local class = require 'middleclass'

local Map = class('Map')
local Tileset = require 'Tileset'

function Map:initialize(id)
	local image = love.image.newImageData("assets/map/map"..id..".png")
	local r,g,b

	self.tileset = Tileset:new()
	self.id = id
	self.h = image:getHeight()
	self.w = image:getWidth()
	self.map = {}
	self.image = {}
	self.image[1] = love.graphics.newImage("assets/fortress1.png")
	self.image[2] = love.graphics.newImage("assets/fortress1.png")
	self.image.x = nil 
	self.image.y = nil 

	for i = 0, self.w-1 do
		self.map[i] = {}

		for j = 0, self.h-1 do
			r,g,b,_ = image:getPixel(i,j)

			if r == 0 and g == 0 and b == 0 then
				self.map[i][j] = 1 --Caillou
			elseif r == 0 and g == 255 and b == 0 then
				self.map[i][j] = 2 --Arbre
			elseif r == 255 and g == 255 and b == 255 then
				self.map[i][j] = 0 --Herbe
			elseif r == 255 and g == 0 and b == 0 then
				self.map[i][j] = 3 --Fortress
			else
				self.map[i][j] = 0
			end
		end
	end

	self.shader1 = love.graphics.newShader[[
extern float night;
extern float r;
extern float player[2];

float distance(vec2 v1, vec2 v2){
	vec2 v3 = v2 - v1;
	return sqrt(v3[0]*v3[0] + v3[1] *v3[1]);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 pixel = Texel(texture, texture_coords);

	vec2 fortress = vec2(64. * 63.4, 64. * 63.5);
	vec2 pixelCoords = vec2(pixel_coords[0] + player[0] - (love_ScreenSize.x/4 - 16), (love_ScreenSize.y - pixel_coords[1]) + player[1] - (love_ScreenSize.y/2 + 40 - 16));
	float dist = distance(fortress, pixelCoords);

	if(dist > r){
		pixel.rgb = vec3(0.,0.,0.);
	}

	if(pixel_coords.x >= love_ScreenSize.x/2){
		pixel.a = 0.;
	}

	if(night > 0){
		pixel.rgb *= vec3(0.2,0.2,0.2);
	}

	return pixel;
}
]]

	self.shader2 = love.graphics.newShader[[
extern float night;
extern float r;
extern float player[2];

float distance(vec2 v1, vec2 v2){
	vec2 v3 = v2 - v1;
	return sqrt(v3[0]*v3[0] + v3[1] *v3[1]);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 pixel = Texel(texture, texture_coords);

	vec2 fortress = vec2(64. * 63.4, 64. * 63.5);
	vec2 pixelCoords = vec2(pixel_coords[0] + player[0] - (love_ScreenSize.x/4*3 - 16), (love_ScreenSize.y - pixel_coords[1]) + player[1] - (love_ScreenSize.y/2 + 40 - 16));
	float dist = distance(fortress, pixelCoords);

	if(dist > r){
		pixel.rgb = vec3(0.,0.,0.);
	}

	if(pixel_coords.x < love_ScreenSize.x/2){
		pixel.a = 0.;
	}

	if(night > 0){
		pixel.rgb *= vec3(0.2,0.2,0.2);
	}

	return pixel;
}
]]

	self.shader1:send("night", 1)
	self.shader2:send("night", 0)
	self.shader1:send("r", 100)
	self.shader2:send("r", 100)
end

function Map:update(dt)
end

function Map:draw()
	local pos = {}
	pos.x = engine.screen.entities[self.id].pos.x
	pos.y = engine.screen.entities[self.id].pos.y

	local size = engine.screen.entities[self.id].size
	local menuH = engine.screen.menuBar.h

	local posTile = {}
	posTile.x = math.floor( (pos.x - math.floor(WINDOW_WIDTH/4)) / Tileset.TILESIZE)
	posTile.y = math.floor( (pos.y - math.floor(WINDOW_HEIGHT/2)) / Tileset.TILESIZE)

	local nbTile = {}
	nbTile.x = math.floor(WINDOW_WIDTH/2 /Tileset.TILESIZE)+3
	nbTile.y = math.floor(WINDOW_HEIGHT /Tileset.TILESIZE)+3

	local decalage = {}
	decalage.x = pos.x % Tileset.TILESIZE
	decalage.y = pos.y % Tileset.TILESIZE


	love.graphics.push()

	if self.id == 1 then
		love.graphics.translate(-pos.x +math.floor(WINDOW_WIDTH/4) - size/2, -pos.y +math.floor(WINDOW_HEIGHT/2) + menuH/2 - size/2)
		love.graphics.setShader(self.shader1)
	else
		love.graphics.translate(-pos.x +math.floor(3*WINDOW_WIDTH/4) - size/2, -pos.y +math.floor(WINDOW_HEIGHT/2) + menuH/2 - size/2)
		love.graphics.setShader(self.shader2)
	end

	for i = 0, nbTile.x do
		for j = 0, nbTile.y do
			if posTile.x + i >= 0 and posTile.y + j >= 0 and posTile.x + i < self.w and posTile.y < self.h then
				if self.map[posTile.x + i][posTile.y + j] ~= 3 then
					self.tileset:drawTile(self.id, self.map[posTile.x + i][posTile.y + j], (posTile.x + i)*Tileset.TILESIZE, (posTile.y + j)*Tileset.TILESIZE)
				else
					self.tileset:drawTile(self.id, 0, (posTile.x + i)*Tileset.TILESIZE, (posTile.y + j)*Tileset.TILESIZE)
					self.image.x = posTile.x + i -2
					self.image.y = posTile.y + j -2
				end
			end
		end
	end

	if self.image.x ~= nil then
		love.graphics.draw(self.image[self.id], self.image.x * Tileset.TILESIZE, self.image.y * Tileset.TILESIZE)
	end

	love.graphics.setColor(0,0,0)
	love.graphics.circle("line", engine.screen.fortress[self.id].pos.x, engine.screen.fortress[self.id].pos.y, engine.screen.fortress[self.id].pos.r)


	love.graphics.setShader()


	love.graphics.pop()

end

return Map
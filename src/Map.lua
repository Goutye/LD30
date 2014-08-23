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
			else
				self.map[i][j] = 0
			end
		end
	end

	self.shader1 = love.graphics.newShader[[
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 pixel = Texel(texture, texture_coords);
	if(pixel_coords.x >= love_ScreenSize.x/2){
		pixel.a = 0.;
	}


	return pixel;
}
]]

	self.shader2 = love.graphics.newShader[[
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 pixel = Texel(texture, texture_coords);
	if(pixel_coords.x < love_ScreenSize.x/2){
		pixel.a = 0.;
	}


	return pixel;
}
]]

end

function Map:update(dt)
end

function Map:draw()
	local pos = {}
	pos.x = engine.screen.entities[self.id].pos.x
	pos.y = engine.screen.entities[self.id].pos.y

	local size = engine.screen.entities[self.id].size

	local posTile = {}
	posTile.x = math.floor( (pos.x - math.floor(WINDOW_WIDTH/4)) / Tileset.TILESIZE)
	posTile.y = math.floor( (pos.y - math.floor(WINDOW_HEIGHT/2)) / Tileset.TILESIZE)

	local nbTile = {}
	nbTile.x = math.floor(WINDOW_WIDTH/2 /Tileset.TILESIZE)+1
	nbTile.y = math.floor(WINDOW_HEIGHT /Tileset.TILESIZE)+1

	local decalage = {}
	decalage.x = pos.x % Tileset.TILESIZE
	decalage.y = pos.y % Tileset.TILESIZE


	love.graphics.push()

	if self.id == 1 then
		love.graphics.translate(-pos.x +math.floor(WINDOW_WIDTH/4) - size/2, -pos.y +math.floor(WINDOW_HEIGHT/2) - size/2)
		love.graphics.setShader(self.shader1)
	else
		love.graphics.translate(-pos.x +math.floor(3*WINDOW_WIDTH/4) - size/2, -pos.y +math.floor(WINDOW_HEIGHT/2) - size/2)
		love.graphics.setShader(self.shader2)
	end

	for i = 0, nbTile.x do
		for j = 0, nbTile.y do
			if posTile.x + i >= 0 and posTile.y + j >= 0 and posTile.x + i < self.w and posTile.y < self.h then
				self.tileset:drawTile(self.id, self.map[posTile.x + i][posTile.y + j], (posTile.x + i)*Tileset.TILESIZE, (posTile.y + j)*Tileset.TILESIZE)
			end
		end
	end

	love.graphics.setShader()


	love.graphics.pop()

end

return Map
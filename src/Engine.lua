local class = require 'middleclass'

local Engine = class('Engine')

function Engine:initialize(screen)
	self.screen = screen
	self.nextScreen = nil

	self.TILESIZE = 64
	self.TIMEFORONEDAY = 24

	self.lights = {}
	self.nbLights = 0.0
	self.canvas = love.graphics.newCanvas()

	self.tileShader = love.graphics.newShader[[
number pxByMeter = 100.0;
extern vec4 posLights[100];
extern number nbLights;
number PI = 3.1415926535897932384626433832795;
extern float cameraX;
extern float cameraY;
extern float night;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	int i;
	vec3 posLight;
	vec3 normal = vec3(0.0, 0.0, 1.0);
	vec3 light;
	vec4 pixel = Texel(texture, texture_coords );
	number power =  60;
	vec3 c = vec3(0.0);
	vec3 col;
	vec3 ambiantLight = vec3(1., 1., 1.);

	//coeff 
	vec3 lightDirection, pixelDirection;
	number lightCosAngle, lightCosOutAngle, diffCos;
	number LIGHT_SOFT_ANGLE = PI/12;
	float shadow;

	if(pixel_coords.y < love_ScreenSize.y - 80 && pixel_coords.x < love_ScreenSize.x/2 && night < 1.5){

		c = ambiantLight;
		if(nbLights > 0.5){
			for(i=0;i<nbLights;i++){
				posLight = vec3(posLights[i][0] - cameraX + love_ScreenSize.x/4 - 16, love_ScreenSize.y - (posLights[i][1] - cameraY + love_ScreenSize.y/2 + 40 - 16), 100.0);
				light = vec3(pixel_coords.x, pixel_coords.y, 0) - posLight;
				lightDirection = normalize(vec3(posLights[i][2]- cameraX, love_ScreenSize.y - posLights[i][3]+ cameraY, 2.0) - posLight);
				lightCosAngle = cos(2*PI);
				lightCosOutAngle = cos(2*PI);
				pixelDirection = normalize(vec3(pixel_coords.x, pixel_coords.y, 2.0) - posLight);
				diffCos = dot(pixelDirection, lightDirection);

				if( i == 0 || i == 3){ 
					col = vec3(1.0,1.0,1.0);
				}else if(i == 1 || i == 4){
					col = vec3(1.0,1.0,1.0);
				}else{
					col = vec3(1.0,1.0,1.0);
				}

	       		c += col * power * (-dot(normal, normalize(light)) / pow(1+ length(light) / pxByMeter , 2));
			}
		}
		if(c.x > 4.){ c = vec3(4.,4.,4.);}
		pixel.rgb *= c;
	}
	if(pixel_coords.y < love_ScreenSize.y - 80 && pixel_coords.x > love_ScreenSize.x/2 && night > 1.5){
		c = ambiantLight;
		if(nbLights > 0.5){
			for(i=0;i<nbLights;i++){
				posLight = vec3(posLights[i][0] - cameraX + love_ScreenSize.x/4*3 - 16, love_ScreenSize.y - (posLights[i][1] - cameraY + love_ScreenSize.y/2 + 40 - 16), 100.0);
				light = vec3(pixel_coords.x, pixel_coords.y, 0) - posLight;
				lightDirection = normalize(vec3(posLights[i][2]- cameraX, love_ScreenSize.y - posLights[i][3]+ cameraY, 2.0) - posLight);
				lightCosAngle = cos(2*PI);
				lightCosOutAngle = cos(2*PI);
				pixelDirection = normalize(vec3(pixel_coords.x, pixel_coords.y, 2.0) - posLight);
				diffCos = dot(pixelDirection, lightDirection);

				if( i == 0 || i == 3){ 
					col = vec3(1.0,1.0,1.0);
				}else if(i == 1 || i == 4){
					col = vec3(1.0,1.0,1.0);
				}else{
					col = vec3(1.0,1.0,1.0);
				}
				if(c.x > 4.){ c = vec3(4.,4.,4.);}
	       		c += col * power * (-dot(normal, normalize(light)) / pow(1+ length(light) / pxByMeter , 2));
			}
		}

		pixel.rgb *= c;
	}
	return pixel;
}
]]
end

function Engine:update(dt)
	if self.nextScreen ~= nil then
		self.screen:onQuit()
		self.screen = self.nextScreen
		self.nextScreen = nil
	end

	self.screen:update(dt)
end

function Engine:draw()
	love.graphics.setCanvas(self.canvas)
	self.screen:draw()
	love.graphics.setCanvas()

	love.graphics.setShader(self.tileShader);
	love.graphics.draw(self.canvas)
	love.graphics.setShader();
end

function Engine:addLight(v)
	table.insert(self.lights, {v.x, v.y, v.x+1, v.y+1})
	self.nbLights = self.nbLights + 1
	self.tileShader:send("posLights", unpack(self.lights))
	self.tileShader:send("nbLights", self.nbLights)
end

--SCREEN

function Engine:screen_setNext(screen)
	self.nextScreen = screen
end

function Engine:screen_getCurrent()
	return self.screen
end

--VECTOR

function Engine:vector_normalize(v)
	local l = self:vector_length(v)
	v.x = v.x / l
	v.y = v.y / l

	return v
end

function Engine:vector_length(v)
	return math.sqrt(v.x * v.x + v.y * v.y)
end

function Engine:vector_of(pos1, pos2)
	local v = {}
	v.x = pos2.x - pos1.x
	v.y = pos2.y - pos1.y
	return v
end

function Engine:vector_rotate(v, angle)
	local r = {}
	r.x = v.x * math.cos(angle) - v.y * math.sin(angle)
	r.y = v.x * math.sin(angle) + v.y * math.cos(angle)
	return r
end

function Engine:vector_copy(v)
	local r = {}
	r.x = v.x
	r.y = v.y
	return r
end

function Engine:vector_getAngle(v)
	local angle = math.acos(v.y)
	if v.x > 0 then
		angle = -angle
	end
	return angle + math.pi
end

--AABB
function Engine:AABB_circle(box, circle, boolReturnPos)
	local pos = {}
	pos.x = circle.pos.x
	pos.y = circle.pos.y

	if pos.x > box.x + box.w - 1 then
		pos.x = box.x + box.w - 1
	elseif pos.x < box.x then
		pos.x = box.x
	end
	if pos.y > box.y + box.h - 1 then
		pos.y = box.y + box.h - 1
	elseif pos.y < box.y then
		pos.y = box.y
	end

	local collision = self:Circle_point(circle, pos)

	if boolReturnPos then
		return collision, pos
	else
		return collision
	end
end

function Engine:AABB_inCircle(box, circle, boolReturnPos)
	local pos = {}
	
	local collision = true
	local pos = {}
	pos[0] = {x = box.x, y = box.y}
	pos[1] = {x = box.x + box.w-1, y = box.y}
	pos[2] = {x = box.x, y = box.y + box.h-1}
	pos[3] = {x = box.x + box.w, y = box.y + box.h}

	for i = 0, 3 do
		collision = collision and self:Circle_point(circle, pos[i])
	end

	if boolReturnPos then
		return collision, pos
	else
		return collision
	end
end

function Engine:AABB_point(box, point)
	return point.x >= box.x and point.x <= box.x + box.w - 1 and 
			point.y >= box.y and point.y <= box.y + box.h - 1 
end

function Engine:AABB_AABB(box1, box2)
	return	box2.x				<= box1.x + box1.w -1
		and box2.x + box2.w -1	>= box1.x 
		and box2.y 				<= box1.y + box1.h -1
		and box2.y + box2.h -1	>= box1.y
end

function Engine:Circle_point(circle, point)
	local v = self:vector_of(circle.pos, point)
	return self:vector_length(v) <= circle.r
end

function Engine:Circle_circle(circle, circle2)
	return self:vector_length(self:vector_of(circle.pos, circle2.pos)) < circle.r + circle2.r
end

return Engine
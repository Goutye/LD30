local class = require 'middleclass'

local IEntity = require 'entity.IEntity'
local Tower = class('Tower', IEntity)

function Tower:initialize(x,y,idWorld)
	self.id = nil
	self.idWorld = idWorld
	self.friendly = true

	self.pos = {}
	self.pos.x = x
	self.pos.y = y
	self.w = 64
	self.h = 64

	self.box = {x = x - self.w/2, y = y-self.h/2, w = self.w, h= self.h}
	self.circle = { pos = {x = x, y = y}, r = 300}

	self.image = love.graphics.newImage("assets/Tower.png")

	self.r = 150
	self.life = 1
	self.lvl = 1

	self.dmg = 1

	self.fire = false
	self.fireTime = 0
	self.fireTimeNext = 1
end

function Tower:update(dt)
	if self.fire then
		self.fireTime = self.fireTime + dt
		if self.fireTime >= self.fireTimeNext then
			self.fire = false
		end
		return
	end
	for i,e in ipairs(engine.screen.entities[self.idWorld]) do
		if i ~= 1 and i ~= self.id and not e.friendly then
			if engine:AABB_circle(e:getBox(), self.circle) then
				e:hit(self.dmg)
				self.fire = true
				break
			end
		end 
	end
end

function Tower:draw()
	love.graphics.setColor(255,255,255)
	if self.idWorld == 1 then
		love.graphics.setShader(engine.screen.map[1].shader1)
	else
		love.graphics.setShader(engine.screen.map[2].shader2)
	end
	love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, 1, 1, self.w/2, self.h/4*3)
	love.graphics.circle("line", self.pos.x, self.pos.y, self.r)
	love.graphics.setShader()
end

function Tower:onQuit()
end

return Tower
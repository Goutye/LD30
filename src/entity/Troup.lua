local class = require 'middleclass'

local IEntity = require 'entity.IEntity'
local Troup = class('Troup', IEntity)

function Troup:initialize(idWorld, x, y, nb)
	self.id = nil
	self.idWorld = idWorld
	self.lvl = nb
	self.friendly = false
	self.exp = nb
	self.life = self.lvl * 20
	self.maxLife = self.life

	self.pos = {x = x, y = y}
	self.w = 64
	self.h = 64

	self.image = love.graphics.newImage("assets/sprites/Group.png")

	self.dir = {}

	local center = {x = engine.screen.fortress[idWorld].pos.x - 92, y = engine.screen.fortress[idWorld].pos.y - 92}
	self.dir.x = center.x - self.pos.x
	self.dir.y = center.y - self.pos.y
	self.dir = engine:vector_normalize(self.dir)

	self.noAttack = false
	self.timeAttack = 1
	self.time = 0
end

function Troup:update(dt)
	if self.noAttack then
		self.time = self.time + dt
		if self.time >= self.timeAttack then
			self.time = 0
			self.noAttack = false
		end
	end

	local box = {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}

	if engine:AABB_AABB(box, engine.screen.entities[self.idWorld][1]:getBox())then
		engine.screen.entities[1][1]:hit(self.lvl)
	end
	if engine:AABB_AABB(box, engine.screen.fortress[self.idWorld].box) then
		if not self.noAttack then
			engine.screen.fortress[self.idWorld]:hit(self.lvl)
			self.noAttack = true
		end
	else
		self.pos.x = self.pos.x + dt * (self.dir.x * 200)
		self.pos.y = self.pos.y + dt * (self.dir.y * 200)
	end
end

function Troup:draw()
	local box = {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}
	if self.idWorld == 1 then
		love.graphics.setShader(engine.screen.map[1].shader1)
	else
		love.graphics.setShader(engine.screen.map[2].shader2)
	end
	
	love.graphics.draw(self.image, self.pos.x, self.pos.y)

	self:drawLifeBar()
	love.graphics.setShader()
end

function Troup:hit(dmg)
	self.life = self.life - dmg
	if self.life <= 0 then
		self.life = 0
		engine.screen:removeEntity(self.idWorld, self.id)
		return true
	end
	return false
end

return Troup
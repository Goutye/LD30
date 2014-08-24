local class = require 'middleclass'

local Tileset = require 'Tileset'
local IEntity = require 'entity.IEntity'
local Bat = class('Bat', IEntity)

function Bat:initialize(x,y,idWorld)
	self.lvl = 1 + math.floor(math.log10(1 + engine.screen.nbEnemyDead))
	self.life = 10 * self.lvl
	self.maxLife = 10 * self.lvl
	self.exp = 2
	self.pos = {}
	self.pos.x = x * Tileset.TILESIZE
	self.pos.y = y * Tileset.TILESIZE
	self.dir = {}
	self.size = 64
	self.w = self.size
	self.h = self.size
	self.id = nil
	self.idWorld = idWorld

	self.image = love.graphics.newImage("assets/sprites/Bat.png")

	local center = {x = engine.screen.fortress[idWorld].pos.x - 92, y = engine.screen.fortress[idWorld].pos.y - 92}
	self.dir.x = center.x - self.pos.x
	self.dir.y = center.y - self.pos.y
	self.dir = engine:vector_normalize(self.dir)

	self.noAttack = false
	self.timeAttack = 1
	self.time = 0
end

function Bat:update(dt)
	if self.noAttack then
		self.time = self.time + dt
		if self.time >= self.timeAttack then
			self.time = 0
			self.noAttack = false
		end
	end

	local box = {x = self.pos.x, y = self.pos.y, w = self.size, h = self.size}

	if engine:AABB_AABB(box, engine.screen.entities[self.idWorld][1]:getBox()) and (engine.screen.menuBar.night == self.idWorld or engine:AABB_AABB(box, engine.screen.fortress[self.idWorld].box)) then
		engine.screen.entities[1][1]:hit(self.lvl)
	end
	if engine:AABB_AABB(box, engine.screen.fortress[self.idWorld].box) then
		if not self.noAttack then
			engine.screen.fortress[self.idWorld]:hit(self.lvl)
			self.noAttack = true
		end
	else
		if engine.screen.menuBar.night == self.idWorld then
			self.pos.x = self.pos.x + dt * (self.dir.x * self.lvl * 200)
			self.pos.y = self.pos.y + dt * (self.dir.y * self.lvl * 200)
		end
	end
end

function Bat:draw()
	local box = {x = self.pos.x, y = self.pos.y, w = self.size, h = self.size}
	if self.idWorld == 1 then
		love.graphics.setShader(engine.screen.map[1].shader1)
	else
		love.graphics.setShader(engine.screen.map[2].shader2)
	end
	if engine.screen.menuBar.night == self.idWorld or engine:AABB_AABB(box, engine.screen.fortress[self.idWorld].box) then
		love.graphics.draw(self.image, self.pos.x, self.pos.y)
		self:drawLifeBar()
	end
	
	love.graphics.setShader()

end

function Bat:hit(dmg)
	self.life = self.life - dmg
	if self.life <= 0 then
		self.life = 0
		engine.screen:removeEntity(self.idWorld, self.id)
		return true
	end
	return false
end

function Bat:onQuit()
end

return Bat
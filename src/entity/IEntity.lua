local class = require 'middleclass'

local IEntity = class('IEntity')

function IEntity:initialize()
	self.id = nil

	self.friendly = false
	self.exp = 1
	self.life = 1
	self.lvl = 1
end

function IEntity:update(dt)
end

function IEntity:draw()
end

function IEntity:drawLifeBar()
	love.graphics.setLineWidth(1)
	love.graphics.setColor(56,56,56)
	love.graphics.rectangle("line", self.pos.x, self.pos.y - 10, self.w, 5)
	love.graphics.setColor(159,36,36)
	love.graphics.rectangle("fill", self.pos.x+1, self.pos.y - 9, (self.w-2) * self.life/self.maxLife, 3)
	love.graphics.setColor(255,255,255)
	love.graphics.printf(self.lvl, self.pos.x - 14, self.pos.y - 13, 14, "center")
end

function IEntity:onQuit()
end

function IEntity:tryMove()
end

function IEntity:giveExp(exp)
	self.exp = self.exp + exp
	if self.exp >= self.expNextLvl then
		self.lvl = self.lvl + 1
		self.life = self.maxLife
		self.exp = self.exp - self.expNextLvl
		self.expNextLvl = self.expNextLvl + math.log(self.expNextLvl)
	end 
end

function IEntity:lootRandom(lvl, idWorld)
	local rand = love.math.random(0,10)

	if rand == 0 then
		engine.screen.entities[idWorld][1].bois = engine.screen.entities[idWorld][1].bois + lvl
	elseif rand == 1 then
		engine.screen.entities[idWorld][1].pierre = engine.screen.entities[idWorld][1].pierre + lvl
	elseif rand == 2 then
		engine.screen.entities[idWorld][1].nourriture = engine.screen.entities[idWorld][1].nourriture + lvl
	end
	print(rand)
end

function IEntity:getBox()
	local box = {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}
	return box
end

IEntity.static.SPEED = 500
IEntity.static.FRICTION = 0.5
return IEntity
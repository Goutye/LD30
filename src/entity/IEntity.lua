local class = require 'middleclass'

local IEntity = class('IEntity')

function IEntity:initialize()
	self.id = nil

	self.exp = 1
	self.life = 1
	self.lvl = 1
end

function IEntity:update(dt)
end

function IEntity:draw()
end

function IEntity:onQuit()
end

function IEntity:tryMove()
end

function IEntity:giveExp(exp)
	self.exp = self.exp + exp
	if self.exp >= self.expNextLvl then
		self.lvl = self.lvl + 1
		self.exp = self.exp - self.expNextLvl
		self.expNextLvl = self.expNextLvl + math.log(self.expNextLvl)
	end 
end

IEntity.static.SPEED = 500
IEntity.static.FRICTION = 0.5
return IEntity
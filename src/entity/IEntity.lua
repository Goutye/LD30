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

IEntity.static.SPEED = 500
IEntity.static.FRICTION = 0.5
return IEntity
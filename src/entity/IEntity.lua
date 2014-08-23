local class = require 'middleclass'

local IEntity = class('IEntity')

function IEntity:initialize()
	self.id = nil

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

IEntity.static.SPEED = 500
IEntity.static.FRICTION = 0.5
return IEntity
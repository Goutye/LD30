local class = require 'middleclass'

local IEntity = require 'entity.IEntity'
local PlayerDark = class('PlayerDark', IEntity)

function PlayerDark:initialize()
	self.life = 1
	self.lvl = 1
	self.size = 64

	self.pos = {}
	self.pos.x = 3200
	self.pos.y = 2400
	self.spd = {}
	self.spd.x = 0
	self.spd.y = 0
end

function PlayerDark:update(dt)
end

function PlayerDark:draw()
	love.graphics.setColor(255,0,255)

	love.graphics.push()
	love.graphics.translate(-self.pos.x +math.floor(3*WINDOW_WIDTH/4) - self.size/2, -self.pos.y +math.floor(WINDOW_HEIGHT/2) - self.size/2)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size, self.size)
	love.graphics.pop()
end

function PlayerDark:onQuit()
end

function PlayerDark:tryMove()
	local x,y = false, false
	local posTile = {}
	posTile.x = math.floor((self.pos.x + self.spd.x) / engine.TILESIZE)
	posTile.y = math.floor((self.pos.y)/ engine.TILESIZE)
	posTile.xm = math.floor((self.pos.x+ self.spd.x + self.size-1) / engine.TILESIZE)
	posTile.ym = math.floor((self.pos.y+  self.size-1) / engine.TILESIZE)

	if posTile.x >= 0 and posTile.xm < engine.screen.map[2].w and
		posTile.y >= 0 and posTile.ym < engine.screen.map[2].h then

		x= engine.screen.map[2].map[posTile.x][posTile.y] == 0 and
			engine.screen.map[2].map[posTile.xm][posTile.y] == 0 and
			engine.screen.map[2].map[posTile.x][posTile.ym] == 0 and
			engine.screen.map[2].map[posTile.xm][posTile.ym] == 0
	end

	posTile.x = math.floor((self.pos.x + self.spd.x) / engine.TILESIZE)
	posTile.y = math.floor((self.pos.y + self.spd.y)/ engine.TILESIZE)
	posTile.xm = math.floor((self.pos.x+ self.spd.x + self.size-1) / engine.TILESIZE)
	posTile.ym = math.floor((self.pos.y + self.spd.y +  self.size-1) / engine.TILESIZE)

	if posTile.x >= 0 and posTile.xm < engine.screen.map[2].w and
		posTile.y >= 0 and posTile.ym < engine.screen.map[2].h then

		y= engine.screen.map[2].map[posTile.x][posTile.y] == 0 and
			engine.screen.map[2].map[posTile.xm][posTile.y] == 0 and
			engine.screen.map[2].map[posTile.x][posTile.ym] == 0 and
			engine.screen.map[2].map[posTile.xm][posTile.ym] == 0
	end

	if not x and not y then
		posTile.x = math.floor((self.pos.x) / engine.TILESIZE)
		posTile.y = math.floor((self.pos.y + self.spd.y)/ engine.TILESIZE)
		posTile.xm = math.floor((self.pos.x + self.size-1) / engine.TILESIZE)
		posTile.ym = math.floor((self.pos.y + self.spd.y +  self.size-1) / engine.TILESIZE)

		if posTile.x >= 0 and posTile.xm < engine.screen.map[2].w and
			posTile.y >= 0 and posTile.ym < engine.screen.map[2].h then

			y= engine.screen.map[2].map[posTile.x][posTile.y] == 0 and
				engine.screen.map[2].map[posTile.xm][posTile.y] == 0 and
				engine.screen.map[2].map[posTile.x][posTile.ym] == 0 and
				engine.screen.map[2].map[posTile.xm][posTile.ym] == 0
		end
	end

	return x,y
end

return PlayerDark
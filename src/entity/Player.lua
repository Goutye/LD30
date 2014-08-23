local class = require 'middleclass'

local IEntity = require 'entity.IEntity'
local Player = class('Player', IEntity)
local PlayerDark = require 'entity.PlayerDark'

function Player:initialize(x,y)
	self.maxLife = 100
	self.life = 100
	self.lvl = 1
	self.size = 32

	self.pos = {}
	self.pos.x = x
	self.pos.y = y
	self.spd = {}
	self.spd.x = 0
	self.spd.y = 0

	self.pierre = 0
	self.bois = 0
	self.nourriture = 0

	self.playerDark = PlayerDark:new(x,y)
end

function Player:update(dt)
	if keyboard:isDown("up") then
		self.spd.y = self.spd.y * IEntity.FRICTION - dt * IEntity.SPEED * (1 - IEntity.FRICTION)
	elseif keyboard:isDown("down") then
		self.spd.y = self.spd.y * IEntity.FRICTION + dt * IEntity.SPEED * (1 - IEntity.FRICTION)
	else
		self.spd.y = self.spd.y * IEntity.FRICTION
	end
	if keyboard:isDown("left") then
		self.spd.x = self.spd.x * IEntity.FRICTION - dt * IEntity.SPEED * (1 - IEntity.FRICTION)
	elseif keyboard:isDown("right") then
		self.spd.x = self.spd.x * IEntity.FRICTION + dt * IEntity.SPEED * (1 - IEntity.FRICTION)
	else
		self.spd.x = self.spd.x * IEntity.FRICTION
	end

	self.playerDark.spd.x = self.spd.x
	self.playerDark.spd.y = self.spd.y

	local boolx,booly = self:tryMove()
	local boolxD, boolyD = self.playerDark:tryMove() 
	if boolx and boolxD then
		self.pos.x = self.pos.x + self.spd.x
		self.playerDark.pos.x = self.pos.x
	elseif booly and boolyD then
		self.pos.y = self.pos.y + self.spd.y
		self.playerDark.pos.y = self.pos.y
		self.spd.x = 0
	else
		self.spd.x = 0
	end
	if booly and boolyD and boolx and boolxD then
		self.pos.y = self.pos.y + self.spd.y
		self.playerDark.pos.y = self.pos.y
	else
		self.spd.y = 0
	end

	engine.screen.map[1].shader1:send("player",self.pos.x,self.pos.y)
	engine.screen.map[2].shader2:send("player",self.pos.x,self.pos.y)
end

function Player:draw()
	love.graphics.setColor(0,0,0)
	local menuH = engine.screen.menuBar.h

	love.graphics.push()
	love.graphics.translate(-self.pos.x +math.floor(WINDOW_WIDTH/4) - self.size/2, -self.pos.y +math.floor(WINDOW_HEIGHT/2) + menuH/2 -self.size/2)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size, self.size)
	love.graphics.pop()
end

function Player:onQuit()
end

function Player:hit(dmg)
	self.life = self.life - dmg
	if self.life <= 0 then
		--TODO ENDSCREEN
	self.life = 0
	end

	self.playerDark.life = self.life
end

function Player:tryMove()
	local x,y = false, false
	local circle = {pos = {x = engine.screen.fortress[1].pos.x, y = engine.screen.fortress[1].pos.y}, r = engine.screen.fortress[1].pos.r}
	local posTile = {}
	posTile.x = math.floor((self.pos.x + self.spd.x) / engine.TILESIZE)
	posTile.y = math.floor((self.pos.y)/ engine.TILESIZE)
	posTile.xm = math.floor((self.pos.x+ self.spd.x + self.size-1) / engine.TILESIZE)
	posTile.ym = math.floor((self.pos.y+  self.size-1) / engine.TILESIZE)

	if posTile.x >= 0 and posTile.xm < engine.screen.map[1].w and
		posTile.y >= 0 and posTile.ym < engine.screen.map[1].h then

		x= engine.screen.map[1].map[posTile.x][posTile.y] == 0 and
			engine.screen.map[1].map[posTile.xm][posTile.y] == 0 and
			engine.screen.map[1].map[posTile.x][posTile.ym] == 0 and
			engine.screen.map[1].map[posTile.xm][posTile.ym] == 0 

		local box = {x = self.pos.x + self.spd.x, y = self.pos.y, w = self.size, h = self.size}
		x = x and engine:AABB_inCircle(box, circle, false)
	end

	posTile.x = math.floor((self.pos.x + self.spd.x) / engine.TILESIZE)
	posTile.y = math.floor((self.pos.y + self.spd.y)/ engine.TILESIZE)
	posTile.xm = math.floor((self.pos.x+ self.spd.x + self.size-1) / engine.TILESIZE)
	posTile.ym = math.floor((self.pos.y + self.spd.y +  self.size-1) / engine.TILESIZE)

	if posTile.x >= 0 and posTile.xm < engine.screen.map[1].w and
		posTile.y >= 0 and posTile.ym < engine.screen.map[1].h then

		y= engine.screen.map[1].map[posTile.x][posTile.y] == 0 and
			engine.screen.map[1].map[posTile.xm][posTile.y] == 0 and
			engine.screen.map[1].map[posTile.x][posTile.ym] == 0 and
			engine.screen.map[1].map[posTile.xm][posTile.ym] == 0

		local box = {x = self.pos.x + self.spd.x, y = self.pos.y + self.spd.y, w = self.size, h = self.size}
		y = y and engine:AABB_inCircle(box, circle, false)
	end

	if not x and not y then
		posTile.x = math.floor((self.pos.x) / engine.TILESIZE)
		posTile.y = math.floor((self.pos.y + self.spd.y)/ engine.TILESIZE)
		posTile.xm = math.floor((self.pos.x + self.size-1) / engine.TILESIZE)
		posTile.ym = math.floor((self.pos.y + self.spd.y +  self.size-1) / engine.TILESIZE)

		if posTile.x >= 0 and posTile.xm < engine.screen.map[1].w and
			posTile.y >= 0 and posTile.ym < engine.screen.map[1].h then

			y= engine.screen.map[1].map[posTile.x][posTile.y] == 0 and
				engine.screen.map[1].map[posTile.xm][posTile.y] == 0 and
				engine.screen.map[1].map[posTile.x][posTile.ym] == 0 and
				engine.screen.map[1].map[posTile.xm][posTile.ym] == 0
		end
		local box = {x = self.pos.x, y = self.pos.y + self.spd.y, w = self.size, h = self.size}
		y = y and engine:AABB_inCircle(box, circle, false)
	end

	return x,y
end

return Player
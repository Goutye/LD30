local class = require 'middleclass'

local IEntity = require 'entity.IEntity'
local PlayerDark = class('PlayerDark', IEntity)

function PlayerDark:initialize(x,y, lvl)
	self.life = 10
	self.lvl = lvl
	self.size = 32
	self.id = 2

	self.exp = 0
	self.expNextLvl = 10

	self.image = {}
	self.image.up = love.graphics.newImage("assets/sprites/player2.png")
	self.image.down = love.graphics.newImage("assets/sprites/player2F.png")
	self.image.left = love.graphics.newImage("assets/sprites/player2L.png")
	self.image.right = love.graphics.newImage("assets/sprites/player2R.png")
	self.image.current = self.image.up

	self.sword = love.graphics.newImage("assets/sprites/hache.png")
	self.swordTime = 0
	self.swordAnimation = false
	self.swordTimeAnimation = 0.25

	self.pos = {}
	self.pos.x = x
	self.pos.y = y
	self.spd = {}
	self.spd.x = 0
	self.spd.y = 0

	self.dir = {}
	self.dir.x = 1
	self.dir.y = 0

	self.pierre = 0
	self.bois = 0
	self.nourriture = 0
end

function PlayerDark:update(dt)
	if self.swordAnimation then
		self.swordTime = self.swordTime + dt
		if self.swordTime >= self.swordTimeAnimation then
			self.swordAnimation = false
			self.swordTime = 0
		end
	end

	if self.dir.x > 0.5 then
		self.image.current = self.image.right
	elseif self.dir.x < -0.5 then
		self.image.current = self.image.left
	elseif self.dir.y > 0.5 then
		self.image.current = self.image.down
	elseif self.dir.y < -0.5 then
		self.image.current = self.image.up
	end
end

function PlayerDark:translate()
	local menuH = engine.screen.menuBar.h
	love.graphics.push()
	love.graphics.translate(-self.pos.x +math.floor(3*WINDOW_WIDTH/4) - self.size/2, -self.pos.y +math.floor(WINDOW_HEIGHT/2) + menuH/2 - self.size/2)
end

function PlayerDark:draw()
	if self.image.current == self.image.down then
		love.graphics.draw(self.image.current, self.pos.x, self.pos.y)
	end

	if self.swordAnimation then
		local angle = engine:vector_getAngle(self.dir)
		love.graphics.draw(self.sword, self.pos.x + self.size/2, self.pos.y + self.size/2, angle, 1, 1, self.sword:getWidth()/2, self.sword:getHeight()-2)
	end

	if self.image.current ~= self.image.down then
		love.graphics.draw(self.image.current, self.pos.x, self.pos.y)
	end
end

function PlayerDark:drawInfo()
	love.graphics.setColor(255,255,255)
	love.graphics.printf("Lvl : ".. self.lvl .."\tExp : " .. math.floor(self.exp).."/"..math.floor(self.expNextLvl), 10 + WINDOW_WIDTH/2 + 50, WINDOW_HEIGHT - 90, WINDOW_WIDTH/2 - 50, "center")
end

function PlayerDark:onQuit()
end

function PlayerDark:tryMove()
	local x,y = false, false
	local circle = {pos = {x = engine.screen.fortress[2].pos.x, y = engine.screen.fortress[2].pos.y}, r = engine.screen.fortress[2].pos.r}
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
		local box = {x = self.pos.x + self.spd.x, y = self.pos.y, w = self.size, h = self.size}
		x = x and engine:AABB_inCircle(box, circle, false)
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

		local box = {x = self.pos.x + self.spd.x, y = self.pos.y + self.spd.y, w = self.size, h = self.size}
		y = y and engine:AABB_inCircle(box, circle, false)
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

			local box = {x = self.pos.x, y = self.pos.y + self.spd.y, w = self.size, h = self.size}
			y = y and engine:AABB_inCircle(box, circle, false)
		end
	end

	return x,y
end

function PlayerDark:getBox()
	local box = {x = self.pos.x, y = self.pos.y, h = self.size, w = self.size}
	return box
end

return PlayerDark
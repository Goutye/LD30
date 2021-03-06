local class = require 'middleclass'

local IEntity = require 'entity.IEntity'
local Player = class('Player', IEntity)
local PlayerDark = require 'entity.PlayerDark'

function Player:initialize(x,y, mode, difficulty)
	self.maxLife = 100 * (3 - difficulty)
	self.life = 100 * (3 - difficulty)
	if mode then
		self.lvl = 3 + 2 * (2-difficulty)
	else
		self.lvl = 1
	end
	self.size = 32
	self.id = 1

	self.difficulty = difficulty

	self.image = {}
	self.image.up = love.graphics.newImage("assets/sprites/player.png")
	self.image.down = love.graphics.newImage("assets/sprites/playerF.png")
	self.image.left = love.graphics.newImage("assets/sprites/playerL.png")
	self.image.right = love.graphics.newImage("assets/sprites/playerR.png")
	self.image.current = self.image.up
	self.sword = love.graphics.newImage("assets/sprites/sword.png")
	
	self.swordTime = 0
	self.swordAnimation = false
	self.swordTimeAnimation = 0.25

	self.exp = 0
	self.expNextLvl = 10

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

	self.playerDark = PlayerDark:new(x,y, self.lvl)

	self.immortal = false
	self.timeImmortal = 1
	self.time = 0

	self.timeWithoutHit = 0
	self.timeMaxHit = 5 * (3 - self.difficulty)

	self.diagonale = false
end

function Player:update(dt)
	self.diagonale = true

	if self.swordAnimation then
		self.swordTime = self.swordTime + dt
		if self.swordTime >= self.swordTimeAnimation then
			self.swordAnimation = false
			self.swordTime = 0
		end
	end

	if self.immortal then
		self.timeWithoutHit = self.timeImmortal
	end

	self.timeWithoutHit = self.timeWithoutHit + dt
	if self.timeWithoutHit > self.timeMaxHit then
		self.timeWithoutHit = 0
		self.life = self.life + 1 * (3-self.difficulty)
		if self.life > self.maxLife then
			self.life = self.maxLife
		end
	end

	if keyboard:isDown("up") or keyboard:isDown("z")  then
		self.spd.y = self.spd.y * IEntity.FRICTION - dt * IEntity.SPEED * (1 - IEntity.FRICTION)
		self.dir.y = -1

	elseif keyboard:isDown("down") or keyboard:isDown("s")  then
		self.spd.y = self.spd.y * IEntity.FRICTION + dt * IEntity.SPEED * (1 - IEntity.FRICTION)
		self.dir.y = 1
	else
		self.diagonale = false
		self.spd.y = self.spd.y * IEntity.FRICTION
	end
	if keyboard:isDown("left") or keyboard:isDown("q") then
		self.spd.x = self.spd.x * IEntity.FRICTION - dt * IEntity.SPEED * (1 - IEntity.FRICTION)
		self.dir.x = -1
	elseif keyboard:isDown("right") or keyboard:isDown("d") then
		self.spd.x = self.spd.x * IEntity.FRICTION + dt * IEntity.SPEED * (1 - IEntity.FRICTION)
		self.dir.x = 1
	else
		self.diagonale = false
		self.spd.x = self.spd.x * IEntity.FRICTION
	end
	self.dir = engine:vector_normalize(self.dir)
	self.playerDark.dir = self.dir

	if self.diagonale then
		self.spd.x = self.spd.x * 1 / math.sqrt(2)
		self.spd.y = self.spd.y * 1 / math.sqrt(2)
	end

	if keyboard:isPressed("space") then
		love.audio.stop(engine.sfx.sword)
		love.audio.play(engine.sfx.sword)

		self.swordAnimation = true
		self.playerDark.swordAnimation = true
		local box = self:getBoxWeapon()
		engine.screen:fight(1, 1, box, self.lvl * 3)
		engine.screen:fight(2, 1, box, self.lvl * 3)
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

	engine.tileShader:send("cameraX", self.pos.x)
	engine.tileShader:send("cameraY", self.pos.y)

	if engine:AABB_AABB(self:getBox(), engine.screen.fortress[1].boxFull) then
		engine.screen.fortress[1].bois = self.bois + engine.screen.fortress[1].bois
		self.bois = 0
		engine.screen.fortress[1].pierre = self.pierre + engine.screen.fortress[1].pierre
		self.pierre = 0
		engine.screen.fortress[1].habitant = self.nourriture + engine.screen.fortress[1].habitant
		self.nourriture = 0
		engine.screen.fortress[2].bois = self.playerDark.bois + engine.screen.fortress[2].bois
		self.playerDark.bois = 0
		engine.screen.fortress[2].pierre = self.playerDark.pierre + engine.screen.fortress[2].pierre
		self.playerDark.pierre = 0
		engine.screen.fortress[2].habitant = self.playerDark.nourriture + engine.screen.fortress[2].habitant
		self.playerDark.nourriture = 0
	end


	if self.immortal then
		self.time = self.time + dt
		if self.time >= self.timeImmortal then
			self.immortal = false
			self.time = 0
		end
	end

	engine.shader1:send("player",self.pos.x,self.pos.y)
	engine.shader2:send("player",self.pos.x,self.pos.y)
end

function Player:translate()
	local menuH = engine.screen.menuBar.h
	love.graphics.push()
	love.graphics.translate(-self.pos.x +math.floor(WINDOW_WIDTH/4) - self.size/2, -self.pos.y +math.floor(WINDOW_HEIGHT/2) + menuH/2 -self.size/2)
end

function Player:draw()
	love.graphics.setColor(255,255,255)
	
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

function Player:drawInfo()
	love.graphics.setColor(255,255,255)
	love.graphics.printf("Lvl : ".. self.lvl .."\tExp : " .. math.floor(self.exp).."/"..math.floor(self.expNextLvl), 10, WINDOW_HEIGHT - 90, WINDOW_WIDTH/2 - 50, "center")
end

function Player:onQuit()
end

function Player:hit(dmg)
	if not self.immortal then
		self.immortal = true
		self.life = self.life - dmg
		if self.life <= 0 then
			engine:screen_setNext(EndScreen:new(engine.screen))
			self.life = 0
			love.audio.play(engine.sfx.death)
		end

		self.playerDark.life = self.life
	end
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

function Player:getBoxWeapon()
	local v = self.dir
	local box = {}
	v.x = v.x * 70
	v.y = v.y * 70

	if v.x < 0 then
		box.x = self.pos.x + v.x
		box.w = -v.x

		if v.y < 0 then
			box.y = self.pos.y + v.y
			box.h = -v.y
		else
			box.y = self.pos.y
			box.h = v.y
		end
	elseif v.x > 0 then
		box.x = self.pos.x
		box.w = v.x
		if v.y < 0 then
			box.y = self.pos.y + v.y
			box.h = -v.y
		else
			box.y = self.pos.y
			box.h = v.y
		end
	end

	if box.h < 4 then
		box.y = box.y -3
		box.h = 20
	end
	if box.w < 4 then
		box.x = box.x - 3
		box.w = 20
	end
	return box
end

function Player:getBox()
	local box = {x = self.pos.x, y = self.pos.y, h = self.size, w = self.size}
	return box
end

return Player
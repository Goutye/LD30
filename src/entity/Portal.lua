local class = require 'middleclass'

local Tileset = require 'Tileset'
local IEntity = require 'entity.IEntity'
local Portal = class('Portal', IEntity)
local Popup = require 'Popup'

function Portal:initialize(idWorld, mode, difficulty)
	self.id = nil
	self.idWorld = idWorld

	self.mode = mode ~= nil

	self.friendly = true
	self.exp = 0
	
	self.maxLife = 500 * (3-difficulty)
	self.life = self.maxLife
	self.lvl = 0

	self.image = love.graphics.newImage("assets/Portal.png")
	self.position = {}
	self.position[0] = {x = 20, y = 20}
	self.position[1] = {x = 20, y = 102}
	self.position[2] = {x = 102, y = 20}
	self.position[3] = {x = 102, y = 102}
	self.pos = {}
	self.w = 64
	self.h = 64

	self:changeLocation()

	self.nbBodyPassed = 0

	if mode ~= nil then
		self.LIMITFORDESTROY = 500 * (1+difficulty)
	else
		self.LIMITFORDESTROY = 150 * (1+difficulty)
	end
	self.sentenceCheck = false
end

function Portal:update(dt)
	if self.nbBodyPassed > self.LIMITFORDESTROY then
		if self.mode then
			engine:screen_setNext(EndScreen:new(engine.screen))
		end

		self.friendly = false
		if not self.sentenceCheck then
			engine.screen:addEntityPassiv(Popup("Hey little dove ! Our troup just said that the portal can be hit!", 5))
			self.sentenceCheck = true
		end
	end
end

function Portal:hit(dmg)
	self.life = self.life - dmg
	if self.life <= 0 then
		self.life = 0

		if not self.mode then
			engine:screen_setNext(EndScreen:new(engine.screen))
		end
	end
end

function Portal:drawInfo()
	love.graphics.printf("Portal : "..self.nbBodyPassed.."/"..self.LIMITFORDESTROY, 10 + (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1), WINDOW_HEIGHT - 30, WINDOW_WIDTH/2 - 50, "center")
end

function Portal:changeLocation()
	local rand = love.math.random(0,3)

	while self.position[rand] == self.pos do
		rand = love.math.random(0,3)
	end

	self.pos.x = self.position[rand].x * Tileset.TILESIZE
	self.pos.y = self.position[rand].y * Tileset.TILESIZE
end

function Portal:draw()
	if self.idWorld == 1 then
		love.graphics.setShader(engine.screen.map[1].shader1)
	else
		love.graphics.setShader(engine.screen.map[2].shader2)
	end
	love.graphics.draw(self.image, self.pos.x, self.pos.y )
	
	if not self.friendly then
		self:drawLifeBar()
	end

	love.graphics.setShader()
end

function Portal:onQuit()
end

return Portal
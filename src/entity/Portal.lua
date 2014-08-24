local class = require 'middleclass'

local Tileset = require 'Tileset'
local IEntity = require 'entity.IEntity'
local Portal = class('Portal', IEntity)
local Popup = require 'Popup'

function Portal:initialize(idWorld)
	self.id = nil
	self.idWorld = idWorld

	self.friendly = true
	self.exp = 0
	self.life = 1000
	self.maxLife = 1000
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
	self.LIMITFORDESTROY = 50
end

function Portal:update(dt)
	if self.nbBodyPassed > self.LIMITFORDESTROY then
		self.friendly = false
	end
end

function Portal:hit(dmg)
	self.life = self.life - dmg
	if self.life <= 0 then
		self.life = 0

		engine:screen_setNext(EndScreen:new(engine.screen))
	end
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
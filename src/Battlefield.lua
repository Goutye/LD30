local class = require 'middleclass'

local Battlefield = class('Battlefield')

local Popup = require 'Popup'
local Troup = require 'entity.Troup'

Battlefield.static.TIMETOATTACK = 1

function Battlefield:initialize(king)
	self.nbSoldiers = {}
	self.nbSoldiers[1] = 0
	self.nbSoldiers[2] = 0

	self.king = {}
	self.king[1] = king[1]
	self.king[2] = king[2]

	self.inFight = false
	self.groupArrival = {}
	self.groupArrival[1] = false
	self.groupArrival[2] = false

	self.penality = {}
	self.penality[1] = 1 --1 = 0%
	self.penality[2] = 1 --1 = 0%

	self.attack = false
	self.attackTime = 0
end

function Battlefield:update(dt)
	if self.inFight then
		if self.nbSoldiers[1] <= 0 then
			self.inFight = false
			engine.screen:addEntityPassiv(Popup:new("LIGHT World losed ! " .. self.nbSoldiers[2] .. " are coming to destroy the light fortress!"))
			--CREATE SOLDIERS IN MAP 1 WITH SOLDIERS 2
			local pos = engine:vector_copy( engine.screen.entities[1][2].pos)
			engine.screen:addEntity(1, Troup:new(1, pos.x, pos.y, self.nbSoldiers[2]) )

			engine.screen.entities[1][2].nbBodyPassed = engine.screen.entities[1][2].nbBodyPassed + self.nbSoldiers[2]
			engine.screen.entities[2][2].nbBodyPassed = engine.screen.entities[2][2].nbBodyPassed + self.nbSoldiers[2]

			self.nbSoldiers[1] = 0
			self.nbSoldiers[2] = 0
			love.audio.play(engine.sfx.troup)
		elseif self.nbSoldiers[2] <= 0 then
			self.inFight = false
			engine.screen:addEntityPassiv(Popup:new("DARK World losed ! " .. self.nbSoldiers[1] .. " are coming to destroy the dark fortress!"))
			--CREATE SOLDIERS IN MAP 2 WITH SOLDIERS 1
			local pos = engine:vector_copy( engine.screen.entities[2][2].pos)
			engine.screen:addEntity(2, Troup:new(2, pos.x, pos.y, self.nbSoldiers[1]) )

			engine.screen.entities[1][2].nbBodyPassed = engine.screen.entities[1][2].nbBodyPassed + self.nbSoldiers[1]
			engine.screen.entities[2][2].nbBodyPassed = engine.screen.entities[2][2].nbBodyPassed + self.nbSoldiers[1]

			self.nbSoldiers[1] = 0
			self.nbSoldiers[2] = 0
			love.audio.play(engine.sfx.troup)
		else
			if self.attack == true then
				self.attack = false
				local dmg1, dmg2 = math.floor(self.nbSoldiers[1]/2 * self.penality[1]), math.floor(self.nbSoldiers[2]/2 * self.penality[2])

				self.nbSoldiers[1] = self.nbSoldiers[1] - dmg2 
				self.nbSoldiers[2] = self.nbSoldiers[2] - dmg1 

				self.penality[1] = 1
				self.penality[2] = 1
			else
				self.attackTime = self.attackTime + dt
				if self.attackTime >= Battlefield.TIMETOATTACK then
					self.attack = true
					self.attackTime = 0
				end
			end
		end
	elseif self.groupArrival[1] and self.groupArrival[2] then
		self.inFight = true
		self.groupArrival[1] = false
		self.groupArrival[2] = false
	elseif self.groupArrival[1] and not self.groupArrival[2] then
		self.inFight = true
		self.nbSoldiers[2], self.penality[2] = self.king[2]:getGroupInTravel()
		self.groupArrival[1] = false
	elseif self.groupArrival[2] and not self.groupArrival[1] then
		self.inFight = true
		self.nbSoldiers[1], self.penality[1] = self.king[1]:getGroupInTravel()
		self.groupArrival[2] = false
	end
end

function Battlefield:putSoldiers(idWorld, nb)
	self.nbSoldiers[idWorld] = self.nbSoldiers[idWorld] + nb

	if not self.inFight then
		self.groupArrival[idWorld] = true
	end
end

function Battlefield:draw()
	if self.inFight then
		love.graphics.setColor(0,0,0,190)
		love.graphics.rectangle("fill", WINDOW_WIDTH/2-50, WINDOW_HEIGHT-100, 50, 100)
		love.graphics.setColor(255,255,255,190)
		love.graphics.rectangle("fill", WINDOW_WIDTH/2, WINDOW_HEIGHT-100, 50, 100)
		love.graphics.setColor(150,10,10)
		love.graphics.rectangle("line", WINDOW_WIDTH/2-50, WINDOW_HEIGHT-100, 100, 100)

		love.graphics.setColor(255,255,255)
		love.graphics.printf(self.nbSoldiers[1], WINDOW_WIDTH/2-40, WINDOW_HEIGHT-70, 30, "center")
		love.graphics.setColor(0,0,0)
		love.graphics.printf(self.nbSoldiers[2], WINDOW_WIDTH/2+10, WINDOW_HEIGHT-70, 30, "center")
	end
end

return Battlefield
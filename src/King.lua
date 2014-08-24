local class = require 'middleclass'

local King = class('King')

local Popup = require 'Popup'

King.static.TIMEENDTRAVEL = 20

function King:initialize(idWorld, fortress)
	self.idWorld = idWorld
	self.fortress = fortress
	self.portalDiscovered = false

	self.day = 0
	self.dayBeforeNextWave = love.math.random(2,4)

	self.inTravel = false
	self.nbSoldiers = 0
	self.timeTravel = 0

	self.menu = false
end

function King:update(dt)
	if self.portalDiscovered then
		if self.inTravel then
			self.day = 0
			self.timeTravel = self.timeTravel + dt

			if self.timeTravel >= King.TIMEENDTRAVEL then
				engine.screen.battlefield:putSoldiers(self.idWorld, self.nbSoldiers)
				self.nbSoldiers = 0
				self.inTravel = false
				self.timeTravel = 0
				self.dayBeforeNextWave = love.math.random(5, 10)
			end
		elseif self.day >= self.dayBeforeNextWave and self.fortress.soldat >= 10 then
			local rand = love.math.random(33, 66)
			self.nbSoldiers = math.floor(self.fortress.soldat * rand/100)
			self.fortress.soldat = self.fortress.soldat - self.nbSoldiers
			self.inTravel = true

			engine.screen:addEntityPassiv(Popup:new("A L'ASSAULT ! " .. self.nbSoldiers .. " are in the road!", 3,self.idWorld))
		end
	
		if keyboard:isPressed("tab") then
			self.menu = not self.menu
		end
	else
		self.day = 0
	end
end

function King:draw()
	if self.menu then
		love.graphics.setColor(56,56,56,180)
		love.graphics.rectangle("fill", (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1), WINDOW_HEIGHT - 100, WINDOW_WIDTH/2 - 50, 100)
		love.graphics.setColor(10,10,10,255)
		love.graphics.rectangle("line", (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1), WINDOW_HEIGHT - 100, WINDOW_WIDTH/2 - 50, 100)

		if self.inTravel then
			love.graphics.setColor(0,0,0)
			love.graphics.line( 50 + (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1), WINDOW_HEIGHT - 50, WINDOW_WIDTH/2 - 100 + (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1), WINDOW_HEIGHT - 50)
			love.graphics.setColor(56,56,56)
			love.graphics.rectangle("fill", 10 + (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1) +(WINDOW_WIDTH/2-50-90) * ((self.idWorld - 1) * (1-self.timeTravel/King.TIMEENDTRAVEL) + (self.idWorld - 2) * -self.timeTravel/King.TIMEENDTRAVEL), WINDOW_HEIGHT - 90, 80, 80)
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("line", 10 + (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1) +(WINDOW_WIDTH/2-50-90) * ((self.idWorld - 1) * (1-self.timeTravel/King.TIMEENDTRAVEL) + (self.idWorld - 2) * -self.timeTravel/King.TIMEENDTRAVEL), WINDOW_HEIGHT - 90, 80, 80)
			love.graphics.setColor(255,255,255)
			love.graphics.printf(self.nbSoldiers, 10 + (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1) +(WINDOW_WIDTH/2-50-90) * ((self.idWorld - 1) * (1-self.timeTravel/King.TIMEENDTRAVEL) + (self.idWorld - 2) * -self.timeTravel/King.TIMEENDTRAVEL), WINDOW_HEIGHT - 70, 80, "center")
		else
			love.graphics.setColor(255,255,255)
			love.graphics.printf("The king thinks about a machiavellian plan...", (WINDOW_WIDTH/2 + 50) * (self.idWorld - 1), WINDOW_HEIGHT - 60, WINDOW_WIDTH/2 - 50, "center")
		end

		love.graphics.setColor(255,255,255)
		--love.graphics.printf(self.day .. "/" .. self.dayBeforeNextWave, 10 + (self.idWorld - 1) * WINDOW_WIDTH/2 ,WINDOW_HEIGHT-50, 50)
	end
end

function King:getGroupInTravel()
	if self.inTravel then
		local nb = self.nbSoldiers
		local penality = self.timeTravel/King.TIMEENDTRAVEL
		self.inTravel = false
		self.nbSoldiers = 0
		self.timeTravel = 0
		self.dayBeforeNextWave = love.math.random(5, 10)
		return nb, penality
	else
		return 0, 0
	end
end

function King:onQuit()
end

return King
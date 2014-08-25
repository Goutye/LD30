local class = require 'middleclass'

local Popup = class('Popup')

Popup.static.TIMEEND = 3

function Popup:initialize(str,time, location, roi)
	self.str = str
	self.time = 0

	if time ~= nil then
		self.maxTime = time
	else
		self.maxTime = Popup.TIMEEND
	end
	self.id = nil
	self.location = location

	self.image = nil

	if roi ~= nil then
		self.image = love.graphics.newImage("assets/sprites/roi"..location..".png")
	end
end

function Popup:update(dt)
	self.time = self.time + dt
	if self.time >= self.maxTime then
		engine.screen:removeEntityPassiv(self.id)
	end
end

function Popup:draw()
	if self.location == 1 or self.location == 2 then
		if self.image ~= nil then
			love.graphics.setColor(255,255,255)
			if self.location == 1 then
				love.graphics.draw(self.image, 0, WINDOW_HEIGHT-100-455)
			else
				love.graphics.draw(self.image, WINDOW_WIDTH-421, WINDOW_HEIGHT-100-470)
			end
		end
		love.graphics.setColor(200,200,200,220)
		love.graphics.rectangle("fill", WINDOW_WIDTH/12 + (WINDOW_WIDTH/2)*(self.location-1), WINDOW_HEIGHT/4*3, WINDOW_WIDTH/3, 100)
		love.graphics.setColor(50,50,50,220)
		love.graphics.rectangle("line", WINDOW_WIDTH/12 + (WINDOW_WIDTH/2)*(self.location-1), WINDOW_HEIGHT/4*3, WINDOW_WIDTH/3, 100)
		love.graphics.setColor(0,0,0)
		love.graphics.printf(self.str, WINDOW_WIDTH/12 + (WINDOW_WIDTH/2)*(self.location-1) + 20, WINDOW_HEIGHT/4*3 + 20, WINDOW_WIDTH/3-40, "center")
	else
		love.graphics.setColor(200,200,200,170)
		love.graphics.rectangle("fill", WINDOW_WIDTH/3, WINDOW_HEIGHT/4*3, WINDOW_WIDTH/3, 100)
		love.graphics.setColor(0,0,0)
		love.graphics.printf(self.str, WINDOW_WIDTH/3 + 20, WINDOW_HEIGHT/4*3 + 20, WINDOW_WIDTH/3-40, "center")
	end
end

function Popup:onQuit()
end

return Popup
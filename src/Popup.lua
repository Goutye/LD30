local class = require 'middleclass'

local Popup = class('Popup')

Popup.static.TIMEEND = 3

function Popup:initialize(str)
	self.str = str
	self.time = 0
	self.id = nil
end

function Popup:update(dt)
	self.time = self.time + dt
	if self.time >= Popup.TIMEEND then
		engine.screen:removeEntityPassiv(self.id)
	end
end

function Popup:draw()
	love.graphics.setColor(200,200,200,170)
	love.graphics.rectangle("fill", WINDOW_WIDTH/3, WINDOW_HEIGHT/4*3, WINDOW_WIDTH/3, 100)
	love.graphics.setColor(0,0,0)
	love.graphics.printf(self.str, WINDOW_WIDTH/3 + 20, WINDOW_HEIGHT/4*3 + 20, WINDOW_WIDTH/3-40, "center")
end

function Popup:onQuit()
end

return Popup
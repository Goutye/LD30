local class = require 'middleclass'

local IScreen = class('IScreen')

function IScreen:initialize()
end

function IScreen:update(dt)
end

function IScreen:draw()
	if keyboard:isDown(" ") or mouse:isDown("l") then
		love.graphics.draw(image, 10,10)
	end
end

function IScreen:onQuit()
end

return IScreen
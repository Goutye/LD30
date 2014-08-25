local class = require 'middleclass'

local Music = class('Music')

function Music:initialize()
	self.menu = love.audio.newSource("assets/music/menu.midi")
end

function Music:update(dt)
end

function Music:draw()
end

function Music:onQuit()
end

return Music
local class = require 'middleclass'

local TitleScreen = class('TitleScreen')

function TitleScreen:initialize()
	self.image = love.graphics.newImage("assets/screen/titlescreen.png")
	self.music = false
end

function TitleScreen:update(dt)
	if not self.music then
		self.music = true
		love.audio.stop()
		love.audio.play(engine.music.menu)
	end

	if mouse:isReleased(1) then
		engine:screen_setNext(MenuScreen:new())
	end
end

function TitleScreen:draw()
	love.graphics.draw(self.image,0,0)

	love.graphics.setColor(0,0,0)
	love.graphics.setFont(engine.font)
	love.graphics.printf("CONNECTED WORLDS - LD30\nA Game made by Goutye", 1280-200, 680, 180, "right")
	love.graphics.setFont(engine.font2)
	engine:printOutLine("  World War\n        of\n\nConnectidia", 500,110)
	love.graphics.setColor(255,255,255)

	love.graphics.setFont(engine.defaut)
end

function TitleScreen:onQuit()
end

return TitleScreen
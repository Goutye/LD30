local class = require 'middleclass'

local StoryScreen = class('StoryScreen')

function StoryScreen:initialize()
	self.sentence = "Connectidia was just a world. Two great kingdoms shared territories.\nThose two kingdoms were Paladins and Emeralds. Each shone in the light of its beliefs.\nPaladins worshipped the light, praising our great King of the purest vision.\nEmeralds worshipped the purity of gems, where this one burst forth into their magic the nobler..\nBut reign after reign, rivalries were never extinguished. And one day, Connectidia broke up."
	self.sentence2 = "You, young soldier, will try to know what happened in these past years.\nDon't forget the words of your king : \n\"Son of my realm. Prove your loyalty and honor my legion by defending my territory.\""

	self.current = self.sentence
end

function StoryScreen:update(dt)
	if mouse:isPressed("l") then
		if self.current ~= self.sentence2 then
			self.current = self.sentence2
		else
			engine:screen_setNext(GameScreen:new())
		end
	end
end

function StoryScreen:draw()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,WINDOW_WIDTH, WINDOW_HEIGHT)
	love.graphics.setColor(155,155,155)
	love.graphics.print(self.current, 40, 40)
end

function StoryScreen:onQuit()
end

return StoryScreen
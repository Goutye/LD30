local class = require 'middleclass'

local StoryScreen = class('StoryScreen')

function StoryScreen:initialize()
	self.sentence = "Connectidia was just a world. Two great kingdoms shared territories. Those two kingdoms were Paladins and Emeralds. Each shone in the light of its beliefs. Paladins worshipped the light, praising our great King of the purest vision. Emeralds worshipped the purity of gems, where this one burst forth into their magic the nobler.. But reign after reign, rivalries were never extinguished. And one day, Connectidia broke up."
	self.sentence2 = "You, young soldier, will try to know what happened in these past years. Don't forget the words of your king : \n\n\"Son of my realm. Prove your loyalty and honor my legion by defending my territory.\""

	self.image = love.graphics.newImage("assets/screen/titlescreen.png")

	self.current = false
end

function StoryScreen:update(dt)
	if mouse:isPressed("l") then
		if not self.current then
			self.current = true
		else
			engine:screen_setNext(ModeScreen:new())
		end
	end
end

function StoryScreen:draw()
	love.graphics.draw(self.image, 0 , 0)
	love.graphics.setColor(0,0,0,150)
	love.graphics.setFont(engine.font4)
	love.graphics.rectangle("fill",0,0,WINDOW_WIDTH, WINDOW_HEIGHT)

	love.graphics.setColor(0,0,0,220)
	love.graphics.rectangle("fill",WINDOW_WIDTH/6 - 10,50,WINDOW_WIDTH/3*2+20, WINDOW_HEIGHT - 100)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("line",WINDOW_WIDTH/6 - 10,50,WINDOW_WIDTH/3*2+20, WINDOW_HEIGHT - 100)

	love.graphics.setColor(155,155,155)
	love.graphics.printf(self.sentence, WINDOW_WIDTH/6, 60, WINDOW_WIDTH/3*2)

	if self.current then
		love.graphics.printf(self.sentence2, WINDOW_WIDTH/6+20, 400, WINDOW_WIDTH/3*2-40)
	end

	love.graphics.setFont(engine.defaut)
	love.graphics.setColor(255,255,255)
end

function StoryScreen:onQuit()
end

return StoryScreen
local class = require 'middleclass'

local MenuScreen = class('MenuScreen')

function MenuScreen:initialize()
	self.button = {x= WINDOW_WIDTH/8*7, y= WINDOW_HEIGHT/6*5, w = 50, h = 50}
	self.image = love.graphics.newImage("assets/screen/howtoplay.png")
	self.tuto = {}
	for i = 1, 5 do
		table.insert(self.tuto, love.graphics.newImage("assets/screen/tutorial"..i..".png"))
	end

	self.tuto[0] = self.image

	self.current = 0
end

function MenuScreen:update(dt)
	if mouse:isReleased("l") or keyboard:isPressed("d") then
		local x,y = mouse:whereReleased("l")
		local pos = {x=x, y=y}

		if(engine:AABB_point(self.button, pos)) then
			engine:screen_setNext(StoryScreen:new())
			love.graphics.setFont(engine.font3)
		else
			self.current = self.current + 1
			if self.current == 6 then
				self.current = 5
				engine:screen_setNext(StoryScreen:new())
			end
		end
	end
	if mouse:isReleased("r") or keyboard:isPressed("a") then
		self.current = self.current - 1
		if self.current < 0 then
			self.current = 0
		end
	end
end

function MenuScreen:draw()
	love.graphics.draw(self.tuto[self.current],0,0)
	love.graphics.setColor(56,56,56)
	love.graphics.rectangle("fill", self.button.x, self.button.y, self.button.w, self.button.h)
	love.graphics.setColor(150,150,150)
	love.graphics.rectangle("line", self.button.x, self.button.y, self.button.w, self.button.h)
	love.graphics.setColor(0,0,0)
	love.graphics.printf("PLAY!", self.button.x + 10, self.button.y + 10, 30, "center")
	love.graphics.setColor(255,255,255)
end

function MenuScreen:onQuit()
end

return MenuScreen
local class = require 'middleclass'

local ModeScreen = class('ModeScreen')

function ModeScreen:initialize()
	self.curseur = love.graphics.newImage("assets/sprites/hache.png")

	self.box = {x = WINDOW_WIDTH/4-100, y = 100, w = WINDOW_WIDTH/4, h = 100}
	self.box2 = {x = WINDOW_WIDTH/2+100, y = 100, w = WINDOW_WIDTH/4, h = 100}
end

function ModeScreen:update(dt)
	if mouse:isPressed("l") then
		local x,y = mouse:wherePressed("l")
		local pos = {x=x,y=y}

		if engine:AABB_point(self.box, pos) then
			--MODE STORY EASY
			engine:screen_setNext(GameScreen:new(0))
		end
		self.box.y = self.box.y + 200
		if engine:AABB_point(self.box, pos) then
			--MODE STORY NORMAL
			engine:screen_setNext(GameScreen:new(1))
		end
		self.box.y = self.box.y + 200
		if engine:AABB_point(self.box, pos) then
			--MODE STORY HARD
			engine:screen_setNext(GameScreen:new(2))
		end

		if engine:AABB_point(self.box2, pos) then
			--MODE LEGION EASY
			engine:screen_setNext(GameScreen:new(0, 1))
		end
		self.box2.y = self.box2.y + 200
		if engine:AABB_point(self.box2, pos) then
			--MODE LEGION NORMAL
			engine:screen_setNext(GameScreen:new(1, 1))
		end
		self.box2.y = self.box2.y + 200
		if engine:AABB_point(self.box2, pos) then
			--MODE LEGION HARD
			engine:screen_setNext(GameScreen:new(2, 1))
		end
		self.box.y = 200
		self.box2.y = 200
	end
end

function ModeScreen:draw()
	local box, box2 = self.box, self.box2
	for i = 0, 2 do
		love.graphics.setColor(150,150,150,150)
		love.graphics.rectangle("fill", box.x, box.y + i * 200, box.w, box.h)
		love.graphics.setColor(56,56,56)
		love.graphics.rectangle("line", box.x, box.y + i * 200, box.w, box.h)
		love.graphics.setColor(150,150,150,150)
		love.graphics.rectangle("fill", box2.x, box2.y + i * 200, box2.w, box2.h)
		love.graphics.setColor(56,56,56)
		love.graphics.rectangle("line", box2.x, box2.y + i * 200, box2.w, box2.h)
	end

	love.graphics.setColor(150,150,150)
	love.graphics.printf("Story Mode", box.x, box.y - 50, box.w, "center")
	love.graphics.printf("Legion Mode", box2.x, box.y - 50, box2.w, "center")

	love.graphics.setColor(0,0,0)
	love.graphics.printf("EASY", box.x, box.y + 50, box.w, "center")
	love.graphics.printf("EASY", box2.x, box.y + 50, box.w, "center")
	love.graphics.printf("NORMAL", box.x, box.y + 50 + 200, box.w, "center")
	love.graphics.printf("NORMAL", box2.x, box.y + 50 + 200, box.w, "center")
	love.graphics.printf("HARD", box.x, box.y + 50 + 400, box.w, "center")
	love.graphics.printf("HARD", box2.x, box.y + 50 + 400, box.w, "center")
end

function ModeScreen:onQuit()
end

return ModeScreen
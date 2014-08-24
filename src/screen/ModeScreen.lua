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
			engine:screen_setNext(GameScreen:new("easy"))
		end
		self.box.y = self.box.y + 200
		if engine:AABB_point(self.box, pos) then
			--MODE STORY NORMAL
			engine:screen_setNext(GameScreen:new("normal"))
		end
		self.box.y = self.box.y + 200
		if engine:AABB_point(self.box, pos) then
			--MODE STORY HARD
			engine:screen_setNext(GameScreen:new("hard"))
		end

		if engine:AABB_point(self.box2, pos) then
			--MODE STORY EASY
			engine:screen_setNext(GameScreen:new("easy"))
		end
		self.box2.y = self.box2.y + 200
		if engine:AABB_point(self.box2, pos) then
			--MODE STORY NORMAL
			engine:screen_setNext(GameScreen:new("normal"))
		end
		self.box2.y = self.box2.y + 200
		if engine:AABB_point(self.box2, pos) then
			--MODE STORY HARD
			engine:screen_setNext(GameScreen:new("hard"))
		end
	end
end

function ModeScreen:draw()
end

function ModeScreen:onQuit()
end

return ModeScreen
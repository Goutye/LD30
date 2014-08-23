local class = require 'middleclass'

local MenuBar = class('MenuBar')

function MenuBar:initialize()
	self.image = love.graphics.newImage("assets/wood.png")
	self.w = 100
	self.h = 80

	self.horloge = love.graphics.newImage("assets/horloge.png")
	self.hour = 5.5
	self.center = {}
	self.center.x = WINDOW_WIDTH/2
	self.center.y = self.w /2
	self.v = {}
	self.v.x = 0
	self.v.y = -40

	self.currentAuto = {}
	self.currentAuto[1] = 0
	self.currentAuto[2] = 0

	self.night = 1
end

function MenuBar:update(dt)
	self.hour = (self.hour + dt) % 24
	self.v.x = 0
	self.v.y = -40
	self.v = engine:vector_rotate(self.v, self.hour/12 *math.pi) -- /24 * 2 => /12

	if self.v.y <= 0 and self.v.x < 0 or self.v.y < 0 and self.v.x >= 0 then
		engine.screen.map[1].shader1:send("night", 1)
		engine.screen.map[2].shader2:send("night", 0)
		local hour = self.hour + 6
		if hour > 12 then
			hour = self.hour - 18
		end
		engine.screen:generateNightMob(1, hour)
		self.night = 1
	else
		engine.screen.map[1].shader1:send("night", 0)
		engine.screen.map[2].shader2:send("night", 1)
		local hour = self.hour - 6
		engine.screen:generateNightMob(2, hour)
		self.night = 2
	end

	if mouse:isPressed("l") then
		local x,y = mouse:wherePressed("l")
		local box = {x = WINDOW_WIDTH/2 -200, y = 40, w = 140, h = 30}
		local pos = {x = x, y = y}
		if engine:AABB_point(box, pos) then
			self.currentAuto[1] = (self.currentAuto[1] + 1) % 4
		end
		box.x = WINDOW_WIDTH-150
		if engine:AABB_point(box, pos) then
			self.currentAuto[2] = (self.currentAuto[2] + 1) % 4
		end
	end
end

function MenuBar:draw()
	for i = 0, math.floor(WINDOW_WIDTH/self.w) do
		love.graphics.draw(self.image, i * self.w, 0)
	end

	love.graphics.draw(self.horloge, WINDOW_WIDTH/2 - self.w/2, 0)

	love.graphics.setColor(255,255,255)
	love.graphics.line(self.center.x, self.center.y, self.center.x + self.v.x, self.center.y + self.v.y)
	love.graphics.setColor(0,0,0)
	love.graphics.line(self.center.x, self.center.y, self.center.x - self.v.x, self.center.y - self.v.y)

	self:drawLifeBar()

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("line", WINDOW_WIDTH/2 -200, 40, 140, 30)
	love.graphics.rectangle("line", WINDOW_WIDTH -150, 40, 140, 30)

	if self.currentAuto[1] == 0 then
		love.graphics.printf("AUTO : Farmer", WINDOW_WIDTH/2 -195, 45, 140)
	elseif self.currentAuto[1] == 1 then
		love.graphics.printf("AUTO : Lumberjack", WINDOW_WIDTH/2 -195, 45, 140)
	elseif self.currentAuto[1] == 2 then
		love.graphics.printf("AUTO : Miner", WINDOW_WIDTH/2 -195, 45, 140)
	else
		love.graphics.printf("No Auto command", WINDOW_WIDTH/2 -195, 45, 140)
	end
	if self.currentAuto[2] == 0 then
		love.graphics.printf("AUTO : Farmer",  WINDOW_WIDTH -145, 45, 140)
	elseif self.currentAuto[2] == 1 then
		love.graphics.printf("AUTO : Lumberjack",  WINDOW_WIDTH -145, 45, 140)
	elseif self.currentAuto[2] == 2 then
		love.graphics.printf("AUTO : Miner",  WINDOW_WIDTH -145, 45, 140)
	else
		love.graphics.printf("No Auto command",  WINDOW_WIDTH -145, 45, 140)
	end
end

function MenuBar:drawLifeBar()
	love.graphics.setLineWidth(3)
	love.graphics.setColor(50,50,50,180)
	love.graphics.rectangle("fill", WINDOW_WIDTH/2 - 12, (WINDOW_HEIGHT-self.w)/6 + self.w + 3, 24, (WINDOW_HEIGHT-self.w)/3*2 - 6)
	love.graphics.setColor(150,150,150)
	love.graphics.rectangle("line", WINDOW_WIDTH/2 - 15, (WINDOW_HEIGHT-self.w)/6 + self.w, 30, (WINDOW_HEIGHT-self.w)/3*2)
	love.graphics.setColor(159,36,36)
	love.graphics.rectangle("fill", WINDOW_WIDTH/2 - 12, (WINDOW_HEIGHT-self.w)/6 + self.w + 3, 24, ((WINDOW_HEIGHT-self.w)/3*2 - 6) * engine.screen.player.life/engine.screen.player.maxLife)
end

function MenuBar:onQuit()
end

return MenuBar
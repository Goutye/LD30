local class = require 'middleclass'

local Fortress = class('Fortress')
local Tileset = require 'Tileset'
local Popup = require 'Popup'

local Mineur = require 'entity.Mineur'
local Bucheron = require 'entity.Bucheron'
local Agriculteur = require 'entity.Agriculteur'
local Soldat = require 'entity.Soldat'

Fortress.static.TIMEEXPANSION = 20

function Fortress:initialize(id)
	self.life = 5000
	self.maxLife = 5000
	self.id = id

	self.image = {}
	self.image.farmer = love.graphics.newImage("assets/icon/farmer.png")
	self.image.limberjack = love.graphics.newImage("assets/icon/limberjack.png")
	self.image.miner = love.graphics.newImage("assets/icon/miner.png")

	self.pos = {}
	self.pos.x = 63.4 * Tileset.TILESIZE
	self.pos.y = 63.5 * Tileset.TILESIZE
	self.pos.r = Tileset.TILESIZE * 6

	self.box = {x = self.pos.x-192/3, y = self.pos.y-192/3, w = 192/3*2, h = 192/3*2}
	self.boxFull = {x = self.pos.x-192/2, y = self.pos.y-192/2, w = 198, h = 198}

	self.soldat = 0
	self.ouvrier = 0
	self.mineur = {}
	self.bucheron = {}
	self.agriculteur = {}

	self.bois = 0
	self.pierre = 0
	self.habitant = 7 -- Player + Le roi + Agriculteur

	self.endSentence = ""
	self.popupSet = false

	--for i = 1,28 do
		--table.insert(self.agriculteur, Agriculteur:new(self))
		--table.insert(self.mineur, Mineur:new(self))
		--table.insert(self.bucheron, Bucheron:new(self))
	--end
	table.insert(self.agriculteur, Agriculteur:new(self))
	table.insert(self.agriculteur, Agriculteur:new(self))
	table.insert(self.agriculteur, Agriculteur:new(self))
	table.insert(self.mineur, Mineur:new(self))
	table.insert(self.bucheron, Bucheron:new(self))
	

	self.timeWithoutExpansion = 0
	self.predHabitant = 0

	self.timeBeforeWorker = 10
	self.timeWorker = 0
end

function Fortress:update(dt)
	self.timeWorker = self.timeWorker + dt
	if self.timeWorker > self.timeBeforeWorker then
		if (self.habitant > self.ouvrier + #self.agriculteur + #self.mineur + #self.bucheron + self.soldat + 2) then 
			if self.ouvrier < 5 then
				self.ouvrier = self.ouvrier + 1
			end
		end
		self.timeWorker = 0
	end


	if mouse:isPressed("l") then
		local x,y = mouse:wherePressed("l")
		local pos = {x = x, y=y}
		local box = {x= 20, y = 20, w = 32, h = 32}

		if self.id == 1 then
			if engine:AABB_point(box, pos) then
				if self.ouvrier > 0 then
					self.ouvrier = self.ouvrier - 1
					table.insert(self.mineur, Mineur:new(self))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end
				if engine.screen.fortress[2].ouvrier > 0 then
					engine.screen.fortress[2].ouvrier = engine.screen.fortress[2].ouvrier - 1
					table.insert(engine.screen.fortress[2].agriculteur, Agriculteur:new(engine.screen.fortress[2]))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end	
			end
			box.x = box.x + 50
			if engine:AABB_point(box, pos) then
				if self.ouvrier > 0 then
					self.ouvrier = self.ouvrier - 1
					table.insert(self.bucheron, Bucheron:new(self))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end
				if engine.screen.fortress[2].ouvrier > 0 then
					engine.screen.fortress[2].ouvrier = engine.screen.fortress[2].ouvrier - 1
					table.insert(engine.screen.fortress[2].mineur, Mineur:new(engine.screen.fortress[2]))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end		
			end
			box.x = box.x + 50
			if engine:AABB_point(box, pos) then
				if self.ouvrier > 0 then
					self.ouvrier = self.ouvrier - 1
					table.insert(self.agriculteur, Agriculteur:new(self))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end
				if engine.screen.fortress[2].ouvrier > 0 then
					engine.screen.fortress[2].ouvrier = engine.screen.fortress[2].ouvrier - 1
					table.insert(engine.screen.fortress[2].bucheron, Bucheron:new(engine.screen.fortress[2]))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end	
			end
		else
			box.x = 20 + WINDOW_WIDTH/2 + 50
			if engine:AABB_point(box, pos) then
				if self.ouvrier > 0 then
					self.ouvrier = self.ouvrier - 1
					table.insert(self.agriculteur, Agriculteur:new(self))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end
				if engine.screen.fortress[1].ouvrier > 0 then
					engine.screen.fortress[1].ouvrier = engine.screen.fortress[1].ouvrier - 1
					table.insert(engine.screen.fortress[1].mineur, Mineur:new(engine.screen.fortress[1]))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end			
			end
			box.x = box.x + 50
			if engine:AABB_point(box, pos) then
				if self.ouvrier > 0 then
					self.ouvrier = self.ouvrier - 1
					table.insert(self.mineur, Mineur:new(self))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end
				if engine.screen.fortress[1].ouvrier > 0 then
					engine.screen.fortress[1].ouvrier = engine.screen.fortress[1].ouvrier - 1
					table.insert(engine.screen.fortress[1].bucheron, Bucheron:new(engine.screen.fortress[1]))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end	
			end
			box.x = box.x + 50
			if engine:AABB_point(box, pos) then
				if self.ouvrier > 0 then
					self.ouvrier = self.ouvrier - 1
					table.insert(self.bucheron, Bucheron:new(self))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end
				if engine.screen.fortress[1].ouvrier > 0 then
					engine.screen.fortress[1].ouvrier = engine.screen.fortress[1].ouvrier - 1
					table.insert(engine.screen.fortress[1].agriculteur, Agriculteur:new(engine.screen.fortress[1]))
				else
					self.endSentence = self.endSentence .. "No available worker!\n"
				end		
			end
		end
		if self.endSentence ~= "" then
			engine.screen:addEntityPassiv(Popup:new(self.endSentence))
			self.endSentence = ""
		end
	end

	for _,e in ipairs(self.mineur) do
		e:update(dt)
	end
	for _,e in ipairs(self.bucheron) do
		e:update(dt)
	end
	for _,e in ipairs(self.agriculteur) do
		e:update(dt)
	end

	if self.ouvrier > 0 and engine.screen.menuBar.currentAuto[self.id] < 3 then
		self.ouvrier = self.ouvrier - 1
		if engine.screen.menuBar.currentAuto[self.id] == 0 then
			table.insert(self.agriculteur, Agriculteur:new(self))
		elseif engine.screen.menuBar.currentAuto[self.id] == 1 then
			table.insert(self.bucheron, Bucheron:new(self))
		elseif engine.screen.menuBar.currentAuto[self.id] == 2 then
			table.insert(self.mineur, Mineur:new(self))
		end
	end

	while self.pierre > 0 and self.bois > 0 and self.soldat < self.habitant - 2 - #self.mineur - #self.bucheron - #self.agriculteur do --Roi + Player
		self.pierre = self.pierre - 1
		self.bois = self.bois - 1
		self.soldat = self.soldat + 1
	end

	--Elargissement
	local r = (5 + (math.sqrt(self.habitant*2) + math.log(self.habitant * 2))/2 ) * Tileset.TILESIZE*3
	if r > self.pos.r then 
		self.pos.r = r
	end
	if self.pos.r > 62*Tileset.TILESIZE and not self.popupSet then
		self.popupSet = true
		engine.screen:addEntityPassiv(Popup:new("Hey slave! We just discovered a Portal! Maybe this is the reason of this attack!", 5, self.id))
		engine.screen.king[self.id].portalDiscovered = true
	end
	


	if self.habitant == self.predHabitant and self.ouvrier == 0 then
		self.timeWithoutExpansion = self.timeWithoutExpansion + dt
		if self.timeWithoutExpansion > Fortress.TIMEEXPANSION then
			self.timeWithoutExpansion = 0
			self.ouvrier = self.ouvrier + 1
			if self.soldat > 0 then
				self.soldat = self.soldat - 1
			end
			self.habitant = self.habitant - 10
		end
	end

	self.predHabitant = self.habitant

	engine.screen.map[self.id].shader1:send("r", self.pos.r)
	engine.screen.map[self.id].shader2:send("r", self.pos.r)
end

function Fortress:draw()
	love.graphics.setColor(255,255,255)
	local x,y = love.mouse:getPosition()
	local mousePos = {x = x, y=y}
	local box1 = {x= 20, y = 20, w = 32, h = 32}
	local box2 = {x= 20+ WINDOW_WIDTH/2 + 50, y = 20, w = 32, h = 32}

	if self.id == 1 then
		love.graphics.printf("Workers : " .. self.ouvrier .. "\tSoldiers : " .. self.soldat .. "\tInhabitants : ".. self.habitant, 150, 34, WINDOW_WIDTH/2-50-150, "center")
		
		love.graphics.setColor(150,150,150)
		for i = 0, 2 do
			if engine:AABB_point(box1, mousePos) or engine:AABB_point(box2, mousePos) then
				love.graphics.setColor(255,255,0)
			else
				love.graphics.setColor(255,255,255)
			end
			box1.x = box1.x + 50
			box2.x = box2.x + 50
			love.graphics.rectangle("fill", 20 + i * 50, 20, 32, 32)
		end
		love.graphics.setColor(255,255,255)

		love.graphics.draw(self.image.miner, 20, 20)
		love.graphics.setColor(30,14,5)
		love.graphics.rectangle("line",18, 18, 36, 36)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(#self.mineur, 20, 55, 32, "center")
		

		love.graphics.draw(self.image.limberjack, 70, 20)
		love.graphics.setColor(30,14,5)
		love.graphics.rectangle("line",18+50, 18, 36, 36)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(#self.bucheron, 70, 55, 32, "center")
		

		love.graphics.draw(self.image.farmer, 120, 20)
		love.graphics.setColor(30,14,5)
		love.graphics.rectangle("line",18+100, 18, 36, 36)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(#self.agriculteur, 120, 55, 32, "center")

		love.graphics.printf("Wood : " .. self.bois .."\tStone : " .. self.pierre, WINDOW_WIDTH/6 + 100, 10, WINDOW_WIDTH/2)
	else
		love.graphics.printf("Workers : " .. self.ouvrier .. "\tSoldiers : " .. self.soldat .. "\tInhabitants : ".. self.habitant, 150 + (WINDOW_WIDTH/2 + 50), 34,  WINDOW_WIDTH/2-50-150, "center")
				love.graphics.setColor(150,150,150)
		for i = 0, 2 do
			if engine:AABB_point(box1, mousePos) or engine:AABB_point(box2, mousePos) then
				love.graphics.setColor(255,255,0)
			else
				love.graphics.setColor(255,255,255)
			end
			box1.x = box1.x + 50
			box2.x = box2.x + 50
			love.graphics.rectangle("fill", WINDOW_WIDTH/2 + 50 + 20 + i * 50, 20, 32, 32)
		end
		love.graphics.setColor(255,255,255)

		love.graphics.draw(self.image.miner, WINDOW_WIDTH/2 + 50 + 70, 20)
		love.graphics.setColor(30,14,5)
		love.graphics.rectangle("line",WINDOW_WIDTH/2 + 50 + 68, 18, 36, 36)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(#self.mineur, WINDOW_WIDTH/2 + 50 + 70, 55, 32, "center")

		love.graphics.draw(self.image.limberjack, WINDOW_WIDTH/2 + 50 + 120, 20)
		love.graphics.setColor(30,14,5)
		love.graphics.rectangle("line",WINDOW_WIDTH/2 + 50 + 68 + 50, 18, 36, 36)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(#self.bucheron, WINDOW_WIDTH/2 + 50 + 120, 55, 32, "center")

		love.graphics.draw(self.image.farmer, WINDOW_WIDTH/2 + 50 + 20, 20)
		love.graphics.setColor(30,14,5)
		love.graphics.rectangle("line",WINDOW_WIDTH/2 + 68, 18, 36, 36)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(#self.agriculteur, WINDOW_WIDTH/2 + 50 + 20, 55, 32, "center")

		love.graphics.printf("Wood : " .. self.bois .."\tStone : " .. self.pierre, WINDOW_WIDTH/2 + 110 + WINDOW_WIDTH/6 + 35, 10, WINDOW_WIDTH/2)
	end

	self:drawLifeBar()
end

function Fortress:drawLifeBar()
	love.graphics.setLineWidth(3)
	love.graphics.setColor(150,150,150)
	love.graphics.rectangle("line",210 + (WINDOW_WIDTH/2 + 50) * (self.id - 1) , 60, WINDOW_WIDTH/4 , 14)
	love.graphics.setColor(50,50,50,180)
	love.graphics.rectangle("fill",213 + (WINDOW_WIDTH/2 + 50) * (self.id - 1), 63, WINDOW_WIDTH/4-6, 8)
	love.graphics.setColor(159,36,36)
	love.graphics.rectangle("fill",213 + (WINDOW_WIDTH/2 + 50) * (self.id - 1), 63, (WINDOW_WIDTH/4-6) * self.life/self.maxLife, 8)

	love.graphics.setColor(255,255,255)
	love.graphics.printf(math.floor(self.life) .. "/" .. self.maxLife, 213 + (WINDOW_WIDTH/2 + 50) * (self.id - 1), 61, WINDOW_WIDTH/4-6, "center")
end

function Fortress:onQuit()
end

function Fortress:hit(dmg)
	self.life = self.life - dmg
	if self.life <= 0 then
		self.life = 0
		engine:screen_setNext(EndScreen:new(engine.screen))
	end
end

return Fortress
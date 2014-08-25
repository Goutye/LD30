local class = require 'middleclass'

local IScreen = require 'screen.IScreen'
local GameScreen = class('GameScreen', IScreen)

local Portal = require 'entity.Portal'
local Fortress = require 'entity.Fortress'
local MenuBar = require 'MenuBar'
local Map = require 'Map'
local Player = require 'entity.Player'
local Menu = require 'Menu'
local King = require 'King'
local Battlefield = require 'Battlefield'

local Bat = require 'entity.Bat'

function GameScreen:initialize(difficulty, mode)
	self.mode = mode ~=nil
	self.difficulty = difficulty

	self.building = {}
	self.entities = {}
	self.entities[1] = {}
	self.entities[2] = {}
	self.entitiesPassiv = {}

	self.fortress = {}
	self.fortress[1] = Fortress:new(1, mode, difficulty)
	self.fortress[2] = Fortress:new(2, mode, difficulty)

	table.insert(self.entities[1], Player:new(self.fortress[1].pos.x, self.fortress[1].pos.y + 200, difficulty))
	self.player = self.entities[1][1]
	self.player.id = 1
	table.insert(self.entities[2], self.player.playerDark)
	self.entities[2][1].id = 1

	--Portal
	table.insert(self.entities[1], Portal:new(1, mode, difficulty))
	self.portal = {}
	self.portal[1] = self.entities[1][2]
	self.portal[1].id = 2
	table.insert(self.entities[2], Portal:new(2, mode, difficulty))
	self.entities[2][2].id = 2
	self.portal[2] = self.entities[2][2]

	--Map

	self.map = {}
	self.map[1] = Map:new(1)
	self.map[2] = Map:new(2)

	self.menuBar = MenuBar:new(mode)

	--King

	self.king = {}
	self.king[1] = King:new(1,self.fortress[1], mode)
	self.king[2] = King:new(2,self.fortress[2], mode)

	self.battlefield = Battlefield:new(self.king)
	--RandomMob

	self.randomNbMob = 0
	self.randomCurrentWorld = 1

	self.menuIsActiv = false
	self.menu = Menu:new()

	self.nbEnemyDead = 0

	--MUSIC
	love.audio.stop()
	love.audio.play(engine.music.start)
	self.portalMusic = false
end

function GameScreen:update(dt)
	--CHEAT
	if mouse:isReleased("r") then
		engine:screen_setNext(EndScreen:new(self))
	end
	if (self.king[1].portalDiscovered or self.king[1].portalDiscovered) and not self.portalMusic then
		self.portalMusic = true
		love.audio.stop(engine.music.start)
		love.audio.play(engine.music.portal)
	end


	if keyboard:isPressed("e") and not self.menuIsActiv then
		self.menuIsActiv = true
		love.audio.stop(engine.sfx.ok)
		love.audio.play(engine.sfx.ok)
	elseif self.menuIsActiv then
		self.menu:update(dt)
	end

	self.menuBar:update(dt)
	self.fortress[1]:update(dt)
	self.fortress[2]:update(dt)

	for i = 1,2 do
		self.king[i]:update(dt)
	end

	self.battlefield:update(dt)

	for _,b in ipairs(self.building) do
		b:update(dt)
	end
	for i = 1,2 do
		for _,e in ipairs(self.entities[i]) do
			e:update(dt)
		end
	end
	for _,p in ipairs(self.entitiesPassiv) do
		p:update(dt)
	end
end

function GameScreen:draw()
	love.graphics.setColor(255,255,255)
	self.map[1]:draw()
	self.map[2]:draw()

	love.graphics.setColor(0,0,0)
	love.graphics.line(WINDOW_WIDTH/2,self.menuBar.w,WINDOW_WIDTH/2,WINDOW_HEIGHT)
	love.graphics.line(0,self.menuBar.h, WINDOW_WIDTH/2-self.menuBar.w/2, self.menuBar.h)
	love.graphics.line(WINDOW_WIDTH/2+self.menuBar.w/2,self.menuBar.h, WINDOW_WIDTH, self.menuBar.h)

	love.graphics.setColor(255,255,255)

	love.graphics.setFont(engine.font7)

	for _,b in ipairs(self.building) do
		b:draw()
	end
	for i = 1,2 do
		self.entities[i][1]:translate()
		for i,e in ipairs(self.entities[i]) do
			if i ~= 1 then
				e:draw()
			end
		end
		self.entities[i][1]:draw()
		love.graphics.pop()
	end

	love.graphics.setColor(255,255,255)
	self.menuBar:draw()
	self.fortress[1]:draw()
	self.fortress[2]:draw()

	if self.menuIsActiv then
		self.menu:draw()
	end

	for i = 1,2 do
		self.king[i]:draw()
	end
	self.battlefield:draw()

	for _,p in ipairs(self.entitiesPassiv) do
		p:draw()
	end


end

function GameScreen:onQuit()
end


function GameScreen:addEntity(idWorld, e)
	table.insert(self.entities[idWorld], e)
	e.id = #self.entities[idWorld]
end

function GameScreen:removeEntity(idWorld, id)
	self.entities[idWorld][id]:onQuit()
	if not self.entities[idWorld][id].friendly then
		self.nbEnemyDead = self.nbEnemyDead + 1
	end
	table.remove(self.entities[idWorld], id)
	
	for i = id, #self.entities[idWorld] do
		self.entities[idWorld][i].id = self.entities[idWorld][i].id - 1
	end	
end

function GameScreen:addEntityPassiv(e)
	table.insert(self.entitiesPassiv, e)
	e.id = #self.entitiesPassiv
end

function GameScreen:removeEntityPassiv(id)
	self.entitiesPassiv[id]:onQuit()
	table.remove(self.entitiesPassiv, id)
	
	for i = id, #self.entitiesPassiv do
		self.entitiesPassiv[i].id = self.entitiesPassiv[i].id - 1
	end	
end

function GameScreen:fight(idWorld, id, box, dmg)
	for i,e in ipairs(self.entities[idWorld]) do
		if i ~= id and not e.friendly then
			local box2 = {x = e.pos.x, y = e.pos.y, w = e.w, h = e.h}
			if engine:AABB_AABB(box, box2) then
				if e:hit(dmg) and id == 1 then --If Dead & player
					self.entities[idWorld][1]:giveExp(e.exp * (3 - self.difficulty) /2)
					self.entities[idWorld][1]:lootRandom(e.lvl, idWorld)
				end
			end
		end
	end
end

function GameScreen:generateNightMob(idWorld, time)
	if idWorld ~= self.randomCurrentWorld then
		self.randomCurrentWorld = idWorld
		self.randomNbMob = 0
	end
	local nbMobMax = 1+ math.log10(self.fortress[idWorld].habitant) * (1+self.difficulty) -- 1 mob par 5 habs
	local nbMob = love.math.random(1, nbMobMax)
	local timeNext = 12/nbMob * self.randomNbMob

	if time > timeNext then
		self.randomNbMob = self.randomNbMob + 1
		local x,y = self:randomCoord()
		self:addEntity(idWorld, Bat:new(x,y,idWorld)) 
	end
end

function GameScreen:randomCoord()
	local x,y = 0,0
	local rand = 0
	local min = -self.map[1].w/2
	local max = self.map[1].w/2

	while rand < 25 and rand > -25 do 
		rand = love.math.random(min, max)
	end
	x = rand + max
	rand = 0

	while rand < 25 and rand > -25 do 
		rand = love.math.random(min, max)
	end
	y = rand + max

	return x,y
end

return GameScreen
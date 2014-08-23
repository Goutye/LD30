local class = require 'middleclass'

local IScreen = require 'screen.IScreen'
local GameScreen = class('GameScreen', IScreen)

local MenuBar = require 'MenuBar'
local Map = require 'Map'
local Player = require 'entity.Player'

function GameScreen:initialize()
	self.building = {}
	self.entities = {}
	self.entitiesPassiv = {}

	table.insert(self.entities, Player:new())
	self.player = self.entities[1]
	self.player.id = 1
	table.insert(self.entities, self.player.playerDark)
	self.entities[2].id = 2

	self.map = {}
	self.map[1] = Map:new(1)
	self.map[2] = Map:new(2)

	self.menuBar = MenuBar:new()
end

function GameScreen:update(dt)
	self.menuBar:update(dt)

	for _,b in ipairs(self.building) do
		b:update(dt)
	end
	for _,e in ipairs(self.entities) do
		e:update(dt)
	end
	for _,p in ipairs(self.entitiesPassiv) do
		p:update(dt)
	end
end

function GameScreen:draw()
	love.graphics.setColor(255,255,255)
	self.map[1]:draw()
	self.map[2]:draw()

	for _,b in ipairs(self.building) do
		b:draw()
	end
	for _,e in ipairs(self.entities) do
		e:draw()
	end
	for _,p in ipairs(self.entitiesPassiv) do
		p:draw()
	end

	love.graphics.setColor(0,0,0)
	love.graphics.line(WINDOW_WIDTH/2,self.menuBar.w,WINDOW_WIDTH/2,WINDOW_HEIGHT)
	love.graphics.line(0,self.menuBar.h, WINDOW_WIDTH/2-self.menuBar.w/2, self.menuBar.h)
	love.graphics.line(WINDOW_WIDTH/2+self.menuBar.w/2,self.menuBar.h, WINDOW_WIDTH, self.menuBar.h)

	love.graphics.setColor(255,255,255)
	self.menuBar:draw()

end

function GameScreen:onQuit()
end


function GameScreen:addEntity(e)
	table.insert(self.entities, e)
	e.id = #self.entities
end

function GameScreen:removeEntity(id)
	self.entities[id]:onQuit()
	table.remove(self.entities, id)
	
	for i = id, #self.entities do
		self.entities[i].id = self.entities[i].id - 1
	end	
end

return GameScreen
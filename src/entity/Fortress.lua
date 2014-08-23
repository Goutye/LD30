local class = require 'middleclass'

local Fortress = class('Fortress')
local Tileset = require 'Tileset'

local Mineur = require 'entity.Mineur'
local Bucheron = require 'entity.Bucheron'
local Agriculteur = require 'entity.Agriculteur'
local Soldat = require 'entity.Soldat'

function Fortress:initialize(id)
	self.life = 1000
	self.maxLife = 20000
	self.id = id

	self.pos = {}
	self.pos.x = 63.4 * Tileset.TILESIZE
	self.pos.y = 63.5 * Tileset.TILESIZE
	self.pos.r = Tileset.TILESIZE * 6

	self.soldat = {}
	self.ouvrier = 0
	self.mineur = {}
	self.bucheron = {}
	self.agriculteur = {}

	self.bois = 0
	self.pierre = 0
	self.habitant = 3 -- Player + Le roi + Agriculteur

	table.insert(self.agriculteur, Agriculteur:new(self))
end

function Fortress:update(dt)
	for _,e in ipairs(self.mineur) do
		e:update(dt)
	end
	for _,e in ipairs(self.bucheron) do
		e:update(dt)
	end
	for _,e in ipairs(self.agriculteur) do
		e:update(dt)
	end

	while self.pierre > 0 and self.bois > 0 and #self.soldat < self.habitant - 2 - #self.mineur - #self.bucheron - #self.agriculteur do --Roi + Player
		self.pierre = self.pierre - 1
		self.bois = self.bois - 1
		table.insert(self.soldat, Soldat:new(self))
	end

	self.pos.r = (5 + math.log(self.habitant * 2)) * Tileset.TILESIZE
	engine.screen.map[self.id].shader1:send("r", self.pos.r)
	engine.screen.map[self.id].shader2:send("r", self.pos.r)
end

function Fortress:draw()
	love.graphics.setColor(255,255,255)

	if self.id == 1 then
		love.graphics.printf("Ouvriers : " .. self.ouvrier .. "\tSoldats : " .. #self.soldat .. "\tHabitants : ".. self.habitant, 10, 10, WINDOW_WIDTH/2)
		love.graphics.printf("Mineurs : " .. #self.mineur .. "\tBucherons : " .. #self.bucheron .. "\tAgriculteurs : ".. #self.agriculteur, 10, 40, WINDOW_WIDTH/2)
		love.graphics.printf("Wood : " .. self.bois .."\tStone : " .. self.pierre, WINDOW_WIDTH/4, 10, WINDOW_WIDTH/2)
	else
		love.graphics.printf("Ouvriers : " .. self.ouvrier .. "\tSoldats : " .. #self.soldat .. "\tHabitants : ".. self.habitant, WINDOW_WIDTH/2 + 60, 10, WINDOW_WIDTH/2)
		love.graphics.printf("Mineurs : " .. #self.mineur .. "\tBucherons : " .. #self.bucheron .. "\tAgriculteurs : ".. #self.agriculteur, WINDOW_WIDTH/2 + 60, 40, WINDOW_WIDTH/2)
		love.graphics.printf("Wood : " .. self.bois .."\tStone : " .. self.pierre, WINDOW_WIDTH/2 + 60 + WINDOW_WIDTH/4, 10, WINDOW_WIDTH/2)
	end
end

function Fortress:onQuit()
end

return Fortress
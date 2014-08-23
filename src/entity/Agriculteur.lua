local class = require 'middleclass'

local Agriculteur = class('Agriculteur')

Agriculteur.static.TIMETOHARVEST = 2

function Agriculteur:initialize(fortress)
	self.lvl = 1
	self.time = 0
	self.totalTime = 0
	self.fortress = fortress
	self.id = nil
end

function Agriculteur:update(dt)
	self.time = self.time + dt
	self.totalTime = self.totalTime + dt
	if self.time > Agriculteur.TIMETOHARVEST / self.lvl then
		self.time = self.time - Agriculteur.TIMETOHARVEST / self.lvl
		self.fortress.habitant = self.fortress.habitant + 1
		if self.fortress.habitant % 10 == 0 then
			self.fortress.ouvrier = self.fortress.ouvrier + 1
		end
	end

	if self.totalTime > engine.TIMEFORONEDAY * 30 then
		--DIED ?
		--TOO OLD SO => TIME TO HARVEST * 2?
	end
end

function Agriculteur:draw()
	--IF I'VE ENOUGH TIME
end

function Agriculteur:onQuit()
end

return Agriculteur
local class = require 'middleclass'

local Bucheron = class('Bucheron')

Bucheron.static.TIMETOHARVEST = 10

function Bucheron:initialize(fortress)
	self.lvl = 1
	self.time = 0
	self.totalTime = 0
	self.fortress = fortress
end

function Bucheron:update(dt)
	self.time = self.time + dt
	self.totalTime = self.totalTime + dt
	if self.time > Bucheron.TIMETOHARVEST then
		self.time = self.time - Bucheron.TIMETOHARVEST
		self.fortress.bois = self.fortress.bois + 1
	end
end

function Bucheron:draw()
	--IF I'VE ENOUGH TIME
end

function Bucheron:onQuit()
end

return Bucheron
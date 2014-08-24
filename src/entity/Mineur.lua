local class = require 'middleclass'

local Mineur = class('Mineur')

Mineur.static.TIMETOHARVEST = 10

function Mineur:initialize(fortress)
	self.lvl = 1
	self.time = 0
	self.totalTime = 0
	self.fortress = fortress
end

function Mineur:update(dt)
	self.time = self.time + dt
	self.totalTime = self.totalTime + dt
	if self.time > Mineur.TIMETOHARVEST then
		self.time = self.time - Mineur.TIMETOHARVEST

		if self.fortress.pierre < 100 then
			self.fortress.pierre = math.floor(self.fortress.pierre + 1)
		end
	end
end

function Mineur:draw()
	--IF I'VE ENOUGH TIME
end

function Mineur:onQuit()
end

return Mineur
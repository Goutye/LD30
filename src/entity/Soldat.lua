local class = require 'middleclass'

local Soldat = class('Soldat')

function Soldat:initialize(fortress)
	self.lvl = 1
	self.time = 0
	self.fortress = fortress
end

function Soldat:update(dt)

end

function Soldat:draw()
	--IF I'VE ENOUGH TIME
end

function Soldat:onQuit()
end

return Soldat
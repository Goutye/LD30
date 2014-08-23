local class = require 'middleclass'

local Tileset = class('Tileset')

Tileset.static.TILESIZE = 64

function Tileset:initialize()
	self.world = {}
	self.world[1] = {}
	self.world[2] = {}

	self.world[1][0] = {tile = love.graphics.newImage("assets/tileset/grass.png"), info = 0}
	self.world[1][1] = {tile = love.graphics.newImage("assets/tileset/roche.png"), info = 1}
	self.world[1][2] = {tile = love.graphics.newImage("assets/tileset/arbre.png"), info = 2}
	
	self.world[2][0] = {tile = love.graphics.newImage("assets/tileset/grass2.png"), info = 0}
	self.world[2][1] = {tile = love.graphics.newImage("assets/tileset/lava.png"), info = 1}
	self.world[2][2] = {tile = love.graphics.newImage("assets/tileset/arbre2.png"), info = 2}
end

function Tileset:drawTile(idWorld, idTile, x, y)
	love.graphics.draw(self.world[idWorld][idTile].tile, x, y)
end

function Tileset:getInfo(idWorld, idTile)
	return self.world[idWorld][idTile].info
end

return Tileset
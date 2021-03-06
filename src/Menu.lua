local class = require 'middleclass'

local Menu = class('Menu')

local Popup = require 'Popup'

local Mineur = require 'entity.Mineur'
local Bucheron = require 'entity.Bucheron'
local Agriculteur = require 'entity.Agriculteur'

local Tower = require 'entity.Tower'
local Canon = require 'entity.Canon'

function Menu:initialize()
	self.choice = {}
	self.choice[0] = {} --ouvrier
	self.choice[0] = 0	--Agri/Mineur/Bucheron
	self.choice[1] = {}
	self.choice[1] = 0	--Type tower ? SI BESOIN
	self.choice[2] = {} --Inventaire :X
	self.choice[2] = 0	--Liste des pierre/bois/nourriture => Si validation => jeter
	self.firstChoice = 0

	self.firstCheck = false

	self.endSentence = ""
end

function Menu:update(dt)
	local fortress1 = engine.screen.fortress[1]
	local fortress2 = engine.screen.fortress[2]
	local player1 = engine.screen.player
	local player2 = engine.screen.player.playerDark

	if keyboard:isPressed("r") then
		love.audio.stop(engine.sfx.ok)
		love.audio.play(engine.sfx.ok)
		if self.firstCheck then
			self.choice[self.firstChoice] = (self.choice[self.firstChoice] - 1) % 3
		else
			self.firstChoice = (self.firstChoice - 1) % 2
		end
	elseif keyboard:isPressed("f") then
		love.audio.stop(engine.sfx.ok)
		love.audio.play(engine.sfx.ok)
		if self.firstCheck then
			self.choice[self.firstChoice] = (self.choice[self.firstChoice] + 1) % 3
		else
			self.firstChoice = (self.firstChoice + 1) % 2
		end
	end
	if keyboard:isPressed("escape") or keyboard:isPressed("backspace") or keyboard:isPressed("3") then
		engine.screen.menuIsActiv = false
		self.firstCheck = false
		love.audio.play(engine.sfx.no)
	elseif keyboard:isPressed("e") then
		love.audio.stop(engine.sfx.ok)
		love.audio.play(engine.sfx.ok)
		if not self.firstCheck then
			self.firstCheck = true
		else
			if self.firstChoice == 0 then
				--Fortress 1
				if self.choice[self.firstChoice] == 0 then
					if fortress1.pierre >= 5 and fortress1.bois >=10 then
						engine.screen:addEntity(1, Tower:new(player1.pos.x, player1.pos.y, 1, 1))
						fortress1.pierre = fortress1.pierre - 5
						fortress1.bois = fortress1.bois - 10
					else
						self.endSentence = self.endSentence .. "Price : 5 stones & 10 woods!\n"
					end
				elseif self.choice[self.firstChoice] == 1 then
					if fortress1.pierre >=20 and fortress1.bois >=15 then
						engine.screen:addEntity(1, Tower:new(player1.pos.x, player1.pos.y, 1, 2))
						fortress1.pierre = fortress1.pierre - 20
						fortress1.bois = fortress1.bois - 15
					else
						self.endSentence = self.endSentence .. "Price : 20 stones & 15 woods!\n"
					end
				else
					if fortress1.pierre >=60 and fortress1.bois >=30 then
						engine.screen:addEntity(1, Tower:new(player1.pos.x, player1.pos.y, 1, 3))
						fortress1.pierre = fortress1.pierre - 60
						fortress1.bois = fortress1.bois - 30
					else
						self.endSentence = self.endSentence .. "Price : 60 stones & 30 woods!\n"
					end
				end
				--Fortress 2
				if self.choice[self.firstChoice] == 0 then
					fortress2.bois = math.floor(fortress2.bois/2)
					self.endSentence = self.endSentence .. "Farewell, woods!\n"
				elseif self.choice[self.firstChoice] == 1 then
					fortress2.ouvrier = 0
					self.endSentence = self.endSentence .. "Farewell, free workers!\n"
				else
					fortress2.pierre = math.floor(fortress2.pierre/2)
					self.endSentence = self.endSentence .. "Farewell, stones!\n"
				end
				
		--CHOIX INVENTAIRE
			else
				--Fortress 1
				if self.choice[self.firstChoice] == 0 then
					fortress1.bois = math.floor(fortress1.bois /2)
					self.endSentence = self.endSentence .. "Farewell, woods!\n"
				elseif self.choice[self.firstChoice] == 1 then
					fortress1.ouvrier = 0
					self.endSentence = self.endSentence .. "Farewell, free workers!\n"
				else
					fortress1.pierre = math.floor(fortress1.pierre /2)
					self.endSentence = self.endSentence .. "Farewell, stones!\n"
				end
				--Fortress 2
				if self.choice[self.firstChoice] == 0 then
					if fortress2.pierre >= 10 and fortress2.bois >=5 then 
						engine.screen:addEntity(2, Canon:new(player1.pos.x, player1.pos.y, 2, 1))
						fortress2.pierre = fortress2.pierre - 10
						fortress2.bois = fortress2.bois - 5
					else
						self.endSentence = self.endSentence .. "Price : 10 stones & 5 woods!\n"
					end
				elseif self.choice[self.firstChoice] == 1 then
					if fortress2.pierre >= 15 and fortress2.bois >=20 then 
						engine.screen:addEntity(2, Canon:new(player1.pos.x, player1.pos.y, 2, 2))
						fortress2.pierre = fortress2.pierre - 15
						fortress2.bois = fortress2.bois - 20
					else
						self.endSentence = self.endSentence .. "Price : 15 stones & 20 woods!\n"
					end
				else
					if fortress2.pierre >= 50 and fortress2.bois >=40 then 
						engine.screen:addEntity(2, Canon:new(player1.pos.x, player1.pos.y, 2, 3))
						fortress2.pierre = fortress2.pierre - 50
						fortress2.bois = fortress2.bois - 40
					else
						self.endSentence = self.endSentence .. "Price : 50 stones & 40 woods!\n"
					end
				end
			end
			engine.screen.menuIsActiv = false
			self.firstCheck = false
			if self.endSentence ~= "" then
				engine.screen:addEntityPassiv(Popup:new(self.endSentence))
				self.endSentence = ""
			end
		end
	end
end

function Menu:draw()
	love.graphics.setColor(60,60,60)
	love.graphics.rectangle("fill", 10, WINDOW_HEIGHT/3*2, 100, 120)
	love.graphics.rectangle("fill", WINDOW_WIDTH - 110, WINDOW_HEIGHT/3*2, 100, 120)

	if self.firstCheck then
		love.graphics.rectangle("fill", 115, WINDOW_HEIGHT/3*2 + 10, 200, 180)
		love.graphics.rectangle("fill", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 10, 200, 180)

		--curseur
		love.graphics.setColor(100,100,100)
		love.graphics.rectangle("fill", 115, WINDOW_HEIGHT/3*2 + 10 + 60*self.choice[self.firstChoice], 200, 60)
		love.graphics.rectangle("fill", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 10 + 60*self.choice[self.firstChoice], 200, 60)

		love.graphics.setColor(0,0,0)
		if self.firstChoice == 0 then
			love.graphics.printf("Tower 1 dmg - Stn 5 Wd 10", 115, WINDOW_HEIGHT/3*2 + 30, 200, "center")
			love.graphics.printf("Tower 2 dmg - Stn 20 Wd 15", 115, WINDOW_HEIGHT/3*2 + 90, 200, "center")
			love.graphics.printf("Tower 3 dmg - Stn 60 Wd 30", 115, WINDOW_HEIGHT/3*2 + 150, 200, "center")

			love.graphics.printf("Throw wood?", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 30, 200, "center")
			love.graphics.printf("Throw workers?", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 90, 200, "center")
			love.graphics.printf("Throw stone?", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 150, 200, "center")
		else
			love.graphics.printf("Throw wood?", 115, WINDOW_HEIGHT/3*2 + 30, 200, "center")
			love.graphics.printf("Throw workers?", 115, WINDOW_HEIGHT/3*2 + 90, 200, "center")
			love.graphics.printf("Throw stone?", 115, WINDOW_HEIGHT/3*2 + 150, 200, "center")

			love.graphics.printf("Cannon 1 dmg - Stn 10 Wd 5", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 30, 100, "center")
			love.graphics.printf("Cannon 2 dmg - Stn 15 Wd 20", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 90, 100, "center")
			love.graphics.printf("Cannon 3 dmg - Stn 50 Wd 40", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 150, 100, "center")			
			
		end
	end

	--curseur
	love.graphics.setColor(100,100,100)
	love.graphics.rectangle("fill", 10, WINDOW_HEIGHT/3*2 + 60*self.firstChoice, 100, 60)
	love.graphics.rectangle("fill", WINDOW_WIDTH - 110, WINDOW_HEIGHT/3*2 + 60*self.firstChoice, 100, 60)

	love.graphics.setColor(0,0,0)
	love.graphics.printf("Tower", 10, WINDOW_HEIGHT/3*2 + 20, 100, "center")
	love.graphics.printf("Ressource", 10, WINDOW_HEIGHT/3*2 + 80, 100, "center")
	love.graphics.printf("Ressource", WINDOW_WIDTH-110, WINDOW_HEIGHT/3*2 + 20, 100, "center")
	love.graphics.printf("Cannon", WINDOW_WIDTH-110, WINDOW_HEIGHT/3*2 + 80, 100, "center")
end

function Menu:onQuit()
end

return Menu
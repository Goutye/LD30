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
		if self.firstCheck then
			self.choice[self.firstChoice] = (self.choice[self.firstChoice] - 1) % 3
		else
			self.firstChoice = (self.firstChoice - 1) % 3
		end
	elseif keyboard:isPressed("f") then
		if self.firstCheck then
			self.choice[self.firstChoice] = (self.choice[self.firstChoice] + 1) % 3
		else
			self.firstChoice = (self.firstChoice + 1) % 3
		end
	end
	if keyboard:isPressed("escape") or keyboard:isPressed("backspace") then
		engine.screen.menuIsActiv = false
	elseif keyboard:isPressed("return") then
		if not self.firstCheck then
			self.firstCheck = true
		else
			if self.firstChoice == 0 then
				--Fortress 1
				if self.choice[self.firstChoice] == 0 then
					if fortress1.ouvrier > 0 then
						fortress1.ouvrier = fortress1.ouvrier - 1
						table.insert(fortress1.agriculteur, Agriculteur:new(fortress1))
					else
						self.endSentence = self.endSentence .. "No available worker!\n"
					end
				elseif self.choice[self.firstChoice] == 1 then
					if fortress1.ouvrier > 0 then
						fortress1.ouvrier = fortress1.ouvrier - 1
						table.insert(fortress1.bucheron, Bucheron:new(fortress1))
					else
						self.endSentence = self.endSentence .. "No available worker!\n"
					end
				else
					if fortress1.ouvrier > 0 then
						fortress1.ouvrier = fortress1.ouvrier - 1
						table.insert(fortress1.mineur, Mineur:new(fortress1))
					else
						self.endSentence = self.endSentence .. "No available worker!\n"
					end
				end
				--Fortress 2
				if self.choice[self.firstChoice] == 0 then
					player2.bois = 0
					self.endSentence = self.endSentence .. "Farewell, woods!\n"
				elseif self.choice[self.firstChoice] == 1 then
					player2.nourriture = 0
					self.endSentence = self.endSentence .. "Farewell, meat!\n"
				else
					player2.pierre = 0
					self.endSentence = self.endSentence .. "Farewell, stones!\n"
				end
		--CHOIX TOWER
			elseif self.firstChoice == 1 then
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
		--CHOIX INVENTAIRE
			else
				--Fortress 1
				if self.choice[self.firstChoice] == 0 then
					player1.bois = 0
					self.endSentence = self.endSentence .. "Farewell, woods!\n"
				elseif self.choice[self.firstChoice] == 1 then
					player1.nourriture = 0
					self.endSentence = self.endSentence .. "Farewell, meat!\n"
				else
					player1.pierre = 0
					self.endSentence = self.endSentence .. "Farewell, stones!\n"
				end
				--Fortress 2
				if self.choice[self.firstChoice] == 0 then
					if fortress2.ouvrier > 0 then
						fortress2.ouvrier = fortress2.ouvrier - 1
						table.insert(fortress2.agriculteur, Agriculteur:new(fortress2))
					else
						self.endSentence = self.endSentence .. "No available worker!\n"
					end
				elseif self.choice[self.firstChoice] == 1 then
					if fortress2.ouvrier > 0 then
						fortress2.ouvrier = fortress2.ouvrier - 1
						table.insert(fortress2.bucheron, Bucheron:new(fortress2))
					else
						self.endSentence = self.endSentence .. "No available worker!\n"
					end
				else
					if fortress2.ouvrier > 0 then
						fortress2.ouvrier = fortress2.ouvrier - 1
						table.insert(fortress2.mineur, Mineur:new(fortress2))
					else
						self.endSentence = self.endSentence .. "No available worker!\n"
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
	love.graphics.rectangle("fill", 10, WINDOW_HEIGHT/3*2, 100, 180)
	love.graphics.rectangle("fill", WINDOW_WIDTH - 110, WINDOW_HEIGHT/3*2, 100, 180)

	if self.firstCheck then
		love.graphics.rectangle("fill", 115, WINDOW_HEIGHT/3*2 + 10, 100, 180)
		love.graphics.rectangle("fill", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 10, 100, 180)

		--curseur
		love.graphics.setColor(100,100,100)
		love.graphics.rectangle("fill", 115, WINDOW_HEIGHT/3*2 + 10 + 60*self.choice[self.firstChoice], 100, 60)
		love.graphics.rectangle("fill", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 10 + 60*self.choice[self.firstChoice], 100, 60)

		love.graphics.setColor(0,0,0)
		if self.firstChoice == 0 then
			love.graphics.printf("New Farmer", 115, WINDOW_HEIGHT/3*2 + 30, 100, "center")
			love.graphics.printf("New Lumberjack", 115, WINDOW_HEIGHT/3*2 + 90, 100, "center")
			love.graphics.printf("New Miner", 115, WINDOW_HEIGHT/3*2 + 150, 100, "center")

			love.graphics.printf("Throw wood?", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 30, 100, "center")
			love.graphics.printf("Throw meat?", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 90, 100, "center")
			love.graphics.printf("Throw stone?", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 150, 100, "center")
		elseif self.firstChoice == 1 then
			love.graphics.printf("Tower 1 dmg", 115, WINDOW_HEIGHT/3*2 + 30, 100, "center")
			love.graphics.printf("Tower 2 dmg", 115, WINDOW_HEIGHT/3*2 + 90, 100, "center")
			love.graphics.printf("Tower 3 dmg", 115, WINDOW_HEIGHT/3*2 + 150, 100, "center")

			love.graphics.printf("Cannon 1 dmg", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 30, 100, "center")
			love.graphics.printf("Cannon 2 dmg", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 90, 100, "center")
			love.graphics.printf("Cannon 3 dmg", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 150, 100, "center")			
		else
			love.graphics.printf("Throw wood?", 115, WINDOW_HEIGHT/3*2 + 30, 100, "center")
			love.graphics.printf("Throw meat?", 115, WINDOW_HEIGHT/3*2 + 90, 100, "center")
			love.graphics.printf("Throw stone?", 115, WINDOW_HEIGHT/3*2 + 150, 100, "center")
			love.graphics.printf("New Farmer", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 30, 100, "center")
			love.graphics.printf("New Lumberjack", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 90, 100, "center")
			love.graphics.printf("New Miner", WINDOW_WIDTH - 215, WINDOW_HEIGHT/3*2 + 150, 100, "center")
			
		end
	end

	--curseur
	love.graphics.setColor(100,100,100)
	love.graphics.rectangle("fill", 10, WINDOW_HEIGHT/3*2 + 60*self.firstChoice, 100, 60)
	love.graphics.rectangle("fill", WINDOW_WIDTH - 110, WINDOW_HEIGHT/3*2 + 60*self.firstChoice, 100, 60)

	love.graphics.setColor(0,0,0)
	love.graphics.printf("Workers", 10, WINDOW_HEIGHT/3*2 + 20, 100, "center")
	love.graphics.printf("Tower", 10, WINDOW_HEIGHT/3*2 + 80, 100, "center")
	love.graphics.printf("Inventory", 10, WINDOW_HEIGHT/3*2 + 140, 100, "center")
	love.graphics.printf("Inventory", WINDOW_WIDTH-110, WINDOW_HEIGHT/3*2 + 20, 100, "center")
	love.graphics.printf("Cannon", WINDOW_WIDTH-110, WINDOW_HEIGHT/3*2 + 80, 100, "center")
	love.graphics.printf("Workers", WINDOW_WIDTH-110, WINDOW_HEIGHT/3*2 + 140, 100, "center")
end

function Menu:onQuit()
end

return Menu
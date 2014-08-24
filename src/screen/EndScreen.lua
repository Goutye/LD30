local class = require 'middleclass'

local EndScreen = class('EndScreen')

function EndScreen:initialize(GS)
	self.GS = GS
	self.win = true
	self.sentence = "Because you're too powerful!"

	if self.GS.fortress[1].life <= 0 or self.GS.fortress[2].life <= 0 then
		self.sentence = "Poor little fortress.."
	end
	if self.GS.player.life <= 0 then
		self.sentence = "YOU DIED... Bats got you ?"
	end

	self.flag = {}
	self.flag.bat = GS.nbEnemyDead > 0
	self.flag.king = GS.king[1].portalDiscovered or GS.king[2].portalDiscovered
	self.flag.portal = not GS.entities[1][2].friendly or not GS.entities[2][2].friendly
	self.flag.win = GS.entities[1][2].life <= 0 or GS.entities[2][2].life <= 0

	self.bat = love.graphics.newImage("assets/sprites/Bat.png")
	self.troup = love.graphics.newImage("assets/sprites/Group.png")
	self.fortress = love.graphics.newImage("assets/fortress1.png")
end

function EndScreen:update(dt)
	if mouse:isReleased("l") then
		engine:screen_setNext(TitleScreen:new())
	end
end

function EndScreen:draw()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0,0,WINDOW_WIDTH, WINDOW_HEIGHT)

	love.graphics.setColor(255,255,255)
	love.graphics.print(self.sentence,200,40)
	love.graphics.print("You killed your first Bat :", 20, 80)
	love.graphics.print("The kings talked to you :",20, 110)
	love.graphics.print("The portal can be hit : ", 20, 140)
	love.graphics.print("You destroy the portal :", 20, 170)

	
	if self.flag.bat then
		love.graphics.setColor(78, 174, 68)
		love.graphics.print("[OK]", 250, 80)
	else
		love.graphics.setColor(155, 10 ,10)
		love.graphics.print("[FAILED]", 250, 80)
	end
	if self.flag.king then
		love.graphics.setColor(78, 174, 68)
		love.graphics.print("[OK]", 250, 110)
	else
		love.graphics.setColor(155, 10 ,10)
		love.graphics.print("[FAILED]", 250, 110)
	end
	if self.flag.portal then
		love.graphics.setColor(78, 174, 68)
		love.graphics.print("[OK]", 250, 140)
	else
		love.graphics.setColor(155, 10 ,10)
		love.graphics.print("[FAILED]", 250, 140)
	end
	if self.flag.win then
		love.graphics.setColor(78, 174, 68)
		love.graphics.print("[OK]", 250, 170)
	else
		love.graphics.setColor(155, 10 ,10)
		love.graphics.print("[FAILED]", 250, 170)
	end

	love.graphics.setColor(255,255,255)
	--PLAYER
	local p = self.GS.player
	love.graphics.draw(self.GS.player.image.down, 20, 250)
	love.graphics.draw(self.GS.player.playerDark.image.down, 300, 250)
	love.graphics.print("LvL : "..p.lvl.."\nLife : ".. p.life, 70, 255)
	love.graphics.print("LvL : "..p.playerDark.lvl.."\nLife : ".. p.playerDark.life, 200, 255)

	--Monster
	love.graphics.draw(self.bat, 20, 300)
	love.graphics.print("Number of Kill : " .. self.GS.nbEnemyDead .."\nLvL Bat : " ..  math.floor(1+math.log10(1+self.GS.nbEnemyDead)), 100, 310)

	love.graphics.draw(self.troup, 20, 380)
	love.graphics.print("Bodies passed the portal : " .. self.GS.entities[1][2].nbBodyPassed, 100, 390)

	--Fortress
	local f1, f2 = self.GS.fortress[1], self.GS.fortress[2]
	love.graphics.draw(self.fortress, 20, 480)
	love.graphics.print("Farmer :     \t" .. #f1.agriculteur .. "\t" .. #f2.agriculteur, 260, 490)
	love.graphics.print("Lumberjack : \t" .. #f1.bucheron .. "\t" .. #f2.bucheron, 260, 510)
	love.graphics.print("Miner :      \t" .. #f1.mineur .. "\t" .. #f2.mineur, 260, 530)
	love.graphics.print("Inhabitants :\t".. f1.habitant .. "\t" .. f2.habitant, 500, 490)
	love.graphics.print("Stone :      \t".. f1.pierre .. "\t" .. f2.pierre, 500, 510)
	love.graphics.print("Wood :       \t".. f1.bois .. "\t" .. f2.bois, 500, 530)

	love.graphics.setColor(255,255,255)
end

function EndScreen:onQuit()
end

return EndScreen
package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'

local Mouse = require 'Mouse'
local Keyboard = require 'Keyboard'
local Engine = require 'Engine'
local GameScreen = require 'screen.GameScreen'

screen = nil
nextScreen = nil
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
keyboard = Keyboard:new()
mouse = Mouse:new()
engine = nil

love.window.setTitle("LD30")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
love.graphics.setBackgroundColor(180, 230, 255)

image = love.graphics.newImage("assets/sprites/player.png")

function love.load()
	engine = Engine:new(GameScreen:new())
end

function love.update(dt)
	engine:update(dt)

	mouse:reset()
	keyboard:reset()
end

function love.draw()
	engine:draw()
	love.graphics.print("FPS : "..love.timer.getFPS(), 10, 10)
end

function love.keypressed(key)
	keyboard:keyPressed(key)
end

function love.keyreleased(key)
	keyboard:keyReleased(key)
end

function love.mousepressed(x, y, button)
    mouse:buttonPressed(x,y,button)
end

function love.mousereleased(x, y, button)
    mouse:buttonReleased(x,y,button)
end
-- This is the main.lua file --
local sti = require "sti" 

function love.load()
	love.window.setTitle("Ares - The Mars Terraforming Game")
	love.window.setMode( 640, 640, {resizable=true, minwidth=640, minheight=640})
	map = sti("maps/samplemap.lua")

	layer = map:addCustomLayer("Building", 2)

	layer.building = {
		image = love.graphics.newImage("maps/items/faucet.png"),
		x = 32 * 3,
		y = 32 * 3,
		ox = 0,
		oy = 0
	}

	layer.draw = function(self)
		love.graphics.draw(
			self.building.image,
			math.floor(self.building.x),
			math.floor(self.building.y),
			0,
			1,
			1,
			self.building.ox,
			self.building.oy)
	end

end

function love.keypressed( key )
	if key == "w" or key == "up" then
		layer.building.y = layer.building.y - 32
	end

	if key == "s" or key == "down" then
		layer.building.y = layer.building.y + 32
	end

	if key == "a" or key == "left" then
		layer.building.x = layer.building.x - 32
	end

	if key == "d" or key == "right" then
		layer.building.x = layer.building.x + 32
	end
end
	

function love.update(dt)

	map:update(dt)
end

function love.draw()
	map:draw()

	local mouseX = love.mouse.getX()
	local mouseY = love.mouse.getY()

	love.graphics.print( "X: " .. mouseX .. " Y: " .. mouseY , 300, 300, 0, 1, 1, 0, 0)

end

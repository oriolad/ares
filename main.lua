-- This is the main.lua file --
local sti = require "sti" 

function love.load()
	love.window.setTitle("Ares - The Mars Terraforming Game")
	love.window.setMode( 832, 640, {resizable=true, minwidth=640, minheight=640})

    -- Add background colour and layer
	love.graphics.setBackgroundColor(0.678, 0.522, 0.302)
	map = sti("assets/maps/basic_map.lua")

    -- Walk layer
    walkLayer = map.layers["walk"]

    -- Add sprite layer
    spriteLayer = map:addCustomLayer("sprite", 2)

	spriteLayer.sprite = {
		image = love.graphics.newImage("assets/items/xenoDiversity/Blue/Alpha/stand.png"),
		x = 32 * 4, -- starting x coordinate
		y = 32 * 4, -- starting y coordinate
		ox = 0,
		oy = 0
	}

	spriteLayer.draw = function(self)
        local spriteHeight = 32
        local spriteWidth = 16
--        love.graphics.push()
--        love.graphics.scale(0.5, 0.5)
		love.graphics.draw(
			self.sprite.image,
			math.floor(self.sprite.x - spriteWidth),
			math.floor(self.sprite.y - spriteHeight),
			0,
			0.5,
			0.5,
			self.sprite.ox,
			self.sprite.oy)
        local width, height = spriteLayer.sprite.image:getDimensions()
        local rectangle = love.graphics.rectangle("line", self.sprite.x - spriteWidth, self.sprite.y - spriteHeight,  width/2, height/2)

--        love.graphics.pop()
    end

end

function love.keypressed( key )
    local movementDistance = 8
    local x = spriteLayer.sprite.x
    local y = spriteLayer.sprite.y

	if key == "w" or key == "up" then
		y = spriteLayer.sprite.y - movementDistance
	end

	if key == "s" or key == "down" then
		y = spriteLayer.sprite.y + movementDistance
	end

	if key == "a" or key == "left" then
		x = spriteLayer.sprite.x - movementDistance
	end

	if key == "d" or key == "right" then
		x = spriteLayer.sprite.x + movementDistance
    end

    local validMove = false
    for k, walkway in pairs(walkLayer.objects) do
        if x > walkway.x and x < walkway.x + walkway.width and y > walkway.y and y < walkway.y + walkway.height then
            validMove = true
            break
        end
    end

    if validMove == true then
        spriteLayer.sprite.x = x
        spriteLayer.sprite.y = y
    end
--    if key == "rctrl" and key == "q" then
--        love.window.close()
--    end
end
	

function love.update(dt)

	map:update(dt)
end

function love.draw()
	map:draw()

	local sX = spriteLayer.sprite.x
	local sY = spriteLayer.sprite.y

	love.graphics.print( "X: " .. sX .. " Y: " .. sY , 300, 300, 0, 1, 1, 0, 0)

end

-- This is the main.lua file --
local sti = require "sti" 

debug = true

function love.load()
    love.window.setTitle("Ares - The Mars Terraforming Game")
    love.window.setMode( 800, 600, {resizable=true, minwidth=640, minheight=640})
    love.window.setFullscreen(true, "desktop")

    -- Add background colour and layer
    love.graphics.setBackgroundColor(0.678, 0.522, 1)	
    map = sti("assets/maps/basic_map.lua")
        

    -- Keyboard Properties
    love.keyboard.setKeyRepeat(true)

    -- Walk layer
    walkLayer = map.layers["walk"]
    walkLayer.opacity = 0
    if debug then walkLayer.opacity = 1 end

    -- Add sprite layer
    spriteLayer = map:addCustomLayer("sprite", 2)

	spriteLayer.sprite = {
		image = love.graphics.newImage("assets/sprites/alien_stand.png"),
		x = 150, -- starting x coordinate
		y = 150, -- starting y coordinate
		ox = 0,
        oy = 0
	}

	spriteLayer.draw = function(self)
        local spriteHeight = 50
        local spriteWidth = 35

		love.graphics.draw(
			self.sprite.image,
			math.floor(self.sprite.x),
			math.floor(self.sprite.y),
			0,
			1,
			1,
			self.sprite.ox,
            self.sprite.oy)
        
            if debug then
                local width, height = spriteLayer.sprite.image:getDimensions()
                local rectangleAroundSprite = love.graphics.rectangle("line", self.sprite.x, self.sprite.y,  width, height)
            end
    end

end

function love.keypressed(key)
        
    if key == "escape" or key == "q" then
        love.event.quit()
    end
    
end -- end love.keypressed function

function getDirectionVector()
    -- Initialize Direction Vector
    directionVector = { x  = 0, y = 0 }

    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        directionVector = { x = 0, y = -1 }
    end

    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        directionVector = { x = 0, y = 1 }
    end

    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        directionVector = { x = -1, y = 0 }
    end

    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        directionVector = { x = 1, y = 0 }
    end

end

function love.update(dt)
    -- initialize variables
    local movementSpeed = 200
    local spriteWidth, spriteHeight = spriteLayer.sprite.image:getDimensions()
    local currentX = spriteLayer.sprite.x
    local currentY = spriteLayer.sprite.y
    getDirectionVector()
    local nextX = currentX + (directionVector.x * movementSpeed * dt)
    local nextY = currentY + (directionVector.y * movementSpeed * dt)
    
    -- check if the next move is within the walk layer boundaries
    -- to do this, need to check that every corner of the sprite is within a walkway
    local nextCoordinates = {
        topLeft = {x = nextX, y = nextY},
        topRight = {x = nextX + spriteWidth, y = nextY},
        bottomLeft = {x = nextX, y = nextY + spriteHeight},
        bottomRight = {x = nextX + spriteWidth, y = nextY + spriteHeight}
    }

    local validMove = {
        topLeft = false,
        topRight = false,
        bottomLeft = false,
        bottomRight = false
    }

    -- loop through all the walkways
    for k, walkway in pairs(walkLayer.objects) do
        
        -- check if any of the corners are in the existing walkway
        for key, point in pairs(nextCoordinates) do
            if point.x >= walkway.x 
                and point.x <= walkway.x + walkway.width 
                and point.y >= walkway.y 
                and point.y <= walkway.y + walkway.height
            then
                validMove[key] = true 
                -- print("Valid Move " .. key .. " = ".. tostring(validMove[key]))
            end
        end
        
    end
    

    local count = 0
    for i, v in pairs(validMove) do
        print("i" .. i)
        print("v" .. tostring(v))
        print(count)
        if( v ) then 
            count = count + 1
        end
    end

    for key, valid in pairs(validMove) do
        -- print("Valid Move " .. key .. " = ".. tostring(validMove[key]))
    end

    if count == 4 then
        spriteLayer.sprite.x = nextX
        spriteLayer.sprite.y = nextY
    end
    map:update(dt)
    

end

function love.draw()
	map:draw()

	local sX = spriteLayer.sprite.x
	local sY = spriteLayer.sprite.y

	love.graphics.print( "X: " .. sX .. " Y: " .. sY , 300, 300, 0, 1, 1, 0, 0)

end

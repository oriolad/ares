-- This is the main.lua file --
local sti = require "sti" 
local movementSystem = require "component.movement"

debug = false

function love.load()
    love.window.setTitle("Ares - The Mars Terraforming Game")
    love.window.setMode( 800, 600, {resizable=true, minwidth=640, minheight=640})
    love.window.setFullscreen(true, "desktop")

    -- Add background colour and layer
    map = sti("assets/maps/basic_map.lua")

    local layerCount = 0
    for i,layer in ipairs(map.layers) do
        print(i .. layer.name)
        layerCount = i
    end
    
    -- Keyboard Properties
    love.keyboard.setKeyRepeat(true)

    -- Walk layer
    walkLayer = map.layers["walk"]
    walkLayer.visible = false
    if debug then walkLayer.visible = true end

    -- Add sprite layer
    spriteLayer = map:addCustomLayer("sprite", layerCount + 1)

    spriteLayer.sprite = {
        image = love.graphics.newImage("assets/sprites/alien_stand.png"),
        x = 230, -- starting x coordinate
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
    if love.keyboard.isDown("space") then
        print("CHECK!")

        for i,row in ipairs(map.layers["rocks"].data) do
            -- print("Row".. tostring(row))
            for j, column in pairs(row) do
                
                io.write(j .. tostring(column))
            end
        end
    end

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
    movementSystem.update(dt)
    map:update(dt)
end

function love.draw()
    map:draw()
    love.graphics.setBackgroundColor(map.backgroundcolor)

    if debug then 
        local sX = spriteLayer.sprite.x
	    local sY = spriteLayer.sprite.y
        love.graphics.print( "X: " .. sX .. " Y: " .. sY , 300, 300, 0, 1, 1, 0, 0) 
    end

end

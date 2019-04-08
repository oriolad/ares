-- This is the main.lua file --
local sti = require "sti" 
local movementSystem = require "component.movement"
local globalProtection = require "global_protection"

globalProtection.protectGlobals()

debugMode = true

function love.load()
    love.window.setTitle("Ares - The Mars Terraforming Game")
    love.window.setMode( 800, 600, {resizable=true, minwidth=640, minheight=640})
    --love.window.setFullscreen(true, "desktop")

    -- Add background colour and layer
    map = sti("assets/maps/basic_map.lua")

    local layerCount = 0
    for i,layer in ipairs(map.layers) do
        if debugMode then print(i .. layer.name) end
        layerCount = i
    end
    
    -- Keyboard Properties
    love.keyboard.setKeyRepeat(true)

    -- Walk layer
    walkLayer = map.layers["walk"]
    walkLayer.visible = false
    if debugMode then 
        -- walkLayer.visible = true
        walkLayer.opacity = 0.3
    end

    -- print the rock layer data in the console
    rockLayer = map.layers["rocks"]
    rocks = {} -- array of rocks
    print("Printing the rock layer data")
    for row, rowTable in ipairs(rockLayer.data) do
        for col in pairs(rowTable) do

            if debugMode then 
                print("row: " .. row)
                print("col: " .. col) 
            end

            local x = (col-1) * map.tileheight
            local y = (row-1) * map.tilewidth

            local rock = {
                x = x,
                y = y,
                width = map.tilewidth,
                height = map.tileheight,
                axes = calculateAxes(x, y, map.tilewidth, map.tileheight)
            }
            table.insert(rocks, rock)
        end
    end          

    -- Add sprite layer
    spriteLayer = map:addCustomLayer("sprite", layerCount + 1)
    spriteLayer.sprite = {
        image = love.graphics.newImage("assets/sprites/alien_stand.png"),
        x = 230, -- starting x coordinate
        y = 100, -- starting y coordinate
        ox = 0,
        oy = 0,
        width = 35,
        height = 50
    }

    spriteLayer.draw = function(self)

        love.graphics.draw(
            self.sprite.image,
            math.floor(self.sprite.x),
            math.floor(self.sprite.y),
            0,
            1,
            1,
            self.sprite.ox,
            self.sprite.oy)
    end

end

function calculateCornerCoordinates(x, y, width, height)
    local coordinates = {
        topLeft = { x = x, y = y },
        topRight = { x = x + width, y = y },
        bottomLeft = { x = x, y = y + height },
        bottomRight = { x = x + width, y = y + height }
    }
    return coordinates
end

function calculateAxes(x, y, width, height)
    local axes = {
        x1 = x,
        x2 = x + width,
        y1 = y, 
        y2 = y + height
    }
    print("Calculated axes: ")
    print("X-axis:" .. axes.x1 .. " " .. axes.x2)
    print("Y-axis:" .. axes.y1 .. " " .. axes.y2)
    return axes
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

    if debugMode then 
        local sX = spriteLayer.sprite.x
	    local sY = spriteLayer.sprite.y
        love.graphics.print( "X: " .. sX .. " Y: " .. sY , 10, 10, 0, 1, 1, 0, 0) 
    end

    -- outline sprite + rocks for debugging
    if debugMode then
        for i, rock in ipairs(rocks) do
            love.graphics.rectangle("line", futureSprite.axes.x1, futureSprite.axes.y1, spriteLayer.sprite.width, spriteLayer.sprite.height)
            love.graphics.rectangle("line", rock.axes.x1, rock.axes.y1, rock.width, rock.height)
        end
    end

end

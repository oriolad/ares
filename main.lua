-- This is the main.lua file --
local sti = require "sti" 
local movementSystem = require "component.movement"
local globalProtection = require "global_protection"
local Entity = require "entity"
local DrawComponent = require "component.draw_component"

globalProtection.protectGlobals()

debugMode = true

function love.load()
    love.window.setTitle("Ares - The Mars Terraforming Game")
    viewport = {
        width = 700,
        height = 600
    }
    love.window.setMode( viewport.width, viewport.height, {resizable=true, minwidth=400, minheight=400})

    -- Add background colour and layer
    map = sti("assets/maps/basic_map.lua")
    map.pixelWidth = map.width * map.tileheight
    map.pixelHeight = map.height * map.tileheight


    local layerCount = 0
    for i,layer in ipairs(map.layers) do
        if debugMode then print(i .. " : " .. layer.name) end
        layerCount = i
    end
    
    
    -- Keyboard Properties
    love.keyboard.setKeyRepeat(true)

    pathLayer = map.layers["path_layer"]
    borders = {}
    for row, rowTable in ipairs(pathLayer.data) do
        for col in pairs(rowTable) do
            local x = (col-1) * map.tileheight
            local y = (row-1) * map.tilewidth

            local border = {
                x = x,
                y = y,
                width = map.tilewidth,
                height = map.tileheight,
                axes = calculateAxes(x, y, map.tilewidth, map.tileheight)
            }
            table.insert(borders, border)
        end
    end     

    generatePlayer()    
end

function printTable(inputTable, level)
        for k, v in pairs(inputTable) do
            if type(v) == "table" then
                print(string.rep(" ", level) .. k .. " :")
                printTable(v, level + 1)
            else
                print(string.rep(" ", level) .. k .. " : " .. tostring(v))
            end
        end
end

function generatePlayer()
    alien = Entity:new("alien")
    DrawComponent:addDrawComponentToEntity(alien, "assets/sprites/alien_stand.png", 230, 100, 35, 50)
end

function love.keypressed(key)
    if love.keyboard.isDown("space") then
        print("CHECK!")
    end

    if key == "escape" or key == "q" then
        love.event.quit()
    end 
end

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

function calculateAxes(x, y, width, height)
    axes = { 
        x1 = x,
        x2 = x + width, 
        y1 = y, 
        y2 = y + height 
    }
    return axes
end

function love.update(dt)
    movementSystem.update(dt)
    map:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(map.backgroundcolor)
    local tx = math.min(map.pixelWidth - viewport.width, math.max(0, alien.x - (viewport.width/2))) 
    local ty = math.min(map.pixelHeight - viewport.height, math.max(0, alien.y - (viewport.height/2)))

    
    map:draw(-tx, -ty)
    DrawComponent:updateEntityCameraTranslation(alien, -tx, -ty)
    DrawComponent:drawEntity(alien)

    if debugMode then

        -- print( "X: " .. spriteLayer.sprite.x .. " Y: " .. spriteLayer.sprite.y) 
        love.graphics.rectangle("line", futureSprite.axes.x1 - tx, futureSprite.axes.y1 - ty, alien.width, alien.height) -- player            
        -- end
    end

end

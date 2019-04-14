-- This is the main.lua file --
local sti = require "sti"
local entityManager = require "entity_manager"

local globalProtection = require "global_protection"
local drawComponent = require "components.draw_component"
local MovementComponent = require "components.movement_component"

local MovementSystem = require "systems.movement_system"
local DrawSystem = require "systems.draw_system"

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
    generateRock()
end



function generatePlayer()
    alien = entityManager.createNewEntity("alien")
    local alienDrawComponent = drawComponent:new("assets/sprites/alien_stand.png", 230, 100)
    local directionVector = MovementSystem.getDirectionVector()
    local alienMoveComponent = MovementComponent:new(230, 100, 200, directionVector, 35, 50)
    entityManager.addComponentToEntity(alienDrawComponent, alien)
    entityManager.addComponentToEntity(alienMoveComponent, alien)
end

function generateRock()
    rock = entityManager.createNewEntity("rock")
    local rockDrawComponent = drawComponent:new("assets/sprites/alien_stand.png", 250, 500)
    local rockMoveComponent = MovementComponent:new(250, 500, 0, { x = 0, y = 0}, 32, 32 )

    entityManager.addComponentToEntity(rockDrawComponent, rock)
    entityManager.addComponentToEntity(rockMoveComponent, rock)
end

function printTable(inputTable, level)
    level = level or 0
    for k, v in pairs(inputTable) do
        if type(v) == "table" then
            print(string.rep(" ", level) .. k .. " :")
            printTable(v, level + 1)
        else
            print(string.rep(" ", level) .. k .. " : " .. tostring(v))
        end
    end
end

function love.keypressed(key)
    if love.keyboard.isDown("space") then
        print("CHECK!")
    end

    if key == "escape" or key == "q" then
        love.event.quit()
    end 
end


function calculateAxes(x, y, width, height)
    axes = { 
        leftX = x,
        rightX = x + width, 
        topY = y, 
        bottomY = y + height 
    }
    return axes
end

function love.update(dt)
    MovementSystem:update(dt)
    map:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(map.backgroundcolor)
    -- viewport logic
    local tx = math.min(map.pixelWidth - viewport.width, math.max(0, alien.drawComponent.x - (viewport.width/2))) 
    local ty = math.min(map.pixelHeight - viewport.height, math.max(0, alien.drawComponent.y - (viewport.height/2)))

    map:draw(-tx, -ty)
    rock.drawComponent.tx = -tx
    rock.drawComponent.ty = -ty
    DrawSystem:draw(rock.drawComponent)

    alien.drawComponent.tx = -tx
    alien.drawComponent.ty = -ty
    DrawSystem:draw(alien.drawComponent)

    if debugMode then
        -- print( "X: " .. spriteLayer.sprite.x .. " Y: " .. spriteLayer.sprite.y) 
        love.graphics.rectangle("line", futureSprite.axes.leftX - tx, futureSprite.axes.topY - ty, alien.movementComponent.width, alien.movementComponent.height) -- player            
    end

end

-- This is the main.lua file --
local sti = require "sti"
local globalProtection = require "global_protection"

local EntityManager = require "entity_manager"

local DrawComponent = require "components.draw_component"
local MovementComponent = require "components.movement_component"
local PositionComponent = require "components.position_component"

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
    mapBorders = {}
    for row, rowTable in ipairs(pathLayer.data) do
        for col in pairs(rowTable) do
            local x = (col-1) * map.tileheight
            local y = (row-1) * map.tilewidth

            border = MovementSystem.calculateBorder(x, y, map.tilewidth, map.tileheight)
            table.insert(mapBorders, border)
        end
    end     
    
    generatePlayer()
    generateRock()

    
end

function generatePlayer()
    alien = EntityManager.createEntity("alien")
    EntityManager.printEntityList()

    local alienPositionComponent = PositionComponent:new(230, 100, 35, 50)
    local alienDrawComponent = DrawComponent:new("assets/sprites/alien_stand.png")
    local alienMoveComponent = MovementComponent:new(200)

    EntityManager.addComponentToEntity(alienPositionComponent, alien)
    EntityManager.addComponentToEntity(alienDrawComponent, alien)
    EntityManager.addComponentToEntity(alienMoveComponent, alien)  

    for i, v in ipairs(alien.componentTable) do
        print("Index: " .. i .. " has type " .. v.type)
    end

    movementSystem = MovementSystem:new(alienPositionComponent, alienMoveComponent)

end

function generateRock()
    rock = EntityManager.createEntity("rock")
    EntityManager.printEntityList()

    local rockPositionComponent = PositionComponent:new(390, 350, 32, 32)
    local rockDrawComponent = DrawComponent:new("assets/sprites/rock.png")

    EntityManager.addComponentToEntity(rockPositionComponent, rock)
    EntityManager.addComponentToEntity(rockDrawComponent, rock)

    for i, v in ipairs(rock.componentTable) do
        print("Index: " .. i .. " has type " .. v.type)
    end
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

    if key == "d" then --set to whatever key you want to use
      debug.debug()
   end
end

function love.update(dt)
    movementSystem:update(dt)
    map:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(map.backgroundcolor)

    -- TODO: write code that quickly grabs a component from an entity and 
    -- put the code in the entity manager 
    -- local drawIndex = 0
    -- for i, value in ipairs(alien.componentTable) do
    --     if value.type == "draw" then
    --         drawIndex = i
    --         break
    --     end
    -- end

    -- viewport logic
    local tx = math.min(map.pixelWidth - viewport.width, math.max(0, alien.componentTable[1].x - (viewport.width/2))) 
    local ty = math.min(map.pixelHeight - viewport.height, math.max(0, alien.componentTable[1].y - (viewport.height/2)))

    map:draw(-tx, -ty)

    alien.componentTable[2].tx = -tx
    alien.componentTable[2].ty = -ty
    
    rock.componentTable[2].tx = -tx
    rock.componentTable[2].ty = -ty
    

    DrawSystem:draw(rock.componentTable[2], rock.componentTable[1])
    DrawSystem:draw(alien.componentTable[2], alien.componentTable[1])
    
    DrawSystem.outlineEntity(alien.componentTable[2], alien.componentTable[1])
    
end

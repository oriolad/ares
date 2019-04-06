--[[
This Defines the movement system
Requires refactoring
Inputs for the movement system will include:
 (1) the entity that's moving
 (2) the validation check (i.e. which areas can the entity move in)
 (3) movement parameters which are properties of the entity
    (3a) speed
    (3b) distance
    (3c) direction

    where distance and direction can be controlled by keypress for certain entities
--]]

local movementSystem = {}

local function update(dt)
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
        --    print("i" .. i)
        --    print("v" .. tostring(v))
        --    print(count)
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
end

movementSystem.update = update

return movementSystem
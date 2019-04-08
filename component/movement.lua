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
        topRight = {x = nextX + spriteLayer.sprite.width, y = nextY},
        bottomLeft = {x = nextX, y = nextY + spriteLayer.sprite.height},
        bottomRight = {x = nextX + spriteLayer.sprite.width, y = nextY + spriteLayer.sprite.width}
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
        for key, spritePoint in pairs(nextCoordinates) do
            if spritePoint.x >= walkway.x 
                and spritePoint.x <= walkway.x + walkway.width 
                and spritePoint.y >= walkway.y 
                and spritePoint.y <= walkway.y + walkway.height
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

    -- TODO: abstract intersect code to any object, including paths
    -- therefore need to refactor walkway code above to work with a generic collision checker
    futureSprite = {
        axes = {
        x1 = nextX,
        x2 = nextX + spriteWidth,
        y1 = nextY, 
        y2 = nextY + spriteHeight
    }}

    -- check for collision with the rocks
    for i, rock in ipairs(rocks) do  
        isColliding = collisionCheck(rock, futureSprite)
        if isColliding then print("Collision!") end
    end
    
end

movementSystem.update = update

function collisionCheck(objectA, objectB)
    collision = false

       if (((objectA.axes.x1 > objectB.axes.x1 and objectA.axes.x1 < objectB.axes.x2) 
                or (objectA.axes.x2 > objectB.axes.x1 and objectA.axes.x2 < objectB.axes.x2))
            and ((objectA.axes.y1 > objectB.axes.y1 and objectA.axes.y1 < objectB.axes.y2)
                or (objectA.axes.y2 > objectB.axes.y1 and objectA.axes.y2 < objectB.axes.y2)))
            or
            (((objectB.axes.x1 > objectA.axes.x1 and objectB.axes.x1 < objectA.axes.x2)
                or (objectB.axes.x2 > objectA.axes.x1 and objectB.axes.x2 < objectA.axes.x2))
            and ((objectB.axes.y1 > objectA.axes.y1 and objectB.axes.y1 < objectA.axes.y2)
                or (objectB.axes.y2 > objectA.axes.y1 and objectB.axes.y2 < objectA.axes.y2))) 
            then
                collision = true
        end

    return collision
end

return movementSystem
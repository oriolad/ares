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
    local currentX = alien.x
    local currentY = alien.y
    getDirectionVector()
    local nextX = math.max(0, math.min(map.pixelWidth - alien.width, currentX + (directionVector.x * movementSpeed * dt)))
    local nextY = math.max(0, math.min(map.pixelHeight - alien.height, currentY + (directionVector.y * movementSpeed * dt)))

    -- TODO: abstract intersect code to any object, including paths
    -- therefore need to refactor walkway code above to work with a generic collision checker
    futureSprite = {
        axes = {
        x1 = nextX,
        x2 = nextX + alien.width,
        y1 = nextY, 
        y2 = nextY + alien.height
    }}

    -- check for any collision with the borders
    local borderCollision = false
    for i, border in ipairs(borders) do
        borderCollision = collisionCheck(border, futureSprite)
        if borderCollision then 
            break
        end
    end

    if borderCollision then 
        print("Collision with border!")
    else
        alien.x = nextX
        alien.y = nextY
    end
    
end

movementSystem.update = update

function collisionCheck(objectA, objectB)
    local collision = false

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
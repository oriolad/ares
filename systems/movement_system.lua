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


local MovementSystem = {}
MovementSystem.__index = MovementSystem

function MovementSystem:update(dt)
    -- initialize variables
    local component = alien.movementComponent
    
    local currentX = component.currentX
    local currentY = component.currentY
    component.directionVector = MovementSystem.getDirectionVector()
    component.nextX = math.max(0, math.min(map.pixelWidth - component.width, currentX + (component.directionVector.x * component.speed * dt)))
    component.nextY = math.max(0, math.min(map.pixelHeight - component.height, currentY + (component.directionVector.y * component.speed * dt)))

    -- TODO: abstract intersect code to any object, including paths
    -- therefore need to refactor walkway code above to work with a generic collision checker
    futureSprite = {
        axes = {
        leftX = component.nextX,
        rightX = component.nextX + component.width,
        topY = component.nextY, 
        bottomY = component.nextY + component.height
    }}

    -- check for any collision with the borders
    local borderCollision = false
    for i, border in ipairs(borders) do
        borderCollision = collisionCheck(border.axes, futureSprite.axes)
        if borderCollision then 
            break
        end
    end

    if borderCollision then 
        print("Collision with border!")
    else
        component.currentX = component.nextX
        component.currentY = component.nextY
        alien.drawComponent.x = component.nextX
        alien.drawComponent.y = component.nextY
    end
    
    -- hard-coded collision check with "rock" entity
    isColliding = collisionCheck(rock.movementComponent.currentBorders, futureSprite.axes)
    if isColliding then
        print("Collision with rock!")
    end
        
end

function MovementSystem.getDirectionVector()
    -- Initialize Direction Vector
    local directionVector = { x  = 0, y = 0 }

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

    return directionVector
end

function MovementSystem.print(movementComponent)
    print("Printing movement component")
    printTable(movementComponent, 0)
end

function collisionCheck(objectA, objectB)
    local collision = false

       if (((objectA.leftX > objectB.leftX and objectA.leftX < objectB.rightX) 
                or (objectA.rightX > objectB.leftX and objectA.rightX < objectB.rightX))
            and ((objectA.topY > objectB.topY and objectA.topY < objectB.bottomY)
                or (objectA.bottomY > objectB.topY and objectA.bottomY < objectB.bottomY)))
            or
            (((objectB.leftX > objectA.leftX and objectB.leftX < objectA.rightX)
                or (objectB.rightX > objectA.leftX and objectB.rightX < objectA.rightX))
            and ((objectB.topY > objectA.topY and objectB.topY < objectA.bottomY)
                or (objectB.bottomY > objectA.topY and objectB.bottomY < objectA.bottomY))) 
            then
                collision = true
        end

    return collision
end

return MovementSystem
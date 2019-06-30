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

function MovementSystem:new(positionComponent, movementComponent)
    local movementSystem = {}
    setmetatable(movementSystem, self)

    movementSystem.positionComponent = positionComponent
    movementSystem.movementComponent = movementComponent

    return movementSystem
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

function MovementSystem:update(dt)
    -- initialize variables
    -- local component = alien.movementComponent
    
    self.movementComponent.currentX = self.positionComponent.x;
    self.movementComponent.currentY = self.positionComponent.y;
    directionVector = MovementSystem.getDirectionVector();

    self.movementComponent.nextX = math.max(0, math.min(map.pixelWidth - self.positionComponent.width, self.movementComponent.currentX + (directionVector.x * self.movementComponent.speed * dt)));
    self.movementComponent.nextY = math.max(0, math.min(map.pixelHeight - self.positionComponent.height, self.movementComponent.currentY + (directionVector.y * self.movementComponent.speed * dt)));

    -- calculate current and future borders
    entityCurrentBoundary = MovementSystem.calculateBorder(self.movementComponent.currentX, self.movementComponent.currentY, self.positionComponent.width, self.positionComponent.height);
    entityFutureBoundary = MovementSystem.calculateBorder(self.movementComponent.nextX, self.movementComponent.nextY, self.positionComponent.width, self.positionComponent.height);

    -- hard-coded collision check with "rock" entity
    -- TODO: move to a collision system
    -- rockBoundary = MovementSystem.calculateBorder(rock.componentTable[1].x, rock.componentTable[1].y, rock.componentTable[1].width, rock.componentTable[1].height)
    -- isColliding = collisionCheck(rockBoundary, entityFutureBoundary)
    -- if isColliding then
        -- print("Collision with rock!")
    -- end

    borderCollision = MovementSystem.collisionCheckWithMapBorders(self.movementComponent, self.positionComponent, mapBorders, entityFutureBoundary)
    if borderCollision then
        print("Collision with border")
    else
        -- Update movement component with next movement
        self.movementComponent.currentX = self.movementComponent.nextX;
        self.movementComponent.currentY = self.movementComponent.nextY;

        -- Position Component is always tracking the latest movement updates
        self.positionComponent.x = self.movementComponent.currentX;
        self.positionComponent.y = self.movementComponent.currentY;
    end
end

function MovementSystem.print(movementComponent)
    print("Printing movement component")
    printTable(movementComponent, 0)
end

function MovementSystem.calculateBorder(x, y, width, height)
    border = {
        leftX = x,
        rightX = x + width,
        topY = y,
        bottomY = y + height
    }
    return border
end

-- Move this function to a collision system
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

-- Move this function to a collision system
function MovementSystem.collisionCheckWithMapBorders(movementComponent, positionComponent, mapBorders, entityFutureBoundary)
    local borderCollision = false
    for i, border in ipairs(mapBorders) do
        borderCollision = collisionCheck(border, entityFutureBoundary)

        if borderCollision then
            break
        end
    end

    return borderCollision
end

return MovementSystem 
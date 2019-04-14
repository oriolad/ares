--[[ Movement Component
movement parameters which are properties of the entity
    (3a) speed
    (3b) distance
    (3c) direction
--]]
local Component = require "components.component"

local MovementComponent = {}
MovementComponent.__index = MovementComponent

function MovementComponent:new(x, y, speed, directionVector, width, height)
    local movementComponent = Component:new("movement_component")
    setmetatable(movementComponent, self)

    movementComponent.currentX = x
    movementComponent.currentY = y
    movementComponent.nextX = x
    movementComponent.nextY = y
    movementComponent.speed = speed
    movementComponent.directionVector = directionVector
    movementComponent.width = width -- TODO: might need to be part of another component instead
    movementComponent.height = height -- TODO: might need to be part of another component instead
    movementComponent.currentBorders = {
        leftX = x,
        rightX = x + width,
        topY = y, 
        bottomY = y + height
        }
    movementComponent.futureBorders = {
        leftX = x,
        rightX = x + width,
        topY = y, 
        bottomY = y + height
        }
    return movementComponent
end


return MovementComponent
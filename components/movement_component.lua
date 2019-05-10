--[[ Movement Component
movement parameters which are properties of the entity
    (3a) speed
    (3b) distance
    (3c) direction
--]]
local Component = require "components.component"

local MovementComponent = {}
MovementComponent.__index = MovementComponent

function MovementComponent:new(speed)
    local movementComponent = Component:new("movement")
    setmetatable(movementComponent, self)

    movementComponent.currentX = 0 -- default current x value
    movementComponent.currentY = 0 -- default current y value
    movementComponent.nextX = 0 -- default next x value
    movementComponent.nextY = 0 -- default next y value
    movementComponent.speed = speed
    return movementComponent
end


return MovementComponent
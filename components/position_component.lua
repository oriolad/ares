--[[ Position Component

--]]
local ComponentManager = require "components.component_manager"

local PositionComponent = {}
PositionComponent.__index = PositionComponent

function PositionComponent:new(x, y, width, height)
        local positionComponent = ComponentManager.createComponent("position")
        setmetatable(positionComponent, self)

        positionComponent.x = x -- will be used as starting x coordinate
        positionComponent.y = y -- will be used as starting y coordinate
        positionComponent.width = width
        positionComponent.height = height
        return positionComponent
end

return PositionComponent
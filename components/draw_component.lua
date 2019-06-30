--[[ Draw Component

--]]
local ComponentManager = require "components.component_manager"

local DrawComponent = {}
DrawComponent.__index = DrawComponent

function DrawComponent:new(imagePath)
        local drawComponent = ComponentManager.createComponent("draw")
        setmetatable(drawComponent, self)

        drawComponent.image = love.graphics.newImage(imagePath)
        drawComponent.x = 0 -- default x position
        drawComponent.y = 0 -- default y position
        drawComponent.ox = 0 -- default x offset
        drawComponent.oy = 0 -- default y offset
        drawComponent.tx = 0 -- default x transform
        drawComponent.ty = 0 -- default y transform
        return drawComponent
end

return DrawComponent
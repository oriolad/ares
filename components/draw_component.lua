--[[ Draw Component

--]]
local Component = require "components.component"

local DrawComponent = {}
DrawComponent.__index = DrawComponent

function DrawComponent:new(imagePath, x, y)
        local drawComponent = Component:new("draw_component")
        setmetatable(drawComponent, self)

        drawComponent.image = love.graphics.newImage(imagePath)
        drawComponent.x = x -- starting x coordinate
        drawComponent.y = y -- starting y coordinate
        drawComponent.ox = 0
        drawComponent.oy = 0
        drawComponent.tx = 0
        drawComponent.ty = 0
        return drawComponent
end

return DrawComponent
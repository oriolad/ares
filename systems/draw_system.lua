--[[ Draw System

--]]

local DrawSystem = {}
DrawSystem.__index = DrawSystem

function DrawSystem.updateValue(drawComponent, key, value)
    drawComponent[key] = updateValue
end

-- Draw a specific entity
function DrawSystem:draw(drawComponent)
	love.graphics.draw(
        drawComponent.image,
        math.floor(drawComponent.x + drawComponent.tx),
        math.floor(drawComponent.y + drawComponent.ty),
        0, -- TODO: add to draw component
        1, -- TODO: add to draw component
        1, -- TODO: add to draw component
        drawComponent.ox,
        drawComponent.oy);
end

function DrawSystem.print(drawComponent)
    print("Printing draw component")
    printTable(drawComponent, 0)
end

return DrawSystem
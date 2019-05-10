--[[ Draw System

--]]

local DrawSystem = {}
DrawSystem.__index = DrawSystem

-- Draw a specific entity
function DrawSystem:draw(drawComponent, positionComponent)
	love.graphics.draw(
        drawComponent.image,
        math.floor(positionComponent.x + drawComponent.tx),
        math.floor(positionComponent.y + drawComponent.ty),
        0, -- TODO: add to draw component
        1, -- TODO: add to draw component
        1, -- TODO: add to draw component
        drawComponent.ox,
        drawComponent.oy);
end

function DrawSystem.updateDrawComponent(drawComponent, key, value)
    drawComponent[key] = value
end

function DrawSystem.outlineEntity(drawComponent, positionComponent)
    -- Move to the movement system and fix
    if debugMode then
        -- print( "X: " .. positionComponent.x .. " Y: " .. positionComponent.y);
        love.graphics.rectangle("line", positionComponent.x + drawComponent.tx, positionComponent.y + drawComponent.ty, positionComponent.width, positionComponent.height);
    end
end

return DrawSystem
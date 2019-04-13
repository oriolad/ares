--[[ Draw Componelnt

--]]

local DrawComponent = {}
DrawComponent.__index = DrawComponent

function DrawComponent:new(imagePath, x, y, width, height)
        local drawComponent = {}
        setmetatable(drawComponent, self)

	drawComponent.image = love.graphics.newImage(imagePath)
        drawComponent.x = x -- starting x coordinate
        drawComponent.y = y -- starting y coordinate
        drawComponent.ox = 0
        drawComponent.oy = 0
        drawComponent.tx = 0
        drawComponent.ty = 0
        drawComponent.width = width
        drawComponent.height = height
        drawComponent.axes = {
	        leftX = x,
	        rightX = x + width,
	        topY = y, 
	        bottomY = y + height
	    }
end

return DrawComponent
--[[ Draw System

--]]

local DrawSystem = {
	entityList = {}
}
DrawSystem.__index = DrawSystem

function DrawSystem:addDrawComponentToEntity(entity, imagePath, x, y, width, height)
		entity.image = love.graphics.newImage(imagePath)
        entity.x = x -- starting x coordinate
        entity.y = y -- starting y coordinate
        entity.ox = 0
        entity.oy = 0
        entity.tx = 0
        entity.ty = 0
        entity.width = width
        entity.height = height
        entity.axes = {
	        leftX = x,
	        rightX = x + width,
	        topY = y, 
	        bottomY = y + height
	    }

	    table.insert(self.entityList, entity)
end

function DrawComponent:updateEntityCameraTranslation(entity, tx, ty)
		entity.tx = tx
		entity.ty = ty
end

-- Draw a specific entity
function DrawComponent:draw()
	love.graphics.draw(
        entity.image,
        math.floor(entity.x + entity.tx),
        math.floor(entity.y + entity.ty),
        0,
        1,
        1,
        entity.ox,
        entity.oy);
end

return DrawSystem
--[[ Entity Manager
Generates a new generic entity and registers it
--]]
local Entity = require "entity"

local EntityManager = {}
EntityManager.id = 0 -- initialize entity IDs
EntityManager.entityList = {}
EntityManager.__index = EntityManager

-- Create new entity with a name and a generated ID
function EntityManager:createNewEntity(name)
        self.id = self.id + 1
        
        local entity = Entity:new(self.id, name)
        table.insert(self.entityList, entity)
        print("New Entity Created:")
        print("> ID: " .. entity.id)
        print("> Name: " .. entity.name)
        return entity
end

function EntityManager:deleteEntity(entityID)
	for i, entity in ipairs(self.entityList) do
		if entity.id == entityID then
			table.remove(self.entityList, i)
		end
	end
end

-- Add a component to an entity
function EntityManager:addComponentToEntity(component, entityID)

-- Get all entities with component

return EntityManager
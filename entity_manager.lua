--[[ Entity Manager
Generates a new generic entity and registers it
--]]
local Entity = require "entity"

local EntityManager = {}
EntityManager.id = -1 -- initialize entity IDs
EntityManager.entityList = {}

-- Create new entity with a name and a generated ID
function EntityManager.createNewEntity(name)
        EntityManager.id = EntityManager.id + 1
        
        local entity = Entity:new(EntityManager.id, name)
        table.insert(EntityManager.entityList, entity)
        print("New Entity Created:")
        print("> ID: " .. entity.id)
        print("> Name: " .. entity.name)
        return entity
end

function EntityManager.deleteEntity(entityID)
	for i, entity in ipairs(self.entityList) do
		if entity.id == entityID then
			table.remove(self.entityList, i)
		end
	end
end

-- TODO: Rewrite using entity ID instead
function EntityManager.printAllComponents(entity)
        print("Printing components for entity " .. entity.id .. " " .. entity.name)
        if entity.hasDraw == true then
                for key, name in pairs(entity.drawComponent) do
                        print(key .. " : " .. tostring(name))
                end
        else
                print("No components to print")
        end
end

-- Add a component to an entity
function EntityManager.addComponentToEntity(component, entity)
        if component.type == "draw_component" then
                entity.hasDraw = true
                entity.drawComponent = component
        elseif component.type == "movement_component" then
                entity.hasMovement = true
                entity.movementComponent = component
        else
                error("Attempt to add a component type '" .. type .. "', which does not exist!")
        end
        print("Component type " .. component.type .. " has been added to entity " .. entity.id)
        printTable(component)
end

-- Get all entities with component

return EntityManager
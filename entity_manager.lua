--[[ Entity Manager
Generates a new generic entity and registers it
--]]
local Entity = require "entity"
local ComponentManager = require "components.component_manager"

local EntityManager = {}
EntityManager.__index = EntityManager

local entityCount = -1 -- initialize entity count
local entityList = {}

-- Create new entity with a name and a generated ID
function EntityManager.createEntity(name)
        entityCount = entityCount + 1
        
        local entity = Entity:new(entityCount, name)
        table.insert(entityList, entity)

        print()
        print("--- New Entity Created:")
        print("> ID: " .. entity.id)
        print("> Name: " .. entity.name)
        return entity
end

function EntityManager.getEntityCount()
        return entityCount
end

function EntityManager.printEntityList()
        for i, entity in ipairs(entityList) do
                print("--- Printing entity list:")
                print("> ID: " .. entity.id .. ", Name: " .. entity.name)
        end
end

function EntityManager.deleteEntity(entityID)
	for i, entity in ipairs(entityList) do
		if entity.id == entityID then
			table.remove(entityList, i)
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
      
        -- iterate through all components in entntiy 
        -- check if entity already has component
        for i, value in ipairs(entity.componentTable) do
                if component.type == value.type then
                        error ("Entity already has the component type " .. type .. " added.")
                end
        end
        
        -- add component to entity's list of components
        table.insert(entity.componentTable, component)

        print("Component type " .. component.type .. " has been added to entity " .. entity.id .. " " .. entity.name)
        printTable(component) -- print component's variables
end

-- Get all entities with component
function EntityManager.getAllEntitiesWithComponentType(componentType)
        local entitiesWithComponentType = {}

        -- check that componentType is valid
        if ComponentManager.isValidType(componentType) then
                print("Checking which entities have component: " .. componentType)
        else
                error("Component type " .. componentType .. " does not exist.")
        end

        -- iterate through all entities
        for i, entity in ipairs(entityList) do
                print("Checking Entity ID: " .. entity.id .. ", Name: " .. entity.name)

                local entityHasComponent = false
                for i, component in ipairs(entity.componentTable) do
                        if component.type == componentType then
                                entityHasComponent = true
                        end
                end

                if entityHasComponent then
                        print("Entity " .. entity.id .. " " .. entity.name .. " has component " .. componentType .. ". Adding to list.")
                        table.insert(entitiesWithComponentType, entity)
                else
                        print("Entity " .. entity.id .. " " .. entity.name .. " does nto have component " .. componentType .. ". Excluding from list.")
                end
        end

        return entitiesWithComponentType
end

return EntityManager
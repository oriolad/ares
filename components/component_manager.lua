--[[ Component Manager
Generates a new component
--]]
local Component = require "components.component"

local ComponentManager = {}
ComponentManager.__index = ComponentManager

local componentTypeTable = {
    "position",
    "draw",
    "movement"
}

local componentCount = -1 -- initialize component Count
local componentList = {}

function ComponentManager.createComponent(componentType)
    componentCount = componentCount + 1
    
    -- Check that the new component type is valid
    if ComponentManager.isValidType(componentType) then
        -- create the new component
        local component = Component:new(componentCount, componentType)
        table.insert(componentList, component)
        print("Creating component of type " .. componentType)
        return component
    else
        error("Attempt to create a component type '" .. componentType .. "', which does not exist!") 
    end   

end

function ComponentManager.isValidType(type)
    local isValidType = false

    for i, validType in ipairs(componentTypeTable) do
        if type == validType then
            isValidType = true
        end
    end

    return isValidType
end

return ComponentManager
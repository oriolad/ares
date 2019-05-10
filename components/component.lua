--[[ Component Class
--]]

local Component = {}
Component.__index = Component

local component_type = { 
    "position",
    "draw",
    "movement"
}

-- Create a new component
function Component:new(type)
        local component = {}
        setmetatable(component, self)

        for i, value in ipairs(component_type) do
            if type == value then
                component.type = type
                return component
            end           
        end
        error("Attempt to create a component type '" .. type .. "', which does not exist!")

end

return Component
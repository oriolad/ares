--[[ Component Class
--]]

local Component = {}
Component.__index = Component

local component_types = { 
    "draw_component",
    "movement_component"
}

-- Create a new component
function Component:new(type)
        local component = {}
        setmetatable(component, self)

        for i, value in ipairs(component_types) do
            print(i .. " " .. value)
            if type == value then
                component.type = type
                return component
            end           
        end
        error("Attempt to create a component type '" .. type .. "', which does not exist!")

end

return Component
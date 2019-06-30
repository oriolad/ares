--[[ Component Class
--]]

local Component = {}
Component.__index = Component

-- Create a new component
function Component:new(id, type)
        local component = {}
        setmetatable(component, self)

        component.id = id
        component.type = type
        return component
end

return Component
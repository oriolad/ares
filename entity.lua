--[[ Entity Factory
Generates a new generic entity and registers it
--]]

local Entity = {}
Entity.id = 0 -- initialize entity IDs
Entity.__index = Entity

-- Create new player at starting x and y coordinates
function Entity:new(name)
        local entity = {}
        setmetatable(entity, self)

        self.id = self.id + 1
        self.name = name
        print("New Entity Created:")
        print("> ID: " .. self.id)
        print("> Name: " .. self.name)
        return entity
end

return Entity
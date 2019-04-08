return {
	protectGlobals = function()
	   setmetatable(_G, {
	       __index = function(self, key)
               error("Attempt to access global variable '" .. key .. "', which does not exist!")
	       end
	   })
	end
}
--!strict
local Artworks = script.Parent.Parent

local ObjectOrientedProgramming = Artworks.ObjectOrientedProgramming
local class = require(ObjectOrientedProgramming.class)
local Object = require(ObjectOrientedProgramming.Object)



local private = {}
local methods = {}

-- Disconnects the connection.
function methods:disconnect()
	if self.connected
	then
		private[self].callbacks[self] = nil
		self.connected = false
		private[self] = nil
	end
end



local Connection = class(methods, Object.class)
local constructor = {class = Connection}

-- Returns a new connection instance.
function constructor.new(callbacks, callback)
	local connection = Connection(Object.new(), {connected = true})
	
	callbacks[connection] = callback
	private[connection] = {callbacks = callbacks}
	
	return connection
end

return constructor

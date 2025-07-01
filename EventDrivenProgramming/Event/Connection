--!strict
local Artworks = script.Parent.Parent.Parent

local ObjectOrientedProgramming = Artworks.ObjectOrientedProgramming
local class = require(ObjectOrientedProgramming.class)
local Object = require(ObjectOrientedProgramming.Object)



local private = {}
local methods = {}

-- Disconnects the connection.
function methods:disconnect()
	if self.connected
	then
		private[self].table[self] = nil
		self.connected = false
	end
end



local Connection = class(methods, Object.class)
local constructor = {class = Connection}

-- Returns a new connection instance.
function constructor.new(connectedFunctions, func)
	local connection = Connection(Object.new(), {connected = true})
	
	private[connection] = {}
	private[connection].table = connectedFunctions
	private[connection].func = func
	
	return connection
end

return constructor

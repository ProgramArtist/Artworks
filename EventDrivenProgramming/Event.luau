--!strict
local Artworks = script.Parent.Parent

local ObjectOrientedProgramming = Artworks.ObjectOrientedProgramming
local class = require(ObjectOrientedProgramming.class)
local Object = require(ObjectOrientedProgramming.Object)



local Connection = require(script.Parent.Connection)

local private = {}
local methods = {}

-- Calls all callbacks with the given arguments.
function methods:fire(...)
	for connection, callback in private[self].callbacks
	do
		coroutine.wrap(callback)(...)
	end
end

-- Connects a function to the event.
-- Returns a connection object that can be disconnected.
function methods:connect(callback)
	if type(callback) ~= "function"
	then
		error("Attempt to connect failed: Passed value is not a function")
	end
	
	return Connection.new(private[self].callbacks, callback)
end

-- Connects a callback to the event that will only be called once.
function methods:once(callback)
	local connection
	connection = self:connect(function(...)
		connection:disconnect()
		callback(...)
	end)
	return connection
end

-- Waits for the event to be fired and returns the arguments it was given.
function methods:wait()
	local thread = coroutine.running()
	
	self:once(function(...)
		coroutine.resume(thread, ...)
	end)
	
	return coroutine.yield()
end

-- Disconnects all callbacks to the event.
function methods:disconnectAll()
	table.clear(private[self].callbacks)
end



local Event = class(methods, Object.class)
local constructor = {class = Event}

-- Returns a new event instance.
function constructor.new()
	local event = Event(Object.new())
	
	private[event] = {callbacks = {}}
	
	return event
end

return constructor

--!strict
local Artworks = script.Parent.Parent

local ObjectOrientedProgramming = Artworks.ObjectOrientedProgramming
local class = require(ObjectOrientedProgramming.class)
local Object = require(ObjectOrientedProgramming.Object)



local Connection = require(script.Connection)

local private = {}
local methods = {}

-- Calls all connected functions with the given arguments.
function methods:fire(...)
	for connection, func in private[self].connectedFunctions
	do
		coroutine.wrap(func)(...)
	end
end

-- Connects a function to the event.
-- Returns a connection object that can be disconnected.
function methods:connect(func)
	if type(func) ~= "function"
	then
		error("Attempt to connect failed: Passed value is not a function")
	end
	
	local connection = Connection.new(private[self].connectedFunctions, func)
	private[self].connectedFunctions[connection] = func
	return connection
end

-- Connects a function to the event that will only be called once.
function methods:once(func)
	local connection
	connection = self:connect(function(...)
		connection:disconnect()
		func(...)
	end)
	return connection
end

-- Waits for a signal to be fired and returns the arguments it was given.
function methods:wait()
	local thread = coroutine.running()
	
	self:once(function(...)
		coroutine.resume(thread, ...)
	end)
	
	return coroutine.yield()
end


local Event = class(methods, Object.class)
local constructor = {class = Event}

-- Returns a new event instance.
function constructor.new()
	local event = Event(Object.new())
	
	private[event] = {connectedFunctions = {}}
	
	return event
end

return constructor

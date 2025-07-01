--!strict
local Artworks = script.Parent.Parent
local Types = require(Artworks.Types)

local EventDrivenProgramming = Artworks.EventDrivenProgramming
local Event = require(EventDrivenProgramming.Event)

local ObjectOrientedProgramming = Artworks.ObjectOrientedProgramming
local class = require(ObjectOrientedProgramming.class)
local Object = require(ObjectOrientedProgramming.Object)



local private = {}
local methods = {}

-- Returns a property changed event of the property.
function methods:getPropertyChangedEvent(property : string)
	if not private[self].propertyChangedEvents[property]
	then
		private[self].propertyChangedEvents[property] = Event.new()
	end
	return private[self].propertyChangedEvents[property]
end

-- Converts the instance into an observable.
local function Observable<T>(instance : T)
	private[instance] = {propertyChangedEvents = {}}

	for key, value in instance
	do
		private[instance][key] = value
	end
	
	setmetatable(private[instance], getmetatable(instance))

	table.clear(instance)
	
	instance.changed = Event.new()
	instance.getPropertyChangedEvent = methods.getPropertyChangedEvent
	
	instance.changed:connect(function(key, value)
		if private[instance].propertyChangedEvents[key]
		then
			private[instance].propertyChangedEvents[key]:fire(value)
		end
	end)

	local metatable = {}
	metatable.__index = private[instance]
	metatable.__newindex = function(self, key, value)
		if metatable.__index[key] ~= value
		then
			metatable.__index[key] = value
			self.changed:fire(key, value)
		end
	end
	metatable.__iter = function()
		return next, private[instance]
	end
	
	return setmetatable(instance, metatable) :: T & {changed : Types.Event, getPropertyChangedEvent : (self : any, property : string) -> Types.Event}
end

return Observable

local Artworks = script.Parent.Parent

local EventDrivenProgramming = Artworks.EventDrivenProgramming
local Observable = require(EventDrivenProgramming.Observable)
local Observer = require(EventDrivenProgramming.Observer)



local constructor = {}

function constructor.new(className)
	return constructor.from(Instance.new(className))
end

function constructor.from<T>(instance : T)
	return function<Children>(properties : T, children : Children)
		local component = instance:Clone()
		for property, value in properties or {}
		do
			if not pcall(function() component[property] = value end)
			then
				local typeOfValue = typeof(value)
				
				if typeOfValue == "function"
				then
					if typeof(component[property]) == "RBXScriptSignal"
					then
						component[property]:Connect(value)
					else
						error(property .. " is not a RBXScriptSignal.")
					end
				elseif typeOfValue == "table"
				then
					local object = value[1]
					local key = value[2]
					
					if type(object) == "table" then
						local observable = object.changed and object or Observable(object)
						pcall(Observer.bindToObservable, observable, key, function(value) 
							component[property] = value
						end)
					elseif type(object) == "userdata"
					then
						if not pcall(Observer.bindToProperty, object, key, function(value) 
								component[property] = value
							end)
						then
							pcall(Observer.bindToAttribute, object, key, function(value) 
								component[property] = value
							end)
						end
					end
				end
			end
		end
		for name, child in children or {}
		do
			child.Name = type(name) == string and name or child.Name
			child.Parent = component
		end
		return component :: T & Children
	end
end

return constructor

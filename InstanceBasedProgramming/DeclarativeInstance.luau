local Artworks = script.Parent.Parent

local EventDrivenProgramming = Artworks.EventDrivenProgramming
local Observable = require(EventDrivenProgramming.Observable)
local Observer = require(EventDrivenProgramming.Observer)



local function assign(instance : Instance, key, value)
	local isProperty = pcall(function() return instance[key] end)
	local typeOfValue = typeof(value)

	if isProperty then
		if typeOfValue == "function"
		then
			if typeof(instance[key]) == "RBXScriptSignal"
			then
				instance[key]:Connect(value)
			else
				error(key .. " is not a RBXScriptSignal.")
			end
		elseif typeOfValue == "table"
		then
			local object = value[1]
			local keyOfObject = value[2]
			local callback = value[3]

			local typeOfObject = typeof(object)

			if typeOfObject == "table"
			then
				local observable = object.changed and object or Observable(object)

				if callback
				then
					pcall(Observer.bindToObservable, observable, keyOfObject, function(valueOfObject) 
						instance[key] = callback(valueOfObject)
					end)
				else
					pcall(Observer.bindToObservable, observable, keyOfObject, function(valueOfObject) 
						instance[key] = valueOfObject
					end)
				end
			elseif typeOfObject == "Instance"
			then
				local isPropertyOfObject = pcall(function() return object[keyOfObject] end)

				if callback
				then
					pcall(isPropertyOfObject and Observer.bindToProperty or Observer.bindToAttribute, object, keyOfObject, function(valueOfObject) 
						instance[key] = callback(valueOfObject)
					end)
				else
					pcall(isPropertyOfObject and Observer.bindToProperty or Observer.bindToAttribute, object, keyOfObject, function(valueOfObject) 
						instance[key] = valueOfObject
					end)
				end
			end
		else
			instance[key] = value
		end
	else
		local typeOfKey = typeof(key)

		if typeOfValue == "Instance"
		then
			value.Name = typeOfKey == string and key or value.Name
			value.Parent = instance
			--else
			--	instance:SetAttribute(key, value)
		elseif typeOfValue == "string" and typeOfKey == "number"
		then
			instance:AddTag(value)
		else
			instance:SetAttribute(key, value)
		end
	end
end



local constructor = {}

function constructor.new(className)
	return constructor.from(Instance.new(className))
end

function constructor.from<T>(instance : T)
	return function<U>(primary : T?, secondary : U?)
		local clone = instance:Clone() :: Instance
		
		for key, value in primary or {}
		do
			assign(clone, key, value)
		end
		
		for key, value in secondary or {}
		do
			assign(clone, key, value)
		end
		
		return clone :: T & U
	end
end

return constructor

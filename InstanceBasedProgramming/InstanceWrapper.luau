--!strict
local InstanceWrapper = {} :: {
	new : <T>(instance : Instance, object : T) -> Instance & T
}

local proxies = {}

function InstanceWrapper.new(instance, object)
	local proxy = proxies[instance]
	if proxy
	then
		getmetatable(proxy).object = object
		return proxy
	end
	
	proxy = newproxy(true)
	local metatable = getmetatable(proxy)
	
	metatable.object = object
	
	metatable.__index = function(self, key : string)
		local value
		local isProperty = false
		
		if metatable.object[key]
		then
			value = metatable.object[key]
		elseif pcall(function() value = instance[key] end)
		then
			isProperty = true
		else
			value = instance:GetAttribute(key)
		end
		
		local valueType = typeof(value)
		if valueType == "function"
		then
			return function(self, ...)
				return value(isProperty and instance or proxy, ...)
			end
		elseif valueType == "Instance"
		then
			return proxies[value] or InstanceWrapper.new(value, {})
		else
			return value
		end
	end
	
	metatable.__newindex = function(self, key : string, value : any)
		local valueType = typeof(value)
		if metatable.object[key]
		then
			metatable.object[key] = value
		elseif pcall(function() instance[key] = valueType == "userdata" and value() or value end)
		then
			
		elseif valueType == "userdata" or valueType == "Instance"
		then
			value.Name = key
			value.Parent = instance
		else
			instance:SetAttribute(key, value)
		end
	end
	
	metatable.__call = function()
		return instance
	end
	
	metatable.__tostring = function()
		return tostring(instance) .. " Wrapper"
	end
	
	-- metatable.__metatable = metatable
	
	metatable.__iter = function()
		return pairs(metatable.object)
	end
	
	proxies[instance] = proxy
	instance.Destroying:Connect(function()
		proxies[instance] = nil
	end)
	return proxy
end

return InstanceWrapper

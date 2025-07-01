--!strict
local Artworks = script.Parent.Parent
local Types = require(Artworks.Types)

local function extend<Instance, Properties>(instance: Instance, properties: Properties): Instance & Properties
	for key, value in properties or {}
	do
		instance[key] = value
	end
	return instance
end

return function<Methods, Parent>(methods : Methods, parent : Parent)
	local metatable = {}
	metatable.__index = parent
	-- Creates instance of the class.
	function metatable:__call<Instance, Properties>(instance : Instance, properties : Properties): Types.Instance<Instance & Properties, Types.Class<Methods, Parent>>
		return setmetatable(extend(instance, properties), {__index = methods})
	end
	metatable.__metatable = metatable
	-- metatable.__type = name
	-- metatable.__tostring = function() return metatable.__type end

	return setmetatable(methods, metatable)
end

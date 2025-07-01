--!strict
local Artworks = script.Parent.Parent
local Types = require(Artworks.Types)

local ObjectOrientedProgramming = Artworks.ObjectOrientedProgramming
local class = require(ObjectOrientedProgramming.class)



local methods = {}

-- Returns whether this is an instance of class.
function methods:isInstanceOf(class : Types.Class)
	local super = getmetatable(self).__index

	repeat
		if super == class then return true end
		super = getmetatable(super).__index
	until super == nil

	return false
end



local Object = class(methods)
local constructor = {class = Object}

-- Returns a new object instance.
function constructor.new()
	local object = Object({})
	
	
	
	return object
end

return constructor

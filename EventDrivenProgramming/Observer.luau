--!strict
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local Artworks = script.Parent.Parent
local ObjectOrientedProgramming = Artworks.ObjectOrientedProgramming
local Object = require(ObjectOrientedProgramming.Object)
local class = require(ObjectOrientedProgramming.class)



local methods = {}

-- Unbinds all functions.
function methods:unbind()
	for index, connection in self
	do
		connection:Disconnect()
	end
end

local Subscription = class({}, methods, Object.class)



local Observer = {}

-- Binds functions to Players.PlayerAdded and Players.PlayerRemoving events.
-- Returns a subscription object that can unbind functions.
function Observer.bindToPlayer(onPlayerAdded : ((player : Player) -> ())?, onPlayerRemoving : ((player : Player) -> ())?)
	local connections : {RBXScriptConnection} = {}
	
	if onPlayerAdded
	then
		table.insert(connections, Players.PlayerAdded:Connect(onPlayerAdded))
		for index, player in Players:GetPlayers()
		do
			task.spawn(onPlayerAdded, player)
		end
	end
	
	if onPlayerRemoving
	then
		table.insert(connections, Players.PlayerRemoving:Connect(onPlayerRemoving))
	end
	
	return Subscription(connections)
end

-- Binds functions to player.CharacterAdded and player.CharacterRemoving events.
-- Returns a subscription object that can unbind functions.
function Observer.bindToCharacter(player : Player, onCharacterAdded : ((character : Model) -> ())?, onCharacterRemoving : ((character : Model) -> ())?)
	local connections : {RBXScriptConnection} = {}
	
	if onCharacterAdded
	then
		table.insert(connections, player.CharacterAdded:Connect(onCharacterAdded))
		if player.Character
		then
			onCharacterAdded(player.Character)
		end
	end

	if onCharacterRemoving
	then
		table.insert(connections, player.CharacterRemoving:Connect(onCharacterRemoving))
	end
	
	return Subscription(connections)
end

-- Binds functions to CollectionService:GetInstanceAddedSignal(tag) and CollectionService:GetInstanceRemovedSignal(tag) events.
-- Returns a subscription object that can unbind functions.
function Observer.bindToTagged(tag : string, onInstanceAdded : ((instance : Instance) -> ())?, onInstanceRemoved : ((instance : Instance) -> ())?)
	local connections : {RBXScriptConnection} = {}

	if onInstanceAdded
	then
		table.insert(connections, CollectionService:GetInstanceAddedSignal(tag):Connect(onInstanceAdded))
		for index, instance in CollectionService:GetTagged(tag)
		do
			task.spawn(onInstanceAdded, instance)
		end
	end

	if onInstanceRemoved
	then
		table.insert(connections, CollectionService:GetInstanceRemovedSignal(tag):Connect(onInstanceRemoved))
	end
	
	return Subscription(connections)
end

-- Binds functions to instance.ChildAdded and instance.ChildRemoved events.
-- Returns a subscription object that can unbind functions.
function Observer.bindToChild(instance : Instance, onChildAdded : ((child : Instance) -> ())?, onChildRemoved : ((child : Instance) -> ())?)
	local connections : {RBXScriptConnection} = {}

	if onChildAdded
	then
		table.insert(connections, instance.ChildAdded:Connect(onChildAdded))
		for index, child in instance:GetChildren()
		do
			task.spawn(onChildAdded, child)
		end
	end
	
	if onChildRemoved
	then
		table.insert(connections, instance.ChildRemoved:Connect(onChildRemoved))
	end
	
	return Subscription(connections)
end

-- Binds functions to instance.DescendantAdded and instance.DescendantRemoving events.
-- Returns a subscription object that can unbind functions.
function Observer.bindToDescendant(instance : Instance, onDescendantAdded : ((descendant : Instance) -> ())?, onDescendantRemoving : ((child : Instance) -> ())?)
	local connections : {RBXScriptConnection} = {}

	if onDescendantAdded
	then
		table.insert(connections, instance.DescendantAdded:Connect(onDescendantAdded))
		for index, descendant in instance:GetDescendants()
		do
			task.spawn(onDescendantAdded, descendant)
		end
	end
	
	if onDescendantRemoving
	then
		table.insert(connections, instance.DescendantRemoving:Connect(onDescendantRemoving))
	end
	
	return Subscription(connections)
end

-- Binds a function to an observable's property changed event.
-- Returns a connection object that can be disconnected.
function Observer.bindToObservable(observable : Types.Observable, property : string, onPropertyChanged : (value : any) -> ())
	local propertyChangedEvent = observable:getPropertyChangedEvent(property)
	
	local connection = propertyChangedEvent:connect(onPropertyChanged)
	onPropertyChanged(observable[property])
	
	return connection
end

-- Binds a function to  instance:GetPropertyChangedSignal(property) event.
-- Returns a subscription object that can unbind the function.
function Observer.bindToProperty(instance : Instance, property : string, onPropertyChanged : (value : any) -> ())
	local connections : {RBXScriptConnection} = {}

	table.insert(connections, instance:GetPropertyChangedSignal(property):Connect(function()
		onPropertyChanged(instance[property])
	end))
	onPropertyChanged(instance[property])
	
	return Subscription(connections)
end

-- Binds a function to instance:GetAttributeChangedSignal(attribute) event.
-- Returns a subscription object that can unbind the function.
function Observer.bindToAttribute(instance : Instance, attribute : string, onAttributeChanged : (value : any) -> ())
	local connections : {RBXScriptConnection} = {}

	table.insert(connections, instance:GetAttributeChangedSignal(attribute):Connect(function()
		onAttributeChanged(instance:GetAttribute(attribute))
	end))
	onAttributeChanged(instance:GetAttribute(attribute))
	
	return Subscription(connections)
end

-- Binds a function to ValueBase.Changed event.
-- Returns a subscription object that can unbind the function.
function Observer.bindToValue(valueBase : ValueBase, onChanged : (value : any) -> ())
	local connections : {RBXScriptConnection} = {}

	table.insert(connections, valueBase.Changed:Connect(onChanged))
	onChanged(valueBase.Value)
	
	return Subscription(connections)
end


return Observer

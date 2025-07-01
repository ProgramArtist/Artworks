[MIT License](https://github.com/ProgramArtist/Artworks/blob/main/LICENSE) | [Installation](https://create.roblox.com/store/asset/116900774846541/Artworks) | [Documentation](https://programartist.notion.site/Artworks-214b63a9093680a983ccffc786c406b7)



---
## DeclarativeInstance
### 
```luau
local from = Artworks.DeclarativeInstance.from

local ScreenGui = from(Instance.new("ScreenGui"))
local Frame = from(Instance.new("Frame"))
local ImageButton = from(Instance.new("ImageButton"))
local TextLabel = from(script.TextLabel)

local temp = {}

local gui = ScreenGui({
	Parent = playerGui
}, 
{
	TestFrame = Frame({
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.5, 0.5),
		Transparency = 0.5,
	}, 
	{
		TestButton = ImageButton{
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 0.95),
			Size = UDim2.fromScale(0.5, 0.25),
			Activated = function()
				print("Hello, word!")
			end,
		},
		TextLabel{
			Text = {temp, "test"},
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 0.1),
		}
	}),
})

RunService.Heartbeat:Connect(function(deltaTime: number) 
	temp["test"] = deltaTime
end)

gui.TestFrame.TestButton.Activated:Connect(function(inputObject: InputObject, clickCount: number) 
	print("Autocompletion is awesome!")
end)
```

## Object Oriented Programming
### Example
```luau

local Object = Artworks.Object
local class = Artworks.class


local methods = {}

-- prints "Hello world!"
function methods:test()
	print(self.temp)
end

local Example = class(methods, Object.class)
local constructor = {class = Example}

function constructor.new()
	local properties = {temp = "Hello world!"}
	local example = Example(Object.new(), properties)
	
	return example
end

return constructor
```
### Script
```luau
local Example = require(script.Example)

local example = Example.new()
example:test()
example:isInstanceOf(Example.class)
```

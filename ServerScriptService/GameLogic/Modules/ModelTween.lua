local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local module = {}

--Create TweenService animation for Model and return Tween
module.CreateAnimation = function(model:Model, startPosition:CFrame, EndPosition:CFrame, Info:TweenInfo)
	model:PivotTo(startPosition)
	
	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = startPosition
	CFrameValue.Parent = model
	
	local connection1 = CFrameValue.Changed:Connect(function()
		model:PivotTo(CFrameValue.Value)
	end)
	
	local Animation = TweenService:Create(CFrameValue, Info, {Value = EndPosition})
	
	local connection2
	connection2 = Animation.Completed:Connect(function()
		connection1:Disconnect()
		connection2:Disconnect()
		CFrameValue:Destroy()
		CFrameValue = nil
	end)
	
	return Animation
end

return module

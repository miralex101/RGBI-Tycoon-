local CollectionService = game:GetService("CollectionService")

local function ConveyorFunc(part:Part)
	part.Anchored = true
	part.AssemblyLinearVelocity = part.CFrame.LookVector * 16
end

CollectionService:GetInstanceAddedSignal("ConveyorBelt"):Connect(function(object:Instance)
	if not object:IsA("Model") then return end
	local Belt = object:FindFirstChild("Belt")
	ConveyorFunc(Belt)
end)

for index, value in CollectionService:GetTagged("ConveyorBelt") do
	if not value:IsA("Model") then continue end
	local Belt = value:FindFirstChild("Belt")
	ConveyorFunc(Belt)
end

return nil

local CollectionService = game:GetService("CollectionService")

local function AddNewUpgrader(object:Model)
	local Field:MeshPart = object:FindFirstChild("Field")
	local PoofSFX:Sound = Field:FindFirstChild("Poof")

	Field.Touched:Connect(function(otherPart)
		if not otherPart:IsA("Part") then return end

		local Upgraded = otherPart:GetAttribute("Upgraded")

		if Upgraded then return end
		PoofSFX:Play()
		otherPart.Material = Enum.Material.Neon
		otherPart:SetAttribute("Upgraded", true)
		local NewCost = otherPart:GetAttribute("Cost") * 2
		otherPart:SetAttribute("Cost", NewCost)
	end)
end

CollectionService:GetInstanceAddedSignal("Upgrader"):Connect(AddNewUpgrader)

for index, value in CollectionService:GetTagged("Upgrader") do
	if not value:IsA("Model") then continue end
	AddNewUpgrader(value)
end

return nil

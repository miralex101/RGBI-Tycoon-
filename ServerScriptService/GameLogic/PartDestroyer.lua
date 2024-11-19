local CollectionService = game:GetService("CollectionService")

local function PartDestroyer(part:Part)
	part.Touched:Connect(function(otherPart)
		local Cost = otherPart:GetAttribute("Cost")

		if not Cost then return end
		if otherPart.Locked and not otherPart.CanCollide then
			task.wait(0.1)
			otherPart:Destroy()
		end
	end)
end

for index, value in CollectionService:GetTagged("PartDestroyer") do
	PartDestroyer(value)
end

return nil

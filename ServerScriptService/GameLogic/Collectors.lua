local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local PlayerList = {}

Players.PlayerAdded:Connect(function(player)
	PlayerList[player] = true
end)

Players.PlayerRemoving:Connect(function(player)
	PlayerList[player] = nil
end)

local function CollectParts(collector:Part)
	collector.Touched:Connect(function(otherPart)
		if not otherPart:IsA("Part") or otherPart.Locked then return end

		local CostAtt = otherPart:GetAttribute("Cost")
		local UpgradedAtt = otherPart:GetAttribute("Upgraded")
		local TeamAtt = otherPart:GetAttribute("Team")

		if not CostAtt or not TeamAtt then return end
		otherPart.Locked = true

		local PartOwner = nil
		for player in PlayerList do
			if player.TeamColor == TeamAtt then
				PartOwner = player
				break
			end
		end

		if not PartOwner then
			otherPart.CanCollide = false
			return 
		end
		local leaderstats = PartOwner:FindFirstChild("leaderstats")
		if not leaderstats then return end
		local playerCash:NumberValue = leaderstats:FindFirstChild("Cash")
		local Rebirth:NumberValue = leaderstats:FindFirstChild("Rebirth")

		playerCash.Value += CostAtt + (0.1 * Rebirth.Value * CostAtt)
		otherPart.CanCollide = false
		task.wait(0.18)
		otherPart:Destroy()
	end)
end

CollectionService:GetInstanceAddedSignal("Collector"):Connect(function(object:Instance)
	if not object:IsA("Part") then return end
	CollectParts(object)
end)

for index, value in CollectionService:GetTagged("Collector") do
	if not value:IsA("Part") then continue end
	CollectParts(value)
end

return nil

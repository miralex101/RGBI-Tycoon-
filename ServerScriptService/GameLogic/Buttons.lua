local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local MyOperations = require(ServerScriptService.GameLogic.Modules.MyOperations)

local function BuyButton(object:Model)
	local button = object:FindFirstChild("ButtonPart")
	local BuySFX:Sound = object:FindFirstChild("BuySound")
	local ErrorSFX:Sound = object:FindFirstChild("Error")
	local Attributes = button.Parent:GetAttributes()
	local NextButtons = MyOperations.SplitString(Attributes.NextButtons, ",")
	local Tycoon = game.Workspace.Tycoons:FindFirstChild(Attributes.TycoonName)

	button.Touched:Connect(function(otherPart)
		if button.Locked then return end

		local player = Players:GetPlayerFromCharacter(otherPart.Parent)
		if not player then 
			--warn("not a player")
			return 
		end

		if player.UserId ~= Attributes.Owner then
			--warn("player, but not a owner")
			--ErrorSFX:Play()
			return
		end

		local playerCash:IntValue = player.leaderstats.Cash
		local CostBuilding:number = Attributes.CostBuilding
		if playerCash.Value < CostBuilding then
			--warn("no money?")
			if not ErrorSFX.IsPlaying then ErrorSFX:Play() end
			return
		end

		button.Locked = true
		BuySFX:Play()
		playerCash.Value -= CostBuilding
		
		local BuyedBuilds:IntValue = player.BuyedBuilds
		BuyedBuilds.Value += 1
		
		local CloneBuilding = MyOperations.GetPositionAndPlaceObject(Tycoon, "Build", Attributes.NameBuilding, Attributes)

		local TagName = string.gsub(Attributes.NameBuilding, "%d", "")
		if not CloneBuilding:HasTag(TagName) then
			CloneBuilding:AddTag(TagName)
		end

		if Attributes.NextButtons == "NONE" then
			object:Destroy()
			return
		end

		for _, buttonName in NextButtons do
			local CloneBuilding = MyOperations.GetPositionAndPlaceObject(Tycoon, "Buttons", buttonName, Attributes)
		end

		object:Destroy()
	end)
end

CollectionService:GetInstanceAddedSignal("Button"):Connect(function(object:Instance)
	local Attributes = object:GetAttributes()
	BuyButton(object)
end)

return nil

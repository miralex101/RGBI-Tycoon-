local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local DataStoreHandler = require(ServerScriptService.GameLogic.Modules.DataStoreHandler)

Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local Cash = Instance.new("NumberValue")
	Cash.Name = "Cash"
	Cash.Value = 0
	Cash.Parent = leaderstats
	
	local MaxCash = Instance.new("NumberValue")
	MaxCash.Name = "MaxCash"
	MaxCash.Parent = leaderstats
	
	local Rebirth = Instance.new("IntValue")
	Rebirth.Name = "Rebirth"
	Rebirth.Parent = leaderstats
	
	local BuyedBuilds = Instance.new("IntValue")
	BuyedBuilds.Name = "BuyedBuilds"
	BuyedBuilds.Parent = player
	
	Cash.Changed:Connect(function()
		if Cash.Value > MaxCash.Value then
			MaxCash.Value = Cash.Value
		end
	end)
	
	DataStoreHandler:LoadPlayerData(player)
end)

Players.PlayerRemoving:Connect(function(player)
	DataStoreHandler:SavePlayerData(player)
end)

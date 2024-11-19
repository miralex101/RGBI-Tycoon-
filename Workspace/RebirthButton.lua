local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local ProximityPrompt = script.Parent
local Roof = ProximityPrompt.Parent.Parent.Parent.Parent

local Owner = Roof:GetAttribute("Owner")
local PlayerOwner = Players:GetPlayerByUserId(Owner)

if PlayerOwner then
	local BuyedBuilds:IntValue = PlayerOwner.BuyedBuilds
	ProximityPrompt.ObjectText = `Left to buy {26-BuyedBuilds.Value} more building!`
	
	BuyedBuilds.Changed:Connect(function(value)
		if value >= 26 then
			ProximityPrompt.ObjectText = "Ready!"
		elseif value < 26 then
			ProximityPrompt.ObjectText = `Left to buy {26-BuyedBuilds.Value} more building!`
		end
	end)
end

ProximityPrompt.Triggered:Connect(function(player)
	local Rebirth:IntValue = player.leaderstats.Rebirth
	local Cash:IntValue = player.leaderstats.Cash
	local MaxCash:IntValue = player.leaderstats.MaxCash
	local BuyedBuilds:IntValue = player.BuyedBuilds
	
	if BuyedBuilds.Value < 26 then
		warn("you're not ready for rebirth")
		return
	end
	
	MaxCash.Value = if Cash.Value > MaxCash.Value then Cash.Value else MaxCash.Value
	Rebirth.Value += 1
	Cash.Value = 0
	BuyedBuilds.Value = 0
	
	player.Team = game.Teams.Neutral
	ServerScriptService.Event:Fire(player.UserId)
	player:LoadCharacter()
end)

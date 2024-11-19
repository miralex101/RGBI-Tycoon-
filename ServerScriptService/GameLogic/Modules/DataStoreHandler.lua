local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerData")

local DataStoreHandler = {}

function DataStoreHandler:SavePlayerData(player)
	local Data = {}
	local Cash:IntValue = player.leaderstats.Cash
	local MaxCash:IntValue = player.leaderstats.MaxCash
	Data.MaxCash = if Cash.Value > MaxCash.Value then Cash.Value else MaxCash.Value
	Data.Rebirth = player.leaderstats.Rebirth.Value
    local success, errorMessage = pcall(function()
        playerDataStore:SetAsync(player.UserId, Data)
    end)
    if not success then
        warn("Failed to save data for player " .. player.Name .. ": " .. errorMessage)
    end
end

function DataStoreHandler:LoadPlayerData(player)
    local success, data = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)
    if success and data then
        for statName, value in pairs(data) do
            if player.leaderstats:FindFirstChild(statName) then
                player.leaderstats[statName].Value = value
            end
        end
    else
        warn("Failed to load data for player " .. player.Name)
    end
end

return DataStoreHandler

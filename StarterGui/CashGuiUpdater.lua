local Players = game:GetService("Players")

local player = Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local cash:IntValue = leaderstats:WaitForChild("Cash")

local CashLabel = script.Parent
CashLabel.Text = cash.Value .. "$"

cash.Changed:Connect(function(value)
	CashLabel.Text = value .. "$"
end)

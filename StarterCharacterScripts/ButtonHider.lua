local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local ButtonList = {}

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

CollectionService:GetInstanceAddedSignal("Button"):Connect(function(instance)
	ButtonList[instance] = true
end)

CollectionService:GetInstanceRemovedSignal("Button"):Connect(function(instance)
	ButtonList[instance] = nil
end)

for index, value in CollectionService:GetTagged("Button") do
	ButtonList[value] = true
end

local HumanoidRootPart:Part = character:WaitForChild("HumanoidRootPart")
local Humanoid = character:FindFirstChildWhichIsA("Humanoid")
local activated = false

local FAR_DISTANCE = 50
local NEAR_DISTANCE = 25
local RANGE = FAR_DISTANCE - NEAR_DISTANCE

local RunConnection = RunService.Heartbeat:Connect(function()
	for Button:Instance in ButtonList do
		local ButtonPart = Button:FindFirstChild("ButtonPart")
		
		if not ButtonPart then continue end
		local Attachment = ButtonPart.Attachment
		local NameLabel = Attachment.BillboardGui.NameLabel
		local CostLabel = Attachment.BillboardGui.CostLabel
		local Configured = Button:GetAttribute("Configured")
		
		if not Configured then
			local NameBuilding = Button:GetAttribute("NameBuilding") or "Nan"
			local CostBuilding = Button:GetAttribute("CostBuilding") or "?"

			NameLabel.Text = NameBuilding
			CostLabel.Text = CostBuilding .. "$"
			Button:SetAttribute("Configured", true)
		end
		
		local distance = (ButtonPart.Position - HumanoidRootPart.Position).Magnitude
		local clampDistance = math.clamp((distance - NEAR_DISTANCE) / RANGE, 0, 1)
		NameLabel.TextTransparency = clampDistance
		CostLabel.TextTransparency = clampDistance
	end
end)

local HumConnection
HumConnection = Humanoid.Died:Connect(function()
	if activated then return end
	activated = true
	RunConnection:Disconnect()
	HumConnection:Disconnect()
end)

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local TycoonsFolder = game.Workspace.Tycoons
local BaseTycoonTemplate = ReplicatedStorage.BaseTycoonTemplate
local MyOperations = require(ServerScriptService.GameLogic.Modules.MyOperations)

local DEFAULT_USER_ID = 7534182259
local TycoonList = {}

local function SetDoorData(Door:Part, UserID:number)
	local SurfaceGui = Door:FindFirstChild("SurfaceGui")
	local ImageLabel:ImageLabel = SurfaceGui:FindFirstChild("ImageLabel")
	local NameLabel:TextLabel = SurfaceGui:FindFirstChild("NameLabel")

	local Name = ""
	if UserID == DEFAULT_USER_ID then
		Name = "Unoccupied Tycoon" 
	else
		pcall(function()
			local getName = Players:GetNameFromUserIdAsync(UserID) or "Noob"
			Name = getName
		end)
	end

	local success, content, isReady = pcall(function()
		return Players:GetUserThumbnailAsync(UserID, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150)
	end)
	if success then
		ImageLabel.Image = content
		NameLabel.Text = Name
	end
end

local function SetTycoon(Tycoon:Model)
	local Door:Part = Tycoon:FindFirstChild("DoorPart")
	local TycoonAttributes = Tycoon:GetAttributes()
	local Build:Folder = Tycoon:FindFirstChild("Build")
	local Buttons:Folder = Tycoon:FindFirstChild("Buttons")
	Tycoon.Name = TycoonAttributes.TycoonName
	
	Door.BrickColor = TycoonAttributes.TeamColor

	Door.Touched:Connect(function(otherPart)
		if Door.Locked then return end

		local player = Players:GetPlayerFromCharacter(otherPart.Parent)
		if not player then return end
		
		if player.Team.Name ~= "Neutral" then return end
		if TycoonAttributes.Owner ~= "" then return end
		Door.Locked = true
		Tycoon:SetAttribute("Owner", player.UserId)
		player.TeamColor = TycoonAttributes.TeamColor
		local NewOwner = Tycoon:GetAttribute("Owner")
		TycoonList[NewOwner] = TycoonAttributes.TycoonName

		local NeutralSpawn:SpawnLocation = Tycoon:FindFirstChild("NeutralSpawn")
		NeutralSpawn:Destroy()

		local TeamTycoonSpawn:SpawnLocation = MyOperations.GetPositionAndPlaceObject(Tycoon, "Build", "TeamSpawn", nil)
		TeamTycoonSpawn.TeamColor = TycoonAttributes.TeamColor
		TeamTycoonSpawn.BrickColor = TycoonAttributes.TeamColor

		MyOperations.GetPositionAndPlaceObject(Tycoon, "Buttons", "ButtonD1", Tycoon:GetAttributes())
		SetDoorData(Door, NewOwner)
	end)

	return TycoonAttributes.TycoonName
end

local function ResetTycoon(NameTycoon:string)
	local Tycoon:Model = TycoonsFolder:FindFirstChild(NameTycoon)
	local Door:Part = Tycoon:FindFirstChild("DoorPart")
	Door.Locked = false
	Tycoon:SetAttribute("Owner", "")

	local Build:Folder = Tycoon:FindFirstChild("Build")
	local Buttons:Folder = Tycoon:FindFirstChild("Buttons")
	local Parts:Folder = Tycoon:FindFirstChild("Parts")

	for i, v in Build:GetChildren() do
		for _, tag in v:GetTags() do
			v:RemoveTag(tag)
		end
	end

	MyOperations.DeleteAll(Build)
	MyOperations.DeleteAll(Buttons)
	MyOperations.DeleteAll(Parts)

	SetDoorData(Door, DEFAULT_USER_ID)
	local NeutralSpawn = Tycoon:FindFirstChild("NeutralSpawn")

	if NeutralSpawn then
		--warn("Neutral spawn already created!")
		return
	end

	local NeutralSpawn:SpawnLocation = MyOperations.GetPositionAndPlaceObject(Tycoon, "Build", "NeutralSpawn", nil)
	NeutralSpawn.Parent = Tycoon
end

Players.PlayerRemoving:Connect(function(player)
	local NameTycoon = TycoonList[player.UserId]
	if NameTycoon then
		ResetTycoon(NameTycoon)
	end
end)

ServerScriptService.Event.Event:Connect(function(Id)
	local TycoonName = TycoonList[Id]
	ResetTycoon(TycoonName)
end)

for index, value in CollectionService:GetTagged("Tycoon") do
	if not value:IsA("Model") then continue end
	local TycoonName = SetTycoon(value)
	ResetTycoon(TycoonName)
end

return nil

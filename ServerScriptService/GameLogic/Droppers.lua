local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local DropperList = {}
local PopSFX = SoundService.Pops:GetChildren()

--Добавление дроппера в список
local function AddFunc(Dropper:Model)
	task.wait(1)
	DropperList[Dropper] = true
end
CollectionService:GetInstanceAddedSignal("Dropper"):Connect(AddFunc)

for index, value in CollectionService:GetTagged("Dropper") do
	AddFunc(value)
end

--Добавить парт в тайкун
local function AddPart(Attributes, Creator)
	local CloneSFX = PopSFX[math.random(#PopSFX)]:Clone()
	
	local part = Instance.new("Part")
	part.BrickColor = Attributes.TeamColor
	part.Size = Vector3.one
	part.Position = Creator.Position
	CloneSFX.Parent = part
	CloneSFX:Play()
	
	part:SetAttribute("Cost", Attributes.CostPart)
	part:SetAttribute("Upgraded", false)
	part:SetAttribute("Team", Attributes.TeamColor)
	part.Parent = game.Workspace.Tycoons:FindFirstChild(Attributes.TycoonName):FindFirstChild("Parts")
	Debris:AddItem(part, 10)
end

local seconds = 0
RunService.Heartbeat:Connect(function(delta)
	seconds += delta
	if seconds >= 1 then
		seconds -= 1
		for Dropper in DropperList do
			local Creator:Part = Dropper:FindFirstChild("Creator")
			if not Creator then
				DropperList[Dropper] = nil
				continue
			end

			local Attributes = Dropper:GetAttributes()
			AddPart(Attributes, Creator)
		end
	end
end)

return nil

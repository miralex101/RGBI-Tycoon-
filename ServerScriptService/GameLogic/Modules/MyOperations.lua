local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local module = {}

local BaseTycoonTemplate = ReplicatedStorage.BaseTycoonTemplate
local ModelTween = require(ServerScriptService.GameLogic.Modules.ModelTween)

--Send string and separator, return table
module.SplitString = function(inputString, separator)
	local result = {}
	local pattern = string.format("([^%s]+)", separator)
	for match in string.gmatch(inputString, pattern) do
		table.insert(result, match:match("^%s*(.-)%s*$")) -- Удаляем пробелы по краям
	end
	return result
end

module.GetPositionAndPlaceObject = function(Tycoon:Model, Parent:string?, objectName:string, Attributes)
	if objectName == "NONE" then return end

	local object = BaseTycoonTemplate:FindFirstChild(objectName) 
		or BaseTycoonTemplate.Build:FindFirstChild(objectName) 
		or BaseTycoonTemplate.Buttons:FindFirstChild(objectName)

	if not object then
		warn(`Cant find {objectName} in Tycoon, Sorry!`)
		return nil
	end

	local position
	if object:IsA("BasePart") then
		position = BaseTycoonTemplate.PrimaryPart.CFrame:ToObjectSpace(object.CFrame)
	elseif object:IsA("Model") then
		position = BaseTycoonTemplate.PrimaryPart.CFrame:ToObjectSpace(object.PrimaryPart.CFrame) 
	else
		warn(`Possible bad type of {objectName} if found! Object type: {typeof(object)}`)
	end

	--return position, object
	
	local CloneBuilding:Model = object:Clone()
	CloneBuilding.Parent = Tycoon[Parent] or Tycoon.Build
	CloneBuilding:PivotTo(Tycoon.PrimaryPart.CFrame:ToWorldSpace(position))
	
	local endPos = Tycoon.PrimaryPart.CFrame:ToWorldSpace(position)
	local startPos = endPos + Vector3.new(0, 100, 0)
	local Info = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local animation = ModelTween.CreateAnimation(CloneBuilding, startPos, endPos, Info)
	animation:Play()
	
	if Attributes then
		CloneBuilding:SetAttribute("Owner", Attributes.Owner)
		CloneBuilding:SetAttribute("TeamColor", Attributes.TeamColor)
		CloneBuilding:SetAttribute("TycoonName", Attributes.TycoonName)
	end
	
	return CloneBuilding
end

module.DeleteAll = function(object:Instance)
	for _, v in object:GetChildren() do
		v:Destroy()
	end
end

return module

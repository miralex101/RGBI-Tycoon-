local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local ModelTween = require(ServerScriptService.GameLogic.Modules.ModelTween)

local function KillPart(part:Part, owner:number)
	part.Touched:Connect(function(otherPart)
		local player = Players:GetPlayerFromCharacter(otherPart.Parent)
		
		if player then
			if player.UserId == owner then return end
			player.Character:FindFirstChildWhichIsA("Humanoid").Health = 0
		end
	end)
end

local function OpenCloseLaserFence(model:Model, owner:number)
	local LaserFence:Model = model.Parent
	local OpenCloseSFX:Sound = LaserFence.OpenCloseLaserFence
	local Lasers:Model = LaserFence.Lasers
	
	if not LaserFence:GetAttribute("Opened") then
		LaserFence:SetAttribute("Opened", false)
	end
	
	local ButtonPartList = {}
	local function OpenCloseVisual(status:boolean)
		local Image = if status then "rbxassetid://9804376096" else "rbxassetid://9648014023"
		local Color = if status then Color3.fromRGB(0, 170, 0) else Color3.fromRGB(170, 0, 0)
		
		for _, Button:Part in ButtonPartList do
			local ImageLabel:ImageLabel = Button:FindFirstChild("SurfaceGui"):FindFirstChild("ImageLabel")
			Button.Color = Color
			ImageLabel.Image = Image
		end
	end
	
	LaserFence:GetAttributeChangedSignal("Opened"):Connect(function()
		OpenCloseVisual(LaserFence:GetAttribute("Opened"))
	end)
	
	local Info = TweenInfo.new(0.5)
	local Button:Part = model:FindFirstChild("ButtonPart")
	ButtonPartList[#ButtonPartList+1] = Button
	
	local NewClickDetector = Instance.new("ClickDetector")
	NewClickDetector.Parent = Button
	
	task.wait(1)
	
	local ClosePosition = LaserFence.PrimaryPart.CFrame
	local OpenPosition = ClosePosition - Vector3.new(0, 15, 0)
	
	NewClickDetector.MouseClick:Connect(function(player)
		if player.UserId ~= owner then return end
		if LaserFence:GetAttribute("Opened") then
			local CloseAnim = ModelTween.CreateAnimation(Lasers, OpenPosition, ClosePosition, Info)
			CloseAnim:Play()
			OpenCloseSFX:Play()
			CloseAnim.Completed:Wait()
			LaserFence:SetAttribute("Opened", false)
		else
			local OpenAnim = ModelTween.CreateAnimation(Lasers, ClosePosition, OpenPosition, Info)
			OpenAnim:Play()
			OpenCloseSFX:Play()
			OpenAnim.Completed:Wait()
			LaserFence:SetAttribute("Opened", true)
		end
	end)
end

CollectionService:GetInstanceAddedSignal("LaserFence"):Connect(function(object:Model)
	local owner = object:GetAttribute("Owner")
	for _, v in object:GetChildren() do
		if v.Name == "Lasers" then
			for _, part in v:GetChildren() do
				KillPart(part, owner)
			end
		end
		if v:IsA("Model") and v.Name ~= "Lasers" then
			OpenCloseLaserFence(v, owner)
		end
	end
end)

return nil

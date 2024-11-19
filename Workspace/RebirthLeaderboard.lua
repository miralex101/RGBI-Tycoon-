--ЭТОТ СКРИПТ Я ВЗЯЛ И АДАПТИРОВАЛ ИЗ TOOLBOX

-- [ SETTINGS ] --

local statsName = "Rebirth" -- Your stats name
local maxItems = 100 -- Max number of items to be displayed on the leaderboard
local minValueDisplay = 1 -- Any numbers lower than this will be excluded
local maxValueDisplay = 10e15 -- (10 ^ 15) Any numbers higher than this will be excluded
local abbreviateValue = true -- The displayed number gets abbreviated to make it "human readable"
local updateEvery = 60 -- (in seconds) How often the leaderboard has to update
local headingColor = Color3.fromRGB(25, 181, 254) -- The background color of the heading

-- [ END SETTINGS ] --




-- Don't edit if you don't know what you're doing --

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local DataStore = DataStoreService:GetOrderedDataStore("GlobalLeaderboard_" .. statsName)
local Frame = script.Parent.Frame
local Contents = Frame.Contents
local Template = script.objTemplate

local COLORS = {
	Default = Color3.fromRGB(38, 50, 56),
	Gold = Color3.fromRGB(255, 215, 0),
	Silver = Color3.fromRGB(192, 192, 192),
	Bronze = Color3.fromRGB(205, 127, 50)
}
local ABBREVIATIONS = { "K", "M", "B", "T" }


local function toHumanReadableNumber(num)
	if num < 1000 then
		return tostring(num)
	end
	
	local digits = math.floor(math.log10(num)) + 1
	local index = math.min(#ABBREVIATIONS, math.floor((digits - 1) / 3))
	local front = num / math.pow(10, index * 3)
	
	return string.format("%i%s+", front, ABBREVIATIONS[index])
end

local function getItems()
	local data = DataStore:GetSortedAsync(false, maxItems, minValueDisplay, maxValueDisplay)
	local topPage = data:GetCurrentPage()

	Contents.Items.Nothing.Visible = #topPage == 0 and true or false

	for position, v in ipairs(topPage) do
		local userId = v.key
		local value = v.value
		local username = "[Not Available]"
		local color = COLORS.Default

		local success, err = pcall(function()
			username = Players:GetNameFromUserIdAsync(userId)
		end)

		if position == 1 then
			color = COLORS.Gold
		elseif position == 2 then
			color = COLORS.Silver
		elseif position == 3 then
			color = COLORS.Bronze
		end

		local item = Template:Clone()
		item.Name = username
		item.LayoutOrder = position
		item.Values.Number.TextColor3 = color
		item.Values.Number.Text = position
		item.Values.Username.Text = username
		item.Values.Value.Text = abbreviateValue and toHumanReadableNumber(value) or value
		item.Parent = Contents.Items
	end
end


script.Parent.Parent.Color = headingColor
Frame.Heading.ImageColor3 = headingColor
Frame.Heading.Bar.BackgroundColor3 = headingColor

while true do
	for _, player in pairs(Players:GetPlayers()) do
		local leaderstats = player:FindFirstChild("leaderstats")

		if not leaderstats then
			warn("Couldn't find leaderstats!")
			break
		end

		local statsValue = leaderstats:FindFirstChild(statsName)

		if not statsValue then
			warn("Couldn't find " .. statsName .. " in leaderstats!")
			break
		end

		pcall(function()
			DataStore:UpdateAsync(player.UserId, function()
				return tonumber(statsValue.Value)
			end)
		end)
	end

	for _, item in pairs(Contents.Items:GetChildren()) do
		if item:IsA("Frame") then
			item:Destroy()
		end
	end

	getItems()

	wait()
	Frame.Heading.Heading.Text = statsName .. " Leaderboard"
	Contents.GuideTopBar.Value.Text = statsName
	wait(updateEvery)
end

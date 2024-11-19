local CollectionService = game:GetService("CollectionService")

CollectionService:GetInstanceAddedSignal("Wall"):Connect(function(object:Model)
	local Attributes = object:GetAttributes()

	for _, v in object:GetChildren() do
		if v:IsA("Part") then
			v.BrickColor = Attributes.TeamColor
		end
	end
end)

return nil

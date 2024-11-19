local ServerScriptService = game:GetService("ServerScriptService")
local Main = ServerScriptService.GameLogic

for _, module:Instance in Main:GetChildren() do
	if not module:IsA("ModuleScript") then continue end
	require(module)
end

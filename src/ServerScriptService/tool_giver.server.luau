--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local on_tag = require(ReplicatedStorage.on_tag)

local function giveTools(backpack: Backpack)
	for _, tool in ServerStorage.Tools:GetChildren() do
		if backpack:FindFirstChild(tool.Name) ~= nil then
			continue
		end
		
		tool:Clone().Parent = backpack
	end
end

on_tag("tool_giver", function(tool_giver)
	local click_detector = assert(tool_giver:FindFirstChildOfClass("ClickDetector"), "ToolGiver is missing a ClickDetector.")
	local surface_gui = assert(tool_giver:FindFirstChildOfClass("SurfaceGui"), "ToolGiver is missing a SurfaceGui.")
	
	click_detector.MouseClick:Connect(function(player)
		local backpack = player.Backpack

		player.CharacterAdded:Connect(function()
			giveTools(backpack)
		end)
		
		if player.Character == nil then
			return
		end
		
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid == nil then
			return
		end
		
		if humanoid.Health > 0 then
			giveTools(backpack)
		end
	end)

	for _, face in Enum.NormalId:GetEnumItems() do
		if face == Enum.NormalId.Front then
			continue
		end

		local clone = surface_gui:Clone()
		clone.Face = face
		clone.Parent = tool_giver
	end
end)
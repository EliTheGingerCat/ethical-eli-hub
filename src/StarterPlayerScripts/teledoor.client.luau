--!strict

local Players = game:GetService("Players")
local Replicated_Storage = game:GetService("ReplicatedStorage")

local local_player = Players.LocalPlayer

local event_teleport = Replicated_Storage.teleport
local on_tag = require(Replicated_Storage.on_tag)

on_tag("teledoor", function(door): ()
	local id = door:GetAttribute("id") :: number
	local main = door:FindFirstChild("Main") :: BasePart
	main.Touched:Connect(function(part)
		if part.Parent == local_player.Character then
			event_teleport:FireServer(id)
		end
	end)
end)
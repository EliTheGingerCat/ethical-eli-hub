--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local event_teleport = ReplicatedStorage.teleport

local is_Studio = RunService:IsStudio()

event_teleport.OnServerEvent:Connect(function(player, id: number)
	if is_Studio then
		print("Can not teleport in Studio.")
		return
	end
	
	pcall(TeleportService.TeleportAsync, TeleportService, id, {player})
end)
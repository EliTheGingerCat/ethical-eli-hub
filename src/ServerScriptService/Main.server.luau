--!strict

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TeleportService = game:GetService("TeleportService")

local Model2 = require(ReplicatedStorage.Model2)
local SafeService = require(ReplicatedStorage.SafeService)

local gameIds = {9033632869}
local gameData = {}
for _, id in gameIds do
	local info = SafeService.marketplace.productInfo(id)
	if info then
		table.insert(gameData, {description = info.Description, image = info.IconImageAssetId, name = info.Name})
	else
		table.insert(gameData, {description = "Description unavailable.", image = 0, name = "Name unavailable"})
	end
end
ReplicatedStorage.GameInfo.Value = HttpService:JSONEncode(gameData)

-- ==========
-- Teleport
-- ==========
TeleportService.TeleportInitFailed:Connect(SafeService.teleport.failed)

ReplicatedStorage.teleport_old.OnServerInvoke = function(player, index)
	local success = SafeService.teleport.main(gameIds[index], {player}) ~= nil
	
	if success then
		TeleportService:SetTeleportGui(player.PlayerGui.TeleportGui)
	end
	
	return success
end

-- ==========
-- Teledoor
-- ==========
local doorModel = ServerStorage.Teledoor
local platform = workspace.Platform

local ROW_MAX = 8

local dSize = Model2.size(doorModel)
local coordStart = platform.Position + platform.Size/2 + dSize + Vector3.new(-platform.Size.X + 5, 0, -dSize.Z*2 - 5)

for i, info in gameData do
	local clone = doorModel:Clone()
	
	local coordColumn = math.floor((i-1) % ROW_MAX / 2) * (dSize.X + 10)
	local coordRow = -math.floor((i-1) / ROW_MAX) * (dSize.Z + 20)
	local coordSide = if i % 2 == 0 then CFrame.new(0, 0, -dSize.Z - 10) * CFrame.Angles(0, math.rad(180), 0) else CFrame.new()
	clone:PivotTo(CFrame.new(coordStart + Vector3.new(coordColumn, 0, coordRow)) * coordSide)
	
	clone:SetAttribute("index", i)
	
	clone.Main.Color = Color3.fromHSV(i % 10 / 10, 1, 1)
	clone.Main.SurfaceGui.Image.Image = if info.image ~= 0 then `rbxassetid://{info.image}` else "rbxasset://textures/ui/GuiImagePlaceholder.png"
	clone.Parent = workspace.Teledoors
end

ReplicatedStorage.Loaded.Value = true
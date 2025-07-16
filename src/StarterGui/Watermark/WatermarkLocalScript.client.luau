--!strict

-- ==========
-- Services
-- ==========
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ==========
-- Player
-- ==========
local Player = Players.LocalPlayer

-- ==========
-- Package
-- ==========
local package = script.Parent

-- ==========
-- Modules
-- ==========
local SafeService = require(ReplicatedStorage.SafeService)

-- ==========
-- GUI
-- ==========
local gui = package.WatermarkGui

local mF = gui.Main

local tF = gui.Teleport
local tButtons = tF.Buttons


local teleportGui = package.WatermarkTeleportGui
local teleportMain = teleportGui.Main

local gameDataFrom = SafeService.marketplace.productInfo(game.PlaceId)
local gameDataTo = SafeService.marketplace.productInfo(2174833639)
if gameDataFrom and gameDataTo then
	teleportMain.From.Text ..= gameDataFrom.Name
	teleportMain.To.Text ..= gameDataTo.Name
end

-- ==========
-- Buttons on click
-- ==========
local tweenClose = TweenService:Create(mF, TweenInfo.new(1), {Position = UDim2.fromScale(1 + mF.Size.X.Scale, 1)})
mF.Close.MouseButton1Click:Connect(function()
	tweenClose:Play()
	tweenClose.Completed:Connect(function()
		mF.Close.Visible = false
	end)
end)
mF.Teleport.MouseButton1Click:Connect(function()
	tF.Visible = true
end)
tButtons.Cancel.TextButton.MouseButton1Click:Connect(function()
	tF.Visible = false
end)
tButtons.Teleport.TextButton.MouseButton1Click:Connect(function()
	if SafeService.teleport.client(2174833639, Player, nil, teleportGui) then
		for _, gui: Instance in Player.PlayerGui:GetDescendants() do
			if gui:IsA("ScreenGui") then
				gui.Enabled = false
			end
		end
		teleportGui.Enabled = true
	end
end)

-- ==========
-- Buttons on hover
-- ==========
for _, buttonHolder in tButtons:GetChildren() do
	if not buttonHolder:IsA("Frame") then continue end
	
	local buttonReal = buttonHolder.TextButton
	
	local tweenGrow = TweenService:Create(buttonReal, TweenInfo.new(0.1), {Size = UDim2.fromScale(1.1, 1.1)})
	local tweenShrink = TweenService:Create(buttonReal, TweenInfo.new(0.1), {Size = UDim2.fromScale(1, 1)})
	
	buttonReal.MouseEnter:Connect(function()
		tweenGrow:Play()
	end)
	buttonReal.MouseLeave:Connect(function()
		tweenShrink:Play()
	end)
end
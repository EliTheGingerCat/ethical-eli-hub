--!strict

-- ==========
-- Player
-- ==========
local Player = game:GetService("Players").LocalPlayer

-- ==========
-- Services
-- ==========
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ==========
-- Wait for game to load
-- ==========
if not ReplicatedStorage.Loaded.Value then ReplicatedStorage.Loaded:GetPropertyChangedSignal("Value"):Wait() end

local gameInfo = HttpService:JSONDecode(ReplicatedStorage.GameInfo.Value)

-- ==========
-- GUI
-- ==========
local gui = Player.PlayerGui:WaitForChild("ScreenGui")

local mF = gui.Main
local mButtons = mF.Buttons

local teleportGui = Player.PlayerGui:WaitForChild("TeleportGui")
local teleportMain = teleportGui.Main
teleportMain.From.Text ..= gameInfo[1].name

local index

-- ==========
-- Buttons on click
-- ==========
mButtons.Cancel.TextButton.MouseButton1Click:Connect(function()
	mF.Visible = false
end)
mButtons.Teleport.TextButton.MouseButton1Click:Connect(function()
	local success = ReplicatedStorage.teleport_old:InvokeServer(index)
	
	if not success then return end
	
	teleportMain.To.Text ..= gameInfo[index].name
	teleportGui.Enabled = true
	
	gui.Enabled = false
end)

-- ==========
-- Buttons on hover
-- ==========
for _, buttonHolder in mButtons:GetChildren() do
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

-- ==========
-- Open GUI on teledoor touch
-- ==========
for _, teledoor in workspace.Teledoors:GetChildren() do
	teledoor.Main.Touched:Connect(function(hit)
		if hit:IsDescendantOf(Player.Character) then
			index = teledoor:GetAttribute("index")
			
			mF.Title.Text = gameInfo[index].name
			mF.Message.Text = gameInfo[index].description
			
			mF.Visible = true
		end
	end)
end
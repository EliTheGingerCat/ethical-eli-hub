script.Parent.TeleportEvent.OnServerEvent:Connect(function(player, cframe)
	player.character.HumanoidRootPart.CFrame = player.character.HumanoidRootPart.CFrame + cframe
end)
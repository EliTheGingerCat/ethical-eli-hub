local event = script.Parent.ChangeTime

event.OnServerEvent:Connect(function(player, newTime)
	game.Lighting:SetMinutesAfterMidnight(newTime)
end)
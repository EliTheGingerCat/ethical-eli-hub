--[[
Purpose: Additional methods for the Model class.
Features: Size
Created: 2023/09/22
Last edited: 2023/09/22
]]

--!strict

local module = {}

function module.size(model: Model): Vector3
	local edges = Vector3.zero
	
	for _, descendant: Instance in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			for _, letter in {"X", "Y", "Z"} do
				local size = math.abs(descendant.Position[letter] - model:GetPivot().Position[letter]) + descendant.Size[letter] / 2
				if size > edges[letter] then
					if letter == "X" then
						edges = Vector3.new(size, edges.Y, edges.Z)
					elseif letter == "Y" then
						edges = Vector3.new(edges.X, size, edges.Z)
					else
						edges = Vector3.new(edges.X, edges.Y, size)
					end
				end
			end
		end
	end
	
	return edges
end

return module
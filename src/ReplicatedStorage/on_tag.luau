--!strict

local CollectionService = game:GetService("CollectionService")

return function(tag: string, onTag: (instance: Instance) -> ()): ()
	for _, tagged in CollectionService:GetTagged(tag) do
		onTag(tagged)
	end

	CollectionService:GetInstanceAddedSignal(tag):Connect(onTag)
end
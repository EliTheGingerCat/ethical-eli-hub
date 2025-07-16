--!strict

local Marketplace_Service = game:GetService("MarketplaceService")
local Replicated_Storage = game:GetService("ReplicatedStorage")

local on_tag = require(Replicated_Storage.on_tag)

local function get_product_info(assetId: number, infoType: Enum.InfoType?): {AssetId: number, AssetTypeId: number, CanBeSoldInThisGame: boolean, ContentRatingTypeId: number, Created: string, Creator: {CreatorTargetId: number, CreatorType: "Group" | "User", HasVerifiedBadge: boolean, Id: number, Name: string}, Description: string, IconImageAssetId: number, IsForSale: boolean, IsLimited: boolean, IsLimitedUnique: boolean, IsNew: boolean, IsPublicDomain: boolean, MinimumMembershipLevel: number, Name: string, PriceInRobux: number, ProductId: number, Remaining: number, SaleAvailabilityLocations: {}, Sales: number, Updated: string}?
	local success, results = pcall(Marketplace_Service.GetProductInfo, Marketplace_Service, assetId, infoType)

	if success then
		return results
	else
		return warn(`Error while getting product info: {results}`)
	end
end

on_tag("teledoor", function(door)
	local id = door:GetAttribute("id") :: number
	local info = get_product_info(id)
	local image_label = door:FindFirstChild("Main"):FindFirstChild("SurfaceGui"):FindFirstChild("Image") :: ImageLabel
	if info then
		image_label.Image = `rbxassetid://{info.IconImageAssetId}`
	else
		image_label.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	end
end)
--[[
Purpose: Makes protected asynchronous calls from services and provides better type checking.
Features: BadgeService, DataStoreService, HttpService, TeleportService, TextService
Created: 2023/09/11
Last edited: 2023/09/22
Credits: https://create.roblox.com/docs/reference/engine/classes/BadgeService, https://create.roblox.com/docs/reference/engine/classes/HttpService, https://create.roblox.com/docs/reference/engine/classes/MarketplaceService, https://create.roblox.com/docs/projects/teleporting, https://create.roblox.com/docs/ui/text-filtering
Further reading: https://create.roblox.com/docs/reference/engine/classes/BadgeService, https://create.roblox.com/docs/reference/engine/classes/DataStoreService, https://create.roblox.com/docs/reference/engine/classes/HttpService, https://create.roblox.com/docs/reference/engine/classes/MarketplaceService, https://create.roblox.com/docs/reference/engine/classes/TeleportService, https://create.roblox.com/docs/reference/engine/classes/TextService, https://create.roblox.com/docs/reference/engine/classes/TextFilterResult
Notes: The type checking (especially on HTTP request) is the main feature, since the pcall stuff is easy enough to add directly in scripts. Overall, this module is pretty useless.
]]

--!strict

local module = {
	badge = {},
	datastore = {},
	http = {},
	marketplace = {},
	teleport = {},
	text = {}
}

local BadgeService = game:GetService("BadgeService")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TextService = game:GetService("TextService")

function module.badge.info(badgeId: number): {Name: string, Description: string, IconImageId: number, IsEnabled: boolean}?
	local success, results = pcall(BadgeService.GetBadgeInfoAsync, BadgeService, badgeId)
	
	if success then
		return results
	else
		warn(`Error while fetching Badge information: {results}`)
	end
	
	return
end

function module.badge.award(userId: number, badgeId: number): boolean?
	local info = module.badge.info(badgeId)
	if info and info.IsEnabled then
		local success, results = pcall(BadgeService.AwardBadge, BadgeService, userId, badgeId)
		
		if success then
			return results
		else
			warn(`Error while awarding Badge: {results}`)
		end
	end
	
	return
end

function module.badge.has(userId: number, badgeId: number): boolean?
	local success, results = pcall(BadgeService.UserHasBadgeAsync, BadgeService, userId, badgeId)
	
	if success then
		return results
	else
		warn(`Error while fetching if player has Badge: {results}`)
	end
	
	return
end

function module.datastore.get(store: GlobalDataStore, key: string, options: DataStoreGetOptions?): any
	local success, results = pcall(store.GetAsync, store, key, options)
	
	if success then
		return results
	else
		return warn(`Error while getting DataStore value: {results}`)
	end
end

function module.datastore.increment(store: GlobalDataStore, key: string, delta: number?, userIds: {any}?, options: DataStoreIncrementOptions?): any
	local success, results = pcall(store.IncrementAsync, store, key, delta, userIds, options)
	
	if success then
		return results
	else
		return warn(`Error while incrementing DataStore key: {results}`)
	end
end

function module.datastore.list(prefix: string?, pageSize: number?, cursor: string?): DataStoreListingPages?
	local success, results = pcall(DataStoreService.ListDataStoresAsync, DataStoreService, prefix, pageSize, cursor)
	
	if success then
		return results
	else
		return warn(`Error while fetching DataStores: {results}`)
	end
end

function module.datastore.remove(store: GlobalDataStore, key: string): any
	local success, results = pcall(store.RemoveAsync, store, key)
	
	if success then
		return results
	else
		return warn(`Error while removing DataStore key: {results}`)
	end
end

function module.datastore.set(store: GlobalDataStore, key: string, value: any, userIds: {any}?, options: DataStoreSetOptions?): any
	local success, results = pcall(store.SetAsync, store, key, value, userIds, options)
	
	if success then
		return results
	else
		return warn(`Error while setting DataStore key: {results}`)
	end
end

function module.datastore.update(store: GlobalDataStore, key: string, transformFunction: any): any
	local success, results = pcall(store.UpdateAsync, store, key, transformFunction)
	
	if success then
		return results
	else
		return warn(`Error while updating DataStore key: {results}`)
	end
end

function module.http.request(requestOptions: {Url: string, Method: ("CONNECT" | "DELETE" | "GET" | "HEAD" | "OPTIONS" | "PATCH" | "POST" | "PUT" | "TRACE")?, Headers: {Accept: any?, ["Cache-Control"]: any?, ["Content-Type"]: "application/json" | "application/xml" | "application/x-www-form-unencoded" | "text/plain" | "text/xml"}?, Body: string?}): {Success: boolean, StatusCode: number, StatusMessage: string, Headers: {}, Body: string?}?
	local success, results = pcall(HttpService.RequestAsync, HttpService, requestOptions)
	
	if success then
		return results
	else
		return warn(`Error while sending Http request: {results}`)
	end
end

function module.marketplace.productInfo(assetId: number, infoType: Enum.InfoType?): {AssetId: number, AssetTypeId: number, CanBeSoldInThisGame: boolean, ContentRatingTypeId: number, Created: string, Creator: {CreatorTargetId: number, CreatorType: "Group" | "User", HasVerifiedBadge: boolean, Id: number, Name: string}, Description: string, IconImageAssetId: number, IsForSale: boolean, IsLimited: boolean, IsLimitedUnique: boolean, IsNew: boolean, IsPublicDomain: boolean, MinimumMembershipLevel: number, Name: string, PriceInRobux: number, ProductId: number, Remaining: number, SaleAvailabilityLocations: {}, Sales: number, Updated: string}?
	local success, results = pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId, infoType)
	
	if success then
		return results
	else
		return warn(`Error while getting product info: {results}`)
	end
end

function module.teleport.main(placeId: number, players: {Player}, teleportOptions: TeleportOptions?): TeleportAsyncResult?
	if game:GetService("RunService"):IsStudio() then return warn("Cannot teleport in Studio!") end
	
	local teleportees = {}
	for _, player in players do
		if not player:GetAttribute("IsTeleporting") then
			table.insert(teleportees, player)
		end
	end
	
	local attemptIndex = 0
	local success, results
	
	repeat
		success, results = pcall(TeleportService.TeleportAsync, TeleportService, placeId, teleportees, teleportOptions)
		attemptIndex += 1
		if not success then
			task.wait(1)
		end
	until success or attemptIndex == 5
	
	if success then
		for _, player in players do
			player:SetAttribute("IsTeleporting", true)
		end
		return results
	else
		return warn(`Error while teleporting: {results}`)
	end
end

function module.teleport.client(placeId: number, player: Player?, teleportData: ({any} | boolean | number | string)?, customLoadingScreen: ScreenGui?): true?
	if game:GetService("RunService"):IsStudio() then return warn("Cannot teleport in Studio!") end
	
	if not player then player = Players.LocalPlayer end
	if not player then return end
	if player:GetAttribute("IsTeleporting") then return end
	
	local attempt = 0
	local success, results
	
	repeat
		success, results = pcall(TeleportService.Teleport, TeleportService, placeId, player, teleportData, customLoadingScreen)
		attempt += 1
		if not success then
			task.wait(1)
		end
	until success or attempt >= 5
	
	if success then
		player:SetAttribute("IsTeleporting", true)
		return true
	else
		return warn(`Error while teleporting: {results}`)
	end
end

function module.teleport.failed(player: Player, teleportResult: Enum.TeleportResult, errorMessage: string, placeId: number, teleportOptions: TeleportOptions)
	if teleportResult == Enum.TeleportResult.Flooded then
		task.wait(15)
	elseif teleportResult == Enum.TeleportResult.Failure then
		task.wait(1)
	else
		error(`Invalid teleport ({teleportResult.Name}):, {errorMessage}`)
	end
	
	player:SetAttribute("IsTeleporting", false)
	
	module.teleport.main(placeId, {player}, teleportOptions)
end

function module.text.filterString(stringToFilter: string, fromUserId: number, textContent: Enum.TextFilterContext?): TextFilterResult?
	local success, results = pcall(TextService.FilterStringAsync, TextService, stringToFilter, fromUserId, textContent)
	
	if success then
		return results
	else
		return warn(`Error while filtering string: {results}`)
	end
end

function module.text.userChat(text: TextFilterResult, toUserId: number): string?
	local success, results = pcall(text.GetChatForUserAsync, text, toUserId)
	
	if success then
		return results
	else
		return warn(`Error while getting user chat filtered string: {results}`)
	end
end

function module.text.broadcast(text: TextFilterResult): string?
	local success, results = pcall(text.GetNonChatStringForBroadcastAsync, text)
	
	if success then
		return results
	else
		return warn(`Error while getting broadcast filtered string: {results}`)
	end
end

function module.text.userOther(text: TextFilterResult, toUserId: number): string?
	local success, results = pcall(text.GetNonChatStringForUserAsync, text, toUserId)
	
	if success then
		return results
	else
		return warn(`Error while getting user non-chat filtered string: {results}`)
	end
end

return module
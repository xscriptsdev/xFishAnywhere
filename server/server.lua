ESX, QBCore = nil, nil

if GetResourceState("es_extended") == "started" then
    ESX = exports["es_extended"]:getSharedObject()
elseif GetResourceState("qb-core") == "started" then
    QBCore = exports["qb-core"]:GetCoreObject()
end

local function HasFishingRod(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getInventoryItem(Config.RequiredItem).count > 0
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player.Functions.GetItemByName(Config.RequiredItem) ~= nil
    end
    return false
end

local function RemoveFishingRod(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(Config.RequiredItem, 1)
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.RemoveItem(Config.RequiredItem, 1)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.RequiredItem], "remove")
    end
end

local function GiveFishingReward(source)
    local reward = Config.FishingRewards[math.random(1, #Config.FishingRewards)]
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(reward, 1)
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddItem(reward, 1)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[reward], "add")
    end

end

RegisterNetEvent("xFishAnywhere:catchFish")
AddEventHandler("xFishAnywhere:catchFish", function()
    local source = source
    if not HasFishingRod(source) then
        TriggerClientEvent("lib:notify", source, { title = "Fishing", description = "You don't have a fishing rod!", type = "error" })
        return
    end
    GiveFishingReward(source)
    TriggerClientEvent("lib:notify", source, { title = "Fishing", description = "You caught a fish!", type = "success" })
end)

RegisterNetEvent("xFishAnywhere:breakRod")
AddEventHandler("xFishAnywhere:breakRod", function()
    local source = source
    if HasFishingRod(source) then
        RemoveFishingRod(source)
    end
end)

ESX.RegisterUsableItem(Config.RequiredItem, function(source)
    TriggerClientEvent("xFishAnywhere:useRod", source)
end)

QBCore.Functions.CreateUseableItem(Config.RequiredItem, function(source)
    TriggerClientEvent("xFishAnywhere:useRod", source)
end)

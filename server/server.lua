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
        return
    end
    GiveFishingReward(source)
end)

RegisterNetEvent("xFishAnywhere:breakRod")
AddEventHandler("xFishAnywhere:breakRod", function()
    local source = source
    if HasFishingRod(source) then
        RemoveFishingRod(source)
    end
end)

    if ESX then
        ESX.RegisterUsableItem(Config.RequiredItem, function(source)
            local xPlayer = ESX.GetPlayerFromId(source)
            local bait = xPlayer.getInventoryItem(Config.RequiredBait)
            
            if bait and bait.count > 0 then
                xPlayer.removeInventoryItem(Config.RequiredBait, 1)
                TriggerClientEvent("xFishAnywhere:useRod", source)
            else
                TriggerClientEvent('xFishAnywhere:notify', source, Config.YouNeedBait, 'error')
            end
        end)
    elseif QBCore then
        QBCore.Functions.CreateUseableItem(Config.RequiredItem, function(source)
            local Player = QBCore.Functions.GetPlayer(source)
            local bait = Player.Functions.GetItemByName(Config.RequiredBait)
            
            if bait and bait.amount > 0 then
                Player.Functions.RemoveItem(Config.RequiredBait, 1)
                TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.RequiredBait], "remove")
                TriggerClientEvent("xFishAnywhere:useRod", source)
            else
                TriggerClientEvent('QBCore:Notify', source, 'You need fishing bait to fish!', 'error')
            end
        end)
    end

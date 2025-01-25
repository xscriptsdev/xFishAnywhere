local isFishing = false
local failStreak = 0

local function IsNearWater()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local _, hit, _, _, _ = TestProbeAgainstWater(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z - 5.0)
    return hit and IsPedOnFoot(ped)
end

local function isWaterThere()
    local ped = PlayerPedId()
    local headCoords = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, -1.5)
    local hasWater = TestProbeAgainstWater(headCoords.x, headCoords.y, headCoords.z, coords.x, coords.y, coords.z)
    return hasWater
end

local function StartFishing()
    if isFishing then
        lib.notify({ title = "Fishing", description = "You are already fishing!", type = "error" })
        return
    end

    local ped = PlayerPedId()
    if not IsNearWater() or not isWaterThere() then
        lib.notify({ title = "Fishing", description = "You need to be standing in front of water to fish!", type = "error" })
        return
    end

    isFishing = true
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true)

    local success = lib.skillCheck({ 'easy', 'easy', { areaSize = 60, speedMultiplier = 2 }, 'easy' }, { 'w', 'w', 'w', 'w' })

    ClearPedTasksImmediately(ped)
    
    isFishing = false

    if success then
        failStreak = 0
        TriggerServerEvent("xFishAnywhere:catchFish")
        lib.notify({ title = "Fishing", description = "You caught a fish!", type = "success" })
    else
        failStreak = failStreak + 1
        lib.notify({ title = "Fishing", description = "You failed to catch anything!", type = "error" })
        if Config.BreakRodAfterFails and failStreak >= Config.FailAttemptsToBreak then
            failStreak = 0
            TriggerServerEvent("xFishAnywhere:breakRod")
            lib.notify({ title = "Fishing", description = "Your fishing rode broke!", type = "error" })
        end
    end
end

RegisterNetEvent("xFishAnywhere:useRod")
AddEventHandler("xFishAnywhere:useRod", function()
    StartFishing()
end)

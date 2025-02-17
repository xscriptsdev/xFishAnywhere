local isFishing = false
local failStreak = 0
local fishingRodProp = nil

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


RegisterNetEvent('xFishAnywhere:notify')
AddEventHandler('xFishAnywhere:notify', function(message, type)
    lib.notify({ title = Config.Title, description = message, type = type })
end)

local function StartFishing()
    if isFishing then
        lib.notify({ title = Config.Title, description = Config.AlreadyFishing, type = "error" })
        return
    end

    local ped = PlayerPedId()
    if not IsNearWater() or not isWaterThere() then
        lib.notify({ title = Config.Title, description = Config.StandInFrontOfWater, type = "error" })
        return
    end

    lib.requestAnimDict('amb@world_human_stand_fishing@idle_a')
    lib.requestAnimDict('mini@tennis')

    isFishing = true
    TaskPlayAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_b', 8.0, -1.0, -1, 50, 0, false, false, false)

    fishingRodProp = CreateObject(GetHashKey("prop_fishing_rod_01"), 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(fishingRodProp, ped, GetPedBoneIndex(ped, 57005), 0.1, 0.02, -0.01, 30.0, 40.0, 50.0, true, true, false, true, false, true)

    local success = lib.skillCheck({ Config.Skillcheck1, Config.Skillcheck2, { areaSize = Config.areaSize, speedMultiplier = Config.speedMultiplier }, Config.Skillcheck3 }, { Config.SkillKey1, Config.SkillKey2, Config.SkillKey3, Config.SkillKey4 })

    ClearPedTasksImmediately(ped)

    if fishingRodProp then
        DeleteObject(fishingRodProp)
        fishingRodProp = nil
    end
    isFishing = false

    if success then
        failStreak = 0
        TriggerServerEvent("xFishAnywhere:catchFish")
        lib.notify({ title = Config.Title, description = Config.FishCaught, type = "success" })
    else
        failStreak = failStreak + 1
        lib.notify({ title = Config.Title, description = "You failed to catch anything!", type = "error" })
        if Config.BreakRodAfterFails and failStreak >= Config.FailAttemptsToBreak then
            failStreak = 0
            TriggerServerEvent("xFishAnywhere:breakRod")
            lib.notify({ title = Config.Title, description = Config.FishingRodBroke, type = "error" })
        end
    end
end

RegisterNetEvent("xFishAnywhere:useRod")
AddEventHandler("xFishAnywhere:useRod", function()
    StartFishing()
end)

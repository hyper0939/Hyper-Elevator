---@diagnostic disable: undefined-global
local ESX = exports['es_extended']:getSharedObject()

local playerCooldowns = {}

local function HasJobAccess(source, elevator)
    if not elevator.job then return true end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    return xPlayer.job.name == elevator.job
end

--#region Lib
lib.callback.register("hyper_elevator:Server:CanUse", function(source, elevatorKey)
    local elevator = Config.Elevators[elevatorKey]
    if not elevator then return end

    return HasJobAccess(source, elevator)
end)

lib.callback.register("hyper_elevator:Server:RequestTeleport", function(source, elevatorKey, floorId)
    local elevator = Config.Elevators[elevatorKey]
    if not elevator then
        return { success = false, reason = Config.Languagues["elevator_not_found"] }
    end

    local floor = nil
    for _, f in pairs(elevator.floors) do
        if f.id == floorId then
            floor = f
            break
        end
    end

    if not floor then
        return { success = false, reason = Config.Languagues["floor_not_found"] }
    end

    if not HasJobAccess(source, elevator) then
        return { success = false, reson = Config.Languagues["no_access"] }
    end

    -- Cooldown
    local now = GetGameTimer()
    local lastUse = playerCooldowns[source]

    if lastUse and (now- lastUse) < Config.TeleportCooldown then
        return { success = false, reason = Config.Languagues["cooldownn"] }
    end

    -- Distance check
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then
        return { success = false, reason = Config.Languagues["player_not_found"] }
    end

    local pedCoords = GetEntityCoords(ped)
    local main = elevator.mainCoords
    local dist = #(pedCoords - vector3(main.x, main.y, main.z))

    if dist > Config.MaxTeleportDistance then
        return { success = false, reason = Config.Languagues["distance"] }
    end

    playerCooldowns[source] = now

    return { success = true }
end)

AddEventHandler("playerDropped", function()
    playerCooldowns[source] = nil
end)
--#endregion

--#region Events
RegisterNetEvent("hyper_elevator:Server:CanUse")
AddEventHandler("hyper_elevator:Server:CanUse", function(source, elevatorKey)
    local elevator = Config.Elevators[elevatorKey]
    if not elevator then return end

    if elevator.job then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end

        if xPlayer.job.name ~= elevator.job then
            return false
        end
    end

    return true
end)

RegisterNetEvent("hyper_elevator:Server:RequestTeleport")
AddEventHandler("hyper_elevator:Server:RequestTeleport", function(source, elevatorKey, floorId)
    local elevator = Config.Elevators[elevatorKey]
    if not elevator then
        return { success = false, reason = Config.Languagues["elevator_not_found"] }
    end

    local floor = nil
    for _, f in pairs(elevator.floors) do
        if f.id == floorId then
            floor = f
            break
        end
    end

    if not floor then
        return { success = false, reason = Config.Languagues["floor_not_found"] }
    end

    if not HasJobAccess(source, elevator) then
        return { success = false, reson = Config.Languagues["no_access"] }
    end

    -- Cooldown
    local now = GetGameTimer()
    local lastUse = playerCooldowns[source]

    if lastUse and (now- lastUse) < Config.TeleportCooldown then
        return { success = false, reason = Config.Languagues["cooldownn"] }
    end

    -- Distance check
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then
        return { success = false, reason = Config.Languagues["player_not_found"] }
    end

    local pedCoords = GetEntityCoords(ped)
    local main = elevator.mainCoords
    local dist = #(pedCoords - vector3(main.x, main.y, main.z))

    if dist > Config.MaxTeleportDistance then
        return { success = false, reason = Config.Languagues["distance"] }
    end

    playerCooldowns[source] = now

    return { success = true }
end)
--#endregion


--#region Logging
RegisterNetEvent("hyper_elevator:Server:Log", function(elevatorKey, floorId)
end)

--#region
-- // Github \\ --
local ResourceName = GetCurrentResourceName()

local GITHUB_USER = "hyper0939"
local GITHUB_REPO = "Hyper-Elevator"
local GITHUB_BRANCH = "main"

local function GetCurrentVersion()
    local manifest = LoadResourceFile(ResourceName, "fxmanifest.lua")
    if not manifest then return "unkown" end
    return manifest:match("version%s*['\"]([%d%.]+)['\"]") or "unknown"
end

local function CheckForUpdate()
    local currentVersion = GetCurrentVersion()

    PerformHttpRequest(("https://raw.githubusercontent.com/%s/%s/%s/hyper_elevator/fxmanifest.lua"):format(GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH),
    function (status, body, headers)
        if status ~= 200 or not body then
            print(("^3[%s] ^7 Update-Check failed (HTTP %s)"):format(ResourceName, status))
            return
        end

        local latestVersion = body:match("version%s*['\"]([%d%.]+)['\"]") or "unknown"
        if not latestVersion then
            print(("^3[%s] ^7Could not read the GitHub version."):format(ResourceName))
            return
        end

        if currentVersion == latestVersion then
            print(("^9[%s] ^7Currently up to date. (v%s)"):format(ResourceName, currentVersion))
        else
            print(("^3[%s] ^7Update available! Installed ^1v%s ^7=> New: ^2v%s"):format(ResourceName, currentVersion, latestVersion))
            print(("^3[%s] ^7Download https://github.com/%s/%s"):format(ResourceName, GITHUB_USER, GITHUB_REPO))
        end
    end, "GET", "", { ["Content-Type"] = "application/json" }
    )
end

AddEventHandler("onResourceStart", function(resource)
    if resource ~= ResourceName then return end

    Citizen.SetTimeout(3000, CheckForUpdate)
end)
--#endregion
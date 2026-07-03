---@diagnostic disable: param-type-mismatch, undefined-global
local ESX = exports['es_extended']:getSharedObject()

local isElevatorOpen = false
local currentElevatorKey = nil

--#region Teleport
local function TeleportToFloor(elevatorKey, floor)
    local ped = PlayerPedId()
    local elevator = Config.Elevators[elevatorKey]

    if IsEntityDead(ped) then
        if Config.UseCustomNotify then
            Config.Notify(Config.Languagues["notify_title"], Config.Languagues["dead"], Config.Languagues["error_type"], Config.Languagues["dead_notify_duration"])
        else
            if Config.UseLib then
                lib.notify({
                    title = Config.Languagues["notify_title"],
                    description = Config.Languagues["dead"],
                    type = "error"
                })
            end
        end
        return
    end

    local allowVehicle = elevator.allowVehicle
    if allowVehicle == nil then
        allowVehicle = Config.AllowVehicleTeleport
    end

    if IsPedInAnyVehicle(ped, false) and not allowVehicle then
        if Config.UseCustomNotify then
            Config.Notify(Config.Languagues["notify_title"], Config.Languagues["vehicle"], Config.Languagues["error_type"], Config.Languagues["vehicle_notify_duration"])
        else
            if Config.UseLib then
                lib.notify({
                    title = Config.Languagues["notify_title"],
                    description = Config.Languagues["vehicle"],
                    type = "error"
                })
            end
        end
        return
    end

    SendNUIMessage({ action = "Hide" })
    SetNuiFocus(false, false)
    isElevatorOpen = false

    DoScreenFadeOut(Config.TeleportFadeTime)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    FreezeEntityPosition(ped, true)

    local coords = floor.coords
    SetEntityCoords(ped ,coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(ped, coords.w)

    Wait(500)

    FreezeEntityPosition(ped, false)

    DoScreenFadeIn(Config.TeleportFadeTime)
    while not IsScreenFadedIn() do
        Wait(0)
    end

    Config.Notify(Config.Languagues["notify_title"], Config.Languagues["success"], Config.Languagues["success_type"], Config.Languagues["success_notify_duration"])

    TriggerServerEvent("hyper_elevator:Server:Log", elevatorKey, floor.id)
end
--#endregion

--#region NUI Callback
RegisterNUICallback("Confirm", function(data, cb)
    local elevator = Config.Elevators[currentElevatorKey]
    if elevator then
        for _, floor in pairs(elevator.floors) do
            if floor.id == data.id then
                TeleportToFloor(currentElevatorKey, floor)
                break
            end
        end
    end
    cb({})
end)

RegisterNUICallback("Close", function(data, cb)
    SendNUIMessage({ action = "Hide" })
    SetNuiFocus(false, false)
    isElevatorOpen = false
    cb({})
end)
--#endregion

--#region Open
local function Return(elevatorKey)
    return TriggerServerEvent("hyper_elevator:Server:CanUse", false, elevatorKey)
end

local function OpenElevator(elevatorKey)
    if isElevatorOpen then return end

    local elevator = Config.Elevators[elevatorKey]
    if not elevator then return end

    if elevator.job then
        local hasAccess = nil

        if Config.UseLib then
            hasAccess = lib.callback.await("hyper_elevator:Server:CanUse", false, elevatorKey)
        else
            hasAccess = Return(elevatorKey)
        end

        if not hasAccess then
            if Config.UseCustomNotify then
                Config.Notify(Config.Languagues["notify_title"], Config.Languagues["job"], Config.Languagues["error_type"], Config.Languagues["job_notify_duration"])
            else
                if Config.UseLib then
                    lib.notify({
                        title = Config.Languagues["notify_title"],
                        description = Config.Languagues["job"],
                        type = "error"
                    })
                end
            end
            return
        end
    end

    currentElevatorKey = elevatorKey
    isElevatorOpen = false

    local floorsPayLoad = {}
    for _, floor in pairs(elevator.floors) do
        floorsPayLoad[#floorsPayLoad + 1] = { id = floor.id, name = floor.name }
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "Show",
        info = elevator.info,
        floors = floorsPayLoad
    })
end
--#endregion

--#region Interaction
CreateThread(function()
    if not Config.UseTarget then return end

    for elevatorKey, elevator in pairs(Config.Elevators) do
        exports.ox_target:addBoxZone({
                coords = vector3(elevator.mainCoords.x, elevator.mainCoords.y, elevator.mainCoords.z),
                size = vector3(1.5, 1.5, 2),
                rotation = elevator.mainCoords.w,
                debug = true,
                options = {
                    {
                        name = ("hyper_elevator_%s_%s"):format(elevatorKey, elevator.id),
                        icon = "fas fa-elevator",
                        label = ("Aufzug benutzen (%s)"):format(elevator.label),
                        onSelect = function()
                            OpenElevator(elevatorKey)
                        end
                    }
                }
            })
    end
end)

CreateThread(function()
    if Config.UseTarget then return end

    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local closestKey, closestDist = nil, nil

        for elevatorKey, elevator in pairs(Config.Elevators) do
            local main = elevator.mainCoords
            local mainCoords = vector3(main.x, main.y, main.z)
            local dist = #(pedCoords - mainCoords)

            if dist < Config.MarkerDrawDistance then
                sleep = 0

                DrawMarker(Config.MarkerType, mainCoords.x, mainCoords.y, mainCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100,
                Config.UpAndDown, true, 2, false, nil, nil, false)

                if not closestDist or dist < closestDist then
                    closestDist = dist
                    closestKey = elevatorKey
                end
            end
        end

        if closestDist and closestDist < Config.InteractionDistance and not isElevatorOpen then
            if Config.UseLib then
                lib.showTextUI(Config.Languagues["helpnotificaiton_msg"])
            else
                if Config.UseCustomHelpnotification then
                    Config.HelpNotification()
                else
                    ESX.ShowHelpNotification(Config.Languagues["helpnotificaiton_msg"], false, false, 0)
                end
            end

            if IsControlJustPressed(0, Config.OpenControl) then
                OpenElevator(closestKey)
            end
        else
            if Config.UseLib then
                lib.hideTextUI()
            end
        end
        Wait(sleep)
    end
end)
--#endregion

--#region Server side close
RegisterNetEvent("hyper_elevator:Client:Close", function()
    SendNUIMessage({ action = "Hide" })
    SetNuiFocus(false, false)
    isElevatorOpen = false
end)
local ESX = exports['es_extended']:getSharedObject()

lib.callback.register("hyper_elevator:Server:CaUse", function(source, elevatorKey)
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

--#region Logging
RegisterNetEvent("hyper_elevator:Server:Log", function(elevatorKey, floorId)
end)
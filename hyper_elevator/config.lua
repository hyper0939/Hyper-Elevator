Config = {}

Config.UseTarget = false
Config.OpenControl = 38 -- E
Config.MarkerType = 1
Config.MarkerSize = vector3(1.5, 1.5, 1.5)
Config.MarkerColor = { r = 0, g = 0, b = 100 }
Config.UpAndDown = true
Config.InteractionDistance = 1.5
Config.MarkerDrawDistance = 10.0

Config.TeleportFadeTime = 500

Config.AllowVehicleTeleport = false

Config.Elevators = {
    ["Pillbox"] = {
        label = "Pillbox Hospital",
        info = "Wähle eine Etage aus, um dorthin zu gelangen",
        job = nil, -- "ambulance"
        allowVehicle = false, -- override Config.AllowVehicleTeleport for this Elevator

        floors = {
            {
                id = 1,
                name = "Garage",
                coords = vec4
            },
            {
                id = 2,
                name = "Lobby",
                coords = vec4
            },
            {
                id = 3,
                name = "Roof",
                coords = vec4
            },
        }
    },
}

Config.UseCustomNotify = true -- if true then ox_lib notify 
Config.Notify = function(server, source, title, message, type, duration)
    if server then
        exports["hyper_notify"]:Notify(source, title, message, type, duration)
    else
        exports["hyper_notify"]:Notify(title, message, type, duration)
    end
end

Config.Languagues = {
    ["notify_title"] = "Elevator",
    ["info_type"] = "Info",
    ["error_type"] = "Error",
    ["warning_type"] = "Warning",
    ["success_type"] = "Success",

    ["dead_notify_duration"] = 4000,
    ["dead"] = "Du kannst als Toter den Aufzug nicht benutzen.",

    ["vehicle_notify_duration"] = 5000,
    ["vehicle"] = "Du kannst mit einem Fahrzeug diesen Aufzug nicht benutzen.",

    ["job_notify_duration"] = 5000,
    ["job"] = "Du hast kein Zugriff auf diesen Aufzug.",
}
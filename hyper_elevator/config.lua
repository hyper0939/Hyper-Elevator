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
Config.TeleportCooldown = 3000 -- 3 Seconds
Config.MaxTeleportDistance = 5.0 -- The distance between mainCoords - player
Config.AllowVehicleTeleport = false

Config.EnableBlips = true
Config.BlipSprite = 372
Config.BlipColor = 3
Config.BlipScale = 0.8

Config.Elevators = {
    ["Pillbox"] = {
        label = "Pillbox Hospital",
        info = "Wähle eine Etage aus, um dorthin zu gelangen",
        job = nil, -- "ambulance"
        allowVehicle = false, -- override Config.AllowVehicleTeleport for this Elevator
        mainCoords = vector4(419.3043, -1635.8181, 29.2919, 90.1318),

        floors = {
            {
                id = 1,
                name = "Garage",
                coords = vector4(408.4610, -1630.5187, 29.2919, 43.3527)
            },
            {
                id = 2,
                name = "Lobby",
                coords = vector4(405.7419, -1633.6831, 29.2919, 55.0953)
            },
            {
                id = 3,
                name = "Roof",
                coords = vector(401.2885, -1638.9774, 29.2919, 48.8157)
            },
        }
    },
}

Config.UseCustomNotify = true -- if true then ox_lib notify 
Config.Notify = function(title, message, type, duration)
    exports["hyper_notify"]:Notify(title, message, type, duration)
end

Config.UseCustomHelpnotification = true -- If false then ESX.ShowHelpNotification(msg, thisFrame, beep, duration)
Config.UseLib = false -- Notify and textui
Config.HelpNotification = function()
    TriggerEvent("revolution_helpnotify:showHelpNotify", Config.Languagues["helpnotificaiton_msg"], "E")
end

Config.Languagues = {
    ["notify_title"] = "Elevator",
    ["info_type"] = "Info",
    ["error_type"] = "Error",
    ["warning_type"] = "Warning",
    ["success_type"] = "Success",
    ["helpnotificaiton_msg"] = "[E] Aufgzug benutzen",

    ["dead_notify_duration"] = 4000,
    ["dead"] = "Du kannst als Toter den Aufzug nicht benutzen.",

    ["vehicle_notify_duration"] = 5000,
    ["vehicle"] = "Du kannst mit einem Fahrzeug diesen Aufzug nicht benutzen.",

    ["job_notify_duration"] = 5000,
    ["job"] = "Du hast kein Zugriff auf diesen Aufzug.",

    ["success_notify_duration"] = 3500,
    ["success"] = "Du hast dich erfolgreich Teleportiert",

    ["teleport_error"] = "Teleport fehlgeschlagen",
    ["teleport_error_duration"] = 4000,

    ["elevator_not_found"] = "Aufzug existiert nicht.",
    ["floor_not_found"] = "Etage existiert nicht.",
    ["no_access"] = "Kein Zugriff auf diesen Aufzug.",
    ["cooldownn"] = "Bitte warte kurz, bevor du den Aufzug erneut benutzt.",
    ["player_not_found"] = "Spieler nicht gefunden.",
    ["distance"] = "Du bist zu weit vom Aufzug entfernt."
}
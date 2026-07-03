fx_version "cerulean"
game "gta5"

author "Hyper"
version "0.0.1"

client_scripts {
    "Code/client-side.lua"
}

server_scripts {
    "Code/server-side.lua"
}

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua"
}

dependcies {
    "ox_lib",
    "oxmysql",
    "ox_target" -- If Config.UseTarget = true
}

ui_page "UI/index.html"

files {
    "UI/*.html",
    "UI/*.css",
    "UI/*.js",
    "UI/images/*.png",
    "UI/fonts/*.woff",
    "UI/fonts/*.otf"
}
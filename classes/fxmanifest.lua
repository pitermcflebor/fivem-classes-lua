fx_version 'cerulean'
games { 'gta5' }

developer 'PiterMcFlebor'
version '1.0'
description 'Classes for FiveM with Lua'

client_scripts {
    'misc/client/callbacks.lua',

    -- @importable scripts ↓
    'client/utils.lua',
    'client/coords.lua',
    'client/vehicle.lua',
    'client/ped.lua',
    'client/player.lua',
    'client/marker.lua',
    -- end here ↑↑

    'misc/client/props.lua',
}

server_scripts {
    'misc/server/callbacks.lua',

    -- @importable scripts ↓
    'server/utils.lua',
    'server/coords.lua',
    'server/ped.lua',
    'server/player.lua',
    'server/vehicle.lua',
}

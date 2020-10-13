fx_version 'cerulean'
games { 'gta5' }

developer 'PiterMcFlebor'
version '1.0'
description 'Classes for FiveM with Lua'

client_scripts {
	'misc/client/main.lua',
	'misc/client/callbacks.lua',

	-- @importable scripts ↓
	'client/utils.lua',
	'client/coords.lua',
	'client/statebag.lua',
	'client/vehicle.lua',
	'client/ped.lua',
	'client/player.lua',
	'client/marker.lua',
	'client/prop.lua',
	-- end here ↑↑

	'misc/client/vehicle_props.lua',
	'misc/client/states.lua',
}

server_scripts {
	'misc/server/main.lua',
	'misc/server/callbacks.lua',
	'misc/server/states.lua',

	-- @importable scripts ↓
	'server/utils.lua',
	'server/coords.lua',
	'server/statebag.lua',
	'server/prop.lua',
	'server/ped.lua',
	'server/player.lua',
	'server/vehicle.lua',
}

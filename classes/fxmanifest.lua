fx_version 'cerulean'
games { 'gta5' }

developer 'PiterMcFlebor'
version '0.2.3'
description [[

Classes script created by PiterMcFlebor (2020)

Don't need anymore to @import the classes!
Check the manual at:
https://pitermcflebor.github.io/tutorial

]]

disable_version_check 'no'				-- set this to 'yes' if you don't want to check the current version
disable_version_check_message 'no'		-- set this to 'yes' if you only want to disable the 'is up to date' message log

client_scripts {
	'misc/client/main.lua',
	'misc/client/callbacks.lua',
	'import.lua',
	'client/utils.lua',
	'client/coords.lua',
	'client/statebag.lua',
	'client/vehicle.lua',
	'client/ped.lua',
	'client/player.lua',
	'client/marker.lua',
	'client/prop.lua',
	'misc/client/common.lua',
	'misc/client/vehicle_props.lua',
	'misc/client/states.lua',
}

server_scripts {
	'misc/server/versioncheck.lua',
	'misc/server/main.lua',
	'misc/server/callbacks.lua',
	'misc/server/states.lua',
	'import.lua',
	'server/utils.lua',
	'server/coords.lua',
	'server/statebag.lua',
	'server/prop.lua',
	'server/ped.lua',
	'server/player.lua',
	'server/vehicle.lua',
}

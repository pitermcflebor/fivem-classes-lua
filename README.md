# Lua classes / types for FiveM

## Documentation [WIP]
https://pitermcflebor.github.io/

Example on your fxmanifest.lua:
```
fx_version 'cerulean'
games { 'gta5' }

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@classes/server/utils.lua',
	'@classes/server/coords.lua',
	'@classes/server/ped.lua',
	'@classes/server/player.lua',
	'@classes/server/vehicle.lua',
	'server/*.lua'
}

dependency 'classes'
```

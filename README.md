# Lua classes / types for FiveM

## Installation
- First download the code
- Add to your resources folder this script named `classes`
- Everything is done!

## How to use it
- Go to any of your resources where you want to use this
- Import the classes needed

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

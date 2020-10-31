# Lua classes / types for FiveM

## Documentation [WIP]
https://pitermcflebor.github.io/

Example on your fxmanifest.lua:
```lua
fx_version 'cerulean'
games { 'gta5' }

client_scripts {
	'@classes/import.lua',
	'client/*.lua'
}

server_scripts {
	'@classes/import.lua',
	'server/*.lua'
}

dependency 'classes'
```

Example on your .lua file:
```lua
import 'coords'

local coords = Coords(12.3, 45.6, 78.9)
coords:AddBlip(--[[parameters]])
```

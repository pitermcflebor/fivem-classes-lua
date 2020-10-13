local spawnedPlayers = {}

RegisterNetEvent('__classes:server:playerSpawned')
AddEventHandler('__classes:server:playerSpawned', function()
    local s = source
    if spawnedPlayers[s] == nil then
        spawnedPlayers[s] = true
    end
end)

AddEventHandler('playerDropped', function(source, reason)
    if spawnedPlayers[source] ~= nil then
        spawnedPlayers[source] = false
    end
end)

AddEventHandler('__classes:server:player:spawned', function(source, cb)
    cb(spawnedPlayers[source] ~= nil and spawnedPlayers[source] or false)
end)

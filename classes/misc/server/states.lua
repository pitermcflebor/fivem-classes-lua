local StateBags = {}

RegisterNetEvent('__classes:server:statebags:update:one')
RegisterNetEvent('__classes:server:statebags:update:all')
RegisterNetEvent('__classes:server:playerSpawned')

AddEventHandler('__classes:server:playerSpawned', function()
	TriggerClientEvent('__classes:client:statebags:load', source, StateBags)
end)

-- update one statebag
-- @entityId - the network entityId
-- @key - the key of the state
-- @value - the value of the state
AddEventHandler('__classes:server:statebags:update:one', function(entityId, key, value, shared)
	if StateBags[entityId] == nil then StateBags[entityId] = {} end
	if StateBags[entityId][key] == nil then StateBags[entityId][key] = {} end
	StateBags[entityId][key] = value
	if shared == true then
		TriggerClientEvent('__classes:client:statebags:update:one', -1, entityId, key, value, false)
	end
end)

-- update all statebag
-- @entityId - the network entityId
-- @sb - the statebag
AddEventHandler('__classes:server:statebags:update:all', function(entityId, sb, shared)
	if StateBags[entityId] == nil then StateBags[entityId] = {} end
	StateBags[entityId] = sb
	if shared == true then
		TriggerClientEvent('__classes:client:statebags:update:all', -1, entityId, sb, false)
	end
end)

-- get statebag key
-- @entityId - the network entity id
-- @key - the key of the state
-- @cb - the callback
AddEventHandler('__classes:server:statebags:get', function(entityId, key, cb)
	cb((StateBags[entityId] ~= nil and StateBags[entityId][key] or nil))
end)

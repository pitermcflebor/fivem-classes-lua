local StateBags = {}

RegisterNetEvent('__classes:client:statebags:load')
RegisterNetEvent('__classes:client:statebags:update:one')
RegisterNetEvent('__classes:client:statebags:update:all')

-- load from server-side the current statebags on server
--
AddEventHandler('__classes:client:statebags:load', function(sb)
	StateBags = sb
end)

-- update one statebag
-- @netId - the network entityId
-- @key - the key of the state
-- @value - the value of the state
AddEventHandler('__classes:client:statebags:update:one', function(entityId, key, value, shared)
	if not shared then
		if StateBags[entityId] == nil then StateBags[entityId] = {} end
		if StateBags[entityId][key] == nil then StateBags[entityId][key] = {} end
		StateBags[entityId][key] = value
	elseif shared == true then
		TriggerServerEvent('__classes:server:statebags:update:one', entityId, key, value, true)
	end
end)

-- update all statebag
-- @netId - the network entityId
-- @sb - the statebag
AddEventHandler('__classes:client:statebags:update:all', function(entityId, sb, shared)
	if not shared then
		if StateBags[entityId] == nil then StateBags[entityId] = {} end
		StateBags[entityId] = sb
	elseif shared == true then
		TriggerServerEvent('__classes:server:statebags:update:all', entityId, sb, true)
	end
end)

-- get statebag key
-- @entityId - the network entity id
-- @key - the key of the state
-- @cb - the callback
AddEventHandler('__classes:client:statebags:get', function(entityId, key, cb)
	cb((StateBags[entityId] ~= nil and StateBags[entityId][key] or nil))
end)

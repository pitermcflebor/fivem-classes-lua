--
-- WARNING: DO NOT IMPORT THIS TO OTHER SCRIPTS
--

RegisterNetEvent('__callback:server')
AddEventHandler('__callback:server', function(eventName, ticket, ...)
	local s = source
	local p = promise.new()

	TriggerEvent('s__callback:'..eventName, function(...)
		p:resolve({...})
	end, s, ...)

	local result = Citizen.Await(p)
	TriggerClientEvent(('__callback:client:%s:%s'):format(eventName, ticket), s, table.unpack(result))
end)

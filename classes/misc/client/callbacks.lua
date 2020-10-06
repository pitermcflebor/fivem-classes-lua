--
-- WARNING: DO NOT IMPORT THIS TO OTHER SCRIPTS
--

RegisterNetEvent('__callback:client')
AddEventHandler('__callback:client', function(eventName, ...)
	local p = promise.new()

	TriggerEvent(('c__callback:%s'):format(eventName), function(...)
		p:resolve({...})
	end, ...)

	local result = Citizen.Await(p)
	TriggerServerEvent(('__callback:server:%s'):format(eventName), table.unpack(result))
end)

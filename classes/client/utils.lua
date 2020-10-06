
_G._type = function(obj)
	if type(obj) == 'table' then
		local meta = getmetatable(obj)
		if meta ~= nil then
			return (rawget( getmetatable(obj), "__type" ) or 'table')
		end
	end
	return type(obj)
end

_G.warning = function(msg, ...)
	print(('^8SCRIPT-WARNING [%s]: %s ^7'):format(("%s:%s:%s"):format(debug.getinfo(3).short_src, debug.getinfo(3).currentline, debug.getinfo(2).name), (msg):format(...)))
end

_G.TriggerServerCallback = function(eventName, ...)
	local p = promise.new()
	local ticket = GetGameTimer()

	RegisterNetEvent(('__callback:client:%s:%s'):format(eventName, ticket))
	local e = AddEventHandler(('__callback:client:%s:%s'):format(eventName, ticket), function(...)
		p:resolve({...})
	end)

	TriggerServerEvent('__callback:server', eventName, ticket, ...)

	local result = Citizen.Await(p)
	RemoveEventHandler(e)
	return table.unpack(result)
end

_G.RegisterClientCallback = function(eventName, fn)
	if eventName ~= nil and type(eventName) == 'string' then
		if fn ~= nil and type(fn) == 'function' then
			AddEventHandler(('c__callback:%s'):format(eventName), function(cb, ...)
				cb(fn(...))
			end)
		else
			warning('The callback expected function, but got %s', type(eventName))
		end
	else
		warning('The event name expected string, but got %s', type(eventName))
	end
end

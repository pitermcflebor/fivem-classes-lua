
if GetCurrentResourceName() == 'classes' then
exports('utils', function()
	return
[[_G._type = function(obj)
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

_G.RegisterServerCallback = function(eventName, fn)
	if eventName ~= nil and type(eventName) == 'string' then
		if fn ~= nil and type(fn) == 'function' then
			AddEventHandler(('s__callback:%s'):format(eventName), function(cb, s, ...)
				local result = {fn(s, ...)}
				cb(table.unpack(result))
			end)
		else
			warning('The callback expected function, but got %s', type(eventName))
		end
	else
		warning('The event name expected string, but got %s', type(eventName))
	end
end

_G.TriggerClientCallback = function(src, eventName, ...)
	local p = promise.new()

	RegisterNetEvent('__callback:server:'..eventName)
	local e = AddEventHandler('__callback:server:'..eventName, function(...)
		local s = source
		if src == s then
			p:resolve({...})
		end
	end)

	TriggerClientEvent('__callback:client', src, eventName, ...)

	local result = Citizen.Await(p)
	RemoveEventHandler(e)
	return table.unpack(result)
end]]
end)
else
	local func, err = load(exports.classes:utils())
	assert(func, err)
	func()
end
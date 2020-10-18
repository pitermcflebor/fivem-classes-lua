
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

_G.ShowHelpNotification = function(msg, thisFrame, beep, duration)
	AddTextEntry('help_notification', msg)
	if thisFrame then
		DisplayHelpTextThisFrame('help_notification', false)
	else
		BeginTextCommandDisplayHelp('help_notification')
		EndTextCommandDisplayHelp(0, false, beep == nil and true or beep, duration or -1)
	end

	msg, thisFrame, beep, duration = nil, nil, nil, nil
end

_G.ShowNotification = function(msg, flash, saveToBrief, hudColorIndex)
	AddTextEntry(GetCurrentResourceName()..':notification:'..GetGameTimer(), msg)
	BeginTextCommandThefeedPost('notification')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief or true)

	msg, hudColorIndex, flash, saveToBrief = nil, nil, nil, nil
end

TimeoutRequestModel = function(model)
	local _model = (type(model) == 'string' and GetHashKey(model) or model)
	if HasModelLoaded(_model) then
		return true
	else
		RequestModel(_model)
		local now = GetGameTimer()
		repeat
			Wait(1)
			if (GetGameTimer() - now) >= 20000 then
				warning('Timeout requesting model "%s" after 20 seconds', model)
				timedout = true
				break
			end
		until (HasModelLoaded(_model))
		if timedout then
			return false
		end
		return true
	end
end

TimeoutRequestAnim = function(animDict)
	if type(animDict) == 'string' then
		if HasAnimDictLoaded(animDict) then
			return true
		end
		RequestAnimDict(animDict)
		local now = GetGameTimer()
		repeat
			Wait(1)
			if (GetGameTimer() - now) >= 20000 then
				warning('Timeout requesting anim "%s" after 20 seconds', animDict)
				timedout = true
				break
			end
		until (HasAnimDictLoaded(animDict))
		if timedout then
			return false
		end
		return true
	else
		warning('Tried to TimeoutRequestAnim without string!')
		return false
	end
end

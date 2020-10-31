
if GetCurrentResourceName() == 'classes' then -- fix for older versions
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
	local notify = GetCurrentResourceName()..':notification'
	AddTextEntry(notify, msg)
	if thisFrame then
		DisplayHelpTextThisFrame(notify, false)
	else
		BeginTextCommandDisplayHelp(notify)
		EndTextCommandDisplayHelp(0, false, beep == nil and true or beep, duration or -1)
	end

	msg, thisFrame, beep, duration = nil, nil, nil, nil
end

_G.ShowNotification = function(msg, flash, saveToBrief, hudColorIndex)
	local notify = GetCurrentResourceName()..':notification'
	AddTextEntry(notify, msg)
	BeginTextCommandThefeedPost(notify)
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief or true)

	msg, hudColorIndex, flash, saveToBrief, notify = nil, nil, nil, nil, nil
end

_G.TimeoutRequestModel = function(model)
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

_G.TimeoutRequestAnim = function(animDict)
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

_G.DrawText3D = function(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	local scale = ((size or 1) / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font or 0)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

_G.dist = function(v1, v2, useZ)
	if type(v1) ~= 'vector3' or type(v2) ~= 'vector3' then
		error"The parameters passed are not vector3!"
	end
	if useZ then
		return #(v1 - v2)
	else
		return #(v1.xy - v2.xy)
	end
end

_G.GetNearestPeds = function(coords, radius, sorted, selfped)
	coords = coords or GetEntityCoords(PlayerPedId())
	local t = {}
	if radius == nil then
		for _,e in pairs(GetGamePool('CPed')) do
			if not selfped and e == PlayerPedId() then --nothing
			else
				table.insert(t, {index=e, distance=dist(GetEntityCoords(e), coords)})
			end
		end
	else
		assert(type(radius) == 'number', 'Radius wasn\'t a number!')
		assert(type(coords) == 'vector3', 'Coords wasn\'t a Vector3!')
		for _,e in pairs(GetGamePool('CPed')) do
			local d = dist(GetEntityCoords(e), coords)
			if d <= radius then
				if not selfped and e == PlayerPedId() then --nothing
				else
					table.insert(t, {index=e, distance=d})
				end
			end
		end
	end
	if not sorted then return t
	else return table.sorted(t, 'distance') end
end

_G.GetNearestPlayers = function(coords, radius, sorted, selfplayer)
	coords = coords or GetEntityCoords(PlayerPedId())
	local t = {}
	if radius == nil then
		for _,e in pairs(GetNearestPeds(coords, nil, false, selfplayer)) do
			if IsPedAPlayer(e.index) then
				table.insert(t, {index=GetPlayerServerId(NetworkGetPlayerIndexFromPed(e.index)), distance=e.distance})
			end
		end
	else
		for _,e in pairs(GetNearestPeds(coords, radius, false, selfplayer)) do
			if IsPedAPlayer(e.index) then
				if e.distance <= radius then
					table.insert(t, {index=GetPlayerServerId(NetworkGetPlayerIndexFromPed(e.index)), distance=e.distance})
				end
			end
		end
	end
	if not sorted then return t
	else return table.sorted(t, 'distance') end
end

_G.GetNearestObjects = function(coords, radius, sorted)
	coords = coords or GetEntityCoords(PlayerPedId())
	local t = {}
	if radius == nil then
		for _,e in pairs(GetGamePool('CObject')) do
			table.insert(t, {index=e, distance=dist(GetEntityCoords(e), coords)})
		end
	else
		assert(type(radius) == 'number', 'Radius wasn\'t a number!')
		assert(type(coords) == 'vector3', 'Coords wasn\'t a Vector3!')
		for _,e in pairs(GetGamePool('CObject')) do
			local d = dist(GetEntityCoords(e), coords)
			if d <= radius then
				table.insert(t, {index=e, distance=d})
			end
		end
	end
	if not sorted then return t
	else return table.sorted(t, 'distance') end
end

_G.GetNearestVehicles = function(coords, radius, sorted)
	coords = coords or GetEntityCoords(PlayerPedId())
	local t = {}
	if radius == nil then
		for _,e in pairs(GetGamePool('CVehicle')) do
			table.insert(t, {index=e, distance=dist(GetEntityCoords(e), coords)})
		end
	else
		assert(type(radius) == 'number', 'Radius wasn\'t a number!')
		assert(type(coords) == 'vector3', 'Coords wasn\'t a Vector3!')
		for _,e in pairs(GetGamePool('CVehicle')) do
			local d = dist(GetEntityCoords(e), coords)
			if d <= radius then
				table.insert(t, {index=e, distance=d})
			end
		end
	end
	if not sorted then return t
	else return table.sorted(t, 'distance') end
end]]
end)
else
	local func, err = load(exports.classes:utils())
	assert(func, err)
	func()
end
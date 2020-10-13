
RegisterClientCallback('__classes:vehicle:get:props:mods', function(netId)
	local localid = NetworkGetEntityFromNetworkId(netId)
	local vehicle = Vehicle(false, localid)
	return vehicle:GetMods()
end)

RegisterClientCallback('__classes:vehicle:get:props', function(netId)
	local localid = NetworkGetEntityFromNetworkId(netId)
	local vehicle = Vehicle(false, localid)
	return vehicle:GetProperties()
end)

AddEventHandler('__classes:vehicle:set:props', function(netId, props)
	local localid = NetworkGetEntityFromNetworkId(netId)
	local vehicle = Vehicle(false, localid)
	vehicle:SetProperties(props)
end)
RegisterNetEvent('__classes:vehicle:set:props')

local notSpawned = true

AddEventHandler('playerSpawned', function()
	if notSpawned then
		TriggerServerEvent('__classes:server:playerSpawned')
		notSpawned = false
	end
end)

local propsSwapped = {}
RegisterNetEvent('__classes:client:model:swap')
AddEventHandler('__classes:client:model:swap', function(netId, originalModel, newModel)
	if not propsSwapped[netId] then
		local localId = NetworkGetEntityFromNetworkId(netId)
		local prop = Prop(false, localId)
		prop:SwapModel(newModel)
		propsSwapped[netId] = prop
	else
		propsSwapped[netId]:SwapModel(newModel)
	end
end)

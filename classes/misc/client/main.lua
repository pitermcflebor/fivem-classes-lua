local notSpawned = true

AddEventHandler('playerSpawned', function()
	if notSpawned then
		TriggerServerEvent('__classes:server:playerSpawned')
		notSpawned = false
	end
end)


if GetCurrentResourceName() == 'classes' then -- fix for older versions
exports('ped', function()
	return
[=[_G.Ped = {}
_G.PedMethods = {}

PedMethods.__call = function(self, newPed, p1, pedType, x,y,z,w, isNetwork)
	local o = setmetatable({}, {
		__index = self,
		__tonumber = function(self) return self.id end,
		__tostring = function(self) return ('Ped<%s>'):format(table.concat({self.id, self.modelName}, ', ')) end,
		__type = 'Ped',
	})
	if newPed == true then
		if type(p1) == 'number' or type(p1) == 'string' then
			if pedType >= 0 then
				if pedType > 29 then
					assert(nil, 'Ped type cannot be more than 29')
				end
			else
				assert(nil, 'Ped type cannot be less than 0')
			end
			if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(w) ~= 'number' then
				assert(nil, 'The X, Y, Z or Heading expected number')
			end
			if type(isNetwork) ~= 'boolean' then
				assert(nil, 'The isNetwork expected boolean, but got '..type(isNetwork))
			end
			if type(p1) == 'string' then
				o.modelName = p1
				o.model = GetHashKey(p1)
			else
				o.model = p1
			end
			o.id = CreatePed(pedType, o.model, x, y, z, w, isNetwork, true)
		else
			assert(nil, 'The second parameter expected number, but got '..type(p1))
		end
	elseif newPed == false then
		if type(p1) == 'number' then
			if DoesEntityExist(p1) then
				o.id = p1
				o.model = GetEntityModel(o.id)
			else
				assert(nil, 'The entity doesn\'t exists!')
			end
		else
			assert(nil, 'The second parameter expected number, but got '..type(p1))
		end
	elseif type(newPed) ~= 'boolean' then
		assert(nil, 'First parameter expected boolean, but got '..type(newPed))
	end
	o.state = StateBag(o.id)
	return o
end

PedMethods.__index = {
	Exists = function(self)
		return (DoesEntityExist(self.id) == 1 and true or false)
	end,

	GetPosition = function(self)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		local coords = GetEntityCoords(self.id)
		local heading = GetEntityHeading(self.id)
		return Coords(coords.x, coords.y, coords.z, heading)
	end,
	
	IsInsideVehicle = function(self)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		return IsPedSittingInAnyVehicle(self.id)
	end,
	
	GetVehicle = function(self, last)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		return Vehicle(false, GetVehiclePedIsIn(self.id, last or false))
	end,

	PlayAnim = function(self, animDict, animName, flag, duration, blendInSpeed, blendOutSpeed, playbackRate, lockX, lockY, lockZ)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		if animDict == nil or type(animDict) ~= 'string' then warning('The animDict wasn\'t string!'); return end
		if animName == nil or type(animName) ~= 'string' then warning('The animName wasn\'t string!'); return end
		if TimeoutRequestAnim(animDict) then
			TaskPlayAnim(self.id, animDict, animName, blendInSpeed or 8.0, blendOutSpeed or 8.0, duration or -1, flag or -1, playbackRate or 0, lockX or false, lockY or false, lockZ or false)
			while not IsEntityPlayingAnim(self.id, animDict, animName, flag or -1) do Wait(0) end
			return true
		else
			return false
		end
	end,

	StartScenario = function(self, scenarioName, playEnterAnim)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		if scenarioName == nil or type(scenarioName) ~= 'string' then warning('The scenarioName wasn\'t string!'); return end
		if IsScenarioTypeEnabled(scenarioName) then
			TaskStartScenarioInPlace(self.id, scenarioName, 0, playEnterAnim or true)
			while not IsPedUsingScenario(self.id, scenarioName) do Wait(0) end
			return true
		else
			return false
		end
	end,

	ClearTasks = function(self)
		if self:Exists() then
			ClearPedTasks(self.id)
		end
	end,

	SetDefaultComponents = function(self)
		SetPedDefaultComponentVariation(self.id)
	end,
}

setmetatable(Ped, PedMethods)]=]
end)
else
	local func, err = load(exports.classes:ped())
	assert(func, err)
	func()
end
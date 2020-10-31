
exports('vehicle', function()
	return
[[_G.Vehicle = {}
_G.VehicleMethods = {}

VehicleMethods.__call = function(self, newVehicle, p1, x, y, z, heading, isNetwork)
	local o = setmetatable({}, {
		__index = self,
		__tonumber = function(self)
			return self.id
		end,
		__tostring = function(self)
			return ('Vehicle<%s>'):format(table.concat({'id: '..self.id, 'model: '..(self.modelName or self.model)}, ', '))
		end,
		__type = 'Vehicle',
	})
	if newVehicle == true then
		if type(p1) ~= 'number' then
			if type(p1) ~= 'string' then
				assert(nil, 'Second parameter expected number or string, but got '..type(p1))
			else
				o.modelName = p1
				o.model = GetHashKey(o.modelName)
			end
		else
			o.model = p1
		end
		if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(heading) ~= 'number' then
			assert(nil, 'X, Y, Z or Heading expected number')
		end
		if type(isNetwork) ~= 'boolean' then
			assert(nil, 'isNetwork expected boolean')
		end
		o.id = CreateVehicle(o.model, x, y, z, heading, isNetwork, true)
	elseif newVehicle == false then
		if type(p1) == 'number' then
			if DoesEntityExist(p1) then
				o.id = p1
				o.model = GetEntityModel(p1)
			else
				assert(nil, 'The entity passed doesn\'t exists!')
			end
		else
			assert(nil, 'Second parameter expected number, but got '..type(p1))
		end
	elseif type(newVehicle) ~= 'boolean' then
		assert(nil, 'First paremeter expected boolean, but got '..type(newVehicle))
	end
	o.state = StateBag(o.id)
	return o
end

VehicleMethods.__index = {
	Exists = function(self)
		return (DoesEntityExist(self.id) == 1 and true or false)
	end,

	WaitForExistence = function(self)
		while not self:Exists() do Wait(0) end
	end,

	Delete = function(self)
		if not self:Exists() then
			warning('Vehicle doesn\'t exists!')
			return
		end
		DeleteEntity(self.id)
	end,
	Remove = function(self)
		if not self:Exists() then
			warning('Vehicle doesn\'t exists!')
			return
		end
		DeleteEntity(self.id)
	end,

	GetOwner = function(self)
		if self:Exists() then
			return NetworkGetEntityOwner(self.id)
		end
	end,

	GetNetId = function(self)
		if self:Exists() then
			return NetworkGetNetworkIdFromEntity(self.id)
		end
	end,

	Freeze = function(self, ms)
		if not self:Exists() then
			warning('Vehicle doesn\'t exists!')
		end
		if self.freezed == nil or self.freezed == false then
			FreezeEntityPosition(self.id, true)
			self.freezed = true
			if ms ~= nil and type(ms) == 'number' then
				CreateThread(function()
					Wait(ms)
					if self.freezed == true then
						FreezeEntityPosition(self.id, false)
						self.freezed = false
					end
				end)
			end
		elseif self.freezed == true then
			FreezeEntityPosition(self.id, false)
			self.freezed = false
		end
		return true
	end,

	GetPosition = function(self)
		if not self:Exists() then
			warning('Vehicle doesn\'t exists!')
		end
		local x,y,z = GetEntityCoords(self.id)
		return Coords(x,y,z)
	end,

	SetPedInside = function(self, ped, seat)
		if not self:Exists() then
			warning('Vehicle doesn\'t exists!')
		else
			if _type(ped) == 'number' or _type(ped) == 'Ped' then
				if math.type(seat) == 'integer' then
					if seat < -2 then
						warning('Seat need to be more than -2, but got ', tostring(seat))
					end
					TaskWarpPedIntoVehicle(tonumber(ped), self.id, seat)
					return true
				else
					warning('Expected Seat as integer, but got %s', (math.type(seat) ~= nil and math.type(seat) or type(seat)))
				end
			else
				warning('Expected Ped as number or Ped, but got %s', _type(ped))
			end
		end
	end,

	EveryoneLeave = function(self)
		if not self:Exists() then
			warning('Vehicle doesn\'t exists!')
		end
		TaskEveryoneLeaveVehicle(self.id)
	end,

	GetColours = function(self)
		if self:Exists() then
			return GetVehicleColours(self.id)
		end
	end,

	GetDashboardColour = function(self)
		if self:Exists() then
			return GetVehicleDashboardColour(self.id)
		end
	end,

	GetInteriorColour = function(self)
		if self:Exists() then
			return GetVehicleInteriorColour(self.id)
		end
	end,

	GetExtraColours = function(self)
		if self:Exists() then
			return GetVehicleExtraColours(self.id)
		end
	end,

	GetHeadlightsColour = function(self)
		if self:Exists() then
			return GetVehicleHeadlightsColour(self.id)
		end
	end,

	GetNumberPlateTextIndex = function(self)
		if self:Exists() then
			return GetVehicleNumberPlateTextIndex(self.id)
		end
	end,

	GetTyreSmokeColor = function(self)
		if self:Exists() then
			return GetVehicleTyreSmokeColor(self.id)
		end
	end,

	GetWindowTint = function(self)
		if self:Exists() then
			return GetVehicleWindowTint(self.id)
		end
	end,

	GetBodyHealth = function(self)
		if self:Exists() then
			return GetVehicleBodyHealth(self.id)
		end
	end,

	GetDirtLevel = function(self)
		if self:Exists() then
			return GetVehicleDirtLevel(self.id)
		end
	end,

	GetEngineHealth = function(self)
		if self:Exists() then
			return GetVehicleEngineHealth(self.id)
		end
	end,

	GetPetrolTankHealth = function(self)
		if self:Exists() then
			return GetVehiclePetrolTankHealth(self.id)
		end
	end,

	GetLivery = function(self)
		if self:Exists() then
			return GetVehicleLivery(self.id)
		end
	end,

	GetNumberPlateText = function(self)
		if self:Exists() then
			return GetVehicleNumberPlateText(self.id)
		end
	end,

	GetRoofLivery = function(self)
		if self:Exists() then
			return GetVehicleRoofLivery(self.id)
		end
	end,

	GetWheelType = function(self)
		if self:Exists() then
			return GetVehicleWheelType(self.id)
		end
	end,

	GetExtras = function(self)
		local extras = {}
		for extraId=0, 15, 1 do
			table.insert(extras, {
				extraId=extraId,
				toggle=IsVehicleExtraTurnedOn(self.id, extraId) == 1
			})
		end
		return extras
	end,

	GetBurstTyres = function(self)
		-- this is awful but easy to read
		return {
			{wheelId=0, burst=IsVehicleTyreBurst(self.id, 0, true)},
			{wheelId=1, burst=IsVehicleTyreBurst(self.id, 1, true)},
			{wheelId=2, burst=IsVehicleTyreBurst(self.id, 2, true)},
			{wheelId=3, burst=IsVehicleTyreBurst(self.id, 3, true)},
			{wheelId=4, burst=IsVehicleTyreBurst(self.id, 4, true)},
			{wheelId=5, burst=IsVehicleTyreBurst(self.id, 5, true)},
		}
	end,

	GetProperties = function(self)
		-- DON'T WORK AS EXPECTED
		-- THX FIVEM
		--[[ self.props 												= {}
		-- model
		self.props.model 										= self.model
		-- colors
		self.props.colours 										= {}
		self.props.colours.primary,
		self.props.colours.secondary 							= self:GetColours()
		self.props.colours.dashboard 							= self:GetDashboardColour()
		self.props.colours.interior 							= self:GetInteriorColour()
		self.props.colours.pearlescent,
		self.props.colours.wheel 								= self:GetExtraColours()
		self.props.colours.headlights 							= self:GetHeadlightsColour()
		self.props.colours.plate 								= self:GetNumberPlateTextIndex()
		self.props.colours.tyreSmoke							= {}
		self.props.colours.tyreSmoke.r,
		self.props.colours.tyreSmoke.g,
		self.props.colours.tyreSmoke.b 							= self:GetTyreSmokeColor()
		self.props.colours.window 								= self:GetWindowTint()
		-- damages
		self.props.bodyHealth 									= self:GetBodyHealth()
		self.props.dirtLevel 									= self:GetDirtLevel()
		self.props.engineHealth 								= self:GetEngineHealth()
		self.props.petroltank 									= self:GetPetrolTankHealth()
		self.props.bursts										= self:GetBurstTyres()
		-- misc
		self.props.livery 										= self:GetLivery()
		self.props.plate 										= self:GetNumberPlateText()
		self.props.roofLivery 									= self:GetRoofLivery()
		self.props.wheelType 									= self:GetWheelType()
		-- mods
		self.props.mods											= TriggerClientCallback(self:GetOwner(), '__classes:vehicle:get:props:mods', self:GetNetId())
		self.props.extras										= self:GetExtras() \]\]
		self.props = TriggerClientCallback(self:GetOwner(), '__classes:vehicle:get:props', self:GetNetId())
		return self.props
	end,

	SetProperties = function(self, props)
		if not self:Exists() then
			warning('Vehicle doesn\'t exists!')
		else
			TriggerClientEvent('__classes:vehicle:set:props', self:GetOwner(), self:GetNetId(), props)
		end
	end,

}

setmetatable(Vehicle, VehicleMethods)]]
end)

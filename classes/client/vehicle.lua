
if GetCurrentResourceName() == 'classes' then -- fix for older versions
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
			return ('Vehicle<%s>'):format(table.concat({'id: '..self.id, 'model: '..self.modelName}, ', '))
		end,
		__type = 'Vehicle'
	})
	if newVehicle == true then
		if type(p1) == 'string' or type(p1) == 'number' then
			o.model = GetHashKey(p1)
			if IsModelInCdimage(o.model) then
				if not HasModelLoaded(o.model) then
					RequestModel(o.model)
					repeat Wait(0) until (HasModelLoaded(o.model))
				end

				if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(heading) ~= 'number' then
					assert(nil, 'X, Y, Z or Heading wasn\'t a number')
				end
				if type(isNetwork) ~= 'boolean' then
					assert(nil, 'isNetwork parameter was '..type(isNetwork)..' but expected boolean')
				end

				if type(p1) == 'string' then o.modelName = p1 end

				o.id = CreateVehicle(o.model, x, y, z, heading, isNetwork, true)
			else
				assert(nil, 'The model '..p1..' doesn\'t exists!')
			end
		else
			assert(nil, 'Second parameter was '..type(p1)..' but expected string or number')
		end
	elseif newVehicle == false then
		if DoesEntityExist(p1) then
			if not NetworkGetEntityOwner(p1) == PlayerId() then
				warning('The entity you tried to select isn\'t owned by you, you will experience some issues!')
			end
			o.id = p1
			o.model = GetEntityModel(p1)
		else
			assert(nil, 'The entity passed doesn\t exists')
		end
	elseif type(newVehicle) ~= 'boolean' then
		assert(nil, 'First parameter was '..type(newVehicle)..', expected boolean')
	end
	o.state = StateBag(o.id)
	return o
end

VehicleMethods.__index = {
	Exists = function(self)
		return (DoesEntityExist(self.id) == 1 and true or false)
	end,

	GetNetId = function(self)
		if self:Exists() then
			return NetworkGetNetworkIdFromEntity(self.id)
		end
	end,

	SetPedInside = function(self, ped, seat)
		if DoesEntityExist(self.id) then
			if _type(ped) == 'number' then
				if not IsPedAPlayer(ped) then
					TaskWarpPedIntoVehicle(ped, self.id, seat)
					return true
				elseif IsPedAPlayer(ped) and ped == PlayerPedId() then
					TaskWarpPedIntoVehicle(ped, self.id, seat)
					return true
				end
			elseif _type(ped) == 'Ped' then
				if not IsPedAPlayer(ped.id) then
					TaskWarpPedIntoVehicle(ped.id, self.id, seat)
					return true
				elseif IsPedAPlayer(ped.id) and ped.id == PlayerPedId() then
					TaskWarpPedIntoVehicle(ped.id, self.id, seat)
					return true
				end
			else
				warning('Ped parameter wasn\'t any number or Ped')
			end
		else
			warning('Vehicle doesn\'t exists!')
		end
		return false
	end,

	GetMods = function(self)
		if self:Exists() then
			return {
				MOD_SPOILER = {modType=GetVehicleMod(self.id, 0), index=0},
				MOD_FRONTBUMPER = {modType=GetVehicleMod(self.id, 1), index=1},
				MOD_REARBUMPER = {modType=GetVehicleMod(self.id, 2), index=2},
				MOD_SIDESKIRT = {modType=GetVehicleMod(self.id, 3), index=3},
				MOD_EXHAUST = {modType=GetVehicleMod(self.id, 4), index=4},
				MOD_CHASSIS = {modType=GetVehicleMod(self.id, 5), index=5},
				MOD_GRILLE = {modType=GetVehicleMod(self.id, 6), index=6},
				MOD_HOOD = {modType=GetVehicleMod(self.id, 7), index=7},
				MOD_FENDER = {modType=GetVehicleMod(self.id, 8), index=8},
				MOD_RIGHTFENDER = {modType=GetVehicleMod(self.id, 9), index=9},
				MOD_ROOF = {modType=GetVehicleMod(self.id, 10), index=10},
				MOD_ENGINE = {modType=GetVehicleMod(self.id, 11), index=11},
				MOD_BRAKES = {modType=GetVehicleMod(self.id, 12), index=12},
				MOD_TRANSMISSION = {modType=GetVehicleMod(self.id, 13), index=13},
				MOD_HORNS = {modType=GetVehicleMod(self.id, 14), index=14},
				MOD_SUSPENSION = {modType=GetVehicleMod(self.id, 15), index=15},
				MOD_ARMOR = {modType=GetVehicleMod(self.id, 16), index=16},
				MOD_UNK17 = {toggle=IsToggleModOn(self.id, 17), index=17},
				MOD_TURBO = {toggle=IsToggleModOn(self.id, 18), index=18},
				MOD_UNK19 = {toggle=IsToggleModOn(self.id, 19), index=19},
				MOD_TIRESMOKE = {toggle=IsToggleModOn(self.id, 20), index=20},
				MOD_UNK21 = {toggle=IsToggleModOn(self.id, 21), index=21},
				MOD_XENONLIGHTS = {toggle=IsToggleModOn(self.id, 22), index=22},
				MOD_FRONTWHEELS = {modType=GetVehicleMod(self.id, 23), index=23},
				MOD_BACKWHEELS = {modType=GetVehicleMod(self.id, 24), index=24},
				MOD_PLATEHOLDER = {modType=GetVehicleMod(self.id, 25), index=25},
				MOD_VANITY_PLATES  = {modType=GetVehicleMod(self.id, 26), index=26},
				MOD_TRIM = {modType=GetVehicleMod(self.id, 27), index=27},
				MOD_ORNAMENTS = {modType=GetVehicleMod(self.id, 28), index=28},
				MOD_DASHBOARD = {modType=GetVehicleMod(self.id, 29), index=29},
				MOD_DIAL = {modType=GetVehicleMod(self.id, 30), index=30},
				MOD_DOOR_SPEAKER = {modType=GetVehicleMod(self.id, 31), index=31},
				MOD_SEATS = {modType=GetVehicleMod(self.id, 32), index=32},
				MOD_STEERINGWHEEL = {modType=GetVehicleMod(self.id, 33), index=33},
				MOD_SHIFTER_LEAVERS = {modType=GetVehicleMod(self.id, 34), index=34},
				MOD_PLAQUES = {modType=GetVehicleMod(self.id, 35), index=35},
				MOD_SPEAKERS = {modType=GetVehicleMod(self.id, 36), index=36},
				MOD_TRUNK = {modType=GetVehicleMod(self.id, 37), index=37},
				MOD_HYDRULICS = {modType=GetVehicleMod(self.id, 38), index=38},
				MOD_ENGINE_BLOCK = {modType=GetVehicleMod(self.id, 39), index=39},
				MOD_AIR_FILTER = {modType=GetVehicleMod(self.id, 40), index=40},
				MOD_STRUTS = {modType=GetVehicleMod(self.id, 41), index=41},
				MOD_ARCH_COVER = {modType=GetVehicleMod(self.id, 42), index=42},
				MOD_AERIALS = {modType=GetVehicleMod(self.id, 43), index=43},
				MOD_TRIM = {modType=GetVehicleMod(self.id, 44), index=44},
				MOD_TANK = {modType=GetVehicleMod(self.id, 45), index=45},
				MOD_WINDOWS = {modType=GetVehicleMod(self.id, 46), index=46},
				MOD_UNK47 = {modType=GetVehicleMod(self.id, 47), index=47},
				MOD_LIVERY = {modType=GetVehicleMod(self.id, 48), index=48}
			}
		end
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
			if DoesExtraExist(self.id, extraId) then
				table.insert(extras, {
					extraId=extraId,
					toggle=IsVehicleExtraTurnedOn(self.id, extraId) == 1
				})
			end
		end
		return extras
	end,

	GetBurstTyres = function(self)
		-- this is awful but easy to read
		return {
			{wheelId=0, burst=IsVehicleTyreBurst(self.id, 0, false) == 1}, 	{wheelId=1, burst=IsVehicleTyreBurst(self.id, 1, false) == 1},
			{wheelId=2, burst=IsVehicleTyreBurst(self.id, 2, false) == 1},	{wheelId=3, burst=IsVehicleTyreBurst(self.id, 3, false) == 1},
			{wheelId=4, burst=IsVehicleTyreBurst(self.id, 4, false) == 1},	{wheelId=5, burst=IsVehicleTyreBurst(self.id, 5, false) == 1},
		}
	end,

	GetFuelLevel = function(self)
		if self:Exists() then
			return GetVehicleFuelLevel(self.id)
		end
	end,

	GetBrokenWindows = function(self)
		local windows = {}
		for i=0, 14, 1 do
			local run, result = pcall(IsVehicleWindowIntact, self.id, i)
			if run then
				table.insert(windows, {index=i, broken=(not result)})
			end
		end
		return windows
	end,

	GetProperties = function(self)
		self.props 												= {}
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
		self.props.fuelLevel									= self:GetFuelLevel()
		self.props.windows										= self:GetBrokenWindows()
		-- misc
		self.props.plate 										= self:GetNumberPlateText()
		self.props.wheelType 									= self:GetWheelType()
		self.props.bursts										= self:GetBurstTyres()
		-- mods
		self.props.mods											= self:GetMods()
		self.props.extras										= self:GetExtras()
	
		return self.props
	end,

	SetProperties = function(self, props)
		if self:Exists() then
			if props.model == self.model then
				local cProps = self:GetProperties()
				SetVehicleModKit(self.id, 0)
				-- misc
				SetVehicleNumberPlateText(self.id, props.plate or cProps.plate)
				SetVehicleWheelType(self.id, props.wheelType or cProps.wheelType)
				-- colors
				if props.colours then
					SetVehicleColours(self.id, (props.colours.primary or cProps.colours.primary), (props.colours.secondary or cProps.colours.secondary))
					SetVehicleDashboardColour(self.id, props.colours.dashboard or cProps.colours.dashboard)
					SetVehicleInteriorColour(self.id, props.colours.interior or cProps.colours.interior)
					SetVehicleExtraColours(self.id, props.colours.pearlescent or cProps.colours.pearlescent, props.colours.wheel or cProps.colours.wheel)
					SetVehicleHeadlightsColour(self.id, props.colours.headlights or cProps.colours.headlights)
					SetVehicleNumberPlateTextIndex(self.id, props.colours.plate or cProps.colours.plate)
					SetVehicleTyreSmokeColor(self.id, props.colours.tyreSmoke.r or cProps.colours.tyreSmoke.r, props.colours.tyreSmoke.g or cProps.colours.tyreSmoke.g, props.colours.tyreSmoke.b or cProps.colours.tyreSmoke.b)
					SetVehicleWindowTint(self.id, props.colours.window or cProps.colours.window)
				end
				-- damages
				SetVehicleBodyHealth(self.id, (props.bodyHealthor or cProps.bodyHealth)+0.0)
				SetVehicleDirtLevel(self.id, (props.dirtLevel or cProps.dirtLevel)+0.0)
				SetVehicleEngineHealth(self.id, (props.engineHealth or cProps.engineHealth)+0.0)
				SetVehiclePetrolTankHealth(self.id, (props.petroltank or cProps.petroltank)+0.0)
				SetVehicleFuelLevel(self.id, props.fuelLevel or cProps.fuelLevel)
				-- LegacyFuel compatibility
				DecorSetFloat(self.id, '_FUEL_LEVEL', props.fuelLevel or cProps.fuelLevel)
				if props.bursts then
					for _,tyre in pairs(props.bursts) do
						if tyre.burst then
							SetVehicleTyreBurst(self.id, tyre.wheelId, true, 1000.0)
						end
					end
				end
				if props.windows then
					for _,window in pairs(props.windows) do
						if window.broken then
							SmashVehicleWindow(self.id, window.index)
						end
					end
				end
				-- mods
				if props.mods then
					local m = props.mods
					local cm = cProps.mods
					for modName,modValue in pairs(m) do
						if modValue.modType ~= nil then
							if modValue.modType ~= -1 then
								SetVehicleMod(self.id, modValue.index, modValue.modType, false)
							end
						elseif modValue.toggle ~= nil then
							ToggleVehicleMod(self.id, modValue.index, modValue.toggle)
						end
					end
				end
				-- extras
				if props.extras then
					for _,extra in pairs(props.extras) do
						SetVehicleExtra(self.id, extra.extraId, extra.toggle)
					end
				end
			end
		end
	end,

	IsDoorOpen = function(self, doorIndex)
		if self:Exists() then
			return GetVehicleDoorAngleRatio(self.id, doorIndex) > 0.0
		end
	end,

	SetDoorOpen = function(self, doorIndex, loose, openInstantly)
		if self:Exists() then
			if doorIndex ~= nil then
				if type(doorIndex) == 'number' then
					SetVehicleDoorOpen(self.id, doorIndex, loose or false, openInstantly or false)
				else
					warning('doorIndex wasn\'t a number!')
				end
			else
				warning('doorIndex was nil!')
			end
		end
	end,

	SetDoorShut = function(self, doorIndex, closeInstantly)
		if self:Exists() then
			if doorIndex ~= nil then
				if type(doorIndex) == 'number' then
					SetVehicleDoorShut(self.id, doorIndex, closeInstantly or false)
				else
					warning('doorIndex wasn\'t a number!')
				end
			else
				warning('doorIndex was nil!')
			end
		end
	end,
}

setmetatable(Vehicle, VehicleMethods)]]
end)
else
	local func, err = load(exports.classes:vehicle())
	assert(func, err)
	func()
end

--[[

Vehicle - Class

Init: Vehicle(
	newVehicle 	-- boolean,
	p1 			-- number,
	x			-- number,
	y			-- number,
	z			-- number,
	heading		-- number,
	isNetwork	-- boolean
)

* if newVehicle is true, p1 will be the vehicle model hash
* if newVehicle is false, p1 will be the vehicle entity id

Vehicle - methods

Vehicle:Exists()
@return boolean

void Vehicle:Delete() or Vehicle:Remove()
@raise error if entity not exists

void Vehicle:Freeze([ms])
@raise error if entity not exists

Vehicle:GetPosition()
@raise error if entity not exists
@return Coords object

void Vehicle:SetPedInside(ped[, seat])
@raise error if entity not exists

void Vehicle:EveryoneLeave()
@raise error if entity not exists

]]

_G.Vehicle = setmetatable({}, {
	__tonumber = function(self)
		return self.id
	end,
	__tostring = function(self)
		return ('Vehicle<%s>'):format(table.concat({'id: '..self.id, 'model: '..(self.modelName or self.model)}, ', '))
	end,
	__type = 'vehicle',
	__call = function(self, newVehicle, p1, x, y, z, heading, isNetwork)
		if newVehicle == true then
			if type(p1) ~= 'number' then
				if type(p1) ~= 'string' then
					assert(nil, 'Second parameter expected number or string, but got '..type(p1))
				else
					self.modelName = p1
					self.model = GetHashKey(self.modelName)
				end
			else
				self.model = p1
			end
			if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(heading) ~= 'number' then
				assert(nil, 'X, Y, Z or Heading expected number')
			end
			if type(isNetwork) ~= 'boolean' then
				assert(nil, 'isNetwork expected boolean')
			end
			self.id = CreateVehicle(self.model, x, y, z, heading, isNetwork, true)
			return self
		elseif newVehicle == false then
			if type(p1) == 'number' then
				if DoesEntityExist(p1) then
					self.id = p1
					self.model = GetEntityModel(p1)
					return self
				else
					assert(nil, 'The entity passed doesn\'t exists!')
				end
			else
				assert(nil, 'Second parameter expected number, but got '..type(p1))
			end
		elseif type(newVehicle) ~= 'boolean' then
			assert(nil, 'First paremeter expected boolean, but got '..type(newVehicle))
		end
	end
})

function Vehicle:Exists()
	return (DoesEntityExist(self.id) == 1 and true or false)
end

function Vehicle:WaitForExistence()
	while not self:Exists() do Wait(0) end
end

function Vehicle:Delete()
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
		return
	end
	DeleteEntity(self.id)
end
function Vehicle:Remove()
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
		return
	end
	DeleteEntity(self.id)
end

function Vehicle:GetOwner()
	if self:Exists() then
		return NetworkGetEntityOwner(self.id)
	end
end

function Vehicle:GetNetId()
	if self:Exists() then
		return NetworkGetNetworkIdFromEntity(self.id)
	end
end

function Vehicle:Freeze(ms)
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
				end
			end)
		end
	elseif self.freezed == true then
		FreezeEntityPosition(self.id, false)
		self.freezed = false
	end
	return true
end

function Vehicle:GetPosition()
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	end
	local x,y,z = GetEntityCoords(self.id)
	return Coords(x,y,z)
end

function Vehicle:SetPedInside(ped, seat)
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
end

function Vehicle:EveryoneLeave()
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	end
	TaskEveryoneLeaveVehicle(self.id)
end

function Vehicle:GetColours()
	if self:Exists() then
		return GetVehicleColours(self.id)
	end
end

function Vehicle:GetDashboardColour()
	if self:Exists() then
		return GetVehicleDashboardColour(self.id)
	end
end

function Vehicle:GetInteriorColour()
	if self:Exists() then
		return GetVehicleInteriorColour(self.id)
	end
end

function Vehicle:GetExtraColours()
	if self:Exists() then
		return GetVehicleExtraColours(self.id)
	end
end

function Vehicle:GetHeadlightsColour()
	if self:Exists() then
		return GetVehicleHeadlightsColour(self.id)
	end
end

function Vehicle:GetNumberPlateTextIndex()
	if self:Exists() then
		return GetVehicleNumberPlateTextIndex(self.id)
	end
end

function Vehicle:GetTyreSmokeColor()
	if self:Exists() then
		return GetVehicleTyreSmokeColor(self.id)
	end
end

function Vehicle:GetWindowTint()
	if self:Exists() then
		return GetVehicleWindowTint(self.id)
	end
end

function Vehicle:GetBodyHealth()
	if self:Exists() then
		return GetVehicleBodyHealth(self.id)
	end
end

function Vehicle:GetDirtLevel()
	if self:Exists() then
		return GetVehicleDirtLevel(self.id)
	end
end

function Vehicle:GetEngineHealth()
	if self:Exists() then
		return GetVehicleEngineHealth(self.id)
	end
end

function Vehicle:GetPetrolTankHealth()
	if self:Exists() then
		return GetVehiclePetrolTankHealth(self.id)
	end
end

function Vehicle:GetLivery()
	if self:Exists() then
		return GetVehicleLivery(self.id)
	end
end

function Vehicle:GetNumberPlateText()
	if self:Exists() then
		return GetVehicleNumberPlateText(self.id)
	end
end

function Vehicle:GetRoofLivery()
	if self:Exists() then
		return GetVehicleRoofLivery(self.id)
	end
end

function Vehicle:GetWheelType()
	if self:Exists() then
		return GetVehicleWheelType(self.id)
	end
end

function Vehicle:GetExtras()
	local extras = {}
	for extraId=0, 15, 1 do
		table.insert(extras, {
			extraId=extraId,
			toggle=IsVehicleExtraTurnedOn(self.id, extraId) == 1
		})
	end
	return extras
end

function Vehicle:GetBurstTyres()
	-- this is awful but easy to read
	return {
																	--[[     .____.      ]]
																	--[[    /      \     ]]
		{wheelId=0, burst=IsVehicleTyreBurst(self.id, 0, true)},  	--[[  O|       |O    ]] {wheelId=1, burst=IsVehicleTyreBurst(self.id, 1, true)},
																	--[[   |       |     ]]
																	--[[   |       |     ]]
		{wheelId=2, burst=IsVehicleTyreBurst(self.id, 2, true)},	--[[  O|       |O    ]] {wheelId=3, burst=IsVehicleTyreBurst(self.id, 3, true)},
																	--[[   |       |     ]]
		{wheelId=4, burst=IsVehicleTyreBurst(self.id, 4, true)},	--[[  O|       |O    ]] {wheelId=5, burst=IsVehicleTyreBurst(self.id, 5, true)},
																	--[[   \______/      ]]
	}
end

function Vehicle:GetProperties()
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
	self.props.extras										= self:GetExtras() ]]
	self.props = TriggerClientCallback(self:GetOwner(), '__classes:vehicle:get:props', self:GetNetId())
	return self.props
end

function Vehicle:SetProperties(props)
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	else
		TriggerClientEvent('__classes:vehicle:set:props', self:GetOwner(), self:GetNetId(), props)
	end
end

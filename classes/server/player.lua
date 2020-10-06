
--[[

Player - Class

Init: Player(
	source		-- number
)

Player - methods

Player:GetPosition()
@return Coords object

Player:IsInVehicle()
@return boolean

Player:GetVehicleSitting()
@return Vehicle object

Player:GetLastVehicle()
@return Vehicle object

]]

_G.Player = setmetatable({}, {
	__tonumber = function(self)
		return self.source
	end,
	__tostring = function(self)
		return ('Player<%s>'):format(table.concat({'id: '..self.source, 'name: '..self.name}, ', '))
	end,
	__type = 'player',
	__call = function(self, source)
		if type(source) == 'number' then
			local identifiers = GetPlayerIdentifiers(source)
			if #identifiers == 0 then
				assert(nil, 'Source doesn\'t exists')
			end
			self.source = source
			self.ped = Ped(false, NetworkGetEntityFromNetworkId(self.source))
			self.name = GetPlayerName(self.source)
			self.identifiers = identifiers
			return self
		else
			assert(nil, 'Source expected number, but got '..type(source))
		end
	end
})

function Player:GetPosition()
	return Coords(GetEntityCoords(self.ped.id), GetEntityHeading(self.ped.id))
end

function Player:IsInVehicle()
	return IsPedSittingInAnyVehicle(self.ped.id)
end

function Player:GetVehicleSitting()
	if self:IsInVehicle() then
		return Vehicle(false, GetVehiclePedIsIn(self.ped.id, false))
	else
		return nil
	end
end

function Player:GetLastVehicle()
	local lastVeh = GetVehiclePedIsIn(self.ped.id, true)
	if lastVeh ~= nil or lastVeh ~= 0 then
		return Vehicle(false, lastVeh)
	end
	return nil
end

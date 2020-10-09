
--[[

Player - Class

Init: CPlayer(
	source		-- number
)

Player - methods

CPlayer:GetPosition()
@return Coords object

CPlayer:IsInVehicle()
@return boolean

CPlayer:GetVehicleSitting()
@return Vehicle object

CPlayer:GetLastVehicle()
@return Vehicle object

]]

_G.CPlayer = setmetatable({}, {
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

function CPlayer:GetPosition()
	return Coords(GetEntityCoords(self.ped.id), GetEntityHeading(self.ped.id))
end

function CPlayer:IsInsideVehicle()
	return self.ped:IsInsideVehicle()
end

function CPlayer:GetVehicle(last)
	if self:IsInsideVehicle() then
		return self.ped:GetVehicle(last)
	else
		return nil
	end
end

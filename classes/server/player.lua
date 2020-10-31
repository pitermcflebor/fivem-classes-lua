
exports('player', function()
	return
[=[
_G.CPlayer = {}
_G.PlayerMethods = {}

PlayerMethods.__call = function(self, source)
	local o = setmetatable({}, {
		__index = self,
		__tonumber = function(self)
			return self.source
		end,
		__tostring = function(self)
			return ('Player<%s>'):format(table.concat({'id: '..self.source, 'name: '..self.name}, ', '))
		end,
		__type = 'player',
	})
	if type(source) == 'number' then
		local identifiers = GetPlayerIdentifiers(source)
		if #identifiers == 0 then
			assert(nil, 'Source doesn\'t exists')
		end
		o.source = source
		o.ped = Ped(false, GetPlayerPed(o.source))
		o.name = GetPlayerName(o.source)
		o.identifiers = {}
		for _,identifier in pairs(identifiers) do
			local splitted = table.build(identifier:split(':'))
			o.identifiers[splitted[1]] = identifier
		end
	else
		assert(nil, 'Source expected number, but got '..type(source))
	end
	o.state = StateBag(o.source, true)
	return o
end

PlayerMethods.__index = {
	GetPosition = function(self)
		if self.ped ~= nil then
			return Coords(GetEntityCoords(self.ped.id), GetEntityHeading(self.ped.id))
		else
			warning('Player Ped doesn\'t exists!')
			return nil
		end
	end,

	IsInsideVehicle = function(self)
		if self.ped ~= nil then
			return self.ped:IsInsideVehicle()
		else
			warning('Player Ped doesn\'t exists!')
			return false
		end
	end,

	GetVehicle = function(self, last)
		if self:IsInsideVehicle() then
			return self.ped:GetVehicle(last)
		else
			return nil
		end
	end,
}

setmetatable(CPlayer, PlayerMethods)]=]
end)

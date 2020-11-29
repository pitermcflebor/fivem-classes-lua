
_G.CPlayer = {}
_G.PlayerMethods = {}

PlayerMethods.__call = function(self, source)
	local o = setmetatable({}, {
		__index = self,
		__tonumber = function(self) return self.id end,
		__tostring = function(self)
			return ('Player<%s>'):format(table.concat({'name: '..self:GetName(), 'source: '..self.source, 'id: '..self.id}, ', '))
		end,
		__type = 'Player',
	})
	if type(source) == 'number' and source == -1 then
		o.id = PlayerId()
		o.ped = Ped(false, PlayerPedId())
		o.serverId = GetPlayerServerId(o.id)
		o.source = o.serverId
	elseif type(source) == 'number' and source > 0 then
		o.serverId = source
		o.id = GetPlayerFromServerId(o.serverId)
		if NetworkIsPlayerActive(o.id) then
			o.ped = Ped(false, GetPlayerPed(o.id))
			o.source = o.serverId
		else
			warning('The Player %s doesn\'t exists!', source)
		end
	else
		warning('The paremeter need to be number, but got '..type(source))
	end
	if not StateBag then
		import 'statebag'
	end
	o.state = StateBag(o.source, true)
	return o
end

PlayerMethods.__index = {
	Exists = function(self)
		return self.ped:Exists()
	end,

	GetPosition = function(self)
		if not self:Exists() then
			warning('The Player Ped doesn\'t exists!')
		else
			return self.ped:GetPosition()
		end
	end,

	GetName = function(self)
		if not self:Exists() then
			warning('The Player Ped doesn\'t exists!')
		else
			return GetPlayerName(self.id)
		end
	end,

	IsInsideVehicle = function(self)
		if not self:Exists() then
			warning('The Player Ped doesn\'t exists!')
		else
			return self.ped:IsInsideVehicle()
		end
	end,

	GetVehicle = function(self, last)
		if not self:Exists() then
			warning('The Player Ped doesn\'t exists!')
		else
			return self.ped:GetVehicle(last)
		end
	end,

	PlayAnim = function(self, ...)
		if self:Exists() then
			return self.ped:PlayAnim(...)
		end
	end,

	StartScenario = function(self, ...)
		if self:Exists() then
			return self.ped:StartScenario(...)
		end
	end,

	ClearTasks = function(self)
		if self:Exists() then
			return self.ped:ClearTasks()
		end
	end
}

setmetatable(CPlayer, PlayerMethods)

--[[

Player - Class

Init: Player(
	source		-- number,
)

* source can be -1 or any number greater than 0
* -1 returns self player

Player - methods

Player:GetPosition()
@return Coords object

Player:GetName()
@return boolean

]]

_G.CPlayer = setmetatable({}, {
	__tonumber = function(self) return self.id end,
	__tostring = function(self)
		return ('Player<%s>'):format(table.concat({'name: '..self:GetName(), 'source: '..self.source, 'id: '..self.id}, ', '))
	end,
	__type = 'Player',
	__call = function(self, source)
		if type(source) == 'number' and source == -1 then
			self.id = PlayerId()
			self.ped = Ped(false, PlayerPedId())
			self.serverId = GetPlayerServerId(self.id)
			self.source = self.serverId
			return self
		elseif type(source) == 'number' and source > 0 then
			self.serverId = source
			self.id = GetPlayerFromServerId(self.serverId)
			print(self.serverId, self.id)
			if NetworkIsPlayerActive(self.id) then
				self.ped = Ped(false, GetPlayerPed(self.id))
				self.source = self.serverId
				return self
			else
				warning('The Player %s doesn\'t exists!', source)
			end
		else
			warning('The paremeter need to be number, but got '..type(source))
		end
	end
})

function CPlayer:Exists()
	return self.ped:Exists()
end

function CPlayer:GetPosition()
	if not self:Exists() then
		warning('The Player Ped doesn\'t exists!')
	end
	return self.ped:GetPosition()
end

function CPlayer:GetName()
	if not self:Exists() then
		warning('The Player Ped doesn\'t exists!')
	end
	return GetPlayerName(self.id)
end

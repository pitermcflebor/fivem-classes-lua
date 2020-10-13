
_G.Prop = {}
_G.PropMethods = {}

PropMethods.__call = function(self, newProp, p1, coords, isNetwork, freezeOnSpawn)
	local o = setmetatable({}, {
		__index = self,
		__tostring = function(self)
			return ('Prop<%s>'):format(table.concat({'id: '..self.id, 'model: '..(self.modelName or self.model)}, ', '))
		end,
	})

	if type(newProp) ~= 'boolean' then 
		assert(nil, "The newProp expected boolean, but got "..type(newProp))
	end
	if type(p1) ~= 'number' then
		if type(p1) ~= 'string' then
			assert(nil, "The second parameter expected number or string, but got "..type(p1))
		else
			o.modelName = p1
			o.model = GetHashKey(o.modelName)
		end
	else
		o.model = p1
	end
	if _type(coords) ~= 'Coords' then
		if type(coords) ~= 'vector4' then
			assert(nil, "The coords parameter expected Coords or Vector4, but got "..type(coords))
		end
	end
	if type(isNetwork) ~= 'boolean' then
		assert(nil, "The isNetwork parameter expected boolean, but got "..type(isNetwork))
	end
	if type(freezeOnSpawn) ~= 'boolean' then
		if type(freezeOnSpawn) ~= 'nil' then
			assert(nil, "The freezeOnSpawn parameter expected boolean or nil, but got "..type(freezeOnSpawn))
		end
	end

	if newProp == true then
		o.id = CreateObjectNoOffset(o.model, coords.x, coords.y, coords.z, isNetwork, true, false)
		while not DoesEntityExist(o.id) do Wait(0) end
		FreezeEntityPosition(o.id, freezeOnSpawn or false)
		o.freezed = freezeOnSpawn or false
	elseif newProp == false then
		o.id = p1
	end

	o.state = StateBag(o.id)

	return o
end

PropMethods.__index = {
	Exists = function(self)
		return (DoesEntityExist(self.id) == 1)
	end,

	WaitForExistence = function(self)
		while not self:Exists() do Wait(0) end
	end,

	Delete = function(self)
		if not self:Exists() then
			warning('Prop doesn\'t exists!')
			return
		end
		DeleteEntity(self.id)
	end,
	Remove = function(self)
		if not self:Exists() then
			warning('Prop doesn\'t exists!')
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
			warning('Prop doesn\'t exists!')
		end
		if self.freezed == nil or self.freezed == false then
			FreezeEntityPosition(self.id, true)
			self.freezed = true
			if ms ~= nil and type(ms) == 'number' then
				SetTimeout(ms, function()
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
}

setmetatable(Prop, PropMethods)

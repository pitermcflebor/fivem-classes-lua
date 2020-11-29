
_G.Prop = {}
_G.PropMethods = {}

PropMethods.__call = function(self, newProp, p1, coords, isNetwork, freezeOnSpawn)
	local o = setmetatable({}, {
		__index = self,
		__tostring = function(self)
			return ('Prop<%s>'):format(table.concat({'id: '..self.id, 'model: '..(self.modelName or self.model)}))
		end,
	})

	if type(newProp) ~= 'boolean' then error("The newProp expected boolean, but got "..type(newProp)) end
	if type(p1) ~= 'number' then
		if type(p1) ~= 'string' then
			error("The second parameter expected number or string, but got "..type(p1))
		else
			o.modelName = p1
			o.model = GetHashKey(o.modelName)
		end
	else
		if newProp then
			o.model = p1
		else
			o.model = GetEntityModel(p1)
		end
	end

	if newProp == true then
		if _type(coords) ~= 'Coords' then
			if type(coords) ~= 'vector4' then
				error("The coords parameter expected Coords or Vector4, but got "..type(coords))
			end
		end
		if type(isNetwork) ~= 'boolean' then error("The isNetwork parameter expected boolean, but got "..type(isNetwork)) end
		if type(freezeOnSpawn) ~= 'boolean' or type(freezeOnSpawn) ~= 'nil' then error("The freezeOnSpawn parameter expected boolean or nil, but got "..type(freezeOnSpawn)) end
		o.id = CreateObject(o.model, coords.x, coords.y, coords.z, isNetwork, true, false)
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

	GetPosition = function(self)
		return Coords(GetEntityCoords(self.id), GetEntityHeading(self.id))
	end,

	SwapModel = function(self, newModel)
		local pos = self:GetPosition()
		self.swapModel = (type(newModel) == 'string' and GetHashKey(newModel) or newModel)
		if not IsModelInCdimage(self.swapModel) then
			warning('Model %s isn\'t on Cdimage!', self.swapModel)
		else
			TimeoutRequestModel(self.swapModel)
			CreateModelSwap(pos.x, pos.y, pos.z, 1.0, self.model, self.swapModel, false)
			self.model = self.swapModel
		end
	end,
}

setmetatable(Prop, PropMethods)
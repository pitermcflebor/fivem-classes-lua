
_G.Ped = {}
_G.PedMethods = {}

PedMethods.__call = function(self, newPed, p1, pedType, x, y, z, heading)
	local o = setmetatable({}, {
		__index = self,
		__tonumber = function(self)
			return self.id
		end,
		__tostring = function(self)
			return ('Ped<%s>'):format(table.concat({self.id, (self.modelName or self.model)}, ', '))
		end,
		__type = 'Ped',
	})
	if newPed == true then
		if type(p1) ~= 'number' then
			if type(p1) ~= 'string' then
				assert(nil, 'Second paremeter expected number or string, but got '..type(p1))
			else
				o.modelName = p1
			end
		end
		if type(pedType) ~= 'number' then
			assert(nil, 'Ped type expected number, but got '..type(pedType))
		end
		if pedType >= 0 then
			if pedType > 29 then
				assert(nil, 'Ped type cannot be more than 29')
			end
		else
			assert(nil, 'Ped type cannot be less than 0')
		end
		if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(heading) ~= 'number' then
			assert(nil, 'X, Y, Z or Heading wasn\'t a number')
		end
		if o.modelName then
			o.model = GetHashKey(o.modelName)
		else
			o.model = p1
		end
		o.id = CreatePed(pedType, o.model, x, y, z, heading, true, true)
	elseif newPed == false then
		if type(p1) == 'number' then
			if not DoesEntityExist(p1) then
				warning('Created a Ped class to a non-existent entity, is that ok?')
			end
			o.id = p1
			o.model = GetEntityModel(p1)
		else
			assert(nil, 'Second parameter expected number, but got '..type(newPed))
		end
	elseif type(newPed) ~= 'boolean' then
		assert(nil, 'First paremeter expected boolean, but got '..type(newPed))
	end
	o.state = StateBag(o.id)
	return o
end

PedMethods.__index = {
	Exists = function(self)
		return (DoesEntityExist(self.id) == 1 and true or false)
	end,

	WaitForExistence = function(self)
		while not self:Exists() do Wait(0) end
	end,

	Delete = function(self)
		if self:Exists() then
			DeleteEntity(self.id)
		end
	end,
	Remove = function(self)
		if self:Exists() then
			DeleteEntity(self.id)
		end
	end,

	GiveWeapon = function(self, weaponModel, ammo, equipNow, isHidden)
		if self:Exists() then
			GiveWeaponToPed(self.id, GetHashKey_2(weaponModel), ammo, isHidden or false, equipNow or false)
		end
	end,

	RemoveWeapon = function(self, weaponModel)
		if self:Exists() then
			RemoveWeaponFromPed(self.id, GetHashKey_2(weaponModel))
		end
	end,

	GetPosition = function(self)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		local x,y,z = GetEntityCoords(self.id)
		local heading = GetEntityHeading(self.id)
		return Coords(x,y,z,heading)
	end,

	IsInsideVehicle = function(self, last)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		local v = GetVehiclePedIsIn(self.id, last or false) ~= 0
		return v
	end,

	GetVehicle = function(self, last)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		if not self:IsInsideVehicle(last) then
			warning('The Ped isn\'t in inside vehicle!')
			return
		end
		return Vehicle(false, GetVehiclePedIsIn(self.id, last or false))
	end,
}

setmetatable(Ped, PedMethods)


--[[

Ped - Class

Init: Ped(
	newPed		-- boolean,
	p1			-- string/number,
	pedType		-- number [0-29],
	x			-- number,
	y			-- number,
	z			-- number,
	heading		-- number,
	isNetwork	-- boolean,
)

* if newPed is true, p1 will be a string or number with the ped model
* if newPed is false, p1 will be a number with the ped entity id

Ped - methods



]]

_G.Ped = {}
_G.PedMethods = {}

PedMethods.__call = function(self, newPed, p1, pedType, x, y, z, heading, isNetwork)
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
		if type(isNetwork) ~= 'boolean' then
			assert(nil, 'isNetwork parameter was '..type(isNetwork)..' but expected boolean')
		end
		o.model = GetHashKey(p1)
		o.id = CreatePed(pedType, o.model, x, y, z, heading, isNetwork, true)
	elseif newPed == false then
		if type(p1) == 'number' then
			if DoesEntityExist(p1) then
				o.id = p1
				o.model = GetEntityModel(p1)
			else
				assert(nil, 'The entity doesn\'t exists')
			end
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

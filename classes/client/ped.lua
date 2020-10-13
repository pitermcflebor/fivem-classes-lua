
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

Ped:Exists()
@return boolean

Ped:GetPosition()
@return Coords object

]]

_G.Ped = {}
_G.PedMethods = {}

PedMethods.__call = function(self, newPed, p1, pedType, x,y,z,w, isNetwork)
	local o = setmetatable({}, {
		__index = self,
		__tonumber = function(self) return self.id end,
		__tostring = function(self) return ('Ped<%s>'):format(table.concat({self.id, self.modelName}, ', ')) end,
		__type = 'Ped',
	})
	if newPed == true then
		if type(p1) == 'number' or type(p1) == 'string' then
			if pedType >= 0 then
				if pedType > 29 then
					assert(nil, 'Ped type cannot be more than 29')
				end
			else
				assert(nil, 'Ped type cannot be less than 0')
			end
			if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(w) ~= 'number' then
				assert(nil, 'The X, Y, Z or Heading expected number')
			end
			if type(isNetwork) == 'boolean' then
				assert(nil, 'The isNetwork expected boolean, but got '..type(isNetwork))
			end
			if type(p1) == 'string' then o.modelName = p1 end
			o.model = GetHashKey(p1)
			o.id = CreatePed(pedType, o.model, x, y, z, w, isNetwork, true)
			return o
		else
			assert(nil, 'The second parameter expected number, but got '..type(p1))
		end
	elseif newPed == false then
		if type(p1) == 'number' then
			if DoesEntityExist(p1) then
				o.id = p1
				o.model = GetEntityModel(o.id)
				return o
			else
				assert(nil, 'The entity doesn\'t exists!')
			end
		else
			assert(nil, 'The second parameter expected number, but got '..type(p1))
		end
	elseif type(newPed) ~= 'boolean' then
		assert(nil, 'First parameter expected boolean, but got '..type(newPed))
	end
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
		local coords = GetEntityCoords(self.id)
		local heading = GetEntityHeading(self.id)
		return Coords(coords.x, coords.y, coords.z, heading)
	end,
	
	IsInsideVehicle = function(self)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		return IsPedSittingInAnyVehicle(self.id)
	end,
	
	GetVehicle = function(self, last)
		if not self:Exists() then
			warning('The Ped doesn\'t exists!')
			return
		end
		return Vehicle(false, GetVehiclePedIsIn(self.id, last or false))
	end,
}

setmetatable(Ped, PedMethods)


--[[

Vehicle - Class

Init: Vehicle(
	newVehicle 	-- boolean,
	p1 			-- number,
	x			-- number,
	y			-- number,
	z			-- number,
	heading		-- number,
	isNetwork	-- boolean
)

* if newVehicle is true, p1 will be the vehicle model hash
* if newVehicle is false, p1 will be the vehicle entity id

Vehicle - methods

Vehicle:Exists()
@return boolean

void Vehicle:Delete() or Vehicle:Remove()
@raise error if entity not exists

void Vehicle:Freeze([ms])
@raise error if entity not exists

Vehicle:GetPosition()
@raise error if entity not exists
@return Coords object

void Vehicle:SetPedInside(ped[, seat])
@raise error if entity not exists

void Vehicle:EveryoneLeave()
@raise error if entity not exists

]]

_G.Vehicle = setmetatable({}, {
	__tonumber = function(self)
		return self.id
	end,
	__tostring = function(self)
		return ('Vehicle<%s>'):format(table.concat({'id: '..self.id, 'model: '..(self.modelName or 'unk')}, ', '))
	end,
	__type = 'vehicle',
	__call = function(self, newVehicle, p1, x, y, z, heading, isNetwork)
		if newVehicle == true then
			if type(p1) ~= 'number' then
				if type(p1) ~= 'string' then
					assert(nil, 'Second parameter expected number or string, but got '..type(p1))
				else
					self.modelName = p1
				end
			end
			if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(heading) ~= 'number' then
				assert(nil, 'X, Y, Z or Heading expected number')
			end
			if type(isNetwork) ~= 'boolean' then
				assert(nil, 'isNetwork expected boolean')
			end
			self.model = GetHashKey(p1)
			self.id = CreateVehicle(self.model, x, y, z, heading, isNetwork, true)
			return self
		elseif newVehicle == false then
			if type(p1) == 'number' then
				if DoesEntityExist(p1) then
					self.id = p1
					self.model = GetEntityModel(p1)
					return self
				else
					assert(nil, 'The entity passed doesn\'t exists!')
				end
			else
				assert(nil, 'Second parameter expected number, but got '..type(p1))
			end
		elseif type(newVehicle) ~= 'boolean' then
			assert(nil, 'First paremeter expected boolean, but got '..type(newVehicle))
		end
	end
})

function Vehicle:Exists()
	return (DoesEntityExist(self.id) == 1 and true or false)
end

function Vehicle:Delete()
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	end
	DeleteEntity(self.id)
end
function Vehicle:Remove()
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	end
	DeleteEntity(self.id)
end


function Vehicle:Freeze(ms)
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	end
	if self.freezed == nil or self.freezed == false then
		FreezeEntityPosition(self.id, true)
		self.freezed = true
		if ms ~= nil and type(ms) == 'number' then
			CreateThread(function()
				Wait(ms)
				if self.freezed == true then
					FreezeEntityPosition(self.id, false)
				end
			end)
		end
	elseif self.freezed == true then
		FreezeEntityPosition(self.id, false)
		self.freezed = false
	end
	return true
end

function Vehicle:GetPosition()
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	end
	local x,y,z = GetEntityCoords(self.id)
	return Coords(x,y,z)
end

function Vehicle:SetPedInside(ped, seat)
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	end
	if type(ped) == 'number' then
		if math.type(seat) == 'integer' then
			if seat < -2 then
				warning('Seat need to be more than -2, but got ', tostring(seat))
			end
			TaskWarpPedIntoVehicle(tonumber(ped), self.id, seat)
			return true
		else
			warning('Expected Seat as integer, but got %s', (math.type(seat) ~= nil and math.type(seat) or type(seat)))
		end
	else
		warning('Expected Ped as number, but got %s', type(ped))
	end
end

function Vehicle:EveryoneLeave()
	if not self:Exists() then
		warning('Vehicle doesn\'t exists!')
	end
	TaskEveryoneLeaveVehicle(self.id)
end


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

]]

_G.Vehicle = setmetatable({}, {
	__tonumber = function(self)
		return self.id
	end,
	__tostring = function(self)
		return ('Vehicle<%s>'):format(table.concat({'id: '..self.id, 'model: '..self.modelName}, ', '))
	end,
	__type = function(self)
		return 'Vehicle'
	end,
	__call = function(self, newVehicle, p1, x, y, z, heading, isNetwork)
		if newVehicle == true then
			if type(p1) == 'string' or type(p1) == 'number' then
				self.model = GetHashKey(p1)
				if IsModelInCdimage(self.model) then
					if not HasModelLoaded(self.model) then
						RequestModel(self.model)
						repeat Wait(0) until (HasModelLoaded(self.model))
					end

					if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(heading) ~= 'number' then
						assert(nil, 'X, Y, Z or Heading wasn\'t a number')
					end
					if type(isNetwork) ~= 'boolean' then
						assert(nil, 'isNetwork parameter was '..type(isNetwork)..' but expected boolean')
					end

					if type(p1) == 'string' then self.modelName = p1 end

					self.id = CreateVehicle(self.model, x, y, z, heading, isNetwork, true)

					return self
				else
					assert(nil, 'The model '..p1..' doesn\'t exists!')
				end
			else
				assert(nil, 'Second parameter was '..type(p1)..' but expected string or number')
			end
		elseif newVehicle == false then
			if DoesEntityExist(p1) then
				if not NetworkGetEntityOwner(p1) == PlayerId() then
					warning('The entity you tried to select isn\'t owned by you, you will experience some issues!')
				end
				self.id = p1
				self.model = GetEntityModel(p1)

				return self
			else
				assert(nil, 'The entity passed doesn\t exists')
			end
		elseif type(newVehicle) ~= 'boolean' then
			assert(nil, 'First parameter was '..type(newVehicle)..', expected boolean')
		end
	end
})

function Vehicle:SetPedInside(ped, seat)
	if DoesEntityExist(self.id) then
		if _type(ped) == 'number' then
			if not IsPedAPlayer(ped) then
				TaskWarpPedIntoVehicle(ped, self.id, seat)
				return true
			elseif IsPedAPlayer(ped) and ped == PlayerPedId() then
				TaskWarpPedIntoVehicle(ped, self.id, seat)
				return true
			end
		elseif _type(ped) == 'Ped' then
			if not IsPedAPlayer(ped.id) then
				TaskWarpPedIntoVehicle(ped.id, self.id, seat)
				return true
			elseif IsPedAPlayer(ped.id) and ped.id == PlayerPedId() then
				TaskWarpPedIntoVehicle(ped.id, self.id, seat)
				return true
			end
		end
	end
	return false
end

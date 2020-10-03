
_G.Vehicle = setmetatable({}, {
	__tonumber = function(self)
		return self.id
	end,
	__tostring = function(self)
		return tostring(self.id)
	end,
	__type = function(self)
		return 'Vehicle'
	end,
	__call = function(self, newVehicle, p1, x, y, z, heading, isNetwork)
		if newVehicle == true then
			if type(p1) == 'string' or type(p1) == 'number' then
				model = GetHashKey(p1)
				if IsModelInCdimage(model) then
					if not HasModelLoaded(model) then
						RequestModel(model)
						repeat Wait(0) until (HasModelLoaded(model))
					end

					if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' or type(heading) ~= 'number' then
						assert(nil, 'X, Y, Z or Heading wasn\'t a number')
					end
					if type(isNetwork) ~= 'boolean' then
						assert(nil, 'isNetwork parameter was '..type(isNetwork)..' but expected boolean')
					end

					self.id = CreateVehicle(model, x, y, z, heading, isNetwork, true)

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
					print('WARNING | The entity you tried to select isn\'t owned by you, you will experience some issues!')
				end
				self.id = p1

				return self
			else
				assert(nil, 'The entity passed doesn\t exists')
			end
		elseif type(newVehicle) ~= 'boolean' then
			assert(nil, 'First parameter was '..type(newVehicle)..', expected boolean')
		end
	end
})

function Vehicle:GetPedInside(ped, seat)
	if DoesEntityExist(self.id) then
		if type(ped) == 'number' then
			if not IsPedAPlayer(ped) then
				TaskWarpPedIntoVehicle(ped, self.id, seat)
				return true
			elseif IsPedAPlayer(ped) and ped == PlayerPedId() then
				TaskWarpPedIntoVehicle(ped, self.id, seat)
				return true
			end
		end
	end
	return false
end

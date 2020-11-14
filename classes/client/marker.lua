
if GetCurrentResourceName() == 'classes' then -- fix for older versions
exports('marker', function()
	return
[=[_G.Marker = {}
_G.MarkerMethods = {}

-- init
MarkerMethods.__call = function(self, markerType, pos, radius, r, g, b, alpha, reserved)
	local o = setmetatable({}, {
		__index = self
	})
	if type(markerType) == 'number' and math.type(markerType) == 'integer' then
		if markerType < 0 then assert(nil, 'markerType can\'t be lower than 0') end
		if markerType > 65 then assert(nil, 'markerType can\'t be greater than 64') end
		if _type(pos) == 'Coords' then
			if type(radius) == 'number' then
				if type(r) == 'number' and type(g) == 'number' and type(b) == 'number' and type(alpha) == 'number' then
					o.id = CreateCheckpoint(markerType, pos.x, pos.y, pos.z, pos.x, pos.y, pos.z, radius, r, g, b, alpha, (reserved or 0))
					o.coords = pos
					o.markerType = markerType
					o.reserved = reserved
					o.radius = radius
					return o
				else
					assert(nil, 'r, g, b or alpha wasn\'t a number!')
				end
			else
				assert(nil, 'radius parameter needed number, but got '..type(radius))
			end
		else
			assert(nil, 'pos parameter needed Coords, but got '..type(pos1))
		end
	else
		assert(nil, 'markerType parameter needed number (integer), but got '..type(markerType))
	end
end

-- methods
MarkerMethods.__index = {
	Delete = function(self)
		DeleteCheckpoint(self.id)
		self.threadWorking = false
	end,

	SetCylinderHeight = function(self, nearHeight, farHeight, radius)
		SetCheckpointCylinderHeight(self.id, nearHeight, farHeight, radius)
	end,

	SetIconRgba = function(self, red, green, blue, alpha)
		SetCheckpointIconRgba(self.id, red, green, blue, alpha)
	end,

	SetRgba = function(self, red, green, blue, alpha)
		SetCheckpointRgba(self.id, red, green, blue, alpha)
	end,

	SetScale = function(self, p0)
		SetCheckpointScale(self.id, p0)
	end,

	Inside = function(self, cb)
		self.threadWorking = true
		self.inside = false
		self.threadWorkingTime = 0
		Citizen.CreateThreadNow(function()
			while self.threadWorking do
				if Vdist2(self.coords.x, self.coords.y, self.coords.z, GetEntityCoords(PlayerPedId())) <= self.radius*1.5 then
					if not self.inside then self.inside = true end
					cb(self)
					self.threadWorkingTime = 0
				else
					if self.inside then collectgarbage("collect") end
					self.threadWorkingTime = 100
				end
				Wait(self.threadWorkingTime)
			end
		end)
	end,

	Outside = function(self, cb)
		self.threadWorking = true
		Citizen.CreateThreadNow(function()
			while self.threadWorking do
				if Vdist2(self.coords.x, self.coords.y, self.coords.z, GetEntityCoords(PlayerPedId())) > self.radius*1.5 then
					cb(self)
				end
				Wait(self.threadWorkingTime)
			end
		end)
	end
}

-- class
setmetatable(Marker, MarkerMethods)]=]
end)
else
	local func, err = load(exports.classes:marker())
	assert(func, err)
	func()
end
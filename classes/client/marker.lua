--[[

Checkpoint types:
0-4---------- Cylinder: 1 arrow, 2 arrow, 3 arrows, CycleArrow, Checker
5-9---------- Cylinder: 1 arrow, 2 arrow, 3 arrows, CycleArrow, Checker (Z is on ground)
10-14-------- Ring: 1 arrow, 2 arrow, 3 arrows, CycleArrow, Checker
15-19-------- 1 arrow, 2 arrow, 3 arrows, CycleArrow, Checker      
20-24-------- Cylinder: 1 arrow, 2 arrow, 3 arrows, CycleArrow, Checker 
25-29-------- Cylinder: 1 arrow, 2 arrow, 3 arrows, CycleArrow, Checker    
30-34-------- Cylinder: 1 arrow, 2 arrow, 3 arrows, CycleArrow, Checker 
35-38-------- Ring: Airplane Up, Left, Right, UpsideDown
39----------- none
40----------- Ring: just a ring
41----------- none
42-44-------- Cylinder w/ number (uses 'reserved' parameter)
* changing reserved value:
	- 0-99 numbers
	- 100-109 arrow
	- 110-119 double arrow
	- 120-129 triple arrow
	- 130-139 ground big circle
	- 140-149 cycle
	- 150-159 ground slim circle
	- 160-169 ground circle with arrow
	- 170-179 ground circle with spaces
	- 180-189 world sphere
	- 190-199 dollar
	- 200-209 lines
	- 210-219 wolf
	- 220-229 ?
	- 230-239 plane
	- 240-249 helicopter
	- 250-255 boat
* restart at 256
45-47-------- Cylinder no arrow or number
48-51-------- none
52----------- ring with dollar inside
53----------- ring with wolf inside
54----------- ring with ? inside
55----------- ring with plane inside
56----------- ring with helicopter inside
57----------- ring with boat inside
58----------- ring with car inside
59----------- ring with motorbike inside
60----------- ring with bike inside
61----------- ring with truck inside
62----------- ring with parachute inside
63----------- ring with jetpack inside
64----------- ring with hurricane? inside

]]

-- Marker - Class
-- (markerType, pos, radius, r, g, b, alpha, reserved)
--[[

Marker - methods

Marker:Delete()
- delete the marker
Marker:SetCylinderHeight(nearHeight, farHeight, radius)
- change cylinder height
Marker:SetIconRgba(red, green, blue, alpha)
- change the marker icon color
Marker:SetScale(p0)
- change the marker scale ??
Marker:Inside(function)
- executes 'function' while inside
Marker:Outside(function)
- executes 'function' while outside

]]

_G.Marker = {}

MarkerMethods = {}

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
		Citizen.CreateThreadNow(function()
			while self.threadWorking do
				if Vdist2(self.coords.x, self.coords.y, self.coords.z, GetEntityCoords(PlayerPedId())) <= self.radius*1.5 then
					if not self.inside then self.inside = true end
					cb(self)
				else
					if self.inside then collectgarbage("collect") end
				end
				Wait(0)
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
				Wait(0)
			end
		end)
	end
}

-- class
setmetatable(Marker, MarkerMethods)

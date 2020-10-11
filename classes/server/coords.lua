
--
-- Coords - class
--
-- Init: Coords(
--		x --[[ number ]],
--		y --[[ number ]], 
--		z --[[ number ]], 
--		w --[[ number ]]
--	)
-- All parameters are optional
--
-- Example:
--
-- local myCoords = Coords(35.645, 16.234, 76.912)
--
--
-- Coords - methods
--
-- void Coords:UpdateX(x --[[ number ]])
-- void Coords:UpdateY(y --[[ number ]])
-- void Coords:UpdateZ(z --[[ number ]])
-- void Coords:UpdateW(w --[[ number ]])
--
-- Coords - Additonal methods
--
-- local x, y, z, w = table.unpack(myCoords)
-- local x, y, z, w = myCoords.xyzw
-- local x, y = myCoords.xy
--

_G.Coords = {}
CoordsMethods = {}

-- methods
CoordsMethods.__index = {
	UpdateX = function(self, v)
		if math.type(v) == 'float' then
			self.x = v
		elseif math.type(v) == 'integer' then
			self.x = v + 0.0
		else
			warning('The new X need to be an integer or a float, not a '..type(v))
		end
	end,
	
	UpdateY = function(self, v)
		if math.type(v) == 'float' then
			self.y = v
		elseif math.type(v) == 'integer' then
			self.y = v + 0.0
		else
			warning('The new Y need to be an integer or a float, not a '..type(v))
		end
	end,
	
	UpdateZ = function(self, v)
		if math.type(v) == 'float' then
			self.z = v
		elseif math.type(v) == 'integer' then
			self.z = v + 0.0
		else
			warning('The new Z need to be an integer or a float, not a '..type(v))
		end
	end,
	
	UpdateW = function(self, v)
		if math.type(v) == 'float' then
			self.w = v
		elseif math.type(v) == 'integer' then
			self.w = v + 0.0
		else
			warning('The new W need to be an integer or a float, not a '..type(v))
		end
	end
}

-- init
CoordsMethods.__call = function(self, ...)
	local o = setmetatable({}, {
		__index = self,
		__tostring = function(self)
			return ("Coords<%s>"):format(table.concat({'X: '..self.x, 'Y: '..self.y, 'Z: '..self.z, 'W: '..self.w}, ', '))
		end,
		__tonumber = function(self)
			return vec(self.x, self.y, self.z)
		end,
		__type = 'Coords',
		--[[ __index = function(self, k)
			if k == 'x' or k == 'y' or k == 'z' or k == 'w' or k == 'heading' then
				return self[k]
			end
			if k == 'xy' then
				return self.x, self.y
			end
			if k == 'xyz' then
				return self.x, self.y, self.z
			end
			if k == 'xyzw' then
				return self.x, self.y, self.z, self.w
			end
		end, ]]
		__unpack = function(self)
			return self.x, self.y, self.z, self.w
		end,
		__pack = function(self)
			return {x=self.x, y=self.y, z=self.z, w=self.w}
		end
	})
	local params = {...}
	o.x = 0.0
	o.y = 0.0
	o.z = 0.0
	o.w = 0.0
	if type(params[1]) == 'number' then
		-- is passing each parameter
		o.x = tonumber(params[1]) or 0.0
		o.y = tonumber(params[2]) or 0.0
		o.z = tonumber(params[3]) or 0.0
		o.w = tonumber(params[4]) or 0.0
	elseif type(params[1]) == 'vector2' then
		-- is passing X and Y
		o.x, o.y = params[1].x, params[1].y
	elseif type(params[1]) == 'vector3' then
		-- is passing X Y and Z
		o.x, o.y, o.z = params[1].x, params[1].y, params[1].z
		if type(params[2]) == 'number' then
			o.w = tonumber(params[2]) or 0.0
		end
	elseif type(params[1]) == 'vector4' then
		-- is passing X Y Z and W
		o.x, o.y, o.z, o.w = params[1].x, params[1].y, params[1].z, params[1].w
	elseif type(params[1]) == 'table' then
		o.x = tonumber(params[1].x) or 0.0
		o.y = tonumber(params[1].y) or 0.0
		o.z = tonumber(params[1].z) or 0.0
		o.w = tonumber((params[1].w or params[1].heading)) or 0.0
	else
		assert(nil, 'None of the passed parameters are number, vector2, vector3, vector4 or a table')
	end

	if math.type(o.x) == 'integer' then
		o.x = o.x + 0.0
	end
	if math.type(o.y) == 'integer' then
		o.y = o.y + 0.0
	end
	if math.type(o.z) == 'integer' then
		o.z = o.z + 0.0
	end
	if math.type(o.w) == 'integer' then
		o.w = o.w + 0.0
	end
	o.heading = o.w
	return o
end

-- class
setmetatable(Coords, CoordsMethods)

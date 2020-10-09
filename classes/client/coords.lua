
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

_G.Coords = setmetatable({}, {
	__tonumber = function(self)
		return vec(self.x, self.y, self.z)
	end,
	__tostring = function(self)
		return ("Coords<%s>"):format(table.concat({'X: '..self.x, 'Y: '..self.y, 'Z: '..self.z, 'W: '..self.w}, ', '))
	end,
	__type = 'Coords',
	__index = function(self, k)
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
	end,
	__unpack = function(self)
		return self.x, self.y, self.z, self.w
	end,
	__pack = function(self)
		return {x=self.x, y=self.y, z=self.z, w=self.w}
	end,
	__call = function(self, ...)
		local params = {...}
		self.x = 0.0
		self.y = 0.0
		self.z = 0.0
		self.w = 0.0
		if type(params[1]) == 'number' then
			-- is passing each parameter
			self.x = tonumber(params[1]) or 0.0
			self.y = tonumber(params[2]) or 0.0
			self.z = tonumber(params[3]) or 0.0
			self.w = tonumber(params[4]) or 0.0
		elseif type(params[1]) == 'vector2' then
			-- is passing X and Y
			self.x, self.y = params[1].x, params[1].y
		elseif type(params[1]) == 'vector3' then
			-- is passing X Y and Z
			self.x, self.y, self.z = params[1].x, params[1].y, params[1].z
			if type(params[2]) == 'number' then
				self.w = tonumber(params[2]) or 0.0
			end
		elseif type(params[1]) == 'vector4' then
			-- is passing X Y Z and W
			self.x, self.y, self.z, self.w = params[1].x, params[1].y, params[1].z, params[1].w
		elseif type(params[1]) == 'table' then
			self.x = tonumber(params[1].x) or 0.0
			self.y = tonumber(params[1].y) or 0.0
			self.z = tonumber(params[1].z) or 0.0
			self.w = tonumber((params[1].w or params[1].heading)) or 0.0
		else
			assert(nil, 'None of the passed parameters are number, vector2, vector3, vector4 or a table')
		end

		if math.type(self.x) == 'integer' then
			self.x = self.x + 0.0
		end
		if math.type(self.y) == 'integer' then
			self.y = self.y + 0.0
		end
		if math.type(self.z) == 'integer' then
			self.z = self.z + 0.0
		end
		if math.type(self.w) == 'integer' then
			self.w = self.w + 0.0
		end
		self.heading = self.w

		return self
	end
})

function Coords:UpdateX(v)
	if math.type(v) == 'float' then
		self.x = v
	elseif math.type(v) == 'integer' then
		self.x = v + 0.0
	else
		warning('The new X need to be an integer or a float, not a '..type(v))
	end
end

function Coords:UpdateY(v)
	if math.type(v) == 'float' then
		self.y = v
	elseif math.type(v) == 'integer' then
		self.y = v + 0.0
	else
		warning('The new Y need to be an integer or a float, not a '..type(v))
	end
end

function Coords:UpdateZ(v)
	if math.type(v) == 'float' then
		self.z = v
	elseif math.type(v) == 'integer' then
		self.z = v + 0.0
	else
		warning('The new Z need to be an integer or a float, not a '..type(v))
	end
end

function Coords:UpdateW(v)
	if math.type(v) == 'float' then
		self.w = v
	elseif math.type(v) == 'integer' then
		self.w = v + 0.0
	else
		warning('The new W need to be an integer or a float, not a '..type(v))
	end
end


_G.Coords = setmetatable({}, {
	__tonumber = function(self)
		return self.x, self.y, self.z
	end,
	__tostring = function(self)
		return ("Coords<%s>"):format(table.concat({'X: '..self.x, 'Y: '..self.y, 'Z: '..self.z, 'W: '..self.w}, ', '))
	end,
	__type = 'coords',
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

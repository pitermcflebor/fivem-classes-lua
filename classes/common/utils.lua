-- THIS IS AN ITERATOR
-- Example:
--[[
local str = "hello world!"
for word in str:split() do
	print(word)
end
]]
-- Example returning table of words:
--[[
table.build(("hello world!"):split())
-- this returns a table {'hello', 'world!'}
table.build(("foo,bar,bee,bear"):split(','))
-- this returns {'foo','bar','bee','bear'}
]]
function string:split(pat)
	pat = pat or '%s+'
	local st, g = 1, self:gmatch("()("..pat..")")
	local function getter(segs, seps, sep, cap1, ...)
	st = sep and seps + #sep
	return self:sub(segs, (seps or 0) - 1), cap1 or sep, ...
	end
	return function() if st then return getter(st, g()) end end
end

-- Example:
--[[
local str = 'this is a test'
if str:startsWith('this') then
	-- returns true or false
	...
end
]]
function string:startsWith(start)
	return self:sub(1, #start) == start
end

-- Example:
--[[
local str = 'this is a test'
if str:endsWith('test') then
	-- returns true or false
	...
end
]]
function string:endsWith(ending)
	return ending == "" or self:sub(-#ending) == ending
end

-- Example:
-- Remove unnecesary spaces
--[[
local str = '   this is a test   '
print( str:trim() ) -- prints: 'this is a test'
]]
function string:trim()
	local n = self:find"%S"
	return n and self:match(".*%S", n) or ""
end

-- Example:
-- Build a table with an iterable function
--[[
table.build(("this is a test"):split()) -- returns a table
]]
function table.build(iter)
	if type(iter) ~= 'function' then return nil end
	local t = {}
	for i in iter do table.insert(t, i) end
	return t
end

-- Example:
-- Fills a table with X input X times
--[[
table.fill('a', 3) -- returns {'a', 'a', 'a'}
]]
function table.fill(input, i)
	local t = {}
	for x=1, i, 1 do table.insert(t,input) end
	return t
end

-- Example:
-- Dump a table but prettier
--[[
print( table.dump(table.fill('a'), 3) )
-- output:
{
	[1] = 'a',
	[2] = 'a',
	[3] = 'a',
}
]]
function table.dump(t, nb)
	if type(t) == 'table' then
		local s = '{\n'
		for key, value in pairs(t) do
			s = s .. table.concat(table.fill('\t', nb or 1)) .. ('[%s] = %s,\n'):format((type(key) == 'string' and ("'%s'"):format(tostring(key)) or key), table.dump(value, (nb or 1)+1))
		end
		return s .. table.concat(table.fill('\t', ((nb or 1)-1 > 0 and nb-1 or 0))) .. '}'
	else
		return (type(t) == 'string' and ("'%s'"):format(tostring(t)) or t)
	end
end

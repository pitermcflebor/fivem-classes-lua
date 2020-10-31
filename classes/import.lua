
_G.import = function(t)
    if type(t) == 'table' then
        for _,className in pairs(t) do
			local f = exports.classes[className]()
            assert(f, 'The class '..className..' doesn\'t exists!')
			local func, err = load(f)
			assert(func, err)
			func()
        end
    elseif type(t) == 'string' then
        if t == '*' then
            local currentClasses
            if IsDuplicityVersion() then
                -- servers-ide
                import {
                    'coords',
                    'ped',
                    'player',
                    'prop',
                    'statebag',
                    'utils',
                    'vehicle'
                }
            else
                -- client-side
                import {
                    'coords',
                    'marker',
                    'ped',
                    'player',
                    'prop',
                    'statebag',
                    'utils',
                    'vehicle'
                }
            end
        else
            import {t}
        end
    else
        error 'Passed parameter to import isn\'t a table or string!'
    end
end

--
-- UTILS FUNCTIONS MOVED HERE!
--


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

-- Example:
-- Get the lower value
--[[
local my_table = {a = 50, b = 10, c = 5}
print( table.lower(my_table) )
-- output: 5, c
]]
function table.lower(t)
	assert(type(t) == 'table', '#1 wasn\'t a table')
	local lowerK
	for k,v in pairs(t) do
		if lowerK == nil then
			lowerK = k
		else
			if t[lowerK] > v then
				lowerK = k
			end
		end
	end
	return t[lowerK], lowerK
end

-- Example:
-- sorte a table
--[[
local my_table = {a = 50, b = 24, d = 1}
table.sorted(my_table)
for k,v in pairs(my_table) do
	print(k,v)
	-- output:
	1	table: {key=d, value=1}
	2	table: {key=b, value=24}
	3	table: {key=a, value=50}
end
]]
function table.sorted(t, customKey, reversed)
	assert(type(customKey) == 'string', 'customKey wasn\'t a string')
	assert(type(reversed) == 'boolean' or type(reversed) == 'nil', 'reversed wasn\'t a boolean')
	local new_t = {}
	for k,v in pairs(t) do table.insert(new_t, {key=k, value=v}) end
	table.sort(new_t,
	function(a,b)
		if type((customKey and a.value[customKey] or a.value)) == 'number' and type((customKey and b.value[customKey] or b.value)) == 'number' then
			if customKey then
				if not reversed then return a.value[customKey] < b.value[customKey]
				else return a.value[customKey] > b.value[customKey] end
			else
				if not reversed then return a.value < b.value
				else return a.value > b.value end
			end
		else
			return false
		end
	end)
	return new_t
end


function GetHashKey_2(m)
	if type(m) == 'number' then return m end
	if type(m) == 'string' then
		return GetHashKey(m)
	end
	error"Invalid Lua type in GetHashKey_2"
end

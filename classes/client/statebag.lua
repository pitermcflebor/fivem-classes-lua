
if GetCurrentResourceName() == 'classes' then -- fix for older versions
exports('statebag', function()
	return
[=[_G.StateBag = {}
_G.StateBagMethods = {}


StateBagMethods.__call = function(self, entityId, isPlayer)
	if type(entityId) == 'number' then
		local o = setmetatable({}, {__index = self})
		if isPlayer ~= nil and isPlayer == true then
			o.id = entityId
		else
			o.localId = entityId
			o.networked = NetworkGetEntityIsNetworked(entityId)
			if o.networked then
				o.id = NetworkGetNetworkIdFromEntity(entityId)
			else
				o.id = entityId
			end
		end
		return o
	else
		assert(nil, "The entityId expected number, but got "..type(entityId))
	end
end

StateBagMethods.__index = {
	clearAll = function(self, shared)
		if shared ~= nil and type(shared) ~= 'boolean' then
			assert(nil, "shared expected a boolean, but got "..type(shared))
		end
		TriggerEvent('__classes:client:statebags:update:all', self.id, {}, shared)
	end,

	clear = function(self, key, shared)
		if shared ~= nil and type(shared) ~= 'boolean' then
			assert(nil, "shared expected a boolean, but got "..type(shared))
		end
		TriggerEvent('__classes:client:statebags:update:one', self.id, key, nil, shared)
	end,

	set = function(self, key, value, shared)
		if key == nil then
			error "key was nil"
		end
		if value == nil then
			error "value was nil"
		end
		if shared ~= nil and type(shared) ~= 'boolean' then
			assert(nil, "shared expected a boolean, but got "..type(shared))
		end
		TriggerEvent('__classes:client:statebags:update:one', self.id, key, value, shared)
		return true
	end,

	get = function(self, key)
		if key == nil then
			error "key was nil"
		end
		local callback = promise:new()
		TriggerEvent('__classes:client:statebags:get', self.id, key, function(value)
			callback:resolve(value)
		end)
		return Citizen.Await(callback)
	end,
}


setmetatable(StateBag, StateBagMethods)]=]
end)
else
	local func, err = load(exports.classes:statebag())
	assert(func, err)
	func()
end
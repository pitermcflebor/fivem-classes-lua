--[[

StateBag - Class

Init
StateBag(entityId)
@entityId - the locally entity id

]]
_G.StateBag = {}
_G.StateBagMethods = {}


StateBagMethods.__call = function(self, entityId, isPlayer)
	if type(entityId) == 'number' then
		local o = setmetatable({}, {__index = self})
		if isPlayer ~= nil and isPlayer == true then
			o.id = entityId
		else
			o.localId = entityId
			if not DoesEntityExist(entityId) then
				warning('The entity you are trying to set StateBag doesn\'t exists! Maybe a onesync issue?')
			end
			o.id = NetworkGetNetworkIdFromEntity(entityId)
		end
		return o
	else
		error("The entityId expected number, but got "..type(entityId))
	end
end

StateBagMethods.__index = {
	clearAll = function(self, shared)
		if shared ~= nil and type(shared) ~= 'boolean' then
			error("shared expected a boolean, but got "..type(shared))
		end
		TriggerEvent('__classes:server:statebags:update:all', self.id, {}, shared)
	end,

	clear = function(self, key, shared)
		if shared ~= nil and type(shared) ~= 'boolean' then
			error("shared expected a boolean, but got "..type(shared))
		end
		TriggerEvent('__classes:server:statebags:update:one', self.id, key, nil, shared)
	end,

	set = function(self, key, value, shared)
		if key == nil then
			error "key was nil"
		end
		if value == nil then
			error "value was nil"
		end
		if shared ~= nil and type(shared) ~= 'boolean' then
			error("shared expected a boolean, but got "..type(shared))
		end
		TriggerEvent('__classes:server:statebags:update:one', self.id, key, value, shared)
		return true
	end,

	get = function(self, key)
		if key == nil then
			error "key was nil"
		end
		local callback = promise:new()
		TriggerEvent('__classes:server:statebags:get', self.id, key, function(value)
			callback:resolve(value)
		end)
		return Citizen.Await(callback)
	end,
}


setmetatable(StateBag, StateBagMethods)

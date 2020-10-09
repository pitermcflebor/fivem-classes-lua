
--
-- Creating a vehicle and setting a ped inside
--
local vehicle = Vehicle(
    true,           -- create a new vehicle?
    'cheetah',      -- vehicle model name or hash key
    0.0,            -- X spawn position
    0.0,            -- Y spawn position
    0.0,            -- Z spawn position
    0.0,            -- W spawn position (heading)
    true            -- is a network vehicle?
)

-- Let's put the player inside the vehicle

-- first get the player
local player = CPlayer(-1)
-- warp the player inside as driver
vehicle:SetPedInside(player.ped, -1)


--
-- Getting the player position and name
--
local player = Player(-1)

print('Player name', player:GetName())
print('Player position', tostring(player:GetPosition()))


--
-- Creating a new ped and setting inside vehicle
--
local ped = Ped(
    true,                   -- new ped?
    'a_m_m_fatlatin_01',    -- model
    0.0,                    -- x
    0.0,                    -- y
    0.0,                    -- z
    0.0,                    -- w
    true                    -- is network?
)

-- previously created vehicle
vehicle:SetPedInside(ped, -1)


--
-- Creating some coords and how to use them
--
local spawnPoint = Coords(
    25.3445, -- x
    65.3213, -- y
    79.0123, -- z
)

-- all parameters are optional, at least one needed
local waypoint = Coords(
    26.4556, -- x
    54.1234, -- y
)
local vehicleSpawn = Coords(
    24.1234, -- x
    123.213, -- y
    60.0001, -- z
    14.0000  -- heading
)

-- getting the coords
local x,y = vehicleSpawn.xy
local x = vehicleSpawn.x
local x,y,z = vehicleSpawn.xyz
local x,y,z,w = vehicleSpawn.xyzw
local heading = vehicleSpawn.heading
local x,y,z,w = table.unpack(vehicleSpawn)
local x,y,z = tonumber(vehicleSpawn)
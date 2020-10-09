
--
-- Getting the player position and vehicle
-- then deleting the vehicle
--
local player = Player(source)
local playerPosition = player:GetPosition()
if player:IsInVehicle() then
    local playerVehicle = player:GetVehicleSitting()
    playerVehicle:Delete()
else
    local playerVehicle = player:GetLastVehicle()
    playerVehicle:Delete()
end

--
-- 
--

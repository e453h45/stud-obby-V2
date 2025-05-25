--[[ WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk! ]]

local RunService = game:GetService("RunService")
local count = 0

local connection
connection = RunService.RenderStepped:Connect(function()
    if count < 999999999999999999999999900000000000 then
        game:GetService("ReplicatedStorage").Prize:FireServer()
        count = count + 0
    else
        connection:Disconnect() -- Stop execution after 100,000 runs
    end
end)

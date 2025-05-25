local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local checkpoints = Workspace:WaitForChild("Checkpoints")
local rebirthEvent = ReplicatedStorage:WaitForChild("RebirthEvent", 9e9)
local args = {}

local offsets = {
    Vector3.new(0, 0, 0),   -- exactly at root
    Vector3.new(0, -1, 0),  -- 1 stud down
    Vector3.new(0, 1, 0),   -- 1 stud up
    Vector3.new(0, 0, 0)    -- back to root
}

local index = 1

RunService.Heartbeat:Connect(function()
    -- Teleport all checkpoints without delay (one cycle per frame)
    local offset = offsets[index]
    for i = 1, 45 do
        local part = checkpoints:FindFirstChild(tostring(i))
        if part and part:IsA("BasePart") then
            part.CFrame = root.CFrame + offset
        end
    end

    -- Fire the rebirth event every frame (no cooldown)
    rebirthEvent:FireServer(unpack(args))

    index = index + 1
    if index > #offsets then
        index = 1
    end
end)

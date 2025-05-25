local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local DropFaster = Instance.new("TextButton")
local StopButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local AutoFarmButton = Instance.new("TextButton")
local StopAllButton = Instance.new("TextButton")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI remains after death
ScreenGui.Parent = game:GetService("CoreGui")

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 320, 0, 220)
Frame.Position = UDim2.new(0.5, -160, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 2
Frame.Active = true

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Domino Playground Scriptiee"
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold

CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold

DropFaster.Parent = Frame
DropFaster.Size = UDim2.new(1, 0, 0, 40)
DropFaster.Position = UDim2.new(0, 0, 0, 30)
DropFaster.Text = "Drop Faster"
DropFaster.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
DropFaster.TextColor3 = Color3.fromRGB(255, 255, 255)
DropFaster.Font = Enum.Font.SourceSansBold

StopButton.Parent = Frame
StopButton.Size = UDim2.new(1, 0, 0, 40)
StopButton.Position = UDim2.new(0, 0, 0, 70)
StopButton.Text = "Stop"
StopButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.SourceSansBold

AutoFarmButton.Parent = Frame
AutoFarmButton.Size = UDim2.new(1, 0, 0, 40)
AutoFarmButton.Position = UDim2.new(0, 0, 0, 110)
AutoFarmButton.Text = "Start AutoFarm"
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
AutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmButton.Font = Enum.Font.SourceSansBold

StopAllButton.Parent = Frame
StopAllButton.Size = UDim2.new(1, 0, 0, 40)
StopAllButton.Position = UDim2.new(0, 0, 0, 150)
StopAllButton.Text = "Stop All"
StopAllButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
StopAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopAllButton.Font = Enum.Font.SourceSansBold

local running = false
local farming = false
local loopTask
local angle = 0
local radius = 320
local speed = 7 -- Faster movement

function enableNoclip(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

function startAutoFarm()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")

    enableNoclip(character) -- Enable noclip

    if humanoidRootPart and humanoid then
        farming = true
        loopTask = RunService.Heartbeat:Connect(function()
            if farming then
                angle = angle + math.rad(speed)
                local x = math.cos(angle) * radius
                local z = math.sin(angle) * radius
                humanoidRootPart.Velocity = Vector3.new(x - humanoidRootPart.Position.X, 0, z - humanoidRootPart.Position.Z)
                humanoid:Move(Vector3.new(1, 0, 0), true)
            end
        end)
    end
end

AutoFarmButton.MouseButton1Click:Connect(function()
    startAutoFarm()
end)

StopAllButton.MouseButton1Click:Connect(function()
    farming = false
    running = false
    if loopTask then
        loopTask:Disconnect()
        loopTask = nil
    end
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Stops movement
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(1) -- Short delay to ensure respawn completion
    startAutoFarm() -- Restart AutoFarm after death
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drop Faster functionality - fires PlaceDomino event every 0.05s
local dropFasterLoop
DropFaster.MouseButton1Click:Connect(function()
    if dropFasterLoop then dropFasterLoop:Disconnect() end
    dropFasterLoop = RunService.RenderStepped:Connect(function()
        local args = {"Start"}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PlaceDomino"):FireServer(unpack(args))
    end)
end)

StopButton.MouseButton1Click:Connect(function()
    if dropFasterLoop then
        dropFasterLoop:Disconnect()
        dropFasterLoop = nil
    end
end)

-- Dragging functionality
local dragging
local dragInput
local dragStart
local startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

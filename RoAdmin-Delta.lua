-- RoAdmin Delta (Android / touch-friendly)
-- Use only in Roblox experiences you own or have permission to test.
-- Client-side movement changes may be reset or blocked by the game server.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local parent
if typeof(gethui) == "function" then
    local ok, result = pcall(gethui)
    if ok and result then
        parent = result
    end
end
parent = parent or CoreGui

local old = parent:FindFirstChild("RoAdminDelta")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "RoAdminDelta"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(255, 300)
panel.Position = UDim2.new(0, 18, 0.35, 0)
panel.BackgroundColor3 = Color3.fromRGB(23, 27, 39)
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(75, 125, 255)
outline.Thickness = 1.5
outline.Parent = panel

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(34, 42, 62)
header.BorderSizePixel = 0
header.Parent = panel
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "RoAdmin"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 34)
close.Position = UDim2.new(1, -41, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(180, 58, 70)
close.Text = "×"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 23
close.Parent = header
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 9)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 28)
status.Position = UDim2.fromOffset(12, 53)
status.BackgroundTransparency = 1
status.Text = "Ready • Android"
status.TextColor3 = Color3.fromRGB(175, 190, 220)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local function getHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid")
end

local function makeButton(label, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 42)
    button.Position = UDim2.fromOffset(12, y)
    button.BackgroundColor3 = Color3.fromRGB(48, 67, 105)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Text = label
    button.AutoButtonColor = true
    button.Parent = panel
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
    button.Activated:Connect(callback)
end

makeButton("⚡  Speed 32", 88, function()
    local ok, err = pcall(function()
        getHumanoid().WalkSpeed = 32
    end)
    status.Text = ok and "Speed set to 32" or "Could not change speed"
end)

makeButton("🦘  Jump 100", 138, function()
    local ok = pcall(function()
        local humanoid = getHumanoid()
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 100
    end)
    status.Text = ok and "Jump set to 100" or "Could not change jump"
end)

makeButton("↩  Reset movement", 188, function()
    local ok = pcall(function()
        local humanoid = getHumanoid()
        humanoid.WalkSpeed = 16
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 50
    end)
    status.Text = ok and "Movement reset" or "Could not reset movement"
end)

local reopen = Instance.new("TextButton")
reopen.Name = "Reopen"
reopen.Size = UDim2.fromOffset(125, 42)
reopen.Position = UDim2.new(0, 18, 0.35, 0)
reopen.BackgroundColor3 = Color3.fromRGB(45, 95, 205)
reopen.Text = "Open RoAdmin"
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 14
reopen.Visible = false
reopen.Parent = gui
Instance.new("UICorner", reopen).CornerRadius = UDim.new(0, 10)

close.Activated:Connect(function()
    panel.Visible = false
    reopen.Visible = true
end)

reopen.Activated:Connect(function()
    panel.Visible = true
    reopen.Visible = false
end)

-- Drag the panel using its title bar (touch or mouse).
local dragging = false
local dragInput
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

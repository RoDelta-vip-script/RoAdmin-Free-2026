-- RoAdmin mobile panel
-- StarterPlayer > StarterPlayerScripts içine LocalScript olarak koy.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "RoAdmin"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(240, 250)
panel.Position = UDim2.new(0, 16, 0.5, -125)
panel.BackgroundColor3 = Color3.fromRGB(25, 29, 40)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -44, 0, 42)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "RoAdmin"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -38, 0, 6)
close.Text = "×"
close.TextSize = 22
close.Parent = panel

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 24)
status.Position = UDim2.fromOffset(10, 42)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(170, 190, 220)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = panel

local function addButton(label, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 38)
    button.Position = UDim2.fromOffset(10, y)
    button.BackgroundColor3 = Color3.fromRGB(55, 75, 115)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Text = label
    button.Parent = panel
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    button.Activated:Connect(callback)
end

local function getHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid")
end

addButton("Speed 32", 74, function()
    getHumanoid().WalkSpeed = 32
    status.Text = "Speed set to 32"
end)

addButton("Speed 16 (default)", 118, function()
    getHumanoid().WalkSpeed = 16
    status.Text = "Speed reset"
end)

addButton("Jump 100", 162, function()
    local humanoid = getHumanoid()
    humanoid.UseJumpPower = true
    humanoid.JumpPower = 100
    status.Text = "Jump set to 100"
end)

addButton("Reset movement", 206, function()
    local humanoid = getHumanoid()
    humanoid.WalkSpeed = 16
    humanoid.UseJumpPower = true
    humanoid.JumpPower = 50
    status.Text = "Movement reset"
end)

close.Activated:Connect(function()
    gui.Enabled = false
end)

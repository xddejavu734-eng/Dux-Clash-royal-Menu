-- // Anti AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- // GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DuxMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainContainer = Instance.new("Frame", screenGui)
mainContainer.Size = UDim2.new(0, 300, 0, 320)
mainContainer.Position = UDim2.new(0.35, 0, 0.2, 0)
mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainContainer.Active = true
mainContainer.Draggable = true

local containerGradient = Instance.new("UIGradient", mainContainer)
containerGradient.Rotation = 90
containerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}

local corner = Instance.new("UICorner", mainContainer)
corner.CornerRadius = UDim.new(0, 12)

-- Header
local header = Instance.new("Frame", mainContainer)
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 Dux Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local subtitle = Instance.new("TextLabel", header)
subtitle.Size = UDim2.new(1, 0, 0, 16)
subtitle.Position = UDim2.new(0, 0, 0.6, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Base System + Utilities"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12

-- Content Area
local content = Instance.new("Frame", mainContainer)
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1

-- // Variables
local savedPosition = nil
local basePosition = nil
local noclipEnabled = false

-- Button Style
local buttonStyle = {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(50, 50, 70),
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.Gotham,
    TextSize = 16
}

-- Position Buttons
local saveBtn = Instance.new("TextButton", content)
saveBtn.Size = buttonStyle.Size
saveBtn.Position = UDim2.new(0, 0, 0, 0)
saveBtn.BackgroundColor3 = buttonStyle.BackgroundColor3
saveBtn.Text = "💾 Save Position"
saveBtn.TextColor3 = buttonStyle.TextColor3
saveBtn.Font = buttonStyle.Font
saveBtn.TextSize = buttonStyle.TextSize
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)

local tpBtn = Instance.new("TextButton", content)
tpBtn.Size = buttonStyle.Size
tpBtn.Position = UDim2.new(0, 0, 0, 50)
tpBtn.BackgroundColor3 = buttonStyle.BackgroundColor3
tpBtn.Text = "🔗 Teleport to Position"
tpBtn.TextColor3 = buttonStyle.TextColor3
tpBtn.Font = buttonStyle.Font
tpBtn.TextSize = buttonStyle.TextSize
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)

-- Base Buttons
local saveBaseBtn = Instance.new("TextButton", content)
saveBaseBtn.Size = buttonStyle.Size
saveBaseBtn.Position = UDim2.new(0, 0, 0, 120)
saveBaseBtn.BackgroundColor3 = Color3.fromRGB(40, 70, 100)
saveBaseBtn.Text = "🏠 Set Base Position"
saveBaseBtn.TextColor3 = buttonStyle.TextColor3
saveBaseBtn.Font = buttonStyle.Font
saveBaseBtn.TextSize = buttonStyle.TextSize
Instance.new("UICorner", saveBaseBtn).CornerRadius = UDim.new(0, 8)

local tpBaseBtn = Instance.new("TextButton", content)
tpBaseBtn.Size = buttonStyle.Size
tpBaseBtn.Position = UDim2.new(0, 0, 0, 170)
tpBaseBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 40)
tpBaseBtn.Text = "🔗 Teleport to Base"
tpBaseBtn.TextColor3 = buttonStyle.TextColor3
tpBaseBtn.Font = buttonStyle.Font
tpBaseBtn.TextSize = buttonStyle.TextSize
Instance.new("UICorner", tpBaseBtn).CornerRadius = UDim.new(0, 8)

-- Noclip Button
local noclipBtn = Instance.new("TextButton", content)
noclipBtn.Size = buttonStyle.Size
noclipBtn.Position = UDim2.new(0, 0, 0, 240)
noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 70)
noclipBtn.Text = "🚫 Noclip: OFF"
noclipBtn.TextColor3 = buttonStyle.TextColor3
noclipBtn.Font = buttonStyle.Font
noclipBtn.TextSize = buttonStyle.TextSize
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 8)

-- Status Indicators
local positionStatus = Instance.new("TextLabel", content)
positionStatus.Size = UDim2.new(1, 0, 0, 20)
positionStatus.Position = UDim2.new(0, 0, 0, 100)
positionStatus.BackgroundTransparency = 1
positionStatus.Text = "Position: Not Saved"
positionStatus.TextColor3 = Color3.fromRGB(200, 150, 150)
positionStatus.Font = Enum.Font.Gotham
positionStatus.TextSize = 12
positionStatus.TextXAlignment = Enum.TextXAlignment.Left

local baseStatus = Instance.new("TextLabel", content)
baseStatus.Size = UDim2.new(1, 0, 0, 20)
baseStatus.Position = UDim2.new(0, 0, 0, 220)
baseStatus.BackgroundTransparency = 1
baseStatus.Text = "Base: Not Set"
baseStatus.TextColor3 = Color3.fromRGB(200, 150, 150)
baseStatus.Font = Enum.Font.Gotham
baseStatus.TextSize = 12
baseStatus.TextXAlignment = Enum.TextXAlignment.Left

-- Button Functions
local function animateButton(button, success)
    local originalColor = button.BackgroundColor3
    local originalText = button.Text
    
    if success then
        button.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        button.Text = "✓ " .. string.sub(button.Text, 4)
    else
        button.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    end
    
    task.wait(1.5)
    
    button.BackgroundColor3 = originalColor
    button.Text = originalText
end

saveBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        positionStatus.Text = "Position: Saved"
        positionStatus.TextColor3 = Color3.fromRGB(150, 200, 150)
        animateButton(saveBtn, true)
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and savedPosition then
        char.HumanoidRootPart.CFrame = savedPosition
        animateButton(tpBtn, true)
    else
        animateButton(tpBtn, false)
    end
end)

saveBaseBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        basePosition = char.HumanoidRootPart.CFrame
        baseStatus.Text = "Base: Set"
        baseStatus.TextColor3 = Color3.fromRGB(150, 200, 150)
        animateButton(saveBaseBtn, true)
    end
end)

tpBaseBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and basePosition then
        char.HumanoidRootPart.CFrame = basePosition
        animateButton(tpBaseBtn, true)
    else
        animateButton(tpBaseBtn, false)
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipBtn.Text = "🚫 Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
    else
        noclipBtn.Text = "🚫 Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 70)
    end
end)

-- Noclip logic
RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Close Button
local closeBtn = Instance.new("TextButton", mainContainer)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
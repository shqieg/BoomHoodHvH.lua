-- Onyx Hub Cheat Script
-- Written by Colin

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OnyxHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Tabs
local Tabs = {"Main", "Visual", "Player", "Teleport", "Target", "Animations", "Settings"}
local TabButtons = {}
local TabFrames = {}

-- Tab Buttons Frame
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Name = "TabButtonsFrame"
TabButtonsFrame.Size = UDim2.new(0, 120, 0, 400)
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
TabButtonsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabButtonsFrame.BorderSizePixel = 0
TabButtonsFrame.Parent = MainFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0, 480, 0, 400)
ContentFrame.Position = UDim2.new(0, 120, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Create Tabs
for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "TabButton"
    TabButton.Size = UDim2.new(0, 120, 0, 40)
    TabButton.Position = UDim2.new(0, 0, 0, (i-1)*40)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.Parent = TabButtonsFrame
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Name = tabName .. "TabFrame"
    TabFrame.Size = UDim2.new(0, 480, 0, 400)
    TabFrame.Position = UDim2.new(0, 0, 0, 0)
    TabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabFrame.BorderSizePixel = 0
    TabFrame.Visible = false
    TabFrame.Parent = ContentFrame
    
    TabButtons[tabName] = TabButton
    TabFrames[tabName] = TabFrame
    
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        TabFrame.Visible = true
    end)
end

TabFrames["Main"].Visible = true

-- Open/Close Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "Open"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui

local MenuOpen = true
ToggleButton.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    MainFrame.Visible = MenuOpen
    ToggleButton.Text = MenuOpen and "Close" or "Open"
end)

-- ESP Setup
local ESP = {
    Enabled = false,
    Boxes = {},
    Tracers = {},
    Names = {},
    Distance = {}
}

function ESP:CreateESP(Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Head = Character:WaitForChild("Head")
    
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(0, 255, 0)
    Box.Thickness = 2
    Box.Filled = false
    self.Boxes[Player] = Box
    
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255, 0, 0)
    Tracer.Thickness = 1
    self.Tracers[Player] = Tracer
    
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 16
    Name.Center = true
    Name.Outline = true
    Name.Text = Player.Name
    self.Names[Player] = Name
    
    local Distance = Drawing.new("Text")
    Distance.Visible = false
    Distance.Color = Color3.fromRGB(200, 200, 200)
    Distance.Size = 14
    Distance.Center = true
    Distance.Outline = true
    self.Distance[Player] = Distance
end

function ESP:UpdateESP(Player)
    if not self.Enabled then 
        self:HideESP(Player)
        return 
    end
    
    local Character = Player.Character
    if not Character then return end
    
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Head = Character:FindFirstChild("Head")
    if not HumanoidRootPart or not Head then return end
    
    local Position, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
    
    if OnScreen then
        local Box = self.Boxes[Player]
        if Box then
            local Size = (workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0)).Y - workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position + Vector3.new(0, 2.5, 0)).Y) / 2
            Box.Size = Vector2.new(Size * 1.5, Size * 1.9)
            Box.Position = Vector2.new(Position.X - Size * 1.5 / 2, Position.Y - Size * 1.9 / 2)
            Box.Visible = true
        end
        
        local Tracer = self.Tracers[Player]
        if Tracer then
            Tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            Tracer.To = Vector2.new(Position.X, Position.Y)
            Tracer.Visible = true
        end
        
        local Name = self.Names[Player]
        local DistanceText = self.Distance[Player]
        if Name and DistanceText then
            Name.Position = Vector2.new(Position.X, Position.Y - 40)
            Name.Visible = true
            
            local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            DistanceText.Text = tostring(math.floor(Dist)) .. "m"
            DistanceText.Position = Vector2.new(Position.X, Position.Y - 20)
            DistanceText.Visible = true
        end
    else
        self:HideESP(Player)
    end
end

function ESP:HideESP(Player)
    if self.Boxes[Player] then self.Boxes[Player].Visible = false end
    if self.Tracers[Player] then self.Tracers[Player].Visible = false end
    if self.Names[Player] then self.Names[Player].Visible = false end
    if self.Distance[Player] then self.Distance[Player].Visible = false end
end

function ESP:ClearESP()
    for Player, Drawing in pairs(self.Boxes) do
        Drawing:Remove()
    end
    for Player, Drawing in pairs(self.Tracers) do
        Drawing:Remove()
    end
    for Player, Drawing in pairs(self.Names) do
        Drawing:Remove()
    end
    for Player, Drawing in pairs(self.Distance) do
        Drawing:Remove()
    end
    self.Boxes = {}
    self.Tracers = {}
    self.Names = {}
    self.Distance = {}
end

function ESP:ToggleESP(State)
    self.Enabled = State
    if not State then
        self:ClearESP()
    else
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                self:CreateESP(Player)
            end
        end
    end
end

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(0, 200, 0, 30)
ESPToggle.Position = UDim2.new(0, 20, 0, 20)
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ESPToggle.BorderSizePixel = 0
ESPToggle.Text = "ESP: Off"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 14
ESPToggle.Parent = TabFrames["Visual"]

ESPToggle.MouseButton1Click:Connect(function()
    ESP:ToggleESP(not ESP.Enabled)
    ESPToggle.Text = "ESP: " .. (ESP.Enabled and "On" or "Off")
end)

-- AimBot Setup
local AimBot = {
    Enabled = false,
    FOVCircle = Drawing.new("Circle"),
    TargetPart = "Head",
    FOVRadius = 80,
    FOVColor = Color3.fromRGB(255, 255, 255),
    Smoothing = 1
}

AimBot.FOVCircle.Visible = false
AimBot.FOVCircle.Radius = AimBot.FOVRadius
AimBot.FOVCircle.Color = AimBot.FOVColor
AimBot.FOVCircle.Thickness = 2
AimBot.FOVCircle.Filled = false
AimBot.FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

-- AimBot Functions
function AimBot:GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = math.huge
    
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character then
            local Character = Player.Character
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local TargetPart = Character:FindFirstChild(self.TargetPart)
            
            if HumanoidRootPart and TargetPart then
                local Position, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(TargetPart.Position)
                local MousePosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                local Center = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
                local Distance = (MousePosition - Center).Magnitude
                
                if OnScreen and Distance < self.FOVRadius and Distance < ShortestDistance then
                    ShortestDistance = Distance
                    ClosestPlayer = Player
                end
            end
        end
    end
    
    return ClosestPlayer
end

function AimBot:AimAtTarget()
    if not self.Enabled then return end
    
    local TargetPlayer = self:GetClosestPlayer()
    if not TargetPlayer or not TargetPlayer.Character then return end
    
    local TargetPart = TargetPlayer.Character:FindFirstChild(self.TargetPart)
    if not TargetPart then return end
    
    local TargetPosition = workspace.CurrentCamera:WorldToViewportPoint(TargetPart.Position)
    local CurrentPosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    local Delta = Vector2.new(TargetPosition.X, TargetPosition.Y) - CurrentPosition
    
    mousemoverel(Delta.X / self.Smoothing, Delta.Y / self.Smoothing)
end

-- AimBot Toggle
local AimBotToggle = Instance.new("TextButton")
AimBotToggle.Name = "AimBotToggle"
AimBotToggle.Size = UDim2.new(0, 200, 0, 30)
AimBotToggle.Position = UDim2.new(0, 20, 0, 60)
AimBotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimBotToggle.BorderSizePixel = 0
AimBotToggle.Text = "AimBot: Off"
AimBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimBotToggle.Font = Enum.Font.Gotham
AimBotToggle.TextSize = 14
AimBotToggle.Parent = TabFrames["Main"]

AimBotToggle.MouseButton1Click:Connect(function()
    AimBot.Enabled = not AimBot.Enabled
    AimBot.FOVCircle.Visible = AimBot.Enabled
    AimBotToggle.Text = "AimBot: " .. (AimBot.Enabled and "On" or "Off")
end)

-- FOV Radius Slider
local FOVSlider = Instance.new("TextLabel")
FOVSlider.Name = "FOVSlider"
FOVSlider.Size = UDim2.new(0, 200, 0, 20)
FOVSlider.Position = UDim2.new(0, 20, 0, 100)
FOVSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVSlider.BorderSizePixel = 0
FOVSlider.Text = "FOV Radius: " .. AimBot.FOVRadius
FOVSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVSlider.Font = Enum.Font.Gotham
FOVSlider.TextSize = 12
FOVSlider.Parent = TabFrames["Main"]

local FOVValue = Instance.new("TextButton")
FOVValue.Name = "FOVValue"
FOVValue.Size = UDim2.new(0, 180, 0, 20)
FOVValue.Position = UDim2.new(0, 10, 0, 120)
FOVValue.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FOVValue.BorderSizePixel = 0
FOVValue.Text = tostring(AimBot.FOVRadius)
FOVValue.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVValue.Font = Enum.Font.Gotham
FOVValue.TextSize = 12
FOVValue.Parent = TabFrames["Main"]

FOVValue.MouseButton1Click:Connect(function()
    AimBot.FOVRadius = AimBot.FOVRadius + 10
    if AimBot.FOVRadius > 200 then
        AimBot.FOVRadius = 50
    end
    AimBot.FOVCircle.Radius = AimBot.FOVRadius
    FOVSlider.Text = "FOV Radius: " .. AimBot.FOVRadius
    FOVValue.Text = tostring(AimBot.FOVRadius)
end)

-- Target Part Selection
local TargetPartButton = Instance.new("TextButton")
TargetPartButton.Name = "TargetPartButton"
TargetPartButton.Size = UDim2.new(0, 200, 0, 30)
TargetPartButton.Position = UDim2.new(0, 20, 0, 150)
TargetPartButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TargetPartButton.BorderSizePixel = 0
TargetPartButton.Text = "Target: Head"
TargetPartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetPartButton.Font = Enum.Font.Gotham
TargetPartButton.TextSize = 14
TargetPartButton.Parent = TabFrames["Main"]

TargetPartButton.MouseButton1Click:Connect(function()
    if AimBot.TargetPart == "Head" then
        AimBot.TargetPart = "HumanoidRootPart"
        TargetPartButton.Text = "Target: Body"
    else
        AimBot.TargetPart = "Head"
        TargetPartButton.Text = "Target: Head"
    end
end)

-- Anti-Aim (SpinBot)
local AntiAim = {
    Enabled = false,
    Speed = 5
}

local SpinBotToggle = Instance.new("TextButton")
SpinBotToggle.Name = "SpinBotToggle"
SpinBotToggle.Size = UDim2.new(0, 200, 0, 30)
SpinBotToggle.Position = UDim2.new(0, 20, 0, 20)
SpinBotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpinBotToggle.BorderSizePixel = 0
SpinBotToggle.Text = "SpinBot: Off"
SpinBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinBotToggle.Font = Enum.Font.Gotham
SpinBotToggle.TextSize = 14
SpinBotToggle.Parent = TabFrames["Player"]

SpinBotToggle.MouseButton1Click:Connect(function()
    AntiAim.Enabled = not AntiAim.Enabled
    SpinBotToggle.Text = "SpinBot: " .. (AntiAim.Enabled and "On" or "Off")
end)

-- Speed Hack
local SpeedHack = {
    Enabled = false,
    Speed = 16
}

local SpeedHackToggle = Instance.new("TextButton")
SpeedHackToggle.Name = "SpeedHackToggle"
SpeedHackToggle.Size = UDim2.new(0, 200, 0, 30)
SpeedHackToggle.Position = UDim2.new(0, 20, 0, 60)
SpeedHackToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedHackToggle.BorderSizePixel = 0
SpeedHackToggle.Text = "Speed Hack: Off"
SpeedHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHackToggle.Font = Enum.Font.Gotham
SpeedHackToggle.TextSize = 14
SpeedHackToggle.Parent = TabFrames["Player"]

SpeedHackToggle.MouseButton1Click:Connect(function()
    SpeedHack.Enabled = not SpeedHack.Enabled
    SpeedHackToggle.Text = "Speed Hack: " .. (SpeedHack.Enabled and "On" or "Off")
    
    if SpeedHack.Enabled and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = SpeedHack.Speed
        end
    else
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = 16
        end
    end
end)

-- Speed Value Selection
local SpeedValue = Instance.new("TextButton")
SpeedValue.Name = "SpeedValue"
SpeedValue.Size = UDim2.new(0, 180, 0, 20)
SpeedValue.Position = UDim2.new(0, 10, 0, 100)
SpeedValue.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SpeedValue.BorderSizePixel = 0
SpeedValue.Text = tostring(SpeedHack.Speed)
SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValue.Font = Enum.Font.Gotham
SpeedValue.TextSize = 12
SpeedValue.Parent = TabFrames["Player"]

SpeedValue.MouseButton1Click:Connect(function()
    SpeedHack.Speed = SpeedHack.Speed + 10
    if SpeedHack.Speed > 100 then
        SpeedHack.Speed = 16
    end
    SpeedValue.Text = tostring(SpeedHack.Speed)
    
    if SpeedHack.Enabled and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = SpeedHack.Speed
        end
    end
end)

-- Rage Aim (Instant hit when target in FOV)
local RageAim = {
    Enabled = false
}

local RageAimToggle = Instance.new("TextButton")
RageAimToggle.Name = "RageAimToggle"
RageAimToggle.Size = UDim2.new(0, 200, 0, 30)
RageAimToggle.Position = UDim2.new(0, 20, 0, 190)
RageAimToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RageAimToggle.BorderSizePixel = 0
RageAimToggle.Text = "Rage Aim: Off"
RageAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
RageAimToggle.Font = Enum.Font.Gotham
RageAimToggle.TextSize = 14
RageAimToggle.Parent = TabFrames["Main"]

RageAimToggle.MouseButton1Click:Connect(function()
    RageAim.Enabled = not RageAim.Enabled
    RageAimToggle.Text = "Rage Aim: " .. (RageAim.Enabled and "On" or "Off")
end)

-- Connections
Players.PlayerAdded:Connect(function(Player)
    if ESP.Enabled then
        ESP:CreateESP(Player)
    end
end)

Players.PlayerRemoving:Connect(function(Player)
    ESP:HideESP(Player)
end)

-- Main Loops
RunService.RenderStepped:Connect(function()
    -- ESP Update
    if ESP.Enabled then
        for Player, Box in pairs(ESP.Boxes) do
            if Player ~= LocalPlayer and Player.Character then
                ESP:UpdateESP(Player)
            else
                ESP:HideESP(Player)
            end
        end
    end
    
    -- AimBot
    if AimBot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        AimBot:AimAtTarget()
    end
    
    -- Anti-Aim
    if AntiAim.Enabled and LocalPlayer.Character then
        local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(AntiAim.Speed), 0)
        end
    end
    
    -- Rage Aim (Auto shoot when target in FOV)
    if RageAim.Enabled and AimBot.Enabled then
        local TargetPlayer = AimBot:GetClosestPlayer()
        if TargetPlayer then
            mouse1click()
        end
    end
end)

-- Initialize
for _, Player in ipairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer and ESP.Enabled then
        ESP:CreateESP(Player)
    end
end

print("Onyx Hub Loaded Successfully!")
print("Features: ESP, AimBot, Rage Aim, SpinBot, Speed Hack")
print("Press the Open/Close button to toggle menu")

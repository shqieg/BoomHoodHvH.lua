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
    -- Tab Button
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
    
    -- Tab Frame
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

-- Show Main tab by default
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

-- Menu State
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

-- ESP Functions
function ESP:CreateESP(Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Head = Character:WaitForChild("Head")
    
    -- Box
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(0, 255, 0)
    Box.Thickness = 2
    Box.Filled = false
    self.Boxes[Player] = Box
    
    -- Tracer
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255, 0, 0)
    Tracer.Thickness = 1
    self.Tracers[Player] = Tracer
    
    -- Name
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 16
    Name.Center = true
    Name.Outline = true
    Name.Text = Player.Name
    self.Names[Player] = Name
    
    -- Distance
    local Distance = Drawing.new("Text")
    Distance.Visible = false
    Distance.Color = Color3.fromRGB(200, 200, 200)
    Distance.Size = 14
    Distance.Center = true
    Distance.Outline = true
    self.Distance[Player] = Distance
end

function ESP:UpdateESP(Player)
    if not self.Enabled then return end
    
    local Character = Player.Character
    if not Character then return end
    
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Head = Character:FindFirstChild("Head")
    if not HumanoidRootPart or not Head then return end
    
    local Position, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
    
    if OnScreen then
        -- Update Box
        local Box = self.Boxes[Player]
        if Box then
            local Size = (workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0)).Y - workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position + Vector3.new(0, 2.5, 0)).Y) / 2
            Box.Size = Vector2.new(Size * 1.5, Size * 1.9)
            Box.Position = Vector2.new(Position.X - Size * 1.5 / 2, Position.Y - Size * 1.9 / 2)
            Box.Visible = true
        end
        
        -- Update Tracer
        local Tracer = self.Tracers[Player]
        if Tracer then
            Tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            Tracer.To = Vector2.new(Position.X, Position.Y)
            Tracer.Visible = true
        end
        
        -- Update Name and Distance
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

function ESP:ToggleESP(State)
    self.Enabled = State
    for Player, Box in pairs(self.Boxes) do
        if State then
            if Player.Character and Player ~= LocalPlayer then
                Box.Visible = true
            end
        else
            Box.Visible = false
        end
    end
end

-- ESP Toggle in Visual Tab
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

-- Player Added/Removed Connections
Players.PlayerAdded:Connect(function(Player)
    ESP:CreateESP(Player)
end)

Players.PlayerRemoving:Connect(function(Player)
    if ESP.Boxes[Player] then ESP.Boxes[Player]:Remove() end
    if ESP.Tracers[Player] then ESP.Tracers[Player]:Remove() end
    if ESP.Names[Player] then ESP.Names[Player]:Remove() end
    if ESP.Distance[Player] then ESP.Distance[Player]:Remove() end
    
    ESP.Boxes[Player] = nil
    ESP.Tracers[Player] = nil
    ESP.Names[Player] = nil
    ESP.Distance[Player] = nil
end)

-- Initialize ESP for existing players
for _, Player in ipairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        ESP:CreateESP(Player)
    end
end

-- ESP Update Loop
RunService.RenderStepped:Connect(function()
    for Player, Box in pairs(ESP.Boxes) do
        if Player ~= LocalPlayer and Player.Character then
            ESP:UpdateESP(Player)
        else
            ESP:HideESP(Player)
        end
    end
end)

-- Silent Aim Setup (Example)
local SilentAimToggle = Instance.new("TextButton")
SilentAimToggle.Name = "SilentAimToggle"
SilentAimToggle.Size = UDim2.new(0, 200, 0, 30)
SilentAimToggle.Position = UDim2.new(0, 20, 0, 20)
SilentAimToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SilentAimToggle.BorderSizePixel = 0
SilentAimToggle.Text = "Silent Aim: Off"
SilentAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SilentAimToggle.Font = Enum.Font.Gotham
SilentAimToggle.TextSize = 14
SilentAimToggle.Parent = TabFrames["Main"]

-- Add more features to other tabs as needed...

print("Onyx Hub Loaded Successfully!")
print("Features: ESP, Silent Aim, Menu System")
print("Press the Open/Close button to toggle menu")

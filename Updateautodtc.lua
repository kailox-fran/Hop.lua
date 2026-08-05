-- [[ STANDALONE ROBLOX SCRIPT EXECUTOR UI ]] --
-- This script programmatically creates a UI for entering and running Lua scripts.
-- To use: Paste this entire code into a LocalScript in StarterPlayerScripts or StarterGui.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExecutorUI"
screenGui.ResetOnSpawn = false -- Keeps UI visible after respawning
screenGui.Parent = playerGui

-- 2. Create the Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 300)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
mainFrame.Active = true
mainFrame.Draggable = true -- Deprecated but simple for this use case
mainFrame.Parent = screenGui

-- Add a Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.Text = "  Script Executor"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

-- 3. Create the TextBox for Script Input
local scriptBox = Instance.new("TextBox")
scriptBox.Name = "ScriptInput"
scriptBox.Size = UDim2.new(1, -20, 1, -85)
scriptBox.Position = UDim2.new(0, 10, 0, 40)
scriptBox.MultiLine = true
scriptBox.TextWrapped = true
scriptBox.ClearTextOnFocus = false
scriptBox.PlaceholderText = "-- Type your script here..."
scriptBox.Text = ""
scriptBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 14
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.Parent = mainFrame

-- 4. Create a Button Container
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "Buttons"
buttonContainer.Size = UDim2.new(1, -20, 0, 35)
buttonContainer.Position = UDim2.new(0, 10, 1, -45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 10)
layout.Parent = buttonContainer

-- Helper function to create styled buttons
local function createBtn(name, text, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.Parent = buttonContainer
    return btn
end

local executeBtn = createBtn("Execute", "EXECUTE", Color3.fromRGB(0, 150, 0))
local saveBtn    = createBtn("Save", "SAVE", Color3.fromRGB(0, 100, 200))
local deleteBtn  = createBtn("Delete", "DELETE", Color3.fromRGB(150, 0, 0))

-- 5. Script Functionality
local savedText = ""

-- Execute Logic
executeBtn.MouseButton1Click:Connect(function()
    local code = scriptBox.Text
    if code ~= "" then
        local func, err = loadstring(code)
        if func then
            local success, runErr = pcall(func)
            if not success then
                warn("Runtime Error: " .. tostring(runErr))
            end
        else
            warn("Syntax Error: " .. tostring(err))
        end
    end
end)

-- Save Logic
saveBtn.MouseButton1Click:Connect(function()
    savedText = scriptBox.Text
    print("Script saved to memory.")
end)

-- Delete Logic
deleteBtn.MouseButton1Click:Connect(function()
    scriptBox.Text = ""
    savedText = ""
    print("Script and memory cleared.")
end)

-- Optional: Make it draggable for modern Roblox
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("UI Loaded Successfully!")

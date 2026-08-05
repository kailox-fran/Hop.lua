-- [[ STANDALONE ROBLOX SCRIPT EXECUTOR UI (V3) ]] --
-- This script programmatically creates a UI for entering and running Lua scripts.
-- Features: Wider, shorter design, minimize/maximize toggle, and a built-in Teleport button.
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
mainFrame.Size = UDim2.new(0, 650, 0, 280) -- Slightly taller to accommodate new button row
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -140) -- Center the frame
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
mainFrame.Active = true
mainFrame.Draggable = true -- Deprecated but simple for this use case
mainFrame.Parent = screenGui

-- Add a Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -30, 0, 30) -- Make space for toggle button
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.Text = "  Script Executor"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

-- Add Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(1, -30, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "_"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local isMinimized = false
local originalSize = mainFrame.Size
local originalPosition = mainFrame.Position
local minimizedSize = UDim2.new(0, 150, 0, 30) -- Smaller size for minimized state

toggleButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        scriptBox.Visible = false
        buttonContainer.Visible = false
        teleportControlsFrame.Visible = false -- Hide teleport controls too
        mainFrame.Size = minimizedSize
        mainFrame.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset + (originalSize.X.Offset - minimizedSize.X.Offset), originalPosition.Y.Scale, originalPosition.Y.Offset)
        toggleButton.Text = "[]"
    else
        scriptBox.Visible = true
        buttonContainer.Visible = true
        teleportControlsFrame.Visible = true -- Show teleport controls
        mainFrame.Size = originalSize
        mainFrame.Position = originalPosition
        toggleButton.Text = "_"
    end
end)

-- 3. Create the TextBox for Script Input
local scriptBox = Instance.new("TextBox")
scriptBox.Name = "ScriptInput"
scriptBox.Size = UDim2.new(1, -20, 1, -125) -- Adjusted height for new button row
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

-- 4. Create a Button Container for Execute, Save, Delete
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "MainButtons"
buttonContainer.Size = UDim2.new(1, -20, 0, 35)
buttonContainer.Position = UDim2.new(0, 10, 1, -85) -- Position below the textbox
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 10)
layout.Parent = buttonContainer

-- Helper function to create styled buttons
local function createBtn(parentFrame, name, text, color, sizeXOffset)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, sizeXOffset or 120, 1, 0) -- Adjusted button width for wider frame
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
    
    btn.Parent = parentFrame
    return btn
end

local executeBtn = createBtn(buttonContainer, "Execute", "EXECUTE", Color3.fromRGB(0, 150, 0))
local saveBtn    = createBtn(buttonContainer, "Save", "SAVE", Color3.fromRGB(0, 100, 200))
local deleteBtn  = createBtn(buttonContainer, "Delete", "DELETE", Color3.fromRGB(150, 0, 0))

-- 5. Create Teleport Controls Frame
local teleportControlsFrame = Instance.new("Frame")
teleportControlsFrame.Name = "TeleportControls"
teleportControlsFrame.Size = UDim2.new(1, -20, 0, 35)
teleportControlsFrame.Position = UDim2.new(0, 10, 1, -45) -- Position below main buttons
teleportControlsFrame.BackgroundTransparency = 1
teleportControlsFrame.Parent = mainFrame

local teleportLayout = Instance.new("UIListLayout")
teleportLayout.FillDirection = Enum.FillDirection.Horizontal
teleportLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
teleportLayout.Padding = UDim.new(0, 10)
teleportLayout.Parent = teleportControlsFrame

local teleportDistanceBox = Instance.new("TextBox")
teleportDistanceBox.Name = "TeleportDistanceInput"
teleportDistanceBox.Size = UDim2.new(0, 80, 1, 0)
teleportDistanceBox.PlaceholderText = "Distance"
teleportDistanceBox.Text = "7" -- Default teleport distance
teleportDistanceBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teleportDistanceBox.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportDistanceBox.Font = Enum.Font.SourceSans
teleportDistanceBox.TextSize = 14
teleportDistanceBox.TextXAlignment = Enum.TextXAlignment.Center
teleportDistanceBox.Parent = teleportControlsFrame

local teleportBtn = createBtn(teleportControlsFrame, "Teleport", "TELEPORT", Color3.fromRGB(200, 100, 0), 120)

-- 6. Script Functionality
local savedText = ""

-- Execute Logic
executeBtn.MouseButton1Click:Connect(function()
    local code = scriptBox.Text
    if code ~= "" then
        local func, err = pcall(loadstring, code)
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

-- Teleport Logic
teleportBtn.MouseButton1Click:Connect(function()
    local playerChar = player.Character
    if not playerChar then
        playerChar = player.CharacterAdded:Wait()
    end
    local rootPart = playerChar:FindFirstChild("HumanoidRootPart")

    if rootPart then
        local distanceText = teleportDistanceBox.Text
        local teleportDistance = tonumber(distanceText)

        if teleportDistance and teleportDistance > 0 then
            rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -teleportDistance)
            print("Teleported " .. teleportDistance .. " studs forward.")
        else
            warn("Invalid teleport distance. Please enter a positive number.")
        end
    else
        warn("HumanoidRootPart not found. Cannot teleport.")
    end
end)

-- Draggable functionality (using InputChanged for better control)
local dragging
local dragStart
local startPosition

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.Ended then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end
end)

print("UI Loaded Successfully!")

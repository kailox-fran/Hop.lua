-- [[ STANDALONE ROBLOX SCRIPT EXECUTOR UI (V4) ]] --
-- This script programmatically creates a UI for entering and running Lua scripts.
-- Features: Wider, shorter design, robust minimize/maximize toggle, and a persistent Teleport button.
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

-- 2. Create the Main Frame (Overall Container)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 280) -- Wider and slightly taller
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -140) -- Center the frame
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
mainFrame.Active = true
mainFrame.Draggable = true -- Deprecated but simple for this use case
mainFrame.Parent = screenGui

-- 3. Create Header Frame (Title and Toggle Button)
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 30)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -30, 1, 0) -- Make space for toggle button
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.Text = "  Script Executor"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = headerFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 30, 1, 0)
toggleButton.Position = UDim2.new(1, -30, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "_"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.BorderSizePixel = 0
toggleButton.Parent = headerFrame

-- 4. Create Body Frame (Script Input and Main Buttons)
local bodyFrame = Instance.new("Frame")
bodyFrame.Name = "Body"
bodyFrame.Size = UDim2.new(1, 0, 1, -70) -- Space for header and footer
bodyFrame.Position = UDim2.new(0, 0, 0, 30)
bodyFrame.BackgroundTransparency = 1
bodyFrame.Parent = mainFrame

local scriptBox = Instance.new("TextBox")
scriptBox.Name = "ScriptInput"
scriptBox.Size = UDim2.new(1, -20, 1, -45) -- Space for main buttons
scriptBox.Position = UDim2.new(0, 10, 0, 0)
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
scriptBox.Parent = bodyFrame

local mainButtonContainer = Instance.new("Frame")
mainButtonContainer.Name = "MainButtons"
mainButtonContainer.Size = UDim2.new(1, -20, 0, 35)
mainButtonContainer.Position = UDim2.new(0, 10, 1, -35)
mainButtonContainer.BackgroundTransparency = 1
mainButtonContainer.Parent = bodyFrame

local mainButtonLayout = Instance.new("UIListLayout")
mainButtonLayout.FillDirection = Enum.FillDirection.Horizontal
mainButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
mainButtonLayout.Padding = UDim.new(0, 10)
mainButtonLayout.Parent = mainButtonContainer

-- 5. Create Footer Frame (Teleport Controls)
local footerFrame = Instance.new("Frame")
footerFrame.Name = "Footer"
footerFrame.Size = UDim2.new(1, 0, 0, 35)
footerFrame.Position = UDim2.new(0, 0, 1, -35)
footerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
footerFrame.BorderSizePixel = 0
footerFrame.Parent = mainFrame

local footerLayout = Instance.new("UIListLayout")
footerLayout.FillDirection = Enum.FillDirection.Horizontal
footerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
footerLayout.Padding = UDim.new(0, 10)
footerLayout.Parent = footerFrame

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
teleportDistanceBox.Parent = footerFrame

-- Helper function to create styled buttons
local function createBtn(parentFrame, name, text, color, sizeXOffset)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, sizeXOffset or 120, 1, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.Parent = parentFrame
    return btn
end

local executeBtn = createBtn(mainButtonContainer, "Execute", "EXECUTE", Color3.fromRGB(0, 150, 0))
local saveBtn    = createBtn(mainButtonContainer, "Save", "SAVE", Color3.fromRGB(0, 100, 200))
local deleteBtn  = createBtn(mainButtonContainer, "Delete", "DELETE", Color3.fromRGB(150, 0, 0))
local teleportBtn = createBtn(footerFrame, "Teleport", "TELEPORT", Color3.fromRGB(200, 100, 0), 120)

-- 6. Script Functionality
local savedText = ""

-- Store original mainFrame dimensions for toggling
local originalMainFrameSize = mainFrame.Size
local originalMainFramePosition = mainFrame.Position
local minimizedMainFrameSize = UDim2.new(originalMainFrameSize.X.Scale, originalMainFrameSize.X.Offset, 0, headerFrame.Size.Y.Offset + footerFrame.Size.Y.Offset) -- Header + Footer height

-- Toggle Logic
toggleButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        bodyFrame.Visible = false
        mainFrame.Size = minimizedMainFrameSize
        -- Adjust position to keep the top-left stable or center it based on preference
        -- For now, let's keep the top edge stable, so only Y offset changes if needed
        mainFrame.Position = UDim2.new(originalMainFramePosition.X.Scale, originalMainFramePosition.X.Offset, originalMainFramePosition.Y.Scale, originalMainFramePosition.Y.Offset)
        toggleButton.Text = "[]"
    else
        bodyFrame.Visible = true
        mainFrame.Size = originalMainFrameSize
        mainFrame.Position = originalMainFramePosition
        toggleButton.Text = "_"
    end
end)

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

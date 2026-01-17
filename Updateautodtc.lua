-- =========================
-- FULL SCRIPT WITH UI TOGGLE + RED HITBOXES + AUTO-UPGRADE
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local detectionRadius = 15
local delayBeforeTrigger = 5
local activatedSoundId = "rbxassetid://17503781665"

-- STATE
local activated = false
local delayRunning = false
local autoUpgradeEnabled = false
local oneTimeExecuted = false
local kgfruitRedeemed = false
local highlightedPlayers = {}
local detectionEnabled = false -- Controlled by UI toggle

-- =========================
-- UI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "StatusUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Status label
local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(0, 320, 0, 50)
label.Position = UDim2.new(0.5, -160, 0, 20)
label.BackgroundColor3 = Color3.fromRGB(30,30,30)
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true
label.Text = "Waiting for nearby player..."

-- Detection toggle button
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 160, 0, 50)
toggleButton.Position = UDim2.new(0.5, -80, 0, 80)
toggleButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Text = "Detection: Off"

toggleButton.MouseButton1Click:Connect(function()
    detectionEnabled = not detectionEnabled
    if detectionEnabled then
        toggleButton.Text = "Detection: On"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0,150,0)
    else
        toggleButton.Text = "Detection: Off"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
        -- Remove all highlights when disabling
        for player, _ in pairs(highlightedPlayers) do
            highlightedPlayers[player]:Destroy()
            highlightedPlayers[player] = nil
        end
    end
end)

-- =========================
-- HELPERS
-- =========================
local function fireRemote(...)
    pcall(function()
        ReplicatedStorage.RemoteEvent.ServerRemoteEvent:FireServer(...)
    end)
end

-- Return first player within detectionRadius, nil if none
local function getNearbyPlayer()
    if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
        return nil
    end

    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and player.Character
            and player.Character:FindFirstChild("HumanoidRootPart") then

            if (myPos - player.Character.HumanoidRootPart.Position).Magnitude <= detectionRadius then
                return player
            end
        end
    end

    return nil
end

-- Add or remove red hitbox highlight
local function setHighlight(player, enabled)
    if not player.Character then return end

    if enabled then
        if highlightedPlayers[player] then return end

        local highlight = Instance.new("Highlight")
        highlight.Name = "RadiusHighlight"
        highlight.FillColor = Color3.fromRGB(255,0,0)
        highlight.OutlineColor = Color3.fromRGB(255,80,80)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character

        highlightedPlayers[player] = highlight
    else
        if highlightedPlayers[player] then
            highlightedPlayers[player]:Destroy()
            highlightedPlayers[player] = nil
        end
    end
end

-- =========================
-- AUTO-UPGRADE LOOP
-- =========================
task.spawn(function()
    while task.wait(1) do
        if not autoUpgradeEnabled then continue end

        fireRemote("Change_ArrayBool_Item", "\230\137\139\231\137\140", 3)
        task.wait(0.3)

        for i = 1, 10 do
            fireRemote("Business", "\229\143\152\229\140\150_\229\174\160\231\137\169", 28)
            task.wait(0.3)
        end

        fireRemote("Change_ArrayBool_Item", "\230\137\139\231\137\140", 4)
        task.wait(0.3)

        for i = 1, 10 do
            fireRemote("Business", "\229\143\152\229\140\150_\229\174\160\231\137\169", 28)
            task.wait(0.3)
        end
    end
end)

-- =========================
-- PLAYER DETECTION + RED HITBOXES + COUNTDOWN


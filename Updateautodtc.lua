-- FULL FARM SCRIPT (Exact args + teleport loop)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local farming = false

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "FarmUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame)

local farmButton = Instance.new("TextButton")
farmButton.Size = UDim2.new(0,180,0,50)
farmButton.Position = UDim2.new(0.5,-90,0.5,-25)
farmButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
farmButton.TextColor3 = Color3.fromRGB(255,255,255)
farmButton.Text = "Start Farm"
farmButton.Parent = frame

Instance.new("UICorner", farmButton)

-- ===== Logic =====
farmButton.MouseButton1Click:Connect(function()
    farming = not farming

    if farming then
        farmButton.Text = "Stop Farm"

        spawn(function()
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")

          -- ===== DNA LOOP =====
for i = 1, 25 do
    if not farming then break end

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- teleport lock
    hrp.CFrame = CFrame.new(1747, 728, -1021)

    -- get DNA object safely
    local dnaFolder = workspace:WaitForChild("Dna", 5)
    if not dnaFolder then
        warn("Dna folder not found")
        break
    end

    local dnaObj = dnaFolder:FindFirstChild("Dna")
    if not dnaObj then
        warn("Dna object not found")
        break
    end

    local remote = game:GetService("ReplicatedStorage")
        :WaitForChild("Remotes", 5)
        :FindFirstChild("CollectDna")

    if remote then
        remote:FireServer(dnaObj)
    else
        warn("CollectDna remote missing")
        break
    end

    wait(0.2)
end

-- ===== PET LOOP =====
for i = 1, 3 do
    if not farming then break end

    local remote = game:GetService("ReplicatedStorage")
        :WaitForChild("Remotes", 5)
        :FindFirstChild("ClaimAlienPet")

    if remote then
        remote:FireServer()
    else
        warn("ClaimAlienPet remote missing")
        break
    end

    wait(0.5)
                    end

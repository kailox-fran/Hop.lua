-- FULL FARM SCRIPT (UI + Freeze + Actions)

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

            -- Teleport
            hrp.CFrame = CFrame.new(1747, 728, -1021)
            wait(0.5)

            -- FREEZE
            hrp.Anchored = true

            -- Collect DNA 25 times
            for i = 1, 25 do
                if not farming then break end

                local args = {
                    workspace:WaitForChild("Dna"):WaitForChild("Dna")
                }

                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remotes")
                    :WaitForChild("CollectDna")
                    :FireServer(unpack(args))

                wait(0.2)
            end

            -- Claim Alien Pet 3 times
            for i = 1, 3 do
                if not farming then break end

                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remotes")
                    :WaitForChild("ClaimAlienPet")
                    :FireServer()

                wait(0.5)
            end

            -- UNFREEZE
            hrp.Anchored = false

            farming = false
            farmButton.Text = "Start Farm"
        end)

    else
        farmButton.Text = "Start Farm"

        -- Safety unfreeze
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.Anchored = false
        end
    end
end)

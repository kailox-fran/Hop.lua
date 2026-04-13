local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

local button = Instance.new("TextButton")
button.Size = UDim2.new(0,180,0,50)
button.Position = UDim2.new(0.5,-90,0.5,-25)
button.BackgroundColor3 = Color3.fromRGB(60,60,60)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Text = "Start Farm"
button.Parent = frame

Instance.new("UICorner", button)

-- ===== MAIN LOOP =====
button.MouseButton1Click:Connect(function()
    farming = not farming

    if farming then
        button.Text = "Stop Farm"

        spawn(function()
            while farming do
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")

                -- TELEPORT LOOP (locks position)
                hrp.CFrame = CFrame.new(1747, 728, -1021)

                -- SAFE DNA CALL
                local dnaFolder = workspace:FindFirstChild("Dna")
                local dnaObj = dnaFolder and dnaFolder:FindFirstChild("Dna")

                local collectRemote = ReplicatedStorage:FindFirstChild("Remotes")
                collectRemote = collectRemote and collectRemote:FindFirstChild("CollectDna")

                if collectRemote and dnaObj then
                    pcall(function()
                        collectRemote:FireServer(dnaObj)
                    end)
                end

                wait(0.2)
            end
        end)

        spawn(function()
            while farming do
                local petRemote = ReplicatedStorage:FindFirstChild("Remotes")
                petRemote = petRemote and petRemote:FindFirstChild("ClaimAlienPet")

                if petRemote then
                    pcall(function()
                        petRemote:FireServer()
                    end)
                end

                wait(0.5)
            end
        end)

    else
        button.Text = "Start Farm"
    end
end)

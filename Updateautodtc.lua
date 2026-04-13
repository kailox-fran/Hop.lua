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

-- ===== MAIN =====
button.MouseButton1Click:Connect(function()
	farming = not farming

	if farming then
		button.Text = "Stop Farm"

		spawn(function()
			local character = player.Character or player.CharacterAdded:Wait()
			local hrp = character:WaitForChild("HumanoidRootPart")

			-- ===== DNA LOOP (25x your exact code) =====
			for i = 1, 25 do
				if not farming then break end

				-- teleport lock
				hrp.CFrame = CFrame.new(1747, 728, -1021)

				-- YOUR EXACT CODE
				local args = {
					workspace:WaitForChild("Dna"):WaitForChild("Dna")
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("CollectDna")
					:FireServer(unpack(args))

				wait(0.2)
			end

			-- ===== PET LOOP (3x) =====
			for i = 1, 3 do
				if not farming then break end

				hrp.CFrame = CFrame.new(1747, 728, -1021)

				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("ClaimAlienPet")
					:FireServer()

				wait(0.5)
			end

			farming = false
			button.Text = "Start Farm"
		end)

	else
		button.Text = "Start Farm"
	end
end)

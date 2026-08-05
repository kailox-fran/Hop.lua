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
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NotesGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(450, 300)
frame.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(225, 150)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Notes"
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

local box = Instance.new("TextBox")
box.Position = UDim2.fromOffset(10, 40)
box.Size = UDim2.new(1, -20, 1, -90)
box.MultiLine = true
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextWrapped = false
box.Text = ""
box.Parent = frame

local savedText = ""

local function makeButton(text, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(90, 30)
	b.Position = UDim2.new(0, x, 1, -35)
	b.Text = text
	b.Parent = frame
	return b
end

local save = makeButton("Save", 10)
local load = makeButton("Load", 110)
local clear = makeButton("Clear", 210)

save.MouseButton1Click:Connect(function()
	savedText = box.Text
end)

load.MouseButton1Click:Connect(function()
	box.Text = savedText
end)

clear.MouseButton1Click:Connect(function()
	box.Text = ""
end)

-- Draggable
local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

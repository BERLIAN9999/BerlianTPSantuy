-- 👑 KING BERLIAN 👑 Teleport + Checkpoint Selector (Fixed UI + Respawn)
-- Versi perbaikan total by Cekiq & GPT-5

local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Hapus GUI lama kalau ada
if PlayerGui:FindFirstChild("KING_GUI") then
	PlayerGui:FindFirstChild("KING_GUI"):Destroy()
end

-- === GUI UTAMA ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KING_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 280, 0, 260)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Text = "👑 KING BERLIAN 👑"
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(0, 255, 255)

local Toggle = Instance.new("TextButton")
Toggle.Parent = Frame
Toggle.Size = UDim2.new(0.8, 0, 0.18, 0)
Toggle.Position = UDim2.new(0.1, 0, 0.25, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 18
Toggle.Text = "MUNCAK SANTUY [OFF]"
Toggle.AutoButtonColor = false
Toggle.BorderSizePixel = 0

local Dropdown = Instance.new("TextButton")
Dropdown.Parent = Frame
Dropdown.Size = UDim2.new(0.8, 0, 0.18, 0)
Dropdown.Position = UDim2.new(0.1, 0, 0.48, 0)
Dropdown.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
Dropdown.TextColor3 = Color3.fromRGB(0, 0, 0)
Dropdown.Font = Enum.Font.GothamBold
Dropdown.TextSize = 18
Dropdown.Text = "Pilih Checkpoint"
Dropdown.BorderSizePixel = 0

local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Parent = Frame
ListFrame.Size = UDim2.new(0.8, 0, 0.32, 0)
ListFrame.Position = UDim2.new(0.1, 0, 0.7, 0)
ListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ListFrame.Visible = false
ListFrame.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ListFrame
UIListLayout.Padding = UDim.new(0, 3)

-- === DATA CHECKPOINT ===
local checkpoints = {
	Vector3.new(-484, 959, -44),
	Vector3.new(-259, 821, 52),
	Vector3.new(-101, 830, -51),
	Vector3.new(63, 877, -84),
	Vector3.new(143, 821, 69),
	Vector3.new(102, 809, 281),
	Vector3.new(-138, 841, 308),
	Vector3.new(-252, 841, 311),
	Vector3.new(-238, 785, 427),
	Vector3.new(-252, 786, 571),
	Vector3.new(-147, 782, 564),
	Vector3.new(149, 761, 567),
	Vector3.new(133, 741, 329),
	Vector3.new(417, 561, 266),
	Vector3.new(209, 510, 496)
}

-- === SISTEM TELEPORT ===
local running = false
local delayTime = 2

local function blueFlashEffect()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local flash = Instance.new("Part", workspace)
	flash.Anchored = true
	flash.CanCollide = false
	flash.Shape = Enum.PartType.Ball
	flash.Material = Enum.Material.Neon
	flash.Color = Color3.fromRGB(0, 170, 255)
	flash.Size = Vector3.new(10, 10, 10)
	flash.CFrame = char.HumanoidRootPart.CFrame
	game:GetService("Debris"):AddItem(flash, 0.3)
end

local function teleportTo(point)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(point)
		blueFlashEffect()
	end
end

local function startTeleport()
	for i, point in ipairs(checkpoints) do
		if not running then break end
		teleportTo(point)
		task.wait(delayTime)
		if i == #checkpoints then
			player:LoadCharacter()
		end
	end
end

player.CharacterAdded:Connect(function()
	if running then
		task.wait(2)
		task.spawn(startTeleport)
	end
end)

-- === EVENT TOMBOL ===
Toggle.MouseButton1Click:Connect(function()
	running = not running
	Toggle.Text = running and "MUNCAK SANTUY [ON]" or "MUNCAK SANTUY [OFF]"
	Toggle.BackgroundColor3 = running and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 85, 255)
	if running then
		task.spawn(startTeleport)
	end
end)

Dropdown.MouseButton1Click:Connect(function()
	ListFrame.Visible = not ListFrame.Visible
end)

-- === BUAT TOMBOL CHECKPOINT ===
for i = 1, #checkpoints do
	local btn = Instance.new("TextButton")
	btn.Parent = ListFrame
	btn.Size = UDim2.new(1, 0, 0, 25)
	btn.Text = "🏁 Checkpoint " .. i
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.BorderSizePixel = 0

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(90, 90, 120)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
	end)

	btn.MouseButton1Click:Connect(function()
		teleportTo(checkpoints[i])
		ListFrame.Visible = false
	end)
end

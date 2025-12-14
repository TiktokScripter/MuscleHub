-- Wait for game
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

-- Character handler
local function getChar()
	return Player.Character or Player.CharacterAdded:Wait()
end

-- Remotes (Muscle Legends)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StrengthEvent = Remotes:WaitForChild("Strength")
local AgilityEvent = Remotes:WaitForChild("Agility")
local DurabilityEvent = Remotes:WaitForChild("Durability")

--------------------------------------------------
-- ORION UI
--------------------------------------------------
local OrionLib = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/shlexware/Orion/main/source"
))()

local Window = OrionLib:MakeWindow({
	Name = "Muscle Legends | Auto Farm",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "ML_Delta"
})

--------------------------------------------------
-- VARIABLES
--------------------------------------------------
local AutoStrength = false
local AutoAgility = false
local AutoDurability = false
local SpeedBoost = false

--------------------------------------------------
-- AUTO TRAIN TAB
--------------------------------------------------
local TrainTab = Window:MakeTab({
	Name = "Auto Train",
	Icon = "rbxassetid://4483345998"
})

TrainTab:AddToggle({
	Name = "Auto Strength",
	Default = false,
	Callback = function(v)
		AutoStrength = v
	end
})

TrainTab:AddToggle({
	Name = "Auto Agility",
	Default = false,
	Callback = function(v)
		AutoAgility = v
	end
})

TrainTab:AddToggle({
	Name = "Auto Durability",
	Default = false,
	Callback = function(v)
		AutoDurability = v
	end
})

--------------------------------------------------
-- TRAIN LOOPS (REAL STAT GAIN)
--------------------------------------------------
task.spawn(function()
	while task.wait(0.15) do
		if AutoStrength then
			pcall(function()
				StrengthEvent:FireServer()
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(0.2) do
		if AutoAgility then
			pcall(function()
				AgilityEvent:FireServer()
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(0.25) do
		if AutoDurability then
			pcall(function()
				DurabilityEvent:FireServer()
			end)
		end
	end
end)

--------------------------------------------------
-- TELEPORT TAB
--------------------------------------------------
local TeleportTab = Window:MakeTab({
	Name = "World Teleports",
	Icon = "rbxassetid://4483345998"
})

local function TP(world)
	local char = getChar()
	local hrp = char:WaitForChild("HumanoidRootPart")

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Part") and v.Name == "Teleport" and v.Parent.Name == world then
			hrp.CFrame = v.CFrame + Vector3.new(0,5,0)
			break
		end
	end
end

TeleportTab:AddButton({
	Name = "Spawn",
	Callback = function()
		TP("Spawn")
	end
})

TeleportTab:AddButton({
	Name = "Desert",
	Callback = function()
		TP("Desert")
	end
})

TeleportTab:AddButton({
	Name = "Winter",
	Callback = function()
		TP("Winter")
	end
})

TeleportTab:AddButton({
	Name = "Legends",
	Callback = function()
		TP("Legends")
	end
})

--------------------------------------------------
-- VISUAL / BOOST TAB
--------------------------------------------------
local BoostTab = Window:MakeTab({
	Name = "Boosts (Client)",
	Icon = "rbxassetid://4483345998"
})

BoostTab:AddToggle({
	Name = "Speed Boost",
	Default = false,
	Callback = function(v)
		SpeedBoost = v
		local hum = getChar():WaitForChild("Humanoid")
		hum.WalkSpeed = v and 60 or 16
	end
})

--------------------------------------------------
-- FINALIZE
--------------------------------------------------
OrionLib:Init()

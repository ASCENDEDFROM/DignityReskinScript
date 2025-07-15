local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local darkRedColor = ColorSequence.new(Color3.fromRGB(139, 0, 0))

local updatedVoidstars = {}
local updatedTerrainExplosions = {}
local hookedEmitters = {}

local crushEmitters = { "Burst", "Ripple", "Shards", "Shockwave", "Star" }
local explosionEmitters = { "Burst", "Burst2", "Ground", "Ground2", "Smoke", "Sparkle", "Sub" }

local lastVoidstarScan = 0
local lastTerrainScan = 0
local SCAN_INTERVAL = 0.6  -- seconds

-- Helper to enforce and track color
local function enforceColorProperty(instance)
	if instance.Color ~= darkRedColor then
		instance.Color = darkRedColor
		warn("✅ Set color on:", instance:GetFullName())
	end

	if not hookedEmitters[instance] then
		hookedEmitters[instance] = true
		instance:GetPropertyChangedSignal("Color"):Connect(function()
			if instance.Color ~= darkRedColor then
				instance.Color = darkRedColor
				warn("🔄 Color changed externally, reset to dark red on:", instance:GetFullName())
			end
		end)
	end
end

local function processNamedEmitters(attachment, emitterNames)
	for _, name in ipairs(emitterNames) do
		for _, child in ipairs(attachment:GetChildren()) do
			if child:IsA("ParticleEmitter") and child.Name == name then
				enforceColorProperty(child)
			end
		end
	end
end

-- 🔁 Runs only every SCAN_INTERVAL seconds
local function scanVoidstars()
	local map = workspace:FindFirstChild("Map")
	local ingame = map and map:FindFirstChild("Ingame")
	if not ingame then return end

	for _, voidstar in ipairs(ingame:GetDescendants()) do
		if voidstar:IsA("MeshPart") and voidstar.Name == "Voidstar" and not updatedVoidstars[voidstar] then
			updatedVoidstars[voidstar] = true
			warn("🔍 Found new Voidstar:", voidstar:GetFullName())

			-- Hide all descendants
			local function setTransparencyRecursive(instance, transparency)
				if instance:IsA("BasePart") then
					instance.Transparency = transparency
				end
				for _, child in ipairs(instance:GetChildren()) do
					setTransparencyRecursive(child, transparency)
				end
			end
			setTransparencyRecursive(voidstar, 1)

			local success, model = pcall(function()
				return game:GetObjects("rbxassetid://92686541599826")[1]
			end)

			if success and model then
				model.Name = "VoidstarOverlay"
				model.Parent = voidstar

				local root = model:FindFirstChildWhichIsA("BasePart")
				if root then
					root.CFrame = voidstar.CFrame

					local motor = Instance.new("Motor6D")
					motor.Name = "VoidstarMotor"
					motor.Part0 = voidstar
					motor.Part1 = root
					motor.C0 = CFrame.new()
					motor.C1 = voidstar.CFrame:toObjectSpace(root.CFrame)
					motor.Parent = voidstar
					warn("⚙️ Attached custom asset to Voidstar")
				else
					warn("❌ Could not find root part in model")
				end
			else
				warn("❌ Failed to load asset from ID")
			end

			local trail = voidstar:FindFirstChild("Trail")
			if trail and trail:IsA("Trail") then
				enforceColorProperty(trail)
			end

			for _, obj in ipairs(voidstar:GetDescendants()) do
				if obj:IsA("Attachment") then
					if obj.Name == "Crush" then
						processNamedEmitters(obj, crushEmitters)
					elseif obj.Name == "Explosion" then
						processNamedEmitters(obj, explosionEmitters)
					end
				end
			end
		end
	end
end

local function scanTerrainExplosions()
	local terrain = workspace:FindFirstChild("Terrain")
	if not terrain then return end

	for _, attachment in ipairs(terrain:GetDescendants()) do
		if attachment:IsA("Attachment") and attachment.Name == "Explosion" and not updatedTerrainExplosions[attachment] then
			updatedTerrainExplosions[attachment] = true
			warn("🔍 Found Terrain Explosion Attachment:", attachment:GetFullName())
			processNamedEmitters(attachment, explosionEmitters)
		end
	end
end

-- 🔁 Main update loop
RunService.Heartbeat:Connect(function(dt)
	local char = player.Character
	if not (char and char.Name == "Noli") then return end

	-- Periodic scanning
	local now = tick()
	if now - lastVoidstarScan >= SCAN_INTERVAL then
		scanVoidstars()
		lastVoidstarScan = now
	end

	if now - lastTerrainScan >= SCAN_INTERVAL then
		scanTerrainExplosions()
		lastTerrainScan = now
	end

	-- Continuous enforcement (lightweight)
	for emitter in pairs(hookedEmitters) do
		if emitter and emitter.Parent and emitter.Color ~= darkRedColor then
			emitter.Color = darkRedColor
			-- Removed `warn()` here to reduce console spam
		end
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mainGui = playerGui:WaitForChild("MainUI")


local map = workspace:WaitForChild("Map"):WaitForChild("Ingame"):WaitForChild("Map")
local ingame = workspace:WaitForChild("Map"):WaitForChild("Ingame")



local darkRedColor = Color3.fromRGB(210, 0, 0)
local darkRedColorSequence = ColorSequence.new(Color3.fromRGB(210, 0, 0))

local targetHighlightName = player.Name .. "NoliAura"
local targetImageId = "rbxassetid://111269114176427"
local targetImageTrans = 0.6

local lastUpdate = 0
local updateInterval = 0.05 -- every 100ms

local function setEmitterColorIfNeeded(emitter)
	if emitter and emitter:IsA("ParticleEmitter") and emitter.Color ~= darkRedColorSequence then
		emitter.Color = darkRedColorSequence
		warn("🌑 Set ParticleEmitter color:", emitter:GetFullName())
	end
end

RunService.Heartbeat:Connect(function()
	if tick() - lastUpdate < updateInterval then return end
	lastUpdate = tick()

	local character = player.Character
	if not character or character.Name ~= "Noli" then return end

	-- 🔴 Update Highlights in Generator / FakeGenerator
	for _, model in ipairs(map:GetDescendants()) do
		if model:IsA("Model") and (model.Name == "Generator" or model.Name == "FakeGenerator") then
			for _, item in ipairs(model:GetChildren()) do
				if item:IsA("Highlight") and item.Name == targetHighlightName then
					if item.FillColor ~= darkRedColor then
						item.FillColor = darkRedColor
						warn("✅ Changed FillColor for:", item:GetFullName())
					end
				end
			end
		end
	end

	-- 🖼️ Update ImageButtons inside GeneratorTeleportButtons
	for _, gui in ipairs(playerGui:GetDescendants()) do
		if gui:IsA("BillboardGui") and gui.Name == "GeneratorTeleportButton" then
			local imageButton = gui:FindFirstChild("ImageButton")
			if imageButton and imageButton:IsA("ImageButton") then
				if imageButton.Image ~= targetImageId then
					imageButton.Image = targetImageId
					warn("🖼️ Updated Image on:", imageButton:GetFullName())
				end
				if imageButton.ImageTransparency ~= targetImageTrans then
					imageButton.ImageTransparency = targetImageTrans
					warn("🖼️ Updated Image Transparency on:", imageButton:GetFullName())
				end
			end
		end
	end

	-- 🌑 Handle In and Out effects
	local inPart = ingame:FindFirstChild("In")
	if inPart and inPart:IsA("BasePart") then
		-- Direct ParticleEmitter named "1"
		setEmitterColorIfNeeded(inPart:FindFirstChild("1"))

		local sigilAttachment = inPart:FindFirstChild("Sigil")
		if sigilAttachment and sigilAttachment:IsA("Attachment") then
			setEmitterColorIfNeeded(sigilAttachment:FindFirstChild("2"))
			setEmitterColorIfNeeded(sigilAttachment:FindFirstChild("3"))
		end
	end

	local outPart = ingame:FindFirstChild("Out")
	if outPart and outPart:IsA("BasePart") then
		-- Direct ParticleEmitters named "1" and "3"
		setEmitterColorIfNeeded(outPart:FindFirstChild("1"))
		setEmitterColorIfNeeded(outPart:FindFirstChild("3"))

		local groundAttachment = outPart:FindFirstChild("Ground")
		if groundAttachment and groundAttachment:IsA("Attachment") then
			setEmitterColorIfNeeded(groundAttachment:FindFirstChild("1"))
			setEmitterColorIfNeeded(groundAttachment:FindFirstChild("2"))
			setEmitterColorIfNeeded(groundAttachment:FindFirstChild("4"))
			setEmitterColorIfNeeded(groundAttachment:FindFirstChild("5"))
		end

		local lightningAttachment = outPart:FindFirstChild("Lightning")
		if lightningAttachment and lightningAttachment:IsA("Attachment") then
			setEmitterColorIfNeeded(lightningAttachment:FindFirstChild("1"))
		end
	end
end)

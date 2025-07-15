local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mainGui = playerGui:WaitForChild("MainUI")

local darkRedColor = Color3.fromRGB(147, 0, 0)
local darkRedColorSequence = ColorSequence.new(Color3.fromRGB(139, 0, 0))

local targetHighlightName = player.Name .. "NoliAura"
local targetImageId = "rbxassetid://118987110014621"
local targetImageTrans = 0.3

local updateInterval = 0.05
local lastUpdate = 0

-- 🌟 Ensure credits label exists once
local function ensureCreditsLabel()
	local existing = mainGui:FindFirstChild("CreditsLabel")
	if existing then return end

	local credits = Instance.new("TextLabel")
	credits.Name = "CreditsLabel"
	credits.BackgroundTransparency = 1
	credits.Position = UDim2.new(0.35, -10, 0.8, -10)
	credits.Size = UDim2.new(0.3, 0, 0, 40)
	credits.TextColor3 = Color3.fromRGB(165, 59, 47)
	credits.TextStrokeTransparency = 1
	credits.TextScaled = true
	credits.Text = "Made By Ascend. On Tiktok"
	credits.Parent = mainGui
end

ensureCreditsLabel()

-- Cache references
local map = workspace:WaitForChild("Map"):WaitForChild("Ingame"):WaitForChild("Map")
local ingame = workspace:WaitForChild("Map"):WaitForChild("Ingame")

-- ⚙️ Apply dark red if needed
local function setEmitterColorIfNeeded(emitter)
	if emitter and emitter:IsA("ParticleEmitter") and emitter.Color ~= darkRedColorSequence then
		emitter.Color = darkRedColorSequence
	end
end

-- 🔁 Main loop
RunService.Heartbeat:Connect(function()
	if tick() - lastUpdate < updateInterval then return end
	lastUpdate = tick()

	local character = player.Character
	if not character or character.Name ~= "Noli" then return end

	-- 🔴 Update generator highlights
	for _, model in ipairs(map:GetDescendants()) do
		if model:IsA("Model") and (model.Name == "Generator" or model.Name == "FakeGenerator") then
			for _, item in ipairs(model:GetChildren()) do
				if item:IsA("Highlight") and item.Name == targetHighlightName and item.FillColor ~= darkRedColor then
					item.FillColor = darkRedColor
				end
			end
		end
	end

	-- 🖼️ Update Teleport Button UI
	for _, gui in ipairs(playerGui:GetDescendants()) do
		if gui:IsA("BillboardGui") and gui.Name == "GeneratorTeleportButton" then
			local imageButton = gui:FindFirstChildOfClass("ImageButton")
			if imageButton then
				if imageButton.Image ~= targetImageId then
					imageButton.Image = targetImageId
				end
				if imageButton.ImageTransparency ~= targetImageTrans then
					imageButton.ImageTransparency = targetImageTrans
				end
			end
		end
	end

	-- 💥 Update "In" effects
	local inPart = ingame:FindFirstChild("In")
	if inPart and inPart:IsA("BasePart") then
		setEmitterColorIfNeeded(inPart:FindFirstChild("1"))
		local sigil = inPart:FindFirstChild("Sigil")
		if sigil and sigil:IsA("Attachment") then
			for _, id in ipairs({ "2", "3" }) do
				setEmitterColorIfNeeded(sigil:FindFirstChild(id))
			end
		end
	end

	-- ⚡ Update "Out" effects
	local outPart = ingame:FindFirstChild("Out")
	if outPart and outPart:IsA("BasePart") then
		for _, id in ipairs({ "1", "3" }) do
			setEmitterColorIfNeeded(outPart:FindFirstChild(id))
		end

		local ground = outPart:FindFirstChild("Ground")
		if ground and ground:IsA("Attachment") then
			for _, id in ipairs({ "1", "2", "4", "5" }) do
				setEmitterColorIfNeeded(ground:FindFirstChild(id))
			end
		end

		local lightning = outPart:FindFirstChild("Lightning")
		if lightning and lightning:IsA("Attachment") then
			setEmitterColorIfNeeded(lightning:FindFirstChild("1"))
		end
	end
end)

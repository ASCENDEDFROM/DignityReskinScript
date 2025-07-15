local player = game.Players.LocalPlayer
local survivorFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
local RunService = game:GetService("RunService")


-- Debug UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DebugGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local debugLabel = Instance.new("TextLabel")
debugLabel.Name = "DebugLabel"
debugLabel.Position = UDim2.new(0.25, 0, 0.05, 0)
debugLabel.Size = UDim2.new(0.5, 0, 0, 22)
debugLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
debugLabel.BackgroundTransparency = 0.3
debugLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
debugLabel.TextSize = 20
debugLabel.TextWrapped = true
debugLabel.TextXAlignment = Enum.TextXAlignment.Left
debugLabel.TextYAlignment = Enum.TextYAlignment.Top
debugLabel.Font = Enum.Font.SourceSans
debugLabel.ClipsDescendants = true
debugLabel.Text = ""
debugLabel.Parent = screenGui

local fadeStarted = false
local fadeReset = false
local lineHeight = 22


local function attachMeshAccessory(params)
	local character = params.character
	local targetPart = params.targetPart
	local name = params.name or "MeshAccessory"
	local meshId = params.meshId
	local textureId = params.textureId
	local position = params.position or Vector3.new(0, 0, 0)
	local rotation = params.rotation or Vector3.new(0, 0, 0)
	local scale = params.scale or Vector3.new(1, 1, 1)
	local offset = params.offset or Vector3.new(0, 0, 0)
	local color = params.color
	local material = params.material

	if not character or not targetPart or not meshId then
		warn("Missing required accessory params")
		return
	end

	local part = Instance.new("Part")
	part.Name = name
	part.Size = Vector3.new(1, 1, 1)
	part.Anchored = false
	part.CanCollide = false
	part.Transparency = 0
	if color then part.Color = color end
	if material then part.Material = material end
	part.Parent = character

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshId = "rbxassetid://" .. meshId
	if textureId then mesh.TextureId = "rbxassetid://" .. textureId end
	mesh.Offset = offset
	mesh.Scale = scale
	mesh.Parent = part

	local weld = Instance.new("Weld")
	weld.Part0 = targetPart
	weld.Part1 = part
	weld.C0 = CFrame.new(position) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
	weld.Parent = part

	return part
end



local function appendDebugText(text)
	local currentText = debugLabel.Text
	local newText = currentText .. (currentText == "" and "" or "\n") .. text
	debugLabel.Text = newText

	local lineCount = select(2, newText:gsub("\n", "\n")) + 1
	debugLabel.Size = UDim2.new(0.5, 0, 0, math.max(lineHeight, lineCount * lineHeight))

	fadeReset = true
	if not fadeStarted then
		fadeStarted = true
		coroutine.wrap(function()
			while true do
				local elapsed = 0
				while elapsed < 10 do
					if fadeReset then
						fadeReset = false
						elapsed = 0
					end
					task.wait(0.1)
					elapsed += 0.1
				end
				for i = 0, 1, 0.05 do
					debugLabel.TextTransparency = i
					debugLabel.BackgroundTransparency = 0.3 + i * 0.7
					task.wait(0.05)
				end
				debugLabel:Destroy()
				break
			end
		end)()
	end
end

local function applyShedletskyAppearance(model)
	appendDebugText("Applying Shedletsky Appearance")

	local head = model:WaitForChild("Head") 
	local torso = model:WaitForChild("Torso") 
	local larm = model:WaitForChild("Left Arm") 
	local lleg = model:WaitForChild("Left Leg") 
	local rarm = model:WaitForChild("Right Arm") 
	local rleg = model:WaitForChild("Right Leg") 

	head.Transparency = 0
	head.Color = Color3.fromRGB(215, 197, 154)
	torso.Transparency = 0
	larm.Transparency = 1
	larm.Color = Color3.fromRGB(215, 197, 154)
	lleg.Transparency = 0
	rarm.Transparency = 0
	rarm.Color = Color3.fromRGB(215, 197, 154)
	rleg.Transparency = 0

	local tmesh = torso:FindFirstChild("Tmesh")
	if tmesh then
		print('TMesh Found')
	else
		local torsom = Instance.new("SpecialMesh")
		torsom.MeshId = "rbxassetid://118094738169384"
		torsom.TextureId = "rbxassetid://117004853120529"
		torsom.Name = "Tmesh"
		torsom.Parent = torso
	end

	local tentacleBase = rarm:FindFirstChild("TentacleBase")

	if tentacleBase then
		-- 🎨 Change all Beam colors
		local customColorSequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(61, 0, 0)), -- 0 0.240201 0 approx
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)), -- 1 0 0
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 0 0 0
		})

		for _, obj in ipairs(tentacleBase:GetChildren()) do
			if obj:IsA("Beam") then
				obj.Color = customColorSequence
			end
		end

		-- 🔴 Change ParticleEmitter color inside the Attachment
		local attachment = tentacleBase:FindFirstChildWhichIsA("Attachment")
		if attachment then
			local emitter = attachment:FindFirstChildWhichIsA("ParticleEmitter")
			if emitter then
				emitter.Color = ColorSequence.new(Color3.fromRGB(139, 0, 0)) -- dark red
			end
		end
	else
		appendDebugText("TentacleBase not found in rarm")
	end

	local face = head:FindFirstChild("fac")

	if face then
		print("Face found")
	else
		local fac = Instance.new("Decal")
		fac.Texture = "http://www.roblox.com/asset/?id=7076053"
		fac.Name = "fac"
		fac.Parent = head
	end

	local noliparts = model:FindFirstChild("Noli")
	if noliparts then
		noliparts:Destroy()
	else
		print("No Noliparts found")
	end

	local vsc = model:WaitForChild("VoidstarCrown")
	vsc.MeshId = "rbxassetid://87420577072581"
	vsc.TextureID = "rbxassetid://112035104040861"

	-- 🗑 Remove all attachments named "Attachment" inside vsc
	for _, obj in ipairs(vsc:GetChildren()) do
		if obj:IsA("Attachment") and obj.Name == "Attachment" then
			obj:Destroy()
		end
	end


	local sa = vsc:FindFirstChild("SurfaceAppearance")
	if sa then 
		sa:Destroy()
	else
		print("Sa gone")
	end

	local shirt = model:FindFirstChild("Shirt")
	if shirt then
		print("Shirt Exists")
	else
		local camisa = Instance.new("Shirt")
		camisa.Name = "Shirt"
		camisa.ShirtTemplate = "http://www.roblox.com/asset/?id=9865284"
		camisa.Parent = model
	end

	local pants = model:FindFirstChild("Pants")
	if pants then
		print("Pants Exists")
	else
		local pant = Instance.new("Pants")
		pant.Name = "Pants"
		pant.PantsTemplate = "http://www.roblox.com/asset/?id=2157796"
		pant.Parent = model
	end
	
	local texturearm = rarm:FindFirstChild("TextureArm")
	if texturearm then
		print("Found Texture")
	else
		local trarm = Instance.new("Texture")
		trarm.Name = "TextureArm"
		trarm.OffsetStudsV = -0.2
		trarm.StudsPerTileU = 4
		trarm.StudsPerTileV = 4
		trarm.Texture = "rbxassetid://102747158118673"
		trarm.Face = "Bottom"
		trarm.Parent = rarm
	end

	local vs = model:WaitForChild("Voidstar")
	vs.TextureID = "rbxassetid://102747158118673"

	-- 🔴 Change all ParticleEmitter colors in Voidstar to red
	for _, obj in ipairs(vs:GetDescendants()) do
		if obj:IsA("ParticleEmitter") then
			obj.Color = ColorSequence.new(Color3.new(1, 0, 0)) -- Red
		end
	end

	-- 🔴 Also change emitters inside these child folders
	local effectFolders = { "AppearT", "Crush", "Explosion", "Main" }

	for _, folderName in ipairs(effectFolders) do
		local folder = model:FindFirstChild(folderName)
		if folder then
			for _, obj in ipairs(folder:GetDescendants()) do
				if obj:IsA("ParticleEmitter") then
					obj.Color = ColorSequence.new(Color3.new(1, 0, 0)) -- Red
				end
			end
		end
	end

	local darkRedColor = ColorSequence.new(Color3.fromRGB(139, 0, 0))

	local hmr = model:WaitForChild("HumanoidRootPart")
	local att = hmr:WaitForChild("Attachment")
	local Sp = att:WaitForChild("ShadowPuddle")

	-- Modify ShadowPuddle
	Sp.Brightness = 2
	Sp.Color = ColorSequence.new(Color3.new(1, 0, 0)) -- Pure red

	-- Look for the "Puddle" part inside HumanoidRootPart
	local puddle = hmr:FindFirstChild("Puddle")
	if puddle and puddle:IsA("Part") then
		for _, obj in ipairs(puddle:GetChildren()) do
			if obj:IsA("Trail") then
				obj.Brightness = 1
				obj.Color = darkRedColor
				warn("✅ Trail color set to dark red for:", obj:GetFullName())
			elseif obj:IsA("ParticleEmitter") then
				obj.Brightness = 1
				obj.Color = darkRedColor
				warn("✅ ParticleEmitter color set to dark red for:", obj:GetFullName())
			end
		end
	else
		warn("⚠️ Puddle part not found or not a Part in:", hmr:GetFullName())
	end





	local function destroyIfExists(childName)
		local obj = model:FindFirstChild(childName)
		if obj then obj:Destroy() end
		appendDebugText((not model:FindFirstChild(childName) and childName .. " destroyed") or (childName .. " not found"))
	end

	destroyIfExists("armeyesr")
	destroyIfExists("armeyesl")
	destroyIfExists("torsoMelt")
	destroyIfExists("headeyes")
	destroyIfExists("legmelt")


	attachMeshAccessory({
		character = model,
		targetPart = rarm,
		name = "armeyesr",
		meshId = 18729363127,
		textureId = 102747158118673,
		position = Vector3.new(0, -0.445, 0),
		rotation = Vector3.new(0, 0, 0),
		scale = Vector3.new(0.022, 0.022, 0.022)
	})

	attachMeshAccessory({
		character = model,
		targetPart = larm,
		name = "armeyesl",
		meshId = 84942951044641,
		textureId = 102747158118673,
		position = Vector3.new(0, 0, 0),
		rotation = Vector3.new(180, -90, 0),
		scale = Vector3.new(0.0055, 0.0055, 0.0055)
	})

	attachMeshAccessory({
		character = model,
		targetPart = torso,
		name = "torsoMelt",
		meshId = 70383093236918,
		textureId = 107838711094130,
		position = Vector3.new(-0.5, 0, -0.03),
		rotation = Vector3.new(0, 0, 0),
		scale = Vector3.new(1, 1, 1)
	})

	attachMeshAccessory({
		character = model,
		targetPart = head,
		name = "headeyes",
		meshId = 92887996087574,
		textureId = 113191180095691,
		position = Vector3.new(-0.2, 0, 0),
		rotation = Vector3.new(0, 0, 0),
		scale = Vector3.new(1.05, 1.05, 1.05)
	})

	attachMeshAccessory({
		character = model,
		targetPart = lleg,
		name = "legmelt",
		meshId = 18729363120,
		textureId = 102747158118673,
		position = Vector3.new(0, 0.4, 0),
		rotation = Vector3.new(0, 0, 0),
		scale = Vector3.new(0.02, 0.025, 0.022)
	})


	local success, importedAssets = pcall(function()
		return game:GetObjects("rbxassetid://96756124125481")
	end)

	if success and #importedAssets > 0 then
		local importedModel = importedAssets[1]
		importedModel.Name = "ImportedShedParts"
		importedModel.Parent = model

		local partsToMotor = {
			"Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg", "Torso", "Voidstar"
		}

		for _, partName in ipairs(partsToMotor) do
			local original = model:FindFirstChild(partName)
			local imported = importedModel:FindFirstChild(partName)

			if original and imported then
				-- Position the imported part at the original's location
				imported.CFrame = original.CFrame
				imported.Anchored = false
				imported.CanCollide = false
				-- Do NOT change parent — leave it inside ImportedShedParts

				-- Motor it to the original part
				local motor = Instance.new("Motor6D")
				motor.Name = "Motor_" .. partName
				motor.Part0 = original
				motor.Part1 = imported
				motor.C0 = CFrame.new()
				motor.C1 = CFrame.new()
				motor.Parent = original

				appendDebugText("Motored " .. partName .. " to imported version")
			else
				appendDebugText("Missing part: " .. partName)
			end
		end

		local originalVoidstar = model:FindFirstChild("Voidstar")
		local importedVoidstar = importedModel and importedModel:FindFirstChild("Voidstar")

		if originalVoidstar and importedVoidstar then
			local partsToSync = {}
			local decalsToSync = {}

			-- Add main imported Voidstar part
			table.insert(partsToSync, importedVoidstar)

			-- Gather all descendant parts and decals under importedVoidstar
			for _, descendant in ipairs(importedVoidstar:GetDescendants()) do
				if descendant:IsA("BasePart") then
					table.insert(partsToSync, descendant)
				elseif descendant:IsA("Decal") then
					table.insert(decalsToSync, descendant)
				end
			end

			-- Sync initial transparency
			for _, part in ipairs(partsToSync) do
				part.Transparency = originalVoidstar.Transparency
			end
			for _, decal in ipairs(decalsToSync) do
				decal.Transparency = originalVoidstar.Transparency
			end

			-- Update on change
			originalVoidstar:GetPropertyChangedSignal("Transparency"):Connect(function()
				local newTransparency = originalVoidstar.Transparency
				for _, part in ipairs(partsToSync) do
					part.Transparency = newTransparency
				end
				for _, decal in ipairs(decalsToSync) do
					decal.Transparency = newTransparency
				end
			end)

			appendDebugText("✅ Transparency sync setup: Parts ("..#partsToSync.."), Decals ("..#decalsToSync..")")
		else
			appendDebugText("❌ Could not find both Voidstars to sync transparency")
		end


	else
		appendDebugText("Failed to load imported asset or asset was empty")
	end





end


-- Get Humanoid


local function watchForCorrectShed()
	local appliedModel = nil

	local function tryApply()
		if appliedModel and appliedModel.Parent == nil then
			appendDebugText("Previous Shedletsky model removed. Waiting for reappearance...")
			appliedModel = nil
		end

		if appliedModel then return end

		for _, model in pairs(survivorFolder:GetChildren()) do
			if model:IsA("Model") and model.Name == "Noli" then
				local usernameAttr = model:GetAttribute("Username")
				if usernameAttr == player.Name then
					appendDebugText("Matching Shedletsky model found for player, applying appearance...")
					applyShedletskyAppearance(model)
					appliedModel = model
					break
				else
					appendDebugText("Skipped non-matching Shedletsky model with Username: " .. tostring(usernameAttr))
				end
			end
		end
	end

	tryApply()

	survivorFolder.ChildAdded:Connect(function()
		task.wait(0.2)
		tryApply()
	end)

	survivorFolder.ChildRemoved:Connect(function()
		task.wait(0.2)
		tryApply()
	end)
end

watchForCorrectShed()


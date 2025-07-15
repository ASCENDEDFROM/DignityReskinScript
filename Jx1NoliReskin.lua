local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

-- Replace DisplayName in the Noli config
local RS = game:GetService("ReplicatedStorage") -- FIXED typo here
local path = RS:WaitForChild("Assets"):WaitForChild("Killers"):WaitForChild("Noli"):WaitForChild("Config")
local NoliConfig = require(path)

-- Test override
NoliConfig.DisplayName = "Jx1Dx1"
NoliConfig.RenderImage = "rbxassetid://87037418899991"


-- Replace Kill voicelines with a new table of asset IDs
NoliConfig.Voicelines.Kill = {
	"rbxassetid://79404262951853",
    "rbxassetid://94158270200818",
    "rbxassetid://121036848793085"
}
NoliConfig.Voicelines.Stunned = {
	"rbxassetid://99167320062822",
    "rbxassetid://96281103613406"
}

for i, soundId in ipairs(NoliConfig.Voicelines.Stunned) do
    print("Stunned Voiceline", i, "=", soundId)
end





-- Test it
for i, id in ipairs(NoliConfig.Voicelines.Kill) do
	print("New Kill Voiceline #" .. i .. ": " .. id)
end

print("New DisplayName:", NoliConfig.DisplayName)

 
local CONFIG = {
    ModelId = 124256690073972,
    CharacterName = "Noli",
    Movement = {
        WalkSpeed = 16,
        JumpPower = 0
    }
}
 
local function createWatermark()
    local watermark = Instance.new("ScreenGui")
    watermark.Name = "HexxedWatermark"
    watermark.IgnoreGuiInset = true
    watermark.ResetOnSpawn = false
 
    local label = Instance.new("TextLabel")
    label.Name = "WatermarkLabel"
    label.Text = "script by Hexxed, finished by Ascend."
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextTransparency = 0.3
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 150, 0, 20)
    label.Position = UDim2.new(0.5, -75, 1, -30)
    label.Parent = watermark
    watermark.Parent = player.PlayerGui
end
 
createWatermark()
 
local function setupCharacterAssets()
    local noliRework = replicatedStorage.Assets.Killers:FindFirstChild("#NoliRework")
    if not noliRework then return end
 
    local coolkidSkin = replicatedStorage.Assets.Skins.Killers.c00lkidd.OriginalC00l
    if not coolkidSkin then return end
 
    local existingConfig = coolkidSkin:FindFirstChild("Config")
    if existingConfig then existingConfig:Destroy() end
 
    local toCopy = {"Config", "VictoryCameraRig", "CameraRig"}
    for _, name in ipairs(toCopy) do
        local obj = noliRework:FindFirstChild(name)
        if obj then
            obj:Clone().Parent = coolkidSkin
        end
    end
end
 
local function deleteUnwantedObjects()
    local coolkid = workspace.Players.Killers:FindFirstChild("c00lkidd")
    if coolkid then
        local objectsToDelete = {"c00lgui", "firebrand", "Shirt"}
        for _, name in ipairs(objectsToDelete) do
            local obj = coolkid:FindFirstChild(name)
            if obj then obj:Destroy() end
        end
 
        local head = coolkid:FindFirstChild("Head")
        if head then
            local face = head:FindFirstChild("face")
            if face then face:Destroy() end
        end
    end
 
    local coolkidConfig = replicatedStorage.Assets.Killers.c00lkidd.Config
    if coolkidConfig then
        local gui = coolkidConfig:FindFirstChild("c00lgui")
        if gui then gui:Destroy() end
    end
end
 
setupCharacterAssets()
deleteUnwantedObjects()
 
local function makeCharacterLimbsTransparent(character)
    local bodyParts = {
        "Head",
        "Torso",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg"
    }
 
    for _, partName in ipairs(bodyParts) do
        local part = character:FindFirstChild(partName)
        if part then
            part.Transparency = 1
            if part:IsA("MeshPart") then
                part.TextureID = ""
            end
            for _, dec in ipairs(part:GetDescendants()) do
                if dec:IsA("Decal") then
                    dec.Transparency = 1
                end
            end
        end
    end
 
    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 1
                for _, dec in ipairs(handle:GetDescendants()) do
                    if dec:IsA("Decal") or dec:IsA("Texture") then
                        dec.Transparency = 1
                    end
                end
            end
        end
    end
end
 
local function deleteSpecificObjects()
    local noliFolder = workspace.Players.Killers:FindFirstChild("Noli")
    if not noliFolder then return end
 
    local targets = {
        noliFolder:FindFirstChild("Tentacle"),
        noliFolder:FindFirstChild("Noli"),
        noliFolder:FindFirstChild("VoidstarCrown")
    }
 
    for _, target in ipairs(targets) do
        if target then target:Destroy() end
    end
end
 
local function modifyVoidstar()
    local worldVoidstar = workspace.Map.Ingame:FindFirstChild("Voidstar")
    if worldVoidstar and worldVoidstar:IsA("MeshPart") then
        worldVoidstar.MeshId = "http://www.roblox.com/asset/?id=16190555"
 
        local noliFolder = workspace.Players.Killers:FindFirstChild("Noli")
        if noliFolder then
            local jx1dx1 = noliFolder:FindFirstChild("JX1DX1")
            if jx1dx1 then
                local modelVoidstar = jx1dx1:FindFirstChild("Voidstar")
                if modelVoidstar then
                    local highlight = modelVoidstar:FindFirstChild("Highlight")
                    if highlight then
                        highlight:Clone().Parent = worldVoidstar
                    end
                end
            end
        end
    end
end
 
local function modifyNoliVoidstar()
    local noliFolder = workspace.Players.Killers:FindFirstChild("Noli")
    if not noliFolder then return end
 
    local noliVoidstar = noliFolder:FindFirstChild("Voidstar")
    if not noliVoidstar then return end
 
    noliVoidstar.Transparency = 0
 
    if noliVoidstar:IsA("MeshPart") then
        noliVoidstar.MeshId = "http://www.roblox.com/asset/?id=16190555"
        noliVoidstar.Material = Enum.Material.SmoothPlastic
        noliVoidstar.Color = Color3.new(1, 0, 0)
        noliVoidstar.Size = Vector3.new(6, 6, 6)
    end
 
    local jx1dx1 = noliFolder:FindFirstChild("JX1DX1")
    if jx1dx1 then
        local modelVoidstar = jx1dx1:FindFirstChild("Voidstar")
        if modelVoidstar then
            local currentStar = modelVoidstar:FindFirstChild("currentstar")
            if currentStar then
                currentStar.Transparency = 1
 
                local highlight = currentStar:FindFirstChild("Highlight")
                if highlight then
                    highlight:Clone().Parent = noliVoidstar
                end
 
                local number = currentStar:FindFirstChild("Number")
                if number then
                    number:Clone().Parent = noliVoidstar
                end
            end
        end
    end
 
    local appear1 = noliVoidstar:FindFirstChild("Appear1")
    local appear2 = noliVoidstar:FindFirstChild("Appear2")
    local appearT = noliVoidstar:FindFirstChild("AppearT")
 
    local emitters = {appear1, appear2}
    if appearT then
        table.insert(emitters, appearT:FindFirstChild("Appear3"))
        table.insert(emitters, appearT:FindFirstChild("Appear4"))
    end
 
    for _, emitter in ipairs(emitters) do
        if emitter and emitter:IsA("ParticleEmitter") then
            emitter.Color = ColorSequence.new(Color3.new(1, 0, 0))
        end
    end
end
 
local function replaceSoundIds(model)
    if not model then return end
 
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
 
    local noliStunSounds = {
        "rbxassetid://77178807796146",
        "rbxassetid://91017967178100",
        "rbxassetid://96946385572611",
        "rbxassetid://110684813246558"
    }
 
    local noliKillSounds = {
        "rbxassetid://109301111857562",
        "rbxassetid://91228266003282"
    }
 
    local jx1dx1KillSounds = {
        "79404262951853",
        "94158270200818",
        "121036848793085"
    }
 
    local jx1dx1StunSounds = {
        "99167320062822",
        "96281103613406"
    }
 
    for _, sound in ipairs(hrp:GetDescendants()) do
        if sound:IsA("Sound") and (sound.Name == "VoicelineSFX" or sound.Name == "VoicelineVFX") then
            if sound.SoundId == "rbxassetid://105079226220020" then
                sound.SoundId = "rbxassetid://105079226220020"
            elseif sound.SoundId == "rbxassetid://95524724737837" then
                sound.SoundId = "rbxassetid://95524724737837"
            elseif sound.SoundId == "rbxassetid://103787230519184" then
                sound.SoundId = "rbxassetid://103787230519184"
            else
                for _, id in ipairs(noliStunSounds) do
                    if sound.SoundId == id then
                        local randomIndex = math.random(1, #noliStunSounds)
                        sound.SoundId = noliStunSounds[randomIndex]
                        break
                    end
                end
 
                for _, id in ipairs(noliKillSounds) do
                    if sound.SoundId == id then
                        local randomIndex = math.random(1, #noliKillSounds)
                        sound.SoundId = noliKillSounds[randomIndex]
                        break
                    end
                end
 
                if sound.Name:find("Kill") or sound.Name:find("kill") then
                    local randomIndex = math.random(1, #jx1dx1KillSounds)
                    sound.SoundId = "rbxassetid://" .. jx1dx1KillSounds[randomIndex]
                elseif sound.Name:find("Stun") or sound.Name:find("stun") then
                    local randomIndex = math.random(1, #jx1dx1StunSounds)
                    sound.SoundId = "rbxassetid://" .. jx1dx1StunSounds[randomIndex]
                end
            end
        end
    end
end
 
local function modifyGeneratorTeleportButton()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end
 
    local teleportButton = playerGui:FindFirstChild("GeneratorTeleportButton")
    if teleportButton then
        local imageButton = teleportButton:FindFirstChild("ImageButton")
        if imageButton and imageButton:IsA("ImageButton") then
            imageButton.Image = "rbxassetid://84024258784560"
        end
    end
end
 
local function modifyHighlights()
    for _, generator in ipairs(workspace.Map.Ingame.Map.Generators:GetDescendants()) do
        if generator:IsA("Highlight") then
            if generator.FillColor == Color3.fromRGB(162, 0, 255) then
                generator.FillColor = Color3.new(1, 0, 0)
                generator.OutlineColor = Color3.new(0, 0, 0)
            end
        end
    end
 
    for _, survivor in ipairs(workspace.Players.Survivors:GetDescendants()) do
        if survivor:IsA("Highlight") then
            if survivor.FillColor == Color3.fromRGB(162, 0, 255) then
                survivor.FillColor = Color3.new(1, 0, 0)
                survivor.OutlineColor = Color3.new(0.4, 0, 0)
            end
        end
    end
end
 
local function handleTentacleParts()
    local noliFolder = workspace.Players.Killers:FindFirstChild("Noli")
    if not noliFolder then return end
 
    for _, descendant in ipairs(noliFolder:GetDescendants()) do
        if descendant.Name == "TentacleBase" and descendant:IsA("BasePart") then
            descendant.Transparency = 1
        end
    end
 
    local jx1dx1 = noliFolder:FindFirstChild("JX1DX1")
    if jx1dx1 then
        local rightArm = jx1dx1:FindFirstChild("Right Arm")
        if rightArm and #rightArm:GetChildren() >= 3 then
            local thirdChild = rightArm:GetChildren()[3]
            if thirdChild and thirdChild:IsA("BasePart") then
                thirdChild.Transparency = 1
            end
        end
 
        local tentacle = jx1dx1:FindFirstChild("Tentacle")
        if tentacle and tentacle:IsA("BasePart") then
            tentacle.Transparency = 1
        end
    end
end
 
local function modifyJX1DX1()
    local noliFolder = workspace.Players.Killers:FindFirstChild("Noli")
    if not noliFolder then return end
 
    local model = noliFolder:FindFirstChild("JX1DX1")
    if not model then return end
 
    local partsToHide = {"Left Arm", "Right Arm", "Left Leg", "Right Leg", "Torso"}
    for _, partName in ipairs(partsToHide) do
        local part = model:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
 
    local noliParts = {"Left Arm", "Right Arm", "Left Leg", "Right Leg", "Torso"}
    for _, partName in ipairs(noliParts) do
        local part = noliFolder:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
 
    local toCopy = {"Highlight", "Shirt Graphic", "Body Colors"}
    for _, name in ipairs(toCopy) do
        local obj = model:FindFirstChild(name)
        if obj then
            local clone = obj:Clone()
            clone.Parent = noliFolder
        end
    end
 
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:IsA("BasePart") then
        hrp.Transparency = 1
    end
 
    local fakeCrown = model:FindFirstChild("FakeCrown")
    if fakeCrown then
        fakeCrown:Destroy()
    end
 
    handleTentacleParts()
    modifyVoidstar()
    modifyNoliVoidstar()
    replaceSoundIds(model)
    modifyGeneratorTeleportButton()
    modifyHighlights()
end
 
local function loadModel()
    local character = player.Character
    if not character or character.Name ~= CONFIG.CharacterName then return end
 
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = CONFIG.Movement.WalkSpeed
        humanoid.JumpPower = CONFIG.Movement.JumpPower
    end
 
    local hrp = character:WaitForChild("HumanoidRootPart")
    if character:FindFirstChild("JX1DX1") then return end
 
    local model
    local success, result = pcall(function()
        return game:GetObjects("rbxassetid://"..CONFIG.ModelId)[1]
    end)
 
    if not success or not result then return end
 
    model = result:Clone()
    model.Name = "JX1DX1"
    model.PrimaryPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChildWhichIsA("BasePart")
    if not model.PrimaryPart then return end
 
    makeCharacterLimbsTransparent(character)
 
    model.Parent = character
    model:SetPrimaryPartCFrame(hrp.CFrame)
 
    local rootMotor = Instance.new("Motor6D")
    rootMotor.Name = "RootJoint"
    rootMotor.Part0 = hrp
    rootMotor.Part1 = model.PrimaryPart
    rootMotor.C0 = CFrame.new()
    rootMotor.C1 = CFrame.new()
    rootMotor.Parent = hrp
 
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.Anchored = false
            part.CanCollide = false
            part.Massless = true
        end
    end
 
    local modelHumanoid = model:FindFirstChildOfClass("Humanoid")
    if modelHumanoid then modelHumanoid:Destroy() end
 
    local function createModelMotors(charModel, model)
        local partMap = {
            Head = "Head",
            Torso = "Torso",
            ["Left Arm"] = "Left Arm",
            ["Right Arm"] = "Right Arm",
            ["Left Leg"] = "Left Leg",
            ["Right Leg"] = "Right Leg"
        }
 
        for modelPartName, charPartName in pairs(partMap) do
            local modelPart = model:FindFirstChild(modelPartName)
            local charPart = charModel:FindFirstChild(charPartName)
            if modelPart and charPart then
                local motor = Instance.new("Motor6D")
                motor.Name = modelPartName.."_Motor"
                motor.Part0 = charPart
                motor.Part1 = modelPart
                motor.C0 = CFrame.new()
                motor.C1 = CFrame.new()
                motor.Parent = charPart
            end
        end
    end
 
    local function attachAccessories(charModel, model)
        for _, accessory in ipairs(model:GetChildren()) do
            if accessory:IsA("Accessory") then
                local handle = accessory:FindFirstChild("Handle")
                if handle then
                    for _, weld in ipairs(handle:GetChildren()) do
                        if weld:IsA("Weld") or weld:IsA("WeldConstraint") or weld:IsA("Motor6D") then
                            weld:Destroy()
                        end
                    end
 
                    local function findAttachmentPoint(char, handle)
                        local handleAttachment = handle:FindFirstChildWhichIsA("Attachment")
                        if not handleAttachment then return nil end
                        for _, part in ipairs(char:GetDescendants()) do
                            local charAttachment = part:FindFirstChild(handleAttachment.Name)
                            if charAttachment and charAttachment:IsA("Attachment") then
                                return part
                            end
                        end
                        return nil
                    end
 
                    local attachPart = findAttachmentPoint(charModel, handle)
                    if attachPart then
                        local mainMotor = Instance.new("Motor6D")
                        mainMotor.Name = "Main_"..accessory.Name.."_Motor"
                        mainMotor.Part0 = attachPart
                        mainMotor.Part1 = handle
                        mainMotor.C0 = CFrame.new()
                        mainMotor.C1 = CFrame.new()
                        mainMotor.Parent = attachPart
                        accessory.Parent = charModel
                    end
                end
            end
        end
    end
 
    createModelMotors(character, model)
    attachAccessories(character, model)
 
    task.delay(1, function()
        if not model.Parent then return end
        if (model.PrimaryPart.Position - hrp.Position).Magnitude > 5 then
            model:SetPrimaryPartCFrame(hrp.CFrame)
        end
        deleteSpecificObjects()
        modifyJX1DX1()
    end)
end
 
player.CharacterAdded:Connect(function(char)
    if char.Name == CONFIG.CharacterName then
        task.wait(0.5)
        loadModel()
    end
end)
 
if player.Character and player.Character.Name == CONFIG.CharacterName then
    loadModel()
end
 
deleteSpecificObjects()
modifyJX1DX1()
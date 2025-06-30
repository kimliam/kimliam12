-- 🔁 LEGAL Egg Detector & Pet Spawner (for private/local use only)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer or Players:GetPlayers()[1]
repeat wait() until player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Egg-to-Pet Mapping (randomized selection)
local eggPetMap = {
    NightEgg = {"HedgehogPet", "MolePet", "FrogPet", "EchoFrogPet", "NightOwlPet", "RaccoonPet"},
    MythicalEgg = {"RedGiantAntPet", "SquirrelPet", "RedFoxPet"},
    ParadiseEgg = {"OstrichPet", "PeacockPet", "CapybaraPet", "ScarletMacawPet", "MimicOctopusPet"},
    BugEgg = {"CaterpillarPet", "GiantMantisPet", "GiantAntPet", "DragonflyPet"},
    OasisEgg = {"MeerkatPet", "SandSnakePet", "AxolotlPet", "HyacinthMacawPet", "FennecFoxPet"}
}

-- Config
local detectionRadius = 15
local checkInterval = 0.2
local lastCheck = 0
local detectedEggs = {}

-- Pet Spawner
local function spawnPet(petName)
    local petModel = ReplicatedStorage:FindFirstChild(petName)
    if not petModel then
        warn("⚠️ Missing pet model: " .. tostring(petName))
        return
    end

    local pet = petModel:Clone()
    pet.Name = player.Name .. "_" .. petName
    pet.Parent = workspace

    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if pet.PrimaryPart and root then
        pet:SetPrimaryPartCFrame(root.CFrame * CFrame.new(3, 0, 2))
    end
end

-- Egg Detection Loop
RunService.Heartbeat:Connect(function(dt)
    lastCheck += dt
    if lastCheck < checkInterval then return end
    lastCheck = 0

    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and eggPetMap[obj.Name] and not detectedEggs[obj] then
            local dist = (obj.Position - root.Position).Magnitude
            if dist <= detectionRadius then
                detectedEggs[obj] = true
                local petList = eggPetMap[obj.Name]
                local randomPet = petList[math.random(1, #petList)]
                spawnPet(randomPet)
                obj:Destroy()
            end
        end
    end
end)

print("✅ Egg Detector & Pet Spawner Loaded Successfully")

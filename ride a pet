-- ==========================================
-- 1. AUTOMATIC CLEANUP (Kills old/stuck GUIs)
-- ==========================================
local guiLocation = typeof(gethui) == "function" and gethui() or game:GetService("CoreGui")
for _, obj in ipairs(guiLocation:GetDescendants()) do
    if obj:IsA("BillboardGui") and obj.Adornee == workspace.Terrain then
        pcall(function() obj:Destroy() end)
    end
end
for _, gui in ipairs(guiLocation:GetChildren()) do
    if gui:IsA("ScreenGui") and string.match(gui.Name, "^%w+$") and #gui.Name >= 12 and #gui.Name <= 20 then
        pcall(function() gui:Destroy() end)
    end
end

-- ==========================================
-- 2. UI INITIALIZATION
-- ==========================================
task.spawn(pcall, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/DiscordLink"))()
end)

local v

local function fn()
    local response = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli%20Library")
    local chunk, v2 = loadstring(response)
    assert(chunk, v2)
    local v3 = chunk()
    assert(type(v3) == "function", "Chilli Library bootstrap is invalid.")
    local v4 = table.create(45)
    local n = 1

    for i = 1, 90, 2 do
        v4[n] = string.char(bit32.bxor(tonumber(string.sub("306908100841206d474f00185f26635b2101387507010810127d7d477a473b6f435a0916573165562900226c00", i, i + 1), 16), string.byte("s9K!2vQ#", (n - 1) % 8 + 1)))
        n += 1
    end

    return v3(table.concat(v4))
end

v = fn()
assert(type(v) == "table" and type(v.CreateWindow) == "function" and type(v.Finalize) == "function", "Chilli Library returned an invalid API.")

v.ManualQuickDefaults = { LeftCenterHidden = true }

local v2 = v:CreateWindow({ Name = "Jaeii Cute", DefaultTab = "Main" })
local defaultTab = v2:GetDefaultTab()

-- ==========================================
-- 3. GAME SERVICES & VARIABLES
-- ==========================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local activeEggs = ReplicatedStorage:WaitForChild("ServerData"):WaitForChild("ActiveEggs")
local gameRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Game")
local v3 = guiLocation

local function fn7(arg)
    local ok, result = pcall(function() return require(arg()) end)
    return ok and result or nil
end

local tbl = {
    Eggs = fn7(function() return ReplicatedStorage.GameData.Eggs end)
}

local function fn2()
    local v4 = Random.new()
    local str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local v5 = v4:NextInteger(12, 20)
    local v6 = table.create(v5)
    for i = 1, v5 do
        v6[i] = string.sub(str, v4:NextInteger(1, #str), v4:NextInteger(1, #str))
    end
    return table.concat(v6)
end

-- ==========================================
-- 4. SHARED UTILITIES & RARITY DATA
-- ==========================================
local tbl3 = {}
local tbl5 = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Ethereal" }

tbl3.RarityColors = {
    Common = Color3.fromRGB(214, 218, 228),
    Rare = Color3.fromRGB(96, 170, 255),
    Epic = Color3.fromRGB(190, 110, 255),
    Legendary = Color3.fromRGB(255, 196, 66),
    Mythic = Color3.fromRGB(255, 82, 90),
    Divine = Color3.fromRGB(255, 240, 150),
    Ethereal = Color3.fromRGB(125, 225, 255),
}

tbl3.Root = function()
    local character = localPlayer.Character
    character = character and character:FindFirstChild("HumanoidRootPart")
    if character and character:IsDescendantOf(workspace) then
        return character
    end
    return nil
end

tbl3.EggData = function(arg)
    local eggs = tbl.Eggs
    local flag = type(eggs) == "table" and eggs[tostring(arg)] or nil
    return type(flag) == "table" and flag or nil
end

tbl3.EggRarity = function(arg)
    local v6 = tbl3.EggData(arg)
    return v6 and tostring(v6.Rarity) or "Common"
end

-- ==========================================
-- 5. TP AUTO FARM & VOLCANO DIP LOGIC
-- ==========================================
local farmSection = defaultTab:CreateSection({ Name = "TP Auto Farm", Expanded = true })

local volcanoPos = Vector3.new(-5117.2, 41405.4, -3480.0) 

local autoFarmTP = false
local tpDelay = 0.3
local farmTargetRarities = {}
local volcanoDipEnabled = false

local function FireRemote(remoteName, ...)
    local remote = gameRemote:FindFirstChild(remoteName)
    if remote and remote:IsA("RemoteEvent") then
        pcall(function(...) remote:FireServer(...) end, ...)
    end
end

local function getPlotDropPosition()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local data = plot:FindFirstChild("Data")
            local owner = data and data:FindFirstChild("Owner")
            if owner and owner.Value == localPlayer then
                local baseplate = plot:FindFirstChild("Baseplate")
                if baseplate then
                    return baseplate.Position + Vector3.new(0, (baseplate.Size.Y / 2) + 5, 0)
                end
            end
        end
    end
    return nil
end

local function getBasketEggs()
    local basket = localPlayer:FindFirstChild("Basket")
    local eggsToDrop = {}
    if basket then
        for _, child in ipairs(basket:GetChildren()) do
            local eggType = child:GetAttribute("Egg")
            if type(eggType) == "string" then
                table.insert(eggsToDrop, eggType)
            end
        end
    end
    return eggsToDrop
end

-- Helper to click the game's native UI prompt
local function ClickVolcanoDropUI()
    local pGui = localPlayer:FindFirstChild("PlayerGui")
    if not pGui then return false end
    
    for _, desc in ipairs(pGui:GetDescendants()) do
        if (desc:IsA("TextLabel") or desc:IsA("TextButton")) and desc.Text then
            local text = string.lower(desc.Text)
            if string.find(text, "drop in volcano") then
                local btn = desc:IsA("TextButton") and desc or desc:FindFirstAncestorWhichIsA("TextButton") or desc:FindFirstAncestorWhichIsA("ImageButton")
                if btn and getconnections then
                    for _, conn in ipairs(getconnections(btn.Activated)) do pcall(function() conn:Fire() end) end
                    for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do pcall(function() conn:Fire() end) end
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while task.wait(0.1) do
        if not autoFarmTP then continue end
        
        local root = tbl3.Root()
        if not root then continue end

        local basketEggs = getBasketEggs()

        -- Bring any stuck eggs home first
        if #basketEggs > 0 then
            local dropPos = getPlotDropPosition()
            if dropPos then
                root.CFrame = CFrame.new(dropPos)
                root.AssemblyLinearVelocity = Vector3.zero
                task.wait(tpDelay) 
                
                for _, eggType in ipairs(basketEggs) do
                    FireRemote("BasketDrop", eggType)
                end
                task.wait(0.5)
            end
            continue
        end

        local nearestEgg = nil
        local minDist = math.huge
        
        for _, egg in ipairs(activeEggs:GetChildren()) do
            local pos = egg:GetAttribute("Position")
            local privateTo = egg:GetAttribute("PrivateTo")
            local eggName = egg:GetAttribute("Egg")
            
            if typeof(pos) == "Vector3" and (privateTo == nil or privateTo == localPlayer.UserId) then
                if type(eggName) == "string" then
                    local rarityName = tbl3.EggRarity(eggName)
                    if next(farmTargetRarities) ~= nil and not farmTargetRarities[rarityName] then 
                        continue 
                    end
                end

                local dist = (pos - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestEgg = egg
                end
            end
        end

        if nearestEgg then
            local pos = nearestEgg:GetAttribute("Position")
            local targetEggId = nearestEgg.Name

            -- 1. Pick up the egg from map
            root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            root.AssemblyLinearVelocity = Vector3.zero
            task.wait(tpDelay) 
            FireRemote("EggPickup", targetEggId)
            task.wait(0.5) 
            
            -- 2. VOLCANO DIP SEQUENCE
            if volcanoDipEnabled and volcanoPos ~= Vector3.zero then
                local basketHasEgg = false
                local basketCheck = localPlayer:FindFirstChild("Basket")
                if basketCheck and #basketCheck:GetChildren() > 0 then
                    basketHasEgg = true
                end

                if basketHasEgg then
                    root.CFrame = CFrame.new(volcanoPos + Vector3.new(0, 5, 0))
                    root.AssemblyLinearVelocity = Vector3.zero
                    task.wait(tpDelay)
                    
                    -- Trigger UI click to drop in volcano
                    ClickVolcanoDropUI()
                    
                    -- Increased mutation wait time to 4.5 seconds
                    task.wait(4.5)
                    
                    -- Actively scan the volcano zone until the egg spawns back in workspace
                    local dippedEggId = nil
                    local timeout = 0
                    while not dippedEggId and timeout < 6.0 do
                        task.wait(0.2)
                        timeout = timeout + 0.2
                        for _, egg in ipairs(activeEggs:GetChildren()) do
                            local ePos = egg:GetAttribute("Position")
                            local privateTo = egg:GetAttribute("PrivateTo")
                            if ePos and (privateTo == nil or privateTo == localPlayer.UserId) then
                                if Vector2.new(ePos.X - volcanoPos.X, ePos.Z - volcanoPos.Z).Magnitude < 45 then
                                    dippedEggId = egg.Name
                                    break
                                end
                            end
                        end
                    end
                    
                    -- Grab the dipped egg with an extended safe delay
                    if dippedEggId then
                        root.CFrame = CFrame.new(volcanoPos + Vector3.new(0, 3, 0))
                        root.AssemblyLinearVelocity = Vector3.zero
                        task.wait(1.0) -- Extended delay before sending the pickup request
                        FireRemote("EggPickup", dippedEggId)
                        task.wait(0.8)
                    end
                end
            end
            
            -- 3. Teleport back to Base Plot and Drop
            local dropPos = getPlotDropPosition()
            if dropPos then
                root.CFrame = CFrame.new(dropPos)
                root.AssemblyLinearVelocity = Vector3.zero
                task.wait(tpDelay) 
                
                local currentBasket = getBasketEggs()
                for _, eggType in ipairs(currentBasket) do
                    FireRemote("BasketDrop", eggType)
                end
                task.wait(0.5)
            end
        end
    end
end)

farmSection:CreateToggle({
    Name = "Enable TP Farm",
    Default = false,
    Callback = function(state)
        autoFarmTP = state
    end,
})

farmSection:CreateMultiDropdown({
    Name = "Farm Target Rarities",
    Options = tbl5,
    Default = {},
    Callback = function(selected)
        farmTargetRarities = {}
        if type(selected) == "table" then
            for k, val in pairs(selected) do
                if val == true and type(k) == "string" then
                    farmTargetRarities[k] = true
                elseif type(val) == "string" then
                    farmTargetRarities[val] = true
                end
            end
        end
    end,
})

farmSection:CreateToggle({
    Name = "Enable Volcano Dip",
    Default = false,
    Callback = function(state)
        volcanoDipEnabled = state
    end,
})

farmSection:CreateSlider({
    Name = "TP Server Delay",
    Min = 0.1,
    Max = 1.0,
    Default = 0.3,
    AllowDecimals = true,
    Increment = 0.1,
    Callback = function(val)
        tpDelay = tonumber(val) or 0.3
    end,
})

-- ==========================================
-- 6. EGG ESP LOGIC
-- ==========================================
local espSection = defaultTab:CreateSection({ Name = "Egg ESP", Expanded = true })
local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
local espTargetRarities = {}
local espEnabled = false
local weightRatio = 6.51
local folder = nil
local eggTracker = {}
local connections = {}

local function createStrokeText(parent, sizeOffset)
    parent.BackgroundTransparency = 1
    parent.FontFace = font
    parent.TextScaled = true
    parent.TextStrokeTransparency = 1
    parent.TextColor3 = Color3.fromRGB(255, 255, 255)
    parent.Size = UDim2.new(1, 0, 0, sizeOffset)
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Name = fn2()
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    uiStroke.LineJoinMode = Enum.LineJoinMode.Round
    uiStroke.Color = Color3.fromRGB(0, 0, 0)
    uiStroke.Thickness = 1.8
    uiStroke.Transparency = 0.05
    uiStroke.Parent = parent
end

local function removeEsp(child)
    local data = eggTracker[child]
    if data then
        eggTracker[child] = nil
        pcall(function() data.Gui:Destroy() end)
    end
end

local function addEsp(arg)
    if eggTracker[arg] or not folder then return end
    
    local attribute = arg:GetAttribute("Egg")
    local attribute2 = arg:GetAttribute("Position")
    
    if type(attribute) ~= "string" or typeof(attribute2) ~= "Vector3" then return end
    
    local attribute3 = arg:GetAttribute("PrivateTo")
    if attribute3 ~= nil and attribute3 ~= localPlayer.UserId then return end

    local rarityName = tbl3.EggRarity(attribute)
    if next(espTargetRarities) ~= nil and not espTargetRarities[rarityName] then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = fn2()
    billboardGui.AlwaysOnTop = true
    billboardGui.LightInfluence = 0
    billboardGui.Size = UDim2.fromOffset(170, 46)
    billboardGui.Adornee = workspace.Terrain
    billboardGui.StudsOffsetWorldSpace = attribute2 + Vector3.new(0, 4, 0)
    billboardGui.MaxDistance = 100000
    
    local frame = Instance.new("Frame")
    frame.Name = fn2()
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.fromScale(1, 1)
    frame.Parent = billboardGui
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Name = fn2()
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = fn2()
    textLabel.LayoutOrder = 1
    createStrokeText(textLabel, 24)
    textLabel.Text = attribute
    textLabel.TextColor3 = tbl3.RarityColors[rarityName] or Color3.fromRGB(255, 255, 255)
    textLabel.Parent = frame
    
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Name = fn2()
    textLabel2.LayoutOrder = 2
    createStrokeText(textLabel2, 18)
    textLabel2.TextColor3 = Color3.fromRGB(230, 232, 240)
    textLabel2.Parent = frame
    
    billboardGui.Parent = folder

    eggTracker[arg] = {
        Gui = billboardGui,
        Info = textLabel2,
        Rarity = rarityName,
        Position = attribute2,
        RawWeight = tonumber(arg:GetAttribute("Weight")) or 0
    }
end

local function clearAllEsp()
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
    table.clear(connections)

    for k in pairs(eggTracker) do
        removeEsp(k)
    end

    if folder then
        pcall(function() folder:Destroy() end)
        folder = nil
    end
end

local function initEsp()
    clearAllEsp()
    if not espEnabled then return end
    
    folder = Instance.new("Folder")
    folder.Name = fn2()
    folder.Parent = v3
    
    local children = activeEggs:GetChildren()
    for _, child in ipairs(children) do
        addEsp(child)
    end

    table.insert(connections, activeEggs.ChildAdded:Connect(function(child)
        task.defer(addEsp, child)
    end))

    table.insert(connections, activeEggs.ChildRemoved:Connect(removeEsp))
    
    local timer = 0
    table.insert(connections, RunService.Heartbeat:Connect(function(deltaTime)
        timer += deltaTime
        if timer < 0.5 then return end
        timer = 0
        
        local root = tbl3.Root()
        if not root then return end

        for eggInstance, data in pairs(eggTracker) do
            if eggInstance and eggInstance.Parent then
                local currentWeight = tonumber(eggInstance:GetAttribute("Weight")) or 0
                local displayWeight = currentWeight * weightRatio
                local dist = math.floor((data.Position - root.Position).Magnitude)
                data.Info.Text = string.format("%s  |  %.2fkg  |  %dm", data.Rarity, displayWeight, dist)
            end
        end
    end))
end

espSection:CreateToggle({
    Name = "Enable Egg ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            initEsp()
        else
            clearAllEsp()
        end
    end,
})

espSection:CreateMultiDropdown({
    Name = "ESP Target Rarities",
    Options = tbl5,
    Default = {},
    Callback = function(selected)
        espTargetRarities = {}
        if type(selected) == "table" then
            for k, val in pairs(selected) do
                if val == true and type(k) == "string" then
                    espTargetRarities[k] = true
                elseif type(val) == "string" then
                    espTargetRarities[val] = true
                end
            end
        end
        if espEnabled then
            initEsp()
        end
    end,
})

espSection:CreateInput({
    Name = "Weight Ratio Multiplier",
    Placeholder = "e.g., 6.51",
    Default = "6.51",
    Callback = function(text)
        local parsed = tonumber(text)
        if parsed then
            weightRatio = parsed
            if espEnabled and folder then
                local root = tbl3.Root()
                if root then
                    for eggInstance, data in pairs(eggTracker) do
                        if eggInstance and eggInstance.Parent then
                            local currentWeight = tonumber(eggInstance:GetAttribute("Weight")) or 0
                            local displayWeight = currentWeight * weightRatio
                            local dist = math.floor((data.Position - root.Position).Magnitude)
                            data.Info.Text = string.format("%s  |  %.2fkg  |  %dm", data.Rarity, displayWeight, dist)
                        end
                    end
                end
            end
        end
    end,
})

v:Finalize({ Window = v2, MainTab = defaultTab, ShowMainTab = true })

-- ==========================================
-- 7. JAEII CUTE TITLE OVERRIDE 
-- ==========================================
task.spawn(function()
    for _ = 1, 15 do
        task.wait(0.5)
        for _, obj in ipairs(guiLocation:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Text:match("Chilli Hub") then
                obj.Text = obj.Text:gsub("Chilli Hub", "Jaeii Cute")
            end
        end
    end
end)

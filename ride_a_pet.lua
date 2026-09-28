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
-- 2. UI INITIALIZATION (Jaeii Cute Framework)
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

local v2 = v:CreateWindow({ Name = "Jaeii Cute", DefaultTab = "Farm" })
local defaultTab = v2:GetDefaultTab()

-- ==========================================
-- 3. GAME SERVICES & INITIAL SETUP
-- ==========================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local gameRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Game")
local activeEggs = ReplicatedStorage:WaitForChild("ServerData"):WaitForChild("ActiveEggs")

local function fn7(arg)
    local ok, result = pcall(function() return require(arg()) end)
    return ok and result or nil
end

local tbl = {
    Eggs = fn7(function() return ReplicatedStorage.GameData.Eggs end),
    EggBaskets = fn7(function() return ReplicatedStorage.GameData.EggBaskets end),
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
-- 4. UTILITIES & CONFIG DATA
-- ==========================================
local tbl3 = {}
local tbl5 = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Ethereal" }
tbl3.RarityRank = {}
for i, v5_item in ipairs(tbl5) do tbl3.RarityRank[v5_item] = i end

tbl3.RarityColors = {
    Common = Color3.fromRGB(214, 218, 228),
    Rare = Color3.fromRGB(96, 170, 255),
    Epic = Color3.fromRGB(190, 110, 255),
    Legendary = Color3.fromRGB(255, 196, 66),
    Mythic = Color3.fromRGB(255, 82, 90),
    Divine = Color3.fromRGB(255, 240, 150),
    Ethereal = Color3.fromRGB(125, 225, 255),
}

tbl3.Status = "Idle"

tbl3.Root = function()
    local character = localPlayer.Character
    character = character and character:FindFirstChild("HumanoidRootPart")
    if character and character:IsDescendantOf(workspace) then
        return character
    end
    return nil
end

tbl3.Plot = function()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, child in ipairs(plots:GetChildren()) do
        local data = child:FindFirstChild("Data")
        data = data and data:FindFirstChild("Owner")
        if data and data.Value == localPlayer then
            return child
        end
    end
    return nil
end

tbl3.PlotBase = function()
    local baseplate = tbl3.Plot()
    baseplate = baseplate and baseplate:FindFirstChild("Baseplate")
    if baseplate and baseplate:IsA("BasePart") then
        return baseplate
    end
    return nil
end

tbl3.PlotTop = function()
    local v6 = tbl3.PlotBase()
    if not v6 then return nil end
    return v6.Position + Vector3.new(0, v6.Size.Y / 2, 0)
end

tbl3.Fire = function(arg, ...)
    local v6 = gameRemote:FindFirstChild(arg)
    if not v6 or not v6:IsA("RemoteEvent") then return false end
    local v7 = table.pack(...)
    return pcall(function() v6:FireServer(table.unpack(v7, 1, v7.n)) end)
end

tbl3.EggData = function(arg)
    local eggs = tbl.Eggs
    local flag = type(eggs) == "table" and eggs[tostring(arg)] or nil
    return type(flag) == "table" and flag or nil
end

tbl3.EggRank = function(arg)
    local v6 = tbl3.EggData(arg)
    return v6 and tbl3.RarityRank[tostring(v6.Rarity)] or 0
end

tbl3.EggRarity = function(arg)
    local v6 = tbl3.EggData(arg)
    return v6 and tostring(v6.Rarity) or "Common"
end

tbl3.BasketCount = function()
    local basket = localPlayer:FindFirstChild("Basket")
    return basket and #basket:GetChildren() or 0
end

tbl3.BasketCapacity = function()
    local EquippedEggBasket = localPlayer:FindFirstChild("SavedData") and localPlayer.SavedData:FindFirstChild("EquippedEggBasket") and localPlayer.SavedData.EquippedEggBasket.Value
    local eggBaskets = tbl.EggBaskets
    local flag = type(eggBaskets) == "table" and EquippedEggBasket and eggBaskets[tostring(EquippedEggBasket)] or nil
    local n = type(flag) == "table" and tonumber(flag.Capacity) or 1
    return math.max(1, n > 50 and 50 or n)
end

-- ==========================================
-- 5. DYNAMIC RUNTIME AUTO-FARM & VOLCANO DIP
-- ==========================================
local farmSection = defaultTab:CreateSection({ Name = "Auto Collect & Volcano Dip", Expanded = true })

local volcanoPos = Vector3.new(-5117.2, 41405.4, -3480.0)
local autoCollectEnabled = false
local volcanoDipEnabled = false
local farmTargetRarities = {}
local tpDelay = 0.3

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

local function getBasketEggsList()
    local basket = localPlayer:FindFirstChild("Basket")
    local items = {}
    if basket then
        for _, child in ipairs(basket:GetChildren()) do
            local eggType = child:GetAttribute("Egg")
            if type(eggType) == "string" then
                table.insert(items, eggType)
            end
        end
    end
    return items
end

task.spawn(function()
    while task.wait(0.1) do
        if not autoCollectEnabled then continue end
        local root = tbl3.Root()
        if not root then continue end
        
        local basketEggs = getBasketEggsList()
        if #basketEggs > 0 and tbl3.BasketCount() >= tbl3.BasketCapacity() then
            local plotTop = tbl3.PlotTop()
            if plotTop then
                tbl3.Status = "Bringing eggs home"
                root.CFrame = CFrame.new(plotTop + Vector3.new(0, 4, 0))
                root.AssemblyLinearVelocity = Vector3.zero
                
                -- Delay only triggers if volcano dip is active
                task.wait(volcanoDipEnabled and 3.0 or tpDelay)
                
                for _, eggType in ipairs(basketEggs) do
                    tbl3.Fire("BasketDrop", eggType)
                end
                task.wait(0.5)
            end
            continue
        end
        
        local availableEggs = {}
        for _, child in ipairs(activeEggs:GetChildren()) do
            local eggName = child:GetAttribute("Egg")
            local eggPos = child:GetAttribute("Position")
            local privateTo = child:GetAttribute("PrivateTo")
            
            if type(eggName) == "string" and typeof(eggPos) == "Vector3" and (privateTo == nil or privateTo == localPlayer.UserId) then
                local rarityName = tbl3.EggRarity(eggName)
                if next(farmTargetRarities) == nil or farmTargetRarities[rarityName] then
                    table.insert(availableEggs, {
                        Instance = child,
                        Name = eggName,
                        Position = eggPos,
                        Rank = tbl3.EggRank(eggName),
                        Distance = (eggPos - root.Position).Magnitude
                    })
                end
            end
        end
        
        table.sort(availableEggs, function(a, b)
            if a.Rank ~= b.Rank then return a.Rank > b.Rank end
            return a.Distance < b.Distance
        end)
        
        if #availableEggs > 0 then
            local target = availableEggs[1]
            tbl3.Status = string.format("Collecting %s", target.Name)
            
            root.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
            root.AssemblyLinearVelocity = Vector3.zero
            task.wait(tpDelay)
            
            if target.Instance.Parent ~= nil then
                local prevCount = tbl3.BasketCount()
                tbl3.Fire("EggPickup", target.Instance.Name)
                
                local waitTimeout = os.clock() + 1.5
                while tbl3.BasketCount() == prevCount and os.clock() < waitTimeout do
                    RunService.Heartbeat:Wait()
                end
                
                if volcanoDipEnabled and volcanoPos ~= Vector3.zero and tbl3.BasketCount() > prevCount then
                    tbl3.Status = "Volcano Dipping..."
                    root.CFrame = CFrame.new(volcanoPos + Vector3.new(0, 5, 0))
                    root.AssemblyLinearVelocity = Vector3.zero
                    task.wait(tpDelay)
                    
                    ClickVolcanoDropUI()
                    task.wait(5.5) -- Mutation wait time
                    
                    local dippedEggId = nil
                    local scanTimer = 0
                    while not dippedEggId and scanTimer < 6.0 do
                        task.wait(0.2)
                        scanTimer += 0.2
                        for _, eggChild in ipairs(activeEggs:GetChildren()) do
                            local ePos = eggChild:GetAttribute("Position")
                            if ePos and Vector2.new(ePos.X - volcanoPos.X, ePos.Z - volcanoPos.Z).Magnitude < 50 then
                                dippedEggId = eggChild.Name
                                break
                            end
                        end
                    end
                    
                    if dippedEggId then
                        root.CFrame = CFrame.new(volcanoPos + Vector3.new(0, 3, 0))
                        root.AssemblyLinearVelocity = Vector3.zero
                        task.wait(1.0)
                        tbl3.Fire("EggPickup", dippedEggId)
                        task.wait(1.0)
                    end
                end
                
                if tbl3.BasketCount() > 0 then
                    local plotTop = tbl3.PlotTop()
                    if plotTop then
                        tbl3.Status = "Bringing eggs home"
                        root.CFrame = CFrame.new(plotTop + Vector3.new(0, 4, 0))
                        root.AssemblyLinearVelocity = Vector3.zero
                        
                        -- Delay only triggers if volcano dip is active
                        task.wait(volcanoDipEnabled and 3.0 or tpDelay)
                        
                        local remainingEggs = getBasketEggsList()
                        for _, eggType in ipairs(remainingEggs) do
                            tbl3.Fire("BasketDrop", eggType)
                        end
                        task.wait(0.5)
                    end
                end
            end
        else
            tbl3.Status = "No matching eggs found"
            task.wait(1)
        end
    end
end)

farmSection:CreateToggle({
    Name = "Auto Collect Eggs",
    Default = false,
    Callback = function(state)
        autoCollectEnabled = state
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
                if val == true and type(k) == "string" then farmTargetRarities[k] = true
                elseif type(val) == "string" then farmTargetRarities[val] = true end
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
-- 6. EGG ESP LOGIC (With Multi-Dropdown)
-- ==========================================
local espSection = defaultTab:CreateSection({ Name = "Egg ESP", Expanded = false })
local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
local espTargetRarities = {}
local espEnabled = false
local espFolder = nil
local eggTrackers = {}
local espConnections = {}

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
    local data = eggTrackers[child]
    if data then
        eggTrackers[child] = nil
        pcall(function() data.Gui:Destroy() end)
    end
end

local function addEsp(arg)
    if eggTrackers[arg] or not espFolder then return end
    local eggName = arg:GetAttribute("Egg")
    local eggPos = arg:GetAttribute("Position")
    if type(eggName) ~= "string" or typeof(eggPos) ~= "Vector3" then return end
    
    local privateTo = arg:GetAttribute("PrivateTo")
    if privateTo ~= nil and privateTo ~= localPlayer.UserId then return end
    
    local rarityName = tbl3.EggRarity(eggName)
    if next(espTargetRarities) ~= nil and not espTargetRarities[rarityName] then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = fn2()
    billboardGui.AlwaysOnTop = true
    billboardGui.LightInfluence = 0
    billboardGui.Size = UDim2.fromOffset(170, 46)
    billboardGui.Adornee = workspace.Terrain
    billboardGui.StudsOffsetWorldSpace = eggPos + Vector3.new(0, 4, 0)
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
    textLabel.Text = eggName
    textLabel.TextColor3 = tbl3.RarityColors[rarityName] or Color3.fromRGB(255, 255, 255)
    textLabel.Parent = frame
    
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Name = fn2()
    textLabel2.LayoutOrder = 2
    createStrokeText(textLabel2, 18)
    textLabel2.TextColor3 = Color3.fromRGB(230, 232, 240)
    textLabel2.Parent = frame
    
    billboardGui.Parent = espFolder
    eggTrackers[arg] = { Gui = billboardGui, Info = textLabel2, Rarity = rarityName, Position = eggPos }
end

local function clearAllEsp()
    for _, conn in ipairs(espConnections) do conn:Disconnect() end
    table.clear(espConnections)
    for k in pairs(eggTrackers) do removeEsp(k) end
    if espFolder then pcall(function() espFolder:Destroy() end); espFolder = nil end
end

local function initEsp()
    clearAllEsp()
    if not espEnabled then return end
    espFolder = Instance.new("Folder")
    espFolder.Name = fn2()
    espFolder.Parent = guiLocation
    
    for _, child in ipairs(activeEggs:GetChildren()) do addEsp(child) end
    table.insert(espConnections, activeEggs.ChildAdded:Connect(function(child) task.defer(addEsp, child) end))
    table.insert(espConnections, activeEggs.ChildRemoved:Connect(removeEsp))
    
    local timer = 0
    table.insert(espConnections, RunService.Heartbeat:Connect(function(dt)
        timer += dt
        if timer < 0.5 then return end
        timer = 0
        local root = tbl3.Root()
        if not root then return end
        for eggInstance, data in pairs(eggTrackers) do
            if eggInstance and eggInstance.Parent then
                local dist = math.floor((data.Position - root.Position).Magnitude)
                data.Info.Text = string.format("%s  |  %dm", data.Rarity, dist)
            end
        end
    end))
end

espSection:CreateToggle({
    Name = "Enable Egg ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then initEsp() else clearAllEsp() end
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
                if val == true and type(k) == "string" then espTargetRarities[k] = true
                elseif type(val) == "string" then espTargetRarities[val] = true end
            end
        end
        if espEnabled then initEsp() end
    end,
})

v:Finalize({ Window = v2, MainTab = defaultTab, ShowMainTab = true })

-- ==========================================
-- 7. TITLE PATCH OVERRIDE ("Jaeii Cute")
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

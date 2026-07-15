--[[
    FLGΞAR v7.0 | FTAP Script
    Style: Like Blitz | Premium Features
    Hotkeys: M (menu) | - (minimize)
    GitHub: https://github.com/the2zews/FLGEAR
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")

-- ============================================================
-- CONFIG
-- ============================================================

local CONFIG = {
    Power = 5000,
    Mode = "Explosion",
    Range = 30,
    ESP = true,
    Aura = true,
    AntiFling = true,
    AutoFling = false,
    Whitelist = {},
    Silent = false
}

-- ============================================================
-- SAVE / LOAD
-- ============================================================

local CONFIG_PATH = "FLGEAR_Config.json"

local function saveConfig()
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_PATH, game:GetService("HttpService"):JSONEncode(CONFIG))
    end)
end

local function loadConfig()
    if not readfile then return end
    pcall(function()
        local content = readfile(CONFIG_PATH)
        if content and content ~= "" then
            local data = game:GetService("HttpService"):JSONDecode(content)
            for k, v in pairs(CONFIG) do
                if data[k] ~= nil then
                    CONFIG[k] = data[k]
                end
            end
        end
    end)
end

loadConfig()

-- ============================================================
-- BLITZ STYLE COLORS (Grey/Dark Theme)
-- ============================================================

local COLORS = {
    Background = Color3.fromHex("1a1a1a"),
    Panel = Color3.fromHex("2a2a2a"),
    PanelLight = Color3.fromHex("3a3a3a"),
    Primary = Color3.fromHex("4a9eff"),
    PrimaryDark = Color3.fromHex("3a7acc"),
    Text = Color3.fromHex("ffffff"),
    TextDim = Color3.fromHex("888888"),
    Border = Color3.fromHex("3a3a3a"),
    Success = Color3.fromHex("4caf50"),
    Danger = Color3.fromHex("f44336"),
    Glow = Color3.fromHex("4a9eff")
}

-- ============================================================
-- UI HELPERS
-- ============================================================

local function round(frame, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = frame
end

local function stroke(frame, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.Border
    s.Thickness = thickness or 1
    s.Parent = frame
end

-- ============================================================
-- ANIMATION (FLGΞAR + lightning)
-- ============================================================

local function showAnimation()
    local screen = Instance.new("ScreenGui")
    screen.Name = "FLGEAR_Animation"
    screen.Parent = LP.PlayerGui
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromHex("0d0d0d")
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel = 0
    bg.Parent = screen

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 450, 0, 100)
    container.Position = UDim2.new(0.5, -225, 0.5, -50)
    container.BackgroundTransparency = 1
    container.Parent = screen

    -- FLGΞAR with lightning
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 0, 65)
    logo.Position = UDim2.new(0, 0, 0, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "FLGΞAR ⚡"
    logo.TextColor3 = Color3.fromHex("ffffff")
    logo.TextTransparency = 1
    logo.TextScaled = true
    logo.Font = Enum.Font.GothamBold
    logo.Parent = container

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 25)
    sub.Position = UDim2.new(0, 0, 0, 70)
    sub.BackgroundTransparency = 1
    sub.Text = "PREMIUM FTAP v7.0"
    sub.TextColor3 = COLORS.TextDim
    sub.TextTransparency = 1
    sub.TextScaled = true
    sub.Font = Enum.Font.Gotham
    sub.Parent = container

    -- Animation sequence
    local t1 = TweenService:Create(logo, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    t1:Play()

    task.wait(0.4)
    local t2 = TweenService:Create(sub, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    t2:Play()

    task.wait(2.5)

    local t3 = TweenService:Create(logo, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    t3:Play()

    local t4 = TweenService:Create(sub, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    t4:Play()

    local t5 = TweenService:Create(bg, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    t5:Play()

    task.wait(1)
    screen:Destroy()
    createUI()
    toggleUI(true)
end

-- ============================================================
-- ESP
-- ============================================================

local espHighlights = {}

local function updateESP()
    for _, h in pairs(espHighlights) do
        pcall(function() h:Destroy() end)
    end
    espHighlights = {}
    if not CONFIG.ESP then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = Instance.new("Highlight")
            h.FillColor = COLORS.Primary
            h.FillTransparency = 0.35
            h.OutlineColor = COLORS.Primary
            h.OutlineTransparency = 0.2
            h.DepthMode = Enum.HighlightDepthMode.Occluded
            h.Adornee = plr.Character
            h.Parent = plr.Character
            table.insert(espHighlights, h)
        end
    end
end

Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)

-- ============================================================
-- AURA
-- ============================================================

local auraAttachment = nil
local auraParticle = nil

local function createAura()
    if auraParticle then
        pcall(function()
            auraParticle:Destroy()
            auraAttachment:Destroy()
        end)
        auraParticle = nil
        auraAttachment = nil
    end
    if not CONFIG.Aura or not Char then return end
    auraAttachment = Instance.new("Attachment")
    auraAttachment.Name = "FLGEAR_Aura"
    auraAttachment.Parent = Root
    auraParticle = Instance.new("ParticleEmitter")
    auraParticle.Texture = "rbxassetid://4746973818"
    auraParticle.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.Primary),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("6ab0ff")),
        ColorSequenceKeypoint.new(1, COLORS.PrimaryDark)
    })
    auraParticle.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(0.5, 5),
        NumberSequenceKeypoint.new(1, 2)
    })
    auraParticle.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.4),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    auraParticle.Lifetime = NumberRange.new(1.5, 3)
    auraParticle.Rate = 15
    auraParticle.Rotation = NumberRange.new(0, 360)
    auraParticle.SpreadAngle = Vector2.new(360, 360)
    auraParticle.Velocity = NumberRange.new(2, 6)
    auraParticle.Parent = auraAttachment
end

LP.CharacterAdded:Connect(function(c)
    Char = c
    Root = c:WaitForChild("HumanoidRootPart")
    task.wait(0.3)
    createAura()
end)

createAura()

-- ============================================================
-- ANTI-FLING
-- ============================================================

if CONFIG.AntiFling and hookfunction then
    local old = hookfunction(getrawmetatable(game).__namecall, newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self.Name and self.Name:match("AntiFling|Kick|Grab|Ban") then
            return nil
        end
        return old(self, ...)
    end))
end

-- ============================================================
-- PLAYER LIST
-- ============================================================

local listFrame = nil

local function updatePlayerList(parent)
    if listFrame then
        pcall(function() listFrame:Destroy() end)
        listFrame = nil
    end
    if not parent then return end
    listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0.9, 0, 0, 120)
    listFrame.Position = UDim2.new(0.05, 0, 0, 10)
    listFrame.BackgroundColor3 = COLORS.Panel
    listFrame.BackgroundTransparency = 0.5
    listFrame.BorderSizePixel = 0
    listFrame.Parent = parent
    round(listFrame, 6)
    stroke(listFrame, COLORS.Border, 0.5)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -10)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = COLORS.Primary
    scroll.Parent = listFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.Parent = scroll

    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.45, 0, 0, 22)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.BackgroundColor3 = COLORS.PanelLight
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Text = plr.Name .. (table.find(CONFIG.Whitelist, plr.Name) and " ★" or "")
            btn.TextColor3 = COLORS.Text
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.Parent = scroll
            round(btn, 4)
            btn.MouseButton1Click:Connect(function()
                local idx = table.find(CONFIG.Whitelist, plr.Name)
                if idx then
                    table.remove(CONFIG.Whitelist, idx)
                    btn.Text = plr.Name
                else
                    table.insert(CONFIG.Whitelist, plr.Name)
                    btn.Text = plr.Name .. " ★"
                end
                saveConfig()
            end)
            btn.MouseButton2Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    Root.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end)
            y = y + 25
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- ============================================================
-- MAIN UI (BLITZ STYLE)
-- ============================================================

local gui = nil
local mainFrame = nil
local blur = nil
local uiVisible = false
local uiMinimized = false
local isClosed = false

local function toggleUI(show)
    if isClosed then return end
    uiVisible = (show ~= nil) and show or not uiVisible
    if not gui or not mainFrame then return end
    if uiVisible and not uiMinimized then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.92
        }):Play()
        if blur then
            TweenService:Create(blur, TweenInfo.new(0.25), {Size = 10}):Play()
        end
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
        if blur then
            TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()
        end
        task.wait(0.2)
        mainFrame.Visible = false
    end
end

local function minimizeUI()
    if isClosed then return end
    uiMinimized = true
    uiVisible = false
    if mainFrame then
        mainFrame.Visible = false
        if blur then
            TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()
        end
    end
end

local function closeUI()
    isClosed = true
    uiVisible = false
    uiMinimized = false
    if gui then
        pcall(function() gui:Destroy() end)
        gui = nil
        mainFrame = nil
    end
    if blur then
        pcall(function() blur:Destroy() end)
        blur = nil
    end
end

local function createUI()
    if gui then
        pcall(function() gui:Destroy() end)
        gui = nil
        mainFrame = nil
    end
    isClosed = false
    uiMinimized = false
    uiVisible = true

    gui = Instance.new("ScreenGui")
    gui.Name = "FLGEAR_UI"
    gui.Parent = LP.PlayerGui
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = game:GetService("Lighting")

    -- Main Frame
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = COLORS.Background
    mainFrame.BackgroundTransparency = 0.92
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    round(mainFrame, 10)
    stroke(mainFrame, COLORS.Border, 1)

    -- ===== TITLE BAR (Blitz style) =====
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = COLORS.Panel
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    round(titleBar, 10)

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "FLGΞAR ⚡ v7.0"
    title.TextColor3 = COLORS.Text
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    -- Minimize button (-)
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -60, 0, 2)
    minBtn.BackgroundColor3 = COLORS.PanelLight
    minBtn.BackgroundTransparency = 0.2
    minBtn.BorderSizePixel = 0
    minBtn.Text = "−"
    minBtn.TextColor3 = COLORS.Text
    minBtn.TextScaled = true
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = titleBar
    round(minBtn, 4)
    minBtn.MouseButton1Click:Connect(minimizeUI)

    -- Close button (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -32, 0, 2)
    closeBtn.BackgroundColor3 = COLORS.PanelLight
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = COLORS.Danger
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    round(closeBtn, 4)
    closeBtn.MouseButton1Click:Connect(closeUI)

    -- ===== TABS (Blitz style) =====
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 32)
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.BackgroundColor3 = COLORS.Panel
    tabContainer.BackgroundTransparency = 0.5
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    local tabs = {"Fling", "Visuals", "Players", "Beta"}
    local tabButtons = {}
    local currentTab = 1

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.25, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
        btn.BackgroundColor3 = (i == 1) and COLORS.Primary or COLORS.Primary
        btn.BackgroundTransparency = (i == 1) and 0.3 or 0.9
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = (i == 1) and COLORS.Text or COLORS.TextDim
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tabContainer
        btn.MouseButton1Click:Connect(function()
            currentTab = i
            for _, b in pairs(tabButtons) do
                b.BackgroundTransparency = 0.9
                b.TextColor3 = COLORS.TextDim
            end
            btn.BackgroundTransparency = 0.3
            btn.TextColor3 = COLORS.Text
            switchTab(i)
        end)
        table.insert(tabButtons, btn)
    end

    -- ===== CONTENT CONTAINER =====
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, -67)
    contentContainer.Position = UDim2.new(0, 0, 0, 67)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

    -- ===== TAB 1: FLING =====
    local tab1 = Instance.new("Frame")
    tab1.Size = UDim2.new(1, 0, 1, 0)
    tab1.BackgroundTransparency = 1
    tab1.Parent = contentContainer

    -- Stats
    local stats = Instance.new("TextLabel")
    stats.Size = UDim2.new(1, -20, 0, 26)
    stats.Position = UDim2.new(0, 10, 0, 8)
    stats.BackgroundColor3 = COLORS.Panel
    stats.BackgroundTransparency = 0.4
    stats.Text = CONFIG.Mode .. "  •  " .. CONFIG.Power .. "  •  R" .. CONFIG.Range
    stats.TextColor3 = COLORS.Text
    stats.TextScaled = true
    stats.Font = Enum.Font.Gotham
    stats.Parent = tab1
    round(stats, 4)

    -- Modes
    local modes = {"Explosion", "Push", "Vortex"}
    local modeBtns = {}
    for i, m in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.28, 0, 0, 28)
        btn.Position = UDim2.new(0.03 + (i-1) * 0.34, 0, 0, 44)
        btn.BackgroundColor3 = (m == CONFIG.Mode) and COLORS.Primary or COLORS.Panel
        btn.BackgroundTransparency = (m == CONFIG.Mode) and 0.3 or 0.4
        btn.BorderSizePixel = 0
        btn.Text = m
        btn.TextColor3 = (m == CONFIG.Mode) and COLORS.Text or COLORS.TextDim
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tab1
        round(btn, 4)
        btn.MouseButton1Click:Connect(function()
            CONFIG.Mode = m
            for _, b in pairs(modeBtns) do
                b.BackgroundTransparency = 0.4
                b.TextColor3 = COLORS.TextDim
            end
            btn.BackgroundTransparency = 0.3
            btn.TextColor3 = COLORS.Text
            stats.Text = m .. "  •  " .. CONFIG.Power .. "  •  R" .. CONFIG.Range
            saveConfig()
        end)
        table.insert(modeBtns, btn)
    end

    -- Power Slider
    local pLabel = Instance.new("TextLabel")
    pLabel.Size = UDim2.new(0.6, 0, 0, 20)
    pLabel.Position = UDim2.new(0.05, 0, 0, 82)
    pLabel.BackgroundTransparency = 1
    pLabel.Text = "POWER: " .. CONFIG.Power
    pLabel.TextColor3 = COLORS.Text
    pLabel.TextScaled = true
    pLabel.Font = Enum.Font.Gotham
    pLabel.TextXAlignment = Enum.TextXAlignment.Left
    pLabel.Parent = tab1

    local pSlider = Instance.new("Frame")
    pSlider.Size = UDim2.new(0.85, 0, 0, 4)
    pSlider.Position = UDim2.new(0.075, 0, 0, 104)
    pSlider.BackgroundColor3 = COLORS.Panel
    pSlider.BackgroundTransparency = 0.3
    pSlider.Parent = tab1
    round(pSlider, 2)

    local pFill = Instance.new("Frame")
    pFill.Size = UDim2.new((CONFIG.Power - 1000) / 14000, 0, 1, 0)
    pFill.BackgroundColor3 = COLORS.Primary
    pFill.Parent = pSlider
    round(pFill, 2)

    local draggingP = false
    pSlider.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingP = true end
    end)
    pSlider.InputEnded:Connect(function()
        draggingP = false
        saveConfig()
    end)
    pSlider.InputChanged:Connect(function(i)
        if draggingP and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - pSlider.AbsolutePosition.X) / pSlider.AbsoluteSize.X, 0, 1)
            CONFIG.Power = math.round(1000 + p * 14000)
            pLabel.Text = "POWER: " .. CONFIG.Power
            stats.Text = CONFIG.Mode .. "  •  " .. CONFIG.Power .. "  •  R" .. CONFIG.Range
            pFill.Size = UDim2.new(p, 0, 1, 0)
        end
    end)

    -- Range Slider
    local rLabel = Instance.new("TextLabel")
    rLabel.Size = UDim2.new(0.6, 0, 0, 20)
    rLabel.Position = UDim2.new(0.05, 0, 0, 122)
    rLabel.BackgroundTransparency = 1
    rLabel.Text = "RANGE: " .. CONFIG.Range
    rLabel.TextColor3 = COLORS.Text
    rLabel.TextScaled = true
    rLabel.Font = Enum.Font.Gotham
    rLabel.TextXAlignment = Enum.TextXAlignment.Left
    rLabel.Parent = tab1

    local rSlider = Instance.new("Frame")
    rSlider.Size = UDim2.new(0.85, 0, 0, 4)
    rSlider.Position = UDim2.new(0.075, 0, 0, 144)
    rSlider.BackgroundColor3 = COLORS.Panel
    rSlider.BackgroundTransparency = 0.3
    rSlider.Parent = tab1
    round(rSlider, 2)

    local rFill = Instance.new("Frame")
    rFill.Size = UDim2.new((CONFIG.Range - 10) / 50, 0, 1, 0)
    rFill.BackgroundColor3 = COLORS.Primary
    rFill.Parent = rSlider
    round(rFill, 2)

    local draggingR = false
    rSlider.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingR = true end
    end)
    rSlider.InputEnded:Connect(function()
        draggingR = false
        saveConfig()
    end)
    rSlider.InputChanged:Connect(function(i)
        if draggingR and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - rSlider.AbsolutePosition.X) / rSlider.AbsoluteSize.X, 0, 1)
            CONFIG.Range = math.round(10 + p * 50)
            rLabel.Text = "RANGE: " .. CONFIG.Range
            stats.Text = CONFIG.Mode .. "  •  " .. CONFIG.Power .. "  •  R" .. CONFIG.Range
            rFill.Size = UDim2.new(p, 0, 1, 0)
        end
    end)

    -- AutoFling Toggle
    local afFrame = Instance.new("Frame")
    afFrame.Size = UDim2.new(0.5, 0, 0, 24)
    afFrame.Position = UDim2.new(0.05, 0, 0, 160)
    afFrame.BackgroundTransparency = 1
    afFrame.Parent = tab1

    local afLabel = Instance.new("TextLabel")
    afLabel.Size = UDim2.new(0.5, 0, 1, 0)
    afLabel.BackgroundTransparency = 1
    afLabel.Text = "AUTO FLING"
    afLabel.TextColor3 = COLORS.Text
    afLabel.TextScaled = true
    afLabel.Font = Enum.Font.Gotham
    afLabel.TextXAlignment = Enum.TextXAlignment.Left
    afLabel.Parent = afFrame

    local afCheck = Instance.new("ImageLabel")
    afCheck.Size = UDim2.new(0, 16, 0, 16)
    afCheck.Position = UDim2.new(0.7, 0, 0, 4)
    afCheck.BackgroundColor3 = COLORS.Panel
    afCheck.Image = "rbxassetid://3926305904"
    afCheck.ImageColor3 = CONFIG.AutoFling and COLORS.Primary or COLORS.TextDim
    afCheck.ScaleType = Enum.ScaleType.Fit
    afCheck.Parent = afFrame
    round(afCheck, 3)

    afFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            CONFIG.AutoFling = not CONFIG.AutoFling
            afCheck.ImageColor3 = CONFIG.AutoFling and COLORS.Primary or COLORS.TextDim
            saveConfig()
        end
    end)

    -- ===== TAB 2: VISUALS =====
    local tab2 = Instance.new("Frame")
    tab2.Size = UDim2.new(1, 0, 1, 0)
    tab2.BackgroundTransparency = 1
    tab2.Visible = false
    tab2.Parent = contentContainer

    local visualToggles = {
        {name = "ESP", key = "ESP"},
        {name = "Aura", key = "Aura"},
        {name = "ANTI-FLING", key = "AntiFling"}
    }

    for i, t in ipairs(visualToggles) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.5, 0, 0, 24)
        frame.Position = UDim2.new(0.05 + ((i-1) % 2) * 0.45, 0, 0, 10 + math.floor((i-1)/2) * 32)
        frame.BackgroundTransparency = 1
        frame.Parent = tab2

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = t.name
        label.TextColor3 = COLORS.Text
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local check = Instance.new("ImageLabel")
        check.Size = UDim2.new(0, 16, 0, 16)
        check.Position = UDim2.new(0.7, 0, 0, 4)
        check.BackgroundColor3 = COLORS.Panel
        check.Image = "rbxassetid://3926305904"
        check.ImageColor3 = CONFIG[t.key] and COLORS.Primary or COLORS.TextDim
        check.ScaleType = Enum.ScaleType.Fit
        check.Parent = frame
        round(check, 3)

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                CONFIG[t.key] = not CONFIG[t.key]
                check.ImageColor3 = CONFIG[t.key] and COLORS.Primary or COLORS.TextDim
                if t.key == "ESP" then updateESP() end
                if t.key == "Aura" then createAura() end
                saveConfig()
            end
        end)
    end

    -- ===== TAB 3: PLAYERS =====
    local tab3 = Instance.new("Frame")
    tab3.Size = UDim2.new(1, 0, 1, 0)
    tab3.BackgroundTransparency = 1
    tab3.Visible = false
    tab3.Parent = contentContainer

    updatePlayerList(tab3)

    -- ===== TAB 4: BETA =====
    local tab4 = Instance.new("Frame")
    tab4.Size = UDim2.new(1, 0, 1, 0)
    tab4.BackgroundTransparency = 1
    tab4.Visible = false
    tab4.Parent = contentContainer

    -- Beta features (marked with small text)
    local betaFeatures = {
        {name = "Silent Aim", status = "Beta"},
        {name = "Auto Teleport", status = "Beta"},
        {name = "Spin Fling", status = "Beta"},
        {name = "Multi Fling", status = "Beta"}
    }

    for i, feat in ipairs(betaFeatures) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.9, 0, 0, 28)
        frame.Position = UDim2.new(0.05, 0, 0, 10 + (i-1) * 34)
        frame.BackgroundColor3 = COLORS.Panel
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = tab4
        round(frame, 4)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = feat.name
        label.TextColor3 = COLORS.Text
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local betaTag = Instance.new("TextLabel")
        betaTag.Size = UDim2.new(0.2, 0, 1, 0)
        betaTag.Position = UDim2.new(0.7, 0, 0, 0)
        betaTag.BackgroundTransparency = 1
        betaTag.Text = "BETA"
        betaTag.TextColor3 = COLORS.TextDim
        betaTag.TextScaled = true
        betaTag.Font = Enum.Font.Gotham
        betaTag.TextXAlignment = Enum.TextXAlignment.Right
        betaTag.Parent = frame
    end

    -- ===== TAB SWITCHER =====
    function switchTab(tabIndex)
        local tabs_frames = {tab1, tab2, tab3, tab4}
        for i, frame in pairs(tabs_frames) do
            frame.Visible = (i == tabIndex)
        end
    end

    switchTab(1)

    -- ===== DRAG (Blitz style - drag by title bar) =====
    local drag = false
    local dragStart, startPos

    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dragStart = i.Position
            startPos = mainFrame.Position
        end
    end)

    titleBar.InputEnded:Connect(function() drag = false end)

    titleBar.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    mainFrame.Visible = false
end

-- ============================================================
-- PHYSICS
-- ============================================================

local function isWhitelisted(plr)
    return table.find(CONFIG.Whitelist, plr.Name) ~= nil
end

local function getTargets()
    local list = {}
    local pos = Root.Position
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and not isWhitelisted(plr) and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - pos).Magnitude
                if dist <= CONFIG.Range then
                    table.insert(list, plr.Character)
                end
            end
        end
    end
    return list
end

local function flingTarget(target)
    local root = target:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if CONFIG.Mode == "Explosion" then
        local e = Instance.new("Explosion")
        e.Position = root.Position + Vector3.new(0, 2, 0)
        e.BlastRadius = 5
        e.BlastPressure = CONFIG.Power / 50
        e.DestroyJointRadiusPercent = 0
        e.Parent = workspace
        task.defer(function() e:Destroy() end)
    elseif CONFIG.Mode == "Push" then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = (root.Position - Root.Position).Unit * CONFIG.Power
        bv.Parent = root
        task.defer(function()
            task.wait(0.05)
            bv:Destroy()
        end)
    elseif CONFIG.Mode == "Vortex" then
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bp.Position = Root.Position + Vector3.new(0, 30, 0)
        bp.P = 3000
        bp.D = 500
        bp.Parent = root
        task.defer(function()
            task.wait(0.15)
            bp:Destroy()
            root.Velocity = Vector3.new(0, CONFIG.Power * 0.8, 0)
        end)
    end
end

local frameCount = 0
RunService.Stepped:Connect(function()
    frameCount = frameCount + 1
    if frameCount % 2 ~= 0 then return end
    if not Char or not Root then return end

    local targets = getTargets()
    if CONFIG.AutoFling then
        for _, t in pairs(targets) do
            flingTarget(t)
        end
    else
        local closest = nil
        local cd = math.huge
        local pos = Root.Position
        for _, t in pairs(targets) do
            local root = t:FindFirstChild("HumanoidRootPart")
            if root then
                local d = (root.Position - pos).Magnitude
                if d < cd then
                    cd = d
                    closest = t
                end
            end
        end
        if closest then
            flingTarget(closest)
        end
    end
end)

-- ============================================================
-- HOTKEYS (M = menu, - = minimize)
-- ============================================================

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.M then
        if isClosed then
            createUI()
            toggleUI(true)
        elseif uiMinimized then
            uiMinimized = false
            toggleUI(true)
        else
            toggleUI()
        end
    end

    if input.KeyCode == Enum.KeyCode.Minus then
        minimizeUI()
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================

showAnimation()

print("========================================")
print("  FLGΞAR v7.0 loaded")
print("  Mode: " .. CONFIG.Mode)
print("  Power: " .. CONFIG.Power)
print("  [M] Menu | [-] Minimize")
print("========================================")

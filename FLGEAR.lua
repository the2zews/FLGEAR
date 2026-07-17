--[[
    FLGΞAR ULTIMATE v9.0 (Full)
    Premium FTAP Script | Blitz Style UI
    Features: ESP | Aura | Anti-Fling | Auto Fling | Whitelist | Teleport | Save Config
    Hotkey: M (menu)
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
    Theme = "Violet",
    Silent = false
}

-- ============================================================
-- SAVE / LOAD (writefile for Solara)
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
                if data[k] ~= nil then CONFIG[k] = data[k] end
            end
        end
    end)
end

loadConfig()

-- ============================================================
-- THEMES
-- ============================================================

local THEMES = {
    Violet = {Primary = Color3.fromHex("7a6085"), Light = Color3.fromHex("a080b5"), Glow = Color3.fromHex("b090c5"), Dark = Color3.fromHex("1a1420")},
    Blue = {Primary = Color3.fromHex("3b82f6"), Light = Color3.fromHex("60a5fa"), Glow = Color3.fromHex("93c5fd"), Dark = Color3.fromHex("1e293b")},
    Red = {Primary = Color3.fromHex("ef4444"), Light = Color3.fromHex("f87171"), Glow = Color3.fromHex("fca5a5"), Dark = Color3.fromHex("1f1a1a")},
    Green = {Primary = Color3.fromHex("22c55e"), Light = Color3.fromHex("4ade80"), Glow = Color3.fromHex("86efac"), Dark = Color3.fromHex("1a1f1a")},
    Gold = {Primary = Color3.fromHex("eab308"), Light = Color3.fromHex("facc15"), Glow = Color3.fromHex("fde047"), Dark = Color3.fromHex("1f1c1a")},
    Pink = {Primary = Color3.fromHex("ec4899"), Light = Color3.fromHex("f472b6"), Glow = Color3.fromHex("f9a8d4"), Dark = Color3.fromHex("1f1a1e")}
}

local function getColors()
    return THEMES[CONFIG.Theme] or THEMES.Violet
end

-- ============================================================
-- UI HELPERS
-- ============================================================

local function round(frame, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = frame
end

local function stroke(frame, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or getColors().Primary
    s.Thickness = thickness or 1
    s.Parent = frame
end

local function applyGradient(frame, color1, color2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or getColors().Dark),
        ColorSequenceKeypoint.new(1, color2 or getColors().Primary)
    })
    g.Rotation = rotation or 45
    g.Parent = frame
end

-- ============================================================
-- NOTIFICATIONS
-- ============================================================

local notifContainer = nil

local function showNotification(text, color, duration)
    if CONFIG.Silent then return end
    if not notifContainer then
        notifContainer = Instance.new("ScreenGui")
        notifContainer.Name = "FLGEAR_Notifs"
        notifContainer.Parent = LP.PlayerGui
        notifContainer.ResetOnSpawn = false
    end
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 40)
    frame.Position = UDim2.new(1, 320, 0, 10)
    frame.BackgroundColor3 = getColors().Dark
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = notifContainer
    round(frame, 8)
    stroke(frame, color or getColors().Primary, 1)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromHex("ffffff")
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -310, 0, 10)
    }):Play()
    task.wait(duration or 3)
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 320, 0, 10)
    }):Play()
    task.wait(0.3)
    frame:Destroy()
end

-- ============================================================
-- ESP (Player Highlight)
-- ============================================================

local espHighlights = {}

local function updateESP()
    for _, h in pairs(espHighlights) do
        pcall(function() h:Destroy() end)
    end
    espHighlights = {}
    if not CONFIG.ESP then return end
    local colors = getColors()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = Instance.new("Highlight")
            h.FillColor = colors.Primary
            h.FillTransparency = 0.3
            h.OutlineColor = colors.Glow
            h.OutlineTransparency = 0
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
    local colors = getColors()
    auraAttachment = Instance.new("Attachment")
    auraAttachment.Name = "FLGEAR_Aura"
    auraAttachment.Parent = Root
    auraParticle = Instance.new("ParticleEmitter")
    auraParticle.Texture = "rbxassetid://4746973818"
    auraParticle.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors.Primary),
        ColorSequenceKeypoint.new(0.5, colors.Light),
        ColorSequenceKeypoint.new(1, colors.Glow)
    })
    auraParticle.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(0.5, 5),
        NumberSequenceKeypoint.new(1, 2)
    })
    auraParticle.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.3),
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
-- PLAYER LIST (Whitelist + Teleport)
-- ============================================================

local listFrame = nil

local function updatePlayerList(parent)
    if listFrame then
        pcall(function() listFrame:Destroy() end)
        listFrame = nil
    end
    if not parent then return end
    local colors = getColors()
    listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0.9, 0, 0, 120)
    listFrame.Position = UDim2.new(0.05, 0, 0, 10)
    listFrame.BackgroundColor3 = colors.Dark
    listFrame.BackgroundTransparency = 0.5
    listFrame.BorderSizePixel = 0
    listFrame.Parent = parent
    round(listFrame, 8)
    stroke(listFrame, colors.Primary, 0.5)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -10)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = colors.Primary
    scroll.Parent = listFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.Parent = scroll
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.45, 0, 0, 24)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.BackgroundColor3 = colors.Primary
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Text = plr.Name .. (table.find(CONFIG.Whitelist, plr.Name) and " ★" or "")
            btn.TextColor3 = Color3.fromHex("ffffff")
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.Parent = scroll
            round(btn, 4)
            btn.MouseButton1Click:Connect(function()
                local idx = table.find(CONFIG.Whitelist, plr.Name)
                if idx then
                    table.remove(CONFIG.Whitelist, idx)
                    btn.Text = plr.Name
                    showNotification("Removed " .. plr.Name .. " from whitelist")
                else
                    table.insert(CONFIG.Whitelist, plr.Name)
                    btn.Text = plr.Name .. " ★"
                    showNotification("Added " .. plr.Name .. " to whitelist")
                end
                saveConfig()
            end)
            btn.MouseButton2Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    Root.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    showNotification("Teleported to " .. plr.Name)
                end
            end)
            y = y + 27
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- ============================================================
-- PREMIUM INTRO ANIMATION
-- ============================================================

local function playIntro()
    local screen = Instance.new("ScreenGui")
    screen.Name = "FLGEAR_Intro"
    screen.Parent = LP.PlayerGui
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromHex("0a0810")
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel = 0
    bg.Parent = screen

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 450, 0, 100)
    container.Position = UDim2.new(0.5, -225, 0.5, -50)
    container.BackgroundTransparency = 1
    container.Parent = screen

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
    sub.Text = "PREMIUM FTAP v9.0"
    sub.TextColor3 = getColors().Light
    sub.TextTransparency = 1
    sub.TextScaled = true
    sub.Font = Enum.Font.Gotham
    sub.Parent = container

    TweenService:Create(logo, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    task.wait(0.4)
    TweenService:Create(sub, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    task.wait(2.5)

    TweenService:Create(logo, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()

    TweenService:Create(sub, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()

    TweenService:Create(bg, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()

    task.wait(1)
    screen:Destroy()
end

-- ============================================================
-- MAIN UI (BLITZ STYLE)
-- ============================================================

local gui = nil
local mainFrame = nil
local blur = nil
local uiVisible = false

local function toggleUI(show)
    uiVisible = (show ~= nil) and show or not uiVisible
    if not gui or not mainFrame then return end
    local colors = getColors()
    if uiVisible then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.92,
            Size = UDim2.new(0, 420, 0, 520)
        }):Play()
        if blur then
            TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Size = 12
            }):Play()
        end
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 400, 0, 500)
        }):Play()
        if blur then
            TweenService:Create(blur, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Size = 0
            }):Play()
        end
        task.wait(0.25)
        mainFrame.Visible = false
    end
end

local function createUI()
    if gui then
        pcall(function() gui:Destroy() end)
        gui = nil
        mainFrame = nil
    end
    local colors = getColors()

    gui = Instance.new("ScreenGui")
    gui.Name = "FLGEAR_UI"
    gui.Parent = LP.PlayerGui
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    blur = Instance.new("BlurEffect")
    blur.Size = 12
    blur.Parent = game:GetService("Lighting")

    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 520)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
    mainFrame.BackgroundColor3 = colors.Dark
    mainFrame.BackgroundTransparency = 0.92
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    round(mainFrame, 14)
    applyGradient(mainFrame, colors.Dark, colors.Primary, 45)

    -- Border
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderColor3 = colors.Primary
    border.BorderSizePixel = 2
    border.Parent = mainFrame
    round(border, 14)

    -- TITLE BAR
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = colors.Primary
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    round(titleBar, 14)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "FLGΞAR ⚡ v9.0"
    title.TextColor3 = Color3.fromHex("ffffff")
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.3, 0, 0, 20)
    status.Position = UDim2.new(0.7, 0, 0, 10)
    status.BackgroundTransparency = 1
    status.Text = "● ONLINE"
    status.TextColor3 = Color3.fromHex("00ff88")
    status.TextScaled = true
    status.Font = Enum.Font.GothamBold
    status.TextXAlignment = Enum.TextXAlignment.Right
    status.Parent = titleBar

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -38, 0, 4)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromHex("ffffff")
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        if blur then blur:Destroy() end
    end)

    -- TABS
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = colors.Primary
    tabContainer.BackgroundTransparency = 0.5
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    local tabs = {"Fling", "Visuals", "Players", "Settings"}
    local tabButtons = {}
    local currentTab = 1
    local tabFrames = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.25, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
        btn.BackgroundColor3 = (i == 1) and colors.Primary or colors.Primary
        btn.BackgroundTransparency = (i == 1) and 0.2 or 0.8
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = (i == 1) and Color3.fromHex("ffffff") or Color3.fromHex("888888")
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tabContainer
        btn.MouseButton1Click:Connect(function()
            currentTab = i
            for _, b in pairs(tabButtons) do
                b.BackgroundTransparency = 0.8
                b.TextColor3 = Color3.fromHex("888888")
            end
            btn.BackgroundTransparency = 0.2
            btn.TextColor3 = Color3.fromHex("ffffff")
            for j, frame in pairs(tabFrames) do
                frame.Visible = (j == i)
            end
        end)
        table.insert(tabButtons, btn)
    end

    -- CONTENT
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -75)
    content.Position = UDim2.new(0, 0, 0, 75)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame

    -- TAB 1: FLING
    local tab1 = Instance.new("Frame")
    tab1.Size = UDim2.new(1, 0, 1, 0)
    tab1.BackgroundTransparency = 1
    tab1.Parent = content
    table.insert(tabFrames, tab1)

    local stats = Instance.new("TextLabel")
    stats.Size = UDim2.new(1, -20, 0, 28)
    stats.Position = UDim2.new(0, 10, 0, 10)
    stats.BackgroundColor3 = colors.Primary
    stats.BackgroundTransparency = 0.3
    stats.Text = CONFIG.Mode .. "  •  " .. CONFIG.Power .. "  •  R" .. CONFIG.Range
    stats.TextColor3 = Color3.fromHex("ffffff")
    stats.TextScaled = true
    stats.Font = Enum.Font.Gotham
    stats.Parent = tab1
    round(stats, 6)

    -- Modes
    local modes = {"Explosion", "Push", "Vortex"}
    local modeBtns = {}
    for i, m in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.28, 0, 0, 30)
        btn.Position = UDim2.new(0.03 + (i-1) * 0.34, 0, 0, 48)
        btn.BackgroundColor3 = (m == CONFIG.Mode) and colors.Primary or colors.Primary
        btn.BackgroundTransparency = (m == CONFIG.Mode) and 0.2 or 0.6
        btn.BorderSizePixel = 0
        btn.Text = m
        btn.TextColor3 = Color3.fromHex("ffffff")
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tab1
        round(btn, 6)
        btn.MouseButton1Click:Connect(function()
            CONFIG.Mode = m
            for _, b in pairs(modeBtns) do
                b.BackgroundTransparency = 0.6
            end
            btn.BackgroundTransparency = 0.2
            stats.Text = m .. "  •  " .. CONFIG.Power .. "  •  R" .. CONFIG.Range
            showNotification("Mode: " .. m)
            saveConfig()
        end)
        table.insert(modeBtns, btn)
    end

    -- Power Slider
    local pLabel = Instance.new("TextLabel")
    pLabel.Size = UDim2.new(0.6, 0, 0, 22)
    pLabel.Position = UDim2.new(0.05, 0, 0, 88)
    pLabel.BackgroundTransparency = 1
    pLabel.Text = "⚡ POWER: " .. CONFIG.Power
    pLabel.TextColor3 = Color3.fromHex("ffffff")
    pLabel.TextScaled = true
    pLabel.Font = Enum.Font.Gotham
    pLabel.TextXAlignment = Enum.TextXAlignment.Left
    pLabel.Parent = tab1

    local pSlider = Instance.new("Frame")
    pSlider.Size = UDim2.new(0.85, 0, 0, 6)
    pSlider.Position = UDim2.new(0.075, 0, 0, 112)
    pSlider.BackgroundColor3 = colors.Primary
    pSlider.BackgroundTransparency = 0.7
    pSlider.Parent = tab1
    round(pSlider, 3)

    local pFill = Instance.new("Frame")
    pFill.Size = UDim2.new((CONFIG.Power - 1000) / 14000, 0, 1, 0)
    pFill.BackgroundColor3 = colors.Primary
    pFill.Parent = pSlider
    round(pFill, 3)

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
            pLabel.Text = "⚡ POWER: " .. CONFIG.Power
            stats.Text = CONFIG.Mode .. "  •  " .. CONFIG.Power .. "  •  R" .. CONFIG.Range
            pFill.Size = UDim2.new(p, 0, 1, 0)
        end
    end)

    -- Range Slider
    local rLabel = Instance.new("TextLabel")
    rLabel.Size = UDim2.new(0.6, 0, 0, 22)
    rLabel.Position = UDim2.new(0.05, 0, 0, 132)
    rLabel.BackgroundTransparency = 1
    rLabel.Text = "📡 RANGE: " .. CONFIG.Range
    rLabel.TextColor3 = Color3.fromHex("ffffff")
    rLabel.TextScaled = true
    rLabel.Font = Enum.Font.Gotham
    rLabel.TextXAlignment = Enum.TextXAlignment.Left
    rLabel.Parent = tab1

    local rSlider = Instance.new("Frame")
    rSlider.Size = UDim2.new(0.85, 0, 0, 6)
    rSlider.Position = UDim2.new(0.075, 0, 0, 156)
    rSlider.BackgroundColor3 = colors.Primary
    rSlider.BackgroundTransparency = 0.7
    rSlider.Parent = tab1
    round(rSlider, 3)

    local rFill = Instance.new("Frame")
    rFill.Size = UDim2.new((CONFIG.Range - 10) / 50, 0, 1, 0)
    rFill.BackgroundColor3 = colors.Light
    rFill.Parent = rSlider
    round(rFill, 3)

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
            rLabel.Text = "📡 RANGE: " .. CONFIG.Range
            stats.Text = CONFIG.Mode .. "  •  " .. CONFIG.Power .. "  •  R" .. CONFIG.Range
            rFill.Size = UDim2.new(p, 0, 1, 0)
        end
    end)

    -- Toggles
    local toggles = {
        {name = "AutoFling", key = "AutoFling"},
        {name = "AntiFling", key = "AntiFling"},
    }
    for i, t in ipairs(toggles) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.4, 0, 0, 26)
        frame.Position = UDim2.new(0.05 + (i-1) * 0.45, 0, 0, 176 + (i-1) * 32)
        frame.BackgroundTransparency = 1
        frame.Parent = tab1

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = t.name
        label.TextColor3 = Color3.fromHex("ffffff")
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local check = Instance.new("ImageLabel")
        check.Size = UDim2.new(0, 18, 0, 18)
        check.Position = UDim2.new(0.7, 0, 0, 4)
        check.BackgroundColor3 = colors.Primary
        check.Image = "rbxassetid://3926305904"
        check.ImageColor3 = CONFIG[t.key] and Color3.fromHex("ffffff") or colors.Primary
        check.ScaleType = Enum.ScaleType.Fit
        check.Parent = frame
        round(check, 4)

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                CONFIG[t.key] = not CONFIG[t.key]
                check.ImageColor3 = CONFIG[t.key] and Color3.fromHex("ffffff") or colors.Primary
                showNotification(t.name .. ": " .. (CONFIG[t.key] and "ON" or "OFF"))
                saveConfig()
            end
        end)
    end

    -- TAB 2: VISUALS
    local tab2 = Instance.new("Frame")
    tab2.Size = UDim2.new(1, 0, 1, 0)
    tab2.BackgroundTransparency = 1
    tab2.Visible = false
    tab2.Parent = content
    table.insert(tabFrames, tab2)

    local visualToggles = {
        {name = "ESP", key = "ESP"},
        {name = "Aura", key = "Aura"},
    }
    for i, t in ipairs(visualToggles) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.5, 0, 0, 26)
        frame.Position = UDim2.new(0.05 + ((i-1) % 2) * 0.45, 0, 0, 10 + math.floor((i-1)/2) * 35)
        frame.BackgroundTransparency = 1
        frame.Parent = tab2

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = t.name
        label.TextColor3 = Color3.fromHex("ffffff")
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local check = Instance.new("ImageLabel")
        check.Size = UDim2.new(0, 18, 0, 18)
        check.Position = UDim2.new(0.7, 0, 0, 4)
        check.BackgroundColor3 = colors.Primary
        check.Image = "rbxassetid://3926305904"
        check.ImageColor3 = CONFIG[t.key] and Color3.fromHex("ffffff") or colors.Primary
        check.ScaleType = Enum.ScaleType.Fit
        check.Parent = frame
        round(check, 4)

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                CONFIG[t.key] = not CONFIG[t.key]
                check.ImageColor3 = CONFIG[t.key] and Color3.fromHex("ffffff") or colors.Primary
                showNotification(t.name .. ": " .. (CONFIG[t.key] and "ON" or "OFF"))
                if t.key == "ESP" then updateESP() end
                if t.key == "Aura" then createAura() end
                saveConfig()
            end
        end)
    end

    -- TAB 3: PLAYERS
    local tab3 = Instance.new("Frame")
    tab3.Size = UDim2.new(1, 0, 1, 0)
    tab3.BackgroundTransparency = 1
    tab3.Visible = false
    tab3.Parent = content
    table.insert(tabFrames, tab3)

    updatePlayerList(tab3)

    -- TAB 4: SETTINGS
    local tab4 = Instance.new("Frame")
    tab4.Size = UDim2.new(1, 0, 1, 0)
    tab4.BackgroundTransparency = 1
    tab4.Visible = false
    tab4.Parent = content
    table.insert(tabFrames, tab4)

    -- Theme selection
    local themeLabel = Instance.new("TextLabel")
    themeLabel.Size = UDim2.new(0.6, 0, 0, 22)
    themeLabel.Position = UDim2.new(0.05, 0, 0, 10)
    themeLabel.BackgroundTransparency = 1
    themeLabel.Text = "🎨 Theme: " .. CONFIG.Theme
    themeLabel.TextColor3 = Color3.fromHex("ffffff")
    themeLabel.TextScaled = true
    themeLabel.Font = Enum.Font.Gotham
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left
    themeLabel.Parent = tab4

    local themeList = {"Violet", "Blue", "Red", "Green", "Gold", "Pink"}
    for i, th in ipairs(themeList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.28, 0, 0, 26)
        btn.Position = UDim2.new(0.05 + (i-1) * 0.32, 0, 0, 38 + math.floor((i-1)/3) * 32)
        btn.BackgroundColor3 = THEMES[th].Primary
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Text = th
        btn.TextColor3 = Color3.fromHex("ffffff")
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tab4
        round(btn, 6)
        btn.MouseButton1Click:Connect(function()
            CONFIG.Theme = th
            themeLabel.Text = "🎨 Theme: " .. th
            showNotification("Theme: " .. th)
            saveConfig()
            createUI() -- Rebuild UI with new theme
        end)
    end

    -- Silent mode toggle
    local silentFrame = Instance.new("Frame")
    silentFrame.Size = UDim2.new(0.5, 0, 0, 26)
    silentFrame.Position = UDim2.new(0.05, 0, 0, 110)
    silentFrame.BackgroundTransparency = 1
    silentFrame.Parent = tab4

    local silentLabel = Instance.new("TextLabel")
    silentLabel.Size = UDim2.new(0.6, 0, 1, 0)
    silentLabel.BackgroundTransparency = 1
    silentLabel.Text = "Silent Mode"
    silentLabel.TextColor3 = Color3.fromHex("ffffff")
    silentLabel.TextScaled = true
    silentLabel.Font = Enum.Font.Gotham
    silentLabel.TextXAlignment = Enum.TextXAlignment.Left
    silentLabel.Parent = silentFrame

    local silentCheck = Instance.new("ImageLabel")
    silentCheck.Size = UDim2.new(0, 18, 0, 18)
    silentCheck.Position = UDim2.new(0.7, 0, 0, 4)
    silentCheck.BackgroundColor3 = colors.Primary
    silentCheck.Image = "rbxassetid://3926305904"
    silentCheck.ImageColor3 = CONFIG.Silent and Color3.fromHex("ffffff") or colors.Primary
    silentCheck.ScaleType = Enum.ScaleType.Fit
    silentCheck.Parent = silentFrame
    round(silentCheck, 4)

    silentFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            CONFIG.Silent = not CONFIG.Silent
            silentCheck.ImageColor3 = CONFIG.Silent and Color3.fromHex("ffffff") or colors.Primary
            showNotification("Silent Mode: " .. (CONFIG.Silent and "ON" or "OFF"))
            saveConfig()
        end
    end)

    -- Save config button
    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0.4, 0, 0, 32)
    saveBtn.Position = UDim2.new(0.3, 0, 0, 150)
    saveBtn.BackgroundColor3 = colors.Primary
    saveBtn.BackgroundTransparency = 0.2
    saveBtn.BorderSizePixel = 0
    saveBtn.Text = "💾 Save Config"
    saveBtn.TextColor3 = Color3.fromHex("ffffff")
    saveBtn.TextScaled = true
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.Parent = tab4
    round(saveBtn, 8)
    saveBtn.MouseButton1Click:Connect(function()
        saveConfig()
        showNotification("Config saved!")
    end)

    toggleUI(true)
end

-- ============================================================
-- FLING FUNCTION (AlignPosition)
-- ============================================================

local function flingTarget(target)
    if not Char or not Root then return end
    local r = target:FindFirstChild("HumanoidRootPart")
    if not r then return end
    -- Whitelist check
    local plrName = Players:GetPlayerFromCharacter(target)
    if plrName and table.find(CONFIG.Whitelist, plrName.Name) then return end

    local att = Instance.new("Attachment")
    local align = Instance.new("AlignPosition")
    local goal = Instance.new("GoalValue")

    att.Parent = Root
    align.Attachment0 = att
    align.Attachment1 = r:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", r)
    align.Responsiveness = 200
    align.ReactionForceEnabled = true
    align.ForceLimit = CONFIG.Power * 10
    align.MaxForce = CONFIG.Power * 20
    align.Parent = Root

    goal.Value = Vector3.new(0, 9999, 0)
    goal.Parent = align

    task.wait(0.1)
    align:Destroy()
    goal:Destroy()
    att:Destroy()
end

-- ============================================================
-- GET TARGETS
-- ============================================================

local function getTargets()
    if not Char or not Root then return {}
    local list = {}
    local pos = Root.Position
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local r = plr.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local dist = (r.Position - pos).Magnitude
                if dist <= CONFIG.Range then
                    table.insert(list, plr.Character)
                end
            end
        end
    end
    return list
end

-- ============================================================
-- MAIN LOOP (Fling every 2 frames)
-- ============================================================

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
            local r = t:FindFirstChild("HumanoidRootPart")
            if r then
                local d = (r.Position - pos).Magnitude
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
-- HOTKEYS
-- ============================================================

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Menu toggle (M)
    if input.KeyCode == Enum.KeyCode.M then
        if gui then
            toggleUI()
        else
            createUI()
        end
    end

    -- Quick toggles
    if input.KeyCode == Enum.KeyCode.F then
        CONFIG.Power = CONFIG.Power + 2500
        if CONFIG.Power > 15000 then CONFIG.Power = 2500 end
        showNotification("Power: " .. CONFIG.Power)
        saveConfig()
    end

    if input.KeyCode == Enum.KeyCode.R then
        local modes = {"Explosion", "Push", "Vortex"}
        for i, m in ipairs(modes) do
            if CONFIG.Mode == m then
                CONFIG.Mode = modes[i % #modes + 1]
                break
            end
        end
        showNotification("Mode: " .. CONFIG.Mode)
        saveConfig()
    end

    if input.KeyCode == Enum.KeyCode.T then
        CONFIG.ESP = not CONFIG.ESP
        updateESP()
        showNotification("ESP: " .. (CONFIG.ESP and "ON" or "OFF"))
        saveConfig()
    end

    if input.KeyCode == Enum.KeyCode.Z then
        CONFIG.AutoFling = not CONFIG.AutoFling
        showNotification("AutoFling: " .. (CONFIG.AutoFling and "ON" or "OFF"))
        saveConfig()
    end

    if input.KeyCode == Enum.KeyCode.X then
        CONFIG.AntiFling = not CONFIG.AntiFling
        showNotification("AntiFling: " .. (CONFIG.AntiFling and "ON" or "OFF"))
        saveConfig()
    end
end)

-- ============================================================
-- INIT
-- ============================================================

playIntro()
task.wait(0.5)
createUI()

print("FLGΞAR ULTIMATE v9.0 loaded")
print("Hotkey: M (menu)")

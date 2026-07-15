--[[
    FLGΞAR v2.1 | FTAP (Fling Things And People)
    Premium Intro | Dark Violet UI | Anti-Detection
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
    Range = 30,
    Power = 5000,
    Mode = "Explosion",  -- "Explosion" | "Push" | "Vortex"
    AntiKick = true,
    Silent = false
}

-- ============================================================
-- COLORS
-- ============================================================

local COLORS = {
    Primary = Color3.fromHex("7a6085"),
    PrimaryDark = Color3.fromHex("4a3a52"),
    PrimaryLight = Color3.fromHex("a080b5"),
    Glow = Color3.fromHex("b090c5"),
    Background = Color3.fromHex("1a1420"),
    Text = Color3.fromHex("f0e8f5"),
    Accent = Color3.fromHex("d4b0e0")
}

-- ============================================================
-- PREMIUM INTRO ANIMATION
-- ============================================================

local function playPremiumIntro()
    local animGui = Instance.new("ScreenGui")
    animGui.Name = "FLGEAR_Intro"
    animGui.Parent = LP.PlayerGui
    animGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    animGui.ResetOnSpawn = false

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromHex("000000")
    bg.BackgroundTransparency = 0.15
    bg.BorderSizePixel = 0
    bg.Parent = animGui

    -- Logo container
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 320, 0, 320)
    logoContainer.Position = UDim2.new(0.5, -160, 0.5, -160)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = animGui

    -- Xi (Ξ) parts
    local function createXiPart(x, y, w, h)
        local part = Instance.new("Frame")
        part.Size = UDim2.new(0, w, 0, h)
        part.Position = UDim2.new(0, x, 0, y)
        part.BackgroundColor3 = Color3.fromHex("ffffff")
        part.BackgroundTransparency = 1
        part.BorderSizePixel = 0
        part.Parent = logoContainer
        return part
    end

    local topBar = createXiPart(40, 20, 240, 28)
    local midBar = createXiPart(40, 146, 240, 28)
    local botBar = createXiPart(40, 272, 240, 28)
    local vertBar = createXiPart(148, 20, 24, 280)

    -- Lightning inside Xi
    local boltTop = Instance.new("Frame")
    boltTop.Size = UDim2.new(0, 8, 0, 70)
    boltTop.Position = UDim2.new(0.5, -4, 0, -50)
    boltTop.BackgroundColor3 = Color3.fromHex("ffffff")
    boltTop.BackgroundTransparency = 1
    boltTop.BorderSizePixel = 0
    boltTop.Parent = logoContainer

    local boltSeg1 = Instance.new("Frame")
    boltSeg1.Size = UDim2.new(0, 50, 0, 8)
    boltSeg1.Position = UDim2.new(0.5, -25, 0, 20)
    boltSeg1.BackgroundColor3 = Color3.fromHex("ffffff")
    boltSeg1.BackgroundTransparency = 1
    boltSeg1.Rotation = 30
    boltSeg1.Parent = logoContainer

    local boltSeg2 = Instance.new("Frame")
    boltSeg2.Size = UDim2.new(0, 50, 0, 8)
    boltSeg2.Position = UDim2.new(0.5, -5, 0, 60)
    boltSeg2.BackgroundColor3 = Color3.fromHex("ffffff")
    boltSeg2.BackgroundTransparency = 1
    boltSeg2.Rotation = -30
    boltSeg2.Parent = logoContainer

    local boltSeg3 = Instance.new("Frame")
    boltSeg3.Size = UDim2.new(0, 50, 0, 8)
    boltSeg3.Position = UDim2.new(0.5, -25, 0, 100)
    boltSeg3.BackgroundColor3 = Color3.fromHex("ffffff")
    boltSeg3.BackgroundTransparency = 1
    boltSeg3.Rotation = 30
    boltSeg3.Parent = logoContainer

    local boltBot = Instance.new("Frame")
    boltBot.Size = UDim2.new(0, 8, 0, 60)
    boltBot.Position = UDim2.new(0.5, -4, 0, 180)
    boltBot.BackgroundColor3 = Color3.fromHex("ffffff")
    boltBot.BackgroundTransparency = 1
    boltBot.BorderSizePixel = 0
    boltBot.Parent = logoContainer

    local boltGroup = Instance.new("Folder")
    boltGroup.Name = "BoltGroup"
    boltGroup.Parent = logoContainer
    boltTop.Parent = boltGroup
    boltSeg1.Parent = boltGroup
    boltSeg2.Parent = boltGroup
    boltSeg3.Parent = boltGroup
    boltBot.Parent = boltGroup

    local xiGroup = Instance.new("Folder")
    xiGroup.Name = "XiGroup"
    xiGroup.Parent = logoContainer
    topBar.Parent = xiGroup
    midBar.Parent = xiGroup
    botBar.Parent = xiGroup
    vertBar.Parent = xiGroup

    -- Text: FLGΞAR + lightning
    local textGroup = Instance.new("Frame")
    textGroup.Size = UDim2.new(0, 600, 0, 140)
    textGroup.Position = UDim2.new(0.5, -300, 0.5, -70)
    textGroup.BackgroundTransparency = 1
    textGroup.Parent = animGui
    textGroup.Visible = false

    local flgLabel = Instance.new("TextLabel")
    flgLabel.Size = UDim2.new(0, 140, 0, 130)
    flgLabel.Position = UDim2.new(0, 0, 0, 5)
    flgLabel.BackgroundTransparency = 1
    flgLabel.Text = "FLG"
    flgLabel.TextColor3 = Color3.fromHex("ffffff")
    flgLabel.TextTransparency = 1
    flgLabel.TextScaled = true
    flgLabel.Font = Enum.Font.GothamBold
    flgLabel.TextXAlignment = Enum.TextXAlignment.Right
    flgLabel.Parent = textGroup

    local xiText = Instance.new("TextLabel")
    xiText.Size = UDim2.new(0, 60, 0, 130)
    xiText.Position = UDim2.new(0, 140, 0, 5)
    xiText.BackgroundTransparency = 1
    xiText.Text = "Ξ"
    xiText.TextColor3 = Color3.fromHex("ffffff")
    xiText.TextTransparency = 1
    xiText.TextScaled = true
    xiText.Font = Enum.Font.GothamBold
    xiText.Parent = textGroup

    local arLabel = Instance.new("TextLabel")
    arLabel.Size = UDim2.new(0, 100, 0, 130)
    arLabel.Position = UDim2.new(0, 200, 0, 5)
    arLabel.BackgroundTransparency = 1
    arLabel.Text = "AR"
    arLabel.TextColor3 = Color3.fromHex("ffffff")
    arLabel.TextTransparency = 1
    arLabel.TextScaled = true
    arLabel.Font = Enum.Font.GothamBold
    arLabel.TextXAlignment = Enum.TextXAlignment.Left
    arLabel.Parent = textGroup

    -- Final lightning
    local boltFinal = Instance.new("Frame")
    boltFinal.Size = UDim2.new(0, 8, 0, 120)
    boltFinal.Position = UDim2.new(0, 320, 0, 10)
    boltFinal.BackgroundColor3 = Color3.fromHex("ffffff")
    boltFinal.BackgroundTransparency = 1
    boltFinal.BorderSizePixel = 0
    boltFinal.Parent = textGroup

    local fSeg1 = Instance.new("Frame")
    fSeg1.Size = UDim2.new(0, 35, 0, 6)
    fSeg1.Position = UDim2.new(0, -10, 0, 30)
    fSeg1.BackgroundColor3 = Color3.fromHex("ffffff")
    fSeg1.BackgroundTransparency = 1
    fSeg1.Rotation = 25
    fSeg1.Parent = boltFinal

    local fSeg2 = Instance.new("Frame")
    fSeg2.Size = UDim2.new(0, 35, 0, 6)
    fSeg2.Position = UDim2.new(0, 5, 0, 55)
    fSeg2.BackgroundColor3 = Color3.fromHex("ffffff")
    fSeg2.BackgroundTransparency = 1
    fSeg2.Rotation = -25
    fSeg2.Parent = boltFinal

    local fSeg3 = Instance.new("Frame")
    fSeg3.Size = UDim2.new(0, 35, 0, 6)
    fSeg3.Position = UDim2.new(0, -10, 0, 80)
    fSeg3.BackgroundColor3 = Color3.fromHex("ffffff")
    fSeg3.BackgroundTransparency = 1
    fSeg3.Rotation = 25
    fSeg3.Parent = boltFinal

    -- Animation
    local parts = {}
    for _, child in pairs(logoContainer:GetDescendants()) do
        if child:IsA("Frame") then
            table.insert(parts, child)
        end
    end

    for _, part in pairs(parts) do
        part.BackgroundTransparency = 1
    end

    for _, part in pairs(parts) do
        local t = TweenService:Create(part, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0
        })
        t:Play()
    end

    task.wait(3)
    local tLogoLeft = TweenService:Create(logoContainer, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.15, -160, 0.5, -160)
    })
    tLogoLeft:Play()

    task.wait(1)
    local tLogoRight = TweenService:Create(logoContainer, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        Position = UDim2.new(0.5, 200, 0.5, -160)
    })
    tLogoRight:Play()

    textGroup.Visible = true

    local tFlg = TweenService:Create(flgLabel, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    tFlg:Play()

    task.wait(0.15)
    local tXi = TweenService:Create(xiText, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    tXi:Play()

    task.wait(0.15)
    local tAr = TweenService:Create(arLabel, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    tAr:Play()

    task.wait(0.2)
    for _, part in pairs(boltFinal:GetDescendants()) do
        if part:IsA("Frame") then
            local t = TweenService:Create(part, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            })
            t:Play()
        end
    end
    local tBoltFinal = TweenService:Create(boltFinal, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tBoltFinal:Play()

    task.wait(0.5)
    local tFinalShift = TweenService:Create(textGroup, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.4, -300, 0.5, -70)
    })
    tFinalShift:Play()

    task.wait(1.5)
    local tBgFade = TweenService:Create(bg, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    tBgFade:Play()
    task.wait(0.6)
    animGui:Destroy()
end

-- ============================================================
-- UI (Dark Violet Theme)
-- ============================================================

local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FLGEAR_UI"
    screenGui.Parent = LP.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 360, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -180, 0.5, -240)
    mainFrame.BackgroundColor3 = COLORS.Background
    mainFrame.BackgroundTransparency = 0.92
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = game:GetService("Lighting")

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.PrimaryDark),
        ColorSequenceKeypoint.new(0.5, COLORS.Primary),
        ColorSequenceKeypoint.new(1, COLORS.PrimaryDark)
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame

    local glowBorder = Instance.new("Frame")
    glowBorder.Size = UDim2.new(1, 0, 1, 0)
    glowBorder.Position = UDim2.new(0, -2, 0, -2)
    glowBorder.BackgroundColor3 = COLORS.Glow
    glowBorder.BackgroundTransparency = 0.7
    glowBorder.BorderSizePixel = 0
    glowBorder.Parent = mainFrame

    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundColor3 = COLORS.Primary
    border.BackgroundTransparency = 0.5
    border.BorderSizePixel = 2
    border.Parent = mainFrame

    -- Title
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 70)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = mainFrame

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, 0, 1, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "FLGΞAR"
    titleText.TextColor3 = COLORS.Text
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleFrame

    local xiLabel = Instance.new("TextLabel")
    xiLabel.Size = UDim2.new(0, 60, 0, 60)
    xiLabel.Position = UDim2.new(0.5, -30, 0, 5)
    xiLabel.BackgroundTransparency = 1
    xiLabel.Text = "Ξ"
    xiLabel.TextColor3 = COLORS.PrimaryLight
    xiLabel.TextScaled = true
    xiLabel.Font = Enum.Font.GothamBold
    xiLabel.Parent = titleFrame

    local xiTween1 = TweenService:Create(xiLabel, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Rotation = 360,
        TextColor3 = COLORS.Glow
    })
    xiTween1:Play()

    local xiTween2 = TweenService:Create(xiLabel, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        TextTransparency = 0.3,
        Position = UDim2.new(0.5, -30, 0, 15)
    })
    xiTween2:Play()

    -- Stats
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, -20, 0, 40)
    statsFrame.Position = UDim2.new(0, 10, 0, 75)
    statsFrame.BackgroundColor3 = COLORS.PrimaryDark
    statsFrame.BackgroundTransparency = 0.5
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = mainFrame

    local statsText = Instance.new("TextLabel")
    statsText.Size = UDim2.new(1, 0, 1, 0)
    statsText.BackgroundTransparency = 1
    statsText.Text = "⚡ FLING READY"
    statsText.TextColor3 = COLORS.Text
    statsText.TextScaled = true
    statsText.Font = Enum.Font.Gotham
    statsText.Parent = statsFrame

    -- Modes
    local modes = {"Explosion", "Push", "Vortex"}
    local modeButtons = {}

    for i, mode in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.28, 0, 0, 35)
        btn.Position = UDim2.new(0.03 + (i-1) * 0.34, 0, 0, 130)
        btn.BackgroundColor3 = (mode == CONFIG.Mode) and COLORS.Primary or COLORS.PrimaryDark
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Text = mode
        btn.TextColor3 = COLORS.Text
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = mainFrame

        btn.MouseButton1Click:Connect(function()
            CONFIG.Mode = mode
            for _, b in ipairs(modeButtons) do
                b.BackgroundColor3 = COLORS.PrimaryDark
            end
            btn.BackgroundColor3 = COLORS.Primary
            statsText.Text = "🔄 MODE: " .. mode
        end)

        table.insert(modeButtons, btn)
    end

    -- Power Slider
    local powerFrame = Instance.new("Frame")
    powerFrame.Size = UDim2.new(0.9, 0, 0, 40)
    powerFrame.Position = UDim2.new(0.05, 0, 0, 180)
    powerFrame.BackgroundTransparency = 1
    powerFrame.Parent = mainFrame

    local powerLabel = Instance.new("TextLabel")
    powerLabel.Size = UDim2.new(0.4, 0, 1, 0)
    powerLabel.BackgroundTransparency = 1
    powerLabel.Text = "⚡ POWER"
    powerLabel.TextColor3 = COLORS.Text
    powerLabel.TextScaled = true
    powerLabel.Font = Enum.Font.Gotham
    powerLabel.TextXAlignment = Enum.TextXAlignment.Left
    powerLabel.Parent = powerFrame

    local powerValue = Instance.new("TextLabel")
    powerValue.Size = UDim2.new(0.3, 0, 1, 0)
    powerValue.Position = UDim2.new(0.7, 0, 0, 0)
    powerValue.BackgroundTransparency = 1
    powerValue.Text = tostring(CONFIG.Power)
    powerValue.TextColor3 = COLORS.PrimaryLight
    powerValue.TextScaled = true
    powerValue.Font = Enum.Font.GothamBold
    powerValue.TextXAlignment = Enum.TextXAlignment.Right
    powerValue.Parent = powerFrame

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.9, 0, 0, 6)
    slider.Position = UDim2.new(0.05, 0, 0, 225)
    slider.BackgroundColor3 = COLORS.PrimaryDark
    slider.BorderSizePixel = 0
    slider.Parent = mainFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((CONFIG.Power - 1000) / 14000, 0, 1, 0)
    sliderFill.BackgroundColor3 = COLORS.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = slider

    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            CONFIG.Power = math.round(1000 + percent * 14000)
            powerValue.Text = tostring(CONFIG.Power)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        end
    end)

    -- Anti-Kick Toggle
    local akFrame = Instance.new("Frame")
    akFrame.Size = UDim2.new(0.9, 0, 0, 30)
    akFrame.Position = UDim2.new(0.05, 0, 0, 245)
    akFrame.BackgroundTransparency = 1
    akFrame.Parent = mainFrame

    local akLabel = Instance.new("TextLabel")
    akLabel.Size = UDim2.new(0.7, 0, 1, 0)
    akLabel.BackgroundTransparency = 1
    akLabel.Text = "🛡️ ANTI-KICK"
    akLabel.TextColor3 = COLORS.Text
    akLabel.TextScaled = true
    akLabel.Font = Enum.Font.Gotham
    akLabel.TextXAlignment = Enum.TextXAlignment.Left
    akLabel.Parent = akFrame

    local akCheck = Instance.new("ImageLabel")
    akCheck.Size = UDim2.new(0, 25, 0, 25)
    akCheck.Position = UDim2.new(0.9, 0, 0, 2)
    akCheck.BackgroundColor3 = COLORS.Primary
    akCheck.Image = "rbxassetid://3926305904"
    akCheck.ImageColor3 = COLORS.Text
    akCheck.ScaleType = Enum.ScaleType.Fit
    akCheck.Parent = akFrame

    akFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            CONFIG.AntiKick = not CONFIG.AntiKick
            akCheck.ImageColor3 = CONFIG.AntiKick and COLORS.Text or COLORS.PrimaryDark
        end
    end)

    -- Toggle UI
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.2, 0, 0, 30)
    toggleBtn.Position = UDim2.new(0.4, 0, 0, 300)
    toggleBtn.BackgroundColor3 = COLORS.PrimaryDark
    toggleBtn.BackgroundTransparency = 0.5
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "▼ HIDE"
    toggleBtn.TextColor3 = COLORS.Text
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = mainFrame

    local uiVisible = true
    toggleBtn.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
        toggleBtn.Text = uiVisible and "▼ HIDE" or "▲ SHOW"
    end)

    -- Close
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = COLORS.Text
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mainFrame

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        game:GetService("Lighting").Blur:Destroy()
    end)

    -- Drag
    local drag = false
    local dragStart, startPos

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return screenGui
end

-- ============================================================
-- PHYSICS (FLING)
-- ============================================================

local function getNearbyPlayers()
    local list = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - Root.Position).Magnitude
            if dist <= CONFIG.Range then
                table.insert(list, plr.Character)
            end
        end
    end
    return list
end

RunService.Stepped:Connect(function()
    if not Char or not Root then return end

    local targets = getNearbyPlayers()
    for _, targetChar in pairs(targets) do
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetRoot then continue end

        if CONFIG.Mode == "Explosion" then
            local explosion = Instance.new("Explosion")
            explosion.Position = targetRoot.Position + Vector3.new(0, 2, 0)
            explosion.BlastRadius = 5
            explosion.BlastPressure = CONFIG.Power / 50
            explosion.DestroyJointRadiusPercent = 0
            explosion.Parent = workspace
            explosion:Destroy()
        elseif CONFIG.Mode == "Push" then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = (targetRoot.Position - Root.Position).Unit * CONFIG.Power
            bv.Parent = targetRoot
            task.wait(0.05)
            bv:Destroy()
        elseif CONFIG.Mode == "Vortex" then
            local bodyPos = Instance.new("BodyPosition")
            bodyPos.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyPos.Position = Root.Position + Vector3.new(0, 30, 0)
            bodyPos.P = 3000
            bodyPos.D = 500
            bodyPos.Parent = targetRoot
            task.wait(0.15)
            bodyPos:Destroy()
            targetRoot.Velocity = Vector3.new(0, CONFIG.Power * 0.8, 0)
        end
    end
end)

-- ============================================================
-- ANTI-KICK
-- ============================================================

if CONFIG.AntiKick then
    local oldNamecall = nil
    if hookfunction then
        oldNamecall = hookfunction(getrawmetatable(game).__namecall, newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self.Name:match("AntiFling|Kick") then
                return nil
            end
            return oldNamecall(self, ...)
        end))
    end
end

-- ============================================================
-- HOTKEYS
-- ============================================================

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F then
        CONFIG.Power = CONFIG.Power == 5000 and 15000 or 5000
        if not CONFIG.Silent then
            LP:Chat("⚡ FLGΞAR POWER: " .. CONFIG.Power)
        end
    end

    if input.KeyCode == Enum.KeyCode.R then
        local modes = {"Explosion", "Push", "Vortex"}
        local currentIndex = table.find(modes, CONFIG.Mode)
        CONFIG.Mode = modes[currentIndex % 3 + 1]
        if not CONFIG.Silent then
            LP:Chat("🔄 MODE: " .. CONFIG.Mode)
        end
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================

playPremiumIntro()
createUI()

print("═══════════════════════════════════════")
print("  ███████╗██╗      ██████╗ ███████╗")
print("  ██╔════╝██║     ██╔════╝ ██╔════╝")
print("  █████╗  ██║     ██║  ███╗█████╗")
print("  ██╔══╝  ██║     ██║   ██║██╔══╝")
print("  ██║     ███████╗╚██████╔╝███████╗")
print("  ╚═╝     ╚══════╝ ╚═════╝ ╚══════╝")
print("  FLGΞAR v2.1 | FTAP")
print("  Mode: " .. CONFIG.Mode .. " | Power: " .. CONFIG.Power)
print("  [F] Power | [R] Mode | Drag UI")
print("═══════════════════════════════════════")

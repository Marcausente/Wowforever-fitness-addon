local _, ns = ...

local FitnessFrame = {}
ns.FitnessFrame = FitnessFrame

local WHITE = "Interface\\Buttons\\WHITE8X8"
local mainFrame = nil
local minimapButton = nil
local stopTicks = {}

local session = {
    inFlight = false,
    landed = false,
    flight = nil,
    currentExercise = nil,
    nextExercise = nil,
    seenIds = {},
    lastCategory = nil,
    completedCount = 0,
    exTimerTotal = 0,
    exTimerRemaining = 0,
    exPrepRemaining = 0,
    exTimerDone = false,
    lastSecond = -1,
}

local function PlayUICue(soundId)
    if PlaySound and soundId then
        pcall(PlaySound, soundId, "SFX")
    end
end

local function CreateBorder(parent, r, g, b, a)
    local edges = {}
    for i = 1, 4 do
        local tex = parent:CreateTexture(nil, "BORDER")
        tex:SetColorTexture(r or 1, g or 1, b or 1, a or 0.14)
        edges[i] = tex
    end
    edges[1]:SetPoint("TOPLEFT"); edges[1]:SetPoint("TOPRIGHT"); edges[1]:SetHeight(1)
    edges[2]:SetPoint("BOTTOMLEFT"); edges[2]:SetPoint("BOTTOMRIGHT"); edges[2]:SetHeight(1)
    edges[3]:SetPoint("TOPLEFT"); edges[3]:SetPoint("BOTTOMLEFT"); edges[3]:SetWidth(1)
    edges[4]:SetPoint("TOPRIGHT"); edges[4]:SetPoint("BOTTOMRIGHT"); edges[4]:SetWidth(1)
    return edges
end

local function MakeButton(parent, width, height, r, g, b)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width, height)
    btn:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    btn.baseR, btn.baseG, btn.baseB = r, g, b
    btn:SetBackdropColor(r, g, b, 0.95)
    btn:SetBackdropBorderColor(math.min(1, r + 0.2), math.min(1, g + 0.2), math.min(1, b + 0.2), 0.75)

    local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    fs:SetPoint("CENTER")
    fs:SetJustifyH("CENTER")
    btn.label = fs

    btn:SetScript("OnEnter", function(self)
        if self:IsEnabled() then
            self:SetBackdropColor(math.min(1, self.baseR + 0.10), math.min(1, self.baseG + 0.10), math.min(1, self.baseB + 0.10), 1)
        end
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(self.baseR, self.baseG, self.baseB, 0.95)
    end)
    btn:SetScript("OnDisable", function(self) self:SetAlpha(0.42) end)
    btn:SetScript("OnEnable", function(self) self:SetAlpha(1.0) end)

    return btn
end

local function MakeOptionPill(parent, width, height, onClick)
    local btn = MakeButton(parent, width, height, 0.13, 0.16, 0.22)
    btn:SetScript("OnClick", onClick)
    function btn:SetSelected(selected)
        if selected then
            self.baseR, self.baseG, self.baseB = 0.06, 0.54, 0.42
            self:SetBackdropColor(0.06, 0.54, 0.42, 1)
            self:SetBackdropBorderColor(0.20, 0.92, 0.74, 0.95)
        else
            self.baseR, self.baseG, self.baseB = 0.13, 0.16, 0.22
            self:SetBackdropColor(0.13, 0.16, 0.22, 0.95)
            self:SetBackdropBorderColor(0.30, 0.36, 0.44, 0.70)
        end
    end
    return btn
end

local function GetFlightRemaining()
    if not session.inFlight or not session.flight then return 0, 0 end
    local elapsed = GetTime() - (session.flight.startTime or GetTime())
    local total = session.flight.totalSeconds or 0
    if total <= 0 then
        return 120, elapsed -- Unknown route duration while learning
    end
    return math.max(0, total - elapsed), elapsed
end

local function SetupTimedExercise(ex)
    session.exTimerTotal = 0
    session.exTimerRemaining = 0
    session.exPrepRemaining = 0
    session.exTimerDone = false
    if ex and ns.Exercises:IsTimed(ex) then
        local secs = ns.Exercises:GetTimedSeconds(ex)
        session.exTimerTotal = secs
        session.exTimerRemaining = secs
        session.exPrepRemaining = 2.0
    end
end

local function PickExercises(useNext)
    local remaining = session.inFlight and select(1, GetFlightRemaining()) or 90
    if session.inFlight and session.flight and session.flight.totalSeconds > 0 and remaining < 10 then
        session.currentExercise = nil
        session.nextExercise = nil
        FitnessFrame:RenderExerciseArea()
        return
    end

    local chosen = nil
    if useNext and session.nextExercise and ((not session.inFlight) or (session.nextExercise.estSeconds or 20) <= remaining) then
        chosen = session.nextExercise
    else
        chosen = ns.Exercises:PickNext(remaining, session.seenIds, session.lastCategory)
    end

    if chosen then
        session.seenIds[chosen.id] = true
        session.lastCategory = chosen.category
        ns.Exercises:MarkRecent(chosen.id)
    end

    session.currentExercise = chosen
    SetupTimedExercise(chosen)

    local budgetAfter = session.inFlight and (remaining - (chosen and (chosen.estSeconds or 20) or 0)) or 90
    if chosen and budgetAfter >= 14 then
        local tempSeen = {}
        for k, v in pairs(session.seenIds) do tempSeen[k] = v end
        tempSeen[chosen.id] = true
        session.nextExercise = ns.Exercises:PickNext(budgetAfter, tempSeen, chosen.category)
    else
        session.nextExercise = nil
    end

    FitnessFrame:RenderExerciseArea()
end

local function PlaceStopTicks()
    if not mainFrame or not session.flight or (session.flight.totalSeconds or 0) <= 0 then
        for _, t in ipairs(stopTicks) do t:Hide() end
        return
    end
    local times = session.flight.stopTimes or {}
    local total = math.max(1, session.flight.totalSeconds)
    local width = mainFrame.flightBar:GetWidth()
    if width <= 0 then width = 406 end

    for i = 1, math.max(#times, #stopTicks) do
        local tick = stopTicks[i]
        if i <= #times then
            if not tick then
                tick = mainFrame.flightBar:CreateTexture(nil, "OVERLAY")
                tick:SetColorTexture(0.05, 0.06, 0.08, 0.85)
                stopTicks[i] = tick
            end
            local frac = math.max(0.02, math.min(0.98, times[i] / total))
            tick:SetSize(2, 26)
            tick:ClearAllPoints()
            tick:SetPoint("CENTER", mainFrame.flightBar, "LEFT", width * frac, 0)
            tick:Show()
        elseif tick then
            tick:Hide()
        end
    end
end

local function BuildFrame()
    if mainFrame then return mainFrame end

    local f = CreateFrame("Frame", "FitnessExcerciseForeverFrame", UIParent, "BackdropTemplate")
    f:SetSize(540, 476)
    f:SetFrameStrata("HIGH")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local db = FitnessExcerciseForeverDB
        if db then
            local a, _, r, x, y = self:GetPoint()
            db.framePos = { a = a, r = r, x = x, y = y }
        end
    end)

    f:SetBackdrop({ bgFile = WHITE })
    f:SetBackdropColor(0.06, 0.08, 0.11, 0.96)
    CreateBorder(f, 1, 1, 1, 0.16)
    table.insert(UISpecialFrames, "FitnessExcerciseForeverFrame")

    -- Top accent strip
    local accent = f:CreateTexture(nil, "ARTWORK")
    accent:SetPoint("TOPLEFT"); accent:SetPoint("TOPRIGHT")
    accent:SetHeight(3)
    accent:SetColorTexture(0.0, 0.84, 0.66, 1)

    -- Header icon + title
    local icon = f:CreateTexture(nil, "ARTWORK")
    icon:SetSize(26, 26)
    icon:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -11)
    icon:SetTexture("Interface\\AddOns\\FitnessExcerciseForever\\Media\\Logo")
    icon:SetTexCoord(0, 1, 0, 1)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    title:SetText("FITNESS EXERCISE FOREVER")
    title:SetTextColor(0.0, 0.90, 0.72)

    local closeBtn = MakeButton(f, 24, 22, 0.22, 0.16, 0.18)
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, -13)
    closeBtn.label:SetText("X")
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local langBtn = MakeButton(f, 64, 22, 0.14, 0.20, 0.28)
    langBtn:SetPoint("RIGHT", closeBtn, "LEFT", -6, 0)
    langBtn:SetScript("OnClick", function()
        local cur = ns.GetLang()
        FitnessExcerciseForeverDB.settings.language = (cur == "es") and "en" or "es"
        FitnessFrame:RefreshAll()
    end)
    f.langBtn = langBtn

    -- =========================================================================
    -- FLIGHT TIMER BAR SECTION (big, clear, always readable)
    -- =========================================================================
    local routeText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    routeText:SetPoint("TOPLEFT", icon, "BOTTOMLEFT", 0, -10)
    routeText:SetPoint("RIGHT", f, "RIGHT", -90, 0)
    routeText:SetJustifyH("LEFT")
    routeText:SetWordWrap(false)
    routeText:SetTextColor(0.92, 0.95, 0.98)
    f.routeText = routeText

    local sourceBadge = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sourceBadge:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, -46)
    sourceBadge:SetJustifyH("RIGHT")
    sourceBadge:SetTextColor(1, 0.84, 0.38)
    f.sourceBadge = sourceBadge

    local testBtn = MakeButton(f, 82, 20, 0.14, 0.34, 0.52)
    testBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, -42)
    testBtn:SetScript("OnClick", function()
        ns.FlightTracker:StartTestFlight(90)
    end)
    f.testBtn = testBtn

    local barFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
    barFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -64)
    barFrame:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, -64)
    barFrame:SetHeight(28)
    barFrame:SetBackdrop({ bgFile = WHITE })
    barFrame:SetBackdropColor(0.03, 0.04, 0.06, 0.98)
    CreateBorder(barFrame, 1, 1, 1, 0.18)

    local bar = CreateFrame("StatusBar", nil, barFrame)
    bar:SetPoint("TOPLEFT", barFrame, "TOPLEFT", 1, -1)
    bar:SetPoint("BOTTOMRIGHT", barFrame, "BOTTOMRIGHT", -1, 1)
    bar:SetStatusBarTexture(WHITE)
    bar:SetStatusBarColor(0.0, 0.72, 0.56, 1)
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(0)
    f.flightBar = bar

    -- High-contrast outlined timer text centered on the bar
    local barText = bar:CreateFontString(nil, "OVERLAY")
    local fontPath = GameFontNormalLarge and GameFontNormalLarge:GetFont() or "Fonts\\FRIZQT__.TTF"
    barText:SetFont(fontPath, 13, "OUTLINE")
    barText:SetDrawLayer("OVERLAY", 7)
    barText:SetPoint("CENTER", bar, "CENTER", 0, 0)
    barText:SetTextColor(1, 1, 1)
    f.barText = barText

    local nextStopText = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    nextStopText:SetPoint("TOPLEFT", barFrame, "BOTTOMLEFT", 2, -4)
    nextStopText:SetPoint("TOPRIGHT", barFrame, "BOTTOMRIGHT", -2, -4)
    nextStopText:SetJustifyH("LEFT")
    nextStopText:SetWordWrap(false)
    f.nextStopText = nextStopText

    -- =========================================================================
    -- SIMPLE SETUP BAR (Equipment + Difficulty)
    -- =========================================================================
    local setupBox = CreateFrame("Frame", nil, f, "BackdropTemplate")
    setupBox:SetPoint("TOPLEFT", barFrame, "BOTTOMLEFT", 0, -18)
    setupBox:SetPoint("TOPRIGHT", barFrame, "BOTTOMRIGHT", 0, -18)
    setupBox:SetHeight(66)
    setupBox:SetBackdrop({ bgFile = WHITE })
    setupBox:SetBackdropColor(0.09, 0.12, 0.16, 0.95)
    CreateBorder(setupBox, 1, 1, 1, 0.10)
    f.setupBox = setupBox

    -- Row 1: Equipment
    local eqLabel = setupBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    eqLabel:SetPoint("TOPLEFT", setupBox, "TOPLEFT", 10, -11)
    eqLabel:SetWidth(74)
    eqLabel:SetJustifyH("LEFT")
    eqLabel:SetTextColor(0.75, 0.82, 0.90)
    setupBox.eqLabel = eqLabel

    local eqNoneBtn = MakeOptionPill(setupBox, 152, 22, function()
        FitnessExcerciseForeverDB.settings.equipmentMode = "none"
        FitnessFrame:RefreshSetupPills()
        if FitnessExcerciseForeverDB.setupDone then
            PickExercises(false)
        end
    end)
    eqNoneBtn:SetPoint("LEFT", eqLabel, "RIGHT", 6, 0)
    setupBox.eqNoneBtn = eqNoneBtn

    local eqMixBtn = MakeOptionPill(setupBox, 220, 22, function()
        FitnessExcerciseForeverDB.settings.equipmentMode = "mixed"
        FitnessFrame:RefreshSetupPills()
        if FitnessExcerciseForeverDB.setupDone then
            PickExercises(false)
        end
    end)
    eqMixBtn:SetPoint("LEFT", eqNoneBtn, "RIGHT", 8, 0)
    setupBox.eqMixBtn = eqMixBtn

    -- Row 2: Difficulty
    local diffLabel = setupBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    diffLabel:SetPoint("TOPLEFT", setupBox, "TOPLEFT", 10, -41)
    diffLabel:SetWidth(74)
    diffLabel:SetJustifyH("LEFT")
    diffLabel:SetTextColor(0.75, 0.82, 0.90)
    setupBox.diffLabel = diffLabel

    local diffDefs = {
        { id = "beginner", key = "DIFF_BEGINNER", w = 122 },
        { id = "intermediate", key = "DIFF_INTERMEDIATE", w = 122 },
        { id = "advanced", key = "DIFF_ADVANCED", w = 122 },
    }
    setupBox.diffPills = {}
    local dx = 0
    for idx, d in ipairs(diffDefs) do
        local pill = MakeOptionPill(setupBox, d.w, 22, function()
            FitnessExcerciseForeverDB.settings.difficulty = d.id
            FitnessFrame:RefreshSetupPills()
            if FitnessExcerciseForeverDB.setupDone then
                PickExercises(false)
            end
        end)
        pill:SetPoint("LEFT", diffLabel, "RIGHT", 6 + dx, 0)
        pill.diffId = d.id
        pill.locKey = d.key
        setupBox.diffPills[idx] = pill
        dx = dx + d.w + 7
    end

    -- =========================================================================
    -- FIRST-TIME CONFIRMATION PANEL (shown until user clicks Show Exercises)
    -- =========================================================================
    local confirmPanel = CreateFrame("Frame", nil, f, "BackdropTemplate")
    confirmPanel:SetPoint("TOPLEFT", setupBox, "BOTTOMLEFT", 0, -10)
    confirmPanel:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 14)
    confirmPanel:SetBackdrop({ bgFile = WHITE })
    confirmPanel:SetBackdropColor(0.09, 0.12, 0.16, 0.95)
    CreateBorder(confirmPanel, 1, 1, 1, 0.10)
    f.confirmPanel = confirmPanel

    confirmPanel.hint = confirmPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    confirmPanel.hint:SetPoint("TOP", confirmPanel, "TOP", 0, -34)
    confirmPanel.hint:SetWidth(360)
    confirmPanel.hint:SetJustifyH("CENTER")
    confirmPanel.hint:SetTextColor(0.84, 0.88, 0.94)

    local startBtn = MakeButton(confirmPanel, 210, 34, 0.06, 0.58, 0.42)
    startBtn:SetPoint("TOP", confirmPanel.hint, "BOTTOM", 0, -22)
    startBtn.label:SetFontObject("GameFontNormal")
    startBtn:SetScript("OnClick", function()
        FitnessExcerciseForeverDB.setupDone = true
        PlayUICue(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        PickExercises(false)
    end)
    confirmPanel.startBtn = startBtn

    -- =========================================================================
    -- ACTIVE EXERCISE CARD (shown once setupDone is true)
    -- =========================================================================
    local exPanel = CreateFrame("Frame", nil, f, "BackdropTemplate")
    exPanel:SetPoint("TOPLEFT", setupBox, "BOTTOMLEFT", 0, -10)
    exPanel:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 52)
    exPanel:SetBackdrop({ bgFile = WHITE })
    exPanel:SetBackdropColor(0.09, 0.12, 0.16, 0.95)
    CreateBorder(exPanel, 1, 1, 1, 0.10)
    f.exPanel = exPanel

    local eqBadge = CreateFrame("Frame", nil, exPanel, "BackdropTemplate")
    eqBadge:SetSize(96, 20)
    eqBadge:SetPoint("TOPLEFT", exPanel, "TOPLEFT", 12, -10)
    eqBadge:SetBackdrop({ bgFile = WHITE })
    eqBadge.text = eqBadge:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    eqBadge.text:SetPoint("CENTER")
    exPanel.eqBadge = eqBadge

    local catText = exPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    catText:SetPoint("LEFT", eqBadge, "RIGHT", 8, 0)
    exPanel.catText = catText

    local doneText = exPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    doneText:SetPoint("TOPRIGHT", exPanel, "TOPRIGHT", -12, -12)
    doneText:SetTextColor(0.45, 0.92, 0.72)
    exPanel.doneText = doneText

    -- Exercise illustration box (left)
    local poseBox = CreateFrame("Frame", nil, exPanel, "BackdropTemplate")
    poseBox:SetSize(134, 134)
    poseBox:SetPoint("TOPLEFT", eqBadge, "BOTTOMLEFT", 0, -10)
    poseBox:SetBackdrop({ bgFile = WHITE })
    poseBox:SetBackdropColor(0.06, 0.08, 0.12, 1)
    CreateBorder(poseBox, 0.20, 0.75, 0.62, 0.35)
    exPanel.poseBox = poseBox

    local poseTex = poseBox:CreateTexture(nil, "ARTWORK")
    poseTex:SetSize(128, 128)
    poseTex:SetPoint("CENTER", poseBox, "CENTER", 0, 0)
    poseTex:SetTexture(ns.Exercises.POSE_TEXTURE)
    exPanel.poseTex = poseTex

    -- Exercise title, target & step-by-step guide (right of illustration)
    local exName = exPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    exName:SetPoint("TOPLEFT", poseBox, "TOPRIGHT", 12, 2)
    exName:SetPoint("RIGHT", exPanel, "RIGHT", -12, 0)
    exName:SetJustifyH("LEFT")
    exName:SetWordWrap(true)
    exName:SetTextColor(1, 1, 1)
    exPanel.exName = exName

    local exTarget = exPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    exTarget:SetPoint("TOPLEFT", exName, "BOTTOMLEFT", 0, -4)
    exTarget:SetPoint("RIGHT", exPanel, "RIGHT", -12, 0)
    exTarget:SetJustifyH("LEFT")
    exTarget:SetTextColor(1, 0.85, 0.35)
    exPanel.exTarget = exTarget

    local exDesc = exPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    exDesc:SetPoint("TOPLEFT", exTarget, "BOTTOMLEFT", 0, -8)
    exDesc:SetPoint("BOTTOMRIGHT", exPanel, "BOTTOMRIGHT", -12, 46)
    exDesc:SetJustifyH("LEFT")
    exDesc:SetJustifyV("TOP")
    exDesc:SetSpacing(3)
    exDesc:SetTextColor(0.86, 0.90, 0.94)
    exPanel.exDesc = exDesc

    -- Timed exercise sub-bar
    local exBar = CreateFrame("StatusBar", nil, exPanel)
    exBar:SetPoint("BOTTOMLEFT", exPanel, "BOTTOMLEFT", 12, 24)
    exBar:SetPoint("BOTTOMRIGHT", exPanel, "BOTTOMRIGHT", -12, 24)
    exBar:SetHeight(7)
    exBar:SetStatusBarTexture(WHITE)
    exBar:SetStatusBarColor(0.95, 0.72, 0.20, 1)
    exBar:SetMinMaxValues(0, 1)
    exBar.bg = exBar:CreateTexture(nil, "BACKGROUND")
    exBar.bg:SetAllPoints()
    exBar.bg:SetColorTexture(1, 1, 1, 0.12)
    exBar:Hide()
    exPanel.exBar = exBar

    local exTimerText = exPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    exTimerText:SetPoint("BOTTOMLEFT", exBar, "TOPLEFT", 0, 3)
    exTimerText:SetTextColor(1, 0.85, 0.35)
    exTimerText:Hide()
    exPanel.exTimerText = exTimerText

    local nextUpText = exPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    nextUpText:SetPoint("BOTTOMLEFT", exPanel, "BOTTOMLEFT", 12, 6)
    nextUpText:SetPoint("BOTTOMRIGHT", exPanel, "BOTTOMRIGHT", -12, 6)
    nextUpText:SetJustifyH("LEFT")
    nextUpText:SetWordWrap(false)
    exPanel.nextUpText = nextUpText

    -- Bottom Action Buttons (Complete / Skip)
    local completeBtn = MakeButton(f, 250, 32, 0.06, 0.56, 0.40)
    completeBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 12)
    completeBtn.label:SetFontObject("GameFontNormal")
    completeBtn:SetScript("OnClick", function()
        if not session.currentExercise then return end
        session.completedCount = session.completedCount + 1
        PlayUICue(SOUNDKIT and SOUNDKIT.IG_QUEST_TURN_IN)
        PickExercises(true)
    end)
    f.completeBtn = completeBtn

    local skipBtn = MakeButton(f, 250, 32, 0.24, 0.28, 0.36)
    skipBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 12)
    skipBtn.label:SetFontObject("GameFontNormal")
    skipBtn:SetScript("OnClick", function()
        if not session.currentExercise then return end
        PlayUICue(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
        PickExercises(false)
    end)
    f.skipBtn = skipBtn

    -- =========================================================================
    -- LIVE UPDATE LOOP
    -- =========================================================================
    f:SetScript("OnUpdate", function(_, elapsed)
        if session.inFlight and session.flight then
            local fl = session.flight
            local total = tonumber(fl.totalSeconds) or 0
            local remaining, flown = GetFlightRemaining()

            if total > 0 then
                local frac = math.max(0, math.min(1, flown / total))
                f.flightBar:SetValue(frac)
            else
                -- Unknown duration: gentle pulsing full bar while learning
                f.flightBar:SetValue(1)
            end

            local sec = math.ceil(total > 0 and remaining or flown)
            if sec ~= session.lastSecond then
                session.lastSecond = sec
                if total > 0 then
                    local leftStr = ns.T("FLIGHT_TIME_LEFT", ns.FlightData:FormatTime(remaining))
                    local totalStr = ns.T("FLIGHT_TIME_TOTAL", ns.FlightData:FormatTime(total))
                    f.barText:SetText(leftStr .. "  •  " .. totalStr)
                else
                    f.barText:SetText(ns.T("FLIGHT_ELAPSED", ns.FlightData:FormatTime(flown)))
                end

                if fl.nextStopIndex and fl.stopTimes[fl.nextStopIndex] then
                    while fl.nextStopIndex and flown >= fl.stopTimes[fl.nextStopIndex] do
                        fl.nextStopIndex = fl.stopTimes[fl.nextStopIndex + 1] and (fl.nextStopIndex + 1) or nil
                    end
                end
                if fl.nextStopIndex and fl.stopNames[fl.nextStopIndex] then
                    local stopRem = math.max(0, fl.stopTimes[fl.nextStopIndex] - flown)
                    local stopCoord = fl.stopCoords and fl.stopCoords[fl.nextStopIndex]
                    local stopLabel = ns.FlightData:TranslateNodeName(stopCoord, fl.stopNames[fl.nextStopIndex], fl.continentID)
                    f.nextStopText:SetText(ns.T("FLIGHT_NEXT_STOP", stopLabel, ns.FlightData:FormatTime(stopRem)))
                else
                    f.nextStopText:SetText("")
                end

                if fl.isTest and total > 0 and remaining <= 0 then
                    ns.FlightTracker:EndFlight(false)
                elseif not fl.isTest and flown > 3 and UnitOnTaxi and not UnitOnTaxi("player") then
                    ns.FlightTracker:EndFlight(false)
                end
            end
        end

        -- Timed exercise countdown
        if FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.setupDone
            and session.currentExercise and session.exTimerTotal > 0 and not session.exTimerDone then
            if session.exPrepRemaining > 0 then
                session.exPrepRemaining = math.max(0, session.exPrepRemaining - elapsed)
                exPanel.exTimerText:SetText(ns.T("EX_TIMER_PREP", math.ceil(session.exPrepRemaining)))
                exPanel.exBar:SetValue(1)
            else
                session.exTimerRemaining = math.max(0, session.exTimerRemaining - elapsed)
                exPanel.exBar:SetValue(session.exTimerRemaining / math.max(1, session.exTimerTotal))
                exPanel.exTimerText:SetText(ns.T("EX_TIMER_LEFT", ns.FlightData:FormatTime(session.exTimerRemaining)))
                if session.exTimerRemaining <= 0 then
                    session.exTimerDone = true
                    exPanel.exTimerText:SetText(ns.T("EX_TIMER_DONE"))
                    exPanel.exBar:SetStatusBarColor(0.18, 0.86, 0.46, 1)
                    PlayUICue(SOUNDKIT and SOUNDKIT.ALARM_CLOCK_WARNING_3)
                end
            end
        end
    end)

    f:Hide()
    mainFrame = f
    FitnessFrame:ApplyPosition()
    return f
end

function FitnessFrame:ApplyPosition()
    if not mainFrame then return end
    local db = FitnessExcerciseForeverDB or {}
    mainFrame:ClearAllPoints()
    if db.framePos and db.framePos.a then
        mainFrame:SetPoint(db.framePos.a, UIParent, db.framePos.r or db.framePos.a, db.framePos.x or 0, db.framePos.y or 0)
    else
        mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
    end
end

function FitnessFrame:ResetPosition()
    if FitnessExcerciseForeverDB then
        FitnessExcerciseForeverDB.framePos = nil
    end
    self:ApplyPosition()
end

function FitnessFrame:RefreshSetupPills()
    if not mainFrame then return end
    local sb = mainFrame.setupBox
    local settings = (FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings) or {}
    local eq = settings.equipmentMode or "none"
    local diff = settings.difficulty or "beginner"

    sb.eqLabel:SetText(ns.T("LABEL_EQUIPMENT"))
    sb.eqNoneBtn.label:SetText(ns.T("EQ_NONE"))
    sb.eqNoneBtn:SetSelected(eq == "none")

    sb.eqMixBtn.label:SetText(ns.T("EQ_MIXED"))
    sb.eqMixBtn:SetSelected(eq == "mixed" or eq == "prefer_dumbbells")

    sb.diffLabel:SetText(ns.T("LABEL_DIFFICULTY"))
    for _, pill in ipairs(sb.diffPills) do
        pill.label:SetText(ns.T(pill.locKey))
        pill:SetSelected(diff == pill.diffId)
    end
end

function FitnessFrame:RefreshBarHeader()
    if not mainFrame then return end
    mainFrame.langBtn.label:SetText(ns.GetLang() == "es" and "ES | EN" or "EN | ES")
    mainFrame.testBtn.label:SetText(ns.T("FLIGHT_TEST_BTN"))

    if session.inFlight and session.flight then
        local fl = session.flight
        session.lastSecond = -1
        mainFrame.testBtn:Hide()
        mainFrame.sourceBadge:Show()
        local originLabel = ns.FlightData:TranslateNodeName(fl.originCoord, fl.originName, fl.continentID)
        local destLabel = ns.FlightData:TranslateNodeName(fl.destCoord, fl.destName, fl.continentID)
        mainFrame.routeText:SetText(originLabel .. "  ->  " .. destLabel)
        if fl.isTest then
            mainFrame.sourceBadge:SetText("[" .. ns.T("BADGE_TEST") .. "]")
        elseif fl.source == "distance" or fl.source == "unknown" then
            mainFrame.sourceBadge:SetText("[" .. ns.T("BADGE_EST") .. "]")
        else
            mainFrame.sourceBadge:SetText("[" .. ns.T("BADGE_EXACT") .. "]")
        end
        mainFrame.flightBar:SetStatusBarColor(0.0, 0.72, 0.56, 1)
        PlaceStopTicks()
    elseif session.landed then
        mainFrame.testBtn:Show()
        mainFrame.sourceBadge:Hide()
        mainFrame.flightBar:SetStatusBarColor(0.20, 0.82, 0.42, 1)
        mainFrame.flightBar:SetValue(1)
        mainFrame.barText:SetText(ns.T("FLIGHT_LANDED"))
        mainFrame.nextStopText:SetText("")
    else
        mainFrame.testBtn:Show()
        mainFrame.sourceBadge:Hide()
        mainFrame.routeText:SetText(ns.T("FLIGHT_READY"))
        mainFrame.flightBar:SetStatusBarColor(0.18, 0.24, 0.32, 1)
        mainFrame.flightBar:SetValue(0)
        mainFrame.barText:SetText("00:00")
        mainFrame.nextStopText:SetText("")
        PlaceStopTicks()
    end
end

function FitnessFrame:RenderExerciseArea()
    if not mainFrame then return end
    local setupDone = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.setupDone

    if not setupDone then
        mainFrame.confirmPanel:Show()
        mainFrame.exPanel:Hide()
        mainFrame.completeBtn:Hide()
        mainFrame.skipBtn:Hide()
        mainFrame.confirmPanel.hint:SetText(ns.T("SETUP_HINT"))
        mainFrame.confirmPanel.startBtn.label:SetText(ns.T("BTN_START_EXERCISES"))
        return
    end

    mainFrame.confirmPanel:Hide()
    mainFrame.exPanel:Show()
    mainFrame.completeBtn:Show()
    mainFrame.skipBtn:Show()
    mainFrame.completeBtn.label:SetText(ns.T("BTN_COMPLETE"))
    mainFrame.skipBtn.label:SetText(ns.T("BTN_SKIP"))

    local ep = mainFrame.exPanel
    ep.doneText:SetText(ns.T("EX_DONE_COUNT", session.completedCount))

    local ex = session.currentExercise
    if not ex then
        ep.eqBadge:Hide()
        ep.poseBox:Hide()
        ep.catText:SetText("")
        ep.exTarget:SetText("")
        ep.exBar:Hide()
        ep.exTimerText:Hide()
        ep.nextUpText:SetText("")
        mainFrame.completeBtn:Disable()
        mainFrame.skipBtn:Disable()

        if session.landed then
            ep.exName:SetText(ns.T("EX_LANDED_TITLE"))
            ep.exDesc:SetText(ns.T("EX_LANDED_DESC"))
        elseif session.inFlight then
            ep.exName:SetText(ns.T("EX_APPROACH_TITLE"))
            ep.exDesc:SetText(ns.T("EX_APPROACH_DESC"))
        else
            ep.exName:SetText(ns.T("EX_EMPTY_TITLE"))
            ep.exDesc:SetText(ns.T("EX_EMPTY_DESC"))
        end
        return
    end

    mainFrame.completeBtn:Enable()
    mainFrame.skipBtn:Enable()

    local name = ns.Exercises:GetLocalized(ex)
    local guideText = ns.Exercises:GetDetailedGuide(ex)
    local target = ns.Exercises:FormatPrescription(ex)

    ep.poseBox:Show()
    local l, r, t, b = ns.Exercises:GetPoseTexCoords(ex)
    ep.poseTex:SetTexCoord(l, r, t, b)

    ep.eqBadge:Show()
    if ex.equipment == "dumbbells" then
        ep.eqBadge:SetBackdropColor(0.76, 0.45, 0.08, 1)
        ep.eqBadge.text:SetText(ns.T("EQ_TAG_DB"))
    else
        ep.eqBadge:SetBackdropColor(0.06, 0.52, 0.42, 1)
        ep.eqBadge.text:SetText(ns.T("EQ_TAG_NONE"))
    end

    ep.catText:SetText(ns.T("CAT_" .. string.upper(ex.category or "UPPER")))
    ep.exName:SetText(name)
    ep.exTarget:SetText(target)
    ep.exDesc:SetText(guideText)

    if session.exTimerTotal > 0 then
        ep.exBar:SetStatusBarColor(0.95, 0.72, 0.20, 1)
        ep.exBar:SetValue(1)
        ep.exBar:Show()
        ep.exTimerText:SetText(ns.T("EX_TIMER_PREP", math.ceil(session.exPrepRemaining)))
        ep.exTimerText:Show()
    else
        ep.exBar:Hide()
        ep.exTimerText:Hide()
    end

    if session.nextExercise then
        local nextName = ns.Exercises:GetLocalized(session.nextExercise)
        local nextTarget = ns.Exercises:FormatPrescription(session.nextExercise)
        ep.nextUpText:SetText(ns.T("EX_NEXT_UP", nextName .. " (" .. nextTarget .. ")"))
    else
        ep.nextUpText:SetText("")
    end
end

function FitnessFrame:RefreshAll()
    if not mainFrame then BuildFrame() end
    self:RefreshBarHeader()
    self:RefreshSetupPills()
    self:RenderExerciseArea()
end

function FitnessFrame:OnFlightStart(flightState)
    local f = BuildFrame()
    session.inFlight = true
    session.landed = false
    session.flight = flightState
    session.seenIds = {}
    session.lastCategory = nil
    session.completedCount = 0
    session.lastSecond = -1

    f.flightBar:SetValue(0)
    self:RefreshBarHeader()
    self:RefreshSetupPills()

    if FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.setupDone then
        PickExercises(false)
    else
        self:RenderExerciseArea()
    end

    PlayUICue(SOUNDKIT and SOUNDKIT.IG_QUEST_LOG_OPEN)
    f:Show()
end

function FitnessFrame:OnFlightLanded(cancelled)
    session.inFlight = false
    session.landed = not cancelled
    self:RefreshBarHeader()
    if cancelled and mainFrame then
        mainFrame:Hide()
    end
end

function FitnessFrame:Toggle()
    local f = BuildFrame()
    if f:IsShown() then
        f:Hide()
    else
        self:RefreshAll()
        if FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.setupDone and not session.currentExercise then
            PickExercises(false)
        end
        f:Show()
    end
end

function FitnessFrame:UpdateMinimapPosition()
    if not minimapButton then return end
    local db = FitnessExcerciseForeverDB or {}
    local angle = math.rad(db.minimapAngle or 210)
    local radius = ((Minimap and Minimap:GetWidth()) or 140) / 2 + 5
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
end

function FitnessFrame:Init()
    BuildFrame()
    self:RefreshAll()

    if Minimap then
        local btn = CreateFrame("Button", "FitnessExcerciseForeverMinimapButton", Minimap)
        btn:SetSize(32, 32)
        btn:SetFrameStrata("MEDIUM")
        btn:EnableMouse(true)
        btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        btn:RegisterForDrag("LeftButton")
        btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\AddOns\\FitnessExcerciseForever\\Media\\Logo")
        icon:SetSize(22, 22)
        icon:SetPoint("CENTER")

        local border = btn:CreateTexture(nil, "OVERLAY")
        border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        border:SetSize(54, 54)
        border:SetPoint("TOPLEFT")

        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:AddLine("Fitness Exercise Forever", 0.0, 0.88, 0.72)
            GameTooltip:AddLine(ns.T("TOOLTIP_MINIMAP_1"), 1, 1, 1)
            GameTooltip:AddLine(ns.T("TOOLTIP_MINIMAP_2"), 0.85, 0.85, 0.85)
            GameTooltip:AddLine(ns.T("TOOLTIP_MINIMAP_3"), 0.7, 0.7, 0.7)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        btn:SetScript("OnClick", function(_, button)
            if button == "RightButton" then
                ns.FlightTracker:StartTestFlight(90)
            else
                FitnessFrame:Toggle()
            end
        end)

        local dragging = false
        btn:SetScript("OnDragStart", function() dragging = true end)
        btn:SetScript("OnDragStop", function()
            dragging = false
            FitnessFrame:UpdateMinimapPosition()
        end)
        btn:SetScript("OnUpdate", function()
            if not dragging then return end
            local cx, cy = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            cx, cy = cx / scale, cy / scale
            local mx, my = Minimap:GetCenter()
            if cx and cy and mx and my then
                FitnessExcerciseForeverDB.minimapAngle = math.deg(math.atan2(cy - my, cx - mx))
                FitnessFrame:UpdateMinimapPosition()
            end
        end)

        minimapButton = btn
        self:UpdateMinimapPosition()
    end
end

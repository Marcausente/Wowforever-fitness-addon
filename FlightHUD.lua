local _, ns = ...

local FlightHUD = {}
ns.FlightHUD = FlightHUD

local WHITE = "Interface\\Buttons\\WHITE8X8"
local hudFrame = nil
local stopTicks = {}

local session = {
    active = false,
    landed = false,
    flight = nil,
    currentExercise = nil,
    nextExercise = nil,
    seenIds = {},
    lastCategory = nil,
    completedCount = 0,
    skippedCount = 0,
    exTimerTotal = 0,
    exTimerRemaining = 0,
    exTimerPaused = false,
    exTimerDone = false,
    exPrepRemaining = 0,
    landedAt = nil,
    lastSecond = -1,
    updateAccum = 0,
}

local function PlayUICue(soundId)
    local settings = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings
    if settings and settings.sounds == false then return end
    if PlaySound and soundId then
        pcall(PlaySound, soundId, "SFX")
    end
end

local function CreateHairlineBorder(parent, r, g, b, a)
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
    btn:SetBackdrop({
        bgFile = WHITE,
        edgeFile = WHITE,
        edgeSize = 1,
    })
    btn.baseR, btn.baseG, btn.baseB = r, g, b
    btn:SetBackdropColor(r, g, b, 0.92)
    btn:SetBackdropBorderColor(math.min(1, r + 0.2), math.min(1, g + 0.2), math.min(1, b + 0.2), 0.75)

    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("CENTER")
    text:SetJustifyH("CENTER")
    btn.label = text

    btn:SetScript("OnEnter", function(self)
        if self:IsEnabled() then
            self:SetBackdropColor(math.min(1, self.baseR + 0.12), math.min(1, self.baseG + 0.12), math.min(1, self.baseB + 0.12), 1)
        end
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(self.baseR, self.baseG, self.baseB, 0.92)
    end)
    btn:SetScript("OnDisable", function(self)
        self:SetAlpha(0.45)
    end)
    btn:SetScript("OnEnable", function(self)
        self:SetAlpha(1.0)
    end)

    return btn
end

local function GetFlightRemaining()
    if not session.flight or session.landed then return 0 end
    local elapsed = GetTime() - (session.flight.startTime or GetTime())
    return math.max(0, (session.flight.totalSeconds or 0) - elapsed), elapsed
end

local function RecordExerciseEvent(ex, status)
    if not ex then return end
    local db = FitnessExcerciseForeverDB
    if not db then return end
    local name = ns.Exercises:GetLocalized(ex)

    db.stats = db.stats or {}
    if status == "completed" then
        db.stats.completed = (db.stats.completed or 0) + 1
        db.stats.activeSeconds = (db.stats.activeSeconds or 0) + (ex.estSeconds or 20)
        if ex.equipment == "dumbbells" then
            db.stats.dumbbellCompleted = (db.stats.dumbbellCompleted or 0) + 1
        else
            db.stats.bodyweightCompleted = (db.stats.bodyweightCompleted or 0) + 1
        end
    elseif status == "skipped" then
        db.stats.skipped = (db.stats.skipped or 0) + 1
    end

    db.history = db.history or {}
    table.insert(db.history, 1, {
        status = status,
        id = ex.id,
        name = name,
        prescription = ns.Exercises:FormatPrescription(ex),
        equipment = ex.equipment,
        route = session.flight and ((session.flight.originName or "?") .. " -> " .. (session.flight.destName or "?")) or "",
        timestamp = date and date("%Y-%m-%d %H:%M") or "",
    })
    while #db.history > 120 do
        table.remove(db.history)
    end
end

local function SetupCurrentExerciseTimer(ex)
    session.exTimerTotal = 0
    session.exTimerRemaining = 0
    session.exTimerPaused = false
    session.exTimerDone = false
    session.exPrepRemaining = 0

    if ex and ns.Exercises:IsTimed(ex) then
        local secs = ns.Exercises:GetTimedSeconds(ex)
        session.exTimerTotal = secs
        session.exTimerRemaining = secs
        session.exPrepRemaining = 2.0 -- Brief 2s get-ready moment before countdown begins
    end
end

local function AdvanceExercise(keepNext)
    if session.landed then
        session.landedAt = GetTime()
        session.currentExercise = nil
        session.nextExercise = nil
        FlightHUD:RenderExercise()
        return
    end
    local remaining = GetFlightRemaining()

    if remaining < 12 then
        session.currentExercise = nil
        session.nextExercise = nil
        FlightHUD:RenderExercise()
        return
    end

    local chosen = nil
    if keepNext and session.nextExercise and (session.nextExercise.estSeconds or 20) <= remaining then
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
    SetupCurrentExerciseTimer(chosen)

    -- Pre-select the upcoming exercise so the user sees what's next
    local remainingAfter = remaining - (chosen and (chosen.estSeconds or 20) or 0)
    if chosen and remainingAfter >= 14 then
        local tempSeen = {}
        for k, v in pairs(session.seenIds) do tempSeen[k] = v end
        tempSeen[chosen.id] = true
        session.nextExercise = ns.Exercises:PickNext(remainingAfter, tempSeen, chosen.category)
    else
        session.nextExercise = nil
    end

    FlightHUD:RenderExercise()
end

local function PlaceStopTicks()
    if not hudFrame or not session.flight then return end
    local times = session.flight.stopTimes or {}
    local total = math.max(1, session.flight.totalSeconds or 1)
    local settings = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings or {}
    local fillMode = settings.fillBar ~= false
    local barWidth = hudFrame.flightBar:GetWidth()
    if barWidth <= 0 then barWidth = 356 end

    for i = 1, math.max(#times, #stopTicks) do
        local tick = stopTicks[i]
        if i <= #times then
            if not tick then
                tick = hudFrame.flightBar:CreateTexture(nil, "OVERLAY")
                tick:SetColorTexture(0.05, 0.05, 0.07, 0.9)
                stopTicks[i] = tick
            end
            local frac = math.max(0.02, math.min(0.98, times[i] / total))
            if not fillMode then frac = 1 - frac end
            tick:SetSize(2, 12)
            tick:ClearAllPoints()
            tick:SetPoint("CENTER", hudFrame.flightBar, "LEFT", barWidth * frac, 0)
            tick:Show()
        elseif tick then
            tick:Hide()
        end
    end
end

local function UpdateDumbbellButton()
    if not hudFrame or not hudFrame.dbToggle then return end
    local settings = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings or {}
    local dbOn = (settings.equipmentMode == "mixed" or settings.equipmentMode == "prefer_dumbbells")
    if dbOn then
        hudFrame.dbToggle.baseR, hudFrame.dbToggle.baseG, hudFrame.dbToggle.baseB = 0.72, 0.45, 0.10
        hudFrame.dbToggle:SetBackdropColor(0.72, 0.45, 0.10, 0.95)
        hudFrame.dbToggle:SetBackdropBorderColor(0.95, 0.72, 0.25, 0.85)
        hudFrame.dbToggle.label:SetText(ns.T("BTN_DUMBBELLS_ON"))
    else
        hudFrame.dbToggle.baseR, hudFrame.dbToggle.baseG, hudFrame.dbToggle.baseB = 0.16, 0.20, 0.26
        hudFrame.dbToggle:SetBackdropColor(0.16, 0.20, 0.26, 0.95)
        hudFrame.dbToggle:SetBackdropBorderColor(0.35, 0.42, 0.52, 0.75)
        hudFrame.dbToggle.label:SetText(ns.T("BTN_DUMBBELLS_OFF"))
    end
end

local function BuildHUD()
    if hudFrame then return hudFrame end

    local f = CreateFrame("Frame", "FitnessExcerciseForeverHUD", UIParent, "BackdropTemplate")
    f:SetSize(392, 248)
    f:SetFrameStrata("MEDIUM")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local db = FitnessExcerciseForeverDB
        if db then
            local a, _, r, x, y = self:GetPoint()
            db.hudPos = { a = a, r = r, x = x, y = y }
        end
    end)

    f:SetBackdrop({ bgFile = WHITE })
    f:SetBackdropColor(0.06, 0.07, 0.09, 0.92)
    CreateHairlineBorder(f, 1, 1, 1, 0.14)

    -- Top accent strip
    local accent = f:CreateTexture(nil, "ARTWORK")
    accent:SetPoint("TOPLEFT"); accent:SetPoint("TOPRIGHT")
    accent:SetHeight(2)
    accent:SetColorTexture(0.0, 0.83, 0.67, 0.95)
    f.accent = accent

    -- Header Icon
    local icon = f:CreateTexture(nil, "ARTWORK")
    icon:SetSize(22, 22)
    icon:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
    icon:SetTexture("Interface\\Icons\\Ability_Rogue_Sprint")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    -- Title + Source Tag
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("LEFT", icon, "RIGHT", 8, 1)
    title:SetTextColor(0.0, 0.88, 0.72)
    f.titleText = title

    local sourceBadge = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sourceBadge:SetPoint("LEFT", title, "RIGHT", 6, 0)
    sourceBadge:SetTextColor(0.68, 0.74, 0.82)
    f.sourceBadge = sourceBadge

    -- Close button
    local closeBtn = MakeButton(f, 22, 20, 0.18, 0.18, 0.22)
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -10)
    closeBtn.label:SetText("X")
    closeBtn:SetScript("OnClick", function()
        f:Hide()
    end)

    -- Quick Dumbbell Toggle in header
    local dbToggle = MakeButton(f, 108, 20, 0.16, 0.20, 0.26)
    dbToggle:SetPoint("RIGHT", closeBtn, "LEFT", -6, 0)
    dbToggle:SetScript("OnClick", function()
        local db = FitnessExcerciseForeverDB
        if not db then return end
        db.settings = db.settings or {}
        if db.settings.equipmentMode == "mixed" or db.settings.equipmentMode == "prefer_dumbbells" then
            db.settings.equipmentMode = "none"
        else
            db.settings.equipmentMode = "mixed"
        end
        UpdateDumbbellButton()
        -- If current exercise no longer matches, or user just turned dumbbells on, re-roll cleanly
        if session.active and not session.landed then
            if db.settings.equipmentMode == "none" and session.currentExercise and session.currentExercise.equipment == "dumbbells" then
                AdvanceExercise(false)
            elseif db.settings.equipmentMode ~= "none" then
                AdvanceExercise(false)
            end
        end
        if ns.MainWindow and ns.MainWindow.Refresh then
            ns.MainWindow:Refresh()
        end
    end)
    f.dbToggle = dbToggle

    -- Route + Flight Timer Row
    local routeText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    routeText:SetPoint("TOPLEFT", icon, "BOTTOMLEFT", 0, -8)
    routeText:SetPoint("RIGHT", f, "RIGHT", -96, 0)
    routeText:SetJustifyH("LEFT")
    routeText:SetWordWrap(false)
    routeText:SetTextColor(0.92, 0.94, 0.96)
    f.routeText = routeText

    local flightTimeText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    flightTimeText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, -39)
    flightTimeText:SetJustifyH("RIGHT")
    flightTimeText:SetTextColor(1, 0.86, 0.45)
    f.flightTimeText = flightTimeText

    -- Flight Progress Bar
    local bar = CreateFrame("StatusBar", nil, f)
    bar:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -58)
    bar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, -58)
    bar:SetHeight(12)
    bar:SetStatusBarTexture(WHITE)
    bar:SetStatusBarColor(0.0, 0.78, 0.62, 1)
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(0)
    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetAllPoints()
    bar.bg:SetColorTexture(1, 1, 1, 0.10)

    local spark = bar:CreateTexture(nil, "OVERLAY", nil, 2)
    spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    spark:SetBlendMode("ADD")
    spark:SetSize(20, 26)
    spark:SetPoint("CENTER", bar:GetStatusBarTexture(), "RIGHT")
    f.flightBar = bar
    f.spark = spark

    -- Next Stop Line
    local nextStopText = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    nextStopText:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -4)
    nextStopText:SetPoint("RIGHT", f, "RIGHT", -12, 0)
    nextStopText:SetJustifyH("LEFT")
    nextStopText:SetWordWrap(false)
    f.nextStopText = nextStopText

    -- Exercise Card Container
    local card = CreateFrame("Frame", nil, f, "BackdropTemplate")
    card:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -88)
    card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 46)
    card:SetBackdrop({ bgFile = WHITE })
    card:SetBackdropColor(0.10, 0.12, 0.16, 0.95)
    CreateHairlineBorder(card, 1, 1, 1, 0.10)
    f.card = card

    -- Exercise meta row (Equipment + Category + Done count)
    local eqBadge = CreateFrame("Frame", nil, card, "BackdropTemplate")
    eqBadge:SetSize(92, 18)
    eqBadge:SetPoint("TOPLEFT", card, "TOPLEFT", 10, -8)
    eqBadge:SetBackdrop({ bgFile = WHITE })
    eqBadge.text = eqBadge:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    eqBadge.text:SetPoint("CENTER")
    card.eqBadge = eqBadge

    local metaText = card:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    metaText:SetPoint("LEFT", eqBadge, "RIGHT", 8, 0)
    metaText:SetJustifyH("LEFT")
    card.metaText = metaText

    local doneText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    doneText:SetPoint("TOPRIGHT", card, "TOPRIGHT", -10, -10)
    doneText:SetTextColor(0.55, 0.92, 0.72)
    card.doneText = doneText

    -- Exercise Name & Prescription Target
    local exName = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    exName:SetPoint("TOPLEFT", eqBadge, "BOTTOMLEFT", 0, -8)
    exName:SetPoint("RIGHT", card, "RIGHT", -122, 0)
    exName:SetJustifyH("LEFT")
    exName:SetWordWrap(false)
    exName:SetTextColor(1, 1, 1)
    card.exName = exName

    local exTarget = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    exTarget:SetPoint("TOPRIGHT", card, "TOPRIGHT", -10, -34)
    exTarget:SetJustifyH("RIGHT")
    exTarget:SetTextColor(1, 0.84, 0.35)
    card.exTarget = exTarget

    -- Exercise Description
    local exDesc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    exDesc:SetPoint("TOPLEFT", exName, "BOTTOMLEFT", 0, -6)
    exDesc:SetPoint("RIGHT", card, "RIGHT", -10, 0)
    exDesc:SetJustifyH("LEFT")
    exDesc:SetJustifyV("TOP")
    exDesc:SetTextColor(0.78, 0.82, 0.88)
    card.exDesc = exDesc

    -- Timed exercise sub-bar (visible only for timed exercises)
    local exBar = CreateFrame("StatusBar", nil, card)
    exBar:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 10, 22)
    exBar:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -10, 22)
    exBar:SetHeight(6)
    exBar:SetStatusBarTexture(WHITE)
    exBar:SetStatusBarColor(0.95, 0.70, 0.20, 1)
    exBar:SetMinMaxValues(0, 1)
    exBar.bg = exBar:CreateTexture(nil, "BACKGROUND")
    exBar.bg:SetAllPoints()
    exBar.bg:SetColorTexture(1, 1, 1, 0.12)
    exBar:Hide()
    card.exBar = exBar

    local exTimerText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    exTimerText:SetPoint("BOTTOMLEFT", exBar, "TOPLEFT", 0, 2)
    exTimerText:SetTextColor(1, 0.82, 0.35)
    exTimerText:Hide()
    card.exTimerText = exTimerText

    -- Next Up footer inside card
    local nextUpText = card:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    nextUpText:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 10, 6)
    nextUpText:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -10, 6)
    nextUpText:SetJustifyH("LEFT")
    nextUpText:SetWordWrap(false)
    card.nextUpText = nextUpText

    -- Bottom Action Buttons
    local completeBtn = MakeButton(f, 134, 28, 0.08, 0.56, 0.38)
    completeBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 10)
    completeBtn:SetScript("OnClick", function()
        if not session.currentExercise then return end
        RecordExerciseEvent(session.currentExercise, "completed")
        session.completedCount = session.completedCount + 1
        PlayUICue(SOUNDKIT and SOUNDKIT.IG_QUEST_TURN_IN)
        AdvanceExercise(true)
        if ns.MainWindow and ns.MainWindow.Refresh then ns.MainWindow:Refresh() end
    end)
    f.completeBtn = completeBtn

    local skipBtn = MakeButton(f, 104, 28, 0.25, 0.28, 0.35)
    skipBtn:SetPoint("LEFT", completeBtn, "RIGHT", 8, 0)
    skipBtn:SetScript("OnClick", function()
        if not session.currentExercise then return end
        RecordExerciseEvent(session.currentExercise, "skipped")
        session.skippedCount = session.skippedCount + 1
        PlayUICue(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
        AdvanceExercise(false)
        if ns.MainWindow and ns.MainWindow.Refresh then ns.MainWindow:Refresh() end
    end)
    f.skipBtn = skipBtn

    local rerollBtn = MakeButton(f, 114, 28, 0.16, 0.30, 0.48)
    rerollBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 10)
    rerollBtn:SetScript("OnClick", function()
        PlayUICue(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        if session.landed then
            local bonus = ns.Exercises:PickNext(35, session.seenIds, session.lastCategory)
            if bonus then
                session.seenIds[bonus.id] = true
                session.lastCategory = bonus.category
                ns.Exercises:MarkRecent(bonus.id)
                session.currentExercise = bonus
                session.nextExercise = nil
                SetupCurrentExerciseTimer(bonus)
                FlightHUD:RenderExercise()
            end
            return
        end
        AdvanceExercise(false)
    end)
    f.rerollBtn = rerollBtn

    -- OnUpdate loop for smooth flight bar & timed exercise countdown
    f:SetScript("OnUpdate", function(_, elapsed)
        if not session.active then return end
        session.updateAccum = session.updateAccum + elapsed

        if not session.landed and session.flight then
            local remaining, flown = GetFlightRemaining()
            local total = math.max(1, session.flight.totalSeconds or 1)
            local settings = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings or {}
            local fillMode = settings.fillBar ~= false
            local frac = math.max(0, math.min(1, flown / total))
            if not fillMode then frac = 1 - frac end

            f.flightBar:SetValue(frac)
            f.spark:SetShown(frac > 0.01 and frac < 0.99)

            local sec = math.ceil(remaining)
            if sec ~= session.lastSecond then
                session.lastSecond = sec
                f.flightTimeText:SetText(ns.FlightData:FormatTime(remaining) .. " / " .. ns.FlightData:FormatTime(total))

                -- Update next stop line
                local fl = session.flight
                if fl.nextStopIndex and fl.stopTimes[fl.nextStopIndex] then
                    while fl.nextStopIndex and flown >= fl.stopTimes[fl.nextStopIndex] do
                        fl.nextStopIndex = fl.stopTimes[fl.nextStopIndex + 1] and (fl.nextStopIndex + 1) or nil
                    end
                end
                if fl.nextStopIndex and fl.stopNames[fl.nextStopIndex] then
                    local stopRem = math.max(0, fl.stopTimes[fl.nextStopIndex] - flown)
                    f.nextStopText:SetText(ns.T("HUD_NEXT_STOP", fl.stopNames[fl.nextStopIndex], ns.FlightData:FormatTime(stopRem)))
                else
                    f.nextStopText:SetText("")
                end

                -- If test flight finishes naturally
                if fl.isTest and remaining <= 0 then
                    ns.FlightTracker:EndFlight(false)
                elseif not fl.isTest and flown > 3 and UnitOnTaxi and not UnitOnTaxi("player") then
                    ns.FlightTracker:EndFlight(false)
                end
            end
        elseif session.landed and session.landedAt then
            local settings = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings or {}
            if settings.autoHideOnLand ~= false and (GetTime() - session.landedAt) >= 4.5 then
                if not session.currentExercise then
                    f:Hide()
                    session.active = false
                end
            end
        end

        -- Timed exercise countdown
        if session.currentExercise and session.exTimerTotal > 0 and not session.exTimerDone and not session.exTimerPaused then
            if session.exPrepRemaining > 0 then
                session.exPrepRemaining = math.max(0, session.exPrepRemaining - elapsed)
                f.card.exTimerText:SetText(ns.T("HUD_TIMER_RUNNING", ns.FlightData:FormatTime(session.exTimerRemaining)))
                f.card.exBar:SetValue(1)
            else
                session.exTimerRemaining = math.max(0, session.exTimerRemaining - elapsed)
                f.card.exBar:SetValue(session.exTimerRemaining / math.max(1, session.exTimerTotal))
                f.card.exTimerText:SetText(ns.T("HUD_TIMER_RUNNING", ns.FlightData:FormatTime(session.exTimerRemaining)))
                if session.exTimerRemaining <= 0 then
                    session.exTimerDone = true
                    f.card.exTimerText:SetText(ns.T("HUD_TIMER_DONE"))
                    f.card.exBar:SetStatusBarColor(0.18, 0.85, 0.45, 1)
                    PlayUICue(SOUNDKIT and SOUNDKIT.ALARM_CLOCK_WARNING_3)

                    local settings = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings or {}
                    if settings.autoAdvanceTimed and not session.landed then
                        RecordExerciseEvent(session.currentExercise, "completed")
                        session.completedCount = session.completedCount + 1
                        AdvanceExercise(true)
                        if ns.MainWindow and ns.MainWindow.Refresh then ns.MainWindow:Refresh() end
                    end
                end
            end
        end
    end)

    hudFrame = f
    self:ApplyLayoutSettings()
    return f
end

function FlightHUD:ApplyLayoutSettings()
    if not hudFrame then return end
    local db = FitnessExcerciseForeverDB or {}
    local settings = db.settings or {}

    local scale = tonumber(settings.hudScale) or 1.0
    hudFrame:SetScale(math.max(0.7, math.min(1.5, scale)))

    hudFrame:ClearAllPoints()
    if db.hudPos and db.hudPos.a then
        hudFrame:SetPoint(db.hudPos.a, UIParent, db.hudPos.r or db.hudPos.a, db.hudPos.x or 0, db.hudPos.y or 140)
    else
        hudFrame:SetPoint("TOP", UIParent, "TOP", 0, -90)
    end
end

function FlightHUD:ResetPosition()
    if FitnessExcerciseForeverDB then
        FitnessExcerciseForeverDB.hudPos = nil
    end
    self:ApplyLayoutSettings()
end

function FlightHUD:RefreshRouteInfo()
    if not hudFrame or not session.flight then return end
    local fl = session.flight
    hudFrame.titleText:SetText(ns.T("HUD_TITLE"))

    local badge = ""
    if fl.isTest then
        badge = "[" .. ns.T("HUD_PRACTICE") .. "]"
    elseif fl.source == "distance" then
        badge = "[" .. ns.T("HUD_ESTIMATED") .. "]"
    else
        badge = "[" .. ns.T("HUD_EXACT") .. "]"
    end
    hudFrame.sourceBadge:SetText(badge)
    hudFrame.routeText:SetText((fl.originName or "?") .. "  ->  " .. (fl.destName or "?"))
    hudFrame.completeBtn.label:SetText(ns.T("BTN_COMPLETE"))
    hudFrame.skipBtn.label:SetText(ns.T("BTN_SKIP"))
    hudFrame.rerollBtn.label:SetText(ns.T("BTN_REROLL"))
    UpdateDumbbellButton()
    PlaceStopTicks()
end

function FlightHUD:RenderExercise()
    if not hudFrame then return end
    local card = hudFrame.card
    local ex = session.currentExercise

    card.doneText:SetText(ns.T("HUD_EXERCISES_DONE", session.completedCount))

    if not ex then
        card.eqBadge:Hide()
        card.metaText:SetText("")
        card.exTarget:SetText("")
        card.exBar:Hide()
        card.exTimerText:Hide()
        card.nextUpText:SetText("")

        if session.landed then
            card.exName:SetText(ns.T("HUD_ALL_DONE_TITLE"))
            card.exDesc:SetText(ns.T("HUD_ALL_DONE_DESC"))
        elseif GetFlightRemaining() < 12 then
            card.exName:SetText(ns.T("HUD_TOO_SHORT_TITLE"))
            card.exDesc:SetText(ns.T("HUD_TOO_SHORT_DESC"))
        else
            card.exName:SetText(ns.T("HUD_NO_MATCH_TITLE"))
            card.exDesc:SetText(ns.T("HUD_NO_MATCH_DESC"))
        end
        hudFrame.completeBtn:Disable()
        hudFrame.skipBtn:Disable()
        return
    end

    hudFrame.completeBtn:Enable()
    hudFrame.skipBtn:Enable()

    local name, desc = ns.Exercises:GetLocalized(ex)
    local targetText = ns.Exercises:FormatPrescription(ex)

    card.eqBadge:Show()
    if ex.equipment == "dumbbells" then
        card.eqBadge:SetBackdropColor(0.75, 0.45, 0.08, 0.95)
        card.eqBadge.text:SetText(ns.T("EQ_DUMBBELLS"))
    else
        card.eqBadge:SetBackdropColor(0.08, 0.50, 0.45, 0.95)
        card.eqBadge.text:SetText(ns.T("EQ_NONE"))
    end

    local catKey = "CAT_" .. string.upper(ex.category or "UPPER")
    local diffKey = "DIFF_" .. string.upper(ex.difficulty or "BEGINNER")
    local posKey = "POS_" .. string.upper(ex.position or "STANDING")
    card.metaText:SetText(ns.T(catKey) .. " • " .. ns.T(diffKey) .. " • " .. ns.T(posKey))

    card.exName:SetText(name)
    card.exTarget:SetText(targetText)
    card.exDesc:SetText(desc)

    if session.exTimerTotal > 0 then
        card.exBar:SetStatusBarColor(0.95, 0.70, 0.20, 1)
        card.exBar:SetValue(1)
        card.exBar:Show()
        card.exTimerText:SetText(ns.T("HUD_TIMER_RUNNING", ns.FlightData:FormatTime(session.exTimerRemaining)))
        card.exTimerText:Show()
    else
        card.exBar:Hide()
        card.exTimerText:Hide()
    end

    if session.nextExercise then
        local nextName = ns.Exercises:GetLocalized(session.nextExercise)
        local nextTarget = ns.Exercises:FormatPrescription(session.nextExercise)
        card.nextUpText:SetText(ns.T("HUD_NEXT_UP", nextName .. " (" .. nextTarget .. ")"))
    else
        card.nextUpText:SetText("")
    end
end

function FlightHUD:StartFlight(flightState)
    local f = BuildHUD()
    self:ApplyLayoutSettings()

    session.active = true
    session.landed = false
    session.landedAt = nil
    session.flight = flightState
    session.seenIds = {}
    session.lastCategory = nil
    session.completedCount = 0
    session.skippedCount = 0
    session.lastSecond = -1

    f.flightBar:SetStatusBarColor(0.0, 0.78, 0.62, 1)
    f.flightBar:SetValue(0)
    self:RefreshRouteInfo()
    AdvanceExercise(false)
    PlayUICue(SOUNDKIT and SOUNDKIT.IG_QUEST_LOG_OPEN)
    f:Show()
end

function FlightHUD:OnLanded(cancelled)
    if not hudFrame or not session.active then return end
    session.landed = true
    session.landedAt = GetTime()
    hudFrame.flightBar:SetValue(1)
    hudFrame.flightBar:SetStatusBarColor(0.20, 0.85, 0.42, 1)
    hudFrame.spark:Hide()
    hudFrame.flightTimeText:SetText(ns.T("HUD_LANDED"))
    hudFrame.nextStopText:SetText("")
    if cancelled then
        hudFrame:Hide()
        session.active = false
    end
end

function FlightHUD:RefreshLanguage()
    if not hudFrame or not hudFrame:IsShown() then return end
    self:RefreshRouteInfo()
    self:RenderExercise()
end

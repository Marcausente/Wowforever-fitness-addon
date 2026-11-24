local _, ns = ...

local MainWindow = {}
ns.MainWindow = MainWindow

local WHITE = "Interface\\Buttons\\WHITE8X8"
local mainFrame = nil
local minimapButton = nil
local activeTab = "overview"

local exFilter = {
    equipment = "all", -- "all", "none", "dumbbells"
    category = "all",  -- "all", "upper", "lower", "core", "cardio", "mobility"
    search = "",
}

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

local function MakeFlatButton(parent, width, height, r, g, b)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width, height)
    btn:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    btn.baseR, btn.baseG, btn.baseB = r or 0.16, g or 0.20, b or 0.26
    btn:SetBackdropColor(btn.baseR, btn.baseG, btn.baseB, 0.95)
    btn:SetBackdropBorderColor(0.35, 0.42, 0.50, 0.75)

    local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    fs:SetPoint("CENTER")
    fs:SetJustifyH("CENTER")
    btn.label = fs

    btn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(math.min(1, self.baseR + 0.10), math.min(1, self.baseG + 0.10), math.min(1, self.baseB + 0.10), 1)
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(self.baseR, self.baseG, self.baseB, 0.95)
    end)
    return btn
end

local function MakeOptionPill(parent, width, height, onClick)
    local btn = MakeFlatButton(parent, width, height, 0.13, 0.16, 0.21)
    btn:SetScript("OnClick", onClick)
    function btn:SetSelected(selected)
        if selected then
            self.baseR, self.baseG, self.baseB = 0.06, 0.52, 0.40
            self:SetBackdropColor(0.06, 0.52, 0.40, 0.98)
            self:SetBackdropBorderColor(0.15, 0.88, 0.70, 0.95)
        else
            self.baseR, self.baseG, self.baseB = 0.13, 0.16, 0.21
            self:SetBackdropColor(0.13, 0.16, 0.21, 0.95)
            self:SetBackdropBorderColor(0.30, 0.36, 0.44, 0.70)
        end
    end
    return btn
end

local function MakeCheckbox(parent, onToggle)
    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetSize(24, 24)
    cb.text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    cb.text:SetPoint("LEFT", cb, "RIGHT", 4, 0)
    cb.text:SetJustifyH("LEFT")
    cb:SetScript("OnClick", function(self)
        onToggle(self:GetChecked() and true or false)
    end)
    return cb
end

local function FormatDurationHuman(totalSeconds)
    totalSeconds = math.floor(tonumber(totalSeconds) or 0)
    if totalSeconds < 60 then
        return totalSeconds .. "s"
    end
    local mins = math.floor(totalSeconds / 60)
    local hrs = math.floor(mins / 60)
    if hrs > 0 then
        return string.format("%dh %dm", hrs, mins % 60)
    end
    return string.format("%dm %ds", mins, totalSeconds % 60)
end

-- =============================================================================
-- TAB 1: OVERVIEW
-- =============================================================================
local function BuildOverviewTab(container)
    local panel = CreateFrame("Frame", nil, container)
    panel:SetAllPoints()

    panel.cards = {}
    local cardW, cardH = 166, 68
    for i = 1, 4 do
        local c = CreateFrame("Frame", nil, panel, "BackdropTemplate")
        c:SetSize(cardW, cardH)
        c:SetPoint("TOPLEFT", panel, "TOPLEFT", (i - 1) * (cardW + 10), -4)
        c:SetBackdrop({ bgFile = WHITE })
        c:SetBackdropColor(0.10, 0.13, 0.17, 0.95)
        CreateBorder(c, 1, 1, 1, 0.10)

        c.title = c:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        c.title:SetPoint("TOPLEFT", c, "TOPLEFT", 10, -10)
        c.title:SetPoint("RIGHT", c, "RIGHT", -10, 0)
        c.title:SetJustifyH("LEFT")

        c.value = c:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        c.value:SetPoint("TOPLEFT", c.title, "BOTTOMLEFT", 0, -6)
        c.value:SetTextColor(0.0, 0.88, 0.72)

        c.sub = c:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        c.sub:SetPoint("BOTTOMLEFT", c, "BOTTOMLEFT", 10, 8)
        c.sub:SetTextColor(0.70, 0.76, 0.84)

        panel.cards[i] = c
    end

    -- Quick Setup Card
    local quick = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    quick:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -84)
    quick:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -84)
    quick:SetHeight(212)
    quick:SetBackdrop({ bgFile = WHITE })
    quick:SetBackdropColor(0.09, 0.11, 0.15, 0.95)
    CreateBorder(quick, 1, 1, 1, 0.10)
    panel.quick = quick

    quick.header = quick:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    quick.header:SetPoint("TOPLEFT", quick, "TOPLEFT", 14, -12)
    quick.header:SetTextColor(1, 0.84, 0.42)

    -- Equipment pills
    quick.eqLabel = quick:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    quick.eqLabel:SetPoint("TOPLEFT", quick.header, "BOTTOMLEFT", 0, -12)

    local eqModes = {
        { id = "none", key = "EQ_MODE_NONE", w = 210 },
        { id = "mixed", key = "EQ_MODE_MIXED", w = 200 },
        { id = "prefer_dumbbells", key = "EQ_MODE_PREFER_DB", w = 200 },
    }
    quick.eqPills = {}
    local eqX = 0
    for idx, m in ipairs(eqModes) do
        local p = MakeOptionPill(quick, m.w, 26, function()
            FitnessExcerciseForeverDB.settings.equipmentMode = m.id
            MainWindow:Refresh()
            if ns.FlightHUD and ns.FlightHUD.RefreshLanguage then
                ns.FlightHUD:RefreshLanguage()
            end
        end)
        p:SetPoint("TOPLEFT", quick.eqLabel, "BOTTOMLEFT", eqX, -6)
        p.modeId = m.id
        p.locKey = m.key
        quick.eqPills[idx] = p
        eqX = eqX + m.w + 8
    end

    -- Difficulty pills
    quick.diffLabel = quick:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    quick.diffLabel:SetPoint("TOPLEFT", quick.eqLabel, "BOTTOMLEFT", 0, -46)

    local diffs = {
        { id = "all", key = "DIFF_ALL", w = 148 },
        { id = "beginner", key = "DIFF_BEGINNER", w = 138 },
        { id = "intermediate", key = "DIFF_INTERMEDIATE", w = 138 },
        { id = "advanced", key = "DIFF_ADVANCED", w = 138 },
    }
    quick.diffPills = {}
    local diffX = 0
    for idx, d in ipairs(diffs) do
        local p = MakeOptionPill(quick, d.w, 24, function()
            FitnessExcerciseForeverDB.settings.difficulty = d.id
            MainWindow:Refresh()
        end)
        p:SetPoint("TOPLEFT", quick.diffLabel, "BOTTOMLEFT", diffX, -6)
        p.diffId = d.id
        p.locKey = d.key
        quick.diffPills[idx] = p
        diffX = diffX + d.w + 8
    end

    -- Floor checkbox
    quick.floorCB = MakeCheckbox(quick, function(checked)
        FitnessExcerciseForeverDB.settings.allowFloor = checked
        MainWindow:Refresh()
    end)
    quick.floorCB:SetPoint("TOPLEFT", quick.diffLabel, "BOTTOMLEFT", -2, -40)

    -- Test & Preview Card
    local preview = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    preview:SetPoint("TOPLEFT", quick, "BOTTOMLEFT", 0, -12)
    preview:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
    preview:SetBackdrop({ bgFile = WHITE })
    preview:SetBackdropColor(0.09, 0.11, 0.15, 0.95)
    CreateBorder(preview, 1, 1, 1, 0.10)
    panel.preview = preview

    preview.header = preview:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    preview.header:SetPoint("TOPLEFT", preview, "TOPLEFT", 14, -12)
    preview.header:SetTextColor(1, 0.84, 0.42)

    preview.testShort = MakeFlatButton(preview, 170, 28, 0.08, 0.52, 0.38)
    preview.testShort:SetPoint("TOPLEFT", preview.header, "BOTTOMLEFT", 0, -10)
    preview.testShort:SetScript("OnClick", function()
        ns.FlightTracker:StartTestFlight(90)
    end)

    preview.testLong = MakeFlatButton(preview, 170, 28, 0.14, 0.34, 0.52)
    preview.testLong:SetPoint("LEFT", preview.testShort, "RIGHT", 10, 0)
    preview.testLong:SetScript("OnClick", function()
        ns.FlightTracker:StartTestFlight(240)
    end)

    preview.resetPos = MakeFlatButton(preview, 170, 28, 0.24, 0.26, 0.32)
    preview.resetPos:SetPoint("LEFT", preview.testLong, "RIGHT", 10, 0)
    preview.resetPos:SetScript("OnClick", function()
        ns.FlightHUD:ResetPosition()
        print("|cff00d4aaFEF:|r " .. ns.T("MSG_HUD_RESET"))
    end)

    preview.lastFlightLabel = preview:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    preview.lastFlightLabel:SetPoint("TOPLEFT", preview.testShort, "BOTTOMLEFT", 0, -16)
    preview.lastFlightLabel:SetPoint("RIGHT", preview, "RIGHT", -14, 0)
    preview.lastFlightLabel:SetJustifyH("LEFT")
    preview.lastFlightLabel:SetTextColor(0.75, 0.80, 0.86)

    function panel:Refresh()
        local db = FitnessExcerciseForeverDB or {}
        local stats = db.stats or {}
        local settings = db.settings or {}

        panel.cards[1].title:SetText(ns.T("STAT_FLIGHTS"))
        panel.cards[1].value:SetText(tostring(stats.flights or 0))
        panel.cards[1].sub:SetText("")

        panel.cards[2].title:SetText(ns.T("STAT_COMPLETED"))
        panel.cards[2].value:SetText(tostring(stats.completed or 0))
        panel.cards[2].sub:SetText(ns.T("STAT_SKIPPED") .. ": " .. tostring(stats.skipped or 0))

        panel.cards[3].title:SetText(ns.T("STAT_ACTIVE_TIME"))
        panel.cards[3].value:SetText(FormatDurationHuman(stats.activeSeconds or 0))
        panel.cards[3].sub:SetText("")

        panel.cards[4].title:SetText(ns.T("STAT_DUMBBELL_DONE"))
        panel.cards[4].value:SetText(tostring(stats.dumbbellCompleted or 0))
        panel.cards[4].sub:SetText(ns.T("STAT_BODYWEIGHT_DONE") .. ": " .. tostring(stats.bodyweightCompleted or 0))

        quick.header:SetText(ns.T("QUICK_CONTROLS"))
        quick.eqLabel:SetText(ns.T("SET_EQUIPMENT"))
        for _, p in ipairs(quick.eqPills) do
            p.label:SetText(ns.T(p.locKey))
            p:SetSelected((settings.equipmentMode or "none") == p.modeId)
        end

        quick.diffLabel:SetText(ns.T("SET_DIFFICULTY"))
        for _, p in ipairs(quick.diffPills) do
            p.label:SetText(ns.T(p.locKey))
            p:SetSelected((settings.difficulty or "all") == p.diffId)
        end

        quick.floorCB:SetChecked(settings.allowFloor ~= false)
        quick.floorCB.text:SetText(ns.T("SET_ALLOW_FLOOR"))

        preview.header:SetText(ns.T("PREVIEW_SECTION"))
        preview.testShort.label:SetText(ns.T("BTN_TEST_FLIGHT"))
        preview.testLong.label:SetText(ns.T("BTN_TEST_LONG"))
        preview.resetPos.label:SetText(ns.T("BTN_RESET_POS"))

        if stats.lastFlight and stats.lastFlight.route then
            preview.lastFlightLabel:SetText(
                ns.T("LAST_FLIGHT") .. ": |cffffffff" .. stats.lastFlight.route .. "|r ("
                .. ns.FlightData:FormatTime(stats.lastFlight.seconds or 0) .. " - " .. (stats.lastFlight.timestamp or "") .. ")"
            )
        else
            preview.lastFlightLabel:SetText(ns.T("NO_FLIGHTS_YET"))
        end
    end

    return panel
end

-- =============================================================================
-- TAB 2: EXERCISES
-- =============================================================================
local function BuildExercisesTab(container)
    local panel = CreateFrame("Frame", nil, container)
    panel:SetAllPoints()

    -- Filter bar
    local eqPills = {}
    local eqFilters = {
        { id = "all", key = "CAT_ALL", w = 70 },
        { id = "none", key = "EQ_NONE", w = 96 },
        { id = "dumbbells", key = "EQ_DUMBBELLS", w = 104 },
    }
    local xOff = 0
    for idx, f in ipairs(eqFilters) do
        local p = MakeOptionPill(panel, f.w, 22, function()
            exFilter.equipment = f.id
            panel:Refresh()
        end)
        p:SetPoint("TOPLEFT", panel, "TOPLEFT", xOff, -2)
        p.filterId = f.id
        p.locKey = f.key
        eqPills[idx] = p
        xOff = xOff + f.w + 6
    end

    -- Search box
    local searchBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    searchBox:SetSize(180, 22)
    searchBox:SetPoint("TOPLEFT", panel, "TOPLEFT", xOff + 14, -2)
    searchBox:SetAutoFocus(false)
    local searchPH = searchBox:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    searchPH:SetPoint("LEFT", searchBox, "LEFT", 4, 0)
    searchBox:SetScript("OnTextChanged", function(self)
        local txt = self:GetText() or ""
        searchPH:SetShown(txt == "")
        exFilter.search = txt:lower()
        panel:RefreshList()
    end)

    local enableAllBtn = MakeFlatButton(panel, 118, 22, 0.14, 0.34, 0.30)
    enableAllBtn:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -2)
    enableAllBtn:SetScript("OnClick", function()
        if FitnessExcerciseForeverDB then
            FitnessExcerciseForeverDB.disabledExercises = {}
        end
        panel:Refresh()
    end)

    -- Category filter row
    local catPills = {}
    local catFilters = {
        { id = "all", key = "CAT_ALL", w = 74 },
        { id = "upper", key = "CAT_UPPER", w = 112 },
        { id = "lower", key = "CAT_LOWER", w = 112 },
        { id = "core", key = "CAT_CORE", w = 120 },
        { id = "cardio", key = "CAT_CARDIO", w = 80 },
        { id = "mobility", key = "CAT_MOBILITY", w = 92 },
    }
    local cx = 0
    for idx, c in ipairs(catFilters) do
        local p = MakeOptionPill(panel, c.w, 22, function()
            exFilter.category = c.id
            panel:Refresh()
        end)
        p:SetPoint("TOPLEFT", panel, "TOPLEFT", cx, -30)
        p.catId = c.id
        p.locKey = c.key
        catPills[idx] = p
        cx = cx + c.w + 6
    end

    -- Scroll list of exercises
    local listFrame = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    listFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -58)
    listFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 96)
    listFrame:SetBackdrop({ bgFile = WHITE })
    listFrame:SetBackdropColor(0.08, 0.10, 0.13, 0.95)
    CreateBorder(listFrame, 1, 1, 1, 0.10)

    local scroll = CreateFrame("ScrollFrame", nil, listFrame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", listFrame, "TOPLEFT", 6, -6)
    scroll:SetPoint("BOTTOMRIGHT", listFrame, "BOTTOMRIGHT", -26, 6)

    local scrollChild = CreateFrame("Frame", nil, scroll)
    scrollChild:SetSize(650, 200)
    scroll:SetScrollChild(scrollChild)

    local rows = {}

    local function GetRow(idx)
        if rows[idx] then return rows[idx] end
        local row = CreateFrame("Frame", nil, scrollChild, "BackdropTemplate")
        row:SetSize(650, 34)
        row:SetBackdrop({ bgFile = WHITE })
        row:SetBackdropColor(0.11, 0.14, 0.18, 0.85)

        row.cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
        row.cb:SetSize(22, 22)
        row.cb:SetPoint("LEFT", row, "LEFT", 4, 0)

        row.eqTag = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.eqTag:SetPoint("LEFT", row.cb, "RIGHT", 6, 0)
        row.eqTag:SetWidth(86)
        row.eqTag:SetJustifyH("LEFT")

        row.nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        row.nameText:SetPoint("LEFT", row.eqTag, "RIGHT", 6, 0)
        row.nameText:SetWidth(250)
        row.nameText:SetJustifyH("LEFT")
        row.nameText:SetWordWrap(false)

        row.targetText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.targetText:SetPoint("LEFT", row.nameText, "RIGHT", 8, 0)
        row.targetText:SetWidth(120)
        row.targetText:SetJustifyH("LEFT")
        row.targetText:SetTextColor(1, 0.84, 0.40)

        row.metaText = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        row.metaText:SetPoint("LEFT", row.targetText, "RIGHT", 6, 0)
        row.metaText:SetWidth(90)
        row.metaText:SetJustifyH("LEFT")

        row.delBtn = MakeFlatButton(row, 54, 20, 0.48, 0.16, 0.16)
        row.delBtn:SetPoint("RIGHT", row, "RIGHT", -6, 0)

        rows[idx] = row
        return row
    end

    -- Custom exercise creator at bottom
    local creator = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    creator:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 0)
    creator:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
    creator:SetHeight(88)
    creator:SetBackdrop({ bgFile = WHITE })
    creator:SetBackdropColor(0.09, 0.11, 0.15, 0.95)
    CreateBorder(creator, 1, 1, 1, 0.10)

    creator.title = creator:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    creator.title:SetPoint("TOPLEFT", creator, "TOPLEFT", 10, -8)
    creator.title:SetTextColor(0.0, 0.88, 0.72)

    local nameInput = CreateFrame("EditBox", nil, creator, "InputBoxTemplate")
    nameInput:SetSize(210, 22)
    nameInput:SetPoint("TOPLEFT", creator.title, "BOTTOMLEFT", 4, -8)
    nameInput:SetAutoFocus(false)
    local namePH = nameInput:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    namePH:SetPoint("LEFT", nameInput, "LEFT", 4, 0)
    nameInput:SetScript("OnTextChanged", function(self)
        namePH:SetShown((self:GetText() or "") == "")
    end)

    local amtInput = CreateFrame("EditBox", nil, creator, "InputBoxTemplate")
    amtInput:SetSize(46, 22)
    amtInput:SetPoint("LEFT", nameInput, "RIGHT", 10, 0)
    amtInput:SetAutoFocus(false)
    amtInput:SetNumeric(true)
    amtInput:SetText("12")

    local unitState = "reps"
    local unitBtn = MakeFlatButton(creator, 84, 22, 0.16, 0.20, 0.26)
    unitBtn:SetPoint("LEFT", amtInput, "RIGHT", 6, 0)
    unitBtn:SetScript("OnClick", function()
        unitState = (unitState == "reps") and "seconds" or "reps"
        unitBtn.label:SetText(unitState == "reps" and ns.T("CUSTOM_UNIT_REPS") or ns.T("CUSTOM_UNIT_SECS"))
    end)

    local dbCB = MakeCheckbox(creator, function() end)
    dbCB:SetPoint("LEFT", unitBtn, "RIGHT", 8, 0)

    local addBtn = MakeFlatButton(creator, 130, 24, 0.08, 0.52, 0.38)
    addBtn:SetPoint("TOPRIGHT", creator, "TOPRIGHT", -10, -24)

    local descInput = CreateFrame("EditBox", nil, creator, "InputBoxTemplate")
    descInput:SetSize(510, 20)
    descInput:SetPoint("TOPLEFT", nameInput, "BOTTOMLEFT", 0, -6)
    descInput:SetAutoFocus(false)
    local descPH = descInput:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    descPH:SetPoint("LEFT", descInput, "LEFT", 4, 0)
    descInput:SetScript("OnTextChanged", function(self)
        descPH:SetShown((self:GetText() or "") == "")
    end)

    local statusMsg = creator:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusMsg:SetPoint("LEFT", descInput, "RIGHT", 10, 0)
    statusMsg:SetTextColor(0.4, 0.95, 0.7)

    addBtn:SetScript("OnClick", function()
        local rawName = (nameInput:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if rawName == "" then
            statusMsg:SetText(ns.T("CUSTOM_EMPTY_NAME"))
            return
        end
        local amount = math.max(1, tonumber(amtInput:GetText()) or 10)
        local rawDesc = (descInput:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
        local db = FitnessExcerciseForeverDB
        db.customExercises = db.customExercises or {}
        local id = "custom_" .. tostring(time()) .. "_" .. tostring(#db.customExercises + 1)
        table.insert(db.customExercises, {
            id = id,
            custom = true,
            equipment = dbCB:GetChecked() and "dumbbells" or "none",
            category = (exFilter.category ~= "all") and exFilter.category or "upper",
            difficulty = "beginner",
            position = "standing",
            amount = amount,
            unit = unitState,
            estSeconds = (unitState == "seconds") and amount or math.min(40, math.max(15, amount * 2)),
            en = { name = rawName, desc = rawDesc },
            es = { name = rawName, desc = rawDesc },
        })
        nameInput:SetText("")
        descInput:SetText("")
        statusMsg:SetText(ns.T("CUSTOM_ADDED"))
        panel:RefreshList()
    end)

    function panel:RefreshList()
        local all = ns.Exercises:GetAll()
        local shown = {}
        for _, ex in ipairs(all) do
            local eqOK = (exFilter.equipment == "all") or (ex.equipment == exFilter.equipment)
            local catOK = (exFilter.category == "all") or (ex.category == exFilter.category)
            local exName = ns.Exercises:GetLocalized(ex)
            local searchOK = (exFilter.search == "") or (exName:lower():find(exFilter.search, 1, true) ~= nil)
            if eqOK and catOK and searchOK then
                shown[#shown + 1] = ex
            end
        end

        for _, row in ipairs(rows) do row:Hide() end

        local y = -2
        for idx, ex in ipairs(shown) do
            local row = GetRow(idx)
            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 2, y)
            row:Show()

            local enabled = ns.Exercises:IsEnabled(ex.id)
            row.cb:SetChecked(enabled)
            row.cb:SetScript("OnClick", function(self)
                local db = FitnessExcerciseForeverDB
                db.disabledExercises = db.disabledExercises or {}
                if self:GetChecked() then
                    db.disabledExercises[ex.id] = nil
                else
                    db.disabledExercises[ex.id] = true
                end
            end)

            if ex.equipment == "dumbbells" then
                row.eqTag:SetText("|cffffb84d" .. ns.T("EQ_DUMBBELLS") .. "|r")
            else
                row.eqTag:SetText("|cff4ce6c2" .. ns.T("EQ_NONE") .. "|r")
            end

            local name = ns.Exercises:GetLocalized(ex)
            row.nameText:SetText(name)
            row.targetText:SetText(ns.Exercises:FormatPrescription(ex))
            row.metaText:SetText(ns.T("CAT_" .. string.upper(ex.category or "UPPER")))

            if ex.custom then
                row.delBtn:Show()
                row.delBtn.label:SetText(ns.T("BTN_DELETE"))
                row.delBtn:SetScript("OnClick", function()
                    local list = FitnessExcerciseForeverDB.customExercises or {}
                    for k = #list, 1, -1 do
                        if list[k].id == ex.id then
                            table.remove(list, k)
                        end
                    end
                    panel:RefreshList()
                end)
            else
                row.delBtn:Hide()
            end

            y = y - 37
        end
        scrollChild:SetHeight(math.max(200, -y + 10))
    end

    function panel:Refresh()
        for _, p in ipairs(eqPills) do
            p.label:SetText(ns.T(p.locKey))
            p:SetSelected(exFilter.equipment == p.filterId)
        end
        for _, p in ipairs(catPills) do
            p.label:SetText(ns.T(p.locKey))
            p:SetSelected(exFilter.category == p.catId)
        end
        enableAllBtn.label:SetText(ns.T("BTN_ENABLE_ALL"))
        searchPH:SetText(ns.T("SEARCH_PLACEHOLDER"))
        namePH:SetText(ns.T("CUSTOM_NAME"))
        descPH:SetText(ns.T("CUSTOM_DESC"))
        creator.title:SetText(ns.T("CUSTOM_EX_TITLE"))
        unitBtn.label:SetText(unitState == "reps" and ns.T("CUSTOM_UNIT_REPS") or ns.T("CUSTOM_UNIT_SECS"))
        dbCB.text:SetText(ns.T("CUSTOM_EQ"))
        addBtn.label:SetText(ns.T("BTN_ADD_CUSTOM"))
        self:RefreshList()
    end

    return panel
end

-- =============================================================================
-- TAB 3: HISTORY & ROUTES
-- =============================================================================
local function BuildHistoryTab(container)
    local panel = CreateFrame("Frame", nil, container)
    panel:SetAllPoints()

    local leftBox = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    leftBox:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -4)
    leftBox:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 0)
    leftBox:SetWidth(355)
    leftBox:SetBackdrop({ bgFile = WHITE })
    leftBox:SetBackdropColor(0.09, 0.11, 0.15, 0.95)
    CreateBorder(leftBox, 1, 1, 1, 0.10)

    leftBox.header = leftBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    leftBox.header:SetPoint("TOPLEFT", leftBox, "TOPLEFT", 12, -10)
    leftBox.header:SetTextColor(1, 0.84, 0.42)

    local leftScroll = CreateFrame("ScrollFrame", nil, leftBox, "UIPanelScrollFrameTemplate")
    leftScroll:SetPoint("TOPLEFT", leftBox, "TOPLEFT", 10, -34)
    leftScroll:SetPoint("BOTTOMRIGHT", leftBox, "BOTTOMRIGHT", -28, 10)
    local leftChild = CreateFrame("Frame", nil, leftScroll)
    leftChild:SetSize(310, 200)
    leftScroll:SetScrollChild(leftChild)
    local leftText = leftChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    leftText:SetPoint("TOPLEFT", leftChild, "TOPLEFT", 2, -2)
    leftText:SetWidth(306)
    leftText:SetJustifyH("LEFT")
    leftText:SetSpacing(3)

    local rightBox = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    rightBox:SetPoint("TOPLEFT", leftBox, "TOPRIGHT", 12, 0)
    rightBox:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
    rightBox:SetBackdrop({ bgFile = WHITE })
    rightBox:SetBackdropColor(0.09, 0.11, 0.15, 0.95)
    CreateBorder(rightBox, 1, 1, 1, 0.10)

    rightBox.header = rightBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rightBox.header:SetPoint("TOPLEFT", rightBox, "TOPLEFT", 12, -10)
    rightBox.header:SetTextColor(0.0, 0.88, 0.72)

    local rightScroll = CreateFrame("ScrollFrame", nil, rightBox, "UIPanelScrollFrameTemplate")
    rightScroll:SetPoint("TOPLEFT", rightBox, "TOPLEFT", 10, -34)
    rightScroll:SetPoint("BOTTOMRIGHT", rightBox, "BOTTOMRIGHT", -28, 10)
    local rightChild = CreateFrame("Frame", nil, rightScroll)
    rightChild:SetSize(290, 200)
    rightScroll:SetScrollChild(rightChild)
    local rightText = rightChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    rightText:SetPoint("TOPLEFT", rightChild, "TOPLEFT", 2, -2)
    rightText:SetWidth(286)
    rightText:SetJustifyH("LEFT")
    rightText:SetSpacing(3)

    function panel:Refresh()
        local db = FitnessExcerciseForeverDB or {}
        leftBox.header:SetText(ns.T("HISTORY_RECENT"))

        local history = db.history or {}
        if #history == 0 then
            leftText:SetText(ns.T("HISTORY_NONE"))
        else
            local lines = {}
            for i = 1, math.min(50, #history) do
                local h = history[i]
                local color = (h.status == "completed") and "|cff4ce68c" or "|cffaaaaaa"
                local statusStr = (h.status == "completed") and ns.T("STATUS_COMPLETED") or ns.T("STATUS_SKIPPED")
                local eqStr = (h.equipment == "dumbbells") and " [DB]" or ""
                lines[#lines + 1] = color .. statusStr .. "|r • " .. (h.name or "?") .. " (" .. (h.prescription or "") .. ")" .. eqStr
                if h.route and h.route ~= "" then
                    lines[#lines + 1] = "  |cff7a828e" .. h.route .. " • " .. (h.timestamp or "") .. "|r"
                end
            end
            leftText:SetText(table.concat(lines, "\n"))
        end
        leftChild:SetHeight(math.max(200, leftText:GetStringHeight() + 16))

        local routes = db.routes or {}
        local routeList = {}
        for _, info in pairs(routes) do
            if type(info) == "table" and info.name then
                routeList[#routeList + 1] = info
            end
        end
        table.sort(routeList, function(a, b) return (a.name or "") < (b.name or "") end)

        rightBox.header:SetText(ns.T("HISTORY_ROUTES", #routeList))
        if #routeList == 0 then
            rightText:SetText(ns.T("ROUTES_NONE"))
        else
            local rLines = {}
            for _, r in ipairs(routeList) do
                rLines[#rLines + 1] = "|cffffffff" .. r.name .. "|r — " .. ns.FlightData:FormatTime(r.baseSeconds or 0)
            end
            rightText:SetText(table.concat(rLines, "\n\n"))
        end
        rightChild:SetHeight(math.max(200, rightText:GetStringHeight() + 16))
    end

    return panel
end

-- =============================================================================
-- TAB 4: SETTINGS
-- =============================================================================
local function BuildSettingsTab(container)
    local panel = CreateFrame("Frame", nil, container, "BackdropTemplate")
    panel:SetAllPoints()
    panel:SetBackdrop({ bgFile = WHITE })
    panel:SetBackdropColor(0.09, 0.11, 0.15, 0.95)
    CreateBorder(panel, 1, 1, 1, 0.10)

    local langLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    langLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -16)
    langLabel:SetTextColor(1, 0.84, 0.42)

    local langOptions = {
        { id = "auto", key = "LANG_AUTO", w = 130 },
        { id = "es", key = "LANG_ES", w = 110 },
        { id = "en", key = "LANG_EN", w = 110 },
    }
    local langPills = {}
    local lx = 0
    for idx, opt in ipairs(langOptions) do
        local p = MakeOptionPill(panel, opt.w, 24, function()
            FitnessExcerciseForeverDB.settings.language = opt.id
            MainWindow:Refresh()
            if ns.FlightHUD and ns.FlightHUD.RefreshLanguage then
                ns.FlightHUD:RefreshLanguage()
            end
        end)
        p:SetPoint("TOPLEFT", langLabel, "BOTTOMLEFT", lx, -8)
        p.langId = opt.id
        p.locKey = opt.key
        langPills[idx] = p
        lx = lx + opt.w + 8
    end

    local cbDefs = {
        { key = "allowFloor", loc = "SET_ALLOW_FLOOR" },
        { key = "autoAdvanceTimed", loc = "SET_AUTO_ADVANCE_TIMED" },
        { key = "fillBar", loc = "SET_FILL_BAR" },
        { key = "sounds", loc = "SET_SOUNDS" },
        { key = "showMapTooltip", loc = "SET_TOOLTIP" },
        { key = "autoHideOnLand", loc = "SET_AUTOHIDE" },
        { key = "showMinimap", loc = "SET_MINIMAP" },
    }

    local checkboxes = {}
    local cy = -78
    for idx, def in ipairs(cbDefs) do
        local cb = MakeCheckbox(panel, function(checked)
            FitnessExcerciseForeverDB.settings[def.key] = checked
            if def.key == "showMinimap" then
                MainWindow:UpdateMinimapVisibility()
            end
        end)
        cb:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, cy)
        cb.settingKey = def.key
        cb.locKey = def.loc
        checkboxes[idx] = cb
        cy = cy - 30
    end

    -- HUD Scale Slider
    local scaleLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    scaleLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 18, cy - 10)

    local scaleSlider = CreateFrame("Slider", "FEFHudScaleSlider", panel, "OptionsSliderTemplate")
    scaleSlider:SetSize(220, 16)
    scaleSlider:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -10)
    scaleSlider:SetMinMaxValues(75, 135)
    scaleSlider:SetValueStep(5)
    scaleSlider:SetObeyStepOnDrag(true)
    if FEFHudScaleSliderLow then FEFHudScaleSliderLow:SetText("75%") end
    if FEFHudScaleSliderHigh then FEFHudScaleSliderHigh:SetText("135%") end
    if FEFHudScaleSliderText then FEFHudScaleSliderText:SetText("") end
    scaleSlider:SetScript("OnValueChanged", function(_, value)
        local rounded = math.floor(value + 0.5)
        FitnessExcerciseForeverDB.settings.hudScale = rounded / 100
        scaleLabel:SetText(ns.T("SET_SCALE", rounded))
        if ns.FlightHUD and ns.FlightHUD.ApplyLayoutSettings then
            ns.FlightHUD:ApplyLayoutSettings()
        end
    end)

    -- Bottom action buttons
    local resetPosBtn = MakeFlatButton(panel, 165, 28, 0.20, 0.24, 0.30)
    resetPosBtn:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 16, 16)
    resetPosBtn:SetScript("OnClick", function()
        ns.FlightHUD:ResetPosition()
        print("|cff00d4aaFEF:|r " .. ns.T("MSG_HUD_RESET"))
    end)

    local resetStatsBtn = MakeFlatButton(panel, 180, 28, 0.45, 0.16, 0.16)
    resetStatsBtn:SetPoint("LEFT", resetPosBtn, "RIGHT", 10, 0)
    resetStatsBtn:SetScript("OnClick", function()
        FitnessExcerciseForeverDB.stats = {}
        FitnessExcerciseForeverDB.history = {}
        print("|cff00d4aaFEF:|r " .. ns.T("SET_RESET_CONFIRM"))
        MainWindow:Refresh()
    end)

    function panel:Refresh()
        local settings = (FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings) or {}
        langLabel:SetText(ns.T("SET_LANGUAGE"))
        for _, p in ipairs(langPills) do
            p.label:SetText(ns.T(p.locKey))
            p:SetSelected((settings.language or "auto") == p.langId)
        end

        for _, cb in ipairs(checkboxes) do
            local val = settings[cb.settingKey]
            if cb.settingKey == "autoAdvanceTimed" then
                cb:SetChecked(val == true)
            else
                cb:SetChecked(val ~= false)
            end
            cb.text:SetText(ns.T(cb.locKey))
        end

        local pct = math.floor(((settings.hudScale or 1.0) * 100) + 0.5)
        scaleSlider:SetValue(pct)
        scaleLabel:SetText(ns.T("SET_SCALE", pct))

        resetPosBtn.label:SetText(ns.T("BTN_RESET_POS"))
        resetStatsBtn.label:SetText(ns.T("SET_RESET_STATS"))
    end

    return panel
end

-- =============================================================================
-- MAIN WINDOW & MINIMAP
-- =============================================================================
function MainWindow:SelectTab(tabId)
    activeTab = tabId
    if not mainFrame then return end
    for id, frame in pairs(mainFrame.tabs) do
        frame:SetShown(id == tabId)
    end
    for _, btn in ipairs(mainFrame.tabButtons) do
        btn:SetSelected(btn.tabId == tabId)
    end
    self:Refresh()
end

function MainWindow:Refresh()
    if not mainFrame then return end
    local langBtn = mainFrame.langToggle
    if langBtn then
        langBtn.label:SetText(ns.GetLang() == "es" and "ES | EN" or "EN | ES")
    end
    if mainFrame.taglineText then
        mainFrame.taglineText:SetText(ns.T("TAGLINE"))
    end
    for _, btn in ipairs(mainFrame.tabButtons) do
        btn.label:SetText(ns.T(btn.locKey))
    end
    if mainFrame.tabs[activeTab] and mainFrame.tabs[activeTab].Refresh then
        mainFrame.tabs[activeTab]:Refresh()
    end
end

function MainWindow:Toggle()
    if not mainFrame then self:Build() end
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        self:Refresh()
        mainFrame:Show()
    end
end

function MainWindow:Build()
    if mainFrame then return mainFrame end

    local f = CreateFrame("Frame", "FitnessExcerciseForeverMainFrame", UIParent, "BackdropTemplate")
    f:SetSize(736, 520)
    f:SetPoint("CENTER")
    f:SetFrameStrata("HIGH")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetBackdrop({ bgFile = WHITE })
    f:SetBackdropColor(0.06, 0.07, 0.09, 0.96)
    CreateBorder(f, 1, 1, 1, 0.16)
    table.insert(UISpecialFrames, "FitnessExcerciseForeverMainFrame")

    local accent = f:CreateTexture(nil, "ARTWORK")
    accent:SetPoint("TOPLEFT"); accent:SetPoint("TOPRIGHT")
    accent:SetHeight(2)
    accent:SetColorTexture(0.0, 0.83, 0.67, 0.95)

    local icon = f:CreateTexture(nil, "ARTWORK")
    icon:SetSize(30, 30)
    icon:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -14)
    icon:SetTexture("Interface\\Icons\\Ability_Rogue_Sprint")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, 0)
    title:SetText("FITNESS EXERCISE FOREVER")
    title:SetTextColor(0.0, 0.88, 0.72)

    local tagline = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    tagline:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
    tagline:SetTextColor(0.74, 0.80, 0.86)
    f.taglineText = tagline

    local closeBtn = MakeFlatButton(f, 24, 24, 0.22, 0.18, 0.20)
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, -14)
    closeBtn.label:SetText("X")
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local langToggle = MakeFlatButton(f, 70, 24, 0.14, 0.20, 0.28)
    langToggle:SetPoint("RIGHT", closeBtn, "LEFT", -8, 0)
    langToggle:SetScript("OnClick", function()
        local cur = ns.GetLang()
        FitnessExcerciseForeverDB.settings.language = (cur == "es") and "en" or "es"
        MainWindow:Refresh()
        if ns.FlightHUD and ns.FlightHUD.RefreshLanguage then
            ns.FlightHUD:RefreshLanguage()
        end
    end)
    f.langToggle = langToggle

    -- Tab bar
    local tabDefs = {
        { id = "overview", key = "TAB_OVERVIEW", w = 135 },
        { id = "exercises", key = "TAB_EXERCISES", w = 135 },
        { id = "history", key = "TAB_HISTORY", w = 155 },
        { id = "settings", key = "TAB_SETTINGS", w = 135 },
    }
    f.tabButtons = {}
    local tx = 16
    for idx, td in ipairs(tabDefs) do
        local tb = MakeOptionPill(f, td.w, 28, function()
            MainWindow:SelectTab(td.id)
        end)
        tb:SetPoint("TOPLEFT", f, "TOPLEFT", tx, -56)
        tb.tabId = td.id
        tb.locKey = td.key
        f.tabButtons[idx] = tb
        tx = tx + td.w + 8
    end

    local content = CreateFrame("Frame", nil, f)
    content:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -94)
    content:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)

    f.tabs = {
        overview = BuildOverviewTab(content),
        exercises = BuildExercisesTab(content),
        history = BuildHistoryTab(content),
        settings = BuildSettingsTab(content),
    }

    f:Hide()
    mainFrame = f
    self:SelectTab("overview")
    return f
end

function MainWindow:UpdateMinimapPosition()
    if not minimapButton then return end
    local db = FitnessExcerciseForeverDB or {}
    local angle = math.rad(db.minimapAngle or 210)
    local radius = ((Minimap and Minimap:GetWidth()) or 140) / 2 + 5
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
end

function MainWindow:UpdateMinimapVisibility()
    if not minimapButton then return end
    local settings = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings
    local show = (not settings) or (settings.showMinimap ~= false)
    minimapButton:SetShown(show)
end

function MainWindow:Init()
    self:Build()

    if Minimap then
        local btn = CreateFrame("Button", "FitnessExcerciseForeverMinimapButton", Minimap)
        btn:SetSize(32, 32)
        btn:SetFrameStrata("MEDIUM")
        btn:EnableMouse(true)
        btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        btn:RegisterForDrag("LeftButton")
        btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\Ability_Rogue_Sprint")
        icon:SetSize(20, 20)
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
                MainWindow:Toggle()
            end
        end)

        local dragging = false
        btn:SetScript("OnDragStart", function() dragging = true end)
        btn:SetScript("OnDragStop", function()
            dragging = false
            MainWindow:UpdateMinimapPosition()
        end)
        btn:SetScript("OnUpdate", function()
            if not dragging then return end
            local cx, cy = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            cx, cy = cx / scale, cy / scale
            local mx, my = Minimap:GetCenter()
            if cx and cy and mx and my then
                FitnessExcerciseForeverDB.minimapAngle = math.deg(math.atan2(cy - my, cx - mx))
                MainWindow:UpdateMinimapPosition()
            end
        end)

        minimapButton = btn
        self:UpdateMinimapPosition()
        self:UpdateMinimapVisibility()
    end

    -- Register in native WoW Interface Options
    local opt = CreateFrame("Frame", "FitnessExcerciseForeverOptionsPanel", UIParent)
    opt.name = "Fitness Exercise Forever"
    local optTitle = opt:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    optTitle:SetPoint("TOPLEFT", 16, -16)
    optTitle:SetText("Fitness Exercise Forever")
    local optSub = opt:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    optSub:SetPoint("TOPLEFT", optTitle, "BOTTOMLEFT", 0, -8)
    optSub:SetText(ns.T("TAGLINE"))
    local openBtn = CreateFrame("Button", nil, opt, "UIPanelButtonTemplate")
    openBtn:SetSize(200, 26)
    openBtn:SetPoint("TOPLEFT", optSub, "BOTTOMLEFT", 0, -16)
    openBtn:SetText("/fef")
    openBtn:SetScript("OnClick", function()
        if InterfaceOptionsFrame then InterfaceOptionsFrame:Hide() end
        MainWindow:Toggle()
    end)

    if InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(opt)
    elseif Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local cat = Settings.RegisterCanvasLayoutCategory(opt, opt.name)
        Settings.RegisterAddOnCategory(cat)
    end
end

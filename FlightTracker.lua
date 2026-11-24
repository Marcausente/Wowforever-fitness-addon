local _, ns = ...

local FlightTracker = {}
ns.FlightTracker = FlightTracker

local state = {
    onFlight = false,
    isTest = false,
    startTime = nil,
    totalSeconds = 0,
    baseSeconds = 0,
    frequentFlier = false,
    source = "unknown", -- "recorded", "database", "legs", "distance", "test"
    originName = nil,
    destName = nil,
    routeKey = nil,
    routeNames = {},
    stopNames = {},
    stopTimes = {},
    nextStopIndex = nil,
    earlyLanding = false,
    pending = nil,
}

FlightTracker.state = state

local function GetShortNodeName(slot)
    if not TaxiNodeName then return "?" end
    local raw = TaxiNodeName(slot)
    if type(raw) ~= "string" then return "?" end
    local short = raw:match("^([^,]+)") or raw
    return short:gsub("^%s+", ""):gsub("%s+$", "")
end

local function GetCurrentNodeSlot()
    if not NumTaxiNodes or not TaxiNodeGetType then return nil end
    for i = 1, NumTaxiNodes() do
        if TaxiNodeGetType(i) == "CURRENT" then
            return i
        end
    end
    return nil
end

local function GetNodeCoordKey(slot)
    if not TaxiNodePosition then return "0.00:0.00", 0, 0 end
    local x, y = TaxiNodePosition(slot)
    x = tonumber(x) or 0
    y = tonumber(y) or 0
    return string.format("%0.2f:%0.2f", x, y), x, y
end

local function BuildRoute(currentSlot, destSlot)
    local keys, xs, ys, names = {}, {}, {}, {}

    local function AddSlot(slot)
        if not slot then return end
        local k, x, y = GetNodeCoordKey(slot)
        local idx = #keys + 1
        keys[idx] = k
        xs[idx] = x
        ys[idx] = y
        names[idx] = GetShortNodeName(slot)
    end

    AddSlot(currentSlot)
    if GetNumRoutes and TaxiGetNodeSlot then
        local numHops = GetNumRoutes(destSlot) or 0
        for i = 2, numHops + 1 do
            local hopSlot = TaxiGetNodeSlot(destSlot, i, true)
            if hopSlot then
                AddSlot(hopSlot)
            end
        end
    end

    local destKey = GetNodeCoordKey(destSlot)
    local routeKey = table.concat(keys, ":")
    if not routeKey:find(destKey, 1, true) then
        AddSlot(destSlot)
        routeKey = table.concat(keys, ":")
    end

    return {
        routeKey = routeKey,
        destKey = destKey,
        keys = keys,
        xs = xs,
        ys = ys,
        names = names,
        originName = names[1] or "?",
        destName = GetShortNodeName(destSlot),
    }
end

local function LookupSubRoute(continentData, keys, first, last)
    if not continentData then return nil end
    local parts = {}
    for i = first, last do
        parts[#parts + 1] = keys[i]
    end
    local subKey = table.concat(parts, ":")
    local db = FitnessExcerciseForeverDB
    if db and db.routes and db.routes[subKey] and type(db.routes[subKey].baseSeconds) == "number" then
        return db.routes[subKey].baseSeconds, "recorded"
    end
    local val = continentData[subKey]
    if type(val) == "number" and val > 0 then
        return val, "database"
    end
    return nil
end

local function EstimateRouteDuration(faction, continentID, route)
    local FlightData = ns.FlightData
    local continentData = nil
    if FlightData and faction and continentID then
        local factionData = FlightData:LoadFaction(faction)
        continentData = factionData and factionData[continentID]
    end

    local last = #route.keys
    -- 1. Exact lookup (recorded by player or built-in Forever DB)
    local exact, exactSource = LookupSubRoute(continentData, route.keys, 1, last)
    if exact then
        return exact, exactSource, continentData
    end

    -- 2. Try summing legs if multi-hop
    if last > 2 and continentData then
        local sum = 0
        local allFound = true
        for i = 1, last - 1 do
            local leg = LookupSubRoute(continentData, route.keys, i, i + 1)
            if leg then
                sum = sum + leg
            else
                allFound = false
                break
            end
        end
        if allFound and sum > 0 then
            return sum, "legs", continentData
        end
    end

    -- 3. Distance-based fallback (~900 sec per full map unit)
    local totalDist = 0
    for i = 2, last do
        local dx = (route.xs[i] or 0) - (route.xs[i - 1] or 0)
        local dy = (route.ys[i] or 0) - (route.ys[i - 1] or 0)
        totalDist = totalDist + math.sqrt(dx * dx + dy * dy)
    end
    local est = math.max(20, math.floor(totalDist * 900 + 0.5))
    return est, "distance", continentData
end

local function ComputeStops(continentData, totalSeconds, route, frequentFlier)
    local stopNames, stopTimes = {}, {}
    local last = #route.keys
    if last <= 2 then
        return stopNames, stopTimes
    end

    local speed = frequentFlier and ns.FlightData.FREQUENT_FLIER_SPEED or 1
    local prev = 0
    local valid = true

    for i = 2, last - 1 do
        local stopBase = LookupSubRoute(continentData, route.keys, 1, i)
        if not stopBase then
            local restBase = LookupSubRoute(continentData, route.keys, i, last)
            if restBase then
                stopBase = (totalSeconds * speed) - restBase
            end
        end
        local stopSec = stopBase and (stopBase / speed) or nil
        if not stopSec or stopSec <= prev or stopSec >= totalSeconds then
            valid = false
            break
        end
        stopTimes[i - 1] = stopSec
        prev = stopSec
    end

    if not valid then
        wipe(stopTimes)
        local dist = 0
        for i = 2, last do
            local dx = (route.xs[i] or 0) - (route.xs[i - 1] or 0)
            local dy = (route.ys[i] or 0) - (route.ys[i - 1] or 0)
            dist = dist + math.sqrt(dx * dx + dy * dy)
            if i < last then
                stopTimes[i - 1] = dist
            end
        end
        for i = 1, last - 2 do
            if dist > 0 then
                stopTimes[i] = totalSeconds * (stopTimes[i] / dist)
            else
                stopTimes[i] = totalSeconds * i / (last - 1)
            end
        end
    end

    for i = 2, last - 1 do
        stopNames[i - 1] = route.names[i]
    end

    return stopNames, stopTimes
end

function FlightTracker:BeginFlight(info)
    if state.onFlight and not state.isTest then return end

    state.onFlight = true
    state.isTest = info.isTest and true or false
    state.startTime = GetTime()
    state.totalSeconds = info.totalSeconds
    state.baseSeconds = info.baseSeconds or info.totalSeconds
    state.frequentFlier = info.frequentFlier and true or false
    state.source = info.source or "database"
    state.originName = info.originName or "?"
    state.destName = info.destName or "?"
    state.routeKey = info.routeKey
    state.stopNames = info.stopNames or {}
    state.stopTimes = info.stopTimes or {}
    state.nextStopIndex = state.stopTimes[1] and 1 or nil
    state.earlyLanding = false
    state.pending = nil

    if not state.isTest then
        local routeLabel = state.originName .. " -> " .. state.destName
        print("|cff00d4aaFEF:|r " .. ns.T("MSG_FLIGHT_START", routeLabel, ns.FlightData:FormatTime(state.totalSeconds)))
    end

    if ns.FlightHUD and ns.FlightHUD.StartFlight then
        ns.FlightHUD:StartFlight(state)
    end
end

function FlightTracker:EndFlight(cancelled)
    if not state.onFlight then return end

    local wasTest = state.isTest
    local elapsed = GetTime() - (state.startTime or GetTime())

    if not wasTest and not cancelled and not state.earlyLanding and elapsed >= 5 and state.routeKey then
        local db = FitnessExcerciseForeverDB
        if db then
            db.routes = db.routes or {}
            local normalized = math.floor(elapsed * (state.frequentFlier and ns.FlightData.FREQUENT_FLIER_SPEED or 1) + 0.5)
            local existing = db.routes[state.routeKey]
            local isNew = (existing == nil) and (state.source == "distance")
            db.routes[state.routeKey] = {
                baseSeconds = normalized,
                name = (state.originName or "?") .. " -> " .. (state.destName or "?"),
                lastFlown = date and date("%Y-%m-%d %H:%M") or "",
                count = (existing and existing.count or 0) + 1,
            }
            if isNew then
                print("|cff00d4aaFEF:|r " .. ns.T("MSG_FLIGHT_LEARNED",
                    db.routes[state.routeKey].name,
                    ns.FlightData:FormatTime(elapsed)))
            end

            db.stats = db.stats or {}
            db.stats.flights = (db.stats.flights or 0) + 1
            db.stats.lastFlight = {
                route = db.routes[state.routeKey].name,
                seconds = math.floor(elapsed + 0.5),
                timestamp = date and date("%Y-%m-%d %H:%M") or "",
            }
        end
    end

    state.onFlight = false
    state.isTest = false
    state.pending = nil

    if ns.FlightHUD and ns.FlightHUD.OnLanded then
        ns.FlightHUD:OnLanded(cancelled)
    end
    if ns.MainWindow and ns.MainWindow.Refresh then
        ns.MainWindow:Refresh()
    end
end

function FlightTracker:StartTestFlight(seconds)
    seconds = math.max(15, math.min(1800, tonumber(seconds) or 90))
    local lang = ns.GetLang()
    local origin = (lang == "es") and "Ventormenta" or "Stormwind"
    local stop = (lang == "es") and "Colina del Centinela" or "Sentinel Hill"
    local dest = (lang == "es") and "Bahía del Botín" or "Booty Bay"

    local stopTimes = {}
    local stopNames = {}
    if seconds >= 60 then
        stopNames[1] = stop
        stopTimes[1] = math.floor(seconds * 0.45)
    end

    self:BeginFlight({
        isTest = true,
        totalSeconds = seconds,
        baseSeconds = seconds,
        frequentFlier = false,
        source = "test",
        originName = origin,
        destName = dest,
        routeKey = nil,
        stopNames = stopNames,
        stopTimes = stopTimes,
    })
end

function FlightTracker:Init()
    local evFrame = CreateFrame("Frame")
    evFrame:RegisterEvent("TAXIMAP_OPENED")
    evFrame:RegisterEvent("PLAYER_CONTROL_LOST")
    evFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
    evFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    local mapContext = {}

    evFrame:SetScript("OnEvent", function(_, event)
        if event == "TAXIMAP_OPENED" then
            mapContext.currentSlot = GetCurrentNodeSlot()
            mapContext.continentID = ns.FlightData:GetContinentID()
            mapContext.faction = UnitFactionGroup and UnitFactionGroup("player") or nil

        elseif event == "PLAYER_CONTROL_LOST" then
            if state.pending and (GetTime() - state.pending.clickedAt) < 5 and not state.onFlight then
                FlightTracker:BeginFlight(state.pending)
            end

        elseif event == "PLAYER_CONTROL_GAINED" then
            if state.onFlight and not state.isTest then
                FlightTracker:EndFlight(false)
            end

        elseif event == "PLAYER_ENTERING_WORLD" then
            state.pending = nil
            if state.onFlight and not state.isTest and not (UnitOnTaxi and UnitOnTaxi("player")) then
                FlightTracker:EndFlight(true)
            end
        end
    end)

    if TakeTaxiNode then
        hooksecurefunc("TakeTaxiNode", function(destSlot)
            if UnitAffectingCombat and UnitAffectingCombat("player") then return end
            local currentSlot = GetCurrentNodeSlot() or mapContext.currentSlot
            if not currentSlot or not destSlot or currentSlot == destSlot then return end

            local faction = mapContext.faction or (UnitFactionGroup and UnitFactionGroup("player"))
            local continentID = mapContext.continentID or ns.FlightData:GetContinentID()
            local route = BuildRoute(currentSlot, destSlot)
            local baseSeconds, source, continentData = EstimateRouteDuration(faction, continentID, route)
            local ff = ns.FlightData:HasFrequentFlier()
            local totalSeconds = ff and (baseSeconds / ns.FlightData.FREQUENT_FLIER_SPEED) or baseSeconds
            local stopNames, stopTimes = ComputeStops(continentData, totalSeconds, route, ff)

            state.pending = {
                clickedAt = GetTime(),
                totalSeconds = totalSeconds,
                baseSeconds = baseSeconds,
                frequentFlier = ff,
                source = source,
                originName = route.originName,
                destName = route.destName,
                routeKey = route.routeKey,
                stopNames = stopNames,
                stopTimes = stopTimes,
            }

            -- Fallback confirmation in case PLAYER_CONTROL_LOST fires before/differently
            C_Timer.After(0.6, function()
                if state.pending and not state.onFlight then
                    if UnitOnTaxi and UnitOnTaxi("player") then
                        FlightTracker:BeginFlight(state.pending)
                    elseif (GetTime() - state.pending.clickedAt) > 2 then
                        state.pending = nil
                    end
                end
            end)
        end)
    end

    if TaxiRequestEarlyLanding then
        hooksecurefunc("TaxiRequestEarlyLanding", function()
            if not state.onFlight or state.isTest then return end
            local nextIdx = state.nextStopIndex
            if nextIdx and state.stopTimes[nextIdx] then
                state.earlyLanding = true
                state.totalSeconds = state.stopTimes[nextIdx]
                state.destName = state.stopNames[nextIdx] or state.destName
                for i = #state.stopTimes, nextIdx, -1 do
                    state.stopTimes[i] = nil
                    state.stopNames[i] = nil
                end
                state.nextStopIndex = nil
                if ns.FlightHUD and ns.FlightHUD.RefreshRouteInfo then
                    ns.FlightHUD:RefreshRouteInfo()
                end
            end
        end)
    end

    if TaxiNodeOnButtonEnter then
        hooksecurefunc("TaxiNodeOnButtonEnter", function(button)
            local settings = FitnessExcerciseForeverDB and FitnessExcerciseForeverDB.settings
            if settings and settings.showMapTooltip == false then return end
            local currentSlot = GetCurrentNodeSlot() or mapContext.currentSlot
            local destSlot = button and button.GetID and button:GetID()
            if not currentSlot or not destSlot or currentSlot == destSlot then return end

            local faction = mapContext.faction or (UnitFactionGroup and UnitFactionGroup("player"))
            local continentID = mapContext.continentID or ns.FlightData:GetContinentID()
            local route = BuildRoute(currentSlot, destSlot)
            local baseSeconds, source = EstimateRouteDuration(faction, continentID, route)
            local ff = ns.FlightData:HasFrequentFlier()
            local secs = ff and (baseSeconds / ns.FlightData.FREQUENT_FLIER_SPEED) or baseSeconds
            local formatted = ns.FlightData:FormatTime(secs)
            local ffLabel = ff and ns.T("TOOLTIP_FREQUENT_FLIER") or ""

            if source == "distance" then
                GameTooltip:AddLine("|cff00d4aaFEF|r " .. ns.T("TOOLTIP_FLIGHT_APPROX", formatted) .. ffLabel, 0.85, 0.95, 0.92)
            else
                GameTooltip:AddLine("|cff00d4aaFEF|r " .. ns.T("TOOLTIP_FLIGHT_TIME", formatted) .. ffLabel, 0.4, 0.95, 0.8)
            end

            local fitCount = math.max(1, math.floor(math.max(0, secs - 4) / 25))
            if secs >= 16 then
                GameTooltip:AddLine(ns.T("TOOLTIP_WORKOUT_FIT", fitCount), 0.78, 0.82, 0.88)
            end
            GameTooltip:Show()
        end)
    end

    if AcceptBattlefieldPort then
        hooksecurefunc("AcceptBattlefieldPort", function()
            if state.onFlight and not state.isTest then
                state.earlyLanding = true
            end
        end)
    end
    if C_SummonInfo and C_SummonInfo.ConfirmSummon then
        hooksecurefunc(C_SummonInfo, "ConfirmSummon", function()
            if state.onFlight and not state.isTest then
                state.earlyLanding = true
            end
        end)
    end
end

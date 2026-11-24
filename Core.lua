local addonName, ns = ...

local DEFAULTS = {
    settings = {
        language = "auto",        -- "auto", "es", "en"
        equipmentMode = "none",   -- "none", "mixed", "prefer_dumbbells"
        difficulty = "all",       -- "all", "beginner", "intermediate", "advanced"
        allowFloor = true,
        autoAdvanceTimed = false,
        fillBar = true,
        sounds = true,
        showMapTooltip = true,
        autoHideOnLand = true,
        showMinimap = true,
        hudScale = 1.0,
    },
    routes = {},
    stats = {},
    history = {},
    disabledExercises = {},
    customExercises = {},
    recentExercises = {},
    minimapAngle = 210,
}

local function ApplyDefaults(target, defaults)
    for k, v in pairs(defaults) do
        if type(v) == "table" then
            if type(target[k]) ~= "table" then
                target[k] = {}
            end
            ApplyDefaults(target[k], v)
        elseif target[k] == nil then
            target[k] = v
        end
    end
end

function FitnessExcerciseForever_Compartment()
    if ns.MainWindow then
        ns.MainWindow:Toggle()
    end
end

local function RegisterSlashCommands()
    SLASH_FITNESSEXCERCISEFOREVER1 = "/fef"
    SLASH_FITNESSEXCERCISEFOREVER2 = "/fitness"

    SlashCmdList["FITNESSEXCERCISEFOREVER"] = function(msg)
        msg = (msg or ""):gsub("^%s+", ""):gsub("%s+$", "")
        local cmd, arg = msg:match("^(%S+)%s*(.-)$")
        cmd = cmd and cmd:lower() or ""
        arg = arg and arg:lower() or ""

        if cmd == "" or cmd == "open" or cmd == "config" then
            ns.MainWindow:Toggle()
            return
        end

        if cmd == "test" then
            local secs = tonumber(arg) or 90
            ns.FlightTracker:StartTestFlight(secs)
            return
        end

        if cmd == "dumbbells" or cmd == "mancuernas" then
            local s = FitnessExcerciseForeverDB.settings
            if s.equipmentMode == "none" then
                s.equipmentMode = "mixed"
                print("|cff00d4aaFEF:|r " .. ns.T("BTN_DUMBBELLS_ON"))
            else
                s.equipmentMode = "none"
                print("|cff00d4aaFEF:|r " .. ns.T("BTN_DUMBBELLS_OFF"))
            end
            ns.MainWindow:Refresh()
            ns.FlightHUD:RefreshLanguage()
            return
        end

        if cmd == "lang" or cmd == "idioma" then
            if arg == "es" or arg == "en" or arg == "auto" then
                FitnessExcerciseForeverDB.settings.language = arg
                ns.MainWindow:Refresh()
                ns.FlightHUD:RefreshLanguage()
                print("|cff00d4aaFEF:|r " .. ns.T("LANG_NAME"))
            else
                print("|cff00d4aaFEF:|r /fef lang [es|en|auto]")
            end
            return
        end

        if cmd == "reset" then
            ns.FlightHUD:ResetPosition()
            print("|cff00d4aaFEF:|r " .. ns.T("MSG_HUD_RESET"))
            return
        end

        print("|cff00d4aa" .. ns.T("MSG_HELP_HEADER") .. "|r")
        print("  " .. ns.T("MSG_HELP_1"))
        print("  " .. ns.T("MSG_HELP_2"))
        print("  " .. ns.T("MSG_HELP_3"))
        print("  " .. ns.T("MSG_HELP_4"))
        print("  " .. ns.T("MSG_HELP_5"))
    end
end

local bootFrame = CreateFrame("Frame")
bootFrame:RegisterEvent("ADDON_LOADED")
bootFrame:SetScript("OnEvent", function(self, event, loadedAddon)
    if event == "ADDON_LOADED" and loadedAddon == addonName then
        FitnessExcerciseForeverDB = FitnessExcerciseForeverDB or {}
        ApplyDefaults(FitnessExcerciseForeverDB, DEFAULTS)

        ns.FlightTracker:Init()
        ns.MainWindow:Init()
        RegisterSlashCommands()

        print(ns.T("LOADED_MSG"))
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

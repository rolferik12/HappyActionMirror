-- HappyActionMirror Core Module
if not HappyActionMirror then HappyActionMirror = {} end
HappyActionMirror.version = "1.0.0"

local ADDON_DISPLAY_NAME = "HappyActionMirror"

-- Register slash commands globally
SLASH_HappyActionMirror1 = "/ham"
SLASH_HappyActionMirror2 = "/happyactionmirror"

SlashCmdList["HappyActionMirror"] = function(msg)
    HappyActionMirror:HandleSlashCommand(msg)
end

function HappyActionMirror:Initialize()
    print("|cff00ff00" .. ADDON_DISPLAY_NAME .. "|r v" .. self.version .. " loaded")

    self:LoadSettings()
    self:CreateOptionsPanel()
    self:CreateUI()
    self:RegisterEvents()
    self:UpdateButtonAppearance()
    self:ToggleFrameVisibility()
end

function HappyActionMirror:HandleSlashCommand(msg)
    msg = strtrim((msg or ""):lower())

    if msg == "toggle" or msg == "" then
        HappyActionMirrorDB.enabled = not HappyActionMirrorDB.enabled
        print(ADDON_DISPLAY_NAME .. ": " .. (HappyActionMirrorDB.enabled and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r"))
        self:ToggleFrameVisibility()
    elseif msg == "lock" then
        self:ToggleLock()
    elseif msg == "reset" then
        print(ADDON_DISPLAY_NAME .. ": Position reset to default")
        if self.frame then
            self.frame:ClearAllPoints()
            self.frame:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
            self:SaveSettings()
        end
    elseif msg == "show" then
        print(ADDON_DISPLAY_NAME .. ": Forced show")
        if self.frame then
            self.frame:Show()
        end
    elseif msg == "hide" then
        if self.frame then
            self.frame:Hide()
        end
    elseif msg == "status" then
        self:PrintStatus()
    elseif msg == "help" or msg == "?" then
        self:PrintHelp()
    else
        print(ADDON_DISPLAY_NAME .. ": Unknown command '" .. msg .. "'. Type /ham help for available commands.")
    end
end

function HappyActionMirror:PrintStatus()
    print(ADDON_DISPLAY_NAME .. ": Current status")
    print("  enabled=" .. tostring(HappyActionMirrorDB.enabled) ..
    " locked=" .. tostring(HappyActionMirrorDB.locked) ..
    " mounted=" .. tostring(HappyActionMirrorDB.showWhenMounted) ..
    " travel=" .. tostring(HappyActionMirrorDB.showWhenTravelForm) ..
    " override=" .. tostring(HappyActionMirrorDB.showWhenOverride))
end

function HappyActionMirror:PrintHelp()
    print("|cff00ff00" .. ADDON_DISPLAY_NAME .. "|r - Action Bar Display Addon")
    print("Available commands:")
    print("  /ham or /happyactionmirror - Show help")
    print("  /ham toggle - Toggle addon on/off")
    print("  /ham lock - Lock/unlock frame for moving")
    print("  /ham reset - Reset position to default")
    print("  /ham show - Force show the bar (for testing)")
    print("  /ham hide - Force hide the bar")
    print("  /ham status - Show current status")
    print("  /ham help - Show this help message")
end

-- Initialize addon when ready
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, name)
    if name == "HappyActionMirror" or name == "HappyActionMirror" then
        HappyActionMirror:Initialize()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)


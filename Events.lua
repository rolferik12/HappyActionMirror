-- HappyActionMirror Events Module
if not HappyActionMirror then HappyActionMirror = {} end

local VISIBILITY_EVENTS = {
    PLAYER_ENTERING_WORLD = true,
    UPDATE_BONUS_ACTIONBAR = true,
    UPDATE_OVERRIDE_ACTIONBAR = true,
}

local APPEARANCE_EVENTS = {
    ACTION_SLOT_CHANGED = true,
    ACTIONBAR_SLOT_CONTENTS_CHANGED = true,
    ACTIONBAR_UPDATE_COOLDOWN = true,
    ACTIONBAR_UPDATE_USABLE = true,
    ACTIONBAR_UPDATE_STATE = true,
    SPELL_UPDATE_COOLDOWN = true,
    SPELL_UPDATE_USABLE = true,
    SPELL_UPDATE_CHARGES = true,
    UPDATE_BINDINGS = true,
    UPDATE_BONUS_ACTIONBAR = true,
    UPDATE_OVERRIDE_ACTIONBAR = true,
}

local function ShouldUpdateVisibility(event)
    return VISIBILITY_EVENTS[event] == true
end

local function ShouldUpdateAppearance(event)
    return APPEARANCE_EVENTS[event] == true
end

function HappyActionMirror:RegisterEvents()
    local eventFrame = CreateFrame("Frame", "HappyActionMirrorEventFrame")

    eventFrame:SetScript("OnEvent", function(self, event, ...)
        HappyActionMirror:OnEvent(event, ...)
    end)

    local eventsToRegister = {
        "PLAYER_ENTERING_WORLD",
        "UPDATE_BONUS_ACTIONBAR",
        "UPDATE_OVERRIDE_ACTIONBAR",
        "ACTION_SLOT_CHANGED",
        "ACTIONBAR_SLOT_CONTENTS_CHANGED",
        "ACTIONBAR_UPDATE_COOLDOWN",
        "ACTIONBAR_UPDATE_USABLE",
        "ACTIONBAR_UPDATE_STATE",
        "SPELL_UPDATE_COOLDOWN",
        "SPELL_UPDATE_USABLE",
        "SPELL_UPDATE_CHARGES",
        "UPDATE_BINDINGS",
    }

    for _, eventName in ipairs(eventsToRegister) do
        local ok, err = pcall(eventFrame.RegisterEvent, eventFrame, eventName)
        if not ok then
            print("HappyActionMirror: Failed to register event " .. eventName .. " (" .. tostring(err) .. ")")
        end
    end

    -- Safety polling for edge cases where events are delayed.
    eventFrame.visibilityCheckTimer = 0
    eventFrame.buttonRefreshTimer = 0
    eventFrame:SetScript("OnUpdate", function(self, elapsed)
        self.visibilityCheckTimer = self.visibilityCheckTimer + elapsed
        self.buttonRefreshTimer = self.buttonRefreshTimer + elapsed

        if self.visibilityCheckTimer >= 0.25 then
            self.visibilityCheckTimer = 0
            HappyActionMirror:ToggleFrameVisibility()
        end

        if self.buttonRefreshTimer >= 0.1 then
            self.buttonRefreshTimer = 0
            HappyActionMirror:UpdateButtonAppearance()
        end
    end)

    self.eventFrame = eventFrame
end

function HappyActionMirror:OnEvent(event, ...)
    if ShouldUpdateVisibility(event) then
        self:ToggleFrameVisibility()
    end

    if ShouldUpdateAppearance(event) then
        self:UpdateButtonAppearance()
    end
end


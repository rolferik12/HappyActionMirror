-- HappyActionMirror Action Bar State Helpers
if not HappyActionMirror then HappyActionMirror = {} end

local BONUS_ACTION_SLOTS = {
    121, 122, 123, 124, 125, 126,
    127, 128, 129, 130, 131, 132,
}

local OVERRIDE_ACTION_SLOTS = {
    205, 206, 207, 208, 209, 210,
    211, 212, 213, 214, 215, 216,
}

local function IsDruidTravelFormActive()
    local formID = GetShapeshiftFormID()
    if not formID then
        return false
    end

    return formID == 27
end

local function HasActiveBonusBar()
    return C_ActionBar and C_ActionBar.HasBonusActionBar and C_ActionBar.HasBonusActionBar() or false
end

local function HasActiveOverrideBar()
    return C_ActionBar and C_ActionBar.HasOverrideActionBar and C_ActionBar.HasOverrideActionBar() or false
end

function HappyActionMirror:GetCurrentBarMode()
    if HasActiveOverrideBar() then
        return "override"
    end

    if HasActiveBonusBar() then
        return "bonus"
    end

    return nil
end

function HappyActionMirror:GetActionSlotsForMode(mode)
    if mode == "override" then
        return OVERRIDE_ACTION_SLOTS
    end

    return BONUS_ACTION_SLOTS
end

function HappyActionMirror:GetSourceButtonForMode(mode, index)
    if mode == "bonus" then
        return _G["BonusActionButton" .. index]
    end

    return nil
end

function HappyActionMirror:IsActionEmpty(mode, actionSlot, texture)
    if mode == "override" then
        local actionType = GetActionInfo(actionSlot)
        return not actionType or not texture
    end

    return not HasAction(actionSlot)
end

function HappyActionMirror:ShouldShowFrame()
    if not HappyActionMirrorDB.enabled then
        return false
    end

    if not HappyActionMirrorDB.locked then
        return true
    end

    local isMounted = IsMounted() and true or false
    local isDruidTravelForm = IsDruidTravelFormActive()
    local showBonusBar = HasActiveBonusBar() and (
        (HappyActionMirrorDB.showWhenMounted and isMounted)
        or (HappyActionMirrorDB.showWhenTravelForm and isDruidTravelForm)
    )
    local showOverrideBar = HappyActionMirrorDB.showWhenOverride and HasActiveOverrideBar()

    return showOverrideBar or showBonusBar
end

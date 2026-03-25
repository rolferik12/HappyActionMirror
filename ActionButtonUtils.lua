-- HappyActionMirror Action Button Helpers
if not HappyActionMirror then HappyActionMirror = {} end

local function FormatBindingText(key)
    if not key or key == "" then
        return ""
    end

    local text = GetBindingText(key, "KEY_") or key
    text = text:gsub("SHIFT%-", "S-")
    text = text:gsub("CTRL%-", "C-")
    text = text:gsub("ALT%-", "A-")
    text = text:gsub("NUMPAD", "N")
    return text
end

local function SetButtonCooldown(button, start, duration, enable, modRate)
    if not button.cooldown then
        return
    end

    if start and duration and duration > 0 then
        if button.cooldown.SetCooldown then
            button.cooldown:SetCooldown(start, duration, modRate or 1)
        else
            CooldownFrame_Set(button.cooldown, start, duration, enable, true, modRate)
        end
        button.cooldown:Show()
    else
        if button.cooldown.SetCooldown then
            button.cooldown:SetCooldown(0, 0, 1)
        else
            CooldownFrame_Set(button.cooldown, 0, 0, 0)
        end
        button.cooldown:Hide()
    end
end

function HappyActionMirror:GetPrimaryActionBinding(index)
    local command = "ACTIONBUTTON" .. index
    local key1 = GetBindingKey(command)
    return FormatBindingText(key1)
end

function HappyActionMirror:ClearButtonState(button)
    button.icon:SetTexture(nil)
    button.icon:Hide()
    button.countText:SetText("")

    if button.cooldown then
        if button.cooldown.SetCooldown then
            button.cooldown:SetCooldown(0, 0, 1)
        else
            CooldownFrame_Set(button.cooldown, 0, 0, 0)
        end
        button.cooldown:Hide()
    end
end

function HappyActionMirror:UpdateButtonCount(button, actionSlot, sourceButton)
    local charges, maxCharges = GetActionCharges(actionSlot)
    if maxCharges and maxCharges > 1 and charges then
        button.countText:SetText(charges)
        return
    end

    local countText = nil
    if sourceButton and sourceButton.Count then
        countText = sourceButton.Count:GetText()
    end

    if countText and countText ~= "" then
        button.countText:SetText(countText)
        return
    end

    local count = GetActionCount(actionSlot)
    if count and count > 1 then
        button.countText:SetText(count)
    else
        button.countText:SetText("")
    end
end

function HappyActionMirror:UpdateButtonCooldown(button, actionSlot)
    local charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(actionSlot)
    local start, duration, enable, modRate = GetActionCooldown(actionSlot)

    if maxCharges and maxCharges > 1 and charges and charges < maxCharges and chargeStart and chargeDuration and chargeDuration > 0 then
        start = chargeStart
        duration = chargeDuration
        enable = 1
        modRate = chargeModRate or modRate
    end

    SetButtonCooldown(button, start, duration, enable, modRate)
end

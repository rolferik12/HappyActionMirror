-- HappyActionMirror UI Module
if not HappyActionMirror then HappyActionMirror = {} end

local BUTTON_SIZE = 36
local BUTTON_SPACING = 40
local FRAME_HORIZONTAL_PADDING = 8
local BASE_FRAME_HEIGHT = 52
local UNLOCKED_HEADER_HEIGHT = 14
local LOCKED_BUTTON_TOP_OFFSET = -8
local UNLOCKED_LOCK_ICON_SIZE = 16

function HappyActionMirror:UpdateLockIndicator()
    if not self.frame or not self.frame.buttonContainer then
        return
    end

    local isLocked = HappyActionMirrorDB.locked and true or false
    local topOffset = LOCKED_BUTTON_TOP_OFFSET
    local frameHeight = BASE_FRAME_HEIGHT

    if not isLocked then
        topOffset = LOCKED_BUTTON_TOP_OFFSET - UNLOCKED_HEADER_HEIGHT
        frameHeight = BASE_FRAME_HEIGHT + UNLOCKED_HEADER_HEIGHT
        if self.frame.unlockIndicator then
            self.frame.unlockIndicator:Show()
        end
        if self.frame.unlockLockButton then
            self.frame.unlockLockButton:Show()
        end
    else
        if self.frame.unlockIndicator then
            self.frame.unlockIndicator:Hide()
        end
        if self.frame.unlockLockButton then
            self.frame.unlockLockButton:Hide()
        end
    end

    self.frame:SetHeight(frameHeight)
    self.frame.buttonContainer:ClearAllPoints()
    self.frame.buttonContainer:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 4, topOffset)
end

function HappyActionMirror:CreateUI()
    local frame = CreateFrame("Frame", "HappyActionMirrorFrame", UIParent)
    frame:SetWidth(488)
    frame:SetHeight(BASE_FRAME_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", HappyActionMirrorDB.positionX or 0, HappyActionMirrorDB.positionY or -100)

    local bgTexture = frame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints(frame)
    bgTexture:SetColorTexture(0, 0, 0, 0.7)

    local borderColor = {0.5, 0.5, 0.5, 1}
    local topBorder = frame:CreateTexture(nil, "BACKGROUND")
    topBorder:SetPoint("TOPLEFT", frame, "TOPLEFT")
    topBorder:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
    topBorder:SetHeight(2)
    topBorder:SetColorTexture(unpack(borderColor))
    
    local bottomBorder = frame:CreateTexture(nil, "BACKGROUND")
    bottomBorder:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
    bottomBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
    bottomBorder:SetHeight(2)
    bottomBorder:SetColorTexture(unpack(borderColor))
    
    local leftBorder = frame:CreateTexture(nil, "BACKGROUND")
    leftBorder:SetPoint("TOPLEFT", frame, "TOPLEFT")
    leftBorder:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
    leftBorder:SetWidth(2)
    leftBorder:SetColorTexture(unpack(borderColor))
    
    local rightBorder = frame:CreateTexture(nil, "BACKGROUND")
    rightBorder:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
    rightBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
    rightBorder:SetWidth(2)
    rightBorder:SetColorTexture(unpack(borderColor))

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame:SetScript("OnDragStart", function(self)
        if not HappyActionMirrorDB.locked then
            self:StartMoving()
        end
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        HappyActionMirror:SaveSettings()
    end)

    local buttonContainer = CreateFrame("Frame", "HappyActionMirrorButtonContainer", frame)
    buttonContainer:SetWidth(480)
    buttonContainer:SetHeight(36)
    buttonContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, LOCKED_BUTTON_TOP_OFFSET)
    frame.buttonContainer = buttonContainer

    local unlockIndicator = CreateFrame("Frame", nil, frame)
    unlockIndicator:SetSize(140, 12)
    unlockIndicator:SetPoint("TOP", frame, "TOP", 0, -3)

    local unlockIcon = unlockIndicator:CreateTexture(nil, "OVERLAY")
    unlockIcon:SetSize(10, 10)
    unlockIcon:SetPoint("LEFT", unlockIndicator, "LEFT", 0, 0)
    unlockIcon:SetTexture("Interface\\Buttons\\UI-Panel-UnlockButton-Up")

    local unlockText = unlockIndicator:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    unlockText:SetPoint("LEFT", unlockIcon, "RIGHT", 4, 0)
    unlockText:SetText("UNLOCKED - Drag to Move")
    unlockText:SetTextColor(1, 0.82, 0.1, 1)

    frame.unlockIndicator = unlockIndicator

    local unlockLockButton = CreateFrame("Button", nil, frame)
    unlockLockButton:SetSize(UNLOCKED_LOCK_ICON_SIZE, UNLOCKED_LOCK_ICON_SIZE)
    unlockLockButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -2)
    unlockLockButton:SetNormalTexture("Interface\\AddOns\\HappyActionMirror\\Textures\\OpenLock")
    unlockLockButton:SetPushedTexture("Interface\\AddOns\\HappyActionMirror\\Textures\\OpenLock")
    unlockLockButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

    local unlockCircle = unlockLockButton:GetNormalTexture()
    if unlockCircle then
        unlockCircle:SetVertexColor(1, 1, 1, 1)
    end

    local pushedCircle = unlockLockButton:GetPushedTexture()
    if pushedCircle then
        pushedCircle:SetVertexColor(1, 1, 1, 1)
    end

    local highlightCircle = unlockLockButton:GetHighlightTexture()
    if highlightCircle then
        highlightCircle:SetBlendMode("ADD")
        highlightCircle:SetVertexColor(1, 1, 1, 0.35)
    end

    unlockLockButton:SetScript("OnClick", function()
        HappyActionMirror:SetLocked(true)
    end)
    unlockLockButton:SetScript("OnEnter", function(self)
        if unlockCircle then
            unlockCircle:SetVertexColor(1, 0.3, 0.3, 1)
        end
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Lock Frame")
        GameTooltip:AddLine("Click to lock this frame in place.", 0.9, 0.9, 0.9)
        GameTooltip:Show()
    end)
    unlockLockButton:SetScript("OnLeave", function()
        if unlockCircle then
            unlockCircle:SetVertexColor(1, 0.2, 0.2, 1)
        end
        GameTooltip:Hide()
    end)
    frame.unlockLockButton = unlockLockButton

    frame:SetScale(HappyActionMirrorDB.scale or 1.0)
    frame:SetAlpha(HappyActionMirrorDB.alpha or 1.0)
    frame:Hide()

    self.frame = frame
    self:UpdateLockIndicator()
    self:PopulateButtons()
end

function HappyActionMirror:PopulateButtons()
    if not self.frame or not self.frame.buttonContainer then
        return
    end

    local buttonContainer = self.frame.buttonContainer
    buttonContainer.buttons = buttonContainer.buttons or {}

    for i = 1, #buttonContainer.buttons do
        if buttonContainer.buttons[i] then
            buttonContainer.buttons[i]:Hide()
            buttonContainer.buttons[i] = nil
        end
    end

    for i = 1, 12 do
        buttonContainer.buttons[i] = self:CreateActionBarButton(buttonContainer, i)
    end

    self:UpdateButtonAppearance()
end

function HappyActionMirror:CreateActionBarButton(parent, index)
    local button = CreateFrame("Frame", nil, parent)
    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", (index - 1) * BUTTON_SPACING, 0)

    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(0.2, 0.2, 0.2, 0.9)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

    local topBorder = button:CreateTexture(nil, "OVERLAY")
    topBorder:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
    topBorder:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, 0)
    topBorder:SetHeight(1)
    topBorder:SetColorTexture(0.55, 0.55, 0.55, 1)

    local bottomBorder = button:CreateTexture(nil, "OVERLAY")
    bottomBorder:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)
    bottomBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
    bottomBorder:SetHeight(1)
    bottomBorder:SetColorTexture(0.55, 0.55, 0.55, 1)

    local leftBorder = button:CreateTexture(nil, "OVERLAY")
    leftBorder:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
    leftBorder:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)
    leftBorder:SetWidth(1)
    leftBorder:SetColorTexture(0.55, 0.55, 0.55, 1)

    local rightBorder = button:CreateTexture(nil, "OVERLAY")
    rightBorder:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, 0)
    rightBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
    rightBorder:SetWidth(1)
    rightBorder:SetColorTexture(0.55, 0.55, 0.55, 1)

    local countText = button:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    countText:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

    local hotkeyText = button:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    hotkeyText:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2)
    hotkeyText:SetTextColor(1, 0.82, 0, 1)

    local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
    cooldown:SetAllPoints(button)
    cooldown:SetReverse(false)

    button.icon = icon
    button.action = index
    button.liveAction = index
    button.liveSourceButton = nil
    button.countText = countText
    button.hotkeyText = hotkeyText
    button.cooldown = cooldown
    button.sourceButtonName = "BonusActionButton" .. index
    button:EnableMouse(true)
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnEnter", function(self)
        if self.liveSourceButton then
            local onEnter = self.liveSourceButton:GetScript("OnEnter")
            if type(onEnter) == "function" then
                onEnter(self.liveSourceButton)
                return
            end
        end

        if not self.liveAction then
            return
        end

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetAction(self.liveAction)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    button:SetScript("OnDragStart", function()
        if not HappyActionMirrorDB.locked and HappyActionMirror.frame then
            HappyActionMirror.frame:StartMoving()
        end
    end)
    button:SetScript("OnDragStop", function()
        if HappyActionMirror.frame then
            HappyActionMirror.frame:StopMovingOrSizing()
            HappyActionMirror:SaveSettings()
        end
    end)

    return button
end

function HappyActionMirror:UpdateButtonAppearance()
    if self.inCombat then
        return
    end
    if not self.frame or not self.frame.buttonContainer or not self.frame.buttonContainer.buttons then
        return
    end

    self:UpdateLockIndicator()

    local mode = self:GetCurrentBarMode()
    local visibleIndex = 0
    for i, button in ipairs(self.frame.buttonContainer.buttons) do
        if self:UpdateSingleButton(button, i, mode) then
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", self.frame.buttonContainer, "TOPLEFT", visibleIndex * BUTTON_SPACING, 0)
            button:Show()
            visibleIndex = visibleIndex + 1
        else
            button:Hide()
        end
    end

    local visibleCount = math.max(visibleIndex, 1)
    local containerWidth = visibleCount * BUTTON_SPACING
    self.frame.buttonContainer:SetWidth(containerWidth)
    self.frame:SetWidth(containerWidth + FRAME_HORIZONTAL_PADDING)
end

function HappyActionMirror:UpdateSingleButton(button, action, mode)
    if not button then
        return false
    end

    local activeMode = mode or self:GetCurrentBarMode()
    local actionSlots = self:GetActionSlotsForMode(activeMode)
    local liveAction = actionSlots[action] or action
    local sourceButton = self:GetSourceButtonForMode(activeMode, action)
    local texture = nil

    if sourceButton then
        if sourceButton.icon then
            texture = sourceButton.icon:GetTexture()
        end
    end

    button.liveAction = liveAction
    button.liveSourceButton = sourceButton
    if button.hotkeyText then
        button.hotkeyText:SetText(self:GetPrimaryActionBinding(action))
    end

    if not texture then
        texture = GetActionTexture(liveAction)
    end

    if self:IsActionEmpty(activeMode, liveAction, texture) then
        self:ClearButtonState(button)
        return false
    end

    if texture then
        button.icon:SetTexture(texture)
        button.icon:Show()
    else
        button.icon:SetTexture(nil)
        button.icon:Hide()
    end

    self:UpdateButtonCount(button, liveAction, sourceButton)
    self:UpdateButtonCooldown(button, liveAction)

    if sourceButton and sourceButton.icon then
        local r, g, b, a = sourceButton.icon:GetVertexColor()
        button.icon:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
    elseif texture then
        button.icon:SetVertexColor(1, 1, 1, 1)
    end

    return true
end

function HappyActionMirror:ToggleFrameVisibility()
    if not self.frame then
        return
    end
    if self.inCombat then
        self.frame:Hide()
        return
    end
    if self:ShouldShowFrame() then
        self.frame:Show()
    else
        self.frame:Hide()
    end
end

function HappyActionMirror:SetLocked(locked)
    HappyActionMirrorDB.locked = locked and true or false
    if HappyActionMirrorDB.locked then
        print("HappyActionMirror: Frame locked")
    else
        print("HappyActionMirror: Frame unlocked - drag to move")
    end

    self:UpdateLockIndicator()
    self:ToggleFrameVisibility()
    if self.RefreshOptionsPanel then
        self:RefreshOptionsPanel()
    end
end

function HappyActionMirror:ToggleLock()
    self:SetLocked(not HappyActionMirrorDB.locked)
end


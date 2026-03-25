-- HappyActionMirror Options Panel
if not HappyActionMirror then HappyActionMirror = {} end

local CHECKBOX_TEMPLATE = "InterfaceOptionsCheckButtonTemplate"

local function CreateCheckbox(parent, label, description, yOffset, onClick)
    local checkbox = CreateFrame("CheckButton", nil, parent, CHECKBOX_TEMPLATE)
    checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, yOffset)

    local text = checkbox.Text
    if text then
        text:SetText(label)
    end

    if description then
        local detail = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        detail:SetPoint("TOPLEFT", checkbox, "BOTTOMLEFT", 4, 0)
        detail:SetText(description)
        detail:SetTextColor(0.75, 0.75, 0.75, 1)
        checkbox.detailText = detail
    end

    checkbox:SetScript("OnClick", onClick)
    return checkbox
end

function HappyActionMirror:RefreshOptionsPanel()
    local controls = self.optionsControls
    if not controls then
        return
    end

    controls.lockButton:SetText(HappyActionMirrorDB.locked and "Unlock Frame" or "Lock Frame")
    controls.lockDescription:SetText(HappyActionMirrorDB.locked and "Frame is locked and follows visibility rules." or "Frame is unlocked and forced visible for moving.")
    controls.showMounted:SetChecked(HappyActionMirrorDB.showWhenMounted)
    controls.showTravelForm:SetChecked(HappyActionMirrorDB.showWhenTravelForm)
    controls.showOverride:SetChecked(HappyActionMirrorDB.showWhenOverride)
end

function HappyActionMirror:CreateOptionsPanel()
    if self.optionsPanel then
        return self.optionsPanel
    end

    local panel = CreateFrame("Frame", "HappyActionMirrorOptionsPanel", UIParent)
    panel.name = "HappyActionMirror"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("HappyActionMirror")

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    subtitle:SetText("Configure frame locking and when the mirrored action bar is visible.")

    local lockButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    lockButton:SetSize(140, 24)
    lockButton:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -20)
    lockButton:SetScript("OnClick", function()
        HappyActionMirror:SetLocked(not HappyActionMirrorDB.locked)
    end)

    local lockDescription = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    lockDescription:SetPoint("LEFT", lockButton, "RIGHT", 12, 0)
    lockDescription:SetTextColor(0.75, 0.75, 0.75, 1)

    local visibilityHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    visibilityHeader:SetPoint("TOPLEFT", lockButton, "BOTTOMLEFT", 0, -24)
    visibilityHeader:SetText("Show Action Bar When")

    local showMounted = CreateCheckbox(
        panel,
        "Mounted with bonus action bar",
        "Show the mirrored bar when mounted and a bonus action bar is active.",
        -145,
        function(self)
            HappyActionMirrorDB.showWhenMounted = self:GetChecked() and true or false
            HappyActionMirror:ToggleFrameVisibility()
        end
    )

    local showTravelForm = CreateCheckbox(
        panel,
        "Druid travel form with bonus action bar",
        "Show the mirrored bar in travel form when a bonus action bar is active.",
        -200,
        function(self)
            HappyActionMirrorDB.showWhenTravelForm = self:GetChecked() and true or false
            HappyActionMirror:ToggleFrameVisibility()
        end
    )

    local showOverride = CreateCheckbox(
        panel,
        "Override action bar active",
        "Show the mirrored bar whenever an override action bar is active.",
        -255,
        function(self)
            HappyActionMirrorDB.showWhenOverride = self:GetChecked() and true or false
            HappyActionMirror:ToggleFrameVisibility()
        end
    )

    panel:SetScript("OnShow", function()
        HappyActionMirror:RefreshOptionsPanel()
    end)

    self.optionsPanel = panel
    self.optionsControls = {
        lockButton = lockButton,
        lockDescription = lockDescription,
        showMounted = showMounted,
        showTravelForm = showTravelForm,
        showOverride = showOverride,
    }

    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name, panel.name)
        Settings.RegisterAddOnCategory(category)
        self.optionsCategory = category
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end

    self:RefreshOptionsPanel()
    return panel
end

-- HappyActionMirror Configuration
if not HappyActionMirror then HappyActionMirror = {} end

local DEFAULTS = {
    enabled = true,
    positionX = 0,
    positionY = -100,
    scale = 1.0,
    alpha = 1.0,
    showWhenMounted = true,
    showWhenTravelForm = true,
    showWhenOverride = true,
    locked = false,
}

function HappyActionMirror:GetDefaults()
    local copy = {}
    for key, value in pairs(DEFAULTS) do
        copy[key] = value
    end
    return copy
end

function HappyActionMirror:LoadSettings()
    if not HappyActionMirrorDB then
        HappyActionMirrorDB = self:GetDefaults()
        return
    end

    for key, value in pairs(DEFAULTS) do
        if HappyActionMirrorDB[key] == nil then
            HappyActionMirrorDB[key] = value
        end
    end
end

function HappyActionMirror:SaveSettings()
    if self.frame then
        local frameX, frameY = self.frame:GetCenter()
        local parentX, parentY = UIParent:GetCenter()
        if frameX and frameY and parentX and parentY then
            HappyActionMirrorDB.positionX = math.floor(frameX - parentX)
            HappyActionMirrorDB.positionY = math.floor(frameY - parentY)
        end
        HappyActionMirrorDB.scale = self.frame:GetScale()
        HappyActionMirrorDB.alpha = self.frame:GetAlpha()
    end
end


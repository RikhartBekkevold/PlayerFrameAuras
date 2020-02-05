function createCheckButtonGroup(el, labels, offsetX)
    local checkmarks = {}
    local element = el              -- the element to attach the first to
    local x = 0                     -- spacing between them - 2 is attached to 1 etc
    local y = -30                   -- set value diff instead of call diff fucntions
    local vertical = false

    for i = 1, #labels, 1 do
        local checkmark = CreateFrame("CheckButton", nil, el, "UICheckButtonTemplate")
        if(i == 1) then
            checkmark:SetPoint("TOPRIGHT", element, "TOPRIGHT", -300, -130)
        else
            checkmark:SetPoint("TOPLEFT", checkmarks[i - 1], "TOPLEFT", x, y)
        end
        checkmark.text:SetFontObject("GameFontHighlight")
        checkmark.text:SetText(labels[i])
        checkmark:SetID(i)
        table.insert(checkmarks, checkmark)
    end

    -- if only one CheckButton created, don't return as table
    if #checkmarks == 1 then return checkmarks[1] else return checkmarks end

end

-- /////////////////////////////////////
function createTooltip(text, anchorEL)
    local name = text
    local tt = CreateFrame("GameTooltip", name, nil, "GameTooltipTemplate") -- Tooltip name cannot be nil

    GameTooltipHeaderText:SetFontObject(GameTooltipTextSmall)

    anchorEL:SetScript("OnEnter", function(self)
        tt:SetOwner(anchorEL, "ANCHOR_RIGHT")
        tt:SetText(text) -- must come before Show - blizz api dansgame -- "|cffffff00" .. text .. "|r"
        tt:Show()
    end)

    anchorEL:SetScript("OnLeave", function(self)
        tt:Hide()
    end)
end


-- /////////////////////////////////////
function createHeader(el, offsetX, offsetY, text, fSize, fType)
    subtitle = el:CreateFontString(nil, "OVERLAY") -- creates as a child of? so if move frame...?
    subtitle:SetPoint("TOPLEFT", el, "TOPLEFT", offsetX, offsetY)

    -- if font size is provided
    if fSize == nil then
        subtitle:SetFont(STANDARD_TEXT_FONT, 17)
    else
        subtitle:SetFont(STANDARD_TEXT_FONT, fSize)
    end

    -- if font type is provided
    if fType == nil then
        subtitle:SetFontObject("GameFontNormal")
    else
        subtitle:SetFontObject(fType)
    end

    subtitle:SetText(text)
    return subtitle
end


-- /////////////////////////////////////
function createEditbox(el, parent)
    local Editbox = CreateFrame("EditBox", "dsada",  parent, "InputBoxTemplate")
    Editbox:SetSize(100, 20)
    Editbox:SetPoint("TOPLEFT", el, "BOTTOMLEFT", 5, -15)
    Editbox:SetAutoFocus(false)

    function Editbox:displayMsg() print("edit msg") end
    Editbox.displaySuperMsg = function() print("super msg") end

    return Editbox
end


-- /////////////////////////////////////
function createButton(el, parent, text)
    local btn = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    btn:SetSize(100, 25)
    btn:SetPoint("LEFT", el, "RIGHT")
    btn:SetText(text)
    return btn
end


-- /////////////////////////////////////
function createSlider(el, heading, value, min, max, offsetX, offsetY, step)
    local slider_heading = createHeader(el, offsetX, offsetY, heading, 13, "GameFontHighlight")
    local slider = CreateFrame("Slider", "globalname", el, "OptionsSliderTemplate")

    slider:SetPoint("TOPLEFT", slider_heading, "TOPLEFT", 0, -20)
    slider:SetOrientation('HORIZONTAL')

    slider:SetWidth(150)
    slider:SetHeight(15)

    slider:SetMinMaxValues(min, max)
    slider:SetValue(value)

    if step then
        slider:SetObeyStepOnDrag(true)
        slider:SetValueStep(step)
    end

    slider:Show()

    slider:SetScript("OnValueChanged", function()
        print(math.floor(slider:GetValue()))
    end)

    return slider
end

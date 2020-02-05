local name, global = ...

local filter_labels = {
    "Buffs",
    "Debuffs",
    "Cancelable",
    "Not Cancelable",
    "Buffs Applied By You"
}

local CB_labels = {
    "Name of aura you don't want to show",
    "",
    "Positions the auras BELOW the player frame",
    "Positions the auras ABOVE the player frame",
    "Hides the default blizzard auras next to the minimap",
}

local headings = {
    ["filter"] = "By Type",
    ["spell_filter"] = "Filtered Auras: ",
    ["specific_filter"] = "By Name",
    ["position_auras"] =  "Position Auras",
    ["default_auras"] =  "Hide Defaults"
}

local ConfigPanel = CreateFrame("Frame")
local sub_panel_display = CreateFrame("Frame")
local sub_panel_filter = CreateFrame("Frame")


function ConfigPanel:Initalize()
    self.name = name
    InterfaceOptions_AddCategory(self)

    sub_panel_display.parent = self.name
    sub_panel_display.name = "Display"
    InterfaceOptions_AddCategory(sub_panel_display)

    sub_panel_filter.parent = self.name
    sub_panel_filter.name = "Filter"
    InterfaceOptions_AddCategory(sub_panel_filter)

    self:AddUIElements()
    self:addHandlers()
end


function ConfigPanel:AddSubtitle(el, offsetX, offsetY, text, fSize, fType)
    subtitle = self:CreateFontString(nil, "OVERLAY")
    subtitle:SetPoint("TOPLEFT", el, "TOPLEFT", offsetX, offsetY)

    -- if font size is not provided
    if fSize == nil then
        subtitle:SetFont(STANDARD_TEXT_FONT, 17)
    else
        subtitle:SetFont(STANDARD_TEXT_FONT, fSize)
    end

    -- if font type is not provided
    if fType == nil then
        subtitle:SetFontObject("GameFontNormal")
    else
        subtitle:SetFontObject(fType)
    end

    -- text needs to be set after font
    subtitle:SetText(text)

    return subtitle
end


function ConfigPanel:AddCheckButtonGroup(el, labels)
    local checkmarks = {}
    local element = el              -- the element to attach the first CB to
    local x = 0                     -- spacing between them
    local y = -30
    local vertical = false

    for i = 1, #labels, 1 do
        local checkmark = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate")
        if(i == 1) then
            checkmark:SetPoint("TOPLEFT", element, "TOPLEFT", x, y)
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


function ConfigPanel:AddFilterCheckmarks()
    local x = 10
    local y = -100
    local vertical_spacing = 25;
    local filters =  {}

    for i = 1, #filter_labels, 1 do
         local checkmark = CreateFrame("CheckButton", nil, sub_panel_filter, "UICheckButtonTemplate")
         checkmark:SetPoint("TOPLEFT", sub_panel_filter, "TOPLEFT", x, y)
         checkmark.text:SetFontObject("GameFontHighlight")
         checkmark.text:SetText(filter_labels[i])
         checkmark:SetID(i)
         checkmark.value = filter_labels[i]

         if doesFilterExist(checkmark.value) ~= nil then checkmark:SetChecked(true) end

         checkmark:SetScript("OnClick", function()
             local index = doesFilterExist(checkmark.value)
             if index ~= nil then
                 table.remove(PFAConfig.filters, index)
             else
                 table.insert(PFAConfig.filters, checkmark.value)
             end
         end)

         table.insert(filters, checkmark)
         y = y - vertical_spacing
    end

    self.filters = filters
end


function ConfigPanel:AddUIElements()
    local title = createHeader(self, 10, -15, ConfigPanel.name, 20)


    local displaytitle = createHeader(sub_panel_filter, 10, -15, "Filter Auras", 19)
    local display_description = createHeader(sub_panel_filter, 10, -40, "These options decides WHICH auras are displayed", 11, "GameFontHighlight")

    local filter_heading = createHeader(sub_panel_filter, 10, -80, headings.filter)
    self:AddFilterCheckmarks()

    local specific_aura_filter_heading = createHeader(self.filters[5], 0, -60, headings.specific_filter)
    local spell_filter_editbox = createEditbox(specific_aura_filter_heading, sub_panel_filter)
    local confirm_btn = createButton(spell_filter_editbox, sub_panel_filter, "Add")
    local cancel_btn = createButton(confirm_btn, sub_panel_filter, "Clear")
    spell_filter_editbox:displayMsg()
    spell_filter_editbox.displaySuperMsg()

    local spell_list_heading = createHeader(confirm_btn, -100, -40, headings.spell_filter, 12)
    local spell_list = createHeader(confirm_btn, -100, -60, "dsd", 12, "GameFontHighlight")

    -- BUFFS POSITION
    local CB_position = createCheckButtonGroup(sub_panel_display, {"Above Player Frame", "Below Player Frame"}, 0)
    local position_heading = createHeader(CB_position[1],  0, 30, headings.position_auras)

    -- HIDE BLIZZ BUFFS
    local default_auras_heading = self:AddSubtitle(self, 10, -50, headings.default_auras)
    local CB_default_auras = self:AddCheckButtonGroup(default_auras_heading, {"Hide Blizzard (top right) Buffs"})

    if PFAConfig.position == "TOP" then
        CB_position[1]:SetChecked(true)
        CB_position[2]:Disable()
        CB_position[2].text:SetFontObject("GameFontDisable")
    else
        CB_position[2]:SetChecked(true)
        CB_position[1]:Disable()
        CB_position[1].text:SetFontObject("GameFontDisable")
    end

    if PFAConfig.hide_default == true then
        CB_default_auras:SetChecked(true)
        BuffFrame:Hide()
    end


    local displaytitle = createHeader(sub_panel_display, 10, -15, "Aura Display", 19)
    local display_description = createHeader(sub_panel_display, 10, -40, "These options decides HOW the auras are displayed", 11, "GameFontHighlight")

    -- SLIDERS FOR SIZE AND SPACING
    local slider = createSlider(sub_panel_display, "Size", PFAConfig.ICON_WIDTH, 10, 60, 20, -100)
    local slider2 = createSlider(slider, "Vertical Spacing", PFAConfig.SPACING, 0, 20, 0, -50)
    local slider3 = createSlider(slider2, "Horizontal Spacing", PFAConfig.SPACING, -20, 0, 0, -50)
    local slider4 = createSlider(slider3, "Num Per Row", PFAConfig.AURAS_PER_ROW, 1, 10, 0, -50, 1)
    local slider5 = createSlider(slider4, "Frame Offset", PFAConfig.START_SPACING, -20, 5, 0, -50)

    -- TOOLTIPS FOR SELECT ELEMENTS
    createTooltip(CB_labels[1], spell_filter_editbox)
    createTooltip(CB_labels[2], self.filters[1])
    createTooltip(CB_labels[3], CB_position[1])
    createTooltip(CB_labels[4], CB_position[2])
    createTooltip(CB_labels[5], CB_default_auras)

    self.size_slider                    = slider
    self.ver_spacing_slider             = slider2
    self.hor_spacing_slider             = slider3
    self.row_limit_slider               = slider4
    self.frame_offset_slider            = slider5

    self.title                          = title
    self.filter_heading                 = filter_heading
    self.specific_aura_filter_heading   = default_auras_heading
    self.position_heading               = position_heading
    self.default_auras_heading          = default_auras_heading

    self.spell_filter_editbox           = spell_filter_editbox
    self.positionCheckBtns              = CB_position
    self.CB_default_auras               = CB_default_auras

    self.confirm_btn                    = confirm_btn
    self.cancel_btn                     = cancel_btn
    self.spell_list_heading             = spell_list_heading
    self.spell_list                     = spell_list
end


function ConfigPanel:addHandlers()
    self.positionCheckBtns[1]:SetScript("OnClick", function()
        PFAConfig.position = "TOP"

        if self.positionCheckBtns[2]:IsEnabled() then
            self.positionCheckBtns[2]:Disable()
            self.positionCheckBtns[2].text:SetFontObject("GameFontDisable")
        else
            self.positionCheckBtns[2]:Enable()
            self.positionCheckBtns[2].text:SetFontObject("GameFontHighlight")
        end
    end)


    self.positionCheckBtns[2]:SetScript("OnClick", function()
        PFAConfig.position = "BOTTOM"

        if self.positionCheckBtns[1]:IsEnabled() then
            self.positionCheckBtns[1]:Disable()
            self.positionCheckBtns[1].text:SetFontObject("GameFontDisable")
        else
            self.positionCheckBtns[1]:Enable()
            self.positionCheckBtns[1].text:SetFontObject("GameFontHighlight")
        end
    end)


    self.CB_default_auras:SetScript("OnClick", function()
        self:ToggleBlizzBuffs()
    end)


    self.confirm_btn:SetScript("OnClick", function()
        local text = self.spell_filter_editbox:GetText()
        local newTable = stringToTable(text)

        for i = 1, #newTable, 1 do
          table.insert(PFAConfig.user_specified_filters, newTable[i])
        end

        self.spell_list_heading:SetText(headings.spell_filter)
        self.spell_list:SetText(text)
        self.spell_filter_editbox:ClearFocus()
        self.spell_filter_editbox:SetText("")
    end)


    self.cancel_btn:SetScript("OnClick", function()
        self.spell_filter_editbox:ClearFocus()
        self.spell_filter_editbox:SetText("")
        PFAConfig.user_specified_filters = {}
    end)
end


function ConfigPanel:ToggleBlizzBuffs()
    if BuffFrame:IsVisible() then
        PFAConfig.hide_default = true
        BuffFrame:Hide()
    else
        PFAConfig.hide_default = false
        BuffFrame:Show()
    end
end


-- EXPORT
global.ConfigPanel = ConfigPanel
global.PFAConfig = PFAConfig

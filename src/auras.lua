local name, global = ...

local LIMIT = 25;
local AURAS_PER_ROW = 3;
local SPACING = 5;
local ICON_WIDTH = 25;
local ICON_HEIGHT = 25;
local filters = "";  	-- comma separated list of aura filters
local height = 70; 	 	-- total height of all buffs
local width = PlayerPortrait:GetWidth() + PlayerFrameHealthBar:GetWidth()

local Auras = CreateFrame("Frame", "Auras", UIParent)
Auras:SetSize(width, height);


function Auras:SetPosition(firsttime)
	SetPositionComboPoints(PFAConfig.position, firsttime)
	SetPositionPetFrame(PFAConfig.position)
	SetPositionAltManaBar(PFAConfig.position)
	SetPaladinPowerBarPosition(PFAConfig.position)
	SetMonkChiBarPosition(PFAConfig.position)

	if PFAConfig.position == "TOP" then
		self:SetPoint("BOTTOMLEFT", PlayerFrameBackground, "TOPLEFT", 0, 0)
	else
		self:SetPoint("TOPLEFT", PlayerFrameBackground, "BOTTOMLEFT", 0, -5)
	end
end


function Auras:setSlotPositions()
	for i = 1, #self.buffButtons, 1 do
		self.buffButtons[i]:ClearAllPoints()
	end

	SetPositionPetFrame(PFAConfig.position)
	SetPositionAltManaBar(PFAConfig.position)
	SetPositionComboPoints(PFAConfig.position)
	SetPaladinPowerBarPosition(PFAConfig.position)
	SetMonkChiBarPosition(PFAConfig.position)

	self:ClearAllPoints()

	if PFAConfig.position == "TOP" then
		self:SetPoint("BOTTOMLEFT", PlayerFrameBackground, "TOPLEFT", 0, 0)

		 for i = 1, #self.buffButtons, 1 do
			if i == 1 then -- if first
				self.buffButtons[i]:SetPoint("BOTTOMLEFT", Auras, "BOTTOMLEFT", 0, PFAConfig.START_SPACING) -- this sets first button to the place of the Auras frame, but where is that?
			elseif i % PFAConfig.AURAS_PER_ROW == 1 then -- breakpoint  -- for every 5, calculated with forumla -- if 5, 10, 15... etc
				self.buffButtons[i]:SetPoint("BOTTOMLEFT", self.buffButtons[i - PFAConfig.AURAS_PER_ROW], "TOPLEFT", 0, PFAConfig.HORIZONTAL_SPACING) -- Auras pos plus PFAConfig.ICON_HEIGHT, or get the push btn
			else -- if not first and not 5.. 10.. etc
				self.buffButtons[i]:SetPoint("TOPLEFT", self.buffButtons[i-1], "TOPRIGHT", PFAConfig.SPACING, 0) -- this is direction, first is starting point, middle is breakpoint/rows
			end
		end
	else
		self:SetPoint("TOPLEFT", PlayerFrameBackground, "BOTTOMLEFT", 0, -5)

		for i = 1, #self.buffButtons, 1 do
			if i == 1 then -- if first
				self.buffButtons[i]:SetPoint("TOPLEFT", Auras, "TOPLEFT", 0, PFAConfig.START_SPACING) -- this sets first button to the place of the Auras frame, but where is that?
			elseif i % PFAConfig.AURAS_PER_ROW == 1 then -- breakpoint  -- for every 5, calculated with forumla -- if 5, 10, 15... etc
				self.buffButtons[i]:SetPoint("TOPLEFT", self.buffButtons[i - PFAConfig.AURAS_PER_ROW], "BOTTOMLEFT", 0, PFAConfig.HORIZONTAL_SPACING) -- Auras pos plus PFAConfig.ICON_HEIGHT, or get the push btn --- 1 pluss
			else -- if not first and not 5.. 10.. etc
				self.buffButtons[i]:SetPoint("TOPLEFT", self.buffButtons[i-1], "TOPRIGHT", PFAConfig.SPACING, 0)
			end
		end
	end
end


function Auras:createAuraSlots()
	local buffButtons = {};

    local padding = 2
    local buffHeight = ICON_WIDTH -- width and height uhm?
    local name, rank, icon, castTime, minRange, maxRange, spellId  = GetSpellInfo(212812);


    for i = 1, LIMIT, 1 do
        local btn = CreateFrame("Button", "", Auras)
        btn:SetSize(PFAConfig.ICON_WIDTH, PFAConfig.ICON_HEIGHT)
        -- btn:SetNormalTexture(icon)
        btn:SetID(i)


		if PFAConfig.position == "BOTTOM" then
			if i == 1 then -- if first
				btn:SetPoint("TOPLEFT", Auras, "TOPLEFT", 0, PFAConfig.START_SPACING) -- this sets first button to the place of the Auras frame, but where is that?
			elseif i % PFAConfig.AURAS_PER_ROW == 1 then -- breakpoint  -- for every 5, calculated with forumla -- if 5, 10, 15... etc
				btn:SetPoint("TOPLEFT", buffButtons[i - PFAConfig.AURAS_PER_ROW], "BOTTOMLEFT", 0, PFAConfig.HORIZONTAL_SPACING) -- Auras pos plus PFAConfig.ICON_HEIGHT, or get the push btn --- 1 pluss
			else -- if not first and not 5.. 10.. etc
				btn:SetPoint("TOPLEFT", buffButtons[i-1], "TOPRIGHT", PFAConfig.SPACING, 0)
			end
		else
			if i == 1 then -- if first
				btn:SetPoint("BOTTOMLEFT", Auras, "BOTTOMLEFT", 0, PFAConfig.START_SPACING) -- this sets first button to the place of the Auras frame, but where is that?
			elseif i % PFAConfig.AURAS_PER_ROW == 1 then -- breakpoint  -- for every 5, calculated with forumla -- if 5, 10, 15... etc
				btn:SetPoint("BOTTOMLEFT", buffButtons[i - PFAConfig.AURAS_PER_ROW], "TOPLEFT", 0, PFAConfig.HORIZONTAL_SPACING) -- Auras pos plus PFAConfig.ICON_HEIGHT, or get the push btn
			else -- if not first and not 5.. 10.. etc
				btn:SetPoint("TOPLEFT", buffButtons[i-1], "TOPRIGHT", PFAConfig.SPACING, 0) -- this is direction, first is starting point, middle is breakpoint/rows
			end
		end

        btn:RegisterForClicks("LeftButtonDown", "RightButtonDown")
        btn:SetScript("OnClick", function(b, buttonClicked)
            CancelUnitBuff("player", b:GetID());
        end)

		local cd = CreateFrame("Cooldown", "", btn, "CooldownFrameTemplate")
		cd:SetPoint("TOPLEFT", btn, "TOPLEFT")
		cd:SetSize(PFAConfig.ICON_WIDTH, PFAConfig.ICON_WIDTH)
		cd:SetReverse(true)
		btn.cooldown = cd

		-- push every button to table
        buffButtons[#buffButtons + 1] = btn
    end

	-- "save"
	self.buffButtons = buffButtons
end


function Auras:addAuraIcon(auraicon, nr, first)
    self.buffButtons[nr]:SetNormalTexture(auraicon)
end


-- reseting buff array happen in other function
function Auras:reset()
    for i = 1, LIMIT, 1 do
        self.buffButtons[i]:SetNormalTexture("")
		self.buffButtons[i].cooldown:SetDrawBling(false)
		self.buffButtons[i].cooldown:SetCooldown(0, 0)
    end
end


function Auras:update()
	filters = tableToString(PFAConfig.filters)
	self:reset()
	self:add()
end


function Auras:add()
    local buffs = {};
    local i = 1;			-- the next unit aura
	local slotIndex = 1; 	-- the next buff slot to place texture

    local auraname, auraicon, count, debuffType, duration, expirationTime = UnitAura("player", i, filters);

    while auraname do
		if isAuraUserIgnored(auraname) == nil then

            -- add icon
      		self:addAuraIcon(auraicon, slotIndex)

            -- add cooldown animnation
			if duration > 0 then
				local time_completed = duration - (expirationTime - GetTime())
				self.buffButtons[slotIndex].cooldown:SetCooldown(GetTime() - time_completed, duration)
			end

            -- push
			slotIndex = slotIndex + 1;
      		buffs[#buffs + 1] = buff;
	  	end

      i = i + 1;
      auraname, auraicon, count, debuffType, duration, expirationTime = UnitAura("player", i, filters);
    end
end


function Auras:createDummyAuras()
	local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(212812);

	for i = 1, #self.buffButtons, 1 do
		self.buffButtons[i]:SetNormalTexture(icon)
	end
end



function Auras:test()
    -- create dummies, but with specific icons
	-- display all dummies etc
	-- display only the debuff dummies
end


--  EVENT HANDLERS / HOOKS
function Auras:onUserChangeFilters()
	for i = 1, #global.ConfigPanel.filters, 1 do
		global.ConfigPanel.filters[i]:HookScript("OnClick", function()
			self:update()
		end)
	end
end


function Auras:onUserChangeSizeSlider()
	global.ConfigPanel.size_slider:HookScript("OnValueChanged", function()
		PFAConfig.ICON_WIDTH = global.ConfigPanel.size_slider:GetValue()
		PFAConfig.ICON_HEIGHT = global.ConfigPanel.size_slider:GetValue()

		self:update()

		local name, rank, icon, castTime, minRange, maxRange, spellId  = GetSpellInfo(212812);

		for i = 1, #self.buffButtons, 1 do
			self.buffButtons[i]:SetSize(PFAConfig.ICON_WIDTH, PFAConfig.ICON_HEIGHT)
			self.buffButtons[i]:SetNormalTexture(icon)
		end
	end)


	global.ConfigPanel.size_slider:HookScript("OnLeave", function()
		self:update()
	end)
end


function Auras:onUserChangeSpacingSlider()
	global.ConfigPanel.ver_spacing_slider:HookScript("OnValueChanged", function()
		PFAConfig.SPACING = global.ConfigPanel.ver_spacing_slider:GetValue()
		self:setSlotPositions()
		self:createDummyAuras()
	end)

	global.ConfigPanel.ver_spacing_slider:HookScript("OnLeave", function()
		self:update()
	end)
end


function Auras:onUserChangeHorizontalSpacingSlider()
	global.ConfigPanel.hor_spacing_slider:HookScript("OnValueChanged", function()
		PFAConfig.HORIZONTAL_SPACING = global.ConfigPanel.hor_spacing_slider:GetValue()
		self:setSlotPositions()
		self:createDummyAuras()
	end)

	global.ConfigPanel.hor_spacing_slider:HookScript("OnLeave", function()
		self:update()
	end)
end


function Auras:onUserChangeFrameOffsetSlider()
	global.ConfigPanel.frame_offset_slider:HookScript("OnValueChanged", function()
		PFAConfig.START_SPACING = global.ConfigPanel.frame_offset_slider:GetValue()
		self:setSlotPositions()
		self:createDummyAuras()
	end)

	global.ConfigPanel.frame_offset_slider:HookScript("OnLeave", function()
		self:update()
	end)
end


function Auras:onUserChangeRowLimitSlider()
	global.ConfigPanel.row_limit_slider:HookScript("OnValueChanged", function()
		PFAConfig.AURAS_PER_ROW = math.floor(global.ConfigPanel.row_limit_slider:GetValue())
		self:setSlotPositions()
		self:createDummyAuras()
	end)

	global.ConfigPanel.row_limit_slider:HookScript("OnLeave", function()
		self:update()
	end)
end


function Auras:onUserChangeBuffPositions()
	for i = 1, #global.ConfigPanel.positionCheckBtns, 1 do
		global.ConfigPanel.positionCheckBtns[i]:HookScript("OnClick", function()
			self:setSlotPositions()
		end)
	end
end

function tableToString(table)
    local string = ""

    for i = 1, #table, 1 do
        if table[i] == "Buffs" then
            string = string .. "HELPFUL "
        elseif table[i] == "Debuffs"  then
            string = string .. "HARMFUL "
        elseif table[i] == "Cancelable"  then
            string = string .. "CANCELABLE "
        elseif table[i] == "Not Cancelable"  then
            string = string .. "NOT_CANCELABLE "
        elseif table[i] == "Buffs Applied By You" then
            string = string .. "PLAYER "
        end
    end

    return string
end


function stringToTable(text)
    local output = {}
    -- local no_space_text = trim(text) - if space right after , or at end or first
    result = text:gsub("^%s+", ""):gsub("%s+$", "")

    for i in string.gmatch(result, "([^,]+)") do
        table.insert(output, i)
    end

    return output
end


function doesFilterExist(value)
    for i = 1, #PFAConfig.filters, 1 do
        if PFAConfig.filters[i] == value then
            return i
        end
    end
    return nil
end


function isAuraUserIgnored(value)
    for i = 1, #PFAConfig.user_specified_filters, 1 do
        if PFAConfig.user_specified_filters[i] == value then
            return i
        end
    end
    return nil
end


function printChildren()
    local kids = { PlayerFrame:GetChildren() };

    for _, child in ipairs(kids) do
      -- stuff
      print(child:GetName())
    end
end


function SetMonkChiBarPosition(pos)
	-- MonkHarmonyBarFrame
    if pos == "TOP" then
        MonkHarmonyBarFrame:ClearAllPoints()
        MonkHarmonyBarFrame:SetPoint("TOP", PlayerFrameBackground, "BOTTOM", 0, 15)
    else
        MonkHarmonyBarFrame:ClearAllPoints()
        MonkHarmonyBarFrame:SetPoint("BOTTOM", PlayerFrameBackground, "TOP", 0, -15)
    end
end


function SetDKRunesPosition(pos)
	-- RuneFrame
	-- RuneFrame.Rune1
end


function SetPaladinPowerBarPosition(pos)
    if pos == "TOP" then
        PaladinPowerBarFrame:ClearAllPoints()
        PaladinPowerBarFrame:SetPoint("TOP", PlayerFrameBackground, "BOTTOM", 0, 1)
        -- PaladinPowerBarFrameBG:SetRotation(0)
    else
        PaladinPowerBarFrame:ClearAllPoints()
        PaladinPowerBarFrame:SetPoint("BOTTOM", PlayerFrameBackground, "TOP", 0.5, 0)
        -- PaladinPowerBarFrameBG:SetRotation(3.14159)
    end
end


function SetPositionPetFrame(pos)
	if pos == "TOP" then
		PetFrame:ClearAllPoints()
		PetFrame:SetPoint("TOPLEFT", PlayerFrame, "BOTTOMLEFT", 80, 40)
		PetName:SetPoint("BOTTOMLEFT", PetFrameHealthBar, "TOPLEFT")
	else
		PetFrame:ClearAllPoints()
		PetFrame:SetPoint("BOTTOMLEFT", PlayerFrame, "TOPLEFT", 80, -33)
		PetName:SetPoint("BOTTOMLEFT", PetFrameHealthBar, "TOPLEFT")
	end
end


function SetPositionAltManaBar(pos)
	if pos == "TOP" then
		PlayerFrameAlternateManaBar:ClearAllPoints()
		PlayerFrameAlternateManaBar:SetPoint("TOP", PlayerFrameBackground, "BOTTOM", 0, -4)

		PlayerFrameAlternateManaBarBorder:ClearAllPoints()
		PlayerFrameAlternateManaBarBorder:SetPoint("CENTER", 0, 13)
		PlayerFrameAlternateManaBarBorder:SetSize(100, PlayerFrameAlternateManaBarBorder:GetHeight())

		local prevPointRight = PlayerFrameAlternateManaBarRightBorder:GetPoint()
		local prevPointLeft	= PlayerFrameAlternateManaBarLeftBorder:GetPoint()

		PlayerFrameAlternateManaBarRightBorder:SetRotation(0)
		PlayerFrameAlternateManaBarRightBorder:ClearAllPoints()
		-- PlayerFrameAlternateManaBarRightBorder:SetPoint(prevPointRight)
		PlayerFrameAlternateManaBarRightBorder:ClearAllPoints()
		PlayerFrameAlternateManaBarRightBorder:SetPoint("CENTER", -55, 3)

		PlayerFrameAlternateManaBarLeftBorder:SetRotation(0)
		PlayerFrameAlternateManaBarLeftBorder:ClearAllPoints()
		-- PlayerFrameAlternateManaBarLeftBorder:SetPoint(prevPointLeft)
		PlayerFrameAlternateManaBarLeftBorder:ClearAllPoints()
		PlayerFrameAlternateManaBarLeftBorder:SetPoint("CENTER", 55, 3)
	else
		PlayerFrameAlternateManaBar:ClearAllPoints()
		PlayerFrameAlternateManaBar:SetPoint("BOTTOM", PlayerFrameBackground, "TOP", 0, 1)

		PlayerFrameAlternateManaBarBorder:ClearAllPoints()
		PlayerFrameAlternateManaBarBorder:SetPoint("CENTER", 0, 13)
		PlayerFrameAlternateManaBarBorder:SetSize(100, PlayerFrameAlternateManaBarBorder:GetHeight())

		local prevPointRight = PlayerFrameAlternateManaBarRightBorder:GetPoint()
		local prevPointLeft	= PlayerFrameAlternateManaBarLeftBorder:GetPoint()

		PlayerFrameAlternateManaBarRightBorder:SetRotation(3.14159)
		PlayerFrameAlternateManaBarRightBorder:ClearAllPoints()
		PlayerFrameAlternateManaBarRightBorder:SetPoint(prevPointRight)
		PlayerFrameAlternateManaBarRightBorder:ClearAllPoints()
		PlayerFrameAlternateManaBarRightBorder:SetPoint("CENTER", -55, 3)

		PlayerFrameAlternateManaBarLeftBorder:SetRotation(3.14159)
		PlayerFrameAlternateManaBarLeftBorder:ClearAllPoints()
		PlayerFrameAlternateManaBarLeftBorder:SetPoint(prevPointLeft)
		PlayerFrameAlternateManaBarLeftBorder:ClearAllPoints()
		PlayerFrameAlternateManaBarLeftBorder:SetPoint("CENTER", 55, 3)
	end
end


function SetPositionComboPoints(pos, firsttime)
	if pos == "TOP" then
		-- reverse the pet and combopoint frames of the buff/addon frame
		ComboPointPlayerFrame:ClearAllPoints()
		ComboPointPlayerFrame:SetPoint("TOP", PlayerFrameBackground, "BOTTOM", 0, 1)
		ComboPointPlayerFrame.Background:SetRotation(0) -- Hide()
		ComboPointPlayerFrame.Combo1:ClearAllPoints()
		ComboPointPlayerFrame.Combo1:SetPoint("TOPLEFT", ComboPointPlayerFrame, "TOPLEFT", 10, -1.5)
	else
		-- reverse the pet and combopoint frames of the buff/addon frame
		-- if dont clear it used current postion and applies offsets - when using clear it reverts to default upper left position before begining to position
		ComboPointPlayerFrame:ClearAllPoints()
		if firsttime then
			ComboPointPlayerFrame:SetPoint("BOTTOM", PlayerFrameBackground, "TOP", -2, 18)
		else
			ComboPointPlayerFrame:SetPoint("BOTTOM", PlayerFrameBackground, "TOP", 0.5, 0) --ComboPointPlayerFrame:GetHeight()/2+8
		end
		ComboPointPlayerFrame.Background:SetRotation(3.14159) -- Hide()
		ComboPointPlayerFrame.Combo1:ClearAllPoints()
		ComboPointPlayerFrame.Combo1:SetPoint("TOPLEFT", ComboPointPlayerFrame, "TOPLEFT", 12, 5)
	end
end



-- localizedClass, englishClass, classIndex = UnitClass("player");
-- SetAlternateClassBarPosition(englishClass)
function SetAlternateClassBarPosition(class)
	if class == "PALADIN" then
		SetPaladinPowerBarPosition()

	elseif class == "HUNTER" then
		SetPositionPetFrame()

	elseif class == "ROGUE" then
		SetPositionComboPoints()

	elseif class == "PRIEST" then
        SetPositionAltManaBar()
		SetPositionPetFrame()	    -- shadowfiend

	elseif class == "MAGE" then
        if PetFrame then
            SetPositionPetFrame()   -- when not called first time - wont throw error
        end

	elseif class == "WARLOCK" then
		SetPositionPetFrame()

	elseif class == "MONK" then
		SetMonkChiBarPosition()

	elseif class == "DEATHKNIGHT" then
		SetDKRunesPosition()          -- SetPositionPetFrame()?
	end
end

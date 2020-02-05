local name, global = ...

local Addon = CreateFrame("Frame", name, UIParent)
Addon:SetSize(200, 200)


function Addon:Initalize()

	self:SetScript("OnEvent", function(self, event, arg1, arg2, arg3)
		if event == "ADDON_LOADED" then
			-- if not this addon being loaded
			if arg1 ~= name then return end

			-- if first time loaded, set the savedvariable
			if PFAConfig == nil then
				PFAConfig = {
					["filters"] = {},
					["hide_default"] = false,
					["position"] = "BOTTOM",
					["ICON_WIDTH"] = 22,
					["ICON_HEIGHT"] = 22,
					["user_specified_filters"] = {},
					["AURAS_PER_ROW"] = 3,
					["SPACING"] = 5,
					["HORIZONTAL_SPACING"] = -5,
					["START_SPACING"] = 5
				}
			end

			-- sets buffs position on frame based on user pref. true = first time called
			Auras:SetPosition(true)

			-- on addon load create config panel
			global.ConfigPanel:Initalize()

			-- hooks
			Auras:onUserChangeBuffPositions()
			Auras:onUserChangeFilters()
			Auras:onUserChangeSizeSlider()
			Auras:onUserChangeSpacingSlider()
			Auras:onUserChangeRowLimitSlider()
			Auras:onUserChangeHorizontalSpacingSlider()
			Auras:onUserChangeFrameOffsetSlider()

			-- load config filter list
			filters = tableToString(PFAConfig.filters)
			-- create buff buttons frames to use for aura display
			Auras:createAuraSlots()
			-- can be replaced with update()
			Auras:add()
			-- unsub for performance
			self:UnregisterEvent("ADDON_LOADED")
		end

		-- if an aura has changed (added, removed)..
		if event == "UNIT_AURA" then
			-- ..on the player
			if arg1 == "player" then
				-- only need filters at start from config file and when slider is changed, dont need it here
				Auras:reset()
				Auras:add()
			end
		end
	end)

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("ADDON_LOADED")
end


Addon:Initalize()

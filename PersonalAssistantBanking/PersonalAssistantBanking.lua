-- Addon: PersonalAssistant.Banking
-- Developer: Klingo

PAB = {}
PAB.AddonName = "PersonalAssistantBanking"
PAB.AddonVersion = "1.0"

-- init default values
function PAB.initDefaults()
    -- initialize the multi-profile structure
    PAB.Banking_Defaults = {}
    -- -----------------------------------------------------
    -- default values for PABanking
    for profileNo = 1, PAG_MAX_PROFILES do
        -- get default vlaues from PAMenu_Defaults
        PAB.Banking_Defaults[profileNo] = PAMenu_Defaults.defaultSettings.PABanking

        -- default values for ItemTypes (only prepare defaults for enabled itemTypes)
        -- deposit=true, withdrawal=false
        for i = 1, #PABItemTypes do
            if PABItemTypes[i] ~= "" then
                PAB.Banking_Defaults[profileNo].ItemTypes[PABItemTypes[i]] = PAC_ITEMTYPE_IGNORE
            end
        end

        -- default values for advanced ItemTypes
        for itemTypeAdvancedNo = 1, #PABItemTypesAdvanced do	-- amount of advanced item types
            PAB.Banking_Defaults[profileNo].ItemTypesAdvanced[itemTypeAdvancedNo] = {
                Key = {},
                Value = {}
            }
        end
        -- TODO: LUA index starts at 1
        PAB.Banking_Defaults[profileNo].ItemTypesAdvanced[1].Key = PAC_OPERATOR_NONE		-- 1 = Lockpick
        PAB.Banking_Defaults[profileNo].ItemTypesAdvanced[1].Value = 100					-- 1 = Lockpick
    end
end


-- init saved variables and register Addon
function PAB.initAddon(eventCode, addOnName)
    if addOnName ~= PAB.AddonName then
        return
    end

    -- addon load started - unregister event
    PAEM.UnregisterForEvent(PAB.AddonName, EVENT_ADD_ON_LOADED)
	
	-- initialize the default values
	PAB.initDefaults()

    -- gets values from SavedVars, or initialises with default values
    PA.savedVars.Banking = ZO_SavedVars:NewAccountWide("PersonalAssistantBanking_SavedVariables", 1, "Banking", PAB.Banking_Defaults)

    -- register PABanking
    PAEM.RegisterForEvent(PAB.AddonName, EVENT_OPEN_BANK, PAB.OnBankOpen)
    PAEM.RegisterForEvent(PAB.AddonName, EVENT_CLOSE_BANK, PAB.OnBankClose)
end

PAEM.RegisterForEvent(PAB.AddonName, EVENT_ADD_ON_LOADED, PAB.initAddon)
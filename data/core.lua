MW2LU = MW2LU or {}

local ADDON_VERSION = "2.0.4"
local ADDON_NAME = "ModernWarfare2LevelUp"
local TITLE = "[|cff4F4F4FM|r|cffffffffodern Warfare 2 |r|cff4F4F4FL|r|cffffffffevel-|r|cff4F4F4FU|r|cff4F4F4F!|r]"
local SOUND_PATHS = {
    high = "Interface\\Addons\\ModernWarfare2LevelUp\\sounds\\modern_warfare_2_high.ogg",
    medium = "Interface\\Addons\\ModernWarfare2LevelUp\\sounds\\modern_warfare_2_med.ogg",
    low = "Interface\\Addons\\ModernWarfare2LevelUp\\sounds\\modern_warfare_2_low.ogg"
}
local DEFAULT_SOUND_ID = 569593
local PREFIX = "|cff4F4F4FMW2LU|r"

MW2LU.version = ADDON_VERSION
MW2LU.defaults = {
    enabled = true,
    soundVariant = "medium",
    muteDefault = true,
    showWelcome = true,
    volume = "Master",
    firstRun = true
}

function MW2LU:InitializeSettings()
    MW2LUSettings = MW2LUSettings or {}
    for key, value in pairs(self.defaults) do
        if MW2LUSettings[key] == nil then
            MW2LUSettings[key] = value
        end
    end
end

function MW2LU:GetSetting(key)
    if not MW2LUSettings then
        return self.defaults[key]
    end
    local value = MW2LUSettings[key]
    if value ~= nil then
        return value
    end
    return self.defaults[key]
end

function MW2LU:SetSetting(key, value)
    MW2LUSettings = MW2LUSettings or {}
    MW2LUSettings[key] = value
end

function MW2LU:PlayCustomLevelUpSound()
    if not self:GetSetting("enabled") then
        return
    end
    local soundPath = SOUND_PATHS[self:GetSetting("soundVariant") or "medium"]
    if soundPath then
        PlaySoundFile(soundPath, self:GetSetting("volume") or "Master")
    end
end

function MW2LU:MuteDefaultLevelUpSound()
    if self:GetSetting("enabled") and self:GetSetting("muteDefault") then
        MuteSoundFile(DEFAULT_SOUND_ID)
    end
end

function MW2LU:UnmuteDefaultLevelUpSound()
    UnmuteSoundFile(DEFAULT_SOUND_ID)
end

function MW2LU:DisplayWelcomeMessage()
    if not self:GetSetting("showWelcome") then
        return
    end
    local version = "|cff8080ff(v" .. ADDON_VERSION .. ")|r"
    local status = self:GetSetting("enabled") and self.L["ENABLED_STATUS"] or self.L["DISABLED_STATUS"]
    print(PREFIX .. " - " .. TITLE .. " " .. status .. " " .. version)
    if self:GetSetting("firstRun") then
        print(PREFIX .. " " .. self.L["COMMUNITY_MESSAGE"])
        self:SetSetting("firstRun", false)
    end
    print(PREFIX .. " " .. self.L["TYPE_HELP"])
end

function MW2LU:ShowHelp()
    print(PREFIX .. " " .. self.L["HELP_HEADER"])
    print(PREFIX .. " " .. self.L["HELP_TEST"])
    print(PREFIX .. " " .. self.L["HELP_ENABLE"])
    print(PREFIX .. " " .. self.L["HELP_DISABLE"])
    print(PREFIX .. " " .. self.L["HELP_WELCOME"])
    print(PREFIX .. " |cffffffff/mw2lu high|r - Use high quality sound")
    print(PREFIX .. " |cffffffff/mw2lu med|r - Use medium quality sound")
    print(PREFIX .. " |cffffffff/mw2lu low|r - Use low quality sound")
end

function MW2LU:HandleSlashCommand(args)
    local command = string.lower(args or "")
    if command == "" or command == "help" then
        self:ShowHelp()
    elseif command == "test" then
        print(PREFIX .. ": " .. self.L["PLAYING_TEST"])
        self:PlayCustomLevelUpSound()
    elseif command == "enable" then
        self:SetSetting("enabled", true)
        self:MuteDefaultLevelUpSound()
        print(PREFIX .. ": " .. self.L["ADDON_ENABLED"])
    elseif command == "disable" then
        self:SetSetting("enabled", false)
        self:UnmuteDefaultLevelUpSound()
        print(PREFIX .. ": " .. self.L["ADDON_DISABLED"])
    elseif command == "welcome" then
        local newValue = not self:GetSetting("showWelcome")
        self:SetSetting("showWelcome", newValue)
        print(PREFIX .. ": " .. (newValue and self.L["WELCOME_TOGGLE_ON"] or self.L["WELCOME_TOGGLE_OFF"]))
    elseif command == "high" then
        self:SetSetting("soundVariant", "high")
        print(PREFIX .. ": " .. string.format(self.L["SOUND_VARIANT_SET"], "high"))
    elseif command == "med" or command == "medium" then
        self:SetSetting("soundVariant", "medium")
        print(PREFIX .. ": " .. string.format(self.L["SOUND_VARIANT_SET"], "medium"))
    elseif command == "low" then
        self:SetSetting("soundVariant", "low")
        print(PREFIX .. ": " .. string.format(self.L["SOUND_VARIANT_SET"], "low"))
    else
        print(PREFIX .. " " .. self.L["ERROR_PREFIX"] .. " " .. self.L["ERROR_UNKNOWN_COMMAND"])
    end
end

SLASH_MW2LU1 = "/mw2lu"
SlashCmdList["MW2LU"] = function(args)
    MW2LU:HandleSlashCommand(args)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LEVEL_UP" then
        MW2LU:PlayCustomLevelUpSound()
    elseif event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == ADDON_NAME then
            MW2LU:InitializeSettings()
            MW2LU:MuteDefaultLevelUpSound()
        end
    elseif event == "PLAYER_LOGIN" then
        MW2LU:DisplayWelcomeMessage()
    elseif event == "PLAYER_LOGOUT" then
        MW2LU:UnmuteDefaultLevelUpSound()
    end
end)

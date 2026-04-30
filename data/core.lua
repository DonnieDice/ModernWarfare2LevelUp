--=====================================================================================
-- MW2LU | ModernWarfare2LevelUp - core.lua
-- Version: 3.0.0
-- Author: DonnieDice
-- RGX Mods Collection - RealmGX Community Project
--=====================================================================================

local RGX = assert(_G.RGXFramework, "MW2LU: RGX-Framework not loaded")

MW2LU = MW2LU or {}

local ADDON_VERSION = "3.0.0"
local ADDON_NAME = "ModernWarfare2LevelUp"
local ICON_PATH = "|Tinterface/addons/ModernWarfare2LevelUp/media/icon:16:16|t"
local PREFIX = ICON_PATH .. " |cff4F4F4FMW2LU:|r"
local TITLE = "[|cff4F4F4FM|r|cffffffffodern Warfare 2|r |cff4F4F4FL|r|cffffffffevel-|r|cff4F4F4FU|r|cff4F4F4F!|r]"

MW2LU.version = ADDON_VERSION
MW2LU.addonName = ADDON_NAME

local Sound = RGX:GetSound()

local handle = Sound:Register(ADDON_NAME, {
sounds = {
high = "Interface\\Addons\\ModernWarfare2LevelUp\\sounds\\modern_warfare_2_high.ogg",
medium = "Interface\\Addons\\ModernWarfare2LevelUp\\sounds\\modern_warfare_2_med.ogg",
low = "Interface\\Addons\\ModernWarfare2LevelUp\\sounds\\modern_warfare_2_low.ogg",
},
defaultSoundId = 569593,
savedVar = "MW2LUSettings",
defaults = {
enabled = true,
soundVariant = "medium",
muteDefault = true,
showWelcome = true,
volume = "Master",
firstRun = true,
},
triggerEvent = "PLAYER_LEVEL_UP",
addonVersion = ADDON_VERSION,
})

MW2LU.handle = handle

local L = MW2LU.L or {}
local initialized = false

local function ShowHelp()
print(PREFIX .. " " .. (L["HELP_HEADER"] or ""))
print(PREFIX .. " " .. (L["HELP_TEST"] or ""))
print(PREFIX .. " " .. (L["HELP_ENABLE"] or ""))
print(PREFIX .. " " .. (L["HELP_DISABLE"] or ""))
print(PREFIX .. " |cffffffff/mw2lu high|r - Use high quality sound")
print(PREFIX .. " |cffffffff/mw2lu med|r - Use medium quality sound")
print(PREFIX .. " |cffffffff/mw2lu low|r - Use low quality sound")
end

local function HandleSlashCommand(args)
local command = string.lower(args or "")
if command == "" or command == "help" then
ShowHelp()
elseif command == "test" then
print(PREFIX .. " " .. (L["PLAYING_TEST"] or ""))
handle:Test()
elseif command == "enable" then
handle:Enable()
print(PREFIX .. " " .. (L["ADDON_ENABLED"] or ""))
elseif command == "disable" then
handle:Disable()
print(PREFIX .. " " .. (L["ADDON_DISABLED"] or ""))
elseif command == "high" then
handle:SetVariant("high")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "high"))
elseif command == "med" or command == "medium" then
handle:SetVariant("medium")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "medium"))
elseif command == "low" then
handle:SetVariant("low")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "low"))
else
print(PREFIX .. " " .. (L["ERROR_PREFIX"] or "") .. " " .. (L["ERROR_UNKNOWN_COMMAND"] or ""))
end
end

RGX:RegisterEvent("ADDON_LOADED", function(event, addonName)
if addonName ~= ADDON_NAME then return end
handle:SetLocale(MW2LU.L)
L = MW2LU.L or {}
handle:Init()
initialized = true
end, "MW2LU_ADDON_LOADED")

RGX:RegisterEvent("PLAYER_LEVEL_UP", function()
if initialized then
handle:Play()
end
end, "MW2LU_PLAYER_LEVEL_UP")

RGX:RegisterEvent("PLAYER_LOGIN", function()
if not initialized then
handle:SetLocale(MW2LU.L)
L = MW2LU.L or {}
handle:Init()
initialized = true
end
handle:ShowWelcome(PREFIX, TITLE)
end, "MW2LU_PLAYER_LOGIN")

RGX:RegisterEvent("PLAYER_LOGOUT", function()
handle:Logout()
end, "MW2LU_PLAYER_LOGOUT")

RGX:RegisterSlashCommand("mw2lu", function(msg)
local ok, err = pcall(HandleSlashCommand, msg)
if not ok then
print(PREFIX .. " |cffff0000MW2LU Error:|r " .. tostring(err))
end
end, "MW2LU_SLASH")

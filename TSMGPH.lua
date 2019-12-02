if not TSMGPHConfigCharacter then
    TSMGPHConfigCharacter = {}
end

TSMGPH = {...}

TSMGPH = LibStub("AceAddon-3.0"):NewAddon("TSMGPH", "AceConsole-3.0", "AceTimer-3.0")

local TSMGPHOptions = TSMGPHLoader:ImportModule("TSMGPHOptions")
local TSMGPHGui = TSMGPHLoader:ImportModule("TSMGPHGui")

function TSMGPH:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("TSMGPHDB")

    TSMGPH:RegisterChatCommand("tsmgph", "TSMGPHSlash")
end
  
function TSMGPH:OnEnable()
    self.timer = self:ScheduleRepeatingTimer("LoadTimer", 1)
end

function TSMGPH:OnDisable()
    -- Called when the addon is disabled
end

function TSMGPH:TSMGPHSlash(input)
    -- /tsmgph
    if input == "" or not input then
        TSMGPHOptions:OpenConfigWindow()
        return
    end
    if input == 'hide' then
        TSMGPHGui:Hide()
        return
    end
    if input == 'show' then
        TSMGPHGui:Show()
        return
    end
    if input == 'set' then
        TSMGPHGui:SetGoldEarnedLabel(''..time())
    end
end

function TSMGPH:LoadTimer()
    TSMGPHGui:Load()
end
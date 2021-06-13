if not TSMGPHConfigCharacter then
    TSMGPHConfigCharacter = {}
end

TSMGPH = {...}

TSMGPH = LibStub('AceAddon-3.0'):NewAddon('TSMGPH', 'AceConsole-3.0', 'AceEvent-3.0')

local TSMGPHOptions = TSMGPHLoader:ImportModule('TSMGPHOptions')
local TSMGPHGui = TSMGPHLoader:ImportModule('TSMGPHGui')

function TSMGPH:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New('TSMGPHDB')

    TSMGPH:RegisterChatCommand('tsmgph', 'TSMGPHSlash')
    TSMGPH:RegisterChatCommand('tsmg', 'TSMGPHSlash')
    if TSMGPH.db.char['show'] then
      TSMGPHGui:Show()
    end
end

function TSMGPH:OnEnable()
    TSMGPH:RegisterEvent('PLAYER_MONEY', TSMGPHGui.Load)
    TSMGPH:RegisterEvent('ITEM_PUSH', TSMGPHGui.Load)
    TSMGPH:RegisterEvent('LOOT_CLOSED', TSMGPHGui.Load)
    TSMGPH:RegisterEvent('BAG_UPDATE', TSMGPHGui.Load)
end

function TSMGPH:TSMGPHSlash(input)
    -- /tsmgph
    if not input or input == '' or input == 'show' or input == 's' then
        TSMGPHGui:Show()
        return
    elseif input == 'hide' or input == 'h' then
        TSMGPHGui:Hide()
        return
    elseif input == 'config' or input == 'c' then
        TSMGPHOptions:OpenConfigWindow()
        return
    elseif input == 'reset' or input == 'r' then
        TSMGPHGui:Reset()
        return
    else
      TSMGPH:Print(
        '\nUnrecognized command ' .. input .. '.\n' ..
        'Available commands for tsmg are:\n' ..
        '    show - Makes TSMGPH visible\n' ..
        '    hide - Makes TSMGPH hidden\n' ..
        '    config - Opens the TSMGPH Config Frame to specify pricing used per item\n' ..
        '    reset - Resets the TSMGPH Starting Time and Gold\n'
      )
    end
end

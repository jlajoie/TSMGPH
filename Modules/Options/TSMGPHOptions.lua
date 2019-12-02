local TSMGPHOptions = TSMGPHLoader:CreateModule("TSMGPHOptions");

TSMGPHOptions.tabs = {...}

local AceGUI = LibStub("AceGUI-3.0")

local _CreateGUI
  
function TSMGPHOptions:OpenConfigWindow()
    local optionsGUI = _CreateGUI()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("TSMGPH", optionsGUI)
    LibStub("AceConfigDialog-3.0"):SetDefaultSize("TSMGPH", 625, 700)
    LibStub("AceConfigDialog-3.0"):Open("TSMGPH")
end

_CreateGUI = function()
    return {
        name = 'TSMGPH',
        handler = TSMGPH,
        type = 'group',
        childGroups = 'tab',
        args = {
            all_tab = TSMGPHOptions.tabs.all:Initialize(),
            unset_tab = TSMGPHOptions.tabs.unset:Initialize(),
        }
    }
end
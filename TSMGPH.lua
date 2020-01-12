if not TSMGPHConfigCharacter then
    TSMGPHConfigCharacter = {}
end

TSMGPH = {...}

TSMGPH = LibStub("AceAddon-3.0"):NewAddon("TSMGPH", "AceConsole-3.0", "AceTimer-3.0")

local TSMGPHOptions = TSMGPHLoader:ImportModule("TSMGPHOptions")
-- local TSMGPHGui = TSMGPHLoader:ImportModule("TSMGPHGui")

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
        -- TSMGPHGui:Hide()
        return
    end
    if input == 'show' then
        -- TSMGPHGui:Show()
        return
    end
    if input == 'set' then
        TSMGPHGui:SetGoldEarnedLabel(''..time())
    end
end

function TSMGPH:LoadTimer()
    -- TSMGPHGui:Load()
end

local f1 = CreateFrame("Frame",nil,UIParent)
f1.texture = f1:CreateTexture()
f1.texture:SetAllPoints(f1)
f1.texture:SetTexture(0, 1, 0)
f1:SetWidth(100) 
f1:SetHeight(100) 
f1:SetAlpha(.90);
f1:SetPoint("CENTER",0,0)
f1.text = f1:CreateFontString(nil,"ARTWORK") 
f1.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
f1.text:SetPoint("CENTER",0,0)
-- f1:Hide()
 
local f2 = CreateFrame("Frame",nil,UIParent)
f2:SetWidth(1) 
f2:SetHeight(1) 
f2:SetAlpha(.90);
f2:SetPoint("CENTER",0,0)
f2.text = f2:CreateFontString(nil,"ARTWORK") 
f2.text:SetFont("Fonts\\ARIALN.ttf", 13)
f2.text:SetPoint("CENTER",0,0)
-- f2:Hide()
 
local function displayupdate(show, message)
    if show == 1 then
        f1.text:SetText(message)
        f1:Show()
        f2:Hide()
    elseif show == 2 then
        f2.text:SetText(message)
        f2:Show()
        f1:Hide()
    else
        f1:Hide()
        f2:Hide()
    end
end
 
displayupdate(1, "|cffffffffmyobjective1")
--or 
displayupdate(2, "|cffffffffmyobjective2")
--or 
displayupdate() -- to just hide both
--or possibly display both objectives in the one fontstring
displayupdate(1, "myobjective1\nmyobjective2")
 
--To use variables:
local objective1 = "myobjective1"
local objective2 = "myobjective2"
displayupdate(1, objective1.."\n"..objective2)
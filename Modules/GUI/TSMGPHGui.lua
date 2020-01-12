local TSMGPHGui = TSMGPHLoader:CreateModule("TSMGPHGui");

local AceGUI = LibStub("AceGUI-3.0")
local frame, button, simpleGroupm, startTimeLabel, startingGoldLabel, goldEarnedLabel, goldEarnedPerHourLabel

 function TSMGPHGui:GetInventoryValue()
    local total, bag, slots, index
    total = 0
    for bag = 0, 4 do
        slots=GetContainerNumSlots(bag)
        for index = 1, slots do
            local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(bag, index)
            if itemCount then
                -- Always use vendorsell for greys
                if not TSMGPH.db.global[''..itemID] == 'ignore' then
                    if quality == 0 then
                        total = total + (_G.TSM_API.GetCustomPriceValue("vendorsell", "i:" .. itemID) or 0) * itemCount
                    else
                        total = total + (_G.TSM_API.GetCustomPriceValue(TSMGPH.db.global[''..itemID] or "vendorsell", "i:" .. itemID) or 0) * itemCount
                    end
                end
            end
        end
    end
    return (GetMoney() + total) / 10000
end

function TSMGPHGui:Hide()
    frame:Hide()
end

function TSMGPHGui:Show()
    if not frame then
        frame = CreateFrame("Frame", "TSMGPHFrame", UIParent)
        frame:SetSize(120, 420)
        frame:SetPoint("CENTER")
        local texture = frame:CreateTexture() 
        texture:SetAllPoints() 
        texture:SetTexture(1,1,1,1) 
        frame.background = texture 
        
        local content = CreateFrame("Frame", nil, scrollframe) 
        content:SetSize(128, 128) 
        local texture = content:CreateTexture() 
        texture:SetAllPoints() 
        texture:SetTexture("Interface\\GLUES\\MainMenu\\Glues-BlizzardLogo") 
        content.texture = texture 
        scrollframe.content = content 

        if not TSMGPH.db.char['startGold'] then
            TSMGPH.db.char['startGold'] = TSMGPHGui:GetInventoryValue()
        end
        if not TSMGPH.db.char['startTime'] then
            TSMGPH.db.char['startTime'] = time()
        end
        if not simpleGroup then
            simpleGroup = AceGUI:Create('SimpleGroup')
        end
        
        if not startTimeLabel then
            startTimeLabel = AceGUI:Create("Label")
            simpleGroup:AddChild(startTimeLabel)
        end
        
        if not startingGoldLabel then
            startingGoldLabel = AceGUI:Create("Label")
            simpleGroup:AddChild(startingGoldLabel)
        end
        
        if not goldEarnedLabel then
            goldEarnedLabel = AceGUI:Create("Label")
            simpleGroup:AddChild(goldEarnedLabel)
        end
        
        if not goldEarnedPerHourLabel then
            goldEarnedPerHourLabel = AceGUI:Create("Label")
            simpleGroup:AddChild(goldEarnedPerHourLabel)
        end
        
        if not button then
            button = AceGUI:Create("Button")
            button:SetWidth(70)
            button:SetText("Reset")
            button:SetCallback('OnClick', function()
                TSMGPHGui:Reset()
                TSMGPHGui:Show()
            end)
        end
        TSMGPHGui:Load()
        
        frame:AddChild(simpleGroup)
        frame:AddChild(button)
    else 
        frame:Show()
        TSMGPHGui:Load()
    end
end

function TSMGPHGui:Load()
    if startTimeLabel and startingGoldLabel and goldEarnedLabel and goldEarnedPerHourLabel then
        TSMGPH.db.char['startTimeLabelText'] = date("%m/%d/%y %H:%M:%S", TSMGPH.db.char['startTime'])
        TSMGPH.db.char['startingGoldLabelText'] = TSMGPHGui:Round(TSMGPH.db.char['startGold'])
        TSMGPH.db.char['goldEarnedLabelText'] = TSMGPHGui:Round(TSMGPHGui:GetInventoryValue() - TSMGPH.db.char['startGold'])
        TSMGPH.db.char['goldEarnedPerHourLabelText'] = TSMGPHGui:Round((TSMGPHGui:GetInventoryValue() - TSMGPH.db.char['startGold']) / ((time() - TSMGPH.db.char['startTime']) / 3600))
        startTimeLabel:SetText('Start time: ' ..  TSMGPH.db.char['startTimeLabelText'])
        startingGoldLabel:SetText('Starting gold: ' ..  TSMGPH.db.char['startingGoldLabelText'])
        goldEarnedLabel:SetText('Gold earned: ' ..  TSMGPH.db.char['goldEarnedLabelText'])
        goldEarnedPerHourLabel:SetText('Gold earned per hour: ' .. TSMGPH.db.char['goldEarnedPerHourLabelText'])
    end
end

function TSMGPHGui:Reset()
    TSMGPH.db.char['startTime'] = time()
    TSMGPH.db.char['startGold'] = TSMGPHGui:GetInventoryValue()
end

function TSMGPHGui:SetGoldEarnedLabel(newLabel)
    if goldEarnedLabel then
        goldEarnedLabel:SetText(newLabel)
    end
end

function TSMGPHGui:Round(num)
    if num then
        return strmatch(''..num, '-?%d*%.?%d?%d?') or 'N/A'
    else
        return 'N/A'
    end
end
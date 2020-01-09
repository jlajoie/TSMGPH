local TSMGPHGui = TSMGPHLoader:CreateModule("TSMGPHGui");

local AceGUI = LibStub("AceGUI-3.0")
local frame
local startTime = time()
local startGold = nil

local button
local simpleGroup
local startTimeLabel
local startingGoldLabel
local goldEarnedLabel
local goldEarnedPerHourLabel

 function TSMGPHGui:GetInventoryValue()
    local TSM_API = _G.TSM_API
    local total, bag, slots, index
    total = 0
    for bag = 0, 4 do
        slots=GetContainerNumSlots(bag)
        for index = 1, slots do
            local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(bag, index)
            if itemCount then
                -- Always use vendorsell for greys
                if quality == 0 then
                    total = total + (TSM_API.GetCustomPriceValue("vendorsell", "i:" .. itemID) or 0) * itemCount
                else
                    total = total + (TSM_API.GetCustomPriceValue(TSMGPH.db.global[''..itemID] or "vendorsell", "i:" .. itemID) or 0) * itemCount
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
        frame = AceGUI:Create("Frame")
        frame:SetHeight(120)
        frame:SetWidth(420)
        frame:SetTitle("TSM Gold per Hour")
        frame:SetLayout("Flow")
        if startGold == nil then
            startGold = TSMGPHGui:GetInventoryValue()
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
        local startTimeLabelText = date("%m/%d/%y %H:%M:%S", startTime)
        local startingGoldLabelText = TSMGPHGui:Round(startGold)
        local goldEarnedLabelText = TSMGPHGui:Round(TSMGPHGui:GetInventoryValue() - startGold)
        local goldEarnedPerHourLabelText = TSMGPHGui:Round((TSMGPHGui:GetInventoryValue() - startGold) / ((time() - startTime) / 3600))
        startTimeLabel:SetText('Start time: ' ..  startTimeLabelText)
        startingGoldLabel:SetText('Starting gold: ' ..  startingGoldLabelText)
        goldEarnedLabel:SetText('Gold earned: ' ..  goldEarnedLabelText)
        goldEarnedPerHourLabel:SetText('Gold earned per hour: ' .. goldEarnedPerHourLabelText)
    end
end

function TSMGPHGui:Reset()
    startTime = time()
    startGold = TSMGPHGui:GetInventoryValue()
end

function TSMGPHGui:SetGoldEarnedLabel(newLabel)
    if goldEarnedLabel then
        goldEarnedLabel:SetText(newLabel)
    end
end

function TSMGPHGui:Round(num)
    return strmatch(''..num, '-?%d*%.?%d?%d?') or '0'
end
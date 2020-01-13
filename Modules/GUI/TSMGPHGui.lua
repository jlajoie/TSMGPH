local TSMGPHGui = TSMGPHLoader:CreateModule('TSMGPHGui');

local AceGUI = LibStub('AceGUI-3.0')
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
                -- if not TSMGPH.db.global[''..itemID] == 'ignore' then
                if TSMGPH.db.global[''..itemID] ~= 'ignore' then
                    if quality == 0 then
                        total = total + (_G.TSM_API.GetCustomPriceValue('vendorsell', 'i:' .. itemID) or 0) * itemCount
                    else
                        total = total + (_G.TSM_API.GetCustomPriceValue(TSMGPH.db.global[''..itemID] or 'vendorsell', 'i:' .. itemID) or 0) * itemCount
                    end
                end
            end
        end
    end
    return (GetMoney() + total) / 10000
end

function TSMGPHGui:Hide()
    frame:Hide()
    TSMGPH.db.char['show'] = false
end


function TSMGPHGui:Initialize()
  if not frame then
      frame = CreateFrame('Frame', "TSMGPHFrame", UIParent)
      frame.texture = frame:CreateTexture()
      frame.texture:SetAllPoints(frame)
      frame:SetBackdrop( {
          bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background',
      });
      frame:SetBackdropColor(1, 1, 1, 1)
      frame:SetMovable(true)
      frame:SetPoint("TOPLEFT", 0, 0)

      frame:EnableMouse(true)
      frame:RegisterForDrag('LeftButton')
      frame:SetScript('OnDragStart', function()
        frame:StartMoving()
      end)
      frame:SetScript('OnDragStop', function()
        frame:StopMovingOrSizing()
        local _, _, _, offsetX, offsetY = frame:GetPoint()
        TSMGPH.db.char['offsetX'] = offsetX
        TSMGPH.db.char['offsetY'] = offsetY
      end)
      frame.text = frame:CreateFontString(nil,'ARTWORK')
      frame.text:SetFont('Fonts\\ARIALN.ttf', 13, nil)
      frame.text:SetJustifyH('LEFT');
      frame.text:SetPoint('TOPLEFT', 4, -4)
      TSMGPHGui:Load()

      frame:SetWidth(8 + frame.text:GetStringWidth())
      frame:SetHeight(8 + frame.text:GetStringHeight())

      if not TSMGPH.db.char['startGold'] then
          TSMGPH.db.char['startGold'] = TSMGPHGui:GetInventoryValue()
      end
      if not TSMGPH.db.char['startTime'] then
          TSMGPH.db.char['startTime'] = time()
      end
      frame:Show()
  end
end

function TSMGPHGui:Show()
    if not frame then
        TSMGPHGui:Initialize()
    else
        frame:Show()
        TSMGPHGui:Load()
    end
    TSMGPH.db.char['show'] = true
end

function TSMGPHGui:Load()
    if frame and TSMGPH.db.char['startTime'] and TSMGPH.db.char['startGold'] then
        TSMGPH.db.char['startTimeLabelText'] = date('%m/%d/%y %H:%M:%S', TSMGPH.db.char['startTime'])
        TSMGPH.db.char['startingGoldLabelText'] = TSMGPHGui:Round(TSMGPH.db.char['startGold'])
        TSMGPH.db.char['goldEarnedLabelText'] = TSMGPHGui:Round(TSMGPHGui:GetInventoryValue() - TSMGPH.db.char['startGold'])
        if (time() - TSMGPH.db.char['startTime']) ~= 0 then
          TSMGPH.db.char['goldEarnedPerHourLabelText'] = TSMGPHGui:Round((TSMGPHGui:GetInventoryValue() - TSMGPH.db.char['startGold']) / ((time() - TSMGPH.db.char['startTime']) / 3600))
        else
          TSMGPH.db.char['goldEarnedPerHourLabelText'] = 0
        end
        local text = (
          'Start time: ' ..  TSMGPH.db.char['startTimeLabelText'] .. '\n' ..
          'Starting gold: ' ..  TSMGPH.db.char['startingGoldLabelText'] .. '\n' ..
          'Gold earned: ' ..  TSMGPH.db.char['goldEarnedLabelText'] .. '\n' ..
          'Gold earned per hour: ' .. TSMGPH.db.char['goldEarnedPerHourLabelText']
        )

        frame.text:SetText(text)
    end
end

function TSMGPHGui:Reset()
    TSMGPH.db.char['startTime'] = time()
    TSMGPH.db.char['startGold'] = TSMGPHGui:GetInventoryValue()
    TSMGPHGui:Load()
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

local TSMGPHOptions = TSMGPHLoader:ImportModule('TSMGPHOptions');

TSMGPHOptions.tabs.all = {...}

function TSMGPHOptions.tabs.all:Initialize()
    local args = {}
    local bag, slots, index, order
    order = 1

    args['tsmgph_header'] = {
        type = 'header',
        order = 0,
        name = 'Trade Skill Master Gold per Hour'
    }

    for bag = 0, 4 do
        slots = GetContainerNumSlots(bag)
        for index = 1, slots do
            local _, itemCount, _, quality, _, _, itemLink, _, _, itemID = GetContainerItemInfo(bag, index)
            if itemCount and _G.TSM_API.GetCustomPriceValue('vendorsell', 'i:' .. itemID) and  quality > 0 then
                args['select'..itemID] = {
                    name = itemLink,
                    type = 'select',
                    values = {
                        dbmarket = 'Auction',
                        vendorsell = 'Vendor',
                        ignore = 'Ignore',
                    },
                    get = function() 
                        if not TSMGPH.db.global[''..itemID] then
                            return ''
                        else
                            return TSMGPH.db.global[''..itemID]
                        end
                    end,
                    set = function(input, option) 
                        TSMGPH.db.global[''..itemID] = option
                    end,
                    style = 'radio',
                }
                order = order + 1
            end
        end
    end

    return {
        name = 'All Items',
        type = 'group',
        order = 1,
        args = args
    }
end
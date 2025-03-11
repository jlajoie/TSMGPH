local TSMGPHOptions = TSMGPHLoader:ImportModule('TSMGPHOptions');

TSMGPHOptions.tabs.unset = {...}

function TSMGPHOptions.tabs.unset:Initialize()
    local args = {}
    local bag, slots, index, order
    order = 1

    args['tsmgph_header'] = {
        type = 'header',
        order = 0,
        name = 'Trade Skill Master Gold per Hour'
    }

    for bag = 0, 4 do
        slots = C_Container.GetContainerNumSlots(bag)
        for index = 1, slots do
            local info = C_Container.GetContainerItemInfo(bag, index)
            if info and info.stackCount and (
                _G.TSM_API.GetCustomPriceValue('vendorsell', 'i:' .. info.itemID) or 
                _G.TSM_API.GetCustomPriceValue('dbminbuyout', 'i:' .. info.itemID)
            ) and (
                info.quality ~= 0 or
                info.quality == 2 and _G.TSM_API.GetCustomPriceValue('destroy', 'i:' .. info.itemID)
            ) and not TSMGPH.db.global[''..info.itemID] then
                args['select'..info.itemID] = {
                    name = info.hyperlink,
                    type = 'select',
                    values = {
                        dbminbuyout  = 'Auction',
                        destroy = 'Disenchant',
                        vendorsell = 'Vendor',
                        ignore = 'Ignore',
                    },
                    get = function() 
                        if not TSMGPH.db.global[''..info.itemID] then
                            return ''
                        else
                            return TSMGPH.db.global[''..info.itemID]
                        end
                    end,
                    set = function(input, option) 
                        TSMGPH.db.global[''..info.itemID] = option
                    end,
                    style = 'radio',
                }
                order = order + 1
            end
        end
    end

    return {
        name = 'Unset Items',
        type = 'group',
        order = 2,
        args = args
    }
end
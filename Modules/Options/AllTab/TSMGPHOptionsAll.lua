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
        slots = C_Container.GetContainerNumSlots(bag)
        for index = 1, slots do
            local info = C_Container.GetContainerItemInfo(bag, index)
            if info and info.stackCount and info.quality > 0 then
                args['select' .. info.itemID] = {
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
        name = 'All Items',
        type = 'group',
        order = 1,
        args = args
    }
end
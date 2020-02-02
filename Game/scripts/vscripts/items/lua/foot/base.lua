require('items/lua/base')
BaseFoot = class(BaseItem, nil, BaseItem)
local itemClass = BaseFoot
function itemClass:GetSlotTextShort()
    return 'feet'
end
function itemClass:GetSlotText()
    return 'Slot: Feet'
end
function itemClass:GetSlotNumber()
    return RPC_GEAR_SLOT_BOOTS
end

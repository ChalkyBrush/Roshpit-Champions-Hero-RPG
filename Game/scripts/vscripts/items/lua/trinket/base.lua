require('items/lua/base')
BaseTrinket = class(BaseItem, nil, BaseItem)
local itemClass = BaseTrinket
function itemClass:GetSlotTextShort()
    return 'amulet'
end
function itemClass:GetSlotText()
    return 'Slot: Trinket'
end
function itemClass:GetSlotNumber()
    return RPC_GEAR_SLOT_TRINKET
end
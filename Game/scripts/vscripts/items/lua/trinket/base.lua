require('items/lua/base')
BaseTrinket = class(BaseItem, nil, BaseItem)
local class = BaseTrinket
function class:GetSlotTextShort()
    return 'amulet'
end
function class:GetSlotText()
    return 'Slot: Trinket'
end
function class:GetSlotNumber()
    return RPC_GEAR_SLOT_TRINKET
end
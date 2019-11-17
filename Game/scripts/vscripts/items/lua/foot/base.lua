require('items/lua/base')
BaseFoot = class(BaseItem, nil, BaseItem)
local class = BaseFoot
function class:GetSlotTextShort()
    return 'feet'
end
function class:GetSlotText()
    return 'Slot: Feet'
end
function class:GetSlotNumber()
    return RPC_GEAR_SLOT_BOOTS
end

require('items/lua/base')
BaseGloves = class(BaseItem, nil, BaseItem)
local itemClass = BaseGloves
function itemClass:GetSlotTextShort()
    return 'feet'
end
function itemClass:GetSlotText()
    return 'Slot: Feet'
end
function itemClass:GetSlotNumber()
    return RPC_GEAR_SLOT_GLOVES
end

require('items/lua/base_item')
BaseGloves = class(BaseItem, nil, BaseItem)
local itemClass = BaseGloves
function itemClass:GetSlotTextShort()
    return 'hands'
end
function itemClass:GetSlotText()
    return 'Slot: Hands'
end
function itemClass:GetSlotNumber()
    return RPC_GEAR_SLOT_GLOVES
end

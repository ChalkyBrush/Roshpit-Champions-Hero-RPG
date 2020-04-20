require('items/lua/base_item')
BaseBody = class(BaseItem, nil, BaseItem)
local itemClass = BaseBody
function itemClass:GetSlotTextShort()
    return 'body'
end
function itemClass:GetSlotText()
    return 'Slot: Body'
end
function itemClass:GetSlotNumber()
    return RPC_GEAR_SLOT_BODY
end
require('items/lua/base')
BaseBody = class(BaseItem, nil, BaseItem)
local class = BaseBody
function class:GetSlotTextShort()
    return 'body'
end
function class:GetSlotText()
    return 'Slot: Body'
end
function class:GetSlotNumber()
    return RPC_GEAR_SLOT_BODY
end
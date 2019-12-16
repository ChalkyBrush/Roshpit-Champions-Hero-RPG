require('items/lua/base')
BaseHelm = class(BaseItem, nil, BaseItem)
local class = BaseHelm
function class:GetSlotTextShort()
    return 'head'
end
function class:GetSlotText()
    return 'Slot: Head'
end
function class:GetSlotNumber()
    return RPC_GEAR_SLOT_HEAD
end

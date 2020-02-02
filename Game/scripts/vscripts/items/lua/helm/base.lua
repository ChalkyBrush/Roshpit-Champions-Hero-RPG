require('items/lua/base')
require('items/constants/helm')
BaseHelm = class(BaseItem, nil, BaseItem)
local itemClass = BaseHelm
function itemClass:GetSlotTextShort()
    return 'head'
end
function itemClass:GetSlotText()
    return 'Slot: Head'
end
function itemClass:GetSlotNumber()
    return RPC_GEAR_SLOT_HEAD
end

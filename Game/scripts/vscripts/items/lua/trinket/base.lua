require('items/lua/base')
BaseTrinket = class(BaseItem, nil, BaseItem)
local class = BaseTrinket

function class:RollProperty3()
    self:RollRuneProperty(3, 1)
end
function class:RollProperty4()
    self:RollRuneProperty(4, 1)
end
function class:HasRuneSlots()
    return true
end
function class:GetSlot()
    return 'amulet'
end
function class:GetSlotText()
    return 'Slot: Trinket'
end

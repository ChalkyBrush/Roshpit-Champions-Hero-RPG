require('items/lua/base')
BaseFoot = class(BaseItem, nil, BaseItem)
local class = BaseFoot
function class:RollProperty1(maxFactor)
    RPCItems:RollFootProperty1(self, 0)
end
function class:RollProperty2(maxFactor)
    RPCItems:RollFootProperty2(self, 0)
end
function class:RollProperty3(maxFactor)
    RPCItems:RollFootProperty3(self, 0)
end
function class:RollProperty4(maxFactor)
    RPCItems:RollFootProperty4(self, 0)
end
function class:GetSlot()
    return 'feet'
end
function class:GetSlotText()
    return 'Slot: Feet'
end

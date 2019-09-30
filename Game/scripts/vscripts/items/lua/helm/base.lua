require('items/lua/base')
BaseHelm = class(BaseItem, nil, BaseItem)
local class = BaseHelm
function class:RollProperty1(maxFactor)
    RPCItems:RollHoodProperty1(self, 0)
end
function class:RollProperty2(maxFactor)
    RPCItems:RollHoodProperty2(self, 0)
end
function class:RollProperty3(maxFactor)
    RPCItems:RollHoodProperty3(self, 0)
end
function class:RollProperty4(maxFactor)
    RPCItems:RollHoodProperty4(self, 0)
end
function class:GetSlot()
    return 'head'
end
function class:GetSlotText()
    return 'Slot: Head'
end

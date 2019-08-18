require('items/lua/base')
BaseFoot = class(BaseItem, nil, BaseItem)
local class = BaseFoot
function class:RollProperty1()
    RPCItems:RollFootProperty1(self, 0)
end
function class:RollProperty2()
    RPCItems:RollFootProperty2(self, 0)
end
function class:RollProperty3()
    RPCItems:RollFootProperty3(self, 0)
end
function class:RollProperty4()
    RPCItems:RollFootProperty4(self, 0)
end
function class:GetSlot()
    return 'feet'
end
function class:GetSlotText()
    return 'Slot: Feet'
end

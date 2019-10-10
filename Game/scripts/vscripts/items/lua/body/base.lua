require('items/lua/base')
BaseBody = class(BaseItem, nil, BaseItem)
local class = BaseBody
function class:RollProperty1(maxFactor)
    RPCItems:RollBodyProperty1(self, 0)
end
function class:RollProperty2(maxFactor)
    RPCItems:RollBodyProperty2(self, 0)
end
function class:RollProperty3(maxFactor)
    RPCItems:RollBodyProperty3(self, 0)
end
function class:RollProperty4(maxFactor)
    RPCItems:RollBodyProperty4(self, 0)
end
function class:GetSlot()
    return 'body'
end
function class:GetSlotText()
    return 'Slot: Body'
end

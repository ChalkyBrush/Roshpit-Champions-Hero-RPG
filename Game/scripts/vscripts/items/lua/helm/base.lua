require('items/lua/base')
BaseHelm = class(BaseItem, nil, BaseItem)
local class = BaseHelm
function class:RollProperty1(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 1, item_level, nil, 1)
end
function class:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, nil, 1)
end
function class:RollProperty3(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, nil, 1)
end
function class:RollProperty4(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, nil, 1)
end
function class:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function class:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 0)
end
function class:GetSlotTextShort()
    return 'head'
end
function class:GetSlotText()
    return 'Slot: Head'
end
function class:GetSlotNumber()
    return RPC_GEAR_SLOT_HEAD
end

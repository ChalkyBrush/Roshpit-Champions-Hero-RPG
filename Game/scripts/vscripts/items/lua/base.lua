require('items/equipment')
BaseItem = class({})
local class = BaseItem
function class:RollProperty1()
    error('Define roll')
end
function class:RollProperty2()
    error('Define roll')
end
function class:RollProperty3()
    error('Define roll')
end
function class:RollProperty4()
    error('Define roll')
end
function class:GetName()
    error('Define item name')
end
function class:GetSlot()
    error('Define slot')
end
function class:GetSlotText()
    error('Define slot text')
end
function class:GetModifierName()
    error('Define modifier name')
end
function class:GetClassName()
    error('Define class name')
end
function class:HasRuneSlots()
    return false
end
function class:Create(position)
    self = RPCItems:CreateVariant(self:GetClassName(), "immortal", self:GetName(), self:GetSlot(), true, self:GetSlotText())
    self.isLuaItem = true
    self.newItemTable.hasRunePoints = self:HasRuneSlots()
    self:RollProperty1()
    self:RollProperty2()
    self:RollProperty3()
    self:RollProperty4()

    CreateItemOnPositionSync(position, self)
    RPCItems:DropItem(self, position)
    return self
end

function class:OnSpellStart()
    local caster = self:GetCaster()
    equip_item({
        ability = self,
        caster = caster,
    })
end
function class:SetSpecialValue(name, color)
    RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_" .. name, color, 1, "#property_"..name.."_description")
end
function class:AddSpecialModifiers(caster)
    caster:AddNewModifier(caster, self, self:GetModifierName(), {})
end
function class:RemoveSpecialModifiers(caster)
    caster:RemoveModifierByName(self:GetModifierName())
end
require('items/equipment')
BaseItem = class({})
local class = BaseItem
local normalPropertiesTable = {
    vision = {
        name = '#item_vision_bonus',
        color = '#96D1D9',
    }
}
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
function class:GetAllowedRuneLetters()
    return {'q', 'w', 'e', 'r'}
end
function class:GetAllowedRuneTiers()
    return {1, 2}
end
function class:RollRuneProperty(slot, rollAmplifiesPerTier)
    local letters = self:GetAllowedRuneLetters()
    local tiers = self:GetAllowedRuneTiers()

    local rnd = RandomInt(0,#letters * #tiers - 1)
    local letter =  letters[rnd % #letters + 1]

    local tier = math.floor(rnd/#letters) + 1
    local propertyName = 'rune_' .. letter .. '_' .. tier
    local value = self:RollRune(1)

    if type(rollAmplifiesPerTier) == 'table' then
        value = math.ceil(rollAmplifiesPerTier[tier] * value)
    else
        value = value * rollAmplifiesPerTier
    end

    self.newItemTable['property' .. slot] = value
    self.newItemTable['property' .. slot .. 'name'] = propertyName
    RPCItems:SetPropertyValues(self, self.newItemTable['property' .. slot], "rune", "#7DFF12", slot)
end
function class:RollRune(rollAmplify)
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    return math.ceil(value * rollAmplify)
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
    self.isLuaItem = true
    equip_item({
        ability = self,
        caster = caster,
    })
end
function class:SetSpecialValue(name, color)
    RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_" .. name, color, 1, "#property_"..name.."_description")
end
function class:SetNormalValue(propertyNumber)
    local info = normalPropertiesTable[self.newItemTable["property" .. propertyNumber .. 'name']]
    if info == nil then
        error('property ' .. self.newItemTable["property" .. propertyNumber .. 'name'] .. ' unknown. Add it to table')
    end
    RPCItems:SetPropertyValues(self, self.newItemTable["property" .. propertyNumber], info.name, info.color, propertyNumber)
    end
function class:AddSpecialModifiers(caster)
    caster:AddNewModifier(caster, self, self:GetModifierName(), {})
end
function class:RemoveSpecialModifiers(caster)
    caster:RemoveModifierByName(self:GetModifierName())
end
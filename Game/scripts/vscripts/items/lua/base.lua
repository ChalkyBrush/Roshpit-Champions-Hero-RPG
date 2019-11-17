require('items/equipment')
BaseItem = class({})
local class = BaseItem
local normalPropertiesTable = {
    vision = {
        name = '#item_vision_bonus',
        color = '#96D1D9',
    }
}
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
    error('Define armor roll')
end
function class:RollMagicArmor(item_level)
    error('Define magic armor roll')
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
function class:GetSlotTextShort()
    error('Define slot text short')
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
function class:GetSlotNumber()
    error('Define slot number')
end
function class:HasRuneSlots()
    return false
end
function class:CreateLuaItem(item_level)
    self = RPCItems:CreateVariant(self:GetClassName(), "immortal", self:GetName(), self:GetSlotTextShort(), true, self:GetSlotText())
    self.isLuaItem = true
    self.newItemTable.hasRunePoints = self:HasRuneSlots()
    local maxFactor = RPCItems:GetMaxFactor()
    self:RollProperty1(item_level)
    self:RollProperty2(item_level)
    self:RollProperty3(item_level)
    self:RollProperty4(item_level)
    self:RollArmor(item_level)
    self:RollMagicArmor(item_level)
    RPCItems:SocketsChance(self)
    RPCItems:SetBaseItemValues(self, self:GetClassName(), false, 
        RPCItems.BASIC_ITEMS_SLOT_TEXT[self:GetSlotNumber()], RPC_ITEM_RARITY_COLORS[RPC_ITEMS_RARITY_IMMORTAL], 
        RPCItems:GetRarityNameFromFactor(RPC_ITEMS_RARITY_IMMORTAL), RPC_ITEMS_RARITY_IMMORTAL, item_level, self:GetSlotNumber())
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
function class:OnLoadItem()
    self.isLuaItem = true
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
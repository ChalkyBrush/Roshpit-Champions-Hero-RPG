require('items/lua/body/base')
require('npc_abilities/base_modifier')

item_rpc_armor_of_atlantis = class(BaseBody, nil, BaseBody)
modifier_armor_of_atlantis = class(npc_base_modifier, nil, npc_base_modifier)
local class = item_rpc_armor_of_atlantis
local className = 'item_rpc_armor_of_atlantis'

local modifierClass = modifier_armor_of_atlantis
local modifierName = 'modifier_armor_of_atlantis'
LinkLuaModifier(modifierName, "items/lua/body/armor_of_atlantis", LUA_MODIFIER_MOTION_NONE)

function class:GetClassName()
    return className
end
function class:GetName()
    return 'Whatever the fuck this is for'
end
function class:GetModifierName()
    return modifierName
end
function class:HasRuneSlots()
    return true
end
function class:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "armor_of_atlantis"
    self:SetSpecialValue(self.newItemTable.property1name, "#478EC1")
end
function class:RollProperty2(maxFactor)
    local value, nameLevel = RPCItems:RollAttribute(0, 4, 16, 0, 0, self.newItemTable.rarity, false, maxFactor * 18)
    self.newItemTable.property2 = value
    self.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(self, self.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)
end

function modifierClass:GetDamageReduction()
    local hero = self:GetCaster()
    local missingHealthPercent = math.floor((1 - hero:GetHealth() / hero:GetMaxHealth()) * 100)
    return math.min(ARMOR_OF_ATLANTIS_DMG_REDUCTION_PCT_PER_MISSING_HP_PCT * missingHealthPercent, ARMOR_OF_ATLANTIS_MAX_DMG_REDUCTION_PCT) / 100
end

function modifierClass:IsHidden()
    return false
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetTexture()
    return "item/seafortress/armor_of_atlantis"
end
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
function class:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_armor_of_atlantis"
    self:SetSpecialValue("armor_of_atlantis", "#478EC1")
end
function class:RollProperty2(item_level)
     RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "all_attributes", 1)
end

function class:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 3)
end
function class:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 0)
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
    return funcs
end

function modifierClass:GetModifierBaseAttack_BonusDamage()
    local hero = self:GetCaster()
    if IsServer() then
        if self:GetAbility():GetGemValue("sapphire") > 0 then
            local missing_health = hero:GetMaxHealth() - hero:GetHealth()
            return missing_health* self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_ARMOR_OF_ATLANTIS_GEM_SAPPHIRE)
        else
            return 0
        end
    end
end

function modifierClass:GetDamageReduction()
    local hero = self:GetCaster()
    local missingHealthPercent = math.floor((1 - hero:GetHealth() / hero:GetMaxHealth()) * 100)
    local damage_reduction_per_missing_health_pct = ITEM_RPC_ARMOR_OF_ATLANTIS_DMG_REDUCTION_PCT_PER_MISSING_HP_PCT
    if IsServer() then
        damage_reduction_per_missing_health_pct = ITEM_RPC_ARMOR_OF_ATLANTIS_DMG_REDUCTION_PCT_PER_MISSING_HP_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_ARMOR_OF_ATLANTIS_GEM_RUBY)
    end
    return math.min(damage_reduction_per_missing_health_pct * missingHealthPercent, ITEM_RPC_ARMOR_OF_ATLANTIS_MAX_DMG_REDUCTION_PCT) / 100
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
require('items/lua/foot/base')
require('npc_abilities/base_modifier')

------------------------------------------------
--------- NOT USED YET!!!!!!!!------------------
------------------------------------------------

item_rpc_bloodstone_boots = class(BaseFoot, nil, BaseFoot)
modifier_bloodstone_boots = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_bloodstone_boots
local itemClassName = 'item_rpc_bloodstone_boots'

local modifierClass = modifier_bloodstone_boots
local modifierName = 'modifier_bloodstone_boots'
LinkLuaModifier(modifierName, "items/lua/foot/bloodstone_boots", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'bloodstone_boots'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_bloodstone_boots"
    self:SetSpecialValue("bloodstone_boots", "#E2371D")
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "max_health", 2)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.75)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_PURE_DMG_REDUCTION,
        MODIFIER_ROSHPIT_E_MIN_CD_MOD,
        MODIFIER_ROSHPIT_E_MAX_CD_MOD,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifierClass:GetPhysicalDamageReduction()
    if IsServer() then
        local hero = self:GetParent()
        local threshold = ITEM_RPC_BLOODSTONE_BOOTS_HP_THRESHOLD_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BLOODSTONE_BOOTS_GEM_RUBY)
        if hero:GetHealth() <= hero:GetMaxHealth() * (threshold / 100) then
            return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_BLOODSTONE_BOOTS_GEM_EMERALD) / 100
        end
        return nil
    end
end
function modifierClass:GetMagicalDamageReduction()
    if IsServer() then
        local hero = self:GetParent()
        local threshold = ITEM_RPC_BLOODSTONE_BOOTS_HP_THRESHOLD_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BLOODSTONE_BOOTS_GEM_RUBY)
        if hero:GetHealth() <= hero:GetMaxHealth() * (threshold / 100) then
            return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_BLOODSTONE_BOOTS_GEM_EMERALD) / 100
        end
        return nil
    end
end
function modifierClass:GetPureDamageReduction()
    if IsServer() then
        local hero = self:GetParent()
        local threshold = ITEM_RPC_BLOODSTONE_BOOTS_HP_THRESHOLD_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BLOODSTONE_BOOTS_GEM_RUBY)
        if hero:GetHealth() <= hero:GetMaxHealth() * (threshold / 100) then
            return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_BLOODSTONE_BOOTS_GEM_EMERALD) / 100
        end
        return nil
    end
end
function modifierClass:GetRoshpitArmorPierceBonus(params)
    local hero = self:GetParent()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLOODSTONE_BOOTS_GEM_SAPPHIRE) * (hero:GetMaxHealth() - hero:GetHealth())
end
function modifierClass:GetRoshpitSpellPierceBonus(params)
    local hero = self:GetParent()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLOODSTONE_BOOTS_GEM_SAPPHIRE) * (hero:GetMaxHealth() - hero:GetHealth())
end

function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if IsServer() then
        local hero = self:GetParent()
        local threshold = ITEM_RPC_BLOODSTONE_BOOTS_HP_THRESHOLD_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BLOODSTONE_BOOTS_GEM_RUBY)
        if hero:GetHealth() <= hero:GetMaxHealth() * (threshold / 100) then
            return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLOODSTONE_BOOTS_GEM_AMETHYST1)
        end
        return nil
    end
end

function modifierClass:GetModifierMoveSpeed_Max_Increase(params)
    if IsServer() then
        local hero = self:GetParent()
        local threshold = ITEM_RPC_BLOODSTONE_BOOTS_HP_THRESHOLD_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BLOODSTONE_BOOTS_GEM_RUBY)
        if hero:GetHealth() <= hero:GetMaxHealth() * (threshold / 100) then
            return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLOODSTONE_BOOTS_GEM_AMETHYST2)
        end
        return nil
    end
end

function modifierClass:GetRoshpitEMaxCdModifier()
    local hero = self:GetParent()
    local threshold = ITEM_RPC_BLOODSTONE_BOOTS_HP_THRESHOLD_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BLOODSTONE_BOOTS_GEM_RUBY)
    if hero:GetHealth() <= hero:GetMaxHealth() * (threshold / 100) then
        return ITEM_RPC_BLOODSTONE_BOOTS_E_CD
    end
    return nil
end
function modifierClass:GetRoshpitEMinCdModifier()
    local hero = self:GetParent()
    local threshold = ITEM_RPC_BLOODSTONE_BOOTS_HP_THRESHOLD_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BLOODSTONE_BOOTS_GEM_RUBY)
    if hero:GetHealth() <= hero:GetMaxHealth() * (threshold / 100) then
        return ITEM_RPC_BLOODSTONE_BOOTS_E_CD
    end
    return nil
end

function modifierClass:IsHidden()
    return true
end
function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetTexture()
    return "itemicons/bloodstone_boots"
end
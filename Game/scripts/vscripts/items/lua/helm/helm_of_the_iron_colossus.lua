require('items/lua/helm/base')
require('npc_abilities/base_modifier')

item_rpc_helm_of_the_iron_colossus = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_helm_of_the_iron_colossus
local itemClassName = 'item_rpc_helm_of_the_iron_colossus'

modifier_helm_of_the_iron_colossus = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_helm_of_the_iron_colossus
local modifierName = 'modifier_helm_of_the_iron_colossus'
LinkLuaModifier(modifierName, "items/lua/helm/helm_of_the_iron_colossus", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Helm of the Iron Colossus'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_helm_of_the_iron_colossus"
    self:SetSpecialValue("helm_of_the_iron_colossus", "#874E4D")
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "strength", 1.5)    
end

function itemClass:RollProperty3(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, "armor", 1.5)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 3)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 0.5)
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_BASE_ARMOR_BONUS,
        MODIFIER_SPECIAL_TYPE_CAST_W_ABILITY 
    })
    self:StartIntervalThink(ARCANE_CASCADE_TICKRATE)
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_MAX_ATTACK_RANGE,
        MODIFIER_PROPERTY_BASE_ROSHPIT_ARMOR,
        MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifierClass:GetModifierBaseAttack_BonusDamage(params)
	local hero = self:GetParent()
	local str_mult = IRON_COLOSSUS_ATT_PER_STR + self:GetAbility():GetFinalGemPropertyValue("amethyst", IRON_COLOSSUS_AMETHYST)
	return hero:GetStrength()*str_mult
end

function modifierClass:GetModifierModelScale(params)
    return IRON_COLOSSUS_MODEL_SCALE
end

function modifierClass:GetModifierMaxAttackRange(params)
	local target_range = IRON_COLOSSUS_ATT_RNG
    return target_range
end

function modifierClass:GetModifierAttackSpeedBaseOverride()
    return IRON_COLOSSUS_ATT_SPD / 100
end

function modifierClass:GetRoshpitBaseArmorBonus()
	local hero = self:GetParent()
	local armor_per_str = IRON_COLOSSUS_AMR_PER_STR + self:GetAbility():GetFinalGemPropertyValue("emerald", IRON_COLOSSUS_EMERALD)
	return hero:GetStrength()*armor_per_str
end
function modifierClass:OnCastWAbility()
    local hero = self:GetParent()
    local ability = hero:GetAbilityByIndex(DOTA_W_SLOT)
    local manaCost = ability:GetManaCost(-1) * (IRON_COLOSSUS_INCR_W_MANA_COST_PCT - self:GetAbility():GetFinalGemPropertyValue("sapphire", IRON_COLOSSUS_SAPPHIRE)) / 100
    self:GetParent():ReduceMana(manaCost)
end

function modifierClass:OnAttackLanded(event)
    local attacker = event.attacker
    local target = event.target
    local ability = event.ability
    local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * (IRON_COLOSSUS_DMG_PER_ATT + self:GetAbility():GetFinalGemPropertyValue("amethyst", IRON_COLOSSUS_AMETHYST))
    if not target.dummy then
        Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
        Filters:ApplyStun(attacker, IRON_COLOSSUS_STUN_DURATION, target)
    end
end

function modifierClass:GetAttackSound(params)
    return "RPCItems.IronColossus.Attack"
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
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
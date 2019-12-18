require('items/lua/helm/base')
require('npc_abilities/base_modifier')

item_rpc_arcane_cascade_hat = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_arcane_cascade_hat
local itemClassName = 'item_rpc_arcane_cascade_hat'

modifier_arcane_cascade_hat = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_arcane_cascade_hat
local modifierName = 'modifier_arcane_cascade_hat'
LinkLuaModifier(modifierName, "items/lua/helm/arcane_cascade_hat", LUA_MODIFIER_MOTION_NONE)

modifier_arcane_cascade_hat_debuff = class(npc_base_modifier, nil, npc_base_modifier)
local debuffModifierClass = modifier_arcane_cascade_hat_debuff
local debuffModifierName = 'modifier_arcane_cascade_hat_debuff'
LinkLuaModifier(debuffModifierName, "items/lua/helm/arcane_cascade_hat", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Arcane Cascade Hat'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_arcane_cascade_hat"
    self:SetSpecialValue("arcane_cascade_hat", "#E558F5")
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "max_mana", 1.5)
end

function itemClass:RollProperty3(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, "intelligence", 1.5)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 3)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(ARCANE_CASCADE_TICKRATE)
end
function modifierClass:OnIntervalThink()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local manaDrain = caster:GetMaxMana() * (ARCANE_CASCADE_MANA_DRAIN + self:GetAbility():GetFinalGemPropertyValue("sapphire", ARCANE_CASCADE_SAPPHIRE)/100)
    if manaDrain > caster:GetMana() then
        manaDrain = caster:GetMana()
    end
    self:GetAbility().damage = manaDrain * ARCANE_CASCADE_DAMAGE
    caster:ReduceMana(manaDrain)
end
function modifierClass:IsHidden()
    return true
end
function modifierClass:IsBuff()
    return true
end
function modifierClass:IsAura()
    return true
end
function modifierClass:IsAuraActiveOnDeath()
    return false
end
function modifierClass:GetAuraRadius()
    return ARCANE_CASCADE_RANGE
end
function modifierClass:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifierClass:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end
function modifierClass:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifierClass:RemoveOnDeath()
    return false
end
function modifierClass:GetModifierAura()
    return debuffModifierName
end

----------------
--ENEMY DEBUFF--
----------------
function debuffModifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS })
    self:StartIntervalThink(ARCANE_CASCADE_TICKRATE)
end

function debuffModifierClass:OnIntervalThink()
    if not IsServer() then
        return
    end
    local target = self:GetParent()
    local ability = self:GetAbility()
    if ability.damage then
        print("Damage: "..ability.damage)
		local damage = ability.damage
		Filters:ApplyItemDamage(target, self:GetCaster(), damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	end
end
function debuffModifierClass:GetRoshpitMagicArmorBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ARCANE_CASCADE_AMETHYST)
end
function debuffModifierClass:IsHidden()
    return true
end
function debuffModifierClass:IsDebuff()
    return true
end
function debuffModifierClass:RemoveOnDeath()
    return true
end
function debuffModifierClass:GetEffectName()
    return "particles/items2_fx/arcane_cascade.vpcf"
end
function debuffModifierClass:GetEffectAttachType()
    return PATTACH_CUSTOMORIGIN_FOLLOW
end
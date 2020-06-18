require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')
require('heroes/obsidian_destroyer/epoch_constants')

item_rpc_epoch_immortal_weapon_2 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_epoch_immortal_weapon_2
local itemClassName = 'item_rpc_epoch_immortal_weapon_2'

modifier_epoch_immortal_weapon_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_epoch_immortal_weapon_2
local modifierName = 'modifier_epoch_immortal_weapon_2'
LinkLuaModifier(modifierName, "heroes/obsidian_destroyer/weapon_scripts/epoch_immortal_weapon_2", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_immortal_weapon_2_death_prevent_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_immortal_weapon_2_death_prevent_effect", "heroes/obsidian_destroyer/weapon_scripts/epoch_immortal_weapon_2", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "epoch"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Epoch Immortal Weapon 2'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_2"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon2", "#6BEF9A", 1, "#property_"..self:RequiredHero().."_immortal_weapon2_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "strength", 2)
end

-- WEAPON MODIFIER
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_PREVENT_DEATH
    })
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

function modifierClass:RoshpitPreventDeathCheck()
    if self:GetAbility():GetCooldownTimeRemaining() > 0 then
        return false
    else
        return self
    end
end

function modifierClass:OnDeathPrevented()
    local caster = self:GetParent()
    local item = self:GetAbility()
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_epoch_immortal_weapon_2_death_prevent_effect", {duration = EPOCH_IMMORTAL_WEAPON_2_RESPAWN_DELAY})
    item:StartRoshpitCooldown(EPOCH_IMMORTAL_WEAPON_2_CD)
end

-- DEATH PREVENT MODIFIER

function modifier_epoch_immortal_weapon_2_death_prevent_effect:IsHidden()
    return false
end

function modifier_epoch_immortal_weapon_2_death_prevent_effect:IsBuff()
    return true
end

function modifier_epoch_immortal_weapon_2_death_prevent_effect:OnCreated()
    if not IsServer() then
        return false
    end
    local caster = self:GetParent()
    caster:AddNoDraw()
    local r_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
    r_ability.cast_position_override = caster:GetAbsOrigin()
    r_ability:OnSpellStart()
    self:StartIntervalThink(0.1)
end

function modifier_epoch_immortal_weapon_2_death_prevent_effect:OnRemoved()
    if not IsServer() then
        return false
    end
    local caster = self:GetParent()
    caster:RemoveNoDraw()
    local r_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
    r_ability.cast_position_override = caster:GetAbsOrigin()
    r_ability:OnChannelFinish(false)
end

function modifier_epoch_immortal_weapon_2_death_prevent_effect:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_STUNNED] = true
    }
    return state
end

function modifier_epoch_immortal_weapon_2_death_prevent_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT
    }
    return funcs
end

function modifier_epoch_immortal_weapon_2_death_prevent_effect:OnIntervalThink()
    local caster = self:GetParent()
    local ticks = EPOCH_IMMORTAL_WEAPON_2_RESPAWN_DELAY/0.1
    local healthRestore = caster:GetMaxHealth()/ticks
    local manaRestore = caster:GetMaxMana()/ticks
    caster:SetHealth(caster:GetHealth() + healthRestore)
    caster:SetMana(caster:GetMana() + manaRestore)
end

function modifier_epoch_immortal_weapon_2_death_prevent_effect:GetModifierCooldownReduction_Constant()
    return 300
end

function modifier_epoch_immortal_weapon_2_death_prevent_effect:GetTexture()
    return "epoch/epoch_eternity_flood"
end
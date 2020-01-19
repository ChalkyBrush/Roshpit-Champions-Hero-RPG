require('/global_constants')
require('npc_abilities/base_modifier')
base_ability = class({})

function base_ability:GetBaseManaCost(level)
    error('Define GetBaseManaCost(level) and not GetManaCost(level)')
end

function base_ability:GetAbilitySlot()
    error('Define GetAbilitySlot()!')
end

function base_ability:GetBaseCooldown(level)
    error('Define GetBaseCooldown(level) and not GetCooldown(level)')
end

function base_ability:GetManaCost(level)
    local hero = self:GetCaster()
    local index = self:GetAbilitySlot()
    local flat = 0
    local pct = 0
    if index == DOTA_Q_SLOT then
        flat = hero:GetModifierStackCount("modifier_q_flat_manacost_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_q_pct_manacost_modifier", hero)
    elseif index == DOTA_W_SLOT then
        flat = hero:GetModifierStackCount("modifier_w_flat_manacost_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_w_pct_manacost_modifier", hero)
    elseif index == DOTA_E_SLOT then
        flat = hero:GetModifierStackCount("modifier_e_flat_manacost_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_e_pct_manacost_modifier", hero)
    elseif index == DOTA_R_SLOT then
        flat = hero:GetModifierStackCount("modifier_r_flat_manacost_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_r_pct_manacost_modifier", hero)
    end
    local baseManaCost = self:GetBaseManaCost(level) or 0
    local manaCost = (baseManaCost + flat) * (1 + pct / 10000)
    return math.max(manaCost, 0)
end

function base_ability:GetCooldown(level)
    local hero = self:GetCaster()
    local index = self:GetAbilitySlot()
    local flat = 0
    local pct = 0
    if index == DOTA_Q_SLOT then
        flat = hero:GetModifierStackCount("modifier_q_flat_cooldown_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_q_pct_cooldown_modifier", hero)
    elseif index == DOTA_W_SLOT then
        flat = hero:GetModifierStackCount("modifier_w_flat_cooldown_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_w_pct_cooldown_modifier", hero)
    elseif index == DOTA_E_SLOT then
        flat = hero:GetModifierStackCount("modifier_e_flat_cooldown_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_e_pct_cooldown_modifier", hero)
    elseif index == DOTA_R_SLOT then
        flat = hero:GetModifierStackCount("modifier_r_flat_cooldown_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_r_pct_cooldown_modifier", hero)
    end

    local cooldown = (self:GetBaseCooldown(level) + flat) * (1 + pct / 10000)
    return math.max(cooldown, 0)
end
require('/global_constants')
require('npc_abilities/base_modifier')
base_ability = class({})

function base_ability:GetManaCostBase(level)
    error('Define GetManaCostBase(level) and not GetManaCost(level)')
end

function base_ability:GetAbilitySlot()
    error('Define GetAbilitySlot()!')
end

function base_ability:GetCooldownBase(level)
    error('Define GetCooldownBase(level) and not GetCooldown(level)')
end

function base_ability:GetChannelTimeBase()
    if self:GetAbilitySlot() == DOTA_R_SLOT then
        error('Define GetChannelTimeBase() and not GetChannelTime()')
    end
end

function base_ability:GetBehaviorBase()
    if self:GetAbilitySlot() == DOTA_R_SLOT then
        error('Define GetBehaviorBase() and not GetBehavior()')
    end
end
function base_ability:OnSpellStartBase()
    if self:GetAbilitySlot() == DOTA_R_SLOT then
        error('Define OnSpellStartBase() and not OnSpellStart()')
    end
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
    local baseManaCost = self:GetManaCostBase(level) or 0
    local manaCost = (baseManaCost + flat / 100) * (pct / 10000)
    return math.max(manaCost, 0)
end

function base_ability:GetCooldown(level)
    local hero = self:GetCaster()
    local index = self:GetAbilitySlot()
    local flat = 0
    local pct = 1
    local min = 0
    local max = 1000
    if index == DOTA_Q_SLOT then
        flat = hero:GetModifierStackCount("modifier_q_flat_cooldown_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_q_pct_cooldown_modifier", hero)
        min = hero:GetModifierStackCount("modifier_q_min_cooldown_modifier", hero)
        max = hero:GetModifierStackCount("modifier_q_max_cooldown_modifier", hero)
    elseif index == DOTA_W_SLOT then
        flat = hero:GetModifierStackCount("modifier_w_flat_cooldown_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_w_pct_cooldown_modifier", hero)
        min = hero:GetModifierStackCount("modifier_w_min_cooldown_modifier", hero)
        max = hero:GetModifierStackCount("modifier_w_max_cooldown_modifier", hero)
    elseif index == DOTA_E_SLOT then
        flat = hero:GetModifierStackCount("modifier_e_flat_cooldown_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_e_pct_cooldown_modifier", hero)
        min = hero:GetModifierStackCount("modifier_e_min_cooldown_modifier", hero)
        max = hero:GetModifierStackCount("modifier_e_max_cooldown_modifier", hero)
    elseif index == DOTA_R_SLOT then
        flat = hero:GetModifierStackCount("modifier_r_flat_cooldown_modifier", hero)
        pct = hero:GetModifierStackCount("modifier_r_pct_cooldown_modifier", hero)
        min = hero:GetModifierStackCount("modifier_r_min_cooldown_modifier", hero)
        max = hero:GetModifierStackCount("modifier_r_max_cooldown_modifier", hero)
    end

    local cooldown = math.min(math.max((self:GetCooldownBase(level) + flat / 100) * (pct / 10000), min / 100), max / 100)
    return cooldown
end

function base_ability:GetChannelTime()
    if self:GetAbilitySlot() == DOTA_R_SLOT then
        local hero = self:GetCaster()
        local flat = hero:GetModifierStackCount("modifier_r_flat_channeltime_modifier", hero)
        local pct = hero:GetModifierStackCount("modifier_r_pct_channeltime_modifier", hero)   
        local channeltime = (self:GetChannelTimeBase() + flat / 100) * (pct / 10000)
        return math.max(channeltime, 0)
    end
end

function base_ability:GetBehavior()
    if self:GetAbilitySlot() == DOTA_R_SLOT and self:GetChannelTime() == 0 then
        return self:GetBehaviorBase() - DOTA_ABILITY_BEHAVIOR_CHANNELLED
    else
        return self:GetBehaviorBase()
    end
end

function base_ability:OnSpellStart()
    self:OnSpellStartBase()
    if self:GetAbilitySlot() == DOTA_R_SLOT and self:GetChannelTime() == 0 then
        self:OnChannelFinish(false)
    end
end
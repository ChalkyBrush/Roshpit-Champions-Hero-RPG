require('heroes/legion_commander/mountain_protector_constants')
require('heroes/base_ability')
mountain_protector_mountain_guardian = class(base_ability)

function mountain_protector_mountain_guardian:GetBaseManaCost(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return MOUNTAIN_PROTECTOR_W_MANA_COST[level + 1]
end

function mountain_protector_mountain_guardian:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_TOGGLE
end

function mountain_protector_mountain_guardian:GetAbilitySlot()
    return DOTA_W_SLOT
end

function mountain_protector_mountain_guardian:GetCastPoint()
    return 0
end

function mountain_protector_mountain_guardian:GetBaseCooldown(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return MOUNTAIN_PROTECTOR_W_COOLDOWN[level + 1]
end

function mountain_protector_mountain_guardian:IsToggle()
    return true
end

function mountain_protector_mountain_guardian:OnToggle()
    if IsServer() then
        local ability = self
        local caster = self:GetCaster()
        if self:GetToggleState() then
            Filters:CastSkillArguments(BASE_ABILITY_W, caster)
            CustomAbilities:QuickAttachParticle("particles/roshpit/mystic_assassin/mountain_a_b_glow.vpcf", caster, 1)
            caster:AddNewModifier(caster, ability, "modifier_mountain_protector_mountain_guardian", {})
            local w_1_level = caster:GetRuneValue("w", 1)
            if w_1_level > 0 then
                caster:AddNewModifier(caster, ability, "modifier_mountain_protector_w_1", {})
                caster:SetModifierStackCount("modifier_mountain_protector_w_1", caster, w_1_level)
            end
            local w_2_level = caster:GetRuneValue("w", 2)
            if w_2_level > 0 then
                caster:AddNewModifier(caster, ability, "modifier_mountain_protector_w_2", {})
                caster:SetModifierStackCount("modifier_mountain_protector_w_2", caster, w_2_level)
            end
            local w_3_level = caster:GetRuneValue("w", 3)
            if w_3_level > 0 then
                caster:AddNewModifier(caster, ability, "modifier_mountain_protector_w_3_aura", {})
            end
            local w_4_level = caster:GetRuneValue("w", 4)
            if w_4_level > 0 then
                caster:AddNewModifier(caster, ability, "modifier_mountain_protector_w_4_aura", {})
            end
            caster:AddNewModifier(caster, ability, "modifier_energy_channel_animating", {duration = 6})
            StartAnimation(caster, {duration = 7, activity = ACT_DOTA_TELEPORT, rate = 0.8, translate = "fallen_legion"})
            EmitSoundOn("MysticAssasin.ShieldYell"..RandomInt(1, 2), caster)
            Timers:CreateTimer(0.1, function()
                StartSoundEvent("MysticAssasin.EnergyChannelLoop", caster)
            end)
        else
            EndAnimation(caster)
            caster:RemoveModifierByName("modifier_mountain_protector_mountain_guardian")
            caster:RemoveModifierByName("modifier_mountain_protector_w_1")
            caster:RemoveModifierByName("modifier_mountain_protector_w_2")
            caster:RemoveModifierByName("modifier_mountain_protector_w_3_aura")
            caster:RemoveModifierByName("modifier_mountain_protector_w_4_aura")
            caster:RemoveModifierByName("modifier_energy_channel_animating")
            Timers:CreateTimer(0.1, function()
                StopSoundEvent("MysticAssasin.EnergyChannelLoop", caster)
            end)
        end
    end
end

modifier_mountain_protector_mountain_guardian = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_mountain_guardian", "heroes/legion_commander/mountain_protector_mountain_guardian", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_mountain_guardian:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_ARMOR_BONUS,
            MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
        })
        self:StartIntervalThink(1)
    end
end
function modifier_mountain_protector_mountain_guardian:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end
function modifier_mountain_protector_mountain_guardian:GetRoshpitArmorBonus()
    return MOUNTAIN_PROTECTOR_W_ARMOR_AND_MAGIC_ARMOR[self:GetAbility():GetLevel()]
end
function modifier_mountain_protector_mountain_guardian:GetRoshpitMagicArmorBonus()
    return MOUNTAIN_PROTECTOR_W_ARMOR_AND_MAGIC_ARMOR[self:GetAbility():GetLevel()]
end
function modifier_mountain_protector_mountain_guardian:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local mana_drain = ability:GetManaCost(-1)

        if caster:GetMana() < mana_drain or caster:IsSilenced() then
            ability:ToggleAbility()
            return false
        end
        ability:PayManaCost()

        Filters:CastSkillArguments(BASE_ABILITY_W, caster)
        if not caster:HasModifier("modifier_energy_channel_animating") then
            caster:AddNewModifier(caster, ability, "modifier_energy_channel_animating", {duration = 6})
            StartAnimation(caster, {duration = 7, activity = ACT_DOTA_TELEPORT, rate = 0.8, translate = "fallen_legion"})
        end
    end
end

modifier_energy_channel_animating = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_energy_channel_animating", "heroes/legion_commander/mountain_protector_mountain_guardian", LUA_MODIFIER_MOTION_NONE)

function modifier_energy_channel_animating:IsHidden()
    return true
end

modifier_mountain_protector_w_1 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_w_1", "heroes/legion_commander/mountain_protector_mountain_guardian", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_w_1:OnCreated()
    self:StartIntervalThink(1)
end
function modifier_mountain_protector_w_1:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        hero:SetModifierStackCount("modifier_mountain_protector_w_1", hero, hero:GetRuneValue("w", 1))
    end
end
function modifier_mountain_protector_w_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }

    return funcs
end
function modifier_mountain_protector_w_1:GetModifierHealthRegenPercentage()
    return self:GetStackCount() * MOUNTAIN_PROTECTOR_W1_HP_REGEN_PERCENT
end
function modifier_mountain_protector_w_1:GetTexture()
    return "mountain_protector/mountain_protector_rune_w_1"
end


modifier_mountain_protector_w_2 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_w_2", "heroes/legion_commander/mountain_protector_mountain_guardian", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_w_2:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS
        })
        self:StartIntervalThink(1)
    end
end
function modifier_mountain_protector_w_2:GetRoshpitSpellPierceBonus()
    return self:GetStackCount() * MOUNTAIN_PROTECTOR_W2_SPELL_PIERCE
end
function modifier_mountain_protector_w_2:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        hero:SetModifierStackCount("modifier_mountain_protector_w_2", hero, hero:GetRuneValue("w", 2))
    end
end
function modifier_mountain_protector_w_2:GetTexture()
    return "mountain_protector/mountain_protector_w_2"
end

modifier_mountain_protector_w_3_aura = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_w_3_aura", "heroes/legion_commander/mountain_protector_mountain_guardian", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_w_3_aura:IsBuff()
    return true
end
function modifier_mountain_protector_w_3_aura:IsAura()
    return true
end
function modifier_mountain_protector_w_3_aura:IsAuraActiveOnDeath()
    return false
end
function modifier_mountain_protector_w_3_aura:GetAuraRadius()
    return MOUNTAIN_PROTECTOR_W3_RADIUS
end
function modifier_mountain_protector_w_3_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_mountain_protector_w_3_aura:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP)
end
function modifier_mountain_protector_w_3_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_mountain_protector_w_3_aura:RemoveOnDeath()
    return true
end
function modifier_mountain_protector_w_3_aura:GetModifierAura()
    return "modifier_mountain_protector_w_3_zap"
end
function modifier_mountain_protector_w_3_aura:GetTexture()
    return "mountain_protector/mountain_protector_w_3"
end

modifier_mountain_protector_w_3_zap = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_w_3_zap", "heroes/legion_commander/mountain_protector_mountain_guardian", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_w_3_zap:OnCreated()
    if IsServer() then
        self:StartIntervalThink(MOUNTAIN_PROTECTOR_W3_TICKRATE)
    end
end
function modifier_mountain_protector_w_3_zap:OnIntervalThink()
    if IsServer() then
        local target = self:GetParent()
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local w_3_level = caster:GetRuneValue("w", 3)
        local w_3_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * MOUNTAIN_PROTECTOR_W3_PCT/100 * w_3_level + caster:GetMaxHealth() * MOUNTAIN_PROTECTOR_W3_HP_PART_PCT/100 * w_3_level
        Filters:TakeArgumentsAndApplyDamage(target, caster, w_3_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_EARTH)
        local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 80), true)
        ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin() + Vector(0, 0, 80), true)
        Timers:CreateTimer(2.0, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end
end
function modifier_mountain_protector_w_3_zap:GetTexture()
    return "mountain_protector/mountain_protector_w_3"
end

modifier_mountain_protector_w_4_aura = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_w_4_aura", "heroes/legion_commander/mountain_protector_mountain_guardian", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_w_4_aura:IsBuff()
    return true
end
function modifier_mountain_protector_w_4_aura:IsAura()
    return true
end
function modifier_mountain_protector_w_4_aura:IsAuraActiveOnDeath()
    return false
end
function modifier_mountain_protector_w_4_aura:GetAuraRadius()
    return MOUNTAIN_PROTECTOR_W4_RADIUS
end
function modifier_mountain_protector_w_4_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_mountain_protector_w_4_aura:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP)
end
function modifier_mountain_protector_w_4_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_mountain_protector_w_4_aura:RemoveOnDeath()
    return true
end
function modifier_mountain_protector_w_4_aura:GetModifierAura()
    return "modifier_mountain_protector_w_4_aura_buff"
end
function modifier_mountain_protector_w_4_aura:GetTexture()
    return "mountain_protector/mountain_protector_w_4"
end

modifier_mountain_protector_w_4_aura_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_w_4_aura_buff", "heroes/legion_commander/mountain_protector_mountain_guardian", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_w_4_aura_buff:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_ARMOR_BONUS,
            MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
        })
        local hero = self:GetCaster()
        local w_4_level = hero:GetRuneValue("w", 4)
        self:SetStackCount(w_4_level)
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end
function modifier_mountain_protector_w_4_aura_buff:OnRefreshed()
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end
function modifier_mountain_protector_w_4_aura_buff:GetRoshpitArmorBonus()
    return self:GetStackCount() * MOUNTAIN_PROTECTOR_W4
end
function modifier_mountain_protector_w_4_aura_buff:GetRoshpitMagicArmorBonus()
    return self:GetStackCount() * MOUNTAIN_PROTECTOR_W4 * 0 --Doesnt give magic armor, maybe some day?
end
function modifier_mountain_protector_w_4_aura_buff:GetTexture()
    return "mountain_protector/mountain_protector_w_4"
end
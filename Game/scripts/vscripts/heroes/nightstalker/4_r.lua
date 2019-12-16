require('/util')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/common')
require('/npc_abilities/base_ability')

local prefix = '4_r_'
local modifiers = {
    lifting = 'modifier_chernobog_4_r_lifting',
    shadows_aura = 'modifier_chernobog_4_r_shadows_aura',
    shadows_enemy_effect = 'modifier_chernobog_4_r_shadows_enemy_effect',
    procession_aura = 'modifier_chernobog_4_r_procession_aura',
    procession_enemy_effect = 'modifier_chernobog_4_r_procession_enemy_effect',
    attack_r3 = 'modifier_chernobog_4_r_attack_r3',
    passive = 'modifier_chernobog_4_r_passive',
}
for modifierPath, modifier in pairs(modifiers) do
    LinkLuaModifier(modifier, "heroes/nightstalker/modifiers/"..prefix..modifierPath, LUA_MODIFIER_MOTION_NONE)
end

chernobog_4_r = class(npc_base_ability, nil, npc_base_ability)
local class = chernobog_4_r

function class:GetIntrinsicModifierName()
    return modifiers.passive
end
function class:GetChannelTime()
    local caster = self:GetCaster()
    return Util.Ability:WithCasterRunesOnClient(caster, function()
        return math.max(CHERNOBOG_R_CHANNEL_TIME - CHERNOBOG_R4_CHANNEL_TIME_REDUCTION * caster.r4_level, 0)
    end)
end
function class:GetCooldown(level)
    local caster = self:GetCaster()
    return Util.Ability:WithCasterRunesOnClient(caster, function()
        local cooldown = self.BaseClass.GetCooldown(self, level)
        cooldown = cooldown - math.min(caster.r4_level*CHERNOBOG_R4_COOLDOWN_REDUCTION, CHERNOBOG_R4_MAX_COOLDOWN_REDUCTION)
        if self.cooldown ~= cooldown then
            self.cooldown = cooldown
            self.cooldown_rounded = tonumber(string.format("%.1f", cooldown))
        end
        return math.max(self.cooldown_rounded, 2)
    end)
end
function class:OnSpellStart()
    local caster = self:GetCaster()
    local casterOrigin = caster:GetAbsOrigin()
    if IsServer() then
        onCastR(caster)
        StartSoundEvent("Chernobog.NightsProcessionChannelStart", caster)
        StartSoundEvent('Chernobog.NightsProcessionChannelling', caster)

        StartAnimation(caster, {duration = 3, activity = ACT_DOTA_TELEPORT, rate = 0.8})
    end
end
function class:OnChannelFinish(interrupted)
    if IsServer() then
        if interrupted then
            self:OnChannelInterrupted()
        else
            self:OnChannelSucceeded()
        end
        local caster = self:GetCaster()
        StopSoundEvent("Chernobog.NightsProcessionChannelStart", caster)
        StopSoundEvent('Chernobog.NightsProcessionChannelling', caster)
    end
end
function class:OnChannelSucceeded()
    self.lifting_up_per_tick = 0
    self.lifting_down_per_tick = 0
    self.radius = self:GetSpecialValueFor('radius') + CHERNOBOG_R4_RADIUS * self:GetCaster().r4_level
    self.startPoint = self:GetCaster():GetAbsOrigin()
    self.endPoint = self:GetCursorPosition()

    local caster = self:GetCaster()

    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", caster, 4)
    EmitSoundOn("Chernobog.NightsProcessionChannelEnd", caster)
    self:Lifting()
    Filters:CastSkillArguments(4, caster)
end
function class:OnChannelInterrupted()
end
function class:Lifting()
    local caster = self:GetCaster()
    local liftingIntervalThink = 0.03
    local currentLiftingInterval = 0

    local intervalIncrease = (1 + CHERNOBOG_R4_CHANNEL_TIME_REDUCTION * self:GetCaster().r4_level)

    local liftingDownStartInterval = 60
    local liftingEndInterval = 120
    Timers:CreateTimer(function()
        if currentLiftingInterval == 0 then
            self:LiftingStart(caster)
            caster:AddNewModifier(caster, self,  modifiers.lifting, {})
        elseif currentLiftingInterval < liftingDownStartInterval then
            self:LiftingUp(caster, currentLiftingInterval, intervalIncrease)
        elseif currentLiftingInterval >= liftingDownStartInterval and currentLiftingInterval < liftingDownStartInterval + intervalIncrease then
            self:LiftingDownStart()
        elseif currentLiftingInterval < liftingEndInterval then
            self:LiftingDown(caster, currentLiftingInterval - liftingDownStartInterval, intervalIncrease)
        elseif currentLiftingInterval >= liftingEndInterval then
            self:DoMainThings()
            self:LiftingEnd()
            caster:RemoveModifierByName(modifiers.lifting)
            return
        end
        currentLiftingInterval = currentLiftingInterval + intervalIncrease
        return liftingIntervalThink
    end)
end
function class:LiftingStart()
end
function class:LiftingUp(caster, currentLiftingInterval, intervalIncrease)
    caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, currentLiftingInterval * intervalIncrease))
    self.lifting_up_per_tick = self.lifting_up_per_tick +  currentLiftingInterval * intervalIncrease
end
function class:LiftingDownStart()
    self.endPoint = WallPhysics:WallSearch(self.startPoint, self.endPoint, self:GetCaster())
    self.endPoint.z = self:GetCaster():GetOrigin().z
    StartAnimation(self:GetCaster(), {duration = 3.5, activity = ACT_DOTA_VERSUS, rate = 1})
end
function class:LiftingDown(caster, currentLiftingInterval, intervalIncrease)
    caster:SetAbsOrigin(self.endPoint - Vector(0, 0, self.lifting_down_per_tick))
    self.lifting_down_per_tick = self.lifting_down_per_tick +  currentLiftingInterval * (intervalIncrease - 0.02)
end
function class:CreateProcession()
    local caster = self:GetCaster()
    local radius = self.radius
    local duration = self:GetDuration('buff', CHERNOBOG_R_DURATION);

    Util.Ability:MakeThinker(caster, self, modifiers.procession_aura, self.endPoint, duration)

    local pfx = ParticleManager:CreateParticle("particles/roshpit/chernobog/nights_procession_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(self.endPoint, caster))
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
    Timers:CreateTimer(duration, function()
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end
function class:DoMainThings()
    local caster = self:GetCaster()
    self:CreateProcession()
    local duration = self:GetDuration('buff', CHERNOBOG_R_DURATION);
    if caster.r2_level > 0 then
        local hasArcana = caster:HasAbility('chernobog_3_e_arcana2') or caster:HasAbility('chernobog_3_e_arcana2_swapped')
        local canCreateAura = true
        if hasArcana then
            if caster.e4_level > 0 then
                init_shadows_values_for_ability({
                    ability = self,
                    radius = CHERNOBOG_ARCANA2_E4_RADIUS,
                    damagePercent = caster.e4_level * CHERNOBOG_ARCANA2_E4_DMG_PCT * (1 + caster.r2_level * CHERNOBOG_R2_SHADOWS_AMP),
                    thinkInterval = CHERNOBOG_ARCANA2_E4_INTERVAL
                })
            else
                canCreateAura = false
            end
        else
            if caster.e2_level > 0 then
                init_shadows_values_for_ability({
                    ability = self,
                    radius = CHERNOBOG_E2_RADIUS,
                    damagePercent = caster.e2_level * CHERNOBOG_E2_DMG_PCT * (1 + caster.r2_level * CHERNOBOG_R2_SHADOWS_AMP),
                    thinkInterval = CHERNOBOG_E2_INTERVAL / (1 + caster.e4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE),
                })
            else
                canCreateAura = false
            end
        end
        if canCreateAura then
            Util.Ability:MakeThinker(caster, self, modifiers.shadows_aura, self.endPoint, getShadowsDuration(caster, duration))
        end
    end
    if caster.r3_level > 0 then
        local duration = self:GetDuration('buff', CHERNOBOG_R_DURATION + CHERNOBOG_R3_DUR_BASE + caster.r3_level * CHERNOBOG_R3_DUR)
        caster:AddNewModifier(caster, self,  modifiers.attack_r3, { duration = duration })
    end
    EndAnimation(caster)
    Timers:CreateTimer(0.03, function()
     StartAnimation(caster, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 0.8})
    end)
end
function class:LiftingEnd()
    local caster = self:GetCaster()
    FindClearSpaceForUnit(caster, self.endPoint, false)

    EmitSoundOn("Chernobog.NightsProcession.Land", caster)

    ScreenShake(caster:GetAbsOrigin(), 260, 0.3, 0.3, 9000, 0, true)

    local pfx = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_dust_ti4.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))

    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end
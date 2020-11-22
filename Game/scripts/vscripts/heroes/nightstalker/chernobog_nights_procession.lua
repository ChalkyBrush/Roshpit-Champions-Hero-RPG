
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/common')
require('heroes/base_ability')
require("heroes/util/channeling")

local prefix = '4_r_'
local modifiers = {
    lifting = 'modifier_chernobog_4_r_lifting',
    shadows_aura = 'modifier_chernobog_4_r_shadows_aura',
    shadows_enemy_effect = 'modifier_chernobog_4_r_shadows_enemy_effect',
    procession_aura = 'modifier_chernobog_4_r_procession_aura',
    procession_enemy_effect = 'modifier_chernobog_4_r_procession_enemy_effect',
    attack_r3 = 'modifier_chernobog_4_r_attack_r3',
}
for modifierPath, modifier in pairs(modifiers) do
    LinkLuaModifier(modifier, "heroes/nightstalker/modifiers/"..prefix..modifierPath, LUA_MODIFIER_MOTION_NONE)
end

chernobog_nights_procession = class(base_ability)

function chernobog_nights_procession:GetIntrinsicModifierName()
    return "modifier_chernobog_nights_procession"
end
function chernobog_nights_procession:GetAbilitySlot()
    return DOTA_R_SLOT
end
function chernobog_nights_procession:GetManaCostBase(level)
    return 0
end
function chernobog_nights_procession:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
end
function chernobog_nights_procession:GetChannelTimeBase()
    return CHERNOBOG_R_CHANNEL_TIME
end
function chernobog_nights_procession:GetCooldownBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return CHERNOBOG_R_COOLDOWN[level + 1]
end
function chernobog_nights_procession:OnSpellStartBase()
    local caster = self:GetCaster()
    beginChannel{ caster = caster }
    local casterOrigin = caster:GetAbsOrigin()
    if IsServer() then
        onCastR(caster)
        StartSoundEvent("Chernobog.NightsProcessionChannelStart", caster)
        StartSoundEvent('Chernobog.NightsProcessionChannelling', caster)

        StartAnimation(caster, {duration = 3, activity = ACT_DOTA_TELEPORT, rate = 0.8})
    end
end
function chernobog_nights_procession:OnChannelFinish(interrupted)
    endChannel{ caster = self:GetCaster() }
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
function chernobog_nights_procession:OnChannelSucceeded()
    endChannel{ caster = self:GetCaster() }
    self.lifting_up_per_tick = 0
    self.lifting_down_per_tick = 0
    self.radius = CHERNOBOG_R_RADIUS + CHERNOBOG_R4_RADIUS * self:GetCaster().r4_level
    self.startPoint = self:GetCaster():GetAbsOrigin()
    self.endPoint = self:GetCursorPosition()

    local caster = self:GetCaster()

    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", caster, 4)
    EmitSoundOn("Chernobog.NightsProcessionChannelEnd", caster)
    self:Lifting()
    Filters:CastSkillArguments(BASE_ABILITY_R, caster)
end
function chernobog_nights_procession:OnChannelInterrupted()
    endChannel{ caster = self:GetCaster() }
end
function chernobog_nights_procession:Lifting()
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
function chernobog_nights_procession:LiftingStart()
end
function chernobog_nights_procession:LiftingUp(caster, currentLiftingInterval, intervalIncrease)
    caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, currentLiftingInterval * intervalIncrease))
    self.lifting_up_per_tick = self.lifting_up_per_tick +  currentLiftingInterval * intervalIncrease
end
function chernobog_nights_procession:LiftingDownStart()
    self.endPoint = WallPhysics:WallSearch(self.startPoint, self.endPoint, self:GetCaster())
    self.endPoint.z = self:GetCaster():GetOrigin().z
    StartAnimation(self:GetCaster(), {duration = 3.5, activity = ACT_DOTA_VERSUS, rate = 1})
end
function chernobog_nights_procession:LiftingDown(caster, currentLiftingInterval, intervalIncrease)
    caster:SetAbsOrigin(self.endPoint - Vector(0, 0, self.lifting_down_per_tick))
    self.lifting_down_per_tick = self.lifting_down_per_tick +  currentLiftingInterval * (intervalIncrease - 0.02)
end
function chernobog_nights_procession:CreateProcession()
    local caster = self:GetCaster()
    local radius = self.radius
    local duration = Filters:GetAdjustedBuffDuration(self:GetCaster(), CHERNOBOG_R_DURATION)

    Util.Ability:MakeThinker(caster, self, modifiers.procession_aura, self.endPoint, duration)

    local pfx = ParticleManager:CreateParticle("particles/roshpit/chernobog/nights_procession_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(self.endPoint, caster))
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
    Timers:CreateTimer(duration, function()
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end
function chernobog_nights_procession:DoMainThings()
    local hero = self:GetCaster()
    self:CreateProcession()
    local duration = 0
    local r_2_level = hero:GetRuneValue("r", 2)
    local r_3_level = hero:GetRuneValue("r", 3)
    if r_2_level > 0 then
        if hero:HasAbility('chernobog_3_e_arcana2') or hero:HasAbility('chernobog_3_e_arcana2_swapped') then
            local e_4_level = hero:GetRuneValue("e", 4)
            duration = Filters:GetAdjustedBuffDuration(hero, CHERNOBOG_R_DURATION + CHERNOBOG_ARCANA2_E4_BONUS_TIME * e_4_level)
        else
            duration = Filters:GetAdjustedBuffDuration(hero, CHERNOBOG_R_DURATION)
        end
        local dummy = CreateUnitByName("dummy_unit_vulnerable", self.endPoint, false, hero, hero, hero:GetTeam())
        dummy:AddAbility("dummy_unit"):SetLevel(1)
        dummy:AddNewModifier(hero, ability, "modifier_chernobog_r_2", { duration = duration})
        Timers:CreateTimer(duration, function()
            UTIL_Remove(dummy)
        end)
    end
    if r_3_level > 0 then
        local duration = CHERNOBOG_R_DURATION + CHERNOBOG_R3_DUR_BASE + r_3_level * CHERNOBOG_R3_DUR
        duration = Filters:GetAdjustedBuffDuration(self:GetCaster(), duration)
        hero:AddNewModifier(hero, self,  modifiers.attack_r3, { duration = duration })
    end
    EndAnimation(hero)
    Timers:CreateTimer(0.03, function()
        StartAnimation(hero, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 0.8})
    end)
end
function chernobog_nights_procession:LiftingEnd()
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



modifier_chernobog_nights_procession = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_nights_procession", "heroes/nightstalker/chernobog_nights_procession", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_nights_procession:OnCreated()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:AddNewModifier(hero, ability, "modifier_chernobog_r_1", {})
        hero:AddNewModifier(hero, ability, "modifier_chernobog_r_4", {})
        self:StartIntervalThink(0.1)
    end
end
function modifier_chernobog_nights_procession:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        local r_1_level = hero:GetRuneValue("r", 1)
        local r_4_level = hero:GetRuneValue("r", 4)
        hero:SetModifierStackCount("modifier_chernobog_r_1", hero, r_1_level)
        hero:SetModifierStackCount("modifier_chernobog_r_4", hero, r_4_level)
    end
end
function modifier_chernobog_nights_procession:IsHidden()
    return true
end
function modifier_chernobog_nights_procession:IsBuff()
    return true
end
function modifier_chernobog_nights_procession:OnRemoved()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:RemoveModifierByName("modifier_chernobog_r_1")
        hero:RemoveModifierByName("modifier_chernobog_r_4")
    end
end

modifier_chernobog_r_1 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_1", "heroes/nightstalker/chernobog_nights_procession", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_r_1:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        RPC_ELEMENT_DEMON,
    })
end
function modifier_chernobog_r_1:IsHidden()
    return true
end
function modifier_chernobog_r_1:RemoveOnDeath()
    return false
end
function modifier_chernobog_r_1:GetRoshpitElementalDmgBonus()
	return CHERNOBOG_R1_DEMON_AMP * self:GetStackCount()
end

modifier_chernobog_r_2 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_2", "heroes/nightstalker/chernobog_nights_procession", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_r_2:OnCreated()
    if IsServer() then
        local hero = self:GetCaster()
        local e_2_level = hero:GetRuneValue("e", 2)
        local e_4_level = hero:GetRuneValue("e", 4)
        if hero:HasAbility('chernobog_3_e_arcana2') or hero:HasAbility('chernobog_3_e_arcana2_swapped') then
            if e_4_level > 0 then
                self:StartIntervalThink(CHERNOBOG_ARCANA2_E4_INTERVAL)
            end
        else
            if e_2_level > 0 then
                self:StartIntervalThink(CHERNOBOG_E2_INTERVAL / (1 + e_4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE))
            end
        end
    end
end
function modifier_chernobog_r_2:OnIntervalThink()
    if IsServer() then
        local hero = self:GetCaster()
        local dummy = self:GetParent()
        local ability = self:GetAbility()
        local e_2_level = hero:GetRuneValue("e", 2)
        local e_4_level = hero:GetRuneValue("e", 4)
        local r_2_level = hero:GetRuneValue("r", 2)
        local r_4_level = hero:GetRuneValue("r", 4)
        if hero:HasAbility('chernobog_demon_flight') or hero:HasAbility('chernobog_demon_warp') then
            local damage = e_4_level * CHERNOBOG_ARCANA2_E4_DMG_PCT/100 * (1 + r_2_level * CHERNOBOG_R2_SHADOWS_AMP) * OverflowProtectedGetAverageTrueAttackDamage(hero)
            local interval = CHERNOBOG_ARCANA2_E4_INTERVAL
            local radius = CHERNOBOG_R_RADIUS + CHERNOBOG_R4_RADIUS * r_4_level
            if hero:HasModifier('modifier_chernobog_glyph_2_1') then
                radius = radius * CHERNOBOG_T21_RADIUS_AMP
            end
            self:StartIntervalThink(interval)
            local enemies = FindUnitsInRadius(hero:GetTeamNumber(), dummy:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            for _, enemy in ipairs(enemies) do
                local damageDelay =  0.9 * interval
                local animationRate = 1 + 0.3 * (0.5/interval - 1)
                local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", enemy, interval)
                ParticleManager:SetParticleControl(pfx, 1, Vector(animationRate, 0, 0))
                Timers:CreateTimer(damageDelay, function()
                    EmitSoundOn("Chernobog.BC.Hit", enemy)
                    Damage:Apply({
                        attacker = hero,
                        victim = enemy,
                        source = self:GetAbility(),
                        sourceType = BASE_ABILITY_E,
                        damage = damage,
                        damageType = DAMAGE_TYPE_MAGICAL,
                        elements = {
                            RPC_ELEMENT_DEMON,
                            RPC_ELEMENT_SHADOW,
                        },
                    })
                    ParticleManager:DestroyParticle(pfx, false)
                    ParticleManager:ReleaseParticleIndex(pfx)
                end)
            end
        else
            local damage = e_2_level * CHERNOBOG_E2_DMG_PCT * (1 + r_2_level * CHERNOBOG_R2_SHADOWS_AMP) * OverflowProtectedGetAverageTrueAttackDamage(hero)
            local interval = CHERNOBOG_E2_INTERVAL / (1 + e_4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE)
            local radius = CHERNOBOG_R_RADIUS + CHERNOBOG_R4_RADIUS * r_4_level
            if hero:HasModifier('modifier_chernobog_glyph_2_1') then
                radius = radius * CHERNOBOG_T21_RADIUS_AMP
            end
            self:StartIntervalThink(interval)
            local enemies = FindUnitsInRadius(hero:GetTeamNumber(), dummy:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            for _, enemy in ipairs(enemies) do
                local damageDelay =  0.9 * interval
                local animationRate = 1 + 0.3 * (0.5/interval - 1)
                local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", enemy, interval)
                ParticleManager:SetParticleControl(pfx, 1, Vector(animationRate, 0, 0))
                Timers:CreateTimer(damageDelay, function()
                    EmitSoundOn("Chernobog.BC.Hit", enemy)
                    Damage:Apply({
                        attacker = hero,
                        victim = enemy,
                        source = self:GetAbility(),
                        sourceType = BASE_ABILITY_E,
                        damage = damage,
                        damageType = DAMAGE_TYPE_MAGICAL,
                        elements = {
                            RPC_ELEMENT_DEMON,
                            RPC_ELEMENT_SHADOW,
                        },
                    })
                    ParticleManager:DestroyParticle(pfx, false)
                    ParticleManager:ReleaseParticleIndex(pfx)
                end)
            end
        end
    end
end
function modifier_chernobog_r_2:IsHidden()
    return true
end
function modifier_chernobog_r_2:IsBuff()
    return true
end


modifier_chernobog_r_4 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_4", "heroes/nightstalker/chernobog_nights_procession", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_r_4:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_R_FLAT_CHANNELTIME_MOD,
        MODIFIER_ROSHPIT_R_FLAT_CD_MOD
    })
end
function modifier_chernobog_r_4:IsHidden()
    return true
end
function modifier_chernobog_r_4:RemoveOnDeath()
    return false
end
function modifier_chernobog_r_4:GetRoshpitRFlatCdModifier(data)
    return - math.min(CHERNOBOG_R4_COOLDOWN_REDUCTION * self:GetStackCount(), CHERNOBOG_R4_MAX_COOLDOWN_REDUCTION)
end
function modifier_chernobog_r_4:GetRoshpitRFlatChanneltimeModifier(data)
    return - CHERNOBOG_R4_CHANNEL_TIME_REDUCTION * self:GetStackCount()
end
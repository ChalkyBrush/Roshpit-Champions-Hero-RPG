require('heroes/skywrath_mage/sephyr_constants')
require('heroes/base_ability')
sephyr_hurricane = class(base_ability)

-- MODIFIER

modifier_sephyr_hurricane_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_sephyr_hurricane_passive", "heroes/skywrath_mage/arcana/sephyr_hurricane", LUA_MODIFIER_MOTION_NONE)

modifier_sephyr_hurricane_dont_split = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_sephyr_hurricane_dont_split", "heroes/skywrath_mage/arcana/sephyr_hurricane", LUA_MODIFIER_MOTION_NONE)

function sephyr_hurricane:GetManaCostBase(level)
    return 0
end

function sephyr_hurricane:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL
end

function sephyr_hurricane:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function sephyr_hurricane:GetCastPoint()
    return 0
end

function sephyr_hurricane:GetCastRange()
    if IsServer() then
        return self:GetSpecialValueFor("cast_range_base") + self:GetCaster():GetRuneValue("q", 2)*SEPHYR_ARCANA2_Q2_CAST_RANGE
    else
        return self:GetSpecialValueFor("cast_range_base")
    end
end

function sephyr_hurricane:GetCooldownBase(level)
    return math.max(GLOBAL_Q_MIN_CD, self:GetSpecialValueFor("cooldown_base") - self:GetCaster():GetRuneValue("q", 2)*SEPHYR_ARCANA2_Q2_CD_REDUCTION)
end

function sephyr_hurricane:OnSpellStart()
    if IsServer() then
        local ability = self
    	local caster = self:GetCaster()
        local target_position = self:GetCursorPosition()
    	local actual_position = WallPhysics:WallSearch(caster:GetAbsOrigin(), target_position, caster)
        CustomAbilities:QuickParticleAtPoint("particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf", caster:GetAbsOrigin(), 3)
        FindClearSpaceForUnit(caster, actual_position, false)

        CustomAbilities:QuickAttachParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", caster, 3)

        StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_TELEPORT_END, rate = 1.0})
        EmitSoundOn("Sephyr.ArcanaHurricane", caster)
        for i = 1, 12, 1 do
            local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/12)
            self:wind_projectile(fv)
        end
        ProjectileManager:ProjectileDodge(caster)
        if caster:GetRuneValue("q", 1) > 0 then
            caster:AddNewModifier(caster, ability, "modifier_sephyr_hurricane_q1", {duration = SEPHYR_ARCANA2_Q1_DURATION})
        end
        Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
    end
end

function sephyr_hurricane:wind_projectile(fv)
    local caster = self:GetCaster()
    local projectileParticle = "particles/items/hurricane_vest_projectile.vpcf"
    local projectileOrigin = caster:GetAbsOrigin() + fv * 10
    local start_radius = 200
    local end_radius = 200
    local range = self:GetSpecialValueFor("wind_range")
    local speed = self:GetSpecialValueFor("wind_speed")
    local info =
    {
        Ability = self,
        EffectName = projectileParticle,
        vSpawnOrigin = projectileOrigin + Vector(0, 0, 60),
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        StartPosition = "attach_hitloc",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 4.0,
        bDeleteOnHit = false,
        vVelocity = fv * speed,
        bProvidesVision = false,
        ExtraData = {initial = 1, tornado = 0}
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)   
end

function sephyr_hurricane:OnProjectileHit_ExtraData(enemy, loc, data)
    if not IsServer() then
        return false
    end
    if enemy then
        if data.initial == 1 then
            local caster = self:GetCaster()
            enemy:AddNewModifier(caster, self, "modifier_sephyr_hurricane_disarm", {duration = self:GetSpecialValueFor("disarm_duration")})
        end
    end
    return false
end

function sephyr_hurricane:GetIntrinsicModifierName()
    return "modifier_sephyr_hurricane_passive"
end

-- PASSIVE

function modifier_sephyr_hurricane_passive:IsHidden()
    return true
end

function modifier_sephyr_hurricane_passive:RemoveOnDeath()
    return false
end

function modifier_sephyr_hurricane_passive:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })

end

function modifier_sephyr_hurricane_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START
    }

    return funcs
end

function modifier_sephyr_hurricane_passive:OnAttackStart(event)
    local target = event.target
    local hero = self:GetParent()
    local ability = self:GetAbility()
    local caster = hero
    if not self:ParentIsAttacker(event) then
        return false
    end
    local procs = Runes:Procs(hero:GetRuneValue("q", 3), SEPHYR_ARCANA2_Q3_SPLIT_CHANCE, 1)
    local splitCount = 0
    if procs > 0 then
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, hero:Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                if enemy:GetEntityIndex() == target:GetEntityIndex() or enemy.dummy then
                else
                    if splitCount < procs then
                        Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
                        splitCount = splitCount + 1
                    end
                end
            end
        end
        caster:AddNewModifier(caster, ability, "modifier_sephyr_hurricane_dont_split", {duration = 1/caster:GetAttacksPerSecond()})
    end
end

function modifier_sephyr_hurricane_dont_split:IsHidden()
    return true
end

function modifier_sephyr_hurricane_passive:GetRoshpitMasterGreenDMG()
    local hero = self:GetParent()
    return hero:GetRuneValue("q", 4)*hero:GetAgility()*SEPHYR_ARCANA2_Q4_AGI_TO_ATK_PCT
end

-- MODIFIER

modifier_sephyr_hurricane_disarm = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_sephyr_hurricane_disarm", "heroes/skywrath_mage/arcana/sephyr_hurricane", LUA_MODIFIER_MOTION_NONE)

-- disarm_modifier

function modifier_sephyr_hurricane_disarm:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end

function modifier_sephyr_hurricane_disarm:OnCreated()
    EmitSoundOn("RPCItems.Hangman.Disarm", self:GetParent())
end

function modifier_sephyr_hurricane_disarm:GetEffectName()
    return "particles/items2_fx/heavens_halberd.vpcf"
end

function modifier_sephyr_hurricane_disarm:GetEffectAttachType()
    return PATTACH_CUSTOMORIGIN_FOLLOW
end

-- MODIFIERQ1

modifier_sephyr_hurricane_q1 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_sephyr_hurricane_q1", "heroes/skywrath_mage/arcana/sephyr_hurricane", LUA_MODIFIER_MOTION_NONE)

function modifier_sephyr_hurricane_q1:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_AGILITY_BONUS,
        MODIFIER_ROSHPIT_OVERRIDE_ATTACK_EVENT
    })
end

function modifier_sephyr_hurricane_q1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_sephyr_hurricane_q1:GetEffectName()
    return "particles/roshpit/sephyr/arcana2_q1_buff.vpcf"
end

function modifier_sephyr_hurricane_q1:GetEffectAttachType()
    return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_sephyr_hurricane_q1:GetRoshpitAgilityBonus()
    return self:GetParent():GetRuneValue("q", 1)*SEPHYR_ARCANA2_Q1_AGI
end

function modifier_sephyr_hurricane_q1:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    return self:GetParent():GetRuneValue("q", 1)*SEPHYR_ARCANA2_Q1_MS
end

function modifier_sephyr_hurricane_q1:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    return self:GetParent():GetRuneValue("q", 1)*SEPHYR_ARCANA2_Q1_MS
end

function modifier_sephyr_hurricane_q1:BasicAttackOverride(event)
    local attacker = self:GetCaster()
    local ability = self:GetAbility()
    local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
    Filters:TakeArgumentsAndApplyDamage(event.target, attacker, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
    return 1
end

function modifier_sephyr_hurricane_q1:GetTexture()
    return "sephyr/sephyr_rune_q_1_arcana2"
end

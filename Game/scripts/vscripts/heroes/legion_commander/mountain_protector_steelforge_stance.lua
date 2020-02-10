require('heroes/legion_commander/mountain_protector_constants')
require('heroes/base_ability')
mountain_protector_steelforge_stance = class(base_ability)

function mountain_protector_steelforge_stance:GetBaseManaCost(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return MOUNTAIN_PROTECTOR_ARCANA1_W_MANA_COST[level + 1]
end

function mountain_protector_steelforge_stance:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_TOGGLE
end

function mountain_protector_steelforge_stance:GetAbilitySlot()
    return DOTA_W_SLOT
end

function mountain_protector_steelforge_stance:GetCastPoint()
    return 0
end

function mountain_protector_steelforge_stance:GetBaseCooldown(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return MOUNTAIN_PROTECTOR_ARCANA1_W_COOLDOWN[level + 1]
end

function mountain_protector_steelforge_stance:IsToggle()
    return true
end

function mountain_protector_steelforge_stance:GetIntrinsicModifierName()
    return "modifier_mountain_protector_arcana_w_2"
end

function mountain_protector_steelforge_stance:OnToggle()
    if IsServer() then
        local ability = self
        local caster = self:GetCaster()
        if self:GetToggleState() then
            Filters:CastSkillArguments(BASE_ABILITY_W, caster)
        
            caster:AddNewModifier(caster, ability, "modifier_mountain_protector_steelforge_stance", {})
            caster:SetModifierStackCount("modifier_mountain_protector_steelforge_stance", caster, MOUNTAIN_PROTECTOR_ARCANA1_W_HP_REGEN_PCT[self:GetLevel()])
        
            local w_3_level = caster:GetRuneValue("w", 3)
            if w_3_level > 0 then
                caster:AddNewModifier(caster, ability, "modifier_mountain_protector_arcana_w_3", {})
            end
        
            local w_4_level = caster:GetRuneValue("w", 4)
            if w_4_level > 0 then
                caster:AddNewModifier(caster, ability, "modifier_mountain_protector_arcana_w_4", {})
                local bonus_damage = caster:GetStrength() * MOUNTAIN_PROTECTOR_ARCANA1_W4_ATTACK_PER_STR * w_4_level
                caster:SetModifierStackCount("modifier_mountain_protector_arcana_w_4", caster, bonus_damage)
            end
            --W1 after W4, so that it can benefit from Attack Damage bonus
            local w_1_level = caster:GetRuneValue("w", 1)
            if w_1_level > 0 then
                local position = caster:GetAbsOrigin()
                local particleName = "particles/roshpit/mountain_protector/steelforge_explosion.vpcf"
                local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
                ParticleManager:SetParticleControl(particle1, 0, position)
                Timers:CreateTimer(4, function()
                    ParticleManager:DestroyParticle(particle1, false)
                end)
                local damage = w_1_level * OverflowProtectedGetAverageTrueAttackDamage(caster) * MOUNTAIN_PROTECTOR_ARCANA1_W1_DMG_OF_ATTACK_POWER_PCT/100 + w_1_level * caster:GetStrength() * MOUNTAIN_PROTECTOR_ARCANA1_W1_DMG_OF_STR
                EmitSoundOnLocationWithCaster(position, "MysticAssasin.FissureExplosion", caster)
                local explosionAOE = MOUNTAIN_PROTECTOR_ARCANA1_W1_AOE_RADIUS
                local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
                if #enemies > 0 then
                    for _, enemy in pairs(enemies) do
                        Filters:ApplyStun(caster, MOUNTAIN_PROTECTOR_ARCANA1_W1_STUN_DURATION, enemy)
                        Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_EARTH, RPC_ELEMENT_ICE)
                    end
                end
            end
        
            caster:AddNewModifier(caster, ability, "modifier_energy_channel_animating", {duration = 6})
            Timers:CreateTimer(0.05, function()
                EmitSoundOn("MysticAssasin.ShieldYell"..RandomInt(1, 2), caster)
            end)
            EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "MountainProtector.SteelForm", caster)
            Timers:CreateTimer(0.1, function()
                StartSoundEvent("MountainProtector.SteelFormLoop", caster)
        
            end)
            Timers:CreateTimer(1.0, function()
                StopSoundEvent("MountainProtector.SteelFormLoop", caster)
            end)
            CustomAbilities:QuickAttachParticleWithPointFollow("particles/roshpit/mountain_protector/steelforge_start_teleport_ti7_out.vpcf", caster, 3, "attach_origin")
            StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_TELEPORT_END, rate = 1.4})
        else
            StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_TELEPORT_END, rate = 1.4})
            caster:RemoveModifierByName("modifier_mountain_protector_steelforge_stance")
            caster:RemoveModifierByName("modifier_mountain_protector_arcana_w_3")
            caster:RemoveModifierByName("modifier_mountain_protector_arcana_w_4")
        end
    end
end

modifier_mountain_protector_steelforge_stance = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_steelforge_stance", "heroes/legion_commander/mountain_protector_steelforge_stance", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_steelforge_stance:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_ARMOR_BONUS,
            MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS,
            MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
            MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
            MODIFIER_ROSHPIT_PURE_DMG_REDUCTION
        })
        self:StartIntervalThink(1)
    end
end
function modifier_mountain_protector_steelforge_stance:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end
function modifier_mountain_protector_steelforge_stance:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }

    return funcs
end
function modifier_mountain_protector_steelforge_stance:GetModifierHealthRegenPercentage()
    return MOUNTAIN_PROTECTOR_ARCANA1_W_HP_REGEN_PCT[self:GetAbility():GetLevel()]
end
function modifier_mountain_protector_steelforge_stance:GetRoshpitArmorBonus()
    return MOUNTAIN_PROTECTOR_ARCANA1_W_ARMOR_AND_MAGIC_ARMOR[self:GetAbility():GetLevel()]
end
function modifier_mountain_protector_steelforge_stance:GetRoshpitMagicArmorBonus()
    return MOUNTAIN_PROTECTOR_ARCANA1_W_ARMOR_AND_MAGIC_ARMOR[self:GetAbility():GetLevel()]
end
function modifier_mountain_protector_steelforge_stance:GetDamageReduction()
    if IsServer() then
        return MOUNTAIN_PROTECTOR_ARCANA1_W_DMG_RED[self:GetAbility():GetLevel()] / 100
    end
end

function modifier_mountain_protector_steelforge_stance:GetPhysicalDamageReduction()
    return self:GetDamageReduction()
end

function modifier_mountain_protector_steelforge_stance:GetMagicalDamageReduction()
    return self:GetDamageReduction()  
end

function modifier_mountain_protector_steelforge_stance:GetPureDamageReduction()
    return self:GetDamageReduction() 
end
function modifier_mountain_protector_steelforge_stance:OnIntervalThink()
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
        local w_4_level = caster:GetRuneValue("w", 4)
        local bonus_damage = caster:GetStrength() * MOUNTAIN_PROTECTOR_ARCANA1_W4_ATTACK_PER_STR * w_4_level
        if bonus_damage then
            caster:SetModifierStackCount("modifier_mountain_protector_arcana_w_4", caster, bonus_damage)
        end
        if not caster:HasModifier("modifier_energy_channel_animating") then
            caster:AddNewModifier(caster, ability, "modifier_energy_channel_animating", {duration = 6})
            StartAnimation(caster, {duration = 7, activity = ACT_DOTA_TELEPORT, rate = 0.8, translate = "fallen_legion"})
        end
    end
end

modifier_energy_channel_animating = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_energy_channel_animating", "heroes/legion_commander/mountain_protector_steelforge_stance", LUA_MODIFIER_MOTION_NONE)

function modifier_energy_channel_animating:IsHidden()
    return true
end

modifier_mountain_protector_steelforge_stone = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_steelforge_stone", "heroes/legion_commander/mountain_protector_steelforge_stance", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_steelforge_stone:IsHidden()
    return true
end
function modifier_mountain_protector_steelforge_stone:GetStatusEffectName()
    return "particles/roshpit/mountain_protector/status_steel.vpcf"
end
function modifier_mountain_protector_steelforge_stone:StatusEffectPriority()
    return 100
end
	
modifier_mountain_protector_arcana_w_2 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_arcana_w_2", "heroes/legion_commander/mountain_protector_steelforge_stance", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_arcana_w_2:IsHidden()
    return true
end
function modifier_mountain_protector_arcana_w_2:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_SPECIAL_TYPE_ON_STUN
        })
    end
end
function modifier_mountain_protector_arcana_w_2:OnStun(event)
    local target = event.target
    local caster = self:GetParent()
    local ability = self:GetAbility()
    local duration = event.stunDuration * MOUNTAIN_PROTECTOR_ARCANA1_W2_DURATION_MULT
    target:AddNewModifier(caster, ability, "modifier_mountain_protector_arcana_w_2_debuff", {duration = duration})
    local w_2_level = caster:GetRuneValue("w", 2)
    target:SetModifierStackCount("modifier_mountain_protector_arcana_w_2_debuff", caster, w_2_level)
end

modifier_mountain_protector_arcana_w_2_debuff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_arcana_w_2_debuff", "heroes/legion_commander/mountain_protector_steelforge_stance", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_arcana_w_2_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end
function modifier_mountain_protector_arcana_w_2_debuff:GetModifierAttackSpeedBonus_Constant()
    return self:GetStackCount() * MOUNTAIN_PROTECTOR_ARCANA1_W2_ATTACK_SLOW
end
function modifier_mountain_protector_arcana_w_2_debuff:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount() * MOUNTAIN_PROTECTOR_ARCANA1_W2_MOVE_SLOW
end
function modifier_mountain_protector_arcana_w_2_debuff:GetTexture()
    return "mountain_protector/mountain_protector_w_2_arcana1"
end

modifier_mountain_protector_arcana_w_3 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_arcana_w_3", "heroes/legion_commander/mountain_protector_steelforge_stance", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_arcana_w_3:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end
function modifier_mountain_protector_arcana_w_3:GetTexture()
    return "mountain_protector/mountain_protector_w_3_arcana1"
end
function modifier_mountain_protector_arcana_w_3:IsHidden()
    return true
end
function modifier_mountain_protector_arcana_w_3:OnTakeDamage(event)
    if IsServer() then
        local attacker = event.attacker
        local hero = self:GetParent()
        local ability = self:GetAbility()
        if IsValidEntity(attacker) then
            if not attacker:IsAlive() then
                return false
            end
            if attacker == hero then
                return false
            end
            local w_3_level = hero:GetRuneValue("w", 3)
            if w_3_level > 0 then
                Filters:ApplyStun(hero, MOUNTAIN_PROTECTOR_ARCANA1_W3_STUN_DURATION_CONST, attacker)
                if not ability.w_3_particles then
                    ability.w_3_particles = 0
                end
                if ability.w_3_particles < 10 then
                    ability.w_3_particles = ability.w_3_particles + 1
                    local w_3_damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * MOUNTAIN_PROTECTOR_ARCANA1_W3_DAMAGE_PERCENT / 100 * w_3_level
                    Filters:TakeArgumentsAndApplyDamage(attacker, hero, w_3_damage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_ICE)
                    local pfx = ParticleManager:CreateParticle("particles/roshpit/mountain_protector/blue_steel_dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, hero)
                    ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT, "attach_hitloc", hero:GetAbsOrigin() + Vector(0, 0, 80), true)
                    ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT, "attach_hitloc", attacker:GetAbsOrigin() + Vector(0, 0, 80), true)
                    Timers:CreateTimer(2.0, function()
                        ParticleManager:DestroyParticle(pfx, false)
                        ability.w_3_particles = ability.w_3_particles - 1
                    end)
                end
            end
        end
    end
end

modifier_mountain_protector_arcana_w_4 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_mountain_protector_arcana_w_4", "heroes/legion_commander/mountain_protector_steelforge_stance", LUA_MODIFIER_MOTION_NONE)

function modifier_mountain_protector_arcana_w_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }

    return funcs
end
function modifier_mountain_protector_arcana_w_4:OnRefreshed()
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end
function modifier_mountain_protector_arcana_w_4:GetModifierBaseAttack_BonusDamage()
    return self:GetStackCount()
end
function modifier_mountain_protector_arcana_w_4:IsHidden()
    return true
end
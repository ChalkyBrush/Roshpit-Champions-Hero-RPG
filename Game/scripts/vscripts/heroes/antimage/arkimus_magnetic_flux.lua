require('heroes/antimage/arkimus_constants')
require('heroes/base_ability')
require('heroes/antimage/arkimus_common')

arkimus_magnetic_flux = class(base_ability)

function arkimus_magnetic_flux:GetBaseManaCost(level)
    return 0
end

function arkimus_magnetic_flux:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function arkimus_magnetic_flux:GetBaseCooldown(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return ARKIMUS_Q_COOLDOWN[level + 1]
end


function arkimus_magnetic_flux:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function arkimus_magnetic_flux:GetCastPoint()
    return 0
end

function arkimus_magnetic_flux:GetIntrinsicModifierName()
    return "modifier_arkimus_magnetic_flux"
end

function arkimus_magnetic_flux:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self
    
        StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.4, translate = "slasher_mask"})
        Timers:CreateTimer(0.25, function()
            local avatarDuration = Filters:GetAdjustedBuffDuration(caster, ability:GetSpecialValueFor("duration"), false)
            caster:AddNewModifier(caster, ability, "modifier_arkimus_magnetic_flux_buff", {duration = avatarDuration})
        end)
        local q_4_level = caster:GetRuneValue("q", 4)
        if q_4_level > 0 then
            caster:AddNewModifier(caster, ability, "modifier_arkimus_arcana_q_4_buff", {duration = avatarDuration})
            caster:SetModifierStackCount("modifier_arkimus_arcana_q_4_buff", caster, q_4_level)
        end
        Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
    end
end

modifier_arkimus_magnetic_flux = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_magnetic_flux", "heroes/antimage/arkimus_magnetic_flux", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_magnetic_flux:OnCreated()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:AddNewModifier(hero, ability, "modifier_arkimus_arcana_q_1", {})
        hero:AddNewModifier(hero, ability, "modifier_arkimus_arcana_q_3", {})
    end
end
function modifier_arkimus_magnetic_flux:IsHidden()
    return true
end
function modifier_arkimus_magnetic_flux:IsBuff()
    return true
end
function modifier_arkimus_magnetic_flux:OnRemoved()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:RemoveModifierByName("modifier_arkimus_arcana_q_1")
        hero:RemoveModifierByName("modifier_arkimus_arcana_q_3")
    end
end

modifier_arkimus_magnetic_flux_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_magnetic_flux_buff", "heroes/antimage/arkimus_magnetic_flux", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_magnetic_flux_buff:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
    
        if not caster.arkimus_arcana1_pfx then
            local arkimus_arcana1_pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/arcana_zap_field.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(arkimus_arcana1_pfx, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(arkimus_arcana1_pfx, 1, Vector(500, 10, 500))
            ParticleManager:SetParticleControl(arkimus_arcana1_pfx, 2, caster:GetAbsOrigin() + Vector(0, 0, 160))
            ParticleManager:SetParticleControl(arkimus_arcana1_pfx, 5, caster:GetAbsOrigin())
            caster.arkimus_arcana1_pfx = arkimus_arcana1_pfx
        end
        self:StartIntervalThink(0.03)
    end
end
function modifier_arkimus_magnetic_flux_buff:IsHidden()
    return false
end
function modifier_arkimus_magnetic_flux_buff:IsBuff()
    return true
end
function modifier_arkimus_magnetic_flux_buff:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        if not ability then
            if caster.arkimus_arcana1_pfx then
                ParticleManager:DestroyParticle(caster.arkimus_arcana1_pfx, true)
                caster.arkimus_arcana1_pfx = nil
            end
            caster:RemoveModifierByName("modifier_arkimus_magnetic_flux_buff")
            return false
        end
        if not ability.interval then
            ability.interval = 0
        end
        if not ability.particleCount then
            ability.particleCount = 0
        end
        ability.interval = ability.interval + 1
        if ability.interval == 6 then
            ability.interval = 0
            local damage = ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("int_damage") * caster:GetIntellect()
            local searchRadius = ARKIMUS_ARCANA1_Q_AOE
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.ZonisLightning", caster)
                for _, enemy in pairs(enemies) do
                    if ability.particleCount < 5 then
                        ability.particleCount = ability.particleCount + 1
                        CreateZonisBeam(caster:GetAbsOrigin() + Vector(0, 0, 120), enemy:GetAbsOrigin() + Vector(0, 0, 50))
                        Timers:CreateTimer(0.5, function()
                            ability.particleCount = ability.particleCount - 1
                        end)
                    end
                    enemy:AddNewModifier(caster, ability, "modifier_arkimus_stun", {duration = ARKIMUS_ARCANA1_Q_STUN})
                    local q_2_level = caster:GetRuneValue("q", 2)
                    if q_2_level > 0 then
                        enemy:AddNewModifier(caster, ability, "modifier_arkimus_arcana_q_2_debuff", {duration = ARKIMUS_ARCANA1_Q_STUN})
                        enemy:SetModifierStackCount("modifier_arkimus_arcana_q_2_debuff", caster, q_2_level)
                    end
                    Filters:ApplyStun(caster, ARKIMUS_ARCANA1_Q_STUN, enemy)
                    Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, ARKIMUS_ARCANA1_Q_DAMAGE_TYPE, BASE_ABILITY_Q, ARKIMUS_ARCANA1_Q_ELEMENT1, ARKIMUS_ARCANA1_Q_ELEMENT2)
                end
            end
        end
        ParticleManager:SetParticleControl(caster.arkimus_arcana1_pfx, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(caster.arkimus_arcana1_pfx, 2, caster:GetAbsOrigin() + Vector(0, 0, 160))
        ParticleManager:SetParticleControl(caster.arkimus_arcana1_pfx, 5, caster:GetAbsOrigin())
    end
end
function modifier_arkimus_magnetic_flux_buff:OnRemoved()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        if caster.arkimus_arcana1_pfx then
            ParticleManager:DestroyParticle(caster.arkimus_arcana1_pfx, false)
            ParticleManager:ReleaseParticleIndex(caster.arkimus_arcana1_pfx)
            caster.arkimus_arcana1_pfx = nil
        end
        caster:RemoveModifierByName("modifier_arkimus_arcana_q_4_buff")
    end
end


modifier_arkimus_arcana_q_1 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_arcana_q_1", "heroes/antimage/arkimus_magnetic_flux", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_q_1:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_INTELLIGENCE_BONUS
        })
    end
end

function modifier_arkimus_arcana_q_1:GetRoshpitIntelligenceBonus()
    if IsServer() then
        local hero = self:GetParent()
        return ARKIMUS_ARCANA1_Q1_INT * hero:GetRuneValue("q", 1)
    end
end

function modifier_arkimus_arcana_q_1:IsHidden()
    return true
end

modifier_arkimus_arcana_q_2_debuff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_arcana_q_2_debuff", "heroes/antimage/arkimus_magnetic_flux", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_q_2_debuff:IsHidden()
    return false
end
function modifier_arkimus_arcana_q_2_debuff:IsDebuff()
    return true
end

function modifier_arkimus_arcana_q_2_debuff:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
        })
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

function modifier_arkimus_arcana_q_2_debuff:GetRoshpitMagicArmorBonus()
    if IsServer() then
        return self:GetStackCount() * ARKIMUS_ARCANA1_Q2_MAGIC_ARMOR_REDUCTION
    end
end

function modifier_arkimus_arcana_q_2_debuff:OnRemoved()
    if IsServer() then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end
function modifier_arkimus_arcana_q_2_debuff:OnRefresh()
    if IsServer() then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

modifier_arkimus_arcana_q_3 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_arcana_q_3", "heroes/antimage/arkimus_magnetic_flux", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_q_3:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_arkimus_arcana_q_3:OnTakeDamage(event)
    local hero = self:GetParent()
    if IsServer() and self:CheckOnDamageTaken(event) then
        print(event.damage)
        local ability = self:GetAbility()
        if not ability.pfxCount then
            ability.pfxCount = 0
        end
    
        local q_3_level = hero:GetRuneValue("q", 3)
        if q_3_level > 0 then
            local duration = Filters:GetAdjustedBuffDuration(hero, ARKIMUS_ARCANA1_Q3_DUR_BASE, false)
            hero:AddNewModifier(hero, ability, "modifier_arkimus_arcana_q_3_buff", {duration = duration})
            local currentStacks = hero:GetModifierStackCount("modifier_arkimus_arcana_q_3_buff", hero)
            print(currentStacks)
            local newStacks = math.min(currentStacks + 1, q_3_level * ARKIMUS_ARCANA1_Q3_STACKS)
            print(newStacks)
            hero:SetModifierStackCount("modifier_arkimus_arcana_q_3_buff", hero, newStacks)
        end
    end
end

function modifier_arkimus_arcana_q_3:IsHidden()
    return true
end

modifier_arkimus_arcana_q_3_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_arcana_q_3_buff", "heroes/antimage/arkimus_magnetic_flux", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_q_3_buff:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
            MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
            MODIFIER_ROSHPIT_PURE_DMG_REDUCTION
        })
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

function modifier_arkimus_arcana_q_3_buff:GetPhysicalDamageReduction()
    if IsServer() then
        local stacks = self:GetStackCount()
        return 1 - ((1 - ARKIMUS_ARCANA1_Q3_DMG_RED_PER_STACK_EXP_BASE) ^ stacks)
    end
end
function modifier_arkimus_arcana_q_3_buff:GetMagicalDamageReduction()
    if IsServer() then
        local stacks = self:GetStackCount()
        return 1 - ((1 - ARKIMUS_ARCANA1_Q3_DMG_RED_PER_STACK_EXP_BASE) ^ stacks)
    end
end
function modifier_arkimus_arcana_q_3_buff:GetPureDamageReduction()
    if IsServer() then
        local stacks = self:GetStackCount()
        return 1 - ((1 - ARKIMUS_ARCANA1_Q3_DMG_RED_PER_STACK_EXP_BASE) ^ stacks)
    end
end

function modifier_arkimus_arcana_q_3_buff:OnRemoved()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        local q_3_stacks = self:GetStackCount()
        if q_3_stacks > 0 and caster:HasModifier("modifier_arkimus_arcana_q_3") then
            q_3_stacks = q_3_stacks - 1
            caster:AddNewModifier(caster, ability, "modifier_arkimus_arcana_q_3_buff", {duration = 5})
            caster:SetModifierStackCount("modifier_arkimus_arcana_q_3_buff", caster, q_3_stacks)
        end
    end
end

modifier_arkimus_arcana_q_4_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_arcana_q_4_buff", "heroes/antimage/arkimus_magnetic_flux", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_q_4_buff:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_AGILITY_BONUS,
            RPC_ELEMENT_LIGHTNING
        })
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

function modifier_arkimus_arcana_q_4_buff:GetRoshpitAgilityBonus()
    if IsServer() then
        local hero = self:GetParent()
        return hero:GetRuneValue("q", 4) * ARKIMUS_ARCANA1_Q4_AGI
    end
end

function modifier_arkimus_arcana_q_4_buff:GetRoshpitElementalDmgBonus()
    if IsServer() then
        local hero = self:GetParent()
        return hero:GetRuneValue("q", 4) * ARKIMUS_ARCANA1_Q4_LIGHTNING_AMP
    end
end


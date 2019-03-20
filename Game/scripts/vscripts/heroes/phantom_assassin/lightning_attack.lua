function lightning_attack_start(event)
    local caster = event.caster
    local ability = event.ability
    Filters:CastSkillArguments(1, caster)
    caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "voltex")
    local buffDuration = ability:GetSpecialValueFor("duration")
    if caster:HasModifier("modifier_voltex_glyph_5_a") then
        buffDuration = buffDuration + 3
    end
    buffDuration = Filters:GetAdjustedBuffDuration(caster, buffDuration, false)
    caster:RemoveModifierByName("modifier_gods_strength_datadriven")
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_gods_strength_datadriven", {duration = buffDuration})
    if caster:HasModifier("modifier_voltex_glyph_1_1") then
        local ability = event.ability
        caster:RemoveModifierByName("modifier_voltex_glyph_1_1_effect")
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_1_1_effect", {duration = buffDuration})
    end
    if caster:HasModifier("modifier_voltex_glyph_2_1") then
        local ability = event.ability
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_visible", {duration = buffDuration})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_invisible", {duration = buffDuration})
        Timers:CreateTimer(0.03, function()
            local agility = caster:GetBaseAgility()
            caster:SetModifierStackCount( "modifier_voltex_glyph_2_1_effect_invisible", ability, agility)
        end)
    end
end

function LightningAttack( keys )
    local attacker = keys.caster
    local caster = attacker
    local ability = keys.ability
    local hero = caster
    local abilityLevel = ability:GetLevel()
    local position = attacker:GetAbsOrigin()
    local target = keys.target
    local unit = target


    EmitSoundOn("Hero_ShadowShaman.EtherShock", target)
    local particleName = "particles/roshpit/voltex/overcharge_lightning_attack.vpcf"
    local radius = keys.search_radius
    local damage = keys.damage
    local shock_limit = keys.shock_limit
    local particleLimit = 42
    if caster:GetUnitName() ==  "zap_assassin_clone" then
        particleLimit = 16
    end
    if not ability.particleCount then
        ability.particleCount = 0
    end
    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
    ParticleManager:SetParticleControl(lightningBolt,0,Vector(attacker:GetAbsOrigin().x,attacker:GetAbsOrigin().y,attacker:GetAbsOrigin().z + attacker:GetBoundingMaxs().z ))   
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
    -- ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBolt, true)
    end)
    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin()+caster:GetForwardVector()*(radius-100), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local targets_shocked = 1
    for _,unit in pairs(enemies) do
        if targets_shocked >= shock_limit then
            break
        end
        -- Particle
        local origin = unit:GetAbsOrigin()
        if ability.particleCount < particleLimit then
            ability.particleCount = ability.particleCount + 1
            local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
            ParticleManager:SetParticleControl(lightningBolt,0,Vector(attacker:GetAbsOrigin().x,attacker:GetAbsOrigin().y,attacker:GetAbsOrigin().z + 100 ))   
            ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
            Timers:CreateTimer(2, function()
                ability.particleCount = ability.particleCount - 1
                ParticleManager:DestroyParticle(lightningBolt, true)
            end)    
        end
        if not caster:IsIllusion() then    
            if caster.q_4_level then
                damage = damage + OverflowProtectedGetAverageTrueAttackDamage(attacker)*0.15*caster.q_4_level
            end
            Filters:TakeArgumentsAndApplyDamage(unit, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
        else
            if caster.hero.q_4_level then
                damage = damage + OverflowProtectedGetAverageTrueAttackDamage(attacker)*0.15*caster.hero.q_4_level
            end
            Filters:TakeArgumentsAndApplyDamage(unit, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
        end
        targets_shocked = targets_shocked + 1
        if not caster:IsIllusion() then
            if caster.q_3_level then
                if caster.q_3_level > 0 then
                    caster.q_3_ability:ApplyDataDrivenModifier(caster.q_3_runeUnit, unit, "modifier_voltex_rune_q_3", {duration = 6})
                    additional_stacks = caster.q_3_level
                    local current_stack = unit:GetModifierStackCount( "modifier_voltex_rune_q_3", caster.q_3_ability )
                    local stacks = current_stack+additional_stacks
                    if stacks > 2000 then
                        stacks = 2000
                    end
                    unit:SetModifierStackCount( "modifier_voltex_rune_q_3", caster.q_3_ability, stacks ) 
                    local luck = RandomInt(1, 10)
                    if luck <= 3 then
                        local q3damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*0.5*caster.q_3_level

                        Filters:TakeArgumentsAndApplyDamage(unit, caster, q3damage, DAMAGE_TYPE_PHYSICAL, 1, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
                    end
                end
            end
        else
            if caster.hero.q_3_level then
                if caster.hero.q_3_level > 0 then
                    caster.hero.q_3_ability:ApplyDataDrivenModifier(caster.hero.q_3_runeUnit, unit, "modifier_voltex_rune_q_3", {duration = 6})
                    additional_stacks = caster.hero.q_3_level
                    local current_stack = unit:GetModifierStackCount( "modifier_voltex_rune_q_3", caster.hero.q_3_ability )
                    local stacks = current_stack+additional_stacks
                    if stacks > 2000 then
                        stacks = 2000
                    end
                    unit:SetModifierStackCount( "modifier_voltex_rune_q_3", caster.hero.q_3_ability, stacks ) 
                end
            end
        end
    end
end

function rune_q_3_strike(attacker, ability, totalLevel, target)

    local particleName = "particles/items_fx/chain_lightning.vpcf"
    local radius = 300 + totalLevel*40
    local damage = 80*totalLevel

    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
    ParticleManager:SetParticleControl(lightningBolt,0,Vector(attacker:GetAbsOrigin().x,attacker:GetAbsOrigin().y,attacker:GetAbsOrigin().z + 100))   
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
    ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    -- EmitSoundOn("Hero_Chen.HandOfGodHealCreep", target)
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
        ParticleManager:ReleaseParticleIndex(lightningBolt)
    end)
    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local targets_shocked = 1 --Is targets=extra targets or total?
    for _,unit in pairs(enemies) do
            if unit ~= target then
                -- Particle
                local origin = unit:GetAbsOrigin()
                local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
                ParticleManager:SetParticleControl(lightningBolt,0,Vector(attacker:GetAbsOrigin().x,attacker:GetAbsOrigin().y,attacker:GetAbsOrigin().z + attacker:GetBoundingMaxs().z ))   
                ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
            
                -- Damage
                ApplyDamage({ victim = unit, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

                -- Increment counter
                --targets_shocked = targets_shocked + 1
            end
    end
end

function lightning_attack_start(event)
    local caster = event.caster
    Filters:CastSkillArguments(1, caster)
    caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "voltex")
    local buffDuration = Filters:GetAdjustedBuffDuration(caster, 5, false)
    if caster:HasModifier("modifier_voltex_glyph_1_1") then
        local ability = event.ability
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_1_1_effect", {duration = buffDuration})
    end
    if caster:HasModifier("modifier_voltex_glyph_2_1") then
        caster:RemoveModifierByName("modifier_voltex_glyph_2_1_effect_invisible")
        caster:RemoveModifierByName("modifier_voltex_glyph_2_1_effect_visible")
        local ability = event.ability
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_visible", {duration = buffDuration})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_invisible", {duration = buffDuration})
        caster:SetModifierStackCount( "modifier_voltex_glyph_2_1_effect_invisible", ability, caster:GetAgility() ) 
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
    ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
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
        if ability.d_a_level then
            damage = damage + attacker:GetAverageTrueAttackDamage(attacker)*0.03*ability.d_a_level
        end
        -- Damage
        Filters:TakeArgumentsAndApplyDamage(unit, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
        -- Increment counter
        targets_shocked = targets_shocked + 1
        if ability.c_a_level then
            if ability.c_a_level > 0 then
                ability.c_a_ability:ApplyDataDrivenModifier(ability.c_a_runeUnit, unit, "modifier_voltex_rune_c_a", {duration = 6})
                additional_stacks = ability.c_a_level
                local current_stack = unit:GetModifierStackCount( "modifier_voltex_rune_c_a", ability.c_a_ability )
                local stacks = current_stack+additional_stacks
                if stacks > 2000 then
                    stacks = 2000
                end
                unit:SetModifierStackCount( "modifier_voltex_rune_c_a", ability.c_a_ability, stacks ) 
            end
        end
    end
end

function rune_c_a_strike(attacker, ability, totalLevel, target)

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

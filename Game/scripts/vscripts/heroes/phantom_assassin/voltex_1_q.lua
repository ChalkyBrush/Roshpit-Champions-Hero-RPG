require('heroes/phantom_assassin/voltex_constants')

function voltex_overcharge_onspellstart(event)
    local caster = event.caster
    local ability = event.ability
    Filters:CastSkillArguments(1, caster)
    local duration = VOLTEX_Q_BASE_DUR
    if caster:HasModifier("modifier_voltex_glyph_5_a") then
        duration = duration * ((100 + VOLTEX_GLYPH_5_A_DURATION_INCREASE_PCT) / 100)
    end
    duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
    caster:RemoveModifierByName("modifier_gods_strength_datadriven")
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_gods_strength_datadriven", {duration = duration})
    if caster:HasModifier("modifier_voltex_glyph_1_1") then
        local ability = event.ability
        caster:RemoveModifierByName("modifier_voltex_glyph_1_1_effect")
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_1_1_effect", {duration = duration})
    end
    if caster:HasModifier("modifier_voltex_glyph_2_1") then
        local ability = event.ability
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_visible", {duration = duration})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_invisible", {duration = duration})
        Timers:CreateTimer(0.03, function()
            local agility = caster:GetBaseAgility()
            caster:SetModifierStackCount( "modifier_voltex_glyph_2_1_effect_invisible", ability, agility)
        end)
    end
	voltex_q_1(event)
end


function voltex_overcharge_onattacklanded( keys )
    local attacker = keys.caster
    local caster = attacker
    local ability = keys.ability
    local hero = caster
    local position = attacker:GetAbsOrigin()
    local target = keys.target
    local unit = target


    EmitSoundOn("Hero_ShadowShaman.EtherShock", target)
    local particleName = "particles/roshpit/voltex/overcharge_lightning_attack.vpcf"
    local radius = keys.search_radius
    local damage = keys.damage
    local shock_limit = keys.shock_limit
    local particleLimit = 42
    if caster:IsIllusion() then
		hero = caster.hero
        particleLimit = 16
    end
	
	local q_4_level = hero:GetRuneValue("q", 4)
    if q_4_level > 0 then    
        damage = damage + OverflowProtectedGetAverageTrueAttackDamage(attacker) * 0.15 * q_4_level
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
        Filters:TakeArgumentsAndApplyDamage(unit, hero, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)

        targets_shocked = targets_shocked + 1
		voltex_q_3(attacker, unit, hero)
    end
end

function voltex_q_1(event)
	local caster = event.caster
    local q_1_level = caster:GetRuneValue("q", 1)
    if q_1_level > 0 then
		local runeUnit = caster.runeUnit
		local q_1_ability = runeUnit:FindAbilityByName("voltex_rune_q_1")
		local duration = VOLTEX_Q_BASE_DUR
		if caster:HasModifier("modifier_voltex_glyph_5_a") then
			duration = duration * ((100 + VOLTEX_GLYPH_5_A_DURATION_INCREASE_PCT) / 100)
		end
        q_1_ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_q_1_buff", {duration = duration})
        caster:SetModifierStackCount( "modifier_voltex_rune_q_1_buff", q_1_ability, q_1_level )
    end
end

function voltex_q_3(attacker, target, hero)
	local q_3_level = hero:GetRuneValue("q", 3)
    if q_3_level > 0 then
		local q_3_ability = hero.runeUnit3:FindAbilityByName("voltex_rune_q_3")
        q_3_ability:ApplyDataDrivenModifier(hero.runeUnit3, target, "modifier_voltex_rune_q_3", {duration = 6})
        local current_stack = target:GetModifierStackCount( "modifier_voltex_rune_q_3", q_3_ability )
        local stacks = current_stack + q_3_level
        if stacks > 2000 then
            stacks = 2000
        end
        target:SetModifierStackCount( "modifier_voltex_rune_q_3", q_3_ability, stacks ) 
        local luck = RandomInt(1, 10)
        if luck <= 3 then
            local q3damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * 0.5 * q_3_level
            Filters:TakeArgumentsAndApplyDamage(target, hero, q3damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_Q, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
        end
    end
end
require("heroes/axe/red_general_constants")
local Helper = require("heroes/util/helper")
local WAmplify = require('heroes/axe/glyphs/t52_w_amplify')
local ImmortalWeapon3 = require('heroes/axe/weapons/immortal_weapon_3')

function red_general_ability_base_r_sunder_startChannel(event)
    local caster = event.caster
    local ability = event.ability
    Helper.initializeAbilityRunes(caster, 'axe', 'r')
    red_general_rune_base_r_3_cast(caster, ability)
    ImmortalWeapon3.amplifyShieldsCount(caster)
end

function red_general_ability_base_r_sunder_createDunk(caster, damage)
    StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.3})
    Timers:CreateTimer(0.2, function()
        local slamPoint = caster:GetAbsOrigin() + caster:GetForwardVector() * 250
        EmitSoundOn("RedGeneral.Sunder", caster)

        local particleName = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf"
        local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(particle1, 0, slamPoint)
        Timers:CreateTimer(4, function()
            ParticleManager:DestroyParticle(particle1, false)
        end)

        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), slamPoint, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
            end
        end
    end)
end

function red_general_ability_base_r_sunder_cast(event)
    local caster = event.caster
    local ability = event.ability
    local damage = event.damage / 100 * caster:GetHealth()
    WAmplify.applyBuff(caster)

    if caster:HasModifier("modifier_axe_glyph_5_a") then
        damage = damage * (1 + RED_GENERAL_GLYPH_5_A_AMPLIFY_PERCENT / 100)
    end

    Filters:CastSkillArguments(4, caster)

    local delay = Filters:GetDelayWithCastSpeed(caster, 0.35)
    local procsCount = 1
    if caster:HasModifier("modifier_axe_glyph_6_1") then
        procsCount = RED_GENERAL_GLYPH_6_1_DUNKS_COUNT
    end

    for i = 0, procsCount - 1, 1 do
        Timers:CreateTimer(i * delay, function()
            red_general_ability_base_r_sunder_createDunk(caster, damage)
        end)
    end
    Timers:CreateTimer(procsCount * delay, function()
        red_general_rune_base_r_1_cast(caster, ability, damage)
    end)
end

function red_general_rune_base_r_1_cast(caster, ability, damage)
    if caster.r_1_level <= 0 then
        return
    end
    red_general_rune_base_r_1_createTauntWaves(caster, ability, damage)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_2_visible", {duration = RED_GENERAL_R1_BUFF_DURATION})
end

function red_general_rune_base_r_1_createTauntWaves(caster, ability, damage)
    for i = 0, RED_GENERAL_R1_BUFF_DURATION, 1 do
        Timers:CreateTimer(0.2 + i, function()
            EmitSoundOn("RedGeneral.TauntWave", caster)
            local position = caster:GetAbsOrigin()
            local particleName = "particles/roshpit/red_general/berserker_timedialate.vpcf"
            local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
            local radius = 600
            ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
            ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
            Timers:CreateTimer(4, function()
                ParticleManager:DestroyParticle(particle, false)
            end)

            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    if enemy:GetAttackCapability() == DOTA_UNIT_CAP_NO_ATTACK then
                    else
                        ability:ApplyDataDrivenModifier(caster, enemy, "modifier_axe_rune_r_1_taunt", {duration = 1.5})
                        enemy:MoveToTargetToAttack(caster)
                    end
                    red_general_rune_base_r_2_dealDamage(caster, enemy, ability, damage)
                end
            end
        end)
    end
end

function red_general_rune_base_r_2_takeDamage(event)
    local caster = event.caster
    local ability = event.ability
    local attacker = event.attacker

    local start_radius = 140
    local end_radius = 140
    local range = 1500
    local speed = 1500
    if IsValidEntity(attacker) then
        if attacker == caster then
        else
            Events:CreateLightningBeamWithParticle(attacker:GetAbsOrigin() + Vector(0, 0, 60), caster:GetAbsOrigin() + Vector(0, 0, 140), "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_basher_lightning.vpcf", 1.5)

            local position = attacker:GetAbsOrigin()
            local radius = 260

            local damage = math.min(event.damage, 20 * caster:GetHealth());
            --print("incoming damage = " .. event.damage)
            damage = damage * caster.r_1_level * RED_GENERAL_R1_DAMAGE
            if caster:HasModifier("modifier_axe_glyph_5_a") then
                damage = damage * (1 + RED_GENERAL_GLYPH_5_A_AMPLIFY_PERCENT / 100)
            end

            --print("damage from r1 = " .. damage)
            Filters:TakeArgumentsAndApplyDamage(attacker, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
        end
    end
end

function red_general_rune_base_r_2_dealDamage(caster, target, ability, initialDamage)
    local runesCount = caster.r_2_level
    if runesCount <= 0 then
        return
    end
    local damage = initialDamage * RED_GENERAL_R2_AMPLIFY_PERCENT / 100 * runesCount
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

end

function red_general_rune_base_r_3_cast(caster, ability)
    local runesCount = caster.r_3_level
    if runesCount <= 0 then
        return
    end
    local duration = Filters:GetAdjustedBuffDuration(caster, RED_GENERAL_R3_DURATION, false)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_3_visible", {duration = duration})
    caster:SetModifierStackCount("modifier_axe_rune_r_3_visible", caster, runesCount)
end

function red_general_rune_base_r_4_think(event)
    local ability = event.ability
    local caster = event.caster

    local runesCount = caster:GetRuneValue("r", 4)
    if runesCount <= 0 then
        caster:RemoveModifierByName("modifier_axe_rune_r_4_visible")
        caster:RemoveModifierByName("modifier_axe_rune_r_4_invisible")
        return
    end

    local partOfIncomingDamage = GameState:IncomingDamageDecrease(caster, nil, false)
    local stacksCount = 1
    if partOfIncomingDamage ~= 0 then
        stacksCount = math.ceil(math.log(1 / partOfIncomingDamage) / math.log(2))
    end

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_4_visible", {})
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_4_invisible", {})
    caster:SetModifierStackCount("modifier_axe_rune_r_4_visible", caster, stacksCount)
    caster:SetModifierStackCount("modifier_axe_rune_r_4_invisible", caster, runesCount * stacksCount)
end


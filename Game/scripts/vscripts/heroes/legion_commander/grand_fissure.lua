require("/heroes/legion_commander/mountain_protector_constants")
function start_channel(event)
    local caster = event.caster
    local ability = event.ability
    EmitSoundOn("legion_commander_legcom_econ_move_0" .. RandomInt(3, 10), caster)
    if caster:HasModifier("modifier_mountain_protector_glyph_6_1") then
        local currentCD = ability:GetCooldownTimeRemaining()
        ability:EndCooldown()
        local newCD = currentCD - 8
        ability:StartCooldown(newCD)
    end
end

function channel_interrupt(event)
end

function channel_complete(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target_points[1]
    local mainAOE = event.radius
    local explosionAOE = 300
    local damage = event.damage
    Filters:CastSkillArguments(4, caster)

    StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_ATTACK, rate = 1.1})
    EmitSoundOn("MysticAssasin.FissureYell", caster)
    EmitSoundOnLocationWithCaster(target, "MysticAssasin.FissureStart", caster)
    local particleName = "particles/roshpit/mystic_assassin/grand_fissure_explosion_beams.vpcf"
    local particleX = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particleX, 0, caster:GetAbsOrigin() + Vector(0, 0, 25))
    Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particleX, false)
	end)
    caster:RemoveModifierByName("modifier_mountain_protector_rune_r_2_visible")
    caster:RemoveModifierByName("modifier_mountain_protector_rune_r_2_invisible")
    if caster:HasModifier("modifier_mountain_protector_glyph_5_a") then
        ability.cast_difference = (target - caster:GetAbsOrigin()) * Vector(1, 1, 0)
    end
    local explosionCount = event.numExplosions
    for i = 1, explosionCount, 1 do
        Timers:CreateTimer(i * 0.3, function()
			local randomExplosionLocation = target + RandomVector(RandomInt(0, 500)) + Vector(0, 0, 20)
			if caster:HasModifier("modifier_mountain_protector_glyph_5_a") and ability.cast_difference then
				randomExplosionLocation = GetGroundPosition(caster:GetAbsOrigin() + ability.cast_difference + RandomVector(RandomInt(0, 700)) + Vector(0, 0, 20), caster)
			end
			aeon_fracture_explosion(caster, randomExplosionLocation, damage, 1, explosionAOE, ability, true, 0)
		end)
    end
    local r_3_level = caster:GetRuneValue("r", 3)
    if r_3_level > 0 then
        ability.burnCenter = target
        if caster:HasModifier("modifier_mountain_protector_glyph_5_a") and ability.cast_difference then
            for i = 1, explosionCount, 1 do
                Timers:CreateTimer(i * 0.3, function()
					CustomAbilities:QuickAttachThinker(ability, caster, GetGroundPosition(caster:GetAbsOrigin() + ability.cast_difference, caster) + Vector(0, 0, 50), "modifier_protector_r_3", {duration = 1.5})
				end)
            end
        else
            CustomAbilities:QuickAttachThinker(ability, caster, GetGroundPosition(target, caster) + Vector(0, 0, 50), "modifier_protector_r_3", {duration = 0.3 * explosionCount})
        end
    end
end

function mountain_protector_r_3_thinker(event)
    local caster = event.caster
	local ability = event.ability
	local r_3_level = caster:GetRuneValue("r", 3)
    local damage = r_3_level * (5000 + ability:GetCaster():GetStrength() * 5)

    Filters:TakeArgumentsAndApplyDamage(event.target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function aeon_fracture_explosion(caster, position, damage, amp, explosionAOE, ability, canBD, e_1_bonus_stun_duration)
    local stun_duration = 1.5
    damage = damage * amp
    -- if not ability.r_4_level then
    -- ability.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "mountain_protector")
    -- end
    -- damage = damage + 0.0003*caster:GetStrength()/10*ability.r_4_level*damage
    local particleName = "particles/roshpit/mystic_assassin/grand_fissure_explosion.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle1, 0, position)
    Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
    EmitSoundOnLocationWithCaster(position, "MysticAssasin.FissureExplosion", caster)

    local targetFlag = 0
    local damageType = DAMAGE_TYPE_MAGICAL
    if caster:HasModifier("modifier_mountain_protector_glyph_3_1") then
        damageType = DAMAGE_TYPE_PURE
        targetFlag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    end

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, targetFlag, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, damageType, BASE_ABILITY_R, RPC_ELEMENT_EARTH, RPC_ELEMENT_FIRE)
            Filters:ApplyStun(caster, stun_duration + e_1_bonus_stun_duration, enemy)
            local r_1_level = caster:GetRuneValue("r", 1)
            if r_1_level > 0 then
                local a_d_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * MOUNTAIN_PROTECTOR_R1_PCT / 100 * r_1_level
                Filters:TakeArgumentsAndApplyDamage(enemy, caster, a_d_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
                local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, caster)
                ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 80), true)
                ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT, "attach_hitloc", enemy:GetAbsOrigin() + Vector(0, 0, 80), true)
                Timers:CreateTimer(2.0, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
            end
            if canBD then
                local r_2_level = caster:GetRuneValue("r", 2)
                if r_2_level > 0 then
                    local b_d_duration = Filters:GetAdjustedBuffDuration(caster, 20, false)
                    local runeAbility = caster.runeUnit2:FindAbilityByName("mountain_protector_rune_r_2")
                    runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_mountain_protector_rune_r_2_visible", {duration = b_d_duration})
                    local currentStacks = caster:GetModifierStackCount("modifier_mountain_protector_rune_r_2_visible", caster.runeUnit2)
                    local stacksCount = min(currentStacks + 1, MOUNTAIN_PROTECTOR_R2_MAX_STACKS)
                    caster:SetModifierStackCount("modifier_mountain_protector_rune_r_2_visible", caster.runeUnit2, stacksCount)
                    runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_mountain_protector_rune_r_2_invisible", {duration = b_d_duration})
                    caster:SetModifierStackCount("modifier_mountain_protector_rune_r_2_invisible", caster.runeUnit2, stacksCount * r_2_level)
                end
            end
        end
        local refreshChance = ability:GetSpecialValueFor("refresh_chance")
        local luck = RandomInt(1, 100)
        if luck <= refreshChance then
            caster:GetAbilityByIndex(DOTA_E_SLOT):EndCooldown()
        end
    end
    if e_1_bonus_stun_duration > 0 then
        local pfx = ParticleManager:CreateParticle("particles/roshpit/mountain_protector/unshakable_stone_dust.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(pfx, 0, position)
        ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.4, 0.1))
        ParticleManager:SetParticleControl(pfx, 2, Vector(0.7, 0.7, 0.7))
        Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
    end
end

function c_d_thinker_think(event)
    local caster = event.caster
end

function glyph_7_1_damage(event)
    local attacker = event.attacker
    local caster = event.unit
    if caster:HasModifier("modifier_energy_channel") or caster:HasModifier("modifier_steelforge_stance") then
        local luck = RandomInt(1, 10)
        if luck <= 3 then
            Filters:ApplyStun(caster, 1, attacker)
        end
    end
end

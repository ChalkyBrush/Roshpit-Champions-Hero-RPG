require('/heroes/legion_commander/mountain_protector_constants')
function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("legion_commander_legcom_econ_move_0"..RandomInt(3, 10), caster)
	if caster:HasModifier("modifier_mountain_protector_glyph_6_1") then
		local currentCD = ability:GetCooldownTimeRemaining()
		ability:EndCooldown()
		local newCD = currentCD - 8
		ability:StartCooldown(newCD)
	end

	ability.r_1_level = caster:GetRuneValue("r", 1)
	ability.r_3_level = caster:GetRuneValue("r", 3)
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

	-- EmitSoundOnLocationWithCaster(target, "MysticAssasin.FissureStart", caster)
	local particleName = "particles/roshpit/mountain_protector/hailstorm_start_beams.vpcf"
	local particleX = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleX, 0, caster:GetAbsOrigin() + Vector(0, 0, 25))
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particleX, false)
	end)

	local hailstormThinker = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())
	hailstormThinker:FindAbilityByName("dummy_unit"):SetLevel(1)
	hailstormThinker.pfx = ParticleManager:CreateParticle("particles/roshpit/mountain_protector/hailstorm_base_snow_arcana1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(hailstormThinker.pfx, 0, hailstormThinker:GetAbsOrigin())

	local duration = 14
	ability:ApplyDataDrivenModifier(caster, hailstormThinker, "modifier_hailstorm_thinker", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, hailstormThinker, "modifier_hailstorm_thinker_enemy", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, hailstormThinker, "modifier_hailstorm_aura_friendly", {duration = duration})
	if caster:HasModifier("modifier_mountain_protector_glyph_5_a") then
		ability.cast_difference = (target - caster:GetAbsOrigin()) * Vector(1, 1, 0)
	end
	ability.hailstormThinker = hailstormThinker

	StartSoundEvent("MountainProtector.HailstormLoop", hailstormThinker)
end

function thinker_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	StopSoundEvent("MountainProtector.HailstormLoop", target)
	ParticleManager:DestroyParticle(target.pfx, false)
	Timers:CreateTimer(1, function()
		UTIL_Remove(target)
	end)
end

function hailstorm_thinker_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local randomExplosionLocation = target:GetAbsOrigin() + RandomVector(RandomInt(0, 700)) + Vector(0, 0, 20)
	if caster:HasModifier("modifier_mountain_protector_glyph_5_a") and ability.cast_difference then
		randomExplosionLocation = GetGroundPosition(caster:GetAbsOrigin() + ability.cast_difference + RandomVector(RandomInt(0, 700)) + Vector(0, 0, 20), caster)
		ability.hailstormThinker:SetAbsOrigin(caster:GetAbsOrigin() + ability.cast_difference)
		ParticleManager:DestroyParticle(ability.hailstormThinker.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.hailstormThinker.pfx)
		ability.hailstormThinker.pfx = ParticleManager:CreateParticle("particles/roshpit/mountain_protector/hailstorm_base_snow_arcana1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(ability.hailstormThinker.pfx, 0, ability.hailstormThinker:GetAbsOrigin())
	end
	local damage = event.damage + event.damage_from_strength * caster:GetStrength()
	hailstorm_explosion(caster, randomExplosionLocation, damage, 1, 300, ability, true, 0)
	-- if target:HasModifier("modifier_hailstorm_aura_friendly") then
	-- --print("I HAVE THE AURA")
	-- end
end

function hailstorm_explosion(caster, position, damage, amp, explosionAOE, ability, canBD, a_c_stun_duration)
	local stun_duration = 1.5
	damage = damage * amp
	-- if not ability.r_4_level then
	-- ability.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "mountain_protector")
	-- end
	-- damage = damage + 0.0003*caster:GetStrength()/10*ability.r_4_level*damage
	local particleName = "particles/roshpit/mountain_protector/ice_fracture.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOnLocationWithCaster(position, "MysticAssasin.HailstormExplosion", caster)

	local targetFlag = 0
	local damageType = DAMAGE_TYPE_MAGICAL
	if caster:HasModifier("modifier_mountain_protector_glyph_3_1") then
		damageType = DAMAGE_TYPE_PURE
		targetFlag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, targetFlag, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, damageType, BASE_ABILITY_R, RPC_ELEMENT_EARTH, RPC_ELEMENT_ICE)
			Filters:ApplyStun(caster, stun_duration + a_c_stun_duration, enemy)
		end
		local refreshChance = ability:GetSpecialValueFor("refresh_chance")
		local luck = RandomInt(1, 100)
		if luck <= refreshChance then
			caster:GetAbilityByIndex(DOTA_E_SLOT):EndCooldown()
		end
	end
	if a_c_stun_duration > 0 then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/mountain_protector/unshakable_stone_dust.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.1, 0.6, 0.9))
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
	if caster:HasModifier("modifier_energy_channel") then
		local luck = RandomInt(1, 10)
		if luck <= 3 then
			Filters:ApplyStun(caster, 1, attacker)
		end
	end
end

function hailstorm_aura_apply(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.r_1_level > 0 then
		if target:GetEntityIndex() == caster:GetEntityIndex() then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_hailstorm_strength", {})
			caster:SetModifierStackCount("modifier_hailstorm_strength", caster, ability.r_1_level)
		end
	end
end

function frozen_stand_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	caster:GetAbilityByIndex(DOTA_W_SLOT):SetActivated(false)
	caster:GetAbilityByIndex(DOTA_E_SLOT):SetActivated(false)
	caster:GetAbilityByIndex(DOTA_D_SLOT):SetActivated(false)
	ability.r2_level = caster:GetRuneValue("r", 2)

	local ability_duration = ARCANA2_R2_DURATION_BASE + ability.r2_level * ARCANA2_R2_DURATION
	local cooldown = max(ability_duration * ARCANA2_R2_COOLDOWN_PERCENT / 100, ARCANA2_R2_MIN_COOLDOWN)
	StartAnimation(caster, {duration = ability_duration, activity = ACT_DOTA_IDLE, rate = 1, translate = "injured"})

	local modifier = caster:FindModifierByName('modifier_frozen_stand')
	modifier:SetDuration(ability_duration, true)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hailstorm_ice_case_cooldown", {duration = cooldown})

	EmitSoundOn("MysticAssasin.MysticWaveYell2", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "MysticAssasin.FrozenStand", caster)
end

function frozen_stand_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	caster:GetAbilityByIndex(DOTA_W_SLOT):SetActivated(true)
	caster:GetAbilityByIndex(DOTA_E_SLOT):SetActivated(true)
	caster:GetAbilityByIndex(DOTA_D_SLOT):SetActivated(true)
	local stun_duration = ability.r2_level * ARCANA2_R2_STUN_DURATION
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ARCANA2_R2_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
	end
	local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
	local radius = 260
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	local origin = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(particle1, 1, Vector(ARCANA2_R2_RADIUS, 1, ARCANA2_R2_RADIUS))
	ParticleManager:SetParticleControl(particle1, 3, Vector(ARCANA2_R2_RADIUS, ARCANA2_R2_RADIUS, ARCANA2_R2_RADIUS))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "MysticAssasin.FrozenStandBreak", caster)
end

function hailstorm_enemy_aura_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.r_3_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hailstorm_enemy_amp", {})
		target:SetModifierStackCount("modifier_hailstorm_enemy_amp", caster, ability.r_3_level)
	end
end

local constants = require('/heroes/legion_commander/constants')
function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("legion_commander_legcom_econ_move_0"..RandomInt(3,10), caster)
	if caster:HasModifier("modifier_mountain_protector_glyph_6_1") then
		local currentCD = ability:GetCooldownTimeRemaining()
		ability:EndCooldown()
		local newCD = currentCD - 8
		ability:StartCooldown(newCD)
	end

	ability.a_d_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
	ability.c_d_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
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


	
	StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_ATTACK, rate=1.1})
	EmitSoundOn("MysticAssasin.FissureYell", caster)

	-- EmitSoundOnLocationWithCaster(target, "MysticAssasin.FissureStart", caster)
	local particleName = "particles/roshpit/mountain_protector/hailstorm_start_beams.vpcf"
	local particleX = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particleX, 0, caster:GetAbsOrigin()+Vector(0,0,25) )
	Timers:CreateTimer(1, 
	function()
		ParticleManager:DestroyParticle( particleX, false )
	end)	

	local hailstormThinker = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())
	hailstormThinker:FindAbilityByName("dummy_unit"):SetLevel(1)
	hailstormThinker.pfx = ParticleManager:CreateParticle("particles/roshpit/mountain_protector/hailstorm_base_snow_arcana1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(hailstormThinker.pfx, 0, hailstormThinker:GetAbsOrigin())

	local duration = 14
	if caster:HasModifier("modifier_mountain_protector_glyph_3_1") then
		duration = duration + 2
	end
	ability:ApplyDataDrivenModifier(caster, hailstormThinker, "modifier_hailstorm_thinker", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, hailstormThinker, "modifier_hailstorm_thinker_enemy", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, hailstormThinker, "modifier_hailstorm_aura_friendly", {duration = duration})
	if caster:HasModifier("modifier_mountain_protector_glyph_5_a") then
		ability.cast_difference = (target - caster:GetAbsOrigin())*Vector(1,1,0)
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
	local randomExplosionLocation = target:GetAbsOrigin() + RandomVector(RandomInt(0,700)) + Vector(0,0,20)
	if caster:HasModifier("modifier_mountain_protector_glyph_5_a") and ability.cast_difference then
		randomExplosionLocation = GetGroundPosition(caster:GetAbsOrigin()+ability.cast_difference + RandomVector(RandomInt(0,700)) + Vector(0,0,20), caster) 
		ability.hailstormThinker:SetAbsOrigin(caster:GetAbsOrigin()+ability.cast_difference)
		ParticleManager:DestroyParticle(ability.hailstormThinker.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.hailstormThinker.pfx)
		ability.hailstormThinker.pfx = ParticleManager:CreateParticle("particles/roshpit/mountain_protector/hailstorm_base_snow_arcana1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(ability.hailstormThinker.pfx, 0, ability.hailstormThinker:GetAbsOrigin())
	end
	local damage = event.damage + event.damage_from_strength * caster:GetStrength()
	hailstorm_explosion(caster, randomExplosionLocation, damage, 1, 300, ability, true, 0)
	-- if target:HasModifier("modifier_hailstorm_aura_friendly") then
	-- 	print("I HAVE THE AURA")
	-- end
end

function hailstorm_explosion(caster, position, damage, amp, explosionAOE, ability, canBD, a_c_stun_duration)
		local stun_duration = 1.5
		damage = damage*amp
		-- if not ability.d_d_level then
		-- 	ability.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "mountain_protector")
		-- end
		-- damage = damage + 0.0003*caster:GetStrength()/10*ability.d_d_level*damage
		local particleName = "particles/roshpit/mountain_protector/ice_fracture.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( particle1, 0, position )
		Timers:CreateTimer(4, 
		function()
			ParticleManager:DestroyParticle( particle1, false )
		end)	
		EmitSoundOnLocationWithCaster(position, "MysticAssasin.HailstormExplosion", caster)

		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_EARTH, RPC_ELEMENT_ICE)
				Filters:ApplyStun(caster, stun_duration+a_c_stun_duration, enemy)
			end
		end 
		if a_c_stun_duration > 0 then
			local pfx = ParticleManager:CreateParticle( "particles/roshpit/mountain_protector/unshakable_stone_dust.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 5, Vector(0.1, 0.6, 0.9))
			ParticleManager:SetParticleControl(pfx, 2, Vector(0.7,0.7,0.7))
			Timers:CreateTimer(10, function() 
			  ParticleManager:DestroyParticle( pfx, false )
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
		local luck = RandomInt(1,10)
		if luck <= 3 then
			Filters:ApplyStun(caster, 1, attacker)
		end
	end
end

function hailstorm_aura_apply(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.a_d_level > 0 then
		if target:GetEntityIndex() == caster:GetEntityIndex() then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_hailstorm_strength", {})
			caster:SetModifierStackCount("modifier_hailstorm_strength", caster, ability.a_d_level)
		end
	end
end

function frozen_stand_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	caster:GetAbilityByIndex(1):SetActivated(false)
	caster:GetAbilityByIndex(2):SetActivated(false)
	caster:GetAbilityByIndex(3):SetActivated(false)
	ability.r2_level = caster:GetRuneValue("r", 2)

	local ability_duration = constants.ARCANA2_R2_DURATION_BASE + ability.r2_level * constants.ARCANA2_R2_DURATION
	local cooldown = max(ability_duration * constants.ARCANA2_R2_COOLDOWN_PERCENT/100, constants.ARCANA2_R2_MIN_COOLDOWN)
	StartAnimation(caster, {duration=ability_duration, activity=ACT_DOTA_IDLE, rate=1, translate="injured"})

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
	caster:GetAbilityByIndex(1):SetActivated(true)
	caster:GetAbilityByIndex(2):SetActivated(true)
	caster:GetAbilityByIndex(3):SetActivated(true)
	local stun_duration =  ability.r2_level * constants.ARCANA2_R2_STUN_DURATION
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, constants.ARCANA2_R2_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
	end
end

function hailstorm_enemy_aura_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.c_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hailstorm_enemy_amp", {})	
		target:SetModifierStackCount("modifier_hailstorm_enemy_amp", caster, ability.c_d_level)
	end
end
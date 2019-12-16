require('heroes/juggernaut/seinaru_constants')

function begin_kaze_gust(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = event.range
	local speed = range + 200

	EmitSoundOn("Seinaru.KazeYell", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seinaru.KazeGust", caster)

	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.fv = fv

	caster:RemoveModifierByName("modifier_seinaru_rune_q_1")
	caster:RemoveModifierByName("modifier_seinaru_rune_q_1_invisible")
	local startPoint = caster:GetAbsOrigin()
	ability.castPosition = startPoint
	local particle = "particles/roshpit/seinaru/kaze_gust_wave.vpcf"
	local start_radius = 340
	local end_radius = 340
	ability.q_1_level = caster:GetRuneValue("q", 1)
	local q_2_level = caster:GetRuneValue("q", 2)
	ability.q_2_level = q_2_level
	if q_2_level > 0 then
		local b_a_duration = Filters:GetAdjustedBuffDuration(caster, SEINARU_Q2_DUR_BASE, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_q_2_speed", {duration = b_a_duration})
		caster:SetModifierStackCount("modifier_seinaru_q_2_speed", caster, q_2_level)
	end
	ability.q_3_level = caster:GetRuneValue("q", 3)
	if ability.q_3_level > 0 then
		local q_3_duration = Filters:GetAdjustedBuffDuration(caster,SEINARU_Q3_BUFF_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_q3_spell_and_armor_pierce", {duration = q_3_duration})
		caster:SetModifierStackCount("modifier_seinaru_q3_spell_and_armor_pierce", caster, ability.q_3_level)
	end
	ability.damage = event.damage
	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		ability.damage = ability.damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * SEINARU_Q4_ADD_DMG_PER_ATT * q_4_level
	end

	-- EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)

	local casterOrigin = caster:GetAbsOrigin()

	local info =
	{
		Ability = ability,
		EffectName = particle,
		vSpawnOrigin = startPoint + Vector(0, 0, 50),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	Filters:CastSkillArguments(1, caster)
	if caster:HasModifier("modifier_seinaru_immortal_weapon_2") then
		local CD = ability:GetCooldownTimeRemaining()
		local newCD = CD * 0.4
		ability:EndCooldown()
		ability:StartCooldown(newCD)
	end
end

function gust_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local stun_duration = SEINARU_Q_STUN_DUR_BASE
	local blind_duration = SEINARU_Q_BLIND_DUR_BASE
	local damage = ability.damage
	ability:ApplyDataDrivenModifier(caster, target, "modifier_kaze_gust_flail", {duration = stun_duration})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_kaze_gust_blind", {duration = blind_duration})

	local particleName = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- for i = 3, 9, 1 do
	-- ParticleManager:SetParticleControl(pfx, i, Vector(200,200,200))
	-- end
	Timers:CreateTimer(0.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if ability.q_1_level > 0 then
		local a_a_duration = Filters:GetAdjustedBuffDuration(caster, SEINARU_Q1_DUR_BASE, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_rune_q_1", {duration = a_a_duration})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_rune_q_1_invisible", {duration = a_a_duration})

		local newStacks = caster:GetModifierStackCount("modifier_seinaru_rune_q_1", caster) + 1
		caster:SetModifierStackCount("modifier_seinaru_rune_q_1", caster, newStacks)
		caster:SetModifierStackCount("modifier_seinaru_rune_q_1_invisible", caster, newStacks * ability.q_1_level)
	end
	if ability.q_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_seinaru_rune_q_2_slow", {duration = blind_duration})
		target:SetModifierStackCount("modifier_seinaru_rune_q_2_slow", caster, ability.q_2_level)
	end


	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
end

function kaze_pushback_think(event)
	local target = event.target
	if target.jumpLock then
		return false
	end
	local ability = event.ability
	local fv = ability.fv
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), ability.castPosition)
	local pushSpeed = math.max((1500 - distance) / 35, 3)
	target:SetAbsOrigin(target:GetAbsOrigin() + fv * pushSpeed)
end

function kaze_pushback_end(event)
	local target = event.target
	if target.jumpLock then
		return false
	end
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

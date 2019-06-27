function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_elemental_beam") then
		EndAnimation(caster)
		caster:RemoveModifierByName("modifier_elemental_beam")
		caster:Stop()
	else
		ability.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "warlord")
		ability.r_4_ability = caster.runeUnit4:FindAbilityByName("warlord_rune_r_4")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_channel_for_items", {duration = 1.8})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_channel_start", {duration = 0.05})
		EmitSoundOn("beastmaster_beas_ability_axes_06", caster)
	end

end

function one_second_channel(event)
	local caster = event.caster
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration = 6.8, activity = ACT_DOTA_CAST_ABILITY_5, rate = 0.25})
	end)
end

function break_channel(event)
	local caster = event.caster
	EndAnimation(caster)
end

function beginBeam(event)
	local caster = event.caster
	local beamLength = 600
	local ability = event.ability
	ability:EndCooldown()
	ability.beamLength = beamLength
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf"
	local particleName2 = "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/warlord_ult_ice.vpcf"
	local particleName3 = ""
	local particleVector = caster:GetAbsOrigin() + Vector(0, 0, 50) + (caster:GetForwardVector() * beamLength)
	ability.pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ability.pfx2 = ParticleManager:CreateParticle(particleName2, PATTACH_ABSORIGIN_FOLLOW, caster)

	ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(ability.pfx, 1, particleVector)

	ParticleManager:SetParticleControlEnt(ability.pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(ability.pfx2, 1, particleVector)
	ability.interval = 0
	EmitSoundOn("Hero_Invoker.DeafeningBlast", caster)
	Filters:CastSkillArguments(4, caster)
	local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "warlord")
	local runeAbility = caster.runeUnit:FindAbilityByName("warlord_rune_r_1")
	if a_d_level > 0 then
		local duration = 0.5 + a_d_level * 0.2
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_warlord_rune_r_1", {duration = duration})
		caster:SetModifierStackCount("modifier_warlord_rune_r_1", runeAbility, a_d_level)
		EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)
	end
	ability.r_2_level = Runes:GetTotalRuneLevel(caster, 2, "r_2", "warlord")
	ability.r_3_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "warlord")
	if ability.r_3_level > 0 then
		local c_d_beamRange = ability.r_3_level * 30 + 300
		particleVector = caster:GetAbsOrigin() + Vector(0, 0, 50) + (WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 8) * c_d_beamRange)
		ability.pfx3 = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
		ability.pfx4 = ParticleManager:CreateParticle(particleName2, PATTACH_ABSORIGIN_FOLLOW, caster)

		ParticleManager:SetParticleControlEnt(ability.pfx3, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(ability.pfx3, 1, particleVector)

		ParticleManager:SetParticleControlEnt(ability.pfx4, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(ability.pfx4, 1, particleVector)

		particleVector = caster:GetAbsOrigin() + Vector(0, 0, 50) + (WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi / 8) * c_d_beamRange)
		ability.pfx5 = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
		ability.pfx6 = ParticleManager:CreateParticle(particleName2, PATTACH_ABSORIGIN_FOLLOW, caster)

		ParticleManager:SetParticleControlEnt(ability.pfx5, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(ability.pfx5, 1, particleVector)

		ParticleManager:SetParticleControlEnt(ability.pfx6, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(ability.pfx6, 1, particleVector)
	end

	for i = 0, 2, 1 do
		local disableAbility = caster:GetAbilityByIndex(i)
		disableAbility:SetActivated(false)
	end
end

function beamThink(event)
	local caster = event.caster
	local ability = event.ability
	ability.beamLength = ability.beamLength + 15
	local beamLength = ability.beamLength
	local particleVector = caster:GetAbsOrigin() + Vector(0, 0, 50) + (caster:GetForwardVector() * beamLength)
	ParticleManager:SetParticleControl(ability.pfx, 1, particleVector)
	ParticleManager:SetParticleControl(ability.pfx2, 1, particleVector)
	ability.interval = ability.interval + 1
	if ability.interval % 5 == 0 and ability.interval < 31 then
		EmitSoundOn("Hero_Pugna.NetherBlast", caster)
	end
	if ability.interval % 2 == 0 then
		beamProjectile(caster:GetAbsOrigin(), beamLength, caster, ability, caster:GetForwardVector())
	end
	if ability.r_3_level > 0 then
		local c_d_beamRange = ability.r_3_level * 30 + 300
		local rotatedVector = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 8)
		particleVector = caster:GetAbsOrigin() + Vector(0, 0, 50) + (rotatedVector * c_d_beamRange)
		ParticleManager:SetParticleControl(ability.pfx3, 1, particleVector)
		ParticleManager:SetParticleControl(ability.pfx4, 1, particleVector)
		beamProjectile(caster:GetAbsOrigin(), c_d_beamRange, caster, ability, rotatedVector)

		rotatedVector = WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi / 8)
		particleVector = caster:GetAbsOrigin() + Vector(0, 0, 50) + (rotatedVector * c_d_beamRange)
		ParticleManager:SetParticleControl(ability.pfx5, 1, particleVector)
		ParticleManager:SetParticleControl(ability.pfx6, 1, particleVector)
		beamProjectile(caster:GetAbsOrigin(), c_d_beamRange, caster, ability, rotatedVector)
	end
	if ability.r_4_level > 0 then
		local d_d_duration = Filters:GetAdjustedBuffDuration(caster, 15, false)
		ability.r_4_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_r_4_visible", {duration = d_d_duration})
		local current_stack = caster:GetModifierStackCount("modifier_warlord_rune_r_4_visible", ability.r_4_ability)
		local newStack = current_stack + 1
		caster:SetModifierStackCount("modifier_warlord_rune_r_4_visible", ability.r_4_ability, newStack)

		ability.r_4_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_r_4_invisible", {duration = d_d_duration})
		caster:SetModifierStackCount("modifier_warlord_rune_r_4_invisible", ability.r_4_ability, newStack * ability.r_4_level)
	end
end

function beamProjectile(origin, range, caster, ability, fv)
	local start_radius = 290
	local end_radius = 290
	local speed = 10000

	local info =
	{
		Ability = ability,
		EffectName = "particles/econ/generic/generic_projectile_linear_1/generic_projectile_linear_1.vpcf",
		vSpawnOrigin = origin + Vector(0, 0, 30),
		fDistance = range - 80,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_hitloc",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iVisionRadius = 400,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function beamEnd(event)
	local ability = event.ability
	local caster = event.caster
	ParticleManager:DestroyParticle(ability.pfx, false)
	ParticleManager:DestroyParticle(ability.pfx2, false)
	StartAnimation(caster, {duration = 5.0, activity = ACT_DOTA_CAST_WILD_AXES_END, rate = 1})
	if ability.r_3_level > 0 then
		ParticleManager:DestroyParticle(ability.pfx3, false)
		ParticleManager:DestroyParticle(ability.pfx4, false)
		ParticleManager:DestroyParticle(ability.pfx5, false)
		ParticleManager:DestroyParticle(ability.pfx6, false)
	end
	ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
	--signus exception
	if caster:HasModifier("modifier_signus_charm") then
		local baseCd = ability:GetCooldownTimeRemaining()
		ability:EndCooldown()
		baseCd = baseCd * 0.6
		ability:StartCooldown(baseCd)
	end
	for i = 0, 2, 1 do
		local disableAbility = caster:GetAbilityByIndex(i)
		disableAbility:SetActivated(true)
	end
end

function projectileHit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage / 5
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4)
	if ability.r_2_level then
		if ability.r_2_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_warlord_rune_r_2", {duration = 0.5})
			target:SetModifierStackCount("modifier_warlord_rune_r_2", ability, ability.r_2_level)
		end
	end
end

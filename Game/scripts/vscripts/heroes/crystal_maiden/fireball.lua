require('heroes/crystal_maiden/init')
function begin_fireball(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	EmitSoundOn("Sorceress.FireBall.Cast", caster)
	local bArcane = sorceressGetArcaneDB(caster)

	local fireBallStartPosition = caster:GetAbsOrigin()
	if caster:HasModifier("modifier_sorceress_immortal_fire_avatar") then
		caster = caster.origCaster
		ability.rune_r_1_level = caster:GetRuneValue("q", 3)
	end
	launchFireBall(caster, ability, fv, "particles/units/heroes/hero_jakiro/fireball.vpcf", 140, fireBallStartPosition)
	if bArcane then
		launchFireBall(caster, caster:FindAbilityByName("sorceress_blink"), fv, "particles/roshpit/sorceress/arcane_enchantment.vpcf", 90, fireBallStartPosition)
	end
	if caster:HasModifier("modifier_sorceress_glyph_3_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fireball_precast", {duration = 0.5})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fireball_multishot", {duration = 0.4})
		Timers:CreateTimer(0.2, function()
			EmitSoundOn("Sorceress.FireBall.Cast", caster)
			StartAnimation(caster, {duration = 0.18, activity = ACT_DOTA_CAST_ABILITY_2, rate = 3})

			launchFireBall(caster, ability, fv, "particles/units/heroes/hero_jakiro/fireball.vpcf", 140, fireBallStartPosition)
			if bArcane then
				launchFireBall(caster, caster:FindAbilityByName("sorceress_blink"), fv, "particles/roshpit/sorceress/arcane_enchantment.vpcf", 90, fireBallStartPosition)
			end
			Timers:CreateTimer(0.2, function()
				EmitSoundOn("Sorceress.FireBall.Cast", caster)
				StartAnimation(caster, {duration = 0.18, activity = ACT_DOTA_CAST_ABILITY_2, rate = 3})
				launchFireBall(caster, ability, fv, "particles/units/heroes/hero_jakiro/fireball.vpcf", 140, fireBallStartPosition)
				if bArcane then
					launchFireBall(caster, caster:FindAbilityByName("sorceress_blink"), fv, "particles/roshpit/sorceress/arcane_enchantment.vpcf", 90, fireBallStartPosition)
				end
			end)
		end)
	end
	local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "sorceress")
	caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "sorceress")
	if c_d_level > 0 then
		-- local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "sorceress")
		-- damage = damage + 0.0001*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*d_d_level*damage
		sorceress_c_d(caster, target, 280, c_d_level)
	end
	Filters:CastSkillArguments(4, caster)

end

function sorceressGetArcaneDB(caster)
	if caster:HasModifier("modifier_arcane_enchantment") then
		local newStacks = caster:GetModifierStackCount("modifier_arcane_enchantment", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_arcane_enchantment", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_arcane_enchantment")
		end
		return true
	else
		return false
	end
end

function sorceress_c_d(caster, point, radius, runesCount)
	EmitSoundOnLocationWithCaster(point, "Sorceress.NuclearSolosPresound", caster)

	local particleName = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, point)
	ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(particle1, 3, Vector(700, 700, 700))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	local ability = caster:FindAbilityByName("pyroblast")

	Timers:CreateTimer(0.5, function()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for i = 1, #enemies, 1 do
				ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_sorceress_rune_r_3", {duration = SORCERESS_R3_DURATION})
				enemies[i]:SetModifierStackCount("modifier_sorceress_rune_r_3", caster, runesCount)
				Filters:ApplyStun(caster, 0.5, enemies[i])
			end
		end
		EmitSoundOnLocationWithCaster(point, "Sorceress.NuclearSolosHitSound", caster)
		local particleName = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
		local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle2, 0, point)
		ParticleManager:SetParticleControl(particle2, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(particle2, 3, Vector(0, 0, 0))
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle2, false)
		end)
	end)

end

function launchFireBall(caster, ability, fv, projectileParticle, impactRadius, fireBallStartPosition)


	local start_radius = impactRadius
	local end_radius = impactRadius
	local range = 2400
	local speed = 1100
	local casterOrigin = fireBallStartPosition
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = casterOrigin + Vector(0, 0, 100),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_attack2",
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
end

function fireball_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	EmitSoundOn("Hero_Invoker.SunStrike.Ignite", target)

	local damage = 0
	if not ability.rune_r_1_level then
		ability.rune_r_1_level = caster:GetRuneValue("q", 3)
	end
	local damage = ability.rune_r_1_level * R1_ADD_DAMAGE + R1_BASE_DAMAGE

	local blinkAbility = caster:FindAbilityByName("sorceress_blink")
	blinkAbility.w_4_damage = damage
	blinkAbility.baseIndex = 4

	-- local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "sorceress")
	-- damage = damage + 0.0001*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*d_d_level*damage
	local radius = 360
	local pyroblast = caster:FindAbilityByName("pyroblast")
	local b_d_level = caster:GetRuneValue("r", 2)
	if not pyroblast.rune_r_2_level then
		pyroblast.rune_r_2_level = b_d_level
	end

	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 20))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			if b_d_level > 0 then
				applyIgnite(caster, pyroblast, damage, enemy, b_d_level, 2)
			end
		end
	end
	local duration = Filters:GetAdjustedBuffDuration(caster, 8, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fireball_stacks", {duration = 8})
	local stacksCount = caster:GetModifierStackCount("modifier_fireball_stacks", caster)
	local newStacksCount = math.min(R1_MAX_STACKS_COUNT, stacksCount + 1)
	caster:SetModifierStackCount("modifier_fireball_stacks", caster, newStacksCount)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fireball_attackspeed", {duration = duration})
	caster:SetModifierStackCount("modifier_fireball_attackspeed", caster, newStacksCount * ability.rune_r_1_level)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fireball_attack_damage", {duration = duration})
	caster:SetModifierStackCount("modifier_fireball_attack_damage", caster, newStacksCount * damage)
end

function fireball_think(event)
	local caster = event.caster
	local pyroblast = caster:FindAbilityByName("pyroblast")
	if pyroblast:GetCooldownTimeRemaining() < 0.1 then
		caster:RemoveModifierByName("modifier_pyro_cooldown")
	end
end

function applyIgnite(caster, ability, damage, target, b_d_level, duration)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_pyroblast_ignite", {duration = duration})
	local igniteDPS = damage * 0.01 * b_d_level
	if target:HasModifier("modifier_pyroblast_ignite") and target.igniteDPS then
		target.igniteDPS = math.max(target.igniteDPS, igniteDPS)
	else
		target.igniteDPS = igniteDPS
	end
end

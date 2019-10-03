require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/obsidian_destroyer/epoch_1_q')
require('heroes/obsidian_destroyer/epoch_1_q_arcana')
require('heroes/obsidian_destroyer/epoch_glyphs')

function onWarpFire(event)
	local caster = event.caster
	local ability = event.ability
	local e_4_level = caster:GetRuneValue("e", 4)
	ability.e_4_level = e_4_level
	if not caster:HasModifier("modifier_time_warp") then
		if caster:HasModifier("modifier_epoch_glyph_7_1") then
			local glyph_duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_warp_7_1_phased", {duration = glyph_duration})
		end
		ability.orb_distance = 70
		caster:StartGesture(ACT_DOTA_ATTACK)
		ability.forwardVector = caster:GetForwardVector()
		ability.castLocation = caster:GetAbsOrigin()
		local targetPoint = ability.castLocation + ability.forwardVector * 300
		fireOrb(ability:GetLevel(), caster, targetPoint, ability.castLocation, ability, e_4_level)
		EmitSoundOn("Hero_Oracle.FalsePromise.Cast", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_warp", nil)
		if caster:HasModifier("modifier_epoch_immortal_weapon_3") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_no_damage", nil)
		end
		epoch_e_2(caster, ability)
		Filters:CastSkillArguments(3, caster)
		ability:EndCooldown()
	else
		jaunt(ability, caster)
	end
end

function fireOrb(abilityLevel, caster, targetPoint, casterOrigin, ability, e_4_level)
	local dummy = CreateUnitByName("npc_dummy_unit", casterOrigin + ability.forwardVector * 100, true, caster, caster, caster:GetTeamNumber())
	dummy.owner = caster:GetPlayerOwnerID()
	dummy:AddAbility("time_warp_dummy")
	dummy:NoHealthBar()
	dummy:AddAbility("dummy_unit")
	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

	local blast = dummy:FindAbilityByName("time_warp_dummy")
	blast.e_4_level = e_4_level
	blast.origCaster = caster
	blast:SetLevel(abilityLevel)
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blast:GetEntityIndex(),
		Position = targetPoint,
		Queue = true
	}
	ExecuteOrderFromTable(order)
	Timers:CreateTimer(5, function()
		dummy:RemoveSelf()
	end)
end

function fire_main_orb(event)
	local ability = event.ability
	local origCaster = ability.origCaster
	local caster = event.caster
	local speed = event.speed
	local radius = event.radius
	local range = event.range
	local point = event.target_points[1]
	local fv = (point - caster:GetAbsOrigin()):Normalized()
	fv = fv * Vector(1, 1, 0)
	if origCaster:HasModifier("modifier_epoch_glyph_2_1") then
		speed = speed * (100+EPOCH_GLYPH_2_1_E_SPEED_BONUS_PCT)/100
		range = range * (100+EPOCH_GLYPH_2_1_E_DISTANCE_BONUS_PCT)/100
	end
	speed = Filters:GetAdjustedESpeed(origCaster, speed, false)
	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_puck/time_warp.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
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
end

function jaunt(ability, caster)
	--print("jaunt calculated distance:")

	--print(ability.orb_distance)
	if ability.orb_distance then
		ProjectileManager:ProjectileDodge(caster)
		EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Cast", caster)
		local newPosition = ability.castLocation + ability.forwardVector * ability.orb_distance
		newPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), newPosition, caster)
		--particle block
		local particleName = "particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
		local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle2, 0, newPosition)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle1, false)
			ParticleManager:DestroyParticle(particle2, false)
		end)
		--end particle block
		caster:SetAbsOrigin(newPosition)
		caster:RemoveModifierByName("modifier_time_warp_7_1_phased")
		FindClearSpaceForUnit(caster, newPosition, true)
		EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Cast", caster)
		caster:RemoveModifierByName("modifier_time_warp")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_warp_buff", nil)
		epoch_e_1(caster)
		epoch_e_3(caster)
	end
end

function startCooldown(event)
	local ability = event.ability
	local caster = event.caster
	Filters:ReduceECooldown(caster, ability, 7, true)
	caster:RemoveModifierByName("modifier_time_warp_7_1_phased")
end

function getProjectilePosition(event)
	local caster = event.caster
	local ability = event.ability
	local distanceAmount = 23
	if caster:HasModifier("modifier_epoch_glyph_2_1") then
		distanceAmount = distanceAmount * (100+EPOCH_GLYPH_2_1_E_DISTANCE_BONUS_PCT)/100
	end
	distanceAmount = Filters:GetAdjustedESpeed(caster, distanceAmount, false)
	if ability.orb_distance then
		ability.orb_distance = ability.orb_distance + distanceAmount
	else
		ability.orb_distance = distanceAmount
	end
end

function onProjectileHit(event)
	local caster = event.ability.origCaster
	local target = event.target
	local damage = event.damage
	local ability = event.ability
	damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * ability.e_4_level * EPOCH_E4_DMG_MULTI_PCT / 100
	if target:HasModifier("modifier_time_bound") or target:HasModifier("modifier_time_bind") or target:HasModifier("modifier_space_link") or target:HasModifier("modifier_epoch_arcana_root") then
		--print("damage x2!!!")
		damage = damage * 2
		if target:HasModifier("modifier_epoch_immortal_weapon_3") then
			Filters:ApplyStun(caster, EPOCH_IMMORTAL_WEAPON_3_STUN, target)
		end
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)

end

function epoch_e_1(caster)
	local runeUnit = caster.runeUnit
	local ability = runeUnit:FindAbilityByName("epoch_rune_e_1")
	local e_1_level = caster:GetRuneValue("e", 1)
	if e_1_level > 0 then
		local e_1_duration = Filters:GetAdjustedBuffDuration(caster, 0.4 + e_1_level * EPOCH_E1_DURATION, false)
		if caster:HasModifier("modifier_epoch_glyph_2_1") then
			e_1_duration = e_1_duration * EPOCH_GLYPH_2_1_E2_DURATION_AMP
		end
		--print("e_1_duration "..e_1_duration)
		ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_epoch_rune_e_1", {duration = e_1_duration})
	end
end

function epoch_e_3(caster)
	local runeUnit = caster.runeUnit3
	local ability = runeUnit:FindAbilityByName("epoch_rune_e_3")
	local e_3_level = caster:GetRuneValue("e", 3)
	if e_3_level > 0 then
		local c_c_duration = Filters:GetAdjustedBuffDuration(caster, 6, false)
		ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_epoch_rune_e_3", {duration = c_c_duration})
		ability.origCaster = caster
		ability.damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
		ability.e_3_level = e_3_level
	end
end

function epoch_e_3_attack_start(event)
	local target = event.target
	local caster = event.attacker
	local ability = caster.runeUnit3:FindAbilityByName("epoch_rune_e_3")
	event.ability = caster.runeUnit3:FindAbilityByName("epoch_rune_q_3")
	ability.e_3_level = caster:GetRuneValue("e", 3)
	local radius = 600
	local targetPoint = target:GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local projectileCount = 0
	local projectileSpeed = caster:GetProjectileSpeed()
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local projectileEffect = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_base_attack.vpcf"
			local q_3_damage = epoch_q_3_get_damage(caster, caster.runeUnit3)
			if q_3_damage then
				projectileEffect = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
				ability.q_3_damage = q_3_damage
			end
			local info =
			{
				Target = enemy,
				Source = caster,
				Ability = ability,
				EffectName = projectileEffect,
				StartPosition = "attach_attack1",
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = true,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = projectileSpeed,
			iVisionTeamNumber = caster:GetTeamNumber()}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
			projectileCount = projectileCount + 1
			if projectileCount == ability.e_3_level + 2 then
				break
			end
		end
	end
end

function epoch_e_3_projectile_land(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.origCaster
	local damage = ability.damage
	local q_3_damage = ability.q_3_damage
	if caster:HasModifier("modifier_epoch_glyph_5_1") then
		local eventTable = {}
		eventTable.ability = caster.runeUnit2:FindAbilityByName("epoch_rune_w_2")
		eventTable.attacker = caster
		eventTable.target = target
		eventTable.caster = caster
		epoch_glyph_5_1_attack_land(eventTable)
	end
	if caster:HasAbility("epoch_time_binder") and q_3_damage then
		local eventTable = {}
		eventTable.ability = caster.runeUnit3:FindAbilityByName("epoch_rune_q_3")
		eventTable.attacker = caster
		eventTable.target = enemy
		eventTable.caster = caster
		eventTable.damage = q_3_damage
		epoch_q_3_strike(eventTable)
	elseif caster:HasAbility("epoch_arcana_ability") then
		local eventTable = {}
		eventTable.ability = caster:FindAbilityByName("epoch_arcana_ability")
		eventTable.attacker = caster
		eventTable.target = enemy
		eventTable.caster = caster
		arcana_attack(eventTable)
	end
	Filters:ApplyDamageBasic(target, caster, damage, DAMAGE_TYPE_PHYSICAL)
	-- ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
end

function epoch_e_2(caster, ability)
	local runeUnit = caster.runeUnit2
	local e_2_level = caster:GetRuneValue("e", 2)
	if e_2_level > 0 then
		local forwardVector = caster:GetForwardVector()
		local numOrbs = e_2_level * EPOCH_E2_ORBS
		ability.e_2_damage = e_2_level * EPOCH_E2_DMG + EPOCH_E2_DMG_BASE
		if numOrbs > 36 then
			numOrbs = 36
		end
		for i = 0, numOrbs, 1 do
			local rotatedVector = rotateVector(forwardVector, (math.pi / 30) * i)
			epoch_e_2_projectile(caster, ability, caster:GetAbsOrigin(), rotatedVector)
			local rotatedVector = rotateVector(forwardVector, (math.pi / 30) * i *- 1)
			epoch_e_2_projectile(caster, ability, caster:GetAbsOrigin(), rotatedVector)
		end
	end
end

function epoch_e_2_projectile(caster, ability, position, fv)
	local start_radius = 130
	local end_radius = 130
	local speed = 700
	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_alchemist/epoch_rune_a_d_concoction_projectile.vpcf",
		vSpawnOrigin = position + Vector(0, 0, 100),
		fDistance = 1000,
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

end

function epoch_e_2_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability.e_2_damage
	damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * ability.e_4_level * EPOCH_E4_DMG_MULTI_PCT / 100
	if target:HasModifier("modifier_time_bound") or target:HasModifier("modifier_time_bind") or target:HasModifier("modifier_space_link") or target:HasModifier("modifier_epoch_arcana_root") then
		damage = damage * 2
		if caster:HasModifier("modifier_epoch_immortal_weapon_3") then
			Filters:ApplyStun(caster, EPOCH_IMMORTAL_WEAPON_3_STUN, target)
		end
	end
	if damage then
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	end

end

function rotateVector(vector, radians)
	XX = vector.x
	YY = vector.y

	Xprime = math.cos(radians) * XX - math.sin(radians) * YY
	Yprime = math.sin(radians) * XX + math.cos(radians) * YY

	vectorX = Vector(1, 0, 0) * Xprime
	vectorY = Vector(0, 1, 0) * Yprime
	rotatedVector = vectorX + vectorY
	return rotatedVector

end

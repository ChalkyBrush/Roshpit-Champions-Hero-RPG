function winter_spawner_think(event)
	local caster = event.caster
	if not caster.summonTable then
		caster.summonTable = {}
		caster.totalSummons = 0
	end
	local newTable = {}
	for i = 1, #caster.summonTable, 1 do
		if IsValidEntity(caster.summonTable[i]) then
			table.insert(newTable, caster.summonTable[i])
		end
	end
	caster.summonTable = newTable
	local maxSummons = 5
	local loops = 1
	if GameState:GetDifficultyFactor() == 2 then
		maxSummons = 8
	elseif GameState:GetDifficultyFactor() == 3 then
		maxSummons = 12
		loops = 2
	end
	if #caster.summonTable > maxSummons then
		return
	end
	caster.totalSummons = caster.totalSummons + 1
	local itemRoll = 1
	if caster.totalSummons > 12 then
		itemRoll = 0
	end
	local bAggro = false
	if caster.aggro then
		bAggro = true
	end
	StartAnimation(caster, {duration = 1.9, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
	EmitSoundOn("Winterblight.SpawnerSquish", caster)
	Timers:CreateTimer(1.3, function()
		for i = 1, loops, 1 do
			local position = caster.summonCenter + RandomVector(RandomInt(1, 240))
			local zombie = Winterblight:SpawnSpawnerUnit(caster:GetAbsOrigin(), RandomVector(1), itemRoll, bAggro)
			zombie:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 100) + caster:GetForwardVector() * 40)
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * (RandomInt(-10, 10)) / 100)
			WallPhysics:Jump(zombie, fv, RandomInt(4, 16), RandomInt(10, 16), RandomInt(16, 24), 1)
			zombie.jumpEnd = "crab_land"
			if caster.totalSummons > 12 then
				zombie:SetDeathXP(0)
				zombie:SetMaximumGoldBounty(0)
				zombie:SetMinimumGoldBounty(0)
			end
			EmitSoundOn("Winterblight.Crab.Spawn", zombie)
			FindClearSpaceForUnit(zombie, zombie:GetAbsOrigin(), false)
			table.insert(caster.summonTable, zombie)
		end
	end)
end

function winter_spawner_die(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite_snow_explode.vpcf", caster, 3)
end

function ogre_armor_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	if not caster.hits then
		caster.hits = 0
	end
	if not caster.pfxCount then
		caster.pfxCount = 0
	end
	if caster.pfxCount < 6 then
		caster.pfxCount = caster.pfxCount + 1
		CustomAbilities:QuickAttachParticle("particles/neutral_fx/ogre_magi_frost_armor_b.vpcf", caster, 0.5)
		Timers:CreateTimer(1, function()
			caster.pfxCount = caster.pfxCount - 1
		end)
	end
	caster.hits = caster.hits + 1
	if caster.hits == event.hits_for_counter then
		caster.hits = 0
		EmitSoundOn("Winterblight.OgreShield.Launch", caster)
		local fv = ((attacker:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		local info =
		{
			Ability = ability,
			EffectName = "particles/roshpit/winterblight/ogre_retaliation.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 50),
			fDistance = 1500,
			fStartRadius = 150,
			fEndRadius = 300,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * 1000,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function ogre_armor_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.OgreArmorImpact", target)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	Filters:ApplyStun(caster, event.stun_duration, target)
end

function monolith_found_enemy(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not caster.activated then
		EmitSoundOn("Winterblight.Monolith.Detect", caster)
		caster.actived = true
		Winterblight:smoothColorTransition(caster, Vector(255, 255, 255), Vector(200, 200, 255), 20)
		Timers:CreateTimer(0.6, function()
			Winterblight:objectShake(caster, 80, 5.2, true, false, false, "Winterblight.Monolith.Shake", 10)
			Timers:CreateTimer(3.05, function()
				CustomAbilities:QuickParticleAtPoint("particles/world_tower/tower_upgrade/ti7_radiant_tower_lvl2_dest.vpcf", caster:GetAbsOrigin(), 6)
				local raxxus = Winterblight:SpawnRaxxus(caster:GetAbsOrigin(), caster:GetForwardVector())
				raxxusAbility = raxxus:FindAbilityByName("winterblight_raxxus_passive")
				raxxusAbility:ApplyDataDrivenModifier(raxxus, raxxus, "modifier_disable_player", {duration = 2.4})
				StartAnimation(raxxus, {duration = 2.4, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.9})
				EmitSoundOn("Winterblight.Monolith.Dest", caster)
				caster.aggroLock = true
				for i = 0, 3, 1 do
					local position = caster:GetAbsOrigin()
					Timers:CreateTimer(0.1 * i, function()
						local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(pfx, 0, position + Vector(0, 0, 80))
						ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
						ParticleManager:SetParticleControl(pfx, 2, Vector(0.8, 0.8, 0.8))
						Timers:CreateTimer(10, function()
							ParticleManager:DestroyParticle(pfx, false)
							ParticleManager:ReleaseParticleIndex(pfx)
						end)
					end)
				end
				Timers:CreateTimer(2.4, function()
					caster.aggroLock = false
					Dungeons:AggroUnit(raxxus)
				end)
				Timers:CreateTimer(0.1, function()
					EmitSoundOn("Winterblight.Raxxus.Intro", raxxus)
					UTIL_Remove(caster)
				end)
			end)
		end)
	end
end

function raxxus_attack_land(event)
	local caster = event.caster
	local victim = event.target
	local ability = event.ability
	local damage = event.damage
	local icePoint = victim:GetAbsOrigin()
	local radius = 240
	EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, icePoint)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frostburn_gauntlets_slow", {duration = 3})
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		end
	end
end

function wb_bandit_jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1]
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance / 20
	ability.liftVelocity = 20
	local heightDiff = 0
	ability.liftVelocity = ability.liftVelocity - heightDiff / 20
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	ability.interval = 0
	if not event.special then
		StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
		EmitSoundOn("Winterblight.Assassin.Aggro", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Assassin.Jump", caster)
		if caster:HasModifier("modifier_machinal_jump_freecast") then
			ability:EndCooldown()
			local newStacks = caster:GetModifierStackCount("modifier_machinal_jump_freecast", caster) - 1
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_machinal_jump_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_machinal_jump_freecast")
			end
		end
		if caster:HasAbility("arkimus_energy_field") then
			local energyField = caster:FindAbilityByName("arkimus_energy_field")
			if energyField.rotationDelta then
				energyField.rotationDelta = math.max(14, energyField.rotationDelta - 4)
			end
		end
	end
	ability.e_1_level = 0
	ability.e_3_level = 0
end

function jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV
	-- if distance < 60 then
	-- fv = Vector(0,0)
	-- end
	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
		if not ability.rising then
			caster:RemoveModifierByName("modifier_machinal_jump")
		end
	end

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.jumpFV * 30), caster)
	if blockUnit then
		fv = Vector(0, 0)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + fv * ability.jumpVelocity + Vector(0, 0, ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 2
	if ability.liftVelocity <= 0 then
		ability.rising = false
	end
	ability.interval = ability.interval + 1
	if ability.interval % 3 == 0 then
		local pfx = ParticleManager:CreateParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(0.4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function jump_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
	if ability.e_1_level > 0 then
		local searchRadius = 300 + ability.e_1_level * 2
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 0.3 * ability.e_1_level

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				CreateZonisBeam(caster:GetAbsOrigin(), enemy:GetAbsOrigin() + Vector(0, 0, 50))
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zonis_stun", {duration = 0.2})
				Filters:ApplyStun(caster, 0.2, enemy)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_ARCANE, RPC_ELEMENT_LIGHTNING)
			end
		else
			for i = 1, 3, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / 3)
				CreateZonisBeam(caster:GetAbsOrigin(), caster:GetAbsOrigin() + fv * 120 + Vector(0, 0, 60))
			end
		end
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.JumpLightning", caster)
	end
	if ability.e_3_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump_c_c_amp", {duration = duration})
		caster:SetModifierStackCount("modifier_machinal_jump_c_c_amp", caster, ability.e_3_level)
	end
end

function mountain_assassin_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local jumpAbility = caster:FindAbilityByName("assassin_jump")
		if jumpAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local targetPoint = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(60, 320))

				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = jumpAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		if not caster:HasModifier("modifier_machinal_jump") then
			if caster:HasAbility("assassin_charge_blast") then
				local chargeBlast = caster:FindAbilityByName("assassin_charge_blast")
				if chargeBlast:IsFullyCastable() then
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						local targetPoint = enemies[1]:GetAbsOrigin()
						caster.lockOnTarget = enemies[1]
						local order =
						{
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							AbilityIndex = chargeBlast:entindex(),
							Position = targetPoint
						}
						ExecuteOrderFromTable(order)
						return false
					end
				end
			end
		end
	end

end

function mountain_assassin_init(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local chargeBlast = caster:FindAbilityByName("assassin_charge_blast")
		chargeBlast:StartCooldown(7)
		if GameState:GetDifficultyFactor() == 1 then
			caster:RemoveAbility("assassin_charge_blast")
		end
	end
end

function begin_mystic_wave(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = event.range

	StartAnimation(caster, {duration = 1.4, activity = ACT_DOTA_ATTACK, rate = 0.9})
	EmitSoundOn("Winterblight.Assassin.CastVO", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Assassin.Projectile", caster)
	local fv = caster:GetForwardVector()
	local startPoint = caster:GetAbsOrigin()
	local particle = "particles/base_attacks/majinaq_linear.vpcf"
	local start_radius = 340
	local end_radius = 340
	local range = range

	local speed = 900

	-- EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)

	local casterOrigin = caster:GetAbsOrigin()

	local info =
	{
		Ability = ability,
		EffectName = particle,
		vSpawnOrigin = startPoint + Vector(0, 0, 80),
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

	local a_a_duration = 3
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_protector_a_a_buff", {duration = a_a_duration})
end

function winter_mystic_wave_impact(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local baseDamage = damage
	local ability = event.ability
	local stunDuration = 0.5

	local damage = baseDamage
	if target:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_mystic_wave_flail", {duration = stunDuration})
		Filters:ApplyStun(caster, stunDuration, target)
		local particleName = "particles/econ/events/winter_major_2017/dagon_wm07.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(1.0, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local manaBurn = math.min(event.mana_burn, target:GetMana())
		target:ReduceMana(manaBurn)
		damage = damage + manaBurn
		EmitSoundOn("Winterblight.Assassin.ManaBurn", target)
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
	

end

function mystic_wave_phase_start(event)
	local caster = event.caster
	local ability = event.ability
	-- EmitSoundOn("Winterblight.Assassin.Aggro", caster)
end

function mystic_wave_casting_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lockOnTarget then
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.lockOnTarget:GetAbsOrigin())
		if distance < 1500 then
			local fv = ((caster.lockOnTarget:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			caster:SetForwardVector(fv)
		end
	end
end

function beetle_underground_think(event)
	local caster = event.caster
	if caster.aggro then
		local particleName = "particles/roshpit/winterblight/snow_impact.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		Timers:CreateTimer(0.03, function()
			EmitSoundOn("Winterblight.MountainBeetle.Unburrow", caster)
		end)
		caster:RemoveModifierByName("modifier_ice_beast_ai")
		caster:RemoveModifierByName("modifier_cave_shroom_ai")
		StartAnimation(caster, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shroom_jumping", {duration = 0.74})
		local position = caster:GetAbsOrigin()
		caster.liftVelocity = 21
		for i = 1, 28, 1 do
			Timers:CreateTimer(0.03 * i, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.liftVelocity))
				caster.liftVelocity = caster.liftVelocity - 1.5
			end)
		end
		Timers:CreateTimer(0.84, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end
end

function ice_crystal_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.strikes then
		caster.strikes = 0
	end
	if caster.strikes >= 3 then
		return false
	end
	caster.strikes = caster.strikes + 1
	caster:SetRenderColor(caster.startingBlue - caster.strikes * 20, caster.startingBlue - caster.strikes * 20, 255)
	CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/mark_of_the_talon_heal.vpcf", caster, 0.3)
	EmitSoundOn("Winterblight.IceCrystal.Hit", caster)
	if caster.strikes == 3 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_attackable_unit_no_more_attacks", {})
		Winterblight:objectShake(caster, 15, 15, true, true, true, nil, 4)
		Timers:CreateTimer(0.5, function()
			local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)

			ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle1, 1, Vector(300, 2, 1000))
			ParticleManager:SetParticleControl(particle1, 3, Vector(300, 550, 550))
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(particle1, false)
			end)
			CustomAbilities:QuickAttachParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_c_ti5.vpcf", caster, 2)
			local position = caster:GetAbsOrigin()
			EmitSoundOn("Winterblight.IceCrystal.Shatter", caster)
			for i = 1, 6, 1 do
				local spawnPos = position + WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / 8) * 8
				local ice = Winterblight:SpawnLivingIce(position, (spawnPos - position):Normalized())
				local particleName = "particles/roshpit/winterblight/snow_impact.vpcf"
				local snowparticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(snowparticle, 0, ice:GetAbsOrigin())
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(snowparticle, false)
				end)
				EmitSoundOn("Winterblight.IceCrystal.Spawn", ice)
				StartAnimation(ice, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1.4})
				local iceAbil = ice:FindAbilityByName("winterblight_ice_magic_immune_ability")
				local iceImmuneDuration = 1 + 0.3 * GameState:GetDifficultyFactor()
				iceAbil:ApplyDataDrivenModifier(ice, ice, "modifier_black_King_bar_immunity", {duration = iceImmuneDuration})
				if GameState:GetDifficultyFactor() >= 3 then
					local luck = RandomInt(1, 8)
					if luck == 1 then
						ice:AddAbility("creature_pure_strike"):SetLevel(GameState:GetDifficultyFactor())
					end
				end
			end
			if not Winterblight.IceShatters then
				Winterblight.IceShatters = 0
			end
			Winterblight.IceShatters = Winterblight.IceShatters + 1
			caster:ClearParticles()
			UTIL_Remove(caster)
			if Winterblight.IceShatters == 18 then
				Winterblight:ShatterIceWall()
			end
		end)
	end
end

function crystal_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = RandomInt(0, 89)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 5) * math.cos(2 * math.pi * caster.interval / 90))
	caster.interval = caster.interval + 1
	local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 90)
	caster:SetForwardVector(rotatedFV)
	if caster.interval == 90 then
		caster.interval = 0
	end
end

function wb_volcanic_glissade(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]

	ability.targetPoint = target
	if caster:GetUnitName() == "winterblight_bladewielder" then
		EmitSoundOn("Winterblight.BladeWielder.Aggro", caster)
	else
		EmitSoundOn("Winterblight.MountainDweller.Charge", caster)
	end
	EmitSoundOn("Winterblight.MountainGlissade", caster)
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_VERSUS, rate = 2})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_volcanic_glissade", {duration = 1.6})
	local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)

	ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle1, 1, Vector(200, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(200, 550, 550))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	if ability.beamPFX then
		ParticleManager:DestroyParticle(ability.beamPFX, false)
	end
	ability.beamPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(ability.beamPFX, 0, caster:GetAbsOrigin() + Vector(0, 0, 90))
	Filters:CastSkillArguments(3, caster)
	local glyphFreeCast = false
	local luck = RandomInt(1, 5 - GameState:GetDifficultyFactor())
	if luck == 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_glissade_freecast", {})
		caster:SetModifierStackCount("modifier_glissade_freecast", caster, 1)
	end
	if caster:HasModifier("modifier_glissade_freecast") then
		if not glyphFreeCast then
			local newStacks = caster:GetModifierStackCount("modifier_glissade_freecast", caster) - 1
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_glissade_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_glissade_freecast")
			end
		end
		ability:EndCooldown()
	else
		if not glyphFreeCast then

		else
			ability:EndCooldown()
		end
	end
end

function wb_glissade_thinking(event)
	local ability = event.ability
	local caster = event.caster

	local movementVector = ((ability.targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 1)):Normalized()
	local movespeed = 60

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + caster:GetForwardVector() * movespeed), caster)
	if blockUnit then
		movespeed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + movementVector * movespeed)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), ability.targetPoint)
	if ability.beamPFX then
		ParticleManager:SetParticleControl(ability.beamPFX, 1, caster:GetAbsOrigin() + Vector(0, 0, 90))
	end
	if distance <= 60 or blockUnit then
		caster:RemoveModifierByName("modifier_volcanic_glissade")
		EndAnimation(caster)
		local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)

		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle1, 1, Vector(200, 2, 1000))
		ParticleManager:SetParticleControl(particle1, 3, Vector(200, 550, 550))
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		EmitSoundOn("Winterblight.MountainGlissade.End", caster)
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		Timers:CreateTimer(0.06, function()
			if ability.beamPFX then
				local destroyPFX = ability.beamPFX
				ability.beamPFX = false
				Timers:CreateTimer(0.5, function()
					ParticleManager:DestroyParticle(destroyPFX, false)
				end)
			end
		end)
	end

end

function mountain_dweller_think(event)
	local caster = event.caster
	local ability = event.ability
	if not IsValidEntity(ability) then
		caster:RemoveModifierByName("modifier_mountain_dweller_passive")
		return false
	end
	if not caster.regenLock then
		ability:ApplyDataDrivenModifier(caster, caster, event.modifierName, {})
	end

	caster.regenLock = false
	if caster.aggro then
		local castAbility = caster:FindAbilityByName("mountain_glissade")
		if caster.castLock then
			return false
		end
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(0, 500))
				if caster:GetHealth() < caster:GetMaxHealth() * 0.35 then
					castPoint = caster:GetAbsOrigin() + (((caster:GetAbsOrigin() - enemies[1]:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()) * RandomInt(300, 800)
				end
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function mountain_dweller_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	caster.regenLock = true
	caster:RemoveModifierByName(event.modifierName)
end

function frostiok_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		EmitSoundOn("Winterblight.Frostiok.Passive", caster)
		for _, enemy in pairs(enemies) do
			local info =
			{
				Target = enemy,
				Source = caster,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 8,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 500,
			iVisionTeamNumber = caster:GetTeamNumber()}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function frostiok_ice_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Winterblight.Frostiok.PassiveImpact", target)
	local damage = event.damage
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})

	ability:ApplyDataDrivenModifier(caster, target, "modifier_frostiok_damage_amp", {duration = 6})

	local buff = target:FindModifierByName("modifier_frostiok_damage_amp")
	local newStacks = target:GetModifierStackCount("modifier_frostiok_damage_amp", buff:GetCaster()) + 1
	target:SetModifierStackCount("modifier_frostiok_damage_amp", buff:GetCaster(), newStacks)
end

function colossus_slam_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.ChillingColossus.WindUp", caster)
	StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_CAST_ABILITY_5, rate = 0.9})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_barnacle_ground_slam", {duration = 1.6})
	Timers:CreateTimer(0.6, function()
		local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 210
		local radius = 540
		local splitEarthParticle = "particles/roshpit/winterblight/frost_colossus_slam.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		EmitSoundOn("Winterblight.ChillingColossus.Slam", caster)
		ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
		-- FindClearSpaceForUnit(caster, position, false)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
				enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 1.5})
			end
		end
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
end

function frost_colossus_init(event)
	local caster = event.caster
	local ability = event.ability
	local stacks = event.stacks
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_frostiok_immunity_stacks", {})
	caster:SetModifierStackCount("modifier_frostiok_immunity_stacks", caster, stacks)

end

function colossus_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_colossus_restore") then
		return false
	end
	if caster:GetHealth() < 2000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_colossus_restore", {duration = 7})
		EmitSoundOn("Winterblight.Restore", caster)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_borealis.vpcf", caster, 3)
		local newStacks = caster:GetModifierStackCount("modifier_frostiok_immunity_stacks", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_frostiok_immunity_stacks", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_frostiok_immunity_stacks")
		end
	end
end

function colossus_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.Colossus.Death", caster)
end

function purging_ice_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.Norgok.PurgingBoltHit", target)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})

	local modifiers = target:FindAllModifiers()
	for i = 1, #modifiers, 1 do
		local modifier = modifiers[i]
		local modifierMaker = modifier:GetCaster()
		if modifierMaker:GetEntityIndex() == target:GetEntityIndex() or modifierMaker:GetEntityIndex() == target.InventoryUnit:GetEntityIndex() then
			local durationRemaining = modifier:GetRemainingTime()
			if durationRemaining > 0 then
				target:RemoveModifierByName(modifier:GetName())
			end
		end
	end
end

function norgok_think(event)
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_luna/luna_lucent_beam_impact_shared.vpcf"
	local damage = event.damage
	if not caster:IsAlive() then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if not ability.interval then
		ability.interval = 0
	end
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_luna/luna_lucent_beam_impact_shared.vpcf", enemy, 0.5)
			ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin())
			EmitSoundOn("Winterblight.Norgok.PassiveHit", enemy)
		end
	end
	ability.interval = ability.interval + 1
	if caster.aggro then
		if ability.interval > 120 then
			ability.interval = 0
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chieftain_buff", {duration = 5})
		end
	end
end

function norgok_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.Norgok.Die", caster)
	Timers:CreateTimer(3, function()
		Winterblight:StartCaveWaves()
	end)
	CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", caster, 5)
	if Winterblight.Stones > 0 then
		local luck = RandomInt(1, 4)
		if luck == 1 then
			Timers:CreateTimer(5, function()
				Winterblight:SpawnGrandStalacorr(Vector(1899, -4411), RandomVector(1))
			end)
		end
	end
end

function iceSprintStart(event)
	local caster = event.caster
	local ability = event.ability
	ability.forwardVec = caster:GetForwardVector()
	ability.interval = 0
	StartAnimation(caster, {duration = event.duration, activity = ACT_DOTA_RUN, rate = 1.2, translate = "haste"})
	-- rune_e_2(caster, ability)
	local level = ability:GetLevel()
	caster:MoveToPosition(caster:GetAbsOrigin() + ability.forwardVec * (level / 0.03) * 25)
end

function iceSprintThink(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()

	ability.interval = ability.interval + 1
	position = GetGroundPosition(position, caster)

	local obstruction = WallPhysics:FindNearestObstruction(position)
	local newPosition = position + caster:GetForwardVector() * 25
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (position + caster:GetForwardVector() * 95), caster)
	if ability.interval % 3 == 0 then
		local baseDamage = event.damage
		iceSprintBlast(caster, newPosition, event.radius, baseDamage, ability)
	end
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end
end

function iceSprintEnd(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	if not caster:IsChanneling() then
		caster:Stop()
	end
	FindClearSpaceForUnit(caster, position, false)
end

function iceSprintBlast(caster, position, radius, damage, ability)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_sprint_slow", {duration = 3})
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	end
end

function autumn_mage_blink_start(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/act_2/blob_launch_impact_hit_smoke.vpcf", caster, 3)

end

function autumn_blink_debuff_end(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.IceBlink", caster)

	local particleName = "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	local target = caster:GetAbsOrigin() + RandomVector(RandomInt(560, 1000))
	local casterOrigin = caster:GetAbsOrigin()
	target = WallPhysics:WallSearch(casterOrigin, target, caster)
	-- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
	--     ParticleManager:SetParticleControl( pfx, 0, position )
	local newPosition = target
	FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function sea_fortress_summon_ability(event)
	local caster = event.caster
	local ability = event.ability
	local loops = 1
	if not caster.summonCount then
		caster.summonCount = 0
	end
	if caster.summons then
		loops = caster.summons
	end
	if not caster.maxSummons then
		caster.maxSummons = 2
	end
	local summoned = false
	if caster:GetUnitName() == "azalea_grave_summoner" then
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_RAZE_2, rate = 1.2})
	end
	for i = 1, loops, 1 do
		if caster.summonCount < caster.maxSummons then
			summoned = true
			local spider = nil
			if caster:GetUnitName() == "winterblight_ice_summoner" then
				spider = Winterblight:SpawnIceSummon(caster:GetAbsOrigin() + RandomVector(RandomInt(100, 260)), caster:GetForwardVector(), caster, caster.aggro)
				CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite_snow_explode.vpcf", spider, 3)
			elseif caster:GetUnitName() == "azalea_grave_summoner" then
				spider = Winterblight:SpawnBlueGargoyle(caster:GetAbsOrigin() + RandomVector(RandomInt(100, 260)), caster:GetForwardVector(), caster, caster.aggro)
				CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite_snow_explode.vpcf", spider, 3)
			end
			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 140), spider:GetAbsOrigin() + Vector(0, 0, 60), "particles/units/heroes/hero_wisp/wisp_tether_agh.vpcf", 0.9)
			spider.origCaster = caster
			caster.summonCount = caster.summonCount + 1
			spider:AddAbility("winterblight_enemy_summon"):SetLevel(1)
			StartAnimation(spider, {duration = 0.5, activity = ACT_DOTA_DISABLED, rate = 1.1})
		end
	end
	if summoned then
		if caster:GetUnitName() == "winterblight_ice_summoner" then
			StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
			EmitSoundOn("Winterblight.IceSummon", caster)
		end
	end
end

function enemy_summon_start(event)
	local caster = event.caster
	local ability = event.ability

	caster:SetDeathXP(0)
	caster:SetMinimumGoldBounty(0)
	caster:SetMaximumGoldBounty(0)
end

function enemy_summon_die(event)
	local caster = event.caster
	local ability = event.ability
	caster.origCaster.summonCount = caster.origCaster.summonCount - 1
end

function blade_jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1]
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance / 18
	ability.liftVelocity = 15
	local heightDiff = 0
	ability.liftVelocity = ability.liftVelocity - heightDiff / 25
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	ability.interval = 0
	if not event.special then
		StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_FLAIL, rate = 1, translate = "forcestaff_friendly"})
		EmitSoundOn("Winterblight.BladeDancer.JumpVO", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.BladeDancer.Jump", caster)
		if caster:HasModifier("modifier_machinal_jump_freecast") then
			ability:EndCooldown()
			local newStacks = caster:GetModifierStackCount("modifier_machinal_jump_freecast", caster) - 1
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_machinal_jump_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_machinal_jump_freecast")
			end
		end
	end
	ability.e_1_level = 0
	ability.e_3_level = 0
end

function blade_jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV
	-- if distance < 60 then
	-- fv = Vector(0,0)
	-- end
	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
		if not ability.rising then
			caster:RemoveModifierByName("modifier_machinal_jump")
		end
	end

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.jumpFV * 30), caster)
	if blockUnit then
		fv = Vector(0, 0)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + fv * ability.jumpVelocity + Vector(0, 0, ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 2
	if ability.liftVelocity <= 0 then
		ability.rising = false
	end
	ability.interval = ability.interval + 1
	-- if ability.interval%3 == 0 then
	-- local pfx = ParticleManager:CreateParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_CUSTOMORIGIN, caster)
	-- ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	-- Timers:CreateTimer(0.4, function()
	-- ParticleManager:DestroyParticle(pfx, false)
	-- end)
	-- end
end

function blade_jump_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
	local pfx = ParticleManager:CreateParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(0.4, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 0.9})
	Timers:CreateTimer(0.1, function()
		EmitSoundOn("Winterblight.BladeDancer.Shockwave", caster)
		caster:AddNewModifier(caster, nil, "modifier_animation", {translate = "walk"})
		caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "walk"})
		local fv = caster:GetForwardVector()
		local info =
		{
			Ability = ability,
			EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = 1500,
			fStartRadius = 140,
			fEndRadius = 140,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * 800,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end)
end

function challenger19ai(event)
	local caster = event.caster
	local abiility = event.ability
	local blinkAbility = caster:FindAbilityByName("arena_phantom_strike")
	local luck = RandomInt(1, 4)
	local range = GameState:GetDifficultyFactor() * 250 + 300
	if luck == 1 then
		if blinkAbility and blinkAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = blinkAbility:entindex(),
				TargetIndex = enemies[1]:entindex()}

				ExecuteOrderFromTable(newOrder)
			end
			return
		end
	end
	local luck = RandomInt(1, 5 - GameState:GetDifficultyFactor())
	if luck == 1 then
		local stifling = caster:FindAbilityByName("arena_stifling_dagger")
		if stifling and stifling:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local distance = WallPhysics:GetDistance(enemies[1]:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
				if distance > 300 then
					local castPoint = enemies[1]:GetAbsOrigin()
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = stifling:entindex(),
					TargetIndex = enemies[1]:entindex()}

					ExecuteOrderFromTable(newOrder)
					return
				end
			end
		end
	end
end

function winterblight_wave_unit_die(event)
	local unit = event.unit
	if unit.deathCode == 1 then
		if not Winterblight.CaveUnitsSlain then
			Winterblight.CaveUnitsSlain = 0
		end
		Winterblight.CaveUnitsSlain = Winterblight.CaveUnitsSlain + 1
		--print(Winterblight.CaveUnitsSlain)
		if Winterblight.CaveUnitsSlain == 34 then
			local delay = 1.2 - 0.15 * GameState:GetDifficultyFactor()
			for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
				local unitName = ""
				local luck = RandomInt(1, 2)
				if luck == 1 then
					unitName = "winterblight_ice_satyr"
				elseif luck == 2 then
					unitName = "winterblight_void_spawn"
				end
				if i == 1 or i == 3 then
					unitName = "winterblight_icetaur"
				end
				Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 12, delay, true)
			end
		elseif Winterblight.CaveUnitsSlain == 69 then
			local delay = 1.2 - 0.15 * GameState:GetDifficultyFactor()
			for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
				local unitName = ""
				if i == 1 then
					unitName = "winterblight_seal"
				elseif i == 2 then
					unitName = "winterblight_snow_crab"
				else
					unitName = "winterblight_mountain_ogre"
				end
				Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 14, delay, true)
			end
		elseif Winterblight.CaveUnitsSlain == 111 then
			local delay = 1.2 - 0.15 * GameState:GetDifficultyFactor()
			for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
				Winterblight:SpawnCaveWaveUnit("winterblight_frostbite_spiderling", Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 15, delay, true)
			end
		elseif Winterblight.CaveUnitsSlain == 155 then
			local delay = 1.2 - 0.15 * GameState:GetDifficultyFactor()
			for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
				local luck = RandomInt(1, 3)
				local unitName = ""
				if luck == 1 then
					unitName = "winterblight_frostbite_spiderling"
				elseif luck == 2 then
					unitName = "mountain_assassin"
				else
					unitName = "aggressive_monster"
				end
				Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 13, delay, true)
			end
		elseif Winterblight.CaveUnitsSlain == 194 then
			local delay = 1.2 - 0.15 * GameState:GetDifficultyFactor()
			for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
				local luck = RandomInt(1, 6)
				local unitName = ""
				if luck == 1 then
					unitName = "winterblight_frostbite_spiderling"
				elseif luck == 2 then
					unitName = "winterblight_ice_satyr"
				elseif luck == 3 then
					unitName = "aggressive_monster"
				elseif luck == 4 then
					unitName = "winterblight_wolf"
				elseif luck == 5 then
					unitName = "winterblight_living_ice"
				elseif luck == 6 then
					unitName = "winterblight_icetaur"
				end
				Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 13, delay, true)
			end
		elseif Winterblight.CaveUnitsSlain == 223 then
			local delay = 1.2 - 0.15 * GameState:GetDifficultyFactor()
			for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
				local luck = RandomInt(1, 7)
				local unitName = ""
				if luck == 1 then
					unitName = "winterblight_frostbite_spiderling"
				elseif luck == 2 then
					unitName = "winterblight_ice_satyr"
				elseif luck == 3 then
					unitName = "winterblight_ice_satyr"
				elseif luck == 4 then
					unitName = "winterblight_void_spawn"
				elseif luck == 5 then
					unitName = "winterblight_living_ice"
				elseif luck == 6 then
					unitName = "winterblight_icetaur"
				elseif luck == 7 then
					unitName = "frostiok"
				end
				Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 13, delay, true)
			end
		elseif Winterblight.CaveUnitsSlain == 252 then
			if GameState:GetDifficultyFactor() == 1 then
				Winterblight:FinishCaveWaves()
			else
				local delay = 1.3 - 0.15 * GameState:GetDifficultyFactor()
				for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
					local luck = RandomInt(1, 7)
					local unitName = ""
					if luck == 1 then
						unitName = "winterblight_frostbite_spiderling"
					elseif luck == 2 then
						unitName = "winterblight_icewrack_marauder"
					elseif luck == 3 then
						unitName = "winterblight_ice_satyr"
					elseif luck == 4 then
						unitName = "winterblight_summon_a"
					elseif luck == 5 then
						unitName = "winterblight_dashing_swordsman"
					elseif luck == 6 then
						unitName = "winterblight_winterbear"
					elseif luck == 7 then
						unitName = "frostiok"
					end
					Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 13, delay, true)
				end
			end
		elseif Winterblight.CaveUnitsSlain == 281 then
			if GameState:GetDifficultyFactor() > 1 then
				local delay = 1.3 - 0.15 * GameState:GetDifficultyFactor()
				for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
					local luck = RandomInt(1, 7)
					local unitName = ""
					if luck == 1 then
						unitName = "winterblight_frigid_growth"
					elseif luck == 2 then
						unitName = "winterblight_icewrack_marauder"
					elseif luck == 3 then
						unitName = "winterblight_ice_satyr"
					elseif luck == 4 then
						unitName = "winterblight_summon_a"
					elseif luck == 5 then
						unitName = "winterblight_dashing_swordsman"
					elseif luck == 6 then
						unitName = "winterblight_winterbear"
					elseif luck == 7 then
						unitName = "frostiok"
					end
					Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 13, delay, true)
				end
			end
		elseif Winterblight.CaveUnitsSlain == 320 then
			if GameState:GetDifficultyFactor() > 1 then
				Winterblight:FinishCaveWaves()
			end
		end
	elseif unit.deathCode == 2 then
		if not Winterblight.AzaleaOrbWaveUnitsSlain then
			Winterblight.AzaleaOrbWaveUnitsSlain = 0
		end
		Winterblight.AzaleaOrbWaveUnitsSlain = Winterblight.AzaleaOrbWaveUnitsSlain + 1
		if Winterblight.AzaleaOrbWaveUnitsSlain == 48 then
			Winterblight.OrbTable = WallPhysics:ShuffleTable(Winterblight.OrbTable)
			for i = 1, #Winterblight.OrbTable, 1 do
				Timers:CreateTimer(i * 0.3, function()
					local orb = Winterblight.OrbTable[i]
					Winterblight:SpawnAzaleaWaveUnit("winterblight_puck", orb.endPos, 1, 12, true)
				end)
			end
		elseif Winterblight.AzaleaOrbWaveUnitsSlain == 76 then
			Winterblight.OrbTable = WallPhysics:ShuffleTable(Winterblight.OrbTable)
			for i = 1, #Winterblight.OrbTable, 1 do
				Timers:CreateTimer(i * 0.3, function()
					local orb = Winterblight.OrbTable[i]
					Winterblight:SpawnAzaleaWaveUnit("frost_whelpling", orb.endPos, 1, 12, true)
				end)
			end
		elseif Winterblight.AzaleaOrbWaveUnitsSlain == 106 then
			Winterblight.OrbTable = WallPhysics:ShuffleTable(Winterblight.OrbTable)
			for i = 1, #Winterblight.OrbTable, 1 do
				Timers:CreateTimer(i * 0.3, function()
					local orb = Winterblight.OrbTable[i]
					local unitName = "winterblight_frost_creep"
					if i % 10 == 0 then
						unitName = "winterblight_frost_frigid_hulk"
					end
					Winterblight:SpawnAzaleaWaveUnit(unitName, orb.endPos, 2, 10 - GameState:GetDifficultyFactor(), true)
				end)
			end
		elseif Winterblight.AzaleaOrbWaveUnitsSlain == 166 then
			Winterblight.OrbTable = WallPhysics:ShuffleTable(Winterblight.OrbTable)
			local nameTable = {"winterblight_azalean_priest", "winterblight_frost_elemental", "winterblight_frost_avatar", "winterblight_azure_sorceress", "winterblight_rider_of_azalea", "winterblight_winterbear", "winterblight_mistral_assassin", "winterblight_azalea_archer"}
			local name1 = nameTable[RandomInt(1, #nameTable)]
			local name2 = nameTable[RandomInt(1, #nameTable)]
			local name3 = nameTable[RandomInt(1, #nameTable)]
			for i = 1, #Winterblight.OrbTable, 1 do
				Timers:CreateTimer(i * 0.5, function()
					local orb = Winterblight.OrbTable[i]
					local unitName = "winterblight_frost_creep"
					if i % 3 == 0 then
						unitName = name1
					elseif i % 3 == 1 then
						unitName = name2
					elseif i % 3 == 2 then
						unitName = name3
					end
					Winterblight:SpawnAzaleaWaveUnit(unitName, orb.endPos, 1, 10, true)
				end)
			end
		elseif Winterblight.AzaleaOrbWaveUnitsSlain == 196 then
			Winterblight.OrbTable = WallPhysics:ShuffleTable(Winterblight.OrbTable)
			for i = 1, #Winterblight.OrbTable, 1 do
				Timers:CreateTimer(i * 0.3, function()
					local orb = Winterblight.OrbTable[i]
					local unitName = "winterblight_frost_creep"
					if i % 3 == 0 then
						unitName = "winterblight_puck"
					elseif i % 3 == 1 then
						unitName = "frost_whelpling"
					elseif i % 3 == 2 then
						unitName = "winterblight_dimension_walker"
					end
					Winterblight:SpawnAzaleaWaveUnit(unitName, orb.endPos, 2, 12, true)
				end)
			end
		elseif Winterblight.AzaleaOrbWaveUnitsSlain == 256 then
			Winterblight.OrbTable = WallPhysics:ShuffleTable(Winterblight.OrbTable)
			local nameTable = {"winterblight_azalean_priest", "winterblight_frost_elemental", "winterblight_frost_avatar", "winterblight_azure_sorceress", "winterblight_rider_of_azalea", "winterblight_winterbear", "winterblight_mistral_assassin", "winterblight_frost_frigid_hulk", "winterblight_azalea_archer"}
			local name1 = nameTable[RandomInt(1, #nameTable)]
			local name2 = nameTable[RandomInt(1, #nameTable)]
			local name3 = nameTable[RandomInt(1, #nameTable)]
			for i = 1, #Winterblight.OrbTable, 1 do
				Timers:CreateTimer(i * 0.4, function()
					local orb = Winterblight.OrbTable[i]
					local unitName = "winterblight_frost_creep"
					if i % 3 == 0 then
						unitName = name1
					elseif i % 3 == 1 then
						unitName = name2
					elseif i % 3 == 2 then
						unitName = name3
					end
					Winterblight:SpawnAzaleaWaveUnit(unitName, orb.endPos, 1, 10, true)
				end)
			end
		elseif Winterblight.AzaleaOrbWaveUnitsSlain == 286 then
			Winterblight:EndOrbWaves()
			--END ORB WAVES
		end
	elseif unit.deathCode == 3 then
		Winterblight:AzaleaWaveUnitDie(unit)
	elseif unit.deathCode == 4 then
		Winterblight:StargazerWaveUnitDie(unit)
	end
end

function ritual_healing(event)
	local target = event.target
	local caster = event.caster
	EmitSoundOn("Winterblight.SatyrHeal", target)
	local healMult = 0.015 + GameState:GetDifficultyFactor() * 0.01
	if target.paragon then
		healMult = 0.005 + GameState:GetDifficultyFactor() * 0.005
	end
	local healAmount = target:GetMaxHealth() * healMult
	target:Heal(healAmount, caster)
	PopupHealing(target, healAmount)
	local particleName = "particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", caster, 1)
end

function frostbite_attack_land(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_frostbite_effect", {duration = 4.5})
	local modifier = target:FindModifierByName("modifier_frostbite_effect")
	local newStacks = math.min(target:GetModifierStackCount("modifier_frostbite_effect", modifier:GetCaster()) + 1, event.max_stacks)
	target:SetModifierStackCount("modifier_frostbite_effect", modifier:GetCaster(), newStacks)
end

function frostbite_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local target = event.target
	local stacks = target:GetModifierStackCount("modifier_frostbite_effect", caster)
	damage = damage * (stacks ^ 2)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function task_armor_init(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_luna_armor", {})
	caster:SetModifierStackCount("modifier_luna_armor", caster, event.charges)
end

function sorc_passive_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if caster:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_azalea_buff", {duration = 8})
		local newStacks = math.min(caster:GetModifierStackCount("modifier_azalea_buff", caster) + 1, 200)
		caster:SetModifierStackCount("modifier_azalea_buff", caster, newStacks)
	end
end

function azalea_sorc_think(event)
	local caster = event.caster
	if not caster.aggro then
		return
	end
	local luck = RandomInt(1, 7 - GameState:GetDifficultyFactor())
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()
	if luck == 1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, caster:Script_GetAttackRange() + 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") and not caster:IsStunned() and not caster:IsRooted() then
			local sumVector = Vector(0, 0, 0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector / #enemies
			local forceDirection = ((casterOrigin - avgVector) * Vector(1, 1, 0)):Normalized()
			CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/sorceress_dash.vpcf", caster, 1.2)
			EmitSoundOn("Winterblight.AzaleaSorceress.Kite", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_SPAWN, rate = 1})
			for i = 1, 22, 1 do
				Timers:CreateTimer(i * 0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() + forceDirection * 14)
				end)
			end
			Timers:CreateTimer(0.66, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)
		end
	end
end

function ice_specter_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mana_burn = event.mana_burn
	EmitSoundOn("Winterblight.IceSpecter.AttackLand", target)
	ability.particleLock = false
	if not ability.particleLock then
		ability.particleLock = true
		local particleName = "particles/units/heroes/hero_leshrac/leshrac_lightning_impact.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
		Timers:CreateTimer(0.5, function()
			ParticleManager:DestroyParticle(pfx, false)
			ability.particleLock = false
		end)
	end
	local burnDamage = math.min(target:GetMana(), mana_burn) * 10
	target:ReduceMana(mana_burn)
	ApplyDamage({victim = target, attacker = caster, damage = burnDamage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end

function ice_specter_die(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mana_burn = event.mana_burn * 10
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 65))
	ParticleManager:SetParticleControl(pfx, 1, Vector(380, 5, 380))
	EmitSoundOn("Winterblight.IceSpecter.DeathStart", caster)
	Timers:CreateTimer(0.75, function()
		ParticleManager:DestroyParticle(pfx, false)
		EmitSoundOn("Winterblight.IceSpecter.Death", caster)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				local burnDamage = math.min(enemy:GetMana(), mana_burn) * 10
				enemy:ReduceMana(mana_burn)
				ApplyDamage({victim = enemy, attacker = caster, damage = burnDamage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			end
		end
	end)
end

function frost_elemental_die(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local icePoint = caster:GetAbsOrigin()
	local radius = event.radius
	EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, icePoint)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_winterblight_chilled", {duration = 8})
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	end
end

function ice_hulk_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local luck = RandomInt(1, 16)
	if luck == 1 then
		local icePoint = target:GetAbsOrigin()
		local radius = 350
		EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
		local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, icePoint)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Winterblight.FrostHulk.Impact", target)
		local damage = event.damage
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			ScreenShake(enemies[1]:GetAbsOrigin(), 130, 0.9, 0.9, 9000, 0, true)
			for _, enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_winterblight_chilled", {duration = 8})
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
				PopupDamage(enemy, damage)
				Filters:ApplyStun(caster, 2.5, enemy)
			end
		end
	end
end

function curse_of_azalea_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function curse_of_azalea_pop(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	Events:CreateLightningBeamWithParticle(unit:GetAbsOrigin(), unit:GetAbsOrigin() + Vector(0, 0, 900), "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", 0.8)
	Filters:ApplyStun(caster, 1.2, unit)
	EmitSoundOn("Winterblight.Priest.CurseOfAzaleaTrigger", unit)
	unit:RemoveModifierByName("modifier_curse_of_azalea")
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_curse_of_azalea_effect", {duration = event.duration})
end

function azalea_priest_think(event)
	local caster = event.caster
	local ability = event.ability
	local caster = event.caster
	local repel = caster:FindAbilityByName("omniknight_repel")
	if caster.aggro then
		if repel:IsFullyCastable() then
			local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
			local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 740, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #allies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = allies[1]:entindex(),
					AbilityIndex = repel:entindex(),
				}
				ExecuteOrderFromTable(newOrder)
				return
			end
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 340 + GameState:GetDifficultyFactor() * 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local sumVector = Vector(0, 0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector / #enemies
			local runDirection = ((caster:GetAbsOrigin() - avgVector) * Vector(1, 1, 0)):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin() + runDirection * 380)
		end
	end
end

function azalea_curse_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target:HasModifier("modifier_curse_of_azalea_immune") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ability:GetSpecialValueFor("bounce_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for k, v in pairs(enemies) do
			if v == target then table.remove(enemies, k) end
		end
		if #enemies > 0 then
			local info = {
				Target = enemies[1],
				Source = target,
				Ability = ability,
				EffectName = "particles/roshpit/winterblight/curse_of_azalea_projectile_poison_touch.vpcf",
				iMoveSpeed = 1500,
				vSourceLoc = caster:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			}
			ProjectileManager:CreateTrackingProjectile(info)
			EmitSoundOn("Winterblight.Priest.CurseProjectile", enemies[1])
		end
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_curse_of_azalea", {duration = 4})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_curse_of_azalea_immune", {duration = 4 + ability:GetSpecialValueFor("immun_duration")})
	end
end

function attackable_unit_hit(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	if caster.prop_id == 0 then
		if not caster.hits then
			caster.hits = 0
		end
		caster.hits = caster.hits + 1
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 30))
		ScreenShake(caster:GetAbsOrigin(), 300, 0.1, 0.1, 9000, 0, true)
		if caster.hits == 5 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_attackable_unit_no_more_attacks", {})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_sword_lifting", {})
			caster.acceleration = 10
			EmitSoundOn("Winterblight.IceSword.BeginLift", caster)
		end
		EmitSoundOn("Winterblight.IceSword.Hit", caster)
	elseif caster.prop_id == 1 then
		Winterblight:AttackAzaleaCrystal(caster, true)
	elseif caster.prop_id == 2 then
		Winterblight:AzaleaCupAttacked(caster, attacker)
	elseif caster.prop_id == 3 then
		Winterblight:AzaleaBladeAttacked(caster, attacker)
	elseif caster.prop_id == 4 then
		Winterblight:AzaleaPuckAttacked(caster, attacker)
	end
end

function sword_lifting_think(event)
	local caster = event.caster
	local ability = event.ability
	caster.acceleration = math.min(caster.acceleration + 1, 50)
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.acceleration))
	if caster.locked then
		return false
	end
	if caster:GetAbsOrigin().z > 3000 then
		--print("spawn sven")
		caster:RemoveModifierByName("modifier_sword_lifting")
		caster.locked = true
		local titan = Winterblight:SpawnFrostTitan(caster:GetAbsOrigin(), caster:GetForwardVector())
		titan:SetAbsOrigin(caster:GetAbsOrigin())
		WallPhysics:Jump(titan, Vector(0, 1), 0, 0, 0, 1)
		titan.jumpEnd = "frost_titan"
		titan.cantAggro = true
		Timers:CreateTimer(0.1, function()
			UTIL_Remove(caster)
		end)
	end
end

function sword_falling_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.acceleration < 0 then
		return false
	end
	caster.acceleration = math.min(caster.acceleration + 1, 85)
	caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, caster.acceleration))
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 128 then
		caster.acceleration = -1
		caster:RemoveModifierByName("modifier_sword_falling")
		local startPoint = GetGroundPosition(caster:GetAbsOrigin(), caster)
		EmitSoundOnLocationWithCaster(startPoint, "Winterblight.SwordClash", caster)

		local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, startPoint)
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.7, 0.75, 0.9))
		ParticleManager:SetParticleControl(pfx, 2, Vector(0.4, 0.4, 0.4))
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
		ScreenShake(caster:GetAbsOrigin(), 300, 0.5, 0.5, 9000, 0, true)

		local damage = 1000
		local procs = 0
		for j = 0, procs, 1 do
			Timers:CreateTimer(j * 0.5, function()
				for i = 0, 3, 1 do
					Timers:CreateTimer(0.15, function()

						local forkDirection = RandomVector(1)
						local direction = forkDirection
						if j == 0 then
							EmitSoundOnLocationWithCaster(startPoint, "Winterblight.ArcanaSunder.Moving", caster)
						end

						local particleName = "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf"
						local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(pfx, 0, startPoint + forkDirection * 50)
						ParticleManager:SetParticleControl(pfx, 1, startPoint + forkDirection * 3000)
						ParticleManager:SetParticleControl(pfx, 3, Vector(200, 3.5, 200)) -- y COMPONENT = duration
						-- ParticleManager:SetParticleControl(pfx, 1, point)
						Timers:CreateTimer(3.5, function()
							ParticleManager:DestroyParticle(pfx, false)
							for i = 1, 3, 1 do
								EmitSoundOnLocationWithCaster(startPoint, "Winterblight.ArcanaSunder.Explode"..i, caster)
							end
							local enemies = FindUnitsInLine(caster:GetTeamNumber(), startPoint, startPoint + forkDirection * 3000, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
							for _, enemy in pairs(enemies) do
								ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
								Filters:ApplyStun(caster, 1, enemy)
								--ability:ApplyDataDrivenModifier(caster, targetUnit, "modifier_stun_explosion", {})
							end
						end)
					end)
				end
			end)
		end
	end
end

function frost_titan_slam_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.IceTitan.WindUp", caster)
	StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_SPAWN, rate = 0.9})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_barnacle_ground_slam", {duration = 1.2})
	local direction = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	CustomAbilities:QuickAttachParticle("particles/act_2/siltbreaker_beam_channel.vpcf", caster, 0.6)
	for i = 1, 2 + GameState:GetDifficultyFactor(), 1 do
		Timers:CreateTimer(0.6 * i, function()
			local position = caster:GetAbsOrigin() + direction * 600 * (i - 1) + direction * 300
			local radius = 800
			local splitEarthParticle = "particles/roshpit/winterblight/frost_colossus_slam.vpcf"
			local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
			EmitSoundOn("Winterblight.ChillingColossus.Slam", caster)
			ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
			-- FindClearSpaceForUnit(caster, position, false)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
					enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 1.5})
				end
			end
			local pfx2 = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(pfx2, 0, position)
			ParticleManager:SetParticleControl(pfx2, 5, Vector(0.7, 0.75, 0.9))
			ParticleManager:SetParticleControl(pfx2, 2, Vector(0.2, 0.2, 0.2))
			Timers:CreateTimer(10, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:DestroyParticle(pfx2, false)
				ParticleManager:ReleaseParticleIndex(pfx2)
			end)
			ScreenShake(position, 300, 0.5, 0.5, 9000, 0, true)
		end)
	end
end

function frost_titan_happening(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 0.9})
	EmitSoundOn("Winterblight.IceTitan.YellGod", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.FrostTitan.GodsStrength", caster)
	Events:ColorWearablesAndBase(caster, Vector(220, 90, 110))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_titan_gods_strength", {duration = 6})
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/frost_titan_god_start.vpcf", caster, 4)
	ParticleManager:SetParticleControl(pfx, 1, Vector(600, 600, 600))
	local waves = GameState:GetDifficultyFactor() + 4
	for i = 1, waves, 1 do
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / waves)
		local info =
		{
			Ability = ability,
			EffectName = "particles/roshpit/redfall_bigwave.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = 600 + GameState:GetDifficultyFactor() * 300,
			fStartRadius = 240,
			fEndRadius = 240,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = 0,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * 1000,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function frost_titan_die(event)
	if not Winterblight.FrostTitansSlain then
		Winterblight.FrostTitansSlain = 0
	end
	Winterblight.FrostTitansSlain = Winterblight.FrostTitansSlain + 1
	if Winterblight.FrostTitansSlain == 3 then
		Timers:CreateTimer(2, function()
			Winterblight:StartOrbSequence()
		end)
	end
end

function frost_god_end(event)
	local caster = event.caster
	local ability = event.ability
	Events:ColorWearablesAndBase(caster, Vector(200, 210, 255))
end

function titan_wave_hit(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local target = event.target
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	Filters:ApplyStun(caster, 1.0, target)
	EmitSoundOn("Winterblight.IceTitan.WaveImpact", target)
end

function azlea_orb_master_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end

	for i = 1, #Winterblight.StatuesTable, 1 do
		local statue = Winterblight.StatuesTable[i]
		statue.position = statue.position + Vector(0, 0, 3) * math.cos(2 * math.pi * caster.interval / 240)
		statue.prop:SetAbsOrigin(statue.position)
	end
	caster.interval = caster.interval + 1
	if caster.interval == 240 then
		caster.interval = 0
	end
end

function dimension_spear_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = event.duration
	for i = 0, 7, 1 do
		local target_ability = target:GetAbilityByIndex(i)
		if target_ability then
			if target_ability:GetCooldownTimeRemaining() > 0 then
				local cd = math.min(target_ability:GetCooldownTimeRemaining() + duration, 60)
				target_ability:EndCooldown()
				target_ability:StartCooldown(cd)
			end
		end
	end
end

function frost_dragon_breath_start(event)
	local caster = event.caster
	local ability = event.ability
	local position = event.target_points[1]
	local fv = ((position - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	StartAnimation(caster, {duration = 1.1, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.9})
	local info =
	{
		Ability = ability,
		EffectName = "particles/items/cannon/breath_of_ice.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 50) + fv * 120,
		fDistance = 550 + GameState:GetDifficultyFactor() * 150,
		fStartRadius = 150,
		fEndRadius = 300,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * 1000,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		Timers:CreateTimer(1.2, function()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 840 + GameState:GetDifficultyFactor() * 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local sumVector = Vector(0, 0)
				for i = 1, #enemies, 1 do
					sumVector = sumVector + enemies[i]:GetAbsOrigin()
				end
				local avgVector = sumVector / #enemies
				local runDirection = ((caster:GetAbsOrigin() - avgVector) * Vector(1, 1, 0)):Normalized()
				caster:MoveToPosition(caster:GetAbsOrigin() + runDirection * 580)
			end
		end)
	end
end

function frost_dragon_breath_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:IsHero() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_breath_for_hero", {duration = 6})
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_breath_effect", {duration = 6})
end

function zealot_die(event)
	local caster = event.caster
	local ability = event.ability
	if not Winterblight.ZealotsSlain then
		Winterblight.ZealotsSlain = 0
	end
	Winterblight.ZealotsSlain = Winterblight.ZealotsSlain + 1
	if Winterblight.ZealotsSlain < 3 then
		Timers:CreateTimer(1.5, function()
			Winterblight:StatueSlotStart(Winterblight.ZealotsSlain + 1)
		end)
	elseif Winterblight.ZealotsSlain == 3 then
		Winterblight:OpenShrineOfAzalea()
	end
	EmitSoundOn("Winterblight.AzaleanZealot.Die", caster)
end

function zealot_teleport(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.aggro then
		return false
	end

	local particleName = "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	if caster.jump_stop then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200 + GameState:GetDifficultyFactor() * 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/frost_titan_god_start.vpcf", caster:GetAbsOrigin(), 3)
		EmitSoundOn("Winterblight.IceBlink", caster)
		local target = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(240, 1200))
		local casterOrigin = caster:GetAbsOrigin()
		target = WallPhysics:WallSearch(casterOrigin, target, caster)
		-- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
		--     ParticleManager:SetParticleControl( pfx, 0, position )
		local newPosition = target
		FindClearSpaceForUnit(caster, newPosition, false)
		local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, newPosition)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx1, false)
			ParticleManager:DestroyParticle(pfx2, false)
		end)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/frost_titan_god_start.vpcf", caster:GetAbsOrigin(), 3)
		StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_TELEPORT_END, rate = 1.1})
		caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "run"})
	end
end

function zealot_strafe(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.aggro then
		return false
	end
	if caster.jump_stop then
		return false
	end
	if caster:HasModifier("modifier_strafing") then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200 + GameState:GetDifficultyFactor() * 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	if #enemies > 0 then
		EmitSoundOn("Winterblight.AzaleanZealot.Strafe", caster)
		local directon = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		ability.strafe_direction = WallPhysics:rotateVector(directon, 2 * math.pi / 4)
		ability.strafe_speed = 30
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_strafing", {duration = 1})
		StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_SPAWN, rate = 1.1})
		caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "run"})
	end
end

function strafing_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.strafe_speed = math.max(ability.strafe_speed - 0.2, 15)
	local speed = ability.strafe_speed
	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + speed * ability.strafe_direction), caster)
	if blockUnit then
		speed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + speed * ability.strafe_direction)
end

function strafe_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
end

function zealot_wave_start(event)
	local caster = event.caster
	local ability = event.ability
	local position = event.target_points[1]
	local blasts = GameState:GetDifficultyFactor()
	local fv = ((position - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	EmitSoundOn("Winterblight.AzaleanZealot.WaveBlast", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.AzaleanZealot.BlastAbility", caster)
	caster.jump_stop = true
	Timers:CreateTimer(1, function()
		caster.jump_stop = false
	end)
	for i = -blasts, blasts, 1 do
		local blastFV = WallPhysics:rotateVector(fv, 2 * math.pi * i / (20 + blasts))
		local info =
		{
			Ability = ability,
			EffectName = "particles/roshpit/winterblight/zealot_wave.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 50) + fv * 120,
			fDistance = 1500,
			fStartRadius = 300,
			fEndRadius = 500,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = blastFV * 1200,
			bProvidesVision = false
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function zealot_wave_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = event.cooldown
	local damage = event.damage
	for i = 0, 7, 1 do
		local target_ability = target:GetAbilityByIndex(i)
		if target_ability then
			local cd = math.min(target_ability:GetCooldownTimeRemaining() + duration, target_ability:GetCooldown(target_ability:GetLevel()))
			target_ability:EndCooldown()
			target_ability:StartCooldown(cd)
		end
	end
end

function coldseer_wave_start(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]
	local damage = event.damage
	EmitSoundOnLocationWithCaster(target, "Winterblight.ColdSeer.WaveFall", Events.GameMaster)
	for i = 0, 5, 1 do
		Timers:CreateTimer(i * 1, function()
			local particlePosition = target + RandomVector(RandomInt(0, 120))
			local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/cold_seer_icefall.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, particlePosition)
			ParticleManager:SetParticleControl(pfx, 4, Vector(280, 280, 280))
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			Timers:CreateTimer(0.24, function()
				-- EmitSoundOnLocationWithCaster(particlePosition, "MysticAssasin.Rockfall.Impact", caster)
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle1, 0, particlePosition)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				GridNav:DestroyTreesAroundPoint(particlePosition, 270, false)
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), particlePosition, nil, 270, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_cold_seer_wave_burn", {duration = 8})
					end
				end
			end)
		end)
	end
end

function wave_burn_think(event)
	local ability = event.ability
	local caster = event.caster
	local damage = event.damage
	local target = event.target
	local stacks = target:GetModifierStackCount("modifier_cold_seer_wave_burn", caster)
	local damage = damage * stacks ^ 2
	ApplyDamage({victim = enemy, attacker = Winterblight.Master, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function wave_burn_ability_executed(event)
	local unit = event.unit
	local target = unit
	local caster = event.caster
	local ability = event.ability
	local modifier = target:FindModifierByName("modifier_cold_seer_wave_burn")
	local stacks = modifier:GetStackCount() + 1
	modifier:SetStackCount(stacks)
	modifier:SetDuration(8, true)
	EmitSoundOn("Winterblight.ColdSeer.BurnTrigger", unit)
end

function heartfreezer_passive(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		EmitSoundOn("Winterblight.HeartFreezer.PassiveSound", caster)
		for _, enemy in pairs(enemies) do
			local info =
			{
				Target = enemy,
				Source = caster,
				Ability = ability,
				EffectName = "particles/roshpit/winterblight/heartfreezer_passive.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 8,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 600,
			iVisionTeamNumber = caster:GetTeamNumber()}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function heartfreezer_blink(event)
	local caster = event.caster
	local ability = event.ability
	--print("ANYTHING?")
	EmitSoundOn("Winterblight.IceBlink", caster)
	local position = event.target_points[1]
	local particleName = "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	local target = position
	local casterOrigin = caster:GetAbsOrigin()
	target = WallPhysics:WallSearch(casterOrigin, target, caster)
	-- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
	--     ParticleManager:SetParticleControl( pfx, 0, position )
	local newPosition = target
	FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function heartfreezer_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local icePoint = target:GetAbsOrigin()
	local radius = 400
	EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, icePoint)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (event.atk_power_dmg / 100)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_heartfreezer_slow", {duration = 3})
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	end
end

function mountain_god_think(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local position = caster:GetAbsOrigin()
	if caster:IsStunned() then
		return false
	end
	if caster.aggro and caster:IsAlive() then
		StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_TELEPORT_END, rate = 0.9})
		Timers:CreateTimer(0.35, function()
			local position = caster:GetAbsOrigin()
			local radius = 450
			local splitEarthParticle = "particles/roshpit/winterblight/frost_colossus_slam.vpcf"
			local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
			EmitSoundOn("Winterblight.Frostgod.Slam", caster)
			-- FindClearSpaceForUnit(caster, position, false)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
					enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 0.5})
				end
			end
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function mountain_god_falling_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.fallSpeed then
		caster.fallSpeed = 10
	end
	caster.fallSpeed = math.min(caster.fallSpeed + 0.5, 45)
	caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, caster.fallSpeed))
	if GetGroundHeight(caster:GetAbsOrigin(), caster) + 100 > caster:GetAbsOrigin().z then
		caster:RemoveModifierByName("modifier_mountain_god_falling")
		Timers:CreateTimer(0.03, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			local position = caster:GetAbsOrigin()
			local damage = event.damage
			StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_TELEPORT_END, rate = 0.9})
			Timers:CreateTimer(0.3, function()
				local position = caster:GetAbsOrigin()
				local radius = 500
				local splitEarthParticle = "particles/roshpit/winterblight/frost_colossus_slam.vpcf"
				local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, position)
				ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
				EmitSoundOn("Winterblight.ChillingColossus.Slam", caster)
				ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
				-- FindClearSpaceForUnit(caster, position, false)
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
						enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 0.5})
					end
				end
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end)
		end)
	end
end

function grand_stalacorr_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if target:HasModifier("modifier_stalacorr_flail") then
		return false
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_stalacorr_flail", {duration = 1.5})
	local punchFV = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	WallPhysics:JumpWithBlocking(target, punchFV, 32, 18, 22, 1)

end

function grand_slacorr_slam_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.Stalacorr.WindUp", caster)
	StartAnimation(caster, {duration = 0.5, activity = ACT_TINY_TOSS, rate = 0.9})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_barnacle_ground_slam", {duration = 1.2})
	local direction = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	for i = 1, 3, 1 do
		Timers:CreateTimer(0.6 * i, function()
			for j = 1, 5, 1 do
				direction = WallPhysics:rotateVector(direction, 2 * math.pi * j / 5)
				local position = caster:GetAbsOrigin() + direction * 600 * (i - 1) + direction * 300
				local radius = 500
				local splitEarthParticle = "particles/roshpit/winterblight/frost_colossus_slam.vpcf"
				local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, position)
				ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
				EmitSoundOn("Winterblight.ChillingColossus.Slam", caster)
				ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
				-- FindClearSpaceForUnit(caster, position, false)
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
						enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 1.5})
					end
				end
				local pfx2 = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx2, 0, position)
				ParticleManager:SetParticleControl(pfx2, 5, Vector(0.7, 0.75, 0.9))
				ParticleManager:SetParticleControl(pfx2, 2, Vector(0.2, 0.2, 0.2))
				Timers:CreateTimer(10, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:DestroyParticle(pfx2, false)
					ParticleManager:ReleaseParticleIndex(pfx2)
				end)
				ScreenShake(position, 300, 0.5, 0.5, 9000, 0, true)
			end
		end)
	end
end

function grand_slacorr_die(event)
	local caster = event.caster
	EmitSoundOn("Winterblight.Stalacorr.WindUp", caster)
	Timers:CreateTimer(1, function()
		for j = 0, 1, 1 do
			Timers:CreateTimer(j * 2.2, function()
				for i = 0, 4, 1 do
					ScreenShake(caster:GetAbsOrigin(), 860, 0.7, 0.7, 9000, 0, true)
					local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 80))
					ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
					ParticleManager:SetParticleControl(pfx, 2, Vector(0.8, 0.8, 0.8))
					Timers:CreateTimer(10, function()
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:ReleaseParticleIndex(pfx)
					end)
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.GrandStalacorr.Rising", Events.GameMaster)
				end
			end)
		end
		RPCItems:RollGravelfootTreads(caster:GetAbsOrigin())
	end)

end

function birch_shell_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_frigid_growth_shield_broken") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_frigid_growth_shield", {duration = 2})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shield_break_stacks", {duration = 10})
		local newStacks = caster:GetModifierStackCount("modifier_shield_break_stacks", caster) + 1
		caster:SetModifierStackCount("modifier_shield_break_stacks", caster, newStacks)
		if newStacks >= 50 then
			caster:RemoveModifierByName("modifier_shield_break_stacks")
			caster:RemoveModifierByName("modifier_frigid_growth_shield")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_frigid_growth_shield_broken", {duration = 15})
		end
	end
end

function winterblight_endurance_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:IsStunned() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_winterblight_endurance_buff", {duration = 0.2})
	end
end
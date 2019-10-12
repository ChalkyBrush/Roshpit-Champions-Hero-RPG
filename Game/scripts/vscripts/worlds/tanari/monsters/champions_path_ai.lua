function kobold_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	Tanari.unibi.objectiveCount = Tanari.unibi.objectiveCount + 1
end

function water_troll_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Tanari.unibi.waterTrollCount then
		Tanari.unibi.waterTrollCount = 0
	end
	Tanari.unibi.waterTrollCount = Tanari.unibi.waterTrollCount + 1
end

function water_troll_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local bloodlust = caster:FindAbilityByName("ogre_magi_bloodlust")
		if bloodlust then
			if bloodlust:IsFullyCastable() then
				local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #allies > 0 then

					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						TargetIndex = allies[1]:entindex(),
						AbilityIndex = bloodlust:entindex(),
					}
					ExecuteOrderFromTable(newOrder)
				end
			end
		end
	end
end

function angry_fish_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Tanari then
		return
	end
	Tanari.unibi.angryFishCount = Tanari.unibi.angryFishCount + 1
end

function angry_fish_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local luck = RandomInt(1, 100)
	if luck <= 15 then
		if not target:IsNull() and not caster:HasModifier("modifier_angry_fish_crit_damage") then
			StartAnimation(caster, {duration = 0.1, activity = ACT_DOTA_TELEPORT_END, rate = 2})

			target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.3})
			WallPhysics:Jump(caster, caster:GetForwardVector(), 0, 50, 6, 1.5)
			WallPhysics:Jump(target, target:GetForwardVector(), 0, 50, 6, 1.5)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_angry_fish_crit_damage", {duration = 0.21})
			Timers:CreateTimer(0.12, function()
				local particleName = "particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero_swipe_blur.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 40))
				local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin() + Vector(0, 0, 10))
				Timers:CreateTimer(0.4, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:DestroyParticle(pfx2, false)
				end)
				StartAnimation(caster, {duration = 0.1, activity = ACT_DOTA_ATTACK, rate = 3})
			end)
			Timers:CreateTimer(0.18, function()
				EmitSoundOn("Tanari.AngryFishCrit", target)
				caster:PerformAttack(target, true, true, false, true, false, false, false)
				local damageApprox = math.ceil(OverflowProtectedGetAverageTrueAttackDamage(caster) * 3.5)
				PopupDamage(target, damageApprox)
			end)
		end
	end
end

function angry_fish_think(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_jumping") and caster.aggro then
		StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_TELEPORT_END, rate = 0.7})
		WallPhysics:Jump(caster, caster:GetForwardVector(), RandomInt(2, 10), 40, 14, 1.4)
	end
	if not caster.aggro then
		if not caster.interval then
			StartAnimation(caster, {duration = 4, activity = ACT_DOTA_TAUNT, rate = 1.2, translate = "backstroke_gesture"})
			local position = Vector(-1152, -1152)
			local randomY = RandomInt(0, 940)
			local randomX = RandomInt(0, 1020)
			caster:MoveToPosition(position + Vector(randomX, randomY))
			event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_angry_fish_swimming", {duration = 8})
		end
	end
end

function angry_fish_stop_swimming(event)
	EndAnimation(event.caster)
end

function kraken_king_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 5, false)
	local ravage = caster:FindAbilityByName("tanari_kraken_ravage")
	if ravage:IsFullyCastable() and caster.interval % 2 == 0 then
		WallPhysics:Jump(caster, Vector(1, 1), 0, 40, 15, 1.5)
		local soundTable = {"tidehunter_tide_pain_01", "tidehunter_tide_kill_09"}
		local randomSound = RandomInt(1, #soundTable)
		EmitSoundOn(soundTable[randomSound], caster)
		EmitSoundOn(soundTable[randomSound], caster)
		StartAnimation(caster, {duration = 1, activity = ACT_DOTA_SPAWN, rate = animationTime})
		return false
	end
	local smash = caster:FindAbilityByName("tanari_kraken_anchor_smash")
	if smash:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then

			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = smash:entindex(),
			}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(smash:GetCastPoint(), function()
				local point = caster:GetAbsOrigin()
				local modifierKnockback =
				{
					center_x = point.x,
					center_y = point.y,
					center_z = point.z,
					duration = 1,
					knockback_duration = 1,
					knockback_distance = 450,
					knockback_height = 250
				}
				for i = 1, #enemies, 1 do
					enemies[i]:AddNewModifier(caster, nil, "modifier_knockback", modifierKnockback)
				end
			end)
		end
	end
	if caster:HasAbility("king_kraken_aoe_ability") then
		local aoeAbility = caster:FindAbilityByName("king_kraken_aoe_ability")
		if aoeAbility:IsFullyCastable() then
			--print("AOE AIBLITY IS CASTABLE")
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = aoeAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				return false
			end
		end
	end
	caster.interval = caster.interval + 1
	if caster.interval > 10 then
		caster.interval = 0
	end
end

function kraken_king_die(event)
	local caster = event.caster
	EmitSoundOn("tidehunter_tide_death_01", caster)
	Timers:CreateTimer(0.9, function()
		ScreenShake(caster:GetAbsOrigin(), 200, 0.4, 0.8, 9000, 0, true)
		for i = 0, 1, 1 do
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 0, 0)
		end
	end)
	Tanari.unibi.krakenKingDead = true
end

function mountain_bully_think(event)
	local caster = event.caster
	WallPhysics:Jump(caster, caster:GetForwardVector(), 16, 10, 16, 1)
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_OVERRIDE_ABILITY_2, rate = 1.6})
end

function mountain_pass_guardian_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOn("elder_titan_elder_anger_04", caster)
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_5, rate = 1})
			local target = enemies[1]
			if not target.jumpLock and not target.pushLock then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_mountain_pass_guardian_pull", {duration = 1.6})
				local particleName = "particles/units/heroes/hero_wisp/tether_green.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin() + Vector(0, 0, 90), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0, 0, 90), true)
				local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin() + Vector(0, 0, 90), true)
				ParticleManager:SetParticleControlEnt(pfx2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0, 0, 90), true)
				local jumpDirection = ((caster:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
				local propulsion = math.floor(distance / 27)
				WallPhysics:Jump(target, jumpDirection, propulsion, 20, 40, 1.2)
				Timers:CreateTimer(1.6, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:DestroyParticle(pfx2, false)
				end)
			end
		end
	end

end

function mountain_pass_guardian_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if not target:HasModifier("modifier_jumping") then
		local point = attacker:GetAbsOrigin()
		local modifierKnockback =
		{
			center_x = point.x,
			center_y = point.y,
			center_z = point.z,
			duration = 1,
			knockback_duration = 1,
			knockback_distance = 350,
			knockback_height = 200
		}
		target:AddNewModifier(attacker, nil, "modifier_knockback", modifierKnockback)
		EmitSoundOn("Tanari.LegionLand", attacker)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
		local bonusDamage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
		ApplyDamage({victim = target, attacker = attacker, damage = bonusDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		PopupDamage(target, bonusDamage)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function pass_guardian_die(event)
	Tanari.unibi.passGuardianDead = true
	Tanari:SpawnMountainNomad(Vector(6784, -1792), Vector(1, 0))
end

function mountain_giant_die(event)
	local position = event.caster:GetAbsOrigin()
	Timers:CreateTimer(0.7, function()
		ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
	end)
end

function mountain_giant_think(event)
	local caster = event.caster
	if caster.aggro then
		StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1})
		EmitSoundOn("earth_spirit_earthspi_pain_14", caster)
		Timers:CreateTimer(0.5, function()
			ScreenShake(caster:GetAbsOrigin(), 200, 0.4, 0.8, 9000, 0, true)
			EmitSoundOn("Tanari.StoneAttack", caster)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for i = 1, #enemies, 1 do
					enemies[i]:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.0})
				end
			end
		end)
	end
end

function nomad_attack_land(event)
	local target = event.target
	local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "follow_origin", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "follow_origin", target:GetAbsOrigin(), true)

	EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
end

function mountain_nomad_die(event)
	Tanari.unibi.mountainNomadDead = true
end

function mountain_specter_think(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			Timers:CreateTimer(1.5 * (i - 1), function()
				position = caster:GetAbsOrigin()
				local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
				local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				EmitSoundOn("Tanari.MountainSpecterBlinkAttack", caster)
				local teleportPosition = enemies[i]:GetAbsOrigin() + RandomVector(220)
				caster:SetAbsOrigin(teleportPosition)
				FindClearSpaceForUnit(caster, teleportPosition, false) --[[Returns:void
Place a unit somewhere not already occupied.
]]
				position = caster:GetAbsOrigin()

				local pfx2 = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				ParticleManager:SetParticleControlEnt(pfx2, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx2, false)
				end)

			end)
		end
	end
end

function mountain_specter_explosion(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_Spectre.HauntCast", caster)
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_5, rate = 0.9, translate = "am_blink"})
	for i = -6, 6, 1 do
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 6 * i)
		create_specter_projectile(caster:GetAbsOrigin() + Vector(0, 0, 120), fv, caster, ability)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "tanari_specter_temporary_root", {duration = 0.2})
end

function create_specter_projectile(spellOrigin, forward, caster, ability)

	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_alchemist/epoch_rune_a_d_concoction_projectile.vpcf",
		vSpawnOrigin = spellOrigin,
		fDistance = 1650,
		fStartRadius = 120,
		fEndRadius = 120,
		Source = caster,
		StartPosition = "attach_hitloc",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 7.0,
		bDeleteOnHit = false,
		vVelocity = forward * 470,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function specter_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local sound = "Hero_Pugna.NetherBlast"
	local particleName = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"
	local particleVector = target:GetAbsOrigin()
	local radius = 200
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	Timers:CreateTimer(0.8, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn(sound, target)
	local damage = event.aoe_damage
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	PopupDamage(target, damage)
end

function mountain_specter_die(event)
	local caster = event.caster
	Tanari.unibi.mountainSpecterDead = true
	local position = caster:GetAbsOrigin()
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	Timers:CreateTimer(1.2, function()
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.RemnantDisappear", caster)

		local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		if caster:GetUnitName() == "tanari_mountain_specter" then
			if GameState:GetDifficultyFactor() == 3 then
				Timers:CreateTimer(3, function()
					Tanari:SpawnMountainSpecterCrow(position, Vector(0, -1))
				end)
			else
				Timers:CreateTimer(5, function()

					Tanari:BeginSideTempleOpenSequence(allies)
				end)
			end
		elseif caster:GetUnitName() == "tanari_mountain_specter_crow_form" then
			Timers:CreateTimer(4, function()
				Tanari:BeginSideTempleOpenSequence(allies)
			end)
		end
		Timers:CreateTimer(0.2, function()
			UTIL_Remove(caster)
		end)

	end)
end

function tanari_hydra_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		if caster:HasModifier("modifier_tanari_hydra_submerged") then
			caster:RemoveModifierByName("modifier_tanari_hydra_submerged")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_beast_fighting", {})
			--print("RISE!")
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			for i = 1, 20, 1 do
				Timers:CreateTimer(0.03 * i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 12))
				end)
			end
			Timers:CreateTimer(0.18, function()
				particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
				EmitSoundOn("Tanari.WaterSplash", caster)
				Timers:CreateTimer(10, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		else
			EmitSoundOn("Tanari.PoisonGale", caster)
			StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.5})
			local spellOrigin = caster:GetAbsOrigin()
			for j = -1, 1, 1 do
				local forward = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 12 * j)
				local info =
				{
					Ability = ability,
					EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
					vSpawnOrigin = spellOrigin,
					fDistance = 1650,
					fStartRadius = 140,
					fEndRadius = 140,
					Source = caster,
					StartPosition = "attach_hitloc",
					bHasFrontalCone = true,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 7.0,
					bDeleteOnHit = false,
					vVelocity = forward * 590,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end
		end
	else
		if not caster:HasModifier("modifier_tanari_hydra_submerged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_tanari_hydra_submerged", {})
			caster:RemoveModifierByName("modifier_beast_fighting")
			--print("FALL!")
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			caster.sinking = true
			Timers:CreateTimer(0.6, function()
				caster.sinking = false
			end)
			for i = 1, 20, 1 do
				Timers:CreateTimer(0.03 * i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 12))
				end)
			end
			Timers:CreateTimer(0.18, function()
				particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
				EmitSoundOn("Tanari.WaterSplash", caster)
				Timers:CreateTimer(10, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end
	end
end

function tanari_hydra_poison_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = Events:GetDifficultyScaledDamage(100, 1200, 8000)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function tanari_hydra_movement(event)
	local caster = event.caster
	if not caster.sinking then
		caster.offsetForward = WallPhysics:rotateVector(caster.offsetForward, -math.pi / 450)
		caster:SetAbsOrigin(Vector(576, -576) + caster.offsetForward * 900)
		caster:SetForwardVector(WallPhysics:rotateVector(caster.offsetForward, -math.pi / 2))
	end
end

function bongo_frog_think(event)
	local caster = event.caster
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.Bongo", caster)
end

function bongo_take_damage(event)
	local caster = event.caster
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS and not caster.spawnedAmbush then
		caster.spawnedAmbush = true
		Timers:CreateTimer(1.0, function()
			local ambusher1 = Tanari:SpawnAmbusher(Vector(-896, 4288), Vector(-1, -1))
			local ambusher2 = Tanari:SpawnAmbusher(Vector(-128, 4096), Vector(1, -1))
			WallPhysics:Jump(ambusher1, Vector(1, -1):Normalized(), 20, 20, 20, 1.3)
			WallPhysics:Jump(ambusher2, Vector(-1, -1):Normalized(), 20, 20, 20, 1.3)
			StartAnimation(ambusher1, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			StartAnimation(ambusher2, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
		end)
	end
end

function wind_temple_keyholder_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval % 3 == 0 and not caster:IsStunned() and not caster:IsFrozen() then
		bomb_throw_start(caster, ability, caster:GetAbsOrigin() + caster:GetForwardVector() * RandomInt(350, 450), event.bomb_damage)
	end
	local modulos = 5 - GameState:GetDifficultyFactor()
	if caster.interval % modulos == 0 then
		if not ability.flowerTable then
			ability.flowerTable = {}
		end
		if #ability.flowerTable < 16 then
			local bottomLeftPos = Vector(1820, 1753)
			local randomX = RandomInt(0, 2000)
			local randomY = RandomInt(0, 750)
			local flower = Tanari:SpawnPoisonFlowerNoLoot(RandomVector(1), bottomLeftPos + Vector(randomX, randomY))
			Timers:CreateTimer(0.05, function()
				StartAnimation(flower, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			end)
			flower:SetDeathXP(0)
			flower:SetMaximumGoldBounty(0)
			flower:SetMinimumGoldBounty(0)
			table.insert(ability.flowerTable, flower)
			local newFlowerTable = {}
			for i = 1, #ability.flowerTable, 1 do
				if IsValidEntity(ability.flowerTable[i]) then
					if flower:IsAlive() then
						table.insert(newFlowerTable, ability.flowerTable[i])
					end
				end
			end
			ability.flowerTable = newFlowerTable
		end
	end
	if caster.interval >= 20 then
		caster.interval = 0
		local forward = caster:GetForwardVector()
		for i = -1, 1 do
			local tripleForward = RandomVector(1)
			Timers:CreateTimer((i + 2) * 0.15, function()
				bomb_throw_start(caster, ability, caster:GetAbsOrigin() + tripleForward * RandomInt(350, 450))
			end)
			EmitSoundOn("lone_druid_lone_druid_bearform_anger_09", caster)
		end
		StartSoundEvent("Tanari.KeyHolderBattle", caster)
	end
	if caster:GetHealth() < caster:GetMaxHealth() * 0.2 then
		if caster.regensRemaining > 0 then
			if not caster:HasModifier("modifier_wind_temple_key_stone_form") then
				caster.regensRemaining = caster.regensRemaining - 1
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_temple_key_stone_form", {duration = 8})
				EmitSoundOn("Tanari.WindKeyHolderStoneForm.VO", caster)
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.WindKeyHolderStoneForm", caster)
				CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", caster, 3)
			end
		else
			caster:RemoveModifierByName("modifier_wind_temple_key_unkillable")
		end
	end
end

function wind_temple_keyholder_attack_land(event)
	local caster = event.attacker
	local ability = event.ability
	local spellOrigin = caster:GetAbsOrigin() + Vector(0, 0, 160) + caster:GetForwardVector() * 50
	local forward = caster:GetForwardVector()
	EmitSoundOn("Tanari.KeyHolder.WindBreath", caster)
	local info =
	{
		Ability = ability,
		EffectName = "particles/items/cannon/breath_of_wind.vpcf",
		vSpawnOrigin = spellOrigin,
		fDistance = 600,
		fStartRadius = 120,
		fEndRadius = 400,
		Source = caster,
		StartPosition = "attach_hitloc",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 7.0,
		bDeleteOnHit = false,
		vVelocity = forward * 470,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function wind_temple_keyholder_projectile_strike(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local divisor = 300
	if GameState:GetDifficultyFactor() == 2 then
		divisor = 200
	elseif GameState:GetDifficultyFactor() == 3 then
		divisor = 100
	end
	if Events.SpiritRealm then
		divisor = divisor / 4
	end
	local damage = (OverflowProtectedGetAverageTrueAttackDamage(caster) / divisor)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function wind_temple_keyholder_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("lone_druid_lone_druid_bearform_death_06", caster)
	EmitSoundOn("lone_druid_lone_druid_bearform_death_06", caster)
	local casterOrigin = caster:GetAbsOrigin()
	for j = 0, 6, 1 do
		Timers:CreateTimer(0.4 * j, function()
			RPCItems:RollItemtype(300, casterOrigin, 1, 0)
		end)
	end
	for i = 1, #ability.flowerTable, 1 do
		if IsValidEntity(ability.flowerTable[i]) then
			if ability.flowerTable[i]:IsAlive() then
				ApplyDamage({victim = ability.flowerTable[i], attacker = caster, damage = 10000000, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			end
		end
	end
	Timers:CreateTimer(1, function()
		StopSoundEvent("Tanari.KeyHolderBattle", caster)
		EmitGlobalSound("Tanari.KeyVictory")
		Tanari:AcquireTempleKey(casterOrigin, "wind")
	end)
	Timers:CreateTimer(9, function()
		Tanari:WindTempleKeyWalls(true)
		Tanari.unibi.windTempleKeyVictory = true
	end)
end

--WIND TEMPLE KEY HOLDER BOMBS

function bomb_throw_start(caster, ability, target, bomb_damage)
	for i = 1, GameState:GetDifficultyFactor(), 1 do
		local fv = (target * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
		fv = WallPhysics:rotateVector(fv, math.pi * 2 * (i - 1) / 20)
		local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
		bomb.phase = 1
		bomb.stun_duration = 2
		bomb.colorPhase = 0
		bomb.fv = fv
		bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_throwing_bomb", {duration = 0.6})
		StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_VICTORY, rate = 1})
		local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
		bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
		bomb.type = "explosive"
		bomb.origCaster = caster
		bomb.origAbility = ability
		bomb.damage = bomb_damage
		bomb:SetOriginalModel("models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl")
		bomb:SetModel("models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl")

		bomb.detonate = true
		if ability.total_bombs == nil then
			ability.total_bombs = 0
			ability.bombs = {}
		end
		ability.total_bombs = ability.total_bombs + 1
		table.insert(ability.bombs, bomb)

		if bomb.detonate then
			Timers:CreateTimer(0.1, function()
				-- StartSoundEvent("Trapper.BombTicking", bomb)
			end)
		end
		EmitSoundOn("Trapper.BombThrow", caster)
		bomb_start(bomb, ability, target)
	end
end

function reindexBombs(ability)
	local tempTable = {}
	for i = 1, #ability.bombs, 1 do
		if IsValidEntity(ability.bombs[i]) then
			table.insert(tempTable, ability.bombs[i])
		end
	end
	return tempTable
end

function bomb_start(caster, ability, target_location)

	local casterOrigin = caster:GetAbsOrigin()
	local targetOrigin = target_location
	local fv = (targetOrigin * Vector(1, 1, 0) - casterOrigin * Vector(1, 1, 0)):Normalized()
	local distance = WallPhysics:GetDistance(casterOrigin * Vector(1, 1, 0), targetOrigin * Vector(1, 1, 0))
	caster:SetForwardVector(fv)
	local propulsion = distance / 30
	caster.maxBounces = 1
	if distance > 500 then
		caster.maxBounces = 2
	end
	bomb_jump_to_position(caster, fv, distance, 20, propulsion, 1, 1)
	local animationTime = math.min(500 / distance, 1)
end

function bomb_jump_to_position(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
	local liftDuration = distance / propulsion / 2
	if unit.phase == 2 then
		liftDuration = 10
	elseif unit.phase == 3 then
		liftDuration = 4
	end
	local endLocation = unit:GetAbsOrigin() + forwardVector * distance
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03 * i, function()
			local currentPosition = unit:GetAbsOrigin()
			local liftForce = math.max(liftForce - i * gravity, 0)
			local newPosition = currentPosition + forwardVector * propulsion + Vector(0, 0, liftForce)
			unit:SetOrigin(newPosition)
		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03 * liftDuration + 0.03, function()
		Timers:CreateTimer(0.03 * fallLoop, function()
			fallLoop = fallLoop + 1
			local currentPosition = unit:GetAbsOrigin()
			local newPosition = currentPosition + forwardVector * propulsion - Vector(0, 0, fallLoop * gravity * fallGravity)

			if unit:HasModifier("modifier_bomb_motion") then
				unit:SetOrigin(newPosition)
			end
			if GetGroundPosition(unit:GetAbsOrigin(), unit).z > unit:GetAbsOrigin().z - 11 then
				unit:SetOrigin(newPosition)
				bomb_land(unit, propulsion)
			else
				if newPosition.x <= endLocation.x + 0 and newPosition.x >= endLocation.x - 0 and newPosition.y <= endLocation.y + 0 and newPosition.y >= endLocation.y - 0 then
					unit:SetOrigin(newPosition)
					bomb_land(unit, propulsion)
				else
					return 0.03
				end
			end
		end)
	end)
end

function bomb_explode(unit)
	EmitSoundOn("Trapper.BombImpactFinal", unit)
	local explosionRadius = 500
	local caster = unit.origCaster
	local ability = unit.origAbility
	local damage = unit.damage
	local stun_duration = unit.stun_duration
	ability.total_bombs = ability.total_bombs - 1

	Timers:CreateTimer(0.9, function()
		local position = unit:GetAbsOrigin()
		StopSoundEvent("Trapper.BombTicking", unit)
		StopSoundOn("Trapper.BombTicking", unit)
		EmitSoundOn("Trapper.BombExplode", unit)
		local particleName = "particles/units/heroes/hero_puck/puck_waning_rift.vpcf"
		local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle2, 0, position)
		ParticleManager:SetParticleControl(particle2, 1, Vector(explosionRadius, explosionRadius, explosionRadius))
		-- ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
		-- ParticleManager:SetParticleControl( particle2, 4, Vector(40, 255, 40) )

		Timers:CreateTimer(1.9, function()
			ParticleManager:DestroyParticle(particle2, false)
		end)
		particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, unit)
		ParticleManager:SetParticleControl(particle1, 0, unit:GetAbsOrigin())
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		GridNav:DestroyTreesAroundPoint(position, explosionRadius, false)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
				enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = stun_duration})
			end
		end
	end)
	Timers:CreateTimer(1.0, function()
		UTIL_Remove(unit)
		ability.bombs = reindexBombs(ability)
	end)
end

function bomb_land(unit, propulsion)
	if unit.phase <= unit.maxBounces then
		unit.phase = unit.phase + 1
		local deltaVector = WallPhysics:rotateVector(unit.fv, math.pi / 30)
		local randomDivisor = RandomInt(-3, 3)
		if randomDivisor == 0 then
			randomDivisor = 1
		end
		if unit.phase == 2 then
			EmitSoundOn("Trapper.BombImpact1", unit)
		else
			EmitSoundOn("Trapper.BombImpact2", unit)
		end
		local fv = unit.fv
		local bombAbility = unit:FindAbilityByName("lanaya_bomb_ability")
		bombAbility:ApplyDataDrivenModifier(unit, unit, "modifier_bomb_motion", {})
		propulsion = math.max(propulsion / (1.1 * unit.phase), 2)
		local luck = RandomInt(1, 4)
		if luck == 4 and unit.phase == unit.maxBounces + 1 then
			fv = unit.fv
		end
		bomb_jump_to_position(unit, fv, 200, 15 - (5 * (unit.phase - 1)), propulsion, 1, 1)
	else
		if unit.type == "explosive" then
			if unit.detonate then
				bomb_explode(unit)
			end
		end
	end
end

function bomb_color_think(event)
	local bomb = event.caster
	if bomb.colorPhase <= 10 then
		bomb:SetRenderColor(0, bomb.colorPhase * 24, 0)
	elseif bomb.colorPhase > 10 then
		bomb:SetRenderColor(0, 240 - bomb.colorPhase * 24, 0)
	end
	bomb.colorPhase = bomb.colorPhase + 1
	if bomb.colorPhase >= 20 then
		bomb.colorPhase = 0
	end
end

--EXPANSION FUNCTIONS
function clam_spawner_think(event)
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
	for i = 1, loops, 1 do
		local position = caster.summonCenter + RandomVector(RandomInt(1, 240))
		local zombie = nil
		if caster.special then
			zombie = Tanari:SpawnClamSpawnerUnit2(position, RandomVector(1), itemRoll, bAggro)
		else
			zombie = Tanari:SpawnClamSpawnerUnit(position, RandomVector(1), itemRoll, bAggro)
		end
		if caster.totalSummons > 12 then
			zombie:SetDeathXP(0)
			zombie:SetMaximumGoldBounty(0)
			zombie:SetMinimumGoldBounty(0)
		end
		EmitSoundOn("Tanari.ClamFishSpawn", zombie)
		CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_endcap.vpcf", zombie, 3)
		FindClearSpaceForUnit(zombie, zombie:GetAbsOrigin(), false)
		table.insert(caster.summonTable, zombie)
	end
end

function clam_spawner_die(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/mk_spherical_steam_burst.vpcf", caster, 4)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Tanari.ClamSpawnerDie", caster)
	end)
	for i = 1, 140, 1 do
		Timers:CreateTimer(i * 0.03, function()
			if IsValidEntity(caster) then
				caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 1.5))
			end
		end)
	end
end

function kraken_aoe_ability(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local baseFV = RandomVector(1)
	local basePosition = GetGroundPosition(caster:GetAbsOrigin(), caster)

	local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_water_base.vpcf", PATTACH_CUSTOMORIGIN, king)
	ParticleManager:SetParticleControl(pfx, 0, basePosition + Vector(0, 0, 30))
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 2, 200))
	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Tanari.KingKrakenAOEStart", caster)
	for i = 1, 3, 1 do
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.KrakenPumpSound", caster)
		Timers:CreateTimer(i - 0.8, function()
			for j = 0, 6, 1 do
				local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
				local torrentPosition = basePosition + WallPhysics:rotateVector(baseFV, 2 * math.pi * j / 7) * (180 * i + 300)
				ParticleManager:SetParticleControl(pfx, 0, torrentPosition)
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), torrentPosition, nil, 180, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
				for k = 1, #enemies, 1 do
					local enemy = enemies[k]
					Filters:ApplyStun(caster, 0.5, enemy)
					ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
					EmitSoundOn("Tanari.KingKrakenAOEHit", enemy)
				end
			end
		end)
	end
end

function specter_blink(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Tanari.SpecterDash", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", caster, 3)
	local fv = RandomVector(1)
	StartAnimation(caster, {duration = 1.4, activity = ACT_DOTA_FLAIL, rate = 0.7, translate = "forcestaff_friendly"})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sorceress_dashing", {duration = 0.8})
	for i = 1, 25, 1 do
		Timers:CreateTimer(i * 0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin() + fv * 32)
		end)
	end
	Timers:CreateTimer(0.75, function()
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_end_lvl2_ti5.vpcf", caster, 3)
	end)
end

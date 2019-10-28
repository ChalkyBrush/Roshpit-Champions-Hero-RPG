function use_vermillion_bundle(event)
	local caster = event.caster
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()
	local shrinePosition = Vector(-12054, -15161)
	local distance = WallPhysics:GetDistance2d(casterOrigin, Vector(-12054, -15161))
	if not Redfall.FarmlandsPortalActive then
		if distance < 120 then
			Redfall.FarmlandsPortalActive = true
			Dungeons.respawnPoint = Vector(14208, -14528)
			UTIL_Remove(ability)
			local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
			local radius = 350
			local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(particle2, 0, GetGroundPosition(shrinePosition, caster))
			ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
			ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
			ParticleManager:SetParticleControl(particle2, 4, Vector(255, 40, 0))
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(particle2, false)
			end)
			EmitSoundOnLocationWithCaster(shrinePosition, "Redfall.ActivateAsharaPortal", Redfall.RedfallMaster)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), shrinePosition, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for i = 1, #enemies, 1 do
					enemies[i]:AddNewModifier(victim, Events:GetGameMasterAbility(), "modifier_stunned", {duration = 1})
					enemies[i].pushVelocity = 32
					enemies[i].pushVector = Vector(-1, 1)
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, enemies[i], "modifier_redfall_pushback", {duration = 0.8})
				end
			end
			AddFOWViewer(DOTA_TEAM_GOODGUYS, shrinePosition, 200, 300, true)
			Timers:CreateTimer(1.0, function()
				EmitGlobalSound("ui.set_applied")
				Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-12054, -15161, 120 + Redfall.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			end)
			Redfall:SpawnFarmlandsPt1()
		else
			MinimapEvent(caster:GetTeamNumber(), caster, -12054, -15161, DOTA_MINIMAP_EVENT_BASE_UNDER_ATTACK, 4)
		end
	end
end

function FarmlandsMainPortal(trigger)
	local hero = trigger.activator
	if Redfall.FarmlandsPortalActive and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(14208, -14592)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function use_demon_relic(event)
	local caster = event.caster
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()
	local shrinePosition = Vector(15378, -14805)
	local distance = WallPhysics:GetDistance2d(casterOrigin, Vector(15378, -14805))
	if not Redfall.PromenadePortalActive then
		if distance < 120 then
			Redfall.PromenadePortalActive = true
			Dungeons.respawnPoint = Vector(14720, 14272)
			UTIL_Remove(ability)
			local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
			local radius = 350
			local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(particle2, 0, GetGroundPosition(shrinePosition, caster))
			ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
			ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
			ParticleManager:SetParticleControl(particle2, 4, Vector(255, 40, 0))
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(particle2, false)
			end)
			EmitSoundOnLocationWithCaster(shrinePosition, "Redfall.ActivateAsharaPortal", Redfall.RedfallMaster)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), shrinePosition, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for i = 1, #enemies, 1 do
					enemies[i]:AddNewModifier(victim, Events:GetGameMasterAbility(), "modifier_stunned", {duration = 1})
					enemies[i].pushVelocity = 32
					enemies[i].pushVector = Vector(-1, 1)
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, enemies[i], "modifier_redfall_pushback", {duration = 0.8})
				end
			end
			AddFOWViewer(DOTA_TEAM_GOODGUYS, shrinePosition, 200, 300, true)
			Timers:CreateTimer(1.0, function()
				EmitGlobalSound("ui.set_applied")
				Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(15367, -14805, 100 + Redfall.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			end)
			Redfall:InitiateCrimsythCastleIntro()
		else
			MinimapEvent(caster:GetTeamNumber(), caster, 15367, -14805, DOTA_MINIMAP_EVENT_BASE_UNDER_ATTACK, 4)
		end
	end
end

function PromenadePortal(trigger)
	local hero = trigger.activator
	if Redfall.PromenadePortalActive and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(14720, 14272)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function bandit_windrun_activate(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local runDirection = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		caster:MoveToPosition(enemies[1]:GetAbsOrigin() + runDirection * 300)
	else
		local runDirection = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 4)
		caster:MoveToPosition(caster:GetAbsOrigin() + runDirection * 820)
	end
end

function farmland_spawner_think(event)
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
	local maxSummons = 4
	local loops = 1
	if GameState:GetDifficultyFactor() == 2 then
		maxSummons = 7
	elseif GameState:GetDifficultyFactor() == 3 then
		maxSummons = 10
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
		local zombie = Redfall:SpawnFarmlandSpawnerUnit(position, RandomVector(1), itemRoll, bAggro)
		if caster.totalSummons > 12 then
			zombie:SetDeathXP(0)
			zombie:SetMaximumGoldBounty(0)
			zombie:SetMinimumGoldBounty(0)
		end
		EmitSoundOn("Redfall.Pumpkin.Spawner", zombie)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_beastmaster/beastmaster_call_boar_glow_base.vpcf", zombie, 3)
		FindClearSpaceForUnit(zombie, zombie:GetAbsOrigin(), false)
		table.insert(caster.summonTable, zombie)
	end

end

function FarmlandsCornTrigger1(event)
	Redfall:FarmlandsCornTrigger1()
end

function FarmlandsCornTrigger2(event)
	Redfall:FarmlandsCornTrigger2()
end

function BigFarmTrigger1(event)
	Redfall:BigFarmTrigger1()
end

function flamethinker_find_unit(event)
	local caster = event.caster
	if not caster.lock then
		caster.lock = true
		EmitSoundOn("Redfall.FireballPassive", caster)
		local position = caster:GetAbsOrigin()
		local baseFV = RandomVector(1)
		local pandaCount = 1 + GameState:GetDifficultyFactor()
		for i = 0, pandaCount, 1 do
			local fv = WallPhysics:rotateVector(baseFV, 2 * math.pi * i / (pandaCount + 1))
			Redfall:SpawnFlamePanda(position, fv, true)
		end
		Timers:CreateTimer(2.4, function()
			ParticleManager:DestroyParticle(caster.pfx, false)
			UTIL_Remove(caster)
		end)
	end
end

function shredder_passive_think(event)
	local caster = event.caster
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
	else
		return false
	end
	if caster.aggro then
		local castAbility = caster:FindAbilityByName("redfall_shredder_whirling_death")
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 295, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = castAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				return
			end
		end
	else
		local casterOrigin = caster:GetAbsOrigin()
		if not caster.interval then
			caster.interval = 0
		end
		if not caster.treeTarget then
			caster.treeTarget = Entities:FindByClassnameNearest("ent_dota_tree", casterOrigin, 550)
		end
		if not caster.treeTarget then
			return false
		end
		if not caster.treeTarget:IsStanding() then
			caster.treeTarget = Entities:FindByClassnameNearest("ent_dota_tree", casterOrigin + RandomVector(300), 550)
		end
		if not IsValidEntity(caster.treeTarget) then
			caster.treeTarget = Entities:FindByClassnameNearest("ent_dota_tree", casterOrigin + RandomVector(300), 550)
			return false
		end
		local tree = caster.treeTarget
		local distance = WallPhysics:GetDistance2d(casterOrigin, tree:GetAbsOrigin())
		if distance < 135 and tree:IsStanding() then
			local moveVector = ((tree:GetAbsOrigin() - casterOrigin) * Vector(1, 1, 0)):Normalized()
			caster:SetForwardVector(moveVector)
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1.0})
			Timers:CreateTimer(0.35, function()
				EmitSoundOn("Hero_Shredder.Attack", caster)
				GridNav:DestroyTreesAroundPoint(tree:GetAbsOrigin(), 110, false)
			end)
			caster.interval = 0
		else
			local moveVector = ((tree:GetAbsOrigin() - casterOrigin) * Vector(1, 1, 0)):Normalized()
			if tree:IsStanding() then
				caster:MoveToPosition(casterOrigin + moveVector * (distance - 80))
			end
			caster.interval = caster.interval + 1
			if caster.interval > 10 then
				local castAbility = caster:FindAbilityByName("redfall_shredder_whirling_death")
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = castAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function twisted_pumpkin_think(event)
	local caster = event.caster
	if caster.aggro then
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() + Vector(0, 0, 130))
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		Timers:CreateTimer(0.03, function()
			EmitSoundOn("Redfall.Shroom.Aggro", caster)
		end)
		caster:RemoveModifierByName("modifier_pumpkin_ai")
		StartAnimation(caster, {duration = 0.84, activity = ACT_DOTA_SPAWN, rate = 1})
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shroom_jumping", {duration = 0.81})
		local position = caster:GetAbsOrigin()
		caster.liftVelocity = 42
		for i = 1, 28, 1 do
			Timers:CreateTimer(0.03 * i, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.liftVelocity))
				caster.liftVelocity = caster.liftVelocity - 3
			end)
		end
		Timers:CreateTimer(0.84, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_pumpkin_active", {})
		end)
	end
end

function twisted_pumpkin_active_think(event)
	local caster = event.caster
	if caster:IsAlive() then
	else
		return false
	end
	if caster:IsStunned() then
		return false
	end
	if caster:HasModifier("modifier_pumpkin_ai") then
		return false
	end
	if caster.castLock then
		return false
	end
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_SPAWN, rate = 1})
		local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		caster:SetForwardVector(fv)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shroom_jumping", {duration = 1.6})
		EmitSoundOn("Redfall.PumpkinFireLaunch", caster)
		Timers:CreateTimer(0.15, function()
			caster:SetForwardVector(fv)
			twisted_pumpkin_cast(caster, ability, position, fv)
		end)
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		caster:MoveToPositionAggressive(enemies[1]:GetAbsOrigin())
	end
end

function twisted_pumpkin_cast(caster, ability, position, fv)
	local start_radius = 130
	local end_radius = 130
	local speed = 500

	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_jakiro/fireball.vpcf",
		vSpawnOrigin = position + Vector(0, 0, 205),
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

function BottomFarmlandTrigger()
	Redfall:BottomFarmlandTrigger()
end

function BottomFarmland2()
	Redfall:BottomFarmland2()
end

function BottomFarmland3()
	Redfall:BottomFarmland3()
end

function duelist_leap_cast(event)
	local caster = event.caster
	local target = event.target
	local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
	ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() + Vector(0, 0, 20))
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
	ability.acceleration = 15
	ability.randomForwardSpeed = RandomInt(0, 4)
	ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	ability.target = target
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.0})
end

function duelist_leap_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	local acceleration = ability.acceleration
	ability.acceleration = ability.acceleration - 1.5
	local directionVector = ability.directionVector
	local movespeed = ability.distance / 24 + 4 + ability.randomForwardSpeed
	caster:SetAbsOrigin(caster:GetAbsOrigin() + directionVector * movespeed + Vector(0, 0, ability.acceleration))
	if ability.acceleration <= 0 then
		if GetGroundHeight(caster:GetAbsOrigin(), caster) > (caster:GetAbsOrigin().z - 10) then
			caster:RemoveModifierByName("modifier_mountain_crush_jumping")
		end
	end
end

function duelist_leap_end(event)
	local caster = event.caster
	local radius = 320
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	EmitSoundOn("Redfall.Duelist.LeapLandVO", caster)
	FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, event.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duelist_boosted_attack", {duration = 4})
		StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_ATTACK, rate = 1.9})
		Timers:CreateTimer(0.2, function()
			caster:MoveToTargetToAttack(enemies[1])
			local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			caster:SetForwardVector(fv)
		end)
	end
	local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
	ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
end

function duelist_boosted_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local damagePercent = event.damagePercent / 100
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * damagePercent
	local ability = event.ability
	ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf", target, 1)
	EmitSoundOn("Redfall.Duelist.Crit", target)
	CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_blur_impact_energy.vpcf", target, 3)
end

function farmer_scene_think(event)
	local target = event.target
	local ability = event.ability
	if not Redfall.RedfallMasterAbility.cinemaSceneA then
		Redfall.RedfallMasterAbility.cinemaSceneA = 0
	end
	if Redfall.RedfallMasterAbility.cinemaSceneA then
		if Redfall.RedfallMasterAbility.cinemaSceneA == 0 then
			-- if not target.cinemaSceneA then
			-- target.cinemaSceneA = 0
			-- end
			if target.cinemaSceneA == 0 then
				local targetPosition = Vector(5056, -12114)
				target:MoveToPosition(targetPosition + RandomVector(80))
				local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), targetPosition)
				if distance < 130 then
					Redfall.FarmSceneSafe = true
					Redfall.dialogueTargets = Redfall.dialogueTargets + 1
					target:Stop()
					target.cinemaSceneA = 1
					ability:ApplyDataDrivenModifier(target, target, "modifier_invisibility_datadriven", {duration = 25})
					ability:ApplyDataDrivenModifier(target, target, "modifier_invisible", {duration = 25})
					target:SetForwardVector(Vector(1, 0))
					if Redfall.dialogueTargets == 1 then
						local thiefTable = {}
						local baseSpawnPos = Vector(6981, -12232)

						local spawnPos1 = baseSpawnPos + Vector(-120, 0)
						local thief1 = Redfall:SpawnCrimsythDuelist(spawnPos1, Vector(-1, 0))
						thief1.offset = Vector(-120, 0)
						table.insert(thiefTable, thief1)

						local spawnPos2 = baseSpawnPos + Vector(0, 80)
						local thief2 = Redfall:SpawnFarmlandsBandit(spawnPos1, Vector(-1, 0))
						thief2.offset = Vector(0, 80)
						table.insert(thiefTable, thief2)

						local spawnPos3 = baseSpawnPos + Vector(0, -80)
						local thief3 = Redfall:SpawnFarmlandsBandit(spawnPos1, Vector(-1, 0))
						thief3.offset = Vector(0, -80)
						table.insert(thiefTable, thief3)

						for i = 1, #thiefTable, 1 do
							local bandit = thiefTable[i]
							Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, bandit, "modifier_command_restric_player", {duration = 13})
							Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, bandit, "modifier_redfall_movable_scene", {duration = 11})
							bandit:SetBaseMoveSpeed(240)
							local banditAbility = bandit:AddAbility("redfall_farmlands_scene_ability")
							banditAbility:ApplyDataDrivenModifier(bandit, bandit, "modifier_farmlands_scene_a", {})
							CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", bandit, 3)
							Timers:CreateTimer(0.5, function()
								bandit:MoveToPosition(Vector(6030, -12288) + bandit.offset)
							end)
						end

						Timers:CreateTimer(6, function()
							Quests:ShowDialogueText({target}, thief1, "redfall_dialogue_bandit_1_a", 6, false)
							Timers:CreateTimer(4, function()
								Quests:ShowDialogueText({target}, Redfall.Farmlands.farmNPCa, "redfall_dialogue_farmer_1_d", 6, false)
							end)
							Timers:CreateTimer(7, function()
								Quests:ShowDialogueText({target}, thief1, "redfall_dialogue_bandit_1_b", 3, false)
								Timers:CreateTimer(3, function()
									Quests:ShowDialogueText({target}, thief1, "redfall_dialogue_bandit_1_b2", 4, false)
									thief2:MoveToPosition(thief2:GetAbsOrigin() + Vector(-330, 0, 0))
									thief3:MoveToPosition(thief3:GetAbsOrigin() + Vector(-330, 0, 0))
									Timers:CreateTimer(1.1, function()
										Quests:ShowDialogueText({target}, Redfall.Farmlands.farmNPCa, "redfall_dialogue_farmer_1_e", 3, false)
										Timers:CreateTimer(1, function()
											Quests:ShowDialogueText({target}, thief2, "redfall_dialogue_bandit_1_c", 3, false)
											for j = 1, #thiefTable, 1 do
												local bandit = thiefTable[j]
												bandit:RemoveModifierByName("modifier_command_restric_player")
												bandit:SetBaseMoveSpeed(400)
											end
										end)
										for i = 1, #Redfall.Farmlands.FarmerSceneAHeroes, 1 do
											local hero = Redfall.Farmlands.FarmerSceneAHeroes[i]
											hero:RemoveModifierByName("modifier_redfall_farmer_scene")
											hero:RemoveModifierByName("modifier_invisibility_datadriven")
											hero:RemoveModifierByName("modifier_invisible")
											WallPhysics:Jump(hero, Vector(1, 0), 28, 21, 25, 1)
										end
									end)
								end)
							end)
						end)
					end
				end
			else
				target:SetForwardVector(Vector(1, 0))
			end
		end
	end
end

function farmlands_scene_a_death(event)
	if not Redfall.Farmlands.SceneADeaths then
		Redfall.Farmlands.SceneADeaths = 0
	end
	Redfall.Farmlands.SceneADeaths = Redfall.Farmlands.SceneADeaths + 1
	if Redfall.Farmlands.SceneADeaths == 3 then
		Redfall:EndFarmerSceneA()
	end
end

function FarmlandsWestTrigger1()
	Redfall:FarmlandsWestTrigger1()
end

function bandit_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local prismMult = event.prism_strike
	local ability = event.ability
	if not target then
		return
	end
	if not target:IsHero() then
		return
	end
	local targetGetStrength = target:GetStrength()
	local targetGetAgility = target:GetAgility()
	local targetGetIntellect = target:GetIntellect()
	local targetGetSpirit = target:GetSpirit()
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", target, 2)
	if targetGetStrength then
		Timers:CreateTimer(0.1, function()
			local damage = targetGetStrength * prismMult
			ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			EmitSoundOn("Redfall.Bandit.PrismStrikeImpact", target)

			local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/prism_strike.vpcf", PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 1, Vector(255, 50, 50))
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
	if targetGetAgility then
		Timers:CreateTimer(0.2, function()
			local damage = targetGetAgility * prismMult
			ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			EmitSoundOn("Redfall.Bandit.PrismStrikeImpact", target)

			local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/prism_strike.vpcf", PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 1, Vector(50, 255, 50))
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
	if targetGetIntellect then
		Timers:CreateTimer(0.3, function()
			local damage = targetGetIntellect * prismMult
			ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			EmitSoundOn("Redfall.Bandit.PrismStrikeImpact", target)

			local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/prism_strike.vpcf", PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 1, Vector(50, 50, 255))
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
	if targetGetSpirit then
		Timers:CreateTimer(0.4, function()
			local damage = targetGetSpirit * prismMult
			ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			EmitSoundOn("Redfall.Bandit.PrismStrikeImpact", target)

			local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/prism_strike.vpcf", PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 1, Vector(255, 50, 255))
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function FarmlandsCenterTrigger1()
	Redfall:FarmlandsCenterTrigger1()
end

function farmlands_scene_b_death(event)
	if not Redfall.Farmlands.SceneBDeaths then
		Redfall.Farmlands.SceneBDeaths = 0
	end
	Redfall.Farmlands.SceneBDeaths = Redfall.Farmlands.SceneBDeaths + 1
	if Redfall.Farmlands.SceneBDeaths == 4 then
		Redfall:EndFarmerSceneB()
	end
end

function FarmlandsWesternTrigger()
	Redfall:FarmlandsWesternTrigger()
end

function FarmlandsCornTrigger3()
	Redfall:FarmlandsCornTrigger3()
end

function task_armor_init(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_task_armor", {})
	caster:SetModifierStackCount("modifier_task_armor", caster, event.charges)
end

function taskmaster_think(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("redfall_bloodlust")
	if IsValidEntity(castAbility) then
		if castAbility:IsFullyCastable() then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
			if #allies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = allies[1]:entindex(),
					AbilityIndex = castAbility:entindex(),
				}
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.AutumnTaskmaster.Cast", caster)
				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function FarmlandsCenterTrigger2()
	Redfall:FarmlandsCenterTrigger2()
end

function FarmlandsWestTrigger2()
	Redfall:FarmlandsWestTrigger2()
end

function farmlands_scene_c_death(event)
	if not Redfall.Farmlands.SceneCDeaths then
		Redfall.Farmlands.SceneCDeaths = 0
	end
	Redfall.Farmlands.SceneCDeaths = Redfall.Farmlands.SceneCDeaths + 1
	if Redfall.Farmlands.SceneCDeaths == 3 then
		Redfall:Farm3Event(2)
	elseif Redfall.Farmlands.SceneCDeaths == 6 then
		Redfall:Farm3Event(3)
	elseif Redfall.Farmlands.SceneCDeaths == 9 then
		Redfall:Farm3Event(4)
	elseif Redfall.Farmlands.SceneCDeaths == 12 then
		Redfall:Farm3Event(5)
	elseif Redfall.Farmlands.SceneCDeaths == 15 then
		Redfall:EndFarmerSceneC()
	end
end

function farmlands_scene_c_distance_check(event)
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(5184, -5440))
	if distance < 130 then
		caster:MoveToPositionAggressive(Vector(5760, -6976))
	end
end

function recruiter_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	-- CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", target, 3)
	ability:ApplyDataDrivenModifier(attacker, target, "modifier_crimsyth_recruiter_armor_loss", {duration = 7})
	ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_crimsyth_recruiter_attack_gain", {duration = 7})
	local armorStacks = target:GetModifierStackCount("modifier_crimsyth_recruiter_armor_loss", attacker) + 1
	target:SetModifierStackCount("modifier_crimsyth_recruiter_armor_loss", attacker, armorStacks)
	local attackStacks = attacker:GetModifierStackCount("modifier_crimsyth_recruiter_attack_gain", attacker) + 1
	attacker:SetModifierStackCount("modifier_crimsyth_recruiter_attack_gain", attacker, attackStacks)
	target:CalculateAndSaveRoshpitAttributes()
	attacker:CalculateAndSaveRoshpitAttributes()
end

function FarmlandsEastTrigger1()
	Redfall:FarmlandsEastTrigger1()
end

function FarmlandsWestTrigger4()
	Redfall:FarmlandsWestTrigger4()
end

function FarmlandsNorthTrigger1()
	Redfall:FarmlandsNorthTrigger1()
end

function FarmlandsLastHouseSpawn(trigger)
	Redfall:FarmlandsLastHouseSpawn(trigger.activator)
end

function farmlands_scene_d_death(event)
	if not Redfall.Farmlands.SceneDDeaths then
		Redfall.Farmlands.SceneDDeaths = 0
	end
	Redfall.Farmlands.SceneDDeaths = Redfall.Farmlands.SceneDDeaths + 1
	if Redfall.Farmlands.SceneDDeaths == 7 then
		Redfall:IncrementFarmlandsQuest()
		Redfall:FinalFarmlandsScene()
	end
end

function demon_farmer_die(event)
	local caster = event.caster
	Timers:CreateTimer(1.5, function()
		--print("GO!")
		local ghostMeepo = CreateUnitByName("redfall_meepo_farmer", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
		ghostMeepo:SetAbsOrigin(ghostMeepo:GetAbsOrigin() + Vector(0, 0, 160))
		ghostMeepo:SetDayTimeVisionRange(500)
		ghostMeepo:SetNightTimeVisionRange(500)
		ghostMeepo:SetBaseMoveSpeed(300)

		ghostMeepo:SetRenderColor(242, 255, 88)
		ghostMeepo:SetForwardVector(caster:GetForwardVector() *- 1)
		ghostMeepo:AddAbility("redfall_meepo_farmer_ghost_passive"):SetLevel(1)
		EmitSoundOn("Redfall.Farmer.GhostSound", ghostMeepo)
		WallPhysics:Jump(ghostMeepo, caster:GetForwardVector() *- 1, 10, 12, 22, 1)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", ghostMeepo, 3)
		Timers:CreateTimer(0.2, function()
			StartAnimation(ghostMeepo, {duration = 1.2, activity = ACT_DOTA_SPAWN, rate = 0.5})
		end)
		Timers:CreateTimer(1.05, function()
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", ghostMeepo, 3)
		end)
		Timers:CreateTimer(1.7, function()
			EmitSoundOn("Redfall.Farmer.MeepoGhostVO", ghostMeepo)
		end)

	end)
end

function meepo_farmer_guide_think(event)
	local ability = event.ability
	local caster = event.caster
	if caster.lock then
		return false
	end
	local distance = 100
	if ability.lastPos then
		distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), ability.lastPos)
	end
	caster:MoveToPosition(Vector(10640, -417))
	if distance < 5 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_temporary_flying", {duration = 1.1})
	end
	ability.lastPos = caster:GetAbsOrigin()
	local distanceToTarget = WallPhysics:GetDistance(caster:GetAbsOrigin() * Vector(1, 1, 0), Vector(10640, -417))
	if distanceToTarget < 100 then
		caster.lock = true
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
		Timers:CreateTimer(1, function()

			local walls = Entities:FindAllByNameWithin("BackFarmExitWall", Vector(10785, -590, 170 + Redfall.ZFLOAT), 600)
			Redfall:FarmWalls(false, walls, true, 3.0)
			Timers:CreateTimer(3, function()
				local blockers = Entities:FindAllByNameWithin("BackFarmExitBlocker", Vector(10812, -512, 100 + Redfall.ZFLOAT), 900)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
		end)
		Timers:CreateTimer(5, function()
			EmitSoundOn("Redfall.Farmer.GhostSound", caster)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster, 3)
			Timers:CreateTimer(0.8, function()
				local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
				Timers:CreateTimer(2.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				UTIL_Remove(caster)
			end)
		end)
	end
end

function demon_farmer_aura_stat_loss(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local percentage = event.stat_loss_percent / 100
	local intStacks = math.floor((target:GetIntellect() + target:GetModifierStackCount("modifier_demon_farmer_aura_int", ability)) * percentage)
	local agiStacks = math.floor((target:GetAgility() + target:GetModifierStackCount("modifier_demon_farmer_aura_agi", ability)) * percentage)
	local strStacks = math.floor((target:GetStrength() + target:GetModifierStackCount("modifier_demon_farmer_aura_str", ability)) * percentage)
	local spiStacks = math.floor((target:GetSpirit() + target:GetModifierStackCount("modifier_demon_farmer_aura_spi", ability)) * percentage)
	if not target:HasModifier("modifier_demon_farmer_aura_str") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_demon_farmer_aura_str", {})
	end
	target:SetModifierStackCount("modifier_demon_farmer_aura_str", ability, strStacks)

	if not target:HasModifier("modifier_demon_farmer_aura_agi") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_demon_farmer_aura_agi", {})
	end
	target:SetModifierStackCount("modifier_demon_farmer_aura_agi", ability, agiStacks)

	if not target:HasModifier("modifier_demon_farmer_aura_int") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_demon_farmer_aura_int", {})
	end
	target:SetModifierStackCount("modifier_demon_farmer_aura_int", ability, intStacks)

	if not target:HasModifier("modifier_demon_farmer_aura_spi") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_demon_farmer_aura_spi", {})
	end
	target:SetModifierStackCount("modifier_demon_farmer_aura_spi", ability, spiStacks)
	
end

function demon_farmer_think(event)
	local caster = event.caster
	if caster.summonState == 0 then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.75 then
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1.0})
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.Farmlands.DemonSpawn", Events.GameMaster)
			local summonLoops = 3
			for i = 1, summonLoops, 1 do
				local spawnPoint = caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / summonLoops) * 120
				local thief = Redfall:SpawnCrimsythRecruiterAggro(spawnPoint, caster:GetForwardVector())
				CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", thief, 3)
			end
			caster.summonState = 1
		end
	elseif caster.summonState == 1 then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.5 then
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1.0})
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.Farmlands.DemonSpawn", Events.GameMaster)
			local summonLoops = 4
			for i = 1, summonLoops, 1 do
				local spawnPoint = caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / summonLoops) * 120
				local thief = Redfall:SpawnCrimsythRecruiterAggro(spawnPoint, caster:GetForwardVector())
				CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", thief, 3)
			end
			caster.summonState = 2
		end
	elseif caster.summonState == 2 then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.25 then
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1.0})
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.Farmlands.DemonSpawn", Events.GameMaster)
			local summonLoops = 5
			for i = 1, summonLoops, 1 do
				local spawnPoint = caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / summonLoops) * 120
				local thief = Redfall:SpawnCrimsythRecruiterAggro(spawnPoint, caster:GetForwardVector())
				CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", thief, 3)
			end
			caster.summonState = 3
		end
	end
end

function ShipyardBackSwitchTrigger(trigger)
	local hero = trigger.activator
	Redfall:ActivateSwitchGeneric(Vector(12074, -3746, -517 + Redfall.ZFLOAT), "ShipyardBackSwitch", true, 0.16)
	Timers:CreateTimer(1, function()
		Dungeons:CreateBasicCameraLockForHeroes(Vector(11008, 1216), 4, {hero})
		Redfall.BackSwitchesActive = true
		Redfall.BackSwitchCurrentAnimals = {"pig", "pig", "pig", "pig"}
		for j = 1, 40, 1 do
			Timers:CreateTimer(j * 0.03, function()
				for k = 1, #Redfall.BackSwitches, 1 do
					Redfall.BackSwitches[k]:SetAbsOrigin(Redfall.BackSwitches[k]:GetAbsOrigin() + Vector(0, 0, 12))
					if j == 40 then
						local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
						local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
						ParticleManager:SetParticleControl(particle1, 0, Redfall.BackSwitches[k]:GetAbsOrigin())
						Timers:CreateTimer(1, function()
							ParticleManager:DestroyParticle(particle1, false)
						end)
						local particle = "particles/roshpit/redfall/tree_healed.vpcf"
						local pfxA = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
						ParticleManager:SetParticleControl(pfxA, 0, Redfall.BackSwitches[k]:GetAbsOrigin() - Vector(0, 0, 100))
						ParticleManager:SetParticleControl(pfxA, 1, Redfall.BackSwitches[k]:GetAbsOrigin() - Vector(0, 0, 100))
						ParticleManager:SetParticleControl(pfxA, 2, Vector(0, 1))
						Timers:CreateTimer(7.5, function()
							ParticleManager:DestroyParticle(pfxA, false)
						end)
						EmitSoundOnLocationWithCaster(Vector(11008, 1216), "Redfall.TreeHealed", Redfall.RedfallMaster)
					end
				end
			end)
		end
	end)
end

function BackAnimalSwitchA()
	local switchIndex = 1
	if Redfall.BackSwitchesActive then
		local switchAnimal = cycleSwitchAnimal(switchIndex)
		Redfall.BackSwitches[switchIndex]:SetModel("models/animal_plate_"..switchAnimal..".vmdl")
		CheckSwitchCondition()
	end
end

function BackAnimalSwitchB()
	local switchIndex = 2
	if Redfall.BackSwitchesActive then
		local switchAnimal = cycleSwitchAnimal(switchIndex)
		Redfall.BackSwitches[switchIndex]:SetModel("models/animal_plate_"..switchAnimal..".vmdl")
		CheckSwitchCondition()
	end
end

function BackAnimalSwitchC()
	local switchIndex = 3
	if Redfall.BackSwitchesActive then
		local switchAnimal = cycleSwitchAnimal(switchIndex)
		Redfall.BackSwitches[switchIndex]:SetModel("models/animal_plate_"..switchAnimal..".vmdl")
		CheckSwitchCondition()
	end
end

function BackAnimalSwitchD()
	local switchIndex = 4
	if Redfall.BackSwitchesActive then
		local switchAnimal = cycleSwitchAnimal(switchIndex)
		Redfall.BackSwitches[switchIndex]:SetModel("models/animal_plate_"..switchAnimal..".vmdl")
		CheckSwitchCondition()
	end
end

function cycleSwitchAnimal(switchIndex)
	EmitSoundOnLocationWithCaster(Redfall.BackSwitches[switchIndex]:GetAbsOrigin(), "Redfall.Farmlands.SwitchPress", Events.GameMaster)
	local animalTable = {"pig", "rabbit", "rat", "rooster"}
	for i = 1, #animalTable, 1 do
		if animalTable[i] == Redfall.BackSwitchCurrentAnimals[switchIndex] then
			local animalIndex = i + 1
			if animalIndex > #animalTable then
				animalIndex = animalIndex - #animalTable
			end
			Redfall.BackSwitchCurrentAnimals[switchIndex] = animalTable[animalIndex]
			return animalTable[animalIndex]
		end
	end
end

function CheckSwitchCondition()
	local condition = true
	for i = 1, #Redfall.CorrectAnimalTable, 1 do
		if Redfall.CorrectAnimalTable[i] == Redfall.BackSwitchCurrentAnimals[i] then
		else
			condition = false
		end
	end
	if condition then
		EmitSoundOnLocationWithCaster(Vector(10982, 1070), "Redfall.Farmlands.SwitchPuzzleComplete", Events.GameMaster)
		Redfall.BackSwitchesActive = false
		Redfall.BackSwitchPuzzleCompleted = true
		local position = Vector(12004, 1856, -300)
		local moveVector = Vector(0, 0, 600 / 180)
		for j = 1, 180, 1 do
			Timers:CreateTimer(j * 0.03, function()

				Redfall.ShipyardBackBridge:SetAbsOrigin(Redfall.ShipyardBackBridge:GetAbsOrigin() + moveVector)
				if j % 30 == 0 then
					ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
					EmitSoundOnLocationWithCaster(position, "Redfall.TreeRising", Redfall.RedfallMaster)
					local pfxX = ParticleManager:CreateParticle("particles/dire_fx/dire_lfr_smoke_19sec.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
					ParticleManager:SetParticleControl(pfxX, 0, position)
					Timers:CreateTimer(10, function()
						ParticleManager:DestroyParticle(pfxX, false)
					end)
					local vectorTable = {Vector(11776, 1728, -610), Vector(11776, 1984, -610), Vector(11776, 2240, -610), Vector(11776, 1528, -610), Vector(12233, 2240, -610), Vector(12233, 1728, -610), Vector(12233, 2028, -610), Vector(12233, 1528, -610)}
					local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
					for i = 1, #vectorTable, 1 do
						local position = vectorTable[i] + Vector(0, 0, Redfall.ZFLOAT - 20)
						local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
						ParticleManager:SetParticleControl(pfx, 0, position)
						Timers:CreateTimer(2, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end
				end
				if j == 180 then
					EmitSoundOnLocationWithCaster(position, "Redfall.TreeHealedMain", Events.GameMaster)
					EmitSoundOnLocationWithCaster(position, "Redfall.TreeHealed", Redfall.RedfallMaster)
				end
			end)
		end
		Timers:CreateTimer(6.5, function()
			local blockers = Entities:FindAllByNameWithin("ShipyardKeyBridgeBlocker", Vector(11978, 1600, -578 + Redfall.ZFLOAT), 5000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end
end

function BackFarmChestTrigger()
	if Beacons.cheats then
		Redfall:BackFarmChestTrigger()
		return false
	end
	if Redfall.BackSwitchPuzzleCompleted then
		if not Redfall.KeyChestOpened then
			Redfall.KeyChestOpened = true
			Redfall:BackFarmChestTrigger()
		end
	end

end

function use_shipyard_key(event)
	local caster = event.caster
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()
	local distance = WallPhysics:GetDistance(casterOrigin * Vector(1, 1, 0), Vector(14896, -10816))
	Dungeons.respawnPoint = Vector(14896, -10816)

	if distance < 130 then
		if not Redfall.ShipyardOpen then
			Redfall.ShipyardOpen = true
			UTIL_Remove(ability)
			local particlePosition = Vector(14896, -10816, 20 + Redfall.ZFLOAT)
			local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall_indicator_allied_wind.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(pfx, 10, particlePosition)
			ParticleManager:SetParticleControl(pfx, 0, particlePosition)
			ParticleManager:SetParticleControl(pfx, 1, particlePosition)
			ParticleManager:SetParticleControl(pfx, 2, particlePosition)
			ParticleManager:SetParticleControl(pfx, 3, particlePosition)
			EmitGlobalSound("Redfall.TreeHealedMain")
			Redfall:OpenAbandonedShipyard()
		else
			EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
		end
	else
		MinimapEvent(caster:GetTeamNumber(), caster, 14896, -10816, DOTA_MINIMAP_EVENT_BASE_UNDER_ATTACK, 4)
		EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
	end

end

function TinyRoomTrigger(trigger)
	local hero = trigger.activator
	Redfall:ActivateSwitchGeneric(Vector(6819, -14850, 124 + Redfall.ZFLOAT), "TinyRoomSwitch", true, 0.165)
	Timers:CreateTimer(1, function()
		Dungeons:CreateBasicCameraLockForHeroes(Vector(11787, -9938), 2.1, {hero})
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(11787, -9938), 600, 6, false)
		local walls = Entities:FindAllByNameWithin("RubyTinyWall", Vector(11787, -9938, 128 + Redfall.ZFLOAT), 1000)
		Redfall:Walls(false, walls, true, 3.51)
		Timers:CreateTimer(3, function()
			local blockers = Entities:FindAllByNameWithin("RubyTinyBlocker", Vector(11720, -9984, 159 + Redfall.ZFLOAT), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
		Redfall:SpawnRubyGiant(Vector(13546, -10000), Vector(-1, 0))
	end)
end

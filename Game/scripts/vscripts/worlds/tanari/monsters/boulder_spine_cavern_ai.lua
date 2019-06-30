function cave_unit_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Tanari.BoulderSpine.counter then
		Tanari.BoulderSpine.counter = 0
	end
	Tanari.BoulderSpine.counter = Tanari.BoulderSpine.counter + 1
	if Tanari.BoulderSpine.counter == 40 then
		spawnPart2()
	end
	if Tanari.BoulderSpine.counter == 85 then
		spawnPart3()
	end
	if Tanari.BoulderSpine.counter == 125 then
		spawnPart4()
	end
	if Tanari.BoulderSpine.counter == 145 then
		spawnPart5()
	end
	if Tanari.BoulderSpine.counter == 192 then
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		Dungeons:CreateBasicCameraLockForHeroes(Vector(3616, 8229), 3, allies)
		Timers:CreateTimer(0.5, function()
			EmitSoundOnLocationWithCaster(Vector(3616, 8229), "Tanari.KeyHolder.WindBreath", Events.GameMaster)
			ParticleManager:DestroyParticle(Tanari.BoulderSpine.wallParticle1, false)
		end)
		Timers:CreateTimer(1.75, function()
			EmitGlobalSound("Tanari.HarpMystery")
		end)
		UTIL_Remove(Tanari.caveBlocker11)
		UTIL_Remove(Tanari.caveBlocker12)
		UTIL_Remove(Tanari.caveBlocker13)
		UTIL_Remove(Tanari.caveBlocker14)
		UTIL_Remove(Tanari.caveBlocker15)
		UTIL_Remove(Tanari.caveBlocker16)
		for i = 1, #Tanari.BoulderSpine.particleTable, 1 do
			ParticleManager:DestroyParticle(Tanari.BoulderSpine.particleTable[i], false)
		end
		Timers:CreateTimer(3, function()
			Tanari:SpawnCaveRoom2()
		end)
	end
end

function spawnPart2()
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle1, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle2, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle3, false)
	local spawnPosition1 = Vector(1472, 7424, 620)
	local spawnPosition2 = Vector(3072, 7424, 620)
	local spawnPosition3 = Vector(1472, 6720, 620)
	local spawnPosition4 = Vector(3008, 6720, 620)
	local particleName = "particles/radiant_fx2/cave_summon_destruction_growinitsphere.vpcf"
	Tanari.BoulderSpine.spawnParticle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 0, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 1, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 2, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 3, spawnPosition1)
	Tanari.BoulderSpine.spawnParticle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 0, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 1, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 2, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 3, spawnPosition2)
	Tanari.BoulderSpine.spawnParticle3 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 0, spawnPosition3)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 1, spawnPosition3)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 2, spawnPosition3)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 3, spawnPosition3)
	Tanari.BoulderSpine.spawnParticle4 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle4, 0, spawnPosition4)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle4, 1, spawnPosition4)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle4, 2, spawnPosition4)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle4, 3, spawnPosition4)
	EmitSoundOnLocationWithCaster(spawnPosition4, "Tanari.Boulderspine.BeaconTouch", Events.GameMaster)

	Timers:CreateTimer(3, function()
		Tanari:SpawnWaveUnit("boulderspine_dimension_warper", spawnPosition1, 12, 47, true)
		Tanari:SpawnWaveUnit("boulderspine_dimension_jumper", spawnPosition2, 12, 47, false)
		Tanari:SpawnWaveUnit("boulderspine_dimension_warper", spawnPosition3, 12, 47, false)
		Tanari:SpawnWaveUnit("boulderspine_dimension_jumper", spawnPosition4, 12, 47, false)
	end)
end

function spawnPart3()
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle1, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle2, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle3, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle4, false)
	local spawnPosition1 = Vector(2112, 7488, 620)
	local spawnPosition2 = Vector(1792, 6976, 620)
	local spawnPosition3 = Vector(2432, 6976, 620)
	local particleName = "particles/radiant_fx2/cave_summon_destruction_growinitsphere.vpcf"
	Tanari.BoulderSpine.spawnParticle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 0, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 1, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 2, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 3, spawnPosition1)
	Tanari.BoulderSpine.spawnParticle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 0, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 1, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 2, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 3, spawnPosition2)
	Tanari.BoulderSpine.spawnParticle3 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 0, spawnPosition3)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 1, spawnPosition3)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 2, spawnPosition3)
	EmitSoundOnLocationWithCaster(spawnPosition3, "Tanari.Boulderspine.BeaconTouch", Events.GameMaster)

	Timers:CreateTimer(3, function()
		Tanari:SpawnWaveUnit("boulderspine_freeze_fiend", spawnPosition1, 14, 47, true)
		Tanari:SpawnWaveUnit("boulderspine_ancient_golem", spawnPosition2, 14, 47, false)
		Tanari:SpawnWaveUnit("boulderspine_rock_golem", spawnPosition3, 14, 47, false)
	end)
end

function spawnPart4()
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle1, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle2, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle3, false)
	local spawnPosition1 = Vector(1472, 7424, 620)
	local spawnPosition2 = Vector(3072, 7424, 620)
	local spawnPosition3 = Vector(1472, 6720, 620)
	local spawnPosition4 = Vector(3008, 6720, 620)
	local particleName = "particles/radiant_fx2/cave_summon_destruction_growinitsphere.vpcf"
	Tanari.BoulderSpine.spawnParticle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 0, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 1, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 2, spawnPosition1)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle1, 3, spawnPosition1)
	Tanari.BoulderSpine.spawnParticle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 0, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 1, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 2, spawnPosition2)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle2, 3, spawnPosition2)
	Tanari.BoulderSpine.spawnParticle3 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 0, spawnPosition3)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 1, spawnPosition3)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 2, spawnPosition3)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle3, 3, spawnPosition3)
	Tanari.BoulderSpine.spawnParticle4 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle4, 0, spawnPosition4)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle4, 1, spawnPosition4)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle4, 2, spawnPosition4)
	ParticleManager:SetParticleControl(Tanari.BoulderSpine.spawnParticle4, 3, spawnPosition4)
	EmitSoundOnLocationWithCaster(spawnPosition4, "Tanari.Boulderspine.BeaconTouch", Events.GameMaster)

	Timers:CreateTimer(3, function()
		Tanari:SpawnWaveUnit("boulderspine_baron_razor", spawnPosition1, 5, 47, true)
		Tanari:SpawnWaveUnit("boulderspine_terror", spawnPosition2, 5, 47, false)
		Tanari:SpawnWaveUnit("boulderspine_terror", spawnPosition3, 5, 47, false)
		Tanari:SpawnWaveUnit("boulderspine_baron_razor", spawnPosition4, 5, 47, false)
	end)
end

function spawnPart5()
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle1, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle2, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle3, false)
	ParticleManager:DestroyParticle(Tanari.BoulderSpine.spawnParticle4, false)
	local portalPositionTable = {}
	local portalParticleTable = {}
	for i = 1, 10, 1 do
		local bottomLeftPos = Vector(832, 6600)
		local randomX = RandomInt(1, 2600)
		local randomY = RandomInt(1, 1200)
		table.insert(portalPositionTable, bottomLeftPos + Vector(randomX, randomY))
	end
	EmitSoundOnLocationWithCaster(portalPositionTable[1], "Tanari.Boulderspine.BeaconTouch", Events.GameMaster)
	EmitSoundOnLocationWithCaster(portalPositionTable[2], "Tanari.Boulderspine.BeaconTouch", Events.GameMaster)
	EmitSoundOnLocationWithCaster(portalPositionTable[3], "Tanari.Boulderspine.BeaconTouch", Events.GameMaster)

	local particleName = "particles/radiant_fx2/cave_summon_destruction_growinitsphere.vpcf"
	for i = 1, 10, 1 do
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, portalPositionTable[i] + Vector(0, 0, 620))
		ParticleManager:SetParticleControl(pfx, 1, portalPositionTable[i] + Vector(0, 0, 620))
		ParticleManager:SetParticleControl(pfx, 2, portalPositionTable[i] + Vector(0, 0, 620))
		ParticleManager:SetParticleControl(pfx, 3, portalPositionTable[i] + Vector(0, 0, 620))
		table.insert(portalParticleTable, pfx)
	end
	Tanari.BoulderSpine.particleTable = portalParticleTable
	Timers:CreateTimer(3, function()
		Tanari:SpawnWaveUnit("boulderspine_freeze_fiend", portalPositionTable[1], 5, 47, true)
		Tanari:SpawnWaveUnit("boulderspine_ancient_golem", portalPositionTable[2], 5, 47, false)
		Tanari:SpawnWaveUnit("boulderspine_rock_golem", portalPositionTable[3], 5, 47, false)
		Tanari:SpawnWaveUnit("boulderspine_baron_razor", portalPositionTable[4], 5, 47, false)
		Tanari:SpawnWaveUnit("boulderspine_terror", portalPositionTable[5], 5, 47, false)
		Timers:CreateTimer(1.35, function()
			Tanari:SpawnWaveUnit("depth_demon", portalPositionTable[6], 5, 47, false)
			Tanari:SpawnWaveUnit("blood_fiend", portalPositionTable[7], 5, 47, false)
			Tanari:SpawnWaveUnit("cave_stalker", portalPositionTable[8], 5, 47, false)
			Tanari:SpawnWaveUnit("boulderspine_dimension_jumper", portalPositionTable[9], 5, 47, false)
			Tanari:SpawnWaveUnit("boulderspine_dimension_warper", portalPositionTable[10], 5, 47, false)
		end)
	end)
end

function SpawnMudGolems()
	for i = 1, 20, 1 do
		Timers:CreateTimer(i * 0.2, function()
			Tanari:SpawnMudGolem(Vector(1088, 9344), Vector(0, -1))
		end)
	end
	Tanari:SpawnViperRoom()
end

function egg_hit(event)
	local caster = event.unit
	if not Tanari.EggsHatching then
		Tanari.EggsHatching = 0
	end
	if not caster.hatching and Tanari.EggsHatching < 4 then
		Tanari.EggsHatching = Tanari.EggsHatching + 1
		caster.hatching = true
		for i = 1, 20, 1 do
			Timers:CreateTimer(i * 0.03, function()
				if i % 2 == 0 then
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(7, 7, 0))
				else
					caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(7, 7, 0))
				end
			end)
		end
		Timers:CreateTimer(0.65, function()
			Tanari:SpawnGreenViper(caster:GetAbsOrigin(), RandomVector(1))
			EmitSoundOn("Tanari.Boulderspine.EggHatch", caster)
			local currentScale = caster:GetModelScale()
			local eggShell = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = caster:GetAbsOrigin()})
			local randomIndex = RandomInt(1, 4)
			local modelName = "models/props_winter/egg_shatter_0"..randomIndex..".vmdl"
			eggShell:SetModel(modelName)
			eggShell:SetModelScale(currentScale)
			eggShell:SetRenderColor(95, 145, 92)
			UTIL_Remove(caster)
			Timers:CreateTimer(60, function()
				UTIL_Remove(eggShell)
			end)
		end)
		Timers:CreateTimer(3.0, function()
			Tanari.EggsHatching = Tanari.EggsHatching - 1
		end)
	end
end

function spike_damage(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Tanari.Spikes", target)
	local damage = target:GetMaxHealth() * 0.03
	ApplyDamage({victim = target, attacker = Events.GameMaster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	PopupDamage(target, damage)
end

function spikes_enter(trigger)
	local hero = trigger.activator
	local ability = Events.GameMaster:FindAbilityByName("npc_abilities")
	ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_spike_damage_boulderspine", {duration = 5000})
end

function spikes_leave(trigger)
	local hero = trigger.activator
	hero:RemoveModifierByName("modifier_spike_damage_boulderspine")
	Timers:CreateTimer(0.15, function()
		hero:RemoveModifierByName("modifier_spike_damage_boulderspine")
	end)
	Timers:CreateTimer(0.35, function()
		hero:RemoveModifierByName("modifier_spike_damage_boulderspine")
	end)
end

function BoulderspineSpikeSpawn(trigger)
	Tanari:SpawnSpikeRoom()
end

function SpawnSpikeBats()
	for i = 1, 10, 1 do
		Timers:CreateTimer(i * 0.25, function()
			Tanari:SpawnFireBat(Vector(1664, 12256) + Vector(109 * i, 0), Vector(0, -1))
		end)
	end
	Timers:CreateTimer(2, function()
		for i = 1, 10, 1 do
			Timers:CreateTimer(i * 0.25, function()
				Tanari:SpawnFireBat(Vector(2049, 11563) + Vector(125 * i, 0), Vector(0, 1))
			end)
		end
	end)
end

function living_ice_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	Tanari.BoulderSpine.iceKilled = Tanari.BoulderSpine.iceKilled + 1
	if Tanari.BoulderSpine.iceKilled < 240 then
		Timers:CreateTimer(1.5, function()
			Tanari:SpawnLivingIceBoulderspinePosition(true)
		end)
	end
	if Tanari.BoulderSpine.iceKilled > 180 and not Tanari.BoulderSpine.dragonSpawned then
		Tanari.BoulderSpine.dragonSpawned = true
		Tanari:SpawnLindworm()
	end
end

function lindworm_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	local radius = 1200
	local castAbility = caster:FindAbilityByName("lindworm_splinter_blast")
	local cooldown = 3
	local targetFindOrder = FIND_ANY_ORDER
	if caster.interval % cooldown == 0 and caster.aggro then
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, targetFindOrder, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = castAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
	caster.interval = caster.interval + 1
	if caster.interval > 100 then
		caster.interval = 1
	end
end

function eternal_ice_start(event)
	local caster = event.caster
	for i = 1, 40, 1 do
		Timers:CreateTimer(i * 0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 4))
		end)
	end
end

function eternal_ice_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.intervalIce then
		caster.intervalIce = 1
	end

	local healAmount = math.floor(caster:GetMaxHealth() * 0.02)
	caster:Heal(healAmount, caster)
	PopupHealing(caster, healAmount)
	caster.intervalIce = caster.intervalIce + 1
	if caster.intervalIce % 5 == 0 then
		local caster = event.caster
		local ability = event.ability
		local position = caster:GetAbsOrigin()
		local radius = 550
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOn("Tanari.FrostWyrmSpecialIce", caster)
			for _, enemy in pairs(enemies) do
				local info =
				{
					Target = enemy,
					Source = caster,
					Ability = ability,
					EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
					StartPosition = "attach_hitloc",
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = false,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					flExpireTime = GameRules:GetGameTime() + 4,
					bProvidesVision = true,
					iVisionRadius = 0,
					iMoveSpeed = 500,
				iVisionTeamNumber = caster:GetTeamNumber()}
				projectile = ProjectileManager:CreateTrackingProjectile(info)

			end
		end
	end
	if caster.intervalIce > 100 then
		caster.intervalIce = 1
	end
end

function wyrm_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	if not caster.encasesBase then
		caster.encasesBase = 0
	end
	if not caster.encasesOverflow then
		caster.encasesOverflow = 0
	end
	if damage > caster:GetMaxHealth() * 0.4 then
		if caster.encasesOverflow < 5 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_lindworm_encased_in_ice", {duration = 5})
			caster.encasesOverflow = caster.encasesOverflow + 1
		end
	end
	if caster:GetHealth() < caster:GetMaxHealth() * 0.5 then
		if caster.encasesBase < 3 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_lindworm_encased_in_ice", {duration = 7})
			caster.encasesBase = caster.encasesBase + 1
		else
			caster:RemoveModifierByName("modifier_lindworm_min_health")
		end
	end
end

function frost_wyrm_die(event)
	local caster = event.caster
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	Tanari:ShatterPrincess(allies)
end

function SpawnFinalRoom()
	Tanari:SpawnBoulderspineFinalRoom()

end

function slithereen_guard_think(event)
	local caster = event.caster
	if caster.aggro then
		if not caster.aggroSound then
			caster.aggroSound = true
			local sound = "slardar_slar_attack_0"..RandomInt(1, 9)
			EmitSoundOn(sound, caster)
		end
		local sprintAbility = caster:FindAbilityByName("slardar_sprint")
		local crushAbility = caster:FindAbilityByName("tanari_slithereen_crush")
		if sprintAbility:IsFullyCastable() then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = sprintAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return true
		end
		if crushAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 270, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = crushAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				return true
			end
		else
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local runAway = true
				local runFromTarget = false
				for i = 1, #enemies, 1 do
					if enemies[i]:IsStunned() then
						runAway = false
						caster:MoveToTargetToAttack(enemies[i])
					else
						runFromTarget = enemies[i]
					end
				end
				if runAway and runFromTarget then
					local moveToDirection = ((caster:GetAbsOrigin() - runFromTarget:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
					caster:MoveToPosition(caster:GetAbsOrigin() + moveToDirection * 240)
					return true
				end
			end
		end
	end
end

function slithereen_featherguard_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_FARTHEST, false)
		if #enemies > 0 then
			local blinkAbility = caster:FindAbilityByName("antimage_blink_custom")
			local castPoint = enemies[1]:GetAbsOrigin() + RandomVector(140)
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = blinkAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(0.3, function()
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_slithereen_featherguard_ai_super_slice", {duration = 2.25})
			end)
		end
	end
end

function royal_guard_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		if not caster.interval then
			caster.interval = 8
		end
		if caster.interval % 5 == 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_FARTHEST, false)
			if #enemies > 0 then
				StartAnimation(caster, {duration = 2.45, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.75})
				local castAbility = caster:FindAbilityByName("slithereen_royal_guard_gush")
				for i = 1, #enemies, 1 do
					Timers:CreateTimer((i - 1) * 0.35, function()
						local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							TargetIndex = enemies[i]:entindex(),
							AbilityIndex = castAbility:entindex(),
						}

						ExecuteOrderFromTable(newOrder)
					end)
				end
			end
		end
		if caster.interval % 8 == 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_royal_guard_magic_shell", {duration = 4})
		end
		caster.interval = caster.interval + 1
		if caster.interval > 100 then
			caster.interval = 1
		end
	end
end

function royal_guard_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if GameState:IsTanariJungle() then
		if not Tanari.royalGuardsSlain then
			Tanari.royalGuardsSlain = 0
		end
		Tanari.royalGuardsSlain = Tanari.royalGuardsSlain + 1
	end
end

function water_key_engage_unit_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Tanari.WaterKeyEngageCount then
		Tanari.WaterKeyEngageCount = 0
	end
	Tanari.WaterKeyEngageCount = Tanari.WaterKeyEngageCount + 1
	if Tanari.WaterKeyEngageCount == 12 then
		Tanari:SpawnWaterTempleKeyHolder(Vector(9408, -5631), Vector(0, 1))
	end
end

function water_temple_keyholder_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 1
	end
	local ability = event.ability
	local torrentAbility = caster:FindAbilityByName("water_keyholder_torrent")
	if caster.interval % 2 == 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local ensnareAbility = caster:FindAbilityByName("water_keyholder_ensnare")
			if ensnareAbility:IsFullyCastable() then
				local ensnareTarget = enemies[1]
				if #enemies > 1 then
					ensnareTarget = enemies[2]
				end
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = ensnareTarget:entindex(),
					AbilityIndex = ensnareAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			else
				local castPoint = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(0, 480))
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = torrentAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
				local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
				local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle, 0, castPoint + Vector(0, 0, 20))
				Timers:CreateTimer(1.8, function()
					ParticleManager:DestroyParticle(particle, false)
				end)
			end
		end
	end
	caster.interval = caster.interval + 1
	if caster.interval > 100 then
		caster.interval = 1
	end
end

function water_keyholder_die(event)
	local caster = event.caster
	Timers:CreateTimer(1, function()
		EmitGlobalSound("Tanari.KeyVictory")
		Tanari:AcquireTempleKey(caster:GetAbsOrigin(), "water")
	end)
	Tanari.WaterTempleKeyAcquired = true
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(Tanari.WaterKeyWallParticle, false)
		UTIL_Remove(Tanari.waterKeyBlock1)
		UTIL_Remove(Tanari.waterKeyBlock2)
		UTIL_Remove(Tanari.waterKeyBlock3)
	end)
end

function cave_monster_take_damage(event)
	local unit = event.unit
	local attacker = event.attacker
	local ability = event.ability
	if not unit.spikeDelay then
		unit.spikeDelay = true
		local mult = 0.025
		if GameState:GetDifficultyFactor() == 1 then
			mult = 0.005
		elseif GameState:GetDifficultyFactor() == 2 then
			mult = 0.015
		end
		local damage = math.min(event.damage * mult, unit:GetHealth())
		ApplyDamage({victim = attacker, attacker = unit, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		Timers:CreateTimer(0.2, function()
			unit.spikeDelay = false
		end)
	end
end

function red_viper_attack_land(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:IsHero() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_red_viper_poison", {duration = 3.5})
	end
end

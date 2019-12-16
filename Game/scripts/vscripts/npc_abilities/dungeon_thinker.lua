function DungeonThink(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local ability = event.ability
	-- caster:SetAbsOrigin(ability.position)
	local radius = 450
	if caster.radius then
		radius = caster.radius
	end
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO
	if caster.enemy then
		target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		target_types = DOTA_UNIT_TARGET_ALL
	end
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
	local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	if #units > 0 then
		for i = 1, #units, 1 do
			if units[i]:HasModifier("modifier_trapper_stealth") then
			else
				typeRedirect(caster, position, units)
				break
			end
		end
	end
end

function typeRedirect(caster, position, units)
	if caster.dungeon == "graveyard" then
		if caster.type == "skeleton" then
			skeletonSpawn(position)
			UTIL_Remove(caster)
		elseif caster.type == "zombieSwarm" then
			zombieSwarm()
			UTIL_Remove(caster)
		elseif caster.type == "zombiePile" then
			zombiePile()
			UTIL_Remove(caster)
		elseif caster.type == "zombieCathedral" then
			zombieCathedral()
			UTIL_Remove(caster)
		elseif caster.type == "graveyardChest" then
			graveyardChest(caster)
			UTIL_Remove(caster)
		elseif caster.type == "graveyardBeacon1" then
			graveyardBeacon1(caster)
			UTIL_Remove(caster)
		elseif caster.type == "skeletonKing" then
			if caster.active then
				skeletonKing(caster)
				UTIL_Remove(caster)
			end
		end
	elseif caster.dungeon == "logging_camp" then
		if caster.type == "forestSprite1" then
			forestSprite(1, caster)
			UTIL_Remove(caster)
		elseif caster.type == "forestSprite2" then
			forestSprite(2, caster)
			UTIL_Remove(caster)
		elseif caster.type == "forestSprite3" then
			forestSprite(3, caster)
			UTIL_Remove(caster)
		elseif caster.type == "forestSprite4" then
			forestSprite(4, caster)
			UTIL_Remove(caster)
		elseif caster.type == "forestSprite5" then
			forestSprite(5, caster)
			UTIL_Remove(caster)
		elseif caster.type == "forestSprite6" then
			forestSprite(6, caster)
			UTIL_Remove(caster)
		elseif caster.type == "mercenarySwarm" then
			mercenarySwarm(caster)
			UTIL_Remove(caster)
		elseif caster.type == "sludge_golems" then
			sludgeGolems(caster)
			UTIL_Remove(caster)
		elseif caster.type == "graveyardChest" then
			graveyardChest(caster)
			UTIL_Remove(caster)
		elseif caster.type == "shredder_max" then
			Dungeons:AggroUnit(caster.shredder)
			UTIL_Remove(caster)
		elseif caster.type == "beginAssault" then
			if not Dungeons.shredder then
				beginAssault(caster)
				UTIL_Remove(caster)
			end
		end
	elseif caster.dungeon == "sand_tomb" then
		if caster.type == "openingSequence" then
			tomb_opening(caster)
			UTIL_Remove(caster)
		elseif caster.type == "goldZombieSwarm" then
			tomb_zombies()
			UTIL_Remove(caster)
		elseif caster.type == "sandBoss" then
			sand_boss(caster)
			UTIL_Remove(caster)
		elseif caster.type == "spawnSecondHalf" then
			spawnSecondHalf()
			UTIL_Remove(caster)
		elseif caster.type == "hermit" then
			InitializeHermit(caster)
			UTIL_Remove(caster)
		end
	elseif caster.dungeon == "vault" then
		if caster.type == "rikiPatrolPoint" then
			rikiPatrol(caster, position, units)
		elseif caster.type == "wardDispenser" then
			dispenseWards(caster, position)
		elseif caster.type == "vaultSwitch1" then
			vaultSwitchPress(caster, position, units)
			UTIL_Remove(caster)
		elseif caster.type == "coffin" then
			zombieCoffin()
			UTIL_Remove(caster)
		elseif caster.type == "spikeTrap" then
			spikeTrap(caster, position, units)
		elseif caster.type == "room4" then
			Dungeons:vaultRoom4()
			UTIL_Remove(caster)
		elseif caster.type == "barkingDog" then
			barkingDog(caster, position)
		elseif caster.type == "antiMageMad" then
			antiMageMad(position)
			UTIL_Remove(caster)
		elseif caster.type == "goldStatue" then
			goldStatue(caster, units)
		elseif caster.type == "vaultSwitch2" then
			vaultSwitchPressTwo(caster, position, units)
			UTIL_Remove(caster)
		elseif caster.type == "applyGold" then
			applyGoldActivator(units)
		elseif caster.type == "boss_initiate" then
			bossInitiate()
			UTIL_Remove(caster)
		end
	elseif caster.dungeon == "castle" then
		if caster.type == "treants1" then
			haunted_treants(Vector(-4837, 6400), 2)
			UTIL_Remove(caster)
		elseif caster.type == "treants2" then
			haunted_treants(Vector(-3840, 6320), 3)
			UTIL_Remove(caster)
		elseif caster.type == "treants3" then
			haunted_treants(Vector(-4736, 4800), 3)
			UTIL_Remove(caster)
		elseif caster.type == "castle_entrance" then
			castle_entrance()
			UTIL_Remove(caster)
		elseif caster.type == "castleChest" then
			castleChest(caster)
			UTIL_Remove(caster)
		elseif caster.type == "front_kitchen" then
			Dungeons:CastleStageThree()
			UTIL_Remove(caster)
		elseif caster.type == "walk_outside" then
			walkOutside()
			UTIL_Remove(caster)
		elseif caster.type == "kitchen_oven" then
			kitchenOven()
			UTIL_Remove(caster)
		elseif caster.type == "summoner_move" then
			summonerMove(caster)
			UTIL_Remove(caster)
		elseif caster.type == "cellar_entrance" then
			cellarEntrance()
			UTIL_Remove(caster)
		elseif caster.type == "castle_boss_entrance" then
			Dungeons:StartCastleBoss()
			UTIL_Remove(caster)
		end
	elseif caster.dungeon == "swamp" then
		if caster.type == "bog_monster" then
			summonBogMonster()
			UTIL_Remove(caster)
		end
	elseif caster.dungeon == "desert_ruins" then
		if caster.type == "initial_spawn" then
			desertRuinsSpawn1(caster)
			UTIL_Remove(caster)
		elseif caster.type == "ruins_entrance" then
			desertTempleActivator(caster, units)
		elseif caster.type == "boss_initiate" then
			Timers:CreateTimer(4, function()
				Dungeons:SpawnRuinsBoss()
			end)
			UTIL_Remove(caster)
		end
	elseif caster.dungeon == "grizzly_falls" then
		if caster.type == "cave_entrance" then
			Dungeons:InitializeGrizzlyCave()
			grizzlyFallsCaveEntrance(caster:GetAbsOrigin())
			UTIL_Remove(caster)
		elseif caster.type == "bridge_fish" then
			Dungeons:BridgeFishThinker(caster:GetAbsOrigin())
			UTIL_Remove(caster)
		elseif caster.type == "boss_preview_event" then
			Dungeons:BossPreviewEvent()
			UTIL_Remove(caster)
		elseif caster.type == "cave_stage_two" then
			Dungeons:GrizzlyCave2()
			UTIL_Remove(caster)
		elseif caster.type == "boss_entrance" then
			Dungeons:GrizzlyInitiateBoss()
			UTIL_Remove(caster)
		end
	elseif caster.dungeon == "abandoned_shipyard" then
		if caster.type == "shipyard_skeleton" then
			Redfall:ShipyardSkeletons(caster:GetAbsOrigin())
			UTIL_Remove(caster)
		end
	end

end

function grizzlyFallsCaveEntrance(position)
	--print("CAVE SOUDNS?!?!?")
	EmitGlobalSound("Ambient.CaveEntrance")
	if Dungeons.grizzlyStatus >= 1 then
		if not Dungeons.tank_ally:IsNull() then
			Dungeons.tank_ally:MoveToPosition(position)
		end
		if not Dungeons.healer_ally:IsNull() then
			Dungeons.healer_ally:MoveToPosition(position)
		end
		Dungeons.grizzlyStatus = 2
	end

	Timers:CreateTimer(34, function()
		EmitGlobalSound("Ambient.CaveAmbient")
		if Dungeons.grizzlyFalls then
			return 67
		end
	end)
end

function desertTempleActivator(caster, units)
	if not caster.vision then
		caster.vision = true
		AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 600, 1200, false)
	end
	local ability = caster:FindAbilityByName("temple_activator_ability")
	for i = 1, #units, 1 do
		ability:ApplyDataDrivenModifier(caster, units[i], "modifier_temple_ui_open", {})
	end
end

function desertRuinsSpawn1(caster)
	local hunter = Dungeons:SpawnDungeonUnit("desert_outrunner", Vector(10170, 11657), 1, 1, 2, "ursa_ursa_anger_15", Vector(0, -1), false, nil)
	local hunter2 = Dungeons:SpawnDungeonUnit("desert_outrunner", Vector(10466, 11657), 1, 1, 2, "ursa_ursa_anger_15", Vector(0, -1), false, nil)
	Timers:CreateTimer(5, function()
		hunter:MoveToPositionAggressive(Vector(9975, 10386))
		hunter2:MoveToPositionAggressive(Vector(10255, 10449))
	end)
end

function InitializeHermit(caster)
	local hermit = caster.hermit
	EmitSoundOn("bristleback_bristle_lasthit_15", hermit)
	hermit:SetForwardVector(Vector(-1, 0))
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", hermit:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	visionTracer:SetDayTimeVisionRange(1000)
	visionTracer:SetNightTimeVisionRange(1000)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 5.5})
			MAIN_HERO_TABLE[i]:Stop()
			PlayerResource:SetCameraTarget(playerID, hermit)
		end
	end
	caster.jumpEnd = "hermit"
	Timers:CreateTimer(1, function()
		local fv = (Vector(9280, -9728) - hermit:GetAbsOrigin()):Normalized()
		--print(fv)
		StartAnimation(hermit, {duration = 3, activity = ACT_DOTA_SPAWN, rate = 0.6})
		WallPhysics:Jump(hermit, fv, 66, 50, 30, 1)
		for i = 1, 45, 1 do
			Timers:CreateTimer(i * 0.05, function()
				visionTracer:SetAbsOrigin(hermit:GetAbsOrigin() + Vector(0, 0, 220))
			end)
		end
	end)

	Timers:CreateTimer(3.9, function()
		hermit:RemoveModifierByName("modifier_hermit_initial")
		local hermitAbility = hermit:FindAbilityByName("hermit_leap")
		hermitAbility:ApplyDataDrivenModifier(hermit, hermit, "modifier_hermit_ai", {})
		hermit:SetAcquisitionRange(400)
		Dungeons:UnlockCamerasAndReturnToHero()
		UTIL_Remove(visionTracer)
	end)
end

function summonBogMonster()
	local bogMonster = Dungeons:SpawnDungeonUnit("the_bog_monster", Vector(12510, 4480), 1, 7, 9, "Hero_Broodmother.SpawnSpiderlings", Vector(0, -1), true, nil)
	local origPos = bogMonster:GetAbsOrigin()
	local undergroundOffset = -600
	local newPos = origPos + Vector(0, 0, undergroundOffset)
	bogMonster:SetAbsOrigin(newPos)
	bogAbility = bogMonster:FindAbilityByName("bog_monster_ai")
	Events:AdjustBossPower(bogMonster, 5, 5, false)
	EmitGlobalSound("Hero_Treant.Overgrowth.Cast")
	EmitGlobalSound("Hero_Treant.Overgrowth.Cast")
	EmitGlobalSound("Hero_Treant.Overgrowth.Cast")
	AddFOWViewer(DOTA_TEAM_GOODGUYS, origPos, 600, 7, false)
	local spawnSequences = 45
	bogAbility:ApplyDataDrivenModifier(bogMonster, bogMonster, "modifier_bog_intro", {duration = 0.05 * spawnSequences + 0.1})
	for i = 1, spawnSequences, 1 do
		Timers:CreateTimer(0.05 * i, function()
			bogMonster:SetAbsOrigin(newPos - (Vector(0, 0, undergroundOffset / spawnSequences)) * i)
		end)
	end
	Timers:CreateTimer(0.1, function()
		StartAnimation(bogMonster, {duration = 0.05 * spawnSequences - 0.1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.3})
		ScreenShake(origPos, 200, 0.5, 1, 9000, 0, true)
	end)
	Timers:CreateTimer(0.05 * spawnSequences / 2, function()
		EmitGlobalSound("Hero_Treant.Overgrowth.Cast")
		EmitGlobalSound("RoshanDT.Scream")
		EmitGlobalSound("Hero_Treant.Overgrowth.Cast")
		ScreenShake(origPos, 400, 0.9, spawnSequences * 0.05, 9000, 0, true)
	end)
	Timers:CreateTimer(0.87, function()
		for i = 1, 7, 1 do
			particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
			local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, bogMonster)
			ParticleManager:SetParticleControl(particle2, 0, origPos - Vector(0, 0, 110) + RandomVector(120))
			ScreenShake(origPos, 200, 0.9, spawnSequences * 0.05, 9000, 0, true)
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(particle2, false)
			end)
		end
		particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, bogMonster)
		ParticleManager:SetParticleControl(particle1, 0, origPos - Vector(0, 0, 140))
		ScreenShake(origPos, 200, 0.9, spawnSequences * 0.05, 9000, 0, true)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		EmitSoundOn("Ability.Torrent", bogMonster)
		EmitSoundOn("Ability.Torrent", bogMonster)
		EmitSoundOn("Ability.Torrent", bogMonster)
		Dungeons:SwampPart2()
	end)
	Timers:CreateTimer(0.05 * spawnSequences + 0.1, function()
		bogAbility:ApplyDataDrivenModifier(bogMonster, bogMonster, "modifier_bog_intro", {duration = 3.2})
		StartAnimation(bogMonster, {duration = 3.2, activity = ACT_DOTA_CAST_ABILITY_5, rate = 0.5})
		Timers:CreateTimer(0.5, function()
			ScreenShake(origPos, 200, 0.5, 1, 9000, 0, true)
			EmitSoundOn("RoshanDT.Scream", bogMonster)
		end)
	end)
end

function cellarEntrance()
	local vectorTable = {Vector(-2752, 10648), Vector(-2240, 10368), Vector(-2880, 11392), Vector(-2112, 11392), Vector(-1664, 10688)}
	for i = 1, 6, 1 do
		Timers:CreateTimer(1 * i, function()
			for j = 1, #vectorTable, 1 do
				local spider = Dungeons:SpawnDungeonUnit("burning_spider", vectorTable[j], 1, 0, 0, "Hero_Broodmother.SpawnSpiderlings", nil, true, nil)
				spider:RemoveAbility("ability_on_fire_effect")
				spider:RemoveModifierByName("modifier_on_fire_effect")
				spider:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
				Timers:CreateTimer(2, function()
					spider:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
				end)
			end
		end)
	end
end

function kitchenOven()
	for i = 1, 12, 1 do
		Timers:CreateTimer(0.25 * i, function()
			local spider = Dungeons:SpawnDungeonUnit("burning_spider", Vector(-2799, 9536), 1, 0, 0, "Hero_Broodmother.SpawnSpiderlings", nil, true, nil)
			spider:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
			Timers:CreateTimer(2, function()
				spider:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
			end)
		end)
	end
end

function summonerMove(caster)
	if caster.stage == 1 then
		EmitGlobalSound("clinkz_clinkz_level_08")
		caster.summoner:MoveToPosition(Vector(-3072, 9024))
		local thinker = Dungeons:CreateDungeonThinker(Vector(-3072, 9024), "summoner_move", 500, "castle")
		thinker.stage = 2
		thinker.summoner = caster.summoner
	elseif caster.stage == 2 then
		EmitGlobalSound("clinkz_clinkz_move_03")
		caster.summoner:MoveToPosition(Vector(-4193, 9024))
		local thinker = Dungeons:CreateDungeonThinker(Vector(-4193, 9024), "summoner_move", 500, "castle")
		thinker.stage = 3
		thinker.summoner = caster.summoner
	elseif caster.stage == 3 then
		EmitGlobalSound("clinkz_clinkz_move_03")
		caster.summoner:MoveToPosition(Vector(-4845, 9735))
		local thinker = Dungeons:CreateDungeonThinker(Vector(-4845, 8833), "summoner_move", 500, "castle")
		thinker.stage = 4
		thinker.summoner = caster.summoner
	elseif caster.stage == 4 then
		local summoner = caster.summoner
		local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")

		local visionTracer = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin() + Vector(0, 280, 0), true, nil, nil, DOTA_TEAM_GOODGUYS)
		visionTracer:AddAbility("dummy_unit"):SetLevel(1)
		visionTracer:AddNewModifier(visionTracer, nil, 'modifier_movespeed_cap', nil)
		visionTracer:SetBaseMoveSpeed(900)
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 8})
				MAIN_HERO_TABLE[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, visionTracer)
			end
		end

		EmitGlobalSound("clinkz_clinkz_laugh_08")
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-4845, 9705), 600, 15, false)
		EmitGlobalSound("clinkz_clinkz_laugh_08")
		EmitGlobalSound("clinkz_clinkz_laugh_08")
		Timers:CreateTimer(2.0, function()
			summoner:MoveToPosition(Vector(-4845, 9695))
			local pugnaTable = {}
			table.insert(pugnaTable, summoner)
			Timers:CreateTimer(0.7, function()
				for i = 1, 3, 1 do
					for j = 1, 5, 1 do
						Timers:CreateTimer(1.2 * (i - 1) + 0.3 * (j - 1), function()
							local xValue = -5320 + j * 160
							local yValue = 9467 - i * 160
							local pugna = createPugnaClone(Vector(xValue, yValue), summoner, gameMasterAbil)
							table.insert(pugnaTable, pugna)
						end)
					end
				end
			end)
			Timers:CreateTimer(5.3, function()
				local soundTable = {"clinkz_clinkz_laugh_06", "clinkz_clinkz_laugh_04", "clinkz_clinkz_laugh_02", "clinkz_clinkz_laugh_01", "clinkz_clinkz_laugh_03", "clinkz_clinkz_laugh_05"}
				for i = 1, #soundTable, 1 do
					Timers:CreateTimer(0.2 * i, function()
						EmitGlobalSound(soundTable[i])
					end)
				end
				Dungeons.summonerTrueFormCount = 0
				Timers:CreateTimer(1.2, function()
					UTIL_Remove(visionTracer)
					for i = 1, #pugnaTable, 1 do
						local pugnaUnit = pugnaTable[i]
						local pugnaPos = pugnaUnit:GetAbsOrigin()
						UTIL_Remove(pugnaUnit)
						local trueForm = Dungeons:SpawnDungeonUnit("summoner_true_form", pugnaPos, 1, 3, 4, "Hero_Undying.FleshGolem.Cast", Vector(0, -1), true, nil)
						Events:AdjustBossPower(trueForm, 5, 5, false)
						EmitSoundOn("Hero_Undying.FleshGolem.Cast", trueForm)
						local particleName = "particles/units/heroes/hero_undying/undying_loadout.vpcf"
						local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, trueForm)
						ParticleManager:SetParticleControlEnt(pfx, 0, trueForm, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", trueForm:GetAbsOrigin(), true)
						Timers:CreateTimer(1, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end
				end)
			end)
		end)
	end
end

function createPugnaClone(position, caster, gameMasterAbil)
	StartAnimation(caster, {duration = 0.25, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.2})
	local particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 200))
	ParticleManager:SetParticleControl(pfx, 1, position + Vector(0, 0, 822))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	particleName = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_lightning.vpcf"
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin() + Vector(0, 0, 200))
	ParticleManager:SetParticleControl(pfx2, 1, position + Vector(0, 0, 822))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	local pugna = CreateUnitByName("courtyard_summoner", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:AdjustBossPower(pugna, 5, 5, false)
	pugna:RemoveAbility("courtyard_summoner_ai")
	pugna:RemoveAbility("cant_die_special")
	pugna:RemoveAbility("dungeon_creep")
	pugna:RemoveModifierByName("modifier_courtyard_summoner_ai")
	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, pugna, "modifier_disable_player", {duration = 8})
	pugna:SetForwardVector(Vector(0, -1))
	pugna:SetModelScale(0.85)
	EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", pugna)
	return pugna
end

function castle_entrance()
	local debuffModels = {"models/props_gameplay/status_shield_broken.vmdl", "models/items/silencer/aeol_drias_shield/aeol_drias_shield.vmdl", "models/heroes/silencer/silencer_curse_skull.vmdl", "models/props_gameplay/disarm_oracle.vmdl"}
	local debuffNames = {"modifier_avernus_armor", "modifier_avernus_magic_resist", "modifier_avernus_e_nerf", "modifier_avernus_miss"}
	local debuffFv = {Vector(0, -1), Vector(0, -1), Vector(0, -1), Vector(0, -1)}
	local debuffScale = {2.2, 1, 2.5, 7}
	local choice = RandomInt(1, #debuffModels)
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(-1856, 6848), true, nil, nil, DOTA_TEAM_GOODGUYS)
	visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	visionTracer:AddNewModifier(visionTracer, nil, 'modifier_movespeed_cap', nil)
	visionTracer:SetBaseMoveSpeed(900)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 9.5})
			MAIN_HERO_TABLE[i]:Stop()
			PlayerResource:SetCameraTarget(playerID, visionTracer)
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("big_text", {message = "#avernus_statue_message"})
	EmitSoundOn("Conquest.capture_point_timer", visionTracer)
	Timers:CreateTimer(1, function()
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", visionTracer:GetAbsOrigin() - Vector(-10, 80, 160), Dungeons.DungeonMaster, 8.6, Vector(1, 0, 0))
	end)
	Timers:CreateTimer(3.5, function()
		EmitSoundOn("Conquest.Glyph.Cast", visionTracer)
		local particleName = "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_ground_eztzhok.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1, 0, Vector(-1856, 6848))
	end)
	local fate = nil
	Timers:CreateTimer(4.2, function()
		fate = CreateUnitByName("npc_flying_dummy_vision", Vector(-1850, 6768), true, nil, nil, DOTA_TEAM_GOODGUYS)
		fate:AddAbility("dummy_unit"):SetLevel(1)
		fate:SetOriginalModel(debuffModels[choice])
		fate:SetModel(debuffModels[choice])
		fate:SetModelScale(debuffScale[choice])
		fate:SetForwardVector(debuffFv[choice])
		local fateLocation = fate:GetAbsOrigin()
		for i = 1, 30, 1 do
			Timers:CreateTimer(i * 0.05, function()
				fate:SetAbsOrigin(fateLocation + Vector(0, 0, 4) * i)
			end)
		end
	end)
	Timers:CreateTimer(8, function()
		local position = fate:GetAbsOrigin()
		local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, Dungeons.DungeonMaster)
		ParticleManager:SetParticleControlEnt(pfx, 0, fate, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
		ParticleManager:SetParticleControlEnt(pfx, 1, fate, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
		Timers:CreateTimer(3.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
	Timers:CreateTimer(9, function()
		local particleName = "particles/items_fx/leshrac_wall_beam.vpcf"
		local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, fate)
		local casterPos = fate:GetAbsOrigin()
		local enemies = MAIN_HERO_TABLE
		for _, unit in pairs(enemies) do
			for i = 1, 5, 1 do
				Timers:CreateTimer(0.08 * i, function()
					EmitSoundOn("Hero_ArcWarden.SparkWraith.Activate", unit)
					EmitSoundOn("Hero_ArcWarden.Flux.Target", fate)
					local origin = unit:GetAbsOrigin()
					local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, fate)
					ParticleManager:SetParticleControl(lightningBolt, 0, Vector(casterPos.x, casterPos.y, casterPos.z + fate:GetBoundingMaxs().z + 120))
					ParticleManager:SetParticleControl(lightningBolt, 1, Vector(origin.x, origin.y, origin.z + unit:GetBoundingMaxs().z))
					local ability = Dungeons.DungeonMaster:FindAbilityByName("avernus_curse")
					ability:ApplyDataDrivenModifier(Dungeons.DungeonMaster, unit, debuffNames[choice], {})
				end)
			end
		end
	end)
	Timers:CreateTimer(9.6, function()
		local position = fate:GetAbsOrigin()
		local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, fate)
		ParticleManager:SetParticleControlEnt(pfx, 0, fate, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
		ParticleManager:SetParticleControlEnt(pfx, 1, fate, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
		Timers:CreateTimer(3.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		Timers:CreateTimer(0.5, function()
			UTIL_Remove(fate)
		end)
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				MAIN_HERO_TABLE[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, nil)
			end
		end
		for i = 1, 8, 1 do
			Timers:CreateTimer(0.6 * i, function()
				soundDummy = CreateUnitByName("npc_flying_dummy_vision", Vector(-1850, 6768), true, nil, nil, DOTA_TEAM_GOODGUYS)
				soundDummy:AddAbility("dummy_unit"):SetLevel(1)
				EmitSoundOn("Conquest.hallow_laughter", soundDummy)
				Timers:CreateTimer(2, function()
					UTIL_Remove(soundDummy)
				end)
			end)
		end
	end)

end

function castleChest(caster)
	local chest = caster.chest
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	StartAnimation(chest, {duration = 7, activity = ACT_DOTA_DIE, rate = 0.28})
	local position = chest:GetAbsOrigin() + Vector(-100, 120)
	if caster.lootLaunch then
		Dungeons.lootLaunch = chest:GetAbsOrigin() + caster.lootLaunch
	else
		Dungeons.lootLaunch = position
	end
	Timers:CreateTimer(2.0, function()
		for i = 0, RandomInt(5, 7), 1 do
			EmitSoundOn("General.FemaleLevelUp", chest)
			RPCItems:RollItemtype(300, chest:GetAbsOrigin(), 1, 0)
		end
		local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, chest)
		local origin = chest:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle1, 0, origin)
		ParticleManager:SetParticleControl(particle1, 1, origin)
		ParticleManager:SetParticleControl(particle1, 2, origin)
		ParticleManager:SetParticleControl(particle1, 3, origin)
	end)
	Timers:CreateTimer(6.5, function()
		Dungeons.lootLaunch = false
		UTIL_Remove(chest)
	end)
	Timers:CreateTimer(2.8, function()
		local ghost = Dungeons:SpawnDungeonUnit("castle_ghost", position, 1, 1, 3, "Conquest.poison.hallow_scream", nil, true, nil)
		EmitSoundOn("Conquest.poison.hallow_scream", ghost)
	end)
end

function walkOutside()
	-- local position = Vector(-256, 8256)
	-- for i = 1, 18, 1 do
	-- Timers:CreateTimer(0.5*i, function()
	-- local archer = Dungeons:SpawnDungeonUnit("castle_skeleton_archer", position, 1, 1, 1, "clinkz_clinkz_anger_06", nil, true, nil)
	-- Timers:CreateTimer(0.1, function()
	-- archer:MoveToPositionAggressive(Vector(-1664, 8576))
	-- end)
	-- end)
	-- end
	local summoner = Dungeons:SpawnDungeonUnit("courtyard_summoner", Vector(320, 9984), 1, 1, 1, "clinkz_clinkz_anger_08", Vector(-1, -1), false, nil)
	Events:AdjustBossPower(summoner, 3, 10, false)
	summoner.state = 0
	summoner.interval = 0
end

function haunted_treants(position, quantity)
	Dungeons:SpawnDungeonUnit("haunted_tree", position, quantity, 1, 1, "Hero_Spectre.HauntCast", nil, true, nil)
	GridNav:DestroyTreesAroundPoint(position, 340, false)
end

function bossInitiate()
	CustomGameEventManager:Send_ServerToAllClients("fadeToBlack", {})
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 10})
			PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
		end
	end

	local antimage = Dungeons.antiMage
	Timers:CreateTimer(1.1, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			FindClearSpaceForUnit(MAIN_HERO_TABLE[i], Vector(9344, 1088), false)
		end
		Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(8832, 586), Name = "wallObstruction"})
		Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(8960, 586), Name = "wallObstruction"})
		Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(9088, 586), Name = "wallObstruction"})

		Dungeons.blocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(9088, 1894), Name = "wallObstruction"})
		Dungeons.blocker5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(9216, 1894), Name = "wallObstruction"})

		Dungeons.wall1 = CreateUnitByName("npc_dummy_unit", Vector(8843, 576), false, nil, nil, DOTA_TEAM_NEUTRALS)
		Dungeons.wall1:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
		Dungeons.wall1:SetModel("models/props_garden/good_stonewall001c.vmdl")
		Dungeons.wall1:SetModelScale(1.75)
		Dungeons.wall1:SetForwardVector(Vector(1, 0))
		Dungeons.wall1:SetAbsOrigin(Dungeons.wall1:GetAbsOrigin() + Vector(0, 0, 256))
		Dungeons.wall1:FindAbilityByName("dummy_unit"):SetLevel(1)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(8957, 576), 300, 99999, false)
		Dungeons.wall2 = CreateUnitByName("npc_dummy_unit", Vector(9057, 576), false, nil, nil, DOTA_TEAM_NEUTRALS)
		Dungeons.wall2:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
		Dungeons.wall2:SetModel("models/props_garden/good_stonewall001c.vmdl")
		Dungeons.wall2:SetModelScale(1.75)
		Dungeons.wall2:SetForwardVector(Vector(1, 0))
		Dungeons.wall2:SetAbsOrigin(Dungeons.wall2:GetAbsOrigin() + Vector(0, 0, 256))
		Dungeons.wall2:FindAbilityByName("dummy_unit"):SetLevel(1)

		Dungeons.wall3 = CreateUnitByName("npc_dummy_unit", Vector(9182, 1930), false, nil, nil, DOTA_TEAM_NEUTRALS)
		Dungeons.wall3:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
		Dungeons.wall3:SetModel("models/props_garden/good_stonewall001c.vmdl")
		Dungeons.wall3:SetModelScale(2.4)
		Dungeons.wall3:SetForwardVector(Vector(1, 0))
		Dungeons.wall3:SetAbsOrigin(Dungeons.wall3:GetAbsOrigin() + Vector(0, 0, 216))
		Dungeons.wall3:FindAbilityByName("dummy_unit"):SetLevel(1)
		table.insert(Dungeons.entityTable, Dungeons.wall1)
		table.insert(Dungeons.entityTable, Dungeons.wall2)
		table.insert(Dungeons.entityTable, Dungeons.wall3)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(9150, 1920), 300, 99999, false)

		Dungeons.entryPoint = Vector(10048, 1536)
		

		local blinkAbility = antimage:FindAbilityByName("antimage_blink_custom")
		local position = Vector(10048, 1536)
		local order =
		{
			UnitIndex = antimage:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = blinkAbility:GetEntityIndex(),
			Position = position,
			Queue = false
		}
		ExecuteOrderFromTable(order)
		Timers:CreateTimer(0.8, function()
			antimage:MoveToPosition(Vector(9973, 1459))
			local speechSlot = findEmptyDialogSlot()
			local time = 4.5
			antimage:AddSpeechBubble(speechSlot, "#vault_antimage_fight_dialogue_one", time, 0, 0)
			disableSpeech(antimage, time, speechSlot)
			EmitGlobalSound("terrorblade_arcana.stinger.respawn")
		end)
		Timers:CreateTimer(5, function()
			StartAnimation(antimage, {duration = 8, activity = ACT_DOTA_TELEPORT, rate = 1})
			for i = 1, 50, 1 do
				Timers:CreateTimer(i * 0.1, function()
					local antimagePosition = antimage:GetAbsOrigin()
					antimage:SetAbsOrigin(antimagePosition + Vector(0, 0, 5))
					if i == 1 then
						local speechSlot = findEmptyDialogSlot()
						local time = 2.3
						antimage:AddSpeechBubble(speechSlot, "#vault_antimage_fight_dialogue_two", time, 0, 0)
						disableSpeech(antimage, time, speechSlot)
					elseif i == 25 then
						local speechSlot = findEmptyDialogSlot()
						local time = 0.9
						antimage:AddSpeechBubble(speechSlot, "#vault_antimage_fight_dialogue_three", time, 0, 0)
						disableSpeech(antimage, time, speechSlot)
					elseif i == 35 then
						local speechSlot = findEmptyDialogSlot()
						local time = 0.9
						antimage:AddSpeechBubble(speechSlot, "#vault_antimage_fight_dialogue_four", time, 0, 0)
						disableSpeech(antimage, time, speechSlot)
					elseif i == 45 then
						local speechSlot = findEmptyDialogSlot()
						local time = 0.9
						antimage:AddSpeechBubble(speechSlot, "#vault_antimage_fight_dialogue_five", time, 0, 0)
						disableSpeech(antimage, time, speechSlot)
					end
				end)
			end
		end)
		Timers:CreateTimer(10.5, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
				if playerID then
					PlayerResource:SetCameraTarget(playerID, nil)
				end
			end
			local antimagePosition = antimage:GetAbsOrigin()
			UTIL_Remove(antimage)
			local boss = Events:SpawnBoss("dynasty_heir_majinaq", antimagePosition)
			Events:AdjustBossPower(boss, 10, 4, true)
			boss:FindAbilityByName("majinaq_blink_strike"):StartCooldown(10)
			EmitGlobalSound("Hero_Antimage.ManaVoid")
			local pfx = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_CUSTOMORIGIN, dogTrap)
			ParticleManager:SetParticleControl(pfx, 0, antimagePosition)
			ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
			ParticleManager:SetParticleControl(pfx, 3, Vector(200, 200, 200))
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			Timers:CreateTimer(2, function()
				EmitGlobalSound("antimage_anti_attack_07")
				EmitGlobalSound("antimage_anti_attack_07")
				EmitGlobalSound("antimage_anti_attack_07")
			end)

		end)
		for i = 0, 15, 1 do
			Timers:CreateTimer(5 + i * 0.3, function()
				local antimagePosition = antimage:GetAbsOrigin()
				Events:CreateLightningBeam(antimagePosition + Vector(0, 0, 90), Vector(9440, 1877, 820))
				Events:CreateLightningBeam(antimagePosition + Vector(0, 0, 90), Vector(10263, 1184, 820))
			end)
		end
	end)
end

function applyGoldActivator(units)
	for _, unit in pairs(units) do
		Dungeons.DungeonMaster.fireAbility:ApplyDataDrivenModifier(Dungeons.DungeonMaster, unit, "modifier_vault_statue_activator", {})
		EmitSoundOn("Hero_Chen.PenitenceCast", unit)
	end
end

function goldStatue(caster, units)
	local goldReady = false
	for _, unit in pairs(units) do
		if unit:HasModifier("modifier_vault_statue_activator") then
			goldReady = true
		end
	end
	if goldReady and Dungeons.goldStatus == caster.seqNumber then
		local statue = caster.statue
		local statueOrigin = statue:GetAbsOrigin()
		EmitGlobalSound("Hero_Undying.Tombstone")
		for i = 1, 30, 1 do
			Timers:CreateTimer(0.03 * i, function()
				local vectorMult = -1
				if i % 2 == 0 then
					vectorMult = 1
				end
				statue:SetAbsOrigin(statueOrigin + Vector(20, 0, 0) * vectorMult)
			end)
		end
		Timers:CreateTimer(0.95, function()
			statue:RemoveModifierByName("modifier_vault_golden_frozen")
			Dungeons.DungeonMaster.fireAbility:ApplyDataDrivenModifier(Dungeons.DungeonMaster, statue, "modifier_vault_golden", {})
			local event = {}
			event.caster = statue
			aggroUnit(event)
		end)
		UTIL_Remove(caster)
	end
end

function antiMageMad(position)
	local antimage = Dungeons.antiMage
	local blinkAbility = antimage:FindAbilityByName("antimage_blink_custom")
	local order =
	{
		UnitIndex = antimage:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blinkAbility:GetEntityIndex(),
		Position = position,
		Queue = true
	}
	Timers:CreateTimer(0.5, function()
		for i = 0, 3, 1 do
			Timers:CreateTimer(i * 2.6, function()
				Dungeons:SpawnDungeonUnit("vault_henchman", Vector(13504, -2304), 2, 0, 0, "silencer_silen_anger_06", Vector(1, 0), true, nil)
				Dungeons:SpawnDungeonUnit("vault_executioner", Vector(13504, -2304), 1, 0, 0, "silencer_silen_anger_06", Vector(1, 0), true, nil)
				Dungeons:SpawnDungeonUnit("vault_arcanist", Vector(13504, -2304), 1, 0, 0, "silencer_silen_anger_06", Vector(1, 0), true, nil)
				Dungeons:SpawnDungeonUnit("vault_pleb", Vector(13504, -2304), 2, 0, 0, "silencer_silen_anger_06", Vector(1, 0), true, nil)
			end)
		end
		ExecuteOrderFromTable(order)
		local speechSlot = findEmptyDialogSlot()
		local time = 5
		antimage:AddSpeechBubble(speechSlot, "#vault_antimage_dialogue_two", time, 0, 0)
		disableSpeech(antimage, time, speechSlot)
		Timers:CreateTimer(0.5, function()
			local playerPosition = MAIN_HERO_TABLE[1]:GetAbsOrigin()
			Timers:CreateTimer(0.5, function()
				antimage:MoveToPosition(playerPosition)
				Timers:CreateTimer(0.05, function()
					antimage:Stop()
				end)
			end)
			Timers:CreateTimer(time, function()
				order =
				{
					UnitIndex = antimage:GetEntityIndex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = blinkAbility:GetEntityIndex(),
					Position = Vector(8942, 1664),
					Queue = true
				}
				ExecuteOrderFromTable(order)
			end)
		end)
	end)
end

function zombieCoffin()
	local vector = Vector(15011, 125)
	for i = 0, 30, 1 do
		Timers:CreateTimer(i * 0.1, function()
			Dungeons:SpawnDungeonUnit("zombie_raider_two", vector, 1, 0, 0, nil, Vector(-1, 0), true, nil)
		end)
	end
end

function barkingDog(caster, position)
	if not caster.barkingDog.active then
		EmitSoundOn("Conquest.capture_point_timer", caster)
		caster.barkingDog.active = true
		Timers:CreateTimer(0.5, function()
			StartAnimation(caster.barkingDog, {duration = 2.5, activity = ACT_DOTA_ATTACK, rate = 1})
			Timers:CreateTimer(0.3, function()
				EmitSoundOn("Conquest.FireTrap", caster)
				createFireProjectile(Dungeons.DungeonMaster, caster.barkingDog:GetAbsOrigin(), caster.barkingDog:GetForwardVector())
			end)
		end)
		Timers:CreateTimer(3, function()
			caster.barkingDog.active = false
		end)
	end
end

function createFireProjectile(caster, position, fv)
	local ability = Dungeons.DungeonMaster.fireAbility
	local speed = 400
	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		vSpawnOrigin = position,
		fDistance = 220,
		fStartRadius = 100,
		fEndRadius = 200,
		Source = caster,
		StartPosition = "custom_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function spikeTrap(caster, position, units)
	if not caster.spikeTrap.active then
		StartAnimation(caster.spikeTrap, {duration = 5, activity = ACT_DOTA_ATTACK, rate = 1})
		EmitSoundOn("Conquest.SpikeTrap.Plate", caster)
		caster.spikeTrap.active = true
		Timers:CreateTimer(1, function()
			EmitSoundOn("Conquest.SpikeTrap.Activate", caster)
			for i = 0, 6, 1 do
				Timers:CreateTimer(0.5 * i, function()
					local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, position, nil, 256, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							local damage = 0
							--print(enemy:GetName())
							if enemy:GetUnitName() == "unreal_terror" then
								damage = 150000
								ApplyDamage({victim = enemy, attacker = MAIN_HERO_TABLE[RandomInt(1, #MAIN_HERO_TABLE)], damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
							else
								damage = 1000
								ApplyDamage({victim = enemy, attacker = caster.spikeTrap, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
							end
							PopupDamage(enemy, damage)
							EmitSoundOn("Hero_NyxAssassin.SpikedCarapace", enemy)
						end
					end
				end)
			end
			Timers:CreateTimer(4, function()
				caster.spikeTrap.active = false
			end)
		end)
	end
end

function vaultSwitchPressTwo(caster, position, units)
	local switch = caster.switch
	for i = 1, #units, 1 do
		units[i]:SetAbsOrigin(units[i]:GetAbsOrigin() + Vector(0, 0, 30))
	end
	for i = 1, 24, 1 do
		Timers:CreateTimer(0.05 * i, function()
			for i = 1, #units, 1 do
				units[i]:SetAbsOrigin(units[i]:GetAbsOrigin() - Vector(0, 0, 0.5) * i)
			end
			switch:SetAbsOrigin(switch:GetAbsOrigin() - Vector(0, 0, 0.1) * i)
		end)
	end
	EmitSoundOn("Visage_Familar.StoneForm.Cast", switch)
	ScreenShake(caster:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
	lowerWall(Dungeons.wall1)
	lowerWall(Dungeons.wall2)
	Timers:CreateTimer(3, function()
		UTIL_Remove(Dungeons.blocker1)
		Dungeons.blocker1 = false
		UTIL_Remove(Dungeons.blocker2)
		Dungeons.blocker2 = false
		UTIL_Remove(Dungeons.blocker3)
		Dungeons.blocker3 = false
	end)
end

function vaultSwitchPress(caster, position, units)
	local switch = caster.switch
	for i = 1, #units, 1 do
		units[i]:SetAbsOrigin(units[i]:GetAbsOrigin() + Vector(0, 0, 30))
	end
	for i = 1, 24, 1 do
		Timers:CreateTimer(0.05 * i, function()
			for i = 1, #units, 1 do
				units[i]:SetAbsOrigin(units[i]:GetAbsOrigin() - Vector(0, 0, 0.5) * i)
			end
			switch:SetAbsOrigin(switch:GetAbsOrigin() - Vector(0, 0, 0.1) * i)
		end)
	end
	EmitSoundOn("Visage_Familar.StoneForm.Cast", switch)
	ScreenShake(caster:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
	lowerWall(Dungeons.wall1)
	Timers:CreateTimer(3, function()
		UTIL_Remove(Dungeons.blocker1)
		Dungeons.blocker1 = false
		UTIL_Remove(Dungeons.blocker2)
		Dungeons.blocker2 = false
		UTIL_Remove(Dungeons.blocker3)
		Dungeons.blocker3 = false
		Dungeons:VaultRoom3()
	end)
	Timers:CreateTimer(2, function()
		local basePosition = Vector(13904, -915, 256)
		for i = 0, 16, 1 do
			Timers:CreateTimer(0.1 * i, function()
				EmitSoundOn("Hero_Mirana.Attack", units[1])
				fireArrow(basePosition + Vector(RandomInt(-200, 200), 0, RandomInt(-80, 100)))
				fireArrow(basePosition + Vector(RandomInt(-200, 200), 0, RandomInt(-80, 100)))
			end)
		end
	end)
end

function fireArrow(arrowOrigin)
	local arrowAbility = Dungeons.DungeonMaster.arrowAbility
	local projectileParticle = "particles/frostivus_herofx/drow_linear_arrow.vpcf"
	local range = 1500
	local caster = Dungeons.DungeonMaster
	local start_radius = 110
	local end_radius = 110
	local speed = 800
	local info =
	{
		Ability = arrowAbility,
		EffectName = projectileParticle,
		vSpawnOrigin = arrowOrigin,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = Vector(0, 1) * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function lowerWall(wall)
	EmitSoundOn("Visage_Familar.StoneForm.Cast", wall)
	local wallOrigin = wall:GetAbsOrigin()
	ScreenShake(wallOrigin, 200, 0.5, 1, 9000, 0, true)
	for i = 1, 60, 1 do
		Timers:CreateTimer(i * 0.05, function()
			wall:SetAbsOrigin(wallOrigin - Vector(0, 0, 4) * i)
		end)
	end
	Timers:CreateTimer(3, function()
		ScreenShake(wallOrigin, 200, 0.5, 1, 9000, 0, true)
		EmitSoundOn("Visage_Familar.StoneForm.Cast", wall)
	end)
	-- Timers:CreateTimer(5, function()
	-- UTIL_Remove(wall)
	-- end)
end

function dispenseWards(caster, position)
	if not caster.stopDispense then
		StartAnimation(caster.wardDispenser, {duration = 2.2, activity = ACT_DOTA_SPAWN, rate = 0.8})
		caster.stopDispense = true
		Timers:CreateTimer(1.8, function()
			EmitSoundOn("General.ButtonClick", caster.wardDispenser)
			local item = RPCItems:CreateItem("item_ward_sentry", nil, nil)
			local position = caster:GetAbsOrigin()
			local drop = CreateItemOnPositionSync(position, item)
			item.cantStash = true
			dropPosition = position + Vector(-1, -1) * 150
			--item:LaunchLoot(false, 240, 0.75, dropPosition)
			RPCItems:LaunchLoot(item, 240, 0.5, dropPosition, dropPosition)
			Timers:CreateTimer(12, function()
				caster.stopDispense = false
			end)
		end)
	end
end

function rikiPatrol(caster, position, units)
	for _, unit in pairs(units) do
		if unit:GetUnitName() == "vault_assassin" and not unit.aggro then
			if caster.patrolPointIndex == 1 then
				unit.phase = 0
				unit:MoveToPosition(Vector(15751, -437))
			elseif caster.patrolPointIndex == 2 then
				if unit.phase == 0 then
					unit:MoveToPosition(Vector(14800, -437))
				else
					unit:MoveToPosition(Vector(15774, -2624))
				end
			elseif caster.patrolPointIndex == 3 then
				if unit.phase == 0 then
					unit:MoveToPosition(Vector(14800, -2624))
				else
					unit:MoveToPosition(Vector(15751, -437))
				end
			elseif caster.patrolPointIndex == 4 then
				unit.phase = 1
				unit:MoveToPosition(Vector(14800, -437))
			end
		end
	end
end

function spawnSecondHalf()
	Dungeons:SpawnDungeonUnit("follower_of_crixalis", Vector(12480, -8192), 1, 1, 1, "sandking_skg_anger_05", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("follower_of_crixalis", Vector(12180, -7992), 1, 1, 1, "sandking_skg_anger_05", Vector(1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("follower_of_crixalis", Vector(12180, -8392), 1, 1, 1, "sandking_skg_anger_05", Vector(1, 1), false, nil)

	Dungeons:SpawnDungeonUnit("follower_of_crixalis", Vector(11392, -7808), 1, 1, 1, "sandking_skg_anger_05", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("follower_of_crixalis", Vector(11134, -7692), 1, 1, 1, "sandking_skg_anger_05", Vector(1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("follower_of_crixalis", Vector(11165, -7450), 1, 1, 1, "sandking_skg_anger_05", Vector(0, -1), false, nil)

	local chestThinker = Dungeons:CreateDungeonThinker(Vector(11200, -6656), "graveyardChest", 240, "graveyard")
	chestThinker.chest = CreateUnitByName("chest", Vector(11200, -6656), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(0, -1))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)

	Dungeons:SpawnDungeonUnit("raging_flame", Vector(10304, -6592), 1, 1, 1, "undying_undying_anger_06", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("raging_flame", Vector(10275, -6112), 1, 1, 1, "undying_undying_anger_06", Vector(0, -1), false, nil)
	Dungeons:SpawnDungeonUnit("tomb_remnant", Vector(10500, -5619), 1, 1, 1, "clinkz_clinkz_anger_04", Vector(-1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("tomb_apparition", Vector(10200, -5619), 3, 1, 1, "clinkz_clinkz_ability_failure_06", Vector(0, -1), false, nil)

	Dungeons:SpawnDungeonUnit("tomb_stalker", Vector(11136, -5120), 1, 2, 4, "faceless_void_face_anger_03", Vector(0, 1), false, nil)
	Dungeons:SpawnDungeonUnit("tomb_stalker", Vector(11136, -4755), 1, 2, 4, "faceless_void_face_anger_03", Vector(0, 1), false, nil)
	Dungeons:SpawnDungeonUnit("tomb_stalker", Vector(11136, -4455), 1, 2, 4, "faceless_void_face_anger_03", Vector(0, 1), false, nil)
end

function sand_boss(caster)
	local sandBoss = caster.sandBoss
	local sandBossAbility = sandBoss:FindAbilityByName("sand_tomb_boss_ability")
	sandBoss:RemoveModifierByName("modifier_tomb_boss_ability_prefight")
	sandBossAbility:ApplyDataDrivenModifier(sandBoss, sandBoss, "modifier_tomb_boss_growing", {duration = 6.5})
	Timers:CreateTimer(0.5, function()
		CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = sandBoss:GetUnitName(), bossMaxHealth = sandBoss:GetMaxHealth(), bossId = tostring(sandBoss)})
		EmitGlobalSound("shop_jbrice_01.stinger.dire_lose")
	end)
end

function tomb_zombies()
	local vector1 = Vector(9121, -5620)
	local vector2 = Vector(9121, -5795)
	local vector3 = Vector(9121, -5962)
	local vector4 = Vector(9121, -6134)
	local vector5 = Vector(9121, -6299)

	local vector6 = Vector(9580, -5620)
	local vector7 = Vector(9580, -5795)
	local vector8 = Vector(9580, -5962)
	local vector9 = Vector(9580, -6134)
	local vector10 = Vector(9580, -6299)
	for i = 0, 5, 1 do
		Timers:CreateTimer(i * 2.5, function()
			Dungeons:SpawnDungeonUnit("tomb_defender", vector1, 1, 0, 0, "undying_undying_anger_14", Vector(1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("tomb_defender", vector2, 1, 0, 0, "undying_undying_anger_14", Vector(1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("tomb_defender", vector3, 1, 0, 0, "undying_undying_anger_14", Vector(1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("tomb_defender", vector4, 1, 0, 0, "undying_undying_anger_14", Vector(1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("tomb_defender", vector5, 1, 0, 0, "undying_undying_anger_14", Vector(1, 0), true, nil)

			Dungeons:SpawnDungeonUnit("tomb_defender", vector6, 1, 0, 0, "undying_undying_anger_14", Vector(-1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("tomb_defender", vector7, 1, 0, 0, "undying_undying_anger_14", Vector(-1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("tomb_defender", vector8, 1, 0, 0, "undying_undying_anger_14", Vector(-1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("tomb_defender", vector9, 1, 0, 0, "undying_undying_anger_14", Vector(-1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("tomb_defender", vector10, 1, 0, 0, "undying_undying_anger_14", Vector(-1, 0), true, nil)
		end)
	end
end

function tomb_opening(caster)
	local adventurerA = caster.adventurerA
	local adventurerB = caster.adventurerB
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 5})
			MAIN_HERO_TABLE[i]:Stop()
			PlayerResource:SetCameraTarget(playerID, adventurerA)

		end
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(9472, -4160), 800, 8, false)
	if not adventurerA:IsNull() then
		adventurerA:MoveToPosition(Vector(9472, -4160))
		ScreenShake(adventurerA:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
	end
	if not adventurerB:IsNull() then
		adventurerB:MoveToPosition(Vector(9257, -4160))
	end


	--  local dummyA = CreateUnitByName("dummy_unit_vulnerable", Vector(9472, -4230), true, caster, caster, caster:GetTeamNumber())
	--  -- dummyA:AddAbility("dummy_unit"):SetLevel(1)
	-- local dummyB = CreateUnitByName("dummy_unit_vulnerable", Vector(9257, -4160), true, caster, caster, caster:GetTeamNumber())
	-- dummyB:AddAbility("dummy_unit"):SetLevel(1)
	

	local rockfallParticle = "particles/dire_fx/dire_lava_falling_rocks.vpcf"
	Timers:CreateTimer(1, function()
		ScreenShake(adventurerA:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
		EmitGlobalSound("Hero_ElderTitan.EarthSplitter.Projectile")

		local position = Vector(9472, -4230, 770)
		local pfx = ParticleManager:CreateParticle(rockfallParticle, PATTACH_CUSTOMORIGIN, adventurerA)
		ParticleManager:SetParticleControl(pfx, 0, position)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
	Timers:CreateTimer(1.5, function()
		EmitSoundOn("meepo_meepo_haste_02", adventurerA)
		local position = Vector(9257, -4160, 770)
		local pfx = ParticleManager:CreateParticle(rockfallParticle, PATTACH_CUSTOMORIGIN, adventurerA)
		ParticleManager:SetParticleControl(pfx, 0, position)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
	Timers:CreateTimer(3.7, function()
		adventurerA:Kill(gameMasterAbil, Events.GameMaster)
	end)
	Timers:CreateTimer(4.3, function()
		EmitSoundOn("meepo_meepo_death_12", adventurerB)
		adventurerB:Kill(gameMasterAbil, Events.GameMaster)
	end)
	Timers:CreateTimer(5.2, function()
		Dungeons:UnlockCamerasAndReturnToHero()
	end)
	Timers:CreateTimer(10, function()
		if not adventurerA:IsNull() then
			UTIL_Remove(adventurerA)
		end
		if not adventurerB:IsNull() then
			UTIL_Remove(adventurerB)
		end
	end)

end

function beginAssault(caster)
	Dungeons.millAssault = true
	local sprite = caster.sprite
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	sprite:SetAbsOrigin(Vector(-14500, -9903))
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(gameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 20})
			PlayerResource:SetCameraTarget(playerID, sprite)
		end
	end
	sprite:MoveToPosition(Vector(-10576, -9286))
	sprite:DestroyAllSpeechBubbles()
	local time = 10
	local speechSlot = findEmptyDialogSlot()
	sprite:AddSpeechBubble(speechSlot, "#logging_camp_sprite_dialogue_seven", time, 0, 0)
	disableSpeech(sprite, time, speechSlot)
	Timers:CreateTimer(11, function()
		StartAnimation(sprite, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 0.8})
		local portal = CreateUnitByName("mill_assault_portal", Vector(-10176, -9216), true, nil, nil, DOTA_TEAM_GOODGUYS)

		portal:SetModel("models/heroes/pedestal/effigy_pedestal_radiant.vmdl")
		portalAbility = portal:AddAbility("town_portal")
		portalAbility:SetLevel(1)

		particleName = "particles/econ/events/ti5/town_portal_start_lvl2_ti5.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, portal)
		ParticleManager:SetParticleControl(particle1, 0, portal:GetAbsOrigin() + Vector(0, 0, 20))

		local tree = CreateUnitByName("lumber_mill_treant", Vector(-5888, -4544), true, nil, nil, DOTA_TEAM_GOODGUYS)

		Events:TeleportUnit(tree, Vector(-10176, -9216), portalAbility, portal, 0.5)
		Timers:CreateTimer(0.5, function()
			tree:MoveToPosition(Vector(-10176, -8960))
		end)
		tree:AddAbility("npc_dialogue"):SetLevel(1)
		tree.dialogueName = "treant"

		Timers:CreateTimer(2, function()
			sprite:DestroyAllSpeechBubbles()
			local speechSlot = findEmptyDialogSlot()
			tree:AddSpeechBubble(speechSlot, "#logging_camp_tree_dialogue_one", 6, 0, 0)
			disableSpeech(tree, time, speechSlot)
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
				if playerID then
					MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_disable_player")
					PlayerResource:SetCameraTarget(playerID, nil)
					EmitSoundOn("treant_treant_battlebegins_01", tree)
				end
			end
			EmitGlobalSound("greevil_loot_spawn_Stinger")
			prepareAssaultQuest()
			tree:MoveToPosition(Vector(-10176, -7488))
			Timers:CreateTimer(8, function()
				tree:MoveToPosition(Vector(-10236, -7488))
			end)
		end)
	end)
end

function prepareAssaultQuest()
	-- GameRules.millQuest = SpawnEntityFromTableSynchronous( "quest", { name = "QuestMill", title = "#assault_lumber_mill" } )
	-- GameRules.subMillQuest = SpawnEntityFromTableSynchronous( "subquest_base", {
	--   show_progress_bar = true,
	--   progress_bar_hue_shift = -119
	--   })
	-- GameRules.millQuest:AddSubquest( GameRules.subMillQuest )

	-- -- text on the quest timer at start
	-- GameRules.millQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 0 )
	-- GameRules.millQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 120 )

	-- -- value on the bar
	-- GameRules.subMillQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 0 )
	-- GameRules.subMillQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 120 )
	Dungeons.assaultKills = 0
	Dungeons.entryPoint = Vector(-10176, -9216)
	for i = 0, 2, 1 do
		Timers:CreateTimer(5 * i, function()
			local millWarrior1 = CreateUnitByName("mill_warrior", Vector(-10176, -9216), true, nil, nil, DOTA_TEAM_GOODGUYS)
			Events:AdjustDeathXP(millWarrior1)
			local millWarrior2 = CreateUnitByName("mill_warrior", Vector(-10176, -9216), true, nil, nil, DOTA_TEAM_GOODGUYS)
			Events:AdjustDeathXP(millWarrior2)
			local millWarrior3 = CreateUnitByName("mill_warrior", Vector(-10176, -9216), true, nil, nil, DOTA_TEAM_GOODGUYS)
			Events:AdjustDeathXP(millWarrior3)
			local millWarriorTree1 = CreateUnitByName("mill_warrior_tree", Vector(-10176, -9216), true, nil, nil, DOTA_TEAM_GOODGUYS)
			Events:AdjustDeathXP(millWarriorTree1)
			local millWarriorTree2 = CreateUnitByName("mill_warrior_tree", Vector(-10176, -9216), true, nil, nil, DOTA_TEAM_GOODGUYS)
			Events:AdjustDeathXP(millWarriorTree2)
			Timers:CreateTimer(0.2, function()
				millWarrior1:MoveToPositionAggressive(Vector(-12672, -7488))
				millWarrior2:MoveToPositionAggressive(Vector(-12672, -7488))
				millWarrior3:MoveToPositionAggressive(Vector(-12672, -7488))
				millWarriorTree1:MoveToPositionAggressive(Vector(-12672, -7488))
				millWarriorTree2:MoveToPositionAggressive(Vector(-12672, -7488))
			end)
		end)
	end
	Timers:CreateTimer(6, function()
		local guard = CreateUnitByName("gazbin_guard", Vector(-13120, -6976), true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(guard)
		guard = CreateUnitByName("gazbin_guard", Vector(-13120, -7936), true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(guard)
		for i = 0, 1, 1 do
			local unit = CreateUnitByName("gazbin_explosives_expert", Vector(-13312, -7488), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit:AddAbility("assault_abilities"):SetLevel(1)
			Events:AdjustDeathXP(unit)
			unit.assault = true
			Timers:CreateTimer(0.2, function()
				unit:SetAcquisitionRange(5000)
			end)
		end
		for i = 0, 5, 1 do
			local unit = CreateUnitByName("gazbin_berserker", Vector(-13312, -7488), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			unit:AddAbility("assault_abilities"):SetLevel(1)
			unit.assault = true
			Timers:CreateTimer(0.2, function()
				unit:SetAcquisitionRange(5000)
			end)
		end
		for i = 0, 5, 1 do
			local unit = CreateUnitByName("gazbin_recruit", Vector(-13312, -7488), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			unit:AddAbility("assault_abilities"):SetLevel(1)
			unit.assault = true
			Timers:CreateTimer(0.2, function()
				unit:SetAcquisitionRange(5000)
			end)
		end
		for i = 0, 1, 1 do
			local unit = CreateUnitByName("gazbin_brute", Vector(-13312, -7488), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			unit:AddAbility("assault_abilities"):SetLevel(1)
			unit.assault = true
			Timers:CreateTimer(0.2, function()
				unit:SetAcquisitionRange(5000)
			end)
		end
		for i = 0, 3, 1 do
			local unit = CreateUnitByName("gazbin_peon", Vector(-13312, -7488), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			unit:AddAbility("assault_abilities"):SetLevel(1)
			unit.assault = true
			Timers:CreateTimer(0.2, function()
				unit:SetAcquisitionRange(5000)
			end)
		end
		for i = 0, 3, 1 do
			local unit = CreateUnitByName("gazbin_mercenary_ranged", Vector(-13312, -7488), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			unit:AddAbility("assault_abilities"):SetLevel(1)
			unit.assault = true
			Timers:CreateTimer(0.2, function()
				unit:SetAcquisitionRange(5000)
			end)
		end
		for i = 0, 2, 1 do
			local unit = CreateUnitByName("gazbin_guard", Vector(-13312, -7488), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			unit:AddAbility("assault_abilities"):SetLevel(1)
			unit.assault = true
			Timers:CreateTimer(0.2, function()
				unit:SetAcquisitionRange(5000)
			end)
		end
	end)
end

function forestSprite(phase, caster)
	if phase == 1 then
		caster.sprite:DestroyAllSpeechBubbles()
		local time = 10
		local speechSlot = findEmptyDialogSlot()
		caster.sprite:AddSpeechBubble(speechSlot, "#logging_camp_sprite_dialogue_one", time, 0, 0)
		disableSpeech(caster.sprite, time, speechSlot)
	elseif phase == 2 then
		caster.sprite:MoveToPosition(caster:GetAbsOrigin())
	elseif phase == 3 then
		caster.sprite:MoveToPosition(Vector(-11520, -15232))
		Timers:CreateTimer(2, function()
			caster.sprite:DestroyAllSpeechBubbles()
			local time = 10
			local speechSlot = findEmptyDialogSlot()
			caster.sprite:AddSpeechBubble(speechSlot, "#logging_camp_sprite_dialogue_three", time, 0, 0)
			disableSpeech(caster.sprite, time, speechSlot)
		end)
	elseif phase == 4 then
		caster.sprite:MoveToPosition(Vector(-10112, -15232))
		Timers:CreateTimer(2, function()
			caster.sprite:DestroyAllSpeechBubbles()
			local time = 4
			local speechSlot = findEmptyDialogSlot()
			caster.sprite:AddSpeechBubble(speechSlot, "#logging_camp_sprite_dialogue_four", time, 0, 0)
			disableSpeech(caster.sprite, time, speechSlot)
		end)
	elseif phase == 5 then
		caster.sprite:MoveToPosition(Vector(-13760, -12240))
		Timers:CreateTimer(3, function()
			caster.sprite:DestroyAllSpeechBubbles()
			local time = 14
			local speechSlot = findEmptyDialogSlot()
			caster.sprite:AddSpeechBubble(speechSlot, "#logging_camp_sprite_dialogue_five", time, 0, 0)
			disableSpeech(caster.sprite, time, speechSlot)
		end)
	elseif phase == 6 then
		caster.sprite:MoveToPosition(Vector(-14500, -9903))
		Timers:CreateTimer(3, function()
			caster.sprite:DestroyAllSpeechBubbles()
			local time = 12
			local speechSlot = findEmptyDialogSlot()
			caster.sprite:AddSpeechBubble(speechSlot, "#logging_camp_sprite_dialogue_six", time, 0, 0)
			disableSpeech(caster.sprite, time, speechSlot)
		end)
	end
end

function sludgeGolems(caster)
	local golem1 = Dungeons:SpawnDungeonUnit("sludge_golem", caster:GetAbsOrigin(), 1, 2, 3, "n_creep_golemRock.Death", Vector(1, 0), true, nil)
	local golem2 = Dungeons:SpawnDungeonUnit("sludge_golem", caster:GetAbsOrigin(), 1, 2, 3, "n_creep_golemRock.Death", Vector(1, 0), true, nil)
	local golem3 = Dungeons:SpawnDungeonUnit("sludge_golem", caster:GetAbsOrigin(), 1, 2, 3, "n_creep_golemRock.Death", Vector(1, 0), true, nil)
end

function mercenarySwarm(caster)
	local vector1 = Vector(-10944, -12416)
	local vector2 = Vector(-10944, -12608)
	local vector3 = Vector(-10944, -12800)
	local zep1 = CreateUnitByName("reinforcement_zeppelin", Vector(-11944, -12416), true, nil, nil, DOTA_TEAM_NEUTRALS)
	zep1:FindAbilityByName("town_unit"):SetLevel(1)
	local zep2 = CreateUnitByName("reinforcement_zeppelin", Vector(-11944, -12608), true, nil, nil, DOTA_TEAM_NEUTRALS)
	zep2:FindAbilityByName("town_unit"):SetLevel(1)
	local zep3 = CreateUnitByName("reinforcement_zeppelin", Vector(-11944, -12800), true, nil, nil, DOTA_TEAM_NEUTRALS)
	zep3:FindAbilityByName("town_unit"):SetLevel(1)
	Timers:CreateTimer(0.5, function()
		zep1:MoveToPosition(vector1)
		zep2:MoveToPosition(vector2)
		zep3:MoveToPosition(vector3)
	end)

	Timers:CreateTimer(3.5, function()
		EmitSoundOn("bounty_hunter_bount_attack_09", zep1)
		EmitSoundOn("bounty_hunter_bount_attack_09", zep2)
		EmitSoundOn("bounty_hunter_bount_attack_09", zep3)
		for i = 0, 12, 1 do
			Timers:CreateTimer(0.5 * i, function()
				local unitName = "gazbin_mercenary"
				if i % 4 == 0 then
					unitName = "gazbin_mercenary_ranged"
				end
				local unit = Dungeons:SpawnDungeonUnit(unitName, vector1, 1, 0, 0, nil, Vector(1, 0), true, nil)
				StartAnimation(unit, {duration = 0.45, activity = ACT_DOTA_TELEPORT_END, rate = 1})
				unit = Dungeons:SpawnDungeonUnit(unitName, vector2, 1, 0, 0, nil, Vector(1, 0), true, nil)
				StartAnimation(unit, {duration = 0.45, activity = ACT_DOTA_TELEPORT_END, rate = 1})
				unit = Dungeons:SpawnDungeonUnit(unitName, vector3, 1, 0, 0, nil, Vector(1, 0), true, nil)
				StartAnimation(unit, {duration = 0.45, activity = ACT_DOTA_TELEPORT_END, rate = 1})
				EmitSoundOn("ui.inv_equip", zep1)
				EmitSoundOn("ui.inv_equip", zep2)
				EmitSoundOn("ui.inv_equip", zep3)
				if i == 9 then
					EmitSoundOn("bounty_hunter_bount_haste_02", zep1)
					EmitSoundOn("bounty_hunter_bount_haste_02", zep2)
					EmitSoundOn("bounty_hunter_bount_haste_02", zep3)
				end
			end)
		end
		Timers:CreateTimer(9, function()
			zep1:MoveToPosition(vector1 + Vector(0, 2000, 0))
			zep2:MoveToPosition(vector2 + Vector(0, 2000, 0))
			zep3:MoveToPosition(vector3 + Vector(0, 2000, 0))
			Timers:CreateTimer(5, function()
				UTIL_Remove(zep1)
				UTIL_Remove(zep2)
				UTIL_Remove(zep3)
			end)
		end)
	end)

	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-11776, -13248), 1, 0, 1, "alchemist_alch_anger_05", Vector(-1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-11392, -12416), 1, 0, 1, "alchemist_alch_anger_05", Vector(0, 1), false, nil)

end

function skeletonKing(caster)
	EmitGlobalSound("skeleton_king_wraith_kill_02")
	local position = caster:GetAbsOrigin()
	local floatingKing = caster.skeletonKing
	Timers:CreateTimer(1.5, function()
		ScreenShake(floatingKing:GetAbsOrigin(), 300, 0.5, 5, 9000, 0, true)
		EmitGlobalSound("Hero_ElderTitan.EarthSplitter.Projectile")
	end)
	Timers:CreateTimer(2.5, function()
		StartAnimation(floatingKing, {duration = 3.1, activity = ACT_DOTA_DIE, rate = 0.65})
	end)
	Timers:CreateTimer(5.7, function()
		UTIL_Remove(floatingKing)
		EmitGlobalSound("skeleton_king_wraith_respawn_03")
		EmitGlobalSound("skeleton_king_wraith_respawn_03")
		local king = Events:SpawnBoss("graveyard_boss", position)
		Events:AdjustBossPower(king, 4, 2, true)
		StartAnimation(king, {duration = 1, activity = ACT_DOTA_ATTACK_EVENT, rate = 0.5, translate = "wraith_spin"})
	end)

end

function graveyardBeacon1(caster)
	ScreenShake(caster:GetAbsOrigin(), 300, 0.5, 5, 9000, 0, true)
	EmitGlobalSound("Hero_ElderTitan.EarthSplitter.Projectile")
	local skull = caster.beacon
	local skeletonKingThinker = caster.skeletonKingThinker
	local position = caster.beacon:GetAbsOrigin()
	Timers:CreateTimer(1.0, function()
		EmitGlobalSound("valve_ti5.stinger.dire_lose")
		local particleName = "particles/items_fx/chain_lightning.vpcf"
		local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, skill)
		local casterPos = position
		local enemies = MAIN_HERO_TABLE
		for _, unit in pairs(enemies) do
			for i = 0, 2, 1 do
				Timers:CreateTimer(1 * i, function()
					local origin = unit:GetAbsOrigin()
					local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, skull)
					ParticleManager:SetParticleControl(lightningBolt, 0, Vector(casterPos.x, casterPos.y, casterPos.z + skull:GetBoundingMaxs().z))
					ParticleManager:SetParticleControl(lightningBolt, 1, Vector(origin.x, origin.y, origin.z + unit:GetBoundingMaxs().z))
				end)
			end
		end
		local ability = skull:FindAbilityByName("town_unit")
		ability:ApplyDataDrivenModifier(skull, skull, "skull_glow", {duration = 1200})

		local beaconParticle = "particles/units/heroes/hero_slark/beacon_glow_ground.vpcf"
		local pfx = ParticleManager:CreateParticle(beaconParticle, PATTACH_CUSTOMORIGIN, skull)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, position)
		ParticleManager:SetParticleControl(pfx, 2, position)
		ParticleManager:SetParticleControl(pfx, 3, position)
	end)
	Timers:CreateTimer(4.0, function()
		skeletonKingThinker.active = true
		EmitGlobalSound("skeleton_king_wraith_attack_04")
		EmitGlobalSound("skeleton_king_wraith_attack_04")
		EmitGlobalSound("skeleton_king_wraith_attack_04")
		EmitGlobalSound("skeleton_king_wraith_attack_04")
	end)
end

function graveyardChest(caster)
	local chest = caster.chest
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	StartAnimation(chest, {duration = 7, activity = ACT_DOTA_DIE, rate = 0.28})
	if caster.lootLaunch then
		Dungeons.lootLaunch = chest:GetAbsOrigin() + caster.lootLaunch
	else
		Dungeons.lootLaunch = chest:GetAbsOrigin() + Vector(-140, 0)
	end
	Timers:CreateTimer(2.0, function()
		for i = 0, RandomInt(5, 7), 1 do
			EmitSoundOn("General.FemaleLevelUp", chest)
			RPCItems:RollItemtype(300, chest:GetAbsOrigin(), 1, 0)
		end
		local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, chest)
		local origin = chest:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle1, 0, origin)
		ParticleManager:SetParticleControl(particle1, 1, origin)
		ParticleManager:SetParticleControl(particle1, 2, origin)
		ParticleManager:SetParticleControl(particle1, 3, origin)
	end)
	Timers:CreateTimer(6.5, function()
		Dungeons.lootLaunch = false
		UTIL_Remove(chest)
	end)
end

function skeletonSpawn(position)
	Dungeons:SpawnDungeonUnit("basic_skeleton", position, 5, 0, 0, nil, nil, false, nil)
end

function zombieSwarm()
	local vector1 = Vector(-6102, -12224)
	local vector2 = Vector(-6100, -11648)
	local vector3 = Vector(-7552, -11776)
	local vector4 = Vector(-7552, -12228)
	for i = 0, 10, 1 do
		Timers:CreateTimer(i * 2.5, function()
			Dungeons:SpawnDungeonUnit("zombie_warrior", vector1, 1, 0, 0, "undying_undying_anger_10", Vector(-1, 0), true, "zombie_warrior")
			Dungeons:SpawnDungeonUnit("zombie_warrior", vector2, 1, 0, 0, "undying_undying_anger_10", Vector(-1, 0), true, "zombie_warrior")
			Dungeons:SpawnDungeonUnit("zombie_warrior", vector3, 1, 0, 0, "undying_undying_anger_10", Vector(1, 0), true, "zombie_warrior")
			Dungeons:SpawnDungeonUnit("zombie_warrior", vector4, 1, 0, 0, "undying_undying_anger_10", Vector(1, 0), true, "zombie_warrior")
		end)
	end
end

function zombiePile()
	local vector = Vector(-5760, -14400)
	for i = 0, 7, 1 do
		Timers:CreateTimer(i * 1, function()
			Dungeons:SpawnDungeonUnit("npc_dota_creature_basic_zombie_exploding", vector, 1, 0, 0, "undying_undying_anger_02", Vector(-1, 1), true, nil)
		end)
	end
end

function zombieCathedral()
	local vector = Vector(-7424, -13888)
	for i = 0, 30, 1 do
		Timers:CreateTimer(i * 0.3, function()
			Dungeons:SpawnDungeonUnit("zombie_raider", vector, 1, 0, 0, nil, Vector(1, 0), true, "zombie_raider")
		end)
	end
end

function DungeonCreep(event)
	local caster = event.caster
	if not caster.aggro then
		local position = caster:GetAbsOrigin()
		local radius = 250
		if caster.aggroRadius then
			radius = caster.aggroRadius
		end
		if caster.aggroLock or caster.cantAggro then
			return false
		end
		local target_types = DOTA_UNIT_TARGET_HERO
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #units > 0 then
			for i = 1, #units, 1 do
				if units[i]:HasModifier("modifier_trapper_stealth") or units[i]:IsInvisible() then
				else
					local heightDiff = units[i]:GetAbsOrigin().z - caster:GetAbsOrigin().z
					local height_compare = 200
					if caster.aggro_height_adjust then
						height_compare = 200 + caster.aggro_height_adjust
					end
					if math.abs(heightDiff) > height_compare then
					else
						Dungeons:AggroUnit(caster)
					end
				end
			end
		end
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for i = 1, #allies, 1 do
			if allies[i].aggro then
				Dungeons:AggroUnit(caster)
			end
		end
	end
end

function aggroUnit(event)
	-- local caster = event.caster
	-- Dungeons:AggroUnit(caster)
end

function aggroUnitInvis(event)
	local caster = event.caster
	local attacker = event.attacker
	caster:MoveToTargetToAttack(attacker)
	Dungeons:AggroUnit(caster)
end

function alchemist_tree_strike(event)
	local target = event.target
	Dungeons:SpawnDungeonUnit("infected_treant", target:GetAbsOrigin(), 5, 0, 0, "treant_treant_anger_04", Vector(-1, 1), true, "")
	target:Kill(event.ability, event.caster)
end

function DungeonCreepDeath(event)
	local caster = event.caster
	-- if caster.minDungeonDrops then
	-- 	if caster.minDungeonDrops > 0 and caster.maxDungeonDrops > 0 then
	-- 		Events:RollExtraItems(caster:GetDeathXP(), caster:GetAbsOrigin(), caster.minDungeonDrops, caster.maxDungeonDrops)
	-- 	end
	-- end
end

function findEmptyDialogSlot()
	if not Events.Dialog1 then
		Events.Dialog1 = true
		return 1
	elseif not Events.Dialog2 then
		Events.Dialog2 = true
		return 2
	elseif not Events.Dialog3 then
		Events.Dialog3 = true
		return 3
	end
	return 4
end

function disableSpeech(caster, time, speechSlot)
	caster.hasSpeechBubble = true
	Timers:CreateTimer(time + 1, function()
		caster.hasSpeechBubble = false
		clearDialogSlot(speechSlot)
	end)
end

function clearDialogSlot(slot)
	if slot == 1 then
		Events.Dialog1 = false
	elseif slot == 2 then
		Events.Dialog2 = false
	elseif slot == 3 then
		Events.Dialog3 = false
	end
end

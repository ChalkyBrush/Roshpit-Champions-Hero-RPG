function Dungeons:InitializeGrizzlyFalls()
	Dungeons.grizzlyEntityTable = {}
	Dungeons.grizzlyStatus = 0
	Dungeons.grizzlyFalls = true
	Dungeons:EmitSoundOnLocationGuaranteed("Ambient.Waterfall", Vector(-13650, 5696))
	Timers:CreateTimer(20, function()
		 Dungeons:EmitSoundOnLocationGuaranteed("Ambient.Waterfall", Vector(-13650, 5696))
		if Dungeons.grizzlyFalls then
			return 20
		end
	end)
	

	local river_lizard = Dungeons:SpawnDungeonUnit("river_beast", Vector(-14948, -448), 1, 1, 2, "venomancer_venm_anger_01", Vector(-1,-0.2), false, nil)
	river_lizard:SetRenderColor(100, 100, 255)
	table.insert(Dungeons.grizzlyEntityTable, river_lizard)
	river_lizard = Dungeons:SpawnDungeonUnit("river_beast", Vector(-14799, 486), 1, 1, 2, "venomancer_venm_anger_01", Vector(0,-1), false, nil)
	river_lizard:SetRenderColor(100, 100, 255)
	table.insert(Dungeons.grizzlyEntityTable, river_lizard)

	local tribal_tank = Dungeons:SpawnDungeonUnit("grizzled_woodsman", Vector(-13952, -768), 1, 2, 3, "tusk_tusk_anger_01", Vector(0,1), false, nil)
			local properties =  {
			    pitch = -30,
			    yaw = 10,
			    roll = 90,
			    XPos = -20,
			    YPos = 10,
			    ZPos = -170,
			  }
			Attachments:AttachProp(tribal_tank, "attach_head", "models/items/witchdoctor/tribal_mask.vmdl", 1.1, properties)
			Events:AdjustBossPower(tribal_tank, 1, 1, false)
			tribal_tank:SetRenderColor(150, 150, 255)

			tribal_tank = Dungeons:SpawnDungeonUnit("grizzled_woodsman", Vector(-12928, 256), 1, 2, 3, "tusk_tusk_anger_01", Vector(-1,-1), false, nil)
			Attachments:AttachProp(tribal_tank, "attach_head", "models/items/witchdoctor/tribal_mask.vmdl", 1.1, properties)
			Events:AdjustBossPower(tribal_tank, 1, 1, false)
			tribal_tank:SetRenderColor(150, 150, 255)

	local worshipper_table = {Vector(-13952, -523), Vector(-13042, -729), Vector(-13042, -1125), Vector(-13963, 6), Vector(-13142, 354), Vector(-13386, -459), Vector(-13442, 354), Vector(-13586, -659)}
	for i = 1, #worshipper_table, 1 do
		Timers:CreateTimer(1.75*i, function()
			local wd = Dungeons:SpawnDungeonUnit("grizzly_twilight_worshipper", worshipper_table[i], 1, 1, 3, "witchdoctor_wdoc_anger_05", Vector(1,1), false, nil)
			table.insert(Dungeons.grizzlyEntityTable, wd)
		end)
	end
	
	Dungeons:SpawnDungeonUnit("grizzly_greedy_kobold", Vector(-14912, 1088), 1, 1, 1, "techies_tech_pain_09", Vector(1,-0.6), false, nil)
	Dungeons:SpawnDungeonUnit("grizzly_greedy_kobold", Vector(-14871, 1236), 1, 1, 1, "techies_tech_pain_09", Vector(0.4,-0.9), false, nil)
	Dungeons:SpawnDungeonUnit("grizzly_greedy_kobold", Vector(-14759, 1169), 1, 1, 1, "techies_tech_pain_09", Vector(0,-1), false, nil)
	local chestThinker = Dungeons:CreateDungeonThinker(Vector(-15070, 1305), "graveyardChest", 160, "graveyard")
	chestThinker.lootLaunch = Vector(100,-100)
	chestThinker.chest = CreateUnitByName("chest", Vector(-15070, 1305), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(1,-1))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)
	table.insert(Dungeons.grizzlyEntityTable, chestThinker.chest)

	chestThinker = Dungeons:CreateDungeonThinker(Vector(-12864, -384), "graveyardChest", 160, "graveyard")
	chestThinker.lootLaunch = Vector(-260,0)
	chestThinker.chest = CreateUnitByName("chest", Vector(-12864, -384), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(-1,0))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)
	table.insert(Dungeons.grizzlyEntityTable, chestThinker.chest)

	local crow_cultist = Dungeons:SpawnDungeonUnit("twilight_crow_cultist", Vector(-13696, 2240), 1, 5, 7, "shadowshaman_shad_kill_04", Vector(-1,-0.2), false, nil)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13696, 2240), 700, 99999, false)
	Events:AdjustBossPower(crow_cultist, 2, 3, false)
	local crow_ability = crow_cultist:FindAbilityByName("twilight_crow_cultist_ai")
	crow_ability:ApplyDataDrivenModifier(crow_cultist, crow_cultist, "modifier_twilight_crow_summoning", {})

	Dungeons.healer_ally = CreateUnitByName("grizzly_ally_healer", Vector(-13696, 2240)+Vector(-1,-0.2)*340, false, Events.GameMaster, nil, DOTA_TEAM_GOODGUYS)
	local ally_ability = Dungeons.healer_ally:FindAbilityByName("grizzly_helper_ai")
	ally_ability:ApplyDataDrivenModifier(Dungeons.healer_ally, Dungeons.healer_ally, "modifier_grizzly_helper_stage_one", {})
	Dungeons.healer_ally:SetAbsOrigin(Dungeons.healer_ally:GetAbsOrigin() +Vector(0,0,300))

	Dungeons.tank_ally = CreateUnitByName("grizzly_ally_tank", Vector(-13796, 2340)+Vector(-1,-0.2)*340, false, Events.GameMaster, nil, DOTA_TEAM_GOODGUYS)
	ally_ability = Dungeons.tank_ally:FindAbilityByName("grizzly_helper_ai")
	ally_ability:ApplyDataDrivenModifier(Dungeons.tank_ally, Dungeons.tank_ally, "modifier_grizzly_helper_stage_one", {})
	Dungeons.tank_ally:SetAbsOrigin(Dungeons.tank_ally:GetAbsOrigin() +Vector(0,0,300))

	    Dungeons.shackleParticle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_WORLDORIGIN, crow_cultist)
	    local link_point = Vector(-13849, 2368, 849)
        ParticleManager:SetParticleControl(Dungeons.shackleParticle1,0,link_point)   
        ParticleManager:SetParticleControl(Dungeons.shackleParticle1,1,Dungeons.tank_ally:GetAbsOrigin()+Vector(0,0,150))
        ParticleManager:SetParticleControl(Dungeons.shackleParticle1,3,link_point )
        for i = 2, 10, 1 do
        	ParticleManager:SetParticleControl(Dungeons.shackleParticle1,i,link_point )
  		 end

	    Dungeons.shackleParticle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_WORLDORIGIN, crow_cultist)
        ParticleManager:SetParticleControl(Dungeons.shackleParticle2,0,link_point )
        ParticleManager:SetParticleControl(Dungeons.shackleParticle2,1,Dungeons.healer_ally:GetAbsOrigin()+Vector(0,0,150))
        ParticleManager:SetParticleControl(Dungeons.shackleParticle2,3,link_point )
        for i = 2, 10, 1 do
        	ParticleManager:SetParticleControl(Dungeons.shackleParticle2,i,link_point)
  		 end
  		 Timers:CreateTimer(5, function()
	  		for i = 1, 20, 1 do
	  			local thinker = Dungeons:CreateDungeonThinker(Vector(-13464, 4381+175*i), "bridge_fish", 110, "grizzly_falls")
	  			table.insert(Dungeons.grizzlyEntityTable, thinker)
	  		end
  		end)
  		Dungeons:CreateDungeonThinker(Vector(-13504, 6272), "boss_preview_event", 140, "grizzly_falls")

  		

  		Dungeons.ogre = Dungeons:SpawnDungeonUnit("grizzly_sleepy_ogre", Vector(-12361,9088), 1, 5, 7, "ogre_magi_ogmag_anger_04", Vector(-1,-0.2), false, nil)
  		Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-12361,9088,67), Name ="wallObstruction"})
  		Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-12361,8979,67), Name ="wallObstruction"})
  		Dungeons.ogre:SetForwardVector(Vector(-0.5,1,1.8))
  		Dungeons.ogre:SetAbsOrigin(Dungeons.ogre:GetAbsOrigin()+Vector(-150,110,-60))
  		StartAnimation(Dungeons.ogre, {duration=0.8, activity=ACT_DOTA_DISABLED, rate=1})
  		Timers:CreateTimer(0.4, function()
  			  		local ogreAbil = Dungeons.ogre:FindAbilityByName("grizzly_sleepy_ogre_ai")
  					ogreAbil:ApplyDataDrivenModifier(Dungeons.ogre, Dungeons.ogre, "modifier_grizzly_sleepy_ogre_sleeping", {})
  		end)
  		Events:AdjustBossPower(Dungeons.ogre, 2, 2, false)

  		--CAVE ENTRANCE IN MEDUSA EVENT
end

function Dungeons:InitializeGrizzlyCave()
	Dungeons.entryPoint = Vector(-13440,9088)
	for i = 1, 7, 1 do
		local rockGuy = Dungeons:SpawnDungeonUnit("grizzly_cave_dweller", Vector(-10240, 9697)+Vector(90,0)*i+RandomVector(50), 1, 0, 1, "shadowshaman_shad_pain_07", RandomVector(1), false, nil)
		rockGuy:SetRenderColor(100, 100, 255)
	end
	local minX = -9466
	local maxX = -8758
	local minY = 9491
	local maxY = 9825
	for i = 1, 12, 1 do
		local rockGuy = Dungeons:SpawnDungeonUnit("grizzly_cave_dweller", Vector(RandomInt(minX, maxX), RandomInt(minY, maxY)), 1, 0, 1, "shadowshaman_shad_pain_07", RandomVector(1), false, nil)
		rockGuy:SetRenderColor(100, 100, 255)
	end
	minX = -9903
	maxX = -9403
	minY = 10423
	maxY = 10642
	for i = 1, 16, 1 do
		local rockGuy = Dungeons:SpawnDungeonUnit("grizzly_cave_dweller", Vector(RandomInt(minX, maxX), RandomInt(minY, maxY)), 1, 0, 1, "shadowshaman_shad_pain_07", RandomVector(1), false, nil)
		rockGuy:SetRenderColor(90, 100, 155)
	end
	
	local rockGuyLeader = Dungeons:SpawnDungeonUnit("grizzly_cave_dweller_leader", Vector(-8861,10522), 1, 2, 4, "shadowshaman_shad_pain_08", Vector(-1,-1), false, nil)
	Events:AdjustBossPower(rockGuyLeader, 1, 1, false)
	rockGuyLeader:SetRenderColor(100, 230, 255)
	Dungeons:CreateDungeonThinker(Vector(-9152, 8896), "cave_stage_two", 500, "grizzly_falls")
end

function Dungeons:GrizzlyCave2()
	local minX = -9545
	local maxX = -8980
	local minY = 7590
	local maxY = 8108
	for i = 1, 20, 1 do
		local rockGuy = Dungeons:SpawnDungeonUnit("grizzly_awakened_stone", Vector(RandomInt(minX, maxX), RandomInt(minY, maxY)), 1, 1, 1, "earth_spirit_earthspi_pain_03", Vector(0,1), false, nil)
		rockGuy:SetRenderColor(90,80,80)
	end
	local rockGuyLeader = Dungeons:SpawnDungeonUnit("grizzly_awakened_stone_leader", Vector(-9280, 7744), 1, 2, 3, "earth_spirit_earthspi_pain_13", Vector(0,1), false, nil)
	Events:AdjustBossPower(rockGuyLeader, 1, 1, false)

	minX = -8448
	maxX = -8149
	minY = 5818
	maxY = 7203
	for i = 1, 8, 1 do
		Timers:CreateTimer(0.3*i, function()
			local rockGuy = Dungeons:SpawnDungeonUnit("grizzly_ancient_crag_golem", Vector(RandomInt(minX, maxX), RandomInt(minY, maxY)), 1, 1, 2, "earth_spirit_earthspi_anger_08", RandomVector(1), false, nil)
		end)
	end
	local graniteBoss = Dungeons:SpawnDungeonUnit("grizzly_granite_apparition", Vector(-10048, 7296), 1, 3, 6, "earth_spirit_earthspi_attack_03", Vector(1,1), false, nil)
	graniteBoss:SetRenderColor(20,20,20)
	Events:AdjustBossPower(graniteBoss, 1, 2, false)

	local luck = RandomInt(1, 3)
	local chestLocTable = {Vector(-8640, 5760), Vector(-9969, 4509), Vector(-11264, 71314)}
	local chestThinker = Dungeons:CreateDungeonThinker(chestLocTable[luck], "graveyardChest", 160, "graveyard")
	chestThinker.lootLaunch = Vector(100,-100)
	chestThinker.chest = CreateUnitByName("chest", chestLocTable[luck], true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(1,-1))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)
	if Dungeons.grizzlyEntityTable then
		table.insert(Dungeons.grizzlyEntityTable, chestThinker.chest)
	end	
	Timers:CreateTimer(4, function()
		local rockGuy = Dungeons:SpawnDungeonUnit("grizzly_ancient_crag_golem", Vector(-10560, 6336), 1, 1, 2, "earth_spirit_earthspi_anger_08", RandomVector(1), false, nil)
		local rockGuy = Dungeons:SpawnDungeonUnit("grizzly_ancient_crag_golem", Vector(-10260, 6336), 1, 1, 2, "earth_spirit_earthspi_anger_08", RandomVector(1), false, nil)
		minX = -10816
		maxX = -10289
		minY = 6144
		maxY = 6595
		for i = 1, 7, 1 do
			local rockGuy = Dungeons:SpawnDungeonUnit("grizzly_awakened_stone", Vector(RandomInt(minX, maxX), RandomInt(minY, maxY)), 1, 1, 2, "earth_spirit_earthspi_pain_03", RandomVector(1), false, nil)
			rockGuy:SetRenderColor(90,80,80)
		end
	end)
	Timers:CreateTimer(6, function()
		for i = 0, 5, 1 do
			local hydra = Dungeons:SpawnDungeonUnit("grizzly_water_hydra", Vector(-9856, 5952)+i*Vector(100,-100)+RandomVector(90), 1, 1, 2, "venomancer_venm_anger_01", RandomVector(1), false, nil)
			hydra:SetRenderColor(60, 110, 210)
		end
	end)
	local big_fungus = Dungeons:SpawnDungeonUnit("fungal_overlord", Vector(-9280, 4736), 1, 1, 4, nil, Vector(0.2, 1), false, nil)
	big_fungus:SetModelScale(1.1)
	big_fungus:RemoveAbility("desert_ruins_ability")
	Timers:CreateTimer(10, function()
		for i = 0, 8, 1 do
			local shroom = Dungeons:SpawnDungeonUnit("grizzly_cave_shroomling", Vector(-10560, 3712)+i*Vector(150,150)+RandomVector(150), 1, 0, 1, "Miniboss_Greevil.Death", RandomVector(1), false, nil)
			shroom:SetAbsOrigin(shroom:GetAbsOrigin()-Vector(0,0,70))
			shroom:SetRenderColor(60, 110, 110)
			local ability = shroom:FindAbilityByName("grizzly_cave_shroom_ai")
			ability:ApplyDataDrivenModifier(shroom, shroom, "modifier_cave_shroom_ai", {})
		end
		minX = -10902
		maxX = -10367
		minY = 3355
		maxY = 4056
		for i = 0, 6, 1 do
			local shroom = Dungeons:SpawnDungeonUnit("grizzly_cave_shroomling", Vector(RandomInt(minX, maxX), RandomInt(minY, maxY)), 1, 0, 1, "Miniboss_Greevil.Death", RandomVector(1), false, nil)
			shroom:SetAbsOrigin(shroom:GetAbsOrigin()-Vector(0,0,66))
			shroom:SetRenderColor(60, 110, 110)
			local ability = shroom:FindAbilityByName("grizzly_cave_shroom_ai")
			ability:ApplyDataDrivenModifier(shroom, shroom, "modifier_cave_shroom_ai", {})
		end
	end)
	Timers:CreateTimer(15, function()
		local acolyte = Dungeons:SpawnDungeonUnit("grizzly_medusa_acolyte", Vector(-10292, 576), 1, 3, 4, "medusa_medus_attack_14", Vector(0,1), false, nil)
		local acolyte2 = Dungeons:SpawnDungeonUnit("grizzly_medusa_acolyte", Vector(-9728, 576), 1, 3, 4, "medusa_medus_anger_09", Vector(0,1), false, nil)
		acolyte.ally = acolyte2
		acolyte2.ally = acolyte
		Events:AdjustBossPower(acolyte, 2, 2, false)
		Events:AdjustBossPower(acolyte2, 2, 2, false)
		Dungeons.acolyteKills = 0
		Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-9984,-1390,76), Name ="wallObstruction"})
		Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-10112,-1390,76), Name ="wallObstruction"})
		Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-10240,-1390,76), Name ="wallObstruction"})
		Dungeons.blocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-10368,-1390,76), Name ="wallObstruction"})
		Dungeons.blocker5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-10496,-1390,76), Name ="wallObstruction"})
		local particle = "particles/units/heroes/hero_dark_seer/leshrac_wallof_replica.vpcf"
		Dungeons.wallParticle = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, acolyte )
		local wallPoint1 = Vector(-10600, -1390, 100)
		local wallPoint2 = Vector(-9856, -1390, 100)
		ParticleManager:SetParticleControl( Dungeons.wallParticle, 0, wallPoint1 )
		ParticleManager:SetParticleControl( Dungeons.wallParticle, 1, wallPoint2 )
	end)
end

function Dungeons:GrizzlyInitiateBoss()
	Dungeons.grizzlyFalls = false
	Dungeons.grizzlyStatus = 3
	CustomGameEventManager:Send_ServerToAllClients("fadeToBlack", {})
	Dungeons.entryPoint = Vector(-10432,-1728)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 1.1})
			PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
		end
	end
	Timers:CreateTimer(0.5, function()
		EmitSoundOnLocationWithCaster(Vector(-10432,-1728), "Ability.Avalanche", Events.GameMaster)
	end)
	local antimage = Dungeons.antiMage
	Timers:CreateTimer(1.1, function()
		if IsValidEntity(Dungeons.tank_ally) then
			FindClearSpaceForUnit(Dungeons.tank_ally, Vector(-10432,-1728), false)
		end
		if IsValidEntity(Dungeons.healer_ally) then
			FindClearSpaceForUnit(Dungeons.healer_ally, Vector(-10432,-1728), false)
		end
		for i = 1, #MAIN_HERO_TABLE, 1 do
			FindClearSpaceForUnit(MAIN_HERO_TABLE[i], Vector(-10432,-1728), false)	
			Timers:CreateTimer(0.2, function()
				local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
				if playerID then
					PlayerResource:SetCameraTarget(playerID, nil)
				end	
			end)
		end
		Timers:CreateTimer(0.5, function()
			-- EmitGlobalSound("Grizzly.BossMusic")
			Dungeons.bossMusic = CreateUnitByName("npc_flying_dummy_vision", Vector(-10176, -2816), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Dungeons.bossMusic:AddAbility("dummy_unit"):SetLevel(1)
			StartSoundEventReliable("Grizzly.BossMusic", Dungeons.bossMusic)
		end)
		Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-9984,-1390,76), Name ="wallObstruction"})
		Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-10112,-1390,76), Name ="wallObstruction"})
		Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-10240,-1390,76), Name ="wallObstruction"})
		Dungeons.blocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-10368,-1390,76), Name ="wallObstruction"})
		Dungeons.blocker5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-10496,-1390,76), Name ="wallObstruction"})

		Dungeons.wall1 = CreateUnitByName("npc_dummy_unit", Vector(-10376,-1244), false, nil, nil, DOTA_TEAM_NEUTRALS)
		Dungeons.wall1:SetOriginalModel("models/props_mines/mines_rocks_ramp_nsew_03b.vmdl")
		Dungeons.wall1:SetModel("models/props_garden/good_stonewall001c.vmdl")
		Dungeons.wall1:SetModelScale(1.75)
		Dungeons.wall1:SetForwardVector(Vector(1,0))
		Dungeons.wall1:FindAbilityByName("dummy_unit"):SetLevel(1)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-10376,-1344), 300, 99999, false)

		Dungeons.wall2 = CreateUnitByName("npc_dummy_unit", Vector(-10121,-1244), false, nil, nil, DOTA_TEAM_NEUTRALS)
		Dungeons.wall2:SetOriginalModel("models/props_mines/mines_rocks_ramp_nsew_03b.vmdl")
		Dungeons.wall2:SetModel("models/props_mines/mines_rocks_ramp_nsew_03b.vmdl")
		Dungeons.wall2:SetModelScale(1.75)
		Dungeons.wall2:SetForwardVector(Vector(1,0))
		Dungeons.wall2:FindAbilityByName("dummy_unit"):SetLevel(1)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-10121,-1344), 300, 99999, false)
		Dungeons:GrizzlyInitiateBoss2()
	end)
end

function Dungeons:GrizzlyInitiateBoss2()
Dungeons.grizzlyFalls = false
EmitGlobalSound("Tiny.Grow")
	ScreenShake(Vector(-10176, -2816), 300, 1.1, 0.7, 9000, 0, true)
	Timers:CreateTimer(1, function()
		EmitGlobalSound("Tiny.Grow")
		ScreenShake(Vector(-10176, -2816), 300, 1.1, 0.7, 9000, 0, true)
	end)
	Timers:CreateTimer(2, function()
		EmitGlobalSound("Tiny.Grow")
		ScreenShake(Vector(-10176, -2816), 300, 1.1, 0.7, 9000, 0, true)
	end)
	Timers:CreateTimer(3, function()
		EmitGlobalSound("Tiny.Grow")
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-10176, -2816), 1000, 99999, false)
		ScreenShake(Vector(-10176, -2816), 300, 1.1, 0.7, 9000, 0, true)
		local medusaBoss = Events:SpawnBoss("grizzly_falls_boss", Vector(-10176, -2816))
		Dungeons.medusaBoss = medusaBoss
		Events:AdjustBossPower(medusaBoss, 7, 6, true)
		local origPos = medusaBoss:GetAbsOrigin()
		medusaBoss:SetAbsOrigin(origPos-Vector(0,0,700))
		medusaBoss:SetForwardVector(Vector(1,0))
		for k = 1, 50, 1 do
			Timers:CreateTimer(k*0.03, function()
				medusaBoss:SetAbsOrigin(medusaBoss:GetAbsOrigin()+Vector(0,0,12))
			end)
		end
		-- Timers:CreateTimer(0.5, function()
		-- 	EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "Hero_Medusa.StoneGaze.Cast", medusaBoss)

		-- end)
		local bossAbility = medusaBoss:FindAbilityByName("grizzly_falls_boss_ai")
		Timers:CreateTimer(0.03, function()
			Timers:CreateTimer(1.5, function()
				local screamAbility = medusaBoss:FindAbilityByName("grizzly_boss_slow_scream")
				local newOrder = {
			 		UnitIndex = medusaBoss:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = screamAbility:entindex(),
				 	}
				 
				ExecuteOrderFromTable(newOrder)
			end)
		  for i = 1, 7, 1 do
		      particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
		      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, medusaBoss )
		      ParticleManager:SetParticleControl( particle2, 0, origPos-Vector(0,0,110)+RandomVector(120))
		      ScreenShake(origPos, 200, 0.9, 10*0.05, 9000, 0, true)
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle2, false )
		      end)
	      end
	      	particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, medusaBoss )
		      ParticleManager:SetParticleControl( particle1, 0, origPos-Vector(0,0,140) )
		      ScreenShake(origPos, 200, 0.9, 10*0.05, 9000, 0, true)
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)
		      EmitSoundOn("Ability.Torrent", medusaBoss)
	    end)
		Timers:CreateTimer(4.5, function()
			EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "medusa_medus_attack_07", medusaBoss)
			EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "medusa_medus_attack_07", medusaBoss)
			medusaBoss.realBoss = true
		end)
	end)
end

function Dungeons:DebugGrizzlyFalls()
	-- EmitGlobalSound("Ambient.CaveEntrance")

	-- Timers:CreateTimer(34, function()
	-- 	EmitGlobalSound("Ambient.CaveAmbient")
	-- 	return 67
	-- end)
	-- Dungeons:InitializeGrizzlyCave()
		-- Dungeons.tank_ally = Events.GameMaster
		-- Dungeons.healer_ally = Events.GameMaster
		-- Dungeons:GrizzlyInitiateBoss()
		-- Dungeons:BossPreviewEvent()
		-- if Dungeons.ogre then
		-- 	UTIL_Remove(Dungeons.ogre)
		-- end
  -- 		Dungeons.ogre = Dungeons:SpawnDungeonUnit("grizzly_sleepy_ogre", Vector(-12361,9088), 1, 5, 7, "ogre_magi_ogmag_anger_04", Vector(-1,-0.2), false, nil)
  -- 		Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-12361,9088,67), Name ="wallObstruction"})
  -- 		Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-12361,8979,67), Name ="wallObstruction"})
  -- 		Dungeons.ogre:SetForwardVector(Vector(-0.4,-1))
  -- 		Dungeons.ogre:SetAbsOrigin(Dungeons.ogre:GetAbsOrigin()+Vector(-70,-280,0))
  -- 		StartAnimation(Dungeons.ogre, {duration=0.8, activity=ACT_DOTA_DIE, rate=2.4})
  -- 		Timers:CreateTimer(0.6, function()
  -- 			  		local ogreAbil = Dungeons.ogre:FindAbilityByName("grizzly_sleepy_ogre_ai")
  -- 					ogreAbil:ApplyDataDrivenModifier(Dungeons.ogre, Dungeons.ogre, "modifier_grizzly_sleepy_ogre_sleeping", {})
  -- 		end)

end

function Dungeons:BossPreviewEvent()
	EmitGlobalSound("Tiny.Grow")
	ScreenShake(Vector(-13504, 6272), 300, 1.1, 0.7, 9000, 0, true)
	Timers:CreateTimer(1, function()
		EmitGlobalSound("Tiny.Grow")
		ScreenShake(Vector(-13504, 6272), 300, 1.1, 0.7, 9000, 0, true)
	end)
	Timers:CreateTimer(2, function()
		EmitGlobalSound("Tiny.Grow")
		ScreenShake(Vector(-13504, 6272), 300, 1.1, 0.7, 9000, 0, true)
		local medusaBoss = CreateUnitByName("grizzly_falls_boss", Vector(-14080, 6464), false, nil, nil, DOTA_TEAM_NEUTRALS)
		local origPos = medusaBoss:GetAbsOrigin()
		medusaBoss:SetForwardVector(Vector(1,0))
		medusaBoss:SetAbsOrigin(origPos-Vector(0,0,12)*50)
		for k = 1, 50, 1 do
			Timers:CreateTimer(0.03*k, function()
			medusaBoss:SetAbsOrigin(medusaBoss:GetAbsOrigin()+Vector(0,0,12))
			end)
		end
		Timers:CreateTimer(0.3, function()
			EmitGlobalSound("Hero_Medusa.StoneGaze.Cast")
			CustomGameEventManager:Send_ServerToAllClients("grizzly_medusa_event", {duration = 8})
		end)
		Timers:CreateTimer(0.5, function()
			EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "Hero_Medusa.StoneGaze.Cast", medusaBoss)
			EmitGlobalSound("Hero_Medusa.StoneGaze.Cast")
			if Dungeons.grizzlyStatus >= 1 and Dungeons.tank_ally then
				if IsValidEntity(Dungeons.tank_ally) then
					Dungeons.tank_ally:AddSpeechBubble(1, "#grizzly_tank_dialogue_one", 5, 0, 0)
				end
			end
		end)
		local bossAbility = medusaBoss:FindAbilityByName("grizzly_falls_boss_ai")
		bossAbility:ApplyDataDrivenModifier(medusaBoss, medusaBoss, "modifier_falls_boss_intro_sequence", {})
		Timers:CreateTimer(0.87, function()
		  for i = 1, 7, 1 do
		      particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
		      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, medusaBoss )
		      ParticleManager:SetParticleControl( particle2, 0, origPos-Vector(0,0,110)+RandomVector(120))
		      ScreenShake(origPos, 200, 0.9, 10*0.05, 9000, 0, true)
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle2, false )
		      end)
	      end
	      	particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, medusaBoss )
		      ParticleManager:SetParticleControl( particle1, 0, origPos-Vector(0,0,140) )
		      ScreenShake(origPos, 200, 0.9, 10*0.05, 9000, 0, true)
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)
		      EmitSoundOn("Ability.Torrent", medusaBoss)
	    end)
		local visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(-14080, 6464, 840), true, nil, nil, DOTA_TEAM_NEUTRALS)
		visionTracer:AddAbility("dummy_unit"):SetLevel(1)
		visionTracer:SetAbsOrigin(Vector(-14080, 6464, 840))
		Timers:CreateTimer(3, function()
			for k = 0, 1, 1 do
				Timers:CreateTimer(1.3*k, function()
					StartAnimation(medusaBoss, {duration=2.5, activity=ACT_DOTA_ATTACK, rate=0.5})
					EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "Ability.PowershotPull", medusaBoss)
					Timers:CreateTimer(0.9, function()
						EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "Hero_DrowRanger.FrostArrows", medusaBoss)
						for i=-7, 7, 1 do 
							rotatedVector = WallPhysics:rotateVector(medusaBoss:GetForwardVector(), math.pi/40*i)
							arrowOrigin = visionTracer:GetAbsOrigin() + medusaBoss:GetForwardVector()*Vector(80,80,0)
							local start_radius = 110
							local end_radius = 110
							local speed = 1100
							local range = 2000
							local info = 
							{
									Ability = bossAbility,
							    	EffectName = "particles/frostivus_herofx/medusa_linear_arrow.vpcf",
							    	vSpawnOrigin = arrowOrigin,
							    	fDistance = range,
							    	fStartRadius = start_radius,
							    	fEndRadius = end_radius,
							    	Source = visionTracer,
							    	bHasFrontalCone = false,
							    	bReplaceExisting = false,
							    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
							    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
							    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							    	fExpireTime = GameRules:GetGameTime() + 5.0,
								bDeleteOnHit = false,
								vVelocity = rotatedVector * speed,
								bProvidesVision = false,
							}
							projectile = ProjectileManager:CreateLinearProjectile(info)	
						end				
					end)
				end)
			end
		end)
		Timers:CreateTimer(6.5, function()
			EmitGlobalSound("medusa_medus_stonegaze_10")
			Timers:CreateTimer(2.6, function()
				EmitGlobalSound("medusa_medus_anger_16")
			end)
		end)
		Timers:CreateTimer(9, function()
			StartAnimation(medusaBoss, {duration=1, activity=ACT_DOTA_MEDUSA_STONE_GAZE, rate=1})
			for j = 1, 40, 1 do
				Timers:CreateTimer(0.03*j, function()
					medusaBoss:SetAbsOrigin(medusaBoss:GetAbsOrigin()-Vector(0,0,30))
				end)
			end
			ScreenShake(Vector(-13504, 6272), 300, 1.1, 0.7, 9000, 0, true)
			Timers:CreateTimer(0.57, function()
			  for i = 1, 7, 1 do
			      particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
			      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, medusaBoss )
			      ParticleManager:SetParticleControl( particle2, 0, origPos-Vector(0,0,110)+RandomVector(120))
			      ScreenShake(origPos, 200, 0.9, 10*0.05, 9000, 0, true)
			      Timers:CreateTimer(4, 
			      function()
			        ParticleManager:DestroyParticle( particle2, false )
			      end)
		      end
		      	particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, medusaBoss )
			      ParticleManager:SetParticleControl( particle1, 0, origPos-Vector(0,0,140) )
			      ScreenShake(origPos, 200, 0.9, 10*0.05, 9000, 0, true)
			      Timers:CreateTimer(4, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)
			      EmitSoundOn("Ability.Torrent", medusaBoss)
			      Dungeons.ogre:RemoveModifierByName("modifier_grizzly_sleepy_ogre_sleeping")
			      UTIL_Remove(Dungeons.blocker1)
			      UTIL_Remove(Dungeons.blocker2)
			      Dungeons.blocker1 = nil
			      Dungeons.blocker2 = nil
			      Dungeons:CreateDungeonThinker(Vector(-11776, 8960), "cave_entrance", 440, "grizzly_falls")
			      FindClearSpaceForUnit(Dungeons.ogre, Vector(-12361,9088), false)
			      Dungeons.ogre:SetForwardVector(Vector(-1,0))
		    end)
			Timers:CreateTimer(1.5, function()
				UTIL_Remove(medusaBoss)
				UTIL_Remove(visionTracer)
			end)
		end)
	end)
end

function Dungeons:BridgeFishThinker(position)
	local animationTable = {ACT_DOTA_SLARK_POUNCE, ACT_DOTA_CAST_ABILITY_1}
	
	local fvTable = {Vector(1,0), Vector(-1,0)}
	for i = 1, 4, 1 do
		local randomOffset = RandomInt(1,100)
		local spawnTable = {position-Vector(420+randomOffset,0), position+Vector(420+randomOffset,0)}
		local spot = RandomInt(1,2)
		local fish = Dungeons:SpawnDungeonUnit("grizzly_bridge_fish", spawnTable[spot], 1, 0, 0, nil, fvTable[spot], true, nil)
		if i == 1 then
			EmitSoundOn("Hero_Slark.Pounce.Cast", fish)
		end 
		local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
	    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, fish)
	    for j = 0, 4, 1 do
        	ParticleManager:SetParticleControl(pfx,j,fish:GetAbsOrigin() )
    	end
        Timers:CreateTimer(1, function()
        	ParticleManager:DestroyParticle(pfx, false)
        end)
	     
		StartAnimation(fish, {duration=0.8, activity=animationTable[RandomInt(1,2)], rate=1})
		WallPhysics:Jump(fish, fvTable[spot], 32, 105, 3.2, 1)
	end
	Dungeons:spawnMedusaGuard(position)
	if Dungeons.grizzlyStatus >= 1 then
		if IsValidEntity(Dungeons.tank_ally) then
			Dungeons.tank_ally:MoveToPosition(position)
		end
		if IsValidEntity(Dungeons.healer_ally) then
			Dungeons.healer_ally:MoveToPositionAggressive(position+Vector(0,-400))
		end
	end
end

function Dungeons:spawnMedusaGuard(position)
	local fvTable = {Vector(1,0), Vector(1,0), Vector(-1,0)}
	local minX1 = -14243
	local maxX1 = -13795
	local maxY1 = 7872
	local minY1 = 4420
	local minX2 = -13062
	local maxX2 = -12825
	local side = RandomInt(1, 3)
	local moveToVector = Vector(0,0)
	if side == 3 then
		moveToVector = Vector(RandomInt(minX2, maxX2), position.y)
	else
		moveToVector = Vector(RandomInt(minX1, maxX1), position.y)
	end
	local medusa = Dungeons:SpawnDungeonUnit("grizzly_twilight_guardian", moveToVector, 1, 0, 0,"medusa_medus_anger_11", fvTable[side], true, nil)

	medusa:SetAbsOrigin(GetGroundPosition(medusa:GetAbsOrigin(), medusa)-Vector(0,0,1100))
	for i = 1, 20, 1 do
		medusa:SetAbsOrigin(medusa:GetAbsOrigin()+Vector(0,0,5)*i)
	end
	local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, medusa)
    for j = 0, 4, 1 do
    	ParticleManager:SetParticleControl(pfx,j,moveToVector )
	end
    Timers:CreateTimer(1, function()
    	ParticleManager:DestroyParticle(pfx, false)
    end)	
end

function Dungeons:EmitSoundOnLocationGuaranteed(soundName, soundPosition, unit)
		if Dungeons.waterfallSound then
			StopSoundOn(soundName, Dungeons.waterfallSound)
			UTIL_Remove(Dungeons.waterfallSound)
		end
		Dungeons.waterfallSound = CreateUnitByName("npc_flying_dummy_vision", soundPosition, true, nil, nil, DOTA_TEAM_GOODGUYS)
		Dungeons.waterfallSound:AddAbility("dummy_unit"):SetLevel(1)
		if MAIN_HERO_TABLE[1] then
			Dungeons.waterfallSound:SetAbsOrigin(MAIN_HERO_TABLE[1]:GetAbsOrigin())
			EmitSoundOn(soundName, Dungeons.waterfallSound)
			Timers:CreateTimer(0.03, function()
				Dungeons.waterfallSound:SetAbsOrigin(soundPosition)
			end)
		end
end
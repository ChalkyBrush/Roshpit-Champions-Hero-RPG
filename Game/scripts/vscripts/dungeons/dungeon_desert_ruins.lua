function Dungeons:InitializeDesertRuins()
	Dungeons.ruinsEntityTable = {}
	Dungeons.ruinsParticleTable = {}
	local spawnPositionTable = {Vector(10496, 10048), Vector(9792, 10713), Vector(10343, 11065), Vector(9510, 10434), Vector(10708, 10629), Vector(9814, 11203), Vector(10598, 11637), Vector(9342, 11107), Vector(9251, 10224), Vector(10615, 11487), Vector(10477, 11548), Vector(10547, 12391), Vector(9542, 12088), Vector(10083, 10720), Vector(9156, 10452), Vector(9919, 11126), Vector(8742, 10058), Vector(9441, 10572)}
	local attackMoveToTable = {Vector(9653, 10467), Vector(10677, 10713), Vector(9510, 10772), Vector(10599, 11010), Vector(9814, 10859), Vector(10543, 11203), Vector(9738, 11406), Vector(10026, 10669), Vector(10406, 10408), Vector(9608, 11579), Vector(9995, 11981), Vector(9870, 111534), Vector(10615, 11467), Vector(9824, 10720), Vector(10521, 11126), Vector(8979, 10582), Vector(9956, 11061), Vector(10729, 10096)}
	for i = 1, #spawnPositionTable, 1 do
		Timers:CreateTimer(0.4 * i, function()
			local hunter = Dungeons:SpawnDungeonUnit("feathered_hunter", spawnPositionTable[i], 1, 1, 1, "meepo_meepo_anger_05", Vector(1, 0), false, nil)
			hunter.startPos = spawnPositionTable[i]
			hunter.movePos = attackMoveToTable[i]
		end)
	end
	local thinker = Dungeons:CreateDungeonThinker(Vector(10048, 10353), "initial_spawn", 390, "desert_ruins")
	Dungeons:SpawnDungeonUnit("nomadic_hunter", Vector(9344, 11845), 1, 2, 3, "bloodseeker_blod_anger_05", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("nomadic_hunter", Vector(9792, 14208), 1, 2, 3, "bloodseeker_blod_anger_05", Vector(0, -1), false, nil)
	Dungeons:SpawnDungeonUnit("nomadic_hunter", Vector(8192, 13312), 1, 2, 3, "bloodseeker_blod_anger_05", Vector(0, -1), false, nil)
	Dungeons:SpawnDungeonUnit("nomadic_hunter", Vector(7296, 15872), 1, 2, 3, "bloodseeker_blod_anger_05", Vector(0, -1), false, nil)
	local bloodPillarLoc = Vector(8704, 10432, 150)
	local bloodWorshipperSpawnTable = {Vector(8824, 10334), Vector(8824, 10560), Vector(8675, 10240), Vector(8560, 10368), Vector(8601, 10591)}
	for i = 1, #bloodWorshipperSpawnTable, 1 do
		local fv = (bloodPillarLoc - bloodWorshipperSpawnTable[i]):Normalized()
		local bloodMinion = Dungeons:SpawnDungeonUnit("blood_worshipper", bloodWorshipperSpawnTable[i], 1, 1, 2, "dazzle_dazz_anger_04", fv, false, nil)
		bloodMinion:SetRenderColor(150, 0, 0)
		bloodMinion.bloodPillarLoc = bloodPillarLoc
	end

	-- local meepoSpawnTable = {Vector(10304, 13056), Vector(10304, 13178)}
	Timers:CreateTimer(8, function()
		for i = 0, 5, 1 do
			local meepo = Dungeons:SpawnDungeonUnit("desert_explorer", Vector(10304, 13056 + i * 120), 1, 1, 1, "meepo_meepo_anger_06", Vector(-1, 0), false, nil)
		end
	end)
	local patrolPoint1 = Vector(7165, 9865)
	local patrolPoint2 = Vector(10268, 11660)
	local patrolPoint3 = Vector(8640, 15744)
	Timers:CreateTimer(10, function()
		Dungeons:SpawnDungeonUnit("wandering_mage_ruins", patrolPoint1 + Vector(-100, 0), 1, 2, 3, "keeper_of_the_light_keep_incant_01", Vector(-1, 0), false, nil)
		Dungeons:SpawnDungeonUnit("wandering_mage_ruins", patrolPoint1 + Vector(100, 0), 1, 2, 3, "keeper_of_the_light_keep_incant_01", Vector(-1, 0), false, nil)
		Timers:CreateTimer(50, function()
			Dungeons:SpawnDungeonUnit("wandering_mage_ruins", patrolPoint2 + Vector(-100, 0), 1, 2, 3, "keeper_of_the_light_keep_incant_01", Vector(-1, 0), false, nil)
			Dungeons:SpawnDungeonUnit("wandering_mage_ruins", patrolPoint2 + Vector(100, 0), 1, 2, 3, "keeper_of_the_light_keep_incant_01", Vector(-1, 0), false, nil)
		end)
		Timers:CreateTimer(90, function()
			Dungeons:SpawnDungeonUnit("wandering_mage_ruins", patrolPoint3 + Vector(-100, 0), 1, 2, 3, "keeper_of_the_light_keep_incant_01", Vector(-1, 0), false, nil)
			Dungeons:SpawnDungeonUnit("wandering_mage_ruins", patrolPoint3 + Vector(100, 0), 1, 2, 3, "keeper_of_the_light_keep_incant_01", Vector(-1, 0), false, nil)
		end)
	end)
	local necromancer = Dungeons:SpawnDungeonUnit("desert_ruins_necromancer", Vector(7140, 12738), 1, 2, 3, "necrolyte_necr_deny_10", Vector(0, -1), false, nil)
	Events:AdjustBossPower(necromancer, 2, 2, false)
	local particleName = "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap.vpcf"
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(7144, 12480, 170), false, nil, nil, DOTA_TEAM_NEUTRALS)
	visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_RENDERORIGIN_FOLLOW, visionTracer)
	ParticleManager:SetParticleControl(particle1, 0, Vector(7144, 12480, 170))
	necromancer.visionTracer = visionTracer
	table.insert(Dungeons.ruinsEntityTable, visionTracer)

	Dungeons:SpawnDungeonUnit("grave_watcher", Vector(9618, 14656), 1, 2, 3, "dazzle_dazz_anger_04", Vector(0, -1), false, nil)
	Dungeons:SpawnDungeonUnit("grave_watcher", Vector(10432, 14976), 1, 2, 3, "dazzle_dazz_anger_04", Vector(0, -1), false, nil)
	Dungeons:SpawnDungeonUnit("grave_watcher", Vector(10048, 15808), 1, 2, 3, "dazzle_dazz_anger_04", Vector(0, -1), false, nil)

	--TEMPLE--
	local stoneVectorTable = {Vector(5821.14, 15858.9), Vector(5888, 15859), Vector(5821, 15732), Vector(5888, 15732), Vector(5957, 15732), Vector(5821, 15607), Vector(5888, 15607), Vector(5957, 15607)}
	Dungeons.stoneEntTable = {}
	for i = 1, #stoneVectorTable, 1 do
		local stone = CreateUnitByName("npc_dummy_unit", stoneVectorTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
		stone.roomIndex = i
		stone:SetOriginalModel("models/props_stone/stoneblock008a.vmdl")
		stone:SetModel("models/props_stone/stoneblock008a.vmdl")
		stone:SetModelScale(0.5)
		stone:SetForwardVector(Vector(1, 0))
		stone:SetAbsOrigin(stoneVectorTable[i] + Vector(0, 0, 950))
		stone:FindAbilityByName("dummy_unit"):SetLevel(1)
		table.insert(Dungeons.stoneEntTable, stone)
	end
	local templeThinker = Dungeons:CreateDungeonThinker(Vector(6208, 15744), "ruins_entrance", 390, "desert_ruins")
	templeThinker:AddAbility("temple_activator_ability"):SetLevel(1)
	Timers:CreateTimer(30, function()
		Dungeons:SpawnDungeonUnit("ruins_blood_arcanist", Vector(6741, 9703), 1, 2, 3, "keeper_of_the_light_keep_incant_02", Vector(-1, 1), false, nil)
	end)
end

function Dungeons:RuinsButtonPress(msg)
	local buttonNumber = msg.buttonNumber
	if not Dungeons.ruinsRoomEnabled then
		Dungeons:CreateOrUpdateRuinsPortal(buttonNumber)
		for i = 1, #Dungeons.stoneEntTable, 1 do
			if buttonNumber == i then
				Dungeons.stoneEntTable[i]:SetRenderColor(255, 0, 0)
				Dungeons.highlightedStone = i
			else
				Dungeons.stoneEntTable[i]:SetRenderColor(255, 255, 255)
			end
		end
		CustomGameEventManager:Send_ServerToAllClients("update_console", {stoneIndex = Dungeons.highlightedStone})
		Dungeons:CreateOrUpdateRuinsPortal(buttonNumber)
	end
end

function Dungeons:CreateOrUpdateRuinsPortal(roomNumber)
	local roomVectorTable = {Vector(3840, 15104), Vector(4973, 15104), Vector(3712, 12864), Vector(5138, 13582), Vector(5958, 13433), Vector(3776, 10624), Vector(5047, 10729), Vector(5944, 10567)}
	if not Dungeons.templePortal then
		Dungeons:InitializeRuins()
		Dungeons.templePortal = CreateUnitByName("beacon", Vector(6606.92, 15812.6), true, nil, nil, DOTA_TEAM_GOODGUYS)
		Dungeons.templePortal.active = active
		Dungeons.templePortal:NoHealthBar()
		Dungeons.templePortal:AddAbility("town_portal")
		Dungeons.templePortal:FindAbilityByName("town_portal"):SetLevel(1)
		Dungeons.templePortal.teleportLocation = roomVectorTable[roomNumber]
		Dungeons.templePortal.dungeonSpecial = true
		-- Beacons:CreateParticle(particleName, portal:GetAbsOrigin()+Vector(0,0,10), portal, 0)
		Beacons:ActivatePortal(Dungeons.templePortal, "particles/portals/green_portal.vpcf", Vector(0.68, 0.68, 0.4))
	else
		Dungeons.templePortal.teleportLocation = roomVectorTable[roomNumber]
	end

end

function Dungeons:SpecialPortal(unit)
	if Dungeons.templeRoomsClearedTable[Dungeons.highlightedStone] == 0 then
		Dungeons.ruinsRoomEnabled = true
		unit.ruinsPorted = true
		Dungeons.entryPoint = Dungeons.templePortal.teleportLocation
		Timers:CreateTimer(3, function()
			CustomGameEventManager:Send_ServerToAllClients("big_text", {message = "#ruins_room"..Dungeons.highlightedStone})
			if Dungeons.highlightedStone == 1 then
				Dungeons:RuinsSolarium(true)
			elseif Dungeons.highlightedStone == 2 then
				Dungeons:RuinsThroneRoom(true)
			elseif Dungeons.highlightedStone == 3 then
				Dungeons:RuinsFungalLab(true)
			elseif Dungeons.highlightedStone == 4 then
				Dungeons:RuinsChamberOfSuffering(true)
			elseif Dungeons.highlightedStone == 5 then
				Dungeons:RuinsGardenOfBlight(true)
			elseif Dungeons.highlightedStone == 6 then
				Dungeons:RuinsMausoleum(true)
			elseif Dungeons.highlightedStone == 7 then
				Dungeons:RuinsSandPit(true)
			elseif Dungeons.highlightedStone == 8 then
				Dungeons:RuinsWellOfSacrifice(true)
			end
		end)
		for i = 1, #MAIN_HERO_TABLE, 1 do
			if not MAIN_HERO_TABLE[i].ruinsPorted then
				Events:TeleportUnit(MAIN_HERO_TABLE[i], Dungeons.templePortal.teleportLocation, Dungeons.templePortal:FindAbilityByName("town_portal"), Dungeons.templePortal, 1.5)
				MAIN_HERO_TABLE[i].ruinsPorted = true
			end
		end
	end
end

function Dungeons:ruinsBossSpecial(unit)
	unit.ruinsPorted = true
	Dungeons.entryPoint = Vector(1344, 14016)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if not MAIN_HERO_TABLE[i].ruinsPorted then
			Events:TeleportUnit(MAIN_HERO_TABLE[i], Vector(1344, 14016), Dungeons.templePortal:FindAbilityByName("town_portal"), Dungeons.templePortal, 1.5)
			MAIN_HERO_TABLE[i].ruinsPorted = true
		end
	end
	-- Timers:CreateTimer(5, function()
	-- Dungeons:SpawnRuinsBoss()
	-- end)
end

function Dungeons:RuinsSolarium(isStart)
	local minX = 3456
	local maxX = 4192
	local minY = 14352
	local maxY = 15700
	if isStart then
		Dungeons.ruinsKills = 0
		Dungeons.ruinsKillsThreshold = 40
		for j = 1, 4, 1 do
			for i = 1, 10, 1 do
				Timers:CreateTimer(i * 2.5, function()
					local spawnPoint = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
					Dungeons:SpawnDungeonUnit("ruins_solarium_void", spawnPoint, 1, 0, 1, nil, RandomVector(1), true, nil)
				end)
			end
			Timers:CreateTimer(j * 5, function()
				local spawnPoint = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
				Dungeons:SpawnDungeonUnit("ruins_solarium_enigma", spawnPoint, 1, 1, 3, "Hero_Enigma.Demonic_Conversion", RandomVector(1), true, nil)
			end)
		end
	else
		Dungeons.ruinsRoomEnabled = false
		createRoomExitPortal(Vector(maxX, maxY))
		Dungeons.templeRoomsClearedTable[1] = 1
	end
end

function Dungeons:RuinsThroneRoom(isStart)
	if isStart then
		Dungeons.ruinsKills = 0
		Dungeons.ruinsKillsThreshold = 1
		local rozan = Dungeons:SpawnDungeonUnit("ruins_king_rozan", Vector(4992, 15872), 1, 3, 5, nil, Vector(0, -1), true, nil)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, rozan:GetAbsOrigin(), 400, 300, false)
		local rozanAbil = rozan:FindAbilityByName("ruins_king_rozan_ai")
		rozanAbil:ApplyDataDrivenModifier(rozan, rozan, "modifier_rozan_intro", {duration = 3})
		Events:AdjustBossPower(rozan, 3, 4, false)
		Timers:CreateTimer(3.05, function()
			rozan.jumpEnd = "hermit"
			WallPhysics:Jump(rozan, Vector(0, -1), 50, 25, 2, 1)
		end)
	else
		Dungeons.ruinsRoomEnabled = false
		createRoomExitPortal(Vector(4992, 14400))
		Dungeons.templeRoomsClearedTable[2] = 1
	end
end

function Dungeons:RuinsFungalLab(isStart)
	local minX = 3456
	local maxX = 4192
	local minY = 12659
	local maxY = 13500
	if isStart then
		Dungeons.ruinsKills = 0
		Dungeons.ruinsKillsThreshold = 40
		for j = 1, 4, 1 do
			for i = 1, 10, 1 do
				Timers:CreateTimer(i * 2.5, function()
					local spawnPoint = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
					local fungus = Dungeons:SpawnDungeonUnit("fungal_minion", spawnPoint, 1, 0, 1, nil, RandomVector(1), true, nil)
					local luck = RandomInt(1, 2)
					if luck == 2 then
						fungus:SetOriginalModel("models/items/furion/treant/fungal_lord_shroomthing/fungal_lord_shroomthing.vmdl")
						fungus:SetModel("models/items/furion/treant/fungal_lord_shroomthing/fungal_lord_shroomthing.vmdl")
					end
					fungus:SetAbsOrigin(fungus:GetAbsOrigin() - Vector(0, 0, 200))
					fungus:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
					Timers:CreateTimer(0.03, function()
						StartAnimation(fungus, {duration = 0.7, activity = ACT_DOTA_SPAWN, rate = 1})
					end)
					for k = 1, 15, 1 do
						Timers:CreateTimer(k * 0.03, function()
							fungus:SetAbsOrigin(fungus:GetAbsOrigin() + Vector(0, 0, 13))
						end)
					end
					Timers:CreateTimer(0.6, function()
						fungus:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
					end)
				end)
			end
			Timers:CreateTimer(j * 5, function()
				local spawnPoint = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
				Dungeons:SpawnDungeonUnit("fungal_overlord", spawnPoint, 1, 1, 3, "Hero_Treant.LeechSeed.Cast", RandomVector(1), true, nil)
			end)
		end
	else
		Dungeons.ruinsRoomEnabled = false
		createRoomExitPortal(Vector(maxX, maxY))
		Dungeons.templeRoomsClearedTable[3] = 1
	end
end

function Dungeons:RuinsChamberOfSuffering(isStart)
	local spawnTable = {Vector(5120, 12480), Vector(5374, 13113), Vector(4842, 13114), Vector(5090, 13680)}
	if isStart then
		Dungeons.ruinsKills = 0
		Dungeons.ruinsKillsThreshold = 32
		for j = 1, 4, 1 do
			for i = 1, 8, 1 do
				Timers:CreateTimer(i * 2.0, function()
					Dungeons:SpawnDungeonUnit("executioner", spawnTable[RandomInt(1, 4)], 1, 0, 1, nil, RandomVector(1), true, "raider")
				end)
			end
			Timers:CreateTimer(j * 4, function()
				local pudge = Dungeons:SpawnDungeonUnit("chained_butcher", spawnTable[RandomInt(1, 4)], 1, 1, 3, "pudge_pud_anger_04", RandomVector(1), false, nil)
				pudge:AddAbility("desert_ruins_ability"):SetLevel(1)
			end)
		end
	else
		Dungeons.ruinsRoomEnabled = false
		createRoomExitPortal(spawnTable[4])
		Dungeons.templeRoomsClearedTable[4] = 1
	end
end

function Dungeons:RuinsGardenOfBlight(isStart)
	local minX = 5888
	local maxX = 6650
	local minY = 12495
	local maxY = 13888
	if isStart then
		Dungeons.ruinsKills = 0
		Dungeons.ruinsKillsThreshold = 15
		for j = 1, 2, 1 do
			for i = 1, 8, 1 do
				Timers:CreateTimer(i * 2.5, function()
					local spawnPoint = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
					Dungeons:SpawnDungeonUnit("blighted_sapling", spawnPoint, 1, 1, 1, nil, RandomVector(1), true, nil)
				end)
			end
		end
	else
		Dungeons.ruinsRoomEnabled = false
		createRoomExitPortal(Vector(maxX, maxY))
		Dungeons.templeRoomsClearedTable[5] = 1
	end
end

function Dungeons:RuinsMausoleum(isStart)
	if isStart then
		Dungeons.ruinsKills = 0
		Dungeons.ruinsKillsThreshold = 4
		for j = 1, 4, 1 do
			local spawnPoint = Vector(3500 + 130 * j, 11840)
			local skull = Dungeons:SpawnDungeonUnit("ruins_golden_skullbone", spawnPoint, 1, 2, 2, nil, Vector(0, -1), true, nil)
			Events:AdjustBossPower(skull, 2, 1, false)
		end
	else
		Dungeons.ruinsRoomEnabled = false
		createRoomExitPortal(Vector(4096, 11840))
		Dungeons.templeRoomsClearedTable[6] = 1
	end
end

function Dungeons:RuinsSandPit(isStart)
	if isStart then
		Dungeons.ruinsKills = 0
		Dungeons.ruinsKillsThreshold = 6
		local vectorTable = {Vector(5201, 11027), Vector(4911, 11344), Vector(5219, 11390), Vector(5478, 11266), Vector(5104, 11590), Vector(4660, 11590), Vector(4525, 11402), Vector(4587, 11719), Vector(4766, 11856), Vector(4992, 11856), Vector(5156, 11908), Vector(5433, 11941), Vector(4763, 11990), Vector(4763, 10987), Vector(4763, 10764), Vector(4989, 10663), Vector(4990, 10469), Vector(5192, 10469), Vector(5340, 10469), Vector(5378, 10628)}
		for j = 1, 6, 1 do
			Timers:CreateTimer(j * 0.3, function()
				local spawnPoint = vectorTable[RandomInt(1, #vectorTable)]
				local burrower = Dungeons:SpawnDungeonUnit("ruins_venomous_burrower", spawnPoint, 1, 2, 2, nil, RandomVector(1), true, nil)
				Events:AdjustBossPower(burrower, 1, 1, false)
			end)
		end
	else
		Dungeons.ruinsRoomEnabled = false
		createRoomExitPortal(Vector(4608, 11904))
		Dungeons.templeRoomsClearedTable[7] = 1
	end
end

function Dungeons:RuinsWellOfSacrifice(isStart)
	if isStart then
		Dungeons.ruinsKills = 0
		Dungeons.ruinsKillsThreshold = 1

		local vectorTable = {Vector(5828, 10619), Vector(5828, 10844), Vector(5828, 11207), Vector(5828, 11517), Vector(5829, 11834), Vector(6072, 11833), Vector(6320, 11834), Vector(6584, 11834), Vector(6700, 11580), Vector(6700, 11331), Vector(6700, 11044), Vector(6700, 10687), Vector(6481, 10639)}
		local warlock = Dungeons:SpawnDungeonUnit("well_of_sacrifice_ghost", Vector(6272, 11200), 1, 3, 5, nil, Vector(0, -1), true, nil)
		local warlockAbil = warlock:FindAbilityByName("well_of_sacrifice_ghost_ai")
		warlockAbil:ApplyDataDrivenModifier(warlock, warlock, "modifier_well_of_sacrifice_ghost_intro", {duration = 15})
		Timers:CreateTimer(0.3, function()
			EmitSoundOn("warlock_warl_laugh_03", warlock)
		end)
		for i = 1, 40, 1 do
			Timers:CreateTimer(i * 0.05, function()
				warlock:SetAbsOrigin(warlock:GetAbsOrigin() + Vector(0, 0, 14))
			end)
		end
		Timers:CreateTimer(5, function()
			EmitSoundOn("warlock_warl_laugh_03", warlock)
		end)
		for j = 1, #vectorTable, 1 do
			Timers:CreateTimer(j * 1.2, function()
				StartAnimation(warlock, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.1})
				local summon = Dungeons:SpawnDungeonUnit("enslaved_corpse", vectorTable[j], 1, 1, 1, "life_stealer_lifest_anger_04", Vector(0, -1), true, nil)
				local visionTracer = CreateUnitByName("npc_flying_dummy_vision", summon:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)

				local particleName = "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_RENDERORIGIN_FOLLOW, visionTracer)
				ParticleManager:SetParticleControl(particle1, 0, summon:GetAbsOrigin())

				local particleName = "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap.vpcf"

				EmitSoundOn("Hero_TemplarAssassin.Trap", visionTracer)
				visionTracer:AddAbility("dummy_unit"):SetLevel(1)
				local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_RENDERORIGIN_FOLLOW, visionTracer)
				ParticleManager:SetParticleControl(particle2, 0, summon:GetAbsOrigin())

				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				Timers:CreateTimer(10, function()
					ParticleManager:DestroyParticle(particle2, false)
					UTIL_Remove(visionTracer)
				end)
			end)
		end
		Timers:CreateTimer(#vectorTable * 1.2, function()
			WallPhysics:Jump(warlock, Vector(0, -1), 20, 25, 1.5, 1)
			Timers:CreateTimer(0.5, function()
				EmitSoundOn("warlock_warl_laugh_03", warlock)
				warlock:RemoveModifierByName("modifier_well_of_sacrifice_ghost_intro")
			end)
		end)
	else
		Dungeons.ruinsRoomEnabled = false
		Dungeons.templeRoomsClearedTable[8] = 1
		createRoomExitPortal(Vector(5888, 11840))
	end
end

function createRoomExitPortal(position)
	local portal = CreateUnitByName("beacon", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 300, 300, false)
	portal.active = active
	portal :NoHealthBar()
	portal :AddAbility("town_portal")
	portal :FindAbilityByName("town_portal"):SetLevel(1)
	portal.teleportLocation = Vector(6272, 15104)
	-- Beacons:CreateParticle(particleName, portal:GetAbsOrigin()+Vector(0,0,10), portal, 0)
	Beacons:ActivatePortal(portal, "particles/portals/green_portal.vpcf", Vector(0.68, 0.68, 0.4))
	if Dungeons.ruinsEntityTable then
		table.insert(Dungeons.ruinsEntityTable, portal)
	end
	Dungeons.entryPoint = Vector(6272, 15104)
	EmitGlobalSound("ui.set_applied")
	EmitGlobalSound("ui.set_applied")
	local spawnRubyGiant = true
	for i = 1, #Dungeons.templeRoomsClearedTable, 1 do
		if Dungeons.templeRoomsClearedTable[i] == 0 then
			spawnRubyGiant = false
		end
	end
	if spawnRubyGiant then
		local giant = Dungeons:SpawnDungeonUnit("ancient_ruby_giant", Vector(6272, 15104), 1, 4, 8, nil, Vector(-1, 1), false, nil)
		Events:AdjustBossPower(giant, 2, 7, false)
	end
end

function Dungeons:InitializeRuins()
	Dungeons.roomKey1 = RandomInt(1, 8)
	Dungeons.roomKey2 = RandomInt(1, 8)
	while Dungeons.roomKey1 == Dungeons.roomKey2 do
		Dungeons.roomKey2 = RandomInt(1, 8)
	end
	----print("ROOM KEYS:")
	----print(Dungeons.roomKey1)
	----print(Dungeons.roomKey2)
	Dungeons.templeRoomsClearedTable = {0, 0, 0, 0, 0, 0, 0, 0}
end

function Dungeons:DebugRuins()
	-- Dungeons:SpawnDungeonUnit("ruins_blood_arcanist", Vector(6741, 9703), 1, 2, 3, "keeper_of_the_light_keep_incant_02", Vector(-1, 1), false, nil)

	-- local stoneVectorTable = {Vector(5821.14, 15858.9), Vector(5888, 15859), Vector(5821, 15732), Vector(5888, 15732), Vector(5957, 15732), Vector(5821, 15607), Vector(5888, 15607), Vector(5957, 15607)}
	-- Dungeons.stoneEntTable = {}
	-- for i = 1, #stoneVectorTable, 1 do
	-- local stone = CreateUnitByName("npc_dummy_unit", stoneVectorTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
	-- stone.roomIndex = i
	-- stone:SetOriginalModel("models/props_stone/stoneblock008a.vmdl")
	-- stone:SetModel("models/props_stone/stoneblock008a.vmdl")
	-- stone:SetModelScale(0.5)
	-- stone:SetForwardVector(Vector(1,0))
	-- stone:SetAbsOrigin(stoneVectorTable[i]+Vector(0,0,950))
	-- stone:FindAbilityByName("dummy_unit"):SetLevel(1)
	-- table.insert(Dungeons.stoneEntTable, stone)
	-- end
	-- local templeThinker = Dungeons:CreateDungeonThinker(Vector(6208, 15744), "ruins_entrance", 390, "desert_ruins")
	-- templeThinker:AddAbility("temple_activator_ability"):SetLevel(1)

	--FUNCTION SPAWN BOSS :D

	Dungeons:SpawnDungeonUnit("ancient_ruby_giant", Vector(6272, 15104), 1, 4, 8, nil, Vector(-1, 1), false, nil)
end

function Dungeons:SpawnRuinsBoss()

	Dungeons.bossSpawned = true
	local fourInnerPointsTable = {Vector(960, 13568), Vector(960, 14527), Vector(1810, 14527), Vector(1810, 13658)}
	local boss = Events:SpawnBoss("ruins_boss", fourInnerPointsTable[RandomInt(1, 4)])
	boss:SetAbsOrigin(boss:GetAbsOrigin() + Vector(0, 0, 1200))
	Events:AdjustBossPower(boss, 4, 4, true)
	EmitGlobalSound("DOTA_Item.DoE.Activate")
	boss.jumpEnd = "hermit"
	WallPhysics:Jump(boss, Vector(0, 0), 0, 30, 1, 0.7)
	Timers:CreateTimer(0.2, function()
		EmitGlobalSound("huskar_husk_level_09")
		EmitGlobalSound("huskar_husk_level_09")
	end)
	local bossAbil = boss:FindAbilityByName("ruins_boss_ai")
	bossAbil:ApplyDataDrivenModifier(boss, boss, "modifier_ruins_boss_intro", {duration = 3})
	Timers:CreateTimer(2.7, function()
		StartAnimation(boss, {duration = 0.8, activity = ACT_DOTA_TELEPORT, rate = 1.5})
	end)
	Timers:CreateTimer(3.6, function()
		EmitGlobalSound("huskar_husk_level_05")
		EmitGlobalSound("huskar_husk_level_05")
		EmitGlobalSound("huskar_husk_level_05")
	end)

end

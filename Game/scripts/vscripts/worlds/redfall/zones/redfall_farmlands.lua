function Redfall:SpawnFarmlandsPt1()
	if not Redfall.Farmlands then
		Redfall.Farmlands = {}
	end
	Redfall:FarmlandsMusic()
	Redfall:SpawnFarmlandsBandit(Vector(12864, -15254), Vector(0,1))
	Redfall:SpawnFarmlandsBandit(Vector(13187, -15134), Vector(-1,1))

	Redfall:SpawnFarmlandSpawner(Vector(11840, -14720), Vector(1,0), Vector(11910, -14720))
	Redfall:SpawnFarmlandSpawner(Vector(12239, -13413), Vector(0,-1), Vector(12239, -13513))

	Redfall:SpawnFarmlandThief(Vector(13632, -13056), Vector(1,0.5))
	Redfall:SpawnFarmlandThief(Vector(13632, -13440), Vector(1,-1))
	Redfall:SpawnFarmlandThief(Vector(13248, -13376), Vector(-1,-0.7))

	Redfall:SpawnGhostPandaFlame(Vector(11279, -13997, 220))
	Redfall:SpawnGhostPandaFlame(Vector(14912, -14144, 220))
	Redfall:SpawnGhostPandaFlame(Vector(12608, -14400, 220))
	Redfall:SpawnGhostPandaFlame(Vector(14699, -13733, 384))

	Timers:CreateTimer(3, function()
		local patrolPositionTable = {Vector(13120, -14144), Vector(10624, -12480)}
		local bandit = Redfall:SpawnFarmlandsBandit(Vector(10624, -12480), RandomVector(1))
		Redfall:AddPatrolArguments(bandit, 40, 6, 200, patrolPositionTable)
		local bandit = Redfall:SpawnFarmlandsBandit(Vector(10624, -12480)+RandomVector(240), RandomVector(1))
		Redfall:AddPatrolArguments(bandit, 40, 6, 200, patrolPositionTable)

		Redfall:SpawnGhostPandaFlame(Vector(9344, -14528, 220))
	end)
	Timers:CreateTimer(1, function()
		Redfall:InitiateAnimalPlates()
	end)
end

function Redfall:SpawnFarmlandsBandit(position, fv)
	local ancient = Redfall:SpawnDungeonUnit( "redfall_farmlands_bandit", position, 1, 4, "Redfall.FarmlandsBandit.Aggro", fv, false)
	ancient.itemLevel = 50
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.dominion = true
	return ancient
end

function Redfall:SpawnFarmlandSpawnerUnit(position, fv, itemRoll, bAggro)
	local stone = Redfall:SpawnDungeonUnit("redfall_pumpkin_flower", position, itemRoll, itemRoll, "Redfall.Pumpkin.Aggro", fv, bAggro)
	stone:SetRenderColor(233,160,160)
	stone.itemLevel = 38
	stone.dominion = true
	return stone
end

function Redfall:SpawnFarmlandSpawner(position, fv, summonCenter)
	local stone = Redfall:SpawnDungeonUnit( "redfall_farmland_spawner", position, 2, 4, nil, fv, false)
	stone:SetRenderColor(234,171,171)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 60
	stone.summonCenter = summonCenter

	return stone
end

function Redfall:SpawnFarmlandThief(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "redfall_farmlands_thief", position, 1, 2, "Redfall.PumpkinThief.Aggro", fv, false)
	stone:SetRenderColor(234,171,171)
	Redfall:ColorWearables(stone, Vector(255, 110, 110))
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 52
	stone.dominion = true
	return stone
end

function Redfall:SpawnHarvestWraith(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "redfall_harvest_wraith", position, 1, 3, "Redfall.HarvestWraith.Aggro", fv, false)
	stone:SetRenderColor(255,140,140)
	Redfall:ColorWearables(stone, Vector(255,140,140))
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 62
	stone.dominion = true
	return stone
end

function Redfall:FarmlandsCornTrigger1()
	local positionTable = {Vector(12096, -11264), Vector(12160, -12288), Vector(12426, -11776), Vector(12672, -12032), Vector(12928, -11264), Vector(13184, -12288), Vector(13376, -11776), Vector(13696, -12352), Vector(13696, -11136)}
	for i = 1, #positionTable, 1 do
		local patrolPositionTable = {}
		for j = 1, #positionTable, 1 do
			local index = i + j
			if index > #positionTable then
				index = index - #positionTable
			end
			table.insert(patrolPositionTable, positionTable[index])
		end
		local wraith = Redfall:SpawnHarvestWraith(positionTable[i], RandomVector(1))
		Redfall:AddPatrolArguments(wraith, 70, 4, 30, patrolPositionTable)
	end
	Redfall:SpawnFarmlandSpawner(Vector(13184, -11520), Vector(0,-1), Vector(13184, -11520))
end

function Redfall:SpawnGhostPandaFlame(position)
	local particleName = "particles/dire_fx/fire_ambience.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,Vector(position.x, position.y, Redfall.ZFLOAT+position.z))
    local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    dummy:AddAbility("redfall_farm_flame_thinker_unit"):SetLevel(1)
    dummy.pfx = pfx
end

function Redfall:SpawnFlamePanda(position, fv, bJumpEffect)
	local stone = Redfall:SpawnDungeonUnit( "redfall_farmlands_flame_panda", position, 0, 2, nil, fv, true)
	if bJumpEffect then
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, stone, "modifier_redfall_monster_entering", {duration = 1.0})
		stone:SetModelScale(0.01)
		for i = 1, 50, 1 do
			Timers:CreateTimer(i*0.03, function()
				stone:SetModelScale(i*0.02)
			end)
		end
		CustomAbilities:QuickAttachParticle("particles/econ/items/invoker/glorious_inspiration/invoker_forge_spirit_spawn_fire.vpcf", stone, 3)
		stone:SetAbsOrigin(position)
		WallPhysics:Jump(stone, fv, 15, 25, 12, 1)
	end
	stone.itemLevel = 54
	stone.dominion = true
	return stone
end

function Redfall:FarmlandsCornTrigger2()
	local positionTable = {Vector(8128, -12736), Vector(8640, -12224), Vector(9152, -12992), Vector(8128, -11712)}
	for i = 1, #positionTable, 1 do
		local patrolPositionTable = {}
		for j = 1, #positionTable, 1 do
			local index = i + j
			if index > #positionTable then
				index = index - #positionTable
			end
			table.insert(patrolPositionTable, positionTable[index])
		end
		local wraith = Redfall:SpawnHarvestWraith(positionTable[i], RandomVector(1))
		Redfall:AddPatrolArguments(wraith, 70, 4, 30, patrolPositionTable)
	end
	Redfall:SpawnFarmlandSpawner(Vector(8894, -11954), Vector(-1,0), Vector(8894, -11954))
	local harvesterTable = {Vector(7680, -12928), Vector(9408, -12736), Vector(8320, -11968), Vector(8576, -11072)}
	for i = 1, #harvesterTable, 1 do
		Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
	end
end

function Redfall:SpawnRedfallHarvester(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "redfall_farmlands_corn_harvester", position, 1, 3, "Redfall.Harvester.Aggro", fv, false)
	stone:SetRenderColor(255,140,140)
	Redfall:ColorWearables(stone, Vector(255,140,140))
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 63
	stone.dominion = true
	return stone
end

function Redfall:BigFarmTrigger1()
	local vectorTable = {Vector(9859, -11986), Vector(9945, -11770), Vector(9852, -11759), Vector(9788, -11665), Vector(9720, -12113), Vector(9899, -12245), Vector(9994, -12180), Vector(10105, -12241)}
	for i = 1, #vectorTable, 1 do
		Timers:CreateTimer(0.2*i, function()
			Redfall:SpawnTwistedPumpkin(vectorTable[i])
		end)
	end

	local vectorTable = {Vector(12076, -13252), Vector(12270, -13117), Vector(12392, -13267), Vector(12497, -13111), Vector(12591, -13045), Vector(12004, -12930)}
	for i = 1, #vectorTable, 1 do
		Timers:CreateTimer(0.2*i, function()
			Redfall:SpawnTwistedPumpkin(vectorTable[i])
		end)
	end
	local patrolPositionTable = {Vector(9662, -13658), Vector(7488, -13952)}
	local bandit = Redfall:SpawnFarmlandsBandit(Vector(7424, -13824), Vector(1,0))
	Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
	local thief = Redfall:SpawnFarmlandThief(Vector(7488, -13952), Vector(1,0))
	Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
	local thief = Redfall:SpawnFarmlandThief(Vector(7360, -14080), Vector(1,0))
	Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)

	Redfall:SpawnGhostPandaFlame(Vector(10112, -11328, 220))

	Timers:CreateTimer(2.2, function()
		local patrolPositionTable = {Vector(10624, -12480), Vector(9856, -10048)}
		local bandit = Redfall:SpawnFarmlandThief(Vector(9816, -10148), Vector(1,0))
		Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandThief(Vector(9956, -9888), Vector(1,0))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandThief(Vector(9856, -10048), Vector(1,0))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
	end)
end

function Redfall:SpawnTwistedPumpkin(position)
	local shroom = Redfall:SpawnDungeonUnit("redfall_twisted_pumpkin", position, 1, 0, nil, RandomVector(1), false)
	shroom.itemLevel = 42
	shroom:SetAbsOrigin(shroom:GetAbsOrigin()-Vector(0,0,210))
	if shroom.paragon then
		shroom:SetAbsOrigin(shroom:GetAbsOrigin()-Vector(0,0,130))
	end
	shroom.dominion = true
	local ability = shroom:FindAbilityByName("redfall_pumpkin_ai")
	ability:ApplyDataDrivenModifier(shroom, shroom, "modifier_pumpkin_ai", {})	
	return shroom
end

function Redfall:BottomFarmlandTrigger()
	Redfall:SpawnFarmlandSpawner(Vector(10560, -14336), Vector(0,-1), Vector(10560, -14336))
	Redfall:SpawnFarmlandSpawner(Vector(10976, -14735), Vector(0,1), Vector(10976, -14735))
	local positionTable = {Vector(10176, -14720), Vector(10560, -15104), Vector(10880, -14720), Vector(10560, -14336)}
	for i = 1, #positionTable, 1 do
		local patrolPositionTable = {}
		for j = 1, #positionTable, 1 do
			local index = i + j
			if index > #positionTable then
				index = index - #positionTable
			end
			table.insert(patrolPositionTable, positionTable[index])
		end
		local wraith = Redfall:SpawnHarvestWraith(positionTable[i], RandomVector(1))
		Redfall:AddPatrolArguments(wraith, 60, 2, 30, patrolPositionTable)
	end
	Redfall:SpawnFarmlandsBandit(Vector(10560, -15256), Vector(0,-1))
	Redfall:SpawnFarmlandsBandit(Vector(10880, -15280), Vector(0,-1))
	Redfall:SpawnFarmlandsBandit(Vector(11173, -15256), Vector(0,-1))
end

function Redfall:BottomFarmland2()
	local harvesterTable = {Vector(8698, -14464), Vector(8199, -14672)}
	for i = 1, #harvesterTable, 1 do
		Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
	end
	
	local bear = Redfall:SpawnChibiBear(Vector(7488, -15296), Vector(-1,-1))
	local patrolPositionTable = {Vector(7488, -15296), Vector(7488, -15296)+Vector(90, 90)}
	Redfall:AddPatrolArguments(bear, 60, 5, 30, patrolPositionTable)
	bear = Redfall:SpawnChibiBear(Vector(8064, -15040), Vector(0,-1))
	patrolPositionTable = {Vector(8064, -15040), Vector(8064, -15040)+Vector(140, 50)}
	Redfall:AddPatrolArguments(bear, 60, 5, 30, patrolPositionTable)
end

function Redfall:SpawnChibiBear(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "redfall_chibi_bear", position, 1, 3, "Redfall.ChibiBear.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 6, false)
	stone.itemLevel = 58
	stone.dominion = true
	return stone
	
end

function Redfall:BottomFarmland3()
	local bear = Redfall:SpawnChibiBear(Vector(5312, -14784), Vector(-1,-1))
	local patrolPositionTable = {Vector(5312, -14784), Vector(5312, -14784)+Vector(-90, 90)}
	Redfall:AddPatrolArguments(bear, 60, 5, 30, patrolPositionTable)

	Redfall:SpawnFarmlandSpawner(Vector(5376, -14144), Vector(0,-1), Vector(5376, -14144))
	Redfall:SpawnFarmlandSpawner(Vector(5760, -14144), Vector(0,-1), Vector(5760, -14144))
	Redfall:SpawnFarmlandSpawner(Vector(6144, -14144), Vector(0,-1), Vector(6144, -14144))

	Redfall:SpawnGhostPandaFlame(Vector(5740, -13967, 220))

	local harvesterTable = {Vector(5248, -13504), Vector(5760, -12992), Vector(6528, -12672)}
	for i = 1, #harvesterTable, 1 do
		Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
	end

	local positionTable = {Vector(5504, -12928), Vector(6016, -13184), Vector(6528, -13440)}
	for i = 1, #positionTable, 1 do
		local patrolPositionTable = {}
		for j = 1, #positionTable, 1 do
			local index = i + j
			if index > #positionTable then
				index = index - #positionTable
			end
			table.insert(patrolPositionTable, positionTable[index])
		end
		local wraith = Redfall:SpawnHarvestWraith(positionTable[i], RandomVector(1))
		Redfall:AddPatrolArguments(wraith, 70, 4, 30, patrolPositionTable)
	end

	Redfall:SpawnGhostPandaFlame(Vector(6848, -12416, 220))

	Timers:CreateTimer(1, function()
		local vectorTable = {Vector(4644, -12500), Vector(4739, -12435), Vector(4605, -12241), Vector(4850, -12495)}
		for i = 1, #vectorTable, 1 do
			Timers:CreateTimer(0.2*i, function()
				Redfall:SpawnTwistedPumpkin(vectorTable[i])
			end)
		end
		Redfall:SpawnCrimsythDuelist(Vector(4586, -13440), Vector(-1,0))
	end)

	if not Redfall.Farmlands then
		Redfall.Farmlands = {}
	end
	Redfall.Farmlands.farmNPCa = Redfall:SpawnTownNPC(Vector(5312, -11392), "redfall_old_farmer", Vector(1, -1), nil, nil, nil, 1.1, true, "redfall_farmer1")
end

function Redfall:SpawnCrimsythDuelist(position, fv)
	local ancient = Redfall:SpawnDungeonUnit( "redfall_crymsith_duelist", position, 2, 5, "Redfall.Duelist.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 4, 4, false)
	ancient.itemLevel = 68

	-- Redfall:ColorWearables(ancient, Vector(255, 150, 150))
	-- ancient:SetRenderColor(255, 150, 150)
	ancient.targetRadius = 1000
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	ancient.targetFindOrder = FIND_ANY_ORDER

	ancient.dominion = true
	return ancient
end

function Redfall:EndFarmerSceneA()
	Quests:ShowDialogueText(MAIN_HERO_TABLE, Redfall.Farmlands.farmNPCa, "redfall_dialogue_farmer_1_f", 5, false)
	print("TALK!!")
	Timers:CreateTimer(5, function()

		Redfall:IncrementFarmlandsQuest()

		Quests:ShowDialogueText(MAIN_HERO_TABLE, Redfall.Farmlands.farmNPCa, "redfall_dialogue_farmer_1_g", 5, false)
		print("TALK AGAIN!!")
		Redfall.Farmlands.farmNPCa:MoveToPosition(Vector(4918, -11392))
		Timers:CreateTimer(8, function()
			Redfall.Farmlands.farmNPCa:MoveToPosition(Redfall.Farmlands.farmNPCa:GetAbsOrigin()+Vector(40, 0, 0))
			Redfall.Farmlands.farmNPCa.dialogueName = "farmer1a"
			print("CHANGE DIALOGUE STYLE")
		end)
	end)
end

function Redfall:FarmlandsWestTrigger1()
	local vectorTable = {Vector(4144, -11396), Vector(3965, -11263), Vector(3975, -11171), Vector(3733, -11162), Vector(3796, -11039), Vector(3866, -10774), Vector(3596, -10853), Vector(3608, -10664), Vector(3658, -10561), Vector(3358, -10522)}
	for i = 1, #vectorTable, 1 do
		Timers:CreateTimer(0.2*i, function()
			Redfall:SpawnTwistedPumpkin(vectorTable[i])
		end)
	end
	Redfall:SpawnCrimsythDuelist(Vector(3968, -9536), Vector(1,0))

	Redfall:SpawnFarmlandsBandit(Vector(3904, -9792), Vector(1,0))
	Redfall:SpawnFarmlandsBandit(Vector(3904, -9280), Vector(1,0))

	Redfall:SpawnFarmlandThief(Vector(3808, -9935), Vector(1,0))
	Redfall:SpawnFarmlandThief(Vector(3584, -10048), Vector(1,0))
	Redfall:SpawnFarmlandThief(Vector(3840, -9088), Vector(1,0))
	Redfall:SpawnFarmlandThief(Vector(3648, -8960), Vector(1,0))
end

function Redfall:SpawnCrimsythBandit(position, fv)
	local ancient = Redfall:SpawnDungeonUnit( "redfall_crimsyth_bandit", position, 1, 4, "Redfall.RikiBandit.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 4, 4, false)
	ancient.itemLevel = 54
	ancient:SetRenderColor(255, 160, 160)
	Redfall:ColorWearables(ancient, Vector(255, 160, 160))
	ancient.targetRadius = 950
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	local damage = 800
	if GameState:GetDifficultyFactor() == 2 then
		damage = 8000
	elseif GameState:GetDifficultyFactor() == 3 then
		damage = 85000
	end
    ancient:SetBaseDamageMin(damage)
    ancient:SetBaseDamageMax(damage)
	ancient.targetFindOrder = FIND_ANY_ORDER
	ancient.dominion = true
	return ancient
end

function Redfall:FarmlandsCenterTrigger1()
	Redfall:SpawnCrimsythBandit(Vector(5504, -10368), Vector(1,-1))
	Redfall:SpawnCrimsythBandit(Vector(6016, -10688), Vector(-1,0.3))

	local patrolPositionTable = {Vector(6528, -9664), Vector(8704, -9280), Vector(4478, -9360)}
	local bandit = Redfall:SpawnFarmlandsBandit(Vector(4478, -9360), Vector(-1,0))
	Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
	local thief = Redfall:SpawnCrimsythBandit(Vector(4478, -9160), Vector(-1,0))
	Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
	local thief = Redfall:SpawnCrimsythDuelist(Vector(4378, -9260), Vector(-1,0))
	Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)

	Timers:CreateTimer(1.5, function()
		local patrolPositionTable = {Vector(8192, -9280), Vector(7552, -6912)}
		local bandit = Redfall:SpawnCrimsythDuelist(Vector(7552, -6912), Vector(1,0))
		Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandThief(Vector(7592, -6712), Vector(1,0))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandThief(Vector(7452, -7112), Vector(1,0))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
	end)

	Redfall:SpawnFarmlandSpawner(Vector(6144, -9216), Vector(0,-1), Vector(6144, -9316))
	Redfall:SpawnFarmlandSpawner(Vector(5312, -9216), Vector(0,-1), Vector(5312, -9316))

	Redfall:SpawnGhostPandaFlame(Vector(7232, -8896, 220))
	Redfall:SpawnGhostPandaFlame(Vector(8384, -8960, 220))

	local vectorTable = {Vector(6893, -10713), Vector(6987, -10648), Vector(7092, -10490), Vector(6913, -10195), Vector(7117, -10151), Vector(7334, -10055), Vector(7229, -10212), Vector(7469, -10395), Vector(7204, -10551), Vector(7473, -10601), Vector(7480, -10828), Vector(7751, -10648), Vector(7677, -10196), Vector(7612, -10101), Vector(7871, -10062), Vector(7856, -10491), Vector(7978, -10641), Vector(8172, -10507), Vector(8237, -10601), Vector(8087, -10147), Vector(8192, -9990), Vector(6852, -10307)}
	for i = 1, #vectorTable, 1 do
		Timers:CreateTimer(0.2*i, function()
			Redfall:SpawnTwistedPumpkin(vectorTable[i])
		end)
	end

	Redfall:SpawnFarmlandSpawner(Vector(7552, -10122), Vector(0,-1), Vector(7552, -10122))
	Redfall:SpawnFarmlandSpawner(Vector(7552, -10624), Vector(0,-1), Vector(7552, -10624))
end

function Redfall:IncrementFarmlandsQuest()
	print("----_QUEST STATE_----")
	print(MAIN_HERO_TABLE[1].RedfallQuests[7].state)
	if MAIN_HERO_TABLE[1].RedfallQuests[7].state == -1 then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[7].state = 1
			Redfall:NewQuest(MAIN_HERO_TABLE[i], 7)
		end   
	else
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[7].state = MAIN_HERO_TABLE[i].RedfallQuests[7].state + 1
		end   
	end 
end

function Redfall:FarmlandsWesternTrigger()
	local thiefTable = {}
	local thief = Redfall:SpawnFarmlandsBandit(Vector(9152, -7680), Vector(-1,0))
	table.insert(thiefTable, thief)
	local duelist = Redfall:SpawnCrimsythDuelist(Vector(10085, -8409), Vector(-1,0))
	table.insert(thiefTable, duelist)
	local thief = Redfall:SpawnCrimsythBandit(Vector(9518, -7255), Vector(-1,1))
	table.insert(thiefTable, thief)
	local thief = Redfall:SpawnFarmlandsBandit(Vector(9728, -7104), Vector(1,1))
	table.insert(thiefTable, thief)
	for i = 1, #thiefTable, 1 do
		local bandit = thiefTable[i]
		local banditAbility = bandit:AddAbility("redfall_farmlands_scene_ability")
		banditAbility:ApplyDataDrivenModifier(bandit, bandit, "modifier_farmlands_scene_b", {})
	end

	local bear = Redfall:SpawnChibiBear(Vector(10304, -9216), Vector(-1,-1))
	local patrolPositionTable = {Vector(10304, -9216)+Vector(-90, 90), Vector(10304, -9216)}
	Redfall:AddPatrolArguments(bear, 60, 5, 30, patrolPositionTable)
	bear = Redfall:SpawnChibiBear(Vector(10752, -9472), Vector(0,-1))
	patrolPositionTable = {Vector(10752, -9472), Vector(10752, -9472)+Vector(-60, 50)}
	Redfall:AddPatrolArguments(bear, 60, 6, 30, patrolPositionTable)

	Redfall:SpawnGhostPandaFlame(Vector(9600, -9280, 220))

	Timers:CreateTimer(2, function()
		local patrolPositionTable = {Vector(3712, -8640), Vector(4096, -6976)}
		local bandit = Redfall:SpawnCrimsythDuelist(Vector(4096, -6976), Vector(1,0))
		Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnCrimsythBandit(Vector(4196, -6926), Vector(1,0))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandThief(Vector(3996, -7076), Vector(1,0))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
	end)
end

function Redfall:EndFarmerSceneB()
	Redfall:IncrementFarmlandsQuest()
end

function Redfall:FarmlandsCornTrigger3()
	Redfall:SpawnFarmlandSpawner(Vector(5184, -7488), Vector(0,-1), Vector(5184, -7488))
	Redfall:SpawnFarmlandSpawner(Vector(6272, -8512), Vector(0,1), Vector(6272, -8512))
	local harvesterTable = {Vector(4608, -8704), Vector(5184, -8064), Vector(5760, -7744), Vector(6016, -8256), Vector(6272, -7552)}
	for i = 1, #harvesterTable, 1 do
		Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
	end
	Timers:CreateTimer(1.2, function()
		local positionTable = {Vector(5248, -8512), Vector(4928, -7488), Vector(5760, -7744), Vector(6272, -8512), Vector(6272, -7488)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local wraith = Redfall:SpawnHarvestWraith(positionTable[i], RandomVector(1))
			Redfall:AddPatrolArguments(wraith, 70, 4, 30, patrolPositionTable)
		end
	end)

	Timers:CreateTimer(1, function()
		local patrolPositionTable = {Vector(3712, -8640), Vector(4096, -6976)}
		local bandit = Redfall:SpawnCrimsythDuelist(Vector(4096, -6976), Vector(1,0))
		Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnCrimsythBandit(Vector(4196, -6926), Vector(1,0))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandThief(Vector(3996, -7076), Vector(1,0))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
	end)
	Timers:CreateTimer(1.5, function()
		Redfall:SpawnFarmlandTaskmaster(Vector(4908, -7137), Vector(0, -1))
		Redfall:SpawnFarmlandTaskmaster(Vector(6279, -7119), Vector(0, -1))

		Redfall:SpawnFarmlandTaskmaster(Vector(6978, -7552), Vector(-1, 0))
		Redfall:SpawnFarmlandTaskmaster(Vector(7160, -8000), Vector(-1, 0))
		Redfall:SpawnFarmlandTaskmaster(Vector(7155, -8448), Vector(-1, 0))
		Redfall:SpawnFarmlandTaskmaster(Vector(7040, -8896), Vector(-1, 0))
	end)
	Timers:CreateTimer(2, function()
		local patrolPositionTable = {Vector(7232, -6848), Vector(9024, -5696)}
		local bandit = Redfall:SpawnCrimsythDuelist(Vector(9024, -5696), Vector(-1,-1))
		Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnCrimsythBandit(Vector(9004, -5596), Vector(-1,-1))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandTaskmaster(Vector(9224, -5796), Vector(-1,-1))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
	end)

	if not Redfall.Farmlands then
		Redfall.Farmlands = {}
	end
	Redfall.Farmlands.farmNPCb = Redfall:SpawnTownNPC(Vector(5184, -5760), "redfall_meepo_farmer", Vector(0, -1), nil, nil, nil, 1.0, true, "redfall_farmer2")
	Redfall.ShredderHandler = Redfall.Farmlands.farmNPCb
end

function Redfall:FarmlandsCenterTrigger2()
	Redfall:SpawnCrimsythBandit(Vector(8192, -7422), Vector(-1,0))
	Redfall:SpawnCrimsythBandit(Vector(8512, -7552), Vector(-1,-1))
	Redfall:SpawnFarmlandsBandit(Vector(8512, -8640), Vector(-1, -1))
end

function Redfall:SpawnFarmlandTaskmaster(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "redfall_farmlands_crymsith_taskmaster", position, 1, 4, "Redfall.AutumnTaskmaster.Aggro", fv, false)
	stone:SetRenderColor(234,131,131)
	Redfall:ColorWearables(stone, Vector(255, 130, 130))
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 65
	stone.dominion = true
	return stone
end

function Redfall:FarmlandsWestTrigger2()
	local harvesterTable = {Vector(3776, -7232), Vector(3840, -6784)}
	for i = 1, #harvesterTable, 1 do
		Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
	end

	Redfall:SpawnFarmlandTaskmaster(Vector(3520, -6464), Vector(0, -1))
	Redfall:SpawnFarmlandTaskmaster(Vector(4096, -6976), Vector(-1, 0))

	Redfall:SpawnFarmlandSpawner(Vector(3264, -7552), Vector(1,0), Vector(3464, -7552))

	Redfall:SpawnCrimsythBandit(Vector(4710, -6512), Vector(-1,-1))
	Redfall:SpawnCrimsythBandit(Vector(4544, -6337), Vector(-1,-1))
	Redfall:SpawnCrimsythDuelist(Vector(4358, -6144), Vector(-0.5,-1))
	Timers:CreateTimer(1, function()
		Redfall:SpawnFarmlandTaskmaster(Vector(4710, -6273), Vector(-0.3, -1))
		Redfall:SpawnFarmlandTaskmaster(Vector(4567, -6091), Vector(-0.2, -1))
	end)

	Redfall:SpawnFarmlandSpawner(Vector(3648, -5760), Vector(1,0), Vector(3748, -5760))
	Redfall:SpawnFarmlandSpawner(Vector(3648, -5568), Vector(1,0), Vector(3748, -5568))
	Redfall:SpawnGhostPandaFlame(Vector(3904, -5504, 220))

	Timers:CreateTimer(1.2, function()
		local harvesterTable = {Vector(4160, -4992), Vector(3584, -5440)}
		for i = 1, #harvesterTable, 1 do
			Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
		end
		Redfall:SpawnFarmlandTaskmaster(Vector(4672, -5248), Vector(-1, 0))
	end)
end

function Redfall:Farm3Event(sequence)
	local positionTable = {Vector(5632, -6969), Vector(5888, -6964), Vector(5746, -6823)}
	if sequence == 1 then
		EmitSoundOnLocationWithCaster(positionTable[1], "Redfall.Farmlands.DemonSpawn", Events.GameMaster)
		for i = 1, #positionTable, 1 do
			local spawnPoint = positionTable[i]
			local thief = nil
			if i == 1 then
				thief = Redfall:SpawnCrimsythDuelist(spawnPoint, Vector(0,1))
			elseif i == 2 then
				thief = Redfall:SpawnFarmlandThief(spawnPoint, Vector(0,1))
			else
				thief = Redfall:SpawnFarmlandThief(spawnPoint, Vector(0,1))
			end
			local banditAbility = thief:AddAbility("redfall_farmlands_scene_ability")
			banditAbility:ApplyDataDrivenModifier(thief, thief, "modifier_farmlands_scene_c", {})
			CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", thief, 3)
			Timers:CreateTimer(0.5, function()
				thief:MoveToPositionAggressive(Vector(5184, -5440))
			end)
		end
	elseif sequence == 2 then
		EmitSoundOnLocationWithCaster(positionTable[1], "Redfall.Farmlands.DemonSpawn", Events.GameMaster)
		for i = 1, #positionTable, 1 do
			local spawnPoint = positionTable[i]
			local thief = nil
			if i == 1 then
				thief = Redfall:SpawnCrimsythDuelist(spawnPoint, Vector(0,1))
			elseif i == 2 then
				thief = Redfall:SpawnCrimsythBandit(spawnPoint, Vector(0,1))
			else
				thief = Redfall:SpawnCrimsythBandit(spawnPoint, Vector(0,1))
			end
			local banditAbility = thief:AddAbility("redfall_farmlands_scene_ability")
			banditAbility:ApplyDataDrivenModifier(thief, thief, "modifier_farmlands_scene_c", {})
			CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", thief, 3)
			Timers:CreateTimer(0.5, function()
				thief:MoveToPositionAggressive(Vector(5184, -5440))
			end)
		end
	elseif sequence == 3 then
		EmitSoundOnLocationWithCaster(positionTable[1], "Redfall.Farmlands.DemonSpawn", Events.GameMaster)
		for i = 1, #positionTable, 1 do
			local spawnPoint = positionTable[i]
			local thief = nil
			if i == 1 then
				thief = Redfall:SpawnFarmlandTaskmaster(spawnPoint, Vector(0,1))
			elseif i == 2 then
				thief = Redfall:SpawnFarmlandsBandit(spawnPoint, Vector(0,1))
			else
				thief = Redfall:SpawnFarmlandsBandit(spawnPoint, Vector(0,1))
			end
			local banditAbility = thief:AddAbility("redfall_farmlands_scene_ability")
			banditAbility:ApplyDataDrivenModifier(thief, thief, "modifier_farmlands_scene_c", {})
			CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", thief, 3)
			Timers:CreateTimer(0.5, function()
				thief:MoveToPositionAggressive(Vector(5184, -5440))
			end)
		end
	elseif sequence == 4 then
		EmitSoundOnLocationWithCaster(positionTable[1], "Redfall.Farmlands.DemonSpawn", Events.GameMaster)
		for i = 1, #positionTable, 1 do
			local spawnPoint = positionTable[i]
			local thief = nil
			if i == 1 then
				thief = Redfall:SpawnFarmlandTaskmaster(spawnPoint, Vector(0,1))
			elseif i == 2 then
				thief = Redfall:SpawnCrimsythDuelist(spawnPoint, Vector(0,1))
			else
				thief = Redfall:SpawnCrimsythDuelist(spawnPoint, Vector(0,1))
			end
			local banditAbility = thief:AddAbility("redfall_farmlands_scene_ability")
			banditAbility:ApplyDataDrivenModifier(thief, thief, "modifier_farmlands_scene_c", {})
			CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", thief, 3)
			Timers:CreateTimer(0.5, function()
				thief:MoveToPositionAggressive(Vector(5184, -5440))
			end)
		end
	elseif sequence == 5 then
		EmitSoundOnLocationWithCaster(positionTable[1], "Redfall.Farmlands.DemonSpawn", Events.GameMaster)
		for i = 1, #positionTable, 1 do
			local spawnPoint = positionTable[i]
			local thief = nil
			if i == 1 then
				thief = Redfall:SpawnCrimsythRecruiter(spawnPoint, Vector(0,1))
			elseif i == 2 then
				thief = Redfall:SpawnCrimsythRecruiter(spawnPoint, Vector(0,1))
			else
				thief = Redfall:SpawnCrimsythRecruiter(spawnPoint, Vector(0,1))
			end
			local banditAbility = thief:AddAbility("redfall_farmlands_scene_ability")
			banditAbility:ApplyDataDrivenModifier(thief, thief, "modifier_farmlands_scene_c", {})
			CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", thief, 3)
			Timers:CreateTimer(0.5, function()
				thief:MoveToPositionAggressive(Vector(5184, -5440))
			end)
		end		
	end
end

function Redfall:EndFarmerSceneC()
	Redfall:IncrementFarmlandsQuest()
	Redfall:basic_dialogue(Redfall.Farmlands.farmNPCb, MAIN_HERO_TABLE, "redfall_dialogue_farmer_2_d", 5, 0, 0, true)
end

function Redfall:SpawnCrimsythRecruiter(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "redfall_crimsyth_recruiter", position, 1, 4, "Redfall.CrymsithRecruiter.Aggro", fv, false)
	stone:SetRenderColor(234,131,131)
	Redfall:ColorWearables(stone, Vector(255, 130, 130))
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 68
	stone.dominion = true
	return stone
end

function Redfall:SpawnCrimsythRecruiterAggro(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "redfall_crimsyth_recruiter", position, 1, 4, "Redfall.CrymsithRecruiter.Aggro", fv, true)
	stone:SetRenderColor(234,131,131)
	Redfall:ColorWearables(stone, Vector(255, 130, 130))
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 70
	stone.dominion = true
	return stone
end

function Redfall:FarmlandsEastTrigger1()
	Redfall:SpawnFarmlandSpawner(Vector(7616, -5840), Vector(0,-1), Vector(7616, -5960))
	Redfall:SpawnFarmlandSpawner(Vector(8000, -5840), Vector(0,-1), Vector(8000, -5960))
	local harvesterTable = {Vector(8320, -5440), Vector(7680, -4288), Vector(8704, -3776), Vector(9792, -5632)}
	for i = 1, #harvesterTable, 1 do
		Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
	end
	Redfall:SpawnFarmlandTaskmaster(Vector(10112, -5376), Vector(-1, -1))
	Redfall:SpawnFarmlandTaskmaster(Vector(8832, -4992), Vector(-1, -1))
	Timers:CreateTimer(1, function()
		Redfall:SpawnFarmlandSpawner(Vector(9152, -4352), Vector(1,0), Vector(9252, -4352))
		Redfall:SpawnFarmlandSpawner(Vector(9152, -3840), Vector(1,0), Vector(9152, -3840))
		Redfall:SpawnFarmlandSpawner(Vector(8448, -4096), Vector(0,-1), Vector(8448, -4096))
	end)

	Redfall:SpawnGhostPandaFlame(Vector(9472, -4352, 220))
	Redfall:SpawnGhostPandaFlame(Vector(9472, -3840, 220))

	Redfall:SpawnFarmlandTaskmaster(Vector(9472, -3776), Vector(-1, -1))
	Redfall:SpawnCrimsythRecruiter(Vector(10176, -3712), Vector(-1,-0.2))
	Redfall:SpawnCrimsythRecruiter(Vector(10304, -3968), Vector(-1,-0.6))
	Redfall:SpawnCrimsythRecruiter(Vector(10368, -4224), Vector(-1,-0.9))

	local bear = Redfall:SpawnChibiBear(Vector(10304, -4992), Vector(1,-1))
	local patrolPositionTable = {Vector(10304, -4992), Vector(10304, -4992)+Vector(-90, 90)}
	Redfall:AddPatrolArguments(bear, 60, 5, 30, patrolPositionTable)
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnCrimsythDuelist(Vector(8000, -3520), Vector(0,-1))
		Redfall:SpawnCrimsythDuelist(Vector(8320, -3520), Vector(0,-1))
	end
	Timers:CreateTimer(2.4, function()
		local positionTable = {Vector(7936, -5120), Vector(8194, -4329), Vector(8468, -4069), Vector(8715, -4345)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local wraith = Redfall:SpawnHarvestWraith(positionTable[i], RandomVector(1))
			Redfall:AddPatrolArguments(wraith, 70, 4, 30, patrolPositionTable)
		end
	end)
end

function Redfall:FarmlandsWestTrigger4()
	local vectorTable = {Vector(4920, -3150), Vector(5032, -3170), Vector(5075, -2939), Vector(5267, -2959), Vector(5230, -2773), Vector(5251, -2660), Vector(5460, -2610), Vector(5010, -2806), Vector(5288, -2846)}
	for i = 1, #vectorTable, 1 do
		Timers:CreateTimer(0.2*i, function()
			Redfall:SpawnTwistedPumpkin(vectorTable[i])
		end)
	end

	local harvesterTable = {Vector(5952, -4480), Vector(6528, -4096)}
	for i = 1, #harvesterTable, 1 do
		Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
	end	

	Redfall:SpawnFarmlandSpawner(Vector(6208, -3840), Vector(-1,0), Vector(6208, -3840))
	Redfall:SpawnFarmlandSpawner(Vector(6528, -3840), Vector(-1,0), Vector(6528, -3840))

	Timers:CreateTimer(1, function()
		Redfall:SpawnCrimsythDuelist(Vector(5440, -3328), Vector(1,-0.3))
		Redfall:SpawnCrimsythDuelist(Vector(5760, -3008), Vector(1,-0.8))
	end)
	Redfall:SpawnGhostPandaFlame(Vector(5568, -4480, 220))
end

function Redfall:FarmlandsNorthTrigger1()
	local harvesterTable = {Vector(7294, -2240), Vector(7232, -1216), Vector(8000, -1216)}
	for i = 1, #harvesterTable, 1 do
		Redfall:SpawnRedfallHarvester(harvesterTable[i], RandomVector(1))
	end	
	Redfall:SpawnFarmlandSpawner(Vector(7680, -2304), Vector(0,-1), Vector(7680, -2304))	
	Redfall:SpawnFarmlandTaskmaster(Vector(7872, -1216), Vector(0, -1))
	Redfall:SpawnFarmlandTaskmaster(Vector(7488, -1216), Vector(0, -1))
	Redfall:SpawnFarmlandTaskmaster(Vector(7033, -1216), Vector(0, -1))

	Redfall:SpawnCrimsythDuelist(Vector(8640, -2304), Vector(0,-1))
	Redfall:SpawnFarmlandsBandit(Vector(8764, -2176), Vector(0,-1))
	Redfall:SpawnCrimsythBandit(Vector(8576, -2048), Vector(0,-1))

	Redfall:SpawnCrimsythDuelist(Vector(9408, -2624), Vector(-0.2,-1))
	Redfall:SpawnFarmlandsBandit(Vector(9408, -2432), Vector(-0.2,-1))
	Redfall:SpawnCrimsythBandit(Vector(9600, -2560), Vector(0,-1))

	Timers:CreateTimer(1, function()
		local patrolPositionTable = {Vector(6295, -2914), Vector(9600, -3136)}
		local bandit = Redfall:SpawnCrimsythRecruiter(Vector(7616, -2624), Vector(-1,-1))
		Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnCrimsythRecruiter(Vector(7616, -2624), Vector(-1,-1))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnCrimsythRecruiter(Vector(7616, -2624), Vector(-1,-1))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)

		local patrolPositionTable = {Vector(9600, -3136), Vector(6295, -2914)}
		local bandit = Redfall:SpawnCrimsythDuelist(Vector(8354, -2560), Vector(-1,-1))
		Redfall:AddPatrolArguments(bandit, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandThief(Vector(8354, -2560), Vector(-1,-1))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
		local thief = Redfall:SpawnFarmlandThief(Vector(8354, -2560), Vector(-1,-1))
		Redfall:AddPatrolArguments(thief, 40, 4, 200, patrolPositionTable)
	end)
end

function Redfall:FarmlandsLastHouseSpawn(hero)
	if not Redfall.Farmlands then
		Redfall.Farmlands = {}
	end
	print("SPAWN HOUSE?")
	if not Redfall.Farmlands.LastFarmSpawned then
		if hero.RedfallQuests[7].state == 3 then
			Redfall.Farmlands.LastFarmSpawned = true
			Redfall.Farmlands.farmNPCd = Redfall:SpawnTownNPC(Vector(9371, -1650), "redfall_meepo_farmer", Vector(-1, -1), nil, nil, nil, 1.0, true, "redfall_farmer3")	
		end
	end
end

function Redfall:SpawnFarmlandsBanditAggrod(position, fv)
	local ancient = Redfall:SpawnDungeonUnit( "redfall_farmlands_bandit", position, 1, 4, "Redfall.FarmlandsBandit.Aggro", fv, true)
	ancient.itemLevel = 50
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.dominion = true
	-- ancient:SetRenderColor(255, 118, 118)
	-- Redfall:ColorWearables(ancient, Vector(255, 110, 110))
	return ancient
end


function Redfall:LastFarmhouseScene(hero)
	local banditTable = {}
	local heroOrigin = hero:GetAbsOrigin()*Vector(1,1,0)
	local banditSpawnTable = {Vector(9472, -1984), Vector(9664, -1856), Vector(9865, -1722), Vector(8832, -1600), Vector(8896, -1472), Vector(8960, -1344), Vector(9152, -1280)}
	for i = 1, #banditSpawnTable, 1 do
		Timers:CreateTimer(i*0.1, function()
			local fv = (heroOrigin-banditSpawnTable[i]):Normalized()
			local bandit = Redfall:SpawnFarmlandsBanditAggrod(banditSpawnTable[i], fv)
			


			table.insert(banditTable, bandit)
			local banditAbility = bandit:AddAbility("redfall_farmlands_scene_ability")
			banditAbility:ApplyDataDrivenModifier(bandit, bandit, "modifier_farmlands_scene_d", {})
			banditAbility:ApplyDataDrivenModifier(bandit, bandit, "modifier_farmlands_scene_d_pre", {duration = 2.5})
			local dodgeAbility = bandit:FindAbilityByName("redfall_dodge_ability"):StartCooldown(8)
			CustomAbilities:QuickAttachParticle("particles/generic_hero_status/status_invisibility_start.vpcf", bandit, 2)
		end)
		Timers:CreateTimer(0.9, function()
			for j = 1, #banditTable, 1 do
				local enemy = banditTable[i]
				local castPoint = hero:GetAbsOrigin()
				local castAbility = enemy:FindAbilityByName("redfall_massive_arrow")
				local newOrder = {
						UnitIndex = enemy:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = castAbility:entindex(),
						Position = castPoint
				 	}
				 
				ExecuteOrderFromTable(newOrder)	
			end
		end)
	end

	-- Timers:CreateTimer(2.5, function()
	-- 	local duelistTable = {}
	-- 	local thief = Redfall:SpawnCrimsythDuelist(Vector(9728, -1088), Vector(1,0))
	-- 	table.insert(duelistTable, thief)
	-- 	local banditAbility = thief:AddAbility("redfall_farmlands_scene_ability")
	-- 	banditAbility:ApplyDataDrivenModifier(thief, thief, "modifier_farmlands_scene_d", {})
	-- 	local thief = Redfall:SpawnCrimsythDuelist(Vector(9792, -1280), Vector(1,0))
	-- 	table.insert(duelistTable, thief)
	-- 	local banditAbility = thief:AddAbility("redfall_farmlands_scene_ability")
	-- 	banditAbility:ApplyDataDrivenModifier(thief, thief, "modifier_farmlands_scene_d", {})
	-- 	local thief = Redfall:SpawnCrimsythDuelist(Vector(9984, -1216), Vector(0,-1))
	-- 	table.insert(duelistTable, thief)
	-- 	local banditAbility = thief:AddAbility("redfall_farmlands_scene_ability")
	-- 	banditAbility:ApplyDataDrivenModifier(thief, thief, "modifier_farmlands_scene_d", {})
	-- 	Timers:CreateTimer(1.3, function()
	-- 		for i = 1, #duelistTable, 1 do
	-- 			duelistTable[i]:MoveToPositionAggressive(heroOrigin)
	-- 		end
	-- 	end)
	-- end)
end

function Redfall:FinalFarmlandsScene()
	InitializeSidequestShredder()
	Timers:CreateTimer(1, function()
		Redfall:basic_dialogue(Redfall.Farmlands.farmNPCd, MAIN_HERO_TABLE, "redfall_dialogue_farmer_3_d", 9, 0, 0, true)
		Redfall.Farmlands.farmNPCd:MoveToPosition(Vector(9344, -704))
		Timers:CreateTimer(3, function()
			local walls = Entities:FindAllByNameWithin("BackFarmWalls", Vector(9385, -634, 164+Redfall.ZFLOAT), 1500)
			Redfall:FarmWalls(false, walls, true, 3.0)	
			Timers:CreateTimer(3, function()
				local blockers = Entities:FindAllByNameWithin("BackFarmBlocker", Vector(9344, -582, 83+Redfall.ZFLOAT), 1200)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)		
		end)
		Timers:CreateTimer(6.5, function()
			Redfall.Farmlands.farmNPCd:MoveToPosition(Vector(9984, -320))
			Timers:CreateTimer(2.5, function()
				Redfall.Farmlands.farmNPCd:MoveToPosition(Vector(9984, -320)+Vector(-40,-40))
				Redfall.Farmlands.farmNPCd.dialogueName = "redfall_farmer_enemy"
			end)
		end)
	end)

	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i].RedfallQuests[7].state = 0
		MAIN_HERO_TABLE[i].RedfallQuests[7].objective = "redfall_quest_7_objective_2"
		MAIN_HERO_TABLE[i].RedfallQuests[7].goal = 1
	end
end

function Redfall:FarmWalls(bRaise, walls, bSound, movementZ)
	if not bRaise then
		movementZ = movementZ*-1
	end
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			if bSound then
				for i = 1, #walls, 1 do
					EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Redfall.LowerFarmWall", Events.GameMaster)
				end
			end
		end)
		for i = 1, 180, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
				end)
			end
		end
	end

end

function Redfall:SpawnDemonFarmer(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "redfall_demon_farmer", position, 3, 6, "Redfall.DemonFarmer.Aggro", fv, true)
	stone:SetRenderColor(234,111,111)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 68
	return stone
end

function Redfall:InitiateAnimalPlates()
	local plate1 = Entities:FindByNameNearest("FarmlandsAnimalPlate", Vector(15135, -16170, 141+Redfall.ZFLOAT), 350)
	local plate2 = Entities:FindByNameNearest("FarmlandsAnimalPlate", Vector(15475, -16170, 141+Redfall.ZFLOAT), 350)
	local plate3 = Entities:FindByNameNearest("FarmlandsAnimalPlate", Vector(15808, -16170, 141+Redfall.ZFLOAT), 350)
	local plate4 = Entities:FindByNameNearest("FarmlandsAnimalPlate", Vector(16152, -16170, 141+Redfall.ZFLOAT), 350)

	local platePosition = Vector(12096, -12288) + Vector(RandomInt(0, 1650), RandomInt(0, 1100)) + Vector(0,0,0+Redfall.ZFLOAT)
	plate1:SetAbsOrigin(platePosition)

	local luck = RandomInt(1,2)
	if luck == 1 then
		local platePosition = Vector(8000, -13056) + Vector(RandomInt(0, 1152), RandomInt(0, 1650)) + Vector(0,0,0+Redfall.ZFLOAT)
		plate2:SetAbsOrigin(platePosition)
	else
		local platePosition = Vector(5440, -13504) + Vector(RandomInt(0, 1080), RandomInt(0, 740)) + Vector(0,0,0+Redfall.ZFLOAT)
		plate2:SetAbsOrigin(platePosition)
	end

	local luck = RandomInt(1,4)
	if luck < 4 then
		local platePosition = Vector(4928, -8768) + Vector(RandomInt(0, 1450), RandomInt(0, 1200)) + Vector(0,0,0+Redfall.ZFLOAT)
		plate3:SetAbsOrigin(platePosition)
	else
		local platePosition = Vector(3904, -5440) + Vector(0,0,0+Redfall.ZFLOAT)
		plate3:SetAbsOrigin(platePosition)
	end

	local luck = RandomInt(1,3)
	if luck == 1 then
		local platePosition = Vector(7680, -4800) + Vector(RandomInt(0, 1000), RandomInt(0, 940)) + Vector(0,0,0+Redfall.ZFLOAT)
		plate4:SetAbsOrigin(platePosition)
	elseif luck == 2 then
		local platePosition = Vector(9600, -6656) + Vector(RandomInt(0, 230), RandomInt(0, 640)) + Vector(0,0,0+Redfall.ZFLOAT)
		plate4:SetAbsOrigin(platePosition)
	else
		local platePosition = Vector(6400, -1920) + Vector(RandomInt(0, 1600), RandomInt(0, 400)) + Vector(0,0,0+Redfall.ZFLOAT)
		plate4:SetAbsOrigin(platePosition)
	end
	Redfall.CorrectAnimalTable = {}
	local animalTable = {"pig", "rabbit", "rat", "rooster"}

	local selection = animalTable[RandomInt(1, #animalTable)]
	table.insert(Redfall.CorrectAnimalTable, selection)
	plate1:SetModel("models/animal_plate_"..selection..".vmdl")

	local selection = animalTable[RandomInt(1, #animalTable)]
	table.insert(Redfall.CorrectAnimalTable, selection)
	plate2:SetModel("models/animal_plate_"..selection..".vmdl")

	local selection = animalTable[RandomInt(1, #animalTable)]
	table.insert(Redfall.CorrectAnimalTable, selection)
	plate3:SetModel("models/animal_plate_"..selection..".vmdl")

	local selection = animalTable[RandomInt(1, #animalTable)]
	table.insert(Redfall.CorrectAnimalTable, selection)
	plate4:SetModel("models/animal_plate_"..selection..".vmdl")	

	Timers:CreateTimer(2, function()
		Redfall.ShipyardBackBridge = Entities:FindByNameNearest("ShipyardBackBridge", Vector(12004, 1856, -557+Redfall.ZFLOAT), 550)
		Redfall.ShipyardBackBridge:SetAbsOrigin(Redfall.ShipyardBackBridge:GetAbsOrigin()-Vector(0,0,600))

		local backAnimalSwitch1 = Entities:FindByNameNearest("ShipyardBackBridge", Vector(12004, 1856, -557+Redfall.ZFLOAT), 550)
		Redfall.BackSwitches = {}
		local switch = Entities:FindByNameNearest("ShipyardBackAnimalSwitch", Vector(10986, 1693, -524+Redfall.ZFLOAT), 450)
		table.insert(Redfall.BackSwitches, switch)
		local switch = Entities:FindByNameNearest("ShipyardBackAnimalSwitch", Vector(10986, 1393, -524+Redfall.ZFLOAT), 450)
		table.insert(Redfall.BackSwitches, switch)
		local switch = Entities:FindByNameNearest("ShipyardBackAnimalSwitch", Vector(10986, 1085, -524+Redfall.ZFLOAT), 450)
		table.insert(Redfall.BackSwitches, switch)
		local switch = Entities:FindByNameNearest("ShipyardBackAnimalSwitch", Vector(10986, 780, -524+Redfall.ZFLOAT), 450)
		table.insert(Redfall.BackSwitches, switch)
		for i = 1, #Redfall.BackSwitches, 1 do
			local switch = Redfall.BackSwitches[i]
			switch:SetAbsOrigin(switch:GetAbsOrigin()-Vector(0,0,480))
		end
	end)
end

function Redfall:BackFarmChestTrigger()
	local chest = Entities:FindByNameNearest("BackFarmChest", Vector(14601, 3456, -666+Redfall.ZFLOAT), 600)
	local keyTargetPos = Vector(14905, 3392, -481+Redfall.ZFLOAT)
	local key = Entities:FindByNameNearest("BackFarmKeyProp", Vector(14905, 3392, -937+Redfall.ZFLOAT), 600)
	for i = 1, 35, 1 do
		Timers:CreateTimer(0.03*i, function()
			chest:SetAbsOrigin(chest:GetAbsOrigin()+Vector(0,0,i*0.22 + 1))
			chest:SetModelScale(1.6-i*0.04)
		end)
	end
	EmitSoundOnLocationWithCaster(chest:GetAbsOrigin(), "Redfall.Farmlands.SwitchPress", Events.GameMaster)
	ScreenShake(chest:GetAbsOrigin(), 130, 0.9, 0.9, 9000, 0, true)
	Timers:CreateTimer(1.1, function()
		local particleName = "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf"
	  	local position = chest:GetAbsOrigin()
	  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	  	ParticleManager:SetParticleControl(pfx, 0, position)
	  	ParticleManager:SetParticleControl(pfx, 1, position)
		  Timers:CreateTimer(3, function()
			   ParticleManager:DestroyParticle(pfx, false)
		  end)	
		  EmitSoundOnLocationWithCaster(chest:GetAbsOrigin(), "Redfall.Farmlands.ChestDisappear", Redfall.RedfallMaster)
		  UTIL_Remove(chest)	
	end)
	Timers:CreateTimer(2, function()
		ScreenShake(keyTargetPos, 130, 0.9, 0.9, 9000, 0, true)
		for i = 1, 70, 1 do
			Timers:CreateTimer(i*0.03, function()
				if i %10 == 0 then
					ScreenShake(keyTargetPos, 130, 0.9, 0.9, 9000, 0, true)
				end
				if i == 20 then
					EmitSoundOnLocationWithCaster(key:GetAbsOrigin(), "Redfall.WaterSplash", Redfall.RedfallMaster)
			  		local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
			  	  	local position = key:GetAbsOrigin()
			  	  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			  	  	ParticleManager:SetParticleControl(pfx, 0, position)
			  		  Timers:CreateTimer(2, function()
			  			   ParticleManager:DestroyParticle(pfx, false)
			  		  end)		
				end
				key:SetAbsOrigin(key:GetAbsOrigin()+Vector(0,0,7))
			end)
		end
		Timers:CreateTimer(2.1, function()
			for i = 1, 80, 1 do
				Timers:CreateTimer(i*0.03, function()
					key:SetAbsOrigin(key:GetAbsOrigin() + Vector(0,0,math.cos((2*math.pi*i)/80))*5)				
				end)
			end
		end)
		Timers:CreateTimer(4.6, function()
			local particleName = "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf"
		  	local position = key:GetAbsOrigin()
		  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		  	ParticleManager:SetParticleControl(pfx, 0, position)
		  	ParticleManager:SetParticleControl(pfx, 1, position)
			  Timers:CreateTimer(3, function()
				   ParticleManager:DestroyParticle(pfx, false)
			  end)	
			  EmitSoundOnLocationWithCaster(key:GetAbsOrigin(), "Redfall.Farmlands.ChestDisappear", Redfall.RedfallMaster)
			  for i = 1, #MAIN_HERO_TABLE, 1 do
			  	Redfall:GiveShipyardKey(MAIN_HERO_TABLE[i], position)
			  end
			  Timers:CreateTimer(0.5, function()
			  	UTIL_Remove(key)	
			  	EmitSoundOnLocationWithCaster(keyTargetPos, "Redfall.KeyAcquireMystery", Events.GameMaster)
			  end)
		end)
	end)
	Timers:CreateTimer(5, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[7].active = 2
			MAIN_HERO_TABLE[i].RedfallQuests[7].state = 1
		end
	end)
end

function InitializeSidequestShredder()
	local spawnPosition = Vector(12416, 853)
	local shredder = CreateUnitByName("redfall_farmlands_friendly_harvester", spawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
	local shredderAbility = shredder:FindAbilityByName("redfall_friendly_shredder_passive")
	shredderAbility:SetLevel(1)
	shredder:SetRenderColor(0, 0, 0)
	Redfall:ColorWearables(shredder, Vector(0, 0, 0))
	Timers:CreateTimer(0.1, function()
		StartAnimation(shredder, {duration=1, activity=ACT_DOTA_DISABLED, rate=1}) 
	end)
	Timers:CreateTimer(1.1, function()
		shredderAbility:ApplyDataDrivenModifier(shredder, shredder, "modifier_friendly_shredder_disabled", {})
	end)
	Redfall.FriendlyShredder = shredder
end

function Redfall:SpawnRubyGiant(position, fv)
	local stone = Redfall:SpawnDungeonUnit( "ancient_ruby_giant", position, 2, 5, "Redfall.RubyGiant.Aggro", fv, false)
	stone:SetRenderColor(234,160,160)
	Events:ColorWearables(stone, Vector(234, 160, 160))
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 68
	return stone
end
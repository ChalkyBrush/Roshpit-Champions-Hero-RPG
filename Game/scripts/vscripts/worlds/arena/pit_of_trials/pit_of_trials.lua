function Arena:PreparePitSwitches()
	Arena.PitSwitchTable = {}
	local deltaY = -226
	local deltaX = -243
	local baseVector = Vector(-8768, 8141, -204)
	for i = 0, 4, 1 do
		for j = 0, 3, 1 do	
			local s1 = Entities:FindByNameNearest("PitSwitch", baseVector+Vector(deltaX*j, deltaY*i), 300)
			table.insert(Arena.PitSwitchTable, s1)
		end
	end
	--print("Prepare Pit Switches")
	Arena.PitSwitchColorTable = {}
	local colorTable = {"red", "blue", "yellow"}
	for i = 1, #Arena.PitSwitchTable, 1 do
		local color = colorTable[RandomInt(1,3)]
		table.insert(Arena.PitSwitchColorTable, color)
		Arena:SetSwitchColor(Arena.PitSwitchTable[i], color)
	end
end

function Arena:SetSwitchColor(switch, color)
	local colorVector = Vector(255, 160, 160)
	if color == "blue" then
		colorVector = Vector(160, 160, 255)
	elseif color == "yellow" then
		colorVector = Vector(255, 255, 120)
	end
	switch:SetRenderColor(colorVector.x, colorVector.y, colorVector.z)
end

function Arena:PitWall(bRaise, walls, bSound, movementZ)
	if not bRaise then
		movementZ = movementZ*-1
	end
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			if bSound then
				for i = 1, #walls, 1 do
					EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Arena.WallOpen", Events.GameMaster)
				end
			end
		end)
		for i = 1, 130, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end
end

function Arena:PitSetup(hero, starLevel)
	if not Arena.PitActive then
		--print(starLevel)
		Arena:OpenPit(starLevel)
		Arena:UpdatePitLockout(hero)
	end
end

function Arena:UpdatePitLockout(hero)
	local steamID = PlayerResource:GetSteamAccountID(hero:GetPlayerOwnerID())
	local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
	local url = ROSHPIT_URL.."/champions/updatePitLockout?"
	if hero.roshpitID == nil then
		return
	end
	url = url.."steam_id="..steamID
	url = url.."&hero_id="..hero.roshpitID
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	-- url = url.."&rank="..battleRank
	-- url = url.."&score="..score
	--SaveLoad:NewKey()
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		--SaveLoad:NewKey()
		local resultTable = {}
		--print( "GET response:\n" )
		for k,v in pairs( result ) do
			--print( string.format( "%s : %s\n", k, v ) )
		end
		--print( "Done." )
		local resultTable = JSON:decode(result.Body)
	end )	
end

function Arena:UpdatePitLevels()
	if SaveLoad:GetAllowSaving() then
		--SaveLoad:NewKey()
		local url = ROSHPIT_URL.."/champions/updatePitClear?"
		for i = 1, #MAIN_HERO_TABLE, 1 do
			Timers:CreateTimer(i, function()
				local steamID = PlayerResource:GetSteamAccountID(MAIN_HERO_TABLE[i]:GetPlayerOwnerID())
				local individualURL = url.."steam_id="..steamID
				individualURL = individualURL.."&hero_id="..MAIN_HERO_TABLE[i].roshpitID
				individualURL = individualURL.."&pit_level="..Arena.PitLevel
				individualURL = individualURL.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
				--print(individualURL)
				--print(MAIN_HERO_TABLE[i])
				if MAIN_HERO_TABLE[i].pit.pit_level < Arena.PitLevel then
					CreateHTTPRequestScriptVM( "POST", individualURL ):Send( function( result )
						--SaveLoad:NewKey()
						local resultTable = {}
						--print( "GET response:\n" )
						for k,v in pairs( result ) do
							--print( string.format( "%s : %s\n", k, v ) )
						end
						--print( "Done." )
						local resultTable = JSON:decode(result.Body)
					end )	
				end
			end)
		end
	end
end

function Arena:OpenPit(pitLevel)
	Dungeons.respawnPoint = Vector(-8064, 7616)
	Arena.PitActive = true
	Arena.PitLevel = pitLevel
	Arena.PitLocked = true
	CustomGameEventManager:Send_ServerToAllClients("update_pit_level", {pitLevel = pitLevel} )
	Arena:ClearCrowd()
	CustomGameEventManager:Send_ServerToAllClients("update_zone_display", {zoneName = "tooltip_pit_of_trials"})
	Arena:ClearOutsideEntities()
	Timers:CreateTimer(3, function()
		local wall = Entities:FindByNameNearest("PitOfTrialsWall2", Vector(-8046, 8365, -430), 300)
		Arena:PitWall(false, {wall}, true, 4.9)
		Timers:CreateTimer(4.6, function()
			local blockers = Entities:FindAllByNameWithin("PitOfTrialsBlocker2", Vector(-8064, 8359), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end)
    Timers:CreateTimer(4, function()
      Challenges:ProcessPossibleSpawnEvent(Arena.PitLevel)
    end)
	CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
	CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.PitIntro"})
	Timers:CreateTimer(5, function()
		Arena:PitMusic()
	end)
	Arena:SpawnChampionGladiator(Vector(-6464, 7808), Vector(-0.2, 1))
end

function Arena:PitMusic()
	Timers:CreateTimer(5, function()
		if Arena.PitActive then
			if Arena.PitBossActive or Arena.PitBossActive2 then
				return false
			end
			CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.PitMusic"})
			if Arena.PitActive then
				return 82
			end
		end
	end)
end

function Arena:ActivateSwitchGeneric(buttonPosition, buttonName, bDown, ms)
	local movementZ = ms
	if bDown then
		movementZ = -ms
	end
	local switch = Entities:FindByNameNearest(buttonName, buttonPosition, 600)
	local walls = {switch}
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Arena.WaterTemple.SwitchStart", Events.GameMaster)
	end)
	for i = 1, 60, 1 do
		for j = 1, #walls, 1 do
			Timers:CreateTimer(i*0.03, function()
				walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
			end)
		end
	end
	Timers:CreateTimer(1.7, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Arena.WaterTemple.SwitchEnd", Events.GameMaster)
	end)
end

function Arena:ActivateSwitchSpecific(switch, bDown, ms)
	local movementZ = ms
	if bDown then
		movementZ = -ms
	end
	local walls = {switch}
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Arena.WaterTemple.SwitchStart", Events.GameMaster)
	end)
	for i = 1, 60, 1 do
		for j = 1, #walls, 1 do
			Timers:CreateTimer(i*0.03, function()
				walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
			end)
		end
	end
	Timers:CreateTimer(1.7, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Arena.WaterTemple.SwitchEnd", Events.GameMaster)
	end)
end

function Arena:SpawnDungeonUnit(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)

	local maxLuck = Arena:GetParagonSpawnRateMax()
    local luck = RandomInt(1, maxLuck)
    local unit = ""
    if luck == 1 then
     unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
    else
     unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
     Events:AdjustDeathXP(unit)
    end
    local ability = unit:FindAbilityByName("dungeon_creep")
    if ability then
      ability:SetLevel(1)
      ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
    end
    if aggroSound then
      unit.aggroSound = aggroSound
    end
    unit.minDungeonDrops = minDrops
    unit.maxDungeonDrops = maxDrops
    if fv then
      unit:SetForwardVector(fv)
    end
    if isAggro then
      Dungeons:AggroUnit(unit)
    end
    if Arena.PitLevel then
    	local currentBounty = unit:GetDeathXP()
    	local adjustBounty = math.floor(currentBounty*(1.16^Arena.PitLevel))
    	unit:SetDeathXP(adjustBounty)
    end
    Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, unit, "modifier_arena_pit_of_trials_enemy", {})
    local damageStacks = Arena:GetDamageStacks()
    if damageStacks > 0 then
    	Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, unit, "modifier_arena_pit_of_trials_damage", {})
    	Arena.ArenaMaster:SetModifierStackCount("modifier_arena_pit_of_trials_damage", Arena.ArenaMaster, damageStacks)
    end
    return unit
end

function Arena:AddPitToUnit(unit)
    Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, unit, "modifier_arena_pit_of_trials_enemy", {})
    local damageStacks = Arena:GetDamageStacks()
    if damageStacks > 0 then
    	Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, unit, "modifier_arena_pit_of_trials_damage", {})
    	Arena.ArenaMaster:SetModifierStackCount("modifier_arena_pit_of_trials_damage", Arena.ArenaMaster, damageStacks)
    end
end

function Arena:GetResistancePercentage()
	local resistMult = 1
	if Arena.PitLevel == 2 then
		resistMult = 0.5	
	elseif Arena.PitLevel == 3 then
		resistMult = 0.2	
	elseif Arena.PitLevel == 4 then
		resistMult = 0.1	
	elseif Arena.PitLevel == 5 then
		resistMult = 0.007	
	elseif Arena.PitLevel == 6 then
		resistMult = 0.001	
	elseif Arena.PitLevel == 7 then
		resistMult = 0.0001	
	end
	return resistMult
end

function Arena:GetDamageStacks()
	local damageStacks = 0
	if Arena.PitLevel == 2 then
		damageStacks = 3
	elseif Arena.PitLevel == 3 then
		damageStacks = 5
	elseif Arena.PitLevel == 4 then
		damageStacks = 10
	elseif Arena.PitLevel == 5 then
		damageStacks = 20
	elseif Arena.PitLevel == 6 then
		damageStacks = 30
	elseif Arena.PitLevel == 7 then
		damageStacks = 40
	end
	return damageStacks
end

function Arena:GetParagonSpawnRateMax()
	local maxSpawn = 100
	if Arena.PitLevel == 2 then
		maxSpawn = 90
	elseif Arena.PitLevel == 3 then
		maxSpawn = 80
	elseif Arena.PitLevel == 4 then
		maxSpawn = 70
	elseif Arena.PitLevel == 5 then
		maxSpawn = 60
	elseif Arena.PitLevel == 6 then
		maxSpawn = 50
	elseif Arena.PitLevel == 7 then
		maxSpawn = 40
	end
	return maxSpawn
end

function Arena:SpawnRoom1()
	Arena:SpawnMasterDuelist(Vector(-6528, 8448)+RandomVector(RandomInt(1,200)), Vector(-1,1))
	Timers:CreateTimer(1.5, function()
		Arena:SpawnMasterDuelist(Vector(-5696, 8128)+RandomVector(RandomInt(1,200)), Vector(-1,1))
	end)
	Timers:CreateTimer(3.0, function()
		Arena:SpawnMasterDuelist(Vector(-6080, 7680)+RandomVector(RandomInt(1,200)), Vector(-1,1))
	end)
	Timers:CreateTimer(4.5, function()
		Arena:SpawnMasterDuelist(Vector(-6912, 7744)+RandomVector(RandomInt(1,200)), Vector(-1,1))
	end)

end

function Arena:SpawnMasterDuelist(position, fv)
	local stone = Arena:SpawnDungeonUnit("master_duelist", position, 1, 3, "Arena.MasterDuelist.Aggro", fv, true)
	stone:SetRenderColor(70,70,70)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 95
	StartAnimation(stone, {duration=1.8, activity=ACT_DOTA_TELEPORT, rate=1.0})
	stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,900))
	WallPhysics:Jump(stone, Vector(1,1), 0, 0, 0, 1)
	stone.jumpEnd = "basic_dust"
	stone.dominion = true
	return stone
end

function Arena:SpawnChampionGladiator(position, fv)
	local stone = Arena:SpawnDungeonUnit("champion_gladiator", position, 2, 4, "Arena.ChampionGladiator.Aggro", fv, false)
	stone:SetRenderColor(100,100,100)
	Events:AdjustBossPower(stone, 8, 8, false)
	stone.itemLevel = 99
	Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Arena:SpawnQuizmaster(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_quizmaster", position, 2, 4, "Arena.QuizMaster.Aggro", fv, false)
	stone:SetRenderColor(255,120,255)
	Events:AdjustBossPower(stone, 8, 8, false)
	stone.itemLevel = 99
	stone.targetRadius = 1000
	stone.autoAbilityCD = 1
	stone.dominion = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnCrazyQuizmaster(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_quizmaster", position, 3, 4, "Arena.QuizMaster.Aggro", fv, false)
	stone:SetRenderColor(10,10,10)
	stone:SetModelScale(2.1)
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 99
	stone.targetRadius = 1000
	stone.autoAbilityCD = 1
	stone:AddAbility("arena_master_duelist_passive"):SetLevel(3)
	stone.dominion = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnPitCrawler(position, fv)
	local stone = Arena:SpawnDungeonUnit("pit_crawler", position, 0, 2, nil, fv, true)
	stone:SetAbsOrigin(position-Vector(0,0,RandomInt(550,750)))
	stone:SetRenderColor(100,100,100)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 92
	local ability = stone:FindAbilityByName("arena_pit_crawler_ai")
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_arena_pit_crawler_enter", {})
	stone.fv = fv
	stone.dominion = true
	return stone
end

function Arena:SpawnShadowSniper(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_shadow_sniper", position, 1, 3, "Arena.ShadowSniper.Aggro", fv, false)
	stone:SetRenderColor(30,30,30)
	Arena:ColorWearables(stone, Vector(30,30,30))
	Events:AdjustBossPower(stone, 6, 6, false)
	stone.itemLevel = 99
	stone.dominion = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
	
end

function Arena:SpawnGhouls()
	-- local ghoulVecTable = {Vector(-6528, 7281), Vector(-6912, 7324), Vector(-7245, 7324), Vector(-7040, 7324), Vector(-7447, 7336), Vector(-6180, 7319), Vector(-5952, 7329), Vector(-5843, 8515), Vector(-5723, 8329), Vector(-5998, 8613)}
	-- local ghoulFVtable = {Vector(0,1), Vector(0,1), Vector(0,1), Vector(0,1), Vector(0,1), Vector(0,1), Vector(0,1), Vector(-1,-1), Vector(-1,-1), Vector(-1,-1)}

	-- local ghoulAngleTable = {Vector(-90, 90, 0), Vector(-90, 90, 0), }
	for i = 1, 35, 1 do
		Timers:CreateTimer(0.7*i, function()
			local position = Vector(0,0)
			local fv = Vector(0,0)
			local angles = Vector(0,0,0)
			local luck = RandomInt(1,4)
			if luck == 1 then
				local ghoulVecTable = {Vector(-5843, 8515), Vector(-5723, 8329), Vector(-5998, 8613)}
				position = ghoulVecTable[RandomInt(1,3)]
				fv = Vector(-1,-1)
				angles = Vector(-90, 210, 0)
			else
				position = Vector(-7273+RandomInt(1,1800), 7331)
				fv = Vector(0,1)
				angles = Vector(-90, 90, 0)
			end

			local ghoul = Arena:SpawnPitCrawler(position, fv)
			ghoul:SetAngles(angles.x, angles.y, angles.z)
		end)
	end
end

function Arena:SetPositionCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
	unit.targetRadius = radius
	unit.minRadius = minRadius
	unit.targetAbilityCD = cooldown
	unit.targetFindOrder = targetFindOrder
end

function Arena:SpawnRoom2()
	Timers:CreateTimer(3, function()
		local wall = Entities:FindByNameNearest("PitOfTrialsWall3", Vector(-4625, 7801, -157), 400)
		Arena:PitWall(false, {wall}, true, 5.8)
		Timers:CreateTimer(4.6, function()
			local blockers = Entities:FindAllByNameWithin("PitOfTrialsBlockers3", Vector(-4607, 7872), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end)
	Arena:SpawnQuizmaster(Vector(-2944, 8064), Vector(-1,0))
	Timers:CreateTimer(1.33, function()
		Arena:SpawnQuizmaster(Vector(-1984, 8704), Vector(0,-1))
	end)
	Timers:CreateTimer(2.66, function()
		Arena:SpawnQuizmaster(Vector(-1088, 8128), Vector(-1,1))
	end)
	Arena:SpawnSoulRevenant(Vector(-2112, 9686), Vector(0,-1))
	Timers:CreateTimer(4, function()
		Arena:SpawnShadowSniper(Vector(-3328, 8640), Vector(0,-1))
		Arena:SpawnShadowSniper(Vector(-2880, 8841), Vector(1,-1))
		Arena:SpawnShadowSniper(Vector(-1391, 9202), Vector(-1,-1))
		Arena:SpawnShadowSniper(Vector(-1088, 8704), Vector(-1,-1))
		Arena:SpawnShadowSniper(Vector(-768, 8640), Vector(-1,0))
		Arena:SpawnShadowSniper(Vector(-2752, 9920), Vector(0,-1))
		Arena:SpawnShadowSniper(Vector(-1536, 9920), Vector(-0.5,-1))
	end)
	Timers:CreateTimer(6, function()
		Arena:SpawnCrazyQuizmaster(Vector(-3732, 9344), Vector(1,0))
	end)
end

function Arena:SpawnSoulRevenant(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_soul_revenant", position, 2, 4, "Arena.SoulRevenant.Aggro", fv, false)
	stone:SetRenderColor(255,120,255)
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 105
	stone.dominion = true
	return stone
end

function Arena:InitTrialOfConquest()
	Arena:SpawnMireKeeper(Vector(-5184, 10432), Vector(1,0))
	Arena:SpawnMireKeeper(Vector(-5116, 10816), Vector(1,-0.2))
	Arena:SpawnMireKeeper(Vector(-4672, 11200), Vector(0.4,-1))
	Arena:SpawnMireKeeper(Vector(-5056, 11776), Vector(0.2,-1))
	Timers:CreateTimer(2, function()
		Arena:SpawnMoutaninBehemoth(Vector(-5952, 10624), Vector(0.7,1))
	end)
	Timers:CreateTimer(5, function()
		local posTable = {Vector(-5760, 12224), Vector(-5248, 12672), Vector(-5632, 13248), Vector(-6848, 13696), Vector(-6720, 13888), Vector(-7360, 12288), Vector(-7744, 12224)}
		local fvTable = {Vector(0,-1), Vector(-1,-1), Vector(-1,-1), Vector(-0.2,-1), Vector(0,-1), Vector(0,1), Vector(0,1)}
		for i = 1, #posTable, 1 do
			Arena:SpawnRootOvergrowth(posTable[i], fvTable[i])
		end
	end)
	Timers:CreateTimer(7, function()
		Arena:SpawnCragnataur(Vector(-8064, 13056), Vector(1,0))
		Arena:SpawnCragnataur(Vector(-7278, 13116), Vector(1,1))
		Arena:SpawnMoutaninBehemoth(Vector(-6080, 13632), Vector(0.7,-1))
		Timers:CreateTimer(3, function()
			Arena:SpawnMoutaninBehemoth(Vector(-7552, 12352), Vector(0.2,1))
			Arena:SpawnMireKeeper(Vector(-5632, 13056), Vector(1,-1))
			Arena:SpawnMireKeeper(Vector(-6784, 13632), Vector(1,-1))
			Arena:SpawnMireKeeper(Vector(-7104, 13888), Vector(-0.2,-1))
		end)
	end)
	Timers:CreateTimer(1, function()
		Arena.StaffBird = CreateUnitByName("npc_flying_dummy_vision", Vector(-9251, 12095), false, nil, nil, DOTA_TEAM_GOODGUYS)
		Arena.StaffBird:SetAbsOrigin(Vector(-9251, 12095, 498))
		Arena.StaffBird:FindAbilityByName("dummy_unit"):SetLevel(1)
		Arena.StaffBird:SetOriginalModel("models/props_gameplay/roquelaire/roquelaire.vmdl")
		Arena.StaffBird:SetModel("models/props_gameplay/roquelaire/roquelaire.vmdl")
		Arena.StaffBird:SetModelScale(1.5)
		StartAnimation(Arena.StaffBird, {duration=99999, activity=ACT_DOTA_ROQUELAIRE_LAND_IDLE, rate=1.0})
	end)
end

function Arena:SpawnMireKeeper(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_mire_keeper", position, 1, 3, "Arena.MireKeeper.Aggro", fv, false)
	stone:SetRenderColor(150,250,150)
	Events:AdjustBossPower(stone, 7, 7, false)
	stone.itemLevel = 102
	stone.dominion = true
	return stone
end

function Arena:SpawnMoutaninBehemoth(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_mountain_behemoth", position, 2, 4, "Arena.MountainBehemoth.Aggro", fv, false)
	stone:SetRenderColor(150,150,150)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	stone.targetRadius = 800
	stone.minRadius	= 0
	stone.targetAbilityCD = 1
	stone.targetFindOrder = FIND_FARTHEST
	stone.dominion = true
	return stone
end

function Arena:SpawnRootOvergrowth(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_root_overgrowth", position, 1, 3, nil, fv, false)
	stone:SetRenderColor(200,200,200)
	Events:AdjustBossPower(stone, 7, 7, false)
	stone.itemLevel = 102
	stone.dominion = true
	return stone
	
end

function Arena:SpawnCragnataur(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_cragnataur", position, 2, 4, "Arena.Cragnataur.Anger", fv, false)
	stone:SetRenderColor(140,140,140)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 105
	Arena:SetPositionCastArgs(stone, 1100, 0, 1, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Arena:SpawnBigPitSpider(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_mountain_spider", position, 2, 4, "Arena.PitSpider.Aggro", fv, false)
	stone:SetRenderColor(140,140,140)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 105
	Arena:SetPositionCastArgs(stone, 1000, 0, 1, FIND_FARTHEST)
	stone.dominion = true
	return stone
end

function Arena:SpawnConquestPart2()
	local VectorTable = {Vector(-11264, 13376), Vector(-11392, 13824), Vector(-11380, 14312), Vector(-11328, 14592), Vector(-10944, 15040), Vector(-10918, 15232), Vector(-10688, 15168)}
	local fvTable = {Vector(0,1), Vector(1,1), Vector(-1,-1), Vector(1,1), Vector(1,0.3), Vector(1,0), Vector(1,0)}
	for i = 1, #VectorTable, 1 do
		Arena:SpawnBigPitSpider(VectorTable[i], fvTable[i])
	end
	Timers:CreateTimer(4, function()
		Arena:SpawnMoutaninBehemoth(Vector(-12904, 11084), Vector(0,-1))
	end)
	Timers:CreateTimer(8, function()
		Arena:SpawnPriestOfKarzhun(Vector(-12800, 12480), Vector(0.3,-1))
	end)
	Timers:CreateTimer(15, function()
		Arena:SpawnHelob(Vector(-12544, 14784), Vector(1,-1))
	end)
	Timers:CreateTimer(20, function()
		local luck = RandomInt(1,(8-Arena.PitLevel))
		if luck == 1 then
			local guardianVecTable = {Vector(-13184, 15424), Vector(-13440, 15552), Vector(-13376, 15360), Vector(-13504, 15232), Vector(-13440, 15040), Vector(-13504, 14912), Vector(-13376, 14848), Vector(-13504, 14720)}
			for i = 1, #guardianVecTable, 1 do
				Arena:SpawnRuinsGuardian(guardianVecTable[i], (Vector(-12804, 15000)-guardianVecTable[i]):Normalized())
			end
		end
	end)
end

function Arena:SpawnPitSpider(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_spider", position, 0, 2, nil, fv, true)
	stone:SetAbsOrigin(position-Vector(0,0,RandomInt(550,750)))
	stone:SetRenderColor(160,120,110)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 92
	local ability = stone:FindAbilityByName("arena_pit_crawler_ai")
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_arena_pit_crawler_enter", {})
	stone.fv = fv
	stone.dominion = true
	return stone
end

function Arena:SpawnConquestSpiders()
	for i = 1, 28+Arena.PitLevel, 1 do
		Timers:CreateTimer(0.55*i, function()
			local position = Vector(0,0)
			local fv = Vector(0,0)
			local angles = Vector(0,0,0)
			local luck = RandomInt(1,7)
			if luck == 1 then
				local ghoulVecTable = {Vector(-11142, 14634), Vector(-10989, 14784), Vector(-10840, 14976)}
				position = ghoulVecTable[RandomInt(1,3)]
				fv = Vector(-1,1)
				angles = Vector(-75, 135, 0)
			elseif luck < 4 then
				position = Vector(-10465+RandomInt(1,465), 14930)
				fv = Vector(0,1)
				angles = Vector(-90, 270, 0)
			elseif luck < 5 then
				position = Vector(-9692+RandomInt(1,250), 15213)
				fv = Vector(0,1)
				angles = Vector(-90, 270, 0)		
			elseif luck < 8 then
				position = Vector(-10942, 13386+RandomInt(1,670))
				fv = Vector(-1,0)
				angles = Vector(-90, 180, 0)			
			end

			local ghoul = Arena:SpawnPitSpider(position, fv)
			ghoul:SetAngles(angles.x, angles.y, angles.z)
		end)
	end
end

function Arena:SpawnPriestOfKarzhun(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_priest_of_karzhun", position, 3, 4, "Arena.KarzhunPriest.Aggro", fv, false)
	stone:SetRenderColor(140,140,140)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 115
	return stone
end

function Arena:SpawnHelob(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_helob", position, 3, 4, "Arena.Helob.Aggro", fv, false)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 118
	stone.dominion = true
	return stone
end

function Arena:SpawnRuinsGuardian(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_conquest_ruins_guardian", position, 1, 2, "Arena.TempleGuardian.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 110
	stone.dominion = true
	return stone
end

function Arena:PitConquestKarzhun(hero)
	local goldAmount = PlayerResource:GetGold(hero:GetPlayerOwnerID())
	if not Arena.Karzhun then
		if goldAmount > 0 then
			
			Arena.Karzhun = true

			local goldCoins = Entities:FindByNameNearest("KarzhunGold", Vector(-11734, 15584, 531), 800)
			goldCoins:SetOrigin(Vector(-11734, 15584, 872))
			local stackLevel = math.floor(goldAmount/10000) + 1
			local randomBonus = RandomInt(1, 10000)
			if randomBonus <= goldAmount%10000 then
				stackLevel = stackLevel + 1
			end 
			PlayerResource:SpendGold(hero:GetPlayerOwnerID(), goldAmount, 0)
			Arena:SpawnKarhzun(stackLevel)
		end
	end
end

function Arena:SpawnKarhzun(stackLevel)
	local position = Vector(-11904, 14848)
	ScreenShake(position, 500, 1, 1, 9000, 0, true)
	local gardiner = Arena:SpawnDungeonUnit("arena_conquest_gift_of_kharzun", position, 2, 5, nil, RandomVector(1), true)
	gardiner.type = ENEMY_TYPE_MINI_BOSS
	gardiner.itemLevel = 125 + stackLevel
	gardiner.stackLevel = stackLevel
	EmitSoundOn("Arena.Karzhun.Entry", gardiner)
	Events:AdjustBossPower(gardiner, 10+stackLevel*2, 10+stackLevel*2, false)
	gardiner:SetAbsOrigin(gardiner:GetAbsOrigin()+Vector(0,0,1000))
	WallPhysics:Jump(gardiner, Vector(0,1), 0, 0, 10, 1.2)
	gardiner.jumpEnd = "cloudburst"
	local ability = gardiner:FindAbilityByName("arena_conquest_karzhun_gift_passive")
	ability:ApplyDataDrivenModifier(gardiner, gardiner, "modifier_kharzun_buff", {})
	gardiner:SetModifierStackCount("modifier_kharzun_buff", gardiner, stackLevel)
	gardiner:SetModelScale(1.0 + stackLevel/10)
end

function Arena:SpawnTempleExplorier(position, fv)
	local fish = Arena:SpawnDungeonUnit("arena_pit_conquest_temple_explorer", position, 2, 5, "Arena.TempleExplorer.Aggro", fv, true)
	fish:SetAbsOrigin(position)
	EmitSoundOn("Arena.CheepJump", fish)
	Events:AdjustBossPower(fish, 10, 10, false)
	local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, fish)
    for j = 0, 4, 1 do
    	ParticleManager:SetParticleControl(pfx,j,fish:GetAbsOrigin() )
	end
    Timers:CreateTimer(1, function()
    	ParticleManager:DestroyParticle(pfx, false)
    end)
    fish:SetRenderColor(69, 255, 69)
	StartAnimation(fish, {duration=3, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.9})
	WallPhysics:Jump(fish, fv, 19, 25, 24, 1)
	fish.itemLevel = 105
	fish.targetRadius = 1000
	fish.autoAbilityCD = 2
	fish.dominion = true
end

function Arena:ArenaConquestTemple()
	Arena:SpawnTempleExplorier(Vector(-14208, 14783, 192), Vector(0,1))
	Arena:SpawnRuinsShaman(Vector(-14833, 14558), Vector(0,1))
	Timers:CreateTimer(4, function()
		local vectorTable = {Vector(-15499, 13649), Vector(-15286, 13493), Vector(-14927, 13281), Vector(-14672, 13281)}
		for i = 1, #vectorTable, 1 do
			local fv = (Vector(-14912, 14016) - vectorTable[i]):Normalized()
			Arena:SpawnTempleWitchDoctor(vectorTable[i], fv)
		end
		local fv = (Vector(-14912, 14016) - Vector(-15316, 13312)):Normalized()
		Arena:SpawnTempleWitchDoctorElite(Vector(-15316, 13312), fv)
		if Arena.PitLevel >= 5 then
			local fv = (Vector(-14912, 14016) - Vector(-15680, 13184)):Normalized()
			Arena:SpawnTempleWitchDoctorElite(Vector(-15680, 13184), fv)
		end
	end)
	Timers:CreateTimer(6, function()
		if Arena.PitLevel >= 6 then
			Arena:SpawnSpiritOfRakash(Vector(-15063, 10650), Vector(-1,1))
		end
	end)
	Timers:CreateTimer(12, function()
		local vectorTable = {Vector(-15872, 11456), Vector(-15872, 11968), Vector(-15360, 11968), Vector(-14912, 12032), Vector(-14912, 12544)}
		for i = 1, #vectorTable, 1 do
			local fv = RandomVector(1)
			Arena:SpawnTempleRepeller(vectorTable[i], fv)
		end
	end)
	Timers:CreateTimer(20, function()
		local vectorTable = {Vector(-15680, 12160), Vector(-15232, 12160), Vector(-15552, 11008), Vector(-15249, 11008), Vector(-14912, 11008)}
		for i = 1, #vectorTable, 1 do
			local fv = Vector(0,1)
			Arena:SpawnTempleHunter(vectorTable[i], fv)
		end

	end)

	Timers:CreateTimer(5, function()
		local shield = CreateUnitByName("npc_flying_dummy_vision", Vector(-15518.7, 12540.2, 100), false, nil, nil, DOTA_TEAM_NEUTRALS)
		shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
		shield:SetOriginalModel("models/arena_conquest_switch.vmdl")
		shield:SetModel("models/arena_conquest_switch.vmdl")
		Timers:CreateTimer(0.05, function()
			shield:SetAbsOrigin(Vector(-15518.7, 12540.2, 100))
		end)
		shield.type = "temple_switch"
		shield:AddAbility("arena_conquest_attackable_unit"):SetLevel(1)
		shield:RemoveAbility("dummy_unit")
		shield:RemoveModifierByName("dummy_unit")
	end)
end

function Arena:SpawnRuinsShaman(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_temple_shaman", position, 3, 5, "Arena.TempleShaman.Aggro", fv, false)
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 120
	return stone
end

function Arena:SpawnRuinsWard(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_temple_guardian_snakes", position, 0, 1, nil, fv, false)
	stone.itemLevel = 110
	stone.dominion = true
	return stone
end


function Arena:SpawnTempleWitchDoctor(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_conquest_temple_witch_doctor", position, 1, 2, "Arena.TempleDoc.Aggro", fv, false)
	Events:AdjustBossPower(stone,2,2,false)
	stone.itemLevel = 110
	stone.dominion = true
	return stone
end

function Arena:SpawnTempleWitchDoctorElite(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_conquest_temple_witch_doctor", position, 2, 4, "Arena.TempleDocBig.Aggro", fv, false)
	Events:AdjustBossPower(stone,14,14,false)
	stone:SetModelScale(1.75)
	local restoration = stone:AddAbility("arena_conquest_voodoo_restoration")
	restoration:SetLevel(3)
	Timers:CreateTimer(1, function()
		-- local newOrder = {
	 -- 		UnitIndex = stone:entindex(), 
	 -- 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
	 -- 		AbilityIndex = restoration:entindex(),
	 -- 	}
	 restoration:ToggleAbility()
 	end)
	 
	ExecuteOrderFromTable(newOrder)			
	stone.itemLevel = 120
	stone.dominion = true
	return stone
end

function Arena:SpawnTempleRepeller(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_conquest_temple_repeller", position, 2, 4, "Arena.TempleRepeller.Aggro", fv, false)
	Events:AdjustBossPower(stone,8,8,false)
	stone.itemLevel = 115
	stone:SetRenderColor(109, 255, 109)
	stone:FindAbilityByName("omniknight_repel"):SetLevel(2)
	stone.dominion = true
	return stone
end

function Arena:SpawnTempleHunter(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_conquest_temple_hunter", position, 2, 4, "Arena.TempleHunter.Aggro", fv, false)
	Events:AdjustBossPower(stone,8,8,false)
	stone.itemLevel = 115
	stone:SetRenderColor(109, 109, 109)
	stone.dominion = true
	return stone
end

function Arena:OpenTempleWall()
	Timers:CreateTimer(1, function()
		local wall = Entities:FindByNameNearest("ArenaConquestWall", Vector(-15872, 10447, 22), 500)
		Arena:PitWall(false, {wall}, true, 4.6)
		Timers:CreateTimer(4.2, function()
			local blockers = Entities:FindAllByNameWithin("ArenaConquestBlocker", Vector(-15872, 10453, 256), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end)	
	local stone1 = Arena:SpawnTempleSkeletonMage(Vector(-15936, 9344), Vector(1,0))
	local stone2 = Arena:SpawnQuizmaster(Vector(-15744, 9344), Vector(1,0))
	local patrolTable = {Vector(-15360, 7296), Vector(-15744, 9344)}
	Arena:AddPatrolArguments(stone1, 0, 6, 320, patrolTable)
	Arena:AddPatrolArguments(stone2, 0, 6, 320, patrolTable)

	local stone11 = Arena:SpawnTempleSkeletonMage(Vector(-15360, 7296), Vector(1,0))
	local stone21 = Arena:SpawnQuizmaster(Vector(-15744, 7232), Vector(1,0))
	local stone31 = Arena:SpawnTempleSkeletonMage(Vector(-15296, 7104), Vector(1,0))
	local patrolTable = {Vector(-15744, 9344), Vector(-15360, 7296)}
	Arena:AddPatrolArguments(stone11, 0, 6, 320, patrolTable)
	Arena:AddPatrolArguments(stone21, 0, 6, 320, patrolTable)
	Arena:AddPatrolArguments(stone31, 0, 6, 320, patrolTable)

	Timers:CreateTimer(6, function()
		Arena:SpawnTempleRepeller(Vector(-14612, 8314), Vector(0,1))
		Arena:SpawnTempleRepeller(Vector(-14400, 8384), Vector(0.3,1))
		Arena:SpawnTempleWitchDoctor(Vector(-14656, 8512), Vector(0.3, 1))
		Arena:SpawnTempleWitchDoctor(Vector(-14400, 8576), Vector(0.7, 1))
		Arena:SpawnTempleWitchDoctor(Vector(-14592, 8768), Vector(1, 1))
	end)
	Timers:CreateTimer(12, function()
		Arena:SpawnMoutaninBehemoth(Vector(-15616, 6656), Vector(0,1))
		Arena:SpawnTempleHunter(Vector(-15616, 7616), Vector(0,1))
		Arena:SpawnTempleHunter(Vector(-15168, 7616), Vector(0,1))
	end)
end

function Arena:SpawnTempleSpider(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_spider", position, 0, 2, nil, fv, true)
	stone:SetRenderColor(160,120,110)
	stone:SetModelScale(0.7)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 98
	stone.dominion = true
	return stone
end

function Arena:SpawnTempleSkeletonMage(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_conquest_skeletal_mage", position, 2, 3, nil, fv, false)
	stone:SetRenderColor(220,220,220)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 105
	stone.dominion = true
	return stone
end

function Arena:SpawnTempleLeshrac(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_conquest_temple_shifter", position, 0, 2, nil, fv, true)
	stone:SetRenderColor(220,220,220)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 108
	stone.dominion = true
	return stone
end

function Arena:ConquestTemplePart3()
	Arena:SpawnConquestDragon(Vector(-12608, 4459), Vector(0,1))
	if Arena.PitLevel > 5 then
		Arena:SpawnConquestDragon(Vector(-12398, 4318), Vector(0,1))
	end
	Arena:SpawnRootOvergrowth(Vector(-12927, 3136), Vector(0,1))
	Timers:CreateTimer(4, function()
		local vectorTable = {Vector(-13056, 3693), Vector(-12800, 3776), Vector(-12544, 3680), Vector(-12544, 3533), Vector(-12800, 3533), Vector(-12685, 3328)}
		local lookPosition = Vector(-12544, 4544)
		for i = 1, #vectorTable, 1 do
			local fv = (lookPosition - vectorTable[i]):Normalized()
			Arena:SpawnGoremawFlamespitter(vectorTable[i], fv)
		end
	end)
	Timers:CreateTimer(6, function()
		Arena:SpawnCragnataur(Vector(-13824, 2816), Vector(1,1))
		Arena:SpawnMireBoss(Vector(-15175, 2112), Vector(1,0.3))
		Arena:SpawnRootOvergrowth(Vector(-15296, 2432), Vector(1,1))
		Arena:SpawnRootOvergrowth(Vector(-14848, 1664), Vector(1,1))
		if Arena.PitLevel > 3 then
			Arena:SpawnCragnataur(Vector(-15296, 768), Vector(0,1))
		end
	end)
	Timers:CreateTimer(9, function()
		Arena:SpawnForestTitan(Vector(-15232, -477), Vector(-1,1))
		Arena:SpawnForestTitan(Vector(-14400, -1984), Vector(0,-1))
		for j = 0, 3, 1 do
			for i = 0, 2, 1 do
				Arena:SpawnForestSoldier(Vector(-15252, -1792)+Vector(130*i, -130*j), Vector(1,0), false)
			end
		end
	end)
	Timers:CreateTimer(12, function()
		Arena:SpawnMireBoss(Vector(-14848, -3264), Vector(0,1))
		Arena:SpawnMireBoss(Vector(-14878, -3904), Vector(0.2,1))
		Arena:SpawnMireKeeper(Vector(-14824, -3584), Vector(0.1,1))
		Arena:SpawnMireKeeper(Vector(-14656, -3392), Vector(1,0))
		Arena:SpawnMireKeeper(Vector(-14976, -3328), Vector(1,1))
		Arena:SpawnForestTitan(Vector(-14848, -4928), Vector(0,1))
	end)
	Timers:CreateTimer(15, function()
		Arena:SpawnForestMage(Vector(-15168, -5184), Vector(1,1))
		Arena:SpawnForestMage(Vector(-14912, -5376), Vector(-0.6,1))
		Arena:SpawnForestMage(Vector(-15296, -5504), Vector(0.5,1))
		Arena:SpawnForestMage(Vector(-14912, -6016), Vector(-0.3,1))
		if Arena.PitLevel > 5 then
			Arena:SpawnForestMage(Vector(-14912, -6016), Vector(-0.3,1))
			Arena:SpawnForestMage(Vector(-14912, -6016), Vector(-0.3,1))
			Arena:SpawnMireBoss(Vector(-15360, -5504), Vector(1,1))
		end
	end)
	Timers:CreateTimer(18, function()
		Arena:SpawnLordOfBovel(Vector(-15168, -7616), Vector(0,1))
	end)
	Timers:CreateTimer(5, function()
		local shield = CreateUnitByName("dummy_unit_vulnerable_with_animations", Vector(-14848, -307, 0), false, nil, nil, DOTA_TEAM_NEUTRALS)
		shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
		shield:SetAbsOrigin(Vector(-14848, -307, 0))
		shield:SetOriginalModel("models/items/wards/esp_eye_of_thunderkeg/esp_eye_of_thunderkeg.vmdl")
		shield:SetModel("models/items/wards/esp_eye_of_thunderkeg/esp_eye_of_thunderkeg.vmdl")
		shield:SetRenderColor(70, 255, 234)
		shield:SetModelScale(5.0)
		shield:AddAbility("arena_conquest_attackable_unit"):SetLevel(1)
		shield:RemoveAbility("dummy_unit")
		shield:RemoveModifierByName("dummy_unit")
		shield:SetForwardVector(Vector(-1,-1))
		shield.type = "forest_ward"
	end)
end

function Arena:ColorWearables(unit, color)
	for k, v in pairs(unit:GetChildren()) do 
		if v:GetClassname() == "dota_item_wearable" then
			local model = v:GetModelName()
			v:SetRenderColor(color[1], color[2], color[3])
		end 
	end 
end

function Arena:SpawnConquestDragon(position, fv)
	local stone = Arena:SpawnDungeonUnit("pit_conquest_dragon", position, 2, 3, "Arena.TempleDragon.Aggro", fv, false)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(0, 200,0))
	Events:AdjustBossPower(stone, 13, 13, false)
	stone.itemLevel = 118
	stone.targetRadius = 530
	stone.minRadius	= 0
	stone.targetAbilityCD = 1
	stone.targetFindOrder = FIND_ANY_ORDER
	stone.dominion = true
	return stone
end

function Arena:SpawnGoremawFlamespitter(position, fv)
	local stone = Arena:SpawnDungeonUnit("terrasic_goremaw_flame_splitter", position, 1, 2, "Arena.FlameSpitter.Aggro", fv, false)
	stone:SetRenderColor(255,120,70)
	Events:AdjustBossPower(stone, 8, 8, false)
	stone.itemLevel = 100
	stone.targetRadius = 400
	stone.autoAbilityCD = 1.5
	stone.dominion = true
	return stone
end

function Arena:SpawnMireBoss(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_mire_boss", position, 2, 4, "Arena.MireBoss.Aggro", fv, false)
	stone:SetRenderColor(180,180,140)
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 106
	Arena:SetPositionCastArgs(stone, 700, 0, 1, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Arena:SpawnForestTitan(position, fv)
	local stone = Arena:SpawnDungeonUnit("pit_conquest_woods_titan", position, 2, 5, "Arena.AncientAggro", fv, false)
	stone:SetRenderColor(255,175,96)
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 110
	Arena:SetPositionCastArgs(stone, 1000, 0, 1, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Arena:SpawnForestSoldier(position, fv, bAggro)
	local stone = Arena:SpawnDungeonUnit("pit_conquest_forest_soldier", position, 0, 2, "Arena.ForestSoldierAggro", fv, bAggro)
	stone:SetRenderColor(255,175,96)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 98
	stone.dominion = true
	return stone
end

function Arena:SpawnForestMage(position, fv)
	local stone = Arena:SpawnDungeonUnit("pit_conquest_forest_mage", position, 1, 3, "Arena.ForestMageAggro", fv, false)
	stone:SetRenderColor(255,175,96)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	stone.targetRadius = 630
	stone.minRadius	= 0
	stone.targetAbilityCD = 1
	stone.targetFindOrder = FIND_ANY_ORDER
	stone.dominion = true
	return stone
end

function Arena:SpawnLordOfBovel(position, fv)
	local stone = Arena:SpawnDungeonUnit("pit_conquest_lord_of_bovel", position, 3, 5, "Arena.BovelAggro", fv, false)
	stone:SetRenderColor(150,150,150)
	Arena:ColorWearables(stone, Vector(150,150,150))
	Events:AdjustBossPower(stone, 13, 13, false)
	stone.itemLevel = 110
	return stone
end

function Arena:SpawnConquestBoss()
	 if not Arena.ConquestOpen then
	 	return
	 end
     local boss = CreateUnitByName("pit_conquest_boss", Vector(-14826, -16121, 950), true, nil, nil, DOTA_TEAM_NEUTRALS)
	 boss.type = ENEMY_TYPE_BOSS
     boss:SetAbsOrigin(Vector(-14826, -16121, 950))
     local bossAbility = boss:FindAbilityByName("conquest_boss_ai")
     bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_conquest_boss_entering", {duration = 10})
     Arena:AddPitToUnit(boss)
     Events:AdjustDeathXP(boss)
     Events:AdjustBossPower(boss, 16, 16, true)
     local targetPosition = Vector(-14835, -14600, 280)
     boss.moveVector = (targetPosition - boss:GetAbsOrigin())/90
     boss.targetPosition = targetPosition
     boss:SetForwardVector(Vector(0,1))
     boss:SetRenderColor(30, 30, 30)
     boss:AddAbility("boss_health"):SetLevel(1)
     AddFOWViewer(DOTA_TEAM_GOODGUYS, targetPosition, 1500, 1500, false)
     Arena:ColorWearables(boss, Vector(30,30,30))

     Timers:CreateTimer(1.0, function()
     	EmitSoundOnLocationWithCaster(targetPosition, "Arena.ConquestBossEnter", Arena.ArenaMaster)
     end)
     Timers:CreateTimer(2.5, function()
     	EmitSoundOnLocationWithCaster(targetPosition, "Arena.PitOfTrials.MusicHighlight", Arena.ArenaMaster)
     	bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_conquest_boss_ai", {})
     end)
     Timers:CreateTimer(4.0, function()
     	Arena:ConquestBossMoveStaffs(true, nil, nil, boss)
     end)
end

function Arena:ConquestBossMoveStaffs(bInit, staff1, staff2, boss)
	if bInit then
		
		boss.staff1 = CreateUnitByName("dummy_unit_vulnerable_with_animations", Vector(-15790, -14766, 550), false, nil, nil, DOTA_TEAM_GOODGUYS)
		boss.staff2 = CreateUnitByName("dummy_unit_vulnerable_with_animations", Vector(-13824, -14766, 550), false, nil, nil, DOTA_TEAM_GOODGUYS)
		local staffTable = {boss.staff1, boss.staff2}
		for i = 1, #staffTable, 1 do
			local staff = staffTable[i]
			local dummyAbility = staff:AddAbility("dummy_unit_cant_die_no_magic_no_attack")
			dummyAbility:SetLevel(1)
			dummyAbility:ApplyDataDrivenModifier(staff, staff, "dummy_unit_vulnerable", {})
			staff:AddAbility("conquest_boss_staff_ability"):SetLevel(1)
			staff.boss = boss
			staff:SetDayTimeVisionRange(500)
			staff:SetNightTimeVisionRange(500)
			staff:SetModelScale(1.3)
		end
		boss.staff1:SetModel("models/items/furion/staff_eagle_1.vmdl")
		boss.staff1:SetOriginalModel("models/items/furion/staff_eagle_1.vmdl")
		boss.staff2:SetModel("models/items/leshrac/tormented_staff/tormented_staff.vmdl")
		boss.staff2:SetOriginalModel("models/items/leshrac/tormented_staff/tormented_staff.vmdl")
		boss.staff2:SetRenderColor(60, 60, 60)
		
		local staffAbility = boss.staff1:FindAbilityByName("conquest_boss_staff_ability")
		staffAbility:ApplyDataDrivenModifier(boss.staff1, boss.staff1, "modifier_conquest_boss_staff_white", {})
		staffAbility = boss.staff2:FindAbilityByName("conquest_boss_staff_ability")
		staffAbility:ApplyDataDrivenModifier(boss.staff2, boss.staff2, "modifier_conquest_boss_staff_black", {})
	end
	local positionsTable = {Vector(-15790, -14766, 550), Vector(-15448, -13312, 550), Vector(-14188, -13288, 550), Vector(-13824, -14766, 550), Vector(-14832, -15680, 550)}
	local rand1 = RandomInt(1, #positionsTable)
	local rand2 = rand1
	while rand2 == rand1 do
		rand2 = RandomInt(1, #positionsTable)
	end
	-- AddFOWViewer(DOTA_TEAM_GOODGUYS, positionsTable[rand1], 300, 300, false)
	-- AddFOWViewer(DOTA_TEAM_GOODGUYS, positionsTable[rand2], 300, 300, false)
	boss.staff1:SetAbsOrigin(positionsTable[rand1])
	boss.staff2:SetAbsOrigin(positionsTable[rand2])

	local particleName = "particles/econ/items/weaver/weaver_immortal_ti6/weaver_immortal_ti6_shukuchi_portal.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, boss.staff1 )
	ParticleManager:SetParticleControl( particle1, 0, boss.staff1:GetAbsOrigin()+Vector(0,0,180) )
	Timers:CreateTimer(3, 
	function()
		ParticleManager:DestroyParticle( particle1, false )
	end)
	local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, boss.staff2 )
	ParticleManager:SetParticleControl( particle1, 0, boss.staff2:GetAbsOrigin()+Vector(0,0,180) )
	Timers:CreateTimer(3, 
	function()
		ParticleManager:DestroyParticle( particle2, false )
	end)
end

function Arena:LiesRoom1()
	local bridge = Entities:FindByNameNearest("ArenaLiesBridge", Vector(-207, 15606, 128+Arena.ZFLOAT), 800)
	bridge:SetAbsOrigin(bridge:GetAbsOrigin()-Vector(0,0,2000))
	Arena.bridge1 = bridge
	Arena:SpawnDustDispenser(Vector(-2449, 12416), Vector(1,0))
	Arena.DustTable = {}
	local spikes = Entities:FindAllByNameWithin("LiesSpikes", Vector(-3008, 14016, 448+Arena.ZFLOAT), 3800)
	for i = 1, #spikes, 1 do
		spikes[i]:SetAbsOrigin(spikes[i]:GetAbsOrigin()-Vector(0,0,1000))
	end
	Timers:CreateTimer(2, function()
		Arena:SpawnLiesBeetle(Vector(-1920, 13632), Vector(-0.4, -1))
		Arena:SpawnLiesBeetle(Vector(-2304, 13888), Vector(0, -1))
		Arena:SpawnLiesBeetle(Vector(-3008, 13824), Vector(1, 0))
		Arena:SpawnLiesBeetle(Vector(-3072, 13376), Vector(1, 0))
		if Arena.PitLevel > 2 then
			Arena:SpawnLiesBeetle(Vector(-3648, 13568), Vector(1, 0))
		end
		if Arena.PitLevel > 4 then
			Arena:SpawnLiesBeetle(Vector(-3551, 14073), Vector(1, -0.3))
		end
	end)
	Timers:CreateTimer(4, function()
		Arena:SpawnLiesLich(Vector(-3520, 14400), Vector(0,-1))
		Arena:SpawnLiesLich(Vector(-3712, 15424), Vector(0.2,-1))
		if Arena.PitLevel > 3 then
			Arena:SpawnLiesLich(Vector(-3600, 14912), Vector(0, -1))
		end
		if Arena.PitLevel > 5 then
			Arena:SpawnLiesBeetle(Vector(-3392, 15488), Vector(1, -0.3))
		end
		Arena:SpawnDustDispenser(Vector(-2816, 15680), Vector(0,-1))
		Arena:SpawnLiesDoombringer(Vector(-1344, 15616), Vector(-1,0))
	end)
	Timers:CreateTimer(5, function()
		local bridge = Entities:FindByNameNearest("ArenaLiesBridge", Vector(999, 13561, 128+Arena.ZFLOAT), 800)
		bridge:SetAbsOrigin(bridge:GetAbsOrigin()-Vector(0,0,2000))
		local spikes = Entities:FindAllByNameWithin("LiesSpikes", Vector(1920, 12633, 128+Arena.ZFLOAT), 2500)
		for i = 1, #spikes, 1 do
			spikes[i]:SetAbsOrigin(spikes[i]:GetAbsOrigin()-Vector(0,0,1000))
		end
		local bridge2 = Entities:FindByNameNearest("ArenaLiesBridge2", Vector(3713, 15393, 138+Arena.ZFLOAT), 1000)
		bridge2:SetAbsOrigin(bridge2:GetAbsOrigin()-Vector(0,0,2000))
		Arena.arbiterBridge = bridge2

		local bridge3 = Entities:FindByNameNearest("ArenaLiesBridge", Vector(3843, 12700, 138+Arena.ZFLOAT), 1000)
		bridge3:SetAbsOrigin(bridge3:GetAbsOrigin()-Vector(0,0,2000))

		local bridge4 = Entities:FindByNameNearest("ArenaLiesBridge", Vector(8936, 12405, 136+Arena.ZFLOAT), 1000)
		bridge4:SetAbsOrigin(bridge4:GetAbsOrigin()-Vector(0,0,2000))

		local bridge5 = Entities:FindByNameNearest("ArenaLiesBridge", Vector(11262, 13606, 136+Arena.ZFLOAT), 1000)
		bridge5:SetAbsOrigin(bridge5:GetAbsOrigin()-Vector(0,0,2000))

		local bridge6 = Entities:FindByNameNearest("ArenaLiesBridge", Vector(12298, 15375, 136+Arena.ZFLOAT), 1000)
		bridge6:SetAbsOrigin(bridge6:GetAbsOrigin()-Vector(0,0,2000))

		local bridge7 = Entities:FindByNameNearest("ArenaLiesBridge2", Vector(13459, 11887, 136+Arena.ZFLOAT), 1000)
		bridge7:SetAbsOrigin(bridge7:GetAbsOrigin()-Vector(0,0,2000))
		Arena.NumbersBridge = bridge7

		local bridge8 = Entities:FindByNameNearest("ArenaLiesBridge", Vector(14076, 7780, 126+Arena.ZFLOAT), 1000)
		bridge8:SetAbsOrigin(bridge8:GetAbsOrigin()-Vector(0,0,2000))

		local bridge9 = Entities:FindByNameNearest("ArenaLiesBridge", Vector(14079, 5376, 110+Arena.ZFLOAT), 1000)
		bridge9:SetAbsOrigin(bridge9:GetAbsOrigin()-Vector(0,0,2000))
	end)
end

function Arena:SpawnDustDispenser(position, fv)
	local shield = CreateUnitByName("dummy_unit_vulnerable_with_animations", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
	-- shield:SetAbsOrigin(position)
	shield:SetOriginalModel("models/items/wards/winged_watcher/winged_watcher.vmdl")
	shield:SetModel("models/items/wards/winged_watcher/winged_watcher.vmdl")
	shield:SetModelScale(2.2)
	shield:AddAbility("arena_conquest_attackable_unit_no_effect"):SetLevel(1)
	shield:RemoveAbility("dummy_unit")
	shield:RemoveModifierByName("dummy_unit")
	shield:SetForwardVector(fv)
	shield.type = "dust_dispenser"
	StartAnimation(shield, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
end

function Arena:SpawnLiesBeetle(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_spark_beetle", position, 1, 3, "Arena.LiesBeetle.Aggro", fv, false)
	-- stone:SetRenderColor(150,150,150)
	-- Arena:ColorWearables(stone, Vector(150,150,150))
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 110
	stone.dominion = true
	return stone
end

function Arena:SpawnLiesLich(position, fv)
	local stone = Arena:SpawnDungeonUnit( "arena_lies_lich", position, 2, 3, "Arena.LiesLich.Aggro", fv, false)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	Events:AdjustBossPower(stone, 8, 8, false)
	stone.itemLevel = 114
	stone.dominion = true
	return stone
end

function Arena:SpawnLiesDoombringer(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_doombringer", position, 3, 6, "Arena.LiesDoom.Aggro", fv, false)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	Events:AdjustBossPower(stone, 8, 8, false)
	stone.itemLevel = 114
	stone.targetRadius = 700
	stone.autoAbilityCD = 3
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:LiesRoom2()
	Arena:SpawnLiesOgre(Vector(1152, 14720), Vector(0,1))
	Arena:SpawnLiesOgre(Vector(1984, 15552), Vector(-1,0))
	Arena:SpawnLiesOgre(Vector(2406, 14813), Vector(-1,1))
	if Arena.PitLevel > 4 then
		Arena:SpawnLiesOgre(Vector(1856, 14336), Vector(-0.3,1))
	end
	Timers:CreateTimer(3, function()
		Arena:SpawnLiesBeetle(Vector(2432, 12672), Vector(-1,0))
		Arena:SpawnLiesBeetle(Vector(1792, 12288), Vector(-0.8,1))
		Arena:SpawnLiesSamurai(Vector(1024, 12544), Vector(0,1))
		Arena:SpawnDustDispenser(Vector(1280, 15872), Vector(0,-1))
	end)
end

function Arena:SpawnLiesOgre(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_supreme_ogre", position, 2, 3, "Arena.LiesOgre.Aggro", fv, false)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 114
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnLiesTrueOgre(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_true_ogre", position, 2, 3, "Arena.LiesTrueOgre.Aggro", fv, false)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnLiesSamurai(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_samurai", position, 2, 3, "Arena.LiesSamurai.Aggro", fv, false)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	stone.dominion = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnArbiterOfTruth(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_arbiter_of_truth", position, 3, 4, "Arena.LiesArbiter.Aggro", fv, true)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	stone.dominion = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnLiesTreasureRoom()
	Arena:SpawnGoldenSkullbone(Vector(5118, 15503), Vector(-1,0))
	Arena:SpawnGoldenSkullbone(Vector(5118, 15071), Vector(-1,0))
	Arena:SpawnGoldenSkullbone(Vector(5438, 15295), Vector(-1,0))
	Arena:SpawnTreasureBird(Vector(5936, 15296), Vector(-1,0))
end

function Arena:SpawnGoldenSkullbone(position, fv)
	local stone = Arena:SpawnDungeonUnit("lies_golden_skullbone", position, 3, 4, "Arena.LiesSkullBone.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 110
	stone.dominion = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnTreasureBird(position, fv)
	local stone = Arena:SpawnDungeonUnit("lies_treasure_hoarder", position, 3, 4, "Arena.LiesTreasureBird.Aggro", fv, false)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnLiesShadowBeast(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_shadow_beast", position, 1, 2, "Arena.LiesShadowBeast.Aggro", fv, false)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	local smokeAbility = stone:FindAbilityByName("lies_smoke_cloud_ability")
	smokeAbility:ApplyDataDrivenModifier(stone, stone, "modifier_lies_smoke_cloud_base", {})
	smokeAbility:ApplyDataDrivenModifier(stone, stone, "modifier_lies_smoke_cloud_invis", {})
	stone.smoke = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnFireTempleShadow(position, fv)
	local stone = Arena:SpawnDungeonUnit("fire_temple_relic_seeker", position, 2, 4, "Arena.FireTemple.RelicSeekerAggro", fv, false)
	stone:SetRenderColor(255,120,100)
	Events:AdjustBossPower(stone, 6, 6, false)
	stone.itemLevel = 100
	stone.dominion = true
	return stone
end

function Arena:SpawnLiesArea3()
	Arena:SpawnDustDispenser(Vector(4928, 12864), Vector(0,-1))
	local stone1 = Arena:SpawnLiesShadowBeast(Vector(5184, 12426), Vector(1,0))
	local patrolTable = {Vector(8256, 11520), Vector(5184, 12426)}
	Arena:AddPatrolArguments(stone1, 4, 6, 320, patrolTable)

	local stone1 = Arena:SpawnLiesShadowBeast(Vector(8256, 11520), Vector(-1,0))
	local stone2 = Arena:SpawnLiesShadowBeast(Vector(8384, 11392), Vector(-1,0))
	local patrolTable = {Vector(5184, 12426), Vector(8256, 11520)}
	Arena:AddPatrolArguments(stone1, 4, 6, 320, patrolTable)
	Arena:AddPatrolArguments(stone2, 4, 6, 320, patrolTable)

	local stone1 = Arena:SpawnLiesShadowBeast(Vector(5888, 11584), Vector(-1,0))
	local stone2 = Arena:SpawnLiesShadowBeast(Vector(5760, 11392), Vector(-1,0))
	local patrolTable = {Vector(8512, 11200), Vector(5888, 11584)}
	Arena:AddPatrolArguments(stone1, 5, 6, 320, patrolTable)
	Arena:AddPatrolArguments(stone2, 5, 6, 320, patrolTable)
	Timers:CreateTimer(3, function()
		Arena:SpawnFireTempleShadow(Vector(7168, 11328), Vector(-1,0))
		Arena:SpawnFireTempleShadow(Vector(7360, 11587), Vector(-1,0))
		Arena:SpawnFireTempleShadow(Vector(7493, 11423), Vector(-1,0))

		Arena:SpawnLiesShadowBeast(Vector(8832, 11456), Vector(-1,0))
		Arena:SpawnLiesShadowBeast(Vector(8948, 11392), Vector(0,1))
		Arena:SpawnLiesShadowBeast(Vector(9088, 11456), Vector(-1,0.3))

		Arena:SpawnLiesSamurai(Vector(8960, 12416), Vector(0,-1))
	end)
end

function Arena:SpawnLiesArea4()
	Arena.LiesLibrarySwitch = Entities:FindByNameNearest("LiesSwitchRevealable", Vector(8624, 13645, 30+Arena.ZFLOAT), 1000)
	Arena.LiesLibrarySwitch:SetAbsOrigin(Arena.LiesLibrarySwitch:GetAbsOrigin()-Vector(0,0,1000))
	Arena.LiesLibrarySwitch:Attribute_SetIntValue("pressed", 0)

	Arena:SpawnLiesTrickster(Vector(9408, 13440), Vector(-1,-1))
	Arena:SpawnLiesTrickster(Vector(9856, 13248), Vector(-1,0))
	Arena:SpawnLiesTrickster(Vector(9884, 13824), Vector(0,-1))
	if Arena.PitLevel > 4 then
		Arena:SpawnLiesTrickster(Vector(10225, 13476), Vector(-1,0))
	end
end

function Arena:LiesRoom5()
	Arena:SetUpNumbersPuzzle()
	Timers:CreateTimer(8, function()
		Arena:SpawnDustDispenser(Vector(10880, 15098), Vector(0,1))
		Arena:SpawnLiesPudge(Vector(10560, 15232), Vector(1,0))
		Arena:SpawnLiesPudge(Vector(10240, 15272), Vector(1,0))
	end)
	Timers:CreateTimer(0.5, function()
		Arena:SpawnLiesPudge(Vector(9630, 15232), Vector(1,0))
		if Arena.PitLevel > 4 then
			Arena:SpawnLiesPudge(Vector(9408, 15758), Vector(1,-1))
		end
	end)
	Timers:CreateTimer(1, function()
		Arena:SpawnLiesPudge(Vector(9984, 15656), Vector(1,-1))
	end)
	if Arena.PitLevel > 3 then
		Arena:SpawnLiesPudge(Vector(11254, 15784), Vector(1,-1))
	end
	Timers:CreateTimer(3, function()
		if Arena.PitLevel > 5 then
			Arena:SpawnLiesTricksterWithSmoke(Vector(9752, 15487), Vector(1,0))
		end
		Arena:SpawnLiesTricksterWithSmoke(Vector(9640, 15751), Vector(1,-1))
		Arena:SpawnLiesTricksterWithSmoke(Vector(10013, 15134), Vector(1,1))
		Arena:SpawnLiesTricksterWithSmoke(Vector(9261, 15341), Vector(1,0))
		Timers:CreateTimer(2, function()
			Arena:SpawnLiesTricksterWithSmoke(Vector(10688, 15680), Vector(1,-1))
			Arena:SpawnLiesTricksterWithSmoke(Vector(10918, 15189), Vector(1,1))
		end)
	end)
	Timers:CreateTimer(1, function()
		Arena:SpawnLiesOgre(Vector(13568, 15296), Vector(0,-1))
		Arena:SpawnLiesShadowBeast(Vector(12800, 13120), Vector(0,1))
		Arena:SpawnLiesShadowBeast(Vector(13312, 14208), Vector(-1,0))
		local stone1 = Arena:SpawnFireTempleShadow(Vector(13578, 12800), Vector(0,1))
		local stone2 = Arena:SpawnLiesBeetle(Vector(13696, 12864), Vector(-0.4, 1))
		local patrolTable = {Vector(14016, 14528),Vector(13696, 12864)}
		Arena:AddPatrolArguments(stone1, 0, 6, 320, patrolTable)
		Arena:AddPatrolArguments(stone2, 0, 6, 320, patrolTable)
		Arena:SpawnFireTempleShadow(Vector(14592, 14592), Vector(-1,0))
		Arena:SpawnFireTempleShadow(Vector(14272, 14592), Vector(-1,0.3))
		Arena:SpawnFireTempleShadow(Vector(14464, 14336), Vector(-1,-0.6))
	end)
	Timers:CreateTimer(8, function()
		Arena:SpawnLiesLich(Vector(15040, 15296), Vector(0,-1))
		if Arena.PitLevel > 3 then
			Arena:SpawnLiesLich(Vector(14871, 15104), Vector(0,-1))
		end
		if Arena.PitLevel > 4 then
			Arena:SpawnLiesLich(Vector(15158, 15104), Vector(0,-1))
		end
		if Arena.PitLevel > 5 then
			Arena:SpawnLiesLich(Vector(14866, 14912), Vector(0,-1))
		end
		if Arena.PitLevel > 6 then
			Arena:SpawnLiesLich(Vector(15168, 14912), Vector(0,-1))
		end
		local stone1 = Arena:SpawnLiesShadowBeast(Vector(13760, 15104), Vector(0,1))
		local stone2 = Arena:SpawnLiesShadowBeast(Vector(13560, 15104), Vector(0,1))
		local patrolTable = {Vector(13632, 13184), Vector(13760, 15104)}
		Arena:AddPatrolArguments(stone1, 0, 6, 320, patrolTable)
		Arena:AddPatrolArguments(stone2, 0, 6, 320, patrolTable)
	end)
end

function Arena:SpawnLiesTrickster(position, fv)
	local stone = Arena:SpawnDungeonUnit("lies_trickster_mage", position, 2, 4, "Arena.LiesTrickster.Aggro", fv, false)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	stone:SetRenderColor(255,255,80)
	Arena:ColorWearables(stone, Vector(255,255,80))
	stone.dominion = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnLiesPudge(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_test_dummy", position, 1, 4, "Arena.LiesTestDummy.Aggro", fv, false)
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 110
	stone:SetRenderColor(255,255,30)
	Arena:ColorWearables(stone, Vector(255,255,30))

	return stone
end

function Arena:SpawnLiesTricksterWithSmoke(position, fv)
	local stone = Arena:SpawnDungeonUnit("lies_trickster_mage", position, 2, 4, "Arena.LiesTrickster.Aggro", fv, false)
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 110
	stone:SetRenderColor(255,255,80)
	Arena:ColorWearables(stone, Vector(255,255,80))
	local smokeAbility = stone:AddAbility("lies_smoke_cloud_ability")
	smokeAbility:SetLevel(1)
	smokeAbility:ApplyDataDrivenModifier(stone, stone, "modifier_lies_smoke_cloud_base", {})
	smokeAbility:ApplyDataDrivenModifier(stone, stone, "modifier_lies_smoke_cloud_invis", {})
	stone.smoke = true
	return stone
end

function Arena:SpawnBigCaveLizard(position, fv)
	local sapling = Arena:SpawnDungeonUnit("boulderspine_cave_lizard_brute", position, 2, 4, "Arena.Boulderspine.CaveLizardAggro", fv, false)
	sapling.itemLevel = 100
	Events:AdjustBossPower(sapling, 10, 10)
	sapling:SetRenderColor(240, 240, 30)
	sapling.autoAbilityCD = 3
	sapling.targetRadius = 1000
	sapling.dominion = true
	return sapling
end

function Arena:SpawnTrueOgre(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_supreme_ogre_true", position, 3, 5, "Arena.LiesOgre.Aggro", fv, false)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 125
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SetUpNumbersPuzzle()
	Arena.numberPuzzle1 = Entities:FindByNameNearest("LiesNumber", Vector(15083, 15258, 144+Arena.ZFLOAT), 500)
	Arena.numberPuzzle1:Attribute_SetIntValue("nbro", 1)
	Arena.numberPuzzle2 = Entities:FindByNameNearest("LiesNumber", Vector(14528, 14400, 144+Arena.ZFLOAT), 500)
	Arena.numberPuzzle2:Attribute_SetIntValue("nbro", 2)
	Arena.numberPuzzle3 = Entities:FindByNameNearest("LiesNumber", Vector(13294, 14675, 144+Arena.ZFLOAT), 500)
	Arena.numberPuzzle3:Attribute_SetIntValue("nbro", 3)
	Arena.numberPuzzle4 = Entities:FindByNameNearest("LiesNumber", Vector(13504, 13016, 144+Arena.ZFLOAT), 500)
	Arena.numberPuzzle4:Attribute_SetIntValue("nbro", 4)
	local position1 = Arena.numberPuzzle1:GetAbsOrigin()
	local position2 = Arena.numberPuzzle2:GetAbsOrigin()
	local position3 = Arena.numberPuzzle3:GetAbsOrigin()
	local position4 = Arena.numberPuzzle4:GetAbsOrigin()

	Arena.numberSwitch1 = Entities:FindByNameNearest("Lies4Switch", Vector(14945, 15240, 18+Arena.ZFLOAT), 500)
	Arena.numberSwitch2 = Entities:FindByNameNearest("Lies4Switch", Vector(14366, 14416, 18+Arena.ZFLOAT), 500)
	Arena.numberSwitch3 = Entities:FindByNameNearest("Lies4Switch", Vector(13128, 14657, 18+Arena.ZFLOAT), 500)
	Arena.numberSwitch4 = Entities:FindByNameNearest("Lies4Switch", Vector(13376, 12968, 18+Arena.ZFLOAT), 500)

	local numberTable = {Arena.numberPuzzle1, Arena.numberPuzzle2, Arena.numberPuzzle3, Arena.numberPuzzle4}
	Arena.SwitchOrder = Arena:shuffle(numberTable)
	--print(numberTable)

	-- for i = 1, #Arena.SwitchOrder, 1 do
	-- 	if Arena.SwitchOrder[i] == Arena.Switch
	-- end
	Arena.SwitchOrder[1]:SetAbsOrigin(position1-Vector(0,0,1000))
	Arena.SwitchOrder[2]:SetAbsOrigin(position2-Vector(0,0,1000))
	Arena.SwitchOrder[3]:SetAbsOrigin(position3-Vector(0,0,1000))
	Arena.SwitchOrder[4]:SetAbsOrigin(position4-Vector(0,0,1000))

	Arena.SwitchOrderNumber = {Arena.SwitchOrder[1]:Attribute_GetIntValue("nbro", 0), Arena.SwitchOrder[2]:Attribute_GetIntValue("nbro", 0), Arena.SwitchOrder[3]:Attribute_GetIntValue("nbro", 0), Arena.SwitchOrder[4]:Attribute_GetIntValue("nbro", 0)}

	Arena.NumberSwitchTable = {Arena.numberSwitch1, Arena.numberSwitch2, Arena.numberSwitch3, Arena.numberSwitch4}
end


function Arena:swap(array, index1, index2)
    array[index1], array[index2] = array[index2], array[index1]
    return array
end

function Arena:shuffle(array)
    local counter = #array
    while counter > 1 do
        local index = math.random(counter)
        array = Arena:swap(array, index, counter)
        counter = counter - 1
    end
    return array
end

function Arena:CheckSwitchOrderConditions()
	local conditionGood = true
	for i = 1, #Arena.ButtonsPressedTable, 1 do
		--print(Arena.SwitchOrderNumber[Arena.ButtonsPressedTable[i]])
		--print(i)
		----print(Arena.SwitchOrder[i]:Attribute_GetIntValue("nbro", 0))
		if i == Arena.SwitchOrderNumber[Arena.ButtonsPressedTable[i]] then
		else
			conditionGood = false
		end
	end
	if conditionGood then
		if #Arena.ButtonsPressedTable == 4 then
			for j = 1, 200, 1 do
				Timers:CreateTimer(j*0.03, function()
					Arena.NumbersBridge:SetAbsOrigin(Arena.NumbersBridge:GetAbsOrigin()+Vector(0,0,10))
				end)
			end
			Timers:CreateTimer(6, function()
				local blockers = Entities:FindAllByNameWithin("LiesNumberBridgeBlocker", Vector(13356, 11968, 160+Arena.ZFLOAT), 3400)
				for k = 1, #blockers, 1 do
					UTIL_Remove(blockers[k])
				end
				Arena.AllowLiesBoss = true
				Arena:SpawnLies7()
				EmitSoundOnLocationWithCaster(Vector(13356, 11968), "Arena.WaterTemple.SwitchEnd", Arena.ArenaMaster)
			end)
		end
	else
		for i = 1, #Arena.NumberSwitchTable, 1 do
			if Arena.NumberSwitchTable[i]:Attribute_GetIntValue("pressed", 0) == 1 then
				Arena:ActivateSwitchSpecific(Arena.NumberSwitchTable[i], false, 0.28)
				Timers:CreateTimer(2, function()
					Arena.NumberSwitchTable[i]:Attribute_SetIntValue("pressed", 0)
				end)
			end
		end
		Arena.ButtonsPressedTable = {}
	end
end

function Arena:SpawnLies7()
	--MOB IDEA -> Immune to magic, takes 10 attacks to break magic shield
	Arena:SpawnLightAbsorber(Vector(13056, 10816), Vector(1,1))
	Arena:SpawnLightAbsorber(Vector(13096, 10560), Vector(1,1))
	Arena:SpawnLightAbsorber(Vector(13312, 10624), Vector(0,1))
	Arena:SpawnLightAbsorber(Vector(14080, 10771), Vector(-1,0))
	Arena:SpawnLightAbsorber(Vector(14555, 10120), Vector(0,1))
	Timers:CreateTimer(2, function()
		local stone1 = Arena:SpawnLiesShadowBeast(Vector(14144, 9216), Vector(0,1))
		local stone2 = Arena:SpawnLiesShadowBeast(Vector(14208, 9152), Vector(0,1))
		local patrolTable = {Vector(13120, 10752), Vector(14144, 9216)}
		Arena:AddPatrolArguments(stone1, 4, 6, 320, patrolTable)
		Arena:AddPatrolArguments(stone2, 4, 6, 320, patrolTable)
	end)
	Timers:CreateTimer(5, function()
		Arena:SpawnLightEater(Vector(15168, 10688), Vector(-1,0))
		Arena:SpawnLightEater(Vector(14976, 10176), Vector(0,1))
		Arena:SpawnLightEater(Vector(14720, 9728), Vector(0,1))
		Arena:SpawnLightEater(Vector(15360, 9600), Vector(0,1))
	end)
	Timers:CreateTimer(8, function()
		if Arena.PitLevel > 3 then
			Arena:SpawnLightAbsorber(Vector(15040, 9536), Vector(0,1))
			Arena:SpawnLightAbsorber(Vector(14912, 9536), Vector(0,1))
			Arena:SpawnLightAbsorber(Vector(14784, 9536), Vector(0,1))
		end
		if Arena.PitLevel > 5 then
			Arena:SpawnLightAbsorber(Vector(15168, 9744), Vector(0,1))
			Arena:SpawnLightAbsorber(Vector(15310, 9600), Vector(0,1))
		end
	end)
	Arena:SpawnLightAbsorber(Vector(13952, 9088), Vector(1,-1))
	Arena:SpawnLightAbsorber(Vector(14080, 9216), Vector(1,-1))
	Timers:CreateTimer(10, function()
		Arena:SpawnRazorBoss(Vector(14080, 8896), Vector(0,1))
		Arena:SpawnDustDispenser(Vector(14843, 4480), Vector(0,-1))
	end)
	local particleName = "particles/dark_smoke_test.vpcf"
    Arena.smokePFX = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.ArenaMaster)
    ParticleManager:SetParticleControl(Arena.smokePFX,0,Vector(14257, 3504, 193+Arena.ZFLOAT) )
end

function Arena:SpawnLightEater(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_castle_enigma", position, 1, 4, "Arena.LightEater.Aggro", fv, false)

	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 104
	Arena:SetPositionCastArgs(stone, 850, 0, 1, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Arena:SpawnLightAbsorber(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_lies_castle_light_absorber", position, 1, 3, "Arena.LightAbsorber.Aggro", fv, false)

	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 104
	stone.dominion = true
	return stone
end

function Arena:SpawnRazorBoss(position, fv)
	local stone = Arena:SpawnDungeonUnit( "arena_lies_razor_miniboss", position, 2, 4, "Arena.RazorBoss.Aggro", fv, false)
	stone:SetRenderColor(255,255,0)
	Arena:ColorWearables(stone, Vector(255,255,0))
	Events:AdjustBossPower(stone, 13, 13, false)
	stone.itemLevel = 115
	stone.targetRadius = 800
	stone.autoAbilityCD = 2
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnLiesBoss(position)
	 if not Arena.LiesOpen then
	 	return
	 end
	local boss = CreateUnitByName("arena_lies_boss", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	boss.type = ENEMY_TYPE_BOSS
	Arena:AddPitToUnit(boss)
	-- boss:SetAbsOrigin(Vector(-14826, -16121, 950))
	Events:AdjustDeathXP(boss)
	Events:AdjustBossPower(boss, 16, 16, true)
	EmitSoundOn("Arena.LiesBoss.IntroSmoke", boss)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", boss, 3)
	Timers:CreateTimer(1, function()
		EmitSoundOnLocationWithCaster(position, "Arena.LiesBoss.Intro", Arena.ArenaMaster)
	end)
	boss.liesBoss = true
	local shieldAbility = boss:FindAbilityByName("arena_lies_boss_magic_immune_ability")
	shieldAbility:ApplyDataDrivenModifier(boss, boss, "arena_lies_boss_magic_immune_ability", {})
	-- boss:SetRenderColor(255,255,0)
	-- Arena:ColorWearables(boss, Vector(255,255,0))
	boss:AddAbility("boss_health"):SetLevel(1)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 1500, 1500, false)
	local eventTable = {}
	eventTable.caster = boss
	eventTable.ability = boss:FindAbilityByName("arena_lies_boss_illusion_ability")
	for i = 1, Arena.PitLevel, 1 do
		arena_lies_boss_illusion_ability_cast(eventTable)
	end
     Timers:CreateTimer(2.5, function()
     	EmitSoundOnLocationWithCaster(position, "Arena.PitOfTrials.MusicHighlight", Arena.ArenaMaster)
     end)
end

function Arena:DescentRoom1()
	Arena:SpawnExiledSpirit(Vector(2130, 10311), Vector(0,-1), false)
	Arena:SpawnExiledSpirit(Vector(2386, 9646), Vector(1,0), false)
	local vectorTable = {Vector(2990, 9281), Vector(2752, 9280), Vector(2624, 9536), Vector(2368, 9664), Vector(2752, 10304), Vector(2752, 9792), Vector(3008, 9536), Vector(3095, 9856)}
	for i = 1, #vectorTable, 1 do
		Arena:SpawnExiledSpirit(vectorTable[i], RandomVector(1), false)
	end

	Arena:SpawnExiledSpiritHeavy(Vector(2560, 10304), Vector(-1,0))
	Arena:SpawnExiledSpiritHeavy(Vector(3532, 9280), Vector(-1,0))
	Arena:SpawnExiledSpiritHeavy(Vector(4928, 8000), Vector(-1,1))
	Timers:CreateTimer(4, function()
		Arena:SpawnExiledSpiritBig(Vector(4416, 8832), Vector(-1,0))
		Arena:SpawnPassageKeeper(Vector(7680, 8448), Vector(-1,0))
	end)
	Timers:CreateTimer(8, function()
		Arena.widow = Arena:SpawnGrievingWidow(Vector(10624, 8000), Vector(1,0))
		Arena.widowCorpse = CreateUnitByName("npc_dummy_unit", Vector(10874, 7830), false, nil, nil, DOTA_TEAM_GOODGUYS)
		Arena.widowCorpse:SetAbsOrigin(Vector(10874, 7830, 210+Arena.ZFLOAT))
		Arena.widowCorpse:RemoveAbility("dummy_unit")
		Arena.widowCorpse:RemoveModifierByName("dummy_unit")
		Arena.widowCorpse:SetOriginalModel("models/heroes/abaddon/abaddon.vmdl")
		Arena.widowCorpse:SetModel("models/heroes/abaddon/abaddon.vmdl")
		Arena.widowCorpse:SetModelScale(1.2)
		Arena.widowCorpse:SetAngles(-90, 270, 0)
		local corpseAbility = Arena.widowCorpse:AddAbility("arena_descent_corpse_ability")
		corpseAbility:ApplyDataDrivenModifier(Arena.widowCorpse, Arena.widowCorpse, "modifier_corpse_start", {})
		Timers:CreateTimer(1, function()
			corpseAbility:ApplyDataDrivenModifier(Arena.widowCorpse, Arena.widowCorpse, "modifier_corpse_frozen", {})
		end)
		corpseAbility:SetLevel(1)
	end)
	local bridge7 = Entities:FindByNameNearest("DescentBridge", Vector(9664, -3881, 100+Arena.ZFLOAT), 1200)
	bridge7:SetAbsOrigin(bridge7:GetAbsOrigin()-Vector(0,0,300))
	Arena.DescentBridge = bridge7
end

function Arena:SpawnExiledSpirit(position, fv, bAggro)
	local stone = Arena:SpawnDungeonUnit( "arena_descent_exiled_spirit", position, 0, 1, "Arena.Descent.ExiledAggro", fv, bAggro)
	stone:SetRenderColor(40,40,40)
	Arena:ColorWearables(stone, Vector(40,40,40))
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 91
	stone.dominion = true
	return stone
end

function Arena:SpawnSorrowWraith(position, fv, bAggro)
	local stone = Arena:SpawnDungeonUnit( "arena_descent_sorrow_wraith", position, 0, 2, "Arena.Descent.ExiledAggro", fv, bAggro)
	stone:SetRenderColor(40,40,40)
	Arena:ColorWearables(stone, Vector(40,40,40))
	Events:AdjustBossPower(stone, 6, 6, false)
	stone.itemLevel = 97
	stone.dominion = true
	return stone
end

function Arena:SpawnHorrorCOnstruct(position, fv, bAggro)
	local stone = Arena:SpawnDungeonUnit( "arena_descent_horror_construct", position, 0, 2, "Arena.Descent.ExiledAggro", fv, bAggro)
	stone:SetRenderColor(40,40,40)
	Arena:ColorWearables(stone, Vector(40,40,40))
	Events:AdjustBossPower(stone, 7, 7, false)
	stone.itemLevel = 102
	stone.dominion = true
	return stone
end

function Arena:SpawnDeathSeeker(position, fv, bAggro)
	local stone = Arena:SpawnDungeonUnit( "arena_descent_death_seeker", position, 0, 2, "Arena.Descent.ExiledAggro", fv, bAggro)
	stone:SetRenderColor(40,40,40)
	Arena:ColorWearables(stone, Vector(40,40,40))
	Events:AdjustBossPower(stone, 7, 7, false)
	stone.itemLevel = 102
	stone.dominion = true
	return stone
end


function Arena:SpawnExiledSpiritHeavy(position, fv)
	local stone = Arena:SpawnDungeonUnit( "arena_descent_exiled_spirit", position, 2, 4, "Arena.Descent.ExiledAggroHeavy", fv, false)
	stone:AddAbility("arena_descent_crippling"):SetLevel(1)
	stone:SetRenderColor(40,40,40)
	stone:SetModelScale(1.5)
	Arena:ColorWearables(stone, Vector(40,40,40))
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 105
	stone.dominion = true
	return stone
end


function Arena:SpawnExiledSpiritBig(position, fv)
	local stone = Arena:SpawnDungeonUnit(  "arena_descent_exiled_spirit_big", position, 2, 4, "Arena.Descent.ExiledAggroHeavy", fv, false)
	stone:AddAbility("creature_endurance_aura"):SetLevel(1)
	stone:SetRenderColor(40,40,40)
	stone:SetModelScale(1.5)
	Arena:ColorWearables(stone, Vector(40,40,40))
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 105
	stone.dominion = true
	return stone
end

function Arena:SpawnPassageKeeper(position, fv)
	local stone = Arena:SpawnDungeonUnit(  "arena_descent_passage_keeper", position, 2, 4, "Arena.DescentPassageKeeper.Aggro", fv, false)
	stone:SetRenderColor(40,40,40)
	Arena:ColorWearables(stone, Vector(40,40,40))
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 111
	stone.dominion = true
	return stone
end

function Arena:SpawnGrievingWidow(position, fv)
	local stone = Arena:SpawnDungeonUnit(  "arena_descent_grieving_widow", position, 2, 4, nil, fv, false)
	stone:SetRenderColor(90,90,90)
	Arena:ColorWearables(stone, Vector(90,90,90))
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 111
	local ability = stone:FindAbilityByName("arena_descent_grieving_widow_ability")
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_grieving_widow_start", {})
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_grieving_widow_crying", {})
	return stone
end

function Arena:WidowTrigger(widow)
	widow:RemoveModifierByName("modifier_grieving_widow_crying")
	local widowAbility = widow:FindAbilityByName("arena_descent_grieving_widow_ability")
	widowAbility:ApplyDataDrivenModifier(widow, widow, "modifier_widow_scream", {duration = 4.5})
	StartAnimation(widow, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.3})
	widow:SetForwardVector(Vector(-1,0))
	Arena.widow.summonCount = 0
	for i = 1, 36, 1 do
		Timers:CreateTimer(i*0.03, function()
			if i <= 18 then
				widow:SetModelScale(widow:GetModelScale()+0.06)
			else
				widow:SetModelScale(widow:GetModelScale()-0.06)
			end
		end)
	end
	Timers:CreateTimer(2, function()
		EmitSoundOn("Arena.Descent.BeamStart", widow)

		-- widowAbility:ApplyDataDrivenModifier(widow, Arena.widowCorpse, "modifier_widow_beam", {})
		widow.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_POINT_FOLLOW, widow)
		ParticleManager:SetParticleControlEnt(widow.particle, 0, widow, PATTACH_POINT_FOLLOW, "attach_hitloc", widow:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(widow.particle, 1, Arena.widowCorpse, PATTACH_POINT_FOLLOW, "attach_hitloc", Arena.widowCorpse:GetAbsOrigin(), true)
		local widowMoveVector = (Vector(9781, 8830, 540+Arena.ZFLOAT) - Arena.widow:GetAbsOrigin())/200
		for i = 1, 200, 1 do
			Timers:CreateTimer(0.03*i, function()
				Arena.widow:SetAbsOrigin(Arena.widow:GetAbsOrigin()+widowMoveVector)
			end)
		end
		Arena.widowCorpse:RemoveModifierByName("modifier_corpse_frozen")
		for i = 1, 200, 1 do
			Timers:CreateTimer(0.03*i, function()
				Arena.widowCorpse:SetAbsOrigin(Arena.widowCorpse:GetAbsOrigin()+Vector(-0.1,0,2))
			end)
		end
	end)
	Timers:CreateTimer(2.5, function()
		widow:SetForwardVector(Vector(0,-1))
	end)
	Timers:CreateTimer(6, function()
		EmitSoundOnLocationWithCaster(Vector(10136, 7852), "Arena.Descent.ScarySound", Arena.ArenaMaster)
			for i = 1, 24, 1 do
				Timers:CreateTimer(i*0.5, function()

					local spirit = Arena:SpawnExiledSpirit(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
					widowAbility:ApplyDataDrivenModifier(widow, spirit, "modifier_widow_summoned_unit", {})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
					local particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf"
				    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.widowCorpse)
				    ParticleManager:SetParticleControl(pfx,0,Arena.widowCorpse:GetAbsOrigin()+Vector(0,0,100))   
				    ParticleManager:SetParticleControl(pfx,1,spirit:GetAbsOrigin()+Vector(0,0,222))
					Timers:CreateTimer(3.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end)
			end
	end)
end

function Arena:DescentRoom2()
	Arena:SpawnTombstone(Vector(9782, 5339, 136), Vector(1,0), Vector(9920, 5599))
	Arena:SpawnTombstone(Vector(8401, 5469, 136), Vector(1,0), Vector(8512, 5632))
	Arena:SpawnTombstone(Vector(8256, 1188, 110), Vector(1,-1), Vector(8320, 896))
	Arena:SpawnTerrorStriker(Vector(8966, 3889), Vector(1,1))
	Arena:SpawnTerrorStriker(Vector(9262, 3932), Vector(0.3,1))
	Arena:SpawnTerrorStriker(Vector(9575, 3734), Vector(0,1))

	Timers:CreateTimer(3, function()
		Arena:SpawnTerrorStriker(Vector(9408, 3529), Vector(0,1))
		Arena:SpawnTerrorStriker(Vector(9088, 3677), Vector(1,1))
		if Arena.PitLevel >=3 then
			Arena:SpawnTerrorStrikerUltra(Vector(8768, 2880), Vector(1,1))
		end
	end)
	Timers:CreateTimer(7, function()
		Arena:SpawnTombstoneZombieBoss(Vector(6976, 5504), Vector(1,0))
		Arena:SpawnTombstoneZombieBoss(Vector(7192, 5248), Vector(1,1))
	end)
	Timers:CreateTimer(12, function()
		Arena:SpawnTombstone(Vector(8896, 1216, 136), Vector(1,0), Vector(9024, 960))
		Arena:SpawnTombstone(Vector(9152, 576, 136), Vector(1,0), Vector(8832, 640))
		Arena:SpawnTerrorStriker(Vector(8640, 1024), Vector(-1,0))
		Arena:SpawnTerrorStriker(Vector(9344, 768), Vector(-1,0))
	end)
	Timers:CreateTimer(10, function()
		Arena:SpawnTombstone(Vector(7424, 2240, 128), Vector(1,-1), Vector(7168, 2496))
		local vectorTable = {Vector(7040, 2944), Vector(6784, 3072), Vector(6528, 3392), Vector(6784, 3584)}
		for i = 1, #vectorTable, 1 do
			Arena:SpawnTombstoneZombieBoss(vectorTable[i], Vector(0,1))
		end
	end)
end

function Arena:SpawnTombstone(position, fv, summonCenter)
	local stone = Arena:SpawnDungeonUnit(  "arena_descent_tombstone", position, 2, 4, nil, fv, false)
	stone:SetAbsOrigin(position+Vector(0,0,Arena.ZFLOAT))
	stone:SetRenderColor(210,210,210)
	Events:AdjustBossPower(stone, 3, 6, false)
	stone.itemLevel = 111
	stone.summonCenter = summonCenter
	return stone
end

function Arena:SpawnTombstoneZombie(position, fv, itemRoll, bAggro)
	local stone = Arena:SpawnDungeonUnit("arena_descent_zombie", position, itemRoll, itemRoll, "Arena.Descent.ZombieAggro", fv, bAggro)
	stone:SetRenderColor(80,80,80)
	Arena:ColorWearables(stone, Vector(80,80,80))

	stone.itemLevel = 111
	stone.dominion = true
	return stone
end

function Arena:SpawnTerrorStriker(position, fv)
	local stone = Arena:SpawnDungeonUnit(  "arena_descent_terror_striker", position, 0, 2, "Arena.Descent.HorrorStrikerAggro", fv, false)
	stone:SetRenderColor(140,140,140)
	Arena:ColorWearables(stone, Vector(140,140,140))
	Events:AdjustBossPower(stone, 8, 8, false)
	stone.itemLevel = 111
	stone.dominion = true
	return stone
end

function Arena:SpawnTerrorStrikerUltra(position, fv)
	local stone = Arena:SpawnDungeonUnit(  "arena_descent_terror_striker_ultra", position, 2, 4, "Arena.Descent.HorrorStrikerAggro", fv, false)
	stone:SetRenderColor(70,70,70)
	Arena:ColorWearables(stone, Vector(70,70,70))
	Events:AdjustBossPower(stone, 13, 13, false)
	stone.itemLevel = 121
	stone.targetRadius = 1150
	stone.minRadius = 0
	stone.targetAbilityCD = 2
	stone.targetFindOrder = FIND_ANY_ORDER
	stone.dominion = true
	return stone
end

function Arena:SpawnGargoyle(position, fv)
	local stone = Arena:SpawnDungeonUnit(  "arena_descent_gargoyle", position, 0, 2, nil, fv, false)
	stone:SetRenderColor(140,140,140)
	Arena:ColorWearables(stone, Vector(140,140,140))
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 111
	stone.dominion = true
	return stone
end

function Arena:SpawnTombstoneZombieBoss(position, fv)
	local stone = Arena:SpawnDungeonUnit(  "arena_descent_boss_zombie", position, 1, 2, "Arena.Descent.ZombieBossAggro", fv, false)
	stone:SetRenderColor(80,160,80)
	Arena:ColorWearables(stone, Vector(80,160,80))
	Events:AdjustBossPower(stone, 8, 8, false)
	stone.itemLevel = 111
	Arena:SetPositionCastArgs(stone, 700, 0, 1, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Arena:SpawnDescentBeetle(position, fv, bAggro)
	local stone = Arena:SpawnDungeonUnit("arena_descent_goo_beetle", position, 1, 3, "Arena.GooBeetle.Aggro", fv, bAggro)
	-- stone:SetRenderColor(150,150,150)
	-- Arena:ColorWearables(stone, Vector(150,150,150))
	Events:AdjustBossPower(stone, 5, 5, false)
	stone:SetRenderColor(40,255,40)
	Arena:ColorWearables(stone, Vector(40,255,40))
	stone.itemLevel = 110
	stone.dominion = true
	return stone
end

function Arena:DescentRoom3()
		Arena:SpawnTombstone(Vector(12800, -704, 136), Vector(1,0), Vector(12736, -1002))
		Arena:SpawnTombstone(Vector(14144, -896, 136), Vector(1,0), Vector(13952, -704))
		Arena:SpawnTombstone(Vector(13824, 448, 136), Vector(1,0), Vector(13632, 256))
end

function Arena:SpawnDescentMiniSkeleton(position, fv, bAggro)
	local stone = Arena:SpawnDungeonUnit("arena_descent_zombie_critter", position, 0, 1, "Arena.SmallSkeletonSummon", fv, bAggro)
	-- stone:SetRenderColor(150,150,150)
	-- Arena:ColorWearables(stone, Vector(150,150,150))
	Events:AdjustBossPower(stone, 2, 2, false)
	stone:SetRenderColor(120,255,120)
	stone.itemLevel = 101
	stone.dominion = true
	return stone
end

function Arena:RollPitPrizebox(deathLocation)
	local baseLevel = 0
	local rarity = "mythical"
	local prizeLevel = RPCItems:GetLogarithmicVarianceValue(140+Arena.PitLevel*10, 0, 0, 0, 0)
	
	--no difinition for *hero*
	if not hero then
		return
	end
	if GameState:GetPlayerPremiumStatus(hero:GetPlayerOwnerID()) then
		prizeLevel = math.ceil(prizeLevel*(1+(0.3*GameState:GetPlayerPremiumStatusCount())))
	end
    local item = RPCItems:CreateVariantWithMin("item_rpc_arena_prizebox", rarity, "Prizebox", false, false, "Consumable", 0, nil, nil)
    item.newItemTable.property1 = prizeLevel
    item.newItemTable.property1name = "prize_level"
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "#arena_prizebox_level", "#D1D1D1",  1) 
    Arena:RollPrizeBoxProperty2(item, prizeLevel)
    if rarity == "rare" or rarity == "mythical" then
    	Arena:RollPrizeBoxProperty3(item, prizeLevel)
    end
    if rarity == "mythical" then
    	Arena:RollPrizeBoxProperty4(item, prizeLevel)
    end
    local drop = CreateItemOnPositionSync( deathLocation, item )
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function Arena:SpawnDescentNightmare(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_descent_nightmare", position, 3, 4, nil, fv, true)
	stone:SetRenderColor(210,240,210)
	Events:AdjustBossPower(stone, 12, 12, false)
	stone.itemLevel = 120
	StartAnimation(stone, {duration=2.0, activity=ACT_DOTA_TELEPORT_END, rate=0.6})
	stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,900))
	WallPhysics:Jump(stone, Vector(1,1), 0, 0, 0, 1)
	stone.jumpEnd = "hermit"
	Timers:CreateTimer(4, function()
		stone.jumpEnd = nil
	end)
	return stone
end

function Arena:SpawnDescent3()
	Arena:SpawnTombstoneZombieBoss(Vector(7951, -4087), Vector(1,-0.5))
	Arena:SpawnTombstoneZombieBoss(Vector(7680, -4160), Vector(1,0))
	Arena:SpawnTombstoneZombieBoss(Vector(7712, -4416), Vector(1,0.5))

	Arena:SpawnDescentRazorGuard(Vector(7808, -5632), Vector(0,1))
	Arena:SpawnDescentRazorGuard(Vector(7488, -5888), Vector(0,1))
	Arena:SpawnDescentRazorGuard(Vector(7680, -6528), Vector(0,1))

	Timers:CreateTimer(4, function()
		Arena:SpawnDescentDoomBringer(Vector(8384, -7296), Vector(-1,1))
		Arena:SpawnDescentDoomBringer(Vector(9097, -7631), Vector(-1,0.6))
		Arena:SpawnDescentRazorGuard(Vector(10070, -7296), Vector(-1,0))
		Arena:SpawnDescentRazorGuard(Vector(10000, -7680), Vector(-1,0.2))
		Arena:SpawnTombstone(Vector(10320, -7104, 127), Vector(-1,0), Vector(10320, -7488))
		Arena:SpawnTombstone(Vector(11682, -7964, 127), Vector(-1,1), Vector(11584, -7577))
		Arena:SpawnDescentDoomBringer(Vector(12352, -7488), Vector(-1,0))
		Arena:SpawnTombstone(Vector(12544, -7104, 127), Vector(-1,1), Vector(12480, -7424, 127))
	end)
end

function Arena:SpawnDescentRazorGuard(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_descent_razor_guard", position, 1, 3, "Arena.RazorGuard.Aggro", fv, false)
	stone:SetRenderColor(60,255,60)
	Arena:ColorWearables(stone, Vector(60,255,60))
	Events:AdjustBossPower(stone, 9, 9, false)
	stone.itemLevel = 110
	stone.dominion = true
	-- Arena:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
	return stone
end

function Arena:SpawnDescentDoomBringer(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_descent_doombringer", position, 1, 3, "Arena.DescentDoom.Aggro", fv, false)
	stone:SetRenderColor(60,255,60)
	Arena:ColorWearables(stone, Vector(60,255,60))
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 115
	stone.targetRadius = 550
	stone.minRadius = 0
	stone.targetAbilityCD = 1
	stone.targetFindOrder = FIND_ANY_ORDER
	return stone
end

function Arena:SpawnDescentDoomBringerBig(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_descent_doombringer", position, 2, 5, "Arena.DescentDoom.Aggro", fv, false)
	stone:SetRenderColor(60,255,60)
	stone:SetModelScale(1.75)
	stone:AddAbility("arena_descent_crippling"):SetLevel(1)
	Arena:ColorWearables(stone, Vector(60,255,60))
	Events:AdjustBossPower(stone, 10, 10, false)
	stone.itemLevel = 120
	stone.targetRadius = 550
	stone.minRadius = 0
	stone.targetAbilityCD = 1
	stone.targetFindOrder = FIND_ANY_ORDER
	stone:AddAbility("arena_master_duelist_passive"):SetLevel(3)
	return stone
end

function Arena:CreateGooBlast(position)
      particleName = "particles/addons_gameplay/pit_goo_blast_blast.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, position )
      ParticleManager:SetParticleControl( particle1, 1, position )
      Timers:CreateTimer(8, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
	
end

function Arena:SpawnDescentBoss()
	if not Arena.DescentOpen then
		return
	end
	local boss = CreateUnitByName("arena_descent_boss", Vector(12468, -13417,-2700), true, nil, nil, DOTA_TEAM_NEUTRALS)
	boss.type = ENEMY_TYPE_BOSS
	boss.jumpLock = true
	local bossAbility = boss:FindAbilityByName("descent_boss_ai")
	bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_descent_boss_entering", {duration = 4.5})

	boss:SetAbsOrigin(Vector(12468, -13417,-2500))
	Arena:AddPitToUnit(boss)
	-- boss:SetAbsOrigin(Vector(-14826, -16121, 950))
	Events:AdjustDeathXP(boss)
	Events:AdjustBossPower(boss, 16, 16, true)

	 boss:SetRenderColor(140,255,140)

	boss:AddAbility("boss_health"):SetLevel(1)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(12468, -13417,-2500), 1500, 1500, false)
     Timers:CreateTimer(3, function()
     	EmitSoundOnLocationWithCaster(Vector(12468, -13417,-2500), "Arena.PitOfTrials.MusicHighlight", Arena.ArenaMaster)
     end)
     Timers:CreateTimer(0.1, function()
     	StartAnimation(boss, {duration=1.3, activity=ACT_DOTA_UNDYING_TOMBSTONE, rate=1.0})
     end)
     for i = 1, 60, 1 do
     	Timers:CreateTimer(0.03*i, function()
     		boss:SetAbsOrigin(boss:GetAbsOrigin()+Vector(0,0,34))
     	end)
     end
     Timers:CreateTimer(1.1, function()
     	Arena:CreateGooBlast(Vector(12468, -13417, 100))
     	
     end)
     Timers:CreateTimer(1.5, function()
     	StartAnimation(boss, {duration=3.0, activity=ACT_DOTA_VICTORY, rate=1.0})
     	EmitSoundOn("Arena.DescentBoss.Roar", boss)
     end)
     boss.ravage = true
     Timers:CreateTimer(7, function()
     	boss.ravage = false
     end)
end

function Arena:SpawnPitGuardian()
	local stone = Arena:SpawnDungeonUnit("arena_pit_pit_guardian", Vector(-1088, 8064), 3, 6, "Arena.PitGuardian.Aggro", Vector(-1,0.5), false)
	stone.type = ENEMY_TYPE_MINI_BOSS
	if Arena.PitColor == "red" then
		stone:SetRenderColor(255,0,0)
	elseif Arena.PitColor == "blue" then
		stone:SetRenderColor(0,0,255)
	elseif Arena.PitColor == "yellow" then
		stone:SetRenderColor(255,255,0)
	end
	Events:AdjustBossPower(stone, 5, 14, false)
	stone.itemLevel = 120

	-- local guardAbility = stone:FindAbilityByName("arena_pit_pit_guardian_ai")
	-- guardAbility:ApplyDataDrivenModifier(stone, stone, "modifier_pit_guardian_red", {})
end

function Arena:SpawnPitFinalBoss()
	local boss = CreateUnitByName("arena_pit_of_trials_final_boss", Vector(4318, -13923), true, nil, nil, DOTA_TEAM_NEUTRALS)
	boss.type = ENEMY_TYPE_BOSS
	boss:SetForwardVector(Vector(0,1))
	Arena:AddPitToUnit(boss)
	-- boss:SetAbsOrigin(Vector(-14826, -16121, 950))
	Events:AdjustDeathXP(boss)
	Events:AdjustBossPower(boss, 18, 18, false)
	boss:AddNewModifier(boss, nil, "modifier_animation", {translate="walk"})
	-- boss:SetRenderColor(255,255,0)
	-- Arena:ColorWearables(boss, Vector(255,255,0))
	boss:AddAbility("boss_health"):SetLevel(1)
	Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, boss, "modifier_damage_resistance", {})
	boss.damageReduc = 0.01
end

function Arena:PitBossMusic()
	Timers:CreateTimer(25, function()
		if Arena.PitBossActive then
			-- EmitSoundOnLocationWithCaster(Vector(-2816, -10306, 256), "Arena.StartingMusic", Events.GameMaster)
			-- EmitSoundOnLocationWithCaster(Vector(-2670, -2445, 256), "Arena.StartingMusic", Events.GameMaster)
			CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.PitBoss.Music"})
			if Arena.PitBossActive then
				return 112
			end
		end
	end)
end

function Arena:PitBossMusic2()
	Timers:CreateTimer(0, function()
		if Arena.PitBossActive2 then
			-- EmitSoundOnLocationWithCaster(Vector(-2816, -10306, 256), "Arena.StartingMusic", Events.GameMaster)
			-- EmitSoundOnLocationWithCaster(Vector(-2670, -2445, 256), "Arena.StartingMusic", Events.GameMaster)
			CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.PitBoss.Music"})
			if Arena.PitBossActive2 then
				return 112
			end
		end
	end)
end

function Arena:SpawnBossSpecter(position, fv, bAggro)
	local stone = Arena:SpawnDungeonUnit("arena_boss_spectre_summon", position, 0, 0, nil, fv, bAggro)
	Events:AdjustBossPower(stone, 7, 7, false)
	stone:SetDeathXP(0)
	stone.dominion = true
	return stone
end

function Arena:DefeatPitBoss(position)
  Timers:CreateTimer(5, function()
        local mithrilReward = Arena:GetPitMithrilReward()
        local crystal = CreateUnitByName("arcane_crystal", position+Vector(0,0,1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward*(1+GameState:GetPlayerPremiumStatusCount()*0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward/200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        for i = 1, #MAIN_HERO_TABLE, 1 do
        	Stars:StarEventPlayer("pitoftrials", MAIN_HERO_TABLE[i])
        end
        -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #potentialWinnerTable, 1 do
        --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
        --  local completed = completedTable.completed
        --  if completed == 0 then
        --    potentialWinnerTable[i].shardsPickedUp = 0
        --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
        --  end
        -- end
        if #crystal.winnerTable > 0 then
          for i = 1, #crystal.winnerTable, 1 do
            crystal.winnerTable[i].shardsPickedUp = 0
          end
          Timers:CreateTimer(1.4, function()
            EmitSoundOn("Resource.MithrilShardEnter", crystal)
          end)
        end
  end)
end

function Arena:GetPitMithrilReward()
	local mithrilReward = ARENA_MITHRIL_PIT_1
	if Arena.PitLevel == 2 then
		mithrilReward = ARENA_MITHRIL_PIT_2
	elseif Arena.PitLevel == 3 then
		mithrilReward = ARENA_MITHRIL_PIT_3
	elseif Arena.PitLevel == 4 then
		mithrilReward = ARENA_MITHRIL_PIT_4
	elseif Arena.PitLevel == 5 then
		mithrilReward = ARENA_MITHRIL_PIT_5
	elseif Arena.PitLevel == 6 then
		mithrilReward = ARENA_MITHRIL_PIT_6
	elseif Arena.PitLevel == 7 then
		mithrilReward = ARENA_MITHRIL_PIT_7
	end
	return mithrilReward
end

function Arena:SpawnSpiritOfRakash(position, fv)
	local stone = Arena:SpawnDungeonUnit("arena_pit_conquest_spirit_of_rakash", position, 2, 4, "Arena.Rakash.Aggro", fv, false)
	-- stone:SetRenderColor(150,150,150)
	-- Arena:ColorWearables(stone, Vector(150,150,150))
	Events:AdjustBossPower(stone, 14, 14, false)
	stone.itemLevel = 128
	local ability = stone:FindAbilityByName("solos_burning_spear")
	ability:ToggleAutoCast()
	return stone
end

function Arena:SoulFerrierEvent()
	local luck = RandomInt(1, 60)
	if luck <= 2+GameState:GetPlayerPremiumStatusCount()*1 then
		PrecacheUnitByNameAsync("pit_of_trials_secret_soul_ferrier", function(...) end)
		PrecacheUnitByNameAsync("arena_ferrier_gargoyle", function(...) end)
		Timers:CreateTimer(2, function()
			local position = Vector(8896, 8640)
			Arena:SpawnSoulFerrier(position, Vector(0,-1))
		end)
	end
end

function Arena:SpawnSoulFerrier(position, fv)
	local stone = Arena:SpawnDungeonUnit("pit_of_trials_secret_soul_ferrier", position, 2, 4, "Arena.FerrierIntro2", fv, false)
	stone.type = ENEMY_TYPE_MINI_BOSS
	stone.cantAggro = true
	-- stone:SetRenderColor(150,150,150)
	-- Arena:ColorWearables(stone, Vector(150,150,150))
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 1500, 1500, false)
	Events:AdjustBossPower(stone, 14, 14, false)
	stone.itemLevel = 128
	Events:ColorWearablesAndBase(stone, Vector(180, 255, 220))
	stone:SetModelScale(0.03)
	Events:smoothSizeChange(stone, 0.03, 1.5, 90)
	Timers:CreateTimer(1, function()
		StartAnimation(stone, {duration=10, activity=ACT_DOTA_TELEPORT, rate=1.0})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", stone, 30)
		EmitSoundOn("Arena.FerrierIntro1", stone)
		Timers:CreateTimer(4, function()
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", stone, 30)
		end)
	end)
	EmitSoundOnLocationWithCaster(stone:GetAbsOrigin(), "Arena.SecretHorrorPiano", stone)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		EmitSoundOnLocationWithCaster(MAIN_HERO_TABLE[1]:GetAbsOrigin(), "Arena.SecretHorrorPiano", stone)
	end
	local ability = stone:FindAbilityByName("soul_ferrier_passive")
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_disable_player", {})
	

	stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,1500))
	stone.speed_fall = 25
	for i = 1, 200, 1 do
		Timers:CreateTimer(i*0.03, function()
			if stone:GetAbsOrigin().z - GetGroundHeight(stone:GetAbsOrigin(), stone) > 2 then
				stone:SetAbsOrigin(stone:GetAbsOrigin() - Vector(0,0,stone.speed_fall))
				stone.speed_fall = math.max(5, stone.speed_fall-0.3)
			end
		end)
	end
	Timers:CreateTimer(8, function()
		local enemies = FindUnitsInRadius( stone:GetTeamNumber(), stone:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			if not stone.lock_sequence then
				stone.lock_sequence = true
				Arena:FerrierSequence(stone, enemies)
			end
		else
			return 3
		end
	end)
	return stone
end

function Arena:FerrierSequence(ferrier, enemies)
	StartAnimation(ferrier, {duration=10, activity=ACT_DOTA_TELEPORT, rate=1.0})
	Arena.FerrierGargoyleTable = {}
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", ferrier, 30)
	for i = 1, 30, 1 do
		Timers:CreateTimer(i*0.2, function()
			local spawn_pos = ferrier:GetAbsOrigin() + RandomVector(RandomInt(800, 1200))
			local targetPosition = enemies[RandomInt(1, #enemies)]:GetAbsOrigin()+RandomVector(RandomInt(100, 400))
			local garg = Arena:SpawnFerrierGargoyle(spawn_pos, targetPosition)
			local base_ability = ferrier:FindAbilityByName("soul_ferrier_passive")
			base_ability:ApplyDataDrivenModifier(ferrier, garg, "modifier_ferrier_unit", {})
		end)
	end
	EmitSoundOnLocationWithCaster(ferrier:GetAbsOrigin(), "Arena.FerrierWaveSpawn", ferrier)
	EmitSoundOn("Arena.FerrierIntro1", ferrier)
	Timers:CreateTimer(6.5, function()
		Arena:RemoveFerrierShield(ferrier:GetAbsOrigin())
	end)
end

function Arena:RemoveFerrierShield(startPos)
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf", startPos+Vector(0,0,100), 3)
	local gargoyle_open = Arena.FerrierGargoyleTable[RandomInt(1, #Arena.FerrierGargoyleTable)]
	if gargoyle_open then
		ParticleManager:SetParticleControl(pfx, 1, gargoyle_open:GetAbsOrigin()+Vector(0,0,100))
		gargoyle_open:RemoveModifierByName("modifier_disable_player")
		EmitSoundOn("Arena.FerrierShieldRemove.Scream", gargoyle_open)
	end
end

function Arena:SpawnFerrierGargoyle(position, targetPosition)
	local stone = Arena:SpawnDungeonUnit("arena_ferrier_gargoyle", position, 0, 1, nil, fv, false)
	CustomAbilities:QuickAttachParticle("particles/econ/items/wisp/wisp_relocate_timer_buff_ti7_end_sparkle.vpcf", stone, 3)
	EmitSoundOn("Arena.FerrierWaveSpawn", stone)
	Dungeons:AggroUnit(stone)
	stone:MoveToPositionAggressive(targetPosition)
	stone.death_code = 1
	table.insert(Arena.FerrierGargoyleTable, stone)
	return stone
end
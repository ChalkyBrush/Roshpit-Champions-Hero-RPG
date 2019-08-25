function Winterblight:CaveGuideSpawn()
	if not Winterblight.CaveGuideSpawned then
	-- 	if Winterblight.CaveGuideReady then
			if not Winterblight.CavernPrecached then
				Winterblight.CavernPrecached = true
				Precache:WinterblightCavern()
			end
			Winterblight:InitCavernData()
			Winterblight.CaveGuideSpawned = true
			local spawnPos = GetGroundPosition(Vector(-5427, 6930), Events.GameMaster)
			local guide = CreateUnitByName("winterblight_cavern_guide", spawnPos, false, nil, nil, DOTA_TEAM_GOODGUYS)
			guide:SetForwardVector(Vector(-1,1))
			StartAnimation(guide, {duration=5, activity=ACT_DOTA_VERSUS, rate=0.8})
			EmitSoundOnLocationWithCaster(spawnPos, "Winterblight.GuideCaveIntro2", Events.GameMaster)
			CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", spawnPos, 3)
			CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", spawnPos, 3)
			for i = 1, 5, 1 do
				Timers:CreateTimer(1*(i+1)-0.5, function()
					EmitSoundOnLocationWithCaster(spawnPos, "Winterblight.Cave.GuideIntro1", Events.GameMaster)
					CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", spawnPos, 3)
					CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9_bloom.vpcf", guide, 3)
				end)
			end
			guide:SetAbsOrigin(guide:GetAbsOrigin()+Vector(0,0,2000))
			guide:SetModelScale(1.3)
			guide:SetRenderColor(60, 50, 255)
			Winterblight.CavernGuide = guide
			local ability = guide:FindAbilityByName("winterblight_cave_guide_ability")
			ability:ApplyDataDrivenModifier(guide, guide, "modifier_guide_entering", {duration = 60})
			CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/aegis_lvl_1000_ambient_ti9.vpcf", spawnPos, 6)
			Timers:CreateTimer(3, function()
				EmitSoundOnLocationWithCaster(spawnPos, "Winterblight.GuideCave.Magical", caster)
			end)
	-- 	end
	-- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13952, 12800, 500), 10000, 10000, false)
	end
end

function Winterblight:GetCaveMetaData()
	local url = ROSHPIT_URL.."/champions/get_winterblight_cavern_meta_data?winterblight=1"

	for i = 1, #MAIN_HERO_TABLE, 1 do
		local hero_name = MAIN_HERO_TABLE[i]:GetUnitName()
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
		local steamID = PlayerResource:GetSteamAccountID(playerID)
		url = url.."&steam_id"..i.."="..steamID
		url = url.."&hero"..i.."="..hero_name
	end
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			Winterblight.CavernMetaData = resultTable
			for i = 1, #MAIN_HERO_TABLE, 1 do
				Stars:StarEventPlayer("cavern_master", MAIN_HERO_TABLE[i])
			end
			print(Winterblight.CavernMetaData)
		end
	end )
end

function Winterblight:InitCavernData()
	Winterblight:GetCaveMetaData()
	local relics_table = {500, 500, 500, 500, 500, 800, 800, 1000, 1000, 1200, 1200, 1500, 2000, 2000, 3000, 3000}
	relics_table = WallPhysics:ShuffleTable(relics_table)
	Winterblight.CavernData = {}
	Winterblight.CavernData.Chambers = {}
	Winterblight.CavernData.RelicsFragments = 0
	Winterblight.CavernData.tiamat_status = 0
	Winterblight.CavernData.realm_breaker_status = -1
	for i = 1, 4, 1 do
		Winterblight.CavernData.Chambers[i] = {}
		Winterblight.CavernData.Chambers[i]["status"] = 0
		Winterblight.CavernData.Chambers[i]["boss_status"] = 0
		Winterblight.CavernData.Chambers[i]["boss_level_defeated"] = 0
		Winterblight.CavernData.Chambers[i]["events"] = {}
		for j = 1, 4, 1 do
			Winterblight.CavernData.Chambers[i]["events"][j] = {}
			Winterblight.CavernData.Chambers[i]["events"][j]["status"] = 0
			local relic_reward_index = (i-1)*4 + j
			Winterblight.CavernData.Chambers[i]["events"][j]["relic_fragments_reward"] = relics_table[relic_reward_index]
			Winterblight.CavernData.Chambers[i]["events"][j]["relic_fragments_rewarded"] = 0
			Winterblight.CavernData.Chambers[i]["events"][j]["level"] = 0
		end
	end
	Winterblight.CavernData.Chambers[1]["boss_name"] = "descent_of_winterblight_torturok"
	Winterblight.CavernData.Chambers[2]["boss_name"] = "descent_of_winterblight_aertega"
	Winterblight.CavernData.Chambers[3]["boss_name"] = "descent_of_winterblight_ozubu"
	Winterblight.CavernData.Chambers[4]["boss_name"] = "winterblight_cavern_gigarraun"

	Winterblight.CavernChamberVertices = {}
	for j = 1, 4, 1 do
		Winterblight.CavernChamberVertices[j] = Winterblight:GetVertices(j)
	end
end

function Winterblight:ProcessUIMessage(msg)
	if msg.start_event == 1 then
		Winterblight:ProcessChamberStart(msg)
	elseif msg.records == 1 then
		Winterblight:ReturnRecordsToUI(msg)
	elseif msg.boss == 1 then
		Winterblight:CavernBossSummon(msg)
	end
end

function Winterblight:ReturnRecordsToUI(msg)
	print(Winterblight.CavernMetaData)
	print(msg.playerID)
	local player = PlayerResource:GetPlayer(msg.PlayerID)
	local steamID = tostring(PlayerResource:GetSteamAccountID(msg.PlayerID))
	local steamID_long = tostring(PlayerResource:GetSteamID(msg.PlayerID))
	CustomGameEventManager:Send_ServerToPlayer(player, "load_winterblight_cavern_records", {wb_data = Winterblight.CavernMetaData, chamber_index = msg.chamber_index, event_index = msg.event_index, steam_id = steamID, steam_id_long = steamID_long, difficulty = GameState:GetDifficultyFactor(), stones = Winterblight.Stones})
end

function Winterblight:ProcessChamberStart(msg)
	if not Beacons.cheats then
		if Winterblight.CavernData.Chambers[msg.chamber]["status"] > 0 then
			return false
		end
	end
	local hero = PlayerResource:GetPlayer(msg.PlayerID):GetAssignedHero()
	if not Winterblight:ValidateChamberMaxLevel(hero, msg.chamber, msg.event_number, msg.level) then
		return false
	end
	Winterblight.CavernData.Chambers[msg.chamber]["status"] = 1
	Winterblight.CavernData.Chambers[msg.chamber]["level"] = msg.level
	Winterblight.CavernData.Chambers[msg.chamber]["event"] = msg.event_number
	Winterblight.CavernData.Chambers[msg.chamber]["hero"] = hero:GetEntityIndex()
	Winterblight.CavernData.Chambers[msg.chamber]["events"][msg.event_number]["status"] = 1
	if not Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"] then
		Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"] = 0
	end
	if not Winterblight.CavernData.Chambers[msg.chamber]["events"][msg.event_number]["attempt"] then
		Winterblight.CavernData.Chambers[msg.chamber]["events"][msg.event_number]["attempt"] = 1
	else
		Winterblight.CavernData.Chambers[msg.chamber]["events"][msg.event_number]["attempt"] = Winterblight.CavernData.Chambers[msg.chamber]["events"][msg.event_number]["attempt"] + 1
	end
	Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"] = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"] + 1
	-- if Beacons.cheats then
	-- 	Winterblight.CavernData.Chambers[msg.chamber]["status"] = 0
	-- end
	if not Winterblight.CavernUnits then
		Winterblight.CavernUnits = {}
	end
	if not Winterblight.CavernPFXs then
		Winterblight.CavernPFXs = {}
	end
	Winterblight.CavernPFXs[msg.chamber] = {}
	Winterblight.CavernUnits[msg.chamber] = {}

	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, hero, "modifier_winterblight_cavern_fighter", {})
	hero.strength_custom = 20
	hero.agility_custom = 20
	hero.intellect_custom = 20
	-- reset hero so rankings are fair w/o potions

	StartAnimation(Winterblight.CavernGuide, {duration=4, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.6})
	Timers:CreateTimer(1.0, function()
		EmitSoundOnLocationWithCaster(Winterblight.CavernGuide:GetAbsOrigin(), "Winterblight.GuideCaveIntro2", Events.GameMaster)
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", Winterblight.CavernGuide, 4)
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", Winterblight.CavernGuide:GetAbsOrigin(), 4)
	end)
	EmitSoundOn("Winterblight.CavernGuide.EventStart.VO", Winterblight.CavernGuide)
	if msg.chamber == 1 then
		Winterblight:FrozenFoyer(msg)
	elseif msg.chamber == 2 then
		Winterblight:AuroraPassage(msg)
	elseif msg.chamber == 3 then
		Winterblight:Crystarium(msg)
	elseif msg.chamber == 4 then
		Winterblight:EdgeOfWinter(msg)
	end

	local player = hero:GetPlayerOwner()
	local playerID = hero:GetPlayerOwnerID()
	Winterblight.CavernData.Chambers[msg.chamber]["steam_id_long"] = tostring(PlayerResource:GetSteamID(playerID))
	CustomGameEventManager:Send_ServerToAllClients("cavern_summary_init", {chamber_data = Winterblight.CavernData.Chambers, fragments = Winterblight.CavernData.RelicsFragments})
end

function Winterblight:FrozenFoyer(msg)
	if msg.event_number == 1 then
		Winterblight:FrozenFoyer1(msg)
	elseif msg.event_number == 2 then
		Winterblight:FrozenFoyer2(msg)
	elseif msg.event_number == 3 then
		Winterblight:FrozenFoyer3(msg)
	elseif msg.event_number == 4 then
		Winterblight:FrozenFoyer4(msg)
	end
end

function Winterblight:AuroraPassage(msg)
	if msg.event_number == 1 then
		Winterblight:AuroraPassage1(msg)
	elseif msg.event_number == 2 then
		Winterblight:AuroraPassage2(msg)
	elseif msg.event_number == 3 then
		Winterblight:AuroraPassage3(msg)
	elseif msg.event_number == 4 then
		Winterblight:AuroraPassage4(msg)
	end
end

function Winterblight:Crystarium(msg)
	if msg.event_number == 1 then
		Winterblight:Crystarium1(msg)
	elseif msg.event_number == 2 then
		Winterblight:Crystarium2(msg)
	elseif msg.event_number == 3 then
		Winterblight:Crystarium3(msg)
	elseif msg.event_number == 4 then
		Winterblight:Crystarium4(msg)
	end
end

function Winterblight:EdgeOfWinter(msg)
	if msg.event_number == 1 then
		Winterblight:EdgeOfWinter1(msg)
	elseif msg.event_number == 2 then
		Winterblight:EdgeOfWinter2(msg)
	elseif msg.event_number == 3 then
		Winterblight:EdgeOfWinter3(msg)
	elseif msg.event_number == 4 then
		Winterblight:EdgeOfWinter4(msg)
	end
end

function Winterblight:ShouldSpawnCaveUnit(chamber, spawnphase)
	if Winterblight.CavernData.Chambers[chamber]["spawnphase"] == spawnphase and Winterblight.CavernData.Chambers[chamber]["status"] == 1 then
		return true
	else
		return false
	end
end

function Winterblight:FrozenFoyer1(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 176
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local chamber_id = msg.chamber
	local unitsTable = {}
	local positionTable = {Vector(-7040, 7552), Vector(-6809, 7936), Vector(-6519, 8320)}
	for i = 1, #positionTable, 1 do
		local fv = ((Vector(-5622, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
		local unit = Winterblight:SpawnWinterRunner(positionTable[i], fv)
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
		end
	end
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(-8704, 5888), Vector(-9728, 6400), Vector(-11520, 7936), Vector(-6784, 8704), Vector(-4992, 9600), Vector(-4608, 9856), Vector(-4736, 10240), Vector(-6794, 10496), Vector(-8704, 11264), Vector(-9728, 11008)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.1, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = RandomVector(1)
					local unit = Winterblight:SpawnManaNull(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(2.5, function()
		local positionTable = {Vector(-12416, 8960), Vector(-8832, 5888), Vector(-5760, 9856), Vector(-10624, 11008)}
	    for i = 1, #positionTable, 1 do
	      Timers:CreateTimer(i*1.2, function()
	        local patrolPositionTable = {}
	        for j = 1, #positionTable, 1 do
	          local index = i + j
	          if index > #positionTable then
	            index = index - #positionTable
	          end
	          table.insert(patrolPositionTable, positionTable[index])
	        end
	        for j = 0, 1, 1 do
	          Timers:CreateTimer(j*0.8, function()
	          	if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
		            local elemental = Winterblight:SpawnBloodWraith(positionTable[i]+RandomVector(RandomInt(1,180)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 12, 10, 220, patrolPositionTable)
		            Winterblight:SetCavernUnit(elemental, elemental:GetAbsOrigin(), true, true, chamber_id)
		        end
	          end)
	        end
	      end)
	    end
	end)
	Timers:CreateTimer(1, function()
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			local ultra_ice = Winterblight:SpawnUltraIce(Vector(-9033, 8320), RandomVector(1))
			Winterblight:SetCavernUnit(ultra_ice, ultra_ice:GetAbsOrigin(), true, true, chamber_id, 2)
		end
	end)
	Timers:CreateTimer(5, function()
		local positionTable = {Vector(-11904, 9600), Vector(-11555, 9998), Vector(-11264, 10436), Vector(-10880, 10834), Vector(-10481, 11290)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.1, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = Vector(1, -0.4)
					local unit = Winterblight:SpawnDrillDigger(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, unit:GetAbsOrigin(), true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(3.5, function()
		local positionTable = {Vector(-10368, 7168), Vector(-12739, 9113), Vector(-10752, 9811), Vector(-7807, 10817), Vector(-5342, 9713), Vector(-7429, 8450)}
	    for i = 1, #positionTable, 1 do
	      Timers:CreateTimer(i*1.2, function()
	        local patrolPositionTable = {}
	        for j = 1, #positionTable, 1 do
	          local index = i + j
	          if index > #positionTable then
	            index = index - #positionTable
	          end
	          table.insert(patrolPositionTable, positionTable[index])
	        end
	        for j = 0, 1, 1 do
	          Timers:CreateTimer(j*0.9, function()
	          	if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
		          	local elemental = Winterblight:SpawnCavernBat(positionTable[i]+RandomVector(RandomInt(1,280)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 20, 4, 320, patrolPositionTable)
		            Winterblight:SetCavernUnit(elemental, elemental:GetAbsOrigin(), true, true, chamber_id)
		        end
	          end)
	        end
	      end)
	    end
	end)
	Timers:CreateTimer(7, function()
		local positionTable = {Vector(-12899, 8939), Vector(-12959, 9216), Vector(-13184, 9515), Vector(-12928, 9783)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.1, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = Vector(0.7, -1)
					local unit = Winterblight:SpawnPantheonKnight(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, unit:GetAbsOrigin(), true, true, chamber_id)
				end
			end)
		end
		local positionTable = {Vector(-8508, 5120), Vector(-8704, 5353), Vector(-8374, 5376)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.2, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = Vector(0, 1)
					local unit = Winterblight:SpawnPantheonKnight(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, unit:GetAbsOrigin(), true, true, chamber_id)
				end
			end)
		end
		local positionTable = {Vector(-7808, 7808), Vector(-9151, 7086), Vector(-10227, 7710), Vector(-9803, 9842)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = RandomVector(1)
					local unit = Winterblight:SpawnPantheonKnight(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, unit:GetAbsOrigin(), true, true, chamber_id)
				end
			end)
		end
	end)	
	Timers:CreateTimer(4, function()
		local positionTable = {}
		for j = 1, 10, 1 do
			local randomPos = Vector(-9600+RandomInt(0,1150), 7680+RandomInt(0, 900))
			table.insert(positionTable, randomPos)
		end
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local unit = Winterblight:SpawnSkatingZealot(positionTable[i], RandomVector(1), Vector(-9600, 7680), 1150, 900)
					Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(6.5, function()
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			local positionTable = {Vector(-8704, 9472), Vector(-8704, 10112), Vector(-8192, 10112), Vector(-8192, 9472)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,-1)
				local unit = Winterblight:SpawnWinterRunner(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)
	Timers:CreateTimer(8.5, function()
		local positionTable = {Vector(-11804, 9088), Vector(-12288, 8832), Vector(-11804, 8532), Vector(-12224, 8448)}
		for i = 1, #positionTable, 1 do
			if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
				local fv = Vector(0,-1)
				local unit = Winterblight:SpawnColdSeer(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)
	Timers:CreateTimer(9.5, function()
		local positionTable = {Vector(-10619, 7925), Vector(-11008, 8064), Vector(-10958, 8520), Vector(-10496, 8615), Vector(-10240, 8261)}
		for i = 1, #positionTable, 1 do
			if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
				local fv = (positionTable[i] - Vector(-10618, 8347)):Normalized()
				local unit = Winterblight:SpawnShineMegmus(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)
	Timers:CreateTimer(11.5, function()
		local positionTable = {Vector(-7296, 10112), Vector(-7028, 9607), Vector(-6692, 9088), Vector(-6272, 9291), Vector(-5851, 9421)}
		for i = 1, #positionTable, 1 do
			if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
				local fv = (positionTable[i] - Vector(-6418, 9856)):Normalized()
				local unit = Winterblight:SpawnIceHaunter(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)
	Timers:CreateTimer(12.5, function()
		local positionTable = {Vector(-10245, 10490), Vector(-10315, 10092), Vector(-10624, 10012)}
		for i = 1, #positionTable, 1 do
			if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
				local fv = RandomVector(1)
				local unit = Winterblight:SpawnChillingColossus(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)
	Timers:CreateTimer(14.5, function()
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			for i = 1, 8, 1 do
				local position = Vector(-10368, 6924) + RandomVector(RandomInt(1, 410))
				local fv = RandomVector(1)
				local unit = Winterblight:SpawnMountainBeetle(position, fv)
				Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
			end
		end
	end)
	Timers:CreateTimer(11.5, function()
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			local positionTable = {Vector(-7448, 10496), Vector(-7934, 10624), Vector(-8320, 10880), Vector(-7808, 11108), Vector(-672, 10352), Vector(-5927, 10471), Vector(-5519, 10240), Vector(-4608, 10240), Vector(-4720, 10674)}
			for i = 1, #positionTable, 1 do
				local fv = RandomVector(1)
				local unit = Winterblight:SpawnBarbedHusker(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)
	Timers:CreateTimer(18.5, function()
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			local positionTable = {Vector(-10481, 11771), Vector(-10816, 11557), Vector(-11008, 11264)}
			for i = 1, #positionTable, 1 do
				local fv = RandomVector(1)
				local unit = Winterblight:SpawnBarbedHusker(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)
end

function Winterblight:FrozenFoyer2(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 468
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local chamber_id = msg.chamber
	local unitsTable = {}
	local positionTable = {Vector(-8832, 5888), Vector(-10281, 7509), Vector(-11837, 8406), Vector(-10805, 8535), Vector(-8704, 8182), Vector(-7004, 8602), Vector(-5860, 9984), Vector(-8064, 9984), Vector(-9216, 10539), Vector(-10319, 9487), Vector(-11166, 10144), Vector(-6418, 9856)}
	for i = 1, 12, 1 do
		positionTable[i] = positionTable[i] + RandomVector(RandomInt(0, 400))
	end
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*0.5, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
      	if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
            local elemental = Winterblight:SpawnUltraIce(positionTable[i]+RandomVector(RandomInt(1,180)), RandomVector(1), 1)
            Winterblight:AddPatrolArguments(elemental, 12, 5, 220, patrolPositionTable)
            Winterblight:SetCavernUnit(elemental, elemental:GetAbsOrigin(), true, true, chamber_id)
        end
      end)
    end
end

function Winterblight:SpawnCavernBat(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winter_cavern_bat", position, 0, 1, "Winterblight.CavernBat.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SetCavernUnit(unit, original_position, bDeaggro, bParticle, chamber_index)
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_winterblight_cavern_unit", {})
	unit.deaggro = bDeaggro
	unit.original_position = original_position
	unit.chamber = chamber_index
	if bParticle then
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", unit:GetAbsOrigin(), 4)
		EmitSoundOn("Winterblight.GuideCaveIntro", unit)
	end
	if chamber_index > 0 then
		local event_index = Winterblight.CavernData.Chambers[chamber_index]["event"]
		if Winterblight.CavernData.Chambers[chamber_index]["events"][event_index]["attempt"] ~= 1 then
			unit.minDungeonDrops = 0
			unit.maxDungeonDrops = 0
		end
		table.insert(Winterblight.CavernUnits[chamber_index], unit)
	end
end

function Winterblight:SpawnWinterRunner(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cavern_centaur", position, 0, 2, "Winterblight.Cavern.Centaur.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	-- stone.cantAggro = true
	Timers:CreateTimer(0.8, function()
		if IsValidEntity(stone) then
			Dungeons:DeaggroUnit(stone)
		end
	end)
	return stone
end

function Winterblight:SpawnPantheonKnight(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("cavern_pantheon_knight", position, 0, 2, "PantheonKnight.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnManaNull(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_mana_null", position, 0, 2, "Winterblight.Cavern.ManaNull.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	if Winterblight.Stones >= 3 then
		stone:AddAbility("creature_pure_strike"):SetLevel(3)
	end
	stone.randomMissMin = 500
	stone.randomMissMax = 1200
	Winterblight:SetPositionCastArgs(stone, 2000, 300, 1, FIND_ANY_ORDER)

	return stone

end

function Winterblight:SpawnBloodWraith(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_blood_wraith", position, 0, 2, "Winterblight.Cavern.BloodWraith.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 50
	stone:SetRenderColor(130, 180, 255)
	stone.dominion = true
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:SpawnUltraIce(position, fv, spawnMult)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cavern_ultra_ice", position, 1, 5, "Winterblight.Cavern.UltraIce.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 6, false)
	stone.itemLevel = 60
	stone:SetRenderColor(150, 190, 255)
	stone.spawnPos = stone:GetAbsOrigin()
	stone.spawnMult = spawnMult
	-- Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:SpawnDrillDigger(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("drill_digger", position, 0, 2, "DrillDigger.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 6, false)
	stone.itemLevel = 55
	stone:SetRenderColor(150, 190, 255)
	stone.dominion = true
	-- Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:SpawnBarbedHusker(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("barbed_mole", position, 0, 2, "Cavern.Husker.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 6, false)
	stone.itemLevel = 55
	stone:SetRenderColor(150, 190, 255)
	stone.randomMissMin = 240
	stone.randomMissMax = 400
	stone.dominion = true
	Winterblight:SetPositionCastArgs(stone, 1500, 300, 1, FIND_ANY_ORDER)
	return stone
end

function Winterblight:IsWithinChamber(unit, chamber_id)
	local compare_position = unit:GetAbsOrigin()
	local is_in_region = false
	if chamber_id == 0 then
		is_in_region = true
	else
		for i = 1, #Winterblight.CavernChamberVertices[chamber_id], 1 do
			if WallPhysics:IsWithinRegionA(compare_position, Winterblight.CavernChamberVertices[chamber_id][i][1], Winterblight.CavernChamberVertices[chamber_id][i][2]) then
				is_in_region = true
				break
			end
		end
	end
	return is_in_region
end

function Winterblight:ValidateChamberMaxLevel(hero, chamber_index, event_index, level)
	local playerID = hero:GetPlayerOwnerID()
	local steam_id = PlayerResource:GetSteamAccountID(playerID)
	local overall_max = 1
	local your_hero_max = 1
	local chamber_index = tostring(chamber_index)
	local event_index = tostring(event_index)
	if Winterblight.CavernMetaData[chamber_index][event_index][steam_id] and Winterblight.CavernMetaData[chamber_index][event_index][steam_id]["hero_record"] and Winterblight.CavernMetaData[chamber_index][event_index][steam_id]["hero_record"]["level"] then
		your_hero_max = Winterblight.CavernMetaData[chamber_index][event_index][steam_id]["hero_record"]["level"] + 5
	end
	local game_settings_max = 1
	local difficulty = GameState:GetDifficultyFactor()
	if difficulty == 2 then
		game_settings_max = 3
	elseif difficulty == 3 then
		game_settings_max = 5
		if Winterblight.Stones == 1 then
			game_settings_max = 10
		elseif Winterblight.Stones == 2 then
			game_settings_max = 15
		elseif Winterblight.Stones == 3 then
			game_settings_max = -1
		end
	end
	if game_settings_max > 0 then
		overall_max = math.min(your_hero_max, game_settings_max)
	else
		overall_max = math.max(your_hero_max, 20)
	end
	if your_hero_max <= 20 and game_settings_max ~= -1 then
		overall_max = game_settings_max
	end
	if overall_max >= level and level > 0 then
		return true
	else
		return false
	end
end

function Winterblight:GetVertices(chamber_id)
	local vertices = {}
	if chamber_id == 1 then
		local height = 819
		local width = 1550
		local origin = Vector(-8584, 5664)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 667
		local width = 1092
		local origin = Vector(-9273, 5893)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 430
		local width = 1027
		local origin = Vector(-10110, 6224)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 1137
		local width = 4157
		local origin = Vector(-8646, 6968)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 802
		local width = 501
		local origin = Vector(-7930, 6038)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 1137
		local width = 720
		local origin = Vector(-11027, 6969)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 890
		local width = 6560
		local origin = Vector(-9248, 7928)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 1508
		local width = 9150
		local origin = Vector(-8863, 9046)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 1609
		local width = 7120
		local origin = Vector(-7848, 10460)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 888
		local width = 2118
		local origin = Vector(-12335, 10115)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 738
		local width = 853
		local origin = Vector(-11778, 10895)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 424
		local width = 3000
		local origin = Vector(-9910, 11401)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 870
		local width = 2100
		local origin = Vector(-10360, 12021)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 768
		local width = 1024
		local origin = Vector(-8448, 5120)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 1152
		local width = 568
		local origin = Vector(-7993, 6080)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 896
		local width = 896
		local origin = Vector(-9536, 6464)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})
	elseif chamber_id == 2 then
		local height = 3410
		local width = 8190
		local origin = Vector(-6976, 14476)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})	

		local height = 1129
		local width = 5650
		local origin = Vector(-6125, 12268)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})		

		local height = 660
		local width = 1437
		local origin = Vector(-9678, 12469)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})	

		local height = 4189
		local width = 1280
		local origin = Vector(-2816, 14401)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})	
	elseif chamber_id == 3 then
		local height = 7140
		local width = 2000
		local origin = Vector(-15079, 4444)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 874
		local width = 1975
		local origin = Vector(-14032, 8116)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 5776
		local width = 640
		local origin = Vector(-12736, 5175)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 5432
		local width = 1152
		local origin = Vector(-13632, 4964)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 4925
		local width = 896
		local origin = Vector(-12096, 5089)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 3228
		local width = 768
		local origin = Vector(-10496, 4301)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 2932
		local width = 477
		local origin = Vector(-9873, 4154)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 2471
		local width = 703
		local origin = Vector(-9376, 3805)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 2018
		local width = 860
		local origin = Vector(-8657, 3611)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 3282
		local width = 1887
		local origin = Vector(-11115, 4457)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})
	elseif chamber_id == 4 then
		local height = 8012
		local width = 2538
		local origin = Vector(-16010, 12250)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 7092
		local width = 914
		local origin = Vector(-14281, 12454)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 4497
		local width = 2698
		local origin = Vector(-12670, 14025)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 640
		local width = 2048
		local origin = Vector(-12800, 11456)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 640
		local width = 1536
		local origin = Vector(-13056, 10816)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 528
		local width = 804
		local origin = Vector(-13396, 10560)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})

		local height = 896
		local width = 867
		local origin = Vector(-13746, 10581)
		local bl_vertex = origin-Vector(width/2, height/2)
		local tr_vertex = origin+Vector(width/2, height/2)
		table.insert(vertices, {bl_vertex, tr_vertex})
	end
	return vertices
end

function Winterblight:ResetChamber(hero, chamber)
	if Winterblight.CavernData.Chambers[chamber]["status"] == 1 then
		Winterblight.CavernData.Chambers[chamber]["status"] = 2
		local event_index = Winterblight.CavernData.Chambers[chamber]["event"]
		Winterblight.CavernData.Chambers[chamber]["events"][event_index]["status"] = 0
		CustomGameEventManager:Send_ServerToAllClients("cavern_summary_init", {chamber_data = Winterblight.CavernData.Chambers, fragments = Winterblight.CavernData.RelicsFragments})
		EmitSoundOn("Winterblight.Cavern.EventLose", hero)
		ClearChamberUnits(chamber)
		local time = #Winterblight.CavernUnits[chamber]*0.03 + 6
		Timers:CreateTimer(time, function()
			Winterblight.CavernData.Chambers[chamber]["status"] = 0
			CustomGameEventManager:Send_ServerToAllClients("cavern_summary_init", {chamber_data = Winterblight.CavernData.Chambers, fragments = Winterblight.CavernData.RelicsFragments})
		end)
	end
end

function ClearChamberUnits(chamber)
	for i = 1, #Winterblight.CavernUnits[chamber], 1 do
		Timers:CreateTimer(i*0.03, function()
			local unit = Winterblight.CavernUnits[chamber][i]
			if IsValidEntity(unit) then
				if unit.pfx then
					ParticleManager:DestroyParticle(unit.pfx, false)
				end
				CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", unit:GetAbsOrigin(), 4)
				EmitSoundOn("Winterblight.GuideCaveIntro", unit)
				UTIL_Remove(unit)
			end
		end)
	end
	for i = 1, #Winterblight.CavernPFXs[chamber], 1 do
		ParticleManager:DestroyParticle(Winterblight.CavernPFXs[chamber][i], false)
	end
	if chamber == 3 and Winterblight.CavernData.Chambers[3]["event"] == 4 then
		Winterblight:OceanOnslaughtWaterProp(true)
	end
end

function Winterblight:CompleteChamberEvent(chamber, position)
	if Winterblight.CavernData.Chambers[chamber]["status"] == 1 then
		EmitSoundOnLocationWithCaster(position, "Winterblight.Cavern.RelicPop", Events.GameMaster)

		Winterblight.CavernData.Chambers[chamber]["status"] = 3

		CustomGameEventManager:Send_ServerToAllClients("cavern_summary_init", {chamber_data = Winterblight.CavernData.Chambers, fragments = Winterblight.CavernData.RelicsFragments})

		local event_index = Winterblight.CavernData.Chambers[chamber]["event"]
		local reward = Winterblight.CavernData.Chambers[chamber]["events"][event_index]["relic_fragments_reward"]
		local hero_index = Winterblight.CavernData.Chambers[chamber]["hero"]
		local hero = EntIndexToHScript(hero_index)
		local level = Winterblight.CavernData.Chambers[chamber]["level"]

		Winterblight.CavernData.Chambers[chamber]["events"][event_index]["status"] = 2
		Winterblight.CavernData.Chambers[chamber]["events"][event_index]["level"] = level
		-- if Beacons.cheats then
		-- 	Winterblight.CavernData.Chambers[chamber]["events"][event_index]["status"] = 0
		-- end
		local realm_breaker_level = Winterblight:realm_breaker_level()
		if realm_breaker_level > 0 then
			Winterblight.CavernData.realm_breaker_status = 0
			Winterblight.CavernData.realm_breaker_level = realm_breaker_level
		end
		Winterblight:DisperseRelicFragments(position, reward, hero, chamber, event_index)

		Winterblight:CavernEventWinItemDrop(level, position)

		Winterblight:CavernCompletionToServer(hero, chamber, event_index, level)
		ClearChamberUnits(chamber)
		Timers:CreateTimer(1, function()
			EmitSoundOnLocationWithCaster(position, "Winterblight.Cavern.Win", Events.GameMaster)
		end)
		Timers:CreateTimer(6.2, function()
			EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "Winterblight.GuideCaveIntro2", Events.GameMaster)
			CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", hero, 4)
		end)
		Timers:CreateTimer(10, function()
			Winterblight.CavernData.Chambers[chamber]["status"] = 0
			CustomGameEventManager:Send_ServerToAllClients("cavern_summary_init", {chamber_data = Winterblight.CavernData.Chambers, fragments = Winterblight.CavernData.RelicsFragments})
		end)	
	end
end

function Winterblight:DisperseRelicFragments(position, crystal_reward, hero, chamber, event_index)
	local relic_dummy_count = math.ceil(crystal_reward/100)
	for i = 1, relic_dummy_count, 1 do
		local crystal = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
		crystal:SetModelScale(0.9)
		crystal:SetOriginalModel("models/props_gameplay/rune_illusion01.vmdl")
		crystal:SetModel("models/props_gameplay/rune_illusion01.vmdl")
		local displacementVector = WallPhysics:rotateVector(Vector(1,1), 2*math.pi*i/relic_dummy_count)
		crystal:SetAbsOrigin(position+displacementVector*120)

		Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, crystal, "modifier_relic_fragment_think", {})
		crystal:FindAbilityByName("dummy_unit"):SetLevel(1)	
		local targetDirection = ((crystal:GetAbsOrigin()-hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		-- targetDirection = (targetDirection*24 + RandomVector(1)):Normalized()
		CustomAbilities:QuickParticleAtPoint("particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_anim_goldbreath.vpcf", crystal:GetAbsOrigin()+Vector(0,0,30), 4)
		crystal.phase = 0
		crystal.direction = targetDirection
		crystal.pushForce = 16
		crystal.liftForce = 18
		crystal.hero = hero
		crystal.relics = crystal_reward/relic_dummy_count
		crystal.chamber = chamber
		crystal.event_index = event_index
		StartAnimation(crystal, {duration=100, activity=ACT_DOTA_IDLE, rate=1})
	end
end

function Winterblight:CavernCompletionToServer(hero, chamber, event_index, level)
	local url = ROSHPIT_URL.."/champions/update_winterblight_cavern?winterblight=1"


	local hero_name = hero:GetUnitName()
	local playerID = hero:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local steam_id_long = tostring(PlayerResource:GetSteamID(playerID))

	url = url.."&steam_id".."="..steamID
	url = url.."&steam_id_long".."="..steam_id_long
	url = url.."&hero_name".."="..hero_name
	url = url.."&event_index".."="..event_index
	url = url.."&chamber_index".."="..chamber
	url = url.."&level".."="..level
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	print(url)
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			Winterblight:GetCaveMetaData()
		end
	end )
end

function Winterblight:SpawnCloakedPhantasm(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cloaked_phantasm", position, 0, 2, "Winterblight.CloakedPhantasm.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 55
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	stone.randomMissMin = 100
	stone.randomMissMax = 500
	Winterblight:SetPositionCastArgs(stone, 2000, 300, 1, FIND_ANY_ORDER)
	if Winterblight.Stones >= 3 then
		stone:AddAbility("arena_magic_immune_breakable_ability"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:SpawnBoar(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_boar", position, 0, 0, "Winterblight.Boar.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 52
	stone:SetRenderColor(220, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:FrozenFoyer3(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 242
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	Winterblight.Foyer3Kills = 0
	local chamber_id = msg.chamber
	local unitsTable = {}
	local portalPosTable = {Vector(-12397, 9093), Vector(-10618, 8347), Vector(-8960, 6912), Vector(-8415, 9743), Vector(-5258, 10071)}
	for i = 1, #portalPosTable, 1 do
		local groundPos = GetGroundPosition(portalPosTable[i], Events.GameMaster)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, groundPos, 500, 10, false)
		local portalPFX = CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/teleport_end_ti9.vpcf", groundPos, 0)
		ParticleManager:SetParticleControl(portalPFX, 3, groundPos)
		ParticleManager:SetParticleControl(portalPFX, 15, groundPos)
		table.insert(Winterblight.CavernPFXs[chamber_id], portalPFX)
	end
	Winterblight:Foyer3WaveRedirect(0)
end

function Winterblight:FrozenFoyer4(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 216
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local color_table = {"red", "blue", "yellow", "green", "purple"}
	Winterblight.MerkurioCrystalTable = WallPhysics:ShuffleTable(color_table)
	local chamber_id = msg.chamber
	local unitsTable = {}
	local crystalPosTable = {Vector(-12397, 9093), Vector(-10618, 8347), Vector(-8960, 6912), Vector(-8415, 9743), Vector(-5258, 10071)}
	for i = 1, #crystalPosTable, 1 do
		local groundPos = GetGroundPosition(crystalPosTable[i], Events.GameMaster)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, groundPos, 500, 10, false)
		local crystal = Winterblight:SpawnMerkurioCrystal(groundPos, i)
		table.insert(Winterblight.CavernUnits[chamber_id], crystal)
		local portalPFX = CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/teleport_end_ti9.vpcf", groundPos, 0)
		ParticleManager:SetParticleControl(portalPFX, 3, groundPos)
		ParticleManager:SetParticleControl(portalPFX, 15, groundPos)
		table.insert(Winterblight.CavernPFXs[chamber_id], portalPFX)
	end
end

function Winterblight:Foyer3WaveRedirect(kills)
	local chamber_id = 1
	local spawnphase = Winterblight.CavernData.Chambers[chamber_id]["spawnphase"]
	local portalPosTable = {Vector(-12397, 9093), Vector(-10618, 8347), Vector(-8960, 6912), Vector(-8415, 9743), Vector(-5258, 10071)}
	if kills == 0 then
		for k = 1, 8, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = Winterblight:SpawnBoar(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 30 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						if i%2 == 0 then
							local spawn = Winterblight:SpawnCloakedPhantasm(position, RandomVector(1))
							Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
							Winterblight:Foyer3SpawnEffect(spawn)
						else
							local spawn = Winterblight:SpawnBloodWraith(position, RandomVector(1))
							Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
							Winterblight:Foyer3SpawnEffect(spawn)
						end
					end		
				end
			end)
		end
	elseif kills == 50 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local spawn = Winterblight:SpawnCorporealRevenant(position, RandomVector(1))
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(spawn)
					end		
				end
			end)
		end
	elseif kills == 70 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local spawn = nil
						if k == 1 then
							spawn = Winterblight:SpawnCorporealRevenant(position, RandomVector(1))
						elseif k == 2 then
							spawn = Winterblight:SpawnHeartFreezer(position, RandomVector(1))
						elseif k == 3 then
							spawn = Winterblight:SpawnManaNull(position, RandomVector(1))
						elseif k == 4 then
							spawn = Winterblight:SpawnWinterRunner(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(spawn)
					end		
				end
			end)
		end
	elseif kills == 90 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local spawn =  Winterblight:SpawnWinterRunner(position, RandomVector(1))
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(spawn)
					end		
				end
			end)
		end
	elseif kills == 110 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						if i%2 == 0 then
							local spawn = Winterblight:SpawnScouringSharpa(position, RandomVector(1))
							Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
							Winterblight:Foyer3SpawnEffect(spawn)
						else
							local spawn = Winterblight:SpawnPolarBear(position, RandomVector(1))
							Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
							Winterblight:Foyer3SpawnEffect(spawn)
						end
					end		
				end
			end)
		end
	elseif kills == 130 then
		for k = 1, 5, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local spawn =  Winterblight:SpawnIceHaunter(position, RandomVector(1))
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(spawn)
					end		
				end
			end)
		end
	elseif kills == 155 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local spawn =  Winterblight:SpawnAzaleaSorceress(position, RandomVector(1))
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(spawn)
					end		
				end
			end)
		end
	elseif kills == 175 then
		for k = 1, 5, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local spawn =  Winterblight:SpawnFrostWhelpling(position, RandomVector(1))
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(spawn)
					end		
				end
			end)
		end
	elseif kills == 200 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local spawn = nil
						if k == 1 then
							spawn = Winterblight:SpawnDrillDigger(position, RandomVector(1))
						elseif k == 2 then
							spawn = Winterblight:SpawnBarbedHusker(position, RandomVector(1))
						elseif k == 3 then
							spawn = Winterblight:SpawnBarbedHusker(position, RandomVector(1))
						elseif k == 4 then
							spawn = Winterblight:SpawnCloakedPhantasm(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(spawn)
					end		
				end
			end)
		end
	elseif kills == 220 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local spawn = nil
						if k == 1 then
							spawn = Winterblight:SpawnCorporealRevenant(position, RandomVector(1))
						elseif k == 2 then
							spawn = Winterblight:SpawnCorporealRevenant(position, RandomVector(1))
						elseif k == 3 then
							spawn = Winterblight:SpawnWinterAssasin(position, RandomVector(1))
						elseif k == 4 then
							spawn = Winterblight:SpawnWinterAssasin(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Foyer3SpawnEffect(spawn)
					end		
				end
			end)
		end
	end
end

function Winterblight:Foyer3SpawnEffect(unit)
	local level = Winterblight.CavernData.Chambers[1]["level"]
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/portal_spawn.vpcf", unit:GetAbsOrigin()+Vector(0,0,60), 2.5)
	EmitSoundOn("Winterblight.Foyer3.Spawn", unit)
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_foyer_3_regen", {})
	local stacks = math.min(level, 20)
	unit:SetModifierStackCount("modifier_foyer_3_regen", Winterblight.Master, stacks)
	Dungeons:AggroUnit(unit)
	unit:SetAcquisitionRange(8000)
end

function Winterblight:SpawnCorporealRevenant(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_corporeal_revenant", position, 0, 2, "Winterblight.Cavern.CorporealRevenant.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 55
	Events:ColorWearablesAndBase(stone, Vector(150, 180, 255))
	stone.dominion = true
	stone.randomMissMin = 300
	stone.randomMissMax = 800
	Winterblight:SetPositionCastArgs(stone, 1600, 300, 1, FIND_ANY_ORDER)
	if Winterblight.Stones >= 3 then
		stone:AddAbility("armor_break_ultra"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:MerkurioEventThink(caster)
	if not caster.event_phase then
		caster.event_phase = 0
		EmitSoundOn("Winterblight.Merkurio.EventStart", caster)
		StartAnimation(caster, {duration=5, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8})
	end
	if caster.event_phase == 0 then
		caster.event_phase = 1
	elseif caster.event_phase == 1 then
		local targetPos = Vector(-6788, 9237)
		caster:MoveToPosition(targetPos)
		local distance = WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin())
		if distance < 100 then
			caster.summon_phase = 0
			caster.event_phase = 2
			EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
		end
	elseif caster.event_phase == 2 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase%2 == 1 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnPolarBear(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			else
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnRelict(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase == 7 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 10 then
				caster.event_phase = 3
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	elseif caster.event_phase == 3 then
		local targetPos = Vector(-5864, 10226)
		caster:MoveToPosition(targetPos)
		local distance = WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin())
		if distance < 100 then
			caster.summon_phase = 0
			caster.event_phase = 4
		end		
	elseif caster.event_phase == 4 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase == 1 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnBeguiler(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 2 then
				for i = 1, 2, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnDrillDigger(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase > 2 then
				for i = 1, 2, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnIceHaunter(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase == 7 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 38 then
				caster.event_phase = 5
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	elseif caster.event_phase == 5 then
		local targetPos = Vector(-8265, 10092)
		caster:MoveToPosition(targetPos)
		local distance = WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin())
		if distance < 100 then
			caster.summon_phase = 0
			caster.event_phase = 6
		end
	elseif caster.event_phase == 6 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase == 1 then
				for i = 1, 8, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnFrostWhelpling(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 2 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnPantheonKnight(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase > 2 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnCloakedPhantasm(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase == 7 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 56 then
				caster.event_phase = 7
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	elseif caster.event_phase == 7 then
		local targetPos = Vector(-9096, 8392)
		caster:MoveToPosition(targetPos)
		local distance = WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin())
		if distance < 100 then
			caster.summon_phase = 0
			caster.event_phase = 8
		end
	elseif caster.event_phase == 8 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase == 1 then
				for i = 1, 8, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnFrostiok(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 2 then
				for i = 1, 8, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:Snowshaker(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 3 or caster.summon_phase == 4 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnManaNull(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase > 4 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnAzaleaSorceress(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase > 6 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 86 then
				caster.event_phase = 9
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	elseif caster.event_phase == 9 then
		local targetPos = Vector(-11044, 10194)
		caster:MoveToPosition(targetPos)
		local distance = WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin())
		if distance < 100 then
			caster.summon_phase = 0
			caster.event_phase = 10
		end
	elseif caster.event_phase == 10 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase == 1 then
				for i = 1, 8, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnFrostElemental(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 2 then
				for i = 1, 8, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnFrostAvatar(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase > 2 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnBloodWraith(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase > 6 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 106 then
				caster.event_phase = 11
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	elseif caster.event_phase == 11 then
		local targetPos = Vector(-11908, 9380)
		caster:MoveToPosition(targetPos)
		local distance = WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin())
		if distance < 100 then
			caster.summon_phase = 0
			caster.event_phase = 12
		end
	elseif caster.event_phase == 12 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase == 1 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnDrillDigger(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 2 then
				for i = 1, 8, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnBarbedHusker(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase > 2 then
				for i = 1, 2, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnBeguiler(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase > 6 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 136 then
				caster.event_phase = 13
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	elseif caster.event_phase == 13 then
		local targetPos = Vector(-9350, 6863)
		caster:MoveToPosition(targetPos)
		local distance = WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin())
		if distance < 100 then
			caster.summon_phase = 0
			caster.event_phase = 14
		end
	elseif caster.event_phase == 14 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase == 1 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnCloakedPhantasm(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 2 then
				for i = 1, 8, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnShineMegmus(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase > 2 then
				for i = 1, 2, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnCorporealRevenant(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase == 7 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 156 then
				caster.event_phase = 15
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	elseif caster.event_phase == 15 then
		local targetPos = Vector(-7136, 8125)
		caster:MoveToPosition(targetPos)
		local distance = WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin())
		if distance < 100 then
			caster.summon_phase = 0
			caster.event_phase = 16
		end
	elseif caster.event_phase == 16 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase == 1 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnCloakedPhantasm(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 2 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnBloodWraith(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 3 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnCorporealRevenant(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 4 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnManaNull(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 5 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnBeguiler(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 6 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnDrillDigger(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase == 7 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 186 then
				caster.event_phase = 17
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	elseif caster.event_phase == 17 then
		if caster.summon_phase <= 6 then
			StartAnimation(caster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
			EmitSoundOn("Winterblight.Merkurio.GustEvent", caster)
			for i = 1, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
				ParticleManager:SetParticleControl(pfx, 1, fv*1000)
				ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
			end
			local baseFV = RandomVector(1)
			caster.summon_phase = caster.summon_phase + 1
			if caster.summon_phase == 1 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:DrillDigger(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 2 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnWinterRunner(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 3 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnWinterRunner(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 4 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnManaNull(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 5 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnBeguiler(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			elseif caster.summon_phase == 6 then
				for i = 1, 4, 1 do
					local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
					local spawnPos = caster:GetAbsOrigin()+fv*320
					local spawn = Winterblight:SpawnSourceRevenant(spawnPos, fv)
					Winterblight:SetCavernUnit(spawn, spawnPos, false, false, 1)
					Winterblight:MerkurioSpawnEffect(caster, spawn)
				end
			end
		elseif caster.summon_phase == 7 then
			if Winterblight.CavernData.Chambers[1]["progress"] >= 206 then
				caster.event_phase = 18
				EmitSoundOn("Winterblight.Merkurio.Laugh", caster)
			end
		end
	end
end

function Winterblight:MerkurioSpawnEffect(caster, unit)
	local particleName = "particles/roshpit/winterblight/blue_beam_attack_light_ti_5.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,caster:GetAttachmentOrigin(0)+Vector(0,0,90))   
    ParticleManager:SetParticleControl(pfx,1,unit:GetAbsOrigin()+Vector(0,0,322))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/portal_spawn.vpcf", unit:GetAbsOrigin()+Vector(0,0,60), 2.5)
end

function Winterblight:SpawnMerkurioCrystal(position, type_index)
	local position = GetGroundPosition(position, Events.GameMaster) + Vector(0,0,300)
	local crystal = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	local yaw = RandomInt(0, 345)

	crystal:SetAngles(0, yaw, 0)

	crystal:SetModelScale(1.5)
	crystal:SetOriginalModel("models/winterblight/azalea_crystal.vmdl")
	crystal:SetModel("models/winterblight/azalea_crystal.vmdl")
	crystal:SetAbsOrigin(position)

	crystal:RemoveAbility("dummy_unit")
	crystal:RemoveModifierByName("dummy_unit")
	crystal.basePosition = position

	crystal.yaw = yaw
	crystal:AddAbility("winterblight_merkurio_event_crystal"):SetLevel(1)
	crystal.pushLock = true
	crystal.dummy = true
	crystal.jumpLock = true
	local crystal_color = Winterblight.MerkurioCrystalTable[type_index]

	if crystal_color == "red" then
		crystal:SetRenderColor(220, 100, 100)
	elseif crystal_color == "blue" then
		crystal:SetRenderColor(100, 100, 220)
	elseif crystal_color == "yellow" then
		crystal:SetRenderColor(220, 220, 100)
	elseif crystal_color == "green" then
		crystal:SetRenderColor(100, 220, 100)
	elseif crystal_color == "purple" then
		crystal:SetRenderColor(220, 100, 220)
	end
	crystal.crystal_color = crystal_color
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", crystal, 3)
	return crystal
end

function Winterblight:SpawnBeguiler(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cavern_beguiler", position, 0, 2, "Winterblight.Beguiler.DisappearingAct.Highlight", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 55
	Events:ColorWearablesAndBase(stone, Vector(150, 180, 255))
	stone.dominion = true
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_ANY_ORDER)
	return stone
end

function Winterblight:SpawnFungalShaman(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_fungal_shaman", position, 0, 2, "Winterblight.FungalShaman.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 55
	Events:ColorWearablesAndBase(stone, Vector(150, 180, 255))
	stone.dominion = true
	stone.targetRadius = 550
	stone.autoAbilityCD = 1
	return stone
end

function Winterblight:Crystarium1(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 112
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local chamber_id = msg.chamber
	local unitsTable = {}
	local positionTable = {Vector(-12434, 7040), Vector(-13312, 6873), Vector(-12695, 6528), Vector(-13192, 6003), Vector(-14873, 4480), Vector(-14395, 4096), Vector(-14657, 3727), Vector(-15472, 6197), Vector(-15616, 5760)}
	for i = 1, #positionTable, 1 do
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			local fv = ((Vector(-11520, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
			local unit = Winterblight:SpawnFungalShaman(positionTable[i], fv)
			Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
		end
	end

	Timers:CreateTimer(1.5, function()
		local positionTable = {Vector(-14336, 7296), Vector(-15152, 5248), Vector(-14848, 3840), Vector(-12672, 4608), Vector(-11008, 4992), Vector(-10240, 3456)}
	    for i = 1, #positionTable, 1 do
	      Timers:CreateTimer(i*1.2, function()
	        local patrolPositionTable = {}
	        for j = 1, #positionTable, 1 do
	          local index = i + j
	          if index > #positionTable then
	            index = index - #positionTable
	          end
	          table.insert(patrolPositionTable, positionTable[index])
	        end
	        for j = 0, 1, 1 do
	          Timers:CreateTimer(j*0.8, function()
	          	if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
		            local elemental = Winterblight:SpawnHeartSlayer(positionTable[i]+RandomVector(RandomInt(1,180)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 12, 10, 220, patrolPositionTable)
		            Winterblight:SetCavernUnit(elemental, elemental:GetAbsOrigin(), true, true, chamber_id)
		        end
	          end)
	        end
	      end)
	    end
	end)

	Timers:CreateTimer(0.5, function()
		for i = 1, 12, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = RandomVector(1)
					local position = Vector(-10496, 4964) + RandomVector(RandomInt(0, 480))
					local unit = Winterblight:SpawnFungusMinion(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(1.5, function()
		for i = 1, 12, 1 do
			Timers:CreateTimer(i*0.2, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = RandomVector(1)
					local position = Vector(-13859, 3875) + RandomVector(RandomInt(0, 480))
					local unit = Winterblight:SpawnFungusMinion(position, fv)		
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(2.8, function()
		local positionTable = {Vector(-14336, 8064), Vector(-13952, 8317), Vector(-13638, 7936), Vector(-15376, 7552), Vector(-15585, 7136), Vector(-10465, 5519), Vector(-10178, 5224), Vector(-9856, 4974), Vector(-14848, 2821), Vector(-14393, 3098)}
		for i = 1, #positionTable, 1 do
			if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
				local fv = ((Vector(-11520, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
				local unit = Winterblight:SpawnSkullHunter(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)
	Timers:CreateTimer(4, function()
		local positionTable = {Vector(-15256, 7295), Vector(-15005, 2197), Vector(-13273, 4037), Vector(-9829, 4244)}
		for i = 1, #positionTable, 1 do
			if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
				local fv = ((Vector(-11520, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
				local unit = Winterblight:SpawnMundugu(positionTable[i], fv)
				Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
			end
		end
	end)

	Timers:CreateTimer(5, function()
		local positionTable = {Vector(-8832, 3712), Vector(-8960, 3456), Vector(-9344, 3328), Vector(-10624, 3459), Vector(-11136, 3328), Vector(-14902, 1543), Vector(-15232, 1474), Vector(-15488, 1664), Vector(-15574, 3036), Vector(-15699, 2754)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.15, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = ((Vector(-11520, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnCrystalist(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
				end
			end)
		end
	end)

	Timers:CreateTimer(6, function()
		local positionTable = {Vector(-15340, 6400), Vector(-15104, 6668), Vector(-15488, 6784), Vector(-13580, 5632), Vector(-13291, 5120), Vector(-13703, 4791), Vector(-11486, 5267), Vector(-10034, 4610)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.2, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = ((Vector(-11520, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnZectRider(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
				end
			end)
		end
	end)

	Timers:CreateTimer(8, function()
		local positionTable = {Vector(-15275, 5156), Vector(-15477, 4772), Vector(-15616, 4388), Vector(-14361, 6247), Vector(-14663, 5836), Vector(-14217, 5490), Vector(-12675, 4797), Vector(-11515, 5712), Vector(-11672, 4186)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.2, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = ((Vector(-11520, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnMushroomPixie(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
				end
			end)
		end
	end)

	Timers:CreateTimer(11, function()
		local positionTable = {Vector(-12800, 3584), Vector(-12416, 3714), Vector(-12646, 3968), Vector(-12293, 4096), Vector(-12160, 3800), Vector(-11904, 4096), Vector(-11681, 3712), Vector(-15467, 2838), Vector(-15249, 2538), Vector(-13976, 7611), Vector(-14396, 7808), Vector(-14720, 7752), Vector(-14336, 7402)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.2, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = ((Vector(-11520, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnCrystariumSpider(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(13, function()
		local positionTable = {Vector(-12160, 6365), Vector(-11776, 6016), Vector(-15488, 1536), Vector(-15488, 1792), Vector(-14243, 2609), Vector(-13996, 2824), Vector(-11648, 3712), Vector(-11264, 3830), Vector(-10880, 3917), Vector(-10624, 4168), Vector(-10459, 3917), Vector(-9088, 4405), Vector(-8809, 4174)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.12, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local fv = ((Vector(-11520, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnIcixel(positionTable[i], fv)
					Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
				end
			end)
		end
	end)

end

function Winterblight:SpawnHeartSlayer(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("crystarium_heart_slayer", position, 0, 2, "Winterblight.HeartStriker.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 55
	Events:ColorWearablesAndBase(stone, Vector(150, 180, 255))
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFungusMinion(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("fungal_minion", position, 0, 2, "Winterblight.FungalMinion.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	Events:ColorWearablesAndBase(stone, Vector(150, 180, 255))
	stone.dominion = true
	return stone

end

function Winterblight:SpawnSkullHunter(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_skull_hunter", position, 0, 2, "Winterblight.SkullHunter.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(40, 180, 255)
	stone.dominion = true
	if Winterblight.Stones >= 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(3)
	end
	stone.randomMissMin = 100
	stone.randomMissMax = 600
	Winterblight:SetPositionCastArgs(stone, 1500, 300, 1, FIND_ANY_ORDER)
	return stone
end

function Winterblight:SpawnMundugu(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("reclusive_mundunugu", position, 0, 2, "Winterblight.Mundugu.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	Events:ColorWearablesAndBase(stone, Vector(150, 180, 255))
	stone.dominion = true
	return stone

end

function Winterblight:SpawnCrystalist(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_crystalist", position, 0, 2, "Winterblight.Crystalist.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 54
	stone:SetRenderColor(40, 180, 255)
	stone.dominion = true
	Winterblight:SetPositionCastArgs(stone, 800, 300, 1, FIND_ANY_ORDER)
	return stone
end

function Winterblight:SpawnZectRider(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_zect_rider", position, 0, 2, "Winterblight.ZectRider.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 54
	Events:ColorWearablesAndBase(stone, Vector(150, 180, 255))
	stone.dominion = true
	return stone

end

function Winterblight:SpawnMushroomPixie(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_mushroom_pixie", position, 0, 2, "Winterblight.MushroomPixie.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 50
	stone:SetRenderColor(130, 180, 255)
	stone.dominion = true
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:SpawnCrystariumSpider(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("crystarium_brood_spider", position, 0, 2, "Winterblight.CrystariumSpider.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 60
	stone:SetRenderColor(80, 180, 255)
	stone.dominion = true
	Winterblight:SetPositionCastArgs(stone, 800, 300, 1, FIND_ANY_ORDER)
	return stone
end

function Winterblight:SpawnIcixel(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_icixel", position, 0, 2, "Winterblight.Icixle.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 60
	stone:SetRenderColor(80, 180, 255)
	stone.dominion = true
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:Crystarium2(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 290
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	Winterblight.Crystarium2Kills = 0
	local chamber_id = msg.chamber
	local unitsTable = {}
	local portalPosTable = {Vector(-15256, 7295), Vector(-15005, 2197), Vector(-13273, 4037), Vector(-12855, 6823), Vector(-9829, 4244)}
	for i = 1, #portalPosTable, 1 do
		local groundPos = GetGroundPosition(portalPosTable[i], Events.GameMaster)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, groundPos, 500, 10, false)
		local portalPFX = CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/teleport_end_ti9.vpcf", groundPos, 0)
		ParticleManager:SetParticleControl(portalPFX, 3, groundPos)
		ParticleManager:SetParticleControl(portalPFX, 15, groundPos)
		table.insert(Winterblight.CavernPFXs[chamber_id], portalPFX)
	end
	Winterblight:Crystarium2WaveRedirect(0)
end

function Winterblight:Crystarium2WaveRedirect(kills)
	local chamber_id = 3
	local spawnphase = Winterblight.CavernData.Chambers[chamber_id]["spawnphase"]
	local portalPosTable = {Vector(-15256, 7295), Vector(-15005, 2197), Vector(-13273, 4037), Vector(-12855, 6823), Vector(-9829, 4244)}
	if kills == 0 then
		for k = 1, 8, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = Winterblight:SpawnFungusMinion(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 38 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = Winterblight:SpawnTokiToki(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 57 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k%2 == 0 then
							boar = Winterblight:SpawnFungalShaman(position, RandomVector(1))
						else
							boar = Winterblight:SpawnIcixel(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end	
	elseif kills == 77 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k%2 == 0 then
							boar = Winterblight:SpawnFungalShaman(position, RandomVector(1))
						else
							boar = Winterblight:SpawnMushroomPixie(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end	
	elseif kills == 97 then
		for k = 1, 8, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k%2 == 0 then
							boar = Winterblight:SpawnBoar(position, RandomVector(1))
						else
							boar = Winterblight:SpawnFungusMinion(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end		
	elseif kills == 137 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnMundugu(position, RandomVector(1))
						else
							boar = Winterblight:SpawnZectRider(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end		
	elseif kills == 157 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnZectRider(position, RandomVector(1))
						elseif k == 2 then
							boar = Winterblight:SpawnDrillDigger(position, RandomVector(1))
						elseif k == 3 then
							boar = Winterblight:SpawnTokiToki(position, RandomVector(1))
						elseif k == 4 then
							boar = Winterblight:SpawnMushroomPixie(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end	
	elseif kills == 177 then
		for k = 1, 6, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k%2 == 0 then
							boar = Winterblight:SpawnCavernBat(position, RandomVector(1))
						else
							boar = Winterblight:SpawnCrystariumSpider(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end	
	elseif kills == 207 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k%2 == 0 then
							boar = Winterblight:SpawnSkullHunter(position, RandomVector(1))
						else
							boar = Winterblight:SpawnHeartSlayer(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end	
	elseif kills == 227 then	
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnSkullHunter(position, RandomVector(1))
						elseif k == 2 then
							boar = Winterblight:SpawnCrystariumSpider(position, RandomVector(1))
						elseif k == 3 then
							boar = Winterblight:SpawnFungalShaman(position, RandomVector(1))
						elseif k == 4 then
							boar = Winterblight:SpawnCorporealRevenant(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end	
	elseif kills == 247 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnHeartSlayer(position, RandomVector(1))
						elseif k == 2 then
							boar = Winterblight:SpawnCrystalist(position, RandomVector(1))
						elseif k == 3 then
							boar = Winterblight:SpawnIcixel(position, RandomVector(1))
						elseif k == 4 then
							boar = Winterblight:SpawnCloakedPhantasm(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end	
	elseif kills == 267 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnTokiToki(position, RandomVector(1))
						elseif k == 2 then
							boar = Winterblight:SpawnTokiToki(position, RandomVector(1))
						elseif k == 3 then
							boar = Winterblight:SpawnFungalShaman(position, RandomVector(1))
						elseif k == 4 then
							boar = Winterblight:SpawnMushroomPixie(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:Crystarium2SpawnEffect(boar)
					end		
				end
			end)
		end		
	end
end

function Winterblight:Crystarium2SpawnEffect(unit)
	local level = Winterblight.CavernData.Chambers[3]["level"]
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/portal_spawn.vpcf", unit:GetAbsOrigin()+Vector(0,0,60), 2.5)
	EmitSoundOn("Winterblight.Foyer3.Spawn", unit)
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_crystarium_2_atk_power", {})
	local stacks = level
	unit:SetModifierStackCount("modifier_crystarium_2_atk_power", Winterblight.Master, stacks)
	Dungeons:AggroUnit(unit)
	unit:SetAcquisitionRange(8000)
end

function Winterblight:AuroraPassage2SpawnEffect(unit)
	local level = Winterblight.CavernData.Chambers[2]["level"]
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/portal_spawn.vpcf", unit:GetAbsOrigin()+Vector(0,0,60), 2.5)
	EmitSoundOn("Winterblight.Foyer3.Spawn", unit)
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_aurora_passage_2_ms_as", {})
	local stacks = level
	unit:SetModifierStackCount("modifier_aurora_passage_2_ms_as", Winterblight.Master, stacks)
	Dungeons:AggroUnit(unit)
	unit:SetAcquisitionRange(8000)
end

function Winterblight:SpawnTokiToki(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_toki_toki", position, 0, 2, "Winterblight.TokiToki.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 60
	stone:SetRenderColor(80, 180, 255)
	stone.dominion = true
	return stone
end

function Winterblight:Crystarium3(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 240
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	Winterblight.Crystarium3Kills = 0
	local chamber_id = msg.chamber


	local positionTable = {Vector(-15232, 1792), Vector(-14735, 2176), Vector(-15232, 2304), Vector(-15488, 2688), Vector(-14720, 2688), Vector(-15441, 3328), Vector(-14976, 3328), Vector(-14464, 3328), Vector(-13965, 3456), Vector(-13440, 3456), Vector(-12800, 3456),
	Vector(-14464, 3840), Vector(-14976, 3840), Vector(-15488, 3840), Vector(-15488, 4608), Vector(-13965, 4096), Vector(-13440, 4096), Vector(-12800, 4096), Vector(-12288, 4096), Vector(-11401, 3584), Vector(-10752, 3584), Vector(-10112, 3584),
	Vector(-9472, 3584), Vector(-8960, 3773), Vector(-9472, 4096), Vector(-10512, 4011), Vector(-11122, 4096), Vector(-11762, 4096), Vector(-14976, 4608), Vector(-14464, 4608), Vector(-13965, 4608), Vector(-13440, 4608),
	Vector(-12800, 4608), Vector(-12288, 4608), Vector(-11763, 4608), Vector(-11122, 4608), Vector(-10512, 4480), Vector(-9658, 4480), Vector(-10112, 4864), Vector(-10512, 4864), Vector(-10678, 5248), Vector(-11123, 5248),
	Vector(-11762, 5120), Vector(-12288, 5248), Vector(-12800, 5248), Vector(-13440, 5120), Vector(-13965, 5120), Vector(-14336, 5120), Vector(-14848, 5120), Vector(-15488, 5120), Vector(-15488, 5888),
	Vector(-14848, 5888), Vector(-14377, 5888), Vector(-13824, 5888), Vector(-13298, 5888), Vector(-12800, 5760), Vector(-12288, 5760), Vector(-11648, 5760), Vector(-15488, 6272), Vector(-14848, 6272),
	Vector(-14377, 6528), Vector(-13824, 6400), Vector(-13298, 6400), Vector(-12800, 6272), Vector(-12288, 6272), Vector(-11648, 6272), Vector(-12288, 6784), Vector(-15263, 6784), Vector(-15590, 7168),
	Vector(-14859, 7257), Vector(-14464, 7257), Vector(-13952, 7424), Vector(-13440, 7168), Vector(-12928, 7168), Vector(-15222, 7680), Vector(-14464, 7808), Vector(-13952, 8192), Vector(-13952, 7808), Vector(-13440, 7728)}

	Winterblight.ShroomSpawnTable = WallPhysics:ShuffleTable(positionTable)
	Winterblight.ShroomsSpawned = 0

	for i = 1, 12, 1 do
		Timers:CreateTimer(i*0.5, function()
			Winterblight:SpawnNextShroom(spawnphase)
		end)
	end
end

function Winterblight:Crystarium4(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 240
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local chamber_id = msg.chamber
	if not Winterblight.SeaFortressPrecache then
		require('worlds/winterblight/extra/ocean_onslaught')
		Winterblight.SeaFortressPrecache = true
		Precache:SeaFortress()
	end
	Winterblight:OceanOnslaughtWaterProp(false)
	Winterblight.OnslaughtUnitsSpawned = 0
	for i = 1, 30, 1 do
		Timers:CreateTimer(i*0.2, function()
			Winterblight:SpawnNextOceanOnslaughtUnit(spawnphase)
		end)
	end
end

function Winterblight:OceanOnslaughtWaterProp(bDown)
	local waterProp = Entities:FindByNameNearest("DeepOceanOnslaughtWater", Vector(-12136, 4874), 5000)
	print(waterProp:GetEntityHandle())
	local currentZ = waterProp:GetAbsOrigin().z
	local targetZ = waterProp:GetAbsOrigin().z + 315
	if bDown then
		targetZ = waterProp:GetAbsOrigin().z - 315
	end
	local ticks = 500
	local delta = (targetZ - currentZ)/ticks
	for i = 1, ticks, 1 do
		Timers:CreateTimer(i*0.03, function()
			waterProp:SetAbsOrigin(waterProp:GetAbsOrigin()+Vector(0,0,delta))
		end)
	end
end

function Winterblight:SpawnDementedMushroom(position, fv, spawnphase)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_demented_mushroom", position, 0, 2, nil, fv, true)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 60
	stone:SetRenderColor(80, 180, 255)
	EmitSoundOn("Winterblight.DementedMushroom.VO.Spawn", stone)

	Events:smoothSizeChange(stone, 0.01, 2.0, 40)
	local ability = stone:FindAbilityByName("winterblight_shroom_procurement")
	local spellPoint = stone:GetAbsOrigin()
	local position = spellPoint
	local particleName = "particles/roshpit/winterblight/confusional_spores.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, stone)
	ParticleManager:SetParticleControl(particle1, 0, spellPoint)
	ParticleManager:SetParticleControl(particle1, 1, Vector(400, 100, 1))
	local enemies = FindUnitsInRadius(stone:GetTeamNumber(), spellPoint, nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)	
	EmitSoundOnLocationWithCaster(position, "Winterblight.ShroomProcure.Explode", stone)
	CustomAbilities:QuickAttachThinker(ability, stone, position, "modifier_shroom_procure_thinker", {duration = 5})
	StartAnimation(stone, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
	return stone
end

function Winterblight:RandomPointInChamber(chamber_id)
	local vertices = Winterblight.CavernChamberVertices[chamber_id]
	local randomVertex = vertices[RandomInt(1, #vertices)]
	local baseX = randomVertex[1].x
	local baseY = randomVertex[1].y
	local maxX = randomVertex[2].x
	local maxY = randomVertex[2].y

	local deltaX = maxX - baseX
	local deltaY = maxY - baseY

	local random_x = baseX + RandomInt(0, deltaX)
	local random_y = baseY + RandomInt(0, deltaY)
	return Vector(random_x, random_y)
end

function Winterblight:SpawnNextShroom(spawnphase)
	if Winterblight.CavernData.Chambers[3]["status"] == 1 then
		Winterblight.ShroomsSpawned = Winterblight.ShroomsSpawned + 1
		if Winterblight.ShroomsSpawned <= #Winterblight.ShroomSpawnTable then
			local randomPos = Winterblight.ShroomSpawnTable[Winterblight.ShroomsSpawned]
			local shroom = Winterblight:SpawnDementedMushroom(randomPos, RandomVector(1))
			Winterblight:SetCavernUnit(shroom, randomPos, true, true, 3)
			shroom.spawnphase = spawnphase
		end
	end
end

function Winterblight:SpawnShroomUnit(caster, position, shroom_unit_spawn_index)
	local spawnphase = caster.spawnphase
	if Winterblight:ShouldSpawnCaveUnit(3, spawnphase) then
		local unit = nil
		if shroom_unit_spawn_index == 1 then
			unit = Winterblight:SpawnZectRider(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 2 then
			unit = Winterblight:SpawnFungalShaman(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 3 then
			unit = Winterblight:SpawnFungusMinion(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 4 then
			unit = Winterblight:SpawnIcixel(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 5 then
			unit = Winterblight:SpawnCrystalist(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 6 then
			unit = Winterblight:SpawnCrystariumSpider(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 7 then
			unit = Winterblight:SpawnMushroomPixie(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 8 then
			unit = Winterblight:SpawnTokiToki(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 9 then
			unit = Winterblight:SpawnSkullHunter(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 10 then
			unit = Winterblight:SpawnHeartSlayer(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 11 then
			unit = Winterblight:SpawnCloakedPhantasm(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 12 then
			unit = Winterblight:SpawnCorporealRevenant(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 13 then
			unit = Winterblight:SpawnBarbedHusker(position, RandomVector(1))
		elseif shroom_unit_spawn_index == 14 then
			unit = Winterblight:SpawnBloodWraith(position, RandomVector(1))
		else
			unit = Winterblight:SpawnScouringSharpa(position, RandomVector(1))
		end
		Dungeons:AggroUnit(unit)
		Winterblight:SetCavernUnit(unit, unit:GetAbsOrigin(), false, false, 3)
	end
end

function Winterblight:AuroraPassage1(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 146
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local chamber_id = msg.chamber
	local unitsTable = {}
	local positionTable = {Vector(-7168, 12160), Vector(-6968, 12416), Vector(-6603, 12498), Vector(-6272, 12343), Vector(-6144, 12168), Vector(-4390, 14514), Vector(-4864, 14592), Vector(-4570, 14208), Vector(-4272, 13952)}
	for i = 1, #positionTable, 1 do
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
			local unit = Winterblight:SpawnGhostOfAurora(positionTable[i], fv)
			Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
		end
	end
	Timers:CreateTimer(1.5, function()
		local positionTable = {Vector(-4480, 12672), Vector(-7383, 12672), Vector(-6912, 13952), Vector(-4273, 13952), Vector(-4736, 15488), Vector(-7168, 15488), Vector(-10031, 15488), Vector(-10752, 13787), Vector(-9856, 12928), Vector(-8920, 14392)}
	    for i = 1, #positionTable, 1 do
	      Timers:CreateTimer(i*1.2, function()
	        local patrolPositionTable = {}
	        for j = 1, #positionTable, 1 do
	          local index = i + j
	          if index > #positionTable then
	            index = index - #positionTable
	          end
	          table.insert(patrolPositionTable, positionTable[index])
	        end
	        for j = 0, 2, 1 do
	          Timers:CreateTimer(j*0.8, function()
	          	if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
		            local elemental = Winterblight:SpawnCavernBat(positionTable[i]+RandomVector(RandomInt(1,220)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 12, 10, 320, patrolPositionTable)
		            Winterblight:SetCavernUnit(elemental, elemental:GetAbsOrigin(), true, true, chamber_id)
		        end
	          end)
	        end
	      end)
	    end
	end)
	Timers:CreateTimer(0.5, function()
		local positionTable = {Vector(-7953, 12800), Vector(-7986, 12416), Vector(-7680, 12535), Vector(-7552, 12259), Vector(-7936, 12171), Vector(-10662, 13952), Vector(-10880, 14215), Vector(-10624, 14464), Vector(-10496, 14215), Vector(-10240, 14336)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnCavernBovaur(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(1.5, function()
		local positionTable = {Vector(-6656, 12659), Vector(-7040, 12800), Vector(-6659, 13706), Vector(-6321, 13824)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnManaNull(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)	
	Timers:CreateTimer(3.5, function()
		local positionTable = {Vector(-7296, 14208), Vector(-6912, 14336), Vector(-9339, 13866), Vector(-9600, 13568), Vector(-3456, 13568)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnIceStealer(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(4.5, function()
		local positionTable = {Vector(-6144, 13696), Vector(-6067, 13952), Vector(-6170, 14208), Vector(-5941, 14464), Vector(-5850, 14208), Vector(-5796, 13952), Vector(-5879, 13824), Vector(-5879, 13650), Vector(-5632, 13705), Vector(-5581, 13952), Vector(-5581, 14171), Vector(-5706, 14392), Vector(-5654, 14592), Vector(-5376, 14393)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = Vector(-1,-0.1)
					local unit = Winterblight:SpawnBoar(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(6.5, function()
		local positionTable = {Vector(-5596, 12800), Vector(-5120, 12844), Vector(-5339, 12544), Vector(-5504, 12288), Vector(-5376, 12032), Vector(-5206, 12288)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnIcixel(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(7.5, function()
		local positionTable = {Vector(-9372, 12928), Vector(-9472, 12598), Vector(-9088, 12598), Vector(-8832, 12672), Vector(-8832, 12416), Vector(-9216, 12416)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = Vector(0.1, 1)
					local unit = Winterblight:SpawnCrystalist(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(8.0, function()
		local positionTable = {Vector(-10112, 12928), Vector(-9856, 12806), Vector(-9856, 13056)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = Vector(1, 0)
					local unit = Winterblight:SpawnDrillDigger(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(8.5, function()
		local positionTable = {Vector(-4736, 13888), Vector(-3840, 13952), Vector(-9344, 15744), Vector(-9728, 15744), Vector(-10165, 15744), Vector(-10368, 15488)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = Vector(0,-1)
					if i == 1 then
						fv = Vector(1,0)
					elseif i == 2 then
						fv = Vector(-1,0)
					end
					local unit = Winterblight:SpawnIceStealer(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(9.0, function()
		local positionTable = {Vector(-5888, 14062), Vector(-5888, 13696), Vector(-5580, 13952), Vector(-5888, 14506), Vector(-5504, 14418)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = Vector(-1, 0)
					local unit = Winterblight:SpawnBarbedHusker(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(10.5, function()
		local positionTable = {Vector(-7168, 13312), Vector(-6784, 13185), Vector(-8899, 13579), Vector(-10387, 14515), Vector(-8923, 15561), Vector(-3788, 12657), Vector(-4909, 14932), Vector(-2678, 14080)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnFrostOverwhelmer(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(11.5, function()
		local positionTable = {Vector(-4976, 12032), Vector(-4848, 12243), Vector(-4592, 12154), Vector(-3968, 14592), Vector(-3391, 14592), Vector(-3584, 14905), Vector(-3968, 15104), Vector(-3287, 15232), Vector(-3634, 15616)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					if i <= 3 then
						fv = Vector(0,1)
					end
					local unit = Winterblight:SpawnGiantSnowCrab(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(12.5, function()
		local positionTable = {Vector(-2991, 12789), Vector(-2991, 13393), Vector(-2678, 14720), Vector(-2678, 15360), Vector(-7168, 15616), Vector(-8420, 15616), Vector(-7808, 15616), Vector(-8576, 13056)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = Vector(0,-1)
					if i == #positionTable then
						fv = Vector(-0.3,1)
					end
					local unit = Winterblight:SpawnServantOfSaturn(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(13.5, function()
		local positionTable = {Vector(-10325, 13420), Vector(-10624, 13440), Vector(-10429, 13293), Vector(-10598, 13137)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnIceHaunter(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(14.5, function()
		local positionTable = {Vector(-8960, 13075), Vector(-9216, 13280), Vector(-7287, 15098), Vector(-7543, 14976), Vector(-7680, 15232), Vector(-7296, 15369), Vector(-7040, 15221), Vector(-10112, 15104), Vector(-10496, 14848), Vector(-9941, 14720), Vector(-10112, 14426)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					if i <=7 then
						fv = Vector(1,1)
					end
					local unit = Winterblight:SpawnZodiacOracle(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(15.5, function()
		local positionTable = {Vector(-4699, 12544), Vector(-4601, 12890), Vector(-4352, 12684), Vector(-4183, 13056)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-6618, 11772) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnZodiacOracle(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(16.5, function()
		local positionTable = {Vector(-6127, 15488), Vector(-5828, 15488), Vector(-5521, 15488), Vector(-5248, 15488)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = Vector(1,0)
					local unit = Winterblight:SpawnWinterRunner(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
end

function Winterblight:AuroraPassage2(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 290
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	Winterblight.AuroraPassage2Kills = 0

	local chamber_id = msg.chamber
	local unitsTable = {}
	local portalPosTable = {Vector(-10383, 14500), Vector(-8659, 14209), Vector(-6616, 12914), Vector(-4966, 15267), Vector(-2546, 14971)}
	for i = 1, #portalPosTable, 1 do
		local groundPos = GetGroundPosition(portalPosTable[i], Events.GameMaster)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, groundPos, 500, 10, false)
		local portalPFX = CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/teleport_end_ti9.vpcf", groundPos, 0)
		ParticleManager:SetParticleControl(portalPFX, 3, groundPos)
		ParticleManager:SetParticleControl(portalPFX, 15, groundPos)
		table.insert(Winterblight.CavernPFXs[chamber_id], portalPFX)
	end
	Winterblight:AuroraPassage2WaveRedirect(0)
end

function Winterblight:AuroraPassage2WaveRedirect(kills)
	local chamber_id = 2
	local spawnphase = Winterblight.CavernData.Chambers[chamber_id]["spawnphase"]
	local portalPosTable = {Vector(-10383, 14500), Vector(-8659, 14209), Vector(-6616, 12914), Vector(-4966, 15267), Vector(-2546, 14971)}
	if kills == 0 then
		for k = 1, 6, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = Winterblight:SpawnGhostOfAurora(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 27 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i == 1 then
							boar = Winterblight:SpawnStarSeeker(position, RandomVector(1))
						else
							boar = Winterblight:SpawnZodiacOracle(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 46 then
		for k = 1, 8, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i%2 == 0 then
							boar = Winterblight:SpawnBoar(position, RandomVector(1))
						else
							boar = Winterblight:SpawnCavernBat(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 84 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i == 1 then
							boar = Winterblight:SpawnIceStealer(position, RandomVector(1))
						else
							boar = Winterblight:SpawnCavernBovaur(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 102 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i == 1 then
							boar = Winterblight:SpawnFrostOverwhelmer(position, RandomVector(1))
						else
							boar = Winterblight:SpawnFrostiok(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 121 then
		for k = 1, 3, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i == 1 then
							boar = Winterblight:SpawnFrostOverwhelmer(position, RandomVector(1))
						else
							boar = Winterblight:SpawnZodiacOracle(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 135 then
		for k = 1, 5, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i <= 2 then
							boar = Winterblight:SpawnIceStealer(position, RandomVector(1))
						else
							boar = Winterblight:SpawnDrillDigger(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 159 then
		for k = 1, 6, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i > 4 then
							boar = Winterblight:SpawnServantOfSaturn(position, RandomVector(1))
						else
							boar = Winterblight:SpawnGhostOfAurora(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 188 then
		for k = 1, 3, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i == 1 then
							boar = Winterblight:SpawnFrostOverwhelmer(position, RandomVector(1))
						elseif i == 2 then
							boar = Winterblight:SpawnServantOfSaturn(position, RandomVector(1))
						else
							boar = Winterblight:SpawnIceStealer(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 200 then
		for k = 1, 6, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i == 1 then
							boar = Winterblight:SpawnIcixel(position, RandomVector(1))
						elseif i == 2 then
							boar = Winterblight:SpawnCrystalist(position, RandomVector(1))
						elseif i == 3 then
							boar = Winterblight:SpawnZectRider(position, RandomVector(1))
						else
							boar = Winterblight:SpawnWinterRunner(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 230 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = Winterblight:SpawnGiantSnowCrab(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 250 then
		for k = 1, 5, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if i == 1 then
							boar = Winterblight:SpawnFrostOverwhelmer(position, RandomVector(1))
						elseif i == 2 then
							boar = Winterblight:SpawnServantOfSaturn(position, RandomVector(1))
						elseif i == 3 then
							boar = Winterblight:SpawnIceStealer(position, RandomVector(1))
						elseif i == 4 then
							boar = Winterblight:SpawnCavernBovaur(position, RandomVector(1))
						else
							boar = Winterblight:SpawnZodiacOracle(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:AuroraPassage2SpawnEffect(boar)
					end		
				end
			end)
		end
	end
end

function Winterblight:SpawnGhostOfAurora(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_ghost_of_aurora", position, 0, 2, "Winterblight.GhostOfAurora.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	stone.randomMissMin = 300
	stone.randomMissMax = 800
	Winterblight:SetPositionCastArgs(stone, 1400, 300, 1, FIND_ANY_ORDER)
	return stone
end

function Winterblight:SpawnCavernBovaur(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cavern_bovaur", position, 0, 2, "Winterblight.CavernBovaur.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	stone.targetRadius = 750
	stone.autoAbilityCD = 1
	return stone
end

function Winterblight:SpawnIceStealer(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_icestealer", position, 0, 2, "Winterblight.IceStealer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrostOverwhelmer(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cavern_overwhelmer", position, 0, 2, "Winterblight.FrostOverwhelm.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	Timers:CreateTimer(0.03, function()
		stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="walk"})
	end)
	return stone
end

function Winterblight:SpawnGiantSnowCrab(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_giant_snow_crab", position, 0, 2, "Winterblight.FrostOverwhelm.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnServantOfSaturn(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_servant_of_saturn", position, 0, 2, "Winterblight.ServantOfSaturn.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnZodiacOracle(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_zodiac_oracle", position, 0, 2, "Winterblight.ZodiacOracle.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	Winterblight:SetPositionCastArgs(stone, 1500, 300, 1, FIND_ANY_ORDER)
	stone.position_cast_self = true
	return stone
end

function Winterblight:CavernEventWinItemDrop(level, position)
	local luck = RandomInt(1, 100)
	local item_drops = 0
	-- if luck < 10 then
	-- 	item_drops = 1
	-- elseif luck < 30 then
	-- 	item_drops = RandomInt(1, 2)
	-- elseif luck < 60 then
	-- 	item_drops = RandomInt(1, 3)
	-- elseif luck < 90 then
	-- 	item_drops = RandomInt(1, 4)
	-- else
	-- 	item_drops = RandomInt(1, 6)
	-- end
	item_drops = item_drops + RandomInt(0, 2)
	if level >= 10 then
		item_drops = item_drops + RandomInt(0, 2)
	end
	if level >= 20 then
		item_drops = item_drops + RandomInt(1, 2)
	end
	if level >= 30 then
		item_drops = item_drops + RandomInt(1, 2)
	end
	for i = 1, item_drops, 1 do
		RPCItems:RollItemtype(400, position, 5, 300)
	end
end

function Winterblight:SpawnThunderhideEgg(position, spawnphase, chamber)
	local egg = CreateUnitByName("boulderspine_viper_egg", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	egg:SetOriginalModel("models/custom_egg.vmdl")
	egg:SetModel("models/custom_egg.vmdl")
	local modelScale = RandomInt(350, 700) / 100
	egg:SetModelScale(modelScale)
	local colorVector = Vector(RandomInt(100, 255), RandomInt(100, 255), RandomInt(120, 255))
	egg:SetRenderColor(colorVector.x, colorVector.y, colorVector.z)
	egg.colorVector = colorVector
	egg:SetForwardVector(RandomVector(1))
	egg:AddAbility("winterblight_thunderhide_egg_ability"):SetLevel(1)
	egg.jumpLock = true
	egg.chamber = chamber
	egg.spawnphase = spawnphase
	egg.SetHullRadius(64)
	egg:SetAbsOrigin(egg:GetAbsOrigin()-Vector(0,0,20))
	egg.size = modelScale
	return egg
end

function Winterblight:SpawnThunderhide(position, fv, colorVector)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cavern_thunderhide", position, 0, 2, "Winterblight.Thunderhide.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 55
	stone:SetRenderColor(colorVector.x, colorVector.y, colorVector.z)
	-- stone.dominion = true
	-- dominion too buggy on this unit
	Winterblight:SetPositionCastArgs(stone, 1500, 300, 1, FIND_ANY_ORDER)
	stone.position_cast_self = true
	return stone
end

function Winterblight:AuroraPassage3(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 100
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local chamber_id = msg.chamber

	for i = 1, 120, 1 do
		Timers:CreateTimer(0.1*i, function()
			local position = Winterblight:RandomAuroraPassagePos()
			local egg = Winterblight:SpawnThunderhideEgg(position, spawnphase, chamber_id)
			CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", egg:GetAbsOrigin()+Vector(0,0,30), 4)
			EmitSoundOn("Winterblight.GuideCaveIntro", egg)
			table.insert(Winterblight.CavernUnits[chamber_id], egg)
		end)
	end
end

function Winterblight:AuroraPassage4(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 3
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local chamber_id = msg.chamber
	local positionTable = {Vector(-3840, 15104), Vector(-7040, 12800), Vector(-10368, 15104)}
	local boss_names = {"winterblight_aurora_boss_1", "winterblight_aurora_boss_2", "winterblight_aurora_boss_3"}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
      	if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
            local elemental = Winterblight:SpawnAuroraBoss(boss_names[i], positionTable[i], RandomVector(1))
            Winterblight:AddPatrolArguments(elemental, 22, 10, 220, patrolPositionTable)
            Winterblight:SetCavernUnit(elemental, elemental:GetAbsOrigin(), true, true, chamber_id)
        end
      end)
    end
	
end

function Winterblight:RandomAuroraPassagePos()
	local luck = RandomInt(1, 352)
	local position = Vector(0,0)
	if luck <= 279 then
		local height = 3410
		local width = 8190
		local origin = Vector(-6976, 14476)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	elseif luck <= 287 then
		local height = 1129
		local width = 5650
		local origin = Vector(-6125, 12268)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	elseif luck <= 297 then	
		local height = 660
		local width = 1437
		local origin = Vector(-9678, 12469)
		local bl_vertex = origin-Vector(width/2, height/2)	
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	else
		local height = 4189
		local width = 1280
		local origin = Vector(-2816, 14401)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	end
	return position
end

function Winterblight:SpawnAuroraBoss(unit_name, position, fv)
	local aggro_sound = nil
	if unit_name == "winterblight_aurora_boss_1" then
		aggro_sound = "Winterblight.AuroraBosses.1.Aggro"
	elseif unit_name == "winterblight_aurora_boss_2" then
		aggro_sound = "Winterblight.AuroraBosses.2.Aggro"
	elseif unit_name == "winterblight_aurora_boss_3" then
		aggro_sound = "Winterblight.AuroraBosses.3.Aggro"
	end
	local stone = Winterblight:SpawnDungeonUnit(unit_name, position, 1, 2, aggro_sound, fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 75
	stone:SetRenderColor(170, 200, 255)
	stone.pushLock = true
	stone.jumpLock = true
	stone:SetHullRadius(190)
	return stone
end

function Winterblight:EdgeOfWinter1(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 126
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local chamber_id = msg.chamber
	local unitsTable = {}
	local positionTable = {Vector(-13824, 10688), Vector(-13440, 10949), Vector(-12928, 11952), Vector(-12534, 12159), Vector(-12160, 12032)}
	for i = 1, #positionTable, 1 do
		local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
		local unit =  Winterblight:SpawnSpaceShark(positionTable[i], fv)
		if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
			Winterblight:SetCavernUnit(unit, positionTable[i], true, true, chamber_id)
		end
	end

	Timers:CreateTimer(0.5, function()
		local positionTable = {Vector(-15488, 9344), Vector(-14720, 9472), Vector(-15616, 10752), Vector(-15104, 11904), Vector(-14080, 11520), Vector(-13696, 12288), Vector(-14976, 13056), Vector(-12672, 13952), Vector(-15744, 14592), Vector(-14592, 15232), Vector(-12928, 15232), Vector(-11904, 15232)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnBoneBlister(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)

	Timers:CreateTimer(0.9, function()
		local positionTable = {Vector(-15744, 8724), Vector(-15360, 8576), Vector(-14976, 8832)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = Vector(0,1)
					local unit = Winterblight:SpawnSeaPortal(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(1.3, function()
		local positionTable = {Vector(-11722, 13092), Vector(-11958, 12937), Vector(-11718, 12772), Vector(-11980, 12672), Vector(-12160, 12416), Vector(-11904, 12416)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnCloakedPhantasm(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(2.1, function()
		local positionTable = {Vector(-15519, 10956), Vector(-15519, 11392), Vector(-14905, 11351), Vector(-14593, 11264), Vector(-14814, 11566), Vector(-14464, 11520), Vector(-13952, 11776), Vector(-13890, 12032), Vector(-15616, 9216), Vector(-15282, 9075), Vector(-15003, 9210), Vector(-14948, 9472)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnZodiacOracle(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(3.3, function()
		local positionTable = {Vector(-15744, 11520), Vector(-15744, 11136), Vector(-15744, 10752), Vector(-15009, 12624), Vector(-14668, 12928), Vector(-14229, 13082), Vector(-12454, 14976), Vector(-12800, 14976), Vector(-14720, 15146), Vector(-14411, 15257), Vector(-14592, 9728), Vector(-14592, 9088)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnStarEater(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(1.5, function()
		local positionTable = {Vector(-15488, 9216), Vector(-14976, 11392), Vector(-15616, 12800), Vector(-14592, 14592), Vector(-12032, 15360), Vector(-13184, 13184)}
	    for i = 1, #positionTable, 1 do
	      Timers:CreateTimer(i*1.2, function()
	        local patrolPositionTable = {}
	        for j = 1, #positionTable, 1 do
	          local index = i + j
	          if index > #positionTable then
	            index = index - #positionTable
	          end
	          table.insert(patrolPositionTable, positionTable[index])
	        end
	        for j = 0, 1, 1 do
	          Timers:CreateTimer(j*0.8, function()
	          	if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
		            local elemental = Winterblight:SpawnGalaxyKnight(positionTable[i]+RandomVector(RandomInt(1,180)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 12, 10, 220, patrolPositionTable)
		            Winterblight:SetCavernUnit(elemental, elemental:GetAbsOrigin(), true, true, chamber_id)
		        end
	          end)
	        end
	      end)
	    end
	end)
	Timers:CreateTimer(5.3, function()
		local positionTable = {Vector(-14336, 12288), Vector(-14613, 12544), Vector(-14390, 13037), Vector(-14080, 13231), Vector(-14223, 15700), Vector(-13929, 15700), Vector(-13629, 15700), Vector(-13327, 15700), Vector(-14026, 10240), Vector(-14139, 9984), Vector(-14208, 9472)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnFrozenKrow(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(6.3, function()
		local positionTable = {Vector(-15533, 9639), Vector(-15686, 9838), Vector(-15686, 10112)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnSoftwalker(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(7.3, function()
		local positionTable = {Vector(-14336, 12700), Vector(-14080, 12891), Vector(-13824, 13054), Vector(13457, 13157), Vector(-12544, 15488), Vector(-12160, 15640), Vector(-11776, 15640), Vector(-11776, 14720), Vector(-11904, 14336), Vector(-15252, 14336), Vector(-15360, 14585), Vector(-15699, 14464), Vector(-15532, 14208)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnMindChatterer(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(9.3, function()
		local positionTable = {Vector(-15616, 12347), Vector(-15232, 12347), Vector(-15232, 12032), Vector(-15360, 11776), Vector(-15607, 12032), Vector(-14464, 11136), Vector(-14168, 11061), Vector(-13947, 10880), Vector(-13696, 12800), Vector(-13385, 12800), Vector(-13097, 12888), Vector(-12800, 13027), Vector(-13073, 13439), Vector(-13385, 13184), Vector(-13696, 13214)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnWintertideMonk(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(11.3, function()
		local positionTable = {Vector(-12416, 13440), Vector(-12081, 13440), Vector(-11776, 13440), Vector(-11776, 13696), Vector(-12081, 13696), Vector(-12416, 13696), Vector(-12081, 13952), Vector(-11776, 13952)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnGalaxyKnight(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(12.3, function()
		local positionTable = {Vector(-13568, 13824), Vector(-13304, 13923), Vector(-13696, 14015), Vector(-13440, 14125), Vector(-13159, 14208), Vector(-13696, 14311)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnSpaceShark(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(14.3, function()
		local positionTable = {Vector(-15104, 14788), Vector(-14976, 14336), Vector(-14592, 14494), Vector(-14732, 14976)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnWintersChieftain(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
	Timers:CreateTimer(16.3, function()
		local positionTable = {Vector(-13657, 14720), Vector(-13990, 14720), Vector(-14208, 14976), Vector(-13859, 14976)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					local position = positionTable[i]
					local fv = ((Vector(-12288, 11136) - positionTable[i])*Vector(1,1,0)):Normalized()
					local unit = Winterblight:SpawnGhostOfAurora(position, fv)
					Winterblight:SetCavernUnit(unit, position, true, true, chamber_id)
				end
			end)
		end
	end)
end

function Winterblight:SpawnSpaceShark(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_space_shark", position, 0, 2, "Winterblight.SpaceShark.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 245, 185)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnBoneBlister(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winter_bone_blister", position, 0, 2, "Winterblight.BoneBlister.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 245, 185)
	stone.dominion = true
	Winterblight:SetPositionCastArgs(stone, 1200, 300, 1, FIND_ANY_ORDER)
	stone.randomMissMin = 340
	stone.randomMissMax = 500
	return stone

end

function Winterblight:SpawnSeaPortal(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("sea_fortress_sea_portal", position, 1, 3, "Seafortress.SeaPortal.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 140, 255)
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetPositionCastArgs(queen, 1400, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Winterblight:SpawnStarEater(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_star_eater", position, 0, 2, "Winterblight.StarEater.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	Events:ColorWearablesAndBase(stone, Vector(220, 140, 255))
	stone.dominion = true
	return stone
end

function Winterblight:SpawnGalaxyKnight(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_galaxy_knight", position, 0, 2, "Winterblight.GalaxyKnight.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	Events:ColorWearablesAndBase(stone, Vector(120, 140, 245))
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrozenKrow(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("winterblight_frozen_krow", position, 0, 3, "Winterblight.Krow.Aggro", fv, false)
  queen.dominion = true
  Events:ColorWearablesAndBase(queen, Vector(100, 140, 245))
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetPositionCastArgs(queen, 1700, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Winterblight:SpawnMindChatterer(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("winterblight_mind_chatterer", position, 0, 3, "Winterblight.MindChatterer.Aggro", fv, false)
  queen.dominion = true
  Events:ColorWearablesAndBase(queen, Vector(100, 140, 245))
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetPositionCastArgs(queen, 1700, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Winterblight:SpawnWintertideMonk(position, fv)
	local queen = Winterblight:SpawnDungeonUnit("winterblight_wintertide_monk", position, 0, 3, "Winterblight.Wintertide.Aggro", fv, false)
	queen.dominion = true
	Events:ColorWearablesAndBase(queen, Vector(100, 140, 245))
	Events:AdjustBossPower(queen, 8, 8, false)
	Winterblight:SetPositionCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
	queen.randomMissMin = 200
	queen.randomMissMax = 600
	return queen
end

function Winterblight:SpawnWintersChieftain(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("winterblight_winters_chieftain", position, 0, 3, "Winterblight.MindChatterer.Aggro", fv, false)
  queen.dominion = true
  Events:ColorWearablesAndBase(queen, Vector(90, 140, 245))
  Events:AdjustBossPower(queen, 8, 8, false)
  -- Winterblight:SetPositionCastArgs(queen, 1700, 0, 1, FIND_ANY_ORDER)
  return queen
end
	
function Winterblight:EdgeOfWinter2(msg)
	local spawnphase = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 275
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	Winterblight.EdgeOfWinter2Kills = 0

	local chamber_id = msg.chamber
	local unitsTable = {}
	local portalPosTable = {Vector(-15372, 8850), Vector(-13179, 11682), Vector(-14955, 12527), Vector(-15503, 14832), Vector(-11833, 15277)}
	for i = 1, #portalPosTable, 1 do
		local groundPos = GetGroundPosition(portalPosTable[i], Events.GameMaster)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, groundPos, 500, 10, false)
		local portalPFX = CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/teleport_end_ti9.vpcf", groundPos, 0)
		ParticleManager:SetParticleControl(portalPFX, 3, groundPos)
		ParticleManager:SetParticleControl(portalPFX, 15, groundPos)
		table.insert(Winterblight.CavernPFXs[chamber_id], portalPFX)
	end
	Winterblight:EdgeOfWinter2WaveRedirect(0)
end

function Winterblight:EdgeOfWinter2WaveRedirect(kills)
	local chamber_id = 4
	local spawnphase = Winterblight.CavernData.Chambers[chamber_id]["spawnphase"]
	local portalPosTable = {Vector(-15372, 8850), Vector(-13179, 11682), Vector(-14955, 12527), Vector(-15503, 14832), Vector(-11833, 15277)}
	if kills == 0 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = Winterblight:SpawnSpaceShark(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 17 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k < 3 then
							boar = Winterblight:SpawnBoneBlister(position, RandomVector(1))
						else
							boar = Winterblight:SpawnFrozenKrow(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 36 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnZodiacOracle(position, RandomVector(1))
						else
							boar = Winterblight:SpawnStarEater(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 56 then
		for k = 1, 6, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnFrozenKrow(position, RandomVector(1))
						else
							boar = Winterblight:SpawnCorporealRevenant(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 85 then
		for k = 1, 5, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k < 4 then
							boar = Winterblight:SpawnGalaxyKnight(position, RandomVector(1))
						else
							boar = Winterblight:SpawnBoneBlister(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 110 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k < 3 then
							boar = Winterblight:SpawnMindChatterer(position, RandomVector(1))
						else
							boar = Winterblight:SpawnStarEater(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 130 then
		for k = 1, 5, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k < 3 then
							boar = Winterblight:SpawnWintertideMonk(position, RandomVector(1))
						else
							boar = Winterblight:SpawnGalaxyKnight(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 155 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k < 3 then
							boar = Winterblight:SpawnWintertideMonk(position, RandomVector(1))
						elseif k == 3 then
							boar = Winterblight:SpawnMindChatterer(position, RandomVector(1))
						elseif k == 4 then
							boar = Winterblight:SpawnWintersChieftain(position, RandomVector(1))
						end
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 174 then
		for k = 1, 6, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						boar = Winterblight:SpawnGalaxyKnight(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 204 then
		for k = 1, 4, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnGhostOfAurora(position, RandomVector(1))
						elseif k == 2 then
							boar = Winterblight:SpawnSpectralWitch(position, RandomVector(1))
						elseif k == 3 then
							boar = Winterblight:SpawnMindChatterer(position, RandomVector(1))
						elseif k == 4 then
							boar = Winterblight:SpawnStarEater(position, RandomVector(1))
						end
						boar = Winterblight:SpawnGalaxyKnight(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 224 then
		for k = 1, 5, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k == 1 then
							boar = Winterblight:SpawnWintertideMonk(position, RandomVector(1))
						elseif k == 2 then
							boar = Winterblight:SpawnMindChatterer(position, RandomVector(1))
						elseif k == 3 then
							boar = Winterblight:SpawnSpaceShark(position, RandomVector(1))
						elseif k == 4 then
							boar = Winterblight:SpawnWintersChieftain(position, RandomVector(1))
						elseif k == 5 then
							boar = Winterblight:SpawnFrozenKrow(position, RandomVector(1))
						end
						boar = Winterblight:SpawnGalaxyKnight(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	elseif kills == 248 then
		for k = 1, 5, 1 do
			Timers:CreateTimer(k*1.5, function()
				if Winterblight:ShouldSpawnCaveUnit(chamber_id, spawnphase) then
					for i = 1, #portalPosTable, 1 do
						local position = portalPosTable[i]
						local boar = nil
						if k < 5 then
							boar = Winterblight:SpawnWintersChieftain(position, RandomVector(1))
						elseif k == 5 then
							boar = Winterblight:SpawnWintertideMonk(position, RandomVector(1))
						end
						boar = Winterblight:SpawnGalaxyKnight(position, RandomVector(1))
						Winterblight:SetCavernUnit(boar, boar:GetAbsOrigin(), false, false, chamber_id)
						Winterblight:EdgeOfWinter2SpawnEffect(boar)
					end		
				end
			end)
		end
	end
end

function Winterblight:EdgeOfWinter2SpawnEffect(unit)
	local level = Winterblight.CavernData.Chambers[4]["level"]
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/portal_spawn.vpcf", unit:GetAbsOrigin()+Vector(0,0,60), 2.5)
	EmitSoundOn("Winterblight.Foyer3.Spawn", unit)
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_edge_of_winter_2_armor_evasion", {})
	local stacks = level
	unit:SetModifierStackCount("modifier_edge_of_winter_2_armor_evasion", Winterblight.Master, stacks)
	Dungeons:AggroUnit(unit)
	unit:SetAcquisitionRange(8000)
end

function Winterblight:EdgeOfWinter3(msg)

	local chamber_id = msg.chamber
	local spawnphase = Winterblight.CavernData.Chambers[chamber_id]["spawnphase"]
	
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	local level = Winterblight.CavernData.Chambers[4]["level"]
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 200 + level*5
	Winterblight.ChrolonusUnitsSpawned = 0
	local amount = math.floor(6 + level*0.5)
	for i = 1, amount, 1 do
		Timers:CreateTimer(0.3*i, function()
			Winterblight:SpawnNextChrolonus(spawnphase)
		end)
	end
end

function Winterblight:SpawnNextChrolonus(spawnphase)
	local positionTable = {Vector(-14464, 11247, 188), Vector(-13042, 11776, 256), Vector(-13824, 12253, 512), Vector(-15104, 11520, 512), Vector(-14464, 12928, 188), Vector(-13440, 12928, 512), Vector(-13440, 13824, 512), Vector(-14592, 14931, 512), Vector(-12160, 14931, 512)}
	local zBonus = 240
	local position = positionTable[RandomInt(1, #positionTable)]
	if Winterblight:ShouldSpawnCaveUnit(4, spawnphase) and Winterblight.ChrolonusUnitsSpawned < Winterblight.CavernData.Chambers[4]["goal"] then
		local unit = Winterblight:SpawnCavernChrolonus(position, fv)
		local descend_point = position + Vector(0,0,zBonus)
		Winterblight:UnitDescendFromOrb(unit, descend_point)
		unit:SetModelScale(0.01)
		Dungeons:AggroUnit(unit)
		Winterblight:SetCavernUnit(unit, unit:GetAbsOrigin(), false, false, 4)
		Winterblight.ChrolonusUnitsSpawned = Winterblight.ChrolonusUnitsSpawned + 1
		unit.spawnphase = spawnphase
		unit.cavern_chronolus = true
		Events:smoothSizeChange(unit, 0.01, 1.9, 30)
	end
end

function Winterblight:SpawnCavernChrolonus(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_chrolonus", position, 0, 1, "Winterblight.CavernChrolonus.Aggro", fv, false)
	Events:AdjustBossPower(stone, 8, 8, false)
	stone.itemLevel = 65
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(3)
		stone:RemoveAbility("normal_steadfast")
		stone:RemoveModifierByName("modifier_steadfast")
		stone:AddAbility("mega_steadfast"):SetLevel(3)
		if Winterblight.Stones > 0 then
			stone:AddAbility("armor_break_ultra"):SetLevel(Winterblight.Stones)
		end
	end

	return stone
end

function Winterblight:EdgeOfWinter4(msg)
	local chamber_id = msg.chamber
	local spawnphase = Winterblight.CavernData.Chambers[chamber_id]["spawnphase"]
	
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 220
	Winterblight.EdgeOfWinterBlackHoles = {}
	Winterblight.BlackHolesKills = 0
	local position = Winterblight:RandomPointInEdgeOfWinter()
	Winterblight:SpawnGravityBlackHole(position, spawnphase)
	Winterblight:GravityBlackHolesSpawns(Winterblight.BlackHolesKills)
end

function Winterblight:SpawnGravityBlackHole(position, spawnphase)
	local black_hole = CreateUnitByName("npc_flying_dummy_vision", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	black_hole:FindAbilityByName("dummy_unit"):SetLevel(1)	
	black_hole:AddAbility("winterblight_black_hole_ability"):SetLevel(1)
	table.insert(Winterblight.CavernUnits[4], black_hole)
	black_hole.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_blackhole.vpcf", PATTACH_ABSORIGIN_FOLLOW, black_hole)
	ParticleManager:SetParticleControl(black_hole.pfx, 0, black_hole:GetAbsOrigin())
	table.insert(Winterblight.EdgeOfWinterBlackHoles, black_hole)
	black_hole:SetBaseMoveSpeed(180)
	black_hole.spawnphase = spawnphase
end

function Winterblight:GravityBlackHolesSpawns(kills)
	if kills == 0 then
		for i = 1, #Winterblight.EdgeOfWinterBlackHoles, 1 do
			local black_hole = Winterblight.EdgeOfWinterBlackHoles[i]
			local black_hole_unit_index = RandomInt(1, 75)
			for k = 1, 4, 1 do
				print("WE GONNA SPAWN?")
				Timers:CreateTimer(k*0.2, function()
					Winterblight:SpawnBlackHoleUnitByIndex(black_hole, black_hole_unit_index)
				end)
			end
		end
	elseif kills == 4 or kills == 12 or kills == 24 or kills == 40 or kills == 60 or kills == 84 or kills == 112 or kills == 144 or kills == 180 then
		local position = Winterblight:RandomPointInEdgeOfWinter()
		Winterblight:SpawnGravityBlackHole(position, Winterblight.CavernData.Chambers[4]["spawnphase"])
		for i = 1, #Winterblight.EdgeOfWinterBlackHoles, 1 do
			local black_hole = Winterblight.EdgeOfWinterBlackHoles[i]
			local black_hole_unit_index = RandomInt(1, 76)
			for k = 1, 4, 1 do
				Timers:CreateTimer(k*1, function()
					Winterblight:SpawnBlackHoleUnitByIndex(black_hole, black_hole_unit_index)
				end)
			end
		end
	end
end

function Winterblight:SpawnBlackHoleUnitByIndex(black_hole, black_hole_unit_index)
	if Winterblight:ShouldSpawnCaveUnit(4, black_hole.spawnphase) then
		local unit = nil
		if black_hole_unit_index == 1 then
			unit = Winterblight:SpawnMountainOgre(position, Vector(0,-1))
		elseif black_hole_unit_index == 2 then
			unit = Winterblight:SpawnFrostiok(position, Vector(0,-1))
		elseif black_hole_unit_index == 3 then
			unit = Winterblight:SpawnIceMarauader(position, Vector(0,-1))
		elseif black_hole_unit_index == 4 then
			unit = Winterblight:SpawnMountainDweller(position, Vector(0,-1))
		elseif black_hole_unit_index == 5 then
			unit = Winterblight:SpawnChillingColossus(position, Vector(0,-1))
		elseif black_hole_unit_index == 6 then
			unit = Winterblight:Snowshaker(position, Vector(0,-1))
		elseif black_hole_unit_index == 7 then
			unit = Winterblight:FrigidGrowth(position, Vector(0,-1))
		elseif black_hole_unit_index == 8 then
			unit = Winterblight:SpawnDashingSwordsman(position, Vector(0,-1))
		elseif black_hole_unit_index == 9 then
			unit = Winterblight:SpawnWinterAssasin(position, Vector(0,-1))
		elseif black_hole_unit_index == 10 then
			unit = Winterblight:SpawnRiderOfAzalea(position, Vector(0,-1))
		elseif black_hole_unit_index == 11 then
			unit = Winterblight:SpawnAzaleaArcher(position, Vector(0,-1))
		elseif black_hole_unit_index == 12 then
			unit = Winterblight:SpawnAzaleaSorceress(position, Vector(0,-1))
		elseif black_hole_unit_index == 13 then
			unit = Winterblight:SpawnFrostAvatar(position, Vector(0,-1))
		elseif black_hole_unit_index == 14 then
			unit = Winterblight:SpawnFrostElemental(position, Vector(0,-1))
		elseif black_hole_unit_index == 15 then
			unit = Winterblight:SpawnFrostHulk(position, Vector(0,-1))
		elseif black_hole_unit_index == 16 then
			unit = Winterblight:SpawnPriestOfAzalea(position, Vector(0,-1))
		elseif black_hole_unit_index == 17 then
			unit = Winterblight:SpawnSoftwalker(position, Vector(0,-1))
		elseif black_hole_unit_index == 18 then
			unit = Winterblight:SpawnFrostWhelpling(position, Vector(0,-1))
		elseif black_hole_unit_index == 19 then
			unit = Winterblight:SpawnHeartFreezer(position, Vector(0,-1))
		elseif black_hole_unit_index == 20 then
			unit = Winterblight:SpawnAzaleaMaiden(position, Vector(0,-1))
		elseif black_hole_unit_index == 21 then
			unit = Winterblight:SpawnSyphist(position, Vector(0,-1))
		elseif black_hole_unit_index == 22 then
			unit = Winterblight:SpawnSourceRevenant(position, Vector(0,-1))
		elseif black_hole_unit_index == 23 then
			unit = Winterblight:SpawnAzaleaHighguard(position, Vector(0,-1))
		elseif black_hole_unit_index == 24 then
			unit = Winterblight:SpawnAzaleaMindbreaker(position, Vector(0,-1))
		elseif black_hole_unit_index == 25 then
			unit = Winterblight:SpawnGhostStriker(position, Vector(0,-1))
		elseif black_hole_unit_index == 26 then
			unit = Winterblight:SpawnSecretKeeper(position, Vector(0,-1))
		elseif black_hole_unit_index == 27 then
			unit = Winterblight:SpawnArmoredKnight(position, Vector(0,-1))
		elseif black_hole_unit_index == 28 then
			unit = Winterblight:SpawnCrystalRunner(position, Vector(0,-1))
		elseif black_hole_unit_index == 29 then
			unit = Winterblight:SpawnDemonSpirit(position, Vector(0,-1))	
		elseif black_hole_unit_index == 30 then
			unit = Winterblight:SpawnBladeWielder(position, Vector(0,-1))	
		elseif black_hole_unit_index == 31 then
			unit = Winterblight:SpawnShineMegmus(position, Vector(0,-1))
		elseif black_hole_unit_index == 32 then
			unit = Winterblight:SpawnAzaleaDragoon(position, Vector(0,-1))
		elseif black_hole_unit_index == 33 then
			unit = Winterblight:SpawnKnifeScraper(position, Vector(0,-1))
		elseif black_hole_unit_index == 34 then
			unit = Winterblight:SpawnFencer(position, Vector(0,-1))
		elseif black_hole_unit_index == 35 then
			unit = Winterblight:SpawnRiftBreaker(position, Vector(0,-1))
		elseif black_hole_unit_index == 36 then
			unit = Winterblight:SpawnStarSeeker(position, Vector(0,-1))
		elseif black_hole_unit_index == 37 then
			unit = Winterblight:SpawnSpineSplitter(position, Vector(0,-1))
		elseif black_hole_unit_index == 38 then
			unit = Winterblight:SpawnScouringSharpa(position, Vector(0,-1))
		elseif black_hole_unit_index == 39 then
			unit = Winterblight:SpawnRelict(position, Vector(0,-1))
		elseif black_hole_unit_index == 40 then
			unit = Winterblight:SpawnPolarBear(position, Vector(0,-1))
		elseif black_hole_unit_index == 41 then
			unit = Winterblight:SpawnIceHaunter(position, Vector(0,-1))
		elseif black_hole_unit_index == 42 then
			unit = Winterblight:SpawnCavernBat(position, Vector(0,-1))
		elseif black_hole_unit_index == 43 then
			unit = Winterblight:SpawnWinterRunner(position, Vector(0,-1))
		elseif black_hole_unit_index == 44 then
			unit = Winterblight:SpawnPantheonKnight(position, Vector(0,-1))
		elseif black_hole_unit_index == 45 then
			unit = Winterblight:SpawnManaNull(position, Vector(0,-1))
		elseif black_hole_unit_index == 46 then
			unit = Winterblight:SpawnBloodWraith(position, Vector(0,-1))
		elseif black_hole_unit_index == 47 then
			unit = Winterblight:SpawnDrillDigger(position, Vector(0,-1))
		elseif black_hole_unit_index == 48 then
			unit = Winterblight:SpawnCloakedPhantasmh(position, Vector(0,-1))
		elseif black_hole_unit_index == 49 then
			unit = Winterblight:SpawnBoar(position, Vector(0,-1))
		elseif black_hole_unit_index == 50 then
			unit = Winterblight:SpawnCorporealRevenant(position, Vector(0,-1))
		elseif black_hole_unit_index == 51 then
			unit = Winterblight:SpawnBeguiler(position, Vector(0,-1))
		elseif black_hole_unit_index == 52 then
			unit = Winterblight:SpawnFungalShaman(position, Vector(0,-1))
		elseif black_hole_unit_index == 53 then
			unit = Winterblight:SpawnHeartSlayer(position, Vector(0,-1))
		elseif black_hole_unit_index == 54 then
			unit = Winterblight:SpawnSkullHunter(position, Vector(0,-1))
		elseif black_hole_unit_index == 55 then
			unit = Winterblight:SpawnMundugu(position, Vector(0,-1))
		elseif black_hole_unit_index == 56 then
			unit = Winterblight:SpawnCrystalist(position, Vector(0,-1))
		elseif black_hole_unit_index == 57 then
			unit = Winterblight:SpawnZectRider(position, Vector(0,-1))
		elseif black_hole_unit_index == 58 then
			unit = Winterblight:SpawnMushroomPixie(position, Vector(0,-1))
		elseif black_hole_unit_index == 59 then
			unit = Winterblight:SpawnCrystariumSpider(position, Vector(0,-1))
		elseif black_hole_unit_index == 60 then
			unit = Winterblight:SpawnIcixel(position, Vector(0,-1))
		elseif black_hole_unit_index == 61 then
			unit = Winterblight:SpawnGhostOfAurora(position, Vector(0,-1))
		elseif black_hole_unit_index == 62 then
			unit = Winterblight:SpawnCavernBovaur(position, Vector(0,-1))
		elseif black_hole_unit_index == 63 then
			unit = Winterblight:SpawnIceStealer(position, Vector(0,-1))
		elseif black_hole_unit_index == 64 then
			unit = Winterblight:SpawnFrostOverwhelmer(position, Vector(0,-1))
		elseif black_hole_unit_index == 65 then
			unit = Winterblight:SpawnGiantSnowCrab(position, Vector(0,-1))
		elseif black_hole_unit_index == 66 then
			unit = Winterblight:SpawnServantOfSaturn(position, Vector(0,-1))
		elseif black_hole_unit_index == 67 then
			unit =  Winterblight:SpawnZodiacOracle(position, Vector(0,-1))
		elseif black_hole_unit_index == 68 then
			unit = Winterblight:SpawnSpaceShark(position, Vector(0,-1))
		elseif black_hole_unit_index == 69 then
			unit = Winterblight:SpawnBoneBlister(position, Vector(0,-1))
		elseif black_hole_unit_index == 70 then
			unit = Winterblight:SpawnStarEater(position, Vector(0,-1))
		elseif black_hole_unit_index == 71 then
			unit = Winterblight:SpawnGalaxyKnight(position, Vector(0,-1))
		elseif black_hole_unit_index == 72 then
			unit = Winterblight:SpawnFrozenKrow(position, Vector(0,-1))
		elseif black_hole_unit_index == 73 then
			unit = Winterblight:SpawnMindChatterer(position, Vector(0,-1))
		elseif black_hole_unit_index == 74 then
			unit = Winterblight:SpawnWintertideMonk(position, Vector(0,-1))
		elseif black_hole_unit_index == 75 then
			unit = Winterblight:SpawnWintersChieftain(position, Vector(0,-1))
		elseif black_hole_unit_index == 76 then
			unit = Winterblight:SpawnSpectralWitch(position, Vector(0,-1))
		end
		print("SPAWN")
		EmitSoundOn("Winterblight.BlackHoleUnit.Spawn", unit)
		local colorVector = Vector(0.8, 0.1, 0.8)
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", unit, 4)
		Winterblight:SetCavernUnit(unit, black_hole:GetAbsOrigin(), false, false, 4)
		Dungeons:AggroUnit(unit)
		Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_wb_zero_g", {})
		unit:SetAcquisitionRange(7000)
	end
end

function Winterblight:RandomPointInEdgeOfWinter()
	local luck = RandomInt(1, 41635)
	local position = Vector(0,0)
	if luck <= 20304 then
		local height = 8012
		local width = 2538
		local origin = Vector(-16010, 12250)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	elseif luck <= 26786 then
		local height = 7092
		local width = 914
		local origin = Vector(-14281, 12454)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	elseif luck <= 38918 then
		local height = 4497
		local width = 2698
		local origin = Vector(-12670, 14025)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	elseif luck <= 40228 then
		local height = 640
		local width = 2048
		local origin = Vector(-12800, 11456)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	elseif luck <= 41211 then
		local height = 640
		local width = 1536
		local origin = Vector(-13056, 10816)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	else
		local height = 528
		local width = 804
		local origin = Vector(-13396, 10560)
		local bl_vertex = origin-Vector(width/2, height/2)
		position = bl_vertex + Vector(RandomInt(0, width), RandomInt(0, height))
	end
	return position
end

function Winterblight:CavernBossSummon(msg)
	local chamber = tonumber(msg.chamber)

	local cost = 2000
	if chamber == 5 then
		cost = 4000
	elseif chamber == 6 then
		cost = 8000
	end
	if Winterblight.CavernData.RelicsFragments < cost then
		return false
	end
	if chamber == 5 then
		Winterblight:TiamatSequence(msg)
		return false
	elseif chamber == 6 then
		Winterblight:RealmBreakerSequence(msg)
		return false
	end
	if Winterblight.CavernData.Chambers[chamber]["boss_status"] ~= 0 then
		return false
	end
	Winterblight.CavernData.Chambers[chamber]["boss_status"] = 1

	local boss_level = Winterblight:calculate_cavern_boss_level(chamber)
	if boss_level < 1 then
		return false
	end
	Winterblight.CavernData.RelicsFragments = Winterblight.CavernData.RelicsFragments - cost
	local boss = nil
	if chamber == 1 then
		local position = Vector(-9033, 8320)
		boss = Winterblight:SpawnTorturok(position)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 2000, 20, false)
	elseif chamber == 2 then
		local position = Vector(-6784, 13824)
		boss = Winterblight:SpawnAertega(position)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 2000, 20, false)
	elseif chamber == 3 then
		local position = Vector(-13515, 5120)
		boss = Winterblight:SpawnOzubu(position)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 2000, 20, false)
	elseif chamber == 4 then
		local position = Vector(-14440, 12584)
		boss = Winterblight:SpawnGigarraun(position)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 2000, 20, false)
	end

	EmitSoundOnLocationWithCaster(boss:GetAbsOrigin(), "Winterblight.BossOut", boss)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/alt_big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, boss:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.6, 0.9))
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.6, 0.6, 0.6))
	local pfx2 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, boss)
	ParticleManager:SetParticleControl(pfx2, 0, boss:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(600, 2, 2))
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
		ParticleManager:DestroyParticle(pfx2, false)
		ParticleManager:ReleaseParticleIndex(pfx2)
	end)
	ScreenShake(boss:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
	local player = PlayerResource:GetPlayer(msg.PlayerID)
	local hero = player:GetAssignedHero()
	Dungeons:LockCameraToUnitForPlayers(boss, 2, {hero})
	EmitSoundOn("Winterblight.CavernBoss.Spawn", boss)

	StartAnimation(Winterblight.CavernGuide, {duration=4, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.6})
	Timers:CreateTimer(1.0, function()
		EmitSoundOnLocationWithCaster(Winterblight.CavernGuide:GetAbsOrigin(), "Winterblight.GuideCaveIntro2", Events.GameMaster)
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", Winterblight.CavernGuide, 4)
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", Winterblight.CavernGuide:GetAbsOrigin(), 4)
	end)
	boss.boss_level = boss_level
	boss.boss_chamber = chamber
	boss.chamber = 0
	Winterblight:SetCavernUnit(boss, boss:GetAbsOrigin(), false, false, 0)
end

function Winterblight:realm_breaker_level()
	local level = 0
	local total_chamber_levels = 0
	local total_chamber_clears = 0
	for i = 1, 4, 1 do
		for j = 1, 4, 1 do
			if Winterblight.CavernData.Chambers[i]["events"][j]["status"] == 2 then
				total_chamber_clears = total_chamber_clears + 1
				total_chamber_levels = total_chamber_levels + Winterblight.CavernData.Chambers[i]["events"][j]["level"]
			end
		end
	end
	if total_chamber_clears == 16 then
		level = total_chamber_levels/total_chamber_clears
	end
	return level
end

function Winterblight:RealmBreakerSequence(msg)
	if not Winterblight:AreAllChambersCleared() then
		return false
	end
	if Winterblight.CavernData.realm_breaker_status ~= 0 then
		return false
	end
	Winterblight.CavernData.realm_breaker_status = 1
	local cost = 8000
	if Winterblight.CavernData.RelicsFragments < cost then
		return false
	end
	local boss_level = Winterblight:realm_breaker_level()
	if boss_level < 1 then
		return false
	end
	Winterblight.CavernData.RelicsFragments = Winterblight.CavernData.RelicsFragments - cost
	local position = Vector(-13440, 13584)
	local boss = Winterblight:SpawnRealmBreaker(position)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 2000, 20, false)

	EmitSoundOnLocationWithCaster(boss:GetAbsOrigin(), "Winterblight.BossOut", boss)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/alt_big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, boss:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.6, 0.9))
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.6, 0.6, 0.6))
	local pfx2 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, boss)
	ParticleManager:SetParticleControl(pfx2, 0, boss:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(600, 2, 2))
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
		ParticleManager:DestroyParticle(pfx2, false)
		ParticleManager:ReleaseParticleIndex(pfx2)
	end)
	ScreenShake(boss:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
	local player = PlayerResource:GetPlayer(msg.PlayerID)
	local hero = player:GetAssignedHero()
	Dungeons:LockCameraToUnitForPlayers(boss, 2, {hero})
	EmitSoundOn("Winterblight.CavernBoss.Spawn", boss)

	StartAnimation(Winterblight.CavernGuide, {duration=4, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.6})
	Timers:CreateTimer(1.0, function()
		EmitSoundOnLocationWithCaster(Winterblight.CavernGuide:GetAbsOrigin(), "Winterblight.GuideCaveIntro2", Events.GameMaster)
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", Winterblight.CavernGuide, 4)
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", Winterblight.CavernGuide:GetAbsOrigin(), 4)
	end)
	boss.boss_level = boss_level
	boss.boss_chamber = 6
	boss.chamber = 0
	Winterblight:SetCavernUnit(boss, boss:GetAbsOrigin(), false, false, 0)
end

function Winterblight:AreAllChambersCleared()
	local cleared = true
	for i = 1, 4, 1 do
		for j = 1, 4, 1 do
			if Winterblight.CavernData.Chambers[i]["events"][j]["status"] == 2 then
			else
				cleared = false
				break
			end
		end
	end
	return cleared
end

function Winterblight:calculate_cavern_boss_level(chamber)
	local level = 0
	local divisor = 0
	local chamber_total = 0
	for j = 1, 4, 1 do
		local event_level = Winterblight.CavernData.Chambers[chamber]["events"][j]["level"]
		if event_level > 0 then
			divisor = divisor + 1
			chamber_total = chamber_total + event_level
		end
	end
	if divisor > 0 then
		level = math.ceil(chamber_total/divisor)
	end
	return level
end

function Winterblight:SpawnTorturok(position)
	local boss = Events:SpawnDescentOfWinterblightDungeonUnit("descent_of_winterblight_torturok", position, 9, 12, "Torturok.Aggro", RandomVector(1), false)
	boss:SetRenderColor(100, 100, 255)
	EmitSoundOn("Torturok.Spawn", boss)
	boss.reduc = 0.1
	return boss
end

function Winterblight:SpawnRealmBreaker(position)
	local boss = Events:SpawnDescentOfWinterblightDungeonUnit("winterblight_realm_breaker", position, 9, 12, "Winterblight.RealmBreaker.Aggro", RandomVector(1), false)
	boss:SetRenderColor(100, 100, 255)
	Winterblight:SetPositionCastArgs(boss, 1000, 300, 1, FIND_ANY_ORDER)
	Timers:CreateTimer(1, function()
		EmitSoundOn("Winterblight.RealmBreaker.Spawn", boss)
	end)
	boss.reduc = 0.01
	return boss
end

function Winterblight:SpawnAertega(position)
	local boss = Events:SpawnDescentOfWinterblightDungeonUnit("descent_of_winterblight_aertega", position, 9, 12, "Events.DescentOfWinterblight.Aertega.Aggro", RandomVector(1), false)
	boss:SetRenderColor(100, 100, 255)
	boss.reduc = 0.15
	EmitSoundOn("Events.DescentOfWinterblight.Aertega.Spawn", boss)
	return boss
end


function Winterblight:SpawnOzubu(position)
	local boss = Events:SpawnDescentOfWinterblightDungeonUnit("descent_of_winterblight_ozubu", position, 9, 12, "Winterblight.Ozubu.Aggro", RandomVector(1), false)
	boss:SetRenderColor(200, 200, 255)
	boss.maxSummons = (1 - (boss:GetHealth() / boss:GetMaxHealth())) * 23 + 2
	boss.reduc = 0.05
	EmitSoundOn("Winterblight.Ozubu.Spawn", boss)
	return boss
end

function Winterblight:SpawnGigarraun(position)
	local boss = Events:SpawnDescentOfWinterblightDungeonUnit("winterblight_cavern_gigarraun", position, 9, 12, "Winterblight.Gigarraun.Aggro", RandomVector(1), false)
	Events:ColorWearablesAndBase(boss, Vector(100, 120, 255))
	boss.reduc = 0.08
	EmitSoundOn("Winterblight.Gigarraun.Spawn", boss)
	return boss
end

function Winterblight:tiamat_boss_level()
	local level = 0
	local bosses_killed = 0
	local total_boss_level = 0
	for i = 1, 4, 1 do
		if Winterblight.CavernData.Chambers[i]["boss_level_defeated"] > 0 then
			bosses_killed = bosses_killed + 1
			total_boss_level = total_boss_level + Winterblight.CavernData.Chambers[i]["boss_level_defeated"]
		end
	end
	if bosses_killed == 4 then
		level = math.ceil(total_boss_level/4)
	end
	return level
end

function Winterblight:TiamatSequence(msg)
	local chamber = 5
	if Winterblight.CavernData.tiamat_status ~= 0 then
		return false
	end
	Winterblight.CavernData.tiamat_status = 1
	local cost = 4000
	if Winterblight.CavernData.RelicsFragments < cost then
		return false
	end
	local boss_level = Winterblight:tiamat_boss_level()
	if boss_level < 1 then
		return false
	end
	Winterblight.CavernData.RelicsFragments = Winterblight.CavernData.RelicsFragments - cost


	local player = PlayerResource:GetPlayer(msg.PlayerID)
	local hero = player:GetAssignedHero()
	
	local guide = Winterblight.CavernGuide
	Dungeons:LockCameraToUnitForPlayers(guide, 13, {hero})
	local ability = guide:FindAbilityByName("winterblight_cave_guide_ability")
	ability:ApplyDataDrivenModifier(guide, guide, "modifier_guide_tiamat_thinking", {})
	CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/aegis_lvl_1000_ambient_ti9.vpcf", guide:GetAbsOrigin(), 6)
	StartAnimation(guide, {duration=4, activity=ACT_DOTA_VERSUS, rate=1.3, translate="surge"})
	guide.tiamat_interval = 0
	guide.tiamat_phase = -1
	guide.goSpeed = 10
	guide.liftSpeed = 1
	guide.sequence_hero = hero
	CustomAbilities:QuickParticleAtPoint("particles/neutral_fx/tornado_ambient.vpcf", guide:GetAbsOrigin(), 7)
	Timers:CreateTimer(0.06, function()
		EmitSoundOn("Winterblight.CaveGuide.StartTiamat.Land.VO", guide)
		EmitSoundOn("Winterblight.CavernGuide.Tornado2", guide)
		EmitSoundOnLocationWithCaster(guide:GetAbsOrigin(), "Winterblight.GuideCaveIntro2", Events.GameMaster)
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", guide, 4)
		CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", guide, 4)
	end)
end

function Winterblight:SpawnTiamat(position)
	local boss = Events:SpawnBoss("winterblight_cavern_boss_tiamat", position)
	boss.reduc = 0.02
	boss:SetSkin(2)
	return boss
end

function Winterblight:MainTiamatSpawn(hero)
	ParticleManager:DestroyParticle(Winterblight.tiamat_sequence_orb.pfx, false)
	local position = Winterblight.tiamat_sequence_orb.final_pos
	Winterblight.tiamat_sequence_orb = nil
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 2000, 20, false)
	local boss = Winterblight:SpawnTiamat(position)
	local boss_level = Winterblight:tiamat_boss_level()
	EmitGlobalSound("Winterblight.Tiamat.FirstSpawn")
	EmitSoundOnLocationWithCaster(boss:GetAbsOrigin(), "Winterblight.BossOut", boss)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/alt_big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, boss:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.6, 0.9))
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.6, 0.6, 0.6))
	local pfx2 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, boss)
	ParticleManager:SetParticleControl(pfx2, 0, boss:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(600, 2, 2))
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
		ParticleManager:DestroyParticle(pfx2, false)
		ParticleManager:ReleaseParticleIndex(pfx2)
	end)
	Dungeons:LockCameraToUnitForPlayers(boss, 2, {hero})
	ScreenShake(boss:GetAbsOrigin(), 5000, 2.0, 2.0, 9000, 0, true)
	-- local player = PlayerResource:GetPlayer(msg.PlayerID)
	EmitSoundOn("Winterblight.CavernBoss.Spawn", boss)
	Timers:CreateTimer(0.7, function()
		EmitSoundOn("Winterblight.Tiamat.Die.VO", boss)
	end)

	boss.boss_level = boss_level
	boss.boss_chamber = 0
	boss.chamber = 0
	Winterblight:SetCavernUnit(boss, boss:GetAbsOrigin(), false, false, 0)
	StartAnimation(boss, {duration=2, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.3})
end

function Winterblight:TiamatBossDie(boss)
	boss.dying = true
	AddFOWViewer(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), 2400, 60, false)
	local ability = boss:FindAbilityByName("tiamat_boss_passive")
	Winterblight.TiamatBossLevel = boss.boss_level
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_boss_dying", {})
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_boss_disarmed", {})
	-- EmitSoundOn("Winterblight.AzaleaBoss.Death1.VO", boss)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
		local luck = RandomInt(1, 3)
	end)
	EmitSoundOn("Winterblight.Tiamat.Die.VO", boss)
	local position = boss:GetAbsOrigin()
	for i = 1, 18, 1 do
		Timers:CreateTimer(0.3 * i, function()
			RPCItems:RollItemtype(300, boss:GetAbsOrigin(), 1, 0)
		end)
	end
	Timers:CreateTimer(1, function()
		local arcanaLuck = RandomInt(1, 195 - GameState:GetPlayerPremiumStatusCount() * 10 - Winterblight.Stones * 25)
		if arcanaLuck == 1 then
			RPCItems:RollAstralArcana3(boss:GetAbsOrigin())
		end
		local luck2 = RandomInt(1, 100 - GameState:GetPlayerPremiumStatusCount() * 1)
		if luck2 == 1 then
			Winterblight:DropBorealGraniteChunk(boss:GetAbsOrigin())
		end
	end)
	Timers:CreateTimer(3, function()
		local luck = RandomInt(1, 5)
		if luck == 1 then
			RPCItems:RollIceFloeSlippers(boss:GetAbsOrigin())
		end
	end)
	Timers:CreateTimer(5, function()
		local luck = RandomInt(1, 5)
		if luck == 1 then
			RPCItems:RollIronTreadsOfDestruction(boss:GetAbsOrigin())
		end
	end)
	for j = 1, 3 + GameState:GetPlayerPremiumStatusCount() * 2, 1 do
		Timers:CreateTimer(j * 0.3, function()
			Winterblight:DropGlacierStone(boss:GetAbsOrigin())
		end)
	end
	Timers:CreateTimer(6, function()
		for j = 1, Winterblight.Stones, 1 do
			Timers:CreateTimer(j, function()
				RPCItems:DropSynthesisVessel(boss:GetAbsOrigin())
			end)
		end
	end)
	Timers:CreateTimer(8, function()

		-- EmitSoundOn("Winterblight.AzaleaBoss.Death2.VO", boss)
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(boss)})
		boss:RemoveModifierByName("modifier_boss_dying")
		-- Timers:CreateTimer(0.03, function()
		-- 	StartAnimation(boss, {duration = 10, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.24})
		-- end)
		Timers:CreateTimer(0.8, function()
			local position = boss:GetAbsOrigin()
			Winterblight:objectShake(boss, 48, 15, true, true, true, "Winterblight.AzaleaBoss.DeathShaking", 24)
			Timers:CreateTimer(1.5, function()
				for i = 0, 3, 1 do
					Timers:CreateTimer(0.1 * i, function()
						local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(pfx, 0, position + Vector(0, 0, 80 + i * 120))
						ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
						ParticleManager:SetParticleControl(pfx, 2, Vector(0.8, 0.8, 0.8))
						Timers:CreateTimer(10, function()
							ParticleManager:DestroyParticle(pfx, false)
							ParticleManager:ReleaseParticleIndex(pfx)
						end)
					end)
				end
				EmitSoundOn("Winterblight.Tiamat.Ice.Explode", boss)
				local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
				local radius = 800
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(particle1, 0, boss:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 1000))
				ParticleManager:SetParticleControl(particle1, 3, Vector(radius, radius, radius))
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				UTIL_Remove(boss)
			end)
		end)
	end)
	Timers:CreateTimer(13, function()
		Winterblight:MithrilReward(position, "tiamat")
	end)

end

function Winterblight:GetStarValueForCavernMaster(hero)
	local star_value_to_return = 0
	local playerID = hero:GetPlayerOwnerID()

	local total_completion_level = 0
	local total_chamber_count = 16
	local total_chamber_clear_count = 0
	local steam_id = tostring(PlayerResource:GetSteamAccountID(playerID))
	
	local event_index = tostring(event_index)
	DeepPrintTable(Winterblight.CavernMetaData)
	for i = 1, 4, 1 do
		local chamber_index = tostring(i)
		for j = 1, 4, 1 do
			local event_index = tostring(j)
			if Winterblight.CavernMetaData[chamber_index] then
				if Winterblight.CavernMetaData[chamber_index][event_index] then
					if Winterblight.CavernMetaData[chamber_index][event_index][steam_id] then
						if Winterblight.CavernMetaData[chamber_index][event_index][steam_id]["hero_record"] and Winterblight.CavernMetaData[chamber_index][event_index][steam_id]["hero_record"]["level"] then
							total_chamber_clear_count = total_chamber_clear_count + 1
							total_completion_level = total_completion_level + Winterblight.CavernMetaData[chamber_index][event_index][steam_id]["hero_record"]["level"]
						end
					end
				end
			end
		end
	end
	print(total_chamber_clear_count)
	if total_chamber_clear_count >= total_chamber_count then
		local average_clear_level = total_completion_level/total_chamber_clear_count
		if average_clear_level >= 10 then
			star_value_to_return = 1
		end
		if average_clear_level >= 20 then
			star_value_to_return = 2
		end
		if average_clear_level >= 30 then
			star_value_to_return = 3
		end
	end
	print(total_completion_level)
	print("RETURN STAR VALUE")
	print(star_value_to_return)
	return star_value_to_return
end
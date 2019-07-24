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
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-12800, 4736, 500), 10000, 10000, false)
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
			print(Winterblight.CavernMetaData)
		end
	end )
end

function Winterblight:InitCavernData()
	Winterblight:GetCaveMetaData()
	Winterblight.CavernData = {}
	Winterblight.CavernData.Chambers = {}
	Winterblight.CavernData.RelicsFragments = 0
	for i = 1, 4, 1 do
		Winterblight.CavernData.Chambers[i] = {}
		Winterblight.CavernData.Chambers[i]["status"] = 0
		-- Winterblight.CavernData.Chambers[i]["relic_fragments_reward"] = 100
		Winterblight.CavernData.Chambers[i]["events"] = {}
		for j = 1, 4, 1 do
			Winterblight.CavernData.Chambers[i]["events"][j] = {}
			Winterblight.CavernData.Chambers[i]["events"][j]["status"] = 0
			Winterblight.CavernData.Chambers[i]["events"][j]["relic_fragments_reward"] = 1000
			Winterblight.CavernData.Chambers[i]["events"][j]["relic_fragments_rewarded"] = 0
			-- update reward calcs
		end
	end
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
	local event_index = Winterblight.CavernData.Chambers[chamber_index]["event"]
	if Winterblight.CavernData.Chambers[chamber_index]["events"][event_index]["attempt"] ~= 1 then
		unit.minDungeonDrops = 0
		unit.maxDungeonDrops = 0
	end
	table.insert(Winterblight.CavernUnits[chamber_index], unit)
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
	for i = 1, #Winterblight.CavernChamberVertices[chamber_id], 1 do
		if WallPhysics:IsWithinRegionA(compare_position, Winterblight.CavernChamberVertices[chamber_id][i][1], Winterblight.CavernChamberVertices[chamber_id][i][2]) then
			is_in_region = true
			break
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
				CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", unit:GetAbsOrigin(), 4)
				EmitSoundOn("Winterblight.GuideCaveIntro", unit)
				UTIL_Remove(unit)
			end
		end)
	end
	for i = 1, #Winterblight.CavernPFXs[chamber], 1 do
		ParticleManager:DestroyParticle(Winterblight.CavernPFXs[chamber][i], false)
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
		-- if Beacons.cheats then
		-- 	Winterblight.CavernData.Chambers[chamber]["events"][event_index]["status"] = 0
		-- end

		Winterblight:DisperseRelicFragments(position, reward, hero, chamber, event_index)
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
	Winterblight.CavernData.Chambers[msg.chamber]["goal"] = 290
	Winterblight.CavernData.Chambers[msg.chamber]["progress"] = 0
	Winterblight.Crystarium3Kills = 0
	local chamber_id = msg.chamber
	-- local unitsTable = {}
	-- local portalPosTable = {Vector(-15256, 7295), Vector(-15005, 2197), Vector(-13273, 4037), Vector(-12855, 6823), Vector(-9829, 4244)}
	-- for i = 1, #portalPosTable, 1 do
	-- 	local groundPos = GetGroundPosition(portalPosTable[i], Events.GameMaster)
	-- 	AddFOWViewer(DOTA_TEAM_GOODGUYS, groundPos, 500, 10, false)
	-- 	local portalPFX = CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/teleport_end_ti9.vpcf", groundPos, 0)
	-- 	ParticleManager:SetParticleControl(portalPFX, 3, groundPos)
	-- 	ParticleManager:SetParticleControl(portalPFX, 15, groundPos)
	-- 	table.insert(Winterblight.CavernPFXs[chamber_id], portalPFX)
	-- end
	-- Winterblight:Crystarium3WaveRedirect(0)
end
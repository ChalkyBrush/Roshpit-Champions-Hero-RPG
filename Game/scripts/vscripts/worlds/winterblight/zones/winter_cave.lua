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
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-9033, 8320, 500), 10000, 10000, false)
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
	Winterblight.CavernChamberVertices[1] = Winterblight:GetVertices(1)
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
	Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"] = Winterblight.CavernData.Chambers[msg.chamber]["spawnphase"] + 1
	-- if Beacons.cheats then
	-- 	Winterblight.CavernData.Chambers[msg.chamber]["status"] = 0
	-- end
	if not Winterblight.CavernUnits then
		Winterblight.CavernUnits = {}
	end
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
	local stone = Winterblight:SpawnDungeonUnit("winter_cavern_bat", position, 1, 1, "Winterblight.CavernBat.Aggro", fv, false)
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
		your_hero_max = Winterblight.CavernMetaData[chamber_index][event_index][steam_id]["hero_record"]["level"] + 1
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
	end
	return vertices
end

function Winterblight:ResetChamber(hero, chamber)
	if Winterblight.CavernData.Chambers[chamber]["status"] == 1 then
		Winterblight.CavernData.Chambers[chamber]["status"] = 2
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
		Winterblight.CavernData.Chambers[chamber]["events"][event_index]["status"] = 1
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
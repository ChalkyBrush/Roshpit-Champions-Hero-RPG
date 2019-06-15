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
			StartAnimation(guide, {duration=4, activity=ACT_DOTA_VERSUS, rate=0.9})
			EmitSoundOnLocationWithCaster(spawnPos, "Winterblight.GuideCaveIntro2", Events.GameMaster)
			CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", spawnPos, 3)
			CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", spawnPos, 3)
			for i = 1, 5, 1 do
				Timers:CreateTimer(0.75*(i+1)-0.5, function()
					EmitSoundOnLocationWithCaster(spawnPos, "Winterblight.Cave.GuideIntro1", Events.GameMaster)
					CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", spawnPos, 3)
				end)
			end
			guide:SetAbsOrigin(guide:GetAbsOrigin()+Vector(0,0,2000))
			guide:SetModelScale(1.3)
			guide:SetRenderColor(60, 50, 255)
			local ability = guide:FindAbilityByName("winterblight_cave_guide_ability")
			ability:ApplyDataDrivenModifier(guide, guide, "modifier_guide_entering", {duration = 60})
	-- 	end
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
	for i = 1, 4, 1 do
		Winterblight.CavernData.Chambers[i] = {}
		Winterblight.CavernData.Chambers[i]["status"] = 0
		Winterblight.CavernData.Chambers[i]["relic_fragments_reward"] = 100
		Winterblight.CavernData.Chambers[i]["events"] = {}
		for j = 1, 4, 1 do
			Winterblight.CavernData.Chambers[i]["events"][j] = {}
			Winterblight.CavernData.Chambers[i]["events"][j]["status"] = 0
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
	if Winterblight.CavernData.Chambers[msg.chamber]["status"] > 0 then
		return false
	end
	Winterblight.CavernData.Chambers[msg.chamber]["status"] = 1
	Winterblight.CavernData.Chambers[msg.chamber]["events"][msg.event_number]["status"] = 1
	if Beacons.cheats then
		Winterblight.CavernData.Chambers[msg.chamber]["status"] = 0
		Winterblight.CavernData.Chambers[msg.chamber]["events"][msg.event_number]["status"] = 0
	end
	if msg.chamber == 1 then
		Winterblight:FrozenFoyer(msg)
	end
end

function Winterblight:FrozenFoyer(msg)
	if msg.event_number == 1 then
		Winterblight:FrozenFoyer1(msg)
	end
end

function Winterblight:FrozenFoyer1(msg)
	local unitsTable = {}
	local positionTable = {Vector(-7040, 7552), Vector(-6809, 7936), Vector(-6519, 8320)}
	for i = 1, #positionTable, 1 do
		local fv = ((Vector(-5622, 6912) - positionTable[i])*Vector(1,1,0)):Normalized()
		local unit = Winterblight:SpawnWinterRunner(positionTable[i], fv)
		Winterblight:SetCavernUnit(unit, 1, positionTable[i], true)
	end

end

function Winterblight:SetCavernUnit(unit, chamber_id, original_position, bDeaggro)
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_winterblight_cavern_unit", {})
	unit.chamber_id = chamber_id
	unit.deaggro = bDeaggro
	unit.original_position = original_position
end

function Winterblight:SpawnWinterRunner(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cavern_centaur", position, 1, 2, "Winterblight.Cavern.Centaur.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 50
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
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
	end
	return vertices
end
function Winterblight:CaveGuideSpawn()
	if not Winterblight.CaveGuideSpawned then
	-- 	if Winterblight.CaveGuideReady then
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
	CustomGameEventManager:Send_ServerToPlayer(player, "load_winterblight_cavern_records", {wb_data = Winterblight.CavernMetaData, chamber_index = msg.chamber_index, event_index = msg.event_index, steam_id = steamID, difficulty = GameState:GetDifficultyFactor(), stones = Winterblight.Stones})
end

function Winterblight:ProcessChamberStart(msg)
	if msg.chamber == 1 then
		Winterblight:FrozenFoyer(msg)
	end
end

function Winterblight:FrozenFoyer(msg)
	if msg.event_number == 1 then
	end
end
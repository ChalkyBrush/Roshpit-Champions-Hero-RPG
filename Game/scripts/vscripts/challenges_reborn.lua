if Challenges == nil then
	Challenges = class({})
	Challenges.ParagonDivisor = 1
	Challenges.MagicArmorMult = 1
	Challenges.SpellPierceMult = 1
	Challenges.ArmorMult = 1
	Challenges.ArmorPierceMult = 1
	Challenges.BonusHPMult = 1
	Challenges.SpeedMult = 1
end

function Challenges:GetChallengeFromRoshpitServer()
	if Challenges.main_challenge then
		return false
	end
	-- if GameState:GetDifficultyFactor() == 3 then
		local url = ROSHPIT_URL.."/champions/get_challenges"

		CreateHTTPRequestScriptVM("GET", url):Send(function(result)
			local resultTable = {}
			--print( "GET response:\n" )
			for k, v in pairs(result) do
				--print( string.format( "%s : %s\n", k, v ) )
			end
			--print( "Done." )
			local resultTable = JSON:decode(result.Body)
			--print(resultTable)
			Challenges:ProcessChallengeResult(resultTable)
		end)
	-- end
end

function Challenges:ProcessChallengeResult(result)
	DeepPrintTable(result)
	Challenges.main_challenge = result["main"]
	Challenges.web_challenge = result["web_premium"]
	Challenges:CheckSpawn()
end

function Challenges:CheckSpawn()
	if Challenges.Crusader then
		return false
	end
	local challenges_list = {Challenges.main_challenge, Challenges.web_challenge}
	for i = 1, #challenges_list, 1 do
		local full_challenge = challenges_list[i]
		local challenge_table = challenges_list[i]["challenge"]
		if Challenges:HeroMatch(full_challenge) then
			print("CHECK MAP MATCH")
			print(GetMapName())
			DeepPrintTable(challenge_table)
			print(challenge_table["map_name"])
			print("######")
			if challenge_table["map_name"] == GetMapName() then
				print("MAP MATCH")
				Challenges:MapMatch(challenge_table)
			end
		end
	end
end

function Challenges:HeroMatch(challenge_table)
	local proceed = true
	print("--------")
	DeepPrintTable(challenge_table["mods"])
	for i = 1, #challenge_table["mods"], 1 do
		local mod = challenge_table["mods"][i]
		if mod["mod_type"] == "hero_limit" then
			print("CHALLENGES: HERO LIMIT")
			if PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) > mod["mod_int1"] then
				print("LIMIT PASS FAIL")
				proceed = false
				break
			end
		end
		if mod["mod_type"] == "hero_spec" then
			print("CHALLENGES: HERO SPEC")
			for i = 1, #MAIN_HERO_TABLE, 1 do
				if MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string1"] and MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string2"] and MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string3"] and MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string4"] and MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string5"] then
					print("HERO CHECK FAIL")
					proceed = false
					break
				end
			end
		end
	end
	return proceed
end

function Challenges:MapMatch(challenge_table)

	if challenge_table["map_name"] == "rpc_tanari_jungle" then
		if challenge_table["difficulty_mod"] == 0 then
			Challenges:SpawnCrusaderNow(Vector(-4416, 1069), Vector(-0.2, 1))
		else
			Challenges.waiting_for_spirit_realm = true
		end
	elseif challenge_table["map_name"] == "rpc_redfall_ridge" then
		if challenge_table["difficulty_mod"] == 0 then
			Challenges:SpawnCrusaderNow(Vector(-13530, -15232), Vector(0,1))
		else
			Challenges.waiting_for_spirit_realm = true
		end
	elseif challenge_table["map_name"] == "rpc_winterblight_mountain" then
		print("WINTER MATCH zxc")
		if challenge_table["difficulty_mod"] == 0 then
			Challenges:SpawnCrusaderNow(Vector(-13979, -1664), Vector(0,-1))
		else
			Challenges.waiting_for_stones = challenge_table["difficulty_mod"]
		end
	elseif challenge_table["map_name"] == "rpc_roshpit_arena" then
		Challenges.waiting_for_pit_open = challenge_table["difficulty_mod"]
	elseif challenge_table["map_name"] == "rpc_sea_fortress" then
		Challenges:SpawnCrusaderNow(Vector(896, -14592), Vector(-1,-1))
	end
end

function Challenges:ProcessPossibleSpawnEvent(value)
	if Challenges.Crusader then
		return false
	end
	if Challenges.waiting_for_spirit_realm then
		if GetMapName() == "rpc_tanari_jungle" then
			Challenges:SpawnCrusaderNow(Vector(-4416, 1069), Vector(-0.2, 1))
		elseif GetMapName() == "rpc_redfall_ridge" then
			Challenges:SpawnCrusaderNow(Vector(-13530, -15232), Vector(0,1))
		end
	elseif Challenges.waiting_for_stones and Challenges.waiting_for_stones >= value then
		Challenges:SpawnCrusaderNow(Vector(-13979, -1664), Vector(0,-1))
	elseif Challenges.waiting_for_pit_open and Challenges.waiting_for_pit_open >= value then
		Challenges:SpawnCrusaderNow(Vector(-7941, 10188), Vector(-0.1,-1))
	end

end

function Challenges:ChallengeWinEvent(event)
end

function Challenges:SpawnCrusaderNow(position, fv)
	print("SPAWN CRUSADER")
 	if Challenges.Crusader then
 		UTIL_Remove(Challenges.Crusader)
 	end
	Challenges.CrusaderSpawned = true
	Challenges.Crusader = CreateUnitByName("the_crusader", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	-- Challenges.Crusader:SetAbsOrigin(Challenges.Crusader:GetAbsOrigin()+Vector(0,0,1000))
	Events:smoothSizeChange(Challenges.Crusader, 0.01, 1.14, 66)
	Timers:CreateTimer(0.9, function()
		CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", Challenges.Crusader, 4)
		EmitSoundOn("Challenges.Crusader.Enter", Challenges.Crusader)
	end)
	Timers:CreateTimer(2.3, function()
		EmitSoundOn("Challenges.Crusader.VOEnter", Challenges.Crusader)
	end)
	Challenges.Crusader:FindAbilityByName("town_unit"):SetLevel(1)
	Challenges.Crusader:FindAbilityByName("npc_dialogue"):SetLevel(1)
	Challenges.Crusader.dialogueName = "crusader"
	Challenges.Crusader:SetForwardVector(fv)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Challenges.Crusader:GetAbsOrigin(), 700, 8, false)
	Timers:CreateTimer(0.5, function()
		StartAnimation(Challenges.Crusader, {duration = 1.5, activity = ACT_DOTA_OVERRIDE_ABILITY_3, rate = 0.8})
	end)
end

function Challenges:ShouldWeSpawnCrusader(challenge)
end

function Challenges:ProcessEvent(event_name)
end

function Challenges:PanoramaInput(msg)
	print("START CHALLENGE")
	print(msg.challenge_type)
end
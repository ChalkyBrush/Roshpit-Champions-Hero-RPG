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
		if Challenges:HeroMatch(full_challenge) and Challenges:MapMatch(challenge_table) and Challenges:DifficultyModMatch(challenge_table) then
			Challenges:SpawnByMap()
		end
	end
end

function Challenges:AreConditionsValidForChallenge(challenge)
	local challenge_table = challenge["challenge"]
	if Challenges:HeroMatch(challenge) and Challenges:MapMatch(challenge_table) and Challenges:DifficultyModMatch(challenge_table) then
		return true
	else
		return false
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
	if challenge_table["map_name"] == GetMapName() then
		return true
	else
		return false
	end
end

function Challenges:DifficultyModMatch(challenge_table)
	local mod_match = true
	if challenge_table["map_name"] == "rpc_tanari_jungle" and challenge_table["difficulty_mod"] == 1 then
		if Events.SpiritRealm then
			mod_match = true
		else
			mod_match = false
		end
	end
	if challenge_table["map_name"] == "rpc_redfall_ridge" and challenge_table["difficulty_mod"] == 1 then
		if Events.SpiritRealm then
			mod_match = true
		else
			mod_match = false
		end
	end
	if challenge_table["map_name"] == "rpc_winterblight_mountain" and challenge_table["difficulty_mod"] > 0 then
		if Winterblight then
			if Winterblight.Stones >= challenge_table["difficulty_mod"] then
				mod_match = true
			else
				mod_match = false
			end
		else
			mod_match = false
		end
	end
	if challenge_table["map_name"] == "rpc_roshpit_arena" and challenge_table["difficulty_mod"] > 0 then
		if Arena then
			if Arena.PitLevel >= challenge_table["difficulty_mod"] then
				mod_match = true
			else
				mod_match = false
			end
		else
			mod_match = false
		end
	end
	return mod_match
end

function Challenges:SpawnByMap()
	if Challenges.Crusader then
		return false
	end
	if GetMapName() == "rpc_tanari_jungle" then
		Challenges:SpawnCrusaderNow(Vector(-4416, 1069), Vector(-1, 0))
	elseif GetMapName() == "rpc_redfall_ridge" then
		Challenges:SpawnCrusaderNow(Vector(-13530, -15232), Vector(0,1))
	elseif GetMapName() == "rpc_winterblight_mountain" then
		Challenges:SpawnCrusaderNow(Vector(-13979, -1664), Vector(0,-1))
	elseif GetMapName() == "rpc_roshpit_arena" then
		Challenges:SpawnCrusaderNow(Vector(-13979, -1664), Vector(0,-1))
	elseif GetMapName() == "rpc_sea_fortress" then
		Challenges:SpawnCrusaderNow(Vector(896, -14592), Vector(-1,-1))
	end	
end

function Challenges:ProcessPossibleSpawnEvent(value)
	if Challenges.Crusader then
		return false
	end
	Challenges:CheckSpawn()
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
	if msg.event_type == "start" then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", MAIN_HERO_TABLE[i], 4)
			EmitSoundOn("Challenges.Crusader.Enter", MAIN_HERO_TABLE[i])
		end
		Notifications:BottomToAll({text = "ui_challenge_started", duration = 4.2})
		local challenge_text = msg.challenge_text
		for _, mod in pairs(msg.mod_array) do
			challenge_text = challenge_text .. "<br>"..mod
		end
		print(challenge_text)
		Timers:CreateTimer(4.2, function()
			Notifications:BottomToAll({text = challenge_text, duration = 10.0})
		end)
		EmitGlobalSound("UI.CrusaderAccept.Music")
	end
end


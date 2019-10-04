if Challenges == nil then
	Challenges = class({})
end

function Challenges:GetChallengeFromRoshpitServer()
	if GameState:GetDifficultyFactor() == 3 then
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
	end
end

function Challenges:ProcessChallengeResult(result)
	local challenges_list = {result["main"], result["web_premium"]}
	Challenges.main_challenge = result["main"]
	Challenges.web_challenge = result["web_premium"]
	for i = 1, #challenges_list, 1 do
		local challenge_table = challenges_list[i]
		if challenge_table["map_name"] == GetMapName() then
			Challenges:MapMatch(challenge_table)
		end
	end
end

function Challenges:MapMatch(challenge_table)

	if challenge_table["map_name"] == "rpc_tanari_jungle" then
		if challenge_table["challenge_mod"] == 0 then
			Challenges:SpawnCrusaderNow(Vector(-4416, 1069), Vector(-0.2, 1))
		else
			Challenges.waiting_for_spirit_realm = true
		end
	elseif challenge_table["map_name"] == "rpc_redfall_ridge" then
		if challenge_table["challenge_mod"] == 0 then
			Challenges:SpawnCrusaderNow(Vector(-13530, -15232), Vector(0,1))
		else
			Challenges.waiting_for_spirit_realm = true
		end
	elseif challenge_table["map_name"] == "rpc_winterblight_mountain" then
		if challenge_table["challenge_mod"] == 0 then
			Challenges:SpawnCrusaderNow(Vector(-12160, 2304), Vector(-1,0))
		else
			Challenges.waiting_for_stones = challenge_table["challenge_mod"]
		end
	elseif challenge_table["map_name"] == "rpc_roshpit_arena" then
		Challenges.waiting_for_pit_open = challenge_table["challenge_mod"]
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
		Challenges:SpawnCrusaderNow(Vector(-12160, 2304), Vector(-1,0)
	elseif Challenges.waiting_for_pit_open and Challenges.waiting_for_pit_open >= value then
		Challenges:SpawnCrusaderNow(Vector(-7941, 10188), Vector(-0.1,-1)
	end

end

function Challenges:SpawnCrusaderNow(position, fv)
	Challenges.Crusader = "spawn_crusader"
end

function Challenges:ShouldWeSpawnCrusader(challenge)
end

function Challenges:ProcessEvent(event_name)
end
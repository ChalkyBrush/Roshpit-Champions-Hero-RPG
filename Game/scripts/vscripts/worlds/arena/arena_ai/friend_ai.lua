require("npc_abilities/dialogue")

function league_assistant_think(event)
	local caster = event.target
	if Arena.BetweenBattles then
		return
	end
	if Arena.Nightmare then
		return
	end
	local newbeeLoungeLoc = Vector(-9664, -2048)
	local majorLoungeLoc = Vector(-8576, 3968)
	local allstarLoungeLoc = Vector(-2368, 5888)
	local battleLoc = Vector(-6312, -2300)
	if not Arena.ChampionsLeague.state then
		if not caster.hasSpeechBubble then
			local ability = event.ability
			local position = caster:GetAbsOrigin()
			local radius = 250

		    local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		    local target_types = DOTA_UNIT_TARGET_HERO
		    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #units > 0 then
				basic_dialogue(caster, units, "#champion_assistant_dialogue_1", 8, 5, -80, true)
			end
		end
	else
		if Arena.ChampionsLeague.state == 0 then
			local destinationPoint = Vector(-4005, -7176)
			caster:MoveToPosition(destinationPoint)
			local distance = WallPhysics:GetDistance(destinationPoint, caster:GetAbsOrigin()*Vector(1,1,0))
			if distance < 200 then
				Arena.ChampionsLeague.state = 1
			end
		elseif Arena.ChampionsLeague.state == 1 then
			local units = GetNearbyHeroes(300, caster)
			if #units > 0 then
				Arena.ChampionsLeague.state = 2
				basic_dialogue(caster, units, "#champion_assistant_dialogue_2", 4.4, 5, -80)
				-- basic_dialogue(Arena.ChampionsLeagueAttendant, units, "#arena_league_attendant_coach_arrive", 4, 5, -80, true)
				Timers:CreateTimer(5, function()
					EmitSoundOn("Arena.AssistantSigh", caster)
					basic_dialogue(caster, units, "#champion_assistant_dialogue_3", 4.4, 5, -80, true)
					Timers:CreateTimer(5, function()
						StartAnimation(caster, {duration=1.4, activity=ACT_DOTA_SPAWN, rate=1.3})
						basic_dialogue(caster, units, "#champion_assistant_dialogue_4", 5.5, 5, -80, true)
						Timers:CreateTimer(6, function()
							basic_dialogue(caster, units, "#champion_assistant_dialogue_5", 8, 5, -80, true)
							Timers:CreateTimer(4, function()
								basic_dialogue(Arena.ChampionsLeagueAttendant, units, "#arena_league_attendant_coach_arrive_end", 4, 5, -80)
							end)
							StartAnimation(Arena.ChampionsLeagueAttendant, {duration=1.7, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.6})
							EmitSoundOn("Arena.ChampionsAttendantLaugh", Arena.ChampionsLeagueAttendant)
							Arena.ChampionsLeague.state = 3
							Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, Arena.Coach, "modifier_walking_fast", {})
							Timers:CreateTimer(12, function()
								basic_dialogue(caster, units, "#champion_assistant_dialogue_6", 9, 5, -80, true)	
							end)
						end)
					end)
				end)
			end
		elseif Arena.ChampionsLeague.state == 3 then
			local destinationPoint = Vector(-8128, -2368)
			caster:MoveToPosition(destinationPoint)
			local distance = WallPhysics:GetDistance(destinationPoint, caster:GetAbsOrigin()*Vector(1,1,0))
			--print(distance)
			if distance < 200 then
				Arena.ChampionsLeague.state = 4
				caster:MoveToPosition(caster:GetAbsOrigin()+Vector(0,-10,0))
			end
		elseif Arena.ChampionsLeague.state == 4 then
			--print("state 4?")
			local units = GetNearbyHeroes(250, caster)
			if #units > 0 then
				Arena.ChampionsLeague.state = 5
				basic_dialogue(caster, units, "#champion_assistant_dialogue_7", 7, 5, -80, true)
				Timers:CreateTimer(7, function()
					basic_dialogue(caster, units, "#champion_assistant_dialogue_8", 7, 5, -80, true)
					Timers:CreateTimer(2, function()
						Arena.ChampionsLeague.state = 6
					end)
				end)
			end
		elseif Arena.ChampionsLeague.state == 6 then
			local destinationPoint = Vector(-9088, -1408)
			caster:MoveToPosition(destinationPoint)
			local distance = WallPhysics:GetDistance(destinationPoint, caster:GetAbsOrigin()*Vector(1,1,0))
			if distance < 200 then
				Arena.ChampionsLeague.state = 7
				caster:MoveToPosition(caster:GetAbsOrigin()+Vector(0,-10,0))
			end
		elseif Arena.ChampionsLeague.state == 7 then
			local units = GetNearbyHeroes(250, caster)
			if #units > 0 then
				Arena.ChampionsLeague.state = 8
				basic_dialogue(caster, units, "#champion_assistant_dialogue_9", 5, 5, -80, true)
				caster:MoveToPosition(caster:GetAbsOrigin()+Vector(-440, 60, 0))
				Timers:CreateTimer(5, function()
					caster:MoveToPosition(caster:GetAbsOrigin()+Vector(-120, 20, 0))
					basic_dialogue(caster, units, "#champion_assistant_dialogue_9a", 7, 5, -80, true)
				end)
			end
		elseif Arena.ChampionsLeague.state == 10 then
			local destinationPoint = Vector(-3623, -7168)
			caster:MoveToPosition(destinationPoint)
			local distance = WallPhysics:GetDistance(destinationPoint, caster:GetAbsOrigin()*Vector(1,1,0))
			if distance < 200 then
				Arena.ChampionsLeague.state = 11
				caster:MoveToPosition(caster:GetAbsOrigin()+Vector(0,10,0))
				Timers:CreateTimer(13, function()
					Arena.ChampionsLeague.state = 12
				end)
			end
		elseif Arena.ChampionsLeague.state == 12 then
			local destinationPoint = Vector(-9344, -2176)
			caster:MoveToPosition(destinationPoint)
			local distance = WallPhysics:GetDistance(destinationPoint, caster:GetAbsOrigin()*Vector(1,1,0))
			if distance < 200 then
				Arena.ChampionsLeague.state = 13
				MAIN_HERO_TABLE[1].ChampionsLeague.state = 0
				basic_dialogue(caster, units, "#champion_assistant_dialogue_12", 12, 5, -80, true)
			end
		elseif Arena.ChampionsLeague.state == 13 then
			local units = GetNearbyHeroes(250, caster)
			if #units > 0 then
				if Arena.ChampionsLeague.battlePrep then
					basic_dialogue(caster, units, "#champion_assistant_dialogue_12a", 12, 5, -80, true)
				else
					basic_dialogue(caster, units, "#champion_assistant_dialogue_12", 12, 5, -80, true)
				end
			end
			if Arena.ChampionsLeague.battlePrep then
				caster:MoveToPosition(battleLoc)
			end
		elseif Arena.ChampionsLeague.state == 16 or Arena.ChampionsLeague.state == 18 then
			if Arena.ChampionsLeague.battlePrep then
				caster:MoveToPosition(battleLoc)
				return
			end
			local destinationPoint = newbeeLoungeLoc
			local distance = WallPhysics:GetDistance(destinationPoint, caster:GetAbsOrigin()*Vector(1,1,0))
			if distance > 200 then
				caster:MoveToPosition(destinationPoint)
			else
				caster:Stop()
				caster:SetForwardVector(Vector(1,0))
			end
			local units = GetNearbyHeroes(250, caster)
			if #units > 0 then
				basic_dialogue(caster, units, "#champion_assistant_dialogue_16", 5, 5, -80, true)
			end
		elseif Arena.ChampionsLeague.state == 20 then

			local units = GetNearbyHeroes(250, caster)
			if #units > 0 then
				if Arena.ChampionsLeague.battlePrep then
					basic_dialogue(caster, units, "#champion_assistant_dialogue_12a", 12, 5, -80, true)
				else
					basic_dialogue(caster, units, "#champion_assistant_dialogue_22", 12, 5, -80, true)
				end
			end
			if Arena.ChampionsLeague.battlePrep then
				caster:MoveToPosition(battleLoc)
			end
		elseif Arena.ChampionsLeague.state == 21 then
			if Arena.ChampionsLeague.battlePrep then
				caster:MoveToPosition(battleLoc)
				return
			end
			local destinationPoint = majorLoungeLoc
			local distance = WallPhysics:GetDistance(destinationPoint, caster:GetAbsOrigin()*Vector(1,1,0))
			if distance > 200 then
				caster:MoveToPosition(destinationPoint)
			else
				caster:Stop()
				caster:SetForwardVector(Vector(1,-0.3))
			end
			local units = GetNearbyHeroes(250, caster)
			if #units > 0 then
				basic_dialogue(caster, units, "#champion_assistant_dialogue_48", 5, 5, -80, false)
			end
		elseif Arena.ChampionsLeague.state == 22 then
			if Arena.ChampionsLeague.battlePrep then
				caster:MoveToPosition(battleLoc)
				return
			end
			local destinationPoint = allstarLoungeLoc
			local distance = WallPhysics:GetDistance(destinationPoint, caster:GetAbsOrigin()*Vector(1,1,0))
			if distance > 200 then
				caster:MoveToPosition(destinationPoint)
			else
				caster:Stop()
				caster:SetForwardVector(Vector(0,-1))
			end
			local units = GetNearbyHeroes(250, caster)
			if #units > 0 then
				basic_dialogue(caster, units, "#champion_assistant_dialogue_59", 5, 5, -80, false)
			end
		end
	end
end

function GetNearbyHeroes(radius, caster)
	local position = caster:GetAbsOrigin()

    local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    local target_types = DOTA_UNIT_TARGET_HERO
    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	return units
end
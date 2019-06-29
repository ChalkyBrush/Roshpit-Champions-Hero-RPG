function Arena:CoachArriveFirstTime()
end

function Arena:ChampionsLeagueFirstSignUp()
	Arena:InitializeChampionsLeagueState()
	Arena:InitializeChampionsLeagueStateForHero(MAIN_HERO_TABLE[1])
	basic_dialogue(Arena.ChampionsLeagueAttendant, {MAIN_HERO_TABLE[1]}, "arena_league_attendant_calling_coach", 6, 5, -30, true)
	Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, Arena.Coach, "modifier_walking", {duration = 60})
	Timers:CreateTimer(0.5, function()
		StartAnimation(Arena.ChampionsLeagueAttendant, {duration = 1.7, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.6})
		for i = 1, 4, 1 do
			Timers:CreateTimer(i * 0.5, function()
				EmitSoundOn("Arena.Paging", Arena.ChampionsLeagueAttendant)
				Events:CreateCollectionBeam(Arena.ChampionsLeagueAttendant:GetAbsOrigin() + Vector(0, 0, 50), Arena.ChampionsLeagueAttendant:GetAbsOrigin() + Vector(0, 0, 600))
			end)
		end
	end)
end

function Arena:InitializeChampionsLeagueState()
	Arena.ChampionsLeague = {}
	Arena.ChampionsLeague.state = 0
	Arena.ChampionsLeague.battlePrep = false
end

function Arena:InitializeChampionsLeagueStateForHero(hero)
	hero.ChampionsLeague = {}
	hero.ChampionsLeague.state = -1
	hero.ChampionsLeague.rank = 21
	hero.ChampionsLeague.wins = 0
	hero.ChampionsLeague.fame = 0
	hero.ChampionsLeague.score20 = -1
	hero.ChampionsLeague.score19 = -1
	hero.ChampionsLeague.score18 = -1
	hero.ChampionsLeague.score17 = -1
	hero.ChampionsLeague.score16 = -1
	hero.ChampionsLeague.score15 = -1
	hero.ChampionsLeague.score14 = -1
	hero.ChampionsLeague.score13 = -1
	hero.ChampionsLeague.score12 = -1
	hero.ChampionsLeague.score11 = -1
	hero.ChampionsLeague.score10 = -1
	hero.ChampionsLeague.score9 = -1
	hero.ChampionsLeague.score8 = -1
	hero.ChampionsLeague.score7 = -1
	hero.ChampionsLeague.score6 = -1
	hero.ChampionsLeague.score5 = -1
	hero.ChampionsLeague.score4 = -1
	hero.ChampionsLeague.score3 = -1
	hero.ChampionsLeague.score2 = -1
	hero.ChampionsLeague.score1 = -1
end

function Arena:ChampionsLeagueRegisterForBattle(hero, rank)
	Arena.ChampionsLeague.battlePrep = true
	Arena.ChampionsLeague.timer = 55
	CustomGameEventManager:Send_ServerToAllClients("init_battle_timer", {timer = Arena.ChampionsLeague.timer})
	Arena.ReadyParticle = ParticleManager:CreateParticle("particles/newplayer_fx/npx_moveto_goal.vpcf", PATTACH_CUSTOMORIGIN, Arena.ArenaMaster)
	ParticleManager:SetParticleControl(Arena.ReadyParticle, 0, Vector(-6144, -2368, 1680))
	ParticleManager:SetParticleControl(Arena.ReadyParticle, 1, Vector(-6144, -2368, 1680))
	Arena:RaiseWalls(false, {Arena.Door1, Arena.Door4})
	Arena:RemoveArenaBlockers(true, false, true, false)
	Timers:CreateTimer(1, function()
		Arena.ChampionsLeague.timer = Arena.ChampionsLeague.timer - 1
		CustomGameEventManager:Send_ServerToAllClients("update_arena_timer", {timer = Arena.ChampionsLeague.timer})
		if Arena.ChampionsLeague.timer >= 1 then
			return 1
		else
			Arena:BeginBattle(hero, rank)
		end
	end)
end

function Arena:BeginBattle(hero, rank)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	local playerID = hero:GetPlayerOwnerID()

	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_command_restric_player", {duration = 80})

	hero:Stop()
	PlayerResource:SetCameraTarget(playerID, hero)

	ParticleManager:DestroyParticle(Arena.ReadyParticle, true)
	CustomGameEventManager:Send_ServerToAllClients("arena_fade_to_black", {fadeBackDelay = 1.3})
	Timers:CreateTimer(0.7, function()
		Arena:ClearOutsideEntities()
		Arena:ClearCrowd()

		FindClearSpaceForUnit(hero, Vector(-6016, -2432), false)
		hero:SetForwardVector(Vector(1, 0))
		FindClearSpaceForUnit(Arena.Coach, Vector(-6322, -2300), false)
		Arena.Coach:SetForwardVector(Vector(1, 0))
		Arena:BattleGeneric(hero, rank)
	end)
	hero:RemoveModifierByName("modifier_arena_guard_lock")
	Timers:CreateTimer(3.5, function()
		Arena:CreateArenaWalls(true, false, false, true)
		Arena:RaiseWalls(true, {Arena.Door1, Arena.Door4}, true)
	end)
	--print("BEGIN BATTLE!")
	Timers:CreateTimer(4, function()
		if IsValidEntity(Arena.fighter1) then
			UTIL_Remove(Arena.fighter1)
		end
		if IsValidEntity(Arena.fighter2) then
			UTIL_Remove(Arena.fighter2)
		end
	end)
end

function Arena:BattleRank20(hero)
	Arena.skipIntro = 0
	local playerID = hero:GetPlayerOwnerID()
	Arena.ChampionsLeague.state = 14
	Arena.ChampionsLeague.currentBattleRank = 20
	Arena.BetweenBattles = true
	Timers:CreateTimer(2.0, function()
		local crowdSize = RandomInt(3, 4)
		Arena:GenerateCrowd(crowdSize)
		local crowdSizeL = 1
		local crowdSizeR = crowdSize - crowdSizeL
		local bo = 3
		Arena.bo = bo
		Arena.crowdSizeL = crowdSizeL
		Arena.crowdSizeR = crowdSizeR
		Arena.scoreL = 0
		Arena.scoreR = 0
		Arena.style = 0
		local enemyName = "champion_league_challenger_20"
		CustomGameEventManager:Send_ServerToAllClients("init_battle_ui", {crowdSizeL = crowdSizeL, crowdSizeR = crowdSizeR, enemyName = enemyName, bo = bo})

		basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_13", 6, 5, -30)
		EmitSoundOnLocationWithCaster(Vector(-2701, -7935), "Arena.Cheer1", Events.GameMaster)
	end)
	Timers:CreateTimer(1.0, function()
		EmitSoundOnLocationWithCaster(Vector(-2670, -2446), "Arena.PreBattleMusic", Arena.ArenaMaster)
	end)
	Timers:CreateTimer(6, function()
		basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_14", 6, 5, -30)
	end)

	Arena:SpawnEnemyForRank(Arena.ChampionsLeague.currentBattleRank)
	Timers:CreateTimer(11, function()
		PlayerResource:SetCameraTarget(playerID, Arena.ChampionsLeagueOpponent)
		Timers:CreateTimer(1, function()
			Arena:RaiseWalls(false, {Arena.Door3}, true)
			Arena:RemoveArenaBlockers(false, false, true, false)
			Timers:CreateTimer(4, function()
				EmitSoundOnLocationWithCaster(Vector(-2701, -7935), "Arena.Cheer1", Arena.ChampionsLeagueOpponent)
				Arena.ChampionsLeagueOpponent:MoveToPosition(Vector(-2109, -2432))
				Timers:CreateTimer(10, function()
					EmitSoundOnLocationWithCaster(Vector(-2701, -7935), "Arena.Cheer1", Arena.ChampionsLeagueOpponent)
					PlayerResource:SetCameraTarget(playerID, hero)
					Timers:CreateTimer(1, function()
						Arena:RaiseWalls(false, {Arena.Door2}, true)
						Arena:RemoveArenaBlockers(false, true, false, false)
						Timers:CreateTimer(3, function()
							hero:MoveToPosition(Vector(-3328, -2432))
							Timers:CreateTimer(6.5, function()
								Arena:MakeVSClash(hero:GetUnitName(), "npc_dota_hero_dark_seer", "champion_league_challenger_20")
							end)
							Timers:CreateTimer(5, function()
								local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
								gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, Arena.ChampionsLeagueOpponent, "modifier_command_restric_player", {duration = 14})
							end)
							Timers:CreateTimer(14, function()
								Arena.ChampionsLeagueOpponent:SetAcquisitionRange(5000)
								Arena:ArenaStartSequence()
								Arena:CreateArenaWalls(false, true, true, false)
								Arena:RaiseWalls(true, {Arena.Door3, Arena.Door2}, false)
								Timers:CreateTimer(5, function()
									Arena.Timer = false
									Arena:StartBattleTimer()

									EmitSoundOnLocationWithCaster(Vector(-2701, -7935), "Arena.Cheer1", Events.GameMaster)
									hero:RemoveModifierByName("modifier_command_restric_player")
									PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
									Arena.ChampionsLeagueOpponent:MoveToPositionAggressive(hero:GetAbsOrigin())
									Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, hero, "modifier_arena_player", {})
									-- Arena:BattleMusic()
								end)
							end)
						end)
					end)
				end)
			end)
		end)
	end)

end

function Arena:PreBattleDialogue(rank)
	if rank == 20 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_13", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_14", 6, 5, -30, true)
		end)
	elseif rank == 19 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_17", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_19", 6, 5, -30, true)
		end)
	elseif rank == 18 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_23", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_24", 6, 5, -30, true)
		end)
	elseif rank == 17 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_25", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_26", 6, 5, -30, true)
		end)
	elseif rank == 16 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_28", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_29", 6, 5, -30, true)
		end)
	elseif rank == 15 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_30", 9, 5, -30, true)
	elseif rank == 14 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_33", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_34", 6, 5, -30, true)
		end)
	elseif rank == 13 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_35", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_36", 6, 5, -30, true)
		end)
	elseif rank == 12 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_37", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_38", 6, 5, -30, true)
		end)
	elseif rank == 11 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_39", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_40", 6, 5, -30, true)
		end)
	elseif rank == 10 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_44", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_45", 6, 5, -30, true)
		end)
	elseif rank == 9 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_46", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_47", 6, 5, -30, true)
		end)
	elseif rank == 8 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_49", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_50", 6, 5, -30, true)
		end)
	elseif rank == 7 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_51", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_52", 6, 5, -30, true)
		end)
	elseif rank == 6 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_53", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_54", 6, 5, -30, true)
		end)
	elseif rank == 5 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_57", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_58", 6, 5, -30, true)
		end)
	elseif rank == 4 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_60", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_61", 6, 5, -30, true)
		end)
		Timers:CreateTimer(15, function()
			if Arena.skipIntro == 0 then
				StartAnimation(Arena.ChampionsLeagueOpponent, {duration = 4, activity = ACT_DOTA_TAUNT, rate = 1.0, translate = "magic_ends_here"})
				EmitGlobalSound("Arena.Cheer4")
			end
		end)
	elseif rank == 3 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_62", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_63", 6, 5, -30, true)
		end)
	elseif rank == 2 then
		basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_66", 5, 5, -30, true)
		Timers:CreateTimer(5.1, function()
			basic_dialogue(Arena.Coach, MAIN_HERO_TABLE, "champion_assistant_dialogue_67", 6, 5, -30, true)
		end)
	end
end

function Arena:GetPortraitForChallenger(rank)
	if rank == 20 then
		return "npc_dota_hero_dark_seer"
	elseif rank == 19 then
		return "npc_dota_hero_phantom_assassin"
	elseif rank == 18 then
		return "npc_dota_hero_alchemist"
	elseif rank == 17 then
		return "npc_dota_hero_brewmaster"
	elseif rank == 16 then
		return "npc_dota_hero_centaur"
	elseif rank == 15 then
		return "npc_dota_hero_riki"
	elseif rank == 14 then
		return "npc_dota_hero_bristleback"
	elseif rank == 13 then
		return "npc_dota_hero_ursa"
	elseif rank == 12 then
		return "npc_dota_hero_troll_warlord"
	elseif rank == 11 then
		return "npc_dota_hero_axe"
	elseif rank == 10 then
		return "npc_dota_hero_skeleton_king"
	elseif rank == 9 then
		return "npc_dota_hero_silencer"
	elseif rank == 8 then
		return "npc_dota_hero_beastmaster"
	elseif rank == 7 then
		return "npc_dota_hero_phantom_lancer"
	elseif rank == 6 then
		return "npc_dota_hero_bane"
	elseif rank == 5 then
		return "npc_dota_hero_dragon_knight"
	elseif rank == 4 then
		return "npc_dota_hero_antimage"
	elseif rank == 3 then
		return "npc_dota_hero_rubick"
	elseif rank == 2 then
		return "npc_dota_hero_sven"
	elseif rank == 1 then
		return "npc_dota_hero_omniknight"
	end
end

function Arena:GetCrowdForChallenger(rank)
	local crowdSize = 0
	local crowdSizeL = 0
	local bo = 3
	if rank == 20 then
		crowdSize = RandomInt(3, 4)
		crowdSizeL = 1
	elseif rank == 19 then
		crowdSize = RandomInt(5, 6)
		crowdSizeL = RandomInt(1, 2)
	elseif rank == 18 then
		crowdSize = RandomInt(7, 8)
		crowdSizeL = RandomInt(5, 6)
	elseif rank == 17 then
		crowdSize = RandomInt(10, 11)
		crowdSizeL = RandomInt(6, 7)
	elseif rank == 16 then
		crowdSize = RandomInt(11, 12)
		crowdSizeL = RandomInt(5, 6)
	elseif rank == 15 then
		crowdSize = RandomInt(12, 13)
		crowdSizeL = RandomInt(7, 8)
	elseif rank == 14 then
		crowdSize = RandomInt(13, 14)
		crowdSizeL = RandomInt(7, 8)
	elseif rank == 13 then
		crowdSize = RandomInt(14, 15)
		crowdSizeL = RandomInt(7, 10)
	elseif rank == 12 then
		crowdSize = RandomInt(15, 16)
		crowdSizeL = RandomInt(7, 8)
	elseif rank == 11 then
		crowdSize = RandomInt(16, 17)
		crowdSizeL = RandomInt(5, 6)
	elseif rank == 10 then
		crowdSize = RandomInt(22, 25)
		crowdSizeL = RandomInt(19, 20)
	elseif rank == 9 then
		crowdSize = RandomInt(24, 27)
		crowdSizeL = RandomInt(10, 15)
	elseif rank == 8 then
		crowdSize = RandomInt(26, 29)
		crowdSizeL = RandomInt(10, 15)
	elseif rank == 7 then
		crowdSize = RandomInt(28, 31)
		crowdSizeL = RandomInt(10, 15)
	elseif rank == 6 then
		crowdSize = RandomInt(15, 20)
		crowdSizeL = crowdSize - 1
	elseif rank == 5 then
		crowdSize = RandomInt(36, 40)
		crowdSizeL = RandomInt(5, 10)
	elseif rank == 4 then
		crowdSize = 50
		crowdSizeL = 0
	elseif rank == 3 then
		crowdSize = RandomInt(44, 46)
		crowdSizeL = RandomInt(15, 18)
	elseif rank == 2 then
		crowdSize = RandomInt(46, 52)
		crowdSizeL = RandomInt(24, 28)
	elseif rank == 1 then
		bo = 5
		crowdSize = RandomInt(54, 60)
		crowdSizeL = RandomInt(24, 28)
	end
	return crowdSize, crowdSizeL, bo
end

function Arena:SpawnEnemyForRank(rank)
	if rank == 20 then
		Arena.MaxStyle = 100
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_20", Vector(384, -2207), Vector(-1, 0), 2, 2, 1.0)
	elseif rank == 19 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_19", Vector(384, -2207), Vector(-1, 0), 2, 3, 0.95)
		Arena.ChampionsLeagueOpponent:SetRenderColor(0, 0, 0)
	elseif rank == 18 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_18", Vector(384, -2207), Vector(-1, 0), 2, 7, 0.8)
	elseif rank == 17 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_17", Vector(384, -2207), Vector(-1, 0), 3, 5, 0.75)
	elseif rank == 16 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_16", Vector(384, -2207), Vector(-1, 0), 3, 5, 0.5)
	elseif rank == 15 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_15", Vector(384, -2207), Vector(-1, 0), 3, 5, 0.6)
	elseif rank == 14 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_14", Vector(384, -2207), Vector(-1, 0), 4, 7, 1.0)
	elseif rank == 13 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_13", Vector(384, -2207), Vector(-1, 0), 0, 10, 0.4)
		local ability = Arena.ChampionsLeagueOpponent:FindAbilityByName("arena_ursa_major_passive")
		ability:ApplyDataDrivenModifier(Arena.ChampionsLeagueOpponent, Arena.ChampionsLeagueOpponent, "modifier_challenger_13_immune", {})
	elseif rank == 12 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_12", Vector(384, -2207), Vector(-1, 0), 1, 10, 0.3)
	elseif rank == 11 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_11", Vector(384, -2207), Vector(-1, 0), 6, 10, 0.3)
	elseif rank == 10 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_10", Vector(384, -2207), Vector(-1, 0), 5, 10, 0.1)
	elseif rank == 9 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_9", Vector(384, -2207), Vector(-1, 0), 1, 1, 0.1)
	elseif rank == 8 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_8", Vector(384, -2207), Vector(-1, 0), 1, 1, 0.009)
		Arena.ChampionsLeagueOpponent:SetRenderColor(67, 64, 47)
	elseif rank == 7 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_7", Vector(384, -2207), Vector(-1, 0), 1, 1, 0.01)
	elseif rank == 6 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_6", Vector(384, -2207), Vector(-1, 0), 1, 1, 0.01)
	elseif rank == 5 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_5", Vector(384, -2207), Vector(-1, 0), 10, 10, 0.01)
	elseif rank == 4 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_4", Vector(384, -2207), Vector(-1, 0), 1, 10, 0.005)
	elseif rank == 3 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_3_a", Vector(384, -2207), Vector(-1, 0), 1, 10, 0.01)
		Arena.ChampionsLeagueOpponent:SetRenderColor(255, 120, 120)
	elseif rank == 2 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_2", Vector(384, -2207), Vector(-1, 0), 1, 10, 0.002)
		Arena.ChampionsLeagueOpponent:SetRenderColor(80, 80, 80)
	elseif rank == 1 then
		Arena.ChampionsLeagueOpponent = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_1", Vector(384, -2207), Vector(-1, 0), 1, 10, 0.001)
	end
	Arena.ChampionsLeagueOpponent.aggro = true
end

function Arena:GetTimeBonus(battleRank)
	local bonus = 0
	if battleRank == 20 then
		bonus = math.max(120 - Arena.Timer, 0)
	elseif battleRank == 19 then
		bonus = math.max(120 - Arena.Timer, 0)
	elseif battleRank == 18 then
		bonus = math.max(180 - Arena.Timer, 0)
	elseif battleRank == 17 then
		bonus = math.max(180 - Arena.Timer, 0)
	elseif battleRank == 16 then
		bonus = math.max(280 - Arena.Timer, 0)
	elseif battleRank == 15 then
		bonus = math.max(180 - Arena.Timer, 0)
	elseif battleRank == 14 then
		bonus = math.max(180 - Arena.Timer, 0)
	elseif battleRank == 13 then
		bonus = math.max(180 - Arena.Timer, 0)
	elseif battleRank == 12 then
		bonus = math.max(160 - Arena.Timer, 0)
	elseif battleRank == 11 then
		bonus = math.max(160 - Arena.Timer, 0)
	elseif battleRank == 10 then
		bonus = math.max(200 - Arena.Timer, 0)
	elseif battleRank == 9 then
		bonus = math.max(250 - Arena.Timer, 0)
	elseif battleRank == 8 then
		bonus = math.max(300 - Arena.Timer, 0)
	elseif battleRank == 7 then
		bonus = math.max(300 - Arena.Timer, 0)
	elseif battleRank == 6 then
		bonus = math.max(400 - Arena.Timer, 0)
	elseif battleRank == 5 then
		bonus = math.max(380 - Arena.Timer, 0)
	elseif battleRank == 4 then
		bonus = math.max(380 - Arena.Timer, 0)
	elseif battleRank == 3 then
		bonus = math.max(380 - Arena.Timer, 0)
	elseif battleRank == 2 then
		bonus = math.max(380 - Arena.Timer, 0)
	elseif battleRank == 1 then
		bonus = math.max(420 - Arena.Timer, 0)
	end
	return bonus
end

function Arena:BattleGeneric(hero, rank)
	CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
	local playerID = hero:GetPlayerOwnerID()
	local challengerRank = rank
	Arena.ChampionsLeague.currentBattleRank = challengerRank
	Arena.BetweenBattles = true
	Arena.BattleScene = true
	Arena.skipIntro = 0
	local cheerSound = "Arena.Cheer1"
	if rank < 10 then
		cheerSound = "Arena.Cheer3"
	elseif rank < 15 then
		cheerSound = "Arena.Cheer2"
	end
	Timers:CreateTimer(2.0, function()
		local crowdSize, crowdSizeL, bo = Arena:GetCrowdForChallenger(challengerRank)
		Arena:GenerateCrowd(crowdSize)
		local crowdSizeR = crowdSize - crowdSizeL
		Arena.bo = bo
		Arena.crowdSizeL = crowdSizeL
		Arena.crowdSizeR = crowdSizeR
		Arena.scoreL = 0
		Arena.scoreR = 0
		Arena.style = 0
		local enemyName = "champion_league_challenger_"..challengerRank
		CustomGameEventManager:Send_ServerToAllClients("init_battle_ui", {crowdSizeL = crowdSizeL, crowdSizeR = crowdSizeR, enemyName = enemyName, bo = bo})
		Arena:PreBattleDialogue(challengerRank)
		EmitSoundOnLocationWithCaster(Vector(-2701, -7935), cheerSound, Events.GameMaster)
	end)
	Timers:CreateTimer(1.0, function()
		CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.PreBattleMusic"})
	end)
	Arena:SpawnEnemyForRank(Arena.ChampionsLeague.currentBattleRank)
	Timers:CreateTimer(11 - (11 * Arena.skipIntro), function()
		if Arena.skipIntro == 0 then
			PlayerResource:SetCameraTarget(playerID, Arena.ChampionsLeagueOpponent)
		end
		Timers:CreateTimer(1 - Arena.skipIntro, function()
			Arena:RaiseWalls(false, {Arena.Door3}, true)
			Arena:RemoveArenaBlockers(false, false, true, false)

			Timers:CreateTimer(4 - (Arena.skipIntro * 4), function()
				EmitSoundOnLocationWithCaster(Vector(-2701, -7935), cheerSound, Arena.ChampionsLeagueOpponent)
				if Arena.skipIntro == 0 then
					Arena.ChampionsLeagueOpponent:MoveToPosition(Vector(-2109, -2432))
				else
					FindClearSpaceForUnit(Arena.ChampionsLeagueOpponent, Vector(-2109, -2432), false)
				end
				Timers:CreateTimer(10 - (Arena.skipIntro * 10), function()
					EmitSoundOnLocationWithCaster(Vector(-2701, -7935), cheerSound, Arena.ChampionsLeagueOpponent)
					PlayerResource:SetCameraTarget(playerID, hero)
					Timers:CreateTimer(1 - Arena.skipIntro, function()

						Arena:RaiseWalls(false, {Arena.Door2}, true)
						Arena:RemoveArenaBlockers(false, true, false, false)

						Timers:CreateTimer(3 - (Arena.skipIntro * 3), function()
							if Arena.skipIntro == 0 then
								hero:MoveToPosition(Vector(-3328, -2432))
							else
								FindClearSpaceForUnit(hero, Vector(-3328, -2432), false)
							end
							Timers:CreateTimer(6.5 - (Arena.skipIntro * 5.5), function()
								if Arena.skipIntro == 1 then
									CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
								end
								Arena:MakeVSClash(hero:GetUnitName(), Arena:GetPortraitForChallenger(challengerRank), "champion_league_challenger_"..challengerRank)
							end)
							Timers:CreateTimer(14 - (Arena.skipIntro * 9), function()
								CustomGameEventManager:Send_ServerToAllClients("hide_arena_skip", {})
								Arena.ChampionsLeagueOpponent:SetAcquisitionRange(5000)
								Arena.ChampionsLeagueOpponent.opponent = hero
								Arena:ArenaStartSequence()
								Arena:CreateArenaWalls(false, true, true, false)
								Arena:RaiseWalls(true, {Arena.Door3, Arena.Door2}, false)
								Timers:CreateTimer(5, function()
									Arena.Timer = false
									Arena:StartBattleTimer()

									EmitSoundOnLocationWithCaster(Vector(-2701, -7935), "Arena.Cheer1", Events.GameMaster)
									hero:RemoveModifierByName("modifier_command_restric_player")
									Arena.ChampionsLeagueOpponent:RemoveModifierByName("modifier_command_restric_player")
									PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
									Arena.ChampionsLeagueOpponent:MoveToPositionAggressive(hero:GetAbsOrigin())
									Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, hero, "modifier_arena_player", {})
									-- Arena:BattleMusic()
								end)
							end)
						end)
					end)
				end)
			end)
		end)
	end)

end

function Arena:ArenaStartSequence()
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, Arena.ChampionsLeagueOpponent, "modifier_command_restric_player", {duration = 5})
	Arena.Starter:SetRenderColor(0, 0, 0)
	for i = 1, 35, 1 do
		Timers:CreateTimer(i * 0.03, function()
			Arena.Starter:SetAbsOrigin(Arena.Starter:GetAbsOrigin() + Vector(0, 0, 9.1))
		end)

	end
	Timers:CreateTimer(2, function()
		Arena.Starter:SetRenderColor(255, 0, 0)
		EmitSoundOnLocationWithCaster(Arena.Starter:GetAbsOrigin(), "Arena.Countdown", Arena.ArenaMaster)
	end)
	Timers:CreateTimer(3, function()
		Arena.Starter:SetRenderColor(255, 255, 0)
		EmitSoundOnLocationWithCaster(Arena.Starter:GetAbsOrigin(), "Arena.Countdown", Arena.ArenaMaster)
	end)
	Timers:CreateTimer(4, function()
		Arena.Starter:SetRenderColor(0, 255, 0)
		EmitSoundOnLocationWithCaster(Arena.Starter:GetAbsOrigin(), "Arena.Countdown", Arena.ArenaMaster)
	end)
	Timers:CreateTimer(5, function()
		Arena.Starter:SetRenderColor(255, 255, 255)
		EmitSoundOnLocationWithCaster(Arena.Starter:GetAbsOrigin(), "Arena.Countdown", Arena.ArenaMaster)
		EmitSoundOnLocationWithCaster(Arena.Starter:GetAbsOrigin(), "Arena.BattleStart", Events.GameMaster)
	end)
	Timers:CreateTimer(7, function()
		for i = 1, 35, 1 do
			Timers:CreateTimer(i * 0.03, function()
				Arena.Starter:SetAbsOrigin(Arena.Starter:GetAbsOrigin() - Vector(0, 0, 9.1))
			end)
		end
	end)
end

function Arena:MakeVSClash(allyHero, enemyHero, enemyName)
	CustomGameEventManager:Send_ServerToAllClients("vs_clash", {enemyHero = enemyHero, allyHero = allyHero, enemyName = enemyName})
end

function Arena:ClearOutsideEntities()
	for i = 1, #Arena.OutsideEntitiesTable, 1 do
		Timers:CreateTimer(i * 0.03, function()
			if IsValidEntity(Arena.OutsideEntitiesTable[i]) then
				UTIL_Remove(Arena.OutsideEntitiesTable[i])
			end
		end)
	end
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local target = MAIN_HERO_TABLE[i]
		target:RemoveModifierByName("modifier_arena_guard_lock")
		target:RemoveModifierByName("modifier_arena_guard_moving")
	end
end

function Arena:ClearCrowd()
	for i = 1, #Arena.Crowd, 1 do
		if IsValidEntity(Arena.Crowd[i]) then
			UTIL_Remove(Arena.Crowd[i])
		end
	end
end

function Arena:CreateArenaWalls(b1, b2, b3, b4)
	Timers:CreateTimer(0.5, function()
		if b1 then
			Arena.Wall1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-6708, -2112, 128)})
			Arena.Wall2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-6708, -2240, 128)})
			Arena.Wall3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-6708, -2368, 128)})
			Arena.Wall4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-6708, -2496, 128)})
		end

		if b2 then
			Arena.Wall5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5696, -2496, 128)})
			Arena.Wall6 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5696, -2368, 128)})
			Arena.Wall7 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5696, -2240, 128)})
			Arena.Wall8 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5696, -2112, 128)})
		end

		if b3 then
			Arena.Wall9 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(64, -1984, 128)})
			Arena.Wall10 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(64, -2112, 128)})
			Arena.Wall11 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(64, -2240, 128)})
			Arena.Wall12 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(64, -2368, 128)})
		end

		if b4 then
			Arena.Wall13 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1152, -2432, 128)})
			Arena.Wall14 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1152, -2304, 128)})
			Arena.Wall15 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1152, -2176, 128)})
			Arena.Wall16 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1152, -2048, 128)})
		end
	end)

end

function Arena:RemoveArenaBlockers(b1, b2, b3, b4)
	local blockers = {}
	if b1 then
		table.insert(blockers, Arena.Wall1)
		table.insert(blockers, Arena.Wall2)
		table.insert(blockers, Arena.Wall3)
		table.insert(blockers, Arena.Wall4)
	end
	if b2 then
		table.insert(blockers, Arena.Wall5)
		table.insert(blockers, Arena.Wall6)
		table.insert(blockers, Arena.Wall7)
		table.insert(blockers, Arena.Wall8)
	end
	if b3 then
		table.insert(blockers, Arena.Wall9)
		table.insert(blockers, Arena.Wall10)
		table.insert(blockers, Arena.Wall11)
		table.insert(blockers, Arena.Wall12)
	end
	if b4 then
		table.insert(blockers, Arena.Wall13)
		table.insert(blockers, Arena.Wall14)
		table.insert(blockers, Arena.Wall15)
		table.insert(blockers, Arena.Wall16)
	end
	for i = 1, #blockers, 1 do
		if IsValidEntity(blockers[i]) then
			UTIL_Remove(blockers[i])
		end
	end
end

function Arena:InitArenaDoors()
	Arena.Door1 = Entities:FindByNameNearest("ArenaWall", Vector(-6753, -2314, -100), 600)
	Arena.Door2 = Entities:FindByNameNearest("ArenaWall", Vector(-5674, -2314, -100), 600)
	Arena.Door3 = Entities:FindByNameNearest("ArenaWall", Vector(64, -2206, -100), 600)
	Arena.Door4 = Entities:FindByNameNearest("ArenaWall", Vector(1165, -2216, -100), 600)
	Arena.Starter = Entities:FindByNameNearest("BattleStarter", Vector(-2688, -2447, -211), 600)
end

function Arena:RaiseWalls(bRaise, walls, bSound)
	local movementZ = 5.1
	if not bRaise then
		movementZ = -5.1
	end
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			if bSound then
				for i = 1, #walls, 1 do
					EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Arena.WallOpen", Events.GameMaster)
				end
			end
		end)
		for i = 1, 90, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i * 0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, movementZ))
					-- if j == 1 then
					-- ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					-- end
				end)
			end
		end
	end
end

function Arena:ChampionsLeagueStatsScreen(hero, bWin)
	if bWin then
		local timeBonus = Arena:GetTimeBonus(Arena.ChampionsLeague.currentBattleRank)
		local crowdBonus = Arena:GetStyleBonus()
		Arena:ChampionsBattleEnd(hero, hero:GetUnitName(), true, timeBonus, crowdBonus)
		Arena:SaveChampionsLeagueData(hero, Arena.ChampionsLeague.currentBattleRank, timeBonus + crowdBonus)
	else
		Arena:ChampionsBattleEnd(hero, hero:GetUnitName(), false, 0, 0)
	end
	Arena.BattleScene = false
end

function Arena:LoseChampionsLeague(hero)
	CustomGameEventManager:Send_ServerToAllClients("clear_battle_ui", {})
	Arena:ClearCrowd()
	Arena:SpawnArenaOutsideEntities()
	Arena.BetweenBattles = false
	Arena.ChampionsLeague.battlePrep = false
	hero:RemoveModifierByName("modifier_arena_player")
	Arena:StartingMusic()
	UTIL_Remove(Arena.ChampionsLeagueOpponent)
	Timers:CreateTimer(2, function()
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
	end)
	if hero.ChampionsLeague.rank == 21 then
		FindClearSpaceForUnit(Arena.Coach, Vector(-9920, -2048), false)
	else
		FindClearSpaceForUnit(Arena.Coach, Vector(-9920, -2048), false)
	end
end

function Arena:WinChampionsLeague(hero)
	Arena.BetweenBattles = false
	CustomGameEventManager:Send_ServerToAllClients("clear_battle_ui", {})
	Arena.ChampionsLeague.battlePrep = false
	hero:RemoveModifierByName("modifier_arena_player")
	UTIL_Remove(Arena.ChampionsLeagueOpponent)
	Arena:ClearCrowd()
	if hero.ChampionsLeague.rank == 2 and Arena.ChampionsLeague.currentBattleRank == 1 then
	else
		Arena:StartingMusic()
		Arena:SpawnArenaOutsideEntities()
	end
	Timers:CreateTimer(2, function()
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
	end)
	FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
	--print(hero.ChampionsLeague.rank)
	--print(Arena.ChampionsLeague.currentBattleRank)
	Timers:CreateTimer(0.7, function()
		FindClearSpaceForUnit(hero, Vector(-7680, -2732), false)
		if hero.ChampionsLeague.rank == 21 and Arena.ChampionsLeague.currentBattleRank == 20 then
			Arena.ChampionsLeague.state = 15
			hero.ChampionsLeague.rank = 20
			FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_15", 6, 5, -30, true)
			end)
			Timers:CreateTimer(6, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_15a", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					Arena.ChampionsLeague.state = 16
				end)
			end)
		elseif hero.ChampionsLeague.rank == 20 and Arena.ChampionsLeague.currentBattleRank == 19 then
			Arena.ChampionsLeague.state = 15
			hero.ChampionsLeague.rank = 19
			FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_20", 6, 5, -30, true)
			end)
			Timers:CreateTimer(6, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_21", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					Arena.ChampionsLeague.state = 18
				end)
			end)
		elseif hero.ChampionsLeague.rank == 19 and Arena.ChampionsLeague.currentBattleRank == 18 then
			hero.ChampionsLeague.rank = 18
			Arena.ChampionsLeague.state = 20
		elseif hero.ChampionsLeague.rank == 18 and Arena.ChampionsLeague.currentBattleRank == 17 then
			hero.ChampionsLeague.rank = 17
			Arena.ChampionsLeague.state = 15
			FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_27", 6, 5, -30, true)
				Arena.ChampionsLeague.state = 20
			end)
		elseif hero.ChampionsLeague.rank == 17 and Arena.ChampionsLeague.currentBattleRank == 16 then
			hero.ChampionsLeague.rank = 16
			Arena.ChampionsLeague.state = 18
		elseif hero.ChampionsLeague.rank == 16 and Arena.ChampionsLeague.currentBattleRank == 15 then
			Arena.ChampionsLeague.state = 17
			hero.ChampionsLeague.rank = 15
			FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_31", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_32", 6, 5, -30, true)
					Arena.ChampionsLeague.state = 18
				end)
			end)
		elseif hero.ChampionsLeague.rank == 15 and Arena.ChampionsLeague.currentBattleRank == 14 then
			hero.ChampionsLeague.rank = 14
			Arena.ChampionsLeague.state = 18
		elseif hero.ChampionsLeague.rank == 14 and Arena.ChampionsLeague.currentBattleRank == 13 then
			hero.ChampionsLeague.rank = 13
			Arena.ChampionsLeague.state = 18
		elseif hero.ChampionsLeague.rank == 13 and Arena.ChampionsLeague.currentBattleRank == 12 then
			hero.ChampionsLeague.rank = 12
			Arena.ChampionsLeague.state = 18
		elseif hero.ChampionsLeague.rank == 12 and Arena.ChampionsLeague.currentBattleRank == 11 then
			hero.ChampionsLeague.rank = 11
			Arena.ChampionsLeague.state = 19
			FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_41", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_42", 6, 5, -30, true)
					Timers:CreateTimer(6, function()
						basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_43", 6, 5, -30, true)
					end)
				end)
			end)
		elseif hero.ChampionsLeague.rank == 11 and Arena.ChampionsLeague.currentBattleRank == 10 then
			hero.ChampionsLeague.rank = 10
			Arena.ChampionsLeague.state = 19
			FindClearSpaceForUnit(hero, Vector(-6912, 3392), false)
			FindClearSpaceForUnit(Arena.Coach, Vector(-7178, 3581), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_45a", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_45b", 6, 5, -30, true)
					Timers:CreateTimer(6, function()
						basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_45c", 6, 5, -30, true)
						Timers:CreateTimer(4, function()
							Arena.ChampionsLeague.state = 21
						end)
					end)
				end)
			end)
		elseif hero.ChampionsLeague.rank == 10 and Arena.ChampionsLeague.currentBattleRank == 9 then
			hero.ChampionsLeague.rank = 9
			Arena.ChampionsLeague.state = 21
		elseif hero.ChampionsLeague.rank == 9 and Arena.ChampionsLeague.currentBattleRank == 8 then
			hero.ChampionsLeague.rank = 8
			Arena.ChampionsLeague.state = 21
		elseif hero.ChampionsLeague.rank == 8 and Arena.ChampionsLeague.currentBattleRank == 7 then
			hero.ChampionsLeague.rank = 7
			Arena.ChampionsLeague.state = 21
		elseif hero.ChampionsLeague.rank == 7 and Arena.ChampionsLeague.currentBattleRank == 6 then
			hero.ChampionsLeague.rank = 6
			Arena.ChampionsLeague.state = 19
			FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_55", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_56", 6, 5, -30, true)
					Arena.ChampionsLeague.state = 22
				end)
			end)
		elseif hero.ChampionsLeague.rank == 6 and Arena.ChampionsLeague.currentBattleRank == 5 then
			hero.ChampionsLeague.rank = 5
			Arena.ChampionsLeague.state = 19
			FindClearSpaceForUnit(hero, Vector(-2880, 2624), false)
			FindClearSpaceForUnit(Arena.Coach, Vector(-2624, 2752), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_59", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_59a", 6, 5, -30, true)
					Arena.ChampionsLeague.state = 22
				end)
			end)
		elseif hero.ChampionsLeague.rank == 5 and Arena.ChampionsLeague.currentBattleRank == 4 then
			hero.ChampionsLeague.rank = 4
			Arena.ChampionsLeague.state = 22
		elseif hero.ChampionsLeague.rank == 4 and Arena.ChampionsLeague.currentBattleRank == 3 then
			hero.ChampionsLeague.rank = 3
			Arena.ChampionsLeague.state = 17
			FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_64", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_65", 6, 5, -30, true)
					Arena.ChampionsLeague.state = 22
				end)
			end)
		elseif hero.ChampionsLeague.rank == 3 and Arena.ChampionsLeague.currentBattleRank == 2 then
			hero.ChampionsLeague.rank = 2
			Arena.ChampionsLeague.state = 17
			FindClearSpaceForUnit(Arena.Coach, Vector(-7680, -2432), false)
			local fv = ((hero:GetAbsOrigin() - Arena.Coach:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			Arena.Coach:SetForwardVector(fv)
			Timers:CreateTimer(2, function()
				basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_68", 6, 5, -30, true)
				Timers:CreateTimer(6, function()
					basic_dialogue(Arena.Coach, {hero}, "champion_assistant_dialogue_69", 6, 5, -30, true)
					Arena.ChampionsLeague.state = 22
				end)
			end)
		elseif hero.ChampionsLeague.rank == 2 and Arena.ChampionsLeague.currentBattleRank == 1 then
			hero.ChampionsLeague.rank = 1
			Arena:GrandVictorySequence(hero)
		else
			Arena:SetUpArenaForChampionsLeagueRank(hero.ChampionsLeague.rank)
		end
	end)

	Timers:CreateTimer(12, function()
		Arena:SetUpArenaForChampionsLeagueRank(hero.ChampionsLeague.rank)
	end)
end

function Arena:GetStyleBonus()
	local points = math.ceil(Arena.crowdSizeL * 100 / (Arena.crowdSizeL + Arena.crowdSizeR))
	points = math.min(points, 100)
	return points
end

function Arena:StartBattleTimer()
	if not Arena.Timer then
		Arena.Timer = 0
	end
	Arena.BetweenBattles = false
	Timers:CreateTimer(1, function()
		if not Arena.BetweenBattles then
			Arena.Timer = Arena.Timer + 1
			CustomGameEventManager:Send_ServerToAllClients("update_battle_timer", {timeElapsed = Arena.Timer})
			return 1
		end
	end)
end

function Arena:StopBattleTimer()
	Arena.BetweenBattles = true
end

function Arena:ChampionsBattleEnd(hero, allyHero, bWin, timeBonus, styleBonus)
	-- local allyHero = MAIN_HERO_TABLE[1]:GetUnitName()
	-- local outcomeMessage = '#arena_battle_lost'
	-- local timeBonus = 100
	-- local styleBonus = 50
	-- local rank = 21
	-- local rankUp = 1
	local rank = hero.ChampionsLeague.rank
	local outcomeMessage = '#arena_battle_lost'
	if bWin then
		outcomeMessage = '#arena_battle_win'
		Timers:CreateTimer(10, function()
			Arena:RollPrizebox(Arena.ChampionsLeague.currentBattleRank, timeBonus + styleBonus, hero)
		end)
	end
	local rankUp = 0
	if Arena.ChampionsLeague.currentBattleRank < rank and bWin then
		rankUp = 1
	end
	CustomGameEventManager:Send_ServerToAllClients("champions_league_lose", {allyHero = allyHero, outcomeMessage = outcomeMessage, timeBonus = timeBonus, styleBonus = styleBonus, rank = rank, rankUp = rankUp})
	Arena.ChampionsLeague.rankUp = false
end

function Arena:SetUpArenaForChampionsLeagueRank(rank)
	if not Arena.ChampionsLeague then
		Arena.ChampionsLeague = {}
	end
	if rank == 20 then
		Arena.ChampionsLeague.state = 16
	elseif rank == 19 then
		Arena.ChampionsLeague.state = 18
	elseif rank >= 11 then
		Arena.ChampionsLeague.state = 16
	elseif rank >= 6 then
		Arena.ChampionsLeague.state = 21
	elseif rank <= 5 then
		Arena.ChampionsLeague.state = 22
	else
		Arena.ChampionsLeague.state = 18
	end
end

function Arena:OgreSequence(hero)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_command_restric_player", {duration = 8})
	local ogre = Arena.Challenger18
	ogre:MoveToPosition(hero:GetAbsOrigin() - (hero:GetForwardVector() * 90))
	basic_dialogue(ogre, {hero}, "arena_champion_18_taunt", 8, 5, -30, true)
	Timers:CreateTimer(3.2, function()
		StartAnimation(ogre, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1})
		local ogreAbil = ogre:FindAbilityByName("arena_gorewreck_passive")

		Timers:CreateTimer(0.3, function()
			EmitSoundOn("Arena.ChampionsLeague.OgrePunch", hero)
			ogreAbil:ApplyDataDrivenModifier(ogre, hero, "modifier_gorewreck_stun", {duration = 6})
			hero:SetHealth(5)
		end)
		Timers:CreateTimer(3, function()
			Arena.Coach:MoveToPosition(Vector(-9920, -1280))
		end)
		Timers:CreateTimer(5, function()
			basic_dialogue(Arena.Coach, {hero}, "arena_coach_18_defend_taunt", 8, 5, -30, true)
			StartAnimation(ogre, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.5})
		end)
		Timers:CreateTimer(9, function()
			Arena.ChampionsLeague.state = 20
			EmitSoundOn("Arena.ChampionsLeague.OgreLaugh", ogre)
			basic_dialogue(ogre, {hero}, "arena_champion_18_ready", 8, 5, -30, true)
			ogre:MoveToPosition(Vector(1728, -2240))
		end)
	end)
end

function Arena:RubickBroTakeDamage(attacker, rubick)
	if rubick.bro:GetHealth() > rubick:GetHealth() then
		if rubick:GetHealth() > 0 then
			rubick.bro:SetHealth(rubick:GetHealth())
		else
			ApplyDamage({victim = rubick.bro, attacker = caster, damage = rubick.bro:GetMaxHealth(), damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function Arena:GrandVictorySequence(hero)
	Arena.ChampionsLeague.state = 17
	FindClearSpaceForUnit(hero, Vector(-2669, -2581), false)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_command_restric_player", {duration = 20})
	gameMasterAbil:ApplyDataDrivenModifier(Arena.Coach, hero, "modifier_command_restric_player", {duration = 20})
	FindClearSpaceForUnit(Arena.Coach, Vector(-2891, -2345), false)
	StartAnimation(hero, {duration = 20, activity = ACT_DOTA_VICTORY, rate = 1.0})
	CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.GrandVictory"})
	hero:SetForwardVector(Vector(0, -1))
	Arena.Coach:SetForwardVector(Vector(0, -1))
	local particleTable = {}
	Timers:CreateTimer(2, function()
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
	end)
	for i = 1, 6, 1 do
		Timers:CreateTimer(3 * i, function()
			EmitGlobalSound("Arena.Cheer"..RandomInt(3, 4))
		end)
	end
	local lightningBolt = ParticleManager:CreateParticle("particles/themed_fx/cny_fireworks_rockets_c.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(-3200, -2944, -500))
	table.insert(particleTable, lightningBolt)

	local lightningBolt = ParticleManager:CreateParticle("particles/themed_fx/cny_fireworks_rockets_c.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(-1948, -2468, -500))
	table.insert(particleTable, lightningBolt)

	local lightningBolt = ParticleManager:CreateParticle("particles/themed_fx/cny_fireworks_rockets_c.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(-2628, -1928, -500))
	table.insert(particleTable, lightningBolt)

	local crystal = CreateUnitByName("arcane_crystal", Vector(-2670, -2385, 800), false, nil, nil, DOTA_TEAM_GOODGUYS)
	crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1000))
	local crystalAbility = crystal:AddAbility("temple_key_ability")
	crystalAbility:ApplyDataDrivenModifier(crystal, crystal, "temple_key_fire_effect", {})
	crystalAbility:SetLevel(1)
	local fv = RandomVector(1)
	crystal:SetOriginalModel("models/ui/eaglesong_trophy/majors_trophy_eaglesong_model.vmdl")
	crystal:SetModel("models/ui/eaglesong_trophy/majors_trophy_eaglesong_model.vmdl")

	crystal:SetModelScale(0.7)
	crystal.fallVelocity = 10
	for i = 1, 300, 1 do
		Timers:CreateTimer(i * 0.05, function()
			crystal:SetAbsOrigin(crystal:GetAbsOrigin() - Vector(0, 0, crystal.fallVelocity))
			crystal.fallVelocity = math.max(crystal.fallVelocity - 0.05, 0)
		end)
	end

	Timers:CreateTimer(20, function()
		Arena.ChampionsLeague.state = 22
		FindClearSpaceForUnit(hero, Vector(-2880, 2112), false)
		FindClearSpaceForUnit(Arena.Coach, Vector(-2432, 2368), false)
		Arena:StartingMusic()
		Arena:SpawnArenaOutsideEntities()
		for i = 1, #particleTable, 1 do
			ParticleManager:DestroyParticle(particleTable[i], false)
		end
		Timers:CreateTimer(1, function()
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
			UTIL_Remove(crystal)
		end)

	end)
end

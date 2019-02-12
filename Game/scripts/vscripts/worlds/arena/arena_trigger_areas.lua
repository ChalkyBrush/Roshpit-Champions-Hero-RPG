require("npc_abilities/dialogue")

function preTrigger(hero)
	if hero:HasModifier("modifier_trigger_lock") then
		return false
	else
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_trigger_lock", {duration = 1})
		return true
	end
end

function LobbyTrigger(trigger)
	if trigger.activator.cheer then
		return false
	end
	if not Arena.EntranceVision then
		Timers:CreateTimer(0.5, function()
			AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-2670,-2445,420), 4050, 99999, false)
		end)
		Arena.EntranceVision = true
		Timers:CreateTimer(26, function()
			if not Arena.ChampionsLeague.battlePrep then
				local randomSound = RandomInt(1,2)
				EmitSoundOnLocationWithCaster(Vector(-2670, -2445), "Arena.Cheer"..randomSound, Events.GameMaster)
				Arena:AnimateCheers()
				return RandomInt(15, 26)
			end
		end)
	end
	trigger.activator.cheer = true
	EmitSoundOnLocationWithCaster(Vector(-2701, -7935), "Arena.Cheer2", Events.GameMaster)
	EmitSoundOnLocationWithCaster(Vector(-2670, -2445), "Arena.Cheer2", Events.GameMaster)
end

function NewbFountain(trigger)
	local hero = trigger.activator
	Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, hero, "modifier_arena_newb_fountain", {duration = 30})
end

function GoodFountain(trigger)
	local hero = trigger.activator
	Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, hero, "modifier_arena_good_fountain", {duration = 30})
end

function FountainLeave(trigger)
	local hero = trigger.activator
	hero:RemoveModifierByName("modifier_arena_good_fountain")
	hero:RemoveModifierByName("modifier_arena_newb_fountain")
end

function LeftLeaderboard(trigger)
	local hero = trigger.activator
	local playerRank = 21
	if not preTrigger(hero) then
		return false
	end
	if hero.ChampionsLeague then
		playerRank = hero.ChampionsLeague.rank
	end
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "open_left_leaderboard", {playerRank = playerRank})
end

function DonationsBoard(trigger)
	local hero = trigger.activator
	if not preTrigger(hero) then
		return false
	end
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "open_donations_board", {})
	local url = ROSHPIT_URL.."/donate/donations?"
	-- url = url.."steam_id="..steamID
	-- url = url.."&hero_slot="..saveSlot
	-- url = url.."&equip_slot="..itemSlot
	-- url = url.."&cost="..cost
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		if result.StatusCode == 200 then
			local resultTable = JSON:decode(result.Body)
			-- local newTable = {}
			-- for i = 1, #resultTable, 1 do
			-- end
			local size = #resultTable
			CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "donations_loaded", {resultTable = resultTable, resultSize = size})
		end
	end )		
end

function LeftLeaderboardExit(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
end

function BehindCounter1(trigger)
	if Arena.Nightmare then
		return false
	end
	local activator = trigger.activator
	local deskGirl = Arena.ChampionsLeagueAttendant
	if deskGirl.dontMove then
		return
	end
	StartAnimation(deskGirl, {duration=1.7, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.6})
	EmitSoundOn("Arena.ChampionsAttendantSign", deskGirl) 
	basic_dialogue(deskGirl, {activator}, "arena_behind_counter_1", 6, 5, -30, true)
	local fv = ((activator:GetAbsOrigin()-deskGirl:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	deskGirl:SetForwardVector(fv)
	deskGirl.dontMove = true
	Timers:CreateTimer(4.5, function()
		deskGirl.dontMove = false
		deskGirl:SetForwardVector(Vector(0,-1))
	end)
end

function BehindCounter2(trigger)
	if Arena.Nightmare then
		return false
	end
	local activator = trigger.activator
	local deskGirl = Arena.PVPAttendant
	if deskGirl.dontMove then
		return
	end
	StartAnimation(deskGirl, {duration=1.7, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.6})
	-- EmitSoundOn("Arena.ChampionsAttendantSign", deskGirl) 
	basic_dialogue(deskGirl, {activator}, "arena_behind_counter_2", 6, 5, -30, true)
	local fv = ((activator:GetAbsOrigin()-deskGirl:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	deskGirl:SetForwardVector(fv)
	deskGirl.dontMove = true
	Timers:CreateTimer(4.5, function()
		deskGirl.dontMove = false
		deskGirl:SetForwardVector(Vector(0,-1))
	end)
end

function BehindCounter3(trigger)
	if Arena.Nightmare then
		return false
	end
	local activator = trigger.activator
	local deskGirl = Arena.ChallengerAttendant
	if deskGirl.dontMove then
		return
	end
	StartAnimation(deskGirl, {duration=1.7, activity=ACT_DOTA_CAST_ABILITY_5, rate=0.6})
	-- EmitSoundOn("Arena.ChampionsAttendantSign", deskGirl) 
	basic_dialogue(deskGirl, {activator}, "arena_behind_counter_3", 6, 5, -30, true)
	local fv = ((activator:GetAbsOrigin()-deskGirl:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	deskGirl:SetForwardVector(fv)
	deskGirl.dontMove = true
	Timers:CreateTimer(4.5, function()
		deskGirl.dontMove = false
		deskGirl:SetForwardVector(Vector(0,-1))
	end)
end

function LeagueAttendant(trigger)
	if Arena.Nightmare then
		return false
	end
	local hero = trigger.activator
	if Events:GetPlayerCount() > 1 then
		local portraitHero = "npc_dota_hero_lina"
		local headerText = "champions_league_attendant"
		local messageText = "arena_league_attendant_player_restriction"
		local bDialogue = 0
		local bAltCondition = 0
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_npc_dialogue", {portraitHero=portraitHero, headerText=headerText, messageText = messageText, bDialogue = bDialogue, bAltCondition = bAltCondition})
		return false
	end
	if not Arena.ChampionsLeague.state then
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "champions_league_attendant", {numPlayers=Arena.NumPlayers, leagueData=Arena.ChampionsLeague})	
		basic_dialogue(Arena.ChampionsLeagueAttendant, {hero}, "arena_league_attendant_greeting", 6, 5, -30)
	elseif Arena.ChampionsLeague.state == 0 then
		basic_dialogue(Arena.ChampionsLeagueAttendant, {hero}, "arena_league_attendant_waiting_for_coach", 6, 5, -30)
	end
end

function LeagueAttendantLeave(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
end

function Sign1(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_view_sign", {sign="sign_hall_of_champions"})	
end

function Sign2(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_view_sign", {sign="sign_aquatarium"})
end

function Sign3(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_view_sign", {sign="sign_minor_locker_room"})
end

function Sign4(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_view_sign", {sign="sign_major_locker_room"})
end

function Sign5(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_view_sign", {sign="sign_allstar"})
end

function PVPAttendant(trigger)
	if Arena.Nightmare then
		return false
	end
	local hero = trigger.activator
	local portraitHero = "npc_dota_hero_dragon_knight"
	local headerText = "pvp_league_attendant"
	local messageText = "pvp_league_attendant_message"
	local bDialogue = 0
	local bAltCondition = 0
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_npc_dialogue", {portraitHero=portraitHero, headerText=headerText, messageText = messageText, bDialogue = bDialogue, bAltCondition = bAltCondition})	
	basic_dialogue(Arena.PVPAttendant, {hero}, "pvp_league_attendant_greeting", 6, 5, -30)
end

function ChallengerAttendant(trigger)
	if Arena.Nightmare then
		return false
	end
	local hero = trigger.activator
	local portraitHero = "npc_dota_hero_beastmaster"
	local headerText = "challenger_attendant"
	local messageText = "challenger_league_attendant_message"
	local bDialogue = 0
	local bAltCondition = 0
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_npc_dialogue", {portraitHero=portraitHero, headerText=headerText, messageText = messageText, bDialogue = bDialogue, bAltCondition = bAltCondition})	
	basic_dialogue(Arena.ChallengerAttendant, {hero}, "challenger_league_attendant_greeting", 6, 5, -30)
end

function ArenaWaterMage(trigger)
	if Arena.WaterMagician.gameStart then
		return
	end
	if Arena.Nightmare then
		return false
	end
	local hero = trigger.activator
	local portraitHero = "npc_dota_hero_furion"
	local headerText = "arena_aquatarium_magician"
	local messageText = "aquatarium_greeting"
	local bDialogue = 1
	local subLabel = "mithril"
	local labelCost = 100
	local bAltCondition = 0
	local altMessage = ""
	local intattr = 0
	local option1 = "aquatarium_option_1"
	local option2 = "arena_league_attendant_choice_1_option_2"
	if hero.waterGame then
		bAltCondition = true
		bDialogue = 0
		messageText = "aquatarium_greeting_alt"
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_npc_dialogue", {portraitHero=portraitHero, headerText=headerText, messageText = messageText, bDialogue = bDialogue, bAltCondition = bAltCondition})	
	else
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_npc_dialogue", {portraitHero=portraitHero, headerText=headerText, messageText = messageText, bDialogue = bDialogue, subLabel = subLabel, labelCost = labelCost, bAltCondition = bAltCondition, bAltmessage = altMessage, intattr = intattr, option1=option1, option2=option2})	
		basic_dialogue(Arena.WaterMagician, {hero}, "aquatarium_greeting_bubble", 6, 5, -30)
	end
end

function ArenaWaterMageExit(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
end

function TerminalNewbie(trigger)
	if Arena.Nightmare then
		return false
	end
	if Events:GetPlayerCount() > 1 then
		return false
	end
	local hero = trigger.activator
	if hero.ChampionsLeague and (Arena.ChampionsLeague.state == 8 or Arena.ChampionsLeague.state == 7) then
		Arena.ChampionsLeague.state = 9
		Timers:CreateTimer(2.5, function()
			Arena.Coach:MoveToPosition(Vector(-9884, -1024))
			Timers:CreateTimer(0.5, function()
				Timers:CreateTimer(0.5, function()
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
				end)
				basic_dialogue(Arena.Coach, {hero}, "#champion_assistant_dialogue_10", 7, 5, -80)
				Timers:CreateTimer(7, function()
					basic_dialogue(Arena.Coach, {hero}, "#champion_assistant_dialogue_11", 10, 5, -80)
					Timers:CreateTimer(4, function()
						Arena.ChampionsLeague.state = 10
					end)
				end)
			end)
		end)
	end
	if Arena.ChampionsLeague.state == 18 then
		Arena.ChampionsLeague.state = 19
		Arena:OgreSequence(hero)
		return false
	end
	if Arena.ChampionsLeague.state == 19 then
		return false
	end
	if hero.ChampionsLeague then
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_terminal", {ChampionsLeague=hero.ChampionsLeague, heroName=hero:GetUnitName(), ArenaChampions=Arena.ChampionsLeague})
	end

	
end

function NewbieLoungeEnter(trigger)
	local hero = trigger.activator
	print("enterLounge")
	if not hero.ChampionsLeague then
		local angryGuard = Arena.NewbieGuardTable[RandomInt(1,#Arena.NewbieGuardTable)]
		local guardAbility = angryGuard:FindAbilityByName("arena_guard_ability")
		guardAbility:ApplyDataDrivenModifier(angryGuard, hero, "modifier_arena_guard_lock", {})
		local fv = ((hero:GetAbsOrigin()-angryGuard:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		angryGuard:SetForwardVector(fv)
		angryGuard.pushToPosition = Vector(-7936, -2496)+Vector(0,0,GetGroundHeight(Vector(-7936, -2496), angryGuard))
		Timers:CreateTimer(2.5, function()
			guardAbility:ApplyDataDrivenModifier(angryGuard, hero, "modifier_arena_guard_moving", {})
		end)
	end	
end

function MajorLoungeEnter(trigger)
	local hero = trigger.activator
	print("enterLounge")
	if not hero.ChampionsLeague or hero.ChampionsLeague.rank > 10 then
		local angryGuard = Arena.MajorGuardTable[RandomInt(1,#Arena.MajorGuardTable)]
		local guardAbility = angryGuard:FindAbilityByName("arena_guard_ability")
		guardAbility:ApplyDataDrivenModifier(angryGuard, hero, "modifier_arena_guard_lock", {})
		local fv = ((hero:GetAbsOrigin()-angryGuard:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		angryGuard:SetForwardVector(fv)
		angryGuard.pushToPosition = Vector(-7040, 3328)+Vector(0,0,GetGroundHeight(Vector(-7040, 3328), angryGuard))
		Timers:CreateTimer(2.5, function()
			guardAbility:ApplyDataDrivenModifier(angryGuard, hero, "modifier_arena_guard_moving", {})
		end)
	end	
end

function AllStarLoungeEnter(trigger)
	local hero = trigger.activator
	print("enterLounge")
	if not hero.ChampionsLeague or hero.ChampionsLeague.rank > 10 then
		local angryGuard = Arena.AllstarGuardTable[RandomInt(1,#Arena.AllstarGuardTable)]
		local guardAbility = angryGuard:FindAbilityByName("arena_guard_ability")
		guardAbility:ApplyDataDrivenModifier(angryGuard, hero, "modifier_arena_guard_lock", {})
		local fv = ((hero:GetAbsOrigin()-angryGuard:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		angryGuard:SetForwardVector(fv)
		angryGuard.pushToPosition = Vector(-2688, 3712)+Vector(0,0,GetGroundHeight(Vector(-2688, 3712), angryGuard))
		Timers:CreateTimer(2.5, function()
			guardAbility:ApplyDataDrivenModifier(angryGuard, hero, "modifier_arena_guard_moving", {})
		end)
	end	
end

function ArenaBattleStartArea(trigger)
	if Arena.Nightmare then
		return false
	end
	local hero = trigger.activator
	if Arena.ChampionsLeague.timer then
		Arena.ChampionsLeague.timer = 1
	end
end

function use_prizebox(event)
	local caster = event.caster
	local item = event.ability
	local rarity = item.rarity
	RPCItems.StrictItemLevel = 260
	for i = 1, item.property2, 1 do
		rollArenaPrizeItem(caster:GetAbsOrigin(), item.property2name)
	end
	if item.rarity == "rare" or item.rarity == "mythical" then
		if item.property3name == "arcane_crystals" then
			dropArcaneCrystalsPrizeBox(caster:GetAbsOrigin(), item.property3)
		else
			for i = 1, item.property3, 1 do
				rollArenaPrizeItem(caster:GetAbsOrigin(), item.property3name)
			end
		end
	end
	if item.rarity == "mythical" then
		if item.property4name == "arcane_crystals" then
			dropArcaneCrystalsPrizeBox(caster:GetAbsOrigin(), item.property4)
		elseif item.property4name == "champions_gear" then
			local luck = RandomInt(1,4)
			if luck == 1 then
	        	RPCItems:RollChampionsGearHelm(caster:GetAbsOrigin())
	        elseif luck == 2 then
	        	RPCItems:RollChampionsGearGauntlet(caster:GetAbsOrigin())
	        elseif luck == 3 then
	        	RPCItems:RollChampionsGearMail(caster:GetAbsOrigin())
	        elseif luck == 4 then
	        	RPCItems:RollChampionsGearBoots(caster:GetAbsOrigin())		
	        end	
		else
			for i = 1, item.property4, 1 do
				rollArenaPrizeItem(caster:GetAbsOrigin(), item.property4name)
			end
		end
	end
	Timers:CreateTimer(0.5, function()
		RPCItems.StrictItemLevel = false
	end)
	RPCItems:ItemUTIL_Remove(item)
end

function rollArenaPrizeItem(deathLocation, rarity)
	local luck = RandomInt(200, 500)
	if luck >= 200 and luck < 265 then
		RPCItems:RollHood(0, deathLocation, rarity, false, 0, nil, 0)
	elseif luck >= 265 and luck < 330 then
		RPCItems:RollHand(0, deathLocation, rarity, false, 0, nil, 0)
	elseif luck >= 330 and luck < 395 then
		RPCItems:RollFoot(0, deathLocation, rarity, false, 0, nil, 0)
	elseif luck >= 395 and luck < 460 then
		RPCItems:RollBody(0, deathLocation, rarity, false, 0, nil, 0)
	elseif luck <= 500 then
		RPCItems:RollAmulet(0, deathLocation, rarity, false, 0, nil, 0)
	end
end

function dropArcaneCrystalsPrizeBox(position, crystalQuantity)
	local connectedPlayerCount = RPCItems:GetConnectedPlayerCount()
	local crystalsPerPlayer = math.floor(crystalQuantity/connectedPlayerCount)
	Glyphs.glyphDropIndex = Glyphs.glyphDropIndex + 1
	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i].maxCrystals = MAIN_HERO_TABLE[i].maxCrystals + crystalsPerPlayer
	end
	local greatestCrystalQuantity = math.max((crystalQuantity-80)/20,0)
	crystalQuantity = crystalQuantity - greatestCrystalQuantity*20
	local greatCrystalQuantity = math.max((crystalQuantity-30)/10,0)
	crystalQuantity = crystalQuantity - greatCrystalQuantity*10
	local largeCrystalQuantity = math.max((crystalQuantity-5)/5,0)
	crystalQuantity = crystalQuantity - largeCrystalQuantity*5
	local smallCrystalQuantity = crystalQuantity
	for i = 1, largeCrystalQuantity, 1 do
		Timers:CreateTimer(0.12*i, function()
			Glyphs:CreateIndividualCrystal(position, 5)
		end)
	end
	Timers:CreateTimer(0.53, function()
		for i = 1, greatCrystalQuantity, 1 do
			Timers:CreateTimer(0.12*i, function()
				Glyphs:CreateIndividualCrystal(position, 10)
			end)
		end
	end)
	Timers:CreateTimer(2.03, function()
		for i = 1, greatestCrystalQuantity, 1 do
			Timers:CreateTimer(0.12*i, function()
				Glyphs:CreateIndividualCrystal(position, 20)
			end)
		end
	end)
	Timers:CreateTimer(1.06, function()
		for i = 1, smallCrystalQuantity, 1 do
			Timers:CreateTimer(0.12*i, function()
				Glyphs:CreateIndividualCrystal(position, 1)
			end)
		end
	end)
	Timers:CreateTimer(45, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].crystalsToSave = MAIN_HERO_TABLE[i].crystalsToSave + MAIN_HERO_TABLE[i].crystalsPickedUp
			MAIN_HERO_TABLE[i].crystalsPickedUp = 0
			MAIN_HERO_TABLE[i].maxCrystals = MAIN_HERO_TABLE[i].maxCrystals - crystalsPerPlayer
		end
		Glyphs.glyphDropIndex = Glyphs.glyphDropIndex - 1
		if Glyphs.glyphDropIndex == 0 then
			for i = 1, #Glyphs.ArcaneCrystalTable, 1 do
				if IsValidEntity(Glyphs.ArcaneCrystalTable[i]) then
					UTIL_Remove(Glyphs.ArcaneCrystalTable[i])
				end
			end
			Glyphs:SaveResources()
			CustomGameEventManager:Send_ServerToAllClients("arcane_out", {})
		end
	end)
end
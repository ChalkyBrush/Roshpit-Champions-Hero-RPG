if GameState == nil then
  GameState = class({})
end

GameState.PVP_REDUCTION = 0.01

function GameState:RecordPlayerID(hero)
	if not GameState.PlayerTable then
		GameState.PlayerTable = {}
	end
	local playerID = hero:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	table.insert(GameState.PlayerTable, steamID)

end

function GameState:DifficultySelect(msg)
	local difficulty = msg.difficulty
	print("DIFFICULTY SELECT?")
	if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		local bHost = false
		if msg.playerID == -10 then
			bHost = true
		else
			local player = PlayerResource:GetPlayer(msg.playerID)
			if GameRules:PlayerHasCustomGameHostPrivileges(player) then
				bHost = true
			end
		end
		if bHost then
			DIFFICULTY_FACTOR = difficulty
			CustomNetTables:SetTableValue("player_stats", "diff", {difficulty = DIFFICULTY_FACTOR} )
			CustomGameEventManager:Send_ServerToAllClients("update_selected_difficulty", {difficulty = DIFFICULTY_FACTOR} )
		end
	end
end

function GameState:GetHeroByPlayerID(playerID)
	local hero = -1
	for i = 1, #GameState.HeroPlayerTable, 1 do
		local dataTable = GameState.HeroPlayerTable[i]
		if dataTable[1] == playerID then
			hero = EntIndexToHScript(dataTable[2])
		end
	end
	return hero
end

function GameState:IsWorld1()
	local mapName = Events.MapName
	if mapName == "rpc_world_1_normal" or mapName == "rpc_world_1_elite" or mapName == "rpc_world_1_legend" or mapName == "rpc_world_1" then
		return true
	else
		return false
	end
end

function GameState:IsTanariJungle()
	local mapName = Events.MapName
	if mapName == "rpc_tanari_jungle_normal" or mapName == "rpc_tanari_jungle_elite" or mapName == "rpc_tanari_jungle_legend" or mapName == "rpc_tanari_jungle" or mapName == "rpc_tanari_jungle_work" then
		return true
	else
		return false
	end
end

function GameState:IsRPCArena()
	local mapName = Events.MapName
	if mapName == "rpc_roshpit_arena_legend" or mapName == "rpc_roshpit_arena" then
		return true
	else
		return false
	end
end

function GameState:IsRedfallRidge()
	local mapName = Events.MapName
	if mapName == "rpc_redfall_ridge_normal" or mapName == "rpc_redfall_ridge_elite" or mapName == "rpc_redfall_ridge_legend"  or mapName == "redfall_ridge_work" or mapName == "rpc_redfall_ridge" then
		return true
	else
		return false
	end
end

function GameState:IsSeaFortress()
	local mapName = Events.MapName
	if mapName == "rpc_sea_fortress" then
		return true
	else
		return false
	end
end

function GameState:IsSeaEarlyCheck()
	local mapName = GetMapName()
	if mapName == "rpc_sea_fortress" then
		return true
	else
		return false
	end
end

function GameState:IsWinterblight()
	local mapName = Events.MapName
	if mapName == "rpc_winterblight_mountain" then
		return true
	else
		return false
	end
end

function GameState:IsSerengaard()
	local mapName = Events.MapName
	if mapName == "rpc_battle_of_serengaard" then
		return true
	else
		return false
	end
end

function GameState:IsSerengaardEarlyCheck()
	local mapName = GetMapName()
	if mapName == "rpc_battle_of_serengaard" then
		return true
	else
		return false
	end
end


function GameState:IsPVPAlpha()
	local mapName = Events.MapName
	if mapName == "rpc_pvp_linewar_no_oracle" or mapName == "rpc_pvp_alpha_3v3_open" or mapName == "rpc_pvp_linewar_no_oracle_work" then
		return true
	else
		return false
	end	
end

function GameState:IsPVPAlpha1v1()
	local mapName = Events.MapName
	if mapName == "rpc_pvp_alpha_1v1" then
		return true
	else
		return false
	end	
end

function GameState:NoOracleEarlyCheck()
	local mapName = GetMapName()
	if mapName == "rpc_pvp_linewar_no_oracle" or mapName == "rpc_pvp_linewar_no_oracle_work" then
		return true
	else
		return false
	end
end


function GameState:NoOracle()
	local mapName = Events.MapName
	if mapName == "rpc_pvp_linewar_no_oracle" or mapName == "rpc_pvp_linewar_no_oracle_work" then
		return true
	else
		return false
	end
end

function GameState:IsPVPAlpha3v3()
	local mapName = Events.MapName
	if mapName == "rpc_pvp_alpha_3v3_open" or mapName == "rpc_pvp_linewar_no_oracle" or mapName == "rpc_pvp_linewar_no_oracle_work" then
		return true
	else
		return false
	end	
end

function GameState:IsPVPLineWarWork()
	local mapName = Events.MapName
	print(mapName)
	if mapName == "rpc_pvp_linewar_no_oracle_work" or mapName == "rpc_pvp_linewar_no_oracle" then
		return true
	else
		return false
	end	
end

function GameState:IsPVPAlphaEarlyCheck()
	local mapName = GetMapName()
	if mapName == "rpc_pvp_alpha_1v1" or mapName == "rpc_pvp_alpha_3v3_open" or mapName == "rpc_pvp_linewar_no_oracle" or mapName == "rpc_pvp_linewar_no_oracle_work" then
		return true
	else
		return false
	end	
end

function GameState:IsPVPAlpha1v1EarlyCheck()
	local mapName = GetMapName()
	if mapName == "rpc_pvp_alpha_1v1" then
		return true
	else
		return false
	end	
end

function GameState:IsPVPAlpha3v3EarlyCheck()
	local mapName = GetMapName()
	if mapName == "rpc_pvp_alpha_3v3_open" or mapName == "rpc_pvp_linewar_no_oracle" or mapName == "rpc_pvp_linewar_no_oracle_work" then
		return true
	else
		return false
	end	
end

function GameState:GetPlayerPremiumStatus(playerID)
	return PlayerResource:HasCustomGameTicketForPlayerID( playerID )
end

function GameState:GetPlayerPremiumStatusCount()
	local premiumStatusCount = 0
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if (PlayerResource:GetConnectionState(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) == 2) or (PlayerResource:GetConnectionState(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) == 1) then
			if GameState:GetPlayerPremiumStatus(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) then
				premiumStatusCount = premiumStatusCount + 1
			end
		end
	end
	return premiumStatusCount
end

function GameState:GetMagicFindBonus()
	local bonus = 0
	bonus = bonus + GameState:GetPlayerPremiumStatusCount()
	bonus = bonus + GameState.magicFindBonus
	return bonus
end

function GameState:ItemDragFromBackpack(msg)
	local item = EntIndexToHScript(msg.itemIndex)
	print(msg.itemIndex)
	item:StartCooldown(6)
end

function GameState:GetDefaultDifficulty()
	local mapName = GetMapName()
	print("MAP NAME::")
	print(mapName)
	if mapName == "rpc_roshpit_arena_legend" or mapName == "rpc_roshpit_arena" or mapName == "rpc_sea_fortress" then
		return 3
	else
		return 1
	end
end

function GameState:SetDifficultyFactor()
	CustomNetTables:SetTableValue("player_stats", "diff", {difficulty = DIFFICULTY_FACTOR} )
	return DIFFICULTY_FACTOR
	-- local mapName = Events.MapName
	-- if mapName == "rpc_world_1_normal" then
	-- 	return 1
	-- elseif mapName == "rpc_world_1_elite" then
	-- 	return 2
	-- elseif mapName == "rpc_world_1_legend" then
	-- 	return 3
	-- elseif mapName == "rpc_tanari_jungle_normal" then
	-- 	return 1
	-- elseif mapName == "rpc_tanari_jungle_elite" then
	-- 	return 2
	-- elseif mapName == "rpc_tanari_jungle_legend" then
	-- 	return 3
	-- elseif mapName == "rpc_roshpit_arena_legend" then
	-- 	return 3
	-- elseif mapName == "rpc_test_map" then
	-- 	return 3
	-- elseif mapName == "rpc_redfall_ridge_normal" then
	-- 	return 1
	-- elseif mapName == "rpc_redfall_ridge_elite" then
	-- 	return 2
	-- elseif mapName == "rpc_redfall_ridge_legend" then
	-- 	return 3
	-- else
	-- 	return 1
	-- end
	-- local difficultyData = CustomNetTables:GetTableValue("game_state", "difficulty_data")
	-- print("---DIFFICULTY DATA---")
	-- print(difficultyData)
	-- print("^---DIFFICULTY DATA---^")
	-- local difficulty = 1
	-- if difficultyData then
	-- 	difficulty = difficultyData.difficulty
	-- end
	-- return difficulty
end

function GameState:GetDifficultyFactor()
	return Events.DifficultyFactor
end

function GameState:GetDifficultyName()
	if GameState:GetDifficultyFactor() == 1 then
		return "normal"
	elseif GameState:GetDifficultyFactor() == 2 then
		return "elite"
	elseif GameState:GetDifficultyFactor() == 3 then
		return "legend"
	end
end

function GameState:InitializeGameState()
	GameState.chieftain = 0
	GameState.neverlord = 0
	GameState.jonuous = 0
	GameState.wraithkeeper = 0
	GameState.gazbinceo = 0
	GameState.silithicus = 0
	GameState.razormore = 0
	GameState.majinaq = 0
	GameState.keeper = 0
	GameState.count = 0
	GameState.rentiki = 0
	GameState.starblight = 0
	GameState.phoenix = 0
	GameState.cheats = false
	Dungeons.itemLevel = 0
	GameState.magicFindBonus = 0
	-- SendToServerConsole("dota_create_unit npc_dota_creep_goodguys_melee")
	-- Timers:CreateTimer(1, function()
	-- 	local ent = Entities:FindAllByClassname("npc_dota_creep_lane")
	-- 	if #ent > 0 then
	-- 		GameState.cheats = true
	-- 		print("CHEATS DETECTED. NO STAT COLLECTION")
	-- 		UTIL_Remove(ent[1])
	-- 	end
	-- end)
end

function GameState:CheatCommandUsed()
	GameState.cheats = true
end

function GameState:NeverlordDefeat()
	GameState.neverlord = 1
end

function GameState:JonuousDefeat()
	GameState.jonuous = 1
end

function GameState:WraithDefeat(bossName, deathPosition)
	GameState.wraithkeeper = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:GazbinDefeat(bossName, deathPosition)
	GameState.gazbinceo = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:SilithicusDefeat(bossName, deathPosition)
	GameState.silithicus = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:RazormoreDefeat()
	GameState.razormore = 1
end

function GameState:MajinaqDefeat(bossName, deathPosition)
	GameState.majinaq = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:ChieftainDefeat()
	GameState.chieftain = 1
end

function GameState:KeeperDefeat(bossName, deathPosition)
	GameState.keeper = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:CountDefeat(bossName, deathPosition)
	GameState.count = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:RentikiDefeat(bossName, deathPosition)
	GameState.rentiki = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:StarblightDefeat(bossName, deathPosition)
	GameState.starblight = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:PhoenixDefeat(bossName, deathPosition)
	GameState.phoenix = 1
	Challenges:BossDie(bossName, deathPosition)
end

function GameState:Debug()
	GameState.chieftain = 1
	GameState.neverlord = 1
	GameState.jonuous = 1
	GameState.wraithkeeper = 1
	GameState.gazbinceo = 1
	GameState.silithicus = 1
	GameState.razormore = 1
	GameState.majinaq = 1
	GameState.keeper = 1
	GameState.count = 1
	GameState.rentiki = 1
	GameState.starblight = 1
	GameState.phoenix = 1
end

function GameState:RecordMatch()
	local developer = Convars:GetBool("developer")
	local cheats = Convars:GetBool("sv_cheats")
	if not cheats and not developer and not GameState.cheats then
		local token = "1337"
		local url = ROSHPIT_URL.."/champions/postData?token="..token
		url = url.."&gameLength="..GameRules:GetGameTime()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			url = url.."&player"..i.."id="..GameState.PlayerTable[i]
			url = url.."&hero"..i.."name="..MAIN_HERO_TABLE[i]:GetClassname()
			url = url.."&hero"..i.."level="..MAIN_HERO_TABLE[i]:GetLevel()
			local playerKills = PlayerResource:GetKills(MAIN_HERO_TABLE[i]:GetPlayerOwnerID())
			url = url.."&hero"..i.."kills="..playerKills
		end
		url = url.."&neverlord="..GameState.neverlord
		url = url.."&jonuous="..GameState.jonuous
		url = url.."&wraithkeeper="..GameState.wraithkeeper
		url = url.."&gazbinceo="..GameState.gazbinceo
		url = url.."&silithicus="..GameState.silithicus
		url = url.."&razormore="..GameState.razormore
		url = url.."&majinaq="..GameState.majinaq
		url = url.."&chieftain="..GameState.chieftain
		url = url.."&avernus="..GameState.count
		url = url.."&keeper="..GameState.keeper
		CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
			print( "POST response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
		end )
	end
end

function GameState:GetPostReductionPhysicalDamage(damage, armor)
	local damageMult = 1 - (0.05*armor/(1 + (0.05 * math.abs(armor))))
	local damage = math.ceil(damage*damageMult)
	return damage
end

function GameState:GoldEarnFilter(goldEarnTable)
	-- print("MODIFY GOLD?")
	-- DeepPrintTable(goldEarnTable)
	local gold = goldEarnTable["gold"]
	local playerID = goldEarnTable["player_id_const"]
	goldEarnTable["gold"] = 0
	PlayerResource:ModifyGold(playerID, gold, true, 0)
	PlayerResource:SetGold(playerID, 0, false)
	return true
end

function GameState:OrderFilter(orderTable)
	local unitNumber = -1
	for _,unitNum in pairs(orderTable.units) do
		unitNumber = unitNum
		break
	end
	-- DeepPrintTable(orderTable)
	local unit = EntIndexToHScript(unitNumber)
	if IsValidEntity(unit) then
		if unit:HasModifier("modifier_neptunes_water_gliders") then
			unit.lastOrder = orderTable.order_type
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				if unit:IsStunned() or unit:IsRooted() or unit:IsFrozen() then
				else
					unit.foot:ApplyDataDrivenModifier(unit.InventoryUnit, unit, "modifier_neptune_gliding_new", {duration = 20})
					unit.foot.slideSpeed = 8
					unit.foot.movementPosition = Vector(orderTable.position_x, orderTable.position_y)
					local movementForward = ((unit.foot.movementPosition - unit:GetAbsOrigin())*Vector(1,1,0)):Normalized()
					unit.foot.movementForward = movementForward
				end
			end
		end
		if unit:HasModifier("modifier_holy_wrath_d_a_buff") then
			if not unit:HasModifier("modifier_holy_wrath_d_a_cooldown") then
				if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
					if unit:IsStunned() or unit:IsRooted() or unit:IsFrozen() then
					else
						local ability = unit:FindAbilityByName("auriun_aoe_shield")
						if IsValidEntity(ability) then
							ability:ApplyDataDrivenModifier(unit, unit, "modifier_holy_wrath_d_a_cooldown", {duration = 1.0})
							CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", unit, 3)
							local clampDistance = ability.d_a_level*10 + 400
							local distance = math.min(WallPhysics:GetDistance2d(Vector(orderTable.position_x, orderTable.position_y), unit:GetAbsOrigin()), clampDistance)
							print("AHOLA1")
							print(Vector(orderTable.position_x, orderTable.position_y))
							local teleportDirection = ((Vector(orderTable.position_x, orderTable.position_y) - unit:GetAbsOrigin())*Vector(1,1,0)):Normalized()
							print(teleportDirection)
							print(distance)
							print(teleportDirection*distance)
							print("ALOHA2")
						    local position2 = WallPhysics:WallSearch(unit:GetAbsOrigin(), unit:GetAbsOrigin()+teleportDirection*distance, unit)
						    FindClearSpaceForUnit(unit, position2, false)
						    EmitSoundOn("Auriun.ShieldHit", unit)
						    Timers:CreateTimer(0.1, function()
						    	CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_end_ti5.vpcf", unit, 3)
						    end)
						end
					end
				end
			end
		end
		if unit:HasModifier("modifier_slipfinn_passive") then
			unit.lastOrder = orderTable.order_type
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				unit.rightClickPos = Vector(orderTable.position_x, orderTable.position_y)
				if unit:HasModifier("modifier_slipfinn_prone") then
					unit:RemoveModifierByName("modifier_slipfinn_prone")
				end
				if unit:HasModifier("modifier_slipfinn_basic_jump") then
					unit.direction = (unit.direction*Vector(1,1,0) + unit.rightClickPos*0.00001):Normalized()
					if unit.speed < 8 then
						unit.speed = math.max(1, unit.speed + 1)
						unit.direction = unit:GetForwardVector()
					end
				end
			end
			if orderTable.entindex_ability > 0 then
				-- local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				-- if IsValidEntity(orderAbility) then
				-- 	if orderAbility:GetAbilityName() == "slipfinn_bubble_possession" then
				-- 		local enemy = EntIndexToHScript(orderTable.entindex_target)
				-- 		if IsValidEntity(enemy) then
				-- 			if not enemy.dominion then
				-- 				unit:Stop()
				-- 				Notifications:Top(unit:GetPlayerOwnerID(), {text="slipfinn_possession_warning", duration=5, style={color="#FF1111"}, continue=true})
				-- 				return false
				-- 			end
				-- 		end
				-- 	end
				-- end
			end
		end
		if unit:HasModifier("modifier_zonik_speedball") then
			unit:RemoveModifierByName("modifier_zonik_speedball")
			unit:RemoveModifierByName("modifier_zonik_speedball_cap")
		end
		if unit:HasModifier("modifier_arkimus_c_b_sprinting") then
			unit:RemoveModifierByName("modifier_arkimus_c_b_sprinting")
			unit:RemoveModifierByName("modifier_arkimus_speed_dash")
		end
		if unit:HasModifier("modifier_arkimus_storm_weapon_passive") then
			if orderTable.entindex_target then
				if not unit:IsRooted() and not unit:IsStunned() then
					local ability = unit:FindAbilityByName("arkimus_storm_weapon")
					local c_b_level = Runes:GetTotalRuneLevelGeneric(unit, 3, 1)

					if c_b_level > 0 and unit:HasModifier("modifier_arkimus_storm_weapon") then
						local enemy = EntIndexToHScript(orderTable.entindex_target)
						if IsValidEntity(enemy) then
							if orderTable.entindex_target == 0 then
							else
								local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), unit:GetAbsOrigin())
								if distance >= 400 then
									DeepPrintTable(orderTable)
									if enemy.dummy then
									elseif enemy:GetClassname() == "dota_item_drop" then
									elseif enemy:GetTeamNumber() == unit:GetTeamNumber() then
									else
										CustomAbilities:ArkimusSpeedDash(unit, enemy, ability, c_b_level)
									end
								end
							end
						end
					end

				end
			end
		end
		if unit:HasModifier("modifier_teleporter_aura") then
			if not unit:HasModifier("modifier_recently_teleported_portal") then
				local movementPosition = Vector(orderTable.position_x, orderTable.position_y)
				if movementPosition.x == 0 and movementPosition.y == 0 then
					if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
						movementPosition = (EntIndexToHScript(orderTable.entindex_target)):GetAbsOrigin()
						local distance = WallPhysics:GetDistance2d(unit:GetAbsOrigin(), movementPosition)
						if distance > 800 then
							local distanceFromCenter = WallPhysics:GetDistance2d(Vector(-64, 256), movementPosition)
							if distanceFromCenter < 5600 then
								unit:Stop()
								Events:TeleportUnit(unit, movementPosition, Events.GameMaster.portal, Events.GameMaster, 0.5)
								return false
							end
						end
					end
				else
					local distance = WallPhysics:GetDistance2d(unit:GetAbsOrigin(), movementPosition)
					if distance > 800 then
						local distanceFromCenter = WallPhysics:GetDistance2d(Vector(-64, 256), movementPosition)
						if distanceFromCenter < 5600 then
							unit:Stop()
							Events:TeleportUnit(unit, movementPosition, Events.GameMaster.portal, Events.GameMaster, 0.5)
							return false
						end
					end
				end
			end
		end
		if unit:HasModifier("modifier_chernobog_shadow_walk") then
			if orderTable.entindex_target then
				if not unit:IsRooted() and not unit:HasModifier("modifier_chernobog_c_c_cooldown") then
					local ability = unit:FindAbilityByName("chernobog_shadow_walk")
					if ability.c_c_level then
						if ability.c_c_level > 0 then
							local enemy = EntIndexToHScript(orderTable.entindex_target)
							if IsValidEntity(enemy) then
								if orderTable.entindex_target == 0 then
								else
									local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), unit:GetAbsOrigin())
									if distance < ability.c_c_level*12 + 400 then
										DeepPrintTable(orderTable)
										if enemy.dummy then
										elseif enemy:GetClassname() == "dota_item_drop" then
										elseif enemy:GetTeamNumber() == unit:GetTeamNumber() then
										else
											CustomAbilities:ChernobogSuddenStrike(unit, enemy, ability)
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if GameState:IsPVPAlpha() then
			if unit:GetUnitName() == "rpc_pvp_tanari_builder" then
				DeepPrintTable(orderTable)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(orderTable.issuer_player_id_const), "openBuilderMenu", {} )
			end
		end
	end
	if orderTable.entindex_ability > 0 then
		if IsValidEntity(unit) then
			if unit:GetUnitName() == "conjuror_elemental_deity_summon" then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "conjuror_deity_shadow_shield" then
						local target = EntIndexToHScript(orderTable.entindex_target)
						if IsValidEntity(target) then
							if not target.aspect then
								return false
							end
						end
					end
				end
			end
			if unit:GetUnitName() == "npc_dota_hero_juggernaut" then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "seinaru_arcana_ability" then
						print("IGNORE CAST ANGLE!!!")
						orderAbility:ApplyDataDrivenModifier(unit, unit, "modifier_seinaru_ignore_cast_angle", {duration = 0.5})
					end
				end
			end
			if unit:GetUnitName() == "npc_dota_hero_visage" then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "ekkan_dominion" or orderAbility:GetAbilityName() == "ekkan_arcana_black_dominion" then
						local enemy = EntIndexToHScript(orderTable.entindex_target)
						if IsValidEntity(enemy) then
							if enemy:GetTeamNumber() == unit:GetTeamNumber() then
								if enemy.ekkan_dominion then
								else
									unit:Stop()
									Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_no_dominion", duration=5, style={color="#FF1111"}, continue=true})
									return false
								end
							else
								if not enemy.dominion then
									unit:Stop()
									Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_no_dominion", duration=5, style={color="#FF1111"}, continue=true})
									return false
								end
							end
						end
					end
					-- if orderAbility:GetAbilityName() == "ekkan_summon_skeleton" then
					-- 	local enemy = EntIndexToHScript(orderTable.entindex_target)
					-- 	if IsValidEntity(enemy) then
					-- 		print(enemy:GetUnitName())
					-- 		if enemy.disable then
					-- 			return false
					-- 		end
					-- 		if enemy:GetUnitName() == "ekkan_corpse" then
					-- 		else
					-- 			unit:Stop()
					-- 			Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_raise_skeleton_fail", duration=5, style={color="#FF1111"}, continue=true})
					-- 			return false
					-- 		end
					-- 	else
					-- 		return false
					-- 	end
					-- end
					if orderAbility:GetAbilityName() == "ekkan_river_of_souls" then
						DeepPrintTable(orderTable)
						unit.corpseExplosionIndex = 0
						if orderTable.entindex_target > 0 then
							local a_c_level = Runes:GetTotalRuneLevel(unit, 1, "a_c", "ekkan")
							if a_c_level < 1 then
								unit:Stop()
								Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_river_no_explosion", duration=5, style={color="#FF1111"}, continue=true})
								return false
							end
							unit.corpseExplosionIndex = orderTable.entindex_target
							local enemy = EntIndexToHScript(orderTable.entindex_target)
							if IsValidEntity(enemy) then
								if enemy.disable then
									return false
								end
								if enemy:GetUnitName() == "ekkan_corpse" then
								else
									unit:Stop()
									Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_raise_skeleton_fail", duration=5, style={color="#FF1111"}, continue=true})
									return false
								end
							else
								return false
							end
						end
					end
					if orderAbility:GetAbilityName() == "ekkan_supercharge" then
						local ally = EntIndexToHScript(orderTable.entindex_target)
						if IsValidEntity(ally) then
							if ally:GetTeamNumber() == unit:GetTeamNumber() then
								if not ally.ekkan_unit then
									unit:Stop()
									Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_supercharge_fail", duration=5, style={color="#FF1111"}, continue=true})
									return false
								end
							else
								if ally:GetUnitName() == "ekkan_corpse" then
									local c_d_level = Runes:GetTotalRuneLevel(unit, 3, "c_d", "ekkan")
									if c_d_level < 1 then
										unit:Stop()
										Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_supercharge_no_corpse_charge", duration=5, style={color="#FF1111"}, continue=true})
										return false
									end
								else
									local b_d_level = Runes:GetTotalRuneLevel(unit, 2, "b_d", "ekkan")
									if b_d_level < 1 then
										unit:Stop()
										Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_supercharge_no_swarm", duration=5, style={color="#FF1111"}, continue=true})
										return false
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return true

end

function GameState:GetInputDamageMultDecrease(attacker, shouldConsumeShield)
	local baseMult = 1

end

function GameState:IncomingDamageDecreaseWithType(victim, attacker, shouldConsumeShields, damagetype)
	local BASE_VALUE_FOR_CALCULATE = 1000000
	local damage = BASE_VALUE_FOR_CALCULATE
	if damagetype == DAMAGE_TYPE_PHYSICAL then
		if victim:HasModifier("modifier_stormshield_cloak") then
			damage = damage*0.5
		end
		if victim:HasModifier("modifier_bahamut_glyph_1_1") then
			damage = damage*0.7
		end
		if victim:HasModifier("modifier_pure_resist") then
			damage = damage*6
		end
	elseif damagetype == DAMAGE_TYPE_MAGICAL then
		if victim:HasModifier("modifier_resplendent_rubber_boots") then
			damage = damage*0.65
		end
	elseif damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_sparkling_token_of_oceanis") then
			damage = damage*0.1
		end
		if victim:HasModifier("modifier_sunstrider_lightsworn") then
			damage = damage*0.2
		end
	end
	if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_lightning_dash") then
			local dash = victim:FindAbilityByName("voltex_lightning_dash")
			if dash then
				local reduction = (100-dash:GetSpecialValueFor("damage_reduction_percent"))/100
				damage = damage*reduction
			end
		end
		if victim:HasModifier("modifier_duskbringer_arcana_armor") then
			local stackCount = victim:GetModifierStackCount("modifier_duskbringer_arcana_armor", victim)
			local consideredArmor = victim:GetPhysicalArmorValue()*0.01*stackCount
			damage = GameState:GetPostReductionPhysicalDamage(damage, consideredArmor)
		end
	    if victim:HasModifier("modifier_pure_resist") then
    		local damageReduc = victim:FindModifierByName("modifier_pure_resist"):GetAbility():GetSpecialValueFor("pure_resist")
    		damageReduc = 1 - (damageReduc/100)
    		damage = damage*damageReduc
	    end
	    if victim:HasModifier("modifier_slipfinn_prone") then
	    	local damageReduc = victim:FindModifierByName("modifier_slipfinn_prone"):GetAbility():GetSpecialValueFor("magic_pure_resist")
    		damageReduc = 1 - (damageReduc/100)
    		damage = damage*damageReduc
	    end
	end
	local decreaseAll = GameState:IncomingDamageDecrease(victim, attacker, shouldConsumeShields)

	return (damage/BASE_VALUE_FOR_CALCULATE)*decreaseAll
end

function GameState:IncomingDamageDecrease(victim, attacker, shouldConsumeShields)
	local BASE_VALUE_FOR_CALCULATE = 1000000 -- for prevent calc errors with small values
	local damage = BASE_VALUE_FOR_CALCULATE

	if victim:HasModifier("modifier_ablecore_greaves_effect") then
		damage = damage*0.2
	end
	if victim:HasModifier("modifier_solunia_c_d_arcana_shell") then
		damage = damage*0.05
	end
	if victim:HasModifier("modifier_neutral_glyph_5_1") then
		damage = damage*0.65
	end

	if victim:HasModifier("modifier_axe_glyph_1_1") then
		damage = damage*0.7
	end
	if victim:HasModifier("modifier_redrock_footwear_damage_reduction") then
		damage = damage*0.5
	end

	if victim:HasModifier("modifier_fuchsia_damage_resistance") then
		damage = damage*0.15
	end
	if victim:HasModifier("modifier_energy_field_c_d_shield") then
		damage = damage*0.05
	end
	if victim:HasModifier("modifier_possession_enemy_lock") then
		damage = 0
	end
	if victim:HasModifier("modifier_rooted_feet_health_regen") then
		damage = damage*0.5
	end
	if victim:HasModifier("modifier_ogre_armor") then
		local ogreArmor = victim:FindAbilityByName("winterblight_ogre_armor")
		local reduction = ogreArmor:GetLevelSpecialValueFor("damage_resist", ogreArmor:GetLevel())
		reduction = (100-reduction)/100
		damage = damage*reduction
	end
	if victim:HasModifier("modifier_arkimus_archon_form") then
		local archonForm = victim:FindAbilityByName("arkimus_archon_form")
		local reduction = archonForm:GetLevelSpecialValueFor("damage_resist", archonForm:GetLevel())
		reduction = (100-reduction)/100
		damage = damage*reduction
	end
	if victim:HasModifier("modifier_axe_rune_c_d_shield") then
		damage = damage*0.2
		if victim:HasModifier("modifier_axe_glyph_6_2") then
			damage = damage * 0.5
		end
		if shouldConsumeShields then
			Filters:HitAxeCCShield(victim, attacker)
		end
	end
	if victim:HasModifier("modifier_volcano_shield") then
		damage = damage*0.1
		if shouldConsumeShields then
			CustomAbilities:HitVolcanoShield(victim, attacker)
		end
	end
	if victim:HasModifier("modifier_whirlwind") and victim:HasModifier("modifier_axe_glyph_4_2") then
		damage = damage*0.5
	end

	if victim:HasModifier("modifier_neutral_glyph_5_2") then
		damage = damage*2
	end

	if victim:HasModifier("modifier_raven_idol") then
		damage = damage*0.6
	end
	if victim:HasModifier("modifier_raven_idol2") then
		damage = damage*0.5
	end

	if victim:HasModifier("modifier_axe_immortal_weapon_1") then
		damage = damage*0.5
	end

	if victim:HasModifier("modifier_living_gauntlet_effect") then
		damage = damage*0.5
	end

	if victim:HasModifier("modifier_red_october_boots") then
		local EAbility = victim:GetAbilityByIndex(2)
		if EAbility:GetCooldownTimeRemaining() > 0 then
			damage = damage*0.5
		end
	end

	if victim:HasModifier("modifier_world_tree_effect") then
		damage = damage*2
	end

	if victim:HasModifier("modifier_guard_of_feronia_shield") then
		damage = damage*0.05
	end

	if victim:HasModifier("modifier_dummy_aura1_effect_zhonik") then
		damage = damage*0.2
	end
	if victim:HasModifier("modifier_damage_resistance") then
		if victim.damageReduc then
			damage = damage*victim.damageReduc
		end
	end

	if victim:HasModifier("modifier_sea_giants_plate") then
		if victim:IsStunned() then
			damage = damage*0.04
		end
	end

	if victim:HasModifier("modifier_chitinous_skin_stack") then
		local stacks = victim:GetModifierStackCount("modifier_chitinous_skin_stack", victim.InventoryUnit)
		local reduction = 1 - stacks*0.01
		damage = damage*reduction
		local newStacks = stacks - 1
		if newStacks > 0 then
			victim:SetModifierStackCount("modifier_chitinous_skin_stack", victim.InventoryUnit, newStacks)
		else
			victim:RemoveModifierByName("modifier_chitinous_skin_stack")
		end
	end

	if victim:HasModifier("modifier_overload_damage_resistance") then
		damage = damage*0.1
	end

	if victim:HasModifier("modifier_energy_channel") or victim:HasModifier("modifier_steelforge_stance") then
		if victim:HasModifier("modifier_mountain_protector_glyph_2_1") then
			damage = damage*0.7
		end
	end

	if victim:HasModifier("modifier_tachyon_shell") then
		local modifier = victim:FindModifierByName("modifier_tachyon_shell")
		if modifier:GetCaster():GetTeamNumber() == victim:GetTeamNumber() then
			local reduction = math.max(1 - modifier:GetAbility().d_a_level*0.005, 0.1)
			if victim:GetEntityIndex() == modifier:GetCaster():GetEntityIndex() then
				reduction = reduction/2
			end
			damage = damage*reduction
		end
	end

	if victim:HasModifier("modifier_ancient_tree_passive") then
		damage = damage*0.004
		if victim:HasModifier("modifier_ancient_tree_round_2") then
			damage = damage*0.5
		end
		local reduction = math.min(victim.summonCount*0.05, 1)
		damage = damage*(1-reduction)
	end
	if victim:HasModifier("modifier_drowning_pool_actual_effect") then
		local modifier = victim:FindModifierByName("modifier_drowning_pool_actual_effect")
		local stacks = modifier:GetStackCount()
		local damageReduc = math.min(stacks*0.015, 0.9)
		damage = damage - damage*damageReduc
	end
	if victim:HasModifier("modifier_steelforge_passive") then
		local steelForge = victim:FindAbilityByName("mountain_protector_steelforge_stance")
		local reduction = steelForge:GetLevelSpecialValueFor("damage_resist", steelForge:GetLevel())
		reduction = (100-reduction)/100
		damage = damage*reduction
	end
	if victim:HasModifier("modifier_task_armor") then
		damage = damage*0.001
		if shouldConsumeShields then
			CustomAbilities:HitTaskShield(victim, attacker)
		end
	end
	if victim:HasModifier("modifier_knights_disciple_heal") then
		damage = damage*0.8
	end
	if victim:HasModifier("modifier_astral_c_c_visible") then
		damage = damage*0.25
	end
	if victim:HasModifier("modifier_ancient_rain") then
		local ancientRain = victim:FindAbilityByName("spirit_warrior_ancient_rain")
		if ancientRain then
			local reduction = (100-ancientRain:GetSpecialValueFor("damage_reduction_percent"))/100
			damage = damage*reduction
		end
	end

	if victim:HasModifier("modifier_duskbringer_t42_visible") then
		local stacks = victim:GetModifierStackCount("modifier_duskbringer_t42_visible", victim)
		damage = damage * (1 - 0.03 * stacks)
	end


	return damage/BASE_VALUE_FOR_CALCULATE
end

function GameState:FilterDamage(filterTable)
	local victim_index = filterTable["entindex_victim_const"]
	local attacker_index = filterTable["entindex_attacker_const"]
	if not victim_index or not attacker_index then
		return true
	end
	local difficultyDamageReduce = 1
	local victim = EntIndexToHScript( victim_index )
	local attacker = EntIndexToHScript( attacker_index )

	if attacker:HasModifier("modifier_arkimus_archon_form") then
		filterTable["damagetype_const"] = DAMAGE_TYPE_PURE
	end
	local damagetype = filterTable["damagetype_const"]

	local mult = 1
	local divisor = 1
	local modifier = nil

	if attacker:IsHero() then
		-- if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
		-- 	filterTable["damage"] = math.ceil(filterTable["damage"]/(1+((attacker:GetIntellect()/14)/100)))
		-- end
	end
	local StartingDamage = filterTable["damage"]
	local applyEffects = true
	local applySturdyHornEffect = true
	if filterTable["entindex_inflictor_const"] then
		local ability = EntIndexToHScript(filterTable["entindex_inflictor_const"])
		if not string.match(ability:GetClassname(), "npc_dota_hero_") then
			if IsValidEntity(ability) then
				if ability:GetEntityIndex() == Events.GameMasterAbility:GetEntityIndex() then
					print("APPLY EFFECTS FALSE!")
					applyEffects = false
				end
				local abilityName = ability:GetAbilityName()
				modifier = victim:FindModifierByName('modifier_centaur_horns')
				if abilityName ~= 'item_rpc_centaur_horns' and modifier then
					local centaurHornsAbility = modifier:GetAbility()
					centaurHornsAbility:ApplyDataDrivenModifier(victim, victim, "modifier_centaur_horns_debuff", {duration = 1.5})
				end
			end
		end
	end

	if applyEffects then
		if victim:HasModifier("modifier_dungeon_thinker_creep") then
			victim.aggro = true
			Dungeons:AggroUnit(victim)
		end
	end
	if GameState:IsPVPAlpha() then
		if victim:IsHero() and attacker:IsHero() then
			if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
				filterTable["damage"] = filterTable["damage"]*0.1
			end
		end
	end

	if attacker:HasModifier("modifier_slipfinn_passive") then
		if filterTable["entindex_inflictor_const"] then
			local ability = EntIndexToHScript(filterTable["entindex_inflictor_const"])
			if IsValidEntity(ability) and ability.possessionAbility then
				local damage = filterTable["damage"]
				local element1 = RPC_ELEMENT_NONE
				if attacker:HasModifier("modifier_slipfinn_immortal_weapon_3") then
					element1 = RPC_ELEMENT_SHADOW
				end
				local a_d_level = Runes:GetTotalRuneLevelGeneric(attacker, 1, 3)
				damage = damage + damage*a_d_level*0.15
				Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damagetype, 4, element1, RPC_ELEMENT_NONE)
				return false
			end
		end
		if WallPhysics:DoesTableHaveValue(attacker.possessedTable, victim:GetUnitName()) then
			local c_d_level = Runes:GetTotalRuneLevelGeneric(attacker, 3, 3)
			if c_d_level > 0 then
				mult = mult + 0.2*c_d_level
			end
		end
	end
	if damagetype == DAMAGE_TYPE_PHYSICAL then
		-- local original_damage = filterTable["damage"] --Post reduction
		-- local inflictor = filterTable["entindex_inflictor_const"]
		-- local damage = original_damage
		-- filterTable["damage"] = damage
		-- if attacker:IsHero() then
		-- 	local primaryAttibute = Filters:GetPrimaryAttributeMultiple(attacker, 1)
		-- 	filterTable["damage"] = filterTable["damage"]*(1+((primaryAttibute/16)/100))
		-- end
		if attacker:HasModifier("modifier_tempest_falcon_ring") then
			attacker.amulet:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_tempest_falcon_ring_effect", {duration = 8})
		end
		if attacker:HasModifier("modifier_firelock_pendant") then
			local multIncrease = (attacker:GetStrength()/10)*0.005
			mult = mult + multIncrease
		end
		if attacker:HasModifier("modifier_power_ranger") then
			mult = mult + 2
		end
		if attacker:HasModifier("modifier_golden_war_plate") then
			mult = mult + 7.0
		end
		if victim:HasModifier("modifier_hood_of_defiler_effect_visible") then
			local multIncrease = victim:GetModifierStackCount("modifier_hood_of_defiler_effect_visible", victim.defiler)*0.25
			mult = mult + multIncrease
		end
		if attacker:HasModifier("modifier_gravekeeper_gauntlet_buff") then
			local stacks = attacker:GetModifierStackCount("modifier_gravekeeper_gauntlet_buff", attacker.InventoryUnit)
			filterTable["damage"] = filterTable["damage"]*(1+(stacks*0.1))
		end
		if attacker:HasModifier("modifier_hand_marauder") then
			if victim:GetPhysicalArmorValue() > 0 then
				local armor = victim:GetPhysicalArmorValue()
				local damageMult = 1 - (0.05*armor/(1 + (0.05 * math.abs(armor))))
				filterTable["damage"] = filterTable["damage"]/damageMult
			end
		end
	elseif damagetype == DAMAGE_TYPE_MAGICAL then
		local inflictor = filterTable["entindex_inflictor_const"]
		if attacker:HasModifier("modifier_volcano_orb") then
			mult = mult+0.5
			print("INCREASE MAGIC DAMAGE")
		end
		if attacker:HasModifier("modifier_alarana_ice_freeze") then
			mult = mult + 0.75
		end
		if attacker:HasModifier("modifier_warlord_glyph_5_a") then
			if attacker:HasModifier("modifier_warlord_ice_charge") then
				local iceCharges = attacker:GetModifierStackCount("modifier_warlord_ice_charge", attacker)
				mult = mult + 0.05*iceCharges
			end
		end
		if attacker:HasModifier("modifier_shadow_trap_d_a_buff") then
			local stacks = attacker:GetModifierStackCount("modifier_shadow_trap_d_a_buff", attacker)
			mult = mult + 0.1*stacks
		end
		if attacker:HasModifier("modifier_auriun_passive") then
			if attacker.a_c_level then
				mult = mult + 0.02*attacker.a_c_level
			end
		end
		if attacker:HasModifier("modifier_sorcerers_regalia") then
			mult = mult+0.4
		end
		if attacker:HasModifier("modifier_neutral_glyph_6_3") then
			mult = mult+0.25
		end
		if attacker:HasModifier("modifier_far_seers_gloves") then
			Filters:FarSeerGloves(attacker, filterTable["damage"], filterTable["entindex_inflictor_const"])
		end
		if attacker:HasModifier("modifier_tempest_falcon_ring_effect") then
			mult = mult + 3
			Timers:CreateTimer(0.05, function()
				attacker:RemoveModifierByName("modifier_tempest_falcon_ring_effect")
			end)
		end
		if attacker:HasModifier("modifier_mark_of_the_talon") then
			local talonAbility = attacker:FindModifierByName("modifier_mark_of_the_talon"):GetAbility()
			local multIncrease = talonAbility:GetLevelSpecialValueFor("post_mitigation_magic", talonAbility:GetLevel())/100
			if talonAbility.d_a_level then
				multIncrease = multIncrease + multIncrease*talonAbility.d_a_level*0.02
			end
			mult = mult + multIncrease
		end
		if attacker:HasModifier("modifier_hood_of_the_black_mage") then
			mult = mult + 2.8
		end



		-- if attacker:HasModifier("modifier_warlord_rune_b_a_invisible") then
		-- 	if damagetype == DAMAGE_TYPE_MAGICAL then
		-- 		local stacks = attacker:GetModifierStackCount("modifier_warlord_rune_b_a_invisible", attacker.runeUnit2)
		-- 		mult = mult + 0.04*stacks
		-- 	end
		-- end
		if attacker:HasModifier("modifier_energy_channel") then
			filterTable["damage"] = filterTable["damage"]*attacker.mountainGuardianMagic
		end
		if victim:HasModifier("modifier_carbuncles_helm_of_reflection_effect") then
			if not attacker:HasModifier("modifier_carbuncles_helm_of_reflection_effect") then
				if not attacker:HasModifier("modifier_carbuncle_immunity") then
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_medusa/carbuncle_ruby_shell_cast.vpcf", victim, 0.8)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_medusa/carbuncle_ruby_shell_cast.vpcf", attacker, 0.8)
					Filters:ApplyItemDamage(attacker,victim,filterTable["damage"]*1000,DAMAGE_TYPE_MAGICAL,victim.headItem,RPC_ELEMENT_FIRE,RPC_ELEMENT_ARCANE)
					victim.headItem:ApplyDataDrivenModifier(victim.InventoryUnit, attacker, "modifier_carbuncle_immunity", {duration = 3})
					Filters:ApplyStun(victim, 3, attacker)
					EmitSoundOn("RPC.Carbuncle.Reflect", attacker)
					local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/items/carbuncle_reflect.vpcf", attacker, 3)
					ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
				end
			end
			filterTable["damage"] = 0
		end
		if victim:HasModifier("modifier_umbral_sentinel_magic_amp") then
			local multIncrease = victim:GetModifierStackCount("modifier_umbral_sentinel_magic_amp", victim.umbral)*0.03
			mult = mult + multIncrease
		end

		if victim:HasModifier("modifier_solunia_warp_core_aura_solar") then
			modifier = victim:FindModifierByName("modifier_solunia_warp_core_aura_solar")
			mult = mult + modifier:GetAbility().c_c_level*0.05
		end
	elseif damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_solunia_warp_core_aura_lunar") then
			modifier = victim:FindModifierByName("modifier_solunia_warp_core_aura_lunar")
			mult = mult + modifier:GetAbility().c_c_level*0.05
		end
	end
	if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_emerald_nullification_ring") then
			filterTable["damage"] = math.max(filterTable["damage"] - Filters:GetHeroAttribute(victim, "agility")*5, 0)
		end
		if victim:HasModifier("modifier_azure_empire_visible") then
			if not Filters:HasDamageBlockShield(victim) then
				if filterTable["damage"] > 0 then
					filterTable["damage"] = 0
					Filters:AzureEmpire(victim, attacker)
				end
			end
		end
		if victim:HasModifier("modifier_ivory_gryffin_aura_effect") then
			filterTable["damage"] = filterTable["damage"] * 0.7
		end
		if attacker:HasModifier("modifier_leshrac_arcana_b_d_effect") then
			modifier = attacker:FindModifierByName("modifier_leshrac_arcana_b_d_effect")
			if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
				local stacks = modifier:GetStackCount()
				local multIncrease = 0.01*stacks
				mult = mult + multIncrease
			end
		end
		if attacker:HasModifier("modifier_bahamut_arcana_passive") then
			local a_b_level = Runes:GetTotalRuneLevelGeneric(attacker, 1, 1)
			print("LESHRAC ABLEVEL!!")
			if a_b_level > 0 then
				local healAmount = math.ceil(filterTable["damage"]*0.001/100*a_b_level)
				if healAmount > attacker:GetMaxHealth() - attacker:GetHealth() then
					local allyHealAmount = healAmount - (attacker:GetMaxHealth() - attacker:GetHealth())
					local arcanaAbility = attacker:FindAbilityByName("bahamut_arcana_orb")
					arcanaAbility:ApplyDataDrivenModifier(attacker, attacker, "modifier_spellvamp_healing", {duration = 0.3})
					local allies = FindUnitsInRadius( attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
					if #allies > 0 then
						for _,ally in pairs(allies) do
							Filters:ApplyHeal(attacker, ally, allyHealAmount/10, true)
						end
					end 
				end
				Filters:ApplyHeal(attacker, attacker, healAmount, true)
			end
		end

    end
    if damagetype == DAMAGE_TYPE_PHYSICAL or damagetype == DAMAGE_TYPE_MAGICAL then
		if victim:HasModifier("modifier_zonik_lightspeed") then
			local c_c_level = victim:FindAbilityByName("zonik_lightspeed").c_c_level
			filterTable["damage"] = math.max(filterTable["damage"] - Filters:GetHeroAttribute(victim, "agility")*c_c_level, 0)
		end
	end
	if victim:HasModifier("modifier_voltex_arcana1_passive") then
		local dash = victim:FindAbilityByName("voltex_lightning_dash")
		local damage = filterTable["damage"]
		local c_c_level = Runes:GetTotalRuneLevelGeneric(victim, 3, 2)
		if c_c_level > 0 then
			if not dash.regen then
				dash.regen = 0
			end
			local addedRegen = math.ceil(damage*0.025*c_c_level)
			dash.regen = dash.regen + addedRegen
			dash:ApplyDataDrivenModifier(victim, victim, "modifier_voltex_lightning_dash_regen", {duration = 3})
			dash:ApplyDataDrivenModifier(victim, victim, "modifier_voltex_lightning_dash_regen_hidden", {duration = 3})
			victim:SetModifierStackCount("modifier_voltex_lightning_dash_regen_hidden", victim, dash.regen)
		end
	end

	if attacker:HasModifier("modifier_trickster_mask") then
		local minBoost = 0
		if attacker:HasModifier("modifier_boots_of_great_fortune") then
			minBoost = minBoost + 2
		end
		if attacker:HasModifier("modifier_fortunes_talisman_of_truth") then
			minBoost = minBoost*1.5 + 2
		end
		local tricksterFactor = RandomInt(-5+minBoost, 15)
		mult = mult + tricksterFactor/10
	end
	if victim:HasModifier("modifier_nights_procession_a_d_rune") then
		if attacker:GetUnitName() == "npc_dota_hero_night_stalker" then
			local multBonus = victim:GetModifierStackCount("modifier_nights_procession_a_d_rune", attacker)*0.07
			mult = mult+multBonus
		end
	end
	if victim:HasModifier("modifier_nightmare_rider_effect_visible") then
		mult = mult + 2
	end
	if attacker:HasModifier("modifier_axe_rune_d_d_invisible") then
		local stacksCount = attacker:GetModifierStackCount("modifier_axe_rune_d_d_invisible", attacker)
		mult = mult + stacksCount * 0.02
	end

	if attacker:HasModifier("modifier_ablecore_greaves_effect") then
		mult = mult + 1.5
	end
	if attacker:HasModifier("modifier_chernobog_demon_form") then
		local demonForm = attacker:FindAbilityByName("chernobog_demon_morph")
		if demonForm then
			mult = mult + 0.1*demonForm.d_d_level
		end
	end
	if attacker:HasModifier("modifier_mordiggus_gauntlet") then
		mult = mult+1
	end
	if victim:HasModifier("modifier_epoch_rune_b_b_visible") then
		if victim:GetPhysicalArmorValue() < 0 then
			if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
				modifier = victim:FindModifierByName("modifier_epoch_rune_b_b_visible")
				if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
					local stacks = modifier:GetStackCount()
					local multIncrease = stacks*0.05*math.abs(victim:GetPhysicalArmorValue())/10
					mult = mult + multIncrease/100
				end
			end
		end
	end
	if victim:HasModifier("modifier_astral_rune_a_c_visible") then
		modifier = victim:FindModifierByName("modifier_astral_rune_a_c_invisible")
		local stacks = modifier:GetStackCount()
		local multIncrease = 0.006*stacks
		mult = mult + multIncrease
	end
	if victim:HasModifier("modifier_astral_d_b_visible") then
		modifier = victim:FindModifierByName("modifier_astral_d_b_invisible")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = 0.009*stacks
			mult = mult + multIncrease
		end
	end
	if attacker:HasModifier("modifier_bahamut_arcana_post_mit") then
		local bahamut = attacker:FindModifierByName("modifier_bahamut_arcana_post_mit"):GetCaster()
		local stacks = attacker:GetModifierStackCount("modifier_bahamut_arcana_post_mit", bahamut)
		mult = mult + stacks * 0.035
	end
	if victim:HasModifier("modifier_wolf_rend_bleed") then
		modifier = victim:FindModifierByName("modifier_wolf_rend_bleed")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local multIncrease = 0.04*modifier:GetAbility().b_b_level
			mult = mult + multIncrease
		end
	end

	if victim:HasModifier("modifier_water_mage_slow") then
		modifier = victim:FindModifierByName("modifier_water_mage_slow")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			mult = mult + 1
		end
	end
	if victim:HasModifier("modifier_arkimus_c_b_sprinting") then
		if victim:HasModifier("modifier_arkimus_immortal_weapon_3") then
			filterTable["damage"] = 0
		end
	end
	if attacker:HasModifier("modifier_conjuror_glyph_5_a") or attacker:HasModifier("modifier_conjuror_glyph_5_a_summon") then
		mult = mult + 2
	end
	if victim:HasModifier("modifier_swarm_effect") then
		local multIncrease = victim:GetModifierStackCount("modifier_swarm_effect", victim.umbral)*0.06
		mult = mult + multIncrease
	end
	if victim:HasModifier("modifier_witch_hat_damage_amp") then
		modifier = victim:FindModifierByName("modifier_witch_hat_damage_amp")
		local stacks = modifier:GetStackCount()
		local multIncrease = 0.15*stacks
		mult = mult + multIncrease
	end

	local modifier = victim:FindModifierByName("modifier_draghor_hawk_screech")
	if modifier then
		mult = mult + modifier:GetStackCount()
	end

	if attacker:HasModifier("modifier_drowning_pool_actual_effect") then
		modifier = attacker:FindModifierByName("modifier_drowning_pool_actual_effect")
		local stacks = modifier:GetStackCount()
		local damageIncrease = stacks*0.2
		filterTable["damage"] = filterTable["damage"] + filterTable["damage"]*damageIncrease
	end
	if attacker:HasModifier("modifier_flamewaker_arcana_b_a_effect") then
		modifier = attacker:FindModifierByName("modifier_flamewaker_arcana_b_a_effect")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = 0.03*stacks
			mult = mult + multIncrease
		end
	end
	if attacker:HasModifier("modifier_voltex_immortal_weapon_1") then
		mult = mult + 0.5
	end
	if attacker:HasModifier("modifier_machinal_jump_c_c_amp") then
		modifier = attacker:FindModifierByName("modifier_machinal_jump_c_c_amp")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = 0.02*stacks
			mult = mult + multIncrease
		end
	end
	if victim:HasModifier("modifier_reaper_slice_amp_debuff") then
		modifier = victim:FindModifierByName("modifier_reaper_slice_amp_debuff")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = 0.02*stacks
			mult = mult + multIncrease
		end
	end
	if victim:HasModifier("modifier_earth_guardian") then
		Filters:EarthGuardian(victim, filterTable["damage"])
		filterTable["damage"] = filterTable["damage"]*0.5
	end
	if victim:HasModifier("modifier_warlord_b_d_effect") then
		modifier = victim:FindModifierByName("modifier_warlord_b_d_effect")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = 0.05*stacks
			mult = mult + multIncrease
		end
	end
	if attacker:HasModifier("modifier_flamewaker_arcana_d_a_aura") then
		modifier = attacker:FindModifierByName("modifier_flamewaker_arcana_d_a_aura")
		if victim:GetEntityIndex() == modifier:GetCaster():GetEntityIndex() then
			local stacks = modifier:GetAbility().d_a_level
			local damageReduc = math.min(stacks*0.015, 0.9)
			filterTable["damage"] = filterTable["damage"]*(1-damageReduc)
		end
	end
	if attacker:HasModifier("modifier_terrasic_stone_plate") then
		if victim:IsStunned() or victim:HasModifier("modifier_knockback") then
			mult = mult + 2
		end
	end
	if attacker:HasModifier("modifier_steelforge_passive") then
		if victim:IsStunned() or victim:HasModifier("modifier_knockback") then
			mult = mult + 0.03*attacker.b_b_level
		end
	end
	if attacker:HasModifier("modifier_waterheart_weapon") then
		local waterheart = attacker:FindModifierByName("modifier_waterheart_weapon"):GetAbility()
		if waterheart then
			mult = mult + 0.03*waterheart.c_d_level
		end
	end
	if attacker:HasModifier("modifier_bahamut_charge_of_light_postmitigation") then
		local stacks = attacker:GetModifierStackCount("modifier_bahamut_charge_of_light_postmitigation", attacker)
		mult = mult + 0.15*stacks
	end
	if victim:HasModifier("tanari_mountain_specter_ai") then
		local reduc = 0.1
		if GameState:GetDifficultyFactor() == 2 then
			reduc = 0.9
		elseif GameState:GetDifficultyFactor() == 3 then
			reduc = 0.996
		end
		if victim.mainBoss then
			filterTable["damage"] = filterTable["damage"]/25
		end
		filterTable["damage"] = filterTable["damage"]*(1-reduc)
	end
	if attacker:HasModifier("tanari_mountain_specter_ai") then
		filterTable["damage"] = filterTable["damage"]*1.2
	end
	if victim:HasModifier("modifier_water_jailer_passive") then
		local reduc = 0.1
		if GameState:GetDifficultyFactor() == 2 then
			reduc = 0.5
		elseif GameState:GetDifficultyFactor() == 3 then
			reduc = 0.98
		end
		filterTable["damage"] = filterTable["damage"]*(1-reduc)
	end
	if victim:HasModifier("modifier_wind_temple_key_stone_form") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_windsteel_effect") then
		filterTable["damage"] = Filters:WindSteelTakeDamage(victim, filterTable["damage"])
	end
	if victim:HasModifier("modifier_secret_temple_refraction") then
		print("DAMAGE BEFORE: "..filterTable["damage"])
		filterTable["damage"] = Filters:SecretTempleTakeDamage(victim, filterTable["damage"])
		print("DAMAGE AFTER: "..filterTable["damage"])
	end
	if victim:HasModifier("modifier_heavens_shield") then
		filterTable["damage"] = Filters:HeavensShieldTakeDamage(victim, filterTable["damage"])
	end
	if victim:HasModifier("modifier_shipyard_veil_shield") then
		if applyEffects then
			if filterTable["damage"] > 0 then
				filterTable["damage"] = 0
				CustomAbilities:HitShipyardShield(victim, attacker)
			end
		end
	end
	if attacker:HasModifier("modifier_neutral_glyph_5_3") then
		if damagetype == DAMAGE_TYPE_PHYSICAL then
			filterTable["damage"] = filterTable["damage"]*1.5
		end
		if damagetype == DAMAGE_TYPE_MAGICAL then
			filterTable["damage"] = filterTable["damage"]*0.5
		end
	end

	if victim:HasModifier("modifier_firelord_ability_ai") then
		if GameState:GetDifficultyFactor() == 3 then
			filterTable["damage"] = filterTable["damage"]*0.2
			if Events.SpiritRealm then
				filterTable["damage"] = filterTable["damage"]*0.3
			end
		end
	end
	if victim:HasModifier("modifier_guard_of_grithault") then
		filterTable["damage"] = Filters:GrithaultDamage(victim, filterTable["damage"])
	end
	if attacker:HasModifier("modifier_warlord_glyph_3_1") then
		if attacker.warlordElement then
			if attacker.warlordElement == "ice" and damagetype == DAMAGE_TYPE_MAGICAL then
				filterTable["damage"] = filterTable["damage"]*1.4
			end
		end
	end
	if victim:HasModifier("modifier_aeriths_tear") then
		if Filters:AerithsTearTakeDamage(attacker, victim) then
			filterTable["damage"] = filterTable["damage"]*0.1
		end
	end
	if victim:HasModifier("modifier_infernal_jailer_passive") then
		local distance = WallPhysics:GetDistance(victim:GetAbsOrigin(), attacker:GetAbsOrigin())
		if distance > 360 then
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_batrider/batrider_firefly_startflash.vpcf", victim, 1)
			filterTable["damage"] = filterTable["damage"]*0.001
		end
	end
	if victim:HasModifier("modifier_tempest_haze_effect_friendly") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			modifier = victim:FindModifierByName("modifier_tempest_haze_effect_friendly")
			if modifier:GetCaster():GetEntityIndex() == victim:GetEntityIndex() then
				filterTable["damage"] = filterTable["damage"]*0.2
			end
		end
	end
	if attacker:HasModifier("modifier_epoch_arcana_passive") then
		if victim:HasModifier("modifier_epoch_arcana_root") then
			local b_a_level = Runes:GetTotalRuneLevelGeneric(attacker, 2, 0)
			if b_a_level > 0 then
				local multIncrease = 0.00001*victim:GetPhysicalArmorBaseValue()*b_a_level
				mult = mult + multIncrease
			end
		end
	end
	if attacker:HasModifier("modifier_zhonic_arcana_c_c_invisible") then
		local stacks = attacker:GetModifierStackCount("modifier_zhonic_arcana_c_c_invisible", attacker)
		local multIncrease = stacks*0.0002
		mult = mult + multIncrease
	end
	if attacker:HasModifier("modifier_general_postmitigation") then
		local stacks = attacker:GetModifierStackCount("modifier_general_postmitigation", Events.GameMaster)
		local multIncrease = stacks/100
		mult = mult + multIncrease
	end
	if attacker:HasModifier("modifier_sunstrider_sunwarrior_vengeance_post_mit") then
		local stacks = attacker:GetModifierStackCount("modifier_sunstrider_sunwarrior_vengeance_post_mit", attacker)
		local multIncrease = stacks*0.12
		mult = mult + multIncrease
	end
	if victim:HasModifier("modifier_auriun_immortal_weapon_1") then
		filterTable["damage"] = Filters:AuriunImmortalWeapon1(filterTable["damage"], victim)
	end

	if victim:HasModifier("modifier_paladin_d_c") then
		modifier = victim:FindModifierByName("modifier_paladin_d_c")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + 0.25*stacks
		end
	end
	if victim:HasModifier("modifier_slipfinn_gloomshade_invisible") then
		modifier = victim:FindModifierByName("modifier_slipfinn_gloomshade_invisible")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + 0.01*stacks
		end
	end
	if attacker:HasModifier("modifier_paladin_d_c_postmit") then
		local stacks = attacker:GetModifierStackCount("modifier_paladin_d_c_postmit", attacker)
		mult = mult + 0.01*stacks
	end
	if victim:HasModifier("modifier_tachyon_amp") then
		modifier = victim:FindModifierByName("modifier_tachyon_amp")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + 0.04*stacks
		end
	end
	if victim:HasModifier("modifier_hailstorm_enemy_amp") then
		modifier = victim:FindModifierByName("modifier_hailstorm_enemy_amp")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + 0.06*stacks
		end
	end
	if attacker:HasModifier("modifier_hood_of_the_sea_oracle") then
		if victim:HasModifier("modifier_sea_oracle_stacker") then
			local stacks = victim:GetModifierStackCount("modifier_sea_oracle_stacker", attacker.InventoryUnit)
			if stacks >= 15 then
				mult = mult + 5.5
				if not victim:HasModifier("modifier_sea_oracle_particle_lock") then
					local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/seafortress/sea_oracle_impact.vpcf", victim, 1)
					ParticleManager:SetParticleControl(pfx, 1, victim:GetAbsOrigin())
					EmitSoundOn("RPCItem.OceanOracle.AttackLand", victim)
					attacker.headItem:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_sea_oracle_particle_lock", {duration = 1.0})
				end
			end
		end
	end
	if Filters:IsIceFrozen(victim) and attacker:HasModifier('modifier_frost_nova_passive') then
		if attacker.b_a_level then
			mult = mult + 0.035*attacker.b_a_level
		end
	end
	if Filters:IsFireBurning(victim) and attacker:HasModifier('modifier_fire_ring_passive') then
		if attacker.b_a_level then
			mult = mult + 0.035*attacker.b_a_level
		end
	end

	if victim:HasModifier("modifier_recently_respawned") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_sadist_shield") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			filterTable["damage"] = 0
			if applyEffects then
				CustomAbilities:HitShieldGeneric(victim, attacker, victim, "modifier_sadist_shield")
			end
		end
	end
	if victim:HasModifier("modifier_black_dominion_shield") then
		filterTable["damage"] = 0
		local shieldCaster = victim:FindModifierByName("modifier_black_dominion_shield"):GetCaster()
		CustomAbilities:HitShieldGeneric(victim, attacker, shieldCaster, "modifier_black_dominion_shield")
	end
	if victim:HasModifier("modifier_light_seer_shield") then
		if filterTable["damage"] > 0 then
			filterTable["damage"] = 0
			local shieldCaster = victim:FindModifierByName("modifier_light_seer_shield"):GetCaster()
			CustomAbilities:HitShieldGeneric(victim, attacker, victim.InventoryUnit, "modifier_light_seer_shield")
		end
	end
	if victim:HasModifier("modifier_djanghor_4_1_shield") then
		if filterTable["damage"] > 0 then
			filterTable["damage"] = 0
			local shieldCaster = victim:FindModifierByName("modifier_djanghor_4_1_shield"):GetCaster()
			CustomAbilities:HitShieldGeneric(victim, attacker, victim, "modifier_djanghor_4_1_shield")
		end
	end
	if victim:HasModifier("modifier_ice_throw_b_b_frozen") then
		modifier = victim:FindModifierByName("modifier_ice_throw_b_b_frozen")
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PHYSICAL then
			local stacks = modifier:GetStackCount()
			filterTable["damage"] = filterTable["damage"] + filterTable["damage"]*0.07*stacks
		end
	end
	if victim:HasModifier("modifier_voltex_d_b_debuff") then
		modifier = victim:FindModifierByName("modifier_voltex_d_b_debuff")
		if damagetype == DAMAGE_TYPE_MAGICAL then
			if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
				local stacks = modifier:GetStackCount()
				filterTable["damage"] = filterTable["damage"] + filterTable["damage"]*0.2*stacks
			end
		end
	end
	if attacker:HasModifier("modifier_golden_war_plate") then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			filterTable["damage"] = filterTable["damage"]*0.35
		end
	end
	if victim:HasModifier("moon_tech_aura") then
		modifier = victim:FindModifierByName("moon_tech_aura")
		local modifierCaster = modifier:GetCaster()
		if attacker:GetEntityIndex() == modifierCaster:GetEntityIndex() then
			local movespeed = attacker:GetBaseMoveSpeed()
			local movespeedAttacker = attacker:GetMoveSpeedModifier(movespeed)
			movespeed = victim:GetBaseMoveSpeed()
			local movespeedVictim = victim:GetMoveSpeedModifier(movespeed)
			local amp = math.max((movespeedAttacker-movespeedVictim)/100, 0)
			mult = mult + amp
		end
	end
	if victim:HasModifier("modifier_mach_punch_amp") then
		modifier = victim:FindModifierByName("modifier_mach_punch_amp")
		local modifierCaster = modifier:GetCaster()
		if attacker:GetEntityIndex() == modifierCaster:GetEntityIndex() then
			local movespeed = attacker:GetBaseMoveSpeed()
			local movespeedAttacker = attacker:GetMoveSpeedModifier(movespeed)
			movespeed = victim:GetBaseMoveSpeed()
			local movespeedVictim = victim:GetMoveSpeedModifier(movespeed)
			-- local amp = math.max((movespeedAttacker-movespeedVictim)/100, 0)
			local amp = (movespeedAttacker-movespeedVictim)/100
			mult = mult + amp
			victim:RemoveModifierByName("modifier_mach_punch_amp")
		end
	end
	if victim:HasModifier("modifier_enchanted_solar_cape") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			victim.body:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_enchanted_solar_cape_effect", {duration = 15})
		end
	end
	if victim:HasModifier("modifier_arcane_shell") then
		filterTable["damage"] = 0
		Filters:ShatterArcaneShell(victim, attacker)
	end
	if victim:HasModifier("modifier_hydroxis_glyph_5_a") then
		if victim:HasModifier("modifier_hydroxis_b_a_shield_visible") or victim:HasModifier("modifier_hydroxis_b_a_shield_visible_glyphed") then
			if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
				filterTable["damage"] = 0
				Filters:MysticWaterShield(victim)
			end
		end
	end
    if attacker:HasModifier("modifier_bladestorm_vest_buff") then
        local bladestormStacks = math.min(attacker:GetModifierStackCount("modifier_bladestorm_vest_buff", attacker.body)+1, 3)
        mult = mult + bladestormStacks*2
    end
	if victim:HasModifier("modifier_duskbringer_ghost_armor") then
		filterTable["damage"] = 0
		Filters:GhostArmor(victim, attacker)
	end

	if attacker:HasModifier("modifier_soul_thrust_effect") then
		modifier = attacker:FindModifierByName("modifier_soul_thrust_effect"):GetCaster()
		if modifier:GetEntityIndex() == victim:GetEntityIndex() then
			filterTable["damage"] = filterTable["damage"]*0.5
		end
	end


	if victim:HasModifier("modifier_paladin_rune_c_a_shield") then
		filterTable["damage"] = 0
		Filters:ShatterPaladinShell(victim, attacker)
	end
	if victim:HasModifier("modifier_voltex_rune_c_b_shield") then
		filterTable["damage"] = 0
		Filters:ShatterVoltexShell(victim, attacker)
	end


	if attacker:HasModifier("modifier_flurry_aura_debuff") then
		filterTable["damage"] = filterTable["damage"]*0.7
	end
	if attacker:HasModifier("modifier_neutral_glyph_5_1") then
		filterTable["damage"] = filterTable["damage"]*0.5
	end
	if attacker:HasModifier("modifier_neutral_glyph_5_2") then
		filterTable["damage"] = filterTable["damage"]*1.35
	end

	if victim:HasModifier("modifier_emerald_douli") then
		local reductionPercent = Filters:EmeraldDouliHit(victim, filterTable["damage"])
		filterTable["damage"] = filterTable["damage"] - filterTable["damage"]*reductionPercent
	end
	if victim:HasModifier("modifier_arkimus_glyph_5_1") then
		local damageReduction = Filters:SpellShieldHit(victim, filterTable["damage"])
		filterTable["damage"] = filterTable["damage"] - damageReduction
	end

	if attacker:HasModifier("modifier_seinaru_immortal_weapon_1") then
		if damagetype == DAMAGE_TYPE_PHYSICAL then
			if not victim.dummy then
				ApplyDamage({ victim = victim, attacker = attacker, damage = filterTable["damage"]*0.35, damage_type = DAMAGE_TYPE_PURE })
				CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf", victim, 1)
			end
		end
	end
	if victim:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		if GameState:GetDifficultyFactor() == 2 then
			if victim.mainBoss then
				filterTable["damage"] = filterTable["damage"]*0.4
			elseif victim.bossStatus then
				filterTable["damage"] = filterTable["damage"]*0.6
			else
				filterTable["damage"] = filterTable["damage"]*1
				difficultyDamageReduce = 1
			end
		elseif GameState:GetDifficultyFactor() == 3 then
			if victim.mainBoss then
				filterTable["damage"] = filterTable["damage"]*0.1
			elseif victim.bossStatus then
				filterTable["damage"] = filterTable["damage"]*0.25
			else
				filterTable["damage"] = filterTable["damage"]*0.6
				difficultyDamageReduce = 0.6
			end
		end
	end
	if victim:HasModifier("modifier_arena_pit_of_trials_enemy") then
		filterTable["damage"] = filterTable["damage"]*Arena:GetResistancePercentage()
	end
	if attacker:HasModifier("modifier_arena_pit_of_trials_enemy") then
		filterTable["damage"] = filterTable["damage"] + filterTable["damage"]*(Arena:GetDamageStacks()/10)
	end
	if victim:HasModifier("modifier_arena_enemy") or victim:HasModifier("modifier_general_reduc") then
		if victim.damageReduc then
			filterTable["damage"] = filterTable["damage"]*victim.damageReduc
			if victim:GetUnitName() == "champion_league_challenger_2" then
				filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth()*0.01)
			elseif victim:GetUnitName() == "champion_league_challenger_1" then
				filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth()*0.008)
			else
				filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth()*0.07)
			end
			filterTable["damage"] = math.max(filterTable["damage"], victim:GetMaxHealth()*0.001)
		end
	end
	if attacker:HasModifier("modifier_arena_crowd_buff") then
		local stacks = attacker:GetModifierStackCount("modifier_arena_crowd_buff", Arena.ArenaMaster)
		local crowdDamageAmp = 1 + (stacks*0.1)
		filterTable["damage"] = filterTable["damage"]*crowdDamageAmp
	end
	if victim:HasModifier("modifier_twig_of_the_enlightened_shield") then
		filterTable["damage"] = Filters:TwigTakeDamage(filterTable["damage"], victim)
	end
	if victim:HasModifier("modifier_phoenix_boss_passive") then
		if filterTable["damage"] > (victim:GetMaxHealth()*0.02) then
			filterTable["damage"] = victim:GetMaxHealth()*0.02
		end
	end
	if victim:GetUnitName() == "phoenix_nest_egg" then
		if GameState:GetDifficultyFactor() == 3 then
			filterTable["damage"] = filterTable["damage"]*0.05
		end
	end
	if victim:HasModifier("modifier_water_jailer_ai") or victim:HasModifier("modifier_bovel_ai") then
		if filterTable["damage"] > (victim:GetMaxHealth()*0.01) then
			filterTable["damage"] = victim:GetMaxHealth()*0.01
		end
	end
	if victim:HasModifier("modifier_fire_key_holder_steam") then
		Tanari:FireKeyHolderSteam(victim, damagetype)
	end
	if victim:HasModifier("modifier_brazen_kabuto_channeling") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_ancient_hero_water_god") then
		if damagetype == DAMAGE_TYPE_PURE then
			filterTable["damage"]=filterTable["damage"]*0.8
			if Events.SpiritRealm then
				filterTable["damage"]=filterTable["damage"]*0.7
			end
		else
			filterTable["damage"] = 0
		end
	end
	if victim:HasModifier("modifier_ancient_hero_wind_god") then
		if damagetype == DAMAGE_TYPE_PHYSICAL then
			filterTable["damage"]=filterTable["damage"]*0.8
			if Events.SpiritRealm then
				filterTable["damage"]=filterTable["damage"]*0.7
			end
		else
			filterTable["damage"] = 0
		end
	end

	if victim:HasModifier("modifier_ancient_hero_fire_god") then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			filterTable["damage"]=filterTable["damage"]*0.8
			if Events.SpiritRealm then
				filterTable["damage"]=filterTable["damage"]*0.7
			end
		else
			filterTable["damage"] = 0
		end
	end
	if victim:HasModifier("modifier_ethereal_revenant_link") then
		if victim.revenantData then
			if victim.revenantData[1] == attacker:GetEntityIndex() then
				filterTable["damage"] = filterTable["damage"]*3
			end
		end
	end
	if attacker:HasModifier("modifier_ethereal_revenant_link") then
		if attacker.revenantData then
			if attacker.revenantData[1] == victim:GetEntityIndex() then
				filterTable["damage"] = filterTable["damage"]*0.1
			end
		end
	end
	if attacker:HasModifier("modifier_baron_storm_link") then
		if attacker.baronData then
			if attacker.baronData[1] == victim:GetEntityIndex() then
				filterTable["damage"] = filterTable["damage"]*0.35
			end
		end
	end
    if attacker:HasModifier("modifier_gorudo_b_d_inside_ring") then
    	modifier = attacker:FindModifierByName("modifier_gorudo_b_d_inside_ring")
    	if victim:GetEntityIndex() == modifier:GetCaster():GetEntityIndex() then
    		filterTable["damage"] = filterTable["damage"]*0.2
    	end
    end
    if victim:HasModifier("modifier_gorudo_b_d_inside_ring") then
    	modifier = victim:FindModifierByName("modifier_gorudo_b_d_inside_ring")
    	if attacker:GetEntityIndex() == modifier:GetCaster():GetEntityIndex() then
    		local d_d_level = attacker:FindAbilityByName("seinaru_gorudo").d_d_level
    		filterTable["damage"] = filterTable["damage"]*(1+d_d_level*0.2)
    	end
    end


	if victim:HasModifier("modifier_fire_mage_ai") then
		filterTable["damage"] = CustomAbilities:WeaponMelt(damagetype, filterTable["damage"])
	end
	if victim:HasModifier("modifier_captain_reimus_ai") then
		if Tanari then
			filterTable["damage"] = Tanari:HeavyArmor(filterTable["damage"], attacker, victim)
		else
			filterTable["damage"] = CustomAbilities:HeavyArmor(filterTable["damage"], attacker, victim)
		end
	end
	if victim:HasModifier("modifier_kolthun_shield") then
		filterTable["damage"] = 0
		Tanari:FireTempleKolthunShieldHit(victim)
	end
	if victim:HasModifier("modifier_firelord_shield") then
		filterTable["damage"] = 0
		Tanari:FireTempleFireShieldHit(victim)
	end


	if Events.SpiritRealm then
      	if victim:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
      		filterTable["damage"] = filterTable["damage"]/6
      	end
      	if attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
      		filterTable["damage"] = filterTable["damage"]*2
      	end
    end
    if victim:HasModifier("modifier_arena_drill_spike") then
    	if attacker:GetEntityIndex() == Arena.ArenaMaster:GetEntityIndex() then
    	else
    		filterTable["damage"] = 0
    	end
    end
    if victim:HasModifier("modifier_arena_challenger_3_b_passive") then
    	if filterTable["damagetype_const"] == DAMAGE_TYPE_PHYSICAL then
    		filterTable["damage"] = 0
    	end
    	Arena:RubickBroTakeDamage(attacker, victim)
    end
    if victim:HasModifier("modifier_arena_challenger_3_a_passive") then
    	if filterTable["damagetype_const"] == DAMAGE_TYPE_MAGICAL then
    		filterTable["damage"] = 0
    	end
    	Arena:RubickBroTakeDamage(attacker, victim)
    end
    if victim:HasModifier("modifier_warlord_ice_shell") then
    	if filterTable["damagetype_const"] == DAMAGE_TYPE_MAGICAL then
    		filterTable["damage"] = 0
    		Filters:WarlordTakeMagicDamage(victim)
    	end
    end
    if victim:HasModifier("modifier_demon_farmer_mark_passive") then
    	if attacker:HasModifier("modifier_demon_farmer_mark_effect") then
    	else
    		filterTable["damage"] = 0
    	end
    end
    if victim:HasModifier("modifier_castle_sorceress_flamespitting") then
    	if filterTable["damage"] > victim:GetMaxHealth()*0.01 then
    		filterTable["damage"] = CustomAbilities:CastleSorceressDamage(victim, filterTable["damage"])
    	end
    end
    if victim:HasModifier("modifier_conquest_boss_ai") then
    	if filterTable["damagetype_const"] == DAMAGE_TYPE_MAGICAL or filterTable["damagetype_const"] == DAMAGE_TYPE_PHYSICAL then
    		filterTable["damage"] = 0
    	end
    end


    if victim:HasModifier("modifier_seinaru_b_c_wakizashi") then
    	filterTable["damage"] = 0
	end
	if damagetype == DAMAGE_TYPE_MAGICAL then
		filterTable["damage"] = filterTable["damage"] * GameState:IncomingDamageDecreaseWithType(victim, attacker, true, DAMAGE_TYPE_MAGICAL)
	elseif damagetype == DAMAGE_TYPE_PHYSICAL then
		filterTable["damage"] = filterTable["damage"] * GameState:IncomingDamageDecreaseWithType(victim, attacker, true, DAMAGE_TYPE_PHYSICAL)
	elseif damagetype == DAMAGE_TYPE_PURE then
		filterTable["damage"] = filterTable["damage"] * GameState:IncomingDamageDecreaseWithType(victim, attacker, true, DAMAGE_TYPE_PURE)
	else
		filterTable["damage"] = filterTable["damage"] * GameState:IncomingDamageDecrease(victim, attacker, true)
	end
	

	if victim:HasModifier("modifier_demon_hunter") then
		filterTable["damage"] = CustomAbilities:ChernobogDemonHunter(victim, filterTable["damage"])
	end

    if victim:HasModifier("modifier_boots_of_ashara") then
    	if filterTable["damage"] <= victim:GetMaxHealth()*0.1 then
    		filterTable["damage"] = filterTable["damage"]*0.1
    		CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/tree_healed_explosion_glow_fb_mid.vpcf", victim, 3)
    	end
    end
    if victim:HasModifier("modifier_hydroxis_mist_debuff") or victim:HasModifier("modifier_hydroxis_mist_debuff_timered") then
    	modifier = victim:FindModifierByName("modifier_hydroxis_mist_debuff")
    	if not modifier then
    		modifier = victim:FindModifierByName("modifier_hydroxis_mist_debuff_timered")
    	end
    	if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
    		local c_b_level = Runes:GetTotalRuneLevelGeneric(attacker, 3, 1)
    		if c_b_level > 0 then
    			mult = mult + 0.06*c_b_level
    		end
    	end
    end
    if attacker:HasModifier("modifier_boss_illusion_ability_effect") then
    	filterTable["damage"] = filterTable["damage"]*0.1
    end
	if victim:HasModifier("modifier_paladin_rune_b_b_shield") then
		local damageAbsorb = math.min(filterTable["damage"], victim.paladin_d_b_absorb)
		victim.paladin_d_b_absorb = victim.paladin_d_b_absorb - damageAbsorb
		if damageAbsorb <= 0 then
			victim:RemoveModifierByName("modifier_paladin_rune_b_b_shield")
		end
		filterTable["damage"] = filterTable["damage"] - damageAbsorb
	end
	if victim:HasModifier("modifier_seinaru_rune_c_b_shield") then
		local damageAbsorb = math.min(filterTable["damage"], victim.seinaru_c_b_absorb)
		victim.seinaru_c_b_absorb = victim.seinaru_c_b_absorb - damageAbsorb
		if damageAbsorb <= 0 then
			victim:RemoveModifierByName("modifier_seinaru_rune_c_b_shield")
		end
		print("damage absorb " .. damageAbsorb)
		filterTable["damage"] = filterTable["damage"] - damageAbsorb
	end
    if victim:HasModifier("modifier_fire_aspect") then
    	if filterTable["damage"] > victim:GetMaxHealth()*0.2 then
    		filterTable["damage"] = victim:GetMaxHealth()*0.2
    	end
    end
    if victim:HasModifier("modifier_fire_spirit_boss_passive") then
    	filterTable["damage"] = filterTable["damage"] * 0.4
    end
    if victim:HasModifier("modifier_serengaard_wave_unit") then
    	if Serengaard.InfiniteWaveCount then
   --  		local flatFactor = math.max(1-(Serengaard.InfiniteWaveCount/10), 0.04)
			-- local damageMult = 1 - (0.1*Serengaard.InfiniteWaveCount/(flatFactor + (0.1 * math.abs(Serengaard.InfiniteWaveCount))))
			-- damageMult = damageMult/3
			local damageMult = 0.92^Serengaard.InfiniteWaveCount
			filterTable["damage"] = filterTable["damage"]*damageMult
		end
    end
    if attacker:HasModifier("modifier_serengaard_wave_unit") then
    	if Serengaard.InfiniteWaveCount then
    		filterTable["damage"] = filterTable["damage"] + filterTable["damage"]*0.12*Serengaard.InfiniteWaveCount
    	end
    end
    if victim:HasModifier("modifier_deity_shadow_shield") then
    	if victim.aspect then
    		filterTable["damage"] = 0
    	end
    end
	if victim:HasModifier("modifier_sea_fortress_ai") then
		local seaFortReduc = 0.0007
		local difficulty = GameState:GetDifficultyFactor()
		if difficulty == 1 then
			seaFortReduc = 0.1
		elseif difficulty == 2 then
			seaFortReduc = 0.05
		end
		filterTable["damage"] = filterTable["damage"]*seaFortReduc
		if victim.reduc then
			filterTable["damage"] = filterTable["damage"]*victim.reduc
		end
	end
	if attacker:HasModifier("modifier_ekkan_dominion_unit") then
		if attacker.hero:HasModifier("modifier_ekkan_immortal_weapon_3") then
			if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
				filterTable["damage"] = filterTable["damage"]*5000
			end
		end
	end
	if not victim:HasModifier("modifier_steadfast") and not victim:HasModifier("modifier_mega_steadfast") and attacker:HasModifier("modifier_neutral_glyph_4_2") then
		filterTable["damage"] = filterTable["damage"] * 0.8
	end
	if victim:HasModifier("modifier_steadfast") then
		local thresholdMult = 1
		if attacker:HasModifier("modifier_neutral_glyph_4_2") then
			thresholdMult = 10
			mult = mult + thresholdMult - 1
			divisor = divisor + thresholdMult - 1
			print("threshold increase")
		end
		if attacker:HasModifier("modifier_slipfinn_passive") then
			local d_c_level = Runes:GetTotalRuneLevelGeneric(attacker, 4, 2)
			local luck = RandomInt(1, 1000)
			if luck < 5*d_c_level then
				thresholdMult = 10000
			end
		end
		if not attacker:HasModifier("modifier_backstab_jumping") then
			filterTable["damage"] = CustomAbilities:Steadfast(filterTable["damage"], victim, thresholdMult)
		end
	end
	if victim:HasModifier("modifier_ancient_steadfast") then
		if not attacker:HasModifier("modifier_backstab_jumping") then
			filterTable["damage"] = CustomAbilities:AncientSteadfast(filterTable["damage"], victim)
		end
	end
	if victim:HasModifier("modifier_mega_steadfast") then
		local thresholdMult = 1
		if attacker:HasModifier("modifier_neutral_glyph_4_2") then
			thresholdMult = 30
			mult = mult + thresholdMult - 1
			divisor = divisor + thresholdMult - 1
		end
		if attacker:HasModifier("modifier_slipfinn_passive") then
			local d_c_level = Runes:GetTotalRuneLevelGeneric(attacker, 4, 2)
			local luck = RandomInt(1, 1000)
			if luck < 5*d_c_level then
				thresholdMult = 10000
			end
		end
		if not attacker:HasModifier("modifier_backstab_jumping") then
			filterTable["damage"] = CustomAbilities:MegaSteadfast(filterTable["damage"], victim, thresholdMult)
		end
	end
	if victim:HasModifier("modifier_exploder_freeze") then
		filterTable["damage"] = filterTable["damage"]*5
	end
	if victim:HasModifier("modifier_zonis_stun_arcana1") then
		if attacker:HasAbility("arkimus_zap_ring") then
			local zapRing = attacker:FindAbilityByName("arkimus_zap_ring")
			mult = mult + zapRing.b_a_level*0.015
		end
	end
	if attacker:HasModifier("modifier_world_tree_effect") then
		mult = mult + 2
	end
	if victim:HasModifier("modifier_arkimus_arcana1_q3") then
		local stacks = victim:GetModifierStackCount("modifier_arkimus_arcana1_q3", victim)
		local reduction = 0.99^stacks
		filterTable["damage"] = filterTable["damage"]*reduction
	end
	if victim:HasModifier("modifier_swamp_lady_shield") or victim:HasModifier("modifier_creature_borrowed_time") then
		local healAmount = filterTable["damage"]
		filterTable["damage"] = 0
		victim:Heal(healAmount, victim)
	end
	if victim:HasModifier("modifier_solar_compression_invisible") then
		modifier = victim:FindModifierByName("modifier_solar_compression_invisible")
		local modifierCaster = modifier:GetCaster()
		local stacks = victim:GetModifierStackCount("modifier_solar_compression_invisible", modifierCaster)
		mult = mult + stacks*0.003
	end
	if victim:HasModifier("modifier_lunar_compression_invisible") then
		modifier = victim:FindModifierByName("modifier_lunar_compression_invisible")
		local modifierCaster = modifier:GetCaster()
		local stacks = victim:GetModifierStackCount("modifier_lunar_compression_invisible", modifierCaster)
		mult = mult + stacks*0.003
	end
	if victim:HasModifier("modifier_in_hydrogen_field") then
		if filterTable["entindex_inflictor_const"] then
			local ability = EntIndexToHScript(filterTable["entindex_inflictor_const"])
			if IsValidEntity(ability) then
				if ability:GetAbilityName() == "sea_fortress_hydrogren_field" then
					filterTable["damage"] = victim:GetMaxHealth()*0.07
				elseif ability:GetAbilityName() == "seafortress_heart_spike" then
					filterTable["damage"] = victim:GetMaxHealth()*0.12
				end
			end
		end
	end
	if victim:HasModifier("modifier_arkimus_glyph_5_a") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			filterTable["damage"] = Filters:ArkimusGlyph5a(victim, filterTable["damage"])
		end
	end
	if attacker:HasModifier("modifier_sea_fortress_ai") then
		filterTable["damage"] = filterTable["damage"]*3
	end
	if attacker:HasModifier("modifier_chernobog_immortal_weapon_2") then
		local missingHealthPercent = math.floor((1-(attacker:GetHealth()/attacker:GetMaxHealth()))*100)
		mult = mult + missingHealthPercent*1.5/100
	end
	--DUSKBRINGER
	if attacker:GetUnitName() == "npc_dota_hero_spirit_breaker" and victim:IsRooted() then
		mult = mult + attacker.d_b_level * 8/100
	end
	modifier = victim:FindModifierByName("modifier_duskbringer_b_d_invisible")
	if modifier then
		local stacks = modifier:GetStackCount()
		mult = mult + stacks*0.01
	end

    if victim:HasModifier('modifier_duskbringer_ghost_form_active') then
        filterTable["damage"] = 0
    end


	--TRAPPER
	modifier = attacker:FindModifierByName("modifier_trapper_d_c_post_amp")
	if modifier then
		local stacks = modifier:GetStackCount()
		mult = mult + stacks*0.1
	end
	if attacker:HasModifier("modifier_trapper_immortal_weapon_2") then
		if victim:HasModifier("modifier_fulminating_burn_effect") or victim:HasModifier("modifier_poison_trap_effect") or victim:HasModifier("modifier_net_trap_netted_effect") or victim:HasModifier("modifier_torrent_trap_slowed_effect") then
			filterTable["damage"] = filterTable["damage"] * 1.3
		end
	end

	modifier = victim:FindModifierByName("modifier_poison_whip")
	if modifier then
		local stacks = modifier:GetStackCount()
		local ability = modifier:GetAbility()
		local a_b_level = ability.a_b_level
		mult = mult + 0.01*a_b_level*stacks
	end

	if attacker:HasModifier("modifier_torrent_trap_immunity") and victim:HasModifier("modifier_trapper_glyph_3_2") then
		filterTable["damage"] = filterTable["damage"]*0.05
	end



	--SEINARU

	modifier = victim:FindModifierByName("modifier_seinaru_rune_a_b_invisible")
	if modifier then
		local stacks = modifier:GetStackCount()
		mult = mult + 0.1/100 * stacks
	end

	--APPLY MULT
	filterTable["damage"] = filterTable["damage"]*mult/divisor
	--FINAL STAGE--


	if attacker:HasModifier("modifier_helm_odin") then
		local proc = Filters:GetProc(attacker, 4)
		if proc then
			filterTable["damage"] = filterTable["damage"] * 20
			PopupOdin(victim, 20)
			CustomAbilities:QuickAttachParticle("particles/roshpit/items/odin_helmet.vpcf", victim, 1.2)
			EmitSoundOnLocationWithCaster(victim:GetAbsOrigin(), "RPCItem.OdinHelmet.Crit", attacker)
		end
	end

	if victim:HasModifier("modifier_canyon_boss_ai") then
		if applyEffects then
			filterTable["damage"] = Redfall:CanyonBossTakeDamage(victim, filterTable["damage"])
		end
	end
	if victim:HasModifier("modifier_conquest_stone_falcon") then
    	if filterTable["damagetype_const"] == DAMAGE_TYPE_MAGICAL or filterTable["damagetype_const"] == DAMAGE_TYPE_PURE then
    		if filterTable["damage"] > victim:GetMaxHealth()*0.35 then
    			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_ambient_end.vpcf", victim, 1.5)
    		end
    		filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth()*0.35)
    	end
	end
	if attacker:HasModifier("modifier_water_temple_bubble_effect") then
		if not attacker:HasModifier("modifier_die_after_time") then
			if Tanari then
				filterTable["damage"] = Tanari:WaterTempleBubble(victim, attacker, filterTable["damage"])
			else
				filterTable["damage"] = CustomAbilities:WaterTempleBubble(victim, attacker, filterTable["damage"])
			end
		end
	end
	if victim:HasModifier("modifier_lava_specter_ai") then
		if applyEffects then
			local luck = RandomInt(1,2)
			if luck == 1 then
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_spectre/spectre_death.vpcf", victim, 1.2)
				filterTable["damage"] = 0
			end
		end
	end

	if victim:HasModifier("modifier_lava_bully_ai") then
		filterTable["damage"] = 0
	end
	if attacker:HasModifier("modifier_fractional_enhancement_geode") then
		filterTable["damage"] = Filters:GeodeDealDamage(victim, filterTable["damage"], attacker)
	end
	if victim:HasModifier("modifier_epoch_arcana_root") then
		local modifier = victim:FindModifierByName("modifier_epoch_arcana_root")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local a_a_level = Runes:GetTotalRuneLevelGeneric(attacker, 1, 0)
			if a_a_level > 0 then
				if attacker:HasAbility("epoch_arcana_ability") then
					attacker:FindAbilityByName("epoch_arcana_ability"):ApplyDataDrivenModifier(attacker, victim, "modifier_epoch_arcana_a_a_effect", {duration = 5})
					local damage = filterTable["damage"]
					filterTable["damage"] = 0
					victim:Heal(damage, attacker)
					if not victim.epochArcanaAA then
						victim.epochArcanaAA = 0
					end
					victim.epochArcanaAA = victim.epochArcanaAA + damage
				end
			end
		end
	end
	if victim:HasModifier("modifier_shipyard_boss_unit") then
		if not Redfall.Shipyard.BossBattleEnd then
			if not attacker:HasModifier("modifier_shipyard_boss_aura_effect") then
				filterTable["damage"] = 0
			end
		end
	end
	if victim:HasModifier("modifier_ankh_of_ancients_shield") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_white_mage_shield") then
		local shieldUsage = math.min(filterTable["damage"], victim.whiteMageShield)
		filterTable["damage"] = filterTable["damage"] - shieldUsage
		victim.whiteMageShield = victim.whiteMageShield - shieldUsage
		if victim.whiteMageShield <= 0 then
			victim:RemoveModifierByName("modifier_white_mage_shield")
		end
	end
	if victim:HasModifier("modifier_reaper_slice_shield") then
		local damageReduce = math.min(filterTable["damage"], victim.scythe_shield_absorb)
		victim.scythe_shield_absorb = victim.scythe_shield_absorb - damageReduce
		if victim.scythe_shield_absorb < 1 then
			victim:RemoveModifierByName("modifier_reaper_slice_shield")
		end
		print("SHIELD ABSORB REMAINING "..victim.scythe_shield_absorb)
		filterTable["damage"] = filterTable["damage"] - damageReduce
	end
	if victim:HasModifier("modifier_perdition_passive") then
		local reductionMult = 0.5
		if GameState:GetDifficultyFactor() == 1 then
			reductionMult = 0
		elseif GameState:GetDifficultyFactor() == 2 then
			reductionMult = 0.2
		end
		local reduction = reductionMult*(3-Redfall.Castle.TorchesLit)
		filterTable["damage"] = math.max(filterTable["damage"]-filterTable["damage"]*reduction, 0)
	end
	if victim:HasModifier("modifier_seven_visions_striking") or victim:HasModifier("modifier_seven_visions_striking_glyphed") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_crimsyth_elite_greaves") then
		CustomAbilities:HitCrimsythElite(victim, attacker, filterTable["damage"])
	end
    if victim:HasModifier("modifier_mystic_mana_wall") then
    	if filterTable["damagetype_const"] == DAMAGE_TYPE_MAGICAL or filterTable["damagetype_const"] == DAMAGE_TYPE_PURE then
    		filterTable["damage"] = Filters:ManawallDamageTaken(victim, filterTable["damage"])
    	end
    end
	if filterTable["entindex_inflictor_const"] then
		local ability = EntIndexToHScript(filterTable["entindex_inflictor_const"])
		if IsValidEntity(ability) then
			if filterTable["damage"] > victim:GetHealth() then
				Filters:AbilityKills(attacker, victim, ability)
			end
		end
	end
	if victim:HasModifier("modifier_alarana_ice_freeze") then
		victim.foot.alaranaIce = victim.foot.alaranaIce - filterTable["damage"]
		filterTable["damage"] = 0
		if victim.foot.alaranaIce <= 0 then
			victim:RemoveModifierByName("modifier_alarana_ice_freeze")
			Filters:AlaranaFrostNova(victim)
		end
	end
	if victim:HasModifier("modifier_frozen_stand") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_shipyard_spawner_passive") then
		filterTable["damage"] = 1
	end
	if victim:HasModifier("modifier_line_tower_passive") then
		if attacker:IsHero() then
			filterTable["damage"] = filterTable["damage"]*0.005
		end
	end
	if victim:HasModifier("modifier_flamewaker_glyph_5_a") then
		if victim:GetUnitName() == "npc_dota_hero_dragon_knight" then
			local thresh = 0.3
			if victim:GetHealth() < victim:GetMaxHealth()*0.5 then
				thresh = 0.15
			end
			if filterTable["damage"] > victim:GetMaxHealth()*thresh then
				filterTable["damage"] = victim:GetMaxHealth()*thresh
			end
		end
    end

    if victim:HasModifier("modifier_centaur_horns") then
        local thresh = 0.15
        if filterTable["damage"] > victim:GetMaxHealth() * thresh then
            filterTable["damage"] = victim:GetMaxHealth() * thresh
        end
    end

	if victim:HasModifier("modifier_djanghor_immortal_weapon_2") then
		if victim:HasModifier("modifier_shapeshift_bear") or victim:HasModifier("modifier_shapeshift_year_beast") then
			if filterTable["damage"] < victim:GetMaxHealth()*100 then
				filterTable["damage"] = math.min(victim:GetMaxHealth()*0.1, filterTable["damage"])
			end
		end
	end
	if victim:HasModifier("modifier_moloth_ai") then
		filterTable["damage"] = CustomAbilities:MolothTakeDamage(victim, damagetype, filterTable["damage"])
	end
	if victim:HasModifier("modifier_disable_player") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_no_damage") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_bahamut_rune_d_d_shell") then
		filterTable["damage"] = 0
	end

	if attacker:HasModifier("modifier_crystalline_slippers") then
		if victim:IsRooted() then
			filterTable["damage"] = filterTable["damage"] * 3
		end
	end

	if victim:HasModifier("modifier_crystalline_slippers") then
		if attacker:IsRooted() then
			filterTable["damage"] = filterTable["damage"]*0.2
		end
	end

	if victim:HasModifier("modifier_armor_of_atlantis") then
		if filterTable["damage"] > victim:GetMaxHealth() then
			filterTable["damage"] = filterTable["damage"] * 0.05
			local pfxA = CustomAbilities:QuickAttachParticle("particles/act_2/ogre_seal_icebreak_flash.vpcf", victim, 0.5)
			ParticleManager:SetParticleControl(pfxA, 1, victim:GetAbsOrigin())
		end
	end
	if attacker:HasModifier("modifier_line_tower_passive") then
		-- filterTable["damage"] = filterTable["damage"]/GameState.PVP_REDUCTION
		if victim:IsHero() then
			filterTable["damage"] = victim:GetMaxHealth()*0.1
		else
			filterTable["damage"] = math.max(filterTable["damage"], victim:GetMaxHealth()*0.1)
		end
	end
	if victim:HasModifier("modifier_serengaard_tower_passive") then
		-- filterTable["damage"] = filterTable["damage"]/GameState.PVP_REDUCTION
	end
	if victim:HasModifier("modifier_line_tower_passive") then
		filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth()*0.08)
	end
	if victim:HasModifier("modifier_serengaard_structure_passive") then
		if victim:GetTeamNumber() == attacker:GetTeamNumber() then
			filterTable["damage"] = 0
		end
	end
	if victim:HasModifier("town_unit") then
		filterTable["damage"] = 0
	end
	--TRAPPER DECOY

	if victim:HasModifier("modifier_decoy_effect") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			filterTable["damage"] = 0
		else
			filterTable["damage"] = 1
		end
    end


	--LETHAL CHECK
	if filterTable["damage"] > victim:GetHealth() then
		if victim:HasModifier("modifier_phoenix_emblem") then
			if victim:HasModifier("modifier_phoenix_rebirthing") then
				filterTable["damage"] = 0
			end
			if not victim:HasModifier("modifier_phoenix_emblem_cooldown") then
				filterTable["damage"] = 0
				Filters:PhoenixEmblem(victim)
			end
		elseif victim:HasModifier("modifier_hailstorm_passive") then
			if not victim:HasModifier("modifier_hailstorm_ice_case_cooldown") then
				local hailstormAbility = victim:FindAbilityByName("mountain_protector_hailstorm")
				local b_d_level = Runes:GetTotalRuneLevelGeneric(victim, 2, 3)
				if b_d_level > 0 then
					hailstormAbility:ApplyDataDrivenModifier(victim, victim, "modifier_frozen_stand", {duration = 6})
					hailstormAbility:ApplyDataDrivenModifier(victim, victim, "modifier_hailstorm_ice_case_cooldown", {duration = 35})
				end
			end
		elseif victim:HasModifier("modifier_ankh_of_the_ancients") then
			if not victim:HasModifier("modifier_ankh_of_ancients_cooldown") then
				filterTable["damage"] = victim:GetHealth() - 2
				victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_ankh_of_ancients_shield", {duration = 6})
				victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_ankh_of_ancients_cooldown", {duration = 24})
				for i = 0, 3, 1 do
					local abilityIndex = i
					if i == 3 then
						abilityIndex = DOTA_ULTIMATE_SLOT
					end
					victim:GetAbilityByIndex(abilityIndex):EndCooldown()
				end
			end		
		elseif victim:HasModifier("modifier_world_trees_flower_cache") then
			print("HAS FLOWER CACHE")
			if not victim:HasModifier("modifier_world_tree_cache_cooldown") then
				filterTable["damage"] = victim:GetHealth() - 2
				print("DO THIS STUFF")
				victim:AddNoDraw()
				victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_world_tree_cache_cooldown", {duration = 15})	
				victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_ankh_of_ancients_shield", {duration = 3})	
				local pfx = ParticleManager:CreateParticle("particles/econ/items/natures_prophet/natures_prophet_weapon_sufferwood/furion_teleport_end_sufferwood.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
				ParticleManager:SetParticleControl(pfx, 0, victim:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx, 4, Vector(300, 0, 0))
				for i = 0, 12, 1 do
					ParticleManager:SetParticleControlEnt(pfx, i, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
				end
				EmitSoundOn("RPCItem.WorldTreeCache.Start", victim)
				Timers:CreateTimer(3, function()
					victim:RemoveNoDraw()
					EmitSoundOn("RPCItem.WorldTreeCache.End", victim)
					victim:SetHealth(victim:GetMaxHealth())
					ParticleManager:DestroyParticle(pfx, false)
					victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_world_tree_effect", {duration = 12})	
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", victim, 1.2)
					local enemies = FindUnitsInRadius( victim:GetTeamNumber(), victim:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
					if #enemies > 0 then
						for _,enemy in pairs(enemies) do
							Filters:ApplyStun(victim, 0.6, enemy)
						end
					end 
				end)
			end
		elseif victim:HasModifier("modifier_solunia_glyph_5_a") then
			if not victim:HasModifier("modifier_solunia_glyph_5_a_cooldown") then
				filterTable["damage"] = victim:GetHealth() - 2
				CustomAbilities:Protostar(victim)
			end
		elseif victim:HasModifier("modifier_paladin_arcana2_passive") then
			local a_c_level = Runes:GetTotalRuneLevelGeneric(victim, 1, 2)
			if a_c_level > 0 then
				if not victim:HasModifier("modifier_paladin_heal_on_lethal_cooldown") then
					local arcanaAbility = victim:FindAbilityByName("paladin_crusader_comet")
					arcanaAbility:ApplyDataDrivenModifier(victim, victim, "modifier_paladin_heal_on_lethal_cooldown", {duration = 5})
					local healAmount = a_c_level * 5000
					local manaRestore = a_c_level * 1000
					EmitSoundOn("Paladin.ArcanaACHeal", victim)
					Filters:ApplyHeal(victim, victim, healAmount, true)
					victim:GiveMana(manaRestore)
					local pfx = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_CUSTOMORIGIN, target )
					ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(pfx, 1, Vector(300,1,300))
					ParticleManager:SetParticleControl(pfx, 2, victim:GetForwardVector())
					Timers:CreateTimer(4, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					end) 	
					filterTable["damage"] =  0
				end
            end
        elseif victim:HasModifier('modifier_duskbringer_ghost_form_checker') then
            local caster = victim:FindModifierByName('modifier_duskbringer_ghost_form_checker'):GetCaster()
			if caster.d_c_level then
                local ability = caster:FindAbilityByName('specter_rush_two')
                ability:ApplyDataDrivenModifier(caster, victim, "modifier_duskbringer_ghost_form_active", {duration = 0.2 * caster.d_c_level})
                CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash_flash.vpcf", victim:GetAbsOrigin()+Vector(0,0,50), 0.4)
                EmitSoundOn("Duskbringer.Wraithform", victim)
				filterTable["damage"] =  0
            end
		end

	end

	if victim:HasModifier("modifier_dummy_active") then
		if attacker == Events.GameMaster then
		else
			local heroOwner = CustomAbilities:getHeroFromUnit(attacker)
			if heroOwner then
				if victim.attackerIndex == attacker:GetEntityIndex() or victim.attackerIndex == heroOwner:GetEntityIndex() then
					local dmgReport = math.floor(filterTable["damage"]/difficultyDamageReduce)
					local element1 = attacker.element1
					local element2 = attacker.element2
					local inflictor = filterTable["entindex_inflictor_const"]
					if not inflictor then
						element1 = RPC_ELEMENT_NONE
						element2 = RPC_ELEMENT_NONE
					end
					CustomGameEventManager:Send_ServerToPlayer(attacker:GetPlayerOwner(), "updateTargetDummy", {dmg = dmgReport, victim = victim:GetEntityIndex(), attacker = attacker:GetEntityIndex(), damagetype = damagetype, element1 = element1, element2 = element2})
					if attacker:HasModifier("modifier_dummy_timer") then
						victim.timerDamage = victim.timerDamage + dmgReport
					end
				end
			end
		end
	end
	local inflictor = filterTable["entindex_inflictor_const"]
	if not applyEffects then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			victim.resist_mag = 1-(filterTable["damage"]/StartingDamage)
		elseif damagetype == DAMAGE_TYPE_PHYSICAL then
			victim.resist_phys = 1-(filterTable["damage"]/StartingDamage)
		elseif damagetype == DAMAGE_TYPE_PURE then
			victim.resist_pure = 1-(filterTable["damage"]/StartingDamage)
		end
		filterTable["damage"] = 0
	end
	-- if attacker:HasModifier("modifier_line_unit_passive") then
	-- 	filterTable["damage"] = filterTable["damage"]/GameState.PVP_REDUCTION
	-- end
	if Beacons.cheats then
		-- if victim:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		-- 	if victim:IsHero() then
		-- 		filterTable["damage"] = 0
		-- 	end
		-- end
		-- if attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		-- 	if attacker:IsHero() then
		-- 		filterTable["damage"] = 0
		-- 	end
		-- end
	end
	
	return true

end
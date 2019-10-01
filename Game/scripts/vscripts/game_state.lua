if GameState == nil then
	GameState = class({})
end

require("/heroes/antimage/arkimus_constants")
require("/heroes/arc_warden/jex_constants")
require("/heroes/axe/red_general_constants")
require("/heroes/beastmaster/warlord_constants")
require("/heroes/crystal_maiden/sorceress_constants")
require("/heroes/dark_seer/zhonik_constants")
require("/heroes/dragon_knight/flamewaker_constants")
require("/heroes/faceless_void/omniro_constants")
require("/heroes/hero_necrolyte/venomort_constants")
require("/heroes/hero_necrolyte/scales")
require("/heroes/huskar/spirit_warrior_constants")
require("/heroes/invoker/constants_CONJUROR")
require("/heroes/juggernaut/seinaru_constants")
require("/heroes/lanaya/trapper_constants")
require("/heroes/legion_commander/mountain_protector_constants")
require("/heroes/leshrac/bahamut_constants")
require("/heroes/monkey_king/djanghor_constants")
require("/heroes/moon_ranger/astral_ranger_constants")
require("/heroes/nightstalker/chernobog_constants")
require("/heroes/obsidian_destroyer/epoch_constants")
require("/heroes/omniknight/paladin_constants")
require("heroes/phantom_assassin/voltex_constants")
require("/heroes/skywrath_mage/sephyr_constants")
require("/heroes/slardar/hydroxis_constants")
require("/heroes/slark/slipfinn_constants")
require("/heroes/spirit_breaker/duskbringer_constants")
require("/heroes/vengeful_spirit/solunia_constants")
require("/heroes/visage/ekkan_constants")
require("/heroes/winter_wyvern/dinath_constants")
require("/heroes/zuus/auriun_constants")

require("/items/constants/boots")
require("/items/constants/chest")
require("/items/constants/gloves")
require("/items/constants/helm")
require("/items/constants/trinket")

require("/worlds/winterblight/constants/enemies_abilities")
require("/worlds/redfall/constants/mithril")
require("/worlds/winterblight/constants/mithril")
require("/worlds/tanari/constants/mithril")
require("/worlds/arena/constants/mithril")
require("/worlds/tutorial/constants/mithril")
require("/worlds/sea_fortress/constants/mithril")
require("/worlds/serengaard/constants/mithril")



VectorTarget:Init({noOrderFilter = true})

GameState.PVP_REDUCTION = 0.01


function OverflowProtectedGetAverageTrueAttackDamage(caster)
	local averageTrueAttackDamage = caster:GetAverageTrueAttackDamage(caster)
	if averageTrueAttackDamage < -2000000000 then
		return 2000000000
	end
	return averageTrueAttackDamage
end

function OverflowProtectedMaxHealingValue(healAmount)
	if healAmount < 0 then
		return 2000000000
	elseif healAmount >= 2000000000 then
		return 2000000000
	else
		return healAmount
	end
end

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
	--print("DIFFICULTY SELECT?")
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
			CustomNetTables:SetTableValue("player_stats", "diff", {difficulty = DIFFICULTY_FACTOR})
			CustomGameEventManager:Send_ServerToAllClients("update_selected_difficulty", {difficulty = DIFFICULTY_FACTOR})
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
	if mapName == "rpc_redfall_ridge_normal" or mapName == "rpc_redfall_ridge_elite" or mapName == "rpc_redfall_ridge_legend" or mapName == "redfall_ridge_work" or mapName == "rpc_redfall_ridge" then
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
	if mapName == "rpc_winterblight_mountain" or mapName == "rpc_winterblight_mountain_work" then
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

function GameState:IsTutorial()
	local mapName = Events.MapName
	if mapName == "rpc_tutorial" then
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
	--print(mapName)
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
	return PlayerResource:HasCustomGameTicketForPlayerID(playerID)
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
	--print(msg.itemIndex)
	item:StartCooldown(6)
end

function GameState:GetDefaultDifficulty()
	local mapName = GetMapName()
	--print("MAP NAME::")
	--print(mapName)
	if mapName == "rpc_roshpit_arena_legend" or mapName == "rpc_roshpit_arena" or mapName == "rpc_sea_fortress" then
		return 3
	else
		return 1
	end
end

function GameState:SetDifficultyFactor()
	CustomNetTables:SetTableValue("player_stats", "diff", {difficulty = DIFFICULTY_FACTOR})
	return DIFFICULTY_FACTOR
	-- local mapName = Events.MapName
	-- if mapName == "rpc_world_1_normal" then
	-- return 1
	-- elseif mapName == "rpc_world_1_elite" then
	-- return 2
	-- elseif mapName == "rpc_world_1_legend" then
	-- return 3
	-- elseif mapName == "rpc_tanari_jungle_normal" then
	-- return 1
	-- elseif mapName == "rpc_tanari_jungle_elite" then
	-- return 2
	-- elseif mapName == "rpc_tanari_jungle_legend" then
	-- return 3
	-- elseif mapName == "rpc_roshpit_arena_legend" then
	-- return 3
	-- elseif mapName == "rpc_test_map" then
	-- return 3
	-- elseif mapName == "rpc_redfall_ridge_normal" then
	-- return 1
	-- elseif mapName == "rpc_redfall_ridge_elite" then
	-- return 2
	-- elseif mapName == "rpc_redfall_ridge_legend" then
	-- return 3
	-- else
	-- return 1
	-- end
	-- local difficultyData = CustomNetTables:GetTableValue("game_state", "difficulty_data")
	----print("---DIFFICULTY DATA---")
	----print(difficultyData)
	----print("^---DIFFICULTY DATA---^")
	-- local difficulty = 1
	-- if difficultyData then
	-- difficulty = difficultyData.difficulty
	-- end
	-- return difficulty
end

function GameState:GetDifficultyFactor()
	return Events.DifficultyFactor
end

function GameState:GetDifficultyName()
	if GameState:GetDifficultyFactor() == DIFFICULTY_NORMAL then
		return "normal"
	elseif GameState:GetDifficultyFactor() == DIFFICULTY_ELITE then
		return "elite"
	elseif GameState:GetDifficultyFactor() == DIFFICULTY_LEGEND then
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
	-- local ent = Entities:FindAllByClassname("npc_dota_creep_lane")
	-- if #ent > 0 then
	-- GameState.cheats = true
	-- --print("CHEATS DETECTED. NO STAT COLLECTION")
	-- UTIL_Remove(ent[1])
	-- end
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
		CreateHTTPRequestScriptVM("POST", url):Send(function(result)
			--print( "POST response:\n" )
			for k, v in pairs(result) do
				--print( string.format( "%s : %s\n", k, v ) )
			end
			--print( "Done." )
		end)
	end
end

function GameState:GetPostReductionPhysicalDamage(damage, armor)
	local damageMult = 1 - (0.05 * armor / (1 + (0.05 * math.abs(armor))))
	local damage = math.ceil(damage * damageMult)
	return damage
end

function GameState:GoldEarnFilter(goldEarnTable)
	----print("MODIFY GOLD?")
	-- DeepPrintTable(goldEarnTable)
	local gold = goldEarnTable["gold"]
	local playerID = goldEarnTable["player_id_const"]
	goldEarnTable["gold"] = 0
	PlayerResource:ModifyGold(playerID, gold, true, 0)
	PlayerResource:SetGold(playerID, 0, false)
	return true
end

function GameState:ModifierGainedFilter(modifierGainedTable)
   -- entindex_parent_const           	= 796 (number)
   -- entindex_ability_const          	= 607 (number)
   -- duration                        	= -1 (number)
   -- entindex_caster_const           	= 606 (number)
   -- name_const                      	= "modifier_name" (string)
	local target = EntIndexToHScript(modifierGainedTable["entindex_parent_const"])
	if target:HasModifier("modifier_radium_spores") then
		local caster = EntIndexToHScript(modifierGainedTable["entindex_caster_const"])
		if modifierGainedTable["entindex_ability_const"] then
			local ability = target:FindModifierByName("modifier_radium_spores"):GetAbility()
			if IsValidEntity(ability) then
				local duration_modifier = ability:GetSpecialValueFor("modifier_duration_reduction")
				local slow_duration = ability:GetSpecialValueFor("slow")
				if target == caster and modifierGainedTable["duration"] > 0 then
					modifierGainedTable["duration"] = modifierGainedTable["duration"]*(1-(duration_modifier/100))
					local modifier_caster = ability:GetCaster()
					ability:ApplyDataDrivenModifier(modifier_caster, target, "radium_spores_slow", {duration = slow_duration})
					EmitSoundOn("Winterblight.RadiumSpores.Trigger", target)
				end
			end
		end
	elseif target:HasModifier("modifier_unshakable") then
		local caster = EntIndexToHScript(modifierGainedTable["entindex_caster_const"])
		if modifierGainedTable["entindex_ability_const"] then
			if target:FindModifierByName("ability_unshakable") then
				local ability = target:FindModifierByName("ability_unshakable"):GetAbility()
				if IsValidEntity(ability) then
					local duration_modifier = ability:GetSpecialValueFor("modifier_duration_reduction")
					if target:GetTeamNumber() ~= caster:GetTeamNumber() and modifierGainedTable["duration"] > 0 then
						modifierGainedTable["duration"] = modifierGainedTable["duration"]*(1-(duration_modifier/100))
					end
				end
			end
		end	
	elseif target:HasModifier("modifier_goldbreaker_effect") then
		local modifierName = modifierGainedTable["name_const"]
		local magic_immune_names = Filters:GetMagicImmuneModifierNames()
		if WallPhysics:DoesTableHaveValue(magic_immune_names, modifierName) then
			local hero = EntIndexToHScript(modifierGainedTable["entindex_caster_const"])
			CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/antimage_manavoid_ti_5_gold.vpcf", target, 3)
			Filters:ApplyStun(hero, modifierGainedTable["duration"], target)
			EmitSoundOn("RPC.MagicImmuneBreakTarget", target)
			return false
		end
	elseif target:HasModifier("modifier_guadian_stone") then
		local caster = EntIndexToHScript(modifierGainedTable["entindex_caster_const"])
		if modifierGainedTable["entindex_ability_const"] then
			local duration_modifier = GUARDIAN_STONE_DEBUFF_REDUCTION_PCT
			if target:GetTeamNumber() ~= caster:GetTeamNumber() and modifierGainedTable["duration"] > 0 then
				modifierGainedTable["duration"] = modifierGainedTable["duration"]*(1-(duration_modifier/100))
				local heal = target:GetMaxHealth()*(GUARDIAN_STONE_HEAL_PCT/100)
				CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/mark_of_the_talon_heal.vpcf", target, 1)
				Filters:ApplyHeal(target, target, heal, true, true)
				EmitSoundOn("Items.GuardianStone.Trigger", target)
			end
		end			
	end
   return true
end

function GameState:AbilityTuningValueFilter(abilityTuneTable)
   -- value                           	= 300 (number)
   -- entindex_ability_const          	= 821 (number)
   -- value_name_const                	= "attack_damage_base" (string)
   -- entindex_caster_const           	= 820 (number)
	return true
end

function GameState:OrderFilter(orderTable)
	local unitNumber = -1
	for _, unitNum in pairs(orderTable.units) do
		unitNumber = unitNum
		break
	end
	-- for k,v in pairs(orderTable) do
	-- --print("K:",k,"V:",v)
	-- end
	-- DeepPrintTable(orderTable)
	local unit = EntIndexToHScript(unitNumber)
	if IsValidEntity(unit) and not unit:IsChanneling() then
		if orderTable.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET and orderTable.entindex_ability and EntIndexToHScript(orderTable.entindex_ability):IsItem() and unit.cant_use_items then
			return false
		end
		if GameState:IsWinterblight() then
			if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and EntIndexToHScript(orderTable.entindex_target).prop_id and EntIndexToHScript(orderTable.entindex_target).prop_id == 2 then
				unit.Attacking_a_Cup = true
			else
				unit.Attacking_a_Cup = false
			end
		end
		Util.Modifier:SimpleEvent(unit, 'OnOrderFilter', { MODIFIER_SPECIAL_TYPE_ORDER_FILTER }, orderTable, nil)
		if unit:HasModifier("modifier_neptunes_water_gliders") then
			unit.lastOrder = orderTable.order_type
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				if unit:IsStunned() or unit:IsRooted() or unit:IsFrozen() then
				else
					unit.foot:ApplyDataDrivenModifier(unit.InventoryUnit, unit, "modifier_neptune_gliding_new", {duration = 20})
					unit.foot.slideSpeed = 8
					unit.foot.movementPosition = Vector(orderTable.position_x, orderTable.position_y)
					local movementForward = ((unit.foot.movementPosition - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
					unit.foot.movementForward = movementForward
				end
			end
		end
		if unit:HasModifier("modifier_pivotal_swiftboots") then
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				if unit:IsStunned() or unit:IsFrozen() then
				else
					local movePos = Vector(orderTable.position_x, orderTable.position_y)
					local currentPos = unit:GetAbsOrigin()
					local fv = ((movePos - currentPos)*Vector(1,1,0)):Normalized()

					local current_fv = unit:GetForwardVector()
					local angle_between = WallPhysics:angle_between_vectors(current_fv, fv)
					print(angle_between)
					if angle_between >= 160 and angle_between <= 200 then
						CustomAbilities:QuickParticleAtPoint("particles/econ/items/rubick/rubick_force_gold_ambient/rubick_telekinesis_land_force_gold.vpcf", unit:GetAbsOrigin(), 3)
						unit.foot:ApplyDataDrivenModifier(unit.InventoryUnit, unit, "modifier_pivotal_swiftboots_speed_decay", {duration = PIVOT_BURST_DURATION})
						unit:SetModifierStackCount("modifier_pivotal_swiftboots_speed_decay", unit.InventoryUnit, PIVOT_BOOT_MS)
						unit:AddNewModifier(unit, nil, 'modifier_pivotal_swift', {duration = 4})
						EmitSoundOn("Items.PivotalSwift", unit)
					end
					unit:SetForwardVector(fv)
				end
			end
		end
		if unit:GetUnitName() == "npc_dota_hero_arc_warden" then
			if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
				if orderTable.entindex_target then
					local target = EntIndexToHScript(orderTable.entindex_target)
					if target:GetClassname() ~= "dota_item_drop" then
						if target:GetUnitName() == "jex_thunder_blossom" then
							local teleport_ability = target:FindAbilityByName("thunder_blossom_teleport")
							if teleport_ability:IsFullyCastable() then
								local order = {
									UnitIndex = target:entindex(),
									OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
									TargetIndex = unit:entindex(),
									AbilityIndex = teleport_ability:entindex(),
								}
								ExecuteOrderFromTable(order)
							end
						end
					end
				end
			end
		end
		if unit:HasModifier("modifier_nethergrasp_palisade") then
			if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
				if orderTable.entindex_target then
					local target = EntIndexToHScript(orderTable.entindex_target)
					if target:GetClassname() ~= "dota_item_drop" then
						Filters:NetergraspPalisade(unit, target)
					end
				end
			end
		end
		if unit:HasModifier("modifier_jex_portal_aura_inside") then
			if unit:HasModifier("modifier_jex_portal_aura_inside") then
				if not unit:HasModifier("modifier_jex_portal_teleporting") then
					--print("RDG")
					local portal_caster = unit:FindModifierByName("modifier_jex_portal_aura_inside"):GetAbility():GetCaster()
					local ability = portal_caster:FindAbilityByName("jex_nature_cosmic_e")
					if portal_caster:HasModifier("modifier_jex_glyph_2_1") or portal_caster:GetEntityIndex() == unit:GetEntityIndex() then
						local movementPosition = Vector(orderTable.position_x, orderTable.position_y)
						local portal = false
						for i = 1, #ability.portalTable, 1 do
							local distance = WallPhysics:GetDistance2d(ability.portalTable[i].position, movementPosition)
							local self_distance = WallPhysics:GetDistance2d(ability.portalTable[i].position, unit:GetAbsOrigin())
							if distance <= 300 and self_distance > 500 then
								portal = ability.portalTable[i]
								break
							end
						end
						if portal then
							ability:ApplyDataDrivenModifier(unit, unit, "modifier_jex_portal_teleporting", {duration = 6})
							ability.teleporting_to = movementPosition
							EmitSoundOn("Jex.EarthsGate.Portal", unit)
							EmitSoundOnLocationWithCaster(ability.teleporting_to, "Jex.EarthsGate.Portal", caster)
							unit:Stop()
							unit:AddNewModifier(unit, nil, "modifier_black_portal_shrink", {duration = 6})
							return false
						end
					end
				end
			end
		end
		if unit:HasModifier("modifier_terrorize_thinking") then
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				unit:RemoveModifierByName("modifier_terrorize_thinking")
			end
		end
		if unit:GetUnitName() == "npc_dota_hero_winter_wyvern" then
			unit.lastOrder = orderTable.order_type
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				require('heroes/winter_wyvern/burning_charge')
				if unit:HasAbility("dinath_scorch_charge") then
					local scorch_charge_ability = unit:FindAbilityByName("dinath_scorch_charge")
					if scorch_charge_ability:IsCooldownReady() then
						if unit:IsStunned() or unit:IsRooted() or unit:IsFrozen() then
						else
							local eventTable = {}
							eventTable.caster = unit
							eventTable.ability = scorch_charge_ability
							eventTable.target_points = {}
							eventTable.target_points[1] = Vector(orderTable.position_x, orderTable.position_y)
							unit:SetForwardVector(WallPhysics:normalized_2d_vector(unit:GetAbsOrigin(), eventTable.target_points[1]))
							burning_charge_start(eventTable)
							scorch_charge_ability:StartCooldown(scorch_charge_ability:GetCooldown(scorch_charge_ability:GetLevel()))
							return false
						end
					end
				end
			end
		end
		if unit:HasModifier("modifier_astral_arcana_on_platform") then
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
				if unit:FindAbilityByName("astral_arcana_ability") then
					CustomAbilities:AstralArcanaCloudMove({caster = unit, ability = unit:FindAbilityByName("astral_arcana_ability")})
				else
					unit:RemoveModifierByName("modifier_astral_arcana_on_platform")
				end
			end
		end
		if unit:HasModifier("modifier_confusional_spores") or unit:HasModifier("modifier_shroom_procure_aura") then
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
				local target_point = Vector(orderTable.position_x, orderTable.position_y)
				local distance = WallPhysics:GetDistance2d(unit:GetAbsOrigin(), target_point)
				local forward_vector = ((target_point - unit:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				local newPos = unit:GetAbsOrigin() - forward_vector*distance
				orderTable.position_x = newPos.x
				orderTable.position_y = newPos.y
			end
		end
		if unit:HasModifier("modifier_stormcloth_bracer") then
			--print(orderTable.order_type)
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then

				local targetVector = Vector(0, 0)
				if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
					targetVector = Vector(orderTable.position_x, orderTable.position_y)
				elseif orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
					local moreTarget = EntIndexToHScript(orderTable.entindex_target)
					targetVector = moreTarget:GetAbsOrigin()
				end
				if not unit:HasModifier("modifier_stormcloth_bracer_cooldown") and unit:IsAlive() then
					if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
						targetVector = Vector(EntIndexToHScript(orderTable.entindex_target):GetAbsOrigin().x, EntIndexToHScript(orderTable.entindex_target):GetAbsOrigin().y)
					end
					local allies = FindUnitsInRadius(unit:GetTeamNumber(), targetVector, nil, 150, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)

					if #allies > 0 then
						local particleName = "particles/roshpit/items/stormcloth_bolt.vpcf"
						local targetUnit
						for _, ally in pairs(allies) do
							if ally ~= unit then
								targetUnit = ally
								break
							end
						end
						if targetUnit then
							StartAnimation(unit, {duration = 0.6, activity = ACT_DOTA_VERSUS, rate = 5.0})
							local itemAbility = unit:FindModifierByName('modifier_stormcloth_bracer'):GetAbility()
							CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/stormcloth_start.vpcf", unit:GetAbsOrigin(), 3)

							itemAbility:ApplyDataDrivenModifier(unit, unit, "modifier_stormcloth_bracer_cooldown", {duration = STORMCLOTH_COOLDOWN})
							itemAbility:ApplyDataDrivenModifier(unit, unit, "modifier_stormcloth_falling", {duration = 1})
							local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, unit)
							ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin())
							ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))

							StartSoundEvent("RPCItems.Stormcloth.Start", unit)
							unit:SetAbsOrigin(targetUnit:GetAbsOrigin() + Vector(0, 0, 1000))
							Timers:CreateTimer(0.8, function()
								ParticleManager:DestroyParticle(pfx, false)
							end)
						end
					end
				end
			end

		end
		if unit:HasModifier("modifier_ice_floe_slippers") then
			if not unit.ice_floe_table then
				unit.ice_floe_table = {}
			end
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				if unit.ice_floe_table.last_clicked then
					if unit:IsStunned() or unit:IsRooted() or unit:IsFrozen() then
					else
						if (GameRules:GetGameTime() - unit.ice_floe_table.last_clicked < 0.3) and (WallPhysics:GetDistance2d(unit.ice_floe_table.last_position, Vector(orderTable.position_x, orderTable.position_y)) < 200) and (WallPhysics:GetDistance2d(unit:GetAbsOrigin(), Vector(orderTable.position_x, orderTable.position_y)) < ICE_FLOE_TRAVEL_DISTANCE) then
							unit.foot:ApplyDataDrivenModifier(unit.InventoryUnit, unit, "modifier_ice_floe_sliding", {duration = 2})
							unit.ice_floe_table.last_clicked = GameRules:GetGameTime()
							unit.ice_floe_table.last_position = Vector(orderTable.position_x, orderTable.position_y)
							unit.ice_floe_table.speed = 50
							EmitSoundOn("RPCItems.IceFloeSlipper.Go", unit)
							StartAnimation(unit, {duration = 1, activity = ACT_DOTA_VERSUS, rate = 2})
							local pfxTest = ParticleManager:CreateParticle("particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
							local moveFV = ((unit.ice_floe_table.last_position - unit:GetAbsOrigin()) * Vector(1, 1, 1)):Normalized()
							local distance = WallPhysics:GetDistance2d(unit:GetAbsOrigin(), unit.ice_floe_table.last_position)
							ParticleManager:SetParticleControl(pfxTest, 0, unit:GetAbsOrigin())
							ParticleManager:SetParticleControl(pfxTest, 1, unit:GetAbsOrigin() + moveFV * distance)
							ParticleManager:SetParticleControl(pfxTest, 2, Vector(1, 1, 1))
							ParticleManager:SetParticleControlEnt(pfxTest, 9, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
							Timers:CreateTimer(1.5, function()
								ParticleManager:DestroyParticle(pfxTest, false)
							end)
						end
					end
				end
				if unit:IsStunned() or unit:IsRooted() or unit:IsFrozen() then
				else
					unit.ice_floe_table.last_clicked = GameRules:GetGameTime()
					unit.ice_floe_table.last_position = Vector(orderTable.position_x, orderTable.position_y)
				end
			end
		end
		if unit:HasModifier("modifier_slipfinn_bog_roller") then
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				local clicked_position = Vector(orderTable.position_x, orderTable.position_y)
				local bog_roller = unit:FindAbilityByName("slipfinn_bog_roller")
				bog_roller.fv = ((clicked_position - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				return false
			end
		end
		if unit:HasModifier("modifier_frostmaw_hunters_hood") then
			if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
				local target = EntIndexToHScript(orderTable.entindex_target)
				if target.frostmaw then
					target:ForceKill(false)
				end
			end
		end
		if unit:HasModifier("modifier_chernobog_demon_flight_attack") then
			if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
				unit.flight_target = EntIndexToHScript(orderTable.entindex_target)
			end
		end
		if unit:HasModifier("modifier_strafe_toggle") then
			unit.lastOrder = orderTable.order_type
			-- DeepPrintTable(orderTable)
			if orderTable.entindex_ability > 0 then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "sephyr_lightbomb" and unit:HasModifier("modifier_strafe_toggle") then
						local fv = ((Vector(orderTable.position_x, orderTable.position_y) - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
						local strafe = unit:FindAbilityByName("sephyr_strafe")
						local lightbomb = unit:FindAbilityByName("sephyr_lightbomb")
						lightbomb.rotation = AngleDiff(WallPhysics:vectorToAngle(fv), WallPhysics:vectorToAngle(strafe.fvLock))
						lightbomb.ogFV = strafe.fvLock
						-- strafe.fvLock = fv
						unit:SetForwardVector(fv)

					end
				end
			end
			if orderTable.order_type == DOTA_UNIT_ORDER_DROP_ITEM or orderTable.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
				-- local strafe = unit:FindAbilityByName("sephyr_strafe")
				-- strafe:ToggleAbility()
				return false
			end
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
				if unit:IsStunned() or unit:IsRooted() or unit:IsFrozen() or unit:HasModifier("modifier_strafe_cooldown") or unit:HasModifier("modifier_strafe_sprinting") then
					local strafe = unit:FindAbilityByName("sephyr_strafe")
					strafe:ApplyDataDrivenModifier(unit, unit, "modifier_strafe_dont_twist", {duration = 0.5})
					--print("MOVE FORWARD")
					-- Timers:CreateTimer(0.03, function()
					-- unit:MoveToPosition(unit:GetAbsOrigin()+strafe.fvLock*2)
					-- end)
				else
					local strafe = unit:FindAbilityByName("sephyr_strafe")
					local movementPosition = Vector(orderTable.position_x, orderTable.position_y)
					if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
						if unit:GetRuneValue("e", 1) > 0 then
							local targetEnemy = EntIndexToHScript(orderTable.entindex_target)
							if targetEnemy:GetClassname() == "dota_item_drop" then
								return false
							end
							if targetEnemy:GetTeamNumber() == unit:GetTeamNumber() then
								return false
							end
							movementPosition = unit:GetAbsOrigin() + (((unit:GetAbsOrigin() - targetEnemy:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()) * 300
							local distanceBoomerang = WallPhysics:GetDistance(unit:GetAbsOrigin(), targetEnemy:GetAbsOrigin())
							local cast_range = 1200
							if unit:HasModifier("modifier_vermillion_dream_robes") then
								cast_range = cast_range + 420
							end
							if distanceBoomerang <= cast_range then
								if CustomAbilities:SephyrBoomerang(unit, strafe, targetEnemy, false) then
								else
								end
							else
								return false
							end
						else
							return false
						end
					end
					if orderTable.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
						movementPosition = EntIndexToHScript(orderTable.entindex_target):GetAbsOrigin()
					end
					local moveDirection = ((movementPosition - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
					local distance = WallPhysics:GetDistance2d(movementPosition, unit:GetAbsOrigin())
					if distance > 120 then
						local abilityDistance = math.min(distance, strafe:GetLevelSpecialValueFor("max_distance", strafe:GetLevel()))
						--print(abilityDistance)
						local e_4_level = unit:GetRuneValue("e", 4)
						if e_4_level > 0 then
							abilityDistance = abilityDistance + e_4_level * SEPHYR_E4_STRAFE_DISTANCE
						end
						strafe.e_4_level = e_4_level
						local manaReduce = strafe:GetLevelSpecialValueFor("mana_percent_use", strafe:GetLevel()) / 100
						unit:ReduceMana(unit:GetMaxMana() * manaReduce)
						strafe:ApplyDataDrivenModifier(unit, unit, "modifier_strafe_sprinting", {duration = 3})
						strafe.fv = moveDirection
						strafe.targetPoint = unit:GetAbsOrigin() + abilityDistance * moveDirection
						strafe.distance = abilityDistance
						strafe.origDistance = abilityDistance
						strafe.canAnimate = true
						if not unit.animLock then
							StartAnimation(unit, {duration = 1.0, activity = ACT_DOTA_TELEPORT_END, rate = 0.9})
						end
						local cooldown = 0.75
						strafe:ApplyDataDrivenModifier(unit, unit, "modifier_strafe_cooldown", {duration = cooldown})
						local pfx = ParticleManager:CreateParticle("particles/roshpit/sephyr/strafe_wind.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin() + Vector(0, 0, 80) - strafe.fv * 200)
						ParticleManager:SetParticleControl(pfx, 1, strafe.fv)
						ParticleManager:SetParticleControl(pfx, 3, unit:GetAbsOrigin() + strafe.fv * 1000)
						local time = strafe.distance / 1200
						Timers:CreateTimer(time, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
						unit:MoveToPosition(unit:GetAbsOrigin() + strafe.fvLock * 1)
						EmitSoundOnLocationWithCaster(movementPosition, "Sephyr.Strafe.Gust", unit)
						local luck = RandomInt(1, 5)
						if luck == 1 then
							if not unit.voLock then
								EmitSoundOn("Sephyr.PiercingGale.VO", unit)
							end
						end
						Filters:CastSkillArguments(3, unit)
						-- if unit:HasAbility("sephyr_lightbomb") then
						-- local lightbomb = unit:FindAbilityByName("sephyr_lightbomb")
						-- lightbomb:SetActivated(false)
						-- end
					else
						strafe:ApplyDataDrivenModifier(unit, unit, "modifier_strafe_dont_twist", {duration = 0.5})
					end
				end
				return false
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
							local clampDistance = ability.q_4_level * 10 + 400
							local distance = math.min(WallPhysics:GetDistance2d(Vector(orderTable.position_x, orderTable.position_y), unit:GetAbsOrigin()), clampDistance)
							--print("AHOLA1")
							--print(Vector(orderTable.position_x, orderTable.position_y))
							local teleportDirection = ((Vector(orderTable.position_x, orderTable.position_y) - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
							--print(teleportDirection)
							--print(distance)
							--print(teleportDirection*distance)
							--print("ALOHA2")
							local position2 = WallPhysics:WallSearch(unit:GetAbsOrigin(), unit:GetAbsOrigin() + teleportDirection * distance, unit)
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
		if unit:HasModifier("modifier_ice_sliding") then
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
				unit.iceRightClickPos = Vector(orderTable.position_x, orderTable.position_y)
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
					local addDirection = ((unit.rightClickPos - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
					unit.direction = (unit.direction * Vector(1, 1, 0) + addDirection * 0.00001):Normalized()
					if unit.speed < 8 then
						unit.speed = math.max(1, unit.speed + 1)
						unit.direction = unit:GetForwardVector()
					end
				end
			end
			if orderTable.entindex_ability > 0 then
				-- local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				-- if IsValidEntity(orderAbility) then
				-- if orderAbility:GetAbilityName() == "slipfinn_bubble_possession" then
				-- local enemy = EntIndexToHScript(orderTable.entindex_target)
				-- if IsValidEntity(enemy) then
				-- if not enemy.dominion then
				-- unit:Stop()
				-- Notifications:Top(unit:GetPlayerOwnerID(), {text="slipfinn_possession_warning", duration=5, style={color="#FF1111"}, continue=true})
				-- return false
				-- end
				-- end
				-- end
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
					local w_3_level = unit:GetRuneValue("w", 3)

					if w_3_level > 0 and unit:HasModifier("modifier_arkimus_storm_weapon") then
						local enemy = EntIndexToHScript(orderTable.entindex_target)
						if IsValidEntity(enemy) then
							if orderTable.entindex_target == 0 then
							else
								local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), unit:GetAbsOrigin())
								if distance >= 400 then
									--DeepPrintTable(orderTable)
									if enemy.dummy then
									elseif enemy:GetClassname() == "dota_item_drop" then
									elseif enemy:GetTeamNumber() == unit:GetTeamNumber() then
									else
										CustomAbilities:ArkimusSpeedDash(unit, enemy, ability, w_3_level)
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
						if distance > 2000 then
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
					if distance > 2000 then
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
		if GameState:IsPVPAlpha() then
			if unit:GetUnitName() == "rpc_pvp_tanari_builder" then
				--DeepPrintTable(orderTable)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(orderTable.issuer_player_id_const), "openBuilderMenu", {})
			end
		end
		if unit:HasModifier("modifier_venomort_arcana2") then
			local ability = unit:FindAbilityByName("venomort_frostvenom_grasp")
			if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
				ability.Q2Toggle = true
			end
			if orderTable.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
				ability.Q2Toggle = false
			end
		end
		if unit:HasModifier("modifier_flamewaker_arcana1") and orderTable.order_type ~= DOTA_UNIT_ORDER_CAST_POSITION then
			local ability = unit:FindAbilityByName("flamewaker_arcana_ability")
			if not ability:IsInAbilityPhase() then
				if orderTable.entindex_ability then
					if EntIndexToHScript(orderTable.entindex_ability):GetName() == "flamewaker_arcana_ability" then
					else
						ability.PointTable = nil
					end
				else
					ability.PointTable = nil
				end
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
			if unit:HasModifier("modifier_distance_cap_effect") then
				if orderTable.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
					local target_point = Vector(orderTable.position_x, orderTable.position_y)
					local distance = WallPhysics:GetDistance2d(unit:GetAbsOrigin(), target_point)
					local forward_vector = ((target_point - unit:GetAbsOrigin())*Vector(1,1,0)):Normalized()
					local newPos = target_point
					if distance > 400 then
						newPos = unit:GetAbsOrigin() + forward_vector*400
					end
					orderTable.position_x = newPos.x
					orderTable.position_y = newPos.y
				end
			end
			if unit:GetUnitName() == "npc_dota_hero_beastmaster" then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "axe_throw_earth" or orderAbility:GetAbilityName() == "axe_throw_ice" or orderAbility:GetAbilityName() == "axe_throw_fire" then
						if unit:HasModifier("modifier_warlord_ice_sprint") or unit:HasModifier("modifier_warlord_jumping") or unit:HasModifier("modifier_warlord_jumping_fire") then
							local fv = unit:GetForwardVector()
							local targetDirection = ((Vector(orderTable.position_x, orderTable.position_y) - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
							unit:SetForwardVector(targetDirection)
							local axeThrow = orderAbility
							axeThrow.castPoint = axeThrow:GetCastPoint()
							axeThrow:SetOverrideCastPoint(0)
							Timers:CreateTimer(0.03, function()
								unit:SetForwardVector(fv)
								axeThrow:SetOverrideCastPoint(axeThrow.castPoint)
							end)
						end
					end
				end
			end
			if unit:GetUnitName() == "npc_dota_hero_vengeful_spirit" then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "solunia_warp_flare" or orderAbility:GetAbilityName() == "solunia_lunar_warp_flare" then
						if unit:HasModifier("modifier_solunia_flare_flying") or unit:HasModifier("modifier_solunia_in_between_flare") then
							local fv = unit:GetForwardVector()
							local targetDirection = ((Vector(orderTable.position_x, orderTable.position_y) - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
							unit:SetForwardVector(targetDirection)
							local warp_flare = orderAbility
							warp_flare.castPoint = warp_flare:GetCastPoint()
							warp_flare:SetOverrideCastPoint(0)
							Timers:CreateTimer(0.03, function()
								warp_flare:SetOverrideCastPoint(warp_flare.castPoint)
							end)
						end
					end
				end
			end
			if unit:GetUnitName() == "npc_dota_hero_juggernaut" then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "seinaru_blade_dash" then
						--print("IGNORE CAST ANGLE!!!")
						orderAbility:ApplyDataDrivenModifier(unit, unit, "modifier_seinaru_ignore_cast_angle", {duration = 0.5})
					end
				end
			end
			if unit:GetUnitName() == "shadow_deity" then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "shadow_deity_shadow_essence" then
						local target = EntIndexToHScript(orderTable.entindex_target)
						if target == unit.conjuror then
						else
							return false
						end
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
									Notifications:Top(unit:GetPlayerOwnerID(), {text = "notification_no_dominion", duration = 5, style = {color = "#FF1111"}, continue = true})
									return false
								end
							else
								if not enemy.dominion then
									unit:Stop()
									Notifications:Top(unit:GetPlayerOwnerID(), {text = "notification_no_dominion", duration = 5, style = {color = "#FF1111"}, continue = true})
									return false
								end
							end
						end
					end
					-- if orderAbility:GetAbilityName() == "ekkan_summon_skeleton" then
					-- local enemy = EntIndexToHScript(orderTable.entindex_target)
					-- if IsValidEntity(enemy) then
					-- --print(enemy:GetUnitName())
					-- if enemy.disable then
					-- return false
					-- end
					-- if enemy:GetUnitName() == "ekkan_corpse" then
					-- else
					-- unit:Stop()
					-- Notifications:Top(unit:GetPlayerOwnerID(), {text="notification_raise_skeleton_fail", duration=5, style={color="#FF1111"}, continue=true})
					-- return false
					-- end
					-- else
					-- return false
					-- end
					-- end
					if orderAbility:GetAbilityName() == "ekkan_river_of_souls" then
						--DeepPrintTable(orderTable)
						unit.corpseExplosionIndex = 0
						if orderTable.entindex_target > 0 then
							local e_1_level = unit:GetRuneValue("e", 1)
							if e_1_level < 1 then
								unit:Stop()
								Notifications:Top(unit:GetPlayerOwnerID(), {text = "notification_river_no_explosion", duration = 5, style = {color = "#FF1111"}, continue = true})
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
									Notifications:Top(unit:GetPlayerOwnerID(), {text = "notification_raise_skeleton_fail", duration = 5, style = {color = "#FF1111"}, continue = true})
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
									Notifications:Top(unit:GetPlayerOwnerID(), {text = "notification_supercharge_fail", duration = 5, style = {color = "#FF1111"}, continue = true})
									return false
								end
							else
								if ally:GetUnitName() == "ekkan_corpse" then
									local r_3_level = unit:GetRuneValue("r", 3)
									if r_3_level < 1 then
										unit:Stop()
										Notifications:Top(unit:GetPlayerOwnerID(), {text = "notification_supercharge_no_corpse_charge", duration = 5, style = {color = "#FF1111"}, continue = true})
										return false
									end
								else
									local r_2_level = unit:GetRuneValue("r", 2)
									if r_2_level < 1 then
										unit:Stop()
										Notifications:Top(unit:GetPlayerOwnerID(), {text = "notification_supercharge_no_swarm", duration = 5, style = {color = "#FF1111"}, continue = true})
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
	if orderTable.entindex_ability > 0 then
		if IsValidEntity(unit) then
			if unit:GetUnitName() == "npc_dota_hero_arc_warden" then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "jex_fire_fire_e" then
						return VectorTarget:OrderFilter(orderTable)
					else
						return true
					end
				else
					return true
				end
			elseif unit:HasModifier("modifier_warlord_arcana2") then
				local orderAbility = EntIndexToHScript(orderTable.entindex_ability)
				if IsValidEntity(orderAbility) then
					if orderAbility:GetAbilityName() == "warlord_cataclysm_shaker" then
						return VectorTarget:OrderFilter(orderTable)
					else
						return true
					end
				else
					return true
				end
			else
				return true
			end
		else
			return true
		end
	else
		return true
	end
	-- return true

end

function GameState:GetInputDamageMultDecrease(attacker, shouldConsumeShield)
	local baseMult = 1

end

function GameState:IncomingDamageDecreaseWithType(victim, attacker, shouldConsumeShields, damagetype)
	local BASE_VALUE_FOR_CALCULATE = 1000000
	local damage = BASE_VALUE_FOR_CALCULATE
	if damagetype == DAMAGE_TYPE_PHYSICAL then
		if victim:HasModifier("modifier_stormshield_cloak") then
			damage = damage * STORMSHIELD_PHYS_REDUCTION
		end
		if victim:HasModifier("modifier_bahamut_glyph_1_1") then
			damage = damage * 0.7
		end
		if victim:HasModifier("modifier_pure_resist") then
			damage = damage * 6
		end
		if victim:HasModifier("modifier_ice_floe_sliding") then
			damage = 0
		end
	elseif damagetype == DAMAGE_TYPE_MAGICAL then
		if victim:HasModifier("modifier_starseeker_passive") then
			damage = 0
		end
	elseif damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_sparkling_token_of_oceanis") then
			damage = damage * (100 - SPARKLING_TOKEN_PURE_DMG_REDUCTION)/100
		end
		if victim:HasModifier("modifier_sunstrider_lightsworn") then
			damage = damage * (1 - SEINARU_ARCANA_E2_PURE_DMG_REDUCE)
		end
		if victim:HasModifier("modifier_blue_gargoyle_passive") then
			local modifier = victim:FindModifierByName("modifier_blue_gargoyle_passive")
			local passiveAbility = modifier:GetAbility()
			local reduction = passiveAbility:GetLevelSpecialValueFor("pure_resist", passiveAbility:GetLevel())
			reduction = (100 - reduction) / 100
			damage = damage * reduction
		end
		if victim:HasModifier("modifier_hope_of_saytaru_effect") then
			damage = (1 - SAYTARU_PURE_DMG_RESISTANCE) * damage
		end
	end
	if damagetype == DAMAGE_TYPE_PHYSICAL or damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_draghor_shapeshift_bear_lua") then
			damage = damage * 0.7
		end
	end
	if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_lightning_dash") then
			local dash = victim:FindAbilityByName("voltex_lightning_dash")
			if dash then
				local reduction = (100 - dash:GetSpecialValueFor("damage_reduction_percent")) / 100
				damage = damage * reduction
			end
		end
		if victim:HasModifier("modifier_duskbringer_arcana_rune_w_2") then
			local stackCount = victim:GetModifierStackCount("modifier_duskbringer_arcana_rune_w_2", victim)
			local consideredArmor = victim:GetPhysicalArmorValue(false) * DUSKBRINGER_ARCANA_W2_MAGIC_PURE_RES_PER_ARMOR * stackCount
			damage = GameState:GetPostReductionPhysicalDamage(damage, consideredArmor)
		end
		if victim:HasModifier("modifier_pure_resist") then
			local damageReduc = victim:FindModifierByName("modifier_pure_resist"):GetAbility():GetSpecialValueFor("pure_resist")
			damageReduc = 1 - (damageReduc / 100)
			damage = damage * damageReduc
		end
		if victim:HasModifier("modifier_slipfinn_prone") then
			local damageReduc = victim:FindModifierByName("modifier_slipfinn_prone"):GetAbility():GetSpecialValueFor("magic_pure_resist")
			damageReduc = 1 - (damageReduc / 100)
			damage = damage * damageReduc
		end
		if victim:HasModifier("modifier_draghor_shapeshift_cat_lua") then
			damage = damage * 0.3
		end
		if victim:HasModifier("modifier_ivory_gryffin_aura_effect") then
			damage = damage * (100-FEATHERWHITE_MAGIC_AND_PURE_REDUCTION)/100
		end
	end
	if victim:HasModifier("modifier_azalea_zealot_ai") then
		local ability = victim:FindAbilityByName("winterblight_azalea_zealot_passive")
		local reduction = 1
		if ability then
			reduction = (100 - ability:GetSpecialValueFor("damage_reduction")) / 100
		end
		if damagetype == DAMAGE_TYPE_MAGICAL then
			if victim.color == "green" then
				damage = damage * reduction
			end
		elseif damagetype == DAMAGE_TYPE_PURE then
			if victim.color == "red" then
				damage = damage * reduction
			end
		elseif damagetype == DAMAGE_TYPE_PHYSICAL then
			if victim.color == "blue" then
				damage = damage * reduction
			end
		end
	end
	if victim:HasModifier("modifier_maiden_armor") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			damage = damage * (1 - victim:GetModifierStackCount("modifier_maiden_armor", victim) * 0.01)
			if shouldConsumeShields then
				CustomAbilities:HitWinterblightMaidenShield(victim, attacker)
			end
		end
	end

	damage = damage * heroes.venomort.getDamageDecrease(victim, attacker, damagetype)
	local decreaseAll = GameState:IncomingDamageDecrease(victim, attacker, shouldConsumeShields)
	return (damage / BASE_VALUE_FOR_CALCULATE) * decreaseAll
end

function GameState:IncomingDamageIncrease(victim, attacker, bReal, damagetype)
	local BASE_VALUE_FOR_CALCULATE = 100000
	local damage = BASE_VALUE_FOR_CALCULATE
	if victim:HasModifier("modifier_berserker_gloves_buff_visible") then
		local stacks = victim:GetModifierStackCount("modifier_berserker_gloves_buff_visible", victim.InventoryUnit)
		damage = damage + damage * BERSERKER_GLOVES_DAMAGE_RECEIVED_INCREASE/100 * stacks
	end
	if victim:HasModifier("modifier_hand_azinoth") then
		damage = damage * (100 + CLAW_OF_AZINOTH_DAMAGE_AMP)/100
	end
	if victim:HasModifier("modifier_frostiok_damage_amp") then
		local buffCaster = victim:FindModifierByName("modifier_frostiok_damage_amp"):GetCaster()
		local buffAbility = victim:FindModifierByName("modifier_frostiok_damage_amp"):GetAbility()
		if IsValidEntity(buffAbility) then
			local stacks = victim:GetModifierStackCount("modifier_frostiok_damage_amp", buffCaster)
			local amp = buffAbility:GetLevelSpecialValueFor("damage_amp_per_stack", buffAbility:GetLevel()) / 100
			damage = damage + damage * amp * stacks
		end
	end

	return damage / BASE_VALUE_FOR_CALCULATE
end

function GameState:IncomingDamageDecrease(victim, attacker, shouldConsumeShields)
	local BASE_VALUE_FOR_CALCULATE = 1000000 -- for prevent calc errors with small values
	local damage = BASE_VALUE_FOR_CALCULATE

	if victim:HasModifier("modifier_ablecore_greaves_effect") then
		damage = damage * (100-ABLECORE_GREAVES_DMG_RED)/100
	end
	if victim:HasModifier("modifier_resplendent_rubber_boots") then
		damage = damage * (100-RESPLENDENT_RUBBER_DMG_REDUCTION)/100
	end
	if victim:HasModifier("modifier_solunia_c_d_arcana_shell") then
		damage = damage * 0.05
	end
	if victim:HasModifier("modifier_neutral_glyph_5_1") then
		damage = damage * 0.65
	end
	if victim:HasModifier("modifier_guard_of_feronia_shield") then
		damage = damage * (100-GUARD_OF_FERONIA_SHIELD_DAMAGE_REDUCTION)/100
	end
	if victim:HasModifier("modifier_helm_of_the_mountain_giant") and (victim:GetHealth() > victim:GetMaxHealth() * HELM_OF_THE_MOUNTAIN_GIANT_PERCENT_TRESHOLD/100) then
		damage = damage * HELM_OF_THE_MOUNTAIN_GIANT_PERCENT_DAMAGE_REDUCTION/100
	end
	if victim:HasModifier("modifier_whirlwind") and victim:HasModifier("modifier_axe_glyph_4_2") then
		damage = damage * 0.5
	end
	if victim:HasModifier("modifier_axe_glyph_1_1") then
		damage = damage * 0.7
	end
	if victim:HasModifier("modifier_redrock_footwear_damage_reduction") then
		damage = damage * (100-REDROCK_DAMAGE_REDUCTION_PCT)/100
	end
	if victim:HasModifier("modifier_gravelfoot_buff") then
		damage = damage * (100-GRAVELFOOT_DMG_REDUCTION)/100
	end
	if victim:HasModifier("modifier_flametongue_q_2_fire_shield") then
		if victim.q_2_level and victim.q_2_level > 0 then
			local reduction = 1 - math.min((0.65 + 0.001 * victim.q_2_level), 0.95)
			damage = damage * reduction
		end
	end
	if victim:HasModifier("modifier_jex_magic_immunity") then
		local barrier_ability = victim:FindModifierByName("modifier_jex_magic_immunity"):GetAbility()
		local reduce_pct = barrier_ability:GetSpecialValueFor("q_4_damage_reduction_pct")
		if barrier_ability.q_4_level then
			local reduction = reduce_pct * barrier_ability.q_4_level
			damage = damage * (1 - (reduction / 100))
		end
	end
	if victim:HasModifier("modifier_knight_hawk_helm") then
		local movespeed = victim:GetBaseMoveSpeed()
		local movespeedModifier = victim:GetMoveSpeedModifier(movespeed, false)
		if movespeedModifier > 550 then
			damage = damage * (1-(KNIGHT_HAWK_DR_ABOVE_DEFAULT_MAX/100))
		end
	end
	if victim:HasModifier("modifier_stonewall_aura_friendly_effect") then
		local reduction = victim:FindModifierByName("modifier_stonewall_aura_friendly_effect"):GetAbility():GetSpecialValueFor("damage_reduction")
		damage = damage * (1 - (reduction / 100))
	end
	if victim:HasModifier("modifier_natures_path_master_buff") then
		local reduction = victim:FindModifierByName("modifier_natures_path_master_buff"):GetAbility():GetSpecialValueFor("damage_reduction")
		damage = damage * (1 - (reduction / 100))
	end
	if victim:HasModifier("modifier_arkimus_arcana1_q3") then
		local stacks = victim:GetModifierStackCount("modifier_arkimus_arcana1_q3", victim)
		local reduction = (1 - ARKIMUS_ARCANA1_Q3_DMG_RED_PER_STACK_EXP_BASE) ^ stacks
		damage = damage * reduction
	end
	if victim:HasModifier("modifier_arkimus_w_4_shield") then
		damage = 0
		if shouldConsumeShields then
			local newStacks = victim:GetModifierStackCount("modifier_arkimus_w_4_shield", caster) - 1
			if newStacks == 0 then
				victim:RemoveModifierByName("modifier_arkimus_w_4_shield")
			else
				victim:SetModifierStackCount("modifier_arkimus_w_4_shield", caster, newStacks)
			end
		end
	end
	if victim:HasModifier("modifier_earth_guardian") then
		if attacker:GetEntityIndex() == victim:GetEntityIndex() then
		else
			damage = damage * 0.5
		end
	end
	if victim:HasModifier("modifier_paladin_glyph_7_2") then
		damage = damage * 0.01
	end
	if victim:HasModifier("modifier_nefali_aura_effect") then
		if victim:GetTeamNumber() == victim:FindModifierByName("modifier_nefali_aura_effect"):GetCaster():GetTeamNumber() then
			local nefaliCaster = victim:FindModifierByName("modifier_nefali_aura_effect"):GetCaster()
			local nefaliAbility = nefaliCaster:FindAbilityByName("blessing_of_nefali")
			local reduction = nefaliAbility:GetLevelSpecialValueFor("damage_reduce", nefaliAbility:GetLevel())
			reduction = (100 - reduction) / 100
			if nefaliCaster:HasModifier("modifier_sephyr_glyph_5_a") then
				reduction = 0.005
			end
			damage = damage * reduction
		end
	end
	if victim:HasModifier("modifier_fuchsia_damage_resistance") then
		damage = damage * (100-FUCHSIA_DMG_REDUCTION)/100
	end
	if victim:HasModifier("modifier_energy_field_c_d_shield") then
		damage = damage * (1 - ARKIMUS_R3_DMG_RED)
	end
	if victim:HasModifier("modifier_possession_enemy_lock") then
		damage = 0
	end
	if victim:HasModifier("modifier_rooted_feet_health_regen") then
		damage = damage * (100-ROOTED_FEET_DMG_REDUCTION)/100
	end
	if victim:HasModifier("modifier_ice_scathe_q2_shield") then
		damage = damage * (1-(WARLORD_ARCANA2_Q2_DAMAGE_REDUCTION_PCT/100))
	end
	if victim:HasModifier("modifier_ogre_armor") then
		local ogreArmor = victim:FindAbilityByName("winterblight_ogre_armor")
		local reduction = ogreArmor:GetLevelSpecialValueFor("damage_resist", ogreArmor:GetLevel())
		reduction = (100 - reduction) / 100
		damage = damage * reduction
	end

	if victim:HasModifier("modifier_arkimus_archon_form") then
		local archonForm = victim:FindModifierByName("modifier_arkimus_archon_form"):GetAbility()
		if archonForm then
			local reduction = archonForm:GetLevelSpecialValueFor("damage_resist", archonForm:GetLevel())
			reduction = (100 - reduction) / 100
			damage = damage * reduction
		end
	end
	if victim:HasModifier("modifier_axe_rune_r_3_shield") then
		damage = damage * 0.2
		if victim:HasModifier("modifier_axe_glyph_6_2") then
			damage = damage * 0.5
		end
		if shouldConsumeShields then
			Filters:HitAxeCCShield(victim, attacker)
		end
	end
	if victim:HasModifier("modifier_volcano_shield") then
		damage = damage * 0.1
		if shouldConsumeShields then
			CustomAbilities:HitVolcanoShield(victim, attacker)
		end
	end

	if victim:HasModifier("modifier_neutral_glyph_5_2") then
		damage = damage * 2
	end

	if victim:HasModifier("modifier_raven_idol2") then
		damage = damage * (100-RAVEN_IDOL_DMG_REDUCTION)/100
	end

	if victim:HasModifier("modifier_axe_immortal_weapon_1") then
		damage = damage * 0.5
	end

	if victim:HasModifier("modifier_living_gauntlet_effect") then
		damage = damage * (100-LIVING_GAUNTLET_DMG_REDUCTION)/100
	end

	if victim:HasModifier("modifier_red_october_boots") then
		local EAbility = victim:GetAbilityByIndex(DOTA_E_SLOT)
		if EAbility:GetCooldownTimeRemaining() > 0 then
			damage = damage * (100-RED_OCTOBER_DMG_REDUCTION)/100
		end
	end

	if victim:HasModifier("modifier_world_tree_effect") then
		damage = damage * WORLD_TREES_CACHE_DAMAGE_TAKEN_INC_PCT/100
	end

	if victim:HasModifier("modifier_dummy_aura1_effect_zhonik") then
		damage = damage * 0.2
	end
	if victim:HasModifier("modifier_damage_resistance") then
		if victim.damageReduc then
			damage = damage * victim.damageReduc
		end
	end

	if victim:HasModifier("modifier_sea_giants_plate") then
		if victim:IsStunned() then
			damage = damage * (100-SEA_GIANTS_PLATE_DMG_REDUCTION_WHILE_STUNNED)/100
		end
	end

	if victim:HasModifier("modifier_chitinous_skin_stack") then
		local stacks = victim:GetModifierStackCount("modifier_chitinous_skin_stack", victim.InventoryUnit)
		local reduction = 1 - stacks * CHITINOUS_LOBSTER_CLAW_DMG_RED_PER_STACK
		damage = damage * reduction
		if shouldConsumeShields then
			local newStacks = stacks - 1
			if newStacks > 0 then
				victim:SetModifierStackCount("modifier_chitinous_skin_stack", victim.InventoryUnit, newStacks)
			else
				victim:RemoveModifierByName("modifier_chitinous_skin_stack")
			end
		end
	end
	if victim:HasModifier("modifier_dragonflame_shield") then
		local dragonflame = victim:FindAbilityByName("flamewaker_dragonflame")
		if dragonflame then
			local reduction = (100 - dragonflame:GetSpecialValueFor("damage_reduce")) / 100
			damage = damage * reduction
		end
	end
	if victim:HasModifier("modifier_overload_damage_resistance") then
		damage = damage * 0.1
	end

	if victim:HasModifier("modifier_energy_channel") or victim:HasModifier("modifier_steelforge_stance") then
		if victim:HasModifier("modifier_mountain_protector_glyph_2_1") then
			damage = damage * 0.7
		end
	end

	if victim:HasModifier("modifier_tachyon_shell") then
		local modifier = victim:FindModifierByName("modifier_tachyon_shell")
		if modifier:GetCaster():GetTeamNumber() == victim:GetTeamNumber() then
			local reduction = math.max(modifier:GetAbility().q_4_level * ZHONIK_Q4_DMG_TAKEN_REDUCTION_PCT / 100, 0.01)
			if victim:GetEntityIndex() == modifier:GetCaster():GetEntityIndex() then
				reduction = reduction * 2
			end
			reduction = math.min(reduction, ZHONIK_Q4_DMG_TAKEN_REDUCTION_MAX_PCT / 100)
			----print("zhonic q4 "..reduction)
			damage = damage * (1 - reduction)
		end
	end

	if victim:HasModifier("modifier_shapeshift_year_beast_r_3") then
		local modifier = victim:FindModifierByName("modifier_shapeshift_year_beast_r_3")
		local reduction = modifier:GetAbility().r_3_level * DJANGHOR_R3_ARCANA_RESIST_PCT
		reduction = math.min(reduction, DJANGHOR_R3_ARCANA_RESIST_MAX_PCT)
		damage = damage * (1 - reduction)
	end
	if victim:HasModifier("modifier_ancient_tree_passive") then
		damage = damage * 0.004
		if victim:HasModifier("modifier_ancient_tree_round_2") then
			damage = damage * 0.5
		end
		local reduction = math.min(victim.summonCount * 0.05, 1)
		damage = damage * (1 - reduction)
	end
	if victim:HasModifier("modifier_drowning_pool_actual_effect") then
		local modifier = victim:FindModifierByName("modifier_drowning_pool_actual_effect")
		local stacks = modifier:GetStackCount()
		local damageReduc = math.min(stacks * HYDROXIS_R4_DMG_RED_PCT/100, 0.9)
		damage = damage - damage * damageReduc
	end
	if victim:HasModifier("modifier_steelforge_passive") then
		local steelForge = victim:FindAbilityByName("mountain_protector_steelforge_stance")
		local reduction = steelForge:GetLevelSpecialValueFor("damage_resist", steelForge:GetLevel())
		reduction = (100 - reduction) / 100
		damage = damage * reduction
	end
	if victim:HasModifier("modifier_task_armor") then
		damage = damage * 0.001
		if shouldConsumeShields then
			CustomAbilities:HitTaskShield(victim, attacker)
		end
	end
	if victim:HasModifier("modifier_luna_armor") then
		damage = damage * 0.001
		if shouldConsumeShields then
			CustomAbilities:HitLunaShield(victim, attacker)
		end
	end
	if victim:HasModifier("modifier_jex_orbital_flame_effect") then
		if shouldConsumeShields then
			damage = 0
			CustomAbilities:HitJexOrbitalFlame(victim, attacker)
		end
	end
	if victim:HasModifier("modifier_knights_disciple_heal") then
		damage = damage * 0.8
	end
	if victim:HasModifier("modifier_astral_c_c_visible") then
		damage = damage * 0.25
	end
	if victim:HasModifier("modifier_ancient_rain") then
		local ancientRain = victim:FindAbilityByName("spirit_warrior_ancient_rain")
		if ancientRain then
			local reduction = (100 - ancientRain:GetSpecialValueFor("damage_reduction_percent")) / 100
			damage = damage * reduction
		end
	end

	if victim:HasModifier("modifier_duskbringer_glyph_4_2_visible") then
		local stacks = victim:GetModifierStackCount("modifier_duskbringer_glyph_4_2_visible", victim)
		damage = damage * (1 - DUSKBRINGER_GLYPH_4_2_RES_PER_STACK * stacks)
	end
	if victim:HasModifier("modifier_snowshaker_passive") then
		local passive = victim:FindAbilityByName("winterblight_snowshaker_passive")
		if passive:GetCooldownTimeRemaining() == 0 then
			damage = 0
			if shouldConsumeShields then
				passive:StartCooldown(passive:GetCooldown(passive:GetLevel()))
				CustomAbilities:QuickAttachParticle("particles/items_fx/immunity_sphere_lincoln_b.vpcf", victim, 0.5)
			end
		end
	end
	if victim:HasModifier("modifier_frigid_growth_shield") then
		local passive = victim:FindAbilityByName("winterblight_frigid_growth_passive")
		local reduction = passive:GetLevelSpecialValueFor("damage_reduc", passive:GetLevel())
		reduction = (100 - reduction) / 100
		damage = damage * reduction
	end
	if victim:HasModifier("modifier_speed_softening") then
		local passive = victim:FindAbilityByName("winterblight_speed_softening")
		local movespeed = victim:GetBaseMoveSpeed()
		local actual_movespeed = victim:GetMoveSpeedModifier(movespeed, false)
		if actual_movespeed >= 300 then
			local reduction = passive:GetLevelSpecialValueFor("damage_reduc", passive:GetLevel())
			reduction = (100 - reduction) / 100
			damage = damage * reduction
		end
	end
	if victim:HasModifier("modifier_armor_softening") then
		local passive = victim:FindAbilityByName("winterblight_armor_softening")
		local armor = victim:GetPhysicalArmorValue(false)
		if armor > 0 then
			local reduction = passive:GetLevelSpecialValueFor("damage_reduc", passive:GetLevel())
			reduction = (100 - reduction) / 100
			damage = damage * reduction
		end
	end
	if victim:HasModifier("modifier_winterblight_endurance_buff") then
		local passive = victim:FindAbilityByName("winterblight_endurance")
		local reduction = passive:GetSpecialValueFor("damage_reduction")
		local dmgMultiplier = (100 - reduction) / 100
		damage = damage * dmgMultiplier
	end
	if victim:HasModifier("modifier_syphist_passive") then
		if victim:GetHealth() / victim:GetMaxHealth() >= 0.1 then
			damage = 0
		end
	end
	if victim:HasModifier("modifier_triboss_powered_up_single") then
		local difficultyReduc = {0.7, 0.1, 0.01}
		local stonesReduce = {0.5, 0.05, 0.01}
		local stoneReduce = 1
		if Winterblight.Stones > 0 then
			stoneReduce = stonesReduce[Winterblight.Stones]
			if GameState:GetDifficultyFactor() == 1 then
				stoneReduce = math.max(stoneReduce, 0.1)
			elseif GameState:GetDifficultyFactor() == 2 then
				stoneReduce = math.max(stoneReduce, 0.01)
			end
		end
		damage = damage * difficultyReduc[GameState:GetDifficultyFactor()] * stoneReduce
	end
	if victim:HasModifier("modifier_Winterblight_unit") then
		if Winterblight.Stones == 1 then
			damage = damage * 0.01
		elseif Winterblight.Stones == 2 then
			damage = damage * 0.001
		elseif Winterblight.Stones == 3 then
			damage = damage * 0.00001
		end
	end
	return damage / BASE_VALUE_FOR_CALCULATE
end

function GameState:AbilityFilter(abilityTable)
	return true
end

function GameState:FilterDamage(filterTable)
	local victim_index = filterTable["entindex_victim_const"]
	local attacker_index = filterTable["entindex_attacker_const"]

	if not victim_index or not attacker_index then
		return true
	end

	--Only Auto attacks dont have filterTable.entindex_inflictor_const set
	if not filterTable.entindex_inflictor_const then
		if filterTable.damagetype_const == DAMAGE_TYPE_PHYSICAL then
			return false
		end
	end

	--Our faked Auto attack dmg to ignore armor on enemies
	--Set filterTable.entindex_inflictor_const to nil to make it like normal auto attack
	if filterTable.entindex_inflictor_const then
		if EntIndexToHScript(filterTable.entindex_inflictor_const):GetName() == "auto_attack_damage_ability" then
			filterTable.entindex_inflictor_const = nil
		end
	end
	local difficultyDamageReduce = 1
	local victim = EntIndexToHScript(victim_index)
	local attacker = EntIndexToHScript(attacker_index)
	local damageData = attacker._damage_data or {}
	local elements = {}
	if attacker.element1 ~= RPC_ELEMENT_NONE then
		table.insert(elements,attacker.element1)
	end
	if attacker.element2 ~= RPC_ELEMENT_NONE then
		table.insert(elements,attacker.element2)
	end

	if damageData.maxPremitigationDamage then
		filterTable['damage'] = math.min(filterTable['damage'], damageData.maxPremitigationDamage)
	end

	if attacker:HasModifier("modifier_apprentice_ai") or attacker:HasModifier("modifier_alien_armor_illusion") then
		Filters:ApplyItemDamage(victim, attacker.hero, filterTable.damage, filterTable.damagetype_const, attacker.hero.body, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
		return false
	end
	if attacker:HasModifier("modifier_magistrates_hood") then
		if filterTable.damagetype_const == DAMAGE_TYPE_MAGICAL or filterTable.damagetype_const == DAMAGE_TYPE_PURE then
			local inflictor = nil
			if filterTable.entindex_inflictor_const then
				inflictor = EntIndexToHScript(filterTable.entindex_inflictor_const)
			end
			if inflictor ~= attacker.headItem then
				local stacks = attacker:GetModifierStackCount("modifier_magistrates_hood_charges", attacker.InventoryUnit)
				if stacks > 0 then
					local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), victim:GetAbsOrigin(), nil, MAGISTRATE_HOOD_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					local magistrate_damage = filterTable.damage*(1 + ((MAGISTRATE_HOOD_DAMAGE_AMP_PCT*#enemies)/100))
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
				            Damage:Apply({
				                source = attacker.headItem,
				                sourceType = BASE_NONE,
				                attacker = attacker,
				                victim = enemy,
				                damage = magistrate_damage,
				                damageType = DAMAGE_TYPE_MAGICAL,
				                elements = elements,
				                ignoreMultipliers = true
				            })
						end
					end
					if not attacker.headItem.particles then
						attacker.headItem.particles = 0
					end
					if attacker.headItem.particles < 6 then
						attacker.headItem.particles = attacker.headItem.particles + 1
						local colorVector = Vector(0.5, 0.5, 0.5)
						if #elements > 0 then
					    	colorVector = Elements:RGBVectorFromElementIndex(elements[1])
					    end
					    print(colorVector)
					    local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/magistrate_hood_gold.vpcf", victim:GetAbsOrigin(), 3)
					    ParticleManager:SetParticleControl(pfx, 12, colorVector)
						Timers:CreateTimer(1, function()
							attacker.headItem.particles = attacker.headItem.particles - 1
						end)
					end
					local new_stacks = math.max(stacks - 1, 0)
					if new_stacks == 0 then
						attacker:RemoveModifierByName("modifier_magistrates_hood_charges")
					else
						print(new_stacks)
						attacker:SetModifierStackCount("modifier_magistrates_hood_charges", attacker.InventoryUnit, new_stacks)
					end
					Timers:CreateTimer(MAGISTRATE_HOOD_REPLENISH_TIME, function()
						local current_stacks = attacker:GetModifierStackCount("modifier_magistrates_hood_charges", attacker.InventoryUnit)
						local refreshed_stacks = math.min(current_stacks + 1, MAGISTRATE_HOOD_MAX_CHARGES)
						attacker.headItem:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_magistrates_hood_charges", {})
						attacker:SetModifierStackCount("modifier_magistrates_hood_charges", attacker.InventoryUnit, refreshed_stacks)
					end)
				end
				return false
			end
		end
	end
	local abs = math.abs
	if filterTable.damagetype_const == DAMAGE_TYPE_PHYSICAL then
		local armor = victim:GetPhysicalArmorValue(false)
		if attacker:HasModifier("modifier_hand_marauder") and armor >= 0 then
			armor = 0
		end
		if victim:HasModifier("modifier_omniro_shadow_debuff") and armor >= 0 then
			armor = 0
		end
		if attacker:GetUnitName() == "paladin_disciple" then
			Filters:TakeArgumentsAndApplyDamage(victim, attacker.paladin, Filters:OverflowProtectedGetAverageTrueAttackDamage(attacker.paladin) * 10, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
			return false
		end
		if attacker:GetUnitName() == "ekkan_skeleton_archer" then
			local luck = RandomInt(1, 10)
			if luck <= 3 then
				filterTable.damage = filterTable.damage * (1 + attacker.w_1_level * EKKAN_W1_CRIT_DMG)
				local damage = Filters:TakeArgumentsAndApplyDamage(victim, attacker.hero, filterTable.damage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE, true, nil)
				filterTable["damage"] = damage
				armor = 0
				PopupDamage(victim, damage)
				CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/archer_crit.vpcf", victim, 0.6)
				attacker.element1 = RPC_ELEMENT_UNDEAD
				filterTable["entindex_inflictor_const"] = attacker.hero:FindAbilityByName("ekkan_summon_skeleton"):GetEntityIndex()
			end
		end
		filterTable.damage = filterTable.damage * (1 - ((0.05 * armor) / (1 + 0.05 * abs(armor))))

		if victim:HasModifier("heatwave_fire_damage") then
			local armor = victim:GetPhysicalArmorValue(false)
			if armor < 0 then
				local heatwave_ability = victim:FindModifierByName("heatwave_fire_damage"):GetAbility()
				if heatwave_ability.rune_e_1 then
					local armor_current = armor
					local premit_enhance = math.min(FLAMEWAKER_E1_PREMIT * heatwave_ability.rune_e_1 * math.abs(armor_current), heatwave_ability.rune_e_1 * 2)
					filterTable.damage = filterTable.damage + filterTable.damage * premit_enhance
				end
			end
		end
	end
	if attacker:GetUnitName() == "ekkan_skeleton_mage" then
		if filterTable.entindex_inflictor_const then
			local ability_used = EntIndexToHScript(filterTable.entindex_inflictor_const)
			if ability_used:GetAbilityName() == "ekkan_mage_blast" then
				local damage = Filters:TakeArgumentsAndApplyDamage(victim, attacker.hero, filterTable.damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE, true, nil)
				filterTable["damage"] = damage
				attacker.element1 = RPC_ELEMENT_UNDEAD
			end
		end
	end

	if attacker:HasModifier("modifier_arkimus_archon_form") then
		filterTable["damagetype_const"] = DAMAGE_TYPE_PURE
	end
	if attacker:HasModifier("modifier_paladin_glyph_7_2") then
		filterTable["damage"] = filterTable["damage"] * 0.001
	end
	if attacker:GetUnitName() == "voltex_rune_e_1_illusion" then
		--Changes the attacker to hero, so that its cerdited to him
		filterTable["entindex_attacker_const"] = attacker.hero:GetEntityIndex()
		attacker = EntIndexToHScript(filterTable["entindex_attacker_const"])
		local e_1_level = attacker:GetRuneValue("e", 1)
		filterTable["damage"] = filterTable["damage"] * (VOLTEX_E1_BASE_OUTGOING_DMG_MULT + VOLTEX_E1_OUTGOING_DMG_MULT * e_1_level)
	end
	local damagetype = filterTable["damagetype_const"]

	local mult = 1
	local divisor = 1
	local modifier = nil

	if attacker:IsHero() then
		-- if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
		-- filterTable["damage"] = math.ceil(filterTable["damage"]/(1+((attacker:GetIntellect()/14)/100)))
		-- end
	end
	local StartingDamage = filterTable["damage"]
	local applyEffects = true
	local applySturdyHornEffect = true

	if filterTable["entindex_inflictor_const"] then
		local ability = EntIndexToHScript(filterTable["entindex_inflictor_const"])
		if ability:GetEntityIndex() == Events.GameMasterAbility:GetEntityIndex() then
			applyEffects = false
		end
		-- if not ability:GetName() == "npc_dota_creature" then
		-- if not string.match(ability:GetClassname(), "npc_dota_hero_") then
		-- if IsValidEntity(ability) then
		-- local abilityName = ability:GetAbilityName()
		-- modifier = victim:FindModifierByName('modifier_centaur_horns')
		-- if abilityName ~= 'item_rpc_centaur_horns' and modifier then
		-- local centaurHornsAbility = modifier:GetAbility()
		-- centaurHornsAbility:ApplyDataDrivenModifier(victim, victim, "modifier_centaur_horns_debuff", {duration = 1.5})
		-- end
		-- end
		-- end
		-- end
	end
	modifier = attacker:FindModifierByName('modifier_chernobog_glyph_t71_passive')
	if modifier then
		mult = mult + modifier:GetPostmitigationAmplify({})
	end
	modifier = attacker:FindModifierByName('modifier_chernobog_4_r_arcana1_postmit_r3')
	if modifier then
		mult = mult + modifier:GetPostmitigationAmplify({ attacker = attacker })
	end
	modifier = victim:FindModifierByName('modifier_chernobog_4_r_procession_enemy_effect')
	if modifier then
		mult = mult + modifier:GetPostmitigationAmplify({ attacker = attacker })
	end
	modifier = victim:FindModifierByName('modifier_chernobog_3_e_teleportation_enemy_effect_e3')
	if modifier then
		mult = mult + modifier:GetPostmitigationAmplify({ attacker = attacker })
	end
	if victim:HasModifier("modifier_centaur_horns") then
		if filterTable["entindex_inflictor_const"] then
			if EntIndexToHScript(filterTable["entindex_inflictor_const"]):GetName() ~= "item_rpc_centaur_horns" then
				local ability = victim:FindModifierByName("modifier_centaur_horns"):GetAbility()
				ability:ApplyDataDrivenModifier(victim, victim, "modifier_centaur_horns_debuff", {duration = CENTAUR_HORNS_DEBUFF_DURATION})
			end
		else
			local ability = victim:FindModifierByName("modifier_centaur_horns"):GetAbility()
			ability:ApplyDataDrivenModifier(victim, victim, "modifier_centaur_horns_debuff", {duration = CENTAUR_HORNS_DEBUFF_DURATION})
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
				filterTable["damage"] = filterTable["damage"] * 0.1
			end
		end
	end
	--building epoch dmg before other multiplers
	if victim:HasModifier("modifier_epoch_arcana_root") then
		local modifier = victim:FindModifierByName("modifier_epoch_arcana_root")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local q_1_level = attacker:GetRuneValue("q", 1)
			if q_1_level > 0 then
				if attacker:HasAbility("epoch_arcana_ability") then
					local affectedByQ1 = victim:FindModifierByName("modifier_epoch_arcana_q_1_effect")
					if not affectedByQ1 then
						----print("affectedByQ1 true")
						attacker:FindAbilityByName("epoch_arcana_ability"):ApplyDataDrivenModifier(attacker, victim, "modifier_epoch_arcana_q_1_effect", {duration = 3})
					end
					-- attacker:FindAbilityByName("epoch_arcana_ability"):ApplyDataDrivenModifier(attacker, victim, "modifier_epoch_arcana_a_a_effect", {duration = 3})
					local damage = filterTable["damage"]
					-- filterTable["damage"] = 0
					-- victim:Heal(damage, attacker)
					if not victim.epochArcanaAA then
						victim.epochArcanaAA = 0
					end
					----print("od q1 arcana test damage per hit Hit "..victim.epochArcanaAA)
					----print("od q1 arcana test damage per hit Damage "..damage)
					-- victim.epochArcanaAA = math.max(victim.epochArcanaAA,damage)
					victim.epochArcanaAA = victim.epochArcanaAA + damage
				end
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
				local r_1_level = attacker:GetRuneValue("r", 1)
				damage = damage + damage * r_1_level * 0.15
				Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damagetype, BASE_ABILITY_R, element1, RPC_ELEMENT_NONE)
				return false
			end
		end
		if WallPhysics:DoesTableHaveValue(attacker.possessedTable, victim:GetUnitName()) then
			local r_3_level = attacker:GetRuneValue("r", 3)
			if r_3_level > 0 then
				mult = mult + 0.2 * r_3_level
			end
		end
	end
	if filterTable["entindex_inflictor_const"] then
		if EntIndexToHScript(filterTable["entindex_inflictor_const"]):GetName() == "axe_arcana_smash" then
			local r_1_level = attacker:GetRuneValue("r", 1)
			mult = mult + 0.1 * r_1_level
		end
	end
	if damagetype == DAMAGE_TYPE_PHYSICAL then
		-- local original_damage = filterTable["damage"] --Post reduction
		-- local inflictor = filterTable["entindex_inflictor_const"]
		-- local damage = original_damage
		-- filterTable["damage"] = damage
		-- if attacker:IsHero() then
		-- local primaryAttibute = Filters:GetPrimaryAttributeMultiple(attacker, 1)
		-- filterTable["damage"] = filterTable["damage"]*(1+((primaryAttibute/16)/100))
		-- end
		if attacker:HasModifier("modifier_tempest_falcon_ring") then
			attacker.amulet:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_tempest_falcon_ring_effect", {duration = TEMPEST_FALCON_RING_DURATION})
		end
		if attacker:HasModifier("modifier_firelock_pendant") then
			local multIncrease = (attacker:GetStrength() / FIRELOCK_PENDANT_STR_DIVISOR) * FIRELOCK_PENDANT_STR_TO_POST_MITI/100
			mult = mult + multIncrease
		end
		if attacker:HasModifier("modifier_power_ranger") then
			mult = mult + POWER_RANGER_PHYS_POST_MITI/100
		end
		if attacker:HasModifier("modifier_golden_war_plate") then
			mult = mult + GOLDEN_WARPLATE_PHYS_POST_MITI_AMP/100
		end
		if victim:HasModifier("modifier_hood_of_defiler_effect_visible") then
			local multIncrease = victim:GetModifierStackCount("modifier_hood_of_defiler_effect_visible", victim.defiler) * HOOD_OF_DEFILER_POST_MITI_PHYS/100
			mult = mult + multIncrease
		end
		if victim:HasModifier('modifier_basilisk_plague_petrify') then
			mult = mult + BASILISK_PLAGUE_PHYSICAL_POSTMIT
		end
	elseif damagetype == DAMAGE_TYPE_MAGICAL then
		local inflictor = filterTable["entindex_inflictor_const"]
		if attacker:HasModifier("modifier_alarana_ice_freeze") then
			mult = mult + ALARANA_MAGIC_POST_MITI/100
		end
		if attacker:HasModifier("modifier_warlord_glyph_5_a") then
			if attacker:HasModifier("modifier_warlord_ice_charge") then
				local iceCharges = attacker:GetModifierStackCount("modifier_warlord_ice_charge", attacker)
				mult = mult + 0.05 * iceCharges
			end
		end
		if attacker:HasModifier("modifier_shadow_trap_d_a_buff") then
			local stacks = attacker:GetModifierStackCount("modifier_shadow_trap_d_a_buff", attacker)
			mult = mult + 0.1 * stacks
		end
		if victim:HasModifier("modifier_drake_ring_postmit") then
			if attacker:GetUnitName() == "npc_dota_hero_winter_wyvern" then
				local stacks = victim:GetModifierStackCount("modifier_drake_ring_postmit", attacker)
				mult = mult + DINATH_W2_POST_MITI_MAGIC * stacks
				--print("STACK INCREASE")
				--print(stacks)
			end
		end
		if attacker:HasModifier("modifier_jex_nature_cosmic_w") then
			local ability = attacker:FindModifierByName("modifier_jex_nature_cosmic_w"):GetAbility()
			if not ability.tech_level then
				ability.tech_level = attacker.onibi.stats_table["nature"]["cosmic"]["W"]["level"]
			end
			local postmit = (ability:GetSpecialValueFor("post_mitigation_magic_per_tech") * ability.tech_level) / 100
			mult = mult + postmit
		end
		if attacker:HasModifier("modifier_sorcerers_regalia") then
			mult = mult + SORCERERS_REGALIA_MAGIC_POST_MITI/100
		end
		if attacker:HasModifier("modifier_slipfinn_bog_roller_e3") then
			local stacks = attacker:GetModifierStackCount("modifier_slipfinn_bog_roller_e3", attacker)
			mult = mult + stacks * 0.08
		end
		if attacker:HasModifier("modifier_neutral_glyph_6_3") then
			mult = mult + 0.25
		end
		if attacker:HasModifier("modifier_far_seers_gloves") then
			Filters:FarSeerGloves(attacker, filterTable["damage"], filterTable["entindex_inflictor_const"])
		end
		if attacker:HasModifier("modifier_tempest_falcon_ring_effect") then
			mult = mult + TEMPEST_FALCON_RING_POST_MITI_MAGIC/100
			Timers:CreateTimer(0.05, function()
				attacker:RemoveModifierByName("modifier_tempest_falcon_ring_effect")
			end)
		end
		if attacker:HasModifier("modifier_mark_of_the_talon") then
			local talonAbility = attacker:FindModifierByName("modifier_mark_of_the_talon"):GetAbility()
			local multIncrease = talonAbility:GetLevelSpecialValueFor("post_mitigation_magic", talonAbility:GetLevel() - 1) / 100
			if talonAbility.q_4_level then
				multIncrease = multIncrease + multIncrease * talonAbility.q_4_level * 0.05
			end
			mult = mult + multIncrease
		end
		if attacker:HasModifier("modifier_hood_of_the_black_mage") then
			mult = mult + (BLACK_MAGE_MAGIC_POST_MITI)/100
		end

		-- if attacker:HasModifier("modifier_warlord_rune_b_a_invisible") then
		-- if damagetype == DAMAGE_TYPE_MAGICAL then
		-- local stacks = attacker:GetModifierStackCount("modifier_warlord_rune_b_a_invisible", attacker.runeUnit2)
		-- mult = mult + 0.04*stacks
		-- end
		-- end

		if victim:HasModifier("modifier_carbuncles_helm_of_reflection_effect") then
			if not attacker:HasModifier("modifier_carbuncles_helm_of_reflection_effect") then
				if not attacker:HasModifier("modifier_carbuncle_immunity") then
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_medusa/carbuncle_ruby_shell_cast.vpcf", victim, 0.8)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_medusa/carbuncle_ruby_shell_cast.vpcf", attacker, 0.8)
					Filters:ApplyItemDamage(attacker, victim, filterTable["damage"] * CARBUNCLE_DAMAGE_AMP, DAMAGE_TYPE_MAGICAL, victim.headItem, RPC_ELEMENT_FIRE, RPC_ELEMENT_ARCANE)
					victim.headItem:ApplyDataDrivenModifier(victim.InventoryUnit, attacker, "modifier_carbuncle_immunity", {duration = CARBUNCLE_ENEMY_IMMUNITY_DURATION})
					Filters:ApplyStun(victim, CARBUNCLE_STUN_DUR, attacker)
					EmitSoundOn("RPC.Carbuncle.Reflect", attacker)
					local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/items/carbuncle_reflect.vpcf", attacker, 3)
					ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
				end
			end
			filterTable["damage"] = 0
		end
		if victim:HasModifier("modifier_umbral_sentinel_magic_amp") then
			local multIncrease = victim:GetModifierStackCount("modifier_umbral_sentinel_magic_amp", victim.umbral) * CREST_OF_UMBRAL_SENTINEL_POST_MITI_MAGIC/100
			mult = mult + multIncrease
		end

		if victim:HasModifier("modifier_solunia_warp_core_aura_solar") then
			modifier = victim:FindModifierByName("modifier_solunia_warp_core_aura_solar")
			mult = mult + modifier:GetAbility().e_3_level * SOLUNIA_E3_POST_MITI_PCT/100
		end
	elseif damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_solunia_warp_core_aura_lunar") then
			modifier = victim:FindModifierByName("modifier_solunia_warp_core_aura_lunar")
			mult = mult + modifier:GetAbility().e_3_level * SOLUNIA_E3_POST_MITI_PCT/100
		end

	end
	if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
		if victim:HasModifier("modifier_emerald_nullification_ring") then
			filterTable["damage"] = math.max(filterTable["damage"] - Filters:GetHeroAttribute(victim, "agility") * EMERALD_NULLIFICATION_AGI_TO_PURE_MAGIC_DMG_BLOCK, 0)
		end
		if attacker:HasModifier("modifier_hope_of_saytaru_effect") then
			filterTable["damage"] = (1 - SAYTARU_OUTPUT_PURE_AND_MAGIC_DMG_DECREASE) * filterTable["damage"]
		end
		if victim:HasModifier("modifier_azure_empire_visible") then
			if not Filters:HasDamageBlockShield(victim) then
				if filterTable["damage"] > 0 then
					filterTable["damage"] = 0
					Filters:AzureEmpire(victim, attacker)
				end
			end
		end
		if attacker:HasModifier("modifier_auriun_passive") then
			if attacker.e_1_level then
				mult = mult + 0.02 * attacker.e_1_level
			end
		end
		if attacker:HasModifier("modifier_leshrac_arcana_b_d_effect") then
			modifier = attacker:FindModifierByName("modifier_leshrac_arcana_b_d_effect")
			if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
				local stacks = modifier:GetStackCount()
				local multIncrease = 0.06 * stacks
				mult = mult + multIncrease
			end
		end
		if attacker:HasModifier("modifier_bahamut_arcana_passive") then
			local w_1_level = attacker:GetRuneValue("w", 1)
			if w_1_level > 0 then
				local healAmount = math.ceil(filterTable["damage"] * 0.001 / 100 * w_1_level)
				if healAmount > attacker:GetMaxHealth() - attacker:GetHealth() then
					local allyHealAmount = healAmount - (attacker:GetMaxHealth() - attacker:GetHealth())
					local arcanaAbility = attacker:FindAbilityByName("bahamut_arcana_orb")
					arcanaAbility:ApplyDataDrivenModifier(attacker, attacker, "modifier_spellvamp_healing", {duration = 0.3})
					local allies = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
					if #allies > 0 then
						for _, ally in pairs(allies) do
							Filters:ApplyHeal(attacker, ally, allyHealAmount / 10, true)
						end
					end
				end
				Filters:ApplyHeal(attacker, attacker, healAmount, true)
			end
		end

	end
	if damagetype == DAMAGE_TYPE_PHYSICAL or damagetype == DAMAGE_TYPE_MAGICAL then
		if victim:HasModifier("modifier_zonik_lightspeed") then
			local e_3_level = victim:FindAbilityByName("zonik_lightspeed").e_3_level
			filterTable["damage"] = math.max(filterTable["damage"] - Filters:GetHeroAttribute(victim, "agility") * e_3_level * ZHONIK_E3_PHYS_BLOCK_FLAT, 0)
		end
		if victim:HasModifier("modifier_draghor_shapeshift_hawk_lua") then
			filterTable["damage"] = math.max(filterTable["damage"] - Filters:GetHeroAttribute(victim, "intellect") * 5, 0)
		end
	end
	--chrolonus boss also uses the passive, have to check for ability
	if victim:HasModifier("modifier_voltex_arcana1_passive") and victim:HasAbility("voltex_lightning_dash") then
		local dash = victim:FindAbilityByName("voltex_lightning_dash")
		local damage = filterTable["damage"]
		local e_3_level = victim:GetRuneValue("e", 3)
		if e_3_level > 0 then
			if not dash.regen then
				dash.regen = 0
			end
			local addedRegen = math.ceil(damage * 0.025 * e_3_level)
			dash.regen = math.min(500000000 - (victim:GetHealthRegen() - dash.regen), dash.regen + addedRegen)
			dash:ApplyDataDrivenModifier(victim, victim, "modifier_voltex_lightning_dash_regen", {duration = 3})
			dash:ApplyDataDrivenModifier(victim, victim, "modifier_voltex_lightning_dash_regen_hidden", {duration = 3})
			victim:SetModifierStackCount("modifier_voltex_lightning_dash_regen_hidden", victim, dash.regen)
		end
	end
	if victim:HasModifier("modifier_jex_q_cosmic_cosmic_postmitigation") then
		local modifier = victim:FindModifierByName("modifier_jex_q_cosmic_cosmic_postmitigation")
		local stacks = victim:GetModifierStackCount("modifier_jex_q_cosmic_cosmic_postmitigation", modifier:GetCaster())
		mult = mult + 0.5 * stacks
	end
	if attacker:HasModifier("modifier_omnimace_undead_buff") then
		local modifier = attacker:FindModifierByName("modifier_omnimace_undead_buff")
		local stacks = attacker:GetModifierStackCount("modifier_omnimace_undead_buff", attacker)
		local ability = attacker:FindAbilityByName("omniro_omni_mace")
		mult = mult + (ability:GetSpecialValueFor("undead_special_b") / 100) * stacks
	end
	if attacker:HasModifier("modifier_duskbringer_arcana_q_4") then
		local stacks = attacker:GetModifierStackCount("modifier_duskbringer_arcana_q_4", attacker)
		mult = mult + 0.17 * stacks
	end
	if attacker:HasModifier("modifier_trickster_mask") then
		local minBoost = 0
		if attacker:HasModifier("modifier_boots_of_great_fortune") then
			minBoost = minBoost + BOOTS_OF_GREAT_FORTUNE_TRICKSTER_BOOST
		end
		if attacker:HasModifier("modifier_fortunes_talisman_of_truth") then
			minBoost = minBoost * FORTUNES_TALISMAN_TRICKSTER_BOOST_MULT + FORTUNES_TALISMAN_TRICKSTER_BOOST_ADD
		end
		local tricksterFactor = RandomInt(-(TRICKSTER_MASK_ALL_DMG_MULT_MIN * 10) + minBoost, ((TRICKSTER_MASK_ALL_DMG_MULT_MAX * 10) - 10))
		mult = mult + tricksterFactor / 10
	end
	if victim:HasModifier("modifier_nights_procession_a_d_rune") then
		if attacker:GetUnitName() == "npc_dota_hero_night_stalker" then
			local multBonus = victim:GetModifierStackCount("modifier_nights_procession_a_d_rune", attacker) * CHERNOBOG_R1_AMP_PCT/100
			mult = mult + multBonus
		end
	end
	if victim:HasModifier("modifier_nightmare_rider_effect_visible") then
		mult = mult + NIGHTMARE_RIDER_POST_MITIGATION_DEBUFF/100
	end
	if attacker:HasModifier("modifier_axe_rune_r_4_invisible") then
		local stacksCount = attacker:GetModifierStackCount("modifier_axe_rune_r_4_invisible", attacker)
		mult = mult + stacksCount * 0.02
	end

	if attacker:HasModifier("modifier_ablecore_greaves_effect") then
		mult = mult + ABLECORE_GREAVES_POST_MITI/100
	end
	if attacker:HasModifier("modifier_mordiggus_gauntlet") then
		mult = mult + (1 - attacker:GetHealth() / attacker:GetMaxHealth()) * MORDIGGUS_POST_MITI_BONUS_PER_HP_MISSING_PCT
	end

	if attacker:HasModifier("modifier_mugato") and attacker:IsSilenced() then
		mult = mult + MUGATO_POST_MITI_PCT/100
	end
	if victim:HasModifier("modifier_epoch_rune_w_2_visible") then
		if victim:GetPhysicalArmorValue(false) < 0 then
			if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
				modifier = victim:FindModifierByName("modifier_epoch_rune_w_2_visible")
				if attacker:GetRuneValue("w", 2) > 0 then
					local multIncrease = attacker:GetRuneValue("w", 2) * EPOCH_W2_POST_MITI_PCT * math.abs(victim:GetPhysicalArmorValue(false)) / 10
					mult = mult + multIncrease / 100
				end
			end
		end
	end
	if victim:HasModifier("modifier_astral_rune_e_1_visible") then
		local modifier = victim:FindModifierByName("modifier_astral_rune_e_1_invisible")
		local stacks = modifier:GetStackCount()
		local multIncrease = ASTRAL_E1_POSTMIT_PCT/100 * stacks
		mult = mult + multIncrease
	end
	if victim:HasModifier("modifier_voltex_static_field_post_mitigation") then
		local modifier = victim:FindModifierByName("modifier_voltex_static_field_post_mitigation")
		if modifier:GetCaster() == attacker then
			local stack_value = modifier:GetAbility():GetSpecialValueFor("post_mitigation_per_spark")
			local stacks = modifier:GetStackCount()
			local multIncrease = (stack_value / 100) * stacks
			mult = mult + multIncrease
		end
	end
	if victim:HasModifier("crystal_arrow_ad_aura") then
		local modifier = victim:FindModifierByName("crystal_arrow_ad_aura")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local abil = modifier:GetAbility()
			mult = mult + abil.r_1_level * 0.05
		end
	end
	if victim:HasModifier("modifier_rockfall_post_mit") then
		mult = mult + 1.25
	end
	if victim:HasModifier("modifier_astral_d_b_visible") then
		modifier = victim:FindModifierByName("modifier_astral_d_b_invisible")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = 0.009 * stacks
			mult = mult + multIncrease
		end
	end
	if attacker:HasModifier("modifier_bahamut_arcana_post_mit") then
		local bahamut = attacker:FindModifierByName("modifier_bahamut_arcana_post_mit"):GetCaster()
		local stacks = attacker:GetModifierStackCount("modifier_bahamut_arcana_post_mit", bahamut)
		mult = mult + stacks * 0.06
	end
	if victim:HasModifier("modifier_wolf_rend_bleed") then
		modifier = victim:FindModifierByName("modifier_wolf_rend_bleed")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local multIncrease = DJANGHOR_W2_POST_MIT_PCT / 100 * modifier:GetAbility().w_2_level
			mult = mult + multIncrease
		end
	end

	if victim:HasModifier("modifier_water_mage_slow") then
		modifier = victim:FindModifierByName("modifier_water_mage_slow")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			mult = mult + WATER_MAGE_ROBES_POST_MITI_AMP/100
		end
	end
	if victim:HasModifier("modifier_arkimus_c_b_sprinting") then
		if victim:HasModifier("modifier_arkimus_immortal_weapon_3") then
			filterTable["damage"] = 0.01
		end
	end
	if attacker:HasModifier("modifier_conjuror_glyph_5_a") or attacker:HasModifier("modifier_conjuror_glyph_5_a_summon") then
		mult = mult + 2
	end
	if attacker:HasModifier("modifier_buzukis_finger_buff") or attacker:HasModifier("challen_postmit_buff") then
		mult = mult + BUZUKIS_FINGER_POST_MITI/100
	end
	if attacker:HasModifier("modifier_earthshock_damage_reduce") then
		local modifierCaster = attacker:FindModifierByName("modifier_earthshock_damage_reduce"):GetCaster()
		local stacks = attacker:GetModifierStackCount("modifier_earthshock_damage_reduce", modifierCaster)
		filterTable["damage"] = filterTable["damage"] - (filterTable["damage"] * math.min((CONJUROR_ARCANA_Q4_DAMAGE_REDUCE_PCT / 100) * stacks, 0.9))
	end
	if victim:HasModifier("modifier_swarm_effect") then
		local multIncrease = victim:GetModifierStackCount("modifier_swarm_effect", victim.umbral) * EKKAN_ARCANA_Q2_POST_MITI
		mult = mult + multIncrease
	end
	if victim:HasModifier("modifier_witch_hat_damage_amp") then
		modifier = victim:FindModifierByName("modifier_witch_hat_damage_amp")
		local stacks = modifier:GetStackCount()
		local multIncrease = 0.15 * stacks
		mult = mult + multIncrease
	end

	local modifier = victim:FindModifierByName("modifier_draghor_hawk_screech")
	if modifier then
		mult = mult + modifier:GetStackCount()
	end

	if attacker:HasModifier("modifier_drowning_pool_actual_effect") then
		modifier = attacker:FindModifierByName("modifier_drowning_pool_actual_effect")
		local stacks = modifier:GetStackCount()
		local damageIncrease = stacks * HYDROXIS_R4_DMG_AMP_PCT/100
		filterTable["damage"] = filterTable["damage"] + filterTable["damage"] * damageIncrease
	end
	if attacker:HasModifier("modifier_flamewaker_arcana1") then
		local self_mult = 0
		local stack_mult = 0
		if attacker:HasModifier("modifier_flamewaker_arcana_b_a_effect") then
			self_mult = 0.03 * attacker:GetModifierStackCount("modifier_flamewaker_arcana_b_a_effect", attacker)
		end
		if victim:HasModifier("modifier_flamewaker_arcana_b_a_effect_stacking_invisible") then
			stack_mult = 0.005 * victim:GetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_invisible", attacker)
		end
		local multIncrease = math.max(self_mult, stack_mult)
		mult = mult + multIncrease
	end
	if attacker:HasModifier("modifier_voltex_immortal_weapon_1") then
		mult = mult + VOLTEX_IMMORTAL_WEAPON_1_POST_MITI_BONUS
	end
	if attacker:HasModifier("modifier_machinal_jump_c_c_amp") then
		modifier = attacker:FindModifierByName("modifier_machinal_jump_c_c_amp")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = ARKIMUS_E3_POST_MITI/100 * stacks
			mult = mult + multIncrease
		end
	end
	if victim:HasModifier("modifier_reaper_slice_amp_debuff") then
		modifier = victim:FindModifierByName("modifier_reaper_slice_amp_debuff")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = 0.02 * stacks
			mult = mult + multIncrease
		end
	end

	if victim:HasModifier("modifier_warlord_b_d_effect") then
		modifier = victim:FindModifierByName("modifier_warlord_b_d_effect")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			local multIncrease = 0.05 * stacks
			mult = mult + multIncrease
		end
	end
	if attacker:HasModifier("modifier_flamewaker_arcana_d_a_aura") then
		modifier = attacker:FindModifierByName("modifier_flamewaker_arcana_d_a_aura")
		if victim:GetEntityIndex() == modifier:GetCaster():GetEntityIndex() then
			local stacks = modifier:GetAbility().q_4_level
			local damageReduc = math.min(stacks * 0.015, 0.9)
			filterTable["damage"] = filterTable["damage"] * (1 - damageReduc)
		end
	end
	if attacker:HasModifier("modifier_terrasic_stone_plate") then
		if victim:IsStunned() or victim:HasModifier("modifier_knockback") or victim:IsFakeStunned() then
			mult = mult + TERRASIC_STONE_PLATE_POST_MITI/100
		end
	end
	if attacker:HasModifier("modifier_warlord_arcana2") then
		if victim:IsStunned() or victim:HasModifier("modifier_knockback") or victim:IsFakeStunned() then
			local mult_bonus = attacker:GetRuneValue("q", 3)*(WARLORD_ARCANA2_Q1_POST_MIT/100)
			mult = mult + mult_bonus
		end
	end
	if attacker:HasModifier("modifier_steelforge_passive") then
		if victim:IsStunned() or victim:HasModifier("modifier_knockback") or victim:IsFakeStunned() then
			mult = mult + ARCANA1_W2_POSTMITIGATION_PERCENT / 100 * attacker.w_2_level
		end
	end
	if attacker:HasModifier("modifier_energy_channel") then
		local w_2_level = attacker:GetRuneValue("w", 2)
		mult = mult + MOUNTAIN_PROTECTOR_W2_POSTMIT_PCT / 100 * w_2_level
	end
	if attacker:HasModifier("modifier_paladin_glyph_6_2") then
		local immortalOrArcanaCount = RPCItems:GetEquippedItemsBelowRarity(attacker, 5)
		mult = mult + immortalOrArcanaCount * 2.4
	end
	if attacker:HasModifier("modfier_razor_band_stacks") then
		local modifier = attacker:FindModifierByName("modfier_razor_band_stacks")
		local stacks = modifier:GetStackCount()
		mult = mult + (RAZOR_BAND_POST_MITIGATION_PER_STACK/100)*stacks
	end
	if attacker:HasModifier("modifier_waterheart_weapon") then
		local waterheart = attacker:FindModifierByName("modifier_waterheart_weapon"):GetAbility()
		if waterheart then
			mult = mult + SPIRIT_WARRIOR_ARCANA_R3_POST_MITI_PCT/100 * waterheart.r_3_level
		end
	end
	if attacker:HasModifier("modifier_bahamut_charge_of_light_postmitigation") then
		local stacks = attacker:GetModifierStackCount("modifier_bahamut_charge_of_light_postmitigation", attacker)
		mult = mult + BAHAMUT_R2_POST_MITI_PCT/100 * stacks
	end

	if attacker:GetUnitName() == "npc_dota_hero_arc_warden" then
		if attacker.r_4_level then
			mult = mult + 0.06 * attacker.r_4_level
		end
	end
	if attacker:HasModifier("modifier_hydroxis_basin_d_d") then
		local stacks = attacker:GetModifierStackCount("modifier_hydroxis_basin_d_d", attacker)
		mult = mult + HYDROXIS_ARCANA_R4_POST_MITI_PCT/100 * stacks
	end
	if attacker:HasModifier("modifier_apollo_post_mit_invisible") then
		if attacker:HasAbility("shot_of_apollo") then
			if attacker:FindAbilityByName("shot_of_apollo").w_4_target == victim then
				local stacks = attacker:GetModifierStackCount("modifier_apollo_post_mit_invisible", attacker)
				mult = mult + 0.007 * stacks
			end
		end
	end
	if attacker:HasModifier("modifier_jex_root_weave_debuff") then
		if attacker:FindModifierByName("modifier_jex_root_weave_debuff"):GetCaster():HasModifier("modifier_jex_glyph_5_1") then
			filterTable["damage"] = filterTable["damage"] * 0.5
		end
	end
	if victim:HasModifier("tanari_mountain_specter_ai") then
		local reduc = 0.1
		if GameState:GetDifficultyFactor() == 2 then
			reduc = 0.9
		elseif GameState:GetDifficultyFactor() == 3 then
			reduc = 0.996
		end
		if victim.mainBoss then
			filterTable["damage"] = filterTable["damage"] / 25
		end
		filterTable["damage"] = filterTable["damage"] * (1 - reduc)
	end
	if attacker:HasModifier("tanari_mountain_specter_ai") then
		filterTable["damage"] = filterTable["damage"] * 1.2
	end
	if victim:HasModifier("modifier_water_jailer_passive") then
		local abil = victim:FindModifierByName("modifier_water_jailer_passive"):GetAbility()
		local reduc = abil:GetSpecialValueFor("damage_block")/100
		filterTable["damage"] = filterTable["damage"] * (1 - reduc)
	end
	if victim:HasModifier("modifier_wind_temple_key_stone_form") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_windsteel_effect") then
		filterTable["damage"] = Filters:WindSteelTakeDamage(victim, filterTable["damage"])
	end
	if victim:HasModifier("modifier_vitali_shield") then
		filterTable["damage"] = 0
		victim:RemoveModifierByName("modifier_vitali_shield")
	end
	if victim:HasModifier("modifier_secret_temple_refraction") then
		filterTable["damage"] = Filters:SecretTempleTakeDamage(victim, filterTable["damage"])
	end
	if victim:HasModifier("modifier_solunia_glyph_5_1_shield") then
		filterTable["damage"] = Filters:SoluniaGlyph51TakeDamage(victim, filterTable["damage"])
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
	if attacker:HasModifier("modifier_gravekeeper_gauntlet_buff") and not damageData.ignoreMultipliers and not damageData.ignorePremitigation then
		local stacks = attacker:GetModifierStackCount("modifier_gravekeeper_gauntlet_buff", attacker.InventoryUnit)
		filterTable["damage"] = filterTable["damage"] * (1 + (stacks * GRAVEKEEPER_PRE_MITI_DAMAGE_AMP_PER_STACK))
	end
	if attacker:HasModifier("modifier_neutral_glyph_5_3") and not damageData.ignoreMultipliers and not damageData.ignorePremitigation then
		if damagetype == DAMAGE_TYPE_PHYSICAL then
			filterTable["damage"] = filterTable["damage"] * 1.5
		end
		if damagetype == DAMAGE_TYPE_MAGICAL then
			filterTable["damage"] = filterTable["damage"] * 0.5
		end
	end

	if victim:HasModifier("modifier_firelord_ability_ai") then
		if GameState:GetDifficultyFactor() == 3 then
			filterTable["damage"] = filterTable["damage"] * 0.2
			if Events.SpiritRealm then
				filterTable["damage"] = filterTable["damage"] * 0.3
			end
		end
	end
	if victim:HasModifier("modifier_guard_of_grithault") then
		filterTable["damage"] = Filters:GrithaultDamage(victim, filterTable["damage"])
	end
	-- if attacker:HasModifier("modifier_warlord_glyph_3_1") then
	-- if attacker.warlordElement then
	-- if attacker.warlordElement == "ice" and damagetype == DAMAGE_TYPE_MAGICAL then
	-- filterTable["damage"] = filterTable["damage"]*1.4
	-- end
	-- end
	-- end
	if victim:HasModifier("modifier_aeriths_tear") then
		if Filters:AerithsTearTakeDamage(attacker, victim) then
			filterTable["damage"] = filterTable["damage"] * (100-AERITHS_TEAR_DMG_REDUCTION)/100
		end
	end
	if victim:HasModifier("modifier_infernal_jailer_passive") then
		local distance = WallPhysics:GetDistance(victim:GetAbsOrigin(), attacker:GetAbsOrigin())
		if distance > 360 then
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_batrider/batrider_firefly_startflash.vpcf", victim, 1)
			filterTable["damage"] = filterTable["damage"] * 0.001
		end
	end
	if victim:HasModifier("modifier_azalea_dragoon_passive") then
		local distance = WallPhysics:GetDistance2d(victim:GetAbsOrigin(), attacker:GetAbsOrigin())
		local passive = victim:FindAbilityByName("winterblight_azalea_dragoon_passive")
		local distanceCompare = passive:GetSpecialValueFor("distance")
		local damageReduce = passive:GetSpecialValueFor("damage_block")
		if distance > distanceCompare then
			if victim:GetUnitName() == "azalea_dragoon" then
				StartAnimation(victim, {duration=0.5, activity=ACT_DOTA_THUNDER_STRIKE, rate=1.8})
			else
				StartAnimation(victim, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.1})
			end
			EmitSoundOn("Winterblight.Dragoon.Block", victim)
			if not passive.particleLock then
				CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/dragoon_block.vpcf", victim, 1)
				passive.particleLock = true
				Timers:CreateTimer(1, function()
					passive.particleLock = false
				end)
			end
			filterTable["damage"] = filterTable["damage"] * (1 - (damageReduce / 100))
		end
	end
	if victim:HasModifier("modifier_spectral_witch_passive") then
		local distance = WallPhysics:GetDistance(victim:GetAbsOrigin(), attacker:GetAbsOrigin())
		if distance > 600 then
			local abil = victim:FindModifierByName("modifier_spectral_witch_passive"):GetAbility()
			local reduction = abil:GetLevelSpecialValueFor("damage_reduction", abil:GetLevel())
			filterTable["damage"] = filterTable["damage"] * (1 - (reduction / 100))
		end
	end
	if victim:HasModifier("modifier_tempest_haze_effect_friendly") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			modifier = victim:FindModifierByName("modifier_tempest_haze_effect_friendly")
			if modifier:GetCaster():GetEntityIndex() == victim:GetEntityIndex() then
				filterTable["damage"] = filterTable["damage"] * 0.2
			end
		end
	end
	if victim:HasModifier("modifier_dinath_glyph_5_a") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			if not victim:HasModifier("modifier_golden_scale_immunity") then
				local immo_glyph = victim.immo_glyph_data
				immo_glyph.ability:ApplyDataDrivenModifier(immo_glyph.caster, victim, "modifier_black_King_bar_immunity", {duration = DINATH_GLYPH_5_A_MAGIC_IMMUNITY_DURATION})
				immo_glyph.ability:ApplyDataDrivenModifier(immo_glyph.caster, victim, "modifier_golden_scale_immunity", {duration = DINATH_GLYPH_5_A_MAGIC_IMMUNITY_CD})
			end
		end
	end
	if attacker:HasModifier("modifier_epoch_arcana_passive") then
		local q_2_level = attacker:GetRuneValue("q", 2)
		local championArmor = math.max(attacker:GetPhysicalArmorBaseValue(), 0)
		if q_2_level > 0 then
			local multIncrease = (victim:GetPhysicalArmorBaseValue() + championArmor) * q_2_level * EPOCH_ARCANA_Q2_POST_MITI_PCT
			mult = mult + multIncrease / 100000 --per 1000 armor, %
		end
	end
	if attacker:HasModifier("modifier_zhonic_arcana_c_c_invisible") then
		local stacks = attacker:GetModifierStackCount("modifier_zhonic_arcana_c_c_invisible", attacker)
		local multIncrease = stacks * ZHONIK_E3_ARCANA_POST_MITI_AMP_PCT / 100
		mult = mult + multIncrease
	end
	if attacker:HasModifier("modifier_general_postmitigation") then
		local stacks = attacker:GetModifierStackCount("modifier_general_postmitigation", Events.GameMaster)
		local multIncrease = stacks / 100
		mult = mult + multIncrease
	end
	if attacker:HasModifier("modifier_azalea_knife_postmitigation") then
		if victim:IsRooted() then
			local multIncrease = 5
			mult = mult + multIncrease
		end
	end
	if attacker:HasModifier("modifier_sunstrider_sunwarrior_vengeance_post_mit") then
		local stacks = attacker:GetModifierStackCount("modifier_sunstrider_sunwarrior_vengeance_post_mit", attacker)
		local multIncrease = stacks * SEINARU_ARCANA_E3_POSTMIT
		mult = mult + multIncrease
	end
	if victim:HasModifier("modifier_auriun_immortal_weapon_1") then
		filterTable["damage"] = Filters:AuriunImmortalWeapon1(filterTable["damage"], victim)
	end

	if victim:HasModifier("modifier_paladin_d_c") then
		modifier = victim:FindModifierByName("modifier_paladin_d_c")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + 0.25 * stacks
		end
	end
	if victim:HasModifier("modifier_lightbomb_postmit") then
		modifier = victim:FindModifierByName("modifier_lightbomb_postmit")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + SEPHYR_Q2_POSTMIT * stacks
		end
	end
	if victim:HasModifier("modifier_stonewall_aura_enemy_effect") then
		modifier = victim:FindModifierByName("modifier_stonewall_aura_enemy_effect")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetCaster():GetRuneValue("w", 1)
			mult = mult + 0.05 * stacks
		end
	end
	if victim:HasModifier("modifier_hyperbeam_postmit") then
		modifier = victim:FindModifierByName("modifier_hyperbeam_postmit")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + DINATH_R2_POST_MITI * stacks
		end
	end
	if victim:HasModifier("modifier_slipfinn_gloomshade_invisible") then
		modifier = victim:FindModifierByName("modifier_slipfinn_gloomshade_invisible")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + 0.015 * stacks
		end
	end
	if attacker:HasModifier("modifier_paladin_d_c_postmit") then
		local stacks = attacker:GetModifierStackCount("modifier_paladin_d_c_postmit", attacker)
		mult = mult + 0.01 * stacks
	end
	if victim:HasModifier("modifier_tachyon_amp") then
		modifier = victim:FindModifierByName("modifier_tachyon_amp")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + stacks * ZHONIK_Q3_POST_MITI_AMP_PCT / 100
		end
	end
	if victim:HasModifier("modifier_hailstorm_enemy_amp") then
		modifier = victim:FindModifierByName("modifier_hailstorm_enemy_amp")
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local stacks = modifier:GetStackCount()
			mult = mult + 0.09 * stacks
		end
	end
	if attacker:HasModifier("modifier_hood_of_the_sea_oracle") then
		if victim:HasModifier("modifier_sea_oracle_stacker") then
			local stacks = victim:GetModifierStackCount("modifier_sea_oracle_stacker", attacker.InventoryUnit)
			if stacks >= HOOD_OF_SEA_ORACLE_MAX_STACKS then
				mult = mult + HOOD_OF_SEA_ORACLE_POST_MITI/100
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
		if attacker.q_2_level then
			mult = mult + 0.035 * attacker.q_2_level
		end
	end
	if Filters:IsFireBurning(victim) and attacker:HasModifier('modifier_fire_ring_passive') then
		if attacker.q_2_level then
			mult = mult + 0.035 * attacker.q_2_level
		end
	end

	mult = mult + heroes.venomort.getPostMitigation(attacker, victim)

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
	if victim:HasModifier("modifier_icewind_shield") then
		filterTable["damage"] = 0
		if applyEffects then
			local shieldCaster = victim:FindModifierByName("modifier_icewind_shield"):GetCaster()
			CustomAbilities:HitShieldGeneric(victim, attacker, shieldCaster, "modifier_icewind_shield")
		end
	end
	if victim:HasModifier("modifier_black_dominion_shield") then
		filterTable["damage"] = 0
		if applyEffects then
			local shieldCaster = victim:FindModifierByName("modifier_black_dominion_shield"):GetCaster()
			CustomAbilities:HitShieldGeneric(victim, attacker, shieldCaster, "modifier_black_dominion_shield")
		end
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
	if victim:HasModifier("modifier_omniro_nature_shield") then
		if filterTable["damage"] > 0 then
			filterTable["damage"] = 0
			local shieldCaster = victim:FindModifierByName("modifier_omniro_nature_shield"):GetCaster()
			CustomAbilities:HitShieldGeneric(victim, attacker, victim, "modifier_omniro_nature_shield")
		end
	end
	if victim:HasModifier("modifier_ice_throw_b_b_frozen") then
		modifier = victim:FindModifierByName("modifier_ice_throw_b_b_frozen")
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PHYSICAL then
			local stacks = modifier:GetStackCount()
			filterTable["damage"] = filterTable["damage"] + filterTable["damage"] * 0.07 * stacks
		end
	end
	if victim:HasModifier("modifier_voltex_d_b_debuff") then
		modifier = victim:FindModifierByName("modifier_voltex_d_b_debuff")
		if damagetype == DAMAGE_TYPE_MAGICAL then
			if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
				local stacks = modifier:GetStackCount()
				filterTable["damage"] = filterTable["damage"] + filterTable["damage"] * 0.2 * stacks
			end
		end
	end
	if attacker:HasModifier("modifier_golden_war_plate") then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			filterTable["damage"] = filterTable["damage"] * (100-GOLDEN_WARPLATE_MAGIC_OUTPUT_REDUCTION)/100
		end
	end
	if victim:HasModifier("moon_tech_aura") then
		modifier = victim:FindModifierByName("moon_tech_aura")
		local modifierCaster = modifier:GetCaster()
		if attacker:GetEntityIndex() == modifierCaster:GetEntityIndex() then
			local movespeed = attacker:GetBaseMoveSpeed()
			local movespeedAttacker = attacker:GetMoveSpeedModifier(movespeed, false)
			movespeed = victim:GetBaseMoveSpeed()
			local movespeedVictim = victim:GetMoveSpeedModifier(movespeed, false)
			local amp = math.max((movespeedAttacker - movespeedVictim) / 100, 0)
			mult = mult + amp
		end
	end
	if victim:HasModifier("modifier_mach_punch_amp") then
		modifier = victim:FindModifierByName("modifier_mach_punch_amp")
		local modifierCaster = modifier:GetCaster()
		if attacker:GetEntityIndex() == modifierCaster:GetEntityIndex() then
			local movespeed = attacker:GetBaseMoveSpeed()
			local movespeedAttacker = attacker:GetMoveSpeedModifier(movespeed, false)
			movespeed = victim:GetBaseMoveSpeed()
			local movespeedVictim = victim:GetMoveSpeedModifier(movespeed, false)
			-- local amp = math.max((movespeedAttacker-movespeedVictim)/100, 0)
			local amp = (movespeedAttacker - movespeedVictim) / 100
			mult = mult + amp
			victim:RemoveModifierByName("modifier_mach_punch_amp")
		end
	end
	if victim:HasModifier("modifier_enchanted_solar_cape") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			victim.body:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_enchanted_solar_cape_effect", {duration = SOLAR_CAPE_DURATION})
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
		local bladestormStacks = math.min(attacker:GetModifierStackCount("modifier_bladestorm_vest_buff", attacker.body) + 1, 3)
		mult = mult + bladestormStacks * BLADESTORM_POST_MITI/100
	end
	if victim:HasModifier("modifier_duskbringer_rune_e_2_effect") then
		filterTable["damage"] = 0
		Filters:GhostArmor(victim, attacker)
	end

	if attacker:HasModifier("modifier_soul_thrust_effect") then
		modifier = attacker:FindModifierByName("modifier_soul_thrust_effect"):GetCaster()
		if modifier:GetEntityIndex() == victim:GetEntityIndex() then
			filterTable["damage"] = filterTable["damage"] * 0.5
		end
	end

	if victim:HasModifier("modifier_paladin_q3_shield") then
		filterTable["damage"] = 0
		Filters:ShatterPaladinShell(victim, attacker)
	end
	if victim:HasModifier("modifier_voltex_rune_w_3_shield") then
		filterTable["damage"] = 0
		Filters:ShatterVoltexShell(victim, attacker)
	end

	if attacker:HasModifier("modifier_flurry_aura_debuff") then
		filterTable["damage"] = filterTable["damage"] * (100-SKYFORGE_DMG_REDUCTION)/100
	end
	if attacker:HasModifier("modifier_neutral_glyph_5_1") then
		filterTable["damage"] = filterTable["damage"] * 0.5
	end
	if attacker:HasModifier("modifier_neutral_glyph_5_2") and not damageData.ignoreMultipliers and not damageData.ignorePremitigation then
		filterTable["damage"] = filterTable["damage"] * 1.35
	end

	if victim:HasModifier("modifier_emerald_douli") then
		local reductionPercent = Filters:EmeraldDouliHit(victim, filterTable["damage"])
		filterTable["damage"] = filterTable["damage"] - filterTable["damage"] * reductionPercent
	end

	if victim:GetTeamNumber() == DOTA_TEAM_NEUTRALS and victim:GetUnitName() ~= "arena_training_dummy" then
		if GameState:GetDifficultyFactor() == 2 then
			if victim.mainBoss then
				filterTable["damage"] = filterTable["damage"] * 0.4
			elseif victim.bossStatus then
				filterTable["damage"] = filterTable["damage"] * 0.6
			else
				filterTable["damage"] = filterTable["damage"] * 1
				difficultyDamageReduce = 1
			end
		elseif GameState:GetDifficultyFactor() == 3 then
			if victim.mainBoss then
				filterTable["damage"] = filterTable["damage"] * 0.1
			elseif victim.bossStatus then
				filterTable["damage"] = filterTable["damage"] * 0.25
			else
				filterTable["damage"] = filterTable["damage"] * 0.6
				difficultyDamageReduce = 0.6
			end
		end
	end
	if victim:HasModifier("modifier_arena_pit_of_trials_enemy") then
		filterTable["damage"] = filterTable["damage"] * Arena:GetResistancePercentage()
	end
	if attacker:HasModifier("modifier_arena_pit_of_trials_enemy") then
		filterTable["damage"] = filterTable["damage"] + filterTable["damage"] * (Arena:GetDamageStacks() / 10)
	end
	if victim:HasModifier("modifier_arena_enemy") or victim:HasModifier("modifier_general_reduc") then
		if victim.damageReduc then
			filterTable["damage"] = filterTable["damage"] * victim.damageReduc
			if victim:GetUnitName() == "champion_league_challenger_2" then
				filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth() * 0.01)
			elseif victim:GetUnitName() == "champion_league_challenger_1" then
				filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth() * 0.008)
			else
				filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth() * 0.07)
			end
			filterTable["damage"] = math.max(filterTable["damage"], victim:GetMaxHealth() * 0.001)
		end
	end
	if attacker:HasModifier("modifier_arena_crowd_buff") then
		local stacks = attacker:GetModifierStackCount("modifier_arena_crowd_buff", Arena.ArenaMaster)
		local crowdDamageAmp = 1 + (stacks * 0.1)
		filterTable["damage"] = filterTable["damage"] * crowdDamageAmp
	end
	if victim:HasModifier("modifier_twig_of_the_enlightened_shield") then
		filterTable["damage"] = Filters:TwigTakeDamage(filterTable["damage"], victim)
	end
	if victim:HasModifier("modifier_grasp_of_elder_shield") then
		filterTable["damage"] = Filters:ElderGraspTakeDamage(filterTable["damage"], victim)
	end
	if victim:HasModifier("modifier_phoenix_boss_passive") then
		if filterTable["damage"] > (victim:GetMaxHealth() * 0.02) then
			filterTable["damage"] = victim:GetMaxHealth() * 0.02
		end
	end
	if victim:GetUnitName() == "phoenix_nest_egg" then
		if GameState:GetDifficultyFactor() == 3 then
			filterTable["damage"] = filterTable["damage"] * 0.05
		end
	end
	if victim:HasModifier("modifier_fire_key_holder_steam") then
		Tanari:FireKeyHolderSteam(victim, damagetype)
	end
	if victim:HasModifier("modifier_brazen_kabuto_channeling") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_brazen_kabuto_shield") then
		filterTable["damage"] = filterTable["damage"] * (1 - KABUTO_SHIELD_RESISTANCE)
	end
	if victim:HasModifier("modifier_ancient_hero_water_god") then
		if damagetype == DAMAGE_TYPE_PURE then
			filterTable["damage"] = filterTable["damage"] * 0.8
			if Events.SpiritRealm then
				filterTable["damage"] = filterTable["damage"] * 0.7
			end
		else
			filterTable["damage"] = 0
		end
	end
	if victim:HasModifier("modifier_ancient_hero_wind_god") then
		if damagetype == DAMAGE_TYPE_PHYSICAL then
			filterTable["damage"] = filterTable["damage"] * 0.8
			if Events.SpiritRealm then
				filterTable["damage"] = filterTable["damage"] * 0.7
			end
		else
			filterTable["damage"] = 0
		end
	end

	if victim:HasModifier("modifier_ancient_hero_fire_god") then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			filterTable["damage"] = filterTable["damage"] * 0.8
			if Events.SpiritRealm then
				filterTable["damage"] = filterTable["damage"] * 0.7
			end
		else
			filterTable["damage"] = 0
		end
	end
	if victim:HasModifier("modifier_ethereal_revenant_link") and not damageData.ignoreMultipliers and not damageData.ignorePremitigation then
		if victim.revenantData then
			if victim.revenantData[1] == attacker:GetEntityIndex() then
				filterTable["damage"] = filterTable["damage"] * ETHEREAL_REVENANT_DAMAGE_AMP
			end
		end
	end
	if attacker:HasModifier("modifier_ethereal_revenant_link") then
		if attacker.revenantData then
			if attacker.revenantData[1] == victim:GetEntityIndex() then
				filterTable["damage"] = filterTable["damage"] * (100-ETHEREAL_REVENANT_DAMAGE_REDUCTION_PCT)/100
			end
		end
	end
	modifier = attacker:FindModifierByName('modifier_baron_storm_link')
	if modifier and modifier:GetCaster() == victim then
		filterTable["damage"] = filterTable["damage"] * (1 - BARON_STORM_DMG_RESISTANCE)
	end
	if attacker:HasModifier("modifier_gorudo_b_d_inside_ring") then
		modifier = attacker:FindModifierByName("modifier_gorudo_b_d_inside_ring")
		if victim:GetEntityIndex() == modifier:GetCaster():GetEntityIndex() then
			if attacker:HasModifier('modifier_seinaru_glyph_6_1') then
				filterTable["damage"] = filterTable["damage"] * (1 - SEINARU_GLYPH6_R2_DMG_RED)
			else
				filterTable["damage"] = filterTable["damage"] * (1 - SEINARU_R2_DMG_RED)
			end
		end
	end
	if victim:HasModifier("modifier_gorudo_b_d_inside_ring") and not damageData.ignoreMultipliers and not damageData.ignorePremitigation then
		modifier = victim:FindModifierByName("modifier_gorudo_b_d_inside_ring")
		if attacker:GetEntityIndex() == modifier:GetCaster():GetEntityIndex() then
			local r_4_level = attacker:FindAbilityByName("seinaru_gorudo").r_4_level
			filterTable["damage"] = filterTable["damage"] * (1 + r_4_level * SEINARU_R4_POSTMIT_MULT)
		end
	end
	if filterTable.entindex_inflictor_const and not damageData.ignoreMultipliers and not damageData.ignorePremitigation then
		local ability = attacker:FindAbilityByName(EntIndexToHScript(filterTable.entindex_inflictor_const):GetName())
		if ability then
			if attacker:HasModifier("modifier_bahamut_arcana_w4_amp") and not attacker:HasModifier("modifier_bahamut_arcana_w4_amp_linger") then
				local stacks = attacker:FindModifierByName("modifier_bahamut_arcana_w4_amp"):GetStackCount()
				filterTable["damage"] = filterTable["damage"] * (1 + stacks / 100)
			end
			if attacker:HasModifier("modifier_bahamut_arcana_w4_amp_linger") then
				local stacks = attacker:FindModifierByName("modifier_bahamut_arcana_w4_amp_linger"):GetStackCount()
				filterTable["damage"] = filterTable["damage"] * (1 + stacks / 100)
			end
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
		if victim:GetTeamNumber() == DOTA_TEAM_NEUTRALS and victim:GetUnitName() ~= "arena_training_dummy" then
			filterTable["damage"] = filterTable["damage"] / 6
		end
		if attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
			filterTable["damage"] = filterTable["damage"] * 2
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
	if victim:HasModifier("modifier_warlord_ice_shell_pure") then
		if filterTable["damagetype_const"] == DAMAGE_TYPE_PURE then
			filterTable["damage"] = 0
			Filters:WarlordTakePureDamage(victim)
		end
	end
	if victim:HasModifier("modifier_demon_farmer_mark_passive") then
		if attacker:HasModifier("modifier_demon_farmer_mark_effect") then
		else
			filterTable["damage"] = 0
		end
	end
	if victim:HasModifier("modifier_castle_sorceress_flamespitting") then
		if filterTable["damage"] > victim:GetMaxHealth() * 0.01 then
			filterTable["damage"] = CustomAbilities:CastleSorceressDamage(victim, filterTable["damage"])
		end
	end
	if victim:HasModifier("modifier_conquest_boss_ai") then
		if filterTable["damagetype_const"] == DAMAGE_TYPE_MAGICAL or filterTable["damagetype_const"] == DAMAGE_TYPE_PHYSICAL then
			filterTable["damage"] = 0
		end
	end

	if victim:HasModifier("modifier_starseeker_passive") then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			victim:Heal(filterTable["damage"], victim)
			PopupHealing(victim, filterTable["damage"])
			filterTable["damage"] = 0
		end
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
	if victim:HasModifier("modifier_arkimus_glyph_5_1") then
		local damageReduction = Filters:SpellShieldHit(victim, filterTable["damage"])
		filterTable["damage"] = filterTable["damage"] - damageReduction
	end
	if attacker:HasModifier("modifier_sea_fortress_ai") and (damageType == DAMAGE_TYPE_PURE or damageType == DAMAGE_TYPE_MAGICAL) then
		filterTable["damage"] = filterTable["damage"] * 3
	end
	if victim:HasModifier("modifier_demon_hunter") then
		filterTable["damage"] = CustomAbilities:ChernobogDemonHunter(victim, filterTable["damage"])
	end

	if victim:HasModifier("modifier_hydroxis_mist_debuff") or victim:HasModifier("modifier_hydroxis_mist_debuff_timered") then
		modifier = victim:FindModifierByName("modifier_hydroxis_mist_debuff")
		if not modifier then
			modifier = victim:FindModifierByName("modifier_hydroxis_mist_debuff_timered")
		end
		if modifier:GetCaster():GetEntityIndex() == attacker:GetEntityIndex() then
			local w_3_level = attacker:GetRuneValue("w", 3)
			if w_3_level > 0 then
				mult = mult + HYDROXIS_ARCANA_W3_POST_MITI_PCT/100 * w_3_level
			end
		end
	end

	if attacker:HasModifier("modifier_crystalline_slippers") and not damageData.ignoreMultipliers and not damageData.ignorePremitigation then
		if victim:IsRooted() then
			filterTable["damage"] = filterTable["damage"] * CRYSTALLINE_PRE_MITI_AMP
		end
	end
	if attacker:HasModifier("modifier_boss_illusion_ability_effect") then
		filterTable["damage"] = filterTable["damage"] * 0.1
	end
	if victim:HasModifier("modifier_paladin_q4_shield") then
		local damageAbsorb = math.min(filterTable["damage"], victim.paladin_q4_absorb)
		victim.paladin_q4_absorb = math.max(victim.paladin_q4_absorb - damageAbsorb, 0)
		if victim.paladin_q4_absorb <= 0 then
			victim:RemoveModifierByName("modifier_paladin_q4_shield")
		end
		filterTable["damage"] = filterTable["damage"] - damageAbsorb
	end
	if victim:HasModifier("modifier_seinaru_rune_w_3_shield") then
		local damageAbsorb = math.min(filterTable["damage"], victim.seinaru_c_b_absorb)
		victim.seinaru_c_b_absorb = math.max(victim.seinaru_c_b_absorb - damageAbsorb, 0)
		if victim.seinaru_c_b_absorb <= 0 then
			victim:RemoveModifierByName("modifier_seinaru_rune_w_3_shield")
		end
		filterTable["damage"] = filterTable["damage"] - damageAbsorb
	end
	if victim:HasModifier("modifier_fire_aspect") then
		if filterTable["damage"] > victim:GetMaxHealth() * 0.2 then
			filterTable["damage"] = victim:GetMaxHealth() * 0.2
		end
	end
	if victim:HasModifier("modifier_fire_spirit_boss_passive") then
		filterTable["damage"] = filterTable["damage"] * 0.4
	end
	if victim:HasModifier("modifier_serengaard_wave_unit") then
		if Serengaard.InfiniteWaveCount then
			--  local flatFactor = math.max(1-(Serengaard.InfiniteWaveCount/10), 0.04)
			-- local damageMult = 1 - (0.1*Serengaard.InfiniteWaveCount/(flatFactor + (0.1 * math.abs(Serengaard.InfiniteWaveCount))))
			-- damageMult = damageMult/3
			local damageMult = 0.92 ^ Serengaard.InfiniteWaveCount
			filterTable["damage"] = filterTable["damage"] * damageMult
		end
	end
	if attacker:HasModifier("modifier_serengaard_wave_unit") then
		if Serengaard.InfiniteWaveCount then
			filterTable["damage"] = filterTable["damage"] + filterTable["damage"] * 0.12 * Serengaard.InfiniteWaveCount
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
		filterTable["damage"] = filterTable["damage"] * seaFortReduc
		if victim.reduc then
			filterTable["damage"] = filterTable["damage"] * victim.reduc
		end
	end
	if victim:HasModifier("modifier_winterblight_cavern_unit") then
		local chamber_level = 1
		if victim.chamber == 0 then
			chamber_level = victim.boss_level
		else
			chamber_level = Winterblight.CavernData.Chambers[victim.chamber]["level"]
		end
		local reduction = 0.74^chamber_level
		if victim.boss_level then
			reduction = reduction*0.1
		end
		if Winterblight:IsWithinChamber(attacker, victim.chamber) then
		else
			if applyEffects then
				print("damage = 0")
				filterTable["damage"] = 0
			end
		end
		if victim.chamber > 0 then
			if Winterblight.CavernData.Chambers[victim.chamber]["status"] ~= 1 then
				filterTable["damage"] = 0
			end
		end
		if victim:HasModifier("modifier_merkurio_crystal_blue") then
			filterTable["damage"] =	filterTable["damage"]*0.1
		end
		if victim:HasModifier("modifier_aurora_4_boss_passive") then
			filterTable["damage"] =	filterTable["damage"]*0.01
		end
		filterTable["damage"] = filterTable["damage"]*reduction
		if victim.chamber > 0 then
			local allowed_player = EntIndexToHScript(Winterblight.CavernData.Chambers[victim.chamber]["hero"]):GetPlayerOwnerID()
			if attacker:GetPlayerOwnerID() ~= allowed_player then
				if applyEffects then
					filterTable["damage"] = 0
				end
			end
		end
		if victim:HasModifier("modifier_merkurio_crystal_purple") and filterTable["damage"] > 0 then
			local caster = victim:FindModifierByName("modifier_merkurio_crystal_purple"):GetCaster()
			local stacks = victim:GetModifierStackCount("modifier_merkurio_crystal_purple", caster) - 1
			if stacks > 0 then
				victim:SetModifierStackCount("modifier_merkurio_crystal_purple", caster, stacks)
			else
				victim:RemoveModifierByName("modifier_merkurio_crystal_purple")
			end
			filterTable["damage"] = 0
		end
	elseif attacker:HasModifier("modifier_winterblight_cavern_unit") then
		local chamber_level = 1
		if attacker.chamber == 0 then
			chamber_level = attacker.boss_level
		else
			chamber_level = Winterblight.CavernData.Chambers[attacker.chamber]["level"]
		end
		local damage_amp = 0.2*chamber_level
		filterTable["damage"] = filterTable["damage"] + filterTable["damage"]*damage_amp
	end
	if attacker:HasModifier("modifier_Winterblight_unit") then
		filterTable["damage"] = filterTable["damage"] * (1 + Winterblight.Stones)
	end
	if attacker:HasModifier("modifier_ekkan_dominion_unit") then
		if attacker.hero:HasModifier("modifier_ekkan_immortal_weapon_3") then
			if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
				filterTable["damage"] = filterTable["damage"] * EKKAN_IMMORTAL_WEAPON_3_AMP
			end
		end
	end

	if not victim:HasModifier("modifier_steadfast") and not victim:HasModifier("modifier_mega_steadfast") and attacker:HasModifier("modifier_neutral_glyph_4_2") then
		filterTable["damage"] = filterTable["damage"] * 0.8
	end
	if victim:HasModifier("modifier_water_jailer_ai") or victim:HasModifier("modifier_bovel_ai") then
		if filterTable["damage"] > (victim:GetMaxHealth() * 0.01) then
			filterTable["damage"] = victim:GetMaxHealth() * 0.01
		end
	end
	if victim:HasModifier("modifier_exploder_freeze") then
		filterTable["damage"] = filterTable["damage"] * 5
	end
	if victim:HasModifier("modifier_zonis_stun_arcana1") then
		if attacker:HasAbility("arkimus_zap_ring") then
			local zapRing = attacker:FindAbilityByName("arkimus_zap_ring")
			mult = mult + zapRing.q_2_level * ARKIMUS_ARCANA1_Q2_POSTMIT
		end
	end
	if attacker:HasModifier("modifier_world_tree_effect") then
		mult = mult + WORLD_TREES_CACHE_POST_MITI/100
	end

	if victim:HasModifier("modifier_swamp_lady_shield") or victim:HasModifier("modifier_creature_borrowed_time") and applyEffects then
		local healAmount = filterTable["damage"]
		filterTable["damage"] = 0
		victim:Heal(healAmount, victim)
	end
	if victim:HasModifier("modifier_solar_compression_invisible") then
		modifier = victim:FindModifierByName("modifier_solar_compression_invisible")
		local modifierCaster = modifier:GetCaster()
		local stacks = victim:GetModifierStackCount("modifier_solar_compression_invisible", modifierCaster)
		mult = mult + stacks * SOLUNIA_ARCANA_Q3_POST_MITI_PCT/100
	end
	if victim:HasModifier("modifier_lunar_compression_invisible") then
		modifier = victim:FindModifierByName("modifier_lunar_compression_invisible")
		local modifierCaster = modifier:GetCaster()
		local stacks = victim:GetModifierStackCount("modifier_lunar_compression_invisible", modifierCaster)
		mult = mult + stacks * SOLUNIA_ARCANA_Q3_POST_MITI_PCT/100
	end
	if victim:HasModifier("modifier_in_hydrogen_field") then
		if filterTable["entindex_inflictor_const"] then
			local ability = EntIndexToHScript(filterTable["entindex_inflictor_const"])
			if IsValidEntity(ability) then
				if ability:GetAbilityName() == "sea_fortress_hydrogren_field" then
					filterTable["damage"] = victim:GetMaxHealth() * 0.07
				elseif ability:GetAbilityName() == "seafortress_heart_spike" then
					filterTable["damage"] = victim:GetMaxHealth() * 0.12
				end
			end
		end
	end
	if victim:HasModifier("modifier_arkimus_glyph_5_a") then
		if damagetype == DAMAGE_TYPE_MAGICAL or damagetype == DAMAGE_TYPE_PURE then
			if filterTable["damage"] > 1 then--monkey paw tweak
				local ability = victim:FindAbilityByName("arkimus_energy_field")
				if ability then
					----print("arkimus_energy_field true")
					filterTable["damage"] = Filters:ArkimusGlyph5a(victim, filterTable["damage"])
					-- else
					-- --print("arkimus_energy_field false")
				end
			end
		end
	end

	if attacker:HasModifier("modifier_chernobog_immortal_weapon_2") then
		local missingHealthPercent = math.floor((1 - (attacker:GetHealth() / attacker:GetMaxHealth())) * 100)
		mult = mult + missingHealthPercent * 1.5 / 100
	end
	--DUSKBRINGER
	if attacker:GetUnitName() == "npc_dota_hero_spirit_breaker" and victim:IsRooted() then
		local w_4_level = attacker:GetRuneValue("w", 4)
		mult = mult + w_4_level * DUSKBRINGER_W4_POSTMIT
	end
	modifier = victim:FindModifierByName("modifier_duskbringer_rune_r_2_invisible")
	if modifier then
		local stacks = modifier:GetStackCount()
		mult = mult + stacks * DUSKBRINGER_R2_POSTMIT

	end

	if victim:HasModifier("modifier_channeling_water_torrent") then
		filterTable["damage"] = filterTable["damage"] * 0.01
	end

	if victim:HasModifier('modifier_duskbringer_ghost_form_active') then
		filterTable["damage"] = 0
	end

	--TRAPPER
	modifier = attacker:FindModifierByName("modifier_trapper_d_c_post_amp")
	if modifier then
		local stacks = modifier:GetStackCount()
		mult = mult + stacks * 0.15
	end

	modifier = victim:FindModifierByName("modifier_poison_whip")
	if modifier then
		local stacks = modifier:GetStackCount()
		local ability = modifier:GetAbility()
		local w_1_level = ability.w_1_level
		mult = mult + TRAPPER_ARCANA1_W1_POST_AMP_PERCENT/100 * w_1_level * math.min(stacks, TRAPPER_ARCANA1_W1_MAX_STACKS)
	end

	--SEINARU

	modifier = victim:FindModifierByName("modifier_seinaru_rune_w_1_invisible")
	if modifier then
		local stacks = modifier:GetStackCount()
		mult = mult + SEINARU_W1_POSTMIT_PER_STACK_PER_LVL * stacks
	end

	modifier = victim:FindModifierByName("modifier_seinaru_rune_q_3_postmitigation_take")
	if modifier then
		local attacker_movespeed = attacker:GetMoveSpeedModifier(attacker:GetBaseMoveSpeed(), false)
		local victim_movespeed = victim:GetMoveSpeedModifier(victim:GetBaseMoveSpeed(), false)
		local movespeed_difference = math.max(attacker_movespeed - victim_movespeed, 0)
		mult = mult + movespeed_difference * SEINARU_Q3_POSTMIT_PER_MOVESPEED_DIF * modifier:GetStackCount()
	end
	modifier = victim:FindModifierByName("modifier_drill_crusher_stack")
	if modifier and modifier:GetStackCount() == DRILL_CRUSHER_MAX_STACKS_COUNT then
		mult = mult + DRILL_CRUSHER_POSTMITIGATION
	end

	if victim:HasModifier("modifier_sephyr_glyph_6_1") then
		local luck = RandomInt(1, 20)
		if luck <= 7 then
			filterTable["damage"] = 0
			CustomAbilities:QuickAttachParticle("particles/roshpit/sephyr/glyph_6_damage.vpcf", victim, 0.5)
		end
	end
	Util.Modifier:SimpleEvent(attacker, 'GetPreMitigationReduce', { MODIFIER_SPECIAL_TYPE_PREMITIGATION }, {
		attacker = attacker,
		victim = victim,
		source = damageData.source,
		sourceType = damageData.sourceType,
		damage = filterTable['damage'],
	}, function(result, data)
		filterTable['damage'] = filterTable['damage'] * (1 - result)
		data.damage = filterTable['damage']
	end)

	Util.Modifier:SimpleEvent(attacker, 'OnAfterPreMitigationReduce', { MODIFIER_SPECIAL_TYPE_PREMITIGATION }, {
		attacker = attacker,
		victim = victim,
		source = damageData.source,
		sourceType = damageData.sourceType,
		damage = filterTable['damage'],
		elements = elements,
	}, nil)
	Util.Modifier:SimpleEvent(victim, 'OnAfterPreMitigationReduce', { MODIFIER_SPECIAL_TYPE_PREMITIGATION }, {
		attacker = attacker,
		victim = victim,
		source = damageData.source,
		sourceType = damageData.sourceType,
		damage = filterTable['damage'],
		elements = elements,
	}, nil)


	if victim:HasModifier("modifier_steadfast") then
		local threshold_abil = {
			moon_shroud = ASTRAL_Q2_STEADFAST_THRESHOLD,
			astral_arcana_ability = ASTRAL_Q2_STEADFAST_THRESHOLD
		}
		local thresholdMult = 1
		if attacker:HasModifier("modifier_neutral_glyph_4_2") then
			thresholdMult = 10
			mult = mult + thresholdMult - 1
			divisor = divisor + thresholdMult - 1
		end
		if damageData.steadfastThresholdMult then
			thresholdMult = thresholdMult + damageData.steadfastThresholdMult
		end
		if filterTable.entindex_inflictor_const then
			for ability_name, thresh in pairs(threshold_abil) do
				if EntIndexToHScript(filterTable.entindex_inflictor_const):GetName() == ability_name then
					thresholdMult = thresholdMult + thresh - 1
				end
			end
		end
		if attacker:GetName() == 'npc_dota_hero_juggernaut' and attacker:FindAbilityByName('seinaru_odachi_leap') then
			if mult == 1 then
				thresholdMult = thresholdMult + attacker:GetRuneValue("e", 3) * SEINARU_E3_THRESHOLD
			elseif attacker:HasModifier('modifier_seinaru_glyph_4_1') then
				thresholdMult = thresholdMult + attacker:GetRuneValue("e", 3) * SEINARU_E3_THRESHOLD / SEINARU_GLYPH4_THRESHOLD_RUNE_REDUCE
			end
		end
		if attacker:HasModifier("modifier_rockfall_passive") then
			thresholdMult = 1 + attacker:GetRuneValue("e", 4) * ARCANA3_E4_THRESHOLD_INCREASE_PERCENT / 100
		end
		if attacker:HasModifier("modifier_slipfinn_passive") then
			local e_4_level = attacker:GetRuneValue("e", 4)
			local luck = RandomInt(1, 1000)
			if luck < 5 * e_4_level then
				thresholdMult = 10000
			end
		end
		if not attacker:HasModifier("modifier_backstab_jumping") and applyEffects then
			if not attacker.ignore_steadfast and not damageData.ignoreSteadfast then
				filterTable["damage"] = CustomAbilities:Steadfast(filterTable["damage"], victim, thresholdMult)
			end
		end
	end
	if victim:HasModifier("modifier_ancient_steadfast") then
		if not attacker:HasModifier("modifier_backstab_jumping") and applyEffects then
			if not attacker.ignore_steadfast and not damageData.ignoreSteadfast then
				filterTable["damage"] = CustomAbilities:AncientSteadfast(filterTable["damage"], victim)
			end
		end
	end
	if victim:HasModifier("modifier_mega_steadfast") then
		local threshold_abil = {
			moon_shroud = ASTRAL_Q2_STEADFAST_THRESHOLD,
			astral_arcana_ability = ASTRAL_Q2_STEADFAST_THRESHOLD
		}
		local thresholdMult = 1
		if attacker:HasModifier("modifier_neutral_glyph_4_2") then
			thresholdMult = 30
			mult = mult + thresholdMult - 1
			divisor = divisor + thresholdMult - 1
		end

		if damageData.megaSteadfastThresholdMult then
			thresholdMult = thresholdMult + damageData.megaSteadfastThresholdMult
		end
		if filterTable.entindex_inflictor_const then
			for ability_name, thresh in pairs(threshold_abil) do
				if EntIndexToHScript(filterTable.entindex_inflictor_const):GetName() == ability_name then
					thresholdMult = thresholdMult + thresh - 1
				end
			end
		end
		if attacker:GetName() == 'npc_dota_hero_juggernaut' and attacker:FindAbilityByName('seinaru_odachi_leap') then
			if mult == 1 then
				thresholdMult = thresholdMult + attacker:GetRuneValue("e", 3) * SEINARU_E3_THRESHOLD
			elseif attacker:HasModifier('modifier_seinaru_glyph_4_1') then
				thresholdMult = thresholdMult + attacker:GetRuneValue("e", 3) * SEINARU_E3_THRESHOLD / SEINARU_GLYPH4_THRESHOLD_RUNE_REDUCE
			end
		end
		if attacker:HasModifier("modifier_rockfall_passive") then
			thresholdMult = 1 + attacker:GetRuneValue("e", 4) * ARCANA3_E4_THRESHOLD_INCREASE_PERCENT / 100
		end
		if attacker:HasModifier("modifier_slipfinn_passive") then
			local e_4_level = attacker:GetRuneValue("e", 4)
			local luck = RandomInt(1, 1000)
			if luck < 5 * e_4_level then
				thresholdMult = 10000
			end
		end
		if not attacker:HasModifier("modifier_backstab_jumping") and applyEffects then
			if not attacker.ignore_steadfast and not damageData.ignoreSteadfast then
				filterTable["damage"] = CustomAbilities:MegaSteadfast(filterTable["damage"], victim, thresholdMult)
			end
		end
	end
	if attacker.ignore_steadfast then
		attacker.ignore_steadfast = false
	end

	--APPLY MULT
	if applyEffects and not damageData.ignoreMultipliers and not damageData.ignorePostmitigation then
		filterTable["damage"] = filterTable["damage"] * mult / divisor
	end
	--AFTER POSTMITIGATION MULTIPLIERS

	if attacker:HasModifier("modifier_trapper_immortal_weapon_2") and not damageData.ignoreMultipliers and not damageData.ignoreExtraPostmitigation then
		if victim:HasModifier("modifier_fulminating_burn_effect") or victim:HasModifier("modifier_poison_trap_effect") or victim:HasModifier("modifier_net_trap_netted_effect") or victim:HasModifier("modifier_torrent_trap_slowed_effect") then
			filterTable["damage"] = filterTable["damage"] * 1.3
		end
	end

	--FINAL STAGE--
	if victim:HasModifier("modifier_earth_guardian") then
		if attacker:GetEntityIndex() == victim:GetEntityIndex() then
		else
			Filters:EarthGuardian(victim, filterTable["damage"])
		end
	end
	if damageData.postmitigationDamage then
		filterTable["damage"] = damageData.postmitigationDamage
	end
	modifier = victim:FindModifierByName('modifier_chernobog_1_q_path_enemy_effect_q1')
	if modifier and not damageData.ignoreMultipliers and not damageData.ignoreExtraPostmitigation then
		filterTable["damage"] = filterTable["damage"] * (1 + modifier:GetExtraPostmitigationAmplify())
	end
	if attacker:HasModifier("modifier_helm_odin") and not damageData.ignoreMultipliers and not damageData.ignoreExtraPostmitigation then
		local proc = Filters:GetProc(attacker, ODIN_HELMET_CHANCE)
		if proc then
			filterTable["damage"] = filterTable["damage"] * ODIN_HELMET_MULT
			PopupOdin(victim, ODIN_HELMET_MULT)
			local helm = attacker.headItem
			if not helm.particleCount then
				helm.particleCount = 0
			end
			if helm.particleCount < 12 then
				helm.particleCount = helm.particleCount + 1
				CustomAbilities:QuickAttachParticle("particles/roshpit/items/odin_helmet.vpcf", victim, 1.2)
				EmitSoundOnLocationWithCaster(victim:GetAbsOrigin(), "RPCItem.OdinHelmet.Crit", attacker)
				Timers:CreateTimer(1, function()
					helm.particleCount = helm.particleCount - 1
				end)
			end
		end
	end
	if attacker:HasModifier("modifier_volcano_orb") and not damageData.ignoreMultipliers and not damageData.ignoreExtraPostmitigation then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			filterTable["damage"] = filterTable["damage"] * VOLCANO_ORB_MAGIC_DMG_MULT
		end
	end

	if victim:HasModifier("modifier_canyon_boss_ai") then
		if applyEffects then
			filterTable["damage"] = Redfall:CanyonBossTakeDamage(victim, filterTable["damage"])
		end
	end
	if victim:HasModifier("modifier_conquest_stone_falcon") then
		if filterTable["damagetype_const"] == DAMAGE_TYPE_MAGICAL or filterTable["damagetype_const"] == DAMAGE_TYPE_PURE then
			if filterTable["damage"] > victim:GetMaxHealth() * STONE_FALCON_HP_THRESHOLD/100 then
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_ambient_end.vpcf", victim, 1.5)
			end
			filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth() * STONE_FALCON_HP_THRESHOLD/100)
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
			local luck = RandomInt(1, 2)
			if luck == 1 then
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
	if victim:HasModifier("modifier_slipfinn_release_immunity") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_epoch_glyph_5_a_little_shield") then
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
		--print("SHIELD ABSORB REMAINING "..victim.scythe_shield_absorb)
		filterTable["damage"] = filterTable["damage"] - damageReduce
	end
	if victim:HasModifier("modifier_perdition_passive") then
		local reductionMult = 0.5
		if GameState:GetDifficultyFactor() == 1 then
			reductionMult = 0
		elseif GameState:GetDifficultyFactor() == 2 then
			reductionMult = 0.2
		end
		local reduction = reductionMult * (3 - Redfall.Castle.TorchesLit)
		filterTable["damage"] = math.max(filterTable["damage"] - filterTable["damage"] * reduction, 0)
	end
	if victim:HasModifier("modifier_seven_visions_striking") or victim:HasModifier("modifier_seven_visions_striking_glyphed") then
		filterTable["damage"] = 0
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
	if victim:HasModifier("modifier_shipyard_spawner_passive") or victim:HasModifier("modifier_jex_fire_tree") then
		filterTable["damage"] = 1
	end
	if victim:HasModifier("modifier_line_tower_passive") then
		if attacker:IsHero() then
			filterTable["damage"] = filterTable["damage"] * 0.005
		end
	end
	if victim:HasModifier("modifier_flamewaker_glyph_5_a") then
		if victim:GetUnitName() == "npc_dota_hero_dragon_knight" then
			local thresh = 0.3
			if victim:GetHealth() < victim:GetMaxHealth() * 0.5 then
				thresh = 0.15
			end
			if filterTable["damage"] > victim:GetMaxHealth() * thresh then
				filterTable["damage"] = victim:GetMaxHealth() * thresh
			end
		end
	end

	if victim:HasModifier("modifier_centaur_horns") then
		local thresh = CENTAUR_HORNS_DAMAGE_CAP/100
		if filterTable["damage"] > victim:GetMaxHealth() * thresh then
			filterTable["damage"] = victim:GetMaxHealth() * thresh
		end
	end

	if victim:HasModifier("modifier_djanghor_immortal_weapon_2") then
		if victim:HasModifier("modifier_shapeshift_bear") or victim:HasModifier("modifier_shapeshift_year_beast") then
			if filterTable["damage"] < victim:GetMaxHealth() * 100 then
				filterTable["damage"] = math.min(victim:GetMaxHealth() * DJANGHOR_WEAP_2_HP_THRESHOLD_PCT, filterTable["damage"])
			end
		end
	end
	if victim:HasModifier("modifier_moloth_ai") then
		filterTable["damage"] = CustomAbilities:MolothTakeDamage(victim, damagetype, filterTable["damage"])
	end
	if victim:HasModifier("modifier_disable_player") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_inside_aquarius_dome") then
		local aquarius_caster = victim:FindModifierByName("modifier_inside_aquarius_dome"):GetCaster()
		if IsValidEntity(aquarius_caster) then
			if victim:GetTeamNumber() == aquarius_caster:GetTeamNumber() then
				if not attacker:HasModifier("modifier_inside_aquarius_dome") then
					filterTable["damage"] = 0
				end
			end
		end
	end
	if victim:HasModifier("modifier_damage_immunity") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_aeon_shield_passive") then
		if victim:HasModifier("modifier_aeon_shield_active") then
			filterTable["damage"] = 0
		else
			if victim:HasModifier("modifier_aeon_shield_charges") then
				local charges = victim:FindModifierByName("modifier_aeon_shield_charges"):GetStackCount()
				if (victim:GetHealth()-filterTable["damage"])/victim:GetMaxHealth() < charges*0.195 then
					local new_charges = charges - 1
					filterTable["damage"] = victim:GetHealth() - victim:GetMaxHealth()*charges*0.195
					if new_charges > 0 then
						victim:SetModifierStackCount("modifier_aeon_shield_charges", victim, new_charges)
					else
						victim:RemoveModifierByName("modifier_aeon_shield_charges")
					end
					local ability = victim:FindModifierByName("modifier_aeon_shield_passive"):GetAbility()
					ability:ApplyDataDrivenModifier(victim, victim, "modifier_aeon_shield_active", {duration = 2.5})
				end
			end
		end
	end
	if victim:HasModifier("modifier_beast_tyrant_combat_ai") then
		if attacker:HasModifier("modifier_beast_tyrant_in_blue") and damagetype == DAMAGE_TYPE_MAGICAL then
		elseif attacker:HasModifier("modifier_beast_tyrant_in_red") and damagetype == DAMAGE_TYPE_PHYSICAL then
		elseif attacker:HasModifier("modifier_beast_tyrant_in_yellow") and damagetype == DAMAGE_TYPE_PURE then
		else
			filterTable["damage"] = 0
		end
	end
	if victim:HasModifier("modifier_colossus_restore") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_no_damage") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_bahamut_rune_r_4_shell") then
		filterTable["damage"] = 0
	end
	--INCREASE INCOMING--
	local increaseIncoming = GameState:IncomingDamageIncrease(victim, attacker, true, damagetype)
	filterTable["damage"] = filterTable["damage"] * increaseIncoming

	if victim:HasModifier("modifier_crystalline_slippers") then
		if attacker:IsRooted() then
			filterTable["damage"] = filterTable["damage"] * (100-CRYSTALLINE_DAMAGE_REDUCTION_FROM_ROOTED)/100
		end
	end
	-- wEIRD MONSTERS
	if victim:HasModifier("modifier_mystery_summon_passive") then
		filterTable["damage"] = 0
		Winterblight:PixieSummonTakeDamage(victim)
	end
	if victim:HasModifier("modifier_armor_of_atlantis") then
		if filterTable["damage"] > victim:GetMaxHealth() * ARMOR_OF_ATLANTIS_HP_THRESHOLD then
			filterTable["damage"] = filterTable["damage"] * (100-ARMOR_OF_ATLANTIS_DMG_REDUCTION)/100
			local pfxA = CustomAbilities:QuickAttachParticle("particles/act_2/ogre_seal_icebreak_flash.vpcf", victim, 0.5)
			ParticleManager:SetParticleControl(pfxA, 1, victim:GetAbsOrigin())
		end
	end
	if attacker:HasModifier("modifier_line_tower_passive") then
		-- filterTable["damage"] = filterTable["damage"]/GameState.PVP_REDUCTION
		if victim:IsHero() then
			filterTable["damage"] = victim:GetMaxHealth() * 0.1
		else
			filterTable["damage"] = math.max(filterTable["damage"], victim:GetMaxHealth() * 0.1)
		end
	end
	if victim:HasModifier("modifier_serengaard_tower_passive") then
		-- filterTable["damage"] = filterTable["damage"]/GameState.PVP_REDUCTION
	end
	if victim:HasModifier("modifier_line_tower_passive") then
		filterTable["damage"] = math.min(filterTable["damage"], victim:GetMaxHealth() * 0.08)
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

	if victim:HasModifier("modifier_frozen_heart") then
		if damagetype == DAMAGE_TYPE_PURE then
			filterTable["damage"] = FROZEN_HEART_DAMAGE_PER_PURE
		elseif damagetype == DAMAGE_TYPE_MAGICAL then
			filterTable["damage"] = FROZEN_HEART_DAMAGE_PER_MAGICAL
		else
			filterTable["damage"] = FROZEN_HEART_DAMAGE_PER_PHYS
		end
	end

	if victim:HasModifier("modifier_recently_respawned") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_seinaru_a_c_dbz") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_paladin_rune_e_1_reviving") then
		filterTable["damage"] = 0
	end
	if victim:HasModifier("modifier_paladin_rune_e_1_invulnerable") then
		filterTable["damage"] = 0
	end

	--LETHAL CHECK
	if filterTable["damage"] > victim:GetHealth() then
		local rezzed = false
		if victim:HasModifier("modifier_phoenix_emblem") then
			if victim:HasModifier("modifier_phoenix_rebirthing") then
				filterTable["damage"] = 0
			end
			if not victim:HasModifier("modifier_phoenix_emblem_cooldown") then
				filterTable["damage"] = 0
				Filters:PhoenixEmblem(victim)
				rezzed = true
			end
		end
		if victim:HasModifier("modifier_conjuror_arcana3") and not rezzed then
			if victim.earthAspect and victim.earthAspect.earthDeity then
				if victim.earthAspect:HasAbility("earth_deity_grand_guardian") then
					local grand_guardian_ability = victim.earthAspect:FindAbilityByName("earth_deity_grand_guardian")
					if grand_guardian_ability:IsFullyCastable() then
						filterTable["damage"] = victim:GetHealth() - 1
						local newOrder = {
							UnitIndex = victim.earthAspect:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							TargetIndex = victim:entindex(),
							AbilityIndex = grand_guardian_ability:entindex(),
						}
						ExecuteOrderFromTable(newOrder)
						rezzed = true
					end
				end
			end
		end
		if victim:HasModifier("modifier_hailstorm_passive") and not rezzed then
			if not victim:HasModifier("modifier_hailstorm_ice_case_cooldown") then
				local hailstormAbility = victim:FindAbilityByName("mountain_protector_hailstorm")
				local r_2_level = victim:GetRuneValue("r", 2)
				if r_2_level > 0 then
					hailstormAbility:ApplyDataDrivenModifier(victim, victim, "modifier_frozen_stand", nil)
					rezzed = true
				end
			end
		end
		if victim:HasModifier("modifier_solunia_glyph_5_a") and not rezzed then
			if not victim:HasModifier("modifier_solunia_glyph_5_a_cooldown") then
				filterTable["damage"] = victim:GetHealth() - 2
				CustomAbilities:Protostar(victim)
				rezzed = true
			end
		end
		if victim:HasModifier("modifier_epoch_glyph_5_a_effect") and not rezzed then
			if not victim:HasModifier("modifier_epoch_glyph_5_a_cooldown") then
				--print("EpochTimeTravelGlyph shield trigger - game state")
				filterTable["damage"] = victim:GetHealth() - 2
				CustomAbilities:EpochTimeTravelGlyph(victim)
				rezzed = true
			end
		end
		if victim:HasModifier("modifier_paladin_arcana2_passive") and not rezzed then
			local e_1_level = victim:GetRuneValue("e", 1)
			if e_1_level > 0 then
				if not victim:HasModifier("modifier_paladin_heal_on_lethal_cooldown") then
					local arcanaAbility = victim:FindAbilityByName("paladin_crusader_comet")
					arcanaAbility:ApplyDataDrivenModifier(victim, victim, "modifier_paladin_heal_on_lethal_cooldown", {duration = 5})
					local healAmount = e_1_level * 5000
					local manaRestore = e_1_level * 1000
					EmitSoundOn("Paladin.ArcanaACHeal", victim)
					Filters:ApplyHeal(victim, victim, healAmount, true)
					victim:GiveMana(manaRestore)
					local pfx = ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_CUSTOMORIGIN, target)
					ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(pfx, 1, Vector(300, 1, 300))
					ParticleManager:SetParticleControl(pfx, 2, victim:GetForwardVector())
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					filterTable["damage"] = 0
					rezzed = true
				end
			end
		end
		if victim:HasModifier("modifier_ankh_of_the_ancients") and not rezzed then
			if not victim:HasModifier("modifier_ankh_of_ancients_cooldown") then
				filterTable["damage"] = victim:GetHealth() - 2
				victim.amulet.ankh_apply_time = GameRules:GetGameTime()
				victim.amulet:ApplyDataDrivenModifier(victim, victim, "modifier_ankh_of_ancients_shield", {duration = ANKH_SHIELD_DURATION})
				for i = 0, 3, 1 do
					local abilityIndex = i
					if i == 3 then
						abilityIndex = DOTA_R_SLOT
					end
					victim:GetAbilityByIndex(abilityIndex):EndCooldown()
				end
				rezzed = true
			end
		end
		if victim:HasModifier("modifier_world_trees_flower_cache") and not rezzed then
			--print("HAS FLOWER CACHE")
			if not victim:HasModifier("modifier_world_tree_cache_cooldown") then
				filterTable["damage"] = victim:GetHealth() - 2
				--print("DO THIS STUFF")
				victim:AddNoDraw()
				victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_world_tree_cache_cooldown", {duration = WORLD_TREES_CACHE_COOLDOWN})
				victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_ankh_of_ancients_shield", {duration = WORLD_TREES_CACHE_RESURRECTION_DELAY})
				local pfx = ParticleManager:CreateParticle("particles/econ/items/natures_prophet/natures_prophet_weapon_sufferwood/furion_teleport_end_sufferwood.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
				ParticleManager:SetParticleControl(pfx, 0, victim:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx, 4, Vector(300, 0, 0))
				for i = 0, 12, 1 do
					ParticleManager:SetParticleControlEnt(pfx, i, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
				end
				EmitSoundOn("RPCItem.WorldTreeCache.Start", victim)
				rezzed = true
				Timers:CreateTimer(WORLD_TREES_CACHE_RESURRECTION_DELAY, function()
					victim:RemoveNoDraw()
					EmitSoundOn("RPCItem.WorldTreeCache.End", victim)
					victim:SetHealth(victim:GetMaxHealth())
					ParticleManager:DestroyParticle(pfx, false)
					victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_world_tree_effect", {duration = WORLD_TREES_CACHE_BUFF_DURATION})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", victim, 1.2)
					local enemies = FindUnitsInRadius(victim:GetTeamNumber(), victim:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							Filters:ApplyStun(victim, 0.6, enemy)
						end
					end
				end)
			end
		end
		if victim:HasModifier('modifier_duskbringer_ghost_form_checker') and not rezzed then
			local caster = victim:FindModifierByName('modifier_duskbringer_ghost_form_checker'):GetCaster()
			local e_4_level = caster:GetRuneValue("e", 4)
			if e_4_level > 0 then
				if caster:HasModifier('modifier_duskbringer_glyph_1_1') then
					for i = 0, 3, 1 do
						local abilityIndex = i
						if i == 3 then
							abilityIndex = DOTA_R_SLOT
						end
						victim:GetAbilityByIndex(abilityIndex):EndCooldown()
					end
				end
				local ability = caster:FindAbilityByName('specter_rush_two')
				ability:ApplyDataDrivenModifier(caster, victim, "modifier_duskbringer_ghost_form_active", {duration = DUSKBRINGER_E4_DUR * e_4_level})
				CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash_flash.vpcf", victim:GetAbsOrigin() + Vector(0, 0, 50), 0.4)
				EmitSoundOn("Duskbringer.Wraithform", victim)
				filterTable["damage"] = 0
				victim.KILLER = attacker
				rezzed = true
			end
		end
	end
	if victim:HasModifier("modifier_zefnar_passive") then
		filterTable["damage"] = Winterblight:ZefnarTakeDamage(victim, filterTable["damage"])
	end

	if victim:HasModifier("modifier_mana_null") then
		if victim:GetMana() > 0 then
			if not victim:IsHero() then
				filterTable["damage"] = 0
				victim:SetMana(victim:GetMana() - 1)
			end
		end
	end
	if victim:HasModifier("modifier_dummy_active") and applyEffects then
		if attacker == Events.GameMaster then
		else
			local heroOwner = CustomAbilities:getHeroFromUnit(attacker)
			if heroOwner then
				if victim.attackerIndex == attacker:GetEntityIndex() or victim.attackerIndex == heroOwner:GetEntityIndex() then
					local dmgReport = math.floor(filterTable["damage"])
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
	if victim:HasModifier("modifier_tutorial_unit") then
		filterTable["damage"] = Tutorial:UnitDamage(attacker, victim, filterTable["damage"], filterTable["damagetype_const"], filterTable["entindex_inflictor_const"])
	end
	if victim.dummy then
		filterTable["damage"] = 0
	end

	if filterTable["damage"] > 0 and applyEffects then
		if victim:HasModifier("modifier_golden_shell_passive") then
			local ability = victim:FindModifierByName("modifier_golden_shell_passive"):GetAbility()
			if not ability.active then
				ability.active = true
				Timers:CreateTimer(0.1, function()
					ability:ApplyDataDrivenModifier(victim, victim, "modifier_black_King_bar_immunity", {duration = ability:GetSpecialValueFor("duration")})
					ability.active = false
				end)
			end
		end
	end

	local inflictor = filterTable["entindex_inflictor_const"]
	if not applyEffects then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			victim.magical_damage_mult = 100 * mult / divisor
			if StartingDamage > 0 then
				victim.resist_mag = 1 - (filterTable["damage"] / StartingDamage)
			else
				victim.resist_mag = 1
			end
		elseif damagetype == DAMAGE_TYPE_PHYSICAL then
			victim.physical_damage_mult = 100 * mult / divisor
			if StartingDamage > 0 then
				victim.resist_phys = 1 - (filterTable["damage"] / StartingDamage)
			else
				victim.resist_phys = 1
			end
		elseif damagetype == DAMAGE_TYPE_PURE then
			victim.pure_damage_mult = 100 * mult / divisor
			if StartingDamage > 0 then
				victim.resist_pure = 1 - (filterTable["damage"] / StartingDamage)
			else
				victim.resist_pure = 1
			end
		end
		filterTable["damage"] = 0
	end

	-- if attacker:HasModifier("modifier_line_unit_passive") then
	-- filterTable["damage"] = filterTable["damage"]/GameState.PVP_REDUCTION
	-- end
	if Beacons.cheats then
		if victim:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			if victim:IsHero() then
				-- print("TAKE DAMAGE: "..filterTable["damage"])
				filterTable["damage"] = 0
			end
			if victim:GetUnitName() == "rubick_apprentice" then
				filterTable["damage"] = 1000
			end
		end
		if attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			if attacker:IsHero() then
				if not victim:HasModifier("modifier_disable_player") then
					-- if not victim:HasModifier("modifier_aeon_shield_passive") then
						-- if filterTable["damage"] > 0 then
							filterTable["damage"] = 999999999999999
						-- end
					-- end
				end
			end
		end
		-- filterTable["damage"] = 0
	end

	if (EntIndexToHScript(filterTable["entindex_attacker_const"]) == EntIndexToHScript(filterTable["entindex_victim_const"])) and (filterTable["damage"] > StartingDamage) then
		filterTable["damage"] = StartingDamage
	end


	return true

end

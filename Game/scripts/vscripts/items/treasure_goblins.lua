if TreasureGoblins == nil then
	TreasureGoblins = class({})
end

LinkLuaModifier("modifier_treasure_goblin_speed", "modifiers/modifier_treasure_goblin_speed", LUA_MODIFIER_MOTION_NONE)

TreasureGoblins.SpawnedCount = 0

TreasureGoblins.Data = {}
TreasureGoblins.Data["rpc_tanari_jungle"] = {}
TreasureGoblins.Data["rpc_redfall_ridge"] = {}
TreasureGoblins.Data["rpc_winterblight_mountain"] = {}
TreasureGoblins.Data["rpc_roshpit_arena"] = {}
TreasureGoblins.Data["rpc_sea_fortress"] = {}

TreasureGoblins.Data["rpc_tanari_jungle"]["regular"] = {}
TreasureGoblins.Data["rpc_tanari_jungle"]["special"] = {}
TreasureGoblins.Data["rpc_redfall_ridge"]["regular"] = {}
TreasureGoblins.Data["rpc_redfall_ridge"]["special"] = {}
TreasureGoblins.Data["rpc_winterblight_mountain"]["regular"] = {}
TreasureGoblins.Data["rpc_winterblight_mountain"]["special"] = {}
TreasureGoblins.Data["rpc_roshpit_arena"]["regular"] = {}
TreasureGoblins.Data["rpc_roshpit_arena"]["special"] = {}
TreasureGoblins.Data["rpc_sea_fortress"]["regular"] = {}
TreasureGoblins.Data["rpc_sea_fortress"]["special"] = {}

TreasureGoblins.Data["rpc_tanari_jungle"]["regular"]["model"] = "models/courier/beetlejaws/mesh/beetlejaws.vmdl"
TreasureGoblins.Data["rpc_tanari_jungle"]["special"]["model"] = "models/courier/smeevil_magic_carpet/smeevil_magic_carpet.vmdl"
TreasureGoblins.Data["rpc_redfall_ridge"]["regular"]["model"] = "models/courier/stump/stump.vmdl"
TreasureGoblins.Data["rpc_redfall_ridge"]["special"]["model"] = "models/items/courier/gama_brothers/gama_brothers.vmdl"
TreasureGoblins.Data["rpc_winterblight_mountain"]["regular"]["model"] = "models/items/courier/bearzky/bearzky.vmdl"
TreasureGoblins.Data["rpc_winterblight_mountain"]["special"]["model"] = "models/items/courier/snapjaw/snapjaw.vmdl"
TreasureGoblins.Data["rpc_roshpit_arena"]["regular"]["model"] = "models/courier/minipudge/minipudge.vmdl"
TreasureGoblins.Data["rpc_roshpit_arena"]["special"]["model"] = "models/courier/trapjaw/trapjaw.vmdl"
TreasureGoblins.Data["rpc_sea_fortress"]["regular"]["model"] = "models/items/courier/g1_courier/g1_courier.vmdl"
TreasureGoblins.Data["rpc_sea_fortress"]["special"]["model"] = "models/courier/flopjaw/flopjaw.vmdl"

TreasureGoblins.Data["rpc_tanari_jungle"]["regular"]["scale"] = 1
TreasureGoblins.Data["rpc_tanari_jungle"]["special"]["scale"] = 1.7
TreasureGoblins.Data["rpc_redfall_ridge"]["regular"]["scale"] = 1
TreasureGoblins.Data["rpc_redfall_ridge"]["special"]["scale"] = 1.2
TreasureGoblins.Data["rpc_winterblight_mountain"]["regular"]["scale"] = 1
TreasureGoblins.Data["rpc_winterblight_mountain"]["special"]["scale"] = 1.2
TreasureGoblins.Data["rpc_roshpit_arena"]["regular"]["scale"] = 1
TreasureGoblins.Data["rpc_roshpit_arena"]["special"]["scale"] = 1.2
TreasureGoblins.Data["rpc_sea_fortress"]["regular"]["scale"] = 1
TreasureGoblins.Data["rpc_sea_fortress"]["special"]["scale"] = 1.2

TreasureGoblins.Stats = {}
TreasureGoblins.Stats[DIFFICULTY_NORMAL] = {}
TreasureGoblins.Stats[DIFFICULTY_ELITE] = {}
TreasureGoblins.Stats[DIFFICULTY_LEGEND] = {}

TreasureGoblins.Stats[DIFFICULTY_NORMAL]["health"] = 100000
TreasureGoblins.Stats[DIFFICULTY_NORMAL]["level"] = 35
TreasureGoblins.Stats[DIFFICULTY_NORMAL]["max_ms"] = 380
TreasureGoblins.Stats[DIFFICULTY_ELITE]["health"] = 1000000
TreasureGoblins.Stats[DIFFICULTY_ELITE]["level"] = 70
TreasureGoblins.Stats[DIFFICULTY_ELITE]["max_ms"] = 450
TreasureGoblins.Stats[DIFFICULTY_LEGEND]["health"] = 10000000
TreasureGoblins.Stats[DIFFICULTY_LEGEND]["level"] = 95
TreasureGoblins.Stats[DIFFICULTY_LEGEND]["max_ms"] = 900


TreasureGoblins.SPECIAL_GOBLIN_HEALTH_MULT = 10
TreasureGoblins.SPECIAL_CHANCE = 5
TreasureGoblins.SPECIAL_GOBLIN_LEVEL_BOOST = 25

TreasureGoblins.ARCANA_CHANCE = 1

TreasureGoblins.SOCKET_1_CHANCE = 75
TreasureGoblins.SOCKET_2_CHANCE = 50

TreasureGoblins.BONUS_GEMS_CHANCES = {}
TreasureGoblins.BONUS_GEMS_CHANCES[1] = 7500
TreasureGoblins.BONUS_GEMS_CHANCES[2] = 4000
TreasureGoblins.BONUS_GEMS_CHANCES[3] = 1200
TreasureGoblins.BONUS_GEMS_CHANCES[4] = 70
TreasureGoblins.BONUS_GEMS_CHANCES[5] = 1

TreasureGoblins.MIN_KILLS_TO_SPAWN = 240

function TreasureGoblins:SpawnChance(treasure_unit)
	Timers:CreateTimer(0.2, function()
		base_position = treasure_unit:GetAbsOrigin()
		if TreasureGoblins.SpawnedCount == 0 then
			local maxRoll = 3000
			if GameState:IsRPCArena() then
				maxRoll = 2000
			end
			if Challenges.units_slain > TreasureGoblins.MIN_KILLS_TO_SPAWN then
				local max_roll = math.max(1, maxRoll - Challenges.units_slain)
				local luck = RandomInt(1, max_roll)
				if luck < 5 then
					local position = base_position + RandomVector(RandomInt(150, 300))
					TreasureGoblins:SpawnTreasureGoblin(position)
				end
			end
		end
	end)
end

function TreasureGoblins:SpawnTreasureGoblin(position)
	TreasureGoblins.SpawnedCount = TreasureGoblins.SpawnedCount + 1
	if TreasureGoblins.Data[GetMapName()] then
		Timers:CreateTimer(0.05, function()
			PrecacheUnitByNameAsync("treasure_goblin_"..GetMapName(), function(...) end)
		end)
		Timers:CreateTimer(2.5, function()
			local goblin = CreateUnitByName("treasure_goblin_"..GetMapName(), position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			goblin:AddAbility("dungeon_creep")	
			local ability = goblin:FindAbilityByName("dungeon_creep")
			ability:SetLevel(1)
			ability:ApplyDataDrivenModifier(goblin, goblin, "modifier_dungeon_thinker_creep", {})
			goblin.aggroSound = "RPCItems.TreasureGoblin.Die"
			goblin:SetForwardVector(RandomVector(1))
			goblin:AddAbility("treasure_goblin_ability"):SetLevel(1)
			local goblin_ability = goblin:FindAbilityByName("treasure_goblin_ability")

			goblin:AddNewModifier(goblin, nil, "modifier_treasure_goblin_speed", {})
			goblin.run_speed = 300
			local luck = RandomInt(1, 100)
			if luck <= TreasureGoblins.SPECIAL_CHANCE then
				goblin.tier = "special"
				goblin_ability:ApplyDataDrivenModifier(goblin, goblin, "modifier_treasure_goblin_special", {})
				goblin.run_speed = 350
			else
				goblin.tier = "regular"
				goblin_ability:ApplyDataDrivenModifier(goblin, goblin, "modifier_treasure_goblin_regular", {})
			end
			goblin:SetModel(TreasureGoblins.Data[GetMapName()][goblin.tier]["model"])
			goblin:SetOriginalModel(TreasureGoblins.Data[GetMapName()][goblin.tier]["model"])
			goblin:SetModelScale(TreasureGoblins.Data[GetMapName()][goblin.tier]["scale"])
			goblin.item_drops = RandomInt(4, 6)

			local goblin_health = TreasureGoblins.Stats[GameState:GetDifficultyFactor()]["health"]
			if goblin.tier == "special" then
				goblin_health = goblin_health * TreasureGoblins.SPECIAL_GOBLIN_HEALTH_MULT
			end
			goblin:SetMaxHPandHealToFull(goblin_health)
			local goblin_level = TreasureGoblins.Stats[GameState:GetDifficultyFactor()]["level"]
			if goblin.tier == "special" then
				goblin_level = goblin_level + TreasureGoblins.SPECIAL_GOBLIN_LEVEL_BOOST
			end
			if GetMapName() == "rpc_tanari_jungle" or GetMapName() == "rpc_redfall_ridge" then
				if Events.SpiritRealm then
					goblin_level = goblin_level + 10
				end
			end
			if GetMapName() == "rpc_winterblight_mountain" then
				goblin_level = goblin_level + Winterblight.Stones*5
			end
			if GetMapName() == "rpc_roshpit_arena" or GetMapName() == "rpc_sea_fortress" then
				goblin_level = goblin_level + 12
			end
			goblin_level = math.min(120, goblin_level)
			goblin:SetRoshpitLevel(goblin_level)
			FindClearSpaceForUnit(goblin, goblin:GetAbsOrigin(), false)
		end)
	end
end

function TreasureGoblins:RollRandomGemTier(roll)
	if roll <= TreasureGoblins.BONUS_GEMS_CHANCES[5] then
		return 5
	elseif roll <= TreasureGoblins.BONUS_GEMS_CHANCES[4] then
		return 4
	elseif roll <= TreasureGoblins.BONUS_GEMS_CHANCES[3] then
		return 3
	elseif roll <= TreasureGoblins.BONUS_GEMS_CHANCES[2] then
		return 2
	elseif roll <= TreasureGoblins.BONUS_GEMS_CHANCES[1] then
		return 1
	else
		return 0
	end
end

function TreasureGoblins:TreasureGoblinItemDrop(goblin)
	local item = nil
	local item_level = RPCItems:RollItemLevelFromUnit(goblin:GetRoshpitLevel())
	if goblin.tier == "special" then
		item_level = math.min(item_level + 10, RPCItems.MAX_ITEM_LEVEL)
	end
	local item_slot = RPC_GEAR_SLOT_WEAPON
	while item_slot == RPC_GEAR_SLOT_WEAPON do
		item_slot = RandomInt(0, 5)
	end
	
	local max_arcana_roll = 400
	if goblin.tier == "special" then
		max_arcana_roll = 40
	end
	local luck = RandomInt(1, max_arcana_roll)
	if luck <= TreasureGoblins.ARCANA_CHANCE then
		print("roll arcana")
		item = RPCItems:RollRandomWorldArcana(item_level)
	else
		print("roll immortal")
		print("ITEM_SLOT:"..item_slot)
		print("ITEM_LEVEL:"..item_level)
		item = RPCItems:RollRandomWorldImmortal(item_slot, item_level)
		print(item:GetAbilityName())
	end
	print(item:GetAbilityName())
	if item then
		if Gems:CanItemBeSocketed(item) then
			local gem1 = nil
			local socket_count = 0
			local max_socket_chance_roll = 100

			local socket1_chance = RandomInt(1, max_socket_chance_roll)
			if socket1_chance <= TreasureGoblins.SOCKET_1_CHANCE then
				Gems:AddSocket(item)
				socket_count = socket_count + 1
			end
			local socket2_chance = RandomInt(1, max_socket_chance_roll)
			if socket2_chance <= TreasureGoblins.SOCKET_2_CHANCE then
				Gems:AddSocket(item)
				socket_count = socket_count + 1
			end
			local max_gem_roll = 10000
			if goblin.tier == "special" then
				max_gem_roll = 3000
			end	
			if socket_count >= 1 then

				local gem_chance = RandomInt(1, max_gem_roll)
				if gem_chance < TreasureGoblins.BONUS_GEMS_CHANCES[1] then
					local random_gem_type = Gems.GEM_TYPES[RandomInt(1, #Gems.GEM_TYPES)]
					gem1 = random_gem_type
					local gem_tier = TreasureGoblins:RollRandomGemTier(gem_chance)
					if Gems.ITEM_MIN_LEVEL_PER_GEM[gem_tier] > item.newItemTable.minLevel then
						gem_tier = 1
					end
					if gem_tier > 0 then
						item.newItemTable.socket1 = gem1
						item.newItemTable.socket1value = gem_tier
					end
				end
				if socket_count >= 2 then
					local gem_chance = RandomInt(1, max_gem_roll)
					if gem_chance < TreasureGoblins.BONUS_GEMS_CHANCES[1] then
						local random_gem_type = Gems.GEM_TYPES[RandomInt(1, #Gems.GEM_TYPES)]
						if not random_gem_type == gem1 then
							local gem_tier = TreasureGoblins:RollRandomGemTier(gem_chance)
							if Gems.ITEM_MIN_LEVEL_PER_GEM[gem_tier] > item.newItemTable.minLevel then
								gem_tier = 1
							end
							if gem_tier > 0 then
								item.newItemTable.socket2 = gem1
								item.newItemTable.socket2value = gem_tier
							end
						end
					end
				end
			end
		end
		RPCItems:ItemUpdateCustomNetTables(item)
		print("DROP ITEM?")
		RPCItems:BasicDropItem(goblin:GetAbsOrigin(), item)
	end
end

function TreasureGoblins:TreasureGoblinDie(goblin)
	local remaining_drops = goblin.item_drops
	local death_drops_extra = RandomInt(2, 3+GameState:GetPlayerPremiumStatusCount())
	if goblin.tier == "special" then
		death_drops_extra = death_drops_extra*2
	end
	local total_death_drops = remaining_drops + death_drops_extra
	for i = 1, total_death_drops, 1 do
		TreasureGoblins:TreasureGoblinItemDrop(goblin)
	end
end
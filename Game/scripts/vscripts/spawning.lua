if Spawning == nil then
	Spawning = class({})
end

function Spawning:SetDropModifier(unit, deathModifier)
	if GameState:IsRedfallRidge() then
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
		if deathModifier ~= nil and deathModifier ~= "" then
			print("Applying Modifier "..deathModifier.." to unit "..unit:GetUnitName())
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, deathModifier, {})
			if unit:HasModifier(deathModifier) then
				print("Modifier successfully applied")
			else
				print("Modifier was not applied")
			end
		end
	elseif GameState:IsRPCArena() then
		Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, unit, "modifier_arena_pit_of_trials_enemy", {})
		if deathModifier ~= nil and deathModifier ~= "" then
			Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, unit, deathModifier, {})
		end
	end
	if unit:GetUnitName() == "npc_dummy_unit" then
		unit:AddAbility("dummy_unit"):SetLevel(1)
	end
end

function Spawning:SpawnUnit(args)
	local luck = 0
	local difficulty = GameState:GetDifficultyFactor()
	if not args.canBeParagon and args.canBeParagon ~= false then
		args.canBeParagon = true
	end
	--1:300 in normal, 1:100 in normal SpiritRealm
	--1:225 in elite,  1:75 in elite SpiritRealm
	--1:150 in legend, 1:50 in legend SpiritRealm
	local maxluck = 300 - (difficulty - 1) * 75
	if Events.SpiritRealm then
		maxluck = maxluck / 3
	end
	luck = RandomInt(1, maxluck)
	if Beacons.paragon == true then
		luck = 1
	end
	if Beacons.packs == true then
		luck = 2
	end
	local unit = ""
	if luck == 1 and args.canBeParagon then
		unit = Paragon:SpawnParagonUnit(args.unitName, args.spawnPoint)
	elseif luck == 2 and args.canBeParagon then
		unit = Paragon:SpawnParagonPack(args.unitName, args.spawnPoint)
	else
		unit = CreateUnitByName(args.unitName, args.spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(unit)
	end
	unit.itemLevel = args.itemLevel
	Spawning:SetDropModifier(unit, args.deathModifier)
	if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
		unit.type = args.enemyType
		if Beacons.cheats then
			if unit.type == ENEMY_TYPE_WEAK_CREEP then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_weak_creep", {})
			elseif unit.type == ENEMY_TYPE_NORMAL_CREEP then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_normal_creep", {})
			elseif unit.type == ENEMY_TYPE_MINI_BOSS then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_mini_boss", {})
			elseif unit.type == ENEMY_TYPE_BOSS then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_boss", {})
			elseif unit.type == ENEMY_TYPE_MAJOR_BOSS then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_major_boss", {})
			end
		end
		local ability = unit:FindAbilityByName("dungeon_creep")
		if ability then
			ability:SetLevel(1)
			ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
		end
		if args.aggroSound then
			unit.aggroSound = args.aggroSound
		end
		unit.minDungeonDrops = args.minDrops
		unit.maxDungeonDrops = args.maxDrops
		if args.fv then
			unit:SetForwardVector(args.fv)
		end
		if args.isAggro then
			Dungeons:AggroUnit(unit)
		end
		if args.creepFunction and type(args.creepFunction) == "function" then
			args.creepFunction(unit)
		end
	else
		for i = 1, #unit.buddiesTable, 1 do
			unit.buddiesTable[i].type = args.enemyType
			unit.buddiesTable[i].itemLevel = args.itemLevel
			if Beacons.cheats then
				if unit.buddiesTable[i].type == ENEMY_TYPE_WEAK_CREEP then
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit.buddiesTable[i], "modifier_weak_creep", {})
				elseif unit.buddiesTable[i].type == ENEMY_TYPE_NORMAL_CREEP then
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit.buddiesTable[i], "modifier_normal_creep", {})
				elseif unit.buddiesTable[i].type == ENEMY_TYPE_MINI_BOSS then
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit.buddiesTable[i], "modifier_mini_boss", {})
				elseif unit.buddiesTable[i].type == ENEMY_TYPE_BOSS then
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit.buddiesTable[i], "modifier_boss", {})
				elseif unit.buddiesTable[i].type == ENEMY_TYPE_MAJOR_BOSS then
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit.buddiesTable[i], "modifier_major_boss", {})
				end
			end
			local ability = unit.buddiesTable[i]:FindAbilityByName("dungeon_creep")
			if ability then
				ability:SetLevel(1)
				ability:ApplyDataDrivenModifier(unit.buddiesTable[i], unit.buddiesTable[i], "modifier_dungeon_thinker_creep", {})
			end
			if args.aggroSound then
				unit.buddiesTable[i].aggroSound = args.aggroSound
			end
			unit.buddiesTable[i].minDungeonDrops = args.minDrops
			unit.buddiesTable[i].maxDungeonDrops = args.maxDrops
			if args.fv then
				unit.buddiesTable[i]:SetForwardVector(args.fv)
			end
			if args.isAggro then
				Dungeons:AggroUnit(unit.buddiesTable[i])
			end
			if args.creepFunction and type(args.creepFunction) == "function" then
				args.creepFunction(unit.buddiesTable[i])
			end
		end
	end
	return unit
end

function Spawning:SpawnNormalCreep(unitName, spawnPoint, minDrops, maxDrops, itemLevel, aggroSound, fv, isAggro, deathModifier)
	local luck = 0
	local difficulty = GameState:GetDifficultyFactor()
	--1:300 in normal, 1:100 in normal SpiritRealm
	--1:225 in elite,  1:75 in elite SpiritRealm
	--1:150 in legend, 1:50 in legend SpiritRealm
	local maxluck = 300 - (difficulty - 1) * 75
	if Events.SpiritRealm then
		maxluck = maxluck / 3
	end
	luck = RandomInt(1, maxluck)
	local unit = ""
	if luck == 1 then
		unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
	elseif luck == 2 or unitName == "redfall_forest_ranger" then
		unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
	else
		unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(unit)
	end
	unit.itemLevel = itemLevel
	if IsValidEntity(unit) then
		unit.type = ENEMY_TYPE_NORMAL_CREEP
		if Beacons.cheats then
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_normal_creep", {})
		end
		local ability = unit:FindAbilityByName("dungeon_creep")
		if ability then
			ability:SetLevel(1)
			ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
		end
		if aggroSound then
			unit.aggroSound = aggroSound
		end
		unit.minDungeonDrops = minDrops
		unit.maxDungeonDrops = maxDrops
		Spawning:SetModifiers(unit, deathModifier)
		if fv then
			unit:SetForwardVector(fv)
		end
		if isAggro then
			Dungeons:AggroUnit(unit)
		end
	else
		for i = 1, #unit, 1 do
			unit[i].type = ENEMY_TYPE_NORMAL_CREEP
			unit[i].itemLevel = itemLevel
			if Beacons.cheats then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit[i], "modifier_normal_creep", {})
			end
			local ability = unit[i]:FindAbilityByName("dungeon_creep")
			if ability then
				ability:SetLevel(1)
				ability:ApplyDataDrivenModifier(unit[i], unit[i], "modifier_dungeon_thinker_creep", {})
			end
			if aggroSound then
				unit[i].aggroSound = aggroSound
			end
			unit[i].minDungeonDrops = minDrops
			unit[i].maxDungeonDrops = maxDrops
			Spawning:SetModifiers(unit[i], deathModifier)
			if fv then
				unit[i]:SetForwardVector(fv)
			end
			if isAggro then
				Dungeons:AggroUnit(unit[i])
			end
		end
	end
	return unit
end

function Spawning:SpawnMiniBoss(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)
	local luck = 0
	local difficulty = GameState:GetDifficultyFactor()
	--1:300 in normal, 1:100 in normal SpiritRealm
	--1:225 in elite,  1:75 in elite SpiritRealm
	--1:150 in legend, 1:50 in legend SpiritRealm
	local maxluck = 300 - (difficulty - 1) * 75
	if Events.SpiritRealm then
		maxluck = maxluck / 3
	end
	luck = RandomInt(1, maxluck)
	local unit = ""
	if luck == 1 then
		unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
	else
		unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(unit)
	end
	unit.type = ENEMY_TYPE_MINI_BOSS
	if Beacons.cheats then
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_mini_boss", {})
	end
	local ability = unit:FindAbilityByName("dungeon_creep")
	if ability then
		ability:SetLevel(1)
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
	end
	if aggroSound then
		unit.aggroSound = aggroSound
	end
	unit.minDungeonDrops = minDrops
	unit.maxDungeonDrops = maxDrops
	Spawning:SetDropModifier(unit)
	if fv then
		unit:SetForwardVector(fv)
	end
	if isAggro then
		Dungeons:AggroUnit(unit)
	end
	return unit
end

function Spawning:SpawnBoss(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)
	local luck = 0
	local difficulty = GameState:GetDifficultyFactor()
	--1:300 in normal, 1:100 in normal SpiritRealm
	--1:225 in elite,  1:75 in elite SpiritRealm
	--1:150 in legend, 1:50 in legend SpiritRealm
	local maxluck = 300 - (difficulty - 1) * 75
	if Events.SpiritRealm then
		maxluck = maxluck / 3
	end
	luck = RandomInt(1, maxluck)
	local unit = ""
	if luck == 1 then
		unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
	elseif luck == 2 then
		unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
	else
		unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(unit)
	end
	unit.type = ENEMY_TYPE_BOSS
	if Beacons.cheats then
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_boss", {})
	end
	local ability = unit:FindAbilityByName("dungeon_creep")
	if ability then
		ability:SetLevel(1)
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
	end
	if aggroSound then
		unit.aggroSound = aggroSound
	end
	unit.minDungeonDrops = minDrops
	unit.maxDungeonDrops = maxDrops
	Spawning:SetDropModifier(unit)
	if fv then
		unit:SetForwardVector(fv)
	end
	if isAggro then
		Dungeons:AggroUnit(unit)
	end
	return unit
end

function Spawning:SpawnMajorBoss(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)
	local luck = 0
	local difficulty = GameState:GetDifficultyFactor()
	--1:300 in normal, 1:100 in normal SpiritRealm
	--1:225 in elite,  1:75 in elite SpiritRealm
	--1:150 in legend, 1:50 in legend SpiritRealm
	local maxluck = 300 - (difficulty - 1) * 75
	if Events.SpiritRealm then
		maxluck = maxluck / 3
	end
	luck = RandomInt(1, maxluck)
	local unit = ""
	if luck == 1 then
		unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
	else
		unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(unit)
	end
	unit.type = ENEMY_TYPE_MAJOR_BOSS
	if Beacons.cheats then
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_major_boss", {})
	end
	local ability = unit:FindAbilityByName("dungeon_creep")
	if ability then
		ability:SetLevel(1)
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
	end
	if aggroSound then
		unit.aggroSound = aggroSound
	end
	unit.minDungeonDrops = minDrops
	unit.maxDungeonDrops = maxDrops
	Spawning:SetDropModifier(unit)
	if fv then
		unit:SetForwardVector(fv)
	end
	if isAggro then
		Dungeons:AggroUnit(unit)
	end
	return unit
end

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
	if not args.canBeParagonSolo and args.canBeParagonSolo ~= false then
		args.canBeParagonSolo = true
	end
	if not args.canBeParagonPack and args.canBeParagonPack ~= false then
		args.canBeParagonPack = true
	end
	-- ╔════════════╦════════╦══════════════╗
	-- ║ Difficulty ║ Normal ║ Spirit world ║
	-- ╠════════════╬════════╬══════════════╣
	-- ║ Normal     ║ 1:600  ║ 1:200        ║
	-- ║ Elite      ║ 1:450  ║ 1:150        ║
	-- ║ Legend     ║ 1:300  ║ 1:100        ║
	-- ╚════════════╩════════╩══════════════╝
	local maxluck = 600 - (difficulty - 1) * 150
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
	-- local unit = ""
	-- if luck == 1 and args.canBeParagon and args.canBeParagonSolo then
	-- 	unit = Paragon:SpawnParagonUnit(args.unitName, args.spawnPoint)
	-- elseif luck == 2 and args.canBeParagon and args.canBeParagonPack then
	-- 	unit = Paragon:SpawnParagonPack(args.unitName, args.spawnPoint)
	-- else
	-- 	unit = CreateUnitByName(args.unitName, args.spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
	-- 	Events:AdjustDeathXP(unit)
	-- end
	local unit = CreateUnitByName(args.unitName, args.spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
	unit.itemLevel = args.itemLevel
	Spawning:SetDropModifier(unit, args.deathModifier)
	if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
		local enemyTier = unit.roshpit_attributes.enemy_tier
		if Beacons.cheats then
			if enemyTier == ENEMY_TYPE_WEAK_CREEP then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_weak_creep", {})
			elseif enemyTier == ENEMY_TYPE_NORMAL_CREEP then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_normal_creep", {})
			elseif enemyTier == ENEMY_TYPE_ELITE_CREEP then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_elite_creep", {})
			elseif enemyTier == ENEMY_TYPE_MINI_BOSS then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_mini_boss", {})
			elseif enemyTier == ENEMY_TYPE_BOSS then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_boss", {})
			elseif enemyTier == ENEMY_TYPE_MAJOR_BOSS then
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
		local enemyTier = unit.roshpit_attributes.enemy_tier
		local modifierToApply = ""
		if enemyTier == ENEMY_TYPE_WEAK_CREEP then
			modifierToApply = "modifier_weak_creep"
		elseif enemyTier == ENEMY_TYPE_NORMAL_CREEP then
			modifierToApply = "modifier_normal_creep"
		elseif enemyTier == ENEMY_TYPE_ELITE_CREEP then
			modifierToApply = "modifier_elite_creep"
		elseif enemyTier == ENEMY_TYPE_MINI_BOSS then
			modifierToApply = "modifier_mini_boss"
		elseif enemyTier == ENEMY_TYPE_BOSS then
			modifierToApply = "modifier_boss"
		elseif enemyTier == ENEMY_TYPE_MAJOR_BOSS then
			modifierToApply = "modifier_major_boss"
		end
		for i = 1, #unit.buddiesTable, 1 do
			unit.buddiesTable[i].type = args.enemyType
			unit.buddiesTable[i].itemLevel = args.itemLevel
			if Beacons.cheats then
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit.buddiesTable[i], modifierToApply, {})
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
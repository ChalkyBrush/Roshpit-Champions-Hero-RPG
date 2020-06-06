function Redfall:SpawnRedfallShroom(position)
	local unit = Enemies:SpawnEnemy("redfall_shroomling", position, nil, RandomVector(1), false)
	unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 70))
	unit:SetRenderColor(255, 57, 53)
	local ability = unit:FindAbilityByName("redfall_shroomling_ai")
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_redfall_shroomling_ai", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnAutumnGazer(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_autumn_gazer", position, nil, fv, false)
	unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 35))
	local colorRandomizer = RandomInt(1, 35)
	unit:SetRenderColor(255 - colorRandomizer, 159 - colorRandomizer, 159 - colorRandomizer)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnAutumnSpawner(position, fv, summonCenter)
	local unit = Enemies:SpawnEnemy("redfall_autumn_spawner", position, nil, fv, false)
	unit.summonCenter = summonCenter
	unit:SetAbsOrigin(Vector(unit:GetAbsOrigin().x, unit:GetAbsOrigin().y, position.z) + Vector(0, 0, Redfall.ZFLOAT))
	unit:SetRenderColor(214, 101, 101)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnAutumnSpawnerUnit(position, fv, itemRoll, bAggro, callback)
	local callbackFunction = function(unit)
		if callback then
			callback(unit)
		end
		unit:SetRenderColor(233, 100, 100)
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	end
	Enemies:SpawnEnemyAsync("redfall_autumn_flower", position, "Redfall.Flower.Aggro", fv, bAggro, callbackFunction)
end

function Redfall:SpawnAutumnSummoner(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_forest_summoner", position, "Redfall.ForestSummoner.Aggro", fv, false)
	unit:SetRenderColor(255, 118, 118)
	Redfall:ColorWearables(unit, Vector(255, 110, 110))
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnRedfallTreant(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_autumn_treant", position, nil, fv, false)
	unit:SetRenderColor(255, 130, 130)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnRedfallForestMinion(position, fv, bAggro)
	local unit = Enemies:SpawnEnemy("redfall_forest_minion", position, "Redfall.ForestMinion.Aggro", fv, bAggro)
	unit:SetRenderColor(255, 148, 0)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnWaterLily(position, fv, bAggro)
	local unit = Enemies:SpawnEnemy("redfall_aqua_lily", position, "Redfall.ForestMinion.Aggro", fv, bAggro)
	unit:SetRenderColor(0, 148, 255)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnWoodDweller(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_forest_wood_dweller", position, "Redfall.WoodDweller.Aggro", fv, false)
	unit:SetRenderColor(255, 158, 158)
	Redfall:ColorWearables(unit, Vector(255, 160, 160))
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit

end

function Redfall:SpawnWozxak(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_wozxak", position, "Redfall.Wozxak.Aggro", fv, false)
	unit:SetRenderColor(255, 158, 158)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit

end

function Redfall:SpawnOvergrowth(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_forest_overgrowth", position, "Redfall.Overgrowth.Aggro", fv, false)
	unit:SetRenderColor(255, 158, 158)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnDiscipleOfMaru(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_disciple_of_maru", position, "Redfall.Maru.Aggro", fv, true)
	unit:SetRenderColor(255, 158, 158)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_fire_effect", {})
	unit.targetRadius = 450
	unit.autoAbilityCD = 3
	CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/time_bind_damage.vpcf", unit, 2)
	unit:AddNewModifier(unit, nil, "modifier_animation", {translate = "walk"})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_disciple_of_maru_die", {})
	return unit
end

function Redfall:SpawnAutumnSpirit(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_autumn_spirit", position, "Redfall.AutumnSpirit.Aggro", fv, false)
	unit:SetRenderColor(255, 158, 158)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_fire_effect", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnBigFlower(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_big_autumn_flower", position, "Redfall.BigFlower.Aggro", fv, false)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_tree_split", {})
	unit:SetRenderColor(255, 118, 118)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit

end

function Redfall:SpawnForestGnome(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_forest_gnome", position, "Redfall.ForstGnome.Aggro", fv, false)
	Redfall:SetPositionCastArgs(unit, 800, 0, 1, FIND_ANY_ORDER)
	unit:SetRenderColor(255, 115, 60)
	Redfall:ColorWearables(unit, Vector(255, 115, 60))
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SetPositionCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
	unit.targetRadius = radius
	unit.minRadius = minRadius
	unit.targetAbilityCD = cooldown
	unit.targetFindOrder = targetFindOrder
end

function Redfall:SpawnCliffWeed(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_cliff_weed", position, "Redfall.CliffWeed.Aggro", fv, false)
	Redfall:SetPositionCastArgs(unit, 800, 0, 1, FIND_ANY_ORDER)
	unit:SetRenderColor(255, 161, 0)
	unit.targetRadius = 1500
	unit.autoAbilityCD = 1
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnCliffInvader(position, fv, wave)
	local unit = Enemies:SpawnEnemy("redfall_cliff_invader", position, nil, fv, true)
	unit:SetAbsOrigin(position - Vector(0, 0, 800))
	unit:SetRenderColor(0, 100, 255)
	local ability = unit:FindAbilityByName("arena_pit_crawler_ai")
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_arena_pit_crawler_enter", {})
	unit.fv = fv
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_cliff_invader", {})
    unit.wave = wave
	return unit
end

function Redfall:SpawnCliffInvaderRanged(position, fv, wave)
	local unit = Enemies:SpawnEnemy("redfall_cliff_invader_range", position, nil, fv, true)
	unit:SetAbsOrigin(position - Vector(0, 0, 800))
	unit:SetRenderColor(0, 100, 255)
	Redfall:ColorWearables(unit, Vector(0, 100, 255))
	local ability = unit:FindAbilityByName("arena_pit_crawler_ai")
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_arena_pit_crawler_enter", {})
	unit.fv = fv
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_cliff_invader", {})
    unit.wave = wave
	return unit
end

function Redfall:SpawnForestRanger(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_forest_ranger", position, "Redfall.ForestRanger.Aggro", fv, false)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_forest_ranger_die", {})
	return unit
end

function Redfall:SpawnRedRaven(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_red_raven", position, "Redfall.RedRaven.Aggro", fv, false)
	unit.jumpEnd = "basic_dust"
	unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 2000))
	WallPhysics:Jump(unit, Vector(1, 1), 0, 0, 0, 1)
	Timers:CreateTimer(1, function()
		EmitSoundOn("Redfall.RedRaven.Taunt", unit)
	end)
	Timers:CreateTimer(2, function()
		StartAnimation(unit, {duration = 2.5, activity = ACT_DOTA_SPAWN, rate = 0.8, translate = "manias_mask"})
	end)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_red_raven_die", {})
	return unit
end

function Redfall:SpawnStoneWatcher(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_stone_watcher", position, "Redfall.StoneWatcher.Aggro", fv, false)
	unit.targetRadius = 900
	unit.minRadius = 0
	unit.targetAbilityCD = 1
	unit.targetFindOrder = FIND_CLOSEST
	unit:SetRenderColor(255, 118, 118)
	Redfall:ColorWearables(unit, Vector(255, 110, 110))
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnSoulReacher(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_hooded_soul_reacher", position, "Redfall.SoulReacher.Aggro", fv, false)
	unit:SetRenderColor(255, 118, 118)
	Redfall:ColorWearables(unit, Vector(255, 110, 110))
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnAshSnake(position, fv, bAggro)
	local unit = Enemies:SpawnEnemy("redfall_ash_snake", position, "Redfall.AshSnake.Aggro", fv, bAggro)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnAshKnight(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_ashfall_knight", position, "Redfall.AshKnight.Aggro", fv, false)
	unit:SetRenderColor(255, 0, 0)
	Redfall:ColorWearables(unit, Vector(255, 0, 0))
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnAutumnSatyr(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_autumn_satyr", position, "Redfall.AutumnSatyr.Aggro", fv, false)
	unit:SetRenderColor(255, 127, 0)
	unit.targetRadius = 300
	unit.minRadius = 0
	unit.targetAbilityCD = 1
	unit.targetFindOrder = FIND_CLOSEST
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnAutumnVulture(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_redfall_vulture", position, "Redfall.AutumnVulture.Aggro", fv, false)
	unit:SetRenderColor(255, 127, 0)
	unit.targetRadius = 1000
	unit.minRadius = 0
	unit.targetAbilityCD = 2
	unit.targetFindOrder = FIND_ANY_ORDER
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})

	return unit
end

function Redfall:SpawnAutumnCragnataur(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_autumn_cragnataur", position, "Redfall.Cragnataur.Aggro", fv, false)
	unit:SetRenderColor(255, 127, 0)
	Redfall:ColorWearables(unit, Vector(255, 110, 0))
	unit.targetRadius = 1000
	unit.minRadius = 0
	unit.targetAbilityCD = 1
	unit.targetFindOrder = FIND_ANY_ORDER
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})

	return unit
end

function Redfall:SpawnCrimsythCultistForTree(position, fv, treeOrigin)
	local unit = Enemies:SpawnEnemy("redfall_crimsyth_cultist", position, nil, fv, true)
	unit:SetAbsOrigin(treeOrigin + Vector(0, 1) * 320 + Vector(0, 0, 800))
			unit:SetRenderColor(255, 50, 50)
	Redfall:ColorWearables(unit, Vector(255, 50, 50))
	StartAnimation(unit, {duration = 7, activity = ACT_DOTA_VICTORY, rate = 1})
	local ability = unit:FindAbilityByName("crimsyth_cultist_ai")
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_cultist_entering_spinning", {duration = 7})
	unit.rotationIndex = 1
	unit.treeOrigin = treeOrigin
	Timers:CreateTimer(7.1, function()
		FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
	end)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_crimsyth_cultist_die", {})
	return unit
end

function Redfall:SpawnCrimsythCultistForCultMaster(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_crimsyth_cultist", position, nil, fv, false)
    unit:SetRenderColor(255, 50, 50)
	Redfall:ColorWearables(unit, Vector(255, 50, 50))
	local ability = unit:FindAbilityByName("crimsyth_cultist_ai")
	unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 900))
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_cultist_entering", {duration = 5})
	WallPhysics:Jump(unit, Vector(1, 1), 0, 0, 0, 0.1)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_crimsyth_cultist_die", {})
	return unit
end

function Redfall:SpawnCrimsythCultMaster(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_crimsyth_cultist_master", position, nil, fv, false)
	unit:SetRenderColor(255, 127, 0)
	unit.targetRadius = 1100
	unit.minRadius = 0
	unit.targetAbilityCD = 1
	unit.targetFindOrder = FIND_FARTHEST
	local ability = unit:FindAbilityByName("crimsith_cult_master_pull")
	unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 900))
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_cultist_entering", {duration = 5})
	WallPhysics:Jump(unit, Vector(1, 1), 0, 0, 0, 0.1)
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Redfall.CultBoss.LaughEnter", unit)
	end)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_crimsyth_cultist_master_die", {})
	return unit
end

function Redfall:SpawnAshTreant(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_ashen_treant", position, "Redfall.AshTreeAggro", fv, true)			
	unit:SetRenderColor(255, 60, 60)
	Redfall:ColorWearables(unit, Vector(255, 60, 60))
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_crimsyth_cultist_master_die", {})
	return unit
end

function Redfall:SpawnStudentOfAshara(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_follower_of_ashara", position, "Redfall.AsharaStudent.Aggro", fv, false)
	unit:SetRenderColor(255, 127, 0)
	Redfall:ColorWearables(unit, Vector(255, 110, 0))
	unit.targetRadius = 1000
	unit.minRadius = 0
	unit.targetAbilityCD = 1
	unit.targetFindOrder = FIND_ANY_ORDER
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	return unit
end

function Redfall:SpawnRedfallAsharaWaveUnit(unitName, spawnPoint, wave, quantity, delay, bSound)
	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CaveUnitSpawn", Redfall.RedfallMaster)
			end
			local unit = Enemies:SpawnEnemy(unitName, spawnPoint, nil, fv, true)
			unit:SetAcquisitionRange(3000)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit, 2)
			if unit:GetUnitName() == "redfall_troll_warlord" then
				unit:SetRenderColor(255, 140, 30)
			elseif unit:GetUnitName() == "redfall_follower_of_ashara" then
				unit:SetRenderColor(255, 120, 0)
				Redfall:ColorWearables(unit, Vector(255, 120, 0))
				unit:SetModelScale(unit:GetModelScale() * 0.74)
				unit.targetRadius = 1000
				unit.minRadius = 0
				unit.targetAbilityCD = 1
				unit.targetFindOrder = FIND_ANY_ORDER
			elseif unit:GetUnitName() == "redfall_armored_crab_beast" or unit:GetUnitName() == "redfall_autumn_mage" or unit:GetUnitName() == "redfall_canyon_alpha_beast" or unit:GetUnitName() == "redfall_canyon_breaker" then
				unit:SetRenderColor(255, 120, 0)
				Redfall:ColorWearables(unit, Vector(255, 120, 0))
				unit.targetRadius = 1000
				unit.minRadius = 0
				unit.targetAbilityCD = 1
				unit.targetFindOrder = FIND_ANY_ORDER
			end
			unit.wave = wave
			Redfall.AsharaWavesCounters[wave]["total"] = Redfall.AsharaWavesCounters[wave]["total"] + 1
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_ashara_wave_unit", {})
		end)
	end
end

function Redfall:SpawnAshara(position, fv)
	local unit = Enemies:SpawnEnemy("redfall_ashara", position, "Redfall.Ashara.Aggro", fv, true)
	unit.jumpEnd = "basic_dust"
	unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 2000))
	unit.type = ENEMY_TYPE_BOSS
	WallPhysics:Jump(unit, Vector(1, 1), 0, 0, 0, 1)
	Timers:CreateTimer(1, function()
		EmitSoundOn("Redfall.Ashara.Taunt", unit)
	end)
	Timers:CreateTimer(2, function()
		StartAnimation(unit, {duration = 2.5, activity = ACT_DOTA_SPAWN, rate = 0.8, translate = "manias_mask"})
	end)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_ashara_die", {})
	return unit
end

function Redfall:SpawnFenrirGhost()
	
	local unit = Enemies:SpawnEnemy("redfall_fenrir", Vector(-2114, -11472), nil, Vector(1, 0), false)
	unit:SetRenderColor(255, 158, 158)
	local ability = unit:FindAbilityByName("redfall_fenrir_ability")
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_fenrir_ghost", {})
	unit.movementTable = {Vector(-15680, -12864), Vector(-12176, -12322), Vector(-11682, -10065), Vector(-9487, -8279), Vector(-10560, -14528), Vector(-5828, -14311), Vector(-2114, -11472), Vector(-6080, -12096), Vector(-7309, -10572), Vector(-2424, -10367), Vector(-4864, -9216), Vector(-3392, -6720), Vector(-87, -6563), Vector(-5952, -4800), Vector(-3072, -4375), Vector(-9618, -5890), Vector(-6720, -9024)}
	FindClearSpaceForUnit(unit, unit.movementTable[RandomInt(1, #unit.movementTable)], false)
	unit.targetPoint = unit.movementTable[RandomInt(1, #unit.movementTable)]
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})

	return unit
end

function Redfall:SpawnFenrir()
	local movementTable = {Vector(-15680, -12864), Vector(-12176, -12322), Vector(-11682, -10065), Vector(-9487, -8279), Vector(-10560, -14528), Vector(-5828, -14311), Vector(-2114, -11472), Vector(-6080, -12096), Vector(-7309, -10572), Vector(-2424, -10367), Vector(-4864, -9216), Vector(-3392, -6720), Vector(-87, -6563), Vector(-5952, -4800), Vector(-3072, -4375), Vector(-9618, -5890), Vector(-6720, -9024)}
	local spawnPoint = movementTable[RandomInt(1, #movementTable)]
	local firstTarget = movementTable[RandomInt(1, #movementTable)]
	local unit = Enemies:SpawnEnemy("redfall_fenrir", spawnPoint, "Redfall.Fenrir.Aggro", Vector(1, 0), false)
	unit:SetRenderColor(255, 158, 158)
	local ability = unit:FindAbilityByName("redfall_fenrir_ability")
	unit.movementTable = movementTable
	unit.targetPoint = firstTarget
	unit:MoveToPosition(unit.targetPoint)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_fenrir", {})
	return unit

end

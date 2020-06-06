
function Redfall:SpawnRedfallForestMinionAsync(position, fv, bAggro, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        unit:SetRenderColor(255, 148, 0)
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
    Enemies:SpawnEnemyAsync("redfall_forest_minion", position, "Redfall.ForestMinion.Aggro", fv, bAggro, callback)
end

function Redfall:SpawnAutumnSummonerAsync(position, fv, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        unit:SetRenderColor(255, 118, 118)
        Redfall:ColorWearables(unit, Vector(255, 110, 110))
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
	Enemies:SpawnEnemyAsync("redfall_forest_summoner", position, "Redfall.ForestSummoner.Aggro", fv, false, callback)
end

function Redfall:SpawnAutumnSpawnerAsync(position, fv, summonCenter, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        unit.summonCenter = summonCenter
        unit:SetAbsOrigin(Vector(unit:GetAbsOrigin().x, unit:GetAbsOrigin().y, position.z) + Vector(0, 0, Redfall.ZFLOAT))
        unit:SetRenderColor(214, 101, 101)
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
    Enemies:SpawnEnemyAsync("redfall_autumn_spawner", position, nil, fv, false, callback)
end

function Redfall:SpawnBigFlowerAsync(position, fv, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_tree_split", {})
        unit:SetRenderColor(255, 118, 118)
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
	Enemies:SpawnEnemyAsync("redfall_big_autumn_flower", position, "Redfall.BigFlower.Aggro", fv, false, callback)
end

function Redfall:SpawnCliffWeedAsync(position, fv, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        Redfall:SetPositionCastArgs(unit, 800, 0, 1, FIND_ANY_ORDER)
        unit:SetRenderColor(255, 161, 0)
        unit.targetRadius = 1500
        unit.autoAbilityCD = 1
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
	Enemies:SpawnEnemyAsync("redfall_cliff_weed", position, "Redfall.CliffWeed.Aggro", fv, false, callback)
end

function Redfall:SpawnAutumnGazerAsync(position, fv, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 35))
        local colorRandomizer = RandomInt(1, 35)
        unit:SetRenderColor(255 - colorRandomizer, 159 - colorRandomizer, 159 - colorRandomizer)
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
	Enemies:SpawnEnemyAsync("redfall_autumn_gazer", position, nil, fv, false, callback)
end

function Redfall:SpawnForestGnomeAsync(position, fv, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        Redfall:SetPositionCastArgs(unit, 800, 0, 1, FIND_ANY_ORDER)
        unit:SetRenderColor(255, 115, 60)
        Redfall:ColorWearables(unit, Vector(255, 115, 60))
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
	Enemies:SpawnEnemyAsync("redfall_forest_gnome", position, "Redfall.ForstGnome.Aggro", fv, false, callback)
end

function Redfall:SpawnWoodDwellerAsync(position, fv, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        unit:SetRenderColor(255, 158, 158)
        Redfall:ColorWearables(unit, Vector(255, 160, 160))
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
	Enemies:SpawnEnemyAsync("redfall_forest_wood_dweller", position, "Redfall.WoodDweller.Aggro", fv, false, callback)
end

function Redfall:SpawnOvergrowthAsync(position, fv, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        unit:SetRenderColor(255, 158, 158)
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
    Enemies:SpawnEnemyAsync("redfall_forest_overgrowth", position, "Redfall.Overgrowth.Aggro", fv, false, callback)
end

function Redfall:SpawnRedfallAsharaWaveUnitAsync(unitName, spawnPoint, wave, quantity, delay, bSound)
	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CaveUnitSpawn", Redfall.RedfallMaster)
			end
            local callback = function(unit)
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
            end
            Enemies:SpawnEnemyAsync(unitName, spawnPoint, nil, fv, true, callback)
		end)
	end
end

function Redfall:SpawnRedfallShroomAsync(position)
    local callback = function(unit)        
        unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 70))
        unit:SetRenderColor(255, 57, 53)
        local ability = unit:FindAbilityByName("redfall_shroomling_ai")
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_redfall_shroomling_ai", {})
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
    Enemies:SpawnEnemyAsync("redfall_shroomling", position, nil, RandomVector(1), false, callback)
end

function Redfall:SpawnWaterLilyAsync(position, fv, bAggro, callbackFunction)
    local callback = function(unit)
        if callbackFunction and type(callbackFunction) == "function"  then
            callbackFunction(unit)
        end
        unit:SetRenderColor(0, 148, 255)
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    end
	Enemies:SpawnEnemyAsync("redfall_aqua_lily", position, "Redfall.ForestMinion.Aggro", fv, bAggro, callback)
end
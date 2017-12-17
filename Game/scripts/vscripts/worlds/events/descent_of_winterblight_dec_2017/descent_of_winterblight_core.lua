function Events:GetWinterblightPositions()
	if GameState:GetDifficultyFactor() > 1 then
		Timers:CreateTimer(15, function()
			if SaveLoad.key1 then
				local url = ROSHPIT_URL.."/champions/winterblight_positions?"
				url = url.."key1="..SaveLoad.key1
				url = url.."&key2="..SaveLoad.key2
				CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
					if result.StatusCode == 200 then
						local resultTable = JSON:decode(result.Body)
						Events:ProcessWinterblight(resultTable)
					else

					end
				end )
				return 120
			else
				return 20
			end
		end)
	end
end

function Events:ProcessWinterblight(resultTable)
	print("PROCESS")
	DeepPrintTable(resultTable)
	if not Events.Ozubu then
		if not Events.OzubuSlain then
			if GetMapName() == resultTable.ozubu_map then
				Events:SpawnOzubu(Vector(resultTable.ozubu_x, resultTable.ozuby_y))
			end
		end
	else
		if Events.OzubuSlain then
		else
			if GetMapName() == resultTable.ozubu_map then
			else
				Events:WinterblightBossFlee(Events.Ozubu)
			end
		end
	end

	if not Events.Aertega then
		if not Events.AertegaSlain then
			if GetMapName() == resultTable.aertega_map then
				Events:SpawnAertega(Vector(resultTable.aertega_x, resultTable.aertega_y))
			end
		end
	else
		if Events.AertegaSlain then
		else
			if GetMapName() == resultTable.aertega_map then
			else
				Events:WinterblightBossFlee(Events.Aertega)
			end
		end
	end

	if not Events.Torturok then
		if not Events.TorturokSlain then
			if GetMapName() == resultTable.torturok_map then
				Events:SpawnTorturok(Vector(resultTable.torturok_x, resultTable.torturok_y))
			end
		end
	else
		if Events.TorturokSlain then
		else
			if GetMapName() == resultTable.torturok_map then
			else
				Events:WinterblightBossFlee(Events.Torturok)
			end
		end
	end
end

function Events:WinterblightBossFlee(boss)
	if boss.aggro then
		return false
	end
	if boss:GetUnitName() == "descent_of_winterblight_ozubu" then
		Events.Ozubu = nil
	end
	if boss:GetUnitName() == "descent_of_winterblight_aertega" then
		Events.Aertega = nil
	end
	if boss:GetUnitName() == "descent_of_winterblight_torturok" then
		Events.Torturok = nil
	end
	if IsValidEntity(boss) then
		Events:smoothSizeChange(boss, boss:GetModelScale(), 0.5, 60)
		for i = 1, 60, 1 do
			Timers:CreateTimer(0.03, function()
				boss:SetAbsOrigin(boss:GetAbsOrigin()+Vector(0,0,6))
			end)
		end
		Timers:CreateTimer(1.9, function()
			EmitSoundOnLocationWithCaster(boss:GetAbsOrigin(), "Winterblight.BossOut", boss)
	        local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
	        ParticleManager:SetParticleControl(pfx, 0, boss:GetAbsOrigin())
	        ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.8, 0.7))
	        ParticleManager:SetParticleControl(pfx, 2, Vector(0.6,0.6,0.6))
	        Timers:CreateTimer(10, function() 
	          ParticleManager:DestroyParticle( pfx, false )
	          ParticleManager:ReleaseParticleIndex(pfx)
	        end)
	        ScreenShake(boss:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
			UTIL_Remove(boss)
		end)
	end
end

function Events:SpawnAertega(position)
	PrecacheUnitByNameAsync("descent_of_winterblight_aertega", function(...) end)
	Timers:CreateTimer(3, function()
		Events.Aertega = Events:SpawnDescentOfWinterblightDungeonUnit("descent_of_winterblight_aertega", position, 9, 12, "Events.DescentOfWinterblight.Aertega.Aggro", RandomVector(1), false)
		Events.Aertega:SetRenderColor(100, 100, 255)
	end)
end

function Events:SpawnTorturok(position)
	PrecacheUnitByNameAsync("descent_of_winterblight_torturok", function(...) end)
	Timers:CreateTimer(3, function()
		Events.Torturok = Events:SpawnDescentOfWinterblightDungeonUnit("descent_of_winterblight_torturok", position, 9, 12, "Torturok.Aggro", RandomVector(1), false)
		Events.Torturok:SetRenderColor(100, 100, 255)
		if GameState:GetDifficultyFactor() == 3 then
			Events.Torturok.reduc = 0.999999
		end
	end)
end

function Events:SpawnOzubu(position)
	PrecacheUnitByNameAsync("descent_of_winterblight_ozubu", function(...) end)
	PrecacheUnitByNameAsync("ozubu_spiderling", function(...) end)
	Timers:CreateTimer(3, function()
		Events.Ozubu = Events:SpawnDescentOfWinterblightDungeonUnit("descent_of_winterblight_ozubu", position, 9, 12, "Winterblight.Ozubu.Aggro", RandomVector(1), false)
		Events.Ozubu:SetRenderColor(200, 200, 255)
		Events.Ozubu.maxSummons = (1 - (Events.Ozubu:GetHealth()/Events.Ozubu:GetMaxHealth()))*23 + 2
	end)
end

function Events:SpawnDescentOfWinterblightDungeonUnit(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)
	local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:AdjustDeathXP(unit)
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
    -- Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    if fv then
      unit:SetForwardVector(fv)
    end
    if isAggro then
      Dungeons:AggroUnit(unit)
    end
    Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit,"modifier_sea_fortress_ai", {})
    -- unit.reduc = 0
    if GameState:GetDifficultyFactor() == 3 then
    	unit.reduc = 0.99999
    elseif GameState:GetDifficultyFactor() == 2 then
    	unit.reduc = 0.9
    end
    return unit
end

function Events:MithrilReward(position, amount)
  Timers:CreateTimer(5, function()
        local mithrilReward = amount*Events.ResourceBonus
        local crystal = CreateUnitByName("arcane_crystal", position+Vector(0,0,1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward*(1+GameState:GetPlayerPremiumStatusCount()*0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward/200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()


      if #crystal.winnerTable > 0 then
          -- for i = 1, #crystal.winnerTable, 1 do
          --   crystal.winnerTable[i].shardsPickedUp = 0
          -- end
          Timers:CreateTimer(1.4, function()
            EmitSoundOn("Resource.MithrilShardEnter", crystal)
          end)
        end

  end)
end
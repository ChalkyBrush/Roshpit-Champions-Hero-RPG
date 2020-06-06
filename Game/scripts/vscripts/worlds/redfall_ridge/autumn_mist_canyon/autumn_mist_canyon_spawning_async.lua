
function Redfall:SpawnCaveWaveUnit(unitName, spawnPoint, wave, quantity, delay, bSound)
	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CaveUnitSpawn", Redfall.RedfallMaster)
			end
            local callback = function(unit)
				unit.dominion = true
				unit:SetAcquisitionRange(3000)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit, 2)
				if unit:GetUnitName() == "redfall_troll_warlord" then
					unit:SetRenderColor(255, 140, 30)
				elseif unit:GetUnitName() == "redfall_ashfall_knight" then
					unit:SetRenderColor(255, 0, 0)
					Redfall:ColorWearables(unit, Vector(255, 0, 0))
				elseif unit:GetUnitName() == "redfall_mist_assassin" then
					unit:SetRenderColor(255, 100, 100)
					Redfall:ColorWearables(unit, Vector(255, 100, 100))
				end
                unit.wave = wave
                Redfall.AutumnMistCanyonWavesCounters[wave]["total"] = Redfall.AutumnMistCanyonWavesCounters[wave]["total"] + 1
            end
            Enemies:SpawnEnemyAsync(unitName, spawnPoint, nil, fv, true, callback)
		end)
	end
end
function Winterblight:CaveGuideSpawn()
	if not Winterblight.CaveGuideSpawned then
		if Winterblight.CaveGuideReady then
			print("TRIGGERED")
			Winterblight.CaveGuideSpawned = true
			local spawnPos = GetGroundPosition(Vector(-5427, 6930), Events.GameMaster)
			local guide = CreateUnitByName("winterblight_cavern_guide", spawnPos, false, nil, nil, DOTA_TEAM_GOODGUYS)
			guide:SetForwardVector(Vector(-1,1))
			StartAnimation(guide, {duration=12, activity=ACT_DOTA_VERSUS, rate=0.7})
			EmitSoundOnLocationWithCaster(spawnPos, "Winterblight.GuideCaveIntro2", Events.GameMaster)
			CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", spawnPos, 3)
			CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", spawnPos, 3)
			for i = 1, 6, 1 do
				Timers:CreateTimer(2*i, function()
					EmitSoundOnLocationWithCaster(spawnPos, "Winterblight.Cave.GuideIntro1", Events.GameMaster)
					CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", spawnPos, 3)
				end)
			end
			guide:SetAbsOrigin(guide:GetAbsOrigin()+Vector(0,0,2000))
			guide:SetModelScale(1.3)
			guide:SetRenderColor(60, 50, 255)
			local ability = guide:FindAbilityByName("winterblight_cave_guide_ability")
			ability:ApplyDataDrivenModifier(guide, guide, "modifier_guide_entering", {duration = 60})
		end
	end
end


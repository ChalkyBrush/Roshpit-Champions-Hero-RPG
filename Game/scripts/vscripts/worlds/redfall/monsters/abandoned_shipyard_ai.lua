function ShipyardWater(trigger)
	--print("ENTER?")
	local hero = trigger.activator
	if hero:HasModifier("modifier_redfall_shipyard_water") then
		return false
	end
	if not Filters:IsTouchingGround(hero) then
		return false
	end
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_redfall_shipyard_water", {})
	hero.lockPoint = hero:GetAbsOrigin()
	for i = 1, 90, 1 do
		Timers:CreateTimer(i*0.03, function()
			hero:SetAbsOrigin(hero.lockPoint-Vector(0,0,i))
		end)
	end
	StartSoundEvent("Redfall.ShipyardWaterEnter", hero)
	Dungeons:LockCameraToUnitForPlayers(hero, 5, {hero})
	Timers:CreateTimer(2.7, function()
		local particleName = "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf"
	  	local position = hero:GetAbsOrigin()
	  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	  	ParticleManager:SetParticleControl(pfx, 0, position)
	  	ParticleManager:SetParticleControl(pfx, 1, position)
		  Timers:CreateTimer(3, function()
			   ParticleManager:DestroyParticle(pfx, false)
		  end)	

		  hero:AddNoDraw()
		  Timers:CreateTimer(1, function()
		  	StopSoundEvent("Redfall.ShipyardWaterEnter", hero)
		  	hero:RemoveNoDraw()
		  	hero:SetAbsOrigin(Vector(15552, -14272, -180+Redfall.ZFLOAT))
		  	WallPhysics:Jump(hero, Vector(-1,0), 22, 28, 30, 1)
		  	Timers:CreateTimer(0.2, function()
				EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "Redfall.WaterSplash", Redfall.RedfallMaster)
		  		local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
		  	  	local position = hero:GetAbsOrigin()
		  	  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		  	  	ParticleManager:SetParticleControl(pfx, 0, position)
		  		  Timers:CreateTimer(2, function()
		  			   ParticleManager:DestroyParticle(pfx, false)
		  		  end)	
		  	end)
		  	Timers:CreateTimer(1.2, function()
		  		hero:RemoveModifierByName("modifier_redfall_shipyard_water")
		  	end)
		  end)
	end)
	if hero:HasModifier("modifier_redfall_inside_shredder") then
		local shredder = hero.shredder
		EmitSoundOn("Redfall.FriendlyShredder.Destruct", shredder)
		Timers:CreateTimer(0.1, function()
			UTIL_Remove(shredder)
			hero.shredder = nil
			hero:RemoveNoDraw()
			CustomAbilities:QuickAttachParticle("particles/econ/items/shredder/timber_controlled_burn/timber_controlled_burn_tree_kill.vpcf", hero, 5)
			hero:RemoveModifierByName("modifier_redfall_inside_shredder")
		end)
	end
end

function ShipyardWater2(trigger)
	ShipyardWater(trigger)
end

function bloodhunter_summon_wolves(event)
	local caster = event.caster
	local ability = event.ability
	local loops = GameState:GetDifficultyFactor() + 1
	EmitSoundOn("Redfall.BloodHunter.SummonWolves", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", caster, 3)
	if GameState:IsRedfallRidge() then
		for i = 1, loops, 1 do
			local spider = Redfall:SpawnBloodWolf(caster:GetAbsOrigin()+RandomVector(RandomInt(100, 180)), caster:GetForwardVector())
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", spider, 2)
		end
	end
end

function SpawnShipyardArea2(event)
	Redfall:SpawnShipyardArea2()
end

function skeleton_boss_arrow_impact(event)
	local caster = event.caster
	local target = event.target
	local radius = 300
	local damage = event.damage
	local ability = event.ability
      local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
      local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
      ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )
      Timers:CreateTimer(1.5, 
      function()
        ParticleManager:DestroyParticle( particle2, false )
      end)
      EmitSoundOn("Redfall.FireballImpact", target)
      local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin() )
      Timers:CreateTimer(2, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	end 
end

function lobster_statue_enemy_die(event)
	if not Redfall.RedfallLobsterKills then
		Redfall.RedfallLobsterKills = 0
	end
	local unit = event.unit
	Redfall.RedfallLobsterKills = Redfall.RedfallLobsterKills + 1
	if Redfall.RedfallLobsterKills == 12 then
		local lobsterHead = Entities:FindByNameNearest("LobsterStatueHead", Vector(12216, -7621, -337+Redfall.ZFLOAT), 750)
		EmitSoundOnLocationWithCaster(Vector(12216, -7821, Redfall.ZFLOAT), "Redfall.LobsterStatueActivate", Redfall.RedfallMaster)
		Timers:CreateTimer(4, function()
			for j = 1, 11, 1 do
				Timers:CreateTimer(j*0.3, function()
					local spawnPosition = Vector(11434+RandomInt(1, 780), -8176+RandomInt(1, 300))
					local rat = Redfall:SpawnShipyardDemonVoid(spawnPosition, RandomVector(1), true)
					Redfall:RedBeam(lobsterHead:GetAbsOrigin(), GetGroundPosition(spawnPosition, Events.GameMaster))
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, rat, "modifier_lobster_statue_enemy", {})
				end)
			end
		end)
	elseif Redfall.RedfallLobsterKills == 22 then
		local lobsterHead = Entities:FindByNameNearest("LobsterStatueHead", Vector(12216, -7621, -337+Redfall.ZFLOAT), 750)
		EmitSoundOnLocationWithCaster(Vector(12216, -7821, Redfall.ZFLOAT), "Redfall.LobsterStatueActivate", Redfall.RedfallMaster)
		Timers:CreateTimer(4, function()
			for j = 1, 11, 1 do
				Timers:CreateTimer(j*0.3, function()
					local spawnPosition = Vector(11434+RandomInt(1, 780), -8176+RandomInt(1, 300))
					local rat = Redfall:SpawnShipyardDemonBrute(spawnPosition, RandomVector(1), true)
					Redfall:RedBeam(lobsterHead:GetAbsOrigin(), GetGroundPosition(spawnPosition, Events.GameMaster))
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, rat, "modifier_lobster_statue_enemy", {})
				end)
			end
		end)
	elseif Redfall.RedfallLobsterKills == 31 then
		local lobsterHead = Entities:FindByNameNearest("LobsterStatueHead", Vector(12216, -7621, -337+Redfall.ZFLOAT), 750)
		EmitSoundOnLocationWithCaster(Vector(12216, -7821, Redfall.ZFLOAT), "Redfall.LobsterStatueActivate", Redfall.RedfallMaster)
		Timers:CreateTimer(4, function()
			for j = 1, 12, 1 do
				Timers:CreateTimer(j*0.3, function()
					local spawnPosition = Vector(11434+RandomInt(1, 780), -8176+RandomInt(1, 300))
					local rat = nil
					if j%3 == 0 then
						rat = Redfall:SpawnShipyardDemonBrute(spawnPosition, RandomVector(1), true)
					elseif j%3 == 1 then
						rat = Redfall:SpawnShipyardDemonVoid(spawnPosition, RandomVector(1), true)
					elseif j%3 == 2 then
						rat = Redfall:SpawnSkeletonArcher(spawnPosition, RandomVector(1), true)
					end
					Redfall:RedBeam(lobsterHead:GetAbsOrigin(), GetGroundPosition(spawnPosition, Events.GameMaster))
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, rat, "modifier_lobster_statue_enemy", {})
				end)
			end
		end)
	elseif Redfall.RedfallLobsterKills == 43 then
		local lobsterHead = Entities:FindByNameNearest("LobsterStatueHead", Vector(12216, -7621, -337+Redfall.ZFLOAT), 750)
		EmitSoundOnLocationWithCaster(Vector(12216, -7821, Redfall.ZFLOAT), "Redfall.LobsterStatueActivate", Redfall.RedfallMaster)
		Timers:CreateTimer(4, function()
			local skeletonCount = GameState:GetDifficultyFactor() + 2
			for j = 1, skeletonCount, 1 do
				Timers:CreateTimer(j*0.3, function()
					local spawnPosition = Vector(11434+RandomInt(1, 780), -8176+RandomInt(1, 300))
					local rat = Redfall:SpawnSkeletonArcherBoss(spawnPosition, RandomVector(1), true)
					Redfall:RedBeam(lobsterHead:GetAbsOrigin(), GetGroundPosition(spawnPosition, Events.GameMaster))
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, rat, "modifier_lobster_statue_enemy", {})
				end)
			end
		end)
	end
	if unit:GetUnitName() == "shipyard_skeleton_archer_boss" then
		if not Redfall.RedfallArcherBossKills then
			Redfall.RedfallArcherBossKills = 0
		end
		Redfall.RedfallArcherBossKills = Redfall.RedfallArcherBossKills + 1
		if Redfall.RedfallArcherBossKills == (GameState:GetDifficultyFactor() + 2) then
			local lobsterHead = Entities:FindByNameNearest("LobsterStatueHead", Vector(12216, -7621, -337+Redfall.ZFLOAT), 750)
			local rat = Redfall:SpawnShipyardConductor(Vector(11072, -7488), Vector(1,-1), false)
			Redfall:RedBeam(lobsterHead:GetAbsOrigin(), GetGroundPosition(Vector(11072, -7488), Events.GameMaster))
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, rat, "modifier_lobster_statue_enemy", {})
		end
	elseif unit:GetUnitName() == "redfall_shipyard_conductor" then
		Redfall:DropShipyardSwitch1()
	end
end

function cast_skeleton_boss_fireball(event)
	local caster = event.caster
	local ability = event.ability
	local targetPoint = event.target_points[1]

		local casterOrigin = caster:GetAbsOrigin()
		local speed = 900
		local fv = ((targetPoint - casterOrigin)*Vector(1,1,0)):Normalized()
		local info = 
		{
				Ability = ability,
	        	EffectName = "particles/roshpit/warlord/fire_ulti_linear.vpcf",
	        	vSpawnOrigin = casterOrigin+Vector(0,0,150),
	        	fDistance = 2000,
	        	fStartRadius = 180,
	        	fEndRadius = 180,
	        	Source = caster,
	        	StartPosition = "attach_attack1",
	        	bHasFrontalCone = false,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv*Vector(1,1,0) * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	
end


function AbandonedShipyardLobsterTrigger(event)
	Redfall:AbandonedShipyardLobsterTrigger()
end

function ShipyardSwitch1Trigger(trigger)
	if Redfall.Shipyard.Switch1Active then
		if not Redfall.Shipyard.Switch1Pressed then
			Redfall.Shipyard.Switch1Pressed = true
			Redfall:ActivateSwitchGeneric(Vector(10896, -6295, -124 + Redfall.ZFLOAT), "ShipyardSwitch1", true, 0.17)
			Dungeons:CreateBasicCameraLockForHeroes(Vector(15088, -6883, -516 + Redfall.ZFLOAT), 5, {trigger.activator})
			AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(15088, -6883, -516 + Redfall.ZFLOAT), 1300, 6, true)
			Redfall:LowerSwitch2andSpawners()
		end
	end
end

function ShipyardSwitch2Trigger(event)
	if Redfall.Shipyard.Switch2Active then
		if not Redfall.Shipyard.Switch2Pressed then
			Redfall.Shipyard.Switch2Pressed = true
			Redfall:ActivateSwitchGeneric(Vector(15088, -6879, -516 + Redfall.ZFLOAT), "ShipyardSwitch2", true, 0.17)
			Redfall:Switch2Pressed()
		end
	end
end

function shipyard_wave_unit_die(event)
	if not Redfall.Shipyard.WaveUnitsKilled then
		Redfall.Shipyard.WaveUnitsKilled = 0
	end
	Redfall.Shipyard.WaveUnitsKilled = Redfall.Shipyard.WaveUnitsKilled + 1
	if Redfall.Shipyard.WaveUnitsKilled == 36 then
		local spawnPositionTable = {Vector(14275, -6679), Vector(15723, -6489), Vector(15093, -7482)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 2 then
				Redfall:SpawnShipyardWaveUnit("shipyard_skeleton_archer", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 3 then
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_demon_wolf", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_demon_wolf", spawnPositionTable[i], 13, 33, delay, true)
			end

		end
	elseif Redfall.Shipyard.WaveUnitsKilled == 74 then
		local spawnPositionTable = {Vector(14275, -6679), Vector(15723, -6489), Vector(15093, -7482)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 2 then
				Redfall:SpawnShipyardWaveUnit("redfall_harvest_wraith", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 3 then
				Redfall:SpawnShipyardWaveUnit("redfall_harvest_wraith", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_void", spawnPositionTable[i], 13, 33, delay, true)
			end

		end
	elseif Redfall.Shipyard.WaveUnitsKilled == 112 then
		local spawnPositionTable = {Vector(14275, -6679), Vector(15723, -6489), Vector(15093, -7482)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 2 then
				Redfall:SpawnShipyardWaveUnit("water_temple_armored_water_beetle", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 3 then
				Redfall:SpawnShipyardWaveUnit("water_temple_armored_water_beetle", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnShipyardWaveUnit("water_temple_armored_water_beetle", spawnPositionTable[i], 13, 33, delay, true)
			end

		end
	elseif Redfall.Shipyard.WaveUnitsKilled == 148 then
		local spawnPositionTable = {Vector(14275, -6679), Vector(15723, -6489), Vector(15093, -7482)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 2 then
				Redfall:SpawnShipyardWaveUnit("redfall_farmlands_thief", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 3 then
				Redfall:SpawnShipyardWaveUnit("redfall_farmlands_thief", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnShipyardWaveUnit("redfall_farmlands_thief", spawnPositionTable[i], 13, 33, delay, true)
			end

		end
	elseif Redfall.Shipyard.WaveUnitsKilled == 180 then
		local spawnPositionTable = {Vector(14275, -6679), Vector(15723, -6489), Vector(15093, -7482)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 2 then
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_crimsyth_blood_hunter", spawnPositionTable[i], 5, 33, delay, true)
			elseif i == 3 then
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_crimsyth_blood_hunter", spawnPositionTable[i], 5, 33, delay, true)
			else
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_demon_wolf", spawnPositionTable[i], 5, 33, delay, true)
			end

		end
	elseif Redfall.Shipyard.WaveUnitsKilled == 195 then
		local spawnPositionTable = {Vector(14275, -6679), Vector(15723, -6489), Vector(15093, -7482)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 2 then
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_haunt_knight", spawnPositionTable[i], 7, 33, delay, true)
			elseif i == 3 then
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_haunt_knight", spawnPositionTable[i], 7, 33, delay, true)
			else
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_haunt_knight", spawnPositionTable[i], 7, 33, delay, true)
			end

		end
	elseif Redfall.Shipyard.WaveUnitsKilled == 216 then
		local spawnPositionTable = {Vector(14275, -6679), Vector(15723, -6489), Vector(15093, -7482)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 2 then
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_haunt_knight", spawnPositionTable[i], 6, 33, delay, true)
			elseif i == 3 then
				Redfall:SpawnShipyardWaveUnit("shipyard_skeleton_archer", spawnPositionTable[i], 6, 33, delay, true)
			else
				Redfall:SpawnShipyardWaveUnit("redfall_shipyard_crimsyth_blood_hunter", spawnPositionTable[i], 6, 33, delay, true)
			end

		end		
	elseif Redfall.Shipyard.WaveUnitsKilled == 234 then
		for i = 1, #Redfall.shipyardSpawnPortalTable, 1 do
			ParticleManager:DestroyParticle(Redfall.shipyardSpawnPortalTable[i], false)
		end
		Redfall:ShipyardGatekeeperBoss()
	end
end

function skulldigger_hellfire_hit(event)
	local target = event.target
	
	local ability = event.ability
	local caster = ability.caster
	local stun_duration = event.stun_duration
	local attack_mult = event.attack_mult
	local damage = event.damage

	EmitSoundOn("RoshpitItem.SkulldiggerImpact", target)

	local radius = 240
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
	ParticleManager:SetParticleControl( particle2, 4, Vector(0, 220, 100) )
	Timers:CreateTimer(1.5, 
		function()
		ParticleManager:DestroyParticle( particle2, false )
	end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:ApplyStun(caster, stun_duration, enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	end

end

function shipyard_aoe_phase_start(event)
	local caster = event.caster
    local particle1 = ParticleManager:CreateParticle("particles/frostivus_gameplay/wraith_king_hellfire_eruption_tell.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
   --print("eruption?")
    for i = 0, 9, 1 do
    	ParticleManager:SetParticleControl(particle1,i,caster:GetAbsOrigin())
    end
    Timers:CreateTimer(4.0, function()
    	ParticleManager:DestroyParticle( particle1, false )
    end)
	 
end

function shipyard_aoe_blast_start(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.Gatekeeper.AOEexplosion", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf", caster, 2)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "RoshpitItem.SkulldiggerLaunch", Events.GameMaster)

	for i = -5, 5, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), (2*math.pi/11)*i)
			local speed = 700
			local info = 
			{
					Ability = ability,
		        	EffectName = "particles/units/heroes/hero_skeletonking/hellfireblast_linear.vpcf",
		        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,220),
		        	fDistance = 1300,
		        	fStartRadius = 120,
		        	fEndRadius = 120,
		        	Source = caster,
		        	StartPosition = "attach_hitloc",
		        	bHasFrontalCone = true,
		        	bReplaceExisting = false,
		        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        	fExpireTime = GameRules:GetGameTime() + 8.0,
				bDeleteOnHit = false,
				vVelocity = fv * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)	
	end
end

function shipyard_aoe_blast_impact(event)
	local target = event.target
	local caster = event.caster
	local stun_duration = event.stun_duration
	Filters:ApplyStun(caster, stun_duration, target)
	
end

function shipyard_gatekeeper_die(event)
	local caster = event.caster
	EmitSoundOn("Redfall.ShipyardGatekeeper.Death", caster)
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollSkulldiggerGloves(caster:GetAbsOrigin())
	end
	Redfall:SpawnShipyardFerry()
end

function BoatTriggerA(trigger)
	----print(Redfall.Shipyard.boatsEnabled)
	----print(Redfall.Shipyard.boatAlock)
	if Redfall.Shipyard.boatsEnabled then
		if not Redfall.Shipyard.boatAlock then
			local hero = trigger.activator
			if hero:HasModifier("modifier_redfall_inside_shredder") then
				return false
			end
			Redfall.Shipyard.boatAlock = true
			local boat = Redfall.BoatA
			local boatAbility = boat:FindAbilityByName("shipyard_boat_dummy_ability")
			local handler = boat.handler
			EmitSoundOn("Redfall.ShipyardHandler.PickUp", handler)
			boatAbility:ApplyDataDrivenModifier(boat, hero, "modifier_boat_dummy_prepping", {duration = 1.3})

			local throwTargetPoint = Vector(14976, -3328, -640)
			local forwardVector = ((throwTargetPoint-handler:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			for i = 1, 40, 1 do
				Timers:CreateTimer(i*0.03, function()
					local radians = ((math.pi/4)/15)*i
					local newForward = WallPhysics:rotateVector(Vector(0,-1), radians)
					handler:SetForwardVector(newForward)
				end)
			end
			Timers:CreateTimer(1.06, function()
				StartAnimation(handler, {duration=1.4, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
			end)
			Timers:CreateTimer(1.3, function()
				EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "Redfall.BoatJump", Events.GameMaster)
				WallPhysics:Jump(hero, forwardVector, 39, 39, 40, 1)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", hero, 3)
				add_flail_effect(hero, boatAbility, boat)
			end)
			Timers:CreateTimer(2, function()
				handler:SetForwardVector(Vector(0,-1))
				Redfall.Shipyard.boatAlock = false
			end)
			Timers:CreateTimer(3.7, function()
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", hero, 3)
			end)
		end
	end
end

function BoatTriggerB(trigger)
	----print(Redfall.Shipyard.boatsEnabled)
	----print(Redfall.Shipyard.boatAlock)
	if Redfall.Shipyard.boatsEnabled then
		if not Redfall.Shipyard.boatBlock then
			local hero = trigger.activator
			if hero:HasModifier("modifier_redfall_inside_shredder") then
				return false
			end
			Redfall.Shipyard.boatBlock = true
			local boat = Redfall.BoatB
			local boatAbility = boat:FindAbilityByName("shipyard_boat_dummy_ability")
			local handler = boat.handler
			EmitSoundOn("Redfall.ShipyardHandler.PickUp", handler)
			boatAbility:ApplyDataDrivenModifier(boat, hero, "modifier_boat_dummy_prepping", {duration = 1.3})

			local throwTargetPoint = Vector(14226, -6336, -384)
			local forwardVector = ((throwTargetPoint-handler:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			for i = 1, 40, 1 do
				Timers:CreateTimer(i*0.03, function()
					local radians = ((-math.pi/4)/20)*i
					local newForward = WallPhysics:rotateVector(Vector(1,0), radians)
					handler:SetForwardVector(newForward)
				end)
			end
			Timers:CreateTimer(1.06, function()
				StartAnimation(handler, {duration=1.4, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
			end)
			Timers:CreateTimer(1.3, function()
				EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "Redfall.BoatJump", Events.GameMaster)
				WallPhysics:Jump(hero, forwardVector, 39, 39, 40, 1)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", hero, 3)
				add_flail_effect(hero, boatAbility, boat)
			end)
			Timers:CreateTimer(2, function()
				handler:SetForwardVector(Vector(1,0))
				Redfall.Shipyard.boatBlock = false
			end)
			Timers:CreateTimer(3.7, function()
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", hero, 3)
			end)
		end
	end
end

function add_flail_effect(hero, ability, boat)
	hero.jumpEnd = "stop_flail"
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_wind_temple_flailing"
	ability:ApplyDataDrivenModifier(boat, hero, jumpingModifier, {duration = 5})
	hero:Stop()
end

function shipyard_throw_prepping_think(event)
	local target = event.target
	local caster = event.caster
	local handler = caster.handler
	target:SetAbsOrigin(handler:GetAbsOrigin()+handler:GetForwardVector()*95+Vector(0,0,40))
end

function pirate_archer_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	EmitSoundOn("Redfall.PirateArcher.SearingArrowImpact", target)
	local damagePercent = event.magic_damage_on_hit/100
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*damagePercent
	ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function ShipyardBigTrigger1()
	Redfall:ShipyardBigTrigger1()
end

function ShipyardStatueBossTrigger()
	Redfall:SpawnShipyardSpawner(Vector(14400, -854), Vector(1,0))
end

function shipyard_spawner_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
		caster.explosionState = 0
	end

	caster.interval = caster.interval + 1

	
	if caster.interval%4 == 0 then
		if not caster.summonTable then
			caster.summonTable = {}
			caster.totalSummons = 0
		end
		local newTable = {}
		for i = 1, #caster.summonTable, 1 do
			if IsValidEntity(caster.summonTable[i]) then
				table.insert(newTable, caster.summonTable[i])
			end
		end
		caster.summonTable = newTable
		local maxSummons = 7
		local loops = 1
		if GameState:GetDifficultyFactor() == 2 then
			maxSummons = 9
			loops = 2
		elseif GameState:GetDifficultyFactor() == 3 then
			maxSummons = 12
			loops = 3
		end
		if #caster.summonTable > maxSummons then
			return
		end
		caster.totalSummons = caster.totalSummons + 1
		local itemRoll = 1
		if caster.totalSummons > 25 then
			itemRoll = 0
		end
		EmitSoundOn("Redfall.ShipyardSpawnerBoss.Spawn", caster)
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_ATTACK, rate=1.5})
		for i = 1, loops, 1 do
			local position = caster:GetAbsOrigin()
			local zombie = Redfall:SpawnShipyardSpawnerUnit(position, RandomVector(1), itemRoll, false)
			StartAnimation(zombie, {duration=1, activity=ACT_DOTA_ATTACK, rate=1})
			if caster.totalSummons > 25 then
				zombie:SetDeathXP(0)
				zombie:SetMaximumGoldBounty(0)
				zombie:SetMinimumGoldBounty(0)
			end
			zombie:SetAbsOrigin(position+Vector(0,0,100)+RandomVector(RandomInt(1,90)))
			WallPhysics:Jump(zombie, Vector(1,0), 15, 12, 20, 1)
			table.insert(caster.summonTable, zombie)
			Timers:CreateTimer(1, function()
				if not zombie.aggro then
					Dungeons:AggroUnit(zombie)
				end
			end)
		end
		caster.interval = 0
	end

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		caster.explosionState = caster.explosionState + 2 + #enemies
		if caster.explosionState > 30 then
			caster.explosionState = 0
	 		  local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		      local radius = 1300
		      local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
		      ParticleManager:SetParticleControl( particle2, 0, GetGroundPosition(caster:GetAbsOrigin(), caster) )
		      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
		      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
		      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 40, 0) )
		      Timers:CreateTimer(1.5, 
		      function()
		        ParticleManager:DestroyParticle( particle2, false )
		      end)
		      EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.ActivateAsharaPortal", Redfall.RedfallMaster)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then	
				for i = 1, #enemies, 1 do
					enemies[i]:AddNewModifier(victim, Events:GetGameMasterAbility(), "modifier_stunned", {duration = 1.3})
					local distance = WallPhysics:GetDistance2d(enemies[i]:GetAbsOrigin(), caster:GetAbsOrigin())
					enemies[i].pushVelocity = math.max(10, 60-(distance/40))
					enemies[i].pushVector = ((enemies[i]:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, enemies[i], "modifier_redfall_pushback", {duration = 1.3})
				end
			end		
		end
	else
		caster.explosionState = math.max(caster.explosionState - 2, 0)

	end 
	caster:SetRenderColor(255, 255-caster.explosionState*8, 255-caster.explosionState*8)
end

function boss_spawner_die(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/econ/events/battlecup/battle_cup_fall_destroy.vpcf", caster, 4)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Redfall.ShipyardSpawnerBoss.Death", caster)
	end)
	for i = 1, 150, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,1.5))
		end)
	end
	Redfall.StatueSpawnerShipyard = true
	Redfall:RaiseShipyardBridge()
end

function shipyard_soul_collector_think(event)
	local caster = event.caster
	local ability = event.ability

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 950, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", caster, 0.8)
		EmitSoundOn("Redfall.ShipyardSoulCollector.Skulls", caster)
		for _,enemy in pairs(enemies) do
				local info = 
				{
					Target = enemy,
					Source = caster,
					Ability = ability,	
					EffectName =  "particles/roshpit/redfall/shipyard_tracking_skull_enemy.vpcf",
					StartPosition = "attach_hitloc",
					bDrawsOnMinimap = false, 
				        bDodgeable = true,
				        bIsAttack = false, 
				        bVisibleToEnemies = true,
				        bReplaceExisting = false,
				        flExpireTime = GameRules:GetGameTime() + 8,
					bProvidesVision = true,
					iVisionRadius = 0,
					iMoveSpeed = 500,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end 
	
end

function shipyard_shield_initiate(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shipyard_veil_shield", {})
	local max_stacks = event.max_stacks
	caster:SetModifierStackCount("modifier_shipyard_veil_shield", caster, max_stacks)
end

function shipyard_soul_collector_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shipyard_veil_shield", {})
	local max_stacks = event.max_stacks
	local newStacks = math.min(max_stacks, caster:GetModifierStackCount("modifier_shipyard_veil_shield", caster) + 1)
	caster:SetModifierStackCount("modifier_shipyard_veil_shield", caster, newStacks)
end

function soul_collector_die(event)
	local caster = event.caster
	EmitSoundOn("Redfall.ShipyardSoulCollector.Death", caster)
	RPCItems:RollShipyardVeil1(caster:GetAbsOrigin())
end

function ShipyardBridgeTrigger(event)
	if Redfall.StatueSpawnerShipyard then
		if not Redfall.ShipyardBridgeBeforeBoss then
			Redfall.ShipyardBridgeBeforeBoss = true
			Redfall:ShipyardBridgeTrigger()
		end
	end
end

function shipyard_knight_die(event)
	if not Redfall.Shipyard then
		Redfall.Shipyard = {}
	end
	if not Redfall.Shipyard.KnightsKilled then
		Redfall.Shipyard.KnightsKilled = 0
	end
	Redfall.Shipyard.KnightsKilled = Redfall.Shipyard.KnightsKilled + 1
	if Redfall.Shipyard.KnightsKilled == 4 then
		local positionTable = {Vector(15040, 7740), Vector(15424, 7744)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.2, function()
				local knight = Redfall:SpawnCrimsythKnight(positionTable[i], Vector(0,-1), true)
				CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", knight, 3)
			end)
		end
	elseif Redfall.Shipyard.KnightsKilled == 6 then
		local positionTable = {Vector(15040, 7740), Vector(15424, 7744), Vector(15040, 8000), Vector(15424, 8000)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.2, function()
				local knight = Redfall:SpawnCrimsythKnight(positionTable[i], Vector(0,-1), true)
				CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", knight, 3)
			end)
		end
	elseif Redfall.Shipyard.KnightsKilled == 10 then
		local knight = Redfall:SpawnCrimsythKnightChamp(Vector(15232, 7616), Vector(0,-1), true)
		CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", knight, 3)
		local positionTable = {Vector(15040, 7740), Vector(15424, 7744)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.2, function()
				local bear = Redfall:SpawnArmoredBearGuard(positionTable[i], Vector(0,-1))
				CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", bear, 3)
				Dungeons:AggroUnit(bear)
			end)
		end
	elseif Redfall.Shipyard.KnightsKilled == 11 then
		Redfall:LowerBossRoomWall()
	end
end

function ShipyardBossRoomTrigger(trigger)
	if Redfall.Shipyard.BossBattleStart then
		return false
	end
	if Redfall.Shipyard.KnightsKilled == 11 then
		if not Redfall.Shipyard.BossTriggerBegin then
			 Redfall:BossRoomTriggerInitiate()
			 Redfall.Shipyard.BossTriggerBegin = true
			 Redfall.Shipyard.LockedPlayerTable = {}
		end
		local hero = trigger.activator
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_disable_player", {})
		table.insert(Redfall.Shipyard.LockedPlayerTable, hero)
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "BGMend", {})
		hero:Stop()
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), Redfall.Shipyard.boss )
		Timers:CreateTimer(1, function()
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
		end)
	end

end

function shipyard_boss_unit_die(event)
	if not Redfall.Shipyard.BossUnitsSlain then
		Redfall.Shipyard.BossUnitsSlain = 0
	end
	Redfall.Shipyard.BossUnitsSlain = Redfall.Shipyard.BossUnitsSlain + 1
	if Redfall.Shipyard.BossUnitsSlain == 10 then
		Redfall:ShipyardBossStateChange(0)
	elseif Redfall.Shipyard.BossUnitsSlain == 26 then
		Redfall:ShipyardBossStateChange(1)
	elseif Redfall.Shipyard.BossUnitsSlain == 42 then
		Redfall:ShipyardBossStateChange(2)
	elseif Redfall.Shipyard.BossUnitsSlain == 58 then
		Redfall:ShipyardBossStateChange(3)
	elseif Redfall.Shipyard.BossUnitsSlain == 74 then
		Redfall:ShipyardBossStateChange(4)
	elseif Redfall.Shipyard.BossUnitsSlain == 90 then
		Redfall:ShipyardBossStateChange(5)
	end
end

function spikeball_thinking(event)
	local caster = event.caster
	local spikeData = caster.spikeData
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval == 6 then
		local spikeProp = spikeData.spikeProp
		local spikeFV = spikeData.spikeFV
		local spikeDistance = spikeData.spikeDistance
		caster.interval = 0
		local movementLoops = 30
		local moveVector = (spikeFV*spikeDistance)/movementLoops
		for i = 1, movementLoops, 1 do
			Timers:CreateTimer(i*0.03, function()	
				local newPos = spikeProp:GetAbsOrigin() + moveVector
				spikeProp:SetAbsOrigin(newPos)
				if IsValidEntity(caster) then
					caster:SetAbsOrigin(newPos)
				end
			end)
		end
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.ShipyardMainBoss.BossSpikeDrag", Redfall.RedfallMaster)
		Timers:CreateTimer(movementLoops*0.03+0.03, function()
			spikeData.spikeFV = spikeFV*-1
		end)	
	end
end

function shipyard_boss_spike_hit(event)
	local target = event.target
	local ability = event.ability
	local stun_duration = 0.8 + GameState:GetDifficultyFactor()*0.2
	
	local healthPercent = 0.2
	if GameState:GetDifficultyFactor() == 2 then
		healthPercent = 0.4
	elseif GameState:GetDifficultyFactor() == 3 then
		healthPercent = 0.6
	end
	local damage = target:GetMaxHealth()*healthPercent
	ApplyDamage({ victim = target, attacker = Events.GameMaster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform.vpcf", target, 3)
	ScreenShake(target:GetAbsOrigin(), 130, 0.3, 0.3, 9000, 0, true)
	EmitSoundOn("Redfall.ShipyardMainBoss.BossSpikeImpact", target)
	Filters:ApplyStun(Events.GameMaster, stun_duration, target)
end

function shipyard_boss_aura_end(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	--print("BREAK AURA??")
	if IsValidEntity(caster) then
		if target:IsHero() and target:IsAlive() then
			local roomCenter = Vector(14825, 10613)
			local distance = WallPhysics:GetDistance2d(roomCenter, target:GetAbsOrigin())
			if distance > 1900 then
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", target, 3)
				FindClearSpaceForUnit(target, roomCenter, false)
				Timers:CreateTimer(0.1, function()
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", target, 3)
				end)
			else
				EmitSoundOn("Redfall.CultBoss.PullAbilityEffect", target)
				CustomAbilities:QuickAttachParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_g.vpcf", caster, 3)
				local particleName = "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ability:ApplyDataDrivenModifier(caster, target, "modifier_crimsith_cult_pull", {duration = 1.5})
				local jumpDirection = ((caster:GetAbsOrigin()-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				local distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
				local propulsion = math.floor(distance/45)
				WallPhysics:Jump(target, jumpDirection, propulsion, 26, 29, 1)	
			end
		end
	end
end

function boss_in_battle_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.dying then
		return false
	end
	if caster:GetHealth() < 1000 then
		caster.dying = true
	end
	local chemicalRage = caster:FindAbilityByName("shipyard_boss_chemical_rage")
	if chemicalRage:IsFullyCastable() then
		local newOrder = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		AbilityIndex = chemicalRage:entindex(),
	 	}
		 
		ExecuteOrderFromTable(newOrder)	
		return true
	end
	local acidSpray = caster:FindAbilityByName("shipyard_boss_acid_spray")
	if acidSpray:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = acidSpray:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
		end
	end
end

function shipyard_boss_unit_think(event)
	local target = event.target
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin(), Vector(14825, 10613))
	if distance > 960 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", target, 3)
		FindClearSpaceForUnit(target, Vector(14825, 10613), false)
		Timers:CreateTimer(0.1, function()
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", target, 3)
		end)
	end
end

function redfall_shipyard_boss_death_check(event)
	local caster = event.caster
	local ability = event.ability
	if caster.deathStart then
	else
		if caster:GetHealth() < 50 then
			caster.deathStart = true
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dying_generic", {duration = 20})
			CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
			caster.deathStart = true
			StartAnimation(caster, {duration=7, activity=ACT_DOTA_FLAIL, rate=1})
			if caster.paragonDummy == nil or caster.buddiesSlain == caster.packSize then
				Redfall:ShipyardBossDeath(caster, ability)
			else
				caster:ForceKill(false)
			end
		end
	end
end

function ShipyardBossPortalTrigger(trigger)
	if Redfall.Shipyard.BossBattleStart then
		local hero = trigger.activator
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(14825, 10613)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end
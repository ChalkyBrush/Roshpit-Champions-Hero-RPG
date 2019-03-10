function TerrasicGuardTrigger(trigger)
	if not Tanari.TerrasicGuardStart then
		if trigger.activator:GetLevel() >= GameState:GetDifficultyFactor()*25 then
			Tanari.TerrasicGuardStart = true
			Tanari:TerrasicGuardSpawn()
		else
			local lvlReq = GameState:GetDifficultyFactor()*25
			Notifications:Top(trigger.activator:GetPlayerOwnerID(), {text="Level "..lvlReq.." Required", duration=3, style={color="red"}, continue=true})
		end
	end
end

function terrasic_guard_die(event)
	print("GUARD DIE")
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	Tanari:LowerWaterTempleWall(-4, "TerrasicIntroWall", Vector(-8500, -1643, 430), "TerrasicBlocker", Vector(-8512, -1644, 232), 1200, true, false)
	-- EmitSoundOnLocationWithCaster(Vector(-2560, -7040, 1200), "Tanari.Music.TerrasicIntro", Events.GameMaster)
	-- Timers:CreateTimer(1.5, function()
	-- 	EmitSoundOnLocationWithCaster(Vector(-7104, -7360, 1200), "Tanari.Music.TerrasicIntro", Tanari.Unibi)
	-- end)
	Timers:CreateTimer(3, function()
		EmitSoundOnLocationWithCaster(Vector(-7872, -5440, 500), "Tanari.Music.TerrasicIntro", Events.GameMaster)
		Timers:CreateTimer(74, function()
			local heroLocTable = {}
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local heroPos = MAIN_HERO_TABLE[i]:GetAbsOrigin()
				if heroPos.x < -1449 and heroPos.y < -2565 and heroPos.x > -8000 then
					table.insert(heroLocTable, heroPos)
				end
			end
			if #heroLocTable > 0 then
				local totalVector = Vector(0,0,0)
				for j = 1, #heroLocTable, 1 do
					totalVector = totalVector+heroLocTable[j]
				end
				local avgVector = totalVector/#heroLocTable
				if Tanari.fireKeyBossStart and not Tanari.FireTempleKeyAcquired then
				else
					EmitSoundOnLocationWithCaster(avgVector, "Tanari.Music.TerrasicIntro", Events.GameMaster)
				end
			end
			return 78
		end)
	end)

	Tanari:SpawnFlameOrchid(Vector(1,0), Vector(-9472, -2560))
	Timers:CreateTimer(0.5, function()
		Tanari:SpawnFlameOrchid(Vector(1,0), Vector(-9418, -3246))
	end)
	Timers:CreateTimer(1.5, function()
		Tanari:SpawnFlameOrchid(Vector(-1,0), Vector(-7782, -3246))
		Tanari:SpawnFlameOrchid(Vector(1,1), Vector(-9152, -4288))
	end)
end

function lava_beast_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		if caster:HasModifier("modifier_lava_beast_submerged") then
			caster:RemoveModifierByName("modifier_lava_beast_submerged")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_beast_fighting", {})
			print("RISE!")
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1}) 
			for i = 1, 13, 1 do
				Timers:CreateTimer(0.03*i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,18))
				end)
			end
			Timers:CreateTimer(0.18, function()
		      particleName = "particles/addons_gameplay/small_lava_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
		      EmitSoundOn("Tanari.LavaSplash", caster)
		      Timers:CreateTimer(10, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)
			end)
		end
	else
		if not caster:HasModifier("modifier_lava_beast_submerged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_lava_beast_submerged", {})
			caster:RemoveModifierByName("modifier_beast_fighting")
			print("FALL!")
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1}) 
			for i = 1, 13, 1 do
				Timers:CreateTimer(0.03*i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,18))
				end)
				Timers:CreateTimer(0.18, function()
			      particleName = "particles/addons_gameplay/small_lava_splash_blast.vpcf"
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
			      EmitSoundOn("Tanari.LavaSplash", caster)
			      Timers:CreateTimer(10, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)
				end)
			end
		end
	end
end

function flame_orchid_think(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_RUN, rate=1.5}) 
	EmitSoundOn("Tanari.OrchidFireLaunch", caster)
	for i = -1, 1, 1 do
		local rotatedFv = WallPhysics:rotateVector(fv, i*math.pi/8)
		flame_orchid_projectile(caster, ability, caster:GetAbsOrigin(), rotatedFv)
	end
end


function flame_orchid_projectile(caster, ability, position, fv)
    local start_radius = 130
    local end_radius = 130
    local speed = 500
       
    local info = 
    {
        Ability = ability,
          EffectName = "particles/units/heroes/hero_jakiro/fireball.vpcf",
          vSpawnOrigin = position+Vector(0,0,205),
          fDistance = 1000,
          fStartRadius = start_radius,
          fEndRadius = end_radius,
          Source = caster,
          StartPosition = "attach_attack1",
          bHasFrontalCone = true,
          bReplaceExisting = false,
          iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
          iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
          iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          fExpireTime = GameRules:GetGameTime() + 5.0,
      bDeleteOnHit = false,
      vVelocity = fv*speed,
      bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info) 

end

function boulderspine_shell_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 and not caster.rising then
		caster.rising = true
		if caster:GetUnitName() == "terrasic_boulderspine" then
			Tanari:SpawnBoulderSpine(caster)
		elseif caster:GetUnitName() == "water_temple_beach_hermit" then
			Tanari:SpawnBeachHermit(caster)
		end
	end
end


function flamespit_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		EmitSoundOn("Tanari.TerrasicCrater.FlameSpitThink", caster)
		for i = 1, #enemies, 1 do
			local info = 
			{
				Target = enemies[i],
				Source = caster,
				Ability = ability,	
				EffectName =  "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 5,
				bProvidesVision = false,
				iVisionRadius = 0,
				iMoveSpeed = 750,
				iVisionTeamNumber = caster:GetTeamNumber()
			}

			projectile = ProjectileManager:CreateTrackingProjectile(info)	
		end
	end	
end

function TerrasicBeetleSpawn()
	local baseVector = Vector(-6640, -9280)
	for i = 1, 18, 1 do
		Timers:CreateTimer(i*0.4, function()
			local randomX = RandomInt(1,900)
			local randomY = RandomInt(1,500)
			Tanari:SpawnVolcanoBeetle(baseVector+Vector(randomX, randomY), RandomVector(1))
		end)
	end
	local basePos = Vector(-4544, -8960, 600)
	for j = 1, 12, 1 do
		Timers:CreateTimer(j*0.2, function()
			local randomX = RandomInt(1, 1000)
			local randomY = RandomInt(1, 660)
			Tanari:SpawnBlackDrake(basePos+Vector(randomX, randomY), RandomVector(1))
		end)
	end
end

function black_drake_think(event)
	local caster = event.caster
	if not caster.aggro then
		local basePos = Vector(-4544, -8960, 600)
		local randomX = RandomInt(1, 1000)
		local randomY = RandomInt(1, 660)
		caster:MoveToPosition(basePos+Vector(randomX, randomY))
	end
end

function black_drake_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Tanari.TerrasicCrater.DrakesSlain then
		Tanari.TerrasicCrater.DrakesSlain = 0
	end
	Tanari.TerrasicCrater.DrakesSlain = Tanari.TerrasicCrater.DrakesSlain + 1
	if Tanari.TerrasicCrater.DrakesSlain == 8 then
		Tanari.BlackDragon.cantAggro = false
		for i = 1, 80, 1 do
			Timers:CreateTimer(i*0.03, function()
				Tanari.BlackDragon:SetModifierStackCount("modifier_black_dragon_extra_z", Tanari.BlackDragon, 240-(i*3))
			end)
		end
		Timers:CreateTimer(2.4, function()
			EmitSoundOn("Tanari.BlackDragon.Aggro", Tanari.BlackDragon)
			Tanari.BlackDragon:RemoveModifierByName("modifier_black_dragon_unaggrod")
			Tanari.BlackDragon:RemoveModifierByName("modifier_black_dragon_extra_z")
		end)
	end
end

function black_dragon_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if caster.phase == 0 then
		caster:MoveToPosition(caster.firstMovePos)
		if WallPhysics:GetDistance(caster.firstMovePos*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0)) < 200 then
			caster.phase = 1
			Timers:CreateTimer(12, function()
				caster.phase = 2
			end)
		end
	elseif caster.phase == 1 then
		local radius = 880
		local basePos = caster.firstMovePos
		local directionVector = WallPhysics:rotateVector(Vector(1,0), caster.interval*2*math.pi/10)
		caster:MoveToPosition(basePos + directionVector*radius)
		caster.interval = caster.interval + 1
		-- print("what!")
		-- print(basePos + directionVector*radius)
	elseif caster.phase == 2 then
		caster:MoveToPosition(Vector(-3904, -8832))
		local distance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), Vector(-3904, -8832))
		if distance < 300 then
			caster.phase = 3
		end
	elseif caster.phase == 3 then
		local radius = 280
		local basePos = Vector(-3904, -8832)
		local directionVector = WallPhysics:rotateVector(Vector(1,0), caster.interval*2*math.pi/10)
		caster:MoveToPosition(basePos + directionVector*radius)
		caster.interval = caster.interval + 1
	end
	if caster.interval == 10 then
		caster.interval = 1
	end
end

function black_dragon_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	print("BLACK DRAGON DIE")
	Timers:CreateTimer(0.5, function()
		EmitSoundOnLocationWithCaster(Vector(-3976, -8613, 700), "Tanari.StatueRise", Events.GameMaster)
	end)
	local heightRequired = 628
	local heightDiff = (628-250)/200
	local beacon = Entities:FindByNameNearest("TerrasicDragonBeacon", Vector(-3976, -8613, 250), 500)
	SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-3976, -8613, 628)})
	for i = 1, 200, 1 do
		Timers:CreateTimer(0.03*i, function()
			beacon:SetAbsOrigin(beacon:GetAbsOrigin()+Vector(0,0,heightDiff))
			if i%40 == 0 then
			    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
			    local dirtParticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			    ParticleManager:SetParticleControl(dirtParticle,0,beacon:GetAbsOrigin()+Vector(0,0,50))
			    Timers:CreateTimer(1.5, function()
			      ParticleManager:DestroyParticle( dirtParticle, false )
			    end)
			end
		end)
	end
	Timers:CreateTimer(6, function()
		Tanari.Beacon1Ready = true
	end)
end

function TerrasicBeacon1Trigger(trigger)
	local units = {trigger.activator}
	if not Tanari.Beacon1Activated and Tanari.Beacon1Ready then
		 Tanari.Beacon1Activated = true
		 Tanari:TriggerTerrasicBeacon(180, 70, Vector(-3976, -8613, 628), Vector(-3976, -8613, 1100), units)
	end
end

function volcano_pharoah_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro and not caster.aggroAnimation then
		StartAnimation(caster, {duration=2.2, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.47}) 
		caster.aggroAnimation = true
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies > 0 then
		if caster:HasModifier("modifier_volcano_pharoah_submerged") then
			AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 400, 5, false)
			caster:RemoveModifierByName("modifier_volcano_pharoah_submerged")
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_CHANNEL_ABILITY_4, rate=1}) 
			for i = 1, 15, 1 do
				Timers:CreateTimer(0.03*i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,54))
				end)
			end
			Timers:CreateTimer(0.18, function()
		      Tanari:CreateLavaBlast(caster:GetAbsOrigin()*Vector(1,1,0))
		      EmitSoundOn("Tanari.LavaSplash", caster)
			end)
		else
			ability:StartCooldown(1.0)
			local bombAbility = caster:FindAbilityByName("terrasic_pharaoh_living_bomb")
			if bombAbility:IsFullyCastable() then
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = bombAbility:entindex(),
			 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return true
			end
			EmitSoundOn("Tanari.TerrasicCrater.FlameSpitThink", caster)
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local info = 
				{
					Target = MAIN_HERO_TABLE[i],
					Source = caster,
					Ability = ability,	
					EffectName =  "particles/units/heroes/hero_lina/big_tracking_fireball.vpcf",
					StartPosition = "attach_hitloc",
					bDrawsOnMinimap = false, 
				        bDodgeable = true,
				        bIsAttack = false, 
				        bVisibleToEnemies = true,
				        bReplaceExisting = false,
				        flExpireTime = GameRules:GetGameTime() + 14,
					iVisionRadius = 0,
					iMoveSpeed = 500,
					iVisionTeamNumber = caster:GetTeamNumber()
				}

				projectile = ProjectileManager:CreateTrackingProjectile(info)	
			end
		end
	else
		if not caster:HasModifier("modifier_volcano_pharoah_submerged") then
			AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 400, 5, false)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_volcano_pharoah_submerged", {})
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_CHANNEL_ABILITY_4, rate=1}) 
			for i = 1, 15, 1 do
				Timers:CreateTimer(0.03*i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,54))
				end)
				Timers:CreateTimer(0.18, function()
			      Tanari:CreateLavaBlast(caster:GetAbsOrigin()*Vector(1,1,0))
			      EmitSoundOn("Tanari.LavaSplash", caster)
				end)
			end
		end
	end
end

function VolcanoPharoahTrigger()
	Tanari:SpawnVolcanoPharoah(Vector(-5839, -7405), Vector(-1,0))
end

function living_bomb_init(event)
	local target = event.target
	target.livingBombCount = 5
	PopupRedCounter(target, 5)
	EmitSoundOn("Tanari.VolcanoPharoah.LivingBombStart", target)
end

function living_bomb_think(event)
	local target = event.target
	target.livingBombCount = target.livingBombCount - 1
	PopupRedCounter(target, target.livingBombCount)
end

function living_bomb_end(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local radius = 360
      local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
      ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )
      Timers:CreateTimer(1.5, 
      function()
        ParticleManager:DestroyParticle( particle2, false )
      end)
      EmitSoundOn("Tanari.VolcanoPharoah.LivingBombExplode", target)
      local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin() )
      target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.9})
      Timers:CreateTimer(2, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
      	ApplyDamage({ victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if not enemy:GetEntityIndex() == target:GetEntityIndex() then
					ApplyDamage({ victim = enemy, attacker = caster, damage = event.ally_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })		
				end
			end
		end 
end

function pharoah_die(event)
	if not Tanari.Beacon2Activated then
	 local caster = event.caster
	 local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	 Tanari.Beacon2Activated = true
	 	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-6488, -7016, 700), 400, 3000, false)
		Timers:CreateTimer(0.5, function()
			EmitSoundOnLocationWithCaster(Vector(-6488, -7016, 700), "Tanari.StatueRise", Events.GameMaster)
		end)
		local heightRequired = 494
		local heightDiff = (429-145)/200
		local beacon = Entities:FindByNameNearest("TerrasicDragonBeacon", Vector(-6488, -7016, 195), 500)
		for i = 1, 200, 1 do
			Timers:CreateTimer(0.03*i, function()
				beacon:SetAbsOrigin(beacon:GetAbsOrigin()+Vector(0,0,heightDiff))
				if i%40 == 0 then
				    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
				    local dirtParticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				    ParticleManager:SetParticleControl(dirtParticle,0,beacon:GetAbsOrigin()+Vector(0,0,50))
				    Timers:CreateTimer(1.5, function()
				      ParticleManager:DestroyParticle( dirtParticle, false )
				    end)
				end
			end)
		end
	SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-6488, -7016, 195)})
	Timers:CreateTimer(7.5, function()

	 Tanari:TriggerTerrasicBeacon(270, 60, Vector(-6488, -7016, 195), Vector(-6488, -7016, 908), allies)
	end)
	end
end

function LavaCastleSpawn(event)
	local basePos = Vector(-8132, -11193)
	for i = 1, 4, 1 do
		for j = 1, 3, 1 do
			Tanari:SpawnRedGuard(basePos+Vector((i-1)*180,(j-1)*225), Vector(0,1))
		end
	end
	Timers:CreateTimer(2, function()
		Tanari:SpawnRedMistSoldier(Vector(-6976, -10944), Vector(-1,0))
		Tanari:SpawnRedMistSoldier(Vector(-7829, -11648), Vector(0,1))
	end)
	Timers:CreateTimer(3, function()
		local basePos = Vector(-5055, -11200)
		local guardTable = {}
		for i = 1, 3, 1 do
			for j = 1, 3, 1 do
				if j == 2 and i == 2 then
					Tanari.Reimus = Tanari:SpawnCaptainReimus(basePos+Vector((i-1)*200,(j-1)*225), Vector(-1,0))
				else
					local unit = nil
					if i == 1 then
						unit = Tanari:SpawnRedMistSoldier(basePos+Vector((i-1)*200,(j-1)*225), Vector(-1,0))
					else
						unit = Tanari:SpawnRedGuard(basePos+Vector((i-1)*200,(j-1)*225), Vector(-1,0))
					end
					table.insert(guardTable, unit)
				end
			end
		end
		Tanari.Reimus.guardTable = guardTable
	end)
end

function EnterLavaCastleTrigger(event)
	if IsValidEntity(Tanari.Reimus) then
		Tanari.Reimus:MoveToPositionAggressive(Vector(-7104,-12928)+RandomVector(90))
		for i = 1, #Tanari.Reimus.guardTable, 1 do
			if IsValidEntity(Tanari.Reimus.guardTable[i]) then
				Tanari.Reimus.guardTable[i]:MoveToPositionAggressive(Vector(-7104,-12928)+RandomVector(90))
			end
		end
	end
	Tanari:SpawnMoltenEntity(Vector(-7040, -13184), Vector(0,1))
	Tanari:SpawnMoltenEntity(Vector(-7040, -13440), Vector(0,1))
	Tanari:SpawnMoltenEntity(Vector(-7040, -13706), Vector(0,1))
	Tanari:SpawnMoltenEntity(Vector(-7040, -13952), Vector(0,1))

	Timers:CreateTimer(3, function()
		local spawnPoint1 = Vector(-8192+RandomInt(0,780), -14336)
		local spawnPoint2 = Vector(-8265, -14177+RandomInt(0,380))
		local spawnPoint3 = Vector(-8265, -13584)
		local spawnPoint4 = Vector(-7424, -14177+RandomInt(0,380))
		Tanari:SpawnVolcanicAsh(spawnPoint1, Vector(1,0))
		Tanari:SpawnVolcanicAsh(spawnPoint2, Vector(1,0))
		Tanari:SpawnVolcanicAsh(spawnPoint3, Vector(1,0))
		Tanari:SpawnVolcanicAsh(spawnPoint4, Vector(1,0))
		Tanari:SpawnLavaBeast(Vector(0,1), Vector(-7925, -13770))
	end)
	Timers:CreateTimer(4, function()
		local spawnPoint1 = Vector(-8192+RandomInt(0,780), -14336)
		local spawnPoint2 = Vector(-8265, -14177+RandomInt(0,380))
		local spawnPoint3 = Vector(-8265, -13584)
		local spawnPoint4 = Vector(-7424, -14177+RandomInt(0,380))
		Tanari:SpawnVolcanicAsh(spawnPoint1, Vector(1,0))
		Tanari:SpawnVolcanicAsh(spawnPoint2, Vector(1,0))
		Tanari:SpawnVolcanicAsh(spawnPoint3, Vector(1,0))
		Tanari:SpawnVolcanicAsh(spawnPoint4, Vector(1,0))
	end)
	Timers:CreateTimer(7, function()
		Tanari:SpawnRedWarlock(Vector(-9472, -13888), Vector(1,1))
	end)
end

function red_warlock_think(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("red_warlock_finger_of_death")
	if castAbility:IsFullyCastable() and caster.aggro then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = enemies[1]:entindex(),
			 		AbilityIndex = castAbility:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)	
		end
	end
end

function red_warlock_take_damage(event)
	local caster = event.caster
	local damage = event.attack_damage
	local damageProportion = damage/caster:GetMaxHealth()
	local manaRestore = damageProportion*500
	caster:GiveMana(manaRestore)
	CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", caster, 1)
end

function BackLavaTrigger(event)
	Tanari:SpawnRedWarlock(Vector(-9600, -15360), Vector(-0.4,1))
	Tanari:SpawnMoltenEntity(Vector(-9472, -15386), Vector(0,1))
	Tanari:SpawnMoltenEntity(Vector(-9678, -15503), Vector(0,1))
end

function conqueror_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local distance = WallPhysics:GetDistance(attacker:GetAbsOrigin(), caster:GetAbsOrigin())
	if distance > 600 then
		if ability:IsFullyCastable() then
			local castPoint = attacker:GetAbsOrigin()
			if distance > 1500 then
				local directionVector = ((attacker:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				castPoint = caster:GetAbsOrigin()+directionVector*1500
			else
				local directionVector = ((attacker:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				castPoint = attacker:GetAbsOrigin()+directionVector*160
			end
			
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)			

		end
	end
end

function conqueror_cast_leap(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	conqueror_leap_start(caster, ability, point)
end

function conqueror_leap_start(caster, ability, target_location)
        caster.jumpEnd = true
        local casterOrigin = caster:GetAbsOrigin()
        local targetOrigin = target_location
        local fv = (targetOrigin*Vector(1,1,0)-casterOrigin*Vector(1,1,0)):Normalized()
        local distance = WallPhysics:GetDistance(casterOrigin*Vector(1,1,0), targetOrigin*Vector(1,1,0))
        caster:SetForwardVector(fv)
        conqueror_leap_jump(caster, fv, distance, 25, 25, 1, 1)
        local animationTime = math.min(350/distance, 1)
        EmitSoundOn("Tanari.Conqueror.Leap", caster)
        StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=animationTime})
end

function conqueror_leap_jump(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
    local gameMaster = Events.GameMaster
    local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
    local jumpingModifier = "modifier_jumping"
    gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 5})
    local liftDuration = distance/propulsion/2
    local endLocation = unit:GetAbsOrigin()+forwardVector*distance
    for i = 1, liftDuration, 1 do
        Timers:CreateTimer(0.03*i, function()
            local currentPosition = unit:GetAbsOrigin()

            local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)

            local obstruction = WallPhysics:FindNearestObstruction(newPosition*Vector(1,1,0))
            local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition*Vector(1,1,0), unit)
            if not blockUnit then
                unit:SetOrigin(newPosition)
            else 
                unit:SetOrigin(newPosition-forwardVector*propulsion)
            end
            
        end)
    end
    local fallLoop = 0
    Timers:CreateTimer(0.03*liftDuration+0.03, function()
        Timers:CreateTimer(0.03*fallLoop, function()
            fallLoop = fallLoop + 1
            local currentPosition = unit:GetAbsOrigin()
            local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity*fallGravity)

            local obstruction = WallPhysics:FindNearestObstruction(newPosition*Vector(1,1,0))
            local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition*Vector(1,1,0), unit)
            if unit:HasModifier("modifier_jumping") then
                if not blockUnit then
                    unit:SetOrigin(newPosition)
                else 
                    unit:SetOrigin(newPosition-forwardVector*propulsion)
                end
            end
            if fallLoop > liftDuration then
                unit:RemoveModifierByName("modifier_jumping")
                FindClearSpaceForUnit(unit, newPosition, false)
                WallPhysics:UnitLand(unit)
            else
                if newPosition.z <= GetGroundHeight(newPosition, unit) + 20 then
                    unit:RemoveModifierByName("modifier_jumping")
                    FindClearSpaceForUnit(unit, newPosition, false)
                    WallPhysics:UnitLand(unit)
                else
                    return 0.03
                end
            end
        end)
    end)
end

function BackLavaStripTrigger()
	for i = 1, 6, 1 do
		Timers:CreateTimer(i*0.5, function()
			local grunt1 = Tanari:SpawnRedMistConqueror(Vector(-5751, -15488), Vector(-1,0))
			local grunt2 = Tanari:SpawnRedMistSoldier(Vector(-5951, -15488), Vector(-1,0))
			Timers:CreateTimer(0.1, function()
				grunt1:MoveToPositionAggressive(Vector(-9600, -15488))
				grunt2:MoveToPositionAggressive(Vector(-9600, -15488))
			end)
		end)
	end
	Timers:CreateTimer(4, function()
		local baseVector = Vector(-5696, -15808)
		for i = 0, 2, 1 do
		 for j = 0, 2, 1 do
		 	if j == 0 then
		 		Tanari:SpawnRedMistBrute(baseVector+Vector(j*320, i*320), Vector(-1,0))
		 	else
		 		Tanari:SpawnRedGuard(baseVector+Vector(j*320, i*320), Vector(-1,0))
		 	end
		 end
		end
	end)
	Timers:CreateTimer(7, function()
		Tanari:SpawnCaptainClayborne(Vector(-3160, -15424), Vector(-1,0))
		Timers:CreateTimer(2, function()
			Tanari:SpawnRedWarlock(Vector(-2814, -15424), Vector(1,1))
			Tanari:SpawnRedMistBrute(Vector(-3456, -15104), Vector(-0.4, -1))
			Tanari:SpawnRedMistBrute(Vector(-2880, -15104), Vector(-0.4, -1))
		end)
	end)
end

function mega_helix_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if ability:GetCooldownTimeRemaining() == 0 then
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		local helixDamage = event.helix_damage
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", caster, 0.8)
		EmitSoundOn("Hero_Axe.CounterHelix", caster)
		local enemies1 = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local helixIndexTable = {}
		if #enemies1 > 0 then
			for i = 1, #enemies1, 1 do
				table.insert(helixIndexTable, enemies1[i]:GetEntityIndex())
				ApplyDamage({ victim = enemies1[i], attacker = caster, damage = helixDamage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
			end
		end
		local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies2 > 0 then
			for i = 1, #enemies2, 1 do
				local shootFireball = true
				for j = 1, #helixIndexTable, 1 do
					if enemies2[i]:GetEntityIndex() == helixIndexTable[j] then
						shootFireball = false
					end
				end
				if shootFireball then
					local info = 
					{
						Target = enemies2[i],
						Source = caster,
						Ability = ability,	
						EffectName =  "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
						StartPosition = "attach_hitloc",
						bDrawsOnMinimap = false, 
					        bDodgeable = true,
					        bIsAttack = false, 
					        bVisibleToEnemies = true,
					        bReplaceExisting = false,
					        flExpireTime = GameRules:GetGameTime() + 5,
						iVisionRadius = 0,
						iMoveSpeed = 600,
						iVisionTeamNumber = caster:GetTeamNumber()
					}

					projectile = ProjectileManager:CreateTrackingProjectile(info)	
				end
			end
		end
	end
end

function TerrasicFortSwitchTrigger(trigger)
	local activator = trigger.activator
	Tanari:ActivateSwitchGeneric(Vector(-1728, -14828, 0), "TerrasicFortSwitch", true)
	Timers:CreateTimer(0.3, function()
		Tanari:LowerWaterTempleWall(-6, "TerrasicFortressWall", Vector(-3136, -13952, 350), "TerrasicFortBlocker", Vector(-3100, -13963, 37), 1200, true, false)
	end)
	Timers:CreateTimer(4, function()
		for i = 1, 6, 1 do
			Timers:CreateTimer(i*3, function()
				local unit1 = Tanari:SpawnRedMistBrute(Vector(-3200, -13760), Vector(0,-1))
				local unit2 = Tanari:SpawnRedMistConqueror(Vector(-3008, -13760), Vector(0,-1))
				local unit3 = Tanari:SpawnRedGuard(Vector(-3200, -13568), Vector(0,-1))
				local unit4 = Tanari:SpawnRedMistSoldier(Vector(-3008, -13568), Vector(0,-1))
				Timers:CreateTimer(0.05, function()
					unit1:MoveToPosition(Vector(-3200, -15488))
					unit2:MoveToPosition(Vector(-3200, -15488))
					unit3:MoveToPosition(Vector(-3200, -15488))
					unit4:MoveToPosition(Vector(-3200, -15488))
				end)
				Timers:CreateTimer(5, function()
					heroOrigin = activator:GetAbsOrigin()
					unit1:MoveToPositionAggressive(heroOrigin)
					unit2:MoveToPositionAggressive(heroOrigin)
					unit3:MoveToPositionAggressive(heroOrigin)
					unit4:MoveToPositionAggressive(heroOrigin)
				end)
			end)
		end
	end)
	Timers:CreateTimer(10, function()
		Tanari:SpawnRedWarlock(Vector(-3264, -12672), Vector(0,-1))
		Tanari:SpawnRedWarlock(Vector(-3008, -12672), Vector(0,-1))
	end)
end

function TerrasicFortressWarlockTrigger()
	local warlock = Tanari:SpawnTerrasicWarlock(Vector(-4513, -12974), Vector(0,1))
	Timers:CreateTimer(0.6, function()
		EmitGlobalSound("Tanari.WarlockLaughIntro")
	end)
	warlock.movingDown = true
	local warlockAbility = warlock:FindAbilityByName("terrasic_warlock_ai")
	warlockAbility:ApplyDataDrivenModifier(warlock, warlock, "modifier_terrasic_warlock_entering", {})
	warlockAbility:ApplyDataDrivenModifier(warlock, warlock, "modifier_terrasic_warlock_cant_die_yet", {})
end

function terrasic_warlock_entering_think(event)
	local caster = event.caster
	local currentFV = caster:GetForwardVector()
	caster:SetForwardVector(WallPhysics:rotateVector(currentFV, math.pi/14))
	if caster.movingDown then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-10))
		if caster:GetAbsOrigin().z < 160 then
			caster:RemoveModifierByName("modifier_terrasic_warlock_entering")
			EmitSoundOn("warlock_warl_laugh_0"..RandomInt(1,6), caster)
		end
	else
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,10))
		if caster:GetAbsOrigin().z > 1300 then
			local basePos = Vector(-5248, -13760)
			local randomX = RandomInt(1, 1500)
			local randomY = RandomInt(1, 1160)
			caster.movingDown = true
			caster:SetAbsOrigin(basePos + Vector(randomX, randomY, caster:GetAbsOrigin().z))
		end
	end
end

function terrasic_warlock_general_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if not caster.summonedBeast and caster:GetHealth() < caster:GetMaxHealth()*0.65 then
		caster.summonedBeast = true
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8}) 
		EmitSoundOn("Tanari.WarlockSummon.Enter", caster)
		local beastPosTable = {Vector(-4928, -13376), Vector(-4149, -13376), Vector(-4149, -12578), Vector(-4933, -12578)}
		local summon = Tanari:SpawnTerrasicWarlockSummon(beastPosTable[RandomInt(1,4)], RandomVector(1))
		particleName = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( particle1, 0, summon:GetAbsOrigin()+Vector(0,0,200) )
		Timers:CreateTimer(5, 
		function()
		ParticleManager:DestroyParticle( particle1, false )
		end)
		Timers:CreateTimer(1, function()
			EmitSoundOn("Tanari.WarlockSummon.Aggro", summon)
			caster:RemoveModifierByName("modifier_terrasic_warlock_cant_die_yet")
		end)
		return
	end
	if not caster:HasModifier("modifier_terrasic_warlock_entering") then
		local fv = caster:GetForwardVector()
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.3}) 
		EmitSoundOn("Tanari.OrchidFireLaunch", caster)
		for i = -1, 1, 1 do
			local rotatedFv = WallPhysics:rotateVector(fv, i*math.pi/8)
			flame_orchid_projectile(caster, ability, caster:GetAbsOrigin(), rotatedFv)
		end
	end
	caster.interval = caster.interval + 1
	if caster.interval % 14 == 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_terrasic_warlock_entering", {})
		caster.movingDown = false
	end
	if caster.interval > 100 then
		caster.interval = 1
	end
end

function warlock_summon_think(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlock_summon_submerged", {})
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1}) 
	for i = 1, 13, 1 do
		Timers:CreateTimer(0.03*i, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,25))
		end)
		Timers:CreateTimer(0.18, function()
	      particleName = "particles/addons_gameplay/small_lava_splash_blast.vpcf"
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin()+Vector(0,0,230) )
	      EmitSoundOn("Tanari.LavaSplash", caster)
	      Timers:CreateTimer(10, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
		end)
	end
	Timers:CreateTimer(2, function()
		caster:RemoveModifierByName("modifier_warlock_summon_submerged")
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1}) 
		for i = 1, 13, 1 do
			Timers:CreateTimer(0.03*i, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,18))
			end)
		end
		local beastPosTable = {Vector(-4928, -13376), Vector(-4149, -13376), Vector(-4149, -12578), Vector(-4933, -12578)}
		caster:SetAbsOrigin(beastPosTable[RandomInt(1,4)]+Vector(0,0,-200))
		EmitSoundOn("Tanari.WarlockSummon.Aggro", caster)
		Timers:CreateTimer(0.18, function()
	      particleName = "particles/addons_gameplay/small_lava_splash_blast.vpcf"
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin()+Vector(0,0,230) )
	      EmitSoundOn("Tanari.LavaSplash", caster)
	      Timers:CreateTimer(10, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
		end)
	end)
end

function terrasic_warlock_die(event)
	local caster = event.caster
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	EmitSoundOn("warlock_warl_death_01", caster)
	if not Tanari.Beacon3Activated then
	 Tanari.Beacon3Activated = true
	 	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-2527, -12057, 700), 400, 3000, false)
		Timers:CreateTimer(0.5, function()
			EmitSoundOnLocationWithCaster(Vector(-2532, -11997, 700), "Tanari.StatueRise", Events.GameMaster)
		end)
		local heightRequired = 660
		local heightDiff = (660-398)/200
		local beacon = Entities:FindByNameNearest("TerrasicDragonBeacon", Vector(-2532, -11997, 400), 600)
		for i = 1, 200, 1 do
			Timers:CreateTimer(0.03*i, function()
				beacon:SetAbsOrigin(beacon:GetAbsOrigin()+Vector(0,0,heightDiff))
				if i%40 == 0 then
				    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
				    local dirtParticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				    ParticleManager:SetParticleControl(dirtParticle,0,beacon:GetAbsOrigin()+Vector(0,0,50))
				    Timers:CreateTimer(1.5, function()
				      ParticleManager:DestroyParticle( dirtParticle, false )
				    end)
				end
			end)
		end
	Timers:CreateTimer(10, function()
		Tanari.TerrasicWarlockDead = true
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-5545, -3069, 500), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-2944, -12190, 300), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
	end)
	SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-6488, -7016, 195)})
	Timers:CreateTimer(7.5, function()
	 Tanari:TriggerTerrasicBeacon(270, 90, Vector(-2527, -12057, 700), Vector(-2527, -12057, 1130), allies)
	end)
	end
end

function TerrasicPortal1(trigger)
	local hero = trigger.activator
	if Tanari.TerrasicWarlockDead and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-5545, -3069)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function TerrasicPortal2(trigger)
	local hero = trigger.activator
	if Tanari.TerrasicWarlockDead and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-2944, -12190)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function FireKeyRoom(trigger)
	local hero = trigger.activator
	if not Tanari.FirewallOpen then
		FindClearSpaceForUnit(hero, Vector(-2496, -4352), false)
	end
end

function FireKeyHolderInitTrigger(event)
	if not Tanari.FirewallOpen then
		return
	end
	if Tanari.FireKeyBossStart then
		return
	end
	Tanari.FireKeyBossStart = true
	print("FIRED?")
	Dungeons.respawnPoint = Vector(-1920, -4736)

	Tanari.fireKeyBlock1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-2233,-4224, 160), name ="wallObstruction"})
	Tanari.fireKeyBlock2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-2233,-4352, 160), name ="wallObstruction"})
	Tanari.fireKeyBlock3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-2233,-4480, 160), name ="wallObstruction"})
	raiseKeyWall()

	local particlePosition = Vector(-1693, -4309, 528)
	local pfx = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_fire_captured.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
	ParticleManager:SetParticleControl( pfx, 10, particlePosition )
	ParticleManager:SetParticleControl( pfx, 0, particlePosition )
	ParticleManager:SetParticleControl( pfx, 1, particlePosition )
	ParticleManager:SetParticleControl( pfx, 2, particlePosition )
	ParticleManager:SetParticleControl( pfx, 3, particlePosition )
	EmitGlobalSound("Tanari.WindTempleKeyHolderStart")
	Tanari.fireKeyBossStart = true
	Timers:CreateTimer(3, function()
		if not Tanari.FireTempleKeyAcquired then
			EmitSoundOnLocationWithCaster(Vector(-1693, -4309, 140), "Tanari.FireKeyHolder.Music", Events.GameMaster)
		end
		if not Tanari.FireTempleKeyAcquired then
			return 45.5
		end
	end)
	for i = 1, 5, 1 do
		Timers:CreateTimer(i*2, function()
			ScreenShake(Vector(-1000, -4265, 400), 500, 0.5, 0.5, 9000, 0, true)
			EmitGlobalSound("Tanari.FireKeyHolder.IntroBarrage")
		end)
	end

	Timers:CreateTimer(10.6, function()
		local boss = CreateUnitByName("terrasic_fire_key_holder", Vector(-990, -4265, 50), false, nil, nil, DOTA_TEAM_NEUTRALS)
		boss.origin = Vector(-990, -4265, 50)
		boss:SetRenderColor(255, 0, 0)
		-- EmitGlobalSound("Tanari.FireKeyHolder.Roar")
		Events:AdjustBossPower(boss, 10, 10, false)
		local bossAbility = boss:FindAbilityByName("terrasic_fire_key_holder_ai")
		bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_fire_key_holder_submerged", {})
		for j = 1, #MAIN_HERO_TABLE, 1 do
			bossAbility:ApplyDataDrivenModifier(boss, MAIN_HERO_TABLE[j], "modifier_fire_key_holder_range", {})
		end
		boss:SetAbsOrigin(boss:GetAbsOrigin()-Vector(0,0,860))
		boss:SetForwardVector(Vector(-1,0))
		EmitGlobalSound("Tanari.VolcanoPharoah.LivingBombExplode")
		Timers:CreateTimer(0.3, function()
			EmitSoundOn("Tanari.LavaSplash", boss)
			StartAnimation(boss, {duration=3.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.26}) 
		end)
		Timers:CreateTimer(0.6, function()
			EmitSoundOn("Tanari.FireKeyHolder.RoarHigh", boss)
			Tanari:CreateLavaBlast(Vector(-920, -4265, 50))
		end)
		for i = 1, 60, 1 do
			Timers:CreateTimer(i*0.03, function()
				ScreenShake(boss:GetAbsOrigin(), 500, 0.1, 0.1, 9000, 0, true)
				boss:SetAbsOrigin(boss:GetAbsOrigin()+Vector(0,0,8.5))
			end)
		end
		Timers:CreateTimer(4.0, function()
			EmitSoundOn("Tanari.FireKeyHolder.RoarLow", boss)
			StartAnimation(boss, {duration=2.7, activity=ACT_DOTA_TELEPORT, rate=0.94}) 
			for j = 1, 41, 1 do
				Timers:CreateTimer(j*0.1, function()
					ScreenShake(boss:GetAbsOrigin(), 500, 0.5, 0.5, 9000, 0, true)
				end)
			end
			local rockFallTable = {Vector(-1088, -4544), Vector(-932, -3897), Vector(-833, -4480)}
			for k = 1, #rockFallTable, 1 do
				Timers:CreateTimer(0.6*k, function()
					ScreenShake(boss:GetAbsOrigin(), 700, 0.6, 0.6, 9000, 0, true)
					local rockfallParticle = "particles/dire_fx/dire_lava_falling_rocks.vpcf"
					local position = rockFallTable[k]
					local pfx = ParticleManager:CreateParticle(rockfallParticle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl( pfx, 0, position )
					Timers:CreateTimer(9, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end)
			end
		end)
		Timers:CreateTimer(6.7, function()
			boss:RemoveModifierByName("modifier_fire_key_holder_submerged")
		end)
	end)
end

function raiseKeyWall()

	local walls = Entities:FindAllByNameWithin("TerrasicKeyWall", Vector(-2174,-4352,-160), 500)
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
		end)
		for i = 1, 90, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,6))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end
end

function steam_end(event)
	local victim = event.caster
	print("STEAm END?")
	if event.type == DAMAGE_TYPE_PHYSICAL then
		victim.physicalStacks = 0
	elseif event.type == DAMAGE_TYPE_MAGICAL then
		victim.magicalStacks = 0
	end
		victim.physicalStacks = victim:GetModifierStackCount("modifier_terrasic_fire_key_holder_steam_physical", victim)
		victim.magicalStacks = victim:GetModifierStackCount("modifier_terrasic_fire_key_holder_steam_magical", victim)
	local totalStackVisual = victim.magicalStacks + victim.physicalStacks
	local stackInput = math.min(totalStackVisual, 100)
	ParticleManager:SetParticleControl(victim.steamPFX, 10, Vector(stackInput, stackInput, stackInput))
	ParticleManager:SetParticleControl(victim.steamPFX, 14, Vector(stackInput, stackInput/12 + 1, totalStackVisual/10))
	ParticleManager:SetParticleControl(victim.steamPFX, 15, Vector(250, 250, 250))
	if totalStackVisual <= 0 then
		ParticleManager:DestroyParticle(victim.steamPFX, true)
		victim.steamPFX = false
	end
end

function fire_key_holder_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:IsAlive() then
		if not caster.summons then
			caster.summons = 0.90
		end
		if caster:GetHealth() < caster:GetMaxHealth()*caster.summons then
			caster.summons = caster.summons - 0.03
			local baseVector = Vector(-1024, -4784)
			local randomY = RandomInt(1,750)
			local dummy = CreateUnitByName("npc_dummy_unit", baseVector+Vector(0,randomY), false, nil, nil, DOTA_TEAM_NEUTRALS)
			ability:ApplyDataDrivenModifier(caster, dummy, "modifier_fire_key_holder_red_effect", {})
			WallPhysics:Jump(dummy, Vector(-1,0), RandomInt(12,14), RandomInt(36,40), RandomInt(26,30), 1.2)
			Timers:CreateTimer(4.5, function()
				local luck = RandomInt(1,5)
				local unit = true
				if luck <= 2 then
					unit = Tanari:SpawnVolcanicAsh(dummy:GetAbsOrigin(), Vector(-1,0))
				else
					unit = Tanari:SpawnMoltenEntity(dummy:GetAbsOrigin(), Vector(-1,0))
				end
				Dungeons:AggroUnit(unit)
				-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
				unit:SetDeathXP(unit:GetDeathXP()/3)
				UTIL_Remove(dummy)
			end)
		end
		if not caster:HasModifier("modifier_fire_key_holder_submerged") then
			caster:SetAbsOrigin(caster.origin)
		end
	end

end

function fire_temple_key_holder_die(event)
	local caster = event.caster
	EmitSoundOn("Tanari.FireKeyHolder.Death", caster)
	for i = 1, 120, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(1,-1,-2))
		end)
	end
	Timers:CreateTimer(1, function()
		EmitGlobalSound("Tanari.KeyVictory")
		Tanari:AcquireTempleKey(caster:GetAbsOrigin(), "fire")
	end)
	Timers:CreateTimer(0.5, function()
		Tanari:CreateLavaBlast(caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,100))
	end)
	Timers:CreateTimer(3, function()
		Tanari:LowerWaterTempleWall(-4, "TerrasicKeyWall", Vector(-2174, -4352, 381), "TerrasicKeyBlocker", Vector(-2200, -4352, 350), 1200, true, false)
	end)
	for j = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[j]:RemoveModifierByName("modifier_fire_key_holder_range")
	end
	Tanari.FireTempleKeyAcquired = true
	UTIL_Remove(Tanari.fireKeyBlock1)
	UTIL_Remove(Tanari.fireKeyBlock2)
	UTIL_Remove(Tanari.fireKeyBlock3)
	if GameState:GetDifficultyFactor() > 1 then
		local luck = RandomInt(1,4)
		if luck == 1 then
			RPCItems:RollTerrasicLavaBoots(caster:GetAbsOrigin())
		end
	end
end

function fire_key_holder_attack(event)
	local target = event.target
	EmitSoundOn("Tanari.FireKeyHolder.Attack", target)
end
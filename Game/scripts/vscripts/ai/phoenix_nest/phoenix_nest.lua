function phoenix_egg_think(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	caster:SetForwardVector(WallPhysics:rotateVector(fv, math.pi/56))
	local currentHealthProt1 = 0
	local maxHealthProt1 = 0
	local currentHealthProt2 = 0
	local maxHealthProt2 = 0
	local currentHealthProt3 = 0
	local maxHealthProt3 = 0
	local currentHealthProt4 = 0
	local maxHealthProt4 = 0
	if Dungeons.beaconSW.regen == -1 then
		currentHealthProt1 = Dungeons.beaconSW:GetHealth()
		maxHealthProt1 = Dungeons.beaconSW:GetMaxHealth()
	else
		currentHealthProt1 = Dungeons.beaconSW.regen
		Dungeons.beaconSW.regen = Dungeons.beaconSW.regen + 1
		maxHealthProt1 = 1800
		if Dungeons.beaconSW.regen >= 1800 then
			CustomGameEventManager:Send_ServerToAllClients("guardian_regen_end", {guardianNumber=1} )
			reviveProtector(Dungeons.beaconSW)
		end
	end
	if Dungeons.beaconSE.regen == -1 then
		currentHealthProt2 = Dungeons.beaconSE:GetHealth()
		maxHealthProt2 = Dungeons.beaconSE:GetMaxHealth()
	else
		currentHealthProt2 = Dungeons.beaconSE.regen
		Dungeons.beaconSE.regen = Dungeons.beaconSE.regen + 1
		maxHealthProt2 = 1800
		if Dungeons.beaconSE.regen >= 1800 then
			CustomGameEventManager:Send_ServerToAllClients("guardian_regen_end", {guardianNumber=2} )
			reviveProtector(Dungeons.beaconSE)
		end
	end
	if Dungeons.beaconNE.regen == -1 then
		currentHealthProt3 = Dungeons.beaconNE:GetHealth()
		maxHealthProt3 = Dungeons.beaconNE:GetMaxHealth()
	else
		currentHealthProt3 = Dungeons.beaconNE.regen
		Dungeons.beaconNE.regen = Dungeons.beaconNE.regen + 1
		maxHealthProt3 = 1800
		if Dungeons.beaconNE.regen >= 1800 then
			CustomGameEventManager:Send_ServerToAllClients("guardian_regen_end", {guardianNumber=3} )	
			reviveProtector(Dungeons.beaconNE)
		end
	end
	if Dungeons.beaconNW.regen == -1 then
		currentHealthProt4 = Dungeons.beaconNW:GetHealth()
		maxHealthProt4 = Dungeons.beaconNW:GetMaxHealth()
	else
		currentHealthProt4 = Dungeons.beaconNW.regen
		Dungeons.beaconNW.regen = Dungeons.beaconNW.regen + 1
		maxHealthProt4 = 1800
		if Dungeons.beaconNW.regen >= 1800 then
			CustomGameEventManager:Send_ServerToAllClients("guardian_regen_end", {guardianNumber=4} )
			reviveProtector(Dungeons.beaconNW)
		end
	end
	if caster.active then
		CustomGameEventManager:Send_ServerToAllClients("update_phoenix_health", {maxHealth=Dungeons.phoenixEgg:GetMaxHealth(), currentHealth=Dungeons.phoenixEgg:GetHealth(), currentHealthProt1=currentHealthProt1, maxHealthProt1=maxHealthProt1, currentHealthProt2=currentHealthProt2, maxHealthProt2=maxHealthProt2, currentHealthProt3=currentHealthProt3, maxHealthProt3=maxHealthProt3, currentHealthProt4=currentHealthProt4, maxHealthProt4=maxHealthProt4 } )
		if not caster.position then
			caster.position = caster:GetAbsOrigin()
		end
		if not caster:HasModifier("modifier_phoenix_hatching") then
		    caster:SetAbsOrigin(caster.position)
	    end
	end

end

function kriggus_think(event)
	local caster = event.caster
	caster.jumpEnd = "hermit"
	if caster.active then
		if not caster.interval then
			caster.interval = 0
		end
		caster.interval = caster.interval + 1
		if caster.interval%4 == 0 then
			local soundTable = {"pudge_pud_pain_01", "pudge_pud_pain_02", "pudge_pud_pain_03", "pudge_pud_pain_04"}
			EmitSoundOn(soundTable[RandomInt(1, 4)], caster)
			WallPhysics:Jump(caster, caster:GetForwardVector(), 35, 22, 30, 1.5)
			StartAnimation(caster, {duration=1.8, activity=ACT_DOTA_SPAWN, rate=0.6})
		end
		if caster.interval >= 10 then
			caster.interval = 0
		end
	end
end

function phoenix_dragon_think(event)
	local caster = event.target
	if not caster.interval then
		caster.interval = 0
	end
	if not caster.enemyPosition then
		caster.enemyPosition = caster:GetAbsOrigin()
	end

	-- local fv = Vector(0,0)
	if caster.interval == 35 or caster.interval == 105 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )
		if #enemies > 0 then
			caster.enemyPosition = enemies[1]:GetAbsOrigin()
			caster:MoveToPosition(caster.enemyPosition+RandomVector(600))
		else
			caster.enemyPosition = Dungeons.phoenixEggLocation
			caster:MoveToPosition(caster.enemyPosition+RandomVector(600))			
		end
	end
		local negativeFactor = RandomInt(0,1)
		if negativeFactor == 0 then
			negativeFactor = -1
		end
		caster.fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/RandomInt(6, 9)*negativeFactor)
	caster.enemyPosition = caster.enemyPosition+caster.fv*10
	caster:MoveToPosition(caster.enemyPosition)
	local fv = caster:GetForwardVector()
	local newPos = caster:GetAbsOrigin()+caster.fv*20
	-- caster:SetAbsOrigin(newPos)
	caster.interval = caster.interval + 1
	if caster.interval > 140 then
		local ability = event.ability
		local start_radius = 180
		local end_radius = 400
		local range = 600
		local speed = 500
		local info = 
		{
				Ability = ability,
	        	EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
	        	vSpawnOrigin = newPos+fv*150,
	        	fDistance = range,
	        	fStartRadius = start_radius,
	        	fEndRadius = end_radius,
	        	Source = caster,
	        	StartPosition = "attach_origin",
	        	bHasFrontalCone = true,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)		
		caster.interval = 0
		StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.1})
		EmitSoundOn("Hero_Jakiro.DualBreath", caster)
	end
end

function high_jump_think(event)
	local caster = event.caster
	local ability = event.ability
	WallPhysics:Jump(caster, caster:GetForwardVector(), 15, 42, 38, 1)
	if caster.animationInt then
		StartAnimation(caster, {duration=1.5, activity=caster.animationInt, rate=0.9})
	end
end
-- ribe( "", guardianRegenBegin );
--   GameEvents.Subscribe( "guardian_regen_end"

function phoenix_siege_think(event)
	-- local caster = event.caster
	-- local position = caster:GetAbsOrigin()
	-- local distanceToPhoenix = WallPhysics:GetDistance(position, Dungeons.phoenixEggLocation)
	-- if distanceToPhoenix < 300 then
	-- 	caster:MoveToTargetToAttack(Dungeons.phoenixEgg)
	-- 	Timers:CreateTimer(2.5, function()
	-- 		caster:Stop()
	-- 	end)
	-- end
end

function phoenix_mob_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	if not caster.moving and caster:IsAlive() then
		caster:MoveToPosition(attacker:GetAbsOrigin())
		caster.moving = true
		Timers:CreateTimer(3.5, function()
			if not caster:IsNull() then
				caster.moving = false
				caster:Stop()
			end
		end)
	end
end

function phoenix_mob_die(event)
	Dungeons.phoenixMobsKilled = Dungeons.phoenixMobsKilled + 1
	print("KILLED "..Dungeons.phoenixMobsKilled)
	print("Thresh "..Dungeons.phoenixMobsThreshold)
	if Dungeons.phoenixMobsKilled == Dungeons.phoenixMobsThreshold then
		Dungeons:IncrementPhoenixWave()
	end
end

function kriggus_follower_think(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- if caster.active then
	-- 	local position = caster:GetAbsOrigin()
	-- 	local forwardGroundPosition = GetGroundPosition(position + (caster:GetForwardVector()*Vector(1,1,0)):Normalized()*44, caster)
	-- 	local forwardMovement = caster:GetForwardVector()*Vector(1,1,0)
	-- 	local bGround = true
	-- 	if position.z < forwardGroundPosition.z-20 then
	-- 		print("CLIMB!")
	-- 		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kriggus_climbing", {})
	-- 	else
	-- 		caster:RemoveModifierByName("modifier_kriggus_climbing")
	-- 	end

	-- end
end

function kriggus_climbing_think(event)
	-- local caster = event.caster
	-- caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,4))
end

-- function kriggus_follower_animate(event)
-- 	local caster = event.caster
-- 	if caster.active then
-- 		StartAnimation(caster, {duration=2, activity=ACT_DOTA_RUN, rate=0.9})
-- 		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 140, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
-- 		if #enemies > 0 then
-- 			caster.active = false
-- 			Timers:CreateTimer(1.5, function()
-- 				caster.active = true
-- 			end)
-- 		end
-- 	end
-- end

function protector_die(event)
	local caster = event.caster
	
	EmitGlobalSound("phoenix_phoenix_bird_death_defeat")
	CustomGameEventManager:Send_ServerToAllClients("guardian_regen_begin", {guardianNumber=caster.index} )
	if caster.index == 1 then
		Dungeons.beaconSW = CreateUnitByName("phoenix_nest_protector", Dungeons.beaconSWLoc, false, nil, nil, DOTA_TEAM_GOODGUYS)
		Dungeons.beaconSW:SetForwardVector(Vector(-1,-1))	
		Dungeons.beaconSW.index = 1	
		initiateNewProtector(Dungeons.beaconSW)
	elseif caster.index == 2 then
		Dungeons.beaconSE = CreateUnitByName("phoenix_nest_protector", Dungeons.beaconSELoc, false, nil, nil, DOTA_TEAM_GOODGUYS)
		Dungeons.beaconSE:SetForwardVector(Vector(1,-1))		
		Dungeons.beaconSE.index = 2
		initiateNewProtector(Dungeons.beaconSE)
	elseif caster.index == 3 then
		Dungeons.beaconNE = CreateUnitByName("phoenix_nest_protector", Dungeons.beaconNELoc, false, nil, nil, DOTA_TEAM_GOODGUYS)
		Dungeons.beaconNE:SetForwardVector(Vector(1,1))
		Dungeons.beaconNE.index = 3
		initiateNewProtector(Dungeons.beaconNE)
	elseif caster.index == 4 then
		Dungeons.beaconNW = CreateUnitByName("phoenix_nest_protector", Dungeons.beaconNWLoc, false, nil, nil, DOTA_TEAM_GOODGUYS)
		Dungeons.beaconNW:SetForwardVector(Vector(-1,1))
		Dungeons.beaconNW.index = 4
		initiateNewProtector(Dungeons.beaconNW)
	end
	
end

function PhoenixEggDestroyed(event)
	local caster = event.caster
	local particleName =  "particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf"
	local position = caster:GetAbsOrigin()
	local particleVector = position
	CustomGameEventManager:Send_ServerToAllClients("eggDie", {} )
	Timers:CreateTimer(1.2, function()
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
		ParticleManager:SetParticleControl( pfx, 1, particleVector )
		ParticleManager:SetParticleControl( pfx, 2, particleVector )
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
		EmitGlobalSound("phoenix_phoenix_bird_death_defeat")
		Events:ChampionsLose()
	end)
	Dungeons.visionTracer = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			
			MAIN_HERO_TABLE[i]:Stop()
			PlayerResource:SetCameraTarget(playerID, Dungeons.visionTracer)
		end
	end

end

function initiateNewProtector(protector)
	local ability = protector:FindAbilityByName("phoenix_protector_passive")
	ability:ApplyDataDrivenModifier(protector, protector, "modifier_phoenix_protector_regenerating", {duration = 90})
	protector:AddNoDraw()
	protector.regen = 0
	Dungeons.protectorCount = Dungeons.protectorCount - 1
	if not Dungeons.phoenixEggHatched then
		local eggAbility = Dungeons.phoenixEgg:FindAbilityByName("phoenix_passive")
		if Dungeons.protectorCount == 0 then
			Dungeons.phoenixEgg:RemoveModifierByName("modifier_phoenix_guardian_bonus")
			eggAbility:ApplyDataDrivenModifier(Dungeons.phoenixEgg, Dungeons.phoenixEgg, "modifier_phoenix_guardian_bonus", {})
		else
		end
		Dungeons.phoenixEgg:SetModifierStackCount( "modifier_phoenix_guardian_bonus", eggAbility, Dungeons.protectorCount)
		Dungeons.phoenixEgg:RemoveModifierByName("modifier_phoenix_invuln")
		Dungeons:PhoenixScale(protector)
	end

	EmitGlobalSound("phoenix_phoenix_bird_death_defeat")
	local particleName =  "particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf"
	local position = protector:GetAbsOrigin()
	local particleVector = position

	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, protector )
	ParticleManager:SetParticleControl( pfx, 0, particleVector )
	ParticleManager:SetParticleControl( pfx, 1, particleVector )
	ParticleManager:SetParticleControl( pfx, 2, particleVector )
	Timers:CreateTimer(1, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end)  	
end

function reviveProtector(protector)
	protector:RemoveModifierByName("modifier_phoenix_protector_regenerating")
	protector:RemoveNoDraw()
	protector.regen = -1
	Dungeons.protectorCount = Dungeons.protectorCount + 1
	if not Dungeons.phoenixEggHatched then
		local eggAbility = Dungeons.phoenixEgg:FindAbilityByName("phoenix_passive")
		Dungeons.phoenixEgg:SetModifierStackCount( "modifier_phoenix_guardian_bonus", eggAbility, Dungeons.protectorCount)
		Dungeons.phoenixEgg:RemoveModifierByName("modifier_phoenix_invuln")
		if Dungeons.protectorCount == 4 then
			eggAbility:ApplyDataDrivenModifier(Dungeons.phoenixEgg, Dungeons.phoenixEgg, "modifier_phoenix_invuln", {})
		end
	end

	StartAnimation(protector, {duration=1, activity=ACT_DOTA_SPAWN, rate=0.9})
	Timers:CreateTimer(1.5, function()
		StartAnimation(protector, {duration=99999, activity=ACT_DOTA_IDLE, rate=1})
	end)
	EmitGlobalSound("phoenix_phoenix_bird_victory")
	local particleName =  "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
	local position = protector:GetAbsOrigin()
	local particleVector = position

	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, protector )
	ParticleManager:SetParticleControl( pfx, 0, particleVector )
	ParticleManager:SetParticleControl( pfx, 1, particleVector )
	ParticleManager:SetParticleControl( pfx, 2, particleVector )
	Timers:CreateTimer(1, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end)  
	ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
	local enemies = FindUnitsInRadius( protector:GetTeamNumber(), position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 2})
		end
	end
end

function cast_phoenix_blast(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 280
	local position = event.target_points[1]
	Timers:CreateTimer(0.45, function()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				local damage = enemy:GetMaxHealth()*2
				if enemy.bossStatus then
					damage = enemy:GetMaxHealth()*0.35
				end
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
				enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 2.5})
				EmitSoundOn("Hero_Tusk.WalrusPunch.Damage", enemy)
			end
			
		end	
	end)
	EmitSoundOnLocationWithCaster(position, "Hero_Phoenix.SuperNova.Explode", caster)
end

function cast_phoenix_summon(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 280
	local position = event.target_points[1]
	      particleName = "particles/items_fx/infernal_summon_spawn_aegis_starfall.vpcf"
	      for i = 1, 8, 1 do
	      	Timers:CreateTimer(0.2+i*0.06, function()
	      		EmitSoundOnLocationWithCaster(position, "Hero_WarlockGolem.Attack", caster)
	      	end)
	      end
	      EmitSoundOnLocationWithCaster(position, "Hero_Warlock.RainOfChaos_buildup", caster)
	      for i = 0, 5, 1 do
	      	Timers:CreateTimer(0.15*i, function()
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			      ParticleManager:SetParticleControl( particle1, 0, position+Vector(0,0,50) )
			      Timers:CreateTimer(6, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)
		      end)
	  	  end
	      Timers:CreateTimer(0.4, function()
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 2})		
					end
				end 	
				Timers:CreateTimer(0.2, function()
					EmitSoundOnLocationWithCaster(position, "Hero_Warlock.RainOfChaos", caster)
				end)
				for i = 1, 4, 1 do
				local infernal = CreateUnitByName("phoenix_forged_spirit", position, true, nil, nil, caster:GetTeamNumber())
				infernal.owner = caster:GetPlayerOwnerID()
				infernal.summoner = caster
				infernal:SetOwner(caster)
				infernal.dieTime = 20
				infernal:AddAbility("ability_die_after_time_generic"):SetLevel(1)
				StartAnimation(infernal, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.0})
				local summonAbil = infernal:AddAbility("ability_summoned_unit")
				summonAbil:SetLevel(1)
				Dungeons:PhoenixScale(infernal)



				infernal:SetRenderColor(200, 140, 50)
				end

	      end)
end

function lich_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_Spectre.HauntCast", caster)
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.2})
	caster.interval = 0
	for i = -7, 7, 1 do
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/7*i)
		createLichBossProjectile(caster:GetAbsOrigin()+Vector(0,0,120), fv, caster, ability)
	end
end
function createLichBossProjectile(spellOrigin, forward, caster, ability)
	
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/units/heroes/hero_alchemist/linear_ice_projectile_concoction_projectile.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = 950,
        	fStartRadius = 120,
        	fEndRadius = 120,
        	Source = caster,
        	StartPosition = "attach_hitloc",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 7.0,
		bDeleteOnHit = false,
		vVelocity = forward * 500,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function lich_boss_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local sound = "Hero_Pugna.NetherBlast" 
    EmitSoundOn(sound, target)
	local damage = Events:GetAdjustedAbilityDamage(4000, 45000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
end

function phoenix_hunter_think(event)
	local caster = event.caster
	local ability = event.ability
	local windwalk = caster:FindAbilityByName("hunter_shukuchi")
	local newOrder = {
 		UnitIndex = caster:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
 		AbilityIndex = windwalk:entindex(),
 	}
				 
	ExecuteOrderFromTable(newOrder)	
	Timers:CreateTimer(0.05, function()
		caster:MoveToPosition(caster:GetAbsOrigin()+caster:GetForwardVector()*500)
	end)
end

function electron_take_damage(event)
	electron_projectile(event, RandomVector(1))
end

function electron_projectile(event, fv)
	local ability = event.ability
	local caster = event.caster
	local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/linear_electric_immortal_lightning.vpcf"
	local projectileOrigin = caster:GetAbsOrigin() + fv*10
	local start_radius = 140
	local end_radius = 140
	local range = 800
	local speed = 400 + RandomInt(0, 250)
		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = projectileOrigin+Vector(0,0,60),
	        	fDistance = range,
	        	fStartRadius = start_radius,
	        	fEndRadius = end_radius,
	        	Source = caster,
	        	StartPosition = "attach_attack1",
	        	bHasFrontalCone = true,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 4.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
end

function electron_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local sound = "Hero_Zuus.ArcLightning.Target" 
    EmitSoundOn(sound, target)
	local damage = caster:GetAverageTrueAttackDamage(caster)/1000
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
end

function phoenix_begin_hatch(event)
	EmitGlobalSound("Hero_Phoenix.SuperNova.Cast")
	EmitGlobalSound("Hero_Phoenix.SuperNova.Cast")
end

function hatching_think(event)
	local caster = event.caster
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,2))
end

function hatch_complete(event)
	Dungeons.phoenixEggHatched = true
	local origin = event.caster:GetAbsOrigin()
	Dungeons.phoenix = CreateUnitByName("phoenix_hatched", origin, false, nil, nil, DOTA_TEAM_GOODGUYS)
	StartAnimation(Dungeons.phoenix, {duration=2, activity=ACT_DOTA_INTRO, rate=0.5})
	UTIL_Remove(event.caster)
	EmitGlobalSound("Hero_Phoenix.SuperNova.Explode")
	EmitGlobalSound("phoenix_phoenix_bird_victory")
	EmitGlobalSound("phoenix_phoenix_bird_victory")
	local particleName =  "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
	local particleVector = origin
	CustomGameEventManager:Send_ServerToAllClients("phoenix_hatch", {} )
	CustomGameEventManager:Send_ServerToAllClients("phoenixHatched2", {} )
	-- CustomGameEventManager:Send_ServerToAllClients("special_event_close", {} )
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Dungeons.phoenix )
	ParticleManager:SetParticleControl( pfx, 0, particleVector )
	ParticleManager:SetParticleControl( pfx, 1, particleVector )
	ParticleManager:SetParticleControl( pfx, 2, particleVector )
	Dungeons:PhoenixScale(Dungeons.phoenix)
	Timers:CreateTimer(3, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end)  
	ScreenShake(particleVector, 500, 0.4, 0.8, 9000, 0, true)
	local enemies = FindUnitsInRadius( Dungeons.phoenix:GetTeamNumber(), origin, nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 5})
		end
	end
	Timers:CreateTimer(1.6, function()
		EmitGlobalSound("valve_ti5.stinger.dire_lose")
	end)
	Timers:CreateTimer(9, function()
		Dungeons:begin_phoenix_boss_sequence()
	end)
end

function hatched_phoenix_think(event)
	local caster = event.caster
	caster:MoveToPosition(Dungeons.phoenixEggLocation+RandomVector(900))
	-- if not Dungeons.subbossInitiate then
	-- 	CustomGameEventManager:Send_ServerToAllClients("update_phoenix_health", {maxHealth=Dungeons.phoenixBoss:GetMaxHealth(), currentHealth=Dungeons.phoenixBoss:GetHealth(), currentHealthProt1=0, maxHealthProt1=0, currentHealthProt2=0, maxHealthProt2=0, currentHealthProt3=0, maxHealthProt3=0, currentHealthProt4=0, maxHealthProt4=0 } )
	-- end
	-- CustomGameEventManager:Send_ServerToAllClients("update_phoenix_health", {maxHealth=caster:GetMaxHealth(), currentHealth=caster:GetHealth(), currentHealthProt1=0, maxHealthProt1=0, currentHealthProt2=0, maxHealthProt2=0, currentHealthProt3=0, maxHealthProt3=0, currentHealthProt4=0, maxHealthProt4=0 } )
end

function phoenix_boss_health_think(event)
	local caster = event.caster
	if not Dungeons.subbossInitiate then
		CustomGameEventManager:Send_ServerToAllClients("update_phoenix_health", {maxHealth=Dungeons.phoenixBoss:GetMaxHealth(), currentHealth=Dungeons.phoenixBoss:GetHealth(), currentHealthProt1=0, maxHealthProt1=0, currentHealthProt2=0, maxHealthProt2=0, currentHealthProt3=0, maxHealthProt3=0, currentHealthProt4=0, maxHealthProt4=0 } )
	else
		local currentHealthProt1 = 0
		local maxHealthProt1 = 0
		local currentHealthProt2 = 0
		local maxHealthProt2 = 0
		local currentHealthProt3 = 0
		local maxHealthProt3 = 0
		local currentHealthProt4 = 0
		local maxHealthProt4 = 0
		if not Dungeons.subbossA:IsNull() then
			currentHealthProt1 = Dungeons.subbossA:GetHealth()
			maxHealthProt1 = Dungeons.subbossA:GetMaxHealth()
		end
		if not Dungeons.subbossB:IsNull() then
			currentHealthProt2 = Dungeons.subbossB:GetHealth()
			maxHealthProt2 = Dungeons.subbossB:GetMaxHealth()
		end
		if not Dungeons.subbossC:IsNull() then
			currentHealthProt3 = Dungeons.subbossC:GetHealth()
			maxHealthProt3 = Dungeons.subbossC:GetMaxHealth()
		end
		if not Dungeons.subbossD:IsNull() then
			currentHealthProt4 = Dungeons.subbossD:GetHealth()
			maxHealthProt4 = Dungeons.subbossD:GetMaxHealth()
		end
		CustomGameEventManager:Send_ServerToAllClients("update_phoenix_health", {maxHealth=Dungeons.phoenixBoss:GetMaxHealth(), currentHealth=Dungeons.phoenixBoss:GetHealth(), currentHealthProt1=currentHealthProt1, maxHealthProt1=maxHealthProt1, currentHealthProt2=currentHealthProt2, maxHealthProt2=maxHealthProt2, currentHealthProt3=currentHealthProt3, maxHealthProt3=maxHealthProt3, currentHealthProt4=currentHealthProt4, maxHealthProt4=maxHealthProt4 } )
	end
end

function phoenix_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.active then
		if not caster.interval then
			caster.interval = 1
		end
		if caster.interval% 27 == 0 and caster.interval <= 85 then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 4000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				local enemy = enemies[RandomInt(1,#enemies)]
				local blinkPosition = enemy:GetAbsOrigin()+RandomVector(RandomInt(300,420))
				ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)
				FindClearSpaceForUnit(caster, blinkPosition, false)
				EmitSoundOn("DOTA_Item.BlinkDagger.Activate", caster)
				ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
				phoenix_boss_doom(caster, enemy, blinkPosition)

			end			
		end
		caster.interval = caster.interval + 1
		print(caster.interval)
		if caster.interval >= 106 then
			caster.interval = -20
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_phoenix_boss_pyromaniac", {duration = 4})
			EmitSoundOn("doom_bringer_doom_ability_scorched_0"..RandomInt(1,3), caster)
		end
	end
	if not caster.phase2 then
		if caster:GetHealth() < caster:GetMaxHealth()*0.5 then
			bossPhaseTwo(caster, ability)
		end
	end
end

function phoenix_boss_think_take_damage(event)

end

function bossPhaseTwo(caster, ability)
	Dungeons.subBossCount = 4
	CustomGameEventManager:Send_ServerToAllClients("phoenixBossEndMusic", {} )
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	caster.phase2 = true
	caster.active = false
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_phoenix_boss_injured", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_phoenix_boss_cinematic", {})
	Dungeons.visionTracer = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	Dungeons.visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	Dungeons.visionTracer:AddNewModifier( Dungeons.visionTracer, nil, 'modifier_movespeed_cap_super', nil )
	Dungeons.visionTracer:SetBaseMoveSpeed(4000)
	Timers:CreateTimer(0.5, function()
		EmitGlobalSound("doom_bringer_doom_rare_01")
		EmitGlobalSound("doom_bringer_doom_rare_01")
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 34})
				MAIN_HERO_TABLE[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, Dungeons.visionTracer)
			end
		end
		CustomGameEventManager:Send_ServerToAllClients("phoenixBossSequenceMusic", {} )
	end)
	Timers:CreateTimer(8.5, function()
		caster:RemoveModifierByName("modifier_phoenix_boss_injured")
	end)
	Timers:CreateTimer(9, function()
		StartAnimation(caster, {duration=2.8, activity=ACT_DOTA_TELEPORT, rate=1.7})
		Timers:CreateTimer(0.1, function()
			for i = 1, 5, 1 do
				Timers:CreateTimer((2.8/5)*i, function()
					ScreenShake(caster:GetAbsOrigin(), 400, 0.4, 0.8, 9000, 0, true)
				end)
			end
			EmitGlobalSound("doom_bringer_doom_anger_08")
			EmitGlobalSound("doom_bringer_doom_anger_08")
		end)
	end)
	Timers:CreateTimer(10.4, function()
		Dungeons.visionTracer:MoveToPosition(Dungeons.spawnPointNorth)
		Timers:CreateTimer(1, function()
		  createPentagram(Dungeons.spawnPointNorth, 1)
	      Timers:CreateTimer(2, function()
	      	bringBossFromPentagram("phoenix_subboss_a", Dungeons.spawnPointNorth, 1, 21, Vector(0,-1))
	      end)
		  Timers:CreateTimer(5.5, function()
		  	Dungeons.visionTracer:MoveToPosition(Dungeons.spawnPointWest)
		  	Timers:CreateTimer(1.5, function()
			  createPentagram(Dungeons.spawnPointWest, 2)
		      Timers:CreateTimer(2.5, function()
		      	bringBossFromPentagram("phoenix_subboss_b", Dungeons.spawnPointWest, 2, 16, Vector(1,0))
		      end)
		  	end)			  	
		  end)
		  Timers:CreateTimer(11.5, function()
		  	Dungeons.visionTracer:MoveToPosition(Dungeons.spawnPointSouth)
		  	Timers:CreateTimer(1.5, function()
			  createPentagram(Dungeons.spawnPointSouth, 3)
		      Timers:CreateTimer(2.5, function()
		      	bringBossFromPentagram("phoenix_subboss_c", Dungeons.spawnPointSouth, 3, 11, Vector(0,1))
		      end)
		  	end)			  	
		  end)		
		  Timers:CreateTimer(17.5, function()
		  	Dungeons.visionTracer:MoveToPosition(Dungeons.spawnPointEast)
		  	Timers:CreateTimer(1.5, function()
			  createPentagram(Dungeons.spawnPointEast, 4)
		      Timers:CreateTimer(2.5, function()
		      	bringBossFromPentagram("phoenix_subboss_d", Dungeons.spawnPointEast, 4, 6, Vector(-1,0))
		      end)
		  	end)			  	
		  end)
		  Timers:CreateTimer(23.5, function()
		  	Dungeons:UnlockCamerasAndReturnToHero()
		  	Timers:CreateTimer(1, function()
		  		caster:RemoveModifierByName("modifier_phoenix_boss_cinematic")
		  		ability:ApplyDataDrivenModifier(caster, caster, "modifier_phoenix_boss_shield", {})
		  		CustomGameEventManager:Send_ServerToAllClients("phoenixSubbossSpawn", {} )
		  		Timers:CreateTimer(1, function()
		  			caster.active = true
		  			Dungeons.subbossInitiate = true
		  			Dungeons.subbossA.active = true
		  			Dungeons.subbossB.active = true
		  			Dungeons.subbossC.active = true
		  			Dungeons.subbossD.active = true		  			
		  		end)
		  		Timers:CreateTimer(11, function()
		  			CustomGameEventManager:Send_ServerToAllClients("phoenixBossEndMusic", {} )
		  			Timers:CreateTimer(2, function()
		  				CustomGameEventManager:Send_ServerToAllClients("phoenixBossStartMusic", {} )
		  			end)
		  		end)
		  	end)
		  end)
		end)
		
	end)
end

function createPentagram(location, index)
	  local particleName = "particles/units/heroes/hero_doom_bringer/doom_intro_ring.vpcf"
	  local particleLoc = Vector(location.x, location.y, GetGroundPosition(location, Events.GameMaster).z)
	  if index == 1 then
	  	  particleLoc = particleLoc+Vector(0,0,70)
	      Dungeons.pentagramParticle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle2, 0, particleLoc )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle2, 1, particleLoc )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle2, 4, particleLoc )
	  elseif index == 2 then
	      Dungeons.pentagramParticle3 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle3, 0, particleLoc )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle3, 1, particleLoc )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle3, 4, particleLoc )
	  elseif index == 3 then
	      Dungeons.pentagramParticle4 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle4, 0, particleLoc )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle4, 1, particleLoc )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle4, 4, particleLoc )
	  elseif index == 4 then
	      Dungeons.pentagramParticle5 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle5, 0, particleLoc )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle5, 1, particleLoc )
	      ParticleManager:SetParticleControl( Dungeons.pentagramParticle5, 4, particleLoc )
	  end
end

function bringBossFromPentagram(bossName, location, index, rootDuration, forward)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	local subboss = CreateUnitByName(bossName, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
	subboss:SetAbsOrigin(subboss:GetAbsOrigin()-Vector(0,0,700))
	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, subboss, "modifier_disable_player", {duration = rootDuration})
	subboss:SetForwardVector(forward)
	subboss.index = index
	for i = 1, 25, 1 do
		Timers:CreateTimer(i*0.05, function()
			subboss:SetAbsOrigin(subboss:GetAbsOrigin()+Vector(0,0,28))
		end)
	end
	StartAnimation(subboss, {duration=3.8, activity=ACT_DOTA_SPAWN, rate=0.6})
	if index == 1 then
		Dungeons.subbossA = subboss
	elseif index == 2 then
		print("DUNGEONS.SUBBOSSB WTF!!")
		Dungeons.subbossB = subboss
	elseif index == 3 then
		Dungeons.subbossC = subboss
	elseif index == 4 then
		Dungeons.subbossD = subboss
	end
	Dungeons:PhoenixScale(subboss)
	local bossScale = math.floor(Dungeons.phoenixWave/3)
	Events:AdjustBossPower(subboss, bossScale, bossScale, false)
	local armorBonus = 100 + (GameState:GetDifficultyFactor()-1)*100*Dungeons.phoenixWave
	subboss:SetPhysicalArmorBaseValue(subboss:GetPhysicalArmorBaseValue()+armorBonus)
	EmitGlobalSound("InspectorCam.Activate")
end

function phoenix_boss_doom(caster, enemy, blinkPosition)
	Timers:CreateTimer(0.2, function()
		local doomAbility = caster:FindAbilityByName("phoenix_boss_doom")
		local newOrder = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		 		TargetIndex = enemy:entindex(),
		 		AbilityIndex = doomAbility:entindex(),
		 	}
		 
		ExecuteOrderFromTable(newOrder)	
		Timers:CreateTimer(0.3, function()
			local soundIndex = RandomInt(1, 7)
			EmitSoundOn("doom_bringer_doom_ability_doom_0"..soundIndex, caster)
		end)
	end)
end

function pyroblast_fire(event)
	local caster = event.caster
	local ability = event.ability
	local fv = RandomVector(1)
	local casterOrigin = caster:GetAbsOrigin()
	StartSoundEvent("hero_jakiro.macropyre", caster)
	  Timers:CreateTimer(1.5,
	  function()
		StopSoundEvent("hero_jakiro.macropyre", caster)
	  end)
	local start_radius = 180
	local end_radius = 180
	local range = 2400
	local speed = 750
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/econ/items/puck/puck_alliance_set/pyroblast_aproset.vpcf",
        	vSpawnOrigin = casterOrigin,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end



function pyroblast_impact(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local damage = Events:GetAdjustedAbilityDamage(3000+Dungeons.phoenixWave*200, 35000+Dungeons.phoenixWave*2000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
	target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 2})
end

function subboss_die(event)
	Dungeons.subBossCount = Dungeons.subBossCount - 1
	local subboss = event.caster
	CustomGameEventManager:Send_ServerToAllClients("phoenixGuardianBarUpdate", {updateIndex = subboss.index} )
	local lootDrops = RandomInt(4,6)
	local deathLoc = subboss:GetAbsOrigin()
	for i = 0, lootDrops, 1 do
		RPCItems:RollItemtype(300, deathLoc, 1, 0)
	end
	if Dungeons.subBossCount == 0 then
		local caster = Dungeons.phoenixBoss
		local ability = caster:FindAbilityByName("phoenix_boss_ai")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_phoenix_boss_cinematic", {duration = 3})
		caster:RemoveModifierByName("modifier_phoenix_boss_shield")
		StartAnimation(caster, {duration=2.8, activity=ACT_DOTA_TELEPORT, rate=1.7})
		Timers:CreateTimer(0.1, function()
			for i = 1, 5, 1 do
				Timers:CreateTimer((2.8/5)*i, function()
					ScreenShake(caster:GetAbsOrigin(), 400, 0.4, 0.8, 9000, 0, true)
				end)
			end
			EmitGlobalSound("doom_bringer_doom_anger_08")
			EmitGlobalSound("doom_bringer_doom_anger_08")
		end)
		CustomGameEventManager:Send_ServerToAllClients("hideGuardianContainer", {} )
		Timers:CreateTimer(3, function()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_phoenix_boss_enraged", {})
		end)
	end
	local luck = RandomInt(1,9)
	if luck == 1 then
		local waveBonus = math.min(Dungeons.phoenixWave, 60)
		RPCItems:RollDemonMask(deathLoc, false, waveBonus)
	end
end

function lich_subboss_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local sound = "Hero_Pugna.NetherBlast" 
    EmitSoundOn(sound, target)
	local damage = Events:GetAdjustedAbilityDamage(3000+Dungeons.phoenixWave*100, 45000+Dungeons.phoenixWave*1500, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
end

function phoenix_subboss_b_think(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_Spectre.HauntCast", caster)
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.2})
	caster.interval = 0
	for i = -2, 2, 1 do
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/20*i)
		createLichBossProjectile(caster:GetAbsOrigin()+Vector(0,0,120), fv, caster, ability)
	end
	if caster.active then
		keepInBoundaries(caster)
	end
end

function phoenix_subboss_a_think(event)
	local caster = event.caster
	if caster.active then
		caster.jumpEnd = "doom_boss"
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local soundTable = {"doom_bringer_doom_pain_04", "doom_bringer_doom_pain_06", "doom_bringer_doom_pain_07", "doom_bringer_doom_pain_08", "doom_bringer_doom_pain_09"}
			EmitSoundOn(soundTable[RandomInt(1,#soundTable)], caster)
			local distance = WallPhysics:GetDistance(enemies[1]:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
			local forward = (enemies[1]:GetAbsOrigin()*Vector(1,1,0) - caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
			StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_ATTACK, rate=0.85, translate="pyre"})
			WallPhysics:Jump(caster, forward, distance/25, 20, 30, 1)
		end
		keepInBoundaries(caster)
	end
end

function keepInBoundaries(unit)
	
	local bottomLeftVector = Vector(-1856, -16304)
	local topRightVector = Vector(7168, -8576)
	local currentPosition = unit:GetAbsOrigin()
	if currentPosition.x < bottomLeftVector.x or currentPosition.x > topRightVector.x or currentPosition.y < bottomLeftVector.y or currentPosition.y > topRightVector.y then
		local returnPoint = Vector(3136, -12416)
		FindClearSpaceForUnit(unit, returnPoint, false)
	end
end

function phoenix_subboss_d_think(event)
	local caster = event.caster
	if caster.active then
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #allies > 0 then
			 StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.2})

			 local fv = (allies[1]:GetAbsOrigin()*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
			 -- caster:SetForwardVector(fv)
			 WallPhysics:Jump(caster, fv, 40, 18, 11, 0.7)
			 EmitSoundOn("DOTA_Item.ForceStaff.Activate", caster)
			 Timers:CreateTimer(0.54, function()
			 	local fv2 = (allies[1]:GetAbsOrigin()*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
			 	-- caster:SetForwardVector(fv2)
			 	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
			 	Timers:CreateTimer(0.2, function()
					local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal.vpcf", PATTACH_CUSTOMORIGIN, hero )
					ParticleManager:SetParticleControlEnt(pfx, 0, allies[1], PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", allies[1]:GetAbsOrigin(), true)
					Timers:CreateTimer(2, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					end) 	
					EmitSoundOn("Hero_DoomBringer.LvlDeath", allies[1])
					local healthRestore = math.floor(allies[1]:GetMaxHealth()*0.22)
					PopupHealing(allies[1], healthRestore)
					allies[1]:Heal(healthRestore, caster)
					local safePos = GetGroundPosition(caster:GetAbsOrigin(), caster)
					FindClearSpaceForUnit(caster, safePos, false)
			 	end)
			 end)
		end
		keepInBoundaries(caster)
	end
end

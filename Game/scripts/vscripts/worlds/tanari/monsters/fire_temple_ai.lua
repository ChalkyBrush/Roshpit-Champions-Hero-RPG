function blackguard_cultist_think(event)
	local caster = event.caster
	local brainSap = caster:FindAbilityByName("blackguard_brain_sap")
	local shackle = caster:FindAbilityByName("blackguard_shackles")
	if caster.aggro then
		if shackle:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = shackle:entindex(),
			 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return
			end
		end
		if brainSap:IsFullyCastable() and not caster:IsChanneling() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = brainSap:entindex(),
			 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return
			end
		end
	end
end

function FireTempleLavaArea()
	Tanari:FireTempleSpawnFirstLavaArea()
end

function lava_prisoner_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_FARTHEST, false )
	if #enemies > 0 then
		if caster:HasModifier("modifier_lava_prisoner_submerged") then
			caster:RemoveModifierByName("modifier_lava_prisoner_submerged")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_beast_fighting", {})
			print("RISE!")
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
			-- for i = 1, 30, 1 do
			-- 	Timers:CreateTimer(0.03*i, function()
			-- 		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,25))
			-- 	end)
			-- end
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,396))
			Timers:CreateTimer(0.18, function()
		      Tanari:CreateLavaBlast(caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,20))
		      EmitSoundOn("Tanari.LavaSplash", caster)
		
			end)
		else
			caster:MoveToTargetToAttack(enemies[1])
		end
	else
		if not caster:HasModifier("modifier_lava_prisoner_submerged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_lava_prisoner_submerged", {})
			caster:RemoveModifierByName("modifier_beast_fighting")
			print("FALL!")
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
			
				-- Timers:CreateTimer(0.03*i, function()
				-- 	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,25))
				-- end)
				for i = 1, 33, 1 do
					Timers:CreateTimer(i*0.03, function()
						if IsValidEntity(caster) then
							caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,12))
						end
					end)
				end

				Timers:CreateTimer(0.18, function()
			      Tanari:CreateLavaBlast(caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,20))
			      EmitSoundOn("Tanari.LavaSplash", caster)
				end)

		end
	end
end

function volcano_drake_death(event)
	local caster = event.caster
	local fv = caster:GetForwardVector()
	for i = 1, 60, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()+fv*i+Vector(0,0,i))
		end)
	end
end

function molten_knight_think(event)
	local caster = event.caster
	if caster:IsStunned() then
		local ability = event.ability
		local radius = 750
	      local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
	      ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin() )
	      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
	      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )
	      Timers:CreateTimer(1.5, 
	      function()
	        ParticleManager:DestroyParticle( particle2, false )
	      end)
	      EmitSoundOn("Tanari.VolcanoPharoah.LivingBombExplode", caster)
	      local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
	      
	      Timers:CreateTimer(2, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
						ApplyDamage({ victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
						enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.4})	
				end
			end 
	end
end

function armor_gain_on_attack_attacked(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_temple_armor_gain_stacks", {duration = 7})
	local currentStacks = caster:GetModifierStackCount("modifier_fire_temple_armor_gain_stacks", caster)
	caster:SetModifierStackCount("modifier_fire_temple_armor_gain_stacks", caster, currentStacks+1)
end

function FireTempleRoom1Trigger1(event)
	if Tanari.FireTemple.flameDummy.phase <= 1 then
		Tanari.FireTemple.flameDummy.phase = 1
		Tanari.FireTemple.flameDummy.zDifference = 350
	end
end

function FireTempleRoom1Trigger2(event)
	if Tanari.FireTemple.flameDummy.phase <= 2 then
		Tanari.FireTemple.flameDummy.phase = 2
	end
end

function FireTempleRoom1Trigger3(event)
	if Tanari.FireTemple.flameDummy.phase <= 3 then
		Tanari.FireTemple.flameDummy.phase = 3
		Tanari.FireTemple.flameDummy.zDifference = 300
	end
end

function FireTempleRoom1Trigger4(event)
	if Tanari.FireTemple.flameDummy.phase <= 4 then
		Tanari.FireTemple.flameDummy.phase = 4
		Tanari.FireTemple.flameDummy.zDifference = 270
	end
end

function FireTempleRoom1Trigger5(event)
	if Tanari.FireTemple.flameDummy.phase <= 5 then
		Tanari.FireTemple.flameDummy.phase = 5
		Tanari.FireTemple.flameDummy.zDifference = 220
	end
end

function FireTempleRoom1Trigger6(event)
	if Tanari.FireTemple.flameDummy.phase <= 6 then
		Tanari.FireTemple.flameDummy.phase = 6
		Tanari.FireTemple.flameDummy.zDifference = 200
	end
end

function flamebous_think(event)
	local caster = event.caster
	local ability = event.ability
	if Tanari.FireTemple.flameDummy.zDifference > Tanari.FireTemple.flameDummy.targetZ then
		Tanari.FireTemple.flameDummy.zDifference = Tanari.FireTemple.flameDummy.zDifference - 5
	end
	caster:SetModifierStackCount("modifier_flamebous_fly_height", caster, Tanari.FireTemple.flameDummy.zDifference)
	if caster.phase > 0 then
		local vectorTable = {Vector(1984, -6592), Vector(2624, -7134), Vector(3059, -8148), Vector(1768, -7552), Vector(1575, -8537), Vector(2770, -8912)}
		caster:MoveToPosition(vectorTable[caster.phase])
		if caster.phase == 6 then
			local distance = WallPhysics:GetDistance(Vector(2770, -8912), caster:GetAbsOrigin()*Vector(1,1,0))
			if distance < 50 then
				EmitSoundOnLocationWithCaster(Vector(2770, -8912), "Tanari.TerrasicCrater.FlameSpitThink", Events.GameMaster)
				UTIL_Remove(caster)
				Timers:CreateTimer(0.2, function()
					local particleName = "particles/dire_fx/fire_ambience.vpcf"
		         	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		          	ParticleManager:SetParticleControl(particle1,0,Vector(2735, -8947, 512)+Vector(0,0,400))
				end)
				Tanari:Room1Run()
			end

		end
	end
end

function red_dragon_blood_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
	if #enemies == 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_temple_red_dragon_blood_effect", {duration = 0.65})
	else
		if caster.aggro then
			local castAbility = caster:FindAbilityByName("fire_temple_flame_ring")
			if castAbility:IsFullyCastable() then
					local newOrder = {
					 		UnitIndex = caster:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					 		AbilityIndex = castAbility:entindex(),
				 	}
					 
					ExecuteOrderFromTable(newOrder)	
			end
		else
			local castAbility = caster:FindAbilityByName("fire_temple_flame_ring")
			castAbility:StartCooldown(4.5)
		end
	end
end

function fire_temple_flame_ring(event)
	local caster = event.caster


	local ability = event.ability
	local fv = caster:GetForwardVector()
	for i = -3, 3, 1 do
		local rotatedVector = WallPhysics:rotateVector(fv, 2*math.pi/7*i)
		fire_temple_flame_ring_projectile(ability, caster, rotatedVector)
	end

end

function fire_temple_flame_ring_projectile(ability, caster, fv)
	local start_radius = 120
	local end_radius = 200
	local range = 360
	local speed = 600

	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = caster:GetAbsOrigin(),
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

function shadow_strike_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", caster, 3)
	      local particle1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", PATTACH_CUSTOMORIGIN, target )
	      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
	      Timers:CreateTimer(4, function()
	      	ParticleManager:DestroyParticle(particle1, false)
	      end)
	      ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadow_walk_transition", {duration = 1})
	caster:AddNoDraw()
	EmitSoundOn("Hero_BountyHunter.WindWalk", caster)
	Timers:CreateTimer(1, function()
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", caster, 4)
		caster:RemoveNoDraw()
		-- EmitSoundOn("Hero_BountyHunter.Jinada", target)
		FindClearSpaceForUnit(caster, target:GetAbsOrigin()-target:GetForwardVector()*110, false)
		caster:MoveToTargetToAttack(target)
	end)
end

function relic_seeker_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	local radius = 1000
	local minRadius = caster.minRadius
	local castAbility = caster:FindAbilityByName("fire_temple_shadow_strike")
	local targetFindOrder = FIND_FARTHEST
	if caster.aggro then
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, targetFindOrder, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
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
	caster.interval = caster.interval + 1
	if caster.interval > 100 then
		caster.interval = 1
	end
end

function shadow_strike_attack(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	PopupDamage(target, event.magic_damage)
	CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_b_gold.vpcf", target, 1)
	attacker:RemoveModifierByName("modifier_fire_temple_shadow_strike")
end

function FireTempleBackHallTrigger()
	Tanari:SpawnBRDRoom()
end

function YojimboTrigger()
	Tanari:InitiateYojimboSequence()
end

function MysterySoundTrigger()
	EmitSoundOnLocationWithCaster(Vector(768, -13952, 500), "Tanari.FireTemple.EnterStatueRoom", Events.GameMaster)
end

function frenzy_attack(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_frenzy_buff_effect", {duration = 6})
	local currentStacks = caster:GetModifierStackCount("modifier_frenzy_buff_effect", attacker)
	attacker:SetModifierStackCount("modifier_frenzy_buff_effect", attacker, currentStacks + 1)
end

function yojimbo_think(event)
	local caster = event.caster
	if not caster.remnantTable then
		caster.remnantTable = {}
	end
	local searingChains = caster:FindAbilityByName("yojimbo_searing_chains")
	local flameGuard = caster:FindAbilityByName("yojimbo_flame_guard")
	local fireRemnant = caster:FindAbilityByName("yojimbo_fire_remnant")
	local activateFireRemnant = caster:FindAbilityByName("ember_spirit_activate_fire_remnant")
	if #caster.remnantTable > 0 and activateFireRemnant:IsFullyCastable() then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = activateFireRemnant:entindex(),
					Position = caster.remnantTable[1]
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
			if #caster.remnantTable > 1 then
				local newTable = {}
				for i = 2, #caster.remnantTable, 1 do
					table.insert(newTable, caster.remnantTable[i])
				end
				caster.remnantTable = newTable
			else
				caster.remnantTable = {}
			end
	end
	if flameGuard:IsFullyCastable() then
		local newOrder = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		AbilityIndex = flameGuard:entindex(),
	 	}
		 
		ExecuteOrderFromTable(newOrder)		
		return
	end
	if searingChains:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = searingChains:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)	
			return
		end
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
	if #enemies > 0 then
		if fireRemnant:IsFullyCastable() then
			local castPoint = enemies[1]:GetAbsOrigin()-enemies[1]:GetForwardVector()*100
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = fireRemnant:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			activateFireRemnant:StartCooldown(3)
			table.insert(caster.remnantTable, castPoint)
			return
		end
	end

end

function yojimbo_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Tanari.FireTemple.Yojimbos then
		Tanari.FireTemple.Yojimbos = 0
	end
	Tanari.FireTemple.Yojimbos = Tanari.FireTemple.Yojimbos + 1
	if Tanari.FireTemple.Yojimbos == 6 then
		Timers:CreateTimer(2, function()
			Tanari:LowerWaterTempleWall(-4, "FireTempleYojimboDoor", Vector(3289, -15167, 392), "FireTempleYojimboBlocker", Vector(3292, -15168, 263), 900, true, false)
		end)
		Timers:CreateTimer(6, function()
			EmitSoundOnLocationWithCaster(Vector(3289, -15167, 392), "Tanari.HarpMystery", Events.GameMaster)
			Tanari:FireTempleRoom3()
		end)
	end
end

function agility_aura_think(event)
	local caster = event.caster
	local omni_slash = caster:FindAbilityByName("fire_temple_omni_slash")
	if caster.aggro then
		if omni_slash:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 620, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_FARTHEST, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = omni_slash:entindex(),
			 	}
				 
				ExecuteOrderFromTable(newOrder)	
				EmitSoundOn("Tanari.FireTemple.CrazyJuggCast", caster)
			end
		end
	end
end

function FireTempleWaveTrigger(event)
	Tanari:FireTempleWaveTrigger()
end

function fire_wave_room_unit_die(event)
	if not Tanari.FireTemple.FireWaveRoomKills then
		Tanari.FireTemple.FireWaveRoomKills = 0
	end
	Tanari.FireTemple.FireWaveRoomKills = Tanari.FireTemple.FireWaveRoomKills + 1
	if Tanari.FireTemple.FireWaveRoomKills%28 == 0 then
		Tanari:WaveRoomPhase(Tanari.FireTemple.FireWaveRoomKills/28)
	end
	if Tanari.FireTemple.FireWaveRoomKills%1 == 0 then
	    local circleCenter = Vector(6750, -16000, 776)
	    local sunDirection = Vector(-1,0)
	    local degrees = Tanari.FireTemple.FireWaveRoomKills/(7/3)
	    local newSunDirection = WallPhysics:rotateVector(sunDirection, -degrees*math.pi/180)
	    newSunDirection = newSunDirection:Normalized()
	    local newSunPos = circleCenter+newSunDirection*2000
	    local sunPieces = Entities:FindAllByNameWithin("FireTempleSun", newSunPos, 1200)
	    for i = 1, #sunPieces, 1 do
	      sunPieces[i]:SetAbsOrigin(newSunPos)
	    end
	    print(newSunPos)
	    local moonDirection = Vector(0,1)
	    local newMoonDirection = WallPhysics:rotateVector(moonDirection, -degrees*math.pi/180)
	    newMoonDirection = newMoonDirection:Normalized()
	    local newMoonPos = circleCenter+newMoonDirection*2000
	    local moonPieces = Entities:FindAllByNameWithin("FireTempleMoon", newMoonPos-Vector(0,0,4), 1200)
	    for i = 1, #moonPieces, 1 do
	      moonPieces[i]:SetAbsOrigin(newMoonPos)
	    end
	    local floor = Entities:FindAllByNameWithin("FireTempleSunFloor", Vector(6708, -14184, 385), 800)
	    local floorEnt = floor[1]
	    local redDif = 30/90
	    local greenDif = 4/90
	    local blueDif = -47/90
	    floorEnt:SetRenderColor(103+redDif*degrees, 93+greenDif*degrees, 144+blueDif*degrees)
		-- print("MOVE SUN STUFF?")
	end
end

function hulk_swipe_hit(event)
	local caster = event.attacker
	local target = event.target
      local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
      ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
      ParticleManager:SetParticleControl( particle2, 1, Vector(100,100,100) )
      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )
      Timers:CreateTimer(1.5, 
      function()
        ParticleManager:DestroyParticle( particle2, false )
      end)
      local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin() )
      Timers:CreateTimer(2, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
end

function nuclear_solos_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 1400
	local randomDistance = RandomInt(1, radius)
	local randomDirection = RandomVector(1)
	local centerPoint = caster:GetAbsOrigin()
	local arrayPoint = centerPoint+randomDirection*randomDistance
	local damage = event.damage

	EmitSoundOnLocationWithCaster(arrayPoint, "Tanari.FireTemple.NuclearSolosPresound", caster)

      local particleName = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, arrayPoint )
      ParticleManager:SetParticleControl( particle1, 1, Vector(280, 0, 0) )
      ParticleManager:SetParticleControl( particle1, 3, Vector(0, 0, 0) )
      Timers:CreateTimer(4, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
	
	Timers:CreateTimer(0.5, function()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), arrayPoint, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then	
			for i = 1, #enemies, 1 do
				ApplyDamage({ victim = enemies[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
				enemies[i]:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.0})	
			end
		end
		EmitSoundOnLocationWithCaster(arrayPoint, "Tanari.FireTemple.NuclearSolosHitSound", caster)
	      local particleName = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
	      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( particle2, 0, arrayPoint )
	      ParticleManager:SetParticleControl( particle2, 1, Vector(280, 0, 0) )
	      ParticleManager:SetParticleControl( particle2, 3, Vector(0, 0, 0) )
	      Timers:CreateTimer(4, 
	      function()
	        ParticleManager:DestroyParticle( particle2, false )
	      end)
	end)

end

function solos_die(event)
	Tanari:LowerWaterTempleWall(-4, "FireTempleSolosWall", Vector(7786, -15288, 510), "FireTempleSolosObstruction", Vector(7872, -15232, 367), 1200, true, false)
	Tanari:FireTemplePart4()
end

function combustion_cast(event)
	local target = event.unit
	local caster = event.caster
	local damage = event.damage
	local ability = event.ability
		local radius = 500
	      local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, target )
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
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	      ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin() )
	      
	      Timers:CreateTimer(2, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.5})	
				end
			end 	
end

function fire_mage_think(event)
	local caster = event.caster
	local curse = caster:FindAbilityByName("fire_temple_curse_of_combustion")
	if caster.aggro then
		if curse:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local targetIndex = 0
				for i = 1, #enemies, 1 do
					if not enemies[i]:HasModifier("modifier_curse_of_combustion") then
						targetIndex = i
					end
				end
				if targetIndex > 0 then
					local newOrder = {
					 		UnitIndex = caster:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					 		TargetIndex = enemies[targetIndex]:entindex(),
					 		AbilityIndex = curse:entindex(),
				 	}
					 
					ExecuteOrderFromTable(newOrder)	
					return 
				end
			end
		end
		local dragonAbility = caster:FindAbilityByName("fire_temple_dragon_slave")
		if dragonAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = dragonAbility:entindex(),
						Position = castPoint
				 	}
				 
				ExecuteOrderFromTable(newOrder)			
			end
		end
	end
end

function FireTempleFinalRoomTrigger(event)
	Tanari:FireTempleFinalRoomSpawn()
end

function FireTempleLavaSpawnsTrigger()
	local positionsTable = {Vector(7716, -10428), Vector(7465, -10292), Vector(7212, -10022), Vector(6927, -9766), Vector(6730, -9766)}
	local fvTable = {Vector(-1,-0.2), Vector(-1,-0.2), Vector(-1,-0.2), Vector(0.7,-1), Vector(0.6,-1)}
	for i = 1, 13, 1 do
		Timers:CreateTimer(i*0.4, function()
			local luck = RandomInt(1, #positionsTable)
			local dummy = CreateUnitByName("npc_dummy_unit", positionsTable[luck], false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddAbility("ability_red_effect"):SetLevel(1)
			WallPhysics:Jump(dummy, fvTable[luck], RandomInt(11,13), RandomInt(36,40), RandomInt(26,30), 1.2)
			Timers:CreateTimer(4.5, function()
				local luck = RandomInt(1,5)
				local unit = true
				if luck <= 2 then
					unit = Tanari:SpawnVolcanicAsh(dummy:GetAbsOrigin(), RandomVector(1))
				else
					unit = Tanari:SpawnMoltenEntity(dummy:GetAbsOrigin(),  RandomVector(1))
				end
				Dungeons:AggroUnit(unit)
				-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
				UTIL_Remove(dummy)
			end)
		end)
	end
end

function FireTempleFinalTrigger()
	Tanari:FireTempleFinalBossSpawn()
end

function temple_protector_die(event)
	local caster = event.caster
	local healPercent = event.heal_percent/100
	EmitSoundOn("Tanari.FireTemple.ProtectiveSpiritDie", caster)
	-- CustomAbilities:QuickAttachParticle("particles/items_fx/protector_death.vpcf", caster, 3)
	      local particleName = "particles/items_fx/protector_death.vpcf"
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
	      ParticleManager:SetParticleControl( particle1, 1, caster:GetAbsOrigin() )
	      
	      Timers:CreateTimer(2, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
	Timers:CreateTimer(0.05, function()
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.FireTemple.ProtectiveSpiritDieSpell", caster)
	end)
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #allies > 0 then
		for i = 1, #allies, 1 do
			if allies[i]:GetUnitName() == "fire_temple_protective_spirit" then
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", allies[i], 5)
				local buffAbility = allies[i]:FindAbilityByName("fire_temple_protector_death_ability")
				buffAbility:ApplyDataDrivenModifier(allies[i], allies[i], "modifier_death_ability_buff", {})
				local currentStack = allies[i]:GetModifierStackCount("modifier_death_ability_buff", allies[i])
				allies[i]:SetModifierStackCount("modifier_death_ability_buff", allies[i], currentStack+1)
				allies[i].modelScale = allies[i].modelScale+0.07
				allies[i]:SetModelScale(allies[i].modelScale)
				allies[i]:Heal(allies[i]:GetMaxHealth()*healPercent, allies[i])
			end
		end
	end
end

function FireTempleLastRoomTrigger()
	Tanari:FireTempleLastRoomTrigger()
end

function flame_wraith_damage(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_flame_wraith_buff", {duration = 9})
	local currentStacks = caster:GetModifierStackCount("modifier_flame_wraith_buff", caster)
	if currentStacks == 0 then
		CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger_cast.vpcf", caster, 3)
	end
	caster:SetModifierStackCount("modifier_flame_wraith_buff", caster, currentStacks + 1)
end

function flame_wraith_lord_think(event)
	local caster = event.caster
	local ability = event.ability
	local lavaBurst = caster:FindAbilityByName("fire_temple_lava_burst")

	if lavaBurst:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = enemies[1]:entindex(),
			 		AbilityIndex = lavaBurst:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)	
			return 
		end
	end

	local dragonAbility= caster:FindAbilityByName("fire_temple_dragon_slave")
	if dragonAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = dragonAbility:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)		
			return	
		end
	end	
end

function kolthun_intro_think(event)
	
	local caster = event.caster
	if caster.interval then
		caster.interval = false
	else
		caster.interval = true
	end
	if not caster.animate then
		caster.animate = 1
	end
	if caster.animate == 1 then
		StartAnimation(caster, {duration=8, activity=ACT_DOTA_TELEPORT, rate=1}) 
	end
	caster.animate = caster.animate + 1
	if caster.animate>=82 then
		caster.animate = 1
	end
      local particleName = "particles/items_fx/fire_temple_beam.vpcf"
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, Events.GameMaster) 
      -- ParticleManager:SetParticleControl(lightningBolt,0,Vector(8119, -9083, 870)) 
      ParticleManager:SetParticleControlEnt(lightningBolt, 0, Tanari.FireTemple.flameOrb, PATTACH_POINT_FOLLOW, "attach_origin", Tanari.FireTemple.flameOrb:GetAbsOrigin(), true) 

      local attach = "attach_attack1"
      if caster.interval then
      	attach = "attach_attack2"
      end
      ParticleManager:SetParticleControlEnt(lightningBolt, 1, caster, PATTACH_POINT_FOLLOW, attach, caster:GetAbsOrigin(), true)
      Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
      end)
end

function kolthun_battle_begin(event)

	local caster = event.caster
	
	EndAnimation(caster)
	caster:RemoveModifierByName("modifier_kolthun_intro")
	EmitGlobalSound("Tanari.FireTemple.KolthunLaugh1")
	Timers:CreateTimer(2.3, function()
		EmitGlobalSound("Tanari.FireTemple.KolthunLaugh2")
	end)
	CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = caster:GetUnitName(), bossMaxHealth = caster:GetMaxHealth()})
	local rockFallTable = {Vector(7424, -9536, 400), Vector(8000, -8256, 400), Vector(5824, -8000, 400), Vector(7040, -8000, 400), Vector(7488, -10176, 400), Vector(6016, -9344, 400)}
	Tanari.FireTemple.rockfallIndex = 1
	Timers:CreateTimer(4, function()
		caster.phase = 1
	end)
	Timers:CreateTimer(4, function()
		ScreenShake(rockFallTable[Tanari.FireTemple.rockfallIndex], 170, 2, 3, 9000, 0, true)
		local rockfallParticle = "particles/dire_fx/dire_lava_falling_rocks.vpcf"
		local position = rockFallTable[Tanari.FireTemple.rockfallIndex]
		local pfx = ParticleManager:CreateParticle(rockfallParticle, PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl( pfx, 0, position )
		Tanari.FireTemple.rockfallIndex = Tanari.FireTemple.rockfallIndex + 1
		if Tanari.FireTemple.rockfallIndex > #rockFallTable then
			Tanari.FireTemple.rockfallIndex = 1
			EmitSoundOnLocationWithCaster(Vector(6848, -9427), "Tanari.LightRockFall", Events.GameMaster)
			Tanari:CreateLavaBlast(Vector(7424, -7936))
		end
		Timers:CreateTimer(12, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		if not Tanari.FireTemple.KolthunBattleEnd then
			return 3.5
		end
	end)
	
	StopSoundEvent("Tanari.FireTemple.Music", Events.GameMaster)
	Tanari.FireTemple.BossBattleBegun = true
	EmitSoundOnLocationWithCaster(Vector(6848, -9427), "Tanari.LightRockFall", Events.GameMaster)
		Timers:CreateTimer(3.5, function()
			if not Tanari.FireTemple.KolthunBattleEnd then
				EmitSoundOnLocationWithCaster(Vector(6648, -9227), "Tanari.FireTemple.KolthunMusic", Events.GameMaster)
				Timers:CreateTimer(40, function()
					EmitSoundOnLocationWithCaster(Vector(6648, -9227), "Tanari.FireTemple.KolthunMusic2", Events.GameMaster)
				end)
				return 80
			end
		end)

end

function kolthun_main_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_kolthun_dashing") then
		print("DASHING NOW")
	end
	if caster:HasModifier("modifier_kolthun_phase_1_death") then
		return
	end
	if caster:HasModifier("modifier_kolthun_phase_2_death") then
		return
	end
	if caster.phase == 1 or caster.phase == 2 then
		if caster:GetHealth() < 1000 and not caster:HasModifier("modifier_kolthun_phase_1_death") then
			if caster.phase == 1 then
				prepare_kolthun_phase_2(ability, caster)
			elseif caster.phase == 2 then
				if not caster:HasModifier("modifier_kolthun_phase_2_death") then
					prepare_kolthun_phase_3(ability, caster)
				end
			end
		end
		local luck = RandomInt(1, 6)
		local casterOrigin = caster:GetAbsOrigin()
		local ringAbility = caster:FindAbilityByName("fire_temple_fire_ring")
		if ringAbility:IsFullyCastable() then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = ringAbility:entindex(),
		 	}
			ExecuteOrderFromTable(newOrder)	
			StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_SUN_STRIKE, rate=1}) 
		end
		if luck == 1 then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			if #enemies > 0 and not caster:HasModifier("modifier_jumping") and not caster:IsStunned() and not caster:IsRooted() then
				local sumVector = Vector(0,0,0)
				for i = 1, #enemies, 1 do
					sumVector = sumVector + enemies[i]:GetAbsOrigin()
				end
				local avgVector = sumVector/#enemies
				local forceDirection = ((casterOrigin-avgVector)*Vector(1,1,0)):Normalized()
				if caster:HasModifier("modifier_kolthun_dashing") then
					EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
				else
					EmitSoundOn("Tanari.FireTemple.KolthunJumpSmall", caster)
				end
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_dashing", {duration = 0.66})
				StartAnimation(caster, {duration=0.66, activity=ACT_DOTA_CAST_TORNADO, rate=1}) 
				local luck2 = RandomInt(1,3)
				if luck2 == 3 then
					EmitSoundOn("Tanari.FireTemple.KolthunDodge", caster)
				end
				for i = 1, 22, 1 do
					Timers:CreateTimer(i*0.03, function()
						caster:SetAbsOrigin(caster:GetAbsOrigin()+forceDirection*24)
					end)
				end
				Timers:CreateTimer(0.66, function()
					FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
				end)	
			end
		end
		if luck == 2 then
			local flameAbility = caster:FindAbilityByName("kolthun_dragon_slave")
			if flameAbility:IsFullyCastable() then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					local castPoint = enemies[1]:GetAbsOrigin()
					local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							AbilityIndex = flameAbility:entindex(),
							Position = castPoint
					 	}
					local luck3 = RandomInt(1,4)
					if luck3 == 1 then
						EmitSoundOn("Tanari.FireTemple.KolthunCast", caster)
					end
					ExecuteOrderFromTable(newOrder)	
					StartAnimation(caster, {duration=1.3, activity=ACT_DOTA_CAST_CHAOS_METEOR, rate=0.6}) 	
				end
			end
		end
		if not caster:HasModifier("modifier_jumping") then
			local groundDifferential = casterOrigin.z - GetGroundHeight(casterOrigin, caster)
			if groundDifferential > 30 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_falling", {duration = 1})
			else
				caster:RemoveModifierByName("modifier_kolthun_falling")
			end
		end
		if casterOrigin.y > -6876 and not caster:HasModifier("modifier_jumping") then
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_TORNADO, rate=1}) 
			WallPhysics:Jump(caster, Vector(0,-1), 32, 30, 44, 1.4)
			EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
		elseif casterOrigin.x < 4759 and not caster:HasModifier("modifier_jumping") then
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_TORNADO, rate=1}) 
			WallPhysics:Jump(caster, Vector(1,0), 32, 30, 44, 1.4)
			EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
		elseif casterOrigin.y < -10838 and not caster:HasModifier("modifier_jumping") then
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_TORNADO, rate=1}) 
			WallPhysics:Jump(caster, Vector(0,1), 32, 30, 44, 1.4)
			EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
		elseif casterOrigin.x > 9152 and not caster:HasModifier("modifier_jumping") then
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_TORNADO, rate=1}) 
			WallPhysics:Jump(caster, Vector(-1,0), 32, 30, 44, 1.4)
			EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
		end
	end
	if not caster:HasModifier("modifier_jumping") and not caster:HasModifier("modifier_kolthun_falling") and not caster:IsStunned() and not caster:IsRooted() then
		local luck = RandomInt(1,5)
		if luck == 1 then
			local casterOrigin = caster:GetAbsOrigin()
			local aggroTarget = caster:GetAggroTarget()
			if aggroTarget then
				local aggroOrigin = aggroTarget:GetAbsOrigin()
				local pathDistance = GridNav:FindPathLength(casterOrigin, aggroOrigin)
				local crowDistance = WallPhysics:GetDistance(casterOrigin, aggroOrigin)
				print("DISTANCES---")
				print(pathDistance)
				print(crowDistance)
				if pathDistance > crowDistance + 300 or pathDistance == -1 then
						local forceDirection = ((aggroOrigin-casterOrigin)*Vector(1,1,0)):Normalized()
						StartAnimation(caster, {duration=0.66, activity=ACT_DOTA_CAST_TORNADO, rate=1})
						if caster:HasModifier("modifier_kolthun_dashing") then
							EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
						else
							EmitSoundOn("Tanari.FireTemple.KolthunJumpSmall", caster)
						end 
						for i = 1, 22, 1 do
							Timers:CreateTimer(i*0.03, function()
								caster:SetAbsOrigin(caster:GetAbsOrigin()+forceDirection*24)
							end)
						end		
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_dashing", {duration = 0.66})
						Timers:CreateTimer(0.66, function()
							FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
						end)	
				end
			end
		end
	end
end

function prepare_kolthun_phase_2(ability, caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_phase_1_death", {})
	EndAnimation(caster)
	Timers:CreateTimer(0.1, function()
		StartAnimation(caster, {duration=30, activity=ACT_DOTA_DIE, rate=0.1})
	end)
	EmitGlobalSound("Tanari.FireTemple.KolthunPain")
end

function prepare_kolthun_phase_3(ability, caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_phase_2_death", {})
	EndAnimation(caster)
	Timers:CreateTimer(0.1, function()
		StartAnimation(caster, {duration=30, activity=ACT_DOTA_DIE, rate=0.1})
	end)
	EmitGlobalSound("Tanari.FireTemple.KolthunPain")
end

function kolthun_falling(event)
	local caster = event.caster
	caster.fallVelocity = caster.fallVelocity + 1
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,caster.fallVelocity))
end

function kolthun_fall_end(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT_END, rate=1})
	caster.fallVelocity = 0
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function fire_ring_think(event)
	local caster = event.caster
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 370, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		local validBurnTable = {}
		for i = 1, #enemies, 1 do
			local validBurn = true
			for j = 1, #enemies2, 1 do
				if enemies[i]:GetEntityIndex() == enemies2[j]:GetEntityIndex() then
					validBurn = false
				end
			end
			if validBurn then
				table.insert(validBurnTable, enemies[i])
			end
		end
		if #validBurnTable > 0 then
			for k = 1, #validBurnTable, 1 do
				event.ability:ApplyDataDrivenModifier(caster, validBurnTable[k], "modifier_fire_ring_impact", {duration = 4})
			end
		end
	end
end

function kolthun_buffing_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.interval then
		caster.interval = false
	else
		caster.interval = true
	end
	print("BUFFING UP?")
      local particleName = "particles/items_fx/fire_temple_beam.vpcf"
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, Events.GameMaster) 
      -- ParticleManager:SetParticleControl(lightningBolt,0,Vector(8119, -9083, 870)) 
      ParticleManager:SetParticleControlEnt(lightningBolt, 0, Tanari.FireTemple.flameOrb, PATTACH_POINT_FOLLOW, "attach_origin", Tanari.FireTemple.flameOrb:GetAbsOrigin(), true) 

      local attach = "attach_attack1"
      if caster.interval then
      	attach = "attach_attack2"
      end
      ParticleManager:SetParticleControlEnt(lightningBolt, 1, caster, PATTACH_POINT_FOLLOW, attach, caster:GetAbsOrigin(), true)
      Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
      end)
      caster:Heal(caster:GetMaxHealth()*0.02, caster)
      CustomGameEventManager:Send_ServerToAllClients("update_boss_health", {current_health = caster:GetHealth()})
end

function kolthun_phase_1_death_think(event)
	local caster = event.caster
	if caster:HasModifier("modifier_kolthun_phase_1_buffing_up") then
		return
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 5, false)
	local ability = event.ability
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), Vector(8319, -9383, 820))

	if GetGroundHeight(caster:GetAbsOrigin(), caster) > caster:GetAbsOrigin().z then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,10))
	end
	if not caster:HasModifier("modifier_kolthun_phase_1_buffing_up") then
		local motionVector = (Vector(8319, -9383, 820)-caster:GetAbsOrigin()):Normalized()
		caster:SetAbsOrigin(caster:GetAbsOrigin()+motionVector*15)
	end
	if distance <= 90 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_phase_1_buffing_up", {duration = 5})
		local fv =  ((Vector(8119, -9083, 270)-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		caster:SetForwardVector(fv)
		Timers:CreateTimer(5, function()
			caster:RemoveModifierByName("modifier_kolthun_phase_1_buffing_up")
		end)
	end
end

function kolthun_buff_up_end(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	caster.phase = 2
	caster:RemoveModifierByName("modifier_kolthun_phase_1_death")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_phase_2", {})
	caster:SetModelScale(1.26)
	EmitGlobalSound("Tanari.FireTemple.KolthunLaugh1")
	Timers:CreateTimer(2.3, function()
		EmitGlobalSound("Tanari.FireTemple.KolthunLaugh2")
	end)
	EmitSoundOn("Hero_OgreMagi.Bloodlust.Cast", caster)
	Timers:CreateTimer(0.1, function()
		EmitSoundOn("Hero_OgreMagi.Bloodlust.Target", caster)
	end)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_shield", {})
	local stacks = 30
	if GameState:GetDifficultyFactor() == 2 then
		stacks = 50
	elseif GameState:GetDifficultyFactor() == 3 then
		stacks = 70
	end
	caster:SetModifierStackCount("modifier_kolthun_shield", caster, stacks)
end

function kolthun_phase_2_death_think(event)
	local caster = event.caster
	if caster:HasModifier("modifier_kolthun_phase_3") then
		return
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 5, false)
	local ability = event.ability
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), Vector(8395, -10101, 600))

	if GetGroundHeight(caster:GetAbsOrigin(), caster) > caster:GetAbsOrigin().z then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,10))
	end
	if not caster:HasModifier("modifier_kolthun_phase_1_buffing_up") then
		local motionVector = (Vector(8395, -10101, 600)-caster:GetAbsOrigin()):Normalized()
		caster:SetAbsOrigin(caster:GetAbsOrigin()+motionVector*15)
	end
	caster:RemoveModifierByName("modifier_boss_health")
	caster:RemoveAbility("boss_health")
	if distance <= 90 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_phase_3", {})
		for i = 1, 25, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,20+i))
			end)
		end
		Timers:CreateTimer(0.6, function()
		      Tanari:CreateLavaBlast(Vector(8395, -10101, 100))
		      EmitSoundOn("Tanari.LavaSplash", caster)
		      Timers:CreateTimer(3, function()
		      	Tanari:SpawnFireLord(caster)
		      end)
		end)
	end
end

function kolthun_phase_3_think(event)
	local caster = event.caster
	if caster.phase3active then
		if not caster.threeThink then
			caster.threeThink = 1
		end
		caster:SetAbsOrigin(caster.boss:GetAbsOrigin()+Vector(0,0,90))
		caster:SetForwardVector(caster.boss:GetForwardVector())
		caster.threeThink = caster.threeThink + 1
		if caster.threeThink%5 == 0 then
		      local particleName = "particles/items_fx/fire_temple_beam.vpcf"
		      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, Events.GameMaster) 
		      -- ParticleManager:SetParticleControl(lightningBolt,0,Vector(8119, -9083, 870)) 
		      local attachC = "attach_arm_L"
		      if caster.cInterval then
		      	attachC = "attach_arm_R"
		      	caster.cInterval = false
		      else
		      	caster.cInterval = true
		      end

		      ParticleManager:SetParticleControlEnt(lightningBolt, 0,	caster.boss, PATTACH_POINT_FOLLOW, attachC, caster.boss:GetAbsOrigin(), true) 

		      local attach = "attach_attack1"
		      if caster.interval then
		      	attach = "attach_attack2"
		      	caster.interval = false
		      else
		      	caster.interval = true
		      end
		      ParticleManager:SetParticleControlEnt(lightningBolt, 1, caster, PATTACH_POINT_FOLLOW, attach, caster:GetAbsOrigin(), true)
		      Timers:CreateTimer(1, function()
		        ParticleManager:DestroyParticle(lightningBolt, false)
		      end)
		end
		if caster.threeThink > 20 then
			caster.threeThink = 0
		end
	end
end

function firelord_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.dying then 
		return
	end
	if caster:GetHealth() < 1000 then
		caster.dying = true
		fire_temple_boss_die(caster, ability)
	end
	if not caster:HasModifier("modifier_firelord_intro") then
		if caster:HasModifier("modifier_kolthun_dashing") then
			print("DASHING NOW")
		end

			if caster:GetHealth() < 1000 and not caster:HasModifier("modifier_kolthun_phase_1_death") then
				-- if caster.phase == 1 then
				-- 	prepare_kolthun_phase_2(ability, caster)
				-- elseif caster.phase == 2 then
				-- 	if not caster:HasModifier("modifier_kolthun_phase_2_death") then
				-- 		prepare_kolthun_phase_3(ability, caster)
				-- 	end
				-- end
			end
			local luck = RandomInt(1, 6)
			local casterOrigin = caster:GetAbsOrigin()
			local ringAbility = caster:FindAbilityByName("fire_temple_fire_ring")
			if ringAbility:IsFullyCastable() then
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				 		AbilityIndex = ringAbility:entindex(),
			 	}
				ExecuteOrderFromTable(newOrder)	
				StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_SUN_STRIKE, rate=1}) 
			end
			if luck == 1 then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
				if #enemies > 0 and not caster:HasModifier("modifier_jumping") and not caster:IsStunned() and not caster:IsRooted() then
					local sumVector = Vector(0,0,0)
					for i = 1, #enemies, 1 do
						sumVector = sumVector + enemies[i]:GetAbsOrigin()
					end
					local avgVector = sumVector/#enemies
					local forceDirection = ((casterOrigin-avgVector)*Vector(1,1,0)):Normalized()
					if caster:HasModifier("modifier_kolthun_dashing") then
						EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
					else
						EmitSoundOn("Tanari.FireTemple.KolthunJumpSmall", caster)
					end
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_dashing", {duration = 0.66})
					StartAnimation(caster, {duration=0.66, activity=ACT_DOTA_TELEPORT_END, rate=1}) 
					local luck2 = RandomInt(1,3)
					if luck2 == 3 then
						EmitSoundOn("Tanari.FireTemple.NeverlordJump", caster)
					end
					for i = 1, 22, 1 do
						Timers:CreateTimer(i*0.03, function()
							caster:SetAbsOrigin(caster:GetAbsOrigin()+forceDirection*34)
						end)
					end
					Timers:CreateTimer(0.66, function()
						FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
					end)	
				end
			end
			if luck == 2 then
				local flameAbility = caster:FindAbilityByName("kolthun_dragon_slave")
				if flameAbility:IsFullyCastable() then
					local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
					if #enemies > 0 then
						local castPoint = enemies[1]:GetAbsOrigin()
						local newOrder = {
								UnitIndex = caster:entindex(),
								OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
								AbilityIndex = flameAbility:entindex(),
								Position = castPoint
						 	}
						local luck3 = RandomInt(1,4)
						if luck3 == 1 then
							EmitSoundOn("Tanari.FireTemple.NeverlordCast", caster)
						end
						ExecuteOrderFromTable(newOrder)	
						StartAnimation(caster, {duration=1.3, activity=ACT_DOTA_RAZE_1, rate=0.8}) 	
					end
				end
			end
			if luck == 3 then
				local razeAbility = caster:FindAbilityByName("neverlord_raze")
				if razeAbility:IsFullyCastable() then
					local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
					if #enemies > 0 then
						local castPoint = enemies[1]:GetAbsOrigin()
						local newOrder = {
								UnitIndex = caster:entindex(),
								OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
								AbilityIndex = razeAbility:entindex(),
								Position = castPoint
						 	}
						local luck3 = RandomInt(1,4)
						if luck3 == 1 then
							EmitSoundOn("Tanari.FireTemple.NeverlordCast", caster)
						end
						ExecuteOrderFromTable(newOrder)	
						-- StartAnimation(caster, {duration=1.3, activity=ACT_DOTA_RAZE_1, rate=0.8}) 	
					end
				end
			end
			if not caster:HasModifier("modifier_jumping") then
				local groundDifferential = casterOrigin.z - GetGroundHeight(casterOrigin, caster)
				if groundDifferential > 30 then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_falling", {duration = 1})
				else
					caster:RemoveModifierByName("modifier_kolthun_falling")
				end
			end
			if casterOrigin.y > -6876 and not caster:HasModifier("modifier_jumping") then
				StartAnimation(caster, {duration=2, activity=ACT_DOTA_FLAIL, rate=1, translate = "forcestaff_friendly"}) 
				WallPhysics:Jump(caster, Vector(0,-1), 32, 30, 44, 1.4)
				EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
			elseif casterOrigin.x < 4759 and not caster:HasModifier("modifier_jumping") then
				StartAnimation(caster, {duration=2, activity=ACT_DOTA_FLAIL, rate=1, translate = "forcestaff_friendly"}) 
				WallPhysics:Jump(caster, Vector(1,0), 32, 30, 44, 1.4)
				EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
			elseif casterOrigin.y < -10838 and not caster:HasModifier("modifier_jumping") then
				StartAnimation(caster,{duration=2, activity=ACT_DOTA_FLAIL, rate=1, translate = "forcestaff_friendly"})  
				WallPhysics:Jump(caster, Vector(0,1), 32, 30, 44, 1.4)
				EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
			elseif casterOrigin.x > 9152 and not caster:HasModifier("modifier_jumping") then
				StartAnimation(caster, {duration=2, activity=ACT_DOTA_FLAIL, rate=1, translate = "forcestaff_friendly"}) 
				WallPhysics:Jump(caster, Vector(-1,0), 32, 30, 44, 1.4)
				EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
			end
		if not caster:HasModifier("modifier_jumping") and not caster:HasModifier("modifier_kolthun_falling") and not caster:IsStunned() and not caster:IsRooted() then
			local luck = RandomInt(1,6)
			if luck == 1 then
				local casterOrigin = caster:GetAbsOrigin()
				local aggroTarget = caster:GetAggroTarget()
				if aggroTarget then
					local aggroOrigin = aggroTarget:GetAbsOrigin()
					-- local pathDistance = GridNav:FindPathLength(casterOrigin, aggroOrigin)
					local crowDistance = WallPhysics:GetDistance(casterOrigin, aggroOrigin)
					print("DISTANCES---")
					print(pathDistance)
					print(crowDistance)
					if crowDistance > 700 then
							local forceDirection = ((aggroOrigin-casterOrigin)*Vector(1,1,0)):Normalized()
							StartAnimation(caster, {duration=0.66, activity=ACT_DOTA_FLAIL, rate=1, translate = "forcestaff_friendly"})
							if caster:HasModifier("modifier_kolthun_dashing") then
								EmitSoundOn("Tanari.FireTemple.KolthunJumpBig", caster)
							else
								EmitSoundOn("Tanari.FireTemple.KolthunJumpSmall", caster)
							end 
							for i = 1, 22, 1 do
								Timers:CreateTimer(i*0.03, function()
									caster:SetAbsOrigin(caster:GetAbsOrigin()+forceDirection*34)
								end)
							end		
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_kolthun_dashing", {duration = 0.66})
							Timers:CreateTimer(0.66, function()
								FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
							end)	
					end
				end
			end
		end
	end
end

function neverlord_raze_cast(event)
	local caster = event.caster
	local point = event.target_points[1] + RandomVector(RandomInt(30, 240))
	local ability = event.ability
	EmitSoundOnLocationWithCaster(point, "Tanari.FireTemple.NeverlordRaze", caster)
	createRazeAtPosition(caster, point, ability, event.damage)
	local forward = caster:GetForwardVector()
	for i = 1, 4, 1 do
		local rotatedForward = WallPhysics:rotateVector(forward, math.pi*i/2)
		local newPosition = point+rotatedForward*180
		createRazeAtPosition(caster, newPosition, ability, event.damage)
	end
end

function createRazeAtPosition(caster, point, ability, damage)
	local particleName = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, point )
	Timers:CreateTimer(2, 
	function()
		ParticleManager:DestroyParticle( particle1, false )
	end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 180, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )	
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			ApplyDamage({ victim = enemies[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
		end
	end
end

function fire_temple_boss_die(caster, ability)
	Statistics.dispatch("tanari_jungle:kill:kolthun");
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_temple_boss_dying", {duration = 8})
	Tanari.FireTemple.KolthunBattleEnd = true
	local kolthun = caster.kolthun
	Dungeons.itemLevel = 120
	Dungeons.lootLaunch = Vector(8354, -9283)
	Timers:CreateTimer(11, function()
		Dungeons.lootLaunch = false
	end)
	StartAnimation(kolthun, {duration=20, activity=ACT_DOTA_DIE, rate=0.25})
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Tanari.FireTemple.NeverlordDefeat", caster)
	end)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text="Dungeon Clear!", duration=8.0})
	end)
	local casterOrigin = caster:GetAbsOrigin()
	for i = 1, 18, 1 do
		Timers:CreateTimer(0.5*i, function()
			RPCItems:RollItemtype(300, casterOrigin, 1, 0)
		end)
	end
	Timers:CreateTimer(4, function()
		local luck = RandomInt(1,4)
		if luck == 1 then
			RPCItems:RollFirelockPendant(casterOrigin)
		end
	end)
	local bossOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(8, function()
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_temple_boss_dying_final", {})
		caster:RemoveModifierByName("modifier_fire_temple_boss_dying")
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=8, activity=ACT_DOTA_DIE, rate=0.25})
			EmitSoundOn("Tanari.FireTemple.NeverlordJump", caster)
			for i = 1, 120, 1 do
				Timers:CreateTimer(i*0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-2))
					end
				end)
			end
			Timers:CreateTimer(6, function()
				UTIL_Remove(caster)
				UTIL_Remove(kolthun)
				Tanari:DefeatDungeonBoss("fire", bossOrigin)
			end)
		end)
	end)
end

function fire_temple_boss_dying_think(event)
	local caster = event.caster
	if not caster.flailEffect then
		caster.flailEffect = true
		StartAnimation(caster, {duration=5.5, activity=ACT_DOTA_FLAIL, rate=1.0})
	end
	CustomAbilities:QuickAttachParticleWithPoint("particles/radiant_fx2/good_ancient001_dest_gobjglow.vpcf", caster, 4, "attach_hitloc")
	EmitSoundOn("Tanari.WindTemple.BossDying", caster)
end

function rare_centaur_die(event)
	local caster = event.caster
	EmitSoundOn("Tanari.FireTemple.CentaurBossDie", caster)
	RPCItems:RollTerrasicStonePlate(caster:GetAbsOrigin())
end

function conflag_carapace_think(event)
	local caster = event.caster
	local ability = event.ability
	local randomRotat = RandomInt(1,360)
	local fv = WallPhysics:rotateVector(caster:GetForwardVector(), (math.pi/180)*randomRotat)

	local projectileParticle = "particles/units/heroes/hero_jakiro/fireball.vpcf"

	local start_radius = 140
	local end_radius = 140
	local range = 1300
	local speed = 1100
	local casterOrigin = caster:GetAbsOrigin()
	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = casterOrigin+Vector(0,0,80),
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_hitloc",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = true,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	EmitSoundOn("Tanari.FireTemple.ConflagShellFireball", caster)
end

function conflag_carapace_impact(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	local radius = 240
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
	ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )
	Timers:CreateTimer(1.5, 
		function()
		ParticleManager:DestroyParticle( particle2, false )
	end)

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin() )
	Timers:CreateTimer(2, 
		function()
		ParticleManager:DestroyParticle( particle1, false )
	end)
	EmitSoundOn("Tanari.FireTemple.ConflagShellHit", target)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
		end
	end 
end

function lava_forge_die(event)
	local caster = event.caster
	EmitSoundOn("Tanari.FireTemple.LavaforgeDie", caster)
	RPCItems:RollLavaForgeCrown(caster:GetAbsOrigin(), false)
end

function fire_spirit_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetHealth() < caster:GetMaxHealth()*0.5 then
		if not caster:HasModifier("modifier_fire_spirit_enraged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spirit_enraged", {})
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.FireSpirit.BuffApplyVO", caster)
		end
	else
		caster:RemoveModifierByName("modifier_fire_spirit_enraged")
	end
end

function fire_spirit_attack_land(event)
	local target = event.target
	local caster = event.caster
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()+Vector(0,0,60))
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 2, 200))
	EmitSoundOn("Tanari.FireSpirit.AttackLand", target)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function fire_spirit_die(event)
	local caster = event.caster
	Tanari:SpiritFireTempleStart()
	EmitSoundOn("Tanari.FireSpirit.Death", caster)
	local pfx = ParticleManager:CreateParticle("particles/radiant_fx/epoch_rune_w_3_ranged001_lvl3_disintegrate.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,60))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,60))

	local pfx2 = ParticleManager:CreateParticle("particles/radiant_fx/good_barracks_melee002_lvl3_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin()+Vector(0,0,20))
	ParticleManager:SetParticleControl(pfx2, 1, caster:GetAbsOrigin()+Vector(0,0,20))

	Dungeons.respawnPoint = Vector(9664, -15104)

	Timers:CreateTimer(8, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.SpiritRealmEpic", caster)

	local walls = Entities:FindAllByNameWithin("FireTempleSpiritWall", Vector(9846, -15492, 900+Tanari.ZFLOAT), 1200)
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			for i = 1, #walls, 1 do
				EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
			end
		end)
		for i = 1, 180, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,-5))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end
	Timers:CreateTimer(3.5, function()
        local blockers = Entities:FindAllByNameWithin("FireTempleSpiritBlocker", Vector(9846, -15492, 900+Tanari.ZFLOAT), 2400)
        for i = 1, #blockers, 1 do
          UTIL_Remove(blockers[i])
        end
	end)
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollFireBlossom(caster:GetAbsOrigin())
	end
end

function fire_shaman_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	local fv = caster:GetForwardVector()
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SPAWN, rate=1.5}) 
	EmitSoundOn("Tanari.OrchidFireLaunch", caster)
	local projectiles = GameState:GetDifficultyFactor() + 4
	for i = 0, projectiles-1, 1 do
		local rotatedFv = WallPhysics:rotateVector(fv, i*math.pi*2/projectiles)
	    local start_radius = 130
	    local end_radius = 130
	    local speed = 500
	    local position = caster:GetAbsOrigin()
	    local info = 
	    {
	        Ability = ability,
	          EffectName = "particles/units/heroes/hero_jakiro/fireball.vpcf",
	          vSpawnOrigin = position+Vector(0,0,105),
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
	      vVelocity = rotatedFv*speed,
	      bProvidesVision = false,
	    }
	    projectile = ProjectileManager:CreateLinearProjectile(info) 
	end
end

function fire_spawner_think(event)
	local caster = event.caster
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
	local maxSummons = 5
	local loops = 1
	if GameState:GetDifficultyFactor() == 2 then
		maxSummons = 8
	elseif GameState:GetDifficultyFactor() == 3 then
		maxSummons = 12
		loops = 2
	end
	if #caster.summonTable > maxSummons then
		return
	end
	caster.totalSummons = caster.totalSummons + 1
	local itemRoll = 1
	if caster.totalSummons > 12 then
		itemRoll = 0
	end
	local bAggro = false
	if caster.aggro then
		bAggro = true
	end
	for i = 1, loops, 1 do
		local position = caster.summonCenter + RandomVector(RandomInt(1, 240))
		local zombie = Tanari:SpawnFireSpawnerUnit(position, RandomVector(1), itemRoll, bAggro)
		if caster.totalSummons > 12 then
			zombie:SetDeathXP(0)
			zombie:SetMaximumGoldBounty(0)
			zombie:SetMinimumGoldBounty(0)
		end
		EmitSoundOn("Redfall.Flower.Spawn", zombie)
		CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_spawn.vpcf", zombie, 3)
		FindClearSpaceForUnit(zombie, zombie:GetAbsOrigin(), false)
		table.insert(caster.summonTable, zombie)
	end

	
end

function fire_spawner_die(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/dire_fx/tower_bad_destroy.vpcf", caster, 4)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Tanari.FireTemple.YojimboDiscipleShatter", caster)
	end)
	for i = 1, 70, 1 do
		Timers:CreateTimer(i*0.03, function()
			if IsValidEntity(caster) then
				caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,3.5))
			end
		end)
	end
end

function gorthos_die(event)
	local caster = event.caster
	EmitSoundOnLocationWithCaster(Vector(14912, -13264), "Tanari.Gorthos.WallOpen", Events.GameMaster)
	local redColor = Vector(146, 108, 108)
	local wallProps = Entities:FindAllByNameWithin("SpiritFireTowers", Vector(14912, -13264), 2000)
	for i = 1, 75, 1 do
		Timers:CreateTimer(0.06, function()
			for j = 1, #wallProps, 1 do
				wallProps[j]:SetRenderColor((146*i)/75, (108*i)/75, (108*i)/75)
			end
		end)
	end
	Timers:CreateTimer(5, function()
		Tanari:SpawnFireSpiritArea2()
		local walls = Entities:FindAllByNameWithin("FireTempleSpiritWall2", Vector(14930, -13241), 1200)
		if #walls > 0 then
			Timers:CreateTimer(0.1, function()
				for i = 1, #walls, 1 do
					EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
				end
			end)
			for i = 1, 180, 1 do
				for j = 1, #walls, 1 do
					Timers:CreateTimer(i*0.03, function()
						walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,-5))
						if j == 1 then
							ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
						end
					end)
				end
			end
		end
		Timers:CreateTimer(3.5, function()
	        local blockers = Entities:FindAllByNameWithin("SpiritWallObstruction", Vector(14912, -13264, 600+Tanari.ZFLOAT), 2400)
	        for i = 1, #blockers, 1 do
	          UTIL_Remove(blockers[i])
	        end
		end)
	end)
end

function begin_specter_rush_two(event)
	local caster = event.caster
	-- caster:Stop()
	local ability = event.ability
	local target = event.target_points[1]
	local chargeSpeed = 1000
	local distance = WallPhysics:GetDistance2d(target,caster:GetAbsOrigin())
	local duration = distance/chargeSpeed
	StartAnimation(caster, {duration=duration+0.39, activity=ACT_DOTA_RUN, rate=1.4, translate="charge"})
	ability.fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	print("charge wind up")
	-- caster:MoveToPosition(caster:GetAbsOrigin() + ability.fv*800)
	local soundTable = {"spirit_breaker_spir_anger_05", "spirit_breaker_spir_laugh_07", "spirit_breaker_spir_move_03"}
	EmitSoundOn(soundTable[RandomInt(1,#soundTable)], caster)
	ability.interval = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_specter_rush_charging", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_charging_fire_create", {duration = duration})
end

function specter_rush_thinking(event)
	local ability = event.ability
	local caster = event.caster
	local movement = 1000*0.03
	caster.EFV = ability.fv
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*movement, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if not blockUnit then
		caster:SetAbsOrigin(newPos)
	end

	if ability.interval%9==0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = 0.7,
			knockback_duration = 0.5,
			knockback_distance = knockback_distance,
			knockback_height = 70
		}
		if #enemies > 0 then
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", caster)
			local damage = event.damage
			for _,enemy in pairs(enemies) do
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin()+Vector(0,0,60))
				ParticleManager:SetParticleControl(pfx, 1, Vector(200, 2, 200))
				EmitSoundOn("Tanari.FireSpirit.AttackLand", enemy)
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)	
			end
		end 			
	end
	ability.interval = ability.interval + 1
end

function specter_rush_end(event)
	local ability = event.ability
	local caster = event.caster
	ability.slideVelocity = 30
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_specter_rush_sliding", {duration = 0.45})
end

function charge_slide_think(event)
	local ability = event.ability
	local caster = event.caster
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*ability.slideVelocity, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if not blockUnit then
		FindClearSpaceForUnit(caster, newPos, false)
	else
		ability.slideVelocity = 0
	end	
	if ability.slideVelocity > 0 then
		ability.slideVelocity = ability.slideVelocity - 2
	end
	caster:RemoveModifierByName("modifier_charging_fire_create")
	print("slide think")
end

function charge_slide_end(event)
	print("slide END")
	local caster = event.caster
	caster.EFV = nil
end

function FireSpiritTrigger(event)
	Tanari:ActivateSwitchGenericWithZ(Vector(11482, -12206, 500), "FireSwitch", true, 0.34)

	Tanari.FireTemple.SpiritWaveUnitsSlain = 0
	Tanari.fireSpawnPortalTable = {}
	local spawnPositionTable = {Vector(11328, -12872, 274), Vector(12160, -11008, 274), Vector(13366, -12902, 297), Vector(13397, -11074, 300), Vector(15428, -12976, 364), Vector(14464, -11074)}
	Timers:CreateTimer(2, function()
		for i = 1, #spawnPositionTable, 1 do
			local pfx = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Tanari.TanariMaster)
			ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i]+Vector(0,0,420+Tanari.ZFLOAT))
			ParticleManager:SetParticleControl(pfx, 1, spawnPositionTable[i]+Vector(0,0,420+Tanari.ZFLOAT))

			table.insert(Tanari.fireSpawnPortalTable, pfx)
			EmitSoundOnLocationWithCaster(spawnPositionTable[i], "Tanari.FireEvent", Tanari.TanariMaster)
		end
	end)
	Timers:CreateTimer(7, function()
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1.5
			if GameState:GetDifficultyFactor() == 2 then
				delay = 1.3
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 1.1
			end
			if i <= 3 then
				Tanari:SpawnSpiritFireWaveUnit("fire_temple_blackguard", spawnPositionTable[i], 4, 33, delay, true)
			else
				Tanari:SpawnSpiritFireWaveUnit("blackguard_cultist", spawnPositionTable[i], 4, 33, delay, true)
			end
		end
	end)
end

function fire_temple_unit_die(event)
	local unit = event.unit
	if unit.code then
		if unit.code == 0 then
			local delay = 1.1
			Tanari.FireTemple.SpiritWaveUnitsSlain = Tanari.FireTemple.SpiritWaveUnitsSlain + 1
			print(Tanari.FireTemple.SpiritWaveUnitsSlain)
			local spawnPositionTable = {Vector(11328, -12872, 274), Vector(12160, -11008, 274), Vector(13366, -12902, 297), Vector(13397, -11074, 300), Vector(15428, -12976, 364), Vector(14464, -11074)}
			if Tanari.FireTemple.SpiritWaveUnitsSlain == 22 then
				for i = 1, #spawnPositionTable, 1 do
					if i <= 1 then
						Tanari:SpawnSpiritFireWaveUnit("fire_temple_blackguard_doombringer", spawnPositionTable[i], 5, 33, delay, true)
					elseif i <= 3 then
						Tanari:SpawnSpiritFireWaveUnit("fire_temple_relic_seeker", spawnPositionTable[i], 5, 33, delay, true)
					else
						Tanari:SpawnSpiritFireWaveUnit("blackguard_cultist", spawnPositionTable[i], 5, 33, delay, true)
					end
				end
			elseif Tanari.FireTemple.SpiritWaveUnitsSlain == 50 then
				for i = 1, #spawnPositionTable, 1 do
					Tanari:SpawnSpiritFireWaveUnit("fire_temple_secret_fanatic", spawnPositionTable[i], 4, 33, delay, true)
				end
			elseif Tanari.FireTemple.SpiritWaveUnitsSlain == 66 then
				for i = 1, #spawnPositionTable, 1 do
					if i <= 3 then
						Tanari:SpawnSpiritFireWaveUnit("fire_temple_secret_fanatic", spawnPositionTable[i], 4, 33, delay, true)
					else
						Tanari:SpawnSpiritFireWaveUnit("fire_temple_tempered_warrior", spawnPositionTable[i], 4, 33, delay, true)
					end
				end
			elseif Tanari.FireTemple.SpiritWaveUnitsSlain == 90 then
				for i = 1, #spawnPositionTable, 1 do
					if i <= 3 then
						Tanari:SpawnSpiritFireWaveUnit("fire_temple_fire_mage", spawnPositionTable[i], 4, 33, delay, true)
					else
						Tanari:SpawnSpiritFireWaveUnit("fire_temple_lava_caller", spawnPositionTable[i], 4, 33, delay, true)
					end
				end
			elseif Tanari.FireTemple.SpiritWaveUnitsSlain == 114 then
				for i = 1, #spawnPositionTable, 1 do
					Tanari:SpawnSpiritFireWaveUnit("fire_temple_protective_spirit", spawnPositionTable[i], 5, 33, delay, true)
				end
			elseif Tanari.FireTemple.SpiritWaveUnitsSlain == 144 then
				for i = 1, #spawnPositionTable, 1 do
					Tanari:SpawnSpiritFireWaveUnit("fire_temple_flame_wraith", spawnPositionTable[i], 2, 33, delay, true)
				end
			elseif Tanari.FireTemple.SpiritWaveUnitsSlain == 156 then
				for i = 1, #Tanari.fireSpawnPortalTable, 1 do
					ParticleManager:DestroyParticle(Tanari.fireSpawnPortalTable[i], false)
					ParticleManager:ReleaseParticleIndex(Tanari.fireSpawnPortalTable[i])
				end
				EmitSoundOnLocationWithCaster(Vector(12288, -12150), "Tanari.FireEvent", Events.GameMaster)
				Tanari:LowerWaterTempleWall(-6, "FireSpiritWall", Vector(11112, -10632, 730), "FireTempleSpiritBlocker", Vector(11136, -10684, 600), 1000, true, false)
				Tanari:FireSpiritPortalRoom()
			end
		elseif unit.code == 1 then
			if not Tanari.FireTemple.FireSpiritThroneWaveKills then
				Tanari.FireTemple.FireSpiritThroneWaveKills = 0
			end
			Tanari.FireTemple.FireSpiritThroneWaveKills = Tanari.FireTemple.FireSpiritThroneWaveKills + 1
			if Tanari.FireTemple.FireSpiritThroneWaveKills == 8 then
				Tanari:SpawnSpiritFireWaveUnit3("tanari_fire_crab_beast", Vector(1,1), 5, 110, 2.5, false)
				Tanari:SpawnSpiritFireWaveUnit3("tanari_flame_beast", Vector(1,1), 5, 110, 2.5, false)
			elseif Tanari.FireTemple.FireSpiritThroneWaveKills == 18 then
				Tanari:SpawnSpiritFireWaveUnit3("fire_temple_protective_spirit", Vector(1,1), 5, 110, 1.5, false)
				Tanari:SpawnSpiritFireWaveUnit3("fire_temple_protective_spirit", Vector(1,1), 5, 110, 1.5, false)
			elseif Tanari.FireTemple.FireSpiritThroneWaveKills == 28 then
				Tanari:SpawnSpiritFireWaveUnit3("fire_temple_lava_caller", Vector(1,1), 5, 110, 2.5, false)
				Tanari:SpawnSpiritFireWaveUnit3("fire_temple_flame_wraith", Vector(1,1), 3, 110, 3.5, false)
			elseif Tanari.FireTemple.FireSpiritThroneWaveKills == 34 then
				Tanari:SpawnSpiritFireWaveUnit3("fire_temple_flame_shaman", Vector(1,1), 4, 110, 2.5, false)
				Tanari:SpawnSpiritFireWaveUnit3("fire_temple_flame_shaman", Vector(1,1), 4, 110, 2.5, false)
			elseif Tanari.FireTemple.FireSpiritThroneWaveKills == 41 then
				Tanari:SpawnSpiritFireWaveUnit3("tanari_lava_spectre", Vector(1,1), 4, 110, 2.5, false)
				Tanari:SpawnSpiritFireWaveUnit3("fire_temple_ogre", Vector(1,1), 4, 110, 2.5, false)
			elseif Tanari.FireTemple.FireSpiritThroneWaveKills == 49 then
				Tanari:SpawnSpiritFireWaveUnit3("tanari_flame_beast", Vector(1,1), 5, 110, 2.5, false)
				Tanari:SpawnSpiritFireWaveUnit3("tanari_flame_beast", Vector(1,1), 5, 110, 2.5, false)
			elseif Tanari.FireTemple.FireSpiritThroneWaveKills == 60 then
				local demon = Tanari:SpawnDemonWatcher(Vector(-13238, -6806), Vector(-1,0))
				Tanari:LaunchWaveUnit3(demon)
			end
		end
	end
end

function FireSpiritPortal1(trigger)
	if Tanari.FireTemple then
		if Tanari.FireTemple.SpiritPortalsActive then
			local hero = trigger.activator
			local portToVector = Vector(-13817, -14545)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
				if not Tanari.FireTemple.Portal1Activated then
					Tanari:InitPortal1Room()
				end
			end
		end
	end
end

function lava_bully_take_damage(event)
	local target = event.unit
	local attacker = event.attacker
	target.pushVector = ((target:GetAbsOrigin()-attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	if not target.pushVelocity then
		target.pushVelocity = 0
	end
	if target.big then
		target.pushVelocity = math.min(target.pushVelocity + 2.1, 25)
	else
		target.pushVelocity = math.min(target.pushVelocity + 4.2, 32)
	end
	local ability = event.ability
	ability:ApplyDataDrivenModifier(target, target, "modifier_lava_bully_pushback", {duration = 3})
end

function lava_bully_pushback_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local fv = target.pushVector

	target:SetAbsOrigin(target:GetAbsOrigin() + fv*target.pushVelocity)
	target.pushVelocity = math.max(target.pushVelocity - 1, 0)
	if target.pushVelocity <= 0.5 then
		target:RemoveModifierByName("modifier_lava_bully_pushback")
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end
	if target:HasModifier("modifier_lava_bully_drowning") then
		return false
	end
	local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), Vector(-13817, -14545))
	if distance > 880 then
		target:SetAbsOrigin(GetGroundPosition(target:GetAbsOrigin(), target))
		ability:ApplyDataDrivenModifier(target, target, "modifier_lava_bully_drowning", {})
		local particleName = "particles/addons_gameplay/small_lava_splash_blast.vpcf"
		target.pushVelocity = target.pushVelocity/2
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin()-Vector(0,0,80) )
		EmitSoundOn("Tanari.LavaSplash", target)
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Tanari.LavaBully.Death", target)
		Timers:CreateTimer(7, 
			function()
			ParticleManager:DestroyParticle( particle1, false )
		end)
	end
end

function lava_bully_drowning(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	target:SetAbsOrigin(target:GetAbsOrigin()-Vector(0,0,4))
	if not target.drowningIndex then
		target.drowningIndex = 0
	end
	target.drowningIndex = target.drowningIndex + 1
	local drownAmount = 80
	if target.big then
		drownAmount = 140
	end
	if target.drowningIndex == 40 then
		local particleName = "particles/addons_gameplay/small_lava_splash_blast.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin()-Vector(0,0,80) )
		EmitSoundOn("Tanari.LavaSplash", target)
		Timers:CreateTimer(7, 
			function()
			ParticleManager:DestroyParticle( particle1, false )
		end)
	end
	if target.drowningIndex > drownAmount then
		target:RemoveModifierByName("modifier_lava_bully_pushback")
		target:RemoveModifierByName("modifier_lava_bully_drowning")
		target:ForceKill(false)
	end
end

function lava_bully_die(event)
	if not Tanari.FireTemple.LavaBullyDeaths then
		Tanari.FireTemple.LavaBullyDeaths = 0
	end
	Tanari.FireTemple.LavaBullyDeaths = Tanari.FireTemple.LavaBullyDeaths + 1
	if Tanari.FireTemple.LavaBullyDeaths == 3 then
		Timers:CreateTimer(1.5, function()
			for i = 1, 4, 1 do
				Timers:CreateTimer(i*0.5, function()
					local centerPoint = Vector(-13817, -14545)
					local spawnPosition = centerPoint + RandomVector(RandomInt(200, 650))
					local bully = Tanari:SpawnLavaBully(spawnPosition, RandomVector(1))
					bully.jumpEnd = "lava_legion"
					bully:SetAbsOrigin(bully:GetAbsOrigin()+Vector(0,0,1000))
					WallPhysics:Jump(bully, Vector(0,0), 0, 30, 1, 1.2)
					Dungeons:AggroUnit(bully)
				end)
			end
		end)
	elseif Tanari.FireTemple.LavaBullyDeaths == 7 then
		Timers:CreateTimer(1.5, function()
			for i = 1, 5, 1 do
				Timers:CreateTimer(i*0.5, function()
					local centerPoint = Vector(-13817, -14545)
					local spawnPosition = centerPoint + RandomVector(RandomInt(200, 650))
					local bully = Tanari:SpawnLavaBully(spawnPosition, RandomVector(1))
					bully.jumpEnd = "lava_legion"
					bully:SetAbsOrigin(bully:GetAbsOrigin()+Vector(0,0,1000))
					WallPhysics:Jump(bully, Vector(0,0), 0, 30, 1, 1.2)
					Dungeons:AggroUnit(bully)
				end)
			end
		end)
	elseif Tanari.FireTemple.LavaBullyDeaths == 12 then
		Timers:CreateTimer(1.5, function()
			for i = 1, 6, 1 do
				Timers:CreateTimer(i*0.5, function()
					local centerPoint = Vector(-13817, -14545)
					local spawnPosition = centerPoint + RandomVector(RandomInt(200, 650))
					local bully = Tanari:SpawnLavaBully(spawnPosition, RandomVector(1))
					bully.jumpEnd = "lava_legion"
					bully:SetAbsOrigin(bully:GetAbsOrigin()+Vector(0,0,1000))
					WallPhysics:Jump(bully, Vector(0,0), 0, 30, 1, 1.2)
					Dungeons:AggroUnit(bully)
				end)
			end
		end)
	elseif Tanari.FireTemple.LavaBullyDeaths == 18 then
		Timers:CreateTimer(2.5, function()
			local centerPoint = Vector(-13817, -14545)
			local spawnPosition = centerPoint + RandomVector(RandomInt(200, 650))
			local bully = Tanari:SpawnLavaBullyBig(spawnPosition, RandomVector(1))
			bully.jumpEnd = "lava_legion"
			bully:SetAbsOrigin(bully:GetAbsOrigin()+Vector(0,0,1000))
			WallPhysics:Jump(bully, Vector(0,0), 0, 30, 1, 1.2)
			Dungeons:AggroUnit(bully)
			bully:SetModelScale(1.8)
			bully.big = true
		end)
	elseif Tanari.FireTemple.LavaBullyDeaths == 19 then
		Timers:CreateTimer(1, function()
			local portalPlatform = Entities:FindByNameNearest("FirePortalPlatform", Vector(-13826, -14515, 500), 1000)
			for i = 1, 30, 1 do
				Timers:CreateTimer(i*0.03, function()
					portalPlatform:SetAbsOrigin(portalPlatform:GetAbsOrigin()+Vector(0,0,50/30))
				end)
			end
			Timers:CreateTimer(0.9, function()
				EmitGlobalSound("ui.set_applied")
				Tanari.FireTemple.BullyRoomClear = true
				Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-13825, -14515, 540), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
				Tanari:CheckFireSpiritBossCondition()
			end)
		end)
	end
end

function mountain_pass_guardian_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if not target:HasModifier("modifier_jumping") and not target:HasModifier("modifier_lava_hit") then
		local point = attacker:GetAbsOrigin()
		if target:HasModifier("modifier_knockback") then
			return false
		end
		local modifierKnockback =
		{
			center_x = point.x,
			center_y = point.y,
			center_z = point.z,
			duration = 1,
			knockback_duration = 1,
			knockback_distance = 350,
			knockback_height = 200
		}     
		if attacker.big then
			modifierKnockback =
			{
				center_x = point.x,
				center_y = point.y,
				center_z = point.z,
				duration = 1,
				knockback_duration = 1,
				knockback_distance = 500,
				knockback_height = 200
			}  
		end
		target:AddNewModifier( attacker, nil, "modifier_knockback", modifierKnockback )
		EmitSoundOn("Tanari.LegionLand", attacker)
		local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
		local bonusDamage = target:GetMaxHealth()*0.05
		ApplyDamage({ victim = target, attacker = attacker, damage = bonusDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		PopupDamage(target, bonusDamage)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function FireSpiritPortal1a(trigger)
	if Tanari.FireTemple then
		if Tanari.FireTemple.BullyRoomClear then
			local hero = trigger.activator
			local portToVector = Vector(12008, -8320, 580)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
			end
		end
	end
end



function moving_platform_think(event)
	local caster = event.caster
	if caster.state == 0 then
		local newPosition = caster.platform:GetAbsOrigin() + caster.movementVector*1.6*(math.sin(caster.movementTicks*math.pi/240))
		caster.platform:SetAbsOrigin(newPosition)
		caster:SetAbsOrigin(newPosition)
		caster.movementTicks = caster.movementTicks + 1
		if caster.movementTicks >= 240 then
			caster.state = 1
			caster.movementTicks = 0
		end
	elseif caster.state == 1 then
		caster.movementTicks = caster.movementTicks + 1
		if caster.movementTicks >= 120 then
			caster.state = 2
			caster.movementTicks = 0
		end
	elseif caster.state == 2 then
		local newPosition = caster.platform:GetAbsOrigin() - caster.movementVector*1.6*(math.sin(caster.movementTicks*math.pi/240))
		caster.platform:SetAbsOrigin(newPosition)
		caster:SetAbsOrigin(newPosition)
		caster.movementTicks = caster.movementTicks + 1
		if caster.movementTicks >= 240 then
			caster.state = 3
			caster.movementTicks = 0
		end
	elseif caster.state == 3 then
		caster.movementTicks = caster.movementTicks + 1
		if caster.movementTicks >= 120 then
			caster.state = 0
			caster.movementTicks = 0
		end
	end
end

function unit_on_moving_platform_think(event)
	local caster = event.caster
	if IsValidEntity(caster) then
		local platform = caster.platform
		local target = event.target
		if target:GetUnitName() == "npc_dummy_unit" then
			return false
		end
		if caster.state == 0 then
			target:SetAbsOrigin(target:GetAbsOrigin()+caster.movementVector*1.6*(math.sin(caster.movementTicks*math.pi/240)))
		elseif caster.state == 2 then
			target:SetAbsOrigin(target:GetAbsOrigin()-caster.movementVector*1.6*(math.sin(caster.movementTicks*math.pi/240)))
		end
	end
end

function unit_on_platform_moving_end(event)
	local caster = event.caster
	local target = event.target
	local trigger = Entities:FindByNameNearest("Lava5", Vector(-14352, -7168, 387), 800)
	if trigger:IsTouching(target) then
		if not target:HasModifier("modifier_moving_platform_active") then
			local ability = Events.GameMaster:FindAbilityByName("npc_abilities")
			local hero = target
			if hero:HasModifier("modifier_rpc_terrasic_lava_boots") then
				hero.foot:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rpc_terrasic_lava_boot_effect", {duration = 7})
				return false
			end
			EmitSoundOn("Env.LavaHit", hero)
			StartAnimation(hero, {duration=4, activity=ACT_DOTA_FLAIL, rate=1.4})
				hero:RemoveModifierByName("modifier_lava_jumping")
				Timers:CreateTimer(0.03, function()
					LavaJump(hero, hero:GetForwardVector(), RandomInt(10, 13), 27, 25, 1)
					ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_lava_flailing", {duration = 4})
				end)
			print("LaVA TOUCH!------------")
			ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_lava_hit", {duration = 4})
			print("TOUCHING LAVA!!")
		end
	end
end

function LavaJump(unit, forwardVector, propulsion, liftForce, liftDuration, gravity)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_lava_jumping"
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, jumpingModifier, {duration = 5})
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03*i, function()
			if IsValidEntity(unit) then
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)
				local obstruction = WallPhysics:FindNearestObstruction(newPosition*Vector(1,1,0))
				local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPosition)*Vector(1,1,0), unit)
				if not blockUnit then
					if GetGroundPosition(newPosition, unit).z > currentPosition.z + 180 then
						newPosition = newPosition-(forwardVector*propulsion)
					end
				else
					newPosition = newPosition-(forwardVector*propulsion)
				end
				unit:SetOrigin(newPosition)
			end
		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03*liftDuration+0.03, function()
		Timers:CreateTimer(0.03*fallLoop, function()
			if IsValidEntity(unit) then
				fallLoop = fallLoop + 1
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity)

				local obstruction = WallPhysics:FindNearestObstruction(newPosition*Vector(1,1,0))
				local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPosition)*Vector(1,1,0), unit)
				if not blockUnit then
					if GetGroundPosition(newPosition, unit).z > currentPosition.z + 180 then
						newPosition = newPosition-(forwardVector*propulsion)
					end
				else
					newPosition = newPosition-(forwardVector*propulsion)
				end
				unit:SetOrigin(newPosition)
				-- print("NEWPOSITION.Z:")
				-- print(newPosition.z)

				if newPosition.z - GetGroundPosition(newPosition, unit).z < 10 then
					print("z1")
					unit:RemoveModifierByName(jumpingModifier)
					FindClearSpaceForUnit(unit, newPosition, false)
					WallPhysics:UnitLand(unit)
					unit:RemoveModifierByName("modifier_lava_jumping")
					print (currentPosition.z)
					if (currentPosition.z <= 252) then
						local triggerTable = {}
						triggerTable.activator = unit
						EnterLava(triggerTable)
					end
				elseif newPosition.z <= 252 then
					print("z2")
					unit:RemoveModifierByName(jumpingModifier)
					-- FindClearSpaceForUnit(unit, newPosition, false)
					WallPhysics:UnitLand(unit)
					local triggerTable = {}
					triggerTable.activator = unit
					EnterLava(triggerTable)
				else
					return 0.03
				end
			end
		end)
	end)
end

function lava_skin_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	if ability:GetCooldownTimeRemaining() <= 0.01 then
		local info = 
		{
			Target = attacker,
			Source = caster,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
			StartPosition = "attach_attack1",
			bDrawsOnMinimap = false, 
		        bDodgeable = true,
		        bIsAttack = false, 
		        bVisibleToEnemies = true,
		        bReplaceExisting = false,
		        flExpireTime = GameRules:GetGameTime() + 5,
			bProvidesVision = false,
			iVisionRadius = 0,
			iMoveSpeed = 1500,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
		ability:StartCooldown(0.15)
	end
end

function fire_siege_hulker_die(event)
	local caster = event.caster
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		for i = 1, #Tanari.FireTemple.MovingPlatformTable, 1 do
			Tanari:CreateLavaBlast(Tanari.FireTemple.MovingPlatformTable[i].platform:GetAbsOrigin())
			for j = 1, 40, 1 do
				Timers:CreateTimer(j*0.03, function()
					Tanari.FireTemple.MovingPlatformTable[i].platform:SetAbsOrigin(Tanari.FireTemple.MovingPlatformTable[i].platform:GetAbsOrigin()-Vector(0,0,5))
				end)
			end
			Timers:CreateTimer(1.3, function()
				Tanari.FireTemple.MovingPlatformTable[i]:RemoveModifierByName("modifier_moving_platform_passive")
				UTIL_Remove(Tanari.FireTemple.MovingPlatformTable[i].platform)
				UTIL_Remove(Tanari.FireTemple.MovingPlatformTable[i])
			end)
		end
		Timers:CreateTimer(1, function()
			EmitGlobalSound("ui.set_applied")
			Tanari.FireTemple.Room2Clear = true
			Tanari:CheckFireSpiritBossCondition()
			AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-12160, -6161, 500), 400, 1200, false)
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-12160, -6161, 500), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-12403, -12028, 500), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		end)
	end
end

function FireSpiritPortal2(trigger)
	if Tanari.FireTemple then
		if Tanari.FireTemple.SpiritPortalsActive then
			local hero = trigger.activator
			local portToVector = Vector(-12400, -12009)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
				if not Tanari.FireTemple.Portal2Activated then
					Tanari.FireTemple.Portal2Activated = true
					Tanari:InitPortal2Room()
				end
			end
		end
	end
end

function FireSpiritPortal2a(trigger)
	if Tanari.FireTemple then
		if Tanari.FireTemple.Room2Clear then
			local hero = trigger.activator
			local portToVector = Vector(13568, -8314, 580)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
			end
		end
	end
end

function FireSpiritPortal2b(trigger)
	if Tanari.FireTemple then
		if Tanari.FireTemple.Room2Clear then
			local hero = trigger.activator
			local portToVector = Vector(13568, -8314, 580)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
			end
		end
	end
end

function FireSpiritPortal3(trigger)
	if Tanari.FireTemple then
		if Tanari.FireTemple.SpiritPortalsActive then
			local hero = trigger.activator
			local portToVector = Vector(-15926, -6808)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
				if not Tanari.FireTemple.Portal3Activated then
					Tanari.FireTemple.Portal3Activated = true
					Tanari:InitPortal3Room()
				end
			end
		end
	end
end

function demon_watcher_think(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()
	for i = 1, 7, 1 do
		local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/7)
		fire_temple_flame_ring_projectile(ability, caster, fv)
	end
end

function fire_temple_demon_watcher_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Tanari.FlameWatcher.Death", caster)
	Timers:CreateTimer(2, function()
		EmitGlobalSound("ui.set_applied")
		Tanari.FireTemple.Room3Clear = true
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-15925, -6808, 410), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		Tanari:CheckFireSpiritBossCondition()
	end)
end

function FireSpiritPortal3a(trigger)
	if Tanari.FireTemple then
		if Tanari.FireTemple.Room3Clear then
			local hero = trigger.activator
			local portToVector = Vector(15104, -8314, 380)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
			end
		end
	end
end

function FireSpiritPortal4(trigger)
	if Tanari.FireTemple then
		if Tanari.FireTemple.FinalFireBossPortal then
			local hero = trigger.activator
			local portToVector = Vector(-13786, -3840)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
				if not Tanari.FireTemple.Portal4Activated then
					Tanari.FireTemple.Portal4Activated = true
					Tanari:InitSpiritFireBossRoom()
				end
			end
		end
	end
end

function fire_spirit_boss_battle_start(event)
	local caster = event.caster
	caster:RemoveModifierByName("modifier_fire_spirit_boss_waiting")
	EmitSoundOn("Tanari.FireSpiritBoss.Aggro", caster)
	caster:SetAcquisitionRange(4000)
	Timers:CreateTimer(2, function()
		EmitSoundOnLocationWithCaster(Vector(-13632, -3072), "Tanari.FireSpiritBoss.Music", Events.GameMaster)
		if not Tanari.FireSpiritBossDead then
			return 50
		end
	end)
end

function fire_spirit_boss_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_spirit_boss_burn", {duration = 5})
	local newStacks = attacker:GetModifierStackCount("modifier_spirit_boss_burn", caster) + 1
	attacker:SetModifierStackCount("modifier_spirit_boss_burn", caster, newStacks)
end

function fire_spirit_boss_burn_damage(event)
	local target = event.target
	local burn_damage = event.burn_damage
	local ability = event.ability
	local caster = event.caster
	local stacks = target:GetModifierStackCount("modifier_spirit_boss_burn", caster)
	ApplyDamage({ victim = target, attacker = caster, damage = burn_damage*stacks, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
end

function fire_breath_start(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_breathing", {duration = 3})
	StartAnimation(caster, {duration=3, activity=ACT_DOTA_CAST_ABILITY_1, rate=1}) 
	EmitSoundOn("Tanari.FireSpiritBoss.BreatheFireStart", caster)
	local lengthBonus = (1-(caster:GetHealth()/caster:GetMaxHealth()))*2000 + 300
	local fv = caster:GetForwardVector()
	Timers:CreateTimer(1.3, function()
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.FireSpiritBoss.BreatheFire", caster)
		for i = -10, 5, 1 do
			Timers:CreateTimer((i+10)*0.1, function()
				local rotatedFV = WallPhysics:rotateVector(fv, 2*math.pi*i/60)
				fire_temple_fire_breath_projectile(ability, caster, rotatedFV, lengthBonus)
			end)
		end
	end)
end

function fire_temple_fire_breath_projectile(ability, caster, fv, length)
	local start_radius = 120
	local end_radius = 200
	local range = 360 + length
	local speed = 600 + length

	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = caster:GetAbsOrigin()+fv*100+Vector(0,0,150),
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


function fire_spirit_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_fire_spirit_boss_waiting") then
		return false
	end
	if caster.dying then
		return false
	end
	if caster:GetHealth() < 1000 then
		caster.dying = true
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spirit_boss_dying", {})
	end
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	local fireAbility = caster:FindAbilityByName("fire_spirit_breath")
	if fireAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = fireAbility:entindex(),
					Position = enemies[1]:GetAbsOrigin()
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			return false
		end
	end
	local modulos = 50
	if caster:GetHealth()/caster:GetMaxHealth() < 0.9 then
		modulos = 40
	elseif caster:GetHealth()/caster:GetMaxHealth() < 0.8 then
		modulos = 35
	elseif caster:GetHealth()/caster:GetMaxHealth() < 0.7 then
		modulos = 30
	elseif caster:GetHealth()/caster:GetMaxHealth() < 0.6 then
		modulos = 25
	elseif caster:GetHealth()/caster:GetMaxHealth() < 0.5 then
		modulos = 20
	elseif caster:GetHealth()/caster:GetMaxHealth() < 0.4 then
		modulos = 15
	elseif caster:GetHealth()/caster:GetMaxHealth() < 0.3 then
		modulos = 10
	end
	if not caster:HasModifier("modifier_spirit_boss_enrage") then
		if caster:GetHealth() < caster:GetMaxHealth()*0.5 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_boss_enrage", {})
			caster:AddNewModifier( caster, nil, 'modifier_movespeed_cap_sonic', {} )
			EmitSoundOn("Tanari.FireSpiritBoss.Enrage", caster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.FireSpiritBoss.EnrageBlast", caster)
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=1})
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", caster, 8) 
		end
	else
		if caster.interval%7 == 0 then
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", caster, 8) 
		end
	end
	local inferno = caster:FindAbilityByName("fire_temple_inferno2")
	if caster.interval%modulos == 0 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = inferno:entindex(),
					Position = enemies[1]:GetAbsOrigin()
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			return false
		end		
	end
	if caster.interval > 100 then
		caster.interval = 0
	end
end

function fire_temple_spirit_boss_die_begin(event)
	Statistics.dispatch("tanari_jungle:kill:fire_spirit");
	local ability = event.ability
	local caster = event.caster
	Tanari.WaterSpiritBossDead = true
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Tanari.FireSpiritBoss.Enrage", caster)
	end)

	local bossOrigin = caster:GetAbsOrigin()
	for i = 1, 12, 1 do
		Timers:CreateTimer(0.5*i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	Timers:CreateTimer(3, function()
	  	local itemName = "item_tanari_spirit_stones_"..Tanari:ConvertDifficultyNumberToName(GameState:GetDifficultyFactor())
	  	print(itemName)
	    local stones = RPCItems:CreateConsumable(itemName, "immortal", "tanari_spirit_stones", "consumable", false, "Consumable", itemName.."_desc")
	    CreateItemOnPositionSync(bossOrigin, stones)
	    stones:LaunchLoot(false, RandomInt(100,600), 0.75, bossOrigin)
	    print("STONES DROPPED")

	    local luck = RandomInt(1,3)
	    if luck == 1 then
	    	RPCItems:RollBlazingFuryArmor(bossOrigin)
	    elseif luck == 2 then
	    	RPCItems:RollDemonfireGauntlet(bossOrigin)
	    elseif luck == 3 then
	    	RPCItems:RollBurningSpiritHelmet(bossOrigin)
	    end
	end)
	Timers:CreateTimer(4, function()
		local maxRoll = 200
		if GameState:GetDifficultyFactor() == 3 then
			maxRoll = 130
		end
		local requirement = 2 + GameState:GetPlayerPremiumStatusCount()
		local luck = RandomInt(1, maxRoll)
		if luck <= requirement then
			RPCItems:RollSpiritWarriorArcana2(bossOrigin)
		end
	end)
	Timers:CreateTimer(8, function()
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {})
		caster:RemoveModifierByName("modifier_wind_temple_boss_dying")
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=8, activity=ACT_DOTA_DIE, rate=1})
			EmitSoundOn("Tanari.FireSpiritBoss.Enrage", caster)
			for i = 1, 120, 1 do
				Timers:CreateTimer(i*0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-5))
					end
					if i%30 == 1 then
						Tanari:CreateLavaBlast(bossOrigin)
					end
				end)
			end
			Timers:CreateTimer(6, function()
				UTIL_Remove(caster)
				Tanari:DefeatSpiritBoss("fire", bossOrigin)
				EmitGlobalSound("ui.set_applied")
				Tanari.FireSpiritBossDead = true
				Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-13782, -3845, 440), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			end)
		end)
	end)
end

function FireSpiritPortal4a(trigger)
	if Tanari.FireTemple then
		if Tanari.FireSpiritBossDead then
			local hero = trigger.activator
			local portToVector = Vector(9024, -15296, 380)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
			end
		end
	end
end
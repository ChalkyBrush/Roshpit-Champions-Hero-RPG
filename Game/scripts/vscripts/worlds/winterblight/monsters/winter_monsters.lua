function winter_spawner_think(event)
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
	StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.9})
	EmitSoundOn("Winterblight.SpawnerSquish", caster)
	Timers:CreateTimer(1.3, function()
		for i = 1, loops, 1 do
			local position = caster.summonCenter + RandomVector(RandomInt(1, 240))
			local zombie = Winterblight:SpawnSpawnerUnit(caster:GetAbsOrigin(), RandomVector(1), itemRoll, bAggro)
			zombie:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,100)+caster:GetForwardVector()*40)
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*(RandomInt(-10,10))/100)
			WallPhysics:Jump(zombie,fv, RandomInt(4, 16), RandomInt(10, 16), RandomInt(16, 24), 1)
			zombie.jumpEnd = "crab_land"
			if caster.totalSummons > 12 then
				zombie:SetDeathXP(0)
				zombie:SetMaximumGoldBounty(0)
				zombie:SetMinimumGoldBounty(0)
			end
			EmitSoundOn("Winterblight.Crab.Spawn", zombie)
			FindClearSpaceForUnit(zombie, zombie:GetAbsOrigin(), false)
			table.insert(caster.summonTable, zombie)
		end
	end)
end

function winter_spawner_die(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite_snow_explode.vpcf", caster, 3)
end

function ogre_armor_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	if not caster.hits then
		caster.hits = 0
	end
	if not caster.pfxCount then
		caster.pfxCount = 0
	end
	if caster.pfxCount < 6 then
		caster.pfxCount = caster.pfxCount + 1
		CustomAbilities:QuickAttachParticle("particles/neutral_fx/ogre_magi_frost_armor_b.vpcf", caster, 0.5)
		Timers:CreateTimer(1, function()
			caster.pfxCount = caster.pfxCount - 1
		end)
	end
	caster.hits = caster.hits + 1
	if caster.hits == event.hits_for_counter then
		caster.hits = 0
		EmitSoundOn("Winterblight.OgreShield.Launch", caster)
		local fv = ((attacker:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local info = 
		{
				Ability = ability,
	        	EffectName = "particles/roshpit/winterblight/ogre_retaliation.vpcf",
	        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,50),
	        	fDistance = 1500,
	        	fStartRadius = 150,
	        	fEndRadius = 300,
	        	Source = caster,
	        	StartPosition = "attach_attack1",
	        	bHasFrontalCone = true,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * 1000,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function ogre_armor_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.OgreArmorImpact", target)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	Filters:ApplyStun(caster, event.stun_duration, target)	
end

function monolith_found_enemy(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not caster.activated then
		EmitSoundOn("Winterblight.Monolith.Detect", caster)
		caster.actived = true
		Winterblight:smoothColorTransition(caster, Vector(255,255,255), Vector(200,200,255), 20)
		Timers:CreateTimer(0.6, function()
			Winterblight:objectShake(caster, 80, 5.2, true, false, false, "Winterblight.Monolith.Shake", 10)
			Timers:CreateTimer(3.05, function()
				 CustomAbilities:QuickParticleAtPoint("particles/world_tower/tower_upgrade/ti7_radiant_tower_lvl2_dest.vpcf", caster:GetAbsOrigin(), 6)
				 local raxxus = Winterblight:SpawnRaxxus(caster:GetAbsOrigin(), caster:GetForwardVector())
				 raxxusAbility = raxxus:FindAbilityByName("winterblight_raxxus_passive")
				 raxxusAbility:ApplyDataDrivenModifier(raxxus, raxxus, "modifier_disable_player", {duration = 2.4})
				 StartAnimation(raxxus, {duration=2.4, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.9})
				 EmitSoundOn("Winterblight.Monolith.Dest", caster)
				 caster.aggroLock = true
				 for i = 0, 3, 1 do
				 	local position = caster:GetAbsOrigin()
				 	Timers:CreateTimer(0.1*i, function()
						local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,80))
						ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
						ParticleManager:SetParticleControl(pfx, 2, Vector(0.8,0.8,0.8))
						Timers:CreateTimer(10, function() 
						  ParticleManager:DestroyParticle( pfx, false )
						  ParticleManager:ReleaseParticleIndex(pfx)
						end)
					end)
				 end
				 Timers:CreateTimer(2.4, function()
				 	caster.aggroLock = false
				 	Dungeons:AggroUnit(raxxus)
				 end)
				 Timers:CreateTimer(0.1, function()
				 	EmitSoundOn("Winterblight.Raxxus.Intro", raxxus)
				 	UTIL_Remove(caster)
				 end)
			end)
		end)
	end
end

function raxxus_attack_land(event)
	local caster = event.caster
	local victim = event.target
	local ability = event.ability
	local damage = event.damage
    local icePoint = victim:GetAbsOrigin()
    local radius = 240
    EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
    local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
    local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
    ParticleManager:SetParticleControl( pfx, 0, icePoint )
    ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
    Timers:CreateTimer(2.5, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then    
        for _,enemy in pairs(enemies) do
            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frostburn_gauntlets_slow", {duration = 3})
            ApplyDamage({ victim = victim, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
        end
    end
end

function jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1]
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance/20
	ability.liftVelocity = 20
	local heightDiff = 0
	ability.liftVelocity = ability.liftVelocity - heightDiff/20
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	ability.interval = 0
	if not event.special then
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1})
		EmitSoundOn("Winterblight.Assassin.Aggro", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Assassin.Jump", caster)
		if caster:HasModifier("modifier_machinal_jump_freecast") then
			ability:EndCooldown()
			local newStacks = caster:GetModifierStackCount("modifier_machinal_jump_freecast", caster) - 1
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_machinal_jump_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_machinal_jump_freecast")
			end
		end
		if caster:HasAbility("arkimus_energy_field") then
			local energyField = caster:FindAbilityByName("arkimus_energy_field")
			if energyField.rotationDelta then
				energyField.rotationDelta = math.max(14, energyField.rotationDelta - 4)
			end
		end
	end
	ability.a_c_level = 0
	ability.c_c_level = 0
end

function jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV
	-- if distance < 60 then
	-- 	fv = Vector(0,0)
	-- end
	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
		print(height)
		if not ability.rising then
			caster:RemoveModifierByName("modifier_machinal_jump")
		end
	end

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*30), caster)
	if blockUnit then
		fv = Vector(0,0)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + fv*ability.jumpVelocity + Vector(0,0,ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 2
	if ability.liftVelocity <= 0 then
		ability.rising = false
	end
	ability.interval = ability.interval + 1
	if ability.interval%3 == 0 then
		local pfx = ParticleManager:CreateParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(0.4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function jump_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
	if ability.a_c_level > 0 then
		local searchRadius = 300 + ability.a_c_level*2
		local damage = caster:GetAverageTrueAttackDamage(caster)*0.3*ability.a_c_level

	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #enemies > 0 then
	        for _,enemy in pairs(enemies) do
	        	CreateZonisBeam(caster:GetAbsOrigin(), enemy:GetAbsOrigin()+Vector(0,0,50))
	        	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zonis_stun", {duration = 0.2})
	        	Filters:ApplyStun(caster, 0.2, enemy)
	        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_ARCANE, RPC_ELEMENT_LIGHTNING)
	        end
	    else
	    	for i = 1, 3, 1 do
	    		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/3)
	    		CreateZonisBeam(caster:GetAbsOrigin(), caster:GetAbsOrigin()+fv*120+Vector(0,0,60))
	    	end
	    end 
	    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.JumpLightning", caster)
	end
	if ability.c_c_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump_c_c_amp", {duration = duration})
		caster:SetModifierStackCount("modifier_machinal_jump_c_c_amp", caster, ability.c_c_level)
	end
end

function mountain_assassin_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local jumpAbility = caster:FindAbilityByName("assassin_jump")
		if jumpAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				local targetPoint = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(60, 320))	
				
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = jumpAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		if not caster:HasModifier("modifier_machinal_jump") then
			if caster:HasAbility("assassin_charge_blast") then
				local chargeBlast = caster:FindAbilityByName("assassin_charge_blast")
				if chargeBlast:IsFullyCastable() then
					local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
					if #enemies > 0 then
						local targetPoint = enemies[1]:GetAbsOrigin()
						caster.lockOnTarget = enemies[1]
						local order =
						{
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							AbilityIndex = chargeBlast:entindex(),
							Position = targetPoint
						}
						ExecuteOrderFromTable(order)
						return false
					end
				end
			end
		end
	end

end

function mountain_assassin_init(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local chargeBlast = caster:FindAbilityByName("assassin_charge_blast")
		chargeBlast:StartCooldown(7)
		if GameState:GetDifficultyFactor() == 1 then
			caster:RemoveAbility("assassin_charge_blast")
		end
	end
end

function begin_mystic_wave(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = event.range

	StartAnimation(caster, {duration=1.4, activity=ACT_DOTA_ATTACK, rate=0.9})
	EmitSoundOn("Winterblight.Assassin.CastVO", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Assassin.Projectile", caster)
	local fv = caster:GetForwardVector()
	local startPoint = caster:GetAbsOrigin()
	local particle = "particles/base_attacks/majinaq_linear.vpcf"
	local start_radius = 340
	local end_radius = 340
	local range = range


	local speed = 900

	-- EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)
	
	local casterOrigin = caster:GetAbsOrigin()

	local info = 
	{
			Ability = ability,
        	EffectName = particle,
        	vSpawnOrigin = startPoint+Vector(0,0,80),
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
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)	

	local a_a_duration = 3
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_protector_a_a_buff", {duration = a_a_duration})
end

function mystic_wave_impact(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local baseDamage = damage
	local ability = event.ability
	local stunDuration = 0.5


	local damage = baseDamage
	if target:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_mystic_wave_flail", {duration = stunDuration})
		Filters:ApplyStun(caster, stunDuration, target)
		local particleName = "particles/econ/events/winter_major_2017/dagon_wm07.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, target )
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(1.0, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
		local manaBurn = math.min(event.mana_burn, target:GetMana())
		target:ReduceMana(manaBurn)
		damage = damage + manaBurn
		EmitSoundOn("Winterblight.Assassin.ManaBurn", target)
		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	end

	
end

function mystic_wave_phase_start(event)
	local caster = event.caster
	local ability = event.ability
	-- EmitSoundOn("Winterblight.Assassin.Aggro", caster)
end

function mystic_wave_casting_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lockOnTarget then
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.lockOnTarget:GetAbsOrigin())
		if distance < 1500 then
			local fv = ((caster.lockOnTarget:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			caster:SetForwardVector(fv)
		end
	end
end

function beetle_underground_think(event)
	local caster = event.caster
	if caster.aggro then
	    local particleName = "particles/roshpit/winterblight/snow_impact.vpcf"
	    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
	    ParticleManager:SetParticleControl(particle1,0,caster:GetAbsOrigin())
	    Timers:CreateTimer(1, function()
	    	ParticleManager:DestroyParticle( particle1, false )
	    end)
      	Timers:CreateTimer(0.03, function()
      		EmitSoundOn("Winterblight.MountainBeetle.Unburrow", caster)
      	end)
      	caster:RemoveModifierByName("modifier_ice_beast_ai")
		caster:RemoveModifierByName("modifier_cave_shroom_ai")
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shroom_jumping", {duration = 0.74})
		local position = caster:GetAbsOrigin()
		caster.liftVelocity = 21
		for i = 1, 28, 1 do
			Timers:CreateTimer(0.03*i, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,caster.liftVelocity))
				caster.liftVelocity = caster.liftVelocity - 1.5
			end)
		end
		Timers:CreateTimer(0.84, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end
end

function ice_crystal_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.strikes then
		caster.strikes = 0
	end
	if caster.strikes >= 3 then
		return false
	end
	caster.strikes = caster.strikes + 1
	caster:SetRenderColor(caster.startingBlue-caster.strikes*20, caster.startingBlue-caster.strikes*20, 255)
	CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/mark_of_the_talon_heal.vpcf", caster, 0.3)
	EmitSoundOn("Winterblight.IceCrystal.Hit", caster)
	if caster.strikes == 3 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_attackable_unit_no_more_attacks", {})
		Winterblight:objectShake(caster, 15, 15, true, true, true, nil, 4)
		Timers:CreateTimer(0.5, function()
		    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
		    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )

		    ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
		    ParticleManager:SetParticleControl( particle1, 1, Vector(300, 2, 1000) )
		    ParticleManager:SetParticleControl( particle1, 3, Vector(300, 550, 550) )
		    Timers:CreateTimer(4, function()
		    	ParticleManager:DestroyParticle(particle1, false)
		    end)
		    CustomAbilities:QuickAttachParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_c_ti5.vpcf", caster, 2)
			local position = caster:GetAbsOrigin()
			EmitSoundOn("Winterblight.IceCrystal.Shatter", caster)
			for i = 1, 6, 1 do
				local spawnPos = position + WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/8)*8
				local ice = Winterblight:SpawnLivingIce(position, (spawnPos-position):Normalized())
			    local particleName = "particles/roshpit/winterblight/snow_impact.vpcf"
			    local snowparticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, nil)
			    ParticleManager:SetParticleControl(snowparticle,0,ice:GetAbsOrigin())
			    Timers:CreateTimer(1, function()
			    	ParticleManager:DestroyParticle( snowparticle, false )
			    end)
				EmitSoundOn("Winterblight.IceCrystal.Spawn", ice)
				StartAnimation(ice, {duration=1, activity=ACT_DOTA_SPAWN, rate=1.4})
				local iceAbil = ice:FindAbilityByName("winterblight_ice_magic_immune_ability")
				local iceImmuneDuration = 1 + 0.3*GameState:GetDifficultyFactor()
				iceAbil:ApplyDataDrivenModifier(ice, ice, "modifier_black_King_bar_immunity", {duration = iceImmuneDuration})
				if GameState:GetDifficultyFactor() >= 3 then
					local luck = RandomInt(1, 8)
					if luck == 1 then
						ice:AddAbility("creature_pure_strike"):SetLevel(GameState:GetDifficultyFactor())
					end
				end
			end
			if not Winterblight.IceShatters then
				Winterblight.IceShatters = 0
			end
			Winterblight.IceShatters = Winterblight.IceShatters + 1
			UTIL_Remove(caster)
			if Winterblight.IceShatters == 18 then
				Winterblight:ShatterIceWall()
			end
		end)
	end
end

function crystal_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = RandomInt(0, 89)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,5)*math.cos(2*math.pi*caster.interval/90))
	caster.interval = caster.interval + 1
	local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/90)
	caster:SetForwardVector(rotatedFV)
	if caster.interval == 90 then
		caster.interval = 0 
	end
end

function volcanic_glissade(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]
	
	ability.targetPoint = target
	EmitSoundOn("Winterblight.MountainDweller.Charge", caster)
	EmitSoundOn("Winterblight.MountainGlissade", caster)
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_VERSUS, rate=2})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_volcanic_glissade", {duration = 1.6})
    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )

    ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( particle1, 1, Vector(200, 2, 1000) )
    ParticleManager:SetParticleControl( particle1, 3, Vector(200, 550, 550) )
    Timers:CreateTimer(4, function()
    	ParticleManager:DestroyParticle(particle1, false)
    end)
	if ability.beamPFX then
		ParticleManager:DestroyParticle(ability.beamPFX, false)
	end	
	ability.beamPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(ability.beamPFX, 0, caster:GetAbsOrigin()+Vector(0,0,90))
	Filters:CastSkillArguments(3, caster)
	local glyphFreeCast = false
	local luck = RandomInt(1, 5-GameState:GetDifficultyFactor())
	if luck == 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_glissade_freecast", {})
		caster:SetModifierStackCount("modifier_glissade_freecast", caster, 1)
	end
	if caster:HasModifier("modifier_glissade_freecast") then
		if not glyphFreeCast then
			local newStacks = caster:GetModifierStackCount("modifier_glissade_freecast", caster) - 1
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_glissade_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_glissade_freecast")
			end
		end
		ability:EndCooldown()
	else
		if not glyphFreeCast then

		else
			ability:EndCooldown()
		end
	end
end

function glissade_thinking(event)
	local ability = event.ability
	local caster = event.caster

	local movementVector = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,1)):Normalized()
	local movespeed = 60

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+caster:GetForwardVector()*movespeed), caster)
	if blockUnit then
		movespeed = 0
	end	
	caster:SetAbsOrigin(caster:GetAbsOrigin() + movementVector*movespeed)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), ability.targetPoint)
	if ability.beamPFX then
		ParticleManager:SetParticleControl(ability.beamPFX, 1, caster:GetAbsOrigin()+Vector(0,0,90))
	end
	if distance <= 60 or blockUnit then
		caster:RemoveModifierByName("modifier_volcanic_glissade")
		EndAnimation(caster)
	    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )

	    ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
	    ParticleManager:SetParticleControl( particle1, 1, Vector(200, 2, 1000) )
	    ParticleManager:SetParticleControl( particle1, 3, Vector(200, 550, 550) )
	    Timers:CreateTimer(4, function()
	    	ParticleManager:DestroyParticle(particle1, false)
	    end)
	    EmitSoundOn("Winterblight.MountainGlissade.End", caster)
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		Timers:CreateTimer(0.06, function()
			if ability.beamPFX then
				local destroyPFX = ability.beamPFX
				ability.beamPFX = false
				Timers:CreateTimer(0.5, function()
					ParticleManager:DestroyParticle(destroyPFX, false)
				end)
			end
		end)
	end
	
end

function mountain_dweller_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.regenLock then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_dweller_regen", {})
	end

	caster.regenLock = false
	if caster.aggro then
		local castAbility = caster:FindAbilityByName("mountain_glissade")
		if caster.castLock then
			return false
		end
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(0, 500))
				if caster:GetHealth() < caster:GetMaxHealth()*0.35 then
					castPoint = caster:GetAbsOrigin() + (((caster:GetAbsOrigin()-enemies[1]:GetAbsOrigin())*Vector(1,1,0)):Normalized())*RandomInt(300, 800)
				end
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = castAbility:entindex(),
						Position = castPoint
				 	}
				 
				ExecuteOrderFromTable(newOrder)			
			end
		end
	end
end

function mountain_dweller_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	caster.regenLock = true
	caster:RemoveModifierByName("modifier_mountain_dweller_regen")
end

function frostiok_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false )
    if #enemies > 0 then    
    	EmitSoundOn("Winterblight.Frostiok.Passive", caster)
        for _,enemy in pairs(enemies) do
				local info = 
				{
					Target = enemy,
					Source = caster,
					Ability = ability,	
					EffectName =  "particles/units/heroes/hero_winter_wyvern/wyvern_splinter.vpcf",
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

function frostiok_ice_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Winterblight.Frostiok.PassiveImpact", target)
	local damage = event.damage
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })

	ability:ApplyDataDrivenModifier(caster, target, "modifier_frostiok_damage_amp", {duration = 6})

	local buff = target:FindModifierByName("modifier_frostiok_damage_amp")
	local newStacks = target:GetModifierStackCount("modifier_frostiok_damage_amp", buff:GetCaster()) + 1
	target:SetModifierStackCount("modifier_frostiok_damage_amp", buff:GetCaster(), newStacks)
end

function colossus_slam_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.ChillingColossus.WindUp", caster)
	StartAnimation(caster, {duration=1.6, activity=ACT_DOTA_CAST_ABILITY_5, rate=0.9})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_barnacle_ground_slam", {duration = 1.6})
	Timers:CreateTimer(0.6, function()
		local position = caster:GetAbsOrigin() + caster:GetForwardVector()*210
		local radius = 540
		local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
		local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, position )
		ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
		EmitSoundOn("Winterblight.ChillingColossus.Slam", caster)
		ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
		-- FindClearSpaceForUnit(caster, position, false)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })	
				enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 1.5})
			end
		end 
	end)
end

function frost_colossus_init(event)
	local caster = event.caster
	local ability = event.ability
	local stacks = event.stacks
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_frostiok_immunity_stacks", {})
	caster:SetModifierStackCount("modifier_frostiok_immunity_stacks", caster, stacks)

end

function colossus_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_colossus_restore") then
		return false
	end
	if caster:GetHealth() < 2000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_colossus_restore", {duration = 7})
		EmitSoundOn("Winterblight.Restore", caster)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_borealis.vpcf", caster, 3)
		local newStacks = caster:GetModifierStackCount("modifier_frostiok_immunity_stacks", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_frostiok_immunity_stacks", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_frostiok_immunity_stacks")
		end
	end
end

function colossus_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.Colossus.Death", caster)
end

function purging_ice_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.Norgok.PurgingBoltHit", target)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })	

	local modifiers = target:FindAllModifiers()
	for i = 1, #modifiers, 1 do
		local modifier = modifiers[i]
		local modifierMaker = modifier:GetCaster()
		if modifierMaker:GetEntityIndex() == target:GetEntityIndex() or modifierMaker:GetEntityIndex() == target.InventoryUnit:GetEntityIndex() then
			local durationRemaining = modifier:GetRemainingTime()
			if durationRemaining > 0 then
				target:RemoveModifierByName(modifier:GetName())
			end
		end
	end
end

function norgok_think(event)
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_luna/luna_lucent_beam_impact_shared.vpcf"
	local damage = event.damage
	if not caster:IsAlive() then
		return false
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if not ability.interval then
		ability.interval = 0
	end
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_luna/luna_lucent_beam_impact_shared.vpcf", enemy, 0.5)
			ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin())
			EmitSoundOn("Winterblight.Norgok.PassiveHit", enemy)
		end
	end
	ability.interval = ability.interval + 1
	if caster.aggro then
		if ability.interval > 120 then
			ability.interval = 0
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chieftain_buff", {duration = 5})
		end 
	end
end

function norgok_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.Norgok.Die", caster)
end

function iceSprintStart(event)
	local caster = event.caster
	local ability = event.ability
	ability.forwardVec = caster:GetForwardVector()
	ability.interval = 0
	StartAnimation(caster, {duration=event.duration, activity=ACT_DOTA_RUN, rate=1.2, translate="haste"})
	-- rune_b_c(caster, ability)
	local level = ability:GetLevel()
	caster:MoveToPosition(caster:GetAbsOrigin()+ability.forwardVec*(level/0.03)*25)
end


function iceSprintThink(event)
  local caster = event.caster
  local ability = event.ability
  local position = caster:GetAbsOrigin()
  
  ability.interval = ability.interval+1
  position = GetGroundPosition( position, caster )

  local obstruction = WallPhysics:FindNearestObstruction(position)
  local newPosition = position+caster:GetForwardVector()*25
  local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (position+caster:GetForwardVector()*95), caster)
  if ability.interval%3 == 0 then
  	local baseDamage = event.damage
  	iceSprintBlast(caster, newPosition, event.radius, baseDamage, ability)
  end
  if not blockUnit then
    caster:SetOrigin(newPosition)
  end
end

function iceSprintEnd(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	if not caster:IsChanneling() then
		caster:Stop()
	end
	FindClearSpaceForUnit(caster, position, false)
end

function iceSprintBlast(caster, position, radius, damage, ability)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then	
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_sprint_slow", {duration = 3})
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
		end
	end
end

function autumn_mage_blink_start(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/act_2/blob_launch_impact_hit_smoke.vpcf", caster, 3)

end

function autumn_blink_debuff_end(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.IceBlink", caster)

	local particleName = "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
    local target = caster:GetAbsOrigin() + RandomVector(RandomInt(560, 1000))
    local casterOrigin = caster:GetAbsOrigin()
    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    -- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
    --     ParticleManager:SetParticleControl( pfx, 0, position )
    local newPosition = target
    FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function sea_fortress_summon_ability(event)
	local caster = event.caster
	local ability = event.ability
	local loops = 1
	if not caster.summonCount then
		caster.summonCount = 0
	end
	if caster.summons then
		loops = caster.summons
	end
	if not caster.maxSummons then
		caster.maxSummons = 2
	end
	local summoned = false
	for i = 1, loops, 1 do
		if caster.summonCount < caster.maxSummons then
			summoned = true
			local spider = nil
			if caster:GetUnitName() == "winterblight_ice_summoner" then
				spider = Winterblight:SpawnIceSummon(caster:GetAbsOrigin()+RandomVector(RandomInt(100, 260)), caster:GetForwardVector(), caster, caster.aggro)
				CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite_snow_explode.vpcf", spider, 3)
			end
			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin()+Vector(0,0,140), spider:GetAbsOrigin()+Vector(0,0,60), "particles/units/heroes/hero_wisp/wisp_tether_agh.vpcf", 0.9)
			spider.origCaster = caster
			caster.summonCount  = caster.summonCount + 1
			spider:AddAbility("winterblight_enemy_summon"):SetLevel(1)
			StartAnimation(spider, {duration=0.5, activity=ACT_DOTA_DISABLED, rate=1.1})
		end
	end
	if summoned then
		if caster:GetUnitName() == "winterblight_ice_summoner" then
			StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.9})
			EmitSoundOn("Winterblight.IceSummon", caster)
		end
	end
end


function enemy_summon_start(event)
	local caster = event.caster
	local ability = event.ability

	caster:SetDeathXP(0)
	caster:SetMinimumGoldBounty(0)
	caster:SetMaximumGoldBounty(0)
end

function enemy_summon_die(event)
	local caster = event.caster
	local ability = event.ability
	caster.origCaster.summonCount = caster.origCaster.summonCount - 1
end

function blade_jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1]
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance/18
	ability.liftVelocity = 15
	local heightDiff = 0
	ability.liftVelocity = ability.liftVelocity - heightDiff/25
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	ability.interval = 0
	if not event.special then
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_FLAIL, rate=1, translate="forcestaff_friendly"})
		EmitSoundOn("Winterblight.BladeDancer.JumpVO", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.BladeDancer.Jump", caster)
		if caster:HasModifier("modifier_machinal_jump_freecast") then
			ability:EndCooldown()
			local newStacks = caster:GetModifierStackCount("modifier_machinal_jump_freecast", caster) - 1
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_machinal_jump_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_machinal_jump_freecast")
			end
		end
	end
	ability.a_c_level = 0
	ability.c_c_level = 0
end

function blade_jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV
	-- if distance < 60 then
	-- 	fv = Vector(0,0)
	-- end
	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
		print(height)
		if not ability.rising then
			caster:RemoveModifierByName("modifier_machinal_jump")
		end
	end

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*30), caster)
	if blockUnit then
		fv = Vector(0,0)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + fv*ability.jumpVelocity + Vector(0,0,ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 2
	if ability.liftVelocity <= 0 then
		ability.rising = false
	end
	ability.interval = ability.interval + 1
	-- if ability.interval%3 == 0 then
	-- 	local pfx = ParticleManager:CreateParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_CUSTOMORIGIN, caster)
	-- 	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	-- 	Timers:CreateTimer(0.4, function()
	-- 		ParticleManager:DestroyParticle(pfx, false)
	-- 	end)
	-- end
end

function blade_jump_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
	local pfx = ParticleManager:CreateParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(0.4, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=0.9})
	Timers:CreateTimer(0.1, function()
		EmitSoundOn("Winterblight.BladeDancer.Shockwave", caster)
		caster:AddNewModifier(caster, nil, "modifier_animation", {translate="walk"})
		caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="walk"})
		local fv = caster:GetForwardVector()
		local info = 
		{
				Ability = ability,
	        	EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
	        	vSpawnOrigin = caster:GetAbsOrigin(),
	        	fDistance = 1500,
	        	fStartRadius = 140,
	        	fEndRadius = 140,
	        	Source = caster,
	        	StartPosition = "attach_attack1",
	        	bHasFrontalCone = false,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * 800,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end)
end

function challenger19ai(event)
	local caster = event.caster
	local abiility = event.ability
	local blinkAbility = caster:FindAbilityByName("arena_phantom_strike")
	local luck = RandomInt(1,4)
	local range = GameState:GetDifficultyFactor()*150 + 290
	if luck == 1 then
		if blinkAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = blinkAbility:entindex(),
						TargetIndex = enemies[1]:entindex()
				 	}
				 
				ExecuteOrderFromTable(newOrder)			
			end
			return
		end
	end
	local stifling = caster:FindAbilityByName("arena_stifling_dagger")
	if stifling:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local distance = WallPhysics:GetDistance(enemies[1]:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
			if distance > 500 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = stifling:entindex(),
						TargetIndex = enemies[1]:entindex()
				 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return		
			end
		end	
	end
end
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
	ability.a_c_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 2)
	ability.c_c_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 2)
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
		chargeBlast:StartCooldown(8)
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
function maiden_armor_init(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_maiden_armor", {})
	caster:SetModifierStackCount("modifier_maiden_armor", caster, event.charges)
end

function shrine_maiden_think(event)
	local caster = event.caster
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro and caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("azalea_crystal_nova")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 320))			
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("azalea_maiden_frostbite")
			if hookAbility:IsFullyCastable() then		
				local order = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = hookAbility:entindex(),
			 	}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function master_crystal_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,2)*math.cos(2*math.pi*caster.interval/180))
	caster.interval = caster.interval + 1
	local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/180)
	caster:SetForwardVector(rotatedFV)
	if caster.interval == 180 then
		caster.interval = 0 
	end
	for i = 1, #Winterblight.AzaleaCrystalTable, 1 do
		local crystal = Winterblight.AzaleaCrystalTable[i]
		crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,0.8)*math.cos(2*math.pi*caster.interval/180))
		local rotatedFV = WallPhysics:rotateVector(crystal:GetForwardVector(), 2*math.pi/180)
		crystal:SetForwardVector(rotatedFV)
	end
end

function reset_crystal_puzzle(event)
	local caster = event.caster
	if caster.locked or caster:HasModifier("modifier_crystal_finished") then
		return false
	end
	for i = 1, #Winterblight.AzaleaCrystalTable, 1 do
		local crystal = Winterblight.AzaleaCrystalTable[i]
		if crystal.pfx then
			ParticleManager:DestroyParticle(crystal.pfx, false)
		end
		UTIL_Remove(crystal)
	end
	UTIL_Remove(Winterblight.MasterCrystal)
	local crystalPosTable = {Vector(10496, -11008), Vector(10496, -11960), Vector(11776, -11960), Vector(11776, -11008)}
	Winterblight.AzaleaCrystalTable = {}
	Winterblight.tripleSwitchCount = 0
	for i = 1, 4, 1 do
		Winterblight:SpawnAzaleaCrystal(crystalPosTable[i], i)
	end
	Winterblight:SpawnMasterAzaleaCrystal()
	EmitSoundOn("Winterblight.AzaleaCrystal.PuzzleReset", Winterblight.MasterCrystal)
end

function zefnar_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = 0.4
	if attacker.mainZefnar then
		duration = 0.8
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	EmitSoundOn("Winterblight.Zefnar.AttackLand", target)
	CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/zefnar_hit.vpcf", target, 3)
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zefnar_root", {duration = duration})
		end
	end 
end

function zefnar_madman_go(event)
	local caster = event.caster
	local ability = event.ability
	if caster.mainZefnar and caster.aggro then
		caster.interval = 0
		if not caster.minis then
			caster.minis = 0
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {})
		StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_6, rate=0.9})
		EmitSoundOn("Winterblight.Zefnar.LifterVO", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Zefnar.Lifter", caster)
		CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/zefnar_hit.vpcf", caster, 3)
	end
end

function zefnar_madman_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.interval < 60 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,20))
	elseif caster.interval >= 60 and caster.interval < 180 then
		if caster.interval%20 == 0 then
			local explodeParticle = "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
			local castParticle ="particles/roshpit/solunia/comet_cast_moon.vpcf"

			local position = GetGroundPosition(caster:GetAbsOrigin()+RandomVector(RandomInt(0, 1000)), caster)
			local pfx = ParticleManager:CreateParticle(castParticle, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
			local damage = event.damage
			EmitSoundOnLocationWithCaster(position, "Winterblight.Zefnar.CometLaunch", caster)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/zefnar_meteor_attack.vpcf", position, 4)
			Timers:CreateTimer(0.45, function()
				local pfx2 = ParticleManager:CreateParticle("particles/roshpit/winterblight/zefnar_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx2, 0, position)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(pfx2, false)
					ParticleManager:ReleaseParticleIndex(pfx2)
				end)
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
						Filters:ApplyStun(caster, 1.5, enemy)
					end
				end 
				if caster.minis < 12 then
					local mini = Winterblight:SpawnMiniZefnar(position, RandomVector(1))
					mini:SetDeathXP(0)
					mini:SetMaximumGoldBounty(0)
					mini:SetMinimumGoldBounty(0)
					caster.minis = caster.minis + 1
					mini.cometMini = true
					mini.mainCaster = caster
				end
			end)
		end
	else
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,20))
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 20 then
			caster:RemoveModifierByName("modifier_disable_player")
		end
	end
	caster.interval = caster.interval + 1
end

function zefnar_die(event)
	local caster = event.caster
	local ability = event.ability
	if caster.cometMini then
		caster.mainCaster.minis = caster.mainCaster.minis - 1
	end
	if caster.mainZefnar then
		EmitSoundOn("Winterblight.Zefnar.Death", caster)
		for i = 1, 50, 1 do
			Timers:CreateTimer(0.03*i, function()
				Winterblight.AzaleaSwitchMathProp:SetAbsOrigin(Winterblight.AzaleaSwitchMathProp:GetAbsOrigin()-Vector(0,0,30))
			end)
		end
		Timers:CreateTimer(1.5, function()
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/zefnar_hit.vpcf", Winterblight.AzaleaSwitchMathProp:GetAbsOrigin(), 3)
			EmitSoundOnLocationWithCaster(Winterblight.AzaleaSwitchMathProp:GetAbsOrigin(), "Winterblight.Zefnar.SpawnMini", Events.GameMaster)
			Winterblight.AzaleaSwitch1Dropped = true
		end)
	end
end

function syphist_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:IsHero() then
		local selfRegen = caster:FindModifierByNameAndCaster("modifier_syphist_regen", caster)
		local enemyRegen = target:FindModifierByNameAndCaster("modifier_syphist_regen_opponent", caster)
		if not selfRegen then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_syphist_regen", {duration = 4.5})
		else
			selfRegen:SetDuration(4.5, true)
		end
		if not enemyRegen then
			EmitSoundOn("Winterblight.SyphistSteal", target)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_syphist_regen_opponent", {duration = 4.5})
			local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(beamPFX, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(beamPFX, 1, caster:GetAbsOrigin())
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(beamPFX, false)
				ParticleManager:ReleaseParticleIndex(beamPFX)
			end)
		else
			enemyRegen:SetDuration(4.5, true)
		end
		local selfRegen = caster:FindModifierByNameAndCaster("modifier_syphist_regen", caster)
		local enemyRegen = target:FindModifierByNameAndCaster("modifier_syphist_regen_opponent", caster)
		if enemyRegen then
			enemyRegen:IncrementStackCount()
		end
		if selfRegen then
			selfRegen:SetStackCount(enemyRegen:GetStackCount())
		end
	end
end

function source_revenant_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local stacks = caster:GetMana()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_source_revenant_attack_power", {})
	caster:SetModifierStackCount("modifier_source_revenant_attack_power", caster, stacks)
end

function source_revenant_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local amount = caster:GetMaxMana()*0.08
	caster:GiveMana(amount)
	PopupMana(caster, amount)
	if not ability.particleLock then
		ability.particleLock = true
		CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", caster, 2)
		Timers:CreateTimer(1, function()
			ability.particleLock = false
		end)
	end
end

function ice_idle_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local sumVector = Vector(0,0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector/#enemies
			local runDirection = ((caster:GetAbsOrigin() - avgVector)*Vector(1,1,0)):Normalized()
			runDirection = WallPhysics:rotateVector(runDirection, 2*math.pi*RandomInt(-4, 4)/16)
			local order = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			 		Position = caster:GetAbsOrigin()+runDirection*RandomInt(300, 400)
		 	}
			ExecuteOrderFromTable(order)
		else
			local position = caster.minVector + Vector(RandomInt(0, caster.maxXroam), RandomInt(0, caster.maxYroam))
			local order = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			 		Position = position
		 	}
			ExecuteOrderFromTable(order)
		end
	else
		local position = caster.minVector + Vector(RandomInt(0, caster.maxXroam), RandomInt(0, caster.maxYroam))
		local order = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		 		Position = position
	 	}
		ExecuteOrderFromTable(order)
		return false
	end
end

function suicide_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if caster.suicide or caster:IsHero() then
		return false
	end
	if caster:GetHealth()/caster:GetMaxHealth() < 0.3 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			caster.suicide = true
			ability.targetPoint = enemies[1]:GetAbsOrigin()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_suicide_jump", {duration = 4})
			local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
			ability.jumpVelocity = distance/20
			ability.liftVelocity = 20
			local heightDiff = 0
			ability.liftVelocity = ability.liftVelocity - heightDiff/20
			ability.rising = true
			ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

			ability.interval = 0
			StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_5, rate=0.9})
			EmitSoundOn("Winterblight.SkaterFiend.SuicideVO", caster)
		end
	end
end

function suicide_jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV

	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
		if not ability.rising then
			caster:RemoveModifierByName("modifier_suicide_jump")
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
end

function suicide_jump_end(event)
	local caster = event.caster
	local ability = event.ability

    local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
    local radius = 260
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )
    local origin = caster:GetAbsOrigin()
    ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,20) )
    ParticleManager:SetParticleControl( particle1, 1, Vector(radius, 1, 1000) )
    ParticleManager:SetParticleControl( particle1, 3, Vector(radius, radius, radius) )
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    EmitSoundOn("Winterblight.SkaterFiend.SuicideCrash", caster)
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local damage = event.damage
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
        	ApplyDamage({ victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chilled", {duration = 3.5})
        end
    end

	Timers:CreateTimer(0.03, function()
		UTIL_Remove(caster)
	end)
end

function azalea_explosion_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.pushVelocity then
		target.pushVelocity = 32
	end
	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin()+target.pushVector*30)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin()+target.pushVector*30, target)
	local fv = target.pushVector
	if blockUnit then
		fv = 0
	end

	target:SetAbsOrigin(GetGroundPosition(target:GetAbsOrigin() + fv*target.pushVelocity, target))
	target.pushVelocity = math.max(target.pushVelocity - 1, 0)
	print("PUSH??")
end

function azalea_cup_sequence_think(event)
	local target = event.target
	if not target.cupSequence then
		return false
	end
	if target.cupSequence == 0 then
		target.cupSequence = 1
		local distance = WallPhysics:GetDistance2d(target.cupSequenceData.targetPoint, target:GetAbsOrigin())
		target.cupSequenceData.jumpVelocity = distance/20 + 4
		target.cupSequenceData.liftVelocity = 23
		local heightDiff = (target.cupSequenceData.targetPoint.z+60)-target:GetAbsOrigin().z
		target.cupSequenceData.liftVelocity = target.cupSequenceData.liftVelocity + heightDiff/24
		target.cupSequenceData.rising = true
		target.cupSequenceData.jumpFV = ((target.cupSequenceData.targetPoint - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()

		target.cupSequenceData.interval = 0
		local playerID = target:GetPlayerID()
		if playerID then
			PlayerResource:SetCameraTarget(playerID, target)
		end
	elseif target.cupSequence == 1 then
		local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), target.cupSequenceData.targetPoint)

		local fv = target.cupSequenceData.jumpFV

		local height = (target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target))


		local blockSearch = target:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(target:GetAbsOrigin(), target))
	    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+target.cupSequenceData.jumpFV*30), target)
		if blockUnit then
			fv = Vector(0,0)
		end
		target:SetOrigin(target:GetAbsOrigin() + fv*target.cupSequenceData.jumpVelocity + Vector(0,0,target.cupSequenceData.liftVelocity))
		target.cupSequenceData.liftVelocity = target.cupSequenceData.liftVelocity - 2
		if target.cupSequenceData.liftVelocity <= 0 then
			target.cupSequenceData.rising = false
		end
		target.cupSequenceData.interval = target.cupSequenceData.interval + 1
		if distance < 20 or target:GetAbsOrigin().z < target.cupSequenceData.targetPoint.z then
			if not target.cupSequenceData.rising then
				target.cupSequence = 2
				target.cupSequenceData.interval = 0
				CustomAbilities:QuickParticleAtPoint("particles/act_2/siltbreaker_beam_channel.vpcf", target.cupSequenceData.targetPoint+Vector(0,0,20), 5)
			end
		end
	elseif target.cupSequence == 2 then
		target.cupSequenceData.interval = target.cupSequenceData.interval + 1
		if target.cupSequenceData.interval == 50 then
			target.cupSequenceData.interval = 0
			target.cupSequence = 3
			target:SetOrigin(Vector(-219, -14701, 2100+Winterblight.ZFLOAT))
			target.cupSequenceData.fallSpeed = 30
			EmitSoundOn("Winterblight.AzaleaCup.Falling", target)
			Timers:CreateTimer(1, function()
				StartAnimation(target, {duration=3.5, activity=ACT_DOTA_SPAWN, rate=0.6})
			end)
			local pfx = ParticleManager:CreateParticle( "particles/winterblight/cup_falling_particle.vpcf", PATTACH_CUSTOMORIGIN, nil )
			target.cupSequenceData.pfx = pfx
			local colorVector = Vector(100, 200, 255)
			ParticleManager:SetParticleControl( target.cupSequenceData.pfx, 0, Vector(-219, -14701, 150+Winterblight.ZFLOAT) )
			ParticleManager:SetParticleControl( target.cupSequenceData.pfx, 1, colorVector )
			ParticleManager:SetParticleControl( target.cupSequenceData.pfx, 2, colorVector )
			ParticleManager:SetParticleControl( target.cupSequenceData.pfx, 3, colorVector )
			CustomAbilities:QuickParticleAtPoint("particles/act_2/siltbreaker_beam_channel.vpcf", Vector(-219, -14701, 150+Winterblight.ZFLOAT), 3)
			print("SEQUENCE 3 START")
		end
	elseif target.cupSequence == 3 then
		print("SEQUENCE 3 GOING")
		target:RemoveModifierByName("modifier_black_portal_shrink")
		target.cupSequenceData.fallSpeed = math.max(target.cupSequenceData.fallSpeed-0.35, 10)
		print(target.cupSequenceData.fallSpeed)
		target:SetOrigin(target:GetAbsOrigin()-Vector(0,0,target.cupSequenceData.fallSpeed))
		print(target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target))
		if target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target) < 40 then
			print("SEQUENCE 3 END")
			target:RemoveModifierByName("modifier_azalea_cup_use")
			local playerID = target:GetPlayerID()
			if playerID then
				PlayerResource:SetCameraTarget(playerID, nil)
			end
			EmitSoundOn("Winterblight.AzaleaCup.Land", target)
			ParticleManager:DestroyParticle(target.cupSequenceData.pfx, false)
			local pfx2 = ParticleManager:CreateParticle("particles/roshpit/winterblight/azalea_explosion_magical.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx2, 2, Vector(90, 200, 255))
			Timers:CreateTimer(3.5, function()
				ParticleManager:DestroyParticle(pfx2, false)
			end)
		end
	end

end

function mindbreaker_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local percentage = event.percentage
	local intelligence = event.intelligence
	local mana_threshold = event.mana_threshold
	local procs = 0
	if target:IsHero() then
		procs = math.min(target:GetIntellect()/intelligence, 15)
	else
		procs = math.min(target:GetMana()/mana_threshold, 15)
	end
	local damage = event.damage*percentage/100
	if procs > 0 then
		CustomAbilities:QuickAttachParticle("particles/winterblight/mindbreaker_attack.vpcf", attacker, 3)
	end
	for i = 1, procs, 1 do
		Timers:CreateTimer(i*0.03, function()
			ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			EmitSoundOn("Winterblight.MindBreaker.Sound", attacker)
			CustomAbilities:QuickAttachParticle("particles/winterblight/mindbreaker_attack.vpcf", target, 3)
		end)
	end
end

function ghost_striker_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local damage_per_missing_hp = event.damage_per_missing_hp
	local damage = (target:GetMaxHealth()-target:GetHealth())*damage_per_missing_hp
	if damage > 100 then
		ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
		EmitSoundOn("Winterblight.GhostStriker.Hit", target)	
		if not ability.particleLock then
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn_spike.vpcf", target, 3)
			ability.particleLock = true
			Timers:CreateTimer(0.5, function()
				ability.particleLock = false
			end)
		end
	end
end

function ghost_striker_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:IsAlive() and caster.aggro then
		if caster:HasAbility("serengaard_antimage_blink_custom") then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				local hookAbility = caster:FindAbilityByName("serengaard_antimage_blink_custom")
				if hookAbility:IsFullyCastable() then
					local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 320))			
					local order =
					{
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = hookAbility:entindex(),
						Position = targetPoint
					}
					ExecuteOrderFromTable(order)
					return false
				end
			end
		end
	end
end

function secret_keeper_attack_land(event)
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	local agility_loss = event.agility_loss/100
	if target:IsHero() then
		if not target:HasModifier("modifier_secret_keeper_agi_loss") then
			ability:ApplyDataDrivenModifier(attacker, target, "modifier_secret_keeper_agi_loss", {duration = 5})
			target:SetModifierStackCount("modifier_secret_keeper_agi_loss", attacker, target:GetAgility()*agility_loss)
		end
	end
end

function thorcrux_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = caster:GetAttackRange()
	if caster:IsAlive() and caster.aggro then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_ATTACK, rate=1.2})
			for _,enemy in pairs(enemies) do
				Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
			end
		end 
	end
end

function crippling_return_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local damage_loss = event.damage_loss/100
	if not attacker:HasModifier("modifier_crippling_return_effect") then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_crippling_return_effect", {duration = 4})
		local damageLoss = attacker:GetBaseDamageMax()*damage_loss
		attacker:SetModifierStackCount("modifier_crippling_return_effect", caster, damageLoss/10)
	end
end

function chrolonus_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local luck = RandomInt(1, 4)
	if luck == 1 then
		EmitSoundOn("Winterblight.Chrolonus.Bash", target)
		ability.pushVector = false
		ability.pushVelocity = 32
		ability.tossPosition = caster:GetAbsOrigin()
		target.pushVector = false
		ability:ApplyDataDrivenModifier(caster, target, "modifier_heavy_boulder_pushback", {duration = 0.8})
		Filters:ApplyStun(caster, 0.5, target)
	end
end

function chrolonus_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro and caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("chrolonus_dash")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 420))			
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function chrolonus_begin_lightning_dash(event)
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack_trail.vpcf"
	ability.point = event.target_points[1]
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_dash", {duration = 3})
	-- EmitSoundOn("Winterblight.Chrolonus.WarpDash", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Chrolonus.WarpDash", caster)
	local particleName = "particles/roshpit/voltex/lightning_dash_trail.vpcf"
	local pfx = 0
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())

	ability.pfx = pfx

	ability.interval = 0
	if not ability.particles then
		ability.particles = 0
	end
	if caster:HasModifier("modifier_lightning_dash_freecast") then
		ability:EndCooldown()
		local newStacks = caster:GetModifierStackCount("modifier_lightning_dash_freecast", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_lightning_dash_freecast", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_lightning_dash_freecast")
		end
	end
end

function chrolonus_add_free_casts(event)
	local caster = event.caster
	local ability = event.ability
	local stackCount = caster:GetModifierStackCount("modifier_lightning_dash_freecast", caster)
	local maxStacks = 4+GameState:GetDifficultyFactor()
	if stackCount < maxStacks then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_dash_freecast", {})
		local newStacks = math.min(stackCount + 1, maxStacks)
		caster:SetModifierStackCount("modifier_lightning_dash_freecast", caster, newStacks)
	end
end

function chrolonus_dash_think(event)
	local caster = event.caster
	local ability = event.ability
	
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.moveDirection*35), caster)

    local forwardSpeed = 100
	if blockUnit then
		forwardSpeed = 0
		caster:RemoveModifierByName("modifier_lightning_dash")
	end
	local newPosition = caster:GetAbsOrigin() + ability.moveDirection*forwardSpeed
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 70) + Vector(0,0,GetGroundHeight(newPosition, caster)))
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < forwardSpeed*1.5 then
		caster:RemoveModifierByName("modifier_lightning_dash")
	end
	ability.interval = ability.interval + 1
	-- if ability.pfx then
	-- local pfx = ability.pfx
	-- 	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	-- 	ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())
	-- end
end

function chrolonus_dash_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.5}) 
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
	ParticleManager:DestroyParticle(ability.pfx, false)

	local particleName = "particles/roshpit/winterblight/zefnar_hit.vpcf"
	local pfxB = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfxB, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfxB, 1, Vector(200, 2, 200))
	Timers:CreateTimer(0.8, function()
		ParticleManager:DestroyParticle(pfxB, false)
	end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local damage = event.damage
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
		end
	end 

end

function crystal_meditation_attack_start(event)
	local attacker = event.attacker
	local target = event.target
	local attacks = event.attacks
	for i = 1, attacks, 1 do
		Timers:CreateTimer(i*0.1, function()
			Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
		end)
	end
end

function malefor_beginCharge(event)
	local ability = event.ability
	local caster = event.caster

	ability.fv = caster:GetForwardVector()
	ability.slideSpeed = 25
	ability.interval = 0
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_RUN, rate=1.5})
	end)

	EmitSoundOn("Winterblight.Malefor.Charge", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Malefor.ChargeWarp", caster)
end

function malefor_charge_think(event)
  local caster = event.caster
  local ability = event.ability
  local position = caster:GetAbsOrigin()
  
  ability.interval = ability.interval+1
  position = GetGroundPosition( position, caster )

  local newPosition = position+ability.fv*30

  local obstruction = WallPhysics:FindNearestObstruction(newPosition)
  local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
  -- if ability.interval%3 == 0 then
  -- 	iceSprintBlast(caster, newPosition, event.radius, event.damage, ability)
  -- end
  if caster:GetAbsOrigin().z - GetGroundHeight(newPosition, caster) > 80 then
  	blockUnit = true
  	caster:RemoveModifierByName("modifier_light_charging")
  end
  if not blockUnit then
    caster:SetOrigin(newPosition)
  end


end

function malefor_slide_think(event)
  local caster = event.caster
  local ability = event.ability
  local position = caster:GetAbsOrigin()
  
  position = GetGroundPosition( position, caster )


  local newPosition = position+ability.fv*ability.slideSpeed
  local obstruction = WallPhysics:FindNearestObstruction(newPosition)
  local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
  ability.slideSpeed = ability.slideSpeed - 1
  -- if ability.interval%3 == 0 then
  -- 	iceSprintBlast(caster, newPosition, event.radius, event.damage, ability)
  -- end
  if not blockUnit then
  	if GridNav:IsTraversable(newPosition) then
    	caster:SetOrigin(newPosition)
    end
  end
end

function malefor_slide_end(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local ability = event.ability
	FindClearSpaceForUnit(caster, position, false)
end

function malefor_charge_end(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()

	local fv = caster:GetForwardVector()


	local particle = "particles/units/heroes/hero_silencer/silencer_last_word_trigger.vpcf"
	local pfx3 = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx3, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx3, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx3, false)
	end)
	local range = event.range
end

function chrolonus_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.Chrolonus.Death", caster)
	Timers:CreateTimer(1, function()
		Winterblight.AzaleaBladesTable = {}
		Winterblight:SpawnAzaleaColorBlade(Vector(7465, -15147, -147), 1)
		Winterblight:SpawnAzaleaColorBlade(Vector(7601, -15147, -147), 2)
		Winterblight:SpawnAzaleaColorBlade(Vector(7736, -15147, -147), 3)
		Winterblight:SpawnAzaleaColorBlade(Vector(7874, -15147, -147), 4)
	end)
	Timers:CreateTimer(0.5, function()
		Winterblight:RemoveBlockers(8.5, "AzaleaBridgeBlocker4", Vector(6600, -15500, 127+Winterblight.ZFLOAT), 5400)
		for i = 1, 300, 1 do
			Timers:CreateTimer(0.03*i, function()
				if i %40 == 0 then
					EmitSoundOnLocationWithCaster(Vector(6400, -15449, 78+Winterblight.ZFLOAT), "Winterblight.AzaleaBridge.Raise", Events.GameMaster)
				end
				Winterblight.AzaleaBridge4:SetAbsOrigin(Winterblight.AzaleaBridge4:GetAbsOrigin()+Vector(0,0,1500/300))
			end)
		end
		Timers:CreateTimer(3, function()
			local walls = Entities:FindAllByNameWithin("AzaleaWall5", Vector(6539, -15459, -4094+Winterblight.ZFLOAT), 2400)
		    EmitSoundOnLocationWithCaster(Vector(6539, -15459), "Winterblight.WallOpen", Events.GameMaster)
		    Winterblight:WallsTicks(false, walls, true, 5, 360, 0.1)
		    Winterblight:RemoveBlockers(4, "AzaleaWallBlocker2", Vector(6539, -15459, 300+Winterblight.ZFLOAT), 3800)
		end)
		Timers:CreateTimer(9, function()
			EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge4:GetAbsOrigin(), "Winterblight.AzaleaBridge.Finish", Winterblight.Master)
			Timers:CreateTimer(0.1, function()
				EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge4:GetAbsOrigin(), "Winterblight.Azalea.Win", Winterblight.Master)
			end)
			local positionTable = {Vector(6750, -15543), Vector(6750, -15408), Vector(6750, -15316), Vector(6242, -15559), Vector(6242, -15408), Vector(6242, -15316)}
            for i = 1, #positionTable, 1 do
              local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
              ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(positionTable[i], Events.GameMaster ))
              ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
              Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(pfx, false)
              end)
            end
		end)
	end)
	Timers:CreateTimer(8, function()
		Winterblight:CandyCrushRoom()
	end)
end

function candy_crush_crystal_hit(event)
	local caster = event.caster
	print("HIT1")
	if caster.locked or caster:HasModifier("modifier_crystal_finished") then
		return false
	end
	print("HIT2")
	if Winterblight.CandyCrushLocked then
		return false
	end
	if not Winterblight.CandyCrushLayout then
		Winterblight:InitializeCandyCrush()
	else
		Winterblight:ResetCandyCrush()
	end
	if caster.dark then
		caster.dark = false
		Winterblight:smoothColorTransition(caster, Vector(40,40,40), Vector(200, 200, 200), 50)
	end
	EmitSoundOn("Winterblight.AzaleaCrystal.PuzzleReset", Winterblight.MasterCrystal)
end

function candy_crush_master_crystal_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,2)*math.cos(2*math.pi*caster.interval/180))
	caster.interval = caster.interval + 1
	local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/180)
	caster:SetForwardVector(rotatedFV)
	if caster.interval == 180 then
		caster.interval = 0 
	end
end

function candy_crush_unit_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	if not Winterblight.CandyCrushLocked then
		if target.black then
			return false
		end
		if not target.link_lock then
			if not attacker.candy_crush_link_data then
				attacker.candy_crush_link_data = {}
				attacker.candy_crush_link_data.links = {}
			elseif #attacker.candy_crush_link_data.links == 0 then
			elseif #attacker.candy_crush_link_data.links >= 1 then
				local sameUnit = false
				for i = 1, #attacker.candy_crush_link_data.links, 1 do
					if target:GetEntityIndex() == attacker.candy_crush_link_data.links[i] then
						sameUnit = false
						break
					end
				end
				if sameUnit then
					return false
				end
				if attacker.candy_crush_link_data.links[#attacker.candy_crush_link_data.links].color == target.color then
				else
					attacker:RemoveModifierByName("modifier_hero_candy_crush")
					return false
				end
				if #attacker.candy_crush_link_data.links == 1 then
					if (attacker.candy_crush_link_data.links[1].index_j == target.index_j) then
						if math.abs(attacker.candy_crush_link_data.links[1].index_i - target.index_i) == 1 then
						else
							print("HORIZONTAL MATCHES, BUT VERTICAL DISTANCE > 1")
							attacker:RemoveModifierByName("modifier_hero_candy_crush")
							return false
						end
					elseif (attacker.candy_crush_link_data.links[1].index_i == target.index_i) then
						if math.abs(attacker.candy_crush_link_data.links[1].index_j - target.index_j) == 1 then
						else
							print("VERTICAL IS SAME, BUT HORIZONTAL DISTANCE > 1")
							attacker:RemoveModifierByName("modifier_hero_candy_crush")
							return false
						end
					else
						print("VERTICAL AND HORIZONTAL ARE OFF")
						attacker:RemoveModifierByName("modifier_hero_candy_crush")
						return false
					end
				else
					local link_index = #attacker.candy_crush_link_data.links
					if attacker.candy_crush_link_data.direction == "horizontal" then
						if (attacker.candy_crush_link_data.links[link_index].index_j == target.index_j) then
							print(math.abs(attacker.candy_crush_link_data.links[link_index].index_i - target.index_i))
							if math.abs(attacker.candy_crush_link_data.links[link_index].index_i - target.index_i) == 1 then
							else
								print("HORIZONTAL MATCHES, BUT VERTICAL DISTANCE > 1")
								attacker:RemoveModifierByName("modifier_hero_candy_crush")
								return false
							end
						else
							print("HORIZONTAL INDEX DOESN'T MATCH, BUT HERO HAD HORIZONTAL GOING")
							attacker:RemoveModifierByName("modifier_hero_candy_crush")
							return false
						end
					else
						if (attacker.candy_crush_link_data.links[link_index].index_i == target.index_i) then
							if math.abs(attacker.candy_crush_link_data.links[link_index].index_j - target.index_j) == 1 then
							else
								print("VERT IS SAME, HORIZONTAL DIFF GREATER THAN 1")
								attacker:RemoveModifierByName("modifier_hero_candy_crush")
								return false
							end
						else
							print("WANTED SAME VERTICAL, WASN'T")
							attacker:RemoveModifierByName("modifier_hero_candy_crush")
							return false
						end
					end
				end
			end
			EmitSoundOn("Winterblight.CandyCrush.Good1", attacker)
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_hero_candy_crush", {duration = 10})
			table.insert(attacker.candy_crush_link_data.links, target)
			target.link_lock = true
			local pfxName = "particles/units/heroes/hero_wisp/tether_green.vpcf"
			if target.color == "red" then
				pfxName = "particles/units/heroes/hero_wisp/epoch_rune_b_a.vpcf"
			elseif target.color == "blue" then
				pfxName = "particles/units/heroes/hero_wisp/wisp_tether_agh.vpcf"
			elseif target.color == "yellow" then
				pfxName = "particles/roshpit/winterblight/tether_yellow.vpcf"
			end
			if #attacker.candy_crush_link_data.links == 1 then
				attacker.candy_crush_link_data.pfxTable = {}
				local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_POINT, attacker)
				ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()+Vector(0,0,70))
				ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_attack1", attacker:GetAbsOrigin()+Vector(0,0,60), true)
				table.insert(attacker.candy_crush_link_data.pfxTable, pfx)
			elseif #attacker.candy_crush_link_data.links == 2 then
				local pfx = attacker.candy_crush_link_data.pfxTable[1]
				ParticleManager:DestroyParticle(pfx, false)
				local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx, 0, attacker.candy_crush_link_data.links[#attacker.candy_crush_link_data.links-1]:GetAbsOrigin()+Vector(0,0,70))
				ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+Vector(0,0,70))
				attacker.candy_crush_link_data.pfxTable[1] = pfx
				if attacker.candy_crush_link_data.links[1].index_j == attacker.candy_crush_link_data.links[2].index_j then
					attacker.candy_crush_link_data.direction = "horizontal"
				else
					attacker.candy_crush_link_data.direction = "vertical"
				end
			else
				local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx, 0, attacker.candy_crush_link_data.links[#attacker.candy_crush_link_data.links-1]:GetAbsOrigin()+Vector(0,0,70))
				ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+Vector(0,0,70))
				table.insert(attacker.candy_crush_link_data.pfxTable, pfx)				
			end

		end
	end
end

function candy_crush_buff_end(event)
	local caster = event.caster
	local ability = event.ability
	local hero = event.target
	print(hero:GetUnitName())
	if Winterblight.CandyCrushLocked then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_hero_candy_crush", {duration = 10})
		return false
	end
	if not Winterblight.CandyCrushBlackStatueTable then
		Winterblight.CandyCrushBlackStatueTable = {}
	end
	if #Winterblight.CandyCrushBlackStatueTable < 10 then
		local xIncrease = #Winterblight.CandyCrushBlackStatueTable*242
		if IsValidEntity(hero.candy_crush_link_data.links[#hero.candy_crush_link_data.links]) then
			Winterblight:SpawnCandyCrushStatue(Vector(2958+xIncrease, -16128), hero.candy_crush_link_data.links[#hero.candy_crush_link_data.links].color, -1, -1)
		end
	else
		Winterblight:ResetCandyCrush()
		return false
	end
	for i = 1, #hero.candy_crush_link_data.links, 1 do
		hero.candy_crush_link_data.links[i].link_lock = false
	end
	if #hero.candy_crush_link_data.links < 3 then
		EmitSoundOn("Winterblight.CandyCrush.Bad", hero)
		for i = 1, #hero.candy_crush_link_data.pfxTable, 1 do
			ParticleManager:DestroyParticle(hero.candy_crush_link_data.pfxTable[i], false)
		end
		for i = 1, #hero.candy_crush_link_data.links, 1 do
			local unit = hero.candy_crush_link_data.links[i]
			Winterblight:SpawnRandomColorStatue(unit:GetAbsOrigin(), unit.index_i,unit.index_j)
			UTIL_Remove(unit)			
		end
		hero.candy_crush_link_data.links = {}
		hero.candy_crush_link_data.pfxTable = {}
	else
		Winterblight:ProcessLinks(hero.candy_crush_link_data.links, hero, 0)
		hero.candy_crush_link_data.links = {}
		hero.candy_crush_link_data.pfxTable = {}
		-- for i = 1, #hero.candy_crush_link_data.pfxTable, 1 do
		-- 	ParticleManager:DestroyParticle(hero.candy_crush_link_data.pfxTable[i], false)
		-- end
	end
	if not Winterblight.CandyCrushBlackStatueTable then
		Winterblight.CandyCrushBlackStatueTable = {}
	end

end

function spectral_witch_apply_think(event)
	local target = event.target
	local caster = event.caster

	local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), caster:GetAbsOrigin())
	local push_speed = (600 - distance)/30
	if push_speed > 0 then
		local push_direction = ((caster:GetAbsOrigin()-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()+push_direction*push_speed)
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, caster:GetAbsOrigin()+push_direction*push_speed, caster)
		if blockUnit then
			push_speed = 0

		else
			caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin() + push_direction*push_speed, caster))
		end
	end
end

function spectral_witch_clear_space(event)
	local caster = event.caster
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function puck_motion_think(event)
	local caster = event.caster
	local newPostion = caster:GetAbsOrigin() + caster.speed*caster.fv
	local impact = false
	local obstruction = WallPhysics:FindNearestObstruction(newPostion)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPostion, caster)
	local normal = Vector(0,0)
	if caster.locked then
		return false
	end
	if blockUnit then
		impact = true
		normal = ((obstruction:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	elseif newPostion.x < 6761 then
		impact = true
		normal = Vector(1,0)
	elseif newPostion.x > 8512 then
		impact = true
		normal = Vector(-1,0)
	elseif newPostion.y < -13330 then
		impact = true
		normal = Vector(0,-1)
	elseif newPostion.y > -9881 then
		if newPostion.x > 7513 and newPostion.x < 7763 then
		else
			impact = true
			normal = Vector(0,1)
		end
	end
	if impact then
		caster.speed = math.max(caster.speed/1.6, 0)
		normal = WallPhysics:rotateVector(normal, math.pi/2)
		local reflectionVector = 2*(normal:Dot(caster.fv, normal))*normal - caster.fv
		caster.fv = reflectionVector:Normalized()
		newPosition = caster:GetAbsOrigin()+(caster.fv*caster.speed*2)
		caster:SetAbsOrigin(newPosition)
		local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight/ice_slip_flash_c.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Winterblight.Puck.WallImpact", caster)
	else
		caster:SetAbsOrigin(newPostion)
	end
	caster:SetForwardVector(WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*caster.rotationSpeed/80))
	caster.rotationSpeed = math.max(caster.rotationSpeed-0.1, caster.speed/30)
	caster.speed = math.max(caster.speed - 0.2, 0)
	if caster.speed == 0 then
		caster:RemoveModifierByName("modifier_winterblight_puck_motion")
	end
	if newPostion.x < 6561 then
		caster:SetAbsOrigin(caster.basePosition)
	elseif newPostion.x > 8712 then
		caster:SetAbsOrigin(caster.basePosition)
	elseif newPostion.y < -13530 then
		caster:SetAbsOrigin(caster.basePosition)
	elseif newPostion.y > -9681 then
		caster:SetAbsOrigin(caster.basePosition)
	end
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(7662, -9780))
	if distance < 140 then
		caster.locked = true
		EmitSoundOn("Winterblight.AzaleaCrystal.FinishPuzzle", caster)
		local walls = Entities:FindAllByNameWithin("PuckGate", Vector(7662, -9780, 300+Winterblight.ZFLOAT), 2400)
	    EmitSoundOnLocationWithCaster(Vector(6539, -15459), "Winterblight.WallOpen", Events.GameMaster)
	    Winterblight:WallsTicks(false, walls, true, 1.4, 260, 0.1)
	    local gate = Entities:FindByNameNearest("PuckGate2", Vector(7650, -9779, 300+Winterblight.ZFLOAT), 500)
	    UTIL_Remove(gate)
	    Winterblight:RemoveBlockers(4, "PuckGateBlocker", Vector(7662, -9780, 300+Winterblight.ZFLOAT), 3800)
	    local flames = Entities:FindAllByClassnameWithin("info_particle_system", Vector(7662, -9780, 300+Winterblight.ZFLOAT), 680)
	    for i = 1, #flames, 1 do
	    	UTIL_Remove(flames[i])
	    end
	    for i = 1, #Winterblight.PuckGuardTable, 1 do
	    	EmitSoundOn("Winterblight.Goalie.Aggro", Winterblight.PuckGuardTable[i])
	    	Winterblight.PuckGuardTable[i]:RemoveModifierByName("modifier_disable_player")
	    	Dungeons:AggroUnit(Winterblight.PuckGuardTable[i])
	    end
	    UTIL_Remove(caster)
		Timers:CreateTimer(3, function()
			local walls = Entities:FindAllByNameWithin("AzaleaWall6", Vector(6539, -10404, -4094+Winterblight.ZFLOAT), 2400)
		    EmitSoundOnLocationWithCaster(Vector(6539, -15459), "Winterblight.WallOpen", Events.GameMaster)
		    Winterblight:WallsTicks(false, walls, true, 5, 360, 0.1)
		    Winterblight:RemoveBlockers(4, "AzaleaWallBlocker3", Vector(6539, -10443, 100+Winterblight.ZFLOAT), 2800)
		    Winterblight:PlatformRoomStartBeacon()
		end)
	end
end

function puck_guard_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.puck_lock then
		return false
	end
	local allies = Entities:FindAllByClassnameWithin("npc_dota_base_additive", caster:GetAbsOrigin(), 130)
	if #allies > 0 then

		for i = 1, #allies, 1 do
			if allies[i].puck then	
				StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=2.1})
				print(allies[i]:GetUnitName())
				Filters:PerformAttackSpecial(caster, allies[i], true, true, true, false, true, false, false)
				local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight/ice_slip_flash_c.vpcf", PATTACH_CUSTOMORIGIN, allies[i] )
				ParticleManager:SetParticleControl( pfx, 0, allies[i]:GetAbsOrigin() )
				ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				caster.puck_lock = true
				caster:SetForwardVector(((allies[i]:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized())
				Timers:CreateTimer(0.5, function()
					caster.puck_lock = false
				end)
				break
			end
		end
	end
end

function puck_guard_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	if target:IsHero() then
		if not target.puckspeed then
			target.puckspeed = 0
		end
		local puckfv = ((target:GetAbsOrigin()-attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		EmitSoundOn("Winterblight.Puck.Impact", target)
		target.puckfv = puckfv
		target.puckspeed = math.min(target.puckspeed + 20, 40)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_winterblight_puck_motion", {duration = 3})
	end
end

function puck_motion_think_guard(event)
	local target = event.target
	if target:HasModifier("modifier_ice_sliding") then
		local newPostion = target:GetAbsOrigin() + target.puckspeed*target.puckfv
		local impact = false
		local obstruction = WallPhysics:FindNearestObstruction(newPostion)
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPostion, target)
		local normal = Vector(0,0)
		if blockUnit then
			impact = true
			normal = ((obstruction:GetAbsOrigin() - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		end
		if impact then
			target.puckspeed = math.max(target.puckspeed/1.6, 0)
			normal = WallPhysics:rotateVector(normal, math.pi/2)
			local reflectionVector = 2*(normal:Dot(target.puckfv, normal))*normal - target.puckfv
			target.puckfv = reflectionVector:Normalized()
			newPosition = target:GetAbsOrigin()+(target.puckfv*target.puckspeed*2)
			target:SetAbsOrigin(newPosition)
			local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight/ice_slip_flash_c.vpcf", PATTACH_CUSTOMORIGIN, target )
			ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			EmitSoundOn("Winterblight.Puck.WallImpact", target)
		else
			target:SetAbsOrigin(newPostion)
		end
	else
		target:RemoveModifierByName("modifier_winterblight_puck_motion")
	end
	target.puckspeed = math.max(target.puckspeed - 0.2, 0)
	if target.puckspeed < 15 then
		target:RemoveModifierByName("modifier_winterblight_puck_motion")
	end	
end

function azalea_beacon_touch(event)
	local caster = event.caster
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		Winterblight:ActivateAzaleaBeacon(event.caster)
	end
end
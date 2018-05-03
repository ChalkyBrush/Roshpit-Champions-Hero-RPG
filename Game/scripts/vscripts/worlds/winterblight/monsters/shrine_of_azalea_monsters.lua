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
		target:SetAbsOrigin(target:GetAbsOrigin() + fv*target.cupSequenceData.jumpVelocity + Vector(0,0,target.cupSequenceData.liftVelocity))
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
			target:SetAbsOrigin(Vector(-219, -14701, 2100+Winterblight.ZFLOAT))
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
		target:SetAbsOrigin(target:GetAbsOrigin()-Vector(0,0,target.cupSequenceData.fallSpeed))
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
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
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(15100, -11100), 1500, 900, false)
	if caster.mainZefnar then
		Winterblight.ZefnarDead = true
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
		Timers:CreateTimer(1, function()
			Timers:CreateTimer(3, function()
				Winterblight:SpawnCup1()
			end)
			
			Winterblight:RemoveBlockers(8.5, "AzaleaBridgeBlocker2", Vector(15104, -12480, 212+Winterblight.ZFLOAT), 5400)
			for i = 1, 300, 1 do
				Timers:CreateTimer(0.03*i, function()
					if i %40 == 0 then
						EmitSoundOnLocationWithCaster(Vector(15733, -11788, 78+Winterblight.ZFLOAT), "Winterblight.AzaleaBridge.Raise", Events.GameMaster)
					end
					Winterblight.AzaleaBridge2:SetAbsOrigin(Winterblight.AzaleaBridge2:GetAbsOrigin()+Vector(0,0,1500/300))
				end)
			end
			Timers:CreateTimer(3, function()
				local walls = Entities:FindAllByNameWithin("AzaleaWall2", Vector(15109, -12332, -4094+Winterblight.ZFLOAT), 2400)
			    EmitSoundOnLocationWithCaster(Vector(15109, -12332), "Winterblight.WallOpen", Events.GameMaster)
			    Winterblight:WallsTicks(false, walls, true, 5, 360, 0.1)
			    Winterblight:RemoveBlockers(4, "AzaleaWallBlockers2", Vector(15104, -12480, 300+Winterblight.ZFLOAT), 1800)
			    Winterblight:ShrineSpawn3()
			end)
			Timers:CreateTimer(9, function()
				EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge2:GetAbsOrigin(), "Winterblight.AzaleaBridge.Finish", Winterblight.Master)
				Timers:CreateTimer(0.1, function()
					EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge2:GetAbsOrigin(), "Winterblight.Azalea.Win", Winterblight.Master)
				end)
				local positionTable = {Vector(14976, -12800), Vector(15085, -12800), Vector(15168, -12800), Vector(15226, -12064), Vector(15136, -12064), Vector(15050, -12064)}
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
			Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, target, "modifier_disable_player", {duration = 0.3})
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
	local ability = event.ability
	if ability.CD == false or ability.CD == nil then
		ability.CD = true
		for i = 1, attacks, 1 do
			Timers:CreateTimer(i*0.1, function()
				Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
				if i == attacks then
					ability.CD = false
				end
			end)
		end
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
		if not attacker:IsHero() then
			return false
		end
		local order =
		{
			UnitIndex = attacker:entindex(),
			OrderType = DOTA_UNIT_ORDER_HOLD_POSITION,
			Queue = true
		}
		attacker:Stop()
		ExecuteOrderFromTable(order)
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
		Timers:CreateTimer(0.2, function()
			Winterblight:PlatformRoomStartBeacon()
		end)
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

function air_spirit_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	if ability:GetCooldownTimeRemaining() == 0 then
		local moveDirection = ((caster:GetAbsOrigin()-attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		moveDirection = WallPhysics:rotateVector(moveDirection, 2*math.pi*RandomInt(-5,5)/60)
		local strafe = ability
		local unit = caster
		local abilityDistance = 700
		ability:StartCooldown(ability:GetCooldownTime())
		strafe:ApplyDataDrivenModifier(unit, unit, "modifier_strafe_sprinting", {duration = 3})
		strafe.fv = moveDirection
		strafe.targetPoint = unit:GetAbsOrigin()+abilityDistance*moveDirection
		strafe.distance = abilityDistance
		strafe.origDistance = abilityDistance
		strafe.canAnimate = true
		if not unit.animLock then
			StartAnimation(unit, {duration=1.0, activity=ACT_DOTA_TELEPORT_END, rate=0.9})
		end
		-- local pfx = ParticleManager:CreateParticle("particles/roshpit/sephyr/strafe_wind.vpcf", PATTACH_CUSTOMORIGIN, nil)
		-- ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin()+Vector(0,0,80)-strafe.fv*200)
		-- ParticleManager:SetParticleControl(pfx, 1, strafe.fv)
		-- ParticleManager:SetParticleControl(pfx, 3, unit:GetAbsOrigin() + strafe.fv*1000)
		-- local time = strafe.distance/1200
		-- Timers:CreateTimer(time, function()
		-- 	ParticleManager:DestroyParticle(pfx, false)
		-- end)
		-- unit:MoveToPosition(unit:GetAbsOrigin()+strafe.fvLock*1)		
	end
end

function air_spirit_strafe_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local targetPoint = ability.targetPoint

	local fv = ability.fv
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+fv*30), caster)
    local forwardSpeed = event.strafe_speed

    -- make scale with level
	if blockUnit then
		forwardSpeed = -10
	end	
	if Filters:HasMovementModifier(caster) then
		forwardSpeed = 0
		caster:RemoveModifierByName("modifier_strafe_sprinting")
		return false
	end
	
	local zfactor = 0
	local distanceFromGround = caster:GetAbsOrigin().z - GetGroundHeight(targetPoint, caster)
	zfactor = -distanceFromGround/5
	caster:SetAbsOrigin(caster:GetAbsOrigin()+fv*forwardSpeed/33+Vector(0,0,zfactor))

	ability.distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)
	-- if not caster:IsChanneling() and not caster:HasModifier("modifier_lightbomb_start_cast") then
	-- 	caster:MoveToPosition(caster:GetAbsOrigin()+ability.fvLock*1)
	-- end
	if ability.distance < 50 or blockUnit then
		caster:RemoveModifierByName("modifier_strafe_sprinting")
		-- if not caster:IsChanneling() and not caster:HasModifier("modifier_lightbomb_start_cast") then
		-- 	caster:MoveToPosition(caster:GetAbsOrigin()+ability.fvLock*5)
		-- end
	end
end

function AmplifyDamageParticleCruxal( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  local particleName = "particles/units/heroes/hero_slardar/axe_d_d_amp_damage.vpcf"
  if target.AmpDamageParticle then
  	ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
  end
-- Particle. Need to wait one frame for the older particle to be destroyed
  Timers:CreateTimer(0.01, function() 
    target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  end)


end

-- Destroys the particle when the modifier is destroyed
function EndAmplifyDamageParticleCruxal( event )
  local target = event.target
  	if target.AmpDamageParticle then
	  ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
	  target.AmpDamageParticle = nil
	end
end

function cruxal_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_cruxal_armor_loss", {duration = 7})
	local stacks = target:GetModifierStackCount("modifier_cruxal_armor_loss", caster)
	target:SetModifierStackCount("modifier_cruxal_armor_loss", caster, stacks + 1)
end

function cruxal_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro and caster:IsAlive() then
		local iceblast = caster:FindAbilityByName("cruxal_ice_blast")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if iceblast:IsFullyCastable() and #enemies > 0 then
			local targetPoint = enemies[1]:GetOrigin() + enemies[1]:GetForwardVector()*RandomInt(80, 320)
			caster.ice_blast_target = targetPoint
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = iceblast:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
end

function cruxal_ice_blast_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

end

function cruxal_die(event)
	local caster = event.caster
	Winterblight.CruxalSlain = true
	EmitSoundOn("Winterblight.Cruxal.Death", caster)
	Winterblight:SpawnCup3()
end

function maze_ghost_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.counter then
		caster.counter = 0
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 300, 3, false)
	if caster:HasModifier("modifier_maze_ghost_frozen") then
		return false
	end
	if caster.lock then
		return false
	end
	local radiusEnemy = 300 + caster.food*8
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radiusEnemy, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	if #enemies > 0 then
		local sumVector = Vector(0,0)
		for i = 1, #enemies, 1 do
			sumVector = sumVector + enemies[i]:GetAbsOrigin()
		end
		local avgVector = sumVector/#enemies
		local runDirection = ((caster:GetAbsOrigin() - avgVector)*Vector(1,1,0)):Normalized()
		local runPosition = caster:GetAbsOrigin()+runDirection*60
		local runPosition2 = WallPhysics:WallSearch(caster:GetAbsOrigin(), runPosition, caster)
		if WallPhysics:GetDistance2d(runPosition, runPosition2) > 0 then
			runPosition = caster:GetAbsOrigin()-runDirection*60
		end
		if not GridNav:IsTraversable(runPosition) then
			runPosition = caster:GetAbsOrigin()-runDirection*160
		end
		if GridNav:FindPathLength(caster:GetAbsOrigin(), runPosition) > (WallPhysics:GetDistance2d(caster:GetAbsOrigin(), runPosition) + 100) then
			runPosition = caster:GetAbsOrigin()-runDirection*160
		end
		local order = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		 		Position = runPosition
	 	}
		ExecuteOrderFromTable(order)
		caster.counter = 0
	else
		caster.counter = caster.counter + 1
		if caster.counter > 30 then
			local order = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			 		Position = caster:GetAbsOrigin()+RandomVector(180)
		 	}
			ExecuteOrderFromTable(order)
			caster.counter = 0
		end
	end	
	local radius = 180 + caster.food*6
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
	for i = 1, #allies, 1 do
		local ally = allies[1]
		if ally:GetUnitName() == "azalea_maze_food" then
			caster.food = caster.food + 1
			caster:SetModelScale(1 + caster.food*0.12)
			CustomAbilities:QuickAttachParticle("particles/econ/items/wisp/wisp_death_ti7.vpcf", caster, 3)
			EmitSoundOn("Winterblight.MazeZombie.EatFood", caster)
			ParticleManager:DestroyParticle(ally.pfx1, false)
			ParticleManager:DestroyParticle(ally.pfx2, false)
			UTIL_Remove(ally)
			if caster.food >= caster.goalFood then
				for j = 1, #Winterblight.foodTable, 1 do
					local food = Winterblight.foodTable[j]
					if IsValidEntity(food) then
						ParticleManager:DestroyParticle(food.pfx1, false)
						ParticleManager:DestroyParticle(food.pfx2, false)
						UTIL_Remove(food)
					end
				end
				caster.lock = true
				StartAnimation(caster, {duration=3.8, activity=ACT_DOTA_DIE, rate=0.9})
				EmitSoundOn("Winterblight.Zombie.Dizzy", caster)
				Timers:CreateTimer(2.0, function()
					EmitSoundOn("Winterblight.Zombie.FallThump", caster)
				end)
				Timers:CreateTimer(3.0, function()
					local boss = Winterblight:SpawnRuptholdTheGlutton(caster:GetAbsOrigin(), caster:GetForwardVector())
					StartAnimation(boss, {duration=2.0, activity=ACT_DOTA_SPAWN, rate=1})
					local position = boss:GetAbsOrigin()
					local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,80))
					ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
					ParticleManager:SetParticleControl(pfx, 2, Vector(0.8,0.8,0.8))
					Timers:CreateTimer(10, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					  ParticleManager:ReleaseParticleIndex(pfx)
					end)
					UTIL_Remove(caster)
				end)
			else
				StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_DIE, rate=1.1})
			end
			break
		end
	end

end

function essence_drain_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local ignoreSuffixList = {
	"charging",
	"jumping",
	"flying",
	"falling",
	"moving",
	"cooldown"
}

	local modifiers = target:FindAllModifiers()
	for i = 1, #modifiers, 1 do
		local continue = true
		if target:IsMagicImmune() then
			return
		end
		local modifier = modifiers[i]
		for _,word in pairs(ignoreSuffixList) do
			if string.find(modifier:GetName(),word) then
				continue = false
			end
		end
		if continue then
			local modifierMaker = modifier:GetCaster()
			if IsValidEntity(modifierMaker) then
				local condition = false
				if modifierMaker:GetTeamNumber() == target:GetTeamNumber() then
					if not WallPhysics:DoesTableHaveValue(Filters:GetUnpurgableBuffNames(), modifier:GetName()) then
						local durationRemaining = modifier:GetRemainingTime()
						if durationRemaining > 0.5 then
							modifier:SetDuration(durationRemaining - 0.1, true)
							local caster_modifier = false
							local stacks = modifier:GetStackCount()
							if not caster:HasModifier(modifier:GetName()) then
								local modifierAbility = modifier:GetAbility()
								if IsValidEntity(modifierAbility) then
									modifierAbility:ApplyDataDrivenModifier(modifier:GetCaster(), caster, modifier:GetName(), {duration = 0.3})
								end
							end
							caster_modifier = caster:FindModifierByName(modifier:GetName())
							if caster_modifier then
								local durationRemaining2 = caster_modifier:GetRemainingTime()
								caster_modifier:SetDuration(durationRemaining2 + 0.2, true)
								caster_modifier:SetStackCount(stacks)
							end
						end
					end
				end
			end
		end
	end
end

function essence_drain_start(event)
	local target = event.target
	StartSoundEvent("Winterblight.DemonSpirit.DrainEvent", target)
end

function essence_drain_end(event)
	local target = event.target
	StopSoundEvent("Winterblight.DemonSpirit.DrainEvent", target)
end

function maze_food_crystal_hit(event)
	local caster = event.caster
	if not caster.lock then
		caster.lock = true
		local position = caster:GetAbsOrigin()
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/act_2/flying_shatter_blast_explosion.vpcf", caster:GetAbsOrigin(), 3)
		for i = 1, 6, 1 do
			ParticleManager:SetParticleControl(pfx, i, caster:GetAbsOrigin())
		end
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.CandyCrystal.Shatter", Winterblight.Master)
		for i = 1, #caster.foodPositionTable, 1 do
			Winterblight:SpawnMazeFood(caster.foodPositionTable[i])
		end
		 for i = 0, 1, 1 do
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
		UTIL_Remove(caster)
	end
end

function megmus_start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.ShrineMegmus.Aggro", caster)
	StartSoundEvent("Winterblight.Megmus.Channel", caster)
end



function megmus_channel_complete(event)
	local caster = event.caster
	local ability = event.ability
	-- CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", caster, 7)
	local castLoops = 0
	for i = 0, castLoops, 1 do
		Timers:CreateTimer(i*2, function()
			EmitSoundOn("Winterblight.Megmus.Ability", caster)
			local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(600, 2, 2))
			StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.8})
			local stunDuration = event.stun_duration

			StopSoundEvent("Winterblight.Megmus.Channel", caster)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 520, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			local damage = event.damage
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
					Filters:ApplyStun(caster, stunDuration, enemy)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_megmus_slow", {duration = 6})
				end
			end 
			
			Timers:CreateTimer(6, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end


function megmus_channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Winterblight.Megmus.Channel", caster)
end

function maze_ghost_frozen_attacked(event)
	local caster = event.caster
	local ability = event.ability
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/ice_shatter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	EmitSoundOn("Winterblight.IceCrystal.Shatter", caster)
	caster:RemoveModifierByName("modifier_maze_ghost_frozen")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_maze_ghost_attack_immune", {})
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function rupthold_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.summonPhase then
		caster.summonPhase = 0
	end
	if not caster:IsAlive() then
		return false
	end
	if caster:GetHealth()/caster:GetMaxHealth() < (1-caster.summonPhase*0.1) then
		caster.summonPhase = caster.summonPhase + 1
		local baseVector = caster:GetForwardVector()
		EmitSoundOn("Winterblight.Rupthold.Summon", caster)
		local spawns = 4 + GameState:GetDifficultyFactor()
		for i = 0, spawns, 1 do
			local pfxName = "particles/items_fx/white_zap_beam.vpcf"
			local spawnPosition = caster:GetAbsOrigin() + WallPhysics:rotateVector(baseVector, 2*math.pi*i/spawns)*300
			local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,120))
			ParticleManager:SetParticleControl(pfx, 1, spawnPosition)
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			Winterblight:SpawnRuptholdGhost(spawnPosition, baseVector)
		end
	end
end

function rupthold_death(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.Rupthold.Death", caster)
	Winterblight.RuptholdSlain = true
	Winterblight:SpawnCup4()
	Timers:CreateTimer(3, function()
		Winterblight:RuptholdWall()
	end)
end

function ghost_aura_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_ghost_aura_stacks", {duration = 3})
	local stacks = attacker:GetModifierStackCount("modifier_ghost_aura_stacks", caster) + 1
	attacker:SetModifierStackCount("modifier_ghost_aura_stacks", caster, stacks)
	if stacks == 10 then
		attacker:RemoveModifierByName("modifier_ghost_aura_stacks")
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_ghost_aura_disarm", {duration = event.disarm_duration})
	end

end

function regression_strike_hit(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local attack_power_mult = event.attack_power_mult
	local damage = OverflowProtectedGetAverageTrueAttackDamage(target)*attack_power_mult/100
	ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })	
	CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/regression_strike.vpcf", target, 5)
	EmitSoundOn("Monster.RegressionStrike", target)
end

function triple_boss_attacked(event)
	local caster = event.caster
	local ability = event.ability
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/ice_shatter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	EmitSoundOn("Winterblight.IceCrystal.Shatter", caster)
	caster:RemoveModifierByName("modifier_azalea_triple_boss_frozen")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {})

	if not Winterblight.TriBossStarterCount then
		Winterblight.TriBossStarterCount = 0
		Winterblight.TriBossTable = {}
		Winterblight.TriBossTable.array = {}
	end

	local anim = 0
	local jumpVO = ""
	local target_point = Vector(0,0)
	if caster:GetUnitName() == "winterblight_buzuki" then
		EmitSoundOn("Winterblight.TriBoss.Buzuki.Aggro", caster)
		target_point = GetGroundPosition(Vector(-5828, -11125, 286), Events.GameMaster)
		anim = ACT_DOTA_VICTORY
		jumpVO = "Winterblight.TriBoss.Buzuki.Pain"
		Winterblight.TriBossTable.Buzuki = caster
	elseif caster:GetUnitName() == "winterblight_azertia" then
		EmitSoundOn("Winterblight.TriBoss.Azertia.Aggro", caster)
		target_point = GetGroundPosition(Vector(-6400, -11125, 286), Events.GameMaster) 
		anim = ACT_DOTA_CAST_ABILITY_4
		jumpVO = "Winterblight.TriBoss.Azertia.Pain"
		Winterblight.TriBossTable.Azertia = caster
	elseif caster:GetUnitName() == "winterblight_torphet" then
		EmitSoundOn("Winterblight.TriBoss.Torphet.Aggro", caster)
		target_point = GetGroundPosition(Vector(-6973, -11125, 286), Events.GameMaster) 
		anim = ACT_DOTA_CAST_ABILITY_4
		jumpVO = "Winterblight.TriBoss.Torphet.Pain"
		Winterblight.TriBossTable.Torphet = caster
	end
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	caster.jumpVO = jumpVO
	caster.anim = anim
	table.insert(Winterblight.TriBossTable.array, caster)
	if caster:GetUnitName() == "winterblight_torphet" then
		StartAnimation(caster, {duration=2.2, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
	else
		StartAnimation(caster, {duration=2.2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
	end
	Timers:CreateTimer(2.5, function()
		local eventTable = {}
		eventTable.caster = caster
		eventTable.ability = ability
		eventTable.target_points = {}
		eventTable.anim = anim
		eventTable.target_points[1] = target_point
		eventTable.jumpVO = jumpVO
		AddFOWViewer(DOTA_TEAM_GOODGUYS, target_point, 600, 10000, false)
		Winterblight:azalea_jump_start(eventTable)
		Timers:CreateTimer(3, function()
			caster:MoveToPosition(target_point)
			Timers:CreateTimer(2.5, function()
				caster:MoveToPosition(caster:GetAbsOrigin()+Vector(0,-10))
				Winterblight.TriBossStarterCount = Winterblight.TriBossStarterCount + 1
				if Winterblight.TriBossStarterCount == 3 then
					Winterblight:TriBossInit()
				end
				Timers:CreateTimer(3, function()
					if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target_point) > 200 then
						caster:SetAbsOrigin(target_point)
					end
				end)
			end)
		end)
	end)	
end



function azalea_jump_think(event)
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
			caster:RemoveModifierByName("modifier_azalea_jump")
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
	if ability.interval%6 == 0 then
		local pfx = ParticleManager:CreateParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(0.4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function azalea_jump_end(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", caster, 3)
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
end

function torphet_summoning_think(event)
	local target = event.target
	print("SEQUENCE 3 GOING")
	target.cupSequenceData.fallSpeed = math.max(target.cupSequenceData.fallSpeed-0.35, 10)
	print(target.cupSequenceData.fallSpeed)
	target:SetOrigin(target:GetAbsOrigin()-Vector(0,0,target.cupSequenceData.fallSpeed))
	print(target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target))
	if target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target) < 40 then

		target:RemoveModifierByName("modifier_azalea_triboss_entering")

		-- EmitSoundOn("Winterblight.AzaleaCup.Land", target)
		-- ParticleManager:DestroyParticle(target.cupSequenceData.pfx, false)
		-- local pfx2 = ParticleManager:CreateParticle("particles/roshpit/winterblight/azalea_explosion_magical.vpcf", PATTACH_CUSTOMORIGIN, nil)
		-- ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin())
		-- ParticleManager:SetParticleControl(pfx2, 2, Vector(90, 200, 255))
		-- Timers:CreateTimer(3.5, function()
		-- 	ParticleManager:DestroyParticle(pfx2, false)
		-- end)
	end
end

function torphet_summoned_unit_die(event)
	Winterblight.TriBossSpawnKills = Winterblight.TriBossSpawnKills + 1
	if Winterblight.TriBossSpawnKills == Winterblight.TriBossSpawnGoal - 1 then
		local newIndex = Winterblight.TriBossPhase + 1
		Winterblight:TriBossPhaser(newIndex)
	end
end

function torphet_powering_up_think(event)
	local target = event.target
	local caster = event.caster
	target:SetModelScale(target:GetModelScale()+0.01)
	local newStacks = target:GetModifierStackCount("modifier_triboss_powered_up_multiple", caster) + 1
	target:SetModifierStackCount("modifier_triboss_powered_up_multiple", casters, newStacks)
end

function tri_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	local stoneReduce = 0
	if Winterblight.Stones == 3 then
		stoneReduce = 1
	end
	if caster.lock then
		return false
	end
	if caster:GetHealth() < 1000 then
		caster.lock = true
		tri_boss_death_sequence(event)
	end
	local luck = RandomInt(1, 12-GameState:GetDifficultyFactor()-stoneReduce)
	if luck == 1 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1300+GameState:GetDifficultyFactor()*200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		local target_point = nil
		if #enemies > 0 then
			target_point = enemies[1]:GetAbsOrigin()+RandomVector(RandomInt(540, 1500))
			local eventTable = {}
			eventTable.caster = caster
			eventTable.ability = ability
			eventTable.target_points = {}
			eventTable.anim = caster.anim
			eventTable.target_points[1] = GetGroundPosition(target_point, caster)
			eventTable.jumpVO = caster.jumpVO
			Winterblight:azalea_jump_start(eventTable)
		else
			target_point = caster:GetAbsOrigin()+caster:GetForwardVector()*600+Vector(0,0,100)
		end
	end
	if caster:GetUnitName() == "winterblight_buzuki" then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local hexAbility = caster:FindAbilityByName("buzuki_hex")
			if hexAbility:IsFullyCastable() then		
				local order = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = hexAbility:entindex(),
			 	}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	elseif caster:GetUnitName() == "winterblight_torphet" then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local coldfeet = caster:FindAbilityByName("torphet_cold_feet")
			if coldfeet:IsFullyCastable() then		
				local order = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = coldfeet:entindex(),
			 	}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local vortex = caster:FindAbilityByName("torphet_ice_vortex")
			if vortex:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(50, 420))			
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = vortex:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	elseif caster:GetUnitName() == "winterblight_azertia" then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local ice_orb = caster:FindAbilityByName("winterblight_ice_orb")
			if ice_orb:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(0, 130))			
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ice_orb:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		local blink = caster:FindAbilityByName("winterblight_summoner_blink")
		if blink:IsFullyCastable() then		
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = blink:entindex()
			}
			ExecuteOrderFromTable(order)
			return false
		end
		
	end
end

function tri_boss_death_sequence(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {})
	caster:RemoveModifierByName("modifier_triboss_in_battle")
	local delay = 0
	if not Winterblight.TriBossesKilled then
		Winterblight.TriBossesKilled = 0
	end
	Winterblight.TriBossesKilled = Winterblight.TriBossesKilled + 1
	if Winterblight.TriBossesKilled < 3 then
		if caster:GetUnitName() == "winterblight_buzuki" then
			delay = 6
			local dialogueEnemies = FindUnitsInRadius( Winterblight.TriBossTable.Buzuki:GetTeamNumber(),caster:GetAbsOrigin(), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			EmitSoundOn("Winterblight.TriBoss.Buzuki.Powerup.Start", Winterblight.TriBossTable.Buzuki)
			StartSoundEvent("Winterblight.TriBoss.Buzuki.Powerup.LP", Winterblight.TriBossTable.Buzuki)
			Quests:ShowDialogueTextAzalea(dialogueEnemies, Winterblight.TriBossTable.Buzuki, "buzuki_powerup", 4, false)
			StartAnimation(Winterblight.TriBossTable.Buzuki, {duration=5, activity=ACT_DOTA_VICTORY, rate=1})
			Timers:CreateTimer(0.8, function()
				EmitSoundOn("Winterblight.TriBoss.Buzuki.Powerup.Laugh", Winterblight.TriBossTable.Buzuki)
			end)
			for i = 1, #Winterblight.TriBossTable.array, 1 do
				local buddy = Winterblight.TriBossTable.array[i]
				if IsValidEntity(buddy) and not buddy.lock then
					if buddy == caster then
					else

						local ability = Winterblight.TriBossTable.Buzuki:FindAbilityByName("winterblight_azalea_triple_boss_ability")
						ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Buzuki, buddy, "modifier_triboss_powering_up", {duration = 5})
						ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Buzuki, buddy, "modifier_triboss_powered_up_multiple", {})
						ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Buzuki, buddy, "modifier_triboss_powered_up_single", {})

						Timers:CreateTimer(5, function()
							StopSoundEvent("Winterblight.TriBoss.Buzuki.Powerup.LP", Winterblight.TriBossTable.Buzuki)
						end)					
					end
				end
			end
			local pos = caster:GetAbsOrigin()
			Timers:CreateTimer(5, function()
				local luck = RandomInt(1, 7-GameState:GetPlayerPremiumStatusCount())
				if luck == 1 then
					RPCItems:RollBuzukisFinger(pos)
				end
			end)
		elseif caster:GetUnitName() == "winterblight_azertia" then
			delay = 2.5
			local abilityTable = {"ability_mega_haste", "winterblight_generic_chill_attack_passive", "winterblight_wolf_ability", "winterblight_ogre_armor", "winterblight_frostiok_passive", "winterblight_frost_colossus_passive", "winterblight_snowshaker_passive", "winterblight_bear_passive", "winterblight_stun_regen", "winterblight_frostbite_attack", "luna_taskmaster_shield", "winterblight_dimension_spear", "winterblight_speed_softening", "winterblight_armor_softening"}
			if GameState:GetDifficultyFactor() >= 2 then
				table.insert(abilityTable, "seafortress_golden_shell")
			end
			if GameState:GetDifficultyFactor() == 3 then
				table.insert(abilityTable, "creature_pure_strike")
			end
			local selectedAbility = abilityTable[RandomInt(1, #abilityTable)]
			StartAnimation(Winterblight.TriBossTable.Azertia, {duration=2.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.9})
			local dialogueEnemies = FindUnitsInRadius( Winterblight.TriBossTable.Azertia:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			Quests:ShowDialogueTextAzalea(dialogueEnemies, Winterblight.TriBossTable.Azertia, "DOTA_Tooltip_Ability_"..selectedAbility, 4, false)
			EmitSoundOnLocationWithCaster(Winterblight.TriBossTable.Azertia:GetAbsOrigin(), Winterblight.TriBossTable.Azertia.jumpVO, Winterblight.TriBossTable.Azertia)
			for i = 1, #Winterblight.TriBossTable.array, 1 do
				local buddy = Winterblight.TriBossTable.array[i]
				if IsValidEntity(buddy) and not buddy.lock then
					if buddy == caster then
					else
						EmitSoundOn("Winterblight.TriBoss.Azertia.AddAbility", buddy)
						Timers:CreateTimer(0.6, function()
							local pfxName = "particles/items_fx/white_zap_beam.vpcf"
							local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
							EmitSoundOn("Winterblight.Rupthold.Summon", buddy)
							ParticleManager:SetParticleControlEnt(pfx, 0, Winterblight.TriBossTable.Azertia, PATTACH_POINT_FOLLOW, "attach_attack1", Winterblight.TriBossTable.Azertia:GetAbsOrigin(), true)
							ParticleManager:SetParticleControl(pfx, 1, buddy:GetAbsOrigin()+Vector(0,0,60))
							buddy:AddAbility(selectedAbility):SetLevel(GameState:GetDifficultyFactor())
							StartAnimation(buddy, {duration=2.5, activity=ACT_DOTA_ATTACK, rate=0.9})
							Timers:CreateTimer(1.5, function()
								ParticleManager:DestroyParticle(pfx, false)
							end)
						end)
					end
				end
			end
		elseif caster:GetUnitName() == "winterblight_torphet" then
			delay = 5.5
			local unitTable = {"winterblight_crystal_malefor", "azalea_grave_summoner", "winterblight_bladewielder", "azalea_shrine_megmus", "winterblight_demon_spirit", "azalea_knife_scraper", "azalea_dragoon", "winterblight_syphist", "winterblight_azalea_secret_keeper", "frostiok", "azalea_ghost_striker", "winterblight_azalea_mindbreaker", "winterblight_azalea_highguard", "azalea_armored_knight", "winterblight_softwalker", "winterblight_cold_seer", "winterblight_source_revenant", "winterblight_maiden_of_azalea", "winterblight_rider_of_azalea", "winterblight_mistral_assassin", "winterblight_frost_frigid_hulk", "winterblight_frost_elemental", "winterblight_frost_avatar", "winterblight_ice_summoner", "winterblight_snow_shaker", "winterblight_frigid_growth", "winterblight_chilling_colossus", "winterblight_dashing_swordsman", "winterblight_azalean_priest", "winterblight_azalea_archer"}
			local selectedUnit = unitTable[RandomInt(1, #unitTable)]
			local dialogueEnemies = FindUnitsInRadius( Winterblight.TriBossTable.Torphet:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			Quests:ShowDialogueTextAzalea(dialogueEnemies, Winterblight.TriBossTable.Torphet, selectedUnit, 4, false)
			EmitSoundOnLocationWithCaster(Winterblight.TriBossTable.Torphet:GetAbsOrigin(), Winterblight.TriBossTable.Torphet.jumpVO, Winterblight.TriBossTable.Torphet)
			StartAnimation(Winterblight.TriBossTable.Torphet, {duration=4.5, activity=ACT_DOTA_TELEPORT, rate=1})
			EmitSoundOn("Winterblight.TriBoss.Torphet.Summoning", Winterblight.TriBossTable.Torphet)
			local multiplier = Winterblight:GetPotentialMultiplierForBuzuki(selectedUnit)
			local unitCount = multiplier*2 + (GameState:GetDifficultyFactor()-1)*4 + Winterblight.Stones
			for i = 1, unitCount, 1 do
				local spawnPosition = caster:GetAbsOrigin()+RandomVector(RandomInt(240, 1500))
				local summon = Winterblight:SpawnAzaleaUnitByName(selectedUnit, spawnPosition)
				AddFOWViewer(DOTA_TEAM_GOODGUYS, summon:GetAbsOrigin(), 600, 10, false)
				local ability = Winterblight.TriBossTable.Torphet:FindAbilityByName("winterblight_azalea_triple_boss_ability")
				summon.cantAggro = true
				ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, summon, "modifier_disable_player", {})
				summon:SetAbsOrigin(summon:GetAbsOrigin()+Vector(0,0,2000))
				ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, summon, "modifier_azalea_triboss_entering", {})
				
				ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, Winterblight.TriBossTable.Torphet, "modifier_torphet_summoning", {duration = 5})
				summon.cupSequenceData = {}
				summon.cupSequenceData.interval = 0
				summon.cupSequenceData.fallSpeed = 30
				EmitSoundOn("Winterblight.AzaleaCup.Falling", caster)
				Timers:CreateTimer(1, function()
					StartAnimation(summon, {duration=5.5, activity=ACT_DOTA_SPAWN, rate=0.6})
				end)
				local pfx = ParticleManager:CreateParticle( "particles/winterblight/cup_falling_particle.vpcf", PATTACH_CUSTOMORIGIN, nil )
				local colorVector = Vector(100, 200, 255)
				ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(summon:GetAbsOrigin(), summon) )
				ParticleManager:SetParticleControl( pfx, 1, colorVector )
				ParticleManager:SetParticleControl( pfx, 2, colorVector )
				ParticleManager:SetParticleControl( pfx, 3, colorVector )
				summon.summonPFX = pfx
				CustomAbilities:QuickParticleAtPoint("particles/act_2/siltbreaker_beam_channel.vpcf", Vector(-219, -14701, 150+Winterblight.ZFLOAT), 3)
				Timers:CreateTimer(5.5, function()
					summon:RemoveModifierByName("modifier_disable_player")
					summon.cantAggro = false
					Dungeons:AggroUnit(summon)
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end
		end
		Timers:CreateTimer(delay, function()
			caster:RemoveModifierByName("modifier_disable_player")
			caster:SetHealth(10)
			caster:ForceKill(true)
		end)
	else
		caster:RemoveModifierByName("modifier_disable_player")
		caster:SetHealth(10)
		caster:ForceKill(true)
		if Winterblight.TriBossesKilled == 3 then
			Winterblight:TriBossesAllSlain()
		end
	end
end

function begin_ice_orb(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local position = caster:GetAbsOrigin() + caster:GetForwardVector()*90
	local orb = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
	orb:SetAbsOrigin(orb:GetAbsOrigin()+Vector(0,0,100))

	orb:FindAbilityByName("dummy_unit"):SetLevel(1)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.TriBoss.Azertia.Cast", caster)
	orb.interval = 0
	ability:ApplyDataDrivenModifier(caster, orb, "modifier_ice_orb_orb", {})
	orb.fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	EmitSoundOn("Winterblight.TriBoss.Azertia.IceCast", caster)
	EmitSoundOn("Winterblight.TriBoss.Azertia.IceOrbTravel", orb)
end

function ice_orb_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local orb = target
	if orb.lock then
		return false
	end
	if IsValidEntity(orb) then
		if orb.interval then
			orb.interval = orb.interval + 1
			orb:SetAbsOrigin(orb:GetAbsOrigin()+orb.fv*30)
			local enemies = FindUnitsInRadius( orb:GetTeamNumber(), orb:GetAbsOrigin(), nil, 130, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				EmitSoundOn("Winterblight.TriBoss.Azertia.IceOrbImpact", enemies[1])
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })	
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_orb_freeze", {duration = 0.2})
				end
			end 
			local shardInterval = 9-GameState:GetDifficultyFactor()
			if orb.interval%shardInterval == 0 then
				local fv = RandomVector(1)
				local info = 
				{
						Ability = ability,
			        	EffectName = "particles/econ/items/mirana/mirana_crescent_arrow/sorceress_ice_lance.vpcf",
			        	vSpawnOrigin = orb:GetAbsOrigin()+orb.fv*90,
			        	fDistance = 1400,
			        	fStartRadius = 120,
			        	fEndRadius = 120,
			        	Source = caster,
			        	StartPosition = "attach_origin",
			        	bHasFrontalCone = false,
			        	bReplaceExisting = false,
			        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			        	iUnitTargetFlags = 0,
			        	iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
			        	fExpireTime = GameRules:GetGameTime() + 5.0,
					bDeleteOnHit = false,
					vVelocity = fv * 800,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end
			if orb.interval >= 100 then
				orb:RemoveModifierByName("modifier_ice_orb_orb")
				orb.lock = true
				UTIL_Remove(orb)
			end
		end
	end
end

function ice_orb_lance_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
    local particleName = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
    local origin = target:GetAbsOrigin()
    ParticleManager:SetParticleControl( particle1, 0, origin )
    ParticleManager:SetParticleControl( particle1, 1, origin )
    Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    EmitSoundOn("Winterblight.TriBoss.Azertia.IceOrbLanceHit", target)
    ApplyDamage({ victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
end

function buzuki_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_triboss_in_battle") then
		local range = event.range
		local damage = event.damage
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			EmitSoundOn("Winterblight.TriBoss.Buzuki.PassiveHit", caster)
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
			    local particle1 = ParticleManager:CreateParticle("particles/roshpit/winterblight/blue_finger.vpcf", PATTACH_CUSTOMORIGIN, target )
			    ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin()+Vector(0,0,80) )
			    ParticleManager:SetParticleControl( particle1, 1, enemy:GetAbsOrigin()+Vector(0,0,80) )
			    Timers:CreateTimer(1, function()
			    	ParticleManager:DestroyParticle(particle1, false)
			    end)
			end
		end 	
	end
end

function mystery_fairy_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if caster.lock or caster.lock2 then
		return false
	end
	caster.interval = caster.interval + 1
	if caster.doorOpen then
		local goalPos = Vector(-13056, -13312)
		if caster.interval %50 == 0 then
			caster:MoveToPosition(goalPos)
		end
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), goalPos)
		if distance < 90 then
			caster.lock = true
			-- EmitSoundOn("Winterblight.Pixie.Mystery1", caster)
			StartAnimation(caster, {duration=1.35, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
			Timers:CreateTimer(0.5, function()
				EmitSoundOn("Winterblight.Pixie.Laugh2", caster)
			end)
			Timers:CreateTimer(1.5, function()
				EmitSoundOn("Winterblight.Pixie.OpenGrunt", caster)
				StartAnimation(caster, {duration=5.0, activity=ACT_DOTA_CAST_ABILITY_5, rate=0.5})
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", caster, 5)
				for i = 0, 4, 1 do
					Timers:CreateTimer(i, function()
						CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell.vpcf", Vector(-13045, -13504), 5)
					end)
				end
				Timers:CreateTimer(0.5, function()
					local walls = Entities:FindAllByNameWithin("AzaleaStarWall", Vector(-13045, -13504, -121+Winterblight.ZFLOAT), 2000)
				    EmitSoundOnLocationWithCaster(Vector(-13045, -13504, 273+Winterblight.ZFLOAT), "Winterblight.Pixie.WallOpen", Events.GameMaster)
				    Winterblight:Walls(false, walls, false, 4.3)
				    Winterblight:RemoveBlockers(4, "AzaleaStarBlocker", Vector(-13004, -13485, -90+Winterblight.ZFLOAT), 2000)
				end)
				Timers:CreateTimer(2, function()
				    local positionTable = {Vector(-13824, -13952), Vector(-13312, -13952), Vector(-12800, -13952), Vector(-12245, -13952)}
				    for i = 1, #positionTable, 1 do
				      local lookToPoint = (Vector(-13045, -13567) - positionTable[i]):Normalized()
				      local unit = Winterblight:SpawnStarSeeker(positionTable[i], lookToPoint)
				      CustomAbilities:QuickAttachParticle("particles/roshpit/mountain_protector/steelforge_start_teleport_ti7_out.vpcf", unit, 3)
				    end
				    Winterblight:SpawnStargazerOrin(Vector(-12928, -14916), Vector(0,1))
				end)
				Timers:CreateTimer(4.9, function()
					caster.lock2 = true
					caster.lock = false
					pixie_sequence(caster, nil)
				end)
			end)
		end
		return false
	end
	if caster.phase > 0 then
		if caster.interval == 100 then
			local enemiesFAR = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			for i = 1, #enemiesFAR, 1 do
				local distance = WallPhysics:GetDistance2d(enemiesFAR[i]:GetAbsOrigin(), caster:GetAbsOrigin())
				if distance > 350 then

					local pfxName = "particles/units/heroes/hero_wisp/wisp_tether_green.vpcf"
					local direction = WallPhysics:normalized_2d_vector(enemiesFAR[i]:GetAbsOrigin(), caster:GetAbsOrigin())
					local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, enemiesFAR[i]:GetAbsOrigin()+Vector(0,0,70))
					ParticleManager:SetParticleControl(pfx, 1, enemiesFAR[i]:GetAbsOrigin()+Vector(0,0,70) + direction*(distance/1600)*550)
					EmitSoundOn("Winterblight.Pixie.Indicator", enemiesFAR[i])
					Timers:CreateTimer(0.4, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end
			end
		end
		local enemiesCLOSE = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemiesCLOSE > 0 then
			caster:RemoveNoDraw()
			local distance = WallPhysics:GetDistance2d(enemiesCLOSE[1]:GetAbsOrigin(), caster:GetAbsOrigin())
			if distance < 90 then
				caster:SetModelScale(1.0)
				caster.phase = caster.phase + 1
				if caster.phase < 5 then
					local newPos = Winterblight:GetRandomPixieLocation()
					pixie_sequence(caster, newPos)
				else
					caster.lock = true
					EmitSoundOn("Winterblight.Pixie.Mystery1", caster)
					StartAnimation(caster, {duration=1.35, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
					Timers:CreateTimer(0.5, function()
						EmitSoundOn("Winterblight.Pixie.Laugh", caster)
					end)
					Timers:CreateTimer(1, function()
						caster.lock = false
						caster.doorOpen = true
					end)
				end
				return false
			else
				local scale = (400-distance)/400
				caster:SetModelScale(scale)
			end
		else
			caster:SetModelScale(0)
			caster:AddNoDraw()
		end		
	else
		if caster.interval%30 == 0 then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				caster.phase = caster.phase + 1
				local newPos = Winterblight:GetRandomPixieLocation()
				pixie_sequence(caster, newPos)
				return false
			end
		end
	end
	if caster.interval >= 100 then
		caster.interval = 0
	end
end

function pixie_sequence(caster, targetPosition)
	if caster.lock then
		return false
	end
	caster.lock = true
	EmitSoundOn("Winterblight.Pixie.Mystery1", caster)
	StartAnimation(caster, {duration=1.35, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
	Timers:CreateTimer(0.5, function()
		if caster.doorOpen then
			EmitSoundOn("Winterblight.Pixie.Laugh3", caster)
		else
			EmitSoundOn("Winterblight.Pixie.Laugh", caster)
		end
	end)
	Timers:CreateTimer(1.35, function()
		StartAnimation(caster, {duration=3.0, activity=ACT_DOTA_TAUNT, rate=1.0, translate="rope"})
		Timers:CreateTimer(1.2, function()
			EmitSoundOn("Winterblight.Pixie.Grunt", caster)
		end)
		local pixie_fv = caster:GetForwardVector()
		Timers:CreateTimer(1.8, function()
			Winterblight:smoothSizeChange(caster, 1, 0.1, 19)
			Timers:CreateTimer(0.6, function()
				if caster.doorOpen then
					local pos = caster:GetAbsOrigin()
					caster:SetModelScale(0)
					local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(pfx, 1, Vector(600, 2, 2))
					local pfx2 = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx2, 0, pos+Vector(0,0,80))
					ParticleManager:SetParticleControl(pfx2, 5, Vector(0.9, 0.9, 1.0))
					ParticleManager:SetParticleControl(pfx2, 2, Vector(0.8,0.8,0.8))
					EmitSoundOn("Winterblight.Pixie.Teleport", caster)
					Timers:CreateTimer(0.2, function()
						UTIL_Remove(caster)
					end)
					return false
				else
					local pos = caster:GetAbsOrigin()
					caster:SetModelScale(0)
					local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(pfx, 1, Vector(600, 2, 2))
					local pfx2 = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx2, 0, pos+Vector(0,0,80))
					ParticleManager:SetParticleControl(pfx2, 5, Vector(0.9, 0.9, 1.0))
					ParticleManager:SetParticleControl(pfx2, 2, Vector(0.8,0.8,0.8))
					EmitSoundOn("Winterblight.Pixie.Teleport", caster)
					caster:SetAbsOrigin(GetGroundPosition(targetPosition, caster)+Vector(0,0,80))
					FindClearSpaceForUnit(caster, targetPosition, false)
					caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,80))
					Timers:CreateTimer(1.0, function()
						caster.lock = false
					end)
					local pixie_summon_table = {}
					for i = 1, 6, 1 do
						local fv = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/6)
						local summon = Winterblight:SpawnPixieMinion(pos+fv*120, pixie_fv)
						table.insert(pixie_summon_table, summon)
						FindClearSpaceForUnit(summon, summon:GetAbsOrigin(), false)
					end
					for j = 1, 10, 1 do
						local fv = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*j/10)
						local summon = Winterblight:SpawnPixieMinion(pos+fv*240, pixie_fv)
						table.insert(pixie_summon_table, summon)
						FindClearSpaceForUnit(summon, summon:GetAbsOrigin(), false)
					end
					for i = 1, #pixie_summon_table, 1 do
						pixie_summon_table[i].buddyTable = pixie_summon_table
					end
					Timers:CreateTimer(0.5, function()
						EmitSoundOnLocationWithCaster(pos, "Winterblight.Pixie.AfterPort", Events.GameMaster)
					end)
					Timers:CreateTimer(3, function()
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:DestroyParticle(pfx2, false)
					end)
				end
			end)
		end)
	end)
end

function mystery_summon_attack(event)
	local attacker = event.attacker
	local target = event.target
	local health_set = event.health_set
	if target:GetHealth() > health_set then
		target:SetHealth(health_set)
	end
end

function RealityRiftPosition( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin() 
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local min_range = ability:GetLevelSpecialValueFor("min_range", ability_level) 
	local max_range = ability:GetLevelSpecialValueFor("max_range", ability_level)
	local reality_rift_particle = keys.reality_rift_particle

	-- Position calculation
	local distance = (target_location - caster_location):Length2D() 
	local direction = (target_location - caster_location):Normalized()
	local target_point = RandomFloat(min_range, max_range) * distance
	local target_point_vector = caster_location + direction * target_point

	-- Particle
	local particle = ParticleManager:CreateParticle(reality_rift_particle, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_location, true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
	ParticleManager:SetParticleControl(particle, 2, target_point_vector)
	ParticleManager:SetParticleControlOrientation(particle, 2, direction, Vector(0,1,0), Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(particle) 

	-- Save the location
	ability.reality_rift_location = target_point_vector
	ability.reality_rift_direction = direction
end

--[[Author: Pizzalol
	Date: 09.04.2015.
	Relocates the target, caster and any illusions under the casters control]]
function RealityRift( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local player = caster:GetPlayerOwnerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local bonus_duration = ability:GetLevelSpecialValueFor("bonus_duration", ability_level) 
	local illusion_search_radius = ability:GetLevelSpecialValueFor("illusion_search_radius", ability_level) 
	local bonus_modifier = keys.bonus_modifier
	
	-- Set the positions to be one on each side of the rift
	target:SetAbsOrigin(ability.reality_rift_location - ability.reality_rift_direction * 25)
	caster:SetAbsOrigin(ability.reality_rift_location + ability.reality_rift_direction * 25)

	-- Set the targets to face eachother
	target:SetForwardVector(ability.reality_rift_direction)
	caster:Stop() 
	caster:SetForwardVector(ability.reality_rift_direction * -1)

	-- Add the phased modifier to prevent getting stuck
	target:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.03})
	caster:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.03})

	-- Execute the attack order for the caster
	local order =
	{
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = target:entindex(),
		Queue = true
	}

	ExecuteOrderFromTable(order)


end

function star_prophecy_start(event)
	local caster = event.caster
	local target = event.target
	StartSoundEvent("Winterblight.StarProphecy.LP", target)
	target.starprophecystacks = 0
end

function star_prophecy_debuff_attack_land(event)
	local caster = event.caster
	local target = event.target
	local attacker = event.attacker
	local modifier = attacker:FindModifierByName("modifier_star_prophecy_debuff")
	local current_duration = modifier:GetRemainingTime()
	local duration = current_duration + 0.3
	modifier:SetDuration(duration, true)
	local newstacks = modifier:GetStackCount() + tonumber(event.stack_add)
	modifier:SetStackCount(newstacks)
	attacker.starprophecystacks = newstacks
end

function star_prophecy_spell_cast(event)
	local caster = event.caster
	local target = event.unit
	local attacker = event.unit
	local modifier = attacker:FindModifierByName("modifier_star_prophecy_debuff")
	local current_duration = modifier:GetRemainingTime()
	print(current_duration)
	local duration = current_duration + 0.8
	modifier:SetDuration(duration, true)
	local newstacks = modifier:GetStackCount() + tonumber(event.stack_add)
	modifier:SetStackCount(newstacks)
	attacker.starprophecystacks = newstacks
end

function star_prophecy_end(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	if not IsValidEntity(caster) then
		caster = Events.GameMaster
		ability = Events.GameMasterAbility
		damage = Events.GameMasterAbility:GetSpecialValueFor("star_prophecy_damage")
	end
	StopSoundEvent("Winterblight.StarProphecy.LP", target)
	local stacks = target.starprophecystacks
	if stacks > 0 then
		for i = 1, stacks, 1 do
			Timers:CreateTimer(i*0.1, function()
		      local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
		      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
		      ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		      Timers:CreateTimer(0.6, function() 
		        ParticleManager:DestroyParticle( pfx, false )
		      end)  
	          Timers:CreateTimer(0.45, -- Start this timer 10 game-time seconds later
	          function()
	            if target:IsAlive() then
	              ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })	
	              EmitSoundOn("Winterblight.StarProphecy.Impact", target)
	            end
	          end)
			end)
		end
	end
end

function starseeker_think(event)
	local caster = event.caster
	local ability = event.ability
	local caster = event.caster
	local starcast = caster:FindAbilityByName("winterblight_star_prophecy")
	if caster.aggro then
		local casting = false
		if starcast:IsFullyCastable() then
			local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
			local target_types = DOTA_UNIT_TARGET_HERO
			local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for i = 1, #enemies, 1 do
					if not enemies[i]:HasModifier("modifier_star_prophecy_debuff") then
						local newOrder = {
					 		UnitIndex = caster:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					 		TargetIndex = enemies[i]:entindex(),
					 		AbilityIndex = starcast:entindex(),
					 	}
						ExecuteOrderFromTable(newOrder)		
						casting = true
						break		
					end
				end	
			end
		end
		if not casting then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 340+GameState:GetDifficultyFactor()*100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local sumVector = Vector(0,0)
				for i = 1, #enemies, 1 do
					sumVector = sumVector + enemies[i]:GetAbsOrigin()
				end
				local avgVector = sumVector/#enemies
				local runDirection = ((caster:GetAbsOrigin() - avgVector)*Vector(1,1,0)):Normalized()
				caster:MoveToPosition(caster:GetAbsOrigin()+runDirection*380)
			end
		end
	end	
end

function spinesplitter_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
	if not caster:IsAlive() then
		return false
	end
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			local enemy = enemies[i]
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_spinesplitter_stack", {duration = 2})
			if not enemy:IsStunned() then
				local modifier = enemy:FindModifierByName("modifier_spinesplitter_stack")
				local newstacks = modifier:GetStackCount() + 1
				modifier:SetStackCount(newstacks)
				if newstacks >= 50 then
					Timers:CreateTimer(0.4, function()
						enemy:RemoveModifierByName("modifier_spinesplitter_stack")
					end)
					EmitSoundOn("Winterblight.SpineSplitter.BoltThrow", caster)
					local info = 
					{
						Target = enemy,
						Source = caster,
						Ability = ability,	
						EffectName =  "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
						StartPosition = "attach_hitloc",
						bDrawsOnMinimap = false, 
					        bDodgeable = true,
					        bIsAttack = false, 
					        bVisibleToEnemies = true,
					        bReplaceExisting = false,
					        flExpireTime = GameRules:GetGameTime() + 8,
						bProvidesVision = true,
						iVisionRadius = 0,
						iMoveSpeed = 800,
						iVisionTeamNumber = caster:GetTeamNumber()
					}
					projectile = ProjectileManager:CreateTrackingProjectile(info)
				end
			end
		end
	end
	-- "modifier_spinesplitter_stack"
end

function stargazer_think(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	if caster:GetHealth() < 1000 then
		if not caster.phase2 then
			caster:AddNewModifier(caster, nil, "modifier_animation", {translate="injured"})
			caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="injured"})
			EmitSoundOn("Winterblight.StarGazer.LowHealth", caster)
			-- caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
		-- 	Timers:CreateTimer(0.5, function()
		-- 		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		-- 		Timers:CreateTimer(0.03, function()
		-- 			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		-- 		end)
		-- 	end)
		end
		caster.phase2 = true
	end
	if not ability.interval then
		ability.interval = 0
	end
	if not caster.lastPos then
		caster.lastPos = Vector(0,0,0)
	end
	if (ability.interval%50 == 0 and ability.interval > 0) and caster.phase2 and caster.wavePhase and (caster.wavePhase < 1) then
		if caster.lastPos == caster:GetAbsOrigin() then
			local point = Vector(-11699, -10174) + GetGroundHeight(Vector(-11699, -10174), caster)+Vector(0,0,10)
			local pfx1 = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin()+Vector(0,0,100))
			local pfx2 = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx2, 0, point+Vector(0,0,10))
			-- sound doesn't play, can't fix
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "rubick_rubick_failure_01", caster)
			EmitSoundOnLocationWithCaster(point, "rubick_rubick_failure_01", caster)
			caster:SetAbsOrigin(point)
			caster:SetForwardVector(Vector(-1,0))
			Timers:CreateTimer(5, function()
				ParticleManager:DestroyParticle(pfx2, true)
				ParticleManager:ReleaseParticleIndex(pfx1)
				ParticleManager:DestroyParticle(pfx2, true)
				ParticleManager:ReleaseParticleIndex(pfx1)
			end)
			Timers:CreateTimer(0.5, function()
				caster:MoveToPosition(caster:GetAbsOrigin()-Vector(5,0))
			end)
		else
			caster.lastPos = caster:GetAbsOrigin()
		end
	end
	ability.interval = ability.interval+1
	if ability.interval % 1 == 0 then
		local position = caster:GetAbsOrigin()+RandomVector(RandomInt(150, 2000))
		position = GetGroundPosition(position, caster)
		if not caster.cometLock then
			begin_stargazer_comet(caster, ability, position, damage)
		end
	end
	if not caster.phase2 then
		local hookAbility = caster:FindAbilityByName("stargazer_glissade")
		if hookAbility:IsFullyCastable() and caster.aggro then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 1500))			
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
	else
		stargazer_phase_2_think(event)
	end
	if ability.interval >= 100 then
		ability.interval = 0
	end
end

function stargazer_debuff_think(event)
	local caster = event.caster
	if not IsValidEntity(caster) then
		return false
	end
	if caster.phase2 then
		return false
	end
	if caster:IsAlive() and caster.aggro then
		local ability = event.ability
		local target = event.target
		if not target.gazer_interval then
			target.gazer_interval = 0
		end
		target.gazer_interval = target.gazer_interval + 1
		local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), caster:GetAbsOrigin())
		local modulos = math.max(((2000-distance)/2000)*10, 1)
		if target.gazer_interval >= modulos then
			target.gazer_interval = 0
			local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			Timers:CreateTimer(0.6, function() 
				ParticleManager:DestroyParticle( pfx, false )
			end)  
			Timers:CreateTimer(0.45,
			function()
				if target:IsAlive() then
				  ApplyDamage({ victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })	
				  EmitSoundOn("Winterblight.StarProphecy.Impact", target)
				end
			end)
		end
	end
end

function begin_stargazer_comet(caster, ability, target, damage)
	local castParticle = "particles/roshpit/solunia/comet_cast_moon.vpcf"
	local explodeParticle = "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
	local starParticle = "particles/roshpit/winterblight/stargazer_comet_attack.vpcf"

	local cast_direction = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/wisp/wisp_relocate_marker_ti7_endpoint_ring.vpcf", target, 2.45)
	Timers:CreateTimer(2, function()
		-- local pfx = ParticleManager:CreateParticle(castParticle, PATTACH_CUSTOMORIGIN, nil)
		-- ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		-- Timers:CreateTimer(4, function()
		-- 	ParticleManager:DestroyParticle(pfx, false)
		-- 	ParticleManager:ReleaseParticleIndex(pfx)
		-- end)
		-- EmitSoundOnLocationWithCaster(target, "Solunia.Arcana1.Comet", caster)
		CustomAbilities:QuickParticleAtPoint(starParticle, target, 4)
		local stun_duration = 1.5
		Timers:CreateTimer(0.45, function()
			local pfx = ParticleManager:CreateParticle(explodeParticle, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, target)
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end)

			if not ability.soundLock then
				EmitSoundOnLocationWithCaster(target, "Winterblight.StarGazer.CometImpact", nil)
				ability.soundLock = true
				Timers:CreateTimer(0.2, function()
					ability.soundLock = false
				end)
			end
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target, nil, 170, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
					Filters:ApplyStun(caster, stun_duration, enemy)
				end
			end 
		end)
	end)
end

function stargazer_volcanic_glissade(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]
	
	ability.targetPoint = target
	if caster:GetUnitName() ==  "azalea_boss" then
		EmitSoundOn("Winterblight.AzaleaBoss.AttackStart.VO", caster)
	else
		EmitSoundOn("Winterblight.StarGazer.Glissade.VO", caster)
	end
	EmitSoundOn("Winterblight.StarGazer.Glissade.Go", caster)
	if caster:GetUnitName() ==  "azalea_boss" then
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_VERSUS, rate=2})
		local pfxTest = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_ice_path.vpcf", PATTACH_CUSTOMORIGIN, nil)
		local moveFV = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,1)):Normalized()
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)
		ParticleManager:SetParticleControl(pfxTest, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfxTest, 1, caster:GetAbsOrigin()+moveFV*distance)
		ParticleManager:SetParticleControl(pfxTest, 2, Vector(1,1,1))
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfxTest, false)
		end)
	else
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_FLAIL, rate=0.5, translate="forcestaff_friendly"})
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_volcanic_glissade", {duration = 1.6})
    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )

    ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( particle1, 1, Vector(200, 2, 1000) )
    ParticleManager:SetParticleControl( particle1, 3, Vector(200, 550, 550) )
    Timers:CreateTimer(4, function()
    	ParticleManager:DestroyParticle(particle1, false)
    end)
end

function stargazer_glissade_thinking(event)
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
	    Timers:CreateTimer(0.03, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end
end

function stargazer_phase_2_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.wavePhase then
		caster.wavePhase = 0
	end
	local orbPos = Vector(-12971, -14614, 670+Winterblight.ZFLOAT)
	local portalPositionTable = {Vector(-13824, -13184), Vector(-12360, -13052), Vector(-13952, -12416), Vector(-12544, -12160), Vector(-14208, -11648), Vector(-13056, -10880), Vector(-14592, -10496), Vector(-14464, -8832), Vector(-12928, -9088), Vector(-11648, -8576)}
	if caster.wavePhase == 0 then
		caster:MoveToPosition(Vector(-11699, -10174))
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(-11699, -10174))
		if distance < 90 then
			AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-11699, -10174), 700, 3000, false)
			AddFOWViewer(DOTA_TEAM_GOODGUYS, orbPos, 300, 3000, false)
			caster:Stop()
			caster:MoveToPosition(caster:GetAbsOrigin()+Vector(-5,0))
			Timers:CreateTimer(0.03, function()
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_stargazer_stopped", {})
			end)
			EmitSoundOn("Winterblight.StarGazer.Move.VO", caster)
			for i = 0, 4, 1 do
				Timers:CreateTimer(1.6*i, function()
					StartAnimation(caster, {duration=1.55, activity=ACT_DOTA_CAST_ABILITY_6, rate=0.75})
				end)
			end
			caster.wavePhase = 1
			caster.beamTable = {}
			local orbPFX = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_ambient.vpcf", PATTACH_CUSTOMORIGIN, nil)
			for i = 0, 3, 1 do
				ParticleManager:SetParticleControl(orbPFX, i, orbPos)
			end

			caster.orbBeamPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, nil)
			caster.orbBeamPos = orbPos
			ParticleManager:SetParticleControl(caster.orbBeamPFX, 0, orbPos)
		end
	elseif caster.wavePhase == 1 then
		local fv = (caster:GetAbsOrigin()-caster.orbBeamPos):Normalized()
		caster.orbBeamPos = caster.orbBeamPos + fv*100
		Winterblight.orbBeamPFX = caster.orbBeamPFX
		Winterblight.Stargazer = caster
		AddFOWViewer(DOTA_TEAM_GOODGUYS, caster.orbBeamPos, 200, 5, false)
		ParticleManager:SetParticleControl(caster.orbBeamPFX, 1, caster.orbBeamPos)
		if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.orbBeamPos) < 200 then
			caster.wavePhase = 2
			ParticleManager:SetParticleControlEnt(caster.orbBeamPFX, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
			for i = 1, #portalPositionTable, 1 do
				local beamData = {}
				beamData.targetPoint = GetGroundPosition(portalPositionTable[i], caster) + Vector(0,0,30)
				beamData.startingPoint = caster:GetAbsOrigin()
				beamData.position = caster:GetAbsOrigin()
				beamData.fv = (beamData.targetPoint - caster:GetAbsOrigin()):Normalized()
				beamData.moving = true
				beamData.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether_agh.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(beamData.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
				table.insert(caster.beamTable, beamData)
			end
			EmitSoundOn("Winterblight.StarGazer.BeamStart", caster)
			caster.beamsCompleted = 0
		end
	elseif caster.wavePhase == 2 then
		for i = 1, #caster.beamTable, 1 do
			local beamData = caster.beamTable[i]
			if beamData.moving then
				beamData.position = beamData.position + beamData.fv*100
				AddFOWViewer(DOTA_TEAM_GOODGUYS, beamData.position, 200, 2, false)
				ParticleManager:SetParticleControl(beamData.pfx, 1, beamData.position)
				local distance = WallPhysics:GetDistance2d(beamData.position, beamData.targetPoint)
				if distance < 150 then
					beamData.moving = false
					local soundCaster = Events.GameMaster
					if i%3 == 1 then
						soundCaster = caster
					elseif i%3 == 2 then
						soundCaster = Winterblight.Master
					end
					EmitSoundOnLocationWithCaster(beamData.targetPoint, "Winterblight.StarGazer.PortalParticleStart", caster)
					ParticleManager:SetParticleControl(beamData.pfx, 1, beamData.targetPoint)
					caster.beamsCompleted = caster.beamsCompleted + 1
					AddFOWViewer(DOTA_TEAM_GOODGUYS, beamData.targetPoint, 400, 3000, false)
					beamData.portalParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(beamData.portalParticle, 0, beamData.targetPoint)
					CustomAbilities:QuickParticleAtPoint("particles/items_fx/blink_dagger_start.vpcf", beamData.targetPoint, 5)
					if caster.beamsCompleted == 10 then
						Timers:CreateTimer(3.5, function()
							Winterblight:StartStarGazerWaveEvent(caster.beamTable)
						end)
						caster.wavePhase = 3
					end
				end
			end
		end
	elseif caster.wavePhase == 3 then
	end
end

function charging_taskmaster_passive(event)
	local caster = event.caster
	local ability = event.ability
	local stacks = event.stacks
	if not caster:IsAlive() then
		return false
	end
	local modifier_name = "modifier_luna_armor"
	StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_FLAIL, rate=1.5})
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for i = 1, #allies, 1 do
			local ally = allies[i]
			if ally:HasModifier("modifier_luna_armor") then
			elseif ally:HasModifier("modifier_luna_armor") and i == #allies then
				ability:ApplyDataDrivenModifier(caster, ally, modifier_name, {duration = 5})
				ally:SetModifierStackCount("modifier_luna_armor", caster, stacks)
				break
			else
				EmitSoundOn("Winterblight.WinterSpirit.ShieldApply", caster)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_f.vpcf", caster, 3)
				ability:ApplyDataDrivenModifier(caster, ally, modifier_name, {duration = 5})
				ally:SetModifierStackCount("modifier_luna_armor", caster, stacks)
				break
			end
		end
	end
end

function giga_ice_revenant_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.fv then
		ability.fv = Vector(0,1)
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	ability.fv = WallPhysics:rotateVector(ability.fv, 2*math.pi/8)
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin() + ability.fv*30,
        	fDistance = 1000,
        	fStartRadius = 140,
        	fEndRadius = 300,
        	Source = caster,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = 0,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = ability.fv * 800,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)	
	if ability.interval%3 == 0 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin()+ability.fv*600, "Winterblight.IceBeam", caster)
	end
	if ability.interval%4 == 0 then
		EmitSoundOn("Winterblight.GigaIce.Path", caster)
		local iceDistance = 600+GameState:GetDifficultyFactor()*200
		local perpFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/4)
		for i = -1, 1, 1 do
			local pfxTest = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_ice_path.vpcf", PATTACH_CUSTOMORIGIN, nil)
			
			ParticleManager:SetParticleControl(pfxTest, 0, caster:GetAbsOrigin()-caster:GetForwardVector()*300+perpFV*i*180)
			ParticleManager:SetParticleControl(pfxTest, 1, caster:GetAbsOrigin()+caster:GetForwardVector()*iceDistance+perpFV*i*180)
			ParticleManager:SetParticleControl(pfxTest, 2, Vector(2,2,2))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfxTest, false)
			end)
		end
		for j = 0, 19, 1 do
			Timers:CreateTimer(j*0.1, function()
				local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin()-caster:GetForwardVector()*0, caster:GetAbsOrigin()+caster:GetForwardVector()*(iceDistance-400), nil, 540, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
				for _,enemy in pairs(enemies) do
					local duration = 2 - (j/10)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_giga_ice_chilled", {duration = duration})
				end
			end)
			
		end
	end
	if ability.interval >= 100 then
		ability.interval = 0
	end
end

function giga_ice_revenant_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	if not attacker:HasModifier("modifier_giga_ice_pulling") then
		local distance = WallPhysics:GetDistance2d(attacker:GetAbsOrigin(), caster:GetAbsOrigin())
		if distance > 1000 then
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_f.vpcf", attacker, 3)
			EmitSoundOn("Winterblight.GigaIce.Pull", attacker)
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_giga_ice_pulling", {duration = 5})
			attacker.gigaIceBeamPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether_agh.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(attacker.gigaIceBeamPFX, 0, caster, PATTACH_POINT_FOLLOW, "attach_static", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(attacker.gigaIceBeamPFX, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
		end
	end
end

function giga_ice_wave_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target:HasModifier("modifier_giga_ice_rooted") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_giga_ice_rooted", {duration = event.root_duration})
	end
end

function giga_ice_pull_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target:IsAlive() then
		return false
	end
	local fv = (caster:GetAbsOrigin()-target:GetAbsOrigin()):Normalized()
	target:SetAbsOrigin(target:GetAbsOrigin() + fv*40)
	local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), caster:GetAbsOrigin())
	if distance < 600 then
		target:RemoveModifierByName("modifier_giga_ice_pulling")
	end
end

function giga_ice_pull_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ParticleManager:DestroyParticle(target.gigaIceBeamPFX, false)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function azalea_boss_attack_start(event)
	local caster = event.caster
	local luck = RandomInt(1, 4)
	if luck == 1 then
		EmitSoundOn("Winterblight.AzaleaBoss.AttackStart.VO", caster)
	end
end

function azalea_boss_attack_land(event)
	local caster = event.caster
	local victim = event.target
	local ability = event.ability
	local damage = (event.damage/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)
    local icePoint = victim:GetAbsOrigin()
    local radius = 500
    EmitSoundOn("Winterblight.AzaleaBoss.AttackLand", victim)
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
            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_azalea_boss_slow", {duration = 3})
            ApplyDamage({ victim = victim, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
        end
    end
end

function azalea_boss_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	print("HELLO?")
	if not attacker:HasModifier("modifier_giga_ice_pulling") then
		if WallPhysics:IsWithinRegionA(attacker:GetAbsOrigin(), Vector(-2341, -16256), Vector(2126, -12703)) then
		else
			print("HELLO2?")
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_f.vpcf", attacker, 3)
			EmitSoundOn("Winterblight.GigaIce.Pull", attacker)
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_giga_ice_pulling", {duration = 5})
			attacker.gigaIceBeamPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether_agh.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(attacker.gigaIceBeamPFX, 0, caster, PATTACH_POINT_FOLLOW, "attach_static", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(attacker.gigaIceBeamPFX, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
		end
	end
end

function azalea_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.phase then
		caster.phase = 0
	end
	if not ability.interval then
		ability.interval = 0
	end
	if caster.dying then
		return false
	end
	if caster:GetHealth() < 1000 and not caster.phaseLock then
		caster.phaseLock = true
		caster.phase = caster.phase + 1
		if caster.phase == 3 and GameState:GetDifficultyFactor() < 3 then
			Winterblight:AzaleaBossDie(caster)
			return false
		elseif caster.phase == 4 then
			Winterblight:AzaleaBossDie(caster)
			return false
		end
		EmitSoundOn("Winterblight.AzaleaBoss.IceHealStart", caster)
		
		if caster.phase == 1 then
			caster:AddAbility("azalea_boss_multi_strike"):SetLevel(GameState:GetDifficultyFactor())
			caster:AddAbility("stargazer_glissade"):SetLevel(GameState:GetDifficultyFactor())
			caster:FindAbilityByName("stargazer_glissade"):StartCooldown(3.6)
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {duration = 14})
		Timers:CreateTimer(14, function()
			caster.phaseLock = false
			EmitSoundOn("Winterblight.AzaleaBoss.IceHealEnd", caster)
			local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,100))
			ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
			ParticleManager:SetParticleControl(pfx, 2, Vector(0.8,0.8,0.8))
			Timers:CreateTimer(10, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			  ParticleManager:ReleaseParticleIndex(pfx)
			end)
			if caster.phase == 1 then
				Timers:CreateTimer(1.5, function()
					EmitSoundOn("Winterblight.AzaleaBoss.EndHeal.VO", caster)
				end)
			elseif caster.phase == 2 then
				caster:AddAbility("azalea_ice_orb_passive"):SetLevel(GameState:GetDifficultyFactor())
				caster:FindAbilityByName("stargazer_glissade"):StartCooldown(3.6)
			elseif caster.phase == 3 then
				caster:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_azalea_phase_4", {})
				caster:FindAbilityByName("stargazer_glissade"):StartCooldown(3.6)
				Timers:CreateTimer(1, function()
					EmitSoundOn("Winterblight.AzaleaBoss.Phase3.VO", caster)
				end)
			end
		end)
	end
	ability.interval = ability.interval + 1
	if ability.interval == 50 then
		local ices = 7 + caster.phase*2
		for i = 0, ices, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/ices)
			fv = WallPhysics:rotateVector(fv, 2*math.pi*RandomInt(-3, 3)/50)
			local target = caster:GetAbsOrigin()+fv*RandomInt(300, 1600)
			target = GetGroundPosition(target, caster)
			local cast_direction = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/azalea_indicator_ring.vpcf", target, 3)
			EmitSoundOnLocationWithCaster(target, "Winterblight.AzaleaBoss.IceNovaStart", caster)
			Timers:CreateTimer(3, function()
				local icePoint = target
				local damage = 10
				local radius = 600
			    EmitSoundOnLocationWithCaster(icePoint, "Winterblight.AzaleaBoss.IceNovaExplode", caster)
			    local particle = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			    local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
			    ParticleManager:SetParticleControl( pfx, 0, icePoint )
			    ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
			    Timers:CreateTimer(2.5, function()
			        ParticleManager:DestroyParticle(pfx, false)
			    end)
			    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), icePoint, nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			    if #enemies > 0 then    
			        for _,enemy in pairs(enemies) do
			            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_giga_ice_rooted", {duration = 2})
			            ApplyDamage({ victim = victim, attacker = caster, damage = event.nova_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
			        end
			    end
			end)
		end
	end
	if caster:HasAbility("azalea_boss_multi_strike") then
	local spin = caster:FindAbilityByName("azalea_boss_multi_strike")
		if spin:IsFullyCastable() then		
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = spin:entindex()
			}
			ExecuteOrderFromTable(order)
		end
	end
	if not caster:HasModifier("modifier_azalea_spinning") then
		if caster:HasAbility("stargazer_glissade") then
			local glissade = caster:FindAbilityByName("stargazer_glissade")
			if glissade:IsFullyCastable() then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 1500))			
					local order =
					{
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = glissade:entindex(),
						Position = targetPoint
					}
					ExecuteOrderFromTable(order)
					return false
				end
			end
		end
	end
	if ability.interval >= 80 then
		ability.interval = 0
	end
end

function azalea_ice_orb_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.dying then
		return false
	end
	local orb_count = 3 + Winterblight.Stones
	if caster.phase == 3 then
		orb_count = orb_count + 1
	end
	local baseFV = RandomVector(1)
	for i = 0, orb_count - 1, 1 do 
		local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/orb_count)
		local position = caster:GetAbsOrigin() + fv*90
		local orb = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
		orb:SetAbsOrigin(orb:GetAbsOrigin()+Vector(0,0,100))

		orb:FindAbilityByName("dummy_unit"):SetLevel(1)

		orb.interval = 0
		ability:ApplyDataDrivenModifier(caster, orb, "modifier_ice_orb_orb", {})
		orb.fv = fv
		EmitSoundOn("Winterblight.TriBoss.Azertia.IceOrbTravel", orb)
	end

end

function azalea_boss_frozen_think(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetHealth(caster:GetHealth() + caster:GetMaxHealth()*0.0075)
end

function azalea_spin_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.interval = 0
	ability.attacks = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_azalea_spinning", {duration = 1.5})
	StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_SPAWN, rate=0.6})
	WallPhysics:Jump(caster, caster:GetForwardVector(), 0, 25, 15, 0.8)
	EmitSoundOn("Winterblight.AzaleaBoss.SpinAttack.VO", caster)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Winterblight.AzaleaBoss.Spin.Whirl", caster)
	end)
end

function azalea_spinning_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.interval = ability.interval + 1
	local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/18)
	caster:SetForwardVector(fv)
	if ability.interval%4 == 0 and ability.attacks < 5 then
		ability.attacks = ability.attacks + 1
		if ability.attacks == 1 then
			EmitSoundOn("Winterblight.AzaleaBoss.AttackStart", caster)
		end
		CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_e_cowlofice.vpcf", caster, 5)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
			end
		end 
	end
end

function boss_death_effect_think(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/boss_exploding.vpcf", caster, 3)
	EmitSoundOn("Winterblight.AzaleaBoss.DeathEffect", caster)
end

function azheran_die(event)
	local hero = event.unit
	local caster = event.caster
	local ability = event.ability
	AddFOWViewer(hero:GetTeamNumber(), hero:GetAbsOrigin(), 500, 6, false)
	EmitSoundOn("Winterblight.Azheran.Die.VO", hero)
	Timers:CreateTimer(3, function()
		local position = hero:GetAbsOrigin()
		for i = 0, 3, 1 do
			Timers:CreateTimer(0.1*i, function()
			    local particleName = "particles/roshpit/winterblight/snow_impact.vpcf"
			    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, nil)
			    ParticleManager:SetParticleControl(particle1,0,caster:GetAbsOrigin())
			    Timers:CreateTimer(1, function()
			    	ParticleManager:DestroyParticle( particle1, false )
			    end)
			end)
		end
		RPCItems:RollFrozenHeart(position)
		EmitSoundOn("RPCItems.FrozenHeart.Shatter", hero)
	    local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
	    local radius = 500
	    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )
	    ParticleManager:SetParticleControl( particle1, 0, position )
	    ParticleManager:SetParticleControl( particle1, 1, Vector(radius, 1, 800) )
	    ParticleManager:SetParticleControl( particle1, 3, Vector(radius, radius, radius) )
	    Timers:CreateTimer(3, function()
	        ParticleManager:DestroyParticle(particle1, false)
	    end)
		hero:SetAbsOrigin(hero:GetAbsOrigin()-Vector(0,0,2500))

	end)
end

function azheran_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_iceblood_stack", {})
	local newStacks = caster:GetModifierStackCount("modifier_iceblood_stack", caster) + 1
	if newStacks >= 8 then
		caster:RemoveModifierByName("modifier_iceblood_stack")
		local damage = event.damage
	    local icePoint = caster:GetAbsOrigin()
	    local radius = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), attacker:GetAbsOrigin())
	    EmitSoundOnLocationWithCaster(icePoint, "Winterblight.AzaleaBeacon.Activate", caster)
	    local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	    local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
	    ParticleManager:SetParticleControl( pfx, 0, icePoint )
	    ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
	    Timers:CreateTimer(2.5, function()
	        ParticleManager:DestroyParticle(pfx, false)
	    end)
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	    if #enemies > 0 then    
	        for _,enemy in pairs(enemies) do
	            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chilled", {duration = 3})
	            ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
	        end
	    end
	else
		caster:SetModifierStackCount("modifier_iceblood_stack", caster, newStacks)
	end
end

function orthok_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local radius = caster:GetAttackRange()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
		end
	end 
end

function orthok_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = caster:GetAttackRange()
	if not caster.initialized then
		radius = 500
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if caster.lock then
		return false
	end
	if not caster:HasModifier("modifier_water_emperor_submerged") then
		caster:SetModelScale(3) 
	end
	if caster:HasModifier("modifier_water_emperor_submerged") then
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		caster:SetModelScale(0.1)
	end
	if #enemies > 0 then
		if caster:HasModifier("modifier_water_emperor_submerged") then
			caster.initialized = true
			caster:RemoveModifierByName("modifier_water_emperor_submerged")
			print("RISE!")
			local animationDuration = 2
			StartAnimation(caster, {duration=animationDuration, activity=ACT_DOTA_SPAWN, rate=0.5})
			-- for i = 1, 17, 1 do
			-- 	Timers:CreateTimer(0.03*i, function()
			-- 		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,34))
			-- 	end)
			-- end
			Timers:CreateTimer(0.18, function()
			    local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			    local radius = 260
			    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )
			    local origin = caster:GetAbsOrigin()
			    ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,20) )
			    ParticleManager:SetParticleControl( particle1, 1, Vector(radius, 1, 1000) )
			    ParticleManager:SetParticleControl( particle1, 3, Vector(500, 500, 500) )
			    Timers:CreateTimer(3, function()
			        ParticleManager:DestroyParticle(particle1, false)
			    end)
			    EmitSoundOn("Winterblight.SkaterFiend.SuicideCrash", caster)
				Timers:CreateTimer(4, 
				function()
					ParticleManager:DestroyParticle( particle1, false )
				end)
			end)
			Timers:CreateTimer(1.2, function()
				if not caster:HasModifier("modifier_water_emperor_submerged") then
					EmitSoundOn("Winterblight.Orthok.Mad", caster)
				end
			end)
		end
	else
		if not caster:HasModifier("modifier_water_emperor_submerged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_emperor_submerged", {})
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1}) 
			for i = 1, 17, 1 do
				Timers:CreateTimer(0.03*i, function()
					if not caster.lock then
						caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,34))
					end
				end)
				Timers:CreateTimer(0.18, function()
				    local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
				    local radius = 260
				    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )
				    local origin = caster:GetAbsOrigin()
				    ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,20) )
				    ParticleManager:SetParticleControl( particle1, 1, Vector(radius, 1, 1000) )
				    ParticleManager:SetParticleControl( particle1, 3, Vector(500, 500, 500) )
				    Timers:CreateTimer(3, function()
				        ParticleManager:DestroyParticle(particle1, false)
				    end)
				    EmitSoundOn("Winterblight.SkaterFiend.SuicideCrash", caster)
					Timers:CreateTimer(4, 
					function()
						ParticleManager:DestroyParticle( particle1, false )
					end)
					Timers:CreateTimer(0.35, function()
						if caster:HasModifier("modifier_water_emperor_submerged") then
							FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
							caster:SetModelScale(0.1)
						end
					end)
				end)
			end
		end
	end
end

function orthok_min_health_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lock then
		return false
	end
	if caster:GetHealth() < 1000 then
		caster.lock = true
		if caster.phase == 1 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_orthok_blue", {})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_orthok_leaving", {})
			Winterblight:smoothSizeChange(caster, 3, 1, 40)
			for i = 1, 100, 1 do
				Timers:CreateTimer(i*0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,6))
				end)
			end
			Timers:CreateTimer(3, function()
				EmitSoundOn("Winterblight.Orthok.Mad", caster)
			end)
			Timers:CreateTimer(4.0, function()
				local icePoint = caster:GetAbsOrigin()
				local radius = 600
			    EmitSoundOnLocationWithCaster(icePoint, "Winterblight.AzaleaBoss.IceNovaExplode", caster)
			    local particle = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			    local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, nil )
			    ParticleManager:SetParticleControl( pfx, 0, icePoint )
			    ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
			    Timers:CreateTimer(2.5, function()
			        ParticleManager:DestroyParticle(pfx, false)
			    end)			
				local position = Winterblight:GetRandomOrthokPosition()
				Winterblight:SpawnOrthok(position, Vector(0,-1), 2)
				UTIL_Remove(caster)
			end)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_orthok_blue", {})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_orthok_leaving", {})
			Winterblight:smoothSizeChange(caster, 3, 1, 40)
			for i = 1, 100, 1 do
				Timers:CreateTimer(i*0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,6))
				end)
			end
			Timers:CreateTimer(3, function()
				EmitSoundOn("Winterblight.Orthok.Mad", caster)
			end)
			Timers:CreateTimer(4.0, function()
				local icePoint = caster:GetAbsOrigin()
				local radius = 600
			    EmitSoundOnLocationWithCaster(icePoint, "Winterblight.AzaleaBoss.IceNovaExplode", caster)
			    local particle = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			    local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, nil )
			    ParticleManager:SetParticleControl( pfx, 0, icePoint )
			    ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
			    Timers:CreateTimer(2.5, function()
			        ParticleManager:DestroyParticle(pfx, false)
			    end)	
			    local immortals = 2 + GameState:GetPlayerPremiumStatusCount()
			    RPCItems:RollChainsOfOrthok(icePoint)
				for i = 1, immortals, 1 do
					Timers:CreateTimer(i*0.5, function()
						RPCItems:RollItemtype(100, icePoint, 5, 100)
					end)
				end
				UTIL_Remove(caster)
			end)
		end
	end
end

function captain_reynar_attacked(event)
	local caster = event.caster
	local ability = event.ability
	caster.phase = 0
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/ice_shatter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	EmitSoundOn("Winterblight.IceCrystal.Shatter", caster)
	caster:RemoveModifierByName("modifier_maze_ghost_frozen")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_reynar_ai", {})
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_VICTORY, rate=0.9})
	Timers:CreateTimer(0.7, function()
		EmitSoundOn("Winterblight.CaptainReynar.Free.VO", caster)
	end)
end

function captain_reynar_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local targetPos = caster:GetAbsOrigin()
	if caster.lock then
		return false
	end
	if caster.phase == 0 then
		targetPos = Vector(-224, -7680)
	elseif caster.phase == 1 then
		targetPos = Vector(3712, -6656)
	elseif caster.phase == 2 then
		targetPos = Vector(10624, -8320)
	elseif caster.phase == 3 then
		targetPos = Vector(11147, -11136)
	end
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	caster:MoveToPosition(targetPos)
	if WallPhysics:GetDistance2d(targetPos, caster:GetAbsOrigin()) < 120 then
		if caster.phase == 0 then
			if Winterblight.IceWallShattered then
				caster.phase = 1
			end
		elseif caster.phase == 1 then
			if Winterblight.CaveIceWallDestroyed then
				caster.phase = 2
			end
		elseif caster.phase == 2 then
			if Winterblight.AzaleaEntranceBridgeRaised then
				caster.phase = 3
			end
		elseif caster.phase == 3 then
			caster.phase = 4
			caster.lock = true
			StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_VICTORY, rate=0.9})
			Timers:CreateTimer(0.2, function()
				EmitSoundOn("Winterblight.CaptainReynar.Free.VO", caster)
			end)
			-- Winterblight.MasterCrystal
			for i = 1, 20, 1 do
				Timers:CreateTimer(i*0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,-15, 5))
				end)
			end
			Timers:CreateTimer(0.5, function()
				Winterblight:objectShake(caster, 40, 5, true, false, true, nil, 1)
				Timers:CreateTimer(1, function()
					local moveVector = (Winterblight.MasterCrystal:GetAbsOrigin()-caster:GetAbsOrigin())/16
					for i = 1, 16, 1 do
						Timers:CreateTimer(i*0.03, function()
							caster:SetAbsOrigin(caster:GetAbsOrigin()+moveVector)
						end)
					end
					Timers:CreateTimer(0.6, function()
						local icePoint = caster:GetAbsOrigin()
						local radius = 600
					    EmitSoundOnLocationWithCaster(icePoint, "Winterblight.AzaleaBoss.IceNovaExplode", caster)
					    local particle = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
					    local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, nil )
					    ParticleManager:SetParticleControl( pfx, 0, icePoint )
					    ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
					    Timers:CreateTimer(2.5, function()
					        ParticleManager:DestroyParticle(pfx, false)
					    end)
					    RPCItems:RollCaptainsVest(icePoint)
						UTIL_Remove(caster)
					end)
				end)
			end)
		end
	end
end
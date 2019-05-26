require('/heroes/monkey_king/constants')
require('/heroes/monkey_king/shapeshift')
LinkLuaModifier("modifier_draghor_feral_sprint", "modifiers/draghor/modifier_draghor_feral_sprint", LUA_MODIFIER_MOTION_NONE)

function hawk_screech_pre(event)
	local caster = event.caster
	EmitSoundOn("Draghor.YearBeast.PreRoar", caster)

	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/year_beast_roar_precastshoutmask.vpcf", caster, 3)
	ParticleManager:SetParticleControl(pfx, 2, Vector(200,200,200))
end

function hawk_screech(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	EmitSoundOn("Draghor.YearBeast.Roar", caster)
	local fv = ((event.target_points[1]-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local altitude = 15
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_6, rate=1.7})
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/roshpit/draghor/year_beast_roar.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,altitude)+fv*130,
        	fDistance = 900,
        	fStartRadius = 100,
        	fEndRadius = 340,
        	Source = caster,
        	StartPosition = "attach_hitloc",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * 1000,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	local q_3_level = caster:GetRuneValue("q", 3)
	if q_3_level > 0 then
		local modifiers = caster:FindAllModifiers()
		for i = 1, #modifiers, 1 do
			local modifier = modifiers[i]
			local modifierMaker = modifier:GetCaster()
			if not modifier.djanghorQ3Increase then
				modifier.djanghorQ3Increase = 0
			end
			if modifierMaker then
				if (modifierMaker:GetEntityIndex() == caster:GetEntityIndex() or modifierMaker:GetEntityIndex() == caster.InventoryUnit:GetEntityIndex()) then
					local durationRemaining = modifier:GetRemainingTime()
					if durationRemaining > 0 then
						local durationIncrease = 0.3 + DJANGHOR_Q3_BUFF_DURATION_INCREASE*q_3_level
						if modifier.djanghorQ3Increase >= DJANGHOR_Q3_MAX_APPLY_COUNT then
						else
							modifier.djanghorQ3Increase = modifier.djanghorQ3Increase + 1
							modifier:SetDuration(durationRemaining + durationIncrease, true)
						end
					end
				end
			end
		end
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_armor_buff", {duration = duration})
	ability.q_1_level = caster:GetRuneValue("q", 1)
	if ability.q_1_level > 0 then
		caster:RemoveModifierByName("modifier_bear_regen")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_regen", {duration = 12})
		EmitSoundOn("Draghor.Bear.Regeneration", caster)
	end
	local howlDuration = Filters:GetAdjustedBuffDuration(caster, 8, false)
	local q_2_level = caster:GetRuneValue("q", 2)
	if q_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wolf_howl_flat_b_b", {duration = howlDuration})
		caster:SetModifierStackCount("modifier_wolf_howl_flat_b_b", caster, q_2_level)
	end
	Filters:CastSkillArguments(1, caster)
end

function hawk_screech_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local debuff_duration = event.debuff_duration
	local damage = event.damage
	local duration = event.duration
	ability:ApplyDataDrivenModifier(caster, target, "modifier_draghor_hawk_screech", {duration = debuff_duration})
	target:SetModifierStackCount("modifier_draghor_hawk_screech", caster, ability:GetLevel())

	ability:ApplyDataDrivenModifier(caster, target, "modifier_bear_roar_taunt", {duration = duration})
	target:MoveToTargetToAttack(caster)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NATURE)
end

function rend_start(event)
	local caster = event.caster
	local ability = event.ability

	local position = caster:GetAbsOrigin()
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.damage_mult/100)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin()+caster:GetForwardVector()*180, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	local element1 = RPC_ELEMENT_NORMAL
	local element2 = RPC_ELEMENT_NONE
	tornado_start(event)
	if caster:HasModifier("modifier_djanghor_immortal_weapon_1") then
        local pfx = ParticleManager:CreateParticle( "particles/roshpit/dreghor/jinbo_heavy.vpcf", PATTACH_POINT, caster )
        ParticleManager:SetParticleControl(0, pfx, caster:GetAbsOrigin())
        -- ParticleManager:SetParticleControl(1, pfx, caster:GetAbsOrigin()+endFV*range)
        ParticleManager:SetParticleControl(2, pfx, Vector(range, 0, 0))
		Timers:CreateTimer(4, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)
		element1 = RPC_ELEMENT_NATURE
		element2 = RPC_ELEMENT_NONE
		local endFV = caster:GetForwardVector()
		local range = 1200
		EmitSoundOn("Draghor.RendRange", caster)
		enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin()+endFV*range, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)		
	end
	if #enemies > 0 then
		EmitSoundOn("Draghor.Wolf.RendHitBasic", enemies[1])
		local bBloodSound = false	
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 2, element1, element2)

			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_stack", {duration = 8})
			local rendStacks = enemy:GetModifierStackCount("modifier_wolf_rend_stack", caster)
			local newStacks = math.min(2, rendStacks+1)
			enemy:SetModifierStackCount("modifier_wolf_rend_stack", caster, newStacks)

			local armorLoss = (enemy:GetPhysicalArmorValue(false)+enemy:GetModifierStackCount("modifier_wolf_rend_armor_loss", caster))*0.5
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_armor_loss", {duration = 8})
			enemy:SetModifierStackCount("modifier_wolf_rend_armor_loss", caster, armorLoss*newStacks)
			if rendStacks == 2 then
				enemy.rendBleed = event.bleed_damage*damage/100
				ability.w_2_level = caster:GetRuneValue("w", 2)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_bleed", {duration = 12})
				local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
				if not ability.bloodCount then
					ability.bloodCount = 0
				end
				if ability.bloodCount < 9 then
					ability.bloodCount = ability.bloodCount + 1
					local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, enemy )
					ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 2, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
					Timers:CreateTimer(3, function()
						ParticleManager:DestroyParticle(pfx, false)
						ability.bloodCount = ability.bloodCount - 1
					end)
				end
				bBloodSound = true
			end
		end	
		if bBloodSound then
			EmitSoundOnLocationWithCaster(enemies[1]:GetAbsOrigin(), "Draghor.Wolf.RendBleed", caster)
		end			
	end 
	Filters:CastSkillArguments(2, caster)
end

function rend_bleed_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = target.rendBleed
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
end

function tornado_start(event)
	local caster = event.caster
	local ability = event.ability


	EmitSoundOn("Draghor.Tornado.Cast", caster)
	local projectileParticle = "particles/roshpit/draghor/hawk_tornado_big.vpcf"
	local fv = caster:GetForwardVector()
	local perpFV = WallPhysics:rotateVector(fv, 2*math.pi/4)
	local speed = 1000
	local projectileOrigin = caster:GetAbsOrigin()+perpFV*RandomInt(-160, 160)
	local range = 1200
	local tornadoRadius = 200

	local projectileFV = (((caster:GetAbsOrigin()+fv*range) - projectileOrigin)*Vector(1,1,0)):Normalized()
	local info = 
	{
			Ability = ability,
	    	EffectName = projectileParticle,
	    	vSpawnOrigin = projectileOrigin,
	    	fDistance = range,
	    	fStartRadius = tornadoRadius,
	    	fEndRadius = tornadoRadius,
	    	Source = caster,
	    	StartPosition = "attach_origin",
	    	bHasFrontalCone = true,
	    	bReplaceExisting = false,
	    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = projectileFV*speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	ability.w_3_level = caster:GetRuneValue("w", 3)

end

function tornado_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local damage = event.damage
	damage = damage + event.int_mult*caster:GetIntellect()
	if ability.w_3_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*DJANGHOR_W3_ATTACK_PERCENT_ADDED_TO_TORNADO_AND_STOMP*ability.w_3_level
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_WIND, RPC_ELEMENT_NATURE)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_hawk_tornado_debuff", {duration = 7})
	if caster:HasModifier("modifier_djanghor_immortal_weapon_3") then
		target:SetModifierStackCount("modifier_hawk_tornado_debuff", caster, 2)
	end

	local bBloodSound = false	
	local enemy = target
	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_stack", {duration = 8})
	local rendStacks = enemy:GetModifierStackCount("modifier_wolf_rend_stack", caster)
	local newStacks = math.min(2, rendStacks+1)
	enemy:SetModifierStackCount("modifier_wolf_rend_stack", caster, newStacks)
	print("RUN THIS??")

	local armorLoss = (enemy:GetPhysicalArmorValue(false)+enemy:GetModifierStackCount("modifier_wolf_rend_armor_loss", caster))*0.5
	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_armor_loss", {duration = 8})
	enemy:SetModifierStackCount("modifier_wolf_rend_armor_loss", caster, armorLoss*newStacks)
	if rendStacks == 2 then
		enemy.rendBleed = event.bleed_damage*damage/100
		ability.w_2_level = caster:GetRuneValue("w", 2)
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_bleed", {duration = 12})
		local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, enemy )
		ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		bBloodSound = true
	end

	if bBloodSound then
		EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Draghor.Wolf.RendBleed", caster)
	end	
end

function begin_bear_charge(event)
	local caster = event.caster
	-- caster:Stop()
	local ability = event.ability
	local target = event.target_points[1]
	local chargeSpeed = 1000
	local distance = WallPhysics:GetDistance2d(target,caster:GetAbsOrigin())
	local duration = distance/chargeSpeed
	StartAnimation(caster, {duration=duration+0.39, activity=ACT_DOTA_MAGNUS_SKEWER_END, rate=1.4})
	ability.fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	caster:SetForwardVector(ability.fv)
	ability.pushTable = {}
	EmitSoundOn("Draghor.YearBeast.Charge", caster)
	ability.interval = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_charging", {duration = duration})
	if caster:HasModifier("modifier_djanghor_glyph_6_1") then
		local c_c_level = caster:GetRuneValue("e", 3)
		if c_c_level > 0 then
			local procs = Runes:Procs(c_c_level, 5, 1)
			if procs > 0 then
				local particle = false
				for i = 1, procs, 1 do
					local modifiers = caster:FindAllModifiers()
					for j = 1, #modifiers, 1 do
						local modifier = modifiers[j]
						local modifierMaker = modifier:GetCaster()
						if modifierMaker and modifierMaker.regularEnemy then
							caster:RemoveModifierByName(modifier:GetName())
							particle = true
							break
						end
					end				
				end
				if particle then
					EmitSoundOn("Draghor.Cleanse", caster)
					local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf", caster, 1.2)
				end
			end
		end
	end	
	Filters:CastSkillArguments(3, caster)
end

function bear_charge_thinking(event)
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
	for _,pushUnit in pairs(ability.pushTable) do
		if not pushUnit.dummy then
			local pushPos = GetGroundPosition(pushUnit:GetAbsOrigin() + ability.fv*movement, caster)
			pushUnit:SetAbsOrigin(pushPos)
		end
	end
	if ability.interval%9==0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			EmitSoundOn("Draghor.BearCharge.Impact", caster)
			for _,enemy in pairs(enemies) do
				Filters:ApplyStun(caster, 0.5, enemy)
				ability.pushTable[tostring(enemy:GetEntityIndex())] = enemy
			      local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			      ParticleManager:SetParticleControl( pfx, 0, enemy:GetAbsOrigin())
			      ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			      Timers:CreateTimer(2, function()
			        ParticleManager:DestroyParticle(pfx, false)
			      end)
			end
		end 			
	end
	ability.interval = ability.interval + 1
end

function bear_charge_end(event)
	local ability = event.ability
	local caster = event.caster
	ability.slideVelocity = 30
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_sliding", {duration = 0.45})
	for _,pushUnit in pairs(ability.pushTable) do
		FindClearSpaceForUnit(pushUnit, pushUnit:GetAbsOrigin(), false)
	end
	ability.pushTable = {}
	wolf_sprint(event)
	if caster:HasModifier("modifier_shapeshift_year_beast") then
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_year_beast_charge", "draghor_year_beast_leap", 2)
	end
end

function sprint_end(event)
	local ability = event.ability
	local caster = event.caster
	if caster:GetAbilityByIndex(2):GetAbilityName() == "draghor_year_beast_leap" then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_year_beast_leap", "djanghor_year_beast_charge", 2)
	end
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
	print("slide think")
end

function charge_slide_end(event)
	print("slide END")
	local caster = event.caster
	caster.EFV = nil
end

function bear_regen_think(event)
	local caster = event.caster
	local ability = event.ability
	local healAmount = ability.q_1_level*DJANGHOR_Q1_REGEN_FLAT
	Filters:ApplyHeal(caster, caster, healAmount, true)
end

function wolf_sprint(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	local d_c_level = caster:GetRuneValue("e", 4)
	if d_c_level > 0 then
		duration = duration + d_c_level*DJANGHOR_E4_DURATION_INCREASE
	end
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.5})
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_wolf_sprint", {duration = duration})
	caster:AddNewModifier( caster, ability, "modifier_draghor_feral_sprint", {duration = duration} )
	EmitSoundOn("Draghor.Wolf.FeralHaste", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_wolf_slide_burst", {duration = 1.0})
	caster:SetModifierStackCount("modifier_wolf_slide_burst", caster, 200)
      local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
      ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin())
      ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
      end)

      local pfx2 = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
      ParticleManager:SetParticleControl( pfx2, 0, caster:GetAbsOrigin()+caster:GetForwardVector()*80)
      ParticleManager:SetParticleControl( pfx2, 1, Vector(200, 200, 200) )
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx2, false)
      end)
      for i = 1, 5, 1 do
      	Timers:CreateTimer(0.25*i, function()
		  local pfxExtra = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
		  ParticleManager:SetParticleControl( pfxExtra, 0, caster:GetAbsOrigin())
		  ParticleManager:SetParticleControl( pfxExtra, 1, Vector(200, 200, 200) )
		  Timers:CreateTimer(2, function()
		    ParticleManager:DestroyParticle(pfxExtra, false)
		  end)
		end)
      end
      Filters:CastSkillArguments(3, caster)
end

function wolf_slide_think(event)
	local caster = event.caster
	local ability = event.ability
	local currentStacks = caster:GetModifierStackCount("modifier_wolf_slide_burst", caster)
	caster:SetModifierStackCount("modifier_wolf_slide_burst", caster, currentStacks - 4)
end

function jump_pre_start(event)
	local caster = event.caster
	local ability = event.ability
	local distance = WallPhysics:GetDistance2d(event.target_points[1], caster:GetAbsOrigin())
	if distance > 700 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.YearBeast.PreLeap", caster)
	else
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.YearBeast.PreLeap", caster)
	end
	if not ability.boostLock then
		ability.boostLock = true
		local sprintModifier = caster:FindModifierByName("modifier_wolf_sprint")
		if sprintModifier then
			sprintModifier:SetDuration(sprintModifier:GetRemainingTime() + 0.65, true)
		end
		Timers:CreateTimer(1, function()
			ability.boostLock = false
		end)
	end
	EndAnimation(caster)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/djanghor/year_beast_pre_leap.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 0.6)
	-- StartAnimation(caster, {duration=0.44, activity=ACT_DOTA_MK_SPRING_CAST, rate=1.2})
end

function yb_jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1]
	ability:ApplyDataDrivenModifier(caster, caster,"modifier_monkey_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance/22
	ability.liftVelocity = 40
	local heightDiff = caster:GetAbsOrigin().z - ability.targetPoint.z
	ability.liftVelocity = ability.liftVelocity - heightDiff/30
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	ability.interval = 0
	local sprintModifier = caster:FindModifierByName("modifier_wolf_sprint")
	if sprintModifier then
		sprintModifier:SetDuration(sprintModifier:GetRemainingTime() + 1, true)
	end
	-- StartAnimation(caster, {duration=1, activity=ACT_DOTA_LEAP_STUN, rate=2.0})
	-- StartAnimation(caster, {duration=2.0, ACT_DOTA_MK_SPRING_SOAR, rate=1.0})
	-- StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1})
	-- EmitSoundOn("Akrimus.Jump.VO", caster)
	Filters:CastSkillArguments(3, caster)

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
			caster:RemoveModifierByName("modifier_monkey_jump")
		end
	end

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*30), caster)
	if blockUnit then
		fv = Vector(0,0)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + fv*ability.jumpVelocity + Vector(0,0,ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 4
	if ability.liftVelocity <= 0 then
		ability.rising = false
	end
	ability.interval = ability.interval + 1
	if ability.interval%3 == 0 then
		-- local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/jump_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
		-- ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		-- Timers:CreateTimer(0.4, function()
		-- 	ParticleManager:DestroyParticle(pfx, false)
		-- end)
	end
end

function year_beast_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_djanghor_immortal_weapon_3") then
		local manaDrain = math.ceil(caster:GetMaxMana()*0.0003)
		if caster:GetMana() < manaDrain then
			monkey_form(event)
		else
			caster:ReduceMana(manaDrain)
		end
	end
end

function jump_end(event)
	local caster = event.caster
	local ability = event.ability
	local stun_duration = event.stun_duration
	local damage = event.stomp_damage
	local w_3_level = caster:GetRuneValue("w", 3)
	local e_1_level = caster:GetRuneValue("e", 1)
	if w_3_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*DJANGHOR_W3_ATTACK_PERCENT_ADDED_TO_TORNADO_AND_STOMP*w_3_level
	end
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/roshpit/draghor/yearbeast_warstomp.vpcf"
	local radius = 280
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	EmitSoundOn("Draghor.Yearbeast.Warstomp", caster)
	-- FindClearSpaceForUnit(caster, position, false)
	if e_1_level > 0 then
		CustomAbilities:QuickAttachThinker(ability, caster, caster:GetAbsOrigin(), "modifier_monkey_a_c_thinker", {duration = 20})
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_NATURE, RPC_ELEMENT_EARTH)
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
	end 
	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_BELLYACHE_END, rate=1.3})
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)	
end

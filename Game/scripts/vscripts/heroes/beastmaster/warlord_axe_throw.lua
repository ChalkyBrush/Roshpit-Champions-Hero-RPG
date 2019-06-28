require('heroes/beastmaster/elemental_axes')

function prepareAxeLaunchPhaseStart(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	local targetDirection = ((event.target_ponts[1] - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	if caster:HasModifier("modifier_warlord_ice_sprint") or caster:HasModifier("modifier_warlord_jumping") or caster:HasModifier("modifier_warlord_jumping_fire") then
		caster:SetForwardVector(targetDirection)
		local axeThrow = caster:GetAbilityByIndex(DOTA_W_SLOT)
		axeThrow.castPoint = axeThrow:GetCastPoint()
		axeThrow:SetOverrideCastPoint(0.01)
		Timers:CreateTimer(0.03, function()
			caster:SetForwardVector(fv)
			axeThrow:SetOverrideCastPoint(axeThrow.castPoint)
		end)
	end
end

function prepareAxeLaunch(event)
	local caster = event.caster
	local ability = event.ability
	local element = event.type
	StartAnimation(caster, {duration=0.39, activity=ACT_DOTA_ATTACK, rate=1.8})
	local point = event.target_points[1]
	local casterOrigin = caster:GetAbsOrigin()
	local fv = (point-casterOrigin):Normalized()

	ability.w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "warlord")
	if element == "earth" then
		launchAxe(ability, caster, "particles/units/heroes/hero_troll_warlord/warlord_range_axe_earth.vpcf", fv, casterOrigin, true, element)
	elseif element == "ice" then
		launchAxe(ability, caster, "particles/units/heroes/elemental_warlord/warlord_range_axe_ice.vpcf", fv, casterOrigin, true, element)
	elseif element == "fire" then
		launchAxe(ability, caster, "particles/_2units/heroes/hero_troll_warlord/warlord_range_axe_fire.vpcf", fv, casterOrigin, true, element)
	end
	Filters:CastSkillArguments(2, caster)
	if not event.bNoCast then
		if caster:HasModifier("modifier_warlord_ice_sprint") or caster:HasModifier("modifier_warlord_jumping") or caster:HasModifier("modifier_warlord_jumping_fire") then
		else
			swapSkills(element, caster, ability)
		end

		if caster:HasModifier("modifier_warlord_immortal_weapon_2") then
			if not caster:HasAbility("axe_throw_fire") then
				local newAbility = caster:AddAbility("axe_throw_fire")
				newAbility:SetAbilityIndex(1)
				newAbility:SetHidden(true)
			end
			if not caster:HasAbility("axe_throw_ice") then
				local newAbility = caster:AddAbility("axe_throw_ice")
				newAbility:SetAbilityIndex(1)
				newAbility:SetHidden(true)
			end
			local elementThrows = {}
			local otherAbilities = {}
			if element == "earth" then
				elementThrows[1] = "ice"
				elementThrows[2] = "fire"
			elseif element == "ice" then
				elementThrows[1] = "fire"
				elementThrows[2] = "earth"
			elseif element == "fire" then
				elementThrows[1] = "earth"
				elementThrows[2] = "ice"		
			end					
			Timers:CreateTimer(0.15, function()
				local eventTable = {}
				eventTable.caster = caster
				local eventAbility = caster:FindAbilityByName("axe_throw_"..elementThrows[1])
				if not eventAbility then
					return false
				end
				eventTable.ability = eventAbility
				eventTable.target_points = {}
				eventTable.target_points[1] = point
				eventTable.type = elementThrows[1]
				eventTable.bNoCast = true
				prepareAxeLaunch(eventTable)
			end)
			Timers:CreateTimer(0.3, function()
				local eventTable = {}
				eventTable.caster = caster
				local eventAbility = caster:FindAbilityByName("axe_throw_"..elementThrows[2])
				if not eventAbility then
					return false
				end
				eventTable.ability = eventAbility
				eventTable.target_points = {}
				eventTable.target_points[1] = point
				eventTable.type = elementThrows[2]
				eventTable.bNoCast = true
				prepareAxeLaunch(eventTable)
			end)
		end
	end

end

function swapSkills(element, caster, ability)
	if element == "earth" then
		swapSkillsToIce(caster, ability, swingCooldown)
		caster:RemoveModifierByName("modifier_elemental_axe_earth")
		caster.warlordElement = "ice"
	elseif element == "ice" then
		swapSkillsToFire(caster, ability, swingCooldown)
		caster:RemoveModifierByName("modifier_elemental_axe_ice")
		caster.warlordElement = "fire"
	elseif element == "fire" then
		swapSkillsToEarth(caster, ability, swingCooldown)
		caster:RemoveModifierByName("modifier_elemental_axe_fire")
		caster.warlordElement = "earth"
	end
end

function launchAxe(ability, caster, particle, fv, startPoint, bSplit, element)
	local start_radius = 120
	local end_radius = 120
	local range = 1500
	local speed = 900
	if not ability.axe_table then
		ability.axe_table = {}
	end
	EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)
	local position = caster:GetAbsOrigin() + Vector(0,0,100)
	local axe = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
	axe:SetAbsOrigin(position)
	axe.pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
	local velocity = fv*speed
	ability:ApplyDataDrivenModifier(caster, axe, "modifier_warlord_axe_motion", {})
	ParticleManager:SetParticleControl(axe.pfx, 0, position)
	ParticleManager:SetParticleControl(axe.pfx, 1, velocity)
	axe:FindAbilityByName("dummy_unit"):SetLevel(1)
	table.insert(ability.axe_table, axe)
	axe.velocity = velocity
	axe.element = element
	axe.original_position = position
	axe.max_range = range
	if axe:GetAbsOrigin().z - GetGroundHeight(axe:GetAbsOrigin(), axe) > 20 then
		axe.downShot = true
	end
	if element == "ice" and caster:HasModifier("modifier_warlord_ice_sprint") then
		axe.e_2_amp = true
	end
		-- local casterOrigin = caster:GetAbsOrigin()

		-- local info = 
		-- {
		-- 		Ability = ability,
	 --        	EffectName = particle,
	 --        	vSpawnOrigin = startPoint+Vector(0,0,120),
	 --        	fDistance = range,
	 --        	fStartRadius = start_radius,
	 --        	fEndRadius = end_radius,
	 --        	Source = caster,
	 --        	StartPosition = "attach_attack1",
	 --        	bHasFrontalCone = true,
	 --        	bReplaceExisting = false,
	 --        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	 --        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	 --        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	 --        	fExpireTime = GameRules:GetGameTime() + 5.0,
		-- 	bDeleteOnHit = false,
		-- 	vVelocity = fv*Vector(1,1,0) * speed,
		-- 	bProvidesVision = false,
		-- }
		-- projectile = ProjectileManager:CreateLinearProjectile(info)
		-- if bSplit then
		-- 	ability.split = true
		-- else
		-- 	ability.split = false
		-- end
	if caster:HasModifier("modifier_warlord_ice_sprint") or caster:HasModifier("modifier_warlord_jumping") or caster:HasModifier("modifier_warlord_jumping_fire") then
		ability:EndCooldown()
	end
end

function axe_moving_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local distance = WallPhysics:GetDistance(target.original_position, target:GetAbsOrigin())
	--print("AXE THROWING: ")
	--print(target:GetAbsOrigin())
	-- if target.downShot then
		if target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target) < 20 then
			event.target = target
			if target.element == "earth" then
				earthAxeStrike(event)
			elseif target.element == "fire" then
				fireAxeStrike(event)
			elseif target.element == "ice" then
				event.axe = target
				iceAxeStrike(event)
			end
			target:RemoveModifierByName("modifier_warlord_axe_motion")
			ParticleManager:DestroyParticle(target.pfx, false)
			ParticleManager:ReleaseParticleIndex(target.pfx)
			return false
		end
	-- end
	if distance > target.max_range then
		target:RemoveModifierByName("modifier_warlord_axe_motion")
		ParticleManager:DestroyParticle(target.pfx, false)
		ParticleManager:ReleaseParticleIndex(target.pfx)
		axe_motion_end(event)
	else
		target:SetAbsOrigin(target:GetAbsOrigin()+target.velocity*FrameTime())
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
		if #enemies > 0 then
			local strike_event_table = WallPhysics:CloneTable(event)
			strike_event_table.target = enemies[1]
			if target.element == "earth" then
				earthAxeStrike(strike_event_table)
			elseif target.element == "fire" then
				fireAxeStrike(strike_event_table)
			elseif target.element == "ice" then
				strike_event_table.axe = target
				iceAxeStrike(strike_event_table)
			end
			target:RemoveModifierByName("modifier_warlord_axe_motion")
			ParticleManager:DestroyParticle(target.pfx, false)
			ParticleManager:ReleaseParticleIndex(target.pfx)
			axe_motion_end(event)
		end	
	end
end

function axe_motion_end(event)
	local target = event.target
	local ability = event.ability
	ParticleManager:DestroyParticle(target.pfx, false)
	ParticleManager:ReleaseParticleIndex(target.pfx)
	Timers:CreateTimer(0.03, function()
		UTIL_Remove(target)
		local newTable = {}
		for i = 1, #ability.axe_table, 1 do
			if IsValidEntity(ability.axe_table[i]) then
				table.insert(newTable, ability.axe_table[i])
			end
		end
		ability.axe_table = newTable
	end)
end

function earthAxeStrike(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local ability = event.ability


	local pureDamage = 0
	if ability.w_4_level > 0 then
		
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.2*ability.w_4_level
		pureDamage = damage*0.025*ability.w_4_level
	end

	local stun_duration = event.stun_duration
	EmitSoundOn("Warlord.EarthAxeImpact", target)
	

	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_EARTH, RPC_ELEMENT_NORMAL)
	Filters:TakeArgumentsAndApplyDamage(target, caster, pureDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_EARTH, RPC_ELEMENT_NORMAL)
	glyph_4_1(caster, ability, target)

	local eventTable = {}
	eventTable.element = "earth"
	eventTable.attacker = caster
	eventTable.ability = ability
	eventTable.charges = 2
	elemental_axe_attack_land(eventTable)

	local pfx = ParticleManager:CreateParticle("particles/roshpit/elemental_warlord/earth_axe_throw_explode.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
	ParticleManager:SetParticleControl(pfx, 2, Vector(200, 200, 200))
	ParticleManager:SetParticleControl(pfx, 3, Vector(200, 200, 200))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	local w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "warlord")
	if w_1_level > 0 then
		local radius = w_1_level*4 + 240
		local stunDuration = w_1_level*0.05
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then	
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_EARTH, RPC_ELEMENT_NORMAL)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, pureDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_EARTH, RPC_ELEMENT_NORMAL)
				Filters:ApplyStun(caster, stunDuration, enemy)
			end
		end	
		local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
		ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
		ParticleManager:SetParticleControl( particle2, 4, Vector(22, 60, 0) )
		Timers:CreateTimer(1.5, 
		function()
			ParticleManager:DestroyParticle( particle2, false )
		end)	
	end
	Filters:ApplyStun(caster, stun_duration, target)
end

function c_b_mana(ability, caster)
	if ability.w_3_level > 0 then
		local manaDrain = caster:GetMaxMana()*0.1
		if caster:GetMana() < manaDrain then
			manaDrain = caster:GetMana()
		end
		caster:ReduceMana(manaDrain)
		local damageBonus = (manaDrain/100)*150*ability.w_3_level
		return damageBonus
	else
		return 0
	end
end

function rune_w_1(caster, target, ability, element)
	    local runeUnit = caster.runeUnit
	    local runeAbility = runeUnit:FindAbilityByName("warlord_rune_w_1")
	    local abilityLevel = runeAbility:GetLevel()
	    local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_1")
	    local totalLevel = abilityLevel + bonusLevel
	    local projectile = "particles/units/heroes/hero_troll_warlord/warlord_range_axe_earth.vpcf"
	    if totalLevel > 0 then
	    	--print("past first if")
	        local procs = Runes:Procs(totalLevel, 10, 1)
	        if procs>0 then
	        	--print("past procs")
	        	if element == "earth" then
	        		projectile = "particles/units/heroes/hero_troll_warlord/warlord_range_axe_earth.vpcf"
	        	elseif element == "fire" then
	        		projectile = "particles/_2units/heroes/hero_troll_warlord/warlord_range_axe_fire.vpcf"
	        	elseif element == "ice" then
	        		projectile = "particles/units/heroes/elemental_warlord/warlord_range_axe_ice.vpcf"
	        	end
	        	for i =1, procs, 1 do
	        		--print("fire some axes")
	        		local randomDirection = RandomVector(1)
	        		local launchPosition = target:GetAbsOrigin() + randomDirection*40
	        		launchAxe(ability, caster, projectile, randomDirection, launchPosition, false)
	        	end
	        end
	    end
end

function iceAxeStrike(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local ability = event.ability

	local e_2_level = caster:GetRuneValue("e", 2)
	if e_2_level > 0 and event.axe then
		if event.axe.e_2_amp then
			damage = damage + damage*1*e_2_level
		end
	end
	local pureDamage = 0
	if ability.w_4_level > 0 then
		
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.02*ability.w_4_level
		pureDamage = damage*0.025*ability.w_4_level
	end

	local radius = event.radius
	local duration = event.duration
	local freezeDuration = 0
	local w_2_level = Runes:GetTotalRuneLevel(caster, 2, "w_2", "warlord")
	if w_2_level > 0 then
		freezeDuration = 1 + 0.1*w_2_level
	end	
	local stun_duration = event.stun_duration
	local position = target:GetAbsOrigin()
	EmitSoundOn("Warlord.IceAxeImpact", target)
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
			if not enemy:HasModifier("modifier_ice_throw_b_b_immunity") then
				if freezeDuration > 0 then
					if enemy:HasModifier("modifier_ice_axe_slow") then
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_throw_b_b_frozen", {duration = freezeDuration})
						enemy:SetModifierStackCount("modifier_ice_throw_b_b_frozen", caster, w_2_level)
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_throw_b_b_immunity", {duration = freezeDuration + 4})
					end
				end
			end
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_axe_slow", {duration = duration})
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_ICE, RPC_ELEMENT_NORMAL)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, pureDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_ICE, RPC_ELEMENT_NORMAL)

		end
	end
	glyph_4_1(caster, ability, target)

	local eventTable = {}
	eventTable.element = "ice"
	eventTable.attacker = caster
	eventTable.ability = ability
	eventTable.charges = 2
	elemental_axe_attack_land(eventTable)
end

function fireAxeStrike(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local ability = event.ability


	local pureDamage = 0

	local radius = event.radius
	local duration = event.duration
	local stun_duration = event.stun_duration
	local position = target:GetAbsOrigin()
	local w_3_level = Runes:GetTotalRuneLevel(caster, 3, "w_3", "warlord")
	if w_3_level > 0 then
		radius = radius + w_3_level*5
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.4*w_3_level
	end
	if ability.w_4_level > 0 then
		
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.02*ability.w_4_level
		pureDamage = damage*0.025*ability.w_4_level
	end
	EmitSoundOn("Hero_Invoker.SunStrike.Ignite", target)
      local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
      ParticleManager:SetParticleControl( particle2, 0, position )
      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )
      Timers:CreateTimer(1.5, 
      function()
        ParticleManager:DestroyParticle( particle2, false )
      end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then	
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_fire_armor_sear", {duration = duration})
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NORMAL)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, pureDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NORMAL)
		end
	end
	glyph_4_1(caster, ability, target)

	local eventTable = {}
	eventTable.element = "fire"
	eventTable.attacker = caster
	eventTable.ability = ability
	eventTable.charges = 2
	elemental_axe_attack_land(eventTable)
end

function rune_w_3(caster)
    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("warlord_rune_w_3")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_3")
    local totalLevel = abilityLevel + bonusLevel
    return totalLevel
end

function glyph_4_1(caster, ability, target)
	if not caster:HasModifier("modifier_warlord_glyph_4_1_cooldown") then
		--print("IN HERE?")
		if caster:HasModifier("modifier_warlord_glyph_4_1") then
			--print("IN THERE!")
			if IsValidEntity(target) then
				local earthAxeAbility = caster:FindAbilityByName("axe_throw_earth")
				local glyphDuration = Filters:GetAdjustedBuffDuration(caster, 3, false)
				earthAxeAbility:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_glyph_4_1_cooldown", {duration = glyphDuration+2})
				earthAxeAbility:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_glyph_4_1_attack_up", {duration = glyphDuration})
				caster.jumpEnd = true
				local casterOrigin = caster:GetAbsOrigin()
				local targetOrigin = target:GetAbsOrigin()
				caster.warlord_ambush_target = target
				local fv = (targetOrigin*Vector(1,1,0)-casterOrigin*Vector(1,1,0)):Normalized()
				local distance = WallPhysics:GetDistance(casterOrigin*Vector(1,1,0), targetOrigin*Vector(1,1,0))
				caster:SetForwardVector(fv)
				glyph_jump(caster, fv, distance, 20, 50, 1, 1)
		        local animationTime = math.min(500/distance, 1)
		        EmitSoundOn("beastmaster_beas_anger_01", caster)
		        StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=animationTime})
		    end
		end
	end
end

function glyph_jump(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
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
				if newPosition.x <= endLocation.x + 20 and newPosition.x >= endLocation.x-20 and newPosition.y <= endLocation.y+20 and newPosition.y >= endLocation.y-20 then
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
require("heroes/skywrath_mage/constants")

function strafe_toggled_on(event)
	local caster = event.caster
	local ability = event.ability
	ability.fvLock = caster:GetForwardVector()
end

function strafe_fv_lock(event)
	local caster = event.caster
	local ability = event.ability
	-- if not caster:HasModifier("modifier_strafe_cooldown") and not caster:HasModifier("modifier_strafe_sprinting") and not caster:HasModifier("modifier_strafe_dont_twist") then
		caster:SetForwardVector(ability.fvLock)
	-- end
end

function strafe_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local targetPoint = ability.targetPoint

	local fv = ability.fv
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+fv*30), caster)
    local forwardSpeed = event.strafe_speed
    if ability.d_c_level > 0 then
    	forwardSpeed = forwardSpeed + 0.15*ability.d_c_level
    end
    if caster:HasModifier("modifier_nefali_c_d_speed") then
    	local stacks = caster:GetModifierStackCount("modifier_nefali_c_d_speed", caster)
    	forwardSpeed = forwardSpeed+R3_STRAFE_SPEED*stacks
    end
    -- make scale with level
	if blockUnit then
		forwardSpeed = 0
	end	
	
	-- local pushForward = 0
	-- if caster:HasModifier("modifier_gale_speed_burst") then
	-- 	local gale = caster:FindAbilityByName("piercing_gale")
	-- 	pushForward = gale.pushSpeed
	-- end
	local zfactor = 0
	local distanceFromGround = caster:GetAbsOrigin().z - GetGroundHeight(targetPoint, caster)
	zfactor = -distanceFromGround/5
	caster:SetAbsOrigin(caster:GetAbsOrigin()+fv*forwardSpeed+Vector(0,0,zfactor))

	ability.distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)
	print(ability.distance)
	if not caster:IsChanneling() and not caster:HasModifier("modifier_lightbomb_start_cast") then
		caster:MoveToPosition(caster:GetAbsOrigin()+ability.fvLock*1)
	end
	if ability.distance < 50 or blockUnit then
		caster:RemoveModifierByName("modifier_strafe_sprinting")
		if not caster:IsChanneling() and not caster:HasModifier("modifier_lightbomb_start_cast") then
			caster:MoveToPosition(caster:GetAbsOrigin()+ability.fvLock*5)
		end
		-- if caster:HasAbility("sephyr_lightbomb") then
		-- 	local lightbomb = caster:FindAbilityByName("sephyr_lightbomb")
		-- 	lightbomb:SetActivated(true)
		-- end
		-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_strafe_dont_twist", {duration = 0.1})
	end
end

function untwist(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_strafe_toggle") then
		if not caster:HasModifier("modifier_strafe_sprinting") and not caster:IsChanneling() and not caster:HasModifier("modifier_lightbomb_start_cast") then
			caster:MoveToPosition(caster:GetAbsOrigin()+ability.fvLock*5)
		end
	end
end

function boomerang_think(event)
	local boomerang = event.caster
	local ability = event.ability

    -- boomerang.target = enemy
    -- boomerang.bounces = 2
    -- boomerang.current_bounces = 0
    boomerang.speed = math.max(boomerang.speed - 0.2, 20)
    if boomerang.current_bounces < boomerang.bounces then
    	local fv = boomerang.fv
    	local towardTarget = ((boomerang.target:GetAbsOrigin()+Vector(0,0,boomerang.target:GetBoundingMaxs().z)) - boomerang:GetAbsOrigin()):Normalized()
			-- local angDiff = AngleDiff(WallPhysics:vectorToAngle(fv), WallPhysics:vectorToAngle(towardTarget))
			-- if angDiff > 10 or angDiff < -10 then
			-- 	boomerang.fv = WallPhysics:rotateVector(boomerang.fv, (2*math.pi/240))
			-- else
			-- 	boomerang.fv = towardTarget
			-- end
		fv = towardTarget
    	boomerang:SetAbsOrigin(boomerang:GetAbsOrigin() + fv*boomerang.speed)
    	local distance = WallPhysics:GetDistance(boomerang.target:GetAbsOrigin()+Vector(0,0,boomerang.target:GetBoundingMaxs().z), boomerang:GetAbsOrigin())
    	if distance < (boomerang.speed+5) then
    		local damage = boomerang.a_c_level * 1500
    		if boomerang.b_c_level > 0 then
    			damage = damage + boomerang.b_c_level*0.15*boomerang.caster:GetAverageTrueAttackDamage(boomerang.caster)
    		end
    		local c_c_level = Runes:GetTotalRuneLevelGeneric(boomerang.caster, 3, 2)
    		if c_c_level > 0 then
    			damage = damage + boomerang.caster:GetAgility()*E3_AGILITY_ADDED_TO_DAMAGE*c_c_level
    		end
    		Filters:TakeArgumentsAndApplyDamage(boomerang.target, boomerang.caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
    		ability:ApplyDataDrivenModifier(boomerang, boomerang.target, "modifier_boomerang_disarm", {duration = 0.5})
    		boomerang.current_bounces = boomerang.current_bounces + 1
    		boomerang.speed = math.min(boomerang.speed + 10, 60)
    		CustomAbilities:QuickParticleAtPoint("particles/sephyr/boomerang_impact.vpcf", boomerang:GetAbsOrigin(), 3)
    		boomerang.actual_hits = boomerang.actual_hits + 1
    		EmitSoundOn("Sephyr.Boomerang.Impact", boomerang)
			local enemies = FindUnitsInRadius( boomerang.caster:GetTeamNumber(), boomerang:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			local origTarget = boomerang.target
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					if enemy:GetEntityIndex() == boomerang.target:GetEntityIndex() then
					else
						boomerang.target = enemy
					end
				end
				if origTarget == boomerang.target then
					boomerang.current_bounces = boomerang.bounces
				end
			else
				boomerang.current_bounces = boomerang.bounces
			end 
    	end
    else
    	local fv = (boomerang.caster:GetAbsOrigin()+Vector(0,0,170) - boomerang:GetAbsOrigin()):Normalized()
    	boomerang:SetAbsOrigin(boomerang:GetAbsOrigin() + fv*boomerang.speed)
    	local distance = WallPhysics:GetDistance(boomerang.caster:GetAbsOrigin()+Vector(0,0,170), boomerang:GetAbsOrigin())
    	if distance < (boomerang.speed+5) then
    		boomerang:RemoveModifierByName("sephyr_boomerang_modifier")
    		Timers:CreateTimer(0.03, function()
    			EmitSoundOn("Sephyr.Boomerang.Return", boomerang)
    			ParticleManager:DestroyParticle(boomerang.pfx, false)
    			local strafe = boomerang.caster:FindAbilityByName("sephyr_strafe")
	    		if boomerang.actual_hits > 0 then
	    			local b_c_level = boomerang.b_c_level
	    			if b_c_level > 0 then
	    				local duration = Filters:GetAdjustedBuffDuration(boomerang.caster, 9, false)
	    				ability:ApplyDataDrivenModifier(boomerang, boomerang.caster, "modifier_boomerang_attack_damage_visible", {duration = duration})
	    				ability:ApplyDataDrivenModifier(boomerang, boomerang.caster, "modifier_boomerang_attack_damage_invisible", {duration = duration})
	    				boomerang.caster:SetModifierStackCount("modifier_boomerang_attack_damage_visible", boomerang, boomerang.actual_hits)
	    				boomerang.caster:SetModifierStackCount("modifier_boomerang_attack_damage_invisible", boomerang, boomerang.actual_hits*b_c_level)
	    			end
	    		end
    			UTIL_Remove(boomerang)
    			reindexBoomerangs(strafe)
    		end)
    	end
    end
    ParticleManager:SetParticleControl(boomerang.pfx, 1, boomerang:GetAbsOrigin())
    local distance_per_second = boomerang.speed/0.03
    ParticleManager:SetParticleControl(boomerang.pfx, 2, Vector(distance_per_second, distance_per_second, distance_per_second))
end

function reindexBoomerangs(ability)
    local tempTable = {}
    for i = 1, #ability.boomerangTable, 1 do
        if IsValidEntity(ability.boomerangTable[i]) then
            table.insert(tempTable, ability.boomerangTable[i])
        end
    end 
    ability.boomerangTable = tempTable
end

function strafe_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local c_c_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 2)
	if c_c_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_strafe_attack_damage", {})
		local bonusAttack = caster:GetAgility()*0.2*c_c_level
		caster:SetModifierStackCount("modifier_strafe_attack_damage", caster, bonusAttack)
	else
		caster:RemoveModifierByName("modifier_strafe_attack_damage")
	end
end
LinkLuaModifier("modifier_warlord_tomahawk_lua", "modifiers/warlord/modifier_warlord_tomahawk_lua", LUA_MODIFIER_MOTION_NONE)

function start_channel(event)
	local caster = event.caster
	EmitSoundOn("beastmaster_beas_ability_axes_06", caster)

end

function tomahawk_start(event)
	local caster = event.caster
	local ability = event.ability

	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)

	local earthCharges = caster:GetModifierStackCount("modifier_warlord_earth_charge", caster)
	local iceCharges = caster:GetModifierStackCount("modifier_warlord_ice_charge", caster)
	local fireCharges = caster:GetModifierStackCount("modifier_warlord_fire_charge", caster)

	caster:SetModifierStackCount("modifier_warlord_earth_charge", caster, math.floor(earthCharges/2))
	caster:SetModifierStackCount("modifier_warlord_ice_charge", caster, math.floor(iceCharges/2))
	caster:SetModifierStackCount("modifier_warlord_fire_charge", caster, math.floor(fireCharges/2))

	local totalCharges = earthCharges + iceCharges + fireCharges
	-- caster:RemoveModifierByName("modifier_warlord_earth_charge")
	-- caster:RemoveModifierByName("modifier_warlord_ice_charge")
	-- caster:RemoveModifierByName("modifier_warlord_fire_charge")

	EmitSoundOn("Warlord.CastArcanaUlti.VO", caster)
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.0})

	if totalCharges > 0 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Warlord.ArcanaUlti.Cast", caster)
		Filters:CastSkillArguments(4, caster)
		
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_enchant_tomahawk_buff", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_tomahawk_buffs", {duration = duration})
		caster:AddNewModifier( caster, ability, "modifier_warlord_tomahawk_lua", {duration = duration} )
		caster:SetRangedProjectileName("particles/roshpit/warlord/enchant_tomahawk_attack.vpcf")
		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

		Timers:CreateTimer(0.2, function()
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
		caster:SetModifierStackCount("modifier_enchant_tomahawk_buff", caster, totalCharges)
	end
end

function tomahawk_buff_end(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	caster:RemoveModifierByName("modifier_warlord_tomahawk_lua")
	caster:RemoveModifierByName("modifier_tomahawk_tectonic_pressure")
end

function tomahawk_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	EmitSoundOn("Warlord.TomahawkAttack.Impact", target)

	local stackCount = caster:GetModifierStackCount("modifier_enchant_tomahawk_buff", caster)
	local newStacks = stackCount - 1
	if stackCount > 0 then
		caster:SetModifierStackCount("modifier_enchant_tomahawk_buff", caster, newStacks)
	else
		caster:RemoveModifierByName("modifier_enchant_tomahawk_buff")
	end

	local a_d_level = caster:GetRuneValue("r", 1)
	if a_d_level > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*0.3*a_d_level
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	    if #enemies > 0 then
	        for _,enemy in pairs(enemies) do
	            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 4, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
	            Filters:ApplyStun(caster, 0.2, enemy)
	        end
	    end 
	    CustomAbilities:QuickAttachParticle("particles/roshpit/warlord/pulverizer_splash.vpcf", target, 0.8)
	    local position = target:GetAbsOrigin()+Vector(0,0,50)
	    local avalancheParticle = "particles/roshpit/warlord/pulverizer.vpcf"
	    local pfx = ParticleManager:CreateParticle( avalancheParticle, PATTACH_CUSTOMORIGIN, target )
	    ParticleManager:SetParticleControl( pfx, 0, position )
	    Timers:CreateTimer(0.9, function()
	        ParticleManager:DestroyParticle(pfx, false)
	    end)   		
	end
	local b_d_level = caster:GetRuneValue("r", 2)
	if b_d_level > 0 then
		ability.r_2_level = b_d_level
		if not target:HasModifier("modifier_tomahawk_ice_effect") then
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch.vpcf", target, 2)
			
		end
		ability:ApplyDataDrivenModifier(caster, target, "modifier_tomahawk_ice_effect", {duration = 6})
	end
	local c_d_level = caster:GetRuneValue("r", 3)
	if c_d_level > 0 then
		ability.r_3_level = c_d_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_tomahawk_tectonic_pressure", {duration = 15})
		local newStacks = caster:GetModifierStackCount("modifier_tomahawk_tectonic_pressure", caster) + 1
		caster:SetModifierStackCount("modifier_tomahawk_tectonic_pressure", caster, newStacks)
	end	
end

function tomahawk_ice_dot_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect())*2*ability.r_2_level
	local threshold = 0.3
	if target.bossStatus then
		threshold = 0.15
	end
	if target.dummy then
		return false
	end
	if target:GetHealth()/target:GetMaxHealth() < threshold then
        local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
        local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, target )
        local position = target:GetAbsOrigin()
        local radius = 260
        ParticleManager:SetParticleControl( pfx, 0, position )
        ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
        Timers:CreateTimer(3, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
        EmitSoundOn("Ability.FrostNova", target)		
		damage = damage * 10000
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #enemies > 0 then
	        for _,enemy in pairs(enemies) do
	        	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_tomahawk_ice_effect", {duration = 6})
	        end
	    end 
	end
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
end

function tectonic_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker

	local start_radius = 140
	local end_radius = 140
	local range = 1500
	local speed = 1500
	if IsValidEntity(attacker) then
		local newStacks = caster:GetModifierStackCount("modifier_tomahawk_tectonic_pressure", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_tomahawk_tectonic_pressure", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_tomahawk_tectonic_pressure")
		end
		local fv = ((attacker:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			local info = 
			{
					Ability = ability,
		        	EffectName = "particles/roshpit/warlord/fire_ulti_linear.vpcf",
		        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,60),
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
				vVelocity = fv*Vector(1,1,0) * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)

			local endPos = caster:GetAbsOrigin()+fv*1500
			Timers:CreateTimer(1, function()
				local position = endPos
				local radius = 260
				EmitSoundOnLocationWithCaster(endPos, "Warlord.Ult.FireImpact", caster)

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
				local damage = ability.r_3_level*caster:GetMaxHealth()*0.1
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then	
					for _,enemy in pairs(enemies) do
						Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					end
				end
			end)
	end

end

function pressure_fireball_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local damage = ability.r_3_level*caster:GetMaxHealth()*0.1
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function tomahawk_cyclone_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target.pushLock or target.jumpLock then
		return false
	end

	local baseFV = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local rotatedFV = WallPhysics:rotateVector(baseFV, 2*math.pi/90)
	local baseDistance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
	local distanceMult = 0.98
	if baseDistance < 150 then
		distanceMult = 1.02
	end
	target:SetAbsOrigin(caster:GetAbsOrigin()+rotatedFV*baseDistance*distanceMult)
end

function tomahawk_cyclone_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end)
end
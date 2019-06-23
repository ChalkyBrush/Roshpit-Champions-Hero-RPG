function start_channel(event)
	local caster = event.caster
	EmitSoundOn("beastmaster_beas_ability_axes_06", caster)
end

function overload_start(event)
	local caster = event.caster
	local ability = event.ability
	Filters:CastSkillArguments(4, caster)
	local earthCharges = caster:GetModifierStackCount("modifier_warlord_earth_charge", caster)
	local iceCharges = caster:GetModifierStackCount("modifier_warlord_ice_charge", caster)
	local fireCharges = caster:GetModifierStackCount("modifier_warlord_fire_charge", caster)

	local totalCharges = earthCharges + iceCharges + fireCharges
	local soundString = "Warlord.Ulti.Roar1"
	if totalCharges > 45 then
		soundString = "Warlord.Ulti.Roar4"
	elseif totalCharges > 30 then
		soundString = "Warlord.Ulti.Roar3"
	elseif totalCharges >= 15 then
		soundString = "Warlord.Ulti.Roar2"
	end
	EmitSoundOn(soundString, caster)
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_5, rate=1.0})
	local healPerEarthCharge = event.heal_per_earth_charge
	caster:RemoveModifierByName("modifier_warlord_rune_e_1_effect")
	if earthCharges > 0 then
		local newStacks = math.floor(earthCharges/2)
		local healAmount = healPerEarthCharge*earthCharges
		local shieldDuration = Filters:GetAdjustedBuffDuration(caster, event.shield_duration*earthCharges, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_overload_damage_resistance", {duration = shieldDuration})
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_warlord_earth_charge", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_warlord_earth_charge")
		end
		Filters:ApplyHeal(caster, caster, healAmount, true)
		local particleName = "particles/roshpit/warlord/earth_ulti.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, Vector(20+7*earthCharges, 0, 0))
		Timers:CreateTimer(4, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
		local earthSound = "Warlord.Ulti.Earth1"
		if earthCharges > 15 then
			earthSound = "Warlord.Ulti.Earth4"
		elseif earthCharges > 10 then
			earthSound = "Warlord.Ulti.Earth3"
		elseif earthCharges > 5 then
			earthSound = "Warlord.Ulti.Earth2"
		end
		EmitSoundOn(earthSound, caster)
		local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "warlord")
		if a_d_level > 0 then
			local a_d_ability = caster.runeUnit:FindAbilityByName("warlord_rune_r_1")
			local a_d_duration = Filters:GetAdjustedBuffDuration(caster, 8, false)
			a_d_ability:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_warlord_rune_r_1", {duration = a_d_duration})
			a_d_ability.heal = healAmount*0.015*a_d_level
			a_d_ability.r_1_level = a_d_level 
			a_d_ability.earthCharges = earthCharges
		end
	end
	if iceCharges > 0 then
		local iceRadius = 200 + iceCharges*50
		local iceDamage = event.ice_damage
		local origin = caster:GetAbsOrigin()
		-- caster:RemoveModifierByName("modifier_warlord_ice_charge")
		local newStacks = math.floor(iceCharges/2)
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_warlord_ice_charge", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_warlord_ice_charge")
		end
		local particleName = "particles/roshpit/warlord/ice_ulti_cowlofice.vpcf"
      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      	local origin = caster:GetAbsOrigin()
      	ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,20) )
      	ParticleManager:SetParticleControl( particle1, 1, Vector(iceRadius, 2, iceRadius) )
      	ParticleManager:SetParticleControl( particle1, 3, Vector(iceRadius, iceRadius, iceRadius) )
      	Timers:CreateTimer(3, function()
      		ParticleManager:DestroyParticle(particle1, false)
      	end)
      	local b_d_level = Runes:GetTotalRuneLevel(caster, 2, "r_2", "warlord")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, iceRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then	
			for _,enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_elemental_overload_frozen", {duration = event.ice_freeze_duration})
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, iceDamage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
				if b_d_level > 0 then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_warlord_b_d_effect", {duration = 8})
					enemy:SetModifierStackCount("modifier_warlord_b_d_effect", caster, b_d_level)
				end
			end
		end
		local iceSound = "Warlord.Ulti.Ice1"
		if iceCharges > 15 then
			iceSound = "Warlord.Ulti.Ice4"
			EmitSoundOn("Warlord.Ult.Ice4a", caster)
		elseif iceCharges > 10 then
			iceSound = "Warlord.Ulti.Ice3"
			EmitSoundOn("Warlord.Ult.Ice3a", caster)
		elseif iceCharges > 5 then
			iceSound = "Warlord.Ulti.Ice2"
		end
		EmitSoundOn(iceSound, caster)
	end
	if fireCharges > 0 then
		local casterOrigin = caster:GetAbsOrigin()
		for i = 1, fireCharges, 1 do
			createFireBall(ability, RandomVector(1), caster, casterOrigin)
		end
		-- caster:RemoveModifierByName("modifier_warlord_fire_charge")
		local newStacks = math.floor(fireCharges/2)
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_warlord_fire_charge", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_warlord_fire_charge")
		end
		if caster:HasAbility("elemental_overload_2") then
			local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "warlord")
			if c_d_level > 0 then
					if newStacks > 0 then
					local c_d_stacks = math.ceil(newStacks*1.0*c_d_level)
					local runeAbility = caster.runeUnit3:FindAbilityByName("warlord_rune_r_3")
					runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, caster, "modifier_warlord_rune_r_3_effect", {})
					caster:SetModifierStackCount("modifier_warlord_rune_r_3_effect", caster.runeUnit3, c_d_stacks)
				else
					caster:RemoveModifierByName("modifier_warlord_rune_r_3_effect")
				end
			end
		elseif caster:HasAbility("enhchant_tomahawk") then
			local d_d_level = caster:GetRuneValue("r", 4)
			if d_d_level > 0 then
				local d_d_stacks = math.ceil(newStacks*1.0*d_d_level)
				local tomahawk = caster:FindAbilityByName("enhchant_tomahawk")
				tomahawk:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_rune_r_4_effect", {})
				caster:SetModifierStackCount("modifier_warlord_rune_r_4_effect", caster, d_d_stacks)
			end
		end
		-- caster:RemoveModifierByName("modifier_warlord_rune_r_3_effect")
	end
	if totalCharges > 0 then
		local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "warlord")
		if d_d_level > 0 then
			local d_d_ability = caster.runeUnit4:FindAbilityByName("warlord_rune_r_4")
			local d_d_duration = Filters:GetAdjustedBuffDuration(caster, 16, false)
			d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_r_4_invisible", {duration = d_d_duration})
			d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_r_4_visible", {duration = d_d_duration})
			caster:SetModifierStackCount("modifier_warlord_rune_r_4_visible", caster.runeUnit4, totalCharges)
			caster:SetModifierStackCount("modifier_warlord_rune_r_4_invisible", caster.runeUnit4, d_d_level*totalCharges)
		end
	end
	
end

function createFireBall(ability, fv, caster, casterOrigin)
	local start_radius = 140
	local end_radius = 140
	local range = 1300
	local speed = 900
		local info = 
		{
				Ability = ability,
	        	EffectName = "particles/roshpit/warlord/fire_ulti_linear.vpcf",
	        	vSpawnOrigin = casterOrigin+Vector(0,0,120),
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
end

function fireball_impact(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local ability = event.ability
	local radius = 190
	local position = target:GetAbsOrigin()
	EmitSoundOn("Warlord.Ult.FireImpact", target)

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
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		end
	end
end

function channel_interrupt(event)
end

function warlord_a_d_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local heal = event.ability.heal
	Filters:ApplyHeal(target, target, heal, true)
	local particleName = "particles/roshpit/warlord/earth_ulti.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(30, 0, 0))
	Timers:CreateTimer(3, function() 
	  ParticleManager:DestroyParticle(pfx, false)
	end)
	local aoeDamage = OverflowProtectedGetAverageTrueAttackDamage(target)*0.03*ability.earthCharges
	local enemies = FindUnitsInRadius( target:GetTeamNumber(), target:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
	--print("WARLORD A_D")	
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Warlord.ADAoeSound", caster)
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, target, aoeDamage, DAMAGE_TYPE_MAGICAL, BASE_ITEM, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)

			local pfx2 = ParticleManager:CreateParticle("particles/roshpit/elemental_warlord/earth_axe_throw_explode.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx2, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
			ParticleManager:SetParticleControl(pfx2, 2, Vector(200, 200, 200))
			ParticleManager:SetParticleControl(pfx2, 3, Vector(200, 200, 200))
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx2, false)
				ParticleManager:ReleaseParticleIndex(pfx2)
			end)
		end
	end
end
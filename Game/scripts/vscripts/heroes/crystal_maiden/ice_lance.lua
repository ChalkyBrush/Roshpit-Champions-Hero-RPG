function begin_lance(event)
	local caster = event.caster
	local ability = event.ability

	--Timers:CreateTimer(0.3,function()
	local target = event.target_points[1]
	EmitSoundOn("Sorceress.IceLance", caster)
	local fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local casterOrigin = caster:GetAbsOrigin()
	local bArcane = sorceressGetArcaneDB(caster)

	if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
		caster = caster.origCaster
		print(caster:GetUnitName())
		ability.rune_a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
	end

	launch_lance(caster, fv, ability, "particles/econ/items/mirana/mirana_crescent_arrow/sorceress_ice_lance.vpcf", casterOrigin, 120)
	if bArcane then
		launch_lance(caster, fv, caster:FindAbilityByName("sorceress_blink"), "particles/roshpit/sorceress/arcane_enchantment.vpcf", casterOrigin+Vector(0,0,80), 90)
	end
	if caster:HasModifier("modifier_sorceress_glyph_2_1") then
		local rotatedFV = WallPhysics:rotateVector(fv, math.pi/10)
		launch_lance(caster, rotatedFV, ability, "particles/econ/items/mirana/mirana_crescent_arrow/sorceress_ice_lance.vpcf", casterOrigin, 120)
		if bArcane then
			launch_lance(caster, rotatedFV, caster:FindAbilityByName("sorceress_blink"), "particles/roshpit/sorceress/arcane_enchantment.vpcf", casterOrigin+Vector(0,0,80), 90)
		end
		rotatedFV = WallPhysics:rotateVector(fv, -math.pi/10)
		launch_lance(caster, rotatedFV, ability, "particles/econ/items/mirana/mirana_crescent_arrow/sorceress_ice_lance.vpcf", casterOrigin, 120)
		if bArcane then
			launch_lance(caster, rotatedFV, caster:FindAbilityByName("sorceress_blink"), "particles/roshpit/sorceress/arcane_enchantment.vpcf", casterOrigin+Vector(0,0,80), 90)
		end
	end
	caster.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "sorceress")
	Filters:CastSkillArguments(1, caster)
	--end)
	-- StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_CAST_ABILITY_2, rate=2.0})
	-- "modifier_arcane_enchantment"

end

function sorceressGetArcaneDB(caster)
	if caster:HasModifier("modifier_arcane_enchantment") then
		bArcane = true
		local newStacks = caster:GetModifierStackCount("modifier_arcane_enchantment", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_arcane_enchantment", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_arcane_enchantment")
		end
		return true
	else
		return false
	end
end

function launch_lance(caster, fv, ability, projectileParticle, casterOrigin, impactRadius)
		-- local projectileParticle = "particles/econ/items/mirana/mirana_crescent_arrow/sorceress_ice_lance.vpcf"

		local start_radius = impactRadius
		local end_radius = impactRadius
		local range = 1800
		local speed = 1200

		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = casterOrigin,
	        	fDistance = range,
	        	fStartRadius = start_radius,
	        	fEndRadius = end_radius,
	        	Source = caster,
	        	StartPosition = "attach_attack2",
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
end

function lance_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	EmitSoundOn("hero_Crystal.projectileImpact", target)
	local damage = 0
	if not ability.rune_a_a_level then
		ability.rune_a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
	end
	damage = ability.rune_a_a_level*1820 + 600
	damage = damage*event.mult

	-- local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "sorceress")
	-- if d_b_level > 0 then
	-- 	local manaDrain = caster:GetMaxMana()*0.05
	-- 	if caster:GetMana() < manaDrain then
	-- 		manaDrain = caster:GetMana()
	-- 	end
	-- 	caster:ReduceMana(manaDrain)
	-- 	damage = damage + (manaDrain/100)*0.003*d_b_level
	-- end

   
    -- damage = damage + 0.0002*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*d_a_level*damage
	if target:HasModifier("modifier_ice_lance_frozen") or target:HasModifier("modifier_frost_nova") or target:HasModifier("modifier_eternal_frost_nova") or target:HasModifier("modifier_ice_throw_b_b_frozen") or target:HasModifier("modifier_elemental_overload_frozen") or target:HasModifier("modifier_alarana_frost_nova") then
		local damageMult = 3
		if caster:HasModifier("modifier_sorceress_glyph_5_a") then
			damageMult = 35
		end
		damage = damage * damageMult
		target:RemoveModifierByName("modifier_ice_lance_frozen")
		target:RemoveModifierByName("modifier_frost_nova")
		target:RemoveModifierByName("modifier_eternal_frost_nova")
		target:RemoveModifierByName("modifier_ice_throw_b_b_frozen")
		target:RemoveModifierByName("modifier_elemental_overload_frozen")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ice_lance_immune", {duration = 12})
		EmitSoundOn("Hero_Lich.ChainFrostImpact.Hero", target)
		local particleName = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
      	local origin = target:GetAbsOrigin()
      	ParticleManager:SetParticleControl( particle1, 0, origin )
      	ParticleManager:SetParticleControl( particle1, 1, origin )
      	Timers:CreateTimer(1, function()
      		ParticleManager:DestroyParticle(particle1, false)
      	end)
	end
	local current_stack = target:GetModifierStackCount( "modifier_ice_lance_cold", ability )
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ice_lance_cold", {duration = 5})
    target:SetModifierStackCount( "modifier_ice_lance_cold", ability, current_stack+1 )
    if current_stack >= 5 and not target:HasModifier("modifier_ice_lance_immune") then
    	target:RemoveModifierByName("modifier_ice_lance_cold")
    	EmitSoundOn("hero_Crystal.frostbite", target)
    	local freezeDuration = ability.rune_a_a_level*0.04 + 3.0
    	ability:ApplyDataDrivenModifier(caster, target, "modifier_ice_lance_frozen", {duration = freezeDuration})
    end
    local blinkAbility = caster:FindAbilityByName("sorceress_blink")
    blinkAbility.d_b_damage = damage
    blinkAbility.baseIndex = 1
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)

    if ability:GetAbilityName() == "ice_lance" then
    	local pfx = ParticleManager:CreateParticle("particles/roshpit/sorceress/ice_lance_impact_explosion.vpcf", PATTACH_CUSTOMORIGIN, caster)
    	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()+Vector(0,0,50))
    	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+Vector(0,0,50))
    	Timers:CreateTimer(1.5, function()
    		ParticleManager:DestroyParticle(pfx, false)
    	end)
    	print("ICE LANCE??")
    	local blizzardAbility = caster:FindAbilityByName("blizzard")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local shards = 0
		EmitSoundOn("Sorceress.IceLanceFracture", target)
		for i = 1, #enemies, 1 do
			local enemy = enemies[i]
			if enemy:GetEntityIndex() == target:GetEntityIndex() then
			else
				print("SPLIT?")
	   			local info = 
				{
					Target = enemy,
					Source = enemy,
					Ability = blizzardAbility,	
					EffectName = "particles/roshpit/sorceress/ice_lance_fracture.vpcf",
					vSourceLoc= target:GetAbsOrigin(),
					bDrawsOnMinimap = false, 
				        bDodgeable = true,
				        bIsAttack = false, 
				        bVisibleToEnemies = true,
				        bReplaceExisting = false,
				        flExpireTime = GameRules:GetGameTime() + 4,
					bProvidesVision = false,
					iVisionRadius = 0,
					iMoveSpeed = 720,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				local projectile = ProjectileManager:CreateTrackingProjectile(info)
				shards = shards + 1

				if shards == 2 then
					break
				end
			end
		end
    end
end

function ice_lance_think(event)
	local caster = event.caster
	local blizzard = caster:FindAbilityByName("blizzard")
	if blizzard:GetCooldownTimeRemaining() < 0.1 then
		caster:RemoveModifierByName("modifier_blizzard_cooldown")
	end
end
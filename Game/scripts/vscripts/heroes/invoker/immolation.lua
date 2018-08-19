function begin_immolation(event)
	local caster = event.caster
	local ability = event.ability
	if caster.fireAspect then
		immolate(caster.fireAspect, event.radius, caster, event.damage)
		EmitSoundOn("Conjuror.ImmolationSub", caster.fireAspect)
	end
	caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "conjuror")
	local fv = caster:GetForwardVector()
	local casterOrigin = caster:GetAbsOrigin()

	EmitSoundOn("Conjuror.Immolation", caster)

	arc_piece(casterOrigin, fv, ability, caster)
	arc_piece(casterOrigin+WallPhysics:rotateVector(fv, math.pi/2)*50-fv*50, fv, ability, caster)
	arc_piece(casterOrigin+WallPhysics:rotateVector(fv, -math.pi/2)*50-fv*50, fv, ability, caster)
	arc_piece(casterOrigin+WallPhysics:rotateVector(fv, math.pi/2)*100-fv*100, fv, ability, caster)
	arc_piece(casterOrigin+WallPhysics:rotateVector(fv, -math.pi/2)*100-fv*100, fv, ability, caster)


	Filters:CastSkillArguments(2, caster)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_w_2")
	local w_2_level = get_w_2_level(caster)
	if w_2_level > 0 then
		local b_b_duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_soul_sear_visible_friendly", {duration = b_b_duration})
		runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_soul_sear_buff_effect", {duration = b_b_duration})
	    local current_stack = caster:GetModifierStackCount( "modifier_soul_sear_visible_friendly", runeAbility )
	    local stacks = math.min(current_stack+1, 3)
	    caster:SetModifierStackCount( "modifier_soul_sear_visible_friendly", runeAbility, stacks )
	    caster:SetModifierStackCount( "modifier_soul_sear_buff_effect", runeAbility, stacks*w_2_level )
	end
end

function get_w_2_level(caster)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_w_2")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_2")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function immolate(fireAspect, radius, caster, damage)
	local aspectPosition = fireAspect:GetAbsOrigin()
	local immolateParticle = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
	local pfx = ParticleManager:CreateParticle( immolateParticle, PATTACH_CUSTOMORIGIN, aspect )
	ParticleManager:SetParticleControl( pfx, 0, aspectPosition )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 0, 0) )
	ParticleManager:SetParticleControl( pfx, 3, Vector(0, 0, 0) )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), aspectPosition, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		end
	end 	
end

function arc_piece(projectileOrigin, fv, ability, caster)
	local projectileParticle = "particles/units/heroes/hero_phantom_lancer/immolation_phantomlancer_spiritlance_projectile.vpcf"

	local start_radius = 110
	local end_radius = 110
	local range = 1400
	local speed = 1100
		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = projectileOrigin+Vector(0,0,100),
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
	        	fExpireTime = GameRules:GetGameTime() + 4.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
end

function arc_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage/3
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_w_2")
	local w_2_level = get_w_2_level(caster)
	if w_2_level > 0 then
		runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_soul_sear_visible_enemy", {duration = 12})
		runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_soul_sear_debuff_effect", {duration = 12})
	    local current_stack = target:GetModifierStackCount( "modifier_soul_sear_visible_enemy", runeAbility )
	    local stacks = math.min(current_stack+1, 3)
	    target:SetModifierStackCount( "modifier_soul_sear_visible_enemy", runeAbility, stacks )
	    target:SetModifierStackCount( "modifier_soul_sear_debuff_effect", runeAbility, stacks*w_2_level )
	end
end




function fire_aspect_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local attack_damage = event.attack_damage
	print("aspect_attack")
	local luck = RandomInt(1, 10)
	if luck <= 3 then
		local w_3_level = 0
		if attacker.conjuror then
			w_3_level = get_w_3_level(attacker.conjuror)
		else
			w_3_level = get_w_3_level(attacker)
		end
		print("luck passed")
		if w_3_level > 0 then
			print("w_3_level is good lets go")
			local bonusDamage = attack_damage*(w_3_level*0.45+0.1)
			Filters:TakeArgumentsAndApplyDamage(target, attacker, bonusDamage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			PopupDamage(target, bonusDamage+attack_damage)
			EmitSoundOn("Hero_Batrider.Flamebreak", target)
			if attacker.conjuror then
				immolate(target, 260, attacker.conjuror, bonusDamage)
				if attacker.conjuror:HasModifier("modifier_conjuror_glyph_6_1") then
					fire_breath(attacker, event.ability, attacker.conjuror, bonusDamage)
				end
			else
				immolate(target, 260, attacker, bonusDamage)
			end
			
		end
	end
	if attacker:HasModifier("modifier_fire_aspect_b_d_effect") then
		local callOfElements = attacker.conjuror:FindAbilityByName("call_of_elements")
		callOfElements:ApplyDataDrivenModifier(attacker.conjuror, target, "modifier_fire_aspect_b_d_armor_shred", {duration = 8})
		target:SetModifierStackCount("modifier_fire_aspect_b_d_armor_shred", attacker.conjuror, callOfElements.r_2_level)
	end
end

function fire_breath(fireAspect, ability, conjuror, damage)
	ability.conjuror = conjuror
	ability.flamebreathDamage = damage*5
	local caster = fireAspect
	local start_radius = 120
	local end_radius = 400
	local range = 600
	local speed = 700
	local fv = caster:GetForwardVector()
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin()+fv*20,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_origin",
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

function fire_breath_strike(event)
	local ability = event.ability
	local target = event.target

	Filters:TakeArgumentsAndApplyDamage(target, ability.conjuror, ability.flamebreathDamage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function get_w_3_level(caster)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_w_3")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_3")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end


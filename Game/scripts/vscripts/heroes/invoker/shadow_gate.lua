function shadow_gate_cast(event)
	local caster = event.caster
	local ability = event.ability
    local target = event.target_points[1]
    local casterOrigin = caster:GetAbsOrigin()
    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    local b_c_level = get_b_c_level(caster)

    ability.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "conjuror")
    local lanceParticle = "particles/units/heroes/hero_phantom_lancer/shadow_flare_phantomlancer_spiritlance_projectile.vpcf"
    if ability.e_4_level > 0 then
    	lanceParticle = "particles/units/heroes/hero_phantom_lancer/conjuror_d_c_phantomlancer_spiritlance_projectile.vpcf"
    end
    if b_c_level > 0 then
    	local fv = (target-casterOrigin):Normalized()*Vector(1,1,0)
    	ability.e_2_damage = b_c_level*1000 + 1000 + caster:GetAgility()*4*b_c_level
    	ability.e_4_pure_damage = ability.e_2_damage*0.15*ability.e_4_level
		arc_piece_shadow(casterOrigin, fv, ability, caster, lanceParticle)
		arc_piece_shadow(casterOrigin+WallPhysics:rotateVector(fv, math.pi/2)*50-fv*50, fv, ability, caster, lanceParticle)
		arc_piece_shadow(casterOrigin+WallPhysics:rotateVector(fv, -math.pi/2)*50-fv*50, fv, ability, caster, lanceParticle)
		arc_piece_shadow(casterOrigin+WallPhysics:rotateVector(fv, math.pi/2)*100-fv*100, fv, ability, caster, lanceParticle)
		arc_piece_shadow(casterOrigin+WallPhysics:rotateVector(fv, -math.pi/2)*100-fv*100, fv, ability, caster, lanceParticle)
    end
    EmitSoundOn("Hero_ShadowDemon.Soul_Catcher.Cast", caster.shadowAspect)
    shadowParticle(caster:GetAbsOrigin(), caster)
	FindClearSpaceForUnit(caster, target, true)
  
    if caster.earthAspect then
    	shadowParticle(caster.earthAspect:GetAbsOrigin(), caster)
    	FindClearSpaceForUnit(caster.earthAspect, target, true)
    	local healAmount = caster.earthAspect:GetMaxHealth()

    	Filters:ApplyHeal(caster, caster.earthAspect, healAmount, true)
    end
    if caster.fireAspect then
    	shadowParticle(caster.fireAspect:GetAbsOrigin(), caster)
    	FindClearSpaceForUnit(caster.fireAspect, target, true)  
    	local healAmount = caster.fireAspect:GetMaxHealth()
    	Filters:ApplyHeal(caster, caster.fireAspect, healAmount, true)	
    end
    if caster.shadowAspect then
    	shadowParticle(caster.shadowAspect:GetAbsOrigin(), caster)
    	FindClearSpaceForUnit(caster.shadowAspect, target, true)   	
    	local healAmount = caster.shadowAspect:GetMaxHealth()
    	Filters:ApplyHeal(caster, caster.shadowAspect, healAmount, true)
    end
    if caster.deity then
    	shadowParticle(caster.deity:GetAbsOrigin(), caster)
    	FindClearSpaceForUnit(caster.deity, target, true)   	
    	-- local healAmount = caster.deity:GetMaxHealth()
    	-- Filters:ApplyHeal(caster, caster.shadowAspect, healAmount, true)
    end
    ability:ApplyDataDrivenThinker(caster, target, "shadow_gate_thinker", {})
    if caster:HasModifier("modifier_call_of_shadow") and caster:HasModifier("modifier_conjuror_glyph_3_1") then
		ability:EndCooldown()
		ability:StartCooldown(4)
    end
    Filters:CastSkillArguments(3, caster)
    ProjectileManager:ProjectileDodge(caster)
end

function shadowParticle(position, caster)
    local shadowParticle = "particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf"
	local pfx = ParticleManager:CreateParticle( shadowParticle, PATTACH_CUSTOMORIGIN, caster.shadowAspect )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, position )
	ParticleManager:SetParticleControl( pfx, 2, position )
	ParticleManager:SetParticleControl( pfx, 3, position )
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle( pfx, false )
	end)
	
end

function get_b_c_level(caster)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_e_2")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "e_2")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function shadow_gate_damage(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
end




function arc_piece_shadow(projectileOrigin, fv, ability, caster, shadowProjectile)
	local projectileParticle = shadowProjectile

	local start_radius = 110
	local end_radius = 110
	local range = 1800
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
	local damage = ability.e_2_damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
	local pureDamage = ability.e_4_pure_damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, pureDamage, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
end
function StartCone(event)
	local caster = event.caster
	local ability = event.ability
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

end

function fireCone(args)

	local caster = args.caster
	local ability = args.ability
	ability.a_b_level = a_b_level(caster, ability)
	ability.b_b_level = b_b_level(caster)	
	if ability.b_b_level > 0 then
		local coneImpactSelfTable = {}
		coneImpactSelfTable.caster = caster
		coneImpactSelfTable.ability = ability
		coneImpactSelfTable.damage = args.damage
		coneImpactSelfTable.target = caster
		cone_impact(coneImpactSelfTable)
	end
	-- rune_c_b(caster, ability)
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local spellOrigin = origin+fv*80
	--A Liner Projectile must have a table with projectile info
	caster.holy_cone_direction = fv
	local info = 
	{
		Ability = args.ability,
        	EffectName = "particles/units/heroes/hero_queenofpain/holy_cone.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = 1300,
        	fStartRadius = 100,
        	fEndRadius = 400,
        	Source = caster,
        	StartPosition = "attach_attack2",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * 1000,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	local modifierKnockback =
	{
		center_x = spellOrigin.x,
		center_y = spellOrigin.y,
		center_z = spellOrigin.z,
		duration = 0.5,
		knockback_duration = 0.5,
		knockback_distance = 200,
		knockback_height = 100,
		should_stun = 0
	}
	caster.cone_velocity = 50
	caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
	--caster:RemoveModifierByName("modifier_knockback")
    --caster:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback );
    if caster:HasModifier("modifier_paladin_glyph_4_1") then
    else
	    Timers:CreateTimer(0.03, function()
	    	ability:ApplyDataDrivenModifier(caster, caster, "modifier_holy_cone", {duration = 0.5})
	    end)
	end
    Filters:CastSkillArguments(2, caster)
end

function a_b_level(caster, ability)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("paladin_rune_a_b")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_b")
	local totalLevel = abilityLevel + bonusLevel
	ability.a_b_damage = (150 + totalLevel*200)/2
	ability.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
	if caster:HasModifier("modifier_paladin_glyph_5_1") then
		ability.a_b_damage = ability.a_b_damage * 3
	end
  	return totalLevel
end

function b_b_level(caster)
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("paladin_rune_b_b")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_b")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function knockback_interval(keys)
	
	local caster = keys.caster
	local modifier = caster:FindModifierByName("modifier_holy_cone")
	local origin = caster:GetAbsOrigin()
	local fv = caster.holy_cone_direction
	caster.blowback = true
	if not caster.cone_velocity then
		caster.cone_velocity = 50
	end
	local obstruction = WallPhysics:FindNearestObstruction(origin*Vector(1,1,0))
    
    -- if blockUnit then
    -- 	caster.cone_velocity = -1
    -- end
	local newPosition = origin-(fv*caster.cone_velocity)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition*Vector(1,1,0), caster)
	caster.cone_velocity = math.max(caster.cone_velocity - 4, 0)
	local groundPosition = GetGroundPosition( newPosition, caster )
	if origin.z - groundPosition.z > -200 then
		if not blockUnit then
			if caster.cone_velocity < 2 then
				FindClearSpaceForUnit(caster, groundPosition, false)
			else
				caster:SetAbsOrigin(groundPosition)
			end
		end
	end
end

function cone_impact(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	if caster:HasModifier("modifier_paladin_glyph_5_1") then
		damage = damage*3
	end
	if caster:GetTeamNumber() == target:GetTeamNumber() then
		if ability.b_b_level > 0 then
			local amount = damage*ability.b_b_level*0.04
			amount = math.floor(amount)
			ability:ApplyDataDrivenModifier(caster, target, "holy_cone_heal_effect", {})

			-- d_b_heal(caster, target, ability, amount)
			Filters:ApplyHeal(caster, target, amount, false)
		end
	else
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		apply_holy_fire(caster, target, ability)
	end
end

function apply_holy_fire(caster, target, ability)
	if not ability.d_a_level then
		ability.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
	end
	if not ability.a_b_level then
		a_b_level(caster, ability)
	end
	if not ability.b_b_level then
		ability.b_b_level = b_b_level(caster)	
	end
	if ability.a_b_level > 0 then
		local burnDuration = ability.a_b_level*0.3 + 1
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_rune_a_b", {duration = burnDuration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_holy_fire_burn_effect", {duration = burnDuration})
		if ability.d_a_level > 1 then
			print("STACKS!")
			local stackCount = target:GetModifierStackCount("modifier_paladin_rune_a_b", caster)
			local newStacks = math.min(stackCount + 1, ability.d_a_level + 1)
			target:SetModifierStackCount("modifier_paladin_rune_a_b", caster, newStacks)
		end
	end
end

function d_b_heal(caster, target, ability, origHeal)
	local d_a_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 0)
	if d_a_level > 0 then
		Filters:ApplyHeal(caster, ally, origHeal, false)
		local actualHeal = math.min(target:GetMaxHealth() - target:GetHealth(), origHeal)
		local shieldAmount = origHeal - actualHeal
		if not target.paladin_d_b_absorb then
			target.paladin_d_b_absorb = 0
		end
		target.paladin_d_b_absorb = math.min(target.paladin_d_b_absorb + shieldAmount, target:GetMaxHealth()*0.04*d_b_level)
		local shieldDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_rune_b_b_shield", {duration = shieldDuration})
	end
end

function modifier_on_destroy(keys)
	local caster = keys.caster
	caster.blowback = false
	local origin = caster:GetAbsOrigin()
	FindClearSpaceForUnit(caster, origin, true)
	caster.cone_velocity = nil	
end

function a_b_DamageThink(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = ability.a_b_damage
	-- damage = damage + 0.0004*(caster:GetIntellect()+caster:GetStrength()+caster:GetAgility())/10*ability.d_b_level*damage
	-- ability.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
	local stacks = target:GetModifierStackCount("modifier_paladin_rune_a_b", caster)
	stacks = math.max(1, stacks)
	for i = 1, stacks, 1 do
		damage = damage + (ability.a_b_damage*0.20)*i
	end
	-- damage = damage + ability.a_b_damage*(stacks-1)
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_HOLY, RPC_ELEMENT_FIRE)
end
--DESIRED OUTPUT: 100, 210, 331, 463

function c_b_attacked(event)
	local luck = RandomInt(1,100)
	if luck <= 15 then
		rune_c_b(event.caster, event.ability)
	end
end

function rune_c_b(caster, ability)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("paladin_rune_c_b")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_b")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
  		local radius = 550
  		local damage = totalLevel*5*caster:GetIntellect()

		-- local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
		-- damage = damage + 0.0007*caster:GetIntellect()/10*d_b_level*damage
		-- damage = damage + 0.0004*(caster:GetIntellect()+caster:GetStrength()+caster:GetAgility())/10*d_b_level*damage
		damage = math.floor(damage)

  		EmitSoundOn("Paladin.HolyNova", caster)
		local particleName =  "particles/units/heroes/hero_elder_titan/paladin_holy_nova.vpcf"
		local position = caster:GetAbsOrigin()
		local particleVector = position

		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)  
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_paladin_c_b_disarm", {duration = 1})
			end
		end
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local heal = math.floor(damage/25)
		if #allies > 0 then
			for _,ally in pairs(allies) do
				-- d_b_heal(caster, ally, ability, heal)
				ability:ApplyDataDrivenModifier(caster, ally, "holy_cone_heal_effect", {})
				Filters:ApplyHeal(caster, ally, heal, false)
			end
		end  
  end
end

function paladin_attack_land(event)
	local attacker = event.attacker
	local caster = attacker
	local ability = event.ability
	local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "paladin")
	if c_a_level > 0 then
		local duration = c_a_level*0.1 + 0.8		
		caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		local currentStacks = caster:GetModifierStackCount("modifier_paladin_rune_c_a_shield", caster)
		local maxStacks = 1
		if caster:HasModifier("modifier_paladin_immortal_weapon_1") then
			maxStacks = 7
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_paladin_rune_c_a_shield", {duration = duration})
		local newStacks = math.min(currentStacks+1, maxStacks)
		caster:SetModifierStackCount("modifier_paladin_rune_c_a_shield", caster, newStacks)
	end
end
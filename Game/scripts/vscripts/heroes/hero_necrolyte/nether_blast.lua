function nether_blaster_phase_start(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_ATTACK, rate=2.5})
end

function begin_blasts(event)
	local caster = event.caster
	local ability = event.ability
	local blast_count = event.blast_count
	local radius = event.radius
	local damage = event.damage
	location = caster:GetOrigin()
	forwardVector = caster:GetForwardVector()
	abilityLevel = ability:GetLevel()
	ability.c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "venomort")
	caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "venomort")
	for i = 1, blast_count, 1 do
		targetPoint = location + forwardVector*i*200
		create_blast(abilityLevel, caster, targetPoint, radius, damage, ability)
	end
	if caster:HasModifier("modifier_venomort_immortal_weapon_2") then
		for j = -1, 1, 1 do
			if j == 0 then
			else
				local rotatedFV = WallPhysics:rotateVector(forwardVector, 2*math.pi*j/16)
				for i = 1, blast_count, 1 do
					targetPoint = location + rotatedFV*i*200
					create_blast(abilityLevel, caster, targetPoint, radius, damage, ability)
					rune_b_b(caster, rotatedFV, location, ability)
				end
			end
		end
	end
	rune_b_b(caster, forwardVector, location, ability)
	rune_c_b(caster)
	if caster:HasModifier("modifier_venomort_glyph_2_1") then
		local glyphDuration = Filters:GetAdjustedBuffDuration(caster, 2, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_glyph_2_1_effect", {duration = glyphDuration})
	end
	if caster:HasModifier("modifier_venomort_immortal_weapon_1") then
		local weaponDuration = Filters:GetAdjustedBuffDuration(caster, 3.5, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_legendary_weapon", {duration = weaponDuration})
	end
	Filters:CastSkillArguments(2, caster)
	
end

function rune_c_b(caster)
  local runeUnit = caster.runeUnit3
  local ability = runeUnit:FindAbilityByName("venomort_rune_c_b")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_b")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
  	local duration = 3
  	if caster:HasModifier("modifier_venomort_glyph_6_1") then
  		duration = duration + 5
  	end
  	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
    ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_venomort_rune_c_b_visible", {duration = duration})
    ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_venomort_rune_c_b_invisible", {duration = duration})
    local current_stack = caster:GetModifierStackCount( "modifier_venomort_rune_c_b_visible", ability )
    if current_stack < 20 then
    	local newStack = current_stack + 1
    	caster:SetModifierStackCount( "modifier_venomort_rune_c_b_visible",  ability, newStack )
    	ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_venomort_rune_c_b_invisible", {duration = duration})
    	caster:SetModifierStackCount( "modifier_venomort_rune_c_b_invisible", ability, newStack*totalLevel )
	end
  end
end

function create_blast(abilityLevel, caster, targetPoint, radius, damage, ability)
    local particleName =  "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"
    local particleVector = targetPoint
    if caster:HasModifier("modifier_venomort_rune_c_b_visible") then
    	local stacks = caster:GetModifierStackCount("modifier_venomort_rune_c_b_visible", caster.runeUnit3)
    	damage = damage + damage*0.04*ability.c_b_level*stacks
    end
    if caster:HasModifier("modifier_venomort_immortal_weapon_2") then
    	damage = damage + caster:GetAverageTrueAttackDamage(caster)
    end
      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster )
      ParticleManager:SetParticleControl( pfx, 0, particleVector )
      ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
        Timers:CreateTimer(0.4, function() 
          ParticleManager:DestroyParticle( pfx, false )
        end)  
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius+10, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
		end
	end 
end

function rune_b_b(caster, forwardVector, location, blast_ability)
    local runeUnit = caster.runeUnit2
    local ability = runeUnit:FindAbilityByName("venomort_rune_b_b")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_b")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
		b_b_skull(totalLevel, caster, forwardVector, location, blast_ability)
    end
end

function b_b_skull(abilityLevel, caster, fv, casterOrigin, ability)
	local start_radius = 350
	local end_radius = 350
	local range = 600 + abilityLevel*10
	if range > 2400 then
		range = 2400
	end
	local speed = (range*7)/5
	local damage = abilityLevel*800 + 400
    if caster:HasModifier("modifier_venomort_rune_c_b_visible") then
    	local stacks = caster:GetModifierStackCount("modifier_venomort_rune_c_b_visible", caster.runeUnit3)
    	print("STACKS: "..stacks)
    	damage = damage + damage*0.04*ability.c_b_level*stacks
    end
	local particleName = "particles/units/heroes/hero_vengeful/venomort_rune_b_b_wave.vpcf"
	if caster:HasModifier("modifier_venomort_glyph_3_1") then
		particleName = "particles/units/heroes/venomort/glyph_3_1_venomort_rune_b_b_wave.vpcf"
		damage = damage*5
	end
	ability.damage = damage
	local info = 
	{
			Ability = ability,
        	EffectName = particleName,
        	vSpawnOrigin = casterOrigin,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = false,
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

function b_b_damage(event)
	local target = event.target
	local caster = event.caster
	local damage = event.ability.damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_POISON, RPC_ELEMENT_GHOST)
end
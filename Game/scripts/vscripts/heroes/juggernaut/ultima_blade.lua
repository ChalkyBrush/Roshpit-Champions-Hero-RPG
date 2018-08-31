function start_ultima(event)
	local caster = event.caster
	local ability = event.ability

	local fv = caster:GetForwardVector()
	local casterOrigin = caster:GetAbsOrigin()
	local rangeblast = event.range
	Timers:CreateTimer(0.35, function()
		fire_projectile(caster, fv, casterOrigin, event, rangeblast)
	end)
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_ATTACK_EVENT, rate=0.8})
		EmitSoundOn("Hero_Juggernaut.BladeDance", caster)
	end)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("juggernaut_jugg_ability_bladefury_12", caster)
		rune_r_1(caster, fv)
	end)
	if ability.r_2_level > 0 then
		local duration = 1+ability.r_2_level*0.15
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		ability.runeAbility:ApplyDataDrivenModifier(ability.runeUnit, caster, "modifier_monk_rune_r_2_immunity", {duration = duration})
		EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)
	end
	-- local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "monk")
	-- if c_d_level > 0 then
	--   	local rush = caster:FindAbilityByName("monk_ultima_blade_heal_alt")
	--   	if not rush then
	--   		rush = caster:AddAbility("monk_ultima_blade_heal_alt")
	--   	end
	--   	local cooldown = ability:GetCooldownTimeRemaining()
	--   	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ultima_cooldown", {duration = cooldown})
	--   	rush:SetLevel(ability:GetLevel())
	--   	rush:SetAbilityIndex(3)
	--   	caster:SwapAbilities("monk_ultima_blade", "monk_ultima_blade_heal_alt", false, true)	
	-- end	
	Filters:CastSkillArguments(4, caster)

	ability.damage = event.damage
	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "monk")
	ability.damage = ability.damage + 0.0007*caster:GetStrength()/10*d_d_level*ability.damage
end

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_TAUNT, rate=1, translate="face_me"})
	-- caster:SetAnimation("idle_spin_sword")
	ability.r_2_level = Runes:GetTotalRuneLevel(caster, 2, "r_2", "monk")
	if ability.r_2_level > 0 then
		ability.runeUnit = caster.runeUnit2
		ability.runeAbility = ability.runeUnit:FindAbilityByName("monk_rune_r_2")
		Timers:CreateTimer(0.6, function()
			ability.runeAbility:ApplyDataDrivenModifier(ability.runeUnit, caster, "modifier_monk_rune_r_2_charge_up", {duration = 2.5})
		end)
	end
end

function end_channel(event)
	local caster = event.caster
	-- caster:RemoveModifierByName("modifier_monk_rune_r_2_charge_up")
	EndAnimation(caster)
end

function rune_r_1(caster, fv)
	local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "monk")
	if a_d_level > 0 then
		local runeUnit = caster.runeUnit
		local ability = runeUnit:FindAbilityByName("monk_rune_r_1")
		ability.caster = caster
		ability.damage = a_d_level*3500

	    local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "monk")
	    ability.damage = ability.damage + 0.0007*caster:GetStrength()/10*d_d_level*ability.damage

		local casterOrigin = caster:GetAbsOrigin()
		a_d_tornado(caster, ability, fv, casterOrigin, a_d_level)
		a_d_tornado(caster, ability, WallPhysics:rotateVector(fv, math.pi/8), casterOrigin, a_d_level)
		a_d_tornado(caster, ability, WallPhysics:rotateVector(fv, -math.pi/8), casterOrigin, a_d_level)
	end
end

function a_d_tornado(caster, ability, fv, casterOrigin, a_d_level)
	local start_radius = 240
	local end_radius = 240
	local range = 700 + 25*a_d_level
	local speed = 900
	
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_invoker/monk_ultima_tornado.vpcf",
        	vSpawnOrigin = casterOrigin+fv*90+Vector(0,0,0),
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_sword",
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

function a_d_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.caster
	local damage = ability.damage
	if caster:HasModifier("modifier_monk_glyph_1_1") then
		damage = damage*1.4
	end
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })	
end

function fire_projectile(caster, fv, casterOrigin, event, rangeblast)

	local ability = event.ability
	local start_radius = 220
	local end_radius = 220
	local range = rangeblast
	local speed = 900
	local damage = 500
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_dragon_knight/monk_ulti.vpcf",
        	vSpawnOrigin = casterOrigin+fv*60+Vector(0,0,30),
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_sword",
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
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin+fv*140, nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = 0.28,
			knockback_duration = 0.26,
			knockback_distance = 140,
			knockback_height = 20,
		}
	      
		if #enemies > 0 then
			EmitSoundOn("Hero_Juggernaut.Attack", caster)
			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )	
				local damage = caster:GetAverageTrueAttackDamage(caster)*3
				Filters:ApplyDamageBasic(enemy,caster,damage,DAMAGE_TYPE_PHYSICAL)
				-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })	
			end
		end
end

function projectileHit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = event.damage
	if caster:HasModifier("modifier_monk_glyph_1_1") then
		damage = damage*1.4
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4)
end

function start_channel_heal(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_TAUNT, rate=1, translate="face_me"})
	ability.r_3_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "monk")
	-- caster:SetAnimation("idle_spin_sword")
end

function start_ultima_heal(event)
	local caster = event.caster
	local ability = event.ability

	local fv = caster:GetForwardVector()
	local casterOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(0.35, function()
		fire_heal_projectile(caster, fv, casterOrigin, event)
	end)
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_ATTACK_EVENT, rate=0.8})
		EmitSoundOn("Hero_Juggernaut.HealingWard.Cast", caster)
	end)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("juggernaut_jug_level_04", caster)
	end)
	cooldownEnd(event)
end

function fire_heal_projectile(caster, fv, casterOrigin, event)

	local ability = event.ability
	local start_radius = 220
	local end_radius = 220
	local range = 900
	local speed = 450
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_dragon_knight/ultima_heal.vpcf",
        	vSpawnOrigin = casterOrigin+fv*60+Vector(0,0,50),
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_sword",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function projectileHitHeal(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability.damage
	ability:ApplyDataDrivenModifier(caster, target, "modifier_monk_ulti_heal", {duration = 5})
	target:SetModifierStackCount( "modifier_monk_ulti_heal", ability, ability.r_3_level )
end

function cooldownEnd(event)
	local ability = event.ability
	local caster = event.caster
	local level = caster:FindAbilityByName("monk_ultima_blade_heal_alt"):GetLevel()
  	ability:SetLevel(level)
  	caster:SwapAbilities("monk_ultima_blade", "monk_ultima_blade_heal_alt", true, false)	
end

function rune_unit_3_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local totalLevel = Runes:GetTotalRuneLevel(hero, 3, "r_3", "monk")
	print("RUNNING?")
	if totalLevel > 0 then
		local stackCount = hero:GetAgility()*0.2*totalLevel
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_monk_rune_r_3_effect", {})
		hero:SetModifierStackCount( "modifier_monk_rune_r_3_effect", ability, stackCount )
	end
end
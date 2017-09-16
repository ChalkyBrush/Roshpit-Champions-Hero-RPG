function hikari_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.heal = event.heal

    local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "monk")
    ability.heal = ability.heal + 0.0006*caster:GetAgility()/10*d_b_level*ability.heal
    caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "monk")

	ability.radius = event.radius
	ability.originalAbility = ability
	local a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "monk")
	ability.a_b_level = a_b_level
	if a_b_level > 0 then
		a_b_effect(caster, ability, d_b_level)
	end
	-- if caster:HasModifier("modifier_monk_b_b_up") then
	-- 	begin_b_b(caster, event.radius, event.heal, ability, caster:GetAbsOrigin())
	-- else
	-- 	local b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "monk")
	-- 	if b_b_level > 0 and not caster:HasModifier("modifier_monk_b_b_up") and not caster:HasModifier("modifier_monk_b_b_down") then
	-- 		local runeUnit = caster.runeUnit2
	-- 		local runeAbility = runeUnit:FindAbilityByName("monk_rune_b_b")
	-- 		runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_monk_b_b_up", {})
	-- 	end
	-- end
	if caster:HasModifier("modifier_monk_glyph_6_1") then
		StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_CAST_ABILITY_2, rate=2.5})
	end
	Filters:CastSkillArguments(2, caster)
	hikari_heal(caster, caster:GetAbsOrigin(), ability, 1)

	local b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "monk")
	if b_b_level > 0 then
		new_b_b(caster, ability, b_b_level)
	end

end

function new_b_b(caster, ability, b_b_level)
	local luck = RandomInt(1,4)
	if luck == 1 then
		local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/death/monkey_king_spring_arcana_death.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(500, 2, 2))

		local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "monk")
		EmitSoundOn("Hydroxis.Ultimate.Start", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seinaru.BBExplosion", Events.GameMaster)
		EndAnimation(caster)
		StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_SPAWN, rate=1.2, translate="odachi"})
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local damage = b_b_level*20000 + 10000
		local stunDuration = 0.04*b_b_level
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stunDuration, enemy)
			end
		end 
	end
end

function a_b_effect(caster, ability, d_b_level)
	local casterOrigin = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	ability.a_b_damage = ability.a_b_level*540
	for i = -6, 6, 1 do
		local rotatedFv = WallPhysics:rotateVector(fv, i*math.pi/6)
		a_b_smoke(caster, rotatedFv, casterOrigin, ability)
	end


end

function a_b_smoke(caster, fv, casterOrigin, ability)
	local start_radius = 180
	local end_radius = 180
	local range = ability.a_b_level*1 + 240
	if range > 600 then
		range = 600
	end
	local speed = 450
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_dragon_knight/monk_hikari_clouds.vpcf",
        	vSpawnOrigin = casterOrigin+fv*30+Vector(0,0,30),
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

function smoke_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability.a_b_damage
	if caster:HasModifier("modifier_monk_glyph_1_1") then
		damage = damage*1.4
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_hikari_slow", {duration = 1.5})
end

function begin_b_b(caster, radius, heal, ability, position)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("monk_rune_b_b")
	
	caster:RemoveModifierByName("modifier_monk_b_b_up")
	runeAbility.sequence = 0
	runeAbility.monk = caster
	runeAbility.radius = radius
	runeAbility.heal = heal
	runeAbility.originalAbility = ability
	local b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "monk")
	local duration = 3
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	runeAbility.duration = duration
	runeAbility.b_b_level = b_b_level


	runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_monk_b_b_active", {duration = duration})
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=0.8})
	
end

function b_b_think(event)

	local ability = event.ability
	local caster = ability.monk
	local sequences = ability.duration*20
	ability.sequence = ability.sequence + 1
	local position = caster:GetAbsOrigin()
	if ability.sequence < sequences*0.3 then
		position = position + Vector(0,0,ability.sequence)
	elseif ability.sequence > sequences*0.7 then
		position = position - Vector(0,0,(sequences-ability.sequence))
	end
	if ability.sequence%3 == 0 then
		EmitSoundOn("Hero_Juggernaut.PreAttack", caster)
	end
	local ampFactor = 1 + 0.05*ability.b_b_level
	if ability.sequence%10 == 0 then
		hikari_heal(caster, position, ability, ampFactor)
	end
	caster:SetAbsOrigin(position)
end

function hikari_heal(caster, position, ability, ampFactor)
	print(caster)
	print(position)
	print(ability)
	print(ampFactor)
	if not ability.radius then
		ability.radius = ability:GetSpecialValueFor("radius")
		ability.originalAbility = ability
		ability.heal = ability:GetSpecialValueFor("heal")
	end
	EmitSoundOn("Hero_Warlock.ShadowWordCastGood", caster)
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, ability.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #allies > 0 then
		for _,ally in pairs(allies) do
			ally:RemoveModifierByName("modifier_monk_heal_effect")
			ability.originalAbility:ApplyDataDrivenModifier(caster, ally, "modifier_monk_heal_effect", {})
			local healAmount = ability.heal*ampFactor
			Filters:ApplyHeal(caster, ally, healAmount, true)
		end
	end  
	if caster:HasModifier("modifier_monk_glyph_5_1") then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, ability.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/monk_glyph_5_1_bushido_heal.vpcf", enemy, 0.65)
				ApplyDamage({ victim = enemy, attacker = caster, damage = ability.heal*ampFactor, damage_type = DAMAGE_TYPE_MAGICAL })	
				PopupDamage(enemy, ability.heal*ampFactor)
			end
		end  
	end
	
end

function rune_c_b_attack(event)
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	local attack_damage = event.attack_damage
	local runeLevel = Runes:GetTotalRuneLevel(attacker, 3, "c_b", "monk")
	if runeLevel > 0 then
		attacker:Heal(attack_damage*0.005*runeLevel, attacker)
		caster:RemoveModifierByName("modifier_monk_rune_c_b_heal_effect")
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_monk_rune_c_b_heal_effect", {duration = 0.5})
	end
end

function seinaru_hikari_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local runeLevel = Runes:GetTotalRuneLevel(caster, 3, "c_b", "monk")
	if runeLevel > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monk_rune_c_b", {})
	else
		caster:RemoveModifierByName("modifier_monk_rune_c_b")
	end
end
require('heroes/juggernaut/seinaru_constants')

function hikari_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.heal = event.heal
	StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.2})
	if not ability.cast_number then
		ability.cast_number = 0
	end
	ability.cast_number = ability.cast_number + 1

	local w_4_level = caster:GetRuneValue("w", 4)
	ability.heal = ability.heal
	caster.w_4_level = w_4_level

	ability.radius = event.radius
	ability.originalAbility = ability
	local w_1_level = caster:GetRuneValue("w", 1)
	ability.w_1_level = w_1_level
	local w_3_level = caster:GetRuneValue("w", 3)
	ability.w_3_level = w_3_level
	if w_1_level > 0 then
		a_b_effect(caster, ability, w_3_level)
	end
	Filters:CastSkillArguments(2, caster)
	hikari_heal(caster, caster:GetAbsOrigin(), ability, 1)

	local w_2_level = caster:GetRuneValue("w", 2)
	if w_2_level > 0 then
		local luck = RandomInt(1, 100)
		if luck <= SEINARU_W2_CHANCE then
			new_b_b(caster, ability, w_2_level)
		end
	end


end

function new_b_b(caster, ability, w_2_level)
	local range = ability:GetSpecialValueFor("radius")
	local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/death/monkey_king_spring_arcana_death.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(range, 2, 2))

	EndAnimation(caster)
	StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_SPAWN, rate = 1.2, translate = "odachi"})
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = w_2_level * SEINARU_W2_DMG
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local damage_vs_the_enemy = damage
			if caster:HasModifier('modifier_seinaru_glyph_5_1') and enemy:HasModifier('modifier_kaze_gust_blind') then
				damage_vs_the_enemy = damage_vs_the_enemy * SEINARU_GLYPH5_W_DMG_AMP_VS_BLINDED
			end
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_typhoon_w_2_magic_armor_loss", {duration = SEINARU_W2_MAGIC_ARMOR_LOSS_DURATION})
			enemy:SetModifierStackCount("modifier_typhoon_w_2_magic_armor_loss", caster, w_2_level)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage_vs_the_enemy, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
			enemy:CalculateAndSaveRoshpitAttributes()
		end
	end
end

function a_b_effect(caster, ability, w_4_level)
	local casterOrigin = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	for i = -6, 6, 1 do
		local rotatedFv = WallPhysics:rotateVector(fv, i * math.pi / 6)
		a_b_smoke(caster, rotatedFv, casterOrigin, ability)
	end

end

function a_b_smoke(caster, fv, casterOrigin, ability)
	local start_radius = 180
	local end_radius = 180
	local range = SEINARU_W1_RANGE_PER_LVL*ability.w_1_level + SEINARU_W1_RANGE_BASE
	local speed = 450
	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_dragon_knight/monk_hikari_clouds.vpcf",
		vSpawnOrigin = casterOrigin + fv * 30 + Vector(0, 0, 30),
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
	if not target.seinaru_w_cast_number or ability.cast_number ~= target.seinaru_w_cast_number then
		local damage = SEINARU_W1_DAMAGE*ability.w_1_level
		print("DAMAGE: "..damage)
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hikari_slow", {duration = 1.5})
		target.seinaru_w_cast_number = ability.cast_number
	end
end

function begin_b_b(caster, radius, heal, ability, position)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("seinaru_rune_w_2")

	caster:RemoveModifierByName("modifier_monk_b_b_up")
	runeAbility.sequence = 0
	runeAbility.monk = caster
	runeAbility.radius = radius
	runeAbility.heal = heal
	runeAbility.originalAbility = ability
	local w_2_level = caster:GetRuneValue("w", 2)
	local duration = 3
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	runeAbility.duration = duration
	runeAbility.w_2_level = w_2_level

	runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_monk_b_b_active", {duration = duration})
	StartAnimation(caster, {duration = duration, activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 0.8})

end

function b_b_think(event)

	local ability = event.ability
	local caster = ability.monk
	local sequences = ability.duration * 20
	ability.sequence = ability.sequence + 1
	local position = caster:GetAbsOrigin()
	if ability.sequence < sequences * 0.3 then
		position = position + Vector(0, 0, ability.sequence)
	elseif ability.sequence > sequences * 0.7 then
		position = position - Vector(0, 0, (sequences - ability.sequence))
	end
	if ability.sequence % 3 == 0 then
		EmitSoundOn("Hero_Juggernaut.PreAttack", caster)
	end
	local ampFactor = 1 + 0.05 * ability.w_2_level
	if ability.sequence % 10 == 0 then
		hikari_heal(caster, position, ability, ampFactor)
	end
	caster:SetAbsOrigin(position)
end

function hikari_heal(caster, position, ability, ampFactor)
	if not ability.radius then
		ability.radius = ability:GetSpecialValueFor("radius")
		ability.originalAbility = ability
		ability.heal = ability:GetSpecialValueFor("heal")
	end
	EmitSoundOn("Hero_Warlock.ShadowWordCastGood", caster)
	local shieldAmount
	if ability.w_3_level then
		shieldAmount = caster:GetAgility() * ability.w_3_level * SEINARU_W3_SHIELD_PER_AGI
	end

	local allies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, ability.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			ally:RemoveModifierByName("modifier_seinaru_hands_of_hikari_effect")
			ability.originalAbility:ApplyDataDrivenModifier(caster, ally, "modifier_seinaru_hands_of_hikari_effect", {})
			local healAmount = ability.heal * ampFactor
			Filters:ApplyHeal(caster, ally, healAmount, true)
			if shieldAmount and shieldAmount > 0 then
				ally.seinaru_c_b_absorb = shieldAmount
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_seinaru_rune_w_3_shield", {duration = SEINARU_W3_DUR_BASE})
			end
		end
	end

end

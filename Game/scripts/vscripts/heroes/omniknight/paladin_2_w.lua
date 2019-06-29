require('heroes/omniknight/paladin_constants')

function StartCone(event)
	local caster = event.caster
	local ability = event.ability
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

end

function fireCone(args)

	local caster = args.caster
	local ability = args.ability
	ability.w_1_level = paladin_get_w_1_level(caster, ability)
	ability.w_2_level = paladin_get_w_2_level(caster)
	if ability.w_2_level > 0 then
		local coneImpactSelfTable = {}
		coneImpactSelfTable.caster = caster
		coneImpactSelfTable.ability = ability
		coneImpactSelfTable.damage = args.damage
		coneImpactSelfTable.target = caster
		cone_impact(coneImpactSelfTable)
	end
	-- rune_w_3(caster, ability)
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local spellOrigin = origin + fv * 80
	--A Liner Projectile must have a table with projectile info
	caster.justice_overwhelming_direction = fv
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
	caster.w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "paladin")
	--caster:RemoveModifierByName("modifier_knockback")
	--caster:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback );
	if caster:HasModifier("modifier_paladin_glyph_4_1") then
	else
		Timers:CreateTimer(0.03, function()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_justice_overwhelming", {duration = 0.5})
		end)
	end
	Filters:CastSkillArguments(2, caster)
end

function paladin_get_w_1_level(caster, ability)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("paladin_rune_w_1")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_1")
	local totalLevel = abilityLevel + bonusLevel
	ability.w_1_damage = (150 + totalLevel * 5000) / 2
	ability.w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "paladin")
	if caster:HasModifier("modifier_paladin_glyph_5_1") then
		ability.w_1_damage = ability.w_1_damage * 3
	end
	return totalLevel
end

function paladin_get_w_2_level(caster)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("paladin_rune_w_2")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_2")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function knockback_interval(keys)

	local caster = keys.caster
	local modifier = caster:FindModifierByName("modifier_justice_overwhelming")
	local origin = caster:GetAbsOrigin()
	local fv = caster.justice_overwhelming_direction
	caster.blowback = true
	if not caster.cone_velocity then
		caster.cone_velocity = 50
	end
	local obstruction = WallPhysics:FindNearestObstruction(origin * Vector(1, 1, 0))

	-- if blockUnit then
	-- caster.cone_velocity = -1
	-- end
	local newPosition = origin - (fv * caster.cone_velocity)
	if caster:HasModifier("modifier_paladin_glyph_4_2") then
		newPosition = origin + (fv * caster.cone_velocity * 0.5)
	end
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), caster)
	caster.cone_velocity = math.max(caster.cone_velocity - 4, 0)
	local groundPosition = GetGroundPosition(newPosition, caster)
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
		damage = damage * 3
	end
	if caster:GetTeamNumber() == target:GetTeamNumber() then
		if ability.w_2_level > 0 then
			local amount = damage * ability.w_2_level * 0.04
			amount = math.floor(amount)
			ability:ApplyDataDrivenModifier(caster, target, "justice_overwhelming_heal_effect", {})

			-- d_b_heal(caster, target, ability, amount)
			Filters:ApplyHeal(caster, target, amount, false)
		end
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_glyph_1_2_effect", {duration = 8})
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		paladin_w_1_apply(caster, target, ability)
	end
end

function paladin_w_1_apply(caster, target, ability)
	ability.w_1_level = caster:GetRuneValue("w", 1)
	ability.w_2_level = caster:GetRuneValue("w", 2)
	ability.w_4_level = caster:GetRuneValue("w", 4)
	if ability.w_1_level > 0 then
		ability.w_1_damage = (PALADIN_W1_BASE_DMG + ability.w_1_level * PALADIN_W1_DMG_PER_LEVEL) / 2
		if caster:HasModifier("modifier_paladin_glyph_5_1") then
			ability.w_1_damage = ability.w_1_damage * 3
		end
		local burnDuration = ability.w_1_level * PALADIN_W1_DURATION_PER_LEVEL + PALADIN_W1_BASE_DURATION
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_rune_w_1", {duration = burnDuration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_holy_fire_burn_effect", {duration = burnDuration})
		if ability.w_4_level > 0 then
			local stackCount = target:GetModifierStackCount("modifier_paladin_rune_w_1", caster)
			local additionalStacks = 1
			if caster:HasModifier("modifier_paladin_glyph_5_1") then
				additionalStacks = additionalStacks + 9
			end
			if caster:HasModifier("modifier_paladin_glyph_4_1") then
				additionalStacks = additionalStacks * 5
			end
			local newStacks = math.min(stackCount + additionalStacks, ability.w_4_level + 1)
			target:SetModifierStackCount("modifier_paladin_rune_w_1", caster, newStacks)
		end
	end
end

function modifier_on_destroy(keys)
	local caster = keys.caster
	caster.blowback = false
	local origin = caster:GetAbsOrigin()
	FindClearSpaceForUnit(caster, origin, true)
	caster.cone_velocity = nil
end

function paladin_w_1_damage_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = ability.w_1_damage
	local stacks = target:GetModifierStackCount("modifier_paladin_rune_w_1", caster)
	stacks = math.max(1, stacks)
	if stacks == 1 then
	elseif stacks > 1 then
		for i = 1, stacks - 1, 1 do
			damage = damage + ability.w_1_damage * (1 + i * PALADIN_W4_DMG_PER_STACK_PCT / 100)
		end
	end
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_HOLY, RPC_ELEMENT_FIRE)
end
--DESIRED OUTPUT: 100, 210, 331, 463

function c_b_attacked(event)
	local luck = RandomInt(1, 100)
	if luck <= 15 then
		rune_w_3(event.caster, event.ability)
	end
end

function rune_w_3(caster, ability)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("paladin_rune_w_3")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_3")
	local totalLevel = abilityLevel + bonusLevel
	if totalLevel > 0 then
		local radius = 550
		local damage = totalLevel * 5 * caster:GetIntellect()
		damage = math.floor(damage)

		EmitSoundOn("Paladin.HolyNova", caster)
		local particleName = "particles/units/heroes/hero_elder_titan/paladin_holy_nova.vpcf"
		local position = caster:GetAbsOrigin()
		local particleVector = position

		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, particleVector)
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_paladin_c_b_disarm", {duration = 1})
			end
		end
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		local heal = math.floor(damage / 25)
		if #allies > 0 then
			for _, ally in pairs(allies) do
				-- d_b_heal(caster, ally, ability, heal)
				ability:ApplyDataDrivenModifier(caster, ally, "justice_overwhelming_heal_effect", {})
				Filters:ApplyHeal(caster, ally, heal, false)
			end
		end
	end
end

function paladin_glyph_4_2_equip(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local pointAbility = target:GetAbilityByIndex(DOTA_W_SLOT)
	if pointAbility then
		if pointAbility.cast_point_og then
		else
			pointAbility.cast_point_og = pointAbility:GetCastPoint()
			pointAbility:SetOverrideCastPoint(0.05)
		end
	end
end

function paladin_glyph_4_2_off(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local index = event.index
	local pointAbility = target:GetAbilityByIndex(DOTA_W_SLOT)
	if pointAbility then
		if pointAbility.cast_point_og then
			pointAbility:SetOverrideCastPoint(pointAbility.cast_point_og)
			pointAbility.cast_point_og = nil
		else
		end
	end
end

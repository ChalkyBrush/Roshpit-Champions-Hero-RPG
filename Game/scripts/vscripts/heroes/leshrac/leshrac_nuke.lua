require('heroes/leshrac/bahamut_arcana_ult')

function begin_judgement(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local damage = event.damage

	ability.damageAmp = 1
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "bahamut")
	local casterOrigin = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	local nukeRange = Filters:GetAdjustedRange(caster, 500)
	local targetPoint = casterOrigin + fv * nukeRange
	targetPoint = GetGroundPosition(targetPoint, caster)
	if caster:HasModifier("modifier_bahamut_glyph_3_1") then
		radius = radius * 1.3
		targetPoint = GetGroundPosition(casterOrigin, caster)
	end
	blast(caster, targetPoint, radius, damage, ability)
	Filters:CastSkillArguments(2, caster)
	local animationTable = {ACT_DOTA_ATTACK, ACT_DOTA_ATTACK2}
	StartAnimation(caster, {duration = 0.25, activity = animationTable[RandomInt(1, #animationTable)], rate = 2.5})
	ability.w_2_level = Runes:GetTotalRuneLevel(caster, 2, "w_2", "bahamut")
	rune_w_3(caster, ability, caster:GetForwardVector())
end

function blast(caster, point, radius, damage, ability)
	EmitSoundOnLocationWithCaster(point, "Hero_Terrorblade.Metamorphosis", caster)
	local particle = "particles/units/heroes/hero_legion_commander/leshrac_nuke.vpcf"
	local pfx10 = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx10, 0, point)
	ParticleManager:SetParticleControl(pfx10, 4, Vector(radius, 0, 0))
	local w_3_level = caster:GetRuneValue("w", 3)
	for i = 5, 12, 1 do
		ParticleManager:SetParticleControl(pfx10, i, point + Vector(0, 0, 280))
	end
	for i = 1, 3, 1 do
		ParticleManager:SetParticleControl(pfx10, i, point + Vector(0, 0, 280))
	end
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx10, true)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		Timers:CreateTimer(0.1, function()
			for _, enemy in pairs(enemies) do
				local damage_with_w_3 = damage + OverflowProtectedGetAverageTrueAttackDamage(enemy) * BAHAMUT_W3_ATTACK_TO_DMG_PCT/100 * w_3_level
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage_with_w_3, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)

				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_leshrac_nuke_judged", {duration = 5})

				if caster:HasModifier("modifier_leshrac_arcana_effect") then
					local arcanaAbility = caster:FindAbilityByName("bahamut_arcana_ulti")
					local arcanaDamage = arcanaAbility:GetSpecialValueFor("damage")
					leshrac_ult_go(arcanaAbility, caster, arcanaDamage, true, enemy)
				end
			end
		end)
	end
end

function c_b_attack_land(event)
	local caster = event.attacker
	local ability = event.ability
	local target = event.target
	local fv = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.damageAmp = 1
	rune_w_3(caster, ability, fv)
	if not ability.w_2_level then
		ability.w_2_level = Runes:GetTotalRuneLevel(caster, 2, "w_2", "bahamut")
	end
end

function rune_w_3(caster, ability, fv)

	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("bahamut_rune_w_3")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_3")
	local totalLevel = abilityLevel + bonusLevel
	runeAbility.totalLevel = totalLevel
	runeAbility.origCaster = caster
	runeAbility.damageAmp = ability.damageAmp
	if totalLevel > 0 then
		local startPoint = caster:GetAbsOrigin()
		local particle = "particles/units/heroes/hero_alchemist/charge_of_light_linear_projectile_concoction_projectile_linear.vpcf"
		local start_radius = 135
		local end_radius = 135
		local range = 1400
		local speed = 900

		EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)

		local casterOrigin = caster:GetAbsOrigin()

		local info =
		{
			Ability = runeAbility,
			EffectName = particle,
			vSpawnOrigin = startPoint + Vector(0, 0, 80),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * Vector(1, 1, 0) * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
		--print("projectile fire")
	end
end

function c_b_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.origCaster
	local damage = BAHAMUT_W3_BASE_DMG + ability.totalLevel * BAHAMUT_W3_DMG

	local w_3_level = caster:GetRuneValue("w", 3)
	damage = damage + OverflowProtectedGetAverageTrueAttackDamage(target) * BAHAMUT_W3_ATTACK_TO_DMG_PCT/100 * w_3_level
	damage = damage * ability.damageAmp
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)

	ability = caster:FindAbilityByName("leshrac_nuke")
	if ability.w_2_level then
		if ability.w_2_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_leshrac_nuke_judged", {duration = 5})
		end
	end
end

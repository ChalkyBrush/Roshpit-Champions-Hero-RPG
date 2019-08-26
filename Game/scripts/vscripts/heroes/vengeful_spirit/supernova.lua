require('heroes/vengeful_spirit/arcana_comet')
require('/heroes/vengeful_spirit/solunia_constants')

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	StartSoundEvent("Solunia.Supernova", caster)
	ability.rotationIndex = 0
	ability.fallVelocity = 1
	ability.startRotation = vectorToAngle(caster:GetForwardVector())
	--print(caster:GetForwardVector())
	--print(ability.startRotation)
	caster:RemoveModifierByName("modifier_solunia_in_between_flare")
	ability.r_3_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "solunia")
	ability.r_3_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * SOLUNIA_R3_WAVE_DMG_PCT/100 * ability.r_3_level
	caster:RemoveModifierByName("modifier_solunia_warp_flare_falling")
	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "solunia")
	if d_d_level > 0 then
		ability:EndCooldown()
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()) - d_d_level * SOLUNIA_R4_CD_RED)
	end
end

function vectorToAngle(vector)
	return math.atan2(vector.y, vector.x) * 180 / math.pi
end

function supernova_a_d(caster, ability)
	if not caster:HasModifier("modifier_solunia_arcana2") then
		local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "solunia")
		if a_d_level > 0 then
			local healthRestore = a_d_level * SOLUNIA_R1_HP
			local manaRestore = a_d_level * SOLUNIA_R1_MANA
			Filters:ApplyHeal(caster, caster, healthRestore, true, false)
			caster:GiveMana(manaRestore)
			PopupHealing(caster, healthRestore)
			PopupMana(caster, manaRestore)
		end
	end
end

function supernova_channeling_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_solunia_in_between_flare") then
		return false
	end
	local rotation = ability.rotationIndex * 6 + ability.startRotation
	caster:SetAngles(0, rotation, 0)
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 2) + Vector(0, 0, math.sin(math.pi * ability.rotationIndex / 30) * 6))
	if (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) > 199 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_ulti_above_ground", {})
	else
		caster:RemoveModifierByName("modifier_solunia_ulti_above_ground")
	end
	ability.rotationIndex = ability.rotationIndex + 1
	if ability.r_3_level > 0 then
		if ability.rotationIndex % 15 == 0 then
			for i = 1, 8, 1 do
				local range = SOLUNIA_R3_RANGE_BASE + SOLUNIA_R3_RANGE * ability.r_3_level
				local speed = range
				local casterOrigin = caster:GetAbsOrigin()
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi * i * 2 / 8)
				local projectileStartPoint = caster:GetAbsOrigin() + fv * range
				local particleName = "particles/roshpit/solunia/a_a_wave_solar.vpcf"
				local fvMult = 1
				if ability:GetAbilityName() == "solunia_eclipse" then
					particleName = "particles/roshpit/solunia/a_a_wave_lunar.vpcf"
					fvMult = -1
					casterOrigin = projectileStartPoint
				end
				local info =
				{
					Ability = ability,
					EffectName = particleName,
					vSpawnOrigin = casterOrigin + Vector(0, 0, 80),
					fDistance = range,
					fStartRadius = 260,
					fEndRadius = 260,
					Source = caster,
					StartPosition = "attach_hitloc",
					bHasFrontalCone = true,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 8.0,
					bDeleteOnHit = false,
					vVelocity = fv * speed * fvMult,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end
		end
	end
end

function begin_supernova(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_warp_flare_falling", {duration = 1})
	StopSoundEvent("Solunia.Supernova", caster)
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local origin = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, -120))
	ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	caster:RemoveModifierByName("modifier_solunia_ulti_above_ground")
	EmitSoundOn("Solunia.Supernova.Explode", caster)
	supernova_a_d(caster, ability)
	novaExplosion(event)
	swap_sun_moon("sun", caster)
	Solunia_Glyph51(event)
end

function begin_eclipse(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_warp_flare_falling", {duration = 1})
	StopSoundEvent("Solunia.Supernova", caster)
	local particleName = "particles/roshpit/solunia/eclipse.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local origin = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, -120))
	ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	caster:RemoveModifierByName("modifier_solunia_ulti_above_ground")
	EmitSoundOn("Solunia.Supernova.Explode", caster)
	supernova_a_d(caster, ability)
	novaExplosion(event)
	swap_sun_moon("moon", caster)
	Solunia_Glyph51(event)
end

function Solunia_Glyph51(event)
	local caster = event.caster
	if caster:HasModifier("modifier_solunia_glyph_5_1") then
		local ability = caster:FindModifierByName("modifier_solunia_glyph_5_1"):GetAbility()
		if caster:HasAbility("solunia_eclipse") or caster:HasAbility("solunia_supernova") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_glyph_5_1_shield", {})
			caster:SetModifierStackCount("modifier_solunia_glyph_5_1_shield", ability, SOLUNIA_GLYPH_5_1_STACKS_BASE)
		elseif caster:HasAbility("solunia_lunar_alpha_spark") or caster:HasAbility("solunia_supernova") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_glyph_5_1_shield_arcana", {})
			caster:SetModifierStackCount("modifier_solunia_glyph_5_1_shield_arcana", ability, SOLUNIA_GLYPH_5_1_STACKS_BASE)
		end
	end
end

function novaExplosion(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local damage = event.damage
	local stun_duration = event.stun_duration
	local r_4_level = caster:GetRuneValue("r", 4)
	if r_4_level > 0 then
		damage = damage + (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) * SOLUNIA_R4_ADD_DMG_PER_ATTR * r_4_level
	end
	if ability:GetAbilityName() == "solunia_eclipse" then
		damageType = DAMAGE_TYPE_PURE
		event.element = "lunar"
	else
		damageType = DAMAGE_TYPE_MAGICAL
		event.element = "solar"
	end
	ability.r_2_level = caster:GetRuneValue("r", 2)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 580, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, damageType, BASE_ABILITY_R, RPC_ELEMENT_COSMOS, RPC_ELEMENT_FIRE)
			Filters:ApplyStun(caster, stun_duration, enemy)
			if ability.r_2_level > 0 then
				Solunia_Apply_R2_Stack(event, enemy)
			end
		end
	end
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 240, false)

	if caster:HasModifier("modifier_solunia_glyph_6_1") then
		local glyph_duration = Filters:GetAdjustedBuffDuration(caster, 8, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_glyph_6_1_ready", {duration = glyph_duration})
	end
	Filters:CastSkillArguments(4, caster)
end

function supernova_burn_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not ability.r_2_level then
		ability.r_2_level = caster:GetRuneValue("r", 2)
		if ability.r_2_level == 0 then
			return
		end
	end
	local dualBurn = false
	if target:HasModifier("modifier_solunia_lunar_burn") and target:HasModifier("modifier_solunia_solar_burn") then
		dualBurn = true
	end
	local totalDamage = 0
	if ability:GetAbilityName() == "solunia_eclipse" and target.SoluniaLunarBurns then
		Solunia_Recalculate_R2_Stacks(event, target, "lunar")
		for i = 1, #target.SoluniaLunarBurns, 1 do
			local damage = target.SoluniaLunarBurns[i].damage
			if dualBurn then
				damage = damage + SOLUNIA_R2_DUAL_BURN_AMP * ability.r_2_level * damage
			end
			totalDamage = totalDamage + damage
		end
		Filters:ApplyDotDamage(caster, ability, target, totalDamage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_COSMOS, RPC_ELEMENT_FIRE)
	elseif ability:GetAbilityName() == "solunia_supernova" and target.SoluniaSolarBurns then
		Solunia_Recalculate_R2_Stacks(event, target, "solar")
		for i = 1, #target.SoluniaSolarBurns, 1 do
			local damage = target.SoluniaSolarBurns[i].damage
			if dualBurn then
				damage = damage + SOLUNIA_R2_DUAL_BURN_AMP * ability.r_2_level * damage
			end
			totalDamage = totalDamage + damage
		end
		Filters:ApplyDotDamage(caster, ability, target, totalDamage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_COSMOS, RPC_ELEMENT_FIRE)
	elseif ability:GetAbilityName() == "solunia_lunar_alpha_spark" then
		local damage = target.SoluniaBurnLunar
		if dualBurn then
			damage = damage + SOLUNIA_ARCANA_R2_DUAL_BURN_PCT/100 * ability.r_2_level * damage
		end
		Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, -2, RPC_ELEMENT_FIRE, RPC_ELEMENT_ICE)
	elseif ability:GetAbilityName() == "solunia_solar_alpha_spark" then
		local damage = target.SoluniaBurnSolar
		if dualBurn then
			damage = damage + SOLUNIA_ARCANA_R2_DUAL_BURN_PCT/100 * ability.r_2_level * damage
		end
		Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, -2, RPC_ELEMENT_FIRE, RPC_ELEMENT_ICE)
	end
end

function supernova_burn_end(event)
	local target = event.target
	local ability = event.ability
	if ability:GetAbilityName() == "solunia_eclipse" then
		target.SoluniaBurnLunar = nil
	elseif ability:GetAbilityName() == "solunia_supernova" then
		target.SoluniaBurnSolar = nil
	elseif ability:GetAbilityName() == "solunia_lunar_alpha_spark" then
		target.SoluniaBurnLunar = nil
	elseif ability:GetAbilityName() == "solunia_solar_alpha_spark" then
		target.SoluniaBurnSolar = nil
	end
end

function Solunia_Apply_R2_Stack(event, target)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local damage = event.damage
	local element = event.element
	if caster:HasModifier("modifier_solunia_arcana2") then
		return
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_solunia_"..element.."_burn", {duration = 8})
	local thisBurn = {}
	thisBurn.damage = damage * SOLUNIA_R2_DMG_PER_DMG * ability.r_2_level
	thisBurn.createdAt = GameRules:GetGameTime()
	if element == "solar" then
		if not target.SoluniaSolarBurns then
			target.SoluniaSolarBurns = {}
		end
		table.insert(target.SoluniaSolarBurns, thisBurn)
	elseif element == "lunar" then
		if not target.SoluniaLunarBurns then
			target.SoluniaLunarBurns = {}
		end
		table.insert(target.SoluniaLunarBurns, thisBurn)
	end
	Solunia_Recalculate_R2_Stacks(event, target, element)
end

function Solunia_Recalculate_R2_Stacks(event, target, element)
	local newBurnsData = {}
	local stacks = 0
	if element == "solar" then
		for i = 1, #target.SoluniaSolarBurns, 1 do
			if GameRules:GetGameTime() - target.SoluniaSolarBurns[i].createdAt >= SOLUNIA_R2_DUR_BASE then
			else
				table.insert(newBurnsData, target.SoluniaSolarBurns[i])
				stacks = stacks + 1
			end
		end
		target.SoluniaSolarBurns = newBurnsData
		target:SetModifierStackCount("modifier_solunia_solar_burn", event.caster, stacks)
	elseif element == "lunar" then
		for i = 1, #target.SoluniaLunarBurns, 1 do
			if GameRules:GetGameTime() - target.SoluniaLunarBurns[i].createdAt >= SOLUNIA_R2_DUR_BASE then
			else
				table.insert(newBurnsData, target.SoluniaLunarBurns[i])
				stacks = stacks + 1
			end
		end
		target.SoluniaLunarBurns = newBurnsData
		target:SetModifierStackCount("modifier_solunia_lunar_burn", event.caster, stacks)
	end
end

function supernova_channel_fail(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_warp_flare_falling", {duration = 1})
	StopSoundEvent("Solunia.Supernova", caster)
	caster:RemoveModifierByName("modifier_solunia_ulti_above_ground")
end

function swap_sun_moon(currentType, caster)

	if currentType == "sun" then
		caster:RemoveModifierByName("modifier_selethas_sun_active")
		caster.sunMoon = "moon"
		if caster:HasModifier("modifier_solunia_arcana1") then
			swapAbility(caster, "solunia_arcana_solar_comet", "solunia_arcana_lunar_comet", 0)
			local eventTable = {}
			eventTable.caster = caster
			eventTable.ability = caster:FindAbilityByName("solunia_arcana_lunar_comet")
			eventTable.max_charges = eventTable.ability:GetLevelSpecialValueFor("max_charges", eventTable.ability:GetLevel())
			apply_arcana_comet_stacks(eventTable)
		else
			swapAbility(caster, "solunia_solar_glow", "solunia_lunar_glow", 0)
		end
		if caster:HasModifier("modifier_solunia_arcana3") then
			swapAbility(caster, "solunia_solar_vorpal_blades", "solunia_lunar_vorpal_blades", 1)
		else
			swapAbility(caster, "solunia_solarang", "solunia_lunarang", 1)
		end
		swapAbility(caster, "solunia_warp_flare", "solunia_lunar_warp_flare", 2)
		if caster:HasModifier("modifier_solunia_arcana2") then
			swapAbility(caster, "solunia_solar_alpha_spark", "solunia_lunar_alpha_spark", DOTA_R_SLOT)
			arcana2runes(caster, caster:FindAbilityByName("solunia_solar_alpha_spark"))
		else
			swapAbility(caster, "solunia_supernova", "solunia_eclipse", DOTA_R_SLOT)
		end

	elseif currentType == "moon" then
		caster.sunMoon = "sun"
		if caster:HasModifier("modifier_solunia_arcana1") then
			swapAbility(caster, "solunia_arcana_lunar_comet", "solunia_arcana_solar_comet", 0)
			local eventTable = {}
			eventTable.caster = caster
			eventTable.ability = caster:FindAbilityByName("solunia_arcana_solar_comet")
			eventTable.max_charges = eventTable.ability:GetLevelSpecialValueFor("max_charges", eventTable.ability:GetLevel())
			apply_arcana_comet_stacks(eventTable)
		else
			swapAbility(caster, "solunia_lunar_glow", "solunia_solar_glow", 0)
		end
		if caster:HasModifier("modifier_solunia_arcana3") then
			swapAbility(caster, "solunia_lunar_vorpal_blades", "solunia_solar_vorpal_blades", 1)
		else
			swapAbility(caster, "solunia_lunarang", "solunia_solarang", 1)
		end
		
		swapAbility(caster, "solunia_lunar_warp_flare", "solunia_warp_flare", 2)
		if caster:HasModifier("modifier_solunia_arcana2") then
			swapAbility(caster, "solunia_lunar_alpha_spark", "solunia_solar_alpha_spark", DOTA_R_SLOT)
			arcana2runes(caster, caster:FindAbilityByName("solunia_lunar_alpha_spark"))
		else
			swapAbility(caster, "solunia_eclipse", "solunia_supernova", DOTA_R_SLOT)
		end

		local wAbility = caster:FindAbilityByName("solunia_solarang")
		if caster:HasModifier("modifier_solunia_arcana3") then
			wAbility = caster:FindAbilityByName("solunia_solar_vorpal_blades")
		end
		wAbility:ApplyDataDrivenModifier(caster, caster, "modifier_selethas_sun_active", {})
	end

end

function arcana2runes(caster, ability)
	local a_d_level = caster:GetRuneValue("r", 1)
	if a_d_level > 0 then
		local healthStacks = RandomInt(SOLUNIA_ARCANA_R1_MIN/10 * a_d_level, SOLUNIA_ARCANA_R1_MAX/10 * a_d_level)
		local healAmount = healthStacks * 10
		Filters:ApplyHeal(caster, caster, healAmount, true)
		local duration = Filters:GetAdjustedBuffDuration(caster, 20, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_arcana_a_d_health_visible", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_arcana_a_d_health_invisible", {duration = duration})
		caster:SetModifierStackCount("modifier_solunia_arcana_a_d_health_invisible", caster, healthStacks)
	end
end

function swapAbility(caster, currentAbilityName, newAbilityName, abilityIndex)
	local ability = caster:FindAbilityByName(currentAbilityName)
	local newAbility = caster:FindAbilityByName(newAbilityName)
	if not newAbility then
		newAbility = caster:AddAbility(newAbilityName)
	end
	local level = ability:GetLevel()
	newAbility:SetLevel(level)
	ability:SetAbilityIndex(abilityIndex)
	caster:SwapAbilities(currentAbilityName, newAbilityName, false, true)
	newAbility:SetAbilityIndex(abilityIndex)
end

function supernova_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	target.solunia_c_c_pullVector = ((caster:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	if ability:GetAbilityName() == "solunia_supernova" then
		target.solunia_c_c_pullVector = target.solunia_c_c_pullVector *- 1
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.r_3_damage, DAMAGE_TYPE_MAGICAL, BASE_ITEM, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
	if not target.jumpLock then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_supernova_projectile_pull", {duration = 0.7})
	end
end

function supernova_c_c_pull(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	target:SetAbsOrigin(target:GetAbsOrigin() + target.solunia_c_c_pullVector * 5)
end

function protostar_lift_think(event)
	local target = event.target
	local modifier = target:FindModifierByName("modifier_soluna_protostar_lifting")
	if modifier then
		local glyphUnit = modifier:GetCaster()
		local glyph = modifier:GetAbility()
		glyph.liftVelocity = glyph.liftVelocity + 1
		target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, glyph.liftVelocity))
		if (target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)) > 220 then
			target:RemoveModifierByName("modifier_soluna_protostar_lifting")
			if target:HasModifier("modifier_solunia_arcana2") then
				local abilityName = "solunia_solar_alpha_spark"
				if target.sunMoon == "moon" then
					abilityName = "solunia_lunar_alpha_spark"
				end
				local ability = target:FindAbilityByName(abilityName)
				ability:EndCooldown()
				local newOrder =
				{
					UnitIndex = target:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
				Position = target:GetAbsOrigin()}

				ExecuteOrderFromTable(newOrder)
			else
				local abilityName = "solunia_supernova"
				if target.sunMoon == "moon" then
					abilityName = "solunia_eclipse"
				end
				local ability = target:FindAbilityByName(abilityName)
				ability:EndCooldown()
				local newOrder = {
					UnitIndex = target:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = ability:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

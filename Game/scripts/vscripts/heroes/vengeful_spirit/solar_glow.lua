require('/heroes/vengeful_spirit/solunia_constants')

function solar_glow_phase_start(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1, translate = "immortal"})
	EmitSoundOn("Selethas.Throw.VO", caster)
end

function solar_glow_start(event)
	local caster = event.caster
	local ability = event.ability

	local target = event.target_points[1]
	ability.targetPoint = target
	local baseFV = (target * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	ability.baseFV = baseFV
	local forwardVelocity = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin()) / 35 + 6
	local damage = event.damage
	local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "solunia")
	local projectiles = event.projectiles
	local stun_duration = event.stun_duration
	local q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "solunia")
	local q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "solunia")
	ability.q_2_level = q_2_level
	for i = 0, projectiles - 1, 1 do
		Timers:CreateTimer(i * 0.2, function()
			local randomOffset = RandomInt(-20, 20)
			local flareAngle = WallPhysics:rotateVector(baseFV, math.pi * randomOffset / 160)
			local flare = CreateUnitByName("selethas_boomerang", caster:GetAbsOrigin() + Vector(0, 0, 100), false, caster, nil, caster:GetTeamNumber())
			flare:SetOriginalModel("models/items/crystal_maiden/ward_staff/ward_staff_crystal.vmdl")
			flare:SetModel("models/items/crystal_maiden/ward_staff/ward_staff_crystal.vmdl")
			flare:SetRenderColor(255, 140, 0)
			flare:SetModelScale(0.1)
			flare.fv = flareAngle
			flare.stun_duration = stun_duration
			if caster:HasModifier("modifier_solunia_glyph_3_1") then
				flare.stun_duration = flare.stun_duration + 1
			end
			flare.liftVelocity = 40
			flare.q_2_level = q_2_level
			flare.q_3_level = q_3_level
			flare.forwardVelocity = forwardVelocity + RandomInt(-3, 3)
			flare.interval = 0
			flare.damage = damage
			flare.typeName = "sun"
			flare.origCaster = caster
			flare.origAbility = ability
			flare:AddAbility("solar_glow_projectile_ability"):SetLevel(1)
			local flareSubAbility = flare:FindAbilityByName("solar_glow_projectile_ability")
			flareSubAbility:ApplyDataDrivenModifier(flare, flare, "modifier_solar_projectile_motion", {})
			EmitSoundOn("Solunia.SolarGlowThrow", flare)
		end)
	end
	local pfx = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	EmitSoundOn("Solunia.NitroInitialCast", caster)
	Filters:CastSkillArguments(1, caster)
	glow_rune_q_1(caster, ability, baseFV, WallPhysics:GetDistance2d(target, caster:GetAbsOrigin()))
	if caster:HasModifier("modifier_solunia_glyph_6_1_ready") then
		caster:RemoveModifierByName("modifier_solunia_glyph_6_1_ready")
		ability:EndCooldown()
	end
end

function vectorToAngle(vector)
	return math.atan2(vector.y, vector.x) * 180 / math.pi
end

function flare_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if caster.typeName == "sun" then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.liftVelocity) + caster.fv * caster.forwardVelocity)
		caster.liftVelocity = caster.liftVelocity - 3
		caster:SetModelScale(math.min((0.5 + caster.interval / 5), 3.0))
		local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 30)
		caster:SetForwardVector(newFV)
		caster:SetAngles(caster.interval * 4, vectorToAngle(newFV), caster.interval * 4)
		caster.interval = caster.interval + 1
		local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
		if caster:GetAbsOrigin().z - groundHeight < 10 then
			flareParticle(caster:GetAbsOrigin(), caster.origCaster, "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf")
			EmitSoundOn("Solunia.SolarGlow.Impact", caster)
			caster:RemoveModifierByName("modifier_solar_projectile_motion")
			flareImpact(caster, ability)
			Timers:CreateTimer(0.1, function()
				UTIL_Remove(caster)
			end)
		end
	elseif caster.typeName == "moon" then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + caster.fv * caster.forwardVelocity + caster.perpFV * 8 * math.cos(caster.interval * math.pi / 10))
		caster.liftVelocity = caster.liftVelocity - 3
		caster:SetModelScale(math.min((0.5 + caster.interval / 5), 3.0))
		local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 30)
		caster:SetForwardVector(newFV)
		caster:SetAngles(caster.interval * 3, vectorToAngle(newFV), caster.interval * 3)
		caster.interval = caster.interval + 1
		local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
		if caster.interval > caster.forwardVelocity * 2 then
			flareParticle(caster:GetAbsOrigin(), caster.origCaster, "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf")
			EmitSoundOn("Solunia.SolarGlow.Impact", caster)
			caster:RemoveModifierByName("modifier_solar_projectile_motion")
			flareImpact(caster, ability)
			Timers:CreateTimer(0.1, function()
				UTIL_Remove(caster)
			end)
		end
	end
end

function flareImpact(caster, ability)
	local damageType = DAMAGE_TYPE_MAGICAL
	local element2 = RPC_ELEMENT_FIRE
	if caster.typeName == "moon" then
		damageType = DAMAGE_TYPE_PURE
		element2 = RPC_ELEMENT_ICE
	end
	local enemies = FindUnitsInRadius(caster.origCaster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local b_a_stack_gain = 0
	local damage = caster.damage
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_boomerang_magic_marker") then
				local stacks = enemy:GetModifierStackCount("modifier_boomerang_magic_marker", caster.origCaster)
				damage = damage + stacks * 0.2 * damage
			end
			if caster.q_3_level > 0 then
				if caster.typeName == "sun" then
					damage = damage + enemy:GetHealth() * 0.004 * caster.q_3_level
				else
					damage = damage + (enemy:GetMaxHealth() - enemy:GetHealth()) * 0.004 * caster.q_3_level
				end
			end
			Filters:TakeArgumentsAndApplyDamage(enemy, caster.origCaster, damage, damageType, BASE_ABILITY_Q, RPC_ELEMENT_COSMOS, element2)
			Filters:ApplyStun(caster.origCaster, caster.stun_duration, enemy)
			b_a_stack_gain = b_a_stack_gain + 1
		end
	end
	if caster.q_2_level > 0 then
		local solunia = caster.origCaster
		local buffDuration = Filters:GetAdjustedBuffDuration(solunia, 3, false)
		if caster.typeName == "moon" then
			caster.origAbility:ApplyDataDrivenModifier(solunia, solunia, "modifier_solunia_b_a_lunar_visible", {duration = buffDuration})
			local newStacks = math.min(solunia:GetModifierStackCount("modifier_solunia_b_a_lunar_visible", solunia) + b_a_stack_gain, 50)
			solunia:SetModifierStackCount("modifier_solunia_b_a_lunar_visible", solunia, newStacks)

			caster.origAbility:ApplyDataDrivenModifier(solunia, solunia, "modifier_solunia_b_a_lunar_invisible", {duration = buffDuration})
			solunia:SetModifierStackCount("modifier_solunia_b_a_lunar_invisible", solunia, newStacks * caster.q_2_level)

			caster.origAbility.q_2_stacks = newStacks
		elseif caster.typeName == "sun" then
			caster.origAbility:ApplyDataDrivenModifier(solunia, solunia, "modifier_solunia_b_a_solar_visible", {duration = buffDuration})
			local newStacks = math.min(solunia:GetModifierStackCount("modifier_solunia_b_a_solar_visible", solunia) + b_a_stack_gain, 50)
			solunia:SetModifierStackCount("modifier_solunia_b_a_solar_visible", solunia, newStacks)

			caster.origAbility:ApplyDataDrivenModifier(solunia, solunia, "modifier_solunia_b_a_solar_invisible", {duration = buffDuration})
			solunia:SetModifierStackCount("modifier_solunia_b_a_solar_invisible", solunia, newStacks * caster.q_2_level)

			caster.origAbility.q_2_stacks = newStacks
		end
	end
end

function b_a_buff_timeout(event)
	local caster = event.caster
	local ability = event.ability
	local buffDuration = Filters:GetAdjustedBuffDuration(caster, 3, false)
	if ability:GetAbilityName() == "solunia_lunar_glow" then
		local newStacks = ability.q_2_stacks - 1
		ability.q_2_stacks = newStacks
		if newStacks < 1 then
			caster:RemoveModifierByName("modifier_solunia_b_a_lunar_visible")
			caster:RemoveModifierByName("modifier_solunia_b_a_lunar_invisible")
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_b_a_lunar_visible", {duration = buffDuration})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_b_a_lunar_invisible", {duration = buffDuration})
			caster:SetModifierStackCount("modifier_solunia_b_a_lunar_visible", caster, newStacks)
			caster:SetModifierStackCount("modifier_solunia_b_a_lunar_invisible", caster, newStacks * ability.q_2_level)
		end
	elseif ability:GetAbilityName() == "solunia_solar_glow" then
		local newStacks = ability.q_2_stacks - 1
		ability.q_2_stacks = newStacks
		if newStacks < 1 then
			caster:RemoveModifierByName("modifier_solunia_b_a_solar_visible")
			caster:RemoveModifierByName("modifier_solunia_b_a_solar_invisible")
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_b_a_solar_visible", {duration = buffDuration})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_b_a_solar_invisible", {duration = buffDuration})
			caster:SetModifierStackCount("modifier_solunia_b_a_solar_visible", caster, newStacks)
			caster:SetModifierStackCount("modifier_solunia_b_a_solar_invisible", caster, newStacks * ability.q_2_level)
		end
	end
end

function flareParticle(position, caster, particleName)
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function lunar_glow_start(event)
	local caster = event.caster
	local ability = event.ability

	local target = event.target_points[1]
	ability.targetPoint = target
	local baseFV = (target * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	ability.baseFV = baseFV
	local forwardVelocity = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin()) / 100 + 11
	local damage = event.damage
	local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "solunia")
	local projectiles = event.projectiles
	local stun_duration = event.stun_duration
	local q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "solunia")
	local q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "solunia")
	ability.q_2_level = q_2_level
	for i = 0, projectiles - 1, 1 do
		Timers:CreateTimer(i * 0.2, function()
			local randomOffset = RandomInt(-10, 10)
			local flareAngle = WallPhysics:rotateVector(baseFV, math.pi * randomOffset / 180)
			local flare = CreateUnitByName("selethas_boomerang", caster:GetAbsOrigin() + Vector(0, 0, 100), false, caster, nil, caster:GetTeamNumber())
			flare:SetAbsOrigin(flare:GetAbsOrigin() + Vector(0, 0, 50))
			flare:SetOriginalModel("models/items/crystal_maiden/ward_staff/ward_staff_crystal.vmdl")
			flare:SetModel("models/items/crystal_maiden/ward_staff/ward_staff_crystal.vmdl")
			flare:SetRenderColor(0, 140, 255)
			flare:SetModelScale(0.1)
			flare.fv = flareAngle
			flare.q_2_level = q_2_level
			flare.q_3_level = q_3_level
			flare.stun_duration = stun_duration
			if caster:HasModifier("modifier_solunia_glyph_3_1") then
				flare.stun_duration = flare.stun_duration + 1
			end
			flare.liftVelocity = 40
			flare.forwardVelocity = forwardVelocity
			flare.interval = 0
			flare.typeName = "moon"
			flare.damage = damage
			flare.origCaster = caster
			flare.origAbility = ability
			flare.perpFV = WallPhysics:rotateVector(flareAngle, math.pi / 2)
			flare:AddAbility("solar_glow_projectile_ability"):SetLevel(1)
			local flareSubAbility = flare:FindAbilityByName("solar_glow_projectile_ability")
			flareSubAbility:ApplyDataDrivenModifier(flare, flare, "modifier_solar_projectile_motion", {})
			EmitSoundOn("Solunia.LunarGlowThrow", flare)
		end)
	end
	local pfx = ParticleManager:CreateParticle("particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	EmitSoundOn("Solunia.NitroInitialCast", caster)
	Filters:CastSkillArguments(1, caster)
	glow_rune_q_1(caster, ability, baseFV, WallPhysics:GetDistance2d(target, caster:GetAbsOrigin()))
	if caster:HasModifier("modifier_solunia_glyph_6_1_ready") then
		caster:RemoveModifierByName("modifier_solunia_glyph_6_1_ready")
		ability:EndCooldown()
	end
end

function glow_rune_q_1(caster, ability, fv, range)
	ability.rune_q_1_level = caster:GetRuneValue("q", 1)
	if ability.rune_q_1_level > 0 then
		ability.q_1_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * SOLUNIA_Q1_DMG_PER_ATT * ability.rune_q_1_level
		local speed = math.max(range / 2 + 200, 400)
		local casterOrigin = caster:GetAbsOrigin()
		local particleName = "particles/roshpit/solunia/a_a_wave_solar.vpcf"
		if ability:GetAbilityName() == "solunia_lunar_glow" then
			particleName = "particles/roshpit/solunia/a_a_wave_lunar.vpcf"
		end
		local info =
		{
			Ability = ability,
			EffectName = particleName,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 80),
			fDistance = range,
			fStartRadius = 220,
			fEndRadius = 220,
			Source = caster,
			StartPosition = "attach_attack2",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 6.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)

	end
end

function a_a_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target.jumpLock or target.pushLock then
		return false
	end
	local targetPoint = ability.targetPoint
	ability:ApplyDataDrivenModifier(caster, target, "modifier_solunia_a_a_root", {duration = 0.6})
	--print("TARGET HIT")
	local distanceToPoint = WallPhysics:GetDistance2d(targetPoint, target:GetAbsOrigin())
	local pushVector = (((targetPoint + ability.baseFV * 200) - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local divider = math.max(4000 - ability.rune_q_1_level * 10, 1500)
	target.solunia_a_a_push_vector = pushVector * (distanceToPoint / divider) * 100
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.q_1_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
end

function a_a_push_end(event)
	local target = event.target
	target.solunia_a_a_push_vector = false
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function a_a_root_think(event)
	local target = event.target
	local newPos = GetGroundPosition(target:GetAbsOrigin() + target.solunia_a_a_push_vector, target)
	target:SetAbsOrigin(newPos)
end

function begin_second_heartbeat(event)
	local caster = event.caster
	local ability = event.ability
	local location = caster:GetOrigin()
	local abilityLevel = ability:GetLevel()
	local forwardVector = caster:GetForwardVector()
	local fv = forwardVector
	local w_2_level = rune_w_2(caster)
	local rangeblast = w_2_level * 10
	if rangeblast > 1000 then
		rangeblast = 1000
	end
	fire_projectile(abilityLevel, caster, fv, location, event, rangeblast)
	ability.w_2_level = w_2_level
	ability.w_3_level = rune_w_3(caster)
	rune_w_4(caster, ability)
	caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "flamewaker")
	-- if caster:HasModifier("modifier_flamewaker_glyph_4_1") then
	-- caster:ReduceMana(ability:GetManaCost(ability:GetLevel())*2)
	-- end
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_1, rate = 2.0})
	Filters:CastSkillArguments(2, caster)
end

function create_gale(abilityLevel, caster, targetPoint, casterOrigin)
	fire_projectile(abilityLevel, caster, targetPoint, casterOrigin)
end

function second_heartbeat_damage(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	if caster:HasModifier("modifier_flamewaker_glyph_4_1") then
		damage = damage + ((caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) * 5 + OverflowProtectedGetAverageTrueAttackDamage(caster) * 0.2) * ability:GetLevel()
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flamewaker_glyph_4_1_effect", {duration = 3})
	end
	damage = damage * (1 + 0.2 * ability.w_2_level)
	if ability.w_3_level > 0 then
		local additional_armorLoss = math.ceil(1.0 * ability.w_3_level)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_searing_heat", {duration = 6})
		local current_stack = target:GetModifierStackCount("modifier_searing_heat", ability)
		local stacks = math.min(current_stack + additional_armorLoss, 10000)
		target:SetModifierStackCount("modifier_searing_heat", ability, stacks)
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function fire_projectile(abilityLevel, caster, fv, casterOrigin, event, rangeblast)

	local ability = event.ability
	local start_radius = event.start_radius
	local end_radius = event.end_radius + rangeblast / 2
	local range = event.range + rangeblast
	local speed = event.speed
	local damage = event.damage
	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
	if caster:HasModifier("modifier_flamewaker_glyph_4_1") then
		projectileParticle = "particles/units/heroes/hero_dragon_knight/blue_flame_breath.vpcf"
	end
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = casterOrigin,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
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

function fire_projectile_c_b(abilityLevel, caster, fv, casterOrigin, event, w_3_level)
	local rangeblast = 300 + w_3_level * 30
	local ability = event.ability
	local start_radius = event.start_radius
	local end_radius = event.end_radius + rangeblast / 2
	local range = rangeblast
	local speed = event.speed
	local damage = event.damage
	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_dragon_knight/breathe_charcoal.vpcf",
		vSpawnOrigin = casterOrigin,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
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

function rune_w_2(caster)
	local w_2_level = caster:GetRuneValue("w", 2)
	return w_2_level
end

function rune_w_3(caster)
	local w_3_level = caster:GetRuneValue("w", 3)
	return w_3_level
end

function rotateVector(vector, radians)
	XX = vector.x
	YY = vector.y

	Xprime = math.cos(radians) * XX - math.sin(radians) * YY
	Yprime = math.sin(radians) * XX + math.cos(radians) * YY

	vectorX = Vector(1, 0, 0) * Xprime
	vectorY = Vector(0, 1, 0) * Yprime
	rotatedVector = vectorX + vectorY
	return rotatedVector

end

function last_damaging_unit(event)
	local caster = event.caster
	if event.attacker then
		if caster:GetEntityIndex() == event.attacker:GetEntityIndex() then
		else
			caster.lastDamagingUnit = event.attacker
		end
	end
end

function rune_w_4(caster, ability)
	local w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "flamewaker")
	if w_4_level > 0 and not caster:HasModifier("modifier_flamewaker_rune_w_4_cooldown") and caster.lastDamagingUnit then
		if IsValidEntity(caster.lastDamagingUnit) then
			if caster.lastDamagingUnit:IsAlive() then
				if caster.lastDamagingUnit.dummy or caster.lastDamagingUnit:HasAbility("dummy_unit") then
				else
					local runeAbility = caster.runeUnit4:FindAbilityByName("flamewaker_rune_w_4")
					runeAbility.w_4_level = w_4_level
					runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_flamewaker_rune_w_4_cooldown", {duration = 0.5})
					local duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
					runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_flamewaker_rune_w_4", {duration = duration})
					caster:SetModifierStackCount("modifier_flamewaker_rune_w_4", runeAbility, w_4_level)
					begin_dragon_wrath(caster, ability, caster.lastDamagingUnit)
				end
			end
		end
	end
end

function c_d_jump(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_jumping"
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 5})
	local liftDuration = distance / propulsion / 2
	local endLocation = unit:GetAbsOrigin() + forwardVector * distance
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03 * i, function()
			local currentPosition = unit:GetAbsOrigin()

			local newPosition = currentPosition + forwardVector * propulsion + Vector(0, 0, liftForce - i * gravity)

			local obstruction = WallPhysics:FindNearestObstruction(newPosition * Vector(1, 1, 0))
			local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), unit)
			if not blockUnit then
				unit:SetOrigin(newPosition)
			else
				unit:SetOrigin(newPosition - forwardVector * propulsion)
			end

		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03 * liftDuration + 0.03, function()
		Timers:CreateTimer(0.03 * fallLoop, function()
			fallLoop = fallLoop + 1
			local currentPosition = unit:GetAbsOrigin()
			local newPosition = currentPosition + forwardVector * propulsion - Vector(0, 0, fallLoop * gravity * fallGravity)

			local obstruction = WallPhysics:FindNearestObstruction(newPosition * Vector(1, 1, 0))
			local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), unit)
			if unit:HasModifier("modifier_jumping") then
				if not blockUnit then
					unit:SetOrigin(newPosition)
				else
					unit:SetOrigin(newPosition - forwardVector * propulsion)
				end
			end
			if fallLoop > liftDuration then
				unit:RemoveModifierByName("modifier_jumping")
				FindClearSpaceForUnit(unit, newPosition, false)
				WallPhysics:UnitLand(unit)
			else
				if WallPhysics:GetDistance(newPosition, endLocation) < 220 then
					unit:RemoveModifierByName("modifier_jumping")
					FindClearSpaceForUnit(unit, newPosition, false)
					WallPhysics:UnitLand(unit)
				else
					return 0.03
				end
			end
		end)
	end)
end

function begin_dragon_wrath(caster, ability, target)
	abilityLevel = ability:GetLevel()
	caster.lastDamagingUnit = false
	--ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)

	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_VERSUS, rate = 1.0})
	EmitSoundOn("Flamewaker.DragonWrathVO", caster)
	caster.flamewaker_d_b_target = target
	ability:ApplyDataDrivenModifier(caster, caster, "modfier_dragon_wrath_jumping", {duration = 8})
	local targetPoint = target:GetAbsOrigin() + RandomVector(90)
	local distance = WallPhysics:GetDistance(targetPoint * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	if distance <= 1800 then
		local jumpFV = ((targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		--print(jumpFV)
		ability.jump_velocity = distance / 30 + 15
		local groundDifferential = GetGroundHeight(target:GetAbsOrigin(), target) - GetGroundHeight(caster:GetAbsOrigin(), caster)
		ability.jump_velocity = distance / 30 + 15 + groundDifferential / 30
		ability.jumpFV = jumpFV
		ability.distance = distance
		ability.targetPoint = targetPoint
		ability.lifting = true
		ability.target = target
		caster:SetForwardVector(jumpFV)
		Timers:CreateTimer(0.25, function()
			ability.lifting = false
		end)
	end
end

function dragon_wrath_jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	local forwardSpeed = (ability.distance / 60 + 15) * 2
	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.jumpFV * 35), caster)
	if blockUnit then
		forwardSpeed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, ability.jump_velocity) + ability.jumpFV * forwardSpeed)
	caster:SetForwardVector(((ability.target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized())
	ability.jump_velocity = ability.jump_velocity - 6.6
	--print(ability.jumpFV)
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 10 and not ability.lifting then
		caster:RemoveModifierByName("modfier_dragon_wrath_jumping")
	end
end

function drop_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	FindClearSpaceForUnit(caster, location, false)
	EndAnimation(caster)
	if IsValidEntity(caster.flamewaker_d_b_target) then
		if caster.flamewaker_d_b_target:IsAlive() then
			--print("blockMAIN")
			EmitSoundOn("Flamewaker.SpecialCrit", caster.flamewaker_d_b_target)
			local target = caster.flamewaker_d_b_target

			local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/flamewaker_crit.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 40))
			local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin() + Vector(0, 0, 10))
			Timers:CreateTimer(0.4, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:DestroyParticle(pfx2, false)
			end)

			Timers:CreateTimer(0.06, function()
				EmitSoundOn("Flamewaker.SpecialCrit", target)
				caster:PerformAttack(target, true, true, false, true, false, false, false)
				local damageApprox = math.ceil(OverflowProtectedGetAverageTrueAttackDamage(caster))
				PopupDamage(target, damageApprox)
				StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 2.4})
				Timers:CreateTimer(0.03, function()
					caster:RemoveModifierByName("modifier_flamewaker_rune_w_4")
				end)
			end)
		end
	end
end

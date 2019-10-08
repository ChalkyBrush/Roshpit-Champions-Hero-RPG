function arkimus_jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1]
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance / 20
	ability.jumpVelocity = Filters:GetAdjustedESpeed(caster, ability.jumpVelocity, false)
	ability.liftVelocity = 20
	ability.liftVelocity = Filters:GetAdjustedESpeed(caster, ability.liftVelocity, true)
	local heightDiff = caster:GetAbsOrigin().z - ability.targetPoint.z
	if heightDiff > 300 then
		heightDiff = 200
	elseif heightDiff < -300 then
		heightDiff = -200
	end
	ability.liftVelocity = ability.liftVelocity - heightDiff / 20
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	ability.interval = 0
	if not event.special then
		StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
		EmitSoundOn("Akrimus.Jump.VO", caster)
		Filters:CastSkillArguments(3, caster)
		if caster:HasModifier("modifier_machinal_jump_freecast") then
			ability:EndCooldown()
			local newStacks = caster:GetModifierStackCount("modifier_machinal_jump_freecast", caster) - 1
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_machinal_jump_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_machinal_jump_freecast")
			end
		end
		if caster:HasAbility("arkimus_energy_field") then
			local energyField = caster:FindAbilityByName("arkimus_energy_field")
			if energyField.rotationDelta then
				energyField.rotationDelta = math.max(14, energyField.rotationDelta - 4)
			end
		end
	end
	ability.e_1_level = caster:GetRuneValue("e", 1)
	ability.e_3_level = caster:GetRuneValue("e", 3)
end

function arkimus_jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV
	-- if distance < 60 then
	-- fv = Vector(0,0)
	-- end
	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
		--print(height)
		if not ability.rising then
			caster:RemoveModifierByName("modifier_machinal_jump")
		end
	end

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.jumpFV * 30), caster)
	if blockUnit then
		fv = Vector(0, 0)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + fv * ability.jumpVelocity + Vector(0, 0, ability.liftVelocity))
	local acceleration = 2
	Filters:GetAdjustedESpeed(caster, acceleration, false)
	ability.liftVelocity = ability.liftVelocity - acceleration
	if ability.liftVelocity <= 0 then
		ability.rising = false
	end
	ability.interval = ability.interval + 1
	if ability.interval % 3 == 0 then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/jump_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(0.4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function jump_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
	end)
	if ability.e_1_level > 0 then
		local searchRadius = 300 + ability.e_1_level * 2
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 0.3 * ability.e_1_level

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				CreateZonisBeam(caster:GetAbsOrigin(), enemy:GetAbsOrigin() + Vector(0, 0, 50))
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zonis_stun", {duration = 0.2})
				Filters:ApplyStun(caster, 0.2, enemy)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_ARCANE, RPC_ELEMENT_LIGHTNING)
			end
		else
			for i = 1, 3, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / 3)
				CreateZonisBeam(caster:GetAbsOrigin(), caster:GetAbsOrigin() + fv * 120 + Vector(0, 0, 60))
			end
		end
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.JumpLightning", caster)
	end
	if ability.e_3_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump_c_c_amp", {duration = duration})
		caster:SetModifierStackCount("modifier_machinal_jump_c_c_amp", caster, ability.e_3_level)
	end
end

function CreateZonisBeam(attachPointA, attachPointB)
	local particleName = "particles/roshpit/arkimus/zonis_lightning.vpcf"
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
	ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(lightningBolt, false)
		ParticleManager:ReleaseParticleIndex(lightningBolt)
	end)
end

function jump_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local stackCount = caster:GetModifierStackCount("modifier_machinal_jump_freecast", caster)
	local maxStacks = 2
	if caster:HasModifier("modifier_arkimus_glyph_4_1") then
		maxStacks = maxStacks + ARKIMUS_GLYPH_4_1_E_FREE_CAST
	end
	if stackCount < maxStacks then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump_freecast", {})
		local newStacks = math.min(stackCount + 1, maxStacks)
		caster:SetModifierStackCount("modifier_machinal_jump_freecast", caster, newStacks)
	end
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_machinal_jump_d_c_effect", {})
		caster:SetModifierStackCount("modifier_machinal_jump_d_c_effect", caster, e_4_level)
	else
		caster:RemoveModifierByName("modifier_machinal_jump_d_c_effect")
	end
end

function jump_passive_think_2(event)
	local caster = event.caster
	local ability = event.ability
	local e_2_level = caster:GetRuneValue("e", 2)
	if e_2_level > 0 then
		if not ability.lastMana then
			ability.lastMana = caster:GetMana()
		end
		local manaDifferential = caster:GetMana() - ability.lastMana
		if manaDifferential > 0 then

			local heal = manaDifferential * e_2_level
			--print("HEAL: "..heal)
			Filters:ApplyHeal(caster, caster, heal, true, false)
		end
		ability.lastMana = caster:GetMana()
	end
end

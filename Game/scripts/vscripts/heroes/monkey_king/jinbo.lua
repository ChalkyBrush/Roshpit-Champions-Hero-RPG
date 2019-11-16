function jinbo_phase(event)
	local caster = event.caster
	local ability = event.ability

	local stacks = caster:GetModifierStackCount("modifier_jinbo_stack", caster)
	if stacks < 2 and not caster:HasModifier("modifier_monkey_jump") then
		StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 1.6, translate = "attack_normal_range"})
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.JinBo.Swing", caster)
	else
		local colorVector = Vector(180, 180, 180)
		if caster:HasModifier("modifier_mark_of_the_fang") then
			colorVector = Vector(0, 255, 0)
		elseif caster:HasModifier("modifier_mark_of_the_claw") then
			colorVector = Vector(255, 0, 0)
		elseif caster:HasModifier("modifier_mark_of_the_talon") then
			colorVector = Vector(0, 0, 255)
		end
		--print(colorVector)
		local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/dreghor/jinbo_precast.vpcf", caster, 3)
		ParticleManager:SetParticleControl(pfx, 8, colorVector)
		StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_MK_STRIKE, rate = 1.4})
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.JinBo.HeavySwing", caster)
	end
end

function jinbo_start(event)
	local caster = event.caster
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jinbo_stack", {duration = 1})
	local newStacks = caster:GetModifierStackCount("modifier_jinbo_stack", caster) + 1
	caster:SetModifierStackCount("modifier_jinbo_stack", caster, newStacks)
	if newStacks < 3 and not caster:HasModifier("modifier_monkey_jump") then
		local position = caster:GetAbsOrigin()
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (event.damage_mult / 100)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() + caster:GetForwardVector() * 180, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOn("Draghor.JinboNormalImpact", enemies[1])
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

				local impactPoint = enemy:GetAbsOrigin()
				local pushVector = ((impactPoint - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				enemy.pushVector = pushVector

				enemy.pushVelocity = (3000 - WallPhysics:GetDistance2d(impactPoint, caster:GetAbsOrigin())) / 400
				enemy.pushVelocity = math.max(enemy.pushVelocity, 6)
				enemy.pushVelocity = math.min(enemy.pushVelocity, 8)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_heavy_boulder_pushback", {duration = 0.5})
			end
		end

	else
		caster:RemoveModifierByName("modifier_jinbo_stack")

		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() + caster:GetForwardVector() * 300, "Draghor.JinBo.HeavySwing.Impact", caster)
		local position = caster:GetAbsOrigin()
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 2 * (event.damage_mult / 100)
		if caster:HasModifier("modifier_monkey_jump") then
			local b_c_level = caster:GetRuneValue("e", 2)
			if b_c_level > 0 then
				damage = damage + damage * DJANGHOR_E2_JINBO_BOOST_IN_LEAP * b_c_level
			end
		end
		local endFV = caster:GetForwardVector()
		local range = 1200
		local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin() + endFV * range, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyStun(caster, event.stun_duration, enemy)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
			end
			if caster:HasModifier("modifier_djanghor_glyph_1_1") then
				caster:GetAbilityByIndex(DOTA_E_SLOT):EndCooldown()
			end
			local e_2_level = caster:GetRuneValue("e", 2)
			if e_2_level > 0 then
				local procs = Runes:Procs(e_2_level, 5, 1)
				if procs > 0 then
					caster:RemoveModifierByName("modifier_shapeshift_freecast")
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_freecast", {duration = 60})
					caster:SetModifierStackCount("modifier_shapeshift_freecast", caster, procs)
				end
			end
		end
		local colorVector = Vector(180, 180, 180)
		if caster:HasModifier("modifier_mark_of_the_fang") then
			colorVector = Vector(0, 255, 0)
		elseif caster:HasModifier("modifier_mark_of_the_claw") then
			colorVector = Vector(255, 0, 0)
		elseif caster:HasModifier("modifier_mark_of_the_talon") then
			colorVector = Vector(0, 0, 255)
		end
		local particleName = "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf"
		local pfx = ParticleManager:CreateParticle("particles/roshpit/dreghor/jinbo_heavy.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(0, pfx, caster:GetAbsOrigin())
		-- ParticleManager:SetParticleControl(1, pfx, caster:GetAbsOrigin()+endFV*range)
		ParticleManager:SetParticleControl(2, pfx, Vector(range, 0, 0))
		ParticleManager:SetParticleControl(4, pfx, colorVector)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

	end
	Filters:CastSkillArguments(2, caster)
end

function heavy_boulder_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin() + target.pushVector * target.pushVelocity, target)
	local fv = target.pushVector
	if blockUnit then
		fv = 0
	end
	local newPos = GetGroundPosition(target:GetAbsOrigin() + fv * target.pushVelocity, target)
	target:SetAbsOrigin(newPos)
	target.pushVelocity = math.max(target.pushVelocity - 0.6, 0)
end

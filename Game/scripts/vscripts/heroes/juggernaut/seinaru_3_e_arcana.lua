require('heroes/juggernaut/seinaru_4_r')
require('heroes/juggernaut/seinaru_1_q_arcana')
require('heroes/juggernaut/seinaru_constants')

function sunstrider_start(event)
	local caster = event.caster
	local target = WallPhysics:WallSearch(caster:GetAbsOrigin(), event.target_points[1], caster)
	local ability = event.ability
	local targets_count = event.targets_count
	local att_to_dmg = event.att_to_dmg
	caster:AddNoDraw()
	local travelTime = 0.5

	local a_c_level = caster:GetRuneValue("e", 1)
	ability.e_3_level = caster:GetRuneValue("e", 3)
	ability.r_1_level = caster:GetRuneValue("r", 1)

	if ability.e_3_level > 0 then
		local c_c_duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sunstrider_sunwarrior_vengeance_post_mit", {duration = c_c_duration})
		caster:SetModifierStackCount("modifier_sunstrider_sunwarrior_vengeance_post_mit", caster, ability.e_3_level)
	end

	local maxTargets = targets_count + math.ceil(SEINARU_ARCANA_E1_TARGETS * a_c_level)
	local targetsCounter = 0
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, 440, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			if targetsCounter < maxTargets then
				targetsCounter = targetsCounter + 1
				Timers:CreateTimer(i * 0.06, function()
					local enemy = enemies[i]
					CustomAbilities:QuickAttachParticle("particles/roshpit/seinaru/sunblade.vpcf", enemy, 0.6)
					local eventTable = {
						caster = caster,
						target = enemy,
						ability = ability,
						att_to_dmg = att_to_dmg
					}
					vengeance_hit(eventTable)
					Timers:CreateTimer(0.2, function()
						CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", enemy, 0.5)
						Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
						if caster:HasAbility("seinaru_blade_dash") then
							local eventTable = {}
							eventTable.caster = caster
							eventTable.target = enemy
							eventTable.ability = caster:FindAbilityByName("seinaru_blade_dash")
							arcana_attack_start(eventTable)
						end
					end)

					if caster:HasAbility("gorudo") then
						Seinaru_Apply_E4(caster, enemy, caster:FindAbilityByName("gorudo"))
					end
				end)
			end
		end
		local travelDurationIncrease = (#enemies - 8) * 0.06
		if travelDurationIncrease > 0 then
			travelTime = travelTime + travelDurationIncrease
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sunstrider_a_c_damage_bonus", {duration = travelTime})
		caster:SetModifierStackCount("modifier_sunstrider_a_c_damage_bonus", caster, a_c_level)
	end

	sunstrider_projectile(caster, ability, target, travelTime)
	EmitSoundOn("Seinaru.Sunstrider.Yell", caster)
	EmitSoundOnLocationWithCaster(target, "Seinaru.Sunstrider.Cast", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seinaru.Sunstrider.Launch", caster)
	ability.point = target
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sunstrider_in_air", {duration = travelTime})
	Filters:CastSkillArguments(3, caster)
	if caster:HasModifier("modifier_sunstrider_freecast") then
		ability:EndCooldown()
		local newStacks = caster:GetModifierStackCount("modifier_sunstrider_freecast", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_sunstrider_freecast", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_sunstrider_freecast")
		end
	end

end

function sunstrider_projectile(caster, ability, point, travelTime)
	local start_radius = 0
	local end_radius = 0
	local range = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), point) * 0.95
	local speed = range / travelTime
	local casterOrigin = caster:GetAbsOrigin()
	local fv = ((point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local info =
	{
		Ability = ability,
		EffectName = "particles/roshpit/seinaru/sunstrider_movement.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
		iVisionTeamNumber = caster:GetTeamNumber()

	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function sunstrider_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.point
	ProjectileManager:ProjectileDodge(caster)

	Timers:CreateTimer(0.06, function()
		caster:RemoveNoDraw()
		local e_1_level = caster:GetRuneValue("e", 1)
		if e_1_level > 0 then
			caster:RemoveModifierByName("modifier_sunstrider_a_c_damage_bonus")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_sunstrider_a_c_damage_bonus", {duration = 3})
			caster:SetModifierStackCount("modifier_sunstrider_a_c_damage_bonus", caster, e_1_level)
		end
		local b_c_level = caster:GetRuneValue("e", 2)
		if b_c_level > 0 then
			local b_c_duration = Filters:GetAdjustedBuffDuration(caster, SEINARU_ARCANA_E2_DUR * b_c_level, false)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_sunstrider_lightsworn", {duration = b_c_duration})
		end
		Timers:CreateTimer(0.24, function()
			caster:RemoveModifierByName("modifier_sunstrider_sunwarrior_vengeance_post_mit")
		end)

	end)
	if ability:GetCooldownTimeRemaining() > 0 then
		local d_c_level = caster:GetRuneValue("e", 4)
		local procs = Runes:Procs(d_c_level, 10, 1)
		if procs > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_sunstrider_freecast", {})
			caster:SetModifierStackCount("modifier_sunstrider_freecast", caster, procs)
		end
	end
	FindClearSpaceForUnit(caster, target, false)
end

function vengeance_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local att_to_dmg = event.att_to_dmg

	local particleName = "particles/roshpit/seinaru/sunwarrior_vengeance_cowlofice.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	local origin = target:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(particle1, 1, Vector(480, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(480, 480, 480))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	local damage = att_to_dmg * OverflowProtectedGetAverageTrueAttackDamage(caster)
	EmitSoundOn("Seinaru.Sunstrider.Vengeance", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			local enemy = enemies[i]
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		end
	end
end

function passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local runesCount = caster:GetRuneValue("e", 4)
	if not runesCount then
		return
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sunstrider_holy_amplify", {})
	caster:SetModifierStackCount("modifier_sunstrider_holy_amplify", caster, runesCount)
end

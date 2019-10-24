require('heroes/leshrac/bahamut_arcana_ult')
require("heroes/leshrac/bahamut_constants")

function begin_lightning_dash(event)
	local caster = event.caster
	local ability = event.ability
	caster:AddNoDraw()

	if ability.lockPoint then
	else
		ability.point = event.target_points[1]
	end
	ability.moveDirection = (ability.point - caster:GetAbsOrigin()):Normalized()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_sphere_of_divinity", {duration = 7})
	StartSoundEvent("Bahamut.ArcanaOrb.LP", caster)
	EmitSoundOn("Bahamut.ArcanaOrb.Start", caster)
	caster:RemoveModifierByName("modifier_leshrac_wall_self_aura")

	local arcanaUlti = caster:FindAbilityByName("bahamut_arcana_ulti")
	if arcanaUlti then
		arcanaUlti.r_1_level = caster:GetRuneValue("r", 1)
	end

	ability.pfx = pfx
	if caster:GetUnitName() == "npc_dota_hero_leshrac" then
		ability.w_2_level = caster:GetRuneValue("w", 2)
		ability.w_3_level = caster:GetRuneValue("w", 3)
	elseif caster:GetUnitName() == "seafortress_shadow_of_bahamut" then
		ability.w_2_level = 0
		ability.w_3_level = 0
	end
	ability.interval = 0
	if not ability.particles then
		ability.particles = 0
	end
	local range = WallPhysics:GetDistance2d(ability.point, caster:GetAbsOrigin())

	local particle = "particles/units/heroes/hero_chen/chen_teleport_flash.vpcf"
	local pfx2 = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	Filters:CastSkillArguments(2, caster)

end

function dash_think(event)
	local caster = event.caster
	local ability = event.ability
	local w_4_level = 0
	if caster:IsHero() then w_4_level = caster:GetRuneValue("w", 4) end

	ability.moveDirection = (ability.point - caster:GetAbsOrigin()):Normalized()

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.moveDirection * 35), caster)
	local distance_for_slowing = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	local forwardSpeed = ability:GetSpecialValueFor("speed") / 33
	if caster:HasModifier("modifier_channel_start") then
		forwardSpeed = 0
	else
		if caster:HasModifier("modifier_light_charging") then
			forwardSpeed = forwardSpeed * BAHAMUT_ARCANA_W_W4_R_SPEED_MULT
		else
			if distance_for_slowing < 200 then
				forwardSpeed = 24
			elseif distance_for_slowing < 400 then
				forwardSpeed = 28
			elseif distance_for_slowing < 600 then
				forwardSpeed = 32
			end
		end
	end
	forwardSpeed = Filters:GetAdjustedESpeed(caster, forwardSpeed, false)
	if w_4_level > 0 then
		local stacks = forwardSpeed * 33 * BAHAMUT_ARCANA_W_W4_AMP_BASE_PCT * w_4_level * ability:GetLevel()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_arcana_w4_amp", {})
		caster:FindModifierByName("modifier_bahamut_arcana_w4_amp"):SetStackCount(stacks)
	else
		caster:RemoveModifierByName("modifier_bahamut_arcana_w4_amp")
		caster:RemoveModifierByName("modifier_bahamut_arcana_w4_amp_linger")
	end
	if blockUnit then
		forwardSpeed = 0
		caster:RemoveModifierByName("modifier_bahamut_sphere_of_divinity")
	end
	local newPosition = caster:GetAbsOrigin() + ability.moveDirection * forwardSpeed
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 200) + Vector(0, 0, GetGroundHeight(newPosition, caster)))
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < forwardSpeed * 1.5 then
		caster:RemoveModifierByName("modifier_bahamut_sphere_of_divinity")
	end
	if ability.w_2_level > 0 then
		if ability.interval % 3 == 0 then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #allies > 0 then
				for _, ally in pairs(allies) do
					if not ally:HasModifier("modifier_bahamut_arcana_post_mit") then
						ability:ApplyDataDrivenModifier(caster, ally, "modifier_bahamut_arcana_post_mit", {duration = BAHAMUT_ARCANA_W_W2_DURATION})
						ally:SetModifierStackCount("modifier_bahamut_arcana_post_mit", caster, ability.w_2_level)
						CustomAbilities:QuickAttachParticle("particles/roshpit/bahamut/bahamut_arcana_postmit_heal_core.vpcf", ally, 1)
					else
						if ally:GetEntityIndex() == caster:GetEntityIndex() then
						else
							CustomAbilities:QuickAttachParticle("particles/roshpit/bahamut/bahamut_arcana_postmit_heal_core.vpcf", ally, 1)
						end
					end
				end
			end
		end
	end
	if ability.w_3_level > 0 then
		bUltNuke = false
		if caster:HasModifier("modifier_leshrac_arcana_effect") then
			local arcanaAbility = caster:FindAbilityByName("bahamut_arcana_ulti")
			bUltNuke = true
		end
		if ability.interval % 3 == 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if not enemy:HasModifier("modifier_arcana2_purity_freeze") then
						local freezeDuration = ability.w_3_level * BAHAMUT_ARCANA_W_W3_PARALYSIS
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_arcana2_purity_freeze", {duration = freezeDuration})
						if bUltNuke then
							local arcanaAbility = caster:FindAbilityByName("bahamut_arcana_ulti")
							local arcanaDamage = arcanaAbility:GetSpecialValueFor("damage")
							leshrac_ult_go(arcanaAbility, caster, arcanaDamage, true, enemy)
						end
					end
				end
			end
		end
	end
	ability.interval = ability.interval + 1
	if caster:GetUnitName() == "npc_dota_hero_leshrac" then
		if ability.interval % 3 == 0 then
			local tickManaDrain = caster:GetMaxMana() * event.mana_drain_per_second * 0.09 / 100

			if caster:GetMana() > tickManaDrain then
				caster:ReduceMana(tickManaDrain)
			else
				caster:RemoveModifierByName("modifier_bahamut_sphere_of_divinity")
			end
		end
	end
end

function dash_end(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_bahamut_arcana_w4_amp") and caster:HasModifier("modifier_light_charging") then
		local stacks = caster:GetModifierStackCount("modifier_bahamut_arcana_w4_amp", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_arcana_w4_amp_linger", {duration = BAHAMUT_ARCANA_W_W4_AMP_LINGER_DURATION})
		caster:SetModifierStackCount("modifier_bahamut_arcana_w4_amp_linger", ability, stacks)
	end
	caster:RemoveModifierByName("modifier_bahamut_arcana_w4_amp")
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_4, rate = 2.4})
		WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		StopSoundEvent("Bahamut.ArcanaOrb.LP", caster)

		local particle = "particles/units/heroes/hero_chen/chen_teleport_flash.vpcf"
		local pfx2 = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)
	end)
	EmitSoundOn("Bahamut.ArcanaOrb.End", caster)
	if not caster:HasModifier("modifier_sorceress_blink_datadriven") then
		caster:RemoveNoDraw()
	end
	-- ParticleManager:DestroyParticle(ability.pfx, false)
	-- ability.pfx = false

end

function arcana_take_damage(event)

end

function regen_think(event)

end

function regen_end(event)

end
--33888750

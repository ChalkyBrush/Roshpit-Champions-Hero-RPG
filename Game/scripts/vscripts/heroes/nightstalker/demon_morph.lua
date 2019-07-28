--Demon Awakening
LinkLuaModifier("modifier_chernobog_demonform_lua", "modifiers/chernobog_1_e/modifier_chernobog_demonform_lua", LUA_MODIFIER_MOTION_NONE)

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Chernobog.NightsProcessionChannelStart", caster)

end

function channel_fail(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_channel_animation")
	if ability.channelPFX then
		ParticleManager:DestroyParticle(ability.channelPFX, false)
	end
	ability.channelPFX = false
end

function begin_demon_morph(event)
	local caster = event.caster
	local ability = event.ability
	ability.r_1_level = caster:GetRuneValue("r", 1)
	ability.r_2_level = caster:GetRuneValue("r", 2)
	ability.r_3_level = caster:GetRuneValue("r", 3)
	ability.r_4_level = caster:GetRuneValue("r", 4)
	local particleName = "particles/roshpit/chernobog/demon_form_transition.vpcf"
	if caster:HasModifier("modifier_demon_hunter") then
		particleName = "particles/units/heroes/hero_shadow_demon/shadow_demon_disruption.vpcf"
	end
	EmitSoundOn("Chernobog.DemonForm.Transition", caster)
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 50))
	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	caster:AddNoDraw()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_transitioning", {duration = 2.0})
	local duration = event.duration + ability.r_4_level * CHERNOBOG_ARCANA_R4_DURATION_INC
	local morphDuration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	Timers:CreateTimer(2.0, function()
		caster:RemoveNoDraw()
		caster:RemoveModifierByName("modifier_chernobog_transitioning")
		if caster:HasModifier("modifier_chernobog_demon_form") then
			StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.3})
			caster:AddNewModifier(caster, ability, "modifier_chernobog_demonform_lua", {})
			CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demonform_start_start_ti7_lvl2.vpcf", caster, 3)
			EmitSoundOn("Chernobog.DemonForm.Anger", caster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Chernobog.DemonForm.Start", caster)
		end

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_demon_form", {duration = morphDuration})
		if ability.r_2_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_demon_form_aura", {duration = morphDuration})
		end
		if caster:HasModifier("modifier_chernobog_arcana2") then
			if caster:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_flight" then
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_flight", "chernobog_demon_walk", 2)
			end
		end
		Filters:CastSkillArguments(4, caster)
	end)
end

function demon_form_start(event)
	local caster = event.caster
	local ability = event.ability
	local modelName = "models/heroes/terrorblade/demon.vmdl"
	caster:SetModel("models/heroes/terrorblade/demon.vmdl")
	caster:SetOriginalModel("models/heroes/terrorblade/demon.vmdl")
	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.3})
	caster:AddNewModifier(caster, ability, "modifier_chernobog_demonform_lua", {})
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demonform_start_start_ti7_lvl2.vpcf", caster, 3)
	EmitSoundOn("Chernobog.DemonForm.Anger", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Chernobog.DemonForm.Start", caster)
	-- Timers:CreateTimer(0.55, function()
	-- StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.3})
	-- end)
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	if caster:HasModifier("modifier_demon_hunter") then
		caster:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
	else
		caster:SetRangedProjectileName("particles/roshpit/chernobog/demon_form_attack.vpcf")
	end
end

function demon_form_end(event)
	local caster = event.caster
	caster:RemoveModifierByName("modifier_chernobog_demon_form_aura")
	caster:RemoveModifierByName("modifier_chernobog_demonform_lua")
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demonform_start_start_ti7_lvl2.vpcf", caster, 3)
	if caster:HasModifier("modifier_movespeed_cap_shadow_walk_1") or caster:HasModifier("modifier_movespeed_cap_shadow_walk_2") or caster:HasModifier("modifier_movespeed_cap_shadow_walk_3") or caster:HasModifier("modifier_movespeed_cap_shadow_walk_4") or caster:HasModifier("modifier_movespeed_cap_shadow_walk_5") or caster:HasModifier("modifier_movespeed_cap_shadow_walk_6") or caster:HasModifier("modifier_movespeed_cap_shadow_walk_7") then
		caster:SetModel("models/heroes/nightstalker/nightstalker.vmdl")
		caster:SetOriginalModel("models/heroes/nightstalker/nightstalker.vmdl")
		caster:SetModel("models/heroes/nightstalker/nightstalker_night.vmdl")
		caster:SetOriginalModel("models/heroes/nightstalker/nightstalker_night.vmdl")
	else
		caster:SetModel("models/heroes/nightstalker/nightstalker_night.vmdl")
		caster:SetOriginalModel("models/heroes/nightstalker/nightstalker_night.vmdl")
		caster:SetModel("models/heroes/nightstalker/nightstalker.vmdl")
		caster:SetOriginalModel("models/heroes/nightstalker/nightstalker.vmdl")
	end
	if caster:HasModifier("modifier_chernobog_arcana2") then
		if caster:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_walk" then
			CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_walk", "chernobog_demon_flight", 2)
		end
	end
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end

function demon_form_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.attack_damage
	local splashDamage = damage * CHERNOBOG_ARCANA_R1_DAMAGE_PCT/100 * ability.r_1_level
	if ability.r_1_level > 0 then
		-- if target:IsAlive() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, splashDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
			end
		end
		if caster:HasModifier("modifier_demon_hunter") then
			CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_form_splash_red.vpcf", target, 0.5)
		else
			CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_form_splash.vpcf", target, 0.5)
		end
		-- end
	end
end

function demon_form_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not caster:HasModifier("modifier_demon_form_dont_split") then
		if ability.r_3_level > 0 then
			local procs = Runes:Procs(ability.r_3_level, CHERNOBOG_ARCANA_R3_SPLIT_PCT, 1)
			local splitCount = 0
			--print(procs)
			if procs > 0 then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						if enemy:GetEntityIndex() == target:GetEntityIndex() then
						else
							if splitCount < procs then
								Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
								splitCount = splitCount + 1
							end
						end
					end
				end
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_form_dont_split", {duration = 0.15})
			end
		end
	end
end

function demon_aura_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.r_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_chernobog_demon_form_aura_stacks", {})
		target:SetModifierStackCount("modifier_chernobog_demon_form_aura_stacks", caster, ability.r_2_level)
	end
end

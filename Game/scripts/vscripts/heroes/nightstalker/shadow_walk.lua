LinkLuaModifier("modifier_movespeed_cap_shadow_walk_1", "modifiers/chernobog_shadow_walk/modifier_movespeed_cap_shadow_walk_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_shadow_walk_2", "modifiers/chernobog_shadow_walk/modifier_movespeed_cap_shadow_walk_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_shadow_walk_3", "modifiers/chernobog_shadow_walk/modifier_movespeed_cap_shadow_walk_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_shadow_walk_4", "modifiers/chernobog_shadow_walk/modifier_movespeed_cap_shadow_walk_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_shadow_walk_5", "modifiers/chernobog_shadow_walk/modifier_movespeed_cap_shadow_walk_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_shadow_walk_6", "modifiers/chernobog_shadow_walk/modifier_movespeed_cap_shadow_walk_6", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_cap_shadow_walk_7", "modifiers/chernobog_shadow_walk/modifier_movespeed_cap_shadow_walk_7", LUA_MODIFIER_MOTION_NONE)

function shadow_walk_start(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_chernobog_demon_form") then
		caster:SetModel("models/heroes/nightstalker/nightstalker_night.vmdl")
		caster:SetOriginalModel("models/heroes/nightstalker/nightstalker_night.vmdl")
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_NIGHTSTALKER_TRANSITION, rate = 1})
	else
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_ATTACK, rate = 2})
	end
	EmitSoundOn("Chernobog.ShadowWalkStart", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", caster, 4)

	local abilityLevel = ability:GetLevel()
	caster:AddNewModifier(caster, nil, 'modifier_movespeed_cap_shadow_walk_'..abilityLevel, {})


	local rune_e_1_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "chernobog")
	ability.e_2_level = Runes:GetTotalRuneLevel(caster, 2, "e_2", "chernobog")
	ability.e_3_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "chernobog")
	if rune_e_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_e_1", {})
		caster:SetModifierStackCount("modifier_chernobog_rune_e_1", caster, rune_e_1_level)
	end
	if ability.e_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_e_2", {})
		caster:SetModifierStackCount("modifier_chernobog_rune_e_2", caster, ability.e_2_level)
	end
	if caster:HasModifier("modifier_chernobog_glyph_2_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_night_vision", {})
	end
	local rune_e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "chernobog")
	if rune_e_4_level > 0 then
		caster:RemoveModifierByName("modifier_chernobog_rune_e_4")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_e_4", {})
	end
	Filters:CastSkillArguments(3, caster)
end

function shadow_walk_end(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_chernobog_demon_form") then
		caster:SetModel("models/heroes/nightstalker/nightstalker.vmdl")
		caster:SetOriginalModel("models/heroes/nightstalker/nightstalker.vmdl")
	end
	StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_SPAWN, rate = 1.5})
	EmitSoundOn("Chernobog.Untoggle", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", caster, 4)
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_1")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_2")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_3")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_4")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_5")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_6")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_7")
	caster:RemoveModifierByName("modifier_chernobog_rune_e_1")
	caster:RemoveModifierByName("modifier_chernobog_rune_e_2")
	caster:RemoveModifierByName("modifier_chernobog_night_vision")
	local rune_e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "chernobog")
	if rune_e_4_level > 0 then
		local d_c_duration = CHERNOBOG_E4_EVASION_LINGER_BASE + CHERNOBOG_E4_EVASION_LINGER * rune_e_4_level
		d_c_duration = Filters:GetAdjustedBuffDuration(caster, d_c_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_e_4", {duration = d_c_duration})
	end
	Filters:ReduceECooldown(caster, ability, 5, true)

end

function shadow_walk_think(event)
	local caster = event.caster
	local target = event.target
	if not caster:HasModifier("modifier_disable_player") and not caster:HasModifier("modifier_nights_procession_caster_lifting") and not caster:HasModifier("modifier_command_restric_player") then
		if caster:IsAlive() then
			local drain_per_second = event.drain_per_second
			drain_per_second = drain_per_second / 100
			if not caster:HasModifier("modifier_chernobog_glyph_5_1") or caster:GetHealth() / caster:GetMaxHealth() > CHERNOBOG_GLYPH51_DRAIN_HP_CAP_PCT then
				local healthDrain = caster:GetMaxHealth() * drain_per_second
				local newHealth = math.max(caster:GetHealth() - healthDrain, 1)
				caster:SetHealth(newHealth)
			end
			local manaDrain = caster:GetMaxMana() * drain_per_second
			caster:ReduceMana(manaDrain)
		end
	end
end

function rune_e_2_illusion(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ability.e_2_level * CHERNOBOG_E2_ILLUSION_DAMAGE_PCT/100
	if not ability.e2_strike_current then
		ability.e2_strike_current = -1
		ability.e2_base_strikes = -1;
	end
	ability.e2_base_strikes = ability.e2_base_strikes + 1
	local intervalsForAtt = CHERNOBOG_SHADOWS_INTERVALS_FOR_ATT
	local particle_animation_rate = 1
	local damage_delay = 0.5
	if caster:HasModifier('modifier_chernobog_glyph_1_1') then
		intervalsForAtt = CHERNOBOG_GLYPH11_SHADOWS_INTERVALS_FOR_ATT
		particle_animation_rate = 1.7
		damage_delay = 0.3
	end
	local strike_current = math.floor(ability.e2_base_strikes / intervalsForAtt)
	if strike_current > ability.e2_strike_current then
		local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", target, CHERNOBOG_SHADOWS_ATT_INTERVAL_BASE * intervalsForAtt)
		ParticleManager:SetParticleControl(pfx, 1, Vector(particle_animation_rate, 0, 0))
		Timers:CreateTimer(damage_delay, function()
			EmitSoundOn("Chernobog.BC.Hit", target)
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
		end)
		ability.e2_strike_current = strike_current
	end
end

function nightvision(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 300, 2.4, false)
end

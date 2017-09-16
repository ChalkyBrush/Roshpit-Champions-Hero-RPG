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
		StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_NIGHTSTALKER_TRANSITION, rate=1})
	else
		StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_ATTACK, rate=2})
	end
	EmitSoundOn("Chernobog.ShadowWalkStart", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", caster, 4)
	
	local abilityLevel = ability:GetLevel()
	caster:AddNewModifier( caster, nil, 'modifier_movespeed_cap_shadow_walk_'..abilityLevel, {} )
	

	local rune_a_c_level = Runes:GetTotalRuneLevel(caster, 1, "a_c", "chernobog")
	ability.b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "chernobog")
	ability.c_c_level = Runes:GetTotalRuneLevel(caster, 3, "c_c", "chernobog")
	if rune_a_c_level > 0 then
		local a_c_duration = 3.5
		if caster:HasModifier("modifier_chernobog_glyph_1_1") then
			a_c_duration = a_c_duration + 1
		end
		a_c_duration = Filters:GetAdjustedBuffDuration(caster, a_c_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_a_c", {duration = a_c_duration})
		caster:SetModifierStackCount("modifier_chernobog_rune_a_c", caster, rune_a_c_level)
	end
    if ability.b_c_level > 0 then
    	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_b_c", {})
    	caster:SetModifierStackCount("modifier_chernobog_rune_b_c", caster, ability.b_c_level)
    end
    if caster:HasModifier("modifier_chernobog_glyph_2_1") then
    	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_night_vision", {})
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
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SPAWN, rate=1.5})
	EmitSoundOn("Chernobog.Untoggle", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", caster, 4)
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_1")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_2")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_3")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_4")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_5")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_6")
	caster:RemoveModifierByName("modifier_movespeed_cap_shadow_walk_7")
	caster:RemoveModifierByName("modifier_chernobog_rune_a_c")
	caster:RemoveModifierByName("modifier_chernobog_rune_b_c")
	caster:RemoveModifierByName("modifier_chernobog_night_vision")
	local rune_d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "chernobog")
	if rune_d_c_level > 0 then
		local d_c_duration = 0.7 + 0.2*rune_d_c_level
		d_c_duration = Filters:GetAdjustedBuffDuration(caster, d_c_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_d_c", {duration = d_c_duration})
	end
	Filters:ReduceECooldown(caster, ability, 5, true)

end

function shadow_walk_think(event)
	local caster = event.caster
	local target = event.target
	if not caster:HasModifier("modifier_disable_player") and not caster:HasModifier("modifier_nights_procession_caster_lifting") and not caster:HasModifier("modifier_command_restric_player") then
		local drain_per_second = event.drain_per_second
		if caster:HasModifier("modifier_chernobog_glyph_5_1") then
			drain_per_second = drain_per_second - 2
		end
		drain_per_second = drain_per_second/100
		local healthDrain = caster:GetMaxHealth()*drain_per_second
		local newHealth = math.max(caster:GetHealth()-healthDrain, 1)
		caster:SetHealth(newHealth)
		local manaDrain = caster:GetMaxMana()*drain_per_second
		caster:ReduceMana(manaDrain)
	end
end

function rune_b_c_illusion(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	print(b_c_illusion)
	local damage = caster:GetAverageTrueAttackDamage(caster)*ability.b_c_level*0.5
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", target, 1.4)
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Chernobog.BC.Hit", target)
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
	end)
end

function nightvision(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 300, 2.4, false)
end
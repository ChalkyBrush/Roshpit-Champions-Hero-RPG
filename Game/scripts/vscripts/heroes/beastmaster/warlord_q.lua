function warlord_stone_form(event)
	local caster = event.caster
	local ability = event.ability
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	Filters:CastSkillArguments(1, caster)
	local luck = RandomInt(3, 5)
	EmitSoundOn("beastmaster_beas_pain_0"..luck, caster)
	EmitSoundOn("Warlord.StoneFormBackground", caster)
	StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_WILD_AXES_END, rate = 1.0})
	CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", caster, 3)

	local q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "warlord")
	if q_1_level > 0 then
		local runeAbility = caster.runeUnit:FindAbilityByName("warlord_rune_q_1")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_warlord_rune_q_1", {duration = duration})
		caster:SetModifierStackCount("modifier_warlord_rune_q_1", caster.runeUnit, q_1_level)
	end

	local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "warlord")
	if q_4_level > 0 then
		local d_a_duration = Filters:GetAdjustedBuffDuration(caster, 20, false)
		local runeAbility = caster.runeUnit4:FindAbilityByName("warlord_rune_q_4")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_q_4_strength", {duration = d_a_duration})
		caster:SetModifierStackCount("modifier_warlord_rune_q_4_strength", caster.runeUnit4, q_4_level)
	end

	if caster:HasModifier("modifier_warlord_glyph_3_1") then
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_stone_form_slow_portion", {duration = duration})
	end
end

function warlord_ice_shell(event)
	local caster = event.caster
	local ability = event.ability
	Filters:CastSkillArguments(1, caster)
	local luck = RandomInt(3, 5)
	EmitSoundOn("beastmaster_beas_pain_0"..luck, caster)
	EmitSoundOn("Warlord.IceShell.Init", caster)
	StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_WILD_AXES_END, rate = 1.0})
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_ice_shell", {duration = duration})
	caster:SetModifierStackCount("modifier_warlord_ice_shell", caster, event.stacks)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_ice_shell_pure", {duration = duration})
	caster:SetModifierStackCount("modifier_warlord_ice_shell_pure", caster, event.stacks_pure)
	CustomAbilities:QuickAttachParticle("particles/roshpit/warlord/ice_shell_activate.vpcf", caster, 3)

	local q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "warlord")
	caster:RemoveModifierByName("modifier_warlord_rune_q_2_visible")
	caster:RemoveModifierByName("modifier_warlord_rune_q_2_invisible")
	if q_2_level > 0 then
		local runeAbility = caster.runeUnit2:FindAbilityByName("warlord_rune_q_2")

		local armorBonus = q_2_level * 0.09 * (Filters:GetBaseBaseArmor(caster))
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_warlord_rune_q_2_visible", {duration = duration})
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_warlord_rune_q_2_invisible", {duration = duration})
		caster:SetModifierStackCount("modifier_warlord_rune_q_2_invisible", caster.runeUnit2, armorBonus)
	end

	local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "warlord")
	if q_4_level > 0 then
		local d_a_duration = Filters:GetAdjustedBuffDuration(caster, 20, false)
		local runeAbility = caster.runeUnit4:FindAbilityByName("warlord_rune_q_4")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_q_4_intelligence", {duration = d_a_duration})
		caster:SetModifierStackCount("modifier_warlord_rune_q_4_intelligence", caster.runeUnit4, q_4_level)
	end
end

function warlord_flame_rush(event)
	local caster = event.caster
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	Filters:CastSkillArguments(1, caster)
	local luck = RandomInt(3, 5)
	EmitSoundOn("beastmaster_beas_pain_0"..luck, caster)
	-- EmitSoundOn("Warlord.StoneFormBackground", caster)
	StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_WILD_AXES_END, rate = 1.0})
	CustomAbilities:QuickAttachParticle("particles/roshpit/warlord/flamerush_activate.vpcf", caster, 3)
	local q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "warlord")
	if q_3_level > 0 then
		local runeAbility = caster.runeUnit3:FindAbilityByName("warlord_rune_q_3")
		runeAbility.q_3_level = q_3_level
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, caster, "modifier_warlord_rune_q_3_hero", {duration = duration})
	end

	local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "warlord")
	if q_4_level > 0 then
		local d_a_duration = Filters:GetAdjustedBuffDuration(caster, 20, false)
		local runeAbility = caster.runeUnit4:FindAbilityByName("warlord_rune_q_4")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_q_4_agility", {duration = d_a_duration})
		caster:SetModifierStackCount("modifier_warlord_rune_q_4_agility", caster.runeUnit4, q_4_level)
	end
end

function warlord_c_a_attack(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local q_3_level = ability.q_3_level
	ability:ApplyDataDrivenModifier(caster, target, "modifier_warlord_rune_q_3_visible", {duration = 12})
	local newStacks = target:GetModifierStackCount("modifier_warlord_rune_q_3_visible", caster) + 1
	target:SetModifierStackCount("modifier_warlord_rune_q_3_visible", caster, newStacks)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_warlord_rune_q_3_invisible", {duration = 12})
	target:SetModifierStackCount("modifier_warlord_rune_q_3_invisible", caster, newStacks * q_3_level)
end

function warlord_stone_form(event)
	local caster = event.caster
	local ability = event.ability
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	Filters:CastSkillArguments(1, caster)
	local luck = RandomInt(3,5)
	EmitSoundOn("beastmaster_beas_pain_0"..luck, caster)
	EmitSoundOn("Warlord.StoneFormBackground", caster)
	StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_CAST_WILD_AXES_END, rate=1.0})
	CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", caster, 3)

	local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "warlord")
	if a_a_level > 0 then
		local runeAbility = caster.runeUnit:FindAbilityByName("warlord_rune_a_a")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_warlord_rune_a_a", {duration = duration})
		caster:SetModifierStackCount("modifier_warlord_rune_a_a", caster.runeUnit, a_a_level)
	end

	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "warlord")
	if d_a_level > 0 then
		local d_a_duration = Filters:GetAdjustedBuffDuration(caster, 20, false)
		local runeAbility = caster.runeUnit4:FindAbilityByName("warlord_rune_d_a")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_d_a_strength", {duration = d_a_duration})
		caster:SetModifierStackCount("modifier_warlord_rune_d_a_strength", caster.runeUnit4, d_a_level)
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
	local luck = RandomInt(3,5)
	EmitSoundOn("beastmaster_beas_pain_0"..luck, caster)
	EmitSoundOn("Warlord.IceShell.Init", caster)
	StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_CAST_WILD_AXES_END, rate=1.0})
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_ice_shell", {duration = duration})
	caster:SetModifierStackCount("modifier_warlord_ice_shell", caster, event.stacks)
	CustomAbilities:QuickAttachParticle("particles/roshpit/warlord/ice_shell_activate.vpcf", caster, 3)


	local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "warlord")
	caster:RemoveModifierByName("modifier_warlord_rune_b_a_visible")
	caster:RemoveModifierByName("modifier_warlord_rune_b_a_invisible")
	if b_a_level > 0 then
		local runeAbility = caster.runeUnit2:FindAbilityByName("warlord_rune_b_a")

		local armorBonus = b_a_level*0.09*(Filters:GetBaseBaseArmor(caster))
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_warlord_rune_b_a_visible", {duration = duration})
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_warlord_rune_b_a_invisible", {duration = duration})
		caster:SetModifierStackCount("modifier_warlord_rune_b_a_invisible", caster.runeUnit2, armorBonus)
	end

	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "warlord")
	if d_a_level > 0 then
		local d_a_duration = Filters:GetAdjustedBuffDuration(caster, 20, false)
		local runeAbility = caster.runeUnit4:FindAbilityByName("warlord_rune_d_a")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_d_a_intelligence", {duration = d_a_duration})
		caster:SetModifierStackCount("modifier_warlord_rune_d_a_intelligence", caster.runeUnit4, d_a_level)
	end
end

function warlord_flame_rush(event)
	local caster = event.caster
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	Filters:CastSkillArguments(1, caster)
	local luck = RandomInt(3,5)
	EmitSoundOn("beastmaster_beas_pain_0"..luck, caster)
	-- EmitSoundOn("Warlord.StoneFormBackground", caster)
	StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_CAST_WILD_AXES_END, rate=1.0})
	CustomAbilities:QuickAttachParticle("particles/roshpit/warlord/flamerush_activate.vpcf", caster, 3)
	local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "warlord")
	if c_a_level > 0 then
		local runeAbility = caster.runeUnit3:FindAbilityByName("warlord_rune_c_a")
		runeAbility.c_a_level = c_a_level
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, caster, "modifier_warlord_rune_c_a_hero", {duration = duration})
	end

	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "warlord")
	if d_a_level > 0 then
		local d_a_duration = Filters:GetAdjustedBuffDuration(caster, 20, false)
		local runeAbility = caster.runeUnit4:FindAbilityByName("warlord_rune_d_a")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_warlord_rune_d_a_agility", {duration = d_a_duration})
		caster:SetModifierStackCount("modifier_warlord_rune_d_a_agility", caster.runeUnit4, d_a_level)
	end
end

function warlord_c_a_attack(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local c_a_level = ability.c_a_level
	ability:ApplyDataDrivenModifier(caster, target, "modifier_warlord_rune_c_a_visible", {duration = 8})
	local newStacks = target:GetModifierStackCount("modifier_warlord_rune_c_a_visible", caster) + 1
	target:SetModifierStackCount("modifier_warlord_rune_c_a_visible", caster, newStacks)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_warlord_rune_c_a_invisible", {duration = 8})
	target:SetModifierStackCount("modifier_warlord_rune_c_a_invisible", caster, newStacks*c_a_level)
end
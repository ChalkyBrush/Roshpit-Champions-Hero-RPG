function flametongue_phase_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	StartSoundEvent("SpiritWarrior.FlametongueCast", caster)
	-- StartSoundEvent("SpiritWarrior.FlametongueTarget", target)
	Timers:CreateTimer(0.82, function()
		if not caster.flametongueStarted then
			StopSoundEvent("SpiritWarrior.FlametongueCast", caster)
			-- StopSoundEvent("SpiritWarrior.FlametongueTarget", target)
		end
		caster.flametongueStarted = false
	end)
	caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "spirit_warrior")
end

function flametongue_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = event.duration
	if caster:HasModifier("modifier_spirit_warrior_immortal_weapon_1") then
		duration = duration + 10
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	caster.flametongueStarted = true
	Filters:CastSkillArguments(1, caster)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_flametongue", {duration = duration})
	if target:GetEntityIndex() == caster:GetEntityIndex() and caster:HasModifier("modifier_spirit_warrior_glyph_6_1") then
	else
		target:RemoveModifierByName("modifier_windstrike_weapon")
	end
	ability.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "spirit_warrior")
	ability.b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "spirit_warrior")
	local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "spirit_warrior")
	caster.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "spirit_warrior")
	if c_a_level > 0 then
		local windstrike = caster:FindAbilityByName("spirit_warrior_windstrike_weapon")
		if not windstrike then
			windstrike = caster:AddAbility("spirit_warrior_windstrike_weapon")
		end
		windstrike:SetLevel(ability:GetLevel())
		windstrike:SetAbilityIndex(0)
		caster:SwapAbilities("spirit_warrior_flametongue", "spirit_warrior_windstrike_weapon", false, true)
	end
end

function flametongue_attack_land(event)
	local target = event.target
	local damage = event.pure_damage
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local mult = event.mult
	damage = damage*mult
	EmitSoundOn("SpiritWarrior.FlametongueImpact", target)
	CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_c.vpcf", target, 1)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	print(ability.a_a_level)
	if ability.a_a_level > 0 then
		print("FIRE EFFECT?")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flametongue_a_a_rune", {duration = 5})
		local stacks = target:GetModifierStackCount("modifier_flametongue_a_a_rune", caster)
		local newStacks = math.min(stacks+1, 50)
		target:SetModifierStackCount("modifier_flametongue_a_a_rune", caster, newStacks)
	end
	if ability.b_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flametongue_b_a_rune_visible", {duration = 5})
		local stacks = target:GetModifierStackCount("modifier_flametongue_b_a_rune_visible", caster)
		local newStacks = math.min(stacks+1, 50)
		target:SetModifierStackCount("modifier_flametongue_b_a_rune_visible", caster, newStacks)

		ability:ApplyDataDrivenModifier(caster, target, "modifier_flametongue_b_a_rune_invisible", {duration = 5})
		local armorLossStacks = newStacks*ability.b_a_level
		target:SetModifierStackCount("modifier_flametongue_b_a_rune_invisible", caster, armorLossStacks)
	end
end

function a_a_damage(event)
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	local caster = event.caster
	local stacks = target:GetModifierStackCount("modifier_flametongue_a_a_rune", caster)
	local burnDamage = (220 + 285*ability.a_a_level)*stacks
	Filters:ApplyDotDamage(caster, ability, target, burnDamage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end
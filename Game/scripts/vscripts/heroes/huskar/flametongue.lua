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
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "spirit_warrior")
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
	ability.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "spirit_warrior")
	ability.q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "spirit_warrior")
	local q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "spirit_warrior")
	caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "spirit_warrior")
	if q_3_level > 0 then
		local windstrike = caster:FindAbilityByName("spirit_warrior_windstrike_weapon")
		if not windstrike then
			windstrike = caster:AddAbility("spirit_warrior_windstrike_weapon")
		end
		windstrike:SetLevel(ability:GetLevel())
		windstrike:SetAbilityIndex(0)
		caster:SwapAbilities("spirit_warrior_flametongue", "spirit_warrior_windstrike_weapon", false, true)
	end

	caster.q_2_level = ability.q_2_level
	if ability.q_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flametongue_q_2_fire_shield", {duration = duration})
		CustomAbilities:QuickAttachParticle("particles/roshpit/heroes/spirit_warrior/flameblood_fire_shield.vpcf", caster, 2)
		-- CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/crimsyth_elite_magic.vpcf", caster:GetAbsOrigin()+Vector(0,0,100)+caster:GetForwardVector()*150, 1.5)
	end
end

function flametongue_attack_land(event)
	local target = event.target
	local damage = event.pure_damage
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local mult = event.mult
	if target:GetPhysicalArmorValue(false) < 0 then
		damage = damage + (event.negative_armor_amp / 100) * math.abs(target:GetPhysicalArmorValue(false)) * damage
	end
	damage = damage * mult
	EmitSoundOn("SpiritWarrior.FlametongueImpact", target)
	CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_c.vpcf", target, 1)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	--print(ability.q_1_level)
	if ability.q_1_level > 0 then
		--print("FIRE EFFECT?")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flametongue_a_a_rune", {duration = 5})
		local stacks = target:GetModifierStackCount("modifier_flametongue_a_a_rune", caster)
		local newStacks = math.min(stacks + 1, 50)
		target:SetModifierStackCount("modifier_flametongue_a_a_rune", caster, newStacks)
	end
	if ability.q_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flametongue_b_a_rune_visible", {duration = 10})
		local stacks = target:GetModifierStackCount("modifier_flametongue_b_a_rune_visible", caster)
		local newStacks = stacks + 1
		target:SetModifierStackCount("modifier_flametongue_b_a_rune_visible", caster, newStacks)

		ability:ApplyDataDrivenModifier(caster, target, "modifier_flametongue_b_a_rune_invisible", {duration = 10})
		local armorLossStacks = newStacks * ability.q_1_level
		target:SetModifierStackCount("modifier_flametongue_b_a_rune_invisible", caster, armorLossStacks)
	end
end

function a_a_damage(event)
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	local caster = event.caster
	local stacks = target:GetModifierStackCount("modifier_flametongue_a_a_rune", caster)
	local burnDamage = (220 + 285 * ability.q_1_level) * stacks
	if target:GetPhysicalArmorValue(false) < 0 then
		burnDamage = burnDamage + (event.negative_armor_amp / 100) * math.abs(target:GetPhysicalArmorValue(false)) * burnDamage
	end
	Filters:ApplyDotDamage(caster, ability, target, burnDamage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

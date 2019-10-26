require('/heroes/huskar/spirit_warrior_constants')

function windstrike_phase_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	StartSoundEvent("SpiritWarrior.WindstrikeCast", caster)
	-- StartSoundEvent("SpiritWarrior.FlametongueTarget", target)
	Timers:CreateTimer(0.82, function()
		if not caster.windstrikeStarted then
			StopSoundEvent("SpiritWarrior.WindstrikeCast", caster)
			-- StopSoundEvent("SpiritWarrior.FlametongueTarget", target)
		end
		caster.windstrikeStarted = false
	end)
	caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "spirit_warrior")
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "spirit_warrior")
end

function windstrike_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = event.duration
	if caster:HasModifier("modifier_spirit_warrior_immortal_weapon_1") then
		duration = duration + SPIRIT_WARRIOR_IMMORTAL_WEAPON_1_Q_DURATION_BONUS
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "spirit_warrior")
	caster.windstrikeStarted = true
	Filters:CastSkillArguments(1, caster)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_windstrike_weapon", {duration = duration})
	if target:GetEntityIndex() == caster:GetEntityIndex() and caster:HasModifier("modifier_spirit_warrior_glyph_6_1") then
	else
		target:RemoveModifierByName("modifier_flametongue")
	end
	local flametongue = caster:FindAbilityByName("spirit_warrior_flametongue")
	flametongue:SetLevel(ability:GetLevel())
	flametongue:SetAbilityIndex(0)
	caster:SwapAbilities("spirit_warrior_flametongue", "spirit_warrior_windstrike_weapon", true, false)
	local q_2_level = caster:GetRuneValue("q", 2)
	if q_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_windstrike_evasion", {duration = duration})
		caster:SetModifierStackCount("modifier_windstrike_evasion", caster, q_2_level)
		CustomAbilities:QuickAttachParticle("particles/roshpit/heroes/spirit_warrior/windstrike_wind_shield.vpcf", caster, 2)
	end
end

function windstrike_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mult = event.mult
	CustomAbilities:QuickAttachParticle("particles/econ/items/elder_titan/elder_titan_fissured_soul/elder_titan_fissured_soul_spirit_buff_endcap.vpcf", target, 1)
	local damage = ability.q_3_level * SPIRIT_WARRIOR_Q3_DMG_PCT/100 * OverflowProtectedGetAverageTrueAttackDamage(attacker) * mult
	if target:GetPhysicalArmorValue(false) > 0 then
		damage = damage + damage * SPIRIT_WARRIOR_Q3_AMP_PER_ARMOR_PCT/100 * target:GetPhysicalArmorValue(false)
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_Q, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
end

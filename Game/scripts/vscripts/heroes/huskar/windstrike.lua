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
	caster.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "spirit_warrior")
	caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "spirit_warrior")
end

function windstrike_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = event.duration
	if caster:HasModifier("modifier_spirit_warrior_immortal_weapon_1") then
		duration = duration + 10
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability.c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "spirit_warrior")
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
end

function windstrike_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mult = event.mult
	CustomAbilities:QuickAttachParticle("particles/econ/items/elder_titan/elder_titan_fissured_soul/elder_titan_fissured_soul_spirit_buff_endcap.vpcf", target, 1)
	local damage = ability.c_a_level*0.05*attacker:GetAverageTrueAttackDamage(attacker)*mult
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
end
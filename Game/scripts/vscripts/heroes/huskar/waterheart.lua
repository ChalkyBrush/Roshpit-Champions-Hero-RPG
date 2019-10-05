require('/heroes/huskar/spirit_warrior_constants')

function waterheart_phase_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	StartSoundEvent("SpiritWarrior.Waterheart.Cast", caster)
	-- StartSoundEvent("SpiritWarrior.FlametongueTarget", target)
	Timers:CreateTimer(0.82, function()
		if not caster.waterheartStarted then
			StopSoundEvent("SpiritWarrior.Waterheart.Cast", caster)
			-- StopSoundEvent("SpiritWarrior.FlametongueTarget", target)
		end
		caster.waterheartStarted = false
	end)
	caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "spirit_warrior")
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "spirit_warrior")
end

function waterheart_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = event.duration
	if caster:HasModifier("modifier_spirit_warrior_immortal_weapon_1") then
		duration = duration + 10
	end
	if caster:HasModifier("modifier_spirit_warrior_glyph_7_1") then
		duration = duration + SPIRIT_WARRIOR_GLYPH_7_1_ADDITIONAL_DURATION
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	caster.waterheartStarted = true
	Filters:CastSkillArguments(4, caster)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_waterheart_weapon", {duration = duration})
end

function waterheart_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mult = event.mult
	CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_water_splash_c.vpcf", target, 1)
	local damage = attacker:GetHealth() * ability.r_3_level * 0.6 * mult
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "SpiritWarrior.Waterheart.Impact", attacker)
end

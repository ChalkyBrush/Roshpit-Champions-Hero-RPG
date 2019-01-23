require('heroes/arc_warden/abilities/onibi')

function jex_active_q_cosmic_nature_shield(event)
	local caster = event.caster
	local ability = event.ability

	local duration_base = event.duration_base
	local duration_per_tech = event.duration_per_tech

	local tech_level = onibi_get_total_tech_level(caster, "cosmic", "nature", "Q")
	local duration = Filters:GetAdjustedBuffDuration(caster, duration_base + duration_per_tech*tech_level, false)

	EmitSoundOn("Jex.CosmicBarrier", caster)
	EmitSoundOn("Jex.CosmicBarrierMagic", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_magic_immunity", {duration = duration})

	local invokePFX = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", caster, 4)
	ParticleManager:SetParticleControl(invokePFX, 1, Vector(60, 10, 150))
	Filters:CastSkillArguments(1, caster)

	ability.q_4_level = caster:GetRuneValue("q", 4)
end

function jex_cosmic_nature_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		local bonus_duration = 5
		local luck = RandomInt(1, 200)
		luck = -2
		if luck < e_4_level then
			local already_modifier = caster:FindModifierByName("modifier_jex_magic_immunity")
			local new_duration = already_modifier:GetDuration() + 0.5
			already_modifier:SetDuration(new_duration, true)
		end
	end
end
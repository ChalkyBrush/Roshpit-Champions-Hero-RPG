function jex_active_q_cosmic_nature_shield(event)
	local caster = event.caster
	local ability = event.ability

	local duration_base = event.duration_base
	local duration_per_tech = event.duration_per_tech

	local tech_level = caster.onibi.stats_table["nature"]["cosmic"]["Q"]["level"]
	local duration = Filters:GetAdjustedBuffDuration(caster, duration_base + duration_per_tech*tech_level, false)

	EmitSoundOn("Jex.CosmicBarrier", caster)
	EmitSoundOn("Jex.CosmicBarrierMagic", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_magic_immunity", {duration = duration})

	local invokePFX = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", caster, 4)
	ParticleManager:SetParticleControl(invokePFX, 1, Vector(60, 10, 150))
	Filters:CastSkillArguments(1, caster)
end
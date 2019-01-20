function jex_activate_q_lightning_cosmic(event)
	local caster = event.caster
	local ability = event.ability

	local duration_base = event.duration
	local stacks_per_tech = event.stacks_per_tech

	local tech_level = caster.onibi.stats_table["lightning"]["cosmic"]["Q"]["level"]
	local duration = Filters:GetAdjustedBuffDuration(caster, duration_base, false)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_lightning_cosmic_shield", {duration = duration})
	EmitSoundOn("Jex.ElectronShield.Start", caster)
	EmitSoundOn("Jex.ElectronShield.Spark", caster)
	local invokePFX = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", caster, 4)
	ParticleManager:SetParticleControl(invokePFX, 1, Vector(10, 10, 100))

	caster:SetModifierStackCount("modifier_jex_lightning_cosmic_shield", caster, tech_level*stacks_per_tech)

	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_cosmic_shield_w_4", {duration = duration})
		caster:SetModifierStackCount("modifier_cosmic_shield_w_4", caster, w_4_level)
	end
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_cosmic_shield_e_4", {duration = duration})
		caster:SetModifierStackCount("modifier_cosmic_shield_e_4", caster, e_4_level)
	end	
	
	Filters:CastSkillArguments(1, caster)
end

function jex_lightning_cosmic_shield_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.unit
	local new_stacks = target:GetModifierStackCount("modifier_jex_lightning_cosmic_shield", caster) - 1
	if new_stacks > 0 then
		target:SetModifierStackCount("modifier_jex_lightning_cosmic_shield", caster, new_stacks)
	else
		target:RemoveModifierByName("modifier_jex_lightning_cosmic_shield")
	end
end
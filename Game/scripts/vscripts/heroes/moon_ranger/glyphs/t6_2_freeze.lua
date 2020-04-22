require('heroes/moon_ranger/astral_ranger_constants')

function freeze_on_attack_landed(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local freeze_chance = ASTRAL_RANGER_GLYPH_6_2_FREEZE_CHANCE
	local freeze_duration = ASTRAL_RANGER_GLYPH_6_2_FREEZE_DURATION
	local freeze_immunity = ASTRAL_RANGER_GLYPH_6_2_FREEZE_IMMUNITY
	local proc = Filters:GetProc(attacker, freeze_chance)
	if proc then
		local position = target:GetAbsOrigin()
		if not target:HasModifier("modifier_astral_6_2_freeze_immune") then
			ability:ApplyDataDrivenModifier(attacker, target, "modifier_astral_glyph_6_2_freeze", {duration = freeze_duration})
			ability:ApplyDataDrivenModifier(attacker, target,"modifier_astral_glyph_6_2_freeze_immune", {duration = freeze_immunity})
		end
		local particleName = "particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_impact_ti_5.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 4, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 5, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Astral.StarBlink.SpellStart", attacker)
	end
end	
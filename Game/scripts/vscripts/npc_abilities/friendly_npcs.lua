function gem_forger_entering_think(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()

	local newFV = WallPhysics:rotateVector(fv, 2*math.pi/30)
	caster:SetForwardVector(newFV)

	local distanceFromGround = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
	local downSpeed = math.max(14, distanceFromGround/20)
	downSpeed = math.min(24, downSpeed)
	if distanceFromGround > 10 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,downSpeed))
		ParticleManager:SetParticleControl(caster.entering_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(caster.entering_pfx, 1, caster:GetAbsOrigin())
	else
		caster:RemoveModifierByName("modifier_gem_forger_entering")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		caster:SetForwardVector(caster.endFV)
		CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf", caster, 2)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", caster, 0.03)
		ParticleManager:DestroyParticle(caster.entering_pfx, false)
		StartAnimation(caster, {duration = 4, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.85})
		EmitSoundOn("NPC.Gemforger.Enter.End", caster)
		EmitSoundOn("NPC.Gemforger.Enter.EndHilite", caster)
		Timers:CreateTimer(0.3, function()
			EmitSoundOn("NPC.Gemforger.Enter.VO", caster)
		end)
	end
end
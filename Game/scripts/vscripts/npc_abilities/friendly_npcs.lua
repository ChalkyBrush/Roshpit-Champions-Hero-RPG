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

function gem_forger_going_home_think(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()

	local newFV = WallPhysics:rotateVector(fv, 2*math.pi/30)
	caster:SetForwardVector(newFV)
	local hero = caster.going_home_buddy
	local distanceFromGround = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
	local upspeed = math.max(14, distanceFromGround/20)
	upspeed = math.min(24, upspeed)
	if Gems.GemForger.going_home_phase == 0 then
		if distanceFromGround < 1400 then
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,upspeed))
			ParticleManager:SetParticleControl(caster.home_pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(caster.home_pfx, 1, caster:GetAbsOrigin())

			hero:SetAbsOrigin(hero:GetAbsOrigin()+Vector(0,0,upspeed))
			ParticleManager:SetParticleControl(caster.hero_home_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(caster.hero_home_pfx, 1, hero:GetAbsOrigin())
		else
			caster:SetForwardVector(caster.endFV)
			CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf", caster, 2)

			StartAnimation(caster, {duration = 4, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.85})
			EmitSoundOn("NPC.Gemforger.Enter.End", caster)

			Gems.GemForger.going_home_phase = 1
			caster:SetAbsOrigin(Events.TownPosition+Vector(0,0,2000)+RandomVector(400))
			hero:SetAbsOrigin(caster:GetAbsOrigin()+RandomVector(200))
		end
	else
		local distanceFromGround = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
		local downSpeed = math.max(14, distanceFromGround/20)
		downSpeed = math.min(24, downSpeed)
		if distanceFromGround > 10 then
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,downSpeed))
			ParticleManager:SetParticleControl(caster.home_pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(caster.home_pfx, 1, caster:GetAbsOrigin())

			hero:SetAbsOrigin(hero:GetAbsOrigin()-Vector(0,0,downSpeed))
			ParticleManager:SetParticleControl(caster.hero_home_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(caster.hero_home_pfx, 1, hero:GetAbsOrigin())
		else
			caster:RemoveModifierByName("modifier_gem_forger_going_home")
			hero:RemoveModifierByName("modifier_gem_forger_going_home_hero")
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			caster:SetForwardVector(caster.endFV)
			CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf", caster, 2)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", caster, 0.03)
			ParticleManager:DestroyParticle(caster.home_pfx, false)
			ParticleManager:DestroyParticle(caster.hero_home_pfx, false)
			StartAnimation(caster, {duration = 4, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.85})
			EmitSoundOn("NPC.Gemforger.Enter.End", caster)
			EmitSoundOn("NPC.Gemforger.Enter.EndHilite", caster)
			Timers:CreateTimer(0.3, function()
				EmitSoundOn("NPC.Gemforger.Enter.VO", caster)
			end)
			CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf", hero, 2)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", hero, 0.03)
		end
	end
end
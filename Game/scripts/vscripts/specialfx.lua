if SpecialFX == nil then
	SpecialFX = class({})
end

function SpecialFX:ColoredSpotlight(position, colorVector)
	local groundPos = GetGroundPosition(position, Events.GameMaster)
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/spotlight_colorable.vpcf", groundPos, 5)
	ParticleManager:SetParticleControl(pfx, 1, groundPos + Vector(0,0,3000))
	ParticleManager:SetParticleControl(pfx, 2, groundPos)
	ParticleManager:SetParticleControl(pfx, 3, colorVector/255)
end

function SpecialFX:ColoredPop(position, colorVector)
	local particleName = "particles/roshpit/winterblight/colorable_pop.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, colorVector/255)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end
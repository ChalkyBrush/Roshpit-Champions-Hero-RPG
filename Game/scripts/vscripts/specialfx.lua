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

function SpecialFX:ColoredScaleSpotlightEntrance(unit, spotlight_color, scale_ticks)
	unit.cantAggro = true
	unit:SetAbsOrigin(unit:GetAbsOrigin()+Vector(0,0,2000))
	local groundPosition = GetGroundPosition(unit:GetAbsOrigin(), unit)
	SpecialFX:ColoredSpotlight(groundPosition, spotlight_color)
	if scale_ticks > 0 then
		local end_scale = unit:GetModelScale()
		unit:SetModelScale(0.1)
		Timers:CreateTimer(1, function()
			Events:smoothSizeChange(unit, 0.1, end_scale, scale_ticks)
		end)
	end
	Events:smoothTranslate(unit, Vector(0,0,-20), 99, Vector(0,0), nil)
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_disable_player", {duration = 3.2})
	Timers:CreateTimer(3.1, function()
		unit.cantAggro = false
	end)
end
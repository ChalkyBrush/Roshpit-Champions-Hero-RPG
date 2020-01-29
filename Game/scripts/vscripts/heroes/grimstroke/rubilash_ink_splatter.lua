require('heroes/grimstroke/rubilash_w_ability')

function ink_splatter_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	local casterOrigin = caster:GetAbsOrigin()
	local newPosition  = WallPhysics:WallSearch(casterOrigin, point, caster)

	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/e_start_"..caster.color..".vpcf", caster, 4)
	ParticleManager:SetParticleControl(pfx, 2, newPosition)

	caster:SetAbsOrigin(newPosition - Vector(0,0,300))
	toggle_rubilash_color(caster)
	local particlePos = GetGroundPosition(newPosition, caster)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_splatter_"..caster.color..".vpcf", particlePos, 3)
	EmitSoundOn("Rubilash.InkSplatter.Highlight", caster)
	EmitSoundOn("Rubilash.InkSplatter.Splatter", caster)
	EmitSoundOn("Rubilash.VO.Grunt", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ink_splatter_emerging", {duration = 0.24})
	StartAnimation(caster, {duration = 2, activity = ACT_DOTA_TELEPORT_END, rate = 1})
end

function ink_splatter_emerging_think(event)
	local caster = event.caster
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,37.5))
end

function ink_splatter_emerging_end(event)
	local caster = event.caster
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end
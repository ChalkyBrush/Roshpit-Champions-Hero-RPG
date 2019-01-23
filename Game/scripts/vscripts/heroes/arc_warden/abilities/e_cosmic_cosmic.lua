require('heroes/arc_warden/abilities/onibi')

function jex_cosmic_cosmic_e_phase_start(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf", caster, 1.5)
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=0.6})
	EmitSoundOn("Jex.Warp.Pre", caster)
	EmitSoundOn("Jex.Warp.Activate", caster)
end

function jex_cosmic_port_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]

    local tech_level = onibi_get_total_tech_level(caster, "cosmic", "cosmic", "E")

	local range = event.additional_cast_range_per_tech*tech_level + event.cast_range
    local e_4_level = caster:GetRuneValue("e", 4)
    range = range + event.e_4_additional_cast_range*e_4_level
    local distance = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin())
    if distance > range then
        local targetVector = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
        target = caster:GetAbsOrigin() + targetVector*range
    end
    local casterOrigin = caster:GetAbsOrigin()
    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    local newPosition = target
    FindClearSpaceForUnit(caster, newPosition, false)
    Filters:CastSkillArguments(3, caster)
    ProjectileManager:ProjectileDodge(caster)

    if caster:HasModifier("modifier_jex_warp_freecast") then
    	local stacks = caster:GetModifierStackCount("modifier_jex_warp_freecast", caster)
    	if stacks > 1 then
    		caster:SetModifierStackCount("modifier_jex_warp_freecast", caster, stacks - 1)
    	else
    		caster:RemoveModifierByName("modifier_jex_warp_freecast")
    	end
    	ability:EndCooldown()
    else
    	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_warp_freecast", {})
    	caster:SetModifierStackCount("modifier_jex_warp_freecast", caster, tech_level)
    end
end
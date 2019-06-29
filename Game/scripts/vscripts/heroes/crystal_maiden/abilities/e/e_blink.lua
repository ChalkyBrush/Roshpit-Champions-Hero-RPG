require('heroes/crystal_maiden/init')
local Blink = require('heroes/crystal_maiden/abilities/e/e1_flicker')
local WaterElemental = require('heroes/crystal_maiden/abilities/e/e2_water_elemental')

function startCast(event)
    local caster = event.caster
    local target = event.target_points[1]
    local casterOrigin = caster:GetAbsOrigin()
    local ability = event.ability

    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    local newPosition = target

    Helper.initializeAbilityRunes(caster, 'sorceress', 'q')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'w')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'e')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'r')

    caster:AddNoDraw()
    caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)

    FindClearSpaceForUnit(event.caster, newPosition, false)

    Blink.cast(caster, ability)
    clearCast(caster, ability)
    ability.amp = 1 + event.amp / 100

    if not caster:HasModifier("modifier_sorceress_immortal_ice_avatar") and not caster:HasModifier("modifier_sorceress_immortal_fire_avatar") then
        WaterElemental.summon(caster, ability, newPosition)
    end

    Filters:CastSkillArguments(3, event.caster)
    ProjectileManager:ProjectileDodge(event.caster)
end

function endCast(event)
    event.caster:RemoveNoDraw()
    event.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
end

function clearCast(caster, ability)
    local lucky = RandomInt(1, 2)
    if lucky ~= 1 and not caster:HasModifier('modifier_sorceress_glyph_4_2') then
        return
    end

    EmitSoundOn("Sorceress.ClearCast", caster)
    caster:RemoveModifierByName("modifier_pyro_cooldown")

    local amplify = ability.amp
    local clearCastDuration = Filters:GetAdjustedBuffDuration(caster, E_CLEAR_CAST_DURATION, false)

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_clear_cast", {duration = clearCastDuration})

    local pyroblast = caster:FindAbilityByName("pyroblast")
    if pyroblast then
        pyroblast.e_3_amp = amplify
        pyroblast:EndCooldown()
    end
    local ice_tornado = caster:FindAbilityByName("sorceress_arcana_ice_tornado")
    if ice_tornado then
        ice_tornado.e_3_amp = amplify
        ice_tornado:EndCooldown()
    end

end

function clearCastEnd(event)
    local caster = event.caster
    local ice_tornado = caster:FindAbilityByName("sorceress_arcana_ice_tornado")
    if ice_tornado then
        ice_tornado.e_3_amp = 0
    end
end

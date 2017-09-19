require('heroes/moon_ranger/init')
local function hitUnitsAndApplyMidifier(caster, ability, target)
    local runesCount =  caster.b_c_level
    if runesCount == nil or runesCount <= 0 then
        return
    end

    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target, nil, E2_FIND_RADUIS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            CustomAbilities:QuickAttachParticle(E2_PARTICLE, enemy, 1)
            caster:PerformAttack(enemy, true, true, true, false, true, false, false)
        end
    end
    ability:ApplyDataDrivenModifier(caster, caster, 'modifier_astral_rune_b_c_visible', {duration = E2_DURATION})
    caster:SetModifierStackCount('modifier_astral_rune_b_c_visible', caster, runesCount)
end

local module = {}
module.hitUnitsAndApplyMidifier = hitUnitsAndApplyMidifier
return module
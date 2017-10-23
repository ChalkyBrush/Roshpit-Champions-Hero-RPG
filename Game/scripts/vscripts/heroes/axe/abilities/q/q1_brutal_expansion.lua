local function getAdditionalDamage(caster)
    if caster.a_a_level > 0 then
        return  caster.a_a_level * caster:GetAverageTrueAttackDamage(caster) * Q1_ATTACK_DAMAGE_PROCENT/100
    else
        return 0
    end
end

local module = {}
module.getAdditionalDamage = getAdditionalDamage
return module
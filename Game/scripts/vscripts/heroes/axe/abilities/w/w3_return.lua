local function cast(caster, abilityLevel)
    if caster.c_b_level > 0 then
        local healAmount = caster.c_b_level* W3_HEAL * abilityLevel
        Filters:ApplyHeal(caster, caster, healAmount, true)
        -- PopupHealing(caster, healAmount)
    end
end

local module = {}
module.cast = cast
return module
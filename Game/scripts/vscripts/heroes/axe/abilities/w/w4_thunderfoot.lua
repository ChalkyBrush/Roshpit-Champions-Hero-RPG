local function getAmplify(caster)
    if caster.d_b_level <= 0 then
        return 1
    else
        return 1 + RED_GENERAL_W4_AMPLIFY_PERCENT/100 * caster:GetStrength()/10 * caster.d_b_level
    end
end

local module = {}
module.getAmplify = getAmplify
return module
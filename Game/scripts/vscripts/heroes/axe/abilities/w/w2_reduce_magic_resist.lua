local function applyDebuff(target, caster, ability)
    local runesCount = caster.b_b_level
    if runesCount <= 0 then
        return
    end
    Helper.updateStackModifier(target, caster, ability, "axe_rune_b_b", RED_GENERAL_W2_DURATION, RED_GENERAL_W2_MAX_STACKS_COUNT, runesCount)
end
local module = {}
module.applyDebuff = applyDebuff
return module
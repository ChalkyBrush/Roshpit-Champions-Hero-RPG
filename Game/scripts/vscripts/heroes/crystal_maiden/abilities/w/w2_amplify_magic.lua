local function cast(caster, target, ability)
    local runesCount = caster.b_b_level
    if runesCount > 0 then
        Helper.updateStackModifier(target, caster, ability, 'sorceress_rune_b_b', W2_DURATION, W2_MAX_STACKS_COUNT, runesCount)
    end
end
local module = {}
module.cast = cast
return module
local function applyBuff(caster, ability)
    local runesCount = caster:GetRuneValue("r", 2)

    if runesCount <= 0 then
        return
    end

    local duration = Filters:GetAdjustedBuffDuration(caster, ARCANA1_R2_DURATION, false)

    Helper.updateStackModifier(caster, caster, ability, 'axe_rune_r_2_arcana1', duration, ARCANA1_R2_MAX_STACKS_COUNT, runesCount)
end

local module = {}
module.applyBuff = applyBuff
return module
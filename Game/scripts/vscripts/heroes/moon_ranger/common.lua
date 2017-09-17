function getProcChance(caster, baseChance)
    return baseChance * (1 + R4_PROC_CHANCE_INCREASE * caster.d_d_level)
end
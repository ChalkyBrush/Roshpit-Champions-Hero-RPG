function getProcChance(caster, baseChance)
	local runeCount = Runes:GetTotalRuneLevel(caster, 4, "d_d", "astral")
    return baseChance * (1 + R4_PROC_CHANCE_INCREASE * runeCount)
end
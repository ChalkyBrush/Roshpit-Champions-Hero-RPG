local function cast(caster, abilityLevel)
	if caster.w_3_level > 0 then
		local healAmountFlat = caster.w_3_level * W3_HEAL_FLAT * abilityLevel
		local healAmountPct = caster.w_3_level * W3_HEAL_PCT / 100 * caster:GetMaxHealth() * abilityLevel
		Filters:ApplyHeal(caster, caster, healAmountFlat + healAmountPct, true)
		-- PopupHealing(caster, healAmount)
	end
end

local module = {}
module.cast = cast
return module

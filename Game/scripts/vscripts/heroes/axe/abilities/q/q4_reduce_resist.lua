local function applyDebuff(caster, target, ability)
	if caster.q_4_level > 0 then
		local runesCount = caster.q_4_level
		Helper.updateStackModifier(target, caster, ability, 'axe_rune_q_4', Q4_DURATION, Q4_MAX_STACKS_COUNT, runesCount)
		if caster:HasModifier("modifier_axe_glyph_2_2") then
			local glyphAbility = caster:FindModifierByName("modifier_axe_glyph_2_2"):GetAbility()
			Helper.updateStackModifier(target, caster, glyphAbility, 'axe_glyph_2_2', Q4_DURATION, Q4_MAX_STACKS_COUNT, nil)
		end
	end
end

local module = {}
module.applyDebuff = applyDebuff
return module

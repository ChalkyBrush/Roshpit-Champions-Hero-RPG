local function applyBuff(caster)
	if caster:HasModifier("modifier_axe_glyph_5_2") then
		local ability = caster:FindModifierByName("modifier_axe_glyph_5_2"):GetAbility()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_glyph_5_2_buff", {duration = T52_AMPLIFY_DURATION})
	end
end
local function getAmplify(caster)
	if caster:HasModifier("modifier_axe_glyph_5_2") and caster:HasModifier("modifier_axe_glyph_5_2_buff") then
		return 1 + T52_AMPLIFY_PERCENT / 100
	else
		return 1
	end
end

local module = {}
module.applyBuff = applyBuff
module.getAmplify = getAmplify
return module

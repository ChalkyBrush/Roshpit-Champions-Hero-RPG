local function applyDebuff(target, caster, ability)
	local runesCount = caster.w_2_level
	if runesCount <= 0 then
		return
	end
	Helper.updateStackModifier(target, caster, ability, "axe_rune_w_2", RED_GENERAL_W2_DURATION, RED_GENERAL_W2_MAX_STACKS_COUNT, runesCount)
end
local module = {}
module.applyDebuff = applyDebuff
return module

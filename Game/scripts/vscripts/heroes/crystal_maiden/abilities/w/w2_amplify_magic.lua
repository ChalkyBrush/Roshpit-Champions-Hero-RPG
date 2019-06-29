local function cast(caster, target, ability)
	local runesCount = caster.w_2_level
	if runesCount > 0 then
		Helper.updateStackModifier(target, caster, ability, 'sorceress_rune_w_2', SORCERESS_W2_DURATION, SORCERESS_W2_MAX_STACKS_COUNT, runesCount)
	end
end
local module = {}
module.cast = cast
return module

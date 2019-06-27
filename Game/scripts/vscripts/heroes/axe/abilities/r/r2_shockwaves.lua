local function dealDamage(caster, target, ability, initialDamage)
	local runesCount = caster.r_2_level
	if runesCount <= 0 then
		return
	end
	local damage = initialDamage * RED_GENERAL_R2_AMPLIFY_PERCENT / 100 * runesCount
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

end
local module = {}
module.dealDamage = dealDamage
return module

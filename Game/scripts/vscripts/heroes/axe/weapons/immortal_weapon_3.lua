local CyclonicShield = require("heroes/axe/abilities/red_general_ability_base_e_whirlwind")
local function amplifyShieldsCount(caster)
	print("amplifyShieldsCount")
	if caster:HasModifier("modifier_axe_immortal_weapon_3") then
		local ability = caster:FindAbilityByName("red_general_ability_base_e_whirlwind")
		CyclonicShield.red_general_rune_base_e_4_amplifyShieldsCount(caster, ability, 1 + RED_GENERAL_IMMORTAL_WEAPON_3_BONUS_SHIELDS_PERCENT / 100)
	end
end

local module = {}
module.amplifyShieldsCount = amplifyShieldsCount
return module

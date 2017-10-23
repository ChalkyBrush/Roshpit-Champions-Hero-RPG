local CyclonicShield = require('heroes/axe/abilities/e/e4_cyclonic_shield')
local function amplifyShieldsCount(caster)
    if caster:HasModifier("modifier_axe_immortal_weapon_3") then
        local ability = caster:FindAbilityByName("whrlwind")
        CyclonicShield.amplifyShieldsCount(caster, ability, 1 + SEA_WEAPON_2_BONUS_SHIELDS_PERCENT/100)
    end
end

local module = {}
module.amplifyShieldsCount = amplifyShieldsCount
return module
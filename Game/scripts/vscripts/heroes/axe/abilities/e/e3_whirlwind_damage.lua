local ImmortalWeapon2 = require('heroes/axe/weapons/immortal_weapon_2')
local function damageEnemies(caster, enemies)
    if caster.c_c_level > 0 then
        local damage = caster.c_c_level * caster:GetAverageTrueAttackDamage(caster)  * E3_DAMAGE_PERCENT/100
        for _,enemy in pairs(enemies) do
            local damageWithWeapon = damage * ImmortalWeapon2.getAmp(caster, enemy)
            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damageWithWeapon, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
        end
    end
end

local module = {}
module.damageEnemies = damageEnemies
return module
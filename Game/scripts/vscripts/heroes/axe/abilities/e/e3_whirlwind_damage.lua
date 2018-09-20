local ImmortalWeapon2 = require('heroes/axe/weapons/immortal_weapon_2')
local function damageEnemies(caster, enemies)
    if caster.e_3_level > 0 then
        local damage = caster.e_3_level * OverflowProtectedGetAverageTrueAttackDamage(caster)  * RED_GENERAL_E3_DAMAGE_PERCENT/100
        for _,enemy in pairs(enemies) do
            local damageWithWeapon = damage * ImmortalWeapon2.getAmp(caster, enemy)
            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damageWithWeapon, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
            EmitSoundOn("RedGeneral.HitSpin", enemy)
            CustomAbilities:QuickParticleAtPoint("particles/roshpit/solunia/boomerang_impact.vpcf", enemy:GetAbsOrigin()+Vector(0,0,100), 0.5)
        end
    end
end

local module = {}
module.damageEnemies = damageEnemies
return module
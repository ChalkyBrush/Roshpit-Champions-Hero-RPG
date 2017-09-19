require('heroes/moon_ranger/init')
local AstralSteal = require('heroes/moon_ranger/abilities/w/w1_astral_steal')
local ClusterArrow = require('heroes/moon_ranger/abilities/w/w4_cluster_arrow')
function projectileHit(event)
    local target = event.target
    local caster = event.caster.hero
    local ability = caster:FindAbilityByName("split_shot")
    local runesCount = caster.c_b_level

    local eventTable = {
        ability = ability,
        caster = caster,
        target = target
    }

    AstralSteal.projectileHit(eventTable)
    ClusterArrow.projectileHit(eventTable)

    local damage = ability:GetSpecialValueFor("damage")*(1 + runesCount * W3_MULTIPLY_PERCENT)
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
    PopupDamage(target, damage)
end

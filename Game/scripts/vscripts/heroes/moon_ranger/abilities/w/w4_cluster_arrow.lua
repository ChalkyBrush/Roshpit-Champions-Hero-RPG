require('heroes/moon_ranger/init')
local function projectileHit(event)
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local damage = event.ability.damage
    local runesCount = caster.d_b_level
    if runesCount == nill or runesCount <= 0 then
        return
    end

    Helper.updateStackModifier(target, caster, ability, 'astral_d_b', W4_DURATION, W4_MAX_STACKS_COUNT, runesCount)
end

local module = {}
module.projectileHit = projectileHit
return module
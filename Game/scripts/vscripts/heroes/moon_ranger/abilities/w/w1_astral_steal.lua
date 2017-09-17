require('heroes/moon_ranger/init')

local function projectileHit(event)
    local ability = event.ability
    local caster = event.caster

    local runesCount = Runes:GetTotalRuneLevel(caster, 1, "a_b", "astral")

    if runesCount == nill or runesCount <= 0 then
        return
    end

    Helper.updateStackModier(caster, caster, ability, 'astral_a_b', W1_DURATION, W1_MAX_STACKS_COUNT, runesCount * W1_ATTRIBUTES_PER_STACK)
end

local module = {}
module.projectileHit = projectileHit

return module
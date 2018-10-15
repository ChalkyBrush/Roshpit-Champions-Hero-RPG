require('heroes/moon_ranger/init')

local function projectileHit(event)
    local ability = event.ability
    local caster = event.caster
    local duration = 0
    if caster:HasModifier("modifier_astral_glyph_1_1") then
    	duration = ASTRAL_T11_DURATION
    else
    	duration = ASTRAL_W1_DURATION
    end

    local runesCount = caster:GetRuneValue("w",1)

    if not runesCount or runesCount <= 0 then
        return
    end

    Helper.updateStackModifier(caster, caster, ability, 'astral_a_b', duration, W1_MAX_STACKS_COUNT, runesCount * W1_ATTRIBUTES_PER_STACK)
end

local module = {}
module.projectileHit = projectileHit

return module
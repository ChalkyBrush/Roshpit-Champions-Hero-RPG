require('heroes/moon_ranger/init')
local function projectileHit(event)
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local damage = event.ability.damage
    local runesCount = Runes:GetTotalRuneLevel(caster, 4, "d_b", "astral")
    if runesCount == nill or runesCount <= 0 then
        return
    end

    Helper.updateStackModier(target, caster, ability, 'astral_d_b', W4_DURATION, W4_MAX_STACKS_COUNT, runesCount)
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_COSMOS)
end

local module = {}
module.projectileHit = projectileHit
module.getPostMultiplayer = getPostMultiplayer

return module
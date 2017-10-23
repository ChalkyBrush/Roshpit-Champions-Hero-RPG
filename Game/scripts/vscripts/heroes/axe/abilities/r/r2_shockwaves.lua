local function dealDamage(caster, target, ability, initialDamage)
    local runesCount = caster.b_d_level
    if runesCount <= 0 then
        return
    end
    local damage = initialDamage * R2_AMPLIFY_PERCENT / 100 * runesCount
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

end
local module = {}
module.dealDamage = dealDamage
return module
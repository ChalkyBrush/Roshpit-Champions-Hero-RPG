local function applyDebuff(target, caster, ability)
    local stackCount = target:GetModifierStackCount("modifier_axe_rune_a_b_visible", caster)
    if stackCount == 0 then
        ability.stackLoseTimes = {}
        ability.tick = 0
    end
    ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_rune_a_b_visible", {duration = RED_GENERAL_W1_DURATION})
    target:SetModifierStackCount("modifier_axe_rune_a_b_visible", caster, stackCount + 1)
    if ability.stackLoseTimes[ability.tick + 6] == nil then
        ability.stackLoseTimes[ability.tick + 6] = 1
    else
        ability.stackLoseTimes[ability.tick + 6] = ability.stackLoseTimes[ability.tick + 6] + 1
    end
end

function think(event)
    local ability = event.ability
    local damage = ability.damage
    local target = event.target
    local caster = event.caster
    local stackCount = target:GetModifierStackCount("modifier_axe_rune_a_b_visible", caster)
    damage = damage * stackCount * caster.a_b_level * W1_DAMAGE_PERCENT/100
    Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

    if ability.stackLoseTimes[ability.tick] ~= nil then
        stackCount = stackCount - ability.stackLoseTimes[ability.tick]
        target:SetModifierStackCount("modifier_axe_rune_a_b_visible", caster, stackCount)
    end

    ability.tick = ability.tick + 1
end

local module = {}
module.applyDebuff = applyDebuff
return module
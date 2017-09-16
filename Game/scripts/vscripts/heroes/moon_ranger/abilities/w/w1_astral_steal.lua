require('heroes/moon_ranger/init')

function start(event)

    print ('testsdfsdf')
    local ability = event.ability
    print(ability.a_b_level)
    if ability.a_b_level== nill or ability.a_b_level <= 0 then
        return
    end


    local caster = event.caster
    local newStacks = math.min(caster:GetModifierStackCount("modifier_astral_a_b_visible", caster) + 1, W1_MAX_STACKS_COUNT)

    caster:RemoveModifierByName("modifier_astral_a_b_visible")
    caster:RemoveModifierByName("modifier_astral_a_b_invisible")

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_a_b_visible", {duration = W1_DURATION})
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_a_b_invisible", {duration = W1_DURATION})

    caster:SetModifierStackCount("modifier_astral_a_b_visible", caster, newStacks)
    caster:SetModifierStackCount("modifier_astral_a_b_invisible", caster, newStacks * ability.a_b_level * W1_ATTRIBUTES_PER_STACK)
end

local module = {}
module.start = start

return module
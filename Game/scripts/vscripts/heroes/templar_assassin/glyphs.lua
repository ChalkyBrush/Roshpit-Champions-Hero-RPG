require('heroes/lanaya/constants')

function t51_think(event)
    local caster = event.caster.hero
    print("t51 think")
    local ability = caster:FindModifierByName("modifier_trapper_glyph_5_1"):GetAbility()
    local modifierName = 'modifier_trapper_5_1_add_radius'
    local newStacks = math.min(caster:GetModifierStackCount(modifierName, caster) + 1, T51_MAX_STACKS_COUNT)
    ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
    caster:SetModifierStackCount(modifierName, caster, newStacks)
end
local function t51_get_radius_amplify(caster)
    local modifierName = 'modifier_trapper_5_1_add_radius'
    local stacksCount = math.max(caster:GetModifierStackCount(modifierName, caster), 0)
    caster:SetModifierStackCount(modifierName, caster, 0)
    return 1 + stacksCount * T51_RADIUS_AMPLIFY_PERCENT/100
end
local module = {}
module.t51_get_radius_amplify = t51_get_radius_amplify
return module
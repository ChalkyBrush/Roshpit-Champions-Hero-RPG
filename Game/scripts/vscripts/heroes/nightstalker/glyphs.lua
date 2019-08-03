local modifiers = {
    t71_passive = 'modifier_chernobog_glyph_t71_passive'
}
local prefix = 'glyph_'

for modifierPath, modifier in pairs(modifiers) do
    LinkLuaModifier(modifier, "heroes/nightstalker/modifiers/"..prefix..modifierPath, LUA_MODIFIER_MOTION_NONE)
end
function glyph71Add(event)
    local caster = event.caster.hero
    local ability = event.ability
    caster:AddNewModifier(caster, ability, modifiers.t71_passive, {})
end

function glyph71Remove(event)
    event.caster:RemoveModifierByName(modifiers.t71_passive)
end
local modifiers = {
    ['7_1_passive'] = 'modifier_chernobog_glyph_7_1_passive'
}
local prefix = 'glyph_'

for modifierPath, modifier in pairs(modifiers) do
    LinkLuaModifier(modifier, "heroes/nightstalker/modifiers/"..prefix..modifierPath, LUA_MODIFIER_MOTION_NONE)
end
function glyph71Add(event)
    local caster = event.caster.hero
    local ability = event.ability
    caster:AddNewModifier(caster, ability, modifiers['7_1_passive'], {})
end

function glyph71Remove(event)
    event.caster:RemoveModifierByName(modifiers['7_1_passive'])
end
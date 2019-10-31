require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_3_e_evasion_e4 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_3_e_evasion_e4

function class:GetTexture()
    return 'chernobog/chernobog_rune_e_4'
end
function class:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }
end

function class:GetModifierEvasion_Constant()
    return CHERNOBOG_E4_EVASION
end

function class:IsHidden()
    return false
end

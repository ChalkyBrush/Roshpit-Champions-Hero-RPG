require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_3_e_bonus_damage_e1= class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_3_e_bonus_damage_e1

function class:GetTexture()
    return 'chernobog/chernobog_rune_e_1'
end
function class:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end
function class:GetModifierBaseDamageOutgoing_Percentage()

    return CHERNOBOG_E1_ATT_PCT * self:GetStackCount()
end
function class:IsHidden()
    return false
end

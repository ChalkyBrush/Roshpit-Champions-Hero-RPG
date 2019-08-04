require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
require('/wallPhysics')
modifier_chernobog_1_q_path_ally_effect = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_q_path_ally_effect

function class:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end
function class:IsDebuff()
    return false
end

function class:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility().movespeed_amplify
end
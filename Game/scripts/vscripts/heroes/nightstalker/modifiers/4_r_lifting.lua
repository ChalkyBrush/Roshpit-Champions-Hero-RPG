require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_4_r_lifting = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_4_r_lifting

function class:CheckState()
    return {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    }
end

function class:IsHidden()
    return true
end

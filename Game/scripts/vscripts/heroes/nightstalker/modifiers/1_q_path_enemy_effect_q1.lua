require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
-- merged q and q1 effects
modifier_chernobog_1_q_path_enemy_effect_q1 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_q_path_enemy_effect_q1

function class:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_EXTRA_POSTMITIGATION,
    })
end
function class:IsDebuff()
    return true
end
function class:GetExtraPostmitigationAmplify(data)
    local caster = self:GetCaster()
    return caster.q1_level * CHERNOBOG_Q1_EXTRA_POSTMIT_PCT/100
end
function class:GetTexture()
    return 'chernobog/chernobog_rune_q_1'
end
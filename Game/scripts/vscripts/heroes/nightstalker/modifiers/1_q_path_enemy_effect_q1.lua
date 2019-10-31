require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
-- merged q and q1 effects
modifier_chernobog_1_q_path_enemy_effect_q1 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_q_path_enemy_effect_q1

function class:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_EXTRA_POSTMITIGATION,
    })
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function class:OnDestroy()
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function class:IsDebuff()
    return true
end
function class:GetExtraPostmitigationAmplify(data)
    return 0
end
function class:GetTexture()
    return 'chernobog/chernobog_rune_q_1'
end
require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_4_r_arcana1_demon_amp_r4 = class(npc_base_modifier, nil, npc_base_modifier)

local class = modifier_chernobog_4_r_arcana1_demon_amp_r4

function class:OnCreated()
    self:SetSpecialTypes({ MODIFIER_SPECIAL_TYPE_ELEMENTS })
end
function class:GetDemonElementAmplify(data)
    local caster = self:GetCaster()
    return caster.r4_level * CHERNOBOG_ARCANA1_R4_DEMON_AMP
end
function class:IsHidden()
    return true
end
function class:IsDebuff()
    return false
end
function class:RemoveOnDeath()
    return false
end
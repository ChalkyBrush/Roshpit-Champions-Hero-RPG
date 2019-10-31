require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_4_r_arcana1_postmit_r3 = class(npc_base_modifier, nil, npc_base_modifier)

local class = modifier_chernobog_4_r_arcana1_postmit_r3

function class:OnCreated()
    self:SetSpecialTypes({ MODIFIER_SPECIAL_TYPE_POSTMITIGATION })
end
function class:GetPostmitigationAmplify(data)
    local caster = self:GetCaster()

    if data.attacker ~= caster then
        return 0
    end
    return 0
end
function class:GetTexture()
    return 'chernobog/chernobog_rune_r_3_arcana1'
end
function class:IsDebuff()
    return false
end
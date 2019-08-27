require('/npc_abilities/base_modifier')
require('heroes/lanaya/constants')
modifier_trapper_t32_damage_reduction = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_trapper_t32_damage_reduction

function class:IsHidden()
    return false
end
function class:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_PREMITIGATION
    })
end
function class:OnRefreshed()
    self:OnCreated()
end
function class:GetPreMitigationReduce(data)
    if data.victim ~= self:GetCaster() or data.attacker == self:GetCaster() then
        return 0
    end
    return TRAPPER_T32_DAMAGE_RED
end
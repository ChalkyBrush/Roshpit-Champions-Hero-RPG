require('/npc_abilities/base_modifier')
require('heroes/lanaya/constants')
modifier_trapper_t32_main = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_trapper_t32_main
local modifierDamageReduction = 'modifier_trapper_t32_damage_reduction'
function class:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_PREMITIGATION
    })
end
function class:OnAfterPreMitigationReduce(data)
    if data.attacker ~= self:GetCaster() or data.sourceType ~= BASE_ABILITY_Q or data.damage == 0 then
        return
    end
    local modifier = data.victim:AddNewModifier(data.attacker, data.ability, modifierDamageReduction, { duration = TRAPPER_T32_DURATION })
    modifier:SetStackCount(TRAPPER_GLYPH_3_1_SHIELDS)
end
function class:IsHidden()
    return true
end

function class:RemoveOnDeath()
    return false
end
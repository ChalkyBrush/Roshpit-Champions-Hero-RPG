require('/npc_abilities/base_modifier')
require('heroes/lanaya/constants')
modifier_trapper_t31_main = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_trapper_t31_main
local modifierShields = 'modifier_trapper_t31_shields'
function class:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_PREMITIGATION
    })
end
function class:OnAfterPreMitigationReduce(data)
    if data.attacker ~= self:GetCaster() or data.sourceType ~= BASE_ABILITY_W or data.damage == 0 then
        return
    end
    local modifier = data.victim:AddNewModifier(data.attacker, data.ability, modifierShields, { duration = 8 })
    modifier:SetStackCount(TRAPPER_T31_SHIELDS)
end
function class:IsHidden()
    return true
end

function class:RemoveOnDeath()
    return false
end
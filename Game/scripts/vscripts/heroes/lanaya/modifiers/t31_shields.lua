require('/npc_abilities/base_modifier')
require("/heroes/lanaya/trapper_constants")
modifier_trapper_t31_shields = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_trapper_t31_shields

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
    local stacksCount = self:GetStackCount() - 1
    self:SetStackCount(stacksCount)
    if stacksCount == 0 then
        self:Destroy()
    end
    return 1
end
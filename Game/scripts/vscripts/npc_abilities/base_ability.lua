require('/event_bus')
npc_base_ability = class({
    element1 = RPC_ELEMENT_NONE,
    element2 = RPC_ELEMENT_NONE,
})

-- TODO: add some params for abilities for allow make
function npc_base_ability:GetRadius(baseRadius)
    return baseRadius
end
function npc_base_ability:SetLevel(level)
    local emitChange = self:GetLevel() ~= level
    local result = self.BaseClass.SetLevel(self, level)
    if emitChange then
        npc_base_ability:OnLevelChange(level)
    end
    return result
end

function npc_base_ability:OnLevelChange(level)
    return
end

function npc_base_ability:GetCooldown(level)
    return self.BaseClass.GetCooldown(self, level)
end

function npc_base_ability:GetDuration(type, baseDuration)
    if type == 'buff' then
        return Filters:GetAdjustedBuffDuration(self:GetCaster(), baseDuration)
    else
        return baseDuration
    end
end
modifier_channel_start = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_channel_start

function modifierClass:OnCreated(table)
    if IsServer() then
    	Filters:BeginRChannel(self:GetCaster())
    end
end

function modifierClass:OnRemoved()
    if IsServer() then
    	Filters:EndRChannel(self:GetCaster())
    end
end

function modifierClass:OnDestroy()
    if IsServer() then
    	Filters:EndRChannel(self:GetCaster())
    end
end

function modifierClass:IsHidden()
    return true
end

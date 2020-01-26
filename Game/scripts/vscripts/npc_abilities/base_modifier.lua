npc_base_modifier = npc_base_modifier or class({})

local class = npc_base_modifier

function class:HasSpecialTypes(types)
    self.specialTypes = self.specialTypes or {}
    for _,type in pairs(types) do
        if not self.specialTypes[type] then
            return false
        end
    end
    return true
end
function class:SetSpecialTypes(types)
    self.specialTypes = {}
    for _,type in pairs(types) do
        self.specialTypes[type] = true
    end
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function class:OnRefresh()
    if IsServer() then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end
function class:OnRemoved()
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end
function class:OnDestroy()
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function class:CheckOnDamageTaken(event)
    return event.attacker ~= self:GetParent() and event.inflictor == nil and event.damage > 0 
end

function class:GetRadius(baseRadius)
    return baseRadius
end
function class:IsDebuff()
    return false
end

function class:RemoveOnDeath()
    return false
end
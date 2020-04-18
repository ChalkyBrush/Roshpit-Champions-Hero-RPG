npc_base_modifier = npc_base_modifier or class({})

local class = npc_base_modifier

function class:HasSpecialTypes(types)
    self.specialTypes = self.specialTypes or {}
    for _,type in pairs(types) do
        if self.specialTypes[type] then
            return true
        end
    end
    return false
end
function class:SetSpecialTypes(types)
    self.specialTypes = {}
    for _,type in pairs(types) do
        self.specialTypes[type] = true
    end
    if not self:GetParent():GetUnitName() == "npc_dummy_unit" then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

function class:OnRefresh()
    if IsServer() and not self:GetParent():GetUnitName() == "npc_dummy_unit" then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end
function class:OnRemoved()
    if IsServer() and not self:GetParent():GetUnitName() == "npc_dummy_unit" then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end
function class:OnDestroy()
    if IsServer() and not self:GetParent():GetUnitName() == "npc_dummy_unit" then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
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
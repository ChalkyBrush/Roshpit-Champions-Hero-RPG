npc_base_modifier = class({})

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
end

function class:GetRadius(baseRadius)
    return baseRadius
end
function class:IsDebuff()
    return false
end
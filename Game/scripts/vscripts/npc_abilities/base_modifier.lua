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
    return IsValidEntity(event.attacker) and --Does Attacker still exist?
            event.attacker ~= self:GetParent() and --Attacker cant be unit that has the modifier
            event.inflictor == nil and --This removes the base auto attack and only allows skills and the roshpit custom auto attack
            event.damage > 0 and --Does it even deal dmg?
            event.unit == self:GetParent() --Is the unit that has the modifier really the victim?
end

function class:ParentIsAttacker(event)
    return event.attacker == self:GetParent()
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

function class:RoshpitDispellable()
    return ROSHPIT_BUFF_NO_DISPEL
end

function class:GetRoshpitParticleName()
    return false
end

function class:GetRoshpitParticleAttachPoint()
    return "attach_hitloc"
end

function class:SetRoshpitParticleControlPoints(pfx)
    return false
end

function class:CreateRoshpitModifierParticle()
    if self:GetRoshpitParticleName() then
        local ability = self:GetAbility()
        if not ability.modifier_pfx_table then
            ability.modifier_pfx_table = {}
        end
        local pfx = ability.modifier_pfx_table[self:GetName()]
        if pfx then
            ParticleManager:DestroyParticle(pfx, false)
            ParticleManager:ReleaseParticleIndex(pfx)
        end
        local pfx = ParticleManager:CreateParticle(self:GetRoshpitParticleName(), self:GetEffectAttachType(), self:GetParent())
        self:SetRoshpitParticleControlPoints(pfx)
        ability.modifier_pfx_table[self:GetName()] = pfx
    end
end

function class:DestroyRoshpitModifierParticle()
    local ability = self:GetAbility()
    if ability.modifier_pfx_table then
        local pfx = ability.modifier_pfx_table[self:GetName()]
        if pfx then
            ParticleManager:DestroyParticle(pfx, false)
            ParticleManager:ReleaseParticleIndex(pfx)
        end
    end
end
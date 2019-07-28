require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

modifier_chernobog_1_q_path_aura = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_q_path_aura

local modifiers = {
    path_effect = 'modifier_chernobog_1_q_path_effect',
}
function class:IsAura()
    return true
end
function class:IsHidden()
    return true
end
function class:OnCreated()
    local target = self:GetParent()
    self.particle = ParticleManager:CreateParticle("particles/roshpit/chernobog/charon_ground.vpcf", PATTACH_POINT_FOLLOW, target)

    --ParticleManager:SetParticleControlEnt(self.particle, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetAuraRadius(), 1, 1))
    -- Just magic
    ParticleManager:SetParticleControl(self.particle, 15, Vector(255, 255, 255))
    ParticleManager:SetParticleControl(self.particle, 16, Vector(1, 0, 0))
end
function class:OnDestroy()
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
end
function class:GetModifierAura()
    return modifiers.path_effect
end
function class:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function class:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end
function class:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function class:GetAuraRadius()
    return self:GetRadius(self:GetAbility().width)
end
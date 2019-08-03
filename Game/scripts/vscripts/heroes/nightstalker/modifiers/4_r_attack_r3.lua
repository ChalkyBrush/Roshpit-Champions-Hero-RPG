require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_4_r_attack_r3 = class(npc_base_modifier, nil, npc_base_modifier)

local class = modifier_chernobog_4_r_attack_r3

function class:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end
function class:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    if params.target == self:GetParent() then
        return
    end
    local caster = self:GetCaster()
    local target = params.target

    local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
    local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
    local radius = CHERNOBOG_R3_RADIUS

    ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
    ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
    ParticleManager:SetParticleControl(particle2, 4, Vector(22, 56, 148))
    Timers:CreateTimer(1.5, function()
        ParticleManager:DestroyParticle(particle2, false)
    end)

    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * CHERNOBOG_R3_DMG_PER_ATT * self:GetCaster().r3_level
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do
        Damage:Apply({
            victim = enemy,
            attacker = caster,
            sourceType = BASE_NONE,
            source = self:GetAbility(),
            damage = damage,
            damageType = DAMAGE_TYPE_PHYSICAL,
            elements = {
                RPC_ELEMENT_DEMON
            }
        })
    end
end
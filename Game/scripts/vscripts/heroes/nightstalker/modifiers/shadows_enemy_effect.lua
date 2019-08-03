require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
-- merged q and q1 effects
modifier_chernobog_shadows_enemy_effect = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_shadows_enemy_effect
local baseDamageDelay = 0.5
local modifierShadowsInProcession = 'modifier_chernobog_4_r_shadows_enemy_effect'

function class:OnCreated()
    local ability = self:GetAbility()
    if not IsServer() then
        return
    end
    self.thinkInterval = ability.shadowsThinkInterval
    self.damagePercent = ability.shadowsDamagePercent
    self:StartIntervalThink(self.thinkInterval)
end
function class:CanAttack()
    return not self:GetParent():HasModifier(modifierShadowsInProcession)
end
function class:OnIntervalThink()
    if not self:CanAttack() then
        return false
    end
    local target = self:GetParent()
    local caster = self:GetCaster()
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * self.damagePercent/100
    local damageDelay =  0.9 * self.thinkInterval
    local animationRate = 1 + 0.3 * (baseDamageDelay/self.thinkInterval - 1)
    local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", target, self.thinkInterval)
    ParticleManager:SetParticleControl(pfx, 1, Vector(animationRate, 0, 0))
    Timers:CreateTimer(damageDelay, function()
        EmitSoundOn("Chernobog.BC.Hit", target)
        Damage:Apply({
            attacker = caster,
            victim = target,
            source = self:GetAbility(),
            sourceType = BASE_ABILITY_E,
            damage = damage,
            damageType = DAMAGE_TYPE_MAGICAL,
            elements = {
                RPC_ELEMENT_DEMON,
                RPC_ELEMENT_SHADOW,
            },
        })
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end
function class:GetTexture()
    return 'chernobog/chernobog_rune_e_2'
end
function class:IsDebuff()
    return true
end
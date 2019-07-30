require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
-- merged q and q1 effects
modifier_chernobog_1_q_path_enemy_effect_q2 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_q_path_enemy_effect_q2

function class:IsHidden()
    return true
end
function class:IsDebuff()
    return true
end
function class:OnCreated()

    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local intervalThink = CHERNOBOG_Q2_INTERVAL_THINK /(1 + CHERNOBOG_Q4_BUFF_Q2_INTERVAL_THINK * caster.q4_level)

    if caster.q2_level > 0 then
        self:StartIntervalThink(intervalThink)
    end
end
function class:OnIntervalThink()
    local target = self:GetParent()
    local caster = self:GetCaster()
    if caster.q2_level > 0 then
        local damage = caster.q2_level * CHERNOBOG_Q2_PER_LVL * caster:GetLevel()
        if caster:HasModifier('modifier_chernobog_glyph_4_1') then
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetRadius(CHERNOBOG_GLYPH_4_1_RADIUS), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            for _,enemy in pairs(enemies) do
                self:ApplyDamage(damage, enemy)
            end
        else
            self:ApplyDamage(damage, target)
        end
    end
end
function class:ApplyDamage(damage, target)
    CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit_body_flash.vpcf", target, 2)
    Damage:Apply({
        attacker = self:GetCaster(),
        victim = target,
        source = self:GetAbility(),
        sourceType = BASE_ABILITY_Q,
        damage = damage,
        damageType = DAMAGE_TYPE_MAGICAL,
        elements = {
            RPC_ELEMENT_DEMON,
            RPC_ELEMENT_SHADOW,
        },
        isDot = true
    })
end
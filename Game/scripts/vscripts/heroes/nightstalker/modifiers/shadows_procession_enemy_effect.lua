require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
-- merged q and q1 effects
modifier_chernobog_shadows_enemy_effect = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_shadows_enemy_effect

function class:OnCreated()
    local ability = self:GetAbility()
    self.thinkInterval = ability.shadowsThinkInterval
    self.damagePercent = ability.damagePercent
    self:StartThinkInterval(self.thinkInterval)
end
function class:IsDebuff()
    return true
end
function class:GetExtraPostmitigationAmplify(data)
    local ability = self:GetAbility()
    return ability.q1_level * CHERNOBOG_Q1_EXTRA_POSTMIT_PCT/100
end
function class:GetTexture()
    return 'chernobog/chernobog_rune_q_1'
end
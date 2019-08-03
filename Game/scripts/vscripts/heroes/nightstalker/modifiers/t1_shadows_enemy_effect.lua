require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/modifiers/shadows_enemy_effect')
modifier_chernobog_t1_shadows_enemy_effect = class(modifier_chernobog_shadows_enemy_effect, nil, modifier_chernobog_shadows_enemy_effect)

local class = modifier_chernobog_t1_shadows_enemy_effect

function class:OnCreated()
    local ability = self:GetAbility()
    if not IsServer() then
        return
    end
    self.thinkInterval = ability.t1_shadowsThinkInterval
    self.damagePercent = ability.t1_shadowsDamagePercent
    self:StartIntervalThink(self.t1_thinkInterval)
end
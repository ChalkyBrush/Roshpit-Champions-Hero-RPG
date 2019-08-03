require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_4_r_procession_enemy_effect = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_4_r_procession_enemy_effect

function class:OnCreated()
    self:SetSpecialTypes({ MODIFIER_SPECIAL_TYPE_POSTMITIGATION })
end
--function class:GetEffectName()
--    return 'particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf'
--end
--function class:GetEffectAttachType()
--    return PATTACH_ABSORIGIN_FOLLOW
--end
function class:CheckState()
    return {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end
function class:GetStatusEffectName()
    return 'particles/status_fx/status_effect_faceless_chronosphere.vpcf'
end
function class:IsDebuff()
    return true
end
function class:GetPostmitigationAmplify(data)
    local caster = self:GetCaster()
    if caster ~= data.attacker then
        return
    end
    return caster.r1_level * CHERNOBOG_R1_POSTMIT
end
function class:IsHidden()
    return false
end

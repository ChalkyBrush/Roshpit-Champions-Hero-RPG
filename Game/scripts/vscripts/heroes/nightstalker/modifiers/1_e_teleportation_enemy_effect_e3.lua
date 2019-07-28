require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_1_e_teleportation_enemy_effect_e3 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_e_teleportation_enemy_effect_e3

function class:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_POSTMITIGATION,
    })
end
function class:IsDebuff()
    return true
end
function class:GetPostmitigationAmplify(data)
    local ability = self:GetAbility()

    print('test e3')
    print(ability.e3_level * CHERNOBOG_E3_POSTMIT)
    if data.attacker ~= self:GetCaster() then
        return 0
    end
    print('caster attack')
    return ability.e3_level * CHERNOBOG_E3_POSTMIT
end
function class:GetTexture()
    return 'chernobog/chernobog_rune_q_1'
end
require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_3_e_teleportation_enemy_effect_e3 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_3_e_teleportation_enemy_effect_e3

function class:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_POSTMITIGATION,
    })
end
function class:IsDebuff()
    return true
end
function class:GetPostmitigationAmplify(data)
    local caster = self:GetCaster()

    print(caster.e3_level * CHERNOBOG_E3_POSTMIT)
    if data.attacker ~= caster then
        return 0
    end
    return caster.e3_level * CHERNOBOG_E3_POSTMIT
end
function class:GetTexture()
    return 'chernobog/chernobog_rune_q_1'
end
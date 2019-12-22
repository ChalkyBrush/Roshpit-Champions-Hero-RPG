require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/modifiers/shadows_enemy_effect')
modifier_chernobog_4_r_passive = class(npc_base_modifier, nil, npc_base_modifier)

local class = modifier_chernobog_4_r_passive

local modifiers = {
    demon_amp_r4 = 'modifier_chernobog_4_r_demon_amp_r4',
}
function class:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ MODIFIER_SPECIAL_TYPE_ELEMENTS })
end
function class:IsHidden()
    return true
end
function class:RemoveOnDeath()
    return false
end
function class:GetDemonElementAmplify(data)
    local caster = self:GetCaster()
    return caster.r1_level * CHERNOBOG_R1_DEMON_AMP
end
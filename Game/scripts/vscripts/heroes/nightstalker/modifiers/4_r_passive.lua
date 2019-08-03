require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/modifiers/shadows_enemy_effect')
modifier_chernobog_4_r_passive = class(npc_base_modifier, nil, npc_base_modifier)

local class = modifier_chernobog_4_r_passive

local modifiers = {
    demon_amp_r4 = 'modifier_chernobog_4_r_demon_amp_r4',
}
function class:OnRuneR4CountUpdate(data)
    local caster = self:GetCaster()
    if data.count > 0 and not self.added then
        caster:AddNewModifier(caster, self, modifiers.demon_amp_r4, {})
    elseif data.count == 0 and self.added then
        self:OnDestroy()
    end
    self.added = data.count > 0
end
function class:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetCaster():RemoveModifierByName(modifiers.demon_amp_r4)
end
function class:IsHidden()
    return true
end
function class:RemoveOnDeath()
    return false
end
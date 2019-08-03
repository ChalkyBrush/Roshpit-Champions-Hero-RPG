require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/modifiers/shadows_enemy_effect')
modifier_chernobog_3_e_passive = class(npc_base_modifier, nil, npc_base_modifier)

local modifiers = {
    bonus_damage_e1 = 'modifier_chernobog_3_e_bonus_damage_e1',
    movespeed = 'modifier_chernobog_3_e_movespeed'
}
local class = modifier_chernobog_3_e_passive

function class:OnRuneE1CountUpdate(data)
    local caster = self:GetCaster()
    if data.count > 0 and not self.added then
        local modifier = caster:AddNewModifier(caster, self, modifiers.bonus_damage_e1, {})
        modifier:SetStackCount(caster.e1_level)
    elseif data.count == 0 and self.added then
        self:OnDestroy()
    end
    self.added = data.count > 0
end
function class:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetCaster():RemoveModifierByName(modifiers.bonus_damage_e1)
end
function class:IsHidden()
    return true
end
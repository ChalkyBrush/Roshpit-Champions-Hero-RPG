require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

modifier_chernobog_1_q_path_effect = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_q_path_effect

local modifiers = {
    path_creator_effect_q3 = 'modifier_chernobog_1_q_path_creator_effect_q3',
    path_enemy_effect = 'modifier_chernobog_1_q_path_enemy_effect',
    path_enemy_effect_q1 = 'modifier_chernobog_1_q_path_enemy_effect_q1',
    path_enemy_effect_q2 = 'modifier_chernobog_1_q_path_enemy_effect_q2',
    path_ally_effect = 'modifier_chernobog_1_q_path_ally_effect',
}

function class:OnCreated()
    if not IsServer() then
        return
    end
    local target = self:GetParent()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    if target:GetName() == 'dummy_unit_vulnerable' then
        return
    end
    if not IsValidEntity(target) or target:IsNull() or caster:IsNull() or target.dummy or target:GetTeamNumber() == nil or caster:GetTeamNumber() == nil then
        return
    end
    if ability.q3_level == nil then
             return
    end

    if caster == target then
        if ability.q3_level > 0  then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_c_a", {})
            caster:SetModifierStackCount("modifier_charons_claw_c_a", caster, ability.q3_level)
        end
    end

    if caster:GetTeamNumber() == target:GetTeamNumber() then
        target:AddNewModifier(caster, ability,  modifiers.path_ally_effect, {})
    else
        target:AddNewModifier(caster, ability,  modifiers.path_enemy_effect, {})
        if ability.q1_level > 0 then
            target:AddNewModifier(caster, ability,  modifiers.path_enemy_effect_q1, {})
        end
        if ability.q2_level > 0 then
            target:AddNewModifier(caster, ability,  modifiers.path_enemy_effect_q2, {})
        end
    end
end
function class:IsHidden()
    return true
end
function class:OnDestroy()
    if not IsServer() then
        return
    end
    local target = self:GetParent()
    local caster = self:GetCaster()
    if not IsValidEntity(target) or target:IsNull() or caster:IsNull() or target.dummy or target:GetTeamNumber() == nil or caster:GetTeamNumber() == nil then
        return
    end
    target:RemoveModifierByName(modifiers.path_ally_effect)
    target:RemoveModifierByName(modifiers.path_enemy_effect)
    target:RemoveModifierByName(modifiers.path_enemy_effect_q1)
    target:RemoveModifierByName(modifiers.path_enemy_effect_q2)
    target:RemoveModifierByName(modifiers.path_creator_effect_q3)
    target:RemoveModifierByName('modifier_charons_claw_c_a')
end
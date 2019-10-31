require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
-- merged q and q1 effects
modifier_chernobog_1_q_path_enemy_effect = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_q_path_enemy_effect

function class:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end
function class:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_PREMITIGATION,
        MODIFIER_SPECIAL_TYPE_EXTRA_POSTMITIGATION,
    })
    if IsServer() then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

function class:OnDestroy()
    if IsServer() then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

function class:IsDebuff()
    return true
end
function class:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility().damage_and_movespeed_reduction
end
function class:GetPremitigationReduce()
    return 0
end
function class:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetAbility().damage_and_movespeed_reduction
end

function class:GetTexture()
    return 'chernobog/chernobog_rune_q_1'
end
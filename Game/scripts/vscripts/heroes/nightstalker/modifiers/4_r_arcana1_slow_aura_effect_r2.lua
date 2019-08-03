require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

modifier_chernobog_4_r_arcana1_slow_aura_effect_r2 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_4_r_arcana1_slow_aura_effect_r2

function class:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end
function class:OnCreated()
    Util.Ability:WithCasterRunesOnClient(self:GetCaster(), function()
        return nil
    end)
end
function class:GetModifierAttackSpeedBonus_Constant()
    return -CHERNOBOG_ARCANA1_R2_ATT_SLOW * self:GetCaster().r2_level
end
function class:GetModifierMoveSpeedBonus_Constant()
    return -CHERNOBOG_ARCANA1_R2_MS_SLOW * self:GetCaster().r2_level
end
function class:GetTexture()
    return 'chernobog/chernobog_rune_r_2_arcana1'
end
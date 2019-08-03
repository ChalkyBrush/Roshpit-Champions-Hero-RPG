require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

modifier_chernobog_4_r_arcana1_slow_aura_r2 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_4_r_arcana1_slow_aura_r2

local modifiers = {
    enemyEffect = 'modifier_chernobog_4_r_arcana1_slow_aura_effect_r2',
    t2glyph = 'modifier_chernobog_glyph_2_1'
}
function class:IsAura()
    return true
end
function class:IsHidden()
    return true
end
function class:OnCreated()
    self.radius = CHERNOBOG_ARCANA1_R2_RADIUS
    if self:GetCaster():HasModifier(modifiers.t2glyph) then
        self.radius = self.radius * CHERNOBOG_T21_RADIUS_AMP
    end
    self.radius = self:GetRadius(self.radius)
end
function class:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end
function class:GetModifierAura()
    return modifiers.enemyEffect
end
function class:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function class:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function class:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
function class:GetAuraRadius()
    return self.radius
end
function class:GetEffectName()
    if self:GetCaster():HasModifier(modifiers.t2glyph) then
        return 'particles/roshpit/chernobog/glyphed_demon_form_slow_aura_spell_bloodbath_bubbles_.vpcf'
    else
        return 'particles/roshpit/chernobog/demon_form_slow_aura_spell_bloodbath_bubbles_.vpcf'
    end
end
function class:GetEffectAttachType()
    return 'attach_origin'
end
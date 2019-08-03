require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
-- merged q and q1 effects
modifier_chernobog_glyph_t71_passive = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_glyph_t71_passive

function class:OnCreated()
    if not IsServer() then
        return
    end
    self.postmitigation_active_until = 0
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_POSTMITIGATION,
    })
    self:StartIntervalThink(CHERNOBOG_T71_CD_CLEANSE)
end
function class:OnIntervalThink()
    local caster = self:GetCaster()
    if caster:IsStunned() then
        Filters:CleanseStuns(caster)
        self.postmitigation_active_until = GameRules:GetGameTime() + CHERNOBOG_T71_POSTMIT_DUR
    end
end
function class:IsDebuff()
    return false
end
function class:GetPostmitigationAmplify(data)
    if self.postmitigation_active_until <= GameRules:GetGameTime() then
        return CHERNOBOG_T71_POSTMIT
    end
end
function class:IsHidden()
    return true
end
function class:RemoveOnDeath()
    return false
end
require('heroes/juggernaut/seinaru_constants')
modifier_seinaru_glyph_t21_movespeed_cap = class({})

function modifier_seinaru_glyph_t21_movespeed_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }

    return funcs
end

function modifier_seinaru_glyph_t21_movespeed_cap:OnCreated(table)
    self:StartIntervalThink(1)
end
function modifier_seinaru_glyph_t21_movespeed_cap:OnIntervalThink()
    self:ForceRefresh()
end

function modifier_seinaru_glyph_t21_movespeed_cap:GetModifierMoveSpeed_Max(params)
    local caster = self:GetCaster()
    local q2_level = caster:GetRuneValue("q", 2)
    local cap = 550 + q2_level * SEINARU_GLYPH2_MOVESPEED_CAP_PER_Q2
    buff_owner = self:GetParent()
    cap = Filters:GetAdjustedMaxMovespeed(cap, buff_owner)
    return cap
end

function modifier_seinaru_glyph_t21_movespeed_cap:IsHidden()
    return true
end

function modifier_seinaru_glyph_t21_movespeed_cap:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

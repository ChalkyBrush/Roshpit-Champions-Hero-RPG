require('heroes/juggernaut/seinaru_constants')
modifier_seinaru_glyph_t21_movespeed_cap = class({})

function modifier_seinaru_glyph_t21_movespeed_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_seinaru_glyph_t21_movespeed_cap:OnCreated( table )
    self:StartIntervalThink(1)
end
function modifier_seinaru_glyph_t21_movespeed_cap:OnIntervalThink()
    self:ForceRefresh()
end

function modifier_seinaru_glyph_t21_movespeed_cap:GetModifierMoveSpeed_Max( params )
    local caster = self:GetCaster()
    local q2_level = caster:GetRuneValue("q", 2)
    return 550 + q2_level * SEINARU_GLYPH2_MOVESPEED_CAP_PER_Q2
end

function modifier_seinaru_glyph_t21_movespeed_cap:GetModifierMoveSpeed_Limit( params )
    local caster = self:GetCaster()
    local q2_level = caster:GetRuneValue("q", 2)
    return 550 + q2_level * SEINARU_GLYPH2_MOVESPEED_CAP_PER_Q2
end

function modifier_seinaru_glyph_t21_movespeed_cap:IsHidden()
    return true
end
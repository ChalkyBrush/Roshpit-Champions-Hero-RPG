require('heroes/juggernaut/seinaru_constants')
modifier_seinaru_glyph_t21_movespeed_cap = class({})
local modifierClass = modifier_seinaru_glyph_t21_movespeed_cap

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }

    return funcs
end

function modifierClass:OnCreated()
    self:StartIntervalThink(1)
end
function modifierClass:OnIntervalThink()
    self:ForceRefresh()
end

function modifierClass:GetModifierMoveSpeed_Max_Increase()
    local caster = self:GetCaster()
    local q2_level = caster:GetRuneValue("q", 2)
    return q2_level * SEINARU_GLYPH2_MOVESPEED_CAP_PER_Q2
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

modifier_chernobog_demon_flight_attack = class({})

function modifier_chernobog_demon_flight_attack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
        -- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
    }

    return funcs
end

function modifier_chernobog_demon_flight_attack:GetModifierAttackRangeBonus(params)
    return 700
end

function modifier_chernobog_demon_flight_attack:GetModifierProjectileSpeedBonus(params)
    return 500
end

function modifier_chernobog_demon_flight_attack:GetAttackSound(params)
    return "Chernobog.DemonFlight.Attack"
end

function modifier_chernobog_demon_flight_attack:IsHidden()
    return true
end

modifier_draghor_shapeshift_bear_lua = class({})

function modifier_draghor_shapeshift_bear_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        -- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
    }

    return funcs
end

function modifier_draghor_shapeshift_bear_lua:GetAttackSound( params )
	return "Draghor.Bear.BasicAttack"
end

function modifier_draghor_shapeshift_bear_lua:IsHidden()
    return true
end
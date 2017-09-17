modifier_draghor_shapeshift_cat_lua = class({})

function modifier_draghor_shapeshift_cat_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_MODEL_CHANGE
    }

    return funcs
end

function modifier_draghor_shapeshift_cat_lua:GetAttackSound( params )
	return "Draghor.Wolf.AttackSound"
end

function modifier_draghor_shapeshift_cat_lua:GetModifierModelChange()
	local catModel = "models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl"
	local caster = self:GetParent()
	if caster:HasModifier("modifier_djanghor_immortal_weapon_1") then
		catModel = "models/items/lycan/ultimate/hunter_kings_trueform/hunter_kings_trueform.vmdl"
	end
	return catModel
end

function modifier_draghor_shapeshift_cat_lua:IsHidden()
    return true
end
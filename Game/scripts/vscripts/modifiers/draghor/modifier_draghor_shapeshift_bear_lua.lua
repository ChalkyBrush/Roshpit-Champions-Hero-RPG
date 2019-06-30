modifier_draghor_shapeshift_bear_lua = class({})

function modifier_draghor_shapeshift_bear_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_MODEL_CHANGE
	}

	return funcs
end

function modifier_draghor_shapeshift_bear_lua:GetAttackSound(params)
	return "Draghor.Bear.BasicAttack"
end

function modifier_draghor_shapeshift_bear_lua:GetModifierModelChange()
	local bearModel = "models/heroes/lone_druid/spirit_bear.vmdl"
	local caster = self:GetParent()
	if caster:HasModifier("modifier_djanghor_immortal_weapon_2") then
		bearModel = "models/items/lone_druid/bear/iron_claw_spirit_bear/iron_claw_spirit_bear.vmdl"
	end
	return bearModel
end

function modifier_draghor_shapeshift_bear_lua:IsHidden()
	return true
end

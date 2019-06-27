modifier_draghor_shapeshift_hawk_lua = class({})

function modifier_draghor_shapeshift_hawk_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MODEL_CHANGE
	}

	return funcs
end

function modifier_draghor_shapeshift_hawk_lua:GetModifierModelChange()
	local birdModel = "models/heroes/beastmaster/beastmaster_bird.vmdl"
	local caster = self:GetParent()
	if caster:HasModifier("modifier_djanghor_immortal_weapon_3") then
		birdModel = "models/items/beastmaster/hawk/beast_heart_marauder_beast_heart_marauder_raven/beast_heart_marauder_beast_heart_marauder_raven.vmdl"
	end
	return birdModel
end

function modifier_draghor_shapeshift_hawk_lua:GetModifierModelScale(params)
	return 45
end

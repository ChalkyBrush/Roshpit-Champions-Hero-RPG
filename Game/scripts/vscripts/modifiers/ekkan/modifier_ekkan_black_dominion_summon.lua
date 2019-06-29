modifier_ekkan_black_dominion_summon = class({})

function modifier_ekkan_black_dominion_summon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		-- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
	}

	return funcs
end

function modifier_ekkan_black_dominion_summon:GetModifierModelScale(params)
	return 50
end

function modifier_ekkan_black_dominion_summon:GetModifierBaseAttackTimeConstant(params)
	-- return 0.5
end

-- function modifier_chernobog_demonform_lua:GetModifierAttackPointConstant( params )
-- return -0.1
-- end

function modifier_ekkan_black_dominion_summon:IsHidden()
	return true
end

modifier_omniro_chrono_path_lua = class({})

function modifier_omniro_chrono_path_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
	}
	return funcs
end

function modifier_omniro_chrono_path_lua:GetModifierIgnoreMovespeedLimit(params)
	return 1
end

function modifier_omniro_chrono_path_lua:GetModifierMoveSpeed_AbsoluteMin(params)
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("min_movespeed")
end

function modifier_omniro_chrono_path_lua:IsHidden()
	return false
end

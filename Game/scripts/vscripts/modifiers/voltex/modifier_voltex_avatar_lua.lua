modifier_voltex_avatar_lua = class({})

function modifier_voltex_avatar_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function modifier_voltex_avatar_lua:GetAttackSound(params)
	return "Voltex.AvatarAttackSound"
end

function modifier_voltex_avatar_lua:IsHidden()
	return true
end

modifier_jex_cosmic_surge_lua = class({})

function modifier_jex_cosmic_surge_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
    }
    return funcs
end

function modifier_jex_cosmic_surge_lua:GetModifierIgnoreMovespeedLimit( params )
    return 1
end

function modifier_jex_cosmic_surge_lua:GetModifierMoveSpeed_AbsoluteMin( params )
	local ability = self:GetAbility()
	if ability.tech_level then
		return ability.tech_level*25 + 400
	else
		return 400
    end
end



function modifier_jex_cosmic_surge_lua:IsHidden()
    return true
end
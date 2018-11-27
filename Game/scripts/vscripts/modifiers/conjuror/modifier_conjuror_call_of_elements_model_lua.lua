modifier_conjuror_call_of_elements_model_lua = class({})

function modifier_conjuror_call_of_elements_model_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE
    }

    return funcs
end

function modifier_conjuror_call_of_elements_model_lua:GetModifierModelScale( params )
	local size = 20
	local ability = self:GetAbility()
	if ability then
		if ability.calls == 2 then
			size = 30
		elseif ability.calls == 3 then
			size = 40
		end
	end
	return size
end

function modifier_conjuror_call_of_elements_model_lua:IsHidden()
    return true
end
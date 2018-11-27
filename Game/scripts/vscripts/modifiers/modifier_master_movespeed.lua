modifier_master_movespeed = class({})

function modifier_master_movespeed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
    }
    return funcs
end

function modifier_master_movespeed:GetModifierIgnoreMovespeedLimit( params )
    return 1
end

function modifier_master_movespeed:GetModifierMoveSpeed_AbsoluteMin( params )
	local target = self:GetParent()
	if target.master_move_speed then
		return target.master_move_speed
	else
		return 100
    end
end



function modifier_master_movespeed:IsHidden()
    return true
end
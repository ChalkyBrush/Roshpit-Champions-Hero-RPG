require('/items/constants/boots')

modifier_crystalline_slippers_emerald = class({})

function modifier_crystalline_slippers_emerald:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end

function modifier_crystalline_slippers_emerald:GetModifierEvasion_Constant(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    if self:GetAbility().immobile then
    	return 0
    else
    	return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_CRYSTALLINE_SLIPPERS_GEM_EMERALD1)
    end
end

function modifier_crystalline_slippers_emerald:IsHidden()
    return true
end

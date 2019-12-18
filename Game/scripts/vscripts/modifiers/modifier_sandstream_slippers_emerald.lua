require('/items/constants/boots')

modifier_sandstream_slippers_emerald = class({})

function modifier_sandstream_slippers_emerald:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_sandstream_slippers_emerald:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_SANDSTREAM_SLIPPERS_GEM_EMERALD1)
end

function modifier_sandstream_slippers_emerald:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_SANDSTREAM_SLIPPERS_GEM_EMERALD2)
end


function modifier_sandstream_slippers_emerald:IsHidden()
    return true
end

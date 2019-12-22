require('/items/constants/boots')

modifier_bloodstone_boot_amethyst = class({})

function modifier_bloodstone_boot_amethyst:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_bloodstone_boot_amethyst:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLOODSTONE_BOOTS_GEM_AMETHYST1)
end

function modifier_bloodstone_boot_amethyst:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLOODSTONE_BOOTS_GEM_AMETHYST2)
end


function modifier_bloodstone_boot_amethyst:IsHidden()
    return true
end

require('/items/constants/boots')

modifier_sonic_boot_base = class({})

function modifier_sonic_boot_base:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_sonic_boot_base:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return ITEM_RPC_SONIC_BOOTS_MOVESPEED + unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_SONIC_BOOTS_GEM_EMERALD)
end

function modifier_sonic_boot_base:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return ITEM_RPC_SONIC_BOOTS_MAX_MOVESPEED + unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SONIC_BOOTS_GEM_SAPPHIRE)
end

function modifier_sonic_boot_base:GetModifierAttackSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    -- return ITEM_RPC_SONIC_BOOTS_ATTACK_SPEED + unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SONIC_BOOTS_GEM_RUBY)
    return 0
end

function modifier_sonic_boot_base:GetModifierBaseDamageOutgoing_Percentage(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    -- return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SONIC_BOOTS_GEM_AMETHYST)
    return 0
end

function modifier_sonic_boot_base:IsHidden()
    return true
end

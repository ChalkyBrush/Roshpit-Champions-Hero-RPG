require('/items/constants/boots')

modifier_voyager_boots_emerald = class({})

function modifier_voyager_boots_emerald:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_voyager_boots_emerald:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    local ability = self:GetAbility()
    return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VOYAGER_BOOTS_GEM_EMERALD)*ability.abilities_on_cd
end

function modifier_voyager_boots_emerald:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    local ability = self:GetAbility()
    return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VOYAGER_BOOTS_GEM_EMERALD)*ability.abilities_on_cd
end

function modifier_voyager_boots_emerald:IsHidden()
    return true
end

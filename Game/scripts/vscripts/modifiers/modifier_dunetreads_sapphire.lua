require('/items/constants/boots')
require('global_constants')

modifier_dunetreads_sapphire = class({})

function modifier_dunetreads_sapphire:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_dunetreads_sapphire:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    if unit:GetAbilityByIndex(DOTA_E_SLOT):GetCooldownTimeRemaining() == 0 then
    	return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DUNETREAD_BOOTS_GEM_SAPPHIRE)
    else
    	return 0
    end
end

function modifier_dunetreads_sapphire:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    if unit:GetAbilityByIndex(DOTA_E_SLOT):GetCooldownTimeRemaining() == 0 then
    	return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DUNETREAD_BOOTS_GEM_SAPPHIRE)
    else
    	return 0
    end
end


function modifier_dunetreads_sapphire:IsHidden()
    return true
end

function modifier_dunetreads_sapphire:RemoveOnDeath()
    return false
end
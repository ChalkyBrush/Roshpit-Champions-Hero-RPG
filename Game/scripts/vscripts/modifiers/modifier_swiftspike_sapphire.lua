require('/items/constants/gloves')

modifier_swiftspike_sapphire = class({})

function modifier_swiftspike_sapphire:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_swiftspike_sapphire:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return unit.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SWIFTSPIKE_BRACER_GEM_SAPPHIRE)
end


function modifier_swiftspike_sapphire:IsHidden()
    return true
end

require('/items/constants/helm')
require('/items/constants/chest')

modifier_vermillion_dream_lua = class({})

function modifier_vermillion_dream_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }

    return funcs
end

function modifier_vermillion_dream_lua:GetModifierCastRangeBonus(params)
    local hero = self:GetParent()
    local range = ITEM_RPC_VERMILLION_DREAM_ROBES_CAST_RANGE_INCREASE
    if IsServer() then
        range = range + hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("ruby", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_RUBY)
    end
    return range
end

function modifier_vermillion_dream_lua:IsHidden()
    return true
end

function modifier_vermillion_dream_lua:RemoveOnDeath()
    return false
end
require('/items/constants/boots')

modifier_boots_of_ashara_ruby = class({})

function modifier_boots_of_ashara_ruby:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_boots_of_ashara_ruby:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_ASHARA_GEM_RUBY)
end

function modifier_boots_of_ashara_ruby:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    return unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_ASHARA_GEM_RUBY)
end

function modifier_boots_of_ashara_ruby:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_ashara_ruby_effect")
	end
end

function modifier_boots_of_ashara_ruby:IsHidden()
    return true
end

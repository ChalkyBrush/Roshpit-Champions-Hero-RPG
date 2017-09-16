modifier_hood_of_lords_lua = class({})

function modifier_hood_of_lords_lua:OnCreated(event)
	print(self:GetParent():GetUnitName())
	-- print(self:GetCaster():GetUnitName())
	-- print(self.hero:GetUnitName())
    -- self.disable_turning = event.disable_turning == 1 and 1 or 0
    -- self.magic_immune = event.magic_immune == 1
    -- self.deniable = event.deniable == 1
end

function modifier_hood_of_lords_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
    }

    return funcs
end

function modifier_hood_of_lords_lua:GetModifierCastRangeBonus( params )
	local hero = self:GetParent()
	local range = 140
	if hero:HasModifier("modifier_vermillion_dream_lua") then
		range = range + 420
	end
    return range
end

function modifier_hood_of_lords_lua:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_hood_of_lords_lua:GetModifierCooldownReduction_Constant()
	return 1
end

function modifier_hood_of_lords_lua:IsHidden()
    return true
end
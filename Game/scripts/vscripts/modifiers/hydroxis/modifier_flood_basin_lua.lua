modifier_flood_basin_lua = class({})

function modifier_flood_basin_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
	}

	return funcs
end

function modifier_flood_basin_lua:GetModifierCastRangeBonus(params)
	local hero = self:GetParent()
	local range = 0
	local ability = self:GetAbility()
	if IsServer() then
		range = range + ability.r_1_level * 15
		if hero:HasModifier("modifier_vermillion_dream_lua") then
			range = range + 420
		end
		if hero:HasModifier("modifier_hood_of_lords_lua") then
			range = range + 140
		end
	end
	return range
end

function modifier_flood_basin_lua:IsHidden()
	return true
end

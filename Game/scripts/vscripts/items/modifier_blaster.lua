modifier_blaster_flame_lua = class({})
modifier_blaster_wind_lua = class({})
modifier_blaster_ice_lua = class({})
modifier_blaster_hex_lua = class({})
--------------------------------------------------------------------------------
function modifier_blaster_ice_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_blaster_ice_lua:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_blaster_ice_lua:GetModifierMoveSpeedBonus_Constant()
	return 300
end
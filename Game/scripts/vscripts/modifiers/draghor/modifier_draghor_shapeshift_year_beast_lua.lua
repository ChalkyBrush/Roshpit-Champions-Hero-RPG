modifier_draghor_shapeshift_year_beast_lua = class({})

function modifier_draghor_shapeshift_year_beast_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MODEL_CHANGE
    }

    return funcs
end

function modifier_draghor_shapeshift_year_beast_lua:GetModifierModelChange()
	local beastModel = "models/creeps/nian/nian_creep.vmdl"
	local caster = self:GetParent()
	-- if caster:HasModifier("modifier_djanghor_immortal_weapon_3") then
	-- 	beastModel = "models/items/beastmaster/hawk/beast_heart_marauder_beast_heart_marauder_raven/beast_heart_marauder_beast_heart_marauder_raven.vmdl"
	-- end
	return beastModel
end

function modifier_draghor_shapeshift_year_beast_lua:GetModifierModelScale( params )
    return -38
end
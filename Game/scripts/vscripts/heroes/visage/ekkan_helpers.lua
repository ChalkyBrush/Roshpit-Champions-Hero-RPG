function dominion_allowed_selfcasted_units(unitName)
	if unitName == "ekkan_familiar" or unitName == "castle_skeleton_warrior" or unitName == "ekkan_skeleton_archer" or unitName == "ekkan_skeleton_mage" then
		return true
	end
	return false
end

function change_summon_model(caster, summon)
	local unitName = summon:GetUnitName()
	if unitName == "ekkan_familiar" then
		if caster:HasModifier("modifier_ekkan_immortal_weapon_2") then
			summon:SetOriginalModel("models/creeps/bat_spitter/bat_spitter.vmdl")
			summon:SetModel("models/creeps/bat_spitter/bat_spitter.vmdl")
			if caster.equipped_gear then
				caster.equipped_gear[RPC_GEAR_SLOT_WEAPON]:ApplyDataDrivenModifier(caster.InventoryUnit, summon, "modifier_ekkan_immortal_weapon2_gargoyle", {})
			end
		end
	end
end
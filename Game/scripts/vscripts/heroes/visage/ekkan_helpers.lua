function dominion_allowed_selfcasted_units(unitName)
	if unitName == "ekkan_familiar" or unitName == "castle_skeleton_warrior" or unitName == "ekkan_skeleton_archer" or unitName == "ekkan_skeleton_mage" then
		return true
	end
	return false
end
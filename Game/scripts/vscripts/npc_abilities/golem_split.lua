function OnGolemDied(keys)
	caster = keys.caster
	location = caster:GetAbsOrigin()
	if string.find(caster:GetUnitName(), "big_mud") then
		local mud = CreateUnitByName("med_mud", location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(mud)
		mud = CreateUnitByName("med_mud", location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(mud)
	elseif string.find(caster:GetUnitName(), "med_mud") then
		local mud = CreateUnitByName("little_mud", location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(mud)
		mud = CreateUnitByName("little_mud", location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(mud)
	end
end
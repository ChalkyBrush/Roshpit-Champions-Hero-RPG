function keep_away_think(event)
	local caster = event.caster
	local ability = event.ability
	local unit = event.target
	if not unit.aggro then
		return false
	end

	local flee_hp_threshold = unit:GetKeyValue("AIFleeHPThreshold")
	if flee_hp_threshold == 0 then
		flee_hp_threshold = 100
	end
	local flee_range = unit:GetKeyValue("AIFleeRange")
	if flee_range == 0 then
		flee_range = 400
	end
	local flee_distance = unit:GetKeyValue("AIFleeDistance")
	if flee_distance == 0 then
		flee_distance = 100
	end
	if math.ceil((unit:GetHealth()/unit:GetMaxHealth())*100) <= flee_hp_threshold then
		local enemies = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, flee_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local direction = ((unit:GetAbsOrigin() - enemies[1]:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			unit:MoveToPosition(unit:GetAbsOrigin() + direction*flee_distance)
		end
	end
end
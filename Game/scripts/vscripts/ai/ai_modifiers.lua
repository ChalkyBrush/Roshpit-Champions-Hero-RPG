function keep_away_think(event)
	local caster = event.caster
	local ability = event.ability
	local unit = event.target
	if not unit.aggro then
		return false
	end

	local flee_hp_threshold = unit.ai_data["AIFleeHPThreshold"]
	if flee_hp_threshold == 0 then
		flee_hp_threshold = 100
	end
	local flee_range = unit.ai_data["AIFleeRange"]
	if flee_range == 0 then
		flee_range = 400
	end
	local flee_distance = unit.ai_data["AIFleeDistance"]
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

function fight_juke_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local unit = event.attacker
	local target = event.target
	if not unit.aggro then
		return false
	end

	local juke_distance = unit.ai_data["AIFightJukeDistance"]
	if juke_distance == 0 then
		juke_distance = 100
	end

	local juke_type = unit.ai_data["RoshpitAIFightJuke"]

	if juke_type == 1 then
		local direction = ((unit:GetAbsOrigin() - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		unit:MoveToPosition(unit:GetAbsOrigin() + direction*juke_distance)
	elseif juke_type == 2 then
		unit:MoveToPosition(unit:GetAbsOrigin() + RandomVector(1)*juke_distance)
	end
end

function ai_death_sound(event)
	local caster = event.caster
	local ability = event.ability
	local unit = event.unit
	EmitSoundOn(unit.ai_data["RoshpitDeathSound"], unit)
end

function ai_climb_think(event)
	local unit = event.target

	local caster = event.caster
	local ability = event.ability

	unit:SetAbsOrigin(unit:GetAbsOrigin()+unit.crawlVector)
	local distance_from_ground = unit:GetDistanceFromGround()
	if distance_from_ground < 30 and distance_from_ground > -30 then
		unit:RemoveModifierByName("ai_crawling_enter")
		unit:SetAngles(0, 0, 0)
		FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
		Dungeons:AggroUnit(unit)
	end
end
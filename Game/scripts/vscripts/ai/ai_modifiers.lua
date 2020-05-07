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
	local end_crawl = false
	if distance_from_ground < 30 and distance_from_ground > -30 then
		end_crawl = true
		if unit.crawl_end_pfx then
			CustomAbilities:QuickParticleAtPoint(unit.crawl_end_pfx, unit:GetAbsOrigin(), 4)
			unit.crawl_end_pfx = nil
		end
		if unit.crawl_end_sound then
			EmitSoundOn(unit.crawl_end_sound, unit)
			unit.crawl_end_sound = nil
		end
		if unit.extra_crawl_distance then
			end_crawl = false
		end
	end
	if unit.extra_crawl_distance then
		if (distance_from_ground - unit.extra_crawl_distance) < 30 and (distance_from_ground - unit.extra_crawl_distance) > -30 then
			end_crawl = true
		end
	end
	if end_crawl then
		unit:RemoveModifierByName("ai_crawling_enter")
		unit:SetAngles(0, 0, 0)
		FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
		Dungeons:AggroUnit(unit)
	end
end

function ai_loot_table_drop(event)
	local unit = event.unit
	print("LOOT DROP")
	if not unit.loot_table then
		return false
	end
	local percentage_mult = 1000
	for _, loot in pairs(unit.loot_table) do
		local luck = RandomInt(1, 100*percentage_mult)
		if luck <= loot["chance"]*percentage_mult then
			if loot["type"] == "immortal" then
				RPCItems:RollAndDropUniqueItem(unit, loot["item"])
			elseif loot["type"] == "special" then
				ai_loot_drop_special(unit, loot)
			end
		end
	end
end

function ai_loot_drop_special(unit, loot)
	if loot["item"] == "item_rpc_winterblight_tarot_card" then
		Winterblight:CreateCastleTarotCard(unit:GetAbsOrigin(), nil)
	end
end
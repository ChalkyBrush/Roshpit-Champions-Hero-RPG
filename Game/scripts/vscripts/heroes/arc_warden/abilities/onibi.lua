ONIBI_ELEMENT_MAX_LEVEL = 100

function load_onibi_data(caster, onibi_data)
	local jex_ability = caster:FindAbilityByName("jex_essence_harvest")
	local spawnPoint = caster:GetAbsOrigin() - caster:GetForwardVector()*100
	caster.onibi = CreateUnitByName("jex_onibi", spawnPoint, false, caster, caster, DOTA_TEAM_GOODGUYS)

	jex_ability:ApplyDataDrivenModifier(caster, caster.onibi, "modifier_jex_onibi_thinker", {})
	caster.onibi.caster = caster
	caster.onibi:SetRenderColor(20, 0, 255)
	caster.onibi:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	caster.onibi:GetAbilityByIndex(0):SetLevel(1)
	caster.onibi:GetAbilityByIndex(1):SetLevel(1)
	caster.onibi.stats_table = {}
	caster.onibi.stats_table["nature"] = {}
	caster.onibi.stats_table["lightning"] = {}
	caster.onibi.stats_table["cosmic"] = {}

	caster.onibi.stats_table["nature"]["exp"] = onibi_data.nature_exp
	caster.onibi.stats_table["nature"]["points"] = onibi_data.nature_points
	caster.onibi.stats_table["lightning"]["exp"] = onibi_data.lightning_exp
	caster.onibi.stats_table["lightning"]["points"] = onibi_data.lightning_points
	caster.onibi.stats_table["cosmic"]["exp"] = onibi_data.cosmic_exp
	caster.onibi.stats_table["cosmic"]["points"] = onibi_data.cosmic_points
	
	caster.onibi.stats_table["nature"]["nature"] = {}

	caster.onibi.stats_table["nature"]["nature"]["q"] = onibi_data.nature_nature_q
	caster.onibi.stats_table["nature"]["nature"]["w"] = onibi_data.nature_nature_w
	caster.onibi.stats_table["nature"]["nature"]["e"] = onibi_data.nature_nature_e

	caster.onibi.stats_table["lightning"]["lightning"] = {}

	caster.onibi.stats_table["lightning"]["lightning"]["q"] = onibi_data.lightning_lightning_q
	caster.onibi.stats_table["lightning"]["lightning"]["w"] = onibi_data.lightning_lightning_w
	caster.onibi.stats_table["lightning"]["lightning"]["e"] = onibi_data.lightning_lightning_e

	caster.onibi.stats_table["cosmic"]["cosmic"] = {}

	caster.onibi.stats_table["cosmic"]["cosmic"]["q"] = onibi_data.cosmic_cosmic_q
	caster.onibi.stats_table["cosmic"]["cosmic"]["w"] = onibi_data.cosmic_cosmic_w
	caster.onibi.stats_table["cosmic"]["cosmic"]["e"] = onibi_data.cosmic_cosmic_e

	caster.onibi.stats_table["nature"]["lightning"] = {}

	caster.onibi.stats_table["nature"]["lightning"]["q"] = onibi_data.nature_lightning_q
	caster.onibi.stats_table["nature"]["lightning"]["w"] = onibi_data.nature_lightning_w
	caster.onibi.stats_table["nature"]["lightning"]["e"] = onibi_data.nature_lightning_e

	caster.onibi.stats_table["nature"]["cosmic"] = {}

	caster.onibi.stats_table["nature"]["cosmic"]["q"] = onibi_data.nature_cosmic_q
	caster.onibi.stats_table["nature"]["cosmic"]["w"] = onibi_data.nature_cosmic_w
	caster.onibi.stats_table["nature"]["cosmic"]["e"] = onibi_data.nature_cosmic_e

	caster.onibi.stats_table["lightning"]["cosmic"] = {}

	caster.onibi.stats_table["lightning"]["cosmic"]["q"] = onibi_data.lightning_cosmic_q
	caster.onibi.stats_table["lightning"]["cosmic"]["w"] = onibi_data.lightning_cosmic_w
	caster.onibi.stats_table["lightning"]["cosmic"]["e"] = onibi_data.lightning_cosmic_e

	calculate_onibi_element_levels(caster.onibi)
end

function get_onibi_elements_name_table(onibi)
	return {"nature", "lightning", "cosmic"}
end

function calculate_onibi_element_levels(onibi)
	local elements_table = get_onibi_elements_name_table(onibi)
	for i = 1, #elements_table, 1 do
		local element_name = elements_table[i]
		local level = get_level_by_sum_exp(onibi.stats_table[element_name]["exp"])
		onibi.stats_table[element_name]["level"] = level
		onibi.stats_table[element_name]["current"] = onibi.stats_table[element_name]["exp"] - get_onibi_sum_exp_table(level)
		print("-----")
		print(onibi.stats_table[element_name]["exp"])
		print(onibi.stats_table[element_name]["current"])
		onibi.stats_table[element_name]["required"] = get_onibi_sum_exp_table(level+1) - get_onibi_sum_exp_table(level)
	end
	write_onibi_to_nettable(onibi)
end

function write_onibi_to_nettable(onibi)
	CustomNetTables:SetTableValue("hero_index", "onibi-"..tostring(onibi:GetEntityIndex()), onibi.stats_table)
end

function get_onibi_exp_table()
	local table = {}
	local differential = 0
	local starting_requirement = 20
	for i = 1, ONIBI_ELEMENT_MAX_LEVEL, 1 do
		local exp_value = starting_requirement + differential
		differential = differential + 50
		table[i] = exp_value
	end
	return table
end

function get_onibi_sum_exp_table(level)
	local xp_table = get_onibi_exp_table()
	local sum = 0
	for i = 0, level, 1 do
		if i > 0 then
			sum = sum + xp_table[i]
		end
	end
	return sum
end

function get_level_by_sum_exp(exp)
	local xp_table = get_onibi_exp_table()
	local sum = 0
	local level = 0
	for i = 0, ONIBI_ELEMENT_MAX_LEVEL-1, 1 do
		sum = sum + xp_table[i+1]
		if i == 100 or (sum >= exp) then
			level = i
			break
		end
	end	
	return level
end

function get_onibi_element_level_from_points(points)

end

function onibi_main_think(event)
	local onibi = event.target
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), onibi:GetAbsOrigin())
	if distance > 3000 then
		local walkToPoint = caster:GetAbsOrigin() - caster:GetForwardVector()*160
		onibi:SetAbsOrigin(walkToPoint)
		local tp_pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/jex/essence_spawn.vpcf", onibi, 2)
		ParticleManager:SetParticleControl(tp_pfx, 1, Vector(0.3, 0.9, 0.8))
	elseif distance > 420 then
		local walkToPoint = caster:GetAbsOrigin() - caster:GetForwardVector()*160
		onibi:MoveToPosition(walkToPoint)
	end
end

function onibi_activate_essence(event)
	local caster = event.caster
	local ability = event.ability
	local essence = event.essence
	local index = event.index
	-- local other_index = 2
	-- if index == 2 then
	-- 	other_index = 1
	-- end
	if essence == "nature" then
		CustomAbilities:AddAndOrSwapSkill(caster, "onibi_nature_"..index, "onibi_lightning_"..index, index-1)
	elseif essence == "lightning" then
		CustomAbilities:AddAndOrSwapSkill(caster, "onibi_lightning_"..index, "onibi_cosmic_"..index, index-1)
	elseif essence == "cosmic" then
		CustomAbilities:AddAndOrSwapSkill(caster, "onibi_cosmic_"..index, "onibi_nature_"..index, index-1)
	end
end
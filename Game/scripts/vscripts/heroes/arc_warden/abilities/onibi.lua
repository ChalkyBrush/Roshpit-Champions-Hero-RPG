ONIBI_ELEMENT_MAX_LEVEL = 100
require('heroes/arc_warden/jex_constants')
function load_onibi_data(caster, onibi_data)
	local jex_ability = caster:FindAbilityByName("jex_essence_harvest")
	local spawnPoint = caster:GetAbsOrigin() - caster:GetForwardVector()*100
	caster.onibi = CreateUnitByName("jex_onibi", spawnPoint, false, caster, caster, caster:GetTeamNumber())

	jex_ability:ApplyDataDrivenModifier(caster, caster.onibi, "modifier_jex_onibi_thinker", {})
	caster.onibi.caster = caster
	caster.onibi:SetRenderColor(20, 0, 255)
	caster.onibi:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	caster.onibi:GetAbilityByIndex(0):SetLevel(1)
	caster.onibi:GetAbilityByIndex(1):SetLevel(1)
	caster.onibi:GetAbilityByIndex(2):SetLevel(1)
	caster.onibi:GetAbilityByIndex(3):SetLevel(1)
	caster.onibi:GetAbilityByIndex(4):SetLevel(1)
	caster.onibi.stats_table = {}
	local elements_table = all_possible_onibi_elements(caster.onibi)
	local ability_keys = {"Q", "W", "E"}
	for i = 1, #elements_table, 1 do
		local element1 = elements_table[i]
		caster.onibi.stats_table[element1] = {}
		for j = 1, #elements_table, 1 do
			local element2 = elements_table[j]
			caster.onibi.stats_table[element1][element2] = {}
			for k = 1, #ability_keys, 1 do
				local ability_key = ability_keys[k]
				caster.onibi.stats_table[element1][element2][ability_key] = {}
				print(element1.." : "..element2.." - "..ability_key)
			end
		end
	end

	if onibi_data["modules"]["nature"] then
		caster.onibi.stats_table["nature"]["exp"] = onibi_data["modules"]["nature"]["exp"]
	else
		caster.onibi.stats_table["nature"]["exp"] = 0
	end
	if onibi_data["modules"]["lightning"] then
		caster.onibi.stats_table["lightning"]["exp"] = onibi_data["modules"]["lightning"]["exp"]
	else
		caster.onibi.stats_table["lightning"]["exp"] = 0
	end
	if onibi_data["modules"]["fire"] then
		caster.onibi.stats_table["fire"]["exp"] = onibi_data["modules"]["fire"]["exp"]
	else
		caster.onibi.stats_table["fire"]["exp"] = 0
	end
	if onibi_data["modules"]["cosmic"] then
		caster.onibi.stats_table["cosmic"]["exp"] = onibi_data["modules"]["cosmic"]["exp"]
	else
		caster.onibi.stats_table["cosmic"]["exp"] = 0
	end
	caster.onibi.current_model_index = 0

	onibi_initial_set_abilities_data(caster.onibi, onibi_data)


	calculate_onibi_element_levels(caster.onibi)
end

function all_possible_onibi_elements(onibi)
	return {"nature", "lightning", "fire", "cosmic"}
end

function get_onibi_elements_name_table(onibi)
	local element_table = {}
	table.insert(element_table, "nature")
	if onibi.caster:HasModifier("modifier_jex_arcana1") then
		table.insert(element_table, "fire")
	else
		table.insert(element_table, "lightning")
	end
	table.insert(element_table, "cosmic")
	return element_table
end

function get_other_elements(onibi, element)
	local elements_table = get_onibi_elements_name_table(onibi)
	local other_elements = {}
	for i = 1, #elements_table, 1 do
		if elements_table[i] == element then
		else
			table.insert(other_elements, elements_table[i])
		end
	end
	return other_elements
end

function calculate_onibi_element_levels(onibi)
	local elements_table = get_onibi_elements_name_table(onibi)
	for i = 1, #elements_table, 1 do
		local element_name = elements_table[i]
		local level = get_level_by_sum_exp(onibi.stats_table[element_name]["exp"])
		onibi.stats_table[element_name]["level"] = level
		onibi.stats_table[element_name]["current"] = onibi.stats_table[element_name]["exp"] - get_onibi_sum_exp_table(level)
		onibi.stats_table[element_name]["required"] = get_onibi_sum_exp_table(level+1) - get_onibi_sum_exp_table(level)
	end
	onibi_calculate_all_tech_points(onibi)
	write_onibi_to_nettable(onibi)
	set_onibi_model(onibi)
end

function write_onibi_to_nettable(onibi)
	CustomNetTables:SetTableValue("hero_index", "onibi-"..tostring(onibi:GetEntityIndex()), onibi.stats_table)
end

function set_onibi_model(onibi)
	local elements_table = get_onibi_elements_name_table(onibi)
	local available_models = {"00", "01", "02", "03", "05", "06", "07", "09", "10", "11", "12", "13", "15", "16", "19", "20"}
	-- 16 models
	local sum_level = 0
	for i = 1, #elements_table, 1 do
		sum_level = sum_level + onibi.stats_table[elements_table[i]]["level"]
	end
	local model_index = math.ceil(sum_level/18.75)
	local model_string = available_models[model_index]
	if onibi.current_model_index == model_index then
	else
		onibi.current_model_index = model_index
		local modelName = "models/items/courier/onibi_lvl_"..model_string.."/onibi_lvl_"..model_string.."_flying.vmdl"
		print(modelName)
		PrecacheModel(modelName, {})
		Timers:CreateTimer(1, function()
			onibi:SetOriginalModel(modelName)
			onibi:SetModel(modelName)
			local invokePFX = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", onibi, 4)
			ParticleManager:SetParticleControl(invokePFX, 1, Vector(10, 10, 100))
		end)
	end
end

function unviable_element_pairs()
	local unviable_pairs = {}
	table.insert(unviable_pairs, {"fire", "lightning"})
	return unviable_pairs
end

function onibi_initial_set_abilities_data(onibi, data_from_server)
	if not onibi.stats_table.abilities then
		onibi.stats_table.abilities = {}
	end
	local elements_table = all_possible_onibi_elements(onibi)
	local ability_keys = {"Q", "W", "E"}
	for i = 1, #elements_table, 1 do
		local element_tech_used
		local element1 = elements_table[i]
		-- local other_elements = get_other_elements(onibi, element1)
		local tech_points_spent = 0
		for k = 1, #elements_table, 1 do
			for j = 1, #ability_keys, 1 do
				local ability_key = ability_keys[j]
				local element2 = elements_table[k]
				local process = true
				local unviable_pairs = unviable_element_pairs()
				for qw = 1, #unviable_pairs, 1 do
					local unviable_pair = unviable_pairs[qw]
					if (element1 == unviable_pair[1] and element2 == unviable_pair[2]) or (element1 == unviable_pair[2] and element2 == unviable_pair[1]) then
						process = false
					end
				end
				if process then
					local level = 0
					local tech_data = nil
					if #data_from_server["techs"] > 0 then
						for i = 1, #data_from_server["techs"], 1 do
							local tech_from_server = data_from_server["techs"][i]
							if (tech_from_server["element1"] == element1 and tech_from_server["element2"] == element2) or (tech_from_server["element1"] == element2 and tech_from_server["element2"] == element1) then
								tech_data = tech_from_server
								break
							end
						end
						if tech_data then
							if ability_key == "Q" then
								level = tech_data["q_level"]
							elseif ability_key == "W" then
								level = tech_data["w_level"]
							elseif ability_key == "E" then
								level = tech_data["e_level"]
							end
						end
					end
					if not level then
						level = 0
					end
					onibi.stats_table[element1][element2][ability_key]["name"] = get_ability_name_by_element_combination_and_key(element1, element2, ability_key)
					onibi.stats_table[element2][element1][ability_key]["name"] = get_ability_name_by_element_combination_and_key(element1, element2, ability_key)
					onibi.stats_table[element1][element2][ability_key]["level"] = level
					onibi.stats_table[element2][element1][ability_key]["level"] = level
					onibi.stats_table[element1][element2][ability_key]["bonus_level"] = 0
					onibi.stats_table[element2][element1][ability_key]["bonus_level"] = 0
					tech_points_spent = tech_points_spent + total_tech_used_on_ability(element1, element2, ability_key, level)
				end
			end
		end
		local element_level = get_level_by_sum_exp(onibi.stats_table[element1]["exp"])
		tech_points_spent = tech_points_spent/2
		local tech_available = tech_points_earned_for_element(element1, element_level) - tech_points_spent
		onibi.stats_table[element1]["tech"] = tech_available
	end

	local immortal_weapon_equip_table = {}
	immortal_weapon_equip_table.target = onibi.caster
	jex_equip_immortal_weapon(immortal_weapon_equip_table)
end

function tech_points_earned_for_element(element, level)
	return level*3
end

function tech_points_available_for_element(element, level)
end

function total_tech_used_on_ability(element1, element2, ability_key, level)
	local mult = 1
	if element1 == element2 then
		mult = 2
	end
	return (level*(level + 1))*mult
end

function get_ability_tech_up_cost(ability_level, mult)
	return (ability_level + 1)*mult
end

function onibi_calculate_all_tech_points(onibi)
	local elements_table = get_onibi_elements_name_table(onibi)
	local ability_keys = {"Q", "W", "E"}
	for i = 1, #elements_table, 1 do
		local element_tech_used
		local element1 = elements_table[i]
		-- local other_elements = get_other_elements(onibi, element1)
		local tech_points_spent = 0
		for k = 1, #elements_table, 1 do
			for j = 1, #ability_keys, 1 do
				local ability_key = ability_keys[j]
				local element2 = elements_table[k]
				local level = onibi.stats_table[element1][element2][ability_key]["level"]
				tech_points_spent = tech_points_spent + total_tech_used_on_ability(element1, element2, ability_key, level)
			end
		end
		local element_level = get_level_by_sum_exp(onibi.stats_table[element1]["exp"])
		tech_points_spent = tech_points_spent/2
		local tech_available = tech_points_earned_for_element(element1, element_level) - tech_points_spent
		onibi.stats_table[element1]["tech"] = tech_available
	end
end

function get_ability_name_by_element_combination_and_key(element1, element2, ability_key)
	local ability_name = "abilname"
	if ability_key == "Q" then
		if element1 == "nature" and element2 == "nature" then
			ability_name = "jex_nature_nature_q"
		elseif (element1 == "nature" and element2 == "lightning") or (element1 == "lightning" and element2 == "nature") then
			ability_name = "jex_lightning_nature_q"
		elseif (element1 == "nature" and element2 == "cosmic") or (element1 == "cosmic" and element2 == "nature") then
			ability_name = "jex_cosmic_nature_q"
		elseif element1 == "lightning" and element2 == "lightning" then
			ability_name = "jex_thunder_thunder_q"
		elseif (element1 == "lightning" and element2 == "cosmic") or (element1 == "cosmic" and element2 == "lightning") then
			ability_name = "jex_lightning_cosmic_q"
		elseif element1 == "cosmic" and element2 == "cosmic" then
			ability_name = "jex_cosmic_cosmic_q"
		elseif element1 == "fire" and element2 == "fire" then
			ability_name = "jex_fire_fire_q"
		elseif (element1 == "fire" and element2 == "cosmic") or (element1 == "cosmic" and element2 == "fire") then
			ability_name = "jex_fire_cosmic_q"
		elseif (element1 == "fire" and element2 == "nature") or (element1 == "nature" and element2 == "fire") then
			ability_name = "jex_nature_fire_q"
		end
	elseif ability_key == "W" then
		if element1 == "nature" and element2 == "nature" then
			ability_name = "jex_nature_nature_w"
		elseif (element1 == "nature" and element2 == "lightning") or (element1 == "lightning" and element2 == "nature") then
			ability_name = "jex_lightning_nature_w"
		elseif (element1 == "nature" and element2 == "cosmic") or (element1 == "cosmic" and element2 == "nature") then
			ability_name = "jex_nature_cosmic_w"
		elseif element1 == "lightning" and element2 == "lightning" then
			ability_name = "jex_lightning_lightning_w"
		elseif (element1 == "lightning" and element2 == "cosmic") or (element1 == "cosmic" and element2 == "lightning") then
			ability_name = "jex_lightning_cosmic_w"
		elseif element1 == "cosmic" and element2 == "cosmic" then
			ability_name = "jex_cosmic_cosmic_w"
		elseif element1 == "fire" and element2 == "fire" then
			ability_name = "jex_fire_fire_w"
		elseif (element1 == "nature" and element2 == "fire") or (element1 == "fire" and element2 == "nature") then
			ability_name = "jex_nature_fire_w"
		elseif (element1 == "cosmic" and element2 == "fire") or (element1 == "fire" and element2 == "cosmic") then
			ability_name = "jex_fire_cosmic_w"
		elseif element1 == "fire" and element2 == "fire" then
			ability_name = "jex_fire_fire_w"
		end
	elseif ability_key == "E" then
		if element1 == "nature" and element2 == "nature" then
			ability_name = "jex_nature_nature_e"
		elseif (element1 == "nature" and element2 == "lightning") or (element1 == "lightning" and element2 == "nature") then
			ability_name = "jex_lightning_nature_e"
		elseif (element1 == "nature" and element2 == "cosmic") or (element1 == "cosmic" and element2 == "nature") then
			ability_name = "jex_nature_cosmic_e"
		elseif element1 == "lightning" and element2 == "lightning" then
			ability_name = "jex_lightning_lightning_e"
		elseif (element1 == "lightning" and element2 == "cosmic") or (element1 == "cosmic" and element2 == "lightning") then
			ability_name = "jex_lightning_cosmic_e"
		elseif element1 == "cosmic" and element2 == "cosmic" then
			ability_name = "jex_cosmic_cosmic_e"
		elseif element1 == "fire" and element2 == "fire" then
			ability_name = "jex_fire_fire_e"
		elseif (element1 == "nature" and element2 == "fire") or (element1 == "fire" and element2 == "nature") then
			ability_name = "jex_nature_fire_e"
		elseif (element1 == "fire" and element2 == "cosmic") or (element1 == "cosmic" and element2 == "fire") then
			ability_name = "jex_fire_cosmic_e"
		end


	end
	return ability_name
end

function get_onibi_exp_table()
	local table = {}
	local differential = 0
	local starting_requirement = 20
	for i = 1, ONIBI_ELEMENT_MAX_LEVEL, 1 do
		local exp_value = starting_requirement + differential
		differential = differential + 80*i
		table[i] = exp_value
	end
	return table
end

function get_onibi_sum_exp_table(level)
	local xp_table = get_onibi_exp_table()
	local sum = 0
	level = math.min(level, ONIBI_ELEMENT_MAX_LEVEL)
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
		if ((i == ONIBI_ELEMENT_MAX_LEVEL-1) and (exp >= sum)) then
			level = 100
			break
		elseif (sum > exp) then
			level = i
			break
		end
	end	
	return level
end

function onibi_level_up(onibi)
	EmitSoundOn("Jex.OnibiLevelUp", onibi)
	Timers:CreateTimer(0.5, function()
		StartAnimation(onibi, {duration=3, activity=ACT_DOTA_RUN, rate=1.5, translate="haste"})
		CustomAbilities:QuickAttachParticle("particles/roshpit/jex/jex_levelup_vine_glow_trail.vpcf", onibi, 4)
	end)

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
	local jex = caster.caster
	-- local other_index = 2
	-- if index == 2 then
	-- 	other_index = 1
	-- end
	if essence == "nature" then
		if jex:HasModifier("modifier_jex_arcana1") then
			CustomAbilities:AddAndOrSwapSkill(caster, "onibi_nature_"..index, "onibi_fire_"..index, index-1)
		else
			CustomAbilities:AddAndOrSwapSkill(caster, "onibi_nature_"..index, "onibi_lightning_"..index, index-1)
		end
	elseif essence == "lightning" then
		CustomAbilities:AddAndOrSwapSkill(caster, "onibi_lightning_"..index, "onibi_cosmic_"..index, index-1)
	elseif essence == "fire" then
		CustomAbilities:AddAndOrSwapSkill(caster, "onibi_fire_"..index, "onibi_cosmic_"..index, index-1)
	elseif essence == "cosmic" then
		CustomAbilities:AddAndOrSwapSkill(caster, "onibi_cosmic_"..index, "onibi_nature_"..index, index-1)
	end
end

function onibi_activate_ability_key(event)
	local caster = event.caster
	local ability = event.ability
	local onibi = caster
	local element1 = string.gsub(caster:GetAbilityByIndex(3):GetAbilityName(), "onibi_", "")
	element1 = string.gsub(element1, '_1', "")
	local element2 = string.gsub(caster:GetAbilityByIndex(4):GetAbilityName(), "onibi_", "")
	element2 = string.gsub(element2, '_2', "")
	local ability_key = string.upper(event.ability_key)
	local ability_level = caster.stats_table[element1][element2][ability_key]["level"]
	if ability_level > 0 then
		EmitSoundOn("Jex.Invoke", caster)
		local ability_name = get_ability_name_by_element_combination_and_key(element1, element2, ability_key)
		local ability_index = convert_ability_key_into_ability_index(ability_key)
		local old_ability_name = caster.caster:GetAbilityByIndex(ability_index):GetAbilityName()
		CustomAbilities:AddAndOrSwapSkill(caster.caster, old_ability_name, ability_name, ability_index)

		local invokePFX = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", onibi.caster, 4)
		ParticleManager:SetParticleControl(invokePFX, 1, Vector(120, 180, 255))
		local invokePFX2 = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", onibi, 4)
		ParticleManager:SetParticleControl(invokePFX2, 1, Vector(120, 180, 255))
		local pfx = ParticleManager:CreateParticle("particles/roshpit/jex/essence_harvest.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 1, caster.caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		Timers:CreateTimer(0.15, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	else
		EmitSoundOn("Jex.InvokeFail", caster)
	end
end

function onibi_invoke(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- local onibi = caster
	-- local element1 = string.gsub(caster:GetAbilityByIndex(0):GetAbilityName(), "onibi_", "")
	-- element1 = string.gsub(element1, '_1', "")
	-- local element2 = string.gsub(caster:GetAbilityByIndex(1):GetAbilityName(), "onibi_", "")
	-- element2 = string.gsub(element2, '_2', "")
	-- local ability_key = string.gsub(caster:GetAbilityByIndex(2):GetAbilityName(), "onibi_", "")
	-- ability_key = string.upper(ability_key)
	-- print(element1)
	-- print(element2)
	-- print(ability_key)
	-- local ability_level = caster.stats_table[element1][element2][ability_key]["level"]
	-- if ability_level > 0 then
	-- 	EmitSoundOn("Jex.Invoke", caster)
	-- 	local ability_name = get_ability_name_by_element_combination_and_key(element1, element2, ability_key)
	-- 	local ability_index = convert_ability_key_into_ability_index(ability_key)
	-- 	local old_ability_name = caster.caster:GetAbilityByIndex(ability_index):GetAbilityName()
	-- 	CustomAbilities:AddAndOrSwapSkill(caster.caster, old_ability_name, ability_name, ability_index)

	-- 	local invokePFX = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", onibi.caster, 4)
	-- 	ParticleManager:SetParticleControl(invokePFX, 1, Vector(120, 180, 255))
	-- 	local invokePFX2 = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", onibi, 4)
	-- 	ParticleManager:SetParticleControl(invokePFX2, 1, Vector(120, 180, 255))
	-- 	local pfx = ParticleManager:CreateParticle("particles/roshpit/jex/essence_harvest.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- 	ParticleManager:SetParticleControlEnt(pfx, 1, caster.caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster.caster:GetAbsOrigin(), true)
	-- 	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	-- 	Timers:CreateTimer(0.15, function()
	-- 		ParticleManager:DestroyParticle(pfx, false)
	-- 	end)
	-- else
	-- 	EmitSoundOn("Jex.InvokeFail", caster)
	-- end
	
end

function convert_ability_key_into_ability_index(ability_key)
	if ability_key == "Q" then
		return 0
	elseif ability_key == "W" then
		return 1
	elseif ability_key == "E" then
		return 2
	end
end

function upgrade_onibi_ability(msg)
	local onibi = EntIndexToHScript(msg.onibi)
	local element1 = msg.element1
	local element2 = msg.element2
	local ability_key = msg.ability_key
	onibi_calculate_all_tech_points(onibi)
	local mult = 1
	if element1 == element2 then
		mult = 2
	end
	local cost = get_ability_tech_up_cost(onibi.stats_table[element1][element2][ability_key]["level"], mult)
	print("--")
	print("COST: "..cost)
	print(element1)
	print(element2)
	print(onibi.stats_table[element1]["tech"])
	print(onibi.stats_table[element2]["tech"])
	local player = PlayerResource:GetPlayer(onibi.caster:GetPlayerOwnerID())
	if onibi.stats_table[element1]["tech"] >= cost and onibi.stats_table[element2]["tech"] >= cost then
		onibi.stats_table[element1][element2][ability_key]["level"] = onibi.stats_table[element1][element2][ability_key]["level"] + 1
		onibi.stats_table[element2][element1][ability_key]["level"] = onibi.stats_table[element1][element2][ability_key]["level"]
		onibi_calculate_all_tech_points(onibi)
		write_onibi_to_nettable(onibi)
		CustomGameEventManager:Send_ServerToPlayer(player, "reset_onibi", {reset = true})
	end
end

function onibi_master_rune_thinker(event)
	local caster = event.caster.caster
	local onibi = event.caster
	local ability = event.ability

	local total_attack_damage_stacks = 0
	local q_1_level = caster:GetRuneValue("q", 1)
	local w_1_level = caster:GetRuneValue("w", 1)
	local e_1_level = caster:GetRuneValue("e", 1)

	local lightning_level = get_level_by_sum_exp(onibi.stats_table["lightning"]["exp"])
	local nature_level = get_level_by_sum_exp(onibi.stats_table["nature"]["exp"])
	local cosmic_level = get_level_by_sum_exp(onibi.stats_table["cosmic"]["exp"])
	local fire_level = 0
	if onibi.stats_table["fire"] then
		fire_level = get_level_by_sum_exp(onibi.stats_table["fire"]["exp"])
	end

	total_attack_damage_stacks = total_attack_damage_stacks + nature_level*q_1_level
	if caster:HasModifier("modifier_jex_arcana1") then
		total_attack_damage_stacks = total_attack_damage_stacks + fire_level*w_1_level
	else
		total_attack_damage_stacks = total_attack_damage_stacks + lightning_level*w_1_level
	end
	total_attack_damage_stacks = total_attack_damage_stacks + cosmic_level*e_1_level
	if total_attack_damage_stacks > 0 then
		ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_onibi_base_attack_damage", {})
		caster:SetModifierStackCount("modifier_onibi_base_attack_damage", onibi, total_attack_damage_stacks)
	else
		caster:RemoveModifierByName("modifier_onibi_base_attack_damage")
	end

	local total_attributes_stacks = 0
	local q_3_level = caster:GetRuneValue("q", 3)
	local w_3_level = caster:GetRuneValue("w", 3)
	local e_3_level = caster:GetRuneValue("e", 3)
	
	total_attributes_stacks = total_attributes_stacks + nature_level*q_3_level
	if caster:HasModifier("modifier_jex_arcana1") then
		total_attributes_stacks = total_attributes_stacks + fire_level*w_3_level
	else
		total_attributes_stacks = total_attributes_stacks + lightning_level*w_3_level
	end
	total_attributes_stacks = total_attributes_stacks + cosmic_level*e_3_level
	if total_attributes_stacks > 0 then
		ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_onibi_all_attributes", {})
		caster:SetModifierStackCount("modifier_onibi_all_attributes", onibi, total_attributes_stacks)
	else
		caster:RemoveModifierByName("modifier_onibi_all_attributes")
	end

	caster.q_2_level = caster:GetRuneValue("q", 2)
	caster.w_2_level = caster:GetRuneValue("w", 2)
	caster.e_2_level = caster:GetRuneValue("e", 2)

	caster.r_1_level = caster:GetRuneValue("r", 1)
	caster.r_2_level = caster:GetRuneValue("r", 2)
	caster.r_3_level = caster:GetRuneValue("r", 3)
	caster.r_4_level = caster:GetRuneValue("r", 4)
end

function jex_equip_immortal_weapon(event)
	local caster = event.target
	local onibi = caster.onibi
	local elements_table = all_possible_onibi_elements(onibi)
	local ability_keys = {"Q", "W", "E"}
	for i = 1, #elements_table, 1 do
		local element1 = elements_table[i]
		-- local other_elements = get_other_elements(onibi, element1)
		local tech_points_spent = 0
		for k = 1, #elements_table, 1 do
			for j = 1, #ability_keys, 1 do
				local ability_key = ability_keys[j]
				local element2 = elements_table[k]
				local bonus = 0
				if (element1 == "nature" or element2 == "nature") and caster:HasModifier("modifier_jex_immortal_weapon_1") then
					bonus = 1
				end
				if (element1 == "lightning" or element2 == "lightning") and caster:HasModifier("modifier_jex_immortal_weapon_2") then
					bonus = 1
				end
				if (element1 == "cosmic" or element2 == "cosmic") and caster:HasModifier("modifier_jex_immortal_weapon_3") then
					bonus = 1
				end
				if element1 == element2 then
					bonus = bonus*2
				end
				if caster:HasModifier("modifier_jex_glyph_5_a") then
					bonus = bonus + 1
				end
				onibi.stats_table[element1][element2][ability_key]["bonus_level"] = bonus
				onibi.stats_table[element2][element1][ability_key]["bonus_level"] = bonus
			end
		end
	end
	write_onibi_to_nettable(onibi)
end

function onibi_get_total_tech_level(caster, element1, element2, ability_key)
	local base_level = caster.onibi.stats_table[element1][element2][ability_key]["level"]
	local bonus_level = caster.onibi.stats_table[element1][element2][ability_key]["bonus_level"]
	return base_level + bonus_level
end
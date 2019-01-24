require('heroes/arc_warden/abilities/onibi')

function jex_main_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	if ability.interval < 4 then
		ability.interval = ability.interval + 1
		return false
	end
	if caster.loading then
		return false
	end
	local player = caster:GetPlayerOwner()
	if not player or player.hero_loading then
		return false
	end
	if not caster.onibi then
		if not caster.onibi_searching then
			get_onibi(caster)
		end
		return false
	end
end

function get_onibi(caster)
	caster.onibi_searching = true
	local roshpit_id = 0
	if caster.roshpitID then
		roshpit_id = caster.roshpitID
	end
	local playerID = caster:GetPlayerOwnerID()
	local url = ROSHPIT_URL.."/champions/getUnibi?"
	url = url.."&steam_id="..PlayerResource:GetSteamAccountID(playerID)
	url = url.."&championcharacter_id="..roshpit_id
	print(url)
	CreateHTTPRequestScriptVM("GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			load_onibi_data(caster, resultTable)
		else
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			caster.onibi_searching = false
		end
	end )
end

function get_onibi_essences(caster, onibi)
	local essences = {}
	for i = 1, 2, 1 do
		local ability = onibi:GetAbilityByIndex(i-1)
		if ability:GetAbilityName() == "onibi_nature_"..i then
			essences[i] = "nature"
		elseif ability:GetAbilityName() == "onibi_lightning_"..i then
			essences[i] = "lightning"
		elseif ability:GetAbilityName() == "onibi_cosmic_"..i then
			essences[i] = "cosmic"
		end
	end
	onibi.essences = essences
	return essences
end

function essence_aura_unit_die(event)
	local unit = event.unit
	local xp = unit:GetDeathXP()
	if xp > 0 then
		local caster = event.caster
	    local essence_value = math.ceil(xp/10)
		local essence_point = GetGroundPosition(unit:GetAbsOrigin(), unit)+RandomVector(RandomInt(0, 300))
		local essence_unit = CreateUnitByName("jex_essence", essence_point, false, nil, nil, DOTA_TEAM_GOODGUYS)
		local onibi = caster.onibi
		essence_unit:FindAbilityByName("jex_essence_ability"):SetLevel(1)
		get_onibi_essences(caster, onibi)
		local essence_possibilities = {onibi.essences[1], onibi.essences[2]}
		local actual_essence = essence_possibilities[RandomInt(1, #essence_possibilities)]
		local essence_data = {}
		essence_unit:SetForwardVector(RandomVector(1))
		print(actual_essence)
		if actual_essence == "nature" then
			essence_data.model = "models/props_nature/desert/succulent_fat.vmdl"
			essence_data.model_scale = 0.8
			essence_data.z_offset = 0
			essence_data.spawn_particle_vector = Vector(50, 255, 60)
			essence_unit:SetRenderColor(60, 255, 90)
		elseif actual_essence == "lightning" then
			essence_data.model = "models/items/dark_willow/dark_willow_ti8_immortal_head/dark_willow_ti8_immortal_flower.vmdl"
			essence_data.model_scale = 6.5
			essence_data.z_offset = 20
			essence_data.spawn_particle_vector = Vector(100, 255, 255)
		elseif actual_essence == "cosmic" then
			local luck = RandomInt(1, 2)
			if luck == 1 then
				essence_data.model = "maps/cavern_assets/models/mushrooms/mushroom_inkycap_03.vmdl"
			elseif luck == 2 then
				essence_data.model = "maps/cavern_assets/models/mushrooms/mushroom_inkycap_03.vmdl"
			end
			essence_data.model_scale = 0.41
			essence_unit:SetRenderColor(100, 0, 255)
			essence_data.z_offset = 0
			essence_data.spawn_particle_vector = Vector(180, 55, 255)
		end
		essence_unit:SetOriginalModel(essence_data.model)
		essence_unit:SetModel(essence_data.model)
		essence_unit.modelScale = essence_data.model_scale
		essence_unit:SetAbsOrigin(GetGroundPosition(essence_unit:GetAbsOrigin(), unit)+Vector(0,0,essence_data.z_offset))
		local spawnPFX = CustomAbilities:QuickAttachParticle("particles/roshpit/jex/essence_spawn.vpcf", essence_unit, 2)
		ParticleManager:SetParticleControl(spawnPFX, 1, essence_data.spawn_particle_vector/255)
		local modifierName = "jex_essence_"..actual_essence
		essence_unit:FindAbilityByName("jex_essence_ability"):ApplyDataDrivenModifier(essence_unit, essence_unit, modifierName, nil)
		essence_unit:FindAbilityByName("jex_essence_ability"):ApplyDataDrivenModifier(essence_unit, essence_unit, "jex_essence_spawning", {duration = 0.42})
		essence_unit:FindAbilityByName("jex_essence_ability"):ApplyDataDrivenModifier(essence_unit, essence_unit, "modifier_jex_essence_despawn", {duration = 180})
		essence_unit.essence_value = math.ceil(RPCItems:GetMaxFactor())
		if essence_unit.itemLevel then
			essence_unit.essence_value = essence_unit.essence_value + essence_unit.itemLevel*2
		end
		essence_unit.essence_value = math.min(essence_unit.essence_value, caster:GetLevel()*10)
		essence_unit.essence_unit = true
		essence_unit.essence = actual_essence
		essence_unit.resource_proportion_to_extract = 4
	end
end

function jex_essence_remove_unit(event)
	local essence = event.target
	if IsValidEntity(essence) then
		UTIL_Remove(essence)
	end
end

function jex_essence_spawning(event)
	local caster = event.caster
	local new_model_scale = caster:GetModelScale() + caster.modelScale/14
	if caster.phase_out then
		new_model_scale = caster:GetModelScale() - caster.modelScale/14
	end
	caster:SetModelScale(new_model_scale)
end

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = event.radius
	ability.point = point
	ability.radius = radius
	StartSoundEvent("Jex.Harvest", caster)
	ability.harvested = 0
	print("ESSENCE HARVEST ANIMATION")
	StartAnimation(caster, {duration=3, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.4})
	-- local allies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	-- local flowers = {}
	-- for i = 1, #allies, 1 do
	-- 	local unit = allies[i]
	-- 	if unit.essence_unit then
	-- 		table.insert(flowers, unit)
	-- 	end
	-- end
	-- allies = nil
	-- for i = 1, #flowers, 1 do
	-- 	local flower = flowers[i]

	-- end
end

function harvest_channel_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local point = ability.point
	local radius = ability.radius
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	local flowers = {}
	for i = 1, #allies, 1 do
		local unit = allies[i]
		print(unit:GetUnitName())
		if unit.essence_unit then
			table.insert(flowers, unit)
		end
	end
	allies = nil
	for i = 1, #flowers, 1 do
		local flower = flowers[i]
		print("FLOWERS")
		if flower.resource_proportion_to_extract > 0 then
			if not flower.extraction_pfx then
				print("Make pfx")
				local pfx = ParticleManager:CreateParticle("particles/roshpit/jex/essence_harvest.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(pfx, 0, flower, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", flower:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
				flower.extraction_pfx = pfx
			end
			local resources_to_extract = flower.essence_value/flower.resource_proportion_to_extract
			flower.essence_value = flower.essence_value - resources_to_extract
			flower.resource_proportion_to_extract = flower.resource_proportion_to_extract - 1
			ability.harvested = ability.harvested + 1
			add_resources_to_hero(caster, flower.essence, resources_to_extract)
			if flower.resource_proportion_to_extract == 0 then
				flower:FindAbilityByName("jex_essence_ability"):ApplyDataDrivenModifier(flower, flower, "jex_essence_spawning", {duration = 0.42})
				flower.phase_out = true
				flower:RemoveModifierByName("jex_essence_nature")
				flower:RemoveModifierByName("jex_essence_lightning")
				flower:RemoveModifierByName("jex_essence_cosmic")
				if flower.extraction_pfx then
					ParticleManager:DestroyParticle(flower.extraction_pfx, false)
					ParticleManager:ReleaseParticleIndex(flower.extraction_pfx)
					flower.extraction_pfx = nil
				end
				Timers:CreateTimer(0.55, function()
					flower:RemoveModifierByName("modifier_jex_essence_despawn")
				end)
			end
		end
	end
end

function essence_harvest_channel_end(event)
	local caster = nil
	local ability = nil
	local point = nil
	local radius = nil
	if event.glyph then
		caster = event.target
		ability = caster:FindAbilityByName("jex_essence_harvest")
		point = caster:GetAbsOrigin()
		radius = event.radius
	else
		caster = event.caster
		ability = event.ability
		point = ability.point
		radius = ability.radius
	end
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	local flowers = {}
	if not event.glyph then
		EndAnimation(caster)
	end
	for i = 1, #allies, 1 do
		local unit = allies[i]
		if unit.essence_unit then
			table.insert(flowers, unit)
		end
	end
	allies = nil
	for i = 1, #flowers, 1 do
		local flower = flowers[i]
		if event.glyph then
			if not flower.extraction_pfx then
				print("Make pfx")
				local pfx = ParticleManager:CreateParticle("particles/roshpit/jex/essence_harvest.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(pfx, 0, flower, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", flower:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
				flower.extraction_pfx = pfx
				Timers:CreateTimer(1, function()
					if flower.extraction_pfx then
						ParticleManager:DestroyParticle(flower.extraction_pfx, false)
						ParticleManager:ReleaseParticleIndex(flower.extraction_pfx)
						flower.extraction_pfx = nil
					end
				end)
			end
		else
			if flower.extraction_pfx then
				ParticleManager:DestroyParticle(flower.extraction_pfx, false)
				ParticleManager:ReleaseParticleIndex(flower.extraction_pfx)
				flower.extraction_pfx = nil
			end
		end
		if event.glyph then
			flower.resource_proportion_to_extract = 1
			add_resources_to_hero(caster, flower.essence, flower.essence_value/2)
		end
		if flower.resource_proportion_to_extract <= 1 then
			flower:FindAbilityByName("jex_essence_ability"):ApplyDataDrivenModifier(flower, flower, "jex_essence_spawning", {duration = 0.42})
			flower.phase_out = true
			flower:RemoveModifierByName("jex_essence_nature")
			flower:RemoveModifierByName("jex_essence_lightning")
			flower:RemoveModifierByName("jex_essence_cosmic")
			if flower.extraction_pfx then
				if not event.glyph then
					ParticleManager:DestroyParticle(flower.extraction_pfx, false)
					ParticleManager:ReleaseParticleIndex(flower.extraction_pfx)
					flower.extraction_pfx = nil
				end
			end
			Timers:CreateTimer(0.5, function()
				if IsValidEntity(flower) then
					flower:RemoveModifierByName("modifier_jex_essence_despawn")
				end
			end)
		end
	end
	if event.glyph then
		if #flowers == 0 then
			if not ability.glyph_harvest_counter then
				ability.glyph_harvest_counter = 0
			end
			ability.glyph_harvest_counter = ability.glyph_harvest_counter + 1
			if ability.glyph_harvest_counter == 3 then
				ability.harvested = 0
				if caster.jex_resources then
					local total_collected = 0
					for k, v in pairs(caster.jex_resources) do
						total_collected = total_collected + caster.jex_resources[k]
					end
					if total_collected > 0 then
						transfer_to_onibi(caster, ability)
						ability.harvested = 0
						ability.glyph_harvest_counter = 0
					end
				end
			end
		else
			ability.harvested = ability.harvested + #flowers
			ability.glyph_harvest_counter = 0
		end
	else

		transfer_to_onibi(caster, ability)
	end

	-- StopSoundEvent("Jex.Harvest", caster)
end

function transfer_to_onibi(caster, ability)
	if ability.harvested > 0 then
		Filters:CastSkillArguments(4, caster)
		local intensity = 1
		if ability.harvested > 10 then
			intensity = 2
		end
		if ability.harvested > 25 then
			intensity = 3
		end
		if ability.harvested > 60 then
			intensity = 4
		end
		if ability.harvested > 110 then
			intensity = 5
		end
		EmitSoundOn("Jex.HarvestEnd"..intensity, caster)
		StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_ATTACK, rate=1.4})
		StartAnimation(caster.onibi, {duration=0.5, activity=ACT_DOTA_DIE, rate=0.8})
	end
	local total_harvested = 0
	if caster.jex_resources then
		for k, v in pairs(caster.jex_resources) do
		  local resource_type = k
		  local amount = v
		  add_resources_to_onibi(caster, resource_type, amount)
		  total_harvested = total_harvested + amount
		end
		for k, v in pairs(caster.jex_resources) do
			caster.jex_resources[k] = 0
		end
		if total_harvested > 0 then
			local pfx = ParticleManager:CreateParticle("particles/roshpit/jex/essence_harvest.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 1, caster.onibi, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster.onibi:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end
	end
end

function add_resources_to_onibi(caster, element, amount)
	amount = math.floor(amount)
	if amount > 0 then
		print("ONIBI GETS "..amount.." of "..element)
		local player = caster:GetPlayerOwner()
		DeepPrintTable(caster.onibi.stats_table[element])
		local level = get_level_by_sum_exp(caster.onibi.stats_table[element]["exp"])
		if level < 100 then
			caster.onibi.stats_table[element]["exp"] = caster.onibi.stats_table[element]["exp"] + amount
		end
		calculate_onibi_element_levels(caster.onibi)
		local new_level = get_level_by_sum_exp(caster.onibi.stats_table[element]["exp"])
		local bLevelUp = 0
		if new_level > level then
			bLevelUp = 1
			onibi_level_up(caster.onibi)
		end
		CustomGameEventManager:Send_ServerToPlayer(player, "update_onibi", {bLevelUp = bLevelUp, levelup_element = element})
	end
end

function add_resources_to_hero(caster, type, amount)
	if not caster.jex_resources then
		caster.jex_resources = {}
	end
	if not caster.jex_resources[type] then
		caster.jex_resources[type] = 0
	end
	caster.jex_resources[type] = caster.jex_resources[type] + amount
end
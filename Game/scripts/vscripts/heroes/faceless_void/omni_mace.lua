require('heroes/faceless_void/omniro_constants')

function omni_mace_main_think(event)
	local caster = event.caster
	local ability = event.ability

	if not caster.omniro_data then
		init_omniro_data(event)
	end

	local reconstruct = omniro_rune_calculate(event)

	if not caster.omniro_data_initialized then
		init_omniro_detail_data(event)
		caster.omniro_data_initialized = true
	end

	omniro_element_charge_think(event)

	local player = caster:GetPlayerOwner()
	if reconstruct then
		CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro_data = caster.omniro_data, omniro = caster:GetEntityIndex(), reconstruct = true})
	else
		CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro_data = caster.omniro_data, omniro = caster:GetEntityIndex()})
	end

	if not caster.omniro_weapon_pfx then		
		-- local counter = 0
		-- for k, v in pairs(caster:GetChildren()) do 
		-- 	if v:GetClassname() == "dota_item_wearable" then
		-- 	  if counter == 5 then
		-- 	  	caster.weapon_attachment = v
		-- 	  end
		-- 	  counter = counter + 1
		-- 	end 
		-- end  
		-- print(caster.weapon_attachment:GetModelName())
		local pfx = ParticleManager:CreateParticle("particles/roshpit/omniro/omniro_weapon_glow.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		caster.omniro_weapon_pfx = pfx
	end
end

function init_omniro_data(event)
	local caster = event.caster
	caster.omniro_data = {}
	for i = 1, 17, 1 do
		caster.omniro_data[i] = {}
		caster.omniro_data[i]["enabled"] = true
		caster.omniro_data[i]["element_number"] = i
		caster.omniro_data[i]["active"] = false
		caster.omniro_data[i]["locked"] = false
		caster.omniro_data[i]["in_rotation"] = 1
		caster.omniro_data[i]["ability_index"] = event.ability:GetEntityIndex()
		if i > 1 then
			caster.omniro_data[i]["rune_tier"] = math.floor(((i-2)/4) + 1)
		else
			caster.omniro_data[i]["rune_tier"] = 0
		end
	end
	caster.omniro_data[1]["active"] = true
	caster.active_element = 1
end

function init_omniro_detail_data(event)
	local caster = event.caster
	for i = 1, 17, 1 do
		-- if caster.omniro_data[i]["level"] > 0 then
			caster.omniro_data[i]["charges"] = 1
			caster.omniro_data[i]["max_charges"] = 1
			caster.omniro_data[i]["charge_up_fraction"] = 0
			caster.omniro_data[i]["charge_up_fraction_full"] = 100

		-- end
	end
end

function omniro_rune_calculate(event)
	local reconstruct = false
	local caster = event.caster
	local rune_q_1 = caster:GetRuneValue("q", 1)
	local rune_q_2 = caster:GetRuneValue("q", 2)
	local rune_q_3 = caster:GetRuneValue("q", 3)
	local rune_q_4 = caster:GetRuneValue("q", 4)

	local rune_w_1 = caster:GetRuneValue("w", 1)
	local rune_w_2 = caster:GetRuneValue("w", 2)
	local rune_w_3 = caster:GetRuneValue("w", 3)
	local rune_w_4 = caster:GetRuneValue("w", 4)

	local rune_e_1 = caster:GetRuneValue("e", 1)
	local rune_e_2 = caster:GetRuneValue("e", 2)
	local rune_e_3 = caster:GetRuneValue("e", 3)
	local rune_e_4 = caster:GetRuneValue("e", 4)

	local rune_r_1 = caster:GetRuneValue("r", 1)
	local rune_r_2 = caster:GetRuneValue("r", 2)
	local rune_r_3 = caster:GetRuneValue("r", 3)
	local rune_r_4 = caster:GetRuneValue("r", 4)

	caster.omniro_data[RPC_ELEMENT_NORMAL]["level"] = 1

	if caster.omniro_data[RPC_ELEMENT_FIRE]["level"] ~= rune_q_1 then
		caster.omniro_data[RPC_ELEMENT_FIRE]["level"] = rune_q_1
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_EARTH]["level"] ~= rune_w_1 then
		caster.omniro_data[RPC_ELEMENT_EARTH]["level"] = rune_w_1
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"] ~= rune_e_1 then
		caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"] = rune_e_1
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_POISON]["level"] ~= rune_r_1 then
		caster.omniro_data[RPC_ELEMENT_POISON]["level"] = rune_r_1
		reconstruct = true
	end

	if caster.omniro_data[RPC_ELEMENT_TIME]["level"] ~= rune_q_2 then
		caster.omniro_data[RPC_ELEMENT_TIME]["level"] = rune_q_2
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_HOLY]["level"] ~= rune_w_2 then
		caster.omniro_data[RPC_ELEMENT_HOLY]["level"] = rune_w_2
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_COSMOS]["level"] ~= rune_e_2 then
		caster.omniro_data[RPC_ELEMENT_COSMOS]["level"] = rune_e_2
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_ICE]["level"] ~= rune_r_2 then
		caster.omniro_data[RPC_ELEMENT_ICE]["level"] = rune_r_2
		reconstruct = true
	end

	if caster.omniro_data[RPC_ELEMENT_ARCANE]["level"] ~= rune_q_3 then
		caster.omniro_data[RPC_ELEMENT_ARCANE]["level"] = rune_q_3
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_SHADOW]["level"] ~= rune_w_3 then
		caster.omniro_data[RPC_ELEMENT_SHADOW]["level"] = rune_w_3
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_WIND]["level"] ~= rune_e_3 then
		caster.omniro_data[RPC_ELEMENT_WIND]["level"] = rune_e_3
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_GHOST]["level"] ~= rune_r_3 then
		caster.omniro_data[RPC_ELEMENT_GHOST]["level"] = rune_r_3
		reconstruct = true
	end

	if caster.omniro_data[RPC_ELEMENT_WATER]["level"] ~= rune_q_4 then
		caster.omniro_data[RPC_ELEMENT_WATER]["level"] = rune_q_4
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_DEMON]["level"] ~= rune_w_4 then
		caster.omniro_data[RPC_ELEMENT_DEMON]["level"] = rune_w_4
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_NATURE]["level"] ~= rune_e_4 then
		caster.omniro_data[RPC_ELEMENT_NATURE]["level"] = rune_e_4
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"] ~= rune_r_4 then
		caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"] = rune_r_4
		reconstruct = true
	end

	for i = 1, #caster.omniro_data, 1 do
		if caster.omniro_data[i]["level"] > 0 then
			caster.omniro_data[i]["enabled"] = true
			local max_charges = 1
			local bonus_max_charges = 0
			if caster.omniro_data[i]["rune_tier"] == 1 then
				bonus_max_charges = math.floor(OMNIRO_T1_RUNE_MAX_CHARGES*caster.omniro_data[i]["level"])
			elseif caster.omniro_data[i]["rune_tier"] == 2 then
				bonus_max_charges = math.floor(OMNIRO_T2_RUNE_MAX_CHARGES*caster.omniro_data[i]["level"])
			elseif caster.omniro_data[i]["rune_tier"] == 3 then
				bonus_max_charges = math.floor(OMNIRO_T3_RUNE_MAX_CHARGES*caster.omniro_data[i]["level"])
			elseif caster.omniro_data[i]["rune_tier"] == 4 then
				bonus_max_charges = math.floor(OMNIRO_T4_RUNE_MAX_CHARGES*caster.omniro_data[i]["level"])
			end
			max_charges = max_charges + bonus_max_charges
			caster.omniro_data[i]["max_charges"] = max_charges
		end
	end
	return reconstruct
end

function omniro_element_charge_think(event)
	local caster = event.caster
	for i = 1, #caster.omniro_data, 1 do
		if caster.omniro_data[i]["level"] > 0 then
			if caster.omniro_data[i]["charges"] < caster.omniro_data[i]["max_charges"] then
				caster.omniro_data[i]["charge_up_fraction"] = caster.omniro_data[i]["charge_up_fraction"] + 1
				if caster.omniro_data[i]["charge_up_fraction"] >= caster.omniro_data[i]["charge_up_fraction_full"] then
					caster.omniro_data[i]["charge_up_fraction"] = 0
					caster.omniro_data[i]["charges"] = math.min(caster.omniro_data[i]["charges"] + 1, caster.omniro_data[i]["max_charges"])
				end
			end
		else
			caster.omniro_data[i]["enabled"] = false
		end
	end
end

function omniro_mace_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target.dummy then
		return false
	end
	local active_element = caster.active_element


	-- CURRENT ELEMENT EFFECT HERE
	if caster:HasModifier("modifier_omni_orb_active") then
		if caster.omniro_data[active_element]["charges"] > 0 then
			caster.omniro_data[active_element]["charges"] = caster.omniro_data[active_element]["charges"] - 1
		end
	end

	local next_element = nil
	if active_element == 17 then

	else
		for i = active_element, 16, 1 do
			if caster.omniro_data[i + 1]["level"] > 0 and caster.omniro_data[i + 1]["in_rotation"] == 1 then
				next_element = i + 1
				break
			end
		end	
	end
	if not next_element then
		next_element = active_element
		for i = 1, 17, 1 do
			if caster.omniro_data[i]["level"] > 0 and caster.omniro_data[i]["in_rotation"] == 1 then
				next_element = i
				break
			end
		end
	end
	print("-----")
	print(active_element)
	print(next_element)
	omni_mace_basic_hit(caster, ability, target, event)

	if not caster.omniro_data[caster.active_element]["locked"] then
		caster.omniro_data[active_element]["active"] = false
		caster.omniro_data[next_element]["active"] = true
		caster.active_element = next_element

		local mace_hit = omni_mace_basic_element_data(next_element)
		if caster.omniro_weapon_pfx then
			ParticleManager:SetParticleControl(caster.omniro_weapon_pfx, 1, mace_hit["color"])
		end
	end

	local player = caster:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro_data = caster.omniro_data, omniro = caster:GetEntityIndex()})
end

function omni_mace_toggle_on(event)
	local caster = event.caster
	caster.omniro_data[caster.active_element]["locked"] = true
end

function omni_mace_toggle_off(event)
	local caster = event.caster
	caster.omniro_data[caster.active_element]["locked"] = false
end

function omni_mace_ui_toggle(msg)
	local caster = EntIndexToHScript(msg.omniro)
	local total_elements_active_count = 0
	for i = 1, #caster.omniro_data, 1 do
		if caster.omniro_data[i]["level"] > 0 and caster.omniro_data[i]["in_rotation"] == 1 then
			total_elements_active_count = total_elements_active_count + 1
		end
	end
	if caster.omniro_data[msg.element_index]["in_rotation"] == 1 and total_elements_active_count > 1 then
		caster.omniro_data[msg.element_index]["in_rotation"] = 0
	else
		caster.omniro_data[msg.element_index]["in_rotation"] = 1
	end
	local player = caster:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro_data = caster.omniro_data, omniro = caster:GetEntityIndex(), reconstruct = true})
end

function omni_mace_basic_hit(caster, ability, target, event)
	local mace_hit_data = omni_mace_basic_element_data(caster.active_element)
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/omni_mace.vpcf", target, 0.4)
	print(mace_hit_data["color"])
	ParticleManager:SetParticleControl(pfx, 1, mace_hit_data["color"])
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.damage_mult/100)*caster.omniro_data[caster.active_element]["level"]
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, mace_hit_data["damage_type"], 1, caster.active_element, RPC_ELEMENT_NONE)

	if caster.active_element == RPC_ELEMENT_FIRE then
		local duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_fire_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_fire_buff", caster, caster.omniro_data[RPC_ELEMENT_FIRE]["level"])
	elseif caster.active_element == RPC_ELEMENT_EARTH then
		local duration = Filters:GetAdjustedBuffDuration(caster, 14, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_earth_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_earth_buff", caster, caster.omniro_data[RPC_ELEMENT_EARTH]["level"])
	elseif caster.active_element == RPC_ELEMENT_LIGHTNING then
		local lightning_dmg = target:GetHealth()*(event.lightning_special_a/100)*caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, lightning_dmg, mace_hit_data["damage_type"], 1, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
	elseif caster.active_element == RPC_ELEMENT_POISON then
		local duration = 2
		ability:ApplyDataDrivenModifier(caster, target, "modifier_omnimace_poison_debuff", {duration = duration})
	elseif caster.active_element == RPC_ELEMENT_TIME then
		local duration = Filters:GetAdjustedBuffDuration(caster, 10, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_time_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_time_buff", caster, caster.omniro_data[RPC_ELEMENT_TIME]["level"])
	elseif caster.active_element == RPC_ELEMENT_HOLY then
		local base_duration = event.holy_special_a*caster.omniro_data[RPC_ELEMENT_HOLY]["level"]
		local duration = Filters:GetAdjustedBuffDuration(caster, base_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_holy_buff", {duration = duration})		
	elseif caster.active_element == RPC_ELEMENT_COSMOS then
		local duration = Filters:GetAdjustedBuffDuration(caster, 14, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_time_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_time_buff", caster, caster.omniro_data[RPC_ELEMENT_TIME]["level"])
	elseif caster.active_element == RPC_ELEMENT_ICE then
		local duration = 12
		local icePoint = target:GetAbsOrigin()
		local radius = 240
	    local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	    local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
	    ParticleManager:SetParticleControl( pfx, 0, icePoint )
	    ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
	    Timers:CreateTimer(2.5, function()
	        ParticleManager:DestroyParticle(pfx, false)
	    end)
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #enemies > 0 then    
	        for _,enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_debuff", {duration = duration})
				caster:SetModifierStackCount("modifier_ice_debuff", enemy, caster.omniro_data[RPC_ELEMENT_ICE]["level"])	
	            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], 1, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
	        end
	    end
	elseif caster.active_element == RPC_ELEMENT_ARCANE then
		local manaDrain = math.min(caster:GetMana(), caster:GetMaxMana()*0.2)
		caster:ReduceMana(manaDrain)
		local arcane_damage = (event.arcane_special_a)*manaDrain*caster.omniro_data[RPC_ELEMENT_ARCANE]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, arcane_damage, mace_hit_data["damage_type"], 1, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	elseif caster.active_element == RPC_ELEMENT_SHADOW then
		local duration = 10
		ability:ApplyDataDrivenModifier(caster, target, "modifier_omniro_shadow_debuff", {duration = duration})
		local shadow_damage = (event.shadow_special_a/100)*damage*caster.omniro_data[RPC_ELEMENT_SHADOW]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, shadow_damage, mace_hit_data["damage_type"], 1, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
	elseif caster.active_element == RPC_ELEMENT_WIND then
		local duration = Filters:GetAdjustedBuffDuration(caster, 14, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_wind_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_wind_buff", caster, caster.omniro_data[RPC_ELEMENT_WIND]["level"])
	elseif caster.active_element == RPC_ELEMENT_GHOST then
		local base_duration = event.ghost_special_a*caster.omniro_data[RPC_ELEMENT_GHOST]["level"]
		local duration = Filters:GetAdjustedBuffDuration(caster, base_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_ghost_buff", {duration = duration})
	elseif caster.active_element == RPC_ELEMENT_WATER then
		local duration = Filters:GetAdjustedBuffDuration(caster, 14, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_water_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_water_buff", caster, caster.omniro_data[RPC_ELEMENT_WATER]["level"])
		local flat_heal = event.water_special_a*caster.omniro_data[RPC_ELEMENT_WATER]["level"]
		Filters:ApplyHeal(caster, caster, flat_heal, true)
		CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/basic_water_heal.vpcf", caster, 1)
	elseif caster.active_element == RPC_ELEMENT_DEMON then
		local duration = Filters:GetAdjustedBuffDuration(caster, 10, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_demon_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_demon_buff", caster, caster.omniro_data[RPC_ELEMENT_DEMON]["level"])
	elseif caster.active_element == RPC_ELEMENT_NATURE then
		local base_duration = event.nature_special_a*caster.omniro_data[RPC_ELEMENT_NATURE]["level"]
		ability:ApplyDataDrivenModifier(caster, target, "modifier_omnimace_nature_debuff", {duration = base_duration})
	elseif caster.active_element == RPC_ELEMENT_UNDEAD then
		local base_duration = event.undead_special_a*caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"]
		ability:ApplyDataDrivenModifier(caster, target, "modifier_omnimace_undead_debuff", {duration = base_duration})

		local duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_undead_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_undead_buff", caster, caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"])
	end
end



function omnimace_poison_debuff_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local poison_damage = (event.poison_special_a/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)
	local hit_data = omni_mace_basic_element_data(RPC_ELEMENT_POISON)
	Filters:ApplyDotDamage(caster, ability, target, poison_damage, hit_data["damage_type"], 1, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end

function omnimace_root_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local nature_damage = (event.nature_special_b/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)
	local hit_data = omni_mace_basic_element_data(RPC_ELEMENT_NATURE)
	Filters:ApplyDotDamage(caster, ability, target, nature_damage, hit_data["damage_type"], 1, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
end

function omni_mace_basic_element_data(element)
	mace_hit_data = {}
	if element == RPC_ELEMENT_NORMAL then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_FIRE then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_EARTH then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_LIGHTNING then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_POISON then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_TIME then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	elseif element == RPC_ELEMENT_HOLY then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_COSMOS then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	elseif element == RPC_ELEMENT_ICE then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_ARCANE then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_SHADOW then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_WIND then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_GHOST then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_WATER then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	elseif element == RPC_ELEMENT_DEMON then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	elseif element == RPC_ELEMENT_NATURE then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_UNDEAD then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	end
	local name, hex = Elements:GetElementNameAndColorByCode(element)
	local red, green, blue = Elements:hex2rgb(hex)
	mace_hit_data["color"] = Vector(red, green, blue)/255
	return mace_hit_data
end

function omniro_elemental_bonus(element1, element2, attacker)
	return 1
end

function omniro_AmplifyDamageParticle( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  local particleName = "particles/roshpit/omniro/shadow_armor_shred.vpcf"
  if target.AmpDamageParticle then
  	ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
  end
-- Particle. Need to wait one frame for the older particle to be destroyed
  Timers:CreateTimer(0.01, function() 
    target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  end)


end

-- Destroys the particle when the modifier is destroyed
function omniro_EndAmplifyDamageParticle( event )
  local target = event.target
  	if target.AmpDamageParticle then
	  ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
	  target.AmpDamageParticle = nil
	end
end
-- RPC_ELEMENT_NONE = -1
-- RPC_ELEMENT_NORMAL = 1
-- RPC_ELEMENT_FIRE = 2
-- RPC_ELEMENT_EARTH = 3
-- RPC_ELEMENT_LIGHTNING = 4
-- RPC_ELEMENT_POISON = 5
-- RPC_ELEMENT_TIME = 6
-- RPC_ELEMENT_HOLY = 7
-- RPC_ELEMENT_COSMOS = 8
-- RPC_ELEMENT_ICE = 9
-- RPC_ELEMENT_ARCANE = 10
-- RPC_ELEMENT_SHADOW = 11
-- RPC_ELEMENT_WIND = 12
-- RPC_ELEMENT_GHOST = 13
-- RPC_ELEMENT_WATER = 14
-- RPC_ELEMENT_DEMON = 15
-- RPC_ELEMENT_NATURE = 16
-- RPC_ELEMENT_UNDEAD = 17
-- RPC_ELEMENT_DRAGON = 18
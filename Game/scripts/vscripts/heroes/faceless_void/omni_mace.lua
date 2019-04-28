require('heroes/faceless_void/omniro_constants')

function omni_mace_main_think(event)
	local caster = event.caster
	local ability = event.ability

	if not caster.omniro_data then
		init_omniro_data(event)
	end

	omniro_rune_calculate(event)

	if not caster.omniro_data_initialized then
		init_omniro_detail_data(event)
		caster.omniro_data_initialized = true
	end

	omniro_element_charge_think(event)

	local player = caster:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro_data = caster.omniro_data, omniro = caster:GetEntityIndex()})

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

	caster.omniro_data[RPC_ELEMENT_FIRE]["level"] = rune_q_1
	caster.omniro_data[RPC_ELEMENT_EARTH]["level"] = rune_w_1
	caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"] = rune_e_1
	caster.omniro_data[RPC_ELEMENT_POISON]["level"] = rune_r_1

	caster.omniro_data[RPC_ELEMENT_TIME]["level"] = rune_q_2
	caster.omniro_data[RPC_ELEMENT_HOLY]["level"] = rune_w_2
	caster.omniro_data[RPC_ELEMENT_COSMOS]["level"] = rune_e_2
	caster.omniro_data[RPC_ELEMENT_ICE]["level"] = rune_r_2

	caster.omniro_data[RPC_ELEMENT_ARCANE]["level"] = rune_q_3
	caster.omniro_data[RPC_ELEMENT_SHADOW]["level"] = rune_w_3
	caster.omniro_data[RPC_ELEMENT_WIND]["level"] = rune_e_3
	caster.omniro_data[RPC_ELEMENT_GHOST]["level"] = rune_r_3

	caster.omniro_data[RPC_ELEMENT_WATER]["level"] = rune_q_4
	caster.omniro_data[RPC_ELEMENT_DEMON]["level"] = rune_w_4
	caster.omniro_data[RPC_ELEMENT_NATURE]["level"] = rune_e_4
	caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"] = rune_r_4

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
	omni_mace_basic_hit(caster, ability, target, event.damage_mult)

	if not caster.omniro_data[caster.active_element]["locked"] then
		caster.omniro_data[active_element]["active"] = false
		caster.omniro_data[next_element]["active"] = true
		caster.active_element = next_element
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
	print(caster.omniro_data[msg.element_index]["in_rotation"])
	CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro_data = caster.omniro_data, omniro = caster:GetEntityIndex()})
end

function omni_mace_basic_hit(caster, ability, target, damage_mult)
	local mace_hit_data = omni_mace_basic_element_data(caster.active_element)
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/omni_mace.vpcf", target, 0.4)
	print(mace_hit_data["color"])
	ParticleManager:SetParticleControl(pfx, 1, mace_hit_data["color"])
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(damage_mult/100)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, mace_hit_data["damage_type"], 3, caster.active_element, RPC_ELEMENT_NONE)

	if caster.active_element == RPC_ELEMENT_FIRE then
		local duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_fire_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_fire_buff", caster, caster.omniro_data[caster.active_element]["level"])
	elseif caster.active_element == RPC_ELEMENT_EARTH then
	end
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
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
	for i = 1, 17, 1, do
		caster.omniro_data[i] = {}
		caster.omniro_data[i]["enabled"] = true
		caster.omniro_data[i]["element_number"] = i
		caster.omniro_data[i]["active"] = false
	end
	caster.omniro_data[1]["active"] = true
	caster.active_element = 1
end

function init_omniro_detail_data(event)
	local caster = event.caster
	for i = 1, 17, 1, do
		if caster.omniro_data[i]["level"] > 0 then
			caster.omniro_data[i]["charges"] = 1
			caster.omniro_data[i]["max_charges"] = 1
			caster.omniro_data[i]["charge_up_fraction"] = 0
			caster.omniro_data[i]["charge_up_fraction_full"] = 80
		end
	end
end

function omniro_rune_calculate(event)
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
end

function omniro_element_charge_think(event)
	for i = 1, #caster.omniro_data, 1 do
		if caster.omniro_data[i]["charges"] < caster.omniro_data[i]["max_charges"] then
			caster.omniro_data[i]["charge_up_fraction"] = caster.omniro_data[i]["charge_up_fraction"] + 1
			if caster.omniro_data[i]["charge_up_fraction"] >= caster.omniro_data[i]["charge_up_fraction_full"] then
				caster.omniro_data[i]["charge_up_fraction"] = 0
				caster.omniro_data[i]["charges"] = math.min(caster.omniro_data[i]["charges"] + 1, caster.omniro_data[i]["max_charges"])
			end
		end
	end
end

function omniro_mace_attack_land(event)
	local caster = event.caster
	local target = event.target
	local active_element = caster.active_element


	-- CURRENT ELEMENT EFFECT HERE
	if caster:HasModifier("modifier_omni_orb_active") then
		if caster.omniro_data[i]["charges"] > 0 then
			print("ORB EFFECT FIRE")
			caster.omniro_data[i]["charges"] = caster.omniro_data[i]["charges"] - 1
		end
	end

	local next_element = nil
	if active_element == 17 then
	else
		for i = active_element, 16, 1 do
			if caster.omniro_data[active_element + 1]["level"] > 0 then
				next_element = caster.omniro_data[active_element + 1]
				break
			end
		end	
	end
	if not next_element then
		for i = 1, 17, 1 do
			if caster.omniro_data[i]["level"] > 0 then
				next_element = caster.omniro_data[i]
			end
		end
	end
	caster.omniro_data[active_element]["active"] = false
	caster.omniro_data[next_element]["active"] = true

	local player = caster:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro_data = caster.omniro_data, omniro = caster:GetEntityIndex()})
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
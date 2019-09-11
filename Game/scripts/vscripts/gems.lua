if Gems == nil then
	Gems = class({})
end

function Gems:RandomlySetSocketsForItem(item)
end

function Gems:AddSocket(item)
	if Gems:CanItemBeSocketed(item) then
		if not item.newItemTable.socket1 then
			item.newItemTable.socket1 = "open"
			item.newItemTable.socket1value = 0
			RPCItems:ItemUpdateCustomNetTables(item)
			return true
		elseif not item.newItemTable.socket2 then
			item.newItemTable.socket2 = "open"
			item.newItemTable.socket2value = 0
			RPCItems:ItemUpdateCustomNetTables(item)
			return true
		end
	end
end

function Gems:SetSocket(item, socket_number, gem, value)
	if socket_number == 1 then
		item.newItemTable.socket1 = gem
		item.newItemTable.socket1value = value
		RPCItems:ItemUpdateCustomNetTables(item)
	elseif socket_number == 2 then
		item.newItemTable.socket2 = gem
		item.newItemTable.socket2value = value
		RPCItems:ItemUpdateCustomNetTables(item)
	end
end

function Gems:CanItemBeSocketed(item)
	local allowed = true
	local slot = item.newItemTable.item_slot
	if slot == "amulet" or slot == "body" or slot == "feet" or slot == "hands" or slot == "head" then
	else
		allowed = false
	end
	if item.newItemTable.rarity == "immortal" then
	else
		allowed = false
	end
	if not item.newItemTable.socket2 then
	else
		allowed = false
		if item.newItemTable.socket2 == "none" then
			allowed = true
		else
			allowed = false
		end
	end
	return allowed
end

function Gems:GetMithrilCostToAddSocket(item)
	local cost = 0
	local next_slot = Gems:NextSlotNumber(item)
	if next_slot == 1 then
		cost = item.newItemTable.minLevel*120
	elseif next_slot == 2 then
		cost = item.newItemTable.minLevel*1200
	end
	return cost
end

function Gems:NextSlotNumber(item)
	local next_slot = 0
	if not item.newItemTable.socket1 then
		next_slot = 1
	elseif not item.newItemTable.socket2 then
		next_slot = 2
	end
	return next_slot
end

function Gems:GetErrorMessageForSocketing(item)
	local error_message = "none"
	local slot = item.newItemTable.item_slot
	if slot == "amulet" or slot == "body" or slot == "feet" or slot == "hands" or slot == "head" then
	else
		error_message = "cannot_be_socketed_slot"
	end
	if item.newItemTable.rarity == "immortal" then
	else
		error_message = "cannot_be_socketed_rarity"
	end
	if not item.newItemTable.socket2 then
	else
		error_message = "cannot_be_socketed_full_socket"
		if item.newItemTable.socket2 == "none" then
			error_message = "none"
		end
	end
	return error_message
end

function Gems:SpawnGemForger(position, endFV, gem_reward)
	-- if not Gems.GemForgerSpawned then
	 	if Gems.GemForger then
	 		UTIL_Remove(Gems.GemForger)
	 	end
		Gems.GemForgerSpawned = true
		Gems.GemForger = CreateUnitByName("gem_forger", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
		Gems.GemForger:SetAbsOrigin(Gems.GemForger:GetAbsOrigin()+Vector(0,0,1000))
		Gems.GemForger.endFV = endFV

		Gems.GemForger:FindAbilityByName("town_unit"):SetLevel(1)
		Gems.GemForger:FindAbilityByName("npc_dialogue"):SetLevel(1)
		Gems.GemForger.dialogueName = "gem_forger"

		local startFV = WallPhysics:rotateVector(endFV, 2*math.pi*1/4)
		Gems.GemForger:SetForwardVector(startFV)
		local gem_ability = Gems.GemForger:FindAbilityByName("gem_forger_ability")
		gem_ability:ApplyDataDrivenModifier(Gems.GemForger, Gems.GemForger, "modifier_gem_forger_entering", {})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", Gems.GemForger, 0.03)

		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, Gems.GemForger:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Gems.GemForger:GetAbsOrigin())
		Gems.GemForger.entering_pfx = pfx
		StartAnimation(Gems.GemForger, {duration = 3, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1})
		EmitSoundOn("NPC.Gemforger.Enter.Start", Gems.GemForger)

		gem_reward = math.ceil(RPCItems:GetLogarithmicVarianceValue(gem_reward, 0, 0, 0, 0))
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].gem_reward = gem_reward
		end
	-- end
end

function Gems:DropSocketForger(position)
	local item = RPCItems:CreateConsumable("item_rpc_socket_cutter", "immortal", "Socket Cutter", "consumable", false, "Consumable", "socket_cutter_desc")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	RPCItems:ItemUpdateCustomNetTables(item)
	RPCItems:BasicDropItem(position, item)
end
function equip_item(event)
	local item = event.ability
	local itemIndex = item:GetEntityIndex()
	local itemTable = CustomNetTables:GetTableValue("item_basics", tostring(itemIndex))
	if item.newItemTable.version == "3.9" then
		Curator:UpdateItemToCurrentVersion(item, event.caster, false)
		return false
	end
	-- DeepPrintTable(event.caster)
	if not itemTable then
		return false
	end
	item.newItemTable = itemTable

	local caster = event.caster
	--print("[equip_item] GetUnitName:"..tostring(caster:GetUnitName()))
	if caster:HasModifier("modifier_cant_equip") then
		return false
	end
	if caster:HasModifier("modifier_respawned_equip") then
		return false
	end
	if caster:GetLevel() >= item.newItemTable.minLevel then
		if item.newItemTable.requiredHero then
			if caster:GetUnitName() == item.newItemTable.requiredHero then
				RPCItems:GearPickup(event.caster, item)
			else
				Notifications:Top(caster:GetPlayerOwnerID(), {text = "Can't Equip", duration = 2, style = {color = "red"}, continue = true})
			end
		else
			RPCItems:GearPickup(event.caster, item)
		end
	else
		Notifications:Top(caster:GetPlayerOwnerID(), {text = "Level Requirement", duration = 2, style = {color = "red"}, continue = true})
		EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
	end
end

function equip_arcana(event)
	local item = event.ability
	local target = event.target
	local index = event.index
	Runes:EquipArcana(target, index)
end

function unequip_arcana(event)
	local item = event.ability
	local target = event.target
	local index = event.index
	Runes:UnequipArcana(target, index)
end

function save_character(event)
	local hero = event.target
	print(hero:GetUnitName())
	local save_message = {}
	save_message.playerID = hero:GetPlayerOwnerID()
	save_message.slot = hero.saveSlot
	save_message.heroIndex = hero:GetEntityIndex()
	save_message.ignore_callback = true
	SaveLoad:SaveCharacter(save_message)
end
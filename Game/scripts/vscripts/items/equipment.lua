function equip_item(event)
	local item = event.ability
	local caster = event.caster
	if caster:HasModifier("modifier_cant_equip") then
		return false
	end
	if caster:HasModifier("modifier_respawned_equip") then
		return false
	end
	if caster:GetLevel() >= item.minLevel then
		if item.requiredHero then
			if caster:GetUnitName() == item.requiredHero then
				RPCItems:GearPickup(event.caster, event.ability)
			else
				Notifications:Top(caster:GetPlayerOwnerID(), {text="Can't Equip", duration=2, style={color="red"}, continue=true})
			end
		else
			RPCItems:GearPickup(event.caster, event.ability)
		end
	else
		Notifications:Top(caster:GetPlayerOwnerID(), {text="Level Requirement", duration=2, style={color="red"}, continue=true})
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
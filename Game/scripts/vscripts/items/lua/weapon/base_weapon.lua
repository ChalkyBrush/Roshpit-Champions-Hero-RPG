require('items/lua/base_item')
BaseWeapon = class(BaseItem, nil, BaseItem)
local itemClass = BaseWeapon
function itemClass:GetSlotTextShort()
    return 'weapon'
end
function itemClass:GetSlotText()
    return 'Slot: Weapon'
end
function itemClass:GetSlotNumber()
    return RPC_GEAR_SLOT_WEAPON
end

function itemClass:CreateLuaItem(item_level)
    self = RPCItems:CreateVariant(self:GetClassName(), "immortal", self:GetName(), self:GetSlotTextShort(), true, self:GetSlotText())
    self.isLuaItem = true

    self:RollProperty1(item_level)
    self:RollProperty2(item_level)
    self:RollProperty3(item_level)
    self:RollProperty4(item_level)

    RPCItems:SetBaseItemValues(self, self:GetClassName(), false, 
    	RPCItems.BASIC_ITEMS_SLOT_TEXT[self:GetSlotNumber()], RPC_ITEM_RARITY_COLORS[RPC_ITEMS_RARITY_IMMORTAL], 
    	RPCItems:GetRarityNameFromFactor(RPC_ITEMS_RARITY_IMMORTAL), RPC_ITEMS_RARITY_IMMORTAL, item_level, self:GetSlotNumber())
    return self
end

function itemClass:RollProperty3(item_level)
	local weapon = self
	local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
	if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
		weapon.newItemTable.property3 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property3name = RPCItems:TranslateRuneRoll(property)
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, "rune", "#7DFF12", 3)
	else
		weapon.newItemTable.property3 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property3name = property
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, "item_"..property, RPCItems.PROPERTY_COLORS[property], 3)
	end
end

function itemClass:RollProperty4(item_level)
	local weapon = self
	local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
	if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
		weapon.newItemTable.property4 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property4name = RPCItems:TranslateRuneRoll(property)
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, "rune", "#7DFF12", 4)
	else
		weapon.newItemTable.property4 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property4name = property
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, "item_"..property, RPCItems.PROPERTY_COLORS[property], 4)
	end
end


	
RPCItems.ArcanaRuneChances = {}
RPCItems.ArcanaRuneChances[1] = 36
RPCItems.ArcanaRuneChances[2] = 72
RPCItems.ArcanaRuneChances[3] = 90
RPCItems.ArcanaRuneChances[4] = 100

function RPCItems:CreateArcanaBasic(variantName, rarityName, itemNameText, slot, gear, slotText, requiredHero, minLevel)
    local item = RPCItems:CreateItem(variantName, nil, nil)
    item.newItemTable.qualityName = rarityName
    item.newItemTable.rarity = rarityName
    item.newItemTable.rarityFactor = RPCItems:GetRarityFactor(item.newItemTable.rarity)
    item.newItemTable.itemPrefix = ""
    item.newItemTable.itemSuffix = ""
    item.newItemTable.item_slot = slot
    item.newItemTable.gear = gear
    item.newItemTable.consumable = nil
    item.newItemTable.requiredHero = requiredHero
    item.newItemTable.gear_slot = RPCItems:getGearSlot(slot)
    if not minLevel or (minLevel and minLevel == 0) then
        minLevel = 1
    end
    item.newItemTable.minLevel = minLevel
    RPCItems:SetTableValues(item, itemNameText, item.newItemTable.consumable, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, "", "", RPCItems:GetRarityFactor(item.newItemTable.rarity))

    return item
end

function RPCItems:RollArcanaRuneForSlot(rune_slot)
    local rune_tier = 1
    local rune_tier_chance = RandomInt(1, 100)
    for key, value in pairs(RPCItems.ArcanaRuneChances) do
        if rune_tier_chance <= value then
            rune_tier = key
            break
        end
    end

    local rune_name = "rune_"..rune_slot.."_"..rune_tier
    return rune_name
end


function RPCItems:RollFlamewakerArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA
    local item = RPCItems:CreateArcanaBasic("item_rpc_flamewaker_arcana1", "arcana", "Flamewaker Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_dragon_knight", item_level)
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_flamewaker_arcana1", "#FCAD58", 1, "#property_flamewaker_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.4)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)

    return item
end

function RPCItems:RollSeinaruArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA
    local item = RPCItems:CreateArcanaBasic("item_rpc_seinaru_arcana1", "arcana", "Seinaru Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_juggernaut", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_seinaru_arcana1", "#F4F269", 1, "#property_seinaru_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.4)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)

    return item
end

function RPCItems:RollSeinaruArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_seinaru_arcana2", "arcana", "Seinaru Arcana 2", "feet", true, "Slot: Feet", "npc_dota_hero_juggernaut", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_seinaru_arcana2", "#FFFB23", 1, "#property_seinaru_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.4)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)

    return item
end

function RPCItems:RollPaladinArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_paladin_arcana2", "arcana", "Paladin Arcana 2", "feet", true, "Slot: Feet", "npc_dota_hero_omniknight", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_paladin_arcana2", "#F7F767", 1, "#property_paladin_arcana2_description")


    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.4)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)

    return item
end

function RPCItems:RollAstralArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_astral_arcana1", "arcana", "Astral Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_drow_ranger", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_astral_arcana1", "#9D8BBF", 1, "#property_astral_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)

    return item
end

function RPCItems:RollBahamutArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_bahamut_arcana1", "arcana", "Bahamut Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_leshrac", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bahamut_arcana1", "#7CDAFF", 1, "#property_bahamut_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3.5)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)

    return item
end

function RPCItems:RollDuskbringerArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_duskbringer_arcana1", "arcana", "Duskbringer Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_spirit_breaker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_duskbringer_arcana1", "#5CEDE1", 1, "#property_duskbringer_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDuskbringerArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_duskbringer_arcana2", "arcana", "Duskbringer Arcana 2", "head", true, "Slot: Head", "npc_dota_hero_spirit_breaker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_duskbringer_arcana2", "#c9d6d6", 1, "#property_duskbringer_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, "max_health", 2.5)
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollConjurorArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_conjuror_arcana1", "arcana", "Conjuror Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_invoker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_conjuror_arcana1", "#D6CF59", 1, "#property_conjuror_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)

    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTrapperArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_trapper_arcana1", "arcana", "Trapper Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_templar_assassin", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_trapper_arcana1", "#CCAE2C", 1, "#property_trapper_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "attack_damage", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    
    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)

    return item
end

function RPCItems:RollSpiritWarriorArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_spirit_warrior_arcana1", "arcana", "Spirit Warrior Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_huskar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spirit_warrior_arcana1", "#82A8E5", 1, "#property_spirit_warrior_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSpiritWarriorArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_spirit_warrior_arcana2", "arcana", "Spirit Warrior Arcana 2", "hands", true, "Slot: Hands", "npc_dota_hero_huskar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spirit_warrior_arcana2", "#82A8E5", 1, "#property_spirit_warrior_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)

    return item
end

function RPCItems:RollSpiritWarriorArcana3(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_spirit_warrior_arcana3", "arcana", "Spirit Warrior Arcana 3", "feet", true, "Slot: Feet", "npc_dota_hero_huskar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana3"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spirit_warrior_arcana3", "#69EF7F", 1, "#property_spirit_warrior_arcana3_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMountainProtectorArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_mountain_protector_arcana1", "arcana", "Mountain Protector Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_legion_commander", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_protector_arcana1", "#BDE6F9", 1, "#property_mountain_protector_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMountainProtectorArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_mountain_protector_arcana2", "arcana", "Mountain Protector Arcana 2", "body", true, "Slot: Body", "npc_dota_hero_legion_commander", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_protector_arcana2", "#94BEFC", 1, "#property_mountain_protector_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 4)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMountainProtectorArcana3(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_mountain_protector_arcana3", "arcana", "Mountain Protector Arcana 3", "feet", true, "Slot: Feet", "npc_dota_hero_legion_commander", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana3"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_protector_arcana3", "#C45E38", 1, "#property_mountain_protector_arcana3_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVenomortArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_venomort_arcana1", "arcana", "Venomort Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_necrolyte", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_venomort_arcana1", "#48AF5E", 1, "#property_venomort_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "attack_damage", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVenomortArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_venomort_arcana2", "arcana", "Venomort Arcana 2", "head", true, "Slot: Head", "npc_dota_hero_necrolyte", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_venomort_arcana2", "#6df2d3", 1, "#property_venomort_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollChernobogArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_chernobog_arcana1", "arcana", "Chernobog Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_night_stalker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_chernobog_arcana1", "#4C5B96", 1, "#property_chernobog_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollChernobogArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_chernobog_arcana2", "arcana", "Chernobog Arcana 2", "feet", true, "Slot: Feet", "npc_dota_hero_night_stalker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_chernobog_arcana2", "#4C7ECE", 1, "#property_chernobog_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.2)
    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_property, 1.4)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAuriunArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_auriun_arcana1", "arcana", "Auriun Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_zuus", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_auriun_arcana1", "#F4DC42", 1, "#property_auriun_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAuriunArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_auriun_arcana2", "arcana", "Auriun Arcana 2", "head", true, "Slot: Head", "npc_dota_hero_zuus", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_auriun_arcana2", "#9B48CE", 1, "#property_auriun_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVoltexArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_voltex_arcana1", "arcana", "Voltex Arcana 1", "feet", true, "Slot: Feet", "npc_dota_hero_phantom_assassin", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_voltex_arcana1", "#49CFF4", 1, "#property_voltex_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollPaladinArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_paladin_arcana1", "arcana", "Paladin Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_omniknight", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_paladin_arcana1", "#F4E542", 1, "#property_paladin_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "spirit", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSorceressArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_sorceress_arcana1", "arcana", "Sorceress Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_crystal_maiden", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sorceress_arcana1", "#82D5FF", 1, "#property_sorceress_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEpochArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_epoch_arcana1", "arcana", "Epoch Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_obsidian_destroyer", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_epoch_arcana1", "#87FFD1", 1, "#property_epoch_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAxeArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_axe_arcana1", "arcana", "Axe Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_axe", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_axe_arcana1", "#82D5FF", 1, "#property_axe_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWarlordArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_warlord_arcana1", "arcana", "Warlord Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_beastmaster", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_warlord_arcana1", "#EFD8BD", 1, "#property_warlord_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWarlordArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_warlord_arcana2", "arcana", "Warlord Arcana 2", "head", true, "Slot: Head", "npc_dota_hero_beastmaster", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_warlord_arcana2", "#3289C7", 1, "#property_warlord_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEkkanArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_ekkan_arcana1", "arcana", "Ekkan Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_visage", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ekkan_arcana1", "#879CBC", 1, "#property_ekkan_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.2)
    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_property, 1.4)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSoluniaArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_solunia_arcana1", "arcana", "Solunia Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_vengefulspirit", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_solunia_arcana1", "#F442E8", 1, "#property_solunia_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "max_health", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSoluniaArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_solunia_arcana2", "arcana", "Solunia Arcana 2", "body", true, "Slot: Body", "npc_dota_hero_vengefulspirit", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_solunia_arcana2", "#E84A7C", 1, "#property_solunia_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSoluniaArcana3(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_solunia_arcana3", "arcana", "Solunia Arcana 3", "hands", true, "Slot: Hands", "npc_dota_hero_vengefulspirit", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana3"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_solunia_arcana3", "#f542c5", 1, "#property_solunia_arcana3_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "element_cosmic", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollArkimusArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_arkimus_arcana1", "arcana", "Arkimus Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_antimage", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arkimus_arcana1", "#f442D7", 1, "#property_arkimus_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollArkimusArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_arkimus_arcana2", "arcana", "Arkimus Arcana 2", "body", true, "Slot: Body", "npc_dota_hero_antimage", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arkimus_arcana2", "#8339A8", 1, "#property_arkimus_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollZhonikArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_zonik_arcana1", "arcana", "Zhonik Arcana 1", "feet", true, "Slot: Feet", "npc_dota_hero_dark_seer", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_zonik_arcana1", "#42F450", 1, "#property_zonik_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 2.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollZhonikArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_zonik_arcana2", "arcana", "Zhonik Arcana 2", "body", true, "Slot: Body", "npc_dota_hero_dark_seer", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_zonik_arcana2", "#42F450", 1, "#property_zonik_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHydroxisArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_hydroxis_arcana1", "arcana", "Hydroxis Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_slardar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hydroxis_arcana1", "#42BCF4", 1, "#property_hydroxis_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBahamutArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_bahamut_arcana2", "arcana", "Bahamut Arcana 2", "hands", true, "Slot: Hands", "npc_dota_hero_leshrac", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bahamut_arcana2", "#DDDDFF", 1, "#property_bahamut_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSorceressArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_sorceress_arcana2", "arcana", "Sorceress Arcana 2", "head", true, "Slot: Head", "npc_dota_hero_crystal_maiden", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sorceress_arcana2", "#F4F269", 1, "#property_sorceress_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDjanghorArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_djanghor_arcana1", "arcana", "Djanghor Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_monkey_king", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_djanghor_arcana1", "#7ef7f2", 1, "#property_djanghor_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFlamewakerArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_flamewaker_arcana2", "arcana", "Flamewaker Arcana 2", "hands", true, "Slot: Hands", "npc_dota_hero_dragon_knight", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_flamewaker_arcana2", "#EFB240", 1, "#property_flamewaker_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAstralArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_astral_arcana2", "arcana", "Astral Arcana 2", "hands", true, "Slot: Hands", "npc_dota_hero_drow_ranger", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_astral_arcana2", "#4286F4", 1, "#property_astral_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1.8)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.8)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAstralArcana3(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_astral_arcana3", "arcana", "Astral Arcana 3", "body", true, "Slot: Body", "npc_dota_hero_drow_ranger", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana3"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_astral_arcana3", "#84B3FF", 1, "#property_astral_arcana3_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSephyrArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_sephyr_arcana1", "arcana", "Sephyr Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_skywrath_mage", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sephyr_arcana1", "#72E0DE", 1, "#property_sephyr_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHydroxisArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_hydroxis_arcana2", "arcana", "Hydroxis Arcana 2", "body", true, "Slot: Body", "npc_dota_hero_slardar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hydroxis_arcana2", "#84B3FF", 1, "#property_hydroxis_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("r")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1.3)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 4)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVoltexArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_voltex_arcana2", "arcana", "Voltex Arcana 2", "head", true, "Slot: Head", "npc_dota_hero_phantom_assassin", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_voltex_arcana2", "#85f2d8", 1, "#property_voltex_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDinathArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_dinath_arcana1", "arcana", "Dinath Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_winter_wyvern", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_dinath_arcana1", "#72E0DE", 1, "#property_dinath_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "attack_damage", 2.4)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollConjurorArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_conjuror_arcana2", "arcana", "Conjuror Arcana 2", "hands", true, "Slot: Hands", "npc_dota_hero_invoker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_conjuror_arcana2", "#FCA314", 1, "#property_conjuror_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollConjurorArcana3(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_conjuror_arcana3", "arcana", "Conjuror Arcana 3", "head", true, "Slot: Head", "npc_dota_hero_invoker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana3"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_conjuror_arcana3", "#b29e3c", 1, "#property_conjuror_arcana3_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("q")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollConjurorArcana4(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_conjuror_arcana4", "arcana", "Conjuror Arcana 4", "feet", true, "Slot: Feet", "npc_dota_hero_invoker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana4"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_conjuror_arcana4", "#433068", 1, "#property_conjuror_arcana4_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAxeArcana2(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_axe_arcana2", "arcana", "Axe Arcana 2", "hands", true, "Slot: Hands", "npc_dota_hero_axe", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_axe_arcana2", "#ad502b", 1, "#property_axe_arcana2_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "armor", 5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, "magic_armor", 5)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollJexArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_jex_arcana1", "arcana", "jex Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_arc_warden", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_jex_arcana1", "#EF4126", 1, "#property_jex_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("w")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "attack_damage", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSlipfinnArcana1(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_ARCANA

    local item = RPCItems:CreateArcanaBasic("item_rpc_slipfinn_arcana1", "arcana", "Slipfinn Arcana 1", "feet", true, "Slot: Feet", "npc_dota_hero_slark", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_slipfinn_arcana1", "#395C93", 1, "#property_slipfinn_arcana1_description")

    local rune_property = RPCItems:RollArcanaRuneForSlot("e")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 3.1)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:PreacheArcanaResources(item)
    Timers:CreateTimer(0.05, function()
        PrecacheItemByNameAsync(item:GetAbilityName(), function(...) end)
    end)
end

function RPCItems:GetAvailableArcanaData(hero)
    local unitName = hero:GetUnitName()
    local arcanaData = {}
    if unitName == "npc_dota_hero_dragon_knight" then
        table.insert(arcanaData, {1, 0})
        table.insert(arcanaData, {2, 1})
    elseif unitName == "npc_dota_hero_phantom_assassin" then
        table.insert(arcanaData, {1, 2})
        table.insert(arcanaData, {2, 0})
    elseif unitName == "npc_dota_hero_necrolyte" then
        table.insert(arcanaData, {1, 3})
        table.insert(arcanaData, {2, 0})
    elseif unitName == "npc_dota_hero_axe" then
        table.insert(arcanaData, {1, 3})
        table.insert(arcanaData, {2, 1})
    elseif unitName == "npc_dota_hero_drow_ranger" then
        table.insert(arcanaData, {1, 0})
        table.insert(arcanaData, {2, 1})
        table.insert(arcanaData, {3, 3})
    elseif unitName == "npc_dota_hero_obsidian_destroyer" then
        table.insert(arcanaData, {1, 0})
    elseif unitName == "npc_dota_hero_omniknight" then
        table.insert(arcanaData, {1, 1})
        table.insert(arcanaData, {2, 2})
    elseif unitName == "npc_dota_hero_crystal_maiden" then
        table.insert(arcanaData, {1, 3})
        table.insert(arcanaData, {2, 0})
    elseif unitName == "npc_dota_hero_invoker" then
        table.insert(arcanaData, {1, 3})
        table.insert(arcanaData, {2, 1})
        table.insert(arcanaData, {3, 0})
        table.insert(arcanaData, {4, 2})
    elseif unitName == "npc_dota_hero_juggernaut" then
        table.insert(arcanaData, {1, 0})
        table.insert(arcanaData, {2, 2})
    elseif unitName == "npc_dota_hero_beastmaster" then
        table.insert(arcanaData, {1, 3})
        table.insert(arcanaData, {2, 0})
    elseif unitName == "npc_dota_hero_leshrac" then
        table.insert(arcanaData, {1, 3})
        table.insert(arcanaData, {2, 1})
    elseif unitName == "npc_dota_hero_spirit_breaker" then
        table.insert(arcanaData, {1, 1})
        table.insert(arcanaData, {2, 0})
    elseif unitName == "npc_dota_hero_zuus" then
        table.insert(arcanaData, {1, 0})
        table.insert(arcanaData, {2, 0})
    elseif unitName == "npc_dota_hero_templar_assassin" then
        table.insert(arcanaData, {1, 1})
    elseif unitName == "npc_dota_hero_huskar" then
        table.insert(arcanaData, {1, 3})
        table.insert(arcanaData, {2, 1})
        table.insert(arcanaData, {3, 2})
    elseif unitName == "npc_dota_hero_legion_commander" then
        table.insert(arcanaData, {1, 1})
        table.insert(arcanaData, {2, 3})
        table.insert(arcanaData, {3, 2})
    elseif unitName == "npc_dota_hero_night_stalker" then
        table.insert(arcanaData, {1, 3})
        table.insert(arcanaData, {2, 2})
    elseif unitName == "npc_dota_hero_slardar" then
        table.insert(arcanaData, {1, 1})
        table.insert(arcanaData, {2, 3})
    elseif unitName == "npc_dota_hero_visage" then
        table.insert(arcanaData, {1, 0})
    elseif unitName == "npc_dota_hero_dark_seer" then
        table.insert(arcanaData, {1, 2})
        table.insert(arcanaData, {2, 3})
    elseif unitName == "npc_dota_hero_antimage" then
        table.insert(arcanaData, {1, 0})
        table.insert(arcanaData, {2, 3})
    elseif unitName == "npc_dota_hero_vengefulspirit" then
        table.insert(arcanaData, {1, 0})
        table.insert(arcanaData, {2, 3})
        table.insert(arcanaData, {3, 1})
    elseif unitName == "npc_dota_hero_monkey_king" then
        table.insert(arcanaData, {1, 3})
    elseif unitName == "npc_dota_hero_slark" then
        table.insert(arcanaData, {1, 2})
    elseif unitName == "npc_dota_hero_skywrath_mage" then
        table.insert(arcanaData, {1, 1})
    elseif unitName == "npc_dota_hero_winter_wyvern" then
        table.insert(arcanaData, {1, 1})
    elseif unitName == "npc_dota_hero_arc_warden" then
        table.insert(arcanaData, {1, 1})
    end
    return arcanaData
end

function RPCItems:RollRandomArcana(item_level)
    local arcanaTable = RPCItems:GetAllArcanaNames()
    local randomArcanaName = arcanaTable[RandomInt(1, #arcanaTable)]
    local arcana = RPCItems:RollArcanaByName(randomArcanaName, item_level)
    return arcana
end

function RPCItems:GetAllArcanaNames()
    local arcanaTable = {"item_rpc_flamewaker_arcana1", "item_rpc_flamewaker_arcana2", "item_rpc_voltex_arcana1", "item_rpc_venomort_arcana1", "item_rpc_venomort_arcana2", "item_rpc_axe_arcana1",
        "item_rpc_astral_arcana1", "item_rpc_astral_arcana2", "item_rpc_epoch_arcana1", "item_rpc_paladin_arcana1", "item_rpc_paladin_arcana2", "item_rpc_sorceress_arcana1", "item_rpc_sorceress_arcana2",
        "item_rpc_conjuror_arcana1", "item_rpc_seinaru_arcana1", "item_rpc_seinaru_arcana2", "item_rpc_warlord_arcana1", "item_rpc_bahamut_arcana1", "item_rpc_bahamut_arcana2", "item_rpc_trapper_arcana1",
        "item_rpc_spirit_warrior_arcana1", "item_rpc_spirit_warrior_arcana2", "item_rpc_spirit_warrior_arcana3", "item_rpc_mountain_protector_arcana1", "item_rpc_mountain_protector_arcana2", "item_rpc_mountain_protector_arcana3",
        "item_rpc_chernobog_arcana1", "item_rpc_chernobog_arcana2", "item_rpc_solunia_arcana1", "item_rpc_solunia_arcana2", "item_rpc_hydroxis_arcana1", "item_rpc_ekkan_arcana1", "item_rpc_zonik_arcana1",
        "item_rpc_zonik_arcana2", "item_rpc_arkimus_arcana1", "item_rpc_arkimus_arcana2", "item_rpc_djanghor_arcana1", "item_rpc_hydroxis_arcana2", "item_rpc_voltex_arcana2", "item_rpc_duskbringer_arcana1", "item_rpc_auriun_arcana1", "item_rpc_auriun_arcana2",
    "item_rpc_dinath_arcana1", "item_rpc_conjuror_arcana2", "item_rpc_conjuror_arcana3", "item_rpc_conjuror_arcana4", "item_rpc_axe_arcana2", "item_rpc_jex_arcana1", "item_rpc_slipfinn_arcana1"}
    return arcanaTable
end

function RPCItems:WorldDropArcanas()
    local arcanaTable = {"item_rpc_flamewaker_arcana1", "item_rpc_flamewaker_arcana2", "item_rpc_voltex_arcana1", "item_rpc_venomort_arcana1", "item_rpc_venomort_arcana2", "item_rpc_axe_arcana1",
        "item_rpc_astral_arcana1", "item_rpc_astral_arcana2", "item_rpc_epoch_arcana1", "item_rpc_paladin_arcana1", "item_rpc_sorceress_arcana1", "item_rpc_sorceress_arcana2",
        "item_rpc_conjuror_arcana1", "item_rpc_seinaru_arcana1", "item_rpc_seinaru_arcana2", "item_rpc_warlord_arcana1", "item_rpc_bahamut_arcana1", "item_rpc_trapper_arcana1",
        "item_rpc_mountain_protector_arcana1", "item_rpc_mountain_protector_arcana2", "item_rpc_mountain_protector_arcana3",
        "item_rpc_chernobog_arcana2", "item_rpc_solunia_arcana1", "item_rpc_solunia_arcana2", "item_rpc_ekkan_arcana1", "item_rpc_zonik_arcana1",
        "item_rpc_zonik_arcana2", "item_rpc_arkimus_arcana1", "item_rpc_djanghor_arcana1", "item_rpc_hydroxis_arcana2", "item_rpc_voltex_arcana2", "item_rpc_duskbringer_arcana1", "item_rpc_auriun_arcana1", "item_rpc_auriun_arcana2",
    "item_rpc_dinath_arcana1", "item_rpc_conjuror_arcana2", "item_rpc_conjuror_arcana3", "item_rpc_conjuror_arcana4", "item_rpc_axe_arcana2", "item_rpc_jex_arcana1"}
    return arcanaTable
end

function RPCItems:RollRandomWorldArcana(item_level)
    local arcanaTable = RPCItems:WorldDropArcanas()
    local randomArcanaName = arcanaTable[RandomInt(1, #arcanaTable)]
    local arcana = RPCItems:RollArcanaByName(randomArcanaName, item_level)
    return arcana
end

function RPCItems:RollArcanaByName(arcana_name, item_level)
    local arcana = nil
    if arcana_name == "item_rpc_flamewaker_arcana1" then
        arcana = RPCItems:RollFlamewakerArcana1(item_level)
    elseif arcana_name == "item_rpc_flamewaker_arcana2" then
        arcana = RPCItems:RollFlamewakerArcana2(item_level)
    elseif arcana_name == "item_rpc_voltex_arcana1" then
        arcana = RPCItems:RollVoltexArcana1(item_level)
    elseif arcana_name == "item_rpc_venomort_arcana1" then
        arcana = RPCItems:RollVenomortArcana1(item_level)
    elseif arcana_name == "item_rpc_venomort_arcana2" then
        arcana = RPCItems:RollVenomortArcana2(item_level)
    elseif arcana_name == "item_rpc_axe_arcana1" then
        arcana = RPCItems:RollAxeArcana1(item_level)
    elseif arcana_name == "item_rpc_astral_arcana1" then
        arcana = RPCItems:RollAstralArcana1(item_level)
    elseif arcana_name == "item_rpc_astral_arcana2" then
        arcana = RPCItems:RollAstralArcana2(item_level)
    elseif arcana_name == "item_rpc_epoch_arcana1" then
        arcana = RPCItems:RollEpochArcana1(item_level)
    elseif arcana_name == "item_rpc_paladin_arcana1" then
        arcana = RPCItems:RollPaladinArcana1(item_level)
    elseif arcana_name == "item_rpc_paladin_arcana2" then
        arcana = RPCItems:RollPaladinArcana2(item_level)
    elseif arcana_name == "item_rpc_sorceress_arcana1" then
        arcana = RPCItems:RollSorceressArcana1(item_level)
    elseif arcana_name == "item_rpc_sorceress_arcana2" then
        arcana = RPCItems:RollSorceressArcana2(item_level)
    elseif arcana_name == "item_rpc_conjuror_arcana1" then
        arcana = RPCItems:RollConjurorArcana1(item_level)
    elseif arcana_name == "item_rpc_seinaru_arcana1" then
        arcana = RPCItems:RollSeinaruArcana1(item_level)
    elseif arcana_name == "item_rpc_seinaru_arcana2" then
        arcana = RPCItems:RollSeinaruArcana2(item_level)
    elseif arcana_name == "item_rpc_warlord_arcana1" then
        arcana = RPCItems:RollWarlordArcana1(item_level)
    elseif arcana_name == "item_rpc_warlord_arcana2" then
        arcana = RPCItems:RollWarlordArcana2(item_level)
    elseif arcana_name == "item_rpc_bahamut_arcana1" then
        arcana = RPCItems:RollBahamutArcana1(item_level)
    elseif arcana_name == "item_rpc_bahamut_arcana2" then
        arcana = RPCItems:RollBahamutArcana2(item_level)
    elseif arcana_name == "item_rpc_duskbringer_arcana1" then
        arcana = RPCItems:RollDuskbringerArcana1(item_level)
    elseif arcana_name == "item_rpc_auriun_arcana1" then
        arcana = RPCItems:RollAuriunArcana1(item_level)
    elseif arcana_name == "item_rpc_auriun_arcana2" then
        arcana = RPCItems:RollAuriunArcana2(item_level)
    elseif arcana_name == "item_rpc_trapper_arcana1" then
        arcana = RPCItems:RollTrapperArcana1(item_level)
    elseif arcana_name == "item_rpc_spirit_warrior_arcana1" then
        arcana = RPCItems:RollSpiritWarriorArcana1(item_level)
    elseif arcana_name == "item_rpc_spirit_warrior_arcana2" then
        arcana = RPCItems:RollSpiritWarriorArcana2(item_level)
    elseif arcana_name == "item_rpc_spirit_warrior_arcana3" then
        arcana = RPCItems:RollSpiritWarriorArcana3(item_level)
    elseif arcana_name == "item_rpc_mountain_protector_arcana1" then
        arcana = RPCItems:RollMountainProtectorArcana1(item_level)
    elseif arcana_name == "item_rpc_mountain_protector_arcana2" then
        arcana = RPCItems:RollMountainProtectorArcana2(item_level)
    elseif arcana_name == "item_rpc_mountain_protector_arcana3" then
        arcana = RPCItems:RollMountainProtectorArcana3(item_level)
    elseif arcana_name == "item_rpc_chernobog_arcana1" then
        arcana = RPCItems:RollChernobogArcana1(item_level)
    elseif arcana_name == "item_rpc_chernobog_arcana2" then
        arcana = RPCItems:RollChernobogArcana2(item_level)
    elseif arcana_name == "item_rpc_solunia_arcana1" then
        arcana = RPCItems:RollSoluniaArcana1(item_level)
    elseif arcana_name == "item_rpc_solunia_arcana2" then
        arcana = RPCItems:RollSoluniaArcana2(item_level)
    elseif arcana_name == "item_rpc_solunia_arcana3" then
        arcana = RPCItems:RollSoluniaArcana3(item_level)
    elseif arcana_name == "item_rpc_hydroxis_arcana1" then
        arcana = RPCItems:RollHydroxisArcana1(item_level)
    elseif arcana_name == "item_rpc_ekkan_arcana1" then
        arcana = RPCItems:RollEkkanArcana1(item_level)
    elseif arcana_name == "item_rpc_zonik_arcana1" then
        arcana = RPCItems:RollZhonikArcana1(item_level)
    elseif arcana_name == "item_rpc_zonik_arcana2" then
        arcana = RPCItems:RollZhonikArcana2(item_level)
    elseif arcana_name == "item_rpc_arkimus_arcana1" then
        arcana = RPCItems:RollArkimusArcana1(item_level)
    elseif arcana_name == "item_rpc_arkimus_arcana2" then
        arcana = RPCItems:RollArkimusArcana2(item_level)
    elseif arcana_name == "item_rpc_djanghor_arcana1" then
        arcana = RPCItems:RollDjanghorArcana1(item_level)
    elseif arcana_name == "item_rpc_astral_arcana3" then
        arcana = RPCItems:RollAstralArcana3(item_level)
    elseif arcana_name == "item_rpc_sephyr_arcana1" then
        arcana = RPCItems:RollSephyrArcana1(item_level)
    elseif arcana_name == "item_rpc_hydroxis_arcana2" then
        arcana = RPCItems:RollHydroxisArcana2(item_level)
    elseif arcana_name == "item_rpc_voltex_arcana2" then
        arcana = RPCItems:RollVoltexArcana2(item_level)
    elseif arcana_name == "item_rpc_dinath_arcana1" then
        arcana = RPCItems:RollDinathArcana1(item_level)
    elseif arcana_name == "item_rpc_conjuror_arcana2" then
        arcana = RPCItems:RollConjurorArcana2(item_level)
    elseif arcana_name == "item_rpc_conjuror_arcana3" then
        arcana = RPCItems:RollConjurorArcana3(item_level)
    elseif arcana_name == "item_rpc_conjuror_arcana4" then
        arcana = RPCItems:RollConjurorArcana4(item_level)
    elseif arcana_name == "item_rpc_axe_arcana2" then
        arcana = RPCItems:RollAxeArcana2(item_level)
    elseif arcana_name == "item_rpc_jex_arcana1" then
        arcana = RPCItems:RollJexArcana1(item_level)
    elseif arcana_name == "item_rpc_slipfinn_arcana1" then
        arcana = RPCItems:RollSlipfinnArcana1(item_level)
    elseif arcana_name == "item_rpc_duskbringer_arcana2" then
        arcana = RPCItems:RollDuskbringerArcana2(item_level)
    end
    return arcana
end

function RPCItems:RollAndDropUniqueArcana(unit, item_name)
    local unit_level = unit:GetRoshpitLevel()
    local item_level = RPCItems:RollItemLevelFromUnit(unit_level)
    local arcana = RPCItems:RollArcanaByName(item_name, item_level)
    RPCItems:BasicDropItem(unit:GetAbsOrigin(), arcana)
    return arcana
end

function RPCItems:RollAndDropArcanaByLevel(position, item_level, item_name)
    local item_level = RPCItems:RollItemLevelFromUnit(item_level)
    local arcana = RPCItems:RollArcanaByName(item_name, item_level)
    RPCItems:BasicDropItem(position, arcana)
    return arcana
end

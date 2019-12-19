function RPCItems:RollRandomWorldArcana(item_level)
    return nil
end

function RPCItems:RollRuneType(letters, tiersTable)
    local luck = RandomInt(1,100)
    local letter = letters[RandomInt(1, #letters)]
    rune_tier = "1"
    for i = 1, 4, 1 do
        local tier_key = "tier"..i
        if tiersTable[tier_key] and luck <= tiersTable[tier_key] then
            rune_tier = i
            break
        end
    end
    rune_roll = "rune_"..letter.."_"..rune_tier
    return rune_roll
end

function RPCItems:RollSandTombOrb(xpBounty, deathLocation, rarity, isShop, type, hero)
    local itemVariant = "item_rpc_sand_tomb_orb"
    local item = RPCItems:CreateItem(itemVariant, nil, nil)

    item.newItemTable.rarity = "immortal"
    local rarityValue = RPCItems:GetRarityFactor(rarity)
    local itemName = "Fangs of Silithicus"
    local suffix = ""
    local prefix = ""
    item.newItemTable.slot = "amulet"
    item.newItemTable.gear = true

    local tier, value, propertyName = RPCItems:RollSlithicusRingProperty()
    item.newItemTable.property1 = value
    item.newItemTable.property1name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)
    local attr = RandomInt(100, 200)
    item.newItemTable.property2 = attr
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    item.newItemTable.property3 = attr
    item.newItemTable.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_strength", "#CC0000", 3)
    item.newItemTable.property4 = RandomInt(20, 40)
    item.newItemTable.property4name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "#item_armor", "#D1D1D1", 4)

    RPCItems:SetTableValues(item, itemName, false, "Slot: Trinket", RPCItems:GetRarityColor(rarity), rarity, "", "", RPCItems:GetRarityFactor(rarity))
    if isShop then
        RPCItems:GiveItemToHero(hero, item)
    else
        local drop = CreateItemOnPositionSync(deathLocation, item)
        local position = deathLocation + RandomVector(RandomInt(200, 400))
        RPCItems:DropItem(item, position)
    end
end

function RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    RPCItems:ItemUpdateCustomNetTables(item)
    if isShop then
        RPCItems:GiveItemToHero(RPCItems.vendorHero, item)
        RPCItems.vendorHero = nil
    else
        local drop = CreateItemOnPositionSync(deathLocation, item)
        local position = deathLocation
        RPCItems:DropItem(item, position)
    end
end

function RPCItems:RollSlithicusRingProperty()
    local luck = RandomInt(0, 400)
    local luck2 = RandomInt(1, 100)
    local propertyName = ""
    local propertyTitle = ""
    local tier = 0
    -- if luck2 < 20 then
    --     value = RandomInt(25, 30)
    -- elseif luck2 < 50 then
    --     value = RandomInt(30, 35)
    -- elseif luck2 < 80 then
    --     value = RandomInt(35, 40)
    -- elseif luck2 < 95 then
    --     value = RandomInt(40, 45)
    -- elseif luck2 <= 100 then
    --     value = RandomInt(45, 50)
    -- end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = RPCItems:GetLogarithmicVarianceValue(math.ceil(maxFactor / 3.5), 0, 0, 0, 0)
    if luck < 100 then
        propertyName = "rune_q_1"
        tier = 1
    elseif luck < 200 then
        propertyName = "rune_w_1"
        tier = 1
    elseif luck < 300 then
        propertyName = "rune_e_1"
        tier = 1
    elseif luck < 405 then
        propertyName = "rune_r_1"
        tier = 1
    end
    return value
end

function RPCItems:CreateVariant(variantName, rarityName, itemNameText, slot, gear, slotText)
    local item = RPCItems:CreateItem(variantName, nil, nil)
    item.newItemTable.qualityName = rarityName
    item.newItemTable.rarity = rarityName
    item.newItemTable.rarityFactor = RPCItems:GetRarityFactor(item.newItemTable.rarity)
    item.newItemTable.itemPrefix = ""
    item.newItemTable.itemSuffix = ""
    item.newItemTable.item_slot = slot
    item.newItemTable.gear = gear
    item.newItemTable.consumable = nil
    item.newItemTable.gear_slot = RPCItems:getGearSlot(slot)
    RPCItems:SetTableValues(item, itemNameText, item.newItemTable.consumable, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, "", "", RPCItems:GetRarityFactor(item.newItemTable.rarity))

    return item
end

function RPCItems:CreateVariantWithHero(variantName, rarityName, itemNameText, slot, gear, slotText, requiredHero)
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
    RPCItems:SetTableValues(item, itemNameText, item.newItemTable.consumable, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, "", "", RPCItems:GetRarityFactor(item.newItemTable.rarity))

    return item
end

function RPCItems:CreateVariantWithMin(variantName, rarityName, itemNameText, slot, gear, slotText, minLevel, prefix, suffix)
    local item = RPCItems:CreateItem(variantName, nil, nil)
    if _G[variantName] then
        item:OnLoadItem()
    end
    item.newItemTable.qualityName = rarityName
    item.newItemTable.rarity = rarityName
    item.newItemTable.rarityFactor = RPCItems:GetRarityFactor(item.newItemTable.rarity)
    if not prefix then
        prefix = ""
    end
    if not suffix then
        suffix = ""
    end
    item.newItemTable.itemPrefix = prefix
    item.newItemTable.itemSuffix = suffix
    item.newItemTable.item_slot = slot
    item.newItemTable.gear = gear
    item.newItemTable.consumable = nil
    item.newItemTable.minLevel = minLevel
    item.newItemTable.gear_slot = RPCItems:getGearSlot(slot)
    RPCItems:SetTableValues(item, itemNameText, item.newItemTable.consumable, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, prefix, suffix, RPCItems:GetRarityFactor(item.newItemTable.rarity))

    return item
end



function RPCItems:CreateConsumable(variantName, rarityName, itemNameText, slot, gear, slotText, useDescription)
    local item = RPCItems:CreateItem(variantName, nil, nil)
    item.newItemTable.qualityName = rarityName
    item.newItemTable.rarity = rarityName
    item.newItemTable.rarityFactor = RPCItems:GetRarityFactor(item.newItemTable.rarity)
    item.newItemTable.itemPrefix = ""
    item.newItemTable.itemSuffix = ""
    item.newItemTable.item_slot = slot
    item.newItemTable.gear = gear
    item.newItemTable.consumable = nil
    item.newItemTable.stackable = true
    item.newItemTable.stashable = true
    RPCItems:SetTableValues(item, itemNameText, item.newItemTable.consumable, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, "", "", RPCItems:GetRarityFactor(item.newItemTable.rarity))

    item.newItemTable.qualityColor = RPCItems:GetRarityColor(item.newItemTable.rarity)
    item.newItemTable.itemDescription = slotText
    item.newItemTable.qualityName = rarityName
    item.newItemTable.stackedConsumable = true
    item.newItemTable.minLevel = 0
    item.newItemTable.useDescription = useDescription
    -- CustomNetTables:SetTableValue("item_basics", tostring(itemIndex), item.newItemTable)
    RPCItems:ItemUpdateCustomNetTables(item)
    return item
end

function RPCItems:CreateUnstashable(variantName, rarityName, itemNameText, slot, gear, slotText, useDescription)
    local item = RPCItems:CreateItem(variantName, nil, nil)
    item.newItemTable.qualityName = rarityName
    item.newItemTable.rarity = rarityName
    item.newItemTable.rarityFactor = RPCItems:GetRarityFactor(item.newItemTable.rarity)
    item.newItemTable.itemPrefix = ""
    item.newItemTable.itemSuffix = ""
    item.newItemTable.item_slot = slot
    item.newItemTable.gear = gear
    item.newItemTable.consumable = nil
    item.newItemTable.cantStash = true
    RPCItems:SetTableValues(item, itemNameText, item.newItemTable.consumable, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, "", "", RPCItems:GetRarityFactor(item.newItemTable.rarity))

    item.newItemTable.qualityColor = RPCItems:GetRarityColor(item.newItemTable.rarity)
    item.newItemTable.itemDescription = slotText
    item.newItemTable.qualityName = rarityName
    item.newItemTable.stackedConsumable = false
    item.newItemTable.minLevel = 0
    item.newItemTable.useDescription = useDescription
    -- CustomNetTables:SetTableValue("item_basics", tostring(itemIndex), item.newItemTable)
    RPCItems:ItemUpdateCustomNetTables(item)
    return item
end

function RPCItems:RollSteelbarkPlate(hero)

    local item = RPCItems:CreateVariant("item_rpc_steelbark_guard", "immortal", "Steelbark Guard", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "steelbark"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_steelbark", "#ADFF5C", 1, "#property_steelbark_description")

    local primaryAttribute = hero:GetRoshpitPrimaryAttribute()
    item.newItemTable.property2 = RandomInt(80, 120)
    if primaryAttribute == 0 then
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    elseif primaryAttribute == 1 then
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    else
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    item.newItemTable.isShop = true
    RPCItems:GiveItemToHero(hero, item)
end



function RPCItems:RollMagebaneRuneProperty()
    local luck = RandomInt(0, 905)
    local luck2 = RandomInt(1, 100)
    local propertyName = ""
    local propertyTitle = ""
    local tier = 0
    local maxFactor = RPCItems:GetMaxFactor()
    if luck2 < 20 then
        value = RandomInt(3, 4)
    elseif luck2 < 50 then
        value = RandomInt(4, 5)
    elseif luck2 < 80 then
        value = RandomInt(5, 6)
    elseif luck2 < 95 then
        value = RandomInt(6, 7)
    elseif luck2 <= 100 then
        value = RandomInt(7, 10)
    end
    if luck < 140 then
        propertyName = "rune_q_1"
        tier = 1
    elseif luck < 240 then
        propertyName = "rune_w_1"
        tier = 1
    elseif luck < 360 then
        propertyName = "rune_e_1"
        tier = 1
    elseif luck < 485 then
        propertyName = "rune_r_1"
        tier = 1
    elseif luck < 590 then
        propertyName = "rune_q_2"
        tier = 2
    elseif luck < 695 then
        propertyName = "rune_w_2"
        tier = 2
    elseif luck < 800 then
        propertyName = "rune_e_2"
        tier = 2
    elseif luck < 910 then
        propertyName = "rune_r_2"
        tier = 2
    end
    ----print("VALUE".. value)
    value = value + RandomInt(math.floor(maxFactor / 15), math.floor(maxFactor / 7))
    ----print("ADJUSTED VALUE".. value)
    return tier, value, propertyName
end


--HATS

function RPCItems:RollAutumnSleeperMask(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL
    local item = RPCItems:CreateVariant("item_rpc_autumn_sleeper_mask", "immortal", "Autumn Sleeper Mask", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_autumn_sleeper_mask"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_autumn_sleeper", "#BF5050", 1, "#property_autumn_sleeper_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    else
        local rune_tier = "t"..RandomInt(1, 2).."_rune"
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_tier, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)

    RPCItems:SetBaseItemValues(item, "item_rpc_autumn_sleeper_mask", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollArcaneCascadeHat(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_arcane_cascade_hat", "immortal", "Arcane Cascade Hat", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_arcane_cascade_hat"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arcane_cascade", "#E558F5", 1, "#property_arcane_cascade_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_mana", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SetBaseItemValues(item, "item_rpc_arcane_cascade_hat", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    RPCItems:SocketsChance(item)
    return item
end

function RPCItems:RollSamuraiHelmet(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL
    local item = RPCItems:CreateVariant("item_rpc_adamantine_samurai_helmet", "immortal", "Adamantine Samurai Helmet", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_samurai_helmet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_samurai_helmet", "#2ac955", 1, "#property_samurai_helmet_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "attack_damage", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SetBaseItemValues(item, "item_rpc_adamantine_samurai_helmet", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    RPCItems:SocketsChance(item)
    return item
end

function RPCItems:RollBasiliskPlagueHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_basilisk_plague_helm", "immortal", "Basilisk Plague Helm", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_basilisk_plague_helm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_basilisk_plague", "#93B058", 1, "#property_basilisk_plague_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "health_regen", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_poison", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)

    RPCItems:SetBaseItemValues(item, "item_rpc_basilisk_plague_helm", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBlackfeatherCrown(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_blackfeather_crown", "immortal", "Blackfeather Crown", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_blackfeather_crown"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blackfeather", "#615C6E", 1, "#property_blackfeather_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    else
        local rune_tier = "t"..RandomInt(1, 2).."_rune"
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_tier, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)

    RPCItems:SetBaseItemValues(item, "item_rpc_blackfeather_crown", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGlintOfOnu(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_blinded_glint_of_onu", "immortal", "Blinded Glint of Onu", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_blinded_glint_of_onu"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_glint_of_onu", "#9DCCC2", 1, "#property_glint_of_onu_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)

    RPCItems:SetBaseItemValues(item, "item_rpc_blinded_glint_of_onu", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBrazenKabuto(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_brazen_kabuto_of_the_desert_realm", "immortal", "Brazen Kabuto of the Desert Realm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_brazen_kabuto"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_brazen_kabuto", "#A87D4C", 1, "#property_brazen_kabuto_description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 2)
    else
        local rune_property = RPCItems:RollArcanaRuneForSlot("r")
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_property, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)

    RPCItems:SetBaseItemValues(item, "item_rpc_brazen_kabuto_of_the_desert_realm", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBurningSpiritHelmet(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_burning_spirit_helmet", "immortal", "Burning Spirit Helmet", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_burning_spirit_helmet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_burning_spirit", "#D6B948", 1, "#property_burning_spirit_description")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_burning_spirit_helmet", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCapOfWildNature(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_cap_of_wild_nature", "immortal", "Cap of Wild Nature", "head", true, "Slot: Head")
    local luck = RandomInt(1, 4)
    if luck == 1 then
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "!immortal!_modifier_cap_of_wild_nature1"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature", "#573E2F", 1, "#property_wild_nature_description")
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    elseif luck == 2 then
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "!immortal!_modifier_cap_of_wild_nature2"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature_two", "#573E2F", 1, "#property_wild_nature_two_description")
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    elseif luck == 3 then
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "!immortal!_modifier_cap_of_wild_nature1"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature", "#573E2F", 1, "#property_wild_nature_description")
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "!immortal!_modifier_cap_of_wild_nature2"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature_two", "#573E2F", 2, "#property_wild_nature_two_description")
    elseif luck == 4 then
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "!immortal!_modifier_cap_of_wild_nature2"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature_two", "#573E2F", 1, "#property_wild_nature_two_description")
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "!immortal!_modifier_cap_of_wild_nature1"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature", "#573E2F", 2, "#property_wild_nature_description")
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_cap_of_wild_nature", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCarbuncleHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_carbuncles_helm_of_reflection", "immortal", "Carbuncle's Helm of Reflection", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_carbuncles_helm_of_reflection"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_carbuncle", "#B85454", 1, "#property_carbuncle_description")

-- {skill_points = skill_points, rune_points = Runes.RUNE_POINTS_PER_LEVEL}
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    local luck = RandomInt(1, 10)
    if luck < 10 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end
    local luck = RandomInt(1, 10)
    if luck == 10 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "t3_rune", 0.8)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_carbuncles_helm_of_reflection", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCentaurHorns(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_centaur_horns", "immortal", "Sturdy Centaur Horns", "head", true, "Slot: Head")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_centaur_horns"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_centaur_horns", "#876852", 1, "#property_centaur_horns_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_centaur_horns", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollChainsOfOrthok(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_chains_of_orthok", "immortal", "Chains of Orthok", "head", true, "Slot: Head")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_chains_of_orthok"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_chains_of_orthok", "#E8F43F", 1, "#property_chains_of_orthok_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_chains_of_orthok", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCrestOfTheUmbralSentinel(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_crest_of_the_umbral_sentinel", "immortal", "Crest of the Umbral Sentinel", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_crest_of_the_umbral_sentinel"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_umbral", "#90C3D4", 1, "#property_umbral_description")

    local luck = RandomInt(1, 10)
    if luck <= 5 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "rune_w_1", 1.2)
    elseif luck <= 9 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "rune_w_2", 1.2)
    elseif luck == 10 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "rune_w_3", 1.2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 1.2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_crest_of_the_umbral_sentinel", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCrimsonSkullCap(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL
    
    local item = RPCItems:CreateVariant("item_rpc_crimson_skull_cap", "immortal", "Crimson Skull Cap", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_crimson_skull_cap"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_crimson_skull_cap", "#C25D55", 1, "#property_crimson_skull_cap_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "max_health", 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_crimson_skull_cap", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRubyDragonCrown(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_crown_of_ruby_dragon", "immortal", "Crown of Ruby Dragon", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_crown_of_ruby_dragon"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ruby_dragon", "#BD2A2A", 1, "#property_ruby_dragon_description")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_crown_of_ruby_dragon", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollLavaForgeCrown(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_crown_of_the_lava_forge", "immortal", "Crown of the Lava Forge", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_crown_of_the_lava_forge"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_lava_forge", "#EB6A59", 1, "#property_lava_forge_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_crown_of_the_lava_forge", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRoknarEmperor(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_crown_of_the_roknar_emperor", "immortal", "Crown of the Rok'nar Emperor", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_crown_of_the_roknar_emperor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_roknar_emperor", "#72BD28", 1, "#property_roknar_emperor_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_health", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_crown_of_the_roknar_emperor", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDarkReefSharkHelmet(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_dark_reef_shark_helmet", "immortal", "Dark Reef Shark Helmet", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_dark_reef_shark_helmet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_shark_helmet", "#A7BAB7", 1, "#property_shark_helmet_Description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, "item_rpc_dark_reef_shark_helmet", false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDeathWhisperHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_death_whisper_helm", "immortal", "Death Whisper Helm", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_death_whisper_helm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_death_whisper", "#4A6A8C", 1, "#property_death_whisper_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.2)
    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDemonMask(item_level, waveBonus)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_demon_mask", "immortal", "Demon Mask", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_demon_mask"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_demon", "#C91818", 1, "#property_demon_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "t3_rune", 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEmeraldDouli(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_emerald_douli", "immortal", "Emerald Douli", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_emerald_douli"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_emerald_douli", "#1DDB49", 1, "#property_emerald_douli_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.2)

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "max_mana", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "max_health", 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollExcavatorsFocusHat(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_excavators_focus_cap", "immortal", "Excavator's Focus Cap", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_excavators_focus_cap"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_excavator", "#7300DE", 1, "#property_excavator_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local attr_rolls = {"strength", "agility", "intelligence", "spirit", "base_ability"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "item_damage", 2.5)
    end

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 2)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEyeOfSeasons(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_eye_of_seasons", "immortal", "Eye of Seasons", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_eye_of_seasons"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_eye_of_seasons", "#E8985F", 1, "#property_eye_of_seasons_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFireDeityCrown(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_fire_deity_crown", "immortal", "Fire Deity Crown", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_fire_deity_crown"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fire_deity", "#E85A4A", 1, "#property_fire_deity_description")

    local rune_type = RPCItems:RollRuneType({"w"}, {tier3 = 80, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "element_fire", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFrostmawHuntersHood(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_frostmaw_hunters_hood", "immortal", "Frostmaw Hunter's Hood", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_frostmaw_hunters_hood"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_frostmaw", "#ff443a", 1, "#property_frostmaw_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_health", 2)

    local luck = RandomInt(1, 5)
    if luck == 5 and item_level > 60 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier3 = 80, tier4 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGuardOfGrithault(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_guard_of_grithault", "immortal", "Guard of Grithault", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_guard_of_grithault"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_grithault", "#34E039", 1, "#property_grithault_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollLumaGuard(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_guard_of_luma", "immortal", "Guard of Luma", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_guard_of_luma"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_luma", "#B8A3E3", 1, "#property_luma_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_cosmic", 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollChampionsGearHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_helm_of_champions", "immortal", "champions_gear", "head", true, "Slot: Head")
    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, "rune_q_4", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHelmOfKnightHawk(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_helm_of_the_knight_hawk", "immortal", "Helm of the Knight Hawk", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_knight_hawk_helm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_knight_hawk", "#3dd1a7", 1, "#property_knight_hawk_description")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit", "movespeed"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1.3)   
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHelmOfTheMountainGiant(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_helm_of_the_mountain_giant", "immortal", "Helm Of The Mountain Giant", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_helm_of_the_mountain_giant"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_giant", "#C95226", 1, "#property_mountain_giant_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2)   
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHelmOfSilentTemplar(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_helm_of_the_silent_templar", "immortal", "Helm of the Silent Templar", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_helm_of_silent_templar"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_helm_of_silent_templar", "#9FC1ED", 1, "#property_helm_of_silent_templar_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHoodOfChosen(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_hood_of_chosen", "immortal", "Hood of the Chosen", "head", true, "Slot: Head")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, rune_type, 1.5)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHoodOfDefiler(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_hood_of_defiler", "immortal", "Hood of the Defiler", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_hood_of_defiler"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hood_of_defiler", "#B36481", 1, "#property_hood_of_defiler_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_demon", 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHoodOfBlackMage(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_hood_of_the_black_mage", "immortal", "Hood of the Black Mage", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_hood_of_the_black_mage"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_black_mage", "#A9B023", 1, "#property_black_mage_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "base_ability", 1.6)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end


function RPCItems:RollHoodOfTheSeaOracle(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_hood_of_the_sea_oracle", "immortal", "Hood of the Sea Oracle", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_hood_of_the_sea_oracle"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_sea_oracle", "#FFBC49", 1, "#property_sea_oracle_Description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "t4_rune", 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHyperVisor(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_hyper_visor", "immortal", "Hyper Visor", "head", true, "Slot: Head")
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_hyper_visor"
    RPCItems:SetPropertyValuesSpecial(item, 0, "#item_property_hyper_visor", "#3CB7E8",  1, "#property_hyper_visor_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_speed", 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollIgneousCanineHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_igneous_canine_helm", "immortal", "Igneous Canine Helm", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_igneous_canine_helm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_igneous_canine", "#EDDA61", 1, "#property_igneous_canine_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.2)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMagistratesHood(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_magistrates_hood", "immortal", "Magistrate's Hood", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_magistrates_hood"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_magistrate", "#fab60a", 1, "#property_magistrate_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "t3_rune", 1)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMugatoMask(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_mask_of_mugato", "immortal", "Mask of Mugato", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mask_of_mugato"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mugato", "#26E0C1", 1, "#property_mugato_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollNecromancerMask(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_mask_of_the_desert_necromancer", "immortal", "Mask of the Desert Necromancer", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mask_of_the_desert_necromancer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_desert_necromancer", "#B38C66", 1, "#property_desert_necromancer_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollPhantomSorcererMask(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_mask_of_the_phantom_sorcerer", "immortal", "Mask of the Phantom Sorcerer", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mask_of_the_phantom_sorcerer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_phantom_sorcerer", "#02F21E", 1, "#property_phantom_sorcerer_description")

    local luck = RandomInt(1, 7)
    if luck < 7 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "t3_rune", 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMaskOfTyrius(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_mask_of_tyrius", "immortal", "Mask of Tyrius", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mask_of_tyrius"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tyrius", "#D6693A", 1, "#property_tyrius_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "strength", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollOceanHelmOfValdun(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ocean_helm_of_valdun", "immortal", "Ocean Helm of Val'Dun", "head", true, "Slot: Head")

    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, "all_elements", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "t4_rune", 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.2)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollOdinHelmet(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_odin_helmet", "immortal", "Odin Helmet", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_odin_helmet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_odin", "#82A6B3", 1, "#property_odin_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollScourgeKnightHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_scourge_knights_helm", "immortal", "Scourge Knight's Helm", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_scourge_knights_helm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_scourge_knight", "#2A194F", 1, "#property_scourge_knight_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)
    local luck = RandomInt(1, 3)
    if luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "element_undead", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollShipyardVeil(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_shipyard_veil_lv1", "immortal", "Shipyard Veil LV1", "head", true, "Slot: Head")
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_shipyard_veil"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_shipyard_veil", "#91F2F1", 1, "#property_shipyard_veil_description")

    local rune_type = RPCItems:RollRuneType({"q"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEternalNightShroud(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_shroud_of_eternal_night", "immortal", "Shroud of Eternal Night", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_shroud_of_eternal_night"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_eternal_night", "#494F63", 1, "#property_eternal_night_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_shadow", 1.5)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollStormcrackHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_stormcrack_helm", "immortal", "Stormcrack Helm", "head", true, "Slot: Head")
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_stormcrack_helm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_stormcrack", "#EFF2AE", 1, "#property_stormcrack_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    else
        local attr_rolls = {"strength", "agility"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSuperAscendency(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_super_ascendency_mask", "immortal", "Super Ascendency Mask", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_super_ascendency_mask"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_super_ascendency", "#E89300", 1, "#property_super_ascendency_description")

    local attr_rolls = {"strength", "agility", "attack_speed", "all_attributes", "rune_r_1", "rune_r_2"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "attack_damage", 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end


function RPCItems:RollSwampDoctorMask(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_swamp_doctors_tribal_mask", "immortal", "Swamp Doctor's Tribal Mask", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_swamp_doctors_tribal_mask"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_swamp_doctor", "#61AD64", 1, "#property_swamp_doctor_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1.5)
    elseif luck == 2 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWitchHat(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_swamp_witch_hat", "immortal", "Swamp Witch's Hat", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_swamp_witch_hat"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_swamp_witch", "#7300DE", 1, "#property_swamp_witch_description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_shadow", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTricksterMask(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_tricksters_mask", "immortal", "Trickster's Mask", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_tricksters_mask"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_trickster", "#FFFB17", 1, "#property_trickster_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTwistedMaskOfAhnqhirBlue(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_twisted_blue_mask_of_ahnqhir", "immortal", "Twisted Blue Mask of Ahn'qhir", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mask_of_ahnqhir_blue"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_twisted_mask_of_ahnqhir_c", "#6BB5F9", 1, "#property_twisted_mask_of_ahnqhir_c_Description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "rune_e_3", 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTwistedMaskOfAhnqhirPurple(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_twisted_purple_mask_of_ahnqhir", "immortal", "Twisted Purple Mask of Ahn'qhir", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mask_of_ahnqhir_purple"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_twisted_mask_of_ahnqhir_a", "#BC60F2", 1, "#property_twisted_mask_of_ahnqhir_a_Description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "rune_q_3", 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTwistedMaskOfAhnqhirYellow(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_twisted_yellow_mask_of_ahnqhir", "immortal", "Twisted Yellow Mask of Ahn'qhir", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mask_of_ahnqhir_yellow"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_twisted_mask_of_ahnqhir_b", "#EBFF6D", 1, "#property_twisted_mask_of_ahnqhir_b_Description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "rune_w_3", 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollUndertakersHood(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_undertakers_hood", "immortal", "Undertaker's Hood", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_undertakers_hood"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_undertaker", "#3E8A2B", 1, "#property_undertaker_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCeruleanHighguard(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_veil_of_the_cerulean_high_guard", "immortal", "Veil of the Cerulean Highguard", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_cerulean_high_guard"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_cerulean_highguard", "#1D35D1", 1, "#property_cerulean_highguard_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDruidsSpiritHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_wolfir_druids_spirit_helm", "immortal", "Wolfir Druid's Spirit Helm", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_druid_spirit_helm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_druids_spirt", "#9DCCC2", 1, "#property_druids_spirit_description")

    local attr_rolls = {"strength", "agility"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)

    local attr_rolls = {"intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, attr_roll, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWraithCrown(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_wraith_crown", "immortal", "Wraith Crown", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_rpc_wraith_crown"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wraith_crown", "#5671E8", 1, "#property_wraith_crown_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWraithHuntersSteelHelm(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_wraith_hunters_steel_helm", "immortal", "Wraith Hunter's Steel Helm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_wraith_hunters_steel_helm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wraith_hunter", "#55A9ED", 1, "#property_wraith_hunter_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

-- BODY

function RPCItems:RollAlienArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_alien_armor", "immortal", "Sea Giant's Plate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_alien_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_alien_armor", "#47471b", 1, "#property_alien_armor_Description")

    if GameState:GetDifficultyFactor() > 2 then
        local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.2)
    else
        local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 45, tier2 = 90, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTanariWindArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ancient_tanari_wind_armor", "immortal", "Ancient Tanari Wind Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_tanari_wind_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tanari_wind_armor", "#C5E7FC", 1, "#property_tanari_wind_armor_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.5)

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSecretTempleArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_armor_of_secret_temple", "immortal", "Armor of the Secret Temple", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_secret_temple"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_secret_temple", "#CE87E6", 1, "#property_secret_temple_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVioletGuardArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_armor_of_violet_guard", "immortal", "Armor of Violet Guard", "body", true, "Slot: Body")
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_armor_of_violet_guard"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_violet_guard_armor", "#A337E6", 1, "#property_violet_guard_armor_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAvalanchePlate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_avalanche_plate", "immortal", "Avalanche Plate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_avalanche_plate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_avalanche", "#9C8C81",  1, "#property_avalanche_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBaronsStormArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_barons_storm_armor", "immortal", "Barons Storm Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_barons_storm_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_baron_storm", "#96DCFF", 1, "#property_baron_storm_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_lightning", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 2)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBladestormVest(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_bladestorm_vest", "immortal", "Bladestorm Vest", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_bladestorm_vest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bladestorm_vest", "#DE2644", 1, "#property_bladestorm_vest_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.6)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBlazingFuryArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_blazing_fury_armor", "immortal", "Blazing Fury Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_blazing_fury"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blazing_fury_armor", "#C1513E", 1, "#property_blazing_fury_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBluestarArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_bluestar_armor", "immortal", "Bluestar Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_bluestar_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bluestar_armor", "#285EBD", 1, "#property_bluestar_armor_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "mana_regen", 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBorealGraniteVest(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_boreal_granite_vest", "immortal", "Boreal Granite Vest", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_boreal_granite_vest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_boreal_granite", "#9EE0FF", 1, "#property_boreal_granite_description")

    local rune_type = RPCItems:RollRuneType({"q"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.8)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCaptainsVest(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_captains_vest", "immortal", "Captains Vest", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_captains_vest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_captains_vest", "#4FCCB1", 1, "#property_captains_vest_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_t1_runes", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_t2_runes", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollChampionsGearMail(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_champions_mail", "immortal", "champions_gear", "body", true, "Slot: Body")

    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, "rune_r_4", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDarkArtsVestments(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_dark_arts_vestments", "immortal", "Vestments of the Dark Arts", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_dark_arts_vestments"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_dark_arts", "#7A3B63", 1, "#property_dark_arts_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDepthCrestArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_depth_crest_armor", "immortal", "Depth Crest Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_depth_crest_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_depth_crest", "#6877E8", 1, "#property_depth_crest_description")

    local luck = RandomInt(1, 3)
    if luck == 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDirewolfBulwark(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_direwolf_bulwark", "immortal", "Direwolf Bulwark", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_direwolf_bulwark"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_direwolf", "#502AA3", 1, "#property_direwolf_description")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit", "armor_pierce"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDoomplate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_doomplate", "immortal", "Doomplate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_doomplate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_doomplate", "#E85920", 1, "#property_doomplate_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)
    else
        local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDragonCeremonyVestments(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_dragon_ceremony_vestments", "immortal", "Vestments of the Dragon Ceremony", "body", true, "Slot: Body")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, rune_type, 1)
    else
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, attr_roll, 1.5)
    end

    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    else
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEmpyrealSunriseRobe(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_empyreal_sunrise_robe", "immortal", "Empyreal Sunrise Robe", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_empyreal_sunrise_robe"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_tropical_sunrise", "#F7E37E", 1, "#property_tropical_sunrise_Description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEnchantedSolarCape(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_enchanted_solar_cape", "immortal", "Enchanted Solar Cape", "body", true, "Slot: Body")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_enchanted_solar_cape"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_enchanted_solar", "#EBB523", 1, "#property_enchanted_solar_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFeatherwhiteArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_featherwhite_armor", "immortal", "Featherwhite Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_featherwhite_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_featherwhite_armor", "#FFFFFF", 1, "#property_featherwhite_armor_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGildedSoulCage(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL
    
    local item = RPCItems:CreateVariant("item_rpc_gilded_soul_cage", "immortal", "Gilded Soul Cage", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_gilded_soul_cage"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gilded_soul", "#B0C930", 1, "#property_gilded_soul_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_holy", 2)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    elseif luck == 4 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spirit", 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGoldenWarPlate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_golden_war_plate", "immortal", "Golden War Plate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_golden_war_plate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gold_war_plate", "#E8E83C", 1, "#property_gold_war_plate_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level,  "armor", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGoldPlateOfLeon(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_gold_plate_of_leon", "immortal", "Gold Plate of Leon", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_gold_plate_of_leon"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gold_plate_of_leon", "#E6E617", 1, "#property_gold_plate_of_leon_description")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGuardOfFeronia(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_guard_of_feronia", "immortal", "Guard of Feronia", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_guard_of_feronia"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_guard_of_feronia", "#D67CC9", 1, "#property_guard_of_feronia_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "rune_q_3", 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHermitSpikeShell(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_hermits_spike_shell", "immortal", "Hermit's Spike Shell", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_hermit_spike_shell"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hermit_spike_shell", "#CDD17B", 1, "#property_hermit_spike_shell_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHeroicConquerorVestments(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_heroic_conqueror_vestments", "immortal", "heroic conqueror", "body", true, "Slot: Body")

    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, "rune_q_4", 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "rune_e_4", 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "rune_e_4", 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, "rune_r_4", 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHurricaneVest(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_hurricane_vest", "immortal", "Hurricane Vest", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_hurricane_vest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hurricane", "#5A54C4", 1, "#property_hurricane_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_wind", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollIceQuillCarapace(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ice_quill_carapace", "immortal", "Ice Quill Carapace", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_ice_quill_carapace"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ice_quill", "#6FD2F2", 1, "#property_ice_quill_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_mana", 1.5)

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "armor", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "magic_armor", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMageplate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_infused_mageplate", "immortal", "Infused Mageplate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_infused_mageplate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mageplate", "#B05CFF", 1, "#property_mageplate_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollLegionVestments(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_legion_vestments", "immortal", "Legion Vestments", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_legion_vestments"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_legion_vestments", "#D45757", 1, "#property_legion_vestments_description")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1.5)

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, attr_roll, 1.75)

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, attr_roll, 2.0)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMysticManaWall(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_mystic_mana_wall", "immortal", "Mystic Mana Wall", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mystic_mana_wall"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mystic_mana_wall", "#5FCFF5", 1, "#property_mystic_mana_wall_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_mana", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:NethergraspPalisade(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_nethergrasp_palisade", "immortal", "nethergrasp Palisade", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_nethergrasp_palisade"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_nethergrasp", "#78f0ec", 1, "#property_nethergrasp_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    elseif luck == 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    end
    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "t3_rune", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollNightmareRiderMantle(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_nightmare_rider_mantle", "immortal", "Nightmare Rider Mantle", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_nightmare_rider"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_nightmare_rider", "#423670", 1, "#property_nightmare_rider_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_shadow", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollOceanTempestPallium(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ocean_tempest_pallium", "immortal", "Ocean Tempest Pallium", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_ocean_tempest_pallium"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ocean_tempest", "#4C74A8", 1, "#property_ocean_tempest_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    else
        local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollOutlandStoneCuirass(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_outland_stone_cuirass", "immortal", "Outland Stone Cuirass", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_outland_stone_cuirass"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_outland_stone", "#FFB668", 1, "#property_outland_stone_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_health", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWatcherPlate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_plate_of_the_watcher", "immortal", "Plate of the Watcher", "body", true, "Slot: Body")
    local luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "!immortal!_modifier_plate_of_the_watcher1"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watcher_one", "#64A4CC", 1, "#property_watcher_one_description")
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, nil, 1.35)
    end

    luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "!immortal!_modifier_plate_of_the_watcher2"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watcher_two", "#64A4CC", 2, "#property_watcher_two_description")
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.35)
    end

    luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property3 = 1
        item.newItemTable.property3name = "!immortal!_modifier_plate_of_the_watcher3"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watcher_three", "#64A4CC", 3, "#property_watcher_three_description")
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.35)
    end

    luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property4 = 1
        item.newItemTable.property4name = "!immortal!_modifier_plate_of_the_watcher4"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watcher_four", "#64A4CC", 4, "#property_watcher_four_description")
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.35)
    end

    RPCItems:GrantItemBaseArmor(item, item_level, 3.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRadiantRuinsLeather(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_radiant_ruins_leather", "immortal", "Radiant Ruins Leather", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_radiant_ruins_leather"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_radiant_ruins", "#EDB940", 1, "#property_radiant_ruins_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 1.75)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFloodRobe(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_robe_of_flooding", "immortal", "Robe of Flooding", "body", true, "Slot: Body")
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_robe_of_flooding"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_flooding", "#57CFFF", 1, "#property_flooding_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRobesOfEruditeTeacher(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL
    local item = RPCItems:CreateVariant("item_rpc_robe_of_the_erudite_teacher", "immortal", "Robes of the Erudite Teacher", "body", true, "Slot: Body")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_erudite_teacher"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_robe_of_the_erudite_teacher", "#32a852", 1, "#property_robe_of_the_erudite_teacher_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRubyDragonScaleArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ruby_dragon_scale_armor", "immortal", "Ruby Dragon Scale Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_ruby_dragon_scale_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ruby_dragon_armor", "#C94242", 1, "#property_ruby_dragon_armor_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTopazDragonScaleArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_topaz_dragon_scale_armor", "immortal", "Topaz Dragon Scale Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_topaz_dragon_scale_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_topaz_dragon", "#FFFC5C", 1, "#property_topaz_dragon_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end


function RPCItems:RollSapphireDragonScaleArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_sapphire_dragon_scale_armor", "immortal", "Sapphire Dragon Scale Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_sapphire_dragon_scale_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sapphire_dragon", "#5786C9", 1, "#property_sapphire_dragon_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 3)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSacredTrialsArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_sacred_trials_armor", "immortal", "Sacred Trials Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_sacred_trials_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sacred_trials", "#EDC02D", 1, "#property_sacred_trials_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end


function RPCItems:RollSavagePlateOfOgthun(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_savage_plate_of_ogthun", "immortal", "Savage Plate of Og'Thun", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_savage_plate_of_ogthun"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ogthun", "#B32224", 1, "#property_ogthun_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSeaGiantsPlate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_sea_giants_plate", "immortal", "Sea Giant's Plate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_sea_giants_plate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_sea_giant_plate", "#C7E8E2", 1, "#property_sea_giant_plate_Description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSoulVest(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_seraphic_soulvest", "immortal", "Seraphic Soulvest", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_seraphic_soulvest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_seraphic_soulvest", "#C5E7FC", 1, "#property_seraphic_soulvest_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSkyforgeFlurryPlate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_skyforge_flurry_plate", "immortal", "Skyforge Flurry Plate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_skyforge_flurry_plate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_skyforge", "#66BCDE", 1, "#property_skyforge_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "all_attributes", 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSorcererRegalia(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_sorcerers_regalia", "immortal", "Sorcerer's Regalia", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_sorcerers_regalia"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sorcerers_regalia", "#1996E3", 1, "#property_sorcerers_regalia_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSpaceTechVest(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_space_tech_vest", "immortal", "Space Tech Vest", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_space_tech_vest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_space_tech", "#4843E6", 1, "#property_space_tech_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_cosmic", 2)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSpellslingerCoat(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_spellslinger_coat", "immortal", "Spellslinger's Coat", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_spellslinger_coat"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spellslinger_coat", "#3FEBC5", 1, "#property_spellslinger_coat_description")

    local rune_type = RPCItems:RollRuneType({"w"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollKnightCrusherArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_staggering_knight_crusher_armor", "immortal", "Staggering Knight Crusher Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_knight_crusher_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_knight_crusher", "#DBB948", 1, "#property_knight_crusher_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 3.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollStormshieldCloak(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_stormshield_cloak", "immortal", "Stormshield Cloak", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_stormshield_cloak"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_stormshield", "#BAD5DE", 1, "#property_stormshield_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2.25)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTatteredNoviceArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_tattered_novice_armor", "immortal", "Tattered Novice Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_tattered_novice_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tattered_novice_armor", "#61C695", 1, "#property_tattered_novice_armor_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollLightSeersRobes(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_templar_light_seers_robe", "immortal", "Templar Light Seer's Robe", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_templar_light_seers_robe"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_light_seer", "#F4E155", 1, "#property_light_seer_Description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_holy", 2)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spirit", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTerrasicStonePlate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_terrasic_stone_plate", "immortal", "Terrasic Stone Plate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_terrasic_stone_plate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_terrasic_stone", "#BF8154", 1, "#property_terrasic_stone_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q"}, {tier1 = 45, tier2 = 90, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_earth", 2)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_fire", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollInfernalPrison(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_the_infernal_prison", "immortal", "The Infernal Prison", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_infernal_prison"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_infernal_prison", "#E87E15", 1, "#property_infernal_prison_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTwilightVestments(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_twilight_vestments", "immortal", "Twilight Vestments", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_twilight_vestments"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_twilight_vestments", "#BCD8E6", 1, "#property_twilight_vestments_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.5)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVampiricBreastplate(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_vampiric_breastplate", "immortal", "Vampiric Breastplate", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_vampiric_breastplate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_vampiric_breastplate", "#71EBA3", 1, "#property_varmpiric_breastplate_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_health", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVermillionDreamRobes(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_vermillion_dream_robes", "immortal", "Vermillion Dream Robes", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_vermillion_dream_robes"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_vermillion_dream_robes", "#D14268", 1, "#property_vermillion_dream_robes_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 45, tier2 = 90, tier3 = 95, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWaterMageRobes(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_water_mage_robes", "immortal", "Water Mage Robes", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_water_mage_robes"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watermage", "#49B7E3", 1, "#property_watermage_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spell_pierce", 2)
    end
    local luck = RandomInt(1, 4)
    if luck == 4 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "element_water", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWindsteelArmor(item_level)
    local item_slot = RPC_GEAR_SLOT_BODY
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_windsteel_armor", "immortal", "Windsteel Armor", "body", true, "Slot: Body")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_windsteel_armor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_windsteel_armor", "#5079D9", 1, "#property_windsteel_armor_description")

    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 1.5)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_wind", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_ice", 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

--GLOVES

function RPCItems:RollAquasteelBracers(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_aquasteel_bracers", "immortal", "Aquasteel Bracers", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_aquasteel_bracers"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_aquasteel", "#56BBEA", 1, "#property_aquasteel_description")

    local luck = RandomInt(1, 4)
    if luck < 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAutumnrockBracers(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_autumnrock_bracer", "immortal", "Autumnrock Bracer", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_autumnrock_bracer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_autumnrock_bracer", "#C2485E", 1, "#property_autumnrock_bracer_description")

    local luck = RandomInt(1, 4)
    if luck < 4 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_earth", 1.75)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBerserkerGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_berserker_gloves", "immortal", "Berserker Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_berserker_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_berserker", "#850D0D", 1, "#property_berserker_rage_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBladeforgeGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_bladeforge_gauntlet", "immortal", "Bladeforge Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_bladeforge_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bladeforge", "#AB0303", 1, "#property_bladeforge_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor_pierce", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBlueRainGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL


    local item = RPCItems:CreateVariant("item_rpc_blue_rain_gauntlet", "immortal", "Blue Rain Gauntlet", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_blue_rain_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blue_rain", "#B6DEE3", 1, "#property_blue_rain_description")


    local luck = RandomInt(1, 3)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.5)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_water", 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBoneguardGauntlets(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_boneguard_gauntlets", "immortal", "Boneguard Gauntlets", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_bonegaurd_gauntlets"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_boneguard", "#8EA38B", 1, "#property_boneguard_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_undead", 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBuzukisFinger(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_buzukis_finger", "immortal", "Buzuki's Finger", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_buzukis_finger"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_buzuki_finger", "#6FD8ED", 1, "#property_buzuki_finger_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollChitinousLobsterClaw(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_chitinous_lobster_claw", "immortal", "Chitinous Lobster Claw", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_chitinous_lobster_claw"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_lobster_claw", "#C97360", 1, "#property_lobster_claw_Description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor_pierce", 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollClawOfAzinoth(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_claw_of_azinoth", "immortal", "Claw of Azinoth", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_claw_of_azinoth"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azinoth", "#543553", 1, "#property_azinoth_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 4)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 2)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollClawOfTheEtherealRevenant(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_claws_of_the_ethereal_revenant", "immortal", "Claws of the Ethereal Revenant", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_claws_of_the_ethereal_revenant"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ethereal_revenant", "#90DFF5", 1, "#property_ethereal_revenant_description")

    local rune_type = RPCItems:RollRuneType({"w"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCytopianLaserGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_cytopian_laser_glove", "immortal", "Cytopian Laser Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_cytopian_laser"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_cytopian_laser", "#85CEED", 1, "#property_cytopian_laser_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_time", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spell_pierce", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "mana_regen", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDarkEmissaryGlove(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_dark_emissary_glove", "immortal", "Dark Emissary Glove", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_dark_emissary_glove"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_dark_emissary", "#3E7BBC", 1, "#property_dark_emissary_Description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_ghost", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 45, tier2 = 90, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDemonfireGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_demonfire_gauntlet", "immortal", "Demonfire Gauntlet", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_demonfire_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_demonfire", "#8C1C1C", 1, "#property_demonfire_description")

    local luck = RandomInt(1, 5)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_demon", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "base_ability", 1.5)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_fire", 1.5)
    elseif luck == 4 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.5)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 45, tier2 = 90, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDepthDemonClaw(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_depth_demon_claw", "immortal", "Depth Demon Claw", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_depth_demon_claw"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_depth_demon_claw", "#634F87", 1, "#property_depth_demon_claw_Description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_demon", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.5)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 45, tier2 = 90, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDiamondClawsOfTiamat(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_diamond_claws_of_tiamat", "immortal", "Diamond Claws of Tiamat", "hands", true, "Slot: Hands")
    tiamat_roll = RPCItems:RollGearAttributeValue(item_level, nil, nil, 4)
    item.newItemTable.property1 = tiamat_roll
    item.newItemTable.property1name = "!immortal!_modifier_diamond_claws_of_tiamat"
    RPCItems:SetPropertyValuesSpecial(item, tiamat_roll, "#item_property_tiamat_claw", "#FAFAFF", 1, "#property_tiamat_claw_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 0.75)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "base_ability", 0.75)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, "all_elements", 0.75)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEnergyWhipGlove(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_energy_whip_glove", "immortal", "Energy Whip Glove", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_energy_whip_glove"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_energy_whip", "#4986b2", 1, "#property_energy_whip_description")

    local rune_type = RPCItems:RollRuneType({"w"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEternalEssenceGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_eternal_essence_gauntlet", "immortal", "Eternal Essence Gauntlet", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_eternal_essence_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_eternal_essence", "#51C9AF", 1, "#property_eternal_essence_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spirit", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level,2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFarSeersEnchantedGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_far_seers_enchanted_gloves", "immortal", "Far Seer's Enchanted Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_far_seers_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_farseer_glove", "#CAD683", 1, "#property_farseer_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.75)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level,2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFrostburnGauntlets(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_frostburn_gauntlets", "immortal", "Frostburn Gauntlets", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_frostburn_gauntlets"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_frostburn_gauntlets", "#7DDAE8", 1, "#property_frostburn_gauntlets_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "mana_regen", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_ice", 2.0)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDivinePurityGauntlets(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_gauntlet_of_divine_purity", "immortal", "Gauntlets of Divine Purity", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_gauntlet_of_divine_purity"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_divine_purity", "#A8D3ED", 1, "#property_divine_purity_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_holy", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    end

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "magic_armor", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGloveOfTheForgottenGhost(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_glove_of_the_forgotten_ghost", "immortal", "Glove of the Forgotten Ghost", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_glove_of_the_forgotten_ghost"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_forgotten_ghost", "#A5E8E7", 1, "#property_forgotten_ghost_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_ghost", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spell_pierce", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "base_ability", 1.75)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGlovesOfSweepingWind(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_gloves_of_sweeping_wind", "immortal", "Sweeping Wind Glove", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_gloves_of_sweeping_wind"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sweeping_wind", "#A9D4C5", 1, "#property_sweeping_wind_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_wind", 2.0)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "agility", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGoldbreakerGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_goldbreaker_gauntlet", "immortal", "Goldshatter Gauntlet", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_goldbreaker_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gold_breaker", "#fff42b", 1, "#property_gold_breaker_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 1.5)
    elseif luck == 2 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "spirit", 1.5)
    elseif luck == 2 then
        local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 45, tier2 = 90, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGrandArcanist(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_grand_arcanist_wraps", "immortal", "Wraps of the Grand Arcanist", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_grand_arcanist"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_grand_arcanist", "#A05BCF", 1, "#property_grand_arcanist_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2.0)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    end

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "base_ability", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollElderGrasp(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_grasp_of_elder", "immortal", "Grasp of the Elders", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_grasp_of_elder"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_elder_grasp", "#5A54C4", 1, "#property_elder_grasp_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spirit", 2.0)
    elseif luck == 2 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.5)
    end

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "spirit", 2.0)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollChampionsGearGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_gauntlet_of_champions", "immortal", "champions_gear", "hands", true, "Slot: Hands")


    return item
end

function RPCItems:RollGravekeepersGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_gravekeepers_gauntlet", "immortal", "Gravekeeper's Gauntlet", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_gravekeepers_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gravekeeper_gauntlet", "#94EBFF", 1, "#property_gravekeeper_gauntlet_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "base_ability", 1.5)
    elseif luck == 2 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"w"}, {tier1 = 40, tier2 = 80, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGreensandCopperGauntlets(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_greensand_copper_gauntlets", "immortal", "Greensand Copper Gauntlets", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_greensand_copper_gauntlets"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_greensand_copper_gauntlets", "#A87732", 1, "#property_greensand_copper_gauntlets_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.75)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.75)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.75)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    Gems:AddSocket(item)
    Gems:AddSocket(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHalcyonSoulGlove(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_halcyon_soul_glove", "immortal", "Halcyon Soul Glove", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_halcyon_soul_glove"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_halcyon_soul", "#E8F274", 1, "#property_halcyon_soul_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.5)

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHandOfMidas(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_hand_of_midas", "immortal", "Hand of Midas", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_hand_of_midas"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hand_of_midas", "#EFF700", 1, "#property_hand_of_midas_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHeavyEchoGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_heavy_echo_gauntlet", "immortal", "Heavy Echo Gauntlet", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_heavy_echo_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_heavy_echo", "#CE3350", 1, "#property_heavy_echo_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 1.5)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor_pierce", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollIronboundGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ironbound_gloves", "immortal", "Ironbound Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_ironbound_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ironbound_gloves", "#CFD2D4", 1, "#property_ironbound_gloves_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollProudGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_kappa_pride_gloves", "immortal", "Proud Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_kappa_pride_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_proud_gloves", "#D950D6", 1, "#property_proud_gloves_description")
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollLivingGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_living_gauntlet", "immortal", "Living Gauntlet", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_living_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_living_gauntlet", "#ADFF5C", 1, "#property_living_gauntlet_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_nature", 2)
    elseif luck == 2 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    end

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "health_regen", 2.0)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMageBaneGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_magebane_gloves", "immortal", "Magebane Gloves", "hands", true, "Slot: Hands")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, rune_type, 2)

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMalachiteShadeBracer(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_malachite_shade_bracer", "immortal", "Malachite Shade Bracer", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_malachite_shade_bracer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_malachite_shade", "#95DB9D", 1, "#property_malachite_shade_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "health_regen", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "mana_regen", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMarauderGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_marauder_gloves", "immortal", "Marauder Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_marauder_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_marauder", "#326E94", 1, "#property_marauder_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor_pierce", 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMasterGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_master_gloves", "immortal", "Master Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_master_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_master_gloves", "#EDCA3B", 1, "#property_master_gloves_description")

    local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMordiggusGauntlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_mordiggus_gauntlet", "immortal", "Mordiggus Gauntlet", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mordiggus_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mordiggus", "#B84874", 1, "#property_mordiggus_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_health", 1.75)

    local luck = RandomInt(1,3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "element_demon", 1.75)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMountainVambraces(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_mountain_vambraces", "immortal", "Mountain Vambraces", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mountain_vambraces"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_vambraces", "#694B4B", 1, "#property_mountain_vambraces_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2.25)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollPhoenixGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_phoenix_gloves", "immortal", "Phoenix Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_phoenix_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_phoenix_gloves", "#EDA65F", 1, "#property_phoenix_gloves_description")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1.75)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollPowerRangerGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_power_ranger_gloves", "immortal", "Power Ranger Gloves", "hands", true, "Slot: Hands")

    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, "strength", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "intelligence", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, "spirit", 2)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRoyalWristguards(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_royal_wristguards", "immortal", "Royal Wristguards", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_royal_wristguards"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_royal_wrist", "#D94848", 1, "#property_royal_wrist_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.75)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 1.75)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 1.75)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollScarecrowGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_scarecrow_gloves", "immortal", "Scarecrow Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_scarecrow_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_scarecrow", "#2CA8F5", 1, "#property_scarecrow_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollScorchedGauntlets(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_scorched_gauntlets", "immortal", "Gloves of the High Flame", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_scorched_gauntlets"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_scorched_gauntlet", "#E8A917", 1, "#property_scorched_gauntlet_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_fire", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    else
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollShadowArmlet(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_shadow_armlet", "immortal", "Shadow Armlet", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_shadow_armlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_shadow_armlet", "#54457A", 1, "#property_shadow_armlet_description")


    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_shadow", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 1.5)
    end
    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.25)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollShadowflameFist(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_shadowflame_fist", "immortal", "Shadowflame Fist", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_shadowflame_fist"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_shadowflame_fist", "#5A25BC", 1, "#property_shadowflame_fist_description")
    
    local luck = RandomInt(1, 3)
    if luck < 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_shadow", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSilverspringGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_silverspring_gloves", "immortal", "Silverspring Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_silverspring_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_silverspring_glove", "#AFCCB8", 1, "#property_silverspring_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "health_regen", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSkulldiggerGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_skulldigger_gauntlet", "immortal", "Skulldigger Gauntlet", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_skulldigger_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_skulldigger", "#90E8E7", 1, "#property_skulldigger_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_health", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_undead", 1.5)
    elseif luck == 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSpellfireGloves(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_spellfire_gloves", "immortal", "Spellfire Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_spellfire_gloves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spellfire", "#FFA62B", 1, "#property_spellfire_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier3 = 80, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSpiritGlove(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_spirit_glove", "immortal", "Spirit Glove", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_spirit_glove"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spirit_glove", "#FFFFFF", 1, "#property_spirit_glove_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spirit", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSpiritualEmpowermentGlove(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_spiritual_empowerment_glove", "immortal", "Spiritual Empowerment Glove", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_spiritual_empowerment_glove"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spiritual_empowerment", "#B6DEE3", 1, "#property_spiritual_empowerment_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spirit", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "base_ability", 1.5)
    end
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollStormclothBracer(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_stormcloth_bracer", "immortal", "Stormcloth Bracers", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_stormcloth_bracer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_stormcloth", "#85CEED", 1, "#property_stormcloth_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_lightning", 1.5)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSwiftspikeBracer(item_level)
    local item_slot = RPC_GEAR_SLOT_GLOVES
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_swiftspike_bracer", "immortal", "Swiftspike Bracer", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_swiftspike_bracer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_swiftspike_bracer", "#3F74A8", 1, "#property_swiftspike_bracer_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "movespeed", 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end


-- BOOTS

function RPCItems:RollAblecoreGreaves(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ablecore_greaves", "immortal", "Ablecore Greaves", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_ablecore_greaves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ablecore_greaves", "#DED083", 1, "#property_ablecore_greaves_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAdmiralBoot(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_admiral_boots", "immortal", "Admiral's Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_admiral_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_admiral_boots", "#A66829", 1, "#property_admiral_boots_description")


    local rune_type = RPCItems:RollRuneType({"e"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)

    local rune_type = RPCItems:RollRuneType({"e"}, {tier2 = 50, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 2)


    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAlaranaIceBoot(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_alaranas_ice_boot", "immortal", "Alarana's Ice Boot", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_alaranas_ice_boot"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_alarana", "#AFECFF", 1, "#property_alarana_description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_ice", 2)
    else
        local rune_type = RPCItems:RollRuneType({"e"}, {tier1 = 40, tier2 = 80, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.25)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollArcanysSlipper(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_arcanys_slipper", "immortal", "Arcanys Slippers", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_arcanys_slipper"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arcanys_slipper", "#C23CCF", 1, "#property_arcanys_slipper_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_arcane", 2)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_mana", 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBloodstoneBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_bloodstone_boots", "immortal", "Bloodstone Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_bloodstone_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bloodstone_boots", "#E2371D", 1, "#property_bloodstone_boots_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_health", 2)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBlueDragonGreaves(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_blue_dragon_greaves", "immortal", "Blue Dragon Greaves", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_blue_dragon_greaves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_dragon_greaves", "#2B4DE3", 1, "#property_dragon_greaves_description")

    local luck = RandomInt(1, 4)
    if luck < 4 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 1.75)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_dragon", 2)
    end
    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    else
        local rune_type = RPCItems:RollRuneType({"e"}, {tier1 = 40, tier2 = 80, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 2.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBootsOfAshara(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_boots_of_ashara", "immortal", "Boots of Ashara", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_boots_of_ashara"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_boots_of_ashara", "#E6C149", 1, "#property_boots_of_ashara_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)
    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollChampionsGearBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_boots_of_champions", "immortal", "champions_gear", "feet", true, "Slot: Boots")
    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, "rune_e_4", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBootsOfGreatFortune(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_boots_of_great_fortune", "immortal", "Boots of Great Fortune", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_boots_of_great_fortune"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_boots_of_great_fortune", "#F1F756", 1, "#property_boots_of_great_fortune_description")

    local rune_type = RPCItems:RollRuneType({"e"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBootsOfOldWisdom(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_boots_of_old_wisdom", "immortal", "Boots of Old Wisdom", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_boots_of_old_wisdom"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_old_wisdom", "#8DEBCE", 1, "#property_old_wisdom_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2.0)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBootsOfPureWaters(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL
    
    local item = RPCItems:CreateVariant("item_rpc_boots_of_pure_waters", "immortal", "Boots of Pure Waters", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_boots_of_pure_waters"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pure_waters", "#2679BD", 1, "#property_pure_waters_description")

    local luck = RandomInt(1,3)
    if luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2.0)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_water", 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVioletTreads(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_boots_of_the_violet_guard", "immortal", "Boots of the Violet Guard", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_violet_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_violet_boot", "#A337E6", 1, "#property_violet_boot_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2.0)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCrimsythEliteGreavesLV1(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_crimsyth_elite_greaves_lv1", "immortal", "Crimsyth Elite Greaves LV1", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_crimsyth_elite_greaves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_crimsyth_elite", "#DD2727", 1, "#property_crimsyth_elite_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.00)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.00)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCrusaderBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_crusader_boots", "immortal", "Crusader Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_devotion_aura"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_crusader_boots", "#48B6CF", 1, "#property_crusader_boots_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    else
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCrystallineSlippers(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_crystalline_slippers", "immortal", "Crystalline Slippers", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_crystalline_slippers"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_crystalline", "#99E8E0", 1, "#property_crystalline_Description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollDunetreadBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_dunetread_boots", "immortal", "Dunetreads", "feet", true, "Slot: Feet")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_dunetread_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_dunetread", "#8A8546", 1, "#property_dunetread_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEmeraldSpeedRunners(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_emerald_speed_runners", "immortal", "Emerald Speed Runners", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_emerald_speed_runners"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_emerald_speed", "#3EC18A", 1, "#property_emerald_speed_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_wind", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFalconBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_falcon_boots", "immortal", "Falcon Boots", "feet", true, "Slot: Feet")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_falcon_boots"

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_falcon_boot", "#AACFE6", 1, "#property_falcon_boot_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 1.75)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 1.75)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollFireWalkers(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_fire_walkers", "immortal", "Fire Walkers", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_fire_walkers"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fire_walkers", "#DE4318", 1, "#property_fire_walkers_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGhostSlippers(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ghost_slippers", "immortal", "Ghost Slippers", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_ghost_slippers"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ghost_slippers", "#9B72C4", 1, "#property_ghost_slippers_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 0.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 0.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 0.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGiantHunterBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_giant_hunters_boots_of_resilience", "immortal", "Giant Hunters Boots of Resilience", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_giant_hunters_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_giant_hunter_boot", "#E3E300", 1, "#property_giant_hunter_boot_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_health", 2)
    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.25)    
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGravelfootTreads(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_gravelfoot_treads", "immortal", "Gravelfoot Treads", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_gravelfoot_treads"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gravelfoot", "#8FC2C9", 1, "#property_gravelfoot_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 3)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGuardianGreaves(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_guardian_greaves", "immortal", "Guardian Greaves", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_guardian_greaves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_guardian_greaves", "#8FE051", 1, "#property_guardien_greaves_description")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollHarvesterBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_harvester_boots", "immortal", "Harvester Boots", "feet", true, "Slot: Feet")
    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, nil, 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, rune_type, 1.5)
    end
    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end
    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.5)
    end
    local luck = RandomInt(1, 3)
    if luck < 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier4 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, rune_type, 1.5)
    end

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollIceFloeSlippers(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ice_floe_slippers", "immortal", "Ice Floe Slippers", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_ice_floe_slippers"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ice_floe_slippers", "#8BD3F9", 1, "#property_ice_floe_slippers_description")

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    local rune_type = RPCItems:RollRuneType({"e"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollIronTreadsOfDestruction(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_iron_treads_of_destruction", "immortal", "Iron Treads of Destruction", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_iron_treads_of_destruction"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_iron_treads_of_destruction", "#4259F4", 1, "#property_iron_treads_of_destruction_description")

    local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 0.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end


function RPCItems:RollManaStriders(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_mana_striders", "immortal", "Mana Striders", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_mana_striders"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mana_striders", "#55A4CF", 1, "#property_mana_striders_description")

    local luck = RandomInt(1,3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2.0)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_mana", 2)
    elseif luck == 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollMoonTechs(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_moon_tech_runners", "immortal", "Moon Tech Runners", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_moon_tech_runners"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_moon_techs", "#3700CF", 1, "#property_moon_techs_description")

    local luck = RandomInt(1,3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2.0)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_cosmic", 2)
    elseif luck == 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollNeptunesWaterGliders(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_neptunes_water_gliders", "immortal", "Neptune's Water Gliders", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_neptunes_water_gliders"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_neptune", "#2294F2", 1, "#property_neptune_description")

    local rune_type = RPCItems:RollRuneType({"e"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)    
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollOceanrunnerBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_oceanrunner_boots", "immortal", "Oceanrunner", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_oceanrunner_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_oceanrunner", "#58EFD6", 1, "#property_oceanrunner_Description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.75)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollResonantPathfinderBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_pathfinders_resonant_boots", "immortal", "Pathfinder's Resonant Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_pathfinders_resonant_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pathfinder", "#E3E02D", 1, "#property_pathfinder_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
        local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollPegasusBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_pegasus_boots", "immortal", "Pegasus Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_pegasus_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pegasus", "#cdd1b0", 1, "#property_pegasus_description")
    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    else
        local rune_type = RPCItems:RollRuneType({"e"}, {tier1 = 40, tier2 = 80, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollPivotalSwiftboots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_pivotal_swiftboots", "immortal", "Pivotal Swiftboots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_pivotal_swiftboots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pivotal", "#4fd9f7", 1, "#property_pivotal_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEternalForestStriders(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_red_october_boots", "immortal", "Red October Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_eternal_forest_striders"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_red_october", "#E87B7B", 1, "#property_red_october_description")

    local rune_type = RPCItems:RollRuneType({"e"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "rune_e_4", 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRedrockFootwear(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_redrock_footwear", "immortal", "Redrock Footwear", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_redrock_footwear"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_redrock", "#EB0E0E", 1, "#property_redrock_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollResplendantRubberBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_resplendent_rubber_boots", "immortal", "Resplendent Rubber Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_resplendent_rubber_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_resplendent_rubber", "#DADE66", 1, "#property_resplendent_rubber_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRootedFeet(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_rooted_feet", "immortal", "Rooted Feet", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_rooted_feet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_rooted_feet", "#ADFF5C", 1, "#property_rooted_feet_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSandstreamSlippers(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_sandstream_slippers", "immortal", "Sandstream Slippers", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_sandstream_slippers"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sandstream_slippers", "#E3DEBA", 1, "#property_sandstream_slippers_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_earth", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSangeBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_sange_boots", "immortal", "Sange Boots", "feet", true, "Slot: Feet")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_rpc_sange_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sange", "#CC1104", 1, "#property_sange_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 45, tier2 = 90, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:SlingerBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_slinger_boots", "immortal", "Bladeslinger Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_slinger_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_slinger_boot", "#D6D2D2", 1, "#property_slinger_boots_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)


    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSonicBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_sonic_boots", "immortal", "Sonic Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_sonic_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sonic_boots", "#AACFE6", 1, "#property_sonic_boots_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "movespeed", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_speed", 2)
    else
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end
    
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSteamboots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_steamboots", "immortal", "Steam Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_rpc_steamboots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_steamboots", "#4FD65A", 1, "#property_steamboots_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "item_damage", 1.75)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollSwampWaders(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_swamp_waders", "immortal", "Swamp Waders", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_swamp_waders"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_swamp_waders", "#658337", 1, "#property_swamp_waders_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTemporalWarpBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_temporal_warp_boots", "immortal", "Temporal Warp Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_temporal_warp_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_temporal_warp", "#A1F442", 1, "#property_temporal_warp_description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_time", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "item_damage", 3)
    elseif luck == 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 2)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTerrasicLavaBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_terrasic_lava_boots", "immortal", "Terrasic Lava Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_rpc_terrasic_lava_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_terrasic_lava", "#9C4343", 1, "#property_terrasic_lava_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_fire", 2)
    elseif luck == 2 or luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    elseif luck == 4 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)
    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollTranquilBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_tranquil_boots", "immortal", "Tranquil Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_tranquil_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tranquil_boots", "#30E691", 1, "#property_tranquil_boots_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_nature", 1.5)
    elseif luck == 2 or luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    elseif luck == 4 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    elseif luck == 5 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "health_regen", 1.75)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)
    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollVoyagerBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_voyager_boots", "immortal", "Voyager Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_voyager_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_voyager", "#AB9091", 1, "#property_voyager_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_speed", 1.5)
    elseif luck == 2 or luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1)
    elseif luck == 4 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)
    elseif luck == 5 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "movespeed", 1.5)
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)
    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollYashaBoots(item_level)
    local item_slot = RPC_GEAR_SLOT_BOOTS
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_yasha_boots", "immortal", "Yasha Boots", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_rpc_yasha_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_yasha", "#4FD65A", 1, "#property_yasha_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 45, tier2 = 90, tier3 = 100})
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

--TRINKETS

function RPCItems:RollAerithsTear(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_aeriths_tear", "immortal", "Aerith's Tear", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_aeriths_tear"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_aeriths_tear", "#3EDAE6", 1, "#property_aeriths_tear")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAncientTanariWaterstone(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ancient_tanari_waterstone", "immortal", "Ancient Tanari Waterstone", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_ancient_waterstone"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ancient_waterstone", "#70C6FF", 1, "#property_ancient_waterstone_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 2)

    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, rune_type, 1.5)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, rune_type, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.75)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAnkhOfAncients(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_ankh_of_the_ancients", "immortal", "Ankh of the Ancients", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_ankh_of_the_ancients"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ankh_of_ancients", "#AEF2E1", 1, "#property_ankh_of_ancients_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "magic_armor", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAntiqueManaRelic(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_antique_mana_relic", "immortal", "Antique Mana Relic", "amulet", true, "Slot: Trinket")

    item.newItemTable.property1name = "!immortal!_modifier_antique_mana_relic"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_antique_mana_relic", "#9DBCF5", 1, "#property_antique_mana_relic_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "max_mana", 2.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAquaLily(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_aqua_lily", "immortal", "Aqua Lily", "amulet", true, "Slot: Trinket")

    item.newItemTable.property1name = "!immortal!_modifier_aqua_lily"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_aqua_lily", "#4FADE8", 1, "#property_aqua_lily_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_water", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAquastoneRing(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_aquastone_ring", "immortal", "Aquastone Ring", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_aquastone_ring"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_aquastone_ring", "#9FC2F9", 1, "#property_aquastone_ring_description")


    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end


function RPCItems:RollArborDragonfly(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL


    local item = RPCItems:CreateVariant("item_rpc_arbor_dragonfly", "immortal", "Arbor Dragonfly", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_arbor_dragonfly"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arbor_dragonfly", "#B59B77", 1, "#property_arbor_dragonfly_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.5)

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollArcaneCharm(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_arcane_charm", "immortal", "Arcane Charm", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_arcane_charm"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arcane_charm", "#c75ce8", 1, "#property_arcane_charm_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "element_arcane", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.5)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAuricRingOfInspiration(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_auric_ring_of_inspiration", "immortal", "Auric Ring of Inspiration", "amulet", true, "Slot: Trinket")

    item.newItemTable.property1name = "!immortal!_modifier_auric_ring_of_inspiration"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_auric_ring_of_inspiration", "#edf056", 1, "#property_auric_ring_of_inspiration_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollAzureEmpire(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_azure_empire", "immortal", "Pendant of the Azure Empire", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "!immortal!_modifier_azure_empire"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire", "#7AD2F0", 1, "#property_azure_empire_description")

    local luck = RandomInt(1, 5)
    if luck == 1 then
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "!immortal!_modifier_azure_empire_hero_silver"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_silver", "#C9E6ED", 2, "#property_azure_empire_silver_description")
    elseif luck == 2 then
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "!immortal!_modifier_azure_empire_hero_green"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_green", "#67EA64", 2, "#property_azure_empire_green_description")
    elseif luck == 3 then
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "!immortal!_modifier_azure_empire_hero_blue"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_blue", "#74A0ED", 2, "#property_azure_empire_blue_description")
    elseif luck == 4 then
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "!immortal!_modifier_azure_empire_hero_red"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_red", "#E03018", 2, "#property_azure_empire_red_description")
    elseif luck == 5 then
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "!immortal!_modifier_azure_empire_hero_purple"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_purple", "#D79FF9", 2, "#property_azure_empire_purple_description")
    end

    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBadgeOfHonor(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL
    local item = RPCItems:CreateVariant("item_rpc_badge_of_honor", "immortal", "Badge of Honor", "amulet", true, "Slot: Trinket")

    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 1, item_level, attr_roll, 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "health_regen", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "armor", 1.5)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, "magic_armor", 1.5)

    RPCItems:GrantItemBaseArmor(item, item_level, 1)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBerylRingOfIntuition(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_beryl_ring_of_intuition", "immortal", "Beryl Ring of Intuition", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "!immortal!_modifier_beryl_ring_of_intuiton"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_beryl_ring_of_intuition", "#5cadff", 1, "#property_beryl_ring_of_intuition_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 2)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, nil, 1.25)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end


function RPCItems:RollBlacksmithsTablet(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_blacksmiths_tablet", "immortal", "Blacksmith's Tablet", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_blacksmiths_tablet"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blacksmiths_tablet", "#C1C7C9", 1, "#property_blacksmiths_tablet_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "attack_damage", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.25)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.25)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollBlueDivinexAmulet(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_blue_divinex_amulet", "immortal", "Blue Divinex Amulet", "amulet", true, "Slot: Trinket")

    item.newItemTable.property1name = "!immortal!_modifier_blue_divinex_amulet"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blue_divinex", "#3857F4", 1, "#property_blue_divinex_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollGreenDivinexAmulet(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_green_divinex_amulet", "immortal", "Green Divinex Amulet", "amulet", true, "Slot: Trinket")

    item.newItemTable.property1name = "!immortal!_modifier_green_divinex_amulet"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_green_divinex", "#4CDB64", 1, "#property_green_divinex_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollRedDivinexAmulet(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_red_divinex_amulet", "immortal", "Red Divinex Amulet", "amulet", true, "Slot: Trinket")

    item.newItemTable.property1name = "!immortal!_modifier_red_divinex_amulet"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_red_divinex", "#D62447", 1, "#property_red_divinex_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "strength", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollCobaltSerenityRing(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_cobalt_serenity_ring", "immortal", "Cobalt Serenity Ring", "amulet", true, "Slot: Trinket")

    item.newItemTable.property1name = "!immortal!_modifier_cobalt_serenity_ring"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_cobalt_serenity", "#4FADE8", 1, "#property_cobalt_serenity_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1.25)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1.25)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollConquestStoneFalcon(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_conquest_stone_falcon", "immortal", "Conquest Stone Falcon", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_conquest_stone_falcon"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_stone_falcon", "#A5B5A9", 1, "#property_stone_falcon_description")

    local attr_rolls = {"armor", "armor_pierce", "spell_pierce", "magic_armor"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, attr_roll, 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 2.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEmeraldNullificationRing(item_level)
    local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_emerald_nullification_ring", "immortal", "Emerald Nullification Ring", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_emerald_nullification_ring"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_emerald_null", "#38D667", 1, "#property_emerald_null_description")

    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "agility", 2)
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 2)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollEpsilonsEyeglass(item_level)
     local item_slot = RPC_GEAR_SLOT_TRINKET
    local rarity = RPC_ITEMS_RARITY_IMMORTAL
       
    local item = RPCItems:CreateVariant("item_rpc_epsilons_eyeglass", "immortal", "Epsilons Eyeglass", "amulet", true, "Slot: Trinket")
    item.newItemTable.property1name = "!immortal!_modifier_epsilons_eyeglass"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_epsilon_eyeglass", "#4A91D9", 1, "#property_epsilon_eyeglass_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "armor_pierce", 2)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spell_pierce", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWinterblightSkullRing(item_level)
    local glyphName = Glyphs:RollRandomGlyphName()
    local item = nil
    if glyphName[2] == "neutral" then
        item = RPCItems:CreateVariant("item_rpc_winterblight_skull_ring", "immortal", "Winterblight Skull Ring", "amulet", true, "Slot: Trinket")
    else
        local internalHeroName = HerosCustom:ConvertRPCNameToStringHeroName(glyphName[2])
        item = RPCItems:CreateVariantWithHero("item_rpc_winterblight_skull_ring", "immortal", "Winterblight Skull Ring", "amulet", true, "Slot: Trinket", internalHeroName)
    end

    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = glyphName[1]
    local value = 1
    item.newItemTable.property1 = value

    -- if glyphName[2] == "neutral" then
    -- else
    --     item.newItemTable.requiredHero = glyphName[2]
    -- end
    ----print(item.newItemTable.requiredHero)
    local glyphTitle = "#DOTA_Tooltip_ability_"..glyphName[1]
    local glyphDescrip = "#"..glyphName[1] .. "_description"
    RPCItems:SetPropertyValuesSpecial(item, "★", glyphTitle, "#b383d1", 1, glyphDescrip)
    item.newItemTable.hasRunePoints = true

    Elements:RollElementAttribute(item, RPC_ELEMENT_UNDEAD, 3.2, 2, 24, 2)
    ----print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    -- item.newItemTable.requiredHero = glyphName[2]
    -- DeepPrintTable(glyphName)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.ceil(value * 1.0)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = math.ceil(value * 1.1)
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMonkeyPaw(item_level)
    local item = RPCItems:CreateVariant("item_rpc_monkey_paw", "immortal", "Monkey Paw", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "monkey_paw"
    local value = 1
    item.newItemTable.property1 = value

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_monkey_paw", "#E4AE33", 1, "#property_monkey_paw_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.5)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.5)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = value * 2
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFrozenHeart(item_level)
    local item = RPCItems:CreateVariant("item_rpc_frozen_heart", "immortal", "Frozen Heart", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "frozen_heart"
    local value = 1
    item.newItemTable.property1 = value

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_frozen_heart", "#82DFFF", 1, "#property_frozen_heart_description")

    item.newItemTable.hasRunePoints = true

    local value, suffixLevel = RPCItems:RollAttribute(100, 5, 30, 0, 0, item.newItemTable.rarity, false, maxFactor * 30)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "mana_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_mana_regen", "#649FA3", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.6)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = math.floor(value * 1.6)
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollStoneOfGordon(deathLocation, gordonFactor)
    local item = RPCItems:CreateVariant("item_rpc_stone_of_gordon", "immortal", "Stone of Gordon", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()
    local luck = RandomInt(1, 10)
    local value = RPCItems:GetLogarithmicVarianceValue(gordonFactor, 0, 0, 0, 0)
    value = math.floor(value)
    item.newItemTable.property1name = "all_runes"
    item.newItemTable.property1 = value

    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "#item_all_runes", "#7DFF12", 1)

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSapphireLotus(item_level)
    local item = RPCItems:CreateVariant("item_rpc_sapphire_lotus", "immortal", "Sapphire Lotus", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "sapphire_lotus"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sapphire_lotus", "#008CFF", 1, "#property_sapphire_lotus_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = math.ceil(1.3 * value)
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = math.ceil(1.3 * value)
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end


function RPCItems:RollTokenOfOceanis(deathLocation, bBossDrop)
    local item = RPCItems:CreateVariant("item_rpc_sparkling_token_of_oceanis", "immortal", "Sparkling Token of Oceanis", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "oceanis"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_sparkling_token", "#FFE884", 1, "#property_sparkling_token_Description")
    local bossMax = 14
    if bBossDrop then
        bossMax = 18
    end
    local value, nameLevel = RPCItems:RollAttribute(0, 6, bossMax, 0, 0, item.newItemTable.rarity, false, maxFactor * bossMax)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGuardianStone(item_level)
    local item = RPCItems:CreateVariant("item_rpc_guardian_stone", "immortal", "Guardian Stone", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "guardian_stone"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_guardian_stone", "#BFD4F5", 1, "#property_guardian_stone_description")
    local luck = RandomInt(1, 2)
    if luck == 1 then
        local value, nameLevel = RPCItems:RollAttribute(0, 6, 30, 0, 0, item.newItemTable.rarity, false, 5600)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "all_attributes"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)
    else
        local value, nameLevel = RPCItems:RollAttribute(0, 4, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "armor"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end


function RPCItems:RollFrostGem(item_level)
    local item = RPCItems:CreateVariant("item_rpc_gem_of_eternal_frost", "immortal", "Gem of Eternal Frost", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "eternal_frost"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_eternal_frost", "#9FE9F5", 1, "#property_eternal_frost_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 7, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    local luck = RandomInt(1, 3)
    if luck == 1 then
        local tier, value, propertyName = RPCItems:RollSkillProperty()
        if tier > 0 then
            item.newItemTable.property3 = value
            item.newItemTable.property3name = propertyName
            RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
        end
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_ICE, 2.1, 1, 30, 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTwigOfEnlightened(item_level)
    local item = RPCItems:CreateVariant("item_rpc_twig_of_the_enlightened", "immortal", "Twig of the Enlightened", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "enlightened_twig"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_twig_of_enlightened", "#95CAF5", 1, "#property_twig_of_enlightened_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 9, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollLifesourceVessel(item_level)
    local item = RPCItems:CreateVariant("item_rpc_lifesource_vessel", "immortal", "Lifesource Vessel", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "lifesource"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_lifesource_vessel", "#E31459", 1, "#property_lifesource_vessel_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 220, 600, 1, 1, item.newItemTable.rarity, false, maxFactor * 400)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    local value, prefixLevel = RPCItems:RollAttribute(100, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 5)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "health_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_health_regen", "#6AA364", 3)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTomeOfChaos(item_level)
    local item = RPCItems:CreateVariant("item_rpc_tome_of_chaos", "immortal", "Tome of Chaos", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "tome_of_chaos"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tome_of_chaos", "#0FBD09", 1, "#property_tome_of_chaos")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_DEMON, 2.5, 1, 30, 3)
    else
        local tier, value, propertyName = RPCItems:RollSkillProperty()
        if tier > 0 then
            item.newItemTable.property3 = value
            item.newItemTable.property3name = propertyName
            RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
        end
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTorchOfGengar(item_level)
    local item = RPCItems:CreateVariant("item_rpc_torch_of_gengar", "immortal", "Torch Of Gengar", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "gengar"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gengar", "#7E36D6", 1, "#property_gengar")

    local magicResistRoll = RandomInt(5, 10)
    item.newItemTable.property2 = magicResistRoll
    item.newItemTable.property2name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_magic_resist", "#AC47DE", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = math.floor(value * 1.4)
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRuinfallSkullToken(item_level)
    local item = RPCItems:CreateVariant("item_rpc_ruinfall_skull_token", "immortal", "Ruinfall Skull Token", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "ruinfall"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ruinfall", "#5E572D", 1, "#property_ruinfall")

    local maxFactor = RPCItems:GetMaxFactor()
    local armorRoll = RandomInt(math.ceil(maxFactor * 1.5), math.ceil(maxFactor * 2.5)) + 5
    if GameState:GetDifficultyFactor() == 2 then
        armorRoll = armorRoll + RandomInt(math.ceil(maxFactor * 5), math.ceil(maxFactor * 10))
    elseif GameState:GetDifficultyFactor() == 3 then
        armorRoll = armorRoll + RandomInt(math.ceil(maxFactor * 6), math.ceil(maxFactor * 12))
    end
    item.newItemTable.property2 = armorRoll
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = math.floor(value * 1.4)
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRavenIdol(item_level)
    local item = RPCItems:CreateVariant("item_rpc_raven_idol", "immortal", "Raven Idol", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "raven2"
    item.newItemTable.property1 = 0
    --RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_raven_idol", "#807F85",  1, "#property_raven_idol_description")
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_raven_idol2", "#807F85", 1, "#property_raven_idol_description2")

    local maxFactor = RPCItems:GetMaxFactor()

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local value, nameLevel = RPCItems:RollAttribute(50, 1, 35, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
        item.newItemTable.property2 = math.ceil(value * 1.1)
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    elseif luck == 2 then
        local value, nameLevel = RPCItems:RollAttribute(50, 1, 35, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
        item.newItemTable.property2 = math.ceil(value * 1.1)
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    else
        local value, nameLevel = RPCItems:RollAttribute(50, 1, 35, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
        item.newItemTable.property2 = math.ceil(value * 1.1)
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = math.floor(value * 1.4)
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFortunesTalismanOfTruth(item_level)
    local item = RPCItems:CreateVariant("item_rpc_fortunes_talisman_of_truth", "immortal", "Fortune's Talisman of Truth", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "fortune_talisman"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fortune_talisman", "#EFEC3B", 1, "#property_fortune_talisman_description")

    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(1500, 0, 0, 0, 0)
    local primaryAttribute = RandomInt(0, 2)
    if primaryAttribute == 0 then
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    elseif primaryAttribute == 1 then
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    else
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = math.floor(value * 1.4)
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollOmegaRuby(item_level)
    local item = RPCItems:CreateVariant("item_rpc_omega_ruby", "immortal", "Omega Ruby", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "omega_ruby"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_omega_ruby", "#C40404", 1, "#property_omega_ruby")

    local value = RandomInt(maxFactor * 12, maxFactor * 360)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFenrirFang(item_level)
    local item = RPCItems:CreateVariant("item_rpc_fenrirs_fang", "immortal", "Fenrir Fang", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "fenrir_fang"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fenrir_fang", "#EB7B6A", 1, "#property_fenrir_fang")

    local value = RandomInt(maxFactor * 12, maxFactor * 667)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollPhoenixEmblem(item_level)
    local item = RPCItems:CreateVariant("item_rpc_phoenix_emblem", "immortal", "Pheonix Token", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "phoenix_emblem"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_phoenix_emblem", "#C98920", 1, "#property_phoenix_emblem")

    local value, prefixLevel = RPCItems:RollAttribute(100, 5, 23, 0, 0, item.newItemTable.rarity, false, maxFactor * 30)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "health_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_health_regen", "#6AA364", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHopeOfSaytaru(item_level)
    local item = RPCItems:CreateVariant("item_rpc_hope_of_saytaru", "immortal", "Hope of Saytaru", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "saytaru"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_saytaru", "#EDE618", 1, "#property_saytaru_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local magicResistRoll = RandomInt(5, 45)
        item.newItemTable.property2 = magicResistRoll
        item.newItemTable.property2name = "magic_resist"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_magic_resist", "#AC47DE", 2)
    else
        local tier, value, propertyName = RPCItems:RollSkillProperty()
        if tier > 0 then
            value = math.ceil(0.7 * value)
            item.newItemTable.property2 = value
            item.newItemTable.property2name = propertyName
            RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
        end
    end
    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFuchsiaRing(item_level)
    local item = RPCItems:CreateVariant("item_rpc_fuchsia_ring", "immortal", "Fuchsia Ring", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "fuchsia"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fuchsia_ring", "#FF0080", 1, "#property_fuchsia_ring_description")

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property2 = value
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end



function RPCItems:RollWorldTreesFlowerCache(item_level)
    local item = RPCItems:CreateVariant("item_rpc_world_trees_flower_cache", "immortal", "World Tree's Flower Cache", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "world_tree_flower"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_world_trees_flower_cache", "#C4544E", 1, "#property_world_trees_flower_cache_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_NATURE, 2, 2, 24, 2)
    else
        local value, nameLevel = RPCItems:RollAttribute(0, 6, 11, 0, 0, item.newItemTable.rarity, false, maxFactor * 11)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "all_attributes"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGalaxyOrb(item_level)
    local item = RPCItems:CreateVariant("item_rpc_galaxy_orb", "immortal", "Galaxy Orb", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "galaxy_orb"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_galaxy_orb", "#FF9100", 1, "#property_galaxy_orb_description")

    Elements:RollElementAttribute(item, RPC_ELEMENT_COSMOS, 2, 2, 30, 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = value * 2
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollPuzzlersLocket(item_level)
    local item = RPCItems:CreateVariant("item_rpc_puzzlers_locket", "immortal", "Puzzler's Locket", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "puzzler"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_puzzler", "#9AF4EB", 1, "#property_puzzler_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 4, 6, 0, 0, item.newItemTable.rarity, false, maxFactor * 8)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local runeName = "rune_"..RPCItems:GetRandomRuneLetter(1, 4) .. "_3"
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 2)
    item.newItemTable.property3name = runeName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local runeName = "rune_"..RPCItems:GetRandomRuneLetter(1, 4) .. "_2"
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = math.max(math.floor(value / 2), 1)
    item.newItemTable.property4 = RPCItems:GetLogarithmicVarianceValue(item.newItemTable.property4, 0, 0, 0, 0)
    item.newItemTable.property4name = runeName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGalvanizedRazorBand(item_level)
    local item = RPCItems:CreateVariant("item_rpc_galvanized_razor_band", "immortal", "Galvanized Razor Band", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "razor_band"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_razor_band", "#DDDDDD", 1, "#property_razor_band_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value = RandomInt(maxFactor * 100, maxFactor * 350)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = math.floor(value * 1.3)
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)


    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end


function RPCItems:RollVolcanoOrb(item_level)
    local item = RPCItems:CreateVariant("item_rpc_volcano_orb", "immortal", "Volcano Orb", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "volcano_orb"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_volcano_orb", "#995050", 1, "#property_volcano_orb_description")

    local tier, value, propertyName = RPCItems:RollAmuletProperty2(item, 300, 1)
    if tier > 0 then
        item.newItemTable.property2 = value
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = math.floor(value * 1.3)
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFractionalEnhancementGeode(item_level)
    local item = RPCItems:CreateVariant("item_rpc_fractional_enhancement_geode", "immortal", "Fractional Enhancement Geode", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "geode"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_geode", "#05FF0D", 1, "#property_geode_description")

    local difficulty = math.min(GameState:GetDifficultyFactor(), 3)
    local armorRoll = 10 ^ difficulty
    item.newItemTable.property2 = armorRoll
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = math.floor(value * 1.3)
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRingOfNobility(item_level)
    local item = RPCItems:CreateVariant("item_rpc_ring_of_nobility", "immortal", "Ring of Nobility", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "nobility"
    item.newItemTable.property1 = 0

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_nobility", "#FFFFFF", 1, "#property_nobility_description")

    local value = math.ceil(RPCItems:GetMinLevel() / 2)
    item.newItemTable.property2 = value * 5
    item.newItemTable.property2name = "item_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_damage_increase", "#F28100", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = value
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:CreateAugmentedRingOfNobility(hero, ability)
    local item = RPCItems:CreateVariantWithMin("item_rpc_ring_of_nobility_augmented", "immortal", "Ring of Nobility Augmented", "amulet", true, "Slot: Trinket", ability.newItemTable.minLevel, "", "")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "nobility_augmented"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_nobility_augmented", "#FFFFFF", 1, "#property_nobility_augmented_description")

    item.newItemTable.property2 = ability.newItemTable.property2 * 2
    item.newItemTable.property2name = ability.newItemTable.property2name
    item.newItemTable.property2color = ability.newItemTable.property2color
    item.newItemTable.property2tooltip = ability.newItemTable.property2tooltip
    -- local primaryAttribute = hero:GetRoshpitPrimaryAttribute()
    -- if primaryAttribute == 0 then
    --     item.newItemTable.property2name = "strength"
    --     RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000",  2)
    -- elseif primaryAttribute == 1 then
    --     item.newItemTable.property2name = "agility"
    --     RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E",  2)
    -- else
    --     item.newItemTable.property2name = "intelligence"
    --     RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF",  2)
    -- end

    item.newItemTable.property3 = ability.newItemTable.property3 * 2
    item.newItemTable.property3name = ability.newItemTable.property3name
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    item.newItemTable.property4 = ability.newItemTable.property4 * 2
    item.newItemTable.property4name = ability.newItemTable.property4name
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    item.pickedUp = true
    RPCItems:ItemUpdateCustomNetTables(item)
    RPCItems:AmuletPickup(hero, item)
    Weapons:Equip(hero, item)
    return item
end

function RPCItems:RollTempestFalconRing(item_level)
    local item = RPCItems:CreateVariant("item_rpc_tempest_falcon_ring", "immortal", "Tempest Falcon Ring", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "tempest_falcon"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tempest_falcon", "#92E0C5", 1, "#property_tempest_falcon_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = value
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFirelockPendant(item_level)
    local item = RPCItems:CreateVariant("item_rpc_firelock_pendant", "immortal", "Firelock Pendant", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "firelock"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_firelock", "#DE5957", 1, "#property_firelock_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    local luck = RandomInt(1, 2)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_FIRE, 2.3, 1, 30, 3)
    else
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = value
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGarnetWarfareRing(item_level)
    local item = RPCItems:CreateVariant("item_rpc_garnet_warfare_ring", "immortal", "Garnet Warfare Ring", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "garnet_warfare"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_garnet_warfare", "#D62D2D", 1, "#property_garnet_warfare_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = value
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollWindOrchid(item_level)
    local item = RPCItems:CreateVariant("item_rpc_wind_orchid", "immortal", "Wind Orchid", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "wind_orchid"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wind_orchid", "#38D667", 1, "#property_wind_orchid_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = value
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFireBlossom(item_level)
    local item = RPCItems:CreateVariant("item_rpc_fire_blossom", "immortal", "Fire Blossom", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "fire_blossom"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fire_blossom", "#D62D2D", 1, "#property_fire_blossom_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = value
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSunCrystal(deathLocation, infiniteWave)
    local item = RPCItems:CreateVariant("item_rpc_serengaard_sun_crystal", "immortal", "Serengaard Sun Crystal", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    local initRoll = RandomInt(500, 1000 + infiniteWave * 40)
    local value = math.min(RPCItems:GetLogarithmicVarianceValue(initRoll, 0, 0, 0, 0), 9000)
    item.newItemTable.property1 = value
    item.newItemTable.property1name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "#item_strength", "#CC0000", 1)

    local initRoll = RandomInt(500, 1000 + infiniteWave * 40)
    local value = math.min(RPCItems:GetLogarithmicVarianceValue(initRoll, 0, 0, 0, 0), 9000)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    local initRoll = RandomInt(500, 1000 + infiniteWave * 40)
    local value = math.min(RPCItems:GetLogarithmicVarianceValue(initRoll, 0, 0, 0, 0), 9000)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_intelligence", "#33CCFF", 3)

    local initRoll = RandomInt(35, 50 + infiniteWave * 5)
    local value = math.min(RPCItems:GetLogarithmicVarianceValue(initRoll, 0, 0, 0, 0), 1000)
    item.newItemTable.property4 = value
    item.newItemTable.property4name = "all_elements"
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "#property_all_elements", "#BED5E5", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSignusCharm(item_level)
    local item = RPCItems:CreateVariant("item_rpc_signus_charm", "immortal", "Signus Charm", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "signus"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_signus", "#ED217D", 1, "#property_signus_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 11, 0, 0, item.newItemTable.rarity, false, maxFactor * 11)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollEyeOfAvernus(item_level)
    local item = RPCItems:CreateVariant("item_rpc_eye_of_avernus", "immortal", "Eye of Avernus", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "avernus"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_avernus", "#E85F31", 1, "#property_avernus_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local magicResistRoll = RandomInt(15, 25)
    item.newItemTable.property3 = magicResistRoll
    item.newItemTable.property3name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_magic_resist", "#AC47DE", 3)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        value = math.floor(value * 1.5)
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollWindDeityCrown(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_wind_deity_crown", "immortal", "Wind Deity Crown", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_wind_deity_crown"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wind_deity", "#92E8A6", 1, "#property_wind_deity_description")

    local rune_type = RPCItems:RollRuneType({"e"}, {tier3 = 80, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "element_wind", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWaterDeityCrown(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_water_deity_crown", "immortal", "Water Deity Crown", "head", true, "Slot: Head")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "!immortal!_modifier_water_deity_crown"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_water_deity", "#5D9AF0", 1, "#property_water_deity_description")

    local rune_type = RPCItems:RollRuneType({"r"}, {tier3 = 80, tier4 = 100})
    RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, rune_type, 1.5)

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, "element_water", 1.5)
    else
        RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 1.5)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 1.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollWhiteMageHat(item_level)
    local item_slot = RPC_GEAR_SLOT_HEAD
    local rarity = RPC_ITEMS_RARITY_IMMORTAL

    local item = RPCItems:CreateVariant("item_rpc_white_mage_hat", "immortal", "White Mage Hat", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "!immortal!_modifier_white_mage_hat"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_white_mage_hat", "#FFFFFF", 1, "#property_white_mage_hat_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "health_regen", 1.25)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "all_attributes", 1.25)
    elseif luck == 3 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "spirit", 2)
    elseif luck == 4 then
        RPCItems:RollBasicItemProperty(item, item_slot, 2, item_level, "intelligence", 2)
    end
    RPCItems:RollBasicItemProperty(item, item_slot, 3, item_level, nil, 1)
    RPCItems:RollBasicItemProperty(item, item_slot, 4, item_level, nil, 1)

    RPCItems:GrantItemBaseArmor(item, item_level, 0)
    RPCItems:GrantItemBaseMagicArmor(item, item_level, 3.5)
    RPCItems:SocketsChance(item)
    RPCItems:SetBaseItemValues(item, item:GetAbilityName(), false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
    return item
end

function RPCItems:RollImmortalByName(itemName, item_level)
    local deathLocation = Vector(0,0)
    local newItem = nil
    --print(immortalName)
    if _G[itemName] then
        newItem = _G[itemName]:CreateLuaItem(item_level)
    elseif itemName == "item_rpc_magebane_gloves" then
        newItem = RPCItems:RollMageBaneGloves(item_level)
    elseif itemName == "item_rpc_direwolf_bulwark" then
        newItem = RPCItems:RollDirewolfBulwark(item_level)
    elseif itemName == "item_rpc_berserker_gloves" then
        newItem = RPCItems:RollBerserkerGloves(item_level)
    elseif itemName == "item_rpc_shadow_armlet" then
        newItem = RPCItems:RollShadowArmlet(item_level)
    elseif itemName == "item_rpc_boneguard_gauntlets" then
        newItem = RPCItems:RollBoneguardGauntlets(item_level)
    elseif itemName == "item_rpc_scorched_gauntlets" then
        newItem = RPCItems:RollScorchedGauntlets(item_level)
    elseif itemName == "item_rpc_hand_of_midas" then
        newItem = RPCItems:RollHandOfMidas(item_level)
    elseif itemName == "item_rpc_kappa_pride_gloves" then
        newItem = RPCItems:RollProudGloves(item_level)
    elseif itemName == "item_rpc_claw_of_azinoth" then
        newItem = RPCItems:RollClawOfAzinoth(item_level)
    elseif itemName == "item_rpc_gauntlet_of_divine_purity" then
        newItem = RPCItems:RollDivinePurityGauntlets(item_level)
    elseif itemName == "item_rpc_marauder_gloves" then
        newItem = RPCItems:RollMarauderGloves(item_level)
    elseif itemName == "item_rpc_grasp_of_elder" then
        newItem = RPCItems:RollElderGrasp(item_level)
    elseif itemName == "item_rpc_scarecrow_gloves" then
        newItem = RPCItems:RollScarecrowGloves(item_level)
    elseif itemName == "item_rpc_living_gauntlet" then
        newItem = RPCItems:RollLivingGauntlet(item_level)
    elseif itemName == "item_rpc_silverspring_gloves" then
        newItem = RPCItems:RollSilverspringGloves(item_level)
    elseif itemName == "item_rpc_mordiggus_gauntlet" then
        newItem = RPCItems:RollMordiggusGauntlet(item_level)
    elseif itemName == "item_rpc_ironbound_gloves" then
        newItem = RPCItems:RollIronboundGloves(item_level)
    elseif itemName == "item_rpc_far_seers_enchanted_gloves" then
        newItem = RPCItems:RollFarSeersEnchantedGloves(item_level)
    elseif itemName == "item_rpc_master_gloves" then
        newItem = RPCItems:RollMasterGloves(item_level)
    elseif itemName == "item_rpc_phoenix_gloves" then
        newItem = RPCItems:RollPhoenixGloves(item_level)
    elseif itemName == "item_rpc_eternal_essence_gauntlet" then
        newItem = RPCItems:RollEternalEssenceGauntlet(item_level)
    elseif itemName == "item_rpc_spirit_glove" then
        newItem = RPCItems:RollSpiritGlove(item_level)
    elseif itemName == "item_rpc_frostburn_gauntlets" then
        newItem = RPCItems:RollFrostburnGauntlets(item_level)
    elseif itemName == "item_rpc_mountain_vambraces" then
        newItem = RPCItems:RollMountainVambraces(item_level)
    elseif itemName == "item_rpc_grand_arcanist_wraps" then
        newItem = RPCItems:RollGrandArcanist(item_level)
    elseif itemName == "item_rpc_bladeforge_gauntlet" then
        newItem = RPCItems:RollBladeforgeGauntlet(item_level)
    elseif itemName == "item_rpc_royal_wristguards" then
        newItem = RPCItems:RollRoyalWristguards(item_level)
    elseif itemName == "item_rpc_cytopian_laser_glove" then
        newItem = RPCItems:RollCytopianLaserGloves(item_level)
    elseif itemName == "item_rpc_stormcloth_bracer" then
        newItem = RPCItems:RollStormclothBracer(item_level)
    elseif itemName == "item_rpc_power_ranger_gloves" then
        newItem = RPCItems:RollPowerRangerGloves(item_level)
    elseif itemName == "item_rpc_hurricane_vest" then
        newItem = RPCItems:RollHurricaneVest(item_level)
    elseif itemName == "item_rpc_robe_of_flooding" then
        newItem = RPCItems:RollFloodRobe(item_level)
    elseif itemName == "item_rpc_avalanche_plate" then
        newItem = RPCItems:RollAvalanchePlate(item_level)
    elseif itemName == "item_rpc_armor_of_violet_guard" then
        newItem = RPCItems:RollVioletGuardArmor(item_level)
    elseif itemName == "item_rpc_twilight_vestments" then
        newItem = RPCItems:RollTwilightVestments(item_level)
    elseif itemName == "item_rpc_radiant_ruins_leather" then
        newItem = RPCItems:RollRadiantRuinsLeather(item_level)
    elseif itemName == "item_rpc_bladestorm_vest" then
        newItem = RPCItems:RollBladestormVest(item_level)
    elseif itemName == "item_rpc_hermits_spike_shell" then
        newItem = RPCItems:RollHermitSpikeShell(item_level)
    elseif itemName == "item_rpc_seraphic_soulvest" then
        newItem = RPCItems:RollSoulVest(item_level)
    elseif itemName == "item_rpc_infused_mageplate" then
        newItem = RPCItems:RollMageplate(item_level)
    elseif itemName == "item_rpc_plate_of_the_watcher" then
        newItem = RPCItems:RollWatcherPlate(item_level)
    elseif itemName == "item_rpc_sorcerers_regalia" then
        newItem = RPCItems:RollSorcererRegalia(item_level)
    elseif itemName == "item_rpc_spellslinger_coat" then
        newItem = RPCItems:RollSpellslingerCoat(item_level)
    elseif itemName == "item_rpc_doomplate" then
        newItem = RPCItems:RollDoomplate(item_level)
    elseif itemName == "item_rpc_ocean_tempest_pallium" then
        newItem = RPCItems:RollOceanTempestPallium(item_level)
    elseif itemName == "item_rpc_savage_plate_of_ogthun" then
        newItem = RPCItems:RollSavagePlateOfOgthun(item_level)
    elseif itemName == "item_rpc_ice_quill_carapace" then
        newItem = RPCItems:RollIceQuillCarapace(item_level)
    elseif itemName == "item_rpc_featherwhite_armor" then
        newItem = RPCItems:RollFeatherwhiteArmor(item_level)
    elseif itemName == "item_rpc_dragon_ceremony_vestments" then
        newItem = RPCItems:RollDragonCeremonyVestments(item_level)
    elseif itemName == "item_rpc_armor_of_secret_temple" then
        newItem = RPCItems:RollSecretTempleArmor(item_level)
    elseif itemName == "item_rpc_vampiric_breastplate" then
        newItem = RPCItems:RollVampiricBreastplate(item_level)
    elseif itemName == "item_rpc_skyforge_flurry_plate" then
        newItem = RPCItems:RollSkyforgeFlurryPlate(item_level)
    elseif itemName == "item_rpc_dark_arts_vestments" then
        newItem = RPCItems:RollDarkArtsVestments(item_level)
    elseif itemName == "item_rpc_legion_vestments" then
        newItem = RPCItems:RollLegionVestments(item_level)
    elseif itemName == "item_rpc_nightmare_rider_mantle" then
        newItem = RPCItems:RollNightmareRiderMantle(item_level)
    elseif itemName == "item_rpc_space_tech_vest" then
        newItem = RPCItems:RollSpaceTechVest(item_level)
    elseif itemName == "item_rpc_stormshield_cloak" then
        newItem = RPCItems:RollStormshieldCloak(item_level)
    elseif itemName == "item_rpc_the_infernal_prison" then
        newItem = RPCItems:RollInfernalPrison(item_level)
    elseif itemName == "item_rpc_enchanted_solar_cape" then
        newItem = RPCItems:RollEnchantedSolarCape(item_level)
    elseif itemName == "item_rpc_gilded_soul_cage" then
        newItem = RPCItems:RollGildedSoulCage(item_level)
    elseif itemName == "item_rpc_bluestar_armor" then
        newItem = RPCItems:RollBluestarArmor(item_level)
    elseif itemName == "item_rpc_windsteel_armor" then
        newItem = RPCItems:RollWindsteelArmor(item_level)
    elseif itemName == "item_rpc_white_mage_hat" then
        newItem = RPCItems:RollWhiteMageHat(item_level)
    elseif itemName == "item_rpc_hyper_visor" then
        newItem = RPCItems:RollHyperVisor(item_level)
    elseif itemName == "item_rpc_crown_of_ruby_dragon" then
        newItem = RPCItems:RollRubyDragonCrown(item_level)
    elseif itemName == "item_rpc_centaur_horns" then
        newItem = RPCItems:RollCentaurHorns(item_level)
    elseif itemName == "item_rpc_hood_of_chosen" then
        newItem = RPCItems:RollHoodOfChosen(item_level)
    elseif itemName == "item_rpc_death_whisper_helm" then
        newItem = RPCItems:RollDeathWhisperHelm(item_level)
    elseif itemName == "item_rpc_guard_of_grithault" then
        newItem = RPCItems:RollGuardOfGrithault(item_level)
    elseif itemName == "item_rpc_cap_of_wild_nature" then
        newItem = RPCItems:RollCapOfWildNature(item_level)
    elseif itemName == "item_rpc_guard_of_luma" then
        newItem = RPCItems:RollLumaGuard(item_level)
    elseif itemName == "item_rpc_brazen_kabuto_of_the_desert_realm" then
        newItem = RPCItems:RollBrazenKabuto(item_level)
    elseif itemName == "item_rpc_odin_helmet" then
        newItem = RPCItems:RollOdinHelmet(item_level)
    elseif itemName == "item_rpc_mask_of_mugato" then
        newItem = RPCItems:RollMugatoMask(item_level)
    elseif itemName == "item_rpc_swamp_witch_hat" then
        newItem = RPCItems:RollWitchHat(item_level)
    elseif itemName == "item_rpc_tricksters_mask" then
        newItem = RPCItems:RollTricksterMask(item_level)
    elseif itemName == "item_rpc_demon_mask" then
        newItem = RPCItems:RollDemonMask(item_level, 0)
    elseif itemName == "item_rpc_crest_of_the_umbral_sentinel" then
        newItem = RPCItems:RollCrestOfTheUmbralSentinel(item_level)
    elseif itemName == "item_rpc_carbuncles_helm_of_reflection" then
        newItem = RPCItems:RollCarbuncleHelm(item_level)
    elseif itemName == "item_rpc_wraith_hunters_steel_helm" then
        newItem = RPCItems:RollWraithHuntersSteelHelm(item_level)
    elseif itemName == "item_rpc_emerald_douli" then
        newItem = RPCItems:RollEmeraldDouli(item_level)
    elseif itemName == "item_rpc_mask_of_tyrius" then
        newItem = RPCItems:RollMaskOfTyrius(item_level)
    elseif itemName == "item_rpc_veil_of_the_cerulean_high_guard" then
        newItem = RPCItems:RollCeruleanHighguard(item_level)
    elseif itemName == "item_rpc_blackfeather_crown" then
        newItem = RPCItems:RollBlackfeatherCrown(item_level)
    elseif itemName == "item_rpc_super_ascendency_mask" then
        newItem = RPCItems:RollSuperAscendency(item_level)
    elseif itemName == "item_rpc_mask_of_the_phantom_sorcerer" then
        newItem = RPCItems:RollPhantomSorcererMask(item_level)
    elseif itemName == "item_rpc_arcane_cascade_hat" then
        newItem = RPCItems:RollArcaneCascadeHat(item_level)
    elseif itemName == "item_rpc_adamantine_samurai_helmet" then
        newItem = RPCItems:RollSamuraiHelmet(item_level)
    elseif itemName == "item_rpc_scourge_knights_helm" then
        newItem = RPCItems:RollScourgeKnightHelm(item_level)
    elseif itemName == "item_rpc_mask_of_the_desert_necromancer" then
        newItem = RPCItems:RollNecromancerMask(item_level)
    elseif itemName == "item_rpc_undertakers_hood" then
        newItem = RPCItems:RollUndertakersHood(item_level)
    elseif itemName == "item_rpc_shroud_of_eternal_night" then
        newItem = RPCItems:RollEternalNightShroud(item_level)
    elseif itemName == "item_rpc_wolfir_druids_spirit_helm" then
        newItem = RPCItems:RollDruidsSpiritHelm(item_level)
    elseif itemName == "item_rpc_blinded_glint_of_onu" then
        newItem = RPCItems:RollGlintOfOnu(item_level)
    elseif itemName == "item_rpc_crown_of_the_roknar_emperor" then
        newItem = RPCItems:RollRoknarEmperor(item_level)
    elseif itemName == "item_rpc_swamp_doctors_tribal_mask" then
        newItem = RPCItems:RollSwampDoctorMask(item_level)
    elseif itemName == "item_rpc_dunetread_boots" then
        newItem = RPCItems:RollDunetreadBoots(item_level)
    elseif itemName == "item_rpc_voyager_boots" then
        newItem = RPCItems:RollVoyagerBoots(item_level)
    elseif itemName == "item_rpc_redrock_footwear" then
        newItem = RPCItems:RollRedrockFootwear(item_level)
    elseif itemName == "item_rpc_pathfinders_resonant_boots" then
        newItem = RPCItems:RollResonantPathfinderBoots(item_level)
    elseif itemName == "item_rpc_neptunes_water_gliders" then
        newItem = RPCItems:RollNeptunesWaterGliders(item_level)
    elseif itemName == "item_rpc_boots_of_the_violet_guard" then
        newItem = RPCItems:RollVioletTreads(item_level)
    elseif itemName == "item_rpc_slinger_boots" then
        newItem = RPCItems:SlingerBoots(item_level)
    elseif itemName == "item_rpc_guardian_greaves" then
        newItem = RPCItems:RollGuardianGreaves(item_level)
    elseif itemName == "item_rpc_blue_dragon_greaves" then
        newItem = RPCItems:RollBlueDragonGreaves(item_level)
    elseif itemName == "item_rpc_sange_boots" then
        newItem = RPCItems:RollSangeBoots(item_level)
    elseif itemName == "item_rpc_boots_of_old_wisdom" then
        newItem = RPCItems:RollBootsOfOldWisdom(item_level)
    elseif itemName == "item_rpc_resplendent_rubber_boots" then
        newItem = RPCItems:RollResplendantRubberBoots(item_level)
    elseif itemName == "item_rpc_ghost_slippers" then
        newItem = RPCItems:RollGhostSlippers(item_level)
    elseif itemName == "item_rpc_yasha_boots" then
        newItem = RPCItems:RollYashaBoots(item_level)
    elseif itemName == "item_rpc_tranquil_boots" then
        newItem = RPCItems:RollTranquilBoots(item_level)
    elseif itemName == "item_rpc_fire_walkers" then
        newItem = RPCItems:RollFireWalkers(item_level)
    elseif itemName == "item_rpc_mana_striders" then
        newItem = RPCItems:RollManaStriders(item_level)
    elseif itemName == "item_rpc_moon_tech_runners" then
        newItem = RPCItems:RollMoonTechs(item_level)
    elseif itemName == "item_rpc_sonic_boots" then
        newItem = RPCItems:RollSonicBoots(item_level)
    elseif itemName == "item_rpc_falcon_boots" then
        newItem = RPCItems:RollFalconBoots(item_level)
    elseif itemName == "item_rpc_crusader_boots" then
        newItem = RPCItems:RollCrusaderBoots(item_level)
    elseif itemName == "item_rpc_arcanys_slipper" then
        newItem = RPCItems:RollArcanysSlipper(item_level)
    elseif itemName == "item_rpc_swamp_waders" then
        newItem = RPCItems:RollSwampWaders(item_level)
    elseif itemName == "item_rpc_admiral_boots" then
        newItem = RPCItems:RollAdmiralBoot(item_level)
    elseif itemName == "item_rpc_rooted_feet" then
        newItem = RPCItems:RollRootedFeet(item_level)
    elseif itemName == "item_rpc_blacksmiths_tablet" then
        newItem = RPCItems:RollBlacksmithsTablet(item_level)
    elseif itemName == "item_rpc_stone_of_gordon" then
        newItem = RPCItems:RollStoneOfGordon(deathLocation, 6)
    elseif itemName == "item_rpc_sapphire_lotus" then
        newItem = RPCItems:RollSapphireLotus(item_level)
    elseif itemName == "item_rpc_arbor_dragonfly" then
        newItem = RPCItems:RollArborDragonfly(item_level)
    elseif itemName == "item_rpc_gem_of_eternal_frost" then
        newItem = RPCItems:RollFrostGem(item_level)
    elseif itemName == "item_rpc_lifesource_vessel" then
        newItem = RPCItems:RollLifesourceVessel(item_level)
    elseif itemName == "item_rpc_tome_of_chaos" then
        newItem = RPCItems:RollTomeOfChaos(item_level)
    elseif itemName == "item_rpc_aeriths_tear" then
        newItem = RPCItems:RollAerithsTear(item_level)
    elseif itemName == "item_rpc_torch_of_gengar" then
        newItem = RPCItems:RollTorchOfGengar(item_level)
    elseif itemName == "item_rpc_ruinfall_skull_token" then
        newItem = RPCItems:RollRuinfallSkullToken(item_level)
    elseif itemName == "item_rpc_raven_idol" then
        newItem = RPCItems:RollRavenIdol(item_level)
    elseif itemName == "item_rpc_omega_ruby" then
        newItem = RPCItems:RollOmegaRuby(item_level)
    elseif itemName == "item_rpc_phoenix_emblem" then
        newItem = RPCItems:RollPhoenixEmblem(item_level)
    elseif itemName == "item_rpc_hope_of_saytaru" then
        newItem = RPCItems:RollHopeOfSaytaru(item_level)
    elseif itemName == "item_rpc_galaxy_orb" then
        newItem = RPCItems:RollGalaxyOrb(item_level)
    elseif itemName == "item_rpc_volcano_orb" then
        newItem = RPCItems:RollVolcanoOrb(item_level)
    elseif itemName == "item_rpc_fractional_enhancement_geode" then
        newItem = RPCItems:RollFractionalEnhancementGeode(item_level)
    elseif itemName == "item_rpc_ring_of_nobility" then
        newItem = RPCItems:RollRingOfNobility(item_level)
    elseif itemName == "item_rpc_azure_empire" then
        newItem = RPCItems:RollAzureEmpire(item_level)
    elseif itemName == "item_rpc_signus_charm" then
        newItem = RPCItems:RollSignusCharm(item_level)
    elseif itemName == "item_rpc_eye_of_avernus" then
        newItem = RPCItems:RollEyeOfAvernus(item_level)
    elseif itemName == "item_rpc_twig_of_the_enlightened" then
        newItem = RPCItems:RollTwigOfEnlightened(item_level)
    elseif itemName == "item_rpc_boots_of_pure_waters" then
        newItem = RPCItems:RollBootsOfPureWaters(item_level)
    elseif itemName == "item_rpc_gloves_of_sweeping_wind" then
        newItem = RPCItems:RollGlovesOfSweepingWind(item_level)
    elseif itemName == "item_rpc_depth_crest_armor" then
        newItem = RPCItems:RollDepthCrestArmor(item_level)
    elseif itemName == "item_rpc_terrasic_stone_plate" then
        newItem = RPCItems:RollTerrasicStonePlate(item_level)
    elseif itemName == "item_rpc_crown_of_the_lava_forge" then
        newItem = RPCItems:RollLavaForgeCrown(item_level)
    elseif itemName == "item_rpc_ancient_tanari_waterstone" then
        newItem = RPCItems:RollAncientTanariWaterstone(item_level)
    elseif itemName == "item_rpc_tempest_falcon_ring" then
        newItem = RPCItems:RollTempestFalconRing(item_level)
    elseif itemName == "item_rpc_firelock_pendant" then
        newItem = RPCItems:RollFirelockPendant(item_level)
    elseif itemName == "item_rpc_water_mage_robes" then
        newItem = RPCItems:RollWaterMageRobes(item_level)
    elseif itemName == "item_rpc_halcyon_soul_glove" then
        newItem = RPCItems:RollHalcyonSoulGlove(item_level)
    elseif itemName == "item_rpc_golden_war_plate" then
        newItem = RPCItems:RollGoldenWarPlate(item_level)
    elseif itemName == "item_rpc_hood_of_defiler" then
        newItem = RPCItems:RollHoodOfDefiler(item_level)
    elseif itemName == "item_rpc_excavators_focus_cap" then
        newItem = RPCItems:RollExcavatorsFocusHat(item_level)
    elseif itemName == "item_rpc_terrasic_lava_boots" then
        newItem = RPCItems:RollTerrasicLavaBoots(item_level)
    elseif itemName == "item_rpc_helm_of_champions" then
        newItem = RPCItems:RollChampionsGearHelm(item_level)
    elseif itemName == "item_rpc_gauntlet_of_champions" then
        newItem = RPCItems:RollChampionsGearGauntlet(item_level)
    elseif itemName == "item_rpc_champions_mail" then
        newItem = RPCItems:RollChampionsGearMail(item_level)
    elseif itemName == "item_rpc_boots_of_champions" then
        newItem = RPCItems:RollChampionsGearBoots(item_level)
    elseif itemName == "item_rpc_greensand_copper_gauntlets" then
        newItem = RPCItems:RollGreensandCopperGauntlets(item_level)
    elseif itemName == "item_rpc_gold_plate_of_leon" then
        newItem = RPCItems:RollGoldPlateOfLeon(item_level)
    elseif itemName == "item_rpc_staggering_knight_crusher_armor" then
        newItem = RPCItems:RollKnightCrusherArmor(item_level)
    elseif itemName == "item_rpc_stormcrack_helm" then
        newItem = RPCItems:RollStormcrackHelm(item_level)
    elseif itemName == "item_rpc_antique_mana_relic" then
        newItem = RPCItems:RollAntiqueManaRelic(item_level)
    elseif itemName == "item_rpc_ablecore_greaves" then
        newItem = RPCItems:RollAblecoreGreaves(item_level)
    elseif itemName == "item_rpc_glove_of_the_forgotten_ghost" then
        newItem = RPCItems:RollGloveOfTheForgottenGhost(item_level)
    elseif itemName == "item_rpc_sapphire_dragon_scale_armor" then
        newItem = RPCItems:RollSapphireDragonScaleArmor(item_level)
    elseif itemName == "item_rpc_topaz_dragon_scale_armor" then
        newItem = RPCItems:RollTopazDragonScaleArmor(item_level)
    elseif itemName == "item_rpc_ruby_dragon_scale_armor" then
        newItem = RPCItems:RollRubyDragonScaleArmor(item_level)
    elseif itemName == "item_rpc_basilisk_plague_helm" then
        newItem = RPCItems:RollBasiliskPlagueHelm(item_level)
    elseif itemName == "item_rpc_giant_hunters_boots_of_resilience" then
        newItem = RPCItems:RollGiantHunterBoots(item_level)
    elseif itemName == "item_rpc_spiritual_empowerment_glove" then
        newItem = RPCItems:RollSpiritualEmpowermentGlove(item_level)
    elseif itemName == "item_rpc_hood_of_the_black_mage" then
        newItem = RPCItems:RollHoodOfBlackMage(item_level)
    elseif itemName == "item_rpc_sacred_trials_armor" then
        newItem = RPCItems:RollSacredTrialsArmor(item_level)
    elseif itemName == "item_rpc_gravekeepers_gauntlet" then
        newItem = RPCItems:RollGravekeepersGauntlet(item_level)
    elseif itemName == "item_rpc_conquest_stone_falcon" then
        newItem = RPCItems:RollConquestStoneFalcon(item_level)
    elseif itemName == "item_rpc_epsilons_eyeglass" then
        newItem = RPCItems:RollEpsilonsEyeglass(item_level)
    elseif itemName == "item_rpc_heroic_conqueror_vestments" then
        --print("GIMME DAT")
        newItem = RPCItems:RollHeroicConquerorVestments(item_level)
    elseif itemName == "item_rpc_autumn_sleeper_mask" then
        newItem = RPCItems:RollAutumnSleeperMask(item_level)
    elseif itemName == "item_rpc_eye_of_seasons" then
        newItem = RPCItems:RollEyeOfSeasons(item_level)
    elseif itemName == "item_rpc_fenrirs_fang" then
        newItem = RPCItems:RollFenrirFang(item_level)
    elseif itemName == "item_rpc_boots_of_ashara" then
        newItem = RPCItems:RollBootsOfAshara(item_level)
    elseif itemName == "item_rpc_autumnrock_bracer" then
        newItem = RPCItems:RollAutumnrockBracers(item_level)
    elseif itemName == "item_rpc_guard_of_feronia" then
        newItem = RPCItems:RollGuardOfFeronia(item_level)
    elseif itemName == "item_rpc_fuchsia_ring" then
        newItem = RPCItems:RollFuchsiaRing(item_level)
    elseif itemName == "item_rpc_helm_of_the_silent_templar" then
        newItem = RPCItems:RollHelmOfSilentTemplar(item_level)
    elseif itemName == "item_rpc_mystic_mana_wall" then
        newItem = RPCItems:RollMysticManaWall(item_level)
    elseif itemName == "item_rpc_sandstream_slippers" then
        newItem = RPCItems:RollSandstreamSlippers(item_level)
    elseif itemName == "item_rpc_malachite_shade_bracer" then
        newItem = RPCItems:RollMalachiteShadeBracer(item_level)
    elseif itemName == "item_rpc_wind_deity_crown" then
        newItem = RPCItems:RollWindDeityCrown(item_level)
    elseif itemName == "item_rpc_water_deity_crown" then
        newItem = RPCItems:RollWaterDeityCrown(item_level)
    elseif itemName == "item_rpc_fire_deity_crown" then
        newItem = RPCItems:RollFireDeityCrown(item_level)
    elseif itemName == "item_rpc_skulldigger_gauntlet_lv1" then
        newItem = RPCItems:RollSkulldiggerGlovesLV1(item_level)
    elseif itemName == "item_rpc_shipyard_veil_lv1" then
        newItem = RPCItems:RollShipyardVeil(item_level)
    elseif itemName == "item_rpc_crimsyth_elite_greaves_lv1" then
        newItem = RPCItems:RollCrimsythEliteGreavesLV1(item_level)
    elseif itemName == "item_rpc_harvester_boots" then
        newItem = RPCItems:RollHarvesterBoots(item_level)
    elseif itemName == "item_rpc_fortunes_talisman_of_truth" then
        newItem = RPCItems:RollFortunesTalismanOfTruth(item_level)
    elseif itemName == "item_rpc_vermillion_dream_robes" then
        newItem = RPCItems:RollVermillionDreamRobes(item_level)
    elseif itemName == "item_rpc_boots_of_great_fortune" then
        newItem = RPCItems:RollBootsOfGreatFortune(item_level)
    elseif itemName == "item_rpc_cobalt_serenity_ring" then
        newItem = RPCItems:RollCobaltSerenityRing(item_level)
    elseif itemName == "item_rpc_emerald_nullification_ring" then
        newItem = RPCItems:RollEmeraldNullificationRing(item_level)
    elseif itemName == "item_rpc_garnet_warfare_ring" then
        newItem = RPCItems:RollGarnetWarfareRing(item_level)
    elseif itemName == "item_rpc_claws_of_the_ethereal_revenant" then
        newItem = RPCItems:RollClawOfTheEtherealRevenant(item_level)
    elseif itemName == "item_rpc_crimson_skull_cap" then
        newItem = RPCItems:RollCrimsonSkullCap(item_level)
    elseif itemName == "item_rpc_spellfire_gloves" then
        newItem = RPCItems:RollSpellfireGloves(item_level)
    elseif itemName == "item_rpc_bloodstone_boots" then
        newItem = RPCItems:RollBloodstoneBoots(item_level)
    elseif itemName == "item_rpc_igneous_canine_helm" then
        newItem = RPCItems:RollIgneousCanineHelm(item_level)
    elseif itemName == "item_rpc_barons_storm_armor" then
        newItem = RPCItems:RollBaronsStormArmor(item_level)
    elseif itemName == "item_rpc_serengaard_sun_crystal" then
        newItem = RPCItems:RollSunCrystal(deathLocation, 1)
    elseif itemName == "item_rpc_temporal_warp_boots" then
        newItem = RPCItems:RollTemporalWarpBoots(item_level)
    elseif itemName == "item_rpc_aqua_lily" then
        newItem = RPCItems:RollAquaLily(item_level)
    elseif itemName == "item_rpc_fire_blossom" then
        newItem = RPCItems:RollFireBlossom(item_level)
    elseif itemName == "item_rpc_wind_orchid" then
        newItem = RPCItems:RollWindOrchid(item_level)
    elseif itemName == "item_rpc_ankh_of_the_ancients" then
        newItem = RPCItems:RollAnkhOfAncients(item_level)
    elseif itemName == "item_rpc_alaranas_ice_boot" then
        newItem = RPCItems:RollAlaranaIceBoot(item_level)
    elseif itemName == "item_rpc_ancient_tanari_wind_armor" then
        newItem = RPCItems:RollTanariWindArmor(item_level)
    elseif itemName == "item_rpc_blue_rain_gauntlet" then
        newItem = RPCItems:RollBlueRainGauntlet(item_level)
    elseif itemName == "item_rpc_shadowflame_fist" then
        newItem = RPCItems:RollShadowflameFist(item_level)
    elseif itemName == "item_rpc_blazing_fury_armor" then
        newItem = RPCItems:RollBlazingFuryArmor(item_level)
    elseif itemName == "item_rpc_aquastone_ring" then
        newItem = RPCItems:RollAquastoneRing(item_level)
    elseif itemName == "item_rpc_burning_spirit_helmet" then
        newItem = RPCItems:RollBurningSpiritHelmet(item_level)
    elseif itemName == "item_rpc_aquasteel_bracers" then
        newItem = RPCItems:RollAquasteelBracers(item_level)
    elseif itemName == "item_rpc_demonfire_gauntlet" then
        newItem = RPCItems:RollDemonfireGauntlet(item_level)
    elseif itemName == "item_rpc_emerald_speed_runners" then
        newItem = RPCItems:RollEmeraldSpeedRunners(item_level)
    elseif itemName == "item_rpc_outland_stone_cuirass" then
        newItem = RPCItems:RollOutlandStoneCuirass(item_level)
    elseif itemName == "item_rpc_world_trees_flower_cache" then
        newItem = RPCItems:RollWorldTreesFlowerCache(item_level)
    elseif itemName == "item_rpc_red_october_boots" then
        newItem = RPCItems:RollEternalForestStriders(item_level)
    elseif itemName == "item_rpc_chitinous_lobster_claw" then
        newItem = RPCItems:RollChitinousLobsterClaw(item_level)
    elseif itemName == "item_rpc_crystalline_slippers" then
        newItem = RPCItems:RollCrystallineSlippers(item_level)
    elseif itemName == "item_rpc_dark_emissary_glove" then
        newItem = RPCItems:RollDarkEmissaryGlove(item_level)
    elseif itemName == "item_rpc_dark_reef_shark_helmet" then
        newItem = RPCItems:RollDarkReefSharkHelmet(item_level)
    elseif itemName == "item_rpc_depth_demon_claw" then
        newItem = RPCItems:RollDepthDemonClaw(item_level)
    elseif itemName == "item_rpc_empyreal_sunrise_robe" then
        newItem = RPCItems:RollEmpyrealSunriseRobe(item_level)
    elseif itemName == "item_rpc_hood_of_the_sea_oracle" then
        newItem = RPCItems:RollHoodOfTheSeaOracle(item_level)
    elseif itemName == "item_rpc_ocean_helm_of_valdun" then
        newItem = RPCItems:RollOceanHelmOfValdun(item_level)
    elseif itemName == "item_rpc_oceanrunner_boots" then
        newItem = RPCItems:RollOceanrunnerBoots(item_level)
    elseif itemName == "item_rpc_sea_giants_plate" then
        newItem = RPCItems:RollSeaGiantsPlate(item_level)
    elseif itemName == "item_rpc_sparkling_token_of_oceanis" then
        newItem = RPCItems:RollTokenOfOceanis(item_level)
    elseif itemName == "item_rpc_templar_light_seers_robe" then
        newItem = RPCItems:RollLightSeersRobes(item_level)
    elseif itemName == "item_rpc_twisted_blue_mask_of_ahnqhir" then
        newItem = RPCItems:RollTwistedMaskOfAhnqhirBlue(item_level)
    elseif itemName == "item_rpc_twisted_yellow_mask_of_ahnqhir" then
        newItem = RPCItems:RollTwistedMaskOfAhnqhirYellow(item_level)
    elseif itemName == "item_rpc_twisted_purple_mask_of_ahnqhir" then
        newItem = RPCItems:RollTwistedMaskOfAhnqhirPurple(item_level)
    elseif itemName == "item_rpc_steamboots" then
        newItem = RPCItems:RollSteamboots(item_level)
    elseif itemName == "item_rpc_monkey_paw" then
        newItem = RPCItems:RollMonkeyPaw(item_level)
    elseif itemName == "item_rpc_arcane_charm" then
        newItem = RPCItems:RollArcaneCharm(item_level)
    elseif itemName == "item_rpc_skulldigger_gauntlet" then
        newItem = RPCItems:RollSkulldiggerGloves(item_level)
    elseif itemName == "item_rpc_winterblight_skull_ring" then
        newItem = RPCItems:RollWinterblightSkullRing(item_level)
    elseif itemName == "item_rpc_heavy_echo_gauntlet" then
        newItem = RPCItems:RollHeavyEchoGauntlet(item_level)
    elseif itemName == "item_rpc_frostmaw_hunters_hood" then
        newItem = RPCItems:RollFrostmawHuntersHood(item_level)
    elseif itemName == "item_rpc_frozen_heart" then
        newItem = RPCItems:RollFrozenHeart(item_level)
    elseif itemName == "item_rpc_energy_whip_glove" then
        newItem = RPCItems:RollEnergyWhipGlove(item_level)
    elseif itemName == "item_rpc_boreal_granite_vest" then
        newItem = RPCItems:RollBorealGraniteVest(item_level)
    elseif itemName == "item_rpc_captains_vest" then
        newItem = RPCItems:RollCaptainsVest(item_level)
    elseif itemName == "item_rpc_gravelfoot_treads" then
        newItem = RPCItems:RollGravelfootTreads(item_level)
    elseif itemName == "item_rpc_ice_floe_slippers" then
        newItem = RPCItems:RollIceFloeSlippers(item_level)
    elseif itemName == "item_rpc_iron_treads_of_destruction" then
        newItem = RPCItems:RollIronTreadsOfDestruction(item_level)
    elseif itemName == "item_rpc_tattered_novice_armor" then
        newItem = RPCItems:RollTatteredNoviceArmor(item_level)
    elseif itemName == "item_rpc_buzukis_finger" then
        newItem = RPCItems:RollBuzukisFinger(item_level)
    elseif itemName == "item_rpc_swiftspike_bracer" then
        newItem = RPCItems:RollSwiftspikeBracer(item_level)
    elseif itemName == "item_rpc_red_divinex_amulet" then
        newItem = RPCItems:RollRedDivinexAmulet(item_level)
    elseif itemName == "item_rpc_green_divinex_amulet" then
        newItem = RPCItems:RollGreenDivinexAmulet(item_level)
    elseif itemName == "item_rpc_blue_divinex_amulet" then
        newItem = RPCItems:RollBlueDivinexAmulet(item_level)
    elseif itemName == "item_rpc_helm_of_the_mountain_giant" then
        newItem = RPCItems:RollHelmOfTheMountainGiant(item_level)
    elseif itemName == "item_rpc_chains_of_orthok" then
        newItem = RPCItems:RollChainsOfOrthok(item_level)
    elseif itemName == "item_rpc_puzzlers_locket" then
        newItem = RPCItems:RollPuzzlersLocket(item_level)
    elseif itemName == "item_rpc_diamond_claws_of_tiamat" then
        newItem = RPCItems:RollDiamondClawsOfTiamat(item_level)
    elseif itemName == "item_rpc_galvanized_razor_band" then
        newItem = RPCItems:RollGalvanizedRazorBand(item_level)
    elseif itemName == "item_rpc_goldbreaker_gauntlet" then
        newItem = RPCItems:RollGoldbreakerGauntlet(item_level)
    elseif itemName == "item_rpc_pegasus_boots" then
        newItem = RPCItems:RollPegasusBoots(item_level)
    elseif itemName == "item_rpc_guardian_stone" then
        newItem = RPCItems:RollGuardianStone(item_level)
    elseif itemName == "item_rpc_robe_of_the_erudite_teacher" then
        newItem = RPCItems:RollRobesOfEruditeTeacher(item_level)
    elseif itemName == "item_rpc_pivotal_swiftboots" then
        newItem = RPCItems:RollPivotalSwiftboots(item_level)
    elseif itemName == "item_rpc_alien_armor" then
        newItem = RPCItems:RollAlienArmor(item_level)
    elseif itemName == "item_rpc_magistrates_hood" then
        newItem = RPCItems:RollMagistratesHood(item_level)
    elseif itemName == "item_rpc_nethergrasp_palisade" then
        newItem = RPCItems:NethergraspPalisade(item_level)
    elseif itemName == "item_rpc_beryl_ring_of_intuition" then
        newItem = RPCItems:RollBerylRingOfIntuition(item_level)
    elseif itemName == "item_rpc_auric_ring_of_inspiration" then
        newItem = RPCItems:RollAuricRingOfInspiration(item_level)
    elseif itemName == "item_rpc_helm_of_the_knight_hawk" then
	   newItem = RPCItems:RollHelmOfKnightHawk(item_level)
    elseif itemName == "item_rpc_wraith_crown" then
        newItem = RPCItems:RollWraithCrown(item_level)
    end
    return newItem
end

function RPCItems:RerollImmortal(hero, item, slotLock1, slotLock2, slotLock3, slotLock4, itemLevel, oldItemProperties)
    --print("[RPCItems:RerollImmortal]")
    local itemName = item:GetAbilityName()
    ----print(itemName)
    local newItem = false
    local isShop = false
    local giveBackOldItem = false
    local deathLocation = RPCItems.DROP_LOCATION
    if GameState:IsTutorial() then
        Events.DifficultyFactor = 3
        Events.SpiritRealm = true
    end
    local item_level = itemLevel
    if item.isLuaItem then
        newItem = item:CreateLuaItem(item_level)
    else
        newItem = RPCItems:RollImmortalByName(item:GetAbilityName(), item_level)
    end
    --print(newItem)
    if newItem then
    else
        newItem = false
        giveBackOldItem = true
    end
    if newItem then
        if not newItem:IsNull() then
            if IsValidEntity(newItem) then
                if IsValidEntity(newItem:GetContainer()) then
                    UTIL_Remove(newItem:GetContainer())
                end
            else
                newItem = false
            end
        else
            newItem = false
        end
    end
    RPCItems.LevelRoll = false
    if not newItem or giveBackOldItem or not IsValidEntity(newItem) then
        -- RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
        Notifications:Top(hero:GetPlayerOwnerID(), {text = "This Item Can Not Be Rerolled", duration = 5, style = {color = "red"}, continue = true})
    else
        newItem.pickedUp = true
        newItem.newItemTable.minLevel = itemLevel
        newItem.newItemTable.validator = oldItemProperties.validator
        newItem.newItemTable.socket1 = oldItemProperties.socket1
        newItem.newItemTable.socket1value = oldItemProperties.socket1value
        newItem.newItemTable.socket2 = oldItemProperties.socket2
        newItem.newItemTable.socket2value = oldItemProperties.socket2value
        -- local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(newItem:GetEntityIndex()))

        -- CustomNetTables:SetTableValue( "item_basics", tostring(newItem:GetEntityIndex()),
        --     {itemName = itemInfo.item_name,
        --     consumable = itemInfo.consumable,
        --     itemDescription = itemInfo.itemDescription,
        --     qualityColor = itemInfo.qualityColor,
        --     qualityName = itemInfo.qualityName,
        --     itemPrefix = itemInfo.itemPrefix,
        --     itemSuffix = itemInfo.itemSuffix,
        --     rarityFactor = itemInfo.rarityFactor,
        --     minLevel = newItem.newItemTable.minLevel } )

        if slotLock1 == 1 then
            newItem.newItemTable.property1 = oldItemProperties.property1
            newItem.newItemTable.property1name = oldItemProperties.property1name
            newItem.newItemTable.property1color = oldItemProperties.property1color
            newItem.newItemTable.property1tooltip = oldItemProperties.property1tooltip
            newItem.newItemTable.property1special = oldItemProperties.property1special
        end
        if slotLock2 == 1 then
            newItem.newItemTable.property2 = oldItemProperties.property2
            newItem.newItemTable.property2name = oldItemProperties.property2name
            newItem.newItemTable.property2color = oldItemProperties.property2color
            newItem.newItemTable.property2tooltip = oldItemProperties.property2tooltip
            newItem.newItemTable.property2special = oldItemProperties.property2special
        end
        if slotLock3 == 1 then
            newItem.newItemTable.property3 = oldItemProperties.property3
            newItem.newItemTable.property3name = oldItemProperties.property3name
            newItem.newItemTable.property3color = oldItemProperties.property3color
            newItem.newItemTable.property3tooltip = oldItemProperties.property3tooltip
            newItem.newItemTable.property3special = oldItemProperties.property3special
        end
        if slotLock4 == 1 then
            newItem.newItemTable.property4 = oldItemProperties.property4
            newItem.newItemTable.property4name = oldItemProperties.property4name
            newItem.newItemTable.property4color = oldItemProperties.property4color
            newItem.newItemTable.property4tooltip = oldItemProperties.property4tooltip
            newItem.newItemTable.property4special = oldItemProperties.property4special
        end
        newItem.newItemTable.base_armor = oldItemProperties.base_armor
        newItem.newItemTable.base_magic_armor = oldItemProperties.base_magic_armor
        RPCItems:ItemUpdateCustomNetTables(newItem)

        if item then
            if IsValidEntity(item:GetContainer()) then
                UTIL_Remove(item:GetContainer())
            end
        end
        if newItem then
            if IsValidEntity(newItem:GetContainer()) then
                UTIL_Remove(newItem:GetContainer())
            end
        else
            RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
            Notifications:Top(hero:GetPlayerOwnerID(), {text = "This Item Can Not Be Rerolled", duration = 5, style = {color = "red"}, continue = true})
        end

        if item:GetAbilityName() == newItem:GetAbilityName() then
            --print("NEW ITEM IS ACCEPTABLE")

        end
        if IsValidEntity(newItem) then
            newItem.expiryTime = false
        end
        if IsValidEntity(item) then
            item.expiryTime = false
        end
    end
    if GameState:IsTutorial() then
        Events.DifficultyFactor = 1
        Events.SpiritRealm = false
    end
    return newItem
end

function RPCItems:GetWorldDropImmortalNamesList(gear_slot)
    local itemsList = {}
    if gear_slot == RPC_GEAR_SLOT_HEAD then
        itemsList = {"item_rpc_adamantine_samurai_helmet", "item_rpc_arcane_cascade_hat", "item_rpc_blackfeather_crown", "item_rpc_blinded_glint_of_onu", "item_rpc_brazen_kabuto_of_the_desert_realm", "item_rpc_cap_of_wild_nature", "item_rpc_carbuncles_helm_of_reflection", 
        "item_rpc_centaur_horns", "item_rpc_crest_of_the_umbral_sentinel", "item_rpc_crown_of_ruby_dragon", "item_rpc_crown_of_the_roknar_emperor", "item_rpc_death_whisper_helm", "item_rpc_emerald_douli", "item_rpc_excavators_focus_cap",
        "item_rpc_guard_of_grithault", "item_rpc_guard_of_luma", "item_rpc_helm_of_the_silent_templar", "item_rpc_hood_of_chosen", "item_rpc_hood_of_defiler", "item_rpc_hyper_visor", "item_rpc_helm_of_the_iron_colossus", "item_rpc_mask_of_mugato",
        "item_rpc_mask_of_the_desert_necromancer", "item_rpc_mask_of_the_phantom_sorcerer", "item_rpc_mask_of_tyrius", "item_rpc_scourge_knights_helm", "item_rpc_odin_helmet", "item_rpc_shroud_of_eternal_night", "item_rpc_stormcrack_helm",
        "item_rpc_super_ascendency_mask", "item_rpc_swamp_witch_hat", "item_rpc_tricksters_mask", "item_rpc_veil_of_the_cerulean_high_guard", "item_rpc_white_mage_hat", "item_rpc_wolfir_druids_spirit_helm", "item_rpc_wraith_crown",
        "item_rpc_wraith_hunters_steel_helm"}
    elseif gear_slot == RPC_GEAR_SLOT_BODY then
        itemsList = {"item_rpc_armor_of_secret_temple", "item_rpc_armor_of_violet_guard", "item_rpc_avalanche_plate", "item_rpc_bladestorm_vest", "item_rpc_bluestar_armor", "item_rpc_dark_arts_vestments", "item_rpc_dragon_ceremony_vestments",
        "item_rpc_enchanted_solar_cape", "item_rpc_featherwhite_armor", "item_rpc_gilded_soul_cage", "item_rpc_golden_war_plate", "item_rpc_gold_plate_of_leon", "item_rpc_hermits_spike_shell", "item_rpc_hurricane_vest",
        "item_rpc_ice_quill_carapace", "item_rpc_infused_mageplate", "item_rpc_legion_vestments", "item_rpc_mystic_mana_wall", "item_rpc_nightmare_rider_mantle", "item_rpc_ocean_tempest_pallium", "item_rpc_outland_stone_cuirass",
        "item_rpc_plate_of_the_watcher", "item_rpc_robe_of_flooding", "item_rpc_savage_plate_of_ogthun", "item_rpc_seraphic_soulvest", "item_rpc_skyforge_flurry_plate", "item_rpc_sorcerers_regalia", "item_rpc_space_tech_vest",
        "item_rpc_spellslinger_coat", "item_rpc_staggering_knight_crusher_armor", "item_rpc_stormshield_cloak", "item_rpc_the_infernal_prison", "item_rpc_vampiric_breastplate", "item_rpc_windsteel_armor"}
    elseif gear_slot == RPC_GEAR_SLOT_GLOVES then
        itemsList = {"item_rpc_berserker_gloves", "item_rpc_bladeforge_gauntlet", "item_rpc_boneguard_gauntlets", "item_rpc_claw_of_azinoth", "item_rpc_cytopian_laser_glove", "item_rpc_eternal_essence_gauntlet",
        "item_rpc_far_seers_enchanted_gloves", "item_rpc_frostburn_gauntlets", "item_rpc_gauntlet_of_divine_purity", "item_rpc_glove_of_the_forgotten_ghost", "item_rpc_grand_arcanist_wraps", "item_rpc_grasp_of_elder",
        "item_rpc_greensand_copper_gauntlets", "item_rpc_halcyon_soul_glove", "item_rpc_heavy_echo_gauntlet", "item_rpc_ironbound_gloves", "item_rpc_kappa_pride_gloves", "item_rpc_living_gauntlet",
        "item_rpc_magebane_gloves", "item_rpc_malachite_shade_bracer", "item_rpc_marauder_gloves", "item_rpc_master_gloves", "item_rpc_mordiggus_gauntlet", "item_rpc_mountain_vambraces", "item_rpc_phoenix_gloves",
        "item_rpc_power_ranger_gloves", "item_rpc_royal_wristguards", "item_rpc_scarecrow_gloves", "item_rpc_scorched_gauntlets", "item_rpc_shadow_armlet", "item_rpc_shadowflame_fist", "item_rpc_silverspring_gloves",
        "item_rpc_spirit_glove", "item_rpc_stormcloth_bracer"}
    elseif gear_slot == RPC_GEAR_SLOT_BOOTS then
        itemsList = {"item_rpc_ablecore_greaves", "item_rpc_admiral_boots", "item_rpc_arcanys_slipper", "item_rpc_blue_dragon_greaves", "item_rpc_boots_of_old_wisdom", "item_rpc_boots_of_the_violet_guard",
        "item_rpc_crusader_boots", "item_rpc_dunetread_boots", "item_rpc_falcon_boots", "item_rpc_fire_walkers", "item_rpc_guardian_greaves", "item_rpc_mana_striders", "item_rpc_moon_tech_runners",
        "item_rpc_neptunes_water_gliders", "item_rpc_pathfinders_resonant_boots", "item_rpc_redrock_footwear", "item_rpc_resplendent_rubber_boots", "item_rpc_rooted_feet", "item_rpc_sandstream_slippers",
        "item_rpc_sange_boots", "item_rpc_slinger_boots", "item_rpc_sonic_boots", "item_rpc_steamboots", "item_rpc_swamp_waders", "item_rpc_temporal_warp_boots", "item_rpc_tranquil_boots", "item_rpc_voyager_boots",
        "item_rpc_yasha_boots"}
    elseif gear_slot == RPC_GEAR_SLOT_TRINKET then
        itemsList = {"item_rpc_aeriths_tear", "item_rpc_antique_mana_relic", "item_rpc_arbor_dragonfly", "item_rpc_arcane_charm", "item_rpc_azure_empire", "item_rpc_blacksmiths_tablet", "item_rpc_epsilons_eyeglass",
        "item_rpc_epsilons_eyeglass"}
    end
    return itemsList
end

function RPCItems:RollRandomWorldImmortal(gear_slot, item_level)
    local itemsList = RPCItems:GetWorldDropImmortalNamesList(gear_slot)
    local randomItem = itemsList[RandomInt(1, #itemsList)]
    local item = RPCItems:RollImmortalByName(randomItem, item_level)
    return item
end

function RPCItems:GetSoulBankableItemsList()
    local itemsList = {"item_rpc_monkey_paw", "item_rpc_magebane_gloves", "item_rpc_berserker_gloves", "item_rpc_shadow_armlet", "item_rpc_boneguard_gauntlets", "item_rpc_scorched_gauntlets",
        "item_rpc_hand_of_midas", "item_rpc_kappa_pride_gloves", "item_rpc_claw_of_azinoth", "item_rpc_gauntlet_of_divine_purity", "item_rpc_marauder_gloves", "item_rpc_grasp_of_elder",
        "item_rpc_scarecrow_gloves", "item_rpc_living_gauntlet", "item_rpc_silverspring_gloves", "item_rpc_mordiggus_gauntlet", "item_rpc_ironbound_gloves", "item_rpc_far_seers_enchanted_gloves",
        "item_rpc_master_gloves", "item_rpc_phoenix_gloves", "item_rpc_eternal_essence_gauntlet", "item_rpc_spirit_glove", "item_rpc_frostburn_gauntlets", "item_rpc_mountain_vambraces", "item_rpc_grand_arcanist_wraps",
        "item_rpc_bladeforge_gauntlet", "item_rpc_royal_wristguards", "item_rpc_cytopian_laser_glove", "item_rpc_stormcloth_bracer", "item_rpc_power_ranger_gloves", "item_rpc_hurricane_vest",
        "item_rpc_robe_of_flooding", "item_rpc_avalanche_plate", "item_rpc_armor_of_violet_guard", "item_rpc_twilight_vestments", "item_rpc_radiant_ruins_leather", "item_rpc_bladestorm_vest",
        "item_rpc_hermits_spike_shell", "item_rpc_seraphic_soulvest", "item_rpc_infused_mageplate", "item_rpc_plate_of_the_watcher", "item_rpc_sorcerers_regalia", "item_rpc_spellslinger_coat",
        "item_rpc_doomplate", "item_rpc_ocean_tempest_pallium", "item_rpc_savage_plate_of_ogthun", "item_rpc_ice_quill_carapace", "item_rpc_featherwhite_armor", "item_rpc_dragon_ceremony_vestments",
        "item_rpc_armor_of_secret_temple", "item_rpc_vampiric_breastplate", "item_rpc_skyforge_flurry_plate", "item_rpc_dark_arts_vestments", "item_rpc_legion_vestments", "item_rpc_nightmare_rider_mantle",
        "item_rpc_space_tech_vest", "item_rpc_stormshield_cloak", "item_rpc_the_infernal_prison", "item_rpc_enchanted_solar_cape", "item_rpc_gilded_soul_cage", "item_rpc_bluestar_armor", "item_rpc_windsteel_armor",
        "item_rpc_white_mage_hat", "item_rpc_hyper_visor", "item_rpc_crown_of_ruby_dragon", "item_rpc_centaur_horns", "item_rpc_hood_of_chosen", "item_rpc_death_whisper_helm",
        "item_rpc_guard_of_grithault", "item_rpc_cap_of_wild_nature", "item_rpc_guard_of_luma", "item_rpc_brazen_kabuto_of_the_desert_realm", "item_rpc_odin_helmet",
        "item_rpc_iron_colussus", "item_rpc_mask_of_mugato", "item_rpc_swamp_witch_hat", "item_rpc_tricksters_mask", "item_rpc_demon_mask", "item_rpc_crest_of_the_umbral_sentinel",
        "item_rpc_carbuncles_helm_of_reflection", "item_rpc_wraith_hunters_steel_helm", "item_rpc_emerald_douli", "item_rpc_mask_of_tyrius", "item_rpc_veil_of_the_cerulean_high_guard",
        "item_rpc_blackfeather_crown", "item_rpc_super_ascendency_mask", "item_rpc_mask_of_the_phantom_sorcerer", "item_rpc_arcane_cascade_hat", "item_rpc_adamantine_samurai_helmet",
        "item_rpc_scourge_knights_helm", "item_rpc_mask_of_the_desert_necromancer", "item_rpc_undertakers_hood", "item_rpc_shroud_of_eternal_night", "item_rpc_wolfir_druids_spirit_helm",
        "item_rpc_blinded_glint_of_onu", "item_rpc_crown_of_the_roknar_emperor", "item_rpc_swamp_doctors_tribal_mask", "item_rpc_dunetread_boots", "item_rpc_voyager_boots", "item_rpc_redrock_footwear",
        "item_rpc_pathfinders_resonant_boots", "item_rpc_neptunes_water_gliders", "item_rpc_boots_of_the_violet_guard", "item_rpc_slinger_boots", "item_rpc_guardian_greaves",
        "item_rpc_blue_dragon_greaves", "item_rpc_sange_boots", "item_rpc_boots_of_old_wisdom", "item_rpc_resplendent_rubber_boots", "item_rpc_ghost_slippers", "item_rpc_yasha_boots",
        "item_rpc_tranquil_boots", "item_rpc_fire_walkers", "item_rpc_mana_striders", "item_rpc_moon_tech_runners", "item_rpc_sonic_boots", "item_rpc_falcon_boots", "item_rpc_crusader_boots",
        "item_rpc_arcanys_slipper", "item_rpc_admiral_boots", "item_rpc_rooted_feet", "item_rpc_blacksmiths_tablet", "item_rpc_stone_of_gordon", "item_rpc_sapphire_lotus", "item_rpc_arbor_dragonfly",
        "item_rpc_gem_of_eternal_frost", "item_rpc_lifesource_vessel", "item_rpc_tome_of_chaos", "item_rpc_aeriths_tear", "item_rpc_torch_of_gengar", "item_rpc_ruinfall_skull_token",
        "item_rpc_raven_idol", "item_rpc_omega_ruby", "item_rpc_phoenix_emblem", "item_rpc_hope_of_saytaru", "item_rpc_galaxy_orb", "item_rpc_volcano_orb", "item_rpc_fractional_enhancement_geode",
        "item_rpc_ring_of_nobility", "item_rpc_azure_empire", "item_rpc_signus_charm", "item_rpc_eye_of_avernus", "item_rpc_twig_of_the_enlightened", "item_rpc_boots_of_pure_waters",
        "item_rpc_gloves_of_sweeping_wind", "item_rpc_depth_crest_armor", "item_rpc_terrasic_stone_plate", "item_rpc_crown_of_the_lava_forge", "item_rpc_ancient_tanari_waterstone",
        "item_rpc_tempest_falcon_ring", "item_rpc_firelock_pendant", "item_rpc_water_mage_robes", "item_rpc_halcyon_soul_glove", "item_rpc_golden_war_plate", "item_rpc_hood_of_defiler",
        "item_rpc_excavators_focus_cap", "item_rpc_terrasic_lava_boots", "item_rpc_helm_of_champions", "item_rpc_gauntlet_of_champions", "item_rpc_champions_mail", "item_rpc_boots_of_champions",
        "item_rpc_greensand_copper_gauntlets", "item_rpc_gold_plate_of_leon", "item_rpc_staggering_knight_crusher_armor", "item_rpc_stormcrack_helm",
        "item_rpc_antique_mana_relic", "item_rpc_ablecore_greaves", "item_rpc_glove_of_the_forgotten_ghost", "item_rpc_sapphire_dragon_scale_armor", "item_rpc_topaz_dragon_scale_armor",
        "item_rpc_ruby_dragon_scale_armor", "item_rpc_basilisk_plague_helm", "item_rpc_giant_hunters_boots_of_resilience", "item_rpc_spiritual_empowerment_glove", "item_rpc_hood_of_the_black_mage",
        "item_rpc_sacred_trials_armor", "item_rpc_gravekeepers_gauntlet", "item_rpc_conquest_stone_falcon", "item_rpc_epsilons_eyeglass", "item_rpc_heroic_conqueror_vestments",
        "item_rpc_autumn_sleeper_mask", "item_rpc_eye_of_seasons", "item_rpc_fenrirs_fang", "item_rpc_boots_of_ashara", "item_rpc_autumnrock_bracer",
        "item_rpc_guard_of_feronia", "item_rpc_fuchsia_ring", "item_rpc_helm_of_the_silent_templar", "item_rpc_mystic_mana_wall", "item_rpc_sandstream_slippers", "item_rpc_malachite_shade_bracer",
        "item_rpc_wind_deity_crown", "item_rpc_water_deity_crown", "item_rpc_fire_deity_crown", "item_rpc_skulldigger_gauntlet_lv1", "item_rpc_shipyard_veil_lv1", "item_rpc_crimsyth_elite_greaves_lv1",
        "item_rpc_harvester_boots", "item_rpc_fortunes_talisman_of_truth", "item_rpc_vermillion_dream_robes", "item_rpc_boots_of_great_fortune", "item_rpc_cobalt_serenity_ring",
        "item_rpc_emerald_nullification_ring", "item_rpc_garnet_warfare_ring", "item_rpc_claws_of_the_ethereal_revenant", "item_rpc_crimson_skull_cap", "item_rpc_hood_of_lords",
        "item_rpc_spellfire_gloves", "item_rpc_bloodstone_boots", "item_rpc_igneous_canine_helm", "item_rpc_barons_storm_armor", "item_rpc_serengaard_sun_crystal",
        "item_rpc_temporal_warp_boots", "item_rpc_aqua_lily", "item_rpc_fire_blossom", "item_rpc_wind_orchid", "item_rpc_ankh_of_the_ancients", "item_rpc_alaranas_ice_boot",
        "item_rpc_ancient_tanari_wind_armor", "item_rpc_blue_rain_gauntlet", "item_rpc_shadowflame_fist", "item_rpc_blazing_fury_armor", "item_rpc_aquastone_ring", "item_rpc_burning_spirit_helmet",
        "item_rpc_aquasteel_bracers", "item_rpc_demonfire_gauntlet", "item_rpc_emerald_speed_runners", "item_rpc_outland_stone_cuirass", "item_rpc_world_trees_flower_cache", "item_rpc_red_october_boots",
        "item_rpc_chitinous_lobster_claw", "item_rpc_crystalline_slippers", "item_rpc_dark_emissary_glove", "item_rpc_dark_reef_shark_helmet", "item_rpc_depth_demon_claw", "item_rpc_empyreal_sunrise_robe",
        "item_rpc_hood_of_the_sea_oracle", "item_rpc_ocean_helm_of_valdun", "item_rpc_oceanrunner_boots", "item_rpc_sea_giants_plate", "item_rpc_sparkling_token_of_oceanis", "item_rpc_templar_light_seers_robe",
    "item_rpc_twisted_blue_mask_of_ahnqhir", "item_rpc_twisted_yellow_mask_of_ahnqhir", "item_rpc_twisted_purple_mask_of_ahnqhir", "item_rpc_new_boots", "item_rpc_heavy_echo_gauntlet"}

    return itemsList
end

function RPCItems:RollAndDropUniqueItem(unit, item_name)
    local unit_level = unit:GetRoshpitLevel()
    local item_level = RPCItems:RollItemLevelFromUnit(unit_level)
    local immortal = RPCItems:RollImmortalByName(item_name, item_level)
    RPCItems:BasicDropItem(unit:GetAbsOrigin(), immortal)
    return immortal
end

function RPCItems:RollAndDropImmortalByLevel(position, item_level, item_name)
    local item_level = RPCItems:RollItemLevelFromUnit(item_level)
    local immortal = RPCItems:RollImmortalByName(item_name, item_level)
    RPCItems:BasicDropItem(position, immortal)
    return immortal
end
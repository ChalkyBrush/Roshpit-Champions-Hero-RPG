function RPCItems:RollNeverlordRingProperty()
    local luck = RandomInt(0, 905)
    local luck2 = RandomInt(1, 100)
    local propertyName = ""
    local propertyTitle = ""
    local tier = 0
    if luck2 < 20 then
        value = RandomInt(5, 7)
    elseif luck2 < 50 then
        value = RandomInt(6, 8)
    elseif luck2 < 80 then
        value = RandomInt(7, 9)
    elseif luck2 < 95 then
        value = RandomInt(10, 15)
    elseif luck2 <= 100 then
        value = RandomInt(15, 20)
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
    return tier, value, propertyName
end

function RPCItems:RollNeverlordRing(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_never_ring", "immortal", "Neverlord Soul Ring", "amulet", true, "Slot: Trinket")
    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    value = math.floor(value * 1.5)
    item.newItemTable.property1 = value
    item.newItemTable.property1name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    value = math.floor(value * 1.5)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    value = math.floor(value * 1.5)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    value = math.floor(value * 1.5)
    item.newItemTable.property4 = value
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
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
    RPCItems:SetTableValues(item, itemNameText, item.newItemTable.consumable, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, "", "", RPCItems:GetRarityFactor(item.newItemTable.rarity))

    return item
end

function RPCItems:CreateVariantArcana(variantName, rarityName, itemNameText, slot, gear, slotText, requiredHero, minLevel)
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
    if not minLevel or (minLevel and minLevel == 0) then
        minLevel = RPCItems:GetMinLevel()
    end
    item.newItemTable.minLevel = minLevel
    RPCItems:SetTableValues(item, itemNameText, item.newItemTable.consumable, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, "", "", RPCItems:GetRarityFactor(item.newItemTable.rarity))

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

    local primaryAttribute = hero:GetPrimaryAttribute()
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

function RPCItems:RollBadgeOfHonor(hero)

    local item = RPCItems:CreateVariant("item_rpc_badge_of_honor", "immortal", "Badge of Honor", "amulet", true, "Slot: Trinket")
    local value = RandomInt(10, 15)
    item.newItemTable.property1 = value
    item.newItemTable.property1name = "health_regen"
    RPCItems:SetPropertyValues(item, value, "#item_health_regen", "#6AA364", 1)

    local primaryAttribute = hero:GetPrimaryAttribute()
    item.newItemTable.property2 = RandomInt(20, 40)
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
    local value = RandomInt(5, 10)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_armor", "#D1D1D1", 3)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end
    item.newItemTable.isShop = true
    RPCItems:GiveItemToHero(hero, item)
end

function RPCItems:RollMageBaneGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_magebane_gloves", "immortal", "Magebane Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    value = math.floor(value * 2)
    item.newItemTable.property1 = value
    item.newItemTable.property1name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    value = math.floor(value * 2)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
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

function RPCItems:RollBerserkerGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_berserker_gloves", "immortal", "Berserker Gloves", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "berserker_rage"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_berserker", "#850D0D", 1, "#property_berserker_rage_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value = RandomInt(maxFactor * 100, maxFactor * 250)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)
    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollShadowArmlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_shadow_armlet", "immortal", "Shadow Armlet", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "shadow_armlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_shadow_armlet", "#54457A", 1, "#property_shadow_armlet_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value = RandomInt(maxFactor * 10, maxFactor * 20)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMalachiteShadeBracer(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_malachite_shade_bracer", "immortal", "Malachite Shade Bracer", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "malachite_shade"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_malachite_shade", "#95DB9D", 1, "#property_malachite_shade_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value, nameLevel = RPCItems:RollAttribute(0, 11, 20, 0, 0, item.newItemTable.rarity, false, maxFactor * 20)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHeavyEchoGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_heavy_echo_gauntlet", "immortal", "Heavy Echo Gauntlet", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "heavy_echo"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_heavy_echo", "#CE3350", 1, "#property_heavy_echo_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value, nameLevel = RPCItems:RollAttribute(0, 4, 20, 0, 0, item.newItemTable.rarity, false, maxFactor * 24)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    local luck = RandomInt(1, 4)
    if luck == 4 then
        local value, nameLevel = RPCItems:RollAttribute(0, 2, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
        item.newItemTable.property3 = value
        item.newItemTable.property3name = "armor"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_armor", "#D1D1D1", 3)
    else
        RPCItems:RollHandProperty3(item, 0)
    end
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBoneguardGauntlets(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_boneguard_gauntlets", "immortal", "Boneguard Gauntlets", "hands", true, "Slot: Hands")

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "boneguard"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_boneguard", "#8EA38B", 1, "#property_boneguard_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value = RandomInt(maxFactor * 4, maxFactor * 7) * GameState:GetDifficultyFactor()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)
    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollScorchedGauntlets(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_scorched_gauntlets", "immortal", "Gloves of the High Flame", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "scorched_gauntlet"
    --RPCItems:SetPropertyValuesSpecial(item, item.newItemTable.property1, "#item_property_scorched_gauntlet", "#E8A917",  1, "#property_scorched_gauntlet_description")
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_scorched_gauntlet_2", "#E8A917", 1, "#property_scorched_gauntlet_description_2")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_FIRE, 2, 1, 32, 2)
    else
        local value, nameLevel = RPCItems:RollAttribute(0, 2, 5, 0, 0, item.newItemTable.rarity, false, maxFactor * 5)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "armor"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)
    end

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)

    --pre patch lv values
    if type(item.newItemTable.property2) == "number" then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 2)
    end
    if type(item.newItemTable.property3) == "number" then
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
    end
    if type(item.newItemTable.property4) == "number" then
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHandOfMidas(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_hand_of_midas", "immortal", "Hand of Midas", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "midas"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hand_of_midas", "#EFF700", 1, "#property_hand_of_midas_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollProudGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_kappa_pride_gloves", "immortal", "Proud Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "pride"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pride", "#D950D6", 1, "#property_pride_description")
    RPCItems:RollHandProperty2(item, 0)
    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollClawOfAzinoth(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_claw_of_azinoth", "immortal", "Claw of Azinoth", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "azinoth"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azinoth", "#543553", 1, "#property_azinoth_description")
    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 4
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBuzukisFinger(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_buzukis_finger", "immortal", "Buzuki's Finger", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "buzuki"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_buzuki_finger", "#6FD8ED", 1, "#property_buzuki_finger_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSwiftspikeBracer(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_swiftspike_bracer", "immortal", "Swiftspike Bracer", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "swiftspike"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_swiftspike_bracer", "#3F74A8", 1, "#property_swiftspike_bracer_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.75)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local maxFactor = RPCItems:GetMaxFactor()
    local value = RPCItems:GetLogarithmicVarianceValue(math.ceil(maxFactor / 2.5), 0, 0, 0, 0)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "movespeed"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_movespeed", "#B02020", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDiamondClawsOfTiamat(deathLocation, boss_level)
    local item = RPCItems:CreateVariant("item_rpc_diamond_claws_of_tiamat", "immortal", "Diamond Claws of Tiamat", "hands", true, "Slot: Hands")
    local tiamat_roll, suffix = RPCItems:RollAttribute(300, 8 + boss_level, 16 + boss_level*4, 0, 0, item.newItemTable.rarity, false, boss_level*400)
    tiamat_roll = math.min(tiamat_roll, 18000)
    item.newItemTable.property1 = tiamat_roll
    item.newItemTable.property1name = "tiamat"
    RPCItems:SetPropertyValuesSpecial(item, tiamat_roll, "#item_property_tiamat_claw", "#FAFAFF", 1, "#property_tiamat_claw_description")

    local value = RandomInt(boss_level * 300, boss_level * 1500)
    value = math.min(value, 140000)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    local value, nameLevel = RPCItems:RollAttribute(100, 2, math.floor(boss_level/2) + 4, 0, 0, item.newItemTable.rarity, false, boss_level*30)
    value = math.min(value, 1000)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "base_ability"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_base_ability", "#7AB4CC", 3)

    local value, nameLevel = RPCItems:RollAttribute(100, 1, boss_level+3, 0, 1, item.newItemTable.rarity, false, boss_level * 20)
    value = math.min(value, 900)
    item.newItemTable.property4 = value
    item.newItemTable.property4name = "all_elements"
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "#property_all_elements", "#BED5E5", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDivinePurityGauntlets(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_gauntlet_of_divine_purity", "immortal", "Gauntlets of Divine Purity", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "divine_purity"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_divine_purity", "#A8D3ED", 1, "#property_divine_purity_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_HOLY, 2.8, 2, 30, 2)
    else
        local armorRoll = RandomInt(maxFactor * 4, maxFactor * 8) + 5
        item.newItemTable.property2 = armorRoll
        item.newItemTable.property2name = "armor"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)
    end

    local magicResistRoll = RandomInt(20, 30)
    item.newItemTable.property3 = magicResistRoll
    item.newItemTable.property3name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_magic_resist", "#AC47DE", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMarauderGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_marauder_gloves", "immortal", "Marauder Gloves", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "marauder"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_marauder", "#326E94", 1, "#property_marauder_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local healthRoll = RandomInt(maxFactor * 50, maxFactor * 120)
    item.newItemTable.property2 = healthRoll
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSkulldiggerGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_skulldigger_gauntlet", "immortal", "Skulldigger Gauntlet", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "skulldigger_v2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_skulldigger", "#90E8E7", 1, "#property_skulldigger_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local maxFactor = RPCItems:GetMaxFactor()
        local healthRoll, pref = RPCItems:RollAttribute(300, 300, 800, 1, 1, item.newItemTable.rarity, false, maxFactor * 600)
        item.newItemTable.property2 = healthRoll
        item.newItemTable.property2name = "max_health"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)
    elseif luck == 2 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_UNDEAD, 4, 3, 40, 2)
    elseif luck == 3 then
        item.newItemTable.hasRunePoints = true
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property2 = math.ceil(value * 2.0)
        local luck = RandomInt(1, 2)
        if luck == 1 then
            propertyName = "rune_q_1"
        elseif luck == 2 then
            propertyName = "rune_q_2"
        end
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)

    --pre patch lv values
    if type(item.newItemTable.property2) == "number" then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
    end
    if type(item.newItemTable.property3) == "number" then
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
    end
    if type(item.newItemTable.property4) == "number" then
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollElderGrasp(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_grasp_of_elder", "immortal", "Grasp of the Elders", "hands", true, "Slot: Hands")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "elder_grasp"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_elder_grasp", "#5A54C4", 1, "#property_elder_grasp_description")
    item.newItemTable.hasRunePoints = true

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollScarecrowGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_scarecrow_gloves", "immortal", "Scarecrow Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "scarecrow"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_scarecrow", "#2CA8F5", 1, "#property_scarecrow_description")

    value, nameLevel = RPCItems:RollAttribute(0, 8, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollChitinousLobsterClaw(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_chitinous_lobster_claw", "immortal", "Chitinous Lobster Claw", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "lobster"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_lobster_claw", "#C97360", 1, "#property_lobster_claw_Description")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 9, 0, 0, item.newItemTable.rarity, false, maxFactor * 9)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDarkEmissaryGlove(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_dark_emissary_glove", "immortal", "Dark Emissary Glove", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "dark_emissary"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_dark_emissary", "#3E7BBC", 1, "#property_dark_emissary_Description")

    Elements:RollElementAttribute(item, RPC_ELEMENT_GHOST, 2.8, 2, 30, 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDepthDemonClaw(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_depth_demon_claw", "immortal", "Depth Demon Claw", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "depth_demon"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_depth_demon_claw", "#634F87", 1, "#property_depth_demon_claw_Description")

    Elements:RollElementAttribute(item, RPC_ELEMENT_DEMON, 2.4, 2, 27, 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGlovesOfSweepingWind(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_gloves_of_sweeping_wind", "immortal", "Sweeping Wind Glove", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sweeping_wind"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sweeping_wind", "#A9D4C5", 1, "#property_sweeping_wind_description")

    Elements:RollElementAttribute(item, RPC_ELEMENT_WIND, 2.8, 2, 30, 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollLivingGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_living_gauntlet", "immortal", "Living Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "living_gauntlet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_living_gauntlet", "#ADFF5C", 1, "#property_living_gauntlet_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 4, 8, 0, 0, item.newItemTable.rarity, false, maxFactor * 8)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    value, prefixLevel = RPCItems:RollAttribute(100, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 8)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "health_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_health_regen", "#6AA364", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSilverspringGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_silverspring_gloves", "immortal", "Silverspring Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "silverspring"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_silverspring_glove", "#AFCCB8", 1, "#property_silverspring_description")

    local value, prefixLevel = RPCItems:RollAttribute(100, 5, 11, 0, 0, item.newItemTable.rarity, false, maxFactor * 6)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "health_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_health_regen", "#6AA364", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMordiggusGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_mordiggus_gauntlet", "immortal", "Mordiggus Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "mordiggus"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mordiggus", "#B84874", 1, "#property_mordiggus_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 300, 800, 1, 1, item.newItemTable.rarity, false, maxFactor * 340) * GameState:GetDifficultyFactor()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)
    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_DEMON, 2.5, 1, 25, 3)
    else
        RPCItems:RollHandProperty3(item, 0)
    end
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollIronboundGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ironbound_gloves", "immortal", "Ironbound Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ironbound"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ironbound_gloves", "#CFD2D4", 1, "#property_ironbound_gloves_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value = RandomInt(maxFactor * 2, maxFactor * 4) * GameState:GetDifficultyFactor()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFarSeersEnchantedGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_far_seers_enchanted_gloves", "immortal", "Far Seer's Enchanted Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "far_seer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_farseer_glove", "#CAD683", 1, "#property_farseer_description")

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    item.newItemTable.hasRunePoints = true

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollShadowflameFist(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_shadowflame_fist", "immortal", "Shadowflame Fist", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "shadowflame"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_shadowflame_fist", "#5A25BC", 1, "#property_shadowflame_fist_description")
    local luck = RandomInt(1, 2)
    if luck == 1 then
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property2 = value
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
        item.newItemTable.hasRunePoints = true
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_SHADOW, 2.4, 2, 24, 2)
    end

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMasterGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_master_gloves", "immortal", "Master Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "master"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_master_gloves", "#EDCA3B", 1, "#property_master_gloves_description")

    item.newItemTable.hasRunePoints = true
    local value = 0
    local nameLevel = 0
    if maxFactor < 40 then
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 3 + 4)
        item.newItemTable.property2 = WallPhysics:round(value, 0)
        item.newItemTable.property2name = "rune_r_1"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 3 + 4)
        item.newItemTable.property3 = WallPhysics:round(value, 0)
        item.newItemTable.property3name = "rune_r_2"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 3 + 4)
        item.newItemTable.property2 = WallPhysics:round(value, 0)
        item.newItemTable.property2name = "rune_r_2"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 3 + 4)
        item.newItemTable.property3 = WallPhysics:round(value, 0)
        item.newItemTable.property3name = "rune_r_3"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollPhoenixGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_phoenix_gloves", "immortal", "Phoenix Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "phoenix"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_phoenix_gloves", "#EDA65F", 1, "#property_phoenix_gloves_description")

    local value, suffixLevel = RPCItems:RollAttribute(100, 2, 7, 0, 1, item.newItemTable.rarity, false, math.min(maxFactor * 3, RandomInt(150, 250)))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_speed"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_attack_speed", "#B02020", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollEternalEssenceGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_eternal_essence_gauntlet", "immortal", "Eternal Essence Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "eternal_essence"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_eternal_essence", "#51C9AF", 1, "#property_eternal_essence_description")

    local value = 0
    local luck = RandomInt(1, 6)
    if luck > 5 then
        value = RandomInt(10, 15)
    elseif luck > 4 then
        value = RandomInt(8, 12)
    else
        value = RandomInt(5, 10)
    end
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "lifesteal"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_lifesteal", "#B1E3B9", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSpiritGlove(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_spirit_glove", "immortal", "Spirit Glove", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "spirit"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spirit_glove", "#FFFFFF", 1, "#property_spirit_glove_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(0, 7, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_HOLY, 2.8, 2, 24, 2)
    end

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFrostburnGauntlets(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_frostburn_gauntlets", "immortal", "Frostburn Gauntlets", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "frostburn"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_frostburn_gauntlets", "#7DDAE8", 1, "#property_frostburn_gauntlets_description")

    local value, suffixLevel = RPCItems:RollAttribute(100, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "mana_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_mana_regen", "#649FA3", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHalcyonSoulGlove(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_halcyon_soul_glove", "immortal", "Halcyon Soul Glove", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "halcyon_soul"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_halcyon_soul", "#E8F274", 1, "#property_halcyon_soul_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 5, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.5)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGreensandCopperGauntlets(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_greensand_copper_gauntlets", "immortal", "Greensand Copper Gauntlets", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property1 = math.floor(value * 2.2)
    item.newItemTable.property1name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)

    local value, nameLevel = RPCItems:RollAttribute(100, 2, 12, 0, 0, item.newItemTable.rarity, false, math.ceil(maxFactor / 2))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "base_ability"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_base_ability", "#7AB4CC", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGloveOfTheForgottenGhost(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_glove_of_the_forgotten_ghost", "immortal", "Glove of the Forgotten Ghost", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "forgotten_ghost"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_forgotten_ghost", "#A5E8E7", 1, "#property_forgotten_ghost_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 2, 12, 0, 0, item.newItemTable.rarity, false, math.ceil(maxFactor / 2.4))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "base_ability"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_base_ability", "#7AB4CC", 2)

    Elements:RollElementAttribute(item, RPC_ELEMENT_GHOST, 2.5, 1, 30, 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGravekeepersGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_gravekeepers_gauntlet", "immortal", "Gravekeeper's Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "gravekeeper"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gravekeeper_gauntlet", "#94EBFF", 1, "#property_gravekeeper_gauntlet_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 3, 12, 0, 0, item.newItemTable.rarity, false, math.ceil(maxFactor / 2.2))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "base_ability"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_base_ability", "#7AB4CC", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.5)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = math.ceil(value * 1.5)
    local luck = RandomInt(1, 3)
    if luck == 1 then
        propertyName = "rune_w_1"
    elseif luck == 2 then
        propertyName = "rune_w_2"
    elseif luck == 3 then
        propertyName = "rune_w_3"
    end
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBlueRainGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_blue_rain_gauntlet", "immortal", "Blue Rain Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "blue_rain"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blue_rain", "#B6DEE3", 1, "#property_blue_rain_description")

    Elements:RollElementAttribute(item, RPC_ELEMENT_WATER, 2.0, 2, 15, 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.3)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSpiritualEmpowermentGlove(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_spiritual_empowerment_glove", "immortal", "Spiritual Empowerment Glove", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "spiritual_empowerment"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spiritual_empowerment", "#B6DEE3", 1, "#property_spiritual_empowerment_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 2, 11, 0, 0, item.newItemTable.rarity, false, math.ceil(maxFactor / 2.1))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "base_ability"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_base_ability", "#7AB4CC", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.8)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMountainVambraces(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_mountain_vambraces", "immortal", "Mountain Vambraces", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "mountain_vambrace"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_vambraces", "#694B4B", 1, "#property_mountain_vambraces_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollAutumnrockBracers(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_autumnrock_bracer", "immortal", "Autumnrock Bracer", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "autumnrock_bracer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_autumnrock_bracer", "#C2485E", 1, "#property_autumnrock_bracer_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 17)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGrandArcanist(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_grand_arcanist_wraps", "immortal", "Wraps of the Grand Arcanist", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "grand_arcanist"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_grand_arcanist", "#A05BCF", 1, "#property_grand_arcanist_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBladeforgeGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_bladeforge_gauntlet", "immortal", "Bladeforge Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "bladeforge"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bladeforge", "#AB0303", 1, "#property_bladeforge_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value = RandomInt(maxFactor * 8, maxFactor * 150) * 3
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRoyalWristguards(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_royal_wristguards", "immortal", "Royal Wristguards", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "royal_wrist"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_royal_wrist", "#D94848", 1, "#property_royal_wrist_description")

    local maxFactor = RPCItems:GetMaxFactor()
    local value = RandomInt(maxFactor * 15, maxFactor * 34) * GameState:GetDifficultyFactor()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = value * 2
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollAquasteelBracers(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_aquasteel_bracers", "immortal", "Aquasteel Bracers", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "aquasteel"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_aquasteel", "#56BBEA", 1, "#property_aquasteel_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 3, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 8)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.5)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDemonfireGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_demonfire_gauntlet", "immortal", "Demonfire Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "demonfire"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_demonfire", "#8C1C1C", 1, "#property_demonfire_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.5)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollCytopianLaserGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_cytopian_laser_glove", "immortal", "Cytopian Laser Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    local value, nameLevel = RPCItems:RollAttribute(0, 260, 620, 0, 0, item.newItemTable.rarity, false, maxFactor * 600)
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "cytopian_laser"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_cytopian_laser", "#85CEED", 1, "#property_cytopian_laser_description")

    local value, suffixLevel = RPCItems:RollAttribute(100, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 9)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "mana_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_mana_regen", "#649FA3", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGoldbreakerGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_goldbreaker_gauntlet", "immortal", "Goldshatter Gauntlet", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    local value, nameLevel = RPCItems:RollAttribute(0, 260, 620, 0, 0, item.newItemTable.rarity, false, maxFactor * 600)
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "gold_breaker"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gold_breaker", "#fff42b", 1, "#property_gold_breaker_description")

    local luck = RandomInt(1, 3)
    if luck < 3 then
        value, nameLevel = RPCItems:RollAttribute(0, 10, 30, 0, 0, item.newItemTable.rarity, false, maxFactor * 22)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    else
        item.newItemTable.hasRunePoints = true
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property2 = math.floor(value * 1.5)
        local luck = RandomInt(1, 10)
        if luck <= 4 then
            propertyName = "rune_r_1"
        elseif luck <= 7 then
            propertyName = "rune_r_2"
        elseif luck <= 9 then
            item.newItemTable.property2 = math.ceil(item.newItemTable.property2 / 2)
            propertyName = "rune_r_3"
        else
            if GameState:GetDifficultyFactor() > 2 then
                item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(10, 0, 0, 0, 0)
                propertyName = "rune_r_4"
            else
                propertyName = "rune_r_1"
            end
        end
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollClawOfTheEtherealRevenant(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_claws_of_the_ethereal_revenant", "immortal", "Claws of the Ethereal Revenant", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ethereal_revenant"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ethereal_revenant", "#90DFF5", 1, "#property_ethereal_revenant_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    local luck = RandomInt(1, 4 + (GameState:GetDifficultyFactor() * 3))
    if luck <= 3 then
        value = math.floor(value * 1.3)
        propertyName = "rune_w_1"
    elseif luck <= 6 then
        value = math.floor(value * 1.3)
        propertyName = "rune_w_2"
    elseif luck <= 9 then
        value = math.floor(value * 1)
        propertyName = "rune_w_3"
    elseif luck == 10 then
        value = math.floor(value * 0.7)
        propertyName = "rune_w_4"
    end
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollEnergyWhipGlove(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_energy_whip_glove", "immortal", "Energy Whip Glove", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "energy_whip"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_energy_whip", "#4986b2", 1, "#property_energy_whip_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    local luck = RandomInt(1, 4 + (GameState:GetDifficultyFactor() * 2))
    if luck <= 3 then
        value = math.floor(value * 1.2)
        propertyName = "rune_w_1"
    elseif luck <= 6 then
        value = math.floor(value * 1.2)
        propertyName = "rune_w_2"
    elseif luck <= 9 then
        value = math.floor(value * 0.8)
        propertyName = "rune_w_3"
    elseif luck == 10 then
        value = math.min(math.floor(value * 0.3), 10)
        propertyName = "rune_w_4"
    end
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    local luck = RandomInt(1, 4 + (GameState:GetDifficultyFactor() * 2))
    if luck <= 3 then
        value = math.floor(value * 1.3)
        propertyName = "rune_w_1"
    elseif luck <= 6 then
        value = math.floor(value * 1.3)
        propertyName = "rune_w_2"
    elseif luck <= 9 then
        value = math.floor(value * 0.9)
        propertyName = "rune_w_3"
    elseif luck == 10 then
        value = math.min(math.floor(value * 0.5), 15)
        propertyName = "rune_w_4"
    end
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollStormclothBracer(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_stormcloth_bracer", "immortal", "Stormcloth Bracers", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    local value, nameLevel = RPCItems:RollAttribute(0, 160, 420, 0, 0, item.newItemTable.rarity, false, maxFactor * 400)
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "stormcloth"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_stormcloth", "#85CEED", 1, "#property_stormcloth_description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(0, 4, 16, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_LIGHTNING, 2.6, 2, 26, 2)
    end

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollPowerRangerGloves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_power_ranger_gloves", "immortal", "Power Ranger Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    local value, nameLevel = RPCItems:RollAttribute(0, 50, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 120)
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "power_ranger"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_power_ranger", "#FF4545", 1, "#property_power_ranger_description")

    value, nameLevel = RPCItems:RollAttribute(0, 7, 27, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    value, nameLevel = RPCItems:RollAttribute(0, 7, 27, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_agility", "#2EB82E", 3)

    value, nameLevel = RPCItems:RollAttribute(0, 7, 27, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
    item.newItemTable.property4 = value
    item.newItemTable.property4name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "#item_intelligence", "#33CCFF", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

--BODY

function RPCItems:RollHurricaneVest(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_hurricane_vest", "immortal", "Hurricane Vest", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "hurricane"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hurricane", "#5A54C4", 1, "#property_hurricane_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 18, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)

    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    Elements:RollElementAttribute(item, RPC_ELEMENT_WIND, 4, 1, 30, 3)

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBaronsStormArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_barons_storm_armor", "immortal", "Barons Storm Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "baron_storm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_baron_storm", "#96DCFF", 1, "#property_baron_storm_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_LIGHTNING, 3, 2, 30, 2)
    else
        RPCItems:RollBodyProperty2(item, 0)
    end
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFloodRobe(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_robe_of_flooding", "immortal", "Robe of Flooding", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "flooding"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_flooding_3", "#57CFFF", 1, "#property_flooding_description_3")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = math.ceil(value * 1.5)
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    --pre patch lv values
    if type(item.newItemTable.property2) == "number" then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
    end
    if type(item.newItemTable.property3) == "number" then
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
    end
    if type(item.newItemTable.property4) == "number" then
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation

    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollAvalanchePlate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_avalanche_plate", "immortal", "Avalanche Plate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "avalanche"
    --RPCItems:SetPropertyValuesSpecial(item, 0, "#item_property_avalanche", "#9C8C81",  1, "#property_avalanche_description")
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_avalanche_2", "#9C8C81", 1, "#property_avalanche_description_2")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 18, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    --pre patch lv values
    if type(item.newItemTable.property2) == "number" then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
    end
    if type(item.newItemTable.property3) == "number" then
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
    end
    if type(item.newItemTable.property4) == "number" then
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSeaGiantsPlate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_sea_giants_plate", "immortal", "Sea Giant's Plate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "sea_giant"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_sea_giant_plate", "#C7E8E2", 1, "#property_sea_giant_plate_Description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 28, 0, 0, item.newItemTable.rarity, false, maxFactor * 28)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollAlienArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_alien_armor", "immortal", "Sea Giant's Plate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "alien"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_alien_armor", "#47471b", 1, "#property_alien_armor_Description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.5)
    local luck = RandomInt(1, 10)
    if luck <= 4 then
        propertyName = "rune_r_1"
    elseif luck <= 7 then
        propertyName = "rune_r_2"
    elseif luck <= 9 then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 / 2)
        propertyName = "rune_r_3"
    else
        if GameState:GetDifficultyFactor() > 2 then
            item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(12, 0, 0, 0, 0)
            propertyName = "rune_r_4"
        else
            propertyName = "rune_r_1"
        end
    end
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollKnightCrusherArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_staggering_knight_crusher_armor", "immortal", "Staggering Knight Crusher Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "knight_crusher"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_knight_crusher", "#DBB948", 1, "#property_knight_crusher_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTerrasicStonePlate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_terrasic_stone_plate", "immortal", "Terrasic Stone Plate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "terrasic_stone"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_terrasic_stone", "#BF8154", 1, "#property_terrasic_stone_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_EARTH, 2.7, 2, 32, 2)
    else
        local value, nameLevel = RPCItems:RollAttribute(0, 8, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    end
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollCaptainsVest(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_captains_vest", "immortal", "Captains Vest", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "captains_vest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_captains_vest", "#4FCCB1", 1, "#property_captains_vest_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(math.ceil(maxFactor / 10), 0, 0, 0, 0)
        item.newItemTable.property2name = "t1_runes"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_t1_runes", "#7DFF12", 2)
    elseif luck == 2 then
        item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(math.ceil(maxFactor / 20), 0, 0, 0, 0)
        item.newItemTable.property2name = "t2_runes"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_t2_runes", "#7DFF12", 2)
    elseif luck == 3 then
        item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(math.ceil(maxFactor / 40), 0, 0, 0, 0)
        item.newItemTable.property2name = "t3_runes"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_t3_runes", "#7DFF12", 2)
    end
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBorealGraniteVest(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_boreal_granite_vest", "immortal", "Boreal Granite Vest", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "boreal_granite"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_boreal_granite", "#9EE0FF", 1, "#property_boreal_granite_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    local luck = RandomInt(1, 4 + (GameState:GetDifficultyFactor() * 2))
    if luck <= 3 then
        value = math.floor(value * 1.2)
        propertyName = "rune_q_1"
    elseif luck <= 6 then
        value = math.floor(value * 1.2)
        propertyName = "rune_q_2"
    elseif luck <= 9 then
        value = math.floor(value * 0.8)
        propertyName = "rune_q_3"
    elseif luck == 10 then
        value = math.min(math.floor(value * 0.3), 10)
        propertyName = "rune_q_4"
    end
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    local luck = RandomInt(1, 4 + (GameState:GetDifficultyFactor() * 2))
    if luck <= 3 then
        value = math.floor(value * 1.3)
        propertyName = "rune_q_1"
    elseif luck <= 6 then
        value = math.floor(value * 1.3)
        propertyName = "rune_q_2"
    elseif luck <= 9 then
        value = math.floor(value * 0.9)
        propertyName = "rune_q_3"
    elseif luck == 10 then
        value = math.min(math.floor(value * 0.5), 15)
        propertyName = "rune_q_4"
    end
    item.newItemTable.property3 = value
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollVioletGuardArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_armor_of_violet_guard", "immortal", "Armor of Violet Guard", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "violet_guard2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_violet_guard_armor2", "#A337E6", 1, "#property_violet_guard_armor_description2")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 2.4)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local evasionValue = RandomInt(12, 20)
    item.newItemTable.property3 = evasionValue
    item.newItemTable.property3name = "evasion"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_evasion", "#759C7C", 3)

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTwilightVestments(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_twilight_vestments", "immortal", "Twilight Vestments", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "twilight"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_twilight_vestments", "#BCD8E6", 1, "#property_twilight_vestments_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.5)
    local luck = RandomInt(1, 10)
    if luck <= 4 then
        propertyName = "rune_r_1"
    elseif luck <= 7 then
        propertyName = "rune_r_2"
    elseif luck <= 9 then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 / 2)
        propertyName = "rune_r_3"
    else
        if GameState:GetDifficultyFactor() > 2 then
            item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(12, 0, 0, 0, 0)
            propertyName = "rune_r_4"
        else
            propertyName = "rune_r_1"
        end
    end
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRadiantRuinsLeather(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_radiant_ruins_leather", "immortal", "Radiant Ruins Leather", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "radiant_ruins"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_radiant_ruins", "#EDB940", 1, "#property_radiant_ruins_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.5)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBladestormVest(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_bladestorm_vest", "immortal", "Bladestorm Vest", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "bladestorm"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bladestorm_vest", "#DE2644", 1, "#property_bladestorm_vest_description")

    local value = RandomInt(maxFactor * 12, maxFactor * 360)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:NethergraspPalisade(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_nethergrasp_palisade", "immortal", "nethergrasp Palisade", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "nethergrasp"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_nethergrasp", "#78f0ec", 1, "#property_nethergrasp_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local value = RandomInt(maxFactor * 30, maxFactor * 330)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "attack_damage"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)
    elseif luck == 2 then
        local value, nameLevel = RPCItems:RollAttribute(0, 9, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value*1.5)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSacredTrialsArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_sacred_trials_armor", "immortal", "Sacred Trials Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sacred_trials"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sacred_trials", "#EDC02D", 1, "#property_sacred_trials_description")

    local value = RandomInt(maxFactor * 12, maxFactor * 360)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHermitSpikeShell(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_hermits_spike_shell", "immortal", "Hermit's Spike Shell", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "spike_shell"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hermit_spike_shell", "#CDD17B", 1, "#property_hermit_spike_shell_description")

    local value = RandomInt(maxFactor * 12, maxFactor * 360)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSoulVest(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_seraphic_soulvest", "immortal", "Seraphic Soulvest", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "seraphic"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_seraphic_soulvest", "#C5E7FC", 1, "#property_seraphic_soulvest_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local value, nameLevel = RPCItems:RollAttribute(0, 4, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_all_attributes", "#FFFFFF", 3)
    -- local luck = RandomInt(1, 3)
    -- if luck == 1 then
    --     value, nameLevel = RPCItems:RollAttribute(50, 1, 35, 0, 0, item.newItemTable.rarity, false, maxFactor*18)
    --     item.newItemTable.property3 = value
    --     item.newItemTable.property3name = "strength"
    --     RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_strength", "#CC0000",  3)
    -- elseif luck == 2 then
    --     value, nameLevel = RPCItems:RollAttribute(50, 1, 35, 0, 0, item.newItemTable.rarity, false, maxFactor*18)
    --     item.newItemTable.property3 = value
    --     item.newItemTable.property3name = "agility"
    --     RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_agility", "#2EB82E",  3)
    -- else
    --     value, nameLevel = RPCItems:RollAttribute(50, 1, 35, 0, 0, item.newItemTable.rarity, false, maxFactor*18)
    --     item.newItemTable.property3 = value
    --     item.newItemTable.property3name = "intelligence"
    --     RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_intelligence", "#33CCFF",  3)
    -- end

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTanariWindArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ancient_tanari_wind_armor", "immortal", "Ancient Tanari Wind Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ancient_tanari"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tanari_wind_armor", "#C5E7FC", 1, "#property_tanari_wind_armor_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 4, 16, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local luck = RandomInt(1, 3)
    if luck == 1 then
        item.newItemTable.hasRunePoints = true
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property3 = math.ceil(value * 1.3)
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    elseif luck == 2 then
        item.newItemTable.hasRunePoints = true
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property3 = math.ceil(value * 1.0)
        item.newItemTable.property3name = "rune_q_3"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_WIND, 2.5, 1, 50, 3)
    end

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollEmpyrealSunriseRobe(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_empyreal_sunrise_robe", "immortal", "Empyreal Sunrise Robe", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sunrise"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_tropical_sunrise", "#F7E37E", 1, "#property_tropical_sunrise_Description")

    local value, nameLevel = RPCItems:RollAttribute(0, 4, 16, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMageplate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_infused_mageplate", "immortal", "Infused Mageplate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "mageplate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mageplate", "#B05CFF", 1, "#property_mageplate_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 9, 16, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    value, nameLevel = RPCItems:RollAttribute(0, 1, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 7)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_armor", "#D1D1D1", 3)

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGoldenWarPlate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_golden_war_plate", "immortal", "Golden War Plate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "golden_war_plate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gold_war_plate", "#E8E83C", 1, "#property_gold_war_plate_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 1, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 8)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollWaterMageRobes(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_water_mage_robes", "immortal", "Water Mage Robes", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "watermage"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watermage", "#49B7E3", 1, "#property_watermage_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 9, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    Elements:RollElementAttribute(item, RPC_ELEMENT_WATER, 4, 1, 50, 3)

    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollWatcherPlate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_plate_of_the_watcher", "immortal", "Plate of the Watcher", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    local luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "watcher1"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watcher_one", "#64A4CC", 1, "#property_watcher_one_description")
    else
        RPCItems:RollBodyProperty1(item, 0)
    end

    luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "watcher2"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watcher_two", "#64A4CC", 2, "#property_watcher_two_description")
    else
        RPCItems:RollBodyProperty2(item, 0)
    end

    luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property3 = 1
        item.newItemTable.property3name = "watcher3"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watcher_three", "#64A4CC", 3, "#property_watcher_three_description")
    else
        RPCItems:RollBodyProperty3(item, 0)
    end

    luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property4 = 1
        item.newItemTable.property4name = "watcher4"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_watcher_four", "#64A4CC", 4, "#property_watcher_four_description")
    else
        RPCItems:RollBodyProperty4(item, 0)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSorcererRegalia(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_sorcerers_regalia", "immortal", "Sorcerer's Regalia", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sorcerer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sorcerers_regalia", "#1996E3", 1, "#property_sorcerers_regalia_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 3
    local luck = RandomInt(1, 3)
    if luck == 1 then
        propertyName = "rune_w_1"
    elseif luck == 2 then
        propertyName = "rune_w_2"
    elseif luck == 3 then
        propertyName = "rune_w_3"
    end
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    value, nameLevel = RPCItems:RollAttribute(0, 10, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_intelligence", "#33CCFF", 3)

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSpellslingerCoat(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_spellslinger_coat", "immortal", "Spellslinger's Coat", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "spellslinger"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spellslinger_coat", "#3FEBC5", 1, "#property_spellslinger_coat_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.4)
    local luck = RandomInt(1, 5)
    if luck <= 2 then
        propertyName = "rune_w_1"
    elseif luck <= 4 then
        propertyName = "rune_w_2"
    elseif luck == 5 then
        propertyName = "rune_w_3"
    end
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDoomplate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_doomplate", "immortal", "Doomplate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "doomplate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_doomplate", "#E85920", 1, "#property_doomplate_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    local luck = RandomInt(1, 3)
    if luck == 1 then
        propertyName = "rune_r_1"
    elseif luck == 2 then
        propertyName = "rune_r_2"
    elseif luck == 3 then
        propertyName = "rune_r_3"
    end
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollOceanTempestPallium(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ocean_tempest_pallium", "immortal", "Ocean Tempest Pallium", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ocean_tempest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ocean_tempest", "#4C74A8", 1, "#property_ocean_tempest_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 120, 500, 0, 1, item.newItemTable.rarity, false, maxFactor * 300)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_mana"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_mana", "#343EC9", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSavagePlateOfOgthun(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_savage_plate_of_ogthun", "immortal", "Savage Plate of Og'Thun", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ogthun"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ogthun", "#B32224", 1, "#property_ogthun_description")

    local value = RandomInt(maxFactor * 22, maxFactor * 360)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollIceQuillCarapace(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ice_quill_carapace", "immortal", "Ice Quill Carapace", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ice_quill"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ice_quill", "#6FD2F2", 1, "#property_ice_quill_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 100, 500, 0, 1, item.newItemTable.rarity, false, maxFactor * 200)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_mana"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_mana", "#343EC9", 2)

    value, prefixLevel = RPCItems:RollAttribute(100, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 3)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_armor", "#D1D1D1", 3)

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDepthCrestArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_depth_crest_armor", "immortal", "Depth Crest Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "depth_crest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_depth_crest", "#6877E8", 1, "#property_depth_crest_description")

    local value, prefixLevel = RPCItems:RollAttribute(100, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 4)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 2)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFeatherwhiteArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_featherwhite_armor", "immortal", "Featherwhite Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "featherwhite"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_featherwhite_armor", "#FFFFFF", 1, "#property_featherwhite_armor_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.5)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDragonCeremonyVestments(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_dragon_ceremony_vestments", "immortal", "Vestments of the Dragon Ceremony", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "dragon_ceremony"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_dragon_ceremony", "#D4583F", 1, "#property_dragon_ceremony_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = WallPhysics:round(value * 1.5, 0)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSecretTempleArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_armor_of_secret_temple", "immortal", "Armor of the Secret Temple", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "secret_temple"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_secret_temple", "#CE87E6", 1, "#property_secret_temple_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollVampiricBreastplate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_vampiric_breastplate", "immortal", "Vampiric Breastplate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "vampiric_breastplate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_vampiric_breastplate", "#71EBA3", 1, "#property_varmpiric_breastplate_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 300, 800, 1, 1, item.newItemTable.rarity, false, maxFactor * 500)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGuardOfFeronia(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_guard_of_feronia", "immortal", "Guard of Feronia", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "feronia"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_guard_of_feronia", "#D67CC9", 1, "#property_guard_of_feronia_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.3)
    item.newItemTable.property2name = "rune_q_3"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMysticManaWall(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_mystic_mana_wall", "immortal", "Mystic Mana Wall", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "mystic_mana"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mystic_mana_wall", "#5FCFF5", 1, "#property_mystic_mana_wall_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 100, 500, 0, 1, item.newItemTable.rarity, false, maxFactor * 200)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_mana"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_mana", "#343EC9", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSkyforgeFlurryPlate(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_skyforge_flurry_plate", "immortal", "Skyforge Flurry Plate", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "skyforge"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_skyforge", "#66BCDE", 1, "#property_skyforge_description")

    local value = RandomInt(maxFactor * 2, maxFactor * 4) * GameState:GetDifficultyFactor()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDarkArtsVestments(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_dark_arts_vestments", "immortal", "Vestments of the Dark Arts", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "dark_arts"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_dark_arts", "#7A3B63", 1, "#property_dark_arts_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSapphireDragonScaleArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_sapphire_dragon_scale_armor", "immortal", "Sapphire Dragon Scale Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sapphire_dragon"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sapphire_dragon", "#5786C9", 1, "#property_sapphire_dragon_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 8, 17, 0, 0, item.newItemTable.rarity, false, maxFactor * 16)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    item.newItemTable.property3 = RPCItems:GetLogarithmicVarianceValue(17, 0, 0, 0, 0)
    item.newItemTable.property3name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_magic_resist", "#AC47DE", 3)

    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTopazDragonScaleArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_topaz_dragon_scale_armor", "immortal", "Topaz Dragon Scale Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "topaz_dragon"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_topaz_dragon", "#FFFC5C", 1, "#property_topaz_dragon_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 8, 17, 0, 0, item.newItemTable.rarity, false, maxFactor * 16)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    item.newItemTable.property3 = RPCItems:GetLogarithmicVarianceValue(17, 0, 0, 0, 0)
    item.newItemTable.property3name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_magic_resist", "#AC47DE", 3)

    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBlazingFuryArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_blazing_fury_armor", "immortal", "Blazing Fury Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "blazing_fury"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blazing_fury_armor", "#C1513E", 1, "#property_blazing_fury_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 5, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRubyDragonScaleArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ruby_dragon_scale_armor", "immortal", "Ruby Dragon Scale Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ruby_dragon"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ruby_dragon_armor", "#C94242", 1, "#property_ruby_dragon_armor_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 8, 17, 0, 0, item.newItemTable.rarity, false, maxFactor * 16)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    item.newItemTable.property3 = RPCItems:GetLogarithmicVarianceValue(18, 0, 0, 0, 0)
    item.newItemTable.property3name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_magic_resist", "#AC47DE", 3)

    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollLegionVestments(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_legion_vestments", "immortal", "Legion Vestments", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "legion_vest"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_legion_vestments", "#D45757", 1, "#property_legion_vestments_description")
    local luck = RandomInt(1, 3)
	if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(0, 3, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    elseif luck == 2 then
        value, nameLevel = RPCItems:RollAttribute(0, 3, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    elseif luck == 3 then
        value, nameLevel = RPCItems:RollAttribute(0, 3, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollNightmareRiderMantle(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_nightmare_rider_mantle", "immortal", "Nightmare Rider Mantle", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "nightmare_rider"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_nightmare_rider", "#423670", 1, "#property_nightmare_rider_description")
    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBodyProperty2(item, 0)
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_SHADOW, 2.1, 1, 30, 2)
    end
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGoldPlateOfLeon(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_gold_plate_of_leon", "immortal", "Gold Plate of Leon", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "gold_leon"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gold_plate_of_leon", "#E6E617", 1, "#property_gold_plate_of_leon_description")
	local luck = RandomInt(1, 3)
	if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(0, 5, 25, 0, 0, item.newItemTable.rarity, false, maxFactor * 30)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    elseif luck == 2 then
        value, nameLevel = RPCItems:RollAttribute(0, 5, 25, 0, 0, item.newItemTable.rarity, false, maxFactor * 30)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    elseif luck == 3 then
        value, nameLevel = RPCItems:RollAttribute(0, 5, 25, 0, 0, item.newItemTable.rarity, false, maxFactor * 30)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSpaceTechVest(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_space_tech_vest", "immortal", "Space Tech Vest", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "space_tech"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_space_tech", "#4843E6", 1, "#property_space_tech_description")

    Elements:RollElementAttribute(item, RPC_ELEMENT_COSMOS, 2.5, 3, 30, 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollStormshieldCloak(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_stormshield_cloak", "immortal", "Stormshield Cloak", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "stormshield"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_stormshield", "#BAD5DE", 1, "#property_stormshield_description")

    local value = RandomInt(maxFactor * 5, maxFactor * 10)
    value = RPCItems:GetLogarithmicVarianceValue(value, 0, 0, 0, 0)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    value = RandomInt(maxFactor * 5, maxFactor * 10)
    value = RPCItems:GetLogarithmicVarianceValue(value, 0, 0, 0, 0)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_armor", "#D1D1D1", 3)

    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollDirewolfBulkwark(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_direwolf_bulwark", "immortal", "Direwolf Bulwark", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "direwolf"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_direwolf", "#502AA3", 1, "#property_direwolf_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 17)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    elseif luck == 2 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 17)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    elseif luck == 3 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 17)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end
    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.2)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item

end

function RPCItems:RollInfernalPrison(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_the_infernal_prison", "immortal", "The Infernal Prison", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "infernal_prison"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_infernal_prison", "#E87E15", 1, "#property_infernal_prison_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 3, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollBodyProperty3(item, 0)

    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollEnchantedSolarCape(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_enchanted_solar_cape", "immortal", "Enchanted Solar Cape", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "enchanted_solar"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_enchanted_solar", "#EBB523", 1, "#property_enchanted_solar_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.3)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)

    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGildedSoulCage(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_gilded_soul_cage", "immortal", "Gilded Soul Cage", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "soul_cage"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gilded_soul", "#B0C930", 1, "#property_gilded_soul_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 3, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 8)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollOutlandStoneCuirass(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_outland_stone_cuirass", "immortal", "Outland Stone Cuirass", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "outland_stone"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_outland_stone", "#FFB668", 1, "#property_outland_stone_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 200, 800, 1, 1, item.newItemTable.rarity, false, maxFactor * 600)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollArmorOfAtlantis(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_armor_of_atlantis", "immortal", "Outland Stone Cuirass", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "atlantis"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_armor_of_atlantis", "#478EC1", 1, "#property_armor_of_atlantis_Description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 200, 800, 1, 1, item.newItemTable.rarity, false, maxFactor * 800)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBluestarArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_bluestar_armor", "immortal", "Bluestar Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "bluestar"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bluestar_armor", "#285EBD", 1, "#property_bluestar_armor_description")

    local value, suffixLevel = RPCItems:RollAttribute(100, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 9)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "mana_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_mana_regen", "#649FA3", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTatteredNoviceArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_tattered_novice_armor", "immortal", "Tattered Novice Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "tattered_novice"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tattered_novice_armor", "#61C695", 1, "#property_tattered_novice_armor_description")

    item.newItemTable.hasRunePoints = true
    local t1_rune_value = RPCItems:RollSlithicusRingProperty()
    local luck = RandomInt(1, 4)
    if luck == 1 then
        item.newItemTable.property2name = "rune_q_1"
    elseif luck == 2 then
        item.newItemTable.property2name = "rune_w_1"
    elseif luck == 3 then
        item.newItemTable.property2name = "rune_e_1"
    else
        item.newItemTable.property2name = "rune_r_1"
    end
    item.newItemTable.property2 = t1_rune_value
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollWindsteelArmor(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_windsteel_armor", "immortal", "Windsteel Armor", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "windsteel"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_windsteel_armor", "#5079D9", 1, "#property_windsteel_armor_description")

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.4)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    item.newItemTable.hasRunePoints = true

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:VermillionDreamRobes(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_vermillion_dream_robes", "immortal", "Vermillion Dream Robes", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "vermillion_dream"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_vermillion_dream_robes", "#D14268", 1, "#property_vermillion_dream_robes_description")
    local luck = RandomInt(1, 4)
    if luck == 4 and maxFactor >= 270 then
        local letter = RPCItems:GetRandomRuneLetter(1, 4)
        runeName = "rune_"..letter.."_4"
        runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 30, 0, 0, 0, 0)

        item.newItemTable.property2name = runeName
        item.newItemTable.property2 = math.floor(runeValue)
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    else
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property2 = math.ceil(value * 1.15)
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end
    item.newItemTable.hasRunePoints = true

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRobesOfEruditeTeacher(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_robe_of_the_erudite_teacher", "immortal", "Robes of the Erudite Teacher", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "erudite_teacher"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_robe_of_the_erudite_teacher", "#32a852", 1, "#property_robe_of_the_erudite_teacher_description")
    local luck = RandomInt(1, 4)
    if luck == 3 and maxFactor > 160 then
        local letter = RPCItems:GetRandomRuneLetter(1, 4)
        runeName = "rune_"..letter.."_3"
        runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 20, 0, 0, 0, 0)

        item.newItemTable.property2name = runeName
        item.newItemTable.property2 = math.floor(runeValue)
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)        
    elseif luck == 4 and maxFactor >= 240 then
        local letter = RPCItems:GetRandomRuneLetter(1, 4)
        runeName = "rune_"..letter.."_4"
        runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 30, 0, 0, 0, 0)

        item.newItemTable.property2name = runeName
        item.newItemTable.property2 = math.floor(runeValue)
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    else
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property2 = math.ceil(value * 1.15)
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end
    item.newItemTable.hasRunePoints = true

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end


function RPCItems:RollLightSeersRobes(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_templar_light_seers_robe", "immortal", "Templar Light Seer's Robe", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "light_seer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_light_seer", "#F4E155", 1, "#property_light_seer_Description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property2 = math.ceil(value * 1.5)
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

        item.newItemTable.hasRunePoints = true
    elseif luck == 2 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_HOLY, 3, 2, 22, 2)
    else
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end

    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end
--HATS

function RPCItems:RollWhiteMageHat(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_white_mage_hat", "immortal", "White Mage Hat", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "white_mage_hat2"
    --RPCItems:SetPropertyValuesSpecial(item, 0, "#item_property_white_mage_hat", "#FFFFFF",  1, "#property_white_mage_hat_description")
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_white_mage_hat_2", "#FFFFFF", 1, "#property_white_mage_hat_2_description")

    local value, prefixLevel = RPCItems:RollAttribute(100, 6, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "health_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_health_regen", "#6AA364", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    --pre patch lv values
    if type(item.newItemTable.property2) == "number" then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.2)
    end
    if type(item.newItemTable.property3) == "number" then
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.2)
    end
    if type(item.newItemTable.property4) == "number" then
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.2)
    end

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollBasiliskPlagueHelm(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_basilisk_plague_helm", "immortal", "Basilisk Plague Helm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "basilisk_plague"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_basilisk_plague", "#93B058", 1, "#property_basilisk_plague_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local value, prefixLevel = RPCItems:RollAttribute(100, 6, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "health_regen"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_health_regen", "#6AA364", 2)
    elseif luck == 2 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_POISON, 3, 2, 30, 2)
    else
        RPCItems:RollHoodProperty2(item, 0)
    end

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollHelmOfKnightHawk(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_helm_of_the_knight_hawk", "immortal", "Helm of the Knight Hawk", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "knight_hawk"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_knight_hawk", "#3dd1a7", 1, "#property_knight_hawk_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    elseif luck == 2 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    elseif luck == 3 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    elseif luck == 4 then
        local maxFactor = RPCItems:GetMaxFactor()
        local value = RPCItems:GetLogarithmicVarianceValue(math.ceil(maxFactor / 2.5), 0, 0, 0, 0)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "movespeed"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_movespeed", "#B02020", 2)
    end

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollHoodOfTheSeaOracle(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_hood_of_the_sea_oracle", "immortal", "Hood of the Sea Oracle", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sea_oracle"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_sea_oracle", "#FFBC49", 1, "#property_sea_oracle_Description")

    item.newItemTable.hasRunePoints = true
    item.newItemTable.property2 = Weapons:GetDeviation(10, 0)
    item.newItemTable.property2name = "rune_q_4"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFrostmawHuntersHood(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_frostmaw_hunters_hood", "immortal", "Frostmaw Hunter's Hood", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "frostmaw"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_frostmaw", "#ff443a", 1, "#property_frostmaw_description")

    item.newItemTable.hasRunePoints = true

    local value, prefixLevel = RPCItems:RollAttribute(300, 300, 800, 1, 1, item.newItemTable.rarity, false, maxFactor * 500)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    local luck = RandomInt(1, 4)
    if luck == 4 and maxFactor >= 150 then
        local letter = RPCItems:GetRandomRuneLetter(1, 4)
        runeName = "rune_"..letter.."_4"
        runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 30, 0, 0, 0, 0)

        item.newItemTable.property3name = runeName
        item.newItemTable.property3 = math.floor(runeValue)
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property3 = math.ceil(value * 1.35)
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    RPCItems:RollHoodProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollOceanHelmOfValdun(deathLocation, bBossDrop)
    local item = RPCItems:CreateVariant("item_rpc_ocean_helm_of_valdun", "immortal", "Ocean Helm of Val'Dun", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()

    local rollFactor = 15
    if bBossDrop then
        rollFactor = 24
    end

    local value, nameLevel = RPCItems:RollAttribute(100, 14, 28, 0, 1, item.newItemTable.rarity, false, rollFactor * 50)
    item.newItemTable.property1 = value
    item.newItemTable.property1name = "all_elements"
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "#property_all_elements", "#BED5E5", 1)

    item.newItemTable.hasRunePoints = true

    item.newItemTable.property2 = Weapons:GetDeviation(math.ceil(rollFactor / 2), 0)
    local luck = RandomInt(1, 4)
    if luck == 1 then
        item.newItemTable.property2name = "rune_q_4"
    elseif luck == 2 then
        item.newItemTable.property2name = "rune_w_4"
    elseif luck == 3 then
        item.newItemTable.property2name = "rune_e_4"
    elseif luck == 4 then
        item.newItemTable.property2name = "rune_r_4"
    end
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTwistedMaskOfAhnqhirBlue(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_twisted_blue_mask_of_ahnqhir", "immortal", "Twisted Blue Mask of Ahn'qhir", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "mask_of_ahnqir_blue"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_twisted_mask_of_ahnqhir_c", "#6BB5F9", 1, "#property_twisted_mask_of_ahnqhir_c_Description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 0.9)
    item.newItemTable.property2name = "rune_e_3"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTwistedMaskOfAhnqhirYellow(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_twisted_yellow_mask_of_ahnqhir", "immortal", "Twisted Yellow Mask of Ahn'qhir", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "mask_of_ahnqir_yellow"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_twisted_mask_of_ahnqhir_b", "#EBFF6D", 1, "#property_twisted_mask_of_ahnqhir_b_Description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 0.9)
    item.newItemTable.property2name = "rune_w_3"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTwistedMaskOfAhnqhirPurple(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_twisted_purple_mask_of_ahnqhir", "immortal", "Twisted Purple Mask of Ahn'qhir", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "mask_of_ahnqir_purple"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_twisted_mask_of_ahnqhir_a", "#BC60F2", 1, "#property_twisted_mask_of_ahnqhir_a_Description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 0.9)
    item.newItemTable.property2name = "rune_q_3"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollShipyardVeil1(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_shipyard_veil_lv1", "immortal", "Shipyard Veil LV1", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "shipyard_veil"
    --RPCItems:SetPropertyValuesSpecial(item, 0, "#item_property_shipyard_veil_1", "#91F2F1",  1, "#property_shipyard_veil_1_description")
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_shipyard_veil_3", "#91F2F1", 1, "#property_shipyard_veil_3_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.15)
    item.newItemTable.property2name = "rune_q_3"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    --pre patch lv values
    if type(item.newItemTable.property2) == "number" then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
    end
    if type(item.newItemTable.property3) == "number" then
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
    end
    if type(item.newItemTable.property4) == "number" then
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHyperVisor(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_hyper_visor", "immortal", "Hyper Visor", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "hyper_visor"
    --RPCItems:SetPropertyValuesSpecial(item, 0, "#item_property_hyper_visor", "#3CB7E8",  1, "#property_hyper_visor_description")
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hyper_visor2", "#3CB7E8", 1, "#property_hyper_visor2_description")

    value, nameLevel = RPCItems:RollAttribute(100, 10, 20, 0, 1, item.newItemTable.rarity, false, math.min(maxFactor * 3, RandomInt(150, 250)))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_speed"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_attack_speed", "#B02020", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollBurningSpiritHelmet(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_burning_spirit_helmet", "immortal", "Burning Spirit Helmet", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "burning_spirit"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_burning_spirit", "#D6B948", 1, "#property_burning_spirit_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)
    elseif luck == 2 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    elseif luck == 3 then
        value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    end

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollRubyDragonCrown(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_crown_of_ruby_dragon", "immortal", "Crown of Ruby Dragon", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ruby_dragon"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ruby_dragon", "#BD2A2A", 1, "#property_ruby_dragon_description")

    value, nameLevel = RPCItems:RollAttribute(100, 20, 100, 0, 0, item.newItemTable.rarity, false, maxFactor * 16)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollCentaurHorns(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_centaur_horns", "immortal", "Sturdy Centaur Horns", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()

    RPCItems:RollHoodProperty1(item, 0)
    RPCItems:RollHoodProperty2(item, 0)
    RPCItems:RollHoodProperty3(item, 0)
    item.newItemTable.property4 = 1
    item.newItemTable.property4name = "centaur_horns"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_centaur_horns", "#876852", 4, "#property_centaur_horns_description")

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollHoodOfChosen(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_hood_of_chosen", "immortal", "Hood of the Chosen", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property1 = math.ceil(value * 2)
    item.newItemTable.property1name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollDeathWhisperHelm(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_death_whisper_helm", "immortal", "Death Whisper Helm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "death_whisper"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_death_whisper", "#4A6A8C", 1, "#property_death_whisper_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 3
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollGuardOfGrithault(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_guard_of_grithault", "immortal", "Guard of Grithault", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "grithault"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_grithault", "#34E039", 1, "#property_grithault_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollHoodOfBlackMage(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_hood_of_the_black_mage", "immortal", "Hood of the Black Mage", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "black_mage"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_black_mage", "#A9B023", 1, "#property_black_mage_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 2, 12, 0, 0, item.newItemTable.rarity, false, math.ceil(maxFactor / 2.4))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "base_ability"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_base_ability", "#7AB4CC", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollCapOfWildNature(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_cap_of_wild_nature", "immortal", "Cap of Wild Nature", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    local luck = RandomInt(1, 3)
    if luck == 1 then
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "wild_nature_one"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature", "#573E2F", 1, "#property_wild_nature_description")
        RPCItems:RollHoodProperty2(item, 0)
    elseif luck == 2 then
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "wild_nature_two"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature_two", "#573E2F", 1, "#property_wild_nature_two_description")
        RPCItems:RollHoodProperty2(item, 0)
    else
        item.newItemTable.property1 = 1
        item.newItemTable.property1name = "wild_nature_one"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature", "#573E2F", 1, "#property_wild_nature_description")
        item.newItemTable.property2 = 1
        item.newItemTable.property2name = "wild_nature_two"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wild_nature_two", "#573E2F", 2, "#property_wild_nature_two_description")
    end
    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollLumaGuard(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_guard_of_luma", "immortal", "Guard of Luma", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "luma_guard"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_luma", "#B8A3E3", 1, "#property_luma_description")

    local visionBonus = RandomInt(400, 700)
    item.newItemTable.property2 = visionBonus
    item.newItemTable.property2name = "vision"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_vision_bonus", "#96D1D9", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollBrazenKabuto(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_brazen_kabuto_of_the_desert_realm", "immortal", "Brazen Kabuto of the Desert Realm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "brazen_kabuto"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_brazen_kabuto", "#A87D4C", 1, "#property_brazen_kabuto_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local value, nameLevel = RPCItems:RollAttribute(0, 4, 8, 0, 0, item.newItemTable.rarity, false, maxFactor * 3)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "armor"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)
    else
        item.newItemTable.hasRunePoints = true
        local luck2 = RandomInt(1, 100)
        local runeValue = 0
        local runeName = ""
        if luck2 <= 35 then
            runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 5, 0, 0, 0, 0)
            runeName = "rune_r_1"
        elseif luck2 <= 70 then
            runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 5, 0, 0, 0, 0)
            runeName = "rune_r_2"
        elseif luck2 <= 90 then
            runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 10, 0, 0, 0, 0)
            runeName = "rune_r_3"
        else
            runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 25, 0, 0, 0, 0)
            runeName = "rune_r_4"
        end

        item.newItemTable.property2name = runeName
        item.newItemTable.property2 = runeValue
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end
    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollOdinHelmet(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_odin_helmet", "immortal", "Odin Helmet", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "odin"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_odin", "#82A6B3", 1, "#property_odin_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollStormcrackHelm(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_stormcrack_helm", "immortal", "Stormcrack Helm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "stormcrack2"
    --RPCItems:SetPropertyValuesSpecial(item, 0, "#item_property_stormcrack", "#EFF2AE",  1, "#property_stormcrack_description")
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_stormcrack2", "#EFF2AE", 1, "#property_stormcrack2_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollWraithCrown(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_wraith_crown", "immortal", "Wraith Crown", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "wraith"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wraith", "#5671E8", 1, "#property_wraith_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value * 2
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollIronColossus(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_iron_colussus", "immortal", "Helm of the Iron Colossus", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "iron_colossus"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_iron_colossus", "#874E4D", 1, "#property_iron_colossus_description")

    value, prefixLevel = RPCItems:RollAttribute(100, 5, 18, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    value, nameLevel = RPCItems:RollAttribute(100, 5, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 4)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_armor", "#D1D1D1", 3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollMugatoMask(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_mask_of_mugato", "immortal", "Mask of Mugato", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "mugato"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mugato", "#26E0C1", 1, "#property_mugato_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = WallPhysics:round(value * 1.5, 0)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollWitchHat(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_swamp_witch_hat", "immortal", "Swamp Witch's Hat", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "swamp_witch"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_swamp_witch", "#7300DE", 1, "#property_swamp_witch_description")
    local luck = RandomInt(1, 2)
    if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(0, 8, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_SHADOW, 2.5, 2, 20, 2)
    end

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollExcavatorsFocusHat(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_excavators_focus_cap", "immortal", "Excavator's Focus Cap", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "excavator"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_excavator", "#7300DE", 1, "#property_excavator_description")

    value, nameLevel = RPCItems:RollAttribute(0, 7, 11, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#58BFD6", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.5)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollTricksterMask(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_tricksters_mask", "immortal", "Trickster's Mask", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "trickster"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_trickster", "#FFFB17", 1, "#property_trickster_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 20, 0, 0, item.newItemTable.rarity, false, maxFactor * 20)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 2)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollDemonMask(deathLocation, isShop, waveBonus)
    local item = RPCItems:CreateVariant("item_rpc_demon_mask", "immortal", "Demon Mask", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "demon_mask"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_demon", "#C91818", 1, "#property_demon_description")

    item.newItemTable.hasRunePoints = true

    local luck = RandomInt(1, 4)
    local propertyName = ""
    if luck == 1 then
        propertyName = "rune_q_3"
    elseif luck == 2 then
        propertyName = "rune_w_3"
    elseif luck == 3 then
        propertyName = "rune_e_3"
    elseif luck == 4 then
        propertyName = "rune_r_3"
    end
    local difficulty = GameState:GetDifficultyFactor()
    if difficulty == 1 then
        waveBonus = math.max(waveBonus - 40, 15)
    elseif difficulty == 2 then
        waveBonus = math.max(waveBonus - 30, 15)
    elseif difficulty == 3 then
        waveBonus = math.max(waveBonus - 20, 15)
    end
    waveBonus = math.min(waveBonus, 20)
    item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(waveBonus, 0, 0, 0, 0)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollCrestOfTheUmbralSentinel(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_crest_of_the_umbral_sentinel", "immortal", "Crest of the Umbral Sentinel", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "umbral"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_umbral", "#90C3D4", 1, "#property_umbral_description")

    item.newItemTable.hasRunePoints = true

    local luck = RandomInt(1, 10)
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    value = math.floor(value * 1.5)
    if luck <= 5 then
        propertyName = "rune_w_1"
    elseif luck <= 9 then
        propertyName = "rune_w_2"
    elseif luck == 10 then
        propertyName = "rune_w_3"
    end

    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollCarbuncleHelm(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_carbuncles_helm_of_reflection", "immortal", "Carbuncle's Helm of Reflection", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "carbuncle"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_carbuncle", "#B85454", 1, "#property_carbuncle_description")

    item.newItemTable.hasRunePoints = true

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.2)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local luck = RandomInt(1, 10)
    if luck < 10 then
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property3 = math.ceil(value * 1.5)
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property3 = math.ceil(value * 2.0)
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollWraithHuntersSteelHelm(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_wraith_hunters_steel_helm", "immortal", "Wraith Hunter's Steel Helm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "wraith_hunter"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wraith_hunter", "#55A9ED", 1, "#property_wraith_hunter_description")

    item.newItemTable.hasRunePoints = true

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollEmeraldDouli(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_emerald_douli", "immortal", "Emerald Douli", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "emerald_douli"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_emerald_douli", "#1DDB49", 1, "#property_emerald_douli_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 300, 800, 1, 1, item.newItemTable.rarity, false, maxFactor * 500)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    value, prefixLevel = RPCItems:RollAttribute(300, 100, 500, 0, 1, item.newItemTable.rarity, false, maxFactor * 200)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "max_mana"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_max_mana", "#343EC9", 3)

    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollMaskOfTyrius(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_mask_of_tyrius", "immortal", "Mask of Tyrius", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "tyrius"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tyrius", "#D6693A", 1, "#property_tyrius_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = WallPhysics:round(value * 1.5, 0)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    value, nameLevel = RPCItems:RollAttribute(100, 20, 60, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_strength", "#CC0000", 3)

    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollAutumnSleeperMask(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_autumn_sleeper_mask", "immortal", "Autumn Sleeper Mask", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "autumn_sleeper"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_autumn_sleeper", "#BF5050", 1, "#property_autumn_sleeper_description")

    RPCItems:RollHoodProperty2(item, 0)
    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollIgneousCanineHelm(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_igneous_canine_helm", "immortal", "Igneous Canine Helm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "igneous_canine"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_igneous_canine", "#EDDA61", 1, "#property_igneous_canine_description")

    RPCItems:RollHoodProperty2(item, 0)
    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollCrimsonSkullCap(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_crimson_skull_cap", "immortal", "Crimson Skull Cap", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "crimson_skull_cap"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_crimson_skull_cap", "#C25D55", 1, "#property_crimson_skull_cap_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 5, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 7)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    Elements:RollElementAttribute(item, RPC_ELEMENT_UNDEAD, 3, 1, 30, 3)

    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollEyeOfSeasons(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_eye_of_seasons", "immortal", "Eye of Seasons", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "eye_of_seasons"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_eye_of_seasons", "#E8985F", 1, "#property_eye_of_seasons_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = WallPhysics:round(value * 1.5, 0)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollCeruleanHighguard(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_veil_of_the_cerulean_high_guard", "immortal", "Veil of the Cerulean Highguard", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "cerulean_highguard"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_cerulean_highguard", "#1D35D1", 1, "#property_cerulean_highguard_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 5, 11, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end



function RPCItems:RollBlackfeatherCrown(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_blackfeather_crown", "immortal", "Blackfeather Crown", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "blackfeather"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blackfeather", "#615C6E", 1, "#property_blackfeather_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 1.7)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollMagistratesHood(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_magistrates_hood", "immortal", "Magistrate's Hood", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "magistrate"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_magistrate", "#fab60a", 1, "#property_magistrate_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.ceil(value * 2)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local luck = RandomInt(1, 4)
    if luck == 1 then
        local runeName = "rune_"..RPCItems:GetRandomRuneLetter(1, 4) .. "_3"
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property3 = math.floor(value*0.5)
        item.newItemTable.property3name = runeName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        RPCItems:RollHoodProperty3(item, 0)
    end
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollSuperAscendency(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_super_ascendency_mask", "immortal", "Super Ascendency Mask", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "super_ascendency"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_super_ascendency", "#E89300", 1, "#property_super_ascendency_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 5, 8, 0, 0, item.newItemTable.rarity, false, maxFactor * 9)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local value = RandomInt(maxFactor * 15, maxFactor * 360)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_bonus_attack_damage", "#343EC9", 3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollPhantomSorcererMask(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_mask_of_the_phantom_sorcerer", "immortal", "Mask of the Phantom Sorcerer", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "phantom_sorcerer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_phantom_sorcerer", "#02F21E", 1, "#property_phantom_sorcerer_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = WallPhysics:round(value * 1.5, 0)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollHelmOfSilentTemplar(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_helm_of_the_silent_templar", "immortal", "Helm of the Silent Templar", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "silent_templar"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_helm_of_silent_templar", "#9FC1ED", 1, "#property_helm_of_silent_templar_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = WallPhysics:round(value * 1.5, 0)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollChainsOfOrthok(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_chains_of_orthok", "immortal", "Chains of Orthok", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "orthok"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_chains_of_orthok", "#E8F43F", 1, "#property_chains_of_orthok_description")
    --print("ORTHOK??")
    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.5)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollArcaneCascadeHat(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_arcane_cascade_hat", "immortal", "Arcane Cascade Hat", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcane_cascade"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arcane_cascade", "#E558F5", 1, "#property_arcane_cascade_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 100, 500, 0, 1, item.newItemTable.rarity, false, maxFactor * 200)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_mana"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_mana", "#343EC9", 2)

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_intelligence", "#33CCFF", 3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollSamuraiHelmet(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_adamantine_samurai_helmet", "immortal", "Adamantine Samurai Helmet", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "samurai_helmet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_samurai_helmet", "#FF2427", 1, "#property_samurai_helmet_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 5)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    local value = RandomInt(maxFactor * 150, maxFactor * 360)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_bonus_attack_damage", "#343EC9", 3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollScourgeKnightHelm(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_scourge_knights_helm", "immortal", "Scourge Knight's Helm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "scourge_knight"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_scourge_knight", "#2A194F", 1, "#property_scourge_knight_description")
    local value = 0
    local luck = RandomInt(1, 5)
    if luck > 4 then
        value = RandomInt(15, 25)
    elseif luck > 3 then
        value = RandomInt(10, 20)
    else
        value = RandomInt(5, 15)
    end
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "lifesteal"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_lifesteal", "#B1E3B9", 2)

    local value = RandomInt(maxFactor * 15, maxFactor * 360)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_bonus_attack_damage", "#343EC9", 3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollHoodOfDefiler(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_hood_of_defiler", "immortal", "Hood of the Defiler", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "hood_of_defiler"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hood_of_defiler", "#B36481", 1, "#property_hood_of_defiler_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local value = RandomInt(maxFactor * 5, maxFactor * 500)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "attack_damage"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_DEMON, 2.7, 2, 29, 2)
    end

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollDarkReefSharkHelmet(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_dark_reef_shark_helmet", "immortal", "Dark Reef Shark Helmet", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "shark_helmet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_shark_helmet", "#A7BAB7", 1, "#property_shark_helmet_Description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        local value = RandomInt(maxFactor * 5, maxFactor * 500)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "attack_damage"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)
    else
        local value, nameLevel = RPCItems:RollAttribute(0, 8, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    end

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollNecromancerMask(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_mask_of_the_desert_necromancer", "immortal", "Mask of the Desert Necromancer", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "desert_necromancer"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_desert_necromancer", "#B38C66", 1, "#property_desert_necromancer_description")
    local value = 0
    local luck = RandomInt(1, 5)
    if luck > 4 then
        value = RandomInt(15, 25)
    elseif luck > 3 then
        value = RandomInt(10, 20)
    else
        value = RandomInt(5, 15)
    end
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "lifesteal"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_lifesteal", "#B1E3B9", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollUndertakersHood(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_undertakers_hood", "immortal", "Undertaker's Hood", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "undertaker"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_undertaker", "#3E8A2B", 1, "#property_undertaker_description")

    local value = RandomInt(maxFactor * 120, maxFactor * 250)
    value = math.floor(RPCItems:GetLogarithmicVarianceValue(value, 0, 0, 0, 0))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 17)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_intelligence", "#33CCFF", 3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollEternalNightShroud(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_shroud_of_eternal_night", "immortal", "Shroud of Eternal Night", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "eternal_night"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_eternal_night", "#494F63", 1, "#property_eternal_night_description")

    RPCItems:RollHoodProperty2(item, 0)
    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollHelmOfTheMountainGiant(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_helm_of_the_mountain_giant", "immortal", "Helm Of The Mountain Giant", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "mountain_giant"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_giant", "#C95226", 1, "#property_mountain_giant_description")

    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 16, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollDruidsSpiritHelm(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_wolfir_druids_spirit_helm", "immortal", "Wolfir Druid's Spirit Helm", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "druid_spirit"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_druids_spirt", "#9DCCC2", 1, "#property_druids_spirit_description")

    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 16, 0, 0, item.newItemTable.rarity, false, maxFactor * 16)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    value, nameLevel = RPCItems:RollAttribute(0, 12, 18, 0, 0, item.newItemTable.rarity, false, maxFactor * 18)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_intelligence", "#33CCFF", 3)

    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollGlintOfOnu(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_blinded_glint_of_onu", "immortal", "Blinded Glint of Onu", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "glint_of_onu"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_glint_of_onu", "#9DCCC2", 1, "#property_glint_of_onu_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollLavaForgeCrown(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_crown_of_the_lava_forge", "immortal", "Crown of the Lava Forge", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "lava_forge"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_lava_forge", "#EB6A59", 1, "#property_lava_forge_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 14, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollRoknarEmperor(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_crown_of_the_roknar_emperor", "immortal", "Crown of the Rok'nar Emperor", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "roknar"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_roknar_emperor", "#72BD28", 1, "#property_roknar_emperor_description")

    local value, prefixLevel = RPCItems:RollAttribute(100, 8, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    local value, prefixLevel = RPCItems:RollAttribute(300, 300, 800, 1, 1, item.newItemTable.rarity, false, maxFactor * 500)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_max_health", "#B02020", 3)

    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

function RPCItems:RollSwampDoctorMask(deathLocation, isShop)
    local item = RPCItems:CreateVariant("item_rpc_swamp_doctors_tribal_mask", "immortal", "Swamp Doctor's Tribal Mask", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "swamp_doctor"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_swamp_doctor", "#61AD64", 1, "#property_swamp_doctor_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 300, 700, 1, 1, item.newItemTable.rarity, false, maxFactor * 500)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)
    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    RPCItems:DropOrGiveItem(hero, item, isShop, deathLocation)
    return item
end

--FEET

function RPCItems:RollDunetreadBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_dunetread_boots", "immortal", "Dunetreads", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "dunetread"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_dunetread", "#8A8546", 1, "#property_dunetread_description")

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollEmeraldSpeedRunners(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_emerald_speed_runners", "immortal", "Emerald Speed Runners", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "emerald_speed"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_emerald_speed", "#3EC18A", 1, "#property_emerald_speed_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.3)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollCrystallineSlippers(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_crystalline_slippers", "immortal", "Crystalline Slippers", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "crystalline"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_crystalline", "#99E8E0", 1, "#property_crystalline_Description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.3)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollAlaranaIceBoot(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_alaranas_ice_boot", "immortal", "Alarana's Ice Boot", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "alarana"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_alarana", "#AFECFF", 1, "#property_alarana_description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollFootProperty2(item, 0)
    elseif luck == 2 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_ICE, 2.4, 1, 20, 2)
    else
        local luck = RandomInt(1, 6)
        item.newItemTable.hasRunePoints = true
        if luck == 1 then
            local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
            item.newItemTable.property2 = math.floor(value * 1.0)
            item.newItemTable.property2name = "rune_e_3"
            RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
        else
            local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
            item.newItemTable.property2 = math.floor(value * 1.4)
            item.newItemTable.property2name = propertyName
            RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
        end
    end
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollPegasusBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_pegasus_boots", "immortal", "Pegasus Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "pegasus"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pegasus", "#cdd1b0", 1, "#property_pegasus_description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollFootProperty2(item, 0)
    else
        local luck = RandomInt(1, 6)
        item.newItemTable.hasRunePoints = true
        if luck == 1 then
            local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
            item.newItemTable.property2 = math.floor(value * 0.9)
            item.newItemTable.property2name = "rune_e_3"
            RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
        else
            local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
            item.newItemTable.property2 = math.floor(value * 1.5)
            item.newItemTable.property2name = propertyName
            RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
        end
    end
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollPivotalSwiftboots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_pivotal_swiftboots", "immortal", "Pivotal Swiftboots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "pivotal"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pivotal", "#4fd9f7", 1, "#property_pivotal_description")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        RPCItems:RollFootProperty2(item, 0)
    else
        item.newItemTable.hasRunePoints = true
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property2 = math.floor(value * 1.5)
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGiantHunterBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_giant_hunters_boots_of_resilience", "immortal", "Giant Hunters Boots of Resilience", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "giant_hunter"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_giant_hunter_boot", "#E3E300", 1, "#property_giant_hunter_boot_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 220, 600, 1, 1, item.newItemTable.rarity, false, maxFactor * 400)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.6)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollVoyagerBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_voyager_boots", "immortal", "Voyager Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "voyager"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_voyager", "#AB9091", 1, "#property_voyager_description")

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRedrockFootwear(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_redrock_footwear", "immortal", "Redrock Footwear", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "redrock"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_redrock", "#EB0E0E", 1, "#property_redrock_description")

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollResonantPathfinderBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_pathfinders_resonant_boots", "immortal", "Pathfinder's Resonant Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "pathfinder"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pathfinder", "#E3E02D", 1, "#property_pathfinder_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.3)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollNeptunesWaterGliders(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_neptunes_water_gliders", "immortal", "Neptune's Water Gliders", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "neptune"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_neptune", "#2294F2", 1, "#property_neptune_description")

    item.newItemTable.hasRunePoints = true
    local luck = RandomInt(1, 10)
    local runeName = "rune_e_1"
    if luck <= 8 and luck > 4 then
        runeName = "rune_e_2"
    elseif luck > 8 then
        runeName = "rune_e_3"
    end

    local value, nameLevel = RPCItems:RollAttribute(0, 1, math.ceil(maxFactor / 4), 0, 0, item.newItemTable.rarity, false, math.ceil(maxFactor / 2.6 + 4))
    item.newItemTable.property2 = math.floor(value)
    item.newItemTable.property2name = runeName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollVioletTreads(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_boots_of_the_violet_guard", "immortal", "Boots of the Violet Guard", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "violet_boots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_violet_boot", "#A337E6", 1, "#property_violet_boot_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 7, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:SlingerBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_slinger_boots", "immortal", "Bladeslinger Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "slinger"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_slinger_boot", "#D6D2D2", 1, "#property_slinger_boots_description")

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGuardianGreaves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_guardian_greaves", "immortal", "Guardian Greaves", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "guardian_greaves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_guardian_greaves", "#8FE051", 1, "#property_guardien_greaves_description")

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHarvesterBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_harvester_boots", "immortal", "Harvester Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true

    local luck = RandomInt(1, 3)
    if luck == 3 then
        local letter = RPCItems:GetRandomRuneLetter(1, 4)
        runeName = "rune_"..letter.."_1"
        runeValue = math.floor(RPCItems:GetLogarithmicVarianceValue(maxFactor / 5, 0, 0, 0, 0))

        item.newItemTable.property1name = runeName
        item.newItemTable.property1 = runeValue
        RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)
    else
        RPCItems:RollFootProperty1(item, 0)
        local itemBonus = RPCItems:GetLogarithmicVarianceNoRounding(1.0)
        itemBonus = math.min(itemBonus, 1.35)
        local value = math.ceil(item.newItemTable.property1 * itemBonus)
        value = math.ceil(value)
        item.newItemTable.property1 = value
        item.newItemTable.hasRunePoints = true
    end

    local luck = RandomInt(1, 3)
    if luck == 3 then
        local letter = RPCItems:GetRandomRuneLetter(1, 4)
        runeName = "rune_"..letter.."_2"
        runeValue = math.floor(RPCItems:GetLogarithmicVarianceValue(maxFactor / 5, 0, 0, 0, 0))

        item.newItemTable.property2name = runeName
        item.newItemTable.property2 = math.floor(runeValue)
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    else
        RPCItems:RollFootProperty2(item, 0)
        local itemBonus = RPCItems:GetLogarithmicVarianceNoRounding(1.0)
        itemBonus = math.min(itemBonus, 1.35)
        local value = math.ceil(item.newItemTable.property2 * itemBonus)
        value = math.ceil(value)
        item.newItemTable.property2 = value
        item.newItemTable.hasRunePoints = true
    end

    local luck = RandomInt(1, 3)
    if luck == 3 and maxFactor >= 150 then
        local letter = RPCItems:GetRandomRuneLetter(1, 4)
        runeName = "rune_"..letter.."_3"
        runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 10, 0, 0, 0, 0)

        item.newItemTable.property3name = runeName
        item.newItemTable.property3 = math.floor(runeValue)
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        RPCItems:RollFootProperty3(item, 0)
        local itemBonus = RPCItems:GetLogarithmicVarianceNoRounding(1.0)
        itemBonus = math.min(itemBonus, 1.35)
        local value = math.ceil(item.newItemTable.property3 * itemBonus)
        value = math.ceil(value)
        item.newItemTable.property3 = value
        item.newItemTable.hasRunePoints = true
    end

    local luck = RandomInt(1, 4)
    if luck == 4 and maxFactor >= 270 then
        local letter = RPCItems:GetRandomRuneLetter(1, 4)
        runeName = "rune_"..letter.."_4"
        runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 30, 0, 0, 0, 0)

        item.newItemTable.property4name = runeName
        item.newItemTable.property4 = math.floor(runeValue)
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    else
        RPCItems:RollFootProperty4(item, 0)
        local itemBonus = RPCItems:GetLogarithmicVarianceNoRounding(1.0)
        itemBonus = math.min(itemBonus, 1.35)
        local value = math.ceil(item.newItemTable.property4 * itemBonus)
        value = math.ceil(value)
        item.newItemTable.property4 = value
        item.newItemTable.hasRunePoints = true
    end
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation

    item.pickedUp = true

    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollCrimsythEliteGreavesLV1(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_crimsyth_elite_greaves_lv1", "immortal", "Crimsyth Elite Greaves LV1", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 0
    item.newItemTable.property1name = "crimsyth_elite"
    --RPCItems:SetPropertyValuesSpecial(item, 0, "#item_property_crimsyth_elite_1", "#DD2727",  1, "#property_crimsyth_elite_1_description")
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_crimsyth_elite_3", "#DD2727", 1, "#property_crimsyth_elite_3_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 4, 8, 0, 0, item.newItemTable.rarity, false, maxFactor * 4)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)

    --pre patch lv values
    if type(item.newItemTable.property2) == "number" then
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
        item.newItemTable.property2 = math.ceil(item.newItemTable.property2 * 1.1)
    end
    if type(item.newItemTable.property3) == "number" then
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
        item.newItemTable.property3 = math.ceil(item.newItemTable.property3 * 1.1)
    end
    if type(item.newItemTable.property4) == "number" then
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
        item.newItemTable.property4 = math.ceil(item.newItemTable.property4 * 1.1)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollAblecoreGreaves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ablecore_greaves", "immortal", "Ablecore Greaves", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ablecore"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ablecore_greaves", "#DED083", 1, "#property_ablecore_greaves_description")

    RPCItems:RollFootProperty2(item, 0)
    local luck = RandomInt(1, 5)
    if luck == 5 then
        local moveslow = RandomInt(24, 60) * 5
        item.newItemTable.property2 = moveslow
        item.newItemTable.property2name = "movespeed_slow"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_movespeed_slow", "#B02020", 2)
    end
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBlueDragonGreaves(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_blue_dragon_greaves", "immortal", "Blue Dragon Greaves", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "dragon_greaves"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_dragon_greaves", "#2B4DE3", 1, "#property_dragon_greaves_description")

    local luck = RandomInt(1, 5)
    if luck > 1 then
        RPCItems:RollFootProperty2(item, 0)
    else
        local luck = RandomInt(1, 9)
        item.newItemTable.hasRunePoints = true
        if luck == 1 then
            local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
            item.newItemTable.property2 = math.floor(value * 1.2)
            item.newItemTable.property2name = "rune_e_3"
            RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
        elseif luck == 2 then
            local value = RandomInt(maxFactor * 12, maxFactor * 800)
			item.newItemTable.property2 = value
			item.newItemTable.property2name = "attack_damage"
			RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)
		else
			local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
            item.newItemTable.property2 = math.floor(value * 1.8)
            item.newItemTable.property2name = propertyName
            RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)		
        end
    end
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSangeBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_sange_boots", "immortal", "Sange Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sange"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sange", "#CC1104", 1, "#property_sange_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(0, 7, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)
    else
        local luck2 = RandomInt(1, 100)
        local runeValue = 0
        local runeLetter = RPCItems:GetRandomRuneLetter(1, 4)
        local runeName = ''
        if luck2 <= 45 then
            runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 7.5, 0, 0, 0, 0)
            runeName = 'rune_' .. runeLetter .. '_1'
        elseif luck2 <= 90 then
            runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 7.5, 0, 0, 0, 0)
            runeName = 'rune_' .. runeLetter .. '_2'
        else
            runeValue = RPCItems:GetLogarithmicVarianceValue(maxFactor / 15, 0, 0, 0, 0)
            runeName = 'rune_' .. runeLetter .. '_3'
        end
        item.newItemTable.property2name = runeName
        item.newItemTable.property2 = runeValue
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollOceanrunnerBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_oceanrunner_boots", "immortal", "Oceanrunner", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "oceanrunner"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#property_oceanrunner", "#58EFD6", 1, "#property_oceanrunner_Description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBootsOfOldWisdom(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_boots_of_old_wisdom", "immortal", "Boots of Old Wisdom", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "old_wisdom"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_old_wisdom", "#8DEBCE", 1, "#property_old_wisdom_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollResplendantRubberBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_resplendent_rubber_boots", "immortal", "Resplendent Rubber Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "rubber_boot"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_resplendent_rubber", "#DADE66", 1, "#property_resplendent_rubber_description")

    item.newItemTable.property2 = RandomInt(8, 25)
    item.newItemTable.property2name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_magic_resist", "#AC47DE", 2)

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.floor(value * 1.5)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTerrasicLavaBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_terrasic_lava_boots", "immortal", "Terrasic Lava Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "terrasic_lava"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_terrasic_lava", "#9C4343", 1, "#property_terrasic_lava_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.5)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    Elements:RollElementAttribute(item, RPC_ELEMENT_FIRE, 3, 1, 32, 3)

    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGhostSlippers(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ghost_slippers", "immortal", "Ghost Slippers", "feet", true, "Slot: Feet")
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ghost_walk"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_unit_walking", "#9B72C4", 1, "#property_unit_walking_description")

    item.newItemTable.property2 = RandomInt(5, 10)
    item.newItemTable.property2name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_magic_resist", "#AC47DE", 2)

    item.newItemTable.property3 = RandomInt(5, 15)
    item.newItemTable.property3name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_magic_resist", "#AC47DE", 3)
    local maxFactor = RPCItems:GetMaxFactor()
    local luck = RandomInt(1, 3)
    if luck == 1 then
        value, nameLevel = RPCItems:RollAttribute(0, 30, 40, 0, 0, item.newItemTable.rarity, false, maxFactor * 24)
        item.newItemTable.property4 = value
        item.newItemTable.property4name = "strength"
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "#item_strength", "#CC0000", 4)
    elseif luck == 2 then
        value, nameLevel = RPCItems:RollAttribute(0, 30, 40, 0, 0, item.newItemTable.rarity, false, maxFactor * 24)
        item.newItemTable.property4 = value
        item.newItemTable.property4name = "agility"
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "#item_agility", "#2EB82E", 4)
    elseif luck == 3 then
        value, nameLevel = RPCItems:RollAttribute(0, 30, 40, 0, 0, item.newItemTable.rarity, false, maxFactor * 24)
        item.newItemTable.property4 = value
        item.newItemTable.property4name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "#item_intelligence", "#33CCFF", 4)
    end
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollYashaBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_yasha_boots", "immortal", "Yasha Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "yasha"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_yasha", "#4FD65A", 1, "#property_yasha_description")

    value, prefixLevel = RPCItems:RollAttribute(100, 4, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSteamboots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_steamboots", "immortal", "Steam Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "steamboots"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_steamboots", "#4FD65A", 1, "#property_steamboots_description")

    value, prefixLevel = RPCItems:RollAttribute(100, 4, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "agility"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_agility", "#2EB82E", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTranquilBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_tranquil_boots", "immortal", "Tranquil Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "tranquil"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_tranquil_boots", "#30E691", 1, "#property_tranquil_boots_description")

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFireWalkers(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_fire_walkers", "immortal", "Fire Walkers", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "fire_walker"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fire_walkers", "#DE4318", 1, "#property_fire_walkers_description")

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRedfallRunners(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_redfall_runners", "immortal", "Redfall Runners", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "redfall_runners"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_redfall_runners", "#E87B7B", 1, "#property_redfall_runners_description")

    local value, nameLevel = RPCItems:RollAttribute(100, 2, 12, 0, 0, item.newItemTable.rarity, false, math.ceil(maxFactor / 2.4))
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "base_ability"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_base_ability", "#7AB4CC", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRedOctoberBoots(deathLocation, isSpirit)
    local item = RPCItems:CreateVariant("item_rpc_red_october_boots", "immortal", "Red October Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "red_october"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_red_october", "#E87B7B", 1, "#property_red_october_description")

    item.newItemTable.hasRunePoints = true
    local runeName = "rune_e_4"
    local runeValue = 0
    if isSpirit then
        runeValue = RPCItems:GetLogarithmicVarianceValue(14, 0, 0, 0, 0)
    else
        runeValue = RPCItems:GetLogarithmicVarianceValue(9, 0, 0, 0, 0)
    end
    item.newItemTable.property2name = runeName
    item.newItemTable.property2 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local luck = RandomInt(1, 3)
    if luck == 1 then
        if isSpirit then
            runeValue = RPCItems:GetLogarithmicVarianceValue(14, 0, 0, 0, 0)
        else
            runeValue = RPCItems:GetLogarithmicVarianceValue(9, 0, 0, 0, 0)
        end
        item.newItemTable.property3name = runeName
        item.newItemTable.property3 = runeValue
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        RPCItems:RollFootProperty3(item, 0)
    end
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBootsOfAshara(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_boots_of_ashara", "immortal", "Boots of Ashara", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ashara"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_boots_of_ashara", "#E6C149", 1, "#property_boots_of_ashara_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 4, 8, 0, 0, item.newItemTable.rarity, false, maxFactor * 3)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollGravelfootTreads(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_gravelfoot_treads", "immortal", "Gravelfoot Treads", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "gravelfoot"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_gravelfoot", "#8FC2C9", 1, "#property_gravelfoot_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 14, 30, 0, 0, item.newItemTable.rarity, false, maxFactor * 10)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollIceFloeSlippers(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ice_floe_slippers", "immortal", "Ice Floe Slippers", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "ice_floe"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ice_floe_slippers", "#8BD3F9", 1, "#property_ice_floe_slippers_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.4)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    local rollMax = 7 + math.ceil(maxFactor / 100)
    local luck = RandomInt(1, rollMax)
    if luck <= 6 then
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 4 + 5)
        item.newItemTable.property3 = WallPhysics:round(value, 0)
        item.newItemTable.property3name = "rune_e_2"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    elseif luck <= 9 then
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 6 + 5)
        item.newItemTable.property3 = WallPhysics:round(value, 0)
        item.newItemTable.property3name = "rune_e_3"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 20)
        item.newItemTable.property3 = math.floor(value)
        item.newItemTable.property3name = "rune_e_4"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollIronTreadsOfDestruction(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_iron_treads_of_destruction", "immortal", "Iron Treads of Destruction", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "destruction"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_iron_treads_of_destruction", "#4259F4", 1, "#property_iron_treads_of_destruction_description")

    item.newItemTable.hasRunePoints = true
    local rollMax = 7 + math.ceil(maxFactor / 100)
    local luck = RandomInt(1, rollMax)
    if luck <= 3 then
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 5 + 5)
        item.newItemTable.property2 = WallPhysics:round(value, 0)
        item.newItemTable.property2name = "rune_r_1"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    elseif luck <= 6 then
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 5 + 5)
        item.newItemTable.property2 = WallPhysics:round(value, 0)
        item.newItemTable.property2name = "rune_r_2"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    elseif luck <= 9 then
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 6 + 5)
        item.newItemTable.property2 = WallPhysics:round(value, 0)
        item.newItemTable.property2name = "rune_r_3"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    else
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 24)
        item.newItemTable.property2 = math.floor(value)
        item.newItemTable.property2name = "rune_r_4"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBloodstoneBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_bloodstone_boots", "immortal", "Bloodstone Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "bloodstone"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bloodstone_boots", "#E2371D", 1, "#property_bloodstone_boots_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 220, 600, 1, 1, item.newItemTable.rarity, false, maxFactor * 400)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_health"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_health", "#B02020", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBootsOfGreatFortune(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_boots_of_great_fortune", "immortal", "Boots of Great Fortune", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "great_fortune"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_boots_of_great_fortune", "#F1F756", 1, "#property_boots_of_great_fortune_description")

    item.newItemTable.hasRunePoints = true
    item.newItemTable.property2 = RPCItems:GetLogarithmicVarianceValue(GameState:GetDifficultyFactor() * 5, 0, 0, 0, 0)
    item.newItemTable.property2name = "rune_e_4"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSandstreamSlippers(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_sandstream_slippers", "immortal", "Sandstream Slippers", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sandstream"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sandstream_slippers", "#E3DEBA", 1, "#property_sandstream_slippers_description")

    item.newItemTable.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = math.floor(value * 1.2)
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollManaStriders(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_mana_striders", "immortal", "Mana Striders", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "mana_stride"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mana_striders", "#55A4CF", 1, "#property_mana_striders_description")

    value, nameLevel = RPCItems:RollAttribute(0, 9, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 16)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollBootsOfPureWaters(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_boots_of_pure_waters", "immortal", "Boots of Pure Waters", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "pure_waters"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_pure_waters", "#2679BD", 1, "#property_pure_waters_description")

    value, nameLevel = RPCItems:RollAttribute(0, 8, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMoonTechs(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_moon_tech_runners", "immortal", "Moon Tech Runners", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "moon_tech"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_moon_techs", "#3700CF", 1, "#property_moon_techs_description")

    Elements:RollElementAttribute(item, RPC_ELEMENT_COSMOS, 2, 2, 20, 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTemporalWarpBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_temporal_warp_boots", "immortal", "Temporal Warp Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "temporal_warp"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_temporal_warp", "#A1F442", 1, "#property_temporal_warp_description")
    --print("TEMPORAL WARP BOOTS")
    local luck = RandomInt(1, 3)
    if luck == 1 then
        local evasionValue = RandomInt(12, 20)
        item.newItemTable.property2 = evasionValue
        item.newItemTable.property2name = "evasion"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_evasion", "#759C7C", 2)
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_TIME, 1.6, 2, 20, 2)
    end

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSonicBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_sonic_boots", "immortal", "Sonic Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "sonic_boot"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sonic_boots", "#AACFE6", 1, "#property_sonic_boots_description")

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFalconBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_falcon_boots", "immortal", "Falcon Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "falcon_boot"

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_falcon_boot", "#AACFE6", 1, "#property_falcon_boot_description")

    local luck = RandomInt(1, 2)
    if luck == 1 then
        item.newItemTable.property2name = "ghost_walk"
        item.newItemTable.property2 = 1
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_unit_walking", "#9B72C4", 2, "#property_unit_walking_description")
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_HOLY, 2.8, 2, 22, 2)
    end

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollCrusaderBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_crusader_boots", "immortal", "Crusader Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "crusader"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_crusader_boots", "#48B6CF", 1, "#property_crusader_boots_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 8, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "strength"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_strength", "#CC0000", 2)

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollArcanysSlipper(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_arcanys_slipper", "immortal", "Arcanys Slippers", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "arcanys"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arcanys_slipper", "#C23CCF", 1, "#property_arcanys_slipper_description")

    local luck = RandomInt(1, 3)
    if luck == 1 then
        local value, nameLevel = RPCItems:RollAttribute(0, 9, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 15)
        item.newItemTable.property2 = value
        item.newItemTable.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
    else
        Elements:RollElementAttribute(item, RPC_ELEMENT_ARCANE, 2.6, 2, 27, 2)
    end

    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollSwampWaders(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_swamp_waders", "immortal", "Swamp Waders", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()

    local moveslow = RandomInt(90, 150)
    item.newItemTable.property1 = moveslow
    item.newItemTable.property1name = "movespeed_slow"
    RPCItems:SetPropertyValues(item, -item.newItemTable.property1, "#item_movespeed_slow", "#B02020", 1)

    item.newItemTable.property2 = RandomInt(14, 20)
    item.newItemTable.property2name = "magic_resist"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_magic_resist", "#AC47DE", 2)

    local value, nameLevel = RPCItems:RollAttribute(300, 8, 12, 0, 0, item.newItemTable.rarity, false, maxFactor * 12)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_armor", "#D1D1D1", 3)

    RPCItems:RollFootProperty4(item, 0)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollAdmiralBoot(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_admiral_boots", "immortal", "Admiral's Boots", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "admiral"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_admiral_boots", "#A66829", 1, "#property_admiral_boots_description")

    item.newItemTable.hasRunePoints = true
    if maxFactor < 40 then
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 3 + 4)
        item.newItemTable.property2 = WallPhysics:round(value, 0)
        item.newItemTable.property2name = "rune_e_1"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 3 + 4)
        item.newItemTable.property3 = WallPhysics:round(value, 0)
        item.newItemTable.property3name = "rune_e_2"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    else
        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 3 + 4)
        item.newItemTable.property2 = WallPhysics:round(value, 0)
        item.newItemTable.property2name = "rune_e_2"
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

        value, nameLevel = RPCItems:RollAttribute(0, 1, 2, 0, 0, item.newItemTable.rarity, false, maxFactor / 3 + 4)
        item.newItemTable.property3 = WallPhysics:round(value, 0)
        item.newItemTable.property3name = "rune_e_3"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollRootedFeet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_rooted_feet", "immortal", "Rooted Feet", "feet", true, "Slot: Feet")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "rooted_feet"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_rooted_feet", "#ADFF5C", 1, "#property_rooted_feet_description")

    value, nameLevel = RPCItems:RollAttribute(0, 4, 8, 0, 0, item.newItemTable.rarity, false, maxFactor * 3)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "armor"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_armor", "#D1D1D1", 2)

    value, prefixLevel = RPCItems:RollAttribute(100, 5, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 6)
    item.newItemTable.property3 = value
    item.newItemTable.property3name = "health_regen"
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_health_regen", "#6AA364", 3)

    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

--TRINKETS

function RPCItems:RollWinterblightSkullRing(deathLocation)
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

function RPCItems:RollArcaneCharm(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_arcane_charm", "immortal", "Arcane Charm", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "arcane_charm"
    local value = 1
    item.newItemTable.property1 = value

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arcane_charm", "#c75ce8", 1, "#property_arcane_charm_description")
    item.newItemTable.hasRunePoints = true
    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_ARCANE, 2.4, 2, 24, 2)
    else
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property2 = math.floor(value * 1.3)
        item.newItemTable.property2name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
    end

    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_ARCANE, 2.4, 2, 24, 3)
    else
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property3 = math.floor(value * 1.3)
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local luck = RandomInt(1, 5)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_ARCANE, 3.5, 2, 35, 4)
    else
        local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
        item.newItemTable.property4 = math.floor(value * 1.8)
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollMonkeyPaw(deathLocation)
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

function RPCItems:RollFrozenHeart(deathLocation)
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

function RPCItems:RollBlacksmithsTablet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_blacksmiths_tablet", "immortal", "Blacksmith's Tablet", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "blacksmith"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blacksmiths_tablet", "#C1C7C9", 1, "#property_blacksmiths_tablet_description")

    local value = RandomInt(maxFactor * 100, maxFactor * 700)
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

function RPCItems:RollAquastoneRing(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_aquastone_ring", "immortal", "Aquastone Ring", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()
    local luck = RandomInt(3, 10)
    value = luck
    item.newItemTable.property1name = "t4_runes"
    item.newItemTable.property1 = value

    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "#item_t4_runes", "#7DFF12", 1)

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

function RPCItems:RollSapphireLotus(deathLocation)
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

function RPCItems:RollArborDragonfly(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_arbor_dragonfly", "immortal", "Arbor Dragonfly", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "arbor"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arbor_dragonfly", "#B59B77", 1, "#property_arbor_dragonfly_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 13, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
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

function RPCItems:RollGuardianStone(deathLocation)
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

function RPCItems:RollAncientTanariWaterstone(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ancient_tanari_waterstone", "immortal", "Ancient Tanari Waterstone", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "ancient_waterstone"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ancient_waterstone", "#70C6FF", 1, "#property_ancient_waterstone_description")

    local value, nameLevel = RPCItems:RollAttribute(0, 6, 11, 0, 0, item.newItemTable.rarity, false, maxFactor * 11)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local luck = RandomInt(1, 2)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_WATER, 2.7, 2, 28, 3)
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

function RPCItems:RollAuricRingOfInspiration(deathLocation, boss_level)
    local item = RPCItems:CreateVariant("item_rpc_auric_ring_of_inspiration", "immortal", "Auric Ring of Inspiration", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "auric_inspiration"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_auric_ring_of_inspiration", "#edf056", 1, "#property_auric_ring_of_inspiration_description")

    local max_attributes_roll = math.ceil(maxFactor*(math.min(boss_level/2, 16))) + 1000
    local value, nameLevel = RPCItems:RollAttribute(0, 6, 11+boss_level/2, 0, 0, item.newItemTable.rarity, false, max_attributes_roll)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local luck = RandomInt(1, 3)
    if luck == 3 then
        local value, nameLevel = RPCItems:RollAttribute(0, 6, 11, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
        item.newItemTable.property3 = value
        item.newItemTable.property3name = "all_attributes"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_all_attributes", "#FFFFFF", 3)
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

function RPCItems:RollBerylRingOfIntuition(deathLocation, boss_level)
    local item = RPCItems:CreateVariant("item_rpc_beryl_ring_of_intuition", "immortal", "Beryl Ring of Intuition", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "beryl_intuition"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_beryl_ring_of_intuition", "#5cadff", 1, "#property_beryl_ring_of_intuition_description")

    local max_attributes_roll = math.ceil(maxFactor*(math.min(boss_level/2, 16))) + 1000
    local value, nameLevel = RPCItems:RollAttribute(0, 6, 10+boss_level/2, 0, 0, item.newItemTable.rarity, false, max_attributes_roll)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)

    local luck = RandomInt(1, 3)
    if luck == 3 then
        local value, nameLevel = RPCItems:RollAttribute(0, 6, 11, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
        item.newItemTable.property3 = value
        item.newItemTable.property3name = "all_attributes"
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_all_attributes", "#FFFFFF", 3)
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

function RPCItems:RollAntiqueManaRelic(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_antique_mana_relic", "immortal", "Antique Mana Relic", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "mana_relic"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_antique_mana_relic", "#9DBCF5", 1, "#property_antique_mana_relic_description")

    local value, prefixLevel = RPCItems:RollAttribute(300, 150, 400, 0, 1, item.newItemTable.rarity, false, maxFactor * 150)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "max_mana"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_max_mana", "#343EC9", 2)

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

function RPCItems:RollFrostGem(deathLocation)
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

function RPCItems:RollTwigOfEnlightened(deathLocation)
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

function RPCItems:RollLifesourceVessel(deathLocation)
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

function RPCItems:RollTomeOfChaos(deathLocation)
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

function RPCItems:RollAerithsTear(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_aeriths_tear", "immortal", "Aerith's Tear", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "aerith"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_aeriths_tear", "#3EDAE6", 1, "#property_aeriths_tear")

    local value, nameLevel = RPCItems:RollAttribute(0, 7, 9, 0, 0, item.newItemTable.rarity, false, maxFactor * 9)
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

function RPCItems:RollTorchOfGengar(deathLocation)
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

function RPCItems:RollRuinfallSkullToken(deathLocation)
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

function RPCItems:RollRavenIdol(deathLocation)
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

function RPCItems:RollConquestStoneFalcon(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_conquest_stone_falcon", "immortal", "Conquest Stone Falcon", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "stone_falcon"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_stone_falcon", "#A5B5A9", 1, "#property_stone_falcon_description")

    local maxFactor = RPCItems:GetMaxFactor()

    local value, nameLevel = RPCItems:RollAttribute(0, 4, 10, 0, 0, item.newItemTable.rarity, false, maxFactor * 5)
    item.newItemTable.property2 = value
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

function RPCItems:RollFortunesTalismanOfTruth(deathLocation)
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

function RPCItems:RollEpsilonsEyeglass(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_epsilons_eyeglass", "immortal", "Epsilons Eyeglass", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "epsilon"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_epsilon_eyeglass", "#4A91D9", 1, "#property_epsilon_eyeglass_description")

    local maxFactor = RPCItems:GetMaxFactor()

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property2 = value
    item.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property3 = value
        item.newItemTable.property3name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
    end

    local tier, value, propertyName = RPCItems:RollSkillProperty()
    if tier > 0 then
        item.newItemTable.property4 = math.floor(value * 1.2)
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollOmegaRuby(deathLocation)
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

function RPCItems:RollFenrirFang(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_fenrirs_fang", "immortal", "Fenrir Fang", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "fenrir_fang"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fenrir_fang", "#EB7B6A", 1, "#property_fenrir_fang")

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

function RPCItems:RollPhoenixEmblem(deathLocation)
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

function RPCItems:RollHopeOfSaytaru(deathLocation)
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

function RPCItems:RollFuchsiaRing(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_fuchsia_ring", "immortal", "Fuchsia Ring", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "fuchsia"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fuchsia_ring", "#FF0080", 1, "#property_fuchsia_ring_description")

    local magicResistRoll = RandomInt(7, 16)
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
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollAnkhOfAncients(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_ankh_of_the_ancients", "immortal", "Ankh of the Ancients", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "ankh_of_ancients"
    item.newItemTable.property1 = 1
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ankh_of_ancients", "#AEF2E1", 1, "#property_ankh_of_ancients_description")

    local magicResistRoll = math.ceil(RPCItems:GetLogarithmicVarianceValue(17, 0, 0, 0, 0))
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
        item.newItemTable.property4 = value
        item.newItemTable.property4name = propertyName
        RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
    end

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollWorldTreesFlowerCache(deathLocation)
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

function RPCItems:RollGalaxyOrb(deathLocation)
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

function RPCItems:RollPuzzlersLocket(deathLocation)
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

function RPCItems:RollGalvanizedRazorBand(deathLocation)
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


function RPCItems:RollVolcanoOrb(deathLocation)
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

function RPCItems:RollFractionalEnhancementGeode(deathLocation)
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

function RPCItems:RollRingOfNobility(deathLocation)
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
    -- local primaryAttribute = hero:GetPrimaryAttribute()
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

function RPCItems:RollAzureEmpire(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_azure_empire", "immortal", "Pendant of the Azure Empire", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "azure_empire"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire", "#7AD2F0", 1, "#property_azure_empire_description")

    local luck = RandomInt(1, 4)
    if luck == 1 then
        item.newItemTable.property2 = 0
        item.newItemTable.property2name = "azure_silver"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_silver", "#C9E6ED", 2, "#property_azure_empire_silver_description")
    elseif luck == 2 then
        item.newItemTable.property2 = 0
        item.newItemTable.property2name = "azure_green"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_green", "#67EA64", 2, "#property_azure_empire_green_description")
    elseif luck == 3 then
        item.newItemTable.property2 = 0
        item.newItemTable.property2name = "azure_blue"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_blue", "#74A0ED", 2, "#property_azure_empire_blue_description")
    elseif luck == 4 then
        item.newItemTable.property2 = 0
        item.newItemTable.property2name = "azure_red"
        RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_azure_empire_red", "#E03018", 2, "#property_azure_empire_red_description")
    end

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property3 = math.ceil(value * 1.4)
    item.newItemTable.property3name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    item.newItemTable.property4 = math.ceil(value * 1.4)
    item.newItemTable.property4name = propertyName
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollTempestFalconRing(deathLocation)
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

function RPCItems:RollFirelockPendant(deathLocation)
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

function RPCItems:RollEmeraldNullificationRing(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_emerald_nullification_ring", "immortal", "Emerald Nullification Ring", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "emerald_null"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_emerald_null", "#38D667", 1, "#property_emerald_null_description")

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

function RPCItems:RollGarnetWarfareRing(deathLocation)
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

function RPCItems:RollRedDivinexAmulet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_red_divinex_amulet", "immortal", "Red Divinex Amulet", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "red_divinex"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_red_divinex", "#D62447", 1, "#property_red_divinex_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
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

function RPCItems:RollGreenDivinexAmulet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_green_divinex_amulet", "immortal", "Green Divinex Amulet", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "green_divinex"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_green_divinex", "#4CDB64", 1, "#property_green_divinex_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
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

function RPCItems:RollBlueDivinexAmulet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_blue_divinex_amulet", "immortal", "Blue Divinex Amulet", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "blue_divinex"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_blue_divinex", "#3857F4", 1, "#property_blue_divinex_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 13)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

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

function RPCItems:RollCobaltSerenityRing(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_cobalt_serenity_ring", "immortal", "Cobalt Serenity Ring", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "cobalt_serenity"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_cobalt_serenity", "#4FADE8", 1, "#property_cobalt_serenity_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

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

function RPCItems:RollWindOrchid(deathLocation)
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

function RPCItems:RollFireBlossom(deathLocation)
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

function RPCItems:RollAquaLily(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_aqua_lily", "immortal", "Aqua Lily", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.property1name = "aqua_lily"
    item.newItemTable.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_aqua_lily", "#4FADE8", 1, "#property_aqua_lily_description")

    value, nameLevel = RPCItems:RollAttribute(0, 6, 15, 0, 0, item.newItemTable.rarity, false, maxFactor * 14)
    item.newItemTable.property2 = value
    item.newItemTable.property2name = "intelligence"
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)

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

function RPCItems:RollSignusCharm(deathLocation)
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

function RPCItems:RollEyeOfAvernus(deathLocation)
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

function RPCItems:RollChampionsGearHelm(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_helm_of_champions", "immortal", "champions_gear", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true

    local runeName = "rune_r_4"
    local runeValue = RPCItems:GetLogarithmicVarianceValue(20, 0, 0, 0, 0)
    item.newItemTable.property1name = runeName
    item.newItemTable.property1 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)

    RPCItems:RollHoodProperty2(item, 0)
    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    --print(item:GetEntityIndex())
    --print(item:GetContainer():GetAbsOrigin())
    return item
end

function RPCItems:RollSpellfireGloves(deathLocation, spiritRealm)
    local item = RPCItems:CreateVariant("item_rpc_spellfire_gloves", "immortal", "Spellfire Gloves", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "spellfire"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spellfire", "#FFA62B", 1, "#property_spellfire_description")

    item.newItemTable.hasRunePoints = true

    local tier = 3
    if GameState:GetDifficultyFactor() > 1 then
        local luck = RandomInt(1, 5 - GameState:GetDifficultyFactor())
        if luck == 1 then
            tier = 4
        end
    end
    local letters = {'q','w','e','r'}
    local letter = letters[RandomInt(1,4)]
    local runeName = 'rune_' .. letter .. '_' .. tier
    local bonus = 0
    if spiritRealm then
        bonus = 8
    end
    if tier == 3 then
        bonus = bonus + 8
    end
    local runeValue = RPCItems:GetLogarithmicVarianceValue(14 + bonus, 0, 0, 0, 0)
    item.newItemTable.property2name = runeName
    item.newItemTable.property2 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHoodOfLords(deathLocation, spiritRealm)
    local item = RPCItems:CreateVariant("item_rpc_hood_of_lords", "immortal", "Hood of Lords", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "lords"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_lords", "#FEFFC6", 1, "#property_lords_description")

    item.newItemTable.hasRunePoints = true

    local runeName = "rune_"..RPCItems:GetRandomRuneLetter(1, 4) .. "_3"
    if GameState:GetDifficultyFactor() > 1 then
        local luck = RandomInt(1, 5 - GameState:GetDifficultyFactor())
        if luck == 1 then
            runeName = "rune_"..RPCItems:GetRandomRuneLetter(1, 4) .. "_4"
        end
    end
    local bonus = 0
    if spiritRealm then
        bonus = 9
    end
    local runeValue = RPCItems:GetLogarithmicVarianceValue(15 + bonus, 0, 0, 0, 0)
    item.newItemTable.property2name = runeName
    item.newItemTable.property2 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollWindDeityCrown(deathLocation, isSpirit, paragonBonus)
    local item = RPCItems:CreateVariant("item_rpc_wind_deity_crown", "immortal", "Wind Deity Crown", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "wind_deity"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_wind_deity", "#92E8A6", 1, "#property_wind_deity_description")

    item.newItemTable.hasRunePoints = true
    if not paragonBonus then
        paragonBonus = 0
    end
    local runeName = "rune_e_3"
    local runeValue = 0
    if isSpirit then
        runeValue = RPCItems:GetLogarithmicVarianceValue(45 + (paragonBonus * 2), 0, 0, 0, 0)
    else
        runeValue = RPCItems:GetLogarithmicVarianceValue(25 + (paragonBonus * 2), 0, 0, 0, 0)
    end
    local luck = RandomInt(1, 3)
    if luck == 3 then
        runeName = "rune_e_4"
        if isSpirit then
            runeValue = RPCItems:GetLogarithmicVarianceValue(20 + paragonBonus, 0, 0, 0, 0)
        else
            runeValue = RPCItems:GetLogarithmicVarianceValue(13 + paragonBonus, 0, 0, 0, 0)
        end
    end
    item.newItemTable.property2name = runeName
    item.newItemTable.property2 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local luck = RandomInt(1, 3)
    if luck == 1 then
        Elements:RollElementAttribute(item, RPC_ELEMENT_WIND, 3, 1, 35, 3)
    else
        RPCItems:RollHoodProperty3(item, 0)
    end
    RPCItems:RollHoodProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollWaterDeityCrown(deathLocation, isSpirit, paragonBonus)
    local item = RPCItems:CreateVariant("item_rpc_water_deity_crown", "immortal", "Water Deity Crown", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "water_deity"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_water_deity", "#5D9AF0", 1, "#property_water_deity_description")

    item.newItemTable.hasRunePoints = true
    if not paragonBonus then
        paragonBonus = 0
    end
    local runeName = "rune_r_3"
    local runeValue = 0
    if isSpirit then
        runeValue = RPCItems:GetLogarithmicVarianceValue(45 + (paragonBonus * 2), 0, 0, 0, 0)
    else
        runeValue = RPCItems:GetLogarithmicVarianceValue(25 + (paragonBonus * 2), 0, 0, 0, 0)
    end
    local luck = RandomInt(1, 3)
    if luck == 3 then
        runeName = "rune_r_4"
        if isSpirit then
            runeValue = RPCItems:GetLogarithmicVarianceValue(20 + paragonBonus, 0, 0, 0, 0)
        else
            runeValue = RPCItems:GetLogarithmicVarianceValue(13 + paragonBonus, 0, 0, 0, 0)
        end
    end
    item.newItemTable.property2name = runeName
    item.newItemTable.property2 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollFireDeityCrown(deathLocation, isSpirit, paragonBonus)
    local item = RPCItems:CreateVariant("item_rpc_fire_deity_crown", "immortal", "Fire Deity Crown", "head", true, "Slot: Head")
    local maxFactor = RPCItems:GetMaxFactor()
    item.newItemTable.property1 = 1
    item.newItemTable.property1name = "fire_deity"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_fire_deity", "#E85A4A", 1, "#property_fire_deity_description")

    item.newItemTable.hasRunePoints = true
    if not paragonBonus then
        paragonBonus = 0
    end
    local runeName = "rune_w_3"
    local runeValue = 0
    if isSpirit then
        runeValue = RPCItems:GetLogarithmicVarianceValue(45 + (paragonBonus * 2), 0, 0, 0, 0)
    else
        runeValue = RPCItems:GetLogarithmicVarianceValue(25 + (paragonBonus * 2), 0, 0, 0, 0)
    end
    local luck = RandomInt(1, 3)
    if luck == 3 then
        runeName = "rune_w_4"
        if isSpirit then
            runeValue = RPCItems:GetLogarithmicVarianceValue(20 + paragonBonus, 0, 0, 0, 0)
        else
            runeValue = RPCItems:GetLogarithmicVarianceValue(13 + paragonBonus, 0, 0, 0, 0)
        end
    end
    item.newItemTable.property2name = runeName
    item.newItemTable.property2 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    RPCItems:RollHoodProperty3(item, 0)
    RPCItems:RollHoodProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollChampionsGearGauntlet(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_gauntlet_of_champions", "immortal", "champions_gear", "hands", true, "Slot: Hands")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true

    local runeName = "rune_w_4"
    local runeValue = RPCItems:GetLogarithmicVarianceValue(20, 0, 0, 0, 0)
    item.newItemTable.property1name = runeName
    item.newItemTable.property1 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)

    RPCItems:RollHandProperty2(item, 0)
    RPCItems:RollHandProperty3(item, 0)
    RPCItems:RollHandProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollChampionsGearMail(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_champions_mail", "immortal", "champions_gear", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true

    local runeName = "rune_q_4"
    local runeValue = RPCItems:GetLogarithmicVarianceValue(20, 0, 0, 0, 0)
    item.newItemTable.property1name = runeName
    item.newItemTable.property1 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)

    RPCItems:RollBodyProperty2(item, 0)
    RPCItems:RollBodyProperty3(item, 0)
    RPCItems:RollBodyProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollChampionsGearBoots(deathLocation)
    local item = RPCItems:CreateVariant("item_rpc_boots_of_champions", "immortal", "champions_gear", "feet", true, "Slot: Boots")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true

    local runeName = "rune_e_4"
    local runeValue = RPCItems:GetLogarithmicVarianceValue(20, 0, 0, 0, 0)
    item.newItemTable.property1name = runeName
    item.newItemTable.property1 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)

    RPCItems:RollFootProperty2(item, 0)
    RPCItems:RollFootProperty3(item, 0)
    RPCItems:RollFootProperty4(item, 0)
    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollHeroicConquerorVestments(deathLocation, pitLevel)
    local item = RPCItems:CreateVariant("item_rpc_heroic_conqueror_vestments", "immortal", "heroic conqueror", "body", true, "Slot: Body")
    local maxFactor = RPCItems:GetMaxFactor()

    item.newItemTable.hasRunePoints = true

    local runeName = "rune_q_4"
    local runeValue = RPCItems:GetLogarithmicVarianceValue(11 + pitLevel, 0, 0, 0, 0)
    item.newItemTable.property1name = runeName
    item.newItemTable.property1 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)

    local runeName = "rune_w_4"
    local runeValue = RPCItems:GetLogarithmicVarianceValue(11 + pitLevel, 0, 0, 0, 0)
    item.newItemTable.property2name = runeName
    item.newItemTable.property2 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)

    local runeName = "rune_e_4"
    local runeValue = RPCItems:GetLogarithmicVarianceValue(11 + pitLevel, 0, 0, 0, 0)
    item.newItemTable.property3name = runeName
    item.newItemTable.property3 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)

    local runeName = "rune_r_4"
    local runeValue = RPCItems:GetLogarithmicVarianceValue(11 + pitLevel, 0, 0, 0, 0)
    item.newItemTable.property4name = runeName
    item.newItemTable.property4 = runeValue
    RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)

    local drop = CreateItemOnPositionSync(deathLocation, item)
    local position = deathLocation
    RPCItems:DropItem(item, position)
    return item
end

function RPCItems:RollImmortalByName(itemName, position)
    local deathLocation = position
    local newItem = nil
    --print(immortalName)
    if _G[itemName] then
        newItem = _G[itemName]:Create(position)
    elseif itemName == "item_rpc_magebane_gloves" then
        newItem = RPCItems:RollMageBaneGloves(deathLocation)
    elseif itemName == "item_rpc_berserker_gloves" then
        newItem = RPCItems:RollBerserkerGloves(deathLocation)
    elseif itemName == "item_rpc_shadow_armlet" then
        newItem = RPCItems:RollShadowArmlet(deathLocation)
    elseif itemName == "item_rpc_boneguard_gauntlets" then
        newItem = RPCItems:RollBoneguardGauntlets(deathLocation)
    elseif itemName == "item_rpc_scorched_gauntlets" then
        newItem = RPCItems:RollScorchedGauntlets(deathLocation)
    elseif itemName == "item_rpc_hand_of_midas" then
        newItem = RPCItems:RollHandOfMidas(deathLocation)
    elseif itemName == "item_rpc_kappa_pride_gloves" then
        newItem = RPCItems:RollProudGloves(deathLocation)
    elseif itemName == "item_rpc_claw_of_azinoth" then
        newItem = RPCItems:RollClawOfAzinoth(deathLocation)
    elseif itemName == "item_rpc_gauntlet_of_divine_purity" then
        newItem = RPCItems:RollDivinePurityGauntlets(deathLocation)
    elseif itemName == "item_rpc_marauder_gloves" then
        newItem = RPCItems:RollMarauderGloves(deathLocation)
    elseif itemName == "item_rpc_grasp_of_elder" then
        newItem = RPCItems:RollElderGrasp(deathLocation)
    elseif itemName == "item_rpc_scarecrow_gloves" then
        newItem = RPCItems:RollScarecrowGloves(deathLocation)
    elseif itemName == "item_rpc_living_gauntlet" then
        newItem = RPCItems:RollLivingGauntlet(deathLocation)
    elseif itemName == "item_rpc_silverspring_gloves" then
        newItem = RPCItems:RollSilverspringGloves(deathLocation)
    elseif itemName == "item_rpc_mordiggus_gauntlet" then
        newItem = RPCItems:RollMordiggusGauntlet(deathLocation)
    elseif itemName == "item_rpc_ironbound_gloves" then
        newItem = RPCItems:RollIronboundGloves(deathLocation)
    elseif itemName == "item_rpc_far_seers_enchanted_gloves" then
        newItem = RPCItems:RollFarSeersEnchantedGloves(deathLocation)
    elseif itemName == "item_rpc_master_gloves" then
        newItem = RPCItems:RollMasterGloves(deathLocation)
    elseif itemName == "item_rpc_phoenix_gloves" then
        newItem = RPCItems:RollPhoenixGloves(deathLocation)
    elseif itemName == "item_rpc_eternal_essence_gauntlet" then
        newItem = RPCItems:RollEternalEssenceGauntlet(deathLocation)
    elseif itemName == "item_rpc_spirit_glove" then
        newItem = RPCItems:RollSpiritGlove(deathLocation)
    elseif itemName == "item_rpc_frostburn_gauntlets" then
        newItem = RPCItems:RollFrostburnGauntlets(deathLocation)
    elseif itemName == "item_rpc_mountain_vambraces" then
        newItem = RPCItems:RollMountainVambraces(deathLocation)
    elseif itemName == "item_rpc_grand_arcanist_wraps" then
        newItem = RPCItems:RollGrandArcanist(deathLocation)
    elseif itemName == "item_rpc_bladeforge_gauntlet" then
        newItem = RPCItems:RollBladeforgeGauntlet(deathLocation)
    elseif itemName == "item_rpc_royal_wristguards" then
        newItem = RPCItems:RollRoyalWristguards(deathLocation)
    elseif itemName == "item_rpc_cytopian_laser_glove" then
        newItem = RPCItems:RollCytopianLaserGloves(deathLocation)
    elseif itemName == "item_rpc_stormcloth_bracer" then
        newItem = RPCItems:RollStormclothBracer(deathLocation)
    elseif itemName == "item_rpc_power_ranger_gloves" then
        newItem = RPCItems:RollPowerRangerGloves(deathLocation)
    elseif itemName == "item_rpc_hurricane_vest" then
        newItem = RPCItems:RollHurricaneVest(deathLocation)
    elseif itemName == "item_rpc_robe_of_flooding" then
        newItem = RPCItems:RollFloodRobe(deathLocation)
    elseif itemName == "item_rpc_avalanche_plate" then
        newItem = RPCItems:RollAvalanchePlate(deathLocation)
    elseif itemName == "item_rpc_armor_of_violet_guard" then
        newItem = RPCItems:RollVioletGuardArmor(deathLocation)
    elseif itemName == "item_rpc_twilight_vestments" then
        newItem = RPCItems:RollTwilightVestments(deathLocation)
    elseif itemName == "item_rpc_radiant_ruins_leather" then
        newItem = RPCItems:RollRadiantRuinsLeather(deathLocation)
    elseif itemName == "item_rpc_bladestorm_vest" then
        newItem = RPCItems:RollBladestormVest(deathLocation)
    elseif itemName == "item_rpc_hermits_spike_shell" then
        newItem = RPCItems:RollHermitSpikeShell(deathLocation)
    elseif itemName == "item_rpc_seraphic_soulvest" then
        newItem = RPCItems:RollSoulVest(deathLocation)
    elseif itemName == "item_rpc_infused_mageplate" then
        newItem = RPCItems:RollMageplate(deathLocation)
    elseif itemName == "item_rpc_plate_of_the_watcher" then
        newItem = RPCItems:RollWatcherPlate(deathLocation)
    elseif itemName == "item_rpc_sorcerers_regalia" then
        newItem = RPCItems:RollSorcererRegalia(deathLocation)
    elseif itemName == "item_rpc_spellslinger_coat" then
        newItem = RPCItems:RollSpellslingerCoat(deathLocation)
    elseif itemName == "item_rpc_doomplate" then
        newItem = RPCItems:RollDoomplate(deathLocation)
    elseif itemName == "item_rpc_ocean_tempest_pallium" then
        newItem = RPCItems:RollOceanTempestPallium(deathLocation)
    elseif itemName == "item_rpc_savage_plate_of_ogthun" then
        newItem = RPCItems:RollSavagePlateOfOgthun(deathLocation)
    elseif itemName == "item_rpc_ice_quill_carapace" then
        newItem = RPCItems:RollIceQuillCarapace(deathLocation)
    elseif itemName == "item_rpc_featherwhite_armor" then
        newItem = RPCItems:RollFeatherwhiteArmor(deathLocation)
    elseif itemName == "item_rpc_dragon_ceremony_vestments" then
        newItem = RPCItems:RollDragonCeremonyVestments(deathLocation)
    elseif itemName == "item_rpc_armor_of_secret_temple" then
        newItem = RPCItems:RollSecretTempleArmor(deathLocation)
    elseif itemName == "item_rpc_vampiric_breastplate" then
        newItem = RPCItems:RollVampiricBreastplate(deathLocation)
    elseif itemName == "item_rpc_skyforge_flurry_plate" then
        newItem = RPCItems:RollSkyforgeFlurryPlate(deathLocation)
    elseif itemName == "item_rpc_dark_arts_vestments" then
        newItem = RPCItems:RollDarkArtsVestments(deathLocation)
    elseif itemName == "item_rpc_legion_vestments" then
        newItem = RPCItems:RollLegionVestments(deathLocation)
    elseif itemName == "item_rpc_nightmare_rider_mantle" then
        newItem = RPCItems:RollNightmareRiderMantle(deathLocation)
    elseif itemName == "item_rpc_space_tech_vest" then
        newItem = RPCItems:RollSpaceTechVest(deathLocation)
    elseif itemName == "item_rpc_stormshield_cloak" then
        newItem = RPCItems:RollStormshieldCloak(deathLocation)
    elseif itemName == "item_rpc_the_infernal_prison" then
        newItem = RPCItems:RollInfernalPrison(deathLocation)
    elseif itemName == "item_rpc_enchanted_solar_cape" then
        newItem = RPCItems:RollEnchantedSolarCape(deathLocation)
    elseif itemName == "item_rpc_gilded_soul_cage" then
        newItem = RPCItems:RollGildedSoulCage(deathLocation)
    elseif itemName == "item_rpc_bluestar_armor" then
        newItem = RPCItems:RollBluestarArmor(deathLocation)
    elseif itemName == "item_rpc_windsteel_armor" then
        newItem = RPCItems:RollWindsteelArmor(deathLocation)
    elseif itemName == "item_rpc_white_mage_hat" then
        newItem = RPCItems:RollWhiteMageHat(deathLocation, isShop)
    elseif itemName == "item_rpc_hyper_visor" then
        newItem = RPCItems:RollHyperVisor(deathLocation, isShop)
    elseif itemName == "item_rpc_crown_of_ruby_dragon" then
        newItem = RPCItems:RollRubyDragonCrown(deathLocation, isShop)
    elseif itemName == "item_rpc_centaur_horns" then
        newItem = RPCItems:RollCentaurHorns(deathLocation, isShop)
    elseif itemName == "item_rpc_hood_of_chosen" then
        newItem = RPCItems:RollHoodOfChosen(deathLocation, isShop)
    elseif itemName == "item_rpc_death_whisper_helm" then
        newItem = RPCItems:RollDeathWhisperHelm(deathLocation, isShop)
    elseif itemName == "item_rpc_guard_of_grithault" then
        newItem = RPCItems:RollGuardOfGrithault(deathLocation, isShop)
    elseif itemName == "item_rpc_cap_of_wild_nature" then
        newItem = RPCItems:RollCapOfWildNature(deathLocation, isShop)
    elseif itemName == "item_rpc_guard_of_luma" then
        newItem = RPCItems:RollLumaGuard(deathLocation, isShop)
    elseif itemName == "item_rpc_brazen_kabuto_of_the_desert_realm" then
        newItem = RPCItems:RollBrazenKabuto(deathLocation, isShop)
    elseif itemName == "item_rpc_odin_helmet" then
        newItem = RPCItems:RollOdinHelmet(deathLocation, isShop)
    elseif itemName == "item_rpc_wraith_crown" then
        newItem = RPCItems:RollWraithCrown(deathLocation, isShop)
    elseif itemName == "item_rpc_iron_colussus" then
        newItem = RPCItems:RollIronColossus(deathLocation, isShop)
    elseif itemName == "item_rpc_mask_of_mugato" then
        newItem = RPCItems:RollMugatoMask(deathLocation, isShop)
    elseif itemName == "item_rpc_swamp_witch_hat" then
        newItem = RPCItems:RollWitchHat(deathLocation, isShop)
    elseif itemName == "item_rpc_tricksters_mask" then
        newItem = RPCItems:RollTricksterMask(deathLocation, isShop)
    elseif itemName == "item_rpc_demon_mask" then
        newItem = RPCItems:RollDemonMask(deathLocation, isShop, 0)
    elseif itemName == "item_rpc_crest_of_the_umbral_sentinel" then
        newItem = RPCItems:RollCrestOfTheUmbralSentinel(deathLocation, isShop)
    elseif itemName == "item_rpc_carbuncles_helm_of_reflection" then
        newItem = RPCItems:RollCarbuncleHelm(deathLocation, isShop)
    elseif itemName == "item_rpc_wraith_hunters_steel_helm" then
        newItem = RPCItems:RollWraithHuntersSteelHelm(deathLocation, isShop)
    elseif itemName == "item_rpc_emerald_douli" then
        newItem = RPCItems:RollEmeraldDouli(deathLocation, isShop)
    elseif itemName == "item_rpc_mask_of_tyrius" then
        newItem = RPCItems:RollMaskOfTyrius(deathLocation, isShop)
    elseif itemName == "item_rpc_veil_of_the_cerulean_high_guard" then
        newItem = RPCItems:RollCeruleanHighguard(deathLocation, isShop)
    elseif itemName == "item_rpc_blackfeather_crown" then
        newItem = RPCItems:RollBlackfeatherCrown(deathLocation, isShop)
    elseif itemName == "item_rpc_super_ascendency_mask" then
        newItem = RPCItems:RollSuperAscendency(deathLocation, isShop)
    elseif itemName == "item_rpc_mask_of_the_phantom_sorcerer" then
        newItem = RPCItems:RollPhantomSorcererMask(deathLocation, isShop)
    elseif itemName == "item_rpc_arcane_cascade_hat" then
        newItem = RPCItems:RollArcaneCascadeHat(deathLocation, isShop)
    elseif itemName == "item_rpc_adamantine_samurai_helmet" then
        newItem = RPCItems:RollSamuraiHelmet(deathLocation, isShop)
    elseif itemName == "item_rpc_scourge_knights_helm" then
        newItem = RPCItems:RollScourgeKnightHelm(deathLocation, isShop)
    elseif itemName == "item_rpc_mask_of_the_desert_necromancer" then
        newItem = RPCItems:RollNecromancerMask(deathLocation, isShop)
    elseif itemName == "item_rpc_undertakers_hood" then
        newItem = RPCItems:RollUndertakersHood(deathLocation, isShop)
    elseif itemName == "item_rpc_shroud_of_eternal_night" then
        newItem = RPCItems:RollEternalNightShroud(deathLocation, isShop)
    elseif itemName == "item_rpc_wolfir_druids_spirit_helm" then
        newItem = RPCItems:RollDruidsSpiritHelm(deathLocation, isShop)
    elseif itemName == "item_rpc_blinded_glint_of_onu" then
        newItem = RPCItems:RollGlintOfOnu(deathLocation, isShop)
    elseif itemName == "item_rpc_crown_of_the_roknar_emperor" then
        newItem = RPCItems:RollRoknarEmperor(deathLocation, isShop)
    elseif itemName == "item_rpc_swamp_doctors_tribal_mask" then
        newItem = RPCItems:RollSwampDoctorMask(deathLocation, isShop)
    elseif itemName == "item_rpc_dunetread_boots" then
        newItem = RPCItems:RollDunetreadBoots(deathLocation)
    elseif itemName == "item_rpc_voyager_boots" then
        newItem = RPCItems:RollVoyagerBoots(deathLocation)
    elseif itemName == "item_rpc_redrock_footwear" then
        newItem = RPCItems:RollRedrockFootwear(deathLocation)
    elseif itemName == "item_rpc_pathfinders_resonant_boots" then
        newItem = RPCItems:RollResonantPathfinderBoots(deathLocation)
    elseif itemName == "item_rpc_neptunes_water_gliders" then
        newItem = RPCItems:RollNeptunesWaterGliders(deathLocation)
    elseif itemName == "item_rpc_boots_of_the_violet_guard" then
        newItem = RPCItems:RollVioletTreads(deathLocation)
    elseif itemName == "item_rpc_slinger_boots" then
        newItem = RPCItems:SlingerBoots(deathLocation)
    elseif itemName == "item_rpc_guardian_greaves" then
        newItem = RPCItems:RollGuardianGreaves(deathLocation)
    elseif itemName == "item_rpc_blue_dragon_greaves" then
        newItem = RPCItems:RollBlueDragonGreaves(deathLocation)
    elseif itemName == "item_rpc_sange_boots" then
        newItem = RPCItems:RollSangeBoots(deathLocation)
    elseif itemName == "item_rpc_boots_of_old_wisdom" then
        newItem = RPCItems:RollBootsOfOldWisdom(deathLocation)
    elseif itemName == "item_rpc_resplendent_rubber_boots" then
        newItem = RPCItems:RollResplendantRubberBoots(deathLocation)
    elseif itemName == "item_rpc_ghost_slippers" then
        newItem = RPCItems:RollGhostSlippers(deathLocation)
    elseif itemName == "item_rpc_yasha_boots" then
        newItem = RPCItems:RollYashaBoots(deathLocation)
    elseif itemName == "item_rpc_tranquil_boots" then
        newItem = RPCItems:RollTranquilBoots(deathLocation)
    elseif itemName == "item_rpc_fire_walkers" then
        newItem = RPCItems:RollFireWalkers(deathLocation)
    elseif itemName == "item_rpc_mana_striders" then
        newItem = RPCItems:RollManaStriders(deathLocation)
    elseif itemName == "item_rpc_moon_tech_runners" then
        newItem = RPCItems:RollMoonTechs(deathLocation)
    elseif itemName == "item_rpc_sonic_boots" then
        newItem = RPCItems:RollSonicBoots(deathLocation)
    elseif itemName == "item_rpc_falcon_boots" then
        newItem = RPCItems:RollFalconBoots(deathLocation)
    elseif itemName == "item_rpc_crusader_boots" then
        newItem = RPCItems:RollCrusaderBoots(deathLocation)
    elseif itemName == "item_rpc_arcanys_slipper" then
        newItem = RPCItems:RollArcanysSlipper(deathLocation)
    elseif itemName == "item_rpc_swamp_waders" then
        newItem = RPCItems:RollSwampWaders(deathLocation)
    elseif itemName == "item_rpc_admiral_boots" then
        newItem = RPCItems:RollAdmiralBoot(deathLocation)
    elseif itemName == "item_rpc_rooted_feet" then
        newItem = RPCItems:RollRootedFeet(deathLocation)
    elseif itemName == "item_rpc_blacksmiths_tablet" then
        newItem = RPCItems:RollBlacksmithsTablet(deathLocation)
    elseif itemName == "item_rpc_stone_of_gordon" then
        newItem = RPCItems:RollStoneOfGordon(deathLocation, 6)
    elseif itemName == "item_rpc_sapphire_lotus" then
        newItem = RPCItems:RollSapphireLotus(deathLocation)
    elseif itemName == "item_rpc_arbor_dragonfly" then
        newItem = RPCItems:RollArborDragonfly(deathLocation)
    elseif itemName == "item_rpc_gem_of_eternal_frost" then
        newItem = RPCItems:RollFrostGem(deathLocation)
    elseif itemName == "item_rpc_lifesource_vessel" then
        newItem = RPCItems:RollLifesourceVessel(deathLocation)
    elseif itemName == "item_rpc_tome_of_chaos" then
        newItem = RPCItems:RollTomeOfChaos(deathLocation)
    elseif itemName == "item_rpc_aeriths_tear" then
        newItem = RPCItems:RollAerithsTear(deathLocation)
    elseif itemName == "item_rpc_torch_of_gengar" then
        newItem = RPCItems:RollTorchOfGengar(deathLocation)
    elseif itemName == "item_rpc_ruinfall_skull_token" then
        newItem = RPCItems:RollRuinfallSkullToken(deathLocation)
    elseif itemName == "item_rpc_raven_idol" then
        newItem = RPCItems:RollRavenIdol(deathLocation)
    elseif itemName == "item_rpc_omega_ruby" then
        newItem = RPCItems:RollOmegaRuby(deathLocation)
    elseif itemName == "item_rpc_phoenix_emblem" then
        newItem = RPCItems:RollPhoenixEmblem(deathLocation)
    elseif itemName == "item_rpc_hope_of_saytaru" then
        newItem = RPCItems:RollHopeOfSaytaru(deathLocation)
    elseif itemName == "item_rpc_galaxy_orb" then
        newItem = RPCItems:RollGalaxyOrb(deathLocation)
    elseif itemName == "item_rpc_volcano_orb" then
        newItem = RPCItems:RollVolcanoOrb(deathLocation)
    elseif itemName == "item_rpc_fractional_enhancement_geode" then
        newItem = RPCItems:RollFractionalEnhancementGeode(deathLocation)
    elseif itemName == "item_rpc_ring_of_nobility" then
        newItem = RPCItems:RollRingOfNobility(deathLocation)
    elseif itemName == "item_rpc_azure_empire" then
        newItem = RPCItems:RollAzureEmpire(deathLocation)
    elseif itemName == "item_rpc_signus_charm" then
        newItem = RPCItems:RollSignusCharm(deathLocation)
    elseif itemName == "item_rpc_eye_of_avernus" then
        newItem = RPCItems:RollEyeOfAvernus(deathLocation)
    elseif itemName == "item_rpc_twig_of_the_enlightened" then
        newItem = RPCItems:RollTwigOfEnlightened(deathLocation)
    elseif itemName == "item_rpc_boots_of_pure_waters" then
        newItem = RPCItems:RollBootsOfPureWaters(deathLocation)
    elseif itemName == "item_rpc_gloves_of_sweeping_wind" then
        newItem = RPCItems:RollGlovesOfSweepingWind(deathLocation)
    elseif itemName == "item_rpc_depth_crest_armor" then
        newItem = RPCItems:RollDepthCrestArmor(deathLocation)
    elseif itemName == "item_rpc_terrasic_stone_plate" then
        newItem = RPCItems:RollTerrasicStonePlate(deathLocation)
    elseif itemName == "item_rpc_crown_of_the_lava_forge" then
        newItem = RPCItems:RollLavaForgeCrown(deathLocation, isShop)
    elseif itemName == "item_rpc_ancient_tanari_waterstone" then
        newItem = RPCItems:RollAncientTanariWaterstone(deathLocation)
    elseif itemName == "item_rpc_tempest_falcon_ring" then
        newItem = RPCItems:RollTempestFalconRing(deathLocation)
    elseif itemName == "item_rpc_firelock_pendant" then
        newItem = RPCItems:RollFirelockPendant(deathLocation)
    elseif itemName == "item_rpc_water_mage_robes" then
        newItem = RPCItems:RollWaterMageRobes(deathLocation)
    elseif itemName == "item_rpc_halcyon_soul_glove" then
        newItem = RPCItems:RollHalcyonSoulGlove(deathLocation)
    elseif itemName == "item_rpc_golden_war_plate" then
        newItem = RPCItems:RollGoldenWarPlate(deathLocation)
    elseif itemName == "item_rpc_hood_of_defiler" then
        newItem = RPCItems:RollHoodOfDefiler(deathLocation, isShop)
    elseif itemName == "item_rpc_excavators_focus_cap" then
        newItem = RPCItems:RollExcavatorsFocusHat(deathLocation, isShop)
    elseif itemName == "item_rpc_terrasic_lava_boots" then
        newItem = RPCItems:RollTerrasicLavaBoots(deathLocation)
    elseif itemName == "item_rpc_helm_of_champions" then
        newItem = RPCItems:RollChampionsGearHelm(deathLocation)
    elseif itemName == "item_rpc_gauntlet_of_champions" then
        newItem = RPCItems:RollChampionsGearGauntlet(deathLocation)
    elseif itemName == "item_rpc_champions_mail" then
        newItem = RPCItems:RollChampionsGearMail(deathLocation)
    elseif itemName == "item_rpc_boots_of_champions" then
        newItem = RPCItems:RollChampionsGearBoots(deathLocation)
    elseif itemName == "item_rpc_greensand_copper_gauntlets" then
        newItem = RPCItems:RollGreensandCopperGauntlets(deathLocation)
    elseif itemName == "item_rpc_gold_plate_of_leon" then
        newItem = RPCItems:RollGoldPlateOfLeon(deathLocation)
    elseif itemName == "item_rpc_staggering_knight_crusher_armor" then
        newItem = RPCItems:RollKnightCrusherArmor(deathLocation)
    elseif itemName == "item_rpc_stormcrack_helm" then
        newItem = RPCItems:RollStormcrackHelm(deathLocation, isShop)
    elseif itemName == "item_rpc_antique_mana_relic" then
        newItem = RPCItems:RollAntiqueManaRelic(deathLocation)
    elseif itemName == "item_rpc_ablecore_greaves" then
        newItem = RPCItems:RollAblecoreGreaves(deathLocation)
    elseif itemName == "item_rpc_glove_of_the_forgotten_ghost" then
        newItem = RPCItems:RollGloveOfTheForgottenGhost(deathLocation)
    elseif itemName == "item_rpc_sapphire_dragon_scale_armor" then
        newItem = RPCItems:RollSapphireDragonScaleArmor(deathLocation)
    elseif itemName == "item_rpc_topaz_dragon_scale_armor" then
        newItem = RPCItems:RollTopazDragonScaleArmor(deathLocation)
    elseif itemName == "item_rpc_ruby_dragon_scale_armor" then
        newItem = RPCItems:RollRubyDragonScaleArmor(deathLocation)
    elseif itemName == "item_rpc_basilisk_plague_helm" then
        newItem = RPCItems:RollBasiliskPlagueHelm(deathLocation, isShop)
    elseif itemName == "item_rpc_giant_hunters_boots_of_resilience" then
        newItem = RPCItems:RollGiantHunterBoots(deathLocation)
    elseif itemName == "item_rpc_spiritual_empowerment_glove" then
        newItem = RPCItems:RollSpiritualEmpowermentGlove(deathLocation)
    elseif itemName == "item_rpc_hood_of_the_black_mage" then
        newItem = RPCItems:RollHoodOfBlackMage(deathLocation, isShop)
    elseif itemName == "item_rpc_sacred_trials_armor" then
        newItem = RPCItems:RollSacredTrialsArmor(deathLocation)
    elseif itemName == "item_rpc_gravekeepers_gauntlet" then
        newItem = RPCItems:RollGravekeepersGauntlet(deathLocation)
    elseif itemName == "item_rpc_conquest_stone_falcon" then
        newItem = RPCItems:RollConquestStoneFalcon(deathLocation)
    elseif itemName == "item_rpc_epsilons_eyeglass" then
        newItem = RPCItems:RollEpsilonsEyeglass(deathLocation)
    elseif itemName == "item_rpc_heroic_conqueror_vestments" then
        --print("GIMME DAT")
        newItem = RPCItems:RollHeroicConquerorVestments(deathLocation, 1)
    elseif itemName == "item_rpc_autumn_sleeper_mask" then
        newItem = RPCItems:RollAutumnSleeperMask(deathLocation, isShop)
    elseif itemName == "item_rpc_eye_of_seasons" then
        newItem = RPCItems:RollEyeOfSeasons(deathLocation, isShop)
    elseif itemName == "item_rpc_redfall_runners" then
        newItem = RPCItems:RollRedfallRunners(deathLocation)
    elseif itemName == "item_rpc_fenrirs_fang" then
        newItem = RPCItems:RollFenrirFang(deathLocation)
    elseif itemName == "item_rpc_boots_of_ashara" then
        newItem = RPCItems:RollBootsOfAshara(deathLocation)
    elseif itemName == "item_rpc_autumnrock_bracer" then
        newItem = RPCItems:RollAutumnrockBracers(deathLocation)
    elseif itemName == "item_rpc_guard_of_feronia" then
        newItem = RPCItems:RollGuardOfFeronia(deathLocation)
    elseif itemName == "item_rpc_fuchsia_ring" then
        newItem = RPCItems:RollFuchsiaRing(deathLocation)
    elseif itemName == "item_rpc_helm_of_the_silent_templar" then
        newItem = RPCItems:RollHelmOfSilentTemplar(deathLocation, isShop)
    elseif itemName == "item_rpc_mystic_mana_wall" then
        newItem = RPCItems:RollMysticManaWall(deathLocation)
    elseif itemName == "item_rpc_sandstream_slippers" then
        newItem = RPCItems:RollSandstreamSlippers(deathLocation)
    elseif itemName == "item_rpc_malachite_shade_bracer" then
        newItem = RPCItems:RollMalachiteShadeBracer(deathLocation)
    elseif itemName == "item_rpc_wind_deity_crown" then
        newItem = RPCItems:RollWindDeityCrown(deathLocation, false, 0)
    elseif itemName == "item_rpc_water_deity_crown" then
        newItem = RPCItems:RollWaterDeityCrown(deathLocation, false, 0)
    elseif itemName == "item_rpc_fire_deity_crown" then
        newItem = RPCItems:RollFireDeityCrown(deathLocation, false, 0)
    elseif itemName == "item_rpc_skulldigger_gauntlet_lv1" then
        newItem = RPCItems:RollSkulldiggerGlovesLV1(deathLocation)
    elseif itemName == "item_rpc_shipyard_veil_lv1" then
        newItem = RPCItems:RollShipyardVeil1(deathLocation)
    elseif itemName == "item_rpc_crimsyth_elite_greaves_lv1" then
        newItem = RPCItems:RollCrimsythEliteGreavesLV1(deathLocation)
    elseif itemName == "item_rpc_harvester_boots" then
        newItem = RPCItems:RollHarvesterBoots(deathLocation)
    elseif itemName == "item_rpc_fortunes_talisman_of_truth" then
        newItem = RPCItems:RollFortunesTalismanOfTruth(deathLocation)
    elseif itemName == "item_rpc_vermillion_dream_robes" then
        newItem = RPCItems:VermillionDreamRobes(deathLocation)
    elseif itemName == "item_rpc_boots_of_great_fortune" then
        newItem = RPCItems:RollBootsOfGreatFortune(deathLocation)
    elseif itemName == "item_rpc_cobalt_serenity_ring" then
        newItem = RPCItems:RollCobaltSerenityRing(deathLocation)
    elseif itemName == "item_rpc_emerald_nullification_ring" then
        newItem = RPCItems:RollEmeraldNullificationRing(deathLocation)
    elseif itemName == "item_rpc_garnet_warfare_ring" then
        newItem = RPCItems:RollGarnetWarfareRing(deathLocation)
    elseif itemName == "item_rpc_claws_of_the_ethereal_revenant" then
        newItem = RPCItems:RollClawOfTheEtherealRevenant(deathLocation)
    elseif itemName == "item_rpc_crimson_skull_cap" then
        newItem = RPCItems:RollCrimsonSkullCap(deathLocation, isShop)
    elseif itemName == "item_rpc_hood_of_lords" then
        newItem = RPCItems:RollHoodOfLords(deathLocation)
    elseif itemName == "item_rpc_spellfire_gloves" then
        newItem = RPCItems:RollSpellfireGloves(deathLocation, false)
    elseif itemName == "item_rpc_bloodstone_boots" then
        newItem = RPCItems:RollBloodstoneBoots(deathLocation, false)
    elseif itemName == "item_rpc_igneous_canine_helm" then
        newItem = RPCItems:RollIgneousCanineHelm(deathLocation)
    elseif itemName == "item_rpc_never_ring" then
        newItem = RPCItems:RollNeverlordRing(deathLocation)
    elseif itemName == "item_rpc_barons_storm_armor" then
        newItem = RPCItems:RollBaronsStormArmor(deathLocation)
    elseif itemName == "item_rpc_serengaard_sun_crystal" then
        newItem = RPCItems:RollSunCrystal(deathLocation, 1)
    elseif itemName == "item_rpc_temporal_warp_boots" then
        newItem = RPCItems:RollTemporalWarpBoots(deathLocation)
    elseif itemName == "item_rpc_aqua_lily" then
        newItem = RPCItems:RollAquaLily(deathLocation)
    elseif itemName == "item_rpc_fire_blossom" then
        newItem = RPCItems:RollFireBlossom(deathLocation)
    elseif itemName == "item_rpc_wind_orchid" then
        newItem = RPCItems:RollWindOrchid(deathLocation)
    elseif itemName == "item_rpc_ankh_of_the_ancients" then
        newItem = RPCItems:RollAnkhOfAncients(deathLocation)
    elseif itemName == "item_rpc_alaranas_ice_boot" then
        newItem = RPCItems:RollAlaranaIceBoot(deathLocation)
    elseif itemName == "item_rpc_ancient_tanari_wind_armor" then
        newItem = RPCItems:RollTanariWindArmor(deathLocation)
    elseif itemName == "item_rpc_blue_rain_gauntlet" then
        newItem = RPCItems:RollBlueRainGauntlet(deathLocation)
    elseif itemName == "item_rpc_shadowflame_fist" then
        newItem = RPCItems:RollShadowflameFist(deathLocation)
    elseif itemName == "item_rpc_blazing_fury_armor" then
        newItem = RPCItems:RollBlazingFuryArmor(deathLocation)
    elseif itemName == "item_rpc_aquastone_ring" then
        newItem = RPCItems:RollAquastoneRing(deathLocation)
    elseif itemName == "item_rpc_burning_spirit_helmet" then
        newItem = RPCItems:RollBurningSpiritHelmet(deathLocation, false)
    elseif itemName == "item_rpc_aquasteel_bracers" then
        newItem = RPCItems:RollAquasteelBracers(deathLocation)
    elseif itemName == "item_rpc_demonfire_gauntlet" then
        newItem = RPCItems:RollDemonfireGauntlet(deathLocation)
    elseif itemName == "item_rpc_emerald_speed_runners" then
        newItem = RPCItems:RollEmeraldSpeedRunners(deathLocation)
    elseif itemName == "item_rpc_outland_stone_cuirass" then
        newItem = RPCItems:RollOutlandStoneCuirass(deathLocation)
    elseif itemName == "item_rpc_world_trees_flower_cache" then
        newItem = RPCItems:RollWorldTreesFlowerCache(deathLocation)
    elseif itemName == "item_rpc_red_october_boots" then
        newItem = RPCItems:RollRedOctoberBoots(deathLocation, false)
    elseif itemName == "item_rpc_armor_of_atlantis" then
        newItem = RPCItems:RollArmorOfAtlantis(deathLocation)
    elseif itemName == "item_rpc_chitinous_lobster_claw" then
        newItem = RPCItems:RollChitinousLobsterClaw(deathLocation)
    elseif itemName == "item_rpc_crystalline_slippers" then
        newItem = RPCItems:RollCrystallineSlippers(deathLocation)
    elseif itemName == "item_rpc_dark_emissary_glove" then
        newItem = RPCItems:RollDarkEmissaryGlove(deathLocation)
    elseif itemName == "item_rpc_dark_reef_shark_helmet" then
        newItem = RPCItems:RollDarkReefSharkHelmet(deathLocation, false)
    elseif itemName == "item_rpc_depth_demon_claw" then
        newItem = RPCItems:RollDepthDemonClaw(deathLocation)
    elseif itemName == "item_rpc_empyreal_sunrise_robe" then
        newItem = RPCItems:RollEmpyrealSunriseRobe(deathLocation)
    elseif itemName == "item_rpc_hood_of_the_sea_oracle" then
        newItem = RPCItems:RollHoodOfTheSeaOracle(deathLocation)
    elseif itemName == "item_rpc_ocean_helm_of_valdun" then
        newItem = RPCItems:RollOceanHelmOfValdun(deathLocation, false)
    elseif itemName == "item_rpc_oceanrunner_boots" then
        newItem = RPCItems:RollOceanrunnerBoots(deathLocation)
    elseif itemName == "item_rpc_sea_giants_plate" then
        newItem = RPCItems:RollSeaGiantsPlate(deathLocation)
    elseif itemName == "item_rpc_sparkling_token_of_oceanis" then
        newItem = RPCItems:RollTokenOfOceanis(deathLocation, false)
    elseif itemName == "item_rpc_templar_light_seers_robe" then
        newItem = RPCItems:RollLightSeersRobes(deathLocation)
    elseif itemName == "item_rpc_twisted_blue_mask_of_ahnqhir" then
        newItem = RPCItems:RollTwistedMaskOfAhnqhirBlue(deathLocation)
    elseif itemName == "item_rpc_twisted_yellow_mask_of_ahnqhir" then
        newItem = RPCItems:RollTwistedMaskOfAhnqhirYellow(deathLocation)
    elseif itemName == "item_rpc_twisted_purple_mask_of_ahnqhir" then
        newItem = RPCItems:RollTwistedMaskOfAhnqhirPurple(deathLocation)
    elseif itemName == "item_rpc_steamboots" then
        newItem = RPCItems:RollSteamboots(deathLocation)
    elseif itemName == "item_rpc_monkey_paw" then
        newItem = RPCItems:RollMonkeyPaw(deathLocation)
    elseif itemName == "item_rpc_arcane_charm" then
        newItem = RPCItems:RollArcaneCharm(deathLocation)
    elseif itemName == "item_rpc_skulldigger_gauntlet" then
        newItem = RPCItems:RollSkulldiggerGloves(deathLocation)
    elseif itemName == "item_rpc_winterblight_skull_ring" then
        newItem = RPCItems:RollWinterblightSkullRing(deathLocation)
    elseif itemName == "item_rpc_heavy_echo_gauntlet" then
        newItem = RPCItems:RollHeavyEchoGauntlet(deathLocation)
    elseif itemName == "item_rpc_frostmaw_hunters_hood" then
        newItem = RPCItems:RollFrostmawHuntersHood(deathLocation)
    elseif itemName == "item_rpc_frozen_heart" then
        newItem = RPCItems:RollFrozenHeart(deathLocation)
    elseif itemName == "item_rpc_energy_whip_glove" then
        newItem = RPCItems:RollEnergyWhipGlove(deathLocation)
    elseif itemName == "item_rpc_boreal_granite_vest" then
        newItem = RPCItems:RollBorealGraniteVest(deathLocation)
    elseif itemName == "item_rpc_captains_vest" then
        newItem = RPCItems:RollCaptainsVest(deathLocation)
    elseif itemName == "item_rpc_gravelfoot_treads" then
        newItem = RPCItems:RollGravelfootTreads(deathLocation)
    elseif itemName == "item_rpc_ice_floe_slippers" then
        newItem = RPCItems:RollIceFloeSlippers(deathLocation)
    elseif itemName == "item_rpc_iron_treads_of_destruction" then
        newItem = RPCItems:RollIronTreadsOfDestruction(deathLocation)
    elseif itemName == "item_rpc_tattered_novice_armor" then
        newItem = RPCItems:RollTatteredNoviceArmor(deathLocation)
    elseif itemName == "item_rpc_buzukis_finger" then
        newItem = RPCItems:RollBuzukisFinger(deathLocation)
    elseif itemName == "item_rpc_swiftspike_bracer" then
        newItem = RPCItems:RollSwiftspikeBracer(deathLocation)
    elseif itemName == "item_rpc_red_divinex_amulet" then
        newItem = RPCItems:RollRedDivinexAmulet(deathLocation)
    elseif itemName == "item_rpc_green_divinex_amulet" then
        newItem = RPCItems:RollGreenDivinexAmulet(deathLocation)
    elseif itemName == "item_rpc_blue_divinex_amulet" then
        newItem = RPCItems:RollBlueDivinexAmulet(deathLocation)
    elseif itemName == "item_rpc_helm_of_the_mountain_giant" then
        newItem = RPCItems:RollHelmOfTheMountainGiant(deathLocation, false)
    elseif itemName == "item_rpc_chains_of_orthok" then
        newItem = RPCItems:RollChainsOfOrthok(deathLocation)
    elseif itemName == "item_rpc_puzzlers_locket" then
        newItem = RPCItems:RollPuzzlersLocket(deathLocation)
    elseif itemName == "item_rpc_diamond_claws_of_tiamat" then
        newItem = RPCItems:RollDiamondClawsOfTiamat(deathLocation, 1)
    elseif itemName == "item_rpc_galvanized_razor_band" then
        newItem = RPCItems:RollGalvanizedRazorBand(deathLocation)
    elseif itemName == "item_rpc_goldbreaker_gauntlet" then
        newItem = RPCItems:RollGoldbreakerGauntlet(deathLocation)
    elseif itemName == "item_rpc_pegasus_boots" then
        newItem = RPCItems:RollPegasusBoots(deathLocation)
    elseif itemName == "item_rpc_guardian_stone" then
        newItem = RPCItems:RollGuardianStone(deathLocation)
    elseif itemName == "item_rpc_robe_of_the_erudite_teacher" then
        newItem = RPCItems:RollRobesOfEruditeTeacher(deathLocation)
    elseif itemName == "item_rpc_pivotal_swiftboots" then
        newItem = RPCItems:RollPivotalSwiftboots(deathLocation)
    elseif itemName == "item_rpc_alien_armor" then
        newItem = RPCItems:RollAlienArmor(deathLocation)
    elseif itemName == "item_rpc_magistrates_hood" then
        newItem = RPCItems:RollMagistratesHood(deathLocation)
    elseif itemName == "item_rpc_nethergrasp_palisade" then
        newItem = RPCItems:NethergraspPalisade(deathLocation)
    elseif itemName == "item_rpc_beryl_ring_of_intuition" then
        newItem = RPCItems:RollBerylRingOfIntuition(deathLocation, 1)
    elseif itemName == "item_rpc_auric_ring_of_inspiration" then
        newItem = RPCItems:RollAuricRingOfInspiration(deathLocation, 1)
    elseif itemName == "item_rpc_helm_of_the_knight_hawk" then
	   newItem = RPCItems:RollHelmOfKnightHawk(deathLocation, false)
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
    RPCItems.LevelRoll = itemLevel
    if item.isLuaItem then
        newItem = item:Create(deathLocation)
    else
        newItem = RPCItems:RollImmortalByName(itemName, deathLocation)
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
        "item_rpc_guard_of_grithault", "item_rpc_cap_of_wild_nature", "item_rpc_guard_of_luma", "item_rpc_brazen_kabuto_of_the_desert_realm", "item_rpc_odin_helmet", "item_rpc_wraith_crown",
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
        "item_rpc_autumn_sleeper_mask", "item_rpc_eye_of_seasons", "item_rpc_redfall_runners", "item_rpc_fenrirs_fang", "item_rpc_boots_of_ashara", "item_rpc_autumnrock_bracer",
        "item_rpc_guard_of_feronia", "item_rpc_fuchsia_ring", "item_rpc_helm_of_the_silent_templar", "item_rpc_mystic_mana_wall", "item_rpc_sandstream_slippers", "item_rpc_malachite_shade_bracer",
        "item_rpc_wind_deity_crown", "item_rpc_water_deity_crown", "item_rpc_fire_deity_crown", "item_rpc_skulldigger_gauntlet_lv1", "item_rpc_shipyard_veil_lv1", "item_rpc_crimsyth_elite_greaves_lv1",
        "item_rpc_harvester_boots", "item_rpc_fortunes_talisman_of_truth", "item_rpc_vermillion_dream_robes", "item_rpc_boots_of_great_fortune", "item_rpc_cobalt_serenity_ring",
        "item_rpc_emerald_nullification_ring", "item_rpc_garnet_warfare_ring", "item_rpc_claws_of_the_ethereal_revenant", "item_rpc_crimson_skull_cap", "item_rpc_hood_of_lords",
        "item_rpc_spellfire_gloves", "item_rpc_bloodstone_boots", "item_rpc_igneous_canine_helm", "item_rpc_never_ring", "item_rpc_barons_storm_armor", "item_rpc_serengaard_sun_crystal",
        "item_rpc_temporal_warp_boots", "item_rpc_aqua_lily", "item_rpc_fire_blossom", "item_rpc_wind_orchid", "item_rpc_ankh_of_the_ancients", "item_rpc_alaranas_ice_boot",
        "item_rpc_ancient_tanari_wind_armor", "item_rpc_blue_rain_gauntlet", "item_rpc_shadowflame_fist", "item_rpc_blazing_fury_armor", "item_rpc_aquastone_ring", "item_rpc_burning_spirit_helmet",
        "item_rpc_aquasteel_bracers", "item_rpc_demonfire_gauntlet", "item_rpc_emerald_speed_runners", "item_rpc_outland_stone_cuirass", "item_rpc_world_trees_flower_cache", "item_rpc_red_october_boots",
        "item_rpc_armor_of_atlantis", "item_rpc_chitinous_lobster_claw", "item_rpc_crystalline_slippers", "item_rpc_dark_emissary_glove", "item_rpc_dark_reef_shark_helmet", "item_rpc_depth_demon_claw", "item_rpc_empyreal_sunrise_robe",
        "item_rpc_hood_of_the_sea_oracle", "item_rpc_ocean_helm_of_valdun", "item_rpc_oceanrunner_boots", "item_rpc_sea_giants_plate", "item_rpc_sparkling_token_of_oceanis", "item_rpc_templar_light_seers_robe",
    "item_rpc_twisted_blue_mask_of_ahnqhir", "item_rpc_twisted_yellow_mask_of_ahnqhir", "item_rpc_twisted_purple_mask_of_ahnqhir", "item_rpc_new_boots", "item_rpc_heavy_echo_gauntlet"}

    return itemsList
end

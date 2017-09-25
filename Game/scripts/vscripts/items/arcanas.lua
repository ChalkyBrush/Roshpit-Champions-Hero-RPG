function RPCItems:RollFlamewakerArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_flamewaker_arcana1", "arcana", "Flamewaker Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_dragon_knight", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "flamewaker_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_flamewaker_arcana1", "#FCAD58",  1, "#property_flamewaker_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_a"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_a"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_a"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_a"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*20)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollSeinaruArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_seinaru_arcana1", "arcana", "Seinaru Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_juggernaut", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "seinaru_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_seinaru_arcana1", "#F4F269",  1, "#property_seinaru_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_a"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_a"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_a"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_a"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*20)
    item.property3 = value
    item.property3name = "agility"
    RPCItems:SetPropertyValues(item, item.property3, "#item_agility", "#2EB82E",  3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollAstralArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_astral_arcana1", "arcana", "Astral Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_drow_ranger", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "astral_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_astral_arcana1", "#9D8BBF",  1, "#property_astral_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_a"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_a"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_a"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_a"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 8, 21, 0, 0, item.rarity, false, maxFactor*11)
    item.property3 = value
    item.property3name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.property3, "#item_all_attributes", "#FFFFFF",  3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollBahamutArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_bahamut_arcana1", "arcana", "Bahamut Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_leshrac", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "bahamut_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_bahamut_arcana1", "#7CDAFF",  1, "#property_bahamut_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 8, 24, 0, 0, item.rarity, false, maxFactor*14)
    item.property3 = value
    item.property3name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.property3, "#item_all_attributes", "#FFFFFF",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollDuskbringerArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_duskbringer_arcana1", "arcana", "Duskbringer Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_spirit_breaker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "duskbringer_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_duskbringer_arcana1", "#5CEDE1",  1, "#property_duskbringer_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_b"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_b"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_b"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_b"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*22)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)

    RPCItems:RollHandProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollConjurorArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_conjuror_arcana1", "arcana", "Conjuror Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_invoker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "conjuror_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_conjuror_arcana1", "#D6CF59",  1, "#property_conjuror_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 8, 20, 0, 0, item.rarity, false, maxFactor*11)
    item.property3 = value
    item.property3name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.property3, "#item_all_attributes", "#FFFFFF",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollTrapperArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_trapper_arcana1", "arcana", "Trapper Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_templar_assassin", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "trapper_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_trapper_arcana1", "#CCAE2C",  1, "#property_trapper_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_b"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_b"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_b"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_b"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 200, 0, 0, item.rarity, false, maxFactor*500)
    item.property3 = value
    item.property3name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.property3, "#item_bonus_attack_damage", "#343EC9",  3) 

    RPCItems:RollHandProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollSpiritWarriorArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_spirit_warrior_arcana1", "arcana", "Spirit Warrior Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_huskar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "spirit_warrior_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spirit_warrior_arcana1", "#82A8E5",  1, "#property_spirit_warrior_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*20)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollSpiritWarriorArcana2(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_spirit_warrior_arcana2", "arcana", "Spirit Warrior Arcana 2", "hands", true, "Slot: Hands", "npc_dota_hero_huskar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "spirit_warrior_arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spirit_warrior_arcana2", "#82A8E5",  1, "#property_spirit_warrior_arcana2_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_b"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_b"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_b"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_b"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*20)
    item.property3 = value
    item.property3name = "intelligence"
    RPCItems:SetPropertyValues(item, item.property3, "#item_intelligence", "#33CCFF",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollSpiritWarriorArcana3(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_spirit_warrior_arcana3", "arcana", "Spirit Warrior Arcana 3", "feet", true, "Slot: Feet", "npc_dota_hero_huskar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "spirit_warrior_arcana3"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_spirit_warrior_arcana3", "#69EF7F",  1, "#property_spirit_warrior_arcana3_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_c"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_c"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_c"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_c"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*20)
    item.property3 = value
    item.property3name = "agility"
    RPCItems:SetPropertyValues(item, item.property3, "#item_agility", "#2EB82E",  3)

    RPCItems:RollFootProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollMountainProtectorArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_mountain_protector_arcana1", "arcana", "Mountain Protector Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_legion_commander", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "legion_commander_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_protector_arcana1", "#BDE6F9",  1, "#property_mountain_protector_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_b"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_b"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_b"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_b"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*20)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)

    RPCItems:RollHandProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollMountainProtectorArcana2(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_mountain_protector_arcana2", "arcana", "Mountain Protector Arcana 2", "body", true, "Slot: Body", "npc_dota_hero_legion_commander", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "legion_commander_arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_mountain_protector_arcana2", "#94BEFC",  1, "#property_mountain_protector_arcana2_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 12, 40, 0, 0, item.rarity, false, maxFactor*28)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollVenomortArcana1(deathLocation)
    --VENOM REAPER ROBES
    local item = RPCItems:CreateVariantArcana("item_rpc_venomort_arcana1", "arcana", "Venomort Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_necrolyte", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_venomort_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_venomort_arcana1", "#48AF5E",  1, "#property_venomort_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 200, 0, 0, item.rarity, false, maxFactor*800)
    item.property3 = value
    item.property3name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.property3, "#item_bonus_attack_damage", "#343EC9",  3) 

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollChernobogArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_chernobog_arcana1", "arcana", "Chernobog Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_night_stalker", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_chernobog_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_chernobog_arcana1", "#4C5B96",  1, "#property_chernobog_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*18)
    item.property3 = value
    item.property3name = "agility"
    RPCItems:SetPropertyValues(item, item.property3, "#item_agility", "#2EB82E",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollAuriunArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_auriun_arcana1", "arcana", "Auriun Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_zuus", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_auriun_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_auriun_arcana1", "#F4DC42",  1, "#property_auriun_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_a"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_a"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_a"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_a"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 8, 21, 0, 0, item.rarity, false, maxFactor*11)
    item.property3 = value
    item.property3name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.property3, "#item_all_attributes", "#FFFFFF",  3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollAuriunArcana2(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_auriun_arcana2", "arcana", "Auriun Arcana 2", "head", true, "Slot: Head", "npc_dota_hero_zuus", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_auriun_arcana2"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_auriun_arcana2", "#9B48CE",  1, "#property_auriun_arcana2_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_a"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_a"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_a"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_a"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 8, 21, 0, 0, item.rarity, false, maxFactor*11)
    item.property3 = value
    item.property3name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.property3, "#item_all_attributes", "#FFFFFF",  3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollVoltexArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_voltex_arcana1", "arcana", "Voltex Arcana 1", "feet", true, "Slot: Feet", "npc_dota_hero_phantom_assassin", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_voltex_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_voltex_arcana1", "#49CFF4",  1, "#property_voltex_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_c"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_c"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_c"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_c"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 60, 0, 0, item.rarity, false, maxFactor*30)
    item.property3 = value
    item.property3name = "agility"
    RPCItems:SetPropertyValues(item, item.property3, "#item_agility", "#2EB82E",  3)

    RPCItems:RollFootProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollPaladinArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_paladin_arcana1", "arcana", "Paladin Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_omniknight", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_paladin_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_paladin_arcana1", "#F4E542",  1, "#property_paladin_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_b"
        item.property2 = math.ceil(value*2.0)
    elseif luck <= 70 then
        item.property2name = "rune_b_b"
        item.property2 = math.ceil(value*2.0)       
    elseif luck <= 90 then
        item.property2name = "rune_c_b"
        item.property2 = math.ceil(value*1.5) 
    else
        item.property2name = "rune_d_b"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 20, 25, 0, 0, item.rarity, false, maxFactor*21)
    item.property3 = value
    item.property3name = "all_attributes"
    RPCItems:SetPropertyValues(item, item.property3, "#item_all_attributes", "#FFFFFF",  3)

    RPCItems:RollHandProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollSorceressArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_sorceress_arcana1", "arcana", "Sorceress Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_crystal_maiden", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_sorceress_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_sorceress_arcana1", "#82D5FF",  1, "#property_sorceress_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.5)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.5)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1.3) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 12, 40, 0, 0, item.rarity, false, maxFactor*25)
    item.property3 = value
    item.property3name = "intelligence"
    RPCItems:SetPropertyValues(item, item.property3, "#item_intelligence", "#33CCFF",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollEpochArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_epoch_arcana1", "arcana", "Epoch Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_obsidian_destroyer", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_epoch_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_epoch_arcana1", "#87FFD1",  1, "#property_epoch_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_a"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_a"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_a"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_a"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*21)
    item.property3 = value
    item.property3name = "intelligence"
    RPCItems:SetPropertyValues(item, item.property3, "#item_intelligence", "#33CCFF",  3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollAxeArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_axe_arcana1", "arcana", "Axe Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_axe", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_axe_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_axe_arcana1", "#82D5FF",  1, "#property_axe_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.4)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.4)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1.2) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 8, 40, 0, 0, item.rarity, false, maxFactor*19)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollWarlordArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_warlord_arcana1", "arcana", "Warlord Arcana 1", "body", true, "Slot: Body", "npc_dota_hero_beastmaster", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_warlord_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_warlord_arcana1", "#EFD8BD",  1, "#property_warlord_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_d"
        item.property2 = math.ceil(value*1.6)
    elseif luck <= 70 then
        item.property2name = "rune_b_d"
        item.property2 = math.ceil(value*1.4)       
    elseif luck <= 90 then
        item.property2name = "rune_c_d"
        item.property2 = math.ceil(value*1.2) 
    else
        item.property2name = "rune_d_d"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 8, 40, 0, 0, item.rarity, false, maxFactor*23)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)

    RPCItems:RollBodyProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollEkkanArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_ekkan_arcana1", "arcana", "Ekkan Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_visage", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_ekkan_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_ekkan_arcana1", "#879CBC",  1, "#property_ekkan_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_a"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_a"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_a"
        item.property2 = math.ceil(value*1.0) 
    else
        item.property2name = "rune_d_a"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(8, 12), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)
    local luck = RandomInt(1, 3)
    if luck == 3 then
        local magicResistRoll = RPCItems:GetLogarithmicVarianceValue(RandomInt(15, 30), 0, 0, 0, 0)
        item.property3 = magicResistRoll
        item.property3name = "magic_resist"
        RPCItems:SetPropertyValues(item, item.property3, "#item_magic_resist", "#AC47DE",  3)
    else
        local luck = RandomInt(1, 100)
        if luck <= 35 then
            item.property3name = "rune_a_a"
            item.property3 = math.ceil(value*1.4)
        elseif luck <= 70 then
            item.property3name = "rune_b_a"
            item.property3 = math.ceil(value*1.4)       
        elseif luck <= 90 then
            item.property3name = "rune_c_a"
            item.property3 = math.ceil(value*1.2) 
        else
            item.property3name = "rune_d_a"
            item.property3 = RPCItems:GetLogarithmicVarianceValue(RandomInt(11, 16), 0, 0, 0, 0)
        end
        RPCItems:SetPropertyValues(item, item.property3, "rune", "#7DFF12",  3)
    end

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollArkimusArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_arkimus_arcana1", "arcana", "Arkimus Arcana 1", "head", true, "Slot: Head", "npc_dota_hero_antimage", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_arkimus_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_arkimus_arcana1", "#f442D7",  1, "#property_arkimus_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_a"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_a"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_a"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_a"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 10, 40, 0, 0, item.rarity, false, maxFactor*18)
    item.property3 = value
    item.property3name = "agility"
    RPCItems:SetPropertyValues(item, item.property3, "#item_agility", "#2EB82E",  3)

    RPCItems:RollHoodProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollZhonikArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_zonik_arcana1", "arcana", "Zhonik Arcana 1", "feet", true, "Slot: Feet", "npc_dota_hero_dark_seer", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_zonik_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_zonik_arcana1", "#42F450",  1, "#property_zonik_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_c"
        item.property2 = math.ceil(value*1.1)
    elseif luck <= 70 then
        item.property2name = "rune_b_c"
        item.property2 = math.ceil(value*1.1)       
    elseif luck <= 90 then
        item.property2name = "rune_c_c"
        item.property2 = math.ceil(value*1) 
    else
        item.property2name = "rune_d_c"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 15, 60, 0, 0, item.rarity, false, maxFactor*30)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)

    RPCItems:RollFootProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end

function RPCItems:RollHydroxisArcana1(deathLocation)
    local item = RPCItems:CreateVariantArcana("item_rpc_hydroxis_arcana1", "arcana", "Hydroxis Arcana 1", "hands", true, "Slot: Hands", "npc_dota_hero_slardar", 0)
    local maxFactor = RPCItems:GetMaxFactor()
    item.property1 = 1
    item.property1name = "!arcana!_hydroxis_arcana1"
    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_hydroxis_arcana1", "#42BCF4",  1, "#property_hydroxis_arcana1_description")


    item.hasRunePoints = true
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    
    local luck = RandomInt(1, 100)
    if luck <= 35 then
        item.property2name = "rune_a_b"
        item.property2 = math.ceil(value*1.5)
    elseif luck <= 70 then
        item.property2name = "rune_b_b"
        item.property2 = math.ceil(value*1.5)       
    elseif luck <= 90 then
        item.property2name = "rune_c_b"
        item.property2 = math.ceil(value*1.1) 
    else
        item.property2name = "rune_d_b"
        item.property2 = RPCItems:GetLogarithmicVarianceValue(RandomInt(10, 15), 0, 0, 0, 0)
    end
    RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)


    local value, prefixLevel = RPCItems:RollAttribute(100, 15, 50, 0, 0, item.rarity, false, maxFactor*24)
    item.property3 = value
    item.property3name = "strength"
    RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)


    RPCItems:RollHandProperty4(item, 0)

    RPCItems:DropOrGiveItem(hero, item, false, deathLocation)
    return item
end


function RPCItems:PreacheArcanaResources(item)
    Timers:CreateTimer(0.05, function()
        PrecacheItemByNameAsync(item:GetAbilityName(), function(...) end)
    end)
end
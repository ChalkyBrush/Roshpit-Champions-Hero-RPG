BASE_BLASTER_TABLE = {"item_fire_blaster", "item_ice_blaster", "item_wind_blaster"}

function RPCItems:RollBlaster(xpBounty, deathLocation, rarity, isShop, type, hero, unitLevel)
    local randomHelm = RandomInt(1, 3)
    if isShop then
        randomHelm = type
    end
	local blaster_variant = BASE_BLASTER_TABLE[randomHelm]
    local item = CreateItem(blaster_variant, nil, nil)
    item.rarity = rarity
    print("rarity:")
    print(rarity)
    local rarityValue = RPCItems:GetRarityFactor(rarity)
    print("rarityValue:")
    print(rarityValue)
    if blaster_variant == "item_fire_blaster" then
        itemName = "Fire Cannon"
        item.type = "fire"
        itemDescription = "Creates a fire cone in front of the caster<br>dealing damage and applying 100<br>fire damage over 5 seconds."
    elseif blaster_variant == "item_ice_blaster" then
        itemName = "Ice Cannon"
        item.type = "ice"
        itemDescription = "Creates an ice cone in front of the caster<br>dealing damage and reducing movespeed<br>by 90 for 5 seconds."
    elseif blaster_variant == "item_wind_blaster" then
        itemName = "Wind Cannon"
        item.type = "wind"
        itemDescription = "Creates a cone of wind in front of the caster<br>dealing damage and applying 25%<br>miss chance for 5 seconds."
    end
    local suffix = RPCItems:RollBlasterProperty1(item, xpBounty)
    if rarityValue >= 2 then
    	prefix = RPCItems:RollBlasterProperty2(item, xpBounty)
    	print(prefix)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollBlasterProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	local additionalPrefix = RPCItems:RollBlasterProperty4(item, xpBounty)
        itemName = additionalPrefix.." "..itemName
    end

    RPCItems:SetTableValues(item, itemName, false, itemDescription, RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    if isShop then
        RPCItems:GiveItemToHero(hero, item)
    else
        local drop = CreateItemOnPositionSync( deathLocation, item )
        local position = deathLocation
        RPCItems:DropItem(item, position)
    end
end

SUFFIX_BLASTER_DAMAGE_TABLE = {"of Blasting", "of Greater Blasting", "of Major Blasting", "of Great Force", "of Unstoppable Force"}
SUFFIX_BLASTER_RADIUS_TABLE = {"of Flooding", "of Upheaval", "of Torrent", "of Catastrophe", "of Great Calamity"}
SUFFIX_BLASTER_RANGE_TABLE = {"of Breadth", "of Expansion", "of Great Breadth", "of Greater Expansion", "of Massive Range"}
SUFFIX_BLASTER_COOLDOWN_TABLE = {"of Acceleration", "of Mastery", "of Quick-Fire", "of Rapid-Fire", "of Swift-Fire"}
SUFFIX_BLASTER_MODIFIER_MAGNITUDE_FIRE_TABLE = {"of Burning", "of Scorching", "of Smoldering", "of Conflageration", "of Incineration"}
SUFFIX_BLASTER_MODIFIER_MAGNITUDE_ICE_TABLE = {"of Refrigeration", "of Numbing", "of Freezing", "of Bitter Ice", "of Numbing Cold"}
SUFFIX_BLASTER_MODIFIER_MAGNITUDE_WIND_TABLE = {"of Shearing", "of Great Shearing", "of Violent Gusts", "of the Storm", "of the Hurricane"}
SUFFIX_BLASTER_MODIFIER_DURATION_TABLE = {"of Lasting", "of Prolonging", "of Lasting Effect", "of Great Prolonging", "of Perpetuation"}
SUFFIX_BLASTER_CASTER_KNOCKBACK = {"of Recoil", "of Great Rebounding", "of Quaking", "of Greater Recoil", "of Grand Reflexion"}
SUFFIX_BLASTER_ROOT = {"of Rooting", "of Crippling", "of Debilitation", "of Great Immobilization", "of Grand Incapacitation"}
SUFFIX_BLASTER_HEX = {"of Hexing", "of Greater Hexing", "of Voodoo", "of Strange Sorcery", "of the Voodoo Lord"}

function RPCItems:RollBlasterProperty1(item, xpBounty)
    local luck = RandomInt(0,100)
    if luck < 30 then
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 40, 80, 1, 3, item.rarity, false, nil)
        item.property1 = value
        item.property1name = "damage"
        suffix = SUFFIX_BLASTER_DAMAGE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_bonus_damage", "#E67607",  1)
    elseif luck >= 30 and luck < 40 then
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 20, 50, 1, 1, item.rarity, false, 1000)
        item.property1 = value
        item.property1name = "radius"
        suffix = SUFFIX_BLASTER_RADIUS_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_end_radius", "#D8ED1C",  1)
    elseif luck >= 40 and luck < 50 then
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 20, 60, 1, 1, item.rarity, false, 1000)
        item.property1 = value
        item.property1name = "range"
        suffix = SUFFIX_BLASTER_RANGE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_range_increase", "#D8ED1C",  1)
    elseif luck >= 50 and luck < 60 then
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 20, 60, 1, 1, item.rarity, true, nil)
        item.property1 = value
        item.property1name = "cooldown"
        suffix = SUFFIX_BLASTER_COOLDOWN_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_cooldown_reduce", "#D1D1D1",  1)
    elseif luck >= 60 and luck < 70 then
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 5, 10, 1, 2, item.rarity, false, nil)
        item.property1 = value
        item.property1name = "modifier_magnitude"
        if item.type == "fire" then
            description = "#item_burn_damage"
            suffix = SUFFIX_BLASTER_MODIFIER_MAGNITUDE_FIRE_TABLE[suffixLevel]
            color = "#DB5C5C"
        elseif item.type == "ice" then
            description = "#item_move_slow"
            suffix = SUFFIX_BLASTER_MODIFIER_MAGNITUDE_ICE_TABLE[suffixLevel]
            color = "#B9E1ED"
        elseif item.type == "wind" then
            description = "#item_miss_chance"
            suffix = SUFFIX_BLASTER_MODIFIER_MAGNITUDE_WIND_TABLE[suffixLevel]
            color = "#5CDB7A"
        end
        RPCItems:SetPropertyValues(item, item.property1, description, color,  1) 
    elseif luck >= 70 and luck < 80 then
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 10, 50, 1, 1, item.rarity, true, nil)
        item.property1 = value
        item.property1name = "modifier_duration"
        suffix = SUFFIX_BLASTER_MODIFIER_DURATION_TABLE[suffixLevel]
        if item.type == "fire" then
            description = "#item_burn_duration"
        elseif item.type == "ice" then
            description = "#item_frost_duration"
        elseif item.type == "wind" then
            description = "#item_windshear_duration"
        end
        RPCItems:SetPropertyValues(item, item.property1, description, "#1975FF",  1) 
    elseif luck >= 80 and luck < 93 then
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 50, 100, 1, 3, item.rarity, false, nil)
        item.property1 = value
        item.property1name = "damage"
        suffix = SUFFIX_BLASTER_DAMAGE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_bonus_damage", "#E67607",  1)
    else
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 10, 50, 1, 10, item.rarity, true, nil)
        item.property1 = value
        item.property1name = "root"
        suffix = SUFFIX_BLASTER_ROOT[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_root_duration", "#8907F2",  1)      
    end
    return suffix
end

PREFIX_BLASTER_DAMAGE_TABLE = {"Forceful", "Dynamic", "Vigorous", "Robust", "Violent"}
PREFIX_BLASTER_RADIUS_TABLE = {"Wide", "Large", "Massive", "Gigantic", "Gargantuan"}
PREFIX_BLASTER_RANGE_TABLE = {"Scoped", "Narrow", "Extended", "Modified", "Launching"}
PREFIX_BLASTER_COOLDOWN_TABLE = {"Speedy", "Hasty", "Reckless", "Swift", "Fulminating"}
PREFIX_BLASTER_MODIFIER_MAGNITUDE_FIRE_TABLE = {"Charred", "Flaming", "Blazing", "Melting", "Cauterizing"}
PREFIX_BLASTER_MODIFIER_MAGNITUDE_ICE_TABLE = {"Chilling", "Frigid", "Frosty", "Frostbitten", "Glacial"}
PREFIX_BLASTER_MODIFIER_MAGNITUDE_WIND_TABLE = {"Fluttering", "Flurry", "Zephyr", "Tempest", "Galeforce"}
PREFIX_BLASTER_MODIFIER_DURATION_TABLE = {"Enduring", "Effective", "Efficient", "Potent", "Striking"}
PREFIX_BLASTER_MOVESPEED_BUFF = {"Quickening", "Mad", "Crazy", "Berserker's", "Expeditioner's"}
PREFIX_BLASTER_BLINK = {"Flickering", "Blinking", "Teleporting", "Time-Warping", "Space-Bending"}

function RPCItems:RollBlasterProperty2(item, xpBounty)
    local luck = RandomInt(0,100)
    if luck < 30 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 40, 90, 1, 4, item.rarity, false, nil)
        item.property2 = value
        item.property2name = "damage"
        prefix = PREFIX_BLASTER_DAMAGE_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_bonus_damage", "#E67607",  2)
    elseif luck >= 30 and luck < 40 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 20, 70, 1, 1, item.rarity, false, 1100)
        item.property2 = value
        item.property2name = "radius"
        prefix = PREFIX_BLASTER_RADIUS_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_end_radius", "#D8ED1C",  2)
    elseif luck >= 40 and luck < 50 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 20, 70, 1, 1, item.rarity, false, 1100)
        item.property2 = value
        item.property2name = "range"
        prefix = PREFIX_BLASTER_RANGE_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_range_increase", "#D8ED1C",  2)
    elseif luck >= 50 and luck < 60 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 20, 60, 1, 1, item.rarity, true, nil)
        item.property2 = value
        item.property2name = "cooldown"
        prefix = PREFIX_BLASTER_COOLDOWN_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_cooldown_reduce", "#D1D1D1",  2)
    elseif luck >= 60 and luck < 70 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 5, 10, 1, 1, item.rarity, false, nil)
        item.property2 = value
        item.property2name = "modifier_magnitude"
        if item.type == "fire" then
            description = "item_burn_damage"
            prefix = PREFIX_BLASTER_MODIFIER_MAGNITUDE_FIRE_TABLE[prefixLevel]
            color = "#DB5C5C"
        elseif item.type == "ice" then
            description = "item_move_slow"
            prefix = PREFIX_BLASTER_MODIFIER_MAGNITUDE_ICE_TABLE[prefixLevel]
            color = "#B9E1ED"
        elseif item.type == "wind" then
            description = "item_miss_chance"
            prefix = PREFIX_BLASTER_MODIFIER_MAGNITUDE_WIND_TABLE[prefixLevel]
            color = "#5CDB7A"
        end
        RPCItems:SetPropertyValues(item, item.property2, description, color,  2) 
    elseif luck >= 70 and luck < 80 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 10, 50, 1, 1, item.rarity, true, nil)
        item.property2 = value
        item.property2name = "modifier_duration"
        prefix = PREFIX_BLASTER_MODIFIER_DURATION_TABLE[prefixLevel]
        if item.type == "fire" then
            description = "item_burn_duration"
        elseif item.type == "ice" then
            description = "item_frost_duration"
        elseif item.type == "wind" then
            description = "item_windshear_duration"
        end
        RPCItems:SetPropertyValues(item, item.property2, description, "#1975FF",  2) 
    elseif luck >= 80 and luck < 87 then
        value = 1
        item.property2 = value
        item.property2name = "extra_shots"
        prefix = "Double"
        RPCItems:SetPropertyValues(item, item.property2, "#item_extra_shots", "#FC0000",  2)
    elseif luck >= 87 and luck < 101 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 30, 60, 1, 10, item.rarity, true, nil)
        item.property2 = value
        item.property2name = "movespeed"
        prefix = PREFIX_BLASTER_MOVESPEED_BUFF[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_movespeed_buff", "#07EBEB",  2)      
    else
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 60, 120, 1, 1, item.rarity, false, 1500)
        item.property2 = value
        item.property2name = "blink"
        prefix = PREFIX_BLASTER_BLINK[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_blink_distance", "#0094DE",  2)   
    end
    return prefix


end

BLASTER_NAME_TABLE_FIRE = {"Deadly Fire Cannon", "Ruthless Fire Cannon", "Savage Fire Cannon", "Lethal Fire Cannon", "Bloodthirsty Fire Cannon"}
BLASTER_NAME_TABLE_ICE = {"Deadly Ice Cannon", "Ruthless Ice Cannon", "Savage Ice Cannon", "Lethal Ice Cannon", "Bloodthirsty Ice Cannon"}
BLASTER_NAME_TABLE_WIND = {"Deadly Wind Cannon", "Ruthless Wind Cannon", "Savage Wind Cannon", "Lethal Wind Cannon", "Bloodthirsty Wind Cannon"}

function RPCItems:RollBlasterProperty3(item, xpBounty)
    local luck = RandomInt(0,100)
    if luck < 40 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 80, 110, 1, 2, item.rarity, false, nil)
        item.property3 = value
        item.property3name = "damage"
        RPCItems:SetPropertyValues(item, item.property3, "#item_bonus_damage", "#E67607", 3)
    elseif luck >= 40 and luck < 50 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 50, 1, 1, item.rarity, true, nil)
        item.property3 = value
        item.property3name = "cooldown"
        RPCItems:SetPropertyValues(item, item.property3, "#item_cooldown_reduce", "#D1D1D1", 3)
    elseif luck >= 50 and luck < 65 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 5, 10, 1, 2, item.rarity, false, nil)
        item.property3 = value
        item.property3name = "modifier_magnitude"
        if item.type == "fire" then
            description = "#item_burn_damage"
            color = "#DB5C5C"
        elseif item.type == "ice" then
            description = "#item_move_slow"
            color = "#B9E1ED"
        elseif item.type == "wind" then
            description = "#item_miss_chance"
            color = "#5CDB7A"
        end
        RPCItems:SetPropertyValues(item, item.property3, description, color, 3) 
    elseif luck >= 65 and luck < 80 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 50, 1, 1, item.rarity, true, nil)
        item.property3 = value
        item.property3name = "modifier_duration"
        if item.type == "fire" then
            description = "#item_burn_duration"
        elseif item.type == "ice" then
            description = "#item_frost_duration"
        elseif item.type == "wind" then
            description = "#item_windshear_duration"
        end
        RPCItems:SetPropertyValues(item, item.property3, description, "#1975FF", 3) 
    elseif luck >= 80 and luck < 87 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 100, 300, 3, 8, item.rarity, false, nil)
        item.property3 = value
        item.property3name = "health_restore"
        RPCItems:SetPropertyValues(item, item.property3, "#item_cannon_health_restore", "#99FF66", 3)      
    else
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 50, 150, 2, 4, item.rarity, false)
        item.property3 = value
        item.property3name = "mana_restore"
        RPCItems:SetPropertyValues(item, item.property3, "#item_cannon_mana_restore", "#1975FF", 3, nil)  
    end
    --if item.type == "fire" then
    --    name = BLASTER_NAME_TABLE_FIRE[nameLevel]
    --elseif item.type == "ice" then
    --    name = BLASTER_NAME_TABLE_ICE[nameLevel]
    --elseif item.type == "wind" then
    --    name = BLASTER_NAME_TABLE_WIND[nameLevel]
    --end
    name = "debug"
    return name


end

PREFIX_BLASTER_DAMAGE_TABLE2 = {"Damaging ", "Blasting ", "52S-", "Devastating ", "Crushing "}
PREFIX_BLASTER_COOLDOWN_TABLE2 = {"Multi-", "Relentless ", "Crashed ", "Designated ", "Lucid "}
PREFIX_BLASTER_MODIFIER_MAGNITUDE_FIRE_TABLE2 = {"Burn ", "Crackle ", "Pyromatic ", "Dragon ", "Dragon God's "}
PREFIX_BLASTER_MODIFIER_MAGNITUDE_ICE_TABLE2 = {"Freeze ", "Cold ", "Polar ", "Crystal ", "Maiden "}
PREFIX_BLASTER_MODIFIER_MAGNITUDE_WIND_TABLE2 = {"Slip ", "Rip ", "Slicer ", "God's ", "Nova "}
PREFIX_BLASTER_MODIFIER_DURATION_TABLE2 = {"Everlasting ", "Infinity ", "Eternity ", "Eternity ", "Eternity "}
PREFIX_BLASTER_MOVESPEED_BUFF2 = {"Quickening ", "Mad ", "Crazy ", "Berserker's ", "Expeditioner's "}
PREFIX_BLASTER_BLINK2 = {"Flickering ", "Blinking ", "Teleporting ", "Time-Warping ", "Space-Bending "}

function RPCItems:RollBlasterProperty4(item, xpBounty)
    local luck = RandomInt(0,100)
    if luck < 40 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 100, 120, 1, 2, item.rarity, false, nil)
        item.property4 = value
        item.property4name = "damage"
        prefix2 = PREFIX_BLASTER_DAMAGE_TABLE2[nameLevel]
        RPCItems:SetPropertyValues(item, item.property4, "#item_bonus_damage", "#E67607", 4)
    elseif luck >= 40 and luck < 50 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 50, 1, 1, item.rarity, true, nil)
        item.property4 = value
        item.property4name = "cooldown"
        prefix2 = PREFIX_BLASTER_COOLDOWN_TABLE2[nameLevel]
        RPCItems:SetPropertyValues(item, item.property4, "#item_cooldown_reduce", "#D1D1D1", 4)
    elseif luck >= 50 and luck < 65 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 5, 10, 1, 2, item.rarity, false, nil)
        item.property4 = value
        item.property4name = "modifier_magnitude"
        if item.type == "fire" then
            description = "#item_burn_damage"
            prefix2 = PREFIX_BLASTER_MODIFIER_MAGNITUDE_FIRE_TABLE2[nameLevel]
            color = "#DB5C5C"
        elseif item.type == "ice" then
            description = "#item_move_slow"
            prefix2 = PREFIX_BLASTER_MODIFIER_MAGNITUDE_ICE_TABLE2[nameLevel]
            color = "#B9E1ED"
        elseif item.type == "wind" then
            description = "#item_miss_chance"
            prefix2 = PREFIX_BLASTER_MODIFIER_MAGNITUDE_WIND_TABLE2[nameLevel]
            color = "#5CDB7A"
        end
        RPCItems:SetPropertyValues(item, item.property4, description, color, 4) 
    elseif luck >= 65 and luck < 80 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 50, 1, 1, item.rarity, true, nil)
        item.property4 = value
        item.property4name = "modifier_duration"
        if item.type == "fire" then
            description = "#item_burn_duration"
            prefix2 = PREFIX_BLASTER_BLINK[nameLevel]
        elseif item.type == "ice" then
            description = "#item_frost_duration"
            prefix2 = PREFIX_BLASTER_BLINK[nameLevel]
        elseif item.type == "wind" then
            description = "#item_windshear_duration"
            prefix2 = PREFIX_BLASTER_BLINK[nameLevel]
        end
        RPCItems:SetPropertyValues(item, item.property4, description, "#1975FF", 4) 
    elseif luck >= 80 and luck < 87 then
        item.property4 = 1
        item.property4name = "torrent"
        prefix2 = "Torrential"
        RPCItems:SetPropertyValues(item, item.property4, "#item_cannon_torrent", "#287EC9", 4)      
    else
        item.property4 = 1
        item.property4name = "moon_shroud"
        prefix2 = "Lunar"
        RPCItems:SetPropertyValues(item, item.property4, "#item_cannon_moon_shroud", "#8060B3", 4)  
    end
    return prefix2


end


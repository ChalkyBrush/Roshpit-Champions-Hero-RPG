BASE_BOOT_TABLE = {"item_rpc_slippers", "item_rpc_boots", "item_rpc_treads"}
BASE_BOOT_NAME_TABLE = {"Slippers", "Boots", "Treads"}

function RPCItems:RollFoot(xpBounty, deathLocation, rarity, isShop, type, hero, unitLevel)
	local randomHelm = RandomInt(1, 3)
    if isShop then
        randomHelm = type
    end
	local itemVariant = BASE_BOOT_TABLE[randomHelm]
    local item = RPCItems:CreateItem(itemVariant, nil, nil)



    item.rarity = rarity
    local rarityValue = RPCItems:GetRarityFactor(rarity)
    local itemName = BASE_BOOT_NAME_TABLE[randomHelm]
    item.slot = "feet"
    item.gear = true
    if rarityValue == 5 then
        if RPCItems:FootLegendary(itemVariant, deathLocation) then
			RPCItems:ItemUTIL_Remove(item)
            return nil
        end
    end
    local prefix = ""
    local additional_prefix = ""
    local suffix = RPCItems:RollFootProperty1(item, xpBounty, randomHelm)
    if rarityValue >= 2 then
    	prefix = RPCItems:RollFootProperty2(item, xpBounty)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollFootProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	additional_prefix = RPCItems:RollFootProperty4(item, xpBounty)
    	itemName = additional_prefix.." "..itemName
    end

    RPCItems:SetTableValues(item, itemName, false, "Slot: Feet", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    if isShop then
        RPCItems:GiveItemToHero(hero, item)
    else
        local drop = CreateItemOnPositionSync( deathLocation, item )
        local position = deathLocation
        RPCItems:DropItem(item, position)
    end
end

function RPCItems:FootLegendary(itemVariant, deathLocation)
    if itemVariant == "item_rpc_slippers" then
        local luck = RandomInt(1, 9)
        if luck == 1 then
            RPCItems:SlingerBoots(deathLocation)
            return true
        elseif luck == 2 then
            RPCItems:RollManaStriders(deathLocation)
            return true
        elseif luck == 3 then
            RPCItems:RollFalconBoots(deathLocation)
            return true
        elseif luck == 4 then
            RPCItems:RollAdmiralBoot(deathLocation)
            return true
        elseif luck == 5 then
            RPCItems:RollArcanysSlipper(deathLocation)
            return true
        elseif luck == 6 then
            RPCItems:RollResonantPathfinderBoots(deathLocation)
            return true
        elseif luck == 7 then
            RPCItems:RollBlueDragonGreaves(deathLocation)
            return true
        elseif luck == 8 then
            RPCItems:RollBootsOfOldWisdom(deathLocation)
            return true
        elseif luck == 9 then
            RPCItems:RollSandstreamSlippers(deathLocation)
            return true
        end
    elseif itemVariant == "item_rpc_boots" then
        local luck = RandomInt(1, 9)
        if luck == 1 then
            RPCItems:RollDunetreadBoots(deathLocation)
            return true
        elseif luck == 2 then
            local arcanaLuck = RandomInt(1, 960)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollConjurorArcana4(deathLocation)
                return true
            end
            RPCItems:RollVioletTreads(deathLocation)
            return true
        elseif luck == 3 then
            RPCItems:RollSangeBoots(deathLocation)
            return true
        elseif luck == 4 then
            RPCItems:RollMoonTechs(deathLocation)
            return true
        elseif luck == 5 then
            RPCItems:RollTranquilBoots(deathLocation)
            return true
        elseif luck == 6 then
            RPCItems:RollVoyagerBoots(deathLocation)
            return true
        elseif luck == 7 then
            RPCItems:RollNeptunesWaterGliders(deathLocation)
            return true
        elseif luck == 8 then
            local arcanaLuck = RandomInt(1, 800)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollVoltexArcana1(deathLocation)
                return true
            end
            RPCItems:RollResplendantRubberBoots(deathLocation)
            return true
        elseif luck == 9 then
            RPCItems:RollTemporalWarpBoots(deathLocation)
            return true
        end
    elseif itemVariant == "item_rpc_treads" then
        local luck = RandomInt(1, 9)
        if luck == 1 then
            RPCItems:RollGuardianGreaves(deathLocation)
            return true
        elseif luck == 2 then
            local arcanaLuck = RandomInt(1, 980)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollMountainProtectorArcana3(deathLocation)
                return true
            end
            RPCItems:RollFireWalkers(deathLocation)
            return true
        elseif luck == 3 then
            local arcanaLuck = RandomInt(1, 860)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollZhonikArcana1(deathLocation)
                return true
            end
            RPCItems:RollSonicBoots(deathLocation)
            return true
        elseif luck == 4 then
            RPCItems:RollRootedFeet(deathLocation)
            return true
        elseif luck == 5 then
            RPCItems:RollCrusaderBoots(deathLocation)
            return true
        elseif luck == 6 then
            RPCItems:RollRedrockFootwear(deathLocation)
            return true
        elseif luck == 7 then
            local arcanaLuck = RandomInt(1, 860)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollSeinaruArcana2(deathLocation)
                return true
            end
            RPCItems:RollYashaBoots(deathLocation)
            return true
        elseif luck == 8 then
            RPCItems:RollAblecoreGreaves(deathLocation)
            return true
        elseif luck == 9 then
            local arcanaLuck = RandomInt(1, 980)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollChernobogArcana2(deathLocation)
                return true
            end
            RPCItems:RollSteamboots(deathLocation)
            return true
        end
    end
    return false
end


SUFFIX_MOVESPEED_TABLE = {"of Haste", "of Celerity", "of Alacrity", "of the Unicorn", "of Lightning Skies"}
SUFFIX_MOVESPEED_MAX_TABLE = {"of Proficiency", "of Artistry", "of Alacrity", "of the Unicorn", "of Lightning Skies"}

function RPCItems:RollFootProperty1(item, xpBounty, randomHelm)
    local luck = RandomInt(0,100)
    if Events.reroll then
        luck = RandomInt(0, 89)
    end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local suffixLevel = 1
    if luck < 10 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 4+bonus, 0, 0, item.rarity, false, maxFactor*10)
        suffix = SUFFIX_HOOD_STRENGTH_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_strength", "#CC0000",  1)
    elseif luck >= 10 and luck < 20 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 4+bonus, 0, 0, item.rarity, false, maxFactor*10)
        suffix = SUFFIX_HOOD_AGILITY_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_agility", "#2EB82E",  1)
    elseif luck >= 20 and luck < 30 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 4+bonus, 0, 0, item.rarity, false, maxFactor*10)
        suffix = SUFFIX_HOOD_INTELLIGENCE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_intelligence", "#33CCFF",  1)
    elseif luck >= 30 and luck < 40 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 5)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 2+bonus, 0, 0, item.rarity, false, 5)
        suffix = SUFFIX_HOOD_MAGIC_RESIST_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_magic_resist", "#AC47DE",  1)
    elseif luck >= 40 and luck < 50 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 6)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 2+bonus, 0, 0, item.rarity, false, maxFactor*3)
        suffix = SUFFIX_HOOD_ARMOR_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_armor", "#D1D1D1",  1)
    elseif luck >= 50 and luck < 60 then
    	local bonus = 0
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 8+bonus, 0, 0, item.rarity, false, 120)
        suffix = SUFFIX_MOVESPEED_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_movespeed", "#B02020",  1) 
    elseif luck >= 60 and luck < 75 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 3)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 3+bonus, 0, 0, item.rarity, false, maxFactor*4)
        suffix = SUFFIX_HEALTH_REGEN_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_health_regen", "#6AA364",  1)
    elseif luck >= 75 and luck < 90 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 3)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 5+bonus, 0, 0, item.rarity, false, maxFactor*3)
        suffix = SUFFIX_MANA_REGEN_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_mana_regen", "#649FA3",  1)
    elseif luck >= 90 and luck <= 100 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 5)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 0, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        suffix = SUFFIX_RESPAWN_REDUCE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_min_level_reduction", "#F28100",  1)             
    end
    return suffix
end

PREFIX_MOVESPEED_TABLE = {"Dash", "Rush", "Mercury", "Sonic", "Pegasus"}

function RPCItems:RollFootProperty2(item, xpBounty)
    local luck = RandomInt(0,100)
    if Events.reroll then
        luck = RandomInt(0, 89)
    end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local prefixLevel = 1
    if luck < 10 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 10)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, maxFactor*12)
        prefix = PREFIX_HOOD_STRENGTH_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_strength", "#CC0000",  2)
    elseif luck >= 10 and luck < 20 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 10)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, maxFactor*12)
        prefix = PREFIX_HOOD_AGILITY_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_agility", "#2EB82E",  2)
    elseif luck >= 20 and luck < 30 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 10)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, maxFactor*12)
        prefix = PREFIX_HOOD_INTELLIGENCE_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_intelligence", "#33CCFF",  2)
    elseif luck >= 30 and luck < 40 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 10)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, 12)
        prefix = PREFIX_HOOD_MAGIC_RESIST_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_magic_resist", "#AC47DE",  2)
    elseif luck >= 40 and luck < 50 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 6)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 2+bonus, 0, 0, item.rarity, false, maxFactor*3)
        prefix = PREFIX_HOOD_ARMOR_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_armor", "#D1D1D1",  2)
    elseif luck >= 50 and luck < 60 then
    	local bonus = 0
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 8+bonus, 0, 0, item.rarity, false, 120)
        prefix = PREFIX_MOVESPEED_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_movespeed", "#B02020",  2)
    elseif luck >= 60 and luck < 75 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 4)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 4+bonus, 0, 0, item.rarity, false, maxFactor*3)
        prefix = PREFIX_HEALTH_REGEN_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_health_regen", "#6AA364",  2)
    elseif luck >= 75 and luck < 90 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 5)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 7+bonus, 0, 0, item.rarity, false, maxFactor*4)
        prefix = PREFIX_MANA_REGEN_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_mana_regen", "#649FA3",  2)
    elseif luck >= 90 and luck <= 100 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 2)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 0, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        prefix = PREFIX_RESPAWN_REDUCE_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, value, "#item_min_level_reduction", "#F28100",  2)             
    end
    return prefix
end



function RPCItems:RollFootProperty3(item, xpBounty)
    local luck = RandomInt(0,110)
    if Events.reroll then
        luck = RandomInt(0, 99)
    end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local prefixLevel  = 1
    if luck < 10 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 20, 0, 0, item.rarity, false, maxFactor*12)
        RPCItems:SetPropertyValues(item, value, "#item_strength", "#CC0000",  3)
    elseif luck >= 10 and luck < 20 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 20, 0, 0, item.rarity, false, maxFactor*12)
        RPCItems:SetPropertyValues(item, value, "#item_agility", "#2EB82E",  3)
    elseif luck >= 20 and luck < 30 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 20, 0, 0, item.rarity, false, maxFactor*12)
        RPCItems:SetPropertyValues(item, value, "#item_intelligence", "#33CCFF",  3)
    elseif luck >= 30 and luck < 40 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 30, 0, 0, item.rarity, false, 10)
        RPCItems:SetPropertyValues(item, value, "#item_magic_resist", "#AC47DE",  3)
    elseif luck >= 40 and luck < 50 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 4, 0, 0, item.rarity, false, maxFactor*4)
        RPCItems:SetPropertyValues(item, value, "#item_armor", "#D1D1D1",  3)
    elseif luck >= 50 and luck < 60 then
    	local bonus = 0
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 8+bonus, 0, 0, item.rarity, false, 120)
        RPCItems:SetPropertyValues(item, value, "#item_movespeed", "#B02020",  3)
    elseif luck >= 60 and luck < 75 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 4, 0, 0, item.rarity, false, maxFactor*5)
        RPCItems:SetPropertyValues(item, value, "#item_health_regen", "#6AA364",  3)
    elseif luck >= 75 and luck < 90 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 5, 0, 0, item.rarity, false, maxFactor*4)
        RPCItems:SetPropertyValues(item, value, "#item_mana_regen", "#649FA3",  3)
    elseif luck >= 90 and luck < 100 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 2, 10, 0, 0, item.rarity, false, math.ceil(maxFactor/5))
        RPCItems:SetPropertyValues(item, value, "#item_base_ability", "#7AB4CC",  3)       
    elseif luck >= 100 and luck <= 110 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 0, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        RPCItems:SetPropertyValues(item, value, "#item_min_level_reduction", "#F28100",  3)             
    end
end


PREFIX_BOOT_TABLE2 = {"Centaur", "Cerberus", "Gryphon", "Thunderbird", "Manticore", "Mephisto", "Minotaur", "Amazon"}

function RPCItems:RollFootProperty4(item, xpBounty)
   local luck = RandomInt(0,110)
    if Events.reroll then
        luck = RandomInt(0, 99)
    end
   local maxFactor = RPCItems:GetMaxFactor()
   local value = 0
   local nameLevel = 1
    if luck < 10 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 40, 0, 0, item.rarity, false, maxFactor*17)
        RPCItems:SetPropertyValues(item, value, "#item_strength", "#CC0000",  4)
    elseif luck >= 10 and luck < 20 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 40, 0, 0, item.rarity, false, maxFactor*17)
        RPCItems:SetPropertyValues(item, value, "#item_agility", "#2EB82E",  4)
    elseif luck >= 20 and luck < 30 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 40, 0, 0, item.rarity, false, maxFactor*17)
        RPCItems:SetPropertyValues(item, value, "#item_intelligence", "#33CCFF",  4)
    elseif luck >= 30 and luck < 40 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 10, 0, 0, item.rarity, false, 8)
        RPCItems:SetPropertyValues(item, value, "#item_magic_resist", "#AC47DE",  4)
    elseif luck >= 40 and luck < 50 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 5, 0, 0, item.rarity, false, maxFactor*6)
        RPCItems:SetPropertyValues(item, value, "#item_armor", "#D1D1D1",  4)
    elseif luck >= 50 and luck < 60 then
        value, nameLevel  = RPCItems:RollAttribute(xpBounty, 1, 8, 0, 0, item.rarity, false, 120)
        RPCItems:SetPropertyValues(item, value, "#item_movespeed", "#B02020",  4)
    elseif luck >= 60 and luck < 75 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 10, 0, 0, item.rarity, false, maxFactor*5)
        RPCItems:SetPropertyValues(item, value, "#item_health_regen", "#6AA364",  4)
    elseif luck >= 75 and luck < 90 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 8, 0, 0, item.rarity, false, maxFactor*4)
        RPCItems:SetPropertyValues(item, value, "#item_mana_regen", "#649FA3",  4)
    elseif luck >= 90 and luck < 100 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 2, 10, 0, 0, item.rarity, false, math.ceil(maxFactor/4.7))
        RPCItems:SetPropertyValues(item, value, "#item_base_ability", "#7AB4CC",  4)       
    elseif luck >= 100 and luck <= 110 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 1, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        RPCItems:SetPropertyValues(item, value, "#item_min_level_reduction", "#F28100",  4)             
    end
    local name = PREFIX_BOOT_TABLE2[RandomInt(1,8)]
    return name
end


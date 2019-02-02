BASE_HEAD_TABLE = {"item_hood", "item_cap", "item_helm"}
BASE_HEAD_NAME_TABLE = {"Hood", "Cap", "Helm"}

function RPCItems:RollHood(xpBounty, deathLocation, rarity, isShop, type, hero, unitLevel)
	local randomHelm = RandomInt(1, 3)
    if isShop then
        randomHelm = type
    end
	local itemVariant = BASE_HEAD_TABLE[randomHelm]
    local item = RPCItems:CreateItem(itemVariant, nil, nil)



    item.rarity = rarity
    local rarityValue = RPCItems:GetRarityFactor(rarity)
    local itemName = BASE_HEAD_NAME_TABLE[randomHelm]
    item.slot = "head"
    item.gear = true

    if rarityValue == 5 then
        if RPCItems:HoodLegendary(itemVariant, deathLocation, isShop) then
			UTIL_Remove(item)
            return nil
        end
    end
    local prefix = ""
    local additional_prefix = ""
    local suffix = RPCItems:RollHoodProperty1(item, xpBounty, randomHelm)
    if rarityValue >= 2 then
    	prefix = RPCItems:RollHoodProperty2(item, xpBounty)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollHoodProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	additional_prefix = RPCItems:RollHoodProperty4(item, xpBounty)
    	itemName = additional_prefix.." "..itemName
    end

    RPCItems:SetTableValues(item, itemName, false, "Slot: Head", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    if isShop then
        item.isShop = true
        RPCItems:GiveItemToHero(hero, item)
    else
        local drop = CreateItemOnPositionSync( deathLocation, item)
        local position = deathLocation
        RPCItems:DropItem(item, position)
    end
end

function RPCItems:HoodLegendary(itemVariant, deathLocation, isShop)
    if itemVariant == "item_hood" then
        local luck = RandomInt(1, 11)
        if luck == 1 then
            local arcanaLuck = RandomInt(1, 680)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                local luck = RandomInt(1, 2)
                if luck == 1 then
                    RPCItems:RollAuriunArcana1(deathLocation)
                else
                    RPCItems:RollAuriunArcana2(deathLocation)
                end
                return true
            end
            RPCItems:RollWhiteMageHat(deathLocation, isShop)
            return true
        elseif luck == 2 then
            RPCItems:RollDeathWhisperHelm(deathLocation, isShop)
            return true
        elseif luck == 3 then
            local arcanaLuck = RandomInt(1, 880)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollSoluniaArcana1(deathLocation)
                return true
            end
            RPCItems:RollLumaGuard(deathLocation, isShop)
            return true
        elseif luck == 4 then
            RPCItems:RollWitchHat(deathLocation, isShop)
            return true
        elseif luck == 5 then
            local arcanaLuck = RandomInt(1, 840)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollEpochArcana1(deathLocation)
                return true
            end
            RPCItems:RollEmeraldDouli(deathLocation, isShop)
            return true
        elseif luck == 6 then
            RPCItems:RollCeruleanHighguard(deathLocation, isShop)
            return true
        elseif luck == 7 then
            RPCItems:RollArcaneCascadeHat(deathLocation, isShop)
            return true
        elseif luck == 8 then
            RPCItems:RollEternalNightShroud(deathLocation, isShop)
            return true
        elseif luck == 9 then
            RPCItems:RollWraithCrown(deathLocation, isShop)
            return true
        elseif luck == 10 then
            local arcanaLuck = RandomInt(1, 840)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
               RPCItems:RollSorceressArcana2(deathLocation)
                return true
            end
            RPCItems:RollCarbuncleHelm(deathLocation, isShop)
            return true
        elseif luck == 11 then
            RPCItems:RollExcavatorsFocusHat(deathLocation, isShop)
            return true
        end
    elseif itemVariant == "item_cap" then
        local luck = RandomInt(1, 12) 
        if luck == 1 then
            local arcanaLuck = RandomInt(1, 980)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollVoltexArcana2(deathLocation)
                return true
            end
            RPCItems:RollHyperVisor(deathLocation, isShop)
            return true
        elseif luck == 2 then
            RPCItems:RollHoodOfChosen(deathLocation, isShop)
            return true           
        elseif luck == 3 then
            RPCItems:RollCapOfWildNature(deathLocation, isShop)
            return true
        elseif luck == 4 then
            RPCItems:RollMugatoMask(deathLocation, isShop)
            return true
        elseif luck == 5 then
            RPCItems:RollTricksterMask(deathLocation, isShop)
            return true
        elseif luck == 6 then
            local arcanaLuck = RandomInt(1, 800)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollArkimusArcana1(deathLocation)
                return true
            end
            RPCItems:RollSuperAscendency(deathLocation, isShop)
            return true
        elseif luck == 7 then
            RPCItems:RollScourgeKnightHelm(deathLocation, isShop)
            return true
        elseif luck == 8 then
            RPCItems:RollDruidsSpiritHelm(deathLocation, isShop)
            return true
        elseif luck == 9 then
            RPCItems:RollBrazenKabuto(deathLocation, isShop)
            return true
        elseif luck == 10 then
            local arcanaLuck = RandomInt(1, 800)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollAstralArcana1(deathLocation)
                return true
            end
            RPCItems:RollCrestOfTheUmbralSentinel(deathLocation, isShop)
            return true
        elseif luck == 11 then
            RPCItems:RollWraithHuntersSteelHelm(deathLocation, isShop)
            return true
        elseif luck == 12 then
            RPCItems:RollHelmOfSilentTemplar(deathLocation, isShop)
            return true
        end   
    elseif itemVariant == "item_helm" then
        local luck = RandomInt(1, 12)  
        if luck == 1 then
            local arcanaLuck = RandomInt(1, 800)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollFlamewakerArcana1(deathLocation)
                return true
            end
            RPCItems:RollRubyDragonCrown(deathLocation, isShop)
            return true
        elseif luck == 2 then
            RPCItems:RollCentaurHorns(deathLocation, isShop)
            return true
        elseif luck == 3 then
            RPCItems:RollOdinHelmet(deathLocation, isShop)
            return true
        elseif luck == 4 then
            RPCItems:RollIronColossus(deathLocation, isShop)
            return true
        elseif luck == 5 then
            RPCItems:RollMaskOfTyrius(deathLocation, isShop)
            return true
        elseif luck == 6 then
            RPCItems:RollPhantomSorcererMask(deathLocation, isShop)
            return true
        elseif luck == 7 then
            local arcanaLuck = RandomInt(1, 800)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollSeinaruArcana1(deathLocation)
                return true
            end
            RPCItems:RollSamuraiHelmet(deathLocation, isShop)
            return true
        elseif luck == 8 then
            RPCItems:RollGlintOfOnu(deathLocation, isShop)
            return true
        elseif luck == 9 then
            local arcanaLuck = RandomInt(1, 960)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollConjurorArcana3(deathLocation)
                return true
            end
            RPCItems:RollRoknarEmperor(deathLocation, isShop)
            return true
        elseif luck == 10 then
            local arcanaLuck = RandomInt(1, 960)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollEkkanArcana1(deathLocation)
                return true
            end
            RPCItems:RollGuardOfGrithault(deathLocation, isShop)
            return true
        elseif luck == 11 then
            RPCItems:RollHoodOfDefiler(deathLocation, isShop)
            return true
        elseif luck == 12 then
            RPCItems:RollStormcrackHelm(deathLocation, isShop)
            return true
        end
    end
    return false
end



SUFFIX_HOOD_STRENGTH_TABLE = {"of the Bear", "of the Warrior", "of the Mountain", "of the Behemoth", "of Titans"}
SUFFIX_HOOD_AGILITY_TABLE = {"of the Rabbit", "of the Swift", "of the Cheetah", "of the Wind", "of the Ninja"}
SUFFIX_HOOD_INTELLIGENCE_TABLE = {"of Understanding", "of the Wise", "of Greater Intelligence", "of Great Brilliance", "of The Grand Magus"}
SUFFIX_HOOD_MAGIC_RESIST_TABLE = {"of Softening", "of Protection", "of Mitigation", "of Dampening", "of Great Dampening"}
SUFFIX_HOOD_ARMOR_TABLE = {"of Protection", "of Greater Protection", "of Mitigation", "of Dampening", "of Great Dampening"}
SUFFIX_HEALTH_REGEN_TABLE = {"of Healing", "of Restoration", "of Major Healing", "of Life", "of Great Restoration"}
SUFFIX_MANA_REGEN_TABLE = {"of Refreshment", "of Greater Refreshment", "of Shielding", "of Greater Shielding", "of Untouchability"}
SUFFIX_MAX_HEALTH_TABLE = {"of the Whale", "of Life", "of Longevity", "of Vitality", "of the Colossus"}
SUFFIX_MAX_MANA_TABLE = {"of Wisdom", "of the Moon", "of the Stars", "of the Blue Moon", "of the Blue Stars"}
SUFFIX_RESPAWN_REDUCE_TABLE = {"of Reincarnation", "of Reincarnation", "of Redemption", "of the Phoenix", "of Immortality"}

function RPCItems:GetHeadBonusRoll(randomHelm, looking, bonus)
	if randomHelm == looking then
		return bonus
	else
		return 0
	end
end

function RPCItems:RollHoodProperty1(item, xpBounty, randomHelm)
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
        item.property1 = value
        item.property1name = "strength"
        suffix = SUFFIX_HOOD_STRENGTH_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_strength", "#CC0000",  1)
    elseif luck >= 10 and luck < 20 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 4+bonus, 0, 0, item.rarity, false, maxFactor*10)
        item.property1 = value
        item.property1name = "agility"
        suffix = SUFFIX_HOOD_AGILITY_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_agility", "#2EB82E",  1)
    elseif luck >= 20 and luck < 30 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 4+bonus, 0, 0, item.rarity, false, maxFactor*10)
        item.property1 = value
        item.property1name = "intelligence"
        suffix = SUFFIX_HOOD_INTELLIGENCE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_intelligence", "#33CCFF",  1)
    elseif luck >= 30 and luck < 40 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 5)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 7+bonus, 0, 0, item.rarity, false, 7)
        item.property1 = value
        item.property1name = "magic_resist"
        suffix = SUFFIX_HOOD_MAGIC_RESIST_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_magic_resist", "#AC47DE",  1)
    elseif luck >= 40 and luck < 50 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 2+bonus, 0, 0, item.rarity, false, maxFactor*3)
        item.property1 = value
        item.property1name = "armor"
        suffix = SUFFIX_HOOD_ARMOR_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_armor", "#D1D1D1",  1)
    elseif luck >= 50 and luck < 60 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 200)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 50, 200+bonus, 1, 1, item.rarity, false, maxFactor*200)
        item.property1 = value
        item.property1name = "max_health"
        suffix = SUFFIX_MAX_HEALTH_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_max_health", "#B02020",  1)
    elseif luck >= 60 and luck < 70 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 100)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 50, 150+bonus, 0, 1, item.rarity, false, maxFactor*80)
        item.property1 = value
        item.property1name = "max_mana"
        suffix = SUFFIX_MAX_MANA_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_max_mana", "#343EC9",  1)   
    elseif luck >= 70 and luck < 80 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 5)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 11+bonus, 0, 0, item.rarity, false, maxFactor*7)
        item.property1 = value
        item.property1name = "health_regen"
        suffix = SUFFIX_HEALTH_REGEN_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_health_regen", "#6AA364",  1)
    elseif luck >= 80 and luck < 90 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 5)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 6+bonus, 0, 0, item.rarity, false, maxFactor*4)
        item.property1 = value
        item.property1name = "mana_regen"
        suffix = SUFFIX_MANA_REGEN_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_mana_regen", "#649FA3",  1)
    elseif luck >= 90 and luck <= 100 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 5)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 0, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        item.property1 = value
        item.property1name = "level_reduce"
        suffix = SUFFIX_RESPAWN_REDUCE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_min_level_reduction", "#F28100",  1)             
    end
    return suffix
end

PREFIX_HOOD_STRENGTH_TABLE = {"Soldier's", "Ogre's", "Beastial", "Mammoth's", "Giant's"}
PREFIX_HOOD_AGILITY_TABLE = {"Nimble", "Adept", "Hasty", "Agile", "Skillful"}
PREFIX_HOOD_INTELLIGENCE_TABLE = {"Intelligent", "Perceptive", "Brilliant", "Enlightened", "Sage's"}
PREFIX_HOOD_MAGIC_RESIST_TABLE = {"Enchanted", "Charmed", "Magnetic", "Spellbound", "Hypnotizing"}
PREFIX_HOOD_ARMOR_TABLE = {"Thick", "Reinforced", "Augmented", "Braced", "Fortified"}
PREFIX_HEALTH_REGEN_TABLE = {"Mending", "Refreshing", "Refreshing", "Rejuvenating", "Wellspring"}
PREFIX_MANA_REGEN_TABLE = {"Replenishing", "Soul", "Mind", "Spirit", "Animus"}
PREFIX_MAX_HEALTH_TABLE = {"Large", "Massive", "Immense", "Colossal", "Herculean"}
PREFIX_MAX_MANA_TABLE = {"Mana", "Greater Mana", "Soul", "Arcane", "Grand Arcane"}
PREFIX_RESPAWN_REDUCE_TABLE = {"Eternal", "Blessed", "Divine", "Exalted", "Sacred"}

function RPCItems:RollHoodProperty2(item, xpBounty)
    local luck = RandomInt(0,100)
    if Events.reroll then
        luck = RandomInt(0, 89)
    end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local prefixLevel = 1
    if luck < 10 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 8)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 12+bonus, 0, 0, item.rarity, false, maxFactor*10)
        item.property2 = value
        item.property2name = "strength"
        prefix = PREFIX_HOOD_STRENGTH_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_strength", "#CC0000",  2)
    elseif luck >= 10 and luck < 20 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 8)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 12+bonus, 0, 0, item.rarity, false, maxFactor*10)
        item.property2 = value
        item.property2name = "agility"
        prefix = PREFIX_HOOD_AGILITY_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_agility", "#2EB82E",  2)
    elseif luck >= 20 and luck < 30 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 8)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 12+bonus, 0, 0, item.rarity, false, maxFactor*10)
        item.property2 = value
        item.property2name = "intelligence"
        prefix = PREFIX_HOOD_INTELLIGENCE_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_intelligence", "#33CCFF",  2)
    elseif luck >= 30 and luck < 40 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 10)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, 5)
        item.property2 = value
        item.property2name = "magic_resist"
        prefix = PREFIX_HOOD_MAGIC_RESIST_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_magic_resist", "#AC47DE",  2)
    elseif luck >= 40 and luck < 50 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 6)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 5+bonus, 0, 0, item.rarity, false, maxFactor*5)
        item.property2 = value
        item.property2name = "armor"
        prefix = PREFIX_HOOD_ARMOR_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_armor", "#D1D1D1",  2)
    elseif luck >= 50 and luck < 60 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 300)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 10, 500+bonus, 1, 1, item.rarity, false, maxFactor*200)
        item.property2 = value
        item.property2name = "max_health"
        prefix = PREFIX_MAX_HEALTH_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_max_health", "#B02020",  2)
    elseif luck >= 60 and luck < 70 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 200)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 50, 200+bonus, 0, 1, item.rarity, false, maxFactor*80)
        item.property2 = value
        item.property2name = "max_mana"
        prefix = PREFIX_MAX_MANA_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_max_mana", "#343EC9",  2)   
    elseif luck >= 70 and luck < 80 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 10)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, maxFactor*7)
        item.property2 = value
        item.property2name = "health_regen"
        prefix = PREFIX_HEALTH_REGEN_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_health_regen", "#6AA364",  2)
    elseif luck >= 80 and luck < 90 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 3)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 5+bonus, 0, 0, item.rarity, false, maxFactor*3)
        item.property2 = value
        item.property2name = "mana_regen"
        prefix = PREFIX_MANA_REGEN_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_mana_regen", "#649FA3",  2)
    elseif luck >= 90 and luck <= 100 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 3)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 0, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        item.property2 = value
        item.property2name = "level_reduce"
        prefix = PREFIX_RESPAWN_REDUCE_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_min_level_reduction", "#F28100",  2)             
    end
    return prefix
end



function RPCItems:RollHoodProperty3(item, xpBounty)
    local luck = RandomInt(0,110)
    if Events.reroll then
        luck = RandomInt(0, 99)
    end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local prefixLevel = 1
    if luck < 10 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 30, 0, 0, item.rarity, false, maxFactor*12)
        item.property3 = value
        item.property3name = "strength"
        RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)
    elseif luck >= 10 and luck < 20 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 30, 0, 0, item.rarity, false, maxFactor*12)
        item.property3 = value
        item.property3name = "agility"
        RPCItems:SetPropertyValues(item, item.property3, "#item_agility", "#2EB82E",  3)
    elseif luck >= 20 and luck < 30 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 30, 0, 0, item.rarity, false, maxFactor*12)
        item.property3 = value
        item.property3name = "intelligence"
        RPCItems:SetPropertyValues(item, item.property3, "#item_intelligence", "#33CCFF",  3)
    elseif luck >= 30 and luck < 40 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 30, 0, 0, item.rarity, false, 5)
        item.property3 = value
        item.property3name = "magic_resist"
        RPCItems:SetPropertyValues(item, item.property3, "#item_magic_resist", "#AC47DE",  3)
    elseif luck >= 40 and luck < 50 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 10, 0, 0, item.rarity, false, maxFactor*5)
        item.property3 = value
        item.property3name = "armor"
        RPCItems:SetPropertyValues(item, item.property3, "#item_armor", "#D1D1D1",  3)
    elseif luck >= 50 and luck < 60 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 500, 0, 0, item.rarity, false, maxFactor*240)
        item.property3 = value
        item.property3name = "max_health"
        RPCItems:SetPropertyValues(item, item.property3, "#item_max_health", "#B02020",  3)
    elseif luck >= 60 and luck < 70 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 50, 300, 0, 0, item.rarity, false, maxFactor*100)
        item.property3 = value
        item.property3name = "max_mana"
        RPCItems:SetPropertyValues(item, item.property3, "#item_max_mana", "#343EC9",  3)   
    elseif luck >= 70 and luck < 80 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 10, 0, 0, item.rarity, false, maxFactor*7)
        item.property3 = value
        item.property3name = "health_regen"
        RPCItems:SetPropertyValues(item, item.property3, "#item_health_regen", "#6AA364",  3)
    elseif luck >= 80 and luck < 90 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 7, 0, 0, item.rarity, false, maxFactor*4)
        item.property3 = value
        item.property3name = "mana_regen"
        RPCItems:SetPropertyValues(item, item.property3, "#item_mana_regen", "#649FA3",  3)
    elseif luck >= 90 and luck < 100 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 2, 10, 0, 0, item.rarity, false, math.ceil(maxFactor/4.1))
        item.property3 = value
        item.property3name = "base_ability"
        RPCItems:SetPropertyValues(item, item.property3, "#item_base_ability", "#7AB4CC",  3)       
    elseif luck >= 100 and luck <= 110 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 0, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        item.property3 = value
        item.property3name = "level_reduce"
        RPCItems:SetPropertyValues(item, item.property3, "#item_min_level_reduction", "#F28100",  3)             
    end
end

PREFIX_HOOD_TABLE2 = {"Adorned", "Gilded", "Resplendant", "Shadow", "Mythic"}

function RPCItems:RollHoodProperty4(item, xpBounty)
    local luck = RandomInt(0,110)
    if Events.reroll then
        luck = RandomInt(0, 99)
    end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local nameLevel = 1
    if luck < 10 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 100, 0, 0, item.rarity, false, maxFactor*15)
        item.property4 = value
        item.property4name = "strength"
        RPCItems:SetPropertyValues(item, item.property4, "#item_strength", "#CC0000",  4)
    elseif luck >= 10 and luck < 20 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 100, 0, 0, item.rarity, false, maxFactor*15)
        item.property4 = value
        item.property4name = "agility"
        RPCItems:SetPropertyValues(item, item.property4, "#item_agility", "#2EB82E",  4)
    elseif luck >= 20 and luck < 30 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 100, 0, 0, item.rarity, false, maxFactor*15)
        item.property4 = value
        item.property4name = "intelligence"
        RPCItems:SetPropertyValues(item, item.property4, "#item_intelligence", "#33CCFF",  4)
    elseif luck >= 30 and luck < 40 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 10, 0, 0, item.rarity, false, 5)
        item.property4 = value
        item.property4name = "magic_resist"
        RPCItems:SetPropertyValues(item, item.property4, "#item_magic_resist", "#AC47DE",  4)
    elseif luck >= 40 and luck < 50 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 10, 0, 0, item.rarity, false, maxFactor*5)
        item.property4 = value
        item.property4name = "armor"
        RPCItems:SetPropertyValues(item, item.property4, "#item_armor", "#D1D1D1",  4)
    elseif luck >= 50 and luck < 60 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 1000, 0, 1, item.rarity, false, maxFactor*240)
        item.property4 = value
        item.property4name = "max_health"
        RPCItems:SetPropertyValues(item, item.property4, "#item_max_health", "#B02020",  4)
    elseif luck >= 60 and luck < 70 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 50, 500, 1, 1, item.rarity, false, maxFactor*100)
        item.property4 = value
        item.property4name = "max_mana"
        RPCItems:SetPropertyValues(item, item.property4, "#item_max_mana", "#343EC9",  4)   
    elseif luck >= 70 and luck < 80 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 10, 0, 0, item.rarity, false, maxFactor*8)
        item.property4 = value
        item.property4name = "health_regen"
        RPCItems:SetPropertyValues(item, item.property4, "#item_health_regen", "#6AA364",  4)
    elseif luck >= 80 and luck < 90 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 8, 0, 0, item.rarity, false, maxFactor*4)
        item.property4 = value
        item.property4name = "mana_regen"
        RPCItems:SetPropertyValues(item, item.property4, "#item_mana_regen", "#649FA3",  4)
    elseif luck >= 90 and luck < 100 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 2, 11, 0, 0, item.rarity, false, math.ceil(maxFactor/4.1))
        item.property4 = value
        item.property4name = "base_ability"
        RPCItems:SetPropertyValues(item, item.property4, "#item_base_ability", "#7AB4CC",  4)       
    elseif luck >= 100 and luck <= 110 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 1, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        item.property4 = value
        item.property4name = "level_reduce"
        RPCItems:SetPropertyValues(item, item.property4, "#item_min_level_reduction", "#F28100",  4)             
    end
    local name = PREFIX_HOOD_TABLE2[nameLevel]
    return name
end


BASE_HAND_TABLE = {"item_wraps", "item_rpc_gloves", "item_rpc_gauntlets"}
BASE_HAND_NAME_TABLE = {"Wraps", "Gloves", "Gauntlets"}

function RPCItems:RollHand(xpBounty, deathLocation, rarity, isShop, type, hero, unitLevel)
	local randomHelm = RandomInt(1, 3)
    if isShop then
        randomHelm = type
    end
	local itemVariant = BASE_HAND_TABLE[randomHelm]
    local item = CreateItem(itemVariant, nil, nil)



    item.rarity = rarity
    local rarityValue = RPCItems:GetRarityFactor(rarity)
    if rarityValue == 5 then
        if RPCItems:HandLegendary(itemVariant, deathLocation) then
            return nil
        end
    end
    local itemName = BASE_HAND_NAME_TABLE[randomHelm]
    item.slot = "hands"
    item.gear = true
    local suffix = RPCItems:RollHandProperty1(item, xpBounty, randomHelm)
    local prefix = ""
    local additional_prefix = ""
    
    if rarityValue >= 2 then
    	prefix = RPCItems:RollHandProperty2(item, xpBounty)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollHandProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	additional_prefix = RPCItems:RollHandProperty4(item, xpBounty)
    	itemName = additional_prefix.." "..itemName
    end

    RPCItems:SetTableValues(item, itemName, false, "Slot: Hands", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    if isShop then
        RPCItems:GiveItemToHero(hero, item)
    else
        local drop = CreateItemOnPositionSync( deathLocation, item )
        local position = deathLocation
        RPCItems:DropItem(item, position)
    end
end

function RPCItems:HandLegendary(itemVariant, deathLocation)
    if itemVariant == "item_wraps" then
        local luck = RandomInt(1, 11)
        if luck == 1 then
            RPCItems:RollSpiritGlove(deathLocation)
            return true
        elseif luck == 2 then
            RPCItems:RollScarecrowGloves(deathLocation)
            return true
        elseif luck == 3 then
            RPCItems:RollElderGrasp(deathLocation)
            return true
        elseif luck == 4 then
            RPCItems:RollClawOfAzinoth(deathLocation)
            return true
        elseif luck == 5 then
            RPCItems:RollMageBaneGloves(deathLocation)
            return true
        elseif luck == 6 then
            RPCItems:RollCytopianLaserGloves(deathLocation)
            return true
        elseif luck == 7 then
            RPCItems:RollGrandArcanist(deathLocation)
            return true
        elseif luck == 8 then
            RPCItems:RollStormclothBracer(deathLocation)
            return true
        elseif luck == 9 then
            RPCItems:RollIronboundGloves(deathLocation)
            return true
        elseif luck == 10 then
            RPCItems:RollGreensandCopperGauntlets(deathLocation)
            return true
        elseif luck == 11 then
            RPCItems:RollShadowflameFist(deathLocation)
            return true
        end
    elseif itemVariant == "item_rpc_gloves" then
        local luck = RandomInt(1, 11)
        if luck == 1 then
            RPCItems:RollPhoenixGloves(deathLocation)
            return true
        elseif luck == 2 then
            RPCItems:RollMasterGloves(deathLocation)
            return true
        elseif luck == 3 then
            local arcanaLuck = RandomInt(1, 920)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollTrapperArcana1(deathLocation)
                return true
            end
            RPCItems:RollMarauderGloves(deathLocation)
            return true
        elseif luck == 4 then
            RPCItems:RollBerserkerGloves(deathLocation)
            return true
        elseif luck == 5 then
            RPCItems:RollProudGloves(deathLocation)
            return true
        elseif luck == 6 then
            RPCItems:RollPowerRangerGloves(deathLocation)
            return true
        elseif luck == 7 then
            RPCItems:RollEternalEssenceGauntlet(deathLocation)
            return true
        elseif luck == 8 then
            RPCItems:RollSilverspringGloves(deathLocation)
            return true
        elseif luck == 9 then
            RPCItems:RollMordiggusGauntlet(deathLocation)
            return true
        elseif luck == 10 then
            RPCItems:RollHalcyonSoulGlove(deathLocation)
            return true
        elseif luck == 11 then
            RPCItems:RollMalachiteShadeBracer(deathLocation)
            return true
        end
    elseif itemVariant == "item_rpc_gauntlets" then
        local luck = RandomInt(1, 11)
        if luck == 1 then
            RPCItems:RollFrostburnGauntlets(deathLocation)
            return true
        elseif luck == 2 then
            RPCItems:RollLivingGauntlet(deathLocation)
            return true
        elseif luck == 3 then
            local arcanaLuck = RandomInt(1, 890)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollPaladinArcana1(deathLocation)
                return true
            end
            RPCItems:RollDivinePurityGauntlets(deathLocation)
            return true
        elseif luck == 4 then
            local arcanaLuck = RandomInt(1, 1090)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollFlamewakerArcana2(deathLocation)
                return true
            end
            RPCItems:RollScorchedGauntlets(deathLocation)
            return true
        elseif luck == 5 then
            RPCItems:RollShadowArmlet(deathLocation)
            return true
        elseif luck == 6 then
            local arcanaLuck = RandomInt(1, 920)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollMountainProtectorArcana1(deathLocation)
                return true
            end
            RPCItems:RollMountainVambraces(deathLocation)
            return true
        elseif luck == 7 then
            RPCItems:RollBladeforgeGauntlet(deathLocation)
            return true
        elseif luck == 8 then
            RPCItems:RollFarSeersEnchantedGloves(deathLocation)
            return true
        elseif luck == 9 then
            RPCItems:RollRoyalWristguards(deathLocation)
            return true
        elseif luck == 10 then
            local arcanaLuck = RandomInt(1, 920)
            if arcanaLuck <= (2 + GameState:GetPlayerPremiumStatusCount()) then
                RPCItems:RollDuskbringerArcana1(deathLocation)
                return true
            end
            RPCItems:RollGloveOfTheForgottenGhost(deathLocation)
            return true
        elseif luck == 11 then
            RPCItems:RollHeavyEchoGauntlet(deathLocation)
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
SUFFIX_MANA_REGEN_TABLE = {"of Refreshment", "of Greater Refreshment", "of the Seal", "of the Whale", "of the Owl"}
SUFFIX_MAX_HEALTH_TABLE = {"of the Whale", "of Life", "of Longevity", "of Vitality", "of the Colossus"}
SUFFIX_MAX_MANA_TABLE = {"of Wisdom", "of the Moon", "of the Stars", "of the Blue Moon", "of the Blue Stars"}
SUFFIX_RESPAWN_REDUCE_TABLE = {"of Reincarnation", "of Reincarnation", "of Redemption", "of the Phoenix", "of Immortality"}

SUFFIX_ATTACK_SPEED_TABLE = {"of Dexterity", "of the Archer", "of Greater Dexterity", "of Mastery", "of Greater Mastery"}
SUFFIX_COOLDOWN_REDUCE_TABLE = {"of Proficiency", "of Artistry", "of Nobility", "of Mastery", "of Greater Mastery"}

function RPCItems:RollHandProperty1(item, xpBounty, randomHelm)
    local luck = RandomInt(0,100)
    if Events.reroll then
        luck = RandomInt(0, 89)
    end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local suffixLevel = 1
    if luck < 10 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 2+bonus, 0, 0, item.rarity, false, maxFactor*10)
        item.property1 = value
        item.property1name = "strength"
        suffix = SUFFIX_HOOD_STRENGTH_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_strength", "#CC0000",  1)
    elseif luck >= 10 and luck < 20 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 2+bonus, 0, 0, item.rarity, false, maxFactor*10)
        item.property1 = value
        item.property1name = "agility"
        suffix = SUFFIX_HOOD_AGILITY_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_agility", "#2EB82E",  1)
    elseif luck >= 20 and luck < 30 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 4)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 2+bonus, 0, 0, item.rarity, false, maxFactor*10)
        item.property1 = value
        item.property1name = "intelligence"
        suffix = SUFFIX_HOOD_INTELLIGENCE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_intelligence", "#33CCFF",  1)
    elseif luck >= 30 and luck < 40 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 5)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 4+bonus, 0, 0, item.rarity, false, 5)
        item.property1 = value
        item.property1name = "magic_resist"
        suffix = SUFFIX_HOOD_MAGIC_RESIST_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_magic_resist", "#AC47DE",  1)
    elseif luck >= 40 and luck < 50 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 6)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 2+bonus, 0, 0, item.rarity, false, maxFactor*3)
        item.property1 = value
        item.property1name = "armor"
        suffix = SUFFIX_HOOD_ARMOR_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_armor", "#D1D1D1",  1)
    elseif luck >= 50 and luck < 60 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 5)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 6+bonus, 0, 1, item.rarity, false, math.min(maxFactor*3, RandomInt(50, 75)))
        item.property1 = value
        item.property1name = "attack_speed"
        suffix = SUFFIX_ATTACK_SPEED_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_attack_speed", "#B02020",  1)
    elseif luck >= 60 and luck < 70 then
    	local bonus = 0
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 8+bonus, 0, 0, item.rarity, false, maxFactor*30)
        item.property1 = value
        item.property1name = "cooldown_reduction"
        suffix = SUFFIX_COOLDOWN_REDUCE_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_bonus_attack_damage", "#343EC9",  1)   
    elseif luck >= 70 and luck < 80 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 3)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 1, 3+bonus, 0, 0, item.rarity, false, maxFactor*4)
        item.property1 = value
        item.property1name = "health_regen"
        suffix = SUFFIX_HEALTH_REGEN_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_health_regen", "#6AA364",  1)
    elseif luck >= 80 and luck < 90 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 3)
        value, suffixLevel = RPCItems:RollAttribute(xpBounty, 2, 3+bonus, 0, 0, item.rarity, false, maxFactor*5)
        item.property1 = value
        item.property1name = "mana_regen"
        suffix = SUFFIX_MANA_REGEN_TABLE[suffixLevel]
        RPCItems:SetPropertyValues(item, item.property1, "#item_mana_regen", "#649FA3",  1)
    elseif luck >= 90 and luck < 100 then
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
PREFIX_RESPAWN_REDUCE_TABLE = {"Eternal", "Blessed", "Divine", "Exalted", "Sacred"}
PREFIX_ATTACK_SPEED_TABLE = {"Apt", "Talented", "Expert", "Furious", "Whirlwind"}
PREFIX_COOLDOWN_REDUCE_TABLE = {"Conjurer's", "Diviner's", "Clairvoyant", "Far Seer's", "Grand Far Seer's"}

function RPCItems:RollHandProperty2(item, xpBounty)
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
        item.property2 = value
        item.property2name = "strength"
        prefix = PREFIX_HOOD_STRENGTH_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_strength", "#CC0000",  2)
    elseif luck >= 10 and luck < 20 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 10)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, maxFactor*12)
        item.property2 = value
        item.property2name = "agility"
        prefix = PREFIX_HOOD_AGILITY_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_agility", "#2EB82E",  2)
    elseif luck >= 20 and luck < 30 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 10)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, maxFactor*12)
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
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 5+bonus, 0, 0, item.rarity, false, maxFactor*3)
        item.property2 = value
        item.property2name = "armor"
        prefix = PREFIX_HOOD_ARMOR_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_armor", "#D1D1D1",  2)
    elseif luck >= 50 and luck < 60 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 5)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 6+bonus, 0, 1, item.rarity, false, math.min(maxFactor*3, RandomInt(50, 75)))
        item.property2 = value
        item.property2name = "attack_speed"
        prefix = PREFIX_ATTACK_SPEED_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_attack_speed", "#B02020",  2)
    elseif luck >= 60 and luck < 70 then
    	local bonus = 0
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 8+bonus, 0, 0, item.rarity, false, maxFactor*100)
        item.property2 = value
        item.property2name = "cooldown_reduction"
        prefix = PREFIX_COOLDOWN_REDUCE_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_bonus_attack_damage", "#343EC9",  2)    
    elseif luck >= 70 and luck < 80 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 2, 4)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 10+bonus, 0, 0, item.rarity, false, maxFactor*4)
        item.property2 = value
        item.property2name = "health_regen"
        prefix = PREFIX_HEALTH_REGEN_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_health_regen", "#6AA364",  2)
    elseif luck >= 80 and luck < 90 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 1, 5)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 2, 4+bonus, 0, 0, item.rarity, false, maxFactor*5)
        item.property2 = value
        item.property2name = "mana_regen"
        prefix = PREFIX_MANA_REGEN_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_mana_regen", "#649FA3",  2)
    elseif luck >= 90 and luck <= 100 then
    	local bonus = RPCItems:GetHeadBonusRoll(randomHelm, 3, 2)
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 0, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        item.property2 = value
        item.property2name = "level_reduce"
        prefix = PREFIX_RESPAWN_REDUCE_TABLE[prefixLevel]
        RPCItems:SetPropertyValues(item, item.property2, "#item_min_level_reduction", "#F28100",  2)             
    end
    return prefix
end



function RPCItems:RollHandProperty3(item, xpBounty)
    local luck = RandomInt(0,110)
    if Events.reroll then
        luck = RandomInt(0, 99)
    end
    local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local prefixLevel = 1
    if luck < 10 then
        value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 20, 0, 0, item.rarity, false, maxFactor*10)
        item.property3 = value
        item.property3name = "strength"
        RPCItems:SetPropertyValues(item, item.property3, "#item_strength", "#CC0000",  3)
    elseif luck >= 10 and luck < 20 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 20, 0, 0, item.rarity, false, maxFactor*10)
        item.property3 = value
        item.property3name = "agility"
        RPCItems:SetPropertyValues(item, item.property3, "#item_agility", "#2EB82E",  3)
    elseif luck >= 20 and luck < 30 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 20, 0, 0, item.rarity, false, maxFactor*10)
        item.property3 = value
        item.property3name = "intelligence"
        RPCItems:SetPropertyValues(item, item.property3, "#item_intelligence", "#33CCFF",  3)
    elseif luck >= 30 and luck < 40 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 30, 0, 0, item.rarity, false, 5)
        item.property3 = value
        item.property3name = "magic_resist"
        RPCItems:SetPropertyValues(item, item.property3, "#item_magic_resist", "#AC47DE",  3)
    elseif luck >= 40 and luck < 50 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 6, 0, 0, item.rarity, false, maxFactor*3)
        item.property3 = value
        item.property3name = "armor"
        RPCItems:SetPropertyValues(item, item.property3, "#item_armor", "#D1D1D1",  3)
    elseif luck >= 50 and luck < 60 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 4, 8, 0, 1, item.rarity, false, math.min(maxFactor*3, RandomInt(50, 75)))
        item.property3 = value
        item.property3name = "attack_speed"
        RPCItems:SetPropertyValues(item, item.property3, "#item_attack_speed", "#B02020",  3)
    elseif luck >= 60 and luck < 70 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 150, 0, 0, item.rarity, false, maxFactor*300)
        item.property3 = value
        item.property3name = "cooldown_reduction"
        RPCItems:SetPropertyValues(item, item.property3, "#item_bonus_attack_damage", "#343EC9",  3)   
    elseif luck >= 70 and luck < 80 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 7, 0, 0, item.rarity, false, maxFactor*5)
        item.property3 = value
        item.property3name = "health_regen"
        RPCItems:SetPropertyValues(item, item.property3, "#item_health_regen", "#6AA364",  3)
    elseif luck >= 80 and luck < 90 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 3, 6, 0, 0, item.rarity, false, maxFactor*7)
        item.property3 = value
        item.property3name = "mana_regen"
        RPCItems:SetPropertyValues(item, item.property3, "#item_mana_regen", "#649FA3",  3)
    elseif luck >= 90 and luck < 100 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 2, 12, 0, 0, item.rarity, false, math.ceil(maxFactor/3.4))
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

PREFIX_GLOVE_TABLE2 = {"Pure", "Virtuous", "Perfect", "Shadow", "Mythic"}

function RPCItems:RollHandProperty4(item, xpBounty)
   local luck = RandomInt(0,110)
    if Events.reroll then
        luck = RandomInt(0, 99)
    end
   local maxFactor = RPCItems:GetMaxFactor()
    local value = 0
    local nameLevel = 1
    if luck < 10 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 40, 0, 0, item.rarity, false, maxFactor*12)
        item.property4 = value
        item.property4name = "strength"
        RPCItems:SetPropertyValues(item, item.property4, "#item_strength", "#CC0000",  4)
    elseif luck >= 10 and luck < 20 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 40, 0, 0, item.rarity, false, maxFactor*12)
        item.property4 = value
        item.property4name = "agility"
        RPCItems:SetPropertyValues(item, item.property4, "#item_agility", "#2EB82E",  4)
    elseif luck >= 20 and luck < 30 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 40, 0, 0, item.rarity, false, maxFactor*12)
        item.property4 = value
        item.property4name = "intelligence"
        RPCItems:SetPropertyValues(item, item.property4, "#item_intelligence", "#33CCFF",  4)
    elseif luck >= 30 and luck < 40 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 10, 0, 0, item.rarity, false, 12)
        item.property4 = value
        item.property4name = "magic_resist"
        RPCItems:SetPropertyValues(item, item.property4, "#item_magic_resist", "#AC47DE", 4)
    elseif luck >= 40 and luck < 50 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 6, 0, 0, item.rarity, false, maxFactor*4)
        item.property4 = value
        item.property4name = "armor"
        RPCItems:SetPropertyValues(item, item.property4, "#item_armor", "#D1D1D1", 4)
    elseif luck >= 50 and luck < 60 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 4, 8, 0, 1, item.rarity, false, math.min(maxFactor*3, RandomInt(50, 75)))
        item.property4 = value
        item.property4name = "attack_speed"
        RPCItems:SetPropertyValues(item, item.property4, "#item_attack_speed", "#B02020", 4)
    elseif luck >= 60 and luck < 70 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 300, 0, 0, item.rarity, false, maxFactor*500)
        item.property4 = value
        item.property4name = "cooldown_reduction"
        RPCItems:SetPropertyValues(item, item.property4, "#item_bonus_attack_damage", "#343EC9", 4)   
    elseif luck >= 70 and luck < 80 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 7, 0, 0, item.rarity, false, maxFactor*12)
        item.property4 = value
        item.property4name = "health_regen"
        RPCItems:SetPropertyValues(item, item.property4, "#item_health_regen", "#6AA364", 4)
    elseif luck >= 80 and luck < 90 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 4, 10, 0, 0, item.rarity, false, maxFactor*12)
        item.property4 = value
        item.property4name = "mana_regen"
        RPCItems:SetPropertyValues(item, item.property4, "#item_mana_regen", "#649FA3", 4)
    elseif luck >= 90 and luck < 100 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 12, 0, 0, item.rarity, false, math.ceil(maxFactor/3.2))
        item.property4 = value
        item.property4name = "base_ability"
        RPCItems:SetPropertyValues(item, item.property4, "#item_base_ability", "#7AB4CC",  4)       
    elseif luck >= 100 and luck <= 110 then
        value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, math.floor(RPCItems:GetMinLevel()/10), 1, 0, item.rarity, false, math.ceil(RPCItems:GetMinLevel()/4))
        item.property4 = value
        item.property4name = "level_reduce"
        RPCItems:SetPropertyValues(item, item.property4, "#item_min_level_reduction", "#F28100", 4)             
    end
    local name = PREFIX_GLOVE_TABLE2[nameLevel]
    return name
end


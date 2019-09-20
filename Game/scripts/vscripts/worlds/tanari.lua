if Tanari == nil then
    Tanari = class({})
end

require("worlds/tanari/tanari_events")

require("worlds/tanari/zones/champions_trail")
require("worlds/tanari/zones/terrasic_crater")
require("worlds/tanari/zones/wildwood_thicket")
require("worlds/tanari/zones/wind_temple")
require("worlds/tanari/zones/boulderspine_cavern")
require("worlds/tanari/zones/water_temple")
require("worlds/tanari/zones/fire_temple")

TANARI_V2 = true

function Tanari:Debug()
    if MAIN_HERO_TABLE[1] then
        -- MAIN_HERO_TABLE[1]:SetBaseStrength(25000)
        -- MAIN_HERO_TABLE[1]:SetBaseAgility(25000)
        -- MAIN_HERO_TABLE[1]:SetBaseIntellect(25000)
        -- MAIN_HERO_TABLE[1]:SetBaseDamageMax(500000)
        -- MAIN_HERO_TABLE[1]:SetBaseDamageMin(500000)
        MAIN_HERO_TABLE[1]:CalculateStatBonus()
        -- Runes:EquipArcana(MAIN_HERO_TABLE[1], 2)
    end

	-- Tanari:InitializeFireTemple()
	--
    --Tanari:SpawnFireSpiritFinalBoss()
    --Tanari:SpawnWaterSpiritFinalBoss()
	--Tanari.WaterTemple = {}
	--Tanari:BeginBossSpawnSequence()
	--Tanari.WindTemple = {}
	--Tanari:SpawnWindBossStaff()
    --Tanari:SpawnWindTempleSpiritBoss()

    -- RPCItems:RollAxeArcana2(Vector(-4928, 2048))
    -- RPCItems:RollHarvesterBoots(Vector(-4928, 2048))
    -- RPCItems:RollSkulldiggerGloves(Vector(-4928, 2048))
    -- Events:SpawnAertega(Vector(-4928, 2048))
    -- Events:SpawnTorturok(Vector(-4928, 2048))

    --  Events:SpawnOzubu(Vector(-4928, 2048))
    --  for i = 1, 5, 1 do
    --     RPCItems:RollWinterblightSkullRing(Vector(-4928, 2048))
    -- end
    -- Dungeons.itemLevel = 500
    -- Glyphs:DropArcaneCrystals(Vector(-4928, 2048), 2.0)
    -- -- RPCItems:RollArcaneCharm(Vector(-3928, 2048))
    -- Tanari:DefeatDungeonBoss("fire", Vector(-4928, 2048))
    local item = RPCItems:CreateItem("item_debug_blink", nil, nil)
    local drop = CreateItemOnPositionSync(Vector(-4928, 2048), item)
    local position = Vector(-4928, 2048)
    RPCItems:DropItem(item, Vector(-4928, 2048))

    -- RPCItems:RollDuskbringerArcana1(Vector(-4928, 2048))
    -- RPCItems:RollDuskbringerArcana2(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_duskbringer_glyph_7_1", Vector(-4928, 2048), 0)
    -- RPCItems:RollJexArcana1(Vector(-4928, 2048))
    -- Tanari:AcquireEssence("fire", Vector(-4928, 2048))
    -- Weapons:RollLegendWeapon1(Vector(-4928, 2048), "omniro")
    -- Weapons:RollLegendWeapon2(Vector(-4928, 2048), "omniro")
    -- Weapons:RollLegendWeapon3(Vector(-4928, 2048), "omniro")
    -- Glyphs:DebugRollHeroGlyphs("omniro", Vector(-4928, 2048))
    -- -- RPCItems:DropSynthesisVessel(Vector(-4928, 2048))
    -- -- RPCItems:RollArkimusArcana2(Vector(-4928, 2048))
    -- RPCItems:RollSkulldiggerGloves(Vector(-4928, 2048))
    -- RPCItems:RollIceFloeSlippers(Vector(-4928, 2048))
    -- RPCItems:RollSlipfinnArcana1(Vector(-4928, 2048))
    -- RPCItems:RollAerithsTear(Vector(-4928, 2048))

    -- for i = 1, 7, 1 do
    --     Glyphs:RollGlyphAll("item_rpc_voltex_glyph_"..tostring(i).."_1", Vector(-4928, 2048), 0)
    -- end

    -- RPCItems:RollAstralArcana2(Vector(-4928, 2048))
    -- RPCItems:RollAstralArcana3(Vector(-4928, 2048))
    -- RPCItems:RollConjurorArcana4(Vector(-4928, 2048))
    -- RPCItems:RollConjurorArcana2(Vector(-4928, 2048))
    -- RPCItems:RollBaronsStormArmor(Vector(-4928, 2048))
    -- RPCItems:RollCaptainsVest(Vector(-4928, 2048))
    -- RPCItems:RollHydroxisArcana2(Vector(-4928, 2048))
    -- RPCItems:RollVoltexArcana2(Vector(-4928, 2048))
    -- RPCItems:RollVenomortArcana1(Vector(-4928, 2048))
    -- RPCItems:RollVenomortArcana2(Vector(-4928, 2048))
    -- for i = 1, 5, 1 do
    --     RPCItems:RollMountainProtectorArcana3(Vector(-4928, 2048))
    -- end
    -- RPCItems:RollBerserkerGloves(Vector(-4928, 2048))
    -- RPCItems:RollSephyrArcana1(Vector(-4928, 2048))

    -- RPCItems:RollDirewolfBulkwark(Vector(-4928, 2048))
    -- RPCItems:RollDjanghorArcana1(Vector(-4928, 2048))
    -- RPCItems:RollHoodOfLords(Vector(-4928, 2048), true)

    -- Tanari:SpawnVaultMaster(Vector(-4928, 2048), RandomVector(1))
    -- RPCItems:RollAnkhOfAncients(Vector(-4928, 2048))
    -- RPCItems:RollChernobogArcana1(Vector(-4928, 2048))
    -- RPCItems:RollChernobogArcana2(Vector(-4928, 2048))
    -- RPCItems:RollHeavyEchoGauntlet(Vector(-4928, 2048))
    -- RPCItems:RollFlamewakerArcana1(Vector(-4928, 2048))
    -- -- RPCItems:RollTwistedMaskOfAhnqhirPurple(Vector(-4928, 2048))
    -- RPCItems:RollBahamutArcana2(Vector(-4928, 2048))
    -- RPCItems:RollBlueRainGauntlet(Vector(-4928, 2048))
    -- RPCItems:RollMountainProtectorArcana2(Vector(-4928, 2048))
    -- RPCItems:RollMountainProtectorArcana3(Vector(-4928, 2048))
    -- RPCItems:RollDunetreadBoots(Vector(-4928, 2048))
    -- Arena = {}
    -- Arena.PitLevel = 7
    -- Weapons:RollLegendWeapon1(Vector(-4928, 2048), "jex")
    -- Weapons:RollLegendWeapon2(Vector(-4928, 2048), "jex")
    -- Weapons:RollLegendWeapon3(Vector(-4928, 2048), "jex")

    -- RPCItems:RollSunCrystal(Vector(-4928, 2048), 100)
    -- RPCItems:RollWaterMageRobes(Vector(-4928, 2048))
    -- RPCItems:RollAlaranaIceBoot(Vector(-4928, 2048))
    -- RPCItems:RollDruidsSpiritHelm(Vector(-4928, 2048), false)
    -- Glyphs:DebugRollHeroGlyphs("jex", Vector(-4928, 2048))
    -- RPCItems:RollMonkeyPaw(Vector(-4928, 2048))
    -- RPCItems:RollSorceressArcana2(Vector(-4928, 2048))
    -- RPCItems:RollPaladinArcana2(Vector(-4928, 2048))
    -- RPCItems:RollArkimusArcana2(Vector(-4928, 2048))
    -- RPCItems:RollSoluniaArcana2(Vector(-4928, 2048))
    -- SaveLoad:KeyDebug()
    -- RPCItems:RollMountainProtectorArcana2(Vector(-4928, 2048))

    -- RPCItems:RollBahamutArcana2(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_spirit_warrior_glyph_7_1", Vector(-4928, 2048), 0)

    -- Curator:CurateArcanaAbilities(MAIN_HERO_TABLE[1])
    -- Curator:CurateAllGlyphsForHeroWithTiers("neutral", 3)
    -- Curator:CurateAllGlyphsForHeroWithTiers("venomort", 2)
    -- Curator:CurateALLBasicWeapons(MAIN_HERO_TABLE[1]:GetPlayerOwnerID())
    -- for i = 1, 50, 1 do
    --     Timers:CreateTimer(i*2, function()
    --          Curator:CurateBasicEquipment(MAIN_HERO_TABLE[1]:GetPlayerOwnerID())
    --     end)
    -- end

    -- Glyphs:RollRandomGlyphBook(Vector(-4928, 2048))
    -- Glyphs:RollRandomGlyphBook(Vector(-4928, 2048))
    -- Glyphs:RollRandomGlyphBook(Vector(-4928, 2048))
    -- Glyphs:DebugRollHeroGlyphs("djanghor", Vector(-4928, 2048))
    -- for i = 1, 7, 1 do
    --     Glyphs:RollGlyphAll("item_rpc_paladin_glyph_"..tostring(i).."_2", Vector(-4928, 2048), 0)
    -- end
    -- Glyphs:RollGlyphAll("item_rpc_neutral_glyph_7_2", Vector(-4928, 2048), 0)
    -- RPCItems:RollPhantomSorcererMask(Vector(-4928, 2048), false)
    -- RPCItems:RollSorceressArcana1(Vector(-4928, 2048))
    -- RPCItems:RollEpsilonsEyeglass(Vector(-4928, 2048))
    -- RPCItems:RollDirewolfBulkwark(Vector(-4928, 2048))
    -- RPCItems:RollCentaurHorns(Vector(-4928, 2048))
    -- RPCItems:RollWaterMageRobes(Vector(-4928, 2048))
    -- RPCItems:RollSorceressArcana2(Vector(-4928, 2048))
    -- RPCItems:RollRubyDragonCrown(Vector(-4928, 2048), false)
    -- RPCItems:RollSoluniaArcana2(Vector(-4928, 2048))
    -- RPCItems:RollNightmareRiderMantle(Vector(-4928, 2048))
    -- RPCItems:RollSeinaruArcana1(Vector(-4928, 2048))
    -- RPCItems:RollHalcyonSoulGlove(Vector(-4928, 2048))
    -- -- RPCItems:RollMageBaneGloves(Vector(-4928, 2048))
    -- RPCItems:RollTwistedMaskOfAhnqhirBlue(Vector(-4928, 2048))
    --  RPCItems:RollTwistedMaskOfAhnqhirYellow(Vector(-4928, 2048))
    --  -- RPCItems:RollArborDragonfly(Vector(-4928, 2048))
    -- RPCItems:RollTwistedMaskOfAhnqhirPurple(Vector(-4928, 2048))
    -- -- Dungeons.itemLevel = 300
    -- -- for i = 1, 3, 1 do
    -- RPCItems:RollPaladinArcana1(Vector(-4928, 2048))
    -- RPCItems:RollBahamutArcana1(Vector(-4928, 2048))
    -- RPCItems:RollBahamutArcana2(Vector(-4928, 2048))

    --     RPCItems:RollSignusCharm(Vector(-4928, 2048))
    -- RPCItems:RollMountainProtectorArcana2(Vector(-4928, 2048))
    -- end
    -- RPCItems:RollAquastoneRing(Vector(-4928, 2048))
    -- RPCItems:RollAuriunArcana2(Vector(-4928, 2048))
    -- RPCItems:RollDemonMask(Vector(-4928, 2048), false, 60)
    -- RPCItems:RollWatcherPlate(Vector(-4928, 2048))
    -- RPCItems:RollEmpyrealSunriseRobe(Vector(-4928, 2048))
    -- for i = 1, 3, 1 do
    --     RPCItems:RollEkkanArcana1(Vector(-4928, 2048))
    -- end
    -- RPCItems:RollDruidsSpiritHelm(Vector(-4928, 2048), isShop)
    -- RPCItems:RollZhonikArcana2(Vector(-4928, 2048))
    -- RPCItems:RollIronTreadsOfDestruction(Vector(-4928, 2048))
    -- RPCItems:RollCarbuncleHelm(Vector(-4928, 2048), false)
    -- RPCItems:RollTwilightVestments(Vector(-4928, 2048))
    -- Arena = {}
    -- Arena.PitLevel = 7
    -- Weapons:RollLegendWeapon1(Vector(-4928, 2048), "dinath")
    -- Weapons:RollLegendWeapon2(Vector(-4928, 2048), "dinath")
    -- Weapons:RollLegendWeapon3(Vector(-4928, 2048), "dinath")
    -- RPCItems:RollDinathArcana1(Vector(-4928, 2048))
    -- RPCItems:RollBlacksmithsTablet(Vector(-4928, 2048))
    -- RPCItems:RollChitinousLobsterClaw(Vector(-4928, 2048))
    -- RPCItems:RollSeinaruArcana1(Vector(-4928, 2048))
    -- RPCItems:RollSeinaruArcana2(Vector(-4928, 2048))
    -- -- RPCItems:RollSeinaruArcana2(Vector(-4928, 2048))
    -- RPCItems:RollSuperAscendency(Vector(-4928, 2048), false)
    -- Weapons:RollLegendWeapon2(Vector(-4928, 2048), "sorceress")
    -- Weapons:RollLegendWeapon3(Vector(-4928, 2048), "sorceress")
    -- -- Glyphs:RollGlyphBook(Vector(-4928, 2048), "sorceress", 5, 2)
    -- -- Glyphs:RollRandomGlyphBook(Vector(-4928, 2048))
    -- for i = 0, 10, 1 do
    --     Glyphs:RollRandomGlyphBook(Vector(-4928, 2048))
    -- end
    -- -- Glyphs:RollRandomGlyphBook(Vector(-4928, 2048))
    -- -- Glyphs:RollRandomGlyphBook(Vector(-4928, 2048))
    -- Glyphs:DebugRollHeroGlyphs("trapper", Vector(-4928, 2048), 2)
    -- Weapons:RollLegendWeapon2(Vector(-4928, 2048), "venomort")
    -- Weapons:RollLegendWeapon3(Vector(-4928, 2048), "sorceress")
    -- for i = 1, 3, 1 do
    --     RPCItems:RollWarlordArcana1(Vector(-4928, 2048))
    -- end
    -- RPCItems:RollSuperAscendency(Vector(-4928, 2048), false)
    -- RPCItems:RollAquaLily(Vector(-4928, 2048))
    -- Dungeons.itemLevel = 200
    -- RPCItems:RollAblecoreGreaves(Vector(-4928, 2048))
    -- RPCItems:RollGlintOfOnu(Vector(-4928, 2048), false)
    -- RPCItems:RollSpiritWarriorArcana2(Vector(-4928, 2048))
    -- -- RPCItems:RollAquasteelBracers(Vector(-4928, 2048))

    -- RPCItems:RollMountainProtectorArcana1(Vector(-4928, 2048))
    -- RPCItems:RollMountainProtectorArcana2(Vector(-4928, 2048))
    -- RPCItems:RollSpiritWarriorArcana3(Vector(-4928, 2048))
    -- RPCItems:RollSeinaruArcana1(Vector(-4928, 2048))
    -- RPCItems:RollOutlandStoneCuirass(Vector(-4928, 2048))
    -- Arena = {}
    -- Arena.PitLevel = 7
    -- Dungeons.itemLevel = 300
    -- Weapons:RollLegendWeapon1(Vector(-4928, 2048), "seinaru")
    -- RPCItems:RollMountainProtectorArcana1(Vector(-4928, 2048))
    -- RPCItems:RollMountainProtectorArcana2(Vector(-4928, 2048))
    -- Dungeons.itemLevel = 300
    -- RPCItems:RollAuriunArcana1(Vector(-4928, 2048))
    -- RPCItems:RollAuriunArcana2(Vector(-4928, 2048))
    -- RPCItems:RollBurningSpiritHelmet(Vector(-4928, 2048))
    -- RPCItems:RollFlamewakerArcana1(Vector(-4928, 2048))
    -- Dungeons.itemLevel = 300
    -- RPCItems:RollVoltexArcana1(Vector(-4928, 2048))
    -- RPCItems:RollAlaranaIceBoot(Vector(-4928, 2048))
    -- for i = 1, 3, 1 do
    --     RPCItems:RollSorceressArcana1(Vector(-4928, 2048))
    -- end
    -- RPCItems:RollGarnetWarfareRing(Vector(-4928, 2048))
    -- RPCItems:RollBladestormVest(Vector(-4928, 2048))
    -- RPCItems:RollIronColossus(Vector(-4928, 2048), false)
    -- RPCItems:RollChernobogArcana1(Vector(-4928, 2048))
    -- RPCItems:RollAquasteelBracers(Vector(-4928, 2048))
    -- Runes:EquipArcana(Vector(-4928, 2048), 2)

    -- Weapons:RollLegendWeapon1(Vector(-4928, 2048), "arkimus")
    -- Weapons:RollLegendWeapon1(Vector(-4928, 2048), "solunia")
    -- RPCItems:RollWindDeityCrown(Vector(-4928, 2048), true, 7)
    -- RPCItems:RollIceQuillCarapace(Vector(-4928, 2048))
    -- RPCItems:RollMugatoMask(Vector(-4928, 2048), false)
    -- RPCItems:RollOmegaRuby(Vector(-4928, 2048))
    -- Curator:CurateBasicWeapons(MAIN_HERO_TABLE[1])
    -- RPCItems:RollAstralArcana1(Vector(-4928, 2048))
    -- Glyphs:DebugRollHeroGlyphs("zonik", Vector(-4928, 2048))
    -- RPCItems:RollSeinaruArcana1(Vector(-4928, 2048))
    -- RPCItems:RollScorchedGauntlets(Vector(-4928, 2048))
    -- RPCItems:RollWhiteMageHat(Vector(-4928, 2048), false)
    -- RPCItems:RollRubyDragonCrown(Vector(-4928, 2048), false)
    -- RPCItems:RollBladestormVest(Vector(-4928, 2048))
    -- RPCItems:RollSeinaruArcana1(Vector(-4928, 2048))
    -- Dungeons.itemLevel = 500
    -- RPCItems:RollMordiggusGauntlet(Vector(-4928, 2048))
    -- RPCItems:RollWaterDeityCrown(Vector(-4928, 2048), true, 0)
    -- RPCItems:RollTemporalWarpBoots(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_astral_glyph_3_1", Vector(-4928, 2048), 0)
    -- RPCItems:RollAvalanchePlate(Vector(-4928, 2048))
    -- RPCItems:RollTrapperArcana1(Vector(-4928, 2048))

    ---------MAX CURATION----------
    Curator:FullCurateHero(MAIN_HERO_TABLE[1])
    -- Timers:CreateTimer(40, function()
    --     Curator:CurateAllGlyphsForHero("neutral")
    -- end)
    -- Curator:CurateALLHeroes()
    -- Curator:CurateHero(MAIN_HERO_TABLE[1]:GetPlayerOwnerID())

    -- Timers:CreateTimer(10, function()
    --     Curator:CurateAllGlyphsForHero("solunia")
    -- end)
    -- Timers:CreateTimer(20, function()
    -- Curator:CurateArcanaAbilities(MAIN_HERO_TABLE[1])
    -- end)

    -- Events.DifficultyFactor = 3
    -- Events.SpiritRealm = true
    -- -- Tanari.WaterTemple = {}
    -- -- Tanari.FireTemple = {}
    -- Tanari:AcquireTempleKey(Vector(-4928, 2048), "wind")
    -- RPCItems:RollShadowflameFist(position)
    -- Curator:CurateALLGlyphs()
    -- RPCItems:RollHelmOfSilentTemplar(Vector(-4928, 2048), false)
    -- RPCItems:RollDuskbringerArcana1(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_auriun_glyph_5_a", Vector(-4928, 2048), 0)
    -- RPCItems:RollFalconBoots(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_hydroxis_glyph_1_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_hydroxis_glyph_2_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_hydroxis_glyph_3_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_neutral_glyph_4_3", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_hydroxis_glyph_5_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_hydroxis_glyph_6_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_hydroxis_glyph_7_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_hydroxis_glyph_5_a", Vector(-4928, 2048), 0)
    -- RPCItems:RollBerserkerGloves(Vector(-4928, 2048))
    -- RPCItems:RollSandstreamSlippers(Vector(-4928, 2048))
    -- RPCItems:RollWindDeityCrown(Vector(-4928, 2048), true, 10)
    -- RPCItems:RollStormshieldCloak(Vector(-4928, 2048))
    -- RPCItems:RollTorchOfGengar(Vector(-4928, 2048))
    -- RPCItems:RollGrandArcanist(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_sorceress_glyph_6_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_duskbringer_glyph_7_1", Vector(-4928, 2048), 0)
    -- RPCItems:RollSpaceTechVest(Vector(-4928, 2048))
    -- RPCItems:RollSilverspringGloves(Vector(-4928, 2048))
    -- RPCItems:RollRootedFeet(Vector(-4928, 2048))
    -- RPCItems:RollLegionVestments(Vector(-4928, 2048))
    -- RPCItems:RollDruidsSpiritHelm(Vector(-4928, 2048), false)
    -- RPCItems:RollGuardianGreaves(Vector(-4928, 2048))
    -- RPCItems:RollWindDeityCrown(Vector(-4928, 2048), true, 5)
    -- RPCItems:RollFloodRobe(Vector(-4928, 2048))
    -- RPCItems:RollInfernalPrison(Vector(-4928, 2048))
    -- RPCItems:RollFractionalEnhancementGeode(Vector(-4928, 2048))
    -- RPCItems:RollBerserkerGloves(Vector(-4928, 2048))
    -- RPCItems:RollWaterDeityCrown(Vector(-4928, 2048), true, 5)
    -- RPCItems:RollFireDeityCrown(Vector(-4928, 2048), true, 5)
    -- Tanari:DefeatDungeonBoss("water", Vector(-4928, 2048))
    -- Tanari:DefeatDungeonBoss("wind", Vector(-4928, 2048))
    -- Tanari:DefeatDungeonBoss("fire", Vector(-4928, 2048))
    -- Tanari:SpawnWindBossStaff()
    -- Tanari:GenericCrystal(300, Vector(-4928, 2048))
    -- RPCItems:RollLumaGuard(Vector(-4928, 2048), false)
    -- Tanari:SpawnAncientHero()
    -- RPCItems:RollLumaGuard(Vector(-4928, 2048), false)
    -- RPCItems:RollGloveOfTheForgottenGhost(Vector(-4928, 2048))
    -- RPCItems:RollRingOfNobility(Vector(-4928, 2048))
    -- RPCItems:RollKnightCrusherArmor(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_sorceress_glyph_6_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_duskbringer_glyph_2_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_mountain_protector_glyph_1_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_mountain_protector_glyph_2_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_mountain_protector_glyph_3_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_mountain_protector_glyph_4_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_mountain_protector_glyph_5_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_mountain_protector_glyph_6_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_mountain_protector_glyph_7_1", Vector(-4928, 2048), 0)
    -- Tanari:CreateAugmentedRingOfNobility(MAIN_HERO_TABLE[1])
    -- RPCItems:RollWaterMageRobes(Vector(-4928, 2048))
    -- Glyphs:RollRandomGlyph(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_warlord_glyph_2_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_warlord_glyph_3_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_warlord_glyph_4_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_warlord_glyph_5_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_warlord_glyph_6_1", Vector(-4928, 2048), 0)
    -- Glyphs:RollGlyphAll("item_rpc_warlord_glyph_7_1", Vector(-4928, 2048), 0)
    -- Tanari:SpawnWindBossStaff()
    -- Tanari.unibi:SetAbsOrigin(Vector(5440, -128))
    -- Tanari.unibi.phase = 10
    -- Tanari.unibi.mountainNomadDead = true
    -- Tanari:BeginSideTempleOpenSequence()
    -- Tanari:SpawnSeaHydra()

    -- Tanari:SpawnThicket()
    -- Tanari:InitializeWindTemple()

    -- Tanari:SpawnWindTemplePart2()
    -- Tanari.WindTemple.staffSequenceComplete = true
    -- Tanari:SpawnMasterOfStorms()
    -- Tanari:BeginBattleTacticsRoom()

    -- Tanari:InitializeCave()
    -- Tanari:SpawnCaveRoom2()
    -- Tanari:SpawnSpikeRoom()
    -- Tanari:SpawnBoulderspineFinalRoom()
    -- Timers:CreateTimer(2, function()
    --   Tanari:ShatterPrincess()
    -- end)
    -- Tanari:SpawnLindworm()
    -- Tanari:DefeatDungeonBoss("fire", Vector(-4928, 2048))
    -- Tanari:AcquireEssence("wind", Vector(-4928, 2048))
    -- Tanari:AcquireEssence("water", Vector(-4928, 2048))
    -- Tanari:AcquireEssence("fire", Vector(-4928, 2048))
    -- Tanari:AcquireTempleKey(Vector(-4928, 2048), "fire")
    -- Tanari.FireTemple = {}
    -- local boss = Tanari:SpawnKelthas()
    -- Timers:CreateTimer(2, function()
    --   Tanari:SpawnFireLord(boss)
    -- end)
    -- Tanari:AcquireTempleKey(Vector(-4928, 2048), "water")
    --  Tanari:AcquireTempleKey(Vector(-4928, 2048), "wind")
    -- Tanari:SpawnOutsideWaterTemple()

    -- Tanari:InitializeWaterTemple()
    -- Timers:CreateTimer(2, function()
    --   Tanari:OpenShieldWall(shield)
    -- end)
    -- Tanari:WaterTemplePrisonRoom()

    --   local particle1 = ParticleManager:CreateParticle( "particles/radiant_fx2/cave_summon_destruction_growinitsphere.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster )
    -- ParticleManager:SetParticleControl( particle1, 0, Vector(-4928, 2048, 420))
    -- ParticleManager:SetParticleControl( particle1, 1, Vector(-4928, 2048, 420))
    -- ParticleManager:SetParticleControl( particle1, 2, Vector(-4928, 2048, 420))
    -- ParticleManager:SetParticleControl( particle1, 3, Vector(-4928, 2048, 420))
end

function Tanari:SpawnTrainingDummy(position)
    local positionTable = {position}
    for i = 1, #positionTable, 1 do
        local dummy = CreateUnitByName("arena_training_dummy", positionTable[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
        dummy:SetForwardVector(Vector(1, -1))
        dummy.targetPosition = dummy:GetAbsOrigin()
        dummy.pushLock = true
        -- AddFOWViewer(DOTA_TEAM_GOODGUYS, dummy.targetPosition, 500, 4, false)
        -- Timers:CreateTimer(6, function()
        --   if IsValidEntity(dummy) then
        --     local dummyAbility = dummy:FindAbilityByName("training_dummy_ability")
        --     dummyAbility:ApplyDataDrivenModifier(dummy, dummy, "modifier_dummy_freeze", {})
        --   end
        -- end)
    end

end

function Tanari:AddPatrolArguments(unit, patrolSlow, phaseIntervals, patrolPointRandom, patrolPositionTable)
    unit:AddAbility("monster_patrol"):SetLevel(1)
    unit.patrolSlow = patrolSlow
    unit.phaseIntervals = phaseIntervals
    unit.patrolPointRandom = patrolPointRandom
    unit.patrolPositionTable = patrolPositionTable
end

function Tanari:CreateAugmentedRingOfNobility(hero)
    local item = RPCItems:CreateVariant("item_rpc_ring_of_nobility_augmented", "immortal", "Ring of Nobility Augmented", "amulet", true, "Slot: Trinket")
    local maxFactor = RPCItems:GetMaxFactor()

    item.property1name = "nobility_augmented"
    item.property1 = 1

    RPCItems:SetPropertyValuesSpecial(item, "★", "#item_property_nobility_augmented", "#FFFFFF", 1, "#property_nobility_augmented_description")

    item.property2 = 150
    local primaryAttribute = hero:GetPrimaryAttribute()
    if primaryAttribute == 0 then
        item.property2name = "strength"
        RPCItems:SetPropertyValues(item, item.property2, "#item_strength", "#CC0000", 2)
    elseif primaryAttribute == 1 then
        item.property2name = "agility"
        RPCItems:SetPropertyValues(item, item.property2, "#item_agility", "#2EB82E", 2)
    else
        item.property2name = "intelligence"
        RPCItems:SetPropertyValues(item, item.property2, "#item_intelligence", "#33CCFF", 2)
    end

    item.property3 = 10
    item.property3name = "rune_b_a"
    RPCItems:SetPropertyValues(item, item.property3, "rune", "#7DFF12", 3)

    item.property4 = 20
    item.property4name = "rune_a_b"
    RPCItems:SetPropertyValues(item, item.property4, "rune", "#7DFF12", 4)
    RPCItems:AmuletPickup(hero, item)
    Weapons:Equip(hero, item)
    return item
end

function Tanari:Debug2()
    -- Stars:GetPlayerStars(MAIN_HERO_TABLE[1]:GetPlayerID())
    -- Stars:StarEventPlayer("power_up", MAIN_HERO_TABLE[1])
    Tanari.WindTemple = {}
    -- Tanari:SpiritWindTempleStart()
    -- Tanari:SpiritWindTempleRoom2()
    Tanari:SpiritWindTempleBossRoom()

    -- Tanari:SpawnWaterSpirit(Vector(-9901, 16128), Vector(0,-1))
    -- Tanari:SpawnWaterSpiritRoom2()
    -- Tanari:SpiritWaterSection2()
    -- Tanari.WaterTemple = {}
    -- Tanari:BigDoorBeachRoom()
    -- Tanari:InitiateLastSpiritRoom()
    -- Tanari:SpawnWaterSpiritFinalBoss()
    -- Tanari:SpawnWaterTempleWaveRoom()
    -- MAIN_HERO_TABLE[1]:ForceKill(false)

    -- Tanari:FireTemplePart4()
    -- Tanari:FireSpiritPortalRoom()

    -- Tanari:SpawnFireSpiritFinalBoss()

    -- Tanari:InitPortal2Room()
    -- Tanari:WaterTemplePrisonRoom()
    -- Tanari:BeginBossSpawnSequence()
    -- Tanari:SpawnWindBossStaff()
    -- Tanari:DefeatDungeonBoss("wind", Vector(-4928, 2048))
    -- Tanari.TerrasicWarlockDead = true
    -- Glyphs:DropArcaneCrystals(Vector(-4928, 2048), 1)
    -- Tanari:SpawnBackVaultMasterRoom()
    -- RPCItems:RollWaterMageRobes(Vector(-4928, 2048))
    -- Tanari:SpawnWindTemplePart2()
    -- RPCItems:RollFirelockPendant(Vector(-4928, 2048))
    -- Tanari:SpawnFireTempleRoom1Part2()
    -- Tanari:FireTempleRoom3()
    -- Tanari:FireTemplePart4()
    -- Tanari:CreateSpiritAmbience()
    -- local unit = Tanari:SpawnThicketUrsa(Vector(-4928, 2048), RandomVector(1))
    -- local newHealth = (2^30)-10
    -- unit:SetMaxHealth(newHealth)
    -- unit:SetBaseMaxHealth(newHealth)
    -- unit:SetHealth(newHealth)
    -- unit:Heal(newHealth, unit)
    -- RPCItems:RollTwigOfEnlightened(Vector(-4928, 2048))
    -- Glyphs:RollGlyphAll("item_rpc_warlord_glyph_1_1", Vector(-4928, 2048), 0)
    -- RPCItems:RollDepthCrestArmor(Vector(-4928, 2048))
    -- RPCItems:RollTerrasicStonePlate(Vector(-4928, 2048))
    -- Tanari:SpawnRareLavaForgeMaster(Vector(6400, -12416), Vector(-1,0.2))
    -- RPCItems:RollLavaForgeCrown(Vector(-4928, 2048), false)
    -- Tanari:SpawnRareWaterWrath(Vector(-6144, 13568), Vector(1,0))
    -- RPCItems:RollDragonCeremonyVestments(Vector(-4928, 2048))
    -- Tanari:SpawnRareBlackCentaur(Vector(9141, -12843), Vector(0,-1))
    -- RPCItems:RollHoodOfDefiler(Vector(-4928, 2048), false)
    -- RPCItems:RollGoldenWarPlate(Vector(-4928, 2048))
    -- RPCItems:RollGreensandCopperGauntlets(Vector(-4928, 2048))
    -- local msg = {}
    -- msg.playerID = MAIN_HERO_TABLE[1]:GetPlayerOwnerID()
    -- msg.itemIndex = MAIN_HERO_TABLE[1]:GetItemInSlot(0):GetEntityIndex()
    -- msg.cost = 1
    -- if not Tanari.reroll then
    --   Tanari.reroll = 0
    -- end
    -- Tanari.reroll = Tanari.reroll+1
    ----print(Tanari.reroll)
    -- Challenges:FinalReroll(msg)
    -- Tanari.WaterTemple = {}
    --   Timers:CreateTimer(1.5, function()
    --     Dungeons:CreateBasicCameraLock(Vector(-4943, 10831, 300), 6.5)
    --     local spinePos = Vector(-4904, 10659.3, -78)
    --     local heightDiff = 672
    --     local spine = Entities:FindByNameNearest("WaterTempleBossSpine", Vector(-4904, 10659, -750), 600)
    --     for i = 1, 120, 1 do
    --       Timers:CreateTimer(i*0.03, function()
    --         spine:SetAbsOrigin(spine:GetAbsOrigin()+Vector(0,0,heightDiff/120))
    --       end)
    --     end
    --     Timers:CreateTimer(2, function()
    --       EmitSoundOnLocationWithCaster(Vector(-4943, 10671, 300), "Tanari.WaterTemple.BossStatueMenace", Events.GameMaster)
    --     end)
    --   end)

    --   Timers:CreateTimer(10.5, function()
    --     Tanari.WaterTemple.bossStatueSpines = true
    --     Dungeons:CreateBasicCameraLock(Vector(-4943, 10831, 300), 6.5)
    --     local finalTridentPos = Vector(-5160.92, 10624, 483)
    --     local heightDiff = 713
    --     local trident = Entities:FindByNameNearest("WaterTempleBossTrident", Vector(-5160, 10624, -250), 600)
    --     for i = 1, 120, 1 do
    --       Timers:CreateTimer(i*0.03, function()
    --         trident:SetAbsOrigin(trident:GetAbsOrigin()+Vector(0,0,heightDiff/120))
    --       end)
    --     end
    --     Timers:CreateTimer(2, function()
    --       EmitSoundOnLocationWithCaster(Vector(-4943, 10671, 300), "Tanari.WaterTemple.BossStatueMenace", Events.GameMaster)
    --     end)
    --   end)

    --   Timers:CreateTimer(20.5, function()
    --     Tanari.WaterTemple.bossStatueTrident = true
    --     Dungeons:CreateBasicCameraLock(Vector(-4943, 10831, 300), 6.5)
    --     local finalHelmPos = Vector(-4888.75, 10624, -102)
    --     local heightDiff = 900
    --     local mask = Entities:FindByNameNearest("WaterTempleBossMask", Vector(-4888, 10624, -1000), 600)
    --     for i = 1, 120, 1 do
    --       Timers:CreateTimer(i*0.03, function()
    --         mask:SetAbsOrigin(mask:GetAbsOrigin()+Vector(0,0,heightDiff/120))
    --       end)
    --     end
    --     Timers:CreateTimer(2, function()
    --       EmitSoundOnLocationWithCaster(Vector(-4943, 10671, 300), "Tanari.WaterTemple.BossStatueMenace", Events.GameMaster)
    --     end)

    --   end)
    --   Timers:CreateTimer(25, function()
    --     Tanari:CheckWaterBossCondition()
    --   end)
    --   Tanari.WaterTemple.bossStatueHelm = true
    -- Tanari:SpawnWindTemplePart2()

end

function Tanari:CreateDummyUnit(position, model, modelscale)
    local visionTracer = CreateUnitByName("npc_flying_dummy_vision", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
    visionTracer:AddAbility("dummy_unit"):SetLevel(1)
    if model then
        visionTracer:SetOriginalModel(model)
        visionTracer:SetModel(model)
        visionTracer:SetModelScale(modelscale)
    end
    return visionTracer
end

function Tanari:InitCamp()
    --print("Initialize Tanari Jungle")
    Dungeons.phoenixCollision = true
    RPCItems.DROP_LOCATION = Vector(6656, -16128)
    Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
    Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
    Events.GameMaster:RemoveModifierByName("modifier_portal")

    Tanari.TanariMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
    Tanari.TanariMaster:AddAbility("tanari_ability"):SetLevel(GameState:GetDifficultyFactor())
    Tanari.TanariMasterAbility = Tanari.TanariMaster:FindAbilityByName("tanari_ability")
    Tanari.TanariMaster:AddAbility("dummy_unit"):SetLevel(1)

    if Beacons.cheats then
        TANARI_V2 = true
    end
    Tanari.ZFLOAT = 0
    -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-4864, 4112), 5000, 5000, false)
    Timers:CreateTimer(2, function()
        Tanari:SpawnWitchDoctor(Vector(-4224, 2368), Vector(-1, -1))
        -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13888,14380), 1250, 99999, false)
        -- -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13888,1928), 500, 99999, false)
        -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13945, 12400, 200), 500, 99999, false)
        -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-14452, 12400, 200), 500, 99999, false)
        -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13438, 12400, 200), 500, 99999, false)
        Events:SpawnSuppliesDealer(Vector(-3232, 2427), Vector(0, -1))

    end)
    Events.TownPosition = Vector(-4928, 2048)
    Events.isTownActive = true
    Events.Dialog0 = false
    Events.Dialog1 = false
    Events.Dialog2 = false
    Events.Dialog3 = false
    Dungeons.itemLevel = 1
    Tanari.BossesSlainNormal = 0
    Tanari.BossesSlainSpirit = 0
    Timers:CreateTimer(3, function()
        local blacksmith = Events:SpawnTownNPC(Vector(-5443, 2606), "red_fox", Vector(0.2, -1), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
        StartAnimation(blacksmith, {duration = 99999, activity = ACT_DOTA_IDLE, rate = 1.0})
        local oracle = Events:SpawnOracle(Vector(-4160, 1408), Vector(-0.7, 1))
        Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(-5184, 1521), Vector(1, 1))

        Tanari:SpawnTrainingDummy(Vector(-5192, 523))
    end)
    Timers:CreateTimer(5, function()
        Tanari:CreateDynamicBlockers()
        Events:SpawnCurator(Vector(-2656, 3456), Vector(1, -0.3))
    end)
    Timers:CreateTimer(10, function()
        Tanari:SetupMaze()
    end)
    Tanari.TerrasicCrater = {}
    Timers:CreateTimer(4, function()
        Tanari:SpawnChampionsTrailPart1()
    end)

    Timers:CreateTimer(10, function()
        CalculateHeroZones()
        return 10
    end)
    Timers:CreateTimer(5, function()
        Tanari:RareSpawns()
    end)
    -- Tanari:SpawnTerrasicCraterZone1()
end

function Tanari:CreateDynamicBlockers()
    Tanari:CreateSideTempleDynamicBlockers()
    Tanari:CreateCaveBlockers()
    Timers:CreateTimer(10, function()
        Tanari:CreateWaterKeyWall()
    end)
end

function Tanari:CreateSideTempleDynamicBlockers()
    Tanari.springTempleBlock1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(2816, 2740, 328), name = "wallObstruction"})
    Tanari.springTempleBlock2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(2688, 2740, 328), name = "wallObstruction"})
    Tanari.springTempleBlock3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(2560, 2740, 328), name = "wallObstruction"})
    Tanari.springTempleBlock4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(2432, 2740, 328), name = "wallObstruction"})
    Tanari.springTempleBlock5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(2304, 2740, 328), name = "wallObstruction"})
end

function Tanari:CreateWaterKeyWall()
    Tanari.waterKeyBlock1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(8512, -5120, 128), name = "wallObstruction"})
    Tanari.waterKeyBlock2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(8512, -5248, 128), name = "wallObstruction"})
    Tanari.waterKeyBlock3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(8512, -5376, 128), name = "wallObstruction"})

    local wallPoint1 = Vector(8512, -4992, 670)
    local wallPoint2 = Vector(8512, -5440, 670)
    local particle = "particles/units/heroes/hero_dark_seer/water_temple_wall_of_replica.vpcf"
    Tanari.WaterKeyWallParticle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl(Tanari.WaterKeyWallParticle, 0, wallPoint1)
    ParticleManager:SetParticleControl(Tanari.WaterKeyWallParticle, 1, wallPoint2)

end

function Tanari:SpawnEnemyUnit(unit_name, location, fv)
    local unit = CreateUnitByName(unit_name, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
    unit:SetForwardVector(fv)
    Events:AdjustDeathXP(unit)
    return unit
end

function Tanari:SpawnDungeonUnit(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)

    local luck = 0
    if not Events.SpiritRealm then
        luck = RandomInt(1, 180)
    else
        luck = RandomInt(1, 60)
    end
    local unit = ""
    if luck == 1 then
        unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
    else
        unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
        Events:AdjustDeathXP(unit)
    end
    local ability = unit:FindAbilityByName("dungeon_creep")
    if ability then
        ability:SetLevel(1)
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
    end
    if aggroSound then
        unit.aggroSound = aggroSound
    end
    unit.minDungeonDrops = minDrops
    unit.maxDungeonDrops = maxDrops
    if fv then
        unit:SetForwardVector(fv)
    end
    if isAggro then
        Dungeons:AggroUnit(unit)
    end
    return unit
end

function Tanari:AcquireTempleKey(position, temple)
    local crystal = CreateUnitByName("arcane_crystal", position + Vector(0, 0, 1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
    crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1300))
    local crystalAbility = crystal:AddAbility("temple_key_ability")
    crystalAbility:ApplyDataDrivenModifier(crystal, crystal, "temple_key_"..temple.."_effect", {})
    crystalAbility:SetLevel(1)
    local fv = RandomVector(1)
    crystal:SetOriginalModel("models/items/meepo/meepo_skeletonkey_sword/meepo_skeletonkey_sword.vmdl")
    crystal:SetModel("models/items/meepo/meepo_skeletonkey_sword/meepo_skeletonkey_sword.vmdl")

    crystal:SetModelScale(1.4)
    crystal.fallVelocity = 45
    crystal.falling = true
    crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
    Timers:CreateTimer(3, function()
        EmitSoundOn("Tanari.KeyCollect", crystal)
    end)
    Timers:CreateTimer(6, function()
        crystal.interval = 0

        for i = 1, #crystal.winnerTable, 1 do
            if IsValidEntity(crystal.winnerTable[i]) then
                Tanari:CreateCollectionBeam(crystal:GetAbsOrigin() + Vector(0, 0, 220), crystal.winnerTable[i]:GetAbsOrigin())
                CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", crystal.winnerTable[i], 0.5)
                EmitSoundOn("Resource.MithrilShardEnter", crystal.winnerTable[i])

                --GIVE KEY TO PLAYER
                local itemName = "item_tanari_"..temple.."_temple_key_"..GameState:GetDifficultyName()
                local key = RPCItems:CreateConsumable(itemName, "rare", "temple_key", "consumable", false, "Consumable", itemName.."_desc")
                RPCItems:GiveItemToHeroWithSlotCheck(crystal.winnerTable[i], key)
            end
        end
        Timers:CreateTimer(0.05, function()
            crystal:SetModelScale(0.05)
            crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 100))
        end)
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", crystal, 0.5)

        crystal.dispersion = false
        Timers:CreateTimer(3, function()
            crystal.leaving = true
        end)
    end)
end

function Tanari:CreateCollectionBeam(attachPointA, attachPointB)
    local particleName = "particles/items_fx/mithril_collect.vpcf"
    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
    ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
    end)
end

function Tanari:DefeatDungeonBoss(element, position)
    Timers:CreateTimer(0.1, function()
        Tanari:AcquireEssence(element, position)
    end)
    Tanari.BossesSlainNormal = Tanari.BossesSlainNormal + 1
    if Events.SpiritRealm then
        Tanari.BossesSlainSpirit = Tanari.BossesSlainSpirit + 1
    end
    Timers:CreateTimer(15, function()
        if Tanari.BossesSlainNormal == 3 then
            Tanari.BossesSlainNormal = -1
            if GameState:GetDifficultyFactor() == 3 then
                Tanari:SpawnAncientHero()
            end
        end
    end)
    Timers:CreateTimer(5, function()
        local mithrilReward = 0
        local starTitle = false
        if element == "wind" then
            mithrilReward = 30
            starTitle = element
        elseif element == "water" then
            mithrilReward = 70
            starTitle = element
        elseif element == "fire" then
            mithrilReward = 100
            starTitle = element
        end
        if starTitle then
            for i = 1, #MAIN_HERO_TABLE, 1 do
                --print("STARS WTF??")
                Stars:StarEventPlayer(starTitle, MAIN_HERO_TABLE[i])
            end
        end
        local mithrilMult = 1
        if GameState:GetDifficultyFactor() == 2 then
            mithrilMult = 2
        elseif GameState:GetDifficultyFactor() == 3 then
            mithrilMult = 6
        end
        if Events.SpiritRealm then
            mithrilMult = mithrilMult * 3
        end
        mithrilReward = math.floor(mithrilReward * mithrilMult) * Events.ResourceBonus
        local crystal = CreateUnitByName("arcane_crystal", position + Vector(0, 0, 1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward * (1 + GameState:GetPlayerPremiumStatusCount() * 0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward / 200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #potentialWinnerTable, 1 do
        --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
        --  local completed = completedTable.completed
        --  if completed == 0 then
        --    potentialWinnerTable[i].shardsPickedUp = 0
        --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
        --  end
        -- end
        if #crystal.winnerTable > 0 then
            -- for i = 1, #crystal.winnerTable, 1 do
            --   crystal.winnerTable[i].shardsPickedUp = 0
            -- end
            Timers:CreateTimer(1.4, function()
                EmitSoundOn("Resource.MithrilShardEnter", crystal)
            end)
        end
    end)
end

function Tanari:DefeatSpiritBoss(element, position)
    Timers:CreateTimer(5, function()
        local mithrilReward = 0
        local starTitle = false
        if element == "wind" then
            mithrilReward = 160
            starTitle = element
        elseif element == "water" then
            mithrilReward = 160
            starTitle = element
        elseif element == "fire" then
            mithrilReward = 160
            starTitle = element
        end
        local mithrilMult = 1
        if GameState:GetDifficultyFactor() == 2 then
            mithrilMult = 2
        elseif GameState:GetDifficultyFactor() == 3 then
            mithrilMult = 6
        end
        if Events.SpiritRealm then
            mithrilMult = mithrilMult * 3
        end
        mithrilReward = math.floor(mithrilReward * mithrilMult)
        local crystal = CreateUnitByName("arcane_crystal", position + Vector(0, 0, 1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward * (1 + GameState:GetPlayerPremiumStatusCount() * 0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward / 200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #potentialWinnerTable, 1 do
        --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
        --  local completed = completedTable.completed
        --  if completed == 0 then
        --    potentialWinnerTable[i].shardsPickedUp = 0
        --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
        --  end
        -- end
        if #crystal.winnerTable > 0 then
            for i = 1, #crystal.winnerTable, 1 do
                crystal.winnerTable[i].shardsPickedUp = 0
            end
            Timers:CreateTimer(1.4, function()
                EmitSoundOn("Resource.MithrilShardEnter", crystal)
            end)
        end
    end)
end

function Tanari:SetPositionCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
    unit.targetRadius = radius
    unit.minRadius = minRadius
    unit.targetAbilityCD = cooldown
    unit.targetFindOrder = targetFindOrder
end

function Tanari:AcquireEssence(element, position)
    for i = 1, #MAIN_HERO_TABLE, 1 do
        Tanari:CreateCollectionBeam(position, MAIN_HERO_TABLE[i]:GetAbsOrigin())
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", MAIN_HERO_TABLE[i], 0.5)
        EmitSoundOn("Resource.MithrilShardEnter", MAIN_HERO_TABLE[i])
        local itemName = ""
        if element == "wind" then
            itemName = "item_tanari_essence_of_wind"
        elseif element == "water" then
            itemName = "item_tanari_heart_of_water"
        elseif element == "fire" then
            itemName = "item_tanari_core_of_fire"
        end
        --GIVE KEY TO PLAYER
        local itemName = itemName.."_"..GameState:GetDifficultyName()
        local key = RPCItems:CreateConsumable(itemName, "mythical", "tanari_element", "consumable", false, "Key Item", itemName.."_desc")
        RPCItems:ItemUpdateCustomNetTables(key)
        RPCItems:GiveItemToHeroWithSlotCheck(MAIN_HERO_TABLE[i], key)
    end
end

function Tanari:SpawnWitchDoctor(position, forwardVector)
    local oracle = CreateUnitByName("tanari_witch_doctor", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
    oracle:SetForwardVector(forwardVector)
    oracle:NoHealthBar()
    oracle:AddAbility("town_unit")
    oracle:AddAbility("npc_dialogue")
    oracle:FindAbilityByName("town_unit"):SetLevel(1)
    oracle:FindAbilityByName("npc_dialogue"):SetLevel(1)
    oracle.dialogueName = "witch_doctor"
    Tanari.fountainAbility = oracle:FindAbilityByName("tanari_fountain")
    Tanari.WitchDoctor = oracle
end

function Tanari:WitchDoctorCombine(hero, difficulty)
    local witchDoctor = Tanari.WitchDoctor
    local witchAbility = Tanari.fountainAbility
    --print(difficulty)
    -- local itemName = itemName.."_"..GameState:GetDifficultyName()
    local itemName = "item_tanari_spirit_stones_"..Tanari:ConvertDifficultyNumberToName(difficulty)
    --print("FINAL COMBINE")
    witchAbility:ApplyDataDrivenModifier(witchDoctor, witchDoctor, "modifier_tanari_combining_elements", {duration = 6.5})
    for i = 1, 5, 1 do
        Timers:CreateTimer(i, function()
            CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_start.vpcf", witchDoctor, 3)
            EmitSoundOnLocationWithCaster(witchDoctor:GetAbsOrigin(), "Tanari.CombineLight", witchDoctor)
        end)
    end
    Timers:CreateTimer(5.5, function()
        Tanari:CreateCollectionBeam(hero:GetAbsOrigin() + Vector(0, 0, 50), witchDoctor:GetAbsOrigin() + Vector(0, 0, 220))
        EmitSoundOn("Resource.MithrilShardEnter", hero)
        EmitGlobalSound("Tanari.CombineHeavy")
        CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", witchDoctor, 3)
        local stones = RPCItems:CreateConsumable(itemName, "immortal", "tanari_spirit_stones", "consumable", false, "Consumable", itemName.."_desc")
        stones.pickedUp = true
        RPCItems:GiveItemToHeroWithSlotCheck(hero, stones)
    end)
end

function Tanari:ConvertDifficultyNumberToName(number)
    if number == 1 then
        return "normal"
    end
    if number == 2 then
        return "elite"
    end
    if number == 3 then
        return "legend"
    end
end

function Tanari:CreateSpiritAmbience()
    local basePos = Vector(-9472, -14208)
    local spirit1 = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(-3712, 2880, 420)})
    spirit1:SetModel("models/effects/fountain_radiant_00.vmdl")
    local spirit2 = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(-4032, 1144, 510)})
    spirit2:SetModel("models/effects/fountain_radiant_00.vmdl")
    for i = 1, 9, 1 do
        for j = 1, 9, 1 do
            Timers:CreateTimer(i * 0.5, function()
                local position = basePos + Vector(i * 2000 + RandomInt(-500, 500), j * 3500 + RandomInt(-600, 600))
                local height = GetGroundHeight(position, Events.GameMaster)
                local spirit = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(position.x, position.y, height + 200)})
                spirit:SetModel("models/effects/fountain_radiant_00.vmdl")
            end)
        end
    end
end

function CalculateHeroZones()
    if MAIN_HERO_TABLE then
        for i = 1, #MAIN_HERO_TABLE, 1 do
            local hero = MAIN_HERO_TABLE[i]
            local heroOrigin = hero:GetAbsOrigin()
            if (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-10176, 3520), Vector(-5632, 6272))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-10176, 6272), Vector(-4068, 8640))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-10098, 8842), Vector(82, 16600))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_water_temple"})
            elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(320, 6144), Vector(4212, 10560))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(460, 10808), Vector(4160, 13440))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(1321, 13952), Vector(3265, 15168))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_cavern"})
            elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(6343, 8370), Vector(10000, 12480))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(4864, 11386), Vector(10000, 14772))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(3584, 14336), Vector(10000, 16000))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_wind_temple"})
            elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-6016, 640), Vector(-3392, 3223))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_town"})
            elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-5760, -2048), Vector(2816, 512))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_lake"})
            elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(2112, -4643), Vector(10048, 940))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_mountain_side"})
            elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(5449, 1536), Vector(10048, 6780))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(4544, 5760), Vector(5760, 10816))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_thicket"})
            elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-10000, -16000), Vector(-951, -3392))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-10000, -4100), Vector(-4416, -2048))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_terrasic_crater"})
            elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-1472, -16384), Vector(10400, -6300))) then
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_tanari_fire_temple"})
            else
                CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "world_tanari_jungle"})
            end
        end
    end
end

function Tanari:RareSpawns()
    local luck = RandomInt(1, 3)
    if luck == 1 then
        Tanari.WindProphet = true
        Timers:CreateTimer(13, function()
            PrecacheUnitByNameAsync("wind_temple_rare_wind_prophet", function(...) end)
        end)
    end

    Timers:CreateTimer(1, function()
        local luck = RandomInt(1, 5)
        if luck == 1 then
            Tanari.BlackCentaur = true
            Timers:CreateTimer(20, function()
                PrecacheUnitByNameAsync("fire_temple_rare_blackguard_centaur", function(...) end)
            end)
        end
    end)

    Timers:CreateTimer(2, function()
        local luck = RandomInt(1, 5)
        if luck == 1 then
            Tanari.RareLavaForge = true
            Timers:CreateTimer(22, function()
                PrecacheUnitByNameAsync("fire_temple_rare_lava_forgemaster", function(...) end)
            end)
        end
    end)

    Timers:CreateTimer(3, function()
        local luck = RandomInt(1, 3)
        if luck == 1 then
            Tanari.RareWaterWrath = true
            Timers:CreateTimer(25, function()
                PrecacheUnitByNameAsync("water_temple_rare_wrath_of_the_water_king", function(...) end)
            end)
        end
    end)

    Timers:CreateTimer(7, function()
        local luck = RandomInt(1, 4)
        if luck == 1 and GameState:GetDifficultyFactor() > 1 then
            Tanari.RareFalconWarder = true
            -- Timers:CreateTimer(22, function()
            --   PrecacheUnitByNameAsync("wind_temple_rare_falcon_warden", function(...) end)
            -- end)
        end
    end)

    Timers:CreateTimer(10, function()
        local luck = RandomInt(1, 5)
        if luck == 1 and GameState:GetDifficultyFactor() > 1 then
            Tanari.RareWaterConstruct = true
            Timers:CreateTimer(22, function()
                PrecacheUnitByNameAsync("water_temple_rare_water_construct", function(...) end)
            end)
        end
    end)

end

function Tanari:ColorWearables(unit, color)
    for k, v in pairs(unit:GetChildren()) do
        if v:GetClassname() == "dota_item_wearable" then
            local model = v:GetModelName()
            v:SetRenderColor(color[1], color[2], color[3])
        end
    end
end

function Tanari:SpawnAncientHero()

    local position = Vector(3840, 0, 1300)
    Dungeons.respawnPoint = Vector(-2176, 2176)
    local particle1 = ParticleManager:CreateParticle("particles/roshpit/tanari/spawn_ancient_hero.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl(particle1, 0, position)
    ParticleManager:SetParticleControl(particle1, 1, position)
    ParticleManager:SetParticleControl(particle1, 2, position)
    ParticleManager:SetParticleControl(particle1, 3, position)
    AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 1000, 8, true)
    Dungeons:CreateBasicCameraLockNoVision(position + Vector(0, 100, 0), 6.8)
    Timers:CreateTimer(1.1, function()
        EmitSoundOnLocationWithCaster(position, "Tanari.AncientHero.Prespawning", Events.GameMaster)
    end)

    Timers:CreateTimer(3.35, function()
        EmitSoundOnLocationWithCaster(position, "Tanari.AncientHero.Spawn", Events.GameMaster)
    end)
    Timers:CreateTimer(3.8, function()
        Tanari:SpawnFinalBoss(position, Vector(-1, 0))
    end)
end

function Tanari:SpawnFinalBoss(position, fv)
    local ancient = Tanari:SpawnDungeonUnit("tanari_ancient_hero", position, 2, 4, "Tanari.AncientHeroAggro", fv, false)
	ancient.type = ENEMY_TYPE_MAJOR_BOSS
    ancient.element = 1
    EmitSoundOn("Tanari.AncientHeroAggro", ancient)
    Events:AdjustBossPower(ancient, 16, 16, true)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_zuus/zeus_loadout.vpcf", ancient, 3)
    ancient:SetRenderColor(150, 255, 150)
    Tanari:ColorWearables(ancient, Vector(150, 255, 150))
    -- ancient:SetAcquisitionRange(99999)
    -- ancient:SetRenderColor(80, 80, 80)
    ancient.starting = true
    --print("ANCHENT AGGRO??")
    --print(ancient.aggro)

    ancient:AddAbility("ancient_god_wind_blink_ability"):SetLevel(3)

    ancient.startingPercent = 1.0
    Timers:CreateTimer(6, function()
        for i = 1, #MAIN_HERO_TABLE, 1 do
            Stars:StarEventSolo("weapon", MAIN_HERO_TABLE[i])
        end
    end)
    return ancient
end

function Tanari:GenericCrystal(mithrilReward, position)
    Timers:CreateTimer(5, function()
        local mithrilMult = 1
        if GameState:GetDifficultyFactor() == 2 then
            mithrilMult = 2
        elseif GameState:GetDifficultyFactor() == 3 then
            mithrilMult = 6
        end
        if Events.SpiritRealm then
            mithrilMult = mithrilMult * 3
        end
        mithrilReward = math.floor(mithrilReward * mithrilMult)
        local crystal = CreateUnitByName("arcane_crystal", position + Vector(0, 0, 1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward * (1 + GameState:GetPlayerPremiumStatusCount() * 0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward / 200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #potentialWinnerTable, 1 do
        --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
        --  local completed = completedTable.completed
        --  if completed == 0 then
        --    potentialWinnerTable[i].shardsPickedUp = 0
        --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
        --  end
        -- end
        if #crystal.winnerTable > 0 then
            for i = 1, #crystal.winnerTable, 1 do
                crystal.winnerTable[i].shardsPickedUp = 0
            end
            Timers:CreateTimer(1.4, function()
                EmitSoundOn("Resource.MithrilShardEnter", crystal)
            end)
        end
    end)
end

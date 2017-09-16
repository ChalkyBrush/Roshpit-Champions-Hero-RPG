PVP_INCOME_TIME = 45

function PVP:LinewarSetupBuilderData()
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(0), {hero_icon = "npc_dota_hero_earthshaker", unitName = "tanari_mountain_bully", unitCode = "A0", income = "2", deathBounty = "2", goldCost = "20", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(1), {hero_icon = "npc_dota_hero_huskar", unitName = "tanari_tribal_ambusher", unitCode = "A1", income = "8", deathBounty = "8", goldCost = "80", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(2), {hero_icon = "npc_dota_hero_ursa", unitName = "tanari_thicket_ursa", unitCode = "A2", income = "14", deathBounty = "14", goldCost = "140", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(3), {hero_icon = "npc_dota_hero_dazzle", unitName = "tanari_thicket_priest", unitCode = "A3", income = "30", deathBounty = "30", goldCost = "300", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(4), {hero_icon = "npc_dota_hero_shadow_shaman", unitName = "tanari_thicket_pain_absorber", unitCode = "A4", income = "30", deathBounty = "30", goldCost = "300", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(5), {hero_icon = "npc_dota_hero_huskar", unitName = "tanari_headhunter", unitCode = "A5", income = "30", deathBounty = "30", goldCost = "300", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(6), {hero_icon = "npc_dota_hero_skywrath_mage", unitName = "wind_temple_avian_warder", unitCode = "A6", income = "40", deathBounty = "40", goldCost = "400", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(7), {hero_icon = "npc_dota_hero_phantom_lancer", unitName = "wind_temple_descendant_of_zeus", unitCode = "A7", income = "60", deathBounty = "60", goldCost = "700", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."A"..tostring(8), {hero_icon = "npc_dota_hero_furion", unitName = "wind_temple_rare_wind_prophet", unitCode = "A8", income = "300", deathBounty = "300", goldCost = "3000", builder="tanari"} )

	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(0), {hero_icon = "npc_dota_hero_sand_king", unitName = "boulderspine_cavern_monster", unitCode = "B0", income = "40", deathBounty = "40", goldCost = "400", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(1), {hero_icon = "npc_dota_hero_tidehunter", unitName = "boulderspine_cave_lizard", unitCode = "B1", income = "50", deathBounty = "50", goldCost = "500", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(2), {hero_icon = "npc_dota_hero_slardar", unitName = "boulderspine_slithereen_guard", unitCode = "B2", income = "70", deathBounty = "70", goldCost = "700", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(3), {hero_icon = "npc_dota_hero_naga_siren", unitName = "boulderspine_slithereen_featherguard", unitCode = "B3", income = "76", deathBounty = "76", goldCost = "760", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(4), {hero_icon = "npc_dota_hero_slark", unitName = "water_temple_shark", unitCode = "B4", income = "80", deathBounty = "80", goldCost = "800", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(5), {hero_icon = "npc_dota_hero_slardar", unitName = "boulderspine_slithereen_royal_guard", unitCode = "B5", income = "90", deathBounty = "90", goldCost = "900", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(6), {hero_icon = "npc_dota_hero_morphling", unitName = "water_temple_faceless_water_elemental", unitCode = "B6", income = "90", deathBounty = "90", goldCost = "900", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(7), {hero_icon = "npc_dota_hero_puck", unitName = "water_temple_fairy_dragon", unitCode = "B7", income = "100", deathBounty = "100", goldCost = "1000", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."B"..tostring(8), {hero_icon = "npc_dota_hero_obsidian_destroyer", unitName = "water_temple_rare_water_construct", unitCode = "B8", income = "1900", deathBounty = "1900", goldCost = "19000", builder="tanari"} )

	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(0), {hero_icon = "npc_dota_hero_axe", unitName = "terrasic_red_mist_soldier", unitCode = "C0", income = "120", deathBounty = "120", goldCost = "1200", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(1), {hero_icon = "npc_dota_hero_elder_titan", unitName = "terrasic_goremaw_flame_splitter", unitCode = "C1", income = "140", deathBounty = "140", goldCost = "1400", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(2), {hero_icon = "npc_dota_hero_clinkz", unitName = "fire_temple_blackguard", unitCode = "C2", income = "180", deathBounty = "180", goldCost = "1800", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(3), {hero_icon = "npc_dota_hero_doom_bringer", unitName = "fire_temple_blackguard_doombringer", unitCode = "C3", income = "220", deathBounty = "220", goldCost = "2200", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(4), {hero_icon = "npc_dota_hero_beastmaster", unitName = "fire_temple_secret_fanatic", unitCode = "C4", income = "260", deathBounty = "260", goldCost = "2600", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(5), {hero_icon = "npc_dota_hero_chaos_knight", unitName = "fire_temple_molten_war_knight", unitCode = "C5", income = "300", deathBounty = "300", goldCost = "3000", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(6), {hero_icon = "npc_dota_hero_juggernaut", unitName = "fire_temple_tempered_warrior", unitCode = "C6", income = "320", deathBounty = "320", goldCost = "3200", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(7), {hero_icon = "npc_dota_hero_terrorblade", unitName = "fire_temple_flame_wraith", unitCode = "C7", income = "380", deathBounty = "380", goldCost = "3800", builder="tanari"} )
	CustomNetTables:SetTableValue("premium_pass", "tanari_".."C"..tostring(8), {hero_icon = "npc_dota_hero_nyx_assassin", unitName = "fire_temple_rare_lava_forgemaster", unitCode = "C8", income = "900", deathBounty = "900", goldCost = "9000", builder="tanari"} )

	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(0), {hero_icon = "npc_dota_hero_ancient_apparition", unitName = "redfall_autumn_spirit", unitCode = "A0", income = "5", deathBounty = "5", goldCost = "50", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(1), {hero_icon = "npc_dota_hero_dark_seer", unitName = "redfall_forest_gnome", unitCode = "A1", income = "8", deathBounty = "8", goldCost = "80", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(2), {hero_icon = "npc_dota_hero_earth_spirit", unitName = "redfall_stone_watcher", unitCode = "A2", income = "20", deathBounty = "20", goldCost = "200", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(3), {hero_icon = "npc_dota_hero_drow_ranger", unitName = "redfall_forest_ranger", unitCode = "A3", income = "25", deathBounty = "25", goldCost = "250", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(4), {hero_icon = "npc_dota_hero_magnataur", unitName = "redfall_autumn_cragnataur", unitCode = "A4", income = "30", deathBounty = "30", goldCost = "300", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(5), {hero_icon = "npc_dota_hero_spirit_breaker", unitName = "redfall_canyon_bull", unitCode = "A5", income = "40", deathBounty = "40", goldCost = "400", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(6), {hero_icon = "npc_dota_hero_bloodseeker", unitName = "redfall_hooded_soul_reacher", unitCode = "A6", income = "50", deathBounty = "50", goldCost = "500", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(7), {hero_icon = "npc_dota_hero_furion", unitName = "redfall_autumn_mage", unitCode = "A7", income = "70", deathBounty = "70", goldCost = "700", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."A"..tostring(8), {hero_icon = "npc_dota_hero_drow_ranger", unitName = "redfall_ashara", unitCode = "A8", income = "450", deathBounty = "450", goldCost = "4500", builder="redfall"} )

	
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(0), {hero_icon = "npc_dota_hero_windrunner", unitName = "redfall_farmlands_bandit", unitCode = "B0", income = "70", deathBounty = "70", goldCost = "700", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(1), {hero_icon = "npc_dota_hero_bane", unitName = "redfall_harvest_wraith", unitCode = "B1", income = "70", deathBounty = "70", goldCost = "700", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(2), {hero_icon = "npc_dota_hero_shredder", unitName = "redfall_farmlands_corn_harvester", unitCode = "B2", income = "85", deathBounty = "85", goldCost = "850", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(3), {hero_icon = "npc_dota_hero_kunkka", unitName = "redfall_crymsith_duelist", unitCode = "B3", income = "85", deathBounty = "85", goldCost = "850", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(4), {hero_icon = "npc_dota_hero_lion", unitName = "redfall_crimsyth_recruiter", unitCode = "B4", income = "90", deathBounty = "90", goldCost = "900", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(5), {hero_icon = "npc_dota_hero_clinkz", unitName = "shipyard_skeleton_archer", unitCode = "B5", income = "90", deathBounty = "90", goldCost = "900", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(6), {hero_icon = "npc_dota_hero_furion", unitName = "redfall_farmlands_crymsith_taskmaster", unitCode = "B6", income = "90", deathBounty = "90", goldCost = "900", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(7), {hero_icon = "npc_dota_hero_chaos_knight", unitName = "redfall_shipyard_crimsyth_knight", unitCode = "B7", income = "100", deathBounty = "100", goldCost = "1000", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."B"..tostring(8), {hero_icon = "npc_dota_hero_tiny", unitName = "ancient_ruby_giant", unitCode = "B8", income = "1300", deathBounty = "1300", goldCost = "13000", builder="redfall"} )


	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(0), {hero_icon = "npc_dota_hero_tusk", unitName = "crimsyth_bombadier", unitCode = "C0", income = "120", deathBounty = "120", goldCost = "1200", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(1), {hero_icon = "npc_dota_hero_treant", unitName = "redfall_snarlroot_treant", unitCode = "C1", income = "140", deathBounty = "140", goldCost = "1400", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(2), {hero_icon = "npc_dota_hero_dragon_knight", unitName = "redfall_crimsyth_hawk_soldier_elite", unitCode = "C2", income = "180", deathBounty = "180", goldCost = "1800", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(3), {hero_icon = "npc_dota_hero_nevermore", unitName = "redfall_crimsyth_shadow", unitCode = "C3", income = "220", deathBounty = "220", goldCost = "2200", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(4), {hero_icon = "npc_dota_hero_sven", unitName = "redfall_castle_warflayer", unitCode = "C4", income = "260", deathBounty = "260", goldCost = "2600", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(5), {hero_icon = "npc_dota_hero_invoker", unitName = "redfall_crimsyth_mage", unitCode = "C5", income = "340", deathBounty = "340", goldCost = "3400", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(6), {hero_icon = "npc_dota_hero_monkey_king", unitName = "crimsyth_fortune_seeker", unitCode = "C6", income = "380", deathBounty = "380", goldCost = "3800", builder="redfall"} )
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(7), {hero_icon = "npc_dota_hero_troll_warlord", unitName = "redfall_crimsyth_berserker", unitCode = "C7", income = "400", deathBounty = "400", goldCost = "4000", builder="redfall"} )	
	CustomNetTables:SetTableValue("premium_pass", "redfall_".."C"..tostring(8), {hero_icon = "npc_dota_hero_earthshaker", unitName = "redfall_lava_behemoth", unitCode = "C8", income = "2400", deathBounty = "2400", goldCost = "24000", builder="redfall"} )	
end

function PVP:LinewarIncomeFunction()
	PVP.IncomeTimer = PVP_INCOME_TIME
	-- CustomGameEventManager:Send_ServerToAllClients("createLineWarIncomeTimer", {incomeTimer = PVP.IncomeTimer} )
	Timers:CreateTimer(0, function()
		CustomGameEventManager:Send_ServerToAllClients("updateLineWarIncomeTimer", {incomeTimer = PVP.IncomeTimer} )
		PVP.IncomeTimer = PVP.IncomeTimer - 1
		if PVP.IncomeTimer < 0 then
			PVP:LineWarCollectIncome()
		end
		return 1
	end)
end

function PVP:RollRandomGlyph(position)
	local rowItem = 1
	local heroTable = {}
	local highestLevel = 0
	for i = 1, #MAIN_HERO_TABLE, 1 do
		table.insert(heroTable, HerosCustom:GetInternalHeroNameMain(MAIN_HERO_TABLE[i]:GetUnitName()))
		if MAIN_HERO_TABLE[i]:GetLevel() > highestLevel then
			highestLevel = MAIN_HERO_TABLE[i]:GetLevel()
		end
	end
	table.insert(heroTable, "neutral")
	local heroName = heroTable[RandomInt(1,#heroTable)]
	local maxTier = math.max(math.floor(highestLevel/15), 1)
	local tier = RandomInt(1, maxTier)
	if heroName == "neutral" then
		rowItem = RandomInt(1,3)
	end
	local glyphName = "item_rpc_"..heroName.."_glyph_"..tier.."_"..rowItem
	print(glyphName)
	Glyphs:RollGlyphAll(glyphName, position, 0)
end

function PVP:Reconnect(player)
	-- if PVP.GameMode == PVP.GAME_MODE_LINE_WAR then
	-- 	CustomGameEventManager:Send_ServerToPlayer(player, "createLineWarIncomeTimer", {incomeTimer = PVP.IncomeTimer} )
	-- end
end

function PVP:LineWarCollectIncome()
	PVP.IncomeTimer = PVP_INCOME_TIME
	EmitGlobalSound("PVP.Linewar.CollectIncome")
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
		local currentGold = PlayerResource:GetGold(playerID)
		local income = MAIN_HERO_TABLE[i].linewarIncome
		PlayerResource:ModifyGold(playerID, income, true, 0)
		PlayerResource:SetGold(playerID, 0, false)
		Notifications:Top(playerID, {text="Income Collected: "..income, duration=5, style={color="white"}, continue=true})
	end

end

function PVP:SpawnFlameWraith(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit("fire_temple_flame_wraith", position, 0, 0, "Tanari.FireTemple.FlameWraithAggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 107
	ancient:SetRenderColor(255, 0, 0)
	return ancient
end

function PVP:SpawnMoltenWarKnight(position, fv, teamNumber)
	local beast = PVP:SpawnDungeonUnit("fire_temple_molten_war_knight", position, 0, 0, "Tanari.FireTemple.KnightAggro", fv, true, teamNumber)
	Events:AdjustBossPower(beast, 5, 5)
	beast:SetRenderColor(255, 170, 170)
	beast.itemLevel = 95
	beast.targetRadius = 900
	beast.minRadius = 100
	beast.targetAbilityCD = 1
	beast.targetFindOrder = FIND_FARTHEST
	return beast
end

function PVP:SpawnSecretFanatic(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit("fire_temple_secret_fanatic", position, 0, 0, "Tanari.FireTemple.SecretFanaticAggro", fv, true, teamNumber)
	stone:SetRenderColor(255,100,90)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 91
	return stone
end

function PVP:SpawnTemperedWarrior(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit("fire_temple_tempered_warrior", position, 0, 0, "Tanari.FireTemple.TemperedWarriorAggro", fv, true, teamNumber)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone:SetRenderColor(255, 255, 60)
	stone.itemLevel = 99
	stone.targetRadius = 300
	stone.autoAbilityCD = 3
	return stone
end

function PVP:LineWarSummonMountainBully(position, fv, teamNumber)
	local bully = PVP:SpawnDungeonUnit("tanari_mountain_bully", position, 0, 0, nil, fv, true, teamNumber)
	bully.itemLevel = 7
	return bully
end

function PVP:SpawnAmbusher(position, fv, teamNumber)
	local ambusher = PVP:SpawnDungeonUnit( "tanari_tribal_ambusher", position, 0, 0, "Tanari.TrabalAmbusher.Aggro", fv, true, teamNumber)
	ambusher.itemLevel = 15
	return ambusher
end

function PVP:SpawnThicketUrsa(position, fv, teamNumber)
	local sapling = PVP:SpawnDungeonUnit("tanari_thicket_ursa", position, 0, 0, "Tanari.ThicketUrsa.Aggro", fv, true, teamNumber)
	sapling.itemLevel = 26
	Events:AdjustBossPower(sapling, 1, 1)
	return sapling
end

function PVP:SpawnHeadhunter(position, fv, teamNumber)
	local hunter = PVP:SpawnDungeonUnit("tanari_headhunter", position, 0, 0, "huskar_husk_anger_0"..RandomInt(1,6), fv, true, teamNumber)
	Events:AdjustBossPower(hunter, 2, 2, false)
	hunter.itemLevel = 26
	hunter:RemoveAbility("monster_patrol")
	hunter:RemoveModifierByName("modifier_patrol_ai")
	return hunter
end

function PVP:SpawnThicketPriest(position, fv, teamNumber)
	local hunter = PVP:SpawnDungeonUnit("tanari_thicket_priest", position, 0, 0, "meepo_meepo_anger_0"..RandomInt(1,3), fv, true, teamNumber)
	Events:AdjustBossPower(hunter, 2, 2, false)
	hunter.itemLevel = 26
	hunter:RemoveAbility("monster_patrol")
	hunter:RemoveModifierByName("modifier_patrol_ai")
	return hunter
end

function PVP:SpawnThicketTank(position, fv, teamNumber)
	local hunter = PVP:SpawnDungeonUnit("tanari_thicket_pain_absorber", position, 0, 0, "elder_titan_elder_anger_04", fv, true, teamNumber)
	Events:AdjustBossPower(hunter, 2, 2, false)
	hunter.itemLevel = 26
	hunter:RemoveAbility("monster_patrol")
	hunter:RemoveModifierByName("modifier_patrol_ai")
	return hunter
end

function PVP:SpawnShark(position, fv, teamNumber)
	local shark = PVP:SpawnDungeonUnit("water_temple_shark", position, 0,0, "slark_slark_shadow_dance_0"..RandomInt(1,4), fv, false, teamNumber)
	Events:AdjustBossPower(shark, 2, 2)
	shark.itemLevel = 58
	shark.targetRadius = 600
	shark.autoAbilityCD = 0.5
	shark:SetRenderColor(170, 170, 255)
	shark:RemoveAbility("monster_patrol")
	shark:RemoveModifierByName("modifier_patrol_ai")
	return shark
end

function PVP:SpawnWindGuardian(position, fv, teamNumber)
	local hunter = PVP:SpawnDungeonUnit("wind_temple_avian_warder", position+RandomVector(300), 0, 0, nil, fv, true, teamNumber)
	hunter.itemLevel = 32
	hunter:SetAbsOrigin(hunter:GetAbsOrigin()+Vector(0,0,470))
	hunterAbility = hunter:FindAbilityByName("wind_temple_wind_guardian_ai")
	hunterAbility:ApplyDataDrivenModifier(hunter, hunter, "modifier_wind_guardian_entrance", {duration = 2.7})
	for i = 1, 90, 1 do
		Timers:CreateTimer(0.03*i, function()
			hunter:SetAbsOrigin(hunter:GetAbsOrigin()-Vector(0,0,math.abs(math.sin(i)*10)))
		end)
	end
	return hunter
end

function PVP:SpawnCaveMonster(position, fv, teamNumber)
	local sapling = PVP:SpawnDungeonUnit("boulderspine_cavern_monster", position, 0, 0, "Tanari.Boulderspine.MonsterAggro", fv, true, teamNumber)
	sapling.itemLevel = 45
	Events:AdjustBossPower(sapling, 1, 1)
	return sapling
end

function PVP:SpawnDescendantOfZeus(position, fv, teamNumber)
	local maiden = PVP:SpawnDungeonUnit("wind_temple_descendant_of_zeus", position, 0, 0, "Tanari.WindTemple.WindDescendantAggro", fv, true, teamNumber)
	maiden.itemLevel = 50
	Events:AdjustBossPower(maiden, 3, 3, false)
	return maiden
end

function PVP:SpawnCaveLizard(position, fv, teamNumber)
	local sapling = PVP:SpawnDungeonUnit("boulderspine_cave_lizard", position, 0, 0, "Tanari.Boulderspine.CaveLizardAggro", fv, true, teamNumber)
	sapling.itemLevel = 49
	Events:AdjustBossPower(sapling, 1, 2)
	sapling:SetRenderColor(30, 30, 30)
	sapling.targetRadius = 3000
	sapling.minRadius = 1000
	sapling.targetAbilityCD = 3.5
	sapling.targetFindOrder = FIND_FARTHEST
	return sapling
end

function PVP:SpawnSlithereenGuard(position, fv, teamNumber)
	local guard = PVP:SpawnDungeonUnit("boulderspine_slithereen_guard", position, 0, 0, nil, fv, true, teamNumber)
	guard.itemLevel = 54
	Events:AdjustBossPower(guard, 2, 2)
	return guard
end

function PVP:SpawnSlithereenFeatherguard(position, fv, teamNumber)
	local guard = PVP:SpawnDungeonUnit("boulderspine_slithereen_featherguard", position, 0, 0, nil, fv, true, teamNumber)
	guard.itemLevel = 55
	Events:AdjustBossPower(guard, 2, 2)
	return guard
end

function PVP:SpawnSlithereenRoyalGuard(position, fv, teamNumber)
	local guard = PVP:SpawnDungeonUnit("boulderspine_slithereen_royal_guard", position, 0, 0, "slardar_slar_anger_06", fv, true, teamNumber)
	guard.itemLevel = 58
	Events:AdjustBossPower(guard, 4, 4)
	return guard
end

function PVP:SpawnFacelessElemental(position, fv, teamNumber)
	local shark = PVP:SpawnDungeonUnit("water_temple_faceless_water_elemental", position, 0,0, "morphling_mrph_anger_0"..RandomInt(1,7), fv, true, teamNumber)
	Events:AdjustBossPower(shark, 1, 1)
	shark:SetRenderColor(200, 200, 255)
	shark.itemLevel = 62
	shark.targetRadius = 1000
	shark.minRadius = 0
	shark.targetAbilityCD = 1.5
	shark.targetFindOrder = FIND_FARTHEST
	return shark
end

function PVP:SpawnFairyDragon(position, fv, teamNumber)
	local fairy = PVP:SpawnDungeonUnit( "water_temple_fairy_dragon", position, 0, 0, nil, fv, true, teamNumber)
	fairy.itemLevel = 69
	fairy:SetRenderColor(175, 175, 255)
	Events:AdjustBossPower(fairy, 1, 1)
	fairy:FindAbilityByName("puck_phase_shift"):SetLevel(GameState:GetDifficultyFactor()+1)
	return fairy
end

function PVP:SpawnRedMistSoldier(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit("terrasic_red_mist_soldier", position, 0, 0, "Tanari.WaterTemple.ExecutionerAggro", fv, true, teamNumber)
	stone:SetRenderColor(255,200,200)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 62
	stone.targetRadius = 340
	stone.autoAbilityCD = 2
	return stone
end

function PVP:SpawnGoremawFlamespitter(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit("terrasic_goremaw_flame_splitter", position, 0, 0, "Tanari.TerrasicCrater.FlameSpitterAggro", fv, true, teamNumber)
	stone:SetRenderColor(255,160,80)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 63
	stone.targetRadius = 400
	stone.autoAbilityCD = 1.5
	return stone
end

function PVP:SpawnBlackguard(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit("fire_temple_blackguard", position, 0, 0, "Tanari.FireTemple.BlackguardAggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 85
	ancient:SetRenderColor(80, 80, 80)
	ancient:RemoveAbility("monster_patrol")
	ancient:RemoveModifierByName("modifier_patrol_ai")
	return ancient
end

function PVP:SpawnBlackguardDoombringer(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit("fire_temple_blackguard_doombringer", position, 0, 0, "Tanari.FireTemple.BlackguardDoombringerAggro", fv, true, teamNumber)
	stone:SetRenderColor(255,200,200)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 87
	return stone
end

function PVP:SpawnWindProphet(position, fv, teamNumber)
	local mage = PVP:SpawnDungeonUnit("wind_temple_rare_wind_prophet", position, 3, 4, "Tanari.WindProphet.Aggro", fv, true, teamNumber)
	mage.itemLevel = 46
	Events:AdjustBossPower(mage, 3, 3, false)
	return mage
end

--REDFALL UNITS
function PVP:SetPositionCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
	unit.targetRadius = radius
	unit.minRadius = minRadius
	unit.targetAbilityCD = cooldown
	unit.targetFindOrder = targetFindOrder
end

function PVP:SpawnAutumnSpirit(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_autumn_spirit", position, 1, 3, "Redfall.AutumnSpirit.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 25
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, ancient, "modifier_experimental_fire_effect", {})
	ancient:SetRenderColor(255, 158, 158)
	return ancient
end

function PVP:SpawnForestGnome(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_forest_gnome", position, 1, 3, "Redfall.ForstGnome.Aggro", fv, true, teamNumber)
	PVP:SetPositionCastArgs(ancient, 800, 0, 1, FIND_ANY_ORDER)
	ancient.itemLevel = 24
	ancient:SetRenderColor(255, 115, 60)
	Events:ColorWearables(ancient, Vector(255, 115, 60))
	return ancient
end

function PVP:SpawnStoneWatcher(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_stone_watcher", position, 1, 3, "Redfall.StoneWatcher.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 1, 1, false)
	ancient.itemLevel = 24

	ancient.targetRadius = 900
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	ancient.targetFindOrder = FIND_CLOSEST


	ancient:SetRenderColor(255, 118, 118)
	Events:ColorWearables(ancient, Vector(255, 110, 110))

	return ancient
end

function PVP:SpawnForestRanger(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_forest_ranger", position, 1, 3, "Redfall.ForestRanger.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 1, 1, false)
	ancient.itemLevel = 24
	ancient.dominion = true
	return ancient
end

function PVP:SpawnAutumnCragnataur(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_autumn_cragnataur", position, 2, 5, "Redfall.Cragnataur.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 1, 1, false)
	ancient.itemLevel = 25

	ancient:SetRenderColor(255, 127, 0)
	Events:ColorWearables(ancient, Vector(255, 110, 0))
	ancient.targetRadius = 1000
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	ancient.targetFindOrder = FIND_ANY_ORDER

	ancient.dominion = true
	return ancient
end

function PVP:SpawnCanyonBull(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_canyon_bull", position, 1, 3, "Redfall.BullGhost.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 34

	ancient:SetRenderColor(255, 140, 0)
	Events:ColorWearables(ancient, Vector(255, 140, 0))
	ancient.dominion = true
	return ancient
end

function PVP:SpawnSoulReacher(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_hooded_soul_reacher", position, 0, 3, "Redfall.SoulReacher.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 1, 1, false)
	ancient.itemLevel = 24

	ancient:SetRenderColor(255, 118, 118)
	Events:ColorWearables(ancient, Vector(255, 110, 110))
	ancient.dominion = true
	return ancient
end

function PVP:SpawnAutumnMage(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit(  "redfall_autumn_mage", position, 1, 3, "Redfall.AutumnMage.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 5, 5, false)
	ancient.itemLevel = 39
	ancient.dominion = true
	ancient:SetRenderColor(255, 180, 80)
	Events:ColorWearables(ancient, Vector(255, 180, 80))

	return ancient
end

function PVP:SpawnFarmlandsBandit(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_farmlands_bandit", position, 1, 4, "Redfall.FarmlandsBandit.Aggro", fv, true, teamNumber)
	ancient.itemLevel = 50
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.dominion = true
	return ancient
end

function PVP:SpawnHarvestWraith(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit( "redfall_harvest_wraith", position, 1, 3, "Redfall.HarvestWraith.Aggro", fv, true, teamNumber)
	stone:SetRenderColor(255,140,140)
	Events:ColorWearables(stone, Vector(255,140,140))
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 62
	stone.dominion = true
	return stone
end

function PVP:SpawnRedfallHarvester(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit( "redfall_farmlands_corn_harvester", position, 1, 3, "Redfall.Harvester.Aggro", fv, true, teamNumber)
	stone:SetRenderColor(255,140,140)
	Events:ColorWearables(stone, Vector(255,140,140))
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 63
	stone.dominion = true
	return stone
end

function PVP:SpawnCrimsythDuelist(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_crymsith_duelist", position, 2, 5, "Redfall.Duelist.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 4, 4, false)
	ancient.itemLevel = 68

	ancient.targetRadius = 1000
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	ancient.targetFindOrder = FIND_ANY_ORDER

	ancient.dominion = true
	return ancient
end

function PVP:SpawnCrimsythRecruiter(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit( "redfall_crimsyth_recruiter", position, 1, 4, "Redfall.CrymsithRecruiter.Aggro", fv, true, teamNumber)
	stone:SetRenderColor(234,131,131)
	Events:ColorWearables(stone, Vector(255, 130, 130))
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 68
	stone.dominion = true
	return stone
end

function PVP:SpawnSkeletonArcher(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit(  "shipyard_skeleton_archer", position, 1, 2, "Redfall.SkeletonArcher.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone:SetRenderColor(120, 70, 70)
	stone.itemLevel = 68
	stone.dominion = true
	return stone
end

function PVP:SpawnFarmlandTaskmaster(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit( "redfall_farmlands_crymsith_taskmaster", position, 1, 4, "Redfall.AutumnTaskmaster.Aggro", fv, true, teamNumber)
	stone:SetRenderColor(234,131,131)
	Events:ColorWearables(stone, Vector(255, 130, 130))
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 65
	stone.dominion = true
	return stone
end

function PVP:SpawnCrimsythKnight(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit("redfall_shipyard_crimsyth_knight", position, 2, 3, "Redfall.CrimsythKnight.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(stone, 4, 4, false)

	stone.targetRadius = 500
	stone.minRadius = 0
	stone.targetAbilityCD = RandomInt(2, 4)
	stone.targetFindOrder = FIND_CLOSEST
	stone:AddAbility("use_ability_1_target_ai"):SetLevel(1)

	stone.dominion = true
	return stone
end

function PVP:SpawnCrimsythBombadier(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit("crimsyth_bombadier", position, 1, 3, "Redfall.Bombadier.Aggro", fv, true, teamNumber)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 80, 80)
  Events:ColorWearables(stone, Vector(255, 60, 60))
  Events:SetPositionCastArgs(stone, 1200, 0, 1, FIND_ANY_ORDER)
  Events:AdjustBossPower(stone, 1, 1, false)
  stone.dominion = true
  return stone
end

function PVP:SpawnSnarlRootTreant(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit("redfall_snarlroot_treant", position, 1, 3, "Redfall.SnarlRoot.Aggro", fv, true, teamNumber)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 120, 120)
  Events:ColorWearables(stone, Vector(255, 120, 120))
  Events:AdjustBossPower(stone, 4, 4, false)
  stone.dominion = true
  return stone
end

function PVP:SpawnHawkSoldierElite(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit("redfall_crimsyth_hawk_soldier_elite", position, 1, 3, "Redfall.HawkSoldierElite.Aggro", fv, true, teamNumber)
  stone.itemLevel = 110
  stone:SetRenderColor(140, 140, 140)
  Events:ColorWearables(stone, Vector(140, 140, 140))
  stone.targetRadius = 600
  stone.minRadius = 0
  stone.targetAbilityCD = 1
  stone.targetFindOrder = FIND_CLOSEST
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.dominion = true
  return stone
end

function PVP:SpawnCrimsythShadow(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit("redfall_crimsyth_shadow", position, 1, 3, "Redfall.CrimsythShadow.Aggro", fv, true, teamNumber)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 80, 80)
  Events:ColorWearables(stone, Vector(255, 140, 140))
  stone.targetRadius = 800
  stone.autoAbilityCD = 1
  Events:AdjustBossPower(stone, 1, 1, false)
  stone.dominion = true
  return stone
end

function PVP:SpawnCastleWarflayer(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit("redfall_castle_warflayer", position, 1, 3, "Redfall.Warflayer.Aggro", fv, true, teamNumber)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 130, 130)
  Events:ColorWearables(stone, Vector(255, 130, 130))
  Events:AdjustBossPower(stone, 3, 3, false)
  stone.dominion = true
  return stone
end

function PVP:SpawnCrimsythMage(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit("redfall_crimsyth_mage", position, 1, 2, "Redfall.CrimsythMage.Aggro", fv, true, teamNumber)
  stone.itemLevel = 96
  stone:SetRenderColor(255, 120, 120)
  Events:AdjustBossPower(stone, 3, 3, false)
  Events:ColorWearables(stone, Vector(255, 120, 120))
  stone.dominion = true
  return stone
end

function PVP:SpawnFortuneSeeker(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit( "crimsyth_fortune_seeker", position, 1, 3, "Redfall.FortuneSeeker.Aggro", fv, true, teamNumber)
  stone.itemLevel = 130
  stone:SetRenderColor(188, 120, 120)
  Events:ColorWearables(stone, Vector(180, 90, 90))
  Events:AdjustBossPower(stone, 8, 8, false)
  -- stone:AddNewModifier(stone, nil, "modifier_animation", {translate="run"})
  stone:AddNewModifier(stone, nil, "modifier_animation", {translate="attack_normal_range"})
  stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="run"})
  Events:SetPositionCastArgs(stone, 1000, 0, 1, FIND_ANY_ORDER)
  stone.dominion = true
  return stone
end

function PVP:SpawnCrymsithBerserker(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit("redfall_crimsyth_berserker", position, 1, 2, "Redfall.CrimsythBerserker.Aggro", fv, true, teamNumber)
  stone.itemLevel = 130
  stone:SetRenderColor(255, 190, 190)
  Events:ColorWearables(stone, Vector(255, 200, 200))
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.dominion = true
  return stone
end

function PVP:SpawnRareWaterConstruct(position, fv, teamNumber)
	local lord = PVP:SpawnDungeonUnit("water_temple_rare_water_construct", position, 5,7, "Tanari.RareWaterConstruct.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(lord, 8, 8)
	lord.itemLevel = 120
	lord:SetRenderColor(60, 60, 255)
	return lord	
end

function PVP:SpawnRareLavaForgeMaster(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit("fire_temple_rare_lava_forgemaster", position, 3, 5, "Tanari.FireTemple.LavaforgeAggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 9, 9, false)
	ancient.itemLevel = 135
	ancient:SetRenderColor(255, 50, 50)
	ancient.targetRadius = 900
	ancient.autoAbilityCD = 2
	return ancient
	
end

function PVP:SpawnAshara(position, fv, teamNumber)
	local ancient = PVP:SpawnDungeonUnit( "redfall_ashara", position, 3, 5, "Redfall.Ashara.Aggro", fv, true, teamNumber)
	Events:AdjustBossPower(ancient, 7, 7, false)
	ancient.itemLevel = 42
	ancient.jumpEnd = "basic_dust"
	ancient:SetAbsOrigin(ancient:GetAbsOrigin()+Vector(0,0,2000))
	WallPhysics:Jump(ancient, Vector(1,1), 0, 0, 0, 1)
	Timers:CreateTimer(1, function()
		EmitSoundOn("Redfall.Ashara.Taunt", ancient)
	end)
	ancient:AddAbility("fire_temple_steadfast"):SetLevel(1)
	Timers:CreateTimer(2, function()
		StartAnimation(ancient, {duration=2.5, activity=ACT_DOTA_SPAWN, rate=0.8, translate="manias_mask"}) 
	end)
	return ancient
end

function PVP:SpawnRubyGiant(position, fv, teamNumber)
	local stone = PVP:SpawnDungeonUnit( "ancient_ruby_giant", position, 2, 5, "Redfall.RubyGiant.Aggro", fv, true, teamNumber)
	stone:SetRenderColor(234,160,160)
	Events:ColorWearables(stone, Vector(234, 160, 160))
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 68
	return stone
end

function PVP:SpawnLavaBehemoth(position, fv, teamNumber)
  local stone = PVP:SpawnDungeonUnit("redfall_lava_behemoth", position, 2, 5, "Redfall.LavaBehemoth.Aggro", fv, true, teamNumber)
  stone.itemLevel = 136
  stone:SetRenderColor(255, 190, 190)
  Events:ColorWearables(stone, Vector(255, 200, 200))
  Events:AdjustBossPower(stone, 7, 7, false)
  Events:SetPositionCastArgs(stone, 1400, 0, 1, FIND_ANY_ORDER)
  return stone
end
--REDFALL END

function PVP:BuildUnit(msg)
	local builderItemData = msg.builderItemData
	local playerID = msg.playerID
	local cost = tonumber(builderItemData.goldCost)
	local currentGold = PlayerResource:GetGold(playerID)
	local foodInfo = CustomNetTables:GetTableValue("premium_pass", "line_war_food_cap_"..playerID)
	if tonumber(foodInfo.currentFood) == tonumber(foodInfo.maxFood) then
	 return false
	end
	if currentGold >= cost then
		PlayerResource:ModifyGold(playerID, -cost, true, 0)
		PlayerResource:SetGold(playerID, 0, false)
		local builder = PVP:GetBuilderUnit("tanari", PlayerResource:GetTeam(playerID))
		StartAnimation(builder, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
		local unit = PVP:pvp_summon_unit(builder, builderItemData.unitCode, tonumber(builderItemData.deathBounty), playerID, msg.regionCode)
		local hero = GameState:GetHeroByPlayerID(playerID)
		PVP:IncrementIncome(hero, tonumber(builderItemData.income))
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "UpdateMenuValues", {})

		unit.builderID = playerID
		local newFood = tonumber(foodInfo.currentFood) + 1
		CustomNetTables:SetTableValue("premium_pass", "line_war_food_cap_"..playerID, {currentFood = tostring(newFood), maxFood = foodInfo.maxFood})
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "updateLineWarFoodCap", {})
	else
	end
	local unitCode = builderItemData.unitCode
end

function PVP:pvp_summon_unit(caster, unitCode, bounty, playerID, regionCode)
	local casterOrigin = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	local unit = nil
	print("REGION CODE")
	print(regionCode)
	if regionCode == "tanari" then
		if unitCode == "A0" then
			unit = PVP:LineWarSummonMountainBully(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A1" then
			unit = PVP:SpawnAmbusher(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A2" then
			unit = PVP:SpawnThicketUrsa(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A3" then
			unit = PVP:SpawnThicketPriest(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A4" then
			unit = PVP:SpawnThicketTank(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A5" then
			unit = PVP:SpawnHeadhunter(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A6" then
			unit = PVP:SpawnWindGuardian(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A7" then
			unit = PVP:SpawnDescendantOfZeus(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A8" then
			unit = PVP:SpawnWindProphet(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B0" then
			unit = PVP:SpawnCaveMonster(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B1" then
			unit = PVP:SpawnCaveLizard(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B2" then
			unit = PVP:SpawnSlithereenGuard(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B3" then
			unit = PVP:SpawnSlithereenFeatherguard(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B4" then
			unit = PVP:SpawnShark(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B5" then
			unit = PVP:SpawnSlithereenRoyalGuard(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B6" then
			unit = PVP:SpawnFacelessElemental(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B7" then
			unit = PVP:SpawnFairyDragon(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B8" then
			unit = PVP:SpawnRareWaterConstruct(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C0" then
			unit = PVP:SpawnRedMistSoldier(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C1" then
			unit = PVP:SpawnGoremawFlamespitter(casterOrigin, fv, caster:GetTeamNumber())	
		elseif unitCode == "C2" then
			unit = PVP:SpawnBlackguard(casterOrigin, fv, caster:GetTeamNumber())	
		elseif unitCode == "C3" then
			unit = PVP:SpawnBlackguardDoombringer(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C4" then
			unit = PVP:SpawnSecretFanatic(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C5" then
			unit = PVP:SpawnMoltenWarKnight(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C6" then
			unit = PVP:SpawnTemperedWarrior(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C7" then
			unit = PVP:SpawnFlameWraith(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C8" then
			unit = PVP:SpawnRareLavaForgeMaster(casterOrigin, fv, caster:GetTeamNumber())
		end
	elseif regionCode == "redfall" then
		if unitCode == "A0" then
			unit = PVP:SpawnAutumnSpirit(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A1" then
			unit = PVP:SpawnForestGnome(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A2" then
			unit = PVP:SpawnStoneWatcher(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A3" then
			unit = PVP:SpawnForestRanger(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A4" then
			unit = PVP:SpawnAutumnCragnataur(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A5" then
			unit = PVP:SpawnCanyonBull(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A6" then
			unit = PVP:SpawnSoulReacher(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A7" then
			unit = PVP:SpawnAutumnMage(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "A8" then
			unit = PVP:SpawnAshara(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B0" then
			unit = PVP:SpawnFarmlandsBandit(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B1" then
			unit = PVP:SpawnHarvestWraith(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B2" then
			unit = PVP:SpawnRedfallHarvester(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B3" then
			unit = PVP:SpawnCrimsythDuelist(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B4" then
			unit = PVP:SpawnCrimsythRecruiter(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B5" then
			unit = PVP:SpawnSkeletonArcher(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B6" then
			unit = PVP:SpawnFarmlandTaskmaster(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B7" then
			unit = PVP:SpawnCrimsythKnight(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "B8" then
			unit = PVP:SpawnRubyGiant(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C0" then
			unit = PVP:SpawnCrimsythBombadier(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C1" then
			unit = PVP:SpawnSnarlRootTreant(casterOrigin, fv, caster:GetTeamNumber())	
		elseif unitCode == "C2" then
			unit = PVP:SpawnHawkSoldierElite(casterOrigin, fv, caster:GetTeamNumber())	
		elseif unitCode == "C3" then
			unit = PVP:SpawnCrimsythShadow(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C4" then
			unit = PVP:SpawnCastleWarflayer(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C5" then
			unit = PVP:SpawnCrimsythMage(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C6" then
			unit = PVP:SpawnFortuneSeeker(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C7" then
			unit = PVP:SpawnCrymsithBerserker(casterOrigin, fv, caster:GetTeamNumber())
		elseif unitCode == "C8" then
			unit = PVP:SpawnLavaBehemoth(casterOrigin, fv, caster:GetTeamNumber())
		end
	end
	if GameState:IsPVPLineWarWork() then
		if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			unit.targetPoint = Vector(192, 64)
		else
			unit.targetPoint = Vector(2560, 3008)
		end
	else
		if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			unit.targetPoint = Vector(-256, -192)
		else
			unit.targetPoint = Vector(2374, 2442)
		end
	end
	unit:SetAcquisitionRange(1000)
	unit.aiState = 0
	unit:AddAbility("pvp_line_unit_ability"):SetLevel(1)
	unit:SetMinimumGoldBounty(bounty)
	unit:SetMaximumGoldBounty(bounty)
	if unitCode == "A8" or unitCode == "B8" or unitCode == "C8" then
	else
		unit.dominion = true
	end
	if GameState:NoOracle() then
		unit.minDungeonDrops = 1
		unit.maxDungeonDrops = 2
		unit:SetDeathXP(unit:GetDeathXP()*4)
	else
		unit:SetDeathXP(0)
	end
	return unit

end

function PVP:IncrementIncome(hero, increase)
	hero.linewarIncome = hero.linewarIncome + increase
	CustomNetTables:SetTableValue("premium_pass", "line_war_income_"..hero:GetEntityIndex(), {income = hero.linewarIncome} )
end

function PVP:GetBuilderUnit(builderType, teamNumber)
	if builderType == "tanari" then
		if teamNumber == DOTA_TEAM_GOODGUYS then
			return PVP.TanariBuilder
		else
			return PVP.TanariBuilderBad
		end
	end
end

function PVP:SpawnDungeonUnit(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro, teamNumber)

    local luck = 5
    -- if not Events.SpiritRealm then
    --   luck = RandomInt(1, 180)
    -- else
    --   luck = RandomInt(1, 60)
    -- end
    local unit = ""
    if luck == 1 then
     unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
    else
     unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, teamNumber)
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
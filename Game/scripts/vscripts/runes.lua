if Runes == nil then
  Runes = class({})
end

function Runes:RedirectRunes(hero, runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID)
	local heroName = hero:GetName()
	if heroName == "npc_dota_hero_dragon_knight" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "flamewaker")
	elseif heroName == "npc_dota_hero_phantom_assassin" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "voltex")
	elseif heroName == "npc_dota_hero_necrolyte" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "venomort")
	elseif heroName == "npc_dota_hero_axe" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "axe")
	elseif heroName == "npc_dota_hero_drow_ranger" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "astral")
	elseif heroName == "npc_dota_hero_obsidian_destroyer" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "epoch")
	elseif heroName == "npc_dota_hero_omniknight" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "paladin")
	elseif heroName == "npc_dota_hero_crystal_maiden" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "sorceress")
	elseif heroName == "npc_dota_hero_invoker" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "conjuror")
	elseif heroName == "npc_dota_hero_juggernaut" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "monk")
	elseif heroName == "npc_dota_hero_beastmaster" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "warlord")
	elseif heroName == "npc_dota_hero_leshrac" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "bahamut")
	elseif heroName == "npc_dota_hero_spirit_breaker" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "duskbringer")
	elseif heroName == "npc_dota_hero_zuus" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "auriun")
	elseif heroName == "npc_dota_hero_templar_assassin" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "trapper")
	elseif heroName == "npc_dota_hero_huskar" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "spirit_warrior")
	elseif heroName == "npc_dota_hero_legion_commander" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "mountain_protector")
	elseif heroName == "npc_dota_hero_night_stalker" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "chernobog")
	elseif heroName == "npc_dota_hero_vengefulspirit" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "solunia")
	elseif heroName == "npc_dota_hero_slardar" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "hydroxis")
	elseif heroName == "npc_dota_hero_visage" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "ekkan")
	elseif heroName == "npc_dota_hero_dark_seer" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "zonik")
	elseif heroName == "npc_dota_hero_antimage" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "arkimus")
	elseif heroName == "npc_dota_hero_monkey_king" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "djanghor")
	elseif heroName == "npc_dota_hero_slark" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "slipfinn")
	elseif heroName == "npc_dota_hero_skywrath_mage" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "sephyr")
	elseif heroName == "npc_dota_hero_winter_wyvern" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "dinath")
	end
	
    runeUnit:AddAbility("town_unit"):SetLevel(1)
    runeUnit2:AddAbility("town_unit"):SetLevel(1) 
    runeUnit3:AddAbility("town_unit"):SetLevel(1)
    runeUnit4:AddAbility("town_unit"):SetLevel(1)
    runeUnit.hero = hero
    runeUnit2.hero = hero
    runeUnit3.hero = hero
    runeUnit4.hero = hero
    runeUnit.owner = playerID
    runeUnit2.owner = playerID
    runeUnit3.owner = playerID
    runeUnit4.owner = playerID
    setRunesBonuses(runeUnit, runeUnit2, runeUnit3, runeUnit4)
    Runes:ResetRuneBonuses(hero, "amulet")
    Runes:ResetRuneBonuses(hero, "hand")
    Runes:ResetRuneBonuses(hero, "body")
end

function setRunesBonuses(runeUnit, runeUnit2, runeUnit3, runeUnit4)
    runeUnit.amulet = {}
    runeUnit.amulet.a_a = 0
    runeUnit.amulet.a_b = 0
    runeUnit.amulet.a_c = 0
    runeUnit.amulet.a_d = 0
    runeUnit2.amulet = {}
    runeUnit2.amulet.b_a = 0
    runeUnit2.amulet.b_b = 0
    runeUnit2.amulet.b_c = 0
    runeUnit2.amulet.b_d = 0
    runeUnit3.amulet = {}
    runeUnit3.amulet.c_a = 0
    runeUnit3.amulet.c_b = 0
    runeUnit3.amulet.c_c = 0
    runeUnit3.amulet.c_d = 0
    runeUnit4.amulet = {}
    runeUnit4.amulet.d_a = 0
    runeUnit4.amulet.d_b = 0
    runeUnit4.amulet.d_c = 0
    runeUnit4.amulet.d_d = 0

    runeUnit.hand = {}
    runeUnit.hand.a_a = 0
    runeUnit.hand.a_b = 0
    runeUnit.hand.a_c = 0
    runeUnit.hand.a_d = 0
    runeUnit2.hand = {}
    runeUnit2.hand.b_a = 0
    runeUnit2.hand.b_b = 0
    runeUnit2.hand.b_c = 0
    runeUnit2.hand.b_d = 0
    runeUnit3.hand = {}
    runeUnit3.hand.c_a = 0
    runeUnit3.hand.c_b = 0
    runeUnit3.hand.c_c = 0
    runeUnit3.hand.c_d = 0
    runeUnit4.hand = {}
    runeUnit4.hand.d_a = 0
    runeUnit4.hand.d_b = 0
    runeUnit4.hand.d_c = 0
    runeUnit4.hand.d_d = 0


    runeUnit.body = {}
    runeUnit.body.a_a = 0
    runeUnit.body.a_b = 0
    runeUnit.body.a_c = 0
    runeUnit.body.a_d = 0
    runeUnit2.body = {}
    runeUnit2.body.b_a = 0
    runeUnit2.body.b_b = 0
    runeUnit2.body.b_c = 0
    runeUnit2.body.b_d = 0
    runeUnit3.body = {}
    runeUnit3.body.c_a = 0
    runeUnit3.body.c_b = 0
    runeUnit3.body.c_c = 0
    runeUnit3.body.c_d = 0
    runeUnit4.body = {}
    runeUnit4.body.d_a = 0
    runeUnit4.body.d_b = 0
    runeUnit4.body.d_c = 0
    runeUnit4.body.d_d = 0

    runeUnit.head = {}
    runeUnit.head.a_a = 0
    runeUnit.head.a_b = 0
    runeUnit.head.a_c = 0
    runeUnit.head.a_d = 0
    runeUnit2.head = {}
    runeUnit2.head.b_a = 0
    runeUnit2.head.b_b = 0
    runeUnit2.head.b_c = 0
    runeUnit2.head.b_d = 0
    runeUnit3.head = {}
    runeUnit3.head.c_a = 0
    runeUnit3.head.c_b = 0
    runeUnit3.head.c_c = 0
    runeUnit3.head.c_d = 0
    runeUnit4.head = {}
    runeUnit4.head.d_a = 0
    runeUnit4.head.d_b = 0
    runeUnit4.head.d_c = 0
    runeUnit4.head.d_d = 0

    runeUnit.weapon = {}
    runeUnit.weapon.a_a = 0
    runeUnit.weapon.a_b = 0
    runeUnit.weapon.a_c = 0
    runeUnit.weapon.a_d = 0
    runeUnit2.weapon = {}
    runeUnit2.weapon.b_a = 0
    runeUnit2.weapon.b_b = 0
    runeUnit2.weapon.b_c = 0
    runeUnit2.weapon.b_d = 0
    runeUnit3.weapon = {}
    runeUnit3.weapon.c_a = 0
    runeUnit3.weapon.c_b = 0
    runeUnit3.weapon.c_c = 0
    runeUnit3.weapon.c_d = 0
    runeUnit4.weapon = {}
    runeUnit4.weapon.d_a = 0
    runeUnit4.weapon.d_b = 0
    runeUnit4.weapon.d_c = 0
    runeUnit4.weapon.d_d = 0

    runeUnit.foot = {}
    runeUnit.foot.a_a = 0
    runeUnit.foot.a_b = 0
    runeUnit.foot.a_c = 0
    runeUnit.foot.a_d = 0
    runeUnit2.foot = {}
    runeUnit2.foot.b_a = 0
    runeUnit2.foot.b_b = 0
    runeUnit2.foot.b_c = 0
    runeUnit2.foot.b_d = 0
    runeUnit3.foot = {}
    runeUnit3.foot.c_a = 0
    runeUnit3.foot.c_b = 0
    runeUnit3.foot.c_c = 0
    runeUnit3.foot.c_d = 0
    runeUnit4.foot = {}
    runeUnit4.foot.d_a = 0
    runeUnit4.foot.d_b = 0
    runeUnit4.foot.d_c = 0
    runeUnit4.foot.d_d = 0
end

function Runes:RunesOnRespawn(hero)
	if hero:HasModifier("modifier_neutral_glyph_3_1") then
		hero:AddNewModifier( hero, nil, 'modifier_movespeed_cap_glyph', nil )
	end
	local heroName = hero:GetName()
	if heroName == "npc_dota_hero_crystal_maiden" then
		  -- local runeUnit = hero.runeUnit2
		  -- local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_b_a")
		  -- local abilityLevel = runeAbility:GetLevel()
		  -- local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_a")
		  -- local totalLevel = abilityLevel + bonusLevel
		  -- if totalLevel > 0 then
		  -- 	runeAbility:ApplyDataDrivenModifier(runeUnit, hero, "modifier_frost_nova_up", {})
		  -- 	hero:RemoveModifierByName("modifier_frost_nova_down")
		  -- end
		  -- runeUnit = hero.runeUnit3
		  -- runeAbility = runeUnit:FindAbilityByName("sorceress_rune_c_d")
		  -- abilityLevel = runeAbility:GetLevel()
		  -- bonusLevel = Runes:GetTotalBonus(runeUnit, "c_d")
		  -- totalLevel = abilityLevel + bonusLevel
		  -- if totalLevel > 0 then
		  -- 	runeAbility:ApplyDataDrivenModifier(runeUnit, hero, "modifier_ring_of_fire_up", {})
		  -- 	hero:RemoveModifierByName("modifier_ring_of_fire_down")
		  -- end
	end
	if heroName == "npc_dota_hero_omniknight" then
		  -- local runeUnit = hero.runeUnit3
		  -- local runeAbility = runeUnit:FindAbilityByName("paladin_rune_c_a")
		  -- local abilityLevel = runeAbility:GetLevel()
		  -- local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_a")
		  -- local totalLevel = abilityLevel + bonusLevel
		  -- if totalLevel > 0 then
		  -- 	runeAbility:ApplyDataDrivenModifier(runeUnit, hero, "modifier_paladin_rune_c_a", {})
		  -- 	hero:RemoveModifierByName("modifier_paladin_rune_c_a_cooling_down")
		  -- end
	end
	if heroName == "npc_dota_hero_juggernaut" then
		-- if hero:HasAbility("odachi_rush") then
		-- 	hero:SwapAbilities("odachi_slice", "odachi_rush", true, false)	
		-- end
		-- if hero:HasAbility("monk_ultima_blade_heal_alt") then
		-- 	hero:SwapAbilities("monk_ultima_blade", "monk_ultima_blade_heal_alt", true, false)
		-- end
	end
end

function Runes:ResetRuneBonuses(hero, slotName)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_a_a_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_a_b_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_a_c_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_a_d_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_b_a_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_b_b_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_b_c_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_b_d_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_c_a_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_c_b_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_c_c_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_c_d_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_d_a_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_d_b_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_d_c_"..slotName, {bonus = 0} )
    CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_rune_d_d_"..slotName, {bonus = 0} )
end


function Runes:GetTotalBonus(RuneUnit, rune)
	if rune == "a_a" then
		return RuneUnit.amulet.a_a + RuneUnit.hand.a_a + RuneUnit.body.a_a + RuneUnit.head.a_a + RuneUnit.weapon.a_a + RuneUnit.foot.a_a
	elseif rune == "a_b" then
		return RuneUnit.amulet.a_b + RuneUnit.hand.a_b + RuneUnit.body.a_b + RuneUnit.head.a_b + RuneUnit.weapon.a_b + RuneUnit.foot.a_b
	elseif rune == "a_c" then
		return RuneUnit.amulet.a_c + RuneUnit.hand.a_c + RuneUnit.body.a_c + RuneUnit.head.a_c + RuneUnit.weapon.a_c + RuneUnit.foot.a_c
	elseif rune == "a_d" then
		return RuneUnit.amulet.a_d + RuneUnit.hand.a_d + RuneUnit.body.a_d + RuneUnit.head.a_d + RuneUnit.weapon.a_d + RuneUnit.foot.a_d
	elseif rune == "b_a" then
		return RuneUnit.amulet.b_a + RuneUnit.hand.b_a + RuneUnit.body.b_a + RuneUnit.head.b_a + RuneUnit.weapon.b_a + RuneUnit.foot.b_a
	elseif rune == "b_b" then
		return RuneUnit.amulet.b_b + RuneUnit.hand.b_b + RuneUnit.body.b_b + RuneUnit.head.b_b + RuneUnit.weapon.b_b + RuneUnit.foot.b_b
	elseif rune == "b_c" then
		return RuneUnit.amulet.b_c + RuneUnit.hand.b_c + RuneUnit.body.b_c + RuneUnit.head.b_c + RuneUnit.weapon.b_c + RuneUnit.foot.b_c 
	elseif rune == "b_d" then
		return RuneUnit.amulet.b_d + RuneUnit.hand.b_d + RuneUnit.body.b_d + RuneUnit.head.b_d + RuneUnit.weapon.b_d + RuneUnit.foot.b_d
	elseif rune == "c_a" then
		return RuneUnit.amulet.c_a + RuneUnit.hand.c_a + RuneUnit.body.c_a + RuneUnit.head.c_a + RuneUnit.weapon.c_a + RuneUnit.foot.c_a  
	elseif rune == "c_b" then
		return RuneUnit.amulet.c_b + RuneUnit.hand.c_b + RuneUnit.body.c_b + RuneUnit.head.c_b + RuneUnit.weapon.c_b + RuneUnit.foot.c_b   
	elseif rune == "c_c" then
		return RuneUnit.amulet.c_c + RuneUnit.hand.c_c + RuneUnit.body.c_c + RuneUnit.head.c_c + RuneUnit.weapon.c_c + RuneUnit.foot.c_c
	elseif rune == "c_d" then
		return RuneUnit.amulet.c_d + RuneUnit.hand.c_d + RuneUnit.body.c_d + RuneUnit.head.c_d + RuneUnit.weapon.c_d + RuneUnit.foot.c_d
	elseif rune == "d_a" then
		return RuneUnit.amulet.d_a + RuneUnit.hand.d_a + RuneUnit.body.d_a + RuneUnit.head.d_a + RuneUnit.weapon.d_a + RuneUnit.foot.d_a  
	elseif rune == "d_b" then
		return RuneUnit.amulet.d_b + RuneUnit.hand.d_b + RuneUnit.body.d_b + RuneUnit.head.d_b + RuneUnit.weapon.d_b + RuneUnit.foot.d_b   
	elseif rune == "d_c" then
		return RuneUnit.amulet.d_c + RuneUnit.hand.d_c + RuneUnit.body.d_c + RuneUnit.head.d_c + RuneUnit.weapon.d_c + RuneUnit.foot.d_c
	elseif rune == "d_d" then
		return RuneUnit.amulet.d_d + RuneUnit.hand.d_d + RuneUnit.body.d_d + RuneUnit.head.d_d + RuneUnit.weapon.d_d + RuneUnit.foot.d_d
	end
end

function Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, player, heroString)
	runeUnit:AddAbility(heroString.."_rune_a_a")
	runeUnit:AddAbility(heroString.."_rune_a_b")
	runeUnit:AddAbility(heroString.."_rune_a_c")
	runeUnit:AddAbility(heroString.."_rune_a_d")

	runeUnit2:AddAbility(heroString.."_rune_b_a")
	runeUnit2:AddAbility(heroString.."_rune_b_b")
	runeUnit2:AddAbility(heroString.."_rune_b_c")
	runeUnit2:AddAbility(heroString.."_rune_b_d")

	runeUnit3:AddAbility(heroString.."_rune_c_a")
	runeUnit3:AddAbility(heroString.."_rune_c_b")
	runeUnit3:AddAbility(heroString.."_rune_c_c")
	runeUnit3:AddAbility(heroString.."_rune_c_d")

	runeUnit4:AddAbility(heroString.."_rune_d_a")
	runeUnit4:AddAbility(heroString.."_rune_d_b")
	runeUnit4:AddAbility(heroString.."_rune_d_c")
	runeUnit4:AddAbility(heroString.."_rune_d_d")
end

function Runes:Procs(runeLevel, chancePerLevel, mod)
	chancePerLevel = chancePerLevel/mod
	local procs = ((runeLevel*chancePerLevel)-((runeLevel*chancePerLevel)%100))/100
	local lucky = RandomInt(0, 100)
	if lucky < (runeLevel*chancePerLevel)%100 then
		procs = procs + 1
	end

	return procs
end

function Runes:GetTotalRuneLevel(caster, tier, runeID, heroName)
	local runeUnit = ""
	if tier == 1 then
		runeUnit = caster.runeUnit
	elseif tier == 2 then
		runeUnit = caster.runeUnit2
	elseif tier == 3 then
		runeUnit = caster.runeUnit3
	elseif tier == 4 then
		runeUnit = caster.runeUnit4
	end
	local runeAbility = runeUnit:FindAbilityByName(heroName.."_rune_"..runeID)
	if runeAbility then
		local abilityLevel = runeAbility:GetLevel()
		if string.match(runeID, "arcana1") then
			runeID = string.gsub(runeID, "_arcana1", "")
		end
		local bonusLevel = Runes:GetTotalBonus(runeUnit, runeID)
		local totalLevel = abilityLevel + bonusLevel
		return totalLevel
	else
		-- local bonusLevel = Runes:GetTotalBonus(runeUnit, runeID)
		-- return bonusLevel
		return 0
	end
end

function Runes:GetTotalRuneLevelGeneric(caster, tier, index)
	local runeUnit = ""
	if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") or caster:HasModifier("modifier_sorceress_immortal_fire_avatar") then
		caster = caster.origCaster
	end
	if tier == 1 then
		runeUnit = caster.runeUnit
	elseif tier == 2 then
		runeUnit = caster.runeUnit2
	elseif tier == 3 then
		runeUnit = caster.runeUnit3
	elseif tier == 4 then
		runeUnit = caster.runeUnit4
	end
	local runeID = Runes:ConvertTierAndIndexToRune(tier, index)
	if runeUnit then
		local runeAbility = runeUnit:GetAbilityByIndex(index)
		if runeAbility then
			local abilityLevel = runeAbility:GetLevel()
			local bonusLevel = Runes:GetTotalBonus(runeUnit, runeID)
			local totalLevel = abilityLevel + bonusLevel
			return totalLevel
		else
			return 0
		end
	else
		return 0
	end
end

function Runes:GetRuneAbility(caster, tier, index)
	local runeUnit = ""
	if tier == 1 then
		runeUnit = caster.runeUnit
	elseif tier == 2 then
		runeUnit = caster.runeUnit2
	elseif tier == 3 then
		runeUnit = caster.runeUnit3
	elseif tier == 4 then
		runeUnit = caster.runeUnit4
	end
	local runeID = Runes:ConvertTierAndIndexToRune(tier, index)
	local runeAbility = runeUnit:GetAbilityByIndex(index)
	return runeAbility
end

function Runes:GetRunePropertyValue(caster, tier, index, propertyName)
	local runeUnit = ""
	if tier == 1 then
		runeUnit = caster.runeUnit
	elseif tier == 2 then
		runeUnit = caster.runeUnit2
	elseif tier == 3 then
		runeUnit = caster.runeUnit3
	elseif tier == 4 then
		runeUnit = caster.runeUnit4
	end
	local runeID = Runes:ConvertTierAndIndexToRune(tier, index)
	local runeAbility = runeUnit:GetAbilityByIndex(index)
	return runeAbility:GetSpecialValueFor(propertyName)
end

function Runes:ConvertTierAndIndexToRune(tier, index)
	local runeID = ""
	if tier == 1 and index == 0 then
		runeID = "a_a"
	elseif tier == 1 and index == 1 then
		runeID = "a_b"
	elseif tier == 1 and index == 2 then
		runeID = "a_c"
	elseif tier == 1 and index == 3 then
		runeID = "a_d"
	elseif tier == 2 and index == 0 then
		runeID = "b_a"
	elseif tier == 2 and index == 1 then
		runeID = "b_b"
	elseif tier == 2 and index == 2 then
		runeID = "b_c"
	elseif tier == 2 and index == 3 then
		runeID = "b_d"
	elseif tier == 3 and index == 0 then
		runeID = "c_a"
	elseif tier == 3 and index == 1 then
		runeID = "c_b"
	elseif tier == 3 and index == 2 then
		runeID = "c_c"
	elseif tier == 3 and index == 3 then
		runeID = "c_d"
	elseif tier == 4 and index == 0 then
		runeID = "d_a"
	elseif tier == 4 and index == 1 then
		runeID = "d_b"
	elseif tier == 4 and index == 2 then
		runeID = "d_c"
	elseif tier == 4 and index == 3 then
		runeID = "d_d"
	end
	return runeID
end

function Runes:apply_runes(ability, unit, PlayerID)
	local hero = GameState:GetHeroByPlayerID(PlayerID)
	if ability:GetLevel() > 0 then
		if ability:GetName() == "venomort_rune_a_b" then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_venomort_rune_a_b", {})
		end
		if ability:GetName() == "venomort_rune_b_c" then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_venomort_rune_b_c", {})
		end
		-- if ability:GetName() == "venomort_rune_b_a" then
		-- 	ability:ApplyDataDrivenModifier(unit, hero, "modifier_venomort_rune_b_a", {})
		-- end
		if ability:GetName() == "paladin_rune_a_c" and not hero:HasModifier("modifier_paladin_rune_a_c_revive_cooldown") then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_paladin_rune_a_c_revivable", {})
		end
		if ability:GetName() == "paladin_rune_b_c" then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_paladin_rune_b_c", {})
		end
		if ability:GetName() == "sorceress_rune_c_b" then
			unit:RemoveModifierByName("modifier_arcane_intellect_aura")
			unit:RemoveModifierByName("modifier_arcane_intellect_effect_invisible")
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_arcane_intellect_aura", {})
		end
		if ability:GetName() == "conjuror_rune_a_a" then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_earth_guardian", {})
		end
	end
	
end

function Runes:EquipArcana(hero, index)
	print("--------APPLY ARCANA HERO NAME-------")
	print(hero:GetUnitName())
	if hero:HasModifier("modifier_respawned_equip") then
		return false
	end
	if hero:GetUnitName() == "npc_dota_hero_dragon_knight" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(0)
			local abilityLevel = hero:GetAbilityByIndex(0):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(0):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(0):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(0):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(0):GetLevel()
			hero:RemoveAbility("fire_blast")
			local newAbility = hero:AddAbility("flamewaker_arcana_ability")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(0)

			hero.runeUnit:RemoveAbility("flamewaker_rune_a_a")
			hero.runeUnit2:RemoveAbility("flamewaker_rune_b_a")
			hero.runeUnit3:RemoveAbility("flamewaker_rune_c_a")
			hero.runeUnit4:RemoveAbility("flamewaker_rune_d_a")

			local newRune = hero.runeUnit:AddAbility("flamewaker_rune_a_a_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit2:AddAbility("flamewaker_rune_b_a_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit3:AddAbility("flamewaker_rune_c_a_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit4:AddAbility("flamewaker_rune_d_a_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(0)
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_flamewaker_think")
			Runes:EasySwapArcanaSkills(hero, 1, "second_heartbeat", "flamewaker_dragonflame", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_juggernaut" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(0)
			local abilityLevel = hero:GetAbilityByIndex(0):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(0):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(0):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(0):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(0):GetLevel()
			hero:RemoveAbility("seinaru_kaze_gust")
			local newAbility = hero:AddAbility("seinaru_arcana_ability")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(0)

			hero.runeUnit:RemoveAbility("monk_rune_a_a")
			hero.runeUnit2:RemoveAbility("monk_rune_b_a")
			hero.runeUnit3:RemoveAbility("monk_rune_c_a")
			hero.runeUnit4:RemoveAbility("monk_rune_d_a")

			local newRune = hero.runeUnit:AddAbility("monk_rune_a_a_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit2:AddAbility("monk_rune_b_a_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit3:AddAbility("monk_rune_c_a_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit4:AddAbility("monk_rune_d_a_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(0)
		elseif index == 2 then
			if hero:HasAbility("spiral_leap") then
				if hero:GetAbilityByIndex(2):GetName() == "spiral_leap" then
					hero:RemoveAbility("odachi_slice")
					Runes:EasySwapArcanaSkills(hero, 2, "spiral_leap", "seinaru_sunstrider", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
				else
					hero:RemoveAbility("spiral_leap")
					Runes:EasySwapArcanaSkills(hero, 2, "odachi_slice", "seinaru_sunstrider", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
				end
			else
				Runes:EasySwapArcanaSkills(hero, 2, "odachi_slice", "seinaru_sunstrider", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			end
			
		end
	elseif hero:GetUnitName() == "npc_dota_hero_leshrac" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(3):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(3):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(3):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(3):GetLevel()
			hero:RemoveAbility("charge_of_light")
			local newAbility = hero:AddAbility("bahamut_arcana_ulti")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(DOTA_ULTIMATE_SLOT)

			hero.runeUnit:RemoveAbility("bahamut_rune_a_d")
			hero.runeUnit2:RemoveAbility("bahamut_rune_b_d")
			hero.runeUnit3:RemoveAbility("bahamut_rune_c_d")
			hero.runeUnit4:RemoveAbility("bahamut_rune_d_d")

			local newRune = hero.runeUnit:AddAbility("bahamut_rune_a_d_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit2:AddAbility("bahamut_rune_b_d_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit3:AddAbility("bahamut_rune_c_d_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit4:AddAbility("bahamut_rune_d_d_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(3)
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_bahamut_a_b_buff")
			Runes:EasySwapArcanaSkills(hero, 1, "leshrac_nuke", "bahamut_arcana_orb", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifiers_rune_b_b_modifier")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_moon_shroud_passive")
			hero:RemoveModifierByName("modifier_astral_rune_d_a_visible")
			hero:RemoveModifierByName("modifier_astral_rune_d_a_invisible")
			local abilityIndex = 0
			local origAbility = hero:GetAbilityByIndex(abilityIndex)
			local abilityLevel = hero:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(abilityIndex):GetLevel()
			hero:RemoveAbility("moon_shroud")
			local newAbility = hero:AddAbility("astral_arcana_ability")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(abilityIndex)

			hero.runeUnit:RemoveAbility("astral_rune_a_a")
			hero.runeUnit2:RemoveAbility("astral_rune_b_a")
			hero.runeUnit3:RemoveAbility("astral_rune_c_a")
			hero.runeUnit4:RemoveAbility("astral_rune_d_a")

			local newRune = hero.runeUnit:AddAbility("astral_rune_a_a_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("astral_rune_b_a_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("astral_rune_c_a_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("astral_rune_d_a_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, 1, "split_shot", "shot_of_apollo", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			print("R$$$F")
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "ranger_aoe_explosion", "crystal_arrow", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_spirit_breaker" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_hidden_ghost_hallow_passive")
			local abilityIndex = 1
			local origAbility = hero:GetAbilityByIndex(abilityIndex)
			local abilityLevel = hero:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(abilityIndex):GetLevel()
			hero:RemoveAbility("ghost_hallow")
			local newAbility = hero:AddAbility("duskbringer_arcana_ability")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(abilityIndex)

			hero.runeUnit:RemoveAbility("duskbringer_rune_a_b")
			hero.runeUnit2:RemoveAbility("duskbringer_rune_b_b")
			hero.runeUnit3:RemoveAbility("duskbringer_rune_c_b")
			hero.runeUnit4:RemoveAbility("duskbringer_rune_d_b")

			local newRune = hero.runeUnit:AddAbility("duskbringer_rune_a_b_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("duskbringer_rune_b_b_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("duskbringer_rune_c_b_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("duskbringer_rune_d_b_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		end
	elseif hero:GetUnitName() == "npc_dota_hero_invoker" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(3):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(3):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(3):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(3):GetLevel()
			hero:RemoveAbility("call_of_elements")
			local newAbility = hero:AddAbility("conjuror_elemental_deity")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(DOTA_ULTIMATE_SLOT)

			hero.runeUnit:RemoveAbility("conjuror_rune_a_d")
			hero.runeUnit2:RemoveAbility("conjuror_rune_b_d")
			hero.runeUnit3:RemoveAbility("conjuror_rune_c_d")
			hero.runeUnit4:RemoveAbility("conjuror_rune_d_d")

			local newRune = hero.runeUnit:AddAbility("conjuror_rune_a_d_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit2:AddAbility("conjuror_rune_b_d_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit3:AddAbility("conjuror_rune_c_d_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit4:AddAbility("conjuror_rune_d_d_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(3)
		end
	elseif hero:GetUnitName() == "npc_dota_hero_templar_assassin" then
		if index == 1 then
			-- hero:RemoveModifierByName("modifier_hidden_ghost_hallow_passive")
			local abilityIndex = 1
			local origAbility = hero:GetAbilityByIndex(abilityIndex)
			local abilityLevel = hero:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(abilityIndex):GetLevel()

			if hero:HasAbility("explosive_bomb") then
				hero:RemoveAbility("explosive_bomb")
			end
			if hero:HasAbility("smoke_bomb") then
				hero:RemoveAbility("smoke_bomb")
			end
			if hero:HasAbility("flash_grenade") then
				hero:RemoveAbility("flash_grenade")
			end
			local newAbility = nil
			if hero:HasModifier("modifier_trapper_stealth") then
				newAbility = hero:AddAbility("trapper_arcana_lasso")
			else
				newAbility = hero:AddAbility("trapper_arcana_venom_whip")
			end
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(abilityIndex)

			hero.runeUnit:RemoveAbility("trapper_rune_a_b")
			hero.runeUnit2:RemoveAbility("trapper_rune_b_b")
			hero.runeUnit3:RemoveAbility("trapper_rune_c_b")
			hero.runeUnit4:RemoveAbility("trapper_rune_d_b")

			local newRune = hero.runeUnit:AddAbility("trapper_rune_a_b_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("trapper_rune_b_b_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("trapper_rune_c_b_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("trapper_rune_d_b_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		end
	elseif hero:GetUnitName() == "npc_dota_hero_huskar" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_ancient_vigor_passive")
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "spirit_warrior_ancient_vigor", "spirit_warrior_ancient_rain", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_spirit_warrior_passive")
			Runes:EasySwapArcanaSkills(hero, 1, "spirit_warrior_soul_thrust", "spirit_warrior_blazing_javelin", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			Runes:EasySwapArcanaSkills(hero, 2, "spirit_warrior_ancient_spirit", "spirit_warrior_ancient_spirit_elite", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_legion_commander" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_energy_channel")
			Runes:EasySwapArcanaSkills(hero, 1, "mountain_protector_mountain_guardian", "mountain_protector_steelforge_stance", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			-- Events:ColorWearables(hero, Vector(0, 0, 255))
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "mountain_protector_aeon_fracture", "mountain_protector_hailstorm", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			Runes:EasySwapArcanaSkills(hero, 2, "mountain_protector_emberstone", "mountain_protector_rockfall", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_zuus" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, 0, "heavens_shield", "auriun_aoe_shield", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, 0, "heavens_shield", "auriun_shadow_trap", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_necrolyte" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "snake_trap", "venom_reaper_slice", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_venomort_rune_b_a")
			Runes:EasySwapArcanaSkills(hero, 0, "gale_nova", "venomort_frostvenom_grasp", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_night_stalker" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "chernobog_nights_procession", "chernobog_demon_morph", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			if hero:FindAbilityByName("chernobog_shadow_walk"):GetToggleState() then
				hero:FindAbilityByName("chernobog_shadow_walk"):ToggleAbility()
			end
			Runes:EasySwapArcanaSkills(hero, 2, "chernobog_shadow_walk", "chernobog_demon_flight", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			if hero:HasModifier("modifier_chernobog_demon_form") then
				CustomAbilities:AddAndOrSwapSkill(hero, "chernobog_demon_flight", "chernobog_demon_walk", 2)
			end
		end
	elseif hero:GetUnitName() == "npc_dota_hero_phantom_assassin" then
		if index == 1 then
			local heavensCharge = hero:FindAbilityByName("heavens_charge")
			if heavensCharge then
				if hero.chargeActive then
				  	local azure_leap = hero:FindAbilityByName("electric_jump")
				  	azure_leap:SetLevel(heavensCharge:GetLevel())
				  	hero:SwapAbilities("heavens_charge", "electric_jump", false, true)
				  	azure_leap:SetAbilityIndex(2)
					hero:RemoveAbility("heavens_charge")
				else
					hero:RemoveAbility("heavens_charge")
				end
			end
			Runes:EasySwapArcanaSkills(hero, 2, "electric_jump", "voltex_lightning_dash", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, 0, "lightning_attack", "voltex_magnet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_omniknight" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_paladin_c_b_passive")
			Runes:EasySwapArcanaSkills(hero, 1, "holy_cone", "paladin_penance", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_paladin_rune_b_c")
			hero:RemoveModifierByName("modifier_paladin_rune_a_c_revivable")
			hero:RemoveModifierByName("modifier_paladin_rune_a_c_reviving")
			hero:RemoveModifierByName("modifier_paladin_rune_a_c_revive_cooldown")
			Runes:EasySwapArcanaSkills(hero, 2, "crusader_dash", "paladin_crusader_comet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_crystal_maiden" then
		if index == 1 then
			local fireball = hero:FindAbilityByName("fireball")
			if fireball then
				if hero:HasModifier("modifier_pyro_cooldown") then
				  	local pyroblast = hero:FindAbilityByName("pyroblast")
				  	pyroblast:SetLevel(fireball:GetLevel())
				  	hero:SwapAbilities("fireball", "pyroblast", false, true)
				  	pyroblast:SetAbilityIndex(DOTA_ULTIMATE_SLOT)
					hero:RemoveAbility("fireball")
				else
					hero:RemoveAbility("fireball")
				end
				hero:RemoveModifierByName("modifier_fireball_passive")
			end
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "pyroblast", "sorceress_arcana_ice_tornado", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			local ice_lance = hero:FindAbilityByName("ice_lance")
			if ice_lance then
				if hero:HasModifier("modifier_blizzard_cooldown") then
				  	local blizzard = hero:FindAbilityByName("blizzard")
				  	blizzard:SetLevel(ice_lance:GetLevel())
				  	hero:SwapAbilities("ice_lance", "blizzard", false, true)
				  	blizzard:SetAbilityIndex(DOTA_ULTIMATE_SLOT)
					hero:RemoveAbility("ice_lance")
				else
					hero:RemoveAbility("ice_lance")
				end
				hero:RemoveModifierByName("modifier_ice_lance_passive")
			end
			Runes:EasySwapArcanaSkills(hero, 0, "blizzard", "sorceress_fire_arcana_q", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_obsidian_destroyer" then
		hero:RemoveModifierByName("modifier_time_binder_passive")
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, 0, "time_binder", "epoch_arcana_ability", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_axe" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_axe_rune_d_d_think")
			hero:RemoveModifierByName("modifier_axe_rune_d_d_visible")
			hero:RemoveModifierByName("modifier_axe_rune_d_d_invisible")
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "sunder", "axe_arcana_smash", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_beastmaster" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "elemental_overload_2", "enhchant_tomahawk", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_visage" then
		if index == 1 then
			local dominionAbility = hero:FindAbilityByName("ekkan_dominion")
			if dominionAbility.dominionTable then
				for i = 1, #dominionAbility.dominionTable, 1 do
					dominionAbility.dominionTable[1]:ForceKill(false)
				end
			end
			Runes:EasySwapArcanaSkills(hero, 0, "ekkan_dominion", "ekkan_arcana_black_dominion", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_antimage" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_zonis_passive")
			hero:RemoveModifierByName("modifier_zonis_freecast")
			Runes:EasySwapArcanaSkills(hero, 0, "arkimus_zonis_spark", "arkimus_zap_ring", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "arkimus_energy_field", "arkimus_archon_form", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_dark_seer" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, 2, "zonik_lightspeed", "zhonik_temporal_field", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_speedball_b_d_mana_regen")
			hero:RemoveModifierByName("modifier_speedball_b_d_regen")
			hero:RemoveModifierByName("modifier_zonik_speedball_passive")
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "zonik_speedball", "timewarp_missles", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_slardar" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, 1, "hydroxis_water_blade", "hydroxis_arcana_ability_1", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "hydroxis_tsunami", "hydroxis_spellbound_flood_basin", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_vengefulspirit" then
		if index == 1 then
			print(hero.sunMoon)
			if hero.sunMoon == "moon" then
				if hero:HasAbility("solunia_solar_glow") then
					hero:RemoveAbility("solunia_solar_glow")
				end
				Runes:EasySwapArcanaSkills(hero, 0, "solunia_lunar_glow", "solunia_arcana_lunar_comet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
				local ability = hero:FindAbilityByName("solunia_arcana_lunar_comet")
				local max_charges = ability:GetLevelSpecialValueFor("max_charges", ability:GetLevel())
				ability:ApplyDataDrivenModifier(hero, hero, "modifier_lunar_comet_free_cast", {})
				hero:SetModifierStackCount("modifier_lunar_comet_free_cast", hero, max_charges)
			else
				if hero:HasAbility("solunia_lunar_glow") then
					hero:RemoveAbility("solunia_lunar_glow")
				end
				Runes:EasySwapArcanaSkills(hero, 0, "solunia_solar_glow", "solunia_arcana_solar_comet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			end
		elseif index == 2 then
			if hero.sunMoon == "moon" then
				if hero:HasAbility("solunia_supernova") then
					hero:RemoveAbility("solunia_supernova")
				end
				Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "solunia_eclipse", "solunia_lunar_alpha_spark", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			else
				if hero:HasAbility("solunia_eclipse") then
					hero:RemoveAbility("solunia_eclipse")
				end
				Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "solunia_supernova", "solunia_solar_alpha_spark", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			end
		end
	elseif hero:GetUnitName() == "npc_dota_hero_monkey_king" then
		if index == 1 then
			require('heroes/monkey_king/shapeshift')
			if hero:HasModifier("modifier_shapeshift_cat") or hero:HasModifier("modifier_shapeshift_bear") or hero:HasModifier("modifier_shapeshift_crow") then
				hero.forceNonBeast = true
				local eventTable = {}
				eventTable.caster = hero
				local monkey_ability = hero:FindAbilityByName("draghor_monkey_form")
				eventTable.ability = monkey_ability
				monkey_form(eventTable)
			end
			local ultAbility = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
			if ultAbility:GetAbilityName() == "draghor_shapeshift_cat" then
				Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "draghor_shapeshift_cat", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			elseif ultAbility:GetAbilityName() == "draghor_shapeshift_bear" then
				Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "draghor_shapeshift_bear", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			elseif ultAbility:GetAbilityName() == "draghor_shapeshift_crow" then
				Runes:EasySwapArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "draghor_shapeshift_crow", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			end
			hero:RemoveAbility("draghor_shapeshift_cat")
			hero:RemoveAbility("draghor_shapeshift_bear")
			hero:RemoveAbility("draghor_shapeshift_crow")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_skywrath_mage" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, 1, "piercing_gale", "icewind_gale", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			hero:RemoveModifierByName("modifier_sephyr_gale_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_winter_wyvern" then
		if index == 1 then
			local oldAbility = hero:FindAbilityByName("dinath_drake_ring")
			if oldAbility.ring then
				ParticleManager:DestroyParticle(oldAbility.ring.pfx, false)
				UTIL_Remove(oldAbility.ring)
				oldAbility.ring = false
			end
			Runes:EasySwapArcanaSkills(hero, 1, "dinath_drake_ring", "dinath_dragon_fire", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			hero:RemoveModifierByName("modifier_drake_ring_passive")
		end
	end
end



function Runes:EasySwapArcanaSkills(hero, abilityIndex, oldAbility, newAbility, internalName, rune_suffix)
	if internalName == "seinaru" then
		internalName = "monk"
	end
	local origAbility = hero:GetAbilityByIndex(abilityIndex)
	local abilityLevel = hero:GetAbilityByIndex(abilityIndex):GetLevel()
	local runeIndex = abilityIndex
	if runeIndex == DOTA_ULTIMATE_SLOT then
		runeIndex = 3
	end
	local runeLevel1 = hero.runeUnit:GetAbilityByIndex(runeIndex):GetLevel()
	local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(runeIndex):GetLevel()
	local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(runeIndex):GetLevel()
	local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(runeIndex):GetLevel()
	hero:RemoveAbility(oldAbility)
	local newAbility = hero:AddAbility(newAbility)
	newAbility:SetLevel(abilityLevel)
	newAbility:SetAbilityIndex(abilityIndex)
	local letter = "a"
	if runeIndex == 1 then
		letter = "b"
	elseif runeIndex == 2 then
		letter = "c"
	elseif runeIndex == 3 then
		letter ="d"
	end
	hero.runeUnit:RemoveAbility(internalName.."_rune_a_"..letter)
	hero.runeUnit2:RemoveAbility(internalName.."_rune_b_"..letter)
	hero.runeUnit3:RemoveAbility(internalName.."_rune_c_"..letter)
	hero.runeUnit4:RemoveAbility(internalName.."_rune_d_"..letter)

	local newRune = hero.runeUnit:AddAbility(internalName.."_rune_a_"..letter.."_"..rune_suffix)
	newRune:SetLevel(runeLevel1)
	newRune:SetAbilityIndex(runeIndex)
	local newRune = hero.runeUnit2:AddAbility(internalName.."_rune_b_"..letter.."_"..rune_suffix)
	newRune:SetLevel(runeLevel2)
	newRune:SetAbilityIndex(runeIndex)
	local newRune = hero.runeUnit3:AddAbility(internalName.."_rune_c_"..letter.."_"..rune_suffix)
	newRune:SetLevel(runeLevel3)
	newRune:SetAbilityIndex(runeIndex)
	local newRune = hero.runeUnit4:AddAbility(internalName.."_rune_d_"..letter.."_"..rune_suffix)
	newRune:SetLevel(runeLevel4)
	newRune:SetAbilityIndex(runeIndex)
end

function Runes:EasyRevertArcanaSkills(hero, abilityIndex, origAbility, arcanaAbility, internalName, rune_suffix)
	if internalName == "seinaru" then
		internalName = "monk"
	end
	local existingAbility = hero:FindAbilityByName(arcanaAbility)
	local abilityLevel = existingAbility:GetLevel()
	local runeIndex = abilityIndex
	if runeIndex == DOTA_ULTIMATE_SLOT then
		runeIndex = 3
	end
	local runeLevel1 = hero.runeUnit:GetAbilityByIndex(runeIndex):GetLevel()
	local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(runeIndex):GetLevel()
	local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(runeIndex):GetLevel()
	local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(runeIndex):GetLevel()
	hero:RemoveAbility(arcanaAbility)
	local newAbility = hero:AddAbility(origAbility)
	newAbility:SetLevel(abilityLevel)
	newAbility:SetAbilityIndex(abilityIndex)

	local letter = "a"
	if runeIndex == 1 then
		letter = "b"
	elseif runeIndex == 2 then
		letter = "c"
	elseif runeIndex == 3 then
		letter ="d"
	end

	hero.runeUnit:RemoveAbility(internalName.."_rune_a_"..letter.."_"..rune_suffix)
	hero.runeUnit2:RemoveAbility(internalName.."_rune_b_"..letter.."_"..rune_suffix)
	hero.runeUnit3:RemoveAbility(internalName.."_rune_c_"..letter.."_"..rune_suffix)
	hero.runeUnit4:RemoveAbility(internalName.."_rune_d_"..letter.."_"..rune_suffix)

	local newRune = hero.runeUnit:AddAbility(internalName.."_rune_a_"..letter)
	newRune:SetLevel(runeLevel1)
	newRune:SetAbilityIndex(runeIndex)
	local newRune = hero.runeUnit2:AddAbility(internalName.."_rune_b_"..letter)
	newRune:SetLevel(runeLevel2)
	newRune:SetAbilityIndex(runeIndex)
	local newRune = hero.runeUnit3:AddAbility(internalName.."_rune_c_"..letter)
	newRune:SetLevel(runeLevel3)
	newRune:SetAbilityIndex(runeIndex)
	local newRune = hero.runeUnit4:AddAbility(internalName.."_rune_d_"..letter)
	newRune:SetLevel(runeLevel4)
	newRune:SetAbilityIndex(runeIndex)
end

function Runes:UnequipArcana(hero, index)
	if hero:HasModifier("modifier_respawned_equip") then
		return false
	end
	if hero:GetUnitName() == "npc_dota_hero_dragon_knight" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(0)
			local abilityLevel = hero:GetAbilityByIndex(0):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(0):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(0):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(0):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(0):GetLevel()
			hero:RemoveAbility("flamewaker_arcana_ability")
			local newAbility = hero:AddAbility("fire_blast")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(0)

			hero.runeUnit:RemoveAbility("flamewaker_rune_a_a_arcana1")
			hero.runeUnit2:RemoveAbility("flamewaker_rune_b_a_arcana1")
			hero.runeUnit3:RemoveAbility("flamewaker_rune_c_a_arcana1")
			hero.runeUnit4:RemoveAbility("flamewaker_rune_d_a_arcana1")

			local newRune = hero.runeUnit:AddAbility("flamewaker_rune_a_a")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit2:AddAbility("flamewaker_rune_b_a")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit3:AddAbility("flamewaker_rune_c_a")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit4:AddAbility("flamewaker_rune_d_a")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(0)
			hero:RemoveModifierByName("modifier_flamewaker_arcana_passive")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_flamewaker_arcana2_passive")
			Runes:EasyRevertArcanaSkills(hero, 1, "second_heartbeat", "flamewaker_dragonflame", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_juggernaut" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(0)
			local abilityLevel = hero:GetAbilityByIndex(0):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(0):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(0):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(0):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(0):GetLevel()
			hero:RemoveAbility("seinaru_arcana_ability")
			local newAbility = hero:AddAbility("seinaru_kaze_gust")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(0)

			hero.runeUnit:RemoveAbility("monk_rune_a_a_arcana1")
			hero.runeUnit2:RemoveAbility("monk_rune_b_a_arcana1")
			hero.runeUnit3:RemoveAbility("monk_rune_c_a_arcana1")
			hero.runeUnit4:RemoveAbility("monk_rune_d_a_arcana1")

			local newRune = hero.runeUnit:AddAbility("monk_rune_a_a")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit2:AddAbility("monk_rune_b_a")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit3:AddAbility("monk_rune_c_a")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit4:AddAbility("monk_rune_d_a")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(0)
			hero:RemoveModifierByName("modifier_seinaru_arcana_passive")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 2, "odachi_slice", "seinaru_sunstrider", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifier_sunstrider_passive_think")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_leshrac" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(3):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(3):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(3):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(3):GetLevel()
			hero:RemoveAbility("bahamut_arcana_ulti")
			local newAbility = hero:AddAbility("charge_of_light")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(DOTA_ULTIMATE_SLOT)

			hero.runeUnit:RemoveAbility("bahamut_rune_a_d_arcana1")
			hero.runeUnit2:RemoveAbility("bahamut_rune_b_d_arcana1")
			hero.runeUnit3:RemoveAbility("bahamut_rune_c_d_arcana1")
			hero.runeUnit4:RemoveAbility("bahamut_rune_d_d_arcana1")

			local newRune = hero.runeUnit:AddAbility("bahamut_rune_a_d")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit2:AddAbility("bahamut_rune_b_d")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit3:AddAbility("bahamut_rune_c_d")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit4:AddAbility("bahamut_rune_d_d")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(3)
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 1, "leshrac_nuke", "bahamut_arcana_orb", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifier_lightning_dash")
			hero:RemoveModifierByName("modifier_bahamut_arcana_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
		if index == 1 then
			local abilityIndex = 0
			local origAbility = hero:GetAbilityByIndex(abilityIndex)
			local abilityLevel = hero:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(abilityIndex):GetLevel()
			hero:RemoveAbility("astral_arcana_ability")
			local newAbility = hero:AddAbility("moon_shroud")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(abilityIndex)

			hero.runeUnit:RemoveAbility("astral_rune_a_a_arcana1")
			hero.runeUnit2:RemoveAbility("astral_rune_b_a_arcana1")
			hero.runeUnit3:RemoveAbility("astral_rune_c_a_arcana1")
			hero.runeUnit4:RemoveAbility("astral_rune_d_a_arcana1")

			local newRune = hero.runeUnit:AddAbility("astral_rune_a_a")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("astral_rune_b_a")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("astral_rune_c_a")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("astral_rune_d_a")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)

			hero:RemoveModifierByName("modifier_astral_arcana_passive")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 1, "split_shot", "shot_of_apollo", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "ranger_aoe_explosion", "crystal_arrow", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
			hero:RemoveModifierByName("modifier_crystal_arrow_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_spirit_breaker" then
		if index == 1 then
			local abilityIndex = 1
			local origAbility = hero:GetAbilityByIndex(abilityIndex)
			local abilityLevel = hero:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(abilityIndex):GetLevel()
			hero:RemoveAbility("duskbringer_arcana_ability")
			local newAbility = hero:AddAbility("ghost_hallow")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(abilityIndex)

			hero.runeUnit:RemoveAbility("duskbringer_rune_a_b_arcana1")
			hero.runeUnit2:RemoveAbility("duskbringer_rune_b_b_arcana1")
			hero.runeUnit3:RemoveAbility("duskbringer_rune_c_b_arcana1")
			hero.runeUnit4:RemoveAbility("duskbringer_rune_d_b_arcana1")

			local newRune = hero.runeUnit:AddAbility("duskbringer_rune_a_b")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("duskbringer_rune_b_b")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("duskbringer_rune_c_b")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("duskbringer_rune_d_b")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		end
	elseif hero:GetUnitName() == "npc_dota_hero_invoker" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(3):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(3):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(3):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(3):GetLevel()
			hero:RemoveAbility("conjuror_elemental_deity")
			local newAbility = hero:AddAbility("call_of_elements")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(DOTA_ULTIMATE_SLOT)

			hero.runeUnit:RemoveAbility("conjuror_rune_a_d_arcana1")
			hero.runeUnit2:RemoveAbility("conjuror_rune_b_d_arcana1")
			hero.runeUnit3:RemoveAbility("conjuror_rune_c_d_arcana1")
			hero.runeUnit4:RemoveAbility("conjuror_rune_d_d_arcana1")

			local newRune = hero.runeUnit:AddAbility("conjuror_rune_a_d")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit2:AddAbility("conjuror_rune_b_d")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit3:AddAbility("conjuror_rune_c_d")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit4:AddAbility("conjuror_rune_d_d")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(3)

			if hero.deity then
				hero.deity:ForceKill(false)
			end
		end
	elseif hero:GetUnitName() == "npc_dota_hero_templar_assassin" then
		if index == 1 then
			hero.d_b_arcana_level = 0
			local abilityIndex = 1
			local origAbility = hero:GetAbilityByIndex(abilityIndex)
			local abilityLevel = hero:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(abilityIndex):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(abilityIndex):GetLevel()
			hero:RemoveAbility("trapper_arcana_venom_whip")
			hero:RemoveAbility("trapper_arcana_lasso")
			local newAbility = hero:AddAbility("explosive_bomb")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(abilityIndex)

			hero.runeUnit:RemoveAbility("trapper_rune_a_b_arcana1")
			hero.runeUnit2:RemoveAbility("trapper_rune_b_b_arcana1")
			hero.runeUnit3:RemoveAbility("trapper_rune_c_b_arcana1")
			hero.runeUnit4:RemoveAbility("trapper_rune_d_b_arcana1")

			local newRune = hero.runeUnit:AddAbility("trapper_rune_a_b")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("trapper_rune_b_b")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("trapper_rune_c_b")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("trapper_rune_d_b")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		end
	elseif hero:GetUnitName() == "npc_dota_hero_huskar" then
		if index == 1 then
			if hero:HasAbility("spirit_warrior_waterheart_weapon") then
				hero:RemoveAbility("spirit_warrior_waterheart_weapon")
			end
			hero:RemoveModifierByName("modifier_ancient_rain_regen")
			hero:RemoveModifierByName("modifier_rain_hidden_waterheart_thinker")
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "spirit_warrior_ancient_vigor", "spirit_warrior_ancient_rain", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_spirit_warrior_arcana2_passive")
			Runes:EasyRevertArcanaSkills(hero, 1, "spirit_warrior_soul_thrust", "spirit_warrior_blazing_javelin", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			Runes:EasyRevertArcanaSkills(hero, 2, "spirit_warrior_ancient_spirit", "spirit_warrior_ancient_spirit_elite", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_legion_commander" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_steelforge_stance")
			hero:RemoveModifierByName("modifier_steelforge_passive")
			Runes:EasyRevertArcanaSkills(hero, 1, "mountain_protector_mountain_guardian", "mountain_protector_steelforge_stance", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			-- Events:ColorWearables(hero, Vector(255, 255, 255))
			hero:RemoveModifierByName("modifier_hailstorm_passive")
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "mountain_protector_aeon_fracture", "mountain_protector_hailstorm", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			hero:RemoveModifierByName("modifier_rockfall_passive")
			local abilityCheck = hero:GetAbilityByIndex(2)
			if abilityCheck:GetAbilityName() == "mountain_protector_volcanic_glissade" then 
				CustomAbilities:AddAndOrSwapSkill(hero, "mountain_protector_volcanic_glissade", "mountain_protector_rockfall", 2)
			end
			if hero:HasAbility("mountain_protector_volcanic_glissade") then
				hero:RemoveAbility("mountain_protector_volcanic_glissade")
			end
			hero:RemoveModifierByName("modifier_mountain_rune_d_c_effect")
			hero:RemoveModifierByName("modifier_glissade_freecast")
			Runes:EasyRevertArcanaSkills(hero, 2, "mountain_protector_emberstone", "mountain_protector_rockfall", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_zuus" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_holy_wrath_passive")
			Runes:EasyRevertArcanaSkills(hero, 0, "heavens_shield", "auriun_aoe_shield", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_shadow_trap_passive")
			Runes:EasyRevertArcanaSkills(hero, 0, "heavens_shield", "auriun_shadow_trap", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_necrolyte" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "snake_trap", "venom_reaper_slice", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 0, "gale_nova", "venomort_frostvenom_grasp", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_night_stalker" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "chernobog_nights_procession", "chernobog_demon_morph", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			print("HERE?????????")
			if hero:GetAbilityByIndex(2):GetAbilityName() == "chernobog_demon_flight" then
				Runes:EasyRevertArcanaSkills(hero, 2, "chernobog_shadow_walk", "chernobog_demon_flight", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			elseif hero:GetAbilityByIndex(2):GetAbilityName() == "chernobog_demon_walk" then
				Runes:EasyRevertArcanaSkills(hero, 2, "chernobog_shadow_walk", "chernobog_demon_walk", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
				hero:RemoveAbility("chernobog_demon_flight")
			elseif hero:GetAbilityByIndex(2):GetAbilityName() == "chernobog_demon_warp" then
				Runes:EasyRevertArcanaSkills(hero, 2, "chernobog_shadow_walk", "chernobog_demon_warp", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
				hero:RemoveAbility("chernobog_demon_flight")
			end
			hero:RemoveModifierByName("modifier_demon_warp_freecast")
			hero:RemoveModifierByName("modifier_demon_flight_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_phantom_assassin" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_voltex_arcana1_passive")
			Runes:EasyRevertArcanaSkills(hero, 2, "electric_jump", "voltex_lightning_dash", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 0, "lightning_attack", "voltex_magnet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_omniknight" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_paladin_arcana_glove_passive")
			Runes:EasyRevertArcanaSkills(hero, 1, "holy_cone", "paladin_penance", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_paladin_arcana2_passive")
			Runes:EasyRevertArcanaSkills(hero, 2, "crusader_dash", "paladin_crusader_comet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_crystal_maiden" then
		hero:RemoveModifierByName("modifier_ice_tornado_passive")
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "pyroblast", "sorceress_arcana_ice_tornado", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			local sun_lance = hero:FindAbilityByName("sorceress_sun_lance")
			if sun_lance then
				if hero.sunlance then
				  	local incinerate = hero:FindAbilityByName("sorceress_fire_arcana_q")
				  	incinerate:SetLevel(sun_lance:GetLevel())
				  	hero:SwapAbilities("sorceress_sun_lance", "sorceress_fire_arcana_q", false, true)
				  	incinerate:SetAbilityIndex(0)
					hero:RemoveAbility("sorceress_sun_lance")
				else
					hero:RemoveAbility("sorceress_sun_lance")
				end
			end
			hero:RemoveModifierByName("modifier_sunlance_passive")
			Runes:EasyRevertArcanaSkills(hero, 0, "blizzard", "sorceress_fire_arcana_q", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_obsidian_destroyer" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_epoch_arcana_passive")
			Runes:EasyRevertArcanaSkills(hero, 0, "time_binder", "epoch_arcana_ability", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_axe" then
		hero:RemoveModifierByName("modifier_axe_arcana_passive")
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "sunder", "axe_arcana_smash", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_beastmaster" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "elemental_overload_2", "enhchant_tomahawk", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_visage" then
		local dominionAbility = hero:FindAbilityByName("ekkan_arcana_black_dominion")
		if dominionAbility.dominionTable then
			for i = 1, #dominionAbility.dominionTable, 1 do
				dominionAbility.dominionTable[1]:ForceKill(false)
			end
		end
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, 0, "ekkan_dominion", "ekkan_arcana_black_dominion", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_antimage" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_arkimus_arcana1_passive")
			Runes:EasyRevertArcanaSkills(hero, 0, "arkimus_zonis_spark", "arkimus_zap_ring", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "arkimus_energy_field", "arkimus_archon_form", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_dark_seer" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, 2, "zonik_lightspeed", "zhonik_temporal_field", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "zonik_speedball", "timewarp_missles", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifier_arcana_missle_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_slardar" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, 1, "hydroxis_water_blade", "hydroxis_arcana_ability_1", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "hydroxis_tsunami", "hydroxis_spellbound_flood_basin", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifier_basin_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_vengefulspirit" then
		if index == 1 then
			print(hero.sunMoon)		
			hero:RemoveModifierByName("modifier_solar_comet_free_cast")
			hero:RemoveModifierByName("modifier_lunar_comet_free_cast")
			hero:RemoveModifierByName("modifier_solar_comet_passive")
			if hero.sunMoon == "moon" then
				if hero:HasAbility("solunia_arcana_solar_comet") then
					hero:RemoveAbility("solunia_arcana_solar_comet")
				end
				Runes:EasyRevertArcanaSkills(hero, 0, "solunia_lunar_glow", "solunia_arcana_lunar_comet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			else
				if hero:HasAbility("solunia_arcana_lunar_comet") then
					hero:RemoveAbility("solunia_arcana_lunar_comet")
				end
				Runes:EasyRevertArcanaSkills(hero, 0, "solunia_solar_glow", "solunia_arcana_solar_comet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			end
		elseif index == 2 then
			if hero.sunMoon == "moon" then
				if hero:HasAbility("solunia_solar_alpha_spark") then
					hero:RemoveAbility("solunia_solar_alpha_spark")
				end
				Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "solunia_eclipse", "solunia_lunar_alpha_spark", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			else
				if hero:HasAbility("solunia_lunar_alpha_spark") then
					hero:RemoveAbility("solunia_lunar_alpha_spark")
				end
				Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "solunia_supernova", "solunia_solar_alpha_spark", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			end
		end
	elseif hero:GetUnitName() == "npc_dota_hero_monkey_king" then
		if index == 1 then
			hero:Stop()
			require('heroes/monkey_king/shapeshift')
			if hero:HasModifier("modifier_shapeshift_year_beast") then
				hero.forceOutYearBeast = true
				local eventTable = {}
				eventTable.caster = hero
				local monkey_ability = hero:FindAbilityByName("draghor_monkey_form")
				eventTable.ability = monkey_ability
				monkey_form(eventTable)
			end
			if hero:HasModifier("modifier_mark_of_the_fang") then
				Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "draghor_shapeshift_cat", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			elseif hero:HasModifier("modifier_mark_of_the_claw") then
				Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "draghor_shapeshift_bear", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			elseif hero:HasModifier("modifier_mark_of_the_talon") then
				Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "draghor_shapeshift_crow", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			else
				Runes:EasyRevertArcanaSkills(hero, DOTA_ULTIMATE_SLOT, "draghor_shapeshift_cat", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			end
		end
	elseif hero:GetUnitName() == "npc_dota_hero_skywrath_mage" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, 1, "piercing_gale", "icewind_gale", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			hero:RemoveModifierByName("modifier_icewind_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_winter_wyvern" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, 1, "dinath_drake_ring", "dinath_dragon_fire", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			hero:RemoveModifierByName("modifier_spire_breath_passive")
			hero:RemoveModifierByName("modifier_spire_breath")
			hero:RemoveModifierByName("modifier_spire_breath_a_b_buff")
			hero:RemoveModifierByName("modifier_dinath_passive_ms_cap")
		end
	end
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "ability_tree_upgrade", {playerId=hero:GetPlayerOwnerID()})
end


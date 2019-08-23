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
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "seinaru")
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
	elseif heroName == "npc_dota_hero_arc_warden" then
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, "jex")
	else
		local roshpit_name = HerosCustom:GetInternalHeroName(heroName)
		Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID, roshpit_name)
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
	runeUnit.amulet.q_1 = 0
	runeUnit.amulet.w_1 = 0
	runeUnit.amulet.e_1 = 0
	runeUnit.amulet.r_1 = 0
	runeUnit2.amulet = {}
	runeUnit2.amulet.q_2 = 0
	runeUnit2.amulet.w_2 = 0
	runeUnit2.amulet.e_2 = 0
	runeUnit2.amulet.r_2 = 0
	runeUnit3.amulet = {}
	runeUnit3.amulet.q_3 = 0
	runeUnit3.amulet.w_3 = 0
	runeUnit3.amulet.e_3 = 0
	runeUnit3.amulet.r_3 = 0
	runeUnit4.amulet = {}
	runeUnit4.amulet.q_4 = 0
	runeUnit4.amulet.w_4 = 0
	runeUnit4.amulet.e_4 = 0
	runeUnit4.amulet.r_4 = 0

	runeUnit.hand = {}
	runeUnit.hand.q_1 = 0
	runeUnit.hand.w_1 = 0
	runeUnit.hand.e_1 = 0
	runeUnit.hand.r_1 = 0
	runeUnit2.hand = {}
	runeUnit2.hand.q_2 = 0
	runeUnit2.hand.w_2 = 0
	runeUnit2.hand.e_2 = 0
	runeUnit2.hand.r_2 = 0
	runeUnit3.hand = {}
	runeUnit3.hand.q_3 = 0
	runeUnit3.hand.w_3 = 0
	runeUnit3.hand.e_3 = 0
	runeUnit3.hand.r_3 = 0
	runeUnit4.hand = {}
	runeUnit4.hand.q_4 = 0
	runeUnit4.hand.w_4 = 0
	runeUnit4.hand.e_4 = 0
	runeUnit4.hand.r_4 = 0

	runeUnit.body = {}
	runeUnit.body.q_1 = 0
	runeUnit.body.w_1 = 0
	runeUnit.body.e_1 = 0
	runeUnit.body.r_1 = 0
	runeUnit2.body = {}
	runeUnit2.body.q_2 = 0
	runeUnit2.body.w_2 = 0
	runeUnit2.body.e_2 = 0
	runeUnit2.body.r_2 = 0
	runeUnit3.body = {}
	runeUnit3.body.q_3 = 0
	runeUnit3.body.w_3 = 0
	runeUnit3.body.e_3 = 0
	runeUnit3.body.r_3 = 0
	runeUnit4.body = {}
	runeUnit4.body.q_4 = 0
	runeUnit4.body.w_4 = 0
	runeUnit4.body.e_4 = 0
	runeUnit4.body.r_4 = 0

	runeUnit.head = {}
	runeUnit.head.q_1 = 0
	runeUnit.head.w_1 = 0
	runeUnit.head.e_1 = 0
	runeUnit.head.r_1 = 0
	runeUnit2.head = {}
	runeUnit2.head.q_2 = 0
	runeUnit2.head.w_2 = 0
	runeUnit2.head.e_2 = 0
	runeUnit2.head.r_2 = 0
	runeUnit3.head = {}
	runeUnit3.head.q_3 = 0
	runeUnit3.head.w_3 = 0
	runeUnit3.head.e_3 = 0
	runeUnit3.head.r_3 = 0
	runeUnit4.head = {}
	runeUnit4.head.q_4 = 0
	runeUnit4.head.w_4 = 0
	runeUnit4.head.e_4 = 0
	runeUnit4.head.r_4 = 0

	runeUnit.weapon = {}
	runeUnit.weapon.q_1 = 0
	runeUnit.weapon.w_1 = 0
	runeUnit.weapon.e_1 = 0
	runeUnit.weapon.r_1 = 0
	runeUnit2.weapon = {}
	runeUnit2.weapon.q_2 = 0
	runeUnit2.weapon.w_2 = 0
	runeUnit2.weapon.e_2 = 0
	runeUnit2.weapon.r_2 = 0
	runeUnit3.weapon = {}
	runeUnit3.weapon.q_3 = 0
	runeUnit3.weapon.w_3 = 0
	runeUnit3.weapon.e_3 = 0
	runeUnit3.weapon.r_3 = 0
	runeUnit4.weapon = {}
	runeUnit4.weapon.q_4 = 0
	runeUnit4.weapon.w_4 = 0
	runeUnit4.weapon.e_4 = 0
	runeUnit4.weapon.r_4 = 0

	runeUnit.foot = {}
	runeUnit.foot.q_1 = 0
	runeUnit.foot.w_1 = 0
	runeUnit.foot.e_1 = 0
	runeUnit.foot.r_1 = 0
	runeUnit2.foot = {}
	runeUnit2.foot.q_2 = 0
	runeUnit2.foot.w_2 = 0
	runeUnit2.foot.e_2 = 0
	runeUnit2.foot.r_2 = 0
	runeUnit3.foot = {}
	runeUnit3.foot.q_3 = 0
	runeUnit3.foot.w_3 = 0
	runeUnit3.foot.e_3 = 0
	runeUnit3.foot.r_3 = 0
	runeUnit4.foot = {}
	runeUnit4.foot.q_4 = 0
	runeUnit4.foot.w_4 = 0
	runeUnit4.foot.e_4 = 0
	runeUnit4.foot.r_4 = 0
end

function Runes:RunesOnRespawn(hero)
	if hero:HasModifier("modifier_neutral_glyph_3_1") then
		hero:AddNewModifier(hero, nil, 'modifier_movespeed_cap_glyph', nil)
	end
	local heroName = hero:GetName()
	if heroName == "npc_dota_hero_crystal_maiden" then
		-- local runeUnit = hero.runeUnit2
		-- local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_q_2")
		-- local abilityLevel = runeAbility:GetLevel()
		-- local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_2")
		-- local totalLevel = abilityLevel + bonusLevel
		-- if totalLevel > 0 then
		-- runeAbility:ApplyDataDrivenModifier(runeUnit, hero, "modifier_frost_nova_up", {})
		-- hero:RemoveModifierByName("modifier_frost_nova_down")
		-- end
		-- runeUnit = hero.runeUnit3
		-- runeAbility = runeUnit:FindAbilityByName("sorceress_rune_r_3")
		-- abilityLevel = runeAbility:GetLevel()
		-- bonusLevel = Runes:GetTotalBonus(runeUnit, "r_3")
		-- totalLevel = abilityLevel + bonusLevel
		-- if totalLevel > 0 then
		-- runeAbility:ApplyDataDrivenModifier(runeUnit, hero, "modifier_ring_of_fire_up", {})
		-- hero:RemoveModifierByName("modifier_ring_of_fire_down")
		-- end
	end
	if heroName == "npc_dota_hero_omniknight" then
		-- local runeUnit = hero.runeUnit3
		-- local runeAbility = runeUnit:FindAbilityByName("paladin_rune_q_3")
		-- local abilityLevel = runeAbility:GetLevel()
		-- local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_3")
		-- local totalLevel = abilityLevel + bonusLevel
		-- if totalLevel > 0 then
		-- runeAbility:ApplyDataDrivenModifier(runeUnit, hero, "modifier_paladin_rune_q_3", {})
		-- hero:RemoveModifierByName("modifier_paladin_rune_q_3_cooling_down")
		-- end
	end
	if heroName == "npc_dota_hero_juggernaut" then
		-- if hero:HasAbility("odachi_rush") then
		-- hero:SwapAbilities("seinaru_odachi_leap", "odachi_rush", true, false)
		-- end
		-- if hero:HasAbility("monk_ultima_blade_heal_alt") then
		-- hero:SwapAbilities("monk_ultima_blade", "monk_ultima_blade_heal_alt", true, false)
		-- end
	end
end

function Runes:ResetRuneBonuses(hero, slotName)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_q_1_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_w_1_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_e_1_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_r_1_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_q_2_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_w_2_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_e_2_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_r_2_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_q_3_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_w_3_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_e_3_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_r_3_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_q_4_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_w_4_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_e_4_"..slotName, {bonus = 0})
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_rune_r_4_"..slotName, {bonus = 0})
end

function Runes:GetTotalBonus(RuneUnit, rune)
	if rune == "q_1" then
		return RuneUnit.amulet.q_1 + RuneUnit.hand.q_1 + RuneUnit.body.q_1 + RuneUnit.head.q_1 + RuneUnit.weapon.q_1 + RuneUnit.foot.q_1
	elseif rune == "w_1" then
		return RuneUnit.amulet.w_1 + RuneUnit.hand.w_1 + RuneUnit.body.w_1 + RuneUnit.head.w_1 + RuneUnit.weapon.w_1 + RuneUnit.foot.w_1
	elseif rune == "e_1" then
		return RuneUnit.amulet.e_1 + RuneUnit.hand.e_1 + RuneUnit.body.e_1 + RuneUnit.head.e_1 + RuneUnit.weapon.e_1 + RuneUnit.foot.e_1
	elseif rune == "r_1" then
		return RuneUnit.amulet.r_1 + RuneUnit.hand.r_1 + RuneUnit.body.r_1 + RuneUnit.head.r_1 + RuneUnit.weapon.r_1 + RuneUnit.foot.r_1
	elseif rune == "q_2" then
		return RuneUnit.amulet.q_2 + RuneUnit.hand.q_2 + RuneUnit.body.q_2 + RuneUnit.head.q_2 + RuneUnit.weapon.q_2 + RuneUnit.foot.q_2
	elseif rune == "w_2" then
		return RuneUnit.amulet.w_2 + RuneUnit.hand.w_2 + RuneUnit.body.w_2 + RuneUnit.head.w_2 + RuneUnit.weapon.w_2 + RuneUnit.foot.w_2
	elseif rune == "e_2" then
		return RuneUnit.amulet.e_2 + RuneUnit.hand.e_2 + RuneUnit.body.e_2 + RuneUnit.head.e_2 + RuneUnit.weapon.e_2 + RuneUnit.foot.e_2
	elseif rune == "r_2" then
		return RuneUnit.amulet.r_2 + RuneUnit.hand.r_2 + RuneUnit.body.r_2 + RuneUnit.head.r_2 + RuneUnit.weapon.r_2 + RuneUnit.foot.r_2
	elseif rune == "q_3" then
		return RuneUnit.amulet.q_3 + RuneUnit.hand.q_3 + RuneUnit.body.q_3 + RuneUnit.head.q_3 + RuneUnit.weapon.q_3 + RuneUnit.foot.q_3
	elseif rune == "w_3" then
		return RuneUnit.amulet.w_3 + RuneUnit.hand.w_3 + RuneUnit.body.w_3 + RuneUnit.head.w_3 + RuneUnit.weapon.w_3 + RuneUnit.foot.w_3
	elseif rune == "e_3" then
		return RuneUnit.amulet.e_3 + RuneUnit.hand.e_3 + RuneUnit.body.e_3 + RuneUnit.head.e_3 + RuneUnit.weapon.e_3 + RuneUnit.foot.e_3
	elseif rune == "r_3" then
		return RuneUnit.amulet.r_3 + RuneUnit.hand.r_3 + RuneUnit.body.r_3 + RuneUnit.head.r_3 + RuneUnit.weapon.r_3 + RuneUnit.foot.r_3
	elseif rune == "q_4" then
		return RuneUnit.amulet.q_4 + RuneUnit.hand.q_4 + RuneUnit.body.q_4 + RuneUnit.head.q_4 + RuneUnit.weapon.q_4 + RuneUnit.foot.q_4
	elseif rune == "w_4" then
		return RuneUnit.amulet.w_4 + RuneUnit.hand.w_4 + RuneUnit.body.w_4 + RuneUnit.head.w_4 + RuneUnit.weapon.w_4 + RuneUnit.foot.w_4
	elseif rune == "e_4" then
		return RuneUnit.amulet.e_4 + RuneUnit.hand.e_4 + RuneUnit.body.e_4 + RuneUnit.head.e_4 + RuneUnit.weapon.e_4 + RuneUnit.foot.e_4
	elseif rune == "r_4" then
		return RuneUnit.amulet.r_4 + RuneUnit.hand.r_4 + RuneUnit.body.r_4 + RuneUnit.head.r_4 + RuneUnit.weapon.r_4 + RuneUnit.foot.r_4
	end
end

function Runes:CollectHeroRunes(runeUnit, runeUnit2, runeUnit3, runeUnit4, player, heroString)
	runeUnit:AddAbility(heroString.."_rune_q_1")
	runeUnit:AddAbility(heroString.."_rune_w_1")
	runeUnit:AddAbility(heroString.."_rune_e_1")
	runeUnit:AddAbility(heroString.."_rune_r_1")

	runeUnit2:AddAbility(heroString.."_rune_q_2")
	runeUnit2:AddAbility(heroString.."_rune_w_2")
	runeUnit2:AddAbility(heroString.."_rune_e_2")
	runeUnit2:AddAbility(heroString.."_rune_r_2")

	runeUnit3:AddAbility(heroString.."_rune_q_3")
	runeUnit3:AddAbility(heroString.."_rune_w_3")
	runeUnit3:AddAbility(heroString.."_rune_e_3")
	runeUnit3:AddAbility(heroString.."_rune_r_3")

	runeUnit4:AddAbility(heroString.."_rune_q_4")
	runeUnit4:AddAbility(heroString.."_rune_w_4")
	runeUnit4:AddAbility(heroString.."_rune_e_4")
	runeUnit4:AddAbility(heroString.."_rune_r_4")
end

function Runes:Procs(runeLevel, chancePerLevel, mod)
	chancePerLevel = chancePerLevel / mod
	local procs = ((runeLevel * chancePerLevel) - ((runeLevel * chancePerLevel) % 100)) / 100
	local lucky = RandomInt(0, 100)
	if lucky < (runeLevel * chancePerLevel) % 100 then
		procs = procs + 1
	end

	return procs
end

function Runes:GetTotalRuneLevel(caster, tier, runeID, heroName)
	if not caster:IsRealHero() then
		return 0
	end
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
		if runeAbility:IsActivated() then
			local abilityLevel = runeAbility:GetLevel()
			if string.match(runeID, "arcana1") then
				runeID = string.gsub(runeID, "_arcana1", "")
			end
			local bonusLevel = Runes:GetTotalBonus(runeUnit, runeID)
			local totalLevel = abilityLevel + bonusLevel
			return totalLevel
		else
			return 0
		end
	else
		-- local bonusLevel = Runes:GetTotalBonus(runeUnit, runeID)
		-- return bonusLevel
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

function Runes:GetRuneLetterByIndex(index)
	local letter = ""
	if index == 1 then
		letter = "q"
	elseif index == 2 then
		letter = "w"
	elseif index == 3 then
		letter = "e"
	elseif index == 4 then
		letter = "r"
	end
	return letter
end

function Runes:ConvertTierAndIndexToRune(tier, index)
	local runeID = ""
	if tier == 1 and index == 0 then
		runeID = "q_1"
	elseif tier == 1 and index == 1 then
		runeID = "w_1"
	elseif tier == 1 and index == 2 then
		runeID = "e_1"
	elseif tier == 1 and index == 3 then
		runeID = "r_1"
	elseif tier == 2 and index == 0 then
		runeID = "q_2"
	elseif tier == 2 and index == 1 then
		runeID = "w_2"
	elseif tier == 2 and index == 2 then
		runeID = "e_2"
	elseif tier == 2 and index == 3 then
		runeID = "r_2"
	elseif tier == 3 and index == 0 then
		runeID = "q_3"
	elseif tier == 3 and index == 1 then
		runeID = "w_3"
	elseif tier == 3 and index == 2 then
		runeID = "e_3"
	elseif tier == 3 and index == 3 then
		runeID = "r_3"
	elseif tier == 4 and index == 0 then
		runeID = "q_4"
	elseif tier == 4 and index == 1 then
		runeID = "w_4"
	elseif tier == 4 and index == 2 then
		runeID = "e_4"
	elseif tier == 4 and index == 3 then
		runeID = "r_4"
	end
	return runeID
end

function Runes:apply_runes(ability, unit, PlayerID)
	local hero = GameState:GetHeroByPlayerID(PlayerID)
	if ability:GetLevel() > 0 then
		if ability:GetName() == "venomort_rune_w_1" then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_venomort_rune_w_1", {})
		end
		if ability:GetName() == "venomort_rune_e_2" then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_venomort_rune_e_2", {})
		end
		-- if ability:GetName() == "venomort_rune_q_2" then
		-- ability:ApplyDataDrivenModifier(unit, hero, "modifier_venomort_rune_q_2", {})
		-- end
		if ability:GetName() == "paladin_rune_e_1" and not hero:HasModifier("modifier_paladin_rune_e_1_revive_cooldown") then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_paladin_rune_e_1_revivable", {})
		end
		if ability:GetName() == "paladin_rune_e_2" then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_paladin_rune_e_2", {})
		end
		if ability:GetName() == "sorceress_rune_w_3" then
			unit:RemoveModifierByName("modifier_arcane_intellect_aura")
			unit:RemoveModifierByName("modifier_arcane_intellect_effect_invisible")
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_arcane_intellect_aura", {})
		end
		if ability:GetName() == "conjuror_rune_q_1" then
			ability:ApplyDataDrivenModifier(unit, hero, "modifier_earth_guardian", {})
        end
		local letter, tier = ability:GetName():match(".*_rune_(.)_(.)")
		if letter ~= nil and tier ~= nil then
			Runes:OnRuneCountUpdate(hero, letter, tier)
		end
	end
	-- if hero:GetUnitName() == "npc_dota_hero_faceless_void" then
	-- local player = hero:GetPlayerOwner()
	-- CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro_data = hero.omniro_data, omniro = hero:GetEntityIndex(), reconstruct = true})
	-- end
end

function Runes:EquipArcana(hero, index)
	--print("--------APPLY ARCANA HERO NAME-------")
	--print(hero:GetUnitName())
	if hero:HasModifier("modifier_respawned_equip") then
		return false
	end
	if hero:GetUnitName() == "npc_dota_hero_dragon_knight" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_Q_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			hero:RemoveAbility("seismic_flare")
			local newAbility = hero:AddAbility("flamewaker_arcana_ability")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(0)

			hero.runeUnit:RemoveAbility("flamewaker_rune_q_1")
			hero.runeUnit2:RemoveAbility("flamewaker_rune_q_2")
			hero.runeUnit3:RemoveAbility("flamewaker_rune_q_3")
			hero.runeUnit4:RemoveAbility("flamewaker_rune_q_4")

			local newRune = hero.runeUnit:AddAbility("flamewaker_rune_q_1_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit2:AddAbility("flamewaker_rune_q_2_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit3:AddAbility("flamewaker_rune_q_3_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit4:AddAbility("flamewaker_rune_q_4_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(0)
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_flamewaker_think")
			Runes:EasySwapArcanaSkills(hero, 1, "second_heartbeat", "flamewaker_dragonflame", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_juggernaut" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_Q_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			hero:RemoveAbility("seinaru_konokaze")
			local newAbility = hero:AddAbility("seinaru_blade_dash")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(0)

			hero.runeUnit:RemoveAbility("seinaru_rune_q_1")
			hero.runeUnit2:RemoveAbility("seinaru_rune_q_2")
			hero.runeUnit3:RemoveAbility("seinaru_rune_q_3")
			hero.runeUnit4:RemoveAbility("seinaru_rune_q_4")

			local newRune = hero.runeUnit:AddAbility("seinaru_rune_q_1_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit2:AddAbility("seinaru_rune_q_2_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit3:AddAbility("seinaru_rune_q_3_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit4:AddAbility("seinaru_rune_q_4_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(0)
		elseif index == 2 then
			if hero:HasAbility("seinaru_spiral_leap") then
				if hero:GetAbilityByIndex(DOTA_E_SLOT):GetName() == "seinaru_spiral_leap" then
					hero:RemoveAbility("seinaru_odachi_leap")
					Runes:EasySwapArcanaSkills(hero, 2, "seinaru_spiral_leap", "seinaru_sunstrider", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
				else
					hero:RemoveAbility("seinaru_spiral_leap")
					Runes:EasySwapArcanaSkills(hero, 2, "seinaru_odachi_leap", "seinaru_sunstrider", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
				end
			else
				Runes:EasySwapArcanaSkills(hero, 2, "seinaru_odachi_leap", "seinaru_sunstrider", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			end

		end
	elseif hero:GetUnitName() == "npc_dota_hero_leshrac" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_R_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_R_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			hero:RemoveAbility("charge_of_light")
			local newAbility = hero:AddAbility("bahamut_arcana_ulti")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(DOTA_R_SLOT)

			hero.runeUnit:RemoveAbility("bahamut_rune_r_1")
			hero.runeUnit2:RemoveAbility("bahamut_rune_r_2")
			hero.runeUnit3:RemoveAbility("bahamut_rune_r_3")
			hero.runeUnit4:RemoveAbility("bahamut_rune_r_4")

			local newRune = hero.runeUnit:AddAbility("bahamut_rune_r_1_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit2:AddAbility("bahamut_rune_r_2_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit3:AddAbility("bahamut_rune_r_3_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit4:AddAbility("bahamut_rune_r_4_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(3)
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_bahamut_a_b_buff")
			Runes:EasySwapArcanaSkills(hero, 1, "leshrac_nuke", "bahamut_arcana_orb", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifiers_rune_w_2_modifier")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_moon_shroud_passive")
			hero:RemoveModifierByName("modifier_astral_rune_q_4_visible")
			hero:RemoveModifierByName("modifier_astral_rune_q_4_invisible")
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

			hero.runeUnit:RemoveAbility("astral_rune_q_1")
			hero.runeUnit2:RemoveAbility("astral_rune_q_2")
			hero.runeUnit3:RemoveAbility("astral_rune_q_3")
			hero.runeUnit4:RemoveAbility("astral_rune_q_4")

			local newRune = hero.runeUnit:AddAbility("astral_rune_q_1_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("astral_rune_q_2_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("astral_rune_q_3_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("astral_rune_q_4_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, 1, "split_shot", "shot_of_apollo", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			--print("R$$$F")
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "ranger_aoe_explosion", "crystal_arrow", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
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

			hero.runeUnit:RemoveAbility("duskbringer_rune_w_1")
			hero.runeUnit2:RemoveAbility("duskbringer_rune_w_2")
			hero.runeUnit3:RemoveAbility("duskbringer_rune_w_3")
			hero.runeUnit4:RemoveAbility("duskbringer_rune_w_4")

			local newRune = hero.runeUnit:AddAbility("duskbringer_rune_w_1_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("duskbringer_rune_w_2_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("duskbringer_rune_w_3_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("duskbringer_rune_w_4_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_flail_passive")
			Runes:EasySwapArcanaSkills(hero, 0, "whirling_flail", "duskbringer_arcana_terrorize", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_invoker" then
		--print("-----HELLO----")
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_R_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_R_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			hero:RemoveAbility("call_of_elements")
			local newAbility = hero:AddAbility("conjuror_elemental_deity")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(DOTA_R_SLOT)

			hero.runeUnit:RemoveAbility("conjuror_rune_r_1")
			hero.runeUnit2:RemoveAbility("conjuror_rune_r_2")
			hero.runeUnit3:RemoveAbility("conjuror_rune_r_3")
			hero.runeUnit4:RemoveAbility("conjuror_rune_r_4")

			local newRune = hero.runeUnit:AddAbility("conjuror_rune_r_1_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit2:AddAbility("conjuror_rune_r_2_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit3:AddAbility("conjuror_rune_r_3_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit4:AddAbility("conjuror_rune_r_4_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(3)
		elseif index == 2 then
			if hero.fireAspect then
				if IsValidEntity(hero.fireAspect) then
					hero.fireAspect:SetHealth(10)
					hero.fireAspect:ForceKill(true)
				end
			end
			if hero:HasAbility("immolation") then
				hero:RemoveAbility("immolation")
			end
			Runes:EasySwapArcanaSkills(hero, 1, "summon_fire_aspect", "summon_fire_deity", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			if hero.earthAspect then
				if IsValidEntity(hero.earthAspect) then
					hero.earthAspectResummonForbidden = true
					hero.earthAspect:SetHealth(10)
					hero.earthAspect:ForceKill(true)
				end
			end
			if hero:HasAbility("earthquake") then
				hero:RemoveAbility("earthquake")
			end
			Runes:EasySwapArcanaSkills(hero, 0, "summon_earth_aspect", "summon_earth_deity", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
		elseif index == 4 then
			if hero.shadowAspect then
				if IsValidEntity(hero.shadowAspect) then
					hero.shadowAspect:SetHealth(10)
					hero.shadowAspect:ForceKill(true)
				end
			end
			if hero:HasAbility("shadow_gate") then
				hero:RemoveAbility("shadow_gate")
			end
			Runes:EasySwapArcanaSkills(hero, 2, "summon_shadow_aspect", "summon_shadow_deity", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana4")
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

			hero.runeUnit:RemoveAbility("trapper_rune_w_1")
			hero.runeUnit2:RemoveAbility("trapper_rune_w_2")
			hero.runeUnit3:RemoveAbility("trapper_rune_w_3")
			hero.runeUnit4:RemoveAbility("trapper_rune_w_4")

			local newRune = hero.runeUnit:AddAbility("trapper_rune_w_1_arcana1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("trapper_rune_w_2_arcana1")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("trapper_rune_w_3_arcana1")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("trapper_rune_w_4_arcana1")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		end
	elseif hero:GetUnitName() == "npc_dota_hero_huskar" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_ancient_vigor_passive")
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "spirit_warrior_ancient_vigor", "spirit_warrior_ancient_rain", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
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
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "mountain_protector_aeon_fracture", "mountain_protector_hailstorm", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
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
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "snake_trap", "venom_reaper_slice", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_venomort_rune_q_2")
			Runes:EasySwapArcanaSkills(hero, 0, "gale_nova", "venomort_frostvenom_grasp", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_night_stalker" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "chernobog_4_r", "chernobog_demon_morph", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			if hero:FindAbilityByName("chernobog_3_e"):GetToggleState() then
				hero:FindAbilityByName("chernobog_3_e"):ToggleAbility()
			end
			Runes:EasySwapArcanaSkills(hero, 2, "chernobog_3_e", "chernobog_demon_flight", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			if hero:HasModifier("modifier_chernobog_demon_form") then
				CustomAbilities:AddAndOrSwapSkill(hero, "chernobog_demon_flight", "chernobog_demon_walk", 2)
			end
		end
	elseif hero:GetUnitName() == "npc_dota_hero_phantom_assassin" then
		if index == 1 then
			local heavensCharge = hero:FindAbilityByName("voltex_rune_e_3_heavens_charge")
			if heavensCharge then
				if hero.chargeActive then
					local azure_leap = hero:FindAbilityByName("voltex_azure_leap")
					azure_leap:SetLevel(heavensCharge:GetLevel())
					hero:SwapAbilities("voltex_rune_e_3_heavens_charge", "voltex_azure_leap", false, true)
					azure_leap:SetAbilityIndex(2)
					hero:RemoveAbility("voltex_rune_e_3_heavens_charge")
				else
					hero:RemoveAbility("voltex_rune_e_3_heavens_charge")
				end
			end
			Runes:EasySwapArcanaSkills(hero, 2, "voltex_azure_leap", "voltex_lightning_dash", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, 0, "voltex_overcharge", "voltex_magnet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_omniknight" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_paladin_c_b_passive")
			Runes:EasySwapArcanaSkills(hero, 1, "justice_overwhelming", "paladin_penance", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_paladin_rune_e_2")
			hero:RemoveModifierByName("modifier_paladin_rune_e_1_revivable")
			hero:RemoveModifierByName("modifier_paladin_rune_e_1_reviving")
			hero:RemoveModifierByName("modifier_paladin_rune_e_1_revive_cooldown")
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
					pyroblast:SetAbilityIndex(DOTA_R_SLOT)
					hero:RemoveAbility("fireball")
				else
					hero:RemoveAbility("fireball")
				end
				hero:RemoveModifierByName("modifier_fireball_passive")
			end
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "pyroblast", "sorceress_arcana_ice_tornado", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			local ice_lance = hero:FindAbilityByName("ice_lance")
			if ice_lance then
				if hero:HasModifier("modifier_blizzard_cooldown") then
					local blizzard = hero:FindAbilityByName("blizzard")
					blizzard:SetLevel(ice_lance:GetLevel())
					hero:SwapAbilities("ice_lance", "blizzard", false, true)
					blizzard:SetAbilityIndex(DOTA_R_SLOT)
					hero:RemoveAbility("ice_lance")
				else
					hero:RemoveAbility("ice_lance")
				end
				hero:RemoveModifierByName("modifier_ice_lance_passive")
			end
			Runes:EasySwapArcanaSkills(hero, 0, "blizzard", "sorceress_fire_arcana_q", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_obsidian_destroyer" then
		hero:RemoveModifierByName("modifier_epoch_time_binder_passive")
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, 0, "epoch_time_binder", "epoch_arcana_ability", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_axe" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_axe_rune_r_4_think")
			hero:RemoveModifierByName("modifier_axe_rune_r_4_visible")
			hero:RemoveModifierByName("modifier_axe_rune_r_4_invisible")
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "sunder", "axe_arcana_smash", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, 1, "backshock", "axe_stonewall_ability", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_beastmaster" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "elemental_overload_2", "enhchant_tomahawk", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			local abilityCheck = hero:GetAbilityByIndex(DOTA_Q_SLOT)
			local abilities_to_remove_table = {}
			local new_ability_name = ""
			if abilityCheck:GetAbilityName() == "warlord_stone_form" then
				new_ability_name = "warlord_cataclysm_shaker"
				abilities_to_remove_table = {"warlord_ice_shell", "warlord_flame_rush"}
			elseif abilityCheck:GetAbilityName() == "warlord_ice_shell" then
				new_ability_name = "warlord_frost_scathe"
				abilities_to_remove_table = {"warlord_stone_form", "warlord_flame_rush"}
			elseif abilityCheck:GetAbilityName() == "warlord_flame_rush" then
				new_ability_name = "warlord_flame_wreck"
				abilities_to_remove_table = {"warlord_stone_form", "warlord_ice_shell"}
			end
			for i = 1, #abilities_to_remove_table, 1 do
				local ability_name = abilities_to_remove_table[i]
				if hero:HasAbility(ability_name) then
					hero:RemoveAbility(ability_name)
				end
			end
			Runes:EasySwapArcanaSkills(hero, 0, abilityCheck:GetAbilityName(), new_ability_name, HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
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
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "arkimus_energy_field", "arkimus_archon_form", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_dark_seer" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, 2, "zonik_lightspeed", "zhonik_temporal_field", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_speedball_b_d_mana_regen")
			hero:RemoveModifierByName("modifier_speedball_b_d_regen")
			hero:RemoveModifierByName("modifier_zonik_speedball_passive")
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "zonik_speedball", "timewarp_missles", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_slardar" then
		if index == 1 then
			Runes:EasySwapArcanaSkills(hero, 1, "hydroxis_water_blade", "hydroxis_arcana_ability_1", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "hydroxis_tsunami", "hydroxis_spellbound_flood_basin", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_vengefulspirit" then
		if index == 1 then
			--print(hero.sunMoon)
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
				Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "solunia_eclipse", "solunia_lunar_alpha_spark", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			else
				if hero:HasAbility("solunia_eclipse") then
					hero:RemoveAbility("solunia_eclipse")
				end
				Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "solunia_supernova", "solunia_solar_alpha_spark", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			end
		elseif index == 3 then
			hero:RemoveModifierByName("modifier_outgoing_solarang")
			hero:RemoveModifierByName("modifier_outgoing_lunarang")
			if hero.sunMoon == "moon" then
				if hero:HasAbility("solunia_solarang") then
					hero:RemoveAbility("solunia_solarang")
				end
				Runes:EasySwapArcanaSkills(hero, 1, "solunia_lunarang", "solunia_lunar_vorpal_blades", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
			else
				if hero:HasAbility("solunia_lunarang") then
					hero:RemoveAbility("solunia_lunarang")
				end
				Runes:EasySwapArcanaSkills(hero, 1, "solunia_solarang", "solunia_solar_vorpal_blades", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
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
			local ultAbility = hero:GetAbilityByIndex(DOTA_R_SLOT)
			if ultAbility:GetAbilityName() == "draghor_shapeshift_cat" then
				Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "draghor_shapeshift_cat", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			elseif ultAbility:GetAbilityName() == "draghor_shapeshift_bear" then
				Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "draghor_shapeshift_bear", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			elseif ultAbility:GetAbilityName() == "draghor_shapeshift_crow" then
				Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "draghor_shapeshift_crow", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
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
	elseif hero:GetUnitName() == "npc_dota_hero_arc_warden" then
		Timers:CreateTimer(0, function()
			if hero.onibi then
				if index == 1 then
					local abilityCheck = hero:GetAbilityByIndex(DOTA_W_SLOT)
					if abilityCheck:GetAbilityName() ~= "jex_base_cannon_lightning" then
						CustomAbilities:AddAndOrSwapSkill(hero, abilityCheck:GetAbilityName(), "jex_base_cannon_lightning", 1)
					end
					local abilityCheck = hero:GetAbilityByIndex(DOTA_Q_SLOT)
					if abilityCheck:GetAbilityName() ~= "jex_base_cannon_nature" then
						CustomAbilities:AddAndOrSwapSkill(hero, abilityCheck:GetAbilityName(), "jex_base_cannon_nature", 0)
					end
					local abilityCheck = hero:GetAbilityByIndex(DOTA_E_SLOT)
					if abilityCheck:GetAbilityName() ~= "jex_base_cannon_cosmic" then
						CustomAbilities:AddAndOrSwapSkill(hero, abilityCheck:GetAbilityName(), "jex_base_cannon_cosmic", 2)
					end
					hero:RemoveModifierByName("modifier_jex_vortex_w")

					local abilities_to_remove_table = {"jex_thunder_thunder_q", "jex_lightning_cosmic_q", "jex_lightning_nature_q", "jex_lightning_lightning_w", "jex_lightning_nature_w", "jex_lightning_cosmic_w", "jex_lightning_nature_e", "jex_lightning_lightning_e", "jex_lightning_cosmic_e"}
					for i = 1, #abilities_to_remove_table, 1 do
						local ability_name = abilities_to_remove_table[i]
						if hero:HasAbility(ability_name) then
							hero:RemoveAbility(ability_name)
						end
					end

					Runes:EasySwapArcanaSkills(hero, 1, "jex_base_cannon_lightning", "jex_base_cannon_fire", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
					local onibi = hero.onibi
					local onibi_ability_check1 = onibi:GetAbilityByIndex(DOTA_D_SLOT)
					CustomAbilities:AddAndOrSwapSkill(onibi, onibi_ability_check1:GetAbilityName(), "onibi_fire_1", 3)
					local onibi_ability_check2 = onibi:GetAbilityByIndex(DOTA_F_SLOT)
					CustomAbilities:AddAndOrSwapSkill(onibi, onibi_ability_check2:GetAbilityName(), "onibi_fire_2", 4)
					onibi.stats_table["arcanas"] = {}
					onibi.stats_table["arcanas"]["fire"] = 1
					if not onibi.stats_table["fire"]["exp"] then
						onibi.stats_table["fire"]["exp"] = 0
					end
					if not onibi.stats_table["fire"]["level"] then
						onibi.stats_table["fire"]["level"] = 0
					end
					require('heroes/arc_warden/abilities/onibi')
					calculate_onibi_element_levels(onibi)
				end
			else
				--print("retrying arcana equip")
				return 0.5
			end
		end)
	elseif hero:GetUnitName() == "npc_dota_hero_slark" then
		if index == 1 then
			local abilityCheck = hero:GetAbilityByIndex(DOTA_E_SLOT)
			if abilityCheck:GetAbilityName() ~= "slipfinn_shadow_rush" then
				CustomAbilities:AddAndOrSwapSkill(hero, abilityCheck:GetAbilityName(), "slipfinn_shadow_rush", 2)
			end
			hero:RemoveModifierByName("modifier_slipfinn_b_c_health")
			hero:RemoveModifierByName("modifier_slipfinn_b_c_health_regen")
			hero:RemoveAbility("slipfinn_shadow_warp")
			Runes:EasySwapArcanaSkills(hero, 2, "slipfinn_shadow_rush", "slipfinn_bog_roller", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	end
end

local keep_modifiers = {
	"modifier_draghor_main_passive"
}

function Runes:EasySwapArcanaSkills(hero, abilityIndex, oldAbility, newAbility, internalName, rune_suffix)
	local origAbility = hero:GetAbilityByIndex(abilityIndex)
	local abilityLevel = hero:GetAbilityByIndex(abilityIndex):GetLevel()
	local abilitySlot = abilityIndex
	if abilitySlot == DOTA_R_SLOT then
		abilitySlot = 3
	end
	local modifiers = hero:FindAllModifiers()
	for _, modifier in pairs(modifiers) do
		if modifier:GetAbility() == origAbility and not WallPhysics:DoesTableHaveValue(keep_modifiers, modifier:GetName()) then
			hero:RemoveModifierByName(modifier:GetName())
		end
	end
	local runeLevel1 = hero.runeUnit:GetAbilityByIndex(abilitySlot):GetLevel()
	local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(abilitySlot):GetLevel()
	local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(abilitySlot):GetLevel()
	local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(abilitySlot):GetLevel()
	hero:RemoveAbility(oldAbility)
	local newAbility = hero:AddAbility(newAbility)
	newAbility:SetLevel(abilityLevel)
	newAbility:SetAbilityIndex(abilityIndex)
	local letter = "q"
	if abilitySlot == 1 then
		letter = "w"
	elseif abilitySlot == 2 then
		letter = "e"
	elseif abilitySlot == 3 then
		letter = "r"
	end
	hero.runeUnit:RemoveAbility(internalName.."_rune_"..letter.."_1")
	hero.runeUnit2:RemoveAbility(internalName.."_rune_"..letter.."_2")
	hero.runeUnit3:RemoveAbility(internalName.."_rune_"..letter.."_3")
	hero.runeUnit4:RemoveAbility(internalName.."_rune_"..letter.."_4")

	local newRune = hero.runeUnit:AddAbility(internalName.."_rune_"..letter.."_1_"..rune_suffix)
	newRune:SetLevel(runeLevel1)
	newRune:SetAbilityIndex(abilitySlot)
	local newRune = hero.runeUnit2:AddAbility(internalName.."_rune_"..letter.."_2_"..rune_suffix)
	newRune:SetLevel(runeLevel2)
	newRune:SetAbilityIndex(abilitySlot)
	local newRune = hero.runeUnit3:AddAbility(internalName.."_rune_"..letter.."_3_"..rune_suffix)
	newRune:SetLevel(runeLevel3)
	newRune:SetAbilityIndex(abilitySlot)
	local newRune = hero.runeUnit4:AddAbility(internalName.."_rune_"..letter.."_4_"..rune_suffix)
	newRune:SetLevel(runeLevel4)
	newRune:SetAbilityIndex(abilitySlot)
end

function Runes:EasyRevertArcanaSkills(hero, abilityIndex, origAbility, arcanaAbility, internalName, rune_suffix)
	local existingAbility = hero:FindAbilityByName(arcanaAbility)
	local abilityLevel = existingAbility:GetLevel()
	local abilitySlot = abilityIndex
	if abilitySlot == DOTA_R_SLOT then
		abilitySlot = 3
	end
	local runeLevel1 = hero.runeUnit:GetAbilityByIndex(abilitySlot):GetLevel()
	local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(abilitySlot):GetLevel()
	local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(abilitySlot):GetLevel()
	local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(abilitySlot):GetLevel()
	local modifiers = hero:FindAllModifiers()
	for _, modifier in pairs(modifiers) do
		if modifier:GetAbility() == existingAbility and not WallPhysics:DoesTableHaveValue(keep_modifiers, modifier:GetName()) then
			hero:RemoveModifierByName(modifier:GetName())
		end
	end
	hero:RemoveAbility(arcanaAbility)
	local newAbility = hero:AddAbility(origAbility)
	newAbility:SetLevel(abilityLevel)
	newAbility:SetAbilityIndex(abilityIndex)

	local letter = "q"
	if abilitySlot == 1 then
		letter = "w"
	elseif abilitySlot == 2 then
		letter = "e"
	elseif abilitySlot == 3 then
		letter = "r"
	end

	hero.runeUnit:RemoveAbility(internalName.."_rune_"..letter.."_1_"..rune_suffix)
	hero.runeUnit2:RemoveAbility(internalName.."_rune_"..letter.."_2_"..rune_suffix)
	hero.runeUnit3:RemoveAbility(internalName.."_rune_"..letter.."_3_"..rune_suffix)
	hero.runeUnit4:RemoveAbility(internalName.."_rune_"..letter.."_4_"..rune_suffix)

	local newRune = hero.runeUnit:AddAbility(internalName.."_rune_"..letter.."_1")
	newRune:SetLevel(runeLevel1)
	newRune:SetAbilityIndex(abilitySlot)
	local newRune = hero.runeUnit2:AddAbility(internalName.."_rune_"..letter.."_2")
	newRune:SetLevel(runeLevel2)
	newRune:SetAbilityIndex(abilitySlot)
	local newRune = hero.runeUnit3:AddAbility(internalName.."_rune_"..letter.."_3")
	newRune:SetLevel(runeLevel3)
	newRune:SetAbilityIndex(abilitySlot)
	local newRune = hero.runeUnit4:AddAbility(internalName.."_rune_"..letter.."_4")
	newRune:SetLevel(runeLevel4)
	newRune:SetAbilityIndex(abilitySlot)
end

function Runes:UnequipArcana(hero, index)
	if hero:HasModifier("modifier_respawned_equip") then
		return false
	end
	if hero:GetUnitName() == "npc_dota_hero_dragon_knight" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_Q_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			hero:RemoveAbility("flamewaker_arcana_ability")
			local newAbility = hero:AddAbility("seismic_flare")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(0)

			hero.runeUnit:RemoveAbility("flamewaker_rune_q_1_arcana1")
			hero.runeUnit2:RemoveAbility("flamewaker_rune_q_2_arcana1")
			hero.runeUnit3:RemoveAbility("flamewaker_rune_q_3_arcana1")
			hero.runeUnit4:RemoveAbility("flamewaker_rune_q_4_arcana1")

			local newRune = hero.runeUnit:AddAbility("flamewaker_rune_q_1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit2:AddAbility("flamewaker_rune_q_2")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit3:AddAbility("flamewaker_rune_q_3")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit4:AddAbility("flamewaker_rune_q_4")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(0)
			hero:RemoveModifierByName("modifier_flamewaker_arcana_passive")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_flamewaker_arcana2_passive")
			Runes:EasyRevertArcanaSkills(hero, 1, "second_heartbeat", "flamewaker_dragonflame", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_juggernaut" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_Q_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
			hero:RemoveAbility("seinaru_blade_dash")
			local newAbility = hero:AddAbility("seinaru_konokaze")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(0)

			hero.runeUnit:RemoveAbility("seinaru_rune_q_1_arcana1")
			hero.runeUnit2:RemoveAbility("seinaru_rune_q_2_arcana1")
			hero.runeUnit3:RemoveAbility("seinaru_rune_q_3_arcana1")
			hero.runeUnit4:RemoveAbility("seinaru_rune_q_4_arcana1")

			local newRune = hero.runeUnit:AddAbility("seinaru_rune_q_1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit2:AddAbility("seinaru_rune_q_2")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit3:AddAbility("seinaru_rune_q_3")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(0)
			local newRune = hero.runeUnit4:AddAbility("seinaru_rune_q_4")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(0)
			hero:RemoveModifierByName("modifier_seinaru_arcana_passive")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 2, "seinaru_odachi_leap", "seinaru_sunstrider", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifier_sunstrider_passive_think")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_leshrac" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_R_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_R_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			hero:RemoveAbility("bahamut_arcana_ulti")
			local newAbility = hero:AddAbility("charge_of_light")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(DOTA_R_SLOT)

			hero.runeUnit:RemoveAbility("bahamut_rune_r_1_arcana1")
			hero.runeUnit2:RemoveAbility("bahamut_rune_r_2_arcana1")
			hero.runeUnit3:RemoveAbility("bahamut_rune_r_3_arcana1")
			hero.runeUnit4:RemoveAbility("bahamut_rune_r_4_arcana1")

			local newRune = hero.runeUnit:AddAbility("bahamut_rune_r_1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit2:AddAbility("bahamut_rune_r_2")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit3:AddAbility("bahamut_rune_r_3")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit4:AddAbility("bahamut_rune_r_4")
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

			hero.runeUnit:RemoveAbility("astral_rune_q_1_arcana1")
			hero.runeUnit2:RemoveAbility("astral_rune_q_2_arcana1")
			hero.runeUnit3:RemoveAbility("astral_rune_q_3_arcana1")
			hero.runeUnit4:RemoveAbility("astral_rune_q_4_arcana1")

			local newRune = hero.runeUnit:AddAbility("astral_rune_q_1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("astral_rune_q_2")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("astral_rune_q_3")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("astral_rune_q_4")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)

			hero:RemoveModifierByName("modifier_astral_arcana_passive")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 1, "split_shot", "shot_of_apollo", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "ranger_aoe_explosion", "crystal_arrow", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
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

			hero.runeUnit:RemoveAbility("duskbringer_rune_w_1_arcana1")
			hero.runeUnit2:RemoveAbility("duskbringer_rune_w_2_arcana1")
			hero.runeUnit3:RemoveAbility("duskbringer_rune_w_3_arcana1")
			hero.runeUnit4:RemoveAbility("duskbringer_rune_w_4_arcana1")

			local newRune = hero.runeUnit:AddAbility("duskbringer_rune_w_1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("duskbringer_rune_w_2")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("duskbringer_rune_w_3")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("duskbringer_rune_w_4")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(abilityIndex)
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_terrorize_passive")
			hero:RemoveModifierByName("modifier_terrorize_thinking")
			hero:RemoveModifierByName("modifier_terrorize_animation")
			hero:RemoveModifierByName("modifier_name_after_terrorize_falling")
			Runes:EasyRevertArcanaSkills(hero, 0, "whirling_flail", "duskbringer_arcana_terrorize", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_invoker" then
		if index == 1 then
			local origAbility = hero:GetAbilityByIndex(DOTA_R_SLOT)
			local abilityLevel = hero:GetAbilityByIndex(DOTA_R_SLOT):GetLevel()
			local runeLevel1 = hero.runeUnit:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel2 = hero.runeUnit2:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel3 = hero.runeUnit3:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			local runeLevel4 = hero.runeUnit4:GetAbilityByIndex(DOTA_D_SLOT):GetLevel()
			hero:RemoveAbility("conjuror_elemental_deity")
			local newAbility = hero:AddAbility("call_of_elements")
			newAbility:SetLevel(abilityLevel)
			newAbility:SetAbilityIndex(DOTA_R_SLOT)

			hero.runeUnit:RemoveAbility("conjuror_rune_r_1_arcana1")
			hero.runeUnit2:RemoveAbility("conjuror_rune_r_2_arcana1")
			hero.runeUnit3:RemoveAbility("conjuror_rune_r_3_arcana1")
			hero.runeUnit4:RemoveAbility("conjuror_rune_r_4_arcana1")

			local newRune = hero.runeUnit:AddAbility("conjuror_rune_r_1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit2:AddAbility("conjuror_rune_r_2")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit3:AddAbility("conjuror_rune_r_3")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(3)
			local newRune = hero.runeUnit4:AddAbility("conjuror_rune_r_4")
			newRune:SetLevel(runeLevel4)
			newRune:SetAbilityIndex(3)

			if hero.deity then
				hero.deity:ForceKill(false)
			end
		elseif index == 2 then
			if hero.fireAspect then
				if IsValidEntity(hero.fireAspect) then
					hero.forceFireReset = true
					hero.fireAspect:SetHealth(10)
					hero.fireAspect:ForceKill(true)
				end
			end
			hero:RemoveModifierByName("modifier_deity_attack_pct_w1")
			hero:RemoveModifierByName("modifier_w_4_agi_increase")
			hero:RemoveModifierByName("modifier_w_4_int_increase")
			hero:RemoveModifierByName("modifier_w_4_str_decrease")
			if hero:HasAbility("fire_arcana_ability") then
				hero:RemoveAbility("fire_arcana_ability")
			end
			Runes:EasyRevertArcanaSkills(hero, 1, "summon_fire_aspect", "summon_fire_deity", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			if hero.earthAspect then
				if IsValidEntity(hero.earthAspect) then
					hero.earthAspectResummonForbidden = true
					hero.forceFireReset = true
					hero.earthAspect:SetHealth(10)
					hero.earthAspect:ForceKill(true)
				end
			end
			hero:RemoveModifierByName("modifier_earth_deity_q_2")
			if hero:HasAbility("arcana_earth_shock") then
				hero:RemoveAbility("arcana_earth_shock")
			end
			Runes:EasyRevertArcanaSkills(hero, 0, "summon_earth_aspect", "summon_earth_deity", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
		elseif index == 4 then
			if hero.shadowAspect then
				if IsValidEntity(hero.shadowAspect) then
					hero.forceShadowReset = true
					hero.shadowAspect:SetHealth(10)
					hero.shadowAspect:ForceKill(true)
				end
			end
			if hero:HasAbility("dark_horizon") then
				hero:RemoveAbility("dark_horizon")
			end
			hero:RemoveModifierByName("shadow_deity_passive")
			hero:RemoveModifierByName("shadow_deity_agility_from_gear")
			Runes:EasyRevertArcanaSkills(hero, 2, "summon_shadow_aspect", "summon_shadow_deity", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana4")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_templar_assassin" then
		if index == 1 then
			hero.w_4_arcana_level = 0
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

			hero.runeUnit:RemoveAbility("trapper_rune_w_1_arcana1")
			hero.runeUnit2:RemoveAbility("trapper_rune_w_2_arcana1")
			hero.runeUnit3:RemoveAbility("trapper_rune_w_3_arcana1")
			hero.runeUnit4:RemoveAbility("trapper_rune_w_4_arcana1")

			local newRune = hero.runeUnit:AddAbility("trapper_rune_w_1")
			newRune:SetLevel(runeLevel1)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit2:AddAbility("trapper_rune_w_2")
			newRune:SetLevel(runeLevel2)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit3:AddAbility("trapper_rune_w_3")
			newRune:SetLevel(runeLevel3)
			newRune:SetAbilityIndex(abilityIndex)
			local newRune = hero.runeUnit4:AddAbility("trapper_rune_w_4")
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
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "spirit_warrior_ancient_vigor", "spirit_warrior_ancient_rain", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
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
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "mountain_protector_aeon_fracture", "mountain_protector_hailstorm", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		elseif index == 3 then
			hero:RemoveModifierByName("modifier_rockfall_passive")
			local abilityCheck = hero:GetAbilityByIndex(DOTA_E_SLOT)
			if abilityCheck:GetAbilityName() == "mountain_protector_volcanic_glissade" then
				CustomAbilities:AddAndOrSwapSkill(hero, "mountain_protector_volcanic_glissade", "mountain_protector_rockfall", 2)
			end
			if hero:HasAbility("mountain_protector_volcanic_glissade") then
				hero:RemoveAbility("mountain_protector_volcanic_glissade")
			end
			hero:RemoveModifierByName("modifier_mountain_rune_e_4_effect")
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
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "snake_trap", "venom_reaper_slice", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 0, "gale_nova", "venomort_frostvenom_grasp", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_night_stalker" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "chernobog_4_r", "chernobog_demon_morph", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			--print("HERE?????????")
			if hero:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_flight" then
				Runes:EasyRevertArcanaSkills(hero, 2, "chernobog_3_e", "chernobog_demon_flight", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			elseif hero:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_walk" then
				Runes:EasyRevertArcanaSkills(hero, 2, "chernobog_3_e", "chernobog_demon_walk", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
				hero:RemoveAbility("chernobog_demon_flight")
			elseif hero:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_warp" then
				Runes:EasyRevertArcanaSkills(hero, 2, "chernobog_3_e", "chernobog_demon_warp", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
				hero:RemoveAbility("chernobog_demon_flight")
			end
			hero:RemoveModifierByName("modifier_demon_warp_freecast")
			hero:RemoveModifierByName("modifier_demon_flight_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_phantom_assassin" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_voltex_arcana1_passive")
			Runes:EasyRevertArcanaSkills(hero, 2, "voltex_azure_leap", "voltex_lightning_dash", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, 0, "voltex_overcharge", "voltex_magnet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_omniknight" then
		if index == 1 then
			hero:RemoveModifierByName("modifier_paladin_arcana_glove_passive")
			Runes:EasyRevertArcanaSkills(hero, 1, "justice_overwhelming", "paladin_penance", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_paladin_arcana2_passive")
			Runes:EasyRevertArcanaSkills(hero, 2, "crusader_dash", "paladin_crusader_comet", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_crystal_maiden" then
		hero:RemoveModifierByName("modifier_ice_tornado_passive")
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "pyroblast", "sorceress_arcana_ice_tornado", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
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
			Runes:EasyRevertArcanaSkills(hero, 0, "epoch_time_binder", "epoch_arcana_ability", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_axe" then
		hero:RemoveModifierByName("modifier_axe_arcana_passive")
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "sunder", "axe_arcana_smash", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			hero:RemoveModifierByName("modifier_stonewall_passive")
			Runes:EasyRevertArcanaSkills(hero, 1, "backshock", "axe_stonewall_ability", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_beastmaster" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "elemental_overload_2", "enhchant_tomahawk", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			local abilityCheck = hero:GetAbilityByIndex(DOTA_Q_SLOT)
			local abilities_to_remove_table = {}
			local new_ability_name = ""
			if abilityCheck:GetAbilityName() == "warlord_cataclysm_shaker" then
				new_ability_name = "warlord_stone_form"
				abilities_to_remove_table = {"warlord_frost_scathe", "warlord_flame_wreck"}
			elseif abilityCheck:GetAbilityName() == "warlord_frost_scathe" then
				new_ability_name = "warlord_ice_shell"
				abilities_to_remove_table = {"warlord_cataclysm_shaker", "warlord_flame_wreck"}
			elseif abilityCheck:GetAbilityName() == "warlord_flame_wreck" then
				new_ability_name = "warlord_flame_rush"
				abilities_to_remove_table = {"warlord_frost_scathe", "warlord_cataclysm_shaker"}
			end
			for i = 1, #abilities_to_remove_table, 1 do
				local ability_name = abilities_to_remove_table[i]
				if hero:HasAbility(ability_name) then
					hero:RemoveAbility(ability_name)
				end
			end
			hero:RemoveModifierByName("modifier_ice_scathe_passive")
			hero:RemoveModifierByName("modifier_ice_scathe_q2_shield")
			Runes:EasyRevertArcanaSkills(hero, 0, abilityCheck:GetAbilityName(), new_ability_name, HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
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
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "arkimus_energy_field", "arkimus_archon_form", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_dark_seer" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, 2, "zonik_lightspeed", "zhonik_temporal_field", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "zonik_speedball", "timewarp_missles", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifier_arcana_missle_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_slardar" then
		if index == 1 then
			Runes:EasyRevertArcanaSkills(hero, 1, "hydroxis_water_blade", "hydroxis_arcana_ability_1", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		elseif index == 2 then
			Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "hydroxis_tsunami", "hydroxis_spellbound_flood_basin", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			hero:RemoveModifierByName("modifier_basin_passive")
		end
	elseif hero:GetUnitName() == "npc_dota_hero_vengefulspirit" then
		if index == 1 then
			--print(hero.sunMoon)
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
				Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "solunia_eclipse", "solunia_lunar_alpha_spark", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			else
				if hero:HasAbility("solunia_lunar_alpha_spark") then
					hero:RemoveAbility("solunia_lunar_alpha_spark")
				end
				Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "solunia_supernova", "solunia_solar_alpha_spark", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana2")
			end
		elseif index == 3 then
			hero:RemoveModifierByName("modifier_vorpal_blade_thinker_lunar")
			hero:RemoveModifierByName("modifier_vorpal_blade_thinker_solar")
			if hero.sunMoon == "moon" then
				if hero:HasAbility("solunia_solar_vorpal_blades") then
					hero:RemoveAbility("solunia_solar_vorpal_blades")
				end
				Runes:EasyRevertArcanaSkills(hero, 1, "solunia_lunarang", "solunia_lunar_vorpal_blades", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
			else
				if hero:HasAbility("solunia_lunar_vorpal_blades") then
					hero:RemoveAbility("solunia_lunar_vorpal_blades")
				end
				Runes:EasyRevertArcanaSkills(hero, 1, "solunia_solarang", "solunia_solar_vorpal_blades", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
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
				Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "draghor_shapeshift_cat", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			elseif hero:HasModifier("modifier_mark_of_the_claw") then
				Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "draghor_shapeshift_bear", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			elseif hero:HasModifier("modifier_mark_of_the_talon") then
				Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "draghor_shapeshift_crow", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			else
				Runes:EasyRevertArcanaSkills(hero, DOTA_R_SLOT, "draghor_shapeshift_cat", "draghor_shapeshift_year_beast", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
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
	elseif hero:GetUnitName() == "npc_dota_hero_arc_warden" then
		if index == 1 then
			local abilityCheck = hero:GetAbilityByIndex(DOTA_W_SLOT)
			if abilityCheck:GetAbilityName() ~= "jex_base_cannon_fire" then
				CustomAbilities:AddAndOrSwapSkill(hero, abilityCheck:GetAbilityName(), "jex_base_cannon_fire", 1)
			end
			local abilityCheck = hero:GetAbilityByIndex(DOTA_Q_SLOT)
			if abilityCheck:GetAbilityName() ~= "jex_base_cannon_nature" then
				CustomAbilities:AddAndOrSwapSkill(hero, abilityCheck:GetAbilityName(), "jex_base_cannon_nature", 0)
			end
			local abilityCheck = hero:GetAbilityByIndex(DOTA_E_SLOT)
			if abilityCheck:GetAbilityName() ~= "jex_base_cannon_cosmic" then
				CustomAbilities:AddAndOrSwapSkill(hero, abilityCheck:GetAbilityName(), "jex_base_cannon_cosmic", 2)
			end
			if hero:HasAbility("jex_fire_cosmic_w") then
				if hero:HasModifier("modifier_jex_orbital_flame_effect") then
					local fire_cosmic_w = hero:FindAbilityByName("jex_fire_cosmic_w")
					for i = 1, #fire_cosmic_w.flameTable, 1 do
						if fire_cosmic_w.flameTable[i]:HasModifier("modifier_orbital_flame_thinker") then
							fire_cosmic_w.flameTable[i]:RemoveModifierByName("modifier_orbital_flame_thinker")
						end
					end
					hero:RemoveModifierByName("modifier_jex_orbital_flame_effect")
				end
			end


			local abilities_to_remove_table = {"jex_fire_fire_q", "jex_fire_cosmic_q", "jex_nature_fire_q", "jex_fire_fire_w", "jex_fire_cosmic_w", "jex_nature_fire_w", "jex_fire_fire_e", "jex_fire_cosmic_e", "jex_nature_fire_e"}
			for i = 1, #abilities_to_remove_table, 1 do
				local ability_name = abilities_to_remove_table[i]
				if hero:HasAbility(ability_name) then
					hero:RemoveAbility(ability_name)
				end
			end

			Runes:EasyRevertArcanaSkills(hero, 1, "jex_base_cannon_lightning", "jex_base_cannon_fire", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
			local onibi = hero.onibi
			local onibi_ability_check1 = onibi:GetAbilityByIndex(DOTA_D_SLOT)
			CustomAbilities:AddAndOrSwapSkill(onibi, onibi_ability_check1:GetAbilityName(), "onibi_nature_1", 3)
			local onibi_ability_check2 = onibi:GetAbilityByIndex(DOTA_F_SLOT)
			CustomAbilities:AddAndOrSwapSkill(onibi, onibi_ability_check2:GetAbilityName(), "onibi_nature_2", 4)
			onibi.stats_table["arcanas"]["fire"] = 0
			require('heroes/arc_warden/abilities/onibi')

			calculate_onibi_element_levels(onibi)
		end
	elseif hero:GetUnitName() == "npc_dota_hero_slark" then
		if index == 1 then
			local abilityCheck = hero:GetAbilityByIndex(DOTA_E_SLOT)
			if abilityCheck:GetAbilityName() ~= "slipfinn_bog_roller" then
				CustomAbilities:AddAndOrSwapSkill(hero, abilityCheck:GetAbilityName(), "slipfinn_bog_roller", 2)
			end
			hero:RemoveModifierByName("modifier_bog_roller_passive")
			hero:RemoveModifierByName("modifier_slipfinn_bog_roller")
			Runes:EasyRevertArcanaSkills(hero, 2, "slipfinn_shadow_rush", "slipfinn_bog_roller", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana1")
		end
	end
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "ability_tree_upgrade", {playerId = hero:GetPlayerOwnerID()})
end

local runesUpdateCounter = 0
function Runes:OnRuneCountUpdate(unit, letter, tier)
	tier = tonumber(tier)
	local newCount = unit:GetRuneValue(letter, tier)
	local bigLetter = letter:upper()

	local letterAndTier = letter .. tier .. '_level'


	unit[letterAndTier] = newCount

	local playerId = unit:GetPlayerOwnerID()
	CustomNetTables:SetTableValue("hero_values", playerId .. '_rune_' .. letterAndTier, {count = newCount})
	CustomNetTables:SetTableValue("hero_values", playerId .. '_last_set_rune', {
		letterAndTier = letterAndTier,
		time = runesUpdateCounter
	})
	runesUpdateCounter = runesUpdateCounter + 1

	Util.Modifier:SimpleEvent(unit, 'OnRuneCountUpdate', { MODIFIER_SPECIAL_TYPE_RUNE }, {
		letter = letter,
		tier = tier,
        count = newCount,
	}, nil)

	Util.Modifier:SimpleEvent(unit, 'OnRune'.. bigLetter .. tier .. 'CountUpdate', { MODIFIER_SPECIAL_TYPE_RUNE }, {
		count = newCount,
	}, nil)
end
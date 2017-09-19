if HerosCustom == nil then
  HerosCustom = class({})
end

function HerosCustom:GetInternalHeroName(heroName)
	if heroName == "npc_dota_hero_dragon_knight" then
		return "flamewaker"
	elseif heroName == "npc_dota_hero_phantom_assassin" then
		return "voltex"
	elseif heroName == "npc_dota_hero_necrolyte" then
		return "venomort"
	elseif heroName == "npc_dota_hero_axe" then
		return "axe"
	elseif heroName == "npc_dota_hero_drow_ranger" then
		return "astral"
	elseif heroName == "npc_dota_hero_obsidian_destroyer" then
		return "epoch"
	elseif heroName == "npc_dota_hero_omniknight" then
		return "paladin"
	elseif heroName == "npc_dota_hero_crystal_maiden" then
		return "sorceress"
	elseif heroName == "npc_dota_hero_invoker" then
		return "conjuror"
	elseif heroName == "npc_dota_hero_juggernaut" then
		return "seinaru"
	elseif heroName == "npc_dota_hero_beastmaster" then
		return "warlord"
	elseif heroName == "npc_dota_hero_leshrac" then
		return "bahamut"
	elseif heroName == "npc_dota_hero_spirit_breaker" then
		return "duskbringer"
	elseif heroName == "npc_dota_hero_zuus" then
		return "auriun"
	elseif heroName == "npc_dota_hero_templar_assassin" then
		return "trapper"
	elseif heroName == "npc_dota_hero_huskar" then
		return "spirit_warrior"
	elseif heroName == "npc_dota_hero_legion_commander" then
		return "mountain_protector"
	elseif heroName == "npc_dota_hero_night_stalker" then
		return "chernobog"
	elseif heroName == "npc_dota_hero_vengefulspirit" then
		return "solunia"
	elseif heroName == "npc_dota_hero_slardar" then
		return "hydroxis"
	elseif heroName == "npc_dota_hero_visage" then
		return "ekkan"
	elseif heroName == "npc_dota_hero_dark_seer" then
		return "zonik"
	elseif heroName == "npc_dota_hero_antimage" then
		return "arkimus"
	elseif heroName == "npc_dota_hero_monkey_king" then
		return "djanghor"
	end
end

function HerosCustom:GetInternalHeroNameMain(heroName)
	if heroName == "npc_dota_hero_dragon_knight" then
		return "flamewaker"
	elseif heroName == "npc_dota_hero_phantom_assassin" then
		return "voltex"
	elseif heroName == "npc_dota_hero_necrolyte" then
		return "venomort"
	elseif heroName == "npc_dota_hero_axe" then
		return "axe"
	elseif heroName == "npc_dota_hero_drow_ranger" then
		return "astral"
	elseif heroName == "npc_dota_hero_obsidian_destroyer" then
		return "epoch"
	elseif heroName == "npc_dota_hero_omniknight" then
		return "paladin"
	elseif heroName == "npc_dota_hero_crystal_maiden" then
		return "sorceress"
	elseif heroName == "npc_dota_hero_invoker" then
		return "conjuror"
	elseif heroName == "npc_dota_hero_juggernaut" then
		return "monk"
	elseif heroName == "npc_dota_hero_beastmaster" then
		return "warlord"
	elseif heroName == "npc_dota_hero_leshrac" then
		return "bahamut"
	elseif heroName == "npc_dota_hero_spirit_breaker" then
		return "duskbringer"
	elseif heroName == "npc_dota_hero_zuus" then
		return "auriun"
	elseif heroName == "npc_dota_hero_templar_assassin" then
		return "trapper"
	elseif heroName == "npc_dota_hero_huskar" then
		return "spirit_warrior"
	elseif heroName == "npc_dota_hero_legion_commander" then
		return "mountain_protector"	
	elseif heroName == "npc_dota_hero_night_stalker" then
		return "chernobog"	
	elseif heroName == "npc_dota_hero_vengefulspirit" then
		return "solunia"
	elseif heroName == "npc_dota_hero_slardar" then
		return "hydroxis"
	elseif heroName == "npc_dota_hero_visage" then
		return "ekkan"
	elseif heroName == "npc_dota_hero_dark_seer" then
		return "zonik"
	elseif heroName == "npc_dota_hero_antimage" then
		return "arkimus"
	elseif heroName == "npc_dota_hero_monkey_king" then
		return "djanghor"
	end
end

function HerosCustom:ConvertRPCNameToStringHeroName(RPCName)
	local name = "tooltip_neutral"
	if RPCName == "flamewaker" then
		name = "npc_dota_hero_dragon_knight"
	elseif RPCName == "voltex" then
		name = "npc_dota_hero_phantom_assassin"
	elseif RPCName == "venomort" then
		name = "npc_dota_hero_necrolyte"
	elseif RPCName == "axe" then
		name = "npc_dota_hero_axe"
	elseif RPCName == "astral" then
		name = "npc_dota_hero_drow_ranger"
	elseif RPCName == "epoch" then
		name = "npc_dota_hero_obsidian_destroyer"
	elseif RPCName == "paladin" then
		name = "npc_dota_hero_omniknight"
	elseif RPCName == "sorceress" then
		name = "npc_dota_hero_crystal_maiden"
	elseif RPCName == "conjuror" then
		name = "npc_dota_hero_invoker"
	elseif RPCName == "monk" then
		name = "npc_dota_hero_juggernaut"
	elseif RPCName == "warlord" then
		name = "npc_dota_hero_beastmaster"
	elseif RPCName == "bahamut" then
		name = "npc_dota_hero_leshrac"
	elseif RPCName == "duskbringer" then
		name = "npc_dota_hero_spirit_breaker"
	elseif RPCName == "auriun" then
		name = "npc_dota_hero_zuus"
	elseif RPCName == "trapper" then
		name = "npc_dota_hero_templar_assassin"
	elseif RPCName == "spirit_warrior" then
		name = "npc_dota_hero_huskar"
	elseif RPCName == "mountain_protector" then
		name = "npc_dota_hero_legion_commander"
	elseif RPCName == "chernobog" then
		name = "npc_dota_hero_night_stalker"
	elseif RPCName == "solunia" then
		name = "npc_dota_hero_vengefulspirit"
	elseif RPCName == "hydroxis" then
		name = "npc_dota_hero_slardar"
	elseif RPCName == "ekkan" then
		name = "npc_dota_hero_visage"
	elseif RPCName == "zonik" then
		name = "npc_dota_hero_dark_seer"
	elseif RPCName == "arkimus" then
		name = "npc_dota_hero_antimage"
	elseif RPCName == "djanghor" then
		name = "npc_dota_hero_monkey_king"
	end
	return name
end

function HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(RPCName)
	local name = "tooltip_neutral"
	if RPCName == "flamewaker" then
		name = "npc_dota_hero_dragon_knight"
	elseif RPCName == "voltex" then
		name = "npc_dota_hero_phantom_assassin"
	elseif RPCName == "venomort" then
		name = "npc_dota_hero_necrolyte"
	elseif RPCName == "axe" then
		name = "npc_dota_hero_axe"
	elseif RPCName == "astral" then
		name = "npc_dota_hero_drow_ranger"
	elseif RPCName == "epoch" then
		name = "npc_dota_hero_obsidian_destroyer"
	elseif RPCName == "paladin" then
		name = "npc_dota_hero_omniknight"
	elseif RPCName == "sorceress" then
		name = "npc_dota_hero_crystal_maiden"
	elseif RPCName == "conjuror" then
		name = "npc_dota_hero_invoker"
	elseif RPCName == "seinaru" then
		name = "npc_dota_hero_juggernaut"
	elseif RPCName == "warlord" then
		name = "npc_dota_hero_beastmaster"
	elseif RPCName == "bahamut" then
		name = "npc_dota_hero_leshrac"
	elseif RPCName == "duskbringer" then
		name = "npc_dota_hero_spirit_breaker"
	elseif RPCName == "auriun" then
		name = "npc_dota_hero_zuus"
	elseif RPCName == "trapper" then
		name = "npc_dota_hero_templar_assassin"
	elseif RPCName == "spirit_warrior" then
		name = "npc_dota_hero_huskar"
	elseif RPCName == "mountain_protector" then
		name = "npc_dota_hero_legion_commander"
	elseif RPCName == "chernobog" then
		name = "npc_dota_hero_night_stalker"
	elseif RPCName == "solunia" then
		name = "npc_dota_hero_vengefulspirit"
	elseif RPCName == "hydroxis" then
		name = "npc_dota_hero_slardar"
	elseif RPCName == "ekkan" then
		name = "npc_dota_hero_visage"
	elseif RPCName == "zonik" then
		name = "npc_dota_hero_dark_seer"
	elseif RPCName == "arkimus" then
		name = "npc_dota_hero_antimage"
	elseif RPCName == "djanghor" then
		name = "npc_dota_hero_monkey_king"
	end
	return name
end

function HerosCustom:GetHeroIndex(heroName)
	if heroName == "npc_dota_hero_dragon_knight" then
		return 1
	elseif heroName == "npc_dota_hero_phantom_assassin" then
		return 2
	elseif heroName == "npc_dota_hero_necrolyte" then
		return 3
	elseif heroName == "npc_dota_hero_axe" then
		return 4
	elseif heroName == "npc_dota_hero_drow_ranger" then
		return 5
	elseif heroName == "npc_dota_hero_obsidian_destroyer" then
		return 6
	elseif heroName == "npc_dota_hero_omniknight" then
		return 7
	elseif heroName == "npc_dota_hero_crystal_maiden" then
		return 8
	elseif heroName == "npc_dota_hero_invoker" then
		return 9
	elseif heroName == "npc_dota_hero_juggernaut" then
		return 10
	elseif heroName == "npc_dota_hero_beastmaster" then
		return 11
	elseif heroName == "npc_dota_hero_leshrac" then
		return 12
	elseif heroName == "npc_dota_hero_spirit_breaker" then
		return 13
	elseif heroName == "npc_dota_hero_zuus" then
		return 14
	elseif heroName == "npc_dota_hero_templar_assassin" then
		return 15
	elseif heroName == "npc_dota_hero_huskar" then
		return 16
	elseif heroName == "npc_dota_hero_legion_commander" then
		return 17
	elseif heroName == "npc_dota_hero_night_stalker" then
		return 18
	elseif heroName == "npc_dota_hero_vengefulspirit" then
		return 19
	elseif heroName == "npc_dota_hero_slardar" then
		return 20
	elseif heroName == "npc_dota_hero_visage" then
		return 21
	elseif heroName == "npc_dota_hero_dark_seer" then
		return 22
	elseif heroName == "npc_dota_hero_antimage" then
		return 23
	elseif heroName == "npc_dota_hero_monkey_king" then
		return 24
	end
end

function HerosCustom:GetHeroNameTable()
	return {"neutral", "flamewaker", "voltex", "venomort", "axe", "astral", "epoch", "paladin", "sorceress", "conjuror", "monk", "warlord", "bahamut", "duskbringer", "auriun", "trapper", "spirit_warrior", "mountain_protector", "chernobog", "solunia", "hydroxis", "ekkan", "zonik", "arkimus", "djanghor"}
end

function HerosCustom:GetInternalNameTable()
	return {"flamewaker", "voltex", "venomort", "axe", "astral", "epoch", "paladin", "sorceress", "conjuror", "seinaru", "warlord", "bahamut", "duskbringer", "auriun", "trapper", "spirit_warrior", "mountain_protector", "chernobog", "solunia", "hydroxis", "ekkan", "zonik", "arkimus", "djanghor"}
end

function HerosCustom:GetAvailableHerosTable()
	return {"npc_dota_hero_dragon_knight", "npc_dota_hero_phantom_assassin", "npc_dota_hero_necrolyte", "npc_dota_hero_axe", "npc_dota_hero_drow_ranger", "npc_dota_hero_obsidian_destroyer", "npc_dota_hero_omniknight", "npc_dota_hero_crystal_maiden", "npc_dota_hero_invoker", "npc_dota_hero_juggernaut", "npc_dota_hero_beastmaster", "npc_dota_hero_leshrac", "npc_dota_hero_spirit_breaker", "npc_dota_hero_zuus", "npc_dota_hero_templar_assassin", "npc_dota_hero_huskar", "npc_dota_hero_legion_commander", "npc_dota_hero_night_stalker", "npc_dota_hero_vengefulspirit", "npc_dota_hero_slardar", "npc_dota_hero_visage", "npc_dota_hero_dark_seer", "npc_dota_hero_antimage", "npc_dota_hero_monkey_king"}
end

function HerosCustom:GetAvailableRunes(heroName)
	local runeTable = {}
	local baseValueTable = {}
	local propensityTable = {}
	local colorTable = {}
	local tooltipTable = {}
	if heroName == "npc_dota_hero_dragon_knight" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 9)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_phantom_assassin" then

		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 11)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_necrolyte" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_axe" then
		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 11)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_drow_ranger" then
		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 18)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 16)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "critical_strike")
		table.insert(baseValueTable, 80)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "#item_critical_strike")
		table.insert(colorTable, "#CC3D3D")
	elseif heroName == "npc_dota_hero_obsidian_destroyer" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 16)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

	elseif heroName == "npc_dota_hero_omniknight" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 16)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 11)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 20)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

	elseif heroName == "npc_dota_hero_crystal_maiden" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 18)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 2)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 18)
		table.insert(propensityTable, -2)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 16)
		table.insert(propensityTable, -2)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, -2)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_invoker" then

		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 9)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 16)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 11)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 9)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "attack_damage")
		table.insert(baseValueTable, 2100)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "#item_bonus_attack_damage")
		table.insert(colorTable, "#343EC9")
	elseif heroName == "npc_dota_hero_juggernaut" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)		
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 9)
		table.insert(propensityTable, 0)	
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 9)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

	elseif heroName == "npc_dota_hero_beastmaster" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 16)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		-- table.insert(runeTable, "rune_c_d")
		-- table.insert(baseValueTable, 14)
		-- table.insert(propensityTable, 0)
		-- table.insert(tooltipTable, "rune")
		-- table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "splash_damage")
		table.insert(baseValueTable, 20)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "#item_splash_damage")
		table.insert(colorTable, "#CC3D3D")
	elseif heroName == "npc_dota_hero_leshrac" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)	
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, 1)	
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, -1)		
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, -1)	
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)	
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 13)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_spirit_breaker" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, -2)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -2)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_zuus" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -3)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 14)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 7)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_templar_assassin" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 7)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 9)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 9)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_huskar" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 13)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_legion_commander" then
		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 9)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 15)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	elseif heroName == "npc_dota_hero_night_stalker" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 11)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
elseif heroName == "npc_dota_hero_vengefulspirit" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 12)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 6)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 2)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
elseif heroName == "npc_dota_hero_slardar" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
elseif heroName == "npc_dota_hero_visage" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
elseif heroName == "npc_dota_hero_dark_seer" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
elseif heroName == "npc_dota_hero_antimage" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
elseif heroName == "npc_dota_hero_monkey_king" then
		table.insert(runeTable, "rune_a_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_a_d")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 0)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_b_d")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_a")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, -1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_b")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_c")
		table.insert(baseValueTable, 10)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")

		table.insert(runeTable, "rune_c_d")
		table.insert(baseValueTable, 8)
		table.insert(propensityTable, 1)
		table.insert(tooltipTable, "rune")
		table.insert(colorTable, "#7DFF12")
	end
	return runeTable, baseValueTable, propensityTable, tooltipTable, colorTable
end
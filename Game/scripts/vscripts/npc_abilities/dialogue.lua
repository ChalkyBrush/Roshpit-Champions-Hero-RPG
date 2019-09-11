function DialogueThink(event)
	if Events.isTownActive then
		caster = event.caster
		if not caster.hasSpeechBubble then
			local ability = event.ability
			local position = caster:GetAbsOrigin()
			local radius = 250

			local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY
			local target_types = DOTA_UNIT_TARGET_HERO
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)

			if #units > 0 then
				if caster.dialogueName then
					if caster.dialogueName == "bearzky" then
						bearzky(caster, units)
					elseif caster.dialogueName == "merchant" then
						merchant(caster, units)
					elseif caster.dialogueName == "red_fox" then
						red_fox(caster, units)
					elseif caster.dialogueName == "beaver" then
						beaver(caster, units)
					elseif caster.dialogueName == "beer_bear" then
						beer_bear(caster, units)
					elseif caster.dialogueName == "owl" then
						owl(caster, units)
					elseif caster.dialogueName == "chest_brothers" then
						chest_brothers(caster, units)
					elseif caster.dialogueName == "rabbit" then
						rabbit(caster, units)
					elseif caster.dialogueName == "book" then
						book(caster, units)
					elseif caster.dialogueName == "treant" then
						tree(caster, units)
					elseif caster.dialogueName == "rareShop" then
						rareShop(caster, units)
					elseif caster.dialogueName == "blacksmith" then
						blacksmith(caster, units)
					elseif caster.dialogueName == "oracle" then
						oracle(caster, units)
					elseif caster.dialogueName == "curator" then
						curator(caster, units)
					elseif caster.dialogueName == "crusader" then
						crusader(caster, units)
					elseif caster.dialogueName == "glyph_enchanter" then
						glyphShop(caster, units)
					elseif caster.dialogueName == "witch_doctor" then
						witch_doctor(caster, units)
					elseif caster.dialogueName == "supplies_dealer" then
						supplies_dealer(caster, units)
					elseif caster.dialogueName == "arena_attendant" then
						StartAnimation(caster, {duration = 6, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.8})
						EmitSoundOn("Arena.FanGrunt", caster)
						basic_dialogue(caster, units, "#arena_dialogue_one", 10, 5, -10)
					elseif caster.dialogueName == "arena_fan" then
						local dialogueString = "#arena_fan_dialogue_one"
						if units[1].ChampionsLeague then
							if units[1].ChampionsLeague.rank <= 5 then
								dialogueString = "#arena_fan_dialogue_two"
							end
						end
						StartAnimation(caster, {duration = 3.0, activity = ACT_DOTA_IDLE_RARE, rate = 1.2})
						basic_dialogue(caster, units, dialogueString, 5, 0, -10)
						Timers:CreateTimer(1.8, function()
							EmitSoundOn("Arena.Fan2Grunt", caster)
						end)
					elseif caster.dialogueName == "arena_fan2" then
						StartAnimation(caster, {duration = 3.0, activity = ACT_DOTA_IDLE_RARE, rate = 1.2})
						basic_dialogue(caster, units, "#arena_fan2_dialogue_one", 5, 0, -10)
						Timers:CreateTimer(0.6, function()
							EmitSoundOn("Arena.Fan2Laugh", caster)
						end)
					elseif caster.dialogueName == "hall_of_champions_dialogue" then
						basic_dialogue(caster, units, "#hall_of_champions_dialogue", 8, 5, -10)
					elseif caster.dialogueName == "arena_challenger_20" then
						if units[1].ChampionsLeague then
							EmitSoundOn("Arena.Rekkin.Growl", caster)
							StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_3, rate = 0.85})
							if units[1].ChampionsLeague.rank >= 20 then
								basic_dialogue(caster, units, "#arena_champion_20_lower", 8, 5, -10)
							else
								basic_dialogue(caster, units, "#arena_champion_20_higher", 8, 5, -10)
							end
						end
					elseif caster.dialogueName == "arena_challenger_18" then
						if Arena.ChampionsLeague.state == 19 then
							return
						end
						if units[1].ChampionsLeague then
							if units[1].ChampionsLeague.rank >= 19 then
								basic_dialogue(caster, units, "#arena_champion_18_lower", 8, 5, -10)
							else
								basic_dialogue(caster, units, "#arena_champion_18_higher", 8, 5, -10)
							end
						end
					elseif caster.dialogueName == "arena_challenger_17" then
						-- EmitSoundOn("Arena.Rekkin.Growl", caster)
						arena_challenger_17(caster, units)
					elseif caster.dialogueName == "arena_challenger_16" then
						basic_dialogue(caster, units, "#champion_league_challenger_16_dialogue", 8, 5, -10)
					elseif caster.dialogueName == "arena_challenger_15" then
						basic_dialogue(caster, units, "#champion_league_challenger_15_dialogue", 8, 5, -10)
					elseif caster.dialogueName == "arena_challenger_13" then
						StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_OVERRIDE_ABILITY_3, rate = 0.85})
						EmitSoundOn("Arena.Challenger13.BasicRoar", caster)
					elseif caster.dialogueName == "arena_challenger_12" then
						StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_SPAWN, rate = 0.85, translate = "loadout"})
						EmitSoundOn("Arena.Challenger12.Laugh1", caster)
					elseif caster.dialogueName == "arena_challenger_11" then
						StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_OVERRIDE_ABILITY_2, rate = 0.85, translate = "loadout"})
						EmitSoundOn("Arena.Challenger11Yell", caster)
					elseif caster.dialogueName == "arena_challenger_10" then
						StartAnimation(caster, {duration = 3, activity = ACT_DOTA_VICTORY, rate = 0.85})
						EmitSoundOn("Arena.Challenger10.Growl", caster)
						if units[1].ChampionsLeague then
							if units[1].ChampionsLeague.rank >= 11 then
								basic_dialogue(caster, units, "#champion_league_challenger_10_dialogue_lower", 8, 5, -10)
							else
								basic_dialogue(caster, units, "#champion_league_challenger_10_dialogue_higher", 8, 5, -10)
							end
						end
					elseif caster.dialogueName == "arena_challenger_9" then
						StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.65})
						EmitSoundOn("Arena.Challenger9.Grunt", caster)
						if units[1].ChampionsLeague then
							if units[1].ChampionsLeague.rank >= 10 then
								basic_dialogue(caster, units, "#champion_league_challenger_9_dialogue_lower", 8, 5, -10)
							else
								basic_dialogue(caster, units, "#champion_league_challenger_9_dialogue_higher", 8, 5, -10)
							end
						end
					elseif caster.dialogueName == "arena_challenger_8" then
						StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.85})
						EmitSoundOn("Arena.Challenger8.Growl", caster)
					elseif caster.dialogueName == "arena_challenger_7" then
						StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.85})
						EmitSoundOn("Arena.Challenger7.Grunt", caster)
						basic_dialogue(caster, units, "#champion_league_challenger_7_dialogue", 8, 5, -10)
					elseif caster.dialogueName == "arena_challenger_5" then
						StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.65})
						EmitSoundOn("Arena.Challenger5.Grunt", caster)
						if units[1].ChampionsLeague then
							if units[1].ChampionsLeague.rank >= 6 then
								basic_dialogue(caster, units, "#champion_league_challenger_5_dialogue", 8, 5, -10)
							else
								basic_dialogue(caster, units, "#champion_league_challenger_5_dialogue_higher", 8, 5, -10)
							end
						else
							basic_dialogue(caster, units, "#champion_league_challenger_5_dialogue", 8, 5, -10)
						end
					elseif caster.dialogueName == "arena_challenger_4" then
						StartAnimation(caster, {duration = 3.0, activity = ACT_DOTA_TELEPORT, rate = 0.85})
						EmitSoundOn("Arena.Challenger4.Laugh", caster)
						basic_dialogue(caster, units, "#champion_league_challenger_4_dialogue", 8, 5, -10)
					elseif caster.dialogueName == "arena_challenger_3" then
						StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_5, rate = 1, translate = "qop_blink"})
						StartAnimation(caster.bro, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_5, rate = 1, translate = "am_blink"})
						EmitSoundOn("Arena.Challenger3.Tone"..RandomInt(2, 5), caster)
						local broPos = caster.bro:GetAbsOrigin()
						caster.bro:SetAbsOrigin(caster:GetAbsOrigin())
						caster:SetAbsOrigin(broPos)
						CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", caster.bro, 2.5)
						CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", caster, 2.5)
					elseif caster.dialogueName == "arena_challenger_2" then
						StartAnimation(caster, {duration = 2.4, activity = ACT_DOTA_OVERRIDE_ABILITY_3, rate = 0.85})
						EmitSoundOn("Arena.Challenger2.Roar", caster)
					elseif caster.dialogueName == "arena_challenger_1" then
						StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.65})
						if units[1].ChampionsLeague then
							if units[1].ChampionsLeague.rank == 1 then
								basic_dialogue(caster, units, "#champion_league_challenger_1_dialogue_alt", 8, 5, -10)
							else
								basic_dialogue(caster, units, "#champion_league_challenger_1_dialogue", 8, 5, -10)
							end
						end
					elseif caster.dialogueName == "gem_forger" then
						gem_forger(caster, units)
					end
				end
			end
		end
	end
end

function basic_dialogue(caster, units, dialogueName, time, xOffset, yOffset, bOverride)
	caster:DestroyAllSpeechBubbles()
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, dialogueName, time, false)
		-- caster:AddSpeechBubble(speechSlot, dialogueName, time, xOffset, yOffset)
		disableSpeech(caster, time, speechSlot)
	end
end

function arena_challenger_17(caster, units)
	if caster.animating then
		return false
	end
	caster.animating = true
	StartAnimation(caster, {duration = 2.9, activity = ACT_DOTA_VICTORY, rate = 1.0})
	basic_dialogue(caster, units, "#arena_champions_17_1", 2, 5, -10)
	Events:SoftFloat(4, 2.5, 0.1, caster)
	EmitSoundOn("Arena.Champion17.Grunt", caster)
	--print("WTF?")
	Timers:CreateTimer(3.1, function()
		--print("WTF2?")

		basic_dialogue(caster, units, "#arena_champions_17_2", 8, 5, -10)
		EmitSoundOn("Arena.Champion17.Summon", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.Champion17.SummonEffect", Events.GameMaster)
		StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
		local earthElement = CreateUnitByName("arena_league_challenger_17_earth", caster:GetAbsOrigin() + caster:GetForwardVector() * 200, true, nil, nil, DOTA_TEAM_GOODGUYS)
		local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), -2 * math.pi / 3)
		local fireElement = CreateUnitByName("arena_league_challenger_17_fire", caster:GetAbsOrigin() + rotatedFV * 200, true, nil, nil, DOTA_TEAM_GOODGUYS)
		rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 3)
		local airElement = CreateUnitByName("arena_league_challenger_17_air", caster:GetAbsOrigin() + rotatedFV * 200, true, nil, nil, DOTA_TEAM_GOODGUYS)
		fireElement:SetForwardVector(caster:GetForwardVector())
		airElement:SetForwardVector(caster:GetForwardVector())
		earthElement:SetForwardVector(caster:GetForwardVector())
		local elementTable = {fireElement, airElement, earthElement}
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split.vpcf", caster, 3)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", fireElement, 2)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", earthElement, 2)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", airElement, 2)
		Timers:CreateTimer(7, function()
			--print("WTF3?")
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.Champion17.SummonEffectEnd", Events.GameMaster)
			for i = 1, #elementTable, 1 do
				local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, elementTable[i]:GetAbsOrigin() + Vector(0, 0, 30))
				Timers:CreateTimer(2.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				UTIL_Remove(elementTable[i])
			end

		end)
		Timers:CreateTimer(10, function()
			--print("WTF4?")
			caster.animating = false
		end)
	end)
end

function bearzky(caster, units)
	local time = 5
	Quests:ShowDialogueText(units, caster, "#dialogue_bear", time, false)
end

function merchant(caster, units)
	--MERCHANT_OPEN_SOUND_TABLE = {"secretshop_secretshop_welcome_04", "secretshop_secretshop_whatyoubuying_01", "secretshop_secretshop_whatyoubuying_02"}
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		caster:AddSpeechBubble(speechSlot, "#dialogue_merchant", time, 0, 0)
		disableSpeech(caster, time, speechSlot)
	end
	for _, unit in ipairs(units) do
		local player = unit:GetPlayerOwner()
		local playerId = player:GetPlayerID()
		CustomGameEventManager:Send_ServerToPlayer(player, "OpenShop", {player = playerId})
		--EmitSoundOnClient(MERCHANT_OPEN_SOUND_TABLE[RandomInt(1, 3)], player)
	end
end

function blacksmith(caster, units)
	--MERCHANT_OPEN_SOUND_TABLE = {"secretshop_secretshop_welcome_04", "secretshop_secretshop_whatyoubuying_01", "secretshop_secretshop_whatyoubuying_02"}
	--print("call how many")
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, "#dialogue_blacksmith_three", time, false)
		disableSpeech(caster, time, speechSlot)
	end
	for _, unit in ipairs(units) do
		local player = unit:GetPlayerOwner()
		if player then
			local playerId = player:GetPlayerID()

		end
	end
end

function gem_forger(caster, units)
	--MERCHANT_OPEN_SOUND_TABLE = {"secretshop_secretshop_welcome_04", "secretshop_secretshop_whatyoubuying_01", "secretshop_secretshop_whatyoubuying_02"}
	--print("call how many")
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, "#gem_forger_fluff", time, false)
		disableSpeech(caster, time, speechSlot)
	end
	for _, unit in ipairs(units) do
		local player = unit:GetPlayerOwner()
		if player then
			local playerId = player:GetPlayerID()

		end
	end
end

function rareShop(caster, units)
	--MERCHANT_OPEN_SOUND_TABLE = {"secretshop_secretshop_welcome_04", "secretshop_secretshop_whatyoubuying_01", "secretshop_secretshop_whatyoubuying_02"}
	local time = 5
	Quests:ShowDialogueText(units, caster, "#dialogue_rare_shop", time, false)
	for _, unit in ipairs(units) do
		local player = unit:GetPlayerOwner()
		local playerId = player:GetPlayerID()
		if not unit.legendHelm then
			CustomGameEventManager:Send_ServerToPlayer(player, "OpenRareShop", {player = playerId})
		end
		--EmitSoundOnClient(MERCHANT_OPEN_SOUND_TABLE[RandomInt(1, 3)], player)
	end
end

function red_fox(caster, units)
	local time = 5
	Quests:ShowDialogueText(units, caster, "#dialogue_fox", time, false)
end

function beaver(caster, units)
	local time = 5
	local dialogue = ""
	if not Dungeons.cleared.townsiege then
		dialogue = "#dialogue_beaver"
	else
		dialogue = "#dialogue_beaver_two"
	end
	Quests:ShowDialogueText(units, caster, dialogue, time, false)
end

function beer_bear(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	Quests:ShowDialogueText(units, caster, "#dialogue_beer_bear", time, false)
end

function owl(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	Quests:ShowDialogueText(units, caster, "#dialogue_owl", time, false)
end

function chest_brothers(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	Quests:ShowDialogueText(units, caster, "#dialogue_chest_brothers", time, false)
end

function rabbit(caster)
	local time = 7
	local speechSlot = findEmptyDialogSlot()
	Quests:ShowDialogueText(units, caster, "#dialogue_rabbit", time, false)
end

function book(caster)
	local time = 8
	if caster.state == 0 then
		Quests:ShowDialogueText(units, caster, "#dialogue_book", time, false)
		disableSpeech(caster, time, speechSlot)
	elseif caster.state == 1 then
		Quests:ShowDialogueText(units, caster, "#dialogue_book_two", time, false)
		disableSpeech(caster, time, speechSlot)
	elseif caster.state == 2 then
		Quests:ShowDialogueText(units, caster, "#dialogue_book_three", time, false)
		disableSpeech(caster, time, speechSlot)
	end
end

function tree(caster, units)
	if not Dungeons.entryPoint then
		local time = 7
		local speechSlot = findEmptyDialogSlot()
		Quests:ShowDialogueText(units, caster, "#logging_camp_tree_dialogue_three", time, false)
		disableSpeech(caster, time, speechSlot)
		for _, hero in pairs(units) do
			if not hero.steelbark and hero:HasAnyAvailableInventorySpace() then
				RPCItems:RollSteelbarkPlate(hero)
				hero.steelbark = true
			end
		end

	else
		local time = 7
		local speechSlot = findEmptyDialogSlot()
		Quests:ShowDialogueText(units, caster, "#logging_camp_tree_dialogue_two", time, false)
		EmitSoundOn("treant_treant_attack_01", caster)
		disableSpeech(caster, time, speechSlot)

	end
end

function oracle(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, "#dialogue_oracle", time, true)
		disableSpeech(caster, time, speechSlot)
	end
end

function curator(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, "#curator_dialogue_1", time, true)
		disableSpeech(caster, time, speechSlot)
	end
end

function crusader(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if GameRules:GetGameTime() > 5 then
		Quests:ShowDialogueText(units, caster, "#dialogue_crusader_one", time, false)
		disableSpeech(caster, time, speechSlot)

		for _, unit in ipairs(units) do
			local player = unit:GetPlayerOwner()
			if player then
				local playerId = player:GetPlayerID()
				Quests:OpenQuests(playerId)
			end
		end
	end
end

function glyphShop(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if GameRules:GetGameTime() > 5 then
		if speechSlot < 4 then
			-- Quests:ShowDialogueText(caster, "#dialogue_glyph_shop_one", 5, 0, 0)
			Quests:ShowDialogueText(units, caster, "#dialogue_glyph_shop_one", time, true)
			-- caster:AddSpeechBubble(speechSlot, "#dialogue_glyph_shop_one", time, 0, -25)
			disableSpeech(caster, time, speechSlot)
		end
	end
end

function witch_doctor(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		if Events.SpiritRealm then
			Quests:ShowDialogueText(units, caster, "#dialogue_witch_doctor_two", time, true)
		else
			Quests:ShowDialogueText(units, caster, "#dialogue_witch_doctor", time, true)
		end
		disableSpeech(caster, time, speechSlot)
	end
	if caster:HasModifier("modifier_tanari_combining_elements") then
		return false
	end

end

function supplies_dealer(caster, units)
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, "#dialogue_supplies_dealer", time, true)
		disableSpeech(caster, time, speechSlot)
	end
	-- if #units > 0 then
	-- EmitSoundOn("NPC.SuppliesDealerGreeting", caster)
	-- end
end

function disableSpeech(caster, time, speechSlot)
	caster.hasSpeechBubble = true
	Timers:CreateTimer(time, function()
		caster.hasSpeechBubble = false
		clearDialogSlot(speechSlot)
	end)
end

function deltaFacingVector(caster, triggeringUnit)
	local facing = (caster:GetAbsOrigin() - triggeringUnit:GetAbsOrigin()):Normalized()
	local rotationVector = facing - caster.baseFVector
	local deltaFacingVector = rotationVector / 20
	return deltaFacingVector
end

function findEmptyDialogSlot()
	if not Events.Dialog1 then
		Events.Dialog1 = true
		return 1
	elseif not Events.Dialog2 then
		Events.Dialog2 = true
		return 2
	elseif not Events.Dialog3 then
		Events.Dialog3 = true
		return 3
	end
	return 4
end

function clearDialogSlot(slot)
	if slot == 1 then
		Events.Dialog1 = false
	elseif slot == 2 then
		Events.Dialog2 = false
	elseif slot == 3 then
		Events.Dialog3 = false
	end
end

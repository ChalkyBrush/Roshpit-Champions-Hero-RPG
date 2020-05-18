function diviner_think(event)
	local caster = event.caster
	local ability = event.ability
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 3, false)
	if caster.phase == 0 then
		local searchPosition = Vector(11820, 14036, 1286)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), searchPosition, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				local player = enemy:GetPlayerOwner()
				CustomGameEventManager:Send_ServerToPlayer(player, "open_winter_castle_event", {})
			end
		end
	elseif caster.phase == 2 then
		local target_pos = Vector(11800, 13400)
		caster:MoveToPosition(target_pos)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target_pos)
		if distance < 80 or Winterblight.OverrideIntroThrow then
			caster.phase = 3
			local delay = 1
			if Winterblight.OverrideIntroThrow then
				delay = 0
			end
			Timers:CreateTimer(delay, function()
				if not Winterblight.OverrideIntroThrow then
					CustomAbilities:QuickParticleAtPoint("particles/econ/items/necrolyte/necronub_death_pulse/necrolyte_pulse_ka_explosion_flash_glow.vpcf", caster:GetAttachmentOrigin(0), 2)
					local card_prop = caster.card_prop
					caster.card_prop = nil

					local card_index = caster.selected_card + 1

					StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1})
					EmitSoundOn("Winterblight.Horus.CardThrow.VO", caster)
					EmitSoundOnLocationWithCaster(card_prop:GetAbsOrigin(), "Winterblight.Horus.Throw", caster)
					card_prop:SetAbsOrigin(Vector(11808, 13046, 2180))
					Events:smoothTranslate(card_prop, Vector(0,0,-40), 15, Vector(0,0), nil)
					Timers:CreateTimer(0.35, function()
						CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/castle_tarot_splash.vpcf", Vector(11808, 13046, 1767), 5)
						EmitSoundOnLocationWithCaster(card_prop:GetAbsOrigin(), "Winterblight.TarotCard.Dunk", caster)
						ScreenShake(Vector(11808, 13046, 1767), 800, 1, 1, 9000, 0, true)
					end)
				end
				Timers:CreateTimer(1.0, function()
					EmitSoundOn("Winterblight.Tarot.Suspense", caster)
				end)
				Timers:CreateTimer(1.7, function()
					local hand1 = Entities:FindByNameNearest("castle_tarot_hands", Vector(11659, 12968, 1800), 800)
					local hand2 = Entities:FindByNameNearest("castle_tarot_hands", Vector(11916, 12968, 1800), 800)
					Events:objectShake(hand1, 80, 8, true, false, true, "Winterblight.TarotHands.Shake", 20)
					Events:objectShake(hand2, 80, 8, true, false, true, "Winterblight.TarotHands.Shake", 20)
					EmitSoundOnLocationWithCaster(Vector(11808, 13046, 2000), "Winterblight.TarotHYPE", caster)
					ScreenShake(Vector(11808, 13046, 1767), 800, 1, 1, 9000, 0, true)
				end)

				Timers:CreateTimer(6.2, function()
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/castle_tarot_splash.vpcf", Vector(11808, 13046, 1767), 5)
					ScreenShake(Vector(11808, 13046, 1767), 800, 1, 1, 9000, 0, true)
					EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.TarotCard.PopoutDunk", caster)
					local tarot_symbol = CreateUnitByName("npc_flying_dummy_vision", Vector(11807, 13048), true, nil, nil, DOTA_TEAM_GOODGUYS)
					ability:ApplyDataDrivenModifier(caster, tarot_symbol, "modifier_tarot_symbol_floating_thinker", {})
					tarot_symbol:SetAbsOrigin(tarot_symbol:GetAbsOrigin()+Vector(0,0,280))
					tarot_symbol:SetDayTimeVisionRange(500)
					tarot_symbol:SetNightTimeVisionRange(500)
					tarot_symbol:RemoveModifierByName("dummy_unit")
					local dummy_ability = tarot_symbol:FindAbilityByName("dummy_unit")
					dummy_ability:ApplyDataDrivenModifier(tarot_symbol, tarot_symbol, "dummy_unit", {})
					tarot_symbol:SetForwardVector(Winterblight.CastleTarot["prop_angle"])
					tarot_symbol:SetModelScale(0.1)
					local model_name = "models/winterblight/tarot/"..Winterblight.CastleTarot["index"].."-"..Winterblight.CastleTarot["name"]..".vmdl"
					print(model_name)
					tarot_symbol:SetModel(model_name)
					tarot_symbol:SetOriginalModel(model_name)
					-- Events:smoothTranslate(tarot_symbol, Vector(0,0,7), 40, Vector(0, 0), nil)
					Events:smoothSizeChange(tarot_symbol, 0.1, Winterblight.CastleTarot["prop_scale"], 40)
					Timers:CreateTimer(1.3, function()
						tarot_symbol.active = true
						if Winterblight.CastleTarot["horror"] then
							-- EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.Tarot.PianoSlamHorror", Events.GameMaster)
						else
							EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.Tarot.PianoSlam", Events.GameMaster)
						end
					end)
				end)
				if Winterblight.CastleTarot["horror"] then
					Timers:CreateTimer(7.9, function()
						EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.Tarot.PianoSlamHorror", Events.GameMaster)
					end)
				end
				Timers:CreateTimer(8.2, function()
					StartAnimation(caster, {duration = 1.4, activity = ACT_DOTA_ATTACK, rate = 1})
					Quests:ShowDialogueText(MAIN_HERO_TABLE, caster, "tarot_"..Winterblight.CastleTarot["name"], 4, false)
					EmitSoundOn("Winterblight.Horus.CardThrow.VO", caster)
					-- EmitSoundOn("Winterblight.DescribeTarotHaunt", caster)

				end)
				Timers:CreateTimer(12.2, function()
					StartAnimation(caster, {duration = 1.4, activity = ACT_DOTA_ATTACK, rate = 1})
					Quests:ShowDialogueText(MAIN_HERO_TABLE, caster, "tarot_"..Winterblight.CastleTarot["name"].."_description", 5, false)
					EmitSoundOn("Winterblight.DescribeTarotHaunt", caster)
				end)
				Timers:CreateTimer(16.2, function()
					caster.phase = 4
					caster:MoveToPosition(Vector(12544, 13568))
				end)
			end)
		end
	elseif caster.phase == 4 then
		local target_pos = Vector(12544, 13568)
		caster:MoveToPosition(target_pos)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target_pos)
		if distance < 80 then
			caster.phase = 5
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-30, 0))
			Timers:CreateTimer(1.2, function()
				caster.phase = 6
			end)
		end
	elseif caster.phase == 6 then
		caster.phase = 7
		Timers:CreateTimer(0.3, function()
			EmitSoundOn("Winterblight.Horus.Exit.VO", caster)
			StartAnimation(caster, {duration = 1.4, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
		end)
		if Winterblight.CastleTarot["name"] == "temperance" then
			for i = 1, #MAIN_HERO_TABLE, 1 do
				ability:ApplyDataDrivenModifier(caster, MAIN_HERO_TABLE[i], "modifier_diviner_temperance_death_tracker", {})
			end
			Winterblight.TemperanceChest = true
		end
		Timers:CreateTimer(0.7, function()
			caster:AddNoDraw()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_diviner_invisible", {})
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", caster:GetAbsOrigin(), 3)
			EmitSoundOn("Winterblight.GraveGhostSpawn", caster)
			if Winterblight.CastleTarot["name"] ~= "fool" then
				for i = 1, #MAIN_HERO_TABLE, 1 do
					Winterblight:DropScryersStone(caster:GetAbsOrigin())
				end
			end
		end)
		Timers:CreateTimer(3, function()
			Winterblight:OpenCastleDoorByIndex(1)
			if Winterblight.CastleTarot["name"] == "hermit" then
				Winterblight:CastleLobbySpawnHermit()
			end
			Winterblight:CastleLobbySpawn1()
			if Winterblight.CastleTarot["name"] == "world" then
				Winterblight:WorldInit()
			else
				Winterblight:CastleNextRoomInit()
			end
			if Winterblight.CastleTarot["name"] == "star" then
				Winterblight:InitCastleStarQuest()
			end
			StartSoundEvent("Winterblight.HorusHYPE", caster)
		end)
		Timers:CreateTimer(6.0, function()
			EmitSoundOn("Winterblight.Horus.Laugh.VO", caster)
		end)
		Timers:CreateTimer(7.5, function()
			StopSoundEvent("Winterblight.HorusHYPE", caster)
		end)
	end

	-- ROOM 1 THINKER
	if Winterblight.CASTLE_DATA["rooms"][1]["active"] >= 1 and Winterblight.CASTLE_DATA["rooms"][1]["cleared"] == 0 then
		if not caster.graveyard then
			caster.graveyard = {0, 0, 0}
		end
		for i = 1, #caster.graveyard, 1 do
			if caster.graveyard[i] == 0 then
				local position = Vector(11775, 15918) + Vector((i-1)*769, 0)
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					caster.graveyard[i] = 1
					local dirt_mound = Entities:FindByNameNearest("CastleBurialMound", position + Vector(0,0,1600), 600)
					Events:objectShake(dirt_mound, 120, 6, true, false, true, "Winterblight.DirtMoundShake", 20)
					Timers:CreateTimer(2, function()
						Events:smoothTranslate(dirt_mound, Vector(0,0,-0.74), 160, Vector(0,0), nil)
					end)
					local ground_position = GetGroundPosition(position, Events.GameMaster)
					for mud_count = 0, 10, 1 do
						Timers:CreateTimer(mud_count*0.4, function()
							for mudx = 0, 1, 1 do
								for mudy = 0, 2, 1 do
									local mud_position = ground_position + Vector((mudx-0.5)*120, (mudy-0.5)*150, - 70)
									CustomAbilities:QuickParticleAtPoint("particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf", mud_position, 4)
								end
							end
						end)
					end
					Timers:CreateTimer(3.6, function()
						for j = -1, 1, 1 do 
							local skeleton = Winterblight:SpawnCastleRoomUnit(1, "winterblight_grave_skeleton", position + Vector(0, j*240), RandomVector(1), true, true)
							CustomAbilities:QuickParticleAtPoint("particles/neutral_fx/skeleton_spawn.vpcf", skeleton:GetAbsOrigin(), 4)
						end
					end)
				end		
			end	
		end
	end
	if Winterblight.CASTLE_DATA["rooms"][4]["active"] >= 1 and Winterblight.CASTLE_DATA["rooms"][4]["cleared"] == 0 then
		if not caster.torture_blood_scene then
			local heroes = FindUnitsInLine(caster:GetTeamNumber(), Vector(14464, 12112), Vector(16318, 12112), caster, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			if #heroes > 0 then
				caster.torture_blood_scene = true
				for i = 1, 25, 1 do
					Timers:CreateTimer(0.3*i, function()
						local position = Vector(14568, 12141) + Vector(RandomInt(0, 1500), 0)
						local ghoul = Winterblight:SpawnCastleRoomUnit(4, "winterblight_corrupted_corpse", position, RandomVector(1), false, true)
						ghoul:CrawlEnter(position, Vector(0,-1), "up", RandomInt(-500, -700), 8)	
						ghoul.crawl_end_pfx = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"	
					end)
				end
			end
		end
	end
	if Winterblight.CASTLE_DATA["rooms"][6]["active"] >= 1 then
		if not caster.lookout_chest then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), Vector(15698, 8088), nil, 160, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				caster.lookout_chest = true
				local particle = Entities:FindByNameNearest("LookoutChestLight", Vector(15698, 8088, 1200), 1000)
				EmitSoundOnLocationWithCaster(Vector(15698, 8088), "Winterblight.Lookout.HiddenChest", caster)
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/zonik/sonic_boom_fallback_mid_egset.vpcf", particle:GetAbsOrigin(), 3)
				UTIL_Remove(particle)
				Timers:CreateTimer(1, function()
					Winterblight:GeneralChestSpawn(Vector(16016, 8448), Vector(-1,-1))
				end)
			end
		end
	end
	if caster.phase >= 7 and Winterblight.CastleTarot["name"] == "hermit" then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local hero = MAIN_HERO_TABLE[i]
			if hero.bgm == "Music.Winterblight.BlackfrostCitadel" then
				local buffAdjust = 0
				if hero:HasModifier("modifier_diviner_hermit_buff") then
					buffAdjust = 700
				end
				local base_vision = hero:GetNightTimeVisionRange() - buffAdjust + hero:GetModifierStackCount("modifier_diviner_hermit_debuff", caster)
				local debuff_stacks = base_vision*(ability:GetSpecialValueFor("hermit_vision_loss_pct")*-1)/100
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_diviner_hermit_debuff", {})
				hero:SetModifierStackCount("modifier_diviner_hermit_debuff", caster, debuff_stacks)
			else
				hero:RemoveModifierByName("modifier_diviner_hermit_debuff")
				hero:RemoveModifierByName("modifier_diviner_hermit_buff")
			end
		end
	end
	-- DEVIL THINK
	if Winterblight.DevilRingData then
		for i = 1, #Winterblight.DevilRingData, 1 do
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), Winterblight.DevilRingData[i].position, nil, 110, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if not Filters:HasFlyingModifier(enemy) then
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_diviner_scryer_doom", {duration = 8})
					end
				end
			end
		end
	end
	-- MOON THINKER
	if caster.phase >= 7 and caster.moon_ghost_table and Winterblight.CastleTarot["name"] == "moon" then
		for i = 1, #caster.moon_ghost_table, 1 do
			local moon_ghost_item = caster.moon_ghost_table[i]
			if moon_ghost_item["active"] == 1 then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), moon_ghost_item["position"], nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					moon_ghost_item["active"] = 0
					Timers:CreateTimer(1, function()
							local ghost = CreateUnitByName("npc_dummy_unit", moon_ghost_item["position"], false, nil, nil, DOTA_TEAM_NEUTRALS)
							ghost:SetForwardVector(Vector(0,-1))
							ghost:SetOriginalModel("models/items/necrolyte/necro_ti9_immortal_skirt/necro_ti9_immortal_ghost.vmdl")
							ghost:SetModel("models/items/necrolyte/necro_ti9_immortal_skirt/necro_ti9_immortal_ghost.vmdl")
							ghost.target = caster.locked_target
							Events:smoothSizeChange(ghost, 0.1, 3.5, 40)
							EmitSoundOn("Winterblight.CrowSentry.HauntStart", ghost)
							local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
							ParticleManager:SetParticleControl(pfx, 0, ghost:GetAbsOrigin()+Vector(0,0,200))
							local blueFactor = RandomInt(50, 90)/100
							ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.5, blueFactor))
							ParticleManager:SetParticleControl(pfx, 2, Vector(0.2, 0.2, 0.2))
							Timers:CreateTimer(6, function()
								ParticleManager:DestroyParticle(pfx, false)
								ParticleManager:ReleaseParticleIndex(pfx)
							end)
						    ability:ApplyDataDrivenModifier(caster, ghost, "modifier_owl_sentry_ghost", {})
							Timers:CreateTimer(5, function()
								EmitSoundOn("Winterblight.CrowSentry.HauntEnd", ghost)
								Events:smoothSizeChange(ghost, 3.5, 0.01, 15)
							end)
							Timers:CreateTimer(5.5, function()
								UTIL_Remove(ghost)
							end)
					end)
					Timers:CreateTimer(8, function()
						EmitSoundOnLocationWithCaster(moon_ghost_item["position"], "Winterblight.CrowSentry.HauntSpawn", caster)
						for i = 1, 2 + GameState:GetDifficultyFactor()*2, 1 do
							local spawn_pos = moon_ghost_item["position"] + RandomVector(RandomInt(180, 600))
							local fv = ((moon_ghost_item["position"] - spawn_pos)*Vector(1,1,0)):Normalized()
							local haunter = Winterblight:SpawnCastleRoomUnit(0, "winterblight_elite_ghoul", spawn_pos, RandomVector(1), false, true)
							Dungeons:AggroUnit(haunter)
							CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", haunter:GetAbsOrigin(), 3)
							EmitSoundOn("Winterblight.GraveGhostSpawn", haunter)
						end
					end)
				end
			end
		end
	end
	-- SUN THINKER
	if Winterblight.SunFireData then
		for i = 1, #Winterblight.SunFireData, 1 do
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), Winterblight.SunFireData[i].position, nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if not Filters:HasFlyingModifier(enemy) then
						if not enemy:HasModifier("modifier_diviner_sun_immolation_effect") then
							EmitSoundOn("Winterblight.SunBurn.Activate", enemy)
						end
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_diviner_sun_immolation_effect", {duration = 3})
					end
				end
			end
		end
	end
	if caster.phase >= 7 and Winterblight.CastleTarot["name"] == "sun" and Winterblight.CASTLE_DATA["rooms"][6]["active"] >= 1 then
		if not caster.disable_sun_platform_thinker then
			if not caster.sun_platform_props then
				caster.sun_platform_props = {}
				local platform = {}
				platform["position"] = Vector(15455, 7363)
				platform["activated"] = 0
				platform["radius"] = 365
				table.insert(caster.sun_platform_props, platform)
				local platform = {}
				platform["position"] = Vector(15642, 5710)
				platform["activated"] = 0
				platform["radius"] = 550
				table.insert(caster.sun_platform_props, platform)
				local platform = {}
				platform["position"] = Vector(16000, 4206)
				platform["activated"] = 0
				platform["radius"] = 325
				table.insert(caster.sun_platform_props, platform)
			end
			local activated_platform_count = 0
			for i = 1, #caster.sun_platform_props, 1 do
				local sun_platform = caster.sun_platform_props[i]
				if sun_platform["activated"] == 0 then
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), sun_platform["position"], nil, sun_platform["radius"], DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						sun_platform["activated"] = 1
						local platform_entity = Entities:FindByNameNearest("SunPlatform", sun_platform["position"] + Vector(0,0,2000), 1500)
						local starting_color = Vector(38, 43, 52)
						local end_color = Vector(255, 181, 70)
						Events:smoothColorTransition(platform_entity, starting_color, end_color, 100)
					end
				else
					activated_platform_count = activated_platform_count + 1
				end
			end
			if activated_platform_count == 3 then
				caster.disable_sun_platform_thinker = true
				Timers:CreateTimer(5, function()
					Winterblight:CastleSunPhoenixSequence()
				end)
			end
		end
	end
	if Winterblight.CASTLE_DATA["rooms"][11]["active"] >= 1 and Winterblight.CastleTarot["name"] == "moon" then
		if not caster.moon_lift_bros then
			local heros = FindUnitsInRadius(caster:GetTeamNumber(), Vector(14712, -2720, 1800), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #heros > 0 then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				for _, hero in pairs(heros) do
					master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, hero, "modifier_diviner_moon_platform", {duration = 1.5})
				end
			end
		end
	end
end

function winterblight_castle_dungeon_master_main_thinker(event)
	local caster = event.caster
	if not caster.think_interval then
		caster.think_interval = 0
	end
	caster.think_interval = caster.think_interval + 1

	if caster.think_interval%30 == 0 then
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", Vector(14639, 12340, 1520), 3)
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", Vector(15237, 9998, 2080), 3)
	end
	if caster.think_interval == 200 then
		caster.think_interval = 0
	end
	if caster.card_prop then
		local card_position = caster:GetAttachmentOrigin(0)
		caster.card_prop:SetAbsOrigin(card_position)
	end
end

function tarot_symbol_float_think(event)
	local target = event.target
	if not target.active then
		return false
	end
	if not target.interval then
		target.interval = 0
	end
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, 3) * math.cos(2 * math.pi * target.interval / 90))
	target.interval = target.interval + 1
	-- local rotatedFV = WallPhysics:rotateVector(target:GetForwardVector(), 2 * math.pi / 90)
	-- target:SetForwardVector(rotatedFV)
	if target.interval == 90 then
		target.interval = 0
	end
end

function reincarnation_respawning_end(event)
	local caster = event.caster
	local ability = event.ability

    EmitSoundOn("Winterblight.Reincarnation.Respawn", caster)
    FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
    caster:RemoveNoDraw()
    CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/ankh_of_ancients_respawn.vpcf", caster:GetAbsOrigin(), 3)
    caster:SetHealth(caster:GetMaxHealth())
    caster:SetMana(caster:GetMaxMana())
    ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
    if caster.aggroSound then
    	EmitSoundOn(caster.aggroSound, caster)
    end
end

function reaper_swipe_init(event)
	local caster = event.caster
	local ability = event.ability
	caster:AddNewModifier(caster, ability, "modifier_truesight", {})
end

function reaper_swipe_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 3, 500, false)
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Winterblight.Reaper.Scream", caster)
	EmitSoundOn("Winterblight.Reaper.Scream2", target)
	local particleName = "particles/roshpit/winterblight/econ/items/necrolyte/necro_sullen_harvest/red_reaper.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	for i = 1, 9, 1 do
		ParticleManager:SetParticleControlEnt(pfx, i, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.damage_pct_atk_power/100) + target:GetMaxHealth()*(event.damage_pct_max_health/100)
	Timers:CreateTimer(1.2, function()
		EmitSoundOn("Winterblight.ReaperSlice.Hit", target)
		target.venomort_reaper_active = false
		Enemies:ApplyDamageToPlayer(target, caster, damage, DAMAGE_TYPE_PURE, ability)

	end)
end

function elite_ghoul_think(event)
	local caster = event.caster
	if caster:IsAlive() then
	else
		return false
	end
	if caster:IsStunned() then
		return false
	end
	if caster.castLock then
		return false
	end
	if not caster.aggro then
		return false
	end
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_SPAWN, rate = 1})
		local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		caster:Stop()
		caster:SetForwardVector(fv)
		EmitSoundOn("Winterblight.EliteGhoul.ThrowSpell", caster)
		EmitSoundOn("Winterblight.EliteGhoul.Throw", caster)
		Timers:CreateTimer(0.15, function()
			local base_damage = event.base_damage
			ability.damage = base_damage

			ability.paralyze_duration = event.paralyze_duration
			local particle = "particles/roshpit/winterblight/ghost_arcanist_projectile_concoction_projectile_linear.vpcf"
			local range = 1000
			local speed = 1000
			local info =
			{
				Ability = ability,
				EffectName = particle,
				vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 60),
				fDistance = range,
				fStartRadius = 170,
				fEndRadius = 170,
				Source = caster,
				StartPosition = "attach_attack1",
				bHasFrontalCone = true,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = fv * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end)
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		caster:MoveToPositionAggressive(enemies[1]:GetAbsOrigin())
	end
end

function castle_room_unit_die(event)
	local unit = event.unit
	if unit.room_index and unit.room_index > 0 then
		Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"] = Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"] + 1
		print("----")
		print("ROOM UNIT DIE - Room: "..unit.room_index..", Total Slain: "..Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"])
		print("GOAL: "..Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemy_spawn_count"] + Winterblight.CASTLE_DATA["rooms"][unit.room_index]["extra_goal"])
		print("ROOM ACTIVE?: "..Winterblight.ActiveCastleRoom["active"])
		if Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"] >= Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemy_spawn_count"] + Winterblight.CASTLE_DATA["rooms"][unit.room_index]["extra_goal"] then
			if Winterblight.ActiveCastleRoom["active"] == 2 then
				Winterblight.ActiveCastleRoom["active"] = 3
				Winterblight:CastleRoomEnemyGoalReached(unit.room_index)
			end
		end
		if Winterblight.CastleTarot["name"] == "devil" then
			if Winterblight.CASTLE_DATA["rooms"][unit.room_index]["active"] < 3 then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, Winterblight.CastleDungeonMaster, "modifier_diviner_devil_door_waiter", {duration = 10})
				Winterblight:CloseCastleDoorByRoomIndex(unit.room_index)
			end
		elseif Winterblight.CastleTarot["name"] == "judgement" then
			if not Winterblight.CASTLE_DATA["rooms"][unit.room_index]["judgement_time_start"] then
				Winterblight.CASTLE_DATA["rooms"][unit.room_index]["judgement_time_start"] = GameRules:GetGameTime()
			end 
		end
	end
	Winterblight:CastleEnemyDieItemHype(unit)
	if not unit.deathCode then
		return true
	end
	-- CELLAR
	if unit.deathCode == "invading_spiderling" then
		Winterblight.CastleDungeonMaster.spider_invade_kills = Winterblight.CastleDungeonMaster.spider_invade_kills + 1
		local delay = 0.7
		local crawlspeed = 8
		local active_delay = 6.5
		if Winterblight.CastleTarot["name"] == "chariot" then
			delay = delay/2
			crawlspeed = 12
			active_delay = active_delay/2
		end
		if Winterblight.CastleDungeonMaster.spider_invade_kills == 10 then
			for i = 1, 10, 1 do
				Timers:CreateTimer(delay*i, function()
					local position = Vector(15104, 16232) + Vector(RandomInt(0, 1200), 0)
					local spider = Winterblight:SpawnCastleRoomUnit(2, "winterblight_invading_spider", position, RandomVector(1), false, false)
					spider:CrawlEnter(position, Vector(0,-1), "down", RandomInt(700, 1000), crawlspeed)
					spider.deathCode = "invading_spiderling"
				end)
			end
			for i = 1, 10, 1 do
				Timers:CreateTimer(delay*i, function()
					local position = Vector(16279, 15198) + Vector(0, RandomInt(0, 850))
					local spider = Winterblight:SpawnCastleRoomUnit(2, "winterblight_invading_spider", position, RandomVector(1), false, false)
					spider:CrawlEnter(position, Vector(-1,0), "down", RandomInt(700, 1000), crawlspeed)
					spider.deathCode = "invading_spiderling"
				end)
			end
		elseif Winterblight.CastleDungeonMaster.spider_invade_kills == 28 then
			for i = 1, 10, 1 do
				Timers:CreateTimer(delay*i, function()
					local position = Vector(15104, 16232) + Vector(RandomInt(0, 1200), 0)
					local spider = Winterblight:SpawnCastleRoomUnit(2, "winterblight_invading_spider", position, RandomVector(1), false, false)
					spider:CrawlEnter(position, Vector(0,-1), "down", RandomInt(700, 1000), crawlspeed)
					spider.deathCode = "invading_spiderling"
				end)
			end
			for i = 1, 10, 1 do
				Timers:CreateTimer(delay*i, function()
					local position = Vector(16279, 15198) + Vector(0, RandomInt(0, 850))
					local spider = Winterblight:SpawnCastleRoomUnit(2, "winterblight_invading_spider", position, RandomVector(1), false, false)
					spider:CrawlEnter(position, Vector(-1,0), "down", RandomInt(700, 1000), crawlspeed)
					spider.deathCode = "invading_spiderling"
				end)
			end
			Timers:CreateTimer(active_delay, function()
				Winterblight.CASTLE_DATA["rooms"][2]["active"] = 2
			end)
		end
	elseif unit.deathCode == "mould_room_mob" then
		if not Winterblight.CastleDungeonMaster.mould_room_mob_deaths then
			Winterblight.CastleDungeonMaster.mould_room_mob_deaths = 0
		end
		Winterblight.CastleDungeonMaster.mould_room_mob_deaths = Winterblight.CastleDungeonMaster.mould_room_mob_deaths + 1
		if Winterblight.CastleDungeonMaster.mould_room_mob_deaths == 16 then
			local positionTable = {Vector(11008, 8320), Vector(10360, 8320), Vector(10350, 7808), Vector(10360, 7296), Vector(10368, 6912), Vector(10752, 6912)}
			for i = 1, 3 + GameState:GetDifficultyFactor(), 1 do
				local fv = (Vector(10678, 7808) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(5, "winterblight_castle_watchman", positionTable[i], fv, false, false)
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", monster:GetAbsOrigin(), 3)
				EmitSoundOn("Winterblight.GraveGhostSpawn", monster)
				if Winterblight.CastleTarot["name"] == "magician" then
					local unitTable = {"winterblight_red_magician", "winterblight_blue_magician", "winterblight_green_magician"}
					for j = 1, 2, 1 do
						local unitName
						local monster = Winterblight:SpawnCastleRoomUnit(5, unitTable[RandomInt(1, #unitTable)], positionTable[i]+RandomVector(240), fv, false, false)
						CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", monster:GetAbsOrigin(), 3)
						EmitSoundOn("Winterblight.GraveGhostSpawn", monster)						
					end
				end
			end			
			Winterblight.CASTLE_DATA["rooms"][5]["active"] = 2
		end
	elseif unit.deathCode == "freezer" then
		if not Winterblight.CastleDungeonMaster.freezer_room_mob_deaths then
			Winterblight.CastleDungeonMaster.freezer_room_mob_deaths = 0
		end
		Winterblight.CastleDungeonMaster.freezer_room_mob_deaths = Winterblight.CastleDungeonMaster.freezer_room_mob_deaths + 1
		if Winterblight.CastleDungeonMaster.freezer_room_mob_deaths == 6 or Winterblight.CastleDungeonMaster.freezer_room_mob_deaths == 18 or Winterblight.CastleDungeonMaster.freezer_room_mob_deaths == 30 then
			local vertices = Winterblight:Room9Vertices()
			local delay = 1
			if GameState:GetDifficultyFactor() == 3 then
				delay = 0.8 - Winterblight.Stones*0.1
			end
			if Winterblight.CastleTarot["name"] == "chariot" then
				delay = delay/2
			end
			local active_delay = delay*(8 + GameState:GetDifficultyFactor()*2)
			if Winterblight.CastleTarot["name"] == "chariot" then
				active_delay = active_delay/2
			end			
			for i = 1, 10 + GameState:GetDifficultyFactor()*2, 1 do
				Timers:CreateTimer(i*delay, function()
					Winterblight:DropRoom9IcicleAtRandomPosition()
				end)
			end
			if Winterblight.CastleDungeonMaster.freezer_room_mob_deaths == 30 then
				Timers:CreateTimer(active_delay, function()
					Winterblight.CASTLE_DATA["rooms"][9]["active"] = 2
				end)
			end
		end
	elseif unit.deathCode == "blue_slime_room" then
		if not Winterblight.CastleDungeonMaster.blue_slime_deaths then
			Winterblight.CastleDungeonMaster.blue_slime_deaths = 0
		end
		Winterblight.CastleDungeonMaster.blue_slime_deaths = Winterblight.CastleDungeonMaster.blue_slime_deaths + 1
		local active_delay = 8.5
		if Winterblight.CastleDungeonMaster.blue_slime_deaths == 6 or Winterblight.CastleDungeonMaster.blue_slime_deaths == 22 or Winterblight.CastleDungeonMaster.blue_slime_deaths == 38 then
			local delay = 0.75
			if Winterblight.CastleTarot["name"] == "chariot" then
				delay = delay/2
				active_delay = active_delay/2
			end
			for i = 1, 16, 1 do
				Timers:CreateTimer(delay*i, function()
					Winterblight:SpawnSlimeRoomZombie()
				end)
			end	
		end	
		if Winterblight.CastleDungeonMaster.blue_slime_deaths == 38 then
			Timers:CreateTimer(active_delay, function()
				Winterblight.CASTLE_DATA["rooms"][12]["active"] = 2
			end)
		end
	elseif unit.deathCode == "sun_phoenix" then
		Winterblight.CastleDungeonMaster.sun_phoenixes_slain = Winterblight.CastleDungeonMaster.sun_phoenixes_slain + 1
		if Winterblight.CastleDungeonMaster.sun_phoenixes_slain == Winterblight.CastleDungeonMaster.sun_phoenixes_count - 1 then
			local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
			local egg = CreateUnitByName("npc_dummy_unit", Vector(15678, 6569), false, nil, nil, DOTA_TEAM_NEUTRALS)
			egg:SetAbsOrigin(egg:GetAbsOrigin()-Vector(0,0,800))
			master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, egg, "modifier_diviner_sun_immolation", {})
			egg:SetOriginalModel("models/items/phoenix/ultimate/blazing_wing_blazing_egg/blazing_wing_blazing_egg.vmdl")
			egg:SetModel("models/items/phoenix/ultimate/blazing_wing_blazing_egg/blazing_wing_blazing_egg.vmdl")
			egg:SetModelScale(2)	
			StartAnimation(egg, {duration = 10.0, activity = ACT_DOTA_IDLE, rate = 0.8})	
			egg:FindAbilityByName("dummy_unit"):SetLevel(1)
			master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, egg, "modifier_diviner_sun_event_thinker", {})
			EmitSoundOn("Winterblight.SunPhoenixEvent.Egg.Supernova", egg)
			egg.giga_egg = true
		end
	end
end

function castle_key_skull_think(event)
	local key = event.target
	if key.skull then
		local newFV = WallPhysics:rotateVector(key:GetForwardVector(), 2*math.pi/80)
		key:SetForwardVector(newFV)
	end
end

function castle_key_entering_think(event)
	local key = event.target
	if not key.fallSpeed then
		key.fallSpeed = 12
	end
	local distanceFromGround = key:GetDistanceFromGround()
	key.fallSpeed = math.max(key.fallSpeed - 0.1, 7)
	local distance_check = 75
	if key.skull then
		distance_check = 130
	end
	if distanceFromGround > distance_check then
		key:SetAbsOrigin(key:GetAbsOrigin()-Vector(0,0,key.fallSpeed))
	else
		EmitSoundOn("Winterblight.GhostBlink", key)
		if key.skull then
			local pfx2 = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/treasure_explosion_colorable.vpcf", key:GetAbsOrigin(), 3)
			ParticleManager:SetParticleControl(pfx2, 4, Vector(1.0, 0.4, 0.2))
		end
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/treasure_explosion_colorable.vpcf", key:GetAbsOrigin(), 3)
		ParticleManager:SetParticleControl(pfx, 4, Vector(0.3, 0.8, 0.6))
		key:RemoveModifierByName("modifier_winter_castle_key_entering")
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, key, "modifier_winter_castle_key_waiting", {})
		Winterblight:KeyLand(key:GetAbsOrigin())
	end
	if not key.soundPlayed then
		if distanceFromGround < 140 then
			if key.skull then
				EmitSoundOn("Winterblight.KeySpawn.Land", key)
				EmitSoundOn("Winterblight.KeySpawn.SkullLand", key)
				local ground_position = GetGroundPosition(key:GetAbsOrigin(), key)
				key.skullpfx = ParticleManager:CreateParticle("particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(key.skullpfx, 0, ground_position)
			else
				EmitSoundOn("Winterblight.KeySpawn.Land", key)
			end
			key.soundPlayed = true
		end
	end
end

function castle_key_waiting_think(event)
	local key = event.target
	if key.skull then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/time_blast2flash_glow.vpcf", key, 3)
	end
	local allies = FindUnitsInRadius( key:GetTeamNumber(), key:GetAbsOrigin(), nil, 180, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	AddFOWViewer(DOTA_TEAM_GOODGUYS, key:GetAbsOrigin(), 300, 1, false)
	if #allies > 0 then
		key.acquiring_hero = allies[1]
		-- CustomAbilities:QuickAttachParticle("particles/econ/events/frostivus/frostivus_tree_cast.vpcf", allies[1], 5)
		EmitSoundOn("Winterblight.EvilExplosion.Highlight", allies[1])
		-- CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", key:GetAbsOrigin(), 3)
		Winterblight:EvilExplosion(key:GetAbsOrigin())
		EmitSoundOn("Winterblight.KeyCollect", key)
		EmitSoundOn("Winterblight.KeyCollect1", allies[1])
		key:RemoveModifierByName("modifier_winter_castle_key_waiting")
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, key, "modifier_winter_castle_key_acquired", {})
		Winterblight.ActiveCastleRoom["cleared"] = 1

		if Winterblight.CastleTarot["name"] == "strength" and Winterblight.ActiveCastleRoom["door_index"] == 9 then
			Timers:CreateTimer(60, function()
				Winterblight:SpawnStrengthEvent()
			end)
		end
		if Winterblight.CastleTarot["name"] == "high_priestess" and Winterblight.ActiveCastleRoom["door_index"] == 6 then
			Timers:CreateTimer(45, function()
				Winterblight:SpawnHighPriestessBoss()
			end)
		end

		Winterblight.CASTLE_DATA["rooms_cleared"] = Winterblight.CASTLE_DATA["rooms_cleared"] + 1
		if key.skull then
			EmitSoundOn("Winterblight.KeyCollect.Skull", key)
			Timers:CreateTimer(4, function()
				Winterblight:WinterCastleBossSpawn()
			end)
			if key.skullpfx then
				ParticleManager:DestroyParticle(key.skullpfx, false)
			end
		else
			if Winterblight.CastleTarot["name"] == "world" then
				Winterblight:WorldRoomInitializers()
			else
				Winterblight:CastleNextRoomInit()
			end
		end
		if Winterblight.CastleTarot["name"] == "empress" then
			master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, key.acquiring_hero, "modifier_diviner_empress_speed_boost", {duration = 90})
		end
		if Winterblight.CastleTarot["name"] == "temperance" then
			for i = 1, #MAIN_HERO_TABLE, 1 do
				MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_temperance_scryer_debuff")
			end
		end
		Winterblight.CastleDungeonMaster:RemoveModifierByName("modifier_diviner_devil_door_waiter")
	end
end

function castle_key_acquired_think(event)
	local key = event.target
	if key.disabled then
		return false
	end
	if not key.collected_interval then
		key.collected_interval = 0
		key.liftSpeed = 12
	end
	
	key.collected_interval = key.collected_interval + 1
	if key.collected_interval > 90 then
		local hero_position = key.acquiring_hero:GetAbsOrigin()
		key.liftSpeed = math.min(key.liftSpeed+0.2, 35)
		key:SetAbsOrigin(key:GetAbsOrigin() + Vector(0,0,key.liftSpeed) )
	else
		local height = 200
		if key.skull then
			height = 400
		end
		key:SetAbsOrigin(key.acquiring_hero:GetAbsOrigin()+Vector(0,0,height))
	end
	if key.collected_interval == 92 then
		CustomAbilities:QuickAttachParticle("particles/econ/events/frostivus/frostivus_tree_cast.vpcf", key, 5)
		EmitSoundOn("Winterblight.KeyCollect.Exit", key)
	end
	if key.collected_interval == 180 then
		key:RemoveModifierByName("modifier_winter_castle_key_acquired")
		key.disabled = true
		Timers:CreateTimer(0.03, function()
			UTIL_Remove(key)
		end)
	end
end

function winterblight_venomous_bite_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:ApplyAndIncrementStack(ability, caster, "modifier_winterblight_venomous_bite_effect", 1, event.max_stacks, event.duration)
end

function winterblight_venomous_bite_effect_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local stacks = target:GetModifierStackCount("modifier_winterblight_venomous_bite_effect", caster)
	local damage = event.damage*stacks
	Enemies:ApplyDamageToPlayer(target, caster, damage, DAMAGE_TYPE_PHYSICAL, ability)
end

function winter_egg_sack_die(event)
	local caster = event.caster

	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", caster:GetAbsOrigin(), 5)
	EmitSoundOn("Winterblight.SpiderSack.Die", caster)
	local baseFV = caster:GetForwardVector()
	for i = 1, 5, 1 do
		local jumpFV = WallPhysics:rotateVector(baseFV, 2*math.pi*i/5)
		local spider = Winterblight:SpawnCastleRoomUnit(caster.room_index, "winterblight_egg_spider", caster:GetAbsOrigin(), RandomVector(1), true, true)
		WallPhysics:JumpWithBlocking(spider, jumpFV, RandomInt(14, 16), RandomInt(10, 12), 20, 1)
	end
	Events:smoothTranslate(caster, Vector(0,0,-4), 60, Vector(0,0), nil)
	Events:smoothSizeChange(caster, 1, 0.3, 30)
	if not Winterblight.CastleDungeonMaster.spider_invade_kills then
		Winterblight.CastleDungeonMaster.spider_invade_kills = 0
		for i = 1, 10, 1 do
			Timers:CreateTimer(0.7*i, function()
				local position = Vector(15104, 16232) + Vector(RandomInt(0, 1200), 0)
				local spider = Winterblight:SpawnCastleRoomUnit(caster.room_index, "winterblight_invading_spider", position, RandomVector(1), false, false)
				spider:CrawlEnter(position, Vector(0,-1), "down", RandomInt(700, 1000), 8)
				spider.deathCode = "invading_spiderling"
			end)
		end
		for i = 1, 10, 1 do
			Timers:CreateTimer(0.7*i, function()
				local position = Vector(16279, 15198) + Vector(0, RandomInt(0, 850))
				local spider = Winterblight:SpawnCastleRoomUnit(caster.room_index, "winterblight_invading_spider", position, RandomVector(1), false, false)
				spider:CrawlEnter(position, Vector(-1,0), "down", RandomInt(700, 1000), 8)
				spider.deathCode = "invading_spiderling"
			end)
		end
	end
end

function frost_wyrm_attack_land(event)
	local caster = event.caster
	local victim = event.target
	local ability = event.ability
	local damage = event.damage
	local icePoint = victim:GetAbsOrigin()
	local radius = 440
	local key = victim:GetEntityIndex() .. '_raxxus_attack_land'
	Util.Common:LimitPerTime(1, 1, key .. '_particles',function()
		EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
		local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, icePoint)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frostburn_gauntlets_slow", {duration = 3})
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		end
	end
end

function frost_wyrm_wave_start(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]
	local damage = event.damage
	EmitSoundOnLocationWithCaster(target, "Winterblight.ColdSeer.WaveFall", Events.GameMaster)
	for i = 0, 5, 1 do
		for j = 1, 5, 1 do
			Timers:CreateTimer(i * 1, function()
				local particlePosition = target + WallPhysics:rotateVector(Vector(1,0), 2*math.pi*j/5)*200
				local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/cold_seer_icefall.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx, 0, particlePosition)
				ParticleManager:SetParticleControl(pfx, 4, Vector(280, 280, 280))
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				Timers:CreateTimer(0.24, function()
					-- EmitSoundOnLocationWithCaster(particlePosition, "MysticAssasin.Rockfall.Impact", caster)
					local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particle1, 0, particlePosition)
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(particle1, false)
					end)
					GridNav:DestroyTreesAroundPoint(particlePosition, 270, false)
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), particlePosition, nil, 270, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_cold_seer_wave_burn", {duration = 8})
						end
					end
				end)
			end)
		end
	end
end

function spike_trap_think(event)
	local ability = event.ability
	local caster = event.caster
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
	local trap_dimension = 150
	local damage = event.damage_base
	Timers:CreateTimer(1.05, function()
		EmitSoundOn("Winterblight.SpikeTrap.Up", caster)
		spike_trap_damage(event)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_spike_trap_active", {duration = 3.0})
	end)
	EmitSoundOn("Winterblight.SpikeTrap.Prepare", caster)
end

function spike_trap_think_chariot(event)
	local ability = event.ability
	local caster = event.caster
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 2})
	local trap_dimension = 150
	local damage = event.damage_base
	Timers:CreateTimer(0.52, function()
		EmitSoundOn("Winterblight.SpikeTrap.Up.Chariot", caster)
		spike_trap_damage(event)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_spike_trap_active", {duration = 1.5})
	end)
	EmitSoundOn("Winterblight.SpikeTrap.Prepare.Chariot", caster)
end

function spike_trap_damage(event)
	local ability = event.ability
	local caster = event.caster
	local trap_dimension = 120
	local damage = event.damage_base
	local victims = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin()-Vector(0, trap_dimension,2), caster:GetAbsOrigin()+Vector(0, trap_dimension,2), caster, trap_dimension, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	if #victims > 0 then
		for _, victim in pairs(victims) do
			local victim_damage = math.floor(damage + (event.damage_pct_max_health/100)*victim:GetMaxHealth())
			Enemies:ApplyDamageToPlayer(victim, caster, victim_damage, DAMAGE_TYPE_PURE, ability)
			PopupDamage(victim, victim_damage)
			EmitSoundOn("Winterblight.SpikeTrap.Impact", victim)
		end
	end
end

function ground_blade_thinker(event)
	local ability = event.ability
	local caster = event.caster

	local trap_radius = 200
	local trap_move_speed = 15
	local rotate_speed = 25
	if Winterblight.CastleTarot["name"] == "chariot" then
		trap_move_speed = 30
		rotate_speed = 40
	end
	if not caster.pfx then
		local particleName = "particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 5, Vector(trap_radius, 2, 100))
		caster.pfx = pfx
	end

	if not caster.angle then
		caster.angle = 0
	end
	if not caster.startHeight then
		caster.startHeight = caster:GetAbsOrigin().z
	end
	if not caster.interval then
		caster.interval = 0
	end
	if not caster.moveFV then
		caster.moveFV = caster:GetForwardVector()
	end

	caster.angle = caster.angle + rotate_speed
	if caster.angle >= 360 then
		caster.angle = 0
	end
	caster:SetAngles(0, caster.angle, 0)


	local newPosition = GetGroundPosition(caster:GetAbsOrigin() + caster.moveFV*trap_move_speed, caster) + Vector(0,0,10) 
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)

	if (caster.startHeight ~= newPosition.z) or blockUnit then
		local newFV = WallPhysics:rotateVector(caster.moveFV, 2*math.pi/8) 
		-- newFV = WallPhysics:rotateVector(newFV, 2*math.pi*RandomInt(-3, 3)/60)
		caster.moveFV = newFV
		EmitSoundOn("Winterblight.SpinBlade.WallBounce", caster)
		CustomAbilities:QuickParticleAtPoint("particles/dire_fx/bad_stuff_end_sparks.vpcf", caster:GetAbsOrigin(), 3)
		-- caster:SetAbsOrigin(caster:GetAbsOrigin() + cas)
	else
		caster:SetAbsOrigin(newPosition)
	end
	caster.interval = caster.interval + 1
	if caster.interval >= 3 then
		caster.interval = 0
		local damage = event.damage_base
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, trap_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, victim in pairs(enemies) do
				local victim_damage = math.floor(damage + (event.damage_pct_max_health/100)*victim:GetMaxHealth())
				Enemies:ApplyDamageToPlayer(victim, caster, victim_damage, DAMAGE_TYPE_PURE, ability)
				PopupDamage(victim, victim_damage)
				EmitSoundOn("Winterblight.SpinBlade.Impact", victim)
			end
		end
	end
end


function torturor_attack_hit(event)
	local target = event.target
	local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)

	EmitSoundOn("Winterblight.CoupBloodEffect", target)	
end

function torturor_think(event)
	local caster = event.caster
	if not caster.spawnPos then
		caster.spawnPos = caster:GetAbsOrigin()
	end
	if caster.spawnPos ~= caster:GetAbsOrigin() then
		return false
	end
	if not caster.aggro then
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_ATTACK, rate=1.1})	
		Timers:CreateTimer(0.3, function()
			EmitSoundOn("Winterblight.Torturor.AttackSound", caster)
			local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + caster:GetForwardVector()*120)
			ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin() + caster:GetForwardVector()*120)
			EmitSoundOn("Winterblight.CoupBloodEffect", pigDummy)			
		end)
	end
end

function chilling_bite_aura_effect_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Winterblight.ChillingBiteAura.Release", caster)
	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/neutral_fx/ghost_frost_attack.vpcf",
		StartPosition = "attach_hitloc",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 750,
	iVisionTeamNumber = caster:GetTeamNumber()}

	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function chilling_bite_aura_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability:ApplyDataDrivenModifier(caster, target, "modifier_winterblight_chilling_bite_aura_chilled", {duration = event.slow_duration})

	local damage =  OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.dmg_pct_atk_power/100)
	Enemies:ApplyDamageToPlayer(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability)
	EmitSoundOn("Winterblight.ChillingBiteAura.Hit", target)
end

function room_7_goo_aura_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local target_origin = target:GetAbsOrigin()
	if (WallPhysics:IsWithinRegionA(target_origin, Vector(8657, 3200), Vector(11140,4392))) or (WallPhysics:IsWithinRegionA(target_origin, Vector(8119, 4329), Vector(11358,6004))) then
		if Winterblight.CastleDungeonMaster.blue_goo_dummy then
			local safest_height = GetGroundHeight(Vector(10880, 3584), target)
			local victim_height = target:GetAbsOrigin().z
			local depth = 0
			if (safest_height - victim_height) > 140 then
				depth = 3
			elseif (safest_height - victim_height) > 80 then
				depth = 2
			elseif (safest_height - victim_height) > 20 then
				depth = 1
			end
			local victim_goo_amount = depth
			if victim_goo_amount > 0 then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, target, "modifier_room_7_in_blue_goo", {})	
				target:SetModifierStackCount("modifier_room_7_in_blue_goo", Winterblight.CastleDungeonMaster, victim_goo_amount)		
			else
				target:RemoveModifierByName("modifier_room_7_in_blue_goo")
			end
		else
			local safest_height = GetGroundHeight(Vector(10880, 3584), target)
			local victim_height = target:GetAbsOrigin().z
			local depth = 0
			if (safest_height - victim_height) > 140 then
				depth = 3
			elseif (safest_height - victim_height) > 80 then
				depth = 2
			elseif (safest_height - victim_height) > 20 then
				depth = 1
			end

			local goo_depth = 3 - Winterblight.CastleDungeonMaster.goo_switches[1] - Winterblight.CastleDungeonMaster.goo_switches[2] - Winterblight.CastleDungeonMaster.goo_switches[3]

			local victim_goo_amount = math.min(depth, goo_depth)
			if depth == 1 and goo_depth < 3 then
				victim_goo_amount = 0
			end
			if (depth == 2 or depth == 1) and goo_depth < 2 then
				victim_goo_amount = 0
			end
			if depth == 2 and goo_depth == 2 then
				victim_goo_amount = 1
			end
			if victim_goo_amount > 0 then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, target, "modifier_room_7_in_goo", {})	
				target:SetModifierStackCount("modifier_room_7_in_goo", Winterblight.CastleDungeonMaster, victim_goo_amount)		
			else
				target:RemoveModifierByName("modifier_room_7_in_goo")
			end
		end
	else
		target:RemoveModifierByName("modifier_room_7_in_goo")
		target:RemoveModifierByName("modifier_room_7_in_blue_goo")
	end
end

function winter_armory_rock_destroy(event)
	local caster = event.caster
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/rock_explode.vpcf", caster:GetAbsOrigin(), 5)
	EmitSoundOn("Winterblight.BlueRock.Explode", caster)
	local amount = 3
	if Winterblight.CastleTarot["name"] == "strength" then
		amount = 6
	end
	if caster.strength_boss_rock then
		for i = 1, 9, 1 do
			local fv = WallPhysics:rotateVector(Vector(-1, -0.5), 2*math.pi*i/9)
			local monster = Winterblight:SpawnCastleRoomUnit(8, "winterblight_sun_rubble", caster:GetAbsOrigin(), fv, true, false)
			monster:SetAbsOrigin(monster:GetAbsOrigin() + Vector(0,0,RandomInt(100, 240)))
			WallPhysics:JumpWithBlocking(monster, fv, RandomInt(14, 16), RandomInt(10, 12), 20, 1)
			StartAnimation(monster, {duration = 1.35, activity = ACT_DOTA_SPAWN, rate = 0.8})
		end
		local spawnPos = caster:GetAbsOrigin()
		Timers:CreateTimer(0.1, function()
			Winterblight:SpawnStrengthMiniboss(spawnPos)
		end)
	else
		for j = 1, amount, 1 do
			local rubble = Winterblight:SpawnCastleRoomUnit(8, "winterblight_sun_rubble", caster:GetAbsOrigin(), RandomVector(1), true, true)
			CustomAbilities:QuickParticleAtPoint("particles/neutral_fx/skeleton_spawn.vpcf", rubble:GetAbsOrigin(), 4)
		end
	end
	Timers:CreateTimer(0.06, function()
		UTIL_Remove(caster)
	end)
end

function castle_ice_bear_attack_land(event)
	local caster = event.caster
	local ability = event.ability

	caster:ApplyAndIncrementStack(ability, caster, "modifier_ice_bear_attack_buff", 1, event.max_stacks, event.duration)
end

function room_9_icicle_fall_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local icicle = event.target
	if icicle.disabled then
		return false
	end
	if not icicle.fallSpeed then
		icicle.fallSpeed = 30
	end
	local distanceFromGround = icicle:GetDistanceFromGround()
	icicle.fallSpeed = math.min(icicle.fallSpeed + 0.1, 60)

	local angles = icicle:GetAngles()
	icicle:SetAngles(angles.x+5, angles.y+5, angles.z+15)

	if distanceFromGround > 10 then
		icicle:SetAbsOrigin(icicle:GetAbsOrigin()-Vector(0,0,icicle.fallSpeed))
	else
		EmitSoundOn("Winterblight.Icicle.Shatter", icicle)
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_medusa/ice_shatter.vpcf", icicle:GetAbsOrigin(), 3)
		icicle:RemoveModifierByName("modifier_room_9_icicle_fall")
		icicle.disabled = true
		local position = icicle:GetAbsOrigin()
		Timers:CreateTimer(0.03, function()
			UTIL_Remove(target)
		end)
		local unitTable = {"winterblight_frozen_cage", "winterblight_castle_warrior", "winterblight_wraithguard", "winterblight_frozen_mage", "winterblight_frozen_phantom", "winterblight_frozen_soul", "winterblight_suffering_spirit", "winterblight_elite_ghoul", "winterblight_fallen_one"}
		local monster = Winterblight:SpawnCastleRoomUnit(9, unitTable[RandomInt(1, #unitTable)], position, RandomVector(1), true, false)
		monster.deathCode = "freezer"
	end
end

function treasure_tower_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.summons then
		caster.summons = caster:GetMaxHealth()
	end
	if caster.summons >= caster:GetHealth() then
		caster.summons = caster.summons - 1
		local summon_height_offset = 45
		local particle_height_Offset = 80
		for i = 1, 3, 1 do
			local fv = WallPhysics:rotateVector(Vector(1, -0.5), 2*math.pi*RandomInt(-5, 5)/120)
			local monster = Winterblight:SpawnCastleRoomUnit(10, "winterblight_treasure_zombie", caster:GetAbsOrigin(), fv, true, false)
			monster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,summon_height_offset) + caster:GetForwardVector()*5)
			WallPhysics:JumpWithBlocking(monster, fv, RandomInt(14, 16), RandomInt(10, 12), 20, 1)
			StartAnimation(monster, {duration = 1.35, activity = ACT_DOTA_SPAWN, rate = 0.8})
			local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", monster, 3)
			ParticleManager:SetParticleControl(pfx, 1, monster:GetAbsOrigin()+Vector(0,0,particle_height_Offset)+monster:GetForwardVector()*150)
		end

		EmitSoundOn("Winterblight.TreasureTower.GoldSound", caster)
		Events:objectShake(caster, 8, 8, true, true, false, nil, 20)
	end
end

function winter_treasure_tower_die(event)
	local caster = event.caster
	local ability = event.ability

	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_warlock/chaos_blast_impact.vpcf", caster:GetAbsOrigin(), 5)
	EmitSoundOn("Winterblight.Tombstone.Explode", caster)
	EmitSoundOn("Winterblight.TreasureTower.Explode", caster)
	Winterblight.CASTLE_DATA["rooms"][10]["active"] = 2	
	for i = 1, 9, 1 do
		local fv = WallPhysics:rotateVector(Vector(-1, -0.5), 2*math.pi*i/9)
		local monster = Winterblight:SpawnCastleRoomUnit(10, "winterblight_treasure_zombie", caster:GetAbsOrigin(), fv, true, false)
		monster:SetAbsOrigin(monster:GetAbsOrigin() + Vector(0,0,summon_height_offset))
		WallPhysics:JumpWithBlocking(monster, fv, RandomInt(14, 16), RandomInt(10, 12), 20, 1)
		StartAnimation(monster, {duration = 1.35, activity = ACT_DOTA_SPAWN, rate = 0.8})
	end
	for j = 1, 3, 1 do
		local monster = Winterblight:SpawnCastleRoomUnit(10, "winterblight_gold_fanatic", caster:GetAbsOrigin(), RandomVector(1), false, false)
		EmitSoundOn("Winterblight.TreasureTower.GoldSound", monster)
		local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", monster, 3)
		ParticleManager:SetParticleControl(pfx, 1, monster:GetAbsOrigin()+Vector(0,0,particle_height_Offset))
	end

	Timers:CreateTimer(1, function()
		if Winterblight.CastleTarot["name"] == "lovers" then
			
		else
			Winterblight:SpawnTreasureRoomChests()
		end
	end)
end

function treasure_chest_attacked(event)
	local caster = event.caster
	local ability = event.ability
	if caster.opened then
		return false
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chest_open", {})
	caster.opened = true
	caster:SetModel("models/props_generic/chest_treasure_02_open.vmdl")
	caster:SetOriginalModel("models/props_generic/chest_treasure_02_open.vmdl")
	StartAnimation(caster, {duration = 3.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.5})
	EmitSoundOn("Winterblight.Chest.Open", caster)
	Timers:CreateTimer(0.6, function()
		if caster.bad_chest then
			local pfx = CustomAbilities:QuickParticleAtPoint("particles/econ/items/riki/riki_head_ti8_gold/riki_smokebomb_ti8_gold.vpcf", caster:GetAbsOrigin(), 3)
			ParticleManager:SetParticleControl(pfx, 1, Vector(300, 300, 300))
			EmitSoundOn("Winterblight.BadChest.Smoke", caster)
			Timers:CreateTimer(0.35, function()
				EmitSoundOn("Winterblight.BadChest.Laugh.VO", caster)
			end)
			
			Timers:CreateTimer(2.0, function()
				local skullbone = Enemies:SpawnEnemyUnit("lies_golden_skullbone", caster:GetAbsOrigin(), caster:GetForwardVector()*-1, true)
				skullbone:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,30))
				local scale = skullbone:GetModelScale()
				Events:smoothSizeChange(skullbone, 0.1, scale, 30)
				WallPhysics:JumpWithBlocking(skullbone, caster:GetForwardVector()*-1, RandomInt(14, 16), RandomInt(24, 32), 20, 1)
				local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", caster, 3)
				ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,80))
				EmitSoundOn("Winterblight.TreasureChest.OpenedWealth", caster)
			end)
			
		else
			EmitSoundOn("Winterblight.TreasureChest.OpenedWealth", caster)
			local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", caster, 3)
			ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,80))

			if caster.contents.items and caster.contents.items > 0 then
				Dungeons.lootLaunch = caster:GetAbsOrigin() - caster:GetForwardVector()*320
				for i = 1, caster.contents.items, 1 do
					RPCItems:RollRandomItemAtLocation(caster.roshpit_attributes.roshpit_level, caster:GetAbsOrigin(), RPCItems.RARITY_BOOSTS[ENEMY_TYPE_BOSS])
				end
				Dungeons.lootLaunch = false
			end
			if caster.contents.glyphs and caster.contents.glyphs > 0 then
				Dungeons.lootLaunch = caster:GetAbsOrigin() - caster:GetForwardVector()*320
				for i = 1, caster.contents.glyphs, 1 do
					local glyph = RPCItems:RebornGlyph()
					RPCItems:BasicDropItem(caster:GetAbsOrigin(), glyph)
				end
				Dungeons.lootLaunch = false
			end
			if caster.contents.crystals and caster.contents.crystals > 0 then
				Glyphs:DropArcaneCrystals(caster:GetAbsOrigin(), ENEMY_TYPE_NORMAL_CREEP, caster.roshpit_attributes.roshpit_level, caster.contents.crystals/10)
			end
			if caster.contents.ring_of_mysteries and caster.contents.ring_of_mysteries > 0 then
				RPCItems:RollAndDropImmortalByLevel(caster:GetAbsOrigin(), caster.roshpit_attributes.roshpit_level, "item_rpc_ring_of_mysteries")
			end
			if caster.contents.tarot_card and caster.contents.tarot_card > 0 then
				Winterblight:CreateCastleTarotCard(caster:GetAbsOrigin(), nil)
			end
			if caster.contents.temperance_boots and caster.contents.temperance_boots > 0 then
				RPCItems:RollAndDropImmortalByLevel(caster:GetAbsOrigin(), caster.roshpit_attributes.roshpit_level, "item_rpc_boots_of_temperance")
			end
		end
	end)
	if Winterblight.CastleTarot["name"] ~= "wheel_of_fortune" then
		if caster.treasure_room then
			for i = 1, #Winterblight.CastleDungeonMaster.treasure_room_chests, 1 do
				local chest = Winterblight.CastleDungeonMaster.treasure_room_chests[i]
				if chest:GetEntityIndex() ~= caster:GetEntityIndex() then
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", chest:GetAbsOrigin(), 3)
					EmitSoundOn("Winterblight.GraveGhostSpawn", chest)
					UTIL_Remove(chest)
				end
			end
		end
	end
end

function moon_warden_think(event)
	local caster = event.caster
	local ability = event.ability

	local position = caster:GetAbsOrigin()+RandomVector(RandomInt(0, 900))

	target = GetGroundPosition(position, caster)
	local cast_direction = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/moon_warden_indicator_ring.vpcf", target, 2.5)
	-- EmitSoundOnLocationWithCaster(target, "Winterblight.AzaleaBoss.IceNovaStart", caster)
	Timers:CreateTimer(2.5, function()
		local icePoint = target
		local damage = event.damage
		local radius = 450
		EmitSoundOnLocationWithCaster(icePoint, "Winterblight.MoonWarden.Pop", caster)
		local particleName = "particles/units/heroes/hero_puck/puck_waning_rift.vpcf"
		local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle2, 0, position)
		ParticleManager:SetParticleControl(particle2, 1, Vector(radius + 50, radius + 50, radius + 50))

		Timers:CreateTimer(1.9, function()
			ParticleManager:DestroyParticle(particle2, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(caster, ability, "modifier_silence", {duration = event.silence_duration})
				Enemies:ApplyDamageToPlayer(enemy, caster, damage, DAMAGE_TYPE_PURE, ability)
			end
		end
	end)
end

function moon_warden_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability and IsValidEntity(ability) then
		target:ApplyModifierAndSetStacks(ability, caster, "modifier_moon_warden_pull", 100, 3.0)
		CustomAbilities:QuickAttachParticle("particles/econ/items/weaver/weaver_immortal_ti6/weaver_immortal_ti6_shukuchi_portal.vpcf", target, 3)
		EmitSoundOn("Winterblight.MoonWarden.Pull", target)
	end
end

function moon_warden_pull_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local newStacks = target:GetModifierStackCount("modifier_moon_warden_pull", caster) - 3
	if newStacks > 0 then
		local pullDirection = ((caster:GetAbsOrigin() - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
		if distance > 200 then
			target:SetAbsOrigin(target:GetAbsOrigin() + pullDirection*newStacks*0.4)
		end
		target:ApplyModifierAndSetStacks(ability, caster, "modifier_moon_warden_pull", newStacks, 3)
	else
		print("REMOVE MODIFIER")
		target:RemoveModifierByName("modifier_moon_warden_pull")
		Timers:CreateTimer(0.06, function()
			FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
		end)
	end
end

function blue_slime_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 740, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		if caster:HasModifier("modifier_blue_slime_submerged") then
			caster:RemoveModifierByName("modifier_blue_slime_submerged")
			--print("RISE!")
			StartAnimation(caster, {duration = 0.61, activity = ACT_DOTA_SPAWN, rate = 0.6})
			for i = 1, 23, 1 do
				Timers:CreateTimer(0.03 * i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 14))
				end)
			end
			Timers:CreateTimer(0.18, function()
				EmitSoundOn("Winterblight.BlueSlime.Splash", caster)
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_blue.vpcf", caster:GetAbsOrigin()+Vector(0,0,260), 4)
			end)
		end
	else
		if not caster:HasModifier("modifier_blue_slime_submerged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_blue_slime_submerged", {})
			--print("FALL!")
			StartAnimation(caster, {duration = 0.57, activity = ACT_DOTA_SPAWN, rate = 0.6})
			for i = 1, 23, 1 do
				Timers:CreateTimer(0.03 * i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 14))
				end)
			end
			Timers:CreateTimer(0.18, function()
				EmitSoundOn("Winterblight.BlueSlime.Splash", caster)
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_blue.vpcf", caster:GetAbsOrigin()+Vector(0,0,180), 4)
			end)
		end
	end
end

function blue_slime_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Winterblight.BlueSlime.AttackSplash", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 140, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Enemies:ApplyDamageToPlayer(enemy, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sticky_blue", {duration = event.duration})
		end
	end

	CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_blue.vpcf", target:GetAbsOrigin(), 4)
end

function blue_slime_die(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.60, function()
		EmitSoundOn("Winterblight.BlueSlime.Splash", caster)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_blue.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 4)
	end)
end

function blue_slime_ghoul_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.BlueSlime.AttackSplash", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 140, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Enemies:ApplyDamageToPlayer(enemy, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sticky_blue", {duration = event.duration})
		end
	end
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_blue.vpcf", caster:GetAbsOrigin(), 4)
end

function castle_boss_rotator(event)
	local caster = event.caster
	local ability = event.ability

	local divisor = 360
	if caster.rotationDivisor then
		divisor = caster.rotationDivisor
	end
	if caster.dying then
		divisor = 240
	end
	if Winterblight.CastleTarot["name"] == "chariot" then
		divisor = divisor/2
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		divisor = divisor*1.5
	end
	if divisor > 0 then
		if not caster.rotateLock then
			local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/divisor)
			caster:SetForwardVector(newFV)
		end
	end
	if caster.dying then
		return false
	end
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1

	if not caster.handIndex then
		caster.handIndex = 1
	end
	local spawnMod = 60 - math.ceil(((caster:GetMaxHealth() - caster:GetHealth())/caster:GetMaxHealth())*50)
	if Winterblight.CastleTarot["name"] == "chariot" then
		spawnMod = math.ceil(spawnMod/2)
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		spawnMod = math.ceil(spawnMod*1.5)
	end
	if caster.interval % spawnMod == 0 then
		castle_boss_projectile_create(caster.handIndex)
		if caster.handIndex == 1 then
			caster.handIndex = 2
		else
			caster.handIndex = 1
		end
	end
	if caster.vision_guy then
		caster.vision_guy:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,100))
	end
	if caster.interval%(spawnMod*5) == 0 then
		if not caster.chain_frost_phase then
			caster.chain_frost_phase = 0
		end
		if caster.chain_frost_phase >= 3 then
			castle_boss_projectile_create(3)
		end
	end
	if caster.interval%60 == 0 then
		local splash_particle = "particles/roshpit/winterblight/blue_goo_explosion.vpcf"
		local splash_position = GetGroundPosition(caster:GetAbsOrigin(), caster) - Vector(0,0,240)
		CustomAbilities:QuickParticleAtPoint(splash_particle, splash_position, 5)
		for i = 1, 5, 1 do
			local fv = WallPhysics:rotateVector(Vector(1,1), 2*math.pi*i/5)
			CustomAbilities:QuickParticleAtPoint(splash_particle, splash_position + fv * 240, 5)
		end
	end
	if caster.interval % 100 == 0 then
		if not caster.surrogates then
			caster.surrogates = {}
		end
		if not caster.pain_animating then
			if #caster.surrogates == 0 then
				local surrogate_count = 3
				if Winterblight.CastleTarot["name"] == "emperor" then
					surrogate_count = 5
				elseif Winterblight.CastleTarot["name"] == "tower" then
					surrogate_count = 1
				end
				local surrogate_unit_name = "winterblight_castle_boss_surrogate"
				if Winterblight.CastleTarot["name"] == "hanged_man" then
					surrogate_unit_name = "winterblight_castle_boss_surrogate_hanged"
				end
				for i = 1, surrogate_count, 1 do
					local spawnPosition = caster:GetAbsOrigin()+RandomVector(RandomInt(600, 1400))
					local surrogate = Enemies:SpawnEnemyUnit(surrogate_unit_name, spawnPosition, Vector(0,-1), false)
					table.insert(caster.surrogates, surrogate)
					CustomAbilities:QuickParticleAtPoint("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", surrogate:GetAbsOrigin(), 4)
					EmitSoundOnLocationWithCaster(surrogate:GetAbsOrigin(), "Winterblight.CastleBoss.SurrogateSpawn", caster)
					Events:ColorWearablesAndBase(surrogate, Vector(50,50,50))
					if surrogate_unit_name == "winterblight_castle_boss_surrogate" then
						surrogate:SetAbsOrigin(surrogate:GetAbsOrigin() + Vector(0,0,90))
					end
					if Winterblight.CastleTarot["name"] == "tower" then
						surrogate:SetModelScale(surrogate:GetModelScale()*2)
						surrogate:AddAbility("ancient_god_steadfast"):SetLevel(GameState:GetDifficultyFactor())
					end
					Winterblight:AdjustCastleUnit(surrogate)
					if Winterblight.CastleTarot["name"] == "hermit" then
						local spawnPos = caster:GetAbsOrigin()+RandomVector(RandomInt(600, 1400))
						Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", spawnPos, RandomVector(1), false, true)
					end
				end
				if caster.rotationDivisor then
					print(caster.rotationDivisor)
					local temp_divisor = caster.rotationDivisor
					caster.rotationDivisor = caster.rotationDivisor/2.5
					Timers:CreateTimer(0.8, function()
						caster.rotationDivisor = temp_divisor/1.7
					end)
					Timers:CreateTimer(2, function()
						caster.rotationDivisor = temp_divisor
					end)
				end
			end
		end
	end
	if caster.interval == 300 then
		caster.interval = 0
	end
end

function castle_boss_projectile_create(index)
	
	local offsetAngleDegrees = 90
	local offsetDistance = 320
	local offsetFixed = Vector(0,0,1500)
	if index ~= 3 then
		if Winterblight.CastleBoss.pain_animating then
			return false
		end
	end
	if index == 2 then
		offsetAngleDegrees = -120
		offsetDistance = 320
		offsetFixed = Vector(0,0,1420)
	end

	local rotatedFV = WallPhysics:rotateVector(Winterblight.CastleBoss:GetForwardVector(), 2*math.pi*offsetAngleDegrees/360)
	local offset =  rotatedFV*offsetDistance + offsetFixed
	local position = Winterblight.CastleBoss:GetAbsOrigin() + offset


	local projectile = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	if index == 3 then
		position = Winterblight.CastleBoss:GetAttachmentOrigin(2)
		projectile.chain_hand = true
	end
	projectile.offsetAngleDegrees = offsetAngleDegrees
	projectile.offsetDistance = offsetDistance
	projectile.offsetFixed = offsetFixed

	projectile:SetModelScale(3.0)
	projectile:SetAbsOrigin(position)
	Winterblight.CastleBoss.main_ability:ApplyDataDrivenModifier(Winterblight.CastleBoss, projectile, "modifier_castle_boss_projectile", {})
	
	projectile.dummy = true
	projectile:FindAbilityByName("dummy_unit"):SetLevel(1)

	-- projectile:SetModel("models/heroes/silencer/silencer_curse_skull.vmdl")
	-- projectile:SetOriginalModel("models/heroes/silencer/silencer_curse_skull.vmdl")
	local projectileName = "particles/roshpit/winterblight/castle_boss_projectile.vpcf"
	if index == 3 then
		projectileName = "particles/econ/items/storm_spirit/storm_spirit_orchid_hat/stormspirit_orchid_ball_lightning.vpcf"
	end
	CustomAbilities:QuickAttachParticle(projectileName, projectile, 6)
	projectile.phase = 0
	EmitSoundOn("Winterblight.CastleBoss.HandProjectile.Create", projectile)
end

function castle_boss_projectile_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local projectile = event.target
	if projectile.lock then
		return false
	end
	if not IsValidEntity(projectile) then
		return false
	end
	if not projectile.offsetAngleDegrees then
		return false
	end
	if not projectile.interval then
		projectile.interval = 0
	end
	if Winterblight.CastleBoss.dying then
		projectile:RemoveModifierByName("modifier_castle_boss_projectile")
		projectile.lock = true
		Timers:CreateTimer(0.03, function()
			UTIL_Remove(projectile)
		end)
	end
	projectile.interval = projectile.interval + 1
	local rotatedFV = WallPhysics:rotateVector(Winterblight.CastleBoss:GetForwardVector(), 2*math.pi*projectile.offsetAngleDegrees/360)
	local offset =  rotatedFV*projectile.offsetDistance + projectile.offsetFixed

	local movement = Vector(8, 8, 6) * math.cos(2 * math.pi * projectile.interval / 90)

	if projectile.phase == 0 then
		local position = Winterblight.CastleBoss:GetAbsOrigin() + offset + movement
		if projectile.chain_hand then
			position = Winterblight.CastleBoss:GetAttachmentOrigin(2)
		end
		if IsValidEntity(projectile) then
			projectile:SetAbsOrigin(position)
		end
	end

	local newFV = WallPhysics:rotateVector(projectile:GetForwardVector(), 2*math.pi/100)
	projectile:SetForwardVector(newFV)
	if projectile.phase == 0 then
		if Winterblight.CastleBoss.pain_animating then
			projectile:RemoveModifierByName("modifier_castle_boss_projectile")
			projectile.lock = true
			UTIL_Remove(projectile)
		end
	end
	if projectile.interval == 100 then
		if projectile.chain_hand then
			local eventTable = {caster = Winterblight.CastleBoss, ability = Winterblight.CastleBoss.main_ability}
			create_chain_frost(eventTable)
			projectile:RemoveModifierByName("modifier_castle_boss_projectile")
			projectile.lock = true
			UTIL_Remove(projectile)			
		else
			projectile.phase = 1
			projectile.forwardSpeed = RandomInt(10, 30)
			EmitSoundOn("Winterblight.CastleBoss.HandProjectile.Launch", projectile)
		end
	end
	if projectile.phase == 1 then
		if not projectile.direction then
			projectile.direction = WallPhysics:rotateVector(Winterblight.CastleBoss:GetForwardVector(), 2*math.pi*projectile.offsetAngleDegrees/360)
		end
		local newPos = projectile:GetAbsOrigin() + projectile.direction*projectile.forwardSpeed - Vector(0,0,20)
		projectile:SetAbsOrigin(newPos)
		local distanceFromGround = projectile:GetDistanceFromGround()
		if distanceFromGround < 10 then
			EmitSoundOn("Winterblight.CastleBoss.HandProjectile.Impact", projectile)
			local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/castle_boss_nuke_explosion_magical.vpcf", projectile:GetAbsOrigin(), 5)
			ParticleManager:SetParticleControl(pfx, 1, Vector(1,0.5,0.5))
			projectile:RemoveModifierByName("modifier_castle_boss_projectile")
			projectile.lock = true
			local damage = Winterblight.CastleBoss.main_ability:GetSpecialValueFor("nuke_damage")
			local slow_duration = Winterblight.CastleBoss.main_ability:GetSpecialValueFor("slow_duration")
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), projectile:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Enemies:ApplyDamageToPlayer(enemy, Winterblight.CastleBoss, damage, DAMAGE_TYPE_MAGICAL, Winterblight.CastleBoss.main_ability)
					Winterblight.CastleBoss.main_ability:ApplyDataDrivenModifier(Winterblight.CastleBoss, enemy, "modifier_castle_boss_burning_slow", {duration = slow_duration})
				end
			end
			UTIL_Remove(projectile)
		end
	end
end

function castle_boss_surrogate_die(event)
	local surrogate = event.unit
	Winterblight:EvilExplosion(surrogate:GetAbsOrigin())
	EmitSoundOn("Winterblight.Surrogate.Explode", surrogate)
	EmitSoundOn("Winterblight.Surrogate.Explode2", surrogate)
	surrogate:AddNoDraw()
	reindex_castle_boss_surrogate_table()

	local light_damage = 3
	local heavy_damage = 14
	if GameState:GetDifficultyFactor() == 2 then
		light_damage = 3
		heavy_damage = 11
	elseif GameState:GetDifficultyFactor() == 3 then
		light_damage = 2
		heavy_damage = 11
	end
	if #Winterblight.CastleBoss.surrogates > 0 then
		if Winterblight.CastleTarot["name"] == "emperor" then
			light_damage = light_damage/2
		end
		castle_boss_take_damage(light_damage)
		Events:ColorWearablesAndBaseOverPeriod(Winterblight.CastleBoss, Winterblight.CastleBoss.color, Vector(255, 20, 40), 30)
		Timers:CreateTimer(0.9, function()
			Events:ColorWearablesAndBaseOverPeriod(Winterblight.CastleBoss, Vector(255, 20, 40), Winterblight.CastleBoss.color, 30)
		end)
	else
		if Winterblight.CastleTarot["name"] == "tower" then
			heavy_damage = heavy_damage + light_damage*2
		end
		castle_boss_take_damage(heavy_damage)
		Events:ColorWearablesAndBaseOverPeriod(Winterblight.CastleBoss, Winterblight.CastleBoss.color, Vector(255, 20, 40), 50)
		Timers:CreateTimer(3.4, function()
			Events:ColorWearablesAndBaseOverPeriod(Winterblight.CastleBoss, Vector(255, 20, 40), Winterblight.CastleBoss.color, 50)
		end)
	end
end

function castle_boss_take_damage(damage)
	local healthLoss = Winterblight.CastleBoss:GetMaxHealth()*(damage/100)
	if damage >= 10 then
		Winterblight.CastleBoss.pain_animating = true
		EndAnimation(Winterblight.CastleBoss)
		Winterblight.CastleBoss.rotateLock = true
		Timers:CreateTimer(0.03, function()
			
			StartAnimation(Winterblight.CastleBoss, {duration = 4.0, activity = ACT_DOTA_FLAIL, rate = 0.5})
			Timers:CreateTimer(1.5, function()
				Winterblight.CastleBoss.rotateLock = false
			end)
		end)
		EmitSoundOn("Winterblight.EvilExplosion.Main", Winterblight.CastleBoss)
		EmitSoundOn("Winterblight.EvilExplosion.Highlight", Winterblight.CastleBoss)
		EmitSoundOn("Winterblight.CastleBoss.PainBig", Winterblight.CastleBoss)
		Timers:CreateTimer(4, function()
			Winterblight.CastleBoss.pain_animating = false
		end)
		Events:objectShake(Winterblight.CastleBoss, 50, 20, true, false, true, nil, 20)
	else
		Events:objectShake(Winterblight.CastleBoss, 8, 9, true, false, true, nil, 20)
		EmitSoundOn("Winterblight.CastleBoss.PainSmall", Winterblight.CastleBoss)
	end
	Winterblight.CastleBoss:SetHealth(math.max(Winterblight.CastleBoss:GetHealth() - healthLoss, 0))
	--CustomGameEventManager:Send_ServerToAllClients("update_boss_health", {current_health = Winterblight.CastleBoss:GetHealth(), bossId = tostring(Winterblight.CastleBoss)})

	Winterblight.CastleBoss.rotationDivisor = 360 - ((Winterblight.CastleBoss:GetMaxHealth() - Winterblight.CastleBoss:GetHealth())/Winterblight.CastleBoss:GetMaxHealth())*330
	Winterblight.CastleBoss.color = Vector(255, 255, 255) - ((Winterblight.CastleBoss:GetMaxHealth() - Winterblight.CastleBoss:GetHealth())/Winterblight.CastleBoss:GetMaxHealth())*Vector(0, 255, 255)

	if Winterblight.CastleBoss:GetHealth() < 10 then
		Winterblight:CastleBossDeath(Winterblight.CastleBoss)
	end
	if damage >= 10 then
		if not Winterblight.CastleBoss.chain_frost_phase then
			Winterblight.CastleBoss.chain_frost_phase = 0
		end
		Winterblight.CastleBoss.chain_frost_phase = Winterblight.CastleBoss.chain_frost_phase + 1
		Timers:CreateTimer(4, function()
			if Winterblight.CastleBoss:GetHealth() > 10 then
				Winterblight:CastleBossSpawnPhase()
			end
			if not Winterblight.CastleBoss.main_ability.skullFrostTable then
				Winterblight.CastleBoss.main_ability.skullFrostTable = {}
			end
			local skullFrostCount = 3
			if Winterblight.CastleTarot["name"] == "death" then
				skullFrostCount = 6
			elseif Winterblight.CastleTarot["name"] == "temperance" then
				skullFrostCount = 0
			end
			if #Winterblight.CastleBoss.main_ability.skullFrostTable < ((Winterblight.CastleBoss:GetMaxHealth() - Winterblight.CastleBoss:GetHealth())/Winterblight.CastleBoss:GetMaxHealth())*(skullFrostCount+0.1) then
				if #Winterblight.CastleBoss.main_ability.skullFrostTable < skullFrostCount then
					ice_skull_create(Winterblight.CastleBoss, Winterblight.CastleBoss.main_ability)
					if Winterblight.CastleTarot["name"] == "death" then
						Timers:CreateTimer(1, function()
							ice_skull_create(Winterblight.CastleBoss, Winterblight.CastleBoss.main_ability)
						end)
					end
				end
			end
		end)
	end
end

function reindex_castle_boss_surrogate_table()
	local new_surrogate_table = {}
	for i = 1, #Winterblight.CastleBoss.surrogates, 1 do
		local surrogate = Winterblight.CastleBoss.surrogates[i]
		if surrogate and IsValidEntity(surrogate) and surrogate:IsAlive() then
			table.insert(new_surrogate_table, surrogate)
		end
	end
	Winterblight.CastleBoss.surrogates = new_surrogate_table
end

function castle_boss_surrogate_rotator(event)
	local caster = event.caster
	local ability = event.ability
	if Winterblight.CastleTarot["name"] == "hanged_man" then
		return false
	end
	if not caster.interval then
		caster.interval = 0
	end
	local rotation_divisor = 90
	if Winterblight.CastleTarot["name"] == "chariot" then
		rotation_divisor = 45
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		rotation_divisor = 135
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 4) * math.cos(2 * math.pi * caster.interval / 90))
	caster.interval = caster.interval + 1
	local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / rotation_divisor)
	caster:SetForwardVector(rotatedFV)
	if caster.interval == 90 then
		caster.interval = 0
	end
end

function castle_boss_death_effect_think(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/boss_exploding.vpcf", caster, 3)
	EmitSoundOn("Winterblight.AzaleaBoss.DeathEffect", caster)
end

function burn_damage_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local burn_damage = event.burn_damage

	Enemies:ApplyDamageToPlayer(target, caster, burn_damage, DAMAGE_TYPE_MAGICAL, ability)
end

function ice_skull_create(caster, ability)
    if not ability.skullFrostTable then
        ability.skullFrostTable = {}
    end

    local dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
    dummy.speed = 600
    dummy.index = #ability.skullFrostTable + 1
    
    if Winterblight.CastleTarot["name"] == "death" then
	    if dummy.index == 6 then
	   	 	dummy.rotationDelta = 180
	   	elseif dummy.index == 5 then
	   		dummy.rotationDelta = 160
	   	elseif dummy.index == 4 then
	   		dummy.rotationDelta = 140
	   	elseif dummy.index == 3 then
	   		dummy.rotationDelta = 120
	   	elseif dummy.index == 2 then
	   		dummy.rotationDelta = 100
	   	elseif dummy.index == 1 then
	   		dummy.rotationDelta = 80
	   	end
	    dummy.distance = 700
	    if #ability.skullFrostTable == 0 then
	    	dummy.distance = 700
	    elseif #ability.skullFrostTable == 1 then
	    	dummy.distance = 875
	    elseif #ability.skullFrostTable == 2 then
	    	dummy.distance = 1050
	    elseif #ability.skullFrostTable == 3 then
	    	dummy.distance = 1225
	    elseif #ability.skullFrostTable == 4 then
	    	dummy.distance = 1400
	    elseif #ability.skullFrostTable == 5 then
	    	dummy.distance = 1575
	    end
    else
	    if dummy.index == 3 then
	   	 	dummy.rotationDelta = 160
	   	elseif dummy.index == 2 then
	   		dummy.rotationDelta = 120
	   	elseif dummy.index == 1 then
	   		dummy.rotationDelta = 80
	   	end
	    dummy.distance = 700
	    if #ability.skullFrostTable == 0 then
	    	dummy.distance = 700
	    elseif #ability.skullFrostTable == 1 then
	    	dummy.distance = 1050
	    elseif #ability.skullFrostTable == 2 then
	    	dummy.distance = 1400
	    end
	end
    local baseFV = caster:GetForwardVector()
    local projectileFV = WallPhysics:rotateVector(baseFV, 2 * math.pi * dummy.index / dummy.rotationDelta)
    local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/boss_death_skull.vpcf", PATTACH_CUSTOMORIGIN, caster)
    local base_position = GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,80)
    ParticleManager:SetParticleControl(pfx, 0, base_position)
    ParticleManager:SetParticleControl(pfx, 1, GetGroundPosition(caster:GetAbsOrigin() + projectileFV * 700 + Vector(0, 0, 80), caster))
    ParticleManager:SetParticleControl(pfx, 2, Vector(dummy.speed, dummy.speed, dummy.speed))
    dummy.pfx = pfx
    dummy.interval = 0
    dummy.dummy = true

    dummy.pullPoint = caster:GetAbsOrigin() + projectileFV * dummy.distance + Vector(0, 0, 80)
    dummy.baseFV = projectileFV
    dummy.hardInterval = 0
    table.insert(ability.skullFrostTable, dummy)
    Timers:CreateTimer(dummy.distance/dummy.speed - 1, function()
    	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_boss_frost_skull", {})
    	dummy:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin() + projectileFV * dummy.distance + Vector(0, 0, 80), caster))
    end)
end

function ice_skull_thinker(event)
    local caster = event.caster
	local ability = event.ability
	local target = event.target
	local dummy = target
	if not dummy.interval then
		UTIL_Remove(dummy)
		ability.skullFrostTable = {}
	end
	dummy.interval = dummy.interval + 1
	dummy.hardInterval = dummy.hardInterval + 1
	local movement = ((dummy.pullPoint - dummy:GetAbsOrigin()):Normalized() * 0.03) * dummy.speed
	movement = movement * Vector(1, 1, 0)
    dummy:SetAbsOrigin(dummy:GetAbsOrigin() + movement)

	if dummy.interval == 3 then
		dummy.interval = 0
		local newFV = WallPhysics:rotateVector(dummy.baseFV, 2 * math.pi / dummy.rotationDelta)
		dummy.baseFV = newFV
		local newPos = GetGroundPosition(caster:GetAbsOrigin() + newFV * dummy.distance + Vector(0, 0, 80), caster)
		dummy.pullPoint = newPos
		ParticleManager:SetParticleControl(dummy.pfx, 1, newPos)
		-- ParticleManager:SetParticleControl(dummy.pfx, 2, Vector(ability.velocity, ability.velocity, ability.velocity))
	end
    if dummy.hardInterval == 7 then
        dummy.hardInterval = 0
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, 110, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.EnergyField.Hit", caster)
			for _, enemy in pairs(enemies) do
				local heightDifference = enemy:GetAbsOrigin().z - dummy:GetAbsOrigin().z 
				if heightDifference < 150 then
					print("HIT ENEMY")
					local pfx1 = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lich/lich_chain_frost_explode.vpcf", enemy, 3)
					ParticleManager:SetParticleControl(pfx1, 3, enemy:GetAbsOrigin()+Vector(0,0,40))
					EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Winterblight.Reaper.Scream", caster)
					EmitSoundOn("Winterblight.CastleBoss.ReaperScream2", enemy)
					EmitSoundOn("Winterblight.CastleBoss.SkullImpact", enemy)
					local particleName = "particles/roshpit/winterblight/econ/items/necrolyte/necro_sullen_harvest/red_reaper.vpcf"
					local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, enemy)
					ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					for i = 1, 9, 1 do
						ParticleManager:SetParticleControlEnt(pfx, i, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin() , true)
					end
					Timers:CreateTimer(1.2, function()
						EmitSoundOn("Winterblight.ReaperSlice.Hit", enemy)
						enemy:ForceKill(false)
					end)
				end
			end
		end
    end
end

function create_chain_frost(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lock then
		return false
	end
	-- StartAnimation(caster, {duration = 0.2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 2.2})
	EmitSoundOn("Winterblight.ChainFrostCast", caster)
	local vorpal_particle = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf"

	local baseFV = caster:GetForwardVector()
	local search_area = caster:GetAbsOrigin()
	local search_radius = event.search_radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), search_area, nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_castle_boss_chain_frost_thinker", {})

	if not ability.vorpals then
		ability.vorpals = {}
	end
	local total_max_blades = event.max_blades


	local damage = event.damage

	

	local vorpal = {}
	local vorpal_distance = 900
	local vorpal_fv = caster:GetForwardVector()
	local perpFV = WallPhysics:rotateVector(vorpal_fv, 2*math.pi/4)
	local vorpal_target = caster:GetAbsOrigin() + caster:GetForwardVector()*780 + Vector(0,0,1660)
	local vorpal_speed = 300
	local vorpal_origin = caster:GetAbsOrigin() + Vector(0,0,1220) + caster:GetForwardVector()*160 - perpFV*400

	local bounces = 9

	vorpal.active = true
	vorpal.speed = vorpal_speed
	vorpal.position = vorpal_origin
	vorpal.target = vorpal_target
	vorpal.interval = 0
	vorpal.damage = damage
	vorpal.mana_restore = mana_restore

	vorpal.type = event.type
	local pfx = ParticleManager:CreateParticle(vorpal_particle, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, vorpal_origin)
	ParticleManager:SetParticleControl(pfx, 1, vorpal_target)
	ParticleManager:SetParticleControl(pfx, 2, Vector(vorpal_speed, vorpal_speed, vorpal_speed))
	vorpal.pfx = pfx
	vorpal.targets_hit = 0
	vorpal.bounces = bounces
	if #enemies > 0 then
		local lock_target = enemies[RandomInt(1, #enemies)]
		vorpal.lock_entity = lock_target
	else
		vorpal.lock_entity = nil
	end
	table.insert(ability.vorpals, vorpal)

end

function castle_chain_frost_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local new_vorpal_table = {}
	local think_interval = 0.1

	local damage = event.damage

	for i = 1, #ability.vorpals, 1 do
		local vorpal = ability.vorpals[i]
		if vorpal.active then
			vorpal.speed = math.min(vorpal.speed + 70, 800)
			local direction = (vorpal.target - vorpal.position):Normalized()
			vorpal.position = vorpal.position + vorpal.speed*think_interval*direction
			vorpal.interval = vorpal.interval + 1

			if vorpal.interval >= 4 then
				if IsValidEntity(vorpal.lock_entity) and vorpal.lock_entity:IsAlive() then
					vorpal.target = vorpal.lock_entity:GetAbsOrigin() + Vector(0,0,100)
				end
			end
			if vorpal.interval >= 120 then
				vorpal.active = false
			end

			local distance = WallPhysics:GetDistance2d(vorpal.position, vorpal.target)
			
			if distance <= (vorpal.speed*think_interval) then
				-- CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", vorpal.position, 3)
				if not vorpal.bounces then
					vorpal.bounces = 9
				end
				if vorpal.targets_hit < (vorpal.bounces - 1) then
					vorpal.targets_hit = vorpal.targets_hit + 1
					local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), vorpal.position, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
					local new_target = nil
					if #nearby_enemies > 0 then
						if IsValidEntity(vorpal.lock_entity) then
							for _, enemy in pairs(nearby_enemies) do
								if enemy:GetEntityIndex() ~= vorpal.lock_entity:GetEntityIndex() then
									new_target = enemy
									break
								end
								-- Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
							end
						else
							new_target = nearby_enemies[1]
						end
					end
					if not IsValidEntity(new_target) then
						local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), vorpal.position, nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
						if #nearby_allies > 0 then
							if IsValidEntity(vorpal.lock_entity) then
								for _, ally in pairs(nearby_allies) do
									if ally:GetUnitName() == "winterblight_castle_boss_surrogate" or ally:GetUnitName() == "winterblight_castle_boss_surrogate_hanged" then
										if ally:GetEntityIndex() ~= vorpal.lock_entity:GetEntityIndex() then
											new_target = ally
											break
										end
									end
								end
							end
						end
					end
					if IsValidEntity(vorpal.lock_entity) then
						EmitSoundOn("Winterblight.ChainFrost.Impact", vorpal.lock_entity)
						local pfx1 = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lich/lich_chain_frost_explode.vpcf", vorpal.lock_entity, 3)
						ParticleManager:SetParticleControl(pfx1, 3, vorpal.lock_entity:GetAbsOrigin()+Vector(0,0,40))
						Winterblight.CastleBoss.main_ability:ApplyDataDrivenModifier(Winterblight.CastleBoss, vorpal.lock_entity, "modifier_chilled", {duration = 5})
						local damage = event.damage
						if vorpal.lock_entity:GetTeamNumber() ~= caster:GetTeamNumber() then
							Enemies:ApplyDamageToPlayer(vorpal.lock_entity, Winterblight.CastleBoss, damage, DAMAGE_TYPE_MAGICAL, Winterblight.CastleBoss.main_ability)
						end
					end
					if IsValidEntity(new_target) then
						vorpal.lock_entity = new_target
						vorpal.target = vorpal.lock_entity:GetAbsOrigin()
					else
						vorpal.active = false
					end

				else
					vorpal.active = false
				end
			end
			if vorpal.active then
				ParticleManager:SetParticleControl(vorpal.pfx, 1, vorpal.target)
				ParticleManager:SetParticleControl(vorpal.pfx, 2, Vector(vorpal.speed, vorpal.speed, vorpal.speed))
				table.insert(new_vorpal_table, vorpal)
			else
				ParticleManager:DestroyParticle(vorpal.pfx, false)
				ParticleManager:ReleaseParticleIndex(vorpal.pfx)	
			end			
		end
	end
	ability.vorpals = new_vorpal_table
end

function use_scryers_stone(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
	CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/scryer_stone_buildup.vpcf", caster, 2.5)
	EmitSoundOn("Winterblight.ScryersStone.Use", caster)
	Timers:CreateTimer(2, function()
		if caster.bgm == "Music.Winterblight.BlackfrostCitadel" then
			local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/scryer_stone_pop.vpcf", caster, 3.5)
			ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+Vector(0,0,30))
			local reveal_pos = nil
			if Winterblight.CastleBossMusic then
				reveal_pos = Winterblight.CastleBoss:GetAbsOrigin()
				AddFOWViewer(caster:GetTeamNumber(), reveal_pos, 600, 10, false)
				MinimapEvent(caster:GetTeamNumber(), caster, reveal_pos.x, reveal_pos.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10)
				EmitSoundOnClient("Winterblight.ScryersStone.Ping", caster:GetPlayerOwner())
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.ScryersStone.Effect", caster)
				EmitSoundOnLocationWithCaster(reveal_pos, "Winterblight.ScryersStone.Effect", caster)
			elseif Winterblight.CastleTarot["name"] == "world" then
				for i = 12, 1, -1 do
					if Winterblight.CASTLE_DATA["rooms"][i]["cleared"] == 0 then
						local door_index = Winterblight.CASTLE_DATA["rooms"][i]["door_index"]
						local door_position = Winterblight.CASTLE_DATA["doors"][door_index]["position"]
						AddFOWViewer(caster:GetTeamNumber(), door_position, 600, 10, false)
						MinimapEvent(caster:GetTeamNumber(), caster, door_position.x, door_position.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10)
					end
				end
				EmitSoundOnClient("Winterblight.ScryersStone.Ping", caster:GetPlayerOwner())
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.ScryersStone.Effect", caster)
			elseif Winterblight.ActiveCastleRoom then
				print("ACTIVE ROOM?")
				if not Winterblight.CastleBossDead then
					local door_index = Winterblight.ActiveCastleRoom["door_index"]
					local door_position = Winterblight.CASTLE_DATA["doors"][door_index]["position"]
					AddFOWViewer(caster:GetTeamNumber(), door_position, 600, 10, false)
					MinimapEvent(caster:GetTeamNumber(), caster, door_position.x, door_position.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10)
					EmitSoundOnClient("Winterblight.ScryersStone.Ping", caster:GetPlayerOwner())
					local eyePosition = GetGroundPosition(door_position, Events.GameMaster) + Vector(0,0,400)
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.ScryersStone.Effect", caster)
					EmitSoundOnLocationWithCaster(door_position, "Winterblight.ScryersStone.Effect", caster)
					reveal_pos = door_position
				end
			end
			if Winterblight.CastleTarot["name"] == "high_priestess" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_diviner_high_priestess_heal", {duration = 15})
			elseif Winterblight.CastleTarot["name"] == "hierophant" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_diviner_hierophant_spirit_buff", {duration = 40})
			elseif Winterblight.CastleTarot["name"] == "chariot" and reveal_pos then
				Events:LockCameraWithDuration(caster, 0.5)
				CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/chariot_teleport.vpcf", caster, 3)
				FindClearSpaceForUnit(caster, reveal_pos, false)
				CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/chariot_teleport.vpcf", caster, 3)
				EmitSoundOn("Winterblight.Tarot.ChariotTeleport", caster)
				ability:EndCooldown()
				ability:StartCooldown(20)
			elseif Winterblight.CastleTarot["name"] == "strength" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_strength_attack_power_player", {duration = 40})
			elseif Winterblight.CastleTarot["name"] == "hermit" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_diviner_hermit_buff", {duration = 15})
			elseif Winterblight.CastleTarot["name"] == "death" then
				if not ability.death_knights then
					ability.death_knights = {}
				end
				local newTable = {}
				for i = 1, #ability.death_knights, 1 do
					if ability.death_knights[i] and IsValidEntity(ability.death_knights[i]) and ability.death_knights[i]:IsAlive() then
						table.insert(newTable, ability.death_knights[i])
					end
				end
				ability.death_knights = newTable
				local fvTable = {Vector(1,0), Vector(0,1), Vector(-1, 0), Vector(0,-1)}
				for i = 1, #fvTable, 1 do
					if #ability.death_knights < 12 then
						local monster = Winterblight:SpawnCastleRoomUnit(0, "winterblight_castle_watchman", caster:GetAbsOrigin()+fvTable[i]*280, fvTable[i]*-1, false, true)
						CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", monster:GetAbsOrigin(), 3)
						EmitSoundOn("Winterblight.GraveGhostSpawn", monster)
						EmitSoundOn("Winterblight.CastleBoss.ReaperScream2", monster)
						monster:MakeNoDropsOrEXP()
						table.insert(ability.death_knights, monster)
					end
				end
			elseif Winterblight.CastleTarot["name"] == "temperance" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_temperance_scryer_debuff", {duration = 40})
			elseif Winterblight.CastleTarot["name"] == "devil" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_diviner_scryer_doom", {duration = 8})
			elseif Winterblight.CastleTarot["name"] == "star" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_diviner_star_all_stats_buff", {duration = 40})
			end
		end
	end)
end

function castle_flamethrower_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.interval then
		ability.interval = -4
		ability.rising = true
	end

	local fv = caster:GetForwardVector()
	local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * ability.interval / 40)

	if ability.rising then
		ability.interval = ability.interval + 1
		if ability.interval == 4 then
			ability.rising = false
		end
	else
		ability.interval = ability.interval - 1
		if ability.interval == -4 then
			ability.rising = true
		end
	end

	local start_radius = 120
	local end_radius = 200
	local range = 900
	local speed = 1000

	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = caster:GetAbsOrigin() + rotatedFV * 30 + Vector(0, 0, 80),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = rotatedFV * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function castle_flamethrower_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Enemies:ApplyDamageToPlayer(target, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
end

function castle_red_mage_burn(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Enemies:ApplyDamageToPlayer(target, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
end

function green_mage_poison_shot_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local particle = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
	local range = 800
	local speed = 1000
	local fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	local info =
	{
		Ability = ability,
		EffectName = particle,
		vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 60),
		fDistance = range,
		fStartRadius = 170,
		fEndRadius = 170,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	EmitSoundOn("Winterblight.GreenMage.VenomGale", caster)
end

function green_mage_poison_shot_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Enemies:ApplyDamageToPlayer(target, caster, event.impact_damage, DAMAGE_TYPE_MAGICAL, ability)
	local stacks = event.slow_ms_stacks
	ability:ApplyDataDrivenModifier(caster, target, "modifier_green_mage_poison_slow", {duration = stacks*0.5})
	target:SetModifierStackCount("modifier_green_mage_poison_slow", caster, stacks)
end

function green_mage_poison_dot_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	Enemies:ApplyDamageToPlayer(target, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
	local modifier = target:FindModifierByName("modifier_green_mage_poison_slow")
	local newStacks = modifier:GetStackCount() - 1
	if newStacks > 1 then
		modifier:SetStackCount(newStacks)
	else
		caster:RemoveModifierByName("modifier_green_mage_poison_slow")
	end

end

function castle_green_mage_poison_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Enemies:ApplyDamageToPlayer(target, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
end

function blue_mage_nova(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]

	local damage = event.damage
	local icePoint = target
	local radius = 440
	EmitSoundOnLocationWithCaster(icePoint, "Winterblight.BlueMage.NovaCast", caster)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, icePoint)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_blue_mage_root", {duration = event.root_duration})
			Enemies:ApplyDamageToPlayer(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability)
		end
	end
end

function haunt_mage_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.aggro then
		return false
	end
	for i = 0, 2, 1 do
		local castAbility = caster:GetAbilityByIndex(i)
		if caster.castLock then
			return false
		end
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				if caster.position_cast_self then
					castPoint = caster:GetAbsOrigin()
				end
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
			end
			break
		end
	end
end

function priestess_death_coil_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Winterblight.Priestess.DeathCoil", caster)
	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
		StartPosition = "attach_hitloc",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 1000,
	iVisionTeamNumber = caster:GetTeamNumber()}

	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function castle_death_coil_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local healAmount = target:GetMaxHealth()*event.heal_pct_max_health/100
	Filters:ApplyHeal(caster, target, healAmount, true)
	local particleName = "particles/frostivus_gameplay/wraith_king_heal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function castle_death_coil_owner_ai(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		if ability:IsFullyCastable() then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #allies > 0 then
				local target = nil
				for i = 1, #allies, 1 do
					if (allies[i]:GetHealth() < allies[i]:GetMaxHealth()) then
						target = allies[i]
						break
					end
				end
				if target then
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						TargetIndex = target:entindex(),
						AbilityIndex = ability:entindex(),
					}

					ExecuteOrderFromTable(newOrder)
				end
			end
		end
	end
end

function castle_high_priestess_heal_think(event)
	local target = event.target

	local heal = math.ceil(target:GetMaxHealth() * 2/100)
	Filters:ApplyHeal(target, target, heal, true)

	local manaRestore = math.ceil(target:GetMaxMana() * 1/100)
	target:GiveMana(manaRestore)
	Timers:CreateTimer(0.1, function()
		PopupMana(target, manaRestore)
	end)

end

function slime_emperor_aura_aura_effect_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Winterblight.SlimeEmperor.Projectile", caster)
	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_nasal_goo_proj.vpcf",
		StartPosition = caster:GetAbsOrigin() + Vector(0,0,300),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 750,
	iVisionTeamNumber = caster:GetTeamNumber()}

	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function slime_emperor_aura_aura_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	target:ApplyAndIncrementStack(ability, caster, "modifier_winterblight_slime_emperor_slowed", 1, 20, event.slow_duration)

	EmitSoundOn("Winterblight.SlimeEmperor.ProjectileImpact", target)
end

function necro_knight_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	if not ability.necro_knight_table then
		ability.necro_knight_table = {}
	end
	if #ability.necro_knight_table < event.max_summons then
		local summon = Enemies:SpawnEnemySummon(caster, "winterblight_castle_warrior", target:GetAbsOrigin()+RandomVector(100), RandomVector(1))
		CustomAbilities:QuickParticleAtPoint("particles/neutral_fx/skeleton_spawn.vpcf", summon:GetAbsOrigin(), 4)
		table.insert(ability.necro_knight_table, summon)
	else
		local new_summon_table = {}
		for i = 1, #ability.necro_knight_table, 1 do
			local summon = ability.necro_knight_table[i]
			if summon and IsValidEntity(summon) and summon:IsAlive() then
				table.insert(new_summon_table, summon)
			end
		end
		ability.necro_knight_table = new_summon_table		
	end
end

function lover_heart_attacked(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if caster.opened then
		return false
	end
	caster.rotationDivisor = 6
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_heart_rotation_animation", {duration = 2})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_heart_activated", {})
	caster.opened = true	
	EmitSoundOn("Winterblight.LoverHeart.Hit", caster)
	local selection = caster.selection_index
	Timers:CreateTimer(2, function()
		local particlePos = GetGroundPosition(caster:GetAbsOrigin(), caster)
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf", particlePos, 3)
		EmitSoundOn("Winterblight.LoverHeart.Reveal", caster)
		local prop_name = nil
		local prop_scale = 1
		local prop_color = Vector(255, 255, 255)
		if selection == 1 then
			prop_name = "winterblight_galren"
			prop_scale = 0.8
			prop_color = Vector(70, 70, 70)
		elseif selection == 2 then
			prop_name = "winterblight_elyna"
			prop_scale = 0.8
			prop_color = Vector(70, 70, 70)
		elseif selection == 3 then
			prop_name = "npc_dummy_unit"
			prop_scale = 0.9
			prop_color = Vector(255, 44, 44)
		end
		local prop = CreateUnitByName(prop_name, caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
		if selection == 3 then
			prop:SetModel("models/props_tree/mango_tree.vmdl")
			prop:SetOriginalModel("models/props_tree/mango_tree.vmdl")
		end
		prop:SetModelScale(prop_scale)
		Events:ColorWearablesAndBase(prop, prop_color)
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, prop, "modifier_diviner_prop_disable", {})
		Timers:CreateTimer(4, function()
			Winterblight:UpdateLoversTarot(selection)
			Winterblight:SpawnRoomKey(10, false)
		end)
	end)
	for i = 1, #Winterblight.CastleDungeonMaster.treasure_room_chests, 1 do
		local heart = Winterblight.CastleDungeonMaster.treasure_room_chests[i]
		if heart:GetEntityIndex() ~= caster:GetEntityIndex() then
			SpecialFX:ColoredPop(heart:GetAbsOrigin(), Vector(255, 120, 120))
			UTIL_Remove(heart)
		end
	end
end

function lover_heart_main_rotator_think(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	local rotatedFV = WallPhysics:rotateVector(fv, 2*math.pi/120)
	caster:SetForwardVector(rotatedFV)
end

function lover_heart_rotation_animation(event)
	local caster = event.caster
	local ability = event.ability

	local fv = caster:GetForwardVector()
	local rotatedFV = WallPhysics:rotateVector(fv, 2*math.pi/caster.rotationDivisor)
	caster:SetForwardVector(rotatedFV)
	caster.rotationDivisor = caster.rotationDivisor + 1
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,3.5))
end

function dragon_dual_burn_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Enemies:ApplyDamageToPlayer(target, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
end

function lovers_special_die(event)
	local unit = event.unit
	if unit:GetUnitName() == "winterblight_galren" then
		RPCItems:CreateBasicConsumable(unit:GetAbsOrigin(), "item_rpc_galrens_skull", "Galren's Skull", "mythical", true)
	elseif unit:GetUnitName() == "winterblight_elyna" then
		RPCItems:CreateBasicConsumable(unit:GetAbsOrigin(), "item_rpc_elynas_feather", "Elyna's Feather", "mythical", true)
	end
end

function use_winterblight_castle_lover_quest_item(event)
	local caster = event.caster
	local item = event.ability
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(13773, -2507))
	if Winterblight.CastleLoversPath and Winterblight.CastleLoversPath == "apple_tree" and distance < 800 and Winterblight.AppleTreeExists then
		if event.index == 1 then
			if not Winterblight.CastleGalrenSpirit then
				local spawnPos = caster:GetAbsOrigin()+caster:GetForwardVector()*200
				if Winterblight.CastleElynaSpirit then
					local spawnDistance = WallPhysics:GetDistance2d(spawnPos, Winterblight.CastleElynaSpirit:GetAbsOrigin())
					if spawnDistance < 400 then
						spawnPos = Winterblight.CastleElynaSpirit:GetAbsOrigin() + RandomVector(400)
					end
				end
				local lover = CreateUnitByName("winterblight_galren", spawnPos, false, nil, nil, DOTA_TEAM_NEUTRALS)
				lover:SetForwardVector(Vector(0,-1))
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, lover, "modifier_diviner_lovers_item_spawn", {})
				SpecialFX:ColoredSpotlight(lover:GetAbsOrigin(), Vector(255, 60, 60))
				lover.phase = 0
				lover:SetAbsOrigin(lover:GetAbsOrigin() + Vector(0,0,600))
				Winterblight.CastleGalrenSpirit = lover
				EmitSoundOn("Winterblight.LoverQuestItemUse", lover)
				UTIL_Remove(item)
			end
		elseif event.index == 2 then
			if not Winterblight.CastleElynaSpirit then 
				local spawnPos = caster:GetAbsOrigin()+caster:GetForwardVector()*200
				if Winterblight.CastleGalrenSpirit then
					local spawnDistance = WallPhysics:GetDistance2d(spawnPos, Winterblight.CastleGalrenSpirit:GetAbsOrigin())
					if spawnDistance < 400 then
						spawnPos = Winterblight.CastleGalrenSpirit:GetAbsOrigin() + RandomVector(400)
					end
				end
				local lover = CreateUnitByName("winterblight_elyna", spawnPos, false, nil, nil, DOTA_TEAM_NEUTRALS)
				lover:SetForwardVector(Vector(0,-1))
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, lover, "modifier_diviner_lovers_item_spawn", {})
				SpecialFX:ColoredSpotlight(lover:GetAbsOrigin(), Vector(255, 60, 60))
				lover.phase = 0
				lover:SetAbsOrigin(lover:GetAbsOrigin() + Vector(0,0,600))
				Winterblight.CastleElynaSpirit = lover
				EmitSoundOn("Winterblight.LoverQuestItemUse", lover)
				UTIL_Remove(item)
			end
		end
	else
		Notifications:Top(caster:GetPlayerOwnerID(), {text = "lovers_quest_item_use_fail", duration = 2, style = {color = "red"}, continue = true})
	end
end

function lover_quest_spawn_think(event)
	local lover = event.target
	if not lover.interval then
		lover.interval = 0
	end
	lover.interval = lover.interval + 1
	if lover.phase == 0 then
		if not lover.fallSpeed then
			lover.fallSpeed = 12
		end
		local distanceFromGround = lover:GetDistanceFromGround()
		lover.fallSpeed = math.max(lover.fallSpeed - 0.1, 7)
		local distance_check = 20
		if distanceFromGround > distance_check then
			lover:SetAbsOrigin(lover:GetAbsOrigin()-Vector(0,0,lover.fallSpeed))
		else
			EmitSoundOn("Winterblight.LoverSummon.Land", lover)
			SpecialFX:ColoredPop(lover:GetAbsOrigin(), Vector(255, 100, 60))
			lover.phase = 1
		end
		if not lover.soundPlayed then
			if distanceFromGround < 140 then
				EmitSoundOn("Winterblight.KeySpawn.Land", lover)
				lover.soundPlayed = true
			end
		end
	elseif lover.phase == 1 then
		if (Winterblight.CastleGalrenSpirit and lover:GetUnitName() == "winterblight_elyna") or (Winterblight.CastleElynaSpirit and lover:GetUnitName() == "winterblight_galren") then
			if not lover.other_lover then
				local other_lover = Winterblight.CastleElynaSpirit
				if lover:GetUnitName() == "winterblight_elyna" then
					other_lover = Winterblight.CastleGalrenSpirit
				end
				lover.other_lover = other_lover
			end
			if lover.other_lover and (lover.other_lover.phase == 1 or lover.other_lover.phase == 2) then
				CustomAbilities:QuickAttachParticle("particles/msg_fx/big_excalamation.vpcf", lover, 3)	
				EmitSoundOn("Winterblight.LoverSurprise", lover)
				local fv = ((lover.other_lover:GetAbsOrigin() - lover:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				lover:SetForwardVector(fv)
				lover.phase = 100
				Timers:CreateTimer(1.5, function()
					lover.phase = 2
				end)
			end
		end
	elseif lover.phase == 2 then
		if lover.interval % 10 == 0 then
			local move_to_position = (lover.other_lover:GetAbsOrigin()) - (((lover:GetAbsOrigin() - lover.other_lover:GetAbsOrigin())*Vector(1,1,0)):Normalized())*400
			lover:MoveToPosition(move_to_position)
			local distance = WallPhysics:GetDistance2d(lover:GetAbsOrigin(), lover.other_lover:GetAbsOrigin())
			if distance < 540 then
				lover.phase = 3
				lover:Stop()
				lover.other_lover:Stop()
				if not Winterblight.FinalLoverSceneStart then
					Winterblight.FinalLoverSceneStart = true
					Timers:CreateTimer(2, function()
						final_lover_scene(lover, lover.other_lover)
					end)
				end
			end
		end
	elseif lover.phase == 4 then
		local fv = ((lover.other_lover:GetAbsOrigin() - lover:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		lover:SetForwardVector(fv)
		local perpFV = WallPhysics:rotateVector(fv, 2*math.pi/4)
		lover:SetAbsOrigin(lover:GetAbsOrigin() + Vector(0,0,6) + fv*2 + perpFV*13)
		if lover.interval % 5 == 0 then
			local distance = WallPhysics:GetDistance2d(lover:GetAbsOrigin(), lover.other_lover:GetAbsOrigin())
			if distance < 50 then
				if not Winterblight.FinalLoverPop then
					Winterblight.FinalLoverPop = true
					local position = lover:GetAbsOrigin()
					SpecialFX:ColoredPop(lover:GetAbsOrigin(), Vector(255,40,40))
					SpecialFX:ColoredPop(lover.other_lover:GetAbsOrigin(), Vector(255,40,40))
					EmitSoundOn("Winterblight.LoversSequenceEnd", lover)
					UTIL_Remove(lover)
					UTIL_Remove(lover.other_lover)
					UTIL_Remove(lover.heart)
					local arcana = RPCItems:RollAndDropArcanaByLevel(position, GameState:GetDifficultyFactor()*40, "item_rpc_sephyr_arcana2")
					arcana.pickedUp = true
					Timers:CreateTimer(2, function()
						Winterblight.FinalLoverPop = nil
						Winterblight.FinalLoverSceneStart = nil
						Winterblight.CastleGalrenSpirit = nil
						Winterblight.CastleElynaSpirit = nil
					end)
				end
			end
		end
	end
	if lover.interval > 100 then
		lover.interval = 0
	end
end

function final_lover_scene(lover1, lover2)
	local midPoint = (lover1:GetAbsOrigin() + lover2:GetAbsOrigin())/2

	local heart = Enemies:SpawnEnemyUnit("winterblight_lovers_heart_path", midPoint, Vector(1,-1), false)
	heart:SetAbsOrigin(heart:GetAbsOrigin() + Vector(0,0,110))
	local particleName = "particles/roshpit/winterblight/colorable_pop.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, heart)
	ParticleManager:SetParticleControlEnt(pfx, 0, heart, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", heart:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(1,0.2,0.2))
	EmitSoundOn("Winterblight.LoverHeart.Reveal", heart)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	heart.rotationDivisor = 10
	local heart_ability = heart:FindAbilityByName("winterblight_lover_heart_ability")
	heart_ability:ApplyDataDrivenModifier(heart, heart, "modifier_heart_activated", {})
	heart_ability:ApplyDataDrivenModifier(heart, heart, "modifier_heart_rotation_animation", {duration = 4})

	Timers:CreateTimer(2, function()
		Events:smoothTranslate(heart, Vector(0,0,2.5), 94, Vector(0,0), "Winterblight.HeartSequenceRise")
	end)
	Timers:CreateTimer(3, function()
		lover1.phase = 4
		lover2.phase = 4
		lover1.animation_distance = WallPhysics:GetDistance2d(lover1:GetAbsOrigin(), lover2:GetAbsOrigin())
		lover2.animation_distance = WallPhysics:GetDistance2d(lover1:GetAbsOrigin(), lover2:GetAbsOrigin())
		SpecialFX:ColoredSpotlight(lover1:GetAbsOrigin()+Vector(0,0,30), Vector(60, 255, 255))
		SpecialFX:ColoredSpotlight(lover2:GetAbsOrigin()+Vector(0,0,30), Vector(60, 255, 255))
		EmitSoundOn("Winterblight.LoversSequenceRise", heart)
		lover1.heart = heart
		lover2.heart = heart
	end)
end

function strength_charge_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	target = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
	local invisible_duration = 3
	ability.fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.targetPoint = target
	local warpDuration = 3.0
	ability.fallVelocity = 3
	ability.forwardVelocity = 45
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_strength_charge_flying", {duration = warpDuration})

	caster:RemoveModifierByName("modifier_end_strength_charge_falling")

    EmitSoundOn("Winterblight.StrengthBoss.Charge", caster)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 5, Vector(0.6, 0.45, 0.24))
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.2, 0.2, 0.2))
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	StartAnimation(caster, {duration = 3, activity = ACT_DOTA_FLAIL, rate = 0.7, translate = "forcestaff_friendly"})
end

function strength_chargeing_think(event)
	local caster = event.caster
	local ability = event.ability


	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.fv*45), caster)
    local forwardSpeed = ability.forwardVelocity
	if blockUnit then
		forwardSpeed = 0
		print("BLOCKED?")
	end
	print("GOOOO")
	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv*forwardSpeed + Vector(0,0,5))
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	if distance < 100 then
		caster:RemoveModifierByName("modifier_strength_charge_flying")
		EndAnimation(caster)
		Timers:CreateTimer(0.03, function()
			StartAnimation(caster, {duration=3, activity=ACT_DOTA_TELEPORT_END, rate=0.8})
		end)
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, false)
			ability.pfx = false
		end
	end
end

function strength_charge_after_warp_falling(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallVelocity))
	ability.fallVelocity = ability.fallVelocity + 3
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	local damage = event.damage
	if caster:GetAbsOrigin().z - groundHeight < ability.fallVelocity/2 then
		caster:RemoveModifierByName("modifier_end_strength_charge_falling")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)

		local radius = 400
		local position = caster:GetAbsOrigin()
		local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
		local damage = event.damage
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Winterblight.StrengthChargeQuake", caster)
		-- FindClearSpaceForUnit(caster, position, false)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Enemies:ApplyDamageToPlayer(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, ability)
				enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
			end
		end
	end
end

function spine_drake_die(event)
	local caster = event.caster
	local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,80))
	ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.4, 0.4))
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.7, 0.7, 0.7))
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	Timers:CreateTimer(0.1, function()
		UTIL_Remove(caster)
	end)
end

function hermit_eye_thinker(event)
	local caster = event.caster
	local ability = event.ability

	local fv = caster:GetForwardVector()
	local rotatedFV = WallPhysics:rotateVector(fv, 2*math.pi/160)

	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval % 30 == 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if #enemies > 0 then
			caster.target_lock = enemies[1]
		else
			caster.target_lock = nil
		end
		caster.interval = 0
	end
	if caster.target_lock then
		rotatedFV = ((caster.target_lock:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	end

	caster:SetForwardVector(rotatedFV)
	if caster.dying then
		if not caster.descend_speed then
			caster.descend_speed = 6
		end
		local fv = caster:GetForwardVector()
		local rotatedFV = WallPhysics:rotateVector(fv, 2*math.pi/60)
		caster:SetForwardVector(rotatedFV)	

		caster.descend_speed = math.min(20, caster.descend_speed + 0.3)
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,12))
	end	
end

function hermit_eye_effect_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_dark_willow/dark_willow_base_attack.vpcf",
		StartPosition = "attach_hitloc",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 500,
	iVisionTeamNumber = caster:GetTeamNumber()}

	projectile = ProjectileManager:CreateTrackingProjectile(info)		
end

function hermit_eye_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.HermitEye.AttackLand", target)
	Enemies:ApplyDamageToPlayer(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability)
end

function hermit_eye_die(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hermit_eye_dying", {duration = 3})
	caster.dying = true
end

function winterblight_shadow_tornado_owner_die(event)
	local caster = event.caster
	local ability = event.ability
	if ability.tornadoTable then
		for i = 1, #ability.tornadoTable, 1 do
			ability.tornadoTable[i]:RemoveModifierByName("modifier_tornado_thinker")
		end
	end
end

function winter_castle_shadow_tornado_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()

	if not caster:IsAlive() then
		return false
	end
	if not ability.tornadoTable then
		ability.tornadoTable = {}
	end
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration = 1.1, activity = ACT_DOTA_ATTACK, rate = 1.6})
	end)
	local startPoint = caster:GetAbsOrigin() + RandomVector(RandomInt(400, 700))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		startPoint = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(90, 270))
	end
	ability.velocity = 1000
	ability.rotationDelta = 20

	local distance = WallPhysics:GetDistance2d(startPoint, caster:GetAbsOrigin())
	ability.velocity = distance * 1
	-- if event.noSound then
	-- 	local luck = RandomInt(1, 3)
	-- 	if luck == 1 then
	-- 		EmitSoundOn("Sorceress.TornadoCast.VO", caster)
	-- 	end
	-- else
	-- 	EmitSoundOn("Sorceress.TornadoCast.VO", caster)
	-- end

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.ShadowTornado.Launch", caster)

	local bAvatar = false
	local casterOrigin = caster:GetAbsOrigin()


	local dummy = CreateUnitByName("npc_dummy_unit", casterOrigin, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_tornado_thinker", {duration = 14})
	local projectileFV = ((startPoint - casterOrigin) * Vector(1, 1, 0)):Normalized()
	local tornadoParticle = "particles/roshpit/winterblight/shadow_tornado_ti6.vpcf"

	local pfx = ParticleManager:CreateParticle(tornadoParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, casterOrigin)

	ParticleManager:SetParticleControlEnt(pfx, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", dummy:GetAbsOrigin(), true)

	ability.clearcast = false

	dummy.pfx = pfx
	dummy.interval = 0
	dummy.dummy = true
	dummy.pullPoint = casterOrigin + projectileFV * 1300 + Vector(0, 0, 80)
	dummy.baseFV = projectileFV
	dummy.hardInterval = 0
	dummy.velocity = ability.velocity
	dummy.position = casterOrigin
	dummy.targetPosition = startPoint
	dummy.newTarget = startPoint
	dummy.atPoint = false
	table.insert(ability.tornadoTable, dummy)
	local max_tornados = event.max_tornados
	if bAvatar then
		max_tornados = 3
	end
	--print(max_tornados)
	if #ability.tornadoTable > max_tornados then
		ability.tornadoTable[1]:RemoveModifierByName("modifier_tornado_thinker")
	end
	Timers:CreateTimer(1, function()
		StartSoundEvent("Winterblight.ShadowTornado.LP", dummy)
	end)

end

function winter_shadow_tornado_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local dummy = target
	if not IsValidEntity(ability) then
		return false
	end
	dummy.interval = dummy.interval + 1
	dummy.hardInterval = dummy.hardInterval + 1

	dummy:SetAbsOrigin(dummy:GetAbsOrigin() + dummy.velocity * 0.03 * dummy.baseFV)
	dummy:SetAbsOrigin(GetGroundPosition(dummy:GetAbsOrigin(), caster))
	local distance = WallPhysics:GetDistance2d(dummy:GetAbsOrigin(), dummy.newTarget)
	dummy.velocity = math.max(dummy.velocity - 15, 300)
	if dummy.atPoint then
		if dummy.interval % 5 == 0 then
			AddFOWViewer(caster:GetTeamNumber(), dummy:GetAbsOrigin(), 400, 1, false)
			dummy.baseFV = WallPhysics:rotateVector(dummy.baseFV, 2 * math.pi / 10)
			dummy.newTarget = dummy.targetPosition + dummy.baseFV * 500
		end
	else

		if distance < 100 then
			dummy.atPoint = true
		end
	end

	if dummy.interval % 15 == 0 then
		local radius = 800
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local enemy = enemies[1]
			local info =
			{
				Target = enemy,
				Source = dummy,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_bane/bane_projectile.vpcf",
				vSourceLoc = dummy:GetAbsOrigin() + Vector(0, 0, RandomInt(80, 140)),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 10,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 900,
			iVisionTeamNumber = caster:GetTeamNumber()}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy.pushLock or enemy.jumpLock then
			else
				local pullVector = ((dummy:GetAbsOrigin() - enemy:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local distance = WallPhysics:GetDistance2d(dummy:GetAbsOrigin(), enemy:GetAbsOrigin())
				local pullSpeed = math.max(4, 10 - distance / 12)
				enemy:SetAbsOrigin(enemy:GetAbsOrigin() + pullVector * pullSpeed)
			end
		end
	end
end

function winter_shadow_tornado_splinter_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage

	Enemies:ApplyDamageToPlayer(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability)
end

function winter_shadow_tornado_thinker_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local pfx = target.pfx
	StopSoundEvent("Winterblight.ShadowTornado.LP", target)
	Timers:CreateTimer(0.03, function()
		UTIL_Remove(target)
		reindex_shadow_tornado_table(ability)
	end)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function tornado_damage_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.pushLock then
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end
end

function enemy_inside_winter_tornado_thinker(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local ability = event.ability
	if IsValidEntity(caster) then
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_ICE, RPC_ELEMENT_WIND)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_shadow_tornado_blind", {duration = 1})
	end
end

function reindex_shadow_tornado_table(ability)
	local newTable = {}
	for i = 1, #ability.tornadoTable, 1 do
		if IsValidEntity(ability.tornadoTable[i]) then
			table.insert(newTable, ability.tornadoTable[i])
		end
	end
	ability.tornadoTable = newTable
end

function in_blue_goo_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target.blue_goo_interval then
		target.blue_goo_interval = 0
	end
	target.blue_goo_interval = target.blue_goo_interval + 1
	local stacks = target:GetModifierStackCount("modifier_room_7_in_blue_goo", caster)
	local mod = 4 - stacks
	if target.blue_goo_interval%mod == 0 then
		local damage = target:GetMaxHealth()*0.15
		Enemies:ApplyDamageToPlayer(target, caster, damage, DAMAGE_TYPE_PURE, ability)
		EmitSoundOn("Winterblight.BlueGoo.Damage", target)
		StartAnimation(target, {duration = 0.3, activity = ACT_DOTA_FLAIL, rate = 2.1})
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_blue.vpcf", target:GetAbsOrigin(), 4)
	end
	if target.blue_goo_interval == 3 then
		target.blue_goo_interval = 0
	end
end

function blue_goo_sniper_leap_onspellstart(event)
	local caster = event.caster
	local ability = event.ability
	abilityLevel = ability:GetLevel()
	--ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)
	ability.jump_level = 0
	EmitSoundOn("Winterblight.BlueGooSniper.Jump.VO", caster)


	ability.animation = false
	ability.extra_particle = false


	ability:ApplyDataDrivenModifier(caster, caster, "modfier_blue_goo_sniper_jumping", {duration = 8})
	local targetPoint = event.target_points[1]
	local distance = WallPhysics:GetDistance(targetPoint * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	local jumpFV = ((targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	--print(jumpFV)
	ability.jump_velocity = distance / 50 + 55
	ability.jumpFV = jumpFV
	ability.distance = distance
	ability.targetPoint = targetPoint
	ability.lifting = true
	Timers:CreateTimer(0.9, function()
		ability.lifting = false
	end)
	ability.landing_point = targetPoint
	local zDiff = targetPoint.z - caster:GetAbsOrigin().z
	StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_TELEPORT_END, rate = 0.3})
end

function blue_goo_sniper_leap_jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	local forwardSpeed = ability.distance / 65
	print("GOING?")
	forwardSpeed = Filters:GetAdjustedESpeed(caster, forwardSpeed, false)
	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.jumpFV * 35), caster)
	if blockUnit then
		forwardSpeed = 0
	end
	local safest_height = GetGroundHeight(Vector(10880, 3584), caster)
	local victim_height = caster:GetAbsOrigin().z
	local depth = 0
	if (safest_height - victim_height) > 120 then
		depth = 1
	end
	if depth == 1 then
		Winterblight:BlueGooSplash(caster:GetAbsOrigin()+Vector(0,0,370))
	end
	

	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, ability.jump_velocity) + ability.jumpFV * forwardSpeed)
	local vertical_deceleration = 3.3
	ability.jump_velocity = math.max(ability.jump_velocity - vertical_deceleration, -35)
	--print(ability.jumpFV)
	local distanceToPoint = WallPhysics:GetDistance2d(ability.landing_point, caster:GetAbsOrigin())
	if distanceToPoint < 50 then
		caster:RemoveModifierByName("modfier_blue_goo_sniper_jumping")
		print("LAND 2d")
	end
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 10 then
		if not ability.lifting then
			caster:RemoveModifierByName("modfier_blue_goo_sniper_jumping")
			print("LAND NOT LIFTING")
		end
	elseif caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 200 and not ability.animation and not ability.lifting then
		ability.animation = true
		-- StartAnimation(caster, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 1.5, translate = "assassin"})
	end
end

function blue_goo_sniper_leap_landing(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	local damage = keys.damage
	local sticky_duration = keys.sticky_duration
	Timers:CreateTimer(0.06, function()
		WallPhysics:ClearSpaceForUnit(caster, location)
		local safest_height = GetGroundHeight(Vector(10880, 3584), caster)
		local victim_height = caster:GetAbsOrigin().z
		local depth = 0
		if (safest_height - victim_height) > 120 then
			depth = 1
		end
		if depth == 1 then
			Winterblight:BlueGooSplash(caster:GetAbsOrigin()+Vector(0,0,450))
		else
			Winterblight:BlueGooSplash(caster:GetAbsOrigin())
		end
	end)


	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Enemies:ApplyDamageToPlayer(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sticky_blue", {duration = sticky_duration})
		end
	end

end

function blue_goo_gunner_splash(event)
	local caster = event.caster
	Winterblight:BlueGooSplash(caster:GetAbsOrigin()+Vector(0,0,100))
end

function blue_goo_gunner_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	if not caster.current_jump_index then
		caster.current_jump_index = 1
	end

	local safest_height = GetGroundHeight(Vector(10880, 3584), caster)
	local victim_height = caster:GetAbsOrigin().z
	local depth = 0
	if (safest_height - victim_height) > 120 then
		depth = 1
	end
	if depth == 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_goo_gunner_in_deep_goo", {})
	else
		caster:RemoveModifierByName("modifier_goo_gunner_in_deep_goo")
	end

	if ability:IsFullyCastable() then
		local positions = {Vector(9984, 4224), Vector(9024, 3614), Vector(9500, 5487), Vector(10854, 5610)}
		local new_jump_index = RandomInt(1, 4)
		while caster.current_jump_index == new_jump_index do
			new_jump_index = RandomInt(1, 4)
		end
		caster.current_jump_index = new_jump_index

		local castPoint = GetGroundPosition(positions[caster.current_jump_index], caster) 
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = ability:entindex(),
			Position = castPoint
		}

		ExecuteOrderFromTable(newOrder)
		return false
	end
	if not caster:HasModifier("modfier_blue_goo_sniper_jumping") then
		local shrapnel_ability = caster:FindAbilityByName("winterblight_blue_goo_shrapnel")
		if shrapnel_ability:IsFullyCastable() then
			local positions = {Vector(9024, 3614), Vector(9500, 5487), Vector(10854, 5610)}
			local castPoint = positions[RandomInt(1, 3)]
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = shrapnel_ability:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			return false
		end	
	end

end

function blue_goo_shrapnel_cast(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1})
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_shrapnel.vpcf", point, 5)
	ParticleManager:SetParticleControl(pfx, 1, Vector(450,450,450))
	EmitSoundOn("Winterblight.Shgrapnel.Start", caster)
	EmitSoundOnLocationWithCaster(point, "Winterblight.Shgrapnel.Effect", caster)
	local damage = event.damage
	for i = 1, 10, 1 do
		Timers:CreateTimer(i*0.5, function()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 440, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Enemies:ApplyDamageToPlayer(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, ability)
				end
			end
		end)
	end
end

function castle_justice_unit_die(event)
	local ability = event.ability
	local caster = event.caster
	local unit = event.unit
	local justice_index = unit.justice_index
	local justice_type = event.justice_type

	local complete = false

	if unit:GetUnitName() == "winterblight_castle_justice_arch_demon_hellmouth" or unit:GetUnitName() == "winterblight_castle_justice_arch_angel_matheus" then
		return false
	end
	if justice_type == "angel" then
		Winterblight.CastleJusticeData.total_angels_killed = Winterblight.CastleJusticeData.total_angels_killed + 1
		Winterblight.CastleJusticeData.room_results[justice_index].angels_killed = Winterblight.CastleJusticeData.room_results[justice_index].angels_killed + 1
		if Winterblight.CastleJusticeData.room_results[justice_index].angels_killed == Winterblight.CastleJusticeData.room_results[justice_index].angels_spawned_count then
			for i = 1, #Winterblight.CastleJusticeData.room_results[justice_index].demons_entities, 1 do
				local despawn_entity = Winterblight.CastleJusticeData.room_results[justice_index].demons_entities[i]
				if IsValidEntity(despawn_entity) and despawn_entity:IsAlive() then
					EmitSoundOn("Winterblight.JusticeDespawn", despawn_entity)
					SpecialFX:ColoredPop(despawn_entity:GetAbsOrigin(), Vector(255, 50, 50))
					UTIL_Remove(despawn_entity)
				end
			end
			Winterblight.CastleJusticeData.angels_spawn_count = Winterblight.CastleJusticeData.angels_spawn_count + 2
			complete = true
		end
	elseif justice_type == "demon" then
		Winterblight.CastleJusticeData.total_demons_killed = Winterblight.CastleJusticeData.total_demons_killed + 1
		Winterblight.CastleJusticeData.room_results[justice_index].demons_killed = Winterblight.CastleJusticeData.room_results[justice_index].demons_killed + 1
		if Winterblight.CastleJusticeData.room_results[justice_index].demons_killed == Winterblight.CastleJusticeData.room_results[justice_index].demons_spawned_count then
			for i = 1, #Winterblight.CastleJusticeData.room_results[justice_index].angels_entities, 1 do
				local despawn_entity = Winterblight.CastleJusticeData.room_results[justice_index].angels_entities[i]
				if IsValidEntity(despawn_entity) and despawn_entity:IsAlive() then
					EmitSoundOn("Winterblight.JusticeDespawn", despawn_entity)
					SpecialFX:ColoredPop(despawn_entity:GetAbsOrigin(), Vector(255, 255, 255))
					UTIL_Remove(despawn_entity)
				end
			end
			Winterblight.CastleJusticeData.demons_spawn_count = Winterblight.CastleJusticeData.demons_spawn_count + 2
			complete = true
		end
	end
	for j = 1, #MAIN_HERO_TABLE, 1 do
		if Winterblight.CastleJusticeData.total_demons_killed > 0 then
			ability:ApplyDataDrivenModifier(caster, MAIN_HERO_TABLE[j], "modifier_diviner_demons_slain", {})
			MAIN_HERO_TABLE[j]:SetModifierStackCount("modifier_diviner_demons_slain", caster, Winterblight.CastleJusticeData.total_demons_killed )
		end
		if Winterblight.CastleJusticeData.total_angels_killed > 0 then
			ability:ApplyDataDrivenModifier(caster, MAIN_HERO_TABLE[j], "modifier_diviner_angels_slain", {})
			MAIN_HERO_TABLE[j]:SetModifierStackCount("modifier_diviner_angels_slain", caster, Winterblight.CastleJusticeData.total_angels_killed )
		end
	end
	if complete then
		if Winterblight.CastleJusticeData.room_index == 9 then
			if Winterblight.CastleJusticeData.total_angels_killed > Winterblight.CastleJusticeData.total_demons_killed then
				Winterblight:SpawnJusticeHellmouth()
			elseif Winterblight.CastleJusticeData.total_demons_killed > Winterblight.CastleJusticeData.total_angels_killed then
				Winterblight:SpawnJusticeMatheus()
			else
				Winterblight:SpawnJusticeBalance()
			end
		else
			Winterblight:HandleJusticeSpawns()
		end
	end
end

function hanging_slayer_init(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetTeamNumber() ~= DOTA_TEAM_NEUTRALS then
		return false
	end
	Timers:CreateTimer(0.03, function()
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,2000))
		caster:AddNoDraw()
		caster:SetForwardVector(RandomVector(1))
		caster.cantAggro = true
		StartAnimation(caster, {duration = 99999, activity = ACT_DOTA_VICTORY, rate = 1})

	end)
end

function hanging_slayer_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_hanging_slayer_falling") then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		caster:RemoveNoDraw()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_hanging_slayer_falling", {})
		ability.fallSpeed = 8
		ability.angle = 180
		EndAnimation(caster)
		Timers:CreateTimer(1.0, function()
			StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.5})
		end)
	else
		
	end
end

function hanging_slayer_dropping(event)
	local caster = event.caster
	local ability = event.ability

	ability.fallSpeed = math.min(ability.fallSpeed + 0.5, 30)
	caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0,0,ability.fallSpeed))
	if caster:GetDistanceFromGround() <= 900 then
		ability.angle = math.max(ability.angle - 6.2, 0)
		
		local newFV = Vector((180 - ability.angle) / 180, (180 - ability.angle) / 180, 1 - (180 - ability.angle) / 180)
		caster:SetForwardVector(newFV)
	end

	if caster:GetDistanceFromGround() <= ability.fallSpeed then
		caster:RemoveModifierByName("modifier_hanging_slayer_falling")
		caster:RemoveModifierByName("modifier_slayer_hanging")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
        local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
        ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
        Timers:CreateTimer(2, function()
          ParticleManager:DestroyParticle(pfx, false)
        end)
        caster:SetAngles(0, 0,0)
        caster.cantAggro = false
        Dungeons:AggroUnit(caster)
        EndAnimation(caster)
        StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_TELEPORT, rate = 1.3})
	end
end

function hanging_slayer_die(event)
	local caster = event.caster
	if not Winterblight.HangingSlayersKilled then
		Winterblight.HangingSlayersKilled = 0
	end
	Winterblight.HangingSlayersKilled = Winterblight.HangingSlayersKilled + 1
	if Winterblight.HangingSlayersKilled%42 == 0 then
		local position = caster:GetAbsOrigin()+RandomVector(RandomInt(40, 160))
		Winterblight:GeneralChestSpawn(position, Vector(0,-1))
	end
end

function water_bearer_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local start_radius = 400
	local end_radius = 400
	local range = 1500
	local speed = 550
	local fv = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	EmitSoundOn("Winterblight.WaterBearer.Projectile", caster)

	local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function devil_door_waiter_end(event)
	Winterblight:OpenCastleDoorByIndex(Winterblight.CastleDungeonMaster.closed_door_index)
end

function faceripper_attack_start(event)
	local caster = event.caster
	local luck = RandomInt(1, 3)
	if luck == 1 then
		EmitSoundOn("Winterblight.FaceRipper.Preattack.VO", caster)
	end
end

function faceripper_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	for i = 1, event.instance_count, 1 do
		Timers:CreateTimer(i*0.06, function()
			Enemies:ApplyDamageToPlayer(target, caster, damage, DAMAGE_TYPE_PHYSICAL, ability)
			local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)

			EmitSoundOn("Winterblight.CoupBloodEffect", target)	
		end)
	end
end

function faceripper_take_damage(event)
	local unit = event.caster
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, Winterblight.CastleDungeonMaster, "modifier_diviner_devil_door_waiter", {duration = 10})
	Winterblight:CloseCastleDoorByRoomIndex(unit.room_index)
end

function starwatcher_think(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
			ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			Timers:CreateTimer(0.6, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			Timers:CreateTimer(0.45, function()
				if enemy:IsAlive() then
					Enemies:ApplyDamageToPlayer(enemy, caster, damage, DAMAGE_TYPE_PURE, ability)
					EmitSoundOn("Winterblight.StarProphecy.Impact", enemy)
				end
			end)
		end
	end
end

function diviner_star_entering_think(event)
	local caster = event.caster
	local ability = event.ability
	local key = event.target

	if not key.fallSpeed then
		key.fallSpeed = 12
	end
	local distanceFromGround = key:GetDistanceFromGround()
	key.fallSpeed = math.max(key.fallSpeed - 0.1, 7)
	local distance_check = 20
	if distanceFromGround > distance_check then
		key:SetAbsOrigin(key:GetAbsOrigin()-Vector(0,0,key.fallSpeed))
	else
		key:RemoveModifierByName("modifier_diviner_star_entering")
		if key:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
			key.cantAggro = false
			if key:GetUnitName() ~= "winterblight_world_commander_vorethrex" then
				Dungeons:AggroUnit(key)
			end
		end
	end
end

function die_holding_scryer_stone(event)
	local unit = event.unit
	local ability = event.ability
	if Winterblight.CastleTarot["name"] == "star" then
		if ability:GetCooldownTimeRemaining() == 0 then
			ability:StartCooldown(60)
			local position = unit:GetAbsOrigin()
			unit.revive = true
			Timers:CreateTimer(1, function()
				unit:RespawnHero(false, false)
				unit:SetAbsOrigin(position + Vector(0,0,1000))
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, unit, "modifier_diviner_star_entering", {duration = 10})
				SpecialFX:ColoredSpotlight(position, Vector(255, 255, 0))	
			end)	
		end
	end
end

function diviner_moon_entering_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if Winterblight.CastleMoonPlatform["lock"] then
		return false
	end
	local target_distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), Vector(14715, -2711))
	if target_distance > 240 then
		target:RemoveModifierByName("modifier_diviner_moon_platform")
		return false
	end
	if Winterblight.CastleMoonPlatform["color"] == Vector(255, 255, 255) then
		Winterblight.CastleMoonPlatform["color"] = Vector(255, 255, 0)
	end
	Winterblight.CastleMoonPlatform["color"] = Winterblight.CastleMoonPlatform["color"] - Vector(1, 1, -0.2)
	Winterblight.CastleMoonPlatform["entity"]:SetRenderColor(Winterblight.CastleMoonPlatform["color"].x, Winterblight.CastleMoonPlatform["color"].y, Winterblight.CastleMoonPlatform["color"].z)
	if Winterblight.CastleMoonPlatform["color"].x < 40 then
		Winterblight.CastleDungeonMaster.moon_lift_bros = {}
		Winterblight.CastleMoonPlatform["lock"] = true
		for i = 1, #MAIN_HERO_TABLE, 1 do
			if MAIN_HERO_TABLE[i]:HasModifier("modifier_diviner_moon_platform") then
				ability:ApplyDataDrivenModifier(caster, MAIN_HERO_TABLE[i], "modifier_diviner_moon_platform_lock", {})
				MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_diviner_moon_platform")
				table.insert(Winterblight.CastleDungeonMaster.moon_lift_bros, MAIN_HERO_TABLE[i])
				MAIN_HERO_TABLE[i]:SetAbsOrigin(MAIN_HERO_TABLE[i]:GetAbsOrigin() + Vector(0,0,15))
			end
		end
		CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/teleport_start_ti9.vpcf", Winterblight.CastleMoonPlatform["entity"]:GetAbsOrigin(), 10)
		EmitSoundOnLocationWithCaster(Winterblight.CastleMoonPlatform["entity"]:GetAbsOrigin(), "Winterblight.MoonPlatform.Activate", Winterblight.CastleDungeonMaster)
		Timers:CreateTimer(1, function()
			EmitSoundOnLocationWithCaster(Winterblight.CastleMoonPlatform["entity"]:GetAbsOrigin(), "Winterblight.MoonPlatform.Spin", Winterblight.CastleDungeonMaster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_diviner_moon_platform_lock_caster", {duration = 10})
		end)
	end
end

function diviner_moon_enter_end(event)
	local target = event.target
	local ability = event.ability
	if Winterblight.CastleMoonPlatform["lock"] then
		return false
	end
	local moon_modifier_count = 0
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if MAIN_HERO_TABLE[i]:HasModifier("modifier_diviner_moon_platform") then
			moon_modifier_count = moon_modifier_count + 1
		end
	end
	if moon_modifier_count == 0 then
		Winterblight.CastleMoonPlatform["color"] = Vector(255,255,255)
		Winterblight.CastleMoonPlatform["entity"]:SetRenderColor(Winterblight.CastleMoonPlatform["color"].x, Winterblight.CastleMoonPlatform["color"].y, Winterblight.CastleMoonPlatform["color"].z)		
	end
end

function diviner_moon_platform_thinker(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	Winterblight.CastleMoonPlatform["lift_speed"] = math.min(Winterblight.CastleMoonPlatform["lift_speed"] + 0.1, 30)
	for i = 1, #caster.moon_lift_bros, 1 do
		local hero = caster.moon_lift_bros[i]
		hero:SetAbsOrigin(hero:GetAbsOrigin() + Vector(0,0,Winterblight.CastleMoonPlatform["lift_speed"]))
	end
	Winterblight.CastleMoonPlatform["entity"]:SetAbsOrigin(Winterblight.CastleMoonPlatform["entity"]:GetAbsOrigin() + Vector(0,0,Winterblight.CastleMoonPlatform["lift_speed"]))
	Winterblight.CastleMoonPlatform["lift_interval"] = Winterblight.CastleMoonPlatform["lift_interval"] + 1
	print(Winterblight.CastleMoonPlatform["lift_interval"])
	if Winterblight.CastleMoonPlatform["lift_interval"] == 240 then
		print("200 LETS GO")
		caster:RemoveModifierByName("modifier_diviner_moon_platform_lock_caster")
		for i = 1, #caster.moon_lift_bros, 1 do
			local hero = caster.moon_lift_bros[i]
			hero:SetAbsOrigin(Vector(13568, -2816, hero:GetAbsOrigin().z - 1240) + RandomVector(100*i))
			local groundPosition = GetGroundPosition(hero:GetAbsOrigin(), hero)
			SpecialFX:ColoredSpotlight(groundPosition, Vector(0, 120, 200))
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_diviner_star_entering", {duration = 10})
			hero:RemoveModifierByName("modifier_diviner_moon_platform_lock")
		end
		local miniboss = Winterblight:SpawnCastleRoomUnit(0, "winterblight_lumos_king", Vector(14713, -2720), Vector(0,-1), false, true)
		miniboss:SetAbsOrigin(miniboss:GetAbsOrigin() + Vector(0,0,1400))
		local groundPosition = GetGroundPosition(miniboss:GetAbsOrigin(), miniboss)
		SpecialFX:ColoredSpotlight(groundPosition, Vector(0, 120, 200))
		miniboss.cantAggro = true
		ability:ApplyDataDrivenModifier(caster, miniboss, "modifier_diviner_star_entering", {duration = 7})
		miniboss:AddLootDrop("immortal", "item_rpc_moon_shard", 100)
	end
end

function lumos_king_think(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local enemy = enemies[RandomInt(1, #enemies)]
		Enemies:ApplyDamageToPlayer(enemy, caster, damage, DAMAGE_TYPE_PURE, ability)
		EmitSoundOn("Winterblight.LumosKing.Moonbeam", enemy)
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_lumos_king_beam", {duration = 0.15})
		Filters:ApplyStun(caster, 0.03, enemy)
	end
end

function claws_of_terror_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local fear_chance = event.fear_chance
	local fear_duration = event.fear_duration
	local luck = RandomInt(1, 100)
	if luck <= fear_chance then
		EmitSoundOn("Winterblight.TerrorClaw.Fear", target)
		target:AddNewModifier(caster, ability, "modifier_fear", {duration = fear_duration})
	end
end

function winter_fire_blink_activate(event)
	local caster = event.caster
	local ability = event.ability

	EmitSoundOn("Winterblight.FireBlink", caster)

	local particleName = "particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	local target = event.target_points[1]
	local casterOrigin = caster:GetAbsOrigin()
	target = WallPhysics:WallSearch(casterOrigin, target, caster)
	-- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
	--     ParticleManager:SetParticleControl( pfx, 0, position )
	local newPosition = target
	FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function winter_fire_blink_ai_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS and caster.aggro then
		if ability:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()+RandomVector(180)
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function sun_phoenix_die(event)
	local caster = event.caster
	Events:smoothTranslate(caster, Vector(0,0,-5), 45, Vector(0,0), nil)
end

function diviner_sun_event_egg_think(event)
	local egg = event.target
	if egg.lock then
		return false
	end
	egg:SetAbsOrigin(egg:GetAbsOrigin() + Vector(0,0,6))
	if egg:GetDistanceFromGround() > 440 then
		egg.lock = true
		EmitSoundOn("Winterblight.SunPhoenixEvent.Egg.Explode", egg)
		local unitName = "winterblight_temple_sun_crow"
		if egg.giga_egg then
			unitName = "winterblight_aspect_of_solos"
		end
		local phoenix = Winterblight:SpawnCastleRoomUnit(0, unitName, egg:GetAbsOrigin(), RandomVector(1), false, true)
		phoenix.deathCode = "sun_phoenix"
		phoenix:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
		phoenix:SetAbsOrigin(egg:GetAbsOrigin())
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, phoenix, "modifier_visual_fly_height_decay", {})
		phoenix:SetModifierStackCount("modifier_visual_fly_height_decay", Events.GameMaster, 440)
		phoenix.min_stacks = 110
		if egg.giga_egg then
			phoenix.min_stacks = 240
			phoenix:AddLootDrop("immortal", "item_rpc_sun_gods_visage", 100)
		end
		Dungeons:AggroUnit(phoenix)
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, phoenix, "modifier_diviner_sun_immolation", {})

		local particleName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle1, 0, egg:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
		ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)

		UTIL_Remove(egg)
	end
end

function aspect_of_solos_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro then
		if not ability.fv then
			ability.fv = caster:GetForwardVector()
		end
		local luck = RandomInt(1, 42)
		if luck == 1 then
			EmitSoundOn("Winterblight.SunPhoenixBoss.VO", caster)
		end
		EmitSoundOn("Winterblight.AspectOfSolos.Flamethrower", caster)
		local start_radius = 120
		local end_radius = 200
		local range = 2000
		local speed = 2000

		local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin() + ability.fv * 30 + Vector(0, 0, 80),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = ability.fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
		ability.fv = WallPhysics:rotateVector(ability.fv, 2*math.pi/30)
	end
end

function aspect_of_solos_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_doom_bringer/doom_loadout.vpcf", target, 4)
	EmitSoundOn("Winterblight.SunBurn.Activate", target)
	Enemies:ApplyDamageToPlayer(target, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
end

function aspect_of_solos_die(event)
	local caster = event.caster
	Timers:CreateTimer(3.1, function()
		local particleName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() + Vector(0,0,500) - caster:GetForwardVector()*120)
		ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
		ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
		EmitSoundOn("Winterblight.SunPhoenixEvent.Egg.Explode", caster)
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		UTIL_Remove(caster)
	end)
end

function vorthrex_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.dying then
		return false
	end
	if caster.aggro then
		local castAbility = caster:FindAbilityByName("winterblight_vorethrex_dash")
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
			end
			return true
		end
	end
	if caster:GetHealth() < 100 then
		if caster.fight_phase == 0 then
			caster.dying = true
			EmitSoundOn("Winterblight.Vorethrex.Die.Pop", caster)
			EmitSoundOn("Winterblight.Vorethrex.Die.VO1", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_vorethrex_dying_think", {})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_vorethrex_disabled", {})
			caster.deathPhase = 0	
			Timers:CreateTimer(3, function()
				caster:RemoveModifierByName("modifier_vorethrex_dying_think")
				EmitSoundOn("Winterblight.Vorethrex.Aggro", caster)
				Timers:CreateTimer(1.5, function()
					StartAnimation(caster, {duration = 3.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.6})
					EmitSoundOn("Winterblight.Vorethrex.Summon.VO", caster)
					local perpFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/4)
					for i = -1, 1, 1 do
						local skullPosition = caster:GetAbsOrigin() + caster:GetForwardVector()*480 + perpFV*400*i
						local skull = CreateUnitByName("npc_dummy_unit", skullPosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
						skull:SetAbsOrigin(skull:GetAbsOrigin() + Vector(0,0,1000))
						skull:SetModelScale(4)
						skull:SetModel("models/heroes/silencer/silencer_curse_skull.vmdl")
						skull:SetOriginalModel("models/heroes/silencer/silencer_curse_skull.vmdl")
						local dummy_ability = skull:FindAbilityByName("dummy_unit")
						dummy_ability:SetLevel(1)
						dummy_ability:ApplyDataDrivenModifier(skull, skull, "dummy_unit", {})
						skull:SetForwardVector(caster:GetForwardVector())
						Events:smoothTranslate(skull, Vector(0,0,-40), 25, Vector(0,0), nil)
						Timers:CreateTimer(0.75, function()
							if i == -1 then
								skull.boss_spawn = "winterblight_baron_moredi"
							elseif i == 0 then
								skull.boss_spawn = "winterblight_lich_king_sonder"
							elseif i == 1 then
								skull.boss_spawn = "winterblight_wrath_queen_asyria"
							end
							local miniboss = Enemies:SpawnEnemyUnit(skull.boss_spawn, skull:GetAbsOrigin(), skull:GetForwardVector(), false)
							Winterblight:EvilExplosion(miniboss:GetAbsOrigin())
							EmitSoundOn("Winterblight.EvilExplosion.Main", miniboss)
							EmitSoundOn("Winterblight.EvilExplosion.Highlight", miniboss)
							Timers:CreateTimer(0.2, function()
								Dungeons:AggroUnit(miniboss)
							end)
							UTIL_Remove(skull)
						end)
					end
					Timers:CreateTimer(1.1, function()
						StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1})
						EmitSoundOn("Winterblight.Vorethrex.GodsStrength.VO", caster)
					end)
					Timers:CreateTimer(1.5, function()
						caster.fight_phase = 1
						caster.dying = false
						caster:RemoveModifierByName("modifier_vorethrex_disabled")
						EmitSoundOn("Winterblight.Vorethrex.GodsStrength", caster)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_vorethrex_phase_2", {})
						EmitSoundOn("particles/units/heroes/hero_sven/sven_loadout.vpcf", caster)
					end)
				end)
			end)					
		elseif caster.fight_phase == 1 then
			AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 10, false)
			EmitSoundOn("Winterblight.Vorethrex.Die.Pop", caster)
			caster.dying = true
			EmitSoundOn("Winterblight.Vorethrex.No.Vo", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_vorethrex_dying_think", {})
			caster.deathPhase = 1
			caster:BossDrops(12)
			Timers:CreateTimer(2, function()
				EmitSoundOn("Winterblight.Vorethrex.Die.VO1", caster)
			end)
			Timers:CreateTimer(4, function()
				StartAnimation(caster, {duration = 8.0, activity = ACT_DOTA_DIE, rate = 1})
				caster.deathPhase = 2
				EmitSoundOn("Winterblight.Vorethrex.Die.VO2", caster)
				Events:objectShake(caster, 70, 25, true, false, true, "Winterblight.Vorethrex.Die.Shake", 50)
				Events:smoothTranslate(caster, Vector(0,0,1), 70, Vector(0,0,0.08), nil)
				Timers:CreateTimer(2.15, function()
					Enemies:EnemySlain(caster, nil)
					CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossEntityIndex = caster:GetEntityIndex()})
					Winterblight:EvilExplosion(caster:GetAbsOrigin())
					EmitSoundOn("Winterblight.EvilExplosion.Highlight", caster)
					EmitSoundOn("Winterblight.Tombstone.Explode", caster)
					local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
					local radius = 800
					local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 1000))
					ParticleManager:SetParticleControl(particle1, 3, Vector(radius, radius, radius))
					Timers:CreateTimer(3, function()
						ParticleManager:DestroyParticle(particle1, false)
					end)
					local immortal_luck = RandomInt(1, 3)
					local position = caster:GetAbsOrigin()
					Timers:CreateTimer(3, function()
						Winterblight:MithrilReward(position, "world_commander")
					end)
					if immortal_luck == 1 then
						RPCItems:RollAndDropUniqueItem(caster, "item_rpc_dissimilation_greaves")
					elseif immortal_luck == 2 then
						RPCItems:RollAndDropUniqueItem(caster, "item_rpc_lich_kings_gaze")
					elseif immortal_luck == 3 then
						RPCItems:RollAndDropUniqueItem(caster, "item_rpc_world_commander_gloves")
					end
					UTIL_Remove(caster)
				end)
			end)
			for j = 1, 3 + GameState:GetPlayerPremiumStatusCount() * 2, 1 do
				Timers:CreateTimer(j * 0.3, function()
					Winterblight:DropGlacierStone(caster:GetAbsOrigin())
				end)
			end
			Timers:CreateTimer(2, function()
				for j = 1, Winterblight.Stones, 1 do
					Timers:CreateTimer(j, function()
						RPCItems:DropSynthesisVessel(boss:GetAbsOrigin())
					end)
				end
			end)
		end
	end
end

function vorthrex_dying_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.deathPhase == 0 then
		caster:SetHealth(caster:GetHealth() + caster:GetMaxHealth()*0.01)
	elseif caster.deathPhase == 1 then
		
		if not caster.soundInterval then
			caster.soundInterval = 0
		end
		if caster.soundInterval % 40 == 0 then
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/boss_dying_tgt.vpcf", caster:GetAbsOrigin() + Vector(0, 0, 300), 3)
			EmitSoundOn("Winterblight.Vorethrex.DyingThink", caster)
		end
		caster.soundInterval = caster.soundInterval + 1
	elseif caster.deathPhase == 2 then
		local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 60)
		caster:SetForwardVector(rotatedFV)
	end

end

function vorethrex_dash_start(event)
	local caster = event.caster
	local ability = event.ability

	
	EmitSoundOn("Winterblight.Vorethrex.Die.VO1", caster)

	-- WallPhysics:Jump(caster, caster:GetForwardVector(), 50, 15, 2, 0.7)
	ability.forwardVec = ((event.target_points[1] - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	-- WallPhysics:JumpFixedDistanceWithBlocking(caster, caster:GetForwardVector(), 400, 15, 50, 1, 1)
	Timers:CreateTimer(0.1, function()
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", caster)
	end)
	local dash_duration = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), event.target_points[1])/1800 + 0.3
	StartAnimation(caster, {duration = dash_duration, activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1})
	caster:RemoveModifierByName("modifier_crusader_dash")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_vorethrex_dash", {duration = dash_duration})

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Vorethrex.Dash.Main", caster)
	local info =
	{
		Ability = ability,
		EffectName = "particles/roshpit/winterblight/vorethrex_dash_projectile.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 70) - ability.forwardVec * 300,
		fDistance = 1600,
		fStartRadius = 260,
		fEndRadius = 260,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = ability.forwardVec * 1600,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

end

function vorethrex_dash_think(event)
	local ability = event.ability
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local obstruction = WallPhysics:FindNearestObstruction(position)
	local pushSpeed = 55
	pushSpeed = Filters:GetAdjustedESpeed(caster, pushSpeed, false)
	local newPosition = position + ability.forwardVec * pushSpeed
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (position + ability.forwardVec * 72), caster)
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end

end

function vorethrex_dash_end(event)
	local caster = event.caster
	local ability = event.ability
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
end

function vorethrex_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Winterblight.Vorethrex.DashProjectileHit", target)
	Enemies:ApplyDamageToPlayer(target, caster, event.damage, DAMAGE_TYPE_MAGICAL, ability)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_vorethrex_dash_debuff", {duration = event.debuff_duration})
end

function world_pad_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	CustomAbilities:QuickParticleAtPoint("particles/econ/world/towers/rock_golem/radiant_rock_golem_destruction_sparkle.vpcf", target:GetAbsOrigin(), 3)
	if #enemies > 0 then
		target:RemoveModifierByName("modifier_diviner_world_pad_think")
		local room_index = target.room_index
		EmitSoundOn("Winterblight.Vorethrex.WorldPlatform.Pop", target)
		EmitSoundOn("Winterblight.Vorethrex.WorldPlatform.Pop2", target)
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/world_pad_pop_impact.vpcf", target:GetAbsOrigin()+Vector(0,0,100), 3)
		ParticleManager:SetParticleControl(pfx, 3, target:GetAbsOrigin())
		SpecialFX:ColoredPop(target:GetAbsOrigin()+Vector(0,0,80), Vector(140, 180, 255))
		Winterblight.ActiveCastleRoom = Winterblight.CASTLE_DATA["rooms"][room_index]
		Winterblight.ActiveCastleRoom["active"] = 1
		Timers:CreateTimer(1, function()
			Winterblight.CastleTarot["rooms"][Winterblight.CASTLE_DATA["rooms_cleared"] + 1] = {index = room_index, variant = 1}
			Winterblight:CastleNextRoomInit()
		end)
		for i = 1, #Winterblight.CastleDungeonMaster.world_pad_table, 1 do
			if Winterblight.CastleDungeonMaster.world_pad_table[i] == target then
				Events:smoothTranslate(Winterblight.CastleDungeonMaster.world_pad_table[i], Vector(0,0,-4), 30, Vector(0,0), nil)
				Timers:CreateTimer(1, function()
					UTIL_Remove(Winterblight.CastleDungeonMaster.world_pad_table[i])
				end)
			else
				Winterblight.CastleDungeonMaster.world_pad_table[i]:RemoveModifierByName("modifier_diviner_world_pad_think")
				UTIL_Remove(Winterblight.CastleDungeonMaster.world_pad_table[i])
			end
		end
	end
end

function winter_castle_judge_think(event)
	local caster = event.caster
	local ability = event.ability
	local judge = event.target	
	if not judge.final_phase then
		return false
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, judge:GetAbsOrigin(), 600, 2, false)
	if judge.final_phase == 0 then
		local target_position = Vector(11648, -1280)
		judge:MoveToPosition(target_position)
		if WallPhysics:GetDistance2d(target_position, judge:GetAbsOrigin()) < 100 then
			judge:MoveToPosition(judge:GetAbsOrigin() + Vector(0,-80))
			Winterblight:OpenCastleDoorByIndex(11)
			judge.final_phase = 1
			Timers:CreateTimer(5, function()
				judge.final_phase = 2
			end)
		end
	elseif judge.final_phase == 2 then
		local target_position = Vector(10569, -2628)
		judge:MoveToPosition(target_position)
		if WallPhysics:GetDistance2d(target_position, judge:GetAbsOrigin()) < 100 then
			judge.final_phase = 3
			judge:MoveToPosition(judge:GetAbsOrigin() + Vector(0,-80))
		end	
	elseif judge.final_phase == 3 then
		local enemies = FindUnitsInRadius(judge:GetTeamNumber(), judge:GetAbsOrigin(), nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			StartAnimation(judge, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.25})
			EmitSoundOn("Winterblight.CastleJudge.OutVO", judge)
			judge.final_phase = 4
			local time = Winterblight.JudgementTotalTime
			local digits = {}
			digits[1] = math.floor(time/600)
			digits[2] = math.floor((time%600)/60)
			digits[3] = nil
			local seconds = time%60
			digits[4] = math.floor(seconds/10)
			digits[5] = seconds%10
			Timers:CreateTimer(2, function()
				for i = 1, 5, 1 do
					Timers:CreateTimer(i*0.6 - 0.45, function()
						StartAnimation(judge, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
					end)
					Timers:CreateTimer(i*0.6, function()
						local prop_point = judge:GetAbsOrigin() + judge:GetForwardVector()*300 + Vector(-300, 0) + Vector(150*(i-1), 0)
						local time_prop = CreateUnitByName("npc_dummy_unit", prop_point, false, nil, nil, DOTA_TEAM_NEUTRALS)
						time_prop:SetRenderColor(100, 140, 255)
						time_prop:SetModelScale(1)
						-- time_prop:SetModel("models/heroes/wisp/wisp_additive.vmdl")
						-- time_prop:SetOriginalModel("models/heroes/wisp/wisp_additive.vmdl")
						SpecialFX:ColoredPop(time_prop:GetAbsOrigin()+Vector(0,0,20), Vector(0, 240, 255))
						EmitSoundOn("Winterblight.CastleJudge.PropSpawn", time_prop)
						table.insert(judge.props_table, time_prop)
						if digits[i] then
							time_prop.counter_pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/judgement_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, time_prop)
							ParticleManager:SetParticleControlEnt(time_prop.counter_pfx, 0, time_prop, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", time_prop:GetAbsOrigin(), true)
							ParticleManager:SetParticleControl(time_prop.counter_pfx, 1, Vector(0, digits[i], 0))
						else
							time_prop.counter_pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/judgement_delimiter.vpcf", PATTACH_OVERHEAD_FOLLOW, time_prop)
							ParticleManager:SetParticleControlEnt(time_prop.counter_pfx, 0, time_prop, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", time_prop:GetAbsOrigin(), true)
							ParticleManager:SetParticleControl(time_prop.counter_pfx, 1, Vector(0, digits[i], 0))
						end
					end)
				end
				Timers:CreateTimer(7, function()
					-- for i = 1, #judge.props_table, 1 do
					-- 	SpecialFX:ColoredPop(judge.props_table[i]:GetAbsOrigin()+Vector(0,0,20), Vector(0, 240, 255))
					-- 	if judge.props_table[i].counter_pfx then
					-- 		ParticleManager:DestroyParticle(judge.props_table[i].counter_pfx, false)
					-- 	end
					-- 	UTIL_Remove(judge.props_table[i])
					-- end
					if Winterblight.JudgementTotalTime > 900 then
						CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", judge:GetAbsOrigin(), 3)
						EmitSoundOn("Winterblight.GraveGhostSpawn", judge)
						EmitSoundOn("Winterblight.CastleJudge.OutVO", judge)
						UTIL_Remove(judge)
					else
						judge.final_phase = 5
					end
				end)
			end)
		end	
	elseif judge.final_phase == 5 then
		local target_position = Vector(9752, -2921)
		judge:MoveToPosition(target_position)
		if WallPhysics:GetDistance2d(target_position, judge:GetAbsOrigin()) < 100 then
			judge.final_phase = 6
			judge:MoveToPosition(judge:GetAbsOrigin() + Vector(-20,20))
			StartAnimation(judge, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
			EmitSoundOn("Winterblight.CastleJudge.ChestVO", judge)
			Timers:CreateTimer(0.45, function()
				EmitSoundOn("Winterblight.CastleJudge.PropSpawn", judge)
				Winterblight:GeneralChestSpawn(Vector(9498, -2670), Vector(1,-1))
			end)
			Timers:CreateTimer(2, function()
				if Winterblight.JudgementTotalTime > 600 then
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", judge:GetAbsOrigin(), 3)
					EmitSoundOn("Winterblight.GraveGhostSpawn", judge)
					EmitSoundOn("Winterblight.CastleJudge.OutVO", judge)
					UTIL_Remove(judge)
				else
					judge.final_phase = 7
				end	
			end)		
		end		
	elseif judge.final_phase == 7 then
		local target_position = Vector(10351, -2560)
		judge:MoveToPosition(target_position)
		if WallPhysics:GetDistance2d(target_position, judge:GetAbsOrigin()) < 100 then
			judge.final_phase = 8
			judge:MoveToPosition(judge:GetAbsOrigin() + Vector(-20,20))
			StartAnimation(judge, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
			EmitSoundOn("Winterblight.CastleJudge.ChestVO", judge)
			Timers:CreateTimer(0.45, function()
				EmitSoundOn("Winterblight.CastleJudge.PropSpawn", judge)
				Winterblight:GeneralChestSpawn(Vector(10130, -2278), Vector(1,-1))
			end)
			Timers:CreateTimer(2, function()
				if Winterblight.JudgementTotalTime > 420 then
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", judge:GetAbsOrigin(), 3)
					EmitSoundOn("Winterblight.GraveGhostSpawn", judge)
					EmitSoundOn("Winterblight.CastleJudge.OutVO", judge)
					UTIL_Remove(judge)
				else
					judge.final_phase = 9
				end	
			end)		
		end		
	elseif judge.final_phase == 9 then
		local target_position = Vector(10990, -2207)
		judge:MoveToPosition(target_position)
		if WallPhysics:GetDistance2d(target_position, judge:GetAbsOrigin()) < 100 then
			judge.final_phase = 10
			judge:MoveToPosition(judge:GetAbsOrigin() + Vector(-20,20))
			StartAnimation(judge, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
			EmitSoundOn("Winterblight.CastleJudge.ChestVO", judge)
			Timers:CreateTimer(0.45, function()
				EmitSoundOn("Winterblight.CastleJudge.PropSpawn", judge)
				Winterblight:GeneralChestSpawn(Vector(10746, -1902), Vector(1,-1))
			end)
			Timers:CreateTimer(2, function()
				if Winterblight.JudgementTotalTime > 300 then
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", judge:GetAbsOrigin(), 3)
					EmitSoundOn("Winterblight.GraveGhostSpawn", judge)
					EmitSoundOn("Winterblight.CastleJudge.OutVO", judge)
					UTIL_Remove(judge)
				else
					judge.final_phase = 11
				end	
			end)		
		end	
	elseif judge.final_phase == 11 then
		local target_position = Vector(11008, -2688)
		judge:MoveToPosition(target_position)
		if WallPhysics:GetDistance2d(target_position, judge:GetAbsOrigin()) < 100 then	
			judge.final_phase = 12
			Timers:CreateTimer(2, function()
				EmitSoundOn("Winterblight.CastleJudge.FinalEventVO", judge)
				Events:objectShake(judge, 70, 15, true, false, true, "Winterblight.CastleJudge.OutShake", 16)
				Timers:CreateTimer(0.5, function()
					EmitSoundOn("Winterblight.GuideCave.Magical", judge)
				end)
				Timers:CreateTimer(2.2, function()
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", judge:GetAbsOrigin(), 3)
					EmitSoundOn("Winterblight.GraveGhostSpawn", judge)
					EmitSoundOn("Winterblight.CastleJudge.OutVO", judge)

					local particle = "particles/units/heroes/hero_warlock/charge_of_light.vpcf"
					local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, judge)
					ParticleManager:SetParticleControl(pfx, 0, judge:GetAbsOrigin())
					ParticleManager:SetParticleControl(pfx, 1, judge:GetAbsOrigin())
					ParticleManager:SetParticleControl(pfx, 2, judge:GetForwardVector())
					Timers:CreateTimer(2.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					local miniboss = Winterblight:SpawnCastleRoomUnit(0, "winterblight_paragon_of_judgement", judge:GetAbsOrigin(), Vector(0,-1), false, true)
					EmitSoundOn("Winterblight.ParagonOfJudgement.SpawnEffect", miniboss)
					Dungeons:AggroUnit(miniboss)
					UTIL_Remove(judge)				
					miniboss:AddLootDrop("immortal", "item_rpc_breastplate_of_abjudication", 100)
				end)
			end)
		end	
	end
end

function paragon_of_judgement_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target	

	local impact_damage = event.impact_damage
	local stun_duration = event.stun_duration
	local stun_chance = event.stun_chance
	local luck = RandomInt(1, 100)
	if luck <= stun_chance then
		CustomAbilities:QuickAttachParticle("particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", target, 3)
		EmitSoundOn("Winterblight.ParagonOfJudgement.Bash", target)
		Enemies:ApplyDamageToPlayer(target, caster, impact_damage, DAMAGE_TYPE_PURE, ability)
		Filters:ApplyStun(caster, stun_duration, target)
	end
end

function judgement_spark_phase(event)
	local caster = event.caster
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.8})
	EmitSoundOn("Winterblight.Cavern.WraithSpark.Pre", caster)
end

function judgement_spark_throw(event)
	local caster = event.caster
	local ability = event.ability
	local spark_count = 3
	local base_damage = event.base_damage
	ability.damage = base_damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.percent_attack_power/100)
	EmitSoundOn("Winterblight.ParagonOfJudgement.CastVO", caster)
	ability.paralyze_duration = event.paralyze_duration
	local particle = "particles/units/heroes/hero_alchemist/charge_of_light_linear_projectile_concoction_projectile_linear.vpcf"
	local range = 2000
	local divisor = 15
	if spark_count == 3 then
		divisor = 17
	elseif spark_count == 4 then
		divisor = 18
	elseif spark_count == 5 then
		divisor = 22
	end
	EmitSoundOn("Winterblight.ParagonOfJudgement.Cast", caster)
	for i = 1, spark_count, 1 do
		local rotation_adjustment = spark_count / 2
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * (i - rotation_adjustment) / divisor)
		local speed = 1500
		local info =
		{
			Ability = ability,
			EffectName = particle,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 140),
			fDistance = range,
			fStartRadius = 220,
			fEndRadius = 220,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function judgement_spark_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local paralyze_duration = ability.paralyze_duration

	local current_stacks = target:GetModifierStackCount("modifier_judgement_spark_paralyze_immunity", target)
	local paralyze_immunity = 1
	if current_stacks <= 5 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_judgement_spark_paralyze_immunity", {duration = paralyze_immunity})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_judgement_spark_paralyze", {duration = paralyze_duration})
		target:SetModifierStackCount("modifier_judgement_spark_paralyze_immunity", caster, current_stacks + 1)
	end
	StartAnimation(target, {duration = paralyze_duration, activity = ACT_DOTA_FLAIL, rate = 2.2})
	EmitSoundOn("Winterblight.ParagonOfJudgement.SpellImpact", target)
	local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, target:GetBoundingMaxs().z + 40))
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, target:GetBoundingMaxs().z + 60))
	Timers:CreateTimer(0.3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Enemies:ApplyDamageToPlayer(target, caster, ability.damage, DAMAGE_TYPE_MAGICAL, ability)
end

function use_winterblight_tarot_card(event)
	local item = event.ability
	local caster = event.caster
	if not Winterblight.CastleDungeonMaster then
		Notifications:Top(caster:GetPlayerOwnerID(), {text = "winterblight_tarot_card_use_fail_2", duration = 2, style = {color = "red"}, continue = true})
		item:StartCooldown(2)
		return false
	end
	if Winterblight.CastleTarot then
		Notifications:Top(caster:GetPlayerOwnerID(), {text = "winterblight_tarot_card_use_fail_1", duration = 2, style = {color = "red"}, continue = true})
		item:StartCooldown(2)
		return false
	end
	local allowable_position = Vector(11807, 13248)
	local distance_to_allowable_position = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), allowable_position)
	if distance_to_allowable_position > 300 then
		Notifications:Top(caster:GetPlayerOwnerID(), {text = "winterblight_tarot_card_use_fail_2", duration = 2, style = {color = "red"}, continue = true})
		item:StartCooldown(2)
		return false
	end

	UTIL_Remove(item)
	CustomGameEventManager:Send_ServerToAllClients("close_wb_castle_tarot", {})
	local tarot_target = nil
	for i = 1, #Winterblight.CASTLE_DATA["tarot"], 1 do
		if string.match(Winterblight.CASTLE_DATA["tarot"][i]["name"], string.gsub(item.newItemTable.property1name, "tarot_", "")) then
			tarot_target = i
			break
		end
	end
	local card_prop = Entities:FindByNameNearest("tarot_card_prop_xtra", Vector(11807, 13042, 1400), 1000)

	Winterblight.CastleTarot = Winterblight.CASTLE_DATA["tarot"][tarot_target]

	StartAnimation(Winterblight.CastleDungeonMaster, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
	Timers:CreateTimer(2, function()
		EmitSoundOn("Winterblight.Horus.CardThrow.VO", Winterblight.CastleDungeonMaster)
	end)
	Winterblight.CastleDungeonMaster:MoveToPosition(Vector(11800, 13400))
	Winterblight.CastleDungeonMaster.phase = 2
	Winterblight.OverrideIntroThrow = true
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
	EmitSoundOnLocationWithCaster(card_prop:GetAbsOrigin(), "Winterblight.Horus.Throw", caster)
	card_prop:SetAbsOrigin(Vector(11808, 13046, 2180))
	Events:smoothTranslate(card_prop, Vector(0,0,-40), 15, Vector(0,0), nil)
	Timers:CreateTimer(0.35, function()
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/castle_tarot_splash.vpcf", Vector(11808, 13046, 1767), 5)
		EmitSoundOnLocationWithCaster(card_prop:GetAbsOrigin(), "Winterblight.TarotCard.Dunk", caster)
		ScreenShake(Vector(11808, 13046, 1767), 800, 1, 1, 9000, 0, true)
	end)

	-- REPEATED CODE DOWN HERE
	Timers:CreateTimer(1, function()
		local model_name = "models/winterblight/tarot/"..Winterblight.CastleTarot["index"].."-"..Winterblight.CastleTarot["name"]..".vmdl"
		local function precache_function()
			
		end
		PrecacheUnitByNameAsync(model_name, precache_function)
	end)
	Timers:CreateTimer(2, function()
		Winterblight:PrecacheTarotAssets()
	end)
	if Winterblight.CastleTarot["name"] == "hanged_man" then
		Winterblight:HangedManPrepareHashMap()
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		Winterblight:TemperanceWaterProps()
		Winterblight.TemperanceDungeonStartTime = GameRules:GetGameTime()
	elseif Winterblight.CastleTarot["name"] == "devil" then
		Winterblight:DevilBloodProps()
	elseif Winterblight.CastleTarot["name"] == "moon" then
		Winterblight:CastleMoonProps()
	end
end

function xelethar_thinker(event)
	local ability = event.ability
	local caster = event.caster
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro then
		local trap_radius = 360
		local trap_move_speed = 25

		if not caster.pfx then
			local particleName = "particles/roshpit/winterblight/xelethar_passive.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 5, Vector(trap_radius, 2, 100))
			caster.pfx = pfx
		end

		if not caster.angle then
			caster.angle = 0
		end
		if not caster.startHeight then
			caster.startHeight = caster:GetAbsOrigin().z
		end
		if not caster.interval then
			caster.interval = 0
		end
		if not caster.projectile_interval then
			caster.projectile_interval = 0
		end
		if not caster.moveFV then
			caster.moveFV = caster:GetForwardVector()
		end


		local newPosition = GetGroundPosition(caster:GetAbsOrigin() + caster.moveFV*trap_move_speed, caster) + Vector(0,0,10) 
		local obstruction_search_position = newPosition + caster.moveFV*400
		local obstruction = WallPhysics:FindNearestObstruction(obstruction_search_position)
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, obstruction_search_position, caster)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(11393, 163))
		if distance > 1200 then
			blockUnit = true
		end
		if blockUnit then
			local newFV = WallPhysics:rotateVector(caster.moveFV, 2*math.pi/RandomInt(2, 8)) 
			-- newFV = WallPhysics:rotateVector(newFV, 2*math.pi*RandomInt(-3, 3)/60)
			caster.moveFV = newFV
			-- EmitSoundOn("Winterblight.SpinBlade.WallBounce", caster)
			-- CustomAbilities:QuickParticleAtPoint("particles/dire_fx/bad_stuff_end_sparks.vpcf", caster:GetAbsOrigin(), 3)
			-- caster:SetAbsOrigin(caster:GetAbsOrigin() + cas)
		else
			caster:SetAbsOrigin(newPosition)
		end
		caster.interval = caster.interval + 1
		caster.projectile_interval = caster.projectile_interval + 1
		if caster.interval >= 3 then
			caster.interval = 0
			local damage = event.damage_base
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, trap_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, victim in pairs(enemies) do
					local victim_damage = math.floor(damage + (event.damage_pct_max_health/100)*victim:GetMaxHealth())
					Enemies:ApplyDamageToPlayer(victim, caster, victim_damage, DAMAGE_TYPE_PURE, ability)
					PopupDamage(victim, victim_damage)
					EmitSoundOn("Winterblight.HighPriestXelethar.PassiveHit", victim)
				end
			end
		end
		local interval_reduction = (1 - (caster:GetHealth()/caster:GetMaxHealth()))*50
		if caster.projectile_interval >= (70 - interval_reduction) then
			caster.projectile_interval = 0
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin()+caster:GetForwardVector()*600, nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies == 0 then
				xelethar_projectile_create(caster, ability, RandomInt(20, 40), caster:GetForwardVector())
			else
				local speed = math.max(10, WallPhysics:GetDistance2d(enemies[1]:GetAbsOrigin(), caster:GetAbsOrigin())/42)
				local targetPoint = enemies[1]:GetAbsOrigin() + enemies[1]:GetForwardVector()*300
				local fv = ((targetPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				xelethar_projectile_create(caster, ability, speed, fv)
			end
		end
	else
		if not caster.anim_interval then
			caster.anim_interval = RandomInt(0, 89)
		end
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 8) * math.cos(2 * math.pi * caster.anim_interval / 90))
		caster.anim_interval = caster.anim_interval + 1
		local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 180)
		caster:SetForwardVector(rotatedFV)
		if caster.anim_interval == 90 then
			caster.anim_interval = 0
		end
	end
end

function xelethar_projectile_create(caster, ability, speed, direction)
	local position = caster:GetAttachmentOrigin(0)


	local projectile = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.6})
	projectile:SetModelScale(3.0)
	projectile:SetAbsOrigin(position + Vector(0,0,400))
	ability:ApplyDataDrivenModifier(caster, projectile, "modifier_xelethar_projectile", {})
	
	projectile.dummy = true
	projectile:FindAbilityByName("dummy_unit"):SetLevel(1)

	-- projectile:SetModel("models/heroes/silencer/silencer_curse_skull.vmdl")
	-- projectile:SetOriginalModel("models/heroes/silencer/silencer_curse_skull.vmdl")

	local projectileName = "particles/econ/items/storm_spirit/storm_spirit_orchid_hat/stormspirit_orchid_ball_lightning.vpcf"

	CustomAbilities:QuickAttachParticle(projectileName, projectile, 6)
	projectile.phase = 1
	EmitSoundOn("Winterblight.CastleBoss.HandProjectile.Create", projectile)
	projectile.forwardSpeed = speed
	projectile.direction = direction
			-- EmitSoundOn("Winterblight.CastleBoss.HandProjectile.Launch", projectile)
end

function xelethar_projectile_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local projectile = event.target
	if projectile.lock then
		return false
	end
	if not IsValidEntity(projectile) then
		return false
	end
	if not projectile.interval then
		projectile.interval = 0
	end
	projectile.interval = projectile.interval + 1
	if projectile.phase == 1 then
		if not projectile.direction then
			projectile.direction = caster:GetForwardVector()
		end
		local newPos = projectile:GetAbsOrigin() + projectile.direction*projectile.forwardSpeed - Vector(0,0,10)
		projectile:SetAbsOrigin(newPos)
		local distanceFromGround = projectile:GetDistanceFromGround()
		if distanceFromGround < 10 then
			EmitSoundOn("Winterblight.IceSummon", projectile)

			local radius = 500
			local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, Winterblight.Stargazer)
			ParticleManager:SetParticleControl(pfx, 0, projectile:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius*2))
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			projectile:RemoveModifierByName("modifier_xelethar_projectile")
			projectile.lock = true
			local damage = event.orb_damage
			local slow_duration = event.slow_duration
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), projectile:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Enemies:ApplyDamageToPlayer(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_xelethar_slow", {duration = slow_duration})
				end
			end
			UTIL_Remove(projectile)
		end
	end
end

function bishop_of_hades_dot_cast(event)
	local ability = event.ability
	local caster = event.caster
	local point = event.target_points[1]

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_bishop_of_hades_dot", {duration = 30})
		end
	end
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", point, 3)
	ParticleManager:SetParticleControl(pfx, 1, Vector(600, 2, 300))
	EmitSoundOnLocationWithCaster(point, "Winterblight.BishopOfHades.DotAOE", caster)
end

function bishop_of_hades_dot_damage(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	if not caster:IsAlive() then
		target:RemoveModifierByName("modifier_bishop_of_hades_dot")
		return false
	end
	Enemies:ApplyDamageToPlayer(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability)
end

function temperance_death(event)
	Winterblight.TemperanceChest = false
end

function star_dummy_think(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if target.lock then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		target.lock = true
		target:RemoveModifierByName("modifier_diviner_star_dummy_thinker")
		if not Winterblight.CastleStarQuestCount then
			Winterblight.CastleStarQuestCount = 0
		end
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Winterblight.Castle.StartActivate", target)
		local colorVector = Vector(147, 151, 54)
		Events:smoothColorTransition(target, target.colorVector, colorVector, 15)
		target.colorVector = colorVector
		Winterblight.CastleStarQuestCount = Winterblight.CastleStarQuestCount + 1
		if Winterblight.CastleStarQuestCount == 5 then
			Winterblight:StarQuestBossSpawn(target:GetAbsOrigin())
		end
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", target:GetAbsOrigin(), 3)
	end
end

function star_boss_attack_hit(event)
	local damage = event.damage
	local target = event.target
	local ability = event.ability
	local attacker = event.attacker
	local key = target:GetEntityIndex() .. '_autumn_mage_attack_hit'
	Util.Common:LimitPerTime(4, 1, key .. '_sound_particles',function()
	CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_mage_starfall_attack.vpcf", target, 0.8)
	EmitSoundOn("Redfall.AutumnMage.StarStart", target)
		Timers:CreateTimer(0.6, function()
			EmitSoundOn("Redfall.FireballPassive", target)
			ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:ApplyDataDrivenModifier(attacker, target, "modifier_autumn_mage_debuff", {duration = 3})

		end)
	end)
end

function empress_emasz_init(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(2, function()
		caster:AddNewModifier(caster, ability, "modifier_persistent_invisibility", {})
	end)
end

function empress_emasz_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if #enemies > 0 then
			caster:MoveToTargetToAttack(enemies[1])
		end
		-- caster:RemoveModifierByName("modifier_persistent_invisibility")
	end
end

function empress_emasz_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_persistent_invisibility")
	Timers:CreateTimer(0.35, function()
		caster:AddNewModifier(caster, ability, "modifier_persistent_invisibility", {})
		SpecialFX:ColoredPop(caster:GetAbsOrigin()+Vector(0,0,150), Vector(255, 120, 120))
	end)
	SpecialFX:ColoredPop(caster:GetAbsOrigin()+Vector(0,0,150), Vector(255, 120, 120))
	local luck = RandomInt(1, 8)
	if luck == 1 then
		EmitSoundOn("Winterblight.Castle.Emasz.AtkVO", caster)
	end
end

function empress_emasz_die(event)
	local caster = event.caster
	Timers:CreateTimer(0.5, function()
		SpecialFX:ColoredSpotlight(caster:GetAbsOrigin(), Vector(245, 120, 60))
	end)
	Timers:CreateTimer(1.25, function()
		Events:smoothTranslate(caster, Vector(0,0,3), 140, Vector(0,0,0.1), nil)
	end)
	Timers:CreateTimer(2, function()
		Winterblight:DropEmperorQuestItem("empress", caster:GetAbsOrigin())
		-- Events:unitFVSpin(caster, 60, 120, -0.08, false)
	end)
end
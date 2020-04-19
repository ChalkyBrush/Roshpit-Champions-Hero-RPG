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
		if distance < 80 then
			caster.phase = 3
			Timers:CreateTimer(1, function()
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
							EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.Tarot.PianoSlamHorror", Events.GameMaster)
						else
							EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.Tarot.PianoSlam", Events.GameMaster)
						end
					end)
				end)
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
			Winterblight:CastleLobbySpawn1()
			Winterblight:CastleNextRoomInit()
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
		if Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"] == Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemy_spawn_count"] + Winterblight.CASTLE_DATA["rooms"][unit.room_index]["extra_goal"] then
			if Winterblight.ActiveCastleRoom["active"] == 2 then
				Winterblight.ActiveCastleRoom["active"] = 3
				Winterblight:CastleRoomEnemyGoalReached(unit.room_index)
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
		if Winterblight.CastleDungeonMaster.spider_invade_kills == 10 then
			for i = 1, 10, 1 do
				Timers:CreateTimer(0.7*i, function()
					local position = Vector(15104, 16232) + Vector(RandomInt(0, 1200), 0)
					local spider = Winterblight:SpawnCastleRoomUnit(2, "winterblight_invading_spider", position, RandomVector(1), false, false)
					spider:CrawlEnter(position, Vector(0,-1), "down", RandomInt(700, 1000), 8)
					spider.deathCode = "invading_spiderling"
				end)
			end
			for i = 1, 10, 1 do
				Timers:CreateTimer(0.7*i, function()
					local position = Vector(16279, 15198) + Vector(0, RandomInt(0, 850))
					local spider = Winterblight:SpawnCastleRoomUnit(2, "winterblight_invading_spider", position, RandomVector(1), false, false)
					spider:CrawlEnter(position, Vector(-1,0), "down", RandomInt(700, 1000), 8)
					spider.deathCode = "invading_spiderling"
				end)
			end
		elseif Winterblight.CastleDungeonMaster.spider_invade_kills == 28 then
			for i = 1, 10, 1 do
				Timers:CreateTimer(0.7*i, function()
					local position = Vector(15104, 16232) + Vector(RandomInt(0, 1200), 0)
					local spider = Winterblight:SpawnCastleRoomUnit(2, "winterblight_invading_spider", position, RandomVector(1), false, false)
					spider:CrawlEnter(position, Vector(0,-1), "down", RandomInt(700, 1000), 8)
					spider.deathCode = "invading_spiderling"
				end)
			end
			for i = 1, 10, 1 do
				Timers:CreateTimer(0.7*i, function()
					local position = Vector(16279, 15198) + Vector(0, RandomInt(0, 850))
					local spider = Winterblight:SpawnCastleRoomUnit(2, "winterblight_invading_spider", position, RandomVector(1), false, false)
					spider:CrawlEnter(position, Vector(-1,0), "down", RandomInt(700, 1000), 8)
					spider.deathCode = "invading_spiderling"
				end)
			end
			Timers:CreateTimer(6.5, function()
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
			for i = 1, 10 + GameState:GetDifficultyFactor()*2, 1 do
				Timers:CreateTimer(i*delay, function()
					Winterblight:DropRoom9IcicleAtRandomPosition()
				end)
			end
			if Winterblight.CastleDungeonMaster.freezer_room_mob_deaths == 30 then
				Timers:CreateTimer(delay*(8 + GameState:GetDifficultyFactor()*2), function()
					Winterblight.CASTLE_DATA["rooms"][9]["active"] = 2
				end)
			end
		end
	elseif unit.deathCode == "blue_slime_room" then
		if not Winterblight.CastleDungeonMaster.blue_slime_deaths then
			Winterblight.CastleDungeonMaster.blue_slime_deaths = 0
		end
		Winterblight.CastleDungeonMaster.blue_slime_deaths = Winterblight.CastleDungeonMaster.blue_slime_deaths + 1
		if Winterblight.CastleDungeonMaster.blue_slime_deaths == 6 or Winterblight.CastleDungeonMaster.blue_slime_deaths == 22 or Winterblight.CastleDungeonMaster.blue_slime_deaths == 38 then
			for i = 1, 16, 1 do
				Timers:CreateTimer(i*0.75, function()
					Winterblight:SpawnSlimeRoomZombie()
				end)
			end	
		end	
		if Winterblight.CastleDungeonMaster.blue_slime_deaths == 38 then
			Timers:CreateTimer(10, function()
				Winterblight.CASTLE_DATA["rooms"][12]["active"] = 2
			end)
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
		Winterblight.CASTLE_DATA["rooms_cleared"] = Winterblight.CASTLE_DATA["rooms_cleared"] + 1
		if key.skull then
			EmitSoundOn("Winterblight.KeyCollect.Skull", key)
			Timers:CreateTimer(4, function()
				Winterblight:WinterCastleBossSpawn()
			end)
		else
			Winterblight:CastleNextRoomInit()
		end
		if Winterblight.CastleTarot["name"] == "empress" then
			master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, key.acquiring_hero, "modifier_diviner_empress_speed_boost", {duration = 90})
		end
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

function spike_trap_damage(event)
	local ability = event.ability
	local caster = event.caster
	local trap_dimension = 150
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
	else
		target:RemoveModifierByName("modifier_room_7_in_goo")
	end
end

function winter_armory_rock_destroy(event)
	local caster = event.caster
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/rock_explode.vpcf", caster:GetAbsOrigin(), 5)
	EmitSoundOn("Winterblight.BlueRock.Explode", caster)
	for j = -1, 1, 1 do
		local skeleton = Winterblight:SpawnCastleRoomUnit(8, "winterblight_sun_rubble", caster:GetAbsOrigin(), RandomVector(1), true, true)
		CustomAbilities:QuickParticleAtPoint("particles/neutral_fx/skeleton_spawn.vpcf", skeleton:GetAbsOrigin(), 4)
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
		Winterblight:SpawnTreasureRoomChests()
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
		target:SetAbsOrigin(target:GetAbsOrigin() + pullDirection*newStacks*0.5)
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
		local splash_particle = "particles/roshpit/rubilash/ink_splatter_blue.vpcf"
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
				end
				for i = 1, surrogate_count, 1 do
					local spawnPosition = caster:GetAbsOrigin()+RandomVector(RandomInt(600, 1400))
					local surrogate = Enemies:SpawnEnemyUnit("winterblight_castle_boss_surrogate", spawnPosition, Vector(0,-1), false)
					table.insert(caster.surrogates, surrogate)
					CustomAbilities:QuickParticleAtPoint("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", surrogate:GetAbsOrigin(), 4)
					EmitSoundOnLocationWithCaster(surrogate:GetAbsOrigin(), "Winterblight.CastleBoss.SurrogateSpawn", caster)
					Events:ColorWearablesAndBase(surrogate, Vector(50,50,50))
					surrogate:SetAbsOrigin(surrogate:GetAbsOrigin() + Vector(0,0,90))
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
	CustomGameEventManager:Send_ServerToAllClients("update_boss_health", {current_health = Winterblight.CastleBoss:GetHealth(), bossId = tostring(Winterblight.CastleBoss)})

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
			if #Winterblight.CastleBoss.main_ability.skullFrostTable < ((Winterblight.CastleBoss:GetMaxHealth() - Winterblight.CastleBoss:GetHealth())/Winterblight.CastleBoss:GetMaxHealth())*3.1 then
				print("ICE SKILL 1")
				if #Winterblight.CastleBoss.main_ability.skullFrostTable < 3 then
					print("ICE SKULL 2")
					ice_skull_create(Winterblight.CastleBoss, Winterblight.CastleBoss.main_ability)
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
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 4) * math.cos(2 * math.pi * caster.interval / 90))
	caster.interval = caster.interval + 1
	local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 90)
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
    
    if dummy.index == 3 then
   	 	dummy.rotationDelta = 160
   	elseif dummy.index == 2 then
   		dummy.rotationDelta = 120
   	elseif dummy.index == 1 then
   		dummy.rotationDelta = 80
   	end

    local baseFV = caster:GetForwardVector()
    local projectileFV = WallPhysics:rotateVector(baseFV, 2 * math.pi * dummy.index / dummy.rotationDelta)
    local pfx = ParticleManager:CreateParticle("particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_chain_frost.vpcf", PATTACH_CUSTOMORIGIN, caster)
    local base_position = GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,80)
    ParticleManager:SetParticleControl(pfx, 0, base_position)
    ParticleManager:SetParticleControl(pfx, 1, GetGroundPosition(caster:GetAbsOrigin() + projectileFV * 700 + Vector(0, 0, 80), caster))
    ParticleManager:SetParticleControl(pfx, 2, Vector(dummy.speed, dummy.speed, dummy.speed))
    dummy.pfx = pfx
    dummy.interval = 0
    dummy.dummy = true
    dummy.distance = 700
    if #ability.skullFrostTable == 1 then
    	dummy.distance = 1050
    elseif #ability.skullFrostTable == 2 then
    	dummy.distance = 1400
    end
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
									if ally:GetUnitName() == "winterblight_castle_boss_surrogate" then
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
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
	CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/scryer_stone_buildup.vpcf", caster, 2.5)
	EmitSoundOn("Winterblight.ScryersStone.Use", caster)
	Timers:CreateTimer(2, function()
		if caster.bgm == "Music.Winterblight.BlackfrostCitadel" then
			local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/scryer_stone_pop.vpcf", caster, 3.5)
			ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+Vector(0,0,30))
			if Winterblight.CastleBossMusic then
				local reveal_pos = Winterblight.CastleBoss:GetAbsOrigin()
				AddFOWViewer(caster:GetTeamNumber(), reveal_pos, 600, 10, false)
				MinimapEvent(caster:GetTeamNumber(), caster, reveal_pos.x, reveal_pos.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10)
				EmitSoundOnClient("Winterblight.ScryersStone.Ping", caster:GetPlayerOwner())
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.ScryersStone.Effect", caster)
				EmitSoundOnLocationWithCaster(reveal_pos, "Winterblight.ScryersStone.Effect", caster)
			elseif Winterblight.ActiveCastleRoom then
				if not Winterblight.CastleBossDead then
					local door_index = Winterblight.ActiveCastleRoom["door_index"]
					local door_position = Winterblight.CASTLE_DATA["doors"][door_index]["position"]
					AddFOWViewer(caster:GetTeamNumber(), door_position, 600, 10, false)
					MinimapEvent(caster:GetTeamNumber(), caster, door_position.x, door_position.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10)
					EmitSoundOnClient("Winterblight.ScryersStone.Ping", caster:GetPlayerOwner())
					local eyePosition = GetGroundPosition(door_position, Events.GameMaster) + Vector(0,0,400)
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.ScryersStone.Effect", caster)
					EmitSoundOnLocationWithCaster(door_position, "Winterblight.ScryersStone.Effect", caster)
				end
			end
			if Winterblight.CastleTarot["name"] == "high_priestess" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_diviner_high_priestess_heal", {duration = 15})
			elseif Winterblight.CastleTarot["name"] == "hierophant" then
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, caster, "modifier_diviner_hierophant_spirit_buff", {duration = 40})
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
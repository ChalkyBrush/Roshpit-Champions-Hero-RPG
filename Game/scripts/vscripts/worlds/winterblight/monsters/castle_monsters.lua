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
	Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"] = Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"] + 1
	-- print("----")
	-- print("ROOM UNIT DIE - Room: "..unit.room_index..", Total Slain: "..Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"])
	-- print("GOAL: "..Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemy_spawn_count"] + Winterblight.CASTLE_DATA["rooms"][unit.room_index]["extra_goal"])
	-- print("ROOM ACTIVE?: "..Winterblight.ActiveCastleRoom["active"])
	if Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemies_slain"] == Winterblight.CASTLE_DATA["rooms"][unit.room_index]["enemy_spawn_count"] + Winterblight.CASTLE_DATA["rooms"][unit.room_index]["extra_goal"] then
		if Winterblight.ActiveCastleRoom["active"] >= 2 then
			Winterblight:CastleRoomEnemyGoalReached(unit.room_index)
		end
	end

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
			end			
			Winterblight.CASTLE_DATA["rooms"][5]["active"] = 2
		end
	end
end

function castle_key_entering_think(event)
	local key = event.target
	if not key.fallSpeed then
		key.fallSpeed = 12
	end
	local distanceFromGround = key:GetDistanceFromGround()
	key.fallSpeed = math.max(key.fallSpeed - 0.1, 7)
	if distanceFromGround > 75 then
		key:SetAbsOrigin(key:GetAbsOrigin()-Vector(0,0,key.fallSpeed))
	else
		EmitSoundOn("Winterblight.GhostBlink", key)
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/treasure_explosion_colorable.vpcf", key:GetAbsOrigin(), 3)
		ParticleManager:SetParticleControl(pfx, 4, Vector(0.3, 0.8, 0.6))
		key:RemoveModifierByName("modifier_winter_castle_key_entering")
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, key, "modifier_winter_castle_key_waiting", {})
	end
	if not key.soundPlayed then
		if distanceFromGround < 140 then
			EmitSoundOn("Winterblight.KeySpawn.Land", key)
			key.soundPlayed = true
		end
	end
end

function castle_key_waiting_think(event)
	local key = event.target
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
		Winterblight:CastleNextRoomInit()
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
		key:SetAbsOrigin(key.acquiring_hero:GetAbsOrigin()+Vector(0,0,200))
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
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origic", caster:GetAbsOrigin(), true)
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
		CustomAbilities:QuickAttachParticle("particles/dire_fx/bad_stuff_end_sparks.vpcf", caster, 3)
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
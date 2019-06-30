if Dungeons == nil then
	Dungeons = class({})
end

require('dungeons/dungeon_desert_ruins')
require('dungeons/dungeon_grizzly_falls')
require('dungeons/dungeon_phoenix_nest')

function Dungeons:DebugSpot()
	local hermit = Dungeons:SpawnDungeonUnit("spine_hermit", Vector(13312, -9984), 1, 7, 9, "bristleback_bristle_attack_18", Vector(1, 1), false, nil)
	local hermitAbility = hermit:FindAbilityByName("hermit_leap")
	hermitAbility:ApplyDataDrivenModifier(hermit, hermit, "modifier_hermit_initial", {})
	hermit.jumpEnd = "hermit"

	--WALL
	local wallPoint1 = Vector(13192, -8708, 450)
	local wallPoint2 = Vector(13836, -8723, 420)
	local particle = "particles/units/heroes/hero_dark_seer/crixalis_wal_of_replica.vpcf"
	Dungeons.wallParticle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 0, wallPoint1)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 1, wallPoint2)
	Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(13376, -8766), Name = "wallObstruction"})
	Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(13504, -8766), Name = "wallObstruction"})
	Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(13632, -8766), Name = "wallObstruction"})
	Dungeons.blocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(13760, -8736), Name = "wallObstruction"})
	--WALL^
	--hermit--
	local thinker = Dungeons:CreateDungeonThinker(Vector(12964, -10048), "hermit", 480, "sand_tomb")
	thinker.hermit = hermit
end

function Dungeons:UnlockCamerasAndReturnToHero()
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
		end
		Timers:CreateTimer(0.05, function()
			if playerID then
				PlayerResource:SetCameraTarget(playerID, nil)
			end
		end)
	end
end

function Dungeons:UnlockCamerasAndReturnToHeroForUnits(units)
	for i = 1, #units, 1 do
		local playerID = units[i]:GetPlayerID()
		if playerID then
			PlayerResource:SetCameraTarget(playerID, units[i])
		end
		Timers:CreateTimer(0.05, function()
			if playerID then
				PlayerResource:SetCameraTarget(playerID, nil)
			end
		end)
	end
end

function Dungeons:CreateBasicCameraLock(position, duration)
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	-- visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	-- visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
	visionTracer:AddAbility("dummy_unit_vulnerable_cant_be_attacked"):SetLevel(1)
	visionTracer:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
	visionTracer:SetModelScale(0.05)
	visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin() - Vector(0, 0, 420))

	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	Timers:CreateTimer(0.6, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = duration})
				MAIN_HERO_TABLE[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, visionTracer)
			end
		end
	end)
	Timers:CreateTimer(duration, function()
		Dungeons:UnlockCamerasAndReturnToHero()
		UTIL_Remove(visionTracer)
	end)
end

function Dungeons:CreateBasicCameraLockForHeroes(position, duration, heroTable)
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	-- visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	-- visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
	visionTracer:AddAbility("dummy_unit_vulnerable_cant_be_attacked"):SetLevel(1)
	visionTracer:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
	visionTracer:SetModelScale(0.05)
	visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin() - Vector(0, 0, 420))

	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	Timers:CreateTimer(0.6, function()
		for i = 1, #heroTable, 1 do
			local playerID = heroTable[i]:GetPlayerID()
			if playerID then
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, heroTable[i], "modifier_disable_player", {duration = duration})
				heroTable[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, visionTracer)
			end
		end
	end)
	Timers:CreateTimer(duration, function()
		Dungeons:UnlockCamerasAndReturnToHero()
		UTIL_Remove(visionTracer)
	end)
end

function Dungeons:CreateBasicCameraLockNoVision(position, duration)
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	-- visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	-- visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
	visionTracer:AddAbility("dummy_unit_vulnerable_cant_be_attacked"):SetLevel(1)
	visionTracer:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
	visionTracer:SetModelScale(0.05)
	visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin() - Vector(0, 0, 420))

	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	Timers:CreateTimer(0.6, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = duration})
				MAIN_HERO_TABLE[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, visionTracer)
			end
		end
	end)
	Timers:CreateTimer(duration, function()
		Dungeons:UnlockCamerasAndReturnToHero()
		UTIL_Remove(visionTracer)
	end)
end

function Dungeons:LockCameraToUnitForAllPlayers(unit, duration)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = duration})
			MAIN_HERO_TABLE[i]:Stop()
			PlayerResource:SetCameraTarget(playerID, unit)
		end
	end
	Timers:CreateTimer(duration, function()
		Dungeons:UnlockCamerasAndReturnToHero()
	end)
end

function Dungeons:LockCameraToUnitForPlayers(unit, duration, heroTable)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	for i = 1, #heroTable, 1 do
		local playerID = heroTable[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, heroTable[i], "modifier_disable_player", {duration = duration})
			heroTable[i]:Stop()
			PlayerResource:SetCameraTarget(playerID, unit)
		end
	end
	Timers:CreateTimer(duration, function()
		for i = 1, #heroTable, 1 do
			local playerID = heroTable[i]:GetPlayerID()
			PlayerResource:SetCameraTarget(playerID, nil)
		end
	end)
end

function Dungeons:getPlayers()
	local hero1 = MAIN_HERO_TABLE[1]
	local player1 = hero1:GetPlayerOwnerID()
	local hero2 = nil
	local player2 = nil
	local hero3 = nil
	local player3 = nil
	local hero4 = nil
	local player4 = nil
	if #MAIN_HERO_TABLE >= 2 then
		hero2 = MAIN_HERO_TABLE[2]
		player2 = hero2:GetPlayerOwnerID()
		-- PlayerResource:GetConnectionState(player2)
	else
		return hero1:GetClassname(), player1, nil, nil, nil, nil, nil, nil
	end
	if #MAIN_HERO_TABLE >= 3 then
		hero3 = MAIN_HERO_TABLE[3]
		player3 = hero3:GetPlayerOwnerID()
	else
		return hero1:GetClassname(), player1, hero2:GetClassname(), player2, nil, nil, nil, nil
	end
	if #MAIN_HERO_TABLE >= 4 then
		hero4 = MAIN_HERO_TABLE[4]
		player4 = hero4:GetPlayerOwnerID()
	else
		return hero1:GetClassname(), player1, hero2:GetClassname(), player2, hero3:GetClassname(), player3, nil, nil
	end
	return hero1:GetClassname(), player1, hero2:GetClassname(), player2, hero3:GetClassname(), player3, hero4:GetClassname(), player4
end

function Dungeons:voteYesLua(keys)
	EmitGlobalSound("ui.npe_objective_complete")
	Dungeons.voteYes = Dungeons.voteYes + 1
	Dungeons:VoteEndCheck()
	CustomGameEventManager:Send_ServerToAllClients("receiveVote", {playerNumber = keys.playerNumber, status = true})
end

function Dungeons:voteNoLua(keys)
	EmitGlobalSound("ui.matchmaking_cancel")
	Dungeons.voteNo = Dungeons.voteNo + 1
	Dungeons:VoteEndCheck()
	CustomGameEventManager:Send_ServerToAllClients("receiveVote", {playerNumber = keys.playerNumber, status = false})
end

function Dungeons:VoteEndCheck()
	if (Dungeons.voteYes + Dungeons.voteNo) == RPCItems:GetConnectedPlayerCount() then
		Dungeons:VoteEnd()
	end
end

function Dungeons:VoteEnd()
	CustomGameEventManager:Send_ServerToAllClients("votingEnd", {})
	Beacons.expireVote = false
	if (Dungeons.voteYes + Dungeons.voteNo) < #MAIN_HERO_TABLE then
		Dungeons.voteYes = #MAIN_HERO_TABLE - Dungeons.voteNo
	end
	if Dungeons.voteYes > Dungeons.voteNo and Events.isTownActive then
		--vote passed
		Timers:CreateTimer(2, function()
			UTIL_Remove(Dungeons.beacon)
			Beacons.dungeonVote = false
			EmitGlobalSound("valve_ti5.stinger.dire_lose")
			CustomGameEventManager:Send_ServerToAllClients("top_notification", {image = Dungeons.imagePath, duration = 4.5, class = "shrink", style = nil, continue = "false", dungeonName = Dungeons.title})
			Dungeons:DungeonSpawnRedirict()
		end)
		local portalAbility = Events.portal:FindAbilityByName("town_portal")
		for i = 1, #MAIN_HERO_TABLE, 1 do
			Events:TeleportUnit(MAIN_HERO_TABLE[i], Dungeons.entryPoint, portalAbility, Events.portal, 1.5)
			MAIN_HERO_TABLE[i].lastPortalUsed = ""
		end
	else
		--vote failed
		Dungeons.entryPoint = nil
		Timers:CreateTimer(15, function()
			Beacons.dungeonVote = false
		end)
	end
end

function Dungeons:DungeonSpawnRedirict()
	for i = 1, #Beacons.WaveBeaconTable, 1 do
		UTIL_Remove(Beacons.WaveBeaconTable[i])
	end
	if Dungeons.title == "graveyard" then
		Dungeons:InitializeGraveyard()
	elseif Dungeons.title == "logging_camp" then
		Dungeons:InitializeLoggingCamp()
	elseif Dungeons.title == "sand_tomb" then
		Dungeons:InitializeSandTomb()
	elseif Dungeons.title == "vault" then
		Dungeons:InitializeVault()
	elseif Dungeons.title == "town_siege" then
		Dungeons:InitializeTownSiege()
	elseif Dungeons.title == "castle" then
		Dungeons:InitializeCastle()
	elseif Dungeons.title == "swamp" then
		Dungeons:InitializeSwamp()
	elseif Dungeons.title == "desert_ruins" then
		Dungeons:InitializeDesertRuins()
	elseif Dungeons.title == "grizzly_falls" then
		Dungeons:InitializeGrizzlyFalls()
	elseif Dungeons.title == "phoenix" then
		Dungeons:InitializePhoenixNest()
	end
	Challenges:StartDungeonTimer(Dungeons.title)
end

function Dungeons:SpawnDungeonUnit(unitName, spawnPoint, quantity, minDrops, maxDrops, aggroSound, fv, isAggro, special)
	for i = 1, quantity, 1 do
		local luck = RandomInt(1, 35)
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
		if special == "zombie_warrior" then
			Dungeons:attachWearables(unit, "attach_attack2", "models/items/axe/vanguard_armor/vanguard_armor.vmdl", 1.0)
			Dungeons:attachWearables(unit, "attach_attack1", "models/props_items/basher.vmdl", 1.0)
		elseif special == "bridgeBoss" then
			unit:SetModelScale(1.4)
			Dungeons:attachWearables(unit, "attach_attack1", "models/items/faceless_void/voidhammer/voidhammer.vmdl", 1.2)
			Dungeons:attachWearables(unit, "attach_head", "models/items/doom/baphomet_head/baphomet_head.vmdl", 1.1)
		elseif special == "raider" then
			Dungeons:attachWearables(unit, "attach_hitloc", "models/props_items/poor_man_shield01.vmdl", 1.0)
			Dungeons:attachWearables(unit, "attach_mouth", "models/items/sven/spartan_helmet.vmdl", 0.9)
		elseif special then
			unit.special = special
		end
		if fv then
			unit:SetForwardVector(fv)
		end
		if isAggro then
			Dungeons:AggroUnit(unit)
		end
		if quantity == 1 then
			return unit
		end
	end
end

function Dungeons:attachWearables(unit, attachPoint, model, scale)
	Attachments:AttachProp(unit, attachPoint, model, scale)
end

function Dungeons:SpawnUnit(unitName, spawnPoint, fv)
	local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
	unit:SetForwardVector(fv)
	Events:AdjustDeathXP(unit)
	return unit
end

function Dungeons:CreateSpeechBubble(unit, time, dialogueMessage)
	unit:DestroyAllSpeechBubbles()
	local speechSlot = 1
	unit:AddSpeechBubble(speechSlot, dialogueMessage, time, 0, 0)
end

function Dungeons:InitializeSwamp()
	Dungeons:SpawnDungeonUnit("swamp_viper", Vector(10496, 4225), 1, 2, 3, "venomancer_venm_anger_01", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("swamp_viper", Vector(10711, 4065), 1, 2, 3, "venomancer_venm_anger_01", Vector(-0.2, 1), false, nil)
	Dungeons:SpawnDungeonUnit("swamp_viper", Vector(10761, 4322), 1, 2, 3, "venomancer_venm_anger_01", Vector(-1, -0.2), false, nil)

	Dungeons:SpawnDungeonUnit("swamp_razorfish", Vector(11136, 4992), 1, 1, 1, "slark_slark_anger_01", Vector(1, 0), false, nil)
	for i = 1, 14, 1 do
		local randomLoc = Vector(11595, 4953) + RandomVector(RandomInt(20, 600))
		Dungeons:SpawnDungeonUnit("swamp_razorfish", randomLoc, 1, 1, 1, "slark_slark_anger_01", RandomVector(1), false, nil)
	end
	Dungeons:SpawnDungeonUnit("swamp_razorfish_captain", Vector(11312, 5467), 1, 2, 3, "slark_slark_anger_02", Vector(-0.3, -1), false, nil)
	Dungeons:SpawnDungeonUnit("swamp_razorfish_captain", Vector(11888, 5184), 1, 2, 3, "slark_slark_anger_02", Vector(-1, -0.2), false, nil)

	Dungeons:SpawnDungeonUnit("swamp_tribal_cultist", Vector(11456, 3496), 1, 2, 3, "witchdoctor_wdoc_anger_01", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("swamp_tribal_cultist", Vector(11592, 3598), 1, 2, 3, "witchdoctor_wdoc_anger_05", Vector(0, -1), false, nil)

	local thinker = Dungeons:CreateDungeonThinker(Vector(13104, 4387), "bog_monster", 1150, "swamp")
end

function Dungeons:SwampPart2()
	Dungeons.swampEntityTable = {}
	Dungeons:SpawnDungeonUnit("swamp_razorfish_irritable", Vector(13248, 4352), 1, 2, 3, "slark_slark_anger_02", Vector(0.3, -1), false, nil)
	Dungeons:SpawnDungeonUnit("swamp_razorfish_captain", Vector(13654, 4315), 1, 2, 3, "slark_slark_anger_02", Vector(-1, 0.2), false, nil)
	Dungeons:SpawnDungeonUnit("swamp_razorfish_irritable", Vector(13654, 4751), 1, 2, 3, "slark_slark_anger_02", Vector(0.3, -1), false, nil)
	Dungeons:SpawnDungeonUnit("swamp_razorfish_captain", Vector(13354, 4741), 1, 2, 3, "slark_slark_anger_02", Vector(-1, 0.2), false, nil)
	for i = 1, 7, 1 do
		local randomLoc = Vector(12928, 4882) + RandomVector(RandomInt(20, 260))
		Dungeons:SpawnDungeonUnit("swamp_razorfish", randomLoc, 1, 1, 1, "slark_slark_anger_01", RandomVector(1), false, nil)
	end
	local mob = Dungeons:SpawnDungeonUnit("swamp_tribal_cultist", Vector(14720, 3490), 1, 2, 3, "witchdoctor_wdoc_anger_01", Vector(1, 0), false, nil)
	table.insert(Dungeons.swampEntityTable, mob)
	mob = Dungeons:SpawnDungeonUnit("swamp_tribal_cultist", Vector(14720, 3357), 1, 2, 3, "witchdoctor_wdoc_anger_02", Vector(1, 0), false, nil)
	table.insert(Dungeons.swampEntityTable, mob)
	mob = Dungeons:SpawnDungeonUnit("swamp_tribal_cultist", Vector(14720, 3222), 1, 2, 3, "witchdoctor_wdoc_anger_05", Vector(1, 0), false, nil)
	table.insert(Dungeons.swampEntityTable, mob)
	mob = Dungeons:SpawnDungeonUnit("swamp_tribal_invoker", Vector(15168, 3392), 1, 4, 7, "witchdoctor_wdoc_anger_05", Vector(-1, 0), false, nil)
	table.insert(Dungeons.swampEntityTable, mob)

	local bearTable = {}
	for i = 1, 10, 1 do
		local spawnPoint = Vector(14272, 6464) + RandomVector(RandomInt(50, 800))
		local bear = Dungeons:SpawnDungeonUnit("swamp_grove_bear", spawnPoint, 1, 1, 1, "n_creep_Thunderlizard_Big.Roar", RandomVector(1), false, nil)
		table.insert(bearTable, bear)
	end
	for i = 1, #bearTable, 1 do
		bearTable[i]:SetRenderColor(120, 30, 120)
		local ability = bearTable[i]:FindAbilityByName("slardar_bash")
		ability:SetLevel(3)
		local bearAbility = bearTable[i]:FindAbilityByName("swamp_grove_bear_ai")
		bearAbility:ApplyDataDrivenModifier(bearTable[i], bearTable[i], "modifier_grove_bear_slow", {})
	end
	Dungeons.groveKills = 0
	Dungeons.groveState = 0
	local bladePosition = Vector(14431, 7107)
	local blade = CreateUnitByName("tracer_unit", bladePosition, false, nil, nil, DOTA_TEAM_NEUTRALS)
	blade:SetAbsOrigin(blade:GetAbsOrigin())
	blade:SetForwardVector(Vector(-0.4, -0.2, 3))
	blade:SetModelScale(1.4)
	blade:SetOriginalModel("models/items/earth_spirit/dragon_soul/dragon_soul.vmdl")
	blade:SetModel("models/items/earth_spirit/dragon_soul/dragon_soul.vmdl")
	blade:FindAbilityByName("dummy_unit"):SetLevel(1)
	Dungeons.blade = blade

	local particleName = "particles/units/heroes/hero_keeper_of_the_light/grove_staff_glow_of_the_light_recall.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, blade)
	ParticleManager:SetParticleControlEnt(particle1, 0, blade, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bladePosition, true)
	Dungeons.Particle1 = particle1

	particleName = "particles/econ/items/enchantress/enchantress_lodestar/enchantress_lodestar_butterfly_blue.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, blade)
	ParticleManager:SetParticleControlEnt(particle2, 0, blade, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bladePosition, true)
	Dungeons.Particle2 = particle2
end

function Dungeons:InitiateSwampBoss()
	--DEBUG
	-- if Dungeons.boss then
	-- UTIL_Remove(Dungeons.boss)
	-- end
	--     local bladePosition = Vector(14431,7107)
	-- local blade = CreateUnitByName("tracer_unit", bladePosition, false, nil, nil, DOTA_TEAM_NEUTRALS)
	-- blade:SetAbsOrigin(blade:GetAbsOrigin())
	-- blade:SetForwardVector(Vector(-0.4,-0.2,3))
	-- blade:SetModelScale(1.4)
	-- blade:SetOriginalModel("models/items/earth_spirit/dragon_soul/dragon_soul.vmdl")
	-- blade:SetModel("models/items/earth_spirit/dragon_soul/dragon_soul.vmdl")
	-- blade:FindAbilityByName("dummy_unit"):SetLevel(1)
	-- Dungeons.blade = blade
	--DEBUG
	local staffPos = Vector(14431, 7107)
	local startPos = Vector(14528, 7744)
	local boss = Events:SpawnBoss("swamp_boss", startPos)
	Events:AdjustBossPower(boss, 15, 6, true)
	local dropDistance = 700
	startPos = boss:GetAbsOrigin() + Vector(0, 0, dropDistance)
	boss:SetAbsOrigin(startPos)
	Timers:CreateTimer(0.05, function()
		StartAnimation(boss, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 0.2})
		local ability = boss:FindAbilityByName("swamp_boss_ai")
		ability:ApplyDataDrivenModifier(boss, boss, "modifier_swamp_boss_intro", {})
		boss:SetForwardVector(Vector(-1, -1))
	end)
	for i = 0, 16, 1 do
		Timers:CreateTimer(0.03 * i, function()
			boss:SetAbsOrigin(startPos - Vector(0, 0, dropDistance / 17 * i))
		end)
	end
	Timers:CreateTimer(0.03 * 17, function()
		ScreenShake(boss:GetAbsOrigin(), 300, 0.9, 0.5, 9000, 0, true)
		EmitSoundOn("Visage_Familar.StoneForm.Cast", boss)
		local position = boss:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, boss)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
	Timers:CreateTimer(0.03 * 17 + 1.2, function()
		boss:MoveToPosition(staffPos + Vector(140, 140))
		Timers:CreateTimer(3.8, function()
			StartAnimation(boss, {duration = 1.5, activity = ACT_DOTA_TELEPORT, rate = 1})
			boss:SetForwardVector(Vector(-1, -1))
			local movementVector = (boss:GetAbsOrigin() - Dungeons.blade:GetAbsOrigin()):Normalized()
			for i = 1, 30, 1 do
				Timers:CreateTimer(0.05 * i, function()
					Dungeons.blade:SetAbsOrigin(Dungeons.blade:GetAbsOrigin() + Vector(0, 0, 4))
				end)
			end
			for i = 1, 20, 1 do
				Timers:CreateTimer(0.05 * i + 1.5, function()
					Dungeons.blade:SetAbsOrigin(Dungeons.blade:GetAbsOrigin() + movementVector * 4 + Vector(0, 0 - 4))
					blade:SetForwardVector(Vector(-0.4 + 0.09 * i, -0.2 - 0.2 * i, 3))
				end)
			end
			Timers:CreateTimer(2.7, function()
				local properties = {
					pitch = 130,
					yaw = 0,
					roll = 0,
					XPos = 0,
					YPos = 0,
					ZPos = 0,
				}
				Attachments:AttachProp(boss, "attach_attack1", "models/items/earth_spirit/dragon_soul/dragon_soul.vmdl", 0.9, properties)
				boss:RemoveModifierByName("modifier_swamp_boss_intro")
				EmitSoundOn("earth_spirit_earthspi_immort_03", boss)
				EmitGlobalSound("Hero_EarthSpirit.Magnetize.Cast")
				UTIL_Remove(Dungeons.blade)
				if Dungeons.Particle1 then
					ParticleManager:DestroyParticle(Dungeons.Particle1, false)
				end
				if Dungeons.Particle2 then
					ParticleManager:DestroyParticle(Dungeons.Particle2, false)
				end
				boss.begin = true
				Dungeons.boss = boss
			end)
		end)
	end)
end

function Dungeons:GetTargetTable()
	local targetTable = {}
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if MAIN_HERO_TABLE[i]:IsAlive() then
			table.insert(targetTable, MAIN_HERO_TABLE[i])
		end
	end
	return targetTable
end

function Dungeons:InitializeCastle()
	GameRules:SetTimeOfDay(0.75)
	Dungeons.castleEntityTable = {}
	Dungeons.DungeonMaster = CreateUnitByName("rune_unit", Vector(-8000, 2000), true, nil, nil, DOTA_TEAM_GOODGUYS)
	Dungeons.DungeonMaster:AddAbility("avernus_curse"):SetLevel(1)
	table.insert(Dungeons.castleEntityTable, Dungeons.DungeonMaster)

	Dungeons:SpawnDungeonUnit("wraithguard", Vector(-3584, 5961), 1, 2, 3, "skeleton_king_wraith_anger_04", Vector(-1, -0.25), false, nil)
	Dungeons:SpawnDungeonUnit("wraithguard", Vector(-3584, 5312), 1, 2, 3, "skeleton_king_wraith_anger_04", Vector(-1, 0), false, nil)
	local thinker = Dungeons:CreateDungeonThinker(Vector(-4763, 6144), "treants1", 500, "castle")
	table.insert(Dungeons.castleEntityTable, thinker)
	thinker = Dungeons:CreateDungeonThinker(Vector(-3840, 6023), "treants2", 500, "castle")
	table.insert(Dungeons.castleEntityTable, thinker)
	thinker = Dungeons:CreateDungeonThinker(Vector(-4562, 5125), "treants3", 500, "castle")
	table.insert(Dungeons.castleEntityTable, thinker)
	Dungeons:SpawnDungeonUnit("wraithguard", Vector(-2496, 5312), 1, 1, 3, "skeleton_king_wraith_anger_04", Vector(-0.1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("wraithguard", Vector(-1997, 5312), 1, 1, 3, "skeleton_king_wraith_anger_04", Vector(0.1, -1), false, nil)
	local rotationVectorTable = {Vector(0, 1), Vector(-1, -1), Vector(1, -1)}
	for i = 1, 3, 1 do
		local pumpkin = Dungeons:SpawnDungeonUnit("mad_pumpkin", Vector(-1390, 5388), 1, 1, 2, "Conquest.poison.hallow_scream", Vector(0.1, -1), false, nil)
		pumpkin.centerPoint = Vector(-1390, 5388)
		pumpkin.rotationVector = rotationVectorTable[i]
	end
	Dungeons:SpawnDungeonUnit("castle_skeleton_archer", Vector(-768, 5824), 1, 2, 3, "clinkz_clinkz_anger_04", Vector(-1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("castle_skeleton_archer", Vector(-230, 5619), 1, 2, 3, "clinkz_clinkz_anger_04", Vector(-1, 0), false, nil)

	local groundskeeper = Dungeons:SpawnUnit("groundskeeper", Vector(-320, 6912), Vector(0, -1))
	Events:AdjustBossPower(groundskeeper, 5, 5, false)
	local groundskeeperAbil = groundskeeper:FindAbilityByName("groundskeeper_ai")
	groundskeeperAbil:ApplyDataDrivenModifier(groundskeeper, groundskeeper, "modifier_groundskeeper_state_one", {})

	local tree = Dungeons:SpawnUnit("tracer_unit", Vector(-341, 6705), Vector(0, -1))
	tree:RemoveAbility("dummy_unit")
	tree:RemoveModifierByName("dummy_unit")
	tree.origPosition = tree:GetAbsOrigin() - Vector(0, 0, 100)
	tree:SetModelScale(1.1)
	tree:SetModel("models/props_tree/tree_cine_00_low.vmdl")
	tree:SetOriginalModel("models/props_tree/tree_cine_00_low.vmdl")
	tree:SetBaseMaxHealth(800000)
	tree:SetMaxHealth(800000)
	tree:SetHealth(800000)
	tree:SetPhysicalArmorBaseValue(35)
	local treeAbility = tree:AddAbility("castle_tree_ai")
	treeAbility:SetLevel(1)
	treeAbility:ApplyDataDrivenModifier(tree, tree, "modifier_tree_invincible", {})
	tree.groundskeeper = groundskeeper
	groundskeeper.tree = tree

	local blade = CreateUnitByName("tracer_unit", Vector(-589.33, 7021.24, 150), false, nil, nil, DOTA_TEAM_NEUTRALS)
	blade:SetAbsOrigin(blade:GetAbsOrigin() - Vector(0, 0, 180))
	blade:SetForwardVector(Vector(0, 1.5))
	blade:SetModelScale(0.7)
	blade:SetOriginalModel("models/items/abaddon/weapon_ravelord/weapon_ravelord.vmdl")
	blade:SetModel("models/items/abaddon/weapon_ravelord/weapon_ravelord.vmdl")
	blade:FindAbilityByName("dummy_unit"):SetLevel(1)
	groundskeeper.blade = blade

	local wallPoint1 = Vector(-2432, 6272)
	local wallPoint2 = Vector(-1792, 6232)
	local particle = "particles/units/heroes/hero_dark_seer/avernus_wall_of_replica.vpcf"
	Dungeons.wallParticle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 0, wallPoint1)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 1, wallPoint2)
	Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-2304, 6272), Name = "wallObstruction"})
	Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-2176, 6272), Name = "wallObstruction"})
	Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-2048, 6272), Name = "wallObstruction"})
	Dungeons.blocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-1920, 6272), Name = "wallObstruction"})
	Dungeons.blocker5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-1792, 6272), Name = "wallObstruction"})
end

function Dungeons:CastleStageTwo()
	local wallPoint1 = Vector(-5480, 10762, 620)
	local wallPoint2 = Vector(-5056, 10752, 620)
	local particle = "particles/units/heroes/hero_dark_seer/avernus_wall_of_replica.vpcf"
	Dungeons.wallParticle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 0, wallPoint1)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 1, wallPoint2)
	Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5376, 10762), Name = "wallObstruction"})
	Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5248, 10762), Name = "wallObstruction"})
	Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5120, 10762), Name = "wallObstruction"})

	Dungeons:SpawnDungeonUnit("wraithguard_elite", Vector(-2240, 5824), 1, 2, 4, "skeleton_king_wraith_anger_04", Vector(0, -1), false, nil)
	local thinker = Dungeons:CreateDungeonThinker(Vector(-2048, 6641), "castle_entrance", 500, "castle")

	local knightVectorTable = {Vector(-2688, 8192), Vector(-2438, 8192), Vector(-2188, 8192)}
	for i = 1, #knightVectorTable, 1 do
		local knight = Dungeons:SpawnUnit("tracer_unit", knightVectorTable[i], Vector(0, -1))
		knight:SetAbsOrigin(knight:GetAbsOrigin() - Vector(0, 0, 140))
		knight:FindAbilityByName("dummy_unit"):SetLevel(1)
		knight:SetModelScale(1.6)

		knight:SetOriginalModel("models/items/wards/knightstatue_ward/knightstatue_ward.vmdl")
		knight:SetModel("models/items/wards/knightstatue_ward/knightstatue_ward.vmdl")
		StartAnimation(knight, {duration = 10000, activity = ACT_DOTA_IDLE, rate = 1})
		table.insert(Dungeons.castleEntityTable, knight)
		local animated = Dungeons:SpawnDungeonUnit("animated_arms", knightVectorTable[i], 1, 1, 2, "Conquest.hallow_laughter", Vector(0, -1), false, nil)
		animated:SetModelScale(1)
		local properties = {
			roll = 230,
			pitch = 90,
			yaw = 60,
			XPos = -60,
			YPos = -15,
			ZPos = 0,
		}
		Attachments:AttachProp(animated, "attach_attack1", "models/items/abaddon/darkstar_the_mistforged/darkstar_the_mistforged.vmdl", 1, properties)
		properties = {
			roll = 0,
			pitch = 0,
			yaw = 0,
			XPos = 0,
			YPos = -90,
			ZPos = -90,
		}
		Attachments:AttachProp(animated, "attach_attack2", "models/items/dragon_knight/wurmblood_shield/wurmblood_shield.vmdl", 1, properties)
	end
	local chestThinker = Dungeons:CreateDungeonThinker(Vector(-2657, 6877), "castleChest", 160, "castle")
	chestThinker.chest = CreateUnitByName("chest", Vector(-2557, 6777), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(-0.8, 1))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)
	Dungeons:CreateDungeonThinker(Vector(-3252, 8832), "front_kitchen", 500, "castle")
end

function Dungeons:CastleStageThree()
	local chef = Dungeons:SpawnDungeonUnit("castle_chef", Vector(-2398, 8768), 1, 2, 4, "pudge_pud_anger_03", Vector(-1, 0), false, nil)
	Events:AdjustBossPower(chef, 5, 5, false)
	local pigDummy = CreateUnitByName("npc_flying_dummy_vision", Vector(-2528, 8768), false, nil, nil, DOTA_TEAM_GOODGUYS)
	pigDummy:AddAbility("dummy_unit"):SetLevel(1)
	table.insert(Dungeons.castleEntityTable, pigDummy)
	chef.pigDummy = pigDummy

	Dungeons:CreateDungeonThinker(Vector(-2816, 9024), "kitchen_oven", 400, "castle")

	Dungeons:CreateDungeonThinker(Vector(-1344, 9336), "walk_outside", 700, "castle")

	local cellarThinker = Dungeons:CreateDungeonThinker(Vector(-2443, 10944), "cellar_entrance", 500, "castle")
	table.insert(Dungeons.castleEntityTable, cellarThinker)

	local necro = Dungeons:SpawnDungeonUnit("castle_undertaker", Vector(-1728, 11008), 1, 5, 7, "necrolyte_necr_ability_reap_01", Vector(1, 0), false, nil)
	table.insert(Dungeons.castleEntityTable, necro)

end

function Dungeons:CastleStageFour()
	-- --TEMP
	-- Dungeons.DungeonMaster = CreateUnitByName("rune_unit", Vector(-8000,2000), true, nil, nil, DOTA_TEAM_GOODGUYS)
	-- Dungeons.DungeonMaster:AddAbility("avernus_curse"):SetLevel(1)
	-- Dungeons.castleEntityTable = {}
	-- --TEMP

	Dungeons:CreateDungeonThinker(Vector(-5248, 12800), "castle_boss_entrance", 400, "castle")
	Dungeons.abaddon = CreateUnitByName("castle_boss_intro", Vector(-4992, 13504), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.abaddon:AddAbility("dummy_unit"):SetLevel(1)
	Dungeons.abaddon:SetForwardVector(Vector(-0.8, -1))

	Dungeons.eyeDummy = CreateUnitByName("npc_flying_dummy_vision", Vector(-5225, 13180, 700), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.eyeDummy:AddAbility("dummy_unit"):SetLevel(1)
	Dungeons.eyeDummy:AddAbility("castle_eye_ai"):SetLevel(1)

	local particleName = "particles/dire_fx/avernus_eye_ambient.vpcf"
	Dungeons.EyeParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, Dungeons.eyeDummy)
	ParticleManager:SetParticleControl(Dungeons.EyeParticle, 0, Dungeons.eyeDummy:GetAbsOrigin() - Vector(0, 0, 100))
end

function Dungeons:StartCastleBoss()
	local mode = GameRules:GetGameModeEntity()
	mode:SetCameraDistanceOverride(1900)
	CustomGameEventManager:Send_ServerToAllClients("fadeToBlack", {})
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		if playerID then
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 12})
			PlayerResource:SetCameraTarget(playerID, Dungeons.abaddon)
		end
	end
	local wallPoint1 = Vector(-4992, 12416, 620)
	local wallPoint2 = Vector(-5504, 12416, 620)
	local particle = "particles/units/heroes/hero_dark_seer/avernus_wall_of_replica.vpcf"

	Dungeons.wallParticle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 0, wallPoint1)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 1, wallPoint2)

	Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5120, 12416), Name = "wallObstruction"})
	Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5248, 12416), Name = "wallObstruction"})
	Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-5376, 12416), Name = "wallObstruction"})
	EmitSoundOn("abaddon_abad_laugh_02", Dungeons.abaddon)
	Timers:CreateTimer(1.1, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			FindClearSpaceForUnit(MAIN_HERO_TABLE[i], Vector(-5248, 12800), false)
			MAIN_HERO_TABLE[i]:SetForwardVector(Vector(0, 1))
		end
		StartAnimation(Dungeons.abaddon, {duration = 8, activity = ACT_DOTA_VICTORY, rate = 0.7})
		Dungeons.abaddon:DestroyAllSpeechBubbles()
		local time = 4
		local speechSlot = 1
		Dungeons.abaddon:AddSpeechBubble(speechSlot, "#castle_boss_dialogue_one", time, 0, 0)
		Timers:CreateTimer(4, function()
			Dungeons.abaddon:DestroyAllSpeechBubbles()
			local time = 4
			local speechSlot = 1
			Dungeons.abaddon:AddSpeechBubble(speechSlot, "#castle_boss_dialogue_two", time, 0, 0)
			Timers:CreateTimer(4, function()
				Dungeons.abaddon:DestroyAllSpeechBubbles()
				local time = 4
				local speechSlot = 1
				Dungeons.abaddon:AddSpeechBubble(speechSlot, "#castle_boss_dialogue_three", time, 0, 0)
				Timers:CreateTimer(1, function()
					local position = Dungeons.abaddon:GetAbsOrigin() + Vector(0, 0, 140)
					local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
					local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, Dungeons.DungeonMaster)
					ParticleManager:SetParticleControlEnt(pfx, 0, Dungeons.abaddon, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
					ParticleManager:SetParticleControlEnt(pfx, 1, Dungeons.abaddon, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
					Timers:CreateTimer(3.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end)
				Timers:CreateTimer(2, function()
					local particleName = "particles/items_fx/castle_boss_wall_beam.vpcf"
					local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Dungeons.abaddon)
					local casterPos = Dungeons.abaddon:GetAbsOrigin()
					for i = 1, 5, 1 do
						Timers:CreateTimer(0.08 * i, function()
							EmitSoundOn("Hero_ArcWarden.Flux.Target", Dungeons.eyeDummy)
							local unit = Dungeons.abaddon
							EmitSoundOn("Hero_ArcWarden.SparkWraith.Activate", unit)
							local origin = Dungeons.eyeDummy:GetAbsOrigin()
							local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Dungeons.abaddon)
							ParticleManager:SetParticleControl(lightningBolt, 0, Vector(casterPos.x, casterPos.y, casterPos.z + 200))
							ParticleManager:SetParticleControl(lightningBolt, 1, Vector(origin.x, origin.y, origin.z + 400))
						end)
					end
				end)
				Timers:CreateTimer(3, function()
					local position = Dungeons.abaddon:GetAbsOrigin() + Vector(0, 0, 140)
					local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
					local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, Dungeons.abaddon)
					ParticleManager:SetParticleControlEnt(pfx, 0, Dungeons.abaddon, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
					ParticleManager:SetParticleControlEnt(pfx, 1, Dungeons.abaddon, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
					Timers:CreateTimer(3.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end)
				Timers:CreateTimer(3.5, function()
					Dungeons:CastleBossFightStart()
					UTIL_Remove(Dungeons.abaddon)
				end)
			end)
		end)
	end)

end

function Dungeons:CastleBossFightStart()
	GameRules:SetTimeOfDay(0.75)
	local boss = CreateUnitByName("castle_boss", Vector(-4558, 13935, 880), false, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.avernusBoss = boss
	Events:AdjustDeathXP(boss)
	Events:AdjustBossPower(boss, 10, 10, true)
	Dungeons.castleCenter = Vector(-5225, 13180, 940)
	Dungeons.castleRadius = 832
	boss.circlePos = Vector(1, 1)
	boss.momentum = 0.5
	boss.direction = -1
	boss.interval = 0
	boss.slowPools = 0
	Dungeons.entryPoint = Vector(-5225, 13180, 940)
	boss:SetAbsOrigin(Dungeons.castleCenter + boss.circlePos * Dungeons.castleRadius)
	CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = boss:GetUnitName(), bossMaxHealth = boss:GetMaxHealth(), bossId = tostring(boss)})
	boss:SetForwardVector(Vector(-1, -1))
	EmitGlobalSound("abaddon_abad_attack_11")
	EmitGlobalSound("abaddon_abad_attack_11")
	EmitGlobalSound("abaddon_abad_attack_11")
	Dungeons.effectDummyTable = {}
	Dungeons.eyeDummy.active = true
	Dungeons.eyeDummy.forward = Vector(0, 1)
	Dungeons.eyeDummy.interval = 0
	Dungeons.eyeDummy.stuck = 0
	local fv = Vector(1, 1)
	for i = -8, 8, 1 do
		local facingVector = WallPhysics:rotateVector(fv, math.pi / 8 * i)
		local effectDummy = CreateUnitByName("npc_flying_dummy_vision", Dungeons.castleCenter + facingVector * 1500 - Vector(0, 0, 200), false, nil, nil, DOTA_TEAM_GOODGUYS)
		effectDummy:AddAbility("dummy_unit"):SetLevel(1)
		-- effectDummy:SetOriginalModel("models/items/abaddon/darkstar_the_mistforged/darkstar_the_mistforged.vmdl")
		-- effectDummy:SetModel("models/items/abaddon/darkstar_the_mistforged/darkstar_the_mistforged.vmdl")
		effectDummy:AddAbility("castle_boss_effect_dummy"):SetLevel(1)
		table.insert(Dungeons.castleEntityTable, effectDummy)
		table.insert(Dungeons.effectDummyTable, effectDummy)
	end
	for i = 1, 4, 1 do
		local random_one = RandomInt(1, #Dungeons.effectDummyTable)
		local random_two = RandomInt(1, #Dungeons.effectDummyTable)
		if random_one == random_two then
			random_two = random_two + 1
			if random_two > #Dungeons.effectDummyTable then
				random_two = 1
			end
		end
		local info =
		{
			Target = Dungeons.effectDummyTable[random_one],
			Source = Dungeons.effectDummyTable[random_two],
			Ability = Dungeons.effectDummyTable[random_two]:FindAbilityByName("castle_boss_effect_dummy"),
			EffectName = "particles/base_attacks/fountain_attack.vpcf",
			StartPosition = "attach_origin",
			bDrawsOnMinimap = false,
			bDodgeable = false,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false,
			iVisionRadius = 500,
			iMoveSpeed = 400,
		iVisionTeamNumber = Dungeons.effectDummyTable[random_two]:GetTeamNumber()}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end
end

function Dungeons:DebugSpawn()
	if Dungeons.animated then
		UTIL_Remove(Dungeons.animated)
	end
	Dungeons.animated = Dungeons:SpawnDungeonUnit("animated_arms", Vector(-2240, 5824), 1, 1, 2, "Conquest.hallow_laughter", Vector(0, -1), false, nil)
	Dungeons.animated:SetModelScale(1)
	local properties = {
		roll = 230,
		pitch = 90,
		yaw = 60,
		XPos = -60,
		YPos = -15,
		ZPos = 0,
	}
	Attachments:AttachProp(Dungeons.animated, "attach_attack1", "models/items/abaddon/darkstar_the_mistforged/darkstar_the_mistforged.vmdl", 1, properties)

	local properties = {
		roll = 0,
		pitch = 0,
		yaw = 0,
		XPos = 0,
		YPos = -90,
		ZPos = -90,
	}
	Attachments:AttachProp(Dungeons.animated, "attach_attack2", "models/items/dragon_knight/wurmblood_shield/wurmblood_shield.vmdl", 1, properties)
end

function Dungeons:InitializeTownSiege()
	Dungeons.siegeEntityTable = {}
	local speechFootman = ""
	for i = 1, 4, 1 do
		for j = 1, 3, 1 do
			if j == 2 and i == 2 then
				speechFootman = CreateUnitByName("town_footman", Vector(-3681 - i * 120, 2387 - j * 120), true, nil, nil, DOTA_TEAM_GOODGUYS)
				Events:AdjustDeathXP(speechFootman)
				speechFootman:SetForwardVector(Vector(-1, -0.2))
				Dungeons:attachWearables(speechFootman, "attach_head", "models/items/omniknight/helmet_crusader.vmdl", 0.95)
				table.insert(Dungeons.siegeEntityTable, speechFootman)
			else
				local footman = CreateUnitByName("town_footman", Vector(-3681 - i * 120, 2387 - j * 120), true, nil, nil, DOTA_TEAM_GOODGUYS)
				Events:AdjustDeathXP(footman)
				footman:SetForwardVector(Vector(-1, -0.2))
				Dungeons:attachWearables(footman, "attach_head", "models/items/omniknight/helmet_crusader.vmdl", 0.95)
				table.insert(Dungeons.siegeEntityTable, footman)
			end
		end
	end
	local archerVectorTable = {Vector(-4096, 2688), Vector(-3968, 2944), Vector(-3968, 3105), Vector(-3890, 3272), Vector(-3264, 960), Vector(-3456, 1344), Vector(-3580, 1584)}
	for i = 1, #archerVectorTable, 1 do
		local archer = CreateUnitByName("town_archer", archerVectorTable[i], true, nil, nil, DOTA_TEAM_GOODGUYS)
		Events:AdjustDeathXP(archer)
		archer.spawnPosition = archerVectorTable[i]
		archer:SetForwardVector(Vector(-1, 0))
		table.insert(Dungeons.siegeEntityTable, archer)
	end
	local eventArcher = CreateUnitByName("town_archer", Vector(-3816, 1792), true, nil, nil, DOTA_TEAM_GOODGUYS)
	Events:AdjustDeathXP(eventArcher)
	eventArcher :SetForwardVector(Vector(-1, 0))
	eventArcher.spawnPosition = Vector(-3816, 1792)
	table.insert(Dungeons.siegeEntityTable, eventArcher)

	Dungeons.commander = CreateUnitByName("garrison_commander", Vector(-2752, 2624), true, nil, nil, DOTA_TEAM_GOODGUYS)
	Events:AdjustDeathXP(Dungeons.commander)
	Dungeons.commander:SetForwardVector(Vector(-1, -0.3))
	local properties = {
		pitch = 90,
		yaw = 60,
		roll = 50,
		XPos = 20,
		YPos = -10,
		ZPos = 0,
	}
	Attachments:AttachProp(Dungeons.commander, "attach_attack1", "models/heroes/legion_commander/legion_commander_weapon.vmdl", 1, properties)
	local eventMinion = ""
	local eventMinion2 = ""
	local minionTable = {}
	for i = 1, 5, 1 do
		for j = 1, 4, 1 do
			if i == 5 and j == 4 then
				eventMinion = CreateUnitByName("basic_siege_unit", Vector(-5996 + i * 120, 2101 - j * 120), true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(eventMinion)
				Events:TownSiegeXP(eventMinion)
				eventMinion:SetForwardVector(Vector(1, 0.2))
				eventMinion.respawnLocation = eventMinion:GetAbsOrigin()
				eventMinion:AddAbility("dummy_unit"):SetLevel(1)
			elseif i == 4 and j == 4 then
				eventMinion2 = CreateUnitByName("basic_siege_unit", Vector(-5996 + i * 120, 2101 - j * 120), true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(eventMinion2)
				Events:TownSiegeXP(eventMinion2)
				eventMinion2:SetForwardVector(Vector(1, 0.2))
				eventMinion2.respawnLocation = eventMinion2:GetAbsOrigin()
				table.insert(minionTable, eventMinion2)
				eventMinion2:AddAbility("dummy_unit"):SetLevel(1)
			else
				local minion = CreateUnitByName("basic_siege_unit", Vector(-5996 + i * 120, 2101 - j * 120), true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(minion)
				Events:TownSiegeXP(minion)
				minion:SetForwardVector(Vector(1, 0.2))
				table.insert(minionTable, minion)
				minion.respawnLocation = minion:GetAbsOrigin()
				minion:AddAbility("dummy_unit"):SetLevel(1)
			end
		end
	end
	Dungeons.chieftain = CreateUnitByName("chaos_chieftain", Vector(-6035, 1683), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:AdjustDeathXP(Dungeons.chieftain)
	Events:AdjustBossPower(Dungeons.chieftain, 1, 1, false)
	Dungeons.chieftain:SetForwardVector(Vector(1, 0.2))
	Dungeons.chieftain:SetBaseHealthRegen(1000)
	local chaosAbil = Dungeons.chieftain:FindAbilityByName("chaos_chieftain_ai")
	chaosAbil:ApplyDataDrivenModifier(Dungeons.chieftain, Dungeons.chieftain, "modifier_chieftain_state_one", {})
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")

	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(-2752, 2624), true, nil, nil, DOTA_TEAM_GOODGUYS)
	visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	visionTracer:AddNewModifier(visionTracer, nil, 'modifier_movespeed_cap', nil)
	Timers:CreateTimer(2.8, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 20})
				MAIN_HERO_TABLE[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, visionTracer)

			end
		end
		Dungeons.commander:DestroyAllSpeechBubbles()
		local time = 8
		local speechSlot = 1
		Dungeons.commander:AddSpeechBubble(speechSlot, "#town_siege_intro_dialogue", time, 0, 0)
		Timers:CreateTimer(3, function()
			visionTracer:MoveToPosition(Vector(-6035, 1683))
			Timers:CreateTimer(1.5, function()
				Dungeons.chieftain:AddSpeechBubble(2, "#town_siege_chieftain_dialogue_one", 8, 0, 0)
				for i = 1, #minionTable - 5, 1 do
					EmitSoundOn("chaos_knight_chaknight_anger_04", minionTable[i])
				end
				Timers:CreateTimer(3.5, function()
					visionTracer:MoveToPosition(speechFootman:GetAbsOrigin())
					speechFootman:AddSpeechBubble(3, "#town_siege_footman_dialogue", 5, 0, 0)
					Timers:CreateTimer(3.7, function()
						visionTracer:MoveToPosition(eventArcher:GetAbsOrigin())
						StartAnimation(eventArcher, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.45})
						EmitSoundOn("Ability.PowershotPull", eventArcher)
						Timers:CreateTimer(1.5, function()
							StartAnimation(eventArcher, {duration = 0.5, activity = ACT_DOTA_OVERRIDE_ABILITY_2, rate = 0.9})
							EmitSoundOn("Ability.Powershot", eventArcher)
							visionTracer:SetForwardVector(eventArcher:GetForwardVector())
							visionTracer:SetBaseMoveSpeed(1000)
							visionTracer:SetModel("models/projectiles/windrunner_arrow.vmdl")
							visionTracer:SetModelScale(0.85)
							visionTracer:SetOriginalModel("models/projectiles/windrunner_arrow.vmdl")
							visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin() - Vector(0, 0, 30) + eventArcher:GetForwardVector() * 50)
							-- visionTracer:MoveToPosition(eventMinion:GetAbsOrigin())
							local movementVector = (eventMinion:GetAbsOrigin() - eventArcher:GetAbsOrigin()) / 33
							for i = 1, 33, 1 do
								Timers:CreateTimer(0.03 * i, function()
									local tracerPos = visionTracer:GetAbsOrigin()
									visionTracer:SetAbsOrigin(tracerPos + movementVector)
									visionTracer:SetForwardVector(movementVector:Normalized())
								end)
							end
							Timers:CreateTimer(1, function()
								for i = 1, #minionTable, 1 do
									StartAnimation(minionTable[i], {duration = 4.0, activity = ACT_DOTA_VICTORY, rate = 0.8})
									minionTable[i]:RemoveAbility("dummy_unit")
									minionTable[i]:RemoveModifierByName("dummy_unit")
									for j = 1, 5, 1 do
										Timers:CreateTimer(i * j * 0.08, function()
											EmitSoundOn("Roshan.Grunt", minionTable[i])
											EmitSoundOn("Roshan.Grunt", minionTable[RandomInt(1, #minionTable)])
										end)
									end
								end

								eventMinion2:MoveToPosition(eventMinion2:GetAbsOrigin() + Vector(0, 70, 0))
								visionTracer:SetModel("models/development/invisiblebox.vmdl")
								visionTracer:SetOriginalModel("models/development/invisiblebox.vmdl")
								local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
								local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, eventMinion)
								ParticleManager:SetParticleControlEnt(pfx, 0, eventMinion, PATTACH_CUSTOMORIGIN, "follow_origin", eventMinion:GetAbsOrigin(), true)
								ParticleManager:SetParticleControlEnt(pfx, 1, eventMinion, PATTACH_CUSTOMORIGIN, "follow_origin", eventMinion:GetAbsOrigin(), true)

								EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", eventMinion)
								StartAnimation(eventMinion, {duration = 2.6, activity = ACT_DOTA_DIE, rate = 0.8})
								for i = 0, 5, 1 do
									Timers:CreateTimer(0.4 * i, function()
										CreateUnitByName("leaping_lion", Vector(-6400, 1252 + RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
									end)
								end
								Timers:CreateTimer(2.4, function()
									UTIL_Remove(eventMinion)
								end)
								Timers:CreateTimer(2.5, function()
									ParticleManager:DestroyParticle(pfx, false)
								end)
							end)
							Timers:CreateTimer(3.2, function()
								visionTracer:SetBaseMoveSpeed(1500)
								visionTracer:MoveToPosition(MAIN_HERO_TABLE[1]:GetAbsOrigin())
								Dungeons.siegeKills = 0
								Dungeons.siegeStage = 0
								speechFootman:AddSpeechBubble(1, "#town_siege_footman_dialogue_two", 6, 0, 0)

							end)

							Timers:CreateTimer(4.4, function()
								for i = 1, #MAIN_HERO_TABLE, 1 do
									local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
									if playerID then
										PlayerResource:SetCameraTarget(playerID, nil)
									end
								end
								for i = 1, #minionTable, 1 do
									minionTable[i]:MoveToPositionAggressive(Dungeons.commander:GetAbsOrigin())
								end
								UTIL_Remove(visionTracer)
							end)
						end)
					end)

				end)
			end)
		end)
	end)


end

function Dungeons:SpawnFootman()
	-- UTIL_Remove(Dungeons.commander)
	local unit = CreateUnitByName("chaos_chieftain", Vector(-6400, 1252 + RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
	-- unit:SetForwardVector(Vector(-1,-0.2))
	--    local properties =  {
	--        pitch = 90,
	--        yaw = 60,
	--        roll = 50,
	--        XPos = 20,
	--        YPos = -10,
	--        ZPos = 0,
	--      }
	-- Attachments:AttachProp(unit, "attach_attack1", "models/heroes/legion_commander/legion_commander_weapon.vmdl", 1, properties)
end

function Dungeons:InitializeGraveyard()
	local thinker = CreateUnitByName("dungeon_thinker", Vector(-4416, -10688), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)
	thinker = CreateUnitByName("dungeon_thinker", Vector(-3968, -10688), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)

	thinker = CreateUnitByName("dungeon_thinker", Vector(-4416, -10368), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)
	thinker = CreateUnitByName("dungeon_thinker", Vector(-3968, -10368), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)

	thinker = CreateUnitByName("dungeon_thinker", Vector(-4416, -10168), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)
	thinker = CreateUnitByName("dungeon_thinker", Vector(-3968, -10168), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)

	thinker = CreateUnitByName("dungeon_thinker", Vector(-4416, -9900), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)
	thinker = CreateUnitByName("dungeon_thinker", Vector(-3968, -9900), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)

	thinker = CreateUnitByName("dungeon_thinker", Vector(-4416, -9700), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)
	thinker = CreateUnitByName("dungeon_thinker", Vector(-3968, -9700), true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = "skeleton"
	thinker.dungeon = "graveyard"
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)

	Dungeons:SpawnDungeonUnit("skeleton_archer", Vector(-4710, -9216), 2, 1, 1, "clinkz_clinkz_anger_04", nil, false, nil)
	Dungeons:SpawnDungeonUnit("skeleton_archer", Vector(-5288, -9216), 3, 1, 1, "clinkz_clinkz_anger_04", nil, false, nil)
	Dungeons:SpawnDungeonUnit("skeleton_archer", Vector(-5818, -9216), 4, 1, 1, "clinkz_clinkz_anger_04", nil, false, nil)

	Dungeons:SpawnDungeonUnit("skeleton_archer", Vector(-6418, -9216), 4, 1, 1, "clinkz_clinkz_anger_04", nil, false, nil)

	Dungeons:CreateDungeonThinker(Vector(-6784, -12160), "zombieSwarm", 1000, "graveyard")

	Dungeons:SpawnDungeonUnit("zombie_bridge_boss", Vector(-6656, -10432), 1, 3, 6, "undying_undying_big_tombstone_07", Vector(0, 1), false, "bridgeBoss")

	Dungeons:CreateDungeonThinker(Vector(-5824, -14336), "zombiePile", 450, "graveyard")

	Dungeons:SpawnDungeonUnit("raider", Vector(-5952, -13780), 1, 1, 1, "axe_axe_anger_03", Vector(-1, 1), false, "raider")
	Dungeons:SpawnDungeonUnit("raider", Vector(-6272, -13760), 1, 1, 1, "axe_axe_anger_03", Vector(1, 1), false, "raider")

	Dungeons:SpawnDungeonUnit("raider", Vector(-6528, -14336), 1, 1, 1, "axe_axe_anger_03", Vector(0, 1), false, "raider")
	Dungeons:SpawnDungeonUnit("raider", Vector(-6784, -14208), 1, 1, 1, "axe_axe_anger_03", Vector(3, 1), false, "raider")
	Dungeons:SpawnDungeonUnit("raider", Vector(-6528, -14080), 1, 1, 1, "axe_axe_anger_03", Vector(0, -1), false, "raider")

	Dungeons:CreateDungeonThinker(Vector(-7104, -14272), "zombieCathedral", 600, "graveyard")

	local chestThinker = Dungeons:CreateDungeonThinker(Vector(-6784, -14720), "graveyardChest", 160, "graveyard")
	chestThinker.chest = CreateUnitByName("chest", Vector(-6602, -14720), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(-1, 0))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)

	local gyBeacon = Dungeons:CreateDungeonThinker(Vector(-7424, -14984), "graveyardBeacon1", 300, "graveyard")
	gyBeacon.beacon = CreateUnitByName("skull_beacon", Vector(-7424, -14984), true, nil, nil, DOTA_TEAM_GOODGUYS)
	gyBeacon.beacon:SetForwardVector(Vector(0, 1))
	gyBeacon.beacon:FindAbilityByName("town_unit"):SetLevel(1)

	local skeletonKingThinker = Dungeons:CreateDungeonThinker(Vector(-6784, -12060), "skeletonKing", 550, "graveyard")
	gyBeacon.skeletonKingThinker = skeletonKingThinker
	skeletonKingThinker.active = false
	skeletonKingThinker.skeletonKing = CreateUnitByName("floating_skeleton_king", Vector(-6784, -12060), true, nil, nil, DOTA_TEAM_GOODGUYS)
	skeletonKingThinker.skeletonKing:SetAbsOrigin(skeletonKingThinker.skeletonKing:GetAbsOrigin() + Vector(0, 0, 60))
	skeletonKingThinker.skeletonKing:SetForwardVector(Vector(0, -1))
	skeletonKingThinker.skeletonKing:FindAbilityByName("town_unit"):SetLevel(1)
	

end

function Dungeons:InitializeLoggingCamp()
	local sprite = CreateUnitByName("forest_sprite", Vector(-15040, -15040), true, nil, nil, DOTA_TEAM_GOODGUYS)
	sprite:SetForwardVector(Vector(-1, 0))
	sprite:FindAbilityByName("town_unit"):SetLevel(1)
	local spriteThinker = Dungeons:CreateDungeonThinker(Vector(-15040, -15040), "forestSprite1", 450, "logging_camp")
	spriteThinker.sprite = sprite
	local spriteThinkerTwo = Dungeons:CreateDungeonThinker(Vector(-13796, -15040), "forestSprite2", 550, "logging_camp")
	spriteThinkerTwo.sprite = sprite
	Dungeons:SpawnDungeonUnit("infected_treant", Vector(-14336, -15360), 1, 0, 0, "treant_treant_anger_04", Vector(-1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("infected_treant", Vector(-14136, -15200), 1, 0, 0, "treant_treant_anger_04", Vector(-1, 0), false, nil)

	Dungeons:SpawnDungeonUnit("infected_treant", Vector(-14528, -14592), 1, 0, 0, "treant_treant_anger_04", Vector(-1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("infected_treant", Vector(-14592, -14720), 1, 0, 0, "treant_treant_anger_04", Vector(1, 1), false, nil)
	Dungeons:SpawnDungeonUnit("infected_treant", Vector(-14336, -14656), 1, 0, 0, "treant_treant_anger_04", Vector(1, 1), false, nil)

	-- local gazbinAlch = CreateUnitByName("gazbin_alchemist", Vector(-13312, -14912), true, nil, nil, DOTA_TEAM_NEUTRALS)
	local gazbinAlch = Dungeons:SpawnDungeonUnit("gazbin_alchemist", Vector(-13312, -14912), 1, 1, 2, nil, Vector(-1, 0), false, "gazbinAlch")
	local dummyTreeTarget = CreateUnitByName("dummy_unit_vulnerable", Vector(-13312, -15424), true, nil, nil, DOTA_TEAM_NEUTRALS)
	gazbinAlch.dummyTarget = dummyTreeTarget
	gazbinAlch.sprite = sprite
	dummyTreeTarget:AddAbility("dummy_unit_vulnerable")
	dummyTreeTarget:FindAbilityByName("dummy_unit_vulnerable"):SetLevel(1)
	dummyTreeTarget:AddAbility("creature_acid_spray"):SetLevel(1)

	Dungeons:SpawnDungeonUnit("mutated_treant", Vector(-12352, -14720), 3, 0, 0, "treant_treant_anger_02", Vector(1, 1), false, nil)

	local spriteThinkerThree = Dungeons:CreateDungeonThinker(Vector(-12928, -14976), "forestSprite2", 400, "logging_camp")
	spriteThinkerThree.sprite = sprite

	Dungeons:SpawnDungeonUnit("gazbin_guard", Vector(-11221, -15680), 1, 1, 1, "DOTA_Item.Necronomicon.Deaths", Vector(-1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_guard", Vector(-11235, -14837), 1, 1, 1, "DOTA_Item.Necronomicon.Deaths", Vector(-1, 0), false, nil)

	local spriteThinkerFour = Dungeons:CreateDungeonThinker(Vector(-11136, -15232), "forestSprite3", 450, "logging_camp")
	spriteThinkerFour.sprite = sprite

	Dungeons:SpawnDungeonUnit("gazbin_brute", Vector(-10112, -15232), 1, 4, 6, "alchemist_alch_anger_03", Vector(-1, 0), false, nil)

	local spriteThinkerFive = Dungeons:CreateDungeonThinker(Vector(-9792, -14336), "forestSprite4", 450, "logging_camp")
	spriteThinkerFive.sprite = sprite

	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-9984, -14464), 1, 0, 1, "alchemist_alch_anger_05", Vector(-1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-9664, -14592), 1, 0, 1, "alchemist_alch_anger_05", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-9664, -14400), 1, 0, 1, "alchemist_alch_anger_05", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-9984, -14336), 1, 0, 1, "alchemist_alch_anger_05", Vector(-1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-9856, -13952), 1, 0, 1, "alchemist_alch_anger_05", Vector(-1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-9536, -13888), 1, 0, 1, "alchemist_alch_anger_05", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-9536, -12800), 1, 0, 1, "alchemist_alch_anger_05", Vector(1, 0), false, nil)

	spriteThinker = Dungeons:CreateDungeonThinker(Vector(-9600, -13184), "forestSprite2", 320, "logging_camp")
	spriteThinker.sprite = sprite

	Dungeons:SpawnDungeonUnit("gazbin_guard", Vector(-10112, -13312), 1, 1, 2, "DOTA_Item.Necronomicon.Deaths", Vector(1, 0), false, nil)

	Dungeons:CreateDungeonThinker(Vector(-10304, -12544), "mercenarySwarm", 900, "logging_camp")

	spriteThinker = Dungeons:CreateDungeonThinker(Vector(-11044, -12608), "forestSprite2", 400, "logging_camp")
	spriteThinker.sprite = sprite

	Dungeons:CreateDungeonThinker(Vector(-11776, -12864), "sludge_golems", 700, "logging_camp")
	for i = -3, 3, 1 do
		Dungeons:SpawnDungeonUnit("gazbin_berserker", Vector(-14188, -12672) + Vector(0, 100 * i), 1, 1, 1, nil, Vector(1, 0), false, nil)
		Dungeons:SpawnDungeonUnit("gazbin_recruit", Vector(-14618, -12672) + Vector(0, 100 * i), 1, 1, 1, "troll_warlord_troll_anger_01", Vector(1, 0), false, nil)
	end

	spriteThinker = Dungeons:CreateDungeonThinker(Vector(-13760, -12240), "forestSprite5", 600, "logging_camp")
	spriteThinker.sprite = sprite

	Dungeons:SpawnDungeonUnit("gazbin_guard", Vector(-16000, -12032), 2, 1, 1, "DOTA_Item.Necronomicon.Deaths", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_guard", Vector(-15872, -11584), 2, 1, 1, "DOTA_Item.Necronomicon.Deaths", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_guard", Vector(-16021, -11181), 2, 1, 1, "DOTA_Item.Necronomicon.Deaths", Vector(1, 0), false, nil)

	Dungeons:SpawnDungeonUnit("gazbin_guard", Vector(-15424, -11136), 3, 1, 1, "DOTA_Item.Necronomicon.Deaths", Vector(1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_brute", Vector(-15168, -11712), 1, 4, 6, "alchemist_alch_anger_03", Vector(0, -1), false, nil)

	Dungeons:SpawnDungeonUnit("gazbin_explosives_expert", Vector(-14848, -10688), 1, 1, 1, "techies_tech_levelup_21", Vector(-1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_explosives_expert", Vector(-14448, -10688), 1, 1, 1, "techies_tech_levelup_21", Vector(-1, -1), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_explosives_expert", Vector(-14848, -10288), 1, 1, 1, "techies_tech_levelup_21", Vector(-1, -1), false, nil)

	local chestThinker = Dungeons:CreateDungeonThinker(Vector(-14400, -9692), "graveyardChest", 240, "graveyard")
	chestThinker.chest = CreateUnitByName("chest", Vector(-14400, -9692), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(1, -2))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)

	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-13630, -9868), 1, 0, 1, "alchemist_alch_anger_05", Vector(1, 0), false, nil)
	Dungeons:SpawnDungeonUnit("gazbin_peon", Vector(-13364, -10458), 1, 0, 1, "alchemist_alch_anger_05", Vector(1, 0), false, nil)

	local shredder = Dungeons:SpawnDungeonUnit("shredder_max", Vector(-12228, -9856), 1, 12, 16, "shredder_timb_kill_01", Vector(-1, 0), false, nil)
	local shredThinker = Dungeons:CreateDungeonThinker(Vector(-12228, -9856), "shredder_max", 600, "logging_camp")
	shredThinker.shredder = shredder
	Dungeons.shredder = true

	spriteThinker = Dungeons:CreateDungeonThinker(Vector(-14080, -10304), "forestSprite6", 700, "logging_camp")
	spriteThinker.sprite = sprite

	assaultThinker = Dungeons:CreateDungeonThinker(Vector(-10176, -9216), "beginAssault", 500, "logging_camp")
	assaultThinker.sprite = sprite

end

function Dungeons:InitializeSandTomb()
	Dungeons.entityTable = {}
	Dungeons.DungeonMaster = CreateUnitByName("rune_unit", Vector(-8000, 2000), true, nil, nil, DOTA_TEAM_GOODGUYS)
	Dungeons.DungeonMaster:AddAbility("dummy_unit"):SetLevel(1)
	local abil = Events.GameMaster:AddAbility("sand_tomb_fire_traps")
	abil:SetLevel(1)
	table.insert(Dungeons.entityTable, Dungeons.DungeonMaster)

	local openingSequenceThinker = Dungeons:CreateDungeonThinker(Vector(9331, -3776), "openingSequence", 520, "sand_tomb")
	local adventurerA = CreateUnitByName("gazbin_explosives_expert", Vector(9472, -5164), true, nil, nil, DOTA_TEAM_GOODGUYS)
	local adventurerB = CreateUnitByName("abomination", Vector(9257, -5164), true, nil, nil, DOTA_TEAM_GOODGUYS)
	adventurerA:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
	adventurerB:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
	adventurerA:SetBaseMoveSpeed(250)
	adventurerB:SetBaseMoveSpeed(220)
	adventurerA:SetForwardVector(Vector(0, 1))
	adventurerB:SetForwardVector(Vector(0, 1))
	adventurerA:SetPhysicalArmorBaseValue(500)
	adventurerB:SetPhysicalArmorBaseValue(500)
	adventurerA:SetBaseHealthRegen(500)
	adventurerB:SetBaseHealthRegen(500)

	local ability = Events.GameMaster:FindAbilityByName("npc_abilities")
	ability:ApplyDataDrivenModifier(Events.GameMaster, adventurerA, "modifier_disable_attacks_and_spells", {duration = 99999})
	ability:ApplyDataDrivenModifier(Events.GameMaster, adventurerB, "modifier_disable_attacks_and_spells", {duration = 99999})
	openingSequenceThinker.adventurerA = adventurerA
	openingSequenceThinker.adventurerB = adventurerB

	Dungeons:SpawnDungeonUnit("tomb_remnant", Vector(9280, -5484), 1, 1, 1, "clinkz_clinkz_anger_10", Vector(0, 1), false, nil)
	Dungeons:SpawnDungeonUnit("tomb_remnant", Vector(9480, -5434), 1, 1, 1, "clinkz_clinkz_anger_10", Vector(0, 1), false, nil)
	Dungeons:SpawnDungeonUnit("tomb_remnant", Vector(9350, -5534), 1, 1, 1, "clinkz_clinkz_anger_10", Vector(0, 1), false, nil)

	Dungeons:CreateDungeonThinker(Vector(9344, -6016), "goldZombieSwarm", 520, "sand_tomb")

	Dungeons:SpawnDungeonUnit("ancient_ghost", Vector(9280, -7084), 1, 1, 1, "sandking_skg_anger_05", Vector(1, 1), false, nil)
	Dungeons:SpawnDungeonUnit("ancient_ghost", Vector(9480, -7034), 1, 1, 1, "sandking_skg_anger_05", Vector(-1, 1), false, nil)
	Dungeons:SpawnDungeonUnit("ancient_ghost", Vector(9350, -7324), 1, 1, 1, "sandking_skg_anger_05", Vector(0, 1), false, nil)

	Dungeons:SpawnDungeonUnit("raging_flame", Vector(9280, -7884), 1, 1, 1, "undying_undying_anger_06", Vector(1, 1), false, nil)
	Dungeons:SpawnDungeonUnit("raging_flame", Vector(9480, -7934), 1, 1, 1, "undying_undying_anger_06", Vector(-1, 1), false, nil)
	Dungeons:SpawnDungeonUnit("raging_flame", Vector(9350, -8124), 1, 1, 1, "undying_undying_anger_06", Vector(0, 1), false, nil)

	Dungeons:SpawnDungeonUnit("demon_clown", Vector(9280, -9920), 1, 1, 3, "undying_undying_happy_05", Vector(1, 1), false, nil)
	Dungeons:SpawnDungeonUnit("demon_clown", Vector(9600, -9600), 1, 1, 3, "undying_undying_happy_05", Vector(-1, 1), false, nil)

	Dungeons:SpawnDungeonUnit("demon_clown", Vector(11559, -9920), 1, 1, 3, "undying_undying_happy_05", Vector(0, 1), false, nil)

	local ghost = Dungeons:SpawnDungeonUnit("rare_ghost_tomb", Vector(10401, -9511), 1, 1, 3, "n_creep_ghost.Death", Vector(-1, -1), false, nil)
	local ghostAbil = ghost:FindAbilityByName("npc_abilities"):ApplyDataDrivenModifier(ghost, ghost, "modifier_rare_ghost_thinker", {duration = 99999})
	ghost = Dungeons:SpawnDungeonUnit("rare_ghost_tomb", Vector(10401, -9721), 1, 1, 3, "n_creep_ghost.Death", Vector(-1, 0), false, nil)
	ghostAbil = ghost:FindAbilityByName("npc_abilities"):ApplyDataDrivenModifier(ghost, ghost, "modifier_rare_ghost_thinker", {duration = 99999})
	ghost = Dungeons:SpawnDungeonUnit("rare_ghost_tomb", Vector(10401, -9930), 1, 1, 3, "n_creep_ghost.Death", Vector(-1, 1), false, nil)
	ghostAbil = ghost:FindAbilityByName("npc_abilities"):ApplyDataDrivenModifier(ghost, ghost, "modifier_rare_ghost_thinker", {duration = 99999})

	local pudge = Dungeons:SpawnDungeonUnit("chained_butcher", Vector(10909, -9525), 1, 1, 3, "pudge_pud_anger_04", Vector(-1, 0), false, nil)
	pudge = Dungeons:SpawnDungeonUnit("chained_butcher", Vector(11365, -9525), 1, 1, 3, "pudge_pud_anger_04", Vector(-1, 0), false, nil)
	for i = 1, 6, 1 do
		local soul_sucker = Dungeons:SpawnDungeonUnit("soul_sucker", Vector(11951, -9740) + RandomVector(RandomInt(100, 300)), 1, 1, 1, "bane_bane_acknow_07", RandomVector(1), false, nil)
		soul_sucker:FindAbilityByName("creature_vacuum_channel"):SetLevel(1)
	end
	local hermit = Dungeons:SpawnDungeonUnit("spine_hermit", Vector(13312, -9984), 1, 7, 9, "bristleback_bristle_attack_18", Vector(1, 1), false, nil)
	Events:AdjustDeathXP(hermit)
	Events:AdjustBossPower(hermit, 3, 3, false)
	local hermitAbility = hermit:FindAbilityByName("hermit_leap")
	hermitAbility:ApplyDataDrivenModifier(hermit, hermit, "modifier_hermit_initial", {})
	hermit.jumpEnd = "hermit"

	--WALL
	local wallPoint1 = Vector(13192, -8708, 450)
	local wallPoint2 = Vector(13836, -8723, 420)
	local particle = "particles/units/heroes/hero_dark_seer/crixalis_wal_of_replica.vpcf"
	Dungeons.wallParticle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 0, wallPoint1)
	ParticleManager:SetParticleControl(Dungeons.wallParticle, 1, wallPoint2)
	Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(13376, -8766), Name = "wallObstruction"})
	Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(13504, -8766), Name = "wallObstruction"})
	Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(13632, -8766), Name = "wallObstruction"})
	Dungeons.blocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(13760, -8736), Name = "wallObstruction"})
	--WALL^
	--hermit--
	local thinker = Dungeons:CreateDungeonThinker(Vector(12964, -10048), "hermit", 480, "sand_tomb")
	thinker.hermit = hermit
	--
	Dungeons:CreateDungeonThinker(Vector(13312, -9984), "spawnSecondHalf", 720, "sand_tomb")

	local chestThinker = Dungeons:CreateDungeonThinker(Vector(10672, -5965), "graveyardChest", 240, "graveyard")
	chestThinker.chest = CreateUnitByName("chest", Vector(10672, -5965), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(-1, -1))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)

	local relic = CreateUnitByName("prop_unit", Vector(11136, -1742) + Vector(175, 0, 0), false, nil, nil, DOTA_TEAM_GOODGUYS)
	relic:SetOriginalModel("models/items/chen/squareskystaff_weapon/squareskystaff_weapon.vmdl")
	relic:SetModel("models/items/chen/squareskystaff_weapon/squareskystaff_weapon.vmdl")
	relic:SetForwardVector(Vector(0, -1))
	ability = relic:AddAbility("ability_sand_relic_passive")
	ability:SetLevel(1)
	local relicPos = relic:GetAbsOrigin() + Vector(0, 0, 100)
	relic:SetAbsOrigin(relicPos)
	relic:SetForwardVector(Vector(0, 1))
	relic:AddAbility("replica")
	relic:FindAbilityByName("replica"):SetLevel(1)
	relic:SetModelScale(2.2)
	ability.relic = relic
	ability.relicPosition = relicPos
	ability.liftPos = 0
	ability.totalLift = 0
	ability.liftVelocity = 0
	ability.lifting = true

	local relicDummy = CreateUnitByName("dummy_unit_vulnerable", Vector(11136, -1792), false, nil, nil, DOTA_TEAM_GOODGUYS)
	ability:ApplyDataDrivenModifier(relic, relicDummy, "modifier_relic_dummy_effect", {duration = 99999})
	ability.dummy = relicDummy
end

function Dungeons:InitializeVault()
	Dungeons.entityTable = {}
	Dungeons.DungeonMaster = CreateUnitByName("rune_unit", Vector(-8000, 2000), true, nil, nil, DOTA_TEAM_GOODGUYS)
	Dungeons.DungeonMaster:AddAbility("dummy_unit"):SetLevel(1)
	Dungeons.DungeonMaster:AddAbility("vault_arrows"):SetLevel(1)
	Dungeons.DungeonMaster.arrowAbility = Dungeons.DungeonMaster:FindAbilityByName("vault_arrows")
	Dungeons.DungeonMaster:AddAbility("vault_fire"):SetLevel(1)
	Dungeons.DungeonMaster.fireAbility = Dungeons.DungeonMaster:FindAbilityByName("vault_fire")
	table.insert(Dungeons.entityTable, Dungeons.DungeonMaster)

	-- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(15278, -1344), 5000, 99999, false)

	-- local openingSequenceThinker = Dungeons:CreateDungeonThinker(Vector(9331, -3776), "openingSequence", 520, "sand_tomb")
	local vaultGuard = Dungeons:SpawnDungeonUnit("vault_guard", Vector(15278, -1344), 1, 2, 3, "doom_bringer_doom_anger_02", Vector(0, -1), false, nil)
	vaultGuard:AddAbility("vault_guard_ability"):SetLevel(1)

	for i = 1, 3, 1 do
		local assassin = Dungeons:SpawnDungeonUnit("vault_assassin", Vector(15774, -2624), 1, 1, 1, "riki_riki_anger_01", Vector(0, 1), false, nil)
		assassin.aggroRadius = 160
		assassin.stop = true
	end
	local thinker = Dungeons:CreateDungeonThinker(Vector(15774, -2624), "rikiPatrolPoint", 300, "vault")
	thinker.patrolPointIndex = 1
	thinker.enemy = true
	table.insert(Dungeons.entityTable, thinker)
	thinker = Dungeons:CreateDungeonThinker(Vector(15751, -437), "rikiPatrolPoint", 300, "vault")
	thinker.patrolPointIndex = 2
	thinker.enemy = true
	table.insert(Dungeons.entityTable, thinker)
	thinker = Dungeons:CreateDungeonThinker(Vector(14800, -437), "rikiPatrolPoint", 300, "vault")
	thinker.patrolPointIndex = 3
	thinker.enemy = true
	table.insert(Dungeons.entityTable, thinker)
	thinker = Dungeons:CreateDungeonThinker(Vector(14800, -2624), "rikiPatrolPoint", 300, "vault")
	thinker.patrolPointIndex = 4
	thinker.enemy = true
	table.insert(Dungeons.entityTable, thinker)

	Dungeons.antiMage = CreateUnitByName("vault_antimage", Vector(8942, 1664), true, nil, nil, DOTA_TEAM_NEUTRALS)

	Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(14592, -1344), Name = "wallObstruction"})
	Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(14592, -1216), Name = "wallObstruction"})
	Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(14592, -1088), Name = "wallObstruction"})

	Dungeons.wall1 = CreateUnitByName("npc_dummy_unit", Vector(14592, -1337), false, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.wall1:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall1:SetModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall1:SetModelScale(1.6)
	Dungeons.wall1:SetForwardVector(Vector(0, 1))
	Dungeons.wall1:SetAbsOrigin(Dungeons.wall1:GetAbsOrigin() + Vector(0, 0, 256))
	Dungeons.wall1:FindAbilityByName("dummy_unit"):SetLevel(1)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(14592, -1233), 300, 99999, false)
	Dungeons.wall2 = CreateUnitByName("npc_dummy_unit", Vector(14592, -1130), false, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.wall2:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall2:SetModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall2:SetModelScale(1.6)
	Dungeons.wall2:SetForwardVector(Vector(0, 1))
	Dungeons.wall2:SetAbsOrigin(Dungeons.wall2:GetAbsOrigin() + Vector(0, 0, 256))
	Dungeons.wall2:FindAbilityByName("dummy_unit"):SetLevel(1)
	Dungeons:VaultGoldRoom()
	table.insert(Dungeons.entityTable, Dungeons.wall1)
	table.insert(Dungeons.entityTable, Dungeons.wall2)
end

function Dungeons:VaultGoldRoom()
	Dungeons.goldStatus = 0
	Dungeons:CreateVaultStatue("vault_statue_one", Vector(15696, 1658), 0)
	Dungeons:CreateVaultStatue("vault_statue_two", Vector(14711, 1653), 1)
	Dungeons:CreateVaultStatue("vault_statue_three", Vector(13885, 1658), 2)
	Dungeons:CreateVaultStatue("vault_statue_four", Vector(12990, 1658), 3)
	Dungeons:CreateVaultStatue("vault_statue_five", Vector(12029, 1658), 4)

	local goldUnit = Dungeons:SpawnDungeonUnit("vault_statue_six", Vector(11328, 1536, 128), 1, 4, 5, nil, Vector(1, 0), false, nil)
	goldUnit.aggroRadius = 0
	Timers:CreateTimer(2, function()
		Dungeons.DungeonMaster.fireAbility:ApplyDataDrivenModifier(Dungeons.DungeonMaster, goldUnit, "modifier_vault_golden_frozen", {})
	end)
	thinker = Dungeons:CreateDungeonThinker(Vector(11528, 1536), "goldStatue", 260, "vault")
	thinker.statue = goldUnit
	thinker.seqNumber = 5
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(11328, 1536, 128), 200, 99999, false)

	Dungeons.finalPedestal = CreateUnitByName("npc_dummy_unit", Vector(11328, 1536, 0), false, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.finalPedestal:SetOriginalModel("models/heroes/pedestal/effigy_pedestal_ti5_dire.vmdl")
	Dungeons.finalPedestal:SetModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.finalPedestal:SetModelScale(2.0)
	Dungeons.finalPedestal:SetForwardVector(Vector(1, 0))
	Dungeons.finalPedestal:SetAbsOrigin(Dungeons.finalPedestal:GetAbsOrigin() + Vector(0, 0, 80))
	Dungeons.finalPedestal:FindAbilityByName("dummy_unit"):SetLevel(1)
	table.insert(Dungeons.entityTable, Dungeons.finalPedestal)
end

function Dungeons:CreateVaultStatue(statue_name, location, number)
	local goldUnit = Dungeons:SpawnDungeonUnit(statue_name, location, 1, 2, 3, nil, Vector(0, -1), false, nil)
	goldUnit.aggroRadius = 0
	Timers:CreateTimer(2, function()
		Dungeons.DungeonMaster.fireAbility:ApplyDataDrivenModifier(Dungeons.DungeonMaster, goldUnit, "modifier_vault_golden_frozen", {})
	end)
	thinker = Dungeons:CreateDungeonThinker(location + Vector(0, -200, 0), "goldStatue", 260, "vault")
	thinker.statue = goldUnit
	thinker.seqNumber = number
	AddFOWViewer(DOTA_TEAM_GOODGUYS, location, 200, 99999, false)

end

function Dungeons:VaultRoom3()
	for i = 1, 4, 1 do
		Dungeons:SpawnDungeonUnit("vault_worshipper", Vector(14188 + i * 100, 60), 1, 1, 1, "doom_bringer_doom_anger_05", Vector(0, -1), false, nil)
	end
	for i = 1, 3, 1 do
		Dungeons:SpawnDungeonUnit("vault_worshipper", Vector(14288 + i * 100, 160), 1, 1, 1, "doom_bringer_doom_anger_05", Vector(0, -1), false, nil)
	end
	for i = 1, 2, 1 do
		Dungeons:SpawnDungeonUnit("vault_worshipper", Vector(14388 + i * 100, 260), 1, 1, 1, "doom_bringer_doom_anger_05", Vector(0, -1), false, nil)
	end
	Dungeons:SpawnDungeonUnit("vault_worshipper", Vector(14488, 360), 1, 1, 1, "doom_bringer_doom_anger_05", Vector(0, -1), false, nil)
	Dungeons:CreateDungeonThinker(Vector(14912, 256), "coffin", 300, "vault")
	Timers:CreateTimer(5, function()
		for i = 0, 5, 1 do
			Timers:CreateTimer(1 * i, function()
				local position = Vector(14257 - (i * 512), 896, 100)
				local assassin = Dungeons:SpawnDungeonUnit("unreal_terror", position, 1, 6, 8, "terrorblade_terr_morph_move_12", Vector(1, 0), false, nil)
				local spikeTrap = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
				table.insert(Dungeons.entityTable, spikeTrap)
				spikeTrap:SetOriginalModel("models/props/traps/spiketrap/spiketrap.vmdl")
				spikeTrap:SetModel("models/props/traps/spiketrap/spiketrap.vmdl")
				spikeTrap:SetModelScale(2.0)
				spikeTrap:SetForwardVector(Vector(1, 0))
				spikeTrap:FindAbilityByName("dummy_unit"):SetLevel(1)
				local thinker = Dungeons:CreateDungeonThinker(position, "spikeTrap", 258, "vault")
				table.insert(Dungeons.entityTable, thinker)
				thinker.spikeTrap = spikeTrap
			end)
		end
	end)
	local chestThinker = Dungeons:CreateDungeonThinker(Vector(10560, 960), "graveyardChest", 160, "graveyard")
	chestThinker.lootLaunch = Vector(200, 100)
	chestThinker.chest = CreateUnitByName("chest", Vector(10560, 960), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(1, 0))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)
	local chestThinker = Dungeons:CreateDungeonThinker(Vector(10560, 770), "graveyardChest", 160, "graveyard")
	chestThinker.lootLaunch = Vector(200, 100)
	chestThinker.chest = CreateUnitByName("chest", Vector(10560, 770), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chestThinker.chest:SetForwardVector(Vector(1, 0))
	chestThinker.chest:FindAbilityByName("town_unit"):SetLevel(1)

	Dungeons:CreateDungeonThinker(Vector(12800, 320), "room4", 160, "vault")

	Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(12544, 448), Name = "wallObstruction"})
	Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(12544, 320), Name = "wallObstruction"})
	Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(12544, 192), Name = "wallObstruction"})

	Dungeons.wall1 = CreateUnitByName("npc_dummy_unit", Vector(12538, 409), false, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.wall1:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall1:SetModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall1:SetModelScale(1.7)
	Dungeons.wall1:SetForwardVector(Vector(0, 1))
	Dungeons.wall1:SetAbsOrigin(Dungeons.wall1:GetAbsOrigin() + Vector(0, 0, 256))
	Dungeons.wall1:FindAbilityByName("dummy_unit"):SetLevel(1)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(12538, 317), 300, 99999, false)
	Dungeons.wall2 = CreateUnitByName("npc_dummy_unit", Vector(12538, 187), false, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.wall2:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall2:SetModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall2:SetModelScale(1.7)
	Dungeons.wall2:SetForwardVector(Vector(0, 1))
	Dungeons.wall2:SetAbsOrigin(Dungeons.wall2:GetAbsOrigin() + Vector(0, 0, 256))
	Dungeons.wall2:FindAbilityByName("dummy_unit"):SetLevel(1)
	table.insert(Dungeons.entityTable, Dungeons.wall1)
	table.insert(Dungeons.entityTable, Dungeons.wall2)
end

function Dungeons:vaultRoom4()
	Dungeons:SpawnDungeonUnit("vault_arcanist", Vector(12864, -64), 1, 1, 2, "silencer_silen_laugh_13", Vector(0, 1), false, nil)
	Dungeons:SpawnDungeonUnit("vault_arcanist", Vector(12708, -215), 1, 1, 2, "silencer_silen_laugh_13", Vector(0, 1), false, nil)
	Dungeons:SpawnDungeonUnit("vault_arcanist", Vector(13028, -215), 1, 1, 2, "silencer_silen_laugh_13", Vector(0, 1), false, nil)
	local vectorTable = {Vector(12672, -524), Vector(13013, -524), Vector(12672, -824), Vector(13013, -824), Vector(12672, -1121), Vector(13013, -1121), Vector(12672, -1421), Vector(13013, -1421)}
	local fvTable = {Vector(1, 0), Vector(-1, 0), Vector(1, 0), Vector(-1, 0), Vector(1, 0), Vector(-1, 0), Vector(1, 0), Vector(-1, 0)}
	for i = 1, #vectorTable, 1 do
		Timers:CreateTimer(1 * i, function()
			local position = vectorTable[i]
			local barkingDog = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			table.insert(Dungeons.entityTable, barkingDog)
			barkingDog:SetOriginalModel("models/props/traps/barking_dog/barking_dog.vmdl")
			barkingDog:SetModel("models/props/traps/barking_dog/barking_dog.vmdl")
			barkingDog:SetForwardVector(fvTable[i])
			barkingDog:FindAbilityByName("dummy_unit"):SetLevel(1)
			local thinker = Dungeons:CreateDungeonThinker(Vector(12872, vectorTable[i].y), "barkingDog", 258, "vault")
			thinker.barkingDog = barkingDog
			table.insert(Dungeons.entityTable, thinker)
		end)
	end
	Dungeons:CreateDungeonThinker(Vector(13696, -1683), "antiMageMad", 160, "vault")
	local vendor = Events:SpawnTownNPC(Vector(12416, -2446), "red_fox", Vector(1, 0), "models/items/courier/sltv_10_courier/sltv_10_courier.vmdl", nil, nil, 1.2, false, "rareShop")
	table.insert(Dungeons.entityTable, vendor)
	Dungeons.goldApplyThinker = Dungeons:CreateDungeonThinker(Vector(12480, -2178), "applyGold", 200, "vault")
	table.insert(Dungeons.entityTable, Dungeons.goldApplyThinker)
	local position = Vector(12480, -2178)
	Dungeons.goldPfx = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/jade_effigy_ambient_radiant.vpcf", PATTACH_CUSTOMORIGIN, Dungeons.goldApplyThinker)
	ParticleManager:SetParticleControl(Dungeons.goldPfx, 0, position)

	Dungeons:CreateDungeonThinker(Vector(8960, 113), "boss_initiate", 480, "vault")
end

function Dungeons:CreateDungeonThinker(position, type, radius, dungeon)
	local thinker = CreateUnitByName("dungeon_thinker", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	thinker.type = type
	thinker.dungeon = dungeon
	thinker.radius = radius
	thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)
	return thinker
end

function Dungeons:DeaggroUnit(caster)
	caster:Stop()
	caster.aggro = false
	caster:SetAcquisitionRange(0)
	caster:AddAbility("dungeon_creep"):SetLevel(1)
	caster:RemoveAbility("dungeon_creep_aggroed")
	caster:FindAbilityByName("dungeon_creep"):ApplyDataDrivenModifier(caster, caster, "modifier_dungeon_thinker_creep", {})
end

function Dungeons:AggroUnit(caster)
	if caster.cantAggro then
		return false
	end
	caster.aggro = true
	if caster.stop then
		caster:Stop()
	end
	if caster.specialAggro then
		Dungeons:SpecialAggro(caster)
		--print("SHOULD AGGRO")
		--print("SHOULD AGGRO")
		--print("SHOULD AGGRO")
	end
	caster:SetAcquisitionRange(3500)
	caster:RemoveModifierByName("modifier_dungeon_thinker_creep")
	if caster:HasAbility("dungeon_creep") then
		caster:RemoveAbility("dungeon_creep")
	end
	local aggrod = caster:FindAbilityByName("dungeon_creep_aggroed")
	local ability = nil
	if not aggrod then
		ability = caster:AddAbility("dungeon_creep_aggroed")
	else
		ability = aggrod
	end
	if ability then
		ability:SetLevel(1)
	end
	if caster.aggroSound then
		EmitSoundOn(caster.aggroSound, caster)
	end
	if caster.special then
		if caster.special == "gazbinAlch" then
			--print("lets fire this skill")
			EmitSoundOn("alchemist_alch_laugh_04", caster)
			EmitSoundOn("alchemist_alch_laugh_04", caster)
			EmitSoundOn("alchemist_alch_laugh_04", caster)
			local ability = caster:FindAbilityByName("gazbin_alchemist_create_trees")
			local order =
			{
				UnitIndex = caster:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = ability:GetEntityIndex(),
				TargetIndex = caster.dummyTarget:GetEntityIndex(),
				Queue = false
			}
			ExecuteOrderFromTable(order)
			Timers:CreateTimer(1.5, function()
				caster.sprite:DestroyAllSpeechBubbles()
				local time = 8
				local speechSlot = 1
				caster.sprite:AddSpeechBubble(speechSlot, "#logging_camp_sprite_dialogue_two", time, 0, 0)
			end)
		end
	end
end

function Dungeons:SpecialAggro(caster)
	if caster.specialAggro == "keyholder" then
		--print("CHANGE ATTACK!")
		caster:SetBaseHealthRegen(2)
		caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
		caster:RemoveAbility("invis_dungeon_creep")
		caster:RemoveModifierByName("modifier_dungeon_thinker_creep_invis")
		caster:AddAbility("key_holder_ability"):SetLevel(1)
	end
end

function Dungeons:MoveHeroAndUnits(hero, location)
	FindClearSpaceForUnit(hero, location, true)
	if hero.earthAspect then
		FindClearSpaceForUnit(hero.earthAspect, location, true)
	end
	if hero.fireAspect then
		FindClearSpaceForUnit(hero.fireAspect, location, true)
	end
	if hero.shadowAspect then
		FindClearSpaceForUnit(hero.shadowAspect, location, true)
	end
end

function Dungeons:Debug()
	if not Dungeons.initialized then
		Dungeons.entityTable = {}
		Dungeons.antiMage = CreateUnitByName("vault_antimage", Vector(8942, 1664), true, nil, nil, DOTA_TEAM_NEUTRALS)
		Dungeons.DungeonMaster = CreateUnitByName("rune_unit", Vector(-8000, 2000), true, nil, nil, DOTA_TEAM_GOODGUYS)
		Dungeons.DungeonMaster:AddAbility("vault_arrows"):SetLevel(1)
		Dungeons.DungeonMaster.arrowAbility = Dungeons.DungeonMaster:FindAbilityByName("vault_arrows")
		Dungeons.DungeonMaster:AddAbility("vault_fire"):SetLevel(1)
		Dungeons.DungeonMaster.fireAbility = Dungeons.DungeonMaster:FindAbilityByName("vault_fire")
		Dungeons.initialized = true
	end
	-- if Dungeons.wall3 then
	-- UTIL_Remove(Dungeons.wall3)
	-- end
	Dungeons:vaultRoom4()
	-- Dungeons.blocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(9088,1894), Name ="wallObstruction"})
	-- Dungeons.blocker5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(9216,1894), Name ="wallObstruction"})
	-- Dungeons.wall3 = CreateUnitByName("npc_dummy_unit", Vector(9182,1930), false, nil, nil, DOTA_TEAM_NEUTRALS)
	-- Dungeons.wall3:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
	-- Dungeons.wall3:SetModel("models/props_garden/good_stonewall001c.vmdl")
	-- Dungeons.wall3:SetModelScale(2.4)
	-- Dungeons.wall3:SetForwardVector(Vector(1,0))
	-- Dungeons.wall3:SetAbsOrigin(Dungeons.wall3:GetAbsOrigin()+Vector(0,0,326))
	-- Dungeons.wall3:FindAbilityByName("dummy_unit"):SetLevel(1)
	-- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(9150,1920), 300, 99999, false)
end

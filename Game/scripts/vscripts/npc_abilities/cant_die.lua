
EXPLOSION_SOUND_TABLE = {"Hero_Techies.RemoteMine.Detonate", "Hero_Rattletrap.Rocket_Flare.Explode"}
EXPLOSION_PARTICLE_TABLE = {"particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"}

function death_check(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.deathStart then
		if caster:GetHealth() < 50 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dying_generic", {duration = 20})
			CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
			caster.deathStart = true
			if caster:GetUnitName() == "graveyard_boss" then
				graveyard_boss_die(caster)
			elseif caster:GetUnitName() == "lumber_mill_boss" then
				lumber_mill_boss_die(caster)
			elseif caster:GetUnitName() == "sand_tomb_boss" then
				sand_tomb_boss_die(caster)
			elseif caster:GetUnitName() == "mines_boss" then
				mines_boss_die(caster)
			elseif caster:GetUnitName() == "dynasty_heir_majinaq" then
				vault_boss_die(caster)
			elseif caster:GetUnitName() == "chaos_chieftain" then
				town_siege_boss_die(caster)
			elseif caster:GetUnitName() == "castle_boss" then
				castle_boss_die(caster)
			elseif caster:GetUnitName() == "swamp_boss" then
				swamp_boss_die(caster)
			elseif caster:GetUnitName() == "ruins_boss" then
				ruins_boss_die(caster)
			elseif caster:GetUnitName() == "grizzly_falls_boss" then
				grizzly_boss_die(caster)
			elseif caster:GetUnitName() == "phoenix_boss" then
				phoenix_boss_die(caster)
			end
		end
	end
end

function death_check_special(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.deathStart then
		if caster:GetHealth() < 150 then
			caster.deathStart = true
			if caster:GetUnitName() == "courtyard_summoner" then
				courtyard_summoner(caster)
			end
		end
	end
end

function BossTakeDamage(event)
	local caster = event.caster
	local ability = event.ability
	CustomGameEventManager:Send_ServerToAllClients("update_boss_health", {current_health = caster:GetHealth(), bossId = tostring(caster)})
end

function death_animation(keys)
	caster = keys.caster
	local particleName = EXPLOSION_PARTICLE_TABLE[RandomInt(1, 1)]
	local particleVector = caster:GetAbsOrigin()
	pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true)
	local sound = EXPLOSION_SOUND_TABLE[RandomInt(1, 2)]
	EmitSoundOn(sound, caster)
end

function graveyard_boss_die(caster)
	caster:RemoveModifierByName("modifier_graveyard_boss_blast")
	local casterOrigin = caster:GetAbsOrigin()
	for i = 0, 9, 1 do
		Timers:CreateTimer(0.4 * i, function()
			RPCItems:RollItemtype(300, casterOrigin, 1, 0)
		end)
	end
	Dungeons.cleared.graveyard = true
	GameState:WraithDefeat(caster:GetUnitName(), casterOrigin)
	EmitSoundOn("skeleton_king_wraith_death_long_01", caster)
	EmitSoundOn("skeleton_king_wraith_death_long_01", caster)
	EmitSoundOn("skeleton_king_wraith_death_long_01", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	local luck = RandomInt(1, 3)
	if luck == 3 then
		RPCItems:RollBoneguardGauntlets(casterOrigin)
	end

	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.27})
		EmitSoundOn("skeleton_king_wraith_death_long_09", caster)
		EmitSoundOn("skeleton_king_wraith_death_long_09", caster)
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(-6784, -12160), Vector(-5248, -7360), "graveyard", nil, true)
		UTIL_Remove(caster)
	end)
	Beacons:CreateBeacons()
	Dungeons.entryPoint = nil
end

function lumber_mill_boss_die(caster)
	caster.dying = true
	Dungeons.itemLevel = 25
	for i = 0, 10, 1 do
		Timers:CreateTimer(0.4 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	local casterOrigin = caster:GetAbsOrigin()
	GameState:GazbinDefeat(caster:GetUnitName(), casterOrigin)
	Dungeons.cleared.lumbermill = true
	EmitSoundOn("batrider_bat_death_01", caster)
	EmitSoundOn("batrider_bat_death_01", caster)
	EmitSoundOn("batrider_bat_death_01", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.25})
		EmitSoundOn("batrider_bat_death_07", caster)
		EmitSoundOn("batrider_bat_death_07", caster)
		EmitSoundOn("batrider_bat_death_07", caster)
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(-10816, -7872), Vector(-7104, -6464), "lumbermill", nil, true)
		UTIL_Remove(caster)
		Dungeons.itemLevel = 17
	end)
	Beacons:CreateBeacons()
	Dungeons.entryPoint = nil
end

function sand_tomb_boss_die(caster)
	caster.dying = true
	Dungeons.itemLevel = 50
	for i = 0, 12, 1 do
		Timers:CreateTimer(0.4 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	local luck = RandomInt(1, 5)
	if luck == 5 then
		RPCItems:RollSandTombOrb(300, caster:GetAbsOrigin(), "immortal", false, "", nil)
	end
	local casterOrigin = caster:GetAbsOrigin()
	GameState:SilithicusDefeat(caster:GetUnitName(), casterOrigin)
	Dungeons.cleared.sandtomb = true
	EmitSoundOn("venomancer_venm_death_01", caster)
	EmitSoundOn("venomancer_venm_death_01", caster)
	EmitSoundOn("venomancer_venm_death_01", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.25})
		EmitSoundOn("venomancer_venm_death_08", caster)
		EmitSoundOn("venomancer_venm_death_08", caster)
		EmitSoundOn("venomancer_venm_death_08", caster)
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(12907, -4480), Vector(7300, -2485), "sandtomb", nil, true)
		UTIL_Remove(caster)
		Dungeons.itemLevel = 30
	end)
	Dungeons.entryPoint = nil
	for i = 1, #Dungeons.entityTable, 1 do
		UTIL_Remove(Dungeons.entityTable[i])
	end
	Beacons:CreateBeacons()
end

function town_siege_boss_die(caster)
	caster.dying = true
	Dungeons.itemLevel = 8
	for i = 0, 9, 1 do
		Timers:CreateTimer(0.4 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	StartAnimation(Dungeons.commander, {duration = 3.5, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.7})
	GameState:ChieftainDefeat()
	Dungeons.cleared.townsiege = true
	EmitSoundOn("chaos_knight_chaknight_death_05", caster)
	EmitSoundOn("chaos_knight_chaknight_death_05", caster)
	EmitSoundOn("chaos_knight_chaknight_death_05", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.25})
		EmitSoundOn("chaos_knight_chaknight_death_01", caster)
		EmitSoundOn("chaos_knight_chaknight_death_01", caster)
		EmitSoundOn("chaos_knight_chaknight_death_01", caster)
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(-5504, 2176), Vector(-14074, 13888), "townsiege", nil, true)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-5504, 2176), 600, 99999, false)
		UTIL_Remove(caster)
		Dungeons.itemLevel = 5
	end)
	Dungeons.entryPoint = nil
	Timers:CreateTimer(120, function()
		UTIL_Remove(Dungeons.commander)
		for i = 1, #Dungeons.siegeEntityTable, 1 do
			local unit = Dungeons.siegeEntityTable[i]
			if unit then
				if not unit:IsNull() then
					UTIL_Remove(Dungeons.siegeEntityTable[i])
				end
			end
		end
	end)
	Beacons:CreateBeacons()
	-- for i = 1, #Dungeons.entityTable, 1 do
	-- UTIL_Remove(Dungeons.entityTable[i])
	-- end
end

function mines_boss_die(caster)
	caster.dying = true
	for i = 0, 20, 1 do
		Timers:CreateTimer(0.2 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	GameState:RazormoreDefeat()
	EmitGlobalSound("razor_raz_death_04")
	EmitGlobalSound("razor_raz_death_04")
	EmitGlobalSound("razor_raz_death_04")
	Events:updateKillQuest(caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Events:EarnKey("mines")
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Act 3 Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 10.5, activity = ACT_DOTA_DIE, rate = 0.25})
		EmitSoundOn("razor_raz_death_05", caster)
		EmitSoundOn("razor_raz_death_05", caster)
		EmitSoundOn("razor_raz_death_05", caster)
	end)
	Timers:CreateTimer(13, function()
		UTIL_Remove(caster)
	end)
end

function vault_boss_die(caster)
	lowerWall(Dungeons.wall1)
	lowerWall(Dungeons.wall2)
	lowerWall(Dungeons.wall3)
	Timers:CreateTimer(5, function()
		UTIL_Remove(Dungeons.blocker1)
		Dungeons.blocker1 = false
		UTIL_Remove(Dungeons.blocker2)
		Dungeons.blocker2 = false
		UTIL_Remove(Dungeons.blocker3)
		Dungeons.blocker3 = false
		UTIL_Remove(Dungeons.blocker4)
		Dungeons.blocker4 = false
		UTIL_Remove(Dungeons.blocker5)
		Dungeons.blocker5 = false
	end)
	caster.dying = true
	Dungeons.itemLevel = 78
	for i = 0, 10, 1 do
		Timers:CreateTimer(0.7 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	local luck = RandomInt(1, 5)
	if luck == 5 then
		Timers:CreateTimer(0.5, function()
			RPCItems:RollHandOfMidas(caster:GetAbsOrigin())
		end)
	end
	local casterOrigin = caster:GetAbsOrigin()
	GameState:MajinaqDefeat(caster:GetUnitName(), casterOrigin)
	Dungeons.cleared.vault = true
	EmitSoundOn("antimage_anti_lose_01", caster)
	EmitSoundOn("antimage_anti_lose_01", caster)
	EmitSoundOn("antimage_anti_lose_01", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.25})
		EmitSoundOn("antimage_anti_death_04", caster)
		EmitSoundOn("antimage_anti_death_04", caster)
		EmitSoundOn("antimage_anti_death_04", caster)
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(9007, 2368), Vector(7236, -1846), "vault", nil, true)
		UTIL_Remove(caster)
		Dungeons.itemLevel = 48
	end)
	Dungeons.entryPoint = nil
	Timers:CreateTimer(30, function()
		for i = 1, #Dungeons.entityTable, 1 do
			Timers:CreateTimer(1 * i, function()
				if not Dungeons.entityTable[i]:IsNull() then
					UTIL_Remove(Dungeons.entityTable[i])
				end
			end)
		end
	end)
	Beacons:CreateBeacons()
end

function lowerWall(wall)
	EmitSoundOn("Visage_Familar.StoneForm.Cast", wall)
	local wallOrigin = wall:GetAbsOrigin()
	ScreenShake(wallOrigin, 200, 0.5, 1, 9000, 0, true)
	for i = 1, 60, 1 do
		Timers:CreateTimer(i * 0.05, function()
			wall:SetAbsOrigin(wallOrigin - Vector(0, 0, 4) * i)
		end)
	end
	Timers:CreateTimer(3, function()
		ScreenShake(wallOrigin, 200, 0.5, 1, 9000, 0, true)
		EmitSoundOn("Visage_Familar.StoneForm.Cast", wall)
	end)
	-- Timers:CreateTimer(5, function()
	-- UTIL_Remove(wall)
	-- end)
end

function courtyard_summoner(caster)
	caster.state = 6
	caster:SetModelScale(0.9)
	local ability = caster:FindAbilityByName("courtyard_summoner_ai")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_summoner_stage_two", {})
	caster:Heal(caster:GetMaxHealth(), caster)
	EmitGlobalSound("clinkz_clinkz_death_04")
	caster:MoveToPosition(Vector(-1472, 8640))
	local thinker = Dungeons:CreateDungeonThinker(Vector(-1472, 8640), "summoner_move", 500, "castle")
	thinker.stage = 1
	thinker.summoner = caster
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	caster:SetBaseMoveSpeed(360)

end

function castle_boss_die(caster)
	caster.dying = true
	Dungeons.itemLevel = 90
	Dungeons.lootLaunch = caster:GetAbsOrigin() + caster:GetForwardVector() * 800 * Vector(1, 1, 0)
	local casterOrigin = caster:GetAbsOrigin()
	for i = 0, 13, 1 do
		Timers:CreateTimer(0.2 * i, function()
			RPCItems:RollItemtype(300, casterOrigin * Vector(1, 1, 0) + 700, 1, 0)
		end)
	end
	UTIL_Remove(Dungeons.eyeDummy)
	UTIL_Remove(Dungeons.blocker1)
	UTIL_Remove(Dungeons.blocker2)
	UTIL_Remove(Dungeons.blocker3)
	Dungeons.blocker1 = nil
	Dungeons.blocker2 = nil
	Dungeons.blocker3 = nil
	local luck = RandomInt(1, 6)
	if luck == 1 then
		RPCItems:RollEyeOfAvernus(casterOrigin, false)
	end
	ParticleManager:DestroyParticle(Dungeons.wallParticle, false)
	GameState:CountDefeat(caster:GetUnitName(), casterOrigin)
	EmitGlobalSound("abaddon_abad_death_01")
	EmitGlobalSound("abaddon_abad_death_01")
	EmitGlobalSound("abaddon_abad_death_01")
	EmitGlobalSound("abaddon_abad_death_01")
	EmitGlobalSound("abaddon_abad_death_01")
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 10.5, activity = ACT_DOTA_DIE, rate = 0.25})
		EmitSoundOn("abaddon_abad_death_08", caster)
		EmitSoundOn("abaddon_abad_death_08", caster)
		EmitSoundOn("abaddon_abad_death_08", caster)
		EmitSoundOn("abaddon_abad_death_08", caster)
		EmitSoundOn("abaddon_abad_death_08", caster)
	end)
	Timers:CreateTimer(13, function()
		UTIL_Remove(caster)
		Dungeons.lootLaunch = nil
		Dungeons.itemLevel = 60
		Beacons:CreatePortal(Vector(-5250, 11935), Vector(827, 2796), "castle", nil, true)
		local mode = GameRules:GetGameModeEntity()
		mode:SetCameraDistanceOverride(CAMERA_DISTANCE_OVERRIDE)
	end)
	Timers:CreateTimer(120, function()
		for i = 1, #Dungeons.castleEntityTable, 1 do
			Timers:CreateTimer(0.2 * i, function()
				if not Dungeons.castleEntityTable[i]:IsNull() then
					UTIL_Remove(Dungeons.castleEntityTable[i])
				end
			end)
		end
		Timers:CreateTimer(0.4 * #Dungeons.castleEntityTable, function()
			Dungeons.castleEntityTable = false
		end)
	end)
	Dungeons.entryPoint = nil
	local debuffNames = {"modifier_avernus_armor", "modifier_avernus_magic_resist", "modifier_avernus_e_nerf", "modifier_avernus_miss"}
	for i = 1, #MAIN_HERO_TABLE, 1 do
		for j = 1, #debuffNames, 1 do
			MAIN_HERO_TABLE[i]:RemoveModifierByName(debuffNames[j])
		end
	end
	Beacons:CreateBeacons()
end

function swamp_boss_die(caster)
	caster.dying = true
	Dungeons.itemLevel = 78
	for i = 0, 10, 1 do
		Timers:CreateTimer(0.4 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	local casterOrigin = caster:GetAbsOrigin()
	GameState:KeeperDefeat(caster:GetUnitName(), casterOrigin)
	Dungeons.cleared.swamp = true
	EmitSoundOn("earth_spirit_earthspi_death_01", caster)
	EmitSoundOn("earth_spirit_earthspi_death_01", caster)
	EmitSoundOn("earth_spirit_earthspi_death_01", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.25})
		EmitSoundOn("earth_spirit_earthspi_death_07", caster)
		EmitSoundOn("earth_spirit_earthspi_death_07", caster)
		EmitSoundOn("earth_spirit_earthspi_death_07", caster)
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(14494, 5659), Vector(4480, 4454), "swamp", nil, true)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(14494, 5659), 600, 99999, false)
		UTIL_Remove(caster)
	end)
	Dungeons.entryPoint = nil
	Timers:CreateTimer(60, function()
		for i = 1, #Dungeons.swampEntityTable, 1 do
			local unit = Dungeons.swampEntityTable[i]
			if unit then
				if not unit:IsNull() then
					UTIL_Remove(Dungeons.swampEntityTable[i])
				end
			end
		end
	end)
	Beacons:CreateBeacons()
end

function ruins_boss_die(caster)
	caster.dying = true
	Dungeons.itemLevel = 66
	for i = 0, 10, 1 do
		Timers:CreateTimer(0.4 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	local casterOrigin = caster:GetAbsOrigin()
	GameState:RentikiDefeat(caster:GetUnitName(), casterOrigin)
	Dungeons.cleared.desertRuins = true
	EmitSoundOn("huskar_husk_death_01", caster)
	EmitSoundOn("huskar_husk_death_01", caster)
	EmitSoundOn("huskar_husk_death_01", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
		local luck = RandomInt(1, 5)
		if luck == 5 then
			RPCItems:RollRadiantRuinsLeather(caster:GetAbsOrigin())
		end
	end)
	for j = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[j].ruinsBossSpecial = false
	end
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.65})
		EmitSoundOn("huskar_husk_death_11", caster)
		EmitSoundOn("huskar_husk_death_11", caster)
		EmitSoundOn("huskar_husk_death_11", caster)
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(20, 14060), Vector(7168, -6784), "ruins", nil, true)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(20, 14060), 600, 99999, false)
		UTIL_Remove(caster)
	end)
	Dungeons.entryPoint = nil
	Timers:CreateTimer(60, function()
		for i = 1, #Dungeons.ruinsEntityTable, 1 do
			local unit = Dungeons.ruinsEntityTable[i]
			if unit then
				if not unit:IsNull() then
					UTIL_Remove(Dungeons.ruinsEntityTable[i])
				end
			end
		end
	end)
	Beacons:CreateBeacons()
end

function grizzly_boss_die(caster)
	Dungeons.grizzlyStatus = 5
	StopSoundEvent("Grizzly.BossMusic", Dungeons.bossMusic)
	UTIL_Remove(Dungeons.bossMusic)
	caster.dying = true
	Dungeons.itemLevel = 38
	for i = 0, 10, 1 do
		Timers:CreateTimer(0.4 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	local casterOrigin = caster:GetAbsOrigin()
	GameState:StarblightDefeat(caster:GetUnitName(), casterOrigin)
	Dungeons.cleared.grizzlyfalls = true
	EmitSoundOn("medusa_medus_death_01", caster)
	EmitSoundOn("medusa_medus_death_01", caster)
	EmitSoundOn("medusa_medus_death_01", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
		local luck = RandomInt(1, 4)
		if luck == 1 then
			RPCItems:RollTwilightVestments(caster:GetAbsOrigin())
		end
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.65})
		EmitSoundOn("medusa_medus_death_14", caster)
		EmitSoundOn("medusa_medus_death_14", caster)
		EmitSoundOn("medusa_medus_death_14", caster)
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(-9317, -3881), Vector(-2880, -2880), "grizzly_falls", nil, true)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-9317, -3881), 400, 99999, false)
		UTIL_Remove(caster)
	end)
	Dungeons.entryPoint = nil
	UTIL_Remove(Dungeons.wall1)
	UTIL_Remove(Dungeons.wall2)
	UTIL_Remove(Dungeons.blocker1)
	UTIL_Remove(Dungeons.blocker2)
	UTIL_Remove(Dungeons.blocker3)
	UTIL_Remove(Dungeons.blocker4)
	UTIL_Remove(Dungeons.blocker5)
	Dungeons.blocker1 = nil
	Dungeons.blocker2 = nil
	Dungeons.blocker3 = nil
	Dungeons.blocker4 = nil
	Dungeons.blocker5 = nil
	if not Dungeons.tank_ally:IsNull() then
		EmitSoundOn("sven_sven_level_05", Dungeons.tank_ally)
		Dungeons.tank_ally:AddSpeechBubble(1, "#grizzly_tank_dialogue_two", 5, 0, 0)
	end
	Timers:CreateTimer(6, function()
		if not Dungeons.tank_ally:IsNull() then
			Dungeons.tank_ally:AddSpeechBubble(1, "#grizzly_tank_dialogue_three", 5, 0, 0)
			RPCItems:RollItemtype(300, Dungeons.tank_ally:GetAbsOrigin(), 5, 2)
		end
		if not Dungeons.healer_ally:IsNull() then
			Dungeons.healer_ally:AddSpeechBubble(2, "#grizzly_healer_dialogue_one", 5, 0, 0)
			RPCItems:RollItemtype(300, Dungeons.healer_ally:GetAbsOrigin(), 5, 2)
		end
	end)
	Timers:CreateTimer(80, function()
		for i = 1, #Dungeons.grizzlyEntityTable, 1 do
			local unit = Dungeons.grizzlyEntityTable[i]
			if unit then
				if not unit:IsNull() then
					UTIL_Remove(Dungeons.grizzlyEntityTable[i])
				end
			end
		end
		if not Dungeons.tank_ally:IsNull() then
			UTIL_Remove(Dungeons.tank_ally)
		end
		if not Dungeons.healer_ally:IsNull() then
			UTIL_Remove(Dungeons.healer_ally)
		end
	end)
	Beacons:CreateBeacons()
end

function phoenix_boss_die(caster)
	caster.active = false
	CustomGameEventManager:Send_ServerToAllClients("phoenixBossEndMusic", {})
	CustomGameEventManager:Send_ServerToAllClients("special_event_close", {})
	caster.dying = true
	local lootDrops = math.ceil((Dungeons.phoenixWave - 9) / 2) + 5
	for i = 0, lootDrops, 1 do
		Timers:CreateTimer(0.4 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	Timers:CreateTimer(30, function()
		Dungeons.phoenixWave = nil
	end)
	local casterOrigin = caster:GetAbsOrigin()
	GameState:PhoenixDefeat(caster:GetUnitName(), casterOrigin)
	Dungeons.cleared.phoenix = true
	EmitSoundOn("doom_bringer_doom_lose_01", caster)
	EmitSoundOn("doom_bringer_doom_lose_01", caster)
	EmitSoundOn("doom_bringer_doom_lose_01", caster)
	StartAnimation(caster, {duration = 4.9, activity = ACT_DOTA_FLAIL, rate = 1})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
		local luck = RandomInt(1, 6)
		if luck == 1 then
			local waveBonus = math.min(Dungeons.phoenixWave, 60)
			RPCItems:RollDemonMask(deathLoc, false, waveBonus)
		end
	end)
	Timers:CreateTimer(5, function()
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_DIE, rate = 0.65})
		EmitSoundOn("doom_bringer_doom_death_03", caster)
		EmitSoundOn("doom_bringer_doom_death_03", caster)
		EmitSoundOn("doom_bringer_doom_death_03", caster)
	end)
	Timers:CreateTimer(8.1, function()
		Beacons:CreatePortal(Vector(3093, -12522), Vector(3648, 6400), "phoenix", nil, true)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(3093, -12522), 600, 99999, false)
		UTIL_Remove(caster)
	end)
	Timers:CreateTimer(10, function()
		local position = Dungeons.phoenix:GetAbsOrigin()
		EmitGlobalSound("phoenix_phoenix_bird_victory")
		EmitGlobalSound("phoenix_phoenix_bird_victory")
		EmitGlobalSound("phoenix_phoenix_bird_victory")
		RPCItems:RollPhoenixEmblem(position)
	end)
	Dungeons.entryPoint = nil
	-- Timers:CreateTimer(60, function()
	-- for i = 1, #Dungeons.ruinsEntityTable, 1 do
	-- local unit = Dungeons.ruinsEntityTable[i]
	-- if unit then
	-- if not unit:IsNull() then
	-- UTIL_Remove(Dungeons.ruinsEntityTable[i])
	-- end
	-- end
	-- end
	-- end)
	Beacons:CreateBeacons()
	ParticleManager:DestroyParticle(Dungeons.pentagramParticle, false)
	ParticleManager:DestroyParticle(Dungeons.pentagramParticle2, false)
	ParticleManager:DestroyParticle(Dungeons.pentagramParticle3, false)
	ParticleManager:DestroyParticle(Dungeons.pentagramParticle4, false)
	ParticleManager:DestroyParticle(Dungeons.pentagramParticle5, false)
end

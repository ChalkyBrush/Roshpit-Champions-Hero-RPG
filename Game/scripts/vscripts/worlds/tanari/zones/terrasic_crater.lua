function Tanari:TerrasicGuardSpawn()
		local walls = Entities:FindAllByNameWithin("TerrasicGuard", Vector(-8512, -930, 250), 900)
		Timers:CreateTimer(0.2, function()
			EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Hero_Undying.Tombstone", Events.GameMaster)
		end)
		for j = 1, #walls, 1 do
			for i = 1, 60, 1 do
				Timers:CreateTimer(i*0.03, function()
					if i%2 == 0 then
						walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(7,15,0))
					else
						walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(-7,-15,0))
					end
					if j == 1 then
						ScreenShake(walls[1]:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
					end
					
				end)
			end
		end
		Dungeons.itemLevel = 50
		Timers:CreateTimer(2.0, function()
			local position = walls[1]:GetAbsOrigin()
			UTIL_Remove(walls[1])
			UTIL_Remove(walls[2])
			local boss = Tanari:SpawnTerrasicGuard(Vector(-8512, -930, 250), Vector(0,1))
			EmitGlobalSound("Tanari.TerrasicCrater.GuardSpawn")
			CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", boss, 3)
			Events:AdjustBossPower(boss, 4, 4, false)
		end)
end

function Tanari:SpawnTerrasicGuard(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_doomguard", position, 3, 5, nil, fv, true)
	stone:SetRenderColor(200,100,100)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 65
	stone.dominion = true
	return stone
end

function Tanari:SpawnTerrasicCraterZone1()
	Tanari.CraterActive = true
	Tanari:TanariZoneThink()
	Tanari:SpawnLavaBeast(Vector(0,1), Vector(-8768, -4672))
	Tanari:SpawnLavaBeast(Vector(0,1), Vector(-10048, -4288))
	Tanari:SpawnLavaBeast(Vector(-0.6,1), Vector(-8067, -4800))
	Tanari:SpawnLavaBeast(Vector(-1,1), Vector(-9344, -5120+RandomInt(0,200)))
	Tanari:SpawnLavaBeast(Vector(0,-1), Vector(-10112+RandomInt(0,1400), -5632))
	Tanari:SpawnLavaBeast(Vector(0,-1), Vector(-7488, -6728))
	Tanari:SpawnLavaBeast(Vector(0,-1), Vector(-7772, -5790))
	Timers:CreateTimer(2.5, function()
		Tanari:SpawnTerrasicStoneGiant(Vector(1, 0.8), Vector(-9244,-3985))
		Tanari:SpawnTerrasicStoneGiant(Vector(1, 0.8), Vector(-8768,-5952))
	end)
	Timers:CreateTimer(3.5, function()
		for i = 1, 12, 1 do
			Timers:CreateTimer(i*0.3, function()
				local offsetX = RandomInt(0,700)
				local offsetY = RandomInt(0,1300)
				Tanari:SpawnBoulderSpineShell(RandomVector(1), Vector(-7232+offsetX, -5568+offsetY))
			end)
		end
		Tanari:SpawnFlameOrchid(Vector(-1,1), Vector(-6626, -5766))

		Tanari:SpawnFlameOrchid(Vector(-1,1), Vector(-8576, -6336))
		Tanari:SpawnFlameOrchid(Vector(-1,1), Vector(-8896, -6720))
		Tanari:SpawnFlameOrchid(Vector(-1,1), Vector(-8064, -6720))
	end)
	Timers:CreateTimer(7, function()
		local positionTable = {Vector(-6144, -4224), Vector(-5184, -5376), Vector(-2880, -5120), Vector(-3008, -4352)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 2
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnTerrasicMoltenWalker(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 20, 5, 30, patrolPositionTable)
			end
		end
		
	end)
	Timers:CreateTimer(8, function()
		local positionTable = {Vector(-6976, -5824), Vector(-8768, -6720), Vector(-8704, -8000), Vector(-7744, -9088)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 2
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnTerrasicMoltenWalker(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 20, 5, 30, patrolPositionTable)
			end
		end
		
	end)
	Timers:CreateTimer(10, function()
		Tanari:SpawnRedMistSoldier(Vector(-8192, -6656), Vector(1,1))
		Tanari:SpawnRedMistSoldier(Vector(-8384, -6400), Vector(1,0))
		Tanari:SpawnRedMistSoldier(Vector(-9152, -7296), Vector(1,0))
	end)
	Timers:CreateTimer(15, function()
		Tanari:SpawnGoremawFlamespitter(Vector(-8896, -8128), Vector(0,1))
		Tanari:SpawnGoremawFlamespitter(Vector(-7296, -9600), Vector(0,1))
		Tanari:SpawnGoremawFlamespitter(Vector(-7616, -9600), Vector(0,1))
		Tanari:SpawnRedMistSoldier(Vector(-8128, -9920), Vector(1,1))
		Tanari:SpawnRedMistSoldier(Vector(-8256, -8512), Vector(-0.45,1))
		Tanari:SpawnLavaBeast(Vector(0,1), Vector(-7424, -10048))
		Tanari:SpawnGoremawFlamespitter(Vector(-6080, -9088), Vector(-1,0))
	end)
	Timers:CreateTimer(2, function()
		Tanari:SpawnBlackDragon(Vector(-9837, 174), Vector(0,-1))
	end)
end

function Tanari:SpawnLavaLegions1()
	for i = 1, 30, 1 do
		Timers:CreateTimer(0.3*i, function()
			local position = Vector(-9472, -3456)
			local offsetX = RandomInt(0, 1300)
			local offsetY = RandomInt(0, 1250)
			Tanari:SpawnLavaLegion(Vector(0,1), position+Vector(offsetX, offsetY))
		end)
	end
end

function Tanari:SpawnLavaBeast(fv, position)
	local beast = Tanari:SpawnEnemyUnit("terrasic_lava_beast", position, fv)
	beast:SetRenderColor(200, 120, 0)
	beast:SetAbsOrigin(beast:GetAbsOrigin()-Vector(0,0,300))
	beast.itemLevel = 61
	local ability = beast:FindAbilityByName("terrasic_lava_beast_ai")
	ability:ApplyDataDrivenModifier(beast, beast, "modifier_lava_beast_submerged", {})
end

function Tanari:SpawnLavaLegion(fv, position)
	local legion = Tanari:SpawnEnemyUnit("terrasic_volcanic_legion", position, fv)
	legion:SetRenderColor(200, 120, 0)
	legion:SetAbsOrigin(legion:GetAbsOrigin()+Vector(0,0,1000))
	legion.itemLevel = 60
	WallPhysics:Jump(legion, Vector(1,1), 0, 0, 0, 1)
	legion.jumpEnd = "lava_legion"
	legion.dominion = true
end

function Tanari:SpawnFlameOrchid(fv, position)
	local orchid = Tanari:SpawnEnemyUnit("terrasic_flame_orchid", position, fv)
	orchid:SetRenderColor(250, 60, 0)
	orchid.itemLevel = 60
	orchid:SetAbsOrigin(orchid:GetAbsOrigin()-Vector(0,0,85))
	orchid.dominion = true
end

function Tanari:SpawnTerrasicStoneGiant(fv, position)
	local stone = Tanari:SpawnDungeonUnit("terrasic_awakened_stone", position, 3, 5, "earth_spirit_earthspi_pain_13", fv, false)
	stone:SetRenderColor(160,20,0)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 62
	stone.dominion = true
end

function Tanari:SpawnTerrasicMoltenWalker(position, fv)
	local stone = Tanari:SpawnDungeonUnit("tanari_molten_walker", position, 0, 2, "earth_spirit_earthspi_pain_9", fv, false)
	stone:SetRenderColor(220,20,0)
	Events:ColorWearablesAndBase(stone, Vector(220, 20, 0))
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 62
	stone.dominion = true
	return stone
end


function Tanari:SpawnBoulderSpineShell(fv, position)
	local shell = Tanari:SpawnDungeonUnit("terrasic_boulderspine", position, 1, 3, "bristleback_bristle_anger_03", fv, false)
	shell.fv = fv
	shell:SetForwardVector(-fv)

	shell:SetAbsOrigin(shell:GetAbsOrigin()-Vector(0,0,100))
	shell:SetModelScale(1.4)
	shell:SetRenderColor(250, 160, 160)
	shell:AddAbility("terrasic_boulderspine_shell_ai"):SetLevel(1)
	shell.itemLevel = 61
	shell.dominion = true
end

function Tanari:SpawnBoulderSpine(spine)
	-- local spine = Tanari:SpawnDungeonUnit("terrasic_boulderspine", position, 1, 3, "bristleback_bristle_anger_03", fv, true)
	spine:SetRenderColor(250, 160, 160)
	spine:SetAbsOrigin(spine:GetAbsOrigin() - Vector(0,0,100))
	spine:RemoveAbility("terrasic_boulderspine_shell_ai")
	spine:RemoveModifierByName("modifier_boulderspine_shell_ai")
	StartAnimation(spine, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
	WallPhysics:Jump(spine, Vector(1,1), 0, 34, 25, 1)
	spine.jumpEnd = "lava_legion"
	Timers:CreateTimer(0.3, function()
			local position = spine:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, spine )
			ParticleManager:SetParticleControl( pfx, 0, position )
			ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
	end)
end

function Tanari:TanariZoneThink()
	Timers:CreateTimer(40, function()
		Tanari:CreateLavaBlast(Vector(-8832, -5184))
		Tanari:CreateLavaBlast(Vector(-7528, -6912))
		Timers:CreateTimer(5, function()
			Tanari:CreateLavaBlast(Vector(-8832, -10112))
			Tanari:CreateLavaBlast(Vector(-8832, -14528))
		end)
		Timers:CreateTimer(10, function()
			Tanari:CreateLavaBlast(Vector(-4160, -6656))
		end)
		if Tanari.CraterActive then
			return 40
		end
	end)
end

function Tanari:CreateLavaBlast(position)
      particleName = "particles/addons_gameplay/pit_lava_blast.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, position )
      ParticleManager:SetParticleControl( particle1, 1, position )
      Timers:CreateTimer(10, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
	
end

function Tanari:SpawnRedMistSoldier(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_red_mist_soldier", position, 0, 2, "Tanari.WaterTemple.ExecutionerAggro", fv, false)
	stone:SetRenderColor(255,200,200)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 62
	stone.targetRadius = 340
	stone.autoAbilityCD = 2
	stone.dominion = true
	return stone
end

function Tanari:SpawnGoremawFlamespitter(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_goremaw_flame_splitter", position, 0, 2, "Tanari.TerrasicCrater.FlameSpitterAggro", fv, false)
	stone:SetRenderColor(255,160,80)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 63
	stone.targetRadius = 400
	stone.autoAbilityCD = 1.5
	stone.dominion = true
	return stone
end

function Tanari:SpawnVolcanoBeetle(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_volcano_beetle", position, 0, 2, nil, fv, true)
	stone:SetRenderColor(255,50,50)
	stone.itemLevel = 60
	stone:SetAbsOrigin(stone:GetAbsOrigin()-Vector(0,0,120))
	Timers:CreateTimer(0.05, function()
		StartAnimation(stone, {duration=1, activity=ACT_DOTA_CAST_BURROW_END, rate=0.8}) 
		CustomAbilities:QuickAttachParticle("particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf", stone, 2)
		EmitSoundOn("Tanari.TerrasicCrater.FireBeetleUnburrow", stone)
	end)
	for i = 1, 30, 1 do
		Timers:CreateTimer(i*0.03, function()
			stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,4))
		end)
	end
	stone.dominion = true
end

function Tanari:SpawnBlackDrake(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_black_drake", position, 0, 2, "Tanari.BlackDrake.Aggro", fv, false)
	stone:SetRenderColor(255,160,80)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 63
	stone.dominion = true
	return stone
end

function Tanari:SpawnBlackDragon(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_black_dragon", position, 2, 4, "Tanari.BlackDrake.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 66
	local dragonAbility = stone:FindAbilityByName("terrasic_black_dragon_ai")
	dragonAbility:ApplyDataDrivenModifier(stone, stone, "modifier_black_dragon_unaggrod", {})
	dragonAbility:ApplyDataDrivenModifier(stone, stone,"modifier_black_dragon_extra_z", {})
	stone:SetModifierStackCount("modifier_black_dragon_extra_z", stone, 240)
	stone.phase = 0
	Tanari.BlackDragon = stone
	local basePos = Vector(-9152, -4160)
	local randomX = RandomInt(1, 1000)
	local randomY = RandomInt(1, 800)
	stone.firstMovePos = basePos+Vector(randomX, randomY)
	Tanari.BlackDragon.cantAggro = true
	return stone
end

function Tanari:SpawnVolcanoPharoah(position, fv)
	local stone = Tanari:SpawnDungeonUnit("volcanic_pharoah", position, 2, 4, "Tanari.VolcanoPharoah.Aggro", fv, false)
	stone:SetRenderColor(255,160,80)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 75
	stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,-1200))
	local ability = stone:FindAbilityByName("terrasic_volcano_pharoah_ai")
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_volcano_pharoah_submerged", {})
	AddFOWViewer(DOTA_TEAM_GOODGUYS, stone:GetAbsOrigin(), 400, 5, false)
	return stone
end

function Tanari:TriggerTerrasicBeacon(startingAngle, desiredAngle, beaconStartLoc, particlePointBeacon, units)
	if not Tanari.BeaconsActivated then
		Tanari.BeaconsActivated = 1
	else
		Tanari.BeaconsActivated = Tanari.BeaconsActivated + 1
	end
	local beacon = Entities:FindByNameNearest("TerrasicDragonBeacon", beaconStartLoc, 900)
	EmitSoundOnLocationWithCaster(beaconStartLoc, "Tanari.TerrasicBeaconMove", Events.GameMaster)
	for i = 1, 53, 1 do
		local angleDifferental = startingAngle-desiredAngle
		local angleDelta = angleDifferental/53
		Timers:CreateTimer(i*0.03, function()
			beacon:SetAngles(0, startingAngle-(i*angleDelta), 0)
			beacon:SetRenderColor(30+i*3, 0, 0)
		end)

	end
	Timers:CreateTimer(1.6, function()
		local particleName = "particles/units/heroes/hero_wisp/epoch_rune_b_a.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster )
		ParticleManager:SetParticleControl(pfx, 0, particlePointBeacon+Vector(0,0,120))
		ParticleManager:SetParticleControl(pfx, 1, Vector(-2711, -3919, 1020))
		Timers:CreateTimer(0.5, function()
			local lockDuration = 3
			if Tanari.BeaconsActivated == 3 then
				Tanari.FirewallOpen = true
				lockDuration = 10.5
				Timers:CreateTimer(3, function()
				local visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(-2711, -3919, 420), false, nil, nil, DOTA_TEAM_GOODGUYS)
				visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin()+Vector(0,0,120))
				visionTracer:FindAbilityByName("dummy_unit"):SetLevel(1)
				visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
				Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, visionTracer, "modifier_ms_thinker", {})
				Dungeons:LockCameraToUnitForPlayers(visionTracer, 9, units)
					Timers:CreateTimer(0.1, function()
						visionTracer:MoveToPosition(Vector(-2273, -4352))
					end)
					Timers:CreateTimer(0.5, function()
						Tanari:LowerWaterTempleWall(-4, "TerrasicKeyWall", Vector(-2174, -4352, 381), "TerrasicKeyBlocker", Vector(-2200, -4352, 350), 1200, true, false)
					end)
					Timers:CreateTimer(5.5, function()
						EmitGlobalSound("Tanari.HarpMystery")
					end)
				end)
			end
			Dungeons:CreateBasicCameraLockForHeroes(Vector(-2711, -3919, 420), lockDuration, units)
			local staff = Entities:FindByNameNearest("TerrasicKeyStaff", Vector(-2843, -3779, 14), 928)
			for j = 1, 42, 1 do
				Timers:CreateTimer(j*0.03, function()
					staff:SetRenderColor(0 + (Tanari.BeaconsActivated - 1)*84 + j*2, 0, 0)
				end)
			end
		end)
	end)
end

function Tanari:SpawnRedGuard(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_red_guard", position, 0, 1, "Tanari.RedGuard.Aggro", fv, false)
	stone.itemLevel = 72
	stone.dominion = true
	return stone
end

function Tanari:SpawnCaptainReimus(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_captain_reimus", position, 2, 3, "Tanari.CaptainReimus.Aggro", fv, false)
	stone.itemLevel = 75
	stone.dominion = true
	return stone
end

function Tanari:HeavyArmor(damage, attacker, victim)
	local distance = WallPhysics:GetDistance(attacker:GetAbsOrigin(), victim:GetAbsOrigin())
	if distance > 500 then
		local mult = 0.1
		if GameState:GetDifficultyFactor() == 2 then
			mult = 0.05
		elseif GameState:GetDifficultyFactor() == 3 then
			mult = 0
		end
		return damage*mult
	else
		return damage
	end
end

function Tanari:SpawnMoltenEntity(position, fv)
	local stone = Tanari:SpawnDungeonUnit("molten_entity", position, 0, 2, nil, fv, false)
	stone.itemLevel = 70
	stone:SetRenderColor(255, 255, 0)
	stone.dominion = true
	return stone
end

function Tanari:SpawnVolcanicAsh(position, fv)
	local stone = Tanari:SpawnDungeonUnit("volcanic_ash", position, 0, 2, nil, fv, false)
	stone.itemLevel = 74
	stone.dominion = true
	return stone
end

function Tanari:SpawnRedWarlock(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_red_warlock", position, 1, 3, nil, fv, false)
	stone.itemLevel = 80
	stone:SetRenderColor(255, 120, 120)
	Events:AdjustBossPower(stone, 2, 3)
	stone:ReduceMana(1000)
	stone.dominion = true
	return stone
end

function Tanari:SpawnRedMistConqueror(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_red_mist_conqueror", position, 0, 2, "Tanari.Conqueror.Aggro", fv, false)
	stone:SetRenderColor(255,200,200)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 72
	stone.dominion = true
	return stone
end


function Tanari:SpawnRedMistBrute(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_red_mist_brute", position, 0, 2, "Tanari.Conqueror.Aggro", fv, false)
	stone:SetRenderColor(255,200,200)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 72
	stone.dominion = true
	return stone
end

function Tanari:SpawnCaptainClayborne(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_captain_clayborne", position, 3, 5, "Tanari.CaptainClayborne.Aggro", fv, false)
	stone:SetRenderColor(255,200,200)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 80
	stone.dominion = true
	return stone
end

function Tanari:SpawnTerrasicWarlock(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_lava_summoner", position, 4, 5, nil, fv, false)
	stone:SetRenderColor(255,160,80)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 75
	stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,1200))
	return stone
end

function Tanari:SpawnTerrasicWarlockSummon(position, fv)
	local stone = Tanari:SpawnDungeonUnit("terrasic_warlock_summon", position, 2, 3, nil, fv, false)
	stone:SetRenderColor(255,160,80)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 75
	stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,-300))
	return stone
end

function Tanari:FireKeyHolderSteam(victim, damagetype)
	local steamAbility = victim:FindAbilityByName("terrasic_fire_key_holder_steam")
	if not victim.physicalStacks then
		victim.physicalStacks = 0
	end
	if not victim.magicalStacks then
		victim.magicalStacks = 0
	end
	if not victim.steamPFX then
		local particleName = "particles/econ/generic/generic_buff_1/fire_key_steam.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ROOTBONE_FOLLOW, victim )
		ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
		victim.steamPFX = pfx
	end
	if damagetype == DAMAGE_TYPE_PHYSICAL then
		victim.physicalStacks = victim:GetModifierStackCount("modifier_terrasic_fire_key_holder_steam_physical", victim) + 1
	end
	if damagetype == DAMAGE_TYPE_MAGICAL then
		victim.magicalStacks = victim:GetModifierStackCount("modifier_terrasic_fire_key_holder_steam_magical", victim) + 1
	end
	if victim.physicalStacks > 0 and damagetype == DAMAGE_TYPE_PHYSICAL then
		steamAbility:ApplyDataDrivenModifier(victim, victim, "modifier_terrasic_fire_key_holder_steam_physical", {duration = 10})
		victim:SetModifierStackCount("modifier_terrasic_fire_key_holder_steam_physical", victim, victim.physicalStacks)
	end
	if victim.magicalStacks > 0 and damagetype == DAMAGE_TYPE_MAGICAL then
		steamAbility:ApplyDataDrivenModifier(victim, victim, "modifier_terrasic_fire_key_holder_steam_magical", {duration = 10})
		victim:SetModifierStackCount("modifier_terrasic_fire_key_holder_steam_magical", victim, victim.magicalStacks)
	end
	local totalStackVisual = victim.magicalStacks + victim.physicalStacks
	local stackInput = math.min(totalStackVisual, 100)
	ParticleManager:SetParticleControl(victim.steamPFX, 10, Vector(stackInput, stackInput, stackInput))
	ParticleManager:SetParticleControl(victim.steamPFX, 14, Vector(stackInput, stackInput/12 + 1, totalStackVisual/10))
	ParticleManager:SetParticleControl(victim.steamPFX, 15, Vector(250, 250, 250))
	if totalStackVisual <= 0 then
		ParticleManager:DestroyParticle(victim.steamPFX, true)
		victim.steamPFX = false
	end
end


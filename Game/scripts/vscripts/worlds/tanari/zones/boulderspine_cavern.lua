function Tanari:CreateCaveBlockers()
  Tanari.caveBlocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1336,4291, 128), name ="wallObstruction"})
  Tanari.caveBlocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1472,4291, 128), name ="wallObstruction"})
  Tanari.caveBlocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1600,4291, 128), name ="wallObstruction"})
  Tanari.caveBlocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1728,4291, 128), name ="wallObstruction"})
  Tanari.caveBlocker5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1856,4291, 128), name ="wallObstruction"})
  Tanari.caveBlocker6 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(1984,4291, 128), name ="wallObstruction"})
  
end

function Tanari:InitializeCave()
	Tanari.BoulderSpine = {}
	Tanari:CreateCaveBlockers2()

	Tanari:SpawnCaveMonster(Vector(1280, 6464), Vector(1,0))
	Tanari:SpawnCaveMonster(Vector(2541, 6818), Vector(-1,-0.3))
	Tanari:SpawnCaveMonster(Vector(1673, 7353), Vector(0,-1))
	Tanari:SpawnCaveMonster(Vector(1467, 7181), Vector(1,-0.4))
	Tanari:SpawnCaveMonster(Vector(1955, 7141), Vector(-1,-0.4))

	-- local beacon = RPCItems:CreateItem("item_rpc_pedestal_item", nil, nil)
	-- CreateItemOnPositionSync(Vector(2112, 7168), beacon)
	-- beacon:GetContainer():SetForwardVector(Vector(0,-1))

	local beacon = Beacons:MakeBeacon(Vector(2112, 6368), "boulderspine", nil, 0)

	for i = 0, 24, 1 do
		local bottomLeftPos = Vector(832, 6600)
		local randomX = RandomInt(1, 2600)
		local randomY = RandomInt(1, 1200)
		local shroom = Dungeons:SpawnDungeonUnit("grizzly_cave_shroomling", bottomLeftPos+Vector(randomX, randomY), 1, 0, 1, "Miniboss_Greevil.Death", RandomVector(1), false, nil)
		shroom.itemLevel = 32
		shroom:SetAbsOrigin(shroom:GetAbsOrigin()-Vector(0,0,70))
		shroom:SetRenderColor(60, 110, 110)
		local ability = shroom:FindAbilityByName("grizzly_cave_shroom_ai")
		ability:ApplyDataDrivenModifier(shroom, shroom, "modifier_cave_shroom_ai", {})
	end
	EmitSoundOnLocationWithCaster(Vector(1920, 7104, 600), "Ambient.Tanari.CaveEntrance", Events.GameMaster)
	
	Timers:CreateTimer(1, function()
		local music = "Ambient.Tanari.Boulderspine"
		EmitSoundOnLocationWithCaster(Vector(3904, 9344, 300), music, Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(980, 9344, 300), music, Events.GameMaster)
		return 105
	end)
end

function Tanari:CreateCaveBlockers2()
	Tanari.caveBlocker11 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(3281,8216, 128), name ="wallObstruction"})
	Tanari.caveBlocker12 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(3392,8216, 128), name ="wallObstruction"})
	Tanari.caveBlocker13 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(3520,8216, 128), name ="wallObstruction"})
	Tanari.caveBlocker14 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(3648,8216, 128), name ="wallObstruction"})
	Tanari.caveBlocker15 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(3776,8216, 128), name ="wallObstruction"})
	Tanari.caveBlocker16 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(3904,8216, 128), name ="wallObstruction"})
	local wallPoint1 = Vector(3217, 8256, 150)
	local wallPoint2 =  Vector(3905, 8256, 150)
	local particle = "particles/units/heroes/hero_dark_seer/crixalis_wal_of_replica.vpcf"
	Tanari.BoulderSpine.wallParticle1 = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, Events.GameMaster )
	ParticleManager:SetParticleControl( Tanari.BoulderSpine.wallParticle1, 0, wallPoint1 )
	ParticleManager:SetParticleControl( Tanari.BoulderSpine.wallParticle1, 1, wallPoint2 )
end

function Tanari:RemoveCaveBlockers()
	UTIL_Remove(Tanari.caveBlocker1)
	UTIL_Remove(Tanari.caveBlocker2)
	UTIL_Remove(Tanari.caveBlocker3)
	UTIL_Remove(Tanari.caveBlocker4)
	UTIL_Remove(Tanari.caveBlocker5)
	UTIL_Remove(Tanari.caveBlocker6)
end

function Tanari:SpawnCaveMonster(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_cavern_monster", position, 1, 2, "Tanari.Boulderspine.MonsterAggro", fv, false)
	sapling.itemLevel = 45
	Events:AdjustBossPower(sapling, 1, 1)
end

function Tanari:SpawnWaveUnit(unitName, spawnPoint, quantity, itemLevel, bSound)
  local delay = 2.7
  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
      local luck = RandomInt(1, 180)
      if Events.SpiritRealm then
      	luck = RandomInt(1, 80)
      end
      if luck == 1 then
        unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
      elseif luck == 2 then
        unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
      else
        unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
        if bSound then
       		 EmitSoundOn("Tanari.Boulderspine.PortalsAppear", unit)
    	end        
    	Events:AdjustDeathXP(unit)
      end
      if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
      	unit.itemLevel = itemLevel
      	unit:AddAbility("tanari_cave_counter"):SetLevel(1)
      	unit.dominion = true
      	if unit:GetUnitName() == "boulderspine_ancient_golem" then
      		unit:SetRenderColor(20, 20, 20)
      	elseif unit:GetUnitName() == "boulderspine_rock_golem" then
      		unit:SetRenderColor(150, 255, 150)
      	elseif unit:GetUnitName() == "boulderspine_dimension_warper" or unit:GetUnitName() == "boulderspine_dimension_jumper" then
      		unit:AddNewModifier(unit, nil, "modifier_animation_translate", {translate="run"})
      	end
      else
      	for i = 1, #unit, 1 do
      		unit.buddiesTable[i].itemLevel = itemLevel
      		unit.buddiesTable[i].dominion = true
      		unit.buddiesTable[i]:AddAbility("tanari_cave_counter"):SetLevel(1)
	      	if unit.buddiesTable[i]:GetUnitName() == "boulderspine_dimension_warper" or unit.buddiesTable[i]:GetUnitName() == "boulderspine_dimension_jumper" then
	      		unit.buddiesTable[i]:AddNewModifier(unit.buddiesTable[i], nil, "modifier_animation_translate", {translate="run"})
	      	end      		
      	end
      end
    end)
  end
end

function Tanari:BeginCaveWave(caster, beacon)
	UTIL_Remove(beacon)
	local spawnPosition1 = Vector(2112, 7488, 620)
	local spawnPosition2 = Vector(1792, 6976, 620)
	local spawnPosition3 = Vector(2432, 6976, 620)
	local particleName = "particles/radiant_fx2/cave_summon_destruction_growinitsphere.vpcf"
    Tanari.BoulderSpine.spawnParticle1 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, Events.GameMaster )
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle1, 0, spawnPosition1)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle1, 1, spawnPosition1)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle1, 2, spawnPosition1)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle1, 3, spawnPosition1)
    Tanari.BoulderSpine.spawnParticle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, Events.GameMaster )
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle2, 0, spawnPosition2)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle2, 1, spawnPosition2)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle2, 2, spawnPosition2)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle2, 3, spawnPosition2)
    Tanari.BoulderSpine.spawnParticle3 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, Events.GameMaster )
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle3, 0, spawnPosition3)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle3, 1, spawnPosition3)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle3, 2, spawnPosition3)
    ParticleManager:SetParticleControl( Tanari.BoulderSpine.spawnParticle3, 3, spawnPosition3)
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.Boulderspine.BeaconTouch", Events.GameMaster)
    CustomAbilities:QuickAttachParticle("particles/items3_fx/glimmer_cape_initial_flash.vpcf", caster, 3)
    -- Timers:CreateTimer(1.5, function()
    -- 	for i = 1, 8, 1 do
    -- 		Timers:CreateTimer(0.6*i, function()
    -- 			EmitSoundOn("Tanari.Boulderspine.PortalsAppear", caster)
    -- 		end)
    -- 	end
    -- end)
    Timers:CreateTimer(3, function()
    	Tanari:SpawnWaveUnit("cave_stalker", spawnPosition1, 15, 45, true)
    	Tanari:SpawnWaveUnit("blood_fiend", spawnPosition2, 15, 45, false)
    	Tanari:SpawnWaveUnit("depth_demon", spawnPosition3, 15, 45, false)
    end)
end

function Tanari:SpawnCaveRoom2()
	Tanari:SpawnArmoredCaveRat(Vector(3392, 9024), Vector(1, -1))
	Tanari:SpawnArmoredCaveRat(Vector(3322, 8849), Vector(1, 0))
	Tanari:SpawnArmoredCaveRat(Vector(3786, 8906), Vector(-1, -0.2))
	Tanari:SpawnArmoredCaveRat(Vector(4065, 8732), Vector(-0.4, -1))
	Tanari:SpawnArmoredCaveRat(Vector(3968, 9344), Vector(0.5, 0.5))
	Tanari:SpawnArmoredCaveRat(Vector(3840, 9516), Vector(1, 0))
	Tanari:SpawnArmoredCaveRat(Vector(3840, 9667), Vector(1, 0))
	Tanari:SpawnArmoredCaveRat(Vector(3840, 9777), Vector(1, 0))
	Tanari:SpawnArmoredCaveRat(Vector(3840, 9897), Vector(1, 0))
	Tanari:SpawnObsidianCaveBeast(Vector(4015, 9600), Vector(0,-1))
	Timers:CreateTimer(4, function()
		Tanari:SpawnCaveLizard(Vector(2730, 10200), Vector(1,0))
		Timers:CreateTimer(0.75, function()
			Tanari:SpawnCaveLizard(Vector(2883, 9952), Vector(1,0.3))
		end)
		Timers:CreateTimer(2.15, function()
			Tanari:SpawnCaveLizard(Vector(3087, 10421), Vector(1,-0.3))
		end)
		Tanari:SpawnBigCaveLizard(Vector(2688, 9728), Vector(1,1))
	end)
end

function Tanari:SpawnArmoredCaveRat(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_armored_cave_rat", position, 0, 2, "Tanari.Boulderspine.CaveRatAggro", fv, false)
	sapling.itemLevel = 47
	sapling:SetRenderColor(105, 250, 175)
	sapling.dominion = true
	Events:AdjustBossPower(sapling, 1, 1)
end

function Tanari:SpawnObsidianCaveBeast(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_obsidian_cave_beast", position, 2, 3, "Tanari.Boulderspine.CaveBeastAggro", fv, false)
	sapling.itemLevel = 49
	sapling.dominion = true
	Events:AdjustBossPower(sapling, 2, 2)
end


function Tanari:SpawnCaveLizard(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_cave_lizard", position, 1, 2, "Tanari.Boulderspine.CaveLizardAggro", fv, false)
	sapling.itemLevel = 49
	Events:AdjustBossPower(sapling, 1, 2)
	sapling:SetRenderColor(30, 30, 30)
	sapling.targetRadius = 3000
	sapling.minRadius = 1000
	sapling.targetAbilityCD = 3.5
	sapling.targetFindOrder = FIND_FARTHEST
	sapling.dominion = true
end

function Tanari:SpawnBigCaveLizard(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_cave_lizard_brute", position, 2, 4, "Tanari.Boulderspine.CaveLizardAggro", fv, false)
	sapling.itemLevel = 51
	Events:AdjustBossPower(sapling, 2, 3)
	sapling:SetRenderColor(30, 30, 30)
	sapling.autoAbilityCD = 3
	sapling.targetRadius = 1000
	sapling.dominion = true
end

function Tanari:SpawnMudGolem(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_mud_golem", position, 0, 1, "Tanari.Boulderspine.MudGolemAggro", fv, true)
	sapling.itemLevel = 46
	sapling.dominion = true
end

function Tanari:SpawnRedViper(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_viper_red", position, 1, 3, "Tanari.Boulderspine.BigViperAggro", fv, false)
	sapling.itemLevel = 49
	sapling:SetRenderColor(255, 57, 57)
	Events:AdjustBossPower(sapling, 1, 1)
	sapling.dominion = true
end

function Tanari:SpawnBlueViper(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_viper_blue", position, 1, 3, "Tanari.Boulderspine.BigViperAggro", fv, false)
	sapling.itemLevel = 49
	sapling:SetRenderColor(66, 69, 255)
	Events:AdjustBossPower(sapling, 1, 1)
	sapling.dominion = true
end

function Tanari:SpawnGreenViper(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("boulderspine_viper_green", position, 0, 1, "Tanari.Boulderspine.SmallViperAggro", fv, true)
	sapling.itemLevel = 46
	sapling.dominion = true
end

function Tanari:SpawnEgg(position)
	local egg = CreateUnitByName("boulderspine_viper_egg", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	egg:SetOriginalModel("models/custom_egg.vmdl")
	egg:SetModel("models/custom_egg.vmdl")
	local modelScale = RandomInt(90, 270)/100
	egg:SetModelScale(modelScale)
	egg.dummy = true
	egg:SetRenderColor(95, 145, 92)
	egg:SetForwardVector(RandomVector(1))
	egg:AddAbility("boulderspine_viper_egg_ability"):SetLevel(1)
	egg.jumpLock = true
end

function Tanari:SpawnViperRoom()
	Tanari:SpawnBlueViper(Vector(960, 9907), Vector(0.3, -1))
	Tanari:SpawnRedViper(Vector(1344, 9728), Vector(-0.2, -1))
	Tanari:SpawnBlueViper(Vector(1789, 10011), Vector(-0.3, -1))
	Tanari:SpawnRedViper(Vector(1152, 10449), Vector(0.2, -1))
	Tanari:SpawnRedViper(Vector(1465, 10449), Vector(-0.2, -1))
	Tanari:SpawnBlueViper(Vector(1665, 10249), Vector(-0.2, -1))

	Tanari:SpawnEgg(Vector(1344, 9910))
	Tanari:SpawnEgg(Vector(1410,9866))
	Tanari:SpawnEgg(Vector(1427, 9938))
	Tanari:SpawnEgg(Vector(1408, 10009))
	Tanari:SpawnEgg(Vector(1496, 9976))
	Tanari:SpawnEgg(Vector(1539, 10003))
	Tanari:SpawnEgg(Vector(1561, 9938))
	Timers:CreateTimer(3, function()
		for i = 1, 16, 1 do
			local spawnPosition = Vector(960, 9497)+RandomVector(RandomInt(1, 80))+Vector(RandomInt(-60, 60), RandomInt(-30, 30))+Vector(0,i*70)
			Tanari:SpawnEgg(spawnPosition)
		end
		for i = 1, 16, 1 do
			local spawnPosition = Vector(1803, 9609)+RandomVector(RandomInt(1, 80))+Vector(RandomInt(-60, 60), RandomInt(-30, 30))+Vector(0,i*70)
			Tanari:SpawnEgg(spawnPosition)
		end
	end)
end

function Tanari:SpawnSpikeRoom()
	if not Tanari.BoulderSpine then
		Tanari.BoulderSpine = {}
	end
	Tanari.BoulderSpine.SpikeTrapTable = {}
	Tanari.BoulderSpine.spikesUp = false
	local spikePositionTable = {Vector(1659.23, 11891.8), Vector(2435, 11898), Vector(3188, 11912)}
	for i = 1, #spikePositionTable, 1 do
		local spikeTrap = CreateUnitByName("npc_dummy_unit", spikePositionTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
		spikeTrap:SetOriginalModel("models/props/traps/spiketrap/spiketrap.vmdl")
		spikeTrap:SetModel("models/props/traps/spiketrap/spiketrap.vmdl")
		spikeTrap:SetModelScale(1.4)
		spikeTrap:SetForwardVector(Vector(1,0))
		spikeTrap:FindAbilityByName("dummy_unit"):SetLevel(1)
		spikeTrap.dummy = true
		table.insert(Tanari.BoulderSpine.SpikeTrapTable, spikeTrap)
	end
	Timers:CreateTimer(3, function()
		for i = 1, #Tanari.BoulderSpine.SpikeTrapTable, 1 do
			local caster = Tanari.BoulderSpine.SpikeTrapTable[i]
			StartAnimation(caster, {duration=2.45, activity=ACT_DOTA_ATTACK, rate=2})
			Timers:CreateTimer(0.5, function()
				EmitSoundOn("Tanari.SpikeTrap", caster)
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
				if #enemies > 0 then
					for j = 1, #enemies, 1 do
						local target = enemies[j]
						EmitSoundOn("Tanari.Spikes", target)
						local damage = target:GetMaxHealth()*0.35
						ApplyDamage({ victim = target, attacker = Events.GameMaster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
						PopupDamage(target, damage)
					end
				end
			end)
		end

		if not Tanari.BoulderSpine.CaveClear then
			return 2.5
		else
			-- for k = 1, #Tanari.BoulderSpine.SpikeTrapTable, 1 do
			-- 	Timers:CreateTimer(2, function()
			-- 		UTIL_Remove(Tanari.BoulderSpine.SpikeTrapTable[k])
			-- 	end)
			-- end
		end
	end)
	Tanari:SpawnBoulderspinePudge(Vector(1947, 11830), Vector(0,-1))
	Tanari:SpawnBoulderspinePudge(Vector(2099, 11827), Vector(0,-1))
	Tanari:SpawnBoulderspinePudge(Vector(2752, 11830), Vector(0,-1))
	Tanari:SpawnBoulderspinePudge(Vector(2840, 11830), Vector(0,-1))
	Timers:CreateTimer(1.5, function()
		if GameState:GetDifficultyFactor() >= 2 then
			Tanari:SpawnBoulderspinePyro(Vector(2432, 11904), Vector(-1,-1))
		end
		if GameState:GetDifficultyFactor() >= 3 then
			Tanari:SpawnBoulderspinePyro(Vector(3176, 11904), Vector(-1,-1))
		end
		Tanari:SpawnBoulderspinePyro(Vector(3200, 12288), Vector(-1,-1))
	end)
end

function Tanari:SpawnBoulderspinePudge(position, fv)
	local pudge = Dungeons:SpawnDungeonUnit("chained_butcher", position, 1, 1, 3, "pudge_pud_anger_04", fv, false, nil)
	pudge.itemLevel = 51

	Events:AdjustBossPower(pudge, 3, 3)
end

function Tanari:SpawnBoulderspinePyro(position, fv)
	local pudge = Dungeons:SpawnDungeonUnit("boulderspine_pyro", position, 1, 3, 4, "pudge_pud_anger_04", fv, true, nil)
	pudge.itemLevel = 55
	Events:AdjustBossPower(pudge, 4, 4)
	pudge.targetRadius = 1000
	pudge.minRadius	= 0
	pudge.targetAbilityCD = 1.5
	pudge.targetFindOrder = FIND_ANY_ORDER
	pudge:SetRenderColor(255, 150, 70)
end

function Tanari:SpawnFireBat(position, fv)
	local hunter = Tanari:SpawnDungeonUnit("boulderspine_firebat", position, 0, 1, nil, fv, true)
	hunter.itemLevel = 48
	hunter:SetAbsOrigin(hunter:GetAbsOrigin()-Vector(0,0,500))
	hunterAbility = hunter:FindAbilityByName("boulderspine_fire_bat_ai")
	hunterAbility:ApplyDataDrivenModifier(hunter, hunter, "modifier_fire_bat_entrance", {duration = 2.7})
	for i = 1, 90, 1 do
		Timers:CreateTimer(0.03*i, function()
			hunter:SetAbsOrigin(hunter:GetAbsOrigin()+Vector(0,0,math.abs(math.sin(i)*10)))
		end)
	end
	hunter.dominion = true
	return hunter
end

function Tanari:SpawnBoulderspineFinalRoom()
	if not Tanari.BoulderSpine then
		Tanari.BoulderSpine = {}
	end
	Tanari.BoulderSpine.iceKilled = 0
	local princess = CreateUnitByName("boulderspine_princess", Vector(1950, 15119), false, nil, nil, DOTA_TEAM_GOODGUYS)
	princess.phase = 0
	local ability = princess:FindAbilityByName("boulderspine_princess_ability_ai")
	Events:AdjustDeathXP(princess)
	ability:SetLevel(1)
	Timers:CreateTimer(1, function()
		ability:ApplyDataDrivenModifier(princess, princess, "modifier_boulderspine_princess_frozen", {})
	end)
	princess:SetForwardVector(Vector(0,-1))
	princess:SetAbsOrigin(princess:GetAbsOrigin()+Vector(0,0,140))
	Tanari.BoulderSpine.Princess = princess
	Timers:CreateTimer(2, function()
		for i = 1, 30, 1 do
			Tanari:SpawnLivingIceBoulderspinePosition(false)
		end
	end)

	
end

function Tanari:SpawnLivingIceBoulderspinePosition(aggro)
	local position = false
	local luck = RandomInt(1, 5)
	if luck == 5 then
		local basePosition = Vector(3065, 13120)
		local randomX = RandomInt(1, 320)
		local randomY = RandomInt(0, 600)
		position = basePosition+Vector(randomX, randomY)
	else
		local basePosition = Vector(1536, 13120)
		local randomX = RandomInt(1, 1200)
		local randomY = RandomInt(0, 1100)
		position = basePosition+Vector(randomX, randomY)
	end
	local hunter = Tanari:SpawnDungeonUnit("boulderspine_living_ice", position, 0, 1, nil, RandomVector(1), aggro)
	hunter.itemLevel = 48
	hunter.dominion = true
end

function Tanari:SpawnLivingIce(position)
	local hunter = Tanari:SpawnDungeonUnit("boulderspine_living_ice", position, 0, 1, nil, RandomVector(1), true)
	hunter.itemLevel = 48
	hunter.dominion = true
end

function Tanari:SpawnLindworm()
	local dragon = Tanari:SpawnDungeonUnit( "boulderspine_lindworm_frost", Vector(2048, 16320), 6, 7, nil, Vector(0,-1), true)
	StartAnimation(dragon, {duration=2.45, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7})
	local dragonAbility = dragon:FindAbilityByName("boulderspine_lindworm_frost_ai")
	dragonAbility:ApplyDataDrivenModifier(dragon, dragon, "modifier_lindworm_entering", {duration = 4})
	dragonAbility:ApplyDataDrivenModifier(dragon, dragon, "modifier_lindworm_min_health", {})
	dragon:SetAbsOrigin(dragon:GetAbsOrigin()+Vector(0,0,700))
	local landPosition = Vector(1984, 13696, 139) 
	local moveDirection = ((landPosition-dragon:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	for i = 1, 160, 1 do
		Timers:CreateTimer(0.03*i, function()
			dragon:SetAbsOrigin(dragon:GetAbsOrigin()+moveDirection*14+(Vector(0,0,-3.7)*(math.cos(i*2*math.pi/80)+1)))
			AddFOWViewer(DOTA_TEAM_GOODGUYS, dragon:GetAbsOrigin()+Vector(0,0,100), 240, 2, false)
			--print(dragon:GetAbsOrigin())
		end)
	end
	dragon.itemLevel = 62
	Events:AdjustBossPower(dragon, 5, 5)
	Timers:CreateTimer(2.2, function()
		EmitGlobalSound("Tanari.FrostWyrmStart")
	end)
end

function Tanari:ShatterPrincess(allies)
	Dungeons:CreateBasicCameraLockForHeroes(Tanari.BoulderSpine.Princess:GetAbsOrigin(), 5, allies)
	Tanari.BoulderSpine.PrincessShattered = true
	local princess = Tanari.BoulderSpine.Princess
	Tanari.royalGuardsSlain = 0
	Timers:CreateTimer(1, function()
		princess:RemoveModifierByName("modifier_boulderspine_princess_frozen")
		local princessAbility = princess:FindAbilityByName("boulderspine_princess_ability_ai")
		princessAbility:ApplyDataDrivenModifier(princess, princess, "modifier_princess_cinematic", {duration = 5})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_medusa/ice_shatter.vpcf", princess, 4)
		StartAnimation(princess, {duration=1.6, activity=ACT_DOTA_CAST_ABILITY_3, rate=1})
		EmitSoundOn("Tanari.MagicIceShatter", princess)
		for i = 1, 90, 1 do
			Timers:CreateTimer(i*0.03, function()
				princess:SetAbsOrigin(princess:GetAbsOrigin()-Vector(0,0,2))
			end)
		end
	end)
	Timers:CreateTimer(3.7, function()
		EmitSoundOn("Tanari.PrincessGreeting", princess)
		local princessAbility = princess:FindAbilityByName("boulderspine_princess_ability_ai")
		princessAbility:ApplyDataDrivenModifier(princess, princess, "modifier_princess_alive_ai", {})
		princess.wayPointEnabled = true
	end)
end

function Tanari:InitializeWaterKeyArea()
	Tanari:SpawnSlithereenGuard(Vector(5504, -4416), Vector(-1, 0), false)
	Timers:CreateTimer(0.5, function()
		Tanari:SpawnSlithereenGuard(Vector(5504, -4672), Vector(-1, 0), false)
	end)
	Timers:CreateTimer(2, function()
		Tanari:SpawnSlithereenGuard(Vector(6912, -4000), Vector(-1, 0), false)
		Tanari:SpawnSlithereenFeatherguard(Vector(6912, -4150), Vector(-1,0), false)
		Tanari:SpawnSlithereenGuard(Vector(6912, -4300), Vector(-1, 0), false)
		Tanari:SpawnSlithereenFeatherguard(Vector(6912, -4450), Vector(-1,0), false)
		Tanari:SpawnSlithereenGuard(Vector(6912, -4600), Vector(-1, 0), false)
	end)
	Timers:CreateTimer(4, function()
		Tanari:SpawnSlithereenRoyalGuard(Vector(8320, -4992), Vector(-1, 0), false)
		Timers:CreateTimer(2, function()
			Tanari:SpawnSlithereenRoyalGuard(Vector(8320, -5465), Vector(-1, 0), false)
		end)
	end)
	local positionTable = {Vector(5056, -3861), Vector(5760, -5312), Vector(6464, -3861), Vector(6608, -5056), Vector(7347, -5375), Vector(8912, -5762)}
	for i = 1, #positionTable, 1 do
		local clam = Tanari:SpawnClamSpawner(positionTable[i], RandomVector(1), positionTable[i])
		clam.special = true
	end
end

function Tanari:SpawnSlithereenGuard(position, fv, bAggro)
	local guard = Tanari:SpawnDungeonUnit("boulderspine_slithereen_guard", position, 1, 2, nil, fv, bAggro)
	guard.itemLevel = 54
	Events:AdjustBossPower(guard, 2, 2)
	guard.dominion = true
	return guard
end

function Tanari:SpawnSlithereenFeatherguard(position, fv, bAggro)
	local guard = Tanari:SpawnDungeonUnit("boulderspine_slithereen_featherguard", position, 1, 2, nil, fv, bAggro)
	guard.itemLevel = 55
	Events:AdjustBossPower(guard, 2, 2)
	guard.dominion = true
	return guard
end

function Tanari:SpawnSlithereenRoyalGuard(position, fv, bAggro)
	local guard = Tanari:SpawnDungeonUnit("boulderspine_slithereen_royal_guard", position, 2, 3, "slardar_slar_anger_06", fv, bAggro)
	guard.itemLevel = 58
	Events:AdjustBossPower(guard, 4, 4)
	guard.dominion = true
	return guard
end

function Tanari:SpawnWaterTempleKeyHolder(position, fv)
	Timers:CreateTimer(1, function()
		EmitGlobalSound("Tanari.RockShake")
		ScreenShake(position, 300, 1.1, 0.7, 9000, 0, true)
	end)
	Timers:CreateTimer(2, function()
		EmitGlobalSound("Tanari.RockShake")
		ScreenShake(position, 300, 1.1, 0.7, 9000, 0, true)
	end)
	Timers:CreateTimer(3, function()
		local beast = Tanari:SpawnEnemyUnit("water_temple_keyholder", position, fv)
		Events:AdjustBossPower(beast, 10, 10)
		beast.itemLevel = 60
		beast:SetAbsOrigin(beast:GetAbsOrigin()-Vector(0,0,500))
		for i = 1, 30, 1 do
			Timers:CreateTimer(i*0.03, function()
				beast:SetAbsOrigin(beast:GetAbsOrigin()+Vector(0,0,17.5))
				ScreenShake(beast:GetAbsOrigin(), 500, 0.1, 0.1, 9000, 0, true)
			end)
		end
		local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
		
		gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, beast, "modifier_disable_player", {duration = 1})
		local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
	    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, beast)
	    for k = 0, 4, 1 do
	    	ParticleManager:SetParticleControl(pfx,k,beast:GetAbsOrigin()+Vector(0,0,480) )
		end
	    Timers:CreateTimer(1.25, function()
	    	EmitGlobalSound("Tanari.WaterKeyHolderAggro")
	    	ParticleManager:DestroyParticle(pfx, false)
	    end)
	end)
end

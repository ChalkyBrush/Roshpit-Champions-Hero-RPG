if Seafortress == nil then
  Seafortress = class({})
end

function Seafortress:Debug()
    if MAIN_HERO_TABLE[1] then
      MAIN_HERO_TABLE[1]:SetBaseStrength(25000)
      MAIN_HERO_TABLE[1]:SetBaseAgility(25000)
      MAIN_HERO_TABLE[1]:SetBaseIntellect(25000)
      MAIN_HERO_TABLE[1]:SetBaseDamageMax(500000)
      MAIN_HERO_TABLE[1]:SetBaseDamageMin(500000)
      MAIN_HERO_TABLE[1]:CalculateStatBonus()
    end

    local item = RPCItems:CreateItem("item_debug_blink", nil, nil)
    local drop = CreateItemOnPositionSync( Vector(844, -15488), item )
    local position = Vector(844, -15488)
    RPCItems:DropItem(item, Vector(844, -15488))
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(4800, -2176), 800, 300, false)
    RPCItems:CreateBasicConsumable(Vector(844, -15488), "item_rpc_grimloks_soul_vessel", "Grimlok's Soul Vessel", "immortal", true)
   -- local unit = Seafortress:SpawnCephapolos(Vector(844, -15488), Vector(1,0))
   -- unit:AddAbility("paragon_abilities"):SetLevel(1)
   -- local ability = unit:FindAbilityByName("paragon_abilities")
   -- ability:ApplyDataDrivenModifier(unit, unit, "modifier_paragon_crippling", {})
    -- Dungeons.itemLevel = 300
    -- for i = 1, 6, 1 do
    --   RPCItems:RollSeinaruArcana1(Vector(844, -15488))
    -- end

    -- Seafortress:SpawnBehindMountainArea()
    -- Seafortress:SpawnCanyonRoom()
    -- Seafortress:SpawnAfterTempleRoom()
    -- Weapons:RollLegendWeapon2(Vector(844, -15488), "ekkan")
    -- Weapons:RollLegendWeapon3(Vector(844, -15488), "ekkan")     
    -- Arena = {}
    -- Arena.PitLevel = 7
    -- Weapons:RollLegendWeapon1(Vector(844, -15488), "bahamut")

    -- Seafortress:SpawnAfterLaserTempleArea()
    -- Seafortress:InitiateBehindFloodArea()
    -- Seafortress:AfterZealotRoom()
    -- Seafortress:SpawnDeepRoom4()
     -- Seafortress:SpawnAfterJailRoom()
     -- RPCItems:RollChernobogArcana1(Vector(844, -15488))
end

function Seafortress:Debug2()
  Seafortress.AllBossesSlainEffect = true
  -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-11478, -723), 800, 300, false)
  -- Seafortress:ActivateLaserCrystal(Vector(-11478, -723, 306))
  -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-11478, -723), 800, 300, false)

          -- EmitSoundOnLocationWithCaster(Vector(-460, -1804, 245), "Seafortress.MemoryButton.Complete", Events.GameMaster)
          -- local wall = Entities:FindByNameNearest("SeaDoor10", Vector(-1280, -2700, -131+Seafortress.ZFLOAT), 900)
          -- Seafortress:Walls(false, {wall}, true, 4)
          -- Seafortress:RemoveBlockers(4, "SeaBlocker9", Vector(-1280, -2688, 191), 1400)
          -- Seafortress.MemoryPuzzleComplete = true
          -- Seafortress:AfterMemoryPuzzleRoomSpawn()

    -- Seafortress:SpawnSeaDragonWarrior(Vector(-3905, 1309), Vector(0,-1))
    -- Seafortress:all_graves_lit()
    -- Seafortress:AfterDragonRoom()
    -- Seafortress:SpawnDarkReefTempleRoom()

    -- Seafortress:FinalRoom(1)
    -- Seafortress:FinalRoom(2)
    -- Seafortress:FinalRoom(3)

    -- Seafortress:AllBossesSlain()
    -- Seafortress:SpawnShadowOfBahamut()
    -- Seafortress:AllBossesSlain()
    -- Seafortress:SpawnFinalBoss()
    -- Seafortress:SpawnGardenRoom()
end

function Seafortress:ActivateOrDeactiveArchon()
  local archonMax = 27 - GameState:GetPlayerPremiumStatusCount()*2
  local luck = RandomInt(1, archonMax)
  if luck == 1 then
    Seafortress.ArkimusActive = true
    Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-14683, 3444, 110+Seafortress.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
  else
    local pad = Entities:FindByNameNearest("ArkimusTeleportPad", Vector(-14683, 3444), 600)
    UTIL_Remove(pad)
  end
end

function Seafortress:InitPaladinGolems()
  local paladinMax = 24 - GameState:GetPlayerPremiumStatusCount()*2
  local luck = RandomInt(1, paladinMax)
  if luck == 1 then
    Seafortress.PaladinGolems = 0
    Seafortress.PaladinArcana = true
  end
end

function Seafortress:Init()
  print("Initialize Sea Fortress")
      Dungeons.phoenixCollision = true
      RPCItems.DROP_LOCATION = Vector(6656,-16128)
      Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
      Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
      Events.GameMaster:RemoveModifierByName("modifier_portal")

      Seafortress.Master = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
      Seafortress.Master:AddAbility("sea_fortress_ability"):SetLevel(GameState:GetDifficultyFactor())
      Seafortress.MasterAbility = Seafortress.Master:FindAbilityByName("sea_fortress_ability")
      Seafortress.Master:AddAbility("dummy_unit"):SetLevel(1)

    Seafortress.ZFLOAT = 0
  -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-4864, 4112), 5000, 5000, false)
  Timers:CreateTimer(2, function()
    -- Events:SpawnSuppliesDealer(Vector(-3232, 2427), Vector(0,-1))

  end)
  Events.TownPosition = Vector(448, -15744)
  Events.isTownActive = true
  Events.Dialog0 = false
  Events.Dialog1 = false
  Events.Dialog2 = false
  Events.Dialog3 = false
  Dungeons.itemLevel = 1
  Timers:CreateTimer(3, function()
      local blacksmith = Events:SpawnTownNPC(Vector(-448, -16064), "red_fox", Vector(0, 1), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
      StartAnimation(blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
      local oracle = Events:SpawnOracle(Vector(1344, -15488), Vector(-1, -0.3))
      Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(-512, -14912), Vector(1, -1))
      Events:SpawnCurator(Vector(1216, -14976), Vector(-1,-0.2))
  end)

  Seafortress:Music()
  Seafortress:Ambience()

  Timers:CreateTimer(6, function()
  	Seafortress:SpawnRoom1()
  end)

  --OTHER DUNGEON INITS
  Seafortress.switchA = Entities:FindByNameNearest("CastleSwitch1a", Vector(-12913, -9341, 139+Seafortress.ZFLOAT), 900)
  Seafortress.switchA:SetAbsOrigin(Seafortress.switchA:GetAbsOrigin()-Vector(0,0,1000))

  Seafortress.switchB = Entities:FindByNameNearest("CastleSwitch2", Vector(-9316, 2084, 12+Seafortress.ZFLOAT), 900)
  Seafortress.switchB:SetAbsOrigin(Seafortress.switchB:GetAbsOrigin()-Vector(0,0,1000))

  Seafortress.Jumper = Entities:FindByNameNearest("SeaJumper", Vector(2128, -8189, 400+Seafortress.ZFLOAT), 1200)
  Seafortress.Jumper:SetAbsOrigin(Seafortress.Jumper:GetAbsOrigin()-Vector(0,0,1000))

  Seafortress.PlatformsTable = {}
  Seafortress.PlatformsTable[1] = Entities:FindByNameNearest("Platform1", Vector(-10327, 4921, 124+Seafortress.ZFLOAT), 1200)
  Seafortress.PlatformsTable[2] = Entities:FindByNameNearest("Platform2", Vector(-8893, 4552, 124+Seafortress.ZFLOAT), 1200)
  Seafortress.PlatformsTable[3] = Entities:FindByNameNearest("Platform3", Vector(-7410, 4511, 124+Seafortress.ZFLOAT), 1200)
  Seafortress.PlatformsTable[4] = Entities:FindByNameNearest("Platform4", Vector(-7222, 6081, 124+Seafortress.ZFLOAT), 1200)

  for i = 1, #Seafortress.PlatformsTable, 1 do
    Seafortress.PlatformsTable[i]:SetAbsOrigin(Seafortress.PlatformsTable[i]:GetAbsOrigin()-Vector(0,0,1000))
  end

  local bridge = Entities:FindByNameNearest("PirateBridgeForGrid", Vector(7808, 7671, 91+Seafortress.ZFLOAT), 1200)
  bridge:SetModel("models/development/invisiblebox.vmdl")

  local bridge = Entities:FindByNameNearest("PirateBridgeForGrid", Vector(8841, 11179, 91+Seafortress.ZFLOAT), 1200)
  bridge:SetModel("models/development/invisiblebox.vmdl")

  Seafortress.Jumper2 = Entities:FindByNameNearest("SeaJumper", Vector(-6398, 14592, 652+Seafortress.ZFLOAT), 1200)
  Seafortress.Jumper2:SetAbsOrigin(Seafortress.Jumper2:GetAbsOrigin()-Vector(0,0,1000))
  Timers:CreateTimer(5, function()
    local particleName = "particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons.vpcf"
    Seafortress.switchPFX = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(Seafortress.switchPFX, 0, Vector(-6638, 2503))
    ParticleManager:SetParticleControl(Seafortress.switchPFX, 1, Vector(190, 190, 190))
  end)
  Seafortress.TempleEnergyState = -1
  Seafortress:OlSpiny()
end

function Seafortress:OlSpiny()
  local max_roll = 18 - GameState:GetPlayerPremiumStatusCount()*2
  local luck = RandomInt(1, max_roll)
  if luck == 1 then
    PrecacheUnitByNameAsync("seafortress_ol_spiny", function(...) end)
    local random_delay = RandomInt(45, 360)
    Timers:CreateTimer(random_delay, function()
      local random_position = Vector(RandomInt(-14000, 14000), RandomInt(-14000, 14000))
      Seafortress:SpawnOlSpiny(random_position, RandomVector(1))
    end)
  end
end

function Seafortress:LeftWingKill()
  if not Seafortress.LeftWingKills then
    Seafortress.LeftWingKills = 0
  end
  Seafortress.LeftWingKills = Seafortress.LeftWingKills + 1
  if Seafortress.LeftWingKills == 6 then
    Seafortress.CentaurSwitchActive = true
    ParticleManager:DestroyParticle(Seafortress.switchPFX, false)
    Seafortress:ActivateOrDeactiveArchon()
  end
end

function Seafortress:MiddleObjective()
  if not Seafortress.MiddleObjectives then
    Seafortress.MiddleObjectives = 0
  end
  Seafortress.MiddleObjectives = Seafortress.MiddleObjectives + 1
  if Seafortress.MiddleObjectives == 5 then
    Timers:CreateTimer(1, function()
      Seafortress:SpawnSkultoth(Vector(-704, 5056), Vector(0,-1))
    end)
  end
end

function Seafortress:ActivateSwitchGeneric(buttonPosition, buttonName, bDown, ms)
  local movementZ = ms
  if bDown then
    movementZ = -ms
  end
  local switch = Entities:FindByNameNearest(buttonName, buttonPosition, 600)
  local walls = {switch}
  Timers:CreateTimer(0.1, function()
    EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Arena.WaterTemple.SwitchStart", Events.GameMaster)
  end)
  for i = 1, 60, 1 do
    for j = 1, #walls, 1 do
      Timers:CreateTimer(i*0.03, function()
        walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
      end)
    end
  end
  Timers:CreateTimer(1.7, function()
    EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Arena.WaterTemple.SwitchEnd", Events.GameMaster)
  end)
end

function Seafortress:Music()
  Timers:CreateTimer(3, function()
    print("MUSIC??")
    print(Seafortress.AllBossesSlainEffect)
    if Seafortress.AllBossesSlainEffect then
    else
      	 for i = 1, #MAIN_HERO_TABLE, 1 do
    		  CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
    		  CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Seafortress.StartingMusic"})
    	  end
    	  return 110
    end
  end)
end

function Seafortress:Ambience()
	Timers:CreateTimer(0, function()
    Dungeons.itemLevel = 300
		local positionTable = {Vector(-1920, -15680), Vector(2304, -15552), Vector(-512, -13440)}
		for i = 1, #positionTable, 1 do
			EmitSoundOnLocationWithCaster(positionTable[i], "Seafortress.OceanWaves", Seafortress.Master)
		end
    for i = 1, #MAIN_HERO_TABLE, 1 do
      CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "update_zone_display", {zoneName = "rpc_sea_fortress"} )
    end
		return 13
	end)
end

function Seafortress:SpawnDungeonUnit(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)
    local luck = 0
    if not Events.SpiritRealm then
      luck = RandomInt(1, 100)
    else
      luck = RandomInt(1, 50)
    end
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
    -- Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    if fv then
      unit:SetForwardVector(fv)
    end
    if isAggro then
      Dungeons:AggroUnit(unit)
    end
    Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, unit, "modifier_sea_fortress_ai", {})
    return unit
end

function Seafortress:SpawnUnitNoParagon(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)
    local luck = 0
    if not Events.SpiritRealm then
      luck = RandomInt(1, 180)
    else
      luck = RandomInt(1, 50)
    end
    local unit = ""

     unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
     Events:AdjustDeathXP(unit)

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
    -- Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
    if fv then
      unit:SetForwardVector(fv)
    end
    if isAggro then
      Dungeons:AggroUnit(unit)
    end
    Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, unit, "modifier_sea_fortress_ai", {})
    return unit
end

function Seafortress:AddPatrolArguments(unit, patrolSlow, phaseIntervals, patrolPointRandom, patrolPositionTable)
  unit:AddAbility("monster_patrol"):SetLevel(1)
  unit.patrolSlow = patrolSlow
  unit.phaseIntervals = phaseIntervals
  unit.patrolPointRandom = patrolPointRandom
  unit.patrolPositionTable = patrolPositionTable
end

function Seafortress:SpawnRoom1()
	local positionTable = {Vector(-533, -10368), Vector(-640, -9728), Vector(-452, -9088), Vector(960, -9536), Vector(1673, -10068), Vector(1024, -10432), Vector(320, -10432)}
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.8, function()
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local elemental = Seafortress:SpawnSeaQueen(positionTable[i], RandomVector(1))
			Seafortress:AddPatrolArguments(elemental, 30, 5, 100, patrolPositionTable)
      elemental.deathCode = 0
		end)
	end
	Timers:CreateTimer(2, function()
		Seafortress:SpawnBarnacleBehemoth(Vector(-1152, -10304), Vector(1,0))
		Seafortress:SpawnBarnacleBehemoth(Vector(-768, -8512), Vector(0,-1))
		Seafortress:SpawnBarnacleBehemoth(Vector(1408, -9536), Vector(-1,-1))
		Seafortress:SpawnBarnacleBehemoth(Vector(1984, -10432), Vector(-1,0))
	end)
  Timers:CreateTimer(4, function()
    Seafortress:SpawnBarnacleBehemoth(Vector(3200, -10824), Vector(0,1))
    Seafortress:SpawnBarnacleBehemoth(Vector(3200, -11272), Vector(0,1))

    Seafortress:SpawnSlithereenElite(Vector(2468, -11487), Vector(1,0))
    Seafortress:SpawnSlithereenElite(Vector(2112, -11487), Vector(1,0))
    Seafortress:SpawnSlithereenElite(Vector(1756, -11487), Vector(1,0))

    Seafortress:SpawnOceanWatcher(Vector(3224, -11904), Vector(-1,-1))
  end)

  local maiden = Seafortress:SpawnSeaMaiden(Vector(2084, -8198), Vector(-1,0))
  maiden.deathCode = 12
end

function Seafortress:SpawnSeaQueen(position, fv)
	local queen = Seafortress:SpawnDungeonUnit("sea_fortress_sea_queen", position, 1, 3, "Seafortress.SeaQueen.Aggro", fv, false)
	queen.dominion = true
	queen:SetRenderColor(100, 180, 255)
	Events:AdjustBossPower(queen, 5, 3, false)
	return queen
end

function Seafortress:SetPositionCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
    unit.targetRadius = radius
    unit.minRadius = minRadius
    unit.targetAbilityCD = cooldown
    unit.targetFindOrder = targetFindOrder
end

function Seafortress:SetTargetCastArgs(unit, targetRadius, minRadius, targetAbilityCD, targetFindOrder)
	unit.targetRadius = targetRadius
	unit.minRadius	= minRadius
	unit.targetAbilityCD = targetAbilityCD
	unit.targetFindOrder = targetFindOrder
end

function Seafortress:SpawnBarnacleBehemoth(position, fv)
	local queen = Seafortress:SpawnDungeonUnit("sea_fortress_barnacle_behemoth", position, 1, 3, "Seafortress.Barnacle.Aggro", fv, false)
	queen.dominion = true
	queen:SetRenderColor(100, 140, 255)
  queen.reduc = 0.5
	Events:AdjustBossPower(queen, 8, 8, false)
	Seafortress:SetTargetCastArgs(queen, 400, 0, 1, FIND_ANY_ORDER)
	return queen
end

function Seafortress:SpawnLakeCheep(position, fv, bForcePos)
	local animationTable = {ACT_DOTA_SLARK_POUNCE, ACT_DOTA_CAST_ABILITY_1}
	local fish = Seafortress:SpawnDungeonUnit("seafortress_cheep", position, 0, 1, nil, fv, false)
  if bForcePos then
    fish:SetAbsOrigin(position)
  end
	EmitSoundOn("SeaFortress.CheepJump", fish)
	local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, fish)
    for j = 0, 4, 1 do
    	ParticleManager:SetParticleControl(pfx,j,fish:GetAbsOrigin() )
	end
    Timers:CreateTimer(1, function()
    	ParticleManager:DestroyParticle(pfx, false)
    end)
    fish.dominion = true
	StartAnimation(fish, {duration=0.8, activity=animationTable[RandomInt(1,2)], rate=1})
  if bForcePos then
	 WallPhysics:Jump(fish, fv, 18, 38, 26, 1)
  else
    WallPhysics:Jump(fish, fv, 19, 22, 24, 1)
  end
end

function Seafortress:SpawnLakeCheepWithBlocking(position, fv, bForcePos)
  local animationTable = {ACT_DOTA_SLARK_POUNCE, ACT_DOTA_CAST_ABILITY_1}
  local fish = Seafortress:SpawnDungeonUnit("seafortress_cheep", position, 0, 1, nil, fv, false)
  if bForcePos then
    fish:SetAbsOrigin(position)
  end
  EmitSoundOn("SeaFortress.CheepJump", fish)
  local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, fish)
    for j = 0, 4, 1 do
      ParticleManager:SetParticleControl(pfx,j,fish:GetAbsOrigin() )
  end
    Timers:CreateTimer(1, function()
      ParticleManager:DestroyParticle(pfx, false)
    end)
    fish.dominion = true
  StartAnimation(fish, {duration=0.8, activity=animationTable[RandomInt(1,2)], rate=1})
  if bForcePos then
   WallPhysics:JumpWithBlocking(fish, fv, 19, 24, 32, 1)
  else
    WallPhysics:JumpWithBlocking(fish, fv, 19, 22, 24, 1)
  end
end

function Seafortress:SpawnSeaLord(position, fv)
	local mage = Seafortress:SpawnDungeonUnit("sea_fortress_sea_lord_arghul", position, 1, 3, "SeaFortress.SeaGod.Aggro", fv, false)
  mage.pushLock = true
  mage.jumpLock = true
	Events:AdjustBossPower(mage, 5, 5, false)
	mage:SetRenderColor(120, 180, 255)
	-- Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	-- Events:SetPositionCastArgs(mage, 1400, 0, 1, FIND_ANY_ORDER)
	return mage
end

function Seafortress:Walls(bRaise, walls, bSound, movementZ)
  if not bRaise then
    movementZ = movementZ*-1
  end
  if #walls > 0 then
    Timers:CreateTimer(0.1, function()
      if bSound then
        for i = 1, #walls, 1 do
          EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Seafortress.WallOpen", Events.GameMaster)
        end
      end
    end)
    for i = 1, 180, 1 do
      for j = 1, #walls, 1 do
        Timers:CreateTimer(i*0.03, function()
          walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
          if j == 1 then
            ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
          end
        end)
      end
    end
  end
end

function Seafortress:RemoveBlockers(delay, blockername, position, searchRadius)
    Timers:CreateTimer(delay, function()
      local blockers = Entities:FindAllByNameWithin(blockername, position, searchRadius)
      for i = 1, #blockers, 1 do
        UTIL_Remove(blockers[i])
      end
    end)
end

function Seafortress:SpawnSeaPortal(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_sea_portal", position, 1, 3, "Seafortress.SeaPortal.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 140, 255)
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetPositionCastArgs(queen, 1400, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnRoom2()
  Timers:CreateTimer(1.5, function()
    local positionTable = {Vector(-3776, -10688), Vector(-4288, -10368), Vector(-3968, -9024), Vector(-2944, -8960), Vector(-2880, -10368)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(-3520, -9920) - positionTable[i]):Normalized()
      Seafortress:SpawnSeaPortal(positionTable[i], lookToPoint)
    end
  end)
  local posTable2 = {Vector(-3917, -10009), Vector(-3527, -9600), Vector(-3406, -10237)}
  for i = 1, #posTable2, 1 do
    Seafortress:SpawnBarnacleBehemoth(posTable2[i], Vector(1,0))
  end
  Timers:CreateTimer(2.5, function()
    local tree = Seafortress:SpawnWaterTree(Vector(-6595, -8827), Vector(1,0))
    local positionTable = {Vector(-5504, -11392), Vector(-5696, -10176), Vector(-6595, -8827), Vector(-3318, -8071)}
    Seafortress:AddPatrolArguments(tree, 0, 6, 140, positionTable)
    Seafortress.treeBoss = tree
    tree.deathCode = 3
    tree.reduc = 0.3
  end)
  Seafortress:SpawnStrongRanger(Vector(-4160, -11328), Vector(1,1))
  Seafortress.seaTreesGrown = 0
end

function Seafortress:SpawnWaterTree(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_leaflet_master", position, 2, 5, nil, fv, false)
  queen:SetRenderColor(100, 140, 255)
  -- Events:ColorWearables(queen, Vector(100, 140, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.25
  return queen
end

function Seafortress:SpawnLeaflet(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_leaflet", position, 0, 0, nil, fv, true)
  queen:SetRenderColor(80, 120, 255)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetAbsOrigin(position)
  queen.dominion = true
  return queen
end

function Seafortress:SpawnLeafletRanged(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_leaflet_ranged", position, 0, 0, nil, fv, true)
  queen:SetRenderColor(80, 120, 255)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetAbsOrigin(position)
  queen.dominion = true
  return queen
end

function Seafortress:SpawnStrongRanger(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_goddess_of_the_hunt", position, 2, 5, nil, fv, false)
  queen:SetRenderColor(60, 60, 60)
  Events:AdjustBossPower(queen, 10, 10, false)
  Seafortress:SetPositionCastArgs(queen, 1500, 0, 1, FIND_CLOSEST)
  queen.reduc = 0.25
  return queen
end
 
function Seafortress:SpawnLunarRanger(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "sea_fortress_lunar_archer", position, 0, 2, nil, fv, false)
  queen:SetRenderColor(60, 60, 60)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.dominion = true
  return queen
end
 
function Seafortress:SpawnVenomousDragonfly(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "sea_fortress_venomous_dragonfly", position, 0, 2, nil, fv, true)
  queen:SetRenderColor(150, 180, 255)
  Events:AdjustBossPower(queen, 5, 5, false)
  queen.dominion = true
  return queen
end

function Seafortress:SpawnWaterScorcher(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "sea_fortress_aqua_scorcher", position, 1, 2, nil, fv, true)
  queen:SetRenderColor(0, 0, 255)
  Events:AdjustBossPower(queen, 7, 7, false)
  queen:SetAbsOrigin(queen:GetAbsOrigin()-Vector(0,0,180))
  queen.dominion = true
  return queen
end

function Seafortress:SpawnGardenRoom()
  Timers:CreateTimer(1, function()
    local positionTable = {Vector(-7168, -15552), Vector(-7488, -14400), Vector(-7360, -14016), Vector(-5760, -14592), Vector(-5632, -13888), Vector(-6784, -12992)}
    for i = 1, #positionTable, 1 do
      Seafortress:SpawnVenomousDragonfly(positionTable[i], RandomVector(1))
    end
  end)
  Seafortress:SpawnWaterScorcher(Vector(-7488, -13376), Vector(1,0))
  Seafortress:SpawnWaterScorcher(Vector(-5916, -15240), Vector(0,1))
  Timers:CreateTimer(2, function()
    local lookToPoint = Vector(-6272, -12864)
    local positionTable = {Vector(-7099, -14784), Vector(-6750, -14884), Vector(-6656, -14528), Vector(-7168, -14464), Vector(-6848, -14324), Vector(-6336, -14338), Vector(-6580, -14144), Vector(-6264, -14062), Vector(-6467, -13824), Vector(-6522, -13568), Vector(-6176, -13496), Vector(-6339, -13248)}
    for i = 1, #positionTable, 1 do
      local fv = (lookToPoint - positionTable[i]):Normalized()
      Seafortress:SpawnSeaDryad(positionTable[i], fv)
    end  
  end)
  Timers:CreateTimer(4, function()
    Seafortress:SpawnSeaPortal(Vector(-8064, -15296), Vector(1,1))
    Seafortress:SpawnSeaPortal(Vector(-8576, -14400), Vector(1,-1))
  end)
  Timers:CreateTimer(0, function()
    EmitSoundOnLocationWithCaster(Vector(-8590, -13076), "Seafortress.Waterfall.Lite", Seafortress.Master)
    return 24
  end)
  Timers:CreateTimer(3, function()
    Seafortress:SpawnAhnQhir(Vector(-8064, -11136), Vector(0,-1))
  end)
  Timers:CreateTimer(5, function()
    local lookToPoint = Vector(-10048, -14784)
    local positionTable = {Vector(-10304, -13056), Vector(-11328, -13120), Vector(-10432, -13888), Vector(-10880, -14464), Vector(-10816, -15104)}
    for i = 1, #positionTable, 1 do
      local fv = (lookToPoint - positionTable[i]):Normalized()
      Seafortress:SpawnSeaDryad(positionTable[i], fv)
    end  
  end)
end

function Seafortress:SpawnSeaDryad(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "sea_fortress_dryad", position, 1, 2, "Seafortress.Dryad.Aggro", fv, false)
  queen:SetRenderColor(150, 180, 255)
  Events:AdjustBossPower(queen, 5, 5, false)
  queen.dominion = true
  return queen
end

function Seafortress:SpawnMountainBeast(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "sea_fortress_mountain_beast", position, 3, 5, nil, fv, true)
  queen:SetRenderColor(150, 180, 255)
  Events:AdjustBossPower(queen, 10, 10, false)
  queen.dominion = true
  queen.reduc = 0.65
  return queen
end

function Seafortress:SpawnGroveBlossom(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "sea_fortress_grove_blossom", position, 0, 2, nil, fv, true)
  queen:SetRenderColor(100, 120, 255)
  queen.dominion = true
  CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser_b.vpcf", queen, 2)
  return queen
end

function Seafortress:SpawnBehindMountainArea()
  Seafortress:SpawnConstruct(Vector(-14336, -15021), Vector(1,0))
  Seafortress:SpawnConstruct(Vector(-14789, -15021), Vector(1,0))
  Seafortress:SpawnConstruct(Vector(-14399, -13957), Vector(1,-0.2))
  Seafortress:SpawnConstruct(Vector(-15074, -13583), Vector(1,0))

  Seafortress:SpawnDeepEarthenWarrior(Vector(-15408, -14400), Vector(1,0))

  Timers:CreateTimer(4, function()
    Seafortress:SpawnSeaQueen(Vector(-15488, -11904), Vector(0,-1))
    Seafortress:SpawnSeaQueen(Vector(-15245, -11312), Vector(-0.2,-1))
    Seafortress:SpawnSeaQueen(Vector(-14956, -10972), Vector(-0.6,-1))
    Seafortress:SpawnSeaQueen(Vector(-114344, -10522), Vector(-1,0))
  end)

  Timers:CreateTimer(5, function()
    local positionTable = {Vector(-14272, -10804), Vector(-15306, -10624), Vector(-15615, -11144), Vector(-14812, -11474), Vector(-15744, -11712), Vector(-12224, -11701), Vector(-12416, -11456), Vector(-12608, -11701)}
    for i = 1, #positionTable, 1 do
      local staff = CreateUnitByName("seafortress_torment_staff", positionTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
      staff:SetForwardVector(RandomVector(1))
      staff:SetAbsOrigin(staff:GetAbsOrigin()-Vector(0,0,40))
    end
    Seafortress:SpawnSeaPortal(Vector(-16064, -11584), Vector(1,-0.2))
  end)

  Timers:CreateTimer(8, function()
    Seafortress:SpawnBarnacleBehemoth(Vector(-12480, -10304), Vector(-1,0))
    Seafortress:SpawnBarnacleBehemoth(Vector(-12992, -10618), Vector(-1,0))
    Seafortress:SpawnBarnacleBehemoth(Vector(-12482, -11019), Vector(-1,0))

    Seafortress:SpawnVenomousDragonfly(Vector(-11584, -10240), Vector(-1,0))
    Seafortress:SpawnVenomousDragonfly(Vector(-11840, -11648), Vector(-1,0))
  end)

  Timers:CreateTimer(2, function()
    Seafortress:SpawnCarnivore(Vector(-15616, -10624), Vector(1,0))
    Seafortress:SpawnCarnivore(Vector(-15744, -10240), Vector(1,-1))
    Seafortress:SpawnCarnivore(Vector(-15360, -9920), Vector(0,-1))
    Seafortress:SpawnCarnivore(Vector(-13609, -9920), Vector(-1,-1))
  end)
  Timers:CreateTimer(1.5, function()
    local positionTable = {Vector(-12864, -11648), Vector(-12864, -12288), Vector(-12621, -12148), Vector(-12067, -11200), Vector(-11854, -10688)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(-12800, -10752) - positionTable[i]):Normalized()
      Seafortress:SpawnCarnivore(positionTable[i], lookToPoint)
    end
  end)

  Timers:CreateTimer(10, function()
    Seafortress:SpawnSwampDragon(Vector(-11200, -10816), Vector(-1,0))
    Seafortress:SpawnSwampDragon(Vector(-10297, -11345), Vector(-1,0.5))
    Seafortress:SpawnSwampDragon(Vector(-10034, -10647), Vector(-1,-0.5))
    Seafortress:SpawnSwampDragon(Vector(-9249, -10496), Vector(-1,-0.2))

    Seafortress:SpawnCarnivore(Vector(-8192, -9984), Vector(-1,-0.5))
    Seafortress:SpawnCarnivore(Vector(-8640, -10176), Vector(-1,-0.5))
  end)
  Timers:CreateTimer(12, function()
    local positionTable = {Vector(-9024, -10368), Vector(-9728, -11008), Vector(-9152, -11520), Vector(-10370, -11400), Vector(-11264, -11328), Vector(-10880, -10368), Vector(-10203, -10571)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*0.8, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        local elemental = Seafortress:SpawnSwampUrsa(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 30, 5, 100, patrolPositionTable)
      end)
    end
  end)

  Timers:CreateTimer(0, function()
    EmitSoundOnLocationWithCaster(Vector(-7744, -9600), "Seafortress.Waterfall.Lite", Seafortress.Master)
    EmitSoundOnLocationWithCaster(Vector(-11046, -8331), "Seafortress.Waterfall.Lite", Seafortress.Master)
    return 24
  end)
end

function Seafortress:SpawnConstruct(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_dimensional_construct", position, 1, 3, "Seafortress.Construct.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 100, 255)
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetTargetCastArgs(queen, 800, 0, 1, FIND_ANY_ORDER)
  return queen
end


function Seafortress:SpawnDeepEarthenWarrior(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "sea_fortress_deep_earthen_warrior", position, 1, 3, "Seafortress.DeepEarth.Aggro", fv, false)
  queen:SetRenderColor(100, 100, 255)
  Events:ColorWearables(queen, Vector(100, 100, 255))
  Events:AdjustBossPower(queen, 8, 12, false)
  Seafortress:SetTargetCastArgs(queen, 1800, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnCarnivore(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("carnivorous_swamp_dweller", position, 1, 2, "Seafortress.Carnivore.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.25
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SpawnSwampDragon(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_swamp_dragon", position, 2, 3, "Seafortress.SwampDragon.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.25
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SpawnSwampUrsa(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_bear", position, 0, 1, "Seafortress.SwampUrsa.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.5
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.targetRadius = 420
  queen.autoAbilityCD = 1
  return queen
end

function Seafortress:SpawnSeafortressViper(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_viper", position, 0, 1, "Seafortress.Viper.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SwampTriggerSpawn()
  for i = 0, 8, 1 do
    local basePos = Vector(-10496, -9600)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  for i = 0, 8, 1 do
    local basePos = Vector(-10560, -9344)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  for i = 0, 2, 1 do
    local basePos = Vector(-10560, -8970)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  for i = 0, 1, 1 do
    local basePos = Vector(-10599, -8613)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  for i = 0, 2, 1 do
    local basePos = Vector(-10599, -8190)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  for i = 0, 3, 1 do
    local basePos = Vector(-8900, -9110)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  for i = 0, 3, 1 do
    local basePos = Vector(-8900, -8753)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  for i = 0, 3, 1 do
    local basePos = Vector(-8900, -8337)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  for i = 0, 6, 1 do
    local basePos = Vector(-10577, -7928)
    Seafortress:SpawnSeafortressViper(basePos+Vector(i*220, 0), Vector(0,-1))
  end
  Seafortress:SpawnSwampMedusa(Vector(-9536, -8576), Vector(0,-1))

  Timers:CreateTimer(8, function()
    local positionTable = {Vector(-10848, -6989), Vector(-10112, -7116), Vector(-9152, -7116), Vector(-7936, -7808), Vector(-8515, -6586)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        for j = 0, 1, 1 do
          Timers:CreateTimer(j*2, function()
            local elemental = Seafortress:SpawnSwampSnake(positionTable[i], RandomVector(1))
            Seafortress:AddPatrolArguments(elemental, 20, 3, 220, patrolPositionTable)
          end)
        end
      end)
    end

    local positionTable = {Vector(-8320, -7422), Vector(-7909, -6976), Vector(-9600, -6278), Vector(-10304, -6392)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        for j = 0, 1, 1 do
          Timers:CreateTimer(j*2, function()
            local elemental = Seafortress:SpawnSwampUrsa(positionTable[i], RandomVector(1))
            Seafortress:AddPatrolArguments(elemental, 20, 3, 220, patrolPositionTable)
          end)
        end
      end)
    end
  end)
  Timers:CreateTimer(16, function()
    Seafortress:SpawnSwampDragon(Vector(-10790, -7119), Vector(-1,0))
    Seafortress:SpawnSwampDragon(Vector(-8502, -6052), Vector(-1,-1))
    Seafortress:SpawnSwampDragon(Vector(-7552, -7472), Vector(1,0))
  end)
end

function Seafortress:SpawnSwampMedusa(position, fv)
  local lord = Seafortress:SpawnDungeonUnit("seafortress_swamp_lady", position, 2, 5, "Seafortress.SwampLady.Aggro", fv, false)
  Events:AdjustBossPower(lord, 10, 10, false)
  lord:SetRenderColor(120, 180, 255)
  lord.deathCode = 6
  lord.pushLock = true
  lord.jumpLock = true
  local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
  local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, lord)
  ParticleManager:SetParticleControl( particle1, 0, lord:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,140) )
  EmitSoundOn("Tanari.WaterSplash", lord)
  lord.reduc = 0.02
  Timers:CreateTimer(4, 
  function()
    ParticleManager:DestroyParticle( particle1, false )
  end)
end

function Seafortress:SpawnSwampSnake(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_swamp_snake", position, 1, 1, "Seafortress.Snake.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen

end

function Seafortress:SpawnSwampShadow(position, fv)
  local sapling = Seafortress:SpawnDungeonUnit("swamp_shadow", position, 1, 2, nil, fv, false)
  Events:AdjustBossPower(sapling, 10, 5)
  sapling:SetAbsOrigin(GetGroundPosition(position, sapling))
  local ability = sapling:FindAbilityByName("swamp_shadow_ability")
  ability:ApplyDataDrivenModifier(sapling, sapling, "modifier_thicket_growth_waiting", {})
  sapling:SetModelScale(0.01)
  sapling:AddNoDraw()
  sapling.dominion = true
  sapling.targetRadius = 1200
  sapling.autoAbilityCD = 1
  return sapling
end

function Seafortress:SwampTriggerSpawn2()
  for j = 1, 20, 1 do
    Timers:CreateTimer(j*0.2, function()
      local randomX = RandomInt(1, 2000)
      local randomY = RandomInt(1, 1750)
      Seafortress:SpawnSwampShadow(Vector(-13568, -8576)+Vector(randomX, randomY), RandomVector(1))
      if j%10 == 0 then
        local randomX = RandomInt(1, 2000)
        local randomY = RandomInt(1, 1750)
        local staff = CreateUnitByName("seafortress_torment_staff", Vector(-13568, -8576)+Vector(randomX, randomY), false, nil, nil, DOTA_TEAM_NEUTRALS)
        staff:SetForwardVector(RandomVector(1))
        staff:SetAbsOrigin(staff:GetAbsOrigin()-Vector(0,0,40))
      end
    end)
  end
  for i = 1, 8, 1 do
    Timers:CreateTimer(i*0.2, function()
      local randomX = RandomInt(1, 880)
      local randomY = RandomInt(1, 3000)
      Seafortress:SpawnSwampShadow(Vector(-12480, -9088)+Vector(randomX, randomY), RandomVector(1))
      if i%4==0 then
        local randomX = RandomInt(1, 2000)
        local randomY = RandomInt(1, 1750)
        local staff = CreateUnitByName("seafortress_torment_staff", Vector(-13568, -8576)+Vector(randomX, randomY), false, nil, nil, DOTA_TEAM_NEUTRALS)
        staff:SetForwardVector(RandomVector(1))
        staff:SetAbsOrigin(staff:GetAbsOrigin()-Vector(0,0,40))
      end
    end)
  end
  Timers:CreateTimer(3, function()
    local positionTable = {}
    for j = 1, 16, 1 do
      local randomX = RandomInt(1, 880)
      local randomY = RandomInt(1, 3000)
      table.insert(positionTable, Vector(-12480, -9088)+Vector(randomX, randomY))
    end
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*0.6, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end

        local elemental = Seafortress:SpawnSeafortressViper(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 20, 3, 220, patrolPositionTable)

      end)
    end
  end)
  Timers:CreateTimer(8, function()
    Seafortress:SpawnCarnivore(Vector(-11968, -8640), Vector(-0.5,1))
    Seafortress:SpawnCarnivore(Vector(-12352, -8886), Vector(0,1))
    Seafortress:SpawnSwampSnake(Vector(-12544, -6320), Vector(1,0))
    Seafortress:SpawnSwampSnake(Vector(-12878, -6513), Vector(1,-1))
    Seafortress:SpawnVenomousDragonfly(Vector(-13888, -8384), Vector(1,0))
    Seafortress:SpawnVenomousDragonfly(Vector(-13568, -6912), Vector(1,0))
  end)
  Timers:CreateTimer(10, function()
    Seafortress:SpawnSeaPortal(Vector(-15808, -8640), Vector(1,0))
    Seafortress:SpawnSeaPortal(Vector(-15808, -7616), Vector(1,0))
  end)
end

function Seafortress:SpawnSeaLadySummoner(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("water_temple_sea_lady_summoner", position, 1, 1, nil, fv, true)
  queen:SetRenderColor(160, 255, 100)
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen

end

function Seafortress:SpawnSeaFortressRevenant(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_revenant", position, 1, 1, nil, fv, true)
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.05
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen

end

function Seafortress:SpawnCanyonRoom()
  
  Seafortress:SpawnSeaFortressHydra(Vector(-14976, -5345, -52+Seafortress.ZFLOAT), Vector(1,0))
  Seafortress:SpawnSeaFortressHydra(Vector(-15185, -4593, -52+Seafortress.ZFLOAT), Vector(1,0))
  Seafortress:SpawnSeaFortressHydra(Vector(-13743, -5072, -52+Seafortress.ZFLOAT), Vector(-1,0))
  Seafortress:SpawnSeaFortressHydra(Vector(-13077, -4672, -52+Seafortress.ZFLOAT), Vector(-1,0))

  Seafortress:SpawnSeaFortressHydra(Vector(-14965, -3583, -52+Seafortress.ZFLOAT), Vector(-1,-1))
  Seafortress:SpawnSeaFortressHydra(Vector(-14400, -3136, -52+Seafortress.ZFLOAT), Vector(0,-1))
  Timers:CreateTimer(4, function()
    Seafortress:SpawnSeaFortressHydra(Vector(-11200, -3392, -52+Seafortress.ZFLOAT), Vector(1,0))
    Seafortress:SpawnSeaFortressHydra(Vector(-11032, -3904, -52+Seafortress.ZFLOAT), Vector(1,0))
    Seafortress:SpawnSeaFortressHydra(Vector(-11328, -4348, -52+Seafortress.ZFLOAT), Vector(-1,0))
    Seafortress:SpawnSeaFortressHydra(Vector(-11937, -4132, -52+Seafortress.ZFLOAT), Vector(-1,0))

    Seafortress:SpawnSeaFortressHydra(Vector(-12288, -3648, -52+Seafortress.ZFLOAT), Vector(-1,-1))
    Seafortress:SpawnSeaFortressHydra(Vector(-12422, -3239, -52+Seafortress.ZFLOAT), Vector(0,-1))
  end)
  Timers:CreateTimer(0, function()
    Seafortress:SpawnMantaRider(Vector(-14848, -6016), Vector(1,-1))
    Seafortress:SpawnMantaRider(Vector(-13819, -5768), Vector(-1,-1))
    Seafortress:SpawnMantaRider(Vector(-14656, -4544), Vector(1,-0.5))
    Seafortress:SpawnMantaRider(Vector(-13888, -3712), Vector(-1,-1))
  end)
  Timers:CreateTimer(5, function()
    local positionTable = {Vector(-14016, -3840), Vector(-15417, -2950), Vector(-13802, -2836), Vector(-15449, -3975)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        for j = 0, 1, 1 do
          Timers:CreateTimer(j*2, function()
            local elemental = Seafortress:SpawnSwampSnake(positionTable[i], RandomVector(1))
            Seafortress:AddPatrolArguments(elemental, 20, 6, 220, patrolPositionTable)
          end)
        end
      end)
    end
  end)

  Timers:CreateTimer(7, function()
    Seafortress:SpawnSeaFortressLizard(Vector(-13184, -3968), Vector(-1,1))
    Seafortress:SpawnSeaFortressLizard(Vector(-13696, -3200), Vector(0,-1))
    Seafortress:SpawnSeaFortressLizard(Vector(-13312, -2816), Vector(-0.2,-1))
    Seafortress:SpawnMantaRider(Vector(-12800, -2752), Vector(-1,-1))
    Seafortress:SpawnSeaFortressLizard(Vector(-12416, -5120), Vector(-0.3,1))
  end)

  Timers:CreateTimer(10, function()
    local positionTable = {Vector(-11520, -4992), Vector(-12800, -4288), Vector(-12992, -2880), Vector(-11008, -2688), Vector(-10240, -4224)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        for j = 0, 1, 1 do
          Timers:CreateTimer(j*2, function()
            local elemental = Seafortress:SpawnSwampUrsa(positionTable[i], RandomVector(1))
            Seafortress:AddPatrolArguments(elemental, 20, 4, 220, patrolPositionTable)
          end)
        end
      end)
    end
  end)
  Timers:CreateTimer(11, function()
    Seafortress:SpawnMantaRider(Vector(-11982, -4760), Vector(-1,1))
    Seafortress:SpawnSeaFortressLizard(Vector(-11136, -2872), Vector(-1,1))
    Seafortress:SpawnSeaFortressLizard(Vector(-11008, -2496), Vector(-1,0))
    local positionTable = {Vector(-12672, -2496), Vector(-10496, -4928), Vector(-10496, -3469)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        local elemental = Seafortress:SpawnMantaRider(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 20, 4, 220, patrolPositionTable)
      end)
    end
    Seafortress:SpawnSeaFortressLizard(Vector(-10048, -3328), Vector(-1,0))
    Seafortress:SpawnSeaFortressLizard(Vector(-10240, -2816), Vector(-1,0.1))
  end)
  Timers:CreateTimer(13, function()
    Seafortress:SpawnSeaFortressHydra(Vector(-9408, -5056), Vector(0,1))
    Seafortress:SpawnSeaFortressHydra(Vector(-9024, -5056), Vector(0,1))
    Seafortress:SpawnSeaFortressHydra(Vector(-8640, -5056), Vector(0,1))
  end)
  Timers:CreateTimer(14, function()
    Seafortress:SpawnCarnivore(Vector(-10110, -3210), Vector(-1,0))
    Seafortress:SpawnCarnivore(Vector(-9936, -3520), Vector(-1,0))
    Seafortress:SpawnCarnivore(Vector(-9856, -3819), Vector(-1,0))

    Seafortress:SpawnSeaFortressTempleExiler(Vector(-8320, -3968), Vector(0,-1))
    Seafortress:SpawnSeaFortressTempleExiler(Vector(-7936, -3968), Vector(0,-1))
  end)
  Timers:CreateTimer(16, function()
    Seafortress:SpawnSeaFortressLizard(Vector(-7924, -4576), Vector(-1,1))
    Seafortress:SpawnSeaFortressLizard(Vector(-8079, -4888), Vector(0,1))
  end)
end

function Seafortress:SpawnSeaFortressHydra(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_hydra", position, 1, 1, "Seafortress.HydraAggro", fv, false)
  queen:SetRenderColor(160, 255, 100)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetAbsOrigin(position)
  queen.pushLock = true
  queen.jumpLock = true
  queen.dominion = true
  return queen

end

function Seafortress:SpawnMantaRider(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_manta_rider", position, 1, 1, "Seafortress.MantaRider.Aggro", fv, false)
  queen:SetRenderColor(160, 255, 100)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetAbsOrigin(position)
  Timers:CreateTimer(0.2, function()
    queen:MoveToPosition(position+queen:GetForwardVector()*3)
  end)
  Seafortress:SetPositionCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
  queen.dominion = true
  return queen
end

function Seafortress:SpawnSeaFortressLizard(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_canyon_lizard", position, 1, 2, "Seafortress.Lizard.Aggro", fv, false)
  queen:SetRenderColor(140, 180, 255)
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  return queen
end

function Seafortress:SpawnSeaFortressTempleExiler(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_temple_exiler", position, 2, 4, "Seafortress.Exiler.Aggro", fv, false)
  queen:SetRenderColor(50, 180, 255)
  Events:ColorWearables(queen, Vector(50, 180, 255))
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.reduc = 0.03
  return queen
end

function Seafortress:SpawnSeaFortressLizard(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_canyon_lizard", position, 1, 2, "Seafortress.Lizard.Aggro", fv, false)
  queen:SetRenderColor(140, 180, 255)
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  return queen
end

function Seafortress:SpawnNagaSamurai(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("water_temple_naga_samurai", position, 1, 2, "Seafortress.NagaSamuari.Aggro", fv, false)
  queen:SetRenderColor(80, 140, 255)
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.dominion = true
  return queen
end


function Seafortress:SpawnSeaTemple()
  local positionTable = {Vector(-8320, -2688), Vector(-8320, -2368), Vector(-8320, -2048), Vector(-8320, -1728), Vector(-8320, -1344)}
  for i = 1, #positionTable, 1 do
    Seafortress:SpawnNagaSamurai(positionTable[i], Vector(0,-1))
  end
  Timers:CreateTimer(1, function()
    Seafortress:SpawnSeaFortressHydra(Vector(-8640, -1344), Vector(-1,0))
    Seafortress:SpawnSeaFortressHydra(Vector(-9024, -128), Vector(1,-1))

    Seafortress:SpawnFrostMage(Vector(-8448, -704), Vector(0,-1))
    Seafortress:SpawnFrostMage(Vector(-8192, -704), Vector(0,-1))
    Seafortress:SpawnFrostMage(Vector(-8448, -384), Vector(0,-1))
    Seafortress:SpawnFrostMage(Vector(-8192, -384), Vector(0,-1))
  end)

  Timers:CreateTimer(4, function()
    local positionTable = {Vector(-8320, 192), Vector(-8320, 512), Vector(-8320, 832), Vector(-8320, 1344), Vector(-8320, 1600)}
    for i = 1, #positionTable, 1 do
      Seafortress:SpawnNagaSamurai(positionTable[i], Vector(0,-1))
    end
    Seafortress:SpawnFrostMage(Vector(-8436, 1088), Vector(0,-1))
    Seafortress:SpawnFrostMage(Vector(-8256, 1088), Vector(0,-1))
    Seafortress:SpawnSeaFortressHydra(Vector(-9984, 920), Vector(0,-1))
  end)
  Timers:CreateTimer(5, function()
    Seafortress:SpawnNagaProtector(Vector(-9376, -512), Vector(1,0))
    Seafortress:SpawnNagaProtector(Vector(-9792, -512), Vector(1,0))
    Seafortress:SpawnNagaProtector(Vector(-9792, -192), Vector(0,-1))
    Seafortress:SpawnNagaProtector(Vector(-9792, 170), Vector(0,-1))

    Seafortress:SpawnNagaProtector(Vector(-8768, 1856), Vector(1,-0.2))
  end)
  Timers:CreateTimer(6, function()
    local ursa = Seafortress:SpawnUrsan(Vector(-9216, 2048), Vector(1,0))
    ursa.deathCode = 7
  end)
end

function Seafortress:SpawnFrostMage(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("water_temple_naga_frost_mage", position, 1, 2, "Seafortress.NagaFrostMage.Aggro", fv, false)
  queen:SetRenderColor(80, 140, 255)
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.dominion = true
  Seafortress:SetPositionCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnNagaProtector(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("water_temple_naga_protector", position, 1, 2, "Seafortress.NagaProtector.Aggro", fv, false)
  queen:SetRenderColor(255, 140, 140)
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.dominion = true
  queen.reduc = 0.4
  local ability = queen:FindAbilityByName("creature_stormshield")
  ability:ApplyDataDrivenModifier(queen, queen, "modifier_stormshield_cloak", {})
  return queen
end

function Seafortress:SpawnUrsan(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_primeval_ursan", position, 2, 3, "Seafortress.Ursan.Aggro", fv, false)
  -- queen:SetRenderColor(255, 140, 140)
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.targetRadius = 520
  queen.autoAbilityCD = 1
  queen.reduc = 0.25
  -- queen.dominion = true
  return queen
end

function Seafortress:SpawnAfterTempleRoom()
  for i = 1, 10, 1 do
    local unit = nil
    local position = Vector(-11072, 640)
    local fv = Vector(1,0)
    local goToPos = Vector(-9330, 2074)
    if i <= 4 then
      unit = Seafortress:SpawnFrostMage(position, fv)
    elseif i <= 7 then
      unit = Seafortress:SpawnNagaProtector(position, fv)
    else
      unit = Seafortress:SpawnNagaSamurai(position, fv)
    end
    Timers:CreateTimer(0.2, function()
      unit:MoveToPositionAggressive(goToPos)
    end)
  end
  Timers:CreateTimer(1, function()
    Seafortress.LaserMechTable = {}
    local pos1 = Vector(-14800, 1241, 247+Seafortress.ZFLOAT)
    local pos2 = Vector(-13376, 1632, 247+Seafortress.ZFLOAT)
    local pos3 = Vector(-12618, 943, 247+Seafortress.ZFLOAT)
    local pos4 = Vector(-13567, 80, 247+Seafortress.ZFLOAT)
    local pos5 = Vector(-14626, -519, 247+Seafortress.ZFLOAT)
    local pos6 = Vector(-15304, -1202, 247+Seafortress.ZFLOAT)
    local pos7 = Vector(-11992, -346, 247+Seafortress.ZFLOAT)
    local posTable = {pos1, pos2, pos3, pos4, pos5, pos6, pos7}
    for i = 1, #posTable, 1 do
      local maxDistance = WallPhysics:GetDistance2d(pos7, Vector(-11478, -723))
      if i < #posTable then
        maxDistance = WallPhysics:GetDistance2d(posTable[i], posTable[i+1])+40
      end
      local mech = Seafortress:SpawnLaserMechanism(posTable[i], 0, 360, maxDistance)
      if i == #posTable then
        mech.lastOne = true
      end
      table.insert(Seafortress.LaserMechTable, mech)
    end
  end)
  Timers:CreateTimer(2, function()
    local positionTable = {Vector(-12224, 1088, -190+Seafortress.ZFLOAT), Vector(-15424, -192, -190+Seafortress.ZFLOAT), Vector(-15104, 512, -190), Vector(-14908, 1535, -190+Seafortress.ZFLOAT), Vector(-14138, -704+RandomInt(0, 330), -190+Seafortress.ZFLOAT), Vector(-13700, -704+RandomInt(0, 330), -190+Seafortress.ZFLOAT)}
    for i = 1, #positionTable, 1 do
      Seafortress:SpawnWaterDusa(positionTable[i], Vector(1,0))
    end
  end)
  Timers:CreateTimer(3, function()
    local basePos = Vector(-13824, 576)
    for i = 0, 3, 1 do
      for j = 0, 2, 1 do
        Seafortress:SpawnSlithereenElite(basePos+Vector(240*i, 300*j), Vector(1,0))
      end
    end
  end)
  Timers:CreateTimer(4, function()
    local positionTable = {Vector(-12840, 3), Vector(-12084, -704), Vector(-14848, -1024), Vector(-14592, 512), Vector(-13568, 1728)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        local elemental = Seafortress:SpawnFrostMage(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 20, 5, 220, patrolPositionTable)
        local elemental = Seafortress:SpawnNagaProtector(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 20, 5, 220, patrolPositionTable)
        local elemental = Seafortress:SpawnNagaSamurai(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 20, 5, 220, patrolPositionTable)
      end)
    end
  end)
  Timers:CreateTimer(6, function()
    Seafortress:SpawnSeaPortal(Vector(-14336, -1408), Vector(0,1))
    Seafortress:SpawnSeaPortal(Vector(-14000, -1408), Vector(0,1))
    Seafortress:SpawnSeaPortal(Vector(-13632, -1408), Vector(0,1))
    local luck = RandomInt(1, 2)
    if luck == 1 then
      Seafortress:SpawnBarnacleBehemoth(Vector(-14462, 665), Vector(1,0))
    else
      Seafortress:SpawnBarnacleBehemoth(Vector(-13184, -512), Vector(1,1))
    end
  end)
end

function Seafortress:SpawnLaserMechanism(position, rangeMin, rangeMax, maxDistance)
    local shield = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    local yaw = 0
    if rangeMax > rangeMin then
      yaw = math.floor(RandomInt(rangeMin, rangeMax)/15)*15
    else
      local yawzip = RandomInt(rangeMax, 360+rangeMin)
      if yawzip > 360 then
        yawzip = yawzip - 360
      end
      yaw = math.floor(yawzip/15)*15
    end

    shield:SetAngles(0, yaw, 0)
    shield:SetRenderColor(36, 44, 77)
    shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    shield:SetOriginalModel("models/sea_fortress/aqua_mechanism.vmdl")
    shield:SetModel("models/sea_fortress/aqua_mechanism.vmdl")
    shield:SetAbsOrigin(position)
    shield:AddAbility("seafortress_attackable_prop_ability"):SetLevel(1)
    shield:RemoveAbility("dummy_unit")
    shield:RemoveModifierByName("dummy_unit")
    shield.basePosition = position
    shield.jumpLock = true
    shield.rangeMin = rangeMin
    shield.rangeMax = rangeMax
    shield.yaw = yaw
    shield.clockwise = true
    shield.maxDistance = maxDistance
    shield.waterMech = true
    shield.pushLock = true
    shield.dummy = true
    AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 500, 99999, false)

    return shield
end

function Seafortress:smoothColorTransition(object, startColor, endColor, ticks)
  local colorChangeVector = (endColor-startColor)/ticks
  for i = 0, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      object:SetRenderColor(startColor.x + colorChangeVector.x * i, startColor.y + colorChangeVector.y * i, startColor.z + colorChangeVector.z * i)
    end)
  end
end

function Seafortress:smoothSizeChange(object, startSize, endSize, ticks)
  local growth = (endSize-startSize)/ticks
  for i = 0, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      object:SetModelScale(startSize + growth*i)
    end)
  end
end

function Seafortress:objectShake(object, ticks, strength, bX, bY, bZ, sound, soundInterval)
  for i = 1, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      local magnitudeX = 0
      local magnitudeY = 0
      local magnitudeZ = 0
      if bX then
        magnitudeX = strength
      end
      if bY then
        magnitudeY = strength
      end
      if bZ then
        magnitudeZ = strength
      end
      local moveVector = Vector(magnitudeX, magnitudeY, magnitudeZ)
      if i%2 == 0 then
        moveVector = moveVector*-1
      end
      if sound then
        if i%soundInterval == 0 then
          EmitSoundOnLocationWithCaster(object:GetAbsOrigin(), sound, Events.GameMaster)
        end
      end
      object:SetAbsOrigin(object:GetAbsOrigin()+moveVector)
    end)
  end
end

function Seafortress:activateLaserMech(mech)
  Seafortress:smoothColorTransition(mech, Vector(36, 44, 77), Vector(70,70,255), 30)
  local ability = mech:FindAbilityByName("seafortress_attackable_prop_ability")
  mech.lock = true
  EmitSoundOn("Seafortress.LaserMech.Activate", mech)
  Timers:CreateTimer(0.9, function()
    if Seafortress.switchClock then
      ability:ApplyDataDrivenModifier(mech, mech, "modifier_laser_mechanism_active", {})
    end
  end)
end

function Seafortress.deactivateLaserMech(mech)
  if mech:HasModifier("modifier_laser_mechanism_active") then
    Seafortress:smoothColorTransition(mech, Vector(70, 70, 255), Vector(36, 44, 77), 30)
    mech:RemoveModifierByName("modifier_laser_mechanism_active")
    EmitSoundOn("Seafortress.LaserMech.Deactivate", mech)
    if mech.laser then
      ParticleManager:DestroyParticle(mech.laser, false)
      ParticleManager:ReleaseParticleIndex(mech.laser)
      mech.laser = false
      mech.laserPos = false
      
    end

  end
  mech.lock = false

end

function Seafortress:SpawnWaterDusa(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "seafortress_water_huntress", position, 1, 1, "Seafortress.WaterDusa.Aggro", fv, false)
  queen:SetRenderColor(140, 170, 250)
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.reduc = 0.5
  queen:SetAbsOrigin(position)
  queen.pushLock = true
  queen.jumpLock = true
  queen.dominion = true
  -- queen.dominion = true
  return queen
end

function Seafortress:SpawnSlithereenElite(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("elite_ocean_warrior", position, 1, 2, "Seafortress.SlithElite.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 255, 140)
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetTargetCastArgs(queen, 400, 0, 1, FIND_ANY_ORDER)
  queen.castAnimation = ACT_DOTA_CAST_ABILITY_4
  return queen

end

function Seafortress:SpawnLordZarkhaz(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_ocean_lord_zarkhaz", position, 1, 2, "Seafortress.Zharkhaz.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 165, 255)
  Events:ColorWearables(queen, Vector(100, 165, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.01
  return queen

end

function Seafortress:ActivateLaserCrystal(position)
  local crystal = Entities:FindByNameNearest("LaserCrystal", position, 900)
  EmitSoundOnLocationWithCaster(crystal:GetAbsOrigin(), "Seafortress.CrystalActivate", Events.GameMaster)
  Seafortress:smoothColorTransition(crystal, Vector(0,0,255), Vector(255, 255, 255), 30)
  for j = 1, 330, 1 do
    Timers:CreateTimer(j*0.03, function()
      local yaw = (j*10)%360
      crystal:SetAngles(yaw, yaw, 0)
    end)
  end
  Timers:CreateTimer(1.4, function()
    local dummy = CreateUnitByName("npc_dummy_unit", position, true, nil, nil, DOTA_TEAM_BADGUYS)
    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    StartSoundEvent("Seafortress.CrystalLoop", dummy)
    Timers:CreateTimer(8.5, function()
      StopSoundEvent("Seafortress.CrystalLoop", dummy)
      UTIL_Remove(dummy)
    end)
  end)
  Timers:CreateTimer(8, function()
    Seafortress:objectShake(crystal, 63, 13, true, true, false, "Seafortress.CrystalShake", 10)
  end)
  Timers:CreateTimer(9.95, function()
    local crystalPos = crystal:GetAbsOrigin()
    UTIL_Remove(crystal)
    EmitSoundOnLocationWithCaster(crystalPos, "Seafortress.CrystalShatter", Events.GameMaster)
    CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_medusa/ice_shatter.vpcf", crystalPos, 5)
    local boss = Seafortress:SpawnLordZarkhaz(crystalPos, Vector(-1,0))
    boss.deathCode = 8
    boss:SetModelScale(0.05)
    Seafortress:smoothSizeChange(boss, 0.05, 3, 60)
    Timers:CreateTimer(1.8, function()
      EmitSoundOn("Seafortress.Zharkhaz.Spawn", boss)
    end)
    Timers:CreateTimer(1.3, function()
      StartAnimation(boss, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.7})
    end)

    for i = 1, 5, 1 do
      Timers:CreateTimer(i*0.36, function()
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", boss, 3)
        EmitSoundOn("Seafortress.KhalzonSpawning", boss)
      end)
    end
  end)
end



function Seafortress:SpawnFirstCaveRoom()
  Timers:CreateTimer(0.5, function()
    local positionTable = {Vector(4544, -9547), Vector(4947, -9919), Vector(5124, -10432), Vector(5349, -10904), Vector(5730, -11342), Vector(6208, -15040)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(3980, -9152) - positionTable[i]):Normalized()
      Seafortress:SpawnGhostPirate(positionTable[i], lookToPoint)
    end
  end)
  Timers:CreateTimer(1, function()
    local positionTable = {Vector(5376, -9600), Vector(5056, -9408), Vector(5696, -9408), Vector(5056, -9024), Vector(4480, -8896), Vector(4800, -8832), Vector(5120, -8704), Vector(5376, -8896), Vector(5440, -8640), Vector(5696, -8960), Vector(4096, -10112), Vector(4480, -10112), Vector(4096, -10432), Vector(4480, -10432)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(3980, -9152) - positionTable[i]):Normalized()
      Seafortress:SpawnConstruct2(positionTable[i], lookToPoint)
    end
  end)
  Timers:CreateTimer(1.5, function()
    local positionTable = {Vector(4352, -11200), Vector(4736, -11520)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(4607, -10893) - positionTable[i]):Normalized()
      Seafortress:SpawnSeaPortal(positionTable[i], lookToPoint)
    end
    Seafortress:SpawnBarnacleBehemoth(Vector(5632, -12079), Vector(1,0.3))
    Seafortress:SpawnBarnacleBehemoth(Vector(6208, -12224), Vector(-0.2,1))
  end)
  Seafortress:SpawnDeepShadowWeaver(Vector(6144, -8320), Vector(-1,-1))
  Timers:CreateTimer(2.5, function()
    Seafortress:SpawnBarnacleBehemoth(Vector(5308, -14976), Vector(0,-1))
    Seafortress:SpawnBarnacleBehemoth(Vector(6099, -15552), Vector(0,1))

    for i = 0, 4, 1 do
      Seafortress:SpawnOceanDeathArcher(Vector(5824, -14336+(i*384)), Vector(0,1))
    end
    for i = 0, 4, 1 do
      Seafortress:SpawnOceanDeathArcher(Vector(6400, -14336+(i*384)), Vector(0,1))
    end
  end)
  Timers:CreateTimer(3.5, function()
    for i = 0, 2, 1 do
      Seafortress:SpawnOceanDeathArcher(Vector(5348, -13888+(i*500)), Vector(0,-1))
    end
    Seafortress:SpawnOceanWatcher(Vector(4864, -12608), Vector(-1,-1))
  end)
end

function Seafortress:SpawnOceanWatcher(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_ocean_watcher", position, 2, 3, "Seafortress.OceanWatcher.Aggro", fv, false)
  queen:SetRenderColor(100, 255, 195)
  Events:ColorWearables(queen, Vector(100, 255, 195))
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.targetRadius = 720
  queen.autoAbilityCD = 1
  queen.reduc = 0.25
  -- queen.dominion = true
  return queen
end

function Seafortress:SpawnGhostPirate(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_ghost_pirate", position, 1, 2, "Seafortress.GhostPirate.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 165, 255)
  Events:ColorWearables(queen, Vector(100, 165, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.4
  Seafortress:SetTargetCastArgs(queen, 800, 0, 1, FIND_ANY_ORDER)
  queen.dominion = true
  return queen

end

function Seafortress:SpawnConstruct2(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_deep_sea_construct", position, 1, 1, "Seafortress.Construct.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 100, 255)
  Events:ColorWearables(queen, Vector(100, 100, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 2
  queen.dominion = true
  return queen
end

function Seafortress:SpawnDeepShadowWeaver(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_deep_shadow_weaver", position, 2, 4, "Seafortress.DeepShadow.Aggro", fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.4
  queen.deathCode = 9
  return queen
end

function Seafortress:SpawnOceanDeathArcher(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("deep_ocean_death_archer", position, 1, 1, "Seafortress.DeathArcher.Die", fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.dominion = true
  return queen
end

function Seafortress:SpawnCavernSummoner(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_cavern_summoner", position, 1, 1, "Seafortress.CavernSummoner.Aggro", fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.maxSummons = 8
  queen.targetRadius = 720
  queen.autoAbilityCD = 1
  queen.reduc = 0.2
  queen.dominion = true
  return queen
end

function Seafortress:SpawnSummonedArcher(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("serengaard_siege_archer", position, 0, 0, nil, fv, false)
  queen:SetRenderColor(100, 255, 255)
  
  return queen
end

function Seafortress:SpawnSeaRider(position, fv, aggroSound)
  local queen = Seafortress:SpawnDungeonUnit("deep_sea_rider", position, 2, 4, aggroSound, fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.04
  return queen
end



function Seafortress:SpawnSecondCaveRoom()
  for i = 1, 8, 1 do
    local position = Vector(7232, -11776)+Vector(RandomInt(1, 1400), RandomInt(1, 520))
    Seafortress:SpawnCavernSummoner(position, Vector(-1,0))
  end

  Timers:CreateTimer(0.5, function()
    local positionTable = {Vector(10048, -11456), Vector(10368, -12160), Vector(9664, -12672), Vector(10560, -13504), Vector(9984, -14208), Vector(10688, -14592)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(9472, -11648) - positionTable[i]):Normalized()
      Seafortress:SpawnGhostPirate(positionTable[i], lookToPoint)
    end
  end)

  Timers:CreateTimer(2, function()
    for i = 0, 2, 1 do
      Seafortress:SpawnOceanDeathArcher(Vector(8896+(i*160), -13760), Vector(1,0.3))
    end
    for i = 0, 2, 1 do
      Seafortress:SpawnOceanDeathArcher(Vector(8896+(i*160), -13376), Vector(1,0.3))
    end
    for j = 0, 2, 1 do
      for i = 0, 1 do
        Seafortress:SpawnOceanDeathArcher(Vector(9664+(i*160), -14720+(j*160)), Vector(0.2,1))
      end
    end
  end)

  Timers:CreateTimer(3, function()
    local positionTable = {Vector(7552, -15424), Vector(9792, -15141), Vector(10432, -13969), Vector(9752, -12096), Vector(10345, -10280), Vector(8328, -8884)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        for j = 0, 1, 1 do
          local elemental = Seafortress:SpawnCavernSummoner(positionTable[i], RandomVector(1))
          Seafortress:AddPatrolArguments(elemental, 20, 4, 220, patrolPositionTable)
        end
      end)
    end
  end)

  Timers:CreateTimer(4, function()
    local positionTable = {Vector(10240, -11418), Vector(10774, -11613), Vector(10560, -11208)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(9472, -11612) - positionTable[i]):Normalized()
      Seafortress:SpawnSlithereenElite(positionTable[i], lookToPoint)
    end
  end)
  Timers:CreateTimer(5, function()
    Seafortress:SpawnSeaRider(Vector(8192,-8704), Vector(0,-1), "Seafortress.Rider.Aggro1")
    Seafortress:SpawnSeaRider(Vector(7808,-15488), Vector(1,0), "Seafortress.Rider.Aggro2")
  end)
  Timers:CreateTimer(1.2, function()
    local positionTable = {}
    for k = 1, 5, 1 do
      local newVector = Vector(7104+RandomInt(0, 2650), -10816+RandomInt(0, 1300))
      table.insert(positionTable, newVector)
    end
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end

        local elemental = Seafortress:SpawnWaterSpiritBeetle(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 20, 2, 220, patrolPositionTable)

      end)
    end
  end)

  Timers:CreateTimer(1.6, function()
    local positionTable = {}
    for k = 1, 5, 1 do
      local newVector = Vector(7168+RandomInt(0, 1200), -14528+RandomInt(0, 2300))
      table.insert(positionTable, newVector)
    end
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end

        local elemental = Seafortress:SpawnWaterSpiritBeetle(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 20, 2, 220, patrolPositionTable)

      end)
    end
  end)
  Seafortress:SpawnDeepShadowWeaver(Vector(10560, -15514), Vector(-1,1))
  Timers:CreateTimer(5.4, function()
    Seafortress:SpawnBarnacleBehemoth(Vector(8768, -14973), Vector(1,0))
    Seafortress:SpawnBarnacleBehemoth(Vector(9154, -15616), Vector(0.5,1))
    Seafortress:SpawnGhostPirate(Vector(8927, -15360), Vector(1,0))
    Seafortress:SpawnGhostPirate(Vector(9088, -15104), Vector(1,0))
    Seafortress:SpawnSeaQueen(Vector(9856, -15296), RandomVector(1))
    Seafortress:SpawnBarnacleBehemoth(Vector(9088, -9344), Vector(0,-1))
  end)
end

function Seafortress:SpawnWaterSpiritBeetle(position, fv)
  local mage = Seafortress:SpawnDungeonUnit("water_shadow_hunter", position, 0, 3, "Seafortress.Beetle.Aggro", fv, false)

  Events:AdjustBossPower(mage, 5, 5, false)
  mage.dominion = true
  -- Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
  -- Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_blue", {})
  Events:SetPositionCastArgs(mage, 600, 0, 1, FIND_ANY_ORDER)
  return mage
end

function Seafortress:SpawnJailer(position, fv)
  local mage = Seafortress:SpawnDungeonUnit("seafortress_jailer", position, 0, 3, nil, fv, true)
  mage:SetRenderColor(40, 190, 255)
  Events:AdjustBossPower(mage, 10, 10, false)
  mage.patrolImmunity = true
  table.insert(Seafortress.jailerTable, mage)
  mage.ability1 = mage:FindAbilityByName("chef_meat_hook")
  mage.ability1:SetLevel(1)
  return mage
end

function Seafortress:SpawnJailRoom()
   Seafortress.jailerTable = {}
   local pudge1 = Seafortress:SpawnJailer(Vector(12352, -15509), Vector(0,1))
   Timers:CreateTimer(0, function()
      Seafortress:AddPatrolArguments(pudge1, 1, 3, 320, {Vector(13302, -14583), Vector(12352, -15509)})
   end)

   local pudge2 = Seafortress:SpawnJailer(Vector(13888, -13855), Vector(0,1))
   Timers:CreateTimer(0.6, function()
      Seafortress:AddPatrolArguments(pudge2, 1, 3, 320, {Vector(13888, -15104), Vector(13888, -13855)})
   end)

   local pudge3 = Seafortress:SpawnJailer(Vector(13184, -12631), Vector(0,-1))
   Timers:CreateTimer(3, function()
      Seafortress:AddPatrolArguments(pudge3, 1, 3, 320, {Vector(12725, -13421), Vector(13184, -12631)})
   end)

   local pudge4 = Seafortress:SpawnJailer(Vector(13952, -13067), Vector(0,-1))
   Timers:CreateTimer(3.0, function()
      Seafortress:AddPatrolArguments(pudge4, 1, 3, 320, {Vector(13488, -11840), Vector(13952, -13067)})
   end)

   local pudge5 = Seafortress:SpawnJailer(Vector(12672, -12033), Vector(1,0))
   Timers:CreateTimer(3.8, function()
      Seafortress:AddPatrolArguments(pudge5, 1, 3, 320, {Vector(13893, -11200), Vector(12672, -12033)})
   end)

   local pudge6 = Seafortress:SpawnJailer(Vector(13097, -10858), Vector(1,0))
   Timers:CreateTimer(5.7, function()
      Seafortress:AddPatrolArguments(pudge6, 1, 3, 320, {Vector(12585, -9984), Vector(13097, -10858)})
   end)

   local pudge7 = Seafortress:SpawnJailer(Vector(13137, -8804), Vector(0,1))
   Timers:CreateTimer(7.7, function()
      Seafortress:AddPatrolArguments(pudge7, 1, 3, 320, {Vector(13568, -9984), Vector(13137, -8804)})
   end)

   local pudge8 = Seafortress:SpawnJailer(Vector(13980, -8704), Vector(0,1))
   Timers:CreateTimer(9.7, function()
      Seafortress:AddPatrolArguments(pudge8, 1, 3, 320, {Vector(14604, -7540), Vector(13980, -8704)})
   end)

   local pudge9 = Seafortress:SpawnJailer(Vector(12145, -9026), Vector(-1,1))

   for i = 1, 4, 1 do
    Timers:CreateTimer(i, function()
      local spawnPos = Vector(12288, -15168) + Vector(RandomInt(0,1800), RandomInt(0,6464))
      local randomPos = Vector(12288, -15168) + Vector(RandomInt(0,1800), RandomInt(0,6464))
      local pudge = Seafortress:SpawnJailer(spawnPos, RandomVector(1))
      Seafortress:AddPatrolArguments(pudge, 1, 3, 320, {randomPos, spawnPos})
    end)
   end

   Seafortress.JailCenterTable = {Vector(14848, -14870), Vector(14848, -13633), Vector(14848, -12242), Vector(14848, -10893), Vector(14848, -9718)}
   Seafortress.GateTable = {0, 0, 0, 0, 0}
   Seafortress.CellCompleteTable = {0, 0, 0, 0, 0}

   Timers:CreateTimer(3, function()
    Seafortress:SpawnInfernalJailer(Vector(14840,-14493), Vector(0,-1), Vector(15262, -14457, 239+Seafortress.ZFLOAT), 1)

    Seafortress:SpawnInfernalJailer(Vector(14784,-13056), Vector(0,-1), Vector(15262, -13056, 239+Seafortress.ZFLOAT), 2)
    Seafortress:SpawnInfernalJailer(Vector(14840,-11648), Vector(0,-1), Vector(15262, -11738, 239+Seafortress.ZFLOAT), 3)
    Seafortress:SpawnInfernalJailer(Vector(14840,-10496), Vector(0,-1), Vector(15262, -10493, 239+Seafortress.ZFLOAT), 4)
    Seafortress:SpawnInfernalJailer(Vector(14840,-9344), Vector(0,-1), Vector(15262, -9344, 239+Seafortress.ZFLOAT), 5)
   end)

    Timers:CreateTimer(2, function()
      Seafortress:SpawnInnerJailEnemies()
    end)
end

function Seafortress:OpenJailGate(switchPos, gatePos, gateIndex, isTemp)
  if Seafortress.GateTable[gateIndex] == 1 then
    return false
  end
  Seafortress.GateTable[gateIndex] = 1
  Seafortress:ActivateSwitchGeneric(switchPos, "JailSwitch", true, 0.408)
  Timers:CreateTimer(0.6, function()
    EmitSoundOnLocationWithCaster(gatePos, "Seafortress.PrisonGateOpen", Events.GameMaster)
    local gate = Entities:FindByNameNearest("JailGate", gatePos, 700)
    for i = 1, 80, 1 do
      Timers:CreateTimer(i*0.03, function()
        gate:SetAngles(0, 270-165*math.cos((i-80)*math.pi/165), 0)
      end)
    end
    Timers:CreateTimer(0.9, function()
      local blockers = Entities:FindAllByNameWithin("JailGateBlocker", gatePos, 800)
      for i = 1, #blockers, 1 do
        blockers[i]:SetEnabled(false, true)
      end
    end)
    if isTemp then
      Timers:CreateTimer(10, function()
        if Seafortress.CellCompleteTable[gateIndex] == 0 then
          Seafortress.GateTable[gateIndex] = 0
          Seafortress:ActivateSwitchGeneric(switchPos, "JailSwitch", false, 0.408)
          EmitSoundOnLocationWithCaster(gatePos, "Seafortress.PrisonGateOpen", Events.GameMaster)
          local gate = Entities:FindByNameNearest("JailGate", gatePos, 700)
          for i = 1, 80, 1 do
            Timers:CreateTimer(i*0.03, function()
              gate:SetAngles(0, 105+165*math.cos((i-80)*math.pi/165), 0)
            end)
          end
          Timers:CreateTimer(0.9, function()
            local blockers = Entities:FindAllByNameWithin("JailGateBlocker", gatePos, 800)
            for i = 1, #blockers, 1 do
              blockers[i]:SetEnabled(true, true)
            end
          end)
        end
      end)
    end


  end)
end

function Seafortress:SpawnInfernalJailer(position, fv, prisonCrateLoc, gateIndex)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_infernal_jail_guard", position, 1, 3, "Seafortress.InfernalJailer.Aggro", fv, false)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.2
  queen.startPos = position
  queen.prisonCrateLoc = prisonCrateLoc
  queen.gateIndex = gateIndex
  return queen
end

function Seafortress:SpawnInnerJailEnemies()
  Seafortress:SpawnGhostPirate(Vector(14592, -15488), Vector(0,1))
  Seafortress:SpawnGhostPirate(Vector(14848, -15488), Vector(0,1))
  Seafortress:SpawnGhostPirate(Vector(15104, -15488), Vector(0,1))

  Seafortress:SpawnOceanDeathArcher(Vector(15214, -15168), Vector(-1,0))
  Seafortress:SpawnOceanDeathArcher(Vector(15214, -14912), Vector(-1,0))

  Timers:CreateTimer(1, function()
    local positionTable = {Vector(14592, -13954), Vector(14976, -13952), Vector(15296, -13760), Vector(15296, -13440)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(14592, -13529) - positionTable[i]):Normalized()
      Seafortress:SpawnCavernSummoner(positionTable[i], lookToPoint)
    end
  end)

  Timers:CreateTimer(3, function()
    for i = 1, 5, 1 do
      Seafortress:SpawnBarnacleBehemoth(Vector(14464, -12736)+Vector(RandomInt(0,900), RandomInt(0,750)), RandomVector(1))
    end
  end)

  Timers:CreateTimer(4, function()
    for i = 1, 4, 1 do
      Seafortress:SpawnCavernSummoner(Vector(14464, -11456)+Vector(RandomInt(0,900), RandomInt(0,750)), RandomVector(1))
    end
    for i = 1, 2, 1 do
      Seafortress:SpawnOceanDeathArcher(Vector(14464, -11456)+Vector(RandomInt(0,900), RandomInt(0,750)), RandomVector(1))
    end
  end)

  Timers:CreateTimer(6, function()
    for j = 0, 1, 1 do
      for i = 0, 2, 1 do
        Seafortress:SpawnVaultLord(Vector(14689+(j*300), -10069+(i*260)), Vector(-1,0))
      end
    end
  end)
end

function Seafortress:SpawnVaultLord(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("water_temple_vault_lord_two", position, 1, 1, "Seafortress.VaultLord.Aggro", fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.1
  queen.dominion = true
  return queen
end
  
function Seafortress:CheckJailConditions()
  local sum = 0
  for i = 1, #Seafortress.CellCompleteTable, 1 do
    sum = sum + Seafortress.CellCompleteTable[i]
  end 
  print(sum)
  if sum == #Seafortress.CellCompleteTable then
    --JAIL CELLS COMPLETE
    Timers:CreateTimer(1, function()
      for j = 1, #Seafortress.jailerTable, 1 do
        local caster = Seafortress.jailerTable[j]
        caster.deathCode = 10
        StartAnimation(caster, {duration=1.1, activity=ACT_DOTA_CAST_ABILITY_ROT, rate=0.9})
        EmitSoundOn("Seafortress.Jailer.DetectVO", caster)
        CustomAbilities:QuickAttachParticle("particles/msg_fx/big_excalamation.vpcf", caster, 3)
        caster:RemoveModifierByName("modifier_disable_player")
        caster.aggroSound = "Seafortress.Jailer.AggroVO"
        Dungeons:DeaggroUnit(caster)
        local ability = caster:FindAbilityByName("seafortress_jailer_passive")
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_jailer_in_combat", {})
        caster:FindAbilityByName("chef_meat_hook"):SetLevel(3)
        caster.reduc = 0.1
      end
    end)
  end
end

function Seafortress:PrisonerSequence()
  for i = 1, #Seafortress.FishPrisonerTable, 1 do
    local fish = Seafortress.FishPrisonerTable[i]
    fish.state = 1
    
  end
  Timers:CreateTimer(3, function()
    local object = Entities:FindByNameNearest("SeaObject", Vector(14624, -7337, 232), 700)
    Seafortress:objectShake(object, 150, 20, true, true, false, "Seafortress.BeaconShake", 10)
  end)
  Timers:CreateTimer(8.4, function()
    local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_barracks001_melee_destroy.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl(pfx, 0, Vector(14624, -7337, 232))
    Timers:CreateTimer(4, function()
      ParticleManager:DestroyParticle(pfx, false)
    end)    
    EmitSoundOnLocationWithCaster(Vector(14624, -7337, 232), "Seafortress.RocksExplode", Events.GameMaster)
    local object = Entities:FindByNameNearest("SeaObject", Vector(14624, -7337, 232), 700)
    UTIL_Remove(object)

    local wall = Entities:FindByNameNearest("SeaDoor6", Vector(14979, -7007, -335+Seafortress.ZFLOAT), 1100)
    Seafortress:Walls(false, {wall}, true, 4.3)
    Seafortress:RemoveBlockers(4, "SeaBlocker6", Vector(14912, -7036, 256+Seafortress.ZFLOAT), 1200)
    Seafortress:SpawnAfterJailRoom()
  end)
  Timers:CreateTimer(8, function()
    for i = 1, #Seafortress.FishPrisonerTable, 1 do
      local fish = Seafortress.FishPrisonerTable[i]
      fish.state = 2
      StartAnimation(fish, {duration=5, activity=ACT_DOTA_VICTORY, rate=1.0})
      EmitSoundOn("Seafortress.FishPrisoner.Happy", fish)
      Timers:CreateTimer(5, function()
        fish.state = 3
      end)
    end
  end)
end

function Seafortress:CreateBlackPortalUnit(position, bStart)
  
  local portalUnit = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
  portalUnit:FindAbilityByName("dummy_unit"):SetLevel(1)
  portalUnit:AddAbility("seafortress_black_portal_teleport"):SetLevel(1)
  portalUnit:SetDayTimeVisionRange(300)
  portalUnit:SetNightTimeVisionRange(300)
  portalUnit.dummy = true
  local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_lvl2.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
  ParticleManager:SetParticleControl(pfx, 0, portalUnit:GetAbsOrigin())
  EmitSoundOnLocationWithCaster(portalUnit:GetAbsOrigin(), "Seafortress.PortalTouch", portalUnit)
  if bStart then
    Seafortress.RoomsMoved = Seafortress.RoomsMoved + 1
    print("crash1?")
    local portalIndex = Seafortress.blackPortalRoomTable[Seafortress.RoomsMoved]
    if Seafortress.RoomsMoved > 10 then
      portalUnit.portToPosition = Vector(5632, -2240)
      Seafortress.LastBlackPortalActive = true
    else
      portalUnit.portToPosition = Seafortress.PORTAL_LOCATIONS_TABLE[portalIndex][Seafortress.altOrder]
    end
    Seafortress.lastPortToPos = portalUnit.portToPosition
    Seafortress.lastFromPos = portalUnit:GetAbsOrigin()
    Seafortress:InitAPortalRoom(Seafortress.blackPortalRoomTable[Seafortress.RoomsMoved])
  else
    print("crash2?")
    if Seafortress.RoomsMoved == 1 then
      portalUnit.portToPosition = Vector(15432, -5342) 
    -- elseif Seafortress.RoomsMoved == 10 then
    --    portalUnit.portToPosition = Vector(5632, -2240)
    else
      portalUnit.portToPosition = Seafortress.lastFromPos
    end
    Seafortress.lastPortToPos = portalUnit.portToPosition
  end
end

function Seafortress:SpawnAfterJailRoom()
  Seafortress.availableRoomTable = {1,2,3,4,5,6,7,8,9,10,11,12,13}
  Seafortress.PORTAL_LOCATIONS_TABLE = {{Vector(14464, -4032), Vector(15616, -4160)}, {Vector(15025, -2711), Vector(14720, -1600)}, {Vector(13479, -1907), Vector(10516, -1907)}, {Vector(10808, -3564), Vector(13472, -3564)}, {Vector(13463, -5233), Vector(10893, -5233)}, {Vector(10880, -8512), Vector(13369, -6496)}, {Vector(9358, -7809), Vector(9469, -6227)}, {Vector(9318, -5253), Vector(9318, -4329)}, {Vector(8818, -1906), Vector(9878, -2967)}, {Vector(6878, -3157), Vector(7701, -2273)}, {Vector(6926, -4275), Vector(7842, -4700)}, {Vector(3470, -6614), Vector(7822, -6603)}, {Vector(3556, -4848), Vector(5760, -4959)}}
  Seafortress.blackPortalRoomTable = {}
  for i = 1, 10, 1 do
    local randomRoom = RandomInt(1, #Seafortress.availableRoomTable)
    table.insert(Seafortress.blackPortalRoomTable, Seafortress.availableRoomTable[randomRoom])
    table.remove(Seafortress.availableRoomTable, randomRoom)
  end
  Seafortress.altOrder = RandomInt(1, 2)
  Seafortress.RoomsMoved = 0
  Seafortress.lastPortToPos = Vector(15432, -5342)
  Seafortress:CreateBlackPortalUnit(Vector(15432, -5342), true)
  DeepPrintTable(Seafortress.blackPortalRoomTable)
  -- Seafortress:InitAPortalRoom(Seafortress.RoomsMoved, Seafortress.blackPortalRoomTable[Seafortress.RoomsMoved])
end

function Seafortress:InitAPortalRoom(roomIndex)
  local nextRoomIndex = Seafortress.blackPortalRoomTable[Seafortress.RoomsMoved]
  local portInLoc = Seafortress.lastPortToPos

  Seafortress:CreateBlackPortalUnit(portInLoc, false)
  if Seafortress.RoomsMoved <= 10 then
    if roomIndex == 1 then
      local pirate = Seafortress:SpawnGhostPirate(Vector(15080, -4083), Vector(-1,0))
      pirate.deathCode = 11
      pirate.mazeCode = 1
      local pirate = Seafortress:SpawnOceanDeathArcher(Vector(14905, -3641), Vector(0,-1))
      pirate.deathCode = 11
      pirate.mazeCode = 1
      local pirate = Seafortress:SpawnOceanDeathArcher(Vector(15232, -3626), Vector(0,-1))
      pirate.deathCode = 11
      pirate.mazeCode = 1
      local pirate = Seafortress:SpawnCavernSummoner(Vector(14932, -4544), Vector(0,1))
      pirate.deathCode = 11
      pirate.mazeCode = 1
      local pirate = Seafortress:SpawnCavernSummoner(Vector(15232, -4544), Vector(0,1))
      pirate.deathCode = 11
      pirate.mazeCode = 1
    elseif roomIndex == 2 then
      local beast = Seafortress:SpawnBarnacleBehemoth(Vector(14778, -2786), Vector(0,1))
      beast.deathCode = 11
      beast.mazeCode = 2
      local beast = Seafortress:SpawnBarnacleBehemoth(Vector(14407, -2183), Vector(1,0))
      beast.deathCode = 11
      beast.mazeCode = 2
      local beast = Seafortress:SpawnBarnacleBehemoth(Vector(15436, -1548), Vector(0,-1))
      beast.deathCode = 11
      beast.mazeCode = 2
      local beast = Seafortress:SpawnBarnacleBehemoth(Vector(15549, -2253), Vector(-1,0))
      beast.deathCode = 11
      beast.mazeCode = 2

      local portal = Seafortress:SpawnSeaPortal(Vector(14976, -2176)+RandomVector(RandomInt(0, 400)), RandomVector(1))
      portal.deathCode = 11
      portal.mazeCode = 2
      local portal = Seafortress:SpawnSeaPortal(Vector(14976, -2176)+RandomVector(RandomInt(0, 400)), RandomVector(1))
      portal.deathCode = 11
      portal.mazeCode = 2
    elseif roomIndex == 3 then
      local spawnIndex = Seafortress.altOrder + 1
      if spawnIndex > 2 then
        spawnIndex = 1
      end
      local archerSpawnPos = Seafortress.PORTAL_LOCATIONS_TABLE[3][spawnIndex]
      local fv = Vector(1,0)
      if spawnIndex == 1 then
        fv = Vector(-1,0)
      end
      local archer = Seafortress:SpawnStrongRanger(archerSpawnPos, fv)
      archer.deathCode = 11
      archer.mazeCode = 3
      local positionTable = {Vector(11264, -1984), Vector(11584, -1728), Vector(11904, -1984), Vector(12352, -1984)}
      for i = 1, #positionTable, 1 do
        Seafortress:SpawnOceanDeathArcher(positionTable[i], fv)
      end
      Seafortress:SpawnVaultLord(Vector(12672, -1792), fv)
      Seafortress:SpawnVaultLord(Vector(12864, -2176), fv)
    elseif roomIndex == 4 then
      local spawnIndex = Seafortress.altOrder + 1
      if spawnIndex > 2 then
        spawnIndex = 1
      end
      local fv = Vector(-1,0)
      if spawnIndex == 1 then
        fv = Vector(1,0)
      end      
      local positionTable = {Vector(11328, -3840), Vector(11328, -3392), Vector(11840, -3597), Vector(12057, -3919), Vector(12058, -3264), Vector(12224, -3597), Vector(12736, -3411), Vector(12736, -3776)}
      local luck = RandomInt(1, 3)
      if luck == 1 then
        positionTable = {Vector(11465, -3370), Vector(11465, -3712), Vector(11913, -3369), Vector(11913, -3712), Vector(12361, -3369), Vector(12361, -3712), Vector(12809, -3369), Vector(12809, -3712)}
      elseif luck == 2 then
        positionTable = {Vector(11364, -3490), Vector(11673, -3712), Vector(11876, -3490), Vector(12096, -3490), Vector(12185, -3712), Vector(12405, -3712), Vector(12608, -3489), Vector(12917, -3712)}
      end
      for i = 1, #positionTable, 1 do
        Seafortress:SpawnMechanoid(positionTable[i], fv)
      end
      Seafortress:CompleteAPortalRoom()
    elseif roomIndex == 5 then
      local spawnIndex = Seafortress.altOrder + 1
      if spawnIndex > 2 then
        spawnIndex = 1
      end
      local fv = Vector(1,0)
      if spawnIndex == 1 then
        fv = Vector(-1,0)
      end
      for i = 0, 3, 1 do
        for j = 0, 2, 1 do
          if j == 0 then
            Seafortress:SpawnNagaSamurai(Vector(11298, -5477) + Vector(i*570, j*210), fv)
          elseif j == 1 then
            Seafortress:SpawnFrostMage(Vector(11298, -5477) + Vector(i*570, j*210), fv)
          else
            Seafortress:SpawnNagaProtector(Vector(11298, -5477) + Vector(i*570, j*210), fv)
          end
        end
      end
      Seafortress:CompleteAPortalRoom()
    elseif roomIndex == 6 then
      local spawnIndex = Seafortress.altOrder + 1
      if spawnIndex > 2 then
        spawnIndex = 1
      end
      local fv = Vector(0,-1)
      if spawnIndex == 1 then
        fv = Vector(1,0)
      end
      local positionTable = {Vector(11136, -7872), Vector(10752, -7039), Vector(11584, -7679), Vector(11448, -6592), Vector(11962, -6784), Vector(12071, -7168), Vector(12347, -6720)}
      for i = 1, #positionTable, 1 do
        Seafortress:SpawnSpikeyBeetle(positionTable[i], fv)
      end

      local positionTable = {Vector(11114, -6874), Vector(10921, -7525), Vector(11136, -7552), Vector(11584, -7552), Vector(11179, -7177), Vector(11504, -6817)}
      for i = 1, #positionTable, 1 do
        Timers:CreateTimer(i*0.8, function()
          local patrolPositionTable = {}
          for j = 1, #positionTable, 1 do
            local index = i + j
            if index > #positionTable then
              index = index - #positionTable
            end
            table.insert(patrolPositionTable, positionTable[index])
          end
          for k = 1, 2, 1 do
            local elemental = Seafortress:SpawnSpearback(positionTable[i], RandomVector(1))
            Seafortress:AddPatrolArguments(elemental, 30, 1, 100, patrolPositionTable)
          end
        end)
      end
      Seafortress:CompleteAPortalRoom()
    elseif roomIndex == 7 then
      local lizard = Seafortress:SpawnSeaFortressLizard(Vector(8960, -7104), Vector(1,0))
      lizard.deathCode = 11
      lizard.mazeCode = 7
      local lizard = Seafortress:SpawnSeaFortressLizard(Vector(9002, -6720), Vector(1,0))
      lizard.deathCode = 11
      lizard.mazeCode = 7
      local lizard = Seafortress:SpawnSeaFortressLizard(Vector(9728, -6720), Vector(-1,0))
      lizard.deathCode = 11
      lizard.mazeCode = 7
      local lizard = Seafortress:SpawnSeaFortressLizard(Vector(9728, -7100), Vector(-1,0))
      lizard.deathCode = 11
      lizard.mazeCode = 7

      local positionTable = {Vector(9408, -7207), Vector(9408, -6528)}
      for i = 1, #positionTable, 1 do
        Timers:CreateTimer(i*1.2, function()
          local patrolPositionTable = {}
          for j = 1, #positionTable, 1 do
            local index = i + j
            if index > #positionTable then
              index = index - #positionTable
            end
            table.insert(patrolPositionTable, positionTable[index])
          end
          for j = 0, 1, 1 do
            Timers:CreateTimer(j*1, function()
              local elemental = Seafortress:SpawnSwampSnake(positionTable[i], RandomVector(1))
              Seafortress:AddPatrolArguments(elemental, 20, 3, 220, patrolPositionTable)
              elemental.deathCode = 11
              elemental.mazeCode = 7
            end)
          end
        end)
      end
    elseif roomIndex == 8 then
      local spawnIndex = Seafortress.altOrder + 1
      if spawnIndex > 2 then
        spawnIndex = 1
      end
      local fv = Vector(0,-1)
      if spawnIndex == 1 then
        fv = Vector(0,1)
      end
      local duelist = Seafortress:SpawnDuelist(Vector(9338, -4736), fv)
      duelist.deathCode = 11
      duelist.mazeCode = 8
    elseif roomIndex == 9 then
      local spawnIndex = Seafortress.altOrder + 1
      if spawnIndex > 2 then
        spawnIndex = 1
      end
      local fv = Vector(-1,1)
      if spawnIndex == 1 then
        fv = Vector(1,-1)
      end
      local positionTable = {Vector(9732, -2093), Vector(9344, -2454), Vector(9007, -2774)}
      for i = 1, #positionTable, 1 do
        local duelist = Seafortress:SpawnRockBreaker(positionTable[i], fv)
        duelist.deathCode = 11
        duelist.mazeCode = 9
      end
    elseif roomIndex == 10 then
      local dragon = Seafortress:SpawnSwampDragon(Vector(7552, -2816), Vector(0,-1))
      dragon.deathCode = 11
      dragon.mazeCode = 10
      local dragon = Seafortress:SpawnSwampDragon(Vector(7168, -2560), Vector(0,1))
      dragon.deathCode = 11
      dragon.mazeCode = 10    
      local positionTable = {Vector(7040, -2048), Vector(6784, -2563), Vector(6894, -3197), Vector(7744, -3169), Vector(7820, -2624), Vector(7744, -2048)}
      for i = 1, #positionTable, 1 do
        local duelist = Seafortress:SpawnSwampUrsa(positionTable[i], RandomVector(1))
      end 
      local positionTable = {Vector(7857, -3182), Vector(6784, -2880), Vector(7872, -2581), Vector(6784, -2216)}
      for i = 1, #positionTable, 1 do
        local duelist = Seafortress:SpawnSeafortressViper(positionTable[i], RandomVector(1))
      end
    elseif roomIndex == 11 then
      Seafortress:SpawnVenomousDragonfly(Vector(6798, -4727), Vector(1,0))
      Seafortress:SpawnVenomousDragonfly(Vector(7680, -4273), Vector(-1,0))

      local positionTable = {Vector(7040, -5184), Vector(7296, -5184), Vector(7552, -5184), Vector(7302, -4928)}
      for i = 1, #positionTable, 1 do
        Seafortress:SpawnSeaDryad(positionTable[i], RandomVector(1))
      end  
      Seafortress:CompleteAPortalRoom()
    elseif roomIndex == 12 then
      Seafortress:SpawnFortuneSeeker(Vector(3840, -7168), Vector(0,1))
      Seafortress:SpawnFortuneSeeker(Vector(4988, -7168), Vector(0,1))
      Seafortress:SpawnFortuneSeeker(Vector(6339, -6784), Vector(0,1))
      Seafortress:SpawnFortuneSeeker(Vector(7040, -6784), Vector(0,1))

      Seafortress:SpawnFortuneSeeker(Vector(7040, -6080), Vector(0,-1))
      Seafortress:SpawnFortuneSeeker(Vector(5677, -6178), Vector(0,-1))
      Seafortress:SpawnFortuneSeeker(Vector(4736, -6232), Vector(0,-1))
      Seafortress:SpawnFortuneSeeker(Vector(4044, -6144), Vector(0,-1))

      local positionTable = {Vector(5824, -6592), Vector(4352, -6784), Vector(7424, -6400)}
      for i = 1, #positionTable, 1 do
        Timers:CreateTimer(i*1.2, function()
          local patrolPositionTable = {}
          for j = 1, #positionTable, 1 do
            local index = i + j
            if index > #positionTable then
              index = index - #positionTable
            end
            table.insert(patrolPositionTable, positionTable[index])
          end
          for j = 0, 1, 1 do
            Timers:CreateTimer(j*1, function()
              local elemental = Seafortress:SpawnCrymsithBerserker(positionTable[i], RandomVector(1))
              Seafortress:AddPatrolArguments(elemental, 20, 3, 220, patrolPositionTable)
            end)
          end
        end)
      end

      Seafortress:CompleteAPortalRoom()
    elseif roomIndex == 13 then
      local positionTable = {Vector(5632, -3888), Vector(5248, -4847), Vector(4800, -3888), Vector(3904, -4096), Vector(4224, -4992)}
      for i = 1, #positionTable, 1 do
        local lookToPoint = (Vector(4608, -4480) - positionTable[i]):Normalized()
        Seafortress:SpawnMantaRider(positionTable[i], lookToPoint)
      end
      local ogre = Seafortress:SpawnBigBeachOgre(Vector(4608, -4457), Vector(0,-1))
      ogre.deathCode = 11
      ogre.mazeCode = 13
    else
      Seafortress:CompleteAPortalRoom()
    end
  else
  end
end




function Seafortress:CompleteAPortalRoom()
  local completedRoom = Seafortress.blackPortalRoomTable[Seafortress.RoomsMoved]

  local portOutIndex = Seafortress.altOrder + 1
  if portOutIndex > 2 then
    portOutIndex = 1
  end
  local portalOutLocation = Seafortress.PORTAL_LOCATIONS_TABLE[completedRoom][portOutIndex]
  Seafortress.altOrder = RandomInt(1, 2)
  Seafortress:CreateBlackPortalUnit(portalOutLocation, true)
  -- Seafortress:InitAPortalRoom(Seafortress.blackPortalRoomTable[Seafortress.RoomsMoved])
end

function Seafortress:PortalMazeUnitDie(caster)
  if not Seafortress.MazeCounts then
    Seafortress.MazeCounts = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    Seafortress.MazeReqs = {5, 6, 1, 0, 0, 0, 8, 1, 3, 2, 0, 0, 1}
  end
  Seafortress.MazeCounts[caster.mazeCode] = Seafortress.MazeCounts[caster.mazeCode] + 1
  if Seafortress.MazeCounts[caster.mazeCode] == Seafortress.MazeReqs[caster.mazeCode] then
    Seafortress:CompleteAPortalRoom()
  end
end

function Seafortress:SpawnMechanoid(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_mekanoid_disruptor", position, 1, 2, nil, fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.4
  queen.dominion = true
  return queen
end

function Seafortress:SpawnSpikeyBeetle(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("spikey_beetle", position, 1, 2, "Seafortress.LobsterAggro", fv, false)
  queen:SetRenderColor(190, 255, 255)
  Events:ColorWearables(queen, Vector(190, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.3
  queen.dominion = true
  return queen
end

function Seafortress:SpawnSpearback(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("cavern_spearback", position, 1, 2, "Seafortress.SpineAggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:ColorWearables(queen, Vector(120, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.2
  queen.dominion = true
  return queen
end

function Seafortress:SpawnDuelist(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_duelist", position, 2, 4, "Seafortress.DuelistAggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:ColorWearables(queen, Vector(120, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.2
  queen.dominion = true
  return queen
end

function Seafortress:SpawnRockBreaker(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_rock_breaker", position, 1, 3, "Seafortress.RockBreaker.Aggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:ColorWearables(queen, Vector(120, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.5
  queen.dominion = true
  return queen
end

function Seafortress:SpawnFortuneSeeker(position, fv)
  local stone = Seafortress:SpawnDungeonUnit( "crimsyth_fortune_seeker", position, 1, 3, "Seafortress.FortuneSeeker.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(120, 255, 255)
  Events:ColorWearables(stone, Vector(120, 255, 255))
  Events:AdjustBossPower(stone, 8, 8, false)
  -- stone:AddNewModifier(stone, nil, "modifier_animation", {translate="run"})
  stone:AddNewModifier(stone, nil, "modifier_animation", {translate="attack_normal_range"})
  stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="run"})
  Events:SetPositionCastArgs(stone, 1000, 0, 1, FIND_ANY_ORDER)
  stone.dominion = true
  stone.reduc = 0.2
  return stone
end

function Seafortress:SpawnCrymsithBerserker(position, fv)
  local stone = Seafortress:SpawnDungeonUnit("redfall_crimsyth_berserker", position, 1, 2, "Seafortress.CrimsythBerserker.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(120, 255, 255)
  Events:ColorWearables(stone, Vector(120, 255, 255))
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.dominion = true
  stone.reduc = 0.3
  return stone
end

function Seafortress:SpawnBigBeachOgre(position, fv)
  local stone = Seafortress:SpawnDungeonUnit("big_beach_ogre", position, 5, 6, "Seafortress.BigOgre.Aggro", fv, false)
  stone.itemLevel = 130
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.reduc = 0.01
  stone.dominion = true
  return stone
end

function Seafortress:SpawnDeepDiver(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_deep_diver", position, 1, 2, "Seafortress.Lizard.Aggro", fv, false)
  queen:SetRenderColor(190, 255, 255)
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  queen.reduc = 0.2
  return queen
end

function Seafortress:SpawnDeepRoom()
  Seafortress:SpawnDeepDiver(Vector(5376, -575), Vector(-1,0))
  Seafortress:SpawnDeepDiver(Vector(4870, -185), Vector(0,-1))
  Seafortress:SpawnDeepDiver(Vector(4544, -64), Vector(0,-1))

  Timers:CreateTimer(1.5, function()
    local positionTable = {Vector(4295, 45), Vector(4624, 384), Vector(5248, 384), Vector(5498, 128), Vector(5891, -80)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(4800, -576) - positionTable[i]):Normalized()
      Seafortress:DepthWarper(positionTable[i], lookToPoint)
    end
  end)

  Timers:CreateTimer(2, function()
    local zot = Seafortress:SpawnZot(Vector(6912, 3908), Vector(-0.2, -1))
    zot.zapCode = 1
  end)
  Timers:CreateTimer(3, function()
    local positionTable = {Vector(4480, 1728), Vector(4672, 1611), Vector(4672, 1344), Vector(6185, 1714), Vector(6400, 1844), Vector(7305, 1728), Vector(7168, 2025), Vector(4800, 3200), Vector(5120, 3328), Vector(5248, 3840)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(5696, 1088) - positionTable[i]):Normalized()
      Seafortress:SpawnSpikeyBeetle(positionTable[i], lookToPoint)
    end
  end)
  Timers:CreateTimer(5, function()
    local positionTable = {Vector(4359, 2304), Vector(5248, 1536), Vector(5824, 1889), Vector(6720, 2305), Vector(6288, 2688), Vector(6288, 2688), Vector(5450, 2954)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(5696, 1088) - positionTable[i]):Normalized()
      Seafortress:SpawnMechanoid(positionTable[i], lookToPoint)
    end
  end)

  local positionTable = {Vector(6458, 1759), Vector(4736, 1792), Vector(5055, 2752), Vector(5915, 3520)}
  for i = 1, #positionTable, 1 do
    Timers:CreateTimer(i*0.8, function()
      local patrolPositionTable = {}
      for j = 1, #positionTable, 1 do
        local index = i + j
        if index > #positionTable then
          index = index - #positionTable
        end
        table.insert(patrolPositionTable, positionTable[index])
      end
      local elemental = Seafortress:DepthWarper(positionTable[i], RandomVector(1))
      Seafortress:AddPatrolArguments(elemental, 30, 4, 100, patrolPositionTable)
    end)
  end

  Timers:CreateTimer(6, function()
    local positionTable = {Vector(6912, 320), Vector(7360, 512), Vector(8448, 1088), Vector(9024, 832), Vector(9344, 512)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(6976, 1536) - positionTable[i]):Normalized()
      Seafortress:SpawnDarkSunderer(positionTable[i], lookToPoint)
    end
  end)
end

function Seafortress:SpawnDeepRoom2()
  Seafortress:SpawnDeepDiver(Vector(7296, -437), Vector(0,1))
  Seafortress:SpawnDeepDiver(Vector(6976, -320), Vector(0,1))

  Seafortress:SpawnDeepDiver(Vector(9472, 214), Vector(-1,0))
  Seafortress:SpawnDeepDiver(Vector(9781, 440), Vector(-1,0))
  Timers:CreateTimer(1, function()
    for j = 0, 1, 1 do
      for i = 0, 2, 1 do
        Seafortress:DepthWarper(Vector(8359, 448)+Vector(340*i, j*260), Vector(-1,0))
      end
    end
  end)

  Timers:CreateTimer(3, function()
    local zot = Seafortress:SpawnZot(Vector(8576, -448), Vector(0, 1))
    zot.zapCode = 2
  end)
end

function Seafortress:DepthWarper(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_depth_warper", position, 1, 3, "Seafortress.DepthWarper.Aggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:ColorWearables(queen, Vector(120, 255, 255))
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  queen.reduc = 0.05
  return queen
end

function Seafortress:ElectrocuteUnit(unit, vKnockback)
  local caster = Seafortress.Master
  local ability = Seafortress.MasterAbility
  if not unit:HasModifier("modifier_lightning_stun") then
    ability:ApplyDataDrivenModifier(caster, unit, "modifier_lightning_stun", {duration = 1.2})
    EmitSoundOn("Seafortress.WaterTemple.ElectricStun", unit)
    ScreenShake(unit:GetAbsOrigin(), 200, 0.1, 0.1, 200, 0, true)
      Timers:CreateTimer(1.2, function()
        
        local mult = 0.3
        if GameState:GetDifficultyFactor() == 2 then
          mult = 0.2
        elseif GameState:GetDifficultyFactor() == 1 then
          mult = 0.1
        end
        if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
          local damage = unit:GetMaxHealth()*mult
          ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
        end
        -- PopupDamage(unit, damage)
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_water_temple_lightning_immune", {duration = 1.2})
        if vKnockback then
          StartAnimation(unit, {duration=0.6, activity=ACT_DOTA_FLAIL, rate=2})
          WallPhysics:Jump(unit, vKnockback, 16, 16, 20, 1.5)
        end
        EmitSoundOn("Seafortress.WaterTemple.ElectricStunEnd", unit)
    end)
  end

end

function Seafortress:SpawnZot(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_thunder_zot", position, 2, 4, "Seafortress.Zot.Aggro", fv, false)
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.reduc = 0.05
  return queen
end

function Seafortress:SpawnDarkSunderer(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_dark_sunderer", position, 1, 3, "Seafortress.DarkSunderer.Aggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:ColorWearables(queen, Vector(120, 255, 255))
  Events:AdjustBossPower(queen, 8, 10, false)
  queen:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="walk"})
  queen.dominion = true
  queen.reduc = 0.015
  return queen
end

function Seafortress:SpawnDeepRoom3()
    local positionTable = {Vector(9216, 3136), Vector(9427, 2835), Vector(9427, 3136), Vector(9728, 3264), Vector(9728, 2944), Vector(9728, 2944)}
    local luck = RandomInt(1,2)
    if luck == 1 then
      positionTable = {Vector(9025, 3198), Vector(9343, 3345), Vector(9728, 3264), Vector(9520, 3026), Vector(9331, 2834), Vector(9728, 2733)}
    end
    for i = 1, #positionTable, 1 do
      Seafortress:SpawnDarkSunderer(positionTable[i], Vector(-1,0))
    end 
    local zot = Seafortress:SpawnZot(Vector(10048, 2944), Vector(-1,0)) 
    zot.zapCode = 3

    Timers:CreateTimer(1, function()
      local positionTable = {Vector(8000, 2944), Vector(8000, 3946), Vector(9458, 4032), Vector(10680, 3456), Vector(10816, 2576), Vector(10048, 1926), Vector(8704, 2408)}
      for i = 1, #positionTable, 1 do
        Timers:CreateTimer(i*0.3, function()
          local patrolPositionTable = {}
          for j = 1, #positionTable, 1 do
            local index = i + j
            if index > #positionTable then
              index = index - #positionTable
            end
            table.insert(patrolPositionTable, positionTable[index])
          end
          for j = 0, 1, 1 do
            Timers:CreateTimer(j*1, function()
              local elemental = Seafortress:SpawnCephapolos(positionTable[i], RandomVector(1))
              Seafortress:AddPatrolArguments(elemental, 20, 3, 420, patrolPositionTable)
            end)
          end
        end)
      end
    end)

  Timers:CreateTimer(3, function()
    local positionTable = {Vector(7808, 3520), Vector(8000, 3776), Vector(7808, 4096)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(8128, 3520) - positionTable[i]):Normalized()
      Seafortress:SpawnSpikeyBeetle(positionTable[i], lookToPoint)
    end
  end)

  Timers:CreateTimer(4, function()
    Seafortress:SpawnGhostPirate(Vector(8512, 4096), Vector(0,-1))
    Seafortress:SpawnGhostPirate(Vector(10831, 3400), Vector(-1,-1))
    Seafortress:SpawnGhostPirate(Vector(11035, 3072), Vector(-1,0))
    Seafortress:SpawnDeepShadowWeaver(Vector(11392, 3648), Vector(-1,-1))

    Seafortress:SpawnDeepDiver(Vector(11584, 2688), Vector(-1,0))
    Seafortress:SpawnDeepDiver(Vector(11584, 3008), Vector(-1,0))

    Seafortress:SpawnCephapolos(Vector(9728, 1600), Vector(0,1))
  end)

  Timers:CreateTimer(6, function()
    for i = 0, 2, 1 do
      for j = 0, 3, 1 do
        if j%2 == 0 then
          Seafortress:DepthWarper(Vector(10496, 1472)+Vector(340*i, j*320), Vector(-1,0))
        else
          Seafortress:SpawnOceanDeathArcher(Vector(10496, 1472)+Vector(340*i, j*320), Vector(-1,0))
        end
      end
    end
  end)
end

function Seafortress:SpawnCephapolos(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_cephalopus", position, 1, 1, "Seafortress.Cephalopus.Aggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:ColorWearables(queen, Vector(120, 255, 255))
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  queen.reduc = 0.25
  Seafortress:SetTargetCastArgs(queen, 700, 0, 1, FIND_ANY_ORDER)
  return queen
end



function Seafortress:SpawnFirstTempleRoom()
  Seafortress:SpawnFortressCentaur(Vector(384, -6080), Vector(0,-1))
  Seafortress:SpawnFortressCentaur(Vector(896, -6080), Vector(0,-1))

  Seafortress:SpawnFortressCentaur(Vector(1438, -6570), Vector(-1,0))
  Seafortress:SpawnFortressCentaur(Vector(1438, -6848), Vector(-1,0))
  Seafortress:SpawnFortressCentaur(Vector(1984, -6570), Vector(-1,0))
  Seafortress:SpawnFortressCentaur(Vector(1984, -6848), Vector(-1,0))

  Seafortress:SpawnSoulSplicer(Vector(518, -6720), Vector(0,-1))
  Seafortress:SpawnSoulSplicer(Vector(807, -6720), Vector(0,-1))
  Seafortress:SpawnSoulSplicer(Vector(518, -6400), Vector(0,-1))
  Seafortress:SpawnSoulSplicer(Vector(807, -6400), Vector(0,-1))
  Timers:CreateTimer(1.5, function()
    Seafortress:SpawnFortressCentaur(Vector(698, -4765), Vector(0,-1))
    Seafortress:SpawnFortressCentaur(Vector(698, -4416), Vector(0,-1))

    for j = 0, 1, 1 do
      for i = 0, 3, 1 do
        Seafortress:SpawnSoulSplicer(Vector(121, -5005)+Vector(300*j, 320*i), Vector(0,-1))
      end
    end
  end)
  Timers:CreateTimer(3, function()
    Seafortress:SpawnFortressCentaur(Vector(331, -3651), Vector(-0.2,-1))
  end)
  Timers:CreateTimer(3.5, function()
    local positionTable = {Vector(-128, -5632), Vector(64, -5248), Vector(768, -5276), Vector(-256, -4096), Vector(-126, -3225), Vector(576, -3036)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(640, -6080) - positionTable[i]):Normalized()
      Seafortress:SpawnFairyDragon(positionTable[i], lookToPoint)
    end
  end)
end

function Seafortress:SpawnSeaMaiden(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_sea_maiden", position, 1, 4, "Seafortress.SeaMaiden.Aggro", fv, false)
  queen:SetRenderColor(120, 255, 165)
  Events:ColorWearables(queen, Vector(120, 255, 165))
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  queen.reduc = 0.04
  Seafortress:SetPositionCastArgs(queen, 1200, 0, 1, FIND_CLOSEST)
  return queen
end

function Seafortress:SpawnFortressCentaur(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_centaur", position, 1, 2, "Seafortress.Centaur.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.targetRadius = 320
  queen.autoAbilityCD = 1
  return queen
end

function Seafortress:SpawnSoulSplicer(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_soul_splicer", position, 1, 2, "Seafortress.SoulSplicer.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  Events:ColorWearables(queen, Vector(120, 255, 165))
  queen.reduc = 0.3
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SpawnFairyDragon(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_fairy_dragon", position, 1, 3, "Seafortress.FairyDragon.Aggro", fv, false)
  -- queen.dominion = true
  --problems with crashing when dominated
  queen:SetRenderColor(160, 255, 100)
  Events:ColorWearables(queen, Vector(120, 255, 165))
  Events:AdjustBossPower(queen, 2, 8, false)
  return queen
end

function Seafortress:SpawnOlaf(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seabinder_olaf", position, 1, 4, "Seafortress.Olaf.Aggro", fv, false)
  queen:SetRenderColor(120, 120, 255)
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  queen.reduc = 0.006
  Seafortress:SetPositionCastArgs(queen, 3500, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnInnerTempleRoom2()
  Seafortress:SpawnOlaf(Vector(1920, -4736), Vector(0,-1))
  Seafortress:SpawnSeaPortal(Vector(2389, -5947), Vector(-1,0))

  Seafortress:SpawnFortressCentaur(Vector(1464, -5947), Vector(1,0))
  Seafortress:SpawnFortressCentaur(Vector(1464, -5632), Vector(1,0))

  Seafortress:SpawnSeaQueen(Vector(1920, -5638), Vector(0,-1))
end

function Seafortress:SpawnTempleAssassin(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_temple_assassin", position, 1, 3, "Seafortress.TempleAssassin.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  Events:ColorWearables(queen, Vector(120, 255, 165))
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SpawnOceanElemental(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_giga_ocean_elemental", position, 3, 6, "Seafortress.OceanElemental.Aggro", fv, false)
  -- queen.dominion = true
  queen:SetRenderColor(30, 255, 100)
  -- Events:ColorWearables(queen, Vector(120, 255, 230))
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SpawnInnerTempleRoom3()
  Timers:CreateTimer(1, function()
    for i = 0, 2, 1 do
      for j = 0, 2, 1 do
        Timers:CreateTimer(j*0.65 + i*1.42, function()
          Seafortress:SpawnTempleAssassin(Vector(1600 + i*320, -2368 + j*448), Vector(0,-1))
        end)
      end
    end
  end)
  Seafortress:SpawnFairyDragon(Vector(1792, -2930), RandomVector(1))
  Seafortress:SpawnFairyDragon(Vector(1593, -2721), RandomVector(1))
  Timers:CreateTimer(2, function()
    Seafortress:SpawnSoulSplicer(Vector(1909, -1264), Vector(0,-1))
    Seafortress:SpawnSoulSplicer(Vector(1575, -1264), Vector(0,-1))

    Seafortress:SpawnSoulSplicer(Vector(1152, -1664), Vector(1,0))
    Seafortress:SpawnSoulSplicer(Vector(1152, -1335), Vector(1,0))
  end)
  Seafortress:SpawnOceanElemental(Vector(2240, -3648), Vector(-1,0))

  Timers:CreateTimer(3, function()
    for k = 0, 5, 1 do
      for j = 0, 2, 1 do
        Timers:CreateTimer(j*0.7 + k*0.4, function()
          Seafortress:SpawnTemplarAssassin(Vector(-1152, -2240)+Vector(k*320, j*300)+RandomVector(RandomInt(0, 160)), Vector(1,0))
        end)
      end
    end
  end)
end

function Seafortress:SpawnTemplarAssassin(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_blazing_assassin", position, 1, 2, "Seafortress.TemplarAssassin.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 200, 255)
  -- Events:ColorWearables(queen, Vector(120, 255, 230))
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:AfterMemoryPuzzleRoomSpawn()
  Timers:CreateTimer(1.5, function()
    for k = 0, 2, 1 do
      for j = 0, 2, 1 do
        Timers:CreateTimer(j*0.3 + k*0.2, function()
          local templar = Seafortress:SpawnTemplarAssassin(Vector(-1152, -2240)+Vector(k*520, j*300)+RandomVector(RandomInt(0, 260)), RandomVector(1))
          templar:SetAbsOrigin(templar:GetAbsOrigin()+Vector(0,0,2000))
          templar.jumpEnd = "basic_dust"
          WallPhysics:JumpWithBlocking(templar, Vector(1,0), 0, 2, 5, 1)
          Timers:CreateTimer(3.2, function()
            StartAnimation(templar, {duration=2, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
            if not templar.aggro then
              Dungeons:AggroUnit(templar)
            end
          end)
        end)
      end
    end
  end)
  Timers:CreateTimer(4, function()
    local spawns = RandomInt(3,5)
    for i = 1, spawns, 1 do
      Timers:CreateTimer(i*0.5, function()
        local puck = Seafortress:SpawnFairyDragon(Vector(-1536, -3456), Vector(0,1))
        Timers:CreateTimer(0.3, function()
          puck:MoveToPositionAggressive(Vector(-260, -1824))
        end)
      end)
    end
  end)

  Timers:CreateTimer(5, function()
    local positionTable = {Vector(-1792, -3392), Vector(-1637, -3712), Vector(-1280, -3712)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(-1280, -2688) - positionTable[i]):Normalized()
      Seafortress:SpawnKrayBeast(positionTable[i], lookToPoint)
    end
  end)

  Timers:CreateTimer(6, function()
    local positionTable = {Vector(-1408, -5632), Vector(-1920, -5248), Vector(-1472, -4800), Vector(-1920, -4288)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(-1280, -2688) - positionTable[i]):Normalized()
      Seafortress:SpawnTempleAssassin(positionTable[i], lookToPoint)
    end
  end)
  Seafortress:SpawnOceanElemental(Vector(-1851, -5981), Vector(0,1))
  Timers:CreateTimer(7, function()
    local positionTable = {Vector(-2779, -5868), Vector(-2675, -6425), Vector(-3186, -6336), Vector(-3665, -5888), Vector(-4041, -6437), Vector(-4480, -6190), Vector(-5120, -6297), Vector(-5568, -5952)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*0.3, function()
        local lookToPoint = (Vector(-1280, -2688) - positionTable[i]):Normalized()
        Seafortress:SpawnDiscipleOfPoseidon(positionTable[i], lookToPoint)
      end)
    end
  end)
  Timers:CreateTimer(8, function()
    local positionTable = {Vector(-6464, -6372), Vector(-6750, -6208), Vector(-6750, -5824), Vector(-6457, -5760), Vector(-6976, -5460), Vector(-6720, -5312)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(-1280, -2688) - positionTable[i]):Normalized()
      Seafortress:SpawnKrayBeast(positionTable[i], lookToPoint)
    end
  end)
  Timers:CreateTimer(10, function()
    local positionTable = {Vector(-6720, -4928), Vector(-6350, -4316), Vector(-6657, -3712)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local lookToPoint = (Vector(-1280, -2688) - positionTable[i]):Normalized()
        Seafortress:SpawnDiscipleOfPoseidon(positionTable[i] + RandomVector(RandomInt(0,80)), lookToPoint)
        Seafortress:SpawnTempleAssassin(positionTable[i] + RandomVector(RandomInt(120,200)), lookToPoint)
        Seafortress:SpawnFairyDragon(positionTable[i] + RandomVector(RandomInt(240,320)), lookToPoint)
      end)
    end
  end)
  Timers:CreateTimer(5.5, function()
    Seafortress:SpawnFortressCentaur(Vector(-4777, -5248), Vector(0,-1))
    Seafortress:SpawnFortressCentaur(Vector(-3581, -5248), Vector(0,-1))
    Seafortress:SpawnFortressCentaur(Vector(-3581, -3392), Vector(0,1))
    Seafortress:SpawnFortressCentaur(Vector(-4777, -3392), Vector(0,1))
  end)

  Timers:CreateTimer(3, function()
    local prophet = Seafortress:SpawnSeaProphet(Vector(-5340, -4352), Vector(0,-1))
    prophet.index = 1
    prophet.deathCode = 13
    local prophet = Seafortress:SpawnSeaProphet(Vector(-4224, -4352), Vector(0,-1))
    prophet.index = 2
    prophet.deathCode = 13
    local prophet = Seafortress:SpawnSeaProphet(Vector(-3032, -4352), Vector(0,-1))
    prophet.index = 3
    prophet.deathCode = 13
  end)

  -- Seafortress:ActivateSwitchGeneric(Vector(-4187, -4260, 122+Seafortress.ZFLOAT), "CastleSwitch3", true, 0.367)
end

function Seafortress:SpawnKrayBeast(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_kray_beast", position, 1, 2, "Seafortress.KrayBeast.Aggro", fv, false)
  queen.dominion = true
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetPositionCastArgs(queen, 1000, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnDiscipleOfPoseidon(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_disciple_of_poseidon", position, 1, 2, "Seafortress.DiscipleOfPoseidon.Aggro", fv, false)
  queen.dominion = true
  Timers:CreateTimer(0.2, function()
    queen:AddNewModifier(Events.GameMaster, nil, "modifier_animation", {translate="attack_normal_range"})
    queen:AddNewModifier(Events.GameMaster, nil, "modifier_animation_translate", {translate="run"})
  end)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetPositionCastArgs(queen, 1000, 0, 1, FIND_ANY_ORDER)

  return queen
end

function Seafortress:SpawnSeaProphet(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_sea_prophet", position, 2, 5, "Seafortress.SeaProphet.Aggro1", fv, false)
  queen.reduc = 0.03
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetRenderColor(170, 255, 245)
  Events:ColorWearables(queen, Vector(170, 255, 245))
  Seafortress:SetPositionCastArgs(queen, 1200, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:InitializeTempleStorm()  
  Seafortress.FloodRainObject = Entities:FindByNameNearest("RainFlood", Vector(-2486, -3944, -400+Seafortress.ZFLOAT), 1500)
  for i = 1, #Seafortress.SeaProphetTable, 1 do
    local prophet = Seafortress.SeaProphetTable[i]
    StartSoundEvent("Seafortress.RainWaves.RainBase", prophet)
    StartAnimation(prophet, {duration=3, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8})
    Timers:CreateTimer(1.0, function()
      EmitSoundOn("Seafortress.SeaProphet.RainWaveStartVO", prophet)
    end)
    ScreenShake(prophet:GetAbsOrigin(), 600, 0.8, 0.8, 600, 0, true)
    Timers:CreateTimer(4.5, function()
      EmitSoundOn("Seafortress.SeaProphet.RainWaveStartVO2", prophet)
      StartAnimation(prophet, {duration=15, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.8})
      Seafortress.RainSpawnParticleTable = {}
      local pfx = ParticleManager:CreateParticle("particles/econ/events/ti7/teleport_start_ti7_core.vpcf", PATTACH_CUSTOMORIGIN, Seafortress.Master)
      local portalPosition = Vector(-5376, -5056, 370+Seafortress.ZFLOAT)
      if prophet.index == 2 then
        portalPosition = Vector(-4203, -3549, 370+Seafortress.ZFLOAT)
      elseif prophet.index == 3 then
        portalPosition = Vector(-3008, -5056, 370+Seafortress.ZFLOAT)
      end
      ParticleManager:SetParticleControl(pfx, 0, portalPosition)
      table.insert(Seafortress.RainSpawnParticleTable, pfx)
      Events:CreateLightningBeamWithParticle(prophet:GetAttachmentOrigin(3), portalPosition, "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)

      Timers:CreateTimer(5, function()
        Seafortress:SpawnFloodWaveUnit("water_temple_faceless_water_elemental", portalPosition, 8, 0.8, true)
      end)
    end)
  end
  Seafortress.RainParticles = {}

  for i = 0, 1, 1 do
    for j = 0, 1, 1 do
      local pfx = ParticleManager:CreateParticle("particles/rain_fx/econ_rain.vpcf", PATTACH_CUSTOMORIGIN, Seafortress.Master)
      ParticleManager:SetParticleControl(pfx, 0, Vector(-6080, -5696)+Vector(2000*i, 2000*j))
      table.insert(Seafortress.RainParticles, pfx)
    end
  end
  Timers:CreateTimer(5, function()
    if Seafortress.RainWavesComplete then
      return false
    end
    for i = 0, 2, 1 do
      for j = 0, 2, 1 do
        EmitSoundOnLocationWithCaster(Vector(-6080, -5696)+Vector(1400*i, 1400*j), "Seafortress.RainWaves.Thunder", Events.GameMaster)
      end
    end
    for i = 1, #Seafortress.SeaProphetTable, 1 do
      ScreenShake(Seafortress.SeaProphetTable[i]:GetAbsOrigin(), 600, 0.8, 0.8, 600, 0, true)
    end
    if not Seafortress.RainWavesComplete then
      return 15
    end
    for i = 1, #Seafortress.SeaProphetTable, 1 do
      local prophet = Seafortress.SeaProphetTable[i]

      StartAnimation(prophet, {duration=3, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8})
      Timers:CreateTimer(1.2, function()
        EmitSoundOn("Seafortress.SeaProphet.RainWaveStartVO", prophet)
      end)
      ScreenShake(prophet:GetAbsOrigin(), 600, 0.8, 0.8, 600, 0, true)
    end
  end)

  Timers:CreateTimer(0.06, function()
    Seafortress.FloodRainObject:SetAbsOrigin(Seafortress.FloodRainObject:GetAbsOrigin()+Vector(0,0,530))
    for i = 1, 252, 1 do
      Timers:CreateTimer(i*0.15, function()
        Seafortress.FloodRainObject:SetAbsOrigin(Seafortress.FloodRainObject:GetAbsOrigin()+Vector(0,0,0.25))
      end)
    end
  end)

end

function Seafortress:SpawnFloodWaveUnit(unitName, spawnPoint, quantity, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Seafortress.RainWaveUnit.Spawn", Seafortress.Master)
    end
      local luck = RandomInt(1, 160)
      if Events.SpiritRealm then
        luck = RandomInt(1, 66)
      end
      if luck == 1 then
        unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
      elseif luck == 2 then
        unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
      else
        unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)   
      Events:AdjustDeathXP(unit)
      end
      if IsValidEntity(unit) then
        unit.dominion = true
        unit.deathCode = 14
        Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, unit, "modifier_sea_fortress_ai", {})
        unit:SetAcquisitionRange(3000)
        CustomAbilities:QuickAttachParticle("particles/econ/events/ti7/blink_dagger_start_ti7_splash.vpcf", unit, 2)
        unit.aggro = true
        Seafortress:AdjustWaveUnit(unit)
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].dominion = true
          unit[i]:SetAcquisitionRange(3000)
          unit[i].deathCode = 14
          Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, unit[i], "modifier_sea_fortress_ai", {})
          CustomAbilities:QuickAttachParticle("particles/econ/events/ti7/blink_dagger_start_ti7_splash.vpcf", unit[i], 2)
          Seafortress:AdjustWaveUnit(unit[i])
        end
      end
    end)
  end
end

function Seafortress:AdjustWaveUnit(unit)
  if unit:GetUnitName() == "water_temple_faceless_water_elemental" then
    unit:SetModelScale(0.8)
    Seafortress:SetPositionCastArgs(unit, 800, 0, 1, FIND_ANY_ORDER)
  elseif unit:GetUnitName() == "water_temple_stone_priestess" then
    unit:SetModelScale(0.8)
    unit:RemoveAbility("creature_pure_strike")
    unit:RemoveModifierByName("modifier_pure_strike")
    Seafortress:SetTargetCastArgs(unit, 800, 0, 1, FIND_ANY_ORDER)    
  elseif unit:GetUnitName() == "seafortress_soul_splicer" then
    unit:SetRenderColor(160, 255, 100)
    Events:ColorWearables(unit, Vector(120, 255, 165))
  elseif unit:GetUnitName() == "seafortress_disciple_of_poseidon" then
    Timers:CreateTimer(0.2, function()
      unit:AddNewModifier(Events.GameMaster, nil, "modifier_animation", {translate="attack_normal_range"})
      unit:AddNewModifier(Events.GameMaster, nil, "modifier_animation_translate", {translate="run"})
    end)
    Events:AdjustBossPower(unit, 8, 8, false)
    Seafortress:SetPositionCastArgs(unit, 1000, 0, 1, FIND_ANY_ORDER)
  elseif unit:GetUnitName() == "water_temple_vault_lord_two" then
    unit:SetRenderColor(100, 255, 255)
    Events:ColorWearables(unit, Vector(100, 255, 255))
    Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, unit, "modifier_seafortress_blue", {})
    Events:AdjustBossPower(unit, 8, 8, false)
    unit.reduc = 0.3
  end
end

function Seafortress:EndRainSequence()
  Seafortress.RainWavesComplete = true
  for i = 1, #Seafortress.SeaProphetTable, 1 do
    local prophet = Seafortress.SeaProphetTable[i]
    StopSoundEvent("Seafortress.RainWaves.RainBase", prophet)
    StartAnimation(prophet, {duration=3, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8})
    Timers:CreateTimer(0.6, function()
      EmitSoundOn("Seafortress.SeaProphet.RainWaveStartVO", prophet)
    end)
    ScreenShake(prophet:GetAbsOrigin(), 600, 0.8, 0.8, 600, 0, true)
    Timers:CreateTimer(4.5, function()
      EmitSoundOn("Seafortress.SeaProphet.RainWaveStartVO2", prophet)
      StartAnimation(prophet, {duration=4, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.8})
    end)
    Timers:CreateTimer(9, function()
      StartAnimation(prophet, {duration=15, activity=ACT_DOTA_TAUNT, rate=1.0, translate="horn"})
      Timers:CreateTimer(2, function()
        local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
        ParticleManager:SetParticleControl(pfx, 0, prophet:GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
        ParticleManager:SetParticleControl(pfx, 2, Vector(0.5,0.5,0.5))
        Timers:CreateTimer(10, function() 
          ParticleManager:DestroyParticle( pfx, false )
          ParticleManager:ReleaseParticleIndex(pfx)
        end)
        ScreenShake(prophet:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
        EmitSoundOnLocationWithCaster(prophet:GetAbsOrigin(), "Seafortress.SeaProphet.FriendlySpawn", Events.GameMaster)      
        Timers:CreateTimer(0.5, function()
          UTIL_Remove(prophet)
        end)   
      end)
    end)
  end
  for j = 1, #Seafortress.RainSpawnParticleTable, 1 do
    ParticleManager:DestroyParticle(Seafortress.RainSpawnParticleTable[j], false)
  end
  for i = 1, #Seafortress.RainParticles, 1 do
    ParticleManager:DestroyParticle(Seafortress.RainParticles[i], false)
  end

  Timers:CreateTimer(0.06, function()
    for i = 1, 126, 1 do
      Timers:CreateTimer(i*0.15, function()
        Seafortress.FloodRainObject:SetAbsOrigin(Seafortress.FloodRainObject:GetAbsOrigin()-Vector(0,0,0.5))
      end)
    end
    Timers:CreateTimer(30, function()
      Seafortress.FloodRainObject:SetAbsOrigin(Seafortress.FloodRainObject:GetAbsOrigin()-Vector(0,0,530))
    end)
  end)
  Timers:CreateTimer(8, function()
    Seafortress:MiddleObjective()
    Seafortress:InitiateBehindFloodArea()
  end)
end

function Seafortress:SpawnDragoon(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_aqua_dragoon", position, 1, 1, "Seafortress.Dragoon.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 255)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.targetRadius = 900
  queen.autoAbilityCD = 1
  return queen
end

function Seafortress:SpawnBloodDrinker(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_blood_drinker", position, 1, 1, "Seafortress.BloodDrinker.Aggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  queen.reduc = 0.25
  Seafortress:SetTargetCastArgs(queen, 700, 0, 1, FIND_ANY_ORDER)
  queen:AddNewModifier( queen, nil, "modifier_movespeed_cap_super", {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:SpawnAfterLaserTempleArea()    
  Seafortress:SpawnSwampDragon(Vector(-12110, 4288), Vector(-1,-1))
  Seafortress:SpawnSwampDragon(Vector(-13706, 4166), Vector(0,-1))
  Seafortress:SpawnSwampDragon(Vector(-12172, 5696), Vector(-0.3,-1))

  Timers:CreateTimer(1, function()
    local positionTable = {Vector(-14016, 6400), Vector(-13056, 5750), Vector(-12544, 4800), Vector(-11264, 4992), Vector(-13440, 3392), Vector(-14272, 3648), Vector(-11904, 2560)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        for k = 0, 1, 1 do
          local elemental = Seafortress:SpawnBloodDrinker(positionTable[i]+RandomVector(k*100), RandomVector(1))
          Seafortress:AddPatrolArguments(elemental, 20, 4, 260, patrolPositionTable)
        end

      end)
    end
  end)

  Timers:CreateTimer(2, function()
    Seafortress:SpawnDragoon(Vector(-13760, 3456), Vector(0,-1))
    Seafortress:SpawnDragoon(Vector(-13184, 3456), Vector(0,-1))
    Seafortress:SpawnDragoon(Vector(-12746, 3213), Vector(1,0))
    Seafortress:SpawnDragoon(Vector(-12224, 3452), Vector(0,-1))

    Seafortress:SpawnDragoon(Vector(-11328, 3379), Vector(0,-1))

    Seafortress:SpawnDragoon(Vector(-12895, 4864), Vector(1,-1))
    Seafortress:SpawnDragoon(Vector(-12224, 5312), Vector(0,-1))

    Seafortress:SpawnDragoon(Vector(-11136, 4736), Vector(-1,0))
    Seafortress:SpawnDragoon(Vector(-11136, 5312), Vector(-1,0))

    Seafortress:SpawnDragoon(Vector(-14528, 6272), Vector(1,0))
    Seafortress:SpawnDragoon(Vector(-14976, 6272), Vector(1,0))
  end)

  Timers:CreateTimer(4, function()
    local positionTable = {Vector(-7098, 3669), Vector(-8832, 4530), Vector(-9792, 3520), Vector(-10304, 5318), Vector(-9684, 6400), Vector(-8110, 5550), Vector(-6912, 6431), Vector(-6433, 4929)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        local elemental = Seafortress:SpawnMantaRider(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 20, 4, 260, patrolPositionTable)

      end)
    end
  end)

  Timers:CreateTimer(12, function()
    Seafortress:SpawnSaltwaterDemon(Vector(-6915, 2688), Vector(-1,1))
    for i = 0, 4, 1 do
      Seafortress:SpawnBloodDrinker(Vector(-7552+(256*i), 3072), Vector(0,1))
    end
  end)
end

function Seafortress:SpawnWaterBug(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_water_bug", position, 1, 1, "Seafortress.WaterBug.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 255)
  queen.reduc = 0.5
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SpawnSaltwaterDemon(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_saltwater_demon", position, 3, 5, "Seafortress.SaltwaterDemon.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 220, 255)
  queen.reduc = 0.02
  Events:AdjustBossPower(queen, 10, 10, false)
  Seafortress:SetPositionCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnPassageTitan(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_sea_passage_titan", position, 1, 3, "Seafortress.SeaTitan.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(0, 190, 255)
  Events:ColorWearables(queen, Vector(0, 190, 255))
  queen.reduc = 0.1
  Events:AdjustBossPower(queen, 10, 10, false)
  Seafortress:SetTargetCastArgs(queen, 700, 0, 1, FIND_ANY_ORDER)
  -- Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  return queen
end

function Seafortress:InitiateBehindFloodArea()
    local walls = Entities:FindAllByNameWithin("BehindFloodWall", Vector(-4800, -2700, -96+Seafortress.ZFLOAT), 4900)
    Seafortress:Walls(false, walls, true, 4)
    Seafortress:RemoveBlockers(4, "BehindFloodBlocker", Vector(-4864, -2688, 191+Seafortress.ZFLOAT), 5000) 

    for i = 0, 6, 1 do
      Timers:CreateTimer(i*0.3, function()
        Seafortress:SpawnDiscipleOfPoseidon(Vector(-6437+(256*i), -2301), Vector(0,-1))
      end)
    end

    for i = 0, 6, 1 do
      Timers:CreateTimer(i*0.42, function()
        Seafortress:SpawnDiscipleOfPoseidon(Vector(-4160+(256*i), -2301), Vector(0,-1))
      end)
    end

    for i = 0, 4, 1 do
       Timers:CreateTimer(i*0.3, function()
        Seafortress:SpawnPassageTitan(Vector(-4050+(356*i),-1984), Vector(0,-1))
       end)
    end
    for i = 0, 4, 1 do
      Timers:CreateTimer(i*0.2, function()
       Seafortress:SpawnPassageTitan(Vector(-6376+(356*i),-1984), Vector(0,-1))
      end)
    end

    Timers:CreateTimer(6, function()
      for i = 0, 7, 1 do
        Seafortress:SpawnTemplarAssassin(Vector(-6446+(580*i), -1536), Vector(0,-1))
      end
    end)

    local zealot = Seafortress:SpawnPoseidonZealot(Vector(-4584, -1280), Vector(0,-1))
    zealot.deathCode = 15
end

function Seafortress:SpawnPoseidonZealot(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_poseidon_zealot", position, 3, 6, "Seafortress.DiscipleOfPoseidon.Aggro", fv, false)
  Timers:CreateTimer(0.2, function()
    queen:AddNewModifier(Events.GameMaster, nil, "modifier_animation", {translate="attack_normal_range"})
    queen:AddNewModifier(Events.GameMaster, nil, "modifier_animation_translate", {translate="run"})
  end)
  queen.reduc = 0.02
  Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetPositionCastArgs(queen, 1000, 0, 1, FIND_ANY_ORDER)

  return queen
end

function Seafortress:SpawnBladewarrior(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_raging_bladewarrior", position, 1, 3, "Seafortress.BladeWarrior.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 220, 255)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 10, 10, false)
  queen:SetRenderColor(0, 190, 255)
  Events:ColorWearables(queen, Vector(0, 190, 255))
  queen:AddNewModifier(queen, nil, "modifier_animation", {translate="run_fast"})
  return queen
end

function Seafortress:SpawnWaterSummoner(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_water_summoner", position, 1, 2, "Seafortress.WaterSummoner.Aggro", fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.maxSummons = 3
  queen.targetRadius = 720
  queen.autoAbilityCD = 1
  queen.reduc = 0.2
  queen.dominion = true
  return queen
end

function Seafortress:SpawnSummonedFaceless(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("water_temple_faceless_water_elemental", position, 0, 0, nil, fv, false)
  queen:SetRenderColor(100, 255, 255)
  Seafortress:SetPositionCastArgs(queen, 1000, 0, 1, FIND_ANY_ORDER)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.3
  return queen
end

function Seafortress:SpawnAxemaster(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_troll_axemaster", position, 1, 3, "Seafortress.Axelord.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 220, 255)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 10, 10, false)
  queen:SetRenderColor(0, 190, 255)
  Events:ColorWearables(queen, Vector(0, 190, 255))
  return queen
end

function Seafortress:SpawnSapphireDragon(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sapphire_dragon", position, 1, 3,"Seafortress.DragonSpawn.Aggro", fv, false)
  queen.reduc = 0.01
  Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetRenderColor(30, 200, 255)

  return queen
end

function Seafortress:SpawnSlicer(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_slicer", position, 1, 3, "Seafortress.Slicer.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 220, 255)
  queen.reduc = 0.3
  Events:AdjustBossPower(queen, 10, 10, false)
  queen:SetRenderColor(0, 190, 255)
  Events:ColorWearables(queen, Vector(0, 190, 255))
  return queen
end

function Seafortress:AfterZealotRoom()
  for i = 0, 2, 1 do
    for j = 0, 2, 1 do
      Seafortress:SpawnBladewarrior(Vector(-4928+(i*256), 896+(j*256)), Vector(0,-1))
    end
  end
  Timers:CreateTimer(1, function()
    for i = 0, 1, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnAxemaster(Vector(-5704+(i*256), 896+(j*256)), Vector(1,0))
      end
    end
  end)
  Timers:CreateTimer(2, function()
    for i = 0, 1, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnWaterSummoner(Vector(-6336+(i*256), 203+(j*256)), Vector(0,1))
      end
    end
  end)
  Seafortress:SpawnPassageTitan(Vector(-6089, 1088), Vector(1,0))
  Timers:CreateTimer(3, function()
    local positionTable = {Vector(-5696, -576), Vector(-5632, 256), Vector(-6848, 1024), Vector(-6080, 1728)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(-6144, 640) - positionTable[i]):Normalized()
      Seafortress:SpawnFairyDragon(positionTable[i], lookToPoint)
    end
  end)
  Timers:CreateTimer(4, function()
    for i = 0, 1, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnDiscipleOfPoseidon(Vector(-3584+(i*256), 128+(j*256)), Vector(0,1))
      end
    end
  end)

  Timers:CreateTimer(6, function()
    for i = 0, 3, 1 do
      for j = 0, 2, 1 do
        if j%2 == 0 then
          Seafortress:SpawnAxemaster(Vector(-4152+(i*256), 1600+(j*256)), Vector(0,-1))
        elseif i%2 == 0 then
          Seafortress:SpawnBladewarrior(Vector(-4152+(i*256), 1600+(j*256)), Vector(0,-1))
        else
          Seafortress:SpawnFortressCentaur(Vector(-4152+(i*256), 1600+(j*256)), Vector(0,-1))
        end
      end
    end
  end)

  Timers:CreateTimer(7, function()
    for i = 0, 2, 1 do
      Seafortress:SpawnWaterSummoner(Vector(-3008+(i*300), 1216), Vector(-1,0))
    end
  end)

  Timers:CreateTimer(8, function()
    for i = 0, 1, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnPassageTitan(Vector(-3904+(i*256), 832+(j*256)), Vector(-1,0))
      end
    end
  end)
  Timers:CreateTimer(9, function()
    Seafortress:SpawnSapphireDragon(Vector(-5888, 704), Vector(1,1))
    Seafortress:SpawnSapphireDragon(Vector(-1920, -320), Vector(-1,1))
    Seafortress:SpawnSapphireDragon(Vector(-2048, 2565), Vector(-1,-1))
    Seafortress:SpawnSapphireDragon(Vector(-5120, 1792), Vector(1,-1))

    Seafortress:SpawnOceanElemental(Vector(-5056, 2624), Vector(1,0))
  end)

  Timers:CreateTimer(10, function()
    local positionTable = {Vector(-1344, -448), Vector(-1408, 1344), Vector(-1216, 2752), Vector(-2752, 3072), Vector(-4032, 3200)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(-3905, 1309) - positionTable[i]):Normalized()
      Seafortress:SpawnFairyDragon(positionTable[i], lookToPoint)
    end
  end)

  Timers:CreateTimer(11, function()
    for i = 0, 2, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnBladewarrior(Vector(-3008+(i*256), -384+(j*256)), Vector(0,1))
      end
    end
  end)

  Timers:CreateTimer(12, function()
    for i = 0, 1, 1 do
      for j = 0, 6, 1 do
        Seafortress:SpawnSlicer(Vector(-2048+(i*256), 192+(j*340)), Vector(-1,0))
      end
    end
  end)

  Timers:CreateTimer(13, function()
      for j = 0, 4, 1 do
        Seafortress:SpawnSlicer(Vector(-3584+(j*256), 2560), Vector(0,-1))
      end
  end)
end

function Seafortress:SpawnSeaDragonWarrior(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_sea_dragon_warrior", position, 1, 3, nil, fv, true)
  queen.dominion = true
  queen:SetRenderColor(100, 220, 255)
  queen.reduc = 0.05
  Events:AdjustBossPower(queen, 10, 10, false)
  queen:SetRenderColor(0, 190, 255)
  Events:ColorWearables(queen, Vector(0, 190, 255))
  queen:SetAbsOrigin(queen:GetAbsOrigin()+Vector(0,0,1500))
  queen.jumpEnd = "basic_dust"
  Timers:CreateTimer(1.5, function()
    EmitSoundOn("Seafortress.SeaDragonWarrior.Aggro", queen)
    StartAnimation(queen, {duration=2, activity=ACT_DOTA_SPAWN, rate=0.8})
  end)
  WallPhysics:Jump(queen, Vector(1,0), 0, 2, 5, 1)
  return queen
end

function Seafortress:SpawnZombiePirate(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_wandering_pirate", position, 1, 3, "Seafortress.WanderingZombie.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(0, 190, 255)
  -- Events:ColorWearables(queen, Vector(0, 190, 255))
  queen.reduc = 0.1
  Events:AdjustBossPower(queen, 10, 10, false)
  Seafortress:SetPositionCastArgs(queen, 700, 0, 1, FIND_ANY_ORDER)
  -- Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  return queen
end

function Seafortress:SpawnDarkSpirit(position, fv, bBase)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_dark_spirit", position, 3, 3, "Seafortress.DarkSpirit.Aggro", fv, false)
  -- Events:ColorWearables(queen, Vector(0, 190, 255))
  queen.reduc = 0.05
  Events:AdjustBossPower(queen, 10, 10, false)
  local ability = queen:FindAbilityByName("seafortress_dark_spirit_passive")
  if bBase then
    ability:ApplyDataDrivenModifier(queen, queen, "modifier_dark_spirit_prepare", {})
  end
  -- Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  return queen
end

function Seafortress:AfterDragonRoom()
  for i = 0, 2, 1 do
    local bolg = Seafortress:SpawnBigBlueFurbolg(Vector(54+(i*400), 256), Vector(-1,0))
    bolg.deathCode = 19
  end
  for i = 0, 1, 1 do
    local bolg = Seafortress:SpawnBigBlueFurbolg(Vector(1792, 888+(i*400)), Vector(0,-1))
    bolg.deathCode = 19
  end
  local positionTable = {Vector(-256, 896), Vector(185, 874), Vector(-64, 1223), Vector(320, 1445), Vector(783, 1446), Vector(1152, 977), Vector(2287, 1243), Vector(2287, 832), Vector(125, -564), Vector(512, -424), Vector(960, -553), Vector(1536, -461)}
  Timers:CreateTimer(2, function()
    for i = 1, #positionTable, 1 do
      Seafortress:SpawnSpearback(positionTable[i], RandomVector(1))
    end
  end)
  Timers:CreateTimer(3, function()
     Seafortress:SpawnFortressCentaur(Vector(2088, -353), Vector(-1,1))
  end)
end

function Seafortress:SpawnDeepRoom4()
  local spirit = Seafortress:SpawnDarkSpirit(Vector(12928, 1536, 16), Vector(0,-1), true)
  spirit.deathCode = 17

  Timers:CreateTimer(2, function()
    local positionTable = {Vector(12736, 896), Vector(13075, 640), Vector(13448, 385)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(11968, 128) - positionTable[i]):Normalized()
      Seafortress:SpawnDarkSunderer(positionTable[i], lookToPoint)
    end
  end)
  Timers:CreateTimer(3, function()
    for i = 0, 1, 1 do
      for j = 0, 3, 1 do
        Seafortress:SpawnSoulSplicer(Vector(14400+(i*256), 768+(j*280)), Vector(-1,0))
      end
    end
  end)
end

function Seafortress:FirstPirateRoom()
  Timers:CreateTimer(0, function()
    local positionTable = {Vector(6272, 11618), Vector(8768, 12160), Vector(11968, 11008)}
    for i = 1, #positionTable, 1 do
      EmitSoundOnLocationWithCaster(positionTable[i], "Seafortress.OceanWaves", Seafortress.Master)
    end
    for i = 1, #MAIN_HERO_TABLE, 1 do
      CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "update_zone_display", {zoneName = "rpc_sea_fortress"} )
    end
    return 13
  end)

  Timers:CreateTimer(0.1, function()
    local positionTable = {Vector(14144, 4544), Vector(14621, 4864)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(14807, 3775) - positionTable[i]):Normalized()
      Seafortress:SpawnZombiePirate(positionTable[i], lookToPoint)
    end
  end)


  local mineLocTable1 = {Vector(14519, 4989), Vector(13501, 4546), Vector(13543, 5440), Vector(12416, 5113), Vector(11931, 5619), Vector(12750, 6720)}
  local mineLocTable2 = {Vector(10880, 6912), Vector(10677, 7961), Vector(9420, 6905), Vector(8554, 7187), Vector(8554, 8320), Vector(9303, 8818)}
  local mineLocTable3 = {Vector(6848,7040), Vector(6848, 8640), Vector(6115, 9608), Vector(6130, 10535), Vector(7552, 10032), Vector(7205, 11008), Vector(7665, 11614)}
  local mineLocTable4 = {Vector(10872,10944), Vector(10437, 9600), Vector(11686, 8478), Vector(12996, 9216), Vector(12761, 9882)}

  local minePosTable = {}
  table.insert(minePosTable, mineLocTable1[RandomInt(1,#mineLocTable1)])
  table.insert(minePosTable, mineLocTable2[RandomInt(1,#mineLocTable2)])
  table.insert(minePosTable, mineLocTable3[RandomInt(1,#mineLocTable3)])
  table.insert(minePosTable, mineLocTable4[RandomInt(1,#mineLocTable4)])

  for i = 1, #minePosTable, 1 do
    local mine = CreateUnitByName("npc_dummy_unit", minePosTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
    mine:SetOriginalModel("models/sea_fortress/zombie_mine.vmdl")
    mine:SetModel("models/sea_fortress/zombie_mine.vmdl")
    local mineAbility = mine:AddAbility("seafortress_zombie_mine_ability")
    mineAbility:SetLevel(1)
    mineAbility:ApplyDataDrivenModifier(mine, mine, "modifier_zombie_mine", {})
    mine:SetAbsOrigin(mine:GetAbsOrigin()+Vector(0,0,RandomInt(130,150)))
    mine:SetModelScale(1.5)
    mine:SetRenderColor(123, 199, 114)
    mine.jumpLock = true
    mine.pushLock = true
    local gravePos = Vector(4601, 8448)
    if i == 2 then
      gravePos = Vector(4985, 8448)
    elseif i == 3 then
      gravePos = Vector(5370, 8448)
    elseif i == 4 then
      gravePos = Vector(5754, 8448)
    end
    mine.gravePos = gravePos
  end

  Timers:CreateTimer(2, function()
    local positionTable = {Vector(13632, 5312), Vector(13504, 4608), Vector(13056, 4982)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(13504, 4992) - positionTable[i]):Normalized()
      Seafortress:SpawnDeckhand(positionTable[i], lookToPoint)
    end
    Seafortress:SpawnZombiePirate(Vector(13557, 4982), Vector(1,-1))
    Seafortress:SpawnSeaPortal(Vector(15147, 4224), Vector(-1,-0.2))
    Seafortress:SpawnSeaPortal(Vector(15232, 3968), Vector(-1,0))
  end)

  Timers:CreateTimer(4, function()
    local positionTable = {Vector(8576, 7111), Vector(10621, 7543), Vector(11840, 6784), Vector(13120, 5399)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*1.2, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end
        for k = 0, 1, 1 do
          local elemental = Seafortress:SpawnZombiedSeafarer(positionTable[i]+RandomVector(k*240), RandomVector(1))
          Seafortress:AddPatrolArguments(elemental, 20, 4, 260, patrolPositionTable)
        end

      end)
    end
  end)

  Timers:CreateTimer(5, function()
    local positionTable = {Vector(12032, 5504), Vector(12032, 5760), Vector(13056, 6080), Vector(12736, 6323), Vector(12416, 6616)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(12736, 5696) - positionTable[i]):Normalized()
      Seafortress:SpawnCephapolos(positionTable[i], lookToPoint)
    end
    Seafortress:SpawnBarnacleBehemoth(Vector(12864, 6656), Vector(-1,-1))

    Seafortress:SpawnDarkSunderer(Vector(11954, 6976), Vector(1,-0.5))
    Seafortress:SpawnDarkSunderer(Vector(11712, 6592), Vector(1,-0.2))
  end)

  Timers:CreateTimer(6, function()
    local positionTable = {Vector(10832, 7808), Vector(11072, 6976), Vector(10816, 6976)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(11200, 7232) - positionTable[i]):Normalized()
      Seafortress:SpawnZombiedSeafarer(positionTable[i], lookToPoint)
    end
    Seafortress:SpawnCephapolos(Vector(11328, 7424), Vector(0,-1))
    Seafortress:SpawnCephapolos(Vector(10816, 6976), Vector(1,1))
  end)

  Timers:CreateTimer(7, function()
    for i = 0, 2, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnZombiePirate(Vector(8937+(i*280), 7550+(j*322)), Vector(1,0))
      end
    end
  end)

  Timers:CreateTimer(8, function()
    for i = 0, 2, 1 do
      Seafortress:SpawnDeckhand(Vector(8768+(i*386), 8163), Vector(0,-1))
    end
    Seafortress:SpawnBarnacleBehemoth(Vector(9472, 8768), Vector(-0.3,-1))
  end)
  Timers:CreateTimer(9, function()
    for i = 0, 1, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnGhostPirate(Vector(8866+(i*310), 6976+(j*260)), Vector(0,1))
      end
    end
  end)
  Timers:CreateTimer(12, function()
    local positionTable = {}
    for k = 0, 9, 1 do
      local newPos = Vector(5632, 6833) + Vector(RandomInt(1,1800), RandomInt(1,1600))
      table.insert(positionTable, newPos)
    end
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*0.6, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end

        local elemental = Seafortress:SpawnRainGargoyle(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 30, 2, 260, patrolPositionTable)

      end)
    end
  end)
  Timers:CreateTimer(14, function()
    local positionTable = {Vector(6464, 10240), Vector(6652, 10624), Vector(7048, 10830), Vector(7296, 9920), Vector(7587, 10114)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(6976, 10368) - positionTable[i]):Normalized()
      Seafortress:SpawnRainGargoyle(positionTable[i], lookToPoint)
    end
  end)
  Timers:CreateTimer(16, function()
    local positionTable = {}
    for k = 0, 8, 1 do
      local newPos = Vector(11264, 9088) + Vector(RandomInt(1,1700), RandomInt(1,1300))
      table.insert(positionTable, newPos)
    end
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*0.6, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end

        local elemental = Seafortress:SpawnRainGargoyle(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 30, 2, 260, patrolPositionTable)

      end)
    end
  end)

  Timers:CreateTimer(18, function()
    local positionTable = {Vector(11712, 8704), Vector(12224, 8610), Vector(12626, 9152), Vector(12889, 9600)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(11492, 9755) - positionTable[i]):Normalized()
      Seafortress:SpawnCephapolos(positionTable[i], lookToPoint)
    end
  end)

  Timers:CreateTimer(19, function()
    Seafortress:SpawnGhostSeal(Vector(8000, 11328), Vector(1,1))
    Seafortress:SpawnGhostSeal(Vector(7616, 11520), Vector(-1,1))
    Seafortress:SpawnGhostSeal(Vector(7232, 11200), Vector(0,-1))
    local positionTable = {Vector(8958, 10060), Vector(9298, 10432), Vector(9596, 10112), Vector(9705, 10496), Vector(9984, 10206), Vector(9984, 11520), Vector(10496, 11217), Vector(10972, 10880), Vector(11327, 10449), Vector(11712, 10505)}
    for i = 1, #positionTable, 1 do
      Seafortress:SpawnGhostSeal(positionTable[i], RandomVector(1))
    end
  end)

  Timers:CreateTimer(21, function()
    local positionTable = {Vector(9753, 11468), Vector(10816, 10556), Vector(11904, 10219)}
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*0.6, function()
        local patrolPositionTable = {}
        for j = 1, #positionTable, 1 do
          local index = i + j
          if index > #positionTable then
            index = index - #positionTable
          end
          table.insert(patrolPositionTable, positionTable[index])
        end

        local elemental = Seafortress:SpawnGhostSeal(positionTable[i], RandomVector(1))
        Seafortress:AddPatrolArguments(elemental, 30, 2, 260, patrolPositionTable)

      end)
    end
  end)

  Timers:CreateTimer(20, function()
    if Seafortress.PaladinArcana then
      Seafortress:SpawnPaladinArcanaGolems()
    end
  end)
end

function Seafortress:SpawnBarnacleColossus(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_barnacle_colossus", position, 1, 3, "Seafortress.Barnacle.Aggro", fv, false)
  queen.cantAggro = true
  -- queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.005
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier( queen, nil, "modifier_movespeed_cap_super", {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  Seafortress:SetTargetCastArgs(queen, 400, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnDeckhand(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_deckhand", position, 1, 1, "Seafortress.Deckhand.Aggro", fv, false)
  queen.dominion = true
  -- queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.3
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SpawnZombiedSeafarer(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_zombied_seafarer", position, 1, 1, "Seafortress.Seafarer.Aggro", fv, false)
  queen.dominion = true
  -- queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetPositionCastArgs(queen, 800, 0, 1, FIND_ANY_ORDER)
  queen.randomMissMin = 60
  queen.randomMissMax = 220
  return queen
end

function Seafortress:SpawnDrownedWraith(position, fv)
  local queen = Seafortress:SpawnDungeonUnit( "seafortress_drowned_wraith", position, 0, 0, "Seafortress.DrownedWraith.Aggro", fv, true)
  queen.dominion = true

  queen.reduc = 0.3

  return queen
end

function Seafortress:SpawnRainGargoyle(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_rain_gargoyle", position, 0, 1, "Seafortress.RainGargoyle.Aggro", fv, false)
  queen.dominion = true

  queen.reduc = 0.3

  return queen
end

function Seafortress:SpawnGhostSeal(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_ghost_seal", position, 0, 1, "Seafortress.GhostSeal.Aggro", fv, false)
  queen.dominion = true

  queen.reduc = 0.04

  return queen
end

function Seafortress:all_graves_lit()
  print("ALL GRAVES LIT")
  local colossus = Seafortress:SpawnBarnacleColossus(Vector(5069, 8975), Vector(0,-1))
  colossus:SetAbsOrigin(Vector(5069, 8975, -1000+Seafortress.ZFLOAT))
  colossus.jumpEnd = "hermit"
  colossus.deathCode = 18
  Seafortress:smoothSizeChange(colossus, 0.2, 1.8, 60)
  for i = 1, 50, 1 do
    Timers:CreateTimer(i*0.03, function()
      if i%10 == 0 then
        ScreenShake(colossus:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
        EmitSoundOnLocationWithCaster(colossus:GetAbsOrigin(), "Seafortress.Colossus.Shake", Events.GameMaster)
      end
      colossus:SetAbsOrigin(colossus:GetAbsOrigin()+Vector(0,0,20))
    end)
  end
  Timers:CreateTimer(1.0, function()
      local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, colossus)
      ParticleManager:SetParticleControl( particle1, 0, colossus:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,80) )
      Timers:CreateTimer(4, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
  end)
  Timers:CreateTimer(1.5, function()
      local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, colossus)
      ParticleManager:SetParticleControl( particle1, 0, colossus:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,80) )
      EmitSoundOn("Tanari.WaterSplash", colossus)
      Timers:CreateTimer(4, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)

      WallPhysics:Jump(colossus, Vector(0,-1), 22, 33, 30, 1.0)
      StartAnimation(colossus, {duration=0.9, activity=ACT_DOTA_FORCESTAFF_END, rate=1.0})
      Timers:CreateTimer(1.6, function()
        local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
        ParticleManager:SetParticleControl(pfx, 0, colossus:GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 5, Vector(0.5, 0.9, 0.5))
        ParticleManager:SetParticleControl(pfx, 2, Vector(0.7,0.7,0.7))
        Timers:CreateTimer(10, function() 
          ParticleManager:DestroyParticle( pfx, false )
          ParticleManager:ReleaseParticleIndex(pfx)
        end)
        ScreenShake(colossus:GetAbsOrigin(), 300, 0.5, 0.5, 9000, 0, true)
        StartAnimation(colossus, {duration=0.9, activity=ACT_DOTA_FORCESTAFF_END, rate=1.0})
        Timers:CreateTimer(1, function()
          
          EmitSoundOn("Seafortress.Colossus.Init", colossus)
          Timers:CreateTimer(0.65, function()
            StartAnimation(colossus, {duration=4, activity=ACT_DOTA_VICTORY, rate=1.1})
          end)
          Timers:CreateTimer(2.05, function()
            EmitSoundOn("Seafortress.Colossus.Roar", colossus)
          end)
          Timers:CreateTimer(4.6, function()
            colossus:RemoveModifierByName("modifier_disable_player")
            colossus.cantAggro = false
            Dungeons:AggroUnit(colossus)
          end)
        end)
      end)
  end)
end

function Seafortress:SpawnStalacorr(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_stalacorr", position, 4, 5, "Seafortress.Stalakor.Aggro", fv, false)

  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.05
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetTargetCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
  local ability = queen:FindAbilityByName("stalacorr_passive")
  queen.cantAggro = true
  ability:ApplyDataDrivenModifier(queen, queen, "modifier_disable_player", {duration = 6.0})
  queen.dominion = true
  for i = 0, 4, 1 do
    Timers:CreateTimer(i*1.5, function()
      ScreenShake(queen:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
      local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, queen )
      ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(queen:GetAbsOrigin(), queen) )
      ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
      end)
      EmitSoundOnLocationWithCaster(queen:GetAbsOrigin(), "Seafortress.Colossus.Shake", Events.GameMaster)
    end)
  end
  
  Timers:CreateTimer(6.0, function()
    queen.cantAggro = false
    Dungeons:AggroUnit(queen)

  end)
  return queen
end


function Seafortress:SpawnBigBlueFurbolg(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_big_blue_furbolg", position, 2, 4, "Seafortress.Furbolg.Aggro", fv, false)
  queen.dominion = true
  -- queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.07
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Seafortress:SpawnDarkReefGuard(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_dark_reef_guard", position, 1, 1, "Seafortress.DarkReefGuard.Aggro", fv, false)
  queen.dominion = true
  -- queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:SpawnDarkReefTempleRoom()
  for i = 0, 4, 1 do
    for j = 0, 1, 1 do
      Seafortress:SpawnDarkReefGuard(Vector(192, 2560)+Vector(i*256, j*256), Vector(1,0))
    end
  end
  Timers:CreateTimer(1, function()
    Seafortress:SpawnBigBlueFurbolg(Vector(-240, 3392), Vector(0,-1))
  end)

  Timers:CreateTimer(3, function()
    local positionTable = {Vector(-1536, 4224), Vector(256, 4224), Vector(256, 5952), Vector(-1536, 5952)}
    for i = 1, #positionTable, 1 do
      local elite = Seafortress:SpawnDarkReefElite(positionTable[i], Vector(0,-1))
      elite.deathCode = 20
    end
  end)

  Timers:CreateTimer(4, function()
    for i = 0, 5, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnFeatherGuard(Vector(-1280, 4160)+Vector(i*250, j*1840), Vector(0,-1))
      end
    end
  end)

  Timers:CreateTimer(5, function()
    for i = 0, 3, 1 do
      for j = 0, 1, 1 do
        Seafortress:SpawnDarkReefGuard(Vector(-1600, 4672)+Vector(j*1800, i*280), Vector(0,-1))
      end
    end
  end)
end

function Seafortress:SpawnDarkReefElite(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("dark_reef_elite", position, 1, 3, "Seafortress.DarkReefElite.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.09
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  queen.castAnimation = ACT_DOTA_CAST_ABILITY_4
  Seafortress:SetTargetCastArgs(queen, 900, 0, 6, FIND_FARTHEST)
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:SpawnFeatherGuard(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_featherguard", position, 0, 1, "Seafortress.NagaFeatherguard.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.3
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:SpawnSkultoth(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("dark_reef_skhultoth", position, 4, 6, nil, fv, false)
  queen.state = 0
  queen.reduc = 0.02
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetRenderColor(0, 0, 255)
  Seafortress:smoothSizeChange(queen, 0.3, 3.5, 45)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  EmitSoundOnLocationWithCaster(queen:GetAbsOrigin(), "Seafortress.Colossus.Shake", Events.GameMaster)
    local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
    ParticleManager:SetParticleControl(pfx, 0, queen:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
    ParticleManager:SetParticleControl(pfx, 2, Vector(0.5,0.5,0.5))
    Timers:CreateTimer(10, function() 
      ParticleManager:DestroyParticle( pfx, false )
      ParticleManager:ReleaseParticleIndex(pfx)
    end)
    ScreenShake(queen:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
    Timers:CreateTimer(2.25, function()
      StartAnimation(queen, {duration=4.2, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.57})
      EmitSoundOnLocationWithCaster(queen:GetAbsOrigin(), "Seafortress.Skultoth.Spawn", Events.GameMaster) 
      Timers:CreateTimer(4.5, function()
        queen.state = 1
      end)
    end)  
    Seafortress.NagaSummonerReefBoss = queen
    queen.deathCode = 22
  return queen
  
end

function Seafortress:FinalRoom(index)
  if not Seafortress.FinalRoomInit then
    Seafortress.FinalRoomInit = true
    Seafortress.ThreeBossTable = {0, 0, 0}
    Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(2052, 7241, 270+Seafortress.ZFLOAT), Events.GameMaster, 0, Vector(0.55, 0.55, 0.55))
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(2052, 7241, 270+Seafortress.ZFLOAT), 400, 5000, false)
  end
  if index == 1 then
    local particle1 = ParticleManager:CreateParticle( "particles/dire_fx/blue_fire_ambience.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl( particle1, 0, Vector(-3904, 8367, 437+Seafortress.ZFLOAT) )
    local particle2 = ParticleManager:CreateParticle( "particles/dire_fx/blue_fire_ambience.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl( particle2, 0, Vector(-2961, 8367, 437+Seafortress.ZFLOAT) )
    Seafortress.ThreeBossTable[index] = 1

    local walls = Entities:FindAllByNameWithin("StatueBoss", Vector(-3456, 9344, -668+Seafortress.ZFLOAT), 800)
    local movementZ = 880/180

    for i = 1, 180, 1 do
      for j = 1, #walls, 1 do
        -- Seafortress:objectShake(walls[j], 180, 5, true, true, false, nil, 30)
        Timers:CreateTimer(i*0.03, function()
          walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
          if j == 1 then
            ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
          end
          if i%30 == 0 and j == 1 then
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Statue.Rising", Events.GameMaster)
          end
          if i %10 == 0 and j == 1 then
            local particleDust = ParticleManager:CreateParticle( "particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
            ParticleManager:SetParticleControl( particleDust, 0, GetGroundPosition(walls[j]:GetAbsOrigin(), Events.GameMaster) )
            Timers:CreateTimer(3, function()
              ParticleManager:DestroyParticle(particleDust, false)
            end)

          end
          if i == 180 and j == 1 then
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Statue.RisingEnd", Events.GameMaster)
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Colossus.Shake", Seafortress.Master)
            Seafortress.ThreeBossTable[index] = 2
            local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
            ParticleManager:SetParticleControl(pfx, 0, walls[j]:GetAbsOrigin()+Vector(0,0,60))
            ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 0.2))
            ParticleManager:SetParticleControl(pfx, 2, Vector(0.8,0.8,0.8))
            Timers:CreateTimer(10, function() 
              ParticleManager:DestroyParticle( pfx, false )
              ParticleManager:ReleaseParticleIndex(pfx)
            end)
          end
        end)
      end
    end
  elseif index == 2 then
    local particle1 = ParticleManager:CreateParticle( "particles/dire_fx/blue_fire_ambience.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl( particle1, 0, Vector(-1600, 8367, 437+Seafortress.ZFLOAT) )
    local particle2 = ParticleManager:CreateParticle( "particles/dire_fx/blue_fire_ambience.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl( particle2, 0, Vector(-640, 8367, 437+Seafortress.ZFLOAT) )
    Seafortress.ThreeBossTable[index] = 1

    local walls = Entities:FindAllByNameWithin("StatueBoss", Vector(-1124, 9315, -418+Seafortress.ZFLOAT), 800)
    local movementZ = 590/180

    for i = 1, 180, 1 do
      for j = 1, #walls, 1 do
        -- Seafortress:objectShake(walls[j], 180, 5, true, true, false, nil, 30)
        Timers:CreateTimer(i*0.03, function()
          walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
          if j == 1 then
            ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
          end
          if i%30 == 0 and j == 1 then
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Statue.Rising", Events.GameMaster)
          end
          if i %10 == 0 and j == 1 then
            local particleDust = ParticleManager:CreateParticle( "particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
            ParticleManager:SetParticleControl( particleDust, 0, GetGroundPosition(walls[j]:GetAbsOrigin(), Events.GameMaster) )
            Timers:CreateTimer(3, function()
              ParticleManager:DestroyParticle(particleDust, false)
            end)

          end
          if i == 180 and j == 1 then
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Statue.RisingEnd", Events.GameMaster)
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Colossus.Shake", Seafortress.Master)
            Seafortress.ThreeBossTable[index] = 2
            local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
            ParticleManager:SetParticleControl(pfx, 0, walls[j]:GetAbsOrigin()+Vector(0,0,60))
            ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
            ParticleManager:SetParticleControl(pfx, 2, Vector(0.7,0.7,0.7))
            Timers:CreateTimer(10, function() 
              ParticleManager:DestroyParticle( pfx, false )
              ParticleManager:ReleaseParticleIndex(pfx)
            end)
          end
        end)
      end
    end
  elseif index == 3 then
    local particle1 = ParticleManager:CreateParticle( "particles/dire_fx/blue_fire_ambience.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl( particle1, 0, Vector(704, 8367, 437+Seafortress.ZFLOAT) )
    local particle2 = ParticleManager:CreateParticle( "particles/dire_fx/blue_fire_ambience.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl( particle2, 0, Vector(1664, 8367, 437+Seafortress.ZFLOAT) )
    Seafortress.ThreeBossTable[index] = 1

    local walls = Entities:FindAllByNameWithin("StatueBoss", Vector(1181, 9312, -418+Seafortress.ZFLOAT), 800)
    local movementZ = 780/180

    for i = 1, 180, 1 do
      for j = 1, #walls, 1 do
        -- Seafortress:objectShake(walls[j], 180, 5, true, true, false, nil, 30)
        Timers:CreateTimer(i*0.03, function()
          walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
          if j == 1 then
            ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
          end
          if i%30 == 0 and j == 1 then
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Statue.Rising", Events.GameMaster)
          end
          if i %10 == 0 and j == 1 then
            local particleDust = ParticleManager:CreateParticle( "particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
            ParticleManager:SetParticleControl( particleDust, 0, GetGroundPosition(walls[j]:GetAbsOrigin(), Events.GameMaster) )
            Timers:CreateTimer(3, function()
              ParticleManager:DestroyParticle(particleDust, false)
            end)

          end
          if i == 180 and j == 1 then
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Statue.RisingEnd", Events.GameMaster)
            EmitSoundOnLocationWithCaster(walls[j]:GetAbsOrigin(), "Seafortress.Colossus.Shake", Seafortress.Master)
            Seafortress.ThreeBossTable[index] = 2
            local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
            ParticleManager:SetParticleControl(pfx, 0, walls[j]:GetAbsOrigin()+Vector(0,0,60))
            ParticleManager:SetParticleControl(pfx, 5, Vector(0.0, 0.7, 0.3))
            ParticleManager:SetParticleControl(pfx, 2, Vector(0.7,0.7,0.7))
            Timers:CreateTimer(10, function() 
              ParticleManager:DestroyParticle( pfx, false )
              ParticleManager:ReleaseParticleIndex(pfx)
            end)
          end
        end)
      end
    end
  
  end
end

function Seafortress:SpawnSiltbreakerBoss(position, fv)
  local queen = Seafortress:SpawnUnitNoParagon("seafortress_boss_siltbreaker", position, 7, 9, nil, fv, true)

  queen.reduc = 0.002
  queen.isBossFFS = true
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:AfterPlatformRoom()
  Seafortress:SpawnSeaFortressHydra(Vector(-5312, 6464,127+Seafortress.ZFLOAT), Vector(0,-1))
  Seafortress:SpawnSeaFortressHydra(Vector(-5120, 5568,127+Seafortress.ZFLOAT), Vector(0,1))
  Seafortress:SpawnSeaFortressHydra(Vector(-4224, 5825,127+Seafortress.ZFLOAT), Vector(0,1))

  Timers:CreateTimer(1, function()
    for i = 0, 1, 1 do
      for j = 0, 2, 1 do
        Seafortress:SpawnOceanCentaur(Vector(-3865, 6183)+Vector(i*240,j*240), Vector(-1,0))
      end
    end
  end)
  Timers:CreateTimer(2, function()
    local master = Seafortress:SpawnOceanCentaurMaster(Vector(-3250, 6344), Vector(-1,0))
    master.deathCode = 23
  end)
end

function Seafortress:SpawnOceanCentaur(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_ocean_centaur", position, 1, 1, "Seafortress.OceanCentaur.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.1
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetTargetCastArgs(queen, 900, 0, 2, FIND_ANY_ORDER)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:SpawnOceanCentaurMaster(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_oceanrunner_arkguil", position, 1, 1, "Seafortress.OceanRunner.Aggro", fv, false)
  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.1
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetTargetCastArgs(queen, 900, 0, 2, FIND_ANY_ORDER)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end


function Seafortress:SpawnOceanGiantBoss(position, fv)
  local queen = Seafortress:SpawnUnitNoParagon("seafortress_boss_silver_sea_giant", position, 7, 9, nil, fv, true)
  queen:SetRenderColor(0, 255, 240)
  queen.reduc = 0.001
  queen.isBossFFS = true
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:SpawnOracleOfSea(position, fv)
  local queen = Seafortress:SpawnUnitNoParagon("seafortress_oracle_of_the_sea", position, 7, 9, nil, fv, true)
  queen.reduc = 0.002
  queen.isBossFFS = true
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:AllBossesSlain()
    Seafortress.AllBossesSlainEffect = true
    for i = 1, #MAIN_HERO_TABLE, 1 do
      CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
    end
    Timers:CreateTimer(5, function()
      Seafortress:SpawnLastArea()
      AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-1152, 10240, 197+Seafortress.ZFLOAT), 2000, 10, false)
      Dungeons:CreateBasicCameraLockForHeroes(Vector(-1152, 10240, 197+Seafortress.ZFLOAT), 9.2, MAIN_HERO_TABLE)
      EmitGlobalSound("Seafortress.EpicBossOpen")
      Timers:CreateTimer(1, function()

        local wall = Entities:FindByNameNearest("SeafortressEpicDoor", Vector(-1056, 10576, 556+Seafortress.ZFLOAT), 700)
        Seafortress:Walls(false, {wall}, true, 5)
        Seafortress:RemoveBlockers(5, "SeafortressEpicBlocker", Vector(-1152, 10576, 101+Seafortress.ZFLOAT), 2400)
        for j = 1, 62, 1 do
          Timers:CreateTimer(j*0.1, function()
            for i = 0, 13, 1 do
              local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
              ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(Vector(-1792+(i*100), 10560), Events.GameMaster) )
              ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
              Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(pfx, false)
              end)
            end
          end)
        end
      end)
      Timers:CreateTimer(0, function()
        local positionTable = {Vector(-2624, 12544), Vector(-128, 13952), Vector(-3264, 15552), Vector(-7744, 14272), Vector(-7744, 14272)}
        for i = 1, #positionTable, 1 do
          EmitSoundOnLocationWithCaster(positionTable[i], "Seafortress.OceanWaves", Seafortress.Master)
        end
        return 13
      end)
    end)
    local bahamutMax = 18 - GameState:GetPlayerPremiumStatusCount()*2
    local luck = RandomInt(1, bahamutMax)
    if luck == 1 then
      Timers:CreateTimer(17, function()
        Seafortress:SpawnShadowOfBahamut()
      end)
    end
end

function Seafortress:SpawnLastArea()
    local positionTable = {Vector(-1728, 11328), Vector(-549, 11264), Vector(-627, 11584), Vector(-896, 12300), Vector(-1728, 12300), Vector(-1728, 13056), Vector(-896, 13056)}
    for i = 1, #positionTable, 1 do
      Seafortress:SpawnGhostSeal(positionTable[i], RandomVector(1))
    end
    Seafortress:SpawnAxemaster(Vector(-768, 14080), Vector(1,1))
    Seafortress:SpawnAxemaster(Vector(-1280, 14528), Vector(0.5,1))

    Seafortress:SpawnSeaPortal(Vector(-1938, 14528), Vector(0,-1))

    Seafortress:SpawnOceanDiviner(Vector(-1142, 14068), Vector(0,-1))
    Timers:CreateTimer(2, function()
      Seafortress:SpawnOceanDiviner(Vector(-1408, 14336), Vector(0,-1))
      for i = 0, 2, 1 do
        for j = 0, 2, 1 do
          if i == 1 and j == 1 then
            Seafortress:SpawnOceanWatcher(Vector(-3581+(i*380), 14033+(j*370)), Vector(1,0))
          else
            Seafortress:SpawnSeaPortal(Vector(-3581+(i*380), 14033+(j*370)), Vector(1,0))
          end
        end
      end
    end)
    Timers:CreateTimer(3, function()
      local positionTable = {Vector(-4352, 14592), Vector(-4608, 14512), Vector(-4352, 13958), Vector(-4608, 13888)}
      for i = 1, #positionTable, 1 do
        Timers:CreateTimer(i*0.5, function()
          Seafortress:SpawnOceanDiviner(positionTable[i], Vector(1,0))
        end)
      end
    end)

    Timers:CreateTimer(4.5, function()
      Seafortress:SpawnOceanDiviner(Vector(-5376, 14272), Vector(1,0))
      Seafortress:SpawnOceanDiviner(Vector(-5376, 14528), Vector(1,0))
      Seafortress:SpawnOceanDiviner(Vector(-5376, 14784), Vector(1,0))
      Seafortress:SpawnPassageTitan(Vector(-4992, 14784), Vector(0,-1))
    end)

    Timers:CreateTimer(6, function()
      local maiden = Seafortress:SpawnSeaMaiden(Vector(-6398, 14592), Vector(1,0))
      maiden.deathCode = 25
      local positionTable = {Vector(-6400, 14080), Vector(-6161, 14215), Vector(-6161, 14848), Vector(-6400, 15027)}
      for i = 1, #positionTable, 1 do
        Timers:CreateTimer(i*0.5, function()
          Seafortress:SpawnOceanDiviner(positionTable[i], Vector(1,0))
        end)
      end
    end)
end

function Seafortress:SpawnOceanDiviner(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_ocean_diviner", position, 1, 2, "Seafortress.Diviner.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.06
  Events:AdjustBossPower(queen, 8, 8, false)
  Seafortress:SetTargetCastArgs(queen, 1000, 0, 1, FIND_FARTHEST)
  return queen
end

function Seafortress:SpawnFinalBoss()
local queen = Seafortress:SpawnUnitNoParagon("seafortress_final_boss", Vector(-14272, 13696), 7, 9, nil, Vector(-1,1), false)
	queen.reduc = 0.00125
	queen.isBossFFS = true
	queen.mainBoss = true
	Events:AdjustBossPower(queen, 8, 8, false) 
end

function Seafortress:BossMusic()
  Timers:CreateTimer(2, function()
     for i = 1, #MAIN_HERO_TABLE, 1 do
      CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
      CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Seafortress.FinalBoss.Music1"})
    end
    Timers:CreateTimer(50, function()
      if Seafortress.FinalBossSlain then
      else
           for i = 1, #MAIN_HERO_TABLE, 1 do
            CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
            CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Seafortress.FinalBoss.Music2"})
          end
          return 50
      end
    end)
  end)
end

function Seafortress:SpawnSquidcicle(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_squidcicle", position, 0, 0, nil, fv, true)
  Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.1
  queen.dominion = true
  queen:SetAbsOrigin(queen:GetAbsOrigin()+Vector(0,0,1000))
  WallPhysics:Jump(queen, fv, 0, 0, 0, 1)
  return queen
end

function Seafortress:DefeatFinalBoss(position)
  Timers:CreateTimer(5, function()
        local mithrilReward = 30000*Events.ResourceBonus
        local crystal = CreateUnitByName("arcane_crystal", position+Vector(0,0,1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward*(1+GameState:GetPlayerPremiumStatusCount()*0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward/200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        Timers:CreateTimer(7, function()
          for i = 1, #MAIN_HERO_TABLE, 1 do
            Stars:StarEventPlayer("valdun", MAIN_HERO_TABLE[i])
          end
        end)

        -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #potentialWinnerTable, 1 do
        --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
        --  local completed = completedTable.completed
        --  if completed == 0 then
        --    potentialWinnerTable[i].shardsPickedUp = 0
        --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
        --  end
        -- end

      Statistics.dispatch("sea_fortress:kill:valdun");
      if #crystal.winnerTable > 0 then
          -- for i = 1, #crystal.winnerTable, 1 do
          --   crystal.winnerTable[i].shardsPickedUp = 0
          -- end
          Timers:CreateTimer(1.4, function()
            EmitSoundOn("Resource.MithrilShardEnter", crystal)
          end)
        end
        Seafortress:Music2()
  end)
end

function Seafortress:Music2()
  Timers:CreateTimer(3, function()
       for i = 1, #MAIN_HERO_TABLE, 1 do
        CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
        CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Seafortress.StartingMusic"})
      end
      return 110
  end)
end

function Seafortress:SpawnAhnQhir(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_ahn_qhir", position, 3,4, "Seafortress.Ahnqhir.Aggro", fv, false)
  queen.reduc = 0.05
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier( queen, nil, 'modifier_movespeed_cap_sonic', {} )
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Seafortress:SpawnShadowOfBahamut()
  local spawnPoint = Vector(-1280, 11392)
  local bahamut = Seafortress:SpawnShadowOfBahamutMonster(spawnPoint, Vector(0,-1))
  Seafortress:smoothSizeChange(bahamut, 0.1, 2.5, 50)

  local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
  ParticleManager:SetParticleControl(pfx, 0, bahamut:GetAbsOrigin())
  ParticleManager:SetParticleControl(pfx, 5, Vector(0.2, 0.2, 0.2))
  ParticleManager:SetParticleControl(pfx, 2, Vector(0.9,0.9,0.9))
  Timers:CreateTimer(10, function() 
    ParticleManager:DestroyParticle( pfx, false )
    ParticleManager:ReleaseParticleIndex(pfx)
  end)
  ScreenShake(bahamut:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
  Timers:CreateTimer(0.5, function()
    bahamut:RemoveModifierByName("modifier_bahamut_arcana_passive")
    StartAnimation(bahamut, {duration=3, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.6})
  end)
  Timers:CreateTimer(1.0, function()
      ScreenShake(bahamut:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
      EmitSoundOnLocationWithCaster(bahamut:GetAbsOrigin(), "Seafortress.ShadowOfBahamut.TrapPop", caster)
      CustomAbilities:QuickParticleAtPoint("particles/roshpit/seafortress/shadow_bahamut_spark.vpcf", bahamut:GetAbsOrigin(), 2.5)
  end)
  Timers:CreateTimer(1.5, function()
    EmitGlobalSound("Seafortress.ShadowOfBahamut.Spawn")
  end)
  Timers:CreateTimer(3.3, function()
    bahamut:RemoveModifierByName("modifier_disable_player")
  end)
end

function Seafortress:SpawnShadowOfBahamutMonster(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_shadow_of_bahamut", position, 3,4, "Seafortress.ShadowOfBahamut.Aggro", fv, false)
  queen.reduc = 0.00001
  queen.isBossFFS = true
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetRenderColor(0, 0, 0)
  Events:ColorWearables(queen, Vector(45, 45, 45))
  return queen
end

function Seafortress:InitArchon()
  Seafortress:SpawnArchonWizard(Vector(4416, 15744), Vector(-0.7,-1))
end

function Seafortress:SpawnArchonWizard(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_archon_wizard", position, 3,4, "Seafortress.ArchonWizard.Aggro", fv, false)
  queen.reduc = 0.00001
  queen.golemsSpawned = 0
  queen.isBossFFS = true
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetRenderColor(0, 0, 0)
  Events:ColorWearables(queen, Vector(0, 0, 0))
  return queen
end

function Seafortress:SpawnArchonGolem(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_archon_golem", position, 5,6, "Seafortress.ArchonGolemSpawn", fv, true)
  queen.reduc = 0.00005
  queen.isBossFFS = true
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetRenderColor(207, 94, 255)
  Seafortress:SetTargetCastArgs(queen, 400, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnPaladinArcanaGolems()
  local golem1 = Seafortress:SpawnPaladinGolem(Vector(12032, 9920), Vector(-1,-1))
  local golem2 = Seafortress:SpawnPaladinGolem(Vector(12294, 9305), Vector(-1,0.2))
  local golem3 = Seafortress:SpawnPaladinGolem(Vector(11796, 9055), Vector(0,1))
  local golem4 = Seafortress:SpawnPaladinGolem(Vector(11392, 9364), Vector(-1,1))
  Seafortress.GolemsTable = {golem1, golem2, golem3, golem4}
end

function Seafortress:SpawnPaladinGolem(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("sea_fortress_paladin_golem", position, 5,6, "Seafortress.ArchonGolemSpawn", fv, false)
  queen.reduc = 0.00005
  queen.isBossFFS = true
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetRenderColor(0, 0, 0)
  Seafortress:SetPositionCastArgs(queen, 1800, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Seafortress:SpawnOlSpiny(position, fv)
  local queen = Seafortress:SpawnDungeonUnit("seafortress_ol_spiny", position, 7,8, "Seafortress.OlSpiny.Aggro", fv, false)
  queen.reduc = 0.000002
  queen.isBossFFS = true
  Events:AdjustBossPower(queen, 8, 8, false)
  Events:ColorWearablesAndBase(queen, Vector(30, 70, 255))
  queen:SetModelScale(0.03)
  Events:smoothSizeChange(queen, 0.03, 2.4, 90)
  EmitSoundOn("Seafortress.OlSpiny.Spawn.FX", queen)
  StartAnimation(queen, {duration=4.6, activity=ACT_DOTA_TELEPORT, rate=1.0})
  Timers:CreateTimer(1.4, function()
    EmitSoundOn("Seafortress.OlSpiny.Spawn.VO", queen)
  end)
  local ability = queen:FindAbilityByName("ol_spiny_passive")
  ability:ApplyDataDrivenModifier(queen, queen, "modifier_disable_player", {duration = 4.5})
  CustomAbilities:QuickAttachParticle("particles/dark_smoke_test.vpcf", queen, 6)
  return queen
end

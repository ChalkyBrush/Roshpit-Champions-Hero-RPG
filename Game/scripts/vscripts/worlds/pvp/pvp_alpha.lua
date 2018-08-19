if PVP == nil then
  PVP = class({})
end

require('worlds/pvp/pvp_line_war')

PVP.GAME_MODE_DEATH_MATCH = 0
PVP.GAME_MODE_LINE_WAR = 1

function PVP:Debug()
  -- CustomGameEventManager:Send_ServerToAllClients("createPVPGoal", {killThreshold = PVP.KillThreshold} )
  PVP:RollRandomGlyph(MAIN_HERO_TABLE[1]:GetAbsOrigin())
end

function PVP:InitGame()
      Dungeons.phoenixCollision = true
      RPCItems.DROP_LOCATION = Vector(6656,-16128)
      Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
      Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
      Events.GameMaster:RemoveModifierByName("modifier_portal")


      PVP.ZFLOAT = PVP:GetPVPAlphaZFLOAT()
    

  Events.TownPosition = Vector(-15168, -14976)
  Events.isTownActive = true
  if GameState:NoOracle() then
  else
      local oracle = Events:SpawnOracle(Vector(-1344, -1024), Vector(0, -1))
      local oracle2 = Events:SpawnOracle(Vector(3200, 4160), Vector(0, -1))
  end


  -- Redfall:VillageMusic()
  

      PVP.PVPMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
      -- Redfall.RedfallMaster:AddAbility("redfall_ability"):SetLevel(GameState:GetDifficultyFactor())
      -- Redfall.RedfallMasterAbility = Redfall.RedfallMaster:FindAbilityByName("redfall_ability")
      PVP.PVPMaster:AddAbility("dummy_unit"):SetLevel(1)
end

function PVP:GetPVPAlphaZFLOAT()
    return 0
end

function PVP:Respawn(npc)
  if GameState:IsPVPLineWarWork() then
    if npc:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      FindClearSpaceForUnit(npc, Vector(-1284, -1392), false)
    else
      FindClearSpaceForUnit(npc, Vector(4408, 4793), false)
    end
  else
    if npc:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      local spawnTable = {Vector(-1642, 370), Vector(-1284, -1392), Vector(1469, -1211)}
      npc:SetOrigin(spawnTable[RandomInt(1, #spawnTable)])
    else
      local spawnTable = {Vector(1571, 3648), Vector(3127, 3613), Vector(3604, 1536)}
      npc:SetOrigin(spawnTable[RandomInt(1, #spawnTable)])
    end
  end
end

function PVP:PlayerKill(killerEntity, killedUnit)
    -- PlayerResource:IncrementKills(killerEntity:GetPlayerOwnerID(), 1)
    if killedUnit:HasModifier("modifier_paladin_rune_e_1_revivable") or killedUnit:HasModifier("modifier_phoenix_rebirthing") then
      return false
    end
    if killedUnit:IsHero() then
      Timers:CreateTimer(0.06, function()
        local respawnTime = 5
        respawnTime = math.floor(respawnTime + killedUnit:GetLevel()*0.1)
        killedUnit:SetTimeUntilRespawn(respawnTime)
      end)
      if killerEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
        PVP.TeamAKills = PVP.TeamAKills + 1
      elseif killerEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
        PVP.TeamBKills = PVP.TeamBKills + 1
      end
      if PVP.GameMode == PVP.GAME_MODE_DEATH_MATCH then
        if PVP.TeamAKills == PVP.KillThreshold then
          PVP:GameEnd(DOTA_TEAM_BADGUYS)
        end
        if PVP.TeamBKills == PVP.KillThreshold then    
          PVP:GameEnd(DOTA_TEAM_GOODGUYS)
        end
      elseif PVP.GameMode == PVP.GAME_MODE_LINE_WAR then
        if not killerEntity:IsHero() then
          for i = 1, #MAIN_HERO_TABLE, 1 do
            if not MAIN_HERO_TABLE[i] == killedUnit:GetTeamNumber() then
              local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
              PlayerResource:ModifyGold(playerID, killedUnit:GetLevel()*5, true, 0)
              PlayerResource:SetGold(playerID, 0, false)
            end
          end
        end
      end
    end
end

function PVP:InitiateVisionNodes()
  local goodNodeTable = {Vector(-256, -1034), Vector(-766, -227), Vector(192, -71), Vector(15, 970)}
  for i = 1, #goodNodeTable, 1 do
    PVP:SpawnVisionNode(DOTA_TEAM_GOODGUYS, goodNodeTable[i])
  end
  local badNodeTable = {Vector(1792, 1408), Vector(1685, 2515), Vector(3093, 2444), Vector(2557, 3315)}
  for i = 1, #badNodeTable, 1 do
    PVP:SpawnVisionNode(DOTA_TEAM_BADGUYS, badNodeTable[i])
  end
end

function PVP:SpawnVisionNode(teamNumber, position)
  local centerView = Vector(1024, 1152)
  local visionNode = nil
  if teamNumber == DOTA_TEAM_GOODGUYS then
    visionNode = CreateUnitByName("rpc_pvp_vision_node", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
    visionNode:FindAbilityByName("dummy_unit"):SetLevel(1)
    visionNode:FindAbilityByName("pvp_vision_node_ability"):SetLevel(1)
    local fv = ((centerView - visionNode:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    visionNode:SetForwardVector(fv)
  else
    visionNode = CreateUnitByName("rpc_pvp_vision_node_bad", position, false, nil, nil, DOTA_TEAM_BADGUYS)
    visionNode:FindAbilityByName("dummy_unit"):SetLevel(1)
    visionNode:FindAbilityByName("pvp_vision_node_ability"):SetLevel(1)
    local fv = ((centerView - visionNode:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    visionNode:SetForwardVector(fv)
  end
  return visionNode
end

function PVP:GameEnd(LosingTeam)
  EmitGlobalSound("RoshpitPVP.GameEnd")
  for i = 1, #MAIN_HERO_TABLE, 1 do
    Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_command_restric_player", {})
  end
  Timers:CreateTimer(6, function()
    GameRules:MakeTeamLose(LosingTeam)
  end)
end

function PVP:VoteSubmit(msg)
  print(msg)
  if not PVP.PVPVoteTable then
    PVP.PVPVoteTable = {}
    PVP.DeathMatchCount = 0
    PVP.LinewarCount = 0
  end
  local personalVote = {}
  if msg.killAmount then
    PVP.DeathMatchCount = PVP.DeathMatchCount + 1

    personalVote.killCount = msg.killAmount
  elseif msg.power then
    PVP.LinewarCount = PVP.LinewarCount + 1
    personalVote.power = msg.power
  end
  table.insert(PVP.PVPVoteTable, personalVote)
end

function PVP:SetPvpRules()

  local avgKills = 0

  if not PVP.PVPVoteTable then
    avgKills = 15
    avgPower = 1
    PVP.GameMode = PVP.GAME_MODE_LINE_WAR
    PVP.DeathMatchCount = 0
    PVP.LinewarCount = 1
  else
    local killCount = 0
    local monsterPower = 0
    for i = 1, #PVP.PVPVoteTable, 1 do
      local personalVote = PVP.PVPVoteTable[i]
      if personalVote.killCount then
        killCount = killCount + personalVote.killCount
      elseif personalVote.power then
        monsterPower = monsterPower + personalVote.power
      end
    end
    avgKills = killCount/#PVP.PVPVoteTable
    avgPower = monsterPower/#PVP.PVPVoteTable
  end
  PVP.TeamAKills = 0
  PVP.TeamBKills = 0
  PVP.KillThreshold = math.floor(avgKills)
  -- PVP.GameMode = PVP.GAME_MODE_DEATH_MATCH
  PVP.monsterPower = math.min(math.ceil(avgPower), 3)
  PVP.monsterPower = math.max(PVP.monsterPower, 1)
  Events.DifficultyFactor = PVP.monsterPower
  if PVP.DeathMatchCount > PVP.LinewarCount then
    PVP.GameMode = PVP.GAME_MODE_DEATH_MATCH
  else
    PVP.GameMode = PVP.GAME_MODE_LINE_WAR
  end
  if PVP.GameMode == PVP.GAME_MODE_DEATH_MATCH then
    CustomGameEventManager:Send_ServerToAllClients("createPVPGoal", {killThreshold = PVP.KillThreshold} )
    PVP:InitiateVisionNodes()
  elseif PVP.GameMode == PVP.GAME_MODE_LINE_WAR then
    Events.DifficultyFactor = 1
    PVP:InitiateTowers()
    PVP:InitiateLineBuilders()
    PVP:LinewarSetupBuilderData()
    PVP:LinewarIncomeFunction()
    for i = 1, #MAIN_HERO_TABLE, 1 do
      PVP:InitiateHero(MAIN_HERO_TABLE[i])
    end
    Redfall = {}
    Redfall.RedfallMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
    Redfall.RedfallMaster:AddAbility("redfall_ability"):SetLevel(GameState:GetDifficultyFactor())
    Redfall.RedfallMasterAbility = Redfall.RedfallMaster:FindAbilityByName("redfall_ability")
    Redfall.RedfallMaster:AddAbility("dummy_unit"):SetLevel(1)
  end
end

function PVP:InitiateTowers()
  local goodNodeTable = {Vector(-256, -1034), Vector(-766, -227), Vector(192, -71), Vector(15, 970)}
  if GameState:IsPVPLineWarWork() then
    goodNodeTable = {Vector(192, -128), Vector(-643, -169), Vector(-563, -923), Vector(-1069, -923)}
  end
  PVP.GoodTowers = {}
  PVP.GoodTowersAlive = 0
  for i = 1, #goodNodeTable, 1 do
    local tower = PVP:SpawnTower(DOTA_TEAM_GOODGUYS, goodNodeTable[i])
    PVP.GoodTowersAlive = PVP.GoodTowersAlive + 1
  end
  PVP.BadTowers = {}
  PVP.BadTowersAlive = 0
  local badNodeTable = {Vector(1792, 1408), Vector(1685, 2515), Vector(3093, 2444), Vector(2557, 3315)}
  if GameState:IsPVPLineWarWork() then
    badNodeTable = {Vector(2560, 3584), Vector(3415, 3659), Vector(3522, 4288), Vector(4224, 4388)}
  end
  for i = 1, #badNodeTable, 1 do
    local tower = PVP:SpawnTower(DOTA_TEAM_BADGUYS, badNodeTable[i])
    PVP.BadTowersAlive = PVP.BadTowersAlive + 1
  end
end

function PVP:SpawnTower(teamNumber, position)
  local centerView = Vector(1024, 1152)
  local visionNode = nil
  if teamNumber == DOTA_TEAM_GOODGUYS then
    visionNode = CreateUnitByName("rpc_pvp_line_tower_good", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
    local fv = ((centerView - visionNode:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    visionNode:SetForwardVector(fv)
    visionNode:FindAbilityByName("pvp_line_tower_ability"):SetLevel(1)
  else
    visionNode = CreateUnitByName("rpc_pvp_line_tower_bad", position, false, nil, nil, DOTA_TEAM_BADGUYS)
    visionNode:FindAbilityByName("pvp_line_tower_ability"):SetLevel(1)
    local fv = ((centerView - visionNode:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    visionNode:SetForwardVector(fv*-1)
    visionNode:FindAbilityByName("pvp_line_tower_ability"):SetLevel(1)
  end
  Events:AdjustDeathXP(visionNode)
  return visionNode
end

function PVP:InitiateLineBuilders()
  local centerView = Vector(1024, 1152)
  local position = Vector(-1728, -1584)
  if GameState:IsPVPLineWarWork() then
    position = Vector(-1600, -1728)
  end
  local builder = CreateUnitByName("rpc_pvp_tanari_builder", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
  local fv = ((centerView - builder:GetAbsOrigin())*Vector(1,1,0)):Normalized()
  builder:SetForwardVector(fv)
  -- builder:FindAbilityByName("pvp_tanari_builder_open_menu"):SetLevel(1)
  PlayerResource:SetGold(builder:GetPlayerOwnerID(), 99999, true)
  for i = 1, #MAIN_HERO_TABLE, 1 do
    if MAIN_HERO_TABLE[i]:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      builder:SetControllableByPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwnerID(), false)
    end
  end

  PVP.TanariBuilder = builder
  print(PVP.TanariBuilder:GetMainControllingPlayer())
  --BAD BUILDER
  local position = Vector(3588, 3392)
  if GameState:IsPVPLineWarWork() then
    position = Vector(4408, 4793)
  end
  local builder = CreateUnitByName("rpc_pvp_tanari_builder", position, false, nil, nil, DOTA_TEAM_BADGUYS)
  local fv = ((centerView - builder:GetAbsOrigin())*Vector(1,1,0)):Normalized()
  builder:SetForwardVector(fv)
  -- builder:FindAbilityByName("pvp_tanari_builder_open_menu"):SetLevel(1)
  PlayerResource:SetGold(builder:GetPlayerOwnerID(), 99999, true)
  for i = 1, #MAIN_HERO_TABLE, 1 do
    if MAIN_HERO_TABLE[i]:GetTeamNumber() == DOTA_TEAM_BADGUYS then
      builder:SetControllableByPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwnerID(), false)
    end
  end

  PVP.TanariBuilderBad = builder
  print(PVP.TanariBuilderBad:GetMainControllingPlayer())
end

function PVP:InitiateHero(heroEntity)
  print("INITAITE PVP HERO")
  if PVP.TanariBuilder then
    if GameState:NoOracle() then
      local maxFood = math.floor(48/PlayerResource:GetPlayerCountForTeam(heroEntity:GetTeamNumber()))
      CustomNetTables:SetTableValue("premium_pass", "line_war_food_cap_"..heroEntity:GetPlayerOwnerID(), {currentFood = 0, maxFood = maxFood} )
      if heroEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
        PVP.TanariBuilder:SetControllableByPlayer(heroEntity:GetPlayerOwnerID(), false)
        print("GIVE GOODGUY CONTROL")
      elseif heroEntity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
        PVP.TanariBuilderBad:SetControllableByPlayer(heroEntity:GetPlayerOwnerID(), false)
        print("GIVE BADGUY CONTROL")
      end
      heroEntity.linewarIncome = 50
      PlayerResource:ModifyGold(heroEntity:GetPlayerOwnerID(), 200, true, 0)
      PlayerResource:SetGold(heroEntity:GetPlayerOwnerID(), 0, false)
      -- PlayerResource:SetGold(heroEntity:GetPlayerOwnerID(), 300, true)
      CustomNetTables:SetTableValue("premium_pass", "line_war_income_"..heroEntity:GetEntityIndex(), {income = heroEntity.linewarIncome} )
    end
  end
end
function PortalThink(event)
    local caster = event.caster
    if caster.active then
        local ability = event.ability
        caster:SetAbsOrigin(ability.position)
        local position = caster:GetAbsOrigin()
        local radius = 200

        local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
        local target_types = DOTA_UNIT_TARGET_HERO
        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
        local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
        for _, unit in ipairs(units) do
            if not unit:HasModifier("modifier_recently_teleported_portal") then
                local player = unit:GetPlayerOwner()
                local playerId = player:GetPlayerID()
                CustomGameEventManager:Send_ServerToPlayer(player, "CloseShop", {player = playerId})
                unit.lastPortalUsed = caster.name
                dungeonPortalsLastUsed(unit, caster.name)
                local teleportLocation = caster.teleportLocation
                if Dungeons.entryPoint and not Beacons.expireVote and not caster.dungeonSpecial and not caster.ruinsBossSpecial then
                    teleportLocation = Dungeons.entryPoint
                end
                Events:TeleportUnit(unit, teleportLocation, ability, caster, 1.2)
                unit.inTown = false
                if caster.dungeonSpecial then
                    Dungeons:SpecialPortal(unit)
                    break
                end
                if caster.ruinsBossSpecial then
                    Dungeons:ruinsBossSpecial(unit)
                    break
                end
                -- if not Events.firstTeleported then
                --     Events.firstTeleported = true
                --     Events:inBetweenWave(20)
                --     Timers:CreateTimer(20,
                --     function()
                --         TeleportAllHeroesToAct1(ability, caster)
                --         Events:wave_redirect()
                --     end)
                -- end
            end
        end
    end
end

function dungeonPortalsLastUsed(unit, name)
    if name == "graveyard" then
        unit.lastPortalUsed = "forestTown"
    elseif name == "lumbermill" then
        unit.lastPortalUsed = "forestTown"
    end
end

function TeleportUnit(unit, position, ability, caster, delay)
    StartSoundEvent("Hero_Chen.TeleportLoop", unit)
    ability:ApplyDataDrivenModifier(caster, unit, "modifier_recently_teleported_portal", {duration = 7})
    ability:ApplyDataDrivenModifier(caster, unit, "modifier_teleporting", {})
    Timers:CreateTimer(delay, function()
        EmitSoundOn("Portal.Hero_Appear", unit)
    end)
    Timers:CreateTimer(delay + 0.6, function()
        --print('prepare camera lock')
        StopSoundEvent("Hero_Chen.TeleportLoop", unit)
        unit:SetAbsOrigin(position)
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_teleported", {})
        groundPosition = GetGroundPosition(position, unit)
        FindClearSpaceForUnit(unit, groundPosition, true)

        Events:LockCamera(unit)

    end)
end

function TeleportAllHeroesToAct1(caster, relatedBeaconPortal, teleportLocation)
    local ability = caster:FindAbilityByName("town_portal")
    for i = 1, #MAIN_HERO_TABLE, 1 do
        local hero = MAIN_HERO_TABLE[i]
        if not Beacons:IsHeroInCorrectLocation(hero, relatedBeaconPortal) then
            hero.lastPortalUsed = "mainTown"
            Events:TeleportUnit(hero, teleportLocation, ability, caster, 1.2)
            hero.inTown = false
        end
    end
    Events.isTownActive = false
end

function BeaconThink(event)
    local caster = event.caster
    local ability = event.ability
    local position = caster:GetAbsOrigin()
    caster:SetAbsOrigin(ability.position)
    local radius = 200

    local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    local target_types = DOTA_UNIT_TARGET_HERO
    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
    local relatedBeaconPortal = caster.relatedPortal
    if not caster.beaconActivated and not Beacons.dungeonVote then
        for _, unit in ipairs(units) do
            if unit:HasModifier("modifier_activating_beacon") then
                if caster.type == "boulderspine" then
                    Timers:CreateTimer(1, function()
                        Tanari:BeginCaveWave(unit, caster)
                    end)
                    return false
                end
                if caster.type == "wave" then
                    local waveNumber = 1
                    local teleportLocation = Vector(0, 0)
                    if caster.relatedPortal == "forestForest" then
                        waveNumber = Beacons.ForestWave
                        teleportLocation = Vector(-7808, -5504)
                    elseif caster.relatedPortal == "desertDesert" then
                        waveNumber = Beacons.DesertWave
                        teleportLocation = Vector(1792, -2624)
                    elseif caster.relatedPortal == "minesMines" then
                        waveNumber = Beacons.MinesWave
                        teleportLocation = Vector(3712, 1152)
                    end
                    Events.WaveNumber = waveNumber
                    if Events.WaveNumber == 0 then
                        MoveBookGuy()
                    end
                    Events.firstTeleported = true
                    caster.beaconActivated = true
                    Beacons:DeactivatePortalByName(caster.relatedPortal)
                    Beacons:RemoveDungeonBeacons()
                    Beacons.respawnLocation = teleportLocation
                    Events:inBetweenWave(10)
                    Timers:CreateTimer(10, function()
                        Dungeons.itemLevel = 0
                        Events:wave_redirect()
                        TeleportAllHeroesToAct1(Events.portal, relatedBeaconPortal, teleportLocation)
                    end)
                    EmitSoundOn("DOTA_Item.AbyssalBlade.Activate", caster)
                    Timers:CreateTimer(0.5, function()
                        for i = 1, #Beacons.WaveBeaconTable, 1 do
                            UTIL_Remove(Beacons.WaveBeaconTable[i])
                        end
                    end)
                    break
                elseif caster.type == "dungeon" then
                    beaconDungeon(caster, unit)
                    break
                end
            else
                ability:ApplyDataDrivenModifier(caster, unit, "modifier_activating_beacon", {duration = 3.5})
            end
        end
    end
end

function beaconDungeon(caster, unit)
    EmitGlobalSound("valve_ti5.stinger.radiant_lose")
    Beacons.dungeonVote = true
    Beacons.expireVote = true
    local hero1, player1, hero2, player2, hero3, player3, hero4, player4 = Dungeons:getPlayers()
    Dungeons.playerTable = fillTable(player1, player2, player3, player4)
    Dungeons.voteYes = 0
    Dungeons.voteNo = 0
    Dungeons.entryPoint = caster.entryPoint
    Dungeons.imagePath = caster.dungeonImagePath
    Dungeons.title = caster.dungeon
    Dungeons.itemLevel = caster.itemLevel
    Dungeons.beacon = caster
    CustomGameEventManager:Send_ServerToAllClients("DungeonVote", {dungeonName = caster.dungeon, dungeonImage = caster.dungeonImagePath, recommendedLevelMin = caster.recommendedLevelMin, recommendedLevelMax = caster.recommendedLevelMax, playerID = unit:GetPlayerOwnerID(), hero = unit:GetClassname(), numPlayers = #MAIN_HERO_TABLE, hero1 = hero1, player1 = player1, hero2 = hero2, player2 = player2, hero3 = hero3, player3 = player3, hero4 = hero4, player4 = player4})
    Timers:CreateTimer(20, function()
        if Beacons.expireVote then
            Dungeons:VoteEnd()
        end
    end)
end

function fillTable(player1, player2, player3, player4)
    playerTable = {}
    table.insert(playerTable, player1)
    table.insert(playerTable, player2)
    table.insert(playerTable, player3)
    table.insert(playerTable, player4)
    return playerTable
end

function MoveBookGuy()
    Events.BookGuy:DestroyAllSpeechBubbles()
    local time = 7
    local speechSlot = findEmptyDialogSlot()
    Events.BookGuy:AddSpeechBubble(speechSlot, "#dialogue_book_two", time, 0, 0)

    Events.BookGuy:MoveToPosition(Vector(-7808, -5504))
    Events.BookGuy.state = 1
    Timers:CreateTimer(11, function()
        Events:TeleportUnit(Events.BookGuy, Vector(-13438, 12401), Events.portal:FindAbilityByName("town_portal"), Events.portal, 1.2)
        Timers:CreateTimer(2, function()
            Events.BookGuy.state = 2
            Events.BookGuy:MoveToPosition(Vector(-14436, 13203))
            Timers:CreateTimer(10, function()
                Events.BookGuy:MoveToPosition(Vector(-14406, 13183))
            end)
        end)
    end)
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

function BeaconInitiate(event)
    local caster = event.caster
    local ability = event.ability
    ability.position = caster:GetAbsOrigin()
end

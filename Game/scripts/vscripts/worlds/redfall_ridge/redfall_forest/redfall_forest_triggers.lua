function RedfallShagbarkTriggerOnStartTouch(trigger)
	local hero = trigger.activator
	local questGuy = Redfall.Quest1Giver
	if not questGuy.talking then
		StartAnimation(questGuy, {duration = 1.0, activity = ACT_DOTA_SPAWN, rate = 0.6})
		questGuy.talking = true
		Redfall:Dialogue(questGuy, {hero}, "redfall_quest_1_dialogue", 5, 5, 5, true)
		Timers:CreateTimer(5, function()
			Redfall:Dialogue(questGuy, {hero}, "redfall_quest_1_dialogue_2", 5, 5, 5, true)
		end)
		Timers:CreateTimer(10, function()
			questGuy.talking = false
		end)
		Timers:CreateTimer(5, function()
			Quests:StartNewQuest("heart_of_the_forest")
			UTIL_Remove(questGuy.ExclamationMark)
		end)
	end
end

function RedfallForestTrigger1OnStartTouch(trigger)
    if not Redfall.RedfallForestTrigger1Triggered then
        Redfall.RedfallForestTrigger1Triggered = true
        Redfall:SpawnAutumnSummonerAsync(Vector(-15808, -12992), Vector(1, 0), nil)
        Redfall:SpawnAutumnSummonerAsync(Vector(-15040, -12864), Vector(1, 0), nil)
        if GameState:GetDifficultyFactor() > 1 then
            Redfall:SpawnAutumnSummonerAsync(Vector(-15858, -12544), Vector(1, -0.5), nil)
            Redfall:SpawnAutumnSummonerAsync(Vector(-15552, -13184), Vector(1, 1), nil)
        end
        Redfall:SpawnAutumnSpawnerAsync(Vector(-15265, -12416, 47), Vector(-1, -1), Vector(-15424, -12608), nil)

        Redfall:SpawnBigFlowerAsync(Vector(-10880, -15040), Vector(0, 1), nil)
        Redfall:SpawnBigFlowerAsync(Vector(-10176, -14720), Vector(-0.5, 1), nil)
    
        Redfall:SpawnCliffWeedAsync(Vector(-9472, -14912), Vector(-1, 1), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-9024, -14647), Vector(-1, 0), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-9292, -14326), Vector(-1, -1), nil)
        Redfall:SpawnAutumnSpawnerAsync(Vector(-8704, -14318, 127), Vector(1, -1), Vector(-8704, -14448), nil)
    
        Redfall:SpawnAutumnSummonerAsync(Vector(-8320, -14464), Vector(-1, -0.6), nil)
        Redfall:SpawnAutumnSummonerAsync(Vector(-8064, -14709), Vector(-1, 0), nil)
    
        Redfall:SpawnCliffWeedAsync(Vector(-8256, -14912), Vector(0, -1), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-7680, -14528), Vector(1, -1), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-7785, -14208), Vector(0.2, -1), nil)
        Redfall:SpawnAutumnGazerAsync(Vector(-8704, -14848), Vector(0.2, 1), nil)
        Redfall:SpawnAutumnGazerAsync(Vector(-8000, -15104), Vector(0, 1), nil)
        Redfall:SpawnAutumnGazerAsync(Vector(-7424, -14016), Vector(0, -1), nil)
            
        Redfall:SpawnCliffWeedAsync(Vector(-7104, -14784), Vector(0, -1), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-6656, -14400), Vector(1, 0), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-6400, -14720), Vector(0.5, 1), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-6475, -14016), Vector(0.5, 1), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-5952, -14080), Vector(0, 1), nil)
        Redfall:SpawnCliffWeedAsync(Vector(-5440, -13970), Vector(-1, 1), nil)
        local callback = function(unit)
            local patrolPoint1 = Vector(-10560, -14784)
            local patrolPoint2 = Vector(-5312, -13888)
            Redfall:AddPatrolArguments(unit, 40, 9, 340, {patrolPoint2, patrolPoint1})
        end
        Redfall:SpawnForestGnomeAsync(Vector(-8064, -14528), Vector(-0.8, -0.2), callback)
        Redfall:SpawnForestGnomeAsync(Vector(-8064, -14758), Vector(-0.8, -0.2), callback)
        Redfall:SpawnForestGnomeAsync(Vector(-7840, -14528), Vector(-0.8, -0.2), callback)
        
        local otaruSpawner = Entities:FindAllByName("npc_spawner_redfall_otaru")[1]
        if otaruSpawner then
            local callback = function(otaru)
                otaru.hasSpeechBubble = false
                otaru:SetForwardVector(otaruSpawner:GetForwardVector())
                otaru:FindAbilityByName("town_unit_not_invuln"):SetLevel(1)
                otaru:FindAbilityByName("redfall_otaru_ability"):SetLevel(1)
                otaru.state = 0
                Redfall.Otaru = otaru
    
                local exclamationMark = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(otaruSpawner:GetAbsOrigin().x, otaruSpawner:GetAbsOrigin().y, Redfall.ZFLOAT + 200)})
                exclamationMark:SetModel("models/ui/exclamation/exclamation.vmdl")
                exclamationMark:SetModelScale(0.05)		
                exclamationMark:SetForwardVector(otaruSpawner:GetForwardVector())
                Redfall.Otaru.ExclamationMark = exclamationMark
            end
            CreateUnitByNameAsync("redfall_otaru", otaruSpawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS, callback)
        end
        Redfall:SpawnWoodDwellerAsync(Vector(-8766, -13137), Vector(0, 1), nil)
        Redfall:SpawnWoodDwellerAsync(Vector(-8384, -12416), Vector(0.2, -1), nil)
        Redfall:SpawnWoodDwellerAsync(Vector(-7711, -12320), Vector(-1, -1), nil)
        Redfall:SpawnWoodDwellerAsync(Vector(-7616, -12924), Vector(-1, 0.3), nil)
        Redfall:SpawnWoodDwellerAsync(Vector(-8020, -13184), Vector(-1, 0.8), nil)
        if GameState:GetDifficultyFactor() > 1 then
            Redfall:SpawnAutumnSpawnerAsync(Vector(-7936, -12672, 47), Vector(-1, -1), Vector(-7936, -12672), nil)
        end

        Redfall:SpawnAutumnSpawnerAsync(Vector(-9024, -8896, 80), Vector(-1, 1), Vector(-9280, -8768), nil)
        Redfall:SpawnAutumnSpawnerAsync(Vector(-9920, -7424, 80), Vector(1, 1), Vector(-9728, -7616), nil)
        Redfall:SpawnAutumnSummonerAsync(Vector(-9664, -8640), Vector(-1, -1), nil)
        Redfall:SpawnAutumnSummonerAsync(Vector(-8384, -8064), Vector(-1, 1), nil)
    
        local position1 = Vector(-9299, -8202)
        local position2 = Vector(-9536, -7294)
        local position3 = Vector(-8662, -7829)
        local callback = function(unit)
            Redfall:AddPatrolArguments(unit, 30, 3, 240, {position3, position2, position1})
        end
        Redfall:SpawnOvergrowthAsync(position1, RandomVector(1), callback)
        Redfall:SpawnOvergrowthAsync(position2, RandomVector(1), callback)
        Redfall:SpawnOvergrowthAsync(position3, RandomVector(1), callback)
    end
end

function RedfallForestMiniBossTriggerOnStartTouch()
    Redfall:SpawnAutumnSpawnerAsync(Vector(-10723, -10880, 80), Vector(1, 0), Vector(-10496, -10880), nil)
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnAutumnSpawnerAsync(Vector(-9792, -10624, 80), Vector(-1, -1), Vector(-9920 - 10723), nil)
	end
	local vectorTable = {}
	local bottomLeftPos = Vector(-10560, -11236)
	for i = 0, 10 + GameState:GetDifficultyFactor() * 2, 1 do
		local randomX = RandomInt(1, 800)
		local randomY = RandomInt(1, 800)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroomAsync(vectorTable[i])
	end
	if GameState:GetDifficultyFactor() > 0 then
		local baseVector = Vector(-9408, -11445)
		local loops = -2 + (GameState:GetDifficultyFactor() * 4)
		for i = 1, loops, 1 do
			Timers:CreateTimer(i * 0.75, function()
				local position = baseVector + Vector(RandomInt(1, 200), RandomInt(1, 740))
				local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
				dummy:AddAbility("ability_blue_effect"):SetLevel(1)
				dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
				WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
                Timers:CreateTimer(10, function()
                    local callback = function(unit)
                        unit:SetAbsOrigin(dummy:GetAbsOrigin())
                        unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
                        UTIL_Remove(dummy)
                    end
					Redfall:SpawnWaterLilyAsync(dummy:GetAbsOrigin(), RandomVector(1), false, callback)
				end)
			end)
		end
	end
	Redfall:SpawnWozxak(Vector(-10304, -10880), Vector(1, 0))
end

function RedfallForestCliffTreeAmbushTriggerOnStartTouch(trigger)
	for j = 1, 12 + (GameState:GetDifficultyFactor() * 3), 1 do
		Timers:CreateTimer(j * 0.4, function()
			local spawnVector = Vector(-11648, -15160 + RandomInt(0, 1024))
            local fv = Vector(1, 0)
            local callback = function(soldier)                    
                WallPhysics:Jump(soldier, fv, 15 + RandomInt(0, 3), 15, 29, 1)
                Timers:CreateTimer(0.1, function()
                    StartAnimation(soldier, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1.0})
                end)
                local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
                local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, soldier)
                ParticleManager:SetParticleControl(pfx, 0, soldier:GetAbsOrigin() + Vector(0, 0, 40))
                Timers:CreateTimer(1, function()
                    ParticleManager:DestroyParticle(pfx, false)
                end)
            end
			Redfall:SpawnRedfallForestMinionAsync(spawnVector, fv, true, callback)
		end)
	end
end

function RedfallForestMidTreeAmbushTriggerOnStartTouch(trigger)
	for j = 1, 6 + (GameState:GetDifficultyFactor() * 3), 1 do
		Timers:CreateTimer(j * 0.4, function()
			local spawnVector = Vector(-11520, -10880) + Vector(1, 1) * RandomInt(1, 500)
			local fv = Vector(-1, 1)
			local soldier = Redfall:SpawnRedfallForestMinion(spawnVector, fv, true)
			WallPhysics:Jump(soldier, fv, 15 + RandomInt(0, 3), 15, 29, 1)
			Timers:CreateTimer(0.1, function()
				StartAnimation(soldier, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1.0})
			end)
			local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, soldier)
			ParticleManager:SetParticleControl(pfx, 0, soldier:GetAbsOrigin() + Vector(0, 0, 40))
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function RedfallForestAquaLilyTrigger1OnStartTouch()
	if not Redfall.LilyPhase then
		Redfall.LilyPhase = 0
	end
	if Redfall.LilyPhase == 0 then
		local baseVector = Vector(-11422, -8896)
		local loops = 7 + (GameState:GetDifficultyFactor() * 3)
		for i = 1, loops, 1 do
			Timers:CreateTimer(i * 0.75, function()
				local position = baseVector + Vector(RandomInt(1, 810), RandomInt(1, 600))
				local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
				dummy:AddAbility("ability_blue_effect"):SetLevel(1)
				dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
				WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
				local pfx = CustomAbilities:QuickAttachParticle("particles/econ/generic/generic_buff_1/generic_buff_1.vpcf", dummy, 10)
				ParticleManager:SetParticleControl(pfx, 14, Vector(1,1,1))
				ParticleManager:SetParticleControl(pfx, 15, Vector(0,30,255))
				Timers:CreateTimer(10, function()
					local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
					unit:SetAbsOrigin(dummy:GetAbsOrigin())
					unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
					EmitSoundOn("Redfall.Aqualily.Spawn", unit)
					CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 4)
					-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
					UTIL_Remove(dummy)
				end)
			end)
		end
	end
	Redfall.LilyPhase = Redfall.LilyPhase + 1
end

function RedfallForestOtaruTriggerOnStartTouch(trigger)
	if not Redfall.OtaruQuestStarted then
		local hero = trigger.activator

		local portraitHero = "npc_dota_hero_ember_spirit"
		local headerText = "redfall_otaru"
		local messageText = "redfall_otaru_dialogue_one"
		local bDialogue = 1
		local bAltCondition = 0
		local altMessage = ""
		local intattr = 0
		local option1 = "redfall_otaru_dialogue_option1"
		local option2 = "redfall_otaru_dialogue_option2"

		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_npc_dialogue", {portraitHero = portraitHero, headerText = headerText, messageText = messageText, bDialogue = bDialogue, subLabel = subLabel, labelCost = labelCost, bAltCondition = bAltCondition, bAltmessage = altMessage, intattr = intattr, option1 = option1, option2 = option2})
	end
end

function RedfallForestOtaruFinalTriggerOnStartTouch(event)
	if Redfall.Otaru then
		local units = FindUnitsInRadius(Redfall.Otaru:GetTeamNumber(), Redfall.Otaru:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if Redfall.Otaru.state == 6 then
			Redfall:Dialogue(Redfall.Otaru, units, "redfall_final_otaru_dialogue", 6, 5, -40, true)
		end
	end
end

function RedfallForestCorruptTreeTriggerOnStartTouch(trigger)
	local hero = trigger.activator
	local position = hero:GetAbsOrigin()
	local tree = Entities:FindByNameNearest("VermillionTreeCorrupted", Vector(position.x, position.y, 130 + Redfall.ZFLOAT), 500)
	if tree then
        if tree.triggered then
            return
        end
        Quests:StartNewQuest("heart_of_the_forest")
        UTIL_Remove(questGuy.ExclamationMark)
        tree.triggered = true
        local particleName = "particles/dark_smoke_test.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(pfx, 0, tree:GetAbsOrigin())
        EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Redfall.CorruptedTreeStart", Redfall.RedfallMaster)
        Timers:CreateTimer(30, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
        local treeDummy = CreateUnitByName("npc_dummy_unit", tree:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
        treeDummy.cultistsSlain = 0
        treeDummy.cultistsTarget = 12
        treeDummy.tree = tree
        treeDummy:AddAbility("dummy_unit"):SetLevel(1)
        Timers:CreateTimer(2.5, function()
            for i = 1, treeDummy.cultistsTarget, 1 do
                Timers:CreateTimer(i, function()
                    local cultist = Redfall:SpawnCrimsythCultistForTree(tree:GetAbsOrigin(), Vector(0, -1), tree:GetAbsOrigin())
                    cultist.treeDummy = treeDummy
                end)
            end
        end)
	end
end

function RedfallForestForestStoneWatcherTriggerOnStartTouch()
    Redfall:SpawnStoneWatcher(Vector(-4906, -12974), Vector(1, -0.2))
	Redfall:SpawnStoneWatcher(Vector(-3858, -12976), Vector(-1, -1))
	Redfall:SpawnStoneWatcher(Vector(-3264, -12734), Vector(-1, -1))
	Redfall:SpawnStoneWatcher(Vector(-2357, -12510), Vector(-1, 0))
end

function RedfallForestShrineOfMaruSurroundingTriggerOnStartTouch()
    Redfall:SpawnAutumnSpawner(Vector(-6336, -8640, 80), Vector(-1, 1), Vector(-6509, -8813))
	local vectorTable = {}
	local bottomLeftPos = Vector(-7360, -9280)
	for i = 0, 6 + GameState:GetDifficultyFactor() * 2, 1 do
		local randomX = RandomInt(1, 1000)
		local randomY = RandomInt(1, 640)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroomAsync(vectorTable[i])
	end
	if GameState:GetDifficultyFactor() > 1 then
		local lilyTable = {Vector(-8064, -8768), Vector(-7552, -8192)}
		for i = 1, #lilyTable, 1 do
			Timers:CreateTimer(i * 0.75, function()
				local position = lilyTable[i]
				local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
				dummy:AddAbility("ability_blue_effect"):SetLevel(1)
				dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
				WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
				Timers:CreateTimer(10, function()
					local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
					unit:SetAbsOrigin(dummy:GetAbsOrigin())
					unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
					-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
					UTIL_Remove(dummy)
				end)
			end)
		end
	end
	Redfall:SpawnAutumnGazer(Vector(-7064, -9261), Vector(0, 1))
	Redfall:SpawnAutumnGazer(Vector(-6592, -9600), Vector(1, 1))
    Redfall:SpawnAutumnGazer(Vector(-6144, -9344), Vector(-1, -1))
    
    if not Redfall.JuggStatue then
        Redfall.JuggStatue = Entities:FindByNameNearest("JuggStatue", Vector(-6916, -8042, 70 + Redfall.ZFLOAT), 400)
    end

    local exclamationMark = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(Redfall.JuggStatue:GetAbsOrigin().x, Redfall.JuggStatue:GetAbsOrigin().y, Redfall.ZFLOAT + 363)})
    exclamationMark:SetModel("models/ui/exclamation/exclamation.vmdl")
    exclamationMark:SetModelScale(0.05)		
    exclamationMark:SetForwardVector(Redfall.JuggStatue:GetForwardVector())
    Redfall.JuggStatue.ExclamationMark = exclamationMark
end

function RedfallForestShrineOfMaruTriggerOnStartTouch()
    UTIL_Remove(Redfall.JuggStatue.ExclamationMark)
	EmitSoundOnLocationWithCaster(Vector(-6916, -8042), "Redfall.JuggStatue.Start", Redfall.RedfallMaster)
	Redfall.JuggStatue = Entities:FindByNameNearest("JuggStatue", Vector(-6916, -8042, 70 + Redfall.ZFLOAT), 400)
	for i = 1, 240, 1 do
		Timers:CreateTimer(0.03 * i, function()
			Redfall.JuggStatue:SetAbsOrigin(Redfall.JuggStatue:GetAbsOrigin() + Vector(0, 0, 1))
		end)
	end
	Timers:CreateTimer(1, function()
		Redfall.JuggAmbient = ParticleManager:CreateParticle("particles/econ/events/battlecup/battlecup_fall_ambient.vpcf", PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(Redfall.JuggAmbient, 0, Vector(-6912, -8128, 250 + Redfall.ZFLOAT))
	end)
	Timers:CreateTimer(2, function()
		Quests:StartNewQuest("shrine_of_maru")
	end)
	local delay = 3
	if GameState:GetDifficultyFactor() == 2 then
		delay = 1.5
	elseif GameState:GetDifficultyFactor() == 3 then
		delay = 0.5
	end
	Timers:CreateTimer(5, function()
		for j = 1, 12, 1 do
			Timers:CreateTimer(j * delay, function()
				local spawnPosition = Vector(-6976, -8448) + RandomVector(RandomInt(1, 240))
				local particleName = "particles/roshpit/redfall/red_beam.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, Vector(-6916, -8042, 200 + Redfall.ZFLOAT))
				ParticleManager:SetParticleControl(pfx, 1, spawnPosition + Vector(0, 0, 122 + Redfall.ZFLOAT))
				Redfall:SpawnDiscipleOfMaru(spawnPosition, Vector(0, -1))
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				EmitSoundOnLocationWithCaster(spawnPosition, "Redfall.Maru.Spawn", Redfall.RedfallMaster)
			end)
		end
	end)
end

function RedfallForestBigFlowerTriggerOnStartTouch()
    Redfall:SpawnBigFlower(Vector(-5952, -12282), Vector(-1, 0))
	Redfall:SpawnBigFlower(Vector(-5120, -11584), Vector(-1, -1))
	Redfall:SpawnBigFlower(Vector(-4224, -11776), Vector(-1, 0))
	Redfall:SpawnBigFlower(Vector(-3776, -10816), Vector(-1, -1))
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnBigFlower(Vector(-3648, -11264), Vector(-1, 0))
		Redfall:SpawnAutumnSpawner(Vector(-4096, -10688, 80), Vector(1, -1), Vector(-4096, -10944))
	end
	Redfall:SpawnBigFlower(Vector(-3200, -11520), Vector(-1, 0.3))
	Redfall:SpawnAutumnSpawner(Vector(-4672, -12160, 80), Vector(1, -1), Vector(-4672, -11943))
end

function RedfallForestNearTreantTriggerOnStartTouch()
	Redfall:SpawnAutumnSpawner(Vector(-4591, -8880, 80), Vector(1, -1), Vector(-4634, -9035))
	Redfall:SpawnAutumnSpawner(Vector(-3589, -10136, 80), Vector(1, -1), Vector(-3649, -9950))
	local vectorTable = {}
	local bottomLeftPos = Vector(-5445, -10461)
	for i = 0, 8 + GameState:GetDifficultyFactor() * 4, 1 do
		local randomX = RandomInt(1, 1200)
		local randomY = RandomInt(1, 720)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroomAsync(vectorTable[i])
	end
	Redfall:SpawnBigFlower(Vector(-3587, -9861), Vector(-1, -1))

	Redfall:SpawnForestGnome(Vector(-3328, -9600), Vector(0, -1))
	Redfall:SpawnForestGnome(Vector(-3008, -9280), Vector(-0.3, -1))
	Redfall:SpawnForestGnome(Vector(-2880, -9664), Vector(-0.8, -0.2))
	if GameState:GetDifficultyFactor() == 3 then
		Redfall:SpawnForestGnome(Vector(-3072, -9534), Vector(0, -1))
	end
	Redfall:SpawnAutumnSummoner(Vector(-5110, -9280), Vector(0, -1))
	Redfall:SpawnAutumnSummoner(Vector(-4800, -9206), Vector(0, -1))
	Redfall:SpawnAutumnSummoner(Vector(-4800, -9536), Vector(0.2, -1))
end

function RedfallForestNearCrowStatueTriggerOnStartTouch(event)
    local lookPosition = Vector(-2176, -12096)
	local vectorTable = {Vector(-2176, -11648), Vector(-1807, -11328), Vector(-1353, -11488), Vector(-1463, -11008), Vector(-832, -11008), Vector(-968, -10432), Vector(-512, -10249)}
	for i = 1, #vectorTable, 1 do
		local fv = (lookPosition - vectorTable[i]):Normalized()
		Redfall:SpawnStudentOfAshara(vectorTable[i], fv)
	end
end

function RedfallForestCrowStatueTriggerOnStartTouch(trigger)
	local hero = trigger.activator
	if Redfall.RavenStatueActive then
		CrowMovement(hero)
		return false
	end
    if hero:HasModifier("modifier_blessing_of_ashara") then
        Quests:IncrementQuestObjective("seeking_ashara_objective3")
		Timers:CreateTimer(0.5, function()
			local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
			local radius = 450
			local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, hero)
			ParticleManager:SetParticleControl(particle2, 0, GetGroundPosition(Vector(-640, -9236, 401), hero))
			ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
			ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
			ParticleManager:SetParticleControl(particle2, 4, Vector(255, 40, 0))
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(particle2, false)
			end)
		end)

		EmitSoundOnLocationWithCaster(Vector(-640, -9236, 401), "Redfall.AsharaRaven.Start", hero)
		Redfall.RavenStatueActive = true
		local particleName = "particles/dark_smoke_test.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, Vector(-640, -9236, 401))

		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		Timers:CreateTimer(3, function()
			EmitSoundOnLocationWithCaster(Vector(-640, -9236, 401), "Redfall.AsharaRaven.Activate", Redfall.RedfallMaster)
			local crow = Entities:FindByNameNearest("ForestRavenStatue", Vector(-633, -9246, 562 + Redfall.ZFLOAT), 1200)
			local activeCrowPosition = crow:GetAbsOrigin()
			UTIL_Remove(crow)
			local activeCrow = Entities:FindByNameNearest("ForestRavenStatueActive", Vector(-633, -9246, -213 + Redfall.ZFLOAT), 1200)
			activeCrow:SetAbsOrigin(activeCrowPosition - Vector(0, 0, 200))
			local spotlight = "particles/roshpit/spotlight.vpcf"
			local pfx2 = ParticleManager:CreateParticle(spotlight, PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(pfx2, 0, Vector(-640, -9236, 401))
			Timers:CreateTimer(2, function()
				EmitSoundOnLocationWithCaster(Vector(-640, -9236, 401), "Redfall.TreeHealedMain", Events.GameMaster)
				CrowMovement(hero)
			end)
		end)

		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[5].objective = "redfall_quest_5_objective_4"
		end
	end
end

function CrowMovement(hero)
	if hero:HasModifier("modifier_raven_courier_active") then
		return false
	end

	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_raven_courier_active", {})
	local raven = CreateUnitByName("redfall_lzard_guide", Vector(-2048, -9344, 1457), false, nil, nil, DOTA_TEAM_GOODGUYS)
	raven:SetOriginalModel("models/items/beastmaster/hawk/beast_heart_marauder_beast_heart_marauder_raven/beast_heart_marauder_beast_heart_marauder_raven.vmdl")
	raven:SetModel("models/items/beastmaster/hawk/beast_heart_marauder_beast_heart_marauder_raven/beast_heart_marauder_beast_heart_marauder_raven.vmdl")
	raven:SetModelScale(1.2)
	raven:SetAbsOrigin(Vector(-2048, -9344, 1457))
	raven:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	raven:SetBaseMoveSpeed(360)
	raven:AddAbility("redfall_raven_courier_ability"):SetLevel(1)
	raven.hero = hero
	local ability = raven:FindAbilityByName("redfall_raven_courier_ability")
	ability.velocity = 40
	ability:ApplyDataDrivenModifier(raven, raven, "modifier_raven_seeking_hero", {})
end

function RedfallWoodsmenTriggerOnStartTouch()
    Redfall:SpawnWoodDweller(Vector(-1728, -8000), Vector(0, 1))
	Redfall:SpawnWoodDweller(Vector(-1408, -8064), Vector(-0.2, 1))
	Redfall:SpawnWoodDweller(Vector(-1152, -7936), Vector(-1, 1))
	Redfall:SpawnWoodDweller(Vector(-1152, -7552), Vector(-1, 0))

	Redfall:SpawnBigFlower(Vector(-1472, -7680), Vector(-0.2, 1))
	Redfall:SpawnBigFlower(Vector(-1856, -7130), Vector(-0.8, 0.2))
	Redfall:SpawnBigFlower(Vector(-1664, -6656), Vector(-0.8, -0.8))

	Redfall:SpawnAutumnSpawner(Vector(-1152, -6976, 127), Vector(-1, -1), Vector(-1280, -7104))
	Redfall:SpawnAutumnSpawner(Vector(-1497, -6016, 127), Vector(0, -1), Vector(-1499, -6218))

	Redfall:SpawnForestGnome(Vector(-2048, -6464), Vector(0.8, -0.7))
	Redfall:SpawnForestGnome(Vector(-1344, -6912), Vector(-1, 0.1))
	Redfall:SpawnForestGnome(Vector(-1280, -6592), Vector(-1, 0.4))
	Redfall:SpawnForestGnome(Vector(-1152, -6464), Vector(-1, 0.8))

	local baseVector = Vector(-1427, -8704)
	local loops = GameState:GetDifficultyFactor() * 3
	for i = 1, loops, 1 do
		Timers:CreateTimer(i * 0.75, function()
			local position = baseVector + Vector(RandomInt(1, 1300), RandomInt(1, 280))
			local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddAbility("ability_blue_effect"):SetLevel(1)
			dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
			WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
			Timers:CreateTimer(10, function()
				local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
				unit:SetAbsOrigin(dummy:GetAbsOrigin())
				unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
				-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
				UTIL_Remove(dummy)
			end)
		end)
	end
	Timers:CreateTimer(4, function()
		local vectorTable = {Vector(-256, -7616), Vector(0, -7616), Vector(202, -7424), Vector(-352, -7329), Vector(94, -6804), Vector(-313, -6640)}
		local fvTable = {Vector(1, 1), Vector(-0.5, 1), Vector(-0.3, 0.7), Vector(1, 0.6), Vector(-1, 1), Vector(-0.6, 1)}
		for i = 1, #vectorTable, 1 do
			Redfall:SpawnSoulReacher(vectorTable[i], fvTable[i])
		end
		Redfall:SpawnAutumnSummoner(Vector(-832, -5760), Vector(-0.2, -1))
		Redfall:SpawnAutumnSummoner(Vector(-384, -6031), Vector(-1, 0))
	end)
end

function RedfallForestRangerTriggerOnStartTouch()
    local vectorTable = {Vector(-5056, -7552), Vector(-4928, -6976), Vector(-4529, -6272), Vector(-3904, -6101), Vector(-3456, -6240), Vector(-3837, -6528), Vector(-3406, -6912)}
	local fvTable = {Vector(0, -1), Vector(-0.2, -1), Vector(-1, -0.6), Vector(-1, 0), Vector(-1, 0.2), Vector(-1, 1), Vector(0, 1)}
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnForestRanger(vectorTable[i], fvTable[i])
	end
	Redfall:SpawnWoodDweller(Vector(-5377, -7232), Vector(1, -1))
	Redfall:SpawnForestGnome(Vector(-3904, -7360), Vector(1, 1))
	Redfall:SpawnForestGnome(Vector(-4096, -7168), Vector(1, 0.7))
	Redfall:SpawnAutumnSpawner(Vector(-3840, -5696, 127), Vector(-1, -1), Vector(-3968, -5824))
end

function RedfallForestAquaLilyTrigger1OnStartTouch()
	local baseVector = Vector(-6170, -7488)
	local loops = -3 + (GameState:GetDifficultyFactor() * 6)
	for i = 1, loops, 1 do
		Timers:CreateTimer(i * 0.75, function()
			local position = baseVector + Vector(RandomInt(1, 600), RandomInt(1, 950))
			local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddAbility("ability_blue_effect"):SetLevel(1)
			dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
			WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
			local pfx = CustomAbilities:QuickAttachParticle("particles/econ/generic/generic_buff_1/generic_buff_1.vpcf", dummy, 10)
			ParticleManager:SetParticleControl(pfx, 14, Vector(1,1,1))
			ParticleManager:SetParticleControl(pfx, 15, Vector(0,30,255))
			Timers:CreateTimer(10, function()
				local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
				unit:SetAbsOrigin(dummy:GetAbsOrigin())
				unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
				EmitSoundOn("Redfall.Aqualily.Spawn", unit)
				CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 4)
				-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
				UTIL_Remove(dummy)
			end)
		end)
	end
end

function RedfallTopRightForestTriggerOnStartTouch()
    local fvTarget = Vector(-2816, -5248)
	local snakePosTable = {Vector(-3584, -5248), Vector(-3328, -5184), Vector(-3535, -4947), Vector(-3584, -4928), Vector(-3328 - 4800), Vector(-3072, -4928), Vector(-3584, -4608)}
	for i = 1, #snakePosTable, 1 do
		local fv = ((fvTarget - snakePosTable[i]) * Vector(1, 1, 0)):Normalized()
		Redfall:SpawnAshSnake(snakePosTable[i], fv, false)
	end
	Redfall:SpawnCliffWeed(Vector(-3392, -4160), Vector(0.2, -1))
	Redfall:SpawnCliffWeed(Vector(-2752, -4352), Vector(-0.5, -1))
	Redfall:SpawnCliffWeed(Vector(-3136, -4416), Vector(0, -1))

	Redfall:SpawnStoneWatcher(Vector(-2432, -5632), Vector(1, -1))
	Redfall:SpawnStoneWatcher(Vector(-2863, -5356), Vector(1, -0.5))

	Redfall:SpawnAutumnSpawner(Vector(-3776, -4480, 127), Vector(-1, -1), Vector(-3648, -4672))
end

function RedfallForestEndTriggerOnStartTouch()
	local position1 = Vector(-6344, -4834)
	local position2 = Vector(-8042, -4408)
	local position3 = Vector(-9729, -5885)
	local position4 = Vector(-7524, -5764)
	local positionTable = {position1, position2, position3, position4}
	local skeletonsPerPatrol = 2
	if GameState:GetDifficultyFactor() == 3 then
		skeletonsPerPatrol = 3
	end
	for i = 1, #positionTable, 1 do
		for j = 1, skeletonsPerPatrol, 1 do
			local ashKnight = Redfall:SpawnAshKnight(positionTable[i] + RandomVector(RandomInt(60, 200)))
			--print(((i)%4)+1)
			Redfall:AddPatrolArguments(ashKnight, 30, 5, 240, {positionTable[((i) % 4) + 1], positionTable[((i + 1) % 4) + 1], positionTable[((i + 2) % 4) + 1], positionTable[((i + 3) % 4) + 1]})
		end
	end
	Redfall:SpawnAutumnSatyr(Vector(-5669, -4792), Vector(1, 0))
	Redfall:SpawnAutumnSatyr(Vector(-5873, -4479), Vector(1, -0.5))
	Redfall:SpawnAutumnSatyr(Vector(-5851, -5120), Vector(1, 0.5))
	Redfall:SpawnAutumnSatyr(Vector(-6464, -5184), Vector(1, 1))
	Redfall:SpawnAutumnSatyr(Vector(-6464, -4608), Vector(1, -0.5))

	local vultureTable = {Vector(-5504, -4160), Vector(-5632, -3968), Vector(-6784, -4608), Vector(-7104, -4352), Vector(-7232, -4736), Vector(-9344, -4416), Vector(-7616, -5888), Vector(-7296, -6016)}
	local lookPosition = Vector(-5952, -4800)
	for i = 1, #vultureTable, 1 do
		Timers:CreateTimer(0.5 * i, function()
			local fv = (lookPosition - vultureTable[i]):Normalized()
			Redfall:SpawnAutumnVulture(vultureTable[i], fv)
		end)
	end
	Timers:CreateTimer(2, function()
		Redfall:SpawnAutumnSpirit(Vector(-9088, -4544), Vector(1, 0))
		Redfall:SpawnAutumnSpirit(Vector(-8832, -5888), Vector(1, 0.2))
		Redfall:SpawnAutumnSpirit(Vector(-7168, -5696), Vector(1, 1))
	end)
	Redfall:SpawnAutumnCragnataur(Vector(-7872, -3788), Vector(1, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-8764, -4288), Vector(1, -0.2))
	Redfall:SpawnAutumnCragnataur(Vector(-7104, -4032), Vector(0.2, -1))
	Timers:CreateTimer(5, function()
		Redfall:SpawnBigFlower(Vector(-9216, -6080), Vector(-1, 0))
		Redfall:SpawnBigFlower(Vector(-7872, -5824), Vector(-1, 0.5))
		Redfall:SpawnBigFlower(Vector(-8896, -4864), Vector(-1, 1))
		Redfall:SpawnBigFlower(Vector(-9536, -5120), Vector(-1, 1))
	end)
end

function RedfallForestFinalBridgeTriggerOnStartTouch()
	Redfall:SpawnAutumnCragnataur(Vector(-8384, -1408), Vector(1, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-8064, -1216), Vector(0, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-7744, -1408), Vector(-1, -1))
	Redfall:SpawnStoneWatcher(Vector(-8512, -1088), Vector(1, -0.6))
	Redfall:SpawnStoneWatcher(Vector(-8192, -960), Vector(0.7, -0.9))

	Redfall:SpawnAutumnVulture(Vector(-8704, -935), Vector(1, -1))
	Redfall:SpawnAutumnVulture(Vector(-7104, -1088), Vector(-1, -1))

	Redfall:SpawnAutumnSatyr(Vector(-7680, -1024), Vector(-1, -0.8))
	Redfall:SpawnAutumnSatyr(Vector(-7424, -1216), Vector(-1, -0.3))
end

function RedfallForestStaffAreaTriggerOnStartTouch()
    Redfall:SpawnAutumnSummoner(Vector(-7552, -10816), Vector(0.3, 1))
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnAutumnSummoner(Vector(-6400, -10496), Vector(0, -1))
	end
	Redfall:SpawnAutumnSummoner(Vector(-5568, -10496), Vector(0, -1))
	Redfall:SpawnAutumnSpirit(Vector(-6976, -10816), Vector(-1, 0))
	Redfall:SpawnAutumnSpawner(Vector(-5696, -9728, 80), Vector(-1, 1), Vector(-5836, -9864))
	local vectorTable = {}
	local bottomLeftPos = Vector(-6592, -10688)
	for i = 0, 8 + GameState:GetDifficultyFactor() * 4, 1 do
		local randomX = RandomInt(1, 1200)
		local randomY = RandomInt(1, 720)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroomAsync(vectorTable[i])
	end
end

function RedfallAsharaGlaiveTriggerOnStartTouch(trigger)
    local hero = trigger.activator
	if Redfall.AsharaWavesCounters then
		return false
	end
    if hero:HasModifier("modifier_blessing_of_ashara") then
        Quests:IncrementQuestObjective("seeking_ashara_objective4")

		Timers:CreateTimer(0.5, function()
			local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
			local radius = 450
			local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, hero)
			ParticleManager:SetParticleControl(particle2, 0, GetGroundPosition(Vector(1257, -15003, 520 + Redfall.ZFLOAT), hero))
			ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
			ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
			ParticleManager:SetParticleControl(particle2, 4, Vector(255, 40, 0))
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(particle2, false)
			end)
		end)

		EmitSoundOnLocationWithCaster(Vector(1257, -15003, 520 + Redfall.ZFLOAT), "Redfall.AsharaRaven.Start", hero)

		local glaive = Entities:FindByNameNearest("AsharaGlaive", Vector(1257, -15003, 520 + Redfall.ZFLOAT), 600)
		for i = 1, 120, 1 do
			Timers:CreateTimer(i * 0.03, function()
				if i % 12 == 0 then
					EmitSoundOnLocationWithCaster(glaive:GetAbsOrigin(), "Redfall.AsharaBlade.Spin", Redfall.RedfallMaster)
				end
				if i % 75 == 0 then
					local particleName = "particles/roshpit/redfall/ashara_moonbeam_lucent_beam_impact_shared_ti_5_gold.vpcf"
					local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
					for i = 1, 8, 1 do
						ParticleManager:SetParticleControl(pfx, i, Vector(1257, -15003, 520 + Redfall.ZFLOAT))
					end
					ParticleManager:SetParticleControl(pfx, 2, Vector(0, 0, 1000))
					for i = 3, 12, 1 do
						ParticleManager:SetParticleControl(pfx, i, Vector(1257, -15003, 520 + Redfall.ZFLOAT))
					end
					EmitSoundOnLocationWithCaster(Vector(1257, -15003, 520 + Redfall.ZFLOAT), "Redfall.SpiritAshara.BeamImpact", Events.GameMaster)
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end
				local spinIndex = 315 + i * 15
				spinIndex = spinIndex % 360
				glaive:SetAngles(0, spinIndex, -90)
				glaive:SetAbsOrigin(glaive:GetAbsOrigin() + Vector(0, 0, i / 10))
			end)
		end
		Timers:CreateTimer(3.8, function()
			UTIL_Remove(glaive)
		end)
		Timers:CreateTimer(2.0, function()
			Redfall.spawnPortalTable2 = {}
            local spawnPositionTable = {
                Vector(240, -14423), --Northwest
                Vector(2075, -14340),  --Northeast
                Vector(1280, -16000) --South
            }
			Timers:CreateTimer(2, function()
				for i = 1, #spawnPositionTable, 1 do
					local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/spawn_portal_counter.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
					ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i] + Vector(0, 0, 600 + Redfall.ZFLOAT))
					table.insert(Redfall.spawnPortalTable2, pfx)
					EmitSoundOnLocationWithCaster(spawnPositionTable[i], "Redfall.CaveUnitPortals", Redfall.RedfallMaster)
				end
			end)
			Timers:CreateTimer(7, function()
                Redfall.AsharaWavesCounters = { }
                Redfall.AsharaWavesCounters[1] = { }
                Redfall.AsharaWavesCounters[1]["killed"] = 0
                Redfall.AsharaWavesCounters[1]["total"] = 9 + 9 + 9
				for i = 1, #spawnPositionTable, 1 do
					local delay = 1.2
					if GameState:GetDifficultyFactor() == 2 then
						delay = 1
					elseif GameState:GetDifficultyFactor() == 3 then
						delay = 0.8
					end
					Redfall:SpawnRedfallAsharaWaveUnitAsync("redfall_forest_ranger", spawnPositionTable[i], 1, 9, delay, true)
				end
			end)
		end)
	end
end
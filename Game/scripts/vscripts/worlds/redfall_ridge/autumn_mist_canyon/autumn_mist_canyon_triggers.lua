
function AutumnMistCanyonAsharaShrineTriggerOnStartTouch(trigger)
    local hero = trigger.activator
    print("Triggered")
	if Redfall.AsharaPortalActive and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-9762, 15337)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function AutumnMistCanyonRoom2Part1TriggerOnStartTouch()
    Redfall:SpawnPanKnight(Vector(-14080, -4288), Vector(0, -1))
	Redfall:SpawnPanKnight(Vector(-14272, -4160), Vector(0.3, -1))

	Redfall:SpawnAlphaBeast(Vector(-14336, -4672), Vector(1, 0))
	Redfall:SpawnAlphaBeast(Vector(-14912, -4288), Vector(1, -1))
	Redfall:SpawnAlphaBeast(Vector(-15104, -3712), Vector(0, -1))

	Redfall:SpawnAutumnCragnataur(Vector(-15040, -3072), Vector(0, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-14720, -3072), Vector(0, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-14400, -3072), Vector(0, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-14080, -3072), Vector(0, -1))

	Timers:CreateTimer(3, function()
		for i = 0, 11, 1 do
			Redfall:SpawnAutumnEnforcer(Vector(-14848 + (i * 100), -2688), Vector(0, -1))
		end
	end)
	Timers:CreateTimer(4, function()
		Redfall:SpawnCanyonBreaker(Vector(-13952, -2176), Vector(0, -1))
	end)
	if GameState:GetDifficultyFactor() > 1 then
		local luck = RandomInt(1, 4)
		if luck == 1 or Beacons.cheats then
			Redfall:SpawnFeronia(Vector(-12992, 2880), RandomVector(1))
		end
	end
end

function AutumnMistCanyonRoom2Part2TriggerOnStartTouch()
    Redfall:SpawnAlphaBeast(Vector(-15104, -832), Vector(0.7, 1))
	Redfall:SpawnCanyonPredator(Vector(-14080, -1088), Vector(0, -1))
	Redfall:SpawnCanyonPredator(Vector(-14367, -704), Vector(1, -1))
	Redfall:SpawnCanyonPredator(Vector(-14848, -640), Vector(1, 0))
	Redfall:SpawnCanyonBreaker(Vector(-15168, 88), Vector(0, -1))
	Timers:CreateTimer(1.5, function()
		local vectorTable = {Vector(-15097, 704), Vector(-15242, 896), Vector(-14965, 891), Vector(-15371, 1088), Vector(-15097, 1088), Vector(-14825, 1088)}
		for i = 1, #vectorTable, 1 do
			Redfall:SpawnArmoredCrabBeast(vectorTable[i], Vector(0, -1))
		end
	end)
	Timers:CreateTimer(4, function()
		local position1 = Vector(-14019, 2560)
		local position2 = Vector(-15104, 1600)
		local position3 = Vector(-12992, 1408)
		local position4 = Vector(-12486, 2480)
		local positionTable = {position1, position2, position3, position4}
		local skeletonsPerPatrol = 2
		for i = 1, #positionTable, 1 do
			for j = 1, skeletonsPerPatrol, 1 do
				local ashknight = false
				if i % 2 == 0 then
					ashKnight = Redfall:SpawnAutumnCragnataur(positionTable[i] + RandomVector(RandomInt(60, 200)))
				else
					ashKnight = Redfall:SpawnPanKnight(positionTable[i] + RandomVector(RandomInt(60, 200)))
				end
				Redfall:AddPatrolArguments(ashKnight, 30, 5, 240, {positionTable[((i) % 4) + 1], positionTable[((i + 1) % 4) + 1], positionTable[((i + 2) % 4) + 1], positionTable[((i + 3) % 4) + 1]})
			end
		end
	end)
	Timers:CreateTimer(6, function()
		Redfall:SpawnCanyonBull(Vector(-14208, 1152), Vector(-1, -0.1))
		Redfall:SpawnCanyonBull(Vector(-14592, 2304), Vector(-1, -0.5))
		Redfall:SpawnCanyonBull(Vector(-13056, 2624), Vector(-1, 0))
		Redfall:SpawnCanyonBull(Vector(-13056, 1516), Vector(-1, -0.2))
		Redfall:SpawnAutumnTyrant(Vector(-13312, 768), Vector(-0.2, 1))
	end)
	Timers:CreateTimer(8, function()
		Redfall:SpawnArmoredCrabBeast(Vector(-12913, 3008), Vector(-0.2, -1))
		Redfall:SpawnArmoredCrabBeast(Vector(-12616, 2272), Vector(1, 0.5))
		Redfall:SpawnArmoredCrabBeast(Vector(-12691, 2048), Vector(1, 1))
		Redfall:SpawnArmoredCrabBeast(Vector(-12032, 2304), Vector(-1, 0))
		Redfall:SpawnArmoredCrabBeast(Vector(-11904, 2174), Vector(-1, 0))
		Redfall:SpawnArmoredCrabBeast(Vector(-12135, 1856), Vector(-1, 1))
	end)
	Timers:CreateTimer(10, function()
		Redfall:SpawnCanyonDinosaur(Vector(-11712, 3200), Vector(-1, -1))
	end)
end

function AutumnMistCanyonBruiserAmbushTriggerOnStartTouch()
    for i = 1, 12 + GameState:GetDifficultyFactor() * 4, 1 do
		Timers:CreateTimer(i * 0.4, function()
			local position = Vector(-13082, -2368 + RandomInt(1, 550))
			local bruiser = Redfall:SpawnCanyonBruiser(position, Vector(-1, 0), true)
			bruiser.jumpEnd = "basic_dust"
			WallPhysics:Jump(bruiser, Vector(-1, 0), 11 + RandomInt(1, 4), 11 + RandomInt(1, 4), 30, 1)
			StartAnimation(bruiser, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.8})
		end)
	end
end

function AutumnMistCanyonPlateTriggerOnStartTouch()
	if Redfall.AutumnMistCanyon then
		if not Redfall.spawnPortalStarted then
			Redfall.spawnPortalStarted = true
			Redfall:ActivateSwitchGeneric(Vector(-15119, 10872, Redfall.ZFLOAT), "AutumnMistCaveSwitch", true, 0.3)
			Redfall.spawnPortalTable = {}
            local spawnPositionTable = {
                Vector(-14729, 10916), 
                Vector(-15040, 8960), 
                Vector(-11968, 9920)
            }
            Redfall.AutumnMistCanyonWavesCounters = { }
            Redfall.AutumnMistCanyonWavesCounters[1]["killed"] = 0
            Redfall.AutumnMistCanyonWavesCounters[1]["total"] = 13 * 3
			Timers:CreateTimer(2, function()
				for i = 1, #spawnPositionTable, 1 do
					local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/spawn_portal_counter.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
					ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i] + Vector(0, 0, 150 + Redfall.ZFLOAT))
					table.insert(Redfall.spawnPortalTable, pfx)
					EmitSoundOnLocationWithCaster(spawnPositionTable[i], "Redfall.CaveUnitPortals", Redfall.RedfallMaster)
				end
			end)
			Timers:CreateTimer(7, function()
				for i = 1, #spawnPositionTable, 1 do
					local delay = 1.2
					if GameState:GetDifficultyFactor() == 2 then
						delay = 1
					elseif GameState:GetDifficultyFactor() == 3 then
						delay = 0.8
					end
					Redfall:SpawnCaveWaveUnit("redfall_mist_knight", spawnPositionTable[i], 1, 13, delay, true)
				end
			end)
		end
	end
end

function AutumnMistCanyonTreeTriggerOnStartTouch(trigger)
	if Redfall.CanyonLastTreeReady then
		if not Redfall.LastCanyonTreeActivated then
			Redfall.LastCanyonTreeActivated = true
			local hero = trigger.activator
			local position = hero:GetAbsOrigin()
			local tree = Entities:FindByNameNearest("VermillionTreeCorrupted", Vector(position.x, position.y, 130 + Redfall.ZFLOAT), 1200)
			if tree then
                local particleName = "particles/dark_smoke_test.vpcf"
                local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
                ParticleManager:SetParticleControl(pfx, 0, tree:GetAbsOrigin())
                EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Redfall.CorruptedTreeStart", Redfall.RedfallMaster)
                local treeDummy = CreateUnitByName("npc_dummy_unit", tree:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
                treeDummy.cultistsSlain = 0
                treeDummy.cultistsTarget = 15
                treeDummy.tree = tree
                treeDummy:AddAbility("dummy_unit"):SetLevel(1)
                treeDummy.pfx = pfx
                treeDummy.boss = true
                Timers:CreateTimer(3.5, function()
                    for i = 1, 20, 1 do
                        Timers:CreateTimer(i * 0.6, function()
                            local cultist = Redfall:SpawnCrimsythCultistForTree(tree:GetAbsOrigin(), Vector(0, -1), tree:GetAbsOrigin())
                            cultist.treeDummy = treeDummy
                        end)
                    end
                end)
                Redfall.CanyonTreeDummy = treeDummy
			end
		end
	end
end
function Winterblight:FirstShrineSpawn()
	if not Winterblight.AzaleaSpawn1 then
		Winterblight.AzaleaSpawn1 = true
		local positionTable = {Vector(10944, -10688), Vector(11345, -10688), Vector(10605, -11294), Vector(10605, -11584), Vector(11712, -11295), Vector(11712, -11583), Vector(11392, -11904), Vector(11171, -11904), Vector(10944, -11904)}
		for i = 1, #positionTable, 1 do
			Winterblight:SpawnAzaleaMaiden(positionTable[i], Vector(0,1))
		end
		local patspawn = RandomInt(1, 3)
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(10535, -11008), Vector(11776, -11008), Vector(10560, -11968), Vector(11776, -11968)}
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
		        for j = 0, 2, 1 do
		          Timers:CreateTimer(j*0.8, function()
		          	if patspawn == 1 then
			            local elemental = Winterblight:SpawnColdSeer(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 15, 5, 220, patrolPositionTable)
			        elseif patspawn == 2 then
			            local elemental = Winterblight:SpawnRiderOfAzalea(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 15, 5, 220, patrolPositionTable)
			        elseif patspawn == 3 then
			            local elemental = Winterblight:SpawnAzaleaSorceress(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 15, 5, 220, patrolPositionTable)
			        end
		          end)
		        end
		      end)
		    end
		end)
		Timers:CreateTimer(0.7, function()
			local positionTable = {Vector(10880, -11008), Vector(11072, -11008), Vector(11264, -11008), Vector(11456, -11008)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostAvatar(positionTable[i], Vector(0,1))
			end
		end)
		local crystalPosTable = {Vector(10496, -11008), Vector(10496, -11960), Vector(11776, -11960), Vector(11776, -11008)}
		Winterblight.AzaleaCrystalTable = {}
		Winterblight.tripleSwitchCount = 0
		for i = 1, 4, 1 do
			Winterblight:SpawnAzaleaCrystal(crystalPosTable[i], i)
		end
		Winterblight:SpawnMasterAzaleaCrystal()
	end
end

function Winterblight:SpawnAzaleaMaiden(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_maiden_of_azalea", position, 0, 1, "Winterblight.Maiden.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 3, false)
	stone.itemLevel = 36
	stone.dominion = true
	return stone
end

function Winterblight:SpawnAzaleaCrystal(position, index)
	position = position + Vector(0,0,487+Winterblight.ZFLOAT)
    local crystal = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    local yaw = RandomInt(0, 345)

    crystal:SetAngles(0, yaw, 0)

    crystal:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    crystal:SetOriginalModel("models/winterblight/azalea_crystal.vmdl")
    crystal:SetModel("models/winterblight/azalea_crystal.vmdl")
    crystal:SetAbsOrigin(position)
    crystal:AddAbility("winterblight_attackable_unit"):SetLevel(1)
    crystal:RemoveAbility("dummy_unit")
    crystal:RemoveModifierByName("dummy_unit")
    crystal.basePosition = position

    crystal.yaw = yaw

    crystal.pushLock = true
    crystal.dummy = true
    crystal.jumpLock = true
    -- AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 500, 99999, false)

    local prop_ability = crystal:FindAbilityByName("winterblight_attackable_unit")
    prop_ability:ApplyDataDrivenModifier(crystal, crystal, "modifier_icy_appearance", {})
    crystal.prop_id = 1
    crystal:SetRenderColor(100, 100, 100)
    local switchPossibilities = {1,2,3,4}
    local thisPossibilities = {}
    for i = 1, #switchPossibilities, 1 do
    	if #thisPossibilities < 2 then
	    	if i == index then
	    	else
	    		local luck = RandomInt(1, 2)
	    		if luck == 1 then
	    			table.insert(thisPossibilities, switchPossibilities[i])
	    		else
	    			if #thisPossibilities == 0 and i > 3 then
	    				table.insert(thisPossibilities, switchPossibilities[i])
	    			elseif #thisPossibilities == 0 and i > 2 and index == 4 then
	    				table.insert(thisPossibilities, switchPossibilities[i])
	    			end
	    		end
	    	end
	    	-- if index == 2 then
	    	-- 	if Winterblight.AzaleaCrystalTable[1].switches == {2,3} and thisPossibilities == {1,3} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	elseif Winterblight.AzaleaCrystalTable[1].switches == {2,4} and thisPossibilities == {1,4} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[1].switches == {2} and thisPossibilities == {1} then
	    	-- 		table.insert(thisPossibilities, RandomInt(3,4))
	    	-- 	end
	    	-- elseif index == 3 then
	    	-- 	if Winterblight.AzaleaCrystalTable[1].switches == {2,3} and thisPossibilities == {1,2} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[2].switches == {1,3} and thisPossibilities == {1,2} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	elseif Winterblight.AzaleaCrystalTable[2].switches == {3,4} and thisPossibilities == {2,4} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	--
	    	-- 	if Winterblight.AzaleaCrystalTable[2].switches == {3} and thisPossibilities == {2} then
	    	-- 		local switchAdd = RandomInt(1, 2)
	    	-- 		if switchAdd == 1 then
	    	-- 			table.insert(thisPossibilities, 1)
	    	-- 		elseif switchAdd == 2 then
	    	-- 			table.insert(thisPossibilities, 4)
	    	-- 		end
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[1].switches == {3} and thisPossibilities == {1} then
	    	-- 		local switchAdd = RandomInt(1, 2)
	    	-- 		if switchAdd == 1 then
	    	-- 			table.insert(thisPossibilities, 2)
	    	-- 		elseif switchAdd == 2 then
	    	-- 			table.insert(thisPossibilities, 4)
	    	-- 		end
	    	-- 	end
	    	-- elseif index == 4 then
	    	-- 	if Winterblight.AzaleaCrystalTable[1].switches == {2,4} and thisPossibilities == {1,2} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[1].switches == {3,4} and thisPossibilities == {1,3} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[2].switches == {1,4} and thisPossibilities == {1,2} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[2].switches == {3,4} and thisPossibilities == {2,3} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[3].switches == {1,4} and thisPossibilities == {1,3} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[3].switches == {2,4} and thisPossibilities == {2,3} then
	    	-- 		table.remove(thisPossibilities, 1)
	    	-- 	end
	    	-- 	--
	    	-- 	if Winterblight.AzaleaCrystalTable[1].switches[1] == 4 and thisPossibilities[1] == 1 then
	    	-- 		table.insert(thisPossibilities, RandomInt(2,3))
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[2].switches == {4} and thisPossibilities == {2} then
	    	-- 		local switchAdd = RandomInt(1, 2)
	    	-- 		if switchAdd == 1 then
	    	-- 			table.insert(thisPossibilities, 1)
	    	-- 		elseif switchAdd == 2 then
	    	-- 			table.insert(thisPossibilities, 3)
	    	-- 		end
	    	-- 	end
	    	-- 	if Winterblight.AzaleaCrystalTable[3].switches == {4} and thisPossibilities == {3} then
	    	-- 		local switchAdd = RandomInt(1, 2)
	    	-- 		if switchAdd == 1 then
	    	-- 			table.insert(thisPossibilities, 1)
	    	-- 		elseif switchAdd == 2 then
	    	-- 			table.insert(thisPossibilities, 2)
	    	-- 		end
	    	-- 	end
	    	-- end
	    	-- if #thisPossibilities == 2 then
	    	-- 	Winterblight.tripleSwitchCount = Winterblight.tripleSwitchCount + 1
	    	-- end
	    	-- if Winterblight.tripleSwitchCount > 2 and index > 3 then
	    	-- 	table.remove(thisPossibilities, 1)
	    	-- end
	    end
    end
    crystal:SetModelScale(1.0)
    crystal.switches = WallPhysics:table_unique(thisPossibilities)
    crystal.index = index
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", crystal, 3)
    table.insert(Winterblight.AzaleaCrystalTable, crystal)
end

function Winterblight:SpawnMasterAzaleaCrystal()
	local position = Vector(11158, -11456, 802+Winterblight.ZFLOAT)
    local crystal = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    local yaw = RandomInt(0, 345)

    crystal:SetAngles(0, yaw, 0)

    crystal:SetModelScale(1.5)
    crystal:SetOriginalModel("models/winterblight/azalea_crystal.vmdl")
    crystal:SetModel("models/winterblight/azalea_crystal.vmdl")
    crystal:SetAbsOrigin(position)

    crystal:RemoveAbility("dummy_unit")
    crystal:RemoveModifierByName("dummy_unit")
    crystal.basePosition = position

    crystal.yaw = yaw
    crystal:AddAbility("winterblight_azalea_master_crystal"):SetLevel(1)
    crystal.pushLock = true
    crystal.dummy = true
    crystal.jumpLock = true
    local colorTable = {"red", "blue", "yellow"}
    Winterblight.MasterCrystalColor = colorTable[RandomInt(1, 3)]
    Winterblight.MasterCrystal = crystal
    if Winterblight.MasterCrystalColor == "red" then
    	crystal:SetRenderColor(220, 100, 100)
    elseif Winterblight.MasterCrystalColor == "blue" then
    	crystal:SetRenderColor(100, 100, 220)
    elseif Winterblight.MasterCrystalColor == "yellow" then
    	crystal:SetRenderColor(220, 220, 100)
    end
    crystal.locked = true
    Timers:CreateTimer(12, function()
    	crystal.locked = false
    end)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", crystal, 3)
    -- AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 500, 99999, false)
end

function Winterblight:AttackAzaleaCrystal(caster, bOrigin)
	local crystal = caster
	if crystal:HasModifier("modifier_crystal_finished") then
		return false
	end
	if not crystal.color then
		crystal.color = "red"
	else
		if crystal.color == "red" then
			crystal.color = "blue"
		elseif crystal.color == "blue" then
			crystal.color = "yellow"
		elseif crystal.color == "yellow" then
			crystal.color = "red"
		end
	end
    if crystal.color == "red" then
    	crystal:SetRenderColor(220, 100, 100)
    elseif crystal.color == "blue" then
    	crystal:SetRenderColor(100, 100, 220)
    elseif crystal.color == "yellow" then
    	crystal:SetRenderColor(220, 220, 100)
    end
    print(bOrigin)
    if bOrigin then
	    for i = 1, #crystal.switches, 1 do
	    	print(crystal.switches[i])
	    	Winterblight:AttackAzaleaCrystal(Winterblight.AzaleaCrystalTable[crystal.switches[i]], false)
	    end
	    Winterblight:CheckAndProcessCrystals()
	end
	
end

function Winterblight:CheckAndProcessCrystals()
	local match_count = 0
	local pfxName = ""
	if Winterblight.MasterCrystalColor == "red" then
		pfxName = "particles/units/heroes/hero_wisp/epoch_rune_b_a.vpcf"
	elseif Winterblight.MasterCrystalColor == "blue" then
		pfxName = "particles/units/heroes/hero_wisp/wisp_tether_agh.vpcf"
	elseif Winterblight.MasterCrystalColor == "yellow" then
		pfxName = "particles/roshpit/winterblight/tether_yellow.vpcf"
	end
	for i = 1, #Winterblight.AzaleaCrystalTable, 1 do
		local crystal = Winterblight.AzaleaCrystalTable[i]
		if crystal.color == Winterblight.MasterCrystalColor then
			match_count = match_count + 1
			if not crystal.pfx then
				crystal.pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(crystal.pfx, 0, crystal, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", crystal:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(crystal.pfx, 1, Winterblight.MasterCrystal, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", Winterblight.MasterCrystal:GetAbsOrigin(), true)
				EmitSoundOn("Winterblight.AzaleaCrystal.Match", crystal)
			end
		elseif crystal.pfx then
			ParticleManager:DestroyParticle(crystal.pfx, false)
			crystal.pfx = false
		end
	end
	if match_count == 4 then
		EmitSoundOnLocationWithCaster(Winterblight.MasterCrystal:GetAbsOrigin(), "Winterblight.AzaleaCrystal.FinishPuzzle", Winterblight.Master)
		local ability = Winterblight.MasterCrystal:FindAbilityByName("winterblight_azalea_master_crystal")
		for i = 1, #Winterblight.AzaleaCrystalTable, 1 do
			local crystal = Winterblight.AzaleaCrystalTable[i]
			ability:ApplyDataDrivenModifier(Winterblight.MasterCrystal, crystal, "modifier_crystal_finished", {})
		end
		ability:ApplyDataDrivenModifier(Winterblight.MasterCrystal, Winterblight.MasterCrystal, "modifier_crystal_finished", {})
		Winterblight:RemoveBlockers(8.5, "AzaleaBridgeBlocker", Vector(12864, -11520, 300+Winterblight.ZFLOAT), 5400)
		for i = 1, 300, 1 do
			Timers:CreateTimer(0.03*i, function()
				if i %40 == 0 then
					EmitSoundOnLocationWithCaster(Vector(13689, -11473), "Winterblight.AzaleaBridge.Raise", Events.GameMaster)
				end
				Winterblight.AzaleaBridge1:SetAbsOrigin(Winterblight.AzaleaBridge1:GetAbsOrigin()+Vector(0,0,1500/300))
			end)
		end
		Timers:CreateTimer(3, function()
			local walls = Entities:FindAllByNameWithin("AzaleaWall1", Vector(13689, -11473, -4094+Winterblight.ZFLOAT), 2400)
		    EmitSoundOnLocationWithCaster(Vector(13689, -11473), "Winterblight.WallOpen", Events.GameMaster)
		    Winterblight:WallsTicks(false, walls, true, 5, 360, 0.1)
		    Winterblight:RemoveBlockers(4, "AzaleaBlocker1", Vector(13689, -11473, 300+Winterblight.ZFLOAT), 1800)
		    Winterblight:ShrineSpawn2()
		end)
		Timers:CreateTimer(9, function()
			EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge1:GetAbsOrigin(), "Winterblight.AzaleaBridge.Finish", Winterblight.Master)
			Timers:CreateTimer(0.1, function()
				EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge1:GetAbsOrigin(), "Winterblight.Azalea.Win", Winterblight.Master)
			end)
			local positionTable = {Vector(12096, -11392), Vector(12096, -11496), Vector(12096, -11592), Vector(12096, -11692), Vector(14065, -11392), Vector(14065, -11496), Vector(14065, -11592), Vector(14065, -11592)}
            for i = 1, #positionTable, 1 do
              local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
              ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(positionTable[i], Events.GameMaster ))
              ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
              Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(pfx, false)
              end)
            end
		end)
		--OPEN DOOR RAISE BRIDGE
	end
end

function Winterblight:ShrineSpawn2()
	if not Winterblight.Shrine2spawned then
		Winterblight.Shrine2spawned = true
		Winterblight:SpawnZefnar(Vector(15168, -11200), Vector(-1,-1))
		local luck = RandomInt(1, 4)
		if luck == 1 then
			Winterblight.AzaleaOperator = "plus"
			Winterblight.AzaleaOperatorPlus:SetAbsOrigin(Winterblight.AzaleaOperatorPlus:GetAbsOrigin()+Vector(0,0,1500))
		elseif luck == 2 then
			Winterblight.AzaleaOperator = "minus"
			Winterblight.AzaleaOperatorMinus:SetAbsOrigin(Winterblight.AzaleaOperatorMinus:GetAbsOrigin()+Vector(0,0,1500))
		elseif luck == 3 then
			Winterblight.AzaleaOperator = "multiply"
			Winterblight.AzaleaOperatorMult:SetAbsOrigin(Winterblight.AzaleaOperatorMult:GetAbsOrigin()+Vector(0,0,1500))
		elseif luck == 4 then
			Winterblight.AzaleaOperator = "divide"
			Winterblight.AzaleaOperatorDivide:SetAbsOrigin(Winterblight.AzaleaOperatorDivide:GetAbsOrigin()+Vector(0,0,1500))
		end
		if Winterblight.AzaleaOperator == "plus" then
			local leftCount = RandomInt(1, 19)
			local rightCount = RandomInt(1, 20-leftCount)
			Winterblight.MathCount = leftCount + rightCount
			Winterblight.leftCount = leftCount
			Winterblight.rightCount = rightCount
		elseif Winterblight.AzaleaOperator == "minus" then
			local leftCount = RandomInt(2, 25)
			local rightCount = RandomInt(1+math.max(0, leftCount-21), leftCount-1)
			Winterblight.MathCount = leftCount - rightCount
			Winterblight.leftCount = leftCount
			Winterblight.rightCount = rightCount
		elseif Winterblight.AzaleaOperator == "multiply" then
			local leftCount = RandomInt(1, 9)
			local rightCount = 1
			if leftCount > 6 then
				rightCount = RandomInt(1, 2)
			elseif leftCount == 6 then
				rightCount = RandomInt(1, 3)
			elseif leftCount == 5 then
				rightCount = RandomInt(1, 4)
			elseif leftCount == 4 then
				rightCount = RandomInt(1, 5)
			elseif leftCount == 3 then
				rightCount = RandomInt(1, 6)
			elseif leftCount == 2 then
				rightCount = RandomInt(1, 10)
			elseif leftCount == 1 then
				rightCount = RandomInt(1, 20)
			end
			Winterblight.MathCount = leftCount * rightCount
			Winterblight.leftCount = leftCount
			Winterblight.rightCount = rightCount
		elseif Winterblight.AzaleaOperator == "divide" then
			local luck2 = RandomInt(1, 25)
			local leftPossibilites = {4,6,8,9,10,12,14,15,16,18,20,21,22,24,25}
			local leftCount = leftPossibilites[RandomInt(1, #leftPossibilites)]
			local rightPossibilites = {}
			if leftCount == 4 then
				rightPossibilites = {2}
			elseif leftCount == 6 then
				rightPossibilites = {2,3}
			elseif leftCount == 8 then
				rightPossibilites = {2,4}
			elseif leftCount == 9 then
				rightPossibilites = {3}
			elseif leftCount == 10 then
				rightPossibilites = {2,5}
			elseif leftCount == 12 then
				rightPossibilites = {2,3,4,6}
			elseif leftCount == 14 then
				rightPossibilites = {2,7}
			elseif leftCount == 15 then
				rightPossibilites = {3,5}
			elseif leftCount == 16 then
				rightPossibilites = {2,4,8}
			elseif leftCount == 18 then
				rightPossibilites = {2,6,9}
			elseif leftCount == 20 then
				rightPossibilites = {2,4,5,10}
			elseif leftCount == 21 then
				rightPossibilites = {3,7}
			elseif leftCount == 22 then
				rightPossibilites = {2,11}
			elseif leftCount == 24 then
				rightPossibilites = {2,3,4,6,8,12}
			elseif leftCount == 25 then
				rightPossibilites = {5}
			end
			local rightCount = rightPossibilites[RandomInt(1, #rightPossibilites)]
			Winterblight.MathCount = leftCount / rightCount
			Winterblight.leftCount = leftCount
			Winterblight.rightCount = rightCount
		end
		local left_abacus = Entities:FindAllByNameWithin("AzeleaAbacus", Vector(14222,-9628, 507+Winterblight.ZFLOAT), 2400)
		left_abacus = WallPhysics:ShuffleTable(left_abacus)
		if Winterblight.leftCount < 25 then
			for i = 1, 25-Winterblight.leftCount, 1 do
				UTIL_Remove(left_abacus[i])
			end
		end
		local right_abacus = Entities:FindAllByNameWithin("AzeleaAbacus2", Vector(15759,-9628, 507+Winterblight.ZFLOAT), 2400)
		right_abacus = WallPhysics:ShuffleTable(right_abacus)
		if Winterblight.rightCount < 25 then
			for i = 1, 25-Winterblight.rightCount, 1 do
				UTIL_Remove(right_abacus[i])
			end
		end
		print("------MATH!!!-----")
		print(Winterblight.leftCount.."-operator-"..Winterblight.rightCount)
		print(Winterblight.MathCount)
	end
end

function Winterblight:SpawnZefnar(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_zefnar", position, 2, 4, "Winterblight.Zefnar.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 3, false)
	stone.itemLevel = 36
	local health = 200
	if GameState:GetDifficultyFactor() == 2 then
		health = 500
	elseif GameState:GetDifficultyFactor() == 3 then
		health = 1500
	end
    stone:SetMaxHealth(health)
    stone:SetBaseMaxHealth(health)
    stone:SetHealth(health)
    stone.mainZefnar = true
	return stone
end

function Winterblight:SpawnMiniZefnar(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_zefnar", position, 0, 0, nil, fv, true)
	Events:AdjustBossPower(stone, 2, 3, false)
	stone.itemLevel = 36
	stone:SetModelScale(0.6)
	EmitSoundOn("Winterblight.Zefnar.SpawnMini", stone)
	stone:SetHullRadius(50)
	return stone
end

function Winterblight:ZefnarTakeDamage(zefnar, damage)
	if zefnar.mainZefnar then
		if zefnar:GetHealth()%10 == 0 then
			local fv = RandomVector(1)
			local stone = Winterblight:SpawnMiniZefnar(zefnar:GetAbsOrigin(), fv)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_stomp.vpcf", zefnar, 2)
			WallPhysics:Jump(stone, fv, RandomInt(8, 10), RandomInt(10, 16), RandomInt(16, 20), 1)
		end
		return 1
	else
		return damage
	end
end

function Winterblight:AzaleaSwitch1()
	if Winterblight.AzaleaSwitch1Dropped then
		if not Winterblight.AzaleaSwitch1Pressed then
			Winterblight.AzaleaSwitch1Pressed = true
			Winterblight:ActivateSwitchGeneric(Vector(15733, -11788, 78+Winterblight.ZFLOAT), "AzaleaSwitchProp1", true, 0.352)
			if not Winterblight.AzaleaMathCounter then
				Winterblight.AzaleaMathCounter = 0
			end
			Timers:CreateTimer(2, function()
				if Winterblight.AzaleaMathCounter == Winterblight.MathCount then
					EmitSoundOnLocationWithCaster(Vector(15733, -11788, 78+Winterblight.ZFLOAT), "Winterblight.AzaleaCrystal.FinishPuzzle", Winterblight.Master)
					Winterblight:RemoveBlockers(8.5, "AzaleaBridgeBlocker2", Vector(15104, -12480, 212+Winterblight.ZFLOAT), 5400)
					for i = 1, 300, 1 do
						Timers:CreateTimer(0.03*i, function()
							if i %40 == 0 then
								EmitSoundOnLocationWithCaster(Vector(15733, -11788, 78+Winterblight.ZFLOAT), "Winterblight.AzaleaBridge.Raise", Events.GameMaster)
							end
							Winterblight.AzaleaBridge2:SetAbsOrigin(Winterblight.AzaleaBridge2:GetAbsOrigin()+Vector(0,0,1500/300))
						end)
					end
					Timers:CreateTimer(3, function()
						local walls = Entities:FindAllByNameWithin("AzaleaWall2", Vector(15109, -12332, -4094+Winterblight.ZFLOAT), 2400)
					    EmitSoundOnLocationWithCaster(Vector(15109, -12332), "Winterblight.WallOpen", Events.GameMaster)
					    Winterblight:WallsTicks(false, walls, true, 5, 360, 0.1)
					    Winterblight:RemoveBlockers(4, "AzaleaWallBlockers2", Vector(15104, -12480, 300+Winterblight.ZFLOAT), 1800)
					    Winterblight:ShrineSpawn3()
					end)
					Timers:CreateTimer(9, function()
						EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge2:GetAbsOrigin(), "Winterblight.AzaleaBridge.Finish", Winterblight.Master)
						Timers:CreateTimer(0.1, function()
							EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge2:GetAbsOrigin(), "Winterblight.Azalea.Win", Winterblight.Master)
						end)
						local positionTable = {Vector(14976, -12800), Vector(15085, -12800), Vector(15168, -12800), Vector(15226, -12064), Vector(15136, -12064), Vector(15050, -12064)}
			            for i = 1, #positionTable, 1 do
			              local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			              ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(positionTable[i], Events.GameMaster ))
			              ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			              Timers:CreateTimer(2, function()
			                ParticleManager:DestroyParticle(pfx, false)
			              end)
			            end
					end)					
				else
					local spawnCount = RandomInt(math.max(Winterblight.MathCount, 18), 28) - Winterblight.AzaleaMathCounter
			    	local unitTable = {"winterblight_softwalker", "winterblight_cold_seer", "winterblight_winterbear", "winterblight_azalea_archer", "winterblight_azure_sorceress", "frost_whelpling", "winterblight_frost_avatar", "winterblight_frost_elemental", "winterblight_rider_of_azalea", "winterblight_azalean_priest", "winterblight_mistral_assassin", "winterblight_frost_frigid_hulk", "winterblight_ice_summoner", "winterblight_maiden_of_azalea"}
			    	local unitName = unitTable[RandomInt(1, #unitTable)]
			    	if spawnCount > 0 then
				    	for i = 1, spawnCount, 1 do
				    		Timers:CreateTimer(i*0.35, function()
					    		local unit = nil
					    		local position = Vector(14376, -11831) + Vector(RandomInt(0,1430), RandomInt(0, 1330))
					    		if unitName == "winterblight_softwalker" then
					    			unit = Winterblight:SpawnSoftwalker(position, RandomVector(1))
					    		elseif unitName == "winterblight_cold_seer" then
					    			unit = Winterblight:SpawnColdSeer(position, RandomVector(1))
					    		elseif unitName == "winterblight_winterbear" then
					    			unit = Winterblight:SpawnWinterbear(position, RandomVector(1))
					    		elseif unitName == "winterblight_azalea_archer" then
					    			unit = Winterblight:SpawnAzaleaArcher(position, RandomVector(1))
					    		elseif unitName == "winterblight_azure_sorceress" then
					    			unit = Winterblight:SpawnAzaleaSorceress(position, RandomVector(1))
					    		elseif unitName == "frost_whelpling" then
					    			unit = Winterblight:SpawnFrostWhelpling(position, RandomVector(1))
					    		elseif unitName == "winterblight_frost_avatar" then
					    			unit = Winterblight:SpawnFrostAvatar(position, RandomVector(1))
					    		elseif unitName == "winterblight_frost_elemental" then
					    			unit = Winterblight:SpawnFrostElemental(position, RandomVector(1))
					    		elseif unitName == "winterblight_rider_of_azalea" then
					    			unit = Winterblight:SpawnRiderOfAzalea(position, RandomVector(1))
					    		elseif unitName == "winterblight_azalean_priest" then
					    			unit = Winterblight:SpawnPriestOfAzalea(position, RandomVector(1))
					    		elseif unitName == "winterblight_mistral_assassin" then
					    			unit = Winterblight:SpawnWinterAssasin(position, RandomVector(1))
					    		elseif unitName == "winterblight_frost_frigid_hulk" then
					    			unit = Winterblight:SpawnFrostHulk(position, RandomVector(1))
					    		elseif unitName == "winterblight_ice_summoner" then
					    			unit = Winterblight:SpawnIceSummoner(position, RandomVector(1))
					    		elseif unitName == "winterblight_maiden_of_azalea" then
					    			unit = Winterblight:SpawnAzaleaMaiden(position, RandomVector(1))
					    		end	   
					    		unit.minDungeonDrops = 0
					    		unit.maxDungeonDrops = 0
					    		unit:SetDeathXP(0)
					    		unit:SetMaximumGoldBounty(0)
					    		unit:SetMinimumGoldBounty(0)
					    		unit:SetAbsOrigin(unit:GetAbsOrigin()+Vector(0,0,1000))
					    		unit.cantAggro = true
					    		WallPhysics:Jump(unit, Vector(1,0), 0, 0, 0, 1)
					    		unit.jumpEnd = "basic_dust"
					    		unit.deathCode = 2
					    		Timers:CreateTimer(0.7, function()
					    			unit.cantAggro = false
					    		end)
					    		Winterblight.AzaleaMathCounter = Winterblight.AzaleaMathCounter + 1
					    	end) 			
				    	end
				    	Timers:CreateTimer(spawnCount*0.35, function()
				    		Winterblight:ActivateSwitchGeneric(Vector(15733, -11788, 78+Winterblight.ZFLOAT), "AzaleaSwitchProp1", false, 0.352)
				    		Timers:CreateTimer(2, function()
				    			Winterblight.AzaleaSwitch1Pressed = false
				    		end)
				    	end)		
				    end		
				end
			end)
		end
	end
end

function Winterblight:AzaleaMathUnitDie(unit)
	Winterblight.AzaleaMathCounter = Winterblight.AzaleaMathCounter - 1
end

function Winterblight:ShrineSpawn3()
	if not Winterblight.Shrine3Spawned then
		Winterblight.Shrine3Spawned = true
		-- local positionTable = {Vector(14236, -14016), Vector(14400, -14142), Vector(14528, -14258), Vector(15552, -14208), Vector(15283, -14208), Vector(15296, -14016), Vector(15552, -14016)}
		-- for i = 1, #positionTable, 1 do
		-- 	Winterblight:SpawnSyphist(positionTable[i], Vector(0,1))
		-- end
		-- Timers:CreateTimer(1, function()
		-- 	for i = 0, 4, 1 do
		-- 		Winterblight:SpawnSourceRevenant(Vector(14622+i*160, -14749), Vector(0,1))
		-- 	end
		-- 	Winterblight:SpawnAzaleaMaiden(Vector(14628, -15173), Vector(0,-1))
		-- end)
		-- Timers:CreateTimer(1.5, function()
		-- 	Winterblight:SpawnMonolith(Vector(14646, -14912), Vector(0,1))
		-- 	Winterblight:SpawnMonolith(Vector(14912, -14912), Vector(0,1))
		-- 	Winterblight:SpawnMonolith(Vector(15168, -14912), Vector(0,1))
		-- end)
		Timers:CreateTimer(2.0, function()
			for i = 0, 4+GameState:GetDifficultyFactor(), 1 do
				local unit = Winterblight:SpawnSkaterFiend(Vector(14336+RandomInt(0,600), -16000+RandomInt(0,520)), RandomVector(1))
				unit.minVector = Vector(14336, -16000)
				unit.maxXroam = 600
				unit.maxYroam = 520
			end
		end)
	end
end

function Winterblight:SpawnSyphist(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_syphist", position, 1, 1, "Winterblight.Syphist.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 42
	stone.dominion = true
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:SpawnSourceRevenant(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_source_revenant", position, 1, 1, "Winterblight.SourceRevenant.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	local baseDMG = 1
	if GameState:GetDifficultyFactor() == 2 then
		baseDMG = 100
	elseif GameState:GetDifficultyFactor() == 3 then
		baseDMG = 1000
	end
	stone:SetBaseDamageMax(baseDMG)
	stone:SetBaseDamageMin(baseDMG)
	stone.itemLevel = 42
	stone.dominion = true
	stone:SetMana(0)
	return stone
end

function Winterblight:SpawnSkaterFiend(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_skater_fiend", position, 0, 1, "Winterblight.SkaterFiend.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 42
	stone.dominion = true
	stone:SetRenderColor(42, 251, 255)
	return stone
end
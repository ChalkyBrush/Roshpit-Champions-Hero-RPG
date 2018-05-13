function Winterblight:SpawnAzaleaCups()
	Winterblight:SpawnCup1()
end

function Winterblight:SpawnCup1()
	if Winterblight.MathPuzzleComplete then
		Winterblight:SpawnAzaleaCup(Vector(15910, -15831), Vector(-1,0), 1)
	end
end

function Winterblight:SpawnAzaleaCup(position, fv, index)
	if not Winterblight.AzaleacupTable then
		Winterblight.AzaleacupTable = {}
	end
    local cup = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    cup:SetForwardVector(fv)
    cup:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    cup:SetOriginalModel("models/winterblight/azalea_cup.vmdl")
    cup:SetModel("models/winterblight/azalea_cup.vmdl")
    cup:AddAbility("winterblight_attackable_unit"):SetLevel(1)
    cup:RemoveAbility("dummy_unit")
    cup:RemoveModifierByName("dummy_unit")

    cup:SetHullRadius(100)
    cup.pushLock = true
    cup.dummy = true
    cup.jumpLock = true
    local angle = WallPhysics:vectorToAngle(fv)
    -- cup:SetAngles(0, angle, 0)
    cup.prop_id = 2
    cup:SetRenderColor(100, 100, 100)
    cup:SetModelScale(1.0)
    cup.index = index
    EmitSoundOn("Winterblight.AzaleaCrystal.FinishPuzzle", cup)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", cup, 3)
    table.insert(Winterblight.AzaleacupTable, cup)
end

function Winterblight:AzaleaCupAttacked(cup, attacker)
	if not cup.active then
		print("HIT INACTIVE CUP")
		cup.active = true
		local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		local radius = 350
		local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( particle2, 0, GetGroundPosition(cup:GetAbsOrigin(), caster) )
		ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
		ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
		ParticleManager:SetParticleControl( particle2, 4, Vector(100, 200, 255) )
		Timers:CreateTimer(1.5, 
		function()
			ParticleManager:DestroyParticle( particle2, false )
		end)
		EmitSoundOnLocationWithCaster(cup:GetAbsOrigin(), "Winterblight.AzaleaCup.Explosion", Winterblight.Master)
		local enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, cup:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then	
			for i = 1, #enemies, 1 do
				enemies[i]:AddNewModifier(victim, Events:GetGameMasterAbility(), "modifier_stunned", {duration = 1})
				Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, enemies[i], "modifier_redfall_pushback", {duration = 0.8})
				enemies[i].pushVector = Vector(-1,0)
			end
		end		
		AddFOWViewer(DOTA_TEAM_GOODGUYS, cup:GetAbsOrigin(), 200, 999999, true)
		Timers:CreateTimer(1.0, function()
			Winterblight:smoothColorTransition(cup, Vector(100, 100, 100), Vector(150, 200, 255), 17)
			Timers:CreateTimer(0.5, function()
				local pfx = ParticleManager:CreateParticle("particles/winterblight/azalea_cup_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx, 0, cup:GetAbsOrigin()+Vector(0,0,160))
				EmitSoundOn("Winterblight.AzaleaCup.Ignite", cup)
			end)
			if not Winterblight.AzaleaPortalTable then
				Winterblight.AzaleaPortalTable = {0, 0, 0, 0, 0, 0}
			end
			if cup.index == 1 then
				Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(1255, -15219, 490+Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
				AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(1255, -15219, 250+Winterblight.ZFLOAT), 300, 99999, false)
				Winterblight.AzaleaPortalTable[1] = 1 
				if Winterblight.AzaleaPortalTable[2] == 0 then
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(1255, -14425, 490+Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
					AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(1255, -14425, 250+Winterblight.ZFLOAT), 300, 99999, false)
					Winterblight.AzaleaPortalTable[2] = 1
				end
			end
		end)
		Winterblight:ShrineSpawn5()
	else
		attacker.cupSequence = false
		print("ATTACK ACTIVE CUP")
		attacker:AddNewModifier( attacker, nil, "modifier_black_portal_shrink", {} )
		Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, attacker, "modifier_azalea_cup_use", {duration = 20})
		local delay = 0
		if WallPhysics:GetDistance2d(cup:GetAbsOrigin(), attacker:GetAbsOrigin()) < 240 then
			Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, attacker, "modifier_redfall_pushback", {duration = 0.3})
			attacker.pushVector = cup:GetForwardVector()*-1
			delay = 0.3
		end
		Timers:CreateTimer(delay, function()
			EmitSoundOn("Winterblight.AzaleaCup.Start", attacker)
			attacker.cupSequenceData = {}
			attacker.cupSequenceData.targetPoint = cup:GetAbsOrigin()
			attacker.cupSequence = 0
		end)
	end
end

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
					Winterblight.MathPuzzleComplete = true
					Winterblight:SpawnCup1()
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
		local luck = RandomInt(1, 3)
		if luck == 1 then
			local positionTable = {Vector(14236, -14016), Vector(14400, -14142), Vector(14528, -14258), Vector(15552, -14208), Vector(15283, -14208), Vector(15296, -14016), Vector(15552, -14016)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnSyphist(positionTable[i], Vector(0,1))
			end
			Timers:CreateTimer(1, function()
				for i = 0, 4, 1 do
					Winterblight:SpawnSourceRevenant(Vector(14622+i*160, -14749), Vector(0,1))
				end
				Winterblight:SpawnAzaleaMaiden(Vector(14628, -15173), Vector(0,-1))
			end)
			Timers:CreateTimer(1.5, function()
				Winterblight:SpawnMonolith(Vector(14646, -14912), Vector(0,1))
				Winterblight:SpawnMonolith(Vector(14912, -14912), Vector(0,1))
				Winterblight:SpawnMonolith(Vector(15168, -14912), Vector(0,1))
			end)
			Timers:CreateTimer(2.0, function()
				for i = 0, 4+GameState:GetDifficultyFactor(), 1 do
					local unit = Winterblight:SpawnSkaterFiend(Vector(14336+RandomInt(0,600), -16000+RandomInt(0,520)), RandomVector(1))
					unit.minVector = Vector(14336, -16000)
					unit.maxXroam = 600
					unit.maxYroam = 520
				end
			end)
		elseif luck == 2 then
			for i = 0, 2, 1 do
				local unit = Winterblight:SpawnSkaterFiend(Vector(15232+RandomInt(0,390), -14208+RandomInt(0,200)), RandomVector(1))
				unit.minVector = Vector(15252, -14188)
				unit.maxXroam = 390
				unit.maxYroam = 200
			end
			for i = 0, 3, 1 do
				local unit = Winterblight:SpawnSkaterFiend(Vector(14137+RandomInt(0,420), -14177+RandomInt(0,290)), RandomVector(1))
				unit.minVector = Vector(14157, -14157)
				unit.maxXroam = 420
				unit.maxYroam = 290
			end
			Timers:CreateTimer(1.0, function()
				for i = 0, 4, 1 do
					Winterblight:SpawnSyphist(Vector(14551+i*170, -14678), Vector(0,1))
				end
				for i = 0, 4, 1 do
					Winterblight:SpawnAzaleaMaiden(Vector(14551+i*170, -14912), Vector(0,1))
				end
			end)
			Timers:CreateTimer(2.0, function()
				local positionTable = {Vector(14336, -15488), Vector(14489, -15616), Vector(14784, -15628), Vector(14948, -15480), Vector(14469, -15872), Vector(14350, -16064), Vector(14784, -15880), Vector(14949, -16022)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnSourceRevenant(positionTable[i], Vector(0,1))
				end
				Winterblight:SpawnSourceAssembly(Vector(14628, -15744), Vector(0,1))
			end)
		elseif luck == 3 then
			local positionTable = {Vector(14703, -13525), Vector(15304, -13566), Vector(14528, -14464), Vector(15296, -14464), Vector(14649, -15191)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnSourceRevenant(positionTable[i], Vector(0,1))
			end
			Timers:CreateTimer(0.6, function()
				local positionTable = {Vector(14272, -14208), Vector(14528, -14208), Vector(14272, -14016), Vector(14528, -14016), Vector(15232, -14208), Vector(15424, -14137), Vector(15616, -14025)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAzaleaMaiden(positionTable[i], Vector(0,1))
				end
			end)
			Timers:CreateTimer(1.2, function()
				for i = 0, 1+GameState:GetDifficultyFactor(), 1 do
					local unit = Winterblight:SpawnSkaterFiend(Vector(14611+RandomInt(0,500), -14895+RandomInt(0,110)), RandomVector(1))
					unit.minVector = Vector(14611, -14895)
					unit.maxXroam = 500
					unit.maxYroam = 110
				end
			end)
			Timers:CreateTimer(2.2, function()
				for i = 0, 3, 1 do
					for j = 0, 3, 1 do
						Winterblight:SpawnSyphist(Vector(14336+i*190, -16000+j*192), Vector(0,1))
					end
				end
			end)
		end
		local luck2 = RandomInt(0, 3)

		if luck2 > 0 then
			Timers:CreateTimer(0.5, function()
				local positionTable = {Vector(15488, -15396), Vector(15897, -13522), Vector(14080, -14979)}
			    for i = 1, luck2, 1 do
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
			          Timers:CreateTimer(j*0.8, function()
			            local elemental = Winterblight:SpawnAzaleaSorceress(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 35, 5, 220, patrolPositionTable)
			          end)
			        end
			      end)
			    end
			end)
		end
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

function Winterblight:SpawnSourceAssembly(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_source_assembly", position, 4, 5, "Winterblight.SkaterFiend.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 55
	stone.dominion = true
	stone:SetMana(0)
	return stone
end

function Winterblight:ShrineSpawn4()
	local luck = RandomInt(1, 3)
	if luck == 1 then
		for i = 0, 2, 1 do
			Winterblight:SpawnSyphist(Vector(11190+i*270, -15994), Vector(1,0))
		end
		for i = 0, 2, 1 do
			Winterblight:SpawnSyphist(Vector(11190+i*270, -15488), Vector(1,0))
		end
		for i = 0, 2, 1 do
			Winterblight:SpawnSyphist(Vector(11190+i*270, -14976), Vector(1,0))
		end
		Timers:CreateTimer(0.2, function()
			local positionTable = {Vector(10880, -16000), Vector(10824, -15744), Vector(10824, -15232), Vector(10880, -15010)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(1,0))
			end	
		end)
	elseif luck == 2 then
		for i = 0, 4, 1 do
			Winterblight:SpawnGhostStriker(Vector(11008+i*256, -16000), Vector(0,1))
		end		
		for i = 0, 4, 1 do
			Winterblight:SpawnGhostStriker(Vector(11008+i*256, -14930), Vector(0,-1))
		end	
		Timers:CreateTimer(0.1, function()
			for i = 0, 2, 1 do
				Winterblight:SpawnPriestOfAzalea(Vector(11199+i*230, -15447), Vector(1,0))
			end		
		end)
		Timers:CreateTimer(0.2, function()
			local positionTable = {Vector(10937, -15744), Vector(10937, -15232)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(1,0))
			end	
		end)
	elseif luck == 3 then
		Timers:CreateTimer(0.2, function()
			local positionTable = {Vector(11153, -16000), Vector(11717, -16000), Vector(11453, -15456), Vector(11153, -14957), Vector(11717, -14957)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(1,0))
			end	
		end)
		for i = 0, 2, 1 do
			Winterblight:SpawnSourceRevenant(Vector(10880, -16000+i*115), Vector(1,0))
		end	
		for i = 0, 2, 1 do
			Winterblight:SpawnSourceRevenant(Vector(10880, -15305+i*115), Vector(1,0))
		end	
		for i = 0, 1, 1 do
			Winterblight:SpawnSecretKeeper(Vector(11922+i*180, -16103), Vector(0,-1))
		end	
		for i = 0, 1, 1 do
			Winterblight:SpawnSecretKeeper(Vector(11922+i*180, -14819), Vector(0,1))
		end	
	end
end

function Winterblight:ShrineSpawn5()
	if not Winterblight.AzaleaTeleportRoomSpawned then
		Winterblight.AzaleaTeleportRoomSpawned = true
		local luck = RandomInt(1, 3)
		if luck == 1 then
			local positionTable = {Vector(-1024, -14336), Vector(-841, -14080), Vector(-512, -13871), Vector(-161, -13871), Vector(185, -13871), Vector(462, -14080), Vector(640, -14336)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(0,-1))
			end	
			Timers:CreateTimer(0.8, function()
				local positionTable = {Vector(-1364, -13915), Vector(-1580, -13915), Vector(-1580, -13639), Vector(-1364, -13639), Vector(936, -13915), Vector(1152, -13915), Vector(936, -13639), Vector(1152, -13639)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAzaleaMindbreaker(positionTable[i], Vector(0,-1))
				end	
			end)	
			Timers:CreateTimer(0.1, function()
				for i = 0, 9, 1 do
					Timers:CreateTimer(i*0.3, function()
						Winterblight:SpawnGhostStriker(Vector(-1536+i*300, -15734), Vector(0,1))
					end)
				end	
			end)	
			Timers:CreateTimer(0.5, function()
				local positionTable = {Vector(-1536, -15482), Vector(1536, -15616)}
			    for i = 1, 1, 1 do
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
			            local elemental = Winterblight:SpawnColdSeer(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 35, 5, 220, patrolPositionTable)
			          end)
			        end
			      end)
			    end
			end)
		elseif luck == 2 then
			for i = 0, 5, 1 do
				Timers:CreateTimer(i*0.1, function()
					Winterblight:SpawnSecretKeeper(Vector(-1536+i*540, -15610), Vector(0,1))
				end)
			end	
			for i = 0, 4, 1 do
				Timers:CreateTimer(i*0.1 + 0.05, function()
					Winterblight:SpawnSecretKeeper(Vector(-1273+i*540, -15880), Vector(0,1))
				end)
			end	
			local positionTable = {{Vector(-1089, -15259), Vector(1,0)}, {Vector(-1089, -15074), Vector(1,0)}, {Vector(-1089, -15259), Vector(1,0)}, {Vector(-1089, -14500), Vector(1,0)}, {Vector(-1089, -14316), Vector(1,0)}, {Vector(-862, -13873), Vector(0,-1)}, {Vector(-677, -13863), Vector(0,-1)}, {Vector(340, -13873), Vector(0,-1)}, {Vector(524, -13873), Vector(0,-1)}, {Vector(771, -14353), Vector(-1,0)}, {Vector(771, -14536), Vector(-1,0)}, {Vector(771, -15082), Vector(-1,0)}, {Vector(771, -15266), Vector(-1,0)}}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaHighguard(positionTable[i][1], positionTable[i][2])
			end	
			Timers:CreateTimer(1, function()
			    local positionTable = {Vector(-1664, -13952), Vector(-1490, -13696), Vector(1223, -13568), Vector(896, -13568), Vector(1109, -13824), Vector(1273, -14033)}
			    for i = 1, #positionTable, 1 do
			      local lookToPoint = (Vector(-256, -14720) - positionTable[i]):Normalized()
			      Winterblight:SpawnAzaleaMindbreaker(positionTable[i], lookToPoint)
			    end
			end)
			Timers:CreateTimer(0.5, function()
				local positionTable = {Vector(-1152, -14080), Vector(768, -14080)}
			    for i = 1, 1, 1 do
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
			            local elemental = Winterblight:SpawnSoftwalker(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 35, 5, 220, patrolPositionTable)
			          end)
			        end
			      end)
			    end
			end)
		elseif luck == 3 then
			Timers:CreateTimer(0.1, function()
				for i = 0, 9, 1 do
					Timers:CreateTimer(i*0.3, function()
						Winterblight:SpawnAzaleaMindbreaker(Vector(-1536+i*300, -15734+math.sin(2*math.pi*i/5)*160), Vector(0,1))
					end)
				end	
			end)	
			Timers:CreateTimer(0.3, function()
			    for i = 0, 4, 1 do
			      Winterblight:SpawnAzaleaHighguard(Vector(-1024, -15232+i*256), Vector(1,0))
			    end
			    for i = 0, 4, 1 do
			      Winterblight:SpawnAzaleaHighguard(Vector(628, -15232+i*256), Vector(-1,0))
			    end
			end)
			Timers:CreateTimer(1, function()
			    local positionTable = {Vector(-1280, -13952), Vector(-1536, -13952), Vector(-1536, -13604), Vector(-1159, -13677), Vector(-1159, -13352), Vector(824, -14144), Vector(824, -13819), Vector(944, -13545), Vector(1200, -13545), Vector(1200, -13892)}
			    for i = 1, #positionTable, 1 do
			      local lookToPoint = (Vector(-256, -14720) - positionTable[i]):Normalized()
			      Winterblight:SpawnSecretKeeper(positionTable[i], lookToPoint)
			    end
			end)
			Timers:CreateTimer(1.5, function()
			    for i = 0, 5, 1 do
			      Winterblight:SpawnGhostStriker(Vector(-712+200*i, -13952), Vector(0,-1))
			    end
			end)
		end
		Timers:CreateTimer(2.5, function()
		    local positionTable = {Vector(-1974, -15616), Vector(-1974, -14976), Vector(-1920, -14366), Vector(-1920, -13696), Vector(-1391, -13096), Vector(-725, -13096), Vector(-93, -13096), Vector(571, -13096), Vector(1152, -13276), Vector(1620, -13755), Vector(1644, -14336), Vector(1664, -15032), Vector(1737, -15744)}
		    for i = 1, #positionTable, 1 do
		      Timers:CreateTimer(i*0.25, function()
			      local ogreSpawn = RandomInt(1, 2)
			      if ogreSpawn == 1 then
			     	 Winterblight:SpawnMountainOgre(positionTable[i]+RandomVector(RandomInt(0, 90)), RandomVector(1))
			      end
			  end)
		    end
		end)
		Timers:CreateTimer(0.25, function()
			Winterblight:SpawnThorcrux(Vector(-180, -13406), Vector(0,-1))
		end)
	end
end

function Winterblight:SpawnAzaleaHighguard(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_highguard", position, 1, 1, "Winterblight.AzaleaHighguard.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 42
	stone.dominion = true
	Events:ColorWearables(stone, Vector(142, 241, 255))
	if Winterblight.Stones >= 2 then
		stone:AddAbility("seafortress_golden_shell"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:SpawnAzaleaMindbreaker(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_mindbreaker", position, 0, 1, "Winterblight.MindBreaker.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 42
	stone.dominion = true
	Events:ColorWearables(stone, Vector(82, 151, 255))
	return stone
end

function Winterblight:SpawnGhostStriker(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_ghost_striker", position, 0, 1, "Winterblight.GhostStriker.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 42
	stone.dominion = true
	Events:ColorWearables(stone, Vector(82, 151, 255))
	return stone
end

function Winterblight:SpawnSecretKeeper(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_secret_keeper", position, 0, 1, "Winterblight.SecretKeeper.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 42
	stone.dominion = true

	return stone
end

function Winterblight:SpawnThorcrux(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_thorcrux", position, 2, 5, "Winterblight.Thorcrux.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 50
	Timers:CreateTimer(0.03, function()
		if GameState:GetDifficultyFactor() == 3 then
			stone:AddAbility("creature_pure_strike"):SetLevel(3)
		end
	end)
	return stone
end

function Winterblight:AzaleaSwitch2()
	Winterblight:ActivateSwitchGeneric(Vector(10819, -15459, 78+Winterblight.ZFLOAT), "AzaleaSwitchProp2", true, 0.368)
	local spawnPoints = {{Vector(10176, -16000), Vector(1,0)}, {Vector(10176, -14974), Vector(1,0)}, {Vector(12672, -14974), Vector(-1,0)}, {Vector(12672, -16000), Vector(-1,0)}}
	local zAdd = 660 + Winterblight.ZFLOAT
	Winterblight.AzaleaSpawnParticleTable = {}
	Timers:CreateTimer(1.5, function()
		for i = 1, #spawnPoints, 1 do
			AddFOWViewer(DOTA_TEAM_GOODGUYS, spawnPoints[i][1], 300, 1500, false)
	    	local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/town_portal_start_lvl2_black_ti5.vpcf", PATTACH_CUSTOMORIGIN, nil)
	    	local particlePos = spawnPoints[i][1]+Vector(0,0,zAdd)
	    	ParticleManager:SetParticleControl(pfx, 0, particlePos)
	    	table.insert(Winterblight.AzaleaSpawnParticleTable, pfx)
	    	EmitSoundOnLocationWithCaster(spawnPoints[i][1]+Vector(0,0,zAdd), "Winterblight.SpawnPortals.Start", Winterblight.Master)
	    	Timers:CreateTimer(4.2, function()
	    		Winterblight:SpawnAzaleaWaveUnit1("azalea_spineback", spawnPoints[i][1], 8, 1.5, true, spawnPoints[i][2])
	    	end)
		end
	end)
end

function Winterblight:SpawnAzaleaWaveUnit1(unitName, spawnPoint, quantity, delay, bSound, jumpFV)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.WaveSpawn", Winterblight.Master)
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
        unit.deathCode = 3
        Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_winterblight_wave_unit", {})
        unit:SetAcquisitionRange(3000)
        CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit, 2)
        unit.aggro = true
        Winterblight:AdjustWaveUnit(unit)
        Winterblight:AzaleaWaveUnitSpawn(unit, jumpFV)
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].dominion = true
          unit[i]:SetAcquisitionRange(3000)
          unit[i].deathCode = 3
          Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit[i], "modifier_winterblight_wave_unit", {})
          CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit[i], 2)
          Winterblight:AdjustWaveUnit(unit[i])
          Winterblight:AzaleaWaveUnitSpawn(unit[i], jumpFV)
        end
      end
    end)
  end
end

function Winterblight:AzaleaWaveUnitSpawn(unit, jumpFV)
	local animation_name = ACT_DOTA_SPAWN
	unit:SetForwardVector(jumpFV)
	if unit:GetUnitName() == "azalea_spineback" or unit:GetUnitName() == "winterblight_icetaur" or unit:GetUnitName() == "winterblight_source_revenant" then
		animation_name = ACT_DOTA_TELEPORT_END
	elseif unit:GetUnitName() == "winterblight_syphist" then
		animation_name = ACT_DOTA_CAST_ABILITY_1
	elseif unit:GetUnitName() == "winterblight_crippling_wraith" then
		animation_name = ACT_DOTA_CAST_ABILITY_3
	end
	unit.jumpEnd = "basic_dust"
	Timers:CreateTimer(0.45, function()
		StartAnimation(unit, {duration=1.4, activity=animation_name, rate=0.9})
		WallPhysics:Jump(unit, jumpFV, RandomInt(16, 18), RandomInt(12, 16), RandomInt(16, 20), 1)
		if unit:GetUnitName() == "winterblight_icewrack_marauder" then
			unit:AddNewModifier(unit, nil, "modifier_animation", {translate="melee"})
			unit:AddNewModifier(unit, nil, "modifier_animation_translate", {translate="run"})
		end
	end)
end

function Winterblight:AzaleaWaveUnitDie(unit)
	if not Winterblight.AzaleaWave1Counter then
		Winterblight.AzaleaWave1Counter = 0
	end
	Winterblight.AzaleaWave1Counter = Winterblight.AzaleaWave1Counter + 1
	if Winterblight.AzaleaWave1Counter == 28 then
		local unitName = "winterblight_frostbite_spiderling"
		local luck = RandomInt(1, 2)
		if luck == 1 then
			unitName = "winterblight_icetaur"
		end
		local spawnPoints = {{Vector(10176, -16000), Vector(1,0)}, {Vector(10176, -14974), Vector(1,0)}, {Vector(12672, -14974), Vector(-1,0)}, {Vector(12672, -16000), Vector(-1,0)}}
    	Timers:CreateTimer(0.5, function()
    		for i = 1, #spawnPoints, 1 do
    			Winterblight:SpawnAzaleaWaveUnit1(unitName, spawnPoints[i][1], 10, 0.9, true, spawnPoints[i][2])
    		end
    	end)
	elseif Winterblight.AzaleaWave1Counter == 66 then
		local unitName = "winterblight_source_revenant"
		local luck = RandomInt(1, 2)
		if luck == 1 then
			unitName = "winterblight_syphist"
		end
		local spawnPoints = {{Vector(10176, -16000), Vector(1,0)}, {Vector(10176, -14974), Vector(1,0)}, {Vector(12672, -14974), Vector(-1,0)}, {Vector(12672, -16000), Vector(-1,0)}}
    	Timers:CreateTimer(0.5, function()
    		for i = 1, #spawnPoints, 1 do
    			Winterblight:SpawnAzaleaWaveUnit1(unitName, spawnPoints[i][1], 4, 1, true, spawnPoints[i][2])
    		end
    	end)
	elseif Winterblight.AzaleaWave1Counter == 80 then
		local unitName = "winterblight_crippling_wraith"
		local spawnPoints = {{Vector(10176, -16000), Vector(1,0)}, {Vector(10176, -14974), Vector(1,0)}, {Vector(12672, -14974), Vector(-1,0)}, {Vector(12672, -16000), Vector(-1,0)}}
    	Timers:CreateTimer(0.5, function()
    		for i = 1, #spawnPoints, 1 do
    			Winterblight:SpawnAzaleaWaveUnit1(unitName, spawnPoints[i][1], 7, 1, true, spawnPoints[i][2])
    		end
    	end)
    elseif Winterblight.AzaleaWave1Counter == 108 then
		local spawnPoints = {{Vector(10176, -16000), Vector(1,0)}, {Vector(10176, -14974), Vector(1,0)}, {Vector(12672, -14974), Vector(-1,0)}, {Vector(12672, -16000), Vector(-1,0)}}
    	for i = 1, #spawnPoints, 1 do
			local luck = RandomInt(1, 6)
			local unitName = ""
			if luck == 1 then
				unitName = "winterblight_frigid_growth"
			elseif luck == 2 then
				unitName = "winterblight_icewrack_marauder"
			elseif luck == 3 then
				unitName =  "winterblight_ice_satyr"
			elseif luck == 4 then
				unitName = "winterblight_dashing_swordsman"
			elseif luck == 5 then
				unitName = "winterblight_winterbear"
			elseif luck == 6 then
				unitName = "frostiok"
			end
    		Winterblight:SpawnAzaleaWaveUnit1(unitName, spawnPoints[i][1], 7, 1, true, spawnPoints[i][2])
    	end
    elseif Winterblight.AzaleaWave1Counter == 136 then
		local nameTable = {"winterblight_azalean_priest", "winterblight_frost_elemental", "winterblight_frost_avatar", "winterblight_azure_sorceress", "winterblight_rider_of_azalea", "winterblight_winterbear", "winterblight_mistral_assassin", "winterblight_frost_frigid_hulk", "winterblight_azalea_archer"}
		local unitName = nameTable[RandomInt(1, #nameTable)]
		local spawnPoints = {{Vector(10176, -16000), Vector(1,0)}, {Vector(10176, -14974), Vector(1,0)}, {Vector(12672, -14974), Vector(-1,0)}, {Vector(12672, -16000), Vector(-1,0)}}
    	Timers:CreateTimer(0.5, function()
    		for i = 1, #spawnPoints, 1 do
    			Winterblight:SpawnAzaleaWaveUnit1(unitName, spawnPoints[i][1], 7, 1, true, spawnPoints[i][2])
    		end
    	end)
    elseif Winterblight.AzaleaWave1Counter == 164 then
     	Timers:CreateTimer(0.5, function()
     		local spawnPoints = {{Vector(10176, -16000), Vector(1,0)}, {Vector(10176, -14974), Vector(1,0)}, {Vector(12672, -14974), Vector(-1,0)}, {Vector(12672, -16000), Vector(-1,0)}}
    		for i = 1, #spawnPoints, 1 do
    			local nameTable = {"winterblight_crippling_wraith", "winterblight_syphist", "winterblight_source_revenant", "winterblight_icetaur", "winterblight_frostbite_spiderling", "azalea_spineback"}
    			local unitName = nameTable[RandomInt(1, #nameTable)]
    			Winterblight:SpawnAzaleaWaveUnit1(unitName, spawnPoints[i][1], 7, 1, true, spawnPoints[i][2])
    		end
    	end)  
    elseif Winterblight.AzaleaWave1Counter == 190 then
		EmitSoundOnLocationWithCaster(Vector(10805, -15468, 259+Winterblight.ZFLOAT), "Winterblight.AzaleaCrystal.FinishPuzzle", Winterblight.Master)
		Winterblight:RemoveBlockers(8.5, "AzaleaBridgeBlocker3", Vector(9728, -15680, 212+Winterblight.ZFLOAT), 5400)
		for i = 1, 300, 1 do
			Timers:CreateTimer(0.03*i, function()
				if i %40 == 0 then
					EmitSoundOnLocationWithCaster(Vector(9572, -15651, 78+Winterblight.ZFLOAT), "Winterblight.AzaleaBridge.Raise", Events.GameMaster)
				end
				Winterblight.AzaleaBridge3:SetAbsOrigin(Winterblight.AzaleaBridge3:GetAbsOrigin()+Vector(0,0,1500/300))
			end)
		end
		Timers:CreateTimer(3, function()
			local walls = Entities:FindAllByNameWithin("AzaleaWall3", Vector(9274, -15669, -4094+Winterblight.ZFLOAT), 2400)
		    EmitSoundOnLocationWithCaster(Vector(9274, -15669), "Winterblight.WallOpen", Events.GameMaster)
		    Winterblight:WallsTicks(false, walls, true, 5, 360, 0.1)
		    Winterblight:RemoveBlockers(4, "AzaleaBlocker3", Vector(9226, -15808, 300+Winterblight.ZFLOAT), 3800)
		    Winterblight:ShrineSpawn6()
		    Winterblight:SpawnChrolonus(Vector(7424, -15488), Vector(1,0))
		end)
		Timers:CreateTimer(9, function()
			EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge3:GetAbsOrigin(), "Winterblight.AzaleaBridge.Finish", Winterblight.Master)
			Timers:CreateTimer(0.1, function()
				EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge3:GetAbsOrigin(), "Winterblight.Azalea.Win", Winterblight.Master)
			end)
			local positionTable = {Vector(10496, -15788), Vector(10496, -15680), Vector(10496, -15570), Vector(8657, -15788), Vector(8657, -15680), Vector(8657, -15570)}
            for i = 1, #positionTable, 1 do
              local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
              ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(positionTable[i], Events.GameMaster ))
              ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
              Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(pfx, false)
              end)
            end
            for j = 1, #Winterblight.AzaleaSpawnParticleTable, 1 do
            	ParticleManager:DestroyParticle(Winterblight.AzaleaSpawnParticleTable[j], false)
            	ParticleManager:ReleaseParticleIndex(Winterblight.AzaleaSpawnParticleTable[j])
            end
		end)					
	end
end

function Winterblight:ShrineSpawn6()
	if not Winterblight.Shrine6spawned then
		Winterblight.Shrine6spawned = true
		local luck = RandomInt(1, 3)
		if luck == 1 then
			for i = 0, 2, 1 do
				Timers:CreateTimer(i*0.6, function()
					Winterblight:SpawnCrystalRunner(Vector(7424+i*256, -15744), Vector(1,0))
				end)
			end
			Timers:CreateTimer(0.9, function()
				for i = 0, 2, 1 do
					Timers:CreateTimer(i*0.6, function()
						Winterblight:SpawnCrystalRunner(Vector(7424+i*256, -15104), Vector(1,0))
					end)
				end
			end)
			Timers:CreateTimer(1, function()
				Winterblight:SpawnArmoredKnight(Vector(7106, -15810), Vector(1,0))
				Winterblight:SpawnArmoredKnight(Vector(7106, -15046), Vector(1,0))
			end)
		elseif luck == 2 then
			for i = 0, 3, 1 do
				Timers:CreateTimer(i*0.6, function()
					Winterblight:SpawnCrystalRunner(Vector(7168+i*256, -16000), Vector(0,1))
				end)
			end
			Timers:CreateTimer(0.9, function()
				for i = 0, 3, 1 do
					Timers:CreateTimer(i*0.6, function()
						Winterblight:SpawnCrystalRunner(Vector(7168+i*256, -14848), Vector(0,-1))
					end)
				end
			end)
			Timers:CreateTimer(1, function()
				Winterblight:SpawnArmoredKnight(Vector(7841, -15658), Vector(1,0))
				Winterblight:SpawnArmoredKnight(Vector(7841, -15488), Vector(1,0))
				Winterblight:SpawnArmoredKnight(Vector(7841, -15283), Vector(1,0))
			end)
		elseif luck == 3 then
			for i = 0, 4, 1 do
				Timers:CreateTimer(i*0.6, function()
					Winterblight:SpawnArmoredKnight(Vector(7680, -15908+i*256), Vector(1,0))
				end)
			end
			Timers:CreateTimer(1, function()
				Winterblight:SpawnCrystalRunner(Vector(7841, -15658), Vector(1,0))
				Winterblight:SpawnCrystalRunner(Vector(7841, -15488), Vector(1,0))
				Winterblight:SpawnCrystalRunner(Vector(7841, -15283), Vector(1,0))
			end)
			Timers:CreateTimer(1.4, function()
				Winterblight:SpawnWinterAssasin(Vector(7225, -15908), Vector(1,0))
				Winterblight:SpawnWinterAssasin(Vector(7040, -15757), Vector(1,0))
			end)
		end
	end
end

function Winterblight:SpawnArmoredKnight(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_armored_knight", position, 1, 1, "Winterblight.ArmoredKnight.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 45
	stone.dominion = true

	return stone
end

function Winterblight:SpawnChrolonus(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_chrolonus", position, 1, 1, "Winterblight.Chrolonus.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 45
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(3)
		stone:RemoveAbility("fire_temple_steadfast")
		stone:RemoveModifierByName("modifier_steadfast")
		stone:AddAbility("redfall_mega_steadfast"):SetLevel(3)
		if Winterblight.Stones > 0 then
			stone:AddAbility("armor_break_ultra"):SetLevel(Winterblight.Stones)
		end
	end

	return stone
end

function Winterblight:SpawnCrystalRunner(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_crystal_malefor", position, 0, 2, "Winterblight.Malefor.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 49
	stone.targetRadius = 1600
	stone.autoAbilityCD = 1
	stone.dominion = true
	Events:ColorWearablesAndBase(stone, Vector(80, 100, 255))
	if Winterblight.Stones >= 2 then
		stone:AddAbility("fire_temple_steadfast"):SetLevel(GameState:GetDifficultyFactor())
	end
	if Winterblight.Stones == 3 then
		stone:AddAbility("creature_pure_strike"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:SpawnAzaleaColorBlade(position, index)
    local blade = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    blade:SetAbsOrigin(position+Winterblight.ZFLOAT+Vector(0,0,115))
    blade:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    blade:SetOriginalModel("models/winterblight/azalea_blade.vmdl")
    blade:SetModel("models/winterblight/azalea_blade.vmdl")
    blade:AddAbility("winterblight_attackable_unit"):SetLevel(1)
    blade:RemoveAbility("dummy_unit")
    blade:RemoveModifierByName("dummy_unit")

    local ability = blade:FindAbilityByName("winterblight_attackable_unit")
    ability:ApplyDataDrivenModifier(blade, blade, "modifier_attackable_unit_no_more_attacks", {duration = 4.8})
    blade:SetHullRadius(50)
    blade.pushLock = true
    blade.dummy = true
    blade.jumpLock = true
    -- blade:SetAngles(0, angle, 0)
    blade.prop_id = 3
    blade:SetModelScale(1.0)
    blade.index = index
    table.insert(Winterblight.AzaleaBladesTable, blade)
    local moveTicks = 160
    for i = 1, moveTicks, 1 do
    	Timers:CreateTimer(i*0.03, function()
    		blade:SetAbsOrigin(blade:GetAbsOrigin()+Vector(0,0,500/moveTicks))
    	end)
    end
    Winterblight:objectShake(blade, 160, 8, true, true, false, "Winterblight.AzaleaSwords.Rising", 30)
    Timers:CreateTimer(moveTicks*0.03, function()
    	EmitSoundOn("Winterblight.AzaleaSwords.Peak", blade)
    	for i = 1, 2, 1 do
    		CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/snow_impact.vpcf", blade:GetAbsOrigin(), 3)
    	end
    end)
end

function Winterblight:AzaleaBladeAttacked(caster, attacker)
	local colors = {Vector(223, 54, 54), Vector(231, 214, 37), Vector(37, 231, 66), Vector(57, 99, 223)}
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", caster, 3)
	EmitSoundOn("Winterblight.AzaleaSwords.Attacked", caster)
	if not caster.color then
		caster.color = "blue"
	end
	if caster.color == "red" then
		caster:SetRenderColor(colors[2].x, colors[2].y, colors[2].z)
		caster.color = "yellow"
	elseif caster.color == "yellow" then
		caster:SetRenderColor(colors[3].x, colors[3].y, colors[3].z)
		caster.color = "green"	
	elseif caster.color == "green" then
		caster:SetRenderColor(colors[4].x, colors[4].y, colors[4].z)
		caster.color = "blue"	
	elseif caster.color == "blue" then
		caster:SetRenderColor(colors[1].x, colors[1].y, colors[1].z)
		caster.color = "red"	
	end	
	local condition = true
	for i = 1, #Winterblight.AzaleaBladeColors, 1 do
		if Winterblight.AzaleaBladeColors[i] == Winterblight.AzaleaBladesTable[i].color then
		else
			condition = false
			break
		end
	end
	if condition then
		EmitSoundOnLocationWithCaster(Winterblight.AzaleaBladesTable[2]:GetAbsOrigin(), "Winterblight.AzaleaCrystal.FinishPuzzle", Winterblight.Master)
		for i = 1, #Winterblight.AzaleaBladesTable, 1 do
			local blade = Winterblight.AzaleaBladesTable[i]
		    local ability = blade:FindAbilityByName("winterblight_attackable_unit")
		    ability:ApplyDataDrivenModifier(blade, blade, "modifier_attackable_unit_no_more_attacks", {})
		    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/hermit_roar.vpcf", blade, 3)	
		end
		Timers:CreateTimer(1, function()
			local walls = Entities:FindAllByNameWithin("AzaleaWall4", Vector(7665, -14336, -4094+Winterblight.ZFLOAT), 2400)
		    EmitSoundOnLocationWithCaster(Vector(7665, -14336), "Winterblight.WallOpen", Events.GameMaster)
		    Winterblight:WallsTicks(false, walls, true, 5, 360, 0.1)
		    Winterblight:RemoveBlockers(4, "AzaleaBlocker4", Vector(7680, -14285, 300+Winterblight.ZFLOAT), 1800)
		end)
	end
end

function Winterblight:CandyCrushRoom()
	Winterblight:SpawnCandyCrushMasterCrystal()
end

function Winterblight:ResetCandyCrush()
	Winterblight.CandyCrushLocked = true
	Winterblight:ActivateBlackStatues()
	for j = 1, #MAIN_HERO_TABLE, 1 do
		local hero = MAIN_HERO_TABLE[j]
		if hero.candy_crush_link_data then
			for i = 1, #hero.candy_crush_link_data.pfxTable, 1 do
				ParticleManager:DestroyParticle(hero.candy_crush_link_data.pfxTable[i], false)
			end
		else
			hero.candy_crush_link_data = {}
		end
		hero.candy_crush_link_data.pfxTable = {}
		hero.candy_crush_link_data.links = {}
		hero:RemoveModifierByName("modifier_hero_candy_crush")
	end
	for i = 1, #Winterblight.CandyCrushLayout, 1 do
		for j = 1, 10, 1 do
			UTIL_Remove(Winterblight.CandyCrushLayout[i][j])
		end
	end
	Winterblight:InitializeCandyCrush()
end

function Winterblight:InitializeCandyCrush()
	if Winterblight.CandyCrushBlackStatueTable then
		Winterblight:ActivateBlackStatues()
	end
	Winterblight.CandyCrushLayout = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(3925, -15086), 1500, 3000, false)
	local color_possibilities = {"red", "yellow", "green", "blue"}
	local basePos = Vector(2958, -15832)
	EmitSoundOnLocationWithCaster(Vector(3925, -15086),"Winterblight.CandyCrush.Start", Winterblight.Master)
	Winterblight.CandyCrushLocked = true
	for i = 1, 10, 1 do
		for j = 1, 10, 1 do
			local randomColor = color_possibilities[RandomInt(1, #color_possibilities)]
			local delay = (i-1)*0.5 + (j-1)*0.05
			Timers:CreateTimer(delay, function()
				Winterblight:SpawnCandyCrushStatue(basePos+Vector(242*(j-1), 182*(i-1)), randomColor, i, j)
			end)
		end
	end
	Timers:CreateTimer(5.5, function()
		Winterblight.CandyCrushLocked = false
	end)
end

function Winterblight:SpawnCandyCrushMasterCrystal()
	local initial = true
	if Winterblight.CandyCrushCrystal then
		UTIL_Remove(Winterblight.CandyCrushCrystal)
		initial = false
	end
	local position = Vector(2505, -14245, 560+Winterblight.ZFLOAT)
    local crystal = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)

    local yaw = 345
    crystal:SetAngles(0, yaw, 0)

    crystal:SetModelScale(1.5)
    crystal:SetOriginalModel("models/winterblight/azalea_crystal.vmdl")
    crystal:SetModel("models/winterblight/azalea_crystal.vmdl")
    crystal:SetAbsOrigin(position)

    crystal:RemoveAbility("dummy_unit")
    crystal:RemoveModifierByName("dummy_unit")
    crystal.basePosition = position

    crystal.yaw = yaw
    crystal:AddAbility("winterblight_candy_crush_master_crystal"):SetLevel(1)
    crystal.pushLock = true
    crystal.dummy = true
    crystal.jumpLock = true
    Winterblight.CandyCrushCrystal = crystal

	crystal:SetRenderColor(40, 40, 40)
	crystal.dark = true
    if not initial then
    	crystal.locked = true
	    Timers:CreateTimer(20, function()
	    	crystal.locked = false
	    end)
	end
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", crystal, 3)
    AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 350, 6000, false)
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(5653, -14257), 350, 6000, false)
end

function Winterblight:SpawnCandyCrushStatue(position, color, index_i, index_j)
    local candy_crush = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)

    local masterAbility = Winterblight.CandyCrushCrystal:FindAbilityByName("winterblight_candy_crush_master_crystal")
    masterAbility:ApplyDataDrivenModifier(Winterblight.CandyCrushCrystal, candy_crush, "modifier_candy_crush_unit", {})
    
    
    if color == "red" then
	    candy_crush:SetOriginalModel("models/winterblight/candy_crush_red.vmdl")
	    candy_crush:SetModel("models/winterblight/candy_crush_red.vmdl")
	    candy_crush:SetRenderColor(221, 82, 82)
	    candy_crush:SetModelScale(1)
	elseif color == "yellow" then
	    candy_crush:SetOriginalModel("models/winterblight/candy_crush_yellow.vmdl")
	    candy_crush:SetModel("models/winterblight/candy_crush_yellow.vmdl")
	    candy_crush:SetRenderColor(255, 255, 0)
	    candy_crush:SetModelScale(1)
	elseif color == "green" then
	    candy_crush:SetOriginalModel("models/heroes/brewmaster/brewmaster_earthspirit_end.vmdl")
	    candy_crush:SetModel("models/heroes/brewmaster/brewmaster_earthspirit_end.vmdl")
	    candy_crush:SetRenderColor(71, 159, 56)
	    candy_crush:SetModelScale(0.85)
	elseif color == "blue" then
	    candy_crush:SetOriginalModel("models/winterblight/candy_crush_blue.vmdl")
	    candy_crush:SetModel("models/winterblight/candy_crush_blue.vmdl")
	    candy_crush:SetRenderColor(86, 123, 255)
	    candy_crush:SetModelScale(0.8)
	end
	candy_crush.color = color
	candy_crush.index_i = index_i
	candy_crush.index_j = index_j
    candy_crush:RemoveAbility("dummy_unit")
    candy_crush:RemoveModifierByName("dummy_unit")
    candy_crush.basePosition = position
    if index_i == -1 or index_j == -1 then
    	table.insert(Winterblight.CandyCrushBlackStatueTable, candy_crush)
    	candy_crush:SetRenderColor(30, 30, 30)
    	candy_crush.black = true
    else
    	Winterblight.CandyCrushLayout[index_i][index_j] = candy_crush
    end
    candy_crush.pushLock = true
    candy_crush.dummy = true
    candy_crush.jumpLock = true
    EmitSoundOn("Winterblight.CandyCrush.SpawnStatue", candy_crush)
    candy_crush.locked = false
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", candy_crush, 3)
end

function Winterblight:ActivateBlackStatues()
	if Winterblight.CandyCrushBlackStatueTable then
		for i = 1, #Winterblight.CandyCrushBlackStatueTable, 1 do
			local statue = Winterblight.CandyCrushBlackStatueTable[i]
			if statue.color == "red" then
				Winterblight:SpawnCandyCrushRedUnit(statue:GetAbsOrigin(), Vector(1,0), true, Winterblight.CandyCrushBlackStatueTable[i+1])
			elseif statue.color == "blue" then
				Winterblight:SpawnCandyCrushBlueUnit(statue:GetAbsOrigin(), Vector(1,0), true, Winterblight.CandyCrushBlackStatueTable[i+1])
			elseif statue.color == "yellow" then
				Winterblight:SpawnCandyCrushYellowUnit(statue:GetAbsOrigin(), Vector(1,0), true, Winterblight.CandyCrushBlackStatueTable[i+1])
			elseif statue.color == "green" then
				Winterblight:SpawnCandyCrushGreenUnit(statue:GetAbsOrigin(), Vector(1,0), true, Winterblight.CandyCrushBlackStatueTable[i+1])
			end
			UTIL_Remove(statue)
		end
		Winterblight.CandyCrushBlackStatueTable = nil
	end
end

function Winterblight:SpawnCandyCrushRedUnit(position, fv, bBlack, nextUnit)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_candy_crush_red_spirit", position, 0, 1, "Winterblight.CandyCrushAggro.Red", fv, true)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 42
	stone.dominion = true
	local colorVector = Vector(221, 82, 82)
	if bBlack then
		colorVector = Vector(30,30,30)
	end
	Events:ColorWearablesAndBase(stone, colorVector)
	local linkUnit = stone
	if nextUnit then
		linkUnit = nextUnit
	end
	local pfx = ParticleManager:CreateParticle( "particles/roshpit/mountain_protector/blue_steel_dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, stone )
	ParticleManager:SetParticleControlEnt(pfx, 0, stone, PATTACH_POINT, "attach_hitloc", stone:GetAbsOrigin()+Vector(0,0,80), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, linkUnit, PATTACH_POINT, "attach_hitloc", linkUnit:GetAbsOrigin()+Vector(0,0,80), true)
	Timers:CreateTimer(2.0, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
	local masterCrystalAbility = Winterblight.CandyCrushCrystal:FindAbilityByName("winterblight_candy_crush_master_crystal")
	masterCrystalAbility:ApplyDataDrivenModifier(Winterblight.CandyCrushCrystal, stone, "modifier_candy_crush_unit_spawn", {duration = 1})
	StartAnimation(stone, {duration=1.2, activity=ACT_DOTA_SPAWN, rate=0.9})
	return stone
end

function Winterblight:SpawnCandyCrushBlueUnit(position, fv, bBlack, nextUnit)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_candy_crush_blue_spirit", position, 0, 1, "Winterblight.CandyCrushAggro.Blue", fv, true)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 42
	stone.dominion = true
	local colorVector = Vector(86, 123, 255)
	if bBlack then
		colorVector = Vector(30,30,30)
	end
	Events:ColorWearablesAndBase(stone, colorVector)
	local linkUnit = stone
	if nextUnit then
		linkUnit = nextUnit
	end
	stone:SetModelScale(0.7)
	local pfx = ParticleManager:CreateParticle( "particles/roshpit/mountain_protector/blue_steel_dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, stone )
	ParticleManager:SetParticleControlEnt(pfx, 0, stone, PATTACH_POINT, "attach_hitloc", stone:GetAbsOrigin()+Vector(0,0,80), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, linkUnit, PATTACH_POINT, "attach_hitloc", linkUnit:GetAbsOrigin()+Vector(0,0,80), true)
	Timers:CreateTimer(2.0, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	local masterCrystalAbility = Winterblight.CandyCrushCrystal:FindAbilityByName("winterblight_candy_crush_master_crystal")
	masterCrystalAbility:ApplyDataDrivenModifier(Winterblight.CandyCrushCrystal, stone, "modifier_candy_crush_unit_spawn", {duration = 1})
	StartAnimation(stone, {duration=1.2, activity=ACT_DOTA_SPAWN, rate=0.9})
	return stone
end

function Winterblight:SpawnCandyCrushYellowUnit(position, fv, bBlack, nextUnit)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_candy_crush_yellow_spirit", position, 0, 1, "Winterblight.CandyCrushAggro.Yellow", fv, true)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 42
	stone.dominion = true
	local colorVector = Vector(255, 255, 0)
	if bBlack then
		colorVector = Vector(30,30,30)
	end
	Events:ColorWearablesAndBase(stone, colorVector)
	local linkUnit = stone
	if nextUnit then
		linkUnit = nextUnit
	end
	local pfx = ParticleManager:CreateParticle( "particles/roshpit/mountain_protector/blue_steel_dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, stone )
	ParticleManager:SetParticleControlEnt(pfx, 0, stone, PATTACH_POINT, "attach_hitloc", stone:GetAbsOrigin()+Vector(0,0,80), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, linkUnit, PATTACH_POINT, "attach_hitloc", linkUnit:GetAbsOrigin()+Vector(0,0,80), true)
	Timers:CreateTimer(2.0, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	local masterCrystalAbility = Winterblight.CandyCrushCrystal:FindAbilityByName("winterblight_candy_crush_master_crystal")
	masterCrystalAbility:ApplyDataDrivenModifier(Winterblight.CandyCrushCrystal, stone, "modifier_candy_crush_unit_spawn", {duration = 1})
	StartAnimation(stone, {duration=1.2, activity=ACT_DOTA_SPAWN, rate=0.9})
	return stone
end

function Winterblight:SpawnCandyCrushGreenUnit(position, fv, bBlack, nextUnit)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_candy_crush_green_spirit", position, 0, 1, "Winterblight.CandyCrushAggro.Green", fv, true)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 42
	stone.dominion = true
	local colorVector = Vector(71, 159, 56)
	if bBlack then
		colorVector = Vector(30,30,30)
	end
	Events:ColorWearablesAndBase(stone, colorVector)
	stone:SetModelScale(0.85)
	local linkUnit = stone
	if nextUnit then
		linkUnit = nextUnit
	end
	local pfx = ParticleManager:CreateParticle( "particles/roshpit/mountain_protector/blue_steel_dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, stone )
	ParticleManager:SetParticleControlEnt(pfx, 0, stone, PATTACH_POINT, "attach_hitloc", stone:GetAbsOrigin()+Vector(0,0,80), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, linkUnit, PATTACH_POINT, "attach_hitloc", linkUnit:GetAbsOrigin()+Vector(0,0,80), true)
	Timers:CreateTimer(2.0, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	local masterCrystalAbility = Winterblight.CandyCrushCrystal:FindAbilityByName("winterblight_candy_crush_master_crystal")
	masterCrystalAbility:ApplyDataDrivenModifier(Winterblight.CandyCrushCrystal, stone, "modifier_candy_crush_unit_spawn", {duration = 1})
	StartAnimation(stone, {duration=1.2, activity=ACT_DOTA_SPAWN, rate=0.9})
	return stone
end

function Winterblight:ProcessLinks(links, hero)
	Winterblight.CandyCrushLocked = true
	local score = #links
	if hero then
		EmitSoundOn("Winterblight.CandyCrush.Good2", hero) 
		for i = 1, #hero.candy_crush_link_data.pfxTable, 1 do
			ParticleManager:DestroyParticle(hero.candy_crush_link_data.pfxTable[i], false)
		end
	else
		EmitSoundOnLocationWithCaster(links[1]:GetAbsOrigin(), "Winterblight.CandyCrush.Good2", Winterblight.Master)
	end
	Winterblight.CandyCrushShiftTable = {}
	shift_table = {}
	for i = 1, #links, 1 do
		local link = links[i]
		if link.color == "red" then
			Winterblight:SpawnCandyCrushRedUnit(link:GetAbsOrigin(), Vector(1,0), true, links[i+1])
		elseif link.color == "blue" then
			Winterblight:SpawnCandyCrushBlueUnit(link:GetAbsOrigin(), Vector(1,0), true, links[i+1])
		elseif link.color == "yellow" then
			Winterblight:SpawnCandyCrushYellowUnit(link:GetAbsOrigin(), Vector(1,0), true, links[i+1])
		elseif link.color == "green" then
			Winterblight:SpawnCandyCrushGreenUnit(link:GetAbsOrigin(), Vector(1,0), true, links[i+1])
		end
		table.insert(shift_table, link)
		link:AddNoDraw()	
	end
	local collapse = "vertical"
	for i = 1, #links, 1 do
		print("LINK"..i..":")
		print("i: "..links[i].index_i)
		print("j: "..links[i].index_j)
	end
	print("-----")
	if links[1].index_i == links[2].index_i then
		collapse = "horizontal"
	end	
	local total_delay = 0.5
	if collapse == "vertical" then
		total_delay = total_delay + #shift_table*0.5
	end
	local newUnitsSpawnedTable = {}
	if collapse == "vertical" then
		if links[1].index_i > links[2].index_i then
			links = WallPhysics:ReverseTable(links)
		end
		Timers:CreateTimer(0.5, function()
			local spawns = #links
			local j = links[1].index_j
			for i = links[#links].index_i+1, 10, 1 do
				print("VERTICAL COLLAPSE")
				local comparitor = Winterblight.CandyCrushLayout[i][j]
				local new_i = comparitor.index_i
				local new_j = comparitor.index_j
				Winterblight:ShiftLinkUnitDown(comparitor, #links)
				print(comparitor.index_i.."---"..comparitor.index_j.." IS SHIFTING DOWN "..#links.." STEPS")
				comparitor.index_i = comparitor.index_i - #links
				if comparitor.index_i > 0 then
					print("NOW STORED AS"..comparitor.index_i.."---"..comparitor.index_j)
					Winterblight.CandyCrushLayout[comparitor.index_i][j] = comparitor
				end
			end
			Timers:CreateTimer(0.5, function()
				print("SPAWNS: "..spawns)
				for i = 11-spawns, 10, 1 do
					print("SPAWNING i:"..i.." j:"..j)
					local basePos = Vector(2958, -15832)
					local position = basePos+Vector(242*(j-1), 182*(i-1))
					Winterblight:SpawnRandomColorStatue(position, i,j)
				end
			end)
		end)
	end
	for i = 1, #shift_table, 1 do
		local delay = 0
		if collapse == "horizontal" then
			delay = 0
		end
		local shift_link = shift_table[i]
		Timers:CreateTimer((i-1)*delay + 0.5, function()
			if collapse == "vertical" then

			else
				local shiftDownTable = {}
				for i = 1, #Winterblight.CandyCrushLayout, 1 do
					for j = 1, #Winterblight.CandyCrushLayout[i], 1 do
						local comparitor = Winterblight.CandyCrushLayout[i][j]
						local new_i = comparitor.index_i
						local new_j = comparitor.index_j
						if comparitor.index_i > shift_link.index_i and comparitor.index_j == shift_link.index_j then
							Winterblight:ShiftLinkUnitDown(comparitor, 1)
							comparitor.index_i = comparitor.index_i - 1
							Winterblight.CandyCrushLayout[comparitor.index_i][comparitor.index_j] = comparitor
						end
						if i == 10 and comparitor.index_j == shift_link.index_j then
							Timers:CreateTimer(0.5, function()
								local basePos = Vector(2958, -15832)
								local position = basePos+Vector(242*(new_j-1), 182*9)
								Winterblight:SpawnRandomColorStatue(position, 10,new_j)
							end)
						end
					end
				end
			end
		end)
	end
	Timers:CreateTimer(total_delay+0.8, function()
		Winterblight:CheckCollapseCombos(hero)
		for i = 1, #links, 1 do
			UTIL_Remove(links[i])
		end	
		print("TURN OFF CANDY CRUSH LOCK")
		Winterblight.CandyCrushLocked = false
	end)
end

function Winterblight:ShiftLinkUnitDown(link_unit, steps)
	local distance = steps*182
	table.insert(Winterblight.CandyCrushShiftTable, link_unit)
	for i = 1, 16, 1 do
		Timers:CreateTimer(i*0.03, function()
			link_unit:SetAbsOrigin(link_unit:GetAbsOrigin()-Vector(0,distance/16,0))
		end)
	end
end

function Winterblight:SpawnRandomColorStatue(position, index_i, index_j)
	local color_possibilities = {"red", "yellow", "green", "blue"}
	local color = color_possibilities[RandomInt(1, 4)]
	Winterblight:SpawnCandyCrushStatue(position, color, index_i, index_j)
end

function Winterblight:CheckCollapseCombos(hero)
	for i = 1, #Winterblight.CandyCrushShiftTable, 1 do
		local link_unit = Winterblight.CandyCrushShiftTable[i]
		if Winterblight:RecursiveCandyCrush({link_unit}, -1, true, hero) then
			return false
		end
		if Winterblight:RecursiveCandyCrush({link_unit}, 1, true, hero) then
			return false
		end
		if Winterblight:RecursiveCandyCrush({link_unit}, -1, false, hero) then
			return false
		end
		if Winterblight:RecursiveCandyCrush({link_unit}, 1, false, hero) then
			return false
		end
	end
	print("TURN OFF CANDY CRUSH LOCK")
	Winterblight.CandyCrushLocked = false
end

function Winterblight:RecursiveCandyCrush(links_table, direction, horiz, hero)
	local link_unit = links_table[#links_table]
	if not IsValidEntity(link_unit) then
		return false
	end
	if horiz then
		if link_unit.index_j + direction < 1 or link_unit.index_j + direction > 10 then
			return false
		end
		if Winterblight.CandyCrushLayout[link_unit.index_i][link_unit.index_j+direction].color == link_unit.color then
			table.insert(links_table, Winterblight.CandyCrushLayout[link_unit.index_i][link_unit.index_j+direction])
			Winterblight:RecursiveCandyCrush(links_table, direction, horiz, hero)
			return false
		end
	else
		if link_unit.index_i + direction < 1 or link_unit.index_i + direction > 10 then
			return false
		end
		if Winterblight.CandyCrushLayout[link_unit.index_i+direction][link_unit.index_j].color == link_unit.color then
			table.insert(links_table, Winterblight.CandyCrushLayout[link_unit.index_i+direction][link_unit.index_j])
			Winterblight:RecursiveCandyCrush(links_table, direction, horiz, hero)
			return false
		end
	end
	if #links_table >= 3 then
		Winterblight:ProcessLinks(links_table, hero)
		return true
	else
		return false
	end
end
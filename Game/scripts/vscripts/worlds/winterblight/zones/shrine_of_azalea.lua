function Winterblight:SpawnAzaleaCups()
	Winterblight:SpawnCup1()
	Winterblight:SpawnCup2()
	Winterblight:SpawnCup3()
	Winterblight:SpawnCup4()
	Winterblight:SpawnCup5()
	Winterblight:SpawnCup6()
end

function Winterblight:CupSpawnCondition(index)
	print("T5A")
	if not Winterblight.AzaleaDungeonOpened then
		return false
	end
	if Winterblight.CupSpawnsInit then
	else
		Winterblight.CupSpawnsInit = true
		Winterblight.ImportantCupSpawnTable = {0,0,0,0,0,0}
	end
	if Winterblight.ImportantCupSpawnTable[index] == 1 then
		return false
	else
		Winterblight.ImportantCupSpawnTable[index] = 1
		return true
	end
end

function Winterblight:SpawnCup1()
	Timers:CreateTimer(1, function()
		if Winterblight.MathPuzzleComplete then
			if Winterblight:CupSpawnCondition(1) then
				Winterblight:SpawnAzaleaCup(Vector(15910, -15831), Vector(-1,0), 1)
			end
		end
	end)
end

function Winterblight:SpawnCup2()
	Timers:CreateTimer(1.2, function()
		if Winterblight.CandyCrushComplete then
			if Winterblight:CupSpawnCondition(2) then
				Winterblight:SpawnAzaleaCup(Vector(5653, -14257), Vector(0,-1), 2)
			end
		end
	end)
end

function Winterblight:SpawnCup3()
	Timers:CreateTimer(1.4, function()
		if Winterblight.CruxalSlain then
			if Winterblight:CupSpawnCondition(3) then
				Winterblight:SpawnAzaleaCup(Vector(128, -11520), Vector(-1,0), 3)
			end
		end
	end)
end

function Winterblight:SpawnCup4()
	Timers:CreateTimer(1.6, function()
		if Winterblight.RuptholdSlain then
			if Winterblight:CupSpawnCondition(4) then
				Winterblight:SpawnAzaleaCup(Vector(-7077, -15307), Vector(0,-1), 4)
			end
		end
	end)
end

function Winterblight:SpawnCup5()
	Timers:CreateTimer(1.8, function()
		if Winterblight.TriBossesSlain then
			if Winterblight:CupSpawnCondition(5) then
				Winterblight:SpawnAzaleaCup(Vector(-5618, -13574), Vector(0,1), 5)
			end
		end
	end)
end

function Winterblight:SpawnCup6()
	Timers:CreateTimer(2, function()
		if Winterblight.StargazerSuccess then
			if Winterblight:CupSpawnCondition(6) then	
				Winterblight:SpawnAzaleaCup(Vector(-14935, -15961), Vector(0,1), 6)
			end
		end
	end)
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
    local pfx = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8_ring_spiral.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, cup:GetAbsOrigin())
    cup:SetAbsOrigin(cup:GetAbsOrigin()-Vector(0,0,500))
    Winterblight:MoveObject(cup, cup:GetAbsOrigin()+Vector(0,0,500), 120)
    Winterblight:objectShake(cup, 120, 3, true, true, false, nil, 5)
    Timers:CreateTimer(3.4, function()
    	EmitSoundOn("Winterblight.AzaleaCup.Spawn", cup)
	    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )

	    ParticleManager:SetParticleControl( particle1, 0, cup:GetAbsOrigin() )
	    ParticleManager:SetParticleControl( particle1, 1, Vector(300, 2, 1000) )
	    ParticleManager:SetParticleControl( particle1, 3, Vector(300, 550, 550) )
	    Timers:CreateTimer(4, function()
	    	ParticleManager:DestroyParticle(particle1, false)
	    end)
    end)
    Timers:CreateTimer(3.6, function()
    	ParticleManager:DestroyParticle(pfx, false)
    end)
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
    EmitSoundOn("Winterblight.IceCrystal.Shatter", cup)
    CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_wisp/wisp_death.vpcf", cup:GetAbsOrigin()+Vector(0,0,600), 3)
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
				enemies[i].pushVector = ((enemies[i]:GetAbsOrigin() - cup:GetAbsOrigin())*Vector(1,1,0)):Normalized()
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
			elseif cup.index == 2 then
				if Winterblight.AzaleaPortalTable[2] == 0 then
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(1255, -14425, 490+Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
					AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(1255, -14425, 250+Winterblight.ZFLOAT), 300, 99999, false)
					Winterblight.AzaleaPortalTable[2] = 1
				end
			elseif cup.index == 3 then
				if Winterblight.AzaleaPortalTable[3] == 0 then
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(448, -13426, 490+Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
					AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(448, -13426, 250+Winterblight.ZFLOAT), 300, 99999, false)
					Winterblight.AzaleaPortalTable[3] = 1
				end
				if Winterblight.AzaleaPortalTable[4] == 0 then
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-768, -13416, 490+Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
					AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-768, -13416, 250+Winterblight.ZFLOAT), 300, 99999, false)
					Winterblight.AzaleaPortalTable[4] = 1
				end
			elseif cup.index == 4 then
				if Winterblight.AzaleaPortalTable[4] == 0 then
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-768, -13416, 490+Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
					AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-768, -13416, 250+Winterblight.ZFLOAT), 300, 99999, false)
					Winterblight.AzaleaPortalTable[4] = 1
				end
			elseif cup.index == 5 then
				if Winterblight.AzaleaPortalTable[5] == 0 then
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-1600, -14400, 490+Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
					AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-1600, -14400, 250+Winterblight.ZFLOAT), 300, 99999, false)
					Winterblight.AzaleaPortalTable[5] = 1
				end
			elseif cup.index == 6 then
				if Winterblight.AzaleaPortalTable[6] == 0 then
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-1600, -15152, 490+Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
					AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-1600, -15152, 250+Winterblight.ZFLOAT), 300, 99999, false)
					Winterblight.AzaleaPortalTable[6] = 1
				end
			end
			local sum = 0
			for j = 1, #Winterblight.AzaleaPortalTable, 1 do
				sum = sum + Winterblight.AzaleaPortalTable[j]
			end
			if sum == 5 then
				Winterblight:SpawnAzaleaBoss()
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
			if not Winterblight.MathPuzzleComplete then
				Winterblight.AzaleaSwitch1Pressed = true
				Winterblight:ActivateSwitchGeneric(Vector(15733, -11788, 78+Winterblight.ZFLOAT), "AzaleaSwitchProp1", true, 0.352)
				if not Winterblight.AzaleaMathCounter then
					Winterblight.AzaleaMathCounter = 0
				end
				Timers:CreateTimer(2, function()
					if Winterblight.AzaleaMathCounter == Winterblight.MathCount then
						Winterblight.MathPuzzleComplete = true
						Timers:CreateTimer(3, function()
							Winterblight:SpawnCup1()
						end)
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
						    		Winterblight.AzaleaMathCounter = Winterblight.AzaleaMathCounter + 1
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
						    		
						    	end) 			
					    	end	
					    end	
					    local delay = math.max(spawnCount*0.35, 3)
				    	Timers:CreateTimer(spawnCount*0.35, function()
				    		Timers:CreateTimer(2, function()
				    			Winterblight.AzaleaSwitch1Pressed = false
				    		end)
				    		Winterblight:ActivateSwitchGeneric(Vector(15733, -11788, 78+Winterblight.ZFLOAT), "AzaleaSwitchProp1", false, 0.352)
				    	end)		
					end
				end)
			end
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
	if Winterblight.Stones >= 1 then
		stone:AddAbility("ability_magic_immune_break"):SetLevel(GameState:GetDifficultyFactor())
	end
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
	if Winterblight.Stones >= 1 then
		stone:AddAbility("ability_stun_immunity"):SetLevel(GameState:GetDifficultyFactor())
	end
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
	Winterblight.CandyCrushProgressCrystal = Entities:FindByNameNearest("CandyCrushProgress", Vector(5653, -14257), 2000)
	Winterblight.CandyCrushProgressCrystal:SetModelScale(0.3)
	Winterblight.CandyCrushProgressCrystal:SetRenderColor(0, 0, 0)
	Winterblight.CandyCrushProgressScore = 0
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

function Winterblight:ProcessLinks(links, hero, stackLevel)
	if Winterblight.CandyCrushComplete then
		return false
	end
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
			Winterblight:SpawnCandyCrushRedUnit(link:GetAbsOrigin(), Vector(1,0), false, links[i+1])
		elseif link.color == "blue" then
			Winterblight:SpawnCandyCrushBlueUnit(link:GetAbsOrigin(), Vector(1,0), false, links[i+1])
		elseif link.color == "yellow" then
			Winterblight:SpawnCandyCrushYellowUnit(link:GetAbsOrigin(), Vector(1,0), false, links[i+1])
		elseif link.color == "green" then
			Winterblight:SpawnCandyCrushGreenUnit(link:GetAbsOrigin(), Vector(1,0), false, links[i+1])
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
	Timers:CreateTimer(total_delay+0.8+stackLevel*0.5, function()
		Winterblight:CheckCollapseCombos(hero, stackLevel)
		local links_count = #links
		for i = 1, #links, 1 do
			UTIL_Remove(links[i])
		end	
		print("TURN OFF CANDY CRUSH LOCK")
		Winterblight.CandyCrushLocked = false
		Winterblight:CandyCrushPoints(links_count)
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
	if not Winterblight.CandyCrushComplete then
		local color_possibilities = {"red", "yellow", "green", "blue"}
		local color = color_possibilities[RandomInt(1, 4)]
		Winterblight:SpawnCandyCrushStatue(position, color, index_i, index_j)
	end
end

function Winterblight:CheckCollapseCombos(hero, stackLevel)
	for i = 1, #Winterblight.CandyCrushShiftTable, 1 do
		local link_unit = Winterblight.CandyCrushShiftTable[i]
		if Winterblight:RecursiveCandyCrush({link_unit}, 1, true, hero, stackLevel) then
		else
			if Winterblight:RecursiveCandyCrush({link_unit}, -1, true, hero, stackLevel) then
			else
				if Winterblight:RecursiveCandyCrush({link_unit}, 1, false, hero, stackLevel) then
				else
					if Winterblight:RecursiveCandyCrush({link_unit}, -1, false, hero, stackLevel) then
					else
						Winterblight.CandyCrushLocked = false
					end
				end
			end
		end
	end
end

function Winterblight:RecursiveCandyCrush(links_table, direction, horiz, hero, stackLevel)
	local link_unit = links_table[#links_table]
	if Winterblight.CandyCrushComplete then
		return false
	end
	if not IsValidEntity(link_unit) then
		return false
	end
	if horiz then
		if link_unit.index_j + direction < 1 or link_unit.index_j + direction > 10 then
			return false
		end
		if Winterblight.CandyCrushLayout[link_unit.index_i][link_unit.index_j+direction].color == link_unit.color then
			table.insert(links_table, Winterblight.CandyCrushLayout[link_unit.index_i][link_unit.index_j+direction])
			Winterblight:RecursiveCandyCrush(links_table, direction, horiz, hero, stackLevel)
			return false
		end
	else
		if link_unit.index_i + direction < 1 or link_unit.index_i + direction > 10 then
			return false
		end
		if Winterblight.CandyCrushLayout[link_unit.index_i+direction][link_unit.index_j].color == link_unit.color then
			table.insert(links_table, Winterblight.CandyCrushLayout[link_unit.index_i+direction][link_unit.index_j])
			Winterblight:RecursiveCandyCrush(links_table, direction, horiz, hero, stackLevel)
			return false
		end
	end
	if #links_table >= 3 then
		stackLevel = stackLevel + 1
		Winterblight:ProcessLinks(links_table, hero, stackLevel)
		return true
	else
		return false
	end
end

function Winterblight:CandyCrushPoints(links_count)
	local goal = 12 + GameState:GetDifficultyFactor()*3
	local points = links_count - 2
	Winterblight.CandyCrushProgressScore = Winterblight.CandyCrushProgressScore + points
	print("SCORE: "..Winterblight.CandyCrushProgressScore)
	local scale = 3*(Winterblight.CandyCrushProgressScore/goal)
	local color = 255*(Winterblight.CandyCrushProgressScore/goal)
	Winterblight.CandyCrushProgressCrystal:SetModelScale(scale)
	Winterblight.CandyCrushProgressCrystal:SetRenderColor(color, color, color)
	if Winterblight.CandyCrushProgressScore >= goal then
		Winterblight.CandyCrushLocked = true
		Winterblight.CandyCrushComplete = true
		EmitSoundOnLocationWithCaster(Winterblight.CandyCrushCrystal:GetAbsOrigin(), "Winterblight.AzaleaCrystal.FinishPuzzle", Winterblight.Master)
		EmitSoundOnLocationWithCaster(Winterblight.CandyCrushProgressCrystal:GetAbsOrigin(), "Winterblight.AzaleaCrystal.FinishPuzzle", Winterblight.Master)
		UTIL_Remove(Winterblight.CandyCrushCrystal)
		Timers:CreateTimer(0.5, function()
			for i = 1, #Winterblight.CandyCrushLayout, 1 do
				for j = 1, #Winterblight.CandyCrushLayout[i], 1 do
					Timers:CreateTimer(0.05*j + 0.5*i, function()
						local statue = Winterblight.CandyCrushLayout[i][j]
						if IsValidEntity(statue) then
						    EmitSoundOn("Winterblight.CandyCrush.SpawnStatue", statue)
						    CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_wisp/wisp_death.vpcf", statue:GetAbsOrigin()+Vector(0,0,40), 3)
						    UTIL_Remove(statue)
						end
					end)
				end
			end
			for i = 1, #Winterblight.CandyCrushBlackStatueTable, 1 do
				Timers:CreateTimer(i*0.5, function()
					local statue = Winterblight.CandyCrushBlackStatueTable[i]
					if IsValidEntity(statue) then
					    EmitSoundOn("Winterblight.CandyCrush.SpawnStatue", statue)
					    CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_wisp/wisp_death.vpcf", statue:GetAbsOrigin()+Vector(0,0,40), 3)
					    UTIL_Remove(statue)
					end
				end)
			end
		end)
		Timers:CreateTimer(0.5, function()
			local pfx = CustomAbilities:QuickParticleAtPoint("particles/act_2/flying_shatter_blast_explosion.vpcf", Winterblight.CandyCrushProgressCrystal:GetAbsOrigin(), 3)
			for i = 1, 6, 1 do
				ParticleManager:SetParticleControl(pfx, i, Winterblight.CandyCrushProgressCrystal:GetAbsOrigin())
			end
			EmitSoundOnLocationWithCaster(Winterblight.CandyCrushProgressCrystal:GetAbsOrigin(), "Winterblight.CandyCrystal.Shatter", Winterblight.Master)
			local position = Winterblight.CandyCrushProgressCrystal:GetAbsOrigin()
			UTIL_Remove(Winterblight.CandyCrushProgressCrystal)
			Timers:CreateTimer(3.5, function()
				Winterblight:SpawnCup2()
				EmitSoundOnLocationWithCaster(position, "Winterblight.Azalea.Win", Winterblight.Master)
			end)
		end)
		--END CANDY CRUSH
	end
end

function Winterblight:CandyCrushRoomMobsSpawn()
	if not Winterblight.CandyCrushRoomMobsSpawned then
		Winterblight.CandyCrushRoomMobsSpawned = true
		local luck = RandomInt(1, 3)
		luck = 2
		if luck == 1 then
			for i = 0, 4, 1 do
				Winterblight:SpawnAzaleaHighguard(Vector(5504, -15744+(256*i)), Vector(1,0))
			end
			Timers:CreateTimer(1, function()
				for i = 0, 3, 1 do
					Winterblight:SpawnSoftwalker(Vector(2560, -15744+(256*i)), Vector(1,0))
				end
			end)
			Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(3072, -13824), Vector(3456, -13824), Vector(4736, -13824), Vector(5120, -13824)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnArmoredKnight(positionTable[i], Vector(0,-1))
				end
			end)
		elseif luck == 2 then
			Timers:CreateTimer(0.5, function()
				local positionTable = {}
				for i = 0, 14, 1 do
				 local randomSpawn = Vector(2816, -15872) + Vector(RandomInt(0, 2800), RandomInt(0, 1900))
				 table.insert(positionTable, randomSpawn)
				end
			    for i = 1, #positionTable, 1 do
			      Timers:CreateTimer(i*0.2, function()
			        local patrolPositionTable = {}
			        for j = 1, #positionTable, 1 do
			          local index = i + j
			          if index > #positionTable then
			            index = index - #positionTable
			          end
			          table.insert(patrolPositionTable, positionTable[index])
			        end
		            local elemental = Winterblight:SpawnSpectralWitch(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 25, 4+RandomInt(1,3), 320, patrolPositionTable)
			      end)
			    end
			end)
		elseif luck == 3 then
			Timers:CreateTimer(0.5, function()
				local positionTable = {}
				for i = 0, 6, 1 do
				 local randomSpawn = Vector(2816, -15872) + Vector(RandomInt(0, 2800), RandomInt(0, 1900))
				 table.insert(positionTable, randomSpawn)
				end
			    for i = 1, #positionTable, 1 do
			      Timers:CreateTimer(i*0.2, function()
			        local patrolPositionTable = {}
			        for j = 1, #positionTable, 1 do
			          local index = i + j
			          if index > #positionTable then
			            index = index - #positionTable
			          end
			          table.insert(patrolPositionTable, positionTable[index])
			        end
		            local elemental = Winterblight:SpawnSpectralWitch(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 25, 4+RandomInt(1,3), 320, patrolPositionTable)
			      end)
			    end
			end)
			Timers:CreateTimer(2.1, function()
				local positionTable = {Vector(2688, -15744), Vector(2540, -15488), Vector(2651, -15232), Vector(2464, -14976), Vector(2641, -14720)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnCrystalRunner(positionTable[i], WallPhysics:rotateVector(Vector(1,0), 2*math.pi*RandomInt(-3, 3)/10))
				end
			end)	
			Timers:CreateTimer(0.1, function()
				local positionTable = {Vector(5760, -16000), Vector(5504, -16000), Vector(5504, -15744), Vector(5760, -15744)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnCrystalRunner(positionTable[i], Vector(1,1))
				end
			end)	
			Timers:CreateTimer(1, function()
				local positionTable = {Vector(3072, -13824), Vector(3328, -13824), Vector(3584, -13824), Vector(4648, -13824), Vector(4904, -13824), Vector(5160, -13824)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnGhostStriker(positionTable[i], Vector(0,-1))
				end
			end)		
		end
	end
end

function Winterblight:SpawnSpectralWitch(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_spectral_witch", position, 1, 1, "Winterblight.SpectralWitch.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 42
	stone.dominion = true
	stone:SetRenderColor(82, 150, 255)
	if Winterblight.Stones >= 3 then
		stone:AddAbility("creature_pure_strike"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:AzaleaSpawn3()
	if not Winterblight.Azalea3Spawned then
		Winterblight.Azalea3Spawned = true
		Winterblight:SpawnAzaleaPuck(Vector(7138, -13028))
		local luck = RandomInt(1, 3)
		Winterblight.PuckGuardTable = {}
		if luck == 1 then
			local positionTable = {Vector(8192, -12160), Vector(7560, -11520), Vector(7063, -12160), Vector(8066, -10599), Vector(7054, -10294)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i*0.3, function()
					local guard = Winterblight:SpawnPuckGuard(positionTable[i], Vector(0,-1))
					table.insert(Winterblight.PuckGuardTable, guard)
				end)
			end
		elseif luck == 2 then
			local positionTable = {Vector(7563, -13038), Vector(8261, -12609), Vector(8261, -11825), Vector(7040, -11825), Vector(7040, -10880), Vector(8064, -10382)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i*0.3, function()
					local guard = Winterblight:SpawnPuckGuard(positionTable[i], Vector(0,-1))
					table.insert(Winterblight.PuckGuardTable, guard)
				end)
			end
		elseif luck == 3 then
			local positionTable = {Vector(7600, -13256), Vector(7040, -12160), Vector(7557, -12160), Vector(8192, -11581), Vector(7040, -10240), Vector(7613, -10744), Vector(8192, -10297)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i*0.3, function()
					local guard = Winterblight:SpawnPuckGuard(positionTable[i], Vector(0,-1))
					table.insert(Winterblight.PuckGuardTable, guard)
				end)
			end
		end
		local luck2 = RandomInt(1, 3)
		if luck2 == 1 then
			local positionTable = {Vector(6833, -13747), Vector(7297, -13747), Vector(7808, -13747), Vector(8320, -13747)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnArmoredKnight(positionTable[i], Vector(0,-1))
		    end	
			for i = 0, 7+GameState:GetDifficultyFactor(), 1 do
				local unit = Winterblight:SpawnSkaterFiend(Vector(7040+RandomInt(0,1152), -12288+RandomInt(0,792)), RandomVector(1))
				unit.minVector = Vector(7040, -12288)
				unit.maxXroam = 1152
				unit.maxYroam = 792
			end	
			Timers:CreateTimer(0.5, function()
				local positionTable = {Vector(6912, -10240), Vector(7028, -10880), Vector(8147, -10924), Vector(8147, -10240)}
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
		            local elemental = Winterblight:SpawnAzaleaMaiden(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 35, 5, 220, patrolPositionTable)
		          end)
		        end
			end)
		elseif luck2 == 2 then
			for i = 0, 4+GameState:GetDifficultyFactor(), 1 do
				local unit = Winterblight:SpawnSkaterFiend(Vector(6912+RandomInt(0,1400), -13216+RandomInt(0,400)), RandomVector(1))
				unit.minVector = Vector(6912, -13216)
				unit.maxXroam = 1400
				unit.maxYroam = 400
			end	
			for i = 0, 7+GameState:GetDifficultyFactor(), 1 do
				Timers:CreateTimer(i*0.3, function()
					Winterblight:SpawnSpectralWitch(Vector(7040+RandomInt(0,1152), -12288+RandomInt(0,792)), RandomVector(1))
				end)
			end	
			local positionTable = {Vector(7040, -10240), Vector(7344, -10624), Vector(7936, -10624), Vector(8192, -10213)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnCrystalRunner(positionTable[i], Vector(0,-1))
		    end
		elseif luck2 == 3 then
			for i = 0, 6+GameState:GetDifficultyFactor(), 1 do
				local unit = Winterblight:SpawnSkaterFiend(Vector(6912+RandomInt(0,1400), -10963+RandomInt(0,740)), RandomVector(1))
				unit.minVector = Vector(6912, -10963)
				unit.maxXroam = 1400
				unit.maxYroam = 740
			end		
			local positionTable = {Vector(6912, -13440), Vector(7265, -13440), Vector(7622, -13440), Vector(8024, -13440), Vector(8380, -13440)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i*0.3, function()
					Winterblight:SpawnSpectralWitch(positionTable[i], Vector(0,-1))
				end)
			end
			Timers:CreateTimer(0.5, function()
				local positionTable = {Vector(6912, -11485), Vector(7168, -11776), Vector(7040, -12288), Vector(7648, -12227), Vector(7552, -11966), Vector(7796, -11648), Vector(8259, -11517), Vector(8133, -12036), Vector(8259, -12416)}
		        local patrolPositionTable = {}
		        for j = 1, #positionTable, 1 do
		          local index = i + j
		          if index > #positionTable then
		            index = index - #positionTable
		          end
		          table.insert(patrolPositionTable, positionTable[index])
		        end
		        for j = 1, 1, 1 do
		          Timers:CreateTimer(j*1, function()
		            local elemental = Winterblight:SpawnCrystalRunner(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 35, 5, 220, patrolPositionTable)
		          end)
		        end
			end)
		end
	end
end

function Winterblight:SpawnAzaleaPuck(position)
    local puck = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    puck:SetAbsOrigin(puck:GetAbsOrigin()+Vector(0,0,12))
    puck:AddAbility("winterblight_attackable_unit"):SetLevel(1)
    
    
    puck:SetOriginalModel("models/winterblight/azalea_puck.vmdl")
    puck:SetModel("models/winterblight/azalea_puck.vmdl")
    puck:SetRenderColor(82, 80, 255)
    puck:SetModelScale(1)

    puck:RemoveAbility("dummy_unit")
    puck:RemoveModifierByName("dummy_unit")
    puck.basePosition = position

    puck.pushLock = true
    puck.dummy = true
    puck.jumpLock = true
    puck.prop_id = 4
    puck.speed = 0
    puck.puck = true
    puck.rotationSpeed = 0
    puck.fv = puck:GetForwardVector()
    EmitSoundOn("Winterblight.CandyCrush.SpawnStatue", puck)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", puck, 3)
end

function Winterblight:AzaleaPuckAttacked(caster, attacker)
	if caster.locked then
		return false
	end
	print("PUCK ATTACKED")
	caster.speed = math.min(caster.speed + 25, 40)
	local ability = caster:FindAbilityByName("winterblight_attackable_unit")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_winterblight_puck_motion", {})
	caster.fv = ((caster:GetAbsOrigin()-attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	caster.rotationSpeed = math.min(caster.rotationSpeed + 1, 4)
	EmitSoundOn("Winterblight.Puck.Impact", caster)
end

function Winterblight:SpawnPuckGuard(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_puck_guard", position, 1, 1, nil, fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 42
	stone.dominion = true
	stone:SetRenderColor(180, 200, 255)
	if Winterblight.Stones >= 1 then
		stone:RemoveAbility("armor_break")
		stone:AddAbility("armor_break_ultra"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:InitializeAzaleaPlatformRoom()
	Winterblight.AzaleaPlatformsTable = {}
	local bordersSearchTable = {Vector(5288, -10992, 143+Winterblight.ZFLOAT), Vector(5988, -12072, 136+Winterblight.ZFLOAT), Vector(4619, -12168, 144+Winterblight.ZFLOAT), Vector(4258, -10951, 143+Winterblight.ZFLOAT), Vector(3479, -10380, 144+Winterblight.ZFLOAT), Vector(2359, -11218, 144+Winterblight.ZFLOAT), Vector(3000, -12541, 144+Winterblight.ZFLOAT), Vector(4909, -13066, 144+Winterblight.ZFLOAT), Vector(378, -11454, 50+Winterblight.ZFLOAT)}
	-- local platformSearchTable = {Vector(5288, -10992, 143+Winterblight.ZFLOAT), }
	-- local blockersSearchTable = {Vector(5307, -111264, 143+Winterblight.ZFLOAT), }
	for i = 1, 9, 1 do
		Timers:CreateTimer(i*0.8, function()
			local platform = {}
			platform.borders = Entities:FindByNameNearest("AzaleaPlatformBorders"..i, bordersSearchTable[i], 2500)
			platform.blockers = Entities:FindAllByNameWithin("AzaleaPlatformBlocker"..i, bordersSearchTable[i], 5000)
			platform.main = Entities:FindByNameNearest("AzaleaPlatform"..i, bordersSearchTable[i], 2500)
			platform.raised = false
			platform.index = i
			table.insert(Winterblight.AzaleaPlatformsTable, platform)
		end)
	end
	Winterblight.AzaleaPlatformsOrder = RandomInt(1, 3)
	Winterblight.AzaleaPlatformsState = 0
	Timers:CreateTimer(9, function()
		for i = 1, #Winterblight.AzaleaPlatformsTable, 1 do
			local platform = Winterblight.AzaleaPlatformsTable[i]
			platform.main:SetAbsOrigin(platform.main:GetAbsOrigin()-Vector(0,0,2000))
			platform.borders:SetAbsOrigin(platform.borders:GetAbsOrigin()-Vector(0,0,2000))
		end
	end)
end

function Winterblight:PlatformRoomStartBeacon()
	Winterblight:CreatePlatformBeacon(Vector(5593, -10399, 145+Winterblight.ZFLOAT), 1, 0)
	Timers:CreateTimer(0.5, function()
		local positionTable = {Vector(640, -12095), Vector(1102, -10718), Vector(2587, -12337), Vector(3456, -13089), Vector(3388, -11467), Vector(4480, -10549), Vector(5307, -12416), Vector(5888, -13056)}
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
	        for j = 0, 2, 1 do
	          Timers:CreateTimer(j*0.8, function()
	            local elemental = Winterblight:SpawnAzaleaSorceress(positionTable[i]+RandomVector(RandomInt(1,400)), RandomVector(1))
	            Winterblight:AddPatrolArguments(elemental, 35, RandomInt(5, 7), 220, patrolPositionTable)
	          end)
	        end
	      end)
	    end
	end)	
	Timers:CreateTimer(1.5, function()
		local positionTable = {Vector(4736, -13167), Vector(2587, -12239), Vector(3712, -11008), Vector(5307, -13136), Vector(2762, -10582), Vector(1366, -11467), Vector(-562, -11483)}
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
	          Timers:CreateTimer(j*0.8, function()
	            local elemental = Winterblight:SpawnSpectralWitch(positionTable[i]+RandomVector(RandomInt(1,400)), RandomVector(1))
	            Winterblight:AddPatrolArguments(elemental, 35, RandomInt(5, 7), 220, patrolPositionTable)
	            Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, elemental, "modifier_winterblight_flying_generic", {})
	          end)
	        end
	      end)
	    end
	end)	
end

function Winterblight:CreateBeacons2to9()
	Winterblight.AzaleaPlatformsState = Winterblight.AzaleaPlatformsState + 1
	if Winterblight.AzaleaPlatformsOrder == 1 then
		if Winterblight.AzaleaPlatformsState == 1 then
			Winterblight:CreatePlatformBeacon(Vector(5292, -10062, 145+Winterblight.ZFLOAT), 2, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 2 then
			Winterblight:CreatePlatformBeacon(Vector(6327, -12416, 145+Winterblight.ZFLOAT), 3, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 3 then
			-- SHOULD BE ON TOP OF PREVIOUS INDEX, RAISES INDEX IN HERE
			Winterblight:CreatePlatformBeacon(Vector(3968, -11791, 145+Winterblight.ZFLOAT), 5, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 4 then
			Winterblight:CreatePlatformBeacon(Vector(2029, -10624, 145+Winterblight.ZFLOAT), 4, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 5 then
			Winterblight:CreatePlatformBeacon(Vector(4480, -11472, 145+Winterblight.ZFLOAT), 6, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 6 then
			Winterblight:CreatePlatformBeacon(Vector(1724, -11188, 145+Winterblight.ZFLOAT), 7, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 7 then
			Winterblight:CreatePlatformBeacon(Vector(3456, -12991, 145+Winterblight.ZFLOAT), 8, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 8 then
			Winterblight:CreatePlatformBeacon(Vector(5958, -12928, 145+Winterblight.ZFLOAT), 9, Winterblight.AzaleaPlatformsState)
			Winterblight:AzaleaLastPlatformRaised()
		end
	elseif Winterblight.AzaleaPlatformsOrder == 2 then
		if Winterblight.AzaleaPlatformsState == 1 then
			Winterblight:CreatePlatformBeacon(Vector(5307, -11904, 145+Winterblight.ZFLOAT), 5, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 2 then
			Winterblight:CreatePlatformBeacon(Vector(2816, -10112, 145+Winterblight.ZFLOAT), 6, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 3 then
			-- SHOULD BE ON TOP OF PREVIOUS INDEX, RAISES INDEX IN HERE
			Winterblight:CreatePlatformBeacon(Vector(3214, -11467, 145+Winterblight.ZFLOAT), 3, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 4 then
			Winterblight:CreatePlatformBeacon(Vector(5248, -12544, 145+Winterblight.ZFLOAT), 7, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 5 then
			Winterblight:CreatePlatformBeacon(Vector(3456, -13254, 145+Winterblight.ZFLOAT), 4, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 6 then
			Winterblight:CreatePlatformBeacon(Vector(4480, -11219, 145+Winterblight.ZFLOAT), 8, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 7 then
			Winterblight:CreatePlatformBeacon(Vector(5504, -13167, 145+Winterblight.ZFLOAT), 2, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 8 then
			Winterblight:CreatePlatformBeacon(Vector(6327, -12416, 145+Winterblight.ZFLOAT), 9, Winterblight.AzaleaPlatformsState)
			Winterblight:AzaleaLastPlatformRaised()
		end		
	elseif Winterblight.AzaleaPlatformsOrder == 3 then
		if Winterblight.AzaleaPlatformsState == 1 then
			Winterblight:CreatePlatformBeacon(Vector(5307, -11524, 145+Winterblight.ZFLOAT), 4, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 2 then
			Winterblight:CreatePlatformBeacon(Vector(3642, -11467, 145+Winterblight.ZFLOAT), 6, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 3 then
			-- SHOULD BE ON TOP OF PREVIOUS INDEX, RAISES INDEX IN HERE
			Winterblight:CreatePlatformBeacon(Vector(1724, -11072, 145+Winterblight.ZFLOAT), 7, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 4 then
			Winterblight:CreatePlatformBeacon(Vector(2587, -12991, 145+Winterblight.ZFLOAT), 5, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 5 then
			Winterblight:CreatePlatformBeacon(Vector(4480, -10084, 145+Winterblight.ZFLOAT), 2, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 6 then
			Winterblight:CreatePlatformBeacon(Vector(6327, -11776, 145+Winterblight.ZFLOAT), 8, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 7 then
			Winterblight:CreatePlatformBeacon(Vector(5248, -13167, 145+Winterblight.ZFLOAT), 3, Winterblight.AzaleaPlatformsState)
		elseif Winterblight.AzaleaPlatformsState == 8 then
			Winterblight:CreatePlatformBeacon(Vector(4656, -12544, 145+Winterblight.ZFLOAT), 9, Winterblight.AzaleaPlatformsState)
			Winterblight:AzaleaLastPlatformRaised()
		end		
	end
end

function Winterblight:AzaleaLastPlatformRaised()
end

function Winterblight:CreatePlatformBeacon(position, platform_index, state)
	position=position+Vector(0,0,280)
    local beacon = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)

    local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/azalea_platform_trigger_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, position)
    ParticleManager:SetParticleControl(pfx, 2, position)
    ParticleManager:SetParticleControl(pfx, 3, position)
    beacon.pfx = pfx
    beacon.order_index = state
    beacon.index = platform_index
    beacon:AddAbility("winterblight_beacon_passive"):SetLevel(1)
    beacon:FindAbilityByName("dummy_unit"):SetLevel(1)
end

function Winterblight:ActivateAzaleaBeacon(beacon)
	local platform = Winterblight.AzaleaPlatformsTable[beacon.index]
	if not platform.raised then
		platform.raised = true
		Winterblight:AzaleaPlatformSpawns(beacon.index)
		ParticleManager:DestroyParticle(beacon.pfx, false)
		for i = 1, 150, 1 do
			Timers:CreateTimer(i*0.03, function()
				platform.main:SetAbsOrigin(platform.main:GetAbsOrigin()+Vector(0,0,2000/150))
				platform.borders:SetAbsOrigin(platform.borders:GetAbsOrigin()+Vector(0,0,2000/150))
			end)
		end
		Timers:CreateTimer(4.4, function()
			EmitSoundOnLocationWithCaster(platform.main:GetAbsOrigin(), "Winterblight.Platform.Lifted", Winterblight.Master)
			for j = 1, #platform.blockers, 1 do
				UTIL_Remove(platform.blockers[j])
			end
			Winterblight:CreateBeacons2to9()
		end)
	    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )

	    ParticleManager:SetParticleControl( particle1, 0, beacon:GetAbsOrigin() )
	    ParticleManager:SetParticleControl( particle1, 1, Vector(300, 2, 1000) )
	    ParticleManager:SetParticleControl( particle1, 3, Vector(300, 550, 550) )
	    Timers:CreateTimer(4, function()
	    	ParticleManager:DestroyParticle(particle1, false)
	    end)
	    EmitSoundOn("Winterblight.AzaleaBeacon.Activate", beacon)
	    UTIL_Remove(beacon)
	end
end

function Winterblight:AzaleaPlatformSpawns(index)
	local luck = RandomInt(1, 3)
	local unitTable = {}
	local positionTable = {}
	if index == 1 then
		if luck == 1 then
			positionTable = {Vector(5307, -11904), Vector(5307, -11520), Vector(5307, -11136), Vector(5307, -10752)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnColdSeer(positionTable[i], Vector(0,1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 2 then
			positionTable = {Vector(5307, -11392), Vector(5307, -11008), Vector(5307, -11776)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnArmoredKnight(positionTable[i], Vector(1,0))
				table.insert(unitTable, spawn)
			end
		elseif luck == 3 then
			positionTable = {Vector(5307, -11392), Vector(5307, -11008), Vector(5307, -11776)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(0,1))
				table.insert(unitTable, spawn)
			end
		end
	elseif index == 2 then
		if luck == 1 then
			positionTable = {Vector(5693, -11904), Vector(5951, -11904)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnSyphist(positionTable[i], Vector(-1,0))
				table.insert(unitTable, spawn)
			end
		elseif luck == 2 then
			positionTable = {Vector(6328, -12416), Vector(6327, -12160), Vector(6327, -11904)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnAzaleaMaiden(positionTable[i], Vector(-1,0))
				table.insert(unitTable, spawn)
			end
		elseif luck == 3 then
			positionTable = {Vector(5693, -11904), Vector(5951, -11904), Vector(6328, -12416), Vector(6327, -12160), Vector(6327, -11904)}
			for i = 1, #positionTable, 1 do
				if i <= 3 then
					local spawn = Winterblight:SpawnAzaleaMindbreaker(positionTable[i], Vector(-1,0))
					table.insert(unitTable, spawn)
				else
					local spawn = Winterblight:SpawnAzaleaArcher(positionTable[i], Vector(-1,0))
					table.insert(unitTable, spawn)
				end
			end
		end
	elseif index == 3 then
		if luck == 1 then
			positionTable = {Vector(4279, -12544), Vector(4656, -12544), Vector(5033, -12544)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnColdSeer(positionTable[i], Vector(1,0))
				table.insert(unitTable, spawn)
			end
		elseif luck == 2 then
			positionTable = {Vector(4379, -12544), Vector(4756, -12544), Vector(5133, -12544), Vector(3900, -12263), Vector(3900, -11874)}
			for i = 1, #positionTable, 1 do
				if i <=3 then
					local spawn = Winterblight:SpawnPriestOfAzalea(positionTable[i], Vector(1,0))
					table.insert(unitTable, spawn)
				else
					local spawn = Winterblight:SpawnFrostAvatar(positionTable[i], Vector(1,0))
					table.insert(unitTable, spawn)
				end
			end
		elseif luck == 3 then
			positionTable = {Vector(5307, -12288), Vector(5307, -12544), Vector(4911, -12544), Vector(4534, -12544), Vector(4279, -12544), Vector(4047, -12544), Vector(3968, -12263), Vector(3968, -12052), Vector(3968, -11900)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(0,1))
				table.insert(unitTable, spawn)
			end
		end
	elseif index == 4 then
		if luck == 1 then
			positionTable = {Vector(4782, -11467), Vector(4280, -11467), Vector(3768, -11467), Vector(4480, -11042), Vector(4480, -10549)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnSyphist(positionTable[i], Vector(0,-1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 2 then
			positionTable = {Vector(4782, -11467), Vector(4280, -11467), Vector(3768, -11467), Vector(4480, -11042), Vector(4480, -10549)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnSourceRevenant(positionTable[i], Vector(0,-1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 3 then
			positionTable = {Vector(4782, -11467), Vector(4280, -11467), Vector(3768, -11467), Vector(4480, -11042), Vector(4480, -10549)}
			for i = 1, #positionTable, 1 do
				if i <= 3 then
					local spawn = Winterblight:SpawnArmoredKnight(positionTable[i], Vector(1,0))
					table.insert(unitTable, spawn)
				else
					local spawn = Winterblight:SpawnRiderOfAzalea(positionTable[i], Vector(1,0))
					table.insert(unitTable, spawn)
				end
			end
		end
	elseif index == 5 then
		if luck == 1 then
			positionTable = {Vector(4905, -10077), Vector(4524, -10077), Vector(4034, -10077), Vector(3652, -10077), Vector(3263, -10077), Vector(2762, -10077), Vector(2763, -10453), Vector(2762, -10688), Vector(2375, -10688), Vector(1960, -10688)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnRiderOfAzalea(positionTable[i], Vector(0,-1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 2 then
			positionTable = {Vector(4905, -10077), Vector(4524, -10077), Vector(4034, -10077), Vector(3652, -10077), Vector(3263, -10077), Vector(2762, -10077), Vector(2763, -10453), Vector(2762, -10688), Vector(2375, -10688), Vector(1960, -10688)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(0,-1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 3 then
			positionTable = {Vector(4905, -10077), Vector(4524, -10077), Vector(4034, -10077), Vector(3652, -10077), Vector(3263, -10077), Vector(2762, -10077), Vector(2763, -10453), Vector(2762, -10688), Vector(2375, -10688), Vector(1960, -10688)}
			for i = 1, #positionTable, 1 do
				if i <= 3 then
					local spawn = Winterblight:SpawnAzaleaMaiden(positionTable[i], Vector(1,0))
					table.insert(unitTable, spawn)
				else
					local spawn = Winterblight:SpawnGhostStriker(positionTable[i], Vector(1,0))
					table.insert(unitTable, spawn)
				end
			end
		end
	elseif index == 6 then
		if luck == 1 then
			positionTable = {Vector(2987, -11467), Vector(2596, -11467), Vector(2225, -11467), Vector(1723, -11467), Vector(1723, -11467)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnSecretKeeper(positionTable[i], Vector(1,0))
				table.insert(unitTable, spawn)
			end
		elseif luck == 2 then
			positionTable = {Vector(2987, -11467), Vector(2596, -11467), Vector(2225, -11467), Vector(1723, -11467), Vector(1723, -11467), Vector(1454, -11467)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnFrostElemental(positionTable[i], Vector(0,-1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 3 then
			positionTable = {Vector(2987, -11467), Vector(2596, -11467), Vector(2225, -11467), Vector(1723, -11467), Vector(1723, -11467), Vector(1454, -11467)}
			for i = 1, #positionTable, 1 do
				if i <= 3 then
					local spawn = Winterblight:SpawnArmoredKnight(positionTable[i], Vector(1,0))
					table.insert(unitTable, spawn)
				else
					local spawn = Winterblight:SpawnRiderOfAzalea(positionTable[i], Vector(1,0))
					table.insert(unitTable, spawn)
				end
			end
		end
	elseif index == 7 then
		if luck == 1 then
			positionTable = {Vector(2550, -11849), Vector(2550, -12083), Vector(2550, -12511), Vector(2550, -12990), Vector(2944, -12990), Vector(3400, -12990), Vector(3456, -13254)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnFrostAvatar(positionTable[i], Vector(0,1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 2 then
			positionTable = {Vector(2550, -11849), Vector(2550, -12083), Vector(2550, -12511), Vector(2550, -12990), Vector(2944, -12990), Vector(3400, -12990), Vector(3456, -13254)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(0,1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 3 then
			positionTable = {Vector(2550, -11849), Vector(2550, -12083), Vector(2550, -12511), Vector(2550, -12990), Vector(2944, -12990), Vector(3400, -12990), Vector(3456, -13254)}
			for i = 1, #positionTable, 1 do
				if i <= 2 then
					local spawn = Winterblight:SpawnWinterAssasin(positionTable[i], Vector(0,1))
					table.insert(unitTable, spawn)
				else
					local spawn = Winterblight:SpawnSourceRevenant(positionTable[i], Vector(-1,0))
					table.insert(unitTable, spawn)
				end
			end
		end
	elseif index == 8 then
		if luck == 1 then
			positionTable = {Vector(3968, -13166), Vector(4352, -13166), Vector(4736, -13166), Vector(5120, -13166), Vector(5760, -13166), Vector(6016, -13166), Vector(6016, -12928), Vector(5760, -12928)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnFrostiok(positionTable[i], Vector(0,1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 2 then
			positionTable = {Vector(3968, -13166), Vector(4352, -13166), Vector(4736, -13166), Vector(5120, -13166), Vector(5760, -13166), Vector(6016, -13166), Vector(6016, -12928), Vector(5760, -12928)}
			for i = 1, #positionTable, 1 do
				local spawn = Winterblight:SpawnRiderOfAzalea(positionTable[i], Vector(0,1))
				table.insert(unitTable, spawn)
			end
		elseif luck == 3 then
			positionTable = {Vector(3968, -13166), Vector(4352, -13166), Vector(4736, -13166), Vector(5120, -13166), Vector(5760, -13166), Vector(6016, -13166), Vector(6016, -12928), Vector(5760, -12928)}
			for i = 1, #positionTable, 1 do
				if i <= 3 then
					local spawn = Winterblight:SpawnChillingColossus(positionTable[i], Vector(0,1))
					table.insert(unitTable, spawn)
				else
					local spawn = Winterblight:SpawnAzaleaArcher(positionTable[i], Vector(-1,0))
					table.insert(unitTable, spawn)
				end
			end
		end
	elseif index == 9 then
		local spawn = Winterblight:SpawnCruxal(Vector(175, -11520), Vector(-1,0))
		positionTable = {Vector(175, -11520)}
		table.insert(unitTable, spawn)
		for j = 0, 6, 1 do
			local vecAdd = Vector(-562, -12160+j*300)
			table.insert(positionTable, vecAdd)
		end
		for i = 0, 6, 1 do
			local spawn = Winterblight:SpawnFrostElemental(Vector(-562, -12160+i*300), Vector(0,1))
			table.insert(unitTable, spawn)
		end
	end
	for i = 1, #unitTable, 1 do
		local unit = unitTable[i]
		unit:SetAbsOrigin(positionTable[i]+Vector(0,0,-1600))
		Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_disable_player", {duration = 4})
	end
	for i = 1, 150, 1 do
		Timers:CreateTimer(i*0.03, function()
			for j = 1, #unitTable, 1 do
				local unit = unitTable[j]
				unit:SetAbsOrigin(unit:GetAbsOrigin()+Vector(0,0,2000/150))
			end
		end)
	end
end

function Winterblight:AzaleaPlatformPitSpawn(spawnIndex)
	print("PLATFORM SPAWN")
	print(spawnIndex)
	if spawnIndex == 1 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck == 1 then
			for i = 1, 4, 1 do
				local pos = Vector(5702, -11486+(i-1)*200)+RandomVector(RandomInt(0, 40))
				table.insert(positionTable, pos)
			end
		elseif luck == 2 then
			positionTable = {Vector(4864, -11776), Vector(4864, -12026), Vector(4608, -12027), Vector(4714, -12216)}
		end
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
			end
		end
	elseif spawnIndex == 2 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck == 1 then
			positionTable = {Vector(6159, -11398), Vector(5888, -11504), Vector(5633, -11520)}
		elseif luck == 2 then
			positionTable = {Vector(5633, -12203), Vector(5768, -12453), Vector(5906, -12284)}
		end
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
			end
		end
	elseif spawnIndex == 3 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck == 1 then
			for i = 0, 4, 1 do
				local pos = Vector(4518+i*200, -12864)+RandomVector(RandomInt(0, 40))
				table.insert(positionTable, pos)
			end
		elseif luck == 2 then
			positionTable = {Vector(4736, -11968), Vector(4992, -12034), Vector(4806, -12215)}
		end
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
			end
		end
	elseif spawnIndex == 4 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck == 1 then
			positionTable = {Vector(4224, -12232), Vector(4385, -12160)}
		elseif luck == 2 then
			positionTable = {Vector(3893, -12881), Vector(4130, -12881), Vector(4385, -12882)}
		end
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
			end
		end
	elseif spawnIndex == 5 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck == 1 then
			positionTable = {Vector(4608, -11797), Vector(4352, -11904)}
		elseif luck == 2 then
			positionTable = {Vector(3422, -11835), Vector(3626, -11835), Vector(3626, -12074)}
		end
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
			end
		end
	elseif spawnIndex == 6 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck == 1 then
			for i = -3, 3, 1 do
				local pos = Vector(3636, -10825)+WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/7)*380
				table.insert(positionTable, pos)
			end
		elseif luck == 2 then
			for i = 0, 2, 1 do
				for j = 0, 2, 1 do
					local pos = Vector(3168, -11114)+Vector(i*470, j*360)
					table.insert(positionTable, pos)
				end
			end
		end
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
			end
		end
	elseif spawnIndex == 7 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck == 1 then
			positionTable = {Vector(768, -11059), Vector(1044, -11059), Vector(1323, -11059)}
		elseif luck == 2 then
			positionTable = {Vector(2048, -11059), Vector(2348, -11059), Vector(2658, -11059)}
		end
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
			end
		end
	elseif spawnIndex == 8 then
		local positionTable = {}
		positionTable = {Vector(2048, -11059), Vector(2348, -11059), Vector(2658, -11059), Vector(3200, -11776), Vector(3014, -12032), Vector(2855, -11776), Vector(2167, -11776), Vector(2048, -12032), Vector(1792, -11776)}
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				local luck = RandomInt(1, 3)
				if luck < 3 then
					Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
				end
			end
		end
	elseif spawnIndex == 9 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck < 3 then
			for i = 0, 2, 1 do
				for j = 0, 2, 1 do
					local pos = Vector(2944, -12544)+Vector(i*270, j*260)
					table.insert(positionTable, pos)
				end
			end
			if #positionTable > 0 then
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
				end
			end
		end
	elseif spawnIndex == 10 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck < 3 then
			for i = 0, 4, 1 do
				local pos = Vector(4244+i*256, -12857)
				table.insert(positionTable, pos)
			end
			if #positionTable > 0 then
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
				end
			end
		end
	elseif spawnIndex == 11 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck == 1 then
			positionTable = {Vector(1536, -12288), Vector(1724, -12072), Vector(1733, -11825), Vector(1536, -11936)}
		elseif luck == 2 then
			positionTable = {Vector(568, -11882), Vector(828, -11882), Vector(704, -11669)}
		end
		if #positionTable > 0 then
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
			end
		end
	elseif spawnIndex == 12 then
		local positionTable = {}
		local luck = RandomInt(1, 3)
		if luck < 3 then
			for i = 0, 4, 1 do
				local pos = Vector(-76+i*256, -11042)
				table.insert(positionTable, pos)
			end
			if #positionTable > 0 then
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAirSpirit(positionTable[i], RandomVector(1))
				end
			end
		end
	end
end

function Winterblight:SpawnAirSpirit(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_air_spirit", position, 0, 1, nil, fv, false)
	Events:AdjustBossPower(stone, 4, 3, false)
	stone.itemLevel = 42
	stone.dominion = true
	stone:SetRenderColor(82, 150, 255)
	stone:SetAbsOrigin(stone:GetAbsOrigin()-Vector(0,0,500))
	stoneAbility = stone:FindAbilityByName("wind_temple_wind_guardian_ai")
	stoneAbility:ApplyDataDrivenModifier(stone, stone, "modifier_wind_guardian_entrance", {duration = 2.7})
	stone.dominion = true
	for i = 1, 90, 1 do
		Timers:CreateTimer(0.03*i, function()
			stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,math.abs(math.sin(i)*10)))
		end)
	end
	Winterblight:SetPositionCastArgs(stone, 1000, 0, 3, FIND_ANY_ORDER)
	Timers:CreateTimer(3, function()
		if not stone.aggro then
			Dungeons:AggroUnit(stone)
		end
	end)
	return stone
end

function Winterblight:SpawnCruxal(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_frost_cruxal", position, 6, 10, "Winterblight.Cruxal.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 52
	stone:SetRenderColor(82, 150, 255)
	if Winterblight.Stones >= 1 then
		stone:AddAbility("fire_temple_frenzy"):SetLevel(GameState:GetDifficultyFactor())
	end
	if Winterblight.Stones >= 2 then
		stone:FindAbilityByName("cruxal_ice_blast"):SetLevel(4)
	end
	if Winterblight.Stones >= 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:InitAzaleaMazeRoom()
	if not Winterblight.AzaleaMazeRoomSpawned then
		Winterblight.AzaleaMazeRoomSpawned = true
		local ghostPositionTable = {Vector(-2560, -10368), Vector(-3584, -15872), Vector(-2944, -15232), Vector(-3840, -14848), Vector(-2984, -14464), Vector(-2588, -13440), Vector(-3840, -12800), Vector(-2688, -12416), Vector(-3328, -13824), Vector(-2944, -11776), Vector(-3584, -11103), Vector(-2304, -11104), Vector(-2912, -10368)}
		local mazeGhost = CreateUnitByName("azalea_maze_ghost", ghostPositionTable[RandomInt(1, #ghostPositionTable)]+RandomVector(150), false, nil, nil, DOTA_TEAM_NEUTRALS)
		mazeGhost.food = 0
		FindClearSpaceForUnit(mazeGhost, mazeGhost:GetAbsOrigin(), false)
		local positionTable = {Vector(-3840, -15250), Vector(-3840, -14750), Vector(-3840, -14250), Vector(-3840, -13750), Vector(-3840, -13250), Vector(-3840, -12750), Vector(-3840, -12250), Vector(-3840, -11750), Vector(-3840, -11250), Vector(-3840, -10750), Vector(-3840, -15872), Vector(-3262, -15872), Vector(-2729, -15872), Vector(-2729, -15184), Vector(-3268, -15184), Vector(-3269, -14485), Vector(-2729, -14485), Vector(-2729, -13848), Vector(-2729, -13105), Vector(-3251, -13105), Vector(-3251, -12480), Vector(-2729, -12480), Vector(-3277, -11787), Vector(-2586, -11787), Vector(-1930, -11787), Vector(-1930, -11126), Vector(-2612, -11126), Vector(-3297, -11126), Vector(-3297, -10372), Vector(-2582, -10372), Vector(-1934, -10372), Vector(-5969, -15990), Vector(-5969, -15408), Vector(-5285, -15990), Vector(-5285, -15408), Vector(-4608, -15990), Vector(-4608, -15408)}
		positionTable = WallPhysics:ShuffleTable(positionTable)
		print("YOUR NUMBER SIR:")
		print(#positionTable)
		mazeGhost.goalFood = 21
		mazeGhost.jumpLock = true
		mazeGhost.pushLock = true
		Winterblight.foodTable = {}
		-- Winterblight.positionSpawnTables = {{}, {}, {}}
		-- for i = 1, 10, 1 do
		-- 	table.insert(Winterblight.positionSpawnTables[1], positionTable[i])
		-- end
		local crystalPositions = WallPhysics:ShuffleTable(ghostPositionTable)
		for i = 1, 3, 1 do
			Winterblight:SpawnMazeFoodCrystal(crystalPositions[i], i, positionTable)
		end
		local luck = RandomInt(1, 3)
		if luck == 1 then
			Winterblight:SpawnDemonSpirit(Vector(-1951, -10467), Vector(0,-1))
			Winterblight:SpawnDemonSpirit(Vector(-1951, -11827), Vector(0,1))
			Timers:CreateTimer(0.2, function()
				local positionTable = {Vector(-2646, -11136), Vector(-2646, -11520), Vector(-2646, -11904)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnBladeWielder(positionTable[i], Vector(1,0))
				end
			end)
			Timers:CreateTimer(0.5, function()
				Winterblight:SpawnChillingColossus(Vector(-2950, -11811), Vector(1,0))
				Winterblight:SpawnShineMegmus(Vector(-3303, -11136), Vector(0,-1))
				Winterblight:SpawnShineMegmus(Vector(-3303, -11811), Vector(1,0))
			end)
			Timers:CreateTimer(0.7, function()
				local positionTable = {Vector(-3909, -11893), Vector(-3909, -11392), Vector(-3909, -10880), Vector(-3909, -10368)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnFrostAvatar(positionTable[i], Vector(0,-1))
				end
				Winterblight:SpawnDemonSpirit(Vector(-2996, -10368), Vector(-1,0))
			end)
			Timers:CreateTimer(0.8, function()
				local positionTable = {Vector(-3840, -12416), Vector(-3328, -12416), Vector(-3328, -12800), Vector(-3328, -13184), Vector(-2825, -13184)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnCrystalRunner(positionTable[i], Vector(0,1))
				end
				Winterblight:SpawnChillingColossus(Vector(-2746, -12447), Vector(0,-1))
			end)
			Timers:CreateTimer(1.0, function()
				local positionTable = {Vector(-3840, -14464), Vector(-3328, -14464), Vector(-2816, -14464)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnShineMegmus(positionTable[i], Vector(-1,0))
				end
				Winterblight:SpawnDemonSpirit(Vector(-2688, -13824), Vector(0,1))
			end)
			Timers:CreateTimer(1.2, function()
				local positionTable = {Vector(-3904, -13824), Vector(-3584, -13824), Vector(-3258, -13824)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnArmoredKnight(positionTable[i], Vector(0,1))
				end
			end)
			Timers:CreateTimer(1.5, function()
				local positionTable = {Vector(-5405, -15616), Vector(-5237, -15321), Vector(-4736, -15451), Vector(-4352, -15300), Vector(-3976, -15301)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnBladeWielder(positionTable[i], Vector(1,0))
				end
			end)
			Timers:CreateTimer(2.0, function()
				local positionTable = {Vector(-4736, -15843), Vector(-4352, -15843), Vector(-3968, -15843), Vector(-3584, -15843), Vector(-3200, -15843), Vector(-2816, -15843)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnShineMegmus(positionTable[i], Vector(1,0))
				end
			end)
			Timers:CreateTimer(2.2, function()
				Winterblight:SpawnDemonSpirit(Vector(-3328, -15206), Vector(0,1))
				Winterblight:SpawnDemonSpirit(Vector(-2777, -15206), Vector(0,1))
			end)
			Timers:CreateTimer(2.6, function()
				local positionTable = {Vector(-5269, -15942), Vector(-5632, -15941), Vector(-6016, -15933)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnSyphist(positionTable[i], Vector(0,1))
				end
			end)
			Timers:CreateTimer(3.0, function()
				for i = 0, 2, 1 do
					for j = 0, 2, 1 do
						Winterblight:SpawnColdSeer(Vector(-7040+i*256, -16000+j*256), Vector(1,0))
					end
				end
			end)
			Timers:CreateTimer(3.3, function()
				local positionTable = {Vector(-7618, -15232), Vector(-7878, -15488), Vector(-7987, -15872)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnFrostHulk(positionTable[i], RandomVector(1))
				end
			end)
		elseif luck == 2 then
			Timers:CreateTimer(0.1, function()
				local positionTable = {Vector(-1962, -12032), Vector(-1962, -11520), Vector(-1962, -11008), Vector(-1962, -10496)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnShineMegmus(positionTable[i], Vector(0,-1))
				end
			end)		
			Timers:CreateTimer(0.2, function()
				Winterblight:SpawnDemonSpirit(Vector(-3328, -11510), Vector(0,-1))
				Winterblight:SpawnDemonSpirit(Vector(-2679, -11510), Vector(0,1))
				Winterblight:SpawnChillingColossus(Vector(-2679, -11149), Vector(1,0))
			end)
			Timers:CreateTimer(0.5, function()
				local positionTable = {Vector(-3865, -10425), Vector(-3456, -10425), Vector(-3072, -10425), Vector(-2688, -10425)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnBladeWielder(positionTable[i], Vector(-1,0))
				end
			end)
			Timers:CreateTimer(0.9, function()
				local positionTable = {Vector(-3880, -11112), Vector(-3880, -11763), Vector(-3880, -12416), Vector(-3328, -12416)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnShineMegmus(positionTable[i], Vector(0,1))
				end
				Winterblight:SpawnGhostStriker(Vector(-2704, -13844), Vector(0,1))
				Winterblight:SpawnGhostStriker(Vector(-2704, -13568), Vector(0,1))
			end)	
			Timers:CreateTimer(1.1, function()
				local positionTable = {Vector(-3328, -13056), Vector(-2688, -13056)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnDemonSpirit(positionTable[i], Vector(0,1))
				end
			end)
			Timers:CreateTimer(1.3, function()
				local positionTable = {Vector(-3200, -13824), Vector(-3514, -13824), Vector(-3892, -13824), Vector(-3892, -14208), Vector(-3892, -14548), Vector()}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAzaleaHighguard(positionTable[i], Vector(0,1))
				end
			end)
			Timers:CreateTimer(1.5, function()
				local positionTable = {Vector(-3509, -14548), Vector(-3072, -14548), Vector(-2688, -14548)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnSoftwalker(positionTable[i], Vector(0,1))
				end
			end)	
			Timers:CreateTimer(1.7, function()
				local positionTable = {Vector(-3200, -15087), Vector(-3200, -15360), Vector(-2816, -15360), Vector(-2814, -15087)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnBladeWielder(positionTable[i], Vector(0,1))
				end
			end)	
			Timers:CreateTimer(1.5, function()
				local positionTable = {Vector(-4224, -15840), Vector(-3584, -15840), Vector(-2814, -15840)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnDemonSpirit(positionTable[i], Vector(0,1))
				end
			end)	
			Timers:CreateTimer(1.9, function()
				local positionTable = {Vector(-5378, -15360), Vector(-4994, -15360), Vector(-4534, -15360), Vector(-4589, -15682), Vector(-4589, -16000)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnArmoredKnight(positionTable[i], Vector(0,1))
				end
			end)	
			Timers:CreateTimer(2.1, function()
				local positionTable = {Vector(-6018, -16000), Vector(-6018, -15676), Vector(-6018, -15293)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnFrostHulk(positionTable[i], Vector(0,-1))
				end
			end)		
			Timers:CreateTimer(3.1, function()
				local positionTable = {Vector(-6577, -15956), Vector(-7037, -15951), Vector(-6806, -15744), Vector(-6577, -15488)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAzaleaSorceress(positionTable[i], Vector(0,-1))
				end
			end)
			Timers:CreateTimer(3.5, function()
				local positionTable = {Vector(-8092, -15539), Vector(-7680, -15392)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnDemonSpirit(positionTable[i], Vector(1,0))
				end
				Winterblight:SpawnChillingColossus(Vector(-8064, -16000), Vector(0,1))
			end)	
		elseif luck == 3 then
			Timers:CreateTimer(0.1, function()
				Winterblight:SpawnGhostStriker(Vector(-1978, -10368), Vector(0,-1))
				Winterblight:SpawnGhostStriker(Vector(-1978, -10752), Vector(0,-1))
				Winterblight:SpawnGhostStriker(Vector(-1978, -11648), Vector(0,1))
				Winterblight:SpawnGhostStriker(Vector(-1978, -12032), Vector(0,1))
			end)
			Timers:CreateTimer(0.3, function()
				local positionTable = {Vector(-2689, -11802), Vector(-2668, -11417), Vector(-2688, -11008)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnDemonSpirit(positionTable[i], Vector(1,0))
				end
			end)	
			Timers:CreateTimer(0.5, function()
				local positionTable = {Vector(-3276, -11846), Vector(-3276, -11484), Vector(-3392, -11136), Vector(-3903, -11136), Vector(-3903, -11520), Vector(3903, -10752)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnShineMegmus(positionTable[i], Vector(1,0))
				end
			end)	
			Timers:CreateTimer(0.8, function()
				local positionTable = {Vector(-3902, -10410), Vector(-3456, -10411), Vector(-2984, -10410)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnArmoredKnight(positionTable[i], Vector(-1,0))
				end
			end)	
			Timers:CreateTimer(1.0, function()
				local positionTable = {Vector(-3069, -13115), Vector(-3385, -13115), Vector(-3294, -12719), Vector(-3200, -12416), Vector(-3512, -12416), Vector(-3840, -12416)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnBladeWielder(positionTable[i], Vector(1,0))
				end
			end)		
			Timers:CreateTimer(1.2, function()
				local positionTable = {Vector(-3840, -13824), Vector(-3536, -13824), Vector(-3232, -13824)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAzaleaMaiden(positionTable[i], Vector(1,0))
				end
			end)	
			Timers:CreateTimer(1.5, function()
				local positionTable = {Vector(-3890, -14080), Vector(-3897, -14486), Vector(-3328, -14486), Vector(-2816, -14486)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnAzaleaArcher(positionTable[i], Vector(1,0))
				end
			end)	
			Timers:CreateTimer(1.8, function()
				local positionTable = {Vector(-3328, -15232), Vector(-2739, -15232)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnDemonSpirit(positionTable[i], Vector(0,1))
				end
				for i = 0, 4, 1 do
					Winterblight:SpawnSecretKeeper(Vector(-4408+i*420, -15870), Vector(0,1))
				end
			end)	
			Timers:CreateTimer(2, function()
				for i = 0, 1, 1 do
					for j = 0, 1, 1 do
						local pos = Vector(-4792+i*256, -15872+j*256)
						Winterblight:SpawnShineMegmus(pos, Vector(1,0))
					end
				end
			end)	
			Timers:CreateTimer(2.2, function()
				local positionTable = {Vector(-5376, -15486), Vector(-5376, -15872)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnDemonSpirit(positionTable[i], Vector(0,1))
				end
			end)	
			Timers:CreateTimer(2.4, function()
				local positionTable = {Vector(-5974, -15872), Vector(-5974, -15421), Vector(-6400, -15421)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnBladeWielder(positionTable[i], Vector(0,1))
				end
				Winterblight:SpawnChillingColossus(Vector(-3968, -15307), Vector(0,1))
			end)	
			Timers:CreateTimer(3.0, function()
				for i = 0, 1, 1 do
					for j = 0, 2, 1 do
						local pos = Vector(-6949+i*256, -15911+j*200)
						Winterblight:SpawnArmoredKnight(pos, Vector(1,0))
					end
				end
			end)	
			Timers:CreateTimer(1.9, function()
				Winterblight:SpawnColdSeer(Vector(-2727, -13824), Vector(0,1))
				Winterblight:SpawnColdSeer(Vector(-2727, -13450), Vector(0,1))
				Winterblight:SpawnColdSeer(Vector(-2727, -13150), Vector(0,1))
				Winterblight:SpawnColdSeer(Vector(-2727, -12870), Vector(0,1))
			end)
			Timers:CreateTimer(3.3, function()
				Winterblight:SpawnCrystalRunner(Vector(-7661, -15232), Vector(-0.5, -1))
				Winterblight:SpawnCrystalRunner(Vector(-7552, -15468), Vector(-0.5, -0.4))
				Winterblight:SpawnCrystalRunner(Vector(-8064, -16000), Vector(1, 0.4))
				Winterblight:SpawnCrystalRunner(Vector(-8129, -15744), Vector(1, 0.1))
				Winterblight:SpawnCrystalRunner(Vector(-8190, -15435), Vector(1, -0.5))
				Winterblight:SpawnDemonSpirit(Vector(-3881, -13184), Vector(0,1))
			end)	
		end
		local luck2 = RandomInt(1, 3)
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(-1898, -11904), Vector(-3840, -12416), Vector(-3180, -14505), Vector(-5376, -15872)}
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
		          	if luck2 == 1 then
			            local elemental = Winterblight:SpawnColdSeer(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 25, 10, 220, patrolPositionTable)
			        elseif luck2 == 2 then
			            local elemental = Winterblight:SpawnPriestOfAzalea(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 25, 10, 220, patrolPositionTable)
			        elseif luck2 == 3 then
			            local elemental = Winterblight:SpawnAzaleaHighguard(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
			            Winterblight:AddPatrolArguments(elemental, 25, 10, 220, patrolPositionTable)
			        end
		          end)
		        end
		      end)
		    end
		end)
		if GameState:GetDifficultyFactor() >= 3 then
			local luck3 = RandomInt(4+GameState:GetPlayerPremiumStatusCount(), 100)
			if luck3 == 100 then
				local boss = Winterblight:SpawnAzheran(ghostPositionTable[RandomInt(1, #ghostPositionTable)]+RandomVector(150), RandomVector(1))
				AddFOWViewer(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), 10000, 10000, false)
				local patPos1 = ghostPositionTable[RandomInt(1, #ghostPositionTable)]+RandomVector(150)
				local patPos2 = ghostPositionTable[RandomInt(1, #ghostPositionTable)]+RandomVector(150)
				local patPos3 = boss:GetAbsOrigin()
				local patrolPositionTable = {patPos1, patPos2, patPos3}
				Winterblight:AddPatrolArguments(boss, 25, 8, 220, patrolPositionTable)
			end
		end
	end
end

function Winterblight:SpawnMazeFood(position)
	local mazeFood = CreateUnitByName("azalea_maze_food", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	mazeFood:SetAbsOrigin(GetGroundPosition(position, mazeFood))
	local pfx = ParticleManager:CreateParticle( "particles/econ/items/wisp/wisp_ambient_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt(pfx, 0, mazeFood, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", mazeFood:GetAbsOrigin(), true)
	mazeFood.pfx1 = pfx
	local pfx2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_ambient.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(pfx2, 0, mazeFood:GetAbsOrigin()+Vector(0,0,100))
	mazeFood.pfx2 = pfx2
	table.insert(Winterblight.foodTable, mazeFood)
	-- mazeFood:SetRenderColor(100, 150, 255)
end

function Winterblight:SpawnDemonSpirit(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_demon_spirit", position, 1, 1, "Winterblight.DemonSpirit.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 3, false)
	stone.itemLevel = 44
	stone.dominion = true
	stone.targetRadius = 1200
	stone.autoAbilityCD = 1
	return stone
end

function Winterblight:SpawnBladeWielder(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_bladewielder", position, 0, 1, "Winterblight.BladeWielder.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 44
	stone.dominion = true
	return stone
end

function Winterblight:SpawnMazeFoodCrystal(position, index, positionTable)
	local position = position + Vector(0, 0, 520+Winterblight.ZFLOAT)
    local crystal = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,50))
    local yaw = 345
    crystal:SetAngles(0, yaw, 0)

    crystal:SetModelScale(1.0)
    crystal:SetOriginalModel("models/winterblight/azalea_crystal.vmdl")
    crystal:SetModel("models/winterblight/azalea_crystal.vmdl")
    crystal:SetAbsOrigin(position)

    crystal:RemoveAbility("dummy_unit")
    crystal:RemoveModifierByName("dummy_unit")
    crystal.basePosition = position

    crystal.yaw = yaw
    crystal:AddAbility("winterblight_maze_food_crystal_ability"):SetLevel(1)
    crystal.pushLock = true
    crystal.dummy = true
    crystal.jumpLock = true

	crystal:SetRenderColor(80, 180, 255)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", crystal, 3)
    local loopStart = (index-1)*10 + 1
    local loopEnd = index*10
    crystal.foodPositionTable = {}
    for i = loopStart, loopEnd, 1 do
    	table.insert(crystal.foodPositionTable, positionTable[i])
    end
    AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 300, 6000, false)
end

function Winterblight:SpawnShineMegmus(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_shrine_megmus", position, 0, 1, "Winterblight.ShrineMegmus.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 4, false)
	stone.itemLevel = 44
	stone.dominion = true
	stone.targetRadius = 600
	stone.autoAbilityCD = 1
	if Winterblight.Stones >= 1 then
		stone:AddAbility("luna_taskmaster_shield"):SetLevel(GameState:GetDifficultyFactor())
	end
	if Winterblight.Stones >= 2 then
		stone:AddAbility("ability_magic_immune_break"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:SpawnRuptholdTheGlutton(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("rupthold_the_glutton", position, 5, 7, "Winterblight.Rupthold.Aggro", fv, true)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 44
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk_golem.vpcf", stone, 5)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", stone, 5)
	return stone
end

function Winterblight:SpawnRuptholdGhost(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("rupthold_ghost", position, 0, 1, "Winterblight.Rupthold.Ghost", fv, true)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 44
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", stone, 5)
	if Winterblight.Stones >= 2 then
		stone:AddAbility("fire_temple_steadfast"):SetLevel(GameState:GetDifficultyFactor())
	end
	if Winterblight.Stones >= 3 then
		stone:AddAbility("creature_pure_strike"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:SpawnBlueGargoyle(position, fv, caster, bAggro)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_blue_gargoyle", position, 0, 0, "Winterblight.Gargoyle.Summons", fv, bAggro)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 45
	stone.dominion = true
	Timers:CreateTimer(0.03, function()
		stone:SetOwner(caster)
		stone:SetTeam(caster:GetTeamNumber())
	end)
	return stone
end

function Winterblight:SpawnGraveSummoner(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_grave_summoner", position, 0, 2, "Winterblight.GraveSummoner.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 46
	stone.targetRadius = 1200
	stone.autoAbilityCD = 1
	stone.dominion = true
	stone.summons = 2
	stone.maxSummons = 2 + math.min(2, Winterblight.Stones)
	return stone
end

function Winterblight:AzaleaSummonerRoomInit()
	local luck = RandomInt(1, 3)
	if luck == 1 then
		Winterblight:SpawnGraveSummoner(Vector(-8746, -14433), Vector(1,0))
		Winterblight:SpawnGraveSummoner(Vector(-8746, -14080), Vector(1,0))
		Winterblight:SpawnGraveSummoner(Vector(-8746, -13696), Vector(1,0))
		Winterblight:SpawnGraveSummoner(Vector(-8095, -13744), Vector(0,-1))
		Winterblight:SpawnGraveSummoner(Vector(-7596, -13744), Vector(0,-1))
		Winterblight:SpawnDemonSpirit(Vector(-6656, -14720), Vector(-1,0))
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(-9216, -12416), Vector(-8704, -12416), Vector(-8192, -12416), Vector(-7680, -12416), Vector(-7168, -12416), Vector(-6656, -12416), Vector(-6144, -12416)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaDragoon(positionTable[i], Vector(0,-1))
			end
			local positionTable = {Vector(-6144, -12800), Vector(-6144, -13184), Vector(-6144, -13568)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaDragoon(positionTable[i], Vector(-1,0))
			end
		end)
		Timers:CreateTimer(1.0, function()
			for i = 0, 6, 1 do
				Winterblight:SpawnAzaleaArcher(Vector(-4662, -13575+i*240), Vector(-1,0))
			end
		end)
		Timers:CreateTimer(1.3, function()
			for i = 0, 3, 1 do
				for j = 0, 1, 1 do
					Winterblight:SpawnCrystalRunner(Vector(-8576+500*i, -13184+j*240), Vector(0,-1))
				end
			end
		end)
		Timers:CreateTimer(1.6, function()
			for i = 0, 5, 1 do
				Winterblight:SpawnArmoredKnight(Vector(-5079, -13737+i*260), Vector(-1,0))
			end
		end)
		Timers:CreateTimer(2.0, function()
			local positionTable = {Vector(-6968, -13894), Vector(-6712, -13894), Vector(-6969, -13638), Vector(-6713, -13638)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnBladeWielder(positionTable[i], Vector(-1,0))
			end
		end)
	elseif luck == 2 then
		Timers:CreateTimer(0.1, function()
			for i = 0, 4, 1 do
				for j = 0, 1, 1 do
					Winterblight:SpawnAzaleaDragoon(Vector(-8192+300*i, -13826+j*270), Vector(0,-1))
				end
			end
		end)
		Timers:CreateTimer(0.3, function()
			for i = 0, 3, 1 do
				Winterblight:SpawnDemonSpirit(Vector(-8783, -14491+i*300), Vector(1,0))
			end
		end)
		Timers:CreateTimer(0.5, function()
			for i = 0, 1, 1 do
				Winterblight:SpawnKnifeScraper(Vector(-7040+i*480, -14592), Vector(-1,0))
			end
			for i = 0, 3, 1 do
				Timers:CreateTimer(i*0.3, function()
					Winterblight:SpawnKnifeScraper(Vector(-5981+i*260, -14214), Vector(-1,0))
				end)
			end
		end)
		Timers:CreateTimer(0.5, function()
			for i = 0, 3, 1 do
				Winterblight:SpawnGraveSummoner(Vector(-5996, -13650+i*300), Vector(-1,0))
			end
		end)
		Timers:CreateTimer(1.2, function()
			for i = 0, 6, 1 do
				Winterblight:SpawnBladeWielder(Vector(-8965+i*300, -12441), Vector(0,-1))
			end
		end)
		Timers:CreateTimer(1.5, function()
			for i = 0, 3, 1 do
				Winterblight:SpawnWinterAssasin(Vector(-4661, -13824+i*240), Vector(-1,0))
			end
		end)
		Timers:CreateTimer(1.9, function()
			for i = 0, 5, 1 do
				Winterblight:SpawnSecretKeeper(Vector(-8320+i*300, -12928), Vector(0,-1))
			end
		end)
		Timers:CreateTimer(2.1, function()
			for i = 0, 4, 1 do
				Winterblight:SpawnAzaleaHighguard(Vector(-5079, -13537+i*260), Vector(-1,0))
			end
		end)
	elseif luck == 3 then
		Timers:CreateTimer(0.3, function()
			for i = 0, 12, 1 do
				local rotatedFV = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/24)
				Winterblight:SpawnKnifeScraper(Vector(-7296, -13696)+rotatedFV*1300, Vector(0,-1))
			end
			Timers:CreateTimer(0.5, function()
				for i = 0, 15, 1 do
					local rotatedFV = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/16)
					Winterblight:SpawnAzaleaDragoon(Vector(-7296, -13496)+rotatedFV*520, Vector(0,-1))
				end
			end)
			Timers:CreateTimer(0.65, function()
				for i = 0, 6, 1 do
					local rotatedFV = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/7)
					Winterblight:SpawnBladeWielder(Vector(-7296, -13496)+rotatedFV*240, Vector(0,-1))
				end
			end)
			Timers:CreateTimer(0.8, function()
				for i = 0, 5, 1 do
					Winterblight:SpawnGraveSummoner(Vector(-8904, -14336+i*400), Vector(1,0))
				end
				Winterblight:SpawnDemonSpirit(Vector(-9486, -12325), Vector(1,0))
			end)
			Timers:CreateTimer(1.1, function()
				for i = 0, 4, 1 do
					Winterblight:SpawnGhostStriker(Vector(-5945+i*300, -14208), Vector(-1,0))
				end
				Winterblight:SpawnDemonSpirit(Vector(-6876, -14592), Vector(1,0))
			end)
			Timers:CreateTimer(1.3, function()
				for i = 0, 4, 1 do
					Winterblight:SpawnShineMegmus(Vector(-5696, -13700+i*270), Vector(-1,0))
				end
				for i = 0, 3, 1 do
					Winterblight:SpawnShineMegmus(Vector(-5000, -13300+i*270), Vector(-1,0))
				end
			end)
			Timers:CreateTimer(1.6, function()
				for i = 0, 6, 1 do
					Winterblight:SpawnAzaleaSorceress(Vector(-4702, -13575+i*240), Vector(-1,0))
				end
			end)
		end)
	end
	Winterblight:SpawnTriBoss("winterblight_buzuki")
	Winterblight:SpawnTriBoss("winterblight_azertia")
	Winterblight:SpawnTriBoss("winterblight_torphet")
	Timers:CreateTimer(5, function()
	    local positionTable = {Vector(-11648, -14848), Vector(-11520, -14208), Vector(-11520, -13824), Vector(-11341, -13440), Vector(-11178, -13056), Vector(-11518, -12747), Vector(-11356, -12288), Vector(-11264, -11904), Vector(-11029, -11520)}
	    for i = 1, #positionTable, 1 do
	      local lookToPoint = (Vector(-8812, -13624) - positionTable[i]):Normalized()
	      Winterblight:SpawnFencer(positionTable[i], lookToPoint)
	    end
	end)
end

function Winterblight:SpawnAzaleaDragoon(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_dragoon", position, 1, 2, "Winterblight.Dragoon.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 50
	if Winterblight.Stones >= 1 then
		stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
	end
	if Winterblight.Stones >= 3 then
		stone:AddAbility("ability_stun_immunity"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:SpawnKnifeScraper(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_knife_scraper", position, 0, 1, "Winterblight.KnifeWielder.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 50
	if Winterblight.Stones >= 3 then
		stone:AddAbility("creature_pure_strike"):SetLevel(GameState:GetDifficultyFactor())
	end
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:SpawnTriBoss(bossName)
	local position = Vector(0,0)
	
	local fv = Vector(0,-1)
	local colorVector = Vector(255, 255, 255)
	
	if bossName == "winterblight_torphet" then
		position = Vector(-9140, -12672)
	elseif bossName == "winterblight_azertia" then
		position = Vector(-8374, -13771) + Vector(RandomInt(0, 3400), RandomInt(0, 1680))
		colorVector = Vector(200, 255, 200)

	elseif bossName == "winterblight_buzuki" then
		position = Vector(-4647, -11866)
		colorVector = Vector(180, 255, 180)

	end
	local stone = Winterblight:SpawnDungeonUnit(bossName, position, 0, 1, nil, fv, false)
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 50
	stone:SetRenderColor(colorVector.x, colorVector.y, colorVector.z)
	local ability = stone:FindAbilityByName("winterblight_azalea_triple_boss_ability")
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_azalea_triple_boss_frozen", {})
	if Winterblight.Stones >= 1 then
		stone:RemoveAbility("fire_temple_steadfast")
		stone:AddAbility("redfall_mega_steadfast"):SetLevel(GameState:GetDifficultyFactor())
	end
end

function Winterblight:azalea_jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1]
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_azalea_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance/22.5
	ability.liftVelocity = 20
	local heightDiff = caster:GetAbsOrigin().z - ability.targetPoint.z
	ability.liftVelocity = ability.liftVelocity - heightDiff/24
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	ability.interval = 0

	CustomAbilities:QuickAttachParticle("particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", caster, 3)
	StartAnimation(caster, {duration=1.5, activity=event.anim, rate=1})
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.TriBoss.AzaleaJump", caster)
	EmitSoundOn(event.jumpVO, caster)

	ability.a_c_level = 0
	ability.c_c_level = 0
end

function Winterblight:TriBossInit()
	for i = 1, #Winterblight.TriBossTable.array, 1 do
		StartAnimation(Winterblight.TriBossTable.array[i], {duration=2.8, activity=ACT_DOTA_RUN, rate=2})
		EmitSoundOn(Winterblight.TriBossTable.array[i].jumpVO, Winterblight.TriBossTable.array[i])
		Winterblight.TriBossTable.array[i]:SetHealth(Winterblight.TriBossTable.array[i]:GetMaxHealth())
	end
	Timers:CreateTimer(2.8, function()
		Winterblight:TriBossPhaser(1)
	end)
	-- EmitSoundOn(, Winterblight.TriBossTable.Buzuki)
	-- EmitSoundOn(, Winterblight.TriBossTable.Azertia)
	-- EmitSoundOn(, Winterblight.TriBossTable.Torphet)
	-- Quests:ShowDialogueText(units, caster, "redfall_dialogue_farmer_1_h", 5, false)
end

function Winterblight:RuptholdWall()
	if not Winterblight.RuptholdWallOpened then
		Winterblight.RuptholdWallOpened = true
		local walls = Entities:FindAllByNameWithin("AzaleaWall7", Vector(-7918, -15008, -4094+Winterblight.ZFLOAT), 2400)
	    EmitSoundOnLocationWithCaster(Vector(-7918, -15008), "Winterblight.WallOpen", Events.GameMaster)
	    Winterblight:WallsTicks(false, walls, true, 5, 360, 0.1)
	    Winterblight:RemoveBlockers(4, "AzaleaWallBlocker4", Vector(-7936, -14975, 300+Winterblight.ZFLOAT), 1800)
	end
end

function Winterblight:TriBossPhaser(index)
	Winterblight.TriBossPhase = index
	local goal = 6 + GameState:GetDifficultyFactor()*2
	-- goal = 0
	if Winterblight.TriBossPhase >= goal then
		Winterblight:TriBossBattleBegin()
		return false
	end
	local unitTable = {"winterblight_crystal_malefor", "azalea_grave_summoner", "winterblight_bladewielder", "azalea_shrine_megmus", "winterblight_demon_spirit", "azalea_knife_scraper", "azalea_dragoon", "winterblight_syphist", "winterblight_azalea_secret_keeper", "frostiok", "azalea_ghost_striker", "winterblight_azalea_mindbreaker", "winterblight_azalea_highguard", "azalea_armored_knight", "winterblight_softwalker", "winterblight_cold_seer", "winterblight_source_revenant", "winterblight_maiden_of_azalea", "winterblight_rider_of_azalea", "winterblight_mistral_assassin", "winterblight_frost_frigid_hulk", "winterblight_frost_elemental", "winterblight_frost_avatar", "winterblight_ice_summoner", "winterblight_snow_shaker", "winterblight_frigid_growth", "winterblight_chilling_colossus", "winterblight_dashing_swordsman", "winterblight_azalean_priest", "winterblight_azalea_archer"}
	local abilityTable = {"fire_temple_steadfast", "ability_mega_haste", "winterblight_generic_chill_attack_passive", "winterblight_wolf_ability", "winterblight_ogre_armor", "winterblight_frostiok_passive", "winterblight_frost_colossus_passive", "winterblight_snowshaker_passive", "winterblight_bear_passive", "winterblight_stun_regen", "winterblight_frostbite_attack", "luna_taskmaster_shield", "winterblight_dimension_spear", "winterblight_speed_softening", "winterblight_armor_softening"}
	local strAbilitiesTable = {"winterblight_ogre_armor", "winterblight_armor_softening", "winterblight_speed_softening"}
	if GameState:GetDifficultyFactor() >= 2 then
		table.insert(abilityTable, "seafortress_golden_shell")
	end
	if GameState:GetDifficultyFactor() == 3 then
		table.insert(abilityTable, "creature_pure_strike")
	end
	if Winterblight.Stones >= 1 then
		table.insert(abilityTable, "redfall_mega_steadfast")
	end
	local buzukiTable = {"multiplier", "powerup"}
	local selectedBuzuki = buzukiTable[RandomInt(1, #buzukiTable)]
	local spawnTable = {}
	local positionTable = {Vector(-7217, -12013), Vector(-6406, -12013), Vector(-5596, -12013)}
	local selectedUnit = unitTable[RandomInt(1, #unitTable)]
	local selectedAbility = abilityTable[RandomInt(1, #abilityTable)]
	if selectedBuzuki == "powerup" then
		while selectedUnit == "azalea_armored_knight" or selectedUnit == "winterblight_softwalker" or selectedUnit == "winterblight_frigid_growth" do
			selectedUnit = unitTable[RandomInt(1, #unitTable)]
		end
		while selectedAbility == strAbilitiesTable[1] or selectedAbility == strAbilitiesTable[2] or selectedAbility == strAbilitiesTable[3] do
			selectedAbility = abilityTable[RandomInt(1, #abilityTable)]
		end
	end
	if selectedUnit == "azalea_armored_knight" or selectedUnit == "winterblight_softwalker" or selectedUnit == "winterblight_frigid_growth" then
		while selectedAbility == strAbilitiesTable[1] or selectedAbility == strAbilitiesTable[2] or selectedAbility == strAbilitiesTable[3] do
			selectedAbility = abilityTable[RandomInt(1, #abilityTable)]
		end
	end
	local dialogueEnemies = FindUnitsInRadius( Winterblight.TriBossTable.Torphet:GetTeamNumber(), Vector(-7296, -13056), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	Quests:ShowDialogueTextAzalea(dialogueEnemies, Winterblight.TriBossTable.Torphet, selectedUnit, 4, false)
	EmitSoundOnLocationWithCaster(Winterblight.TriBossTable.Torphet:GetAbsOrigin(), Winterblight.TriBossTable.Torphet.jumpVO, Winterblight.TriBossTable.Torphet)
	StartAnimation(Winterblight.TriBossTable.Torphet, {duration=4.5, activity=ACT_DOTA_TELEPORT, rate=1})
	EmitSoundOn("Winterblight.TriBoss.Torphet.Summoning", Winterblight.TriBossTable.Torphet)
	local multiplier = Winterblight:GetPotentialMultiplierForBuzuki(selectedUnit)
	for i = 1, #positionTable, 1 do
		local summon = Winterblight:SpawnAzaleaUnitByName(selectedUnit, positionTable[i])
		AddFOWViewer(DOTA_TEAM_GOODGUYS, summon:GetAbsOrigin(), 600, 30, false)
		table.insert(spawnTable, summon)
		local ability = Winterblight.TriBossTable.Torphet:FindAbilityByName("winterblight_azalea_triple_boss_ability")
		summon.cantAggro = true
		ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, summon, "modifier_disable_player", {})
		summon:SetAbsOrigin(summon:GetAbsOrigin()+Vector(0,0,2000))
		ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, summon, "modifier_azalea_triboss_entering", {})
		ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, summon, "modifier_triboss_summoned_unit", {})
		
		ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, Winterblight.TriBossTable.Torphet, "modifier_torphet_summoning", {duration = 5})
		summon.cupSequenceData = {}
		summon.cupSequenceData.interval = 0
		summon.cupSequenceData.fallSpeed = 30
		EmitSoundOn("Winterblight.AzaleaCup.Falling", summon)
		Timers:CreateTimer(1, function()
			StartAnimation(summon, {duration=5.5, activity=ACT_DOTA_SPAWN, rate=0.6})
		end)
		local pfx = ParticleManager:CreateParticle( "particles/winterblight/cup_falling_particle.vpcf", PATTACH_CUSTOMORIGIN, nil )
		local colorVector = Vector(100, 200, 255)
		ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(summon:GetAbsOrigin(), summon) )
		ParticleManager:SetParticleControl( pfx, 1, colorVector )
		ParticleManager:SetParticleControl( pfx, 2, colorVector )
		ParticleManager:SetParticleControl( pfx, 3, colorVector )
		summon.summonPFX = pfx
		CustomAbilities:QuickParticleAtPoint("particles/act_2/siltbreaker_beam_channel.vpcf", Vector(-219, -14701, 150+Winterblight.ZFLOAT), 3)
	end
	Timers:CreateTimer(5, function()
		StartAnimation(Winterblight.TriBossTable.Azertia, {duration=2.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.9})
		local dialogueEnemies = FindUnitsInRadius( Winterblight.TriBossTable.Azertia:GetTeamNumber(), Vector(-7296, -13056), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		Quests:ShowDialogueTextAzalea(dialogueEnemies, Winterblight.TriBossTable.Azertia, "DOTA_Tooltip_Ability_"..selectedAbility, 4, false)
		EmitSoundOnLocationWithCaster(Winterblight.TriBossTable.Azertia:GetAbsOrigin(), Winterblight.TriBossTable.Azertia.jumpVO, Winterblight.TriBossTable.Azertia)
		for i = 1, #spawnTable, 1 do
			EmitSoundOn("Winterblight.TriBoss.Azertia.AddAbility", spawnTable[i])
			Timers:CreateTimer(0.6, function()
				local pfxName = "particles/items_fx/white_zap_beam.vpcf"
				local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
				EmitSoundOn("Winterblight.Rupthold.Summon", spawnTable[i])
				ParticleManager:SetParticleControlEnt(pfx, 0, Winterblight.TriBossTable.Azertia, PATTACH_POINT_FOLLOW, "attach_attack1", Winterblight.TriBossTable.Azertia:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(pfx, 1, spawnTable[i]:GetAbsOrigin()+Vector(0,0,60))
				spawnTable[i]:AddAbility(selectedAbility):SetLevel(GameState:GetDifficultyFactor())
				StartAnimation(spawnTable[i], {duration=2.5, activity=ACT_DOTA_ATTACK, rate=0.9})
				Timers:CreateTimer(1.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end)
		end
	end)

	Timers:CreateTimer(10, function()
		local delay = 10
		local dialogueEnemies = FindUnitsInRadius( Winterblight.TriBossTable.Buzuki:GetTeamNumber(), Vector(-7296, -13056), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if selectedBuzuki == "multiplier" then
			StartAnimation(Winterblight.TriBossTable.Buzuki, {duration=2.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
			local voice = (multiplier+1).."x"
			delay = 3
			Quests:ShowDialogueTextAzalea(dialogueEnemies, Winterblight.TriBossTable.Buzuki, voice, 4, false)
			for i = 1, #positionTable, 1 do
				for j = 1, multiplier, 1 do
					local summon = Winterblight:SpawnAzaleaUnitByName(selectedUnit, positionTable[i])

					table.insert(spawnTable, summon)
					local pfxName = "particles/items_fx/white_zap_beam.vpcf"
					local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
					EmitSoundOn("Winterblight.Rupthold.Summon", summon)
					ParticleManager:SetParticleControlEnt(pfx, 0, Winterblight.TriBossTable.Buzuki, PATTACH_POINT_FOLLOW, "attach_attack1", Winterblight.TriBossTable.Buzuki:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(pfx, 1, positionTable[i]+Vector(0,0,100))
					Timers:CreateTimer(1.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					local ability = Winterblight.TriBossTable.Torphet:FindAbilityByName("winterblight_azalea_triple_boss_ability")
					summon.cantAggro = true
					ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, summon, "modifier_disable_player", {})
					ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Torphet, summon, "modifier_triboss_summoned_unit", {})
					summon:AddAbility(selectedAbility):SetLevel(GameState:GetDifficultyFactor())
				end
			end
		elseif selectedBuzuki == "powerup" then
			delay = 8
			EmitSoundOn("Winterblight.TriBoss.Buzuki.Powerup.Start", Winterblight.TriBossTable.Buzuki)
			StartSoundEvent("Winterblight.TriBoss.Buzuki.Powerup.LP", Winterblight.TriBossTable.Buzuki)
			Quests:ShowDialogueTextAzalea(dialogueEnemies, Winterblight.TriBossTable.Buzuki, "buzuki_powerup", 4, false)
			StartAnimation(Winterblight.TriBossTable.Buzuki, {duration=5, activity=ACT_DOTA_VICTORY, rate=1})
			Timers:CreateTimer(0.8, function()
				EmitSoundOn("Winterblight.TriBoss.Buzuki.Powerup.Laugh", Winterblight.TriBossTable.Buzuki)
			end)
			for i=1, #spawnTable, 1 do
				local ability = Winterblight.TriBossTable.Buzuki:FindAbilityByName("winterblight_azalea_triple_boss_ability")
				ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Buzuki, spawnTable[i], "modifier_triboss_powering_up", {duration = 5})
				ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Buzuki, spawnTable[i], "modifier_triboss_powered_up_multiple", {})
				ability:ApplyDataDrivenModifier(Winterblight.TriBossTable.Buzuki, spawnTable[i], "modifier_triboss_powered_up_single", {})
			end
			Timers:CreateTimer(5, function()
				StopSoundEvent("Winterblight.TriBoss.Buzuki.Powerup.LP", Winterblight.TriBossTable.Buzuki)
			end)
		end
		Timers:CreateTimer(delay, function()
			Winterblight.TriBossSpawnGoal = #spawnTable
			Winterblight.TriBossSpawnKills = 0
			for i = 1, #spawnTable, 1 do
				spawnTable[i]:RemoveModifierByName("modifier_disable_player")
				spawnTable[i].cantAggro = false
				Dungeons:AggroUnit(spawnTable[i])
				if spawnTable[i].summonPFX then
					ParticleManager:DestroyParticle(spawnTable[i].summonPFX, false)
				end
			end
		end)
	end)
	
	-- StartAnimation(Winterblight.TriBossTable.Buzuki, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
	-- local dialogueEnemies = FindUnitsInRadius( Winterblight.TriBossTable.Buzuki:GetTeamNumber(), Vector(-7296, -13056), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	-- Quests:ShowDialogueTextAzalea(dialogueEnemies, Winterblight.TriBossTable.Buzuki, selectedUnit, 4, false)
	-- for i = 1, #positionTable, 1 do
	-- 	if selectedUnit == "azalea_grave_summoner" then
	-- 		local summon = Winterblight:SpawnGraveSummoner(positionTable[i], Vector(0,-1))
	-- 		table.insert(spawnTable, summon)
	-- 		local pfxName = "particles/items_fx/white_zap_beam.vpcf"
	-- 		local pfx = ParticleManager:CreateParticle(pfxName, PATTACH_CUSTOMORIGIN, nil)
	-- 		EmitSoundOn("Winterblight.Rupthold.Summon", summon)
	-- 		ParticleManager:SetParticleControlEnt(pfx, 0, Winterblight.TriBossTable.Buzuki, PATTACH_POINT_FOLLOW, "attach_attack1", Winterblight.TriBossTable.Buzuki:GetAbsOrigin(), true)
	-- 		ParticleManager:SetParticleControl(pfx, 1, positionTable[i])
	-- 		Timers:CreateTimer(1.5, function()
	-- 			ParticleManager:DestroyParticle(pfx, false)
	-- 		end)
	-- 	end
	-- end
	Timers:CreateTimer(3, function()
	end)
end

function Winterblight:SpawnAzaleaUnitByName(name, position)
	local summon = nil
	if name == "azalea_grave_summoner" then
		summon = Winterblight:SpawnGraveSummoner(position, Vector(0,-1))
	elseif name == "winterblight_bladewielder" then
		summon = Winterblight:SpawnBladeWielder(position, Vector(0,-1))
	elseif name == "azalea_shrine_megmus" then
		summon = Winterblight:SpawnShineMegmus(position, Vector(0,-1))
	elseif name == "winterblight_demon_spirit" then
		summon = Winterblight:SpawnDemonSpirit(position, Vector(0,-1))
	elseif name == "azalea_knife_scraper" then
		summon = Winterblight:SpawnKnifeScraper(position, Vector(0,-1))
	elseif name == "azalea_dragoon" then
		summon = Winterblight:SpawnAzaleaDragoon(position, Vector(0,-1))
	elseif name == "winterblight_syphist" then
		summon = Winterblight:SpawnSyphist(position, Vector(0,-1))
	elseif name == "winterblight_azalea_secret_keeper" then
		summon = Winterblight:SpawnSecretKeeper(position, Vector(0,-1))
	elseif name == "frostiok" then
		summon = Winterblight:SpawnFrostiok(position, Vector(0,-1))
	elseif name == "azalea_ghost_striker" then
		summon = Winterblight:SpawnGhostStriker(position, Vector(0,-1))
	elseif name == "winterblight_azalea_mindbreaker" then
		summon = Winterblight:SpawnAzaleaMindbreaker(position, Vector(0,-1))
	elseif name == "winterblight_azalea_highguard" then
		summon = Winterblight:SpawnAzaleaHighguard(position, Vector(0,-1))
	elseif name == "azalea_armored_knight" then
		summon = Winterblight:SpawnArmoredKnight(position, Vector(0,-1))
	elseif name == "winterblight_softwalker" then
		summon = Winterblight:SpawnSoftwalker(position, Vector(0,-1))
	elseif name == "winterblight_cold_seer" then
		summon = Winterblight:SpawnColdSeer(position, Vector(0,-1))
	elseif name == "winterblight_source_revenant" then
		summon = Winterblight:SpawnSourceRevenant(position, Vector(0,-1))
	elseif name == "winterblight_maiden_of_azalea" then
		summon = Winterblight:SpawnAzaleaMaiden(position, Vector(0,-1))
	elseif name == "winterblight_rider_of_azalea" then
		summon = Winterblight:SpawnRiderOfAzalea(position, Vector(0,-1))
	elseif name == "winterblight_mistral_assassin" then
		summon = Winterblight:SpawnWinterAssasin(position, Vector(0,-1))
	elseif name == "winterblight_frost_frigid_hulk" then
		summon = Winterblight:SpawnFrostHulk(position, Vector(0,-1))
	elseif name == "winterblight_frost_elemental" then
		summon = Winterblight:SpawnFrostElemental(position, Vector(0,-1))
	elseif name == "winterblight_frost_avatar" then
		summon = Winterblight:SpawnFrostAvatar(position, Vector(0,-1))
	elseif name == "winterblight_ice_summoner" then
		summon = Winterblight:SpawnIceSummoner(position, Vector(0,-1))
	elseif name == "winterblight_snow_shaker" then
		summon = Winterblight:Snowshaker(position, Vector(0,-1))
	elseif name == "winterblight_frigid_growth" then
		summon = Winterblight:SpawnFrigidGrowth(position, Vector(0,-1))
	elseif name == "winterblight_chilling_colossus" then
		summon = Winterblight:SpawnChillingColossus(position, Vector(0,-1))
	elseif name == "winterblight_dashing_swordsman" then
		summon = Winterblight:SpawnDashingSwordsman(position, Vector(0,-1))
	elseif name == "winterblight_azalean_priest" then
		summon = Winterblight:SpawnPriestOfAzalea(position, Vector(0,-1))
	elseif name == "winterblight_azalea_archer" then
		summon = Winterblight:SpawnAzaleaArcher(position, Vector(0,-1))
	elseif name == "winterblight_crystal_malefor" then
		summon = Winterblight:SpawnCrystalRunner(position, Vector(0,-1))
	end
	return summon
end

function Winterblight:GetPotentialMultiplierForBuzuki(name)
	local multiplier = RandomInt(1, 3)
	if name == "azalea_grave_summoner" then
	elseif name == "winterblight_bladewielder" then
		multiplier = RandomInt(1, 4)
	elseif name == "azalea_shrine_megmus" then
		multiplier = RandomInt(2, 5)
	elseif name == "winterblight_demon_spirit" then
		multiplier = RandomInt(1, 2)
	elseif name == "azalea_knife_scraper" then
		multiplier = RandomInt(2, 5)
	elseif name == "azalea_dragoon" then
		multiplier = RandomInt(2, 5)
	elseif name == "winterblight_syphist" then
		multiplier = RandomInt(2, 5)
	elseif name == "winterblight_azalea_secret_keeper" then
		multiplier = RandomInt(2, 5)
	elseif name == "frostiok" then
		multiplier = RandomInt(2, 6)
	elseif name == "azalea_ghost_striker" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_azalea_mindbreaker" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_azalea_highguard" then
		multiplier = RandomInt(1, 3)
	elseif name == "azalea_armored_knight" then
		multiplier = RandomInt(1, 4)
	elseif name == "winterblight_softwalker" then
		multiplier = RandomInt(1, 4)
	elseif name == "winterblight_cold_seer" then
		multiplier = RandomInt(1, 5)
	elseif name == "winterblight_source_revenant" then
		multiplier = RandomInt(1, 4)
	elseif name == "winterblight_maiden_of_azalea" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_rider_of_azalea" then
		multiplier = RandomInt(2, 5)
	elseif name == "winterblight_mistral_assassin" then
		multiplier = RandomInt(1, 3)
	elseif name == "winterblight_frost_frigid_hulk" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_frost_elemental" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_frost_avatar" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_ice_summoner" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_snow_shaker" then
		multiplier = RandomInt(2, 3)
	elseif name == "winterblight_frigid_growth" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_dashing_swordsman" then
		multiplier = RandomInt(2, 4)
	elseif name == "winterblight_azalean_priest" then
		multiplier = RandomInt(2, 4)
	elseif name ==  "winterblight_azalea_archer" then
		multiplier = RandomInt(1+GameState:GetDifficultyFactor(), 3+GameState:GetDifficultyFactor())
	elseif name == "winterblight_crystal_malefor" then
		multiplier = RandomInt(2, 4)
	end
	return multiplier
end

function Winterblight:TriBossBattleBegin()
	for i = 1, #Winterblight.TriBossTable.array, 1 do
		StartAnimation(Winterblight.TriBossTable.array[i], {duration=2.8, activity=ACT_DOTA_RUN, rate=2})
		EmitSoundOn(Winterblight.TriBossTable.array[i].jumpVO, Winterblight.TriBossTable.array[i])
	end
	Timers:CreateTimer(2.8, function()
		for i = 1, #Winterblight.TriBossTable.array, 1 do
			local target_point = Vector(-8074, -13471) + Vector(RandomInt(0, 2800), RandomInt(0, 1580))
			local eventTable = {}
			local caster = Winterblight.TriBossTable.array[i]
			local ability = caster:FindAbilityByName("winterblight_azalea_triple_boss_ability")
			eventTable.caster = caster
			eventTable.ability = ability
			eventTable.target_points = {}
			eventTable.anim = caster.anim
			eventTable.target_points[1] = GetGroundPosition(target_point, caster) + Vector(0,0,200)
			eventTable.jumpVO = caster.jumpVO
			Winterblight:azalea_jump_start(eventTable)
			Timers:CreateTimer(1.5, function()
				if caster:GetUnitName() == "winterblight_buzuki" then
					EmitSoundOn("Winterblight.TriBoss.Buzuki.Aggro", caster)
				elseif caster:GetUnitName() == "winterblight_azertia" then
					EmitSoundOn("Winterblight.TriBoss.Azertia.Aggro", caster)
				elseif caster:GetUnitName() == "winterblight_torphet" then
					EmitSoundOn("Winterblight.TriBoss.Torphet.Aggro", caster)
				end
				if caster:GetUnitName() == "winterblight_torphet" then
					StartAnimation(caster, {duration=2.2, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
				else
					StartAnimation(caster, {duration=2.2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
				end
				Timers:CreateTimer(1, function()
					caster:RemoveModifierByName("modifier_disable_player")
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_triboss_in_battle", {})
					Dungeons:AggroUnit(caster)
					caster:SetAcquisitionRange(6000)
				end)
			end)
		end
	end)

end

function Winterblight:TriBossesAllSlain()
	Winterblight:RuptholdWall()
	Winterblight.TriBossesSlain = true
	Winterblight:SpawnCup5()
	Winterblight:AzaleaLastRoomWall()
end

function Winterblight:SpawnFencer(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_fencer", position, 1, 2, "Winterblight.Fencer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 3, false)
	stone.itemLevel = 54
	if Winterblight.Stones >= 1 then
		stone:AddAbility("ability_magic_immune_break"):SetLevel(GameState:GetDifficultyFactor())
	end
	if Winterblight.Stones >= 3 then
		stone:AddAbility("ability_stun_immunity"):SetLevel(GameState:GetDifficultyFactor())
	end
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate="run"})
	stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="run"})
	return stone
end

function Winterblight:AzaleaLastRoomWall()
	if not Winterblight.AzaleaLastWallOpened then
		Winterblight.AzaleaLastWallOpened = true
		local walls = Entities:FindAllByNameWithin("AzaleaWall8", Vector(-11740, -12980, 273+Winterblight.ZFLOAT), 2400)
	    EmitSoundOnLocationWithCaster(Vector(-11740, -12980, 273+Winterblight.ZFLOAT), "Winterblight.WallOpen", Events.GameMaster)
	    Winterblight:Walls(false, walls, true, 4.3)
	    Winterblight:RemoveBlockers(4, "AzaleaBlocker5", Vector(-11740, -12928, 150+Winterblight.ZFLOAT), 2800)
	end
end

function Winterblight:SpawnPixieMinion(position, fv)
	local hp = (100 + GameState:GetDifficultyFactor()*100) + Winterblight.Stones*100
	local pixie = CreateUnitByName("pixie_minion", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	pixie:SetBaseMaxHealth(hp)
	pixie:SetMaxHealth(hp)
	pixie:SetHealth(hp)
	pixie:SetAcquisitionRange(3000)
	pixie:SetForwardVector(fv)
	return pixie
end

function Winterblight:GetRandomPixieLocation()
	-- local possiblePositionTable = {Vector(-14080, -13440), Vector(-13568, -13312), Vector(-12576, -13222)}
	local position = nil
	local luck = RandomInt(1, 100)
	if luck <=38 then
		position = Vector(-14208, -13312) + Vector(RandomInt(0, 2300), RandomInt(0, 2250))
	elseif luck <= 92 then
		position = Vector(-15616, -11776) + Vector(RandomInt(0, 3950), RandomInt(0, 2750))
	elseif luck < 99 then
		position = Vector(-11129, -10347+RandomInt(0, 2500))
	elseif luck == 99 then
		position = Vector(-15404, -12103)
	elseif luck == 100 then
		position = Vector(-16000, -11776)
	end
	return position
end

function Winterblight:PixieSummonTakeDamage(summon)
	for i = 1, #summon.buddyTable, 1 do
		local buddy = summon.buddyTable[i]
		if IsValidEntity(buddy) and buddy:IsAlive() then
			local newHealth = buddy:GetHealth() - 1
			if newHealth == 0 then
				buddy:ForceKill(true)
			else
				buddy:SetHealth(newHealth)
			end
		end
	end
end

function Winterblight:SpawnRiftBreaker(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_riftbreaker", position, 1, 1, "Winterblight.Riftbreaker.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 50
	Events:ColorWearablesAndBase(stone, Vector(150,255,145))
	Winterblight:SetTargetCastArgs(stone, 1500, 0, 2, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnStarSeeker(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_star_seeker", position, 1, 1, "Winterblight.StarSeeker.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 50
	stone.dominion = true
	Events:ColorWearablesAndBase(stone, Vector(150,255,145))
	return stone
end

function Winterblight:SpawnSpineSplitter(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("azalea_spine_splitter", position, 1, 1, "Winterblight.SpineSplitter.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 5, false)
	stone.itemLevel = 50
	stone.dominion = true
	Events:ColorWearablesAndBase(stone, Vector(150,255,145))
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end


function Winterblight:LastAzaleaRoomStart()
	if Winterblight.LastAzaleaRoomSpawned then
		return false
	end
	Winterblight.LastAzaleaRoomSpawned = true
	local pixie = CreateUnitByName("azalea_mystery_pixie", Vector(-11699, -10174), false, nil, nil, DOTA_TEAM_NEUTRALS)
	pixie:SetForwardVector(Vector(-1,0))
	pixie.phase = 0
	local luck = RandomInt(1, 3)
	if luck == 1 then
		for j = 0, 2, 1 do
		 for i = 0, 2, 1 do
		 	Timers:CreateTimer(i*0.5 + j*0.32, function()
		 		Winterblight:SpawnRiftBreaker(Vector(-13312+i*256, -10807+j*256), Vector(0,-1))
		 	end)
		 end
		end
		Timers:CreateTimer(0.3, function()
			local positionTable = {Vector(-12544, -13254), Vector(-12045, -13292), Vector(-12288, -13015), Vector(-12544, -12800), Vector(-12045, -12800)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnStarSeeker(positionTable[i], Vector(0,1))
			end
		end)
		Timers:CreateTimer(0.75, function()
			for j = 0, 3, 1 do
			 for i = 0, 2, 1 do
			 	Timers:CreateTimer(i*0.5 + j*0.32, function()
			 		Winterblight:SpawnSpineSplitter(Vector(-11862+i*256, -9480+j*256), Vector(-1,-0))
			 	end)
			 end
			end
		end)
		Timers:CreateTimer(1.1, function()
			local positionTable = {Vector(-14080, -13312), Vector(-13696, -13009), Vector(-13952, -12701), Vector(-14080, -12366), Vector(-13739, -12216), Vector(-14080, -12032), Vector(-14262, -11648), Vector(-14382, -11136), Vector(-14585, -10752)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFencer(positionTable[i], Vector(1,0))
			end
			Winterblight:SpawnChillingColossus(Vector(-14715, -10368), Vector(1,0))
		end)
		Timers:CreateTimer(1.3, function()
			local positionTable = {Vector(-14976, -9216), Vector(-14592, -9216), Vector(-14208, -9216), Vector(-13824, -9216), Vector(-14976, -8832), Vector(-14592, -8832), Vector(-14208, -8832), Vector(-13824, -8832)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFencer(positionTable[i], Vector(0,-1))
			end
			Winterblight:SpawnStarSeeker(Vector(-15360, -9088), Vector(1,-1))
			Winterblight:SpawnStarSeeker(Vector(-15267, -8832), Vector(1,-0.5))
			Winterblight:SpawnStarSeeker(Vector(-15103, -8576), Vector(0.1,-1))
		end)
		Timers:CreateTimer(1.5, function()
		    local positionTable = {Vector(-13312, -8739), Vector(-12617, -8739), Vector(-12928, -8827), Vector(-13184, -9138), Vector(-12928, -9344), Vector(-12672, -9138)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(-12573, -9627) - positionTable[i]):Normalized()
		      Winterblight:SpawnAzaleaDragoon(positionTable[i], lookToPoint)
		    end
		end)
		Timers:CreateTimer(1.7, function()
			Winterblight:SpawnDemonSpirit(Vector(-11651, -8329), RandomVector(1))
			Winterblight:SpawnDemonSpirit(Vector(-11210, -8188), RandomVector(1))
		end)
		Timers:CreateTimer(2.5, function()
			Winterblight:SpawnGraveSummoner(Vector(-15103, -11329), Vector(-0.2, 1))
			Winterblight:SpawnGraveSummoner(Vector(-15310, -11648), Vector(-0.4, 1))
			Winterblight:SpawnGraveSummoner(Vector(-15488, -11904), Vector(-0.7, 1))
		end)
		Timers:CreateTimer(2.0, function()
		    local positionTable = {Vector(-12928, -10880), Vector(-13184, -10721), Vector(-12864, -10496), Vector(-13440, -10322), Vector(-13056, -10121), Vector(-13440, -9918)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(-13696, -11008) - positionTable[i]):Normalized()
		      Winterblight:SpawnShineMegmus(positionTable[i], lookToPoint)
		    end
		end)
	elseif luck == 2 then
		Timers:CreateTimer(0.3, function()
			local positionTable = {Vector(-12109, -13277), Vector(-12454, -13184), Vector(-12160, -12874), Vector(-12544, -12742), Vector(-12160, -12539), Vector(-12544, -12378), Vector(-12265, -12143), Vector(-12672, -12032)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnRiftBreaker(positionTable[i], Vector(0,1))
			end
		end)
		Winterblight:SpawnDemonSpirit(Vector(-13056, -12672), Vector(0,1))
		Winterblight:SpawnDemonSpirit(Vector(-13056, -12972), Vector(0,1))
		Timers:CreateTimer(1.1, function()
			local positionTable = {Vector(-14080, -13312), Vector(-13696, -13012), Vector(-14208, -12694), Vector(-13696, -12488), Vector(-14208, -12218), Vector(-13972, -11804), Vector(-14336, -11707)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnStarSeeker(positionTable[i], Vector(1,0))
			end
			Winterblight:SpawnChillingColossus(Vector(-13824, -10752), Vector(0.2,-1))
		end)
		Timers:CreateTimer(1.3, function()
			local positionTable = {Vector(-14336, -11354), Vector(-14500, -11008), Vector(-14802, -10795), Vector(-14820, -10368), Vector(-14500, -10624)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnGraveSummoner(positionTable[i], Vector(1,0))
			end
		end)
		Timers:CreateTimer(2.1, function()
			for j = 0, 2, 1 do
			 for i = 0, 5, 1 do
			 	Timers:CreateTimer(i*0.5 + j*0.32, function()
			 		Winterblight:SpawnSpineSplitter(Vector(-15232+i*256, -9216+j*256), Vector(0,-1))
			 	end)
			 end
			end
		end)
		Timers:CreateTimer(2, function()
			Winterblight:SpawnMonolith(Vector(-15356, -11714), Vector(0,1))
			Winterblight:SpawnMonolith(Vector(-15488, -12032), Vector(0,1))
			Winterblight:SpawnMonolith(Vector(-15126, -11368), Vector(0,1))
			SpawnChillingColossus(Vector(-11648, -10880), Vector(0,1))
		end)
		Timers:CreateTimer(1.0, function()
			local positionTable = {Vector(-13184, -10880), Vector(-12800, -10880), Vector(-12928, -10496), Vector(-13352, -10496), Vector(-13395, -10151), Vector(-13276, -9762), Vector(-12928, -10074), Vector(-12544, -10248)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFencer(positionTable[i], Vector(0,-1))
			end
		end)
		Timers:CreateTimer(1.8, function()
			local positionTable = {Vector(-12672, -9600), Vector(-12928, -9093), Vector(-13312, -8798), Vector(-12824, -8686), Vector(-12377, -9264), Vector(-11673, -9472), Vector(-11387, -9216), Vector(-11945, -9088), Vector(-12160, -8686), Vector(-11776, -8458), Vector(-11387, -8832)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaDragoon(positionTable[i], Vector(0,-1))
			end
		end)
	elseif luck == 3 then
		Timers:CreateTimer(1, function()
		    local positionTable = {Vector(-12672, -10115), Vector(-12544, -9847), Vector(-13056, -9856), Vector(-12880, -9528), Vector(-12544, -9528), Vector(-12881, -9088), Vector(-13184, -8916), Vector(-12672, -8776)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(-13184, -10368) - positionTable[i]):Normalized()
		      Winterblight:SpawnAzaleaMaiden(positionTable[i], lookToPoint)
		    end
		    Winterblight:SpawnDemonSpirit(Vector(-11101, -9968), Vector(-1,0))
		end)
		Timers:CreateTimer(1.2, function()
		    local positionTable = {Vector(-11904, -9472), Vector(-11521, -9394), Vector(-11776, -9088), Vector(-11225, -9088), Vector(-12160, -8862), Vector(-11648, -8745), Vector(-11264, -8496), Vector(-11904, -8299), Vector(-11520, -8088)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(-13184, -10368) - positionTable[i]):Normalized()
		      Winterblight:SpawnAzaleaMaiden(positionTable[i], lookToPoint)
		    end
		end)
		Timers:CreateTimer(0.5, function()
			for j = 0, 6, 1 do
			 for i = 0, 2, 1 do
			 	Timers:CreateTimer(i*0.5 + j*0.32, function()
			 		Winterblight:SpawnSpineSplitter(Vector(-12624+i*256, -13260+j*256), Vector(0,1))
			 	end)
			 end
			end
		end)
		Timers:CreateTimer(0.3, function()
		    local positionTable = {Vector(-14080, -13317), Vector(-13696, -13258), Vector(-13524, -12928), Vector(-13952, -12928), Vector(-14336, -12760), Vector(-13696, -12524), Vector(-13696, -12288), Vector(-14113, -12389)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(-12519, -12061) - positionTable[i]):Normalized()
		      Winterblight:SpawnRiftBreaker(positionTable[i], lookToPoint)
		    end
		end)
		Timers:CreateTimer(0.7, function()
		    local positionTable = {Vector(-14208, -11904), Vector(-14404, -11648), Vector(-14128, -11520), Vector(-14338, -11264), Vector(-14286, -11008), Vector(-14587, -10952), Vector(-14492, -10752), Vector(-14674, -10496), Vector(-14674, -10240)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(-12519, -12061) - positionTable[i]):Normalized()
		      Winterblight:SpawnAzaleaDragoon(positionTable[i], lookToPoint)
		    end
		end)
		Timers:CreateTimer(2.1, function()
			for j = 0, 1, 1 do
			 for i = 0, 4, 1 do
			 	Timers:CreateTimer(i*0.5 + j*0.32, function()
			 		Winterblight:SpawnFencer(Vector(-15232+i*356, -9216+j*356), Vector(0,-1))
			 	end)
			 end
			end
		end)
		Timers:CreateTimer(1.8, function()
			Winterblight:SpawnArmoredKnight(Vector(-12976, -10880), Vector(0,-1))
			Winterblight:SpawnArmoredKnight(Vector(-13229, -10624), Vector(0,-1))
			Winterblight:SpawnArmoredKnight(Vector(-13440, -10368), Vector(0,-1))
			Winterblight:SpawnStarSeeker(Vector(-11648, -10880), Vector(0,1))
			Winterblight:SpawnStarSeeker(Vector(-11204, -9620), Vector(-1,0))
			Winterblight:SpawnStarSeeker(Vector(-11648, -9480), Vector(-1,-1))
		end)
		Timers:CreateTimer(2.3, function()
			for j = 0, 4, 1 do
			 for i = 0, 2, 1 do
			 	Timers:CreateTimer(i*0.5 + j*0.32, function()
			 		Winterblight:SpawnSpineSplitter(Vector(-15733+i*240, -11904+j*256), Vector(0,1))
			 	end)
			 end
			end
		end)
	end
	if false then
	Timers:CreateTimer(0.2, function()
		for i = 0, 3, 1 do
			local unit = Winterblight:SpawnSkaterFiend(Vector(-13664+RandomInt(0,1180), -11520+RandomInt(0,180)), RandomVector(1))
			unit.minVector = Vector(-13664, -11520)
			unit.maxXroam = 1180
			unit.maxYroam = 180
		end
	end)
	Timers:CreateTimer(0.8, function()
		for i = 0, 4, 1 do
			local unit = Winterblight:SpawnSkaterFiend(Vector(-15232+RandomInt(0,1020), -9856+RandomInt(0,240)), RandomVector(1))
			unit.minVector = Vector(-15232, -9856)
			unit.maxXroam = 1020
			unit.maxYroam = 240
		end
	end)
	Timers:CreateTimer(0.5, function()
		local positionTable = {Vector(-15488, -11392), Vector(-13917, -10502), Vector(-12287, -9605), Vector(-12601, -12056), Vector(-13919, -12766)}
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
	        local patspawn = RandomInt(1, 3)
	        for j = 0, 2, 1 do
	          Timers:CreateTimer(j*0.8, function()
	          	if patspawn == 1 then
		            local elemental = Winterblight:SpawnStarSeeker(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 15, 5, 220, patrolPositionTable)
		        elseif patspawn == 2 then
		            local elemental = Winterblight:SpawnSpectralWitch(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 15, 5, 220, patrolPositionTable)
		        elseif patspawn == 3 then
		            local elemental = Winterblight:SpawnAzaleaArcher(positionTable[i]+RandomVector(RandomInt(1,100)), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 15, 5, 220, patrolPositionTable)
		        end
	          end)
	        end
	      end)
	    end
	end)
	end
end

function Winterblight:SpawnStargazerOrin(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("stargazer_orin", position, 6, 8, "Winterblight.StarGazer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 60
	Events:ColorWearablesAndBase(stone, Vector(150,255,145))
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_magic_immune_break"):SetLevel(GameState:GetDifficultyFactor())
	end
	if Winterblight.Stones > 0 then
		stone:RemoveAbility("fire_temple_steadfast")
		stone:RemoveModifierByName("modifier_steadfast")
		stone:AddAbility("redfall_mega_steadfast"):SetLevel(GameState:GetDifficultyFactor())
	end
	if GameState:GetDifficultyFactor() == 3 and Winterblight.Stones >= 3 then
		stone:AddAbility("seafortress_golden_shell"):SetLevel(3)
	end
	return stone
end

function Winterblight:StartStarGazerWaveEvent(beamTable)
	Winterblight.StarGazerBeamTable = beamTable
	local luck2 = RandomInt(1, 3)
	for i = 1, #beamTable, 1 do
		local beamData = beamTable[i]
		local position = beamData.targetPoint
		local unitName = "winterblight_azalea_archer"
		if luck2 == 1 then
			unitName = "winterblight_frost_elemental"
		elseif luck2 == 2 then
			unitName = "winterblight_frost_avatar"
		end
		Winterblight:SpawnStargazerWaveUnit1(unitName, position, 3, 4, true, nil)
	end
end

function Winterblight:SpawnStargazerWaveUnit1(unitName, spawnPoint, quantity, delay, bSound, jumpFV)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.StarGazer.PortalStart", Winterblight.Master)
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
        unit.deathCode = 4
        Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_winterblight_wave_unit", {})
        unit:SetAcquisitionRange(3500)
        CustomAbilities:QuickAttachParticle("particles/roshpit/mountain_protector/steelforge_start_teleport_ti7_out.vpcf", unit, 2)
        unit.aggro = true
        Winterblight:AdjustWaveUnit(unit)
        Winterblight:StargazerWaveUnitSpawn(unit, jumpFV)
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].dominion = true
          unit[i]:SetAcquisitionRange(3500)
          unit[i].deathCode = 4
          Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit[i], "modifier_winterblight_wave_unit", {})
          CustomAbilities:QuickAttachParticle("particles/roshpit/mountain_protector/steelforge_start_teleport_ti7_out.vpcf", unit[i], 2)
          Winterblight:AdjustWaveUnit(unit[i])
          Winterblight:StargazerWaveUnitSpawn(unit[i], jumpFV)
        end
      end
    end)
  end
end

function Winterblight:StargazerWaveUnitDie(unit)
	if not Winterblight.StargazerWaveUnitsSlain then
		Winterblight.StargazerWaveUnitsSlain = 0
	end
	local beamTable = Winterblight.StarGazerBeamTable
	Winterblight.StargazerWaveUnitsSlain = Winterblight.StargazerWaveUnitsSlain + 1
	if Winterblight.StargazerWaveUnitsSlain == 27 then
		for i = 1, #beamTable, 1 do
			local beamData = beamTable[i]
			local position = beamData.targetPoint
			Winterblight:SpawnStargazerWaveUnit1("azalea_shrine_megmus", position, 2, 7, true, nil)
		end
	elseif Winterblight.StargazerWaveUnitsSlain == 46 then
		for i = 1, #beamTable, 1 do
			local beamData = beamTable[i]
			local position = beamData.targetPoint
			Winterblight:SpawnStargazerWaveUnit1("winter_snow_spirit", position, 3, 3, true, nil)
		end
	elseif Winterblight.StargazerWaveUnitsSlain == 75 then
		for i = 1, #beamTable, 1 do
			local luck = RandomInt(1, 3)
			local beamData = beamTable[i]
			local position = beamData.targetPoint
			local unitName = "winter_snow_spirit"
			if luck == 1 then
				unitName = "winterblight_rider_of_azalea"
			elseif luck == 2 then
				unitName = "azalea_dragoon"
			end
			Winterblight:SpawnStargazerWaveUnit1(unitName, position, 2, 5, true, nil)
		end
	elseif Winterblight.StargazerWaveUnitsSlain == 94 then
		for i = 1, #beamTable, 1 do
			local luck = RandomInt(1, 3)
			local beamData = beamTable[i]
			local position = beamData.targetPoint
			local unitName = "azalea_air_spirit"
			if luck == 1 then
				unitName = "azalea_grave_summoner"
			elseif luck == 2 then
				unitName = "winterblight_syphist"
			end
			Winterblight:SpawnStargazerWaveUnit1(unitName, position, 3, 6, true, nil)
		end
	elseif Winterblight.StargazerWaveUnitsSlain == 123 then
		for i = 1, #beamTable, 1 do
			local luck = RandomInt(1, 3)
			local beamData = beamTable[i]
			local position = beamData.targetPoint
			local unitName = "winter_snow_spirit"
			if luck == 1 then
				unitName = "azalea_star_seeker"
			elseif luck == 2 then
				unitName = "azalea_fencer"
			end
			Winterblight:SpawnStargazerWaveUnit1(unitName, position, 2, 5, true, nil)
		end
	elseif Winterblight.StargazerWaveUnitsSlain == 143 then
		for i = 1, #beamTable, 1 do
			local luck = RandomInt(1, 12)
			local beamData = beamTable[i]
			local position = beamData.targetPoint
			local unitName = "winter_snow_spirit"
			if luck == 1 then
				unitName = "azalea_star_seeker"
			elseif luck == 2 then
				unitName = "azalea_fencer"
			elseif luck == 3 then
				unitName = "azalea_air_spirit"
			elseif luck == 4 then
				unitName = "azalea_grave_summoner"
			elseif luck == 5 then
				unitName = "winterblight_syphist"
			elseif luck == 6 then
				unitName = "azalea_dragoon"
			elseif luck == 7 then
				unitName = "winterblight_rider_of_azalea"
			elseif luck == 8 then
				unitName = "azalea_shrine_megmus"
			elseif luck == 9 then
				unitName = "winterblight_maiden_of_azalea"
			elseif luck == 10 then
				unitName = "winterblight_frost_avatar"
			elseif luck == 11 then
				unitName = "winterblight_azalea_archer"
			end
			Winterblight:SpawnStargazerWaveUnit1(unitName, position, 2, 7, true, nil)
		end
	elseif Winterblight.StargazerWaveUnitsSlain == 163 then
		for i = 1, #beamTable, 1 do
			local luck = RandomInt(1, 12)
			local beamData = beamTable[i]
			local position = beamData.targetPoint
			local unitName = "winter_snow_spirit"
			if luck == 1 then
				unitName = "azalea_star_seeker"
			elseif luck == 2 then
				unitName = "azalea_fencer"
			elseif luck == 3 then
				unitName = "azalea_air_spirit"
			elseif luck == 4 then
				unitName = "azalea_grave_summoner"
			elseif luck == 5 then
				unitName = "winterblight_syphist"
			elseif luck == 6 then
				unitName = "azalea_dragoon"
			elseif luck == 7 then
				unitName = "winterblight_rider_of_azalea"
			elseif luck == 8 then
				unitName = "azalea_shrine_megmus"
			elseif luck == 9 then
				unitName = "winterblight_maiden_of_azalea"
			elseif luck == 10 then
				unitName = "winterblight_frost_avatar"
			elseif luck == 11 then
				unitName = "winterblight_azalea_archer"
			end
			Winterblight:SpawnStargazerWaveUnit1(unitName, position, 3, 6.5, true, nil)
		end
	elseif Winterblight.StargazerWaveUnitsSlain == 193 then
		for i = 1, #beamTable, 1 do
			local beamData = beamTable[i]
			CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", beamData.targetPoint, 3)
			ParticleManager:DestroyParticle(beamData.portalParticle, false)
			ParticleManager:DestroyParticle(beamData.pfx, false)
			EmitSoundOnLocationWithCaster(beamData.targetPoint, "Winterblight.StarGazer.Portal.End", Winterblight.Stargazer)
		end
		ParticleManager:DestroyParticle(Winterblight.orbBeamPFX, false)
		Winterblight.orbBeamPFX = nil
		Winterblight.StarGazerBeamTable = nil
		Winterblight.Stargazer.cometLock = true
		Timers:CreateTimer(3, function()
			EmitSoundOn("Winterblight.StarGazer.Disappear1", Winterblight.Stargazer) 
			StartAnimation(Winterblight.Stargazer, {duration=2.4, activity=ACT_DOTA_CAST_ABILITY_5, rate=0.7})
			Timers:CreateTimer(2.6, function()
				Winterblight.Stargazer:AddNewModifier(Winterblight.Stargazer, nil, "modifier_animation", {translate="spin"})
				Winterblight.Stargazer:AddNewModifier(Winterblight.Stargazer, nil, "modifier_animation_translate", {translate="spin"})
				StartAnimation(Winterblight.Stargazer, {duration=3.0, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.5, translate="spin"})
				Winterblight:smoothSizeChange(Winterblight.Stargazer, 2.25, 0.1, 36)
				for i = 1, 36, 1 do
					Timers:CreateTimer(i*0.03, function()
						Winterblight.Stargazer:SetAbsOrigin(Winterblight.Stargazer:GetAbsOrigin()+Vector(0,0,11))
						local fv = WallPhysics:rotateVector(Winterblight.Stargazer:GetForwardVector(), 2*math.pi*math.cos(2*math.pi*i/7)/14)
						Winterblight.Stargazer:SetForwardVector(fv)
					end)
				end
				Timers:CreateTimer(0.3, function()
					EmitSoundOn("Winterblight.StarGazer.TeleportOut.Grunt", Winterblight.Stargazer)
				end)
				Timers:CreateTimer(1.08, function()
					local pos = Winterblight.Stargazer:GetAbsOrigin()
					Winterblight.Stargazer:SetModelScale(0)
					local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, Winterblight.Stargazer)
					ParticleManager:SetParticleControl(pfx, 0, Winterblight.Stargazer:GetAbsOrigin())
					ParticleManager:SetParticleControl(pfx, 1, Vector(600, 2, 2))
					local pfx2 = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx2, 0, pos+Vector(0,0,80))
					ParticleManager:SetParticleControl(pfx2, 5, Vector(0.9, 0.9, 1.0))
					ParticleManager:SetParticleControl(pfx2, 2, Vector(0.8,0.8,0.8))
					EmitSoundOn("Winterblight.Pixie.Teleport", Winterblight.Stargazer)
					Timers:CreateTimer(0.2, function()
						UTIL_Remove(Winterblight.Stargazer)
					end)		
					local luck = RandomInt(1, 8-GameState:GetDifficultyFactor())
					if luck == 1 then
						RPCItems:RollStargazersSphere(pos)
					end
					Winterblight:LastBridgeAndCup()
				end)
			end)
		end)
		--WAVES END
	end
end

function Winterblight:LastBridgeAndCup()
	Timers:CreateTimer(0.5, function()
		Winterblight:RemoveBlockers(8.5, "LastAzaleaBridgeBlocker", Vector(-15944, -13162, 127+Winterblight.ZFLOAT), 5400)
		for i = 1, 300, 1 do
			Timers:CreateTimer(0.03*i, function()
				if i %40 == 0 then
					EmitSoundOnLocationWithCaster(Vector(-15944, -13162, 127+Winterblight.ZFLOAT), "Winterblight.AzaleaBridge.Raise", Events.GameMaster)
				end
				Winterblight.AzaleaBridge5:SetAbsOrigin(Winterblight.AzaleaBridge5:GetAbsOrigin()+Vector(0,0,3000/300))
			end)
		end
		Timers:CreateTimer(9, function()
			EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge5:GetAbsOrigin(), "Winterblight.AzaleaBridge.Finish", Winterblight.Master)
			Timers:CreateTimer(0.1, function()
				EmitSoundOnLocationWithCaster(Winterblight.AzaleaBridge5:GetAbsOrigin(), "Winterblight.Azalea.Win", Winterblight.Master)
			end)
			local positionTable = {Vector(-15900, -12160), Vector(-16028, -12160), Vector(-16156, -12160), Vector(-15900, -14968), Vector(-16028, -14968), Vector(-16156, -14968)}
            for i = 1, #positionTable, 1 do
              local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
              ParticleManager:SetParticleControl( pfx, 0, GetGroundPosition(positionTable[i], Events.GameMaster ))
              ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
              Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(pfx, false)
              end)
            end
		end)
		Timers:CreateTimer(12, function()
			Winterblight.StargazerSuccess = true
			Winterblight:SpawnCup6()
		end)
		Winterblight:SpawnMobsAtLastCup()
	end)
end

function Winterblight:StargazerWaveUnitSpawn(unit, jumpFV)
	local stone = unit
	if stone:GetUnitName() == "azalea_shrine_megmus" then
		Events:AdjustBossPower(stone, 5, 4, false)
		stone.itemLevel = 44
		stone.dominion = true
		stone.targetRadius = 600
		stone.autoAbilityCD = 1
		if Winterblight.Stones >= 1 then
			stone:AddAbility("luna_taskmaster_shield"):SetLevel(GameState:GetDifficultyFactor())
		end
		if Winterblight.Stones >= 2 then
			stone:AddAbility("ability_magic_immune_break"):SetLevel(GameState:GetDifficultyFactor())
		end
	elseif stone:GetUnitName() == "winterblight_rider_of_azalea" then
		if GameState:GetDifficultyFactor() < 3 then
			stone:RemoveAbility("armor_break_ultra")
		end
	elseif stone:GetUnitName() == "azalea_dragoon" then
		if Winterblight.Stones >= 1 then
			stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
		end
		if Winterblight.Stones >= 3 then
			stone:AddAbility("ability_stun_immunity"):SetLevel(GameState:GetDifficultyFactor())
		end
	elseif stone:GetUnitName() == "azalea_air_spirit" then
		Winterblight:SetPositionCastArgs(stone, 1000, 0, 3, FIND_ANY_ORDER)
	elseif stone:GetUnitName() == "azalea_grave_summoner" then
		stone.targetRadius = 1200
		stone.autoAbilityCD = 1
		stone.summons = 2
		stone.maxSummons = 2 + math.min(2, Winterblight.Stones)
	elseif stone:GetUnitName() == "winterblight_syphist" then
		if GameState:GetDifficultyFactor() == 3 then
			stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
		end
	elseif stone:GetUnitName() == "azalea_fencer" then
		if Winterblight.Stones >= 1 then
			stone:AddAbility("ability_magic_immune_break"):SetLevel(GameState:GetDifficultyFactor())
		end
		if Winterblight.Stones >= 3 then
			stone:AddAbility("ability_stun_immunity"):SetLevel(GameState:GetDifficultyFactor())
		end
		stone:AddNewModifier(stone, nil, "modifier_animation", {translate="run"})
		stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="run"})
	elseif stone:GetUpVector() == "azalea_star_seeker" then
		Events:ColorWearablesAndBase(stone, Vector(150,255,145))
	end
end

function Winterblight:SpawnWinterSpirit(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winter_snow_spirit", position, 0, 1, nil, fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 55
	stone.dominion = true
	return stone
end

function Winterblight:SpawnGigaIceRevenant(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("giga_ice_revenant", position, 7, 9, "Winterblight.GigaIceRevenant.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 55
	-- stone.dominion = true
	if Winterblight.Stones >= 1 then
		stone:RemoveAbility("fire_temple_steadfast")
		stone:AddAbility("redfall_mega_steadfast"):SetLevel(GameState:GetDifficultyFactor())
	end
	Events:ColorWearablesAndBase(stone, Vector(150,255,145))
	return stone
end

function Winterblight:SpawnMobsAtLastCup()
	local luck = RandomInt(1, 3)
	Winterblight:SpawnGigaIceRevenant(Vector(-15872, -15956), Vector(0,1))
	if luck == 1 then
		local positionTable = {Vector(-16000, -15488), Vector(-15723, -15488), Vector(-15360, -15794), Vector(-15360, -16076)}
		for i = 1, #positionTable, 1 do
			Winterblight:SpawnFencer(positionTable[i], Vector(0,1))
		end		
	elseif luck == 2 then
		local positionTable = {Vector(-16000, -15488), Vector(-15723, -15488), Vector(-15320, -15744), Vector(-15320, -16000), Vector(-15320, -16237), Vector(-16000, -15744), Vector(-15723, -15744)}
		for i = 1, #positionTable, 1 do
			Winterblight:SpawnRiftBreaker(positionTable[i], Vector(0,1))
		end		
	elseif luck == 3 then
		local positionTable = {Vector(-16000, -15488), Vector(-15723, -15488), Vector(-15320, -15744), Vector(-15320, -16000), Vector(-15320, -16237), Vector(-16000, -15744), Vector(-15723, -15744)}
		for i = 1, #positionTable, 1 do
			Winterblight:SpawnBladeWielder(positionTable[i], Vector(0,1))
		end	
	end
	local luck2 = RandomInt(1, 3)
	if luck2 == 1 then
		Winterblight:SpawnDemonSpirit(Vector(-14936, -15708), Vector(-1,0))
	end
	local luck2 = RandomInt(1, 3)
	if luck2 == 1 then
		Winterblight:SpawnDemonSpirit(Vector(-14704, -15979), Vector(-1,0))
	end
	local luck2 = RandomInt(1, 3)
	if luck2 == 1 then
		Winterblight:SpawnDemonSpirit(Vector(-14936, -16216), Vector(-1,0))
	end
	Timers:CreateTimer(1.0, function()
		for i = 0, 6, 1 do
			Winterblight:SpawnWinterSpirit(Vector(-15744+i*170, -16256), Vector(0,1))
		end
	end)
end

function Winterblight:SpawnAzaleaBoss()
	Winterblight.AzaleaBossMusic = true
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-218, -14701), 1200, 300, false)
	Timers:CreateTimer(10, function()
		for i = 1, #Winterblight.AzaleaBossStatue, 1 do
			local prop = Winterblight.AzaleaBossStatue[i]
			prop.model:SetAbsOrigin(prop.model:GetAbsOrigin()+Vector(0,0,0))
			prop.speed = 20
			prop.distanceMoved = 0
			Timers:CreateTimer(0.03, function()
				prop.speed = math.min(prop.speed + 1, 100)
				prop.distanceMoved = prop.distanceMoved + prop.speed
				prop.model:SetAbsOrigin(prop.model:GetAbsOrigin() - Vector(0,0,prop.speed))
				if prop.distanceMoved >= 2970 then
				else
					return 0.03
				end
			end) 
		end
		Timers:CreateTimer(1.95, function()
			local startPoint = GetGroundPosition(Winterblight.AzaleaBossStatue[1].model:GetAbsOrigin(), Events.GameMaster)
			EmitSoundOnLocationWithCaster(startPoint, "Winterblight.AzaleaBoss.Stuate.Land", Events.GameMaster)

			local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl(pfx, 0, startPoint)
			ParticleManager:SetParticleControl(pfx, 5, Vector(0.7, 0.75, 0.9))
			ParticleManager:SetParticleControl(pfx, 2, Vector(0.7,0.7,0.7))
			Timers:CreateTimer(10, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			  ParticleManager:ReleaseParticleIndex(pfx)
			end)
			ScreenShake(Winterblight.AzaleaBossStatue[1].model:GetAbsOrigin(), 800, 0.8, 0.8, 9000, 0, true)

			local damage = 1000
			local procs = 0
			for j = 0, procs, 1 do
				Timers:CreateTimer(j*0.5, function()
					for i = 0, 4, 1 do
						Timers:CreateTimer(0.15, function()

							local forkDirection = WallPhysics:rotateVector(Vector(-1,-1), 2*math.pi*i/5)
							local direction = forkDirection
							if j == 0 then
								EmitSoundOnLocationWithCaster(startPoint, "Winterblight.ArcanaSunder.Moving", Events.GameMaster)
							end

							local particleName = "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf"
							local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControl(pfx, 0, startPoint+forkDirection*50)
							ParticleManager:SetParticleControl(pfx, 1, startPoint+forkDirection*3000)
							ParticleManager:SetParticleControl(pfx, 3, Vector(200,3.5,200)) -- y COMPONENT = duration
							-- ParticleManager:SetParticleControl(pfx, 1, point)
							Timers:CreateTimer(3.5, function()
								ParticleManager:DestroyParticle(pfx, false)
								for i = 1, 3, 1 do
									EmitSoundOnLocationWithCaster(startPoint, "Winterblight.ArcanaSunder.Explode"..i, Events.GameMaster)
								end
								local enemies = FindUnitsInLine(DOTA_TEAM_NEUTRALS, startPoint, startPoint+forkDirection*3000, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
						        for _,enemy in pairs(enemies) do
						        	ApplyDamage({ victim = enemy, attacker = Events.GameMaster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = Winterblight.MasterAbility })	
						            Filters:ApplyStun(Events.GameMaster, 3, enemy)
						        end
							end)
						end)
					end
				end)
			end
		end)

		Timers:CreateTimer(5.65, function()
			local position = Winterblight.AzaleaBossStatue[1].model:GetAbsOrigin()
			for i = 1, #Winterblight.AzaleaBossStatue, 1 do
				UTIL_Remove(Winterblight.AzaleaBossStatue[i].model)
			end

			Winterblight.AzaleaBossStatue = nil
			local boss = Events:SpawnBoss("azalea_boss", position)
			boss:SetAcquisitionRange(5000)
			position = boss:GetAbsOrigin()
			StartSoundEvent("Winterblight.AzaleaBoss.Shatter", boss)
			local pfx2 = ParticleManager:CreateParticle( "particles/roshpit/winterblight/frost_colossus_slam.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx2, 0, position )
			ParticleManager:SetParticleControl( pfx2, 1, Vector(700, 700, 700) )
			local enemies = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then	
				for i = 1, #enemies, 1 do
					ApplyDamage({ victim = enemies[i], attacker = Events.GameMaster, damage = 5000, damage_type = DAMAGE_TYPE_PURE, ability = Winterblight.MasterAbility })	
					enemies[i]:AddNewModifier(victim, Events:GetGameMasterAbility(), "modifier_stunned", {duration = 3})
				end
			end		
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx2, false)
			end)
			for i = 0, 3, 1 do
				Timers:CreateTimer(0.1*i, function()
					local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,80+i*120))
					ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
					ParticleManager:SetParticleControl(pfx, 2, Vector(0.8,0.8,0.8))
					Timers:CreateTimer(10, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					  ParticleManager:ReleaseParticleIndex(pfx)
					end)
				end)
			end
			Timers:CreateTimer(1.6, function()
				EmitSoundOn("Winterblight.AzaleaBoss.Spawn.VO", boss)
				StartAnimation(boss, {duration=1.7, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.6, translate="immortal"})
			end)
			Timers:CreateTimer(2.8, function()
				StopSoundEvent("Winterblight.AzaleaBoss.Shatter", boss)
			end)
			boss:SetForwardVector(Vector(0,-1))
			Events:ColorWearables(boss, Vector(69, 171, 255))
			boss:SetRenderColor(160, 200, 255)
			Timers:CreateTimer(0, function()
				if not Winterblight.AzaleaBossSlain then
					for i = 1, #MAIN_HERO_TABLE, 1 do
						print("LETS GO")
						if MAIN_HERO_TABLE[i].bgm == "Winterblight.AzaleaBossMusic" then
							print("YEP")
						  CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
						  CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Winterblight.AzaleaBossMusic"})
						end
					end
					return 78
				end
			end)
		end)
	end)
end

function Winterblight:AzaleaBossDie(boss)
	boss.dying = true
	Winterblight.AzaleaBossSlain = true
	Winterblight.AzaleaBossMusic = false
	boss:RemoveModifierByName("modifier_azalea_spinning")
	local ability = boss:FindAbilityByName("azalea_boss_passive")
	
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_boss_dying", {})
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_boss_disarmed", {})
	EmitSoundOn("Winterblight.AzaleaBoss.Death1.VO", boss)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text="Dungeon Clear!", duration=8.0})
		local luck = RandomInt(1,3)
	end)
	local position = boss:GetAbsOrigin()
	for i = 1, 18, 1 do
		Timers:CreateTimer(0.3*i, function()
			RPCItems:RollItemtype(300, boss:GetAbsOrigin(), 1, 0)
		end)
	end
	Timers:CreateTimer(1, function()
		local arcanaLuck = RandomInt(1, 200-GameState:GetPlayerPremiumStatusCount()*10)
		if arcanaLuck == 1 then
			arcana = RPCItems:RollAstralArcana3(boss:GetAbsOrigin())
		end
		local luck2 = RandomInt(1,100-GameState:GetPlayerPremiumStatusCount()*1)
		if luck2 == 1 then
			Winterblight:DropBorealGraniteChunk(boss:GetAbsOrigin())
		end
	end)
	Timers:CreateTimer(3, function()
		local luck = RandomInt(1, 5)
		if luck == 1 then
			RPCItems:RollIceFloeSlippers(boss:GetAbsOrigin())
		end
	end)
	Timers:CreateTimer(5, function()
		local luck = RandomInt(1, 5)
		if luck == 1 then
			RPCItems:RollIronTreadsOfDestruction(boss:GetAbsOrigin())
		end
	end)
	for j = 1, 3+GameState:GetPlayerPremiumStatusCount()*2, 1 do
		Timers:CreateTimer(j*0.3, function()
			 Winterblight:DropGlacierStone(boss:GetAbsOrigin())
		end)
	end
	Timers:CreateTimer(6, function()
		for j = 1, Winterblight.Stones, 1 do
			Timers:CreateTimer(j, function()
				RPCItems:DropSynthesisVessel(boss:GetAbsOrigin())
			end)
		end
	end)
	Timers:CreateTimer(8, function()
		EmitSoundOn("Winterblight.AzaleaBoss.Death2.VO", boss)
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {})
		boss:RemoveModifierByName("modifier_boss_dying")
		Timers:CreateTimer(0.03, function()
			StartAnimation(boss, {duration=10, activity=ACT_DOTA_DIE, rate=0.24})
		end)
		Timers:CreateTimer(5, function()
			local position = boss:GetAbsOrigin()
			ability:ApplyDataDrivenModifier(boss, boss, "modifier_boss_frozen", {})
			Timers:CreateTimer(6.5, function()
				Winterblight:objectShake(boss, 48, 15, true, true, true, "Winterblight.AzaleaBoss.DeathShaking", 24)
				-- Events:smoothSizeChange(boss, boss:GetModelScale(), boss:GetModelScale()-0.5, 5)
			end)
			Timers:CreateTimer(8, function()
				for i = 0, 3, 1 do
					Timers:CreateTimer(0.1*i, function()
						local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,80+i*120))
						ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
						ParticleManager:SetParticleControl(pfx, 2, Vector(0.8,0.8,0.8))
						Timers:CreateTimer(10, function() 
						  ParticleManager:DestroyParticle( pfx, false )
						  ParticleManager:ReleaseParticleIndex(pfx)
						end)
					end)
				end
				EmitSoundOn("Winterblight.AzaleaBoss.FinalShatter", boss)
			    local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			    local radius = 800
			    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )
			    ParticleManager:SetParticleControl( particle1, 0, boss:GetAbsOrigin() )
			    ParticleManager:SetParticleControl( particle1, 1, Vector(radius, 1, 1000) )
			    ParticleManager:SetParticleControl( particle1, 3, Vector(radius, radius, radius) )
			    Timers:CreateTimer(3, function()
			        ParticleManager:DestroyParticle(particle1, false)
			    end)
				UTIL_Remove(boss)
			end)
		end)
	end)
	Timers:CreateTimer(15, function()
		Winterblight:MithrilReward(position)
	end)

end

function Winterblight:SpawnAzheran(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azheran_iceblood", position, 4, 8, "Winterblight.Azheran.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 70
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate="walk"})
	Events:ColorWearablesAndBase(stone, Vector(0, 255, 255))
    local newHealth = 500
    if GameState:GetDifficultyFactor() == 2 then
    	newHealth = 1000
    elseif GameState:GetDifficultyFactor() == 3 then
    	newHealth = 2000
    end
    stone:SetMaxHealth(newHealth)
    stone:SetBaseMaxHealth(newHealth)
    stone:SetHealth(newHealth)
	return stone
end

function Winterblight:SpawnOrthok(position, fv, phase)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_orthok_the_damned", position, 4, 8, nil, fv, true)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 70
	stone.phase = phase
	Events:ColorWearablesAndBase(stone, Vector(0, 255, 255))
	if phase == 2 then
		local ability = stone:FindAbilityByName("orthok_ai_ability")
		ability:ApplyDataDrivenModifier(stone, stone, "modifier_orthok_blue", {})
		stone:AddAbility("orthok_split_attack"):SetLevel(GameState:GetDifficultyFactor())
	end
end

function Winterblight:InitializeOrthok()
	local position = Winterblight:GetRandomOrthokPosition()
	Winterblight:SpawnOrthok(position, Vector(0,-1), 1)
end

function Winterblight:GetRandomOrthokPosition()
	local luck = RandomInt(1,8)
	local position = nil
	if luck == 1 then
		position = Winterblight:GetRandomPixieLocation() + RandomVector(RandomInt(1, 400))
	elseif luck == 2 then
		position = Vector(-8374, -13771) + Vector(RandomInt(0, 3400), RandomInt(0, 1680))
	elseif luck == 3 then
		local posTable = {Vector(-3840, -15250), Vector(-3840, -14750), Vector(-3840, -14250), Vector(-3840, -13750), Vector(-3840, -13250), Vector(-3840, -12750), Vector(-3840, -12250), Vector(-3840, -11750), Vector(-3840, -11250), Vector(-3840, -10750), Vector(-3840, -15872), Vector(-3262, -15872), Vector(-2729, -15872), Vector(-2729, -15184), Vector(-3268, -15184), Vector(-3269, -14485), Vector(-2729, -14485), Vector(-2729, -13848), Vector(-2729, -13105), Vector(-3251, -13105), Vector(-3251, -12480), Vector(-2729, -12480), Vector(-3277, -11787), Vector(-2586, -11787), Vector(-1930, -11787), Vector(-1930, -11126), Vector(-2612, -11126), Vector(-3297, -11126), Vector(-3297, -10372), Vector(-2582, -10372), Vector(-1934, -10372), Vector(-5969, -15990), Vector(-5969, -15408), Vector(-5285, -15990), Vector(-5285, -15408), Vector(-4608, -15990), Vector(-4608, -15408)}
		position = posTable[RandomInt(1, #posTable)] + RandomVector(240)
	elseif luck == 4 then
		position = Vector(-1471, -15744) + Vector(RandomInt(0, 2600), RandomInt(0, 2300))
	elseif luck == 5 then
		position = Vector(2560, -16000) + Vector(RandomInt(0, 3300), RandomInt(0, 2100))
	elseif luck == 6 then
		local luck2 = RandomInt(1, 2)
		if luck2 == 1 then
			position = Vector(7040, -15872) + Vector(RandomInt(0, 1200), RandomInt(0, 900))
		elseif luck2 == 2 then
			position = Vector(10880, -15959) + Vector(RandomInt(0, 1300), RandomInt(0, 900))
		end
	elseif luck == 7 then
		position = Vector(6869, -13881) + Vector(RandomInt(0, 1600), RandomInt(0, 3600))
	elseif luck == 8 then
		position = Vector(14336, -11826) + Vector(RandomInt(0, 1300), RandomInt(0, 1300))
	end
	return position
end

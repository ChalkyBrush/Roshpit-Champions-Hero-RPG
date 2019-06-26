function Tanari:SpawnOutsideWaterTemple()
	Tanari:SpawnWaterBug(Vector(-4980, 5824), Vector(1,-0.4))
	Tanari:SpawnWaterBug(Vector(-4326, 5750), Vector(0.2,-1))
	Tanari:SpawnWaterBug(Vector(-3920, 6052), Vector(0,-1))
	Tanari:SpawnWaterBug(Vector(-3456, 4992), Vector(-1,-0.2))

	Tanari:SpawnRazorfishCaptain(Vector(-1984, 5312), Vector(0,1))
	Tanari:SpawnRazorfishCaptain(Vector(-1792, 5440), Vector(-1,1))
	Timers:CreateTimer(2, function()
		Tanari:SpawnRazorfishCaptain(Vector(-1984, 6272), Vector(-1,-1))
		Tanari:SpawnRazorfishCaptain(Vector(-1472, 6400), Vector(0,-1))
		Tanari:SpawnRazorfishIrritable(Vector(-1728, 6336), Vector(0,-1))
		Tanari:SpawnRazorfishIrritable(Vector(-1664, 6144), Vector(-1,-1))
		Tanari:SpawnRazorfishIrritable(Vector(-1408, 6174), Vector(-1,-1))
	end)
	Timers:CreateTimer(4, function()
		local patrolPoint1 = Vector(-2698, 7616)
		local patrolPoint2 = Vector(-2048, 8080)
		local patrolPoint3 = Vector(-1728, 7232)
		local ancient = Tanari:SpawnTanariAncient(patrolPoint3, RandomVector(1))
		ancient.patrolPositionTable = {patrolPoint1, patrolPoint2, patrolPoint3}
		local ancient2 = Tanari:SpawnTanariAncient(patrolPoint1, RandomVector(1))
		ancient2.patrolPositionTable = {patrolPoint2, patrolPoint3, patrolPoint1}
		local ancient3 = Tanari:SpawnTanariAncient(patrolPoint2, RandomVector(1))
		ancient3.patrolPositionTable = {patrolPoint3, patrolPoint1, patrolPoint2}
	end)
	Timers:CreateTimer(6, function()
		
		Tanari:SpawnSlithereenGuard(Vector(-2560, 9412), Vector(0, -1), false)
		Tanari:SpawnSlithereenGuard(Vector(-1683, 9412), Vector(0, -1), false)
		Tanari:SpawnSlithereenFeatherguard(Vector(-1856, 9392), Vector(0,-1), false)
		Tanari:SpawnSlithereenFeatherguard(Vector(-2368, 9392), Vector(0,-1), false)
		Tanari:SpawnSlithereenRoyalGuard(Vector(-2112, 9412), Vector(0, -1), false)
	end)
	Timers:CreateTimer(3, function()
		local music = "Ambient.OutsideWaterTemple"
		EmitSoundOnLocationWithCaster(Vector(-2496, 7296), music, Events.GameMaster)
		return 60	
	end)
end

function Tanari:SpawnWaterBug(position, fv)
	local guard = Tanari:SpawnDungeonUnit("tanari_water_bug", position, 0, 2, "Tanari.WaterBugAggro", fv, false)
	guard.itemLevel = 45
	guard:SetRenderColor(180, 255, 255)
	guard.dominion = true
	return guard
end

function Tanari:SpawnRazorfishCaptain(position, fv)
	local fish = Tanari:SpawnDungeonUnit("swamp_razorfish_captain", position, 0, 2, "slark_slark_anger_02", fv, false)
	fish.itemLevel = 48
	fish.dominion = true
	return fish
end

function Tanari:SpawnRazorfishIrritable(position, fv)
	local fish = Tanari:SpawnDungeonUnit("swamp_razorfish_irritable", position, 0, 2, "slark_slark_anger_01", fv, false)
	fish.itemLevel = 48
	fish.dominion = true
	return fish
end

function Tanari:SpawnTanariAncient(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("tanari_ancient", position, 2, 4, "Tanari.AncientAggro", fv, false)
	ancient.itemLevel = 60
	ancient.patrolSlow = 30
	ancient.phaseIntervals = 4
	ancient.patrolPointRandom = 100
	ancient.dominion = true
	return ancient
end

function Tanari:InitializeWaterTemple()
	Tanari:WaterTempleWalls()
	Tanari.WaterTemple = {}
	Tanari.WaterTemple.Initialized = true
	Dungeons.respawnPoint = Vector(-1221, 10893)
	Timers:CreateTimer(7, function()
		EmitGlobalSound("Tanari.TempleStart")
	end)
		Timers:CreateTimer(10, function()
			local music = "Tanari.WaterTemple.Music"
			local VectorTable = {Vector(-1664, 14464, 300), Vector(-4992, 14464, 300), Vector(-4992, 10671, 300), Vector(9801, 14050, 90), Vector(-8000, 15264, 800), Vector(-8819, 10816, 300), Vector(-5824, 10816, 300), Vector(-7529, 8734, 300), Vector(-7975, 5376, 300), Vector(-7092, 5121, 250), Vector(-13440, 13866), Vector(-13440, 8852), Vector(-13440, 3904)}
			for i = 1, #VectorTable, 1 do
				EmitSoundOnLocationWithCaster(VectorTable[i], music, Events.GameMaster)
			end
			EmitSoundOnLocationWithCaster(Vector(-7092, 5121, 250), "Tanari.WaterTemple.Endloop", Events.GameMaster)
			if not Tanari.WaterTemple.BossBattleBegun then
				return 105
			end
		end)
		Tanari:SpawnWaterVaultLord(Vector(-4480, 10048), Vector(1,0))
		Tanari:SpawnWaterVaultLord(Vector(-4288, 10304), Vector(1,0))
		Tanari:SpawnWaterVaultLord(Vector(-4352, 10624), Vector(1,0))
		Tanari:SpawnWaterVaultLord(Vector(-4288, 10944), Vector(1,0))
		Tanari:SpawnWaterVaultLord(Vector(-4480, 11200), Vector(1,0))
		Timers:CreateTimer(2, function()
			local patrolPoint1 = Vector(-4416, 11712)
			local patrolPoint2 = Vector(-4544, 9472)
			local patrolPoint3 = Vector(-5632, 10624)
			local unitTable = {}
			local unit = Tanari:SpawnShark(patrolPoint1, RandomVector(1))
			table.insert(unitTable, unit)
			unit = Tanari:SpawnSlithereenFeatherguard(patrolPoint1, Vector(-1,0), false)
			table.insert(unitTable, unit)
			unit = Tanari:SpawnSlithereenGuard(patrolPoint1, Vector(-1, 0), false)
			table.insert(unitTable, unit)
			for i = 1, #unitTable, 1 do
				unitTable[i].patrolSlow = 40
				unitTable[i].phaseIntervals = 5
				unitTable[i].patrolPointRandom = 300
				unitTable[i].patrolPositionTable = {patrolPoint2, patrolPoint3, patrolPoint1}
				unitTable[i]:AddAbility("monster_patrol"):SetLevel(1)
			end

			unitTable = {}
			unit = Tanari:SpawnShark(patrolPoint2, RandomVector(1))
			table.insert(unitTable, unit)
			unit = Tanari:SpawnSlithereenFeatherguard(patrolPoint2, Vector(-1,0), false)
			table.insert(unitTable, unit)
			unit = Tanari:SpawnShark(patrolPoint2, RandomVector(1))
			table.insert(unitTable, unit)
			for i = 1, #unitTable, 1 do
				unitTable[i].patrolSlow = 40
				unitTable[i].phaseIntervals = 5
				unitTable[i].patrolPointRandom = 300
				unitTable[i].patrolPositionTable = {patrolPoint3, patrolPoint1, patrolPoint2}
				unitTable[i]:AddAbility("monster_patrol"):SetLevel(1)
			end

			unitTable = {}
			unit = Tanari:SpawnShark(patrolPoint3, RandomVector(1))
			table.insert(unitTable, unit)
			unit = Tanari:SpawnSlithereenGuard(patrolPoint3, Vector(-1, 0), false)
			table.insert(unitTable, unit)
			unit = Tanari:SpawnSlithereenGuard(patrolPoint3, Vector(-1, 0), false)
			table.insert(unitTable, unit)
			for i = 1, #unitTable, 1 do
				unitTable[i].patrolSlow = 40
				unitTable[i].phaseIntervals = 5
				unitTable[i].patrolPointRandom = 300
				unitTable[i].patrolPositionTable = {patrolPoint1, patrolPoint2, patrolPoint3}
				unitTable[i]:AddAbility("monster_patrol"):SetLevel(1)
			end
		end)
		local shield = CreateUnitByName("npc_flying_dummy_vision", Vector(-4480, 12487, 500), false, nil, nil, DOTA_TEAM_NEUTRALS)
		shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
		shield:SetOriginalModel("models/water_temple_shield.vmdl")
		shield:SetModel("models/water_temple_shield.vmdl")
		shield:SetAbsOrigin(Vector(-4480, 12487, 700))
		shield:AddAbility("water_temple_shield_ability"):SetLevel(1)
		shield:RemoveAbility("dummy_unit")
		shield:RemoveModifierByName("dummy_unit")
		shield:SetRenderColor(160, 160, 160)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-4480, 12216, 300), 500, 99999, false)
		Tanari.WaterTemple.shield = shield
	-- Timers:CreateTimer(9, function()
	-- 	local music = "Tanari.WaterTemple.Intro"
	-- 	EmitSoundOnLocationWithCaster(Vector(-4736, 10816, 200), music, Events.GameMaster)

	-- end)
end

function Tanari:WaterTempleWalls()
	local movementZ = -4.00
	Timers:CreateTimer(5, function()
		local walls = Entities:FindAllByNameWithin("WaterTempleMainDoor", Vector(-2659,11136,208), 600)
		Timers:CreateTimer(0.1, function()
			EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
		end)
		for i = 1, 90, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end)
	Timers:CreateTimer(8, function()
		local blockers = Entities:FindAllByNameWithin("WaterTempleWall", Vector(-2663,11136,200), 900)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)
end

function Tanari:SpawnWaterVaultLord(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_vault_lord", position, 1,2, "Tanari.WaterTemple.VaultLordAggro", fv, false)
	Events:AdjustBossPower(lord, 1, 1)
	lord.itemLevel = 58
	lord.targetRadius = 400
	lord.autoAbilityCD = 0.5
	lord:SetRenderColor(40, 40, 255)
	lord.dominion = true
end

function Tanari:SpawnShark(position, fv)
	local shark = Tanari:SpawnDungeonUnit("water_temple_shark", position, 1,2, "slark_slark_shadow_dance_0"..RandomInt(1,4), fv, false)
	Events:AdjustBossPower(shark, 1, 1)
	shark.itemLevel = 58
	shark.targetRadius = 600
	shark.autoAbilityCD = 0.5
	shark:SetRenderColor(170, 170, 255)
	shark.dominion = true
	return shark
end

function Tanari:OpenShieldWall(shield)
	Tanari:WaterTemplePart2()
	for i = 1, 30, 1 do
		Timers:CreateTimer(i*0.03, function()
			shield:SetAngles(i*1.2, 0, 0)
		end)
	end
	Timers:CreateTimer(0.27, function()
		EmitSoundOn("Tanari.WaterTemple.ShieldCreak", shield)
	end)
	Timers:CreateTimer(0.9, function()
		for i = 1, 10, 1 do
			Timers:CreateTimer(i*0.03, function()
				shield:SetAbsOrigin(shield:GetAbsOrigin()-Vector(0,0,40))
			end)
		end
	end)
	Timers:CreateTimer(1.2, function()
		local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
	    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, shield)
	    for k = 0, 4, 1 do
	    	ParticleManager:SetParticleControl(pfx,k,shield:GetAbsOrigin()+Vector(0,0,100) )
		end
	    Timers:CreateTimer(1.25, function()
	    	ParticleManager:DestroyParticle(pfx, false)
	    end)
		EmitSoundOn("Tanari.WaterTemple.ShieldFall", shield)
		for i = 1, 10, 1 do
			Timers:CreateTimer(i*0.03, function()
				shield:SetAngles(32+i*7, i*3, i*7)
				shield:SetAbsOrigin(shield:GetAbsOrigin()-Vector(0,16,0))
			end)
		end
	end)
	Timers:CreateTimer(1.0, function()
		local movementZ = -6
		Timers:CreateTimer(0.5, function()
			local walls = Entities:FindAllByNameWithin("WaterTempleWall1", Vector(-4488,12567,100), 600)
			Timers:CreateTimer(0.1, function()
				EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
			end)
			for i = 1, 90, 1 do
				for j = 1, #walls, 1 do
					Timers:CreateTimer(i*0.03, function()
						walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
						walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
						if j == 1 then
							ScreenShake(walls[j]:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
						end
					end)
				end
			end
		end)
		Timers:CreateTimer(2.6, function()
			local blockers = Entities:FindAllByNameWithin("WaterTempleWallBlock1", Vector(-4399,12480,119), 900)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
				-- UTIL_Remove(shield)
			end
		end)
	end)
end

function Tanari:WaterTemplePart2()
	Tanari:SpawnWaterVaultLord(Vector(-4672, 13760), Vector(0,-1))
	Tanari:SpawnWaterVaultLord(Vector(-4224, 13760), Vector(0,-1))
	Tanari:SpawnWaterVaultLord(Vector(-4480, 13440), Vector(0,-1))
	Tanari:SpawnSlithereenRoyalGuard(Vector(-4480, 13085), Vector(0, -1), false)
	Tanari:SpawnAquaMage(Vector(-3508, 13228), Vector(-1,1))
	Tanari:SpawnAquaMage(Vector(-3264, 13515), Vector(-1,0))
	Timers:CreateTimer(2, function()
		Tanari:SpawnShark(Vector(-1920, 13376), Vector(-1,-1))
		local VectorTable = {Vector(-2368, 12672), Vector(-1984, 12672), Vector(-2304, 12864), Vector(-2053, 12928), Vector(-2432, 13056), Vector(-2176, 13312), Vector(-2112, 13696), Vector(-1792, 13568), Vector(-1472, 13760)}
		for i = 1, #VectorTable, 1 do
			Timers:CreateTimer(i*0.1, function()
				Tanari:SpawnBeachHermitShell(RandomVector(1), VectorTable[i])
			end)
		end
	end)
	Timers:CreateTimer(4.5, function()
		Tanari:SpawnJellyfishBoss()
	end)
	Timers:CreateTimer(6, function()
		Tanari:SpawnTentacleSwitches()
		Tanari:RotateOctopusStatueColors()
	end)
end

function Tanari:SpawnAquaMage(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_temple_aqua_mage", position, 1,3, "Tanari.WaterTemple.AquaMageAggro", fv, false)
	mage.itemLevel = 60
	mage:SetRenderColor(80, 80, 240)
	Events:AdjustBossPower(mage, 5, 5)
	mage.dominion = true
end


function Tanari:SpawnBeachHermitShell(fv, position)
	local shell = Tanari:SpawnDungeonUnit("water_temple_beach_hermit", position, 1, 3, "bristleback_bristle_anger_02", fv, false)
	shell.fv = fv
	shell:SetForwardVector(-fv)

	shell:SetAbsOrigin(shell:GetAbsOrigin()-Vector(0,0,100))
	shell:SetModelScale(1.4)
	shell:AddAbility("terrasic_boulderspine_shell_ai"):SetLevel(1)
	shell.dominion = true
end

function Tanari:SpawnBeachHermit(spine)
	-- local spine = Tanari:SpawnDungeonUnit("terrasic_boulderspine", position, 1, 3, "bristleback_bristle_anger_03", fv, true)
	spine:SetAbsOrigin(spine:GetAbsOrigin() - Vector(0,0,100))
	spine:RemoveAbility("terrasic_boulderspine_shell_ai")
	spine:RemoveModifierByName("modifier_boulderspine_shell_ai")
	StartAnimation(spine, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
	WallPhysics:Jump(spine, Vector(1,1), 0, 32, 25, 1.5)
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

function Tanari:SpawnJellyfishBoss()
	local jellyfish = CreateUnitByName("water_temple_boss_jellyfish", Vector(-664, 15616), false, nil, nil, DOTA_TEAM_NEUTRALS)
	jellyfish:SetForwardVector(Vector(0,-1))
	jellyfish.itemLevel = 60
	Events:AdjustBossPower(jellyfish, 4, 4)
	Tanari.WaterTemple.jellyfish = jellyfish
end

function Tanari:ElectrocuteUnit(caster, ability, unit, vKnockback)
	if not unit:HasModifier("modifier_lightning_stun") then
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_lightning_stun", {duration = 1.2})
		EmitSoundOn("Tanari.WaterTemple.ElectricStun", unit)
		ScreenShake(unit:GetAbsOrigin(), 200, 0.1, 0.1, 200, 0, true)
			Timers:CreateTimer(1.2, function()
				
				local mult = 0.3
				if GameState:GetDifficultyFactor() == 2 then
					mult = 0.2
				elseif GameState:GetDifficultyFactor() == 1 then
					mult = 0.1
				end
				if unit:GetUnitName() == "npc_dota_hero_phantom_assassin" then
					mult = mult/3
				end
				local damage = unit:GetMaxHealth()*mult
				ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
				-- PopupDamage(unit, damage)
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_water_temple_lightning_immune", {duration = 1.2})
				if vKnockback then
					StartAnimation(unit, {duration=0.6, activity=ACT_DOTA_FLAIL, rate=2})
					WallPhysics:Jump(unit, vKnockback, 16, 16, 20, 1.5)
				end
				EmitSoundOn("Tanari.WaterTemple.ElectricStunEnd", unit)
		end)
	end

end

function jelly_lightning_stun_start(event)
	local target = event.target
	StartAnimation(target, {duration=1.2, activity=ACT_DOTA_FLAIL, rate=2.6})
end

function Tanari:LowerWaterTempleWall(movementZ, wallName, wallPosition, blockerName, blockerPosition, blockerSearchRadius, bOpen, bGeneric)
		Timers:CreateTimer(0.5, function()
			local searchHeight = 0
			if not bOpen then
				searchHeight = -600
			end
			local walls = Entities:FindAllByNameWithin(wallName, wallPosition+Vector(0,0,searchHeight), 400)
			if #walls > 0 then
				Timers:CreateTimer(0.1, function()
					EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
				end)
				for i = 1, 90, 1 do
					for j = 1, #walls, 1 do
						Timers:CreateTimer(i*0.03, function()
							walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
							walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
							if j == 1 then
								ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
							end
						end)
					end
				end
			end
		end)
		--print(bGeneric)
		Timers:CreateTimer(2.6, function()
			if bOpen then
				local blockers = Entities:FindAllByNameWithin(blockerName, blockerPosition, blockerSearchRadius)
				if #blockers == 0 then
					if Tanari.WaterTemple.wallDown == 1 then
						blockers = Tanari.WaterTemple.mazeEntrance1Blockers
					elseif Tanari.WaterTemple.wallDown == 2 then
						blockers = Tanari.WaterTemple.mazeEntrance2Blockers
					elseif Tanari.WaterTemple.wallDown == 3 then
						blockers = Tanari.WaterTemple.mazeEntrance3Blockers
					end
				end
				-- if bGeneric then
				-- 	--print("IN B GENERIC")
				-- 	--print(Vector(wallPosition.x,wallPosition.y, 128))
				-- 	--print(blockerSearchRadius)
				-- 	blockers = Entities:FindAllByClassnameWithin("point_simple_obstruction", Vector(wallPosition.x,wallPosition.y, 128), blockerSearchRadius)
				-- end
				--print("blockers")
				--print(blockers)
				for i = 1, #blockers, 1 do
					--print(blockers[i]:GetClassname())
					if blockers[i]:GetClassname() == "point_simple_obstruction" then
						UTIL_Remove(blockers[i])
					end
					-- UTIL_Remove(shield)
				end

			end
		end)
		if not bOpen then
			if wallPosition.y == 14540 then				
				Tanari.WaterTemple.mazeEntrance1Blockers = {}
			elseif wallPosition.y == 15296 then
				Tanari.WaterTemple.mazeEntrance2Blockers = {}
			elseif wallPosition.y == 16064 then
				Tanari.WaterTemple.mazeEntrance3Blockers = {}
			end
			
			for i = -2, 2, 1 do
				--print("SPAWN BLOCKERS AT VV")
				--print(Vector(wallPosition.x,wallPosition.y+(i*128), 128))
				local entity = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(wallPosition.x,wallPosition.y+(i*128), 128), name ="MazeBlocker"})
				if wallPosition.y == 14540 then				
					table.insert(Tanari.WaterTemple.mazeEntrance1Blockers, entity)
				elseif wallPosition.y == 15296 then
					table.insert(Tanari.WaterTemple.mazeEntrance2Blockers, entity)
				elseif wallPosition.y == 16064 then
					table.insert(Tanari.WaterTemple.mazeEntrance3Blockers, entity)
				end
			end
		end
end

function Tanari:SpawnPrisonGuard(position, fv)
	local shark = Tanari:SpawnDungeonUnit("water_temple_prison_guard", position, 1,2, "slark_slark_anger_0"..RandomInt(1,4), fv, false)
	Events:AdjustBossPower(shark, 2, 2)
	shark.itemLevel = 58
	shark.targetRadius = 300
	shark.autoAbilityCD = 1
	shark:SetRenderColor(170, 170, 255)
	shark.dominion = true
	return shark
end

function Tanari:SpawnExecutioner(position, fv)
	local shark = Tanari:SpawnDungeonUnit("water_temple_executioner", position, 1,3, "Tanari.WaterTemple.ExecutionerAggro", fv, false)
	Events:AdjustBossPower(shark, 2, 2)
	shark:SetRenderColor(100, 100, 255)
	shark.itemLevel = 60
	shark.dominion = true
	return shark
end

function Tanari:SpawnElectricRoomMobs()
	local bottomleftPos = Vector(-3136, 14272)
	for i = 1, 10+(GameState:GetDifficultyFactor()*4), 1 do
		Timers:CreateTimer(i*0.2, function()
			local randomX = RandomInt(0,2700)
			local randomY = RandomInt(0, 1600)
			Tanari:SpawnEnemyUnit("water_temple_regular_jellyfish", bottomleftPos+Vector(randomX, randomY), RandomVector(1))
		end)
	end
	Tanari:SpawnShark(Vector(-3520, 14400), Vector(0,1))
	if GameState:GetDifficultyFactor() >= 2 then
		Tanari:SpawnShark(Vector(-2340, 14339), Vector(-1,0))
	end
	if GameState:GetDifficultyFactor() >= 3 then
		Tanari:SpawnShark(Vector(-1330, 14412), Vector(-1,0))
	end
	Tanari:SpawnAquaMage(Vector(-640, 14848), Vector(0,-1))
end

function Tanari:WaterTemplePrisonRoom()
	if not Tanari.WaterTemple then
		Tanari.WaterTemple = {}
	end
	Tanari.WaterTemple.wallDown = false
	Tanari.WaterTemple.wallDropping = false
	Tanari.WaterTemple.mazeEntrance1Blockers = {}
	Tanari.WaterTemple.mazeEntrance2Blockers = {}
	Tanari.WaterTemple.mazeEntrance3Blockers = {}
	Tanari:SpawnPrisonGuard(Vector(-5504, 14656), Vector(1,1))
	Tanari:SpawnPrisonGuard(Vector(-6016, 14784), Vector(1,0))
	Tanari:SpawnPrisonGuard(Vector(-5376, 15424), Vector(1,0))
	Tanari:SpawnPrisonGuard(Vector(-5985, 15360), Vector(1,-0.2))
	Tanari:SpawnPrisonGuard(Vector(-5888, 15936), Vector(1,-1))
	Tanari:SpawnWaterVaultLord(Vector(-5824, 14976), Vector(1,0.2))
	Timers:CreateTimer(5, function()
		Tanari:SpawnExecutioner(Vector(-6749, 14536), Vector(1, 0))
		Tanari:SpawnExecutioner(Vector(-6749, 15281), Vector(1, 0))
		Tanari:SpawnExecutioner(Vector(-6749, 16284), Vector(1, 0))
	end)
	Timers:CreateTimer(9, function()
		Tanari:SpawnPrisonMobs()
	end)
	Timers:CreateTimer(15, function()
		if Events.SpiritRealm then
			Tanari:SpawnWaterSpirit(Vector(-9901, 16128), Vector(0,-1))
		end
		Tanari:SpawnJailer(Vector(-9728, 12416), Vector(0,1))
		Tanari:InitializeRascals()
	end)
end

function Tanari:SpawnPrisonMobs()
	
	local baseCellCenter = Vector(-9024, 16064)
	local yOffset = -800
	local xOffset = 800
	for i = 0, 2, 1 do
		for j = 0, 2, 1 do
			local spawnUnit = true
			if j == 0 then
				local roomOpen = false
				for p = 1, #Tanari.TopRowOpenRooms, 1 do
					if i+1 == Tanari.TopRowOpenRooms[p] then
						roomOpen = true
					end
				end
				if not roomOpen then
					spawnUnit = false
				end
			end
			if spawnUnit then
				local spawnCount = 2
				if i == 0 then
					spawnCount = RandomInt(3, 4)
				end
				for k = 1, spawnCount, 1 do
					Timers:CreateTimer(k*2, function()
						Tanari:SpawnRandomPrisonMob(baseCellCenter+Vector(xOffset*i, yOffset*j))
					end)
				end
			end
		end
	end
end

function Tanari:SpawnRandomPrisonMob(position)
	position = position+RandomVector(RandomInt(160, 280))
	local unitTable = {"shark", "prison_guard", "vault_lord", "cave_lizard", "executioner", "slithereen_guard", "executioner", "prison_guard"}
	local randomIndex = RandomInt(1, #unitTable)
	local randomUnitAlias = unitTable[randomIndex]
	if randomUnitAlias == "shark" then
		Tanari:SpawnShark(position, Vector(1,0))
	elseif randomUnitAlias == "prison_guard" then
		Tanari:SpawnPrisonGuard(position, Vector(1, 0))
	elseif randomUnitAlias == "vault_lord" then
		Tanari:SpawnWaterVaultLord(position, Vector(1,0))
	elseif randomUnitAlias == "cave_lizard" then
		Tanari:SpawnCaveLizard(position, Vector(1, 0))
	elseif randomUnitAlias == "executioner" then
		Tanari:SpawnExecutioner(position, Vector(1, 0))
	elseif randomUnitAlias == "slithereen_guard" then
		Tanari:SpawnSlithereenGuard(position, Vector(1, 0), false)
	end
end

function Tanari:SpawnJailer(position, fv)
	local shark = Tanari:SpawnDungeonUnit("water_temple_jailer", position, 3,5, "pudge_pud_attack_09", fv, false)
	Events:AdjustBossPower(shark, 4, 4)
	shark:SetRenderColor(64, 138, 55)
	shark.itemLevel = 64
	
end

function Tanari:SetupMaze()
	--horizontal walls
	Tanari.TopRowOpenRooms = {}
	local column2 = 0
	for i = 1, 3, 1 do
		local luck = RandomInt(1,2)
		if i == 3 then
			if column2 == 1 then
				luck = 2
			else
				luck = 1
			end
		end
		local xPos = 0
		local yPos = 0
		if i == 1 then
			xPos = -9024
		elseif i == 2 then
			xPos = -8256
		elseif i == 3 then
			xPos = -7488
		end
		if luck == 1 then
			yPos = 15680
			table.insert(Tanari.TopRowOpenRooms, i)
		elseif luck == 2 then
			yPos = 14923
		end
		if i == 2 then
			column2 = luck
		end
		local wallPosition = Vector(xPos, yPos, 8)
		local wall = Entities:FindByNameNearest("MazeWallHoriz", wallPosition+Vector(0,0,200), 400)
		UTIL_Remove(wall)
		local blockers = Entities:FindAllByNameWithin("MazeBlockerHorizontal", Vector(wallPosition.x, wallPosition.y, 328), 400)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end
	--vertical walls
	for i = 1, 3, 1 do
		local remove1 = RandomInt(1, 3)
		local remove2 = RandomInt(1,3)
		while remove1 == remove2 do
			remove2 = RandomInt(1,3)
		end
		local xPos = 0
		local yPos = 0
		local zPos = -96
		if i == 1 then
			xPos = -9408
			zPos = 144
		elseif i == 2 then
			xPos = -8632
		elseif i == 3 then
			xPos = -7104
		end
		if remove1 == 1 or remove2 == 1 then
			local wallPosition = Vector(xPos, 16064, zPos)
			local wall = Entities:FindByNameNearest("MazeWallVert", wallPosition+Vector(0,0,200), 400)
			UTIL_Remove(wall)
			local blockers = Entities:FindAllByNameWithin("MazeBlocker", Vector(wallPosition.x, wallPosition.y, 328), 400)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end
		if remove1 == 2 or remove2 == 2 then
			local wallPosition = Vector(xPos, 15296, zPos)
			local wall = Entities:FindByNameNearest("MazeWallVert", wallPosition+Vector(0,0,200), 400)
			UTIL_Remove(wall)
			local blockers = Entities:FindAllByNameWithin("MazeBlocker", Vector(wallPosition.x, wallPosition.y, 328), 400)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end
		if remove1 == 3 or remove2 == 3 then
			local wallPosition = Vector(xPos, 14495, zPos)
			local wall = Entities:FindByNameNearest("MazeWallVert", wallPosition+Vector(0,0,200), 400)
			UTIL_Remove(wall)
			local blockers = Entities:FindAllByNameWithin("MazeBlocker", Vector(wallPosition.x, wallPosition.y, 328), 400)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end
	end

end

function Tanari:OpenPrisonGate()
	if not Tanari.WaterTemple then
		Tanari.WaterTemple = {}
	end
	EmitSoundOnLocationWithCaster(Vector(-8822, 12433, 120), "Tanari.WaterTemple.PrisonGateOpen", Events.GameMaster)
	local gate = Entities:FindByNameNearest("WaterTempleJailDoor", Vector(-9048, 12430, 228), 700)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-8822, 12433, 120), 600, 30, false)
	for i = 1, 80, 1 do
		Timers:CreateTimer(i*0.03, function()
			gate:SetAngles(0, 360-165*math.cos((i-80)*math.pi/160), 0)
		end)
	end
	Timers:CreateTimer(0.9, function()
		local blockers = Entities:FindAllByNameWithin("WaterTempleJailBlocker", Vector(-8767, 12480, 220), 800)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)
	for i = 1, #Tanari.WaterTemple.rascalTable, 1 do
		local rascal = Tanari.WaterTemple.rascalTable[i]
		EndAnimation(rascal)
		Timers:CreateTimer(0.5, function()
			StartAnimation(rascal, {duration=3.5, activity=ACT_DOTA_VICTORY, rate=1}) 
			EmitGlobalSound("Tanari.WaterTemple.RascalHappy")
			Timers:CreateTimer(3.5, function()
				rascal:RemoveModifierByName("modifier_rascal_imprisoned")
				rascal.phase = 1
			end)
		end)
	end
	Timers:CreateTimer(13, function()
		Tanari:WaterTempleJailBreak()
	end)
	
end

function Tanari:WaterTempleJailBreak()
	local spawnPositions = {Vector(-6053, 16064), Vector(-6056, 15296), Vector(-6070, 14540)}
	for i = 1, 14, 1 do
		Timers:CreateTimer(i*1, function()
			local randomSpawnPosition = spawnPositions[RandomInt(1, #spawnPositions)]
			local fv = Vector(-1,0)
			Tanari:SpawnJailBreakUnit(randomSpawnPosition, fv)
		end)
	end
end

function Tanari:SpawnJailBreakUnit(position, fv)
	local unitTable = {"shark", "prison_guard", "executioner", "slithereen_guard", "slithereen_royal_guard", "featherguard"}
	local randomIndex = RandomInt(1, #unitTable)
	local randomUnitAlias = unitTable[randomIndex]
	local unit = false
	if randomUnitAlias == "shark" then
		unit = Tanari:SpawnShark(position, fv)
	elseif randomUnitAlias == "prison_guard" then
		unit = Tanari:SpawnPrisonGuard(position, fv)
	elseif randomUnitAlias == "executioner" then
		unit = Tanari:SpawnExecutioner(position, fv)
	elseif randomUnitAlias == "slithereen_guard" then
		unit = Tanari:SpawnSlithereenGuard(position, fv, false)
	elseif randomUnitAlias == "slithereen_royal_guard" then
		unit = Tanari:SpawnSlithereenRoyalGuard(position, fv, false)
	elseif randomUnitAlias == "featherguard" then
		unit = Tanari:SpawnSlithereenFeatherguard(position, fv, false)
	end
	Timers:CreateTimer(0.5, function()
		unit:MoveToPositionAggressive(Vector(-9856, 14300+RandomInt(1,1400)))
	end)
end


function Tanari:InitializeRascals()
	local positionTable = {Vector(-9228, 13120), Vector(-9067, 12960), Vector(-8832, 13184)}
	Tanari.WaterTemple.rascalTable = {}
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.2, function()
			local rascal = CreateUnitByName("water_temple_fish_prisoner", positionTable[i], false, nil, nil, DOTA_TEAM_GOODGUYS)
			rascal.phase = 0
			local ability = rascal:FindAbilityByName("water_temple_rascal_ai")
			Events:AdjustDeathXP(rascal)
			ability:SetLevel(1)
			Timers:CreateTimer(0.1, function()
				ability:ApplyDataDrivenModifier(rascal, rascal, "modifier_rascal_imprisoned", {})
			end)
			rascal:SetForwardVector(RandomVector(1))
			StartAnimation(rascal, {duration=99999, activity=ACT_DOTA_IDLE, rate=1, translate="injured"}) 
			table.insert(Tanari.WaterTemple.rascalTable, rascal)
		end)
	end
end

function Tanari:ActivateSwitchGeneric(buttonPosition, buttonName, bDown)
	local movementZ = 0.5
	if bDown then
		movementZ = -0.5
	end
	local switch = Entities:FindByNameNearest(buttonName, buttonPosition, 600)
	local walls = {switch}
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WaterTemple.SwitchStart", Events.GameMaster)
	end)
	for i = 1, 60, 1 do
		for j = 1, #walls, 1 do
			Timers:CreateTimer(i*0.03, function()
				walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
			end)
		end
	end
	Timers:CreateTimer(1.7, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WaterTemple.SwitchEnd", Events.GameMaster)
	end)
end

function Tanari:ActivateSwitchGenericWithZ(buttonPosition, buttonName, bDown, movementZ)
	if bDown then
		movementZ = -movementZ
	end
	local switch = Entities:FindByNameNearest(buttonName, buttonPosition, 600)
	local walls = {switch}
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WaterTemple.SwitchStart", Events.GameMaster)
	end)
	for i = 1, 60, 1 do
		for j = 1, #walls, 1 do
			Timers:CreateTimer(i*0.03, function()
				walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
			end)
		end
	end
	Timers:CreateTimer(1.7, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WaterTemple.SwitchEnd", Events.GameMaster)
	end)
end

function Tanari:RascalCutscene(allies)
	Dungeons:LockCameraToUnitForPlayers(allies, 14.9, Tanari.WaterTemple.rascalTable[1])
	Tanari.WaterTemple.rascalTable[2]:MoveToPosition(Vector(-6080, 11408))
	Timers:CreateTimer(2, function()
		local fv = ((Tanari.WaterTemple.rascalTable[2]:GetAbsOrigin() - Tanari.WaterTemple.rascalTable[3]:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		Tanari:RascalJump(Tanari.WaterTemple.rascalTable[3], fv, 10, 11, 15, 1, 160)
		StartAnimation(Tanari.WaterTemple.rascalTable[3], {duration=1, activity=ACT_DOTA_SLARK_POUNCE, rate=1})
		Timers:CreateTimer(0.5, function()
			Tanari.WaterTemple.rascalTable[3]:SetAbsOrigin(Tanari.WaterTemple.rascalTable[2]:GetAbsOrigin()+Vector(0,0,160))
		end)
		Timers:CreateTimer(1.5, function()
			local fv = ((Tanari.WaterTemple.rascalTable[3]:GetAbsOrigin() - Tanari.WaterTemple.rascalTable[1]:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			Tanari:RascalJump(Tanari.WaterTemple.rascalTable[1], fv, 9, 24, 15, 1, 320)
			StartAnimation(Tanari.WaterTemple.rascalTable[1], {duration=1, activity=ACT_DOTA_SLARK_POUNCE, rate=1})
			Timers:CreateTimer(0.5, function()
				Tanari.WaterTemple.rascalTable[1]:SetAbsOrigin(Tanari.WaterTemple.rascalTable[3]:GetAbsOrigin()+Vector(0,0,160))
			end)
			Timers:CreateTimer(2.3, function()
				WallPhysics:Jump(Tanari.WaterTemple.rascalTable[1], Vector(-1,0), 16, 50, 30, 1)
				StartAnimation(Tanari.WaterTemple.rascalTable[1], {duration=1, activity=ACT_DOTA_SLARK_POUNCE, rate=1})
				Timers:CreateTimer(2, function()
					Tanari.WaterTemple.rascalTable[1]:MoveToPosition(Vector(-8424, 11416))
					Timers:CreateTimer(2.5, function()
						WallPhysics:Jump(Tanari.WaterTemple.rascalTable[3], Vector(1,0), 8, 8, 14, 1.5)
						StartAnimation(Tanari.WaterTemple.rascalTable[3], {duration=1, activity=ACT_DOTA_SLARK_POUNCE, rate=1})
					end)
					Timers:CreateTimer(3.25, function()
						Tanari:ActivateSwitchGeneric(Vector(-8424, 11416, 90), "WaterTempleRascalSwitch", true)
						Timers:CreateTimer(0.5, function()
							Tanari:SpawnBackSneakRoom()
							Tanari:LowerWaterTempleWall(-6, "WaterTempleRascalWall", Vector(-6436, 11392), "RascalWallBlocker", Vector(-6400, 11546, 119), 900, true, false)
							Timers:CreateTimer(0.5, function()
								for i = 1, #Tanari.WaterTemple.rascalTable, 1 do
									local rascal = Tanari.WaterTemple.rascalTable[i]
									local ability = rascal:FindAbilityByName("water_temple_rascal_ai")
									Timers:CreateTimer(0.1, function()
										ability:ApplyDataDrivenModifier(rascal, rascal, "modifier_rascal_imprisoned", {duration = 3.6})
										StartAnimation(rascal, {duration=3.6, activity=ACT_DOTA_VICTORY, rate=1}) 
										EmitGlobalSound("Tanari.WaterTemple.RascalHappy")
									end)
								end
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end

function Tanari:RascalJump(unit, forwardVector, propulsion, liftForce, liftDuration, gravity, floorZ)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_jumping"
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 6})
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03*i, function()
			if IsValidEntity(unit) then
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)
				unit:SetOrigin(newPosition)
			end
		end)
	end
	local fallLoop = 0
end

function Tanari:SpawnTentacleSwitches()
	Tanari.WaterTemple.Tentacles = {}
	local positionTable = {Vector(-326, 13880), Vector(-326,13504), Vector(-326,13085), Vector(-326,12672)}
	local fvTable = {Vector(-1,-1), Vector(-1, -0.5), Vector(-1, 0.5), Vector(-1, 1)}
	for i = 1, #positionTable, 1 do
		Tanari:SpawnWaterTempleTentacle(positionTable[i], fvTable[i])
	end
end

function Tanari:SpawnWaterTempleTentacle(position, fv)
	local staff = CreateUnitByName("water_temple_tentacle_switch", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	staff:SetForwardVector(fv)
	staff:SetRenderColor(115, 115, 115)
	staff.color = "grey"
	staff.dummy = true
	table.insert(Tanari.WaterTemple.Tentacles, staff)
end

function Tanari:TentacleChangeColor(tentacle, currentColor)
	local newColor = "red"
	if currentColor == "red" then
		newColor = "yellow"
		tentacle:SetRenderColor(241, 244, 13)
	elseif currentColor == "yellow" then
		newColor = "green"
		tentacle:SetRenderColor(107, 203, 100)
	elseif currentColor == "green" then
		newColor = "blue"
		tentacle:SetRenderColor(49, 55, 213)
	else
		newColor = "red"
		tentacle:SetRenderColor(192, 50, 50)
	end
	tentacle.color = newColor
	Tanari:CheckOctopusStatueCondition()
end

function Tanari:RotateOctopusStatueColors()
	Tanari.WaterTemple.Octopus1 = Entities:FindByNameNearest("WaterTempleOctopusStatue", Vector(0,13942,78), 400)
	Tanari.WaterTemple.Octopus2 = Entities:FindByNameNearest("WaterTempleOctopusStatue", Vector(0,13531,78), 400)
	Tanari.WaterTemple.Octopus3 = Entities:FindByNameNearest("WaterTempleOctopusStatue", Vector(0,13120,78), 400)
	Tanari.WaterTemple.Octopus4 = Entities:FindByNameNearest("WaterTempleOctopusStatue", Vector(0,12699,78), 400)
	Timers:CreateTimer(1, function()
		if not Tanari.WaterTemple.OctopusStatueClear then
			Tanari.WaterTemple.OctopusColors = {}
			Tanari:GiveStatueRandomColor(Tanari.WaterTemple.Octopus1)
			Tanari:GiveStatueRandomColor(Tanari.WaterTemple.Octopus2)
			Tanari:GiveStatueRandomColor(Tanari.WaterTemple.Octopus3)
			Tanari:GiveStatueRandomColor(Tanari.WaterTemple.Octopus4)
			EmitSoundOnLocationWithCaster(Vector(0,13300,200), "Tanari.WaterTemple.OctopusStatueChange", Events.GameMaster)
			if not Tanari.WaterTemple.OctopusStatueClear then
				local interval = 12
				if GameState:GetDifficultyFactor() == 2 then
					interval = 11
				elseif GameState:GetDifficultyFactor() == 3 then
					interval = 10
				end
				return interval
			end
		end
	end)
end

function Tanari:GiveStatueRandomColor(statue)
	local luck = RandomInt(1,4)
	local redColor = Vector(189, 126, 116)
	local blueColor = Vector(76, 133, 255)
	local yellowColor = Vector(249, 255, 128)
	local greenColor = Vector(112, 199, 98)
	local coloringVector = Vector(255, 255, 255)
	if luck == 1 then
		table.insert(Tanari.WaterTemple.OctopusColors, "red")
		coloringVector = redColor
	elseif luck == 2 then
		table.insert(Tanari.WaterTemple.OctopusColors, "blue")
		coloringVector = blueColor
	elseif luck == 3 then
		table.insert(Tanari.WaterTemple.OctopusColors, "yellow")
		coloringVector = yellowColor
	else
		table.insert(Tanari.WaterTemple.OctopusColors, "green")
		coloringVector = greenColor
	end
	statue:SetRenderColor(coloringVector.x, coloringVector.y, coloringVector.z)
end

function Tanari:CheckOctopusStatueCondition()
	local correctTentacles = 0
	for i = 1, 4, 1 do
		if Tanari.WaterTemple.OctopusColors[i] == Tanari.WaterTemple.Tentacles[i].color then
			correctTentacles = correctTentacles + 1
		end
	end
	if correctTentacles == 4 then
		for k = 1, 4, 1 do
			local ability = Tanari.WaterTemple.Tentacles[k]:FindAbilityByName("water_temple_tentacle_switch_ability")
			ability:ApplyDataDrivenModifier(Tanari.WaterTemple.Tentacles[k], Tanari.WaterTemple.Tentacles[k], "water_tentacle_attack_immune", {})
		end
		EmitGlobalSound("Tanari.WaterTemple.OctopusStatueWin")
		Tanari.WaterTemple.OctopusStatueClear = true
		for i = 1, 4, 1 do
			for j = 1, 60, 1 do
				Timers:CreateTimer(j*0.03, function()
					local xOffset = -20
					if j%2 == 0 then
						xOffset = 20
					end
					if i == 1 then
						ScreenShake(Tanari.WaterTemple.Tentacles[1]:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
					end
					Tanari.WaterTemple.Tentacles[i]:SetAbsOrigin(Tanari.WaterTemple.Tentacles[i]:GetAbsOrigin()+Vector(xOffset, 0, -6))
				end)
			end
		end
		Tanari:PrepareWaterTempleRoom3()
		Tanari:LowerWaterTempleWall(-6, "WaterTempleWall2", Vector(-4849, 13688, 0), "WaterTempleBlocker2", Vector(-4864, 13760, 119), 900, true, false)
		Timers:CreateTimer(60, function()
			for k = 1, 4, 1 do
				UTIL_Remove(Tanari.WaterTemple.Tentacles[k])
			end
			Tanari.WaterTemple.Tentacles = false
		end)
	end
end

function Tanari:PrepareWaterTempleRoom3()
	Tanari:SpawnAquaMage(Vector(-5696, 13069)+RandomVector(200), Vector(1,1))
	if Tanari.RareWaterWrath then
		Tanari:SpawnRareWaterWrath(Vector(-6144, 13568), Vector(1,0))
	end
	Tanari:SpawnFacelessElemental(Vector(-5888, 13568), Vector(1,-1))
	Timers:CreateTimer(0.4, function()
		Tanari:SpawnFacelessElemental(Vector(-6208, 13824), Vector(1,-0.5))
	end)
	Timers:CreateTimer(0.6, function()
		Tanari:SpawnFacelessElemental(Vector(-6592, 13568), Vector(0.5,-0.5))
	end)
	Timers:CreateTimer(1.1, function()
		Tanari:SpawnFacelessElemental(Vector(-6976, 13888), Vector(0.8,-0.5))
		Tanari:SpawnFacelessElemental(Vector(-7040, 13568), Vector(0.8,-0.2))
	end)
	Timers:CreateTimer(3, function()
		Tanari:SpawnAquaMage(Vector(-7680, 12992), Vector(0,1))
		Tanari:SpawnAquaMage(Vector(-7488, 12160), Vector(-0.2,1))
		Tanari:SpawnFacelessElemental(Vector(-7168, 12352), Vector(-0.8,0.5))
	end)
end

function Tanari:SpawnFacelessElemental(position, fv)
	local shark = Tanari:SpawnDungeonUnit("water_temple_faceless_water_elemental", position, 1,3, "morphling_mrph_anger_0"..RandomInt(1,7), fv, false)
	Events:AdjustBossPower(shark, 1, 1)
	shark:SetRenderColor(200, 200, 255)
	shark.itemLevel = 62
	shark.targetRadius = 1000
	shark.minRadius = 0
	shark.targetAbilityCD = 1.5
	shark.targetFindOrder = FIND_FARTHEST
	shark.dominion = true
	return shark
end

function Tanari:SpawnWaterVaultLord2(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_vault_lord_two", position, 1,2, "Tanari.WaterTemple.VaultLordAggro", fv, false)
	Events:AdjustBossPower(lord, 1, 1)
	lord.itemLevel = 61
	lord:SetRenderColor(40, 255, 255)
	lord.dominion = true
	return lord
end

function Tanari:SpineRoomSpawn()
	Tanari:SpawnWaterVaultLord2(Vector(-8384, 13440), Vector(0,-1))
	Tanari:SpawnWaterVaultLord2(Vector(-8128, 13440), Vector(0,-1))
	Tanari:SpawnWaterVaultLord2(Vector(-8384, 12416), Vector(0,1))
	Tanari:SpawnWaterVaultLord2(Vector(-8128, 12416), Vector(0,1))
	Tanari:SpawnWaterVaultLord(Vector(-8256, 12864), Vector(1,0))
	Tanari:SpawnBossStatue(Vector(-9001, 13689, 280), nil, 0, "spine")
end

function Tanari:MainStatueCoordinates()
	local spinePos = Vector(-4904, 10659.3, -78)
	local helmPos = Vector(-4888.75, 10624, 102)
	local tridentPos = Vector(-5160.92, 10624, 483)
end

function Tanari:SpawnBossStatue(position, fv, startingAngle, type)
	if not Tanari.WaterTemple.Initialized then
		return
	end
	local statue = CreateUnitByName("npc_flying_dummy_vision", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	statue:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
	statue:SetOriginalModel("models/water_temple_boss_statue.vmdl")
	statue:SetModel("models/water_temple_boss_statue.vmdl")
	statue:SetAbsOrigin(position+Vector(0,0,140))
	statue:AddAbility("water_temple_boss_statue_ability"):SetLevel(1)
	local statueAbility = statue:FindAbilityByName("water_temple_boss_statue_ability")
	statueAbility:ApplyDataDrivenModifier(statue, statue, "modifier_statue_glowing", {})
	statue:RemoveAbility("dummy_unit")
	statue:RemoveModifierByName("dummy_unit")
	statue:SetRenderColor(255, 255, 0)
	statue.startingAngle = startingAngle
	statue.timesRotated = 0
	statue.dummy = true
	statue.type = type
	if fv then
		statue:SetForwardVector(fv)
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position+Vector(0,0,300), 460, 99999, false)
	return statue
end

function Tanari:SpawnBlueWarlock(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_blue_warlock", position, 1,2, "Tanari.WaterTemple.VaultLordAggro", fv, false)
	Events:AdjustBossPower(lord, 1, 1)
	lord.itemLevel = 61
	lord:SetRenderColor(90, 90, 255)
	lord:SetMana(0)
	lord.dominion = true
	return lord
end

function Tanari:SpawnBackSneakRoom()
	Tanari:SpawnBlueWarlock(Vector(-8320, 10560), Vector(0,1))
	Tanari:SpawnBlueWarlock(Vector(-7104, 10560), Vector(0,1))
	Tanari:SpawnBlueWarlock(Vector(-8320, 9664), Vector(0,1))
	Tanari:SpawnBlueWarlock(Vector(-7104, 9664), Vector(0,1))
	Tanari:SpawnAquaMage(Vector(-8320, 10112), Vector(1,0))
	Tanari:SpawnAquaMage(Vector(-7168, 10112), Vector(-1,0))
	Tanari:SpawnAquaEmperor(Vector(-7680, 10176))
end

function Tanari:SpawnAquaEmperor(position)
	local lord = Tanari:SpawnDungeonUnit("water_temple_emperor_elemental", position, 4,5, "morphling_mrph_anger_0"..RandomInt(1,7), Vector(0,1), false)
	Events:AdjustBossPower(lord, 5, 5)
	lord.itemLevel = 61
	lord:SetRenderColor(115, 115, 255)
	lord:SetMana(0)
	lord:SetAbsOrigin(lord:GetAbsOrigin()-Vector(0,0,540))
	local ability = lord:FindAbilityByName("water_temple_aqua_emperor_ai")
	ability:ApplyDataDrivenModifier(lord, lord, "modifier_water_emperor_submerged", {})
end

function Tanari:SpawnVaultMaster(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_vault_master", position, 2,3, "Tanari.WaterTemple.VaultLordAggro", fv, false)
	Events:AdjustBossPower(lord, 1, 2)
	lord.itemLevel = 64
	lord:SetRenderColor(115, 115, 255)
	lord.dominion = true
	return lord
end

function Tanari:SpawnBackVaultMasterRoom()
	Tanari:SpawnVaultMaster(Vector(-8896, 10752), Vector(0,-1))
	Tanari:SpawnWaterVaultLord2(Vector(-9026, 11192), Vector(0,-1))
	Tanari:SpawnWaterVaultLord2(Vector(-8799, 11192), Vector(0,-1))
	Tanari:SpawnWaterVaultLord(Vector(-8921, 11651), Vector(0,-1))

	Tanari:SpawnVaultMaster(Vector(-9902, 11463), Vector(1,-1))
	Tanari:SpawnVaultMaster(Vector(-9920, 11053), Vector(0,1))
	Timers:CreateTimer(1, function()
		Tanari:SpawnVaultMaster(Vector(-9000, 8000), Vector(0,1))
		Tanari:SpawnBlueWarlock(Vector(-9238, 7936), Vector(0,1))
		Tanari:SpawnBlueWarlock(Vector(-8867, 7936), Vector(0,1))
		Tanari:SpawnFacelessElemental(Vector(-9408, 7936), Vector(0,1))
		Tanari:SpawnFacelessElemental(Vector(-8704, 7936), Vector(0,1))
	end)
	Timers:CreateTimer(5, function()
		if Tanari.RareWaterConstruct then
			Tanari:SpawnRareWaterConstruct(Vector(-9048, 7552), Vector(0,1))
		end
	end)
end

function Tanari:WaterTempleWaveTrigger()
	if not Tanari.WaterTemple then
		Tanari.WaterTemple = {}
	end
	Tanari:ActivateSwitchGeneric(Vector(-9047, 8320, 90), "WaterTempleWaveSwitch", true)
	local roomPos1 = Vector(-9792, 6784)
	local roomPos2 = Vector(-9042, 6784)
	local roomPos3 = Vector(-7616, 8320)
	local roomPos4 = Vector(-7616, 7520)
	local aggressionPoint = Vector(-9408, 9060)
	Tanari.WaterTemple.waveDeaths = 0
	Tanari.WaterTemple.doorPhase = 0
	Timers:CreateTimer(0.5, function()
		Tanari:LowerWaterTempleWall(-6, "WaterTempleWaveWall1", Vector(-9837, 7194, 37), "WaterTempleWaveBlocker1", Vector(-9856, 7168, 122), 900, true, false)
		Timers:CreateTimer(1.2, function()
			Tanari:SpawnWaterTempleWaveUnit("water_temple_armored_water_beetle", roomPos1, 30, 58, 0.3)
			Timers:CreateTimer(4, function()
				local lord = Tanari:SpawnWaterVaultLord2(roomPos1, Vector(1,0))
				Dungeons:AggroUnit(lord)
			end)
			Timers:CreateTimer(8, function()
				lord = Tanari:SpawnWaterVaultLord2(roomPos1, Vector(1,0))
				Dungeons:AggroUnit(lord)
			end)
		end)
	end)
	--"water_temple_wave_room_ability"
end

function Tanari:SpawnWaterTempleWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay)
  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
      local luck = RandomInt(1, 222)
      if Events.SpiritRealm then
      	luck = RandomInt(1, 80)
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
      	unit.itemLevel = itemLevel
      	unit:AddAbility("water_temple_wave_room_ability"):SetLevel(1)
      	if unit:GetUnitName() == "water_temple_serpent_sleeper" then
      		unit:SetRenderColor(115, 115, 255)
      	elseif unit:GetUnitName() == "water_temple_armored_water_beetle" then
      		unit:SetRenderColor(115, 115, 255)
		elseif unit:GetUnitName() == "water_temple_blinded_serpent_warrior" then
      		unit:SetRenderColor(195, 195, 255)
      	end
      	unit:SetAcquisitionRange(4000)
      	unit.dominion = true
      else
      	for i = 1, #unit, 1 do
      		unit[i].itemLevel = itemLevel
      		unit[i]:AddAbility("water_temple_wave_room_ability"):SetLevel(1)
      		unit[i]:SetAcquisitionRange(4000)
      		unit[i].dominion = true
      	end
      end
    end)
  end
end

function Tanari:SpawnSerpent(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_serpent_sleeper", position, 0, 1, nil, fv, true)
	lord.itemLevel = 60
	lord:SetRenderColor(115, 115, 255)
	lord.dominion = true
end

function Tanari:SpawnWaterBeetle(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_armored_water_beetle", position, 0, 1, nil, fv, true)
	lord.itemLevel = 60
	lord:SetRenderColor(115, 115, 255)
	lord.dominion = true
end

function Tanari:SpawnWaterBeetleNoAggro(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_armored_water_beetle", position, 0, 1, nil, fv, false)
	lord.itemLevel = 60
	lord:SetRenderColor(115, 115, 255)
	lord.dominion = true
end

function Tanari:SpawnBlindedWarrior(position, fv)
	local lord = Tanari:SpawnDungeonUnit( "water_temple_blinded_serpent_warrior", position, 0, 1, nil, fv, true)
	lord.itemLevel = 60
	lord:SetRenderColor(195, 195, 255)
	lord.dominion = true
end

function Tanari:WhirlpoolUnit(unit)
	if unit:HasModifier("modifier_whirlpool_flailing") then
		return false
	end
	if unit:HasFlyMovementCapability() then
		return false
	end
	local position = unit:GetAbsOrigin()
	local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
	local particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, unit )
	ParticleManager:SetParticleControl( particle, 0, position+Vector(0,0,145))
	Timers:CreateTimer(2.2, function()
		ParticleManager:DestroyParticle(particle, false)
	end)	
	unit:SetAbsOrigin(unit:GetAbsOrigin()+Vector(0,0,50))
	EmitSoundOn("Hero_Tidehunter.Taunt.BackStroke", unit)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_disable_player", {})
	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_whirlpool_flailing", {})
	for i = 1, 40, 1 do
		Timers:CreateTimer(i*0.03, function()
			unit:SetAbsOrigin(unit:GetAbsOrigin()-Vector(0,0,1))
		end)
	end
	Timers:CreateTimer(1.2, function()
		local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
	    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, unit)
	    for k = 0, 4, 1 do
	    	ParticleManager:SetParticleControl(pfx,k,unit:GetAbsOrigin()+Vector(0,0,240) )
		end	
		local playerID = unit:GetPlayerID()
		
		if PlayerResource:IsValidPlayerID(playerID) then
			PlayerResource:SetCameraTarget(playerID, unit)
		-- Timers:CreateTimer(duration,
		-- function()
		--   PlayerResource:SetCameraTarget(playerID, nil)
		-- end)
		end
		for i = 1, 20, 1 do
			Timers:CreateTimer(0.03*i, function()
				unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, -16))
			end)
		end
		local whirlPoolLocation = Vector(-4928, 9600, 78)
		local whirlPoolMotionVector = ((whirlPoolLocation - unit:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local whirlPoolDistance = WallPhysics:GetDistance(whirlPoolLocation*Vector(1,1,0), unit:GetAbsOrigin()*Vector(1,1,0))
		Timers:CreateTimer(0.7, function()
			local loops = whirlPoolDistance/90
			for k = 1, loops, 1 do
				Timers:CreateTimer(k*0.03, function()
					unit:SetAbsOrigin(unit:GetAbsOrigin()+whirlPoolMotionVector*90)
				end)
			end
			Timers:CreateTimer(loops*0.03 + 0.2, function()
				local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
				local particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, unit )
				ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin()+Vector(0,0,305))
				Timers:CreateTimer(2.2, function()
					ParticleManager:DestroyParticle(particle, false)
				end)
				Timers:CreateTimer(0.8, function()
					WallPhysics:Jump(unit, Vector(1,1), 0, 40, 38, 0.9)
					Timers:CreateTimer(0.4, function()
					      particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
					      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, unit )
					      ParticleManager:SetParticleControl( particle1, 0, unit:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,140) )
					      EmitSoundOn("Tanari.WaterSplash", unit)
					      Timers:CreateTimer(4, 
					      function()
					        ParticleManager:DestroyParticle( particle1, false )
					      end)
					      PlayerResource:SetCameraTarget(playerID, nil)
					      Timers:CreateTimer(0.85, function()
					      	unit:RemoveModifierByName("modifier_whirlpool_flailing")
					      end)
					      unit:RemoveModifierByName("modifier_disable_player")
					end)
				end)					

			end)
		end)
	end)
end

function Tanari:SpawnGardenArea()
	Tanari:SpawnFairyDragon(Vector(-4800, 7872), Vector(-1,1))
	Tanari:SpawnFairyDragon(Vector(-5839, 7588), Vector(0,1))
	local patrolFairyTable = {}
	local fairy = Tanari:SpawnFairyDragon(Vector(-6608, 7052), Vector(0,1))
	fairy.patrolPositionTable = {Vector(-5632, 7104), Vector(-6208, 7552)}
	table.insert(patrolFairyTable, fairy)

	fairy = Tanari:SpawnFairyDragon(Vector(-5888, 6488), Vector(0,1))
	fairy.patrolPositionTable = {Vector(-6272, 6400), Vector(-5888, 7488)}
	table.insert(patrolFairyTable, fairy)

	fairy = Tanari:SpawnFairyDragon(Vector(-5760, 6528), Vector(0,1))
	fairy.patrolPositionTable = {Vector(-4928, 7232), Vector(-5760, 6528)}
	table.insert(patrolFairyTable, fairy)

	for i =1, #patrolFairyTable, 1 do
		patrolFairyTable[i].patrolSlow = 45
		patrolFairyTable[i].phaseIntervals = 4
		patrolFairyTable[i].patrolPointRandom = 370
		
		patrolFairyTable[i]:AddAbility("monster_patrol"):SetLevel(1)
	end
	Tanari:SpawnFacelessElemental(Vector(-6015, 7360), Vector(1,-1))
	Timers:CreateTimer(4, function()
		local riderTable = {}
		local patrolPoint1 = Vector(-5184, 7616)
		local patrolPoint2 = Vector(-4672, 6848)
		local patrolPoint3 = Vector(-4288, 7616)
		local rider = Tanari:SpawnAmphiLizardRider(Vector(-4672, 6912, 128), Vector(0,1))
		rider.patrolPositionTable = {patrolPoint3, patrolPoint1, patrolPoint2}
		rider:AddAbility("monster_patrol"):SetLevel(1)
		rider = Tanari:SpawnAmphiLizardRider(Vector(-4672, 6784, 128), Vector(0,1))
		rider.patrolPositionTable = {patrolPoint3, patrolPoint1, patrolPoint2}
		rider:AddAbility("monster_patrol"):SetLevel(1)
		rider = Tanari:SpawnAmphiLizardRider(Vector(-4800, 6848, 128), Vector(0,1))
		rider.patrolPositionTable = {patrolPoint3, patrolPoint1, patrolPoint2}
		rider:AddAbility("monster_patrol"):SetLevel(1)
	--
		rider = Tanari:SpawnAmphiLizardRider(Vector(-4352, 7808, 128), Vector(-1,0))
		rider.patrolPositionTable = {patrolPoint1, patrolPoint2, patrolPoint3}
		rider:AddAbility("monster_patrol"):SetLevel(1)
		rider = Tanari:SpawnAmphiLizardRider(Vector(-4302, 7908, 128), Vector(-1,0))
		rider.patrolPositionTable = {patrolPoint1, patrolPoint2, patrolPoint3}
		rider:AddAbility("monster_patrol"):SetLevel(1)
	end)
	Timers:CreateTimer(5, function()
		local ancient = Tanari:SpawnTanariAncient(Vector(-7552, 5824), RandomVector(1))
		ancient.patrolPositionTable = {Vector(-7552, 4736), Vector(-7552, 5824)}
	end)
	Timers:CreateTimer(6, function()
		Tanari:SpawnAmphiLizardRider(Vector(-4992, 6400), Vector(1,1))
		Tanari:SpawnAmphiLizardRider(Vector(-4800, 6336), Vector(0,1))
	end)
	Timers:CreateTimer(7, function()
		local position1 = Vector(-6912, 5440)
		local position2 = Vector(-6336, 5120)
		local position3 = Vector(-6656, 5888)
		local position4 = Vector(-6976, 4928)
		local elementPatrolTable = {}
		local elemental = Tanari:SpawnFacelessElemental(position1, Vector(1,-1))
		elemental.patrolPositionTable = {position2, position1}
		table.insert(elementPatrolTable, elemental)

		elemental = Tanari:SpawnFacelessElemental(position2, Vector(1,-1))
		elemental.patrolPositionTable = {position3, position4, position1}
		table.insert(elementPatrolTable, elemental)

		elemental = Tanari:SpawnFacelessElemental(position3, Vector(1,-1))
		elemental.patrolPositionTable = {position3, position4, position1, position2}
		table.insert(elementPatrolTable, elemental)

		elemental = Tanari:SpawnFacelessElemental(position4, Vector(1,-1))
		elemental.patrolPositionTable = {position1, position2, position3, position4}
		table.insert(elementPatrolTable, elemental)

		for i =1, #elementPatrolTable, 1 do
			elementPatrolTable[i].patrolSlow = 25
			elementPatrolTable[i].phaseIntervals = 3
			elementPatrolTable[i].patrolPointRandom = 270
			
			elementPatrolTable[i]:AddAbility("monster_patrol"):SetLevel(1)
		end
	end)
	Timers:CreateTimer(10, function()
		local patrolFairyTable = {}
		local fairy = Tanari:SpawnFairyDragon(Vector(-7104, 5824), Vector(0,1))
		fairy.patrolPositionTable = {Vector(-6016, 4864), Vector(-7104, 5824)}
		table.insert(patrolFairyTable, fairy)

		fairy = Tanari:SpawnFairyDragon(Vector(-6464, 5504), Vector(0,1))
		fairy.patrolPositionTable = {Vector(-5376, 6336), Vector(-6464, 5504)}
		table.insert(patrolFairyTable, fairy)


		for i =1, #patrolFairyTable, 1 do
			patrolFairyTable[i].patrolSlow = 40
			patrolFairyTable[i].phaseIntervals = 4
			patrolFairyTable[i].patrolPointRandom = 320
			
			patrolFairyTable[i]:AddAbility("monster_patrol"):SetLevel(1)
		end
		Tanari:SpawnAmphiLizardRider(Vector(-5888, 5504), Vector(0,1))
	end)
	Timers:CreateTimer(12, function()
		Tanari:SpawnWaterVaultLord2(Vector(-6528, 4288), Vector(1,0))
		Tanari:SpawnWaterVaultLord2(Vector(-6528, 4160), Vector(1,0))
		Tanari:SpawnAquaMage(Vector(-6656, 4224), Vector(1,0))
		Tanari:SpawnFairyDragon(Vector(-6820, 4143), Vector(1,0))
		Tanari:SpawnFairyDragon(Vector(-6784, 4288), Vector(1,0))
	end)

end

function Tanari:SpawnGardenArea2()
	local basePos = Vector(-8384, 5824)
	for i = 1, 10, 1 do
		local randomX = RandomInt(1, 580)
		local randomY = RandomInt(1, 260)
		Tanari:SpawnWaterBeetleNoAggro(basePos+Vector(randomX, randomY), RandomVector(1))
	end
	local patrolFairyTable = {}
	local fairy = Tanari:SpawnFairyDragon(Vector(-8832, 4608), Vector(0,1))
	fairy.patrolPositionTable = {Vector(-8000, 5568), Vector(-8832, 4608)}
	table.insert(patrolFairyTable, fairy)

	fairy = Tanari:SpawnFairyDragon(Vector(-9152, 5696), Vector(0,1))
	fairy.patrolPositionTable = {Vector(-8000, 4800), Vector(-9152, 5696)}
	table.insert(patrolFairyTable, fairy)

	fairy = Tanari:SpawnFairyDragon(Vector(-9088, 5184), Vector(0,1))
	fairy.patrolPositionTable = {Vector(-7616, 5184), Vector(-9088, 5184)}
	table.insert(patrolFairyTable, fairy)

	for i =1, #patrolFairyTable, 1 do
		patrolFairyTable[i].patrolSlow = 45
		patrolFairyTable[i].phaseIntervals = 4
		patrolFairyTable[i].patrolPointRandom = 360
		
		patrolFairyTable[i]:AddAbility("monster_patrol"):SetLevel(1)
	end
	Timers:CreateTimer(3, function()
		Tanari:SpawnBossStatue(Vector(-9536, 4005, 380), Vector(0,1), 90, "mask")
		Tanari:SpawnVaultMaster(Vector(-9984, 4672), Vector(0, 1))
		Tanari:SpawnVaultMaster(Vector(-9722, 4672), Vector(0, 1))
		Tanari:SpawnVaultMaster(Vector(-9424, 4672), Vector(0, 1))
		Tanari:SpawnVaultMaster(Vector(-9216, 4672), Vector(0, 1))
		Tanari:SpawnFacelessElemental(Vector(-9984, 5376), Vector(1,0))
		Tanari:SpawnFacelessElemental(Vector(-9984, 5632), Vector(1,0))
		Tanari:SpawnFacelessElemental(Vector(-9152, 5632), Vector(-1,0))
		Tanari:SpawnFacelessElemental(Vector(-9152, 5376), Vector(-1,0))
	end)
	Timers:CreateTimer(2, function()
		Tanari:SpawnSlithereenRoyalGuard(Vector(-9472, 4928), Vector(0, 1), false)
		Tanari:SpawnSlithereenRoyalGuard(Vector(-9722, 4928), Vector(0, 1), false)
	end)
end

function Tanari:SpawnFairyDragon(position, fv)
	local fairy = Tanari:SpawnDungeonUnit( "water_temple_fairy_dragon", position, 1, 1, nil, fv, false)
	fairy.itemLevel = 69
	fairy:SetRenderColor(175, 175, 255)
	Events:AdjustBossPower(fairy, 1, 1)
	fairy:FindAbilityByName("puck_phase_shift"):SetLevel(GameState:GetDifficultyFactor()+1)
	fairy.dominion = true
	return fairy
end

function Tanari:SpawnAmphiLizardRider(position, fv)
	local rider = Tanari:SpawnDungeonUnit( "water_temple_amphi_lizard_rider", position, 1, 1, "Tanari.WaterTemple.LizardRiderAggro", fv, false)
	rider.itemLevel = 66
	Events:AdjustBossPower(rider, 1, 1)
	rider:SetRenderColor(135, 135, 255)
	rider.targetRadius = 760
	rider.minRadius = 100
	rider.targetAbilityCD = 2
	rider.targetFindOrder = FIND_FARTHEST
	rider.patrolSlow = 25
	rider.phaseIntervals = 5
	rider.patrolPointRandom = 240
	rider.dominion = true
	return rider
end

function Tanari:CheckWaterBossCondition(attacker)
	if Tanari.WaterTemple.bossStatueSpines and Tanari.WaterTemple.bossStatueTrident and Tanari.WaterTemple.bossStatueHelm then
		Timers:CreateTimer(9.25, function()
			Dungeons:CreateBasicCameraLockForHeroes(Vector(-4943, 10831, 300), 10.1, {attacker})
			EmitGlobalSound("Tanari.WaterTemple.BossTransform")
			local mainstatue = Entities:FindByNameNearest("WaterTempleBossMain", Vector(-4943, 10671), 300)
			local trident = Entities:FindByNameNearest("WaterTempleBossTrident", Vector(-4720, 10650, 463), 800)
			local mask = Entities:FindByNameNearest("WaterTempleBossMask", Vector(-4888.75, 10624, -102), 600)
			local spine = Entities:FindByNameNearest("WaterTempleBossSpine", Vector(-4904, 10659.3, -78), 600)
			local fullStatue = {mainstatue, trident, mask, spine}
			for i = 1, 120, 1 do
				Timers:CreateTimer(i*0.03, function()
					for j = 1, #fullStatue, 1 do
						fullStatue[j]:SetRenderColor(i*2, i*2, 250-(i*2))
					end
				end)
			end		
			Timers:CreateTimer(3.65, function()
				for j = 1, #fullStatue, 1 do
					UTIL_Remove(fullStatue[j])
				end
				local newStatue = Tanari:SpawnBossStatue(Vector(-5056, 10650, 28), Vector(1,0), 0, "completion")
				newStatue:SetModelScale(3.2)
				-- for i = 1, 350, 1 do
				-- 	Timers:CreateTimer(0.03*i, function()
				-- 		newStatue:SetAbsOrigin(Vector(-5056, 10650, 128))
				-- 	end)
				-- end
				newStatue:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
				Timers:CreateTimer(2.6, function()
					EmitGlobalSound("Tanari.HarpMystery")
				end)
			end)
		end)
		Timers:CreateTimer(15, function()
			local music = "Tanari.WaterTemple.PreBossLoop"
			if not Tanari.WaterTemple.BossBattleBegun then
			EmitSoundOnLocationWithCaster(Vector(-5056, 10650, 28), music, Events.GameMaster)
			end
			if not Tanari.WaterTemple.BossBattleBegun then
				return 8.8
			end
		end)
	end
end

function Tanari:BeginBossSpawnSequence()
	for j = 1, 5, 1 do
		Timers:CreateTimer(j*2, function()
			local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
			local particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( particle, 0, Vector(-5056, 10650, 490))
			Timers:CreateTimer(2.2, function()
				ParticleManager:DestroyParticle(particle, false)
			end)
		end)
	end
	local blockers = Entities:FindAllByNameWithin("WaterTempleBossBlocker", Vector(-5056,10635,190), 1200)
	for i = 1, #blockers, 1 do
		UTIL_Remove(blockers[i])
	end
	Timers:CreateTimer(1, function()
		local music = "Tanari.WaterTemple.BossMusic"
		local VectorTable = {Vector(-1664, 14464, 300), Vector(-4992, 14464, 300), Vector(-4992, 10671, 300), Vector(9801, 14050, 90), Vector(-8000, 15264, 800), Vector(-8819, 10816, 300), Vector(-5824, 10816, 300), Vector(-7529, 8734, 300), Vector(-7975, 5376, 300), Vector(-7092, 5121, 250)}
		for i = 1, #VectorTable, 1 do
			EmitSoundOnLocationWithCaster(VectorTable[i], music, Events.GameMaster)
		end
		if not Tanari.WaterTemple.BossBattleEnd then
			return 75
		end
	end)
	Timers:CreateTimer(10, function()
		local boss = Events:SpawnBoss("water_temple_boss", Vector(-5056, 10650, 78))
		boss:SetRenderColor(150, 150, 255)
		Events:AdjustBossPower(boss, 8, 8)
		boss:SetAbsOrigin(Vector(-5056, 10650, -400))
		Timers:CreateTimer(0.4, function()

	 	particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
		  local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, boss )
		  ParticleManager:SetParticleControl( particle1, 0, boss:GetAbsOrigin()+Vector(0,0,240) )
		  EmitSoundOn("Tanari.WaterSplash", boss)
		  EmitSoundOn("Tanari.WaterSplash", boss)
		  Timers:CreateTimer(4, 
		  function()
		    ParticleManager:DestroyParticle( particle1, false )
		  end)
		  StartAnimation(boss, {duration=2.3, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.6})
		  Tanari:FloodRobeCheck()
		end)
		Timers:CreateTimer(0.95, function()
		 	  local particleName = "particles/units/heroes/hero_slardar/slardar_crush.vpcf"
			  local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, boss )
			  ParticleManager:SetParticleControl( particle2, 0, boss:GetAbsOrigin()+Vector(0,0,240) )
			  Timers:CreateTimer(2, function()
			  	ParticleManager:DestroyParticle(particle2, false)
			  end)
			EmitSoundOn("Hero_Slardar.Slithereen_Crush", boss)
		end)
		Timers:CreateTimer(0.8, function()
			EmitGlobalSound("Tanari.WaterTemple.BossAggro")
		end)
		local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
		gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, boss, "modifier_disable_player", {duration = 2.5})
		for i = 1, 40, 1 do
			Timers:CreateTimer(i*0.03, function()
				boss:SetAbsOrigin(boss:GetAbsOrigin()+Vector(0,0,18))
			end)
		end
		boss:FindAbilityByName("water_temple_boss_whirlpool"):StartCooldown(12)
	end)


end

function Tanari:FloodRobeCheck()
	Tanari.FloodRobeBattle = false
	if GameState:GetDifficultyFactor() == 3 then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local body = MAIN_HERO_TABLE[i].body
			if body then
				if body:GetAbilityName() == "item_rpc_robe_of_flooding_2" then
					Tanari.FloodRobeBattle = true
				end
			end
		end
	end
end

function Tanari:UpgradeFloodRobes(bossPosition)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local body = MAIN_HERO_TABLE[i].body
		if body then
			if body:GetAbilityName() == "item_rpc_robe_of_flooding_2" then
				local hero = MAIN_HERO_TABLE[i]
				
				StartAnimation(hero, {duration=12, activity=ACT_DOTA_FLAIL, rate=1}) 
				
			      particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, hero )
			      ParticleManager:SetParticleControl( particle1, 0, hero:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,140) )
			      EmitSoundOn("Tanari.WaterSplash", hero)
			      Timers:CreateTimer(4, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)
					EmitSoundOn("Hero_Tidehunter.Taunt.BackStroke", hero)
					local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_disable_player", {})
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_whirlpool_flailing", {})
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_upgrading_flood_robe", {})
					
					hero.upgradeRobePosition = bossPosition
					hero.upgradeRobeZMove = 0
					for j = 1, 18, 1 do
						Timers:CreateTimer(j, function()
					      particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
					      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, hero )
					      ParticleManager:SetParticleControl( particle1, 0, hero:GetAbsOrigin()-Vector(0,0,30) )
					      EmitSoundOn("Tanari.WaterSplash", hero)
					      Timers:CreateTimer(4, 
					      function()
					        ParticleManager:DestroyParticle( particle1, false )
					      end)
						end)
					end
					Timers:CreateTimer(18, function()
						Notifications:Top(hero:GetPlayerOwnerID(), {text="Robe of Flooding Upgraded", duration=5, style={color="white"}, continue=true})
						RPCItems:CreateFloodRobe3(hero, body)
						hero:RemoveModifierByName("modifier_disable_player")
						hero:RemoveModifierByName("modifier_whirlpool_flailing")
						hero:RemoveModifierByName("modifier_upgrading_flood_robe")
						-- FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
						WallPhysics:Jump(hero, hero:GetForwardVector(), 20, 20, 24, 1.5)
					end)
			end
		end
	end
end

function Tanari:WaterTempleBubble(victim, attacker, damage)
	local threshold = 0.02
	if GameState:GetDifficultyFactor() == 2 then
		threshold = 0.01
	elseif GameState:GetDifficultyFactor() == 3 then
		threshold = 0.005
	end
	if damage > victim:GetMaxHealth()*threshold then
		damage = victim:GetMaxHealth()*threshold
	end
	return damage
end

function Tanari:SpawnRareWaterWrath(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_rare_wrath_of_the_water_king", position, 3,5, "Tanari.WaterTemple.RareWrathAggro", fv, false)
	Events:AdjustBossPower(lord, 5, 5)
	lord.itemLevel = 75
	lord:SetRenderColor(60, 60, 255)
	return lord	
end

function Tanari:SpawnRareWaterConstruct(position, fv)
	local lord = Tanari:SpawnDungeonUnit("water_temple_rare_water_construct", position, 5,7, "Tanari.RareWaterConstruct.Aggro", fv, false)
	Events:AdjustBossPower(lord, 8, 8)
	lord.itemLevel = 120
	lord:SetRenderColor(60, 60, 255)
	return lord	
end

function Tanari:SpawnWaterSpirit(position, fv)
	local mage = Tanari:SpawnDungeonUnit("redfall_ancient_water_spirit", position, 2, 4, "Tanari.WaterTemple.SpiritAggro", fv, false)
	mage.itemLevel = 100
	Events:AdjustBossPower(mage, 10, 10, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnWaterSpiritJailer(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_temple_spirit_jailer", position, 0, 3, "Tanari.WaterJailer.Aggro", fv, false)
	mage.itemLevel = 80
	mage.dominion = true
	Events:AdjustBossPower(mage, 3, 5, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpiritWaterTempleStart()
	for i = 1, 4, 1 do
		for j = 1, 8, 1 do
			Timers:CreateTimer(j*0.15, function()
				local spawnPos = Vector(-12736, 14592)+Vector((i-1)*448, (j-1)*192)
				Tanari:SpawnWaterSpiritJailer(spawnPos, Vector(1,0))
			end)
		end
	end

	Timers:CreateTimer(2, function()
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-10584, 16039), 300, 1200, false)
		local positionTable = {Vector(-12672, 14656), Vector(-12288, 15872), Vector(-11328, 15673), Vector(-11375, 14644), Vector(-12224, 15025), Vector(-12480, 15425), Vector(-12032, 15778)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 1
			if GameState:GetDifficultyFactor() >= 2 then
				spawnCount = 2
			end
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnVaultKing(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 4, 30, patrolPositionTable)
			end
		end
	end)
end

function Tanari:SpawnVaultKing(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_temple_vault_king", position, 0, 3, "Tanari.VaultKing.Aggro", fv, false)
	mage.itemLevel = 90
	mage.dominion = true
	Events:AdjustBossPower(mage, 5, 5, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Events:SetPositionCastArgs(mage, 1200, 0, 1, FIND_ANY_ORDER)
	return mage
end

function Tanari:SpawnWaterWraith(position, fv, bAggro)
	local mage = Tanari:SpawnDungeonUnit("caged_water_wraith", position, 0, 3, "Tanari.WaterWraith.Aggro", fv, bAggro)
	mage.itemLevel = 85
	mage.dominion = true
	Events:AdjustBossPower(mage, 3, 3, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_blue", {})
	return mage
end

function Tanari:SpawnWaterSpiritRoom2()
	local positionTable = {Vector(-15792, 12130), Vector(-14016, 12130), Vector(-13568, 13952), Vector(-13568, 15232), Vector(-14464, 14769), Vector(-15869, 14095)}
	for i = 1, #positionTable, 1 do
		local patrolPositionTable = {}
		for j = 1, #positionTable, 1 do
			local index = i + j
			if index > #positionTable then
				index = index - #positionTable
			end
			table.insert(patrolPositionTable, positionTable[index])
		end
		local spawnCount = 1
		for k = 1, spawnCount, 1 do
			local elemental = Tanari:SpawnWaterSpiritBeetle(positionTable[i], RandomVector(1))
			Tanari:AddPatrolArguments(elemental, 30, 4, 30, patrolPositionTable)
		end
	end
	Timers:CreateTimer(3, function()
		Tanari:SpawnVaultKing(Vector(-15616, 14848), Vector(0,-1))
		Tanari:SpawnVaultKing(Vector(-15966, 15232), Vector(0,-1))
		Tanari:SpawnVaultKing(Vector(-15360, 15232), Vector(0,-1))
	end)
	Timers:CreateTimer(4, function()
		Tanari:SpawnSlardarJailer(Vector(-14784, 14464), Vector(0,-1))
		Tanari:SpawnSlardarJailer(Vector(-15616, 15872), Vector(0,-1))
		Tanari:SpawnSlardarJailer(Vector(-15223, 16192), Vector(-1,0))
		Tanari:SpawnSlardarJailer(Vector(-14871, 16192), Vector(-1,0))
	end)
	Timers:CreateTimer(5, function()
		for i = 0, 4, 1 do
			Tanari:SpawnWaterSpiritJailer(Vector(-14400+i*160, 16256), Vector(-1,0))
		end
	end)
end

function Tanari:SpawnWaterSpiritBeetle(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_shadow_hunter", position, 0, 3, "Tanari.WaterBeetle.Aggro", fv, false)
	mage.itemLevel = 85
	Events:AdjustBossPower(mage, 5, 5, false)
	mage.dominion = true
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_blue", {})
	Events:SetPositionCastArgs(mage, 600, 0, 1, FIND_ANY_ORDER)
	return mage
end

function Tanari:SpawnSlardarJailer(position, fv)
	local mage = Tanari:SpawnDungeonUnit("slithereen_prison_guard", position, 0, 3, "WaterTemple.JailerAggro", fv, false)
	mage.itemLevel = 90
	mage.dominion = true
	Events:AdjustBossPower(mage, 5, 5, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	mage.targetRadius = 800
	mage.autoAbilityCD = 2
	mage.castSound = "WaterTemple.JailerCast"
	return mage
end

function Tanari:SpawnWaterMetaSlark(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_temple_meta_prisoner", position, 2, 4, "Tanari.WaterTemple.MetaSlarkAggro", fv, false)
	mage.itemLevel = 100
	Events:AdjustBossPower(mage, 12, 12, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_blue", {})
	return mage
end

function Tanari:SpawnSerpentHuntress(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_temple_serpent_huntress", position, 1, 3, "Tanari.SerpentHuntress.Aggro", fv, false)
	mage.itemLevel = 95
	mage.dominion = true
	Events:AdjustBossPower(mage, 5, 5, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpiritWaterSection2()
  local positionTable = {Vector(-10757, 10240), Vector(-10757, 9728), Vector(-11490, 9580), Vector(-11904, 9580), Vector(-12288, 9580), Vector(-12672, 9580)}
  for i = 1, #positionTable, 1 do
  	Tanari:SpawnSerpentHuntress(positionTable[i], Vector(1,0))
  end
  local beetPosTable = {Vector(-11502, 10240), Vector(-11739, 10048), Vector(-11957, 10240), Vector(-12140, 9984), Vector(-12416, 10176)}
  for i = 1, #beetPosTable, 1 do
  	Tanari:SpawnWaterSpiritBeetle(beetPosTable[i], RandomVector(1))
  end

  local statue = Entities:FindByNameNearest("SpiritWaterRamp", Vector(-13008, 10138, 200), 1200)
  statue:SetAbsOrigin(statue:GetAbsOrigin()-Vector(0,0,1000))

  Tanari.WaterTemple.puzzle1color = RandomInt(1, 3)
  local hintStatue = Entities:FindByNameNearest("WaterPuzzleHint", Vector(-12703, 10176), 1300)
  if Tanari.WaterTemple.puzzle1color == 1 then
  	hintStatue:SetRenderColor(255, 80, 80)
  elseif Tanari.WaterTemple.puzzle1color == 2 then
  	hintStatue:SetRenderColor(129, 177, 129)
  elseif Tanari.WaterTemple.puzzle1color == 3 then
  	hintStatue:SetRenderColor(80, 80, 255)
  end

	Tanari.WaterTemple.SerpentSwitchTable = {}
	local switchPosTable = {Vector(-10958, 9950), Vector(-10794, 9950), Vector(-10628, 9950), Vector(-10464, 9950)}
	for i = 1, #switchPosTable, 1 do
	  local thinker = CreateUnitByName("dungeon_thinker", switchPosTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)  
	  thinker:SetOriginalModel("models/props_structures/ancient_trigger001.vmdl")
	  thinker:SetModel("models/props_structures/ancient_trigger001.vmdl")
	  thinker.index = i
	  thinker.color = i-1
	  if thinker.color == 0 then
	  	thinker.color = 3
	  end
	  thinker.enabled = true
	  thinker:SetModelScale(0.6)
	  thinker:RemoveAbility("dungeon_thinker")
	  thinker:RemoveModifierByName("modifier_dungeon_thinker")
	  thinker.name = "waterTempleSnakeSwitch"
	  thinker:AddAbility("dungeon_thinker2")
	  thinker:FindAbilityByName("dungeon_thinker2"):SetLevel(1)
	  thinker:FindAbilityByName("dungeon_thinker2"):ApplyDataDrivenModifier(thinker, thinker, "modifier_dungeon_thinker2", {})
	  if thinker:HasAbility("modifier_dungeon_thinker2") then
	  	--print("HAS DUNGEON THINKER")
	  end
	  thinker.statue = Entities:FindByNameNearest("SerpentStatue1", Vector(-12129+((i-1)*580), 10549), 1000)
	  table.insert(Tanari.WaterTemple.SerpentSwitchTable, thinker)
	end

end

function Tanari:SerpentSwitchActivate(caster)
  if caster.enabled then
    StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
    if caster.color == 1 then
      caster.color = 2
      caster.statue:SetRenderColor(129, 177, 129)
    elseif caster.color == 2 then
      caster.color = 3
      caster.statue:SetRenderColor(80, 80, 255)
    elseif caster.color == 3 then
      caster.color = 1
      caster.statue:SetRenderColor(255, 80, 80)
    end
    EmitSoundOn("Tanari.CastleSwitch.Press", caster)



    local bPuzzleClear = true
    for i = 1, #Tanari.WaterTemple.SerpentSwitchTable, 1 do
      if Tanari.WaterTemple.puzzle1color == Tanari.WaterTemple.SerpentSwitchTable[i].color then
      else
        bPuzzleClear = false
      end
    end
    if bPuzzleClear then
    	EmitGlobalSound("WaterTemple.SpiritBeacon")
		Tanari.WaterTemple.WaterPuzzleClear = true

	for i = 1, #Tanari.WaterTemple.SerpentSwitchTable, 1 do
		local switch = Tanari.WaterTemple.SerpentSwitchTable[i]
		switch.enabled = false
		for j = 1, 30, 1 do
		  Timers:CreateTimer(j*0.03, function()
		    switch:SetAbsOrigin(switch:GetAbsOrigin()-Vector(0,0,1.6))
		  end)
		end
		Timers:CreateTimer(0.3, function()
		  local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		  local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		  ParticleManager:SetParticleControl(particle1,0,switch:GetAbsOrigin())
		  Timers:CreateTimer(2, function()
		    ParticleManager:DestroyParticle( particle1, false )
		  end)
		end)
		Timers:CreateTimer(1, function()
		  UTIL_Remove(switch)
		end)
	end

		local walls = Entities:FindAllByNameWithin("OrganicAnemone", Vector(-12992, 10176, 16), 1200)
		for i = 1, 90, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,-5))
				end)
				if i%15 == 0 then
			  		local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
			  	  	local position = walls[j]:GetAbsOrigin()
			  	  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			  	  	ParticleManager:SetParticleControl(pfx, 0, position)
			  		  Timers:CreateTimer(3, function()
			  			   ParticleManager:DestroyParticle(pfx, false)
			  		  end)		
				end
			end
		end
		Timers:CreateTimer(3, function()
			Tanari:WaterSpiritPart2Again()
			local statue = Entities:FindByNameNearest("SpiritWaterRamp", Vector(-13008, 10138, -200), 1200)
			for i = 1, 180, 1 do
				Timers:CreateTimer(i*0.03, function()
					statue:SetAbsOrigin(statue:GetAbsOrigin()+Vector(0,0,1000/180))
					if i%30 == 0 then
						ScreenShake(statue:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
				  		local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
				  	  	local position = GetGroundPosition(statue:GetAbsOrigin(), Events.GameMaster) - Vector(0,0,40)
				  	  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				  	  	EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "Tanari.Shake", Events.GameMaster)
				  	  	ParticleManager:SetParticleControl(pfx, 0, position)
				  		  Timers:CreateTimer(2, function()
				  			   ParticleManager:DestroyParticle(pfx, false)
				  		  end)	
					end
				end)
			end
			Timers:CreateTimer(5.3, function()
				ScreenShake(statue:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
		  		local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
		  	  	local position = GetGroundPosition(statue:GetAbsOrigin(), Events.GameMaster) + Vector(240,0)
		  	  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		  	  	ParticleManager:SetParticleControl(pfx, 0, position)
		  		  Timers:CreateTimer(2, function()
		  			   ParticleManager:DestroyParticle(pfx, false)
		  		  end)	
				EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "Tanari.RockHit", Events.GameMaster)
				ScreenShake(statue:GetAbsOrigin(), 360, 0.3, 0.3, 9000, 0, true)
			end)
		end)
		Timers:CreateTimer(8.4, function()
			local blockers = Entities:FindAllByNameWithin("AnemoneBlocker", Vector(-12992, 10240, 200), 2000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end

		end)
    end
  end
end

function Tanari:WaterSpiritPart2Again()
	Tanari:SpawnSerpentHuntress(Vector(-12992, 10810), Vector(0, -1))
	Tanari:SpawnSerpentHuntress(Vector(-12408, 10810), Vector(0, -1))

	Tanari:SpawnWaterManifestation(Vector(-11328, 10675), Vector(-1,0))
	Tanari:SpawnWaterManifestation(Vector(-11328, 10910), Vector(-1,0))
	Tanari:SpawnWaterManifestation(Vector(-10880, 10674), Vector(-1,0))
	Tanari:SpawnWaterManifestation(Vector(-10880, 10910), Vector(-1,0))
	Tanari:SpawnWaterManifestation(Vector(-10432, 10647), Vector(-1,0))
	Tanari:SpawnWaterManifestation(Vector(-10432, 10910), Vector(-1,0))
	Timers:CreateTimer(2, function()
		Tanari:SpawnVaultKing(Vector(-10432, 12096), Vector(0,-1))
		Tanari:SpawnVaultKing(Vector(-11136, 12096), Vector(0,-1))
		Tanari:SpawnVaultKing(Vector(-11776, 12096), Vector(0,-1))
		Tanari:SpawnVaultKing(Vector(-12352, 12096), Vector(0,-1))

		Tanari:SpawnWaterManifestation(Vector(-12352, 12736), Vector(0,-1))

		Tanari:SpawnSerpentHuntress(Vector(-11792, 13256), Vector(0, -1))
		Tanari:SpawnSerpentHuntress(Vector(-11339, 13504), Vector(0, -1))
		Tanari:SpawnSerpentHuntress(Vector(-11132, 13504), Vector(0, -1))
	end)

	Timers:CreateTimer(4, function()
		local positionTable = {Vector(-10560, 10816), Vector(-10560, 12009), Vector(-12416, 12625), Vector(-11328, 13312)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 1
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnSerpentHuntress(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 4, 30, patrolPositionTable)
			end
		end
	end)
end

function Tanari:SpawnWaterManifestation(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_manifestation", position, 0, 2, "Tanari.WaterManifest.Aggro", fv, false)
	mage.itemLevel = 95
	mage.dominion = true
	Events:AdjustBossPower(mage, 5, 5, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_blue", {})
	return mage
end

function Tanari:SpawnRadialWaterStatueBombRoom()
	Timers:CreateTimer(2.5, function()
		for i = 1, 7, 1 do
			for j = 1, 2, 1 do
				Tanari:SpawnWaterManifestation(Vector(-15360, 10880)+Vector((i-1)*256, (j-1)*256), Vector(1,0))
			end
		end
	end)
	Timers:CreateTimer(10, function()
		 Tanari:SpawnVaultKing(Vector(-12864, 8576), Vector(-1,0))
		 Tanari:SpawnVaultKing(Vector(-12672, 8576), Vector(-1,0))
		 Tanari:SpawnVaultKing(Vector(-12864, 8384), Vector(-1,0))
		 Tanari:SpawnVaultKing(Vector(-12672, 8384), Vector(-1,0))
	end)
	Timers:CreateTimer(6, function()
		local positionTable = {Vector(-15616, 10880), Vector(-15616, 8512), Vector(-14208, 8512), Vector(-14208, 10880)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 1
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnSerpentHuntress(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 5, 30, patrolPositionTable)
				local elemental = Tanari:SpawnSerpentHuntress(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 5, 30, patrolPositionTable)
				local elemental = Tanari:SpawnSlardarJailer(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 5, 30, patrolPositionTable)
			end
		end
	end)

	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-14607, 9393, 77), 1000, 1200, false)
	Timers:CreateTimer(1.5, function()
		local centerPoint = Vector(-14607, 9393, 77)
		Tanari:SpawnRadialStatue("water_temple_duke_korlazeen", centerPoint, Vector(1,0))
		for i = 1, 6, 1 do
			local fv = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/6)
			Tanari:SpawnRadialStatue("water_temple_stone_priestess", centerPoint+fv*420, fv)
		end
		Timers:CreateTimer(3, function()
			for i = 1, 16, 1 do
				local fv = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/18)
				Tanari:SpawnRadialStatue("water_temple_stone_fish", centerPoint+fv*620, fv)
			end
		end)
		Timers:CreateTimer(4.5, function()
			for i = 1, 28, 1 do
				local fv = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/28)
				Tanari:SpawnRadialStatue("water_temple_prison_guard", centerPoint+fv*840, fv)
				
			end
		end)
	end)
end

function Tanari:SpawnRadialStatue(unitName, position, fv)
	local mage = Tanari:SpawnDungeonUnit(unitName, position, 0, 2, nil, fv, false)
	mage.itemLevel = 95
	Events:AdjustBossPower(mage, 5, 5, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Timers:CreateTimer(1.5, function()
		Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_frozen_stone", {})
	end)
	mage.autoAbilityCD = 3
	Events:SetTargetCastArgs(mage, 1200, 0, 2, FIND_ANY_ORDER)
	mage.targetRadius = 300
	return mage
end

function Tanari:SpawnWaterTempleWaveRoom()
	local positionTable = {Vector(-15232, 7232), Vector(-15232, 6288), Vector(-13428, 7232), Vector(-13428, 6288)}
	if GameState:GetDifficultyFactor() == 3 then
		positionTable = {Vector(-15232, 7232), Vector(-15232, 6288), Vector(-13428, 7232), Vector(-13428, 6288), Vector(-15488, 6784), Vector(-13120, 6784)}
	end
	for i = 1, #positionTable, 1 do
		Tanari:SpawnDrownedSorrow(positionTable[i], Vector(0,1))
	end

	Timers:CreateTimer(1, function()
		Tanari:SpawnSerpentHuntress(Vector(-16064, 6336), Vector(1,0))
		Tanari:SpawnSerpentHuntress(Vector(-16064, 6592), Vector(1,0))
		Tanari:SpawnSerpentHuntress(Vector(-16064, 6848), Vector(1,0))
		Tanari:SpawnSerpentHuntress(Vector(-16064, 7104), Vector(1,0))
	end)

	Timers:CreateTimer(2, function()
		Tanari:SpawnSerpentHuntress(Vector(-12480, 6336), Vector(1,0))
		Tanari:SpawnSerpentHuntress(Vector(-12480, 6592), Vector(1,0))
		Tanari:SpawnSerpentHuntress(Vector(-12480, 6848), Vector(1,0))
		Tanari:SpawnSerpentHuntress(Vector(-12480, 7104), Vector(1,0))
	end)
	Tanari:SpawnBigWaterArcher(Vector(-14208, 6784), Vector(0,1))
end

function Tanari:SpawnDrownedSorrow(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_drowned_sorrow", position, 1, 3, "Tanari.DrownedSorrow.Aggro", fv, false)
	mage.itemLevel = 95
	Events:AdjustBossPower(mage, 5, 5, false)
	mage:SetRenderColor(100, 100, 255)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Events:SetPositionCastArgs(mage, 1400, 0, 1, FIND_ANY_ORDER)
	return mage
end

function Tanari:SpawnBigWaterArcher(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_archer_spirit", position, 2, 5, "Tanari.BigArcher.Aggro", fv, false)
	mage.itemLevel = 95
	Events:AdjustBossPower(mage, 12, 12, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	mage:SetRenderColor(50, 50, 255)
	Events:ColorWearables(mage, Vector(50, 50, 255))
	return mage
end

function Tanari:SpawnSpiritWaterWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Tanari.SpiritWater.Spawn", Tanari.TanariMaster)
    end
      local luck = RandomInt(1, 222)
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
        unit.itemLevel = itemLevel
        unit.dominion = true
        Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "tanari_water_temple_modifier", {})
        Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "tanari_mountain_specter_ai", {})
        unit.code = 0

        unit:SetAcquisitionRange(3000)
        CustomAbilities:QuickAttachParticle("particles/econ/events/ti7/shivas_guard_active_ti7_flash.vpcf", unit, 2)
        unit.aggro = true
        if unit:GetUnitName() == "water_temple_faceless_water_elemental" then
          Events:SetPositionCastArgs(unit, 1200, 0, 1, FIND_ANY_ORDER)
        elseif unit:GetUnitName() == "water_temple_prison_guard" then
			unit.targetRadius = 300
			unit.autoAbilityCD = 2    	
        end
        -- elseif unit:GetUnitName() == "iron_spine" then
        --   unit:SetRenderColor(255, 60, 60)
        --   Redfall:ColorWearables(unit, Vector(255, 60, 60))
        -- elseif unit:GetUnitName() == "redfall_castle_demented_shaman" then
        --   unit:SetRenderColor(255, 60, 60)
        --   Redfall:ColorWearables(unit, Vector(255, 60, 60))
        -- end
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].itemLevel = itemLevel
          Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit[i], "tanari_water_temple_modifier", {})
          Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit[i], "tanari_mountain_specter_ai", {})
          unit[i].code = 0
          unit[i]:SetAcquisitionRange(3000)
          unit[i].dominion = true
          CustomAbilities:QuickAttachParticle("particles/econ/events/ti7/shivas_guard_active_ti7_flash.vpcf", unit[i], 2)
			if unit[i]:GetUnitName() == "water_temple_faceless_water_elemental" then
			  Events:SetPositionCastArgs(unit[i], 1200, 0, 1, FIND_ANY_ORDER)
        	elseif unit:GetUnitName() == "water_temple_prison_guard" then
				unit[i].targetRadius = 300
				unit[i].autoAbilityCD = 2 
			end
          -- if unit[i]:GetUnitName() == "redfall_autumn_monster" then
          --   unit[i].targetRadius = 800
          --   unit[i].autoAbilityCD = 1
          -- elseif unit[i]:GetUnitName() == "crimsyth_bombadier" then
          --   Events:SetPositionCastArgs(unit[i], 1200, 0, 1, FIND_ANY_ORDER)
          -- end
        end
      end
    end)
  end
end

function Tanari:BigDoorBeachRoom()
	Tanari.WaterTemple.SwitchesActive = true
	Tanari.WaterTemple.BigDoorSide = "left"
	Tanari.WaterTemple.BigWaterDoor = Entities:FindByNameNearest("BigWaterTempleDoor", Vector(-14068, 4941, -500), 800)
	Tanari.WaterTemple.BigDoorBlockers = Entities:FindAllByNameWithin("WaterTempleDoorBlocker", Vector(-14080, 4922, 80), 2400)
	local positionTable = {Vector(-15488, 4657), Vector(-15168, 5142), Vector(-15729, 4900)}
	for i = 1, #positionTable, 1 do
		Tanari:SpawnDrownedSorrow(positionTable[i], Vector(0,1))
	end

	local positionTable = {Vector(-15872, 4864), Vector(-14977, 5057), Vector(-15616, 4596)}
	for i = 1, #positionTable, 1 do
		local facingVector = (Vector(-15488, 5440) - positionTable[i]):Normalized()
		Tanari:SpawnWaterManifestation(positionTable[i], facingVector)
	end

	Timers:CreateTimer(2, function()
		Tanari:InitializeRubicksPuzzle()
		Tanari:SpawnSlardarJailer(Vector(-16128, 4224), Vector(1,0))
		Tanari:SpawnSlardarJailer(Vector(-16128, 3904), Vector(1,0))
	end)

	Timers:CreateTimer(3, function()
		for j = 1, 6, 1 do
			Tanari:SpawnSerpentHuntress(Vector(-14400, 4480)+Vector((j-1)*130, 0), Vector(0, -1))
		end
	end)

	Timers:CreateTimer(5, function()
		local spawns = GameState:GetDifficultyFactor() + 3
		for i = 1, spawns, 1 do
			for j = 1, 2, 1 do
				Tanari:SpawnAcqualeenDefector(Vector(-14016, 5312)+Vector(180*(i-1), 170*(j-1)), Vector(0,-1))
			end
		end
	end)

	Timers:CreateTimer(8, function()
		Tanari:SpawnAcqualeenDefector(Vector(-12928, 3968), Vector(0,1))
		Tanari:SpawnAcqualeenDefector(Vector(-12736, 3968), Vector(0,1))
		Tanari:SpawnAcqualeenDefector(Vector(-12544, 3968), Vector(0,1))

		Tanari:SpawnSerpentHuntress(Vector(-12224, 4025), Vector(-1, 0))
		Tanari:SpawnSerpentHuntress(Vector(-12224, 3776), Vector(-1, 0))
	end)

	Timers:CreateTimer(11, function()
		Tanari:SpawnWaterSpiritJailer(Vector(-11200, 4096), Vector(-1,0))
		Tanari:SpawnWaterSpiritJailer(Vector(-11200, 3904), Vector(-1,0))
		Tanari:SpawnWaterSpiritJailer(Vector(-10944, 4131), Vector(-1,-0.2))
		Tanari:SpawnWaterSpiritJailer(Vector(-10944, 3939), Vector(-1,-0.2))
		Tanari:SpawnWaterSpiritJailer(Vector(-10688, 4056), Vector(-1,-0.4))
		Tanari:SpawnWaterSpiritJailer(Vector(-10688, 4248), Vector(-1,-0.4))
		Tanari:SpawnWaterSpiritJailer(Vector(-10756, 4608), Vector(0,-1))
		Tanari:SpawnWaterSpiritJailer(Vector(-10591, 4608), Vector(0,-1))
	end)

	Timers:CreateTimer(12.5, function()
		Tanari:SpawnWaterSpiritJailer(Vector(-11161, 4800), Vector(1,0))
		Tanari:SpawnWaterSpiritJailer(Vector(-11072, 5120), Vector(0,-1))
		Tanari:SpawnWaterSpiritJailer(Vector(-11328, 4800), Vector(0,-1))

		local positionTable = {Vector(-10624, 5312), Vector(-11776, 5376), Vector(-11264, 5760)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 1
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnWaterSpiritBeetle(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 5, 30, patrolPositionTable)
				local elemental = Tanari:SpawnWaterSpiritBeetle(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 5, 30, patrolPositionTable)
			end
		end
	end)

	Timers:CreateTimer(14, function()
		local positionTable = {Vector(-11936, 6358), Vector(-10555, 6358), Vector(-10555, 7628), Vector(-11936, 7628)}
		for i = 1, #positionTable, 1 do
			Tanari:SpawnNagaPriestess(positionTable[i], Vector(0,-1))
		end
	end)
	Timers:CreateTimer(16, function()
		for i = 0, 4, 1 do
			Tanari:SpawnAcqualeenDefector(Vector(-11974, 6824+(190*i)), Vector(0,-1))
		end
		for i = 0, 4, 1 do
			Tanari:SpawnAcqualeenDefector(Vector(-11675+(190*i), 6345), Vector(0,-1))
		end
	end)
end

function Tanari:SpawnAcqualeenDefector(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_temple_aqualeen_defector", position, 0, 3, "Tanari.WaterTempleDefector.Aggro", fv, false)
	mage.itemLevel = 95
	Events:AdjustBossPower(mage, 7, 7, false)
	mage.dominion = true
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	mage:SetRenderColor(150, 150, 255)
	return mage
end

function Tanari:InitializeRubicksPuzzle()
	Tanari.WaterTemple.RubicksGridTable = {}
	-- Tanari.WaterTemple.RubicksPuzzleColors = {1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4}
	Tanari.WaterTemple.RubicksPuzzleColors = {}
	for i = 1, 16, 1 do
		table.insert(Tanari.WaterTemple.RubicksPuzzleColors, RandomInt(1,4))
	end
	local shuffledTable = Tanari:shuffTable(Tanari.WaterTemple.RubicksPuzzleColors)
	--DeepPrintTable(shuffledTable)
	Tanari.WaterTemple.RubicksPuzzleColors = shuffledTable
	Tanari:SetupRubicksSwitches()
	Tanari:RecolorPuzzleBlocks()
	Tanari.WaterTemple.RubicksPhase = 0
	-- for i = 1, #Tanari.WaterTemple.RubicksGridTable, 1 do
	-- 	local block = Tanari.WaterTemple.RubicksGridTable[i]

	-- end
end

function Tanari:RecolorPuzzleBlocks()
	for i = 0, 3, 1 do
		for j = 0, 3, 1 do
			local blockPosition = Vector(-11663, 7424)+Vector(277*j, -272*i)
			local puzzleBlock = Entities:FindByNameNearest("SpiritRubicksPuzzleBlock", blockPosition+Vector(0,0,300), 500)
			table.insert(Tanari.WaterTemple.RubicksGridTable, puzzleBlock)
			local color = Tanari.WaterTemple.RubicksPuzzleColors[(i*4+j+1)]
			Tanari:SetRubicksBlockColor(puzzleBlock, color)
		end
	end
end

function Tanari:SetupRubicksSwitches()
	Tanari.WaterTemple.RubicksSwitchTable = {}
	for i = 0, 3, 1 do
		local position = Vector(-11664+i*290, 6398)
		local thinker = CreateUnitByName("dungeon_thinker", position, false, nil, nil, DOTA_TEAM_NEUTRALS)  
		thinker:SetOriginalModel("models/props_structures/ancient_trigger001.vmdl")
		thinker:SetModel("models/props_structures/ancient_trigger001.vmdl")
		thinker.index = i
		thinker.side = 0
		thinker.enabled = true
		thinker:SetModelScale(0.6)
		thinker:RemoveAbility("dungeon_thinker")
		thinker:RemoveModifierByName("modifier_dungeon_thinker")
		thinker.name = "rubicksSwitch"
		thinker:AddAbility("dungeon_thinker2")
		thinker:FindAbilityByName("dungeon_thinker2"):SetLevel(1)
		thinker:FindAbilityByName("dungeon_thinker2"):ApplyDataDrivenModifier(thinker, thinker, "modifier_dungeon_thinker2", {})
		if thinker:HasAbility("modifier_dungeon_thinker2") then
			--print("HAS DUNGEON THINKER")
		end
		table.insert(Tanari.WaterTemple.RubicksSwitchTable, thinker)
	end
	for i = 0, 3, 1 do
		local position = Vector(-10539, 7446 - i*272)
		local thinker = CreateUnitByName("dungeon_thinker", position, false, nil, nil, DOTA_TEAM_NEUTRALS)  
		thinker:SetOriginalModel("models/props_structures/ancient_trigger001.vmdl")
		thinker:SetModel("models/props_structures/ancient_trigger001.vmdl")
		thinker.index = i
		thinker.side = 1
		thinker.enabled = true
		thinker:SetModelScale(0.6)
		thinker:RemoveAbility("dungeon_thinker")
		thinker:RemoveModifierByName("modifier_dungeon_thinker")
		thinker.name = "rubicksSwitch"
		thinker:AddAbility("dungeon_thinker2")
		thinker:FindAbilityByName("dungeon_thinker2"):SetLevel(1)
		thinker:FindAbilityByName("dungeon_thinker2"):ApplyDataDrivenModifier(thinker, thinker, "modifier_dungeon_thinker2", {})
		if thinker:HasAbility("modifier_dungeon_thinker2") then
			--print("HAS DUNGEON THINKER")
		end
		table.insert(Tanari.WaterTemple.RubicksSwitchTable, thinker)
	end
end

function Tanari:WaterTempleRubicksSwitch(switch)
	if switch.enabled then
	    StartAnimation(switch, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
	    EmitSoundOn("Tanari.CastleSwitch.Press", switch)
		if switch.enabled then
		    StartAnimation(switch, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
		    EmitSoundOn("Tanari.CastleSwitch.Press", switch)
			if switch.side == 0 then
				local newColumnTable = {}
				for i = 0, 3, 1 do
					local index = 1 + (i+1)*4 + switch.index
					if index > 16 then
						index = index - 16
					end
					table.insert(newColumnTable, Tanari.WaterTemple.RubicksPuzzleColors[index])
				end

				for i = 1, 4, 1 do
					local index = 1 + (i+1)*4 + switch.index
					if index > 16 then
						index = index - 16
					end
					Tanari.WaterTemple.RubicksPuzzleColors[index] = newColumnTable[i]
				end			
			elseif switch.side == 1 then
				local newRowTable = {}
				local row = switch.index + 1
				--print("Row: "..row)
				for i = 0, 3, 1 do
					local addition = i
					if i == 0 then
						addition = 4
					end
					local index = ((row-1)*4) + addition
					if index > 16 then
						index = index - 16
					end
					table.insert(newRowTable, Tanari.WaterTemple.RubicksPuzzleColors[index])
				end

				for i = 1, 4, 1 do
					local addition = i
					if i == 0 then
						addition = 4
					end
					local index = ((row-1)*4) + addition
					if index > 16 then
						index = index - 16
					end
					Tanari.WaterTemple.RubicksPuzzleColors[index] = newRowTable[i]
				end
			end
			Tanari:RecolorPuzzleBlocks()
			Tanari:CheckRubicksConditions()
		end
	end
end

function Tanari:SetRubicksBlockColor(puzzleBlock, color)
	if color == 1 then
		puzzleBlock:SetRenderColor(255, 160, 160)
	elseif color == 2 then
		puzzleBlock:SetRenderColor(160, 255, 160)
	elseif color == 3 then
		puzzleBlock:SetRenderColor(160, 160, 255)
	elseif color == 4 then
		puzzleBlock:SetRenderColor(255, 255, 160)
	elseif color == 0 then
		puzzleBlock:SetRenderColor(50, 50, 50)
	end
end

function Tanari:CheckRubicksConditions()
	local totalCheck = true
	if not Tanari.WaterTemple.allowedColors then
		Tanari.WaterTemple.allowedColors = {1,2,3,4}
	end
	if #Tanari.WaterTemple.allowedColors == 1 then
		for k = 1, #Tanari.WaterTemple.RubicksSwitchTable, 1 do
			Tanari.WaterTemple.RubicksSwitchTable[k].enabled = false
		end
		for g = 1, 16, 1 do
			Tanari.WaterTemple.RubicksPuzzleColors[g] = 0
		end
		Tanari:RecolorPuzzleBlocks()
		Tanari:RubicksPuzzleComplete()
		return false
	end
	local megaCheck = true
	for g = 2, 16, 1 do
		if Tanari.WaterTemple.RubicksPuzzleColors[g] == Tanari.WaterTemple.RubicksPuzzleColors[g-1] then
		else
			megaCheck = false
		end
	end
	if megaCheck then
		Tanari:RecolorPuzzleBlocks()
		Tanari:RubicksPuzzleComplete()		
		return false
	end	
	if Tanari.WaterTemple.RubicksPhase >= 0 then
		local sameColor = false
		--row check
		for i = 0, 3, 1 do
			for j = 1, 3, 1 do
				local index = 1 + i*4
				local comparator = index + j
				if Tanari.WaterTemple.RubicksPuzzleColors[index] == Tanari.WaterTemple.RubicksPuzzleColors[index+j] and Tanari.WaterTemple.RubicksPuzzleColors[index+1] == Tanari.WaterTemple.RubicksPuzzleColors[index+j+1] and Tanari.WaterTemple.RubicksPuzzleColors[index+2] == Tanari.WaterTemple.RubicksPuzzleColors[index+j+2] then
					sameColor = true
				end
			end
			if sameColor then
				local index = 1 + i*4
				local color = Tanari.WaterTemple.RubicksPuzzleColors[index]

				local newAllowedColors = {}
				for d = 1, #Tanari.WaterTemple.allowedColors, 1 do
					if Tanari.WaterTemple.allowedColors[d] == color then
					else
						table.insert(newAllowedColors, Tanari.WaterTemple.allowedColors[d])
					end
				end
				Tanari.WaterTemple.allowedColors = newAllowedColors

				for k = 1, #Tanari.WaterTemple.RubicksSwitchTable, 1 do
					Tanari.WaterTemple.RubicksSwitchTable[k].enabled = false
				end
				for g = 1, 16, 1 do
					if Tanari.WaterTemple.RubicksPuzzleColors[g] == color then
						Tanari.WaterTemple.RubicksPuzzleColors[g] = 0
					end
				end
				Tanari:RecolorPuzzleBlocks()
				Timers:CreateTimer(1.5, function()
					for k = 1, #Tanari.WaterTemple.RubicksSwitchTable, 1 do
						Tanari.WaterTemple.RubicksSwitchTable[k].enabled = true
					end
					for g = 1, #Tanari.WaterTemple.RubicksPuzzleColors, 1 do
						if Tanari.WaterTemple.RubicksPuzzleColors[g] == 0 then
							Tanari.WaterTemple.RubicksPuzzleColors[g] = Tanari.WaterTemple.allowedColors[RandomInt(1, #Tanari.WaterTemple.allowedColors)]
						end
					end
					Tanari:RecolorPuzzleBlocks()
					-- Tanari:CheckRubicksConditions()
				end)
				Tanari.WaterTemple.RubicksPhase = 1
				break
			end
		end
		--column check
		for i = 0, 3, 1 do
			local columnReinforce = true
			for j = 1, 3, 1 do
				local index = i + 1
				local comparator = index + j*4
				if comparator > 16 then
					comparator = comparator - 16
				end
				if Tanari.WaterTemple.RubicksPuzzleColors[index] == Tanari.WaterTemple.RubicksPuzzleColors[comparator] then
				else
					columnReinforce = false
				end
			end
			if columnReinforce then
				local index = 1 + i
				local color = Tanari.WaterTemple.RubicksPuzzleColors[index]
				local newAllowedColors = {}
				for d = 1, #Tanari.WaterTemple.allowedColors, 1 do
					if Tanari.WaterTemple.allowedColors[d] == color then
					else
						table.insert(newAllowedColors, Tanari.WaterTemple.allowedColors[d])
					end
				end
				Tanari.WaterTemple.allowedColors = newAllowedColors
				for k = 1, #Tanari.WaterTemple.RubicksSwitchTable, 1 do
					Tanari.WaterTemple.RubicksSwitchTable[k].enabled = false
				end
				for g = 1, 16, 1 do
					if Tanari.WaterTemple.RubicksPuzzleColors[g] == color then
						Tanari.WaterTemple.RubicksPuzzleColors[g] = 0
					end
				end
				Tanari:RecolorPuzzleBlocks()
				Timers:CreateTimer(1.5, function()
					for k = 1, #Tanari.WaterTemple.RubicksSwitchTable, 1 do
						Tanari.WaterTemple.RubicksSwitchTable[k].enabled = true
					end
					for g = 1, #Tanari.WaterTemple.RubicksPuzzleColors, 1 do
						if Tanari.WaterTemple.RubicksPuzzleColors[g] == 0 then
							Tanari.WaterTemple.RubicksPuzzleColors[g] = Tanari.WaterTemple.allowedColors[RandomInt(1, #Tanari.WaterTemple.allowedColors)]
						end
					end
					Tanari:RecolorPuzzleBlocks()
					-- Tanari:CheckRubicksConditions()
				end)
				Tanari.WaterTemple.RubicksPhase = 1
				break
			end
		end		
	end
end

function Tanari:shuffTable(t)
	local n = #t -- gets the length of the table 
	while n >= 2 do -- only run if the table has more than 1 element
		local k = math.random(n) -- get a random number
		t[n], t[k] = t[k], t[n]
		n = n - 1
	end
	return t
end

function Tanari:RubicksPuzzleComplete()
	Tanari.WaterTemple.RubicksComplete = true
	if #Tanari.WaterTemple.RubicksSwitchTable > 0 then
		for i = 1, #Tanari.WaterTemple.RubicksSwitchTable, 1 do
			local switch = Tanari.WaterTemple.RubicksSwitchTable[i]
			switch.enabled = false
			for j = 1, 30, 1 do
			  Timers:CreateTimer(j*0.03, function()
			    switch:SetAbsOrigin(switch:GetAbsOrigin()-Vector(0,0,1.6))
			  end)
			end
			Timers:CreateTimer(0.3, function()
			  local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
			  local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			  ParticleManager:SetParticleControl(particle1,0,switch:GetAbsOrigin())
			  Timers:CreateTimer(2, function()
			    ParticleManager:DestroyParticle( particle1, false )
			  end)
			end)
			Timers:CreateTimer(1, function()
			  UTIL_Remove(switch)
			end)
		end
		Tanari.WaterTemple.RubicksSwitchTable = {}
		EmitSoundOnLocationWithCaster(Vector(-11195, 7824), "WaterTemple.SpiritStatue", Events.GameMaster)
		Timers:CreateTimer(3, function()
			Tanari:LowerWaterTempleWall(-6, "WaterTempleSpiritWall", Vector(-11908, 8079, 200), "WaterSpiritBlocker", Vector(-11908, 8079, 200), 1200, true, false)
		end)
		local particleName = "particles/econ/events/ti5/town_portal_start_lvl2_black_ti5.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, Vector(-11182, 7924, 845))
		ParticleManager:SetParticleControl(pfx, 0, Vector(-11182, 7924, 845))
	end
end

function Tanari:SpawnNagaPriestess(position, fv)
	local mage = Tanari:SpawnDungeonUnit("water_temple_stone_priestess", position, 0, 3, "Tanari.WaterPriestess.Aggro", fv, false)
	mage.itemLevel = 92
	Events:AdjustBossPower(mage, 5, 5, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Events:SetTargetCastArgs(mage, 1200, 0, 1, FIND_ANY_ORDER)
	return mage
end

function Tanari:InitiateLastSpiritRoom()
	Tanari:SpawnDrownedSorrow(Vector(-11072, 2552), Vector(1,0))
	Tanari:SpawnDrownedSorrow(Vector(-10837, 2816), Vector(1,0))
	Tanari:SpawnDrownedSorrow(Vector(-10688, 2368), Vector(1,0))

	Tanari:SpawnSlardarJailer(Vector(-11008, 1664), Vector(0,1))
	Tanari:SpawnSlardarJailer(Vector(-10995, 1833), Vector(0,1))
	Tanari:SpawnSlardarJailer(Vector(-10816, 1856), Vector(0,1))

	Timers:CreateTimer(1, function()
		Tanari:SpawnNagaPriestess(Vector(-11712, 2944), Vector(0,-1))
		Tanari:SpawnNagaPriestess(Vector(-11712, 1792), Vector(0,1))
		Tanari:SpawnWaterSpiritBeetle(Vector(-11294, 1945), RandomVector(1))
	end)

	Timers:CreateTimer(2, function()
		local positionTable = {Vector(-12096, 2240), Vector(-14416, 2240), Vector(-12804, 2240), Vector(-13177, 2240), Vector(-13568, 2240), Vector(-14016, 2240), Vector(-14528, 2240), Vector(-15040, 2240)}
		for i = 1, #positionTable, 1 do
			for j = 0, 1 do
				Tanari:SpawnAcqualeenDefector(positionTable[i]+Vector(0,190*j, 0), Vector(1,0))
			end
		end
	end)
	Timers:CreateTimer(3, function()
		for i = 0, 2, 1 do
			Tanari:SpawnSerpentHuntress(Vector(-14293+(500*i), 1728), Vector(0,1))
			Tanari:SpawnSerpentHuntress(Vector(-13376+(500*i), 1922), Vector(0,1))
			Tanari:SpawnSerpentHuntress(Vector(-13184+(500*i), 1922), Vector(0,1))
		end
	end)
	Timers:CreateTimer(4, function()
		for i = 0, 2, 1 do
			Tanari:SpawnSerpentHuntress(Vector(-13404+(500*i), 2672), Vector(0,-1))
			Tanari:SpawnSerpentHuntress(Vector(-13212+(500*i), 2672), Vector(0,-1))
			Tanari:SpawnSerpentHuntress(Vector(-13295+(500*i), 2866), Vector(0,-1))
		end
	end)
	Timers:CreateTimer(6, function()
		local positionTable = {Vector(-15360, 1764), Vector(-14976, 1764), Vector(-14592, 1764), Vector(-14208, 1764), Vector(-13760, 1764)}
		for i = 1, #positionTable, 1 do
			Tanari:SpawnVaultKing(positionTable[i], Vector(0,1))
		end
		for i = 1, #positionTable, 1 do
			Tanari:SpawnVaultKing(positionTable[i]+Vector(0,1000), Vector(0,-1))
		end
	end)
	Timers:CreateTimer(8, function()
		local positionTable = {Vector(-13824, 1792), Vector(-13824, 2844)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 3
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnWaterManifestation(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 4, 30, patrolPositionTable)
			end
		end
	end)
	Tanari:SpawnIceQueen(Vector(-15552, 2304), Vector(1,0))
end

function Tanari:SpawnIceQueen(position, fv)
	local mage = Tanari:SpawnDungeonUnit("ice_queen_alarana", position, 2, 4, "Tanari.IceQueen.Aggro", fv, false)
	mage.itemLevel = 110
	Events:AdjustBossPower(mage, 12, 12, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_blue", {})

	return mage
end

function Tanari:SpawnSlithereenEliteWarrior(position, fv)
	local mage = Tanari:SpawnDungeonUnit("slithereen_elite_warrior", position, 2, 4, "Tanari.SlithElite.Aggro", fv, false)
	mage.itemLevel = 110
	Events:AdjustBossPower(mage, 6, 6, false)
	Events:SetTargetCastArgs(mage, 1200, 0, 2, FIND_ANY_ORDER)
	mage.castAnimation = ACT_DOTA_CAST_ABILITY_4
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	mage:SetRenderColor(100, 100, 100)
	return mage
end

function Tanari:SpawnSpiritMountain()
	local positionTable = {Vector(11072, -192), Vector(11584, 8), Vector(12224, 374), Vector(12928, 534), Vector(13568, 534), Vector(14219, -64), Vector(14573, -768), Vector(14573, -1408), Vector(14573, -2048), Vector(14144, -2353), Vector(13440, -2241), Vector(12544, -2241), Vector(11776, -2032), Vector(11072, -1917), Vector(10432, -1701)}
	for i = 1, #positionTable, 1 do
		Tanari:SpawnSlithereenEliteWarrior(positionTable[i], RandomVector(1))
	end
end

function Tanari:SpawnWaterSpiritFinalBoss()
	local guardian = Events:SpawnBoss("tanari_water_spirit_boss", Vector(12992,-1024))
	guardian.pushLock = true
	guardian.jumpLock = true
	guardian:SetAbsOrigin(guardian:GetAbsOrigin()-Vector(0,0,1400))
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, guardian, "tanari_mountain_specter_ai", {})
	-- local guardian = CreateUnitByName("wind_temple_spirit_boss", Vector(12992, 1536), false, nil, nil, DOTA_TEAM_NEUTRALS)
	guardian:SetForwardVector(Vector(0,-1))
	Events:AdjustBossPower(guardian, 12, 12, false)
	local bossAbility = guardian:FindAbilityByName("water_spirit_main_boss_ability")
	bossAbility:ApplyDataDrivenModifier(guardian, guardian, "modifier_main_boss_entering", {})
      local properties =  {
        roll = 0,
        pitch = 0,
        yaw = 0,
        XPos = -20,
        YPos = 0,
        ZPos = -150,
      }
      Attachments:AttachProp(guardian, "attach_head", "models/items/axe/shout_mask/shout_mask.vmdl", 1.3, properties)
    for i = 0, 2, 1 do
    	Timers:CreateTimer(i*2, function()
			local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
			local particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, statue )
			ParticleManager:SetParticleControl( particle, 0, Vector(12992, -1024, 1100))
			Timers:CreateTimer(5.2, function()
				ParticleManager:DestroyParticle(particle, false)
			end)
		end)
	end
	for i = 1, 6, 1 do
		Timers:CreateTimer(i*0.6, function()
			ScreenShake(guardian:GetAbsOrigin(), 3000, 0.9, 0.9, 9000, 1, true)
			EmitSoundOnLocationWithCaster(guardian:GetAbsOrigin(), "Tanari.Shake", Events.GameMaster)
		end)
	end
	Timers:CreateTimer(0, function()
		EmitSoundOnLocationWithCaster(Vector(12992, -1024), "Tanari.WaterSpiritBoss.Music", Events.GameMaster)
		if not Tanari.WaterSpiritBossDead then
			return 52
		end
	end)
	
     Timers:CreateTimer(4, function()
	     for i = 1, 50, 1 do
	     	Timers:CreateTimer(i*0.03, function()
	     		guardian:SetAbsOrigin(guardian:GetAbsOrigin()+Vector(0,0,1000/50))
	     		ScreenShake(guardian:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
	     	end)
	     end
	    Timers:CreateTimer(0.8, function()
			StartAnimation(guardian, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
			Timers:CreateTimer(0.18, function()
		      particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, guardian )
		      ParticleManager:SetParticleControl( particle1, 0, Vector(12992, -1024, 1000) )
		      EmitSoundOn("Tanari.WaterSplash", guardian)
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)
			end)
		end)
		Timers:CreateTimer(2.5, function()
			EmitGlobalSound("Tanari.WaterSpiritMainBoss.Aggro")
			guardian:RemoveModifierByName("modifier_main_boss_entering")
			guardian:SetAbsOrigin(guardian:GetAbsOrigin()-Vector(0,0,400))
			bossAbility:ApplyDataDrivenModifier(guardian, guardian, "modifier_spirit_boss_fighting", {})
		end)
	end)
end
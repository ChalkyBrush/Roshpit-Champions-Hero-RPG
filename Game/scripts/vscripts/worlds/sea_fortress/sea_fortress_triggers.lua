function FishSpawn1(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-512, -11136), false)
end

function FishSpawn2(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-1664, -9884), false)
end

function FishSpawn3(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-1344, -8576), false)
end

function FishSpawn4(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(1088, -8832), false)
end

function FishSpawn5(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(2368, -10112), false)
end

function FishSpawn6(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(1408, -10816), false)
end

function FishSpawn7(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-14272, -11712, -60+Seafortress.ZFLOAT), true)
end

function FishSpawn8(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-13508, -11840, -60+Seafortress.ZFLOAT), true)
end

function FishSpawn9(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-13888, -11328, -60+Seafortress.ZFLOAT), true)
end

function FishSpawn10(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-13760, -4416, -1+Seafortress.ZFLOAT), true)
end

function FishSpawn11(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-14912, -3356, -1+Seafortress.ZFLOAT), true)
end

function FishSpawn12(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-11734, -4428, -1+Seafortress.ZFLOAT), true)
end

function FishSpawn13(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-9070, 256, -1+Seafortress.ZFLOAT), true)
end

function FishSpawn14(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-9070, 1145, -1+Seafortress.ZFLOAT), true)
end

function FishSpawn15(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-15552, -64, -1+Seafortress.ZFLOAT), true)
end

function FishSpawn16(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-9408, 3485, -1+Seafortress.ZFLOAT), true)
end

function FishSpawn17(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-6464, 3840, -1+Seafortress.ZFLOAT), true)
end

function FishSpawn18(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-8704, 6144, -1+Seafortress.ZFLOAT), true)
end


function GenericFishSpawn(hero, basePos, bForcePos)
	for j = 1, 3, 1 do
		Timers:CreateTimer((j-1)*1.5, function()
			for i = 0, 3, 1 do
				Timers:CreateTimer(i*0.2, function()
					local position = basePos+RandomVector(RandomInt(0, 140))
					local fv = ((hero:GetAbsOrigin()-position)*Vector(1,1,0)):Normalized()
					Seafortress:SpawnLakeCheep(position, fv, bForcePos)
				end)
			end
		end)
	end
end

function SpawnScorchers(trigger)
	local positionTable = {Vector(-9600, -14016), Vector(-9600, -13632), Vector(-9600, -13248)}
	for i = 1, #positionTable, 1 do
		local caster = Seafortress:SpawnWaterScorcher(positionTable[i], Vector(-1,0))
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,34*17))
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
		for i = 1, 17, 1 do
			Timers:CreateTimer(0.03*i, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,34))
			end)
		end
		Timers:CreateTimer(0.18, function()
	      particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,140) )
	      EmitSoundOn("Tanari.WaterSplash", caster)
	      Timers:CreateTimer(4, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
		end)
	end
end

function MountainBeasts(trigger)
	Seafortress.BeastTable = {}
	local pfx = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_water_blue_wood.vpcf", PATTACH_CUSTOMORIGIN, Seafortress.Master)
	ParticleManager:SetParticleControl(pfx, 0, Vector(-10816, -14260, 670+Seafortress.ZFLOAT))
	EmitSoundOnLocationWithCaster(Vector(-10816, -14260), "Seafortress.Beast.Activate", Seafortress.Master)
	Timers:CreateTimer(2, function()
		local beast1 = Entities:FindByNameNearest("MountainBeastStatue", Vector(-11208, -13696, 512+Seafortress.ZFLOAT), 1000)
		OpenBeast(beast1, Vector(1, -0.3))
		Timers:CreateTimer(5, function()
			local beast2 = Entities:FindByNameNearest("MountainBeastStatue", Vector(-11476, -14244, 512+Seafortress.ZFLOAT), 1000)
			OpenBeast(beast2, Vector(1, 0))
		end)
		Timers:CreateTimer(10, function()
			local beast3 = Entities:FindByNameNearest("MountainBeastStatue", Vector(-11208, -14784, 512+Seafortress.ZFLOAT), 1000)
			OpenBeast(beast3, Vector(1, 0.15))
		end)
	end)
	Timers:CreateTimer(19, function()
		local basePos = Vector(-10944, -14979)
		for i = 1, #Seafortress.BeastTable, 1 do
			StartAnimation(Seafortress.BeastTable[i], {duration=1, activity=ACT_DOTA_RUN, rate=1.5}) 
			EmitSoundOn("Seafortress.Beast.ShatterVO", (Seafortress.BeastTable[i]))
		end
		for j = 1, 30, 1 do
			Timers:CreateTimer(j*0.06, function()
				local randX = RandomInt(1, 700)
				local randY = RandomInt(1, 1700)
				local blossom = Seafortress:SpawnGroveBlossom(basePos + Vector(randX, randY), RandomVector(1))
				EmitSoundOn("Seafortress.SpawnGroveBlossom", blossom)
				blossom.deathCode = 4

			end)
		end
	end)
end

function OpenBeast(beast, fv)
	for i = 1, 120, 1 do
		Timers:CreateTimer(i*0.03, function()
			local moveVector = beast:GetAbsOrigin()+Vector(0,15,0)
			if i%2 == 0 then
				moveVector = beast:GetAbsOrigin()-Vector(0,15,0)
			end
			if i%30 == 1 then
				EmitSoundOnLocationWithCaster(beast:GetAbsOrigin(), "Seafortress.Beast.Shake", Events.GameMaster)
				local particle = ParticleManager:CreateParticle("particles/roshpit/seafortress/helix_effect.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(particle, 0, beast:GetAbsOrigin())
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(particle, false)
				end)
			end
			beast:SetAbsOrigin(moveVector)
		end)
	end
	Timers:CreateTimer(3.66, function()
		EmitSoundOnLocationWithCaster(beast:GetAbsOrigin(), "Seafortress.Beast.Shatter", Seafortress.Master)
		local beastUnit = Seafortress:SpawnMountainBeast(beast:GetAbsOrigin(), fv)
		table.insert(Seafortress.BeastTable, beastUnit)
		Timers:CreateTimer(1, function()
			EmitSoundOn("Seafortress.Beast.ShatterVO", beastUnit)
		end)
		CustomAbilities:QuickAttachParticle( "particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", beastUnit, 6)
		UTIL_Remove(beast)
	end)
end

function SwampTriggerSpawn()
	Seafortress:SwampTriggerSpawn()
end

function SwampTriggerSpawn2()
	Seafortress:SwampTriggerSpawn2()
end

function SeaFortressSwitchA()

	print("SWITCH A")
	if Seafortress.RevenantDead then
		if not Seafortress.SwitchA then
			Seafortress.SwitchA = true
			Seafortress:ActivateSwitchGeneric(Vector(-12913, -9341, 139), "CastleSwitch1a", true, 0.6)
			Timers:CreateTimer(1, function()
				local wall = Entities:FindByNameNearest("SeaDoor3", Vector(-15234, -7158, 527+Seafortress.ZFLOAT), 900)
				Seafortress:Walls(false, {wall}, true, 4)
				Seafortress:RemoveBlockers(5, "SeaBlocker1", Vector(-15360, -7154, 121), 1400)
				Seafortress:SpawnCanyonRoom()
			end)
		end
	else
	end
end

function SeafortTempleSpawn(trigger)
	local hero = trigger.activator
	GenericFishSpawn(hero, Vector(-9167, -4909, -1+Seafortress.ZFLOAT), true)
	Timers:CreateTimer(3, function()
		GenericFishSpawn(hero, Vector(-8835, -4909, -1+Seafortress.ZFLOAT), true)
	end)
	Seafortress:SpawnSeaTemple()
end

function SeaFortressSwitchB()

	print("SWITCH B")
	if Seafortress.UrsanDead then
		if not Seafortress.SwitchB then
			Seafortress.SwitchB = true
			Seafortress:ActivateSwitchGeneric(Vector(-9316, 2084, 12+Seafortress.ZFLOAT), "CastleSwitch2", true, 0.404)
			Timers:CreateTimer(1, function()
				local wall = Entities:FindByNameNearest("SeaDoor4", Vector(-10846, 640, -120+Seafortress.ZFLOAT), 900)
				Seafortress:Walls(false, {wall}, true, 4)
				Seafortress:RemoveBlockers(5, "SeaBlocker2", Vector(-10795, 640, 127), 1800)
				Seafortress:SpawnAfterTempleRoom()
			end)
		end
	else
	end
end

function SeaFortressSwitchC()
	if not Seafortress.switchClock then
		if Seafortress.laserCrystalPopped then
			return false
		end
		Seafortress.switchClock = true
		Seafortress:ActivateSwitchGeneric(Vector(-14559, 1498, 12+Seafortress.ZFLOAT), "SeafortSwitch1", true, 0.37)
		Seafortress:activateLaserMech(Seafortress.LaserMechTable[1])
		Timers:CreateTimer(0.2, function()
			if Seafortress.laserCrystalPopped then
				return false
			end
			local enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(-14559, 1498), nil, 250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
			if #enemies == 0 then
				if Seafortress.switchClock then

					Seafortress:ActivateSwitchGeneric(Vector(-14559, 1498, 12+Seafortress.ZFLOAT), "SeafortSwitch1", false, 0.37)
					Timers:CreateTimer(0.2, function()
						Seafortress.switchClock = false
						for i = 1, #Seafortress.LaserMechTable, 1 do
							Seafortress.deactivateLaserMech(Seafortress.LaserMechTable[i])
						end
					end)
				end
			else
				return 0.2
			end
		end)
	end
end

function SeaFortressSwitchCEND()
end

function SeaFortressSwitchD()
	Seafortress:ActivateSwitchGeneric(Vector(1305, -11464, 401+Seafortress.ZFLOAT), "CastleSwitch3", true, 0.408)
	Timers:CreateTimer(1, function()
		local wall = Entities:FindByNameNearest("SeaDoor1", Vector(3530, -8942, 506+Seafortress.ZFLOAT), 1100)
		Seafortress:Walls(false, {wall}, true, 4.3)
		Seafortress:RemoveBlockers(5, "SeaBlocker1", Vector(3530, -8942, 506+Seafortress.ZFLOAT), 1200)
		Seafortress:SpawnFirstCaveRoom()
	end)
end

function SeaFortressSwitchE()
	Seafortress:ActivateSwitchGeneric(Vector(4722, -12329, 401+Seafortress.ZFLOAT), "CastleSwitch4", true, 0.408)
	Timers:CreateTimer(1, function()
		local walls = Entities:FindAllByNameWithin("SeaDoor6", Vector(6818, -11600, 132+Seafortress.ZFLOAT), 1200)
		Seafortress:Walls(false, walls, true, 4.2)
		Seafortress:RemoveBlockers(5, "SeaBlocker4", Vector(6804, -11776, 345+Seafortress.ZFLOAT), 1800)
		Seafortress:SpawnSecondCaveRoom()
	end)
end

function SeaFortressSwitchF()
	if not Seafortress.CaveSwitchesPressed then
		Seafortress.CaveSwitchesPressed = 0
	end
	Seafortress.CaveSwitchesPressed = Seafortress.CaveSwitchesPressed + 1
	Seafortress:ActivateSwitchGeneric(Vector(7366, -15589, 142+Seafortress.ZFLOAT), "CastleSwitch4", true, 0.408)
	Timers:CreateTimer(1, function()
		local walls = Entities:FindAllByNameWithin("SeaDoor7", Vector(11712, -14330, 132+Seafortress.ZFLOAT), 1200)
		Seafortress:Walls(false, walls, true, 4.2)
		Seafortress:RemoveBlockers(5, "SeaBlocker6", Vector(11712, -14400, 278+Seafortress.ZFLOAT), 1800)
	end)
	checkAllSwitches()
end

function SeaFortressSwitchG()
	if not Seafortress.CaveSwitchesPressed then
		Seafortress.CaveSwitchesPressed = 0
	end
	Seafortress.CaveSwitchesPressed = Seafortress.CaveSwitchesPressed + 1
	Seafortress:ActivateSwitchGeneric(Vector(7948, -8368, 142+Seafortress.ZFLOAT), "CastleSwitch4", true, 0.408)
	Timers:CreateTimer(1, function()
		local walls = Entities:FindAllByNameWithin("SeaDoor6", Vector(11289, -14330, 132+Seafortress.ZFLOAT), 1200)
		Seafortress:Walls(false, walls, true, 4.2)
		Seafortress:RemoveBlockers(5, "SeaBlocker5", Vector(11276, -14400, 278+Seafortress.ZFLOAT), 1800)
	end)
	checkAllSwitches()
end

function checkAllSwitches()
	if Seafortress.CaveSwitchesPressed == 2 then
		Seafortress:SpawnJailRoom()
	end
end

function JailSwitch1()
	Seafortress:OpenJailGate(Vector(13097, -15095, 12+Seafortress.ZFLOAT), Vector(14305, -14933, 131), 1, true)
end

function JailSwitch2()
	Seafortress:OpenJailGate(Vector(12711, -13328, 12+Seafortress.ZFLOAT), Vector(14305, -13272, 131), 2, true)
end

function JailSwitch3()
	Seafortress:OpenJailGate(Vector(12820, -12086, 12+Seafortress.ZFLOAT), Vector(14305, -12017, 131), 3, true)
end

function JailSwitch4()
	Seafortress:OpenJailGate(Vector(13610, -10806, 12+Seafortress.ZFLOAT), Vector(14305, -10767, 131), 4, true)
end

function JailSwitch5()
	Seafortress:OpenJailGate(Vector(13094, -8982, 12+Seafortress.ZFLOAT), Vector(14305, -9512, 131), 5, true)
end

function SeaFortressSwitchH()
	Seafortress:ActivateSwitchGeneric(Vector(5690, -2622, 266+Seafortress.ZFLOAT), "CastleSwitch4", true, 0.408)
	Timers:CreateTimer(1, function()
		Seafortress.MazeExitPortalActive = true
		EmitGlobalSound("ui.set_applied")
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(5676, -3129, 370+Seafortress.ZFLOAT), Events.GameMaster, 0, Vector(0.55, 0.55, 0.55))
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(14502, -5342, 370+Seafortress.ZFLOAT), Events.GameMaster, 0, Vector(0.55, 0.55, 0.55))
	end)
end

function MazeExitTeleport1(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_recently_teleported_portal") then
		if Seafortress.MazeExitPortalActive then
			local portToVector = Vector(5676, -3129)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function MazeExitTeleport2(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_recently_teleported_portal") then
		if Seafortress.MazeExitPortalActive then
			local portToVector = Vector(14502, -5342)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function DeepRoomSpawn()
	Seafortress:SpawnDeepRoom()
end

function LightningZapper1(trigger)
	local hero = trigger.activator
	if not Seafortress.ZapBlocker1 then
		Seafortress:ElectrocuteUnit(hero, Vector(0,1))
	end
end

function LightningZapper2(trigger)
	local hero = trigger.activator
	if not Seafortress.ZapBlocker2 then
		Seafortress:ElectrocuteUnit(hero, Vector(0,-1))
	end
end

function LightningZapper3(trigger)
	local hero = trigger.activator
	if not Seafortress.ZapBlocker3 then
		Seafortress:ElectrocuteUnit(hero, Vector(0,1))
	end
end

function SeaFortressSwitchI(trigger)
	local hero = trigger.activator
	Seafortress:ActivateSwitchGeneric(Vector(2961, -14194, 501+Seafortress.ZFLOAT), "CastleSwitch3", true, 0.408)
	Timers:CreateTimer(1, function()
		Dungeons:CreateBasicCameraLockForHeroes(Vector(510, -7137, 197+Seafortress.ZFLOAT), 2.2, {hero})
		local wall = Entities:FindByNameNearest("SeaDoor1", Vector(510, -7137, 197+Seafortress.ZFLOAT), 1100)
		Seafortress:Walls(false, {wall}, true, 4.3)
		Seafortress:RemoveBlockers(5, "SeaBlocker1", Vector(576, -7105, 240+Seafortress.ZFLOAT), 1200)
		Seafortress:SpawnFirstTempleRoom()
	end)
end

function GreenBeaconTrigger(trigger)
	local hero = trigger.activator
	print("HELLO?")
	if hero:HasModifier("modifier_sea_fortress_green_beacon") then
		return false
	end
	if Seafortress.MaidenDead then
		hero:SetAbsOrigin(Seafortress.Jumper:GetAbsOrigin())
		EmitSoundOn("Seafortress.GreenBeacon.Lift", hero)
		Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, hero, "modifier_sea_fortress_green_beacon", {duration = 3.5})
		StartAnimation(hero, {duration=3.5, activity=ACT_DOTA_FLAIL, rate=0.7})
		for i = 1, 50, 1 do
			Timers:CreateTimer(i*0.03, function()
				hero:SetAbsOrigin(hero:GetAbsOrigin()+Vector(0,0,i*0.3))
			end)
		end 
		Events:LockCameraWithDuration(hero, 4.5)
		Timers:CreateTimer(1.53, function()
			local fv = ((Vector(2635, -14187) - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			EmitSoundOn("Seafortress.GreenBeacon.Throw", hero)
			hero.jumpEnd = "basic_dust"
			WallPhysics:Jump(hero, fv, 68, 37, 52, 1)
		end)
	end
end

function SeaFortressSwitchTemple1()
	Seafortress:ActivateSwitchGeneric(Vector(2264, -6645, 131+Seafortress.ZFLOAT), "CastleSwitch3", true, 0.408)
	Timers:CreateTimer(1, function()
		local wall = Entities:FindByNameNearest("SeaDoor8", Vector(2279, -6390, -185+Seafortress.ZFLOAT), 1100)
		Seafortress:Walls(false, {wall}, true, 4.3)
		Seafortress:RemoveBlockers(4, "SeaBlocker7", Vector(2304, -6388, 240+Seafortress.ZFLOAT), 1200)
		Seafortress:SpawnInnerTempleRoom2()
	end)
end

function SeaFortressSwitchTemple2()
	Seafortress:ActivateSwitchGeneric(Vector(1928, -4641, 0+Seafortress.ZFLOAT), "CastleSwitch3", true, 0.408)
	Timers:CreateTimer(1, function()
		local wall = Entities:FindByNameNearest("SeaDoor9", Vector(1187, -3694, 76+Seafortress.ZFLOAT), 1100)
		Seafortress:Walls(false, {wall}, true, 4.3)
		Seafortress:RemoveBlockers(4, "SeaBlocker8", Vector(1187, -3712, 191+Seafortress.ZFLOAT), 1200)
		Seafortress:SpawnInnerTempleRoom3()
	end)
end

function MemorySwitchTrigger(trigger)
	--48 switches
	if not Seafortress.MemoryTable then
		InitMemoryTable()
	end
	local caller = trigger.caller
	print(caller:GetName())
	print(caller:GetAbsOrigin())
	local switchIndex = caller:GetName():gsub('MemorySwitchTrigger', "")
	switchIndex = tonumber(switchIndex)
	local button = Entities:FindByNameNearest("MemorySwitch", caller:GetAbsOrigin(), 200)
	ButtonPress(switchIndex, button, trigger.activator)
end

function ButtonPress(buttonIndex, button, hero)
	if Seafortress.MemoryActivated[buttonIndex] == 1 then
		return false
	end
	if Seafortress.MemorySwitchesPressed[1] == buttonIndex then
		return false
	end
	if Seafortress.MemoryPuzzleComplete then
		return false
	end
	if Seafortress.MemorySwitchesPressed[1] and Seafortress.MemorySwitchesPressed[2] then
		return false
	end
	local colorVector = GetMemoryButtonColorVector(buttonIndex)
	Seafortress:smoothColorTransition(button, Vector(255,255,255), colorVector, 30)

	pushButtonDown(button, false)
	if not Seafortress.MemorySwitchesPressed[1] then
		Seafortress.MemorySwitchesPressed[1] = buttonIndex
		Seafortress.MemorySwitchesPressedObject[1] = button
		Seafortress.MemorySwitchesPressedObject[1].color = colorVector
	else
		Seafortress.MemorySwitchesPressed[2] = buttonIndex
		Seafortress.MemorySwitchesPressedObject[2] = button
		Seafortress.MemorySwitchesPressedObject[2].color = colorVector
		Timers:CreateTimer(0.9, function()
			if Seafortress.MemoryTable[Seafortress.MemorySwitchesPressed[1]] == Seafortress.MemoryTable[Seafortress.MemorySwitchesPressed[2]] then
				Seafortress:smoothColorTransition(Seafortress.MemorySwitchesPressedObject[1], Seafortress.MemorySwitchesPressedObject[1].color, Vector(50,50,50), 30)
				Seafortress:smoothColorTransition(Seafortress.MemorySwitchesPressedObject[2], Seafortress.MemorySwitchesPressedObject[2].color, Vector(50,50,50), 30)
				Seafortress.MemoryActivated[Seafortress.MemorySwitchesPressed[1]] = 1
				Seafortress.MemoryActivated[Seafortress.MemorySwitchesPressed[2]] = 1
				Seafortress.MemorySwitchesPressed[1] = false
				Seafortress.MemorySwitchesPressedObject[1] = nil
				Seafortress.MemorySwitchesPressed[2] = false
				Seafortress.MemorySwitchesPressedObject[2] = nil
				
				local sum = 0
				for k = 1, #Seafortress.MemoryActivated, 1 do
					sum = sum + Seafortress.MemoryActivated[k]
				end
				if sum == 48 then
					print("PUZZLE COMPLETE")
					EmitSoundOnLocationWithCaster(Vector(-460, -1804, 245), "Seafortress.MemoryButton.Complete", Events.GameMaster)
					local wall = Entities:FindByNameNearest("SeaDoor10", Vector(-1280, -2700, -131+Seafortress.ZFLOAT), 900)
					Seafortress:Walls(false, {wall}, true, 4)
					Seafortress:RemoveBlockers(4, "SeaBlocker9", Vector(-1280, -2688, 191), 1400)
					Seafortress.MemoryPuzzleComplete = true
					Seafortress:AfterMemoryPuzzleRoomSpawn()
				else
					EmitSoundOnLocationWithCaster(Vector(-250, -1804), "Seafortress.MemoryButton.Success", Events.GameMaster)
				end
			else
				EmitSoundOnLocationWithCaster(Vector(-250, -1804), "Seafortress.MemoryButton.Fail", Events.GameMaster)
				pushButtonDown(Seafortress.MemorySwitchesPressedObject[1], true)
				Seafortress:smoothColorTransition(Seafortress.MemorySwitchesPressedObject[1], Seafortress.MemorySwitchesPressedObject[1].color, Vector(255,255,255), 30)
				pushButtonDown(Seafortress.MemorySwitchesPressedObject[2], true)
				Seafortress:smoothColorTransition(Seafortress.MemorySwitchesPressedObject[2], Seafortress.MemorySwitchesPressedObject[2].color, Vector(255,255,255), 30)
				Seafortress.MemorySwitchesPressed[1] = false
				Seafortress.MemorySwitchesPressedObject[1] = nil
				Seafortress.MemorySwitchesPressed[2] = false
				Seafortress.MemorySwitchesPressedObject[2] = nil
			end
		end)
	end
	-- Seafortress.MemoryButtonLock = true
	-- Timers:CreateTimer(0.05, function()
	-- 	Seafortress.MemoryButtonLock = false
	-- end)
end

function GetMemoryButtonColorVector(buttonIndex)
	local colorCode = Seafortress.MemoryTable[buttonIndex]
	if colorCode == 1 then
		return Vector(200, 50, 50)
	elseif colorCode == 2 then
		return Vector (50, 200, 50)
	elseif colorCode == 3 then
		return Vector (50, 50, 200)
	elseif colorCode == 4 then
		return Vector (200, 200, 50)
	end
end

function pushButtonDown(switch, bUnpress)
  local movementZ = -0.5
  if bUnpress then
  	movementZ = movementZ*-1
  end
  local walls = {switch}
  if not bUnpress then
	  Timers:CreateTimer(0.1, function()
	    EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Seafortress.MemoryButton.Press", Events.GameMaster)
	  end)
  end
  for i = 1, 30, 1 do
    for j = 1, #walls, 1 do
      Timers:CreateTimer(i*0.03, function()
        walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
      end)
    end
  end
end

function InitMemoryTable()
	Seafortress.MemoryTable = {}
	Seafortress.tempTable = {}
	for i = 1, 48, 1 do
		local j = 1
		if i > 12 and i <= 24 then
			j = 2
		elseif i > 24 and i <= 36 then
			j = 3
		elseif i > 36 and i <= 48 then
			j = 4
		end
		table.insert(Seafortress.tempTable, j)
	end
	for i = 1, 48, 1 do
		local randomRoom = RandomInt(1, #Seafortress.tempTable)
		table.insert(Seafortress.MemoryTable, Seafortress.tempTable[randomRoom])
		table.remove(Seafortress.tempTable, randomRoom)
	end
	Seafortress.MemoryActivated = {}
	for i = 1, 48, 1 do
		table.insert(Seafortress.MemoryActivated, 0)
	end
	Seafortress.MemorySwitchesPressed = {false, false}
	Seafortress.MemorySwitchesPressedObject = {nil, nil}
end

function SeaFortressSwitchTemple3()
	if Seafortress.StormButtonLock then
		return false
	end
	if Seafortress.SeaProphetTable then
		if #Seafortress.SeaProphetTable == 3 then
			if not Seafortress.SeaWaveSwitchPressed then
				Seafortress.SeaWaveSwitchPressed = true
				Seafortress:ActivateSwitchGeneric(Vector(-4187, -4260, 122+Seafortress.ZFLOAT), "CastleSwitch3", true, 0.377)
				Timers:CreateTimer(2, function()
					Seafortress:InitializeTempleStorm()
				end)
			end
		else
			Seafortress.StormButtonLock = true
			Seafortress:ActivateSwitchGeneric(Vector(-4187, -4260, 122+Seafortress.ZFLOAT), "CastleSwitch3", true, 0.377)
			Timers:CreateTimer(1.5, function()
				Seafortress:ActivateSwitchGeneric(Vector(-4187, -4260, 122+Seafortress.ZFLOAT), "CastleSwitch3", false, 0.377)
				Timers:CreateTimer(1, function()
					Seafortress.StormButtonLock = false
				end)
			end)
		end
	else
		Seafortress.StormButtonLock = true
		Seafortress:ActivateSwitchGeneric(Vector(-4187, -4260, 122+Seafortress.ZFLOAT), "CastleSwitch3", true, 0.377)
		Timers:CreateTimer(1.5, function()
			Seafortress:ActivateSwitchGeneric(Vector(-4187, -4260, 122+Seafortress.ZFLOAT), "CastleSwitch3", false, 0.377)
			Timers:CreateTimer(1, function()
				Seafortress.StormButtonLock = false
			end)
		end)
	end
end

function TemplePushOnTouch(trigger)
	local hero = trigger.activator
	FindClearSpaceForUnit(hero, Vector(-10944, 6042), false)
end

function PlatformRoomSwitch(trigger)
	local hero = trigger.activator
	local caller = trigger.caller

	local switchIndex = caller:GetName():gsub('PlatformRoomSwitch', "")
	switchIndex = tonumber(switchIndex)
	if switchIndex == 5 then
	else
		Seafortress:ActivateSwitchGeneric(hero:GetAbsOrigin(), "SeafortSwitch1", true, 0.4)
	end
	local mobTable = {}
	if switchIndex == 1 then
		Seafortress:RemoveBlockers(2.7, "Platform1Blocker", Vector(-9984, 4950, 151+Seafortress.ZFLOAT), 4400)
		local positionTable = {Vector(-10688, 4911), Vector(-10432, 4911), Vector(-10176, 4911), Vector(-9924, 4911)}
		for i = 1, #positionTable, 1 do
			local beast = Seafortress:SpawnKrayBeast(positionTable[i], Vector(-1,0))
			beast:SetAbsOrigin(positionTable[i]-Vector(0,0,740))
			table.insert(mobTable, beast)
			Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, beast, "modifier_seafortress_rooted", {duration = 5.9})
		end
		local assassin = Seafortress:SpawnTempleAssassin(Vector(-10304, 3934), Vector(0,1))
		assassin:SetAbsOrigin(Vector(-10304, 3934)-Vector(0,0,740))
		table.insert(mobTable, assassin)
		Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, assassin, "modifier_seafortress_rooted", {duration = 5.9})

		local assassin = Seafortress:SpawnTempleAssassin(Vector(-9884, 5814), Vector(0,-1))
		assassin:SetAbsOrigin(Vector(-9884, 5814)-Vector(0,0,740))
		table.insert(mobTable, assassin)
		Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, assassin, "modifier_seafortress_rooted", {duration = 5.9})

	elseif switchIndex == 2 then
		Seafortress:RemoveBlockers(2.7, "Platform2Blocker", Vector(-8704, 4032, 151+Seafortress.ZFLOAT), 4400)

		local positionTable = {Vector(-9600, 4736), Vector(-9600, 4416), Vector(-9600, 4096)}
		for i = 1, #positionTable, 1 do
			local beast = Seafortress:SpawnBarnacleBehemoth(positionTable[i], Vector(0,1))
			beast:SetAbsOrigin(positionTable[i]-Vector(0,0,740))
			table.insert(mobTable, beast)
			Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, beast, "modifier_seafortress_rooted", {duration = 5.9})
		end

		local positionTable = {Vector(-9088, 4082), Vector(-8897, 3963), Vector(-8704, 4082), Vector(-8469, 3954), Vector(-8253, 4082)}
		for i = 1, #positionTable, 1 do
			local beast = nil
			local luck = RandomInt(1,3)
			if luck == 1 then
				beast = Seafortress:SpawnFrostMage(positionTable[i], Vector(-1,0))
			elseif luck == 2 then
				beast = Seafortress:SpawnNagaProtector(positionTable[i], Vector(-1,0))
			elseif luck == 3 then
				beast = Seafortress:SpawnNagaSamurai(positionTable[i], Vector(-1,0))
			end
			beast:SetAbsOrigin(positionTable[i]-Vector(0,0,740))
			table.insert(mobTable, beast)
			Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, beast, "modifier_seafortress_rooted", {duration = 5.9})
		end

		local positionTable = {Vector(-8832, 4928), Vector(-8640, 5080)}
		for i = 1, #positionTable, 1 do
			local beast = Seafortress:SpawnSeaQueen(positionTable[i], Vector(-1,-1))
			beast:SetAbsOrigin(positionTable[i]-Vector(0,0,740))
			table.insert(mobTable, beast)
			Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, beast, "modifier_seafortress_rooted", {duration = 5.9})
		end

	elseif switchIndex == 3 then
		Seafortress:RemoveBlockers(2.7, "Platform3Blocker", Vector(-7488, 4096, 151+Seafortress.ZFLOAT), 4400)

		for i = 0, 9, 1 do
			local position = Vector(-7872+RandomInt(0,860), 3776+RandomInt(0,500))
			local beast = Seafortress:SpawnWaterBug(position, Vector(-1,0))
			beast:SetAbsOrigin(position-Vector(0,0,740))
			table.insert(mobTable, beast)
			Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, beast, "modifier_seafortress_rooted", {duration = 5.9})
		end
		local positionTable = {Vector(-7744, 4672), Vector(-7744, 4928), Vector(-7744, 5248)}
		for i = 1, #positionTable, 1 do
			local beast = Seafortress:SpawnBarnacleBehemoth(positionTable[i], Vector(0,1))
			beast:SetAbsOrigin(positionTable[i]-Vector(0,0,740))
			table.insert(mobTable, beast)
			Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, beast, "modifier_seafortress_rooted", {duration = 5.9})
		end
	elseif switchIndex == 4 then
		Seafortress:RemoveBlockers(2.7, "Platform4Blocker", Vector(-7488, 5952, 151+Seafortress.ZFLOAT), 4400)

		for i = 0, 9, 1 do
			local position = Vector(-8256+RandomInt(0,860), 5824+RandomInt(0,500))
			local beast = Seafortress:SpawnWaterBug(position, Vector(0,-1))
			beast:SetAbsOrigin(position-Vector(0,0,740))
			table.insert(mobTable, beast)
			Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, beast, "modifier_seafortress_rooted", {duration = 5.9})
		end
	elseif switchIndex == 5 then
		if Seafortress.CentaurSwitchActive then
			if not Seafortress.CentaurSpawn then
				Seafortress:ActivateSwitchGeneric(hero:GetAbsOrigin(), "SeafortSwitch1", true, 0.4)
				Seafortress.CentaurSpawn = true
				local wall = Entities:FindByNameNearest("PlatformWall", Vector(-5960, 6005, -4+Seafortress.ZFLOAT), 900)
				Seafortress:Walls(false, {wall}, true, 4)
				Seafortress:RemoveBlockers(4, "PlatformDoorBlocker", Vector(-5952, 6016, 101+Seafortress.ZFLOAT), 1400)		
				Seafortress:AfterPlatformRoom()
			end
		else
			EmitSoundOn("Seafortress.NoSwitchTouch", hero)
			local jumpFV = ((Vector(256, -9792)-hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(hero, jumpFV, 90, 110, 200, 1)
			local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/seafortress/boss_dying_effect.vpcf", hero, 4)
			ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin())
		end
	end
	if switchIndex <= 4 then
		for i = 1, 200, 1 do
			Timers:CreateTimer(i*0.03, function()
				Seafortress.PlatformsTable[switchIndex]:SetAbsOrigin(Seafortress.PlatformsTable[switchIndex]:GetAbsOrigin()+Vector(0,0,5))
				if #mobTable > 0 then
					for j = 1, #mobTable, 1 do
						mobTable[j]:SetAbsOrigin(mobTable[j]:GetAbsOrigin()+Vector(0,0,5))
					end
				end
			end)
		end
		Timers:CreateTimer(5.8, function()
			EmitSoundOnLocationWithCaster(Seafortress.PlatformsTable[switchIndex]:GetAbsOrigin(), "Arena.WaterTemple.SwitchEnd", Events.GameMaster)
			-- if #mobTable > 0 then
			-- 	for j = 1, #mobTable, 1 do
			-- 		mobTable[j]:RemoveModifierByName("modifier_seafortress_rooted")
			-- 	end
			-- end
		end)
	end
end

function TempleEnergyButton(trigger)
	local hero = trigger.activator
	local caller = trigger.caller
	local switchIndex = caller:GetName():gsub('TempleEnergyButton', "")
	switchIndex = tonumber(switchIndex)
	local darkBlue = Vector(81, 119, 148)
	local darkSwitch = Vector(67, 131, 101)
	local lightSwitch = Vector(199, 192, 75)
	if not Seafortress.TempleEnergyState then
		Seafortress.TempleEnergyState = 0
	end
	print(Seafortress.TempleEnergyState)
	if Seafortress.TempleEnergyState == 0 then
		if switchIndex == 1 then
			local switch = Entities:FindByNameNearest("BeamButton", Vector(-6242, -256), 800)
			Seafortress:smoothColorTransition(switch, lightSwitch, darkSwitch, 30)
			Seafortress.TempleEnergyState = -1
			local beam = Entities:FindByNameNearest("BeamFloor1", Vector(-6242, 477), 800)
			Seafortress:smoothColorTransition(beam, darkBlue, lightSwitch, 30)
			EmitSoundOnLocationWithCaster(beam:GetAbsOrigin(), "Seafortress.ButtonGlowLite", Events.GameMaster)
			Timers:CreateTimer(0.9, function()
				local switch = Entities:FindByNameNearest("BeamButton", Vector(-6242, 1216), 800)
				Seafortress:smoothColorTransition(switch, darkSwitch, lightSwitch, 30)
				EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Seafortress.ButtonGlow", Seafortress.Master)
				Timers:CreateTimer(0.9, function()
					Seafortress.TempleEnergyState = 1
				end)				
			end)
		end
	elseif Seafortress.TempleEnergyState == 1 then
		if switchIndex == 2 then
			local switch = Entities:FindByNameNearest("BeamButton", Vector(-6242, 1216), 800)
			Seafortress:smoothColorTransition(switch, lightSwitch, darkSwitch, 30)
			Seafortress.TempleEnergyState = -1
			local beam = Entities:FindByNameNearest("BeamFloor2", Vector(-3903, 360), 800)
			Seafortress:smoothColorTransition(beam, darkBlue, lightSwitch, 30)
			EmitSoundOnLocationWithCaster(beam:GetAbsOrigin(), "Seafortress.ButtonGlowLite", Events.GameMaster)
			Timers:CreateTimer(0.9, function()
				local switch = Entities:FindByNameNearest("BeamButton", Vector(-3597, -307), 800)
				Seafortress:smoothColorTransition(switch, darkSwitch, lightSwitch, 30)
				EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Seafortress.ButtonGlow", Seafortress.Master)
				Timers:CreateTimer(0.9, function()
					Seafortress.TempleEnergyState = 2
				end)				
			end)
		end
	elseif Seafortress.TempleEnergyState == 2 then
		if switchIndex == 3 then
			local switch = Entities:FindByNameNearest("BeamButton", Vector(-3597, -307), 800)
			Seafortress:smoothColorTransition(switch, lightSwitch, darkSwitch, 30)

			local switch = Entities:FindByNameNearest("BeamButton", Vector(-6242, 1216), 800)
			Seafortress:smoothColorTransition(switch, darkSwitch, lightSwitch, 30)
			EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Seafortress.ButtonGlow", Seafortress.Master)
			Seafortress.TempleEnergyState = 3
		end
	elseif Seafortress.TempleEnergyState == 3 then
		if switchIndex == 2 then
			local switch = Entities:FindByNameNearest("BeamButton", Vector(-6242, 1216), 800)
			Seafortress:smoothColorTransition(switch, lightSwitch, darkSwitch, 30)
			Seafortress.TempleEnergyState = -1
			local beam = Entities:FindByNameNearest("BeamFloor3", Vector(-3903, 2007), 800)
			Seafortress:smoothColorTransition(beam, darkBlue, lightSwitch, 30)
			EmitSoundOnLocationWithCaster(beam:GetAbsOrigin(), "Seafortress.ButtonGlowLite", Events.GameMaster)
			Timers:CreateTimer(0.9, function()
				local switch = Entities:FindByNameNearest("BeamButton", Vector(-4125, 2618), 800)
				Seafortress:smoothColorTransition(switch, darkSwitch, lightSwitch, 30)
				EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Seafortress.ButtonGlow", Seafortress.Master)
				Timers:CreateTimer(0.9, function()
					Seafortress.TempleEnergyState = 4
				end)				
			end)
		end
	elseif Seafortress.TempleEnergyState == 4 then
		local switch = Entities:FindByNameNearest("BeamButton", Vector(-4125, 2618), 800)
		Seafortress:smoothColorTransition(switch, lightSwitch, darkSwitch, 30)
		Seafortress.TempleEnergyState = -1
		local beam = Entities:FindByNameNearest("BeamFloor4", Vector(-4128, 2068), 800)
		Seafortress:smoothColorTransition(beam, darkBlue, lightSwitch, 30)
		EmitSoundOnLocationWithCaster(beam:GetAbsOrigin(), "Seafortress.ButtonGlowLite", Events.GameMaster)
		Timers:CreateTimer(0.9, function()
			local switch = Entities:FindByNameNearest("mid_dragon", Vector(-3905, 1309), 800)
			Seafortress:smoothColorTransition(switch, Vector(105, 130, 173), Vector(0, 100, 255), 30)
			EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Seafortress.ButtonGlow", Seafortress.Master)
			Timers:CreateTimer(1, function()
				local boss = Seafortress:SpawnSeaDragonWarrior(Vector(-3905, 1309), Vector(0,-1))
				boss.deathCode = 16
			end)			
		end)		
	end
end

function PirateSwitch(trigger)
	local hero = trigger.activator
	local movementZ = 283/60
	Timers:CreateTimer(4, function()
		Seafortress.PirateGravesUp = true
	end)
	Seafortress:ActivateSwitchGeneric(Vector(11809, 9520, 2+Seafortress.ZFLOAT), "SeafortSwitch1", true, 0.43)
	Dungeons:CreateBasicCameraLockForHeroes(Vector(4986, 8448, -176+Seafortress.ZFLOAT), 2.2, {hero})
	
	local walls = Entities:FindAllByNameWithin("PirateGrave", Vector(4986, 8448, -176+Seafortress.ZFLOAT), 1500)

	Timers:CreateTimer(0.1, function()
	    for i = 1, #walls, 1 do
	      EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Seafortress.PirateTombstones.Rise", Events.GameMaster)
	    end
	end)
	for i = 1, 60, 1 do
	  for j = 1, #walls, 1 do
	    Timers:CreateTimer(i*0.03, function()
	      walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
	      if i % 30 == 0 then
		      if j == 1 then
		        ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
		      end
			local pfx2 = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( pfx2, 0, GetGroundPosition(walls[j]:GetAbsOrigin(), Events.GameMaster)+Vector(0,0,60))
			ParticleManager:SetParticleControl( pfx2, 1, Vector(200, 200, 200) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx2, false)
				ParticleManager:ReleaseParticleIndex(pfx2)
			end)
		  end
	    end)
	  end
	end

end

function MinWraithTriggers(trigger)
	local caller = trigger.caller
	local triggerIndex = caller:GetName():gsub('MinWraithTriggers', "")
	triggerIndex = tonumber(triggerIndex)
	local position = Vector(14336, 5184, 100+Seafortress.ZFLOAT)
	local fv = Vector(0,-1)
	if triggerIndex == 2 then
		position = Vector(13440, 5824, 100+Seafortress.ZFLOAT)
		fv = Vector(-1,-1)
	elseif triggerIndex == 3 then
		position = Vector(11064, 6737, 100+Seafortress.ZFLOAT)
		fv = Vector(0.2,1)
	elseif triggerIndex == 4 then
		position = Vector(7129, 6978, 100+Seafortress.ZFLOAT)
		fv = Vector(-1,1)
	end
	for i = 1, 15+RandomInt(1,3), 1 do
		Timers:CreateTimer(0.3*i, function()
			local stone = Seafortress:SpawnDrownedWraith(position, fv, true)
			stone:SetAbsOrigin(position)
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster )
		      ParticleManager:SetParticleControl( particle1, 0, position )
		      WallPhysics:Jump(stone, fv, RandomInt(13,15), RandomInt(22,26), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_SPAWN, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
end

function StalacorrTrigger(trigger)
	Seafortress:SpawnStalacorr(Vector(12432, 9460), Vector(-1,0))
	Seafortress:SpawnStalacorr(Vector(11681, 8894), Vector(0,1))
	Seafortress:SpawnStalacorr(Vector(11465, 9989), Vector(0.5,-1))
end

function StalacorrTrigger0(trigger)
	local luck = RandomInt(1, 3)
	if luck == 1 then
		Seafortress:SpawnStalacorr(Vector(6592, 10432), Vector(1,0))
	elseif luck == 2 then
		Seafortress:SpawnStalacorr(Vector(7326, 10023), Vector(-1,0))
	else
		Seafortress:SpawnStalacorr(Vector(7457, 10914), Vector(0,-1))
	end
end

function MajorTeleport(trigger)
	local hero = trigger.activator
	print("teleport?")
	if not hero:HasModifier("modifier_recently_teleported_portal") then
		if Seafortress.FinalRoomInit then
			local portToVector = Vector(448, -10368)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function BossBeacon(trigger)
	local hero = trigger.activator
	local caller = trigger.caller

	local switchIndex = caller:GetName():gsub('BossBeacon', "")
	switchIndex = tonumber(switchIndex)
	if switchIndex == 1 then
		if Seafortress.ThreeBossTable[switchIndex] == 2 then
			Seafortress.ThreeBossTable[switchIndex] = 3
			local pfx = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_wind.vpcf", PATTACH_CUSTOMORIGIN, Seafortress.Master)
			ParticleManager:SetParticleControl(pfx, 0, Vector(-3427, 8623, 370+Seafortress.ZFLOAT))
			EmitSoundOnLocationWithCaster(Vector(-3427, 8623, 200+Seafortress.ZFLOAT), "Seafortress.BossBeacon.Activate", Seafortress.Master)
			Timers:CreateTimer(2, function()
				local walls = Entities:FindAllByNameWithin("StatueBoss", Vector(-3456, 9344, -418+Seafortress.ZFLOAT), 800)
				for j = 1, #walls, 1 do
					Seafortress:objectShake(walls[j], 90, 10, true, true, false, "Seafortress.Statue.MAGAShake", 15)
				end
				Timers:CreateTimer(2.8, function()
					local position = Vector(-3456, 9344, -418+Seafortress.ZFLOAT)
					for j = 1, #walls, 1 do
						UTIL_Remove(walls[j])
					end
					EmitSoundOnLocationWithCaster(position, "Seafortress.Beast.Shatter", Seafortress.Master)
					local boss = Seafortress:SpawnOceanGiantBoss(position, Vector(0,-1))
					boss.deathCode = 24
					CustomAbilities:QuickAttachParticle( "particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", boss, 6)
		            local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
		            ParticleManager:SetParticleControl(pfx, 0, boss:GetAbsOrigin())
		            ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 0.2))
		            ParticleManager:SetParticleControl(pfx, 2, Vector(0.8,0.8,0.8))
		            Timers:CreateTimer(10, function() 
		              ParticleManager:DestroyParticle( pfx, false )
		              ParticleManager:ReleaseParticleIndex(pfx)
		            end)
		            StartAnimation(boss, {duration=0.9, activity=ACT_DOTA_CAST_REFRACTION, rate=1}) 
	            	Timers:CreateTimer(0.1, function()
	            		EmitSoundOn("Seafortress.OceanGiant.HeavySwing", boss)
	            	end)
		            Timers:CreateTimer(1, function()
		            	Timers:CreateTimer(0.5, function()
		            		StartAnimation(boss, {duration=4.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1}) 
		            	end)
		            	Timers:CreateTimer(0.1, function()
		            		EmitSoundOn("Seafortress.OceanGiant.Intro", boss)
		            	end)
		            	for i = 1, 45, 1 do
		            		Timers:CreateTimer(i*0.1, function()
		            			ScreenShake(boss:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
		            		end)
		            	end
		            	Timers:CreateTimer(5.0, function()
		            		boss:RemoveModifierByName("modifier_disable_player")
		            		boss.lock = true
		            		Timers:CreateTimer(2, function()
		            			boss.lock = false
		            		end)
		            	end)
		            end)
				end)
			end)
		end
	elseif switchIndex == 2 then
		if Seafortress.ThreeBossTable[switchIndex] == 2 then
			Seafortress.ThreeBossTable[switchIndex] = 3
			local pfx = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_wind.vpcf", PATTACH_CUSTOMORIGIN, Seafortress.Master)
			ParticleManager:SetParticleControl(pfx, 0, Vector(-1126, 8623, 370+Seafortress.ZFLOAT))
			EmitSoundOnLocationWithCaster(Vector(-1126, 8623, 200+Seafortress.ZFLOAT), "Seafortress.BossBeacon.Activate", Seafortress.Master)
			Timers:CreateTimer(2, function()
				local walls = Entities:FindAllByNameWithin("StatueBoss", Vector(-1124, 9315, -418+Seafortress.ZFLOAT), 800)
				for j = 1, #walls, 1 do
					Seafortress:objectShake(walls[j], 90, 10, true, true, false, "Seafortress.Statue.MAGAShake", 15)
				end
				Timers:CreateTimer(2.8, function()
					local position = Vector(-1124, 9315, -418+Seafortress.ZFLOAT)
					for j = 1, #walls, 1 do
						UTIL_Remove(walls[j])
					end
					EmitSoundOnLocationWithCaster(position, "Seafortress.Beast.Shatter", Seafortress.Master)
					local boss = Seafortress:SpawnSiltbreakerBoss(position, Vector(0,-1))
					boss.deathCode = 24
					CustomAbilities:QuickAttachParticle( "particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", boss, 6)
		            local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
		            ParticleManager:SetParticleControl(pfx, 0, boss:GetAbsOrigin())
		            ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
		            ParticleManager:SetParticleControl(pfx, 2, Vector(0.7,0.7,0.7))
		            Timers:CreateTimer(10, function() 
		              ParticleManager:DestroyParticle( pfx, false )
		              ParticleManager:ReleaseParticleIndex(pfx)
		            end)
		            StartAnimation(boss, {duration=0.9, activity=ACT_DOTA_CAST_REFRACTION, rate=1}) 
		            Timers:CreateTimer(1, function()
		            	Timers:CreateTimer(0.5, function()
		            		StartAnimation(boss, {duration=4.5, activity=ACT_DOTA_CAST_ABILITY_3, rate=1}) 
		            	end)
		            	Timers:CreateTimer(0.1, function()
		            		EmitSoundOn("Seafortress.Siltbreaker.Aggro", boss)
		            	end)
		            	for i = 1, 49, 1 do
		            		Timers:CreateTimer(i*0.1, function()
		            			ScreenShake(boss:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
		            		end)
		            	end
		            	Timers:CreateTimer(5.0, function()
		            		boss:RemoveModifierByName("modifier_disable_player")
		            	end)
		            end)
				end)
			end)
		end
	elseif switchIndex == 3 then
		if Seafortress.ThreeBossTable[switchIndex] == 2 then
			Seafortress.ThreeBossTable[switchIndex] = 3
			local pfx = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_wind.vpcf", PATTACH_CUSTOMORIGIN, Seafortress.Master)
			ParticleManager:SetParticleControl(pfx, 0, Vector(1178, 8623, 370+Seafortress.ZFLOAT))
			EmitSoundOnLocationWithCaster(Vector(1178, 8623, 370+Seafortress.ZFLOAT), "Seafortress.BossBeacon.Activate", Seafortress.Master)
			Timers:CreateTimer(2, function()
				local walls = Entities:FindAllByNameWithin("StatueBoss", Vector(1181, 9312, -418+Seafortress.ZFLOAT), 800)
				for j = 1, #walls, 1 do
					Seafortress:objectShake(walls[j], 90, 10, true, true, false, "Seafortress.Statue.MAGAShake", 15)
				end
				Timers:CreateTimer(2.8, function()
					local position = Vector(1181, 9312, -418+Seafortress.ZFLOAT)
					for j = 1, #walls, 1 do
						UTIL_Remove(walls[j])
					end
					EmitSoundOnLocationWithCaster(position, "Seafortress.Beast.Shatter", Seafortress.Master)
					local boss = Seafortress:SpawnOracleOfSea(position, Vector(0,-1))
					boss.deathCode = 24
					CustomAbilities:QuickAttachParticle( "particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", boss, 6)
		            local pfx = ParticleManager:CreateParticle( "particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
		            ParticleManager:SetParticleControl(pfx, 0, boss:GetAbsOrigin())
		            ParticleManager:SetParticleControl(pfx, 5, Vector(0.0, 0.7, 0.3))
		            ParticleManager:SetParticleControl(pfx, 2, Vector(0.7,0.7,0.7))
		            Timers:CreateTimer(10, function() 
		              ParticleManager:DestroyParticle( pfx, false )
		              ParticleManager:ReleaseParticleIndex(pfx)
		            end)
		            StartAnimation(boss, {duration=0.9, activity=ACT_DOTA_CAST_TORNADO, rate=1}) 
		            Timers:CreateTimer(1, function()

		            	Timers:CreateTimer(0.5, function()
		            		StartAnimation(boss, {duration=5.5, activity=ACT_DOTA_TELEPORT, rate=1}) 
			            	for i = 1, 3, 1 do
			            		CustomAbilities:QuickAttachParticle( "particles/act_2/siltbreaker_beam_channel.vpcf", boss, 5.5)
			            	end
		            	end)
		            	Timers:CreateTimer(0.1, function()
		            		EmitSoundOn("Seafortress.OceanOracle.Aggro", boss)
		            	end)
		            	for i = 1, 49, 1 do
		            		Timers:CreateTimer(i*0.1, function()
		            			ScreenShake(boss:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
		            		end)
		            	end
		            	Timers:CreateTimer(6.0, function()
		            		boss:RemoveModifierByName("modifier_disable_player")
		            		boss.lock = true
		            		Timers:CreateTimer(1.3, function()
		            			boss.lock = false
		            		end)
		            	end)
		            end)
				end)
			end)
		end
	end
end

function JumperTrigger(trigger)
	local hero = trigger.activator
	print("HELLO?")
	if hero:HasModifier("modifier_sea_fortress_green_beacon") then
		return false
	end
	if Seafortress.MaidenDeadTwo then
		hero:SetAbsOrigin(Seafortress.Jumper2:GetAbsOrigin())
		EmitSoundOn("Seafortress.GreenBeacon.Lift", hero)
		Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, hero, "modifier_sea_fortress_green_beacon", {duration = 3.5})
		StartAnimation(hero, {duration=3.5, activity=ACT_DOTA_FLAIL, rate=0.7})
		for i = 1, 50, 1 do
			Timers:CreateTimer(i*0.03, function()
				hero:SetAbsOrigin(hero:GetAbsOrigin()+Vector(0,0,i*0.3))
			end)
		end 
		Events:LockCameraWithDuration(hero, 4.5)
		Timers:CreateTimer(1.53, function()
			local fv = ((Vector(-11840, 12096) - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			EmitSoundOn("Seafortress.GreenBeacon.Throw", hero)
			hero.jumpEnd = "basic_dust"
			WallPhysics:Jump(hero, fv, 58, 37, 42, 1)
		end)
	end
end
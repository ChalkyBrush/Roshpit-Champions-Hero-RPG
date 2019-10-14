function Tanari:InitializeWindTemple()
	Tanari:WindTempleWalls()
	Tanari.WindTemple = {}
	Tanari.WindTemple.finalEncounter = {}
	Dungeons.respawnPoint = Vector(7490, 7972)
	Timers:CreateTimer(2, function()
		Tanari:MoveAngel()
	end)
	Timers:CreateTimer(7, function()
		EmitGlobalSound("Tanari.TempleStart")
	end)
	Timers:CreateTimer(12, function()
		if not Tanari.WindTemple.BossBattleBegun then
			local music = "Tanari.Music.WindTemple"
			EmitSoundOnLocationWithCaster(Vector(7808, 9088, 700), music, Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(7744, 12160, 500), music, Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(7872, 15244, 1000), music, Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(7872, 7040, 1000), music, Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(13312, 13312, 1000), music, Events.GameMaster)
			if not Tanari.WindTemple.BossBattleBegun then
				return 128
			end
		end
	end)
	Timers:CreateTimer(5, function()
		EmitSoundOnLocationWithCaster(Vector(7744, 12096, 400), "Ambient.Tanari.Windy", Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(7872, 15244, 700), "Ambient.Tanari.Windy", Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(7872, 7040, 1000), "Ambient.Tanari.Windy", Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(13312, 13312, 1000), "Ambient.Tanari.Windy", Events.GameMaster)
		return 10
	end)
	Timers:CreateTimer(3, function()
		Tanari:SpawnWindMage(Vector(9597, 11392), Vector(-1, -1))
		Timers:CreateTimer(0.4, function()
			Tanari:SpawnWindMage(Vector(9472, 11264), Vector(-1, 0))
		end)
		Timers:CreateTimer(0.8, function()
			Tanari:SpawnWindMage(Vector(9664, 11233), Vector(-1, -1))
		end)
		Timers:CreateTimer(1.2, function()
			Tanari:SpawnWindMage(Vector(9633, 11008), Vector(-1, 0))
		end)
		Timers:CreateTimer(1.6, function()
			Tanari:SpawnWindMage(Vector(9472, 10944), Vector(-1, 1))
		end)
		if Tanari.WindProphet then
			Tanari:SpawnWindProphet(Vector(7680, 12160), Vector(-1, 0))
		end
	end)
	Timers:CreateTimer(7, function()
		Tanari:SpawnWindDrake(Vector(9833, 9458), Vector(-0.2, 1))
	end)
	Timers:CreateTimer(3, function()
		local chest = CreateUnitByName("chest", Vector(9280, 7168), true, nil, nil, DOTA_TEAM_GOODGUYS)
		chest:SetForwardVector(Vector(0, 1))
		chest:FindAbilityByName("town_unit"):SetLevel(1)
		Tanari.WindTemple.TempleChest1 = chest
	end)
	Tanari.WindTemple.SpiritBridge = Entities:FindByNameNearest("WindSpiritBridge", Vector(10533, 14272, 83 + Tanari.ZFLOAT), 1000)
	Tanari.WindTemple.SpiritBridge:SetAbsOrigin(Tanari.WindTemple.SpiritBridge:GetAbsOrigin() - Vector(0, 0, 1000))
end

function Tanari:SpawnWindTemplePart2()
	if not Tanari.WindTemple then
		Tanari.WindTemple = {}
	end
	Tanari:SpawnEmeraldSpider(Vector(6464, 10624), Vector(1, -1))
	Tanari:SpawnEmeraldSpider(Vector(6608, 10624), Vector(-1, -1))
	Tanari:SpawnEmeraldSpider(Vector(6588, 11200), Vector(0, -1))
	Timers:CreateTimer(5, function()
		Tanari:InitWindStaffs()
	end)
	Timers:CreateTimer(7, function()
		Tanari:SpawnWindTempleGardener(Vector(5632, 14144), Vector(0, -1))
		Tanari:SpawnWindTempleGardener(Vector(6144, 14080), Vector(-1, -1))
		Tanari:SpawnWindTempleGardener(Vector(5632, 14527), Vector(1, 0))
		Tanari:SpawnWindTempleGardener(Vector(5952, 14848), Vector(-1, -1))
	end)
	Timers:CreateTimer(10, function()
		Tanari:SpawnWindMaiden(Vector(6144, 15488), Vector(-1, -1))
		Tanari:SpawnWindMaiden(Vector(6183, 15616), Vector(0, -1))
		Tanari:SpawnWindMaiden(Vector(6154, 15872), Vector(0, -1))
		Tanari:SpawnWindMaiden(Vector(6384, 15936), Vector(-1, -1))
		Tanari:SpawnWindMaiden(Vector(6543, 15787), Vector(-1, -0.5))
		Tanari:SpawnWindMaiden(Vector(6592, 15629), Vector(1, 0))
		Tanari:SpawnWindMaiden(Vector(6464, 15513), Vector(-1, -0.2))
		Tanari:SpawnWindMaiden(Vector(6464, 15358), Vector(-1, -0.7))
		Tanari:SpawnWindMage(Vector(6720, 15936), Vector(-1, 0))
		Tanari:SpawnWindMage(Vector(6848, 15680), Vector(-1, -1))
	end)
	Timers:CreateTimer(12, function()
		Tanari:SpawnDescendantOfZeus(Vector(7626, 15712), Vector(1, -1))
		Tanari:SpawnDescendantOfZeus(Vector(8134, 15712), Vector(-1, -1))
	end)
	if Tanari.RareFalconWarder then
		Timers:CreateTimer(24, function()
			Tanari:SpawnRareFalconWarden(Vector(9638, 15744), Vector(-1, 0))
		end)
	end
end

function Tanari:Walls(bRaise, walls, bSound, movementZ)
	if not bRaise then
		movementZ = movementZ *- 1
	end
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			if bSound then
				for i = 1, #walls, 1 do
					EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
				end
			end
		end)
		for i = 1, 180, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i * 0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, movementZ))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end
end

function Tanari:CreateDynamicWindTempleWall()
	Tanari.windTempleBlocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(7104, 8310, 273), name = "wallObstruction"})
	Tanari.windTempleBlocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(7232, 8310, 273), name = "wallObstruction"})
	Tanari.windTempleBlocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(7360, 8310, 273), name = "wallObstruction"})
	Tanari.windTempleBlocker4 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(7488, 8310, 273), name = "wallObstruction"})
	Tanari.windTempleBlocker5 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(7616, 8310, 273), name = "wallObstruction"})
	Tanari.windTempleBlocker6 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(7744, 8310, 273), name = "wallObstruction"})
	Tanari.windTempleBlocker7 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(7872, 8310, 273), name = "wallObstruction"})
end

function Tanari:WindTempleWalls()
	local movementZ = -3.75

	Timers:CreateTimer(5, function()
		local walls = Entities:FindAllByNameWithin("WindTempleWall", Vector(7499, 8342, 646), 900)
		Timers:CreateTimer(0.1, function()
			EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
		end)
		for i = 1, 90, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i * 0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, movementZ))
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, movementZ))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end)
	Timers:CreateTimer(8, function()
		UTIL_Remove(Tanari.windTempleBlocker1)
		UTIL_Remove(Tanari.windTempleBlocker2)
		UTIL_Remove(Tanari.windTempleBlocker3)
		UTIL_Remove(Tanari.windTempleBlocker4)
		UTIL_Remove(Tanari.windTempleBlocker5)
		UTIL_Remove(Tanari.windTempleBlocker6)
		UTIL_Remove(Tanari.windTempleBlocker7)
	end)
end

function Tanari:MoveAngel()
	local angels = Entities:FindAllByNameWithin("WindTempleAngel", Vector(7456, 7095, 200), 900)
	for j = 1, #angels, 1 do
		for i = 1, 64, 1 do
			Timers:CreateTimer(i * 0.03, function()
				angels[j]:SetAbsOrigin(angels[j]:GetAbsOrigin() + Vector(0, 2, 0))
			end)
		end
	end
	Tanari.angelPhase = 0
	Tanari.angels = angels
	Timers:CreateTimer(2, function()
		local heightChange = math.sin(Tanari.angelPhase) * 14
		for i = 1, #Tanari.angels, 1 do
			Tanari.angels[i]:SetAbsOrigin(Tanari.angels[i]:GetAbsOrigin() + Vector(0, 0, heightChange))
		end
		Tanari.angelPhase = Tanari.angelPhase + 0.1
		if Tanari.angelPhase >= 50 then
			Tanari.angelPhase = 0
		end
		return 0.05
	end)
end

function Tanari:SpawnWindGuardian(position, fv)
	local hunter = Tanari:SpawnDungeonUnit("wind_temple_avian_warder", position, 0, 1, nil, fv, true)
	hunter.itemLevel = 32
	hunter:SetAbsOrigin(hunter:GetAbsOrigin() - Vector(0, 0, 500))
	hunterAbility = hunter:FindAbilityByName("wind_temple_wind_guardian_ai")
	hunterAbility:ApplyDataDrivenModifier(hunter, hunter, "modifier_wind_guardian_entrance", {duration = 2.7})
	hunter.dominion = true
	for i = 1, 90, 1 do
		Timers:CreateTimer(0.03 * i, function()
			hunter:SetAbsOrigin(hunter:GetAbsOrigin() + Vector(0, 0, math.abs(math.sin(i) * 10)))
		end)
	end
	return hunter
end

function Tanari:SpawnWindMage(position, fv)
	local mage = Tanari:SpawnDungeonUnit("wind_temple_wind_mage", position, 3, 4, "Tanari.WindMage.Aggro", fv, false)
	mage.itemLevel = 38
	mage.dominion = true
	return mage
end

function Tanari:SpawnWindDrake(position, fv)
	local dragon = Tanari:SpawnDungeonUnit("wind_temple_wind_drake", position, 3, 4, "Tanari.WindDrake.Aggro", fv, false)
	Events:AdjustBossPower(dragon, 2, 3, false)
	dragon.itemLevel = 52
end

function Tanari:SpawnEmeraldSpider(position, fv)
	local spider = Tanari:SpawnDungeonUnit("wind_temple_emerald_spider", position, 0, 2, "Tanari.EmeraldSpider.Aggro", fv, false)
	spider.itemLevel = 37
	spider:SetRenderColor(140, 255, 170)
	spider.dominion = true
	return spider
end

function Tanari:SpawnWindTempleSpider(position, fv)
	local spider = Tanari:SpawnDungeonUnit("wind_temple_venom_spider", position, 0, 1, "Tanari.EmeraldSpider.Aggro", fv, false)
	spider.itemLevel = 37
	spider:SetRenderColor(140, 255, 170)
	spider.dominion = true
	return spider
end

function Tanari:SpawnWindTempleGardener(position, fv)
	local gardiner = Tanari:SpawnDungeonUnit("wind_temple_gardener", position, 1, 4, "Tanari.WindTemple.GardinerAggro", fv, false)
	gardiner.itemLevel = 42
	gardiner:SetRenderColor(180, 255, 180)
	Events:AdjustBossPower(gardiner, 1, 1, false)
	gardiner.dominion = true
	return gardiner
end

function Tanari:SpawnWindMaiden(position, fv)
	local maiden = Tanari:SpawnDungeonUnit("wind_temple_wind_maiden", position, 1, 4, "Tanari.WindTemple.WindMaidenAggro", fv, false)
	maiden.itemLevel = 42
	maiden:SetRenderColor(180, 255, 180)
	Events:AdjustBossPower(maiden, 1, 1, false)
	maiden.dominion = true
	return maiden
end

function Tanari:SpawnDescendantOfZeus(position, fv)
	local maiden = Tanari:SpawnDungeonUnit("wind_temple_descendant_of_zeus", position, 3, 4, "Tanari.WindTemple.WindDescendantAggro", fv, false)
	maiden.itemLevel = 50
	Events:AdjustBossPower(maiden, 3, 3, false)
	maiden.dominion = true
	return maiden
end

function Tanari:SpawnWindHighPriest(position, fv)
	local maiden = Tanari:SpawnDungeonUnit("wind_temple_wind_high_priest", position, 2, 4, nil, fv, false)
	maiden.itemLevel = 46
	Events:AdjustBossPower(maiden, 1, 1, false)
	return maiden
end

function Tanari:InitWindStaffs()
	Tanari:SpawnWindTempleStaff(Vector(6361, 15741), "red", 1)
	Tanari:SpawnWindTempleStaff(Vector(7905, 15379), "green", 2)
	Tanari:SpawnWindTempleStaff(Vector(9373, 15741), "blue", 3)
end

function Tanari:SpawnWindTempleStaff(position, base, staffID)
	local staff = CreateUnitByName("wind_temple_staff", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	staff.dummy = true
	staff.jumpLock = true
	local staffAbility = staff:FindAbilityByName("wind_temple_staff_dummy")
	staffAbility:SetLevel(1)
	Tanari:StaffChangeColor(staff, base)
	if staffID == 1 then
		Tanari.WindTemple.staff1 = staff
	elseif staffID == 2 then
		Tanari.WindTemple.staff2 = staff
	elseif staffID == 3 then
		Tanari.WindTemple.staff3 = staff
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, staff:GetAbsOrigin() + Vector(0, 0, 200), 600, 2400, false)
end

function Tanari:StaffChangeColor(staff, newColor)
	if newColor == "red" then
		staff:SetRenderColor(255, 0, 0)
	elseif newColor == "green" then
		staff:SetRenderColor(0, 255, 0)
	elseif newColor == "blue" then
		staff:SetRenderColor(0, 0, 255)
	end
	staff:RemoveModifierByName("modifier_wind_temple_staff_red")
	staff:RemoveModifierByName("modifier_wind_temple_staff_green")
	staff:RemoveModifierByName("modifier_wind_temple_staff_blue")
	staff.color = newColor
	local staffAbility = staff:FindAbilityByName("wind_temple_staff_dummy")
	staffAbility:ApplyDataDrivenModifier(staff, staff, "modifier_wind_temple_staff_"..newColor, {})
	Tanari:StaffCheckBossBuffs(staff)
end

function Tanari:StaffCheckBossBuffs(staff)
	if staff.pfx2 then
		ParticleManager:DestroyParticle(staff.pfx2, false)
		staff.pfx2 = false
	end
	local staffAbility = staff:FindAbilityByName("wind_temple_staff_dummy")
	if Tanari.WindTemple.staffGuardianRed then
		if staff.color == "red" then
			staffAbility:ApplyDataDrivenModifier(staff, Tanari.WindTemple.staffGuardianRed, "wind_temple_staff_dummy_buff", {})
			Tanari:AttachParticleToBoss(staff.color, staff, Tanari.WindTemple.staffGuardianRed)
		else
			Tanari.WindTemple.staffGuardianRed:RemoveModifierByNameAndCaster("wind_temple_staff_dummy_buff", staff)
		end
	end
	if Tanari.WindTemple.staffGuardianBlue then
		if staff.color == "blue" then
			staffAbility:ApplyDataDrivenModifier(staff, Tanari.WindTemple.staffGuardianBlue, "wind_temple_staff_dummy_buff", {})
			Tanari:AttachParticleToBoss(staff.color, staff, Tanari.WindTemple.staffGuardianBlue)
		else
			Tanari.WindTemple.staffGuardianBlue:RemoveModifierByNameAndCaster("wind_temple_staff_dummy_buff", staff)
		end
	end
	if Tanari.WindTemple.staffGuardianGreen then
		if staff.color == "green" then
			staffAbility:ApplyDataDrivenModifier(staff, Tanari.WindTemple.staffGuardianGreen, "wind_temple_staff_dummy_buff", {})
			Tanari:AttachParticleToBoss(staff.color, staff, Tanari.WindTemple.staffGuardianGreen)
		else
			Tanari.WindTemple.staffGuardianGreen:RemoveModifierByNameAndCaster("wind_temple_staff_dummy_buff", staff)
		end
	end
end

function Tanari:AttachParticleToBoss(color, staff, boss)
	local blueParticle = "particles/units/heroes/hero_wisp/wisp_tether.vpcf"
	local redParticle = "particles/units/heroes/hero_wisp/epoch_rune_b_a.vpcf"
	local greenParticle = "particles/units/heroes/hero_wisp/tether_green.vpcf"
	local particleName = ""
	if color == "red" then
		particleName = redParticle
	elseif color == "green" then
		particleName = greenParticle
	elseif color == "blue" then
		particleName = blueParticle
	end
	--print(particleName)
	local eonPfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, staff)
	ParticleManager:SetParticleControl(eonPfx, 0, staff:GetAbsOrigin() + Vector(0, 0, 300))
	ParticleManager:SetParticleControlEnt(eonPfx, 1, boss, PATTACH_POINT_FOLLOW, "attach_hitloc", boss:GetAbsOrigin() + Vector(0, 0, 140), true)
	-- ParticleManager:SetParticleControlEnt(eonPfx, 0, staff1, PATTACH_WORLDORIGIN, "start_at_customorigin", staff1:GetAbsOrigin()+Vector(0,0,500), true)
	-- ParticleManager:SetParticleControlEnt(eonPfx, 1, staff2, PATTACH_WORLDORIGIN, "start_at_customorigin", staff2:GetAbsOrigin()+Vector(0,0,500), true)
	staff.pfx2 = eonPfx
end

function Tanari:CheckStaffCondition()
	if Tanari.WindTemple.staff1.color == Tanari.WindTemple.staff2.color and Tanari.WindTemple.staff2.color == Tanari.WindTemple.staff3.color then
		Timers:CreateTimer(2, function()
			if Tanari.WindTemple.staff1.color == Tanari.WindTemple.staff2.color and Tanari.WindTemple.staff2.color == Tanari.WindTemple.staff3.color then
				local color = Tanari.WindTemple.staff1.color
				if not Tanari.WindTemple.redStaffBoss and color == "red" then
					Tanari.WindTemple.redStaffBoss = true
					Tanari:SpawnStaffGuardian("red")
				end
				if not Tanari.WindTemple.greenStaffBoss and color == "green" then
					Tanari.WindTemple.greenStaffBoss = true
					Tanari:SpawnStaffGuardian("green")
				end
				if not Tanari.WindTemple.blueStaffBoss and color == "blue" then
					Tanari.WindTemple.blueStaffBoss = true
					Tanari:SpawnStaffGuardian("blue")
				end
			end
		end)
	end
end

function Tanari:SpawnStaffGuardian(color)
	local vectorTable = {Vector(6400, 15680), Vector(7931, 15680), Vector(9407, 15680)}
	local position = vectorTable[RandomInt(1, #vectorTable)]
	ScreenShake(position, 500, 1, 1, 9000, 0, true)
	local gardiner = Tanari:SpawnDungeonUnit("wind_temple_keeper_of_"..color.."_wind", position, 2, 5, nil, Vector(0, -1), true)
	gardiner.itemLevel = 50
	if color == "red" then
		gardiner:SetRenderColor(255, 0, 0)
		Tanari.WindTemple.staffGuardianRed = gardiner
	elseif color == "green" then
		gardiner:SetRenderColor(0, 255, 0)
		Tanari.WindTemple.staffGuardianGreen = gardiner
	elseif color == "blue" then
		gardiner:SetRenderColor(0, 0, 255)
		Tanari.WindTemple.staffGuardianBlue = gardiner
	end
	Timers:CreateTimer(2, function()
		Tanari:StaffCheckBossBuffs(Tanari.WindTemple.staff1)
		Tanari:StaffCheckBossBuffs(Tanari.WindTemple.staff2)
		Tanari:StaffCheckBossBuffs(Tanari.WindTemple.staff3)
	end)
	Events:AdjustBossPower(gardiner, 3, 3, false)
	gardiner:SetAbsOrigin(gardiner:GetAbsOrigin() + Vector(0, 0, 1000))
	WallPhysics:Jump(gardiner, Vector(0, 1), 0, 0, 10, 1.2)
	gardiner.jumpEnd = "cloudburst"
	gardiner.color = color
end

function Tanari:SpawnMasterOfStorms()
	local centerPoint = Vector(4160, 15871)
	-- local radius = 650
	local hunter = Tanari:SpawnDungeonUnit("wind_temple_master_of_storms", Vector(3285, 16070), 5, 7, nil, Vector(1, 0), true)
	hunter.centerPoint = centerPoint
	hunter.fv = Vector(1, 0)
	hunter.phase = 0
	hunter.itemLevel = 37
	hunter:SetAbsOrigin(hunter:GetAbsOrigin() - Vector(0, 0, 800))
	hunterAbility = hunter:FindAbilityByName("wind_temple_master_of_storms_ai")
	hunterAbility:ApplyDataDrivenModifier(hunter, hunter, "modifier_wind_guardian_entrance", {duration = 3})
	for i = 1, 90, 1 do
		Timers:CreateTimer(0.03 * i, function()
			hunter:SetAbsOrigin(hunter:GetAbsOrigin() + Vector(0, 0, math.abs(math.sin(i) * 20)))
		end)
	end
	Timers:CreateTimer(3, function()
		hunterAbility:ApplyDataDrivenModifier(hunter, hunter, "modifier_master_of_storms_ai", {})
		EmitGlobalSound("Tanari.WindTemple.MasterOfStormsAggro")
	end)

end

function Tanari:BeginBattleTacticsRoom()
	Tanari.WindTemple.finalEncounter = {}
	local unit = true

	unit = Tanari:SpawnDescendantOfZeus(Vector(8320, 14272), Vector(-1, 0))
	table.insert(Tanari.WindTemple.finalEncounter, unit)
	unit = Tanari:SpawnWindMaiden(Vector(8467, 14400), Vector(-1, 0))
	table.insert(Tanari.WindTemple.finalEncounter, unit)
	unit = Tanari:SpawnWindMaiden(Vector(8467, 14272), Vector(-1, 0))
	table.insert(Tanari.WindTemple.finalEncounter, unit)
	unit = Tanari:SpawnWindMaiden(Vector(8467, 14144), Vector(-1, 0))
	table.insert(Tanari.WindTemple.finalEncounter, unit)
	unit = Tanari:SpawnWindMage(Vector(8640, 14400), Vector(-1, 0))
	table.insert(Tanari.WindTemple.finalEncounter, unit)
	unit = Tanari:SpawnWindMage(Vector(8640, 14208), Vector(-1, 0))
	table.insert(Tanari.WindTemple.finalEncounter, unit)

	unit = Tanari:SpawnWindHighPriest(Vector(8832, 14464), Vector(-1, 0))
	table.insert(Tanari.WindTemple.finalEncounter, unit)

	Timers:CreateTimer(0.75, function()
		unit = Tanari:SpawnWindHighPriest(Vector(8832, 14272), Vector(-1, 0))
		table.insert(Tanari.WindTemple.finalEncounter, unit)
	end)
	Timers:CreateTimer(1.5, function()
		unit = Tanari:SpawnWindHighPriest(Vector(8832, 14080), Vector(-1, 0))
		table.insert(Tanari.WindTemple.finalEncounter, unit)
	end)

	Tanari.WindTemple.parallelTable = {"wind_temple_descendant_of_zeus", "wind_temple_wind_maiden", "wind_temple_wind_maiden", "wind_temple_wind_maiden", "wind_temple_wind_mage", "wind_temple_wind_mage", "wind_temple_wind_high_priest", "wind_temple_wind_high_priest", "wind_temple_wind_high_priest"}
	if Events.SpiritRealm then
		Tanari:SpawnWindSpirit(Vector(9727, 14272), Vector(-1, 0))
	end
end

function Tanari:SpawnWindBossStaff()
	if not Tanari.WindTemple then
		Tanari.WindTemple = {}
	end
	local bossStaff = CreateUnitByName("wind_temple_boss_staff", Vector(9506.3, 13123.6), false, nil, nil, DOTA_TEAM_NEUTRALS)
	bossStaff:SetRenderColor(50, 50, 50)
	local staffAbility = bossStaff:FindAbilityByName("wind_temple_boss_staff_ability")
	bossStaff:SetAbsOrigin(bossStaff:GetAbsOrigin() + Vector(0, 0, 320))
	bossStaff.zDelta = 320
	Timers:CreateTimer(0.5, function()
		bossStaff:SetHealth(500000)
		bossStaff:Heal(500000, bossStaff)
	end)
	Events:AdjustDeathXP(bossStaff)
	staffAbility:ApplyDataDrivenModifier(bossStaff, bossStaff, "modifier_wind_temple_boss_staff_starting", {})
	Tanari.WindTemple.dragon1 = Tanari:SpawnStaffDragon(Vector(1, 0))
	Tanari.WindTemple.dragon2 = Tanari:SpawnStaffDragon(Vector(0, 1))
	Tanari.WindTemple.dragon3 = Tanari:SpawnStaffDragon(Vector(-1, 0))
	Tanari.WindTemple.dragon4 = Tanari:SpawnStaffDragon(Vector(0, -1))

	Tanari.WindTemple.windBossStaff = bossStaff
end

function Tanari:SpawnStaffDragon(displacement)
	local centerPoint = Vector(9492, 13120, 560)
	local radius = 690
	local dragon = CreateUnitByName("npc_flying_dummy_vision", centerPoint + displacement * radius, false, nil, nil, DOTA_TEAM_NEUTRALS)
	dragon.displacement = displacement
	dragon:SetOriginalModel("models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl")
	dragon:SetModel("models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl")

	dragon:RemoveAbility("dummy_unit")
	dragon:RemoveModifierByName("dummy_unit")
	local ability = dragon:AddAbility("wind_temple_dragon_dummy")
	ability:SetLevel(1)
	ability:ApplyDataDrivenModifier(dragon, dragon, "modifier_wind_temple_dragon_idle", {})
	dragon:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
	dragon:SetRenderColor(50, 50, 50)
	dragon:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	dragon:SetModelScale(2.2)
	return dragon
end

function Tanari:WindTempleBossMusic()
	Timers:CreateTimer(9.4, function()
		if Tanari.WindTemple.BossBattleBegun and not Tanari.WindTemple.BossBattleEnd then
			local music = "Tanari.WindTemple.BossMusic"
			EmitSoundOnLocationWithCaster(Vector(7808, 9088, 700), music, Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(7744, 12160, 500), music, Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(7872, 15244, 1000), music, Events.GameMaster)
			if Tanari.WindTemple.BossBattleBegun and not Tanari.WindTemple.BossBattleEnd then
				return 52
			end
		end
	end)
	-- Timers:CreateTimer(52, function()
	-- local music = "Music.PhoenixBoss"
	-- EmitSoundOnLocationWithCaster(Vector(7808, 9088, 700), music, Events.GameMaster)
	-- EmitSoundOnLocationWithCaster(Vector(7744, 12160, 500), music, Events.GameMaster)
	-- EmitSoundOnLocationWithCaster(Vector(7872, 15244, 1000), music, Events.GameMaster)
	-- if Tanari.WindTemple.BossBattleBegun then
	-- return 191
	-- end
	-- end)
end

function Tanari:SpawnWindTempleBoss(position)
	--print("SPAWN BOSS!!")
	local boss = Events:SpawnBoss("wind_temple_boss", position)
	boss.jumpLock = true
	boss.pushLock = true
	Events:AdjustBossPower(boss, 4, 4, true)
	boss.type = ENEMY_TYPE_BOSS
	local bossAbility = boss:FindAbilityByName("wind_temple_boss_ai")
	bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_wind_temple_boss_intro", {duration = 5.1})
	boss:SetAbsOrigin(Vector(position.x, position.y, boss:GetAbsOrigin().z) + Vector(0, 0, -2800))
	for i = 1, #MAIN_HERO_TABLE, 1 do
		bossAbility:ApplyDataDrivenModifier(boss, MAIN_HERO_TABLE[i], "modifier_wind_temple_boss_wind_blessing", {})
	end
	Timers:CreateTimer(2, function()
		StartAnimation(boss, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.8})
	end)
	Timers:CreateTimer(5, function()
		EmitGlobalSound("Tanari.WindTemple.BossAggro")

	end)
	for i = 1, 130, 1 do
		Timers:CreateTimer(i * 0.03, function()
			local axisShake = Vector(-15, -15, 0)
			if i % 2 == 0 then
				axisShake = Vector(15, 15, 0)
			end
			boss:SetAbsOrigin(boss:GetAbsOrigin() + Vector(0, 0, 16) + axisShake)
			ScreenShake(boss:GetAbsOrigin(), 500, 0.1, 0.1, 9000, 0, true)
		end)
	end
	Tanari.WindTemple.bossEntity = boss
end

function Tanari:WindTempleLast2Tornados()
	particleName = "particles/econ/items/windrunner/windrunner_cape_sparrowhawk/windrunner_windrun_sparrowhawk.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, Vector(9087, 12931, 900))
	local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, Vector(9449, 12686, 900))
end

function Tanari:SpawnWindProphet(position, fv)
	local mage = Tanari:SpawnDungeonUnit("wind_temple_rare_wind_prophet", position, 3, 4, "Tanari.WindProphet.Aggro", fv, false)
	mage.itemLevel = 46
	Events:AdjustBossPower(mage, 3, 3, false)
	return mage
end

function Tanari:SpawnRareFalconWarden(position, fv)
	local mage = Tanari:SpawnDungeonUnit("wind_temple_rare_falcon_warden", position, 3, 6, "Tanari.RareWarden.Aggro", fv, false)
	mage.itemLevel = 74
	Events:AdjustBossPower(mage, 7, 7, false)
	return mage
end

function Tanari:SpawnWindSpirit(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_ancient_wind_spirit", position, 2, 4, "Tanari.WindSpiritAggro", fv, false)
	mage.itemLevel = 70
	Events:AdjustBossPower(mage, 6, 6, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnAvianWarderElite(position, fv)
	local hunter = Tanari:SpawnDungeonUnit("wind_temple_avian_warder_elite", position, 0, 1, nil, fv, true)
	hunter.itemLevel = 65
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, hunter, "tanari_mountain_specter_ai", {})
	hunter:SetAbsOrigin(hunter:GetAbsOrigin() - Vector(0, 0, 500))
	hunterAbility = hunter:FindAbilityByName("wind_temple_wind_guardian_ai")
	hunterAbility:ApplyDataDrivenModifier(hunter, hunter, "modifier_wind_guardian_entrance", {duration = 2.7})
	hunter.dominion = true

	for i = 1, 90, 1 do
		Timers:CreateTimer(0.03 * i, function()
			hunter:SetAbsOrigin(hunter:GetAbsOrigin() + Vector(0, 0, math.abs(math.sin(i) * 10)))
		end)
	end
	return hunter
end

function Tanari:SpiritWindTempleStart()
	Tanari:SpawnWindBear(Vector(11520, 14912), Vector(1, 0))

	Tanari:SpawnWindBear(Vector(12139, 15273), Vector(-1, 0))
	Tanari:SpawnWindBear(Vector(11776, 15744), Vector(0, -1))
	Tanari:SpawnWindBear(Vector(11584, 15552), Vector(1, -1))

	Tanari:GenerateWindJumperParticle(Vector(12556, 15718, 135 + 400))
	Tanari:GenerateWindJumperParticle(Vector(13864, 15643, 135 + 400))

	Timers:CreateTimer(4, function()
		local positionTable = {Vector(14656, 15040), Vector(14940, 15488), Vector(15438, 14818)}
		if GameState:GetDifficultyFactor() >= 2 then
			table.insert(positionTable, Vector(14976, 14738))
		end
		if GameState:GetDifficultyFactor() >= 3 then
			table.insert(positionTable, Vector(15488, 15416))
		end
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local elemental = Tanari:SpawnJadeElemental(positionTable[i], RandomVector(1), false)
			Tanari:AddPatrolArguments(elemental, 70, 4, 30, patrolPositionTable)
		end
	end)
	Tanari.WindTemple.SpiritBridge2 = Entities:FindByNameNearest("WindSpiritBridge", Vector(14976, 13056, 96 + Tanari.ZFLOAT), 1200)
	Tanari.WindTemple.SpiritBridge2:SetAbsOrigin(Tanari.WindTemple.SpiritBridge2:GetAbsOrigin() - Vector(0, 0, 1000))
end

function Tanari:SpawnWindBear(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_wind_bear", position, 1, 3, "Tanari.WindBear.Aggro", fv, false)
	mage.itemLevel = 70
	mage.dominion = true
	Events:AdjustBossPower(mage, 6, 6, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:GenerateWindJumperParticle(position)
	particleName = "particles/econ/items/windrunner/windrunner_cape_sparrowhawk/windrunner_windrun_sparrowhawk.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(particle1, 0, position)
end

function Tanari:SpawnJadeElemental(position, fv, bAggro)
	local mage = Tanari:SpawnDungeonUnit("tanari_jade_water_elemental", position, 1, 3, "Tanari.JadeElemental.Aggro", fv, false)
	mage.itemLevel = 70
	mage:SetRenderColor(200, 255, 210)
	Events:AdjustBossPower(mage, 6, 6, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	mage.targetRadius = 600
	mage.minRadius = 0
	mage.targetAbilityCD = 1.5
	mage.targetFindOrder = FIND_FARTHEST
	if bAggro then
		mage:SetDeathXP(1)
	end
	return mage
end

function Tanari:TreeComplete()
	Tanari.WindTemple.SpiritWaveUnitsSlain = 0
	Tanari.windSpawnPortalTable = {}
	local spawnPositionTable = {Vector(15035, 15844), Vector(15707, 14865), Vector(14578, 14374), Vector(14297, 15239)}
	Timers:CreateTimer(2, function()
		for i = 1, #spawnPositionTable, 1 do
			local pfx = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_cascade.vpcf", PATTACH_WORLDORIGIN, Tanari.TanariMaster)
			ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i] + Vector(0, 0, 460 + Tanari.ZFLOAT))
			table.insert(Tanari.windSpawnPortalTable, pfx)
			EmitSoundOnLocationWithCaster(spawnPositionTable[i], "Tanari.WindPortalSpawn", Tanari.TanariMaster)
		end
	end)
	Timers:CreateTimer(7, function()
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			Tanari:SpawnSpiritWindWaveUnit("wind_temple_wind_mage", spawnPositionTable[i], 10, 33, delay, true)
		end
	end)
end

function Tanari:SpawnSpiritWindWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Tanari.WindPortal.UnitSpawn", Tanari.TanariMaster)
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

			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				unit.itemLevel = itemLevel
				unit.dominion = true
				Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "tanari_wind_temple_modifier", {})
				Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "tanari_mountain_specter_ai", {})
				unit.code = 0

				unit:SetAcquisitionRange(3000)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk_init.vpcf", unit, 2)
				unit.aggro = true
				-- if unit:GetUnitName() == "redfall_castle_dweller" then
				--   unit:SetRenderColor(255, 60, 60)
				--   Redfall:ColorWearables(unit, Vector(255, 60, 60))
				-- elseif unit:GetUnitName() == "iron_spine" then
				--   unit:SetRenderColor(255, 60, 60)
				--   Redfall:ColorWearables(unit, Vector(255, 60, 60))
				-- elseif unit:GetUnitName() == "redfall_castle_demented_shaman" then
				--   unit:SetRenderColor(255, 60, 60)
				--   Redfall:ColorWearables(unit, Vector(255, 60, 60))
				-- end
			else
				for i = 1, #unit.buddiesTable, 1 do
					unit.buddiesTable[i].aggro = true
					unit.buddiesTable[i].itemLevel = itemLevel
					Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit.buddiesTable[i], "tanari_wind_temple_modifier", {})
					Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit.buddiesTable[i], "tanari_mountain_specter_ai", {})
					unit.buddiesTable[i].code = 0
					unit.buddiesTable[i]:SetAcquisitionRange(3000)
					unit.buddiesTable[i].dominion = true
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk_init.vpcf", unit.buddiesTable[i], 2)
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

function Tanari:SpiritWindTempleRoom2()
	local positionTable = {Vector(15313, 11840), Vector(15232, 11584), Vector(15232, 12050), Vector(14592, 11904)}
	for i = 1, #positionTable, 1 do
		local fv = (Vector(14917, 11757) - positionTable[i]):Normalized()
		Tanari:SpawnWindCrusher(positionTable[i], fv)
	end
	Timers:CreateTimer(3, function()
		local positionTable = {Vector(12942, 12288), Vector(13184, 11434), Vector(11904, 11520)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(14917, 11757) - positionTable[i]):Normalized()
			Tanari:SpawnWindCrusher(positionTable[i], fv)
		end
	end)
	Timers:CreateTimer(4, function()
		local basePos = Vector(11968, 11500)
		for i = 1, 21, 1 do
			Timers:CreateTimer(i * 0.2, function()
				local spawnPosition = basePos + Vector(RandomInt(0, 2000), RandomInt(0, 850))
				local fv = (Vector(14917, 11757) - spawnPosition):Normalized()
				Tanari:SpawnWindTempleViper(spawnPosition, fv)
			end)
		end
	end)
	Timers:CreateTimer(5, function()
		local positionTable = {Vector(12224, 11776), Vector(12528, 11648), Vector(12528, 11968), Vector(12775, 12224), Vector(13120, 12224), Vector(13174, 11840), Vector(13174, 11520), Vector(13504, 11904), Vector(13504, 11644), Vector(13670, 11712), Vector(13760, 12040), Vector(14016, 11857), Vector(12030, 12224), Vector(12030, 11456), Vector(12032, 11264), Vector(12288, 11264), Vector(12800, 12224), Vector(12544, 12224)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Tanari:SpawnWindTempleLizard(positionTable[i], fv)
		end
	end)
	Timers:CreateTimer(12, function()
		Tanari:SpawnWindBear(Vector(12284, 8960), Vector(-1, -1))
		Tanari:SpawnWindBear(Vector(11901, 8775), Vector(0, 1))
		Tanari:SpawnWindBear(Vector(13359, 8321), Vector(0, 1))
		Tanari:SpawnWindBear(Vector(15483, 8750), Vector(-1, 0.3))
		Tanari:SpawnWindBear(Vector(14208, 9216), Vector(0, -1))
		Timers:CreateTimer(3, function()
			Tanari:SpawnWindSprite(Vector(12032, 8832), Vector(0, 1))
			Tanari:SpawnWindSprite(Vector(12655, 8692), Vector(-1, 0.2))
			Tanari:SpawnWindSprite(Vector(13376, 8692), Vector(-1, 0))
			Tanari:SpawnWindSprite(Vector(14502, 8332), Vector(-1, 0.1))
			Tanari:SpawnWindSprite(Vector(14361, 8960), Vector(-1, 0))
			Tanari:SpawnWindSprite(Vector(15168, 8576), Vector(-1, -0.1))
		end)
		Timers:CreateTimer(6, function()
			local positionTable = {Vector(12902, 8640), Vector(14336, 9146), Vector(15360, 8960), Vector(14645, 8320), Vector(13668, 8256)}
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
				if GameState:GetDifficultyFactor() == 3 then
					spawnCount = 2
				end
				for k = 1, spawnCount, 1 do
					local elemental = Tanari:SpawnWindSpark(positionTable[i], RandomVector(1))
					Tanari:AddPatrolArguments(elemental, 50, 4, 30, patrolPositionTable)
				end
			end
			Tanari:SpawnWindCrusher(Vector(14592, 8128), Vector(-0.5, 1))
			Tanari:SpawnWindCrusher(Vector(15488, 8128), Vector(-1, 0))
			Tanari:SpawnWindCrystalTree(Vector(15578, 6642), Vector(0, 1))
		end)
	end)
end

function Tanari:SpawnWindCrusher(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_wind_crusher", position, 0, 2, "Tanari.WindCrusher.Aggro", fv, false)
	mage.itemLevel = 70
	mage.dominion = true
	Events:AdjustBossPower(mage, 6, 6, false)
	Tanari:SetPositionCastArgs(mage, 720, 0, 2, FIND_ANY_ORDER)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnWindTempleViper(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_wind_temple_viper", position, 0, 2, "Tanari.WindViper.Aggro", fv, false)
	mage.itemLevel = 77
	mage.dominion = true
	Events:AdjustBossPower(mage, 1, 1, false)
	Tanari:SetPositionCastArgs(mage, 720, 0, 4, FIND_ANY_ORDER)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnWindTempleLizard(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("tanari_wind_temple_lizard", position, 1, 2, nil, fv, false)
	sapling.itemLevel = 49
	Events:AdjustBossPower(sapling, 1, 2)
	sapling:SetRenderColor(180, 180, 255)
	sapling.targetRadius = 1000
	sapling.minRadius = 0
	sapling.targetAbilityCD = 3.5
	sapling.targetFindOrder = FIND_ANY_ORDER
	sapling.dominion = true
	sapling:SetAbsOrigin(sapling:GetAbsOrigin() - Vector(0, 0, 300))
	local ability = sapling:FindAbilityByName("wind_temple_fish_ability")
	ability:ApplyDataDrivenModifier(sapling, sapling, "modifier_thicket_growth_waiting", {})
	return sapling
end

function Tanari:SpawnWindSprite(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_wind_sprite", position, 0, 2, "Tanari.WindSprite.Aggro", fv, false)
	mage.itemLevel = 76
	mage.dominion = true
	Events:AdjustBossPower(mage, 3, 3, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnWindSpark(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_wind_spark", position, 0, 2, "Tanari.WindSpark.Aggro", fv, false)
	mage.itemLevel = 88
	mage.dominion = true
	Events:AdjustBossPower(mage, 2, 2, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnWindCrystalTree(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("tanari_wind_crystal_tree", position, 2, 4, "Tanari.WindTreant.Aggro", fv, false)
	sapling.itemLevel = 90
	Events:AdjustBossPower(sapling, 1, 2)
	sapling:SetRenderColor(180, 180, 255)
	sapling.targetRadius = 1000
	sapling.minRadius = 0
	sapling.targetAbilityCD = 1
	sapling.targetFindOrder = FIND_CLOSEST
	sapling.dominion = true
	return sapling
end

function Tanari:SpawnWindApparition(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_wind_apparation", position, 3, 6, "Tanari.WindSpirit.Aggro", fv, false)
	mage.itemLevel = 80
	mage.dominion = true
	Events:AdjustBossPower(mage, 3, 3, false)
	Tanari:SetPositionCastArgs(mage, 600, 0, 4, FIND_ANY_ORDER)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnWindBallSwitch(position)
	local ball = CreateUnitByName("tanari_wind_spark_dummy", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	ball:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
	ball:AddAbility("tanari_wind_ball_prop"):SetLevel(1)
	ball:RemoveAbility("dummy_unit")
	ball:RemoveModifierByName("dummy_unit")
	ball.startPosition = ball:GetAbsOrigin()
	ball.jumpLock = true
	ball.pushLock = true
	ball.dummy = true
	ball.moveVelocity = 0
	ball.liftVelocity = 0
	ball.roll = 0
	ball.pitch = 0
	ball.interval = 0
	ball:SetRenderColor(100, 255, 100)
	ball:SetModelScale(1.0)
end

function Tanari:SpawnWindDemon(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_wind_demon", position, 3, 6, nil, fv, true)
	mage.type = ENEMY_TYPE_MINI_BOSS
	mage.itemLevel = 80
	Events:AdjustBossPower(mage, 6, 6, false)
	mage:SetRenderColor(0, 0, 0)
	Tanari:SetPositionCastArgs(mage, 1000, 0, 1, FIND_ANY_ORDER)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	local ability = mage:FindAbilityByName("tanari_wind_demon_passive")
	ability:ApplyDataDrivenModifier(mage, mage, "modifier_wind_demon_waiting", {})
	return mage
end

function Tanari:SpiritWindTempleBossRoom()
	Tanari:SpawnWindBear(Vector(12928, 2688), Vector(-1, 0))
	Tanari:SpawnWindBear(Vector(12928, 2432), Vector(-1, 0))
	Tanari:SpawnWindBear(Vector(12928, 2176), Vector(-1, 0))
	Tanari:SpawnWindSpark(Vector(12032, 2325), RandomVector(1))
	Timers:CreateTimer(3, function()
		local positionTable = {Vector(12032, 2496), Vector(12370, 2496), Vector(12715, 2626), Vector(12715, 2187), Vector(13087, 2360), Vector(13443, 2361), Vector(13782, 2368), Vector(13662, 2112), Vector(13983, 1984), Vector(14099, 2304), Vector(14514, 2688), Vector(14491, 2058), Vector(14784, 2058)}
		for i = 1, #positionTable, 1 do
			Tanari:SpawnWindNinja(positionTable[i], RandomVector(1))
		end
	end)

	Timers:CreateTimer(5, function()
		Tanari:SpawnWindBear(Vector(14080, 2624), Vector(-1, -1))
		Tanari:SpawnWindCrusher(Vector(13312, 2944), Vector(0, -1))
		Tanari:SpawnWindCrusher(Vector(14208, 2944), Vector(0, -1))
	end)
	Timers:CreateTimer(7, function()
		local positionTable2 = {Vector(11169, 2880), Vector(11264, 2560), Vector(11840, 2398), Vector(12672, 2176), Vector(13056, 2709), Vector(13903, 2816), Vector(14656, 2709), Vector(14656, 2176), Vector(14080, 1824)}
		for i = 1, #positionTable2, 1 do
			--print("poison flowers")
			local flower = Tanari:SpawnPoisonFlower(RandomVector(1), positionTable2[i])
			Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, flower, "tanari_mountain_specter_ai", {})
		end
	end)
	Tanari.WindTemple.GuardianTable = {}
	local guardian = Tanari:SpawnWindValleyGuardian(Vector(12416, 2721), Vector(0, -1), 0.5)
	table.insert(Tanari.WindTemple.GuardianTable, guardian)
	local guardian = Tanari:SpawnWindValleyGuardian(Vector(13153, 2138), Vector(0, 1), 0.5)
	table.insert(Tanari.WindTemple.GuardianTable, guardian)
	local guardian = Tanari:SpawnWindValleyGuardian(Vector(13603, 2720), Vector(0, -1), 0.5)
	table.insert(Tanari.WindTemple.GuardianTable, guardian)
	local guardian = Tanari:SpawnWindValleyGuardian(Vector(14400, 2334), Vector(-1, 0), 0.5)
	table.insert(Tanari.WindTemple.GuardianTable, guardian)
	local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/cyclone_fm06.vpcf", PATTACH_WORLDORIGIN, guardian)
	ParticleManager:SetParticleControl(pfx, 0, Vector(13777, 2202, 548))
	Tanari.WindTemple.TornadoPFX = pfx
end

function Tanari:SpawnWindNinja(position, fv)
	local mage = Tanari:SpawnDungeonUnit("wind_temple_spirit_ninja", position, 0, 2, "Tanari.SpiritNinja.Aggro", fv, false)
	mage.itemLevel = 80
	mage.dominion = true
	Events:AdjustBossPower(mage, 1, 1, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnWindValleyGuardian(position, fv, delay)
	local guardian = CreateUnitByName("wind_valley_guardian", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	guardian:SetForwardVector(fv)
	guardian.type = ENEMY_TYPE_MINI_BOSS
	Events:AdjustDeathXP(guardian)
	Events:AdjustBossPower(guardian, 12, 12, false)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 300, 600, false)
	local ability = guardian:FindAbilityByName("wind_valley_guardian")
	Timers:CreateTimer(delay, function()
		ability:ApplyDataDrivenModifier(guardian, guardian, "modifier_valley_guardian_waiting", {})
		ability:ApplyDataDrivenModifier(guardian, guardian, "modifier_valley_guardian_stone", {})
	end)
	guardian.targetRadius = 1000
	guardian.minRadius = 0
	guardian.targetAbilityCD = 1
	guardian.targetFindOrder = FIND_ANY_ORDER
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, guardian, "tanari_mountain_specter_ai", {})
	return guardian
end

function Tanari:SpawnWindTempleSpiritBoss()
	local guardian = Events:SpawnBoss("wind_temple_spirit_boss", Vector(12992, 1536))

	Tanari.WindTemple.SpiritBoss = guardian
	guardian.type = ENEMY_TYPE_BOSS
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, guardian, "tanari_mountain_specter_ai", {})
	-- local guardian = CreateUnitByName("wind_temple_spirit_boss", Vector(12992, 1536), false, nil, nil, DOTA_TEAM_NEUTRALS)
	guardian:SetForwardVector(Vector(0, 1))
	Events:AdjustBossPower(guardian, 4, 4, true)
	local ability = guardian:FindAbilityByName("wind_spirit_main_boss_ability")
	ability:ApplyDataDrivenModifier(guardian, guardian, "modifier_main_boss_entering", {})
	Timers:CreateTimer(0.3, function()
		guardian:MoveToPosition(Vector(13772, 2298))
		EmitSoundOn("Tanari.WindSpiritBoss.Spawn", guardian)
	end)
	Timers:CreateTimer(5.5, function()
		StartAnimation(guardian, {duration = 2.5, activity = ACT_DOTA_VICTORY, rate = 1.2})
		EmitSoundOn("Tanari.WindSpiritBoss.Start", guardian)
		Timers:CreateTimer(1.3, function()
			for i = 1, #Tanari.WindTemple.GuardianTable, 1 do
				Tanari.WindTemple.GuardianTable[i]:RemoveModifierByName("modifier_valley_guardian_waiting")
				Tanari.WindTemple.GuardianTable[i]:RemoveModifierByName("modifier_valley_guardian_stone")
				EmitSoundOn("Tanari.WindKeyHolderStoneForm", Tanari.WindTemple.GuardianTable[i])
				CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", Tanari.WindTemple.GuardianTable[i], 3)

				CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", Tanari.WindTemple.GuardianTable[i], 3)
				Timers:CreateTimer(0.5, function()
					EmitSoundOnLocationWithCaster(guardian:GetAbsOrigin(), "Tanari.WindGuardian.SpawnVO", Tanari.WindTemple.GuardianTable[i])
				end)
				local ability = Tanari.WindTemple.GuardianTable[i]:FindAbilityByName("wind_valley_guardian")
				ability:ApplyDataDrivenModifier(Tanari.WindTemple.GuardianTable[i], Tanari.WindTemple.GuardianTable[i], "modifier_valley_guardian_final", {})

				Events:CreateLightningBeam(Tanari.WindTemple.GuardianTable[i]:GetAbsOrigin(), Tanari.WindTemple.GuardianTable[i]:GetAbsOrigin() + Vector(0, 0, RandomInt(1600, 2000)))
				EmitSoundOnLocationWithCaster(Tanari.WindTemple.GuardianTable[i]:GetAbsOrigin(), "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
				Tanari.WindTemple.GuardianTable[i]:SetAcquisitionRange(2400)
				Tanari.WindTemple.GuardianTable[i].aggro = true
			end
		end)
		Timers:CreateTimer(1.5, function()
			guardian:RemoveModifierByName("modifier_main_boss_entering")
			local guardianAbility = guardian:FindAbilityByName("wind_spirit_main_boss_ability")
			guardianAbility:ApplyDataDrivenModifier(guardian, guardian, "modifier_spirit_boss_fighting", {})
		end)
	end)

	local properties = {
		roll = 0,
		pitch = 0,
		yaw = 0,
		XPos = -5,
		YPos = 0,
		ZPos = -150,
	}
	Attachments:AttachProp(guardian, "attach_head", "models/items/axe/shout_mask/shout_mask.vmdl", 0.9, properties)
end

function Tanari:DebugSpawnBoss()
	local guardian = CreateUnitByName("wind_temple_spirit_boss", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	local properties = {
		roll = 0,
		pitch = -10,
		yaw = 0,
		XPos = 25,
		YPos = 0,
		ZPos = -100,
	}
	Attachments:AttachProp(stone, "head", "models/items/axe/shout_mask/shout_mask.vmdl", 1.5, properties)
	return guardian
end

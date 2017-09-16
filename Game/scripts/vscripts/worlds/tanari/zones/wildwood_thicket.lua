function Tanari:SpawnThicket()
	-- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(7493, 3584, 500), 8000, 1000, false)
	--DEBUG
	local thicketPoint1 = Vector(6208, 4864)
	local thicketPoint2 = Vector(9472, 4480) 
	local thicketPoint3 = Vector(7168, 4032) 
	local thicketPoint4 = Vector(6492, 2752)
	local thicketPoint5 = Vector(7872, 1536)
	local thicketPoint6 = Vector(8022, 5211)
	local thicketPoint7 = Vector(8192, 3776)
	Timers:CreateTimer(5, function()
		Tanari:CreateDynamicWindTempleWall()
	end)
	Timers:CreateTimer(3, function()
		Timers:CreateTimer(8, function()
			local patrolHunter1 = Tanari:SpawnHeadhunter(thicketPoint1)
			local patrolHunter2 = Tanari:SpawnHeadhunter(thicketPoint1+RandomVector(100))
			patrolHunter1.patrolPositionTable = {thicketPoint2, thicketPoint5, thicketPoint4, thicketPoint1}
			patrolHunter2.patrolPositionTable = {thicketPoint2, thicketPoint5, thicketPoint4, thicketPoint1}

			patrolHunter1 = Tanari:SpawnThicketPriest(thicketPoint2)
			patrolHunter2 = Tanari:SpawnThicketTank(thicketPoint2+RandomVector(100))
			patrolHunter1.patrolPositionTable = {thicketPoint3, thicketPoint4, thicketPoint1, thicketPoint2}
			patrolHunter2.patrolPositionTable = {thicketPoint3, thicketPoint4, thicketPoint1, thicketPoint2}
		end)

		Timers:CreateTimer(3, function()
			local patrolHunter1 = Tanari:SpawnHeadhunter(thicketPoint3)
			local patrolHunter2 = Tanari:SpawnThicketTank(thicketPoint3+RandomVector(100))
			patrolHunter1.patrolPositionTable = {thicketPoint4, thicketPoint5, thicketPoint2, thicketPoint1, thicketPoint3}
			patrolHunter2.patrolPositionTable = {thicketPoint4, thicketPoint5, thicketPoint2, thicketPoint1, thicketPoint3}
		end)

		local patrolHunter1 = Tanari:SpawnHeadhunter(thicketPoint4)
		local patrolHunter2 = Tanari:SpawnThicketPriest(thicketPoint4+RandomVector(100))
		local patrolHunter3 = Tanari:SpawnHeadhunter(thicketPoint4+RandomVector(100))
		patrolHunter1.patrolPositionTable = {thicketPoint1, thicketPoint2, thicketPoint3, thicketPoint5, thicketPoint4}
		patrolHunter2.patrolPositionTable = {thicketPoint1, thicketPoint2, thicketPoint3, thicketPoint5, thicketPoint4}
		patrolHunter3.patrolPositionTable = {thicketPoint1, thicketPoint2, thicketPoint3, thicketPoint5, thicketPoint4}

		patrolHunter1 = Tanari:SpawnHeadhunter(thicketPoint5)
		patrolHunter2 = Tanari:SpawnThicketPriest(thicketPoint5+RandomVector(100))
		patrolHunter3 = Tanari:SpawnThicketTank(thicketPoint5+RandomVector(100))
		patrolHunter1.patrolPositionTable = {thicketPoint6, thicketPoint1, thicketPoint3, thicketPoint4, thicketPoint5}
		patrolHunter2.patrolPositionTable = {thicketPoint6, thicketPoint1, thicketPoint3, thicketPoint4, thicketPoint5}
		patrolHunter3.patrolPositionTable = {thicketPoint6, thicketPoint1, thicketPoint3, thicketPoint4, thicketPoint5}

		patrolHunter1 = Tanari:SpawnThicketPriest(thicketPoint6)
		patrolHunter2 = Tanari:SpawnThicketPriest(thicketPoint6+RandomVector(100))
		patrolHunter3 = Tanari:SpawnHeadhunter(thicketPoint6+RandomVector(100))
		patrolHunter1.patrolPositionTable = {thicketPoint1, thicketPoint6}
		patrolHunter2.patrolPositionTable = {thicketPoint1, thicketPoint6}
		patrolHunter3.patrolPositionTable = {thicketPoint1, thicketPoint6}

		Timers:CreateTimer(4, function()
			patrolHunter1 = Tanari:SpawnHeadhunter(thicketPoint7)
			patrolHunter2 = Tanari:SpawnThicketPriest(thicketPoint7+RandomVector(100))
			patrolHunter3 = Tanari:SpawnThicketTank(thicketPoint7+RandomVector(100))
			patrolHunter1.patrolPositionTable = {thicketPoint1, thicketPoint2, thicketPoint5, thicketPoint4, thicketPoint5, thicketPoint7}
			patrolHunter2.patrolPositionTable = {thicketPoint1, thicketPoint2, thicketPoint5, thicketPoint4, thicketPoint5, thicketPoint7}
			patrolHunter3.patrolPositionTable = {thicketPoint1, thicketPoint2, thicketPoint5, thicketPoint4, thicketPoint5, thicketPoint7}
		end)
	end)
	Timers:CreateTimer(20, function()
		Tanari:SpawnHighPriestTorall(Vector(9664, 1408), Vector(-1,-1))
		local hunter1 = Tanari:SpawnHeadhunter(Vector(9518, 1441))
		hunter1.patrolPositionTable = {Vector(9326, 1400), Vector(9518, 1441)}
		local hunter2 = Tanari:SpawnThicketPriest(Vector(9838, 1339))
		hunter2.patrolPositionTable = {Vector(9713, 1261), Vector(9838, 1339)}
		local hunter3 = Tanari:SpawnThicketTank(Vector(9587, 1262))
		hunter3.patrolPositionTable = {Vector(9416, 1186), Vector(9587, 1262)}
	end)
	Timers:CreateTimer(5, function()
		EmitSoundOnLocationWithCaster(Vector(7488, 7872, 200), "Ambient.Tanari.Windy", Events.GameMaster)
		return 10
	end)

	Timers:CreateTimer(3, function()
		Tanari:SpawnThicketWatcher(Vector(6080, 2368), Vector(1,-1))
		Tanari:SpawnThicketWatcher(Vector(7326, 3199), Vector(-1,1))
		Tanari:SpawnThicketWatcher(Vector(7300, 1101), Vector(0,1))
		Tanari:SpawnThicketWatcher(Vector(9229, 1707), Vector(0,-1))
		Tanari:SpawnThicketWatcher(Vector(9229, 3551), Vector(-0.2,1))
		Timers:CreateTimer(4, function()
			Tanari:SpawnThicketWatcher(Vector(9918, 4122), Vector(-1,1))
			Tanari:SpawnThicketWatcher(Vector(8823, 4544), Vector(0,-1))
			Tanari:SpawnThicketWatcher(Vector(6718, 4392), Vector(1,0))
			if GameState:GetDifficultyFactor() > 1 then
				Tanari:SpawnThicketWatcher(Vector(6080, 3199), Vector(1,0))
				Tanari:SpawnThicketWatcher(Vector(7086, 2651), Vector(-1,0))
				Tanari:SpawnThicketWatcher(Vector(7834, 881), Vector(0.4,1))
				Tanari:SpawnThicketWatcher(Vector(8441, 4739), Vector(0,1))
				Tanari:SpawnThicketWatcher(Vector(7977, 4393), Vector(-1,0))
				Tanari:SpawnThicketWatcher(Vector(6718, 3896), Vector(0,-1))
			end
		end)
	end)
end

function Tanari:SpawnHeadhunter(position)
	local hunter = Tanari:SpawnDungeonUnit("tanari_headhunter", position, 2, 4, "huskar_husk_anger_0"..RandomInt(1,6), Vector(1,0), false)
	Events:AdjustBossPower(hunter, 2, 2, false)
	hunter.itemLevel = 26
	hunter.patrolSlow = 40
	hunter.phaseIntervals = 9
	hunter.patrolPointRandom = 300
	hunter.dominion = true
	return hunter
end

function Tanari:SpawnThicketPriest(position)
	local hunter = Tanari:SpawnDungeonUnit("tanari_thicket_priest", position, 2, 4, "meepo_meepo_anger_0"..RandomInt(1,3), Vector(1,0), false)
	Events:AdjustBossPower(hunter, 2, 2, false)
	hunter.itemLevel = 26
	hunter.patrolSlow = 40
	hunter.phaseIntervals = 9
	hunter.patrolPointRandom = 300
	hunter.dominion = true
	return hunter
end

function Tanari:SpawnThicketTank(position)
	local hunter = Tanari:SpawnDungeonUnit("tanari_thicket_pain_absorber", position, 2, 4, "elder_titan_elder_anger_04", Vector(1,0), false)
	Events:AdjustBossPower(hunter, 2, 2, false)
	hunter.itemLevel = 26
	hunter.patrolSlow = 40
	hunter.phaseIntervals = 9
	hunter.patrolPointRandom = 300
	hunter.dominion = true
	return hunter
end



function Tanari:SpawnPrimitiveAmbusher(position, fv)
	local hunter = Tanari:SpawnDungeonUnit("tanari_primitive_hunter", position, 0, 1, "troll_warlord_troll_anger_0"..RandomInt(1,6), fv, true)
	hunter.itemLevel = 18
	WallPhysics:Jump(hunter, fv, 24, 22, 20, 1.2)
	StartAnimation(hunter, {duration=1, activity=ACT_DOTA_RUN, rate=1, translate="haste"})
	hunter.dominion = true
	return hunter
end

function Tanari:SpawnHighPriestTorall(position, fv)
	local hunter = Tanari:SpawnDungeonUnit("tanari_thicket_high_priest", position, 3, 6, "meepo_meepo_anger_0"..RandomInt(1,3), fv, false)
	Events:AdjustBossPower(hunter, 3, 3, false)
	hunter.itemLevel = 32
	hunter.dominion = true
end

function Tanari:SpawnSideThicket()
	local basePos = Vector(5120, 6464)
	for i = 1, 20, 1 do
		Timers:CreateTimer(i*0.4, function()
			Tanari:SpawnSapling(basePos+Vector(0,0,50*i)+RandomVector(120), RandomVector(1))
		end)
	end
	for j = 1, 12, 1 do
		Timers:CreateTimer(j*0.7, function()
			Tanari:SpawnThicketBat(Vector(5120, 8576))
		end)
	end
	Tanari:SpawnWildTroll(Vector(4928, 7616), Vector(-1,-1))
	Tanari:SpawnThicketBatMatriarch(Vector(5222, 9877), Vector(0,-1))
	-- local item = RPCItems:CreateUnstashable("item_rpc_thicket_bat_egg", "rare", "Thicket Bat Egg", -1, false, "Tanari Jungle only", "thicket_bat_egg_description")
	-- CreateItemOnPositionSync(Vector(5120, 10162), item)
	-- local particleName = RPCItems:GetRarityParticle("rare")
	-- item.particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, item )
	-- ParticleManager:SetParticleControl( item.particle, 0, item:GetContainer():GetAbsOrigin() )
end

function Tanari:SpawnSapling(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("blighted_sapling", position, 0, 1, "Tanari.Sapling.Aggro", fv, false)
	sapling.itemLevel = 27
	sapling:RemoveAbility("knockback_immunity")
	sapling:RemoveAbility("desert_ruins_ability")
	sapling:SetModelScale(0.6)	
	sapling.dominion = true
	CustomAbilities:QuickAttachParticle("particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf", sapling, 1)
end

function Tanari:SpawnWildTroll(position, fv)
	local troll = Tanari:SpawnDungeonUnit("tanari_wild_troll", position, 2, 3, "techies_tech_pain_01", fv, false)
	troll.itemLevel = 27
	Events:AdjustBossPower(troll, 1, 1)
	troll.dominion = true
end

function Tanari:SpawnThicketBat(position)
	local sapling = Tanari:SpawnDungeonUnit("tanari_thicket_bat", position, 0, 2, "Tanari.Bat.Aggro", Vector(1,0), false)
	sapling.itemLevel = 32
	sapling.dominion = true
end

function Tanari:SpawnThicketBatMatriarch(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("tanari_thicket_matriarch", position, 3, 6, "Tanari.BatMatriarch.Aggro", fv, false)
	sapling.itemLevel = 37
	Events:AdjustBossPower(sapling, 5, 5)
	sapling.dominion = true
end

function Tanari:SpawnThicketUrsa(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("tanari_thicket_ursa", position, 1, 2, "Tanari.ThicketUrsa.Aggro", fv, false)
	sapling.itemLevel = 26
	Events:AdjustBossPower(sapling, 1, 1)
	sapling.dominion = true
	return sapling
end

function Tanari:SpawnThicketWatcher(position, fv)
	local sapling = Tanari:SpawnDungeonUnit("thicket_watcher", position, 1, 2, nil, fv, false)
	sapling.itemLevel = 26
	Events:AdjustBossPower(sapling, 2, 2)
	sapling:SetAbsOrigin(GetGroundPosition(position, sapling))
	local ability = sapling:FindAbilityByName("thicket_growth_ability")
	ability:ApplyDataDrivenModifier(sapling, sapling, "modifier_thicket_growth_waiting", {})
	sapling:AddNoDraw()
	sapling.dominion = true

	local luck = RandomInt(1,6-GameState:GetDifficultyFactor())
	if luck == 1 then
		local sapling = Tanari:SpawnDungeonUnit("thicket_watcher", position, 1, 2, nil, fv, false)
		sapling.itemLevel = 26
		Events:AdjustBossPower(sapling, 2, 2)
		sapling:SetAbsOrigin(GetGroundPosition(position, sapling))
		local ability = sapling:FindAbilityByName("thicket_growth_ability")
		ability:ApplyDataDrivenModifier(sapling, sapling, "modifier_thicket_growth_waiting", {})
		sapling:AddNoDraw()
		sapling.dominion = true
	end
	return sapling
end
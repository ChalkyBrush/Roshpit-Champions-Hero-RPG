function Winterblight:SpawnSeaQueen(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("sea_fortress_sea_queen", position, 1, 3, "Seafortress.SeaQueen.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 180, 255)
  Events:AdjustBossPower(queen, 5, 3, false)
  return queen
end

function Winterblight:SpawnBarnacleBehemoth(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("sea_fortress_barnacle_behemoth", position, 1, 3, "Seafortress.Barnacle.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 140, 255)
  queen.reduc = 0.5
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetTargetCastArgs(queen, 400, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Winterblight:SpawnSeaPortal(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("sea_fortress_sea_portal", position, 1, 3, "Seafortress.SeaPortal.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 140, 255)
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetPositionCastArgs(queen, 1400, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Winterblight:SpawnLunarRanger(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("sea_fortress_lunar_archer", position, 0, 2, nil, fv, false)
  queen:SetRenderColor(60, 60, 60)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.dominion = true
  return queen
end

function Winterblight:SpawnSeaDryad(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("sea_fortress_dryad", position, 1, 2, "Seafortress.Dryad.Aggro", fv, false)
  queen:SetRenderColor(150, 180, 255)
  Events:AdjustBossPower(queen, 5, 5, false)
  queen.dominion = true
  return queen
end

function Winterblight:SpawnCarnivore(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("carnivorous_swamp_dweller", position, 1, 2, "Seafortress.Carnivore.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.25
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Winterblight:SpawnSwampDragon(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_swamp_dragon", position, 2, 3, "Seafortress.SwampDragon.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.25
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Winterblight:SpawnSwampUrsa(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_bear", position, 0, 1, "Seafortress.SwampUrsa.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.5
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.targetRadius = 420
  queen.autoAbilityCD = 1
  return queen
end

function Winterblight:SpawnSeafortressViper(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_viper", position, 0, 1, "Seafortress.Viper.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Winterblight:SpawnMantaRider(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_manta_rider", position, 1, 1, "Seafortress.MantaRider.Aggro", fv, false)
  queen:SetRenderColor(160, 255, 100)
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:SetAbsOrigin(position)
  Timers:CreateTimer(0.2, function()
    queen:MoveToPosition(position + queen:GetForwardVector() * 3)
  end)
  Winterblight:SetPositionCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
  queen.dominion = true
  return queen
end

function Winterblight:SpawnSeaFortressLizard(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_canyon_lizard", position, 1, 2, "Seafortress.Lizard.Aggro", fv, false)
  queen:SetRenderColor(140, 180, 255)
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  return queen
end

function Winterblight:SpawnNagaSamurai(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("water_temple_naga_samurai", position, 1, 2, "Seafortress.NagaSamuari.Aggro", fv, false)
  queen:SetRenderColor(80, 140, 255)
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.dominion = true
  return queen
end

function Winterblight:SpawnFrostMage(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("water_temple_naga_frost_mage", position, 1, 2, "Seafortress.NagaFrostMage.Aggro", fv, false)
  queen:SetRenderColor(80, 140, 255)
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.dominion = true
  Winterblight:SetPositionCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Winterblight:SpawnNagaProtector(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("water_temple_naga_protector", position, 1, 2, "Seafortress.NagaProtector.Aggro", fv, false)
  queen:SetRenderColor(255, 140, 140)
  Events:AdjustBossPower(queen, 10, 8, false)
  queen.dominion = true
  queen.reduc = 0.4
  local ability = queen:FindAbilityByName("creature_stormshield")
  ability:ApplyDataDrivenModifier(queen, queen, "modifier_stormshield_cloak", {})
  return queen
end

function Winterblight:SpawnGhostPirate(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_ghost_pirate", position, 1, 2, "Seafortress.GhostPirate.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 165, 255)
  Events:ColorWearables(queen, Vector(100, 165, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.4
  Winterblight:SetTargetCastArgs(queen, 800, 0, 1, FIND_ANY_ORDER)
  queen.dominion = true
  return queen

end

function Winterblight:SpawnDeepShadowWeaver(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_deep_shadow_weaver", position, 2, 4, "Seafortress.DeepShadow.Aggro", fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.4
  queen.deathCode = 9
  return queen
end

function Winterblight:SpawnOceanDeathArcher(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("deep_ocean_death_archer", position, 1, 1, "Seafortress.DeathArcher.Die", fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.dominion = true
  return queen
end

function Winterblight:SpawnSeaRider(position, fv, aggroSound)
  local queen = Winterblight:SpawnDungeonUnit("deep_sea_rider", position, 2, 4, aggroSound, fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.04
  return queen
end

function Winterblight:SpawnMechanoid(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_mekanoid_disruptor", position, 1, 2, nil, fv, false)
  queen:SetRenderColor(100, 255, 255)
  Events:ColorWearables(queen, Vector(100, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.4
  queen.dominion = true
  return queen
end

function Winterblight:SpawnSpikeyBeetle(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("spikey_beetle", position, 1, 2, "Seafortress.LobsterAggro", fv, false)
  queen:SetRenderColor(190, 255, 255)
  Events:ColorWearables(queen, Vector(190, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.3
  queen.dominion = true
  return queen
end

function Winterblight:SpawnSpearback(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("cavern_spearback", position, 1, 2, "Seafortress.SpineAggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:ColorWearables(queen, Vector(120, 255, 255))
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.reduc = 0.2
  queen.dominion = true
  return queen
end

function Winterblight:SpawnFortuneSeeker(position, fv)
  local stone = Winterblight:SpawnDungeonUnit("crimsyth_fortune_seeker", position, 1, 3, "Seafortress.FortuneSeeker.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(120, 255, 255)
  Events:ColorWearables(stone, Vector(120, 255, 255))
  Events:AdjustBossPower(stone, 8, 8, false)
  -- stone:AddNewModifier(stone, nil, "modifier_animation", {translate="run"})
  stone:AddNewModifier(stone, nil, "modifier_animation", {translate = "attack_normal_range"})
  stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate = "run"})
  Events:SetPositionCastArgs(stone, 1000, 0, 1, FIND_ANY_ORDER)
  stone.dominion = true
  stone.reduc = 0.2
  return stone
end

function Winterblight:SpawnCrymsithBerserker(position, fv)
  local stone = Winterblight:SpawnDungeonUnit("redfall_crimsyth_berserker", position, 1, 2, "Seafortress.CrimsythBerserker.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(120, 255, 255)
  Events:ColorWearables(stone, Vector(120, 255, 255))
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.dominion = true
  stone.reduc = 0.3
  return stone
end

function Winterblight:SpawnDarkSunderer(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_dark_sunderer", position, 1, 3, "Seafortress.DarkSunderer.Aggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:ColorWearables(queen, Vector(120, 255, 255))
  Events:AdjustBossPower(queen, 8, 10, false)
  queen:AddNewModifier(stone, nil, "modifier_animation_translate", {translate = "walk"})
  queen.dominion = true
  queen.reduc = 0.015
  return queen
end

function Winterblight:SpawnFortressCentaur(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_centaur", position, 1, 2, "Seafortress.Centaur.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.targetRadius = 320
  queen.autoAbilityCD = 1
  return queen
end

function Winterblight:SpawnSoulSplicer(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_soul_splicer", position, 1, 2, "Seafortress.SoulSplicer.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 100)
  Events:ColorWearables(queen, Vector(120, 255, 165))
  queen.reduc = 0.3
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Winterblight:SpawnFairyDragon(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("sea_fortress_fairy_dragon", position, 1, 3, "Seafortress.FairyDragon.Aggro", fv, false)
  -- queen.dominion = true
  --problems with crashing when dominated
  queen:SetRenderColor(160, 255, 100)
  Events:ColorWearables(queen, Vector(120, 255, 165))
  Events:AdjustBossPower(queen, 2, 8, false)
  return queen
end

function Winterblight:SpawnKrayBeast(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_kray_beast", position, 1, 2, "Seafortress.KrayBeast.Aggro", fv, false)
  queen.dominion = true
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetPositionCastArgs(queen, 1000, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Winterblight:SpawnDragoon(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_aqua_dragoon", position, 1, 1, "Seafortress.Dragoon.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 255)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  queen.targetRadius = 900
  queen.autoAbilityCD = 1
  return queen
end

function Winterblight:SpawnBloodDrinker(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_blood_drinker", position, 1, 1, "Seafortress.BloodDrinker.Aggro", fv, false)
  queen:SetRenderColor(120, 255, 255)
  Events:AdjustBossPower(queen, 8, 10, false)
  queen.dominion = true
  queen.reduc = 0.25
  Winterblight:SetTargetCastArgs(queen, 700, 0, 1, FIND_ANY_ORDER)
  queen:AddNewModifier(queen, nil, "modifier_movespeed_cap_super", {})
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Winterblight:SpawnWaterBug(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_water_bug", position, 1, 1, "Seafortress.WaterBug.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(160, 255, 255)
  queen.reduc = 0.5
  Events:AdjustBossPower(queen, 8, 8, false)
  return queen
end

function Winterblight:SpawnSaltwaterDemon(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_saltwater_demon", position, 3, 5, "Seafortress.SaltwaterDemon.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 220, 255)
  queen.reduc = 0.02
  Events:AdjustBossPower(queen, 10, 10, false)
  Winterblight:SetPositionCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
  return queen
end

function Winterblight:SpawnPassageTitan(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_sea_passage_titan", position, 1, 3, "Seafortress.SeaTitan.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(0, 190, 255)
  Events:ColorWearables(queen, Vector(0, 190, 255))
  queen.reduc = 0.1
  Events:AdjustBossPower(queen, 10, 10, false)
  Winterblight:SetTargetCastArgs(queen, 700, 0, 1, FIND_ANY_ORDER)
  -- Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  return queen
end

function Winterblight:SpawnBladewarrior(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_raging_bladewarrior", position, 1, 3, "Seafortress.BladeWarrior.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 220, 255)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 10, 10, false)
  queen:SetRenderColor(0, 190, 255)
  Events:ColorWearables(queen, Vector(0, 190, 255))
  queen:AddNewModifier(queen, nil, "modifier_animation", {translate = "run_fast"})
  return queen
end

function Winterblight:SpawnAxemaster(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_troll_axemaster", position, 1, 3, "Seafortress.Axelord.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 220, 255)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 10, 10, false)
  queen:SetRenderColor(0, 190, 255)
  Events:ColorWearables(queen, Vector(0, 190, 255))
  return queen
end

function Winterblight:SpawnZombiePirate(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_wandering_pirate", position, 1, 3, "Seafortress.WanderingZombie.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(0, 190, 255)
  -- Events:ColorWearables(queen, Vector(0, 190, 255))
  queen.reduc = 0.1
  Events:AdjustBossPower(queen, 10, 10, false)
  Winterblight:SetPositionCastArgs(queen, 700, 0, 1, FIND_ANY_ORDER)
  -- Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, queen, "modifier_seafortress_blue", {})
  return queen
end

function Winterblight:SpawnZombiedSeafarer(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_zombied_seafarer", position, 1, 1, "Seafortress.Seafarer.Aggro", fv, false)
  queen.dominion = true
  -- queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetPositionCastArgs(queen, 800, 0, 1, FIND_ANY_ORDER)
  queen.randomMissMin = 60
  queen.randomMissMax = 220
  return queen
end

function Winterblight:SpawnDrownedWraith(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_drowned_wraith", position, 0, 0, "Seafortress.DrownedWraith.Aggro", fv, true)
  queen.dominion = true

  queen.reduc = 0.3

  return queen
end

function Winterblight:SpawnRainGargoyle(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_rain_gargoyle", position, 0, 1, "Seafortress.RainGargoyle.Aggro", fv, false)
  queen.dominion = true

  queen.reduc = 0.3

  return queen
end

function Winterblight:SpawnDarkReefGuard(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_dark_reef_guard", position, 1, 1, "Seafortress.DarkReefGuard.Aggro", fv, false)
  queen.dominion = true
  -- queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.2
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier(queen, nil, 'modifier_movespeed_cap_sonic', {})
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end


function Winterblight:SpawnDarkReefElite(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("dark_reef_elite", position, 1, 3, "Seafortress.DarkReefElite.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.09
  Events:AdjustBossPower(queen, 8, 8, false)
  queen:AddNewModifier(queen, nil, 'modifier_movespeed_cap_sonic', {})
  queen.castAnimation = ACT_DOTA_CAST_ABILITY_4
  Winterblight:SetTargetCastArgs(queen, 900, 0, 6, FIND_FARTHEST)
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Winterblight:SpawnOceanCentaur(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_ocean_centaur", position, 1, 1, "Seafortress.OceanCentaur.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.1
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetTargetCastArgs(queen, 900, 0, 2, FIND_ANY_ORDER)
  queen:AddNewModifier(queen, nil, 'modifier_movespeed_cap_sonic', {})
  Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, queen, "modifier_ms_thinker", {})
  return queen
end

function Winterblight:SpawnOceanDiviner(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("seafortress_ocean_diviner", position, 1, 2, "Seafortress.Diviner.Aggro", fv, false)
  queen.dominion = true
  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.06
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetTargetCastArgs(queen, 1000, 0, 1, FIND_FARTHEST)
  return queen
end

function Winterblight:SpawnNextOceanOnslaughtUnit(spawnphase)
	local positionTable = {Vector(-15232, 1792), Vector(-14735, 2176), Vector(-15232, 2304), Vector(-15488, 2688), Vector(-14720, 2688), Vector(-15441, 3328), Vector(-14976, 3328), Vector(-14464, 3328), Vector(-13965, 3456), Vector(-13440, 3456), Vector(-12800, 3456),
	Vector(-14464, 3840), Vector(-14976, 3840), Vector(-15488, 3840), Vector(-15488, 4608), Vector(-13965, 4096), Vector(-13440, 4096), Vector(-12800, 4096), Vector(-12288, 4096), Vector(-11401, 3584), Vector(-10752, 3584), Vector(-10112, 3584),
	Vector(-9472, 3584), Vector(-8960, 3773), Vector(-9472, 4096), Vector(-10512, 4011), Vector(-11122, 4096), Vector(-11762, 4096), Vector(-14976, 4608), Vector(-14464, 4608), Vector(-13965, 4608), Vector(-13440, 4608),
	Vector(-12800, 4608), Vector(-12288, 4608), Vector(-11763, 4608), Vector(-11122, 4608), Vector(-10512, 4480), Vector(-9658, 4480), Vector(-10112, 4864), Vector(-10512, 4864), Vector(-10678, 5248), Vector(-11123, 5248),
	Vector(-11762, 5120), Vector(-12288, 5248), Vector(-12800, 5248), Vector(-13440, 5120), Vector(-13965, 5120), Vector(-14336, 5120), Vector(-14848, 5120), Vector(-15488, 5120), Vector(-15488, 5888),
	Vector(-14848, 5888), Vector(-14377, 5888), Vector(-13824, 5888), Vector(-13298, 5888), Vector(-12800, 5760), Vector(-12288, 5760), Vector(-11648, 5760), Vector(-15488, 6272), Vector(-14848, 6272),
	Vector(-14377, 6528), Vector(-13824, 6400), Vector(-13298, 6400), Vector(-12800, 6272), Vector(-12288, 6272), Vector(-11648, 6272), Vector(-12288, 6784), Vector(-15263, 6784), Vector(-15590, 7168),
	Vector(-14859, 7257), Vector(-14464, 7257), Vector(-13952, 7424), Vector(-13440, 7168), Vector(-12928, 7168), Vector(-15222, 7680), Vector(-14464, 7808), Vector(-13952, 8192), Vector(-13952, 7808), Vector(-13440, 7728)}
	local position = positionTable[RandomInt(1, #positionTable)]
	local seafort_spawn_index = RandomInt(1, 42)
	if Winterblight:ShouldSpawnCaveUnit(3, spawnphase) and Winterblight.OnslaughtUnitsSpawned < 240 then
		local unit = nil
		if seafort_spawn_index == 1 then
			unit = Winterblight:SpawnSeaQueen(position, RandomVector(1))
		elseif seafort_spawn_index == 2 then
			unit = Winterblight:SpawnBarnacleBehemoth(position, RandomVector(1))
		elseif seafort_spawn_index == 3 then
			unit = Winterblight:SpawnSeaPortal(position, RandomVector(1))
		elseif seafort_spawn_index == 4 then
			unit = Winterblight:SpawnLunarRanger(position, RandomVector(1))
		elseif seafort_spawn_index == 5 then
			unit = Winterblight:SpawnSeaDryad(position, RandomVector(1))
		elseif seafort_spawn_index == 6 then
			unit = Winterblight:SpawnCarnivore(position, RandomVector(1))
		elseif seafort_spawn_index == 7 then
			unit = Winterblight:SpawnSwampDragon(position, RandomVector(1))
		elseif seafort_spawn_index == 8 then
			unit = Winterblight:SpawnSwampUrsa(position, RandomVector(1))
		elseif seafort_spawn_index == 9 then
			unit = Winterblight:SpawnSeafortressViper(position, RandomVector(1))
		elseif seafort_spawn_index == 10 then
			unit = Winterblight:SpawnMantaRider(position, RandomVector(1))
		elseif seafort_spawn_index == 11 then
			unit = Winterblight:SpawnSeaFortressLizard(position, RandomVector(1))
		elseif seafort_spawn_index == 12 then
			unit = Winterblight:SpawnNagaSamurai(position, RandomVector(1))
		elseif seafort_spawn_index == 13 then
			unit = Winterblight:SpawnFrostMage(position, RandomVector(1))
		elseif seafort_spawn_index == 14 then
			unit = Winterblight:SpawnNagaProtector(position, RandomVector(1))
		elseif seafort_spawn_index == 15 then
			unit = Winterblight:SpawnGhostPirate(position, RandomVector(1))
		elseif seafort_spawn_index == 16 then
			unit = Winterblight:SpawnDeepShadowWeaver(position, RandomVector(1))
		elseif seafort_spawn_index == 17 then
			unit = Winterblight:SpawnOceanDeathArcher(position, RandomVector(1))
		elseif seafort_spawn_index == 18 then
			unit = Winterblight:SpawnSeaRider(position, RandomVector(1), nil)
		elseif seafort_spawn_index == 19 then
			unit = Winterblight:SpawnMechanoid(position, RandomVector(1))
		elseif seafort_spawn_index == 20 then
			unit = Winterblight:SpawnSpikeyBeetle(position, RandomVector(1))
		elseif seafort_spawn_index == 21 then
			unit = Winterblight:SpawnSpearback(position, RandomVector(1))
		elseif seafort_spawn_index == 22 then
			unit = Winterblight:SpawnFortuneSeeker(position, RandomVector(1))
		elseif seafort_spawn_index == 23 then
			unit = Winterblight:SpawnCrymsithBerserker(position, RandomVector(1))
		elseif seafort_spawn_index == 24 then
			unit = Winterblight:SpawnDarkSunderer(position, RandomVector(1))
		elseif seafort_spawn_index == 25 then
			unit = Winterblight:SpawnFortressCentaur(position, RandomVector(1))
		elseif seafort_spawn_index == 26 then
			unit = Winterblight:SpawnSoulSplicer(position, RandomVector(1))
		elseif seafort_spawn_index == 27 then
			unit = Winterblight:SpawnFairyDragon(position, RandomVector(1))
		elseif seafort_spawn_index == 28 then
			unit = Winterblight:SpawnKrayBeast(position, RandomVector(1))
		elseif seafort_spawn_index == 29 then
			unit = Winterblight:SpawnDragoon(position, RandomVector(1))
		elseif seafort_spawn_index == 30 then
			unit = Winterblight:SpawnBloodDrinker(position, RandomVector(1))
		elseif seafort_spawn_index == 31 then
			unit = Winterblight:SpawnWaterBug(position, RandomVector(1))
		elseif seafort_spawn_index == 32 then
			unit = Winterblight:SpawnSaltwaterDemon(position, RandomVector(1))
		elseif seafort_spawn_index == 33 then
			unit = Winterblight:SpawnPassageTitan(position, RandomVector(1))
		elseif seafort_spawn_index == 34 then
			unit = Winterblight:SpawnBladewarrior(position, RandomVector(1))
		elseif seafort_spawn_index == 35 then
			unit = Winterblight:SpawnAxemaster(position, RandomVector(1))
		elseif seafort_spawn_index == 36 then
			unit = Winterblight:SpawnZombiePirate(position, RandomVector(1))
		elseif seafort_spawn_index == 37 then
			unit = Winterblight:SpawnZombiedSeafarer(position, RandomVector(1))
		elseif seafort_spawn_index == 38 then
			unit = Winterblight:SpawnDrownedWraith(position, RandomVector(1))
		elseif seafort_spawn_index == 39 then
			unit = Winterblight:SpawnRainGargoyle(position, RandomVector(1))
		elseif seafort_spawn_index == 40 then
			unit = Winterblight:SpawnDarkReefElite(position, RandomVector(1))
		elseif seafort_spawn_index == 41 then
			unit = Winterblight:SpawnDarkReefGuard(position, RandomVector(1))
		else
			unit = Winterblight:SpawnOceanDiviner(position, RandomVector(1))
		end
		Dungeons:AggroUnit(unit)
		Winterblight:SetCavernUnit(unit, unit:GetAbsOrigin(), false, false, 3)
		Winterblight.OnslaughtUnitsSpawned = Winterblight.OnslaughtUnitsSpawned + 1
		unit.spawnphase = spawnphase
		EmitSoundOn("Winterblight.OceanOnslaught.Spawn", unit)
		CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 4)
	end
end
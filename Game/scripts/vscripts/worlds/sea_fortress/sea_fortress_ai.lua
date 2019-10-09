function seafortress_unit_die(event)
	local caster = event.unit
	if caster.deathCode then
		if caster.deathCode == 0 then
			if not Seafortress.queensKilled then
				Seafortress.queensKilled = 0
			end
			Seafortress.queensKilled = Seafortress.queensKilled + 1
			if Seafortress.queensKilled == 7 then
				local lord = Seafortress:SpawnSeaLord(Vector(256, -9728), Vector(0, -1))
				lord.deathCode = 1
				EmitSoundOn("SeaFortress.SeaGod.Aggro", lord)
				local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, lord)
				ParticleManager:SetParticleControl(particle1, 0, lord:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, 140))
				EmitSoundOn("Tanari.WaterSplash", lord)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end
		elseif caster.deathCode == 1 then
			Seafortress:SpawnRoom2()
			EmitSoundOn("SeaFortress.SeaGod.Die", caster)
			local wall = Entities:FindByNameNearest("SeaDoor1", Vector(-2265, -9478, 402 + Seafortress.ZFLOAT), 700)
			Seafortress:Walls(false, {wall}, true, 4)
			Seafortress:RemoveBlockers(4, "SeaBlocker1", Vector(-2240, -9577), 800)
		elseif caster.deathCode == 2 then
			if not Seafortress.leafletDeaths then
				Seafortress.leafletDeaths = 0
				Seafortress.leafletPhase = 0
			end
			Seafortress.leafletDeaths = Seafortress.leafletDeaths + 1
			if Seafortress.leafletDeaths == 70 then
				Seafortress.leafletDeaths = 0
				if Seafortress.leafletPhase < 2 then
					Seafortress.leafletPhase = Seafortress.leafletPhase + 1
					for i = 1, #Seafortress.treeBoss.treesGrownTable, 1 do
						Seafortress.treeBoss.treesGrownTable[i] = 1
					end
				elseif Seafortress.leafletPhase == 2 then
					--print("LEAFLET!")
					Seafortress.leafletPhase = Seafortress.leafletPhase + 1
					Seafortress.treeBoss:RemoveModifierByName("modifier_disable_player")
					local treeBossAbility = Seafortress.treeBoss:FindAbilityByName("sea_fortress_tree_ability")
					treeBossAbility:ApplyDataDrivenModifier(Seafortress.treeBoss, Seafortress.treeBoss, "modifier_fungal_overlord_passive", {})
					Seafortress.treeBoss.phase = 2
					local archerPosTable = {Vector(-4672, -10944), Vector(-5632, -11107), Vector(-6272, -9884), Vector(-5376, -9408), Vector(-6144, -8448), Vector(-4544, -8192)}
					for i = 1, #archerPosTable, 1 do
						local fv = (Vector(-4800, -9679) - archerPosTable[i]):Normalized()
						local archer = Seafortress:SpawnLunarRanger(archerPosTable[i], fv)
						archer:SetAbsOrigin(archer:GetAbsOrigin() + Vector(0, 0, 2000))
						WallPhysics:Jump(archer, fv, 0, 0, 0, 0.5)
						archer.jumpEnd = "pfx"
						archer.jumpPFX = "particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf"
						Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, archer, "modifier_disable_player", {duration = 1.9})
						Timers:CreateTimer(0.5, function()
							StartAnimation(archer, {duration = 1.9, activity = ACT_DOTA_UNDYING_DECAY, rate = 1.1})
						end)
					end
				end
			end
		elseif caster.deathCode == 3 then
			local wall = Entities:FindByNameNearest("SeaDoor2", Vector(-6195, -12000, 527 + Seafortress.ZFLOAT), 900)
			Seafortress:Walls(false, {wall}, true, 4)
			Seafortress:RemoveBlockers(5, "SeaBlocker1", Vector(-6144, -12021, 129), 1200)
			Seafortress:SpawnGardenRoom()
			Timers:CreateTimer(2.82, function()
				ScreenShake(caster:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
			end)
			Seafortress:LeftWingKill()
		elseif caster.deathCode == 4 then
			if not Seafortress.groveBlossomsSpawned then
				Seafortress.groveBlossomsSpawned = 0
			end
			Seafortress.groveBlossomsSpawned = Seafortress.groveBlossomsSpawned + 1
			if Seafortress.groveBlossomsSpawned == 26 then
				if not Seafortress.blossomWaves then
					Seafortress.blossomWaves = 0
					-- if Beacons.cheats then
					-- Seafortress.blossomWaves = 4
					-- end
				end
				if Seafortress.blossomWaves < 4 then
					Seafortress.groveBlossomsSpawned = 0
					Seafortress.blossomWaves = Seafortress.blossomWaves + 1
					local basePos = Vector(-10944, -14979)
					for i = 1, #Seafortress.BeastTable, 1 do
						StartAnimation(Seafortress.BeastTable[i], {duration = 1, activity = ACT_DOTA_RUN, rate = 1.5})
						EmitSoundOn("Seafortress.Beast.ShatterVO", (Seafortress.BeastTable[i]))
					end
					for j = 1, 30, 1 do
						Timers:CreateTimer(j * 0.06, function()
							local randX = RandomInt(1, 700)
							local randY = RandomInt(1, 1700)
							local blossom = Seafortress:SpawnGroveBlossom(basePos + Vector(randX, randY), RandomVector(1))
							EmitSoundOn("Seafortress.SpawnGroveBlossom", blossom)
							blossom.deathCode = 4
						end)
					end
				else
					for i = 1, #Seafortress.BeastTable, 1 do
						local beast = Seafortress.BeastTable[i]
						local beastAbility = beast:FindAbilityByName("sea_fortress_mountain_beast_ability")
						beast.deathCode = 5
						beastAbility:ApplyDataDrivenModifier(beast, beast, "modifier_mountain_beast_in_combat", {})
						beast:RemoveModifierByName("modifier_disable_player")
					end
					--print("OPEN BEHIND MOUNTAINS!!")
				end
			end
		elseif caster.deathCode == 5 then
			if not Seafortress.mountainBeastsSlain then
				Seafortress.mountainBeastsSlain = 0
			end
			Seafortress.mountainBeastsSlain = Seafortress.mountainBeastsSlain + 1
			if Seafortress.mountainBeastsSlain == 3 then
				local wall = Entities:FindByNameNearest("SeaRockDoor", Vector(-12813, -14466, 566 + Seafortress.ZFLOAT), 900)
				Seafortress:Walls(false, {wall}, true, 4)
				Seafortress:RemoveBlockers(5, "SeaBlocker1", Vector(-12738, -14528, 530), 1200)
				Seafortress:SpawnBehindMountainArea()
				Seafortress:LeftWingKill()
			end
		elseif caster.deathCode == 6 then
			EmitSoundOn("Seafortress.SwampRevenant.Death", caster)
			Timers:CreateTimer(0.82, function()
				Seafortress.RevenantDead = true
				local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(particle1, 0, Seafortress.switchA:GetAbsOrigin())
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				EmitSoundOnLocationWithCaster(Seafortress.switchA:GetAbsOrigin(), "Seafortress.SwitchImpact", Events.GameMaster)
			end)
			Seafortress:LeftWingKill()
			Seafortress.switchA:SetAbsOrigin(Seafortress.switchA:GetAbsOrigin() + Vector(0, 0, 3000))
			for i = 1, 30, 1 do
				Timers:CreateTimer(i * 0.03, function()
					Seafortress.switchA:SetAbsOrigin(Seafortress.switchA:GetAbsOrigin() - Vector(0, 0, (2000 / 30)))
				end)
			end
		elseif caster.deathCode == 7 then
			EmitSoundOn("Seafortress.Ursan.Death", caster)
			Timers:CreateTimer(0.82, function()
				Seafortress.UrsanDead = true
				Seafortress:LeftWingKill()
				local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(particle1, 0, Seafortress.switchB:GetAbsOrigin())
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				EmitSoundOnLocationWithCaster(Seafortress.switchB:GetAbsOrigin(), "Seafortress.SwitchImpact", Events.GameMaster)
			end)
			Seafortress.switchB:SetAbsOrigin(Seafortress.switchB:GetAbsOrigin() + Vector(0, 0, 3000))
			for i = 1, 30, 1 do
				Timers:CreateTimer(i * 0.03, function()
					Seafortress.switchB:SetAbsOrigin(Seafortress.switchB:GetAbsOrigin() - Vector(0, 0, (2000 / 30)))
				end)
			end
		elseif caster.deathCode == 8 then
			EmitSoundOn("Seafortress.Zharkun.Death", caster)
			EndAnimation(caster)
			Seafortress:LeftWingKill()
			Timers:CreateTimer(2.2, function()
				local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + caster:GetForwardVector() * 520)
				ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 0.5))
				ParticleManager:SetParticleControl(pfx, 2, Vector(0.7, 0.7, 0.7))
				Timers:CreateTimer(10, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
				ScreenShake(caster:GetAbsOrigin(), 300, 0.5, 0.5, 9000, 0, true)
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.SmallCrash", Events.GameMaster)
			end)
			Timers:CreateTimer(2.5, function()
				local wall = Entities:FindByNameNearest("SeaDoor5", Vector(-13570, 2305, -6 + Seafortress.ZFLOAT), 900)
				Seafortress:Walls(false, {wall}, true, 4)
				Seafortress:RemoveBlockers(5, "SeaBlocker3", Vector(-13570, 2305, 127 + Seafortress.ZFLOAT), 1200)
				Seafortress:SpawnAfterLaserTempleArea()
			end)
			local luck = RandomInt(1, 4)
			if luck == 1 then
				RPCItems:RollDarkEmissaryGlove(caster:GetAbsOrigin())
			end
		elseif caster.deathCode == 9 then
			EmitSoundOn("Seafortress.DeepShadow.Die", caster)
		elseif caster.deathCode == 10 then
			if not Seafortress.JailersSlain then
				Seafortress.JailersSlain = 0
			end
			Seafortress.JailersSlain = Seafortress.JailersSlain + 1
			EmitSoundOn("Seafortress.Jailer.Die", caster)
			if Seafortress.JailersSlain == 13 then
				for i = 1, #Seafortress.FishPrisonerTable, 1 do
					local fish = Seafortress.FishPrisonerTable[i]
					fish.index = i
					StartAnimation(fish, {duration = 2.2, activity = ACT_DOTA_VICTORY, rate = 1.1})
					EmitSoundOn("Seafortress.FishPrisoner.Happy", fish)
					Timers:CreateTimer(1.4, function()
						local fishAbility = fish:FindAbilityByName("seafortress_fish_prisoner_ability")
						fishAbility:ApplyDataDrivenModifier(fish, fish, "modifier_fish_freed_and_ready", {})
						fish.state = 0
					end)
				end
			end
			--JAILER DIE
		elseif caster.deathCode == 11 then
			Seafortress:PortalMazeUnitDie(caster)
		elseif caster.deathCode == 12 then
			EmitSoundOn("Seafortress.SeaMaiden.Death", caster)
			Timers:CreateTimer(0.82, function()
				local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(particle1, 0, Seafortress.Jumper:GetAbsOrigin())
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				EmitSoundOnLocationWithCaster(Seafortress.Jumper:GetAbsOrigin(), "Seafortress.SwitchImpact", Events.GameMaster)
				Timers:CreateTimer(0.4, function()
					Seafortress.MaidenDead = true
					local particle2 = ParticleManager:CreateParticle("particles/roshpit/seafortress/teleport_tube.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
					ParticleManager:SetParticleControl(particle2, 0, Seafortress.Jumper:GetAbsOrigin() - Vector(0, 0, 60))
					local particle3 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
					ParticleManager:SetParticleControl(particle3, 0, Seafortress.Jumper:GetAbsOrigin() - Vector(0, 0, 60))
				end)
			end)
			Seafortress.Jumper:SetAbsOrigin(Seafortress.Jumper:GetAbsOrigin() + Vector(0, 0, 3000))
			for i = 1, 30, 1 do
				Timers:CreateTimer(i * 0.03, function()
					Seafortress.Jumper:SetAbsOrigin(Seafortress.Jumper:GetAbsOrigin() - Vector(0, 0, (2000 / 30)))
				end)
			end
		elseif caster.deathCode == 13 then
			sea_prophet_die(caster)
		elseif caster.deathCode == 14 then
			rain_wave_unit_die(caster)
		elseif caster.deathCode == 15 then
			zealot_die(caster)
		elseif caster.deathCode == 16 then
			dragonwarrior_die(caster)
		elseif caster.deathCode == 17 then
			dark_spirit_die(caster)
		elseif caster.deathCode == 18 then
			colossus_die(caster)
		elseif caster.deathCode == 19 then
			dark_reef_guard_die(caster)
		elseif caster.deathCode == 20 then
			reef_elite_die(caster)
		elseif caster.deathCode == 21 then
			naga_summon_unit_die(caster, true)
		elseif caster.deathCode == 22 then
			naga_summoner_die(caster)
		elseif caster.deathCode == 23 then
			centaur_master_die(caster)
		elseif caster.deathCode == 24 then
			tri_boss_die(caster)
		elseif caster.deathCode == 25 then
			sea_maiden_final_die(caster)
		end
	end

	local premiumCount = GameState:GetPlayerPremiumStatusCount()
	local luck2 = RandomInt(1, 3000 - (500 * premiumCount))
	if luck2 == 1 then
		item_rpc_armor_of_atlantis:Create(caster:GetAbsOrigin())
	elseif luck2 == 2 then
		RPCItems:RollChitinousLobsterClaw(caster:GetAbsOrigin())
	end
	local paragonAdjust = 0
	if caster.paragon then
		paragonAdjust = 2000
	end
	local maxBound = math.max(10000 - (500 * premiumCount) - paragonAdjust, 10)
	local luck3 = RandomInt(1, maxBound)
	if luck3 <= 2 then
		Weapons:RollRandomLegendWeapon2(caster:GetAbsOrigin())
	elseif luck3 == 3 then
		Weapons:RollRandomLegendWeapon3(caster:GetAbsOrigin())
	end
end

function seafortress_unit_think(event)
	local caster = event.target
	if not caster:IsAlive() then
		return false
	end
	if caster:GetUnitName() == "sea_fortress_sea_queen" then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("sea_queen_scream_of_pain")
			if hookAbility:IsFullyCastable() then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hookAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		if caster.aggro then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local hookAbility = caster:FindAbilityByName("sea_queen_blink")
				if hookAbility:IsFullyCastable() then
					local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 320))
					local order =
					{
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = hookAbility:entindex(),
						Position = targetPoint
					}
					ExecuteOrderFromTable(order)
					return false
				end
			end
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local hookAbility = caster:FindAbilityByName("seaqueen_shadow_strike")
				if hookAbility:IsFullyCastable() then
					local order = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						TargetIndex = enemies[1]:entindex(),
						AbilityIndex = hookAbility:entindex(),
					}
					ExecuteOrderFromTable(order)
					return false
				end
			end
		end
	elseif caster:GetUnitName() == "seafortress_deep_shadow_weaver" then
		deep_shadow_weaver_ai(caster)
	elseif caster:GetUnitName() == "seafortress_mekanoid_disruptor" then
		mekanoid_disruptor_ai(caster)
	elseif caster:GetUnitName() == "seafortress_duelist" then
		duelist_ai(caster)
	elseif caster:GetUnitName() == "seafortress_depth_warper" then
		depth_warper_ai(caster)
	elseif caster:GetUnitName() == "sea_fortress_fairy_dragon" then
		fairy_dragon_ai(caster)
	elseif caster:GetUnitName() == "seafortress_poseidon_zealot" then
		poseidon_zealot_ai(caster)
	elseif caster:GetUnitName() == "seafortress_oceanrunner_arkguil" then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("seafortress_centaur_slam")
			if hookAbility:IsFullyCastable() then
				local order = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = hookAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function barnacle_ground_slam_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Seafortress.Barnacle.Windup", caster)
	StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_UNDYING_DECAY, rate = 1.1})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_barnacle_ground_slam", {duration = 0.9})
	Timers:CreateTimer(0.5, function()
		if not caster:IsAlive() then
			return false
		end
		local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 350
		local radius = 340
		if caster:GetUnitName() == "sea_fortress_barnacle_colossus" then
			radius = 440
			damage = damage * 2
		end
		local splitEarthParticle = "particles/units/heroes/hero_leshrac/astral_rune_b_d.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		EmitSoundOn("Seafortress.Barnacle.Quake", caster)
		-- FindClearSpaceForUnit(caster, position, false)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
				enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
			end
		end
	end)
end

function prison_shank_attack(event)
	local attacker = event.attacker
	local target = event.target
	local mult = event.status_mult
	local ability = event.ability
	if target:IsHero() then
		local damage = (target:GetAgility() + target:GetStrength() + target:GetIntellect()) * mult
		ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_slark/slark_essence_shift.vpcf", target, 1.5)
	end
end

function sea_god_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 and not ability.lock then
		ability.lock = true
		for _, enemy in pairs(enemies) do
			Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
		end
		ability.lock = false
	end
end

function hydrogen_field_start(event)
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/roshpit/sea_fortress/hydrogen_field.vpcf"
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	ability.pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)

	local position = event.target_points[1]
	local radius = 600
	ParticleManager:SetParticleControl(ability.pfx, 0, position)
	ParticleManager:SetParticleControl(ability.pfx, 1, Vector(radius, 2, radius * 2))
	EmitSoundOnLocationWithCaster(position, "Seafortress.HydrogenField", caster)
	for i = 1, 14, 1 do
		Timers:CreateTimer(i * 0.5, function()
			if i == 14 then
				ParticleManager:DestroyParticle(ability.pfx, false)
				ability.pfx = false
			end
			if IsValidEntity(caster) then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						if enemy:IsHero() then
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_in_hydrogen_field", {duration = 0.5})
							ApplyDamage({victim = enemy, attacker = caster, damage = 1, damage_type = DAMAGE_TYPE_PURE, ability = ability})
						end
					end
				end
			end
		end)
	end
end

function sea_tree_found_player(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	if not caster.phase then
		caster.phase = -1
		StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.6})
		EmitSoundOn("Seafortress.SeaTree.Intro", caster)
		local fv = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		caster:MoveToPosition(caster:GetAbsOrigin() + fv * 2)
		Timers:CreateTimer(1.5, function()
			caster.phase = 0
			caster.treePosTable = {Vector(-4963, -11193), Vector(-5760, -10422), Vector(-5902, -9253), Vector(-4096, -8064)}
			caster.treesGrownTable = {0, 0, 0, 0}
		end)
	end

end

function sea_tree_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if caster.phase then
		if caster.phase == 0 then
			if not caster.treePos then
				caster.treePos = Vector(0, 0, 0)
				local minIndex = 0
				for i = 1, #caster.treePosTable, 1 do
					local distance1 = WallPhysics:GetDistance2d(caster.treePosTable[i], caster:GetAbsOrigin())
					local distance2 = WallPhysics:GetDistance2d(caster.treePosTable[i], caster.treePos)
					if distance1 < distance2 then
						if caster.treesGrownTable[i] == 0 then
							caster.treePos = caster.treePosTable[i]
							caster.minIndex = i
						end
					end
				end
			else
				caster:MoveToPosition(caster.treePos + RandomVector(360))
				local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.treePos)
				if distance < 780 then
					caster.phase = -1
					local fv = (caster.treePos - caster:GetAbsOrigin()):Normalized()
					caster:Stop()
					-- caster:MoveToPosition(caster:GetAbsOrigin()+fv2)
					local tree = Entities:FindByNameNearest("SeaTree", caster.treePos, 600)
					for i = 1, 150, 1 do
						Timers:CreateTimer(i * 0.03, function()
							local growth = 1.2 / 150
							if i % 50 == 1 then
								StartAnimation(caster, {duration = 1.45, activity = ACT_DOTA_CAST_ABILITY_5, rate = 1.0})
								EmitSoundOn("Seafortress.Tree.LeechSeed", caster)
								local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed.vpcf", PATTACH_POINT_FOLLOW, caster)
								ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
								ParticleManager:SetParticleControlEnt(pfx, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
								ParticleManager:SetParticleControl(pfx, 1, caster.treePos + Vector(0, 0, 60))
								Timers:CreateTimer(0.7, function()
									ParticleManager:DestroyParticle(pfx, false)
									ParticleManager:ReleaseParticleIndex(pfx)
								end)
							end
							tree:SetModelScale(0.6 + growth * i)
						end)

					end
					Timers:CreateTimer(4.5, function()
						Seafortress.seaTreesGrown = Seafortress.seaTreesGrown + 1
						caster.treePos = false
						caster.phase = 0
						caster.treeGrown = true
						caster.treesGrownTable[caster.minIndex] = 1
						if Seafortress.seaTreesGrown == 4 then
							caster.phase = 1
							-- caster:RemoveModifierByName("modifier_disable_player")
						end
					end)
				end
			end
		elseif caster.phase == 1 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			if #enemies > 0 then
				fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				caster:MoveToPosition(caster:GetAbsOrigin() + fv)
			end
		end
		if caster.treeGrown then
			for i = 1, #caster.treesGrownTable, 1 do
				if caster.treesGrownTable[i] > 0 and caster.treesGrownTable[i] < 20 then
					caster.treesGrownTable[i] = caster.treesGrownTable[i] + 1
					local spawnPosition = GetGroundPosition(caster.treePosTable[i], Events.GameMaster) + Vector(0, 0, RandomInt(340, 510))
					local fv = RandomVector(1)
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster.treePosTable[i], nil, 2800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						fv = ((enemies[1]:GetAbsOrigin() - caster.treePosTable[i]) * Vector(1, 1, 0)):Normalized()
					end
					local leaf = nil
					local luck = RandomInt(1, 3)
					if luck == 1 then
						leaf = Seafortress:SpawnLeafletRanged(spawnPosition, fv)
					else
						leaf = Seafortress:SpawnLeaflet(spawnPosition, fv)
					end
					local rate = RandomInt(25, 50)
					StartAnimation(leaf, {duration = 1.7, activity = ACT_DOTA_SPAWN, rate = rate / 100})
					WallPhysics:Jump(leaf, fv, 18, 10, 12, 1.2)
					leaf.deathCode = 2
					EmitSoundOn("Seafortress.LeafletSummon", leaf)
					ability:ApplyDataDrivenModifier(caster, leaf, "modifier_leaflet_spawning", {duration = 0.5})
				end
			end
		end
	end

end

function sea_leaflet_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.hitsTaken then
		caster.hitsTaken = 0
	end
	if not caster:HasModifier("modifier_black_King_bar_immunity") then
		caster.hitsTaken = caster.hitsTaken + 1
		if caster.hitsTaken == 5 then
			caster.hitsTaken = 0
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_black_King_bar_immunity", {duration = 3})
		end
	end
end

function begin_kaze_gust(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = event.range

	local speed = range

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.SilenceWave", caster)

	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.fv = fv

	local startPoint = caster:GetAbsOrigin()
	ability.castPosition = startPoint
	local particle = "particles/units/heroes/hero_drow/drow_silence_wave.vpcf"
	local start_radius = 320
	local end_radius = 320

	-- EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)

	local casterOrigin = caster:GetAbsOrigin()

	local info =
	{
		Ability = ability,
		EffectName = particle,
		vSpawnOrigin = startPoint + Vector(0, 0, 50),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function gust_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local stun_duration = event.stun_duration
	local blind_duration = event.blind_duration
	local damage = ability.damage
	ability:ApplyDataDrivenModifier(caster, target, "modifier_kaze_gust_flail", {duration = 1.0})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_kaze_gust_blind", {duration = blind_duration})
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_drow/drow_hero_silence.vpcf", target, 2.5)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function kaze_pushback_think(event)
	local target = event.target
	if target.jumpLock then
		return false
	end
	local ability = event.ability
	local fv = ability.fv
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), ability.castPosition)
	local pushSpeed = math.max((1700 - distance) / 35, 5)

	local blockSearch = target:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(target:GetAbsOrigin(), target))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + pushSpeed * fv), target)
	if blockUnit then
		pushSpeed = 0
	end

	target:SetAbsOrigin(target:GetAbsOrigin() + fv * pushSpeed)
end

function kaze_pushback_end(event)
	local target = event.target
	if target.jumpLock then
		return false
	end
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function fungal_overlord_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval % 5 == 0 then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), MAIN_HERO_TABLE[i]:GetAbsOrigin())
			if distance < 3000 then
				local position = MAIN_HERO_TABLE[i]:GetAbsOrigin() + RandomVector(110)
				--ability:ApplyDataDrivenThinker(caster, position, "modifier_poison_cloud_thinker", {})
				CustomAbilities:QuickAttachThinker(ability, caster, position, "modifier_poison_cloud_thinker", {duration = 5})
			end
		end
	end
	if caster.interval >= 11 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bog_intro", {duration = 0.9})
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.4})
		EmitGlobalSound("RoshanDT.Scream")

		local particleName = "particles/items2_fx/smoke_of_deceit.vpcf"
		local casterPos = caster:GetAbsOrigin()
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle1, 0, casterPos)
		ParticleManager:SetParticleControl(particle1, 1, Vector(1800, 1000, 300))
		Timers:CreateTimer(0.5, function()
			local distance = RandomInt(200, 700)
			local gasCount = math.floor(distance / 60)
			for i = -gasCount, gasCount, 1 do
				local fv = caster:GetForwardVector()
				local rotatedFv = WallPhysics:rotateVector(fv, math.pi * 2 / gasCount * i)
				local gasPosition = caster:GetAbsOrigin() + rotatedFv * distance
				--ability:ApplyDataDrivenThinker(caster, gasPosition, "modifier_poison_cloud_thinker", {})
				CustomAbilities:QuickAttachThinker(ability, caster, gasPosition, "modifier_poison_cloud_thinker", {duration = 5})
			end
			Timers:CreateTimer(0.5, function()
				distance = distance + 200
				gasCount = math.floor(distance / 60)
				for i = -gasCount, gasCount, 1 do
					local fv = caster:GetForwardVector()
					local rotatedFv = WallPhysics:rotateVector(fv, math.pi * 2 / gasCount * i)
					local gasPosition = caster:GetAbsOrigin() + rotatedFv * distance
					--ability:ApplyDataDrivenThinker(caster, gasPosition, "modifier_poison_cloud_thinker", {})
					CustomAbilities:QuickAttachThinker(ability, caster, gasPosition, "modifier_poison_cloud_thinker", {duration = 5})
				end
				Timers:CreateTimer(0.5, function()
					distance = distance + 200
					gasCount = math.floor(distance / 60)
					for i = -gasCount, gasCount, 1 do
						local fv = caster:GetForwardVector()
						local rotatedFv = WallPhysics:rotateVector(fv, math.pi * 2 / gasCount * i)
						local gasPosition = caster:GetAbsOrigin() + rotatedFv * distance
						--ability:ApplyDataDrivenThinker(caster, gasPosition, "modifier_poison_cloud_thinker", {})
						CustomAbilities:QuickAttachThinker(ability, caster, gasPosition, "modifier_poison_cloud_thinker", {duration = 5})
					end
				end)
			end)
		end)
		ScreenShake(casterPos, 200, 0.9, 0.4, 9000, 0, true)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)

		caster.interval = 0

	end
end

function bog_monster_die(event)
	local caster = event.caster
	Timers:CreateTimer(2.82, function()
		ScreenShake(caster:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
		EmitSoundOn("Hero_Treant.LeechSeed.Cast", caster)
	end)
	

end

function bog_monster_poison_cloud(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsNull() then
		local target = event.target
		local damage = event.poison_damage
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end

function venomous_dragonfly_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = math.min(caster.interval + 1, 10)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	if #enemies > 0 then
		fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		caster:MoveToPosition(caster:GetAbsOrigin() + fv)
		if caster.interval >= 10 then
			caster.interval = 0
			local particle = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
			local start_radius = 200
			local end_radius = 200
			local range = 1200
			local speed = 1000
			StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_RUN, rate = 1.6})

			EmitSoundOn("Seafortress.VenomGale", caster)

			local casterOrigin = caster:GetAbsOrigin()

			local info =
			{
				Ability = ability,
				EffectName = particle,
				vSpawnOrigin = casterOrigin + Vector(0, 0, 100),
				fDistance = range,
				fStartRadius = start_radius,
				fEndRadius = end_radius,
				Source = caster,
				StartPosition = "attach_attack1",
				bHasFrontalCone = true,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = fv * Vector(1, 1, 0) * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end
	end

end

function water_scorcher_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = math.min(caster.interval + 1, 12)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	if #enemies > 0 then
		fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		caster:MoveToPosition(caster:GetAbsOrigin() + fv)
		if caster.interval >= 12 then
			EmitSoundOn("Seafortress.ScorcherBlast", caster)
			for i = -1, 1, 1 do
				local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * i / 16)
				caster.interval = 0
				local particle = "particles/base_attacks/ranged_tower_good_linear.vpcf"
				local start_radius = 120
				local end_radius = 120
				local range = 1500
				local speed = 1200
				StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_RUN, rate = 1.6})
				


				local casterOrigin = caster:GetAbsOrigin()

				local info =
				{
					Ability = ability,
					EffectName = particle,
					vSpawnOrigin = casterOrigin + Vector(0, 0, 200),
					fDistance = range,
					fStartRadius = start_radius,
					fEndRadius = end_radius,
					Source = caster,
					StartPosition = "attach_attack1",
					bHasFrontalCone = true,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 5.0,
					bDeleteOnHit = false,
					vVelocity = rotatedFV * Vector(1, 1, 0) * speed,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end
		end
	end
end

function dryad_speed_start(event)
	local caster = event.caster
	caster:AddNewModifier(caster, nil, 'modifier_movespeed_cap_sonic', {})
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_ms_thinker", {})
end

function sea_exploder_go(event)
	local caster = event.caster
	local ability = event.ability
	local pfx = ParticleManager:CreateParticle("particles/econ/items/puck/puck_alliance_set/puck_waning_rift_aproset.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(500, 10, 500))
	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Seafortress.DetonateCreep", caster)
	local damage = event.damage
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			ApplyDamage({victim = enemies[1], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:ApplyDataDrivenModifier(caster, enemies[1], "modifier_exploder_freeze", {duration = event.freeze_duration})
		end
	end
end

function sea_beast_think(event)
	local caster = event.caster
	local ability = event.ability

	if not caster.interval then
		caster.interval = 0
	end
	if caster.lock then
		return false
	end
	caster.interval = caster.interval + 1
	local searchRadius = math.min(caster.interval * 100, 4000)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		caster.interval = 0
		caster.lock = true
		Timers:CreateTimer(2, function()
			caster.lock = false
		end)
		CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_start.vpcf", caster, 3)
		local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		local target = enemies[1]:GetAbsOrigin() + fv * RandomInt(350, 500)
		local targetPos = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
		FindClearSpaceForUnit(caster, targetPos, false)
		ProjectileManager:ProjectileDodge(caster)
		CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_end.vpcf", caster, 3)
		StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_SPAWN, rate = 1.6})
		EmitSoundOn("Seafortress.MountainBeast.Blink", caster)
	end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	if #enemies > 0 then
		local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		caster:MoveToPosition(caster:GetAbsOrigin() + fv * 240)
		if caster.interval % 6 == 0 then
			EmitSoundOn("Seafortress.Beast.ShatterVO", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_beast_attacking", {duration = 0.8})
			StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_RUN, rate = 1.6})
			for j = 1, 3, 1 do
				Timers:CreateTimer(j * 0.3, function()
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.ScorcherBlast", caster)
					for i = -1, 1, 1 do
						local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * i / 16)
						local particle = "particles/base_attacks/ranged_tower_bad_linear.vpcf"
						local start_radius = 120
						local end_radius = 120
						local range = 1500
						local speed = 1200

						


						local casterOrigin = caster:GetAbsOrigin()

						local info =
						{
							Ability = ability,
							EffectName = particle,
							vSpawnOrigin = caster:GetAbsOrigin() + caster:GetForwardVector() * 50 + Vector(0, 0, 100),
							fDistance = range,
							fStartRadius = start_radius,
							fEndRadius = end_radius,
							Source = caster,
							StartPosition = "attach_hitloc",
							bHasFrontalCone = true,
							bReplaceExisting = false,
							iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
							iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
							iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							fExpireTime = GameRules:GetGameTime() + 5.0,
							bDeleteOnHit = false,
							vVelocity = rotatedFV * Vector(1, 1, 0) * speed,
							bProvidesVision = false,
						}
						projectile = ProjectileManager:CreateLinearProjectile(info)
					end
				end)
			end
		end
	end
	if caster.interval % 3 == 0 then
		local pfx = ParticleManager:CreateParticle("particles/econ/items/puck/puck_fairy_wing/puck_waning_rift_fairy_wing.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(500, 10, 500))
		Timers:CreateTimer(5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Seafortress.DetonateCreep", caster)
		local damage = 65000
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for i = 1, #enemies, 1 do
				ApplyDamage({victim = enemies[1], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
				if enemies[1]:HasModifier("modifier_stun_immune") or enemies[1]:HasModifier("modifier_recently_respawned") then
				else
					ability:ApplyDataDrivenModifier(caster, enemies[1], "modifier_exploder_freeze", {duration = 0.7})
				end
			end
		end
	end
end

function rock_giant_take_damage(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	if not caster.rocksOut then
		caster.rocksOut = 0
	end
	--print("[rock_giant_take_damage] rocksOut: "..tostring(caster.rocksOut))
	if caster.rocksOut < 10 then
		caster.rocksOut = caster.rocksOut + 1
		local info =
		{
			Target = attacker,
			Source = caster,
			Ability = ability,
			EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
			StartPosition = "attach_attack1",
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 5,
			bProvidesVision = true,
			iVisionRadius = 0,
			iMoveSpeed = 600,
		iVisionTeamNumber = caster:GetTeamNumber()}
		local projectile = ProjectileManager:CreateTrackingProjectile(info)
		Timers:CreateTimer(1.5, function()
			if caster.rocksOut > 0 then
				caster.rocksOut = caster.rocksOut - 1
			end
		end)
	end
end

function rock_blast_start(event)
	local ability = event.ability
	local caster = event.caster
	local point = event.target_points[1]

	local attacker = event.attacker
	local length = math.max(WallPhysics:GetDistance(caster:GetAbsOrigin() * Vector(1, 1, 0), point * Vector(1, 1, 0)) / 190, 1) + 2
	length = 12
	local fv = (point * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local startPosition = caster:GetAbsOrigin()
	local damage = event.damage
	local stun_duration = 0.2
	for i = 1, math.floor(length), 1 do
		Timers:CreateTimer(0.1 * (i - 1), function()
			local position = startPosition + fv * i * 200
			position = GetGroundPosition(position, caster)
			terra_blast_explosion(caster, position, damage, 200, ability, stun_duration)
		end)
	end
	ScreenShake(caster:GetAbsOrigin(), 360, 0.6, 0.6, 9000, 0, true)
end

function terra_blast_explosion(caster, position, damage, explosionAOE, ability, stun_duration)
	local particleName = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle1, 0, position)
	ParticleManager:SetParticleControl(particle1, 1, Vector(explosionAOE, 5, explosionAOE * 2))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOnLocationWithCaster(position, "Seafortress.EarthGiant.Quakes", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.2})
		end
	end
end

function tormented_staff_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = event.damage
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_tormented_slow", {duration = 0.2})

			local particleName = "particles/roshpit/arkimus/zonis_lightning.vpcf"
			local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			local attachPointA = caster:GetAbsOrigin() + Vector(0, 0, 330)
			local attachPointB = enemy:GetAbsOrigin() + Vector(0, 0, 60)
			ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
			ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(lightningBolt, false)
				ParticleManager:ReleaseParticleIndex(lightningBolt)
			end)
		end
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.ZonisLightning", caster)
	end


end

function slaughtering_dagger_attack(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	local health_mult = event.health_mult / 100
	local damage = target:GetMaxHealth() * health_mult
	if target:IsHero() then
		ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_slark/slark_essence_shift.vpcf", target, 1.5)
		local particleName = "particles/roshpit/epoch/arcana_a_a_xplosion.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		for i = 0, 5, 1 do
			ParticleManager:SetParticleControlEnt(pfx, i, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControl(pfx, 6, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 10, target:GetAbsOrigin())
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
	EmitSoundOn("Seafortress.CarnivoreAttack.Spatter", target)
end

function carnivore_die(event)
	local caster = event.caster
	if Seafortress then
		local position = caster:GetAbsOrigin()
		local spawns = RandomInt(3, 7)
		for i = 1, spawns, 1 do
			local fv = WallPhysics:rotateVector(Vector(1, 0), 2 * math.pi * i / spawns)
			Seafortress:SpawnLakeCheepWithBlocking(position, fv, false)
		end
	end
end

function sea_dragon_regen_think(event)
	local caster = event.caster
	local ability = event.ability
	local heal_percent = event.heal_percent / 100
	if caster:GetHealth() < caster:GetMaxHealth() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		local healMult = math.max(#enemies, 1)
		local heal = caster:GetMaxHealth() * heal_percent * healMult
		Filters:ApplyHeal(caster, caster, heal, true)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", caster, 1)
	end
end

function sea_lady_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.dying then
		return false
	end
	if caster:GetHealth() < 1000 then
		caster.dying = true
		Seafortress:LeftWingKill()
		caster:RemoveModifierByName("modifier_swamp_shield_passive")
		caster:RemoveModifierByName("modifier_water_emperor_ai")
		StartAnimation(caster, {duration = 5.0, activity = ACT_DOTA_FLAIL, rate = 1.0})
		EmitSoundOn("Seafortress.SwampLady.PreDeath", caster)
		caster.size = 3.64
		caster.shrinking = true
		for i = 1, 120, 1 do
			Timers:CreateTimer(i * 0.03, function()
				local baseScale = 3.64
				if caster.shrinking then
					caster.size = caster.size - 0.06
				else
					caster.size = caster.size + 0.06
				end
				if i % 20 == 0 then
					if caster.shrinking then
						caster.shrinking = false
					else
						caster.shrinking = true
					end
				end
				caster:SetModelScale(caster.size)
			end)
		end
		Timers:CreateTimer(3.2, function()
			local position = caster:GetAbsOrigin()
			local particleName = "particles/roshpit/seafortress/swamp_lady_explode.vpcf"
			EmitSoundOnLocationWithCaster(position + Vector(0, 0, 300), "Seafortress.SwampLady.Death2", Events.GameMaster)
			local pfxB = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(pfxB, 0, position + Vector(0, 0, 0))
			Timers:CreateTimer(55.0, function()
				ParticleManager:DestroyParticle(pfxB, false)
			end)
			for k = 1, 8, 1 do
				local particleName = "particles/roshpit/seafortress/swamp_lady_explode.vpcf"
				local anglePos = position + WallPhysics:rotateVector(Vector(-1, 1), 2 * math.pi * k / 8) * 400
				local pfxC = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfxC, 0, anglePos + Vector(0, 0, 160))
				Timers:CreateTimer(55.0, function()
					ParticleManager:DestroyParticle(pfxC, false)
				end)
			end
		end)
		Timers:CreateTimer(3.8, function()
			local position = caster:GetAbsOrigin()
			UTIL_Remove(caster)
			local fv = RandomVector(1)

			local pfxC = ParticleManager:CreateParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(pfxC, 0, position + Vector(0, 0, 300))
			ParticleManager:SetParticleControl(pfxC, 1, Vector(200, 100, 200))
			Timers:CreateTimer(5.0, function()
				ParticleManager:DestroyParticle(pfxC, false)
			end)
			EmitSoundOnLocationWithCaster(position + Vector(0, 0, 300), "Seafortress.SwampLady.Death", Events.GameMaster)
			Timers:CreateTimer(0.5, function()
				EmitSoundOnLocationWithCaster(position + Vector(0, 0, 300), "Seafortress.SwampLady.DeathSpawn", Events.GameMaster)

			end)
			for j = 1, 3, 1 do
				local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * j / 3)
				local summoner = Seafortress:SpawnSeaLadySummoner(position, rotatedFV)
				summoner:SetAbsOrigin(position + Vector(0, 0, 350))
				WallPhysics:JumpWithBlocking(summoner, rotatedFV, 19, 24, 20, 1)
				StartAnimation(summoner, {duration = 3.0, activity = ACT_DOTA_TELEPORT, rate = 1.0})
				Timers:CreateTimer(4, function()
					summoner.state = 0
					local walkToPosition = Vector(-15168, -8414) + Vector(0, (j - 1) * 300)
					summoner.walkToPosition = walkToPosition
					summoner.aggro = false
				end)
			end
		end)
	end
	if not caster:HasModifier("modifier_water_emperor_submerged") then
		EmitSoundOn("Seafortress.VenomGale", caster)
		local baseFV = caster:GetForwardVector()
		for i = 1, 10, 1 do
			local particle = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
			local start_radius = 200
			local end_radius = 200
			local range = 1200
			local speed = 1000
			local fv = WallPhysics:rotateVector(baseFV, 2 * math.pi * i / 10)


			local casterOrigin = caster:GetAbsOrigin()

			local info =
			{
				Ability = ability,
				EffectName = particle,
				vSpawnOrigin = casterOrigin + Vector(0, 0, 100),
				fDistance = range,
				fStartRadius = start_radius,
				fEndRadius = end_radius,
				Source = caster,
				StartPosition = "attach_hitloc",
				bHasFrontalCone = true,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = fv * Vector(1, 1, 0) * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end
		local luck = RandomInt(1, 3)
		if luck == 1 then
			Timers:CreateTimer(1.5, function()
				EmitSoundOn("Seafortress.SwampLady.Laughing", caster)
			end)
		end
	end

end

function sea_witch_apply_shield(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Seafortress.SwampLady.ShieldApply", caster)
	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_VICTORY, rate = 2.0})
end

function shadow_detected_enemy(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Timers:CreateTimer(0.06, function()
		caster:RemoveNoDraw()
		target:RemoveModifierByName("modifier_thicket_growth_detected_enemy")
	end)
	caster:RemoveModifierByName("modifier_thicket_growth_waiting")
	local position = caster:GetAbsOrigin()

	Dungeons:AggroUnit(caster)
	local animationTable = {ACT_DOTA_CAST_ABILITY_1}
	local animation = animationTable[RandomInt(1, #animationTable)]
	StartAnimation(caster, {duration = 1.5, activity = animation, rate = 1.3})
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 300, 5, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_growing_into_existence", {duration = 1.2})
	for i = 1, 40, 1 do
		Timers:CreateTimer(i * 0.03, function()
			caster:SetModelScale(i * (1 / 40))
		end)
	end
end

function lady_summoner_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if caster.state then
		caster.interval = caster.interval + 1
		if caster.interval > 100 then
			caster.interval = 1
		end
		if caster.state == 0 then
			if not Seafortress.swampStaffs then
				Seafortress.swampStaffs = 0
			end
			caster:MoveToPosition(caster.walkToPosition)
			local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.walkToPosition)
			if distance < 150 then
				Seafortress.swampStaffs = Seafortress.swampStaffs + 1
				caster.state = 1
			end
		elseif caster.state == 1 then
			if Seafortress.swampStaffs == 3 then
				caster.state = 2
			end
		elseif caster.state == 2 then
			caster.state = 3
			EmitSoundOn("Seafortress.SwampSummoner.StartProcess", caster)

			StartAnimation(caster, {duration = 10, activity = ACT_DOTA_VICTORY, rate = 1.0})

		elseif caster.state == 3 then
			if caster.interval % 10 == 0 then
				StartAnimation(caster, {duration = 10, activity = ACT_DOTA_VICTORY, rate = 1.0})
			end
			for i = 0, 1 do
				Timers:CreateTimer(i * 0.5, function()
					local leftHandPoint = caster:GetAbsOrigin() + Vector(0, 0, 190)
					local headPoint = caster.walkToPosition + Vector(-250, 0, 480)
					Events:CreateLightningBeam(leftHandPoint, headPoint)
					EmitSoundOn("Seafortress.ZonisLightning", caster)
				end)
			end
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				Seafortress.swampStaffSequenceStart = true
			end
			if Seafortress.swampStaffSequenceStart then
				caster.state = 4
			end
		elseif caster.state == 4 then
			if caster.interval % 10 == 0 then
				StartAnimation(caster, {duration = 10, activity = ACT_DOTA_VICTORY, rate = 1.0})
			end
			if not Seafortress.staffTicks then
				Seafortress.staffTicks = 0
			end
			Seafortress.staffTicks = Seafortress.staffTicks + 1
			for i = 0, 1 do
				Timers:CreateTimer(i * 0.5, function()
					local leftHandPoint = caster:GetAbsOrigin() + Vector(0, 0, 190)
					local headPoint = caster.walkToPosition + Vector(-250, 0, 480)
					Events:CreateLightningBeam(leftHandPoint, headPoint)
					EmitSoundOn("Seafortress.ZonisLightning", caster)
					local bossPoint = Vector(-15808, -8128, 645 + Seafortress.ZFLOAT)
					Events:CreateLightningBeam(headPoint, bossPoint)
					Events:CreateLightningBeam(bossPoint, GetGroundPosition(bossPoint, Events.GameMaster))
				end)
			end
			if Seafortress.staffTicks > 15 then
				if not Seafortress.RevenantBoss then
					Seafortress.RevenantBoss = Seafortress:SpawnSeaFortressRevenant(Vector(-15808, -8128, 645 + Seafortress.ZFLOAT), Vector(1, 0))
					Seafortress.RevenantBoss:SetModelScale(0.01)
					Seafortress.RevenantBoss.reduc = 0.1
					Seafortress.RevenantBoss.itemReduc = 0.01
					Seafortress.RevenantBoss.deathCode = 6
				end
				caster.state = 5
			end
		elseif caster.state == 5 then
			if caster.interval % 10 == 0 then
				StartAnimation(caster, {duration = 10, activity = ACT_DOTA_VICTORY, rate = 1.0})
			end
			if not Seafortress.RevenantTicks then
				Seafortress.RevenantTicks = 0
			end
			for i = 0, 1 do
				Timers:CreateTimer(i * 0.5, function()
					local leftHandPoint = caster:GetAbsOrigin() + Vector(0, 0, 190)
					local headPoint = caster.walkToPosition + Vector(-250, 0, 480)
					Events:CreateLightningBeam(leftHandPoint, headPoint)
					EmitSoundOn("Seafortress.ZonisLightning", caster)
					local bossPoint = Vector(-15808, -8128, 645 + Seafortress.ZFLOAT)
					Events:CreateLightningBeam(headPoint, bossPoint)
					Events:CreateLightningBeam(bossPoint, GetGroundPosition(bossPoint, Events.GameMaster))
				end)
			end
			Seafortress.RevenantTicks = Seafortress.RevenantTicks + 0.5
			Seafortress.RevenantBoss:SetModelScale(0.01 + (Seafortress.RevenantTicks / 20))
			Timers:CreateTimer(0.5, function()
				Seafortress.RevenantTicks = Seafortress.RevenantTicks + 0.5
				Seafortress.RevenantBoss:SetModelScale(0.01 + (Seafortress.RevenantTicks / 20))
			end)
			--print(Seafortress.RevenantTicks)
			if Seafortress.RevenantTicks > 60 then
				caster.state = 6
				if not Seafortress.RevenantBoss.init then
					Seafortress.RevenantBoss.init = true
					Seafortress.RevenantBoss:RemoveModifierByName("modifier_disable_player")
					EmitSoundOn("Seafortress.SwampRevenant.Aggro", Seafortress.RevenantBoss)
					local staffs = Entities:FindAllByNameWithin("SeaSummonStaff", Vector(-15424, -8128), 1500)
					for i = 1, #staffs, 1 do
						CustomAbilities:QuickAttachParticle("particles/world_destruction_fx/dire_tree004b_destruction.vpcf", staffs[i], 4)
						Timers:CreateTimer(0.2, function()
							EmitSoundOnLocationWithCaster(staffs[i]:GetAbsOrigin(), "Redfall.AutumnSpawner.Death", Events.GameMaster)
							for j = 1, 90, 1 do
								Timers:CreateTimer(j * 0.03, function()
									staffs[i]:SetAbsOrigin(staffs[i]:GetAbsOrigin() - Vector(0, 0, 3))
								end)
							end
							Timers:CreateTimer(3, function()
								UTIL_Remove(staffs[i])
							end)
						end)
					end
				end
			end
		elseif caster.state == 6 then
			caster:RemoveModifierByName("modifier_disable_player")
			EndAnimation(caster)
			EmitSoundOn("Seafortress.SwampSummoner.StartProcess", caster)
		end

	end
end

function revenant_attack(event)
	local attacker = event.attacker
	local target = event.target
	local caster = attacker
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy:GetEntityIndex() == attacker:GetEntityIndex() then
			else
				Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
				Timers:CreateTimer(0.3, function()
					local pfx = ParticleManager:CreateParticle("particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_POINT, attacker)
					ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_POINT, "attach_whip", attacker:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, 100))
					Timers:CreateTimer(1, function()
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:ReleaseParticleIndex(pfx)
					end)
				end)
			end
		end
	end
	Timers:CreateTimer(0.3, function()
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_POINT, attacker)
		ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_POINT, "attach_whip", attacker:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, 100))
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
	end)
end

function revenant_attack_land(event)
	local caster = event.caster
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	local ability = event.ability
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_revenant_slow", {duration = 0.1})
end

function submerge_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		if caster:HasModifier("modifier_water_emperor_submerged") then
			caster:RemoveModifierByName("modifier_water_emperor_submerged")
			--print("RISE!")
			StartAnimation(caster, {duration = 0.61, activity = ACT_DOTA_FLAIL, rate = 0.6})
			for i = 1, 17, 1 do
				Timers:CreateTimer(0.03 * i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 34))
				end)
			end
			Timers:CreateTimer(0.18, function()
				if caster:GetUnitName() == "water_medusa_passive" then
					EmitSoundOn("Seafortress.WaterDusa.Aggro", caster)
				end
				particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, 140))
				EmitSoundOn("Tanari.WaterSplash", caster)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end
	else
		if not caster:HasModifier("modifier_water_emperor_submerged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_emperor_submerged", {})
			--print("FALL!")
			StartAnimation(caster, {duration = 0.57, activity = ACT_DOTA_FLAIL, rate = 0.6})
			for i = 1, 17, 1 do
				Timers:CreateTimer(0.03 * i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 34))
				end)
			end
			Timers:CreateTimer(0.18, function()
				particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, 140))
				EmitSoundOn("Tanari.WaterSplash", caster)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end
	end
end

function manta_rider_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local moveToDirection = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local distance = WallPhysics:GetDistance2d(enemies[1]:GetAbsOrigin(), caster:GetAbsOrigin())
			caster:MoveToPosition(caster:GetAbsOrigin() + moveToDirection * (distance - RandomInt(300, 600)))
		end
		local luck = RandomInt(1, 2)
		if luck == 1 then
			caster.castSound = "Seafortress.BatThrowVO"
		else
			caster.castSound = nil
		end
	end
end

function bombadier_ability_start(event)
	local caster = event.caster
	local ability = event.ability

	local target = event.target_points[1]
	local baseFV = (target * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local divisor = 28
	local forwardVelocity = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin()) / divisor + 6
	--print(baseFV)
	local bombCount = event.num_bombs
	local damage = event.damage
	for i = 0, bombCount - 1, 1 do
		Timers:CreateTimer(i * 0.2, function()
			local randomOffset = RandomInt(-16, 16)
			local flareAngle = WallPhysics:rotateVector(baseFV, math.pi * randomOffset / 160)
			local flare = CreateUnitByName("selethas_boomerang", caster:GetAbsOrigin() + Vector(0, 0, 100), false, caster, nil, caster:GetTeamNumber())
			flare:SetOriginalModel("models/items/techies/bigshot/bigshot_barrel.vmdl")
			flare:SetModel("models/items/techies/bigshot/bigshot_barrel.vmdl")
			flare:SetRenderColor(255, 140, 0)
			flare:SetModelScale(0.1)
			flare.fv = flareAngle
			flare.stun_duration = 1
			flare.liftVelocity = 40
			flare.forwardVelocity = forwardVelocity + RandomInt(-2, 2)
			flare.altMaxScale = 0.5
			flare.interval = 0
			flare.damage = damage
			flare.origCaster = caster
			flare.origAbility = ability
			flare:SetAbsOrigin(flare:GetAbsOrigin() + Vector(0, 0, 120))
			flare:AddAbility("redfall_bombadier_bomb_ability"):SetLevel(1)
			local flareSubAbility = flare:FindAbilityByName("redfall_bombadier_bomb_ability")
			flareSubAbility:ApplyDataDrivenModifier(flare, flare, "modifier_solar_projectile_motion", {})
		end)
	end
end

function exiler_think(event)
	local caster = event.caster
	if caster.aggro and caster:IsAlive() then
		local ability = event.ability
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_start.vpcf", caster, 3)
			local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local target = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(160, 350))
			if caster:GetUnitName() == "seafortress_boss_silver_sea_giant" then
				target = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(500, 750))
			else
				StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_TELEPORT, rate = 1.8})
			end
			local targetPos = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
			FindClearSpaceForUnit(caster, targetPos, false)
			ProjectileManager:ProjectileDodge(caster)
			CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_end.vpcf", caster, 3)
			EmitSoundOn("Seafortress.Exiler.Blink", caster)
		end
	end
end

function exiler_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local proc = Filters:GetProc(attacker, 35)
	if target:HasModifier("modifier_glint_no_proc") then
		local newNoProcStacks = target:GetModifierStackCount("modifier_glint_no_proc", caster) - 1
		if newNoProcStacks > 0 then
			target:SetModifierStackCount("modifier_glint_no_proc", caster, newNoProcStacks)
		else
			target:RemoveModifierByName("modifier_glint_no_proc")
		end

		return false
	end
	if proc then
		if attacker:IsAlive() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_glint_no_proc", {duration = 1})
			target:SetModifierStackCount("modifier_glint_no_proc", caster, 2)
			local newPosition = target:GetAbsOrigin() + target:GetForwardVector() *- 120
			local position = attacker:GetAbsOrigin()
			local newPosition = WallPhysics:WallSearch(position, newPosition, target)
			FindClearSpaceForUnit(attacker, newPosition, false)
			attacker:SetForwardVector(target:GetForwardVector() * Vector(1, 1, 0))
			event.ability:ApplyDataDrivenModifier(event.caster, attacker, "modifier_blinded_glint_buff", {duration = 0.8})

			local particleName = "particles/econ/items/meepo/meepo_diggers_divining_rod/meepo_divining_rod_poof_end_rays_burst.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
			local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx2, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", newPosition, true)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:DestroyParticle(pfx2, false)
			end)
			Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
			Timers:CreateTimer(0.1, function()
				if target:IsAlive() then
					Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
				end
			end)
			EmitSoundOnLocationWithCaster(newPosition, "RPCItem.GlintOfOnu", attacker)
		end
	end
	local damage = event.damage
	local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 240
	local radius = 240
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/astral_rune_b_d.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOn("Seafortress.Barnacle.Quake", caster)
	-- FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 0.1})
		end
	end
end

function exiler_kill(event)
	local unit = event.unit
	local caster = event.caster
	if unit:IsHero() then
		Timers:CreateTimer(3, function()
			if caster:IsAlive() then
				EmitSoundOn("Seafortress.Exiler.Kill", caster)
			end
		end)
	end
end

function exiler_death(event)
	local caster = event.caster
	EmitSoundOn("Seafortress.Exiler.Death", caster)
end

function ursan_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/econ/items/ursa/ursa_swift_claw/ursa_swift_claw_left.vpcf", target, 1)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", target, 3)
	local damage = 1000000000
	ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
end

function stormshield_cloak_shield_think(event)
	local shield = event.target
	if IsValidEntity(shield) then
		local hero = shield.hero
		if hero then
			if hero:IsAlive() then
				shield.offsetVector = WallPhysics:rotateVector(shield.offsetVector, math.pi / 20)
				local heroOrigin = hero:GetAbsOrigin()
				local position = heroOrigin + shield.offsetVector * 60 - Vector(0, 0, 65)
				shield:SetAbsOrigin(position)
				local fv = (position - heroOrigin):Normalized() * Vector(1, 1, 0)
				shield:SetForwardVector(fv)
			else
				local target = hero
				for i = 1, #target.shieldTable, 1 do
					UTIL_Remove(target.shieldTable[i])
				end
				target.shieldTable = false
			end
		else
			-- local target = hero
			-- for i = 1, #target.shieldTable, 1 do
			-- UTIL_Remove(target.shieldTable[i])
			-- end
			-- target.shieldTable = false
		end
	end
end

function prop_attacked(event)

	local shield = event.target
	if shield.laser then
		return false
	end
	local attacker = event.attacker
	if attacker:IsRealHero() then
		local newYaw = shield.yaw
		newYaw = shield.yaw - 15
		if shield.yaw < 0 then
			shield.yaw = 345
		end
		shield.yaw = newYaw
		shield:SetAngles(0, shield.yaw, 0)
	end
end

function attackable_prop_think(event)
	local caster = event.caster
	caster:SetAbsOrigin(caster.basePosition)
end

function laser_mechanism_active_think(event)
	local caster = event.caster
	if not caster.laser then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/solunia/lunar_warp_beam_blade_golden.vpcf", PATTACH_CUSTOMORIGIN, Seafortress.Master)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 105))
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
		caster.laser = pfx
		caster.laserPos = caster:GetAbsOrigin()
	else
		local fv = WallPhysics:angleToVector(caster.yaw)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.laserPos)
		if distance < caster.maxDistance - 30 then
			caster.laserPos = caster.laserPos + fv * 30
			ParticleManager:SetParticleControl(caster.laser, 1, caster.laserPos + Vector(0, 0, 105))
		end
		if caster.lastOne then
			if distance > caster.maxDistance - 60 then
				if not Seafortress.laserCrystalPopped then
					Seafortress.laserCrystalPopped = true
					Timers:CreateTimer(1.5, function()
						AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-11478, -723), 500, 300, false)
						Seafortress:ActivateLaserCrystal(Vector(-11478, -723, 306))
					end)
				end
			end
		else
			local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster.laserPos, nil, 90, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for i = 1, #enemies, 1 do
					local unit = enemies[i]
					--print(unit:GetUnitName())
					if unit.waterMech then
						if not unit:HasModifier("modifier_laser_mechanism_active") then
							if not unit.lock then
								Seafortress:activateLaserMech(unit)
							end
						end
					end
				end
			end
		end
	end
end

function water_medusa_attack_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_water_medusa_stat_loss", {duration = 5})
	local stacks = target:GetModifierStackCount("modifier_water_medusa_stat_loss", caster) + 1
	target:SetModifierStackCount("modifier_water_medusa_stat_loss", caster, stacks)
end

function water_medusa_die(event)
	local caster = event.caster
	Timers:CreateTimer(2.9, function()
		local fv = caster:GetForwardVector()
		local perpFV = WallPhysics:rotateVector(fv, 2 * math.pi / 4)
		local splashPos = caster:GetAbsOrigin() + perpFV * 100 - fv * 30
		particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle1, 0, splashPos * Vector(1, 1, 0) + Vector(0, 0, 60))
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
	end)
end

function zharkaz_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	EmitSoundOn("Seafortress.KhalzonSpawning", target)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", target, 3)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zharkaz_root", {duration = 0.7})
		end
	end
end

function zharkaz_think(event)
	local caster = event.caster
	local ability = event.ability

	if caster.aggro then
		local radius = 1200
		if caster.altSpell then
			radius = 900
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("zharkaz_jump_crush")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin()
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = hookAbility:entindex(),
				TargetIndex = enemies[1]:entindex()}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function mountain_crush_cast(event)
	local caster = event.caster
	local target = event.target
	if not caster.altSpell then
		caster.altSpell = false
	end
	EmitSoundOn("Seafortress.Zharkun.JumpGrunt", caster)
	if caster.altSpell then
		caster.altSpell = false
		CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_flash_b_gravelmaw.vpcf", caster, 1)
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
		ability.acceleration = 60
		ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		ability.distance = 0
		ability.target = target
		StartAnimation(caster, {duration = 2, activity = ACT_DOTA_VICTORY, rate = 1.0})
	else
		CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_flash_b_gravelmaw.vpcf", caster, 1)
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
		ability.acceleration = 60
		ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		ability.distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
		ability.target = target
		StartAnimation(caster, {duration = 2, activity = ACT_DOTA_VICTORY, rate = 1.0})
		caster.altSpell = true
	end
end

function mountain_crush_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	local acceleration = ability.acceleration
	ability.acceleration = ability.acceleration - 4
	local directionVector = ability.directionVector
	local speed = ability.distance / 17

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + directionVector * speed), caster)
	if blockUnit then
		speed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + directionVector * speed + Vector(0, 0, ability.acceleration))
	if ability.acceleration <= 0 then
		if GetGroundHeight(caster:GetAbsOrigin(), caster) > (caster:GetAbsOrigin().z - 20) then
			caster:RemoveModifierByName("modifier_mountain_crush_jumping")
		end
	end
end

function mountain_crush_end(event)
	local caster = event.caster
	local radius = 900
	local position = caster:GetAbsOrigin()
	local ability = event.ability
	local splitEarthParticle = "particles/seafortress/zharkan_quake.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOn("Seafortress.Zharkun.Quake", caster)
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, position, false)
	end)
	ScreenShake(caster:GetAbsOrigin(), 300, 0.5, 1, 9000, 0, true)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius + 5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = 700000, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
		end
	end
end

function ghost_pirate_think(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	if not caster.aggro then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			Timers:CreateTimer(1.5 * (i - 1), function()
				position = caster:GetAbsOrigin()
				local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
				local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				EmitSoundOn("Seafortress.GhostPirate.Teleport", caster)
				local teleportPosition = enemies[i]:GetAbsOrigin() + RandomVector(140)
				caster:SetAbsOrigin(teleportPosition)
				FindClearSpaceForUnit(caster, teleportPosition, false)
				position = caster:GetAbsOrigin()

				local pfx2 = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				ParticleManager:SetParticleControlEnt(pfx2, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx2, false)
				end)

			end)
		end
	end
end

function deep_shadow_weaver_ai(caster)
	local blinkAbility = caster:FindAbilityByName("arena_phantom_strike")
	local luck = RandomInt(1, 4)
	if luck == 1 then
		if blinkAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = blinkAbility:entindex(),
				TargetIndex = enemies[1]:entindex()}

				ExecuteOrderFromTable(newOrder)
			end
			return
		end
	end
	local stifling = caster:FindAbilityByName("arena_stifling_dagger")
	if stifling:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local distance = WallPhysics:GetDistance(enemies[1]:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
			if distance > 500 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = stifling:entindex(),
				TargetIndex = enemies[1]:entindex()}

				ExecuteOrderFromTable(newOrder)
				return
			end
		end
	end
end

function mekanoid_disruptor_ai(caster)
	local hookAbility = caster:FindAbilityByName("mekanoid_hookshot")

	-- if hookAbility:IsFullyCastable() then
	-- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1140, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	-- if #enemies > 0 then
	-- if WallPhysics:IsWithinRegionA(enemies[1]:GetAbsOrigin(), Vector(10880, -4096), Vector(13376, -3116)) then
	-- local newOrder = {
	-- UnitIndex = caster:entindex(),
	-- OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
	-- AbilityIndex = hookAbility:entindex(),
	-- Position = enemies[1]:GetAbsOrigin()
	--  }

	-- ExecuteOrderFromTable(newOrder)
	-- return
	-- end
	-- end
	-- end

	local battery = caster:FindAbilityByName("mekanoid_battery_assault")
	if battery:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = battery:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return
		end
	end
end

function death_archer_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local leftHandPoint = caster:GetAbsOrigin() + Vector(0, 0, 100)
	local headPoint = target:GetAbsOrigin() + Vector(0, 0, 100)
	Events:CreateLightningBeamWithParticle(leftHandPoint, headPoint, "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
	EmitSoundOn("Seafortress.ZonisLightning", caster)

	ApplyDamage({victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function sea_fortress_summon_ability(event)
	local caster = event.caster
	local ability = event.ability
	local loops = 1
	if not caster.summonCount then
		caster.summonCount = 0
	end
	local summoned = false
	for i = 1, loops, 1 do
		if caster.summonCount < caster.maxSummons then
			summoned = true
			local spider = nil
			if caster:GetUnitName() == "seafortress_cavern_summoner" then
				spider = Seafortress:SpawnSummonedArcher(caster:GetAbsOrigin() + RandomVector(RandomInt(100, 260)), caster:GetForwardVector())
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_dustcloud.vpcf", spider, 2)
			elseif caster:GetUnitName() == "seafortress_water_summoner" then
				spider = Seafortress:SpawnSummonedFaceless(caster:GetAbsOrigin() + RandomVector(RandomInt(100, 260)), caster:GetForwardVector())
				local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, spider)
				for j = 0, 4, 1 do
					ParticleManager:SetParticleControl(pfx, j, spider:GetAbsOrigin())
				end
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end
			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 80), spider:GetAbsOrigin(), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
			spider.origCaster = caster
			caster.summonCount = caster.summonCount + 1
			spider:AddAbility("seafortress_enemy_summon"):SetLevel(1)
			StartAnimation(spider, {duration = 0.5, activity = ACT_DOTA_DISABLED, rate = 1.1})
		end
	end
	if summoned then
		if caster:GetUnitName() == "seafortress_cavern_summoner" then
			EmitSoundOn("Seafortress.CavernSummoner.Summon", caster)
		elseif caster:GetUnitName() == "seafortress_water_summoner" then
			StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
			EmitSoundOn("Seafortress.WaterSummoner.Summon", caster)
		end
	end
end

function enemy_summon_start(event)
	local caster = event.caster
	local ability = event.ability

	caster:SetDeathXP(0)
	caster:SetMinimumGoldBounty(0)
	caster:SetMaximumGoldBounty(0)
end

function enemy_summon_die(event)
	local caster = event.caster
	local ability = event.ability
	caster.origCaster.summonCount = caster.origCaster.summonCount - 1
end

function borrowed_time_think(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Seafortress.BorrowedTime", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_creature_borrowed_time", {duration = 4})
end

function sea_rider_attack_land(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = attacker
	local target = event.target

	local position = target:GetAbsOrigin()
	local damage = event.damage
	local endFV = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local range = 1000
	local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin() + endFV * range, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sea_rider_slow", {duration = 2})
		end
	end
	local particleName = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(0, pfx, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(1, pfx, caster:GetAbsOrigin() + endFV * range)

	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("RPCItem.BlueRain", target)

end

function sea_rider_take_damage(event)
	local ability = event.ability
	local caster = event.caster
	if not caster.waves then
		caster.waves = 0
	end
	if caster.waves < 10 then
		local damage = event.damage
		caster.waves = caster.waves + 1
		EmitSoundOn("Tanari.WaterTemple.RareWrathWater", caster)
		local range = 1500
		local start_radius = 320
		local end_radius = 320
		local baseFV = caster:GetForwardVector()
		local speed = 700
		local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
		local fv = RandomVector(1)
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 30),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 6.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
		Timers:CreateTimer(1.5, function()
			caster.waves = caster.waves - 1
		end)
	end

end

function jailer_think(event)
	local ability = event.ability
	local caster = event.caster
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	if #enemies > 0 then
		if enemies[1]:HasModifier("modifier_jumping") then
			return false
		end
		if enemies[1]:GetAbsOrigin().z > (caster:GetAbsOrigin().z + 500) then
			return false
		end
		if WallPhysics:IsWithinRegionA(enemies[1]:GetAbsOrigin(), Vector(14283, -15680), Vector(15488, -9152)) then
			return false
		end
		StartAnimation(caster, {duration = 1.1, activity = ACT_DOTA_ATTACK, rate = 1.4})
		local throwPoint = Seafortress.JailCenterTable[1]
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Seafortress.JailCenterTable[1])
		for i = 2, #Seafortress.JailCenterTable, 1 do
			local distanceCheck = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Seafortress.JailCenterTable[i])
			if distanceCheck < distance then
				distance = distanceCheck
				throwPoint = Seafortress.JailCenterTable[i]
			end
		end
		local target = enemies[1]
		EmitSoundOn("Seafortress.Jailer.Throw", target)
		EmitSoundOn("Seafortress.Jailer.ThrowVO", caster)
		local throwVector = ((throwPoint - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		local propulsion = distance / 75 + 5
		local liftTime = distance / 65 + 10
		target:SetAbsOrigin(caster:GetAbsOrigin() + throwVector * 120)
		caster:MoveToPosition(caster:GetAbsOrigin() + throwVector * 20)
		Timers:CreateTimer(0.2, function()
			target.jumpEnd = "stop_flail"
			if not target:HasModifier("modifier_jumping") then
				WallPhysics:Jump(target, throwVector, propulsion, 30, liftTime, 1)
			end
			ability:ApplyDataDrivenModifier(caster, target, "modifier_wind_temple_flailing", {duration = 4})
			EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Seafortress.Jailer.ThrowHack", caster)
		end)
	else
		if caster.patrolLock then
			return false
		end
		enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 620, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if #enemies == 0 then
			enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		end
		if #enemies > 0 then
			if WallPhysics:IsWithinRegionA(enemies[1]:GetAbsOrigin(), Vector(14283, -15680), Vector(15488, -9152)) then
				return false
			end
			if enemies[1]:GetAbsOrigin().z > (caster:GetAbsOrigin().z + 500) then
				return false
			end
			if enemies[1]:HasModifier("modifier_hook_root") or enemies[1]:HasModifier("modifier_jumping") then
				return false
			end
			StartAnimation(caster, {duration = 1.1, activity = ACT_DOTA_CAST_ABILITY_ROT, rate = 0.9})
			EmitSoundOn("Seafortress.Jailer.DetectVO", caster)
			caster.patrolLock = true
			local target = enemies[1]
			CustomAbilities:QuickAttachParticle("particles/msg_fx/big_excalamation.vpcf", caster, 3)
			local fv = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin() + fv * 20)

			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/oracle_fortune_cast_tgt.vpcf", target, 3)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", target, 3)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_hook_root", {duration = 3.5})
			if enemies[1]:IsHero() then
				Timers:CreateTimer(1.2, function()
					local hookAbility = caster.ability1
					if hookAbility:IsFullyCastable() then
						EmitSoundOn("Seafortress.Jailer.HookVO", caster)
						local targetPoint = target:GetAbsOrigin()
						local order =
						{
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							AbilityIndex = hookAbility:entindex(),
							Position = targetPoint
						}
						ExecuteOrderFromTable(order)
						Timers:CreateTimer(0.5, function()
							caster.patrolLock = false
						end)
						return false
					end
				end)
			else
				target:ForceKill(false)
				Timers:CreateTimer(0.5, function()
					caster.patrolLock = false
				end)
			end
		end
	end
end

function infernal_jailer_think(event)
	local caster = event.caster
	if not caster:IsAlive() then
		return false
	end
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		EmitSoundOn("Seafortress.InfernalJailer.Fire", caster)
		for i = 1, 7, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / 7)
			local start_radius = 120
			local end_radius = 200
			local range = 360
			local speed = 600

			local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

			local info =
			{
				Ability = ability,
				EffectName = projectileParticle,
				vSpawnOrigin = caster:GetAbsOrigin(),
				fDistance = range,
				fStartRadius = start_radius,
				fEndRadius = end_radius,
				Source = caster,
				StartPosition = "attach_origin",
				bHasFrontalCone = true,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = fv * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end
	else
		local distance = WallPhysics:GetDistance2d(caster.startPos, caster:GetAbsOrigin())
		if distance > 1200 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies == 0 then
				Dungeons:DeaggroUnit(caster)
				CustomAbilities:QuickAttachParticle("particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf", caster, 2)
				FindClearSpaceForUnit(caster, caster.startPos, false)
				caster:MoveToPosition(caster:GetAbsOrigin() + Vector(0, -10))
				EmitSoundOn("Seafortress.InfernalJailer.Blink", caster)
				CustomAbilities:QuickAttachParticle("particles/econ/events/ti6/blink_dagger_end_ti6.vpcf", caster, 2)
			end
		end
	end
end

function infernal_jailer_die(event)
	local caster = event.caster
	local ability = event.ability
	local targetPosition = caster.prisonCrateLoc
	EmitSoundOn("Seafortress.Fireball", caster)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, targetPosition, 600, 30, true)
	local fv = (targetPosition - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local projectileParticle = "particles/roshpit/warlord/fire_ulti_linear.vpcf"
	local start_radius = 0
	local end_radius = 0
	local range = WallPhysics:GetDistance2d(caster:GetAbsOrigin() * Vector(1, 1, 0), targetPosition)
	local speed = 1200
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 80),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	Timers:CreateTimer(range / speed, function()
		AddFOWViewer(DOTA_TEAM_GOODGUYS, targetPosition, 800, 10, false)
		EmitSoundOnLocationWithCaster(targetPosition, "Seafortress.RocksExplode", Events.GameMaster)
		local particle = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
		local particlePosition = GetGroundPosition(targetPosition, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, particlePosition)
		ParticleManager:SetParticleControl(pfx, 1, particlePosition)
		ParticleManager:SetParticleControl(pfx, 2, fv)
		Timers:CreateTimer(3.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

		local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_barracks001_melee_destroy.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, targetPosition)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local blockers = Entities:FindAllByNameWithin("JailCrateBlocker", targetPosition, 800)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
		local cage = Entities:FindAllByNameWithin("JailCrate", targetPosition, 800)
		for i = 1, #cage, 1 do
			UTIL_Remove(cage[i])
		end
		if caster.gateIndex == 1 then
			Seafortress:OpenJailGate(Vector(13097, -15095, 12 + Seafortress.ZFLOAT), Vector(14305, -14933, 131), 1, false)
		elseif caster.gateIndex == 2 then
			Seafortress:OpenJailGate(Vector(12711, -13328, 12 + Seafortress.ZFLOAT), Vector(14305, -13272, 131), 2, true)
		elseif caster.gateIndex == 3 then
			Seafortress:OpenJailGate(Vector(12820, -12086, 12 + Seafortress.ZFLOAT), Vector(14305, -12017, 131), 3, true)
		elseif caster.gateIndex == 4 then
			Seafortress:OpenJailGate(Vector(13610, -10806, 12 + Seafortress.ZFLOAT), Vector(14305, -10767, 131), 4, true)
		elseif caster.gateIndex == 5 then
			Seafortress:OpenJailGate(Vector(13094, -8982, 12 + Seafortress.ZFLOAT), Vector(14305, -9512, 131), 5, true)
		end
		for i = 1, 3, 1 do
			local fishPrisoner = CreateUnitByName("seafortress_fish_prisoner", targetPosition + RandomVector(RandomInt(1, 200)), false, nil, nil, DOTA_TEAM_GOODGUYS)
			FindClearSpaceForUnit(fishPrisoner, fishPrisoner:GetAbsOrigin(), false)
			fishPrisoner:SetForwardVector(Vector(-1, 0))
			fishPrisoner:SetRenderColor(0, 200, 255)
			Events:ColorWearables(fishPrisoner, Vector(0, 200, 255))
			Timers:CreateTimer(0.5, function()
				StartAnimation(fishPrisoner, {duration = 2.2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.95})
			end)
			if not Seafortress.FishPrisonerTable then
				Seafortress.FishPrisonerTable = {}
			end
			table.insert(Seafortress.FishPrisonerTable, fishPrisoner)
		end
		Seafortress.CellCompleteTable[caster.gateIndex] = 1
		Seafortress:CheckJailConditions()
	end)
end

function jailer_combat_think(event)
	local caster = event.caster
	local ability = event.ability

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local hookAbility = caster:FindAbilityByName("chef_meat_hook")
		if hookAbility:IsFullyCastable() then
			local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 260))
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = hookAbility:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
end

function jailer_attack_hit(event)
	local target = event.target
	local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Seafortress.JailerAttack.Hit", target)
end

function fish_prisoner_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.state == 0 then
		local targetPosition = Vector(14624, -7337) + WallPhysics:rotateVector(Vector(-1, 0), 2 * math.pi * (caster.index + 5) / 40) * 410
		local distance = WallPhysics:GetDistance2d(targetPosition, caster:GetAbsOrigin())
		if distance < 90 then
			if not Seafortress.PrisonersInPositionCount then
				Seafortress.PrisonersInPositionCount = 0
			end
			if not caster.counted then
				caster.counted = true
				Seafortress.PrisonersInPositionCount = Seafortress.PrisonersInPositionCount + 1
				if Seafortress.PrisonersInPositionCount == 15 then
					Seafortress:PrisonerSequence()
				end
			end
		else
			caster:MoveToPosition(targetPosition)
		end
	elseif caster.state == 1 then
		Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin(), Vector(14624, -7334, 900 + Seafortress.ZFLOAT), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
		EmitSoundOn("Seafortress.ZonisLightning", caster)
		StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.7})
	elseif caster.state == 3 then
		if not caster.freedomPosition then
			local luck = RandomInt(1, 3)
			if luck == 1 then
				caster.freedomPosition = Vector(1408, -13952) + RandomVector(300)
			elseif luck == 2 then
				caster.freedomPosition = Vector(-1088, -13993) + RandomVector(500)
			else
				caster.freedomPosition = Vector(-3027, -15874) + RandomVector(600)
			end
		end
		caster:MoveToPosition(caster.freedomPosition)
		local distance = WallPhysics:GetDistance2d(caster.freedomPosition, caster:GetAbsOrigin())
		if distance < 240 then
			local fish = caster
			fish:Stop()
			caster.state = 4
			EmitSoundOn("SeaFortress.CheepJump", fish)
			local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, fish)
			for j = 0, 4, 1 do
				ParticleManager:SetParticleControl(pfx, j, fish:GetAbsOrigin())
			end
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			StartAnimation(fish, {duration = 1.4, activity = ACT_DOTA_SLARK_POUNCE, rate = 1})
			for j = 1, 20, 1 do
				Timers:CreateTimer(j * 0.03, function()
					fish:SetAbsOrigin(fish:GetAbsOrigin() - Vector(0, 0, 6))
				end)
			end
			Timers:CreateTimer(1, function()
				UTIL_Remove(fish)
			end)
		end
	end
end

function black_portal_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not target:HasModifier("modifier_recently_teleported") then
		target:SetAbsOrigin(caster:GetAbsOrigin())
		ability:ApplyDataDrivenModifier(caster, target, "modifier_recently_teleported", {duration = 4})
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Seafortress.PortalTouch", target)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_black_portal_teleporting_out", {duration = 2})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_damage_immunity", {duration = 3.6})
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Seafortress.PortalShrink", target)
			target:AddNewModifier(target, nil, "modifier_black_portal_shrink", {})
			-- for i = 0, 30, 1 do
			--   Timers:CreateTimer(i*0.03, function()
			--  ProjectileManager:ProjectileDodge(target)
			--     target:SetModelScale(target:GetModelScale() - 0.015)
			--   end)
			-- end
			Timers:CreateTimer(1.5, function()
				Events:LockCameraWithDuration(target, 0.2)
				target:SetAbsOrigin(GetGroundPosition(caster.portToPosition, target))
				target:RemoveModifierByName("modifier_black_portal_teleporting_out")
				ability:ApplyDataDrivenModifier(caster, target, "modifier_black_portal_teleporting_in", {duration = 1.5})
				EmitSoundOn("Seafortress.PortalGrow", target)
				target:RemoveModifierByName("modifier_black_portal_shrink")
				-- for i = 0, 30, 1 do
				-- Timers:CreateTimer(i*0.03, function()
				-- ProjectileManager:ProjectileDodge(target)
				--   target:SetModelScale(target:GetModelScale() + 0.015)

				-- end)
				-- end
				WallPhysics:Jump(target, Vector(1, 0), 0, 30, 32, 1)
			end)
		end)
	end
end

function duelist_ai(caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local hookAbility = caster:FindAbilityByName("sea_fortress_overwhelming_odds")
		if hookAbility:IsFullyCastable() then
			local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(2, 180))
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = hookAbility:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local hookAbility = caster:FindAbilityByName("seafortress_duel")
		if hookAbility:IsFullyCastable() then
			local order = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = enemies[1]:entindex(),
				AbilityIndex = hookAbility:entindex(),
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
end

function rock_breaker_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	if not target:HasModifier("modifier_jumping") and not target:HasModifier("modifier_knockback") then
		local point = attacker:GetAbsOrigin()
		local modifierKnockback =
		{
			center_x = point.x,
			center_y = point.y,
			center_z = point.z,
			duration = 0.7,
			knockback_duration = 0.7,
			knockback_distance = 0,
			knockback_height = 200
		}
		target:AddNewModifier(attacker, nil, "modifier_knockback", modifierKnockback)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function explosive_skin_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.prevPercent then
		caster.prevPercent = 1
	end
	if (caster:GetHealth() / caster:GetMaxHealth()) < caster.prevPercent - event.threshold then
		local soulLoops = (caster.prevPercent - (caster:GetHealth() / caster:GetMaxHealth())) / event.threshold
		caster.prevPercent = caster.prevPercent - event.threshold * soulLoops
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_temple_key_stone_form", {duration = 1.5})

		caster.explosiveStacks = caster:GetModifierStackCount("modifier_wind_temple_key_stone_form", caster) + soulLoops
		caster:SetModifierStackCount("modifier_wind_temple_key_stone_form", caster, caster.explosiveStacks)

	end
end

function stone_form_explode(event)
	local caster = event.caster
	local ability = event.ability
	local stun_duration = event.stun_duration
	local explosion_radius = event.explosion_radius
	local damage = event.damage

	local stacks = caster.explosiveStacks
	local pfx = ParticleManager:CreateParticle("particles/econ/events/ti7/shivas_guard_active_ti7.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(stacks * explosion_radius, 100, stacks * explosion_radius * 3))
	Timers:CreateTimer(0.9, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Timers:CreateTimer(0.2, function()
		StartAnimation(caster, {duration = 1.3, activity = ACT_DOTA_SPAWN, rate = 1.0})
	end)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.IceExplosionSkin", caster)
	EmitSoundOn("Seafortress.Lizard.Aggro", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage * stacks, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end
	end
end

function depth_warper_ai(caster)
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local warpAbility = caster:FindAbilityByName("creature_depth_warp")
			if warpAbility:IsFullyCastable() then
				for i = 0, 20, 1 do
					Timers:CreateTimer(i * 0.09, function()
						--print("GO CAST DELAY")
						if warpAbility:IsFullyCastable() then
							local enemyFV = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
							local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), enemies[1]:GetAbsOrigin())
							local castAngle = WallPhysics:rotateVector(enemyFV, 2 * math.pi * RandomInt(-5, 5) / 50)
							--print(castAngle)
							local magnitude = distance / 20
							local targetPoint = caster:GetAbsOrigin() + (castAngle * RandomInt(28, 40) * magnitude)
							local order =
							{
								UnitIndex = caster:entindex(),
								OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
								AbilityIndex = warpAbility:entindex(),
								Position = targetPoint
							}
							ExecuteOrderFromTable(order)
						end
					end)
				end
			end
		end
		local laser = caster:FindAbilityByName("depth_laser")
		if laser:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local order = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = laser:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function warp_flare_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	caster:RemoveModifierByName("modifier_solunia_flare_flying")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_flare_flying", {duration = 3.0})
	caster:RemoveModifierByName("modifier_solunia_in_between_flare")
	EmitSoundOn("Seafortress.WarpExplosion", caster)
	-- StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.5})
	ability.targetPoint = target
	ability.fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	caster:RemoveModifierByName("modifier_lava_jumping")
	if not ability.bandTable then
		ability.bandTable = {}
	end
	if not ability.flareCount then
		ability.flareCount = 0
	end
	local pfx = nil
	local particleName = "particles/roshpit/solunia/lunar_warp_beam_blade_golden.vpcf"

	pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ability.particle = false
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 80) - ability.fv * 30)
	table.insert(ability.bandTable, pfx)
	ability.currentBand = #ability.bandTable
	EmitSoundOn("Seafortress.WarpFlare", caster)

end

function warp_flare_flying_think(event)
	local caster = event.caster
	local ability = event.ability
	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.fv * 45), caster)
	local forwardSpeed = 80
	if blockUnit then
		forwardSpeed = 0
		end_warp_phase(caster, ability)
		return
	end

	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv * forwardSpeed)
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	local liftVector = Vector(0, 0, 0)
	-- if caster:GetAbsOrigin().z - groundHeight < 300 then
	-- liftVector = Vector(0,0,15)
	-- end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + liftVector)
	if ability.bandTable[ability.currentBand] then
		ParticleManager:SetParticleControl(ability.bandTable[ability.currentBand], 1, caster:GetAbsOrigin() + Vector(0, 0, 80) + ability.fv * 60)
	end
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)
	if distance < 85 then
		if not ability.lock then
			end_warp_phase(caster, ability)
		end
	end
	if distance > 2300 then
		end_warp_phase(caster, ability)
	end
end

function end_warp_phase(caster, ability)
	if not ability.flareCount then
		return false
	end
	ability.flareCount = ability.flareCount + 1
	caster:RemoveModifierByName("modifier_solunia_flare_flying")
	ability.lock = true
	Timers:CreateTimer(0.1, function()
		ability.lock = false
	end)
	ability.betweenFlareRotation = 1
	ability.startRotation = vectorToAngle(ability.fv)
	EmitSoundOn("Seafortress.WarpExplosion", caster)
	local maxFlares = 3
	if ability.flareCount >= maxFlares then

		end_warp_flare(ability, caster)
	else
		ability:EndCooldown()
		local inBetweenTime = 1.2
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_in_between_flare", {duration = inBetweenTime})
	end
end

function inbetween_flare_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.betweenFlareRotation = ability.betweenFlareRotation + 1
	caster:SetAngles(0, ability.betweenFlareRotation * 0.5 + ability.startRotation, 0)
	caster:SetAbsOrigin(caster:GetAbsOrigin() + math.cos(ability.betweenFlareRotation * math.pi / 50) * 1.2)
	-- caster:SetForwardVector(newFV)
	-- Vector(1,0) = 0
	-- Vector(1,1) = 45
	-- Vector(0,1) = 90
	-- Vector(-1,1) = 135
	-- Vector(-1,0) = 180
end

function vectorToAngle(vector)
	return math.atan2(vector.y, vector.x) * 180 / math.pi
end

function inbetween_flare_start(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_solunia_immortal_weapon_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_warp_flare_immortal_weapon_effect", {})
	end
end

function inbetween_flare_end(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.flareCount then
		return false
	end
	caster:RemoveModifierByName("modifier_solunia_warp_flare_immortal_weapon_effect")
	caster:SetAngles(0, 0, 0)
	if not caster:HasModifier("modifier_solunia_flare_flying") then
		end_warp_flare(ability, caster)
	end
end

function end_warp_flare(ability, caster)
	if not caster:HasModifier("modifier_channel_start") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_warp_flare_falling", {duration = 4})
	end
	ability.fallVelocity = 3
	--print(ability.flareCount)
	EmitSoundOn("Seafortress.WarpExplosion", caster)
	local maxFlares = 3

	ability.flareCount = false
	Timers:CreateTimer(0.4, function()
		for i = 1, #ability.bandTable, 1 do
			ParticleManager:DestroyParticle(ability.bandTable[i], false)
			ParticleManager:ReleaseParticleIndex(ability.bandTable[i])
		end
		ability.bandTable = {}
	end)

end

function after_flare_falling(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_solunia_warp_flare_falling")
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_SPAWN, rate = 1.8})

end

function zot_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	EmitSoundOn("Seafortress.Zot.Attack", target)
	local particleName = "particles/roshpit/voltex/overcharge_lightning_attack.vpcf"
	local radius = 1000
	local damage = event.damage
	local shock_limit = 30
	local particleLimit = 10
	if not ability.particleCount then
		ability.particleCount = 0
	end
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attacker:GetAbsOrigin().x, attacker:GetAbsOrigin().y, attacker:GetAbsOrigin().z + attacker:GetBoundingMaxs().z))
	ParticleManager:SetParticleControl(lightningBolt, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z))
	ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(lightningBolt, true)
	end)
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin() + caster:GetForwardVector() * (radius - 100), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local targets_shocked = 1
	for _, unit in pairs(enemies) do
		if targets_shocked >= shock_limit then
			break
		end
		-- Particle
		local origin = unit:GetAbsOrigin()
		if ability.particleCount < particleLimit then
			ability.particleCount = ability.particleCount + 1
			local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
			ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attacker:GetAbsOrigin().x, attacker:GetAbsOrigin().y, attacker:GetAbsOrigin().z + 100))
			ParticleManager:SetParticleControl(lightningBolt, 1, Vector(origin.x, origin.y, origin.z + unit:GetBoundingMaxs().z))
			Timers:CreateTimer(2, function()
				ability.particleCount = ability.particleCount - 1
				ParticleManager:DestroyParticle(lightningBolt, true)
			end)
		end

		-- Damage
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})

		-- Increment counter
		targets_shocked = targets_shocked + 1
	end
end

function zot_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if caster.zapCode == 1 then
		-- EmitSoundOnLocationWithCaster(Vector(7040, 1088), "Seafortress.ZonisLightning", caster)
		local leftZap = Vector(6642, 1193, 276 + Seafortress.ZFLOAT)
		local rightZap = Vector(7430, 1193, 276 + Seafortress.ZFLOAT)
		Events:CreateLightningBeam(leftZap, rightZap)
		local leftZap = Vector(6642, 1193, 460 + Seafortress.ZFLOAT)
		local rightZap = Vector(7430, 1193, 460 + Seafortress.ZFLOAT)
		Events:CreateLightningBeam(leftZap, rightZap)
	elseif caster.zapCode == 2 then
		local leftZap = Vector(8165, 1546, 276 + Seafortress.ZFLOAT)
		local rightZap = Vector(8988, 1546, 276 + Seafortress.ZFLOAT)
		Events:CreateLightningBeam(leftZap, rightZap)
		local leftZap = Vector(8165, 1546, 460 + Seafortress.ZFLOAT)
		local rightZap = Vector(8988, 1546, 460 + Seafortress.ZFLOAT)
		Events:CreateLightningBeam(leftZap, rightZap)
	elseif caster.zapCode == 3 then
		local leftZap = Vector(10490, 904, 276 + Seafortress.ZFLOAT)
		local rightZap = Vector(11520, 904, 276 + Seafortress.ZFLOAT)
		Events:CreateLightningBeam(leftZap, rightZap)
		local leftZap = Vector(10490, 904, 460 + Seafortress.ZFLOAT)
		local rightZap = Vector(11520, 904, 460 + Seafortress.ZFLOAT)
		Events:CreateLightningBeam(leftZap, rightZap)
	end
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("seafortress_plasma_field")
			if hookAbility:IsFullyCastable() then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hookAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function zot_die(event)
	local caster = event.caster
	local ability = event.ability
	if caster.zapCode == 1 then
		Seafortress:RemoveBlockers(0, "ElectroBlocker", Vector(6994, 1163), 1800)
		Seafortress.ZapBlocker1 = true
		Seafortress:SpawnDeepRoom2()
	elseif caster.zapCode == 2 then
		Seafortress:RemoveBlockers(0, "ElectroBlocker", Vector(8510, 1555), 1800)
		Seafortress.ZapBlocker2 = true
		Seafortress:SpawnDeepRoom3()
	elseif caster.zapCode == 3 then
		Seafortress:RemoveBlockers(0, "ElectroBlocker", Vector(10520, 876), 1800)
		Seafortress.ZapBlocker3 = true
		Seafortress:SpawnDeepRoom4()
	end
end

function dark_sunder_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local damage = event.damage
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_sunder_charges", {duration = 7})
	local newStacks = target:GetModifierStackCount("modifier_dark_sunder_charges", caster) + 1
	target:SetModifierStackCount("modifier_dark_sunder_charges", caster, newStacks)
	if newStacks >= 5 then
		CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_hunter.vpcf", target, 3)
		target:RemoveModifierByName("modifier_dark_sunder_charges")
		EmitSoundOn("Seafortress.DarkSunder.Pop", target)
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		ScreenShake(target:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
	end
end

function goo_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, target, "modifier_seafortress_ink_goo", {duration = 4.5})
	local newStacks = target:GetModifierStackCount("modifier_seafortress_ink_goo", caster) + 1
	target:SetModifierStackCount("modifier_seafortress_ink_goo", caster, newStacks)
end

function sea_maiden_terror_start(event)
	local caster = event.caster
	local ability = event.ability

	EmitSoundOn("Seafortress.SeaMaiden.Terror", caster)
	local point = event.target_points[1]
	local fv = ((point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	for i = -1, 1, 1 do
		local range = 1500

		local speed = 2000
		local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * i / 20)

		local startPoint = caster:GetAbsOrigin()
		ability.castPosition = startPoint
		local particle = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf"
		local start_radius = 200
		local end_radius = 200

		-- EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)

		local casterOrigin = caster:GetAbsOrigin()

		local info =
		{
			Ability = ability,
			EffectName = particle,
			vSpawnOrigin = startPoint + Vector(0, 0, 50),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = rotatedFV * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function sea_maiden_take_damage(event)
	local caster = event.caster
	local ability = event.ability

	if not ability.waves then
		ability.waves = 0
	end
	if ability.waves < 12 then
		ability.waves = ability.waves + 1
		local start_radius = 400
		local end_radius = 400
		local range = 1500
		local speed = 550
		local fv = RandomVector(1)
		EmitSoundOn("WaterTemple.Gush", caster)

		local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)

		Timers:CreateTimer(2, function()
			ability.waves = ability.waves - 1
		end)
	end

end

function stun_regen_thinker_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:IsStunned() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_stun_regen_applied", {duration = 2})
	else
		caster:RemoveModifierByName("modifier_stun_regen_applied")
	end
end

function heart_spike_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:IsHero() then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash_flash.vpcf", target, 3)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_in_hydrogen_field", {duration = 0.2})
		ApplyDamage({victim = target, attacker = caster, damage = 1, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	end
end

function fairy_dragon_ai(caster)
	if not caster.prevPercent then
		caster.prevPercent = 1
	end
	if (caster:GetHealth() / caster:GetMaxHealth()) < caster.prevPercent - 0.05 then
		caster.prevPercent = caster.prevPercent - 0.05
		local phaseAbility = caster:FindAbilityByName("puck_phase_shift")
		if phaseAbility:IsFullyCastable() then
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = phaseAbility:entindex(),
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
	if caster.aggro then
		local enemies1 = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		if #enemies1 > 0 then
			local popAbility = caster:FindAbilityByName("seafortress_waning_rift")
			if popAbility:IsFullyCastable() then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = popAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("puck_illusory_orb")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(0, 140))
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				local randomDelay = RandomInt(50, 300) / 100
				Timers:CreateTimer(randomDelay, function()
					local jauntAbility = caster:FindAbilityByName("puck_ethereal_jaunt")
					if jauntAbility:IsFullyCastable() then
						local order =
						{
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
							AbilityIndex = jauntAbility:entindex(),
						}
						ExecuteOrderFromTable(order)
					else
						return 0.1
					end
				end)
				return false
			end
		end
	end
end

function burning_spear_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, target, "modifier_burning_spear_effect", {duration = 7})
	local newStacks = target:GetModifierStackCount("modifier_burning_spear_effect", caster) + 1
	target:SetModifierStackCount("modifier_burning_spear_effect", caster, newStacks)
end

function solos_spear_burn(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	ApplyDamage({victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function temple_assassin_think(event)
	local caster = event.caster
	if caster.aggro and caster:IsAlive() then
		local ability = event.ability
		ability:StartCooldown(6)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_start.vpcf", caster, 3)
			local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local target = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(160, 350))
			local targetPos = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
			FindClearSpaceForUnit(caster, targetPos, false)
			ProjectileManager:ProjectileDodge(caster)
			CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_end.vpcf", caster, 3)
			StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_SPAWN, rate = 1.4})
			EmitSoundOn("Seafortress.TempleAssassin.Teleport", caster)
		end
	end
end

function heavy_boulder_toss_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability.pushVector = false
	ability.pushVelocity = 44
	ability.tossPosition = caster:GetAbsOrigin()
	target.pushVector = false
end

function heavy_boulder_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.pushVector then
		local impactPoint = target:GetAbsOrigin()
		local pushVector = ((impactPoint - ability.tossPosition) * Vector(1, 1, 0)):Normalized()
		target.pushVector = pushVector
		if ability.pushVelocity == -1 then
			target.pushVelocity = (3000 - WallPhysics:GetDistance2d(impactPoint, ability.tossPosition)) / 400
			target.pushVelocity = math.max(target.pushVelocity, 8)
			target.pushVelocity = math.min(target.pushVelocity, 100)
		else
			target.pushVelocity = ability.pushVelocity
		end
		EmitSoundOn("Redfall.StoneAttack", target)
	end
	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin() + target.pushVector * target.pushVelocity * 1.5, target)
	local fv = target.pushVector
	if blockUnit then
		fv = 0
	end
	local newPos = GetGroundPosition(target:GetAbsOrigin() + fv * target.pushVelocity, target)
	if target:GetAbsOrigin().z > GetGroundHeight(target:GetAbsOrigin(), target) + 10 then
		newPos = target:GetAbsOrigin() + fv * target.pushVelocity, target
	end
	target:SetAbsOrigin(newPos)
	target.pushVelocity = target.pushVelocity - 1
end

function desolator_spawn(event)
	local caster = event.caster
	local ability = event.ability
	caster.refractionItem = ability
	caster.refractionItem:ApplyDataDrivenModifier(caster, caster, "modifier_secret_temple_refraction", {})
	caster:SetModifierStackCount("modifier_secret_temple_refraction", caster.refractionItem, 30)
	caster.refractionItem:ApplyDataDrivenModifier(caster, caster, "modifier_secret_temple_refraction_damage", {})
end

function templar_desolator_think(event)
	local caster = event.caster
	if caster.aggro then
		caster:RemoveModifierByName("modifier_animation_translate")
	else
		caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "meld"})
	end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		if caster:HasModifier("modifier_templar_assassin_meld") then
			caster:MoveToTargetToAttack(enemies[1])
		else
			local hookAbility = caster:FindAbilityByName("seafortress_meld")
			if hookAbility:IsFullyCastable() then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hookAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function chitinous_skin_think(event)
	local caster = event.caster
	local target = caster
	local ability = event.ability
	if ability then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_chitinous_skin_stacks", {})
		local newStacks = math.min(target:GetModifierStackCount("modifier_chitinous_skin_stacks", caster) + 1, 20)
		target:SetModifierStackCount("modifier_chitinous_skin_stacks", caster, newStacks)
	end
end

function chitinous_skin_take_damage(event)
	local caster = event.caster
	local target = caster
	local ability = event.ability

	local newStacks = target:GetModifierStackCount("modifier_chitinous_skin_stacks", caster) - 1
	if newStacks > 0 then
		target:SetModifierStackCount("modifier_chitinous_skin_stacks", caster, newStacks)
	else
		caster:RemoveModifierByName("modifier_chitinous_skin_stacks")
	end
end

function begin_lightning_dash(event)
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
	ability.point = event.target_points[1] + caster:GetForwardVector() * 300
	ability.moveDirection = (ability.point - caster:GetAbsOrigin()):Normalized()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_dash", {duration = 3})
	EmitSoundOn("Seafortress.DiscipleOfPoseidon.Dash", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.DiscipleOfPoseidon.DashStart", Events.GameMaster)
	local particleName = "particles/roshpit/voltex/lightning_dash_trail.vpcf"
	local pfx = 0
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())

	ability.pfx = pfx

	ability.interval = 0
	if not ability.particles then
		ability.particles = 0
	end
end

function dash_think(event)
	local caster = event.caster
	local ability = event.ability

	ability.moveDirection = (ability.point - caster:GetAbsOrigin()):Normalized()

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.moveDirection * 35), caster)

	local forwardSpeed = 100
	if blockUnit then
		forwardSpeed = 0
		caster:RemoveModifierByName("modifier_lightning_dash")
	end
	local newPosition = caster:GetAbsOrigin() + ability.moveDirection * forwardSpeed
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 70) + Vector(0, 0, GetGroundHeight(newPosition, caster)))
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < forwardSpeed * 1.5 then
		caster:RemoveModifierByName("modifier_lightning_dash")
	end
	ability.interval = ability.interval + 1
	-- if ability.pfx then
	-- local pfx = ability.pfx
	-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())
	-- end
end

function dash_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration = 0.2, activity = ACT_DOTA_MK_TREE_END, rate = 1.5})
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		Timers:CreateTimer(0.29, function()
			EndAnimation(caster)
			caster:AddNewModifier(caster, nil, "modifier_animation", {translate = "attack_normal_range"})
			caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "run"})

		end)
	end)
	ParticleManager:DestroyParticle(ability.pfx, false)
	ability.pfx = false

end

function starfall_aura_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_mirana/mirana_loadout.vpcf", target, 3.5)
	local damage = event.damage
	Timers:CreateTimer(0.45, function()
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		EmitSoundOn("Seafortress.SeaProphet.StarfallImpact", target)
	end)
end

function create_sea_prophet_whirlpool(event)
	local caster = event.caster
	local target = event.target_points[1]
	Events:CreateLightningBeamWithParticle(caster:GetAttachmentOrigin(3), target, "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/prophet_rootrings.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, target)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.ZonisLightning", caster)

	Timers:CreateTimer(0.9, function()
		Timers:CreateTimer(0.15, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local unit = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())
		unit:AddAbility("seafortress_subwhirlpool_ability"):SetLevel(1)
		unit:FindAbilityByName("dummy_unit"):SetLevel(1)
		unit.pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/prophet_rootportrait.vpcf", PATTACH_CUSTOMORIGIN, unit)
		ParticleManager:SetParticleControl(unit.pfx, 0, unit:GetAbsOrigin() + Vector(0, 0, 30))
		EmitSoundOnLocationWithCaster(target, "Seafortress.SeaProphet.WhirlpoolPosition", caster)
		Timers:CreateTimer(12, function()
			ParticleManager:DestroyParticle(unit.pfx, false)
			UTIL_Remove(unit)
		end)
	end)
end

function in_whirlpool_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target.pushLock or target.jumpLock then
		return false
	end
	if IsValidEntity(caster) then
	else
		return false
	end
	local baseFV = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local rotatedFV = WallPhysics:rotateVector(baseFV, 2 * math.pi / 90)
	local baseDistance = math.min(WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin()), 500)
	local distanceMult = 0.98
	if baseDistance < 150 then
		distanceMult = 1.02
	end
	if baseDistance > 400 then
		return false
	end
	local newPos = caster:GetAbsOrigin() + rotatedFV * baseDistance * distanceMult
	local push = true
	local blockSearch = target:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(target:GetAbsOrigin(), target))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPos), target)
	if blockUnit then
		push = false
	end
	if push then
		target:SetAbsOrigin(newPos)
	end
end

function whirlpool_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end)
end

function sea_prophet_die(caster)
	local index = caster.index
	Timers:CreateTimer(2, function()
		local position = Vector(-5348, -3718)
		local fv = Vector(0, -1)
		if index == 2 then
			position = Vector(-4200, -4782)
			fv = Vector(0, 1)
		elseif index == 3 then
			position = Vector(-3072, -3718)
		end
		local newProphet = CreateUnitByName("seafortress_sea_prophet", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
		local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, newProphet:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
		ParticleManager:SetParticleControl(pfx, 2, Vector(0.5, 0.5, 0.5))
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
		ScreenShake(newProphet:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
		EmitSoundOnLocationWithCaster(newProphet:GetAbsOrigin(), "Seafortress.SeaProphet.FriendlySpawn", Events.GameMaster)
		newProphet:SetForwardVector(fv)
		newProphet:RemoveModifierByName("modifier_use_ability_1_position_ai")
		newProphet:RemoveModifierByName("modifier_creature_starfall_aura")
		local passiveAbility = newProphet:FindAbilityByName("seafortress_sea_prophet_passive")
		passiveAbility:ApplyDataDrivenModifier(newProphet, newProphet, "modifier_sea_prophet_summoner_form", {})
		newProphet:RemoveAbility("use_ability_1_position_ai")
		Timers:CreateTimer(0.1, function()
			StartAnimation(newProphet, {duration = 1.9, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.0})
		end)
		Timers:CreateTimer(1.7, function()
			EmitSoundOn("Seafortress.SeaProphet.RespawnVO", newProphet)
		end)
		if not Seafortress.SeaProphetTable then
			Seafortress.SeaProphetTable = {}
		end
		newProphet.jumpLock = true
		newProphet.pushLock = true
		table.insert(Seafortress.SeaProphetTable, newProphet)
		newProphet.index = index
		-- if #Seafortress.SeaProphetTable == 3 then
		-- Seafortress:ActivateSwitchGeneric(Vector(-4187, -4260, 122+Seafortress.ZFLOAT), "CastleSwitch3", false, 0.377)
		-- end
	end)
end

function rain_wave_unit_die(caster)
	if not Seafortress.RainWaveUnitsSlain then
		Seafortress.RainWaveUnitsSlain = 0
	end
	Seafortress.RainWaveUnitsSlain = Seafortress.RainWaveUnitsSlain + 1

	local portalPosition1 = Vector(-5376, -5056, 370 + Seafortress.ZFLOAT)
	local portalPosition2 = Vector(-4203, -3549, 370 + Seafortress.ZFLOAT)
	local portalPosition3 = Vector(-3008, -5056, 370 + Seafortress.ZFLOAT)

	if Seafortress.RainWaveUnitsSlain == 21 then
		Seafortress:SpawnFloodWaveUnit("water_temple_stone_priestess", portalPosition1, 10, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("water_temple_faceless_water_elemental", portalPosition2, 8, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("water_temple_stone_priestess", portalPosition3, 10, 0.8, true)
		prophetAnimations()
	elseif Seafortress.RainWaveUnitsSlain == 45 then
		Seafortress:SpawnFloodWaveUnit("seafortress_soul_splicer", portalPosition1, 10, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("seafortress_soul_splicer", portalPosition2, 10, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("water_temple_stone_priestess", portalPosition3, 8, 0.8, true)
		prophetAnimations()
	elseif Seafortress.RainWaveUnitsSlain == 73 then
		Seafortress:SpawnFloodWaveUnit("seafortress_disciple_of_poseidon", portalPosition1, 8, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("seafortress_soul_splicer", portalPosition2, 8, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("water_temple_vault_lord_two", portalPosition3, 8, 0.8, true)
		prophetAnimations()
	elseif Seafortress.RainWaveUnitsSlain == 97 then
		Seafortress:SpawnFloodWaveUnit("arena_conquest_temple_shifter", portalPosition1, 12, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("arena_conquest_temple_shifter", portalPosition2, 12, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("arena_conquest_temple_shifter", portalPosition3, 12, 0.8, true)
		prophetAnimations()
	elseif Seafortress.RainWaveUnitsSlain == 132 then
		Seafortress:SpawnFloodWaveUnit("seafortress_disciple_of_poseidon", portalPosition1, 8, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("arena_conquest_temple_shifter", portalPosition2, 14, 0.8, true)
		Seafortress:SpawnFloodWaveUnit("water_temple_faceless_water_elemental", portalPosition3, 8, 0.8, true)
		prophetAnimations()
	elseif Seafortress.RainWaveUnitsSlain == 162 then
		Seafortress:EndRainSequence()
	end
end

function prophetAnimations()
	local portalPosition1 = Vector(-5376, -5056, 370 + Seafortress.ZFLOAT)
	local portalPosition2 = Vector(-4203, -3549, 370 + Seafortress.ZFLOAT)
	local portalPosition3 = Vector(-3008, -5056, 370 + Seafortress.ZFLOAT)
	for i = 1, #Seafortress.SeaProphetTable, 1 do
		local prophet = Seafortress.SeaProphetTable[i]
		local portalPosition = false
		if prophet.index == 1 then
			portalPosition = portalPosition1
		elseif prophet.index == 2 then
			portalPosition = portalPosition2
		elseif prophet.index == 3 then
			portalPosition = portalPosition3
		end
		StartAnimation(prophet, {duration = 3, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.8})
		Timers:CreateTimer(1.2, function()
			EmitSoundOn("Seafortress.SeaProphet.RainWaveStartVO", prophet)
		end)
		ScreenShake(prophet:GetAbsOrigin(), 600, 0.8, 0.8, 600, 0, true)
		Events:CreateLightningBeamWithParticle(prophet:GetAttachmentOrigin(3), portalPosition, "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
	end
end

function dragoon_poison_nova(event)
	local caster = event.caster
	local ability = event.ability

	local radius = RandomInt(500, 900)

	radius = radius + 40
	EmitSoundOn("Seafortress.Dragoon.PoisonNova", caster)
	local particleName = "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local origin = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin)
	ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1.7, radius))
	ParticleManager:SetParticleControl(particle1, 2, Vector(0, 0, 0))
	-- ParticleManager:SetParticleControl( particle1, 3, Vector(radius,radius,radius) )
	-- ParticleManager:SetParticleControl( particle1, 4, Vector(radius,radius,radius) )
	-- ParticleManager:SetParticleControl( particle1, 5, Vector(radius,radius,radius) )
	-- ParticleManager:SetParticleControl( particle1, 6, Vector(radius,radius,radius) )
	-- ParticleManager:SetParticleControl( particle1, 7, Vector(radius,radius,radius))
	-- ParticleManager:SetParticleControl( particle1, 8, Vector(radius,radius,radius))
	-- ParticleManager:SetParticleControl( particle1, 9, Vector(radius,radius,radius) )
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	local location = caster:GetAbsOrigin()
	for i = 1, 4, 1 do
		Timers:CreateTimer(0.45 * i, function()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius / (5 - i), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_dragoon_poison_nova", {duration = 6})
				end
			end
		end)
	end
end

function guillotine_strike_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", target, 3)
	local damage = target:GetHealth() * 0.8
	-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_axe/axe_culling_blade_hit_sparks.vpcf", target, 1)
	EmitSoundOn("Seafortress.GuillotineStrike.Blood", target)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end

function blood_drinker_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	if #enemies > 0 then
		local stacks = 0
		for i = 1, #enemies, 1 do
			local percentage = 1 - (enemies[i]:GetHealth() / enemies[i]:GetMaxHealth())
			stacks = stacks + math.floor(percentage * 100)
		end
		if stacks > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_blood_drinker_effect", {})
			caster:SetModifierStackCount("modifier_blood_drinker_effect", caster, stacks)
		else
			caster:RemoveModifierByName("modifier_blood_drinker_effect")
		end
	else
		caster:RemoveModifierByName("modifier_blood_drinker_effect")
	end

end

function start_thunder_quake(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	local nukePosition = point
	Events:CreateLightningBeam(nukePosition, nukePosition + Vector(0, 0, RandomInt(1600, 2000)))
	EmitSoundOnLocationWithCaster(nukePosition, "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
	Timers:CreateTimer(1.0, function()
		EmitSoundOnLocationWithCaster(nukePosition, "Seafortress.ThunderQuake", Events.GameMaster)
		local damage = event.quakeDamage

		local radius = 240
		local position = nukePosition
		local stun_duration = 1.0
		local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
				Filters:ApplyStun(caster, stun_duration, enemy)
			end
		end
		Timers:CreateTimer(3.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
end

function poseidon_zealot_ai(caster)
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("monkey_king_boundless_strike")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(0, 180))
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function zealot_die(caster)
	CustomAbilities:QuickAttachParticle("particles/dire_fx/tower_bad_face_end_sparks.vpcf", caster, 5)
	Seafortress:MiddleObjective()
	local wallL = Entities:FindByNameNearest("BigSeaDoorLeft", Vector(-4928, -1024), 900)
	local wallR = Entities:FindByNameNearest("BigSeaDoorRight", Vector(-4224, -1024), 900)
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(wallL:GetAbsOrigin(), "Seafortress.WallOpen", Events.GameMaster)
		EmitSoundOnLocationWithCaster(wallR:GetAbsOrigin(), "Seafortress.WallOpen", Events.GameMaster)
	end)
	Seafortress.TempleEnergyState = 0
	local radiusCounter = 0
	for i = 1, 180, 1 do
		Timers:CreateTimer(i * 0.03, function()
			wallL:SetAbsOrigin(wallL:GetAbsOrigin() + Vector(-4.25, 0, 0))
			wallR:SetAbsOrigin(wallR:GetAbsOrigin() + Vector(4.25, 0, 0))
			if i % 30 == 0 then
				ScreenShake(wallL:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
				ScreenShake(wallR:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
				local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, wallL:GetAbsOrigin() + Vector(0, 0, 320))
				ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
				local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx2, 0, wallR:GetAbsOrigin() + Vector(0, 0, 320))
				ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
					ParticleManager:DestroyParticle(pfx2, false)
					ParticleManager:ReleaseParticleIndex(pfx2)
				end)
				radiusCounter = radiusCounter + 1
				Seafortress:RemoveBlockers(0, "SeaBlocker10", Vector(-4600, -1024), 256 * radiusCounter)
				if i < 130 then
					EmitSoundOnLocationWithCaster(wallL:GetAbsOrigin(), "Seafortress.WallOpen", Events.GameMaster)
					EmitSoundOnLocationWithCaster(wallR:GetAbsOrigin(), "Seafortress.WallOpen", Events.GameMaster)
				end
			end
		end)
	end
	Seafortress:AfterZealotRoom()

	local darkSwitch = Vector(67, 131, 101)
	local lightSwitch = Vector(199, 192, 75)
	local switch = Entities:FindByNameNearest("BeamButton", Vector(-6242, -256), 800)
	Seafortress:smoothColorTransition(switch, darkSwitch, lightSwitch, 30)
	EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Seafortress.ButtonGlow", Seafortress.Master)
end

function sapphire_dragon_attack_start(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if not ability.lock then
		ability.lock = true
		for i = 1, 6, 1 do
			Timers:CreateTimer(i * 0.1 + 0.1, function()
				Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
				if i == 6 then ability.lock = false end
			end)
		end
		Timers:CreateTimer(0.7, function()
			local luck = RandomInt(1, 2)
			if luck == 1 then
				EmitSoundOn("Seafortress.DragonSpawn.Attack", attacker)
			end
		end)
	end
end

function ice_shell(event)
	local caster = event.caster
	local ability = event.ability
	Filters:CastSkillArguments(1, caster)
	local luck = RandomInt(3, 5)
	EmitSoundOn("Seafortress.IceShell", caster)
	StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_ice_shell", {duration = duration})
	caster:SetModifierStackCount("modifier_warlord_ice_shell", caster, event.stacks)
	CustomAbilities:QuickAttachParticle("particles/roshpit/warlord/ice_shell_activate.vpcf", caster, 3)

end

function dragon_warrior_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.fv then
		caster.fv = Vector(1, 0)
		caster.interval = 0
	end
	caster.fv = WallPhysics:rotateVector(caster.fv, 2 * math.pi / 16)
	local origin = caster:GetAbsOrigin()

	local start_radius = 120
	local end_radius = 200
	local range = 540
	local speed = 700
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 200 then
		local info =
		{
			Ability = ability,
			EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
			vSpawnOrigin = origin,
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = caster.fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end

	if caster:GetHealth() < caster:GetMaxHealth() * 0.5 then
		if not caster.summonedDragons then
			caster.summonedDragons = true
			StartAnimation(caster, {duration = 1.2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
			EmitSoundOn("Seafortress.SeaDragonWarrior.SummonVO", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {duration = 4.5})
			for i = 1, 3, 1 do
				Timers:CreateTimer(i, function()
					local dragon = Seafortress:SpawnSapphireDragon(caster:GetAbsOrigin() + RandomVector(340), RandomVector(1))
					dragon:SetAbsOrigin(dragon:GetAbsOrigin() + Vector(0, 0, 1000))
					WallPhysics:Jump(dragon, Vector(1, 0), 0, 2, 5, 1.6)
					Timers:CreateTimer(1.6, function()
						if not dragon.aggro then
							Dungeons:AggroUnit(dragon)
						end
					end)
				end)
			end
		end
	end
end

function dragonwarrior_die(caster)
	EmitSoundOn("Seafortress.SeaDragonWarrior.DeathVO", caster)
	local wall = Entities:FindByNameNearest("SeaDoor11", Vector(-836, 200, -16 + Seafortress.ZFLOAT), 700)
	Seafortress:Walls(false, {wall}, true, 4)
	Seafortress:RemoveBlockers(4, "SeaBlocker11", Vector(-832, 128), 1400)
	Seafortress:MiddleObjective()
	Seafortress:AfterDragonRoom()
end

function dark_spirit_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_dark_spirit_prepare")

	local position = caster:GetAbsOrigin()
	local particle = "particles/units/heroes/hero_warlock/charge_of_light.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
	FindClearSpaceForUnit(caster, position, false)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, position)
	ParticleManager:SetParticleControl(pfx, 2, caster:GetForwardVector())
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Seafortress.DarkSpirit.SplitStart", caster)
	local fv = caster:GetForwardVector()
	for i = 1, 7, 1 do
		local spawnPoint = caster:GetAbsOrigin() + WallPhysics:rotateVector(fv, 2 * math.pi * i / 7) * 300
		local spirit = Seafortress:SpawnDarkSpirit(spawnPoint, fv, false)
		StartAnimation(spirit, {duration = 1.5, activity = ACT_DOTA_SPAWN, rate = 0.9})
		Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, spirit, "modifier_seafortress_rooted", {duration = 1.5})
		spirit.cantAggro = true
		Timers:CreateTimer(1.5, function()
			spirit.cantAggro = false
			Dungeons:AggroUnit(spirit)
		end)
		spirit.deathCode = 17
	end
	Timers:CreateTimer(1, function()
		EmitSoundOn("Seafortress.DarkSpirit.SplitEnd", caster)
	end)
end

function dark_spirit_die(caster)
	if not Seafortress.DarkSpiritsSlain then
		Seafortress.DarkSpiritsSlain = 0
	end
	EmitSoundOn("Seafortress.DarkSpirit.Die", caster)
	Seafortress.DarkSpiritsSlain = Seafortress.DarkSpiritsSlain + 1
	if Seafortress.DarkSpiritsSlain == 8 then
		local wall = Entities:FindByNameNearest("SeaDoor6", Vector(14857, 2854, -265 + Seafortress.ZFLOAT), 900)
		Seafortress:Walls(false, {wall}, true, 6)
		Seafortress:RemoveBlockers(4, "SeaBlocker6", Vector(14784, 2880), 800)
		Seafortress:FirstPirateRoom()
	end
	local luck = RandomInt(1, 30)
	if luck == 1 then
		RPCItems:RollDepthDemonClaw(caster:GetAbsOrigin())
	end
end

function zombie_mine_attacked(event)
	local attacker = event.attacker
	local caster = event.caster
	if not caster.attacksTaken then
		caster.attacksTaken = 0
	end
	if caster.lock then
		return
	end
	caster.attacksTaken = caster.attacksTaken + 1
	if caster.attacksTaken == 3 then
		caster.lock = true
		local position = caster:GetAbsOrigin()
		local gravePos = caster.gravePos
		local zombie = CreateUnitByName("seafortress_wandering_ghost", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
		WallPhysics:Jump(zombie, Vector(1, 0), 0, 10, 20, 1)
		zombie.jumpEnd = "basic_dust"
		Seafortress:smoothSizeChange(zombie, 0.2, 1.02, 35)
		Timers:CreateTimer(0.6, function()
			StartAnimation(zombie, {duration = 2.6, activity = ACT_DOTA_SPAWN, rate = 1.0})
			Timers:CreateTimer(0.1, function()
				EmitSoundOn("Seafortress.PirateZombieGhost.Spawn", zombie)
			end)
		end)
		EmitSoundOn("Seafortress.PirateZombieGhost.MineBreak", caster)
		zombie.gravePos = gravePos
		local mineAbility = zombie:FindAbilityByName("seafortress_zombie_mine_ability")
		mineAbility:ApplyDataDrivenModifier(zombie, zombie, "modifier_ghost_zombie", {})
		zombie.state = 0
		Timers:CreateTimer(3.0, function()
			zombie.state = 1
		end)
		local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		UTIL_Remove(caster)
	end
end

function ghost_zombie_think(event)
	local caster = event.caster

	if caster.state == 1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		if #enemies > 0 then
			caster:Stop()
		else
			caster:MoveToPosition(caster.gravePos + Vector(0, -160, 0))
		end
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.gravePos + Vector(0, -240, 0))
		if distance < 90 then
			caster.state = 2
		end
	elseif caster.state == 2 then

		caster:MoveToPosition(caster.gravePos + Vector(0, -230, 0))
		caster.state = 3
	elseif caster.state == 3 then
		if Seafortress.PirateGravesUp then
			caster.state = 4
			StartAnimation(caster, {duration = 2.2, activity = ACT_DOTA_SPAWN, rate = 0.5})
			Timers:CreateTimer(0.1, function()
				EmitSoundOn("Seafortress.PirateZombieGhost.Spawn", caster)
			end)
			local moveVector = (caster.gravePos - caster:GetAbsOrigin()) * Vector(1, 1, 0)
			moveVector = moveVector / 27
			for i = 1, 27, 1 do
				Timers:CreateTimer(i * 0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() - (moveVector - Vector(0, 0, 3)))
				end)
			end
			Timers:CreateTimer(1.35, function()
				local newMoveVector = (caster.gravePos - caster:GetAbsOrigin()) * Vector(1, 1, 0)
				newMoveVector = newMoveVector / 13
				for i = 1, 13, 1 do
					Timers:CreateTimer(i * 0.03, function()
						caster:SetAbsOrigin(caster:GetAbsOrigin() + newMoveVector)
					end)
				end
			end)
			Timers:CreateTimer(1.8, function()
				AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 15, false)
				local graveColor = Vector(76, 146, 208)
				local graveStartColor = Vector(77, 100, 76)
				local grave = Entities:FindByNameNearest("PirateGrave", caster:GetAbsOrigin(), 550)
				CustomAbilities:QuickParticleAtPoint("particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf", grave:GetAbsOrigin() + Vector(0, 0, 60), 3)
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.PirateZombieGhost.GraveLit", Events.GameMaster)
				UTIL_Remove(caster)
				Seafortress:smoothColorTransition(grave, graveStartColor, graveColor, 60)

				Timers:CreateTimer(1.8, function()
					if not Seafortress.GravesLit then
						Seafortress.GravesLit = 0
					end
					Seafortress.GravesLit = Seafortress.GravesLit + 1
					if Seafortress.GravesLit == 4 then
						Seafortress:all_graves_lit()
					end
				end)
			end)
		end
	end
end

function colossus_die(caster)
	EmitSoundOn("Seafortress.Barnacle.Aggro", caster)
	Timers:CreateTimer(1, function()
		local wall = Entities:FindByNameNearest("SeaDoor12", Vector(2485, 8664, -12 + Seafortress.ZFLOAT), 1500)
		Seafortress:Walls(false, {wall}, true, 3.5)
		Seafortress:RemoveBlockers(4, "SeaBlocker12", Vector(2598, 8704, 128), 1500)
		Seafortress:FinalRoom(3)
	end)
end

function deckhand_think(event)
	local caster = event.caster
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 850, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("redfall_bandit_blink_strike")
			if hookAbility:IsFullyCastable() then
				local order = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = hookAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local hookAbility = caster:FindAbilityByName("arena_riki_ult")
		if hookAbility:IsFullyCastable() then
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hookAbility:entindex(),
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
	

end

function start_curse_of_the_deep(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	EmitSoundOnLocationWithCaster(point, "Seafortress.Seafarer.CurseOfTheDeep", caster)
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/seafortress/curse_of_deep_aoe.vpcf", point, 4)
	ParticleManager:SetParticleControl(pfx, 1, Vector(300, 5, 300))
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_curse_of_the_deep", {duration = event.duration})
		end
	end
end

function curse_of_deep_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.unit
	local damage = target:GetMaxHealth() * 0.05
	if IsValidEntity(ability) then
		if not ability.lock then
			ability.lock = true
			CustomAbilities:QuickAttachParticle("particles/roshpit/seafortress/deep_maledict_j.vpcf", target, 1)
			EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Seafortress.Seafarer.CurseOfTheDeepTick", caster)
			ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			Timers:CreateTimer(0.1, function()
				ability.lock = false
			end)
		end
	end
end

function stalacorr_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if target:HasModifier("modifier_stalacorr_flail") then
		return false
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_stalacorr_flail", {duration = 1.5})
	local punchFV = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	WallPhysics:JumpWithBlocking(target, punchFV, 22, 24, 26, 1)

end

function stalacorr_created(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if caster:IsHero() then
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_disable_player", {duration = 5})
	end
end

function stalacor_stone_toss(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	EmitSoundOn("Seafortress.Stalakor.StoneToss", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local info =
			{
				Target = enemy,
				Source = caster,
				Ability = ability,
				EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
				StartPosition = "attach_attack1",
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 8,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 900,
			iVisionTeamNumber = caster:GetTeamNumber()}
			local projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function seal_slap_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability.pushVector = false
	ability.pushVelocity = 27
	ability.tossPosition = caster:GetAbsOrigin()
	target.pushVector = false
end

function colossus_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local percentage = 1 - (caster:GetHealth() / caster:GetMaxHealth())
	percentage = math.ceil(percentage * 100)
	if percentage > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_colossus_rage", {})
		caster:SetModifierStackCount("modifier_colossus_rage", caster, percentage)
	end
	caster:SetRenderColor(255, 255 - (2.55 * percentage), 255 - (2.55 * percentage))
end

function blade_mail_take_damage(event)
	local caster = event.caster

	local attacker = event.attacker
	local ability = event.ability

	local percent = 500
	if attacker:IsHero() then
		percent = 0.1
	end
	local damage = event.damage * percent
	if not ability.reflectLock then
		ability.reflectLock = true
		ApplyDamage({victim = attacker, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		Timers:CreateTimer(0.05, function()
			ability.reflectLock = false
		end)
		EmitSoundOn("Seafortress.Furbolg.BladeMailDamage", attacker)
	end
end

function dark_reef_guard_die(caster)
	if not Seafortress.BlueBolgDeath then
		Seafortress.BlueBolgDeath = 0
	end
	Seafortress.BlueBolgDeath = Seafortress.BlueBolgDeath + 1
	if Seafortress.BlueBolgDeath == 5 then
		Seafortress:MiddleObjective()
		Timers:CreateTimer(2, function()
			local wall = Entities:FindByNameNearest("SeaDoor5", Vector(1717, 1993, -6 + Seafortress.ZFLOAT), 900)
			Seafortress:Walls(false, {wall}, true, 4)
			Seafortress:RemoveBlockers(4, "SeaBlocker5", Vector(1717, 1993, -6 + Seafortress.ZFLOAT), 1200)
			Seafortress:SpawnDarkReefTempleRoom()
		end)
	end
end

function reef_guard_channel_complete(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_sven/sven_loadout.vpcf", caster, 2)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dark_reef_massive_buff", {})
	EmitSoundOn("Seafortress.DarkReefGuard.GodsStrength", caster)
end

function reef_elite_die(event)
	if not Seafortress.ReefEliteSlain then
		Seafortress.ReefEliteSlain = 0
	end
	Seafortress.ReefEliteSlain = Seafortress.ReefEliteSlain + 1
	if Seafortress.ReefEliteSlain == 4 then
		Seafortress:MiddleObjective()
	end

end

function naga_summoner_think(event)
	local caster = event.caster
	local ability = event.ability

	if not caster.summonState then
		caster.interval = 0
		caster.summonState = 0
	end
	caster.interval = caster.interval + 1
	local basePos = Vector(-1600, 4184)
	local yFactor = 0
	local xFactor = 0
	local luck = RandomInt(1, 4)
	if luck == 2 then
		xFactor = 1792
	elseif luck == 3 then
		yFactor = 1792
	elseif luck == 4 then

	end
	local spawnPos = basePos + Vector(xFactor, yFactor)
	if luck == 1 then
		spawnPos = spawnPos + Vector(RandomInt(0, 1792), RandomInt(-200, 200))
	elseif luck == 2 then
		spawnPos = spawnPos + Vector(RandomInt(-200, 200), RandomInt(0, 1792))
	elseif luck == 3 then
		spawnPos = spawnPos + Vector(RandomInt(0, 1792), RandomInt(-200, 200))
	elseif luck == 4 then
		spawnPos = spawnPos + Vector(RandomInt(-200, 200), RandomInt(0, 1792))
	end
	--print("STATE"..caster.state)
	if caster.state == 1 then
		if caster.summonState <= 14 then
			if caster.summonState == 0 then
				EmitSoundOn("Seafortress.Skultoth.SummonAmbient", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_naga_summoner_summoning", {})
			end
			caster.summonState = caster.summonState + 1
			local summonLuck = RandomInt(0, 2)
			local unit = nil
			if summonLuck == 0 then
				unit = Seafortress:SpawnNagaSamurai(spawnPos, Vector(0, -1))
			elseif summonLuck == 1 then
				unit = Seafortress:SpawnFrostMage(spawnPos, Vector(0, -1))
			else
				unit = Seafortress:SpawnNagaProtector(spawnPos, Vector(0, -1))
			end
			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 500), unit:GetAbsOrigin() + Vector(0, 0, 200), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
			Dungeons:AggroUnit(unit)
			CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 3)
			EmitSoundOn("Seafortress.Skultoth.SummonUnit", unit)
			unit.deathCode = 21
		else
			caster.summonState = 0
			caster.state = 2
			caster:RemoveModifierByName("modifier_naga_summoner_summoning")
		end
	elseif caster.state == 2 then
	elseif caster.state == 3 then
		if caster.summonState <= 14 then
			if caster.summonState == 0 then
				EmitSoundOn("Seafortress.Skultoth.SummonAmbient", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_naga_summoner_summoning", {})
			end
			caster.summonState = caster.summonState + 1
			local summonLuck = RandomInt(0, 2)
			local unit = nil

			unit = Seafortress:SpawnDarkReefGuard(spawnPos, Vector(0, -1))

			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 500), unit:GetAbsOrigin() + Vector(0, 0, 200), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
			Dungeons:AggroUnit(unit)
			CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 3)
			EmitSoundOn("Seafortress.Skultoth.SummonUnit", unit)
			unit.deathCode = 21
		else
			caster.summonState = 0
			caster.state = 2
			caster:RemoveModifierByName("modifier_naga_summoner_summoning")
		end
	elseif caster.state == 4 then
		if caster.summonState <= 14 then
			if caster.summonState == 0 then
				EmitSoundOn("Seafortress.Skultoth.SummonAmbient", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_naga_summoner_summoning", {})
			end
			caster.summonState = caster.summonState + 1
			local summonLuck = RandomInt(0, 2)
			local unit = nil
			if caster.summonState % 2 == 0 then
				unit = Seafortress:SpawnFeatherGuard(spawnPos, Vector(0, -1))
			else
				unit = Seafortress:SpawnTempleAssassin(spawnPos, Vector(0, -1))
			end

			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 500), unit:GetAbsOrigin() + Vector(0, 0, 200), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
			Dungeons:AggroUnit(unit)
			CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 3)
			EmitSoundOn("Seafortress.Skultoth.SummonUnit", unit)
			unit.deathCode = 21
		else
			caster.summonState = 0
			caster.state = 2
			caster:RemoveModifierByName("modifier_naga_summoner_summoning")
		end
	elseif caster.state == 5 then
		--print("HELLO?")
		if caster.summonState <= 12 then
			if caster.summonState == 0 then
				EmitSoundOn("Seafortress.Skultoth.SummonAmbient", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_naga_summoner_summoning", {})
			end
			caster.summonState = caster.summonState + 1
			local summonLuck = RandomInt(0, 2)
			local unit = nil
			if caster.summonState < 6 then
				unit = Seafortress:SpawnDarkReefElite(spawnPos, Vector(0, -1))
			else
				unit = Seafortress:SpawnDarkReefGuard(spawnPos, Vector(0, -1))
			end

			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 500), unit:GetAbsOrigin() + Vector(0, 0, 200), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
			Dungeons:AggroUnit(unit)
			CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 3)
			EmitSoundOn("Seafortress.Skultoth.SummonUnit", unit)
			unit.deathCode = 21
		else
			caster.summonState = 0
			caster.state = 2
			caster:RemoveModifierByName("modifier_naga_summoner_summoning")
		end
	elseif caster.state == 6 then
		if caster.summonState <= 13 then
			if caster.summonState == 0 then
				EmitSoundOn("Seafortress.Skultoth.SummonAmbient", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_naga_summoner_summoning", {})
			end
			caster.summonState = caster.summonState + 1
			local summonLuck = RandomInt(0, 2)
			local unit = nil
			if caster.summonState < 8 then
				unit = Seafortress:SpawnSlithereenElite(spawnPos, Vector(0, -1))
			else
				unit = Seafortress:SpawnDarkReefElite(spawnPos, Vector(0, -1))
			end

			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 500), unit:GetAbsOrigin() + Vector(0, 0, 200), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
			Dungeons:AggroUnit(unit)
			CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 3)
			EmitSoundOn("Seafortress.Skultoth.SummonUnit", unit)
			unit.deathCode = 21
		else
			caster.summonState = 0
			caster.state = 2
			caster:RemoveModifierByName("modifier_naga_summoner_summoning")
		end
	elseif caster.state == 7 then
		if caster.summonState <= 7 then
			if caster.summonState == 0 then
				EmitSoundOn("Seafortress.Skultoth.SummonAmbient", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_naga_summoner_summoning", {})
			end
			caster.summonState = caster.summonState + 1
			local summonLuck = RandomInt(0, 2)
			local unit = nil
			if caster.summonState < 4 then
				unit = Seafortress:SpawnOceanWatcher(spawnPos, Vector(0, -1))
			elseif caster.summonState < 8 then
				unit = Seafortress:SpawnBigBlueFurbolg(spawnPos, Vector(0, -1))
			else
				unit = Seafortress:SpawnOceanElemental(spawnPos, Vector(0, -1))
			end

			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 500), unit:GetAbsOrigin() + Vector(0, 0, 200), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
			Dungeons:AggroUnit(unit)
			CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 3)
			EmitSoundOn("Seafortress.Skultoth.SummonUnit", unit)
			unit.deathCode = 21
		else
			caster.summonState = 0
			caster.state = 2
			caster:RemoveModifierByName("modifier_naga_summoner_summoning")
		end
	elseif caster.state == 8 then
		if caster.summonState <= 7 then
			if caster.summonState == 0 then
				EmitSoundOn("Seafortress.Skultoth.SummonAmbient", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_naga_summoner_summoning", {})
			end
			caster.summonState = caster.summonState + 1
			local summonLuck = RandomInt(0, 2)
			local unit = nil
			unit = Seafortress:SpawnDarkReefElite(spawnPos, Vector(0, -1))

			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 500), unit:GetAbsOrigin() + Vector(0, 0, 200), "particles/econ/events/ti7/maelstorm_ti7.vpcf", 0.9)
			Dungeons:AggroUnit(unit)
			CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 3)
			EmitSoundOn("Seafortress.Skultoth.SummonUnit", unit)
			unit.deathCode = 21
		else
			caster.summonState = 0
			caster.state = 0
			caster:RemoveModifierByName("modifier_naga_summoner_summoning")
			Timers:CreateTimer(0.5, function()
				StartAnimation(caster, {duration = 4.4, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.57})
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.Skultoth.Spawn", Events.GameMaster)
				Timers:CreateTimer(4.5, function()
					caster.state = 9
					caster:RemoveModifierByName("modifier_disable_player")
					caster:SetAcquisitionRange(3800)
				end)
			end)
		end
	elseif caster.state == 9 then
		if caster.interval % 12 == 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_start.vpcf", caster, 3)
				local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local target = enemies[1]:GetAbsOrigin() + RandomVector(RandomInt(160, 550))
				local targetPos = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
				FindClearSpaceForUnit(caster, targetPos, false)
				ProjectileManager:ProjectileDodge(caster)
				CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_end.vpcf", caster, 3)
				StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_SPAWN, rate = 1.4})
				EmitSoundOn("Seafortress.TempleAssassin.Teleport", caster)
				Timers:CreateTimer(0.3, function()
					ScreenShake(caster:GetAbsOrigin(), 360, 1.2, 1.2, 9000, 0, true)
					EmitSoundOn("Seafortress.Skuloth.Crush", caster)
					local particleName = "particles/units/heroes/hero_slardar/water_temple_boss_crush.vpcf"
					local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, statue)
					ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0, 0, 80))
					ParticleManager:SetParticleControl(particle, 1, Vector(550, 550, 550))
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 530, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							ApplyDamage({victim = enemy, attacker = caster, damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 5, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
							if enemy:HasModifier("modifier_stun_immune") or enemy:HasModifier("modifier_recently_respawned") then
							else
								enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = 1})
							end
						end
					end
					Timers:CreateTimer(2.2, function()
						ParticleManager:DestroyParticle(particle, false)
					end)
				end)
				return false
			end
		else
			local channelAbility = caster:FindAbilityByName("dark_reef_guard_channel")
			if channelAbility:IsFullyCastable() then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = channelAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
	if caster.interval > 100 then
		caster.interval = 0
	end
end

function naga_summon_unit_die(caster, bCount)
	if not Seafortress.NagaSummonsSlain then
		Seafortress.NagaSummonsSlain = 0
	end
	if bCount then
		Seafortress.NagaSummonsSlain = Seafortress.NagaSummonsSlain + 1
	end
	--print("UNITS SLIAN: "..Seafortress.NagaSummonsSlain)

	if Seafortress.NagaSummonsSlain == 12 then
		if Seafortress.NagaSummonerReefBoss:HasModifier("modifier_naga_summoner_summoning") then
			Timers:CreateTimer(6, function()
				Seafortress.NagaSummonerReefBoss.state = 3
			end)
		else
			Seafortress.NagaSummonerReefBoss.state = 3
		end
	elseif Seafortress.NagaSummonsSlain == 26 then
		if Seafortress.NagaSummonerReefBoss:HasModifier("modifier_naga_summoner_summoning") then
			Timers:CreateTimer(6, function()
				Seafortress.NagaSummonerReefBoss.state = 4
			end)
		else
			Seafortress.NagaSummonerReefBoss.state = 4
		end
	elseif Seafortress.NagaSummonsSlain == 38 then
		if Seafortress.NagaSummonerReefBoss:HasModifier("modifier_naga_summoner_summoning") then
			Timers:CreateTimer(6, function()
				Seafortress.NagaSummonerReefBoss.state = 5
			end)
		else
			Seafortress.NagaSummonerReefBoss.state = 5
		end
	elseif Seafortress.NagaSummonsSlain == 52 then
		if Seafortress.NagaSummonerReefBoss:HasModifier("modifier_naga_summoner_summoning") then
			Timers:CreateTimer(6, function()
				Seafortress.NagaSummonerReefBoss.state = 6
			end)
		else
			Seafortress.NagaSummonerReefBoss.state = 6
		end
	elseif Seafortress.NagaSummonsSlain == 67 then
		if Seafortress.NagaSummonerReefBoss:HasModifier("modifier_naga_summoner_summoning") then
			Timers:CreateTimer(6, function()
				Seafortress.NagaSummonerReefBoss.state = 7
			end)
		else
			Seafortress.NagaSummonerReefBoss.state = 7
		end
	elseif Seafortress.NagaSummonsSlain == 78 then
		if Seafortress.NagaSummonerReefBoss:HasModifier("modifier_naga_summoner_summoning") then
			Timers:CreateTimer(6, function()
				Seafortress.NagaSummonerReefBoss.state = 8
			end)
		else
			Seafortress.NagaSummonerReefBoss.state = 8
		end
	end

end

function naga_summoner_die(caster)
	EmitSoundOn("Seafortress.Skultoth.Die", caster)

	Seafortress:smoothSizeChange(caster, 3.5, 0.3, 60)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.5, 0.5, 0.5))
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	local luck = RandomInt(1, 3)
	if luck == 1 then
		RPCItems:RollCrystallineSlippers(caster:GetAbsOrigin())
	end
	Timers:CreateTimer(2, function()
		local wall = Entities:FindByNameNearest("SeaDoor1", Vector(-713, 6848, 96 + Seafortress.ZFLOAT), 900)
		Seafortress:Walls(false, {wall}, true, 4.2)
		Seafortress:RemoveBlockers(4, "SeaBlocker1", Vector(-873, 6848), 1200)
		Seafortress:FinalRoom(2)
	end)
end

function siltbreaker_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_channeling_water_torrent") then
		return false
	end
	if caster.lock then
		return false
	end
	if not caster:HasModifier("modifier_disable_player") then
		local bReturn = false
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_slardar_amplify_damage") then
					local hookAbility = caster:FindAbilityByName("siltbreaker_amplify_damage")
					if hookAbility:IsFullyCastable() then
						local order = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							TargetIndex = enemy:entindex(),
							AbilityIndex = hookAbility:entindex(),
						}
						ExecuteOrderFromTable(order)
						bReturn = true
						-- StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_5, rate=1.0})
						EmitSoundOn("Seafortress.Siltbreaker.CastAmp", caster)
						caster.lock = true
						Timers:CreateTimer(0.5, function()
							caster.lock = false
						end)
					end
					break
				end
			end
			if bReturn then
				return false
			end
		end

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("siltbreaker_channel")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 260))
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				EmitSoundOn("Seafortress.Siltbreaker.WaterTorrentCAST", caster)
				return false
			else
				local hookAbility = caster:FindAbilityByName("siltbreaker_whirlpool")
				if hookAbility:IsFullyCastable() then
					local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 200))
					local order =
					{
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = hookAbility:entindex(),
						Position = targetPoint
					}
					ExecuteOrderFromTable(order)
					return false
				end
			end
		end
	end
end

function whirlpool_phase_start(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/act_2/siltbreaker_channel.vpcf", caster, 1)
	EmitSoundOn("Seafortress.Siltbreaker.CastWhirlpool", caster)
end

function silt_whirlpool_create(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	EmitSoundOn("Seafortress.Skultoth.SummonAmbient", caster)
	--ability:ApplyDataDrivenThinker(caster, point, "modifier_whirlpool_thinker", {})
	CustomAbilities:QuickAttachThinker(ability, caster, point, "modifier_whirlpool_thinker", {})
	if caster:GetHealth() < caster:GetMaxHealth() * 0.66 then
		--ability:ApplyDataDrivenThinker(caster, point+RandomVector(300), "modifier_whirlpool_thinker", {})
		CustomAbilities:QuickAttachThinker(ability, caster, point + RandomVector(300), "modifier_whirlpool_thinker", {})
	end
	if caster:GetHealth() < caster:GetMaxHealth() * 0.33 then
		--ability:ApplyDataDrivenThinker(caster, point+RandomVector(600), "modifier_whirlpool_thinker", {})
		CustomAbilities:QuickAttachThinker(ability, caster, point + RandomVector(600), "modifier_whirlpool_thinker", {})
	end
end

function channeling_water_torrent(event)
	local caster = event.caster
	local ability = event.ability
	-- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	-- if #enemies > 0 then
	-- local lookVector = (enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)
	-- end
	if caster:HasModifier("modifier_channeling_active") then
		-- local endFV = caster:GetForwardVector()
		-- local range = 1000
		-- local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin()+endFV*(range+300), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
		-- if #enemies > 0 then
		-- for _,enemy in pairs(enemies) do
		-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
		-- -- ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sea_rider_slow", {duration = 2})
		-- end
		-- end
		-- local particleName = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike.vpcf"
		--    local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		--    ParticleManager:SetParticleControl(0, pfx, caster:GetAbsOrigin()+endFV*300)
		--    ParticleManager:SetParticleControl(1, pfx, caster:GetAbsOrigin()+endFV*(range+300))

		-- Timers:CreateTimer(4, function()
		--   ParticleManager:DestroyParticle( pfx, false )
		-- end)
		EmitSoundOn("RPCItem.BlueRain", caster)
		local fv = caster:GetForwardVector()
		for i = -1, 1, 1 do
			local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * i / 15)
			local info =
			{
				Ability = ability,
				EffectName = "particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform.vpcf",
				vSpawnOrigin = caster:GetAbsOrigin() + caster:GetForwardVector() * 260,
				fDistance = 2500,
				fStartRadius = 240,
				fEndRadius = 240,
				Source = caster,
				StartPosition = "attach_attack1",
				bHasFrontalCone = true,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = rotatedFV * 2500,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end
	end
end

function water_torrent_hit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	target:ForceKill(false)
end

function centaur_slam_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/centaur/dc_centaur_double_edge/_dc_centaur_double_edge.vpcf", target, 3)
	local damage = event.damage
	EmitSoundOn("Seafortress.CentaurSlam.Impact", target)
	-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_axe/axe_culling_blade_hit_sparks.vpcf", target, 1)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.3})
end

function centaur_master_die(caster)
	local wall = Entities:FindByNameNearest("SeaDoor13", Vector(-3792, 6848, -7 + Seafortress.ZFLOAT), 1100)
	Seafortress:Walls(false, {wall}, true, 4.01)
	Seafortress:RemoveBlockers(4, "SeaBlocker13", Vector(-3754, 6848, 101 + Seafortress.ZFLOAT), 1200)
	Timers:CreateTimer(2, function()
		Seafortress:FinalRoom(1)
	end)
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollOceanrunnerBoots(caster:GetAbsOrigin())
	end
end

function sea_giant_think(event)
	local caster = event.caster
	if caster:HasModifier("modifier_disable_player") then
		return false
	end
	if caster.lock then
		return false
	end
	if not caster:HasAbility("ability_mega_haste") then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.4 then
			caster:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
		end
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local hookAbility = caster:FindAbilityByName("sea_giant_split_earth")
		if hookAbility:IsFullyCastable() then
			local direction = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local targetPoint = caster:GetAbsOrigin() + direction * 500
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = hookAbility:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
			EmitSoundOn("Seafortress.OceanGiantCastSplit", caster)
			caster.lock = true
			Timers:CreateTimer(0.7, function()
				caster.lock = false
			end)
			return false
		end
	end
end

function sea_giant_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local proc = Filters:GetProc(attacker, 25)
	if target:HasModifier("modifier_glint_no_proc") then
		local newNoProcStacks = target:GetModifierStackCount("modifier_glint_no_proc", caster) - 1
		if newNoProcStacks > 0 then
			target:SetModifierStackCount("modifier_glint_no_proc", caster, newNoProcStacks)
		else
			target:RemoveModifierByName("modifier_glint_no_proc")
		end

		return false
	end
	if proc then
		if attacker:IsAlive() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_glint_no_proc", {duration = 1})
			target:SetModifierStackCount("modifier_glint_no_proc", caster, 2)
			local newPosition = target:GetAbsOrigin() + target:GetForwardVector() *- 320
			local position = attacker:GetAbsOrigin()
			local newPosition = WallPhysics:WallSearch(position, newPosition, target)
			FindClearSpaceForUnit(attacker, newPosition, false)
			attacker:SetForwardVector(target:GetForwardVector() * Vector(1, 1, 0))
			event.ability:ApplyDataDrivenModifier(event.caster, attacker, "modifier_blinded_glint_buff", {duration = 0.8})

			local particleName = "particles/econ/items/meepo/meepo_diggers_divining_rod/meepo_divining_rod_poof_end_rays_burst.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
			local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx2, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", newPosition, true)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:DestroyParticle(pfx2, false)
			end)
			Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
			Timers:CreateTimer(0.1, function()
				if target:IsAlive() then
					Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
				end
			end)
			EmitSoundOnLocationWithCaster(newPosition, "RPCItem.GlintOfOnu", attacker)
		end
	end
	local damage = event.damage
	local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 360
	local radius = 350
	local splitEarthParticle = "particles/roshpit/seafortress/sea_quake.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOn("Seafortress.Barnacle.Quake", caster)
	-- FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 0.1})
		end
	end
end

function sea_giant_kill(event)
	local caster = event.caster
	local unit = event.unit
	EmitSoundOn("Seafortress.OceanGiantKill", caster)
end

function sea_giant_ult(event)
	local caster = event.caster
	local ability = event.ability

	local point = event.target_points[1]
	local direction = ((point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	local startPoint = caster:GetAbsOrigin() + direction * 400

	local stun_duration = event.stun_duration
	local amp = event.amp
	local forks = event.forks
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * event.attack_power_mult_percent / 100
	damage = damage * amp
	local max = 2
	local min = 1
	if caster:GetHealth() < caster:GetMaxHealth() * 0.2 then
		max = 6
	elseif caster:GetHealth() < caster:GetMaxHealth() * 0.4 then
		max = 5
	elseif caster:GetHealth() < caster:GetMaxHealth() * 0.6 then
		max = 4
	elseif caster:GetHealth() < caster:GetMaxHealth() * 0.8 then
		max = 3
	end
	local divisor = max

	-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_prevent_turning_invisible", {duration = 0.15})
	Timers:CreateTimer(0, function()
		direction = caster:GetForwardVector()
		startPoint = caster:GetAbsOrigin() + direction * 400
		local pfx2 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_fire_base.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, startPoint)
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), startPoint, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stun_duration, enemy)
			end
		end
		EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Start", caster)
		local procs = 0
		for j = 0, procs, 1 do
			Timers:CreateTimer(j * 0.5, function()
				for i = min, max, 1 do
					Timers:CreateTimer(0.15, function()

						local forkDirection = WallPhysics:rotateVector(direction, 2 * math.pi * i / divisor)
						if j == 0 then
							EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Moving", caster)
						end

						local particleName = "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf"
						local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
						--print("DOING ANYTHING?")
						ParticleManager:SetParticleControl(pfx, 0, startPoint - direction * 50 + forkDirection * 50)
						ParticleManager:SetParticleControl(pfx, 1, startPoint + forkDirection * 3000)
						ParticleManager:SetParticleControl(pfx, 3, Vector(200, 3.5, 200)) -- y COMPONENT = duration
						-- ParticleManager:SetParticleControl(pfx, 1, point)
						Timers:CreateTimer(3.5, function()
							ParticleManager:DestroyParticle(pfx, false)
							for i = 1, 3, 1 do
								EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Explode"..i, caster)
							end
							local enemies = FindUnitsInLine(caster:GetTeamNumber(), startPoint, startPoint + forkDirection * 3000, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
							for _, enemy in pairs(enemies) do
								ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
								Filters:ApplyStun(caster, stun_duration, enemy)
								--ability:ApplyDataDrivenModifier(caster, targetUnit, "modifier_stun_explosion", {})
							end
							caster:RemoveModifierByName("modifier_general_postmitigation")
						end)


					end)
				end
			end)
		end
	end)
end

function oracle_of_sea_think(event)
	local caster = event.caster
	if caster:HasModifier("modifier_disable_player") then
		return false
	end
	if caster.lock then
		return false
	end
	local buffAbility = caster:FindAbilityByName("sea_oracle_attack_buff")
	if buffAbility:IsFullyCastable() then
		local order =
		{
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = buffAbility:entindex(),
		}
		ExecuteOrderFromTable(order)
		caster.lock = true
		Timers:CreateTimer(1.5, function()
			caster.lock = false
		end)
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local hookAbility = caster:FindAbilityByName("sea_oracle_wave_push")
		if hookAbility:IsFullyCastable() then
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hookAbility:entindex(),
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
	

end

function oracle_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster

	if target:IsHero() then

		ability:ApplyDataDrivenModifier(caster, target, "modifier_sea_oracle_stats_debuff", {duration = 6})
		local stacks = target:GetModifierStackCount("modifier_sea_oracle_stats_debuff", caster)
		local newStacks = stacks + 1
		target:SetModifierStackCount("modifier_sea_oracle_stats_debuff", caster, newStacks)

		local intStacks = target:GetModifierStackCount("modifier_demon_farmer_aura_int", caster)
		local strStacks = target:GetModifierStackCount("modifier_demon_farmer_aura_str", caster)
		local agiStacks = target:GetModifierStackCount("modifier_demon_farmer_aura_agi", caster)

		local newIntStacks = target:GetIntellect() * 0.08
		local newStrStacks = target:GetStrength() * 0.08
		local newAgiStacks = target:GetAgility() * 0.08

		ability:ApplyDataDrivenModifier(caster, target, "modifier_demon_farmer_aura_int", {duration = 6})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_demon_farmer_aura_str", {duration = 6})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_demon_farmer_aura_agi", {duration = 6})

		target:SetModifierStackCount("modifier_demon_farmer_aura_int", caster, intStacks + newIntStacks)
		target:SetModifierStackCount("modifier_demon_farmer_aura_str", caster, strStacks + newStrStacks)
		target:SetModifierStackCount("modifier_demon_farmer_aura_agi", caster, agiStacks + newAgiStacks)
	else
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			caster:MoveToTargetToAttack(enemies[1])
		end
	end
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/seafortress/sea_oracle_impact.vpcf", target, 4)
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
	local damage = event.damage
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	EmitSoundOn("Seafortress.OceanOracle.AttackLand", target)
end

function oracle_wave_push_start(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", caster, 4)

	local particle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
	local start_radius = 240
	local end_radius = 240
	local range = 2500
	local speed = 1500

	EmitSoundOn("Seafortress.OceanOracle.DeafBlastGO", caster)

	local casterOrigin = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	for i = 1, 12, 1 do
		local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * i / 12)
		local info =
		{
			Ability = ability,
			EffectName = particle,
			vSpawnOrigin = casterOrigin + Vector(0, 0, 100),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = rotatedFV * Vector(1, 1, 0) * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function sea_oracle_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local radius = caster:Script_GetAttackRange()
	local attackTime = caster:GetAttackAnimationPoint()
	Timers:CreateTimer(attackTime, function()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local max = 1
		max = max + math.floor((1 - caster:GetHealth() / caster:GetMaxHealth()) * 10)
		local counter = 1
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy:GetEntityIndex() == target:GetEntityIndex() then
				else
					if counter < max then
						counter = counter + 1
						Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
					end
				end
			end
		end
	end)
end

function oracle_push_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability.pushVector = false
	ability.pushVelocity = 54
	ability.tossPosition = caster:GetAbsOrigin()
	target.pushVector = false
	ability:ApplyDataDrivenModifier(caster, target, "modifier_blast_slow", {duration = 3})
end

function oracle_attack_buff_pre(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/act_2/siltbreaker_beam_channel.vpcf", caster, 0.8)
end

function oracle_buff_start(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", caster, 4)
end

function tri_boss_die(caster)
	for i = 0, RandomInt(5, 7), 1 do
		RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
	end
	if not Seafortress.MainBossesSlain then
		Seafortress.MainBossesSlain = 0
	end
	if caster:GetUnitName() == "seafortress_boss_siltbreaker" then
		Statistics.dispatch("sea_fortress:kill:siltbreaker");
		local luck = RandomInt(1, 3)
		if luck == 1 then
			RPCItems:RollDarkReefSharkHelmet(caster:GetAbsOrigin(), false)
		end
	elseif caster:GetUnitName() == "seafortress_oracle_of_the_sea" then
		Statistics.dispatch("sea_fortress:kill:sea_oracle");
		local luck = RandomInt(1, 9)
		if luck == 1 then
			RPCItems:RollEmpyrealSunriseRobe(caster:GetAbsOrigin())
		elseif luck == 2 then
			RPCItems:RollHoodOfTheSeaOracle(caster:GetAbsOrigin())
		end
	elseif caster:GetUnitName() == "seafortress_boss_silver_sea_giant" then
		Statistics.dispatch("sea_fortress:kill:sea_giant");
		local luck = RandomInt(1, 3)
		if luck == 1 then
			RPCItems:RollSeaGiantsPlate(caster:GetAbsOrigin())
		end
	end
	Timers:CreateTimer(0.2, function()
		local maxRoll = 220
		local requirement = 2 + GameState:GetPlayerPremiumStatusCount()
		local luck = RandomInt(1, maxRoll)
		if luck <= requirement then
			RPCItems:RollHydroxisArcana1(caster:GetAbsOrigin())
		end
	end)
	Weapons:RollRandomLegendWeapon2(caster:GetAbsOrigin())
	Seafortress.MainBossesSlain = Seafortress.MainBossesSlain + 1
	if Seafortress.MainBossesSlain == 3 then
		Seafortress:AllBossesSlain()
	end
end

function diviner_jump_cast(event)
	local caster = event.caster
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_adaptive_strike_k.vpcf", caster, 1)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
	ability.acceleration = 30
	ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	ability.target = target
	StartAnimation(caster, {duration = 2, activity = ACT_DOTA_SPAWN, rate = 1.0, tranlate = "loadout"})
end

function diviner_jump_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	local acceleration = ability.acceleration
	ability.acceleration = ability.acceleration - 1.5
	local directionVector = ability.directionVector
	caster:SetAbsOrigin(caster:GetAbsOrigin() + directionVector * (ability.distance / 30) + Vector(0, 0, ability.acceleration))
	if ability.acceleration <= 0 then
		if GetGroundHeight(caster:GetAbsOrigin(), caster) > (caster:GetAbsOrigin().z - 10) then
			caster:RemoveModifierByName("modifier_mountain_crush_jumping")
		end
	end
end

function diviner_jump_end(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 280
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/radiant_fx/radiant_ranged_barracks001_destruction_a.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOn("Seafortress.Diviner.Crash", caster)
	FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius + 5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = 450000, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_blast_jump_slow", {duration = 3})
		end
	end
end

function sea_maiden_final_die(caster)
	Seafortress:SpawnFinalBoss()
	EmitSoundOn("Seafortress.SeaMaiden.Death", caster)
	Timers:CreateTimer(0.82, function()
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1, 0, Seafortress.Jumper2:GetAbsOrigin())
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		EmitSoundOnLocationWithCaster(Seafortress.Jumper2:GetAbsOrigin(), "Seafortress.SwitchImpact", Events.GameMaster)
		Timers:CreateTimer(0.4, function()
			Seafortress.MaidenDeadTwo = true
			local particle2 = ParticleManager:CreateParticle("particles/roshpit/seafortress/teleport_tube.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(particle2, 0, Seafortress.Jumper2:GetAbsOrigin() - Vector(0, 0, 60))
			local particle3 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(particle3, 0, Seafortress.Jumper2:GetAbsOrigin() - Vector(0, 0, 60))
		end)
	end)
	Seafortress.Jumper2:SetAbsOrigin(Seafortress.Jumper2:GetAbsOrigin() + Vector(0, 0, 3000))
	for i = 1, 30, 1 do
		Timers:CreateTimer(i * 0.03, function()
			Seafortress.Jumper2:SetAbsOrigin(Seafortress.Jumper2:GetAbsOrigin() - Vector(0, 0, (2000 / 30)))
		end)
	end
end

function sea_fortress_final_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if not caster.aggro then
		return false
	end
	if caster.dying then
		return false
	end
	caster.interval = caster.interval + 1
	if caster.interval % 40 == 0 then
		if not caster.backHits then
			caster.backHits = 0
		end
		local backHitsMax = 1
		if caster:GetHealth() < caster:GetMaxHealth() * 0.8 then
			backHitsMax = 2
		elseif caster:GetHealth() < caster:GetMaxHealth() * 0.6 then
			backHitsMax = 3
		elseif caster:GetHealth() < caster:GetMaxHealth() * 0.4 then
			backHitsMax = 4
		elseif caster:GetHealth() < caster:GetMaxHealth() * 0.2 then
			backHitsMax = 5
		end
		caster.backHitsMax = backHitsMax
		if caster.backHits > backHitsMax then
			caster.backHits = 0
		end
		Seafortress.MasterAbility:ApplyDataDrivenModifier(Seafortress.Master, caster, "modifier_seafortress_rooted", {duration = 0.8})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {duration = 30})
		StartAnimation(caster, {duration = 1.9, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.1})
		EmitSoundOn("Seafortress.ElectricTennis.StartVO", caster)
		local unit = CreateUnitByName("dummy_unit_vulnerable", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
		unit:AddAbility("seafortress_electric_ball_ability"):SetLevel(1)
		unit:RemoveAbility("dummy_unit_vulnerable")
		unit:RemoveModifierByName("dummy_unit")
		unit.speed = 30
		unit.fv = caster:GetForwardVector()
		unit.origCaster = caster
	end
	if caster.interval == 120 then
		caster.interval = 0
	end
	if caster:GetHealth() < caster:GetMaxHealth() * 0.9 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("seafortress_final_boss_jump")
			if hookAbility:IsFullyCastable() then
				local order = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = hookAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end

	if not caster.summoned1 then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.7 then
			caster.summoned1 = true
			StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.5})
			EmitSoundOn("Seafortress.Boss.SummonVO", caster)
			CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", caster, 4)
			for i = 1, 20, 1 do
				Timers:CreateTimer(i * 0.3, function()
					local spawnPos = Vector(-12812, 12032) + RandomVector(RandomInt(300, 1800))
					Seafortress:SpawnSquidcicle(spawnPos, RandomVector(1))
				end)
			end
		end
	end
	if not caster.summoned2 then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.45 then
			caster.summoned2 = true
			StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.5})
			EmitSoundOn("Seafortress.Boss.SummonVO", caster)
			CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", caster, 4)
			for i = 1, 30, 1 do
				Timers:CreateTimer(i * 0.3, function()
					local spawnPos = Vector(-12812, 12032) + RandomVector(RandomInt(300, 1800))
					Seafortress:SpawnSquidcicle(spawnPos, RandomVector(1))
				end)
			end
		end
	end
	if not caster:HasModifier("modifier_final_boss_gods_strength") then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.3 then
			StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.5})
			EmitSoundOn("Seafortress.Boss.SummonVO", caster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.DarkReefGuard.GodsStrength", caster)
			CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", caster, 4)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_sven/sven_loadout.vpcf", caster, 3)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_final_boss_gods_strength", {})
			caster:AddNewModifier(caster, caster, "modifier_movespeed_cap_super", {})
			Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_ms_thinker", {})
		end
	end
	if not caster.flood then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.35 then
			caster.flood = true
			EmitSoundOnLocationWithCaster(Vector(-14976, 10240), "Seafortress.RainWaves.RainBase", Events.GameMaster)
			for i = 0, 1, 1 do
				for j = 0, 3, 1 do
					local pfx = ParticleManager:CreateParticle("particles/rain_fx/econ_rain.vpcf", PATTACH_CUSTOMORIGIN, Seafortress.Master)
					ParticleManager:SetParticleControl(pfx, 0, Vector(-14976, 10240) + Vector(2000 * i, 1500 * j))
				end
			end
			local waterEnt = Entities:FindByNameNearest("BossFloodWaters", Vector(-11543, 12321, -860 + Seafortress.ZFLOAT), 800)
			waterEnt:SetAbsOrigin(waterEnt:GetAbsOrigin() + Vector(0, 0, 660))
			local movement = 155 / 300
			for i = 1, 300, 1 do
				Timers:CreateTimer(i * 0.1, function()
					waterEnt:SetAbsOrigin(waterEnt:GetAbsOrigin() + Vector(0, 0, movement))
				end)
			end
			Seafortress.BossWater = waterEnt
		end
	else
		if caster:GetHealth() < caster:GetMaxHealth() * 0.35 then
			local pfx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/hyper_visor.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, Vector(-12812, 12032) + RandomVector(RandomInt(1800, 2700)))
			ParticleManager:SetParticleControl(pfx, 1, Vector(240, 0, 0))
			ParticleManager:SetParticleControl(pfx, 3, Vector(0, 0, 0))
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end
	end
	if caster:GetHealth() < 1000 then
		caster.dying = true
		Seafortress.FinalBossSlain = true
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_boss_dying", {})
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Seafortress.Boss.Death1", caster)
		end)
		Timers:CreateTimer(1.5, function()
			CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
			EmitGlobalSound("Loot_Drop_Stinger_Arcana")
			Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})

		end)
		for i = 1, 20, 1 do
			Timers:CreateTimer(0.5 * i, function()
				RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
			end)
		end
		Timers:CreateTimer(3, function()
			for i = 0, 2, 1 do
				Timers:CreateTimer(i, function()
					Weapons:RollRandomLegendWeapon3(caster:GetAbsOrigin())
				end)
			end
		end)
		Timers:CreateTimer(4, function()
			local luck = RandomInt(1, 10)
			if luck == 1 then
				RPCItems:RollOceanHelmOfValdun(caster:GetAbsOrigin(), true)
			elseif luck == 2 then
				RPCItems:RollTokenOfOceanis(caster:GetAbsOrigin(), true)
			end
		end)
		Timers:CreateTimer(2, function()
			RPCItems:DropSynthesisVessel(caster:GetAbsOrigin())
		end)
		local randDelay = RandomInt(10, 50) / 10
		local position = caster:GetAbsOrigin()
		Timers:CreateTimer(randDelay, function()
			for i = 1, #GameState:GetPlayerPremiumStatusCount() + 1, 1 do
				local luck = RandomInt(1, 50)
				if luck == 1 then
					RPCItems:RollRandomArcana(position)
				end
			end
		end)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_boss_dying_effect", {})
		local bossOrigin = caster:GetAbsOrigin()
		StartAnimation(caster, {duration = 9, activity = ACT_DOTA_FLAIL, rate = 1})
		Timers:CreateTimer(7, function()
			CustomAbilities:QuickParticleAtPoint("particles/act_2/siltbreaker_spell_torrent_bubbles.vpcf", caster:GetAbsOrigin(), 12)
		end)
		Timers:CreateTimer(9, function()
			CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
			caster:RemoveModifierByName("modifier_boss_dying")
			Timers:CreateTimer(0.1, function()
				StartAnimation(caster, {duration = 10, activity = ACT_DOTA_DISABLED, rate = 0.25})
				EmitSoundOn("Seafortress.Boss.Death2", caster)
				for i = 1, 120, 1 do
					Timers:CreateTimer(i * 0.05, function()
						if IsValidEntity(caster) then
							caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, -2.5))
						end
					end)
				end
				Timers:CreateTimer(6, function()
					UTIL_Remove(caster)
					Seafortress:DefeatFinalBoss(bossOrigin)
				end)
			end)
		end)
		Timers:CreateTimer(1, function()
			local waterEnt = Seafortress.BossWater
			local movement = -155 / 300
			for i = 1, 300, 1 do
				Timers:CreateTimer(i * 0.1, function()
					waterEnt:SetAbsOrigin(waterEnt:GetAbsOrigin() + Vector(0, 0, movement * 2))
				end)
			end
		end)
	end
end

function final_boss_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.init then
		EmitSoundOn("Seafortress.FinalBoss.Start", caster)
		caster.init = true
		CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = caster:GetUnitName(), bossMaxHealth = caster:GetMaxHealth(), bossId = tostring(caster)})
		Seafortress:BossMusic()
	end
end

function boss_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker

	local fv = ((target:GetAbsOrigin() - attacker:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	-- CustomAbilities:QuickAttachParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_weapon/kunkka_spell_tidebringer_fxset.vpcf", attacker, 2)
	local particleName = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_crit.vpcf"
	if caster:HasModifier("modifier_final_boss_gods_strength") then
		particleName = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf"
	end
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + fv * 600, true)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			-- Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 2)
			local targetAngle = ((enemy:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local angleDifferential = math.acos(fv:Dot(targetAngle, fv))
			--print(angleDifferential)
			if angleDifferential < math.pi / 2 then
				ApplyDamage({victim = enemy, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			end
		end
	end

	if not attacker:HasModifier("modifier_attackspeed_lock") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_final_boss_attack_speed", {duration = 0.3})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_attackspeed_lock", {duration = 1.8})
	end
end

function lightning_ball_think(event)
	local caster = event.caster
	local ability = event.ability

	if not IsValidEntity(caster) or not caster.origCaster then
		return false
	end
	if caster.origCaster.dying then
		UTIL_Remove(caster)
	end
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster:HasModifier("modifier_electric_ball_immunity") then
		return false
	end
	if not caster.fv then
		return false
	end
	local newPosition = caster:GetAbsOrigin() + caster.fv * caster.speed
	caster:SetAbsOrigin(GetGroundPosition(newPosition, caster) + Vector(0, 0, 80))
	caster.speed = math.max(caster.speed - 0.4, 14)
	local bossDistance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.origCaster:GetAbsOrigin())
	if bossDistance > 3200 then
		caster.fv = ((caster.origCaster:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	if #enemies > 0 then
		if enemies[1]:HasModifier("modifier_electric_ball_immunity") then
			local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), enemies[1]:GetAbsOrigin())
			if distance < 300 then
				local towardEnemy = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				caster.fv = (caster.fv * 30 - towardEnemy):Normalized()
			end
		else
			local towardEnemy = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			caster.fv = (caster.fv * 15 + towardEnemy):Normalized()
		end
	end
	local enemiesDamage = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemiesDamage > 0 then
		for i = 1, #enemiesDamage, 1 do
			if not enemiesDamage[i]:HasModifier("modifier_electric_ball_immunity") then
				local towardEnemy = ((enemiesDamage[i]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				Seafortress:ElectrocuteUnit(enemiesDamage[i], towardEnemy)
				ability:ApplyDataDrivenModifier(caster, enemiesDamage[i], "modifier_electric_ball_immunity", {duration = 4.0})
			end
		end
		-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_electric_ball_immunity", {duration = 2})
	end
	if caster.interval > 60 then
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 220, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #allies > 0 then
			for i = 1, #allies, 1 do
				local ally = allies[i]
				if ally:GetUnitName() == "seafortress_final_boss" then
					if not ally:HasModifier("modifier_electric_ball_immunity") then
						if ally.backHits < ally.backHitsMax then
							ally.backHits = ally.backHits + 1
							--print(ally.backHits)
							local towardEnemy = ((ally:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
							ally:SetForwardVector(towardEnemy *- 1)
							StartAnimation(ally, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1.1})
							ability:ApplyDataDrivenModifier(caster, ally, "modifier_electric_ball_immunity", {duration = 0.9})
							Timers:CreateTimer(0.24, function()
								caster.fv = towardEnemy *- 1
								caster.speed = 55
								EmitSoundOn("Seafortress.SvenAttack", caster)
							end)
						else
							local towardEnemy = ((ally:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
							Seafortress:ElectrocuteUnit(ally, towardEnemy)
							UTIL_Remove(caster)
							if ally:HasModifier("modifier_disable_player") then
								ally.backHits = 0
								Timers:CreateTimer(0.5, function()
									ally:RemoveModifierByName("modifier_disable_player")
									CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_medusa/ice_shatter.vpcf", ally, 3)
									EmitSoundOnLocationWithCaster(ally:GetAbsOrigin(), "Seafortress.ElectricTennis.BossImpact", ally)
									EmitSoundOn("Seafortress.ElectricTennis.HitVO", ally)
									ally.interval = 0
								end)
							end
							return false
						end
					end
				end
			end
		end
	end

	if caster.interval > 1400 then
		caster:RemoveModifierByName("modifier_electric_ball")
		UTIL_Remove(caster)
	end
end

function lightning_ball_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	--print("TAKE DAMAGE?")
	local pushDirection = ((caster:GetAbsOrigin() - attacker:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	caster.speed = math.min(caster.speed + 6, 55)
	caster.fv = (caster.fv + pushDirection * 4):Normalized()
end

function boss_crush_end(event)
	local caster = event.caster
	local radius = 320
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/astral_rune_b_d.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOn("Seafortress.Barnacle.Quake", caster)
	FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius - 10, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = 600000, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 1.5})
		end
	end
	local pfx2 = ParticleManager:CreateParticle("particles/radiant_fx/radiant_ranged_barracks001_destruction_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, position)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(radius, radius, radius))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx2, false)
		ParticleManager:DestroyParticle(pfx, false)
	end)
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 2.0})
	local particleDust = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(particleDust, 0, GetGroundPosition(position, Events.GameMaster))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particleDust, false)
	end)
end

function boss_jump_cast(event)
	local caster = event.caster
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_adaptive_strike_k.vpcf", caster, 1)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
	ability.acceleration = 30
	ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.distance = math.max(WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0)), 500)
	ability.target = target
	StartAnimation(caster, {duration = 1.9, activity = ACT_DOTA_TELEPORT_END, rate = 0.8})
end

function main_boss_dying_think(event)
	local caster = event.caster
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/seafortress/boss_dying_effect.vpcf", caster, 4)
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	EmitSoundOn("Seafortress.MainBossyDying.ExplodeSound", caster)
end

function ahn_qhir_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local luck = RandomInt(1, 5)
	if luck == 1 then
		StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.1})
		CustomAbilities:QuickAttachParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_blade_fury.vpcf", caster, 1)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ahn_qhir_spinning", {duration = 1})
		StartSoundEvent("Seafortress.Ahnqhir.Spin", caster)
		for i = 0, 2, 1 do
			Timers:CreateTimer(i * 0.5, function()
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						ApplyDamage({victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
						CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_weapon_blur_critical.vpcf", enemy, 0.7)
					end
				end
				if i == 2 then
					StopSoundEvent("Seafortress.Ahnqhir.Spin", caster)
				end
			end)
		end
	end
end

function begin_ahn_khir_dash(event)
	local caster = event.caster
	local ability = event.ability
	ability.point = event.target_points[1] + caster:GetForwardVector() * 300
	ability.moveDirection = (ability.point - caster:GetAbsOrigin()):Normalized()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_dash", {duration = 3})
	EmitSoundOn("Seafortress.Ahnqhir.Bladestorm", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.DiscipleOfPoseidon.DashStart", Events.GameMaster)
	local particleName = "particles/roshpit/voltex/lightning_dash_trail.vpcf"
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.1})
	local pfx = 0
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())
	StartSoundEvent("Seafortress.Ahnqhir.Spin", caster)
	ability.pfx = pfx

	ability.interval = 0
	if not ability.particles then
		ability.particles = 0
	end
end

function dash_think_ahn_khir(event)
	local caster = event.caster
	local ability = event.ability

	ability.moveDirection = (ability.point - caster:GetAbsOrigin()):Normalized()

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.moveDirection * 35), caster)

	local forwardSpeed = 42
	if blockUnit then
		forwardSpeed = 0
		caster:RemoveModifierByName("modifier_lightning_dash")
		StopSoundEvent("Seafortress.Ahnqhir.Spin", caster)
	end
	local newPosition = caster:GetAbsOrigin() + ability.moveDirection * forwardSpeed
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 0) + Vector(0, 0, GetGroundHeight(newPosition, caster)))
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < forwardSpeed * 1.5 then
		caster:RemoveModifierByName("modifier_lightning_dash")
		StopSoundEvent("Seafortress.Ahnqhir.Spin", caster)
	end
	ability.interval = ability.interval + 1
	if ability.interval % 10 == 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_weapon_blur_critical.vpcf", enemy, 0.7)
			end
		end
	end
	-- if ability.pfx then
	-- local pfx = ability.pfx
	-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())
	-- end
end

function ahn_khir_think(event)
	local caster = event.caster
	if caster:HasModifier("modifier_ahn_khir_spirit_form") then
		return false
	end
	if not caster.aggro then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local hookAbility = caster:FindAbilityByName("seafortress_ahn_khir_dash")
		if hookAbility:IsFullyCastable() then
			local facingVector = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local distance = WallPhysics:GetDistance2d(enemies[1]:GetAbsOrigin(), caster:GetAbsOrigin())
			local targetPoint = caster:GetAbsOrigin() + facingVector * (distance + 400)
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = hookAbility:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
	local ability = event.ability
	if caster:GetHealth() < 5000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ahn_khir_spirit_form", {})
		local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.5, 0.94, 0.8))
		ParticleManager:SetParticleControl(pfx, 2, Vector(0.7, 0.7, 0.7))
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
		ScreenShake(caster:GetAbsOrigin(), 300, 0.5, 0.5, 9000, 0, true)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.SmallCrash", Events.GameMaster)
		Seafortress:smoothSizeChange(caster, 2.1, 0.9, 36)
		Timers:CreateTimer(1, function()
			EmitSoundOn("Seafortress.Ahnqhir.AfterDeath", caster)
		end)
	end
end

function ahn_khir_spirit_think(event)
	local caster = event.caster
	if not caster.state then
		caster.state = 0
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 450, 2.5, false)
	if caster.state == 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		if #enemies > 0 then
			caster:Stop()
		else
			caster:MoveToPosition(Vector(-15424, -3072))
		end
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(-15424, -3072))
		if distance < 120 then
			caster.state = 1
		end
	elseif caster.state == 1 then
		caster.state = 2
		Timers:CreateTimer(2, function()
			caster.state = 3
		end)
	elseif caster.state == 3 then
		caster.state = 4
		StartAnimation(caster, {duration = 6.2, activity = ACT_DOTA_DIE, rate = 0.5})
		Timers:CreateTimer(0.1, function()
			EmitSoundOn("Seafortress.Ahnqhir.AtMask", caster)
		end)
		local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.5, 0.94, 0.8))
		ParticleManager:SetParticleControl(pfx, 2, Vector(0.7, 0.7, 0.7))
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
		ScreenShake(caster:GetAbsOrigin(), 300, 0.5, 0.5, 9000, 0, true)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.SmallCrash", Events.GameMaster)
		Seafortress:smoothSizeChange(caster, 0.9, 0.3, 70)
		Timers:CreateTimer(2.3, function()
			UTIL_Remove(caster)
		end)
		local mask = Entities:FindByNameNearest("mask_of_ahnqir", Vector(-15245, -3459, -584 + Seafortress.ZFLOAT), 2000)
		local colorSpectrum = {Vector(255, 255, 0), Vector(255, 0, 255), Vector(0, 0, 255)}
		local luck = RandomInt(1, 3)
		Seafortress:smoothColorTransition(mask, Vector(0, 0, 0), colorSpectrum[luck], 60)
		local maskGroundPos = GetGroundPosition(mask:GetAbsOrigin(), Events.GameMaster)
		CustomAbilities:QuickParticleAtPoint("particles/items_fx/aegis_timer.vpcf", maskGroundPos, 5)
		Timers:CreateTimer(1.8, function()
			EmitSoundOnLocationWithCaster(maskGroundPos, "Seafortress.Ahnqhir.MaskDrop", Events.GameMaster)
			if luck == 1 then
				RPCItems:RollTwistedMaskOfAhnqhirYellow(maskGroundPos)
			elseif luck == 2 then
				RPCItems:RollTwistedMaskOfAhnqhirPurple(maskGroundPos)
			elseif luck == 3 then
				RPCItems:RollTwistedMaskOfAhnqhirBlue(maskGroundPos)
			end
		end)
	end
end

function saltwater_demon_die(event)
	local caster = event.caster
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollLightSeersRobes(caster:GetAbsOrigin())
	end
end

function spikey_carapace_init(event)
	local ability = event.ability
	ability.entTable = {}
end

function spikey_carapace_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local damage = event.damage
	local ability = event.ability
	-- if caster:HasModifier("modifier_no_reflect") then
	-- return false
	-- end
	local bReflect = true
	for i = 1, #ability.entTable, 1 do
		if ability.entTable[i] == attacker:GetEntityIndex() then
			bReflect = false
		end
	end
	if bReflect then
		if not attacker.bIgnore_spikey_beetle_reflect then
			attacker.bIgnore_spikey_beetle_reflect = true
			EmitSoundOn("Seafortress.SpikeyCarapace.Reflect", attacker)
			ApplyDamage({victim = attacker, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			attacker:AddNewModifier(caster, ability, "modifier_stunned", {duration = event.stun_duration})
			Timers:CreateTimer(0.03, function()
				attacker.bIgnore_spikey_beetle_reflect = false
			end)
			-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_no_reflect", {duration = 0.1})
			table.insert(ability.entTable, attacker:GetEntityIndex())
		end
	end
end

function bahamut_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy:GetEntityIndex() == target:GetEntityIndex() then
			else
				Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
			end
		end
	end
end

function shadow_of_bahamut_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("shadow_of_bahamut_orb")
			if hookAbility:IsFullyCastable() then
				local direction = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()) * Vector(1, 1, 0)
				local targetPoint = enemies[1]:GetOrigin() + direction * 700
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				EmitSoundOn("Seafortress.ShadowOfBahamut.Orb", caster)
				return false
			end
		end
		if ability.interval > 20 then
			ability.interval = 0
			for i = 1, #enemies, 1 do
				ability.blastTable = {}
				table.insert(ability.blastTable, enemies[i]:GetAbsOrigin() + RandomVector(RandomInt(0, 200)))

			end
			for j = 1, #ability.blastTable, 1 do
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/seafortress/shadow_of_bahamut_indicator_portrait.vpcf", GetGroundPosition(ability.blastTable[j], caster) + Vector(0, 0, 10), 2.2)
				Timers:CreateTimer(2.1, function()
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), ability.blastTable[j], nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					for i = 1, #enemies, 1 do
						enemies[i]:ForceKill(false)
					end
					ScreenShake(ability.blastTable[j], 200, 0.5, 1, 9000, 0, true)
					EmitSoundOnLocationWithCaster(ability.blastTable[j], "Seafortress.ShadowOfBahamut.TrapPop", caster)
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/seafortress/shadow_bahamut_spark.vpcf", ability.blastTable[j], 2.5)
				end)
			end
		end
	end
end

function shadow_of_bahamut_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Seafortress.ShadowOfBahamut.Die", caster)
	local drops = 1
	if caster.paragon then
		drops = 3
	end
	for i = 1, drops, 1 do
		RPCItems:RollBahamutArcana2(caster:GetAbsOrigin())
	end
end

function pure_resist_take_damage(event)
	local victim = event.unit
	local ability = event.ability
	if ability.particleLock then
	else
		-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_windwalk_flash_b.vpcf", victim, 1)
		ability.particleLock = true
		Timers:CreateTimer(1.0, function()
			ability.particleLock = false
		end)
	end
end

function archon_wizard_die(event)
	local caster = event.caster
	Seafortress.ArchonSlain = true
	EmitSoundOn("Seafortress.ArchonWizardDie", caster)
	local arcanas = 1
	if caster.paragon then
		arcanas = 2
	end
	for i = 1, arcanas, 1 do
		RPCItems:RollArkimusArcana2(caster:GetAbsOrigin())
	end
	Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(3104, 14272, 110 + Seafortress.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
end

function archon_ground_slam_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Seafortress.ArchonGolemWindUp", caster)
	StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.1})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_barnacle_ground_slam", {duration = 0.9})
	Timers:CreateTimer(0.5, function()
		if not caster:IsAlive() then
			return false
		end
		local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 350
		local radius = 240
		local splitEarthParticle = "particles/roshpit/seafortress/archon_golem_slam.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		EmitSoundOn("Arkimus.ArchonGolem.Slam", caster)
		-- FindClearSpaceForUnit(caster, position, false)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
				if not enemy:HasModifier("modifier_stunned") then
					enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
				end
			end
		end
	end)
end

function archon_wizard_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.r_4_level = 20
	if not caster.golems then
		caster.interval = 0
		caster.golemsSpawned = 0
		caster.golems = Entities:FindAllByNameWithin("ArchonGolem", Vector(3876, 15028, 100 + Seafortress.ZFLOAT), 3800)
	end
	if (caster:GetHealth() / caster:GetMaxHealth()) * 100 < 100 - caster.golemsSpawned * 10 then
		local golemIndex = RandomInt(1, #caster.golems)
		caster.golemsSpawned = caster.golemsSpawned + 1
		local newTable = {}
		for i = 1, #caster.golems, 1 do
			if i == golemIndex then

			else
				table.insert(newTable, caster.golems[i])
			end
		end
		local golem = caster.golems[golemIndex]
		caster.golems = newTable
		-- if golem then
		CreateZonisBeamSeafort(caster:GetAbsOrigin() + Vector(0, 0, 60), golem:GetAbsOrigin() + Vector(0, 0, 60))
		Seafortress:objectShake(golem, 60, 10, true, true, false, "Seafortress.ArchonGolemShaking", 20)
		Seafortress:smoothColorTransition(golem, Vector(75, 53, 88), Vector(207, 94, 255), 60)
		Timers:CreateTimer(1.9, function()
			Seafortress:SpawnArchonGolem(golem:GetAbsOrigin(), RandomVector(1))
			Timers:CreateTimer(0.1, function()
				UTIL_Remove(golem)
			end)
		end)
		-- end
	end
	if caster.aggro then
		caster.interval = caster.interval + 1
		if caster.interval == 14 then
			caster.interval = 0
			CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_start.vpcf", caster, 3)
			FindClearSpaceForUnit(caster, Vector(3876, 15028, 128) + RandomVector(RandomInt(0, 1000)), false)
			ProjectileManager:ProjectileDodge(caster)
			CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_end.vpcf", caster, 3)
			StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_SPAWN, rate = 1.6})
			EmitSoundOn("Seafortress.MountainBeast.Blink", caster)
		end
	end
end

function CreateZonisBeamSeafort(attachPointA, attachPointB)
	for i = 0, 4, 1 do
		Timers:CreateTimer(0.2 * i, function()
			local particleName = "particles/roshpit/arkimus/zonis_lightning.vpcf"
			local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
			ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(lightningBolt, false)
				ParticleManager:ReleaseParticleIndex(lightningBolt)
			end)
		end)
	end
end

function begin_crusader_comet(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	ability.point = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
	ability.jumpVelocity = 60
	ability.forwardMovement = 6
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_comet_jumping", {duration = 1})
	ability.fv = ((ability.point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.landAnimated = false
	EmitSoundOn("Seafortress.CometLift.VO", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/holy_blinkend.vpcf", caster, 1.7)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Paladin.CometFlying", caster)
	local c_c_level = 15
	caster:RemoveModifierByName("modifier_comet_storming")
	if c_c_level > 0 then
		local c_c_duration = 1.0 + 0.1 * c_c_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_black_King_bar_immunity", {duration = c_c_duration})
	end
end

function jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.jumpVelocity = math.max(ability.jumpVelocity - 3, 20)
	ability.forwardMovement = ability.forwardMovement + 2

	local newPosition = caster:GetAbsOrigin() + Vector(0, 0, ability.jumpVelocity) + ability.fv * ability.forwardMovement
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), newPosition, caster)

	if afterWallPosition == newPosition then
		caster:SetAbsOrigin(newPosition)
	else
		caster:SetAbsOrigin(newPosition - ability.fv * ability.forwardMovement)
	end

	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) > 500 then
		caster:RemoveModifierByName("modifier_comet_jumping")
		-- ability.fv = ((ability.point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_comet_storming", {duration = 2})
		local distanceToDash = WallPhysics:GetDistance2d(ability.point, caster:GetAbsOrigin())
		local dashTicks = (caster:GetAbsOrigin().z - GetGroundHeight(ability.point, caster)) / 40
		ability.dashSpeed = math.max(distanceToDash / dashTicks, ability.forwardMovement)
		Timers:CreateTimer(0.1, function()
			EmitSoundOn("Seafortress.CometDash.VO", caster)
		end)
	end
end

function comet_think(event)
	local caster = event.caster
	local ability = event.ability
	local moveVelocity = ability.dashSpeed

	local newPosition = caster:GetAbsOrigin() + ability.fv * moveVelocity - Vector(0, 0, 40)
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), newPosition, caster)

	if afterWallPosition == newPosition then
		caster:SetAbsOrigin(newPosition)
	else
		caster:SetAbsOrigin(newPosition - ability.fv * moveVelocity)
	end

	-- caster:SetAbsOrigin(caster:GetAbsOrigin()+ability.fv*moveVelocity-Vector(0,0,40))
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 80 then
		caster:RemoveModifierByName("modifier_comet_storming")
	elseif caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 340 then
		if not ability.landAnimated then
			--print("ANIMATE")
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Paladin.CometLand", caster)
			ability.landAnimated = true
			StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_ATTACK, rate = 1.3})
		end
	end
end

function comet_storm_end(event)
	local caster = event.caster
	local ability = event.ability
	local landPoint = GetGroundPosition(caster:GetAbsOrigin() + ability.fv * ability.forwardMovement, caster)
	FindClearSpaceForUnit(caster, landPoint, false)
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/paladin/arcana_comet_ground_impact.vpcf", landPoint + Vector(0, 0, 20), 5)
	ParticleManager:SetParticleControl(pfx, 3, landPoint + Vector(0, 0, 20))
	EmitSoundOn("Paladin.CometLandGround", caster)

	local damage = event.damage + 100
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), landPoint, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		end
	end

end

function dark_paladin_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		for i = 1, #Seafortress.GolemsTable, 1 do
			if not Seafortress.GolemsTable[i].aggro then
				Dungeons:AggroUnit(Seafortress.GolemsTable[i])
			end
		end
	end
end

function dark_paladin_die(event)
	local caster = event.caster
	EmitSoundOn("Seafortress.DarkPaladinDie", caster)
	Seafortress.PaladinGolems = Seafortress.PaladinGolems + 1
	if Seafortress.PaladinGolems == 4 then
		RPCItems:RollPaladinArcana2(caster:GetAbsOrigin())
	end
end

function ol_spiny_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 3
	for i = 1, 3, 1 do
		Timers:CreateTimer(i * 0.03, function()
			CustomAbilities:QuickAttachParticle("particles/roshpit/slipfinn/shadow_shank.vpcf", target, 0.4)
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
			CustomAbilities:QuickAttachParticle("particles/roshpit/slipfinn/bog_mystic_dagger.vpcf", target, 2)
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
		end)
	end
end

function ol_spiny_think(event)
	local caster = event.caster
	local ability = event.ability
	local spine = caster:FindAbilityByName("furbolg_blade_mail")
	if caster:HasModifier("modifier_disable_player") then
		return false
	end
	if spine:IsFullyCastable() then
		local order =
		{
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = spine:entindex(),
		}
		ExecuteOrderFromTable(order)
		return false
	end
	local luck = RandomInt(1, 10)
	if luck == 1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1050, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local jump_ability = caster:FindAbilityByName("slipfinn_jump")
			if jump_ability:IsFullyCastable() then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = jump_ability:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function ol_spiny_kill_unit(event)
	local caster = event.caster
	local ability = event.ability
	local unit = event.unit
	if unit:IsRealHero() then
		AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 10, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {})
		CustomAbilities:QuickAttachParticle("particles/dark_smoke_test.vpcf", caster, 6)
		Timers:CreateTimer(1, function()
			Events:smoothSizeChange(caster, 2.4, 0.03, 90)
			EmitSoundOn("Seafortress.OlSpiny.Spawn.FX", caster)
			StartAnimation(caster, {duration = 3, activity = ACT_DOTA_TELEPORT, rate = 1.0})
			Timers:CreateTimer(1.4, function()
				EmitSoundOn("Seafortress.OlSpiny.Spawn.VO", caster)
			end)
			Timers:CreateTimer(3, function()
				local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx, 5, Vector(0.2, 0.5, 0.9))
				ParticleManager:SetParticleControl(pfx, 2, Vector(0.2, 0.2, 0.2))
				Timers:CreateTimer(10, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
				ScreenShake(caster:GetAbsOrigin(), 300, 0.5, 0.5, 9000, 0, true)
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seafortress.SmallCrash", Events.GameMaster)
				EmitSoundOn("Seafortress.OlSpiny.Spawn.FX", caster)
				UTIL_Remove(caster)
			end)
		end)
	end
end

function ol_spiny_die(event)
	local caster = event.caster
	RPCItems:RollSlipfinnArcana1(caster:GetAbsOrigin())
	Events:smoothSizeChange(caster, 2.4, 0.03, 90)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", caster, 5)
	EmitSoundOn("Seafortress.OlSpiny.Death", caster)
	EmitSoundOn("Seafortress.OlSpiny.Spawn.FX", caster)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 5, Vector(0.2, 0.5, 0.9))
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.2, 0.2, 0.2))
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function sea_fortress_use_soul_vessel(event)
	local caster = event.caster
	local ability = event.ability
	if GameState:IsSeaFortress() then
		UTIL_Remove(ability)
		PrecacheUnitByNameAsync("seafortress_beast_tyrant", function(...) end)
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", caster:GetAbsOrigin(), 3)
		Timers:CreateTimer(2, function()
			local spawnPos = caster:GetAbsOrigin() + RandomVector(400)
			local stone = CreateUnitByName("seafortress_beast_tyrant", spawnPos, false, nil, nil, DOTA_TEAM_GOODGUYS)
			-- stone:SetRenderColor(150,150,150)
			-- Arena:ColorWearables(stone, Vector(150,150,150))
			AddFOWViewer(DOTA_TEAM_GOODGUYS, spawnPos, 300, 15, false)
			Events:AdjustBossPower(stone, 14, 14, false)
			stone.itemLevel = 128
			stone:SetModelScale(0.03)
			Events:smoothSizeChange(stone, 0.03, 1.0, 90)
			Timers:CreateTimer(1, function()
				EmitSoundOn("Seafortress.TyrantGhost.SpawnVO", stone)
				StartAnimation(stone, {duration = 5, activity = ACT_DOTA_TELEPORT, rate = 1.0})
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", stone, 30)
				Timers:CreateTimer(4, function()
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", stone, 30)
				end)
			end)
			EmitSoundOnLocationWithCaster(stone:GetAbsOrigin(), "Seafortress.TyrantGhost.IntroMusic", stone)
			stone:SetAbsOrigin(stone:GetAbsOrigin() + Vector(0, 0, 1500))
			stone.speed_fall = 25
			for i = 1, 200, 1 do
				Timers:CreateTimer(i * 0.03, function()
					if stone:GetAbsOrigin().z - GetGroundHeight(stone:GetAbsOrigin(), stone) > 2 then
						stone:SetAbsOrigin(stone:GetAbsOrigin() - Vector(0, 0, stone.speed_fall))
						stone.speed_fall = math.max(5, stone.speed_fall - 0.3)
					end
				end)
			end
			local ghost_passive = stone:FindAbilityByName("seafortress_beast_tryant_passive")
			ghost_passive:ApplyDataDrivenModifier(stone, stone, "modifier_beast_tyrant_ghost_mode", {})
			ghost_passive:ApplyDataDrivenModifier(stone, stone, "modifier_disable_player", {})
			stone.phase = 0
			Timers:CreateTimer(6, function()
				stone.phase = 1
			end)
		end)
	else
		local playerID = caster:GetPlayerOwnerID()
		Notifications:Top(playerID, {text = "Sea Fortress Only", duration = 6, style = {color = "#FF3333"}, continue = true})
	end
end

function tyrant_ghost_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.phase == 1 then
		if not caster.onwardSound then
			EmitSoundOn("Seafortress.TyrantGhost.IntroSpawn.VO", caster)
			caster.onwardSound = true
		end
		local moveToPos = Vector(-1144, 10038)
		local distance = WallPhysics:GetDistance2d(moveToPos, caster:GetAbsOrigin())
		if distance > 100 then
			if Seafortress.AllBossesSlainEffect then
				caster.phase = 2
			else
				caster:MoveToPosition(moveToPos)
			end
		elseif Seafortress.AllBossesSlainEffect then
			caster.phase = 2
		end
	elseif caster.phase == 2 then
		local moveToPos = Vector(-1432, 14784)
		local distance = WallPhysics:GetDistance2d(moveToPos, caster:GetAbsOrigin())
		if distance > 100 then
			caster:MoveToPosition(moveToPos)
		else
			caster.phase = 3
		end
	elseif caster.phase == 3 then
		local statuePos = Vector(-1344, 15700)
		caster.phase = 4
		EmitSoundOn("Seafortress.TyrantGhost.SpawnVO", caster)
		StartAnimation(caster, {duration = 16, activity = ACT_DOTA_TELEPORT, rate = 1.0})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", caster, 30)
		local new_beast = Seafortress:SpawnDungeonUnit("seafortress_beast_tyrant", statuePos, 10, 10, "Seafortress.TyrantGhost.Aggro", Vector(0, -1), false)
		new_beast.reduc = 0.0000018
		new_beast.type = ENEMY_TYPE_MAJOR_BOSS
		new_beast.isBossFFS = true
		new_beast:SetAbsOrigin(statuePos)
		local new_beast_ability = new_beast:FindAbilityByName("seafortress_beast_tryant_passive")

		new_beast_ability:ApplyDataDrivenModifier(new_beast, new_beast, "modifier_disable_player", {})
		Timers:CreateTimer(1, function()
			new_beast_ability:ApplyDataDrivenModifier(new_beast, new_beast, "modifier_beast_tyrant_spawning", {})
		end)
		new_beast:SetAbsOrigin(new_beast:GetAbsOrigin() - Vector(0, 0, 3000))
		new_beast:SetModelScale(3)
		Events:ColorWearablesAndBase(new_beast, Vector(30, 30, 30))
		new_beast.raise_interval = 0
		Seafortress:objectShake(new_beast, 501, 15, true, true, false, "Hero_Spirit_Breaker.PreAttack", 60)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, new_beast:GetAbsOrigin(), 800, 60, false)
		new_beast.cantAggro = true
		for i = 1, 500, 1 do
			Timers:CreateTimer(i * 0.03, function()
				new_beast.raise_interval = new_beast.raise_interval + 1
				if new_beast.raise_interval % 10 == 0 then
					EmitSoundOn("Seafortress.TyrantGhost.Shake", new_beast)
					ScreenShake(new_beast:GetAbsOrigin(), 200, 0.5, 0.5, 500, 0, true)
				end
				if i % 120 == 0 then
					particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
					EmitSoundOn("Tanari.WaterSplash", new_beast)
					local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, new_beast)
					ParticleManager:SetParticleControl(particle1, 0, GetGroundPosition(new_beast:GetAbsOrigin(), new_beast))
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(particle1, false)
					end)
				end
				new_beast:SetAbsOrigin(new_beast:GetAbsOrigin() + Vector(0, 0, 6.3))
			end)
		end
		Timers:CreateTimer(16, function()
			local stone = caster
			EmitSoundOn("Seafortress.TyrantGhost.SpawnVO", stone)
			StartAnimation(stone, {duration = 10, activity = ACT_DOTA_TELEPORT, rate = 1.0})
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", stone, 30)

			EmitSoundOnLocationWithCaster(stone:GetAbsOrigin(), "Arena.SecretHorrorPiano", stone)
			stone.speed_fall = 1
			for i = 1, 200, 1 do
				Timers:CreateTimer(i * 0.03, function()
					stone:SetAbsOrigin(stone:GetAbsOrigin() + Vector(0, 0, stone.speed_fall))
					stone.speed_fall = math.min(8, stone.speed_fall + 0.4)
				end)
			end
			Timers:CreateTimer(7, function()
				UTIL_Remove(caster)
			end)
			Seafortress:objectShake(new_beast, 90, 30, true, true, false, "Seafortress.SmallCrash", 5)
			Timers:CreateTimer(1, function()
				EmitSoundOnLocationWithCaster(new_beast:GetAbsOrigin(), "Seafortress.TyrantGhost.IntroMusic", new_beast)
			end)
			Timers:CreateTimer(2.5, function()
				new_beast:RemoveModifierByName("modifier_beast_tyrant_spawning")
				StartAnimation(new_beast, {duration = 5, activity = ACT_DOTA_SPAWN, rate = 1.0})
				WallPhysics:Jump(new_beast, Vector(0, -1), 38, 30, 30, 1.2)
				CustomAbilities:QuickAttachParticle("particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_generic.vpcf", new_beast, 5)
				local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, new_beast:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
				ParticleManager:SetParticleControl(pfx, 2, Vector(1, 1, 1))
				ScreenShake(new_beast:GetAbsOrigin(), 500, 2, 2, 3000, 0, true)
				Timers:CreateTimer(10, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
				EmitSoundOn("Seafortress.TyrantGhost.IntroCrash", new_beast)

				Events:ColorWearablesAndBase(new_beast, Vector(0, 100, 255))
				Timers:CreateTimer(1.5, function()
					local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
					ParticleManager:SetParticleControl(pfx, 0, new_beast:GetAbsOrigin())
					ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
					ParticleManager:SetParticleControl(pfx, 2, Vector(1, 1, 1))
					Timers:CreateTimer(10, function()
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:ReleaseParticleIndex(pfx)
					end)
					ScreenShake(new_beast:GetAbsOrigin(), 500, 2, 2, 3000, 0, true)
					EmitSoundOn("Seafortress.TyrantGhost.IntroCrash", new_beast)
				end)
				Timers:CreateTimer(2, function()
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", new_beast, 3)
					EmitSoundOn("Seafortress.TyrantGhost.SpawnVO", new_beast)
					StartAnimation(new_beast, {duration = 3, activity = ACT_DOTA_TELEPORT, rate = 0.8})

					Timers:CreateTimer(4, function()
						new_beast:RemoveModifierByName("modifier_disable_player")
						new_beast.cantAggro = false
						Dungeons:AggroUnit(new_beast)
						local new_beast_ability = new_beast:FindAbilityByName("seafortress_beast_tryant_passive")
						new_beast_ability:ApplyDataDrivenModifier(new_beast, new_beast, "modifier_beast_tyrant_combat_ai", {})
					end)
				end)
			end)
		end)
	end
end

function tyrant_ghost_combat_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:IsChanneling() then
		return false
	end
	if not caster:IsAlive() then
		return false
	end
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	local seven_visions = caster:FindAbilityByName("seven_visions")
	if seven_visions:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = seven_visions:entindex(),
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
	if ability.interval % RandomInt(2, 5) == 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local plasma = caster:FindAbilityByName("duskbringer_arcana_terrorize_phantom_plasma")
			if plasma:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 220))
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = plasma:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
			end
		end
	end

	if ability.interval >= 40 then
		ability.interval = 0
		local colors_table = {"red", "blue", "yellow"}
		EmitSoundOn("Seafortress.TyrantGhost.ColorsAbility.VO", caster)
		StartAnimation(caster, {duration = 1.9, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.9})
		for i = 1, #colors_table, 1 do
			local target = caster:GetAbsOrigin() + RandomVector(RandomInt(400, 1000))
			local unit = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber())

			unit:AddAbility("seafortress_beast_tryant_dummy_area"):SetLevel(1)
			local color_ability = unit:FindAbilityByName("seafortress_beast_tryant_dummy_area")
			local modifierName = "modifier_beast_tyrant_dummy_"..colors_table[i]
			color_ability:ApplyDataDrivenModifier(unit, unit, modifierName, {})
			unit:FindAbilityByName("dummy_unit"):SetLevel(1)
			unit.pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/ghost_tyrant_area_portrait.vpcf", PATTACH_CUSTOMORIGIN, unit)
			local colorVector = Vector(255, 0, 0)
			if colors_table[i] == "blue" then
				colorVector = Vector(0, 0, 255)
			elseif colors_table[i] == "yellow" then
				colorVector = Vector(255, 255, 0)
			end

			ParticleManager:SetParticleControl(unit.pfx, 0, unit:GetAbsOrigin() + Vector(0, 0, 30))
			ParticleManager:SetParticleControl(unit.pfx, 4, colorVector)
			EmitSoundOnLocationWithCaster(target, "Seafortress.TyrantGhost.ColorsAbility.Effect", caster)


			Timers:CreateTimer(12, function()
				ParticleManager:DestroyParticle(unit.pfx, false)
				UTIL_Remove(unit)
			end)
		end
	end
end

function beast_tyrant_die(event)
	local caster = event.caster
	ScreenShake(caster:GetAbsOrigin(), 500, 2, 2, 3000, 0, true)
	EmitSoundOn("Seafortress.TyrantGhost.Die", caster)
	Timers:CreateTimer(1.9, function()
		local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 80
		local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.7, 0.9))
		ParticleManager:SetParticleControl(pfx, 2, Vector(1, 1, 1))
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
		ScreenShake(caster:GetAbsOrigin(), 500, 2, 2, 3000, 0, true)
		EmitSoundOn("Seafortress.TyrantGhost.IntroCrash", caster)
		Timers:CreateTimer(2.1, function()
			local death_position = caster:GetAbsOrigin()
			local is_paragon = caster.paragon
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", caster, 30)

			-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.SecretHorrorPiano", caster)
			caster.speed_fall = 2
			for i = 1, 120, 1 do
				Timers:CreateTimer(i * 0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.speed_fall))
					caster.speed_fall = math.min(8, caster.speed_fall + 1.2)
				end)
			end
			Timers:CreateTimer(6, function()
				CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", death_position, 5)

				EmitSoundOnLocationWithCaster(death_position, "Seafortress.TyrantGhost.IntroMusic", Events.GameMaster)
				Timers:CreateTimer(5, function()
					local arcanas = 1
					if is_paragon then
						arcanas = 2
					end
					for i = 1, arcanas, 1 do
						RPCItems:RollDuskbringerArcana2(position)
					end
				end)
			end)
		end)
	end)
end

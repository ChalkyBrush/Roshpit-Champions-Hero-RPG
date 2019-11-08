function DialogueThink(event)
	local ability = event.ability
	caster = event.caster
	if not caster.hasSpeechBubble then
		local ability = event.ability
		local position = caster:GetAbsOrigin()
		local radius = 250

		local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		local target_types = DOTA_UNIT_TARGET_HERO
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)

		if #units > 0 then
			if caster.dialogueName then
				if caster.dialogueName == "redfall_farmer1" then
					local fv = ((units[1]:GetAbsOrigin() - position) * Vector(1, 1, 0)):Normalized()
					caster:SetForwardVector(fv)
					farmer1(caster, ability, units)
				elseif caster.dialogueName == "farmer1a" then
					caster.hasSpeechBubble = true
					Quests:ShowDialogueText(units, caster, "redfall_dialogue_farmer_1_h", 5, false)
					Timers:CreateTimer(6, function()
						caster.hasSpeechBubble = false
					end)
				elseif caster.dialogueName == "redfall_farmer2" then
					farmer2(caster, ability, units)
				elseif caster.dialogueName == "redfall_farmer3" then
					farmer3(caster, ability, units[1])
					return false
				elseif caster.dialogueName == "redfall_farmer_enemy" then
					farmer_enemy(caster, ability, units[1])
				elseif caster.dialogueName == "farmer2_shredder" then
					farmer_shredder(caster, ability, units)
				elseif caster.dialogueName == "farmer2_shredder_2" then
					farmer_shredder2(caster, ability, units)
				end
			end
		end
	end
	if caster.dialogueName then
		if caster.dialogueName == "redfall_farmer3" then
			local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
			local target_types = DOTA_UNIT_TARGET_HERO
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1600, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			local luck = RandomInt(1, 2)
			local speechText = "#redfall_dialogue_farmer_3_a"
			if luck == 2 then
				speechText = "#redfall_dialogue_farmer_3_b"
			end
			Quests:ShowDialogueText(units, caster, speechText, 3, false)
		end
	end
	if caster.phase then
		if caster.dialogueName == "redfall_farmer1" then
			if caster.phase == 0 then
			end
		end
	end

end

function farmer1(caster, ability, units)
	local position = caster:GetAbsOrigin()
	local radius = 3000

	local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_HERO
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	if #units > 0 then
		Redfall.dialogueTargetMax = #units
		Redfall.dialogueTargets = 0
		Redfall.Farmlands.FarmerSceneAHeroes = units
		caster.dialogueName = nil
		local time = 6
		local speechSlot = findEmptyDialogSlot()
		if speechSlot < 4 then
			Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_1_a", time, false)
			Redfall:disableSpeech(caster, time, speechSlot)
		end
		Timers:CreateTimer(6, function()
			local time = 5
			local speechSlot = findEmptyDialogSlot()
			if speechSlot < 4 then
				Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_1_b", time, false)
				Redfall:disableSpeech(caster, time, speechSlot)
			end
		end)
		Timers:CreateTimer(11, function()
			local time = 5
			local speechSlot = findEmptyDialogSlot()
			if speechSlot < 4 then
				Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_1_c", time, false)
				Redfall:disableSpeech(caster, time, speechSlot)
			end
			Timers:CreateTimer(0.6, function()
				caster:MoveToPosition(Vector(5610, -12238))
				Timers:CreateTimer(6.5, function()
					caster:MoveToPosition(Vector(5650, -12238))
				end)
			end)
		end)
		for i = 1, #units, 1 do
			local unit = units[i]
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_farmer_scene", {duration = 1})
			unit:Stop()
			Timers:CreateTimer(11, function()
				unit.cinemaSceneA = 0
				Redfall.RedfallMasterAbility.cinemaSceneA = 0
			end)
			Timers:CreateTimer(22, function()
				if not Redfall.FarmSceneSafe then
					caster.dialogueName = "redfall_farmer1"
				end
			end)
		end
	end
end

function findEmptyDialogSlot()
	if not Events.Dialog1 then
		Events.Dialog1 = true
		return 1
	elseif not Events.Dialog2 then
		Events.Dialog2 = true
		return 2
	elseif not Events.Dialog3 then
		Events.Dialog3 = true
		return 3
	end
	return 4
end

function farmer2(caster, ability, units)
	caster.dialogueName = nil
	Redfall.ShredderHandler = caster
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_2_a", time, false)
		Redfall:disableSpeech(caster, time, speechSlot)
	end
	Timers:CreateTimer(5, function()
		local time = 4
		local speechSlot = findEmptyDialogSlot()
		if speechSlot < 4 then
			Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_2_b", time, false)
			Redfall:disableSpeech(caster, time, speechSlot)
		end
	end)
	Timers:CreateTimer(9.8, function()
		Redfall:Farm3Event(1)
	end)
	Timers:CreateTimer(10, function()
		local time = 5
		local speechSlot = findEmptyDialogSlot()
		if speechSlot < 4 then
			Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_2_c", time, false)
			Redfall:disableSpeech(caster, time, speechSlot)
		end
	end)
end

function farmer3(caster, ability, hero)
	caster.dialogueName = nil
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(MAIN_HERO_TABLE, caster, "#redfall_dialogue_farmer_3_c", time, false)
		Redfall:disableSpeech(caster, time, speechSlot)
	end
	Redfall:LastFarmhouseScene(hero)
end

function farmer_enemy(caster, ability, hero)
	caster.dialogueName = nil
	local time = 5
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(MAIN_HERO_TABLE, caster, "...", time, false)
		Redfall:disableSpeech(caster, time, speechSlot)
	end
	StartAnimation(caster, {duration = 4.6, activity = ACT_DOTA_TELEPORT, rate = 1.0})
	local baseSize = 0.9
	for i = 1, 150, 1 do
		Timers:CreateTimer(i * 0.03, function()
			if i % 31 == 0 then
				CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/boss_death_ntimage_manavoid_ti_5.vpcf", caster, 3)
				EmitSoundOn("Redfall.DemonFarmerChanneling", caster)
			end
			caster:SetRenderColor(255, 255 - i, 255 - i)
			caster:SetModelScale(baseSize + i * 0.01)
		end)
	end
	Timers:CreateTimer(4.59, function()
		local demon = Redfall:SpawnDemonFarmer(caster:GetAbsOrigin(), caster:GetForwardVector())
		demon.summonState = 0
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tombstone.vpcf", demon, 4)
		CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_spawn.vpcf", demon, 4)
		UTIL_Remove(caster)
	end)
end

function farmer_shredder(caster, ability, units)
	caster.dialogueName = nil
	local time = 4
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_2_shredder_1", time, false)
		Redfall:disableSpeech(caster, time, speechSlot)
	end
	Timers:CreateTimer(4, function()
		Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_2_shredder_1a", 5, false)
		caster:MoveToPosition(Vector(6144, -5952))
		Timers:CreateTimer(1, function()
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(0, 10, 0))
			local walls = Entities:FindAllByNameWithin("HouseBookshelf", Vector(6168, -5755, 226 + Redfall.ZFLOAT), 1200)
			Redfall:FarmWalls(false, walls, true, 3.0)
			Timers:CreateTimer(3, function()
				local blockers = Entities:FindAllByNameWithin("FarmhouseBookshelfBlocker", Vector(6208, -5779, 96 + Redfall.ZFLOAT), 1200)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
		end)
		Timers:CreateTimer(4.7, function()
			caster:MoveToPosition(Vector(6656, -5632))
			Timers:CreateTimer(5, function()
				caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-20, 0, 0))
				caster.dialogueName = "farmer2_shredder_2"
			end)
		end)
	end)
	Timers:CreateTimer(8, function()
		Redfall.FriendlyShredder.aiState = 3
	end)
end

function farmer_shredder2(caster, ability, units)
	local time = 8
	local speechSlot = findEmptyDialogSlot()
	if speechSlot < 4 then
		Quests:ShowDialogueText(units, caster, "#redfall_dialogue_farmer_2_shredder_2", time, false)
		Redfall:disableSpeech(caster, time, speechSlot)
	end
end

function use_spirit_ruby(event)
	local hero = event.caster
	local item = event.ability
	local distance = WallPhysics:GetDistance2d(Vector(-14464, -15040, 128), hero:GetAbsOrigin())
	if Events.SpiritRealm then
		EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
		return
	end
	if distance < 2000 then
		if GameState:IsRedfallRidge() then

			RPCItems:ItemUTIL_Remove(item)
			EmitGlobalSound("Redfall.EnterEquinox")
			-- for i = 1, #MAIN_HERO_TABLE, 1 do
			--   Tanari.fountainAbility:ApplyDataDrivenModifier(Tanari.WitchDoctor, MAIN_HERO_TABLE[i], "modifier_tanari_entering_spirit_realm", {duration = 4})
			-- end
			Events.SpiritRealm = true
			CustomGameEventManager:Send_ServerToAllClients("enter_equinox", {})
			Timers:CreateTimer(3.2, function()
				EmitGlobalSound("Redfall.EnterSpiritRealm.Music")
				Redfall:CreateSpiritAmbience()
				CustomGameEventManager:Send_ServerToAllClients("update_spirit_zone_display", {tooltip = "#redfall_equinox"})
			end)
			Timers:CreateTimer(10, function()
				Challenges:ProcessPossibleSpawnEvent(1)
			end)
		else
			Notifications:Top(hero:GetPlayerOwnerID(), {text = "Must use in Town", duration = 3, style = {color = "red"}, continue = true})
			EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
		end
	end
end

function ancient_tree_think(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/ancient_tree_sparkle_end_ti6_lvl2.vpcf", caster, 3)
	local ability = event.ability
	if caster.dying then
		return false
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			local info =
			{
				Target = enemies[i],
				Source = caster,
				Ability = ability,
				EffectName = "particles/roshpit/ancient_tree/vision_projectile.vpcf",
				StartPosition = "attach_origin",
				bDrawsOnMinimap = false,
				bDodgeable = false,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 5,
				bProvidesVision = false,
				iVisionRadius = 0,
				iMoveSpeed = 600,
			iVisionTeamNumber = caster:GetTeamNumber()}

			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function ancient_tree_main_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.summonCount then
		caster.summonCount = 0
	end
	if caster.dying then
		return false
	end
	if caster:IsStunned() or caster:IsSilenced() or caster:IsFrozen() then
		if not caster.stunCounter then
			caster.stunCounter = 0
		end
		caster.stunCounter = caster.stunCounter + 1
		if caster.stunCounter >= 12 then
			caster.stunCounter = 0
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_black_King_bar_immunity", {duration = 3.5})
		end
	end
	if caster:GetHealth() < 5000 then
		caster.dying = true
		if caster.phase2 then
			Statistics.dispatch("redfall_ridge:kill:world_tree");
			caster.deathStart = true
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dying_generic", {duration = 20})
			CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
			caster.deathStart = true
			StartAnimation(caster, {duration = 7, activity = ACT_DOTA_FLAIL, rate = 1})
			Timers:CreateTimer(0.5, function()
				EmitSoundOn("Redfall.AncientTree.Death2", caster)
			end)
			Timers:CreateTimer(1.5, function()
				EmitGlobalSound("Loot_Drop_Stinger_Arcana")
				local luck = RandomInt(1, 2)
				if luck == 1 then
					RPCItems:RollWorldTreesFlowerCache(caster:GetAbsOrigin())
				else
					RPCItems:RollRedOctoberBoots(caster:GetAbsOrigin(), Events.SpiritRealm)
				end
			end)
			caster:BossDrops(14)
			-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_temple_boss_dying_effect", {})
			local bossOrigin = caster:GetAbsOrigin()
			Timers:CreateTimer(8, function()
				Events:MainBossSlain(caster:GetUnitName())
				caster:RemoveModifierByName("modifier_dying_generic")
				local stoneAbility = caster:FindAbilityByName("ancient_tree_passive")
				stoneAbility:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_tree_cinematic", {duration = 7.0})
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_cant_die_disabled", {duration = 20})
				Timers:CreateTimer(0.1, function()
					StartAnimation(caster, {duration = 8, activity = ACT_DOTA_DIE, rate = 0.6})
					EmitSoundOn("Redfall.AncientTree.Death1", caster)
					-- for i = 1, 120, 1 do
					-- Timers:CreateTimer(i*0.05, function()
					-- if IsValidEntity(caster) then
					-- caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-5))
					-- end
					-- end)
					-- end
					Timers:CreateTimer(2.85, function()
						ScreenShake(caster:GetAbsOrigin(), 1330, 1.5, 1.5, 9000, 0, true)
					end)
					Timers:CreateTimer(4.5, function()
						UTIL_Remove(caster)
						Redfall:DefeatDungeonBoss("ancient_tree", bossOrigin)
					end)
				end)
			end)
		else
			local stone = caster
			caster.phase2 = true
			local stoneAbility = caster:FindAbilityByName("ancient_tree_passive")
			StartAnimation(stone, {duration = 2.4, activity = ACT_DOTA_DIE, rate = 1.1})
			stoneAbility:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_tree_cinematic", {duration = 7.0})
			stoneAbility:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_tree_round_2", {})
			for i = 1, 80, 1 do
				Timers:CreateTimer(i * 0.03, function()
					caster:SetModelScale(2.45 - i * 0.03)
				end)
			end
			EmitSoundOn("Redfall.AncientTree.Death1", caster)
			Timers:CreateTimer(2.6, function()
				for i = 1, 120, 1 do
					Timers:CreateTimer(i * 0.03, function()
						stone:SetModelScale(0.05 + i * 0.025)
					end)
				end
				Timers:CreateTimer(0.05, function()
					StartAnimation(stone, {duration = 6, activity = ACT_DOTA_TELEPORT, rate = 0.5})
				end)
				for j = 0, 3, 1 do
					Timers:CreateTimer(j * 0.8, function()
						local particleName = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
						local pfxB = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, stone)
						ParticleManager:SetParticleControl(pfxB, 0, stone:GetAbsOrigin() + Vector(0, 0, 50))
						ParticleManager:SetParticleControl(pfxB, 1, Vector(300 + j * 100, 1, 2))
						ScreenShake(stone:GetAbsOrigin(), 130, 0.9, 0.9, 9000, 0, true)
						Timers:CreateTimer(2.8, function()
							ParticleManager:DestroyParticle(pfxB, false)
						end)
					end)
				end
			end)
			Timers:CreateTimer(6.5, function()
				caster.dying = false
				caster:SetHealth(caster:GetMaxHealth())
				EmitSoundOn("Redfall.AncientTree.Taunt", caster)
			end)
		end
	end
	if caster.summonCount < 18 then
		local summonAbility = caster:FindAbilityByName("ancient_tree_summon")
		if summonAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 5100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = summonAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				Timers:CreateTimer(0.05, function()
					caster:SetAcquisitionRange(5000)
				end)
				return false
			end
		end
	end
	local slamAbility = caster:FindAbilityByName("ancient_tree_ground_slam")
	if slamAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = enemies[1]:entindex(),
				AbilityIndex = slamAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return false
		end
	end
end

function ancient_tree_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ancient_tree_vision", {duration = 5})
	local stackIncrease = 1
	if caster:HasModifier("modifier_ancient_tree_round_2") then
		stackIncrease = 2
	end
	local newStacks = target:GetModifierStackCount("modifier_ancient_tree_vision", caster) + stackIncrease
	target:SetModifierStackCount("modifier_ancient_tree_vision", caster, newStacks)
	target:CalculateAndSaveRoshpitAttributes()
end

function ancient_tree_summon(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()
	local position = caster:GetAbsOrigin()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(position, Events.GameMaster))
	EmitSoundOnLocationWithCaster(position, "Redfall.AncientTree.Spawn", Events.GameMaster)
	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if not caster.summonCount then
		caster.summonCount = 0
	end
	if not caster.summonTable then
		caster.summonTable = {}
	end
	local summons = 4
	if caster:HasModifier("modifier_ancient_tree_round_2") then
		summons = 7
	end
	local spawnDistance = RandomInt(260, 480)
	for i = 0, summons, 1 do
		local rotatedFV = WallPhysics:rotateVector(baseFV, 2 * math.pi * i / summons)
		local stone = Redfall:SpawnAncientTreeSummon(caster:GetAbsOrigin() + rotatedFV * spawnDistance, rotatedFV)
		local particleName = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
		local pfxB = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, stone)
		ParticleManager:SetParticleControl(pfxB, 0, stone:GetAbsOrigin() + Vector(0, 0, 50))
		ParticleManager:SetParticleControl(pfxB, 1, Vector(100, 1, 2))
		Timers:CreateTimer(2.8, function()
			ParticleManager:DestroyParticle(pfxB, false)
		end)
		caster.summonCount = caster.summonCount + 1
		stone.origCaster = caster
		stone:SetRenderColor(255, 100, 100)
		table.insert(caster.summonTable, stone)
		stone.targetRadius = 1000
		stone.minRadius = 0
		stone.targetAbilityCD = 1
		stone.targetFindOrder = FIND_CLOSEST
		stone:SetAcquisitionRange(5000)
	end
end

function tree_summon_die(event)
	local caster = event.caster
	local ability = event.ability
	local origCaster = event.unit.origCaster
	origCaster.summonCount = origCaster.summonCount - 1

	local newTable = {}
	for i = 1, #origCaster.summonTable, 1 do
		local summon = origCaster.summonTable[i]
		if IsValidEntity(summon) then
			if summon:IsAlive() then
				table.insert(newTable, summon)
			end
		end
	end
	origCaster.summonTable = newTable
	for i = 1, #origCaster.summonTable, 1 do
		--print(origCaster.summonTable[i]:GetUnitName())
	end
end

function summoner_leech_seed(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	EmitSoundOn("Redfall.AncientTreeSummon.LeechSeed", caster)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(0.7, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_summon_leech_seed_debuff", {duration = 3})
end

function summon_leech_seed_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local origCaster = caster.origCaster
	local damage = event.damage
	if origCaster:HasModifier("modifier_ancient_tree_round_2") then
		damage = damage * 2
	end
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_treant/treant_leech_seed_damage_pulse.vpcf", target, 0.5)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	for i = 1, #origCaster.summonTable, 1 do
		local info =
		{
			Target = origCaster.summonTable[i],
			Source = target,
			Ability = ability,
			EffectName = "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf",
			StartPosition = "attach_origin",
			bDrawsOnMinimap = false,
			bDodgeable = false,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 5,
			bProvidesVision = false,
			iVisionRadius = 0,
			iMoveSpeed = 600,
		iVisionTeamNumber = caster:GetTeamNumber()}

		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end
	local info =
	{
		Target = origCaster,
		Source = target,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf",
		StartPosition = "attach_origin",
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 600,
	iVisionTeamNumber = caster:GetTeamNumber()}

	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function summon_leech_seed_heal(event)
	local target = event.target
	local caster = event.caster
	local healAmount = target:GetMaxHealth() * 0.20
	if target:GetUnitName() == "redfall_ancient_tree" then
		healAmount = target:GetMaxHealth() * 0.06
	end
	--print(healAmount)
	Filters:ApplyHeal(target, target, healAmount, true)
end

function tree_ground_slam_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Redfall.AncientTree.WindUp", caster)
	StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.9})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_barnacle_ground_slam", {duration = 1.6})
	Timers:CreateTimer(0.6, function()
		local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 380
		local radius = 540
		if caster:HasModifier("modifier_ancient_tree_round_2") then
			radius = 900
		end
		local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		EmitSoundOn("Redfall.AncientTree.Slam", caster)
		ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
		-- FindClearSpaceForUnit(caster, position, false)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
				enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 1.5})
			end
		end
	end)
end

function general_hero_think(event)
	local target = event.target
	CustomAttributes:SetAttributes(target)
	CustomAttributes:ApplyStatBonusesToHero(target)
	local strength = math.floor(target:GetStrength())
	local agility = math.floor(target:GetAgility())
	local intelligence = math.floor(target:GetIntellect())
	local primaryAttribute = target:GetPrimaryAttribute()
	local healthRegen = target:GetHealthRegen()
	local manaRegen = (target:GetBaseManaRegen() + target:GetBonusManaRegen())
	-- magaRegen = manaRegen + (manaRegen*target:GetManaRegenMultiplier())/100

	local movespeedBase = target:GetBaseMoveSpeed()
	local movespeed = target:GetMoveSpeedModifier(movespeedBase, false)
	CustomNetTables:SetTableValue("hero_index", tostring(target:GetEntityIndex() .. "_attributes"), {strength = tostring(strength), agility = tostring(agility), intelligence = tostring(intelligence), primaryAttribute = tostring(primaryAttribute), healthRegen = tostring(healthRegen), manaRegen = tostring(manaRegen), movespeed = tostring(movespeed)})
	for i = 0, 5, 1 do
		local playerID = target:GetPlayerOwnerID()
		local itemEntity = CustomNetTables:GetTableValue("equipment", tostring(playerID) .. "-"..tostring(i))
		if itemEntity then
			if itemEntity.itemIndex == -1 then
			else
				local item = EntIndexToHScript(itemEntity.itemIndex)
				if IsValidEntity(item) then
				else
					CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(i), {itemIndex = -1})
					CustomGameEventManager:Send_ServerToPlayer(target:GetPlayerOwner(), "update_inventory", {})
				end
			end
		else
			CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(i), {itemIndex = -1})
			CustomGameEventManager:Send_ServerToPlayer(target:GetPlayerOwner(), "update_inventory", {})
		end

	end
	if GridNav:IsTraversable(target:GetAbsOrigin()) then
		target.safePos = target:GetAbsOrigin()
	end
	if not target:HasModifier("modifier_ms_thinker") then
		if Events.GameMaster then
			Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, target, "modifier_ms_thinker", {})
		end
	end
	-- CustomAttributes:CalcMovespeed(target)
end

function hero_aura_apply(event)
	local caster = event.target
	local pickUpPlayer = nil
	if caster.active and caster:HasModifier("arcane_cystal_passive") then
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #allies > 0 then
			pickUpPlayer = allies[1]
			if #allies > 1 then
				for i = 2, #allies, 1 do
					if pickUpPlayer.crystalsPickedUp then
						if pickUpPlayer.crystalsPickedUp > pickUpPlayer.maxCrystals * Events.ResourceBonus then
							pickUpPlayer = allies[i]
						end
					end
				end
			end
			if pickUpPlayer.crystalsPickedUp < pickUpPlayer.maxCrystals * Events.ResourceBonus then
				caster.pickUpPlayer = pickUpPlayer
				caster.active = false
				caster.moveSpeed = 25
				if pickUpPlayer:HasModifier("modifier_arcane_charm") then
					caster.moveSpeed = 35
				end
				caster:FindAbilityByName("arcane_crystal_ability"):ApplyDataDrivenModifier(caster, caster, "arcane_crystal_moving_to_target", {})
			end
		end
	end
end

function crystal_moving_to_target(event)
	local caster = event.caster
	if IsValidEntity(caster) and caster.pickUpPlayer then
		if not caster.pickupLock then
			local pickUpPlayer = caster.pickUpPlayer
			if caster.scale then
				caster.scale = math.max(caster.scale - 0.06, 0.2)
				caster:SetModelScale(caster.scale)
			end
			local moveToDirection = pickUpPlayer:GetAbsOrigin() - caster:GetAbsOrigin()
			moveToDirection = moveToDirection:Normalized()
			moveToDirection = moveToDirection:Normalized()
			caster:SetAbsOrigin(caster:GetAbsOrigin() + moveToDirection * caster.moveSpeed)
			caster.moveSpeed = caster.moveSpeed + 1
			-- local newPos = caster:GetAbsOrigin()*moveToDirection*40
			-- caster:SetAbsOrigin(newPos)
			local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), caster.pickUpPlayer:GetAbsOrigin())
			if distance < (caster.moveSpeed + 3) then
				caster.pickupLock = true
				local crystalAmount = caster.quantity * Events.ResourceBonus

				PopupArcaneCrystals(pickUpPlayer, crystalAmount)
				local particleName = "particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, pickUpPlayer)
				ParticleManager:SetParticleControlEnt(pfx, 0, pickUpPlayer, PATTACH_POINT_FOLLOW, "attach_hitloc", pickUpPlayer:GetAbsOrigin(), true)
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				pickUpPlayer.crystalsPickedUp = pickUpPlayer.crystalsPickedUp + crystalAmount
				if crystalAmount == 1 then
					EmitSoundOnLocationWithCaster(pickUpPlayer:GetAbsOrigin(), "Glyphs.ArcaneCrystalCollect2", pickUpPlayer)
				else
					EmitSoundOnLocationWithCaster(pickUpPlayer:GetAbsOrigin(), "Glyphs.ArcaneCrystalCollect", pickUpPlayer)
				end
				CustomGameEventManager:Send_ServerToPlayer(pickUpPlayer:GetPlayerOwner(), "collect_arcane", {gain = pickUpPlayer.crystalsPickedUp})
				CustomGameEventManager:Send_ServerToPlayer(pickUpPlayer:GetPlayerOwner(), "update_resources_increment", {increment = pickUpPlayer.crystalsPickedUp, resource = "arcane"})
				if pickUpPlayer:HasModifier("modifier_arcane_charm") then
					local healPercent = (caster.quantity / 100) * 0.01
					Filters:ApplyHeal(pickUpPlayer, pickUpPlayer, pickUpPlayer:GetMaxHealth() * healPercent, true)
					pickUpPlayer:GiveMana(pickUpPlayer:GetMaxMana() * healPercent)
				end
				UTIL_Remove(caster)
			end
		end
	end
end

function arcane_crystal_think(event)
	local caster = event.caster

end

function mithril_shard_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
		caster.rewardsTable = {}
		local playerTable = RPCItems:GetConnectedPlayerTable()
		for i = 1, #playerTable, 1 do
			if not playerTable[i].shardsPickedUp then
				playerTable[i].shardsPickedUp = 0
			end
			table.insert(caster.rewardsTable, {playerTable[i], 0})
		end
	end
	if caster.falling then
		caster.fallVelocity = caster.fallVelocity - 1
		caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, caster.fallVelocity))
		if caster.fallVelocity <= 0 then
			caster.falling = false
			caster.dispersion = true
		end
	end
	local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 100)
	caster:SetForwardVector(newFV)
	caster.interval = caster.interval + 1
	if caster.dispersion then
		if caster.interval % 10 == 0 then
			caster.interval = 0
			local collectionAmount = 1
			if caster.reward > 50000 then
				collectionAmount = 5000
			elseif caster.reward > 20000 then
				collectionAmount = 2000
			elseif caster.reward > 10000 then
				collectionAmount = 1000
			elseif caster.reward > 5000 then
				collectionAmount = 400
			elseif caster.reward > 2000 then
				collectionAmount = 200
			elseif caster.reward > 800 then
				collectionAmount = 100
			elseif caster.reward > 400 then
				collectionAmount = 50
			elseif caster.reward > 120 then
				collectionAmount = 20
			elseif caster.reward > 10 then
				collectionAmount = 5
			end
			local sizePerCrystal = caster.modelScale / caster.reward
			local newModelScale = caster.modelScale - (sizePerCrystal * collectionAmount)
			caster.modelScale = newModelScale
			caster:SetModelScale(newModelScale)
			for i = 1, #caster.winnerTable, 1 do
				local save_collectionAmount = collectionAmount
				if STARS_INCREASE_MITHRIL then
					local hero = caster.winnerTable[i]
					Stars:GetPlayerStars(hero:GetPlayerOwnerID())
					local stars = hero.grandTotalStars
					local mith_mult = 1
					if STARS_INCREASE_MITHRIL_ADDITIVE then
						mith_mult = (1 + stars * MITHRIL_INCREASE_PER_STAR_PCT / 100)
					else
						mith_mult = (1 + MITHRIL_INCREASE_PER_STAR_PCT / 100) ^ stars
					end
					collectionAmount = math.floor(collectionAmount * mith_mult)
				end
				createCollectionBeam(caster:GetAbsOrigin() + Vector(0, 0, 150), caster.winnerTable[i]:GetAbsOrigin())
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", caster.winnerTable[i], 0.5)
				caster.winnerTable[i].shardsPickedUp = caster.winnerTable[i].shardsPickedUp + collectionAmount
				CustomGameEventManager:Send_ServerToPlayer(caster.winnerTable[i]:GetPlayerOwner(), "collect_mithril", {gain = caster.winnerTable[i].shardsPickedUp})
				CustomGameEventManager:Send_ServerToPlayer(caster.winnerTable[i]:GetPlayerOwner(), "update_resources_increment", {increment = caster.winnerTable[i].shardsPickedUp, resource = "mithril"})
				collectionAmount = save_collectionAmount
			end
			for i = 1, #caster.rewardsTable, 1 do
				local save_collectionAmount = collectionAmount
				if STARS_INCREASE_MITHRIL then
					local hero = caster.winnerTable[i]
					Stars:GetPlayerStars(hero:GetPlayerOwnerID())
					local stars = hero.grandTotalStars
					local mith_mult = 1
					if STARS_INCREASE_MITHRIL_ADDITIVE then
						mith_mult = (1 + stars * MITHRIL_INCREASE_PER_STAR_PCT / 100)
					else
						mith_mult = (1 + MITHRIL_INCREASE_PER_STAR_PCT / 100) ^ stars
					end
					collectionAmount = math.floor(collectionAmount * mith_mult)
				end
				caster.rewardsTable[i][2] = caster.rewardsTable[i][2] + collectionAmount
				collectionAmount = save_collectionAmount
			end
			if collectionAmount == 1 then
				EmitSoundOn("Resource.MithrilShardCollect", caster)
			else
				EmitSoundOn("Resource.MithrilShardEnter", caster)
			end
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", caster, 0.5)

			caster.reward = caster.reward - collectionAmount
			if caster.reward <= 0 then
				caster.dispersion = false
				Timers:CreateTimer(2, function()
					caster.leaving = true
				end)
			end
		end
	end
	if caster.leaving then
		caster.fallVelocity = caster.fallVelocity + 1
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.fallVelocity))
		if caster.fallVelocity >= 45 then
			caster.leaving = false
			Challenges:SaveMithrilShards(caster.rewardsTable)
			UTIL_Remove(caster)
		end
	end
end

function createCollectionBeam(attachPointA, attachPointB)
	local particleName = "particles/items_fx/mithril_collect.vpcf"
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
	ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(lightningBolt, false)
	end)
end

function ability_1_position_think(event)
	local caster = event.caster
	local ability = event.ability
	local castAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)
	if caster.castLock then
		return false
	end
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = castAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
		end
	end
end

function ability_1_target_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if caster.castLock then
		return false
	end
	local radius = caster.targetRadius
	local minRadius = caster.minRadius
	local castAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)
	local cooldown = caster.targetAbilityCD * 2
	local targetFindOrder = caster.targetFindOrder
	if caster.interval % cooldown == 0 and caster.aggro then
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, targetFindOrder, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = castAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				if caster.castAnimation then
					StartAnimation(caster, {duration = 1, activity = caster.castAnimation, rate = 1})
				end
			end
		end
	end
	caster.interval = caster.interval + 1
	if caster.interval > 100 then
		caster.interval = 1
	end
end

function ability_1_no_target_ai(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if caster.castLock then
		return false
	end
	local radius = caster.targetRadius
	if not radius then
		radius = 800
	end
	local castAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)
	if not caster.autoAbilityCD then
		caster.aggro = true
		caster.autoAbilityCD = 1
		--print("ability_1_no_target_ai caster.autoAbilityCD")
		return
	end
	local cooldown = caster.autoAbilityCD * 2
	if caster.interval % cooldown == 0 and caster.aggro then
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = castAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				if caster.castSound then
					EmitSoundOn(caster.castSound, caster)
				end
			end
		end
	end
	caster.interval = caster.interval + 1
	if caster.interval > 100 then
		caster.interval = 1
	end
end

function ability_1_position_think_generic(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if caster.castLock then
		return false
	end
	local castAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)

	local radius = caster.targetRadius

	if not radius then
		radius = 800
	end	

	local minRadius = caster.minRadius
	if not caster.targetAbilityCD then
		caster.aggro = true
		caster.targetAbilityCD = 1
		--print("ability_1_position_think_generic caster.targetAbilityCD")
		return
	end
	local cooldown = caster.targetAbilityCD * 2
	local targetFindOrder = caster.targetFindOrder
	if caster.interval % cooldown == 0 and caster.aggro then
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, targetFindOrder, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				if caster.randomMissMin then
					castPoint = castPoint + RandomVector(RandomInt(caster.randomMissMin, caster.randomMissMax))
				end
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
				if caster.castSound then
					EmitSoundOn(caster.castSound, caster)
				end
			end
		end
	end
	caster.interval = caster.interval + 1
	if caster.interval > 100 then
		caster.interval = 1
	end
end

function hero_summon_think(event)
	local caster = event.caster
	if caster:GetUnitName() == "sorc_water_elemental" then
		SorcWaterElementalThink(caster)
	elseif caster:GetUnitName() == "jex_charged_mushroom" then
		jex_thundershroom_think(caster)
	elseif caster:GetUnitName() == "jex_cinderbark_treant" then
		jex_thundershroom_think(caster)
	end
end

function SorcWaterElementalThink(caster)
	local sorcPosition = caster.creator:GetAbsOrigin()
	local aspectPosition = caster:GetAbsOrigin()
	local position = sorcPosition + caster.creator:GetForwardVector() * 300 + RandomVector(RandomInt(0, 80))
	if WallPhysics:GetDistance(sorcPosition, aspectPosition) > 650 then
		caster:MoveToPosition(position)
	else
		caster:MoveToPositionAggressive(position)
	end
end

function jex_thundershroom_think(caster)
	local sorcPosition = caster.summoner:GetAbsOrigin()
	local aspectPosition = caster:GetAbsOrigin()
	local position = sorcPosition + caster.summoner:GetForwardVector() * 300 + RandomVector(RandomInt(0, 80))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		return false
	end
	if WallPhysics:GetDistance(sorcPosition, aspectPosition) > 1000 then
		caster:MoveToPosition(position)
	else
		caster:MoveToPositionAggressive(position)
	end
end

function hero_summon_on(event)
	local caster = event.caster
	caster:SetAcquisitionRange(3000)
	if caster:GetUnitName() == "sorc_water_elemental" then
		caster.creator.bIsAIon = true
	elseif caster:GetUnitName() == "earth_aspect" then
		caster.conjuror.bIsAIonEARTH = true
	elseif caster:GetUnitName() == "fire_aspect" then
		caster.conjuror.bIsAIonFIRE = true
	elseif caster:GetUnitName() == "shadow_aspect" then
		caster.conjuror.bIsAIonSHADOW = true
	end
end

function hero_summon_off(event)
	local caster = event.caster
	caster:SetAcquisitionRange(500)
	if caster:GetUnitName() == "sorc_water_elemental" and caster:GetHealth() > 0 then
		caster.creator.bIsAIon = false
	elseif caster:GetUnitName() == "earth_aspect" and caster:GetHealth() > 0 then
		caster.conjuror.bIsAIonEARTH = false
	elseif caster:GetUnitName() == "fire_aspect" and caster:GetHealth() > 0 then
		caster.conjuror.bIsAIonFIRE = false
		--print("here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	elseif caster:GetUnitName() == "shadow_aspect" and caster:GetHealth() > 0 then
		caster.conjuror.bIsAIonSHADOW = false
	end
end

function find_clear_space(event)
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function dialogue_leash_think(event)
	local hero = event.target
	local leashUnit = hero.dialogueUnit
	local distance = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), leashUnit:GetAbsOrigin())
	if distance > 500 then
		hero:RemoveModifierByName("modifier_dialogue_leash")
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_basic_dialogue", {})
	end
end

function world1_wave_unit_die(event)
	if not GameRules.Quest then
		GameRules.Quest = {}
		GameRules.Quest.UnitsKilled = 0
		GameRules.Quest.UnitsKilledPart = 0
		GameRules.Quest.Subwave = 0

	end
	GameRules.Quest.UnitsKilled = GameRules.Quest.UnitsKilled + 1
	GameRules.Quest.UnitsKilledPart = GameRules.Quest.UnitsKilledPart + 1

	if GameRules.Quest.UnitsKilledPart == GameRules.Quest.KillLimit1 and GameRules.Quest.Subwave == 0 then
		Events:wave_redirect()
		GameRules.Quest.UnitsKilledPart = 0
		GameRules.Quest.Subwave = GameRules.Quest.Subwave + 1
	end
	if GameRules.Quest.UnitsKilledPart == GameRules.Quest.KillLimit2 and GameRules.Quest.Subwave == 1 then
		Events:wave_redirect()
		GameRules.Quest.UnitsKilledPart = 0
		GameRules.Quest.Subwave = GameRules.Quest.Subwave + 1
	end
	if GameRules.Quest.UnitsKilledPart == GameRules.Quest.KillLimit3 and GameRules.Quest.Subwave == 2 then
		Events:wave_redirect()
		GameRules.Quest.UnitsKilledPart = 0
		GameRules.Quest.Subwave = GameRules.Quest.Subwave + 1
	end
	if GameRules.Quest.UnitsKilled == GameRules.Quest.KillLimit then

		EmitGlobalSound("Tutorial.Quest.complete_01")
		Notifications:TopToAll({image = "file://{images}/custom_game/text/wave-clear-simple.png", duration = 4.0})
		Timers:CreateTimer(3, function()
			GameRules.Quest:CompleteQuest()
			GameRules.Quest.UnitsKilled = -100
			GameRules.Quest.KillLimit = -1000
			Beacons:WaveClear(Events.WaveNumber)
		end)
		--Timers:CreateTimer(8,
		--  function()
		--  Events:killOffWave()
		--  end)
	end
end

function dungeon_thinker_activate(event)
	local caster = event.caster
	--print("DUNGEON THINKER ACTIVATE")
	if caster.name == "crimsythCastleSwitch" then
		Redfall:CastleWaterRoomSwitch(caster)
	elseif caster.name == "waterTempleSnakeSwitch" then
		Tanari:SerpentSwitchActivate(caster)
	elseif caster.name == "rubicksSwitch" then
		Tanari:WaterTempleRubicksSwitch(caster)
	end
end

function recently_respawn_end(event)
	local target = event.target
	target:SetHealth(target:GetMaxHealth())
	target:SetMana(target:GetMaxMana())
end

function ms_thinker(event)
	local unit = event.target
	unit:RemoveModifierByName("modifier_master_movespeed")
	local baseSpeed = unit:GetBaseMoveSpeed()
	local modifier = unit:GetMoveSpeedModifier(baseSpeed, false)
	local modifier2 = unit:GetMoveSpeedModifier(0, false)

	local buffs = unit:FindAllModifiers()
	local speed = baseSpeed
	local mult = 1
	for _,modifier in pairs(buffs) do

		if modifier['GetModifierMoveSpeedBonus_Constant'] then
			local localSpeed =  modifier['GetModifierMoveSpeedBonus_Constant'](modifier, {}) or 0
			if localSpeed ~=  nil then
				speed = speed + localSpeed
			end
		end
		if modifier['GetModifierMoveSpeedBonus_Percentage'] then
			local localMult = modifier['GetModifierMoveSpeedBonus_Percentage'](modifier, {})
			if localMult ~= nil then
				mult = mult + localMult/100
			end
		end
	end
	speed = math.max(speed * mult, baseSpeed + modifier2)
	local movespeedMult = 1;

	local ideal = unit:GetIdealSpeed()
	local max_ms = CustomAttributes:MSCap(unit)
	--speed = math.max(modifier2 + baseSpeed, speed)
	if speed > 100 and max_ms > 550 then
		unit.master_move_speed = math.min(speed, max_ms)
		unit:AddNewModifier(unit, nil, "modifier_master_movespeed", {})
	else
		unit.master_move_speed = nil
		unit:RemoveModifierByName("modifier_master_movespeed")
	end
end


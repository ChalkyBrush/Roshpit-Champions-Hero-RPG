function grizzly_woodsman_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1})
		EmitSoundOn("tusk_tusk_move_15", caster)
		Timers:CreateTimer(0.1, function()
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "DOTA_Item.DustOfAppearance.Activate", caster)
			local spellPoint = caster:GetAbsOrigin() + caster:GetForwardVector() * 200
			local particleName = "particles/items_fx/dust_of_appearance.vpcf"
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particle1, 0, spellPoint)
			ParticleManager:SetParticleControl(particle1, 1, Vector(400, 100, 1))
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), spellPoint, nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for i = 1, #enemies, 1 do
				ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_grizzled_tank_debuff", {duration = 6})
			end
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(particle1, false)
			end)
		end)
	end
end

function twilight_worshipper_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 0
		caster.crowTable = {}
	end
	if not caster.aggro and caster.interval == 6 then
		local minX = -13898
		local minY = -1170
		local maxX = -12928
		local maxY = 384
		local xCoordinate = RandomInt(minX, maxX)
		local yCoordinate = RandomInt(minY, maxY)
		caster:MoveToPosition(Vector(xCoordinate, yCoordinate))
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	local ability = event.ability
	local cask = caster:FindAbilityByName("witch_doctor_paralyzing_cask")
	if cask:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = enemies[1]:entindex(),
				AbilityIndex = cask:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(1, function()
				cask:StartCooldown(7)
			end)
		end
	end
end

function twilight_crow_cultist_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		if not caster.interval then
			caster.interval = 0
			caster:RemoveModifierByName("modifier_twilight_crow_summoning")
			caster.bonus = 0
		end
		if caster.interval % 3 == 0 then
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_FLAIL, rate = 0.7, translate = "forcestaff_friendly"})
			WallPhysics:Jump(caster, caster:GetForwardVector(), 50 + caster.bonus * 15, 15, 2, 0.7)
			EmitSoundOn("DOTA_Item.ForceStaff.Activate", caster)
		end
		caster.interval = caster.interval + 1
		if caster.interval > 10 then
			local soundTable = {"shadowshaman_shad_laugh_06", "shadowshaman_shad_laugh_09"}
			EmitSoundOn(soundTable[RandomInt(1, 2)], caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_twilight_crow_summoning", {duration = 1})
			caster.interval = 0
			caster.crowTable = {}
			for i = 1, 10 + caster.bonus * 4, 1 do
				Timers:CreateTimer(0.3 * i, function()
					local summonPos = caster:GetAbsOrigin() + RandomVector(RandomInt(50, 600 + caster.bonus * 200))
					local crow = Dungeons:SpawnDungeonUnit("twilight_crow_summon", summonPos, 1, 0, 0, "Hero_Phoenix.Attack", caster:GetForwardVector(), true, nil)
					local crowAbility = crow:FindAbilityByName("twilight_crow_summon_ai")
					crowAbility:ApplyDataDrivenModifier(crow, crow, "modifier_twilight_crow_summon_ai", {duration = 10})
					table.insert(caster.crowTable, crow)
				end)
			end
		end
		if not caster.stageTwo then
			if caster:GetHealth() < caster:GetMaxHealth() * 0.4 then
				caster.stageTwo = true
				caster.bonus = 1
				caster:SetModelScale(2.4)
				EmitGlobalSound("Conquest.poison.hallow_scream")
				EmitGlobalSound("Conquest.poison.hallow_scream")
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_twilight_crow_stage_two", {})
				caster:SetRenderColor(255, 250, 250)
			end
		end
	end
end

function twilight_crow_summon_think(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_twilight_crow_moving", {duration = 1})
	local vecTable = {Vector(1, 0), Vector(-1, 0), Vector(0, 1), Vector(0, -1)}
	caster.moveVec = vecTable[RandomInt(1, 4)]
	EmitSoundOn("Hero_Phoenix.Attack", caster)
end

function sleepy_ogre_attack_land(event)
	local caster = event.caster
	if not Dungeons.tank_ally:IsNull() then
		Dungeons.tank_ally:MoveToPositionAggressive(caster:GetAbsOrigin())
	end
	if not Dungeons.healer_ally:IsNull() then
		Dungeons.healer_ally:MoveToPositionAggressive(caster:GetAbsOrigin())
	end
end

function crow_cultist_die(event)
	local caster = event.caster
	local crowTable = caster.crowTable
	if crowTable then
		for i = 1, #crowTable, 1 do
			crowTable[i]:RemoveModifierByName("modifier_twilight_crow_summon_ai")
		end
	end
	local luck = RandomInt(1, 4)
	if luck == 4 then
		RPCItems:RollBlackfeatherCrown(caster:GetAbsOrigin())
	end
	Dungeons.healer_ally:RemoveModifierByName("modifier_grizzly_helper_stage_one")
	Dungeons.tank_ally:RemoveModifierByName("modifier_grizzly_helper_stage_one")
	Events:AdjustDeathXP(Dungeons.tank_ally)
	Events:AdjustDeathXP(Dungeons.healer_ally)
	Dungeons.grizzlyStatus = 1
	-- apply modifier_grizzly_helper_ai
	Dungeons.tank_ally:AddSpeechBubble(1, "#grizzly_dialogue_one", 5, 0, 0)
	EmitSoundOn("sven_sven_thanks_02", Dungeons.tank_ally)
	WallPhysics:Jump(Dungeons.tank_ally, Vector(1, 1), 0, 15, 2, 1.2)
	WallPhysics:Jump(Dungeons.healer_ally, Vector(1, 1), 0, 15, 2, 1.2)
	local fv = (MAIN_HERO_TABLE[1]:GetAbsOrigin() * Vector(1, 1, 0) - Dungeons.healer_ally:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	Dungeons.healer_ally:SetForwardVector(fv)
	Dungeons.tank_ally:SetForwardVector(fv)
	Timers:CreateTimer(5.1, function()
		Dungeons.tank_ally:AddSpeechBubble(1, "#grizzly_dialogue_two", 5, 0, 0)
		Timers:CreateTimer(2.8, function()
			Dungeons.healer_ally:AddSpeechBubble(2, "#grizzly_dialogue_three", 3, 0, 0)
			EmitSoundOn("lina_lina_laugh_01", Dungeons.healer_ally)
		end)
		Timers:CreateTimer(5.1, function()
			Dungeons.tank_ally:AddSpeechBubble(1, "#grizzly_dialogue_four", 5, 0, 0)
			EmitSoundOn("sven_sven_level_05", Dungeons.tank_ally)
			Dungeons.tank_ally:MoveToPosition(Vector(-13440, 3520))
			Dungeons.healer_ally:MoveToPosition(Vector(-13440, 3520))
			Timers:CreateTimer(2, function()
				EmitSoundOn("lina_lina_laugh_02", Dungeons.healer_ally)
			end)
		end)
	end)
	ParticleManager:DestroyParticle(Dungeons.shackleParticle1, false)
	ParticleManager:DestroyParticle(Dungeons.shackleParticle2, false)
	EmitGlobalSound("Hero_Chen.TeleportOut")
	local tankAbility = Dungeons.tank_ally:FindAbilityByName("grizzly_helper_ai")
	tankAbility:ApplyDataDrivenModifier(Dungeons.tank_ally, Dungeons.tank_ally, "modifier_grizzly_helper_ai", {})
	local healAbility = Dungeons.healer_ally:FindAbilityByName("grizzly_helper_ai")
	healAbility:ApplyDataDrivenModifier(Dungeons.healer_ally, Dungeons.healer_ally, "modifier_grizzly_helper_ai", {})
end

function twilight_crow_moving_think(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin() + caster.moveVec * 30)
end

function twilight_crow_end(event)
	local caster = event.caster
	UTIL_Remove(caster)
end

function twilight_guardian_think(event)
	local caster = event.caster
	local minX1 = -14243
	local maxX1 = -13795
	local maxY1 = 7872
	local minY1 = 4420
	local minX2 = -13062
	local maxX2 = -12825
	local zSpot = 360
	if caster.bossMedusa then
		minX1 = -10368
		maxX1 = -9963
		maxY1 = -2433
		minY1 = -3213
		minX2 = -10368
		maxX2 = -9963
		zSpot = 620
	end
	for i = 1, 15, 1 do
		Timers:CreateTimer(0.03 * i, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 3) * i)
		end)
	end
	Timers:CreateTimer(1, function()
		local side = RandomInt(1, 3)
		local moveToVector = Vector(0, 0)
		if side == 3 then
			moveToVector = Vector(RandomInt(minX2, maxX2), RandomInt(minY1, maxY1), zSpot)
		else
			moveToVector = Vector(RandomInt(minX1, maxX1), RandomInt(minY1, maxY1), zSpot)
		end
		caster:SetAbsOrigin(moveToVector)
		local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		for j = 0, 4, 1 do
			ParticleManager:SetParticleControl(pfx, j, moveToVector)
		end
		StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_SPAWN, rate = 1})
		EmitSoundOn("medusa_medus_anger_03", caster)
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
end

function grizzly_falls_boss_arrow_hit(event)
	local caster = event.caster
	local target = event.target
	local damage = Events:GetAdjustedAbilityDamage(600, 12000, 20000)
	--print("arrow hit")
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function grizzly_sleepy_ogre_think(event)
end

function grizzly_sleepy_ogre_sleeping_think(event)
	local caster = event.caster
end

function grizzly_helper_think(event)
	local caster = event.caster
	if Dungeons.grizzlyStatus == 2 then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			if MAIN_HERO_TABLE[i]:GetAbsOrigin().x > -11456 and MAIN_HERO_TABLE[i]:IsAlive() then
				caster:MoveToPositionAggressive(MAIN_HERO_TABLE[i]:GetAbsOrigin() + RandomVector(150))
				break
			end
		end
	elseif Dungeons.grizzlyStatus == 3 then
		if Dungeons.medusaBoss then
			if caster:GetUnitName() == "grizzly_ally_tank" then
				local distance = WallPhysics:GetDistance(caster:GetAbsOrigin() * Vector(1, 1, 0), Dungeons.medusaBoss:GetAbsOrigin() * Vector(1, 1, 0))
				if distance > 500 then
					caster:MoveToPositionAggressive(Dungeons.medusaBoss:GetAbsOrigin())
					Timers:CreateTimer(0.2, function()
						EmitSoundOn("sven_sven_level_05", caster)
						StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_SPAWN, rate = 1})
						local jumpFV = (Dungeons.medusaBoss:GetAbsOrigin() * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
						WallPhysics:Jump(caster, jumpFV, 30, 45, 3, 1)
					end)
				end
			end
		end
	end
	if caster:GetUnitName() == "grizzly_ally_tank" then
		local warcryAbil = caster:FindAbilityByName("grizzly_tank_ally_warcry")
		if warcryAbil:IsFullyCastable() then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = warcryAbil:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
		end
	elseif caster:GetUnitName() == "grizzly_ally_healer" then
		if not Dungeons.tank_ally:IsNull() then
			local distance = WallPhysics:GetDistance(Dungeons.tank_ally:GetAbsOrigin(), caster:GetAbsOrigin())
			if distance > 700 then
				if Dungeons.grizzlyStatus == 1 then
					caster:MoveToPosition(Dungeons.tank_ally:GetAbsOrigin() + Vector(0, -300, 0))
				else
					caster:MoveToPosition(Dungeons.tank_ally:GetAbsOrigin() + RandomVector(200))
				end
			end
		end
		local flashHeal = caster:FindAbilityByName("grizzly_healer_flash_heal")
		if flashHeal:IsFullyCastable() then
			local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
			local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #allies > 0 then
				for i = 1, #allies, 1 do
					if allies[i]:GetHealth() < (allies[i]:GetMaxHealth() * 0.7) then
						local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							TargetIndex = allies[i]:entindex(),
							AbilityIndex = flashHeal:entindex(),
						}
						ExecuteOrderFromTable(newOrder)
						break
					end
				end
			end
		else
		end
		local holyShield = caster:FindAbilityByName("grizzly_healer_holy_shield")
		if holyShield:IsFullyCastable() and (caster:GetHealth() < caster:GetMaxHealth() * 0.4) then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = holyShield:entindex(),
			}
			ExecuteOrderFromTable(newOrder)
		end
	end

end

function grizzly_helper_flash_heal(event)
	local target = event.target
	local caster = event.caster
	EmitSoundOn("Grizzly.AllyHeal", target)
	local healMult = 0.3
	if target.paragon then
		healMult = 0.07
	end
	local healAmount = caster:GetMaxHealth() * healMult
	target:Heal(healAmount, caster)
	PopupHealing(target, healAmount)
	local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

end

function ancient_crag_golem_think(event)
	-- local caster = event.caster
	-- local avalanche = caster:FindAbilityByName("creature_avalanche")
	-- if caster.aggro then
	-- if avalanche:IsFullyCastable() then
	-- local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 620, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	-- if #enemies > 0 then
	-- local targetPoint = enemies[1]:GetAbsOrigin()
	-- local order =
	-- {
	-- UnitIndex = caster:entindex(),
	-- OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
	-- AbilityIndex = avalanche:entindex(),
	-- Position = targetPoint
	-- }
	-- ExecuteOrderFromTable(order)
	-- end
	-- end
	-- end
end

function granite_app_think(event)
	local caster = event.caster
	if caster.aggro then
		local avalanche = caster:FindAbilityByName("creature_avalanche")
		local meteor = caster:FindAbilityByName("custom_meteor")
		local iceBlast = caster:FindAbilityByName("freeze_fiend_crystal_nova")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 720, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local ability = false
			if avalanche:IsFullyCastable() then
				ability = avalanche
			elseif meteor:IsFullyCastable() then
				ability = meteor
			elseif iceBlast:IsFullyCastable() then
				ability = iceBlast
			end
			if ability then
				local targetPoint = enemies[1]:GetAbsOrigin()
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
			end
		end
	end
end

function grizzly_cave_shroom_think(event)
	local caster = event.caster
	if caster.aggro then
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		Timers:CreateTimer(0.03, function()
			EmitSoundOn("Redfall.Shroom.Aggro", caster)
		end)
		caster:RemoveModifierByName("modifier_cave_shroom_ai")
		StartAnimation(caster, {duration = 0.84, activity = ACT_DOTA_SPAWN, rate = 1})
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shroom_jumping", {duration = 0.84})
		local position = caster:GetAbsOrigin()
		caster.liftVelocity = 21
		for i = 1, 28, 1 do
			Timers:CreateTimer(0.03 * i, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.liftVelocity))
				caster.liftVelocity = caster.liftVelocity - 1.5
			end)
		end
		Timers:CreateTimer(0.84, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end
end

function medusa_acolyte_think(event)
	local caster = event.caster
	if not caster.aggro then
		if caster.ally.aggro then
			ApplyDamage({victim = caster, attacker = caster.ally, damage = 1, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	else
		if IsValidEntity(caster.ally) and caster.ally:IsAlive() then
			local purification = caster:FindAbilityByName("creature_purification")
			if purification:IsFullyCastable() then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = caster.ally:entindex(),
					AbilityIndex = purification:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				local soundTable = {"medusa_medus_deny_20", "medusa_medus_deny_18", "medusa_medus_happy_04"}
				EmitSoundOn(soundTable[RandomInt(1, 3)], caster)
			end
		end
		local shield = caster:FindAbilityByName("grizzly_healer_holy_shield")
		if shield:IsFullyCastable() then
			if caster:GetHealth() < caster:GetMaxHealth() * 0.5 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = shield:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function medusa_acolyte_die(event)
	Dungeons.acolyteKills = Dungeons.acolyteKills + 1
	if Dungeons.acolyteKills == 2 then
		UTIL_Remove(Dungeons.blocker1)
		UTIL_Remove(Dungeons.blocker2)
		UTIL_Remove(Dungeons.blocker3)
		UTIL_Remove(Dungeons.blocker4)
		UTIL_Remove(Dungeons.blocker5)
		Dungeons.blocker1 = nil
		Dungeons.blocker2 = nil
		Dungeons.blocker3 = nil
		Dungeons.blocker4 = nil
		Dungeons.blocker5 = nil
		ParticleManager:DestroyParticle(Dungeons.wallParticle, false)
		Dungeons:CreateDungeonThinker(Vector(-10176, -1724), "boss_entrance", 440, "grizzly_falls")
	end
end

function grizzly_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.realBoss and not caster.deathStart then
		local screamAbility = caster:FindAbilityByName("grizzly_boss_slow_scream")
		local torrentAbility = caster:FindAbilityByName("grizzly_boss_torrents")
		if screamAbility:IsFullyCastable() then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = screamAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
		elseif torrentAbility:IsFullyCastable() then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = torrentAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			tank_run(caster)
		end
		if not caster.interval then
			caster.interval = 0
		end
		if caster.interval % 2 == 0 then
			caster:Stop()
		end
		caster.interval = caster.interval + 1
		if caster.interval % 8 == 0 then
			boss_arrows(caster, ability)
		end
		if caster.interval == 20 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_grizzly_falls_descending", {duration = 3})
			boss_descend(caster)
			caster.interval = 0
		end
	end

end

function tank_run(medusaBoss)
	if not Dungeons.tank_ally:IsNull() then
		local tank = Dungeons.tank_ally
		StartAnimation(tank, {duration = 0.8, activity = ACT_DOTA_SPAWN, rate = 1})
		local jumpFV = (tank:GetAbsOrigin() * Vector(1, 1, 0) - medusaBoss:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
		tank:SetForwardVector(jumpFV)
		tank:MoveToPosition(tank:GetAbsOrigin() + jumpFV * 500)
		WallPhysics:Jump(tank, jumpFV, 35, 45, 3, 1)
	end
end

function boss_arrows(medusaBoss, bossAbility)

	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", medusaBoss:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	visionTracer:SetAbsOrigin(medusaBoss:GetAbsOrigin() + Vector(0, 0, 600))
	local soundTable = {"medusa_medus_anger_11", "medusa_medus_splitshot_05", "medusa_medus_splitshot_02"}
	local luck = RandomInt(1, 3)
	EmitGlobalSound(soundTable[luck])

	for k = 0, 1, 1 do
		Timers:CreateTimer(1.3 * k, function()
			StartAnimation(medusaBoss, {duration = 2.5, activity = ACT_DOTA_ATTACK, rate = 0.5})
			EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "Ability.PowershotPull", medusaBoss)
			Timers:CreateTimer(0.9, function()
				EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "Hero_DrowRanger.FrostArrows", medusaBoss)
				for i = -7, 7, 1 do
					rotatedVector = WallPhysics:rotateVector(medusaBoss:GetForwardVector(), math.pi / 40 * i)
					arrowOrigin = visionTracer:GetAbsOrigin() + medusaBoss:GetForwardVector() * Vector(80, 80, 0)
					local start_radius = 110
					local end_radius = 110
					local speed = 1100
					local range = 2000
					local info =
					{
						Ability = bossAbility,
						EffectName = "particles/frostivus_herofx/medusa_linear_arrow.vpcf",
						vSpawnOrigin = arrowOrigin,
						fDistance = range,
						fStartRadius = start_radius,
						fEndRadius = end_radius,
						Source = visionTracer,
						bHasFrontalCone = false,
						bReplaceExisting = false,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						fExpireTime = GameRules:GetGameTime() + 5.0,
						bDeleteOnHit = false,
						vVelocity = rotatedVector * speed,
						bProvidesVision = false,
					}
					projectile = ProjectileManager:CreateLinearProjectile(info)
				end
			end)
		end)
	end
	Timers:CreateTimer(5, function()
		UTIL_Remove(visionTracer)
	end)
end

function boss_descend(medusaBoss)
	ScreenShake(Vector(-13504, 6272), 300, 1.1, 0.7, 9000, 0, true)
	for j = 1, 40, 1 do
		Timers:CreateTimer(0.03 * j, function()
			medusaBoss:SetAbsOrigin(medusaBoss:GetAbsOrigin() - Vector(0, 0, 30))
		end)
	end
	local origPos = medusaBoss:GetAbsOrigin()
	Timers:CreateTimer(0.57, function()
		for i = 1, 4, 1 do
			local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
			local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, medusaBoss)
			ParticleManager:SetParticleControl(particle2, 0, origPos - Vector(0, 0, 110) + RandomVector(120))
			ScreenShake(origPos, 200, 0.9, 10 * 0.05, 9000, 0, true)
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(particle2, false)
			end)
		end
		local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, medusaBoss)
		ParticleManager:SetParticleControl(particle1, 0, origPos - Vector(0, 0, 140))
		ScreenShake(origPos, 200, 0.9, 10 * 0.05, 9000, 0, true)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		EmitSoundOn("Ability.Torrent", medusaBoss)
	end)
	Timers:CreateTimer(1, function()
		boss_ascend(medusaBoss)
	end)
end

function boss_ascend(medusaBoss)

	Timers:CreateTimer(1, function()
		EmitGlobalSound("Tiny.Grow")
		ScreenShake(Vector(-10176, -2816), 300, 1.1, 0.7, 9000, 0, true)
	end)
	Timers:CreateTimer(2, function()
		EmitGlobalSound("Tiny.Grow")
		ScreenShake(Vector(-10176, -2816), 300, 1.1, 0.7, 9000, 0, true)
		local origPos = Vector(-10176, -2816)
		medusaBoss:SetAbsOrigin(origPos - Vector(0, 0, 700))
		medusaBoss:SetForwardVector(Vector(1, 0))
		for k = 1, 50, 1 do
			Timers:CreateTimer(k * 0.03, function()
				medusaBoss:SetAbsOrigin(medusaBoss:GetAbsOrigin() + Vector(0, 0, 22))
			end)
		end
		-- Timers:CreateTimer(0.5, function()
		-- EmitSoundOnLocationWithCaster(medusaBoss:GetAbsOrigin(), "Hero_Medusa.StoneGaze.Cast", medusaBoss)

		-- end)
		local bossAbility = medusaBoss:FindAbilityByName("grizzly_falls_boss_ai")
		Timers:CreateTimer(0.87, function()
			for i = 1, 7, 1 do
				particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
				local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, medusaBoss)
				ParticleManager:SetParticleControl(particle2, 0, origPos + Vector(0, 0, 210) + RandomVector(120))
				ScreenShake(origPos, 200, 0.9, 10 * 0.05, 9000, 0, true)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle2, false)
				end)
			end
			particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, medusaBoss)
			ParticleManager:SetParticleControl(particle1, 0, origPos + Vector(0, 0, 220))
			ScreenShake(origPos, 200, 0.9, 10 * 0.05, 9000, 0, true)
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(particle1, false)
			end)
			EmitSoundOn("Ability.Torrent", medusaBoss)
		end)
		Timers:CreateTimer(1, function()
			for i = 1, 5, 1 do
				local minX1 = -10368
				local maxX1 = -9963
				local maxY1 = -2433
				local minY1 = -3213
				local moveToVector = Vector(0, 0)

				moveToVector = Vector(RandomInt(minX1, maxX1), RandomInt(minY1, maxY1))

				local medusa = Dungeons:SpawnDungeonUnit("grizzly_twilight_guardian", moveToVector, 1, 0, 0, "medusa_medus_anger_11", Vector(0, -1), true, nil)

				medusa:SetAbsOrigin(GetGroundPosition(medusa:GetAbsOrigin(), medusa) - Vector(0, 0, 1100))
				for i = 1, 20, 1 do
					medusa:SetAbsOrigin(medusa:GetAbsOrigin() + Vector(0, 0, 5) * i)
				end
				local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, medusa)
				for j = 0, 4, 1 do
					ParticleManager:SetParticleControl(pfx, j, moveToVector)
				end
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				medusa:SetDeathXP(0)
				medusa:SetMinimumGoldBounty(0)
				medusa:SetMaximumGoldBounty(0)
				medusa.bossMedusa = true
			end
		end)
	end)
end

function boss_scream_begin(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Medusa.StoneGaze.Cast", caster)
	-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Medusa.StoneGaze.Cast", caster)
	StartAnimation(caster, {duration = 8, activity = ACT_DOTA_MEDUSA_STONE_GAZE, rate = 0.3})
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for i = 1, #enemies, 1 do
		ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_grizzly_falls_slow_debuff", {duration = 4.5})
		if enemies[i]:GetUnitName() == "grizzly_ally_tank" then
			ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_grizzly_falls_disable_debuff", {duration = 4})
		end

	end
	CustomGameEventManager:Send_ServerToAllClients("grizzly_medusa_event", {duration = 5})
	for i = 1, 9, 1 do
		Timers:CreateTimer(0.5 * i, function()
			ScreenShake(caster:GetAbsOrigin(), (10 - i) * 50, 0.9, 0.5, 9000, 0, true)
		end)
	end
end

function boss_torrent_begin(event)
	local caster = event.caster
	local ability = event.ability
	local soundTable = {"medusa_medus_laugh_04", "medusa_medus_levelup_08", "medusa_medus_anger_11", "medusa_medus_anger_13", "medusa_medus_anger_04"}
	EmitGlobalSound(soundTable[RandomInt(1, 5)])
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
	CustomGameEventManager:Send_ServerToAllClients("grizzly_medusa_event", {duration = 1.1})
	Timers:CreateTimer(0.8, function()
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ability.Torrent", caster)
		ScreenShake(caster:GetAbsOrigin(), 200, 0.9, 10 * 0.05, 9000, 0, true)
		local torrentCount = 15
		if caster:GetHealth() < caster:GetMaxHealth() * 0.4 then
			torrentCount = 25
		elseif caster:GetHealth() < caster:GetMaxHealth() * 0.7 then
			torrentCount = 20
		end
		for i = 1, 14, 1 do
			local position = Vector(0, 0)
			local region = RandomInt(1, 10)
			if region <= 5 then
				local minX = -10384
				local maxX = -9987
				local minY = -3189
				local maxY = -2440
				position = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
			elseif region < 8 then
				local minX = -10961
				local maxX = -9174
				local minY = -3696
				local maxY = -2133
				position = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
			elseif region < 9 then
				local minX = -10936
				local maxX = -9694
				local minY = -2039
				local maxY = -1505
				position = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
			else
				local minX = -10613
				local maxX = -9628
				local minY = -4479
				local maxY = -3837
				position = Vector(RandomInt(minX, maxX), RandomInt(minY, maxY))
			end
			position = GetGroundPosition(position, caster)
			create_torrent(position, caster, ability)

		end
	end)
end

function create_torrent(position, caster, ability)
	particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, position + Vector(0, 0, 40))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for i = 1, #enemies, 1 do
		ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_grizzly_torrent_slow_debuff", {duration = 3})
		local damage = Events:GetAdjustedAbilityDamage(800, 16000, 30000)
		ApplyDamage({victim = enemies[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		local enemyPos = enemies[i]:GetAbsOrigin()
		local modifierKnockback =
		{
			center_x = enemyPos.x,
			center_y = enemyPos.y,
			center_z = enemyPos.z,
			duration = 1.3,
			knockback_duration = 1.3,
			knockback_distance = 0,
			knockback_height = 400,
		}
		enemies[i]:AddNewModifier(enemies[i], nil, "modifier_knockback", modifierKnockback)
	end
end

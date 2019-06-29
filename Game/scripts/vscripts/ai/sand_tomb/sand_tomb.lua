function sand_tomb_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.firePhase then
		ability.firePhase = 0
	end
	fireTrap(ability.firePhase, ability, caster, true)
	-- fireTrap(ability.firePhase+6, ability, caster, false)
	ability.firePhase = ability.firePhase + 1
	if ability.firePhase > 12 then
		ability.firePhase = 0
	end
end

function fireTrap(phase, ability, caster, bSound)
	if phase > 12 then
		phase = phase - 12
	end
	local originVector = Vector(0, 0)
	local fv = Vector(0, 0)
	if phase % 2 == 0 then
		originVector = Vector(9114, -7118 - phase * 110)
		fv = Vector(1, 0)
	else
		originVector = Vector(9578, -7118 - phase * 110)
		fv = Vector(-1, 0)
	end
	if bSound then
		EmitSoundOnLocationWithCaster(originVector + Vector(-400, 0), "Hero_EmberSpirit.FireRemnant.Cast", caster)
	end
	local speed = 500
	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		vSpawnOrigin = originVector,
		fDistance = 420,
		fStartRadius = 100,
		fEndRadius = 200,
		Source = caster,
		StartPosition = "custom_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function fireTrapImpact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Hero_SkeletonKing.Hellfire_Blast", target)
	local damage = Events:GetAdjustedAbilityDamage(1200, 35000, 0)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	PopupDamage(target, damage)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_fire_trap_burning", {duration = 4})
end

function SpikeDamage(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Hero_NyxAssassin.SpikedCarapace", target)
	local damage = Events:GetAdjustedAbilityDamage(500, 5000, 0)
	ApplyDamage({victim = target, attacker = Events.GameMaster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	PopupDamage(target, damage)
end

function pudgeThink(event)
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local hook = caster:FindAbilityByName("creature_meat_hook")
		local order =
		{
			UnitIndex = caster:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = hook:GetEntityIndex(),
			Position = enemies[1]:GetAbsOrigin(),
			Queue = false
		}
		ExecuteOrderFromTable(order)
	end
end

function vacuum_channel_think(event)
	local ability = event.ability
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local particleName = "particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf"
		local particleVector = point
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, dummy)
		ParticleManager:SetParticleControl(pfx, 0, particleVector)
		ParticleManager:SetParticleControl(pfx, 1, Vector(650, 650, 650))
		StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CHANNEL_ABILITY_4, rate = 1.4})
		EmitSoundOn("Hero_Bane.BrainSap", caster)
		for _, enemy in pairs(enemies) do
			local movementVector = (enemy:GetAbsOrigin() - point):Normalized()
			enemy.vacuumDirection = movementVector *- 1
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_creature_vacuumed", {duration = 0.9})

		end
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function vacuum_target_thinker(event)
	local ability = event.ability
	local target = event.target
	target:SetAbsOrigin(target:GetAbsOrigin() + target.vacuumDirection * 15)
end

function vacuuming_end(event)
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function relic_think(event)
	local ability = event.ability
	if not ability.crixalisOver then
		if ability.lifting then
			ability.liftVelocity = ability.liftVelocity + 1
			ability.liftPos = ability.liftPos + ability.liftVelocity
			ability.totalLift = ability.totalLift + 10
		else
			ability.liftVelocity = ability.liftVelocity - 1
			ability.liftPos = ability.liftPos + ability.liftVelocity
			ability.totalLift = ability.totalLift + 10
		end
		if ability.totalLift % 400 == 100 then
			ability.lifting = false
		end
		if (ability.totalLift + 200) % 400 == 100 then
			ability.lifting = true
		end
		if ability.totalLift % 400 == 0 and not ability.crixalisEvent then
			local radius = 240
			local position = ability.relic:GetAbsOrigin()
			local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
			local target_types = DOTA_UNIT_TARGET_HERO
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local units = FindUnitsInRadius(ability.relic:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #units > 0 then
				EmitSoundOn("compendium_points", units[1])
				EmitSoundOn("compendium_points", units[1])
				EmitSoundOn("compendium_points", units[1])
				Timers:CreateTimer(2, function()
					EmitSoundOn("Hero_Brewmaster.DrunkenHaze.Target", units[1])
					EmitSoundOn("Hero_Brewmaster.DrunkenHaze.Target", units[1])
					EmitSoundOn("Hero_Brewmaster.DrunkenHaze.Target", units[1])
					EmitSoundOn("Hero_Brewmaster.DrunkenHaze.Target", units[1])
					ScreenShake(ability.relic:GetAbsOrigin(), 200, 0.5, 5, 9000, 0, true)
				end)
				ability.crixalisEvent = true
				local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
				for i = 1, #MAIN_HERO_TABLE, 1 do
					local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
					Timers:CreateTimer(2, function()
						StartAnimation(MAIN_HERO_TABLE[i], {duration = 7, activity = ACT_DOTA_DIE, rate = 0.15})
					end)
					if playerID then
						gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 6})
						MAIN_HERO_TABLE[i]:Stop()
						PlayerResource:SetCameraTarget(playerID, units[1])
					end
					Timers:CreateTimer(7, function()
						Dungeons:MoveHeroAndUnits(MAIN_HERO_TABLE[i], Vector(15104, -9280))
					end)
					Timers:CreateTimer(10, function()
						if playerID then
							PlayerResource:SetCameraTarget(playerID, nil)
						end
					end)
				end
				Timers:CreateTimer(4.5, function()
					startCrixalisVisionEvent(ability)
				end)
				CustomGameEventManager:Send_ServerToAllClients("crixalisEvent", {})
			end
		end
		ability.relic:SetAbsOrigin(ability.relicPosition + Vector(0, 0, ability.liftPos))
		ability.dummy:SetAbsOrigin(ability.relicPosition + Vector(-170, 0, ability.liftPos + 505))
	end
end

function startCrixalisVisionEvent(relicAbility)

	local crixalis = CreateUnitByName("vision_of_crixalis", Vector(15104, -9200), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:AdjustBossPower(crixalis, 7, 7)
	crixalis:SetForwardVector(Vector(0, -1))
	Dungeons.entryPoint = Vector(15104, -9080)
	crixalis.pfx1 = createSandStormGuy()
	crixalis.pfx2 = createSandStormGuy()
	StartSoundEvent("Ability.SandKing_SandStorm.loop", crixalis)
	crixalis.relicAbility = relicAbility
end

function createSandStormGuy(crixalis)
	local sandParticle = "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf"
	local position = Vector(15104, -9280)
	local pfx = ParticleManager:CreateParticle(sandParticle, PATTACH_CUSTOMORIGIN, crixalis)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(1200, 1200, 1200))
	return pfx
end

function crixalis_death(event)
	local caster = event.caster
	local relicAbility = caster.relicAbility
	Dungeons.entryPoint = Vector(9344, -2944)
	StopSoundEvent("Ability.SandKing_SandStorm.loop", caster)
	Timers:CreateTimer(1, function()
		CustomGameEventManager:Send_ServerToAllClients("crixalisEvent", {})
		ParticleManager:DestroyParticle(caster.pfx1, false)
		ParticleManager:DestroyParticle(caster.pfx2, false)
	end)
	Timers:CreateTimer(4, function()
		EmitGlobalSound("sandking_skg_rare_03")
	end)
	Timers:CreateTimer(8, function()
		UTIL_Remove(relicAbility.dummy)
		relicAbility.relic:RemoveModifierByName("modifier_relic_effect")
		relicAbility.crixalisOver = true
		relicAbility.relic:RemoveAbility("ability_sand_relic_passive")
		for i = 1, #MAIN_HERO_TABLE, 1 do
			Dungeons:MoveHeroAndUnits(MAIN_HERO_TABLE[i], Vector(11136, -1792))
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
			if playerID then
				MAIN_HERO_TABLE[i]:Stop()
				Timers:CreateTimer(2, function()
					PlayerResource:SetCameraTarget(playerID, nil)
				end)
			end
		end
		Dungeons:SpawnDungeonUnit("tomb_stalker", Vector(11200, -7434), 1, 2, 4, "faceless_void_face_anger_03", Vector(0, -1), false, nil)
		Dungeons:SpawnDungeonUnit("tomb_stalker", Vector(11456, -7936), 1, 2, 4, "faceless_void_face_anger_03", Vector(1, -1), false, nil)
		Dungeons:SpawnDungeonUnit("tomb_stalker", Vector(12258, -8190), 1, 2, 4, "faceless_void_face_anger_03", Vector(1, 0), false, nil)

		Dungeons:SpawnDungeonUnit("vision_warden", Vector(11136, -2752), 1, 2, 4, "sandking_skg_anger_06", Vector(0, 1), false, nil)
		Dungeons:SpawnDungeonUnit("vision_warden", Vector(11136, -3608), 1, 2, 4, "sandking_skg_anger_06", Vector(0, 1), false, nil)
		local bossThinker = Dungeons:CreateDungeonThinker(Vector(13440, -4920), "sandBoss", 700, "sand_tomb")
		bossThinker.sandBoss = CreateUnitByName("sand_tomb_boss", Vector(13440, -4920), true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:AdjustDeathXP(bossThinker.sandBoss)
		Events:AdjustBossPower(bossThinker.sandBoss, 5, 3)
		bossThinker.sandBoss:SetForwardVector(Vector(0, -1))
		bossThinker.sandBoss.mainBoss = true
		bossThinker.sandBoss.bossStatus = true
		Timers:CreateTimer(0.2, function()
			local bossAbility = bossThinker.sandBoss:FindAbilityByName("sand_tomb_boss_ability")
			bossAbility:SetLevel(1)
			bossAbility:ApplyDataDrivenModifier(bossThinker.sandBoss, bossThinker.sandBoss, "modifier_tomb_boss_ability_prefight", {duration = 99999})
		end)
	end)
end

function crixalis_follower_death(event)
	local caster = event.caster
	EmitSoundOn("venomancer_venm_anger_01", caster)
	EmitSoundOn("venomancer_venm_anger_01", caster)
	EmitSoundOn("venomancer_venm_anger_01", caster)
	local worm = CreateUnitByName("sand_tomb_parasite", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:AdjustDeathXP(worm)
	worm = CreateUnitByName("sand_tomb_parasite", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:AdjustDeathXP(worm)
	worm = CreateUnitByName("sand_tomb_parasite", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:AdjustDeathXP(worm)
end

function tomb_boss_growing(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.growScale then
		ability.growScale = 0
	end
	ability.growScale = ability.growScale + 1
	caster:SetModelScale(0.4 + ability.growScale * 0.02)
	if ability.growScale % 10 == 0 then
		ScreenShake(Vector(13440, -4920), 300, 0.2, 5, 9000, 0, true)
	end
	if ability.growScale % 36 == 0 then
		EmitSoundOn("Hero_ElderTitan.EarthSplitter.Projectile", caster)
	end
	if ability.growScale % 12 == 0 then
		local rockfallParticle = "particles/dire_fx/dire_lava_falling_rocks.vpcf"
		local position = Vector(13440, -4920, 65) + RandomVector(RandomInt(100, 700))
		local pfx = ParticleManager:CreateParticle(rockfallParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		Timers:CreateTimer(6, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function tomb_boss_think(event)
	local caster = event.caster
	local ability = event.ability

	if not ability.thinkInterval then
		ability.thinkInterval = 0
	end
	if not caster.wardCount then
		caster.wardCount = 0
	end
	if not caster.dying then
		ability.thinkInterval = ability.thinkInterval + 1
		if ability.thinkInterval % 4 == 0 then
			if caster.wardCount < 10 then
				local spawnPoint = caster:GetAbsOrigin() + RandomVector(RandomInt(200, 680))
				local ward = Events:spawnUnitMisc("tomb_boss_ward", spawnPoint, 1)
				caster.wardCount = caster.wardCount + 1
				ward.boss = caster
				local wardAbility = ward:FindAbilityByName("sand_tomb_boss_ward_ability")
				wardAbility:SetLevel(1)
				EmitSoundOn("Hero_Venomancer.Plague_Ward", ward)
				local order =
				{
					UnitIndex = ward:GetEntityIndex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = wardAbility:GetEntityIndex(),
					TargetIndex = caster:GetEntityIndex(),
					Queue = false
				}
				Timers:CreateTimer(0.1, function()
					ExecuteOrderFromTable(order)
				end)
			end
		end
		if ability.thinkInterval % 5 == 0 then
			local galeNova = caster:FindAbilityByName("venomort_rune_q_1_poison_nova_one")
			galeNova:SetLevel(RandomInt(12, 20))
			local order =
			{
				UnitIndex = caster:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = galeNova:GetEntityIndex(),
				Queue = false
			}
			ExecuteOrderFromTable(order)
			EmitSoundOn("Hero_Venomancer.PoisonNova", caster)
		end
		if ability.thinkInterval > 60 then
			caster:SetAbsOrigin(Vector(13440, -4920))
			ability.thinkInterval = 0
		end
		bigPoison(caster, ability)
	end
end

function sand_tomb_boss_ward_die(event)
	local caster = event.caster
	local boss = caster.boss
	boss.wardCount = boss.wardCount - 1
	boss:RemoveModifierByNameAndCaster("modifier_silithicus_bind", caster)
	--    local current_stack = caster:GetModifierStackCount( "modifier_voltex_rune_w_1", ability )
	-- caster:SetModifierStackCount( "modifier_voltex_rune_w_1", ability, current_stack+1 )
end

function bigPoison(caster, ability)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies == 0 then
		enemies = MAIN_HERO_TABLE
		for _, enemy in pairs(enemies) do
			EmitSoundOn("Hero_Venomancer.Plague_Ward", enemy)
			local particleName = "particles/units/heroes/hero_nevermore/venom_raze.vpcf"
			local particleVector = enemy:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
			ParticleManager:SetParticleControl(pfx, 0, particleVector)
			local damage = Events:GetAdjustedAbilityDamage(1500, 60000, 0)
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			PopupDamage(target, damage)
		end
	end
end

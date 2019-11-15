function dragonkin_enflame_start(event)
end

function RedfallLava1(trigger)
	local hero = trigger.activator
	local fv = Vector(0, 1)
	local zHeight = 58 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function RedfallLava2(trigger)
	local hero = trigger.activator
	local fv = Vector(1, 1)
	local zHeight = 58 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function RedfallLava3(trigger)
	local hero = trigger.activator
	local fv = Vector(1, 0)
	local zHeight = 58 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function RedfallLava4(trigger)
	local hero = trigger.activator
	local fv = Vector(0, 1)
	local zHeight = 58 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function RedfallLava5(trigger)
	local hero = trigger.activator
	local fv = Vector(0, 1)
	local zHeight = -5 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function RedfallLava6(trigger)
	local hero = trigger.activator
	local fv = ((hero:GetAbsOrigin() - Vector(8750, 5410)) * Vector(1, 1, 0)):Normalized()
	local zHeight = -348 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function RedfallLava7(trigger)
	local hero = trigger.activator
	local fv = hero:GetForwardVector()
	local zHeight = 197 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function RedfallBossLava(trigger)
	local hero = trigger.activator
	local fv = hero:GetForwardVector()
	local zHeight = 197 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function RedfallLavaFlood(trigger)
	local hero = trigger.activator
	if Redfall.Castle then
		if Redfall.Castle.LavaDrained then
			return false
		end
	end
	hero:Stop()
	local fv = ((Vector(7027, 9153) - hero:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local zHeight = 58 + Redfall.ZFLOAT
	lavaGO(trigger, fv, zHeight)
end

function lavaGO(trigger, fv, zHeight)
	local hero = trigger.activator
	local caster = Events.GameMaster
	local ability = caster:FindAbilityByName("npc_abilities")
	if not hero:IsAlive() or hero:HasModifier("modifier_voltex_rune_e_3_heavens_charge_falling") then
		return false
	end
	if hero:HasFlyMovementCapability() or Filters:HasFlyingModifier(hero) then
		return false
	end
	if hero:HasModifier("modifier_rpc_terrasic_lava_boots") then
		hero.foot:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rpc_terrasic_lava_boot_effect", {duration = TERRASIC_LAVA_BOOTS_DURATION})
		return false
	end
	EmitSoundOn("Env.LavaHit", hero)
	StartAnimation(hero, {duration = 4, activity = ACT_DOTA_FLAIL, rate = 1.4})
	hero:RemoveModifierByName("modifier_lava_jumping")
	Timers:CreateTimer(0.03, function()
		hero:Stop()
		LavaJump(hero, fv, RandomInt(10, 13), 27, 25, 1, zHeight)
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_flailing", {duration = 4})
	end)
	--print("LaVA TOUCH!------")
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_hit", {duration = 4})
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_jumping_start", {duration = 0.3})
	--print("TOUCHING LAVA!!")
end

function lava_damage_think(event)
	local target = event.target
	local attacker = Events.GameMaster
	local damagePercentage = 0.03
	if GameState:GetDifficultyFactor() == 2 then
		damagePercentage = 0.04
	elseif GameState:GetDifficultyFactor() == 3 then
		damagePercentage = 0.05
	end
	local damage = target:GetMaxHealth() * damagePercentage
	-- local damage = Events:GetDifficultyScaledDamage(300, 3000, 10000)
	ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function LavaJump(unit, forwardVector, propulsion, liftForce, liftDuration, gravity, zHeight)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_lava_jumping"
	if unit:HasModifier(jumpingModifier) then
		return false
	end
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, jumpingModifier, {duration = 5})
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03 * i, function()
			if IsValidEntity(unit) then
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition + forwardVector * propulsion + Vector(0, 0, liftForce - i * gravity)
				local obstruction = WallPhysics:FindNearestObstruction(newPosition * Vector(1, 1, 0))
				local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPosition) * Vector(1, 1, 0), unit)
				if not blockUnit then
					if GetGroundPosition(newPosition, unit).z > currentPosition.z + 180 then
						newPosition = newPosition - (forwardVector * propulsion)
					end
				else
					newPosition = newPosition - (forwardVector * propulsion)
				end
				unit:SetOrigin(newPosition)
			end
		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03 * liftDuration + 0.03, function()
		Timers:CreateTimer(0.03 * fallLoop, function()
			if IsValidEntity(unit) then
				fallLoop = fallLoop + 1
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition + forwardVector * propulsion - Vector(0, 0, fallLoop * gravity)

				local obstruction = WallPhysics:FindNearestObstruction(newPosition * Vector(1, 1, 0))
				local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPosition) * Vector(1, 1, 0), unit)
				if not blockUnit then
					if GetGroundPosition(newPosition, unit).z > currentPosition.z + 180 then
						newPosition = newPosition - (forwardVector * propulsion)
					end
				else
					newPosition = newPosition - (forwardVector * propulsion)
				end
				unit:SetOrigin(newPosition)
				--print("NEWPOSITION.Z:")
				--print(newPosition.z)
				if newPosition.z - GetGroundPosition(newPosition, unit).z < 30 then
					if not unit:HasModifier("modifier_lava_jumping_start") then
						--print("z1")
						unit:RemoveModifierByName(jumpingModifier)
						WallPhysics:UnitLand(unit)
						unit:RemoveModifierByName("modifier_lava_jumping")
						FindClearSpaceForUnit(unit, newPosition, false)
						--print("REMOVE LAVA JUMPING")
						--print (currentPosition.z)
					end
				else
					return 0.03
				end
			end
		end)
	end)
end

function hell_bandit_attack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local mana_burn_percent = event.mana_burn_percent
	local manaBurn = math.min(target:GetMaxMana() * mana_burn_percent / 100, target:GetMana())
	local damage = manaBurn
	target:ReduceMana(manaBurn)
	ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/prism_strike.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(50, 150, 255))
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function autumn_monster_fire_lash(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	EmitSoundOn("Redfall.PumpkinFireLaunch", caster)
	for i = -1, 1, 1 do
		local rotatedFv = WallPhysics:rotateVector(fv, i * math.pi / 8)
		flame_orchid_projectile(caster, ability, caster:GetAbsOrigin(), rotatedFv)
	end
end

function flame_orchid_projectile(caster, ability, position, fv)
	local start_radius = 130
	local end_radius = 130
	local speed = 500

	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_jakiro/fireball.vpcf",
		vSpawnOrigin = position + Vector(0, 0, 205),
		fDistance = 1000,
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
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

end

function redfall_bombadier_ability_start(event)
	local caster = event.caster
	local ability = event.ability

	local target = event.target_points[1]
	local baseFV = (target * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local divisor = 24
	if caster:GetUnitName() == "crimsyth_bombadier_rooted" then
		divisor = 36
	end
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
			flare.stun_duration = 2
			flare.liftVelocity = 40
			flare.forwardVelocity = forwardVelocity + RandomInt(-3, 3)
			flare.interval = 0
			flare.damage = damage
			flare.origCaster = caster
			flare.origAbility = ability
			flare:AddAbility("redfall_bombadier_bomb_ability"):SetLevel(1)
			local flareSubAbility = flare:FindAbilityByName("redfall_bombadier_bomb_ability")
			flareSubAbility:ApplyDataDrivenModifier(flare, flare, "modifier_solar_projectile_motion", {})
			EmitSoundOn("Redfall.PumpkinFireLaunch", flare)
		end)
	end
end

function bombadier_bomb_thinking(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.liftVelocity) + caster.fv * caster.forwardVelocity)
	caster.liftVelocity = caster.liftVelocity - 3
	local maxScale = 0.65
	if caster.altMaxScale then
		maxScale = caster.altMaxScale
	end
	caster:SetModelScale(math.min((0.1 + caster.interval / 5), maxScale))
	local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 30)
	caster:SetForwardVector(newFV)
	caster:SetAngles(caster.interval * 4, 30, caster.interval * 4)
	caster.interval = caster.interval + 1
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < 10 then

		EmitSoundOn("Redfall.Bombadier.BombExplose", caster)
		caster:RemoveModifierByName("modifier_solar_projectile_motion")
		bombImpact(caster, ability)
		flareParticle(caster:GetAbsOrigin())
		Timers:CreateTimer(0.1, function()
			UTIL_Remove(caster)
		end)
	end
end

function flareParticle(position)
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, position)
	ParticleManager:SetParticleControl(particle2, 1, Vector(260, 260, 260))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 20))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
end

function bombImpact(caster, ability)
	local enemies = FindUnitsInRadius(caster.origCaster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = caster.damage
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster.origCaster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			Filters:ApplyStun(caster.origCaster, caster.stun_duration, enemy)
		end
	end
end

function hawk_soldier_think(event)
	local caster = event.caster
	if caster.aggro then
		local forwardVelocity = 16
		if caster:HasModifier("modifier_crimsyth_hawk_soldier_haste") then
			forwardVelocity = 25
		end
		if caster:GetUnitName() == "redfall_crimsyth_hawk_soldier_elite" then
			-- local checkPoint = caster:GetAbsOrigin()+caster:GetForwardVector()*70
			-- local obstruction = WallPhysics:FindNearestObstruction(checkPoint)
			-- local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, checkPoint, caster)
			-- if blockUnit then
			-- forwardVelocity = 0
			-- end
		end
		if caster:HasModifier("modifier_redfall_hawk_elite_lock_on_self") then
			return false
		end
		local random = RandomInt(1, 2)
		if random == 1 then
			EmitSoundOn("Redfall.HawkSoldier.Jump", caster)
		end
		if caster:GetUnitName() == "redfall_crimsyth_hawk_soldier_elite" then
			WallPhysics:JumpWithBlocking(caster, caster:GetForwardVector(), forwardVelocity, 11, 18, 1)
		else
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				if caster:GetAbsOrigin().y < 15500 then
					WallPhysics:Jump(caster, caster:GetForwardVector(), forwardVelocity, 11, 18, 1)
				end
			end
		end
		StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_TELEPORT_END, rate = 0.9})
	end
end

function CastleSorceressTrigger(trigger)
	if not Redfall.SorceressActive then
		Redfall.SorceressActive = true
		local hero = trigger.activator
		local sorceress = Redfall.CastleSorceress
		EmitSoundOn("Redfall.CastleSorceress.Laugh", sorceress)
		StartAnimation(sorceress, {duration = 3.5, activity = ACT_DOTA_VICTORY, rate = 0.9})
		local sorcAbility = sorceress:FindAbilityByName("redfall_crimsyth_sorceress_ai")
		sorcAbility:ApplyDataDrivenModifier(sorceress, sorceress, "modifier_sorceress_flying", {})
		sorcAbility:ApplyDataDrivenModifier(sorceress, sorceress, "modifier_z_axis", {})
		sorceress:RemoveModifierByName("modifier_crymsith_sorceress_waiting")
		local allies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin() + Vector(2000, 0, 0), nil, 4000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #allies > 0 then
			Dungeons:LockCameraToUnitForPlayers(sorceress, 5, allies)
			Quests:ShowDialogueText(allies, sorceress, "crimsyth_sorceress_dialogue_1", 6, false)
		end
		Timers:CreateTimer(2.4, function()
			sorcAbility:ApplyDataDrivenModifier(sorceress, sorceress, "modifier_sorceress_moving", {})
			sorceress.state = 0
			sorceress.interval = 0
			Timers:CreateTimer(1.5, function()
				sorceress:MoveToPosition(Vector(5184, 12800))
				sorceress.state = 1
			end)

			Timers:CreateTimer(7, function()
				EmitSoundOn("Redfall.CastleSorceress.Laugh2", sorceress)
				StartAnimation(sorceress, {duration = 3.5, activity = ACT_DOTA_VICTORY, rate = 0.9})
			end)
			Timers:CreateTimer(7.5, function()
				sorceress.state = 2
				sorceress:MoveToPosition(Vector(5376, 9354))
			end)
			for i = 1, 15, 1 do
				Timers:CreateTimer(i, function()
					ScreenShake(sorceress:GetAbsOrigin(), 530, 0.9, 0.9, 9000, 2, true)
				end)
			end
			Timers:CreateTimer(13, function()
				AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(5407, 7803), 800, 900, false)
				local boss = BossIntroScene(allies)
				sorceress.state = 3
				if #allies > 0 then
					Dungeons:LockCameraToUnitForPlayers(boss, 3, allies)
				end
				local mode = GameRules:GetGameModeEntity()
				mode:SetCameraDistanceOverride(2000)
				Redfall.CastleBossIntro = boss

			end)
		end)
	end
end

function sorceress_flying_think(event)
	local caster = event.caster
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 10, false)
end

function sorceress_moving_think(event)
	local caster = event.caster
	local ability = event.ability
	local currentZ = caster:GetModifierStackCount("modifier_z_axis", caster)
	local newZ = 0
	local heightDifferential = currentZ
	if caster.state == 0 then
		-- caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,5))
		currentZ = currentZ + 8
	elseif caster.state == 1 then
		if heightDifferential > 240 then
			currentZ = currentZ - 1
		elseif heightDifferential < 180 then
			currentZ = currentZ + 1
		end
	elseif caster.state == 2 then
		if heightDifferential > 700 then
			currentZ = currentZ - 1
		elseif heightDifferential < 680 then
			currentZ = currentZ + 10
		end
	elseif caster.state == 3 then
		caster:SetForwardVector(Vector(0, -1))
		if heightDifferential > 200 then
			currentZ = currentZ - 4
		end
	elseif caster.state == 4 then
		if heightDifferential > 420 then
			currentZ = currentZ - 1
		elseif heightDifferential < 380 then
			currentZ = currentZ + 4
		end
	elseif caster.state == 5 then
		if heightDifferential > 240 then
			currentZ = currentZ - 1
		elseif heightDifferential < 180 then
			currentZ = currentZ + 1
		end
	end
	currentZ = currentZ + math.sin(2 * math.pi * caster.interval / 45) * 4
	--print("---SORC STATE_---")
	--print(caster.state)
	--print(currentZ)
	caster:SetModifierStackCount("modifier_z_axis", caster, currentZ)
	if caster.interval > 45 then
		caster.interval = 0
	end
end

function BossIntroScene(allies)
	local boss = CreateUnitByName("redfall_crimsyth_castle_boss", Vector(5357, 7969), false, nil, nil, DOTA_TEAM_NEUTRALS)
	boss:SetAbsOrigin(boss:GetAbsOrigin() - Vector(0, 0, 400))
	boss:SetForwardVector(Vector(0, 1))
	local ability = boss:FindAbilityByName("redfall_crimsyth_castle_boss_ai")
	boss:SetRenderColor(255, 60, 40)
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_waiting", {})
	EmitSoundOn("Redfall.CastleBoss.Lava", boss)
	EmitSoundOnLocationWithCaster(boss:GetAbsOrigin(), "Redfall.CastleBoss.LavaEmerge", Events.GameMaster)
	Redfall:CreateLavaBlast(Vector(5357, 7969, -50 + Redfall.ZFLOAT))
	for i = 1, 120, 1 do
		Timers:CreateTimer(i * 0.03, function()
			boss:SetAbsOrigin(boss:GetAbsOrigin() + Vector(0, 0, 4.0))
		end)
	end
	Timers:CreateTimer(1, function()
		StartAnimation(boss, {duration = 3.5, activity = ACT_DOTA_CAST_ABILITY_3, rate = 0.3})
		Quests:ShowDialogueText(MAIN_HERO_TABLE, boss, "crimsyth_castle_boss_dialogue_1", 6, false)
		EmitSoundOn("Redfall.CastleBoss.IntroVO1", boss)
	end)
	Timers:CreateTimer(5.2, function()
		Dungeons:LockCameraToUnitForPlayers(Redfall.CastleSorceress, 3, allies)
	end)
	Timers:CreateTimer(6, function()
		StartAnimation(Redfall.CastleSorceress, {duration = 2.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
		EmitSoundOn("Redfall.CastleSorceress.Laugh3", Redfall.CastleSorceress)
		Quests:ShowDialogueText(MAIN_HERO_TABLE, Redfall.CastleSorceress, "crimsyth_sorceress_dialogue_2", 6, false)
	end)
	Timers:CreateTimer(10.5, function()
		-- Dungeons:LockCameraToUnitForPlayers(boss, 5, allies)
		StartAnimation(boss, {duration = 1.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.7})
		Quests:ShowDialogueText(MAIN_HERO_TABLE, boss, "crimsyth_castle_boss_dialogue_2", 6, false)
		EmitSoundOn("Redfall.CastleBoss.IntroVO2", boss)
	end)
	Timers:CreateTimer(15.6, function()
		-- Dungeons:LockCameraToUnitForPlayers(Redfall.CastleSorceress, 3, allies)
		StartAnimation(Redfall.CastleSorceress, {duration = 1.5, activity = ACT_DOTA_ATTACK, rate = 0.7})
		EmitSoundOn("Redfall.CastleSorceress.Laugh", Redfall.CastleSorceress)
		Quests:ShowDialogueText(MAIN_HERO_TABLE, Redfall.CastleSorceress, "crimsyth_sorceress_dialogue_3", 6, false)
	end)
	Timers:CreateTimer(18, function()
		Redfall.CastleSorceress.state = 4
		Redfall.CastleSorceress:MoveToPosition(Vector(5184, 12800))

		Quests:ShowDialogueText(MAIN_HERO_TABLE, Redfall.CastleSorceress, "crimsyth_sorceress_dialogue_4", 6, false)
	end)
	Timers:CreateTimer(23, function()
		local mode = GameRules:GetGameModeEntity()
		mode:SetCameraDistanceOverride(CAMERA_DISTANCE_OVERRIDE)
		Redfall.CastleSorceress:MoveToPosition(Vector(4197, 12743))
		Redfall.CastleSorceress.state = 5
	end)
	

	Timers:CreateTimer(27, function()
		Redfall.OutsideCastleParticleTable = {}
		StartAnimation(Redfall.CastleSorceress, {duration = 2.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
		EmitSoundOnLocationWithCaster(Vector(4097, 12743, 272 + Redfall.ZFLOAT), "Redfall.CastleSpawner.Activate", Redfall.RedfallMaster)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, Vector(4097, 12743, 272 + Redfall.ZFLOAT))
		Timers:CreateTimer(6, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

		local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx2, 0, Vector(4097, 12743, 272 + Redfall.ZFLOAT))
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(4097, 12743, 272), 500, 1500, false)
		table.insert(Redfall.OutsideCastleParticleTable, pfx2)
		Timers:CreateTimer(4, function()
			Redfall:SpawnOutsideCastleWaveUnit("redfall_dragonkin", Vector(4097, 12743, 272), 8, 90, 1.3, true)
		end)
		-- EmitSoundOnLocationWithCaster(Vector(4097, 12743, 272+Redfall.ZFLOAT), "Redfall.SpawnPortalsActivate", Events.GameMaster)
	end)
	Timers:CreateTimer(29, function()
		Redfall.CastleSorceress:MoveToPosition(Vector(6052, 12707, 272))
	end)
	Timers:CreateTimer(34, function()
		EmitSoundOn("Redfall.CastleSorceress.Laugh", Redfall.CastleSorceress)
		StartAnimation(Redfall.CastleSorceress, {duration = 2.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
		EmitSoundOnLocationWithCaster(Vector(6152, 12707, 272 + Redfall.ZFLOAT), "Redfall.CastleSpawner.Activate", Redfall.RedfallMaster)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, Vector(6152, 12707, 272 + Redfall.ZFLOAT))
		Timers:CreateTimer(6, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

		local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx2, 0, Vector(6152, 12707, 272 + Redfall.ZFLOAT))
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(6152, 12707, 272), 500, 1500, false)
		Timers:CreateTimer(4, function()
			Redfall:SpawnOutsideCastleWaveUnit("redfall_dragonkin", Vector(6152, 12707, 272), 8, 90, 1.3, true)
		end)
		table.insert(Redfall.OutsideCastleParticleTable, pfx2)
	end)

	Timers:CreateTimer(36, function()
		Redfall.CastleSorceress:MoveToPosition(Vector(5440, 14516, 272))
	end)
	Timers:CreateTimer(41, function()
		EmitSoundOn("Redfall.CastleSorceress.Laugh", Redfall.CastleSorceress)
		StartAnimation(Redfall.CastleSorceress, {duration = 2.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
		EmitSoundOnLocationWithCaster(Vector(5440, 14616, 272 + Redfall.ZFLOAT), "Redfall.CastleSpawner.Activate", Redfall.RedfallMaster)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, Vector(5440, 14616, 272 + Redfall.ZFLOAT))
		Timers:CreateTimer(6, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

		local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx2, 0, Vector(5440, 14616, 272 + Redfall.ZFLOAT))
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(5440, 14616, 272), 500, 1500, false)
		Timers:CreateTimer(4, function()
			Redfall:SpawnOutsideCastleWaveUnit("redfall_dragonkin", Vector(5440, 14616, 272), 8, 90, 1.3, true)
		end)
		table.insert(Redfall.OutsideCastleParticleTable, pfx2)
	end)

	Timers:CreateTimer(43, function()
		Redfall.CastleSorceress:MoveToPosition(Vector(2891, 14616, 272))
	end)
	Timers:CreateTimer(48, function()
		EmitSoundOn("Redfall.CastleSorceress.Laugh", Redfall.CastleSorceress)
		StartAnimation(Redfall.CastleSorceress, {duration = 2.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.9})
		EmitSoundOnLocationWithCaster(Vector(2791, 14616, 272 + Redfall.ZFLOAT), "Redfall.CastleSpawner.Activate", Redfall.RedfallMaster)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, Vector(2791, 14616, 272 + Redfall.ZFLOAT))
		Timers:CreateTimer(6, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

		local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx2, 0, Vector(2791, 14616, 272 + Redfall.ZFLOAT))
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(2791, 14616, 272), 500, 1500, false)
		Timers:CreateTimer(4, function()
			Redfall:SpawnOutsideCastleWaveUnit("redfall_dragonkin", Vector(2791, 14616, 272), 8, 90, 1.3, true)
		end)
		table.insert(Redfall.OutsideCastleParticleTable, pfx2)
	end)
	Timers:CreateTimer(50.5, function()
		Redfall.CastleSorceress:MoveToPosition(Vector(2624, 13504, 15))
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(2624, 13504, 15), 500, 1500, false)
	end)
	Timers:CreateTimer(55, function()
		Redfall.CastleSorceress:SetForwardVector(Vector(1, 0))
	end)
	return boss
end

function castle_boss_waiting_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.moveInterval then
		ability.moveInterval = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, math.sin(math.pi * ability.moveInterval / 180) * 2))
	ability.moveInterval = ability.moveInterval + 1
	if ability.moveInterval > 180 then
		ability.moveInterval = -180
	end
end

function outside_castle_wave_unit_die(event)
	if not Redfall.CastleWaveUnitsSlain then
		Redfall.CastleWaveUnitsSlain = 0
	end
	if not IsValidEntity(Redfall.CastleSorceress) then
		return false
	end
	local sorcAbility = Redfall.CastleSorceress:FindAbilityByName("redfall_crimsyth_sorceress_ai")
	local spawnPoint1 = Vector(2791, 14616, 272)
	local spawnPoint2 = Vector(5440, 14616, 272)
	local spawnPoint3 = Vector(6152, 12707, 272)
	local spawnPoint4 = Vector(4097, 12743, 272)
	Redfall.CastleWaveUnitsSlain = Redfall.CastleWaveUnitsSlain + 1
	if Redfall.CastleWaveUnitsSlain == 28 then
		EmitSoundOn("Redfall.CastleSorceress.Laugh2", Redfall.CastleSorceress)
		StartAnimation(Redfall.CastleSorceress, {duration = 2.0, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.9})
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint1, 10, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint2, 10, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint3, 10, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint4, 10, 90, 1.3, true)
	elseif Redfall.CastleWaveUnitsSlain == 64 then
		EmitSoundOn("Redfall.CastleSorceress.Laugh2", Redfall.CastleSorceress)
		StartAnimation(Redfall.CastleSorceress, {duration = 2.0, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.9})
		Redfall:SpawnOutsideCastleWaveUnit("redfall_dragonkin", spawnPoint1, 8, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint2, 10, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_autumn_monster", spawnPoint3, 8, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint4, 10, 90, 1.3, true)
	elseif Redfall.CastleWaveUnitsSlain == 102 then
		local buildPoint1 = Vector(3776, 13568)
		local buildPoint2 = Vector(3825, 14273)
		local buildPoint3 = Vector(4491, 14617)
		local buildPoint4 = Vector(4448, 13883)
		local buildTable = {buildPoint1, buildPoint2, buildPoint3, buildPoint4}
		for i = 1, #buildTable, 1 do
			Timers:CreateTimer((i - 1) * 8, function()
				Redfall.CastleSorceress:MoveToPosition(buildTable[i] - Vector(100, 0, 0))
				EmitSoundOn("Redfall.CastleSorceress.Laugh"..RandomInt(2, 3), Redfall.CastleSorceress)
				StartAnimation(Redfall.CastleSorceress, {duration = 4.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.4})
				local bombadier = Redfall:SpawnCrimsythBombadierRooted(buildTable[i], RandomVector(1))
				bombadier:SetModelScale(0.01)
				bombadier.scale = 0.01
				sorcAbility:ApplyDataDrivenModifier(Redfall.CastleSorceress, bombadier, "modifier_sorceress_building_unit", {duration = 4})
			end)
		end
		Timers:CreateTimer(37, function()
			Redfall.CastleSorceress:MoveToPosition(Vector(2624, 13504, 15))
		end)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_snarlroot_treant", spawnPoint1, 4, 90, 2.0, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_snarlroot_treant", spawnPoint2, 4, 90, 2.0, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_snarlroot_treant", spawnPoint3, 4, 90, 2.0, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_snarlroot_treant", spawnPoint4, 4, 90, 2.0, true)
	elseif Redfall.CastleWaveUnitsSlain == 118 then
		Redfall:SpawnOutsideCastleWaveUnit("redfall_castle_archer", spawnPoint1, 9, 90, 1.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_castle_archer", spawnPoint2, 9, 90, 1.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_castle_archer", spawnPoint3, 9, 90, 1.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_castle_archer", spawnPoint4, 9, 90, 1.7, true)
	elseif Redfall.CastleWaveUnitsSlain == 154 then
		Redfall:SpawnOutsideCastleWaveUnit("redfall_castle_archer", spawnPoint1, 9, 90, 1.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint2, 10, 90, 1.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint3, 10, 90, 1.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_dragonkin", spawnPoint4, 8, 90, 1.7, true)
	elseif Redfall.CastleWaveUnitsSlain == 192 then
		Redfall:SpawnOutsideCastleWaveUnit("nibohg", spawnPoint1, 5, 90, 2.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("nibohg", spawnPoint2, 5, 90, 2.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("nibohg", spawnPoint3, 5, 90, 2.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("nibohg", spawnPoint4, 5, 90, 2.7, true)
	elseif Redfall.CastleWaveUnitsSlain == 212 then
		Redfall:SpawnOutsideCastleWaveUnit("nibohg", spawnPoint1, 5, 90, 2.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_castle_archer", spawnPoint2, 7, 90, 2.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_snarlroot_treant", spawnPoint3, 5, 90, 2.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("crimsyth_bombadier", spawnPoint4, 6, 90, 2.7, true)
	elseif Redfall.CastleWaveUnitsSlain == 235 then
		Dungeons.phoenixEggLocation = Vector(4352, 13696)
		Redfall:SpawnOutsideCastleWaveUnit("phoenix_siege_dragon", spawnPoint1, 7, 90, 1.4, true)
		Redfall:SpawnOutsideCastleWaveUnit("phoenix_siege_dragon", spawnPoint2, 7, 90, 1.4, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_autumn_monster", spawnPoint3, 5, 90, 2.7, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_autumn_monster", spawnPoint4, 5, 90, 2.7, true)
	elseif Redfall.CastleWaveUnitsSlain == 260 then
		Redfall:SpawnOutsideCastleWaveUnit("castle_doomguard", spawnPoint1, 9, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("castle_doomguard", spawnPoint2, 9, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("castle_doomguard", spawnPoint3, 9, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("castle_doomguard", spawnPoint4, 9, 90, 1.8, true)
	elseif Redfall.CastleWaveUnitsSlain == 296 then
		local buildPoint1 = Vector(3776, 13568)
		local buildPoint2 = Vector(3825, 14273)
		local buildPoint3 = Vector(4491, 14617)
		local buildPoint4 = Vector(4448, 13883)
		local buildTable = {buildPoint1, buildPoint2, buildPoint3, buildPoint4}
		for i = 1, #buildTable, 1 do
			Timers:CreateTimer((i - 1) * 8, function()
				Redfall.CastleSorceress:MoveToPosition(buildTable[i] - Vector(100, 0, 0))
				EmitSoundOn("Redfall.CastleSorceress.Laugh"..RandomInt(2, 3), Redfall.CastleSorceress)
				StartAnimation(Redfall.CastleSorceress, {duration = 4.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.4})
				local bombadier = Redfall:SpawnCrimsythBombadierRooted(buildTable[i], RandomVector(1))
				bombadier:SetModelScale(0.01)
				bombadier.scale = 0.01
				sorcAbility:ApplyDataDrivenModifier(Redfall.CastleSorceress, bombadier, "modifier_sorceress_building_unit", {duration = 4})
			end)
		end
		Timers:CreateTimer(37, function()
			Redfall.CastleSorceress:MoveToPosition(Vector(2624, 13504, 15))
		end)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint1, 10, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint2, 10, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint3, 10, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint4, 10, 90, 1.3, true)
	elseif Redfall.CastleWaveUnitsSlain == 336 then
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hell_bandit", spawnPoint1, 8, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hell_bandit", spawnPoint2, 8, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hell_bandit", spawnPoint3, 8, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hell_bandit", spawnPoint4, 8, 90, 1.8, true)
	elseif Redfall.CastleWaveUnitsSlain == 368 then
		Redfall:SpawnOutsideCastleWaveUnit("castle_doomguard", spawnPoint1, 8, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_castle_archer", spawnPoint2, 8, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("crimsyth_bombadier", spawnPoint3, 6, 90, 1.8, true)
		Redfall:SpawnOutsideCastleWaveUnit("castle_doomguard", spawnPoint4, 8, 90, 1.8, true)
	elseif Redfall.CastleWaveUnitsSlain == 379 then
		Redfall:SpawnOutsideCastleWaveUnit("redfall_snarlroot_treant", spawnPoint1, 4, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_autumn_monster", spawnPoint2, 6, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint3, 10, 90, 1.3, true)
		Redfall:SpawnOutsideCastleWaveUnit("redfall_crimsyth_hawk_soldier", spawnPoint4, 10, 90, 1.3, true)
	elseif Redfall.CastleWaveUnitsSlain == 409 then
		Redfall.CastleSorceress:RemoveModifierByName("modifier_sorceress_flying")
		Redfall.CastleSorceress:RemoveModifierByName("modifier_crymsith_sorceress_waiting")
		sorcAbility:ApplyDataDrivenModifier(Redfall.CastleSorceress, Redfall.CastleSorceress, "modifier_sorceress_in_battle", {})
		Redfall.CastleSorceress:MoveToPositionAggressive(Vector(4352, 13696))
	end
end

function sorc_grow_unit(event)
	local target = event.target
	target.scale = target.scale + 0.01
	target:SetModelScale(target.scale)
end

function sorc_grow_end(event)
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", target, 2.4)
end

function sorceress_death(event)
	local caster = event.caster
	EmitSoundOn("Redfall.CastleSorceress.Death", caster)

	local particleName = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local origin = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 2, caster:GetForwardVector())
	ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	for i = 1, 90, 1 do
		Timers:CreateTimer(i * 0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 3))
			local angles = caster:GetAnglesAsVector()
			caster:SetAngles(angles.x, (angles.y + 3), angles.z)
		end)
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 4000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	Timers:CreateTimer(3.5, function()
		if #enemies > 0 then
			Dungeons:CreateBasicCameraLockForHeroes(Vector(5376, 11520), 11, enemies)
		end
		Timers:CreateTimer(1, function()
			local drawbridge = Entities:FindByNameNearest("castle_drawbridge", Vector(5355, 11047, -140 + Redfall.ZFLOAT), 800)
			EmitSoundOnLocationWithCaster(drawbridge:GetAbsOrigin(), "Redfall.WallOpen", Redfall.RedfallMaster)
			for i = 1, 63, 1 do
				Timers:CreateTimer(i * 0.03, function()
					local moveLeft = 10
					if i % 2 == 0 then
						moveLeft = -10
						ScreenShake(drawbridge:GetAbsOrigin(), 2, 0.8, 0.2, 9000, 0, true)
					end
					drawbridge:SetAbsOrigin(drawbridge:GetAbsOrigin() + Vector(moveLeft, 0, 3.33))
				end)
			end
			Timers:CreateTimer(1.83, function()
				for i = 1, 180, 1 do
					Timers:CreateTimer(i * 0.03, function()
						drawbridge:SetAngles(0, 0, 90 - (i * 0.5))
						if i % 20 == 0 then
							EmitSoundOnLocationWithCaster(drawbridge:GetAbsOrigin(), "Redfall.DrawbridgeLowering", Events.GameMaster)
							ScreenShake(drawbridge:GetAbsOrigin(), 2, 0.2, 0.8, 9000, 0, true)
						end
					end)
				end
			end)
			Timers:CreateTimer(6, function()
				EmitGlobalSound("Music.Redfall.DungeonOpen")
				Timers:CreateTimer(1, function()
					EmitSoundOnLocationWithCaster(Vector(5300, 11878, 125), "Redfall.TreeHealed", Events.GameMaster)
					for i = 1, 7, 1 do
						local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(pfx, 0, Vector(4962 + (128 * (i - 1)), 11878, 125) + Vector(0, 0, Redfall.ZFLOAT))
						ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
						Timers:CreateTimer(2, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end
				end)
			end)
		end)
	end)
	Timers:CreateTimer(18, function()
		local boss = Redfall.CastleBossIntro
		-- Dungeons:LockCameraToUnitForPlayers(Redfall.CastleBossIntro, 5, enemies)
		Timers:CreateTimer(0.5, function()
			StartAnimation(Redfall.CastleBossIntro, {duration = 1.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.7})
			EmitSoundOn("Redfall.CastleBoss.IntroVO2", Redfall.CastleBossIntro)
			Timers:CreateTimer(2, function()
				StartAnimation(Redfall.CastleBossIntro, {duration = 9.0, activity = ACT_DOTA_CAST_ABILITY_3_END, rate = 0.20})
				Timers:CreateTimer(0.8, function()
					EmitSoundOnLocationWithCaster(boss:GetAbsOrigin(), "Redfall.CastleBoss.LavaEmerge", Events.GameMaster)
					Redfall:CreateLavaBlast(Vector(5357, 7969, -50 + Redfall.ZFLOAT))
				end)
				for i = 1, 120, 1 do
					Timers:CreateTimer(i * 0.03, function()
						boss:SetAbsOrigin(boss:GetAbsOrigin() - Vector(0, 0, 4.0))
					end)
				end
			end)
			Timers:CreateTimer(6, function()
				UTIL_Remove(Redfall.CastleBossIntro)
				local castleFXTable = Entities:FindAllByNameWithin("CastleFX", Vector(5357, 7969, -500 + Redfall.ZFLOAT), 4000)
				for j = 1, 120, 1 do
					Timers:CreateTimer(j * 0.03, function()
						for i = 1, #castleFXTable, 1 do
							castleFXTable[i]:SetAbsOrigin(castleFXTable[i]:GetAbsOrigin() - Vector(0, 0, 5))
						end
					end)
				end
			end)
		end)
	end)
	Timers:CreateTimer(9, function()
		Redfall:InitiateCrimsythCastle()
		local blockers = Entities:FindAllByNameWithin("drawbridge_blocker", Vector(5376, 11520, 128 + Redfall.ZFLOAT), 4000)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)
	Timers:CreateTimer(1, function()
		if Redfall.OutsideCastleParticleTable then
			for i = 1, #Redfall.OutsideCastleParticleTable, 1 do
				ParticleManager:DestroyParticle(Redfall.OutsideCastleParticleTable[i], false)
				ParticleManager:ReleaseParticleIndex(Redfall.OutsideCastleParticleTable[i])
			end
			Redfall.OutsideCastleParticleTable = nil
		end
	end)
end

function fire_spray_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_sorceress_in_battle") or caster:GetUnitName() == "winterblight_candy_crush_orange_spirit" then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOn("Redfall.SorceressFire", caster)
			for i = 1, #enemies, 1 do
				local info =
				{
					Target = enemies[i],
					Source = caster,
					Ability = ability,
					EffectName = "particles/base_attacks/ranged_tower_bad.vpcf",
					StartPosition = "attach_hitloc",
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = false,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					flExpireTime = GameRules:GetGameTime() + 5,
					bProvidesVision = false,
					iVisionRadius = 0,
					iMoveSpeed = 750,
				iVisionTeamNumber = caster:GetTeamNumber()}

				projectile = ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end
end

function castle_sorceress_blink(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Redfall.SorceressDash", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf", caster, 3)
	local fv = RandomVector(1)
	StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_SPAWN, rate = 0.9})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sorceress_dashing", {duration = 0.8})
	for i = 1, 25, 1 do
		Timers:CreateTimer(i * 0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin() + fv * 32)
		end)
	end
	Timers:CreateTimer(0.75, function()
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti6/blink_dagger_end_ti6.vpcf", caster, 3)
	end)
end

function sorceress_combat_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.spawnInterval then
		caster.spawnInterval = 10
	end
	if not caster:IsAlive() then
		return false
	end
	local dashAbility = caster:FindAbilityByName("castle_sorceress_blink_ability")
	if dashAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = dashAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return false
		end
	end
	local arrayAbility = caster:FindAbilityByName("castle_sorceress_light_strike_array")
	if arrayAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 850, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = arrayAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(0.4, function()
				EmitSoundOn("Redfall.CastleSorceress.Laugh"..RandomInt(2, 3), Redfall.CastleSorceress)
			end)
			return false
		end
	end
	if caster:GetHealth() < caster:GetMaxHealth() * (1 - (caster.spawnInterval / 100)) then
		caster.spawnInterval = caster.spawnInterval + 10
		for i = 1, 3 + GameState:GetDifficultyFactor(), 1 do

			Timers:CreateTimer(i * 0.25, function()
				local position = caster:GetAbsOrigin() + RandomVector(1) * RandomInt(200, 360)
				Redfall:RedBeam(caster:GetAbsOrigin(), position)
				Redfall:SpawnHawkSoldierAggro(position, RandomVector(1))
				EmitSoundOnLocationWithCaster(position, "Redfall.SorceressSummon", Redfall.RedfallMaster)
			end)
		end
	end
end

function hawk_knight_lock_on_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	EmitSoundOn("Redfall.HawkSoldierElite.LockOn", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_redfall_hawk_elite_lock_on_self", {duration = 2})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_redfall_hawk_elite_lock_on_enemy", {duration = 2})
	ability.lockCount = 0
end

function hawk_knight_lock_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not ability then
		return
	end
	ability.lockCount = ability.lockCount + 1
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), target:GetAbsOrigin())
	local moveVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local angle = WallPhysics:vectorToAngle(moveVector)
	-- caster:SetAngles(0, angle, 0)
	if distance < 880 then
		if ability.lockCount == 18 then
			ability.target = target
			EmitSoundOn("Redfall.HawkSoldierElite.Aggro", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_hawk_charging", {duration = 3})
			-- caster:SetAngles(0,0,0)
		end
	else
		-- caster:SetAngles(0,0,0)
		EmitSoundOn("Redfall.HawkSoldierElite.LockOnBreak", caster)
		caster:RemoveModifierByName("modifier_redfall_hawk_elite_lock_on_self")
		target:RemoveModifierByName("modifier_redfall_hawk_elite_lock_on_enemy")
		local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/prism_strike.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, Vector(255, 60, 60))
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function hawk_knight_charging_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	local stun_duration = event.stun_duration
	local damage = event.damage
	if not caster:IsAlive() then
		return false
	end
	local moveVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 1)):Normalized()
	caster:SetForwardVector(moveVector)
	local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), caster:GetAbsOrigin())
	caster:SetAbsOrigin(caster:GetAbsOrigin() + moveVector * 70)
	if distance < 130 then
		caster:RemoveModifierByName("modifier_redfall_hawk_elite_lock_on_self")
		target:RemoveModifierByName("modifier_redfall_hawk_elite_lock_on_target")
		caster:RemoveModifierByName("modifier_hawk_charging")
		StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.2})
		Filters:ApplyStun(caster, stun_duration, target)
		EmitSoundOn("Redfall.HawkSoldier.Smash", target)
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/prism_strike.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, Vector(255, 60, 60))
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function crimsyth_castle_prop_attacked(event)
	local unit = event.unit
	local target = event.target
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	if not caster.attacks then
		caster.attacks = 0
	end
	caster.attacks = caster.attacks + 1
	caster:SetRenderColor(255 - caster.attacks * 30, 255 - caster.attacks * 30, 255 - caster.attacks * 30)
	if caster.attacks == 5 then
		EmitSoundOn("Redfall.Castle.SwordTurn", caster)
		caster:RemoveModifierByName("modifier_attackable_prop")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_shield_no_more_attack", {})
		for i = 1, 48, 1 do
			Timers:CreateTimer(0.03 * i, function()
				caster:SetAngles(0.5 * i, 0, 0)
				caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0.22, 0, 0))
			end)
		end
		Timers:CreateTimer(1.44, function()
			EmitSoundOn("Redfall.Castle.SwordRelease", caster)
			local moveVector = (Vector(5773, 8652, 143 + Redfall.ZFLOAT - 130) - caster:GetAbsOrigin()) / 12
			for j = 1, 12, 1 do
				Timers:CreateTimer(j * 0.03, function()
					caster:SetAngles(24 + (1 / 6) * j, 360 - (1 / 3) * j, -j * (5 / 6))
					caster:SetAbsOrigin(caster:GetAbsOrigin() + moveVector)
				end)
			end
		end)
		Timers:CreateTimer(1.44 + 0.41, function()
			EmitSoundOn("Redfall.Castle.SwordHitGround", caster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.Castle.SwordHitGround2", Events.GameMaster)
			local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, Vector(5696, 8640, 129) + Vector(0, 0, Redfall.ZFLOAT))
			ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local baseAngles = Vector(28, 352, -20)
			local moveVector = (Vector(5773, 8652, 137) - caster:GetAbsOrigin()) / 18
			for i = 1, 4, 1 do
				Timers:CreateTimer(i * 0.03, function()
					-- caster:SetAbsOrigin(caster:GetAbsOrigin()+moveVector)
					caster:SetAngles(28 + (49 / 4) * i, (20 / 4) * i, -20 - (160 / 4) * i)
				end)
			end

			-- caster:SetAngles(77, 20, -180)
			Timers:CreateTimer(1, function()
				EmitSoundOn("Redfall.Castle.CursedSwordFadeOut", caster)
				for i = 1, 80, 1 do
					Timers:CreateTimer(i * 0.03, function()
						caster:SetRenderColor(255 - i * 3, 255 - i * 3, 255 - i * 3)
					end)
				end
			end)
			Timers:CreateTimer(4, function()
				local positionTable = {Vector(5696, 8576), Vector(5760, 8695), Vector(5852, 8852)}
				for j = 1, #positionTable, 1 do
					local stone = Redfall:SpawnCrimsythShadow(positionTable[j], Vector(0.3, 1), true)
					CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", stone, 2)
					Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, stone, "modifier_redfall_castle_entrance_unit", {})
				end
				EmitSoundOnLocationWithCaster(positionTable[1], "Redfall.CastleSpawner.Spawn", Redfall.RedfallMaster)
				UTIL_Remove(caster)
			end)
		end)
	end
end

function attackable_prop_think(event)
	local caster = event.caster
	caster:SetAbsOrigin(caster.basePosition)
end

function CastleSwitch1Trigger(event)
	if Redfall.CastleStart and Redfall.CastleSwitch1Active then
		Redfall.CastleSwitch1Active = false
		Redfall:ActivateSwitchGeneric(Vector(5950, 9138, 410 + Redfall.ZFLOAT), "CastleSwitch1", true, 0.165)
		local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(6795, 9088, 527 + Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 3.51)
		Redfall:CastleInitiateLavaRoom()
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleBlocker1", Vector(6783, 9025, 128 + Redfall.ZFLOAT), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end
end

function castle_entrance_unit_die(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Redfall.CastleEntranceUnitsKilled then
		Redfall.CastleEntranceUnitsKilled = 0
	end
	Redfall.CastleEntranceUnitsKilled = Redfall.CastleEntranceUnitsKilled + 1
	if Redfall.CastleEntranceUnitsKilled == 3 then
		Redfall:DropCastleSwtich(Redfall.Castle.Switch1, 0)
		Timers:CreateTimer(1.8, function()
			Redfall.CastleSwitch1Active = true
		end)
	end
end

function LavaDrainTrigger(trigger)
	local hero = trigger.activator
	if not Redfall.LavaDrainTriggered then
		if Redfall.Castle.LavaFlood then
			Redfall.LavaDrainTriggered = true
			Redfall:ActivateSwitchGeneric(Vector(7096, 6814, 519 + Redfall.ZFLOAT), "LavaDrainSwitch", true, 0.148)
			Timers:CreateTimer(0.5, function()
				StartSoundEvent("Redfall.LavaDrain", hero)
				Timers:CreateTimer(4, function()
					Redfall.Castle.LavaDrained = true
				end)
				for i = 1, 350, 1 do
					Timers:CreateTimer(0.03 * i, function()
						Redfall.Castle.LavaFlood:SetAbsOrigin(Redfall.Castle.LavaFlood:GetAbsOrigin() - Vector(0, 0, 0.3))
					end)
				end
				Timers:CreateTimer(10.5, function()
					StopSoundEvent("Redfall.LavaDrain", hero)
					EmitSoundOnLocationWithCaster(Vector(7101, 6812, 304), "Redfall.LavaDrainEnd", Redfall.RedfallMaster)
				end)
				for i = 1, 18 + GameState:GetDifficultyFactor() * 6, 1 do
					Timers:CreateTimer(i * 0.1, function()
						local luck = RandomInt(1, 3)
						local randomPosition = Vector(0, 0)
						if luck == 1 then
							randomPosition = Vector(7488 + RandomInt(1, 450), 8768 + RandomInt(1, 1600))
						else
							randomPosition = Vector(7056 + RandomInt(1, 1420), 7757 + RandomInt(1, 755))
						end
						--print("SPAWN LIZARD")
						--print(randomPosition)
						local lizard = Redfall:SpawnCastleLavaLizard(randomPosition, RandomVector(1))
						lizard:SetAbsOrigin(lizard:GetAbsOrigin() - Vector(0, 0, 300))
					end)
				end
			end)
		end
	end
end

function CastleFlameJumperBlue(trigger)
	local hero = trigger.activator
	hero:AddNoDraw()
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_redfall_in_castle_flame", {duration = 6})

	local position = hero:GetAbsOrigin()
	local dummy = CreateUnitByName("npc_dummy_unit", Vector(-3518, 13625, 183), false, nil, nil, hero:GetTeamNumber())
	dummy:AddAbility("ability_red_effect"):SetLevel(1)
	Timers:CreateTimer(0.5, function()
		WallPhysics:Jump(dummy, Vector(1, 0), 6, 48, 46, 0.8)
	end)
	Timers:CreateTimer(4, function()
		hero:SetAbsOrigin(dummy:GetAbsOrigin())
		EmitSoundOn("Redfall.CastleFireJumpEnd", hero)
		Timers:CreateTimer(0.1, function()
			hero:RemoveNoDraw()
		end)
		UTIL_Remove(dummy)
		local particleName = "particles/dire_fx/bad_ancient002_destroy_fire.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		StartAnimation(hero, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
		hero:RemoveModifierByName("modifier_redfall_in_castle_flame")
	end)
end

function CastleFlameJumper1(trigger)
	local hero = trigger.activator
	hero:AddNoDraw()
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_redfall_in_castle_flame", {duration = 6})

	local position = hero:GetAbsOrigin()
	local dummy = CreateUnitByName("npc_dummy_unit", Vector(7098, 10300, 321), false, nil, nil, hero:GetTeamNumber())
	dummy:AddAbility("ability_red_effect"):SetLevel(1)
	Timers:CreateTimer(0.5, function()
		WallPhysics:Jump(dummy, Vector(1, 0), 17, 27, 30, 0.8)
	end)
	Timers:CreateTimer(4, function()
		hero:SetAbsOrigin(dummy:GetAbsOrigin())
		EmitSoundOn("Redfall.CastleFireJumpEnd", hero)
		Timers:CreateTimer(0.1, function()
			hero:RemoveNoDraw()
		end)
		UTIL_Remove(dummy)
		local particleName = "particles/dire_fx/bad_ancient002_destroy_fire.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		StartAnimation(hero, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
		hero:RemoveModifierByName("modifier_redfall_in_castle_flame")
	end)
end

function CastleFlameJumper2(trigger)
	if Redfall.Castle.LavaRoomJumpTable[1] then
		local hero = trigger.activator
		hero:AddNoDraw()
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_redfall_in_castle_flame", {duration = 6})

		local position = hero:GetAbsOrigin()
		local dummy = CreateUnitByName("npc_dummy_unit", Vector(8424, 10319, 270 + Redfall.ZFLOAT), false, nil, nil, hero:GetTeamNumber())
		dummy:AddAbility("ability_red_effect"):SetLevel(1)
		Timers:CreateTimer(0.5, function()
			WallPhysics:Jump(dummy, Vector(0, -1), 19, 27, 33, 0.8)
		end)
		Timers:CreateTimer(4, function()
			hero:SetAbsOrigin(dummy:GetAbsOrigin())
			EmitSoundOn("Redfall.CastleFireJumpEnd", hero)
			Timers:CreateTimer(0.1, function()
				hero:RemoveNoDraw()
			end)
			UTIL_Remove(dummy)
			local particleName = "particles/dire_fx/bad_ancient002_destroy_fire.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
			ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			StartAnimation(hero, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			hero:RemoveModifierByName("modifier_redfall_in_castle_flame")
		end)
	end
end

function CastleFlameJumper3(trigger)
	if Redfall.Castle.LavaRoomJumpTable[2] then
		local hero = trigger.activator
		hero:AddNoDraw()
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_redfall_in_castle_flame", {duration = 6})

		local position = hero:GetAbsOrigin()
		local dummy = CreateUnitByName("npc_dummy_unit", Vector(8392, 8986, 360 + Redfall.ZFLOAT), false, nil, nil, hero:GetTeamNumber())
		dummy:AddAbility("ability_red_effect"):SetLevel(1)
		Timers:CreateTimer(0.5, function()
			WallPhysics:Jump(dummy, Vector(0, -1), 26, 27, 38, 0.8)
			AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(8384, 7168), 240, 10, false)
		end)
		Timers:CreateTimer(3.8, function()
			hero:SetAbsOrigin(dummy:GetAbsOrigin())
			EmitSoundOn("Redfall.CastleFireJumpEnd", hero)
			Timers:CreateTimer(0.1, function()
				hero:RemoveNoDraw()
			end)
			UTIL_Remove(dummy)
			local particleName = "particles/dire_fx/bad_ancient002_destroy_fire.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
			ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			StartAnimation(hero, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			hero:RemoveModifierByName("modifier_redfall_in_castle_flame")
		end)
	end
end

function CastleFlameJumper4(trigger)
	if Redfall.Castle.LavaRoomJumpTable[3] then
		local hero = trigger.activator
		hero:AddNoDraw()
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_redfall_in_castle_flame", {duration = 6})

		local position = hero:GetAbsOrigin()
		local dummy = CreateUnitByName("npc_dummy_unit", Vector(8328, 6943, 370 + Redfall.ZFLOAT), false, nil, nil, hero:GetTeamNumber())
		dummy:AddAbility("ability_red_effect"):SetLevel(1)
		Timers:CreateTimer(0.5, function()
			WallPhysics:Jump(dummy, Vector(-1, 0), 17, 27, 30, 0.8)
		end)
		Timers:CreateTimer(3.6, function()
			hero:SetAbsOrigin(dummy:GetAbsOrigin())
			EmitSoundOn("Redfall.CastleFireJumpEnd", hero)
			Timers:CreateTimer(0.1, function()
				hero:RemoveNoDraw()
			end)
			UTIL_Remove(dummy)
			local particleName = "particles/dire_fx/bad_ancient002_destroy_fire.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
			ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			StartAnimation(hero, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			hero:RemoveModifierByName("modifier_redfall_in_castle_flame")
		end)
	end
end

function castle_flame_start(event)
	local hero = event.target
	local particleName = "particles/dire_fx/bad_ancient002_destroy_fire.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
	ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin() + Vector(0, 0, 30))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Redfall.FireballPassive", hero)

end

function warflayer_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	Filters:MagicImmuneBreak(attacker, target)
end

function lava_room_unit_die(event)
	local platformIndex = event.unit.platformIndex
	if not Redfall.Castle.PlatformKillTable then
		Redfall.Castle.PlatformKillTable = {0, 0, 0}
	end
	Redfall.Castle.PlatformKillTable[platformIndex] = Redfall.Castle.PlatformKillTable[platformIndex] + 1
	if Redfall.Castle.PlatformKillTable[platformIndex] == platformIndex + 1 then
		local position = Vector(0, 0)
		if platformIndex == 1 then
			position = Vector(8424, 10319, 260 + Redfall.ZFLOAT)
		elseif platformIndex == 2 then
			position = Vector(8392, 8986, 350 + Redfall.ZFLOAT)
		elseif platformIndex == 3 then
			position = Vector(8328, 6943, 360 + Redfall.ZFLOAT)
		end
		local pfx = ParticleManager:CreateParticle("particles/redfall/castle_fire_pod.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, position)
		Redfall.Castle.LavaRoomJumpTable[platformIndex] = true
	end
end

function LavaFloodRoomTrigger(trigger)
	if Redfall.Castle.LavaDrained then
		if not Redfall.Castle.LavaSwitch then
			Redfall.Castle.LavaSwitch = true
			Redfall:ActivateSwitchGeneric(Vector(8299, 9625, -133 + Redfall.ZFLOAT), "CastleLavaSwitch", true, 0.182)
			local walls = Entities:FindAllByNameWithin("CastleWall2", Vector(8690, 8049, 521 + Redfall.ZFLOAT), 2000)
			Redfall:Walls(false, walls, true, 3.88)
			Redfall:InitializeMazeBattlementsRoom()
			Timers:CreateTimer(5, function()
				local blockers = Entities:FindAllByNameWithin("LavaFloodRoomBlocker", Vector(8685, 8000, 128 + Redfall.ZFLOAT), 3000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
		end
	end
end

function lava_lizard_think(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_jumping") and caster.aggro then
		if caster:IsAlive() then
			StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_TELEPORT_END, rate = 0.7})
			WallPhysics:Jump(caster, caster:GetForwardVector(), RandomInt(2, 10), 30, 14, 1.4)
		end
	end
	if not caster.aggro then
		local forward = RandomVector(1)
		WallPhysics:Jump(caster, forward, RandomInt(2, 8), 30, 14, 1.4)
		local randomPosition = Vector(0, 0)
		if luck == 1 then
			randomPosition = Vector(7488 + RandomInt(1, 450), 8768 + RandomInt(1, 1600))
		else
			randomPosition = Vector(7056 + RandomInt(1, 1420), 7757 + RandomInt(1, 755))
		end
		caster:MoveToPositionAggressive(randomPosition)
	end
end

function MazeRoomTrigger1(trigger)
	if not Redfall.Castle.MazeSwitch1 then
		Redfall.Castle.MazeSwitch1 = true
		Redfall:ActivateSwitchGeneric(Vector(9620, 9890, -5 + Redfall.ZFLOAT), "MazeRoomSwitch1", true, 0.163)
		local walls = Entities:FindAllByNameWithin("CastleWall3", Vector(10078, 9032, 457 + Redfall.ZFLOAT), 1200)
		Redfall:Walls(false, walls, true, 3.32)
		Redfall:InitializeMazeBattlementsRoom2()
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("MazeRoomBlocker", Vector(10111, 9085, 146 + Redfall.ZFLOAT), 1400)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end
end

function barrel_throw(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()

	local flare = CreateUnitByName("redfall_thrown_barrel", caster:GetAbsOrigin() + fv * 10, false, caster, nil, caster:GetTeamNumber())
	flare:SetOriginalModel("models/rolling_barrel.vmdl")
	flare:SetModel("models/rolling_barrel.vmdl")
	flare:SetRenderColor(255, 140, 0)
	flare:SetModelScale(0.1)
	flare.fv = fv
	flare.roll = -180
	flare.stun_duration = 2
	flare.forwardVelocity = 21
	flare.interval = 0
	flare.damage = event.damage
	flare.origCaster = caster
	flare.origAbility = ability
	flare:SetForwardVector(fv)
	StartSoundEvent("Redfall.TongeyKong.BarrellThrow.Barrel", flare)
	ability:ApplyDataDrivenModifier(caster, flare, "modifier_for_the_barrel", {})
	ability.barrel = flare
end

function barrel_rolling_think(event)
	local barrel = event.target
	if not IsValidEntity(barrel) then
		return false
	end
	local fv = barrel.fv
	local yaw = WallPhysics:vectorToAngle(WallPhysics:rotateVector(fv, math.pi / 2))
	-- barrel:SetForwardVector(WallPhysics:rotateVector(fv,math.pi/2))
	local currentRoll = barrel.roll
	local newRoll = barrel.roll + 10
	barrel.roll = newRoll
	if newRoll > 180 then
		barrel.roll = -180
	end

	barrel:SetModelScale(math.min((0.1 + barrel.interval / 4), 1.0))

	barrel:SetAngles(0, yaw, barrel.roll)
	if barrel.forwardVelocity < 2 then
		local eventTable = {}
		eventTable.unit = barrel
		barrel_explode(eventTable)
	end
	local velocityChange = -0.3
	local newPosition = barrel:GetAbsOrigin() + barrel.fv * barrel.forwardVelocity
	local obstruction = WallPhysics:FindNearestObstruction(newPosition + barrel.fv)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition + barrel.fv, barrel)
	if blockUnit then
		barrel.forwardVelocity = barrel.forwardVelocity / 2
		-- barrel.fv = WallPhysics:rotateVector(barrel.fv*-1, 2*math.pi*RandomInt(-5,5)/180)
		-- local normal = WallPhysics:rotateVector((obstruction:GetAbsOrigin() - barrel:GetAbsOrigin()):Normalized(), math.pi/2)
		local normal = ((obstruction:GetAbsOrigin() - barrel:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		normal = WallPhysics:rotateVector(normal, math.pi / 2)
		local reflectionVector = 2 * (normal:Dot(barrel.fv, normal)) * normal - barrel.fv
		barrel.fv = reflectionVector:Normalized()
		newPosition = barrel:GetAbsOrigin() + (barrel.fv * barrel.forwardVelocity * 2)
		barrel:SetAbsOrigin(GetGroundPosition(newPosition, barrel) + Vector(0, 0, 25))
		EmitSoundOn("Redfall.TongeyKong.BarrelHitWall", barrel)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, barrel)
		ParticleManager:SetParticleControl(pfx, 0, barrel:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	else
		local slopeEffect = GetGroundHeight(barrel:GetAbsOrigin(), barrel) - GetGroundHeight(newPosition, barrel)
		velocityChange = velocityChange + slopeEffect / 10
		barrel:SetAbsOrigin(GetGroundPosition(newPosition, barrel) + Vector(0, 0, 25))
	end
	barrel.forwardVelocity = barrel.forwardVelocity + velocityChange
	barrel.interval = barrel.interval + 1
	if barrel.interval % 44 == 0 then
		StartSoundEvent("Redfall.TongeyKong.BarrellThrow.Barrel2", barrel)
	end
end

function barrel_thrower_take_damage(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_barrel_throw_run_cooldown") then
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_barrel_throw_run_cooldown", {duration = 5.5})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_barrel_throw_running", {duration = 1.2})

		StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_RUN, rate = 1, translate = "haste"})
		EmitSoundOn("Redfall.TongeyKong.TakeDamage", caster)
		local attacker = event.attacker
		local moveVector = ((caster:GetAbsOrigin() - attacker:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		caster:MoveToPosition(caster:GetAbsOrigin() + moveVector * 400)
		caster.faceUnit = attacker
	end
end

function tongey_run_end(event)
	local caster = event.caster
	local ability = event.ability
	local forward = ((caster.faceUnit:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	caster:Stop()
	Timers:CreateTimer(0.1, function()
		caster:MoveToPosition(caster:GetAbsOrigin() + forward * 3)
	end)
end

function barrel_impact(event)
	local eventTable = {}
	eventTable.unit = event.ability.barrel
	barrel_explode(eventTable)
end

function barrel_explode(event)
	local barrel = event.unit
	if not IsValidEntity(barrel.origCaster) or not IsValidEntity(barrel.origAbility) then
		barrel:RemoveModifierByName("modifier_for_the_barrel")
		Timers:CreateTimer(0.09, function()
			UTIL_Remove(barrel)
		end)
		return false
	end
	local enemies = FindUnitsInRadius(barrel.origCaster:GetTeamNumber(), barrel:GetAbsOrigin(), nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = barrel.damage
	flareParticle(barrel:GetAbsOrigin())
	StopSoundEvent("Redfall.TongeyKong.BarrellThrow.Barrel", barrel)
	StopSoundEvent("Redfall.TongeyKong.BarrellThrow.Barrel2", barrel)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = barrel.origCaster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			Filters:ApplyStun(barrel.origCaster, barrel.stun_duration, enemy)
		end
	end
	EmitSoundOn("Redfall.BarrelThrow.BombExplode", barrel)
	local cd = barrel.origAbility:GetCooldownTimeRemaining()
	if cd < 5.5 then
		barrel.origAbility:EndCooldown()
	else
		Timers:CreateTimer(2, function()
			barrel.origAbility:EndCooldown()
		end)
	end
	barrel:RemoveModifierByName("modifier_for_the_barrel")
	Timers:CreateTimer(0.09, function()
		UTIL_Remove(barrel)
	end)
end

function barrel_thrower_ai_think(event)
	local caster = event.caster
	local ability = event.ability
	local newOrder = {
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ability:entindex(),
	}

	ExecuteOrderFromTable(newOrder)
end

function CastleRifleTrigger(event)
	if not Redfall.Castle then
		return false
	end
	for i = 1, 10, 1 do
		Timers:CreateTimer(i * 0.2, function()
			local rifle = Redfall:SpawnCrimsythGunman(Vector(7823, 10816), Vector(1, 0))
			Timers:CreateTimer(0.1, function()
				rifle:MoveToPositionAggressive(Vector(8961, 10431) + RandomVector(RandomInt(1, 140)))
			end)
		end)
	end
	local gunmanElite = Redfall:SpawnCrimsythGunmanElite(Vector(6336, 10816), Vector(1, 0))
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, gunmanElite, "modifier_castle_unit_generic", {})
	gunmanElite.code = 0
	local positionTable = {Vector(7552, 10784), Vector(7296, 10880), Vector(7040, 10752)}
	for i = 1, #positionTable, 1 do
		Redfall:SpawnCrimsythKhanKnight(positionTable[i], Vector(1, 0))
	end
end

function khan_knight_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local blind_duration = event.blind_duration
	if ability:GetCooldownTimeRemaining() < 0.1 then
		CustomAbilities:QuickAttachParticle("particles/econ/items/slardar/slardar_takoyaki_gold/slardar_crush_tako_ground_dust_pyro_gold.vpcf", caster, 2)
		-- local pfx = ParticleManager:CreateParticle( "particles/econ/items/slardar/slardar_takoyaki_gold/slardar_crush_tako_ground_dust_pyro_gold.vpcf", PATTACH_WORLDORIGIN, caster )
		-- ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_WORLDORIGIN, "attach_hitloc", caster:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl(pfx, 1, Vector(320, 2, 320))
		-- Timers:CreateTimer(1, function()
		--   ParticleManager:DestroyParticle( pfx, false )
		-- end)
		ability:StartCooldown(1.5)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_khan_knight_blind", {duration = blind_duration})
			end
		end
	end
end

function generic_castle_unit_die(event)
	local unit = event.unit
	if unit.code then
		if unit.code == 0 then
			local switch = Entities:FindByNameNearest("MazeRoomSwitch2", Vector(6040, 10827, 28 + Redfall.ZFLOAT), 800)

			switch:SetAbsOrigin(switch:GetAbsOrigin() + Vector(0, 0, 1485 + 500))
			Redfall.Castle.switchfallVelocity3 = 0
			for i = 1, 54, 1 do
				Timers:CreateTimer(i * 0.03, function()
					Redfall.Castle.switchfallVelocity3 = Redfall.Castle.switchfallVelocity3 + 1
					switch:SetAbsOrigin(switch:GetAbsOrigin() - Vector(0, 0, Redfall.Castle.switchfallVelocity3))
				end)
			end
			Timers:CreateTimer(1.6, function()
				Redfall.Castle.MazeSwitch2Active = true
				local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(particle1, 0, switch:GetAbsOrigin())
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Redfall.SwitchImpact", Events.GameMaster)
			end)
		elseif unit.code == 1 then
			if not Redfall.Castle.SnipersKilled then
				Redfall.Castle.SnipersKilled = 0
			end
			Redfall.Castle.SnipersKilled = Redfall.Castle.SnipersKilled + 1
			if Redfall.Castle.SnipersKilled == 3 then
				local switch = Entities:FindByNameNearest("MazeRoomSwitch3", Vector(11482, 9898, -500 + Redfall.ZFLOAT), 800)

				switch:SetAbsOrigin(switch:GetAbsOrigin() + Vector(0, 0, 1485 + 500))
				Redfall.Castle.switchfallVelocity3 = 0
				for i = 1, 54, 1 do
					Timers:CreateTimer(i * 0.03, function()
						Redfall.Castle.switchfallVelocity3 = Redfall.Castle.switchfallVelocity3 + 1
						switch:SetAbsOrigin(switch:GetAbsOrigin() - Vector(0, 0, Redfall.Castle.switchfallVelocity3))
					end)
				end
				Timers:CreateTimer(1.6, function()
					Redfall.Castle.MazeSwitch3Active = true
					local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
					local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
					ParticleManager:SetParticleControl(particle1, 0, switch:GetAbsOrigin())
					Timers:CreateTimer(2, function()
						ParticleManager:DestroyParticle(particle1, false)
					end)
					EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Redfall.SwitchImpact", Events.GameMaster)
				end)
			end
		elseif unit.code == 2 then
			if not Redfall.Castle.TortureUnitsKilled then
				Redfall.Castle.TortureUnitsKilled = 0
			end
			Redfall.Castle.TortureUnitsKilled = Redfall.Castle.TortureUnitsKilled + 1
			if Redfall.Castle.TortureUnitsKilled == 40 then
				local buildTable = {Vector(9984, 7168), Vector(9984, 6848), Vector(10432, 6412), Vector(10832, 6601)}
				for i = 1, #buildTable, 1 do
					Timers:CreateTimer((i - 1) * 4, function()
						EmitSoundOn("Redfall.TortureBoss.VO.Laugh"..RandomInt(1, 2), Redfall.Castle.tortureBoss)
						StartAnimation(Redfall.Castle.tortureBoss, {duration = 3.8, activity = ACT_DOTA_VICTORY, rate = 1.0})
						local bombadier = Redfall:SpawnTorturePuppet(buildTable[i] + RandomVector(150), RandomVector(1))
						bombadier:SetModelScale(0.01)
						bombadier.scale = 0.01
						Redfall.Castle.tortureBoss.ability:ApplyDataDrivenModifier(Redfall.Castle.tortureBoss, bombadier, "modifier_sadist_building_unit", {duration = 4})
					end)
				end
				--print("TORTURED SOUL TIME")
				Redfall:SpawnTortureWaveUnit("redfall_tortured_soul", Vector(10432, 6144), 11, 100, 0.7, true)
				Redfall:SpawnTortureWaveUnit("redfall_tortured_soul", Vector(11008, 6464), 11, 100, 0.7, true)
				Redfall:SpawnTortureWaveUnit("redfall_tortured_soul", Vector(11264, 7168), 11, 100, 0.7, true)
			elseif Redfall.Castle.TortureUnitsKilled == 70 then
				local buildTable = {Vector(9984, 7168), Vector(9984, 6848)}
				for i = 1, #buildTable, 1 do
					Timers:CreateTimer((i - 1) * 4, function()
						EmitSoundOn("Redfall.TortureBoss.VO.Laugh"..RandomInt(1, 2), Redfall.Castle.tortureBoss)
						StartAnimation(Redfall.Castle.tortureBoss, {duration = 3.8, activity = ACT_DOTA_VICTORY, rate = 1.0})
						local bombadier = Redfall:SpawnTorturePuppet(buildTable[i] + RandomVector(150), RandomVector(1))
						bombadier:SetModelScale(0.01)
						bombadier.scale = 0.01
						Redfall.Castle.tortureBoss.ability:ApplyDataDrivenModifier(Redfall.Castle.tortureBoss, bombadier, "modifier_sadist_building_unit", {duration = 4})
					end)
				end
				--print("TORTURED SOUL TIME")
				Redfall:SpawnTortureWaveUnit("redfall_tortured_soul", Vector(10432, 6144), 10, 100, 0.8, true)
				--print("CORRUPTED CORPSE TIME")
				Redfall:SpawnTortureWaveUnit("redfall_crimsyth_corrupted_corpse", Vector(11008, 6464), 10, 100, 0.8, true)
				--print("KHAN KNIGHT TIME")
				Redfall:SpawnTortureWaveUnit("redfall_crimsyth_khan_knight", Vector(11264, 7168), 5, 100, 1.6, true)
			elseif Redfall.Castle.TortureUnitsKilled == 95 then
				local buildTable = {Vector(9984, 7168), Vector(9984, 6848), Vector(10432, 6412), Vector(10832, 6601)}
				for i = 1, #buildTable, 1 do
					Timers:CreateTimer((i - 1) * 4, function()
						EmitSoundOn("Redfall.TortureBoss.VO.Laugh"..RandomInt(1, 2), Redfall.Castle.tortureBoss)
						StartAnimation(Redfall.Castle.tortureBoss, {duration = 3.8, activity = ACT_DOTA_VICTORY, rate = 1.0})
						local bombadier = Redfall:SpawnTorturePuppet(buildTable[i] + RandomVector(150), RandomVector(1))
						bombadier:SetModelScale(0.01)
						bombadier.scale = 0.01
						Redfall.Castle.tortureBoss.ability:ApplyDataDrivenModifier(Redfall.Castle.tortureBoss, bombadier, "modifier_sadist_building_unit", {duration = 4})
					end)
				end
				Redfall:SpawnTortureWaveUnit("redfall_crimsyth_cultist_elite", Vector(10432, 6144), 12, 100, 0.7, true)
				Redfall:SpawnTortureWaveUnit("redfall_crimsyth_cultist_elite", Vector(11008, 6464), 12, 100, 0.7, true)
				Redfall:SpawnTortureWaveUnit("redfall_crimsyth_cultist_elite", Vector(11264, 7168), 12, 100, 0.7, true)
			elseif Redfall.Castle.TortureUnitsKilled == 130 then
				Redfall.Castle.tortureBoss:RemoveModifierByName("modifier_sadist_waiting")
				Redfall.Castle.tortureBoss:RemoveModifierByName("modifier_sadist_z_flight")
				EmitSoundOn("Redfall.TortureBoss.VO.BattleStart", Redfall.Castle.tortureBoss)
				Redfall.Castle.tortureBoss.ability:ApplyDataDrivenModifier(Redfall.Castle.tortureBoss, Redfall.Castle.tortureBoss, "modifier_sadist_combat", {})
			end
		elseif unit.code == 3 then
			garden_treant_death()
		elseif unit.code == 4 then
			rock_mini_golem_death()
		elseif unit.code == 5 then
			local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(-1924, 13556, 463 + Redfall.ZFLOAT), 2000)
			Redfall:Walls(false, walls, true, 3.76)
			Timers:CreateTimer(3.1, function()
				Redfall:InitializeBluePlatformRoom()
			end)
			Timers:CreateTimer(5, function()
				local blockers = Entities:FindAllByNameWithin("CastleWallBlocker", Vector(-1984, 13568, 128 + Redfall.ZFLOAT), 1800)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
		elseif unit.code == 6 then
			crystal_wave_unit_death()
		elseif unit.code == 7 then
			Redfall:LavaCrystalSwitch(unit)
		elseif unit.code == 8 then
			archer_water_room_die()
		elseif unit.code == 9 then
			EmitSoundOn("Redfall.CastleGroundsGuardian.Aggro", unit)
			Redfall:CastleGroundsGuardianDie()
		elseif unit.code == 10 then
			Redfall:ElthezunWaveUnitDie(unit)
		elseif unit.code == 11 then
			Redfall:FinallBossUnitDie(unit)
		end
	end
end

function MazeRoomTrigger2(trigger)
	local hero = trigger.activator
	if Redfall.CastleStart and Redfall.Castle.MazeSwitch2Active then
		Dungeons:CreateBasicCameraLockForHeroes(Vector(9724, 8650, 463 + Redfall.ZFLOAT), 3, {hero})
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(9724, 8650), 600, 8, false)
		Redfall.Castle.MazeSwitch2Active = false
		Redfall:ActivateSwitchGeneric(Vector(6040, 10827, 528 + Redfall.ZFLOAT), "MazeRoomSwitch2", true, 0.165)
		local walls = Entities:FindAllByNameWithin("CastleWall4", Vector(9724, 8650, 463 + Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 3.51)
		Timers:CreateTimer(3.1, function()
			Redfall:InitializeMazeBattlementsRoom3()
		end)
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("MazeRoomBlocker2", Vector(9705, 8637, 147 + Redfall.ZFLOAT), 2400)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)

	end
end

function castle_viking_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * 0.005
	flareParticle(target:GetAbsOrigin())
	EmitSoundOn("Redfall.EnclaveViking.AttackExplosion", target)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			Filters:ApplyStun(attacker, 0.1, enemy)
		end
	end

end

function CastleMazeCornerTrigger(event)
	Redfall:SpawnCrimsythKhanKnight(Vector(11008, 7872), Vector(-1, 0))
	Redfall:SpawnCrimsythKhanKnight(Vector(11392, 7932), Vector(-1, 0))

	Redfall:SpawnCrimsythKhanKnight(Vector(11392, 7932), Vector(-1, 0))
	Redfall:SpawnCrimsythKhanKnight(Vector(11392, 7932), Vector(-1, 0))
	Redfall:SpawnCrimsythGunmanElite(Vector(11328, 8320), Vector(-1, -1))
	Redfall:SpawnHawkSoldierElite(Vector(11072, 8192), Vector(-0.3, -1))

	for i = 1, 9 + GameState:GetDifficultyFactor() * 3, 1 do
		Redfall:SpawnEnclaveViking(Vector(10880 + RandomInt(1, 720), 9091 + RandomInt(0, 205)), Vector(0, -1))
	end
	local luck = RandomInt(1, 2)
	if luck == 1 then
		Redfall:SpawnCastleWarflayer(Vector(11439, 8568), Vector(0, -1))
	end

end

function MazeRoomTrigger3(trigger)
	local hero = trigger.activator
	if Redfall.CastleStart and Redfall.Castle.MazeSwitch3Active then
		Dungeons:CreateBasicCameraLockForHeroes(Vector(9095, 7547), 3, {hero})
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(9095, 7547), 600, 8, false)
		Redfall.Castle.MazeSwitch3Active = false

		Redfall:ActivateSwitchGeneric(Vector(6040, 10827, 0 + Redfall.ZFLOAT), "MazeRoomSwitch3", true, 0.165)

		local walls = Entities:FindAllByNameWithin("CastleWall5", Vector(9095, 7547, 430 + Redfall.ZFLOAT), 1400)
		Redfall:Walls(false, walls, true, 3.51)
		Timers:CreateTimer(3.1, function()
			Redfall:InitializeCastleTortureRoom()
		end)
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleBlocker2", Vector(8937, 7626, 147 + Redfall.ZFLOAT), 1600)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end
end

function TortureRoomStartTrigger(trigger)
	if not Redfall.ErakorStarted then
		Redfall.Castle.DoomParticleTable = {}
		local tortureBoss = Redfall.Castle.tortureBoss
		EmitSoundOn("Redfall.TortureBoss.VO.Greeting", tortureBoss)
		tortureBoss.ability:ApplyDataDrivenModifier(tortureBoss, tortureBoss, "modifier_sadist_z_flight", {})
		Redfall.ErakorStarted = true
		for i = 1, 80, 1 do
			Timers:CreateTimer(i * 0.03, function()
				if i <= 40 then
					tortureBoss:SetModelScale(1.4 + i * 0.01)
				else
					tortureBoss:SetModelScale(1.8 - (i - 40) * 0.01)
				end
				tortureBoss:SetModifierStackCount("modifier_sadist_z_flight", tortureBoss, i * 2)
			end)
		end
		Timers:CreateTimer(2.4, function()
			EmitSoundOn("Redfall.TortureBoss.VO.Laugh1", tortureBoss)
			tortureBoss:MoveToPosition(Vector(10432, 6347))
			Timers:CreateTimer(1.2, function()
				StartAnimation(tortureBoss, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0, translate = "deadwinter_soul"})
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, Vector(10432, 6144, 2 + Redfall.ZFLOAT))
				table.insert(Redfall.Castle.DoomParticleTable, pfx)
				Timers:CreateTimer(1.5, function()
					Redfall:SpawnTortureWaveUnit("redfall_crimsyth_corrupted_corpse", Vector(10432, 6144), 14, 100, 0.7, true)
				end)
			end)
		end)
		Timers:CreateTimer(5.4, function()
			tortureBoss:MoveToPosition(Vector(10908, 6464))
			Timers:CreateTimer(1.2, function()
				EmitSoundOn("Redfall.TortureBoss.VO.Laugh2", tortureBoss)
				StartAnimation(tortureBoss, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0, translate = "deadwinter_soul"})
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, Vector(11008, 6464, 2 + Redfall.ZFLOAT))
				table.insert(Redfall.Castle.DoomParticleTable, pfx)
				Timers:CreateTimer(1.5, function()
					Redfall:SpawnTortureWaveUnit("redfall_crimsyth_corrupted_corpse", Vector(11008, 6464), 14, 100, 0.7, true)
				end)
			end)
		end)
		Timers:CreateTimer(10, function()
			tortureBoss:MoveToPosition(Vector(11164, 7068))
			Timers:CreateTimer(1.2, function()
				EmitSoundOn("Redfall.TortureBoss.VO.Laugh1", tortureBoss)
				StartAnimation(tortureBoss, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0, translate = "deadwinter_soul"})
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, Vector(11264, 7168, 2 + Redfall.ZFLOAT))
				table.insert(Redfall.Castle.DoomParticleTable, pfx)
				Timers:CreateTimer(1.5, function()
					Redfall:SpawnTortureWaveUnit("redfall_crimsyth_corrupted_corpse", Vector(11264, 7168), 14, 100, 0.7, true)
				end)
			end)
		end)
		Timers:CreateTimer(13, function()
			for i = 1, 40, 1 do
				Timers:CreateTimer(i * 0.03, function()
					tortureBoss:SetModifierStackCount("modifier_sadist_z_flight", tortureBoss, 160 + i * 2)
				end)
			end
			tortureBoss:MoveToPosition(Vector(10333, 7451))
			Timers:CreateTimer(2, function()
				tortureBoss:MoveToPosition(tortureBoss:GetAbsOrigin() + Vector(0, -5, 0))
			end)
		end)
	end
end

function sadist_death(event)
	local caster = event.caster
	EmitSoundOn("Redfall.TortureBoss.VO.Death", caster)
	for i = 1, #Redfall.Castle.DoomParticleTable, 1 do
		ParticleManager:DestroyParticle(Redfall.Castle.DoomParticleTable[i], false)
	end
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollAndDropUniqueItem(caster, "item_rpc_crimson_skull_cap")
	end
	Redfall.Castle.DoomParticleTable = nil
	Timers:CreateTimer(1.5, function()
		local walls = Entities:FindAllByNameWithin("CastleWall6", Vector(10014, 6136, 490 + Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 3.81)
		Timers:CreateTimer(3.1, function()
			Redfall:InitializeArchivistRoom()
		end)
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleTortureWallBlocker", Vector(10012, 6208, 128 + Redfall.ZFLOAT), 2000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end)
end

function sadist_combat_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	local castAbility = caster:FindAbilityByName("sadist_blood_bath")
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = castAbility:entindex(),
				Position = castPoint
			}
			EmitSoundOn("Redfall.TortureBoss.VO.CastBloodBath", caster)
			ExecuteOrderFromTable(newOrder)
			return false
		end
	end
	EmitSoundOn("Redfall.Sadist.FireWave", caster)
	for i = -4, 4, 1 do
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), (2 * math.pi / 9) * i)
		local speed = 200
		local info =
		{
			Ability = ability,
			EffectName = "particles/units/heroes/hero_jakiro/jakiro_taunt_icemelt_fire.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 80),
			fDistance = 180,
			fStartRadius = 220,
			fEndRadius = 220,
			Source = caster,
			StartPosition = "attach_hitloc",
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
	caster.interval = caster.interval + 1
	if caster.interval % 8 == 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOn("Redfall.TortureBoss.VO.Attach", caster)
			ability:ApplyDataDrivenModifier(caster, enemies[1], "modifier_sadist_attach", {duration = 5})
		end

		caster.interval = 0
	end
end

function sadist_attach_think(event)
	local caster = event.caster
	local target = event.target
	local moveVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	caster:SetAbsOrigin(caster:GetAbsOrigin() + moveVector * 20)
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
	if distance < 120 or distance > 1950 then
		target:RemoveModifierByName("modifier_sadist_attach")
	end
end

function sadist_combat_start(event)
	local caster = event.caster
	local target = event.target
	local charges = event.shield_charges
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sadist_shield", {})
	caster:SetModifierStackCount("modifier_sadist_shield", caster, charges)

end

function archivist_found_hero(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not Redfall.Castle.ArchivistBattleStart then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_archivist_lock_on_player", {duration = 20})
	end
	if not Redfall.Castle.ArchivistSequenceBegin then
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(8813, 5504), 1500, 900, false)
		Redfall.Castle.ArchivistSequenceBegin = true
		EmitSoundOn("Redfall.Archivist.Greeting", caster)
		target.warlockMotionIndex = 0
		Timers:CreateTimer(4, function()
			caster:MoveToPosition(Vector(8849, 5952))
			Timers:CreateTimer(3.5, function()
				caster:MoveToPosition(Vector(8849, 5952) - Vector(0, 20))
				EmitSoundOn("Redfall.Archivist.Incantation", caster)
				for i = 0, 6, 1 do
					Timers:CreateTimer(i * 2, function()
						StartAnimation(caster, {duration = 2, activity = ACT_DOTA_FATAL_BONDS, rate = 0.8})
						Timers:CreateTimer(0.6, function()
							EmitSoundOn("Redfall.Molok.CrashingHands", caster)
							local pfx = ParticleManager:CreateParticle("particles/econ/wards/warlock/ward_warlock/warlock_ambient_ward_explosion.vpcf", PATTACH_POINT_FOLLOW, caster)
							ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
							Timers:CreateTimer(1.5, function()
								ParticleManager:DestroyParticle(pfx, false)
							end)
						end)
					end)
				end

				Timers:CreateTimer(3, function()
					EmitSoundOnLocationWithCaster(Vector(8813, 5504), "Redfall.ArchivistSummoning", caster)
					for i = 1, 26, 1 do
						Timers:CreateTimer(0.5 * i, function()
							ScreenShake(caster:GetAbsOrigin(), 2, 0.5, 0.9, 9000, 0, true)
						end)
					end
					Timers:CreateTimer(10, function()
						local moloth = Redfall:SpawnArchivistDemonMoloth(Vector(8813, 5504), Vector(0, -1))
						moloth:SetAbsOrigin(Vector(8813, 5504, moloth:GetAbsOrigin().z) - Vector(0, 0, 800))
						moloth:SetModelScale(0.03)
						moloth:FindAbilityByName("redfall_moloth_bombs"):StartCooldown(8)
						local molothAbility = moloth:FindAbilityByName("redfall_moloth_passive")
						molothAbility:ApplyDataDrivenModifier(moloth, moloth, "modifier_moloth_untouchable", {})
						Redfall.Castle.moloth = moloth
						for i = 1, 100, 1 do
							Timers:CreateTimer(0.03 * i, function()
								moloth:SetModelScale(0.028 * i)
								moloth:SetAbsOrigin(moloth:GetAbsOrigin() + Vector(0, 0, 4.2))
							end)
						end
						Timers:CreateTimer(1.5, function()
							EmitSoundOn("Redfall.CastleBoss.LavaEmerge", moloth)
							Redfall:CreateLavaBlast(moloth:GetAbsOrigin() + Vector(0, 0, 300))
						end)
						Timers:CreateTimer(3, function()
							EmitSoundOn("Redfall.Molok.Aggro", moloth)
							StartAnimation(moloth, {duration = 1.5, activity = ACT_DOTA_ATTACK, rate = 0.7})
							moloth.centerPoint = moloth:GetAbsOrigin()

							local sphere1 = Redfall:SpawnMolothSphere(Vector(0, 1))
							local sphere2 = Redfall:SpawnMolothSphere(WallPhysics:rotateVector(Vector(0, 1), 2 * math.pi / 3))
							local sphere3 = Redfall:SpawnMolothSphere(WallPhysics:rotateVector(Vector(0, 1), 4 * math.pi / 3))
							Redfall.Castle.BossSphereTable = {sphere1, sphere2, sphere3}
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_archivist_in_combat", {})
						end)

					end)
					Timers:CreateTimer(14, function()
						caster:RemoveModifierByName("modifier_the_archivist_waiting")
						Redfall.Castle.ArchivistBattleStart = true
						Dungeons:AggroUnit(caster)
					end)
				end)
			end)
		end)
	end
end

function archivist_hero_lock_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.warlockMotionIndex then
		target.warlockMotionIndex = 0
	end
	target.warlockMotionIndex = target.warlockMotionIndex + 1
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(math.sin(target.warlockMotionIndex * math.pi / 90) * 4, math.sin(target.warlockMotionIndex * math.pi / 90) *- 4, math.sin(target.warlockMotionIndex * math.pi / 90) * 3))
	if target.warlockMotionIndex > 360 then
		target.warlockMotionIndex = 0
	end
	if Redfall.Castle.ArchivistBattleStart then
		target:RemoveModifierByName("modifier_archivist_lock_on_player")
	end

end

function redfall_molok_bombs_ability_start(event)
	local caster = event.caster
	local ability = event.ability

	local target = event.target_points[1]
	local baseFV = (target * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local divisor = 40
	local forwardVelocity = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin()) / divisor + 6
	--print(baseFV)
	local bombCount = event.num_bombs
	local damage = event.damage

	for i = 0, bombCount - 1, 1 do
		Timers:CreateTimer(i * 0.2, function()
			local randomOffset = RandomInt(-16, 16)
			local flareAngle = WallPhysics:rotateVector(baseFV, math.pi * randomOffset / 160)
			local flare = CreateUnitByName("selethas_boomerang", caster:GetAbsOrigin() + Vector(0, 0, 400), false, caster, nil, caster:GetTeamNumber())
			flare:SetAbsOrigin(flare:GetAbsOrigin() + Vector(0, 0, 200))
			flare:SetOriginalModel("models/boss_sphere.vmdl")
			flare:SetModel("models/boss_sphere.vmdl")
			flare:SetRenderColor(0, 0, 0)
			flare:SetModelScale(0.1)
			flare.fv = flareAngle
			flare.stun_duration = 2
			flare.liftVelocity = 50
			flare.forwardVelocity = forwardVelocity + RandomInt(-3, 3)
			flare.interval = 0
			flare.damage = damage
			flare.origCaster = caster
			flare.origAbility = ability
			-- flare.altMaxScale = 1
			flare:AddAbility("redfall_bombadier_bomb_ability"):SetLevel(1)
			local flareSubAbility = flare:FindAbilityByName("redfall_bombadier_bomb_ability")
			flareSubAbility:ApplyDataDrivenModifier(flare, flare, "modifier_solar_projectile_motion", {})
			EmitSoundOn("Redfall.PumpkinFireLaunch", flare)
		end)
	end
end

function moloth_bombs_preattack(event)
	local caster = event.caster
	local passAbility = caster:FindAbilityByName("redfall_moloth_passive")
	passAbility:ApplyDataDrivenModifier(caster, caster, "modifier_moloth_disable_point_lock", {duration = 1})
	if caster:IsAlive() then
		StartAnimation(caster, {duration = 1.2, activity = ACT_DOTA_RUN, rate = 0.8})
		Redfall:CreateLavaBlast(caster:GetAbsOrigin() + Vector(0, 0, 80))
		for j = 1, 40, 1 do
			Timers:CreateTimer(0.03 * j, function()
				if caster:IsAlive() then
					if j <= 20 then
						caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 8))
					else
						caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, -8))
					end
				end
			end)
		end
	end
end

function moloth_combat_think(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("redfall_moloth_bombs")
	if caster.centerPoint then
		if not caster:HasModifier("modifier_moloth_disable_point_lock") then
			caster:SetAbsOrigin(caster.centerPoint)
		end
	end
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = castAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			return false
		end
	end
end

function moloth_sphere_think(event)
	local caster = event.caster
	caster.baseFV = WallPhysics:rotateVector(caster.baseFV, 2 * math.pi / 360)
	local centerPoint = Vector(8816, 5467)
	caster:SetAbsOrigin(centerPoint + caster.baseFV * 900 + Vector(0, 0, -90 + Redfall.ZFLOAT))
end

function moloth_sphere_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Redfall.Molok.Sphere.Change", caster)
	if not IsValidEntity(event.attacker) then
		return false
	end
	if not event.attacker:IsHero() then
		return false
	end
	if caster.colorCode == 0 or caster.colorCode == 3 then
		caster.colorCode = 1
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_moloth_sphere_red", {})
		caster:SetRenderColor(255, 0, 0)
		caster:RemoveModifierByName("modifier_moloth_sphere_blue")
		caster:RemoveModifierByName("modifier_moloth_sphere_green")
	elseif caster.colorCode == 1 then
		caster.colorCode = 2
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_moloth_sphere_blue", {})
		caster:SetRenderColor(0, 0, 255)
		caster:RemoveModifierByName("modifier_moloth_sphere_red")
		caster:RemoveModifierByName("modifier_moloth_sphere_green")
	elseif caster.colorCode == 2 then
		caster.colorCode = 3
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_moloth_sphere_green", {})
		caster:SetRenderColor(0, 255, 0)
		caster:RemoveModifierByName("modifier_moloth_sphere_blue")
		caster:RemoveModifierByName("modifier_moloth_sphere_red")
	end
	check_spheres_matching()
end

function check_spheres_matching()
	local colorCode = 0
	if Redfall.Castle.BossSphereTable[1].colorCode == Redfall.Castle.BossSphereTable[2].colorCode and Redfall.Castle.BossSphereTable[2].colorCode == Redfall.Castle.BossSphereTable[3].colorCode then
		colorCode = Redfall.Castle.BossSphereTable[1].colorCode
	end
	--print(colorCode)
	if colorCode > 0 then
		local modifierName = "modifier_moloth_sphere_on_moloth_red"
		if colorCode == 2 then
			modifierName = "modifier_moloth_sphere_on_moloth_blue"
		elseif colorCode == 3 then
			modifierName = "modifier_moloth_sphere_on_moloth_green"
		end
		for i = 1, 3, 1 do
			local ability = Redfall.Castle.BossSphereTable[i]:FindAbilityByName("redfall_moloth_sphere_ability")
			ability:ApplyDataDrivenModifier(Redfall.Castle.BossSphereTable[i], Redfall.Castle.moloth, modifierName, {})
		end
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_untouchable")
		EmitSoundOn("Redfall.Moloth.Vulnerable", Redfall.Castle.moloth)
		EmitSoundOnLocationWithCaster(Redfall.Castle.moloth:GetAbsOrigin(), "Redfall.Moloth.VulnerableMagic", Events.GameMaster)
		ScreenShake(Redfall.Castle.moloth:GetAbsOrigin(), 2, 2, 1.5, 9000, 0, true)
	else
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_red")
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_red")
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_red")
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_blue")
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_blue")
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_blue")
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_green")
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_green")
		Redfall.Castle.moloth:RemoveModifierByName("modifier_moloth_sphere_on_moloth_green")
		local molothAbility = Redfall.Castle.moloth:FindAbilityByName("redfall_moloth_passive")
		molothAbility:ApplyDataDrivenModifier(Redfall.Castle.moloth, Redfall.Castle.moloth, "modifier_moloth_untouchable", {})
	end
end

function archivist_orb_change_start(event)
	local caster = event.caster
	local target = event.target

	local particleName = "particles/units/heroes/hero_tinker/tinker_laser.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 9, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(0.8, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local eventTable = {}
	eventTable.caster = target
	eventTable.ability = target:FindAbilityByName("redfall_moloth_sphere_ability")
	moloth_sphere_take_damage(eventTable)
	EmitSoundOn("Redfall.Archivist.SphereChanger", caster)
end

function archivist_in_combat_think(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("redfall_archivist_orb_changer")
	if castAbility:IsFullyCastable() then
		local sphere = Redfall.Castle.BossSphereTable[RandomInt(1, 3)]
		if IsValidEntity(sphere) then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = sphere:entindex(),
				AbilityIndex = castAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
		end
	end
end

function moloth_die(event)
	local caster = event.caster
	EmitSoundOn("Redfall.Moloth.Death", caster)
	for i = 1, #Redfall.Castle.BossSphereTable, 1 do
		CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", Redfall.Castle.BossSphereTable[i], 2)
		Redfall.Castle.BossSphereTable[i]:RemoveModifierByName("modifier_moloth_sphere_base_ai")
		Timers:CreateTimer(0.06, function()
			UTIL_Remove(Redfall.Castle.BossSphereTable[i])
		end)
	end
	Timers:CreateTimer(1.5, function()
		Redfall.Castle.archivistBoss:RemoveModifierByName("modifier_archivist_in_combat")
		CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/shield_shatter.vpcf", Redfall.Castle.archivistBoss, 3)
		local archivistAbility = Redfall.Castle.archivistBoss:FindAbilityByName("redfall_the_archivist_passive")
		archivistAbility:ApplyDataDrivenModifier(Redfall.Castle.archivistBoss, Redfall.Castle.archivistBoss, "modifier_archivist_finish_him", {})
		EmitSoundOn("Redfall.ArchivistPreDeathVO", Redfall.Castle.archivistBoss)
		ScreenShake(Redfall.Castle.archivistBoss:GetAbsOrigin(), 2, 2, 1.5, 9000, 0, true)
		EmitSoundOnLocationWithCaster(Redfall.Castle.archivistBoss:GetAbsOrigin(), "Redfall.Moloth.VulnerableMagic", Events.GameMaster)
	end)
end

function archivist_death(event)
	local caster = event.caster
	Redfall:ActivateBossStatue(Vector(-1600, 4066, 315 + Redfall.ZFLOAT))
	EmitSoundOn("Redfall.ArchivistMainDeathVO", caster)
	if GameState:GetDifficultyFactor() >= 3 then
		Glyphs:RollArchivistT5Glyph(caster:GetAbsOrigin())
	end
end

function lock_on_end(event)
	FindClearSpaceForUnit(event.target, event.target:GetAbsOrigin(), false)
end

function CastleTileTrigger1(trigger)
	local hero = trigger.activator
	local tileIndex = 1
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger2(trigger)
	local hero = trigger.activator
	local tileIndex = 2
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger3(trigger)
	local hero = trigger.activator
	local tileIndex = 3
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger4(trigger)
	local hero = trigger.activator
	local tileIndex = 4
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger5(trigger)
	local hero = trigger.activator
	local tileIndex = 5
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger6(trigger)
	local hero = trigger.activator
	local tileIndex = 6
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger7(trigger)
	local hero = trigger.activator
	local tileIndex = 7
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger8(trigger)
	local hero = trigger.activator
	local tileIndex = 8
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger9(trigger)
	local hero = trigger.activator
	local tileIndex = 9
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger10(trigger)
	local hero = trigger.activator
	local tileIndex = 10
	castle_tile_hit(tileIndex)
end

function CastleTileTrigger11(trigger)
	local hero = trigger.activator
	local tileIndex = 11
	castle_tile_hit(tileIndex)
end

function castle_tile_hit(tileIndex)
	--DeepPrintTable(Redfall.Castle.TileLocationTable)
	for i = 1, #Redfall.Castle.TileLocationTable, 1 do
		if Redfall.Castle.TileLocationTable[i] == tileIndex then
			if Redfall.Castle.TileLocationTable[i] == 0 then
			else
				Redfall.Castle.TileLocationTable[i] = 0
				Redfall.Castle.EntranceTileTable[i]:SetRenderColor(133, 167, 194)
				EmitSoundOnLocationWithCaster(Redfall.Castle.EntranceTileTable[i]:GetAbsOrigin(), "Redfall.CastleTile.Activate", Events.GameMaster)
			end
		end
	end
	if Redfall.CastleSwitch2dropped then
	else
		if Redfall.Castle.TileLocationTable[1] == 0 and Redfall.Castle.TileLocationTable[2] == 0 then
			Redfall.CastleSwitch2dropped = true
			Redfall:DropCastleSwtich(Redfall.Castle.Switch2, 0)
			Timers:CreateTimer(1.8, function()
				Redfall.CastleSwitch2Active = true
			end)
		end
	end
end

function CastleSwitch1TriggerA(event)
	if Redfall.CastleStart and Redfall.CastleSwitch2Active then
		if Redfall.CastleSwitch2Pressed then
		else
			Redfall.CastleSwitch2Pressed = true
			Redfall:ActivateSwitchGeneric(Vector(4740, 9195, 215 + Redfall.ZFLOAT), "CastleSwitch1a", true, 0.165)
			local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(3819, 9003, 510 + Redfall.ZFLOAT), 2000)
			Redfall:Walls(false, walls, true, 3.51)
			Redfall:InitCastleNextFirstRoom()
			Timers:CreateTimer(5, function()
				local blockers = Entities:FindAllByNameWithin("CastleWallBlockerEntrance", Vector(3840, 9024, 128 + Redfall.ZFLOAT), 2000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
		end
	end
end

function GardenLordTrigger(trigger)
	if not Redfall.Castle.GardenOverlordStart then
		Redfall.Castle.GardenOverlordStart = true

		local mask = Entities:FindByNameNearest("GardenOverlordHead", Vector(1321, 9041, -209 + Redfall.ZFLOAT), 1000)
		EmitSoundOnLocationWithCaster(mask:GetAbsOrigin(), "Redfall.GardenOverlordStatue.StartSound", Events.GameMaster)
		for i = 1, 80, 1 do
			Timers:CreateTimer(i * 0.03, function()
				mask:SetRenderColor(50 + i * 2, 50 + i * 2, 50 + i * 2)
			end)
		end
		local statue = Entities:FindByNameNearest("GardenOverlordBody", Vector(1245, 9041, 263 + Redfall.ZFLOAT), 1500)
		local totalStatue = {mask, statue}
		Timers:CreateTimer(2.2, function()
			for i = 1, #totalStatue, 1 do
				for j = 1, 50, 1 do
					Timers:CreateTimer(j * 0.03, function()
						local piece = totalStatue[i]
						local moveVector = Vector(20, 20, 0)
						if j % 2 == 0 then
							moveVector = Vector(-20, -20, 0)
						end
						if j % 15 == 0 then
							EmitSoundOnLocationWithCaster(Vector(1245, 9041, 263 + Redfall.ZFLOAT), "Redfall.Shaking", Events.GameMaster)
						end
						--print("MOVE PIECE")
						totalStatue[i]:SetAbsOrigin(totalStatue[i]:GetAbsOrigin() + moveVector)
					end)
				end
			end
		end)
		Timers:CreateTimer(3.8, function()
			local stone = Redfall:SpawnGardenOverlord(totalStatue[2]:GetAbsOrigin(), Vector(1, 0))
			Redfall.Castle.GardenOverlord = stone
			AddFOWViewer(DOTA_TEAM_GOODGUYS, stone:GetAbsOrigin(), 400, 30, false)
			local ability = stone:FindAbilityByName("redfall_garden_overlord_passive")
			ability:ApplyDataDrivenModifier(stone, stone, "modifier_garden_overlord_immune", {})
			local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_barracks001_melee_destroy.vpcf", PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
			ParticleManager:SetParticleControl(pfx, 0, totalStatue[2]:GetAbsOrigin())
			EmitSoundOnLocationWithCaster(totalStatue[2]:GetAbsOrigin(), "Redfall.RockCrash", Redfall.RedfallMaster)
			EmitSoundOn("Redfall.GardenOverlordVO1", stone)
			UTIL_Remove(totalStatue[1])
			UTIL_Remove(totalStatue[2])
			Timers:CreateTimer(0.1, function()
				StartAnimation(stone, {duration = 1.5, activity = ACT_DOTA_SPAWN, rate = 1.0})
				Timers:CreateTimer(1.4, function()
					stone.jumpEnd = "hermit"
					StartAnimation(stone, {duration = 1.5, activity = ACT_DOTA_SPAWN, rate = 1.0})
					WallPhysics:Jump(stone, Vector(1, 0), 30, 14, 19, 1)
					Timers:CreateTimer(2.8, function()
						ParticleManager:DestroyParticle(pfx, false)
						EmitSoundOn("Redfall.GardenOverlordVO2", stone)
						StartAnimation(stone, {duration = 2.0, activity = ACT_DOTA_TELEPORT, rate = 1.2})
					end)
				end)
			end)
			Timers:CreateTimer(5.4, function()
				AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(2611, 9024, 100 + Redfall.ZFLOAT), 1200, 120, false)
				local trees = Entities:FindAllByNameWithin("CastleGardenTree", Vector(2611, 9024, 100 + Redfall.ZFLOAT), 4000)

				for i = 1, #trees, 1 do
					local delay = 4.6
					if GameState:GetDifficultyFactor() == 2 then
						delay = 4.0
					elseif GameState:GetDifficultyFactor() == 3 then
						delay = 3.4
					end
					Timers:CreateTimer((i - 1) * delay, function()
						local moveVector = ((trees[i]:GetAbsOrigin() - stone:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
						stone:MoveToPosition(stone:GetAbsOrigin() + moveVector * 3)
						StartAnimation(stone, {duration = 1.8, activity = ACT_DOTA_CAST_ABILITY_5, rate = 1.0})
						EmitSoundOnLocationWithCaster(trees[i]:GetAbsOrigin(), "Redfall.CastleOverlord.SummonTree", Events.GameMaster)
						EmitSoundOn("Redfall.CastleOverlord.SummonVO", stone)
						Timers:CreateTimer(0.5, function()
							local pfx2 = ParticleManager:CreateParticle("particles/world_destruction_fx/tree_pine_02_destruction.vpcf", PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
							ParticleManager:SetParticleControl(pfx2, 0, trees[i]:GetAbsOrigin())
							local treant = Redfall:SpawnSnarlRootTreant(trees[i]:GetAbsOrigin() + RandomVector(150), RandomVector(1))
							Dungeons:AggroUnit(treant)

							Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, treant, "modifier_castle_unit_generic", {})
							treant.code = 3
							UTIL_Remove(trees[i])
						end)
					end)
				end

			end)
		end)

	end
end

function garden_treant_death(event)
	if not Redfall.Castle.GardenSnarlrootKilled then
		Redfall.Castle.GardenSnarlrootKilled = 0
	end
	Redfall.Castle.GardenSnarlrootKilled = Redfall.Castle.GardenSnarlrootKilled + 1
	if Redfall.Castle.GardenSnarlrootKilled == 8 then
		Redfall.Castle.GardenOverlord:RemoveModifierByName("modifier_garden_overlord_immune")
		EmitSoundOn("Redfall.GardenOverlordVO1", Redfall.Castle.GardenOverlord)
	end
end

function garden_overlord_death(event)
	local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(1396, 7594, 510 + Redfall.ZFLOAT), 2000)
	Redfall:Walls(false, walls, true, 3.41)
	Redfall:SpawnFortuneRoom()
	Timers:CreateTimer(5, function()
		local blockers = Entities:FindAllByNameWithin("GardenBlocker1", Vector(1408, 7616, 128 + Redfall.ZFLOAT), 2400)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)
end

function fire_turtle_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.state then
		caster.state = 0
	end
	if caster.state == 0 then
		if not caster:HasModifier("modifier_fire_turtle_gearing_for_explosion") then
			local targetPosition = Vector(1557 + RandomInt(1, 1550), 9664 + RandomInt(1, 500))
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for i = 1, #enemies, 1 do
					if (WallPhysics:IsWithinRegionA(enemies[i]:GetAbsOrigin(), Vector(1557, 9664), Vector(3100, 10164))) then
						targetPosition = enemies[i]:GetAbsOrigin()
					end
				end
			end
			caster:MoveToPosition(targetPosition)
		end
	elseif caster.state == 1 then
		if not caster:HasModifier("modifier_fire_turtle_gearing_for_explosion") then
			local targetPosition = Vector(1557 + RandomInt(1, 1550), 9664 + RandomInt(1, 500))
			caster:MoveToPosition(targetPosition)
		end
	end
end

function fire_turtle_attacked(event)
	local caster = event.caster
	local ability = event.ability
	if not event.attacker:IsHero() then
		return false
	end
	if caster:HasModifier("modifier_fire_turtle_gearing_for_explosion") then
		return false
	end
	if not caster:HasModifier("modifier_fire_turtle_gearing_for_explosion") then
		StartAnimation(caster, {duration = 4, activity = ACT_DOTA_IDLE_RARE, rate = 1.3})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_turtle_gearing_for_explosion", {duration = 3.5})
		EmitSoundOn("Redfall.TurtleHitVO", caster)
	end
	ability.interval = 0
	ability.liftVelocity = 0.2
	ability.falling = false

	if caster:GetAbsOrigin().y > 10330 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster, 3)
		FindClearSpaceForUnit(caster, Vector(2240, 9856), false)
		Timers:CreateTimer(0.1, function()
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster, 3)
		end)
	end
	if caster:GetAbsOrigin().x < 1031 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster, 3)
		FindClearSpaceForUnit(caster, Vector(2240, 9856), false)
		Timers:CreateTimer(0.1, function()
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster, 3)
		end)
	end
end

function fire_turtle_gearing_up_think(event)
	local caster = event.caster
	local ability = event.ability

	ability.interval = ability.interval + 1
	if ability.falling then
		ability.liftVelocity = ability.liftVelocity - 0.2
	else
		caster:SetRenderColor(255, 255 - ability.interval * 4, 255 - ability.interval * 4)
		ability.liftVelocity = ability.liftVelocity + 0.1
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, ability.liftVelocity))
	if ability.interval == 70 then
		caster:SetRenderColor(255, 255, 255)
		ability.liftVelocity = -5
		ability.falling = true
		flareParticle(caster:GetAbsOrigin())
		EmitSoundOn("Redfall.Bombadier.BombExplose", caster)
		local rocks = Entities:FindAllByNameWithin("CastleGardenRocks", caster:GetAbsOrigin(), 480)
		if #rocks > 0 then
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.RockCrash", Redfall.RedfallMaster)
			for i = 1, #rocks, 1 do
				local position = rocks[i]:GetAbsOrigin()
				local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_barracks001_melee_destroy.vpcf", PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
				ParticleManager:SetParticleControl(pfx, 0, position)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				local hasRedGolem = false
				local golemLuck = RandomInt(1, Redfall.Castle.RocksUp)
				if golemLuck <= (3 - Redfall.Castle.RockGolemsFound) then
					hasRedGolem = true
					Redfall.Castle.RockGolemsFound = Redfall.Castle.RockGolemsFound + 1
				end
				for i = 1, 3 + GameState:GetDifficultyFactor(), 1 do
					local golem = Redfall:SpawnMiniGolem(position, RandomVector(1))
					if hasRedGolem then
						if i == 1 then
							golem:SetRenderColor(200, 40, 40)
							Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, golem, "modifier_castle_unit_generic", {})
							golem.code = 4
						end
					end
				end
				local rockBlocker = Entities:FindByNameNearest("CastleRockBlocker", rocks[i]:GetAbsOrigin(), 500)
				UTIL_Remove(rocks[i])
				if rockBlocker then
					UTIL_Remove(rockBlocker)
				end
				Redfall.Castle.RocksUp = Redfall.Castle.RocksUp - 1
			end
		end
	end
	if ability.interval > 30 then
		local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
		if caster:GetAbsOrigin().z - groundHeight < 20 then
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end
	end
end

function rock_mini_golem_death(event)

	if Redfall.Castle.StalagmitesExploded == 0 then
		local stalagmite = Entities:FindByNameNearest("CastleGardenStalag1", Vector(1030, 9664, 130 + Redfall.ZFLOAT), 900)
		destroy_stalagmite(stalagmite)
	elseif Redfall.Castle.StalagmitesExploded == 1 then
		local stalagmite = Entities:FindByNameNearest("CastleGardenStalag2", Vector(1030, 9920, 130 + Redfall.ZFLOAT), 900)
		destroy_stalagmite(stalagmite)
	elseif Redfall.Castle.StalagmitesExploded == 2 then
		local stalagmite = Entities:FindByNameNearest("CastleGardenStalag3", Vector(1030, 10176, 130 + Redfall.ZFLOAT), 900)
		destroy_stalagmite(stalagmite)
		local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(914, 10087, 450 + Redfall.ZFLOAT), 1600)
		Redfall:Walls(false, walls, true, 3.41)
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleGardenBlocker", Vector(895, 10048, 128), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
		Redfall.Castle.FireTurtle.state = 1
		Redfall:WaterPlatformRoom()
	end
	Redfall.Castle.StalagmitesExploded = Redfall.Castle.StalagmitesExploded + 1
end

function destroy_stalagmite(stalagmite)
	Redfall:SpawnBigGolem(stalagmite:GetAbsOrigin(), Vector(1, 0))
	EmitSoundOnLocationWithCaster(stalagmite:GetAbsOrigin(), "Redfall.RockCrash", Redfall.RedfallMaster)
	local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_barracks001_melee_destroy.vpcf", PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
	ParticleManager:SetParticleControl(pfx, 0, stalagmite:GetAbsOrigin())
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	UTIL_Remove(stalagmite)
end

function crimson_samurai_think(event)
	local caster = event.caster
	local ability = event.ability
	local castAbility = caster:FindAbilityByName("custom_meteor2")
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 440, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
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

function CastleWaterSwitch1()
	if not Redfall.Castle.WaterPuzzleClear then
		Redfall:CastleWaterRoomSwitch(Redfall.Castle.SwitchTable[1])
	end
end

function CastleWaterSwitch2()
	if not Redfall.Castle.WaterPuzzleClear then
		Redfall:CastleWaterRoomSwitch(Redfall.Castle.SwitchTable[2])
	end
end

function CastleWaterSwitch3()
	if not Redfall.Castle.WaterPuzzleClear then
		Redfall:CastleWaterRoomSwitch(Redfall.Castle.SwitchTable[3])
	end
end

function CastleWaterSwitch4()
	if not Redfall.Castle.WaterPuzzleClear then
		Redfall:CastleWaterRoomSwitch(Redfall.Castle.SwitchTable[4])
	end
end

function CastleWaterSwitch5()
	if not Redfall.Castle.WaterPuzzleClear then
		Redfall:CastleWaterRoomSwitch(Redfall.Castle.SwitchTable[5])
	end
end

function CastleWaterSwitch6()
	if not Redfall.Castle.WaterPuzzleClear then
		Redfall:CastleWaterRoomSwitch(Redfall.Castle.SwitchTable[6])
	end
end

function conquest_switch_attack(event)
	local caster = event.caster
	local ability = event.ability
	if caster.type == "reaver" then
		if not caster.attackCount then
			caster.attackCount = 0
			caster.startingAngle = 0
		end
		caster.attackCount = caster.attackCount + 1
		caster:SetRenderColor(255 - (caster.attackCount * 20), 255 - (caster.attackCount * 20), 255)
		for i = 1, 15, 1 do
			Timers:CreateTimer(i * 0.03, function()
				caster.startingAngle = caster.startingAngle + 1
				caster:SetAngles(0, 270 - caster.startingAngle * 1.2, 0)
				caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 0.9))
			end)
		end

		if caster.attackCount == 5 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_attackable_unit_no_more_attacks", {})
			Timers:CreateTimer(0.35, function()
				EmitSoundOn("Arena.WaterTemple.SwitchEnd", caster)
			end)
			for j = 1, 40, 1 do
				Timers:CreateTimer(j * 0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 2))
				end)
			end
			Timers:CreateTimer(1.2, function()
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.RockCrash", Events.GameMaster)
			end)
			Timers:CreateTimer(120, function()
				UTIL_Remove(caster)
			end)
			local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(-1966, 8664, 496 + Redfall.ZFLOAT), 2000)
			Redfall:Walls(false, walls, true, 3.88)
			Redfall:SpawnTreasureRoom()
			Timers:CreateTimer(5, function()
				local blockers = Entities:FindAllByNameWithin("CastleBlocker3", Vector(-1856, 8655, 128 + Redfall.ZFLOAT), 3000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
		end
	end
end

function loki_attack_land(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_cast_ring_burst.vpcf", caster, 2)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_loki_movespeed", {duration = 7})
	local newStacks = caster:GetModifierStackCount("modifier_loki_movespeed", caster) + 1
	caster:SetModifierStackCount("modifier_loki_movespeed", caster, newStacks)
	local heal = caster:GetMaxHealth() * 0.02
	caster:Heal(heal, caster)
	PopupHealing(caster, heal)
end

function loki_the_mad_die(event)
	local caster = event.caster
	EmitSoundOn("Redfall.LokiTheMad.Death", caster)
	local luck = RandomInt(1, 3)
	if luck == 1 then
		RPCItems:VermillionDreamRobes(caster:GetAbsOrigin())
	end
end

function CrystalMazeTrigger(trigger)
	if not Redfall.CastleCrystalMazeTrigger then
		Redfall.CastleCrystalMazeTrigger = true
		Redfall:ActivateSwitchGeneric(Vector(-2870, 13315, 387 + Redfall.ZFLOAT), "MazeRoomSwitch1", true, 0.168)

		Redfall.crystalMazePFX = {}
		local spawnPositionTable = {Vector(-3398, 12810), Vector(-2880, 12810)}
		Timers:CreateTimer(2, function()
			for i = 1, #spawnPositionTable, 1 do
				local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/spawn_portal_counter.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
				ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i] + Vector(0, 0, 541 + Redfall.ZFLOAT))
				table.insert(Redfall.crystalMazePFX, pfx)
				EmitSoundOnLocationWithCaster(spawnPositionTable[i], "Redfall.CaveUnitPortals", Redfall.RedfallMaster)
			end
		end)
		Timers:CreateTimer(4, function()
			for i = 1, #spawnPositionTable, 1 do
				local delay = 0.8
				if GameState:GetDifficultyFactor() == 2 then
					delay = 0.6
				elseif GameState:GetDifficultyFactor() == 3 then
					delay = 0.4
				end
				Redfall:SpawnCrystalRoomWaveUnit("redfall_dragonkin", spawnPositionTable[i], 15, 33, delay, true)
			end
		end)
	end
end

function crystal_wave_unit_death(event)
	if not Redfall.Castle.CrystalWaveKills then
		Redfall.Castle.CrystalWaveKills = 0
	end
	Redfall.Castle.CrystalWaveKills = Redfall.Castle.CrystalWaveKills + 1
	local spawnPositionTable = {Vector(-3398, 12810), Vector(-2880, 12810)}
	if Redfall.Castle.CrystalWaveKills == 28 then
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			Redfall:SpawnCrystalRoomWaveUnit("redfall_crimsyth_hell_bandit", spawnPositionTable[i], 10, 33, delay, true)
		end
	elseif Redfall.Castle.CrystalWaveKills == 48 then
		for i = 1, #spawnPositionTable, 1 do
			local delay = 0.8
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.6
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.4
			end
			Redfall:SpawnCrystalRoomWaveUnit("redfall_crimsyth_gunman", spawnPositionTable[i], 15, 33, delay, true)
		end
	elseif Redfall.Castle.CrystalWaveKills == 78 then
		for i = 1, #spawnPositionTable, 1 do
			local delay = 0.8
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.6
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.4
			end
			Redfall:SpawnCrystalRoomWaveUnit("redfall_crystal_shifter", spawnPositionTable[i], 15, 33, delay, true)
		end
	elseif Redfall.Castle.CrystalWaveKills == 108 then
		for i = 1, #spawnPositionTable, 1 do
			local delay = 0.8
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.6
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.4
			end
			Redfall:SpawnCrystalRoomWaveUnit("redfall_castle_archer", spawnPositionTable[i], 10, 33, delay, true)
		end
	elseif Redfall.Castle.CrystalWaveKills == 128 then
		for i = 1, #spawnPositionTable, 1 do
			local delay = 0.8
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.6
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.4
			end
			Redfall:SpawnCrystalRoomWaveUnit("redfall_castle_warflayer", spawnPositionTable[i], 5, 33, delay, true)
		end
	elseif Redfall.Castle.CrystalWaveKills == 138 then
		local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(-4295, 15593, 541 + Redfall.ZFLOAT), 1700)
		Redfall:Walls(false, walls, true, 3.51)
		Redfall:CastleStartLavaMazeRoom()
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleBlocker", Vector(-4288, 15616, 384 + Redfall.ZFLOAT), 2000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
		for i = 1, #Redfall.crystalMazePFX, 1 do
			ParticleManager:DestroyParticle(Redfall.crystalMazePFX[i], false)
		end
		Redfall.crystalMazePFX = nil
	end
end

function castle_whomp_think(event)
	local caster = event.caster
	if Redfall.Castle.LavaPoles[1] and Redfall.Castle.LavaPoles[2] and Redfall.Castle.LavaPoles[3] then
		local liftSpeed = 5 + GameState:GetDifficultyFactor()
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, liftSpeed))
		if caster:GetAbsOrigin().z > 700 + Redfall.ZFLOAT then
			caster:RemoveModifierByName("modifier_thwompHead")
			Timers:CreateTimer(0.05, function()
				UTIL_Remove(caster)
			end)
			return false
		end
	else
		if caster.rising == 0 then
			local liftSpeed = 5 + GameState:GetDifficultyFactor()
			caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, liftSpeed))
			if caster:GetAbsOrigin().z > 700 + Redfall.ZFLOAT then
				caster.rising = 1
			end
		elseif caster.rising == 1 then
			caster.interval = caster.interval + 1
			if caster.interval == 22 then
				caster.interval = 0
				caster.rising = 2
			end
		elseif caster.rising == 2 then
			caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 43))
			if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) then
				ScreenShake(caster:GetAbsOrigin(), 2, 2, 1.5, 9000, 0, true)
				EmitSoundOn("Redfall.ThwompStomp", caster)
				local particleName = "particles/redfall/red_smash.vpcf"
				local position = caster:GetAbsOrigin() + caster.offset
				local particleVector = position

				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, particleVector)
				ParticleManager:SetParticleControl(pfx, 1, particleVector)
				ParticleManager:SetParticleControl(pfx, 2, particleVector)
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 170, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						local mult = 0.35 + GameState:GetDifficultyFactor() * 0.15
						local damage = enemy:GetMaxHealth() * mult
						ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
						enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.5})
					end
				end
				caster.rising = 3
			end
		elseif caster.rising == 3 then
			caster.interval = caster.interval + 1
			if caster.interval == 42 then
				caster.interval = 0
				caster.rising = 0
			end
		end
	end
	caster.thwompHead:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, caster.headOffset))
end

function crimsyth_ball_prop_attacked(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	if not attacker:IsHero() then
		return false
	end
	local hitDirectionVector = ((caster:GetAbsOrigin() - attacker:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	caster.fv = hitDirectionVector
	caster.forwardVelocity = math.min(caster.moveVelocity + 20, 40)
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), attacker:GetAbsOrigin())
	caster.liftVelocity = math.min(caster.liftVelocity + distance / 12, 14)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ball_switch_moving", {})
	caster.noDust = false
end

function ball_prop_think(event)
	local caster = event.caster
	if caster:GetAbsOrigin().z > 1200 + Redfall.ZFLOAT then
		caster:SetAbsOrigin(GetGroundPosition(caster.startPosition, caster))
		caster:RemoveModifierByName("modifier_ball_switch_moving")
	end
	if (WallPhysics:IsWithinRegionA(caster:GetAbsOrigin(), Vector(-7040, 9792), Vector(-2424, 13796))) then
	else
		caster:SetAbsOrigin(GetGroundPosition(caster.startPosition, caster))
		caster:RemoveModifierByName("modifier_ball_switch_moving")
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 340, 5, false)
end

function ball_switch_moving_think(event)
	local ball = event.target
	if not IsValidEntity(ball) then
		return false
	end
	local fv = ball.fv
	-- barrel:SetForwardVector(WallPhysics:rotateVector(fv,math.pi/2))
	local currentRoll = ball.roll
	local newRoll = ball.roll + ball.forwardVelocity / 3
	if newRoll > 180 then
		newRoll = -180
	end
	ball.roll = newRoll
	ball.pitch = ball.pitch + ball.liftVelocity / 3
	if ball.pitch > 180 then
		ball.pitch = -180
	end
	if ball.forwardVelocity <= 0 then
		if ball:GetAbsOrigin().z - GetGroundHeight(ball:GetAbsOrigin(), ball) < 40 then
			ball:RemoveModifierByName("modifier_ball_switch_moving")
		end
	end
	ball:SetAngles(newRoll, ball.pitch, 0)

	local velocityChange = -0.3
	local newPosition = ball:GetAbsOrigin() + ball.fv * ball.forwardVelocity + Vector(0, 0, ball.liftVelocity)
	local obstruction = WallPhysics:FindNearestObstruction(newPosition + ball.fv)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition + ball.fv, ball)
	ball.liftVelocity = ball.liftVelocity - 0.8
	if ball.liftVelocity < 0 then
		if ball:GetAbsOrigin().z - GetGroundHeight(ball:GetAbsOrigin(), ball) < 40 then
			if ball.liftVelocity < -10 then
				ball.liftVelocity = ball.liftVelocity /- 1.5
			else
				ball.liftVelocity = 0
				ball.noDust = true
				if ball.forwardVelocity < 1 then
					ball:RemoveModifierByName("modifier_ball_switch_moving")
				end
			end
			if not ball.noDust then
				newPosition = GetGroundPosition(ball:GetAbsOrigin(), ball)
				EmitSoundOn("Redfall.BallSwitch.Bounce", ball)
				local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, ball)
				ParticleManager:SetParticleControl(pfx, 0, ball:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end
		end
	end
	if blockUnit then
		ball.forwardVelocity = math.max(ball.forwardVelocity / 1.6, 0)
		-- barrel.fv = WallPhysics:rotateVector(barrel.fv*-1, 2*math.pi*RandomInt(-5,5)/180)
		-- local normal = WallPhysics:rotateVector((obstruction:GetAbsOrigin() - barrel:GetAbsOrigin()):Normalized(), math.pi/2)
		local normal = ((obstruction:GetAbsOrigin() - ball:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		normal = WallPhysics:rotateVector(normal, math.pi / 2)
		local reflectionVector = 2 * (normal:Dot(ball.fv, normal)) * normal - ball.fv
		ball.fv = reflectionVector:Normalized()
		newPosition = ball:GetAbsOrigin() + (ball.fv * ball.forwardVelocity * 2)
		ball:SetAbsOrigin(newPosition)
		EmitSoundOn("Redfall.BallSwitch.Bounce", ball)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, ball)
		ParticleManager:SetParticleControl(pfx, 0, ball:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	else
		local slopeEffect = GetGroundHeight(ball:GetAbsOrigin(), ball) - GetGroundHeight(newPosition, ball)
		velocityChange = velocityChange + slopeEffect / 10
		ball:SetAbsOrigin(newPosition)
	end
	ball.forwardVelocity = math.max(ball.forwardVelocity + velocityChange, 0)
	ball.interval = ball.interval + 1
	if ball.interval % 3 == 0 then

		for i = 1, #Redfall.Castle.BallSwitchGoalsTable, 1 do
			if Redfall.Castle.BallSwitchGoalsTable[i] then
				local goalDistance = WallPhysics:GetDistance(Redfall.Castle.BallSwitchGoalsTable[i], ball:GetAbsOrigin())
				--print("GOAL DISTANCE:")
				--print(goalDistance)
				if goalDistance < 90 then
					ball:SetAbsOrigin(Redfall.Castle.BallSwitchGoalsTable[i])
					Redfall.Castle.BallSwitchGoalsTable[i] = false
					ball:RemoveModifierByName("modifier_ball_switch_moving")
					ball:FindAbilityByName("redfall_ball_prop"):ApplyDataDrivenModifier(ball, ball, "modifier_water_shield_no_more_attack", {})
					Timers:CreateTimer(6, function()
						UTIL_Remove(ball)
					end)
					checkBallSwitchGoal()
					local ballSwitchGoalProps = Entities:FindAllByNameWithin("BallSwitchGoal"..i, ball:GetAbsOrigin(), 2000)
					table.insert(ballSwitchGoalProps, ball)
					EmitSoundOnLocationWithCaster(ball:GetAbsOrigin(), "Redfall.BallSwitch.Goal", ball)
					Redfall:Walls(false, ballSwitchGoalProps, true, 1.18)
					Timers:CreateTimer(2, function()
						local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
						ParticleManager:SetParticleControl(pfx, 0, ballSwitchGoalProps[1]:GetAbsOrigin())
						ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
						Timers:CreateTimer(2, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end)
					-- for j = 1, 100, 1 do
					-- Timers:CreateTimer(j*0.03, function()
					-- for k = 1, #ballSwitchGoalProps, 1 do
					-- ballSwitchGoalProps[k]:SetAbsOrigin(ballSwitchGoalProps[k]:GetAbsOrigin()-Vector(0,0,8))
					-- end
					-- end)
					-- end
				end
			end
		end
	end
end

function checkBallSwitchGoal()
	local allFalse = true
	for i = 1, #Redfall.Castle.BallSwitchGoalsTable, 1 do
		if Redfall.Castle.BallSwitchGoalsTable[i] then
			allFalse = false
		end
	end
	if allFalse then
		local walls = Entities:FindAllByNameWithin("CastleWallZ", Vector(-3054, 9829, 498 + Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 3.51)
		Redfall:CastleInitiateAfterBallRoom()
		Redfall.Castle.SwampMazeActive = true
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleBlocker", Vector(-2996, 9792, 128 + Redfall.ZFLOAT), 2400)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)

		local walls = Entities:FindAllByNameWithin("CastleWall2", Vector(-2454, 10171, 515 + Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 3.51)
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleBlocker2", Vector(-2474, 10255, 128 + Redfall.ZFLOAT), 2400)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end
end

function crimsyth_mage_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		EmitSoundOn("RPCItem.RedrockFootwear", caster)
		local position = caster:GetAbsOrigin()
		local particleName = "particles/units/heroes/hero_faceless_void/redrock_timedialate.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		local radius = 500
		ParticleManager:SetParticleControl(particle, 0, position)
		ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle, false)
		end)

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_crimsyth_mage_slow", {duration = 2.5})
				ApplyDamage({victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			end
		end
	end
end

function CastleBallSwitchRoomSpawnTrigger()
	for i = 1, 4, 1 do
		for j = 1, 4, 1 do
			Timers:CreateTimer(j * 0.3, function()
				Redfall:SpawnCrimsonShadowDancer(Vector(-3328 + ((i - 1) * 200), 10752 + ((j - 1) * 200)), Vector(0, -1))
			end)
		end
	end
end

function SwampMazeTrigger()
	if not Redfall.Castle.SwampMazeTrigger and Redfall.Castle.SwampMazeActive == true then
		Redfall.Castle.WaterArchersDead = 0
		Redfall.Castle.SwampMazeTrigger = true
		Redfall:ActivateSwitchGeneric(Vector(-6170, 9487, 470 + Redfall.ZFLOAT), "SwampRoomSwitch", true, 0.165)
		local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(-6464, 7439, 551 + Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 3.51)
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleBlocker", Vector(-6464, 7360, 128 + Redfall.ZFLOAT), 2000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
		local positionTable = {Vector(-8105, 8241), Vector(-7484, 8241), Vector(-6909, 8241), Vector(-8124, 6717), Vector(-7484, 6717), Vector(-6909, 6717)}
		for i = 1, #positionTable, 1 do
			local archer = Redfall:SpawnShipyardPirateArcher(positionTable[i], Vector(1, 0))
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, archer, "modifier_castle_unit_generic", {})
			archer.code = 8
		end
	end
end

function archer_water_room_die()
	if not Redfall.Castle.WaterArchersDead then
		Redfall.Castle.WaterArchersDead = 0
	end
	Redfall.Castle.WaterArchersDead = Redfall.Castle.WaterArchersDead + 1
	if Redfall.Castle.WaterArchersDead == 6 then
		Redfall.Castle.GhostPortalActive = true
		EmitGlobalSound("ui.set_applied")
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-7386, 7494, 138 + Redfall.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		Redfall:PerditionRoom()
	end
end

function GhostTeleport(trigger)
	local hero = trigger.activator
	if Redfall.Castle.GhostPortalActive then
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(-6912, 4864)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function perdition_torch_think(event)
	local caster = event.caster
	caster:SetAbsOrigin(caster.basePos)
end

function perdition_torch_attacked(event)
	local torch = event.caster
	local ability = event.ability
	if not torch:HasModifier("modifier_torch_in_flame") then
		Redfall.Castle.TorchesLit = Redfall.Castle.TorchesLit + 1
		ability:ApplyDataDrivenModifier(torch, torch, "modifier_torch_in_flame", {duration = 20})
		torch.pfx = ParticleManager:CreateParticle("particles/dire_fx/fire_ambience.vpcf", PATTACH_CUSTOMORIGIN, torch)
		ParticleManager:SetParticleControl(torch.pfx, 0, torch:GetAbsOrigin() + Vector(0, 0, 198))
		torch.visionUnit = CreateUnitByName("npc_flying_dummy_vision", torch:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
		torch.visionUnit:SetDayTimeVisionRange(600)
		torch.visionUnit:SetNightTimeVisionRange(600)
		torch.visionUnit:FindAbilityByName("dummy_unit"):SetLevel(1)
	end
end

function torch_flame_end(event)
	local torch = event.caster
	ParticleManager:DestroyParticle(torch.pfx, false)
	Redfall.Castle.TorchesLit = Redfall.Castle.TorchesLit - 1
	UTIL_Remove(torch.visionUnit)
end

function ghost_of_perdition_think(event)
	local luck = RandomInt(1, 5)
	local ability = event.ability
	local caster = event.caster
	local casterOrigin = caster:GetAbsOrigin()
	if not caster:IsAlive() then
		return false
	end
	if luck == 1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, 740, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") and not caster:IsStunned() and not caster:IsRooted() then
			local sumVector = Vector(0, 0, 0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector / #enemies
			local forceDirection = ((casterOrigin - avgVector) * Vector(1, 1, 0)):Normalized()
			local distance = WallPhysics:GetDistance2d(casterOrigin, Vector(-6912, 4864))
			if distance > 900 then
				forceDirection = forceDirection *- 1
			elseif distance > 2250 then
				FindClearSpaceForUnit(caster, Vector(-6912, 4864), false)
			end
			EmitSoundOn("Redfall.GhostOfPerdition.Jump", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration = 0.66, activity = ACT_DOTA_CAST_TORNADO, rate = 1})
			for i = 1, 22, 1 do
				Timers:CreateTimer(i * 0.03, function()
					local newPosition = caster:GetAbsOrigin() + forceDirection * 20
					local obstruction = WallPhysics:FindNearestObstruction(newPosition * Vector(1, 1, 0))
					local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), caster)
					if not blockUnit then
						caster:SetAbsOrigin(newPosition)
					end

				end)
			end
			Timers:CreateTimer(0.66, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)
			return false
		end
	end
	local coldSnapAbility = caster:FindAbilityByName("perdition_cold_snap")
	if coldSnapAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = enemies[1]:entindex(),
				AbilityIndex = coldSnapAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return false
		end
	end
	local raiseAbility = caster:FindAbilityByName("perdition_raise_dead")
	if raiseAbility:IsFullyCastable() then
		if caster.summons then
			if caster.summons > 0 then
				return false
			end
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = raiseAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return false
		end
	end
	local bkbAbility = caster:FindAbilityByName("creature_black_king_bar")
	if bkbAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = bkbAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return false
		end
	end
end

function perdition_raise_dead(event)
	local caster = event.caster
	local ability = event.ability
	local numSummons = event.skeleton_summons
	EmitSoundOn("Redfall.GhostOfPerdition.RaiseDead", caster)
	caster.summons = numSummons
	for i = 1, numSummons, 1 do
		Timers:CreateTimer(i * 0.1, function()
			local skeleton = Redfall:SpawnShipyardPirateArcher(caster:GetAbsOrigin() + RandomVector(RandomInt(50, 240)), caster:GetForwardVector())
			ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_raise_dead_minion", {})
			Dungeons:AggroUnit(skeleton)
			CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", skeleton, 3)
		end)
	end
end

function perdition_skeleton_summon_die(event)
	local caster = event.caster
	caster.summons = caster.summons - 1
end

function perdition_die(event)
	local caster = event.caster
	Redfall:ActivateBossStatue(Vector(-1600, 2442, 315 + Redfall.ZFLOAT))
	EmitSoundOn("Redfall.GhostOfPerdition.Die", caster)
	Timers:CreateTimer(2, function()
		Redfall.Castle.PerditionDie = true
		EmitGlobalSound("ui.set_applied")
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-6008, 4390, -50 + Redfall.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
	end)
	local luck = RandomInt(1, 3)
	if luck == 1 then
		RPCItems:RollBloodstoneBoots(caster:GetAbsOrigin())
	end
end

function GhostTeleportOut(trigger)
	local hero = trigger.activator
	if Redfall.Castle.PerditionDie then
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(-6144, 7488)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function fortune_chest_attacked(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lock then
		return false
	end
	if Redfall.Castle.FortuneLock then
		return false
	end
	if not caster:HasModifier("modifier_chest_transforming") then
		Redfall.Castle.LastOpened = GameRules:GetGameTime()
		caster.interval = 0
		caster.opener = event.attacker
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chest_transforming", {})
		Redfall.Castle.FortuneLock = true
		Timers:CreateTimer(5, function()
			if GameRules:GetGameTime() > (Redfall.Castle.LastOpened + 4.5) then
				Redfall.Castle.FortuneLock = false
			end
		end)
	end
end

function chest_transforming_think(event)
	local caster = event.caster
	if caster.lock then
		return false
	end
	if caster.interval == 0 then
		local pfx1 = ParticleManager:CreateParticle("particles/units/unit_greevil/greevil_transformation_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx1, false)
		end)
		EmitSoundOn("Redfall.FortuneChest.Hit", caster)
		if caster.code >= 0 then
			Redfall.Castle.FortuneChestsOpened = Redfall.Castle.FortuneChestsOpened + 1
		end
	end
	caster.interval = caster.interval + 1
	if caster.code >= 0 then
		local sumDistance = math.abs(caster.i - Redfall.Castle.chestItarget) + math.abs(caster.j - Redfall.Castle.chestJtarget)
		if caster.index == Redfall.Castle.FortuneChestBoss then
			caster:SetRenderColor(123 + (caster.interval * 4), 239 - (caster.interval * 6), 210 - (caster.interval * 6))
		elseif sumDistance <= 2 then
			caster:SetRenderColor(123 - (caster.interval * 4), 239 - (caster.interval * 6), 210 + (caster.interval * 1))
		else
			caster:SetRenderColor(123 + (caster.interval * 4), 239, 210)
		end
	else
		caster:SetRenderColor(100 + (caster.interval * 4), 100, 100 + (caster.interval * 4))
	end
	if caster.interval == 30 then
		caster.lock = true
		Redfall.Castle.FortuneLock = false
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

		local particleName = "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf"
		local position = caster:GetAbsOrigin()
		local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx2, 0, position)
		ParticleManager:SetParticleControl(pfx2, 1, position)
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)

		EmitSoundOn("Redfall.FortuneChest.Open", caster)
		local code = caster.code
		local position = caster:GetAbsOrigin()
		if code == -1 then
			local luck = RandomInt(1, 3)
			if luck == 1 then
				RPCItems:RollCobaltSerenityRing(position)
			elseif luck == 2 then
				RPCItems:RollGarnetWarfareRing(position)
			elseif luck == 3 then
				RPCItems:RollEmeraldNullificationRing(position)
			end
			caster:RemoveModifierByName("modifier_chest_transforming")
			Timers:CreateTimer(0.05, function()
				UTIL_Remove(caster)
			end)
			return false
		end
		if Redfall.Castle.FortuneChestsOpened == 15 then
			if caster.index == Redfall.Castle.FortuneChestBoss then
			else
				RPCItems:RollBootsOfGreatFortune(position)
				caster:RemoveModifierByName("modifier_chest_transforming")
				Timers:CreateTimer(0.05, function()
					UTIL_Remove(caster)
				end)
				return false
			end
		end
		if caster.index == Redfall.Castle.FortuneChestBoss then
			Timers:CreateTimer(1.2, function()
				FortunaSequence()
			end)
			local orb = CreateUnitByName("selethas_boomerang", position, false, caster, nil, caster:GetTeamNumber())
			orb:SetOriginalModel("models/boss_sphere.vmdl")
			orb:SetModel("models/boss_sphere.vmdl")
			orb:AddAbility("dummy_unit"):SetLevel(1)
			for i = 1, 40, 1 do
				Timers:CreateTimer(i * 0.03, function()
					orb:SetAbsOrigin(orb:GetAbsOrigin() + Vector(0, 0, 5 + (i / 6)))
					if i == 40 then
						local particleName = "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf"
						local pfxF = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
						ParticleManager:SetParticleControl(pfxF, 0, orb:GetAbsOrigin())
						ParticleManager:SetParticleControl(pfxF, 1, orb:GetAbsOrigin())
						Timers:CreateTimer(3, function()
							ParticleManager:DestroyParticle(pfxF, false)
						end)
						EmitSoundOnLocationWithCaster(orb:GetAbsOrigin(), "Redfall.Farmlands.ChestDisappear", Events.GameMaster)
						UTIL_Remove(orb)
					end
				end)
			end
			for i = 1, #Redfall.Castle.FortuneChestTable, 1 do
				if IsValidEntity(Redfall.Castle.FortuneChestTable[i]) then
					local position = Redfall.Castle.FortuneChestTable[i]:GetAbsOrigin()
					local particleName = "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf"
					local position = caster:GetAbsOrigin()
					local pfxQ = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
					ParticleManager:SetParticleControl(pfxQ, 0, position)
					ParticleManager:SetParticleControl(pfxQ, 1, position)
					Timers:CreateTimer(3, function()
						ParticleManager:DestroyParticle(pfxQ, false)
					end)
					Redfall.Castle.FortuneChestTable[i]:RemoveModifierByName("modifier_chest_transforming")
					Timers:CreateTimer(0.05, function()
						UTIL_Remove(Redfall.Castle.FortuneChestTable[i])
					end)
				end
			end
			return false
		end
		if code == 0 then
			for i = 1, 3, 1 do
				local monkey = Redfall:SpawnFortuneSeeker(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 1 then
			for i = 1, 3, 1 do
				local monkey = Redfall:SpawnHawkSoldierElite(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 2 then
			for i = 1, 3, 1 do
				local monkey = Redfall:SpawnCrimsythGunmanElite(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 3 then
			for i = 1, 3, 1 do
				local monkey = Redfall:SpawnCastleWarflayer(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 4 then
			for i = 1, 3, 1 do
				local monkey = Redfall:SpawnCrimsythShadow(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 5 then
			for i = 1, 3, 1 do
				local monkey = Redfall:SpawnSoulScar(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 6 then
			for i = 1, 3, 1 do
				local monkey = Redfall:SpawnCrimsonSamurai(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 7 then
			for i = 1, 15, 1 do
				Timers:CreateTimer(i * 0.05, function()
					local monkey = Redfall:SpawnHawkSoldier(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
					Dungeons:AggroUnit(monkey)
				end)
			end
		elseif code == 8 then
			for i = 1, 12, 1 do
				Timers:CreateTimer(i * 0.05, function()
					local monkey = Redfall:SpawnCrimsonWarrior(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
					Dungeons:AggroUnit(monkey)
				end)
			end
		elseif code == 9 then
			for i = 1, 5, 1 do
				local monkey = Redfall:SpawnCrimsythKhanKnight(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 10 then
			Glyphs:DropArcaneCrystals(position, 1.4)
		elseif code == 11 then
			rollFortuneChestImmortal(position)
		elseif code == 12 then
			Glyphs:RollRandomGlyph(position)
		elseif code == 13 then
			RPCItems:RollGold(1000, position)
		elseif code == 14 then
			for i = 1, 3, 1 do
				local monkey = Redfall:SpawnAutumnMonster(position + RandomVector(RandomInt(20, 120)), Vector(-1, 0))
				Dungeons:AggroUnit(monkey)
			end
		elseif code == 15 then
			for i = 1, 4, 1 do
				local monkey = Redfall:SpawnRedfallShroom(position + RandomVector(RandomInt(20, 160)))
				Dungeons:AggroUnit(monkey)
				Events:AdjustDeathXP(monkey)
			end
		elseif code == 16 then
			local wozxak = Redfall:SpawnWozxak(position, Vector(-1, 0))
			Dungeons:AggroUnit(wozxak)
			Events:AdjustDeathXP(wozxak)
			Events:AdjustDeathXP(wozxak)
			wozxak:SetModelScale(2.4)
		elseif code == 17 then
			RPCItems:RollHandOfMidas(position)
		end
		caster:RemoveModifierByName("modifier_chest_transforming")
		Timers:CreateTimer(0.05, function()
			UTIL_Remove(caster)
		end)
	end
end

function rollFortuneChestImmortal(deathLocation)
	local rarity = "immortal"
	local luck = RandomInt(200, 500)
	if luck >= 200 and luck < 265 then
		RPCItems:RollHood(0, deathLocation, rarity, false, 0, nil, 0)
	elseif luck >= 265 and luck < 330 then
		RPCItems:RollHand(0, deathLocation, rarity, false, 0, nil, 0)
	elseif luck >= 330 and luck < 395 then
		RPCItems:RollFoot(0, deathLocation, rarity, false, 0, nil, 0)
	elseif luck >= 395 and luck < 460 then
		RPCItems:RollBody(0, deathLocation, rarity, false, 0, nil, 0)
	elseif luck <= 500 then
		RPCItems:RollAmulet(0, deathLocation, rarity, false, 0, nil, 0)
	end
end

function FortunaSequence()
	local totalStatue = Entities:FindAllByNameWithin("FortunisStatue", Vector(4043, 6464, 108 + Redfall.ZFLOAT), 1500)
	Timers:CreateTimer(1.2, function()
		for i = 1, #totalStatue, 1 do
			for j = 1, 50, 1 do
				Timers:CreateTimer(j * 0.03, function()
					local piece = totalStatue[i]
					local moveVector = Vector(20, 20, 0)
					if j % 2 == 0 then
						moveVector = Vector(-20, -20, 0)
					end
					if j % 15 == 0 then
						EmitSoundOnLocationWithCaster(Vector(4043, 6464, 108 + Redfall.ZFLOAT), "Redfall.FortunaSequence.Shaking", Events.GameMaster)
					end
					--print("MOVE PIECE")
					totalStatue[i]:SetAbsOrigin(totalStatue[i]:GetAbsOrigin() + moveVector)
				end)
			end
		end
	end)
	Timers:CreateTimer(2.8, function()
		EmitSoundOnLocationWithCaster(Vector(4043, 6464, 108 + Redfall.ZFLOAT), "Redfall.FortunaSequence.Start", Events.GameMaster)

		local stone = Redfall:SpawnEffigyOfFortunis(totalStatue[2]:GetAbsOrigin(), Vector(-1, 0))
		stone:SetAbsOrigin(Vector(4047, 6474, 100 + Redfall.ZFLOAT))
		local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_barracks001_melee_destroy.vpcf", PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx, 0, totalStatue[2]:GetAbsOrigin())
		UTIL_Remove(totalStatue[1])
		UTIL_Remove(totalStatue[2])
		Timers:CreateTimer(0.1, function()
			-- StartAnimation(stone, {duration=1.5, activity=ACT_DOTA_SPAWN, rate=1.0})
			WallPhysics:Jump(stone, Vector(-1, 0), 14, 24, 19, 0.8)

			Timers:CreateTimer(0.2, function()
				StartAnimation(stone, {duration = 1.5, activity = ACT_DOTA_TELEPORT_END, rate = 0.68})
				EmitSoundOn("Redfall.ForestGuideAppear", stone)
			end)
			Timers:CreateTimer(1.2, function()
				local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, stone)
				ParticleManager:SetParticleControl(pfx, 0, stone:GetAbsOrigin() + Vector(0, 0, 100))
				EmitSoundOn("Redfall.ForestSwitchLand", stone)
				Timers:CreateTimer(2.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end)

		end)
	end)
end

function fortunis_think(event)
	local stone = event.caster

	local enemies = FindUnitsInRadius(stone:GetTeamNumber(), stone:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local fv = ((enemies[1]:GetAbsOrigin() - stone:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		WallPhysics:JumpWithBlocking(stone, fv, 14, 24, 19, 0.8)

		Timers:CreateTimer(0.2, function()
			StartAnimation(stone, {duration = 1.5, activity = ACT_DOTA_TELEPORT_END, rate = 0.68})
			EmitSoundOn("Redfall.ForestGuideAppear", stone)
		end)
		Timers:CreateTimer(1.1, function()
			local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, stone)
			ParticleManager:SetParticleControl(pfx, 0, stone:GetAbsOrigin() + Vector(0, 0, 100))
			EmitSoundOn("Redfall.ForestSwitchLand", stone)
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function fortunis_death(event)
	local caster = event.caster
	EmitSoundOn("Redfall.FortunisEffigy.Die", caster)
	Timers:CreateTimer(1.5, function()
		local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(3474, 5380, 513 + Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 3.51)
		Redfall:CastleSpawnBackHallway()
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleBlocker1", Vector(3474, 5380, 513 + Redfall.ZFLOAT), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end)
end

function TreasureDialogueTrigger(trigger)
	local hero = trigger.activator
	if Redfall.Castle.TreasureGhost then
		Quests:ShowDialogueText({hero}, Redfall.Castle.TreasureGhost, "maze_ghost_dialogue", 6, false)
		StartAnimation(Redfall.Castle.TreasureGhost, {duration = 1.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.3})
		EmitSoundOn("Redfall.TreasureGhost.Laugh", Redfall.Castle.TreasureGhost)
	end
end

function TreasureRoomTrigger1(trigger)
	if Redfall.Castle.TreasureGhost then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", Redfall.Castle.TreasureGhost, 2)
		local ghost = Redfall.Castle.TreasureGhost
		Redfall.Castle.TreasureGhost = false
		EmitSoundOn("Redfall.DinosaurShift", ghost)
		Timers:CreateTimer(1, function()
			UTIL_Remove(ghost)
		end)
		pushSwitchesAndOpenDoor(Vector(-1940, 7318, 489 + Redfall.ZFLOAT), "TreasureBlocker1", Vector(-1906, 6916), 1)
	end
end

function TreasureRoomTrigger2(trigger)
	if Redfall.Castle.TreasureGhost then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", Redfall.Castle.TreasureGhost, 2)
		local ghost = Redfall.Castle.TreasureGhost
		Redfall.Castle.TreasureGhost = false
		EmitSoundOn("Redfall.DinosaurShift", ghost)
		Timers:CreateTimer(1, function()
			UTIL_Remove(ghost)
		end)
		pushSwitchesAndOpenDoor(Vector(-768, 7318, 480 + Redfall.ZFLOAT), "TreasureBlocker2", Vector(-768, 6916), 2)
	end
end

function TreasureRoomTrigger3(trigger)
	if Redfall.Castle.TreasureGhost then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", Redfall.Castle.TreasureGhost, 2)
		local ghost = Redfall.Castle.TreasureGhost
		Redfall.Castle.TreasureGhost = false
		EmitSoundOn("Redfall.DinosaurShift", ghost)
		Timers:CreateTimer(1, function()
			UTIL_Remove(ghost)
		end)
		pushSwitchesAndOpenDoor(Vector(346, 7318, 489 + Redfall.ZFLOAT), "TreasureBlocker3", Vector(432, 6916), 3)
	end
end

function pushSwitchesAndOpenDoor(doorPos, blockerName, prizePosition, prizeIndex)
	Redfall:ActivateSwitchGeneric(Vector(325, 7673, 1 + Redfall.ZFLOAT), "TreasureRoomSwitch", true, 0.165)
	Redfall:ActivateSwitchGeneric(Vector(-762, 7673, 1 + Redfall.ZFLOAT), "TreasureRoomSwitch", true, 0.165)
	Redfall:ActivateSwitchGeneric(Vector(-1908, 7673, 1 + Redfall.ZFLOAT), "TreasureRoomSwitch", true, 0.165)
	local walls = Entities:FindAllByNameWithin("TreasureWall", doorPos, 600)
	Redfall:Walls(false, walls, true, 3.51)
	Timers:CreateTimer(5, function()
		local blockers = Entities:FindAllByNameWithin(blockerName, doorPos, 1500)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)
	if Redfall.Castle.TreasureTable[prizeIndex] == 1 then
		Redfall:SpawnEtherealRevenant(prizePosition, Vector(0, 1))
	elseif Redfall.Castle.TreasureTable[prizeIndex] == 2 then
		local torch = CreateUnitByName("npc_dummy_unit", prizePosition, false, nil, nil, DOTA_TEAM_NEUTRALS)
		torch:SetOriginalModel("models/redfall/chest_hitbox.vmdl")
		torch:SetModel("models/redfall/chest_hitbox.vmdl")
		torch.jumpLock = true
		torch:SetForwardVector(Vector (0, 1))
		torch:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
		torch:AddAbility("redfall_fortune_chest_ability"):SetLevel(1)
		torch:RemoveAbility("dummy_unit")
		torch:RemoveModifierByName("dummy_unit")
		torch:SetRenderColor(100, 100, 100)
		torch.code = -1
	elseif Redfall.Castle.TreasureTable[prizeIndex] == 3 then
		local torch = CreateUnitByName("npc_dummy_unit", prizePosition, false, nil, nil, DOTA_TEAM_NEUTRALS)
		torch:SetOriginalModel("models/props_gameplay/rune_invisibility01.vmdl")
		torch:SetModel("models/props_gameplay/rune_invisibility01.vmdl")
		torch.jumpLock = true
		torch:SetForwardVector(Vector (0, 1))
		torch:SetModelScale(4.0)
		torch:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
		torch:AddAbility("redfall_arcane_crystal_mine"):SetLevel(1)
		torch:RemoveAbility("dummy_unit")
		torch:RemoveModifierByName("dummy_unit")
		torch.attacks = 6
	end
end

function ethereal_revenant_die(event)
	local caster = event.caster
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		RPCItems:RollClawOfTheEtherealRevenant(caster:GetAbsOrigin())
	end
	EmitSoundOn("Redfall.EtherealRevenant.Death", caster)

end

function crystal_mine_attack(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	caster.attacks = caster.attacks - 1
	Glyphs:DropArcaneCrystals(position, 0.45)
	caster:SetModelScale(4.0 - (6 - caster.attacks) * 0.3)
	StartAnimation(caster, {duration = 0.87, activity = ACT_DOTA_IDLE, rate = 2.0})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_cant_be_attacked", {duration = 0.9})
	Timers:CreateTimer(0.9, function()
		StartAnimation(caster, {duration = 900, activity = ACT_DOTA_IDLE, rate = 1})
	end)
	if caster.attacks <= 0 then
		caster:RemoveModifierByName("modifier_attackable_prop")
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster, 2)
		EmitSoundOn("Redfall.CrystalMine.Break", caster)
		caster:SetModelScale(0.1)
		Timers:CreateTimer(1.5, function()
			UTIL_Remove(caster)
		end)
	end
end

function garden_watcher_nuke_precast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local particleName = "particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)

	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, target:GetAbsOrigin())
	Timers:CreateTimer(0.6, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Redfall.GardenWatcher.EquinoctialShift", caster)
end

function garden_watcher_nuke_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local newCasterPos = WallPhysics:WallSearch(target:GetAbsOrigin(), caster:GetAbsOrigin(), caster)
	local newTargetPos = WallPhysics:WallSearch(caster:GetAbsOrigin(), target:GetAbsOrigin(), target)

	FindClearSpaceForUnit(caster, newTargetPos, false)
	FindClearSpaceForUnit(target, newCasterPos, false)
end

function ElthezunTrigger(trigger)
	if not Redfall.ElthezunTriggered then
		Redfall.Castle.ElthezunSpawnParticleTable = {}
		local miniBoss = Redfall.Castle.Elthezun
		local bossBlinkAbility = miniBoss:FindAbilityByName("antimage_blink_custom")
		EndAnimation(miniBoss)
		Redfall.ElthezunTriggered = true
		Timers:CreateTimer(0.06, function()
			EmitSoundOn("Redfall.Elthezun.Laugh", miniBoss)
			StartAnimation(miniBoss, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.7})
		end)
		Timers:CreateTimer(2, function()
			local castPoint = Vector(5952, 4215)
			local newOrder = {
				UnitIndex = miniBoss:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = bossBlinkAbility:entindex(),
				Position = castPoint
			}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(0.5, function()
				miniBoss:SetForwardVector(Vector(0, -1))
				StartAnimation(miniBoss, {duration = 1.3, activity = ACT_DOTA_TELEPORT, rate = 1})
				EmitSoundOn("Redfall.Elthezun.SpawnGrunt", miniBoss)
				EmitSoundOnLocationWithCaster(Vector(5952, 4010, 158 + Redfall.ZFLOAT), "Redfall.CastleSpawner.Activate", Redfall.RedfallMaster)
				local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, Vector(5952, 4010, 158 + Redfall.ZFLOAT))
				Timers:CreateTimer(6, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)

				local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
				ParticleManager:SetParticleControl(pfx2, 0, Vector(5952, 4010, 138 + Redfall.ZFLOAT))
				AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(5952, 4010), 500, 1500, false)
				table.insert(Redfall.Castle.ElthezunSpawnParticleTable, pfx2)
				Timers:CreateTimer(4, function()
					Redfall:SpawnElthezunWaveUnit("iron_spine", Vector(5952, 4010), 8, 90, 1.3, true)
				end)
			end)
		end)
		Timers:CreateTimer(7, function()
			local castPoint = Vector(6784, 4288)
			local newOrder = {
				UnitIndex = miniBoss:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = bossBlinkAbility:entindex(),
				Position = castPoint
			}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(0.5, function()
				miniBoss:SetForwardVector(Vector(0, -1))
				StartAnimation(miniBoss, {duration = 1.3, activity = ACT_DOTA_TELEPORT, rate = 1})
				EmitSoundOn("Redfall.Elthezun.SpawnGrunt", miniBoss)
				local spawnLoc = Vector(6765, 4010, 138 + Redfall.ZFLOAT)
				EmitSoundOnLocationWithCaster(spawnLoc, "Redfall.CastleSpawner.Activate", Redfall.RedfallMaster)
				local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, spawnLoc)
				Timers:CreateTimer(6, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)

				local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
				ParticleManager:SetParticleControl(pfx2, 0, spawnLoc)
				AddFOWViewer(DOTA_TEAM_GOODGUYS, spawnLoc, 500, 1500, false)
				table.insert(Redfall.Castle.ElthezunSpawnParticleTable, pfx2)
				Timers:CreateTimer(4, function()
					Redfall:SpawnElthezunWaveUnit("iron_spine", spawnLoc, 8, 90, 1.3, true)
				end)
			end)
		end)
		Timers:CreateTimer(12, function()
			local castPoint = Vector(5958, 4907)
			local newOrder = {
				UnitIndex = miniBoss:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = bossBlinkAbility:entindex(),
				Position = castPoint
			}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(0.5, function()
				miniBoss:SetForwardVector(Vector(0, 1))
				StartAnimation(miniBoss, {duration = 1.3, activity = ACT_DOTA_TELEPORT, rate = 1})
				EmitSoundOn("Redfall.Elthezun.SpawnGrunt", miniBoss)
				local spawnLoc = Vector(5952, 5184, 138 + Redfall.ZFLOAT)
				EmitSoundOnLocationWithCaster(spawnLoc, "Redfall.CastleSpawner.Activate", Redfall.RedfallMaster)
				local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, spawnLoc)
				Timers:CreateTimer(6, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)

				local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
				ParticleManager:SetParticleControl(pfx2, 0, spawnLoc)
				AddFOWViewer(DOTA_TEAM_GOODGUYS, spawnLoc, 500, 1500, false)
				table.insert(Redfall.Castle.ElthezunSpawnParticleTable, pfx2)
				Timers:CreateTimer(4, function()
					Redfall:SpawnElthezunWaveUnit("iron_spine", spawnLoc, 8, 90, 1.3, true)
				end)
			end)
		end)
		Timers:CreateTimer(17, function()
			local castPoint = Vector(6784, 4864)
			local newOrder = {
				UnitIndex = miniBoss:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = bossBlinkAbility:entindex(),
				Position = castPoint
			}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(0.5, function()
				miniBoss:SetForwardVector(Vector(0, 1))
				StartAnimation(miniBoss, {duration = 1.3, activity = ACT_DOTA_TELEPORT, rate = 1})
				EmitSoundOn("Redfall.Elthezun.SpawnGrunt", miniBoss)
				local spawnLoc = Vector(6765, 5184, 138 + Redfall.ZFLOAT)
				EmitSoundOnLocationWithCaster(spawnLoc, "Redfall.CastleSpawner.Activate", Redfall.RedfallMaster)
				local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, spawnLoc)
				Timers:CreateTimer(6, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)

				local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
				ParticleManager:SetParticleControl(pfx2, 0, spawnLoc)
				AddFOWViewer(DOTA_TEAM_GOODGUYS, spawnLoc, 500, 1500, false)
				table.insert(Redfall.Castle.ElthezunSpawnParticleTable, pfx2)
				Timers:CreateTimer(4, function()
					Redfall:SpawnElthezunWaveUnit("iron_spine", spawnLoc, 8, 90, 1.3, true)
				end)

				local mainAbility = miniBoss:FindAbilityByName("redfall_prince_elthezun_ability")
				mainAbility:ApplyDataDrivenModifier(miniBoss, miniBoss, "modifier_elthezun_during_wave", {})
			end)
		end)
	end
end

function elthezun_during_wave_think(event)
	local caster = event.caster
	local blinkAbility = caster:FindAbilityByName("antimage_blink_custom")
	local positionTable = {Vector(5568, 5120), Vector(5568, 4250), Vector(7183, 3864), Vector(7283, 4611), Vector(7178, 5371), Vector(6376, 4596)}
	local castPoint = positionTable[RandomInt(1, #positionTable)] + RandomVector(90)
	local newOrder = {
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blinkAbility:entindex(),
		Position = castPoint
	}
	ExecuteOrderFromTable(newOrder)
end

function elthezun_combat_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval > 7 then
		local luck = RandomInt(1, 3)
		if luck == 3 then
			EmitSoundOn("Redfall.Elthezun.BlinkGrunt", caster)
		end
		local blinkAbility = caster:FindAbilityByName("antimage_blink_custom")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2160, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin() + RandomVector(120)
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = blinkAbility:entindex(),
				Position = castPoint
			}
			ExecuteOrderFromTable(newOrder)
		end
		caster.interval = 0
	end
	local projectileCount = 1
	if caster:GetHealth() < caster:GetMaxHealth() * 0.51 then
		projectileCount = 2
	end
	if GameState:GetDifficultyFactor() == 3 then
		projectileCount = projectileCount + 1
	end
	for i = 1, projectileCount, 1 do
		create_elthezun_projectile(caster, ability)
	end
end

function create_elthezun_projectile(caster, ability)
	local projectileParticle = "particles/base_attacks/majinaq_linear.vpcf"
	local projectileOrigin = caster:GetAbsOrigin()
	local start_radius = 95
	local end_radius = 95
	local fv = RandomVector(1)
	local range = 1200
	local speed = 300 + RandomInt(0, 250)
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = projectileOrigin + Vector(0, 0, 110),
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
		fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function elthezun_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	local mana_drain = event.mana_drain
	EmitSoundOn("Redfall.Elthezun.ProjectileHit", target)
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	target:ReduceMana(mana_drain)
end

function elthezun_die(event)
	local caster = event.caster
	EmitSoundOn("Redfall.Elthezun.Death", caster)
	local cameralockers = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	Timers:CreateTimer(2, function()
		if #cameralockers > 0 then
			Dungeons:CreateBasicCameraLockForHeroes(Vector(870, 4968), 4, cameralockers)
		end
		local walls = Entities:FindAllByNameWithin("CastleWall7", Vector(870, 4968, 534 + Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 3.51)
		Redfall:CastleInitiateAfterHallwayRoom()
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("CastleBlocker5", Vector(896, 4992, 128 + Redfall.ZFLOAT), 2000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
	end)
end

function cannibal_die(event)
	local caster = event.caster
	EmitSoundOn("Redfall.TheCannibal.Death", caster)
	local switch = Entities:FindByNameNearest("FinalRoomSwitch", Vector(246, 5868, -491 + Redfall.ZFLOAT), 800)
	Redfall:DropCastleSwtich(switch, 1)
	Timers:CreateTimer(2, function()
		Redfall.Castle.FinalSwitchActive = true
	end)
end

function FinalRoomSwitchTrigger(event)
	if Redfall.Castle.FinalSwitchActive then
		if not Redfall.Castle.FinalSwitchPressed then
			Redfall.Castle.FinalSwitchPressed = true
			Redfall:ActivateSwitchGeneric(Vector(246, 5868, 9 + Redfall.ZFLOAT), "FinalRoomSwitch", true, 0.165)
			local walls = Entities:FindAllByNameWithin("CastleWall7", Vector(-1410, 5932, 527 + Redfall.ZFLOAT), 2000)
			Redfall:Walls(false, walls, true, 3.51)
			Redfall:CastleInitiateFinalRoom()
			Timers:CreateTimer(5, function()
				local blockers = Entities:FindAllByNameWithin("CastleBlocker6", Vector(-1384, 5888, 128 + Redfall.ZFLOAT), 3000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
		end
	end
end

function demon_follower_think(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("redfall_demon_follower_finger")
	if castAbility and castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = enemies[1]:entindex(),
				AbilityIndex = castAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
		end
	end
end

function FinalBossTrigger()
	if Redfall.Castle.BossStatuesActivated == 2 and Redfall.Castle.FinalSwitchPressed == true then
		Redfall.Castle.BossStatuesActivated = 3
		Redfall.FinalBossStart = true
		local allies = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(448, 2542), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		for i = 1, #allies, 1 do
			CustomGameEventManager:Send_ServerToPlayer(allies[i]:GetPlayerOwner(), "BGMend", {})
		end
		for j = 1, 8, 1 do
			Timers:CreateTimer(j * 0.4, function()
				EmitSoundOnLocationWithCaster(Vector(448, 2542), "Redfall.StatueMoving", Events.GameMaster)
				ScreenShake(Vector(448, 2542), 2, 2, 1.5, 9000, 0, true)
			end)
		end
		Timers:CreateTimer(3, function()
			Redfall:CastleBossMusic()
			EmitSoundOnLocationWithCaster(Vector(448, 2542), "Redfall.FinalBoss.Intro1", Events.GameMaster)
			Timers:CreateTimer(1.5, function()
				local boss = CreateUnitByName("redfall_crimsyth_castle_boss", Vector(448, 2542), false, nil, nil, DOTA_TEAM_NEUTRALS)
				Redfall.Castle.FinalBoss = boss
				boss.type = ENEMY_TYPE_BOSS
				boss:SetAbsOrigin(boss:GetAbsOrigin() - Vector(0, 0, 600))
				boss:SetForwardVector(Vector(0, -1))
				Events:AdjustBossPower(boss, 16, 16, false)
				local ability = boss:FindAbilityByName("redfall_crimsyth_castle_boss_ai")
				boss:SetRenderColor(255, 60, 40)
				ability:ApplyDataDrivenModifier(boss, boss, "modifier_waiting", {})
				EmitSoundOn("Redfall.CastleBoss.Lava", boss)
				EmitSoundOnLocationWithCaster(boss:GetAbsOrigin(), "Redfall.CastleBoss.LavaEmerge", Events.GameMaster)
				Redfall:CreateLavaBlast(Vector(448, 2542, -110 + Redfall.ZFLOAT))
				for i = 1, 120, 1 do
					Timers:CreateTimer(i * 0.03, function()
						boss:SetAbsOrigin(boss:GetAbsOrigin() + Vector(0, 0, 6.0))
					end)
				end
				Timers:CreateTimer(1, function()
					boss:RemoveModifierByName("modifier_cant_die_generic")
					StartAnimation(boss, {duration = 3.5, activity = ACT_DOTA_CAST_ABILITY_3, rate = 0.3})
					Quests:ShowDialogueText(MAIN_HERO_TABLE, boss, "redfall_castle_boss_dialogue_1", 6, false)
					EmitSoundOn("Redfall.CastleBoss.IntroVO1", boss)
					Timers:CreateTimer(4.5, function()
						StartAnimation(boss, {duration = 2.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.8})
						Quests:ShowDialogueText(MAIN_HERO_TABLE, boss, "redfall_castle_boss_dialogue_2", 6, false)
						EmitSoundOn("Redfall.CastleBoss.Anger1", boss)
						Timers:CreateTimer(4.5, function()
							StartAnimation(boss, {duration = 2.5, activity = ACT_DOTA_ATTACK, rate = 0.8})
							Quests:ShowDialogueText(MAIN_HERO_TABLE, boss, "redfall_castle_boss_dialogue_3", 6, false)
							EmitSoundOn("Redfall.CastleBoss.IntroVO2", boss)
							ability:ApplyDataDrivenModifier(boss, boss, "modifier_castle_boss_shielded_effect", {})

							Timers:CreateTimer(4.5, function()
								StartAnimation(boss, {duration = 2.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.8})
								Quests:ShowDialogueText(MAIN_HERO_TABLE, boss, "redfall_castle_boss_dialogue_4", 6, false)
								EmitSoundOn("Redfall.CastleBoss.IntroVO3", boss)
								CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = boss:GetUnitName(), bossMaxHealth = boss:GetMaxHealth(), bossId = tostring(boss)})
								Timers:CreateTimer(2, function()
									for i = 1, 12, 1 do
										Timers:CreateTimer(i * 0.4, function()
											Redfall:FinalBossSummon(boss, "redfall_crimsyth_recruiter")
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
end

function boss_illusion_ability_cast(event)
	local caster = event.caster
	local ability = event.ability
	if caster.illusion then
		return
	end
	if not caster:HasModifier("modifier_boss_illusion_ability_effect") then
		if not caster.illusionCount then
			caster.illusionCount = 0
		end
		local numIllusions = GameState:GetDifficultyFactor()
		if Events.SpiritRealm then
			numIllusions = numIllusions * 2
		end
		if caster.illusionCount < GameState:GetDifficultyFactor() * 3 then
			for i = 1, numIllusions, 1 do
				Timers:CreateTimer((i - 1) * 0.15, function()
					local position = WallPhysics:WallSearch(caster:GetAbsOrigin(), caster:GetAbsOrigin() + RandomVector(340), caster)
					local illusion = CreateUnitByName("redfall_crimsyth_castle_boss_illusion", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
					-- boss:SetAbsOrigin(Vector(-14826, -16121, 950))
					Events:AdjustDeathXP(illusion)
					Events:AdjustBossPower(illusion, 16, 16, false)
					illusion.illusion = true
					EmitSoundOn("Redfall.FinalBoss.IllusionSpawn", illusion)
					CustomAbilities:QuickAttachParticle("particles/dire_fx/bad_ancient_beams.vpcf", illusion, 3)
					CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", illusion, 3)
					illusion:SetRenderColor(105, 123, 221)
					illusion.boss = caster
					ability:ApplyDataDrivenModifier(caster, illusion, "modifier_boss_illusion_ability_effect", {})
					illusion:SetMaximumGoldBounty(0)
					illusion:SetMinimumGoldBounty(0)
					illusion:SetAcquisitionRange(2400)
					illusion:SetDeathXP(0)
					caster.illusionCount = caster.illusionCount + 1
				end)
			end
		end
	end
end

function castle_boss_in_combat_1(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetHealth() < 10000 then
		caster:RemoveModifierByName("modifier_final_boss_in_combat_phase_1")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_final_boss_move_to_pit", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_castle_boss_shielded_effect", {})
	end
	local illusionAbility = caster:FindAbilityByName("crimsyth_boss_illusion_ability")
	if illusionAbility:IsFullyCastable() then
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = illusionAbility:entindex(),
		}

		ExecuteOrderFromTable(newOrder)
		return true
	end
	if caster:GetHealth() < caster:GetMaxHealth() * 0.66 then
		local blastAbility = caster:FindAbilityByName("crimsyth_final_boss_fire_blast")
		if blastAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = blastAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function boss_illusion_die(event)
	local caster = event.unit
	local boss = caster.boss
	boss.illusionCount = boss.illusionCount - 1
end

function final_boss_fire_blast_start(event)
	local caster = event.caster
	local point = event.target_points[1]
	local ability = event.ability

	if caster:HasModifier("modifier_final_boss_in_combat_phase_1") then
		final_boss_fire_blast_meteor(caster, ability, point)
	elseif caster:HasModifier("modifier_final_boss_final_form") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		for i = 1, #enemies, 1 do
			final_boss_fire_blast_meteor(caster, ability, enemies[i]:GetAbsOrigin())
			if caster:GetHealth() < caster:GetMaxHealth() * 0.8 then
				Timers:CreateTimer(0.25, function()
					final_boss_fire_blast_meteor(caster, ability, enemies[i]:GetAbsOrigin() + RandomVector(400))
				end)
			end
			if caster:GetHealth() < caster:GetMaxHealth() * 0.5 then
				Timers:CreateTimer(0.5, function()
					final_boss_fire_blast_meteor(caster, ability, enemies[i]:GetAbsOrigin() + RandomVector(800))
				end)
			end
			if caster:GetHealth() < caster:GetMaxHealth() * 0.25 then
				Timers:CreateTimer(0.75, function()
					final_boss_fire_blast_meteor(caster, ability, enemies[i]:GetAbsOrigin() + RandomVector(1200))
				end)
			end
		end
	end
end

function final_boss_fire_blast_meteor(caster, ability, point)
	local pfx = ParticleManager:CreateParticle("particles/redfall/fire_sphere.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, point)
	ParticleManager:SetParticleControl(pfx, 3, point)
	-- ParticleManager:SetParticleControl(pfx, 1, Vector(50, 150, 255))
	Timers:CreateTimer(2.2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	local meteor = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeamNumber())
	meteor:SetModelScale(1.6)
	meteor:SetAbsOrigin(meteor:GetAbsOrigin() + Vector(0, 0, 1500))
	ability:ApplyDataDrivenModifier(caster, meteor, "modifier_meteor_falling", {})
	meteor.fallVelocity = 8
	meteor.origCaster = caster
	meteor:SetOriginalModel("models/particle/meteor.vmdl")
	meteor:SetModel("models/particle/meteor.vmdl")
	meteor.rotation = 0
	EmitSoundOn("Redfall.BossMeteor.Falling", meteor)
end

function boss_meteor_falling_think(event)
	local caster = event.target
	local ability = event.ability
	if not IsValidEntity(caster) then
		return false
	end
	local ability = event.ability
	caster.fallVelocity = caster.fallVelocity + 0.5
	caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, caster.fallVelocity))
	caster.rotation = caster.rotation + 2
	caster:SetAngles(caster.rotation, caster.rotation / 2, caster.rotation / 3)
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 20 then
		local damage = event.damage
		local position = caster:GetAbsOrigin()
		local radius = 360
		local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster.origCaster)
		ParticleManager:SetParticleControl(particle2, 0, position)
		ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
		ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
		ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 20))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(particle2, false)
		end)
		EmitSoundOnLocationWithCaster(position, "Redfall.BossMeteor.Impact", caster.origCaster)
		local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster.origCaster)
		ParticleManager:SetParticleControl(particle1, 0, position)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster.origCaster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
				enemy:AddNewModifier(caster.origCaster, nil, "modifier_stunned", {duration = 1.5})
			end
		end
		UTIL_Remove(caster)

	end
end

function castle_boss_move_to_pit_think(event)
	local caster = event.caster
	local ability = event.ability

	local moveToPoint = Vector(-512, 2432, 368)
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), moveToPoint)
	caster:MoveToPosition(moveToPoint)
	if distance < 120 then
		caster:RemoveModifierByName("modifier_final_boss_move_to_pit")
		caster:SetForwardVector(Vector(1, 0))
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_boss_root", {})
		Timers:CreateTimer(0.5, function()
			caster:SetHealth(caster:GetMaxHealth())
			StartAnimation(caster, {duration = 4.0, activity = ACT_DOTA_CAST_ABILITY_3_END, rate = 0.23})
			WallPhysics:Jump(caster, Vector(1, 0), 17, 24, 19, 0.8)
			caster.jumpEnd = nil
			Timers:CreateTimer(1.4, function()
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.CastleBoss.LavaEmerge", Events.GameMaster)
				Redfall:CreateLavaBlast(caster:GetAbsOrigin() - Vector(0, 0, 70))
				for i = 1, 40, 1 do
					Timers:CreateTimer(i * 0.03, function()
						caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 40))
					end)
				end
				Timers:CreateTimer(4.2, function()
					caster.jumpLock = true
					EmitSoundOn("Redfall.FinalBoss.Laugh1", caster)
					caster:SetModelScale(5.0)
					for i = 1, 80, 1 do
						Timers:CreateTimer(i * 0.03, function()
							ScreenShake(caster:GetAbsOrigin(), 2, 2, 1.5, 9000, 0, true)
							caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 12))
						end)
					end
					Timers:CreateTimer(0.3, function()
						StartAnimation(caster, {duration = 3.0, activity = ACT_DOTA_CAST_ABILITY_3, rate = 0.3})
						Redfall:CreateLavaBlast(caster:GetAbsOrigin())
						EmitSoundOn("Redfall.CastleBoss.IntroVO1", caster)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_final_boss_final_form", {})
					end)
					Timers:CreateTimer(3.5, function()
						EmitGlobalSound("Redfall.FinalBoss.Taunt")
						caster:RemoveModifierByName("modifier_castle_boss_shielded_effect")
					end)
					local castleFXTable = Entities:FindAllByNameWithin("CastleFX", Vector(260, 2500, 295 + Redfall.ZFLOAT), 3000)
					for j = 1, 120, 1 do
						Timers:CreateTimer(j * 0.03, function()
							for i = 1, #castleFXTable, 1 do
								castleFXTable[i]:SetAbsOrigin(castleFXTable[i]:GetAbsOrigin() - Vector(0, 0, 6))
							end
						end)
					end
				end)
			end)
		end)
	end
end

function castle_boss_in_combat_2(event)
	local caster = event.caster
	local ability = event.ability
	if caster.dying then
		return false
	end
	if caster:GetHealth() < 10000 then
		caster.dying = true
		for i = 1, #MAIN_HERO_TABLE, 1 do
			CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
		end
		Redfall.CastleFinalBossEnd = true
		local cantDieAbility = caster:FindAbilityByName("redfall_crimsyth_castle_boss_passive")
		castle_final_boss_death(caster, cantDieAbility)
	end

	local blastAbility = caster:FindAbilityByName("crimsyth_final_boss_fire_blast")
	if blastAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = blastAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
		end
	end

end

function castle_boss_split_attack(event)
	local attacker = event.attacker
	local target = event.target
	local targetPoint = target:GetAbsOrigin()
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), targetPoint, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if not (enemy:GetEntityIndex() == target:GetEntityIndex()) then
				local info =
				{
					Target = enemy,
					Source = attacker,
					Ability = ability,
					EffectName = "particles/redfall/castle_boss_attack.vpcf",
					StartPosition = "attach_attack1",
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = true,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					flExpireTime = GameRules:GetGameTime() + 7,
					bProvidesVision = false,
					iVisionRadius = 0,
					iMoveSpeed = 1000,
				}
				projectile = ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end

end

function castle_boss_split_attack_hit(event)
	local caster = event.caster
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	local ability = event.ability
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
end

function castle_final_boss_death(caster, ability)
	Statistics.dispatch("redfall_ridge:kill:lord_scarloth");
	CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dying_generic", {})
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Redfall.FinalBoss.Death", caster)
	end)
	Dungeons.lootLaunch = Vector(-832, 2432)
	Timers:CreateTimer(12, function()
		Dungeons.lootLaunch = false
	end)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
		-- local luck = RandomInt(1,4)
		-- if luck == 1 then
		-- RPCItems:RollCrimsythEliteGreavesLV1(caster:GetAbsOrigin(), false)
		-- end
	end)
	caster:BossDrops(15)
	Timers:CreateTimer(3, function()
		local maxRoll = 250
		if GameState:GetDifficultyFactor() == 3 then
			maxRoll = 170
		end
		if Events.SpiritRealm then
			maxRoll = maxRoll - 60
		end
		local requirement = 2 + GameState:GetPlayerPremiumStatusCount()
		local luck = RandomInt(1, maxRoll)
		if luck <= requirement then
			RPCItems:RollAndDropUniqueArcana(caster, "item_rpc_chernobog_arcana1")
		end
	end)
	-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_temple_boss_dying_effect", {})
	local bossOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(8, function()
		Enemies:EnemySlain(caster, nil)
		Events:MainBossSlain(caster:GetUnitName())
		caster:RemoveModifierByName("modifier_dying_generic")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_cant_die_disabled", {duration = 20})
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration = 8, activity = ACT_DOTA_DIE, rate = 0.25})
			EmitSoundOn("Redfall.FinalBoss.Death2", caster)
			Timers:CreateTimer(0.5, function()
				Redfall:FinalBossDrops(caster)
				Redfall:CreateLavaBlast(bossOrigin + Vector(0, 0, 300))
			end)
			for i = 1, 120, 1 do
				Timers:CreateTimer(i * 0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, -6) - caster:GetForwardVector() * 5)
					end
				end)
			end
			Timers:CreateTimer(3, function()
				for i = 1, #MAIN_HERO_TABLE, 1 do
					Redfall:GiveSpiritRuby(MAIN_HERO_TABLE[i], bossOrigin + Vector(0, 0, 300))
				end
			end)
			Timers:CreateTimer(5.7, function()
				UTIL_Remove(caster)
				Redfall:DefeatDungeonBoss("castle", bossOrigin)
			end)
		end)
	end)
	Timers:CreateTimer(20, function()
		if GameState:GetDifficultyFactor() == 3 then
			Redfall:SpawnAncientTree()
		end
	end)
end

function lava_behemoth_die(event)
	local caster = event.caster
	EmitSoundOn("Redfall.LavaBehemoth.Aggro", caster)
	RPCItems:RollIgneousCanineHelm(caster:GetAbsOrigin())
end

function lava_behemoth_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	if not ability.projectiles then
		ability.projectiles = 0
	end
	if ability.projectiles < 16 then
		ability.projectiles = ability.projectiles + 1
		EmitSoundOn("Redfall.SorceressFire", caster)
		local info =
		{
			Target = attacker,
			Source = caster,
			Ability = ability,
			EffectName = "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_base_attack.vpcf",
			StartPosition = "attach_hitloc",
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 5,
			bProvidesVision = false,
			iVisionRadius = 0,
			iMoveSpeed = 750,
		iVisionTeamNumber = caster:GetTeamNumber()}

		projectile = ProjectileManager:CreateTrackingProjectile(info)
		Timers:CreateTimer(2.5, function()
			ability.projectiles = ability.projectiles - 1
		end)
	end
end

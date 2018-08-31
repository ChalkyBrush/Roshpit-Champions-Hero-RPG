function quake_set_target(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability.position = target:GetAbsOrigin()
end

function enforcer_puff(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/ui/ui_generic_treasure_impact.vpcf", caster, 3)
	EmitSoundOn("Redfall.Enforcer.Poof", caster)
end

function redfall_tyrant_quake(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local radius = 240
	local position = ability.position
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/astral_rune_r_2.vpcf"
	local damage = event.damage
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	EmitSoundOn("Redfall.TyrantQuake", caster)
	-- FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
		end
	end 		
end

function CanyonRoom2Trigger()
	Redfall:CanyonRoom2Trigger()
end

function alpha_dash(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_redfall_alpha_charging", {duration = 5})
	ability.damage = event.damage
	local moveDirection = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
	local targetPosition = caster:GetAbsOrigin()+moveDirection*distance*2
	caster:MoveToPosition(targetPosition)
	ability.targetPosition = targetPosition
	caster.attacked = false
	caster:AddNewModifier( caster, nil, 'modifier_movespeed_cap', nil )
end


function alpha_dash_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.attacked then
		return
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 160, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	if #enemies > 0 then
		local enemy = enemies[1]
		EmitSoundOn("Redfall.AlphaPanda.ChargeImpact", enemy)
		caster:PerformAttack(enemy, true, true, false, true, false, false, false)
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=2.0})
		caster.attacked = true
		CustomAbilities:QuickAttachParticle("particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_fire_b_elixir.vpcf", enemy, 4)
		CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger_start.vpcf", enemy, 1)
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_alpha_debuff", {duration = 4})

		Timers:CreateTimer(1.2, function()
			caster:RemoveModifierByName("modifier_redfall_alpha_charging")
		end)
		ApplyDamage({ victim = enemy, attacker = caster, damage = event.ability.damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
	end
	if WallPhysics:GetDistance(caster:GetAbsOrigin(), event.ability.targetPosition) < 170 then
		caster:RemoveModifierByName("modifier_redfall_alpha_charging")
	end
	print(caster:GetAbsOrigin().z)
	print((caster:GetAbsOrigin()+caster:GetForwardVector()*200).z)
	if caster:GetAbsOrigin().z < (caster:GetAbsOrigin()+caster:GetForwardVector()*200).z - 20 then
		print("REMOVE FLIGHT")
		caster.attacked = true
		caster:RemoveModifierByName("modifier_redfall_alpha_charging")
	end
end

function waveScreenShake(event)
	local caster = event.caster
	ScreenShake(caster:GetAbsOrigin(), 260, 0.3, 0.3, 9000, 0, true)
end

function BruiserAmbush()
	Redfall:BruiserAmbush()
end

function CanyonPart2()
	Redfall:CanyonPart2()
end

function predator_passive_damage(event)
	local caster = event.caster
	local modifier = caster:FindModifierByName("modifier_canyon_predator_effect")
	if modifier then
		modifier:IncrementStackCount()
	end
end

function armored_crab_beast_ability_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_crab_beast_burrowwing", {duration = 2.83})
	StartAnimation(caster, {duration=2.83, activity=ACT_DOTA_TAUNT, rate=1.0})
	for i = 1, 30, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,2))
		end)
	end
	EmitSoundOn("Redfall.CanyonBurrow", caster)
	local pfx = ParticleManager:CreateParticle("particles/econ/items/sand_king/sandking_barren_crown/sandking_rubyspire_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	Timers:CreateTimer(2.0, function()
		local targetPosition = target:GetAbsOrigin() + RandomVector(240)
		FindClearSpaceForUnit(caster, targetPosition, false)
		for i = 1, 26, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,2))
			end)
		end
		local pfx2 = ParticleManager:CreateParticle("particles/econ/items/sand_king/sandking_barren_crown/sandking_rubyspire_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx2, 1, caster:GetAbsOrigin())
		EmitSoundOn("Redfall.CanyonBurrow", caster)
		Timers:CreateTimer(5, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:DestroyParticle(pfx2, false)
		end)
	end)
end

function dinosaur_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro then
		local baseFV = RandomVector(1)
		local fireBalls = 3 + GameState:GetDifficultyFactor()
		EmitSoundOn("Redfall.FireballPassive", caster)
		local randomFireballHeight = RandomInt(70, 130)
		for i = 1, fireBalls, 1 do
			local fv = WallPhysics:rotateVector(baseFV, 2*i*math.pi/fireBalls)
			local projectileParticle = "particles/roshpit/warlord/fire_ulti_linear.vpcf"
			local start_radius = 150
			local end_radius = 150
			local range = 1500
			local speed = 1200
			local info = 
			{
					Ability = ability,
		        	EffectName = projectileParticle,
		        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,randomFireballHeight),
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
		        	fExpireTime = GameRules:GetGameTime() + 4.0,
				bDeleteOnHit = false,
				vVelocity = fv * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end
	end
end

function dinosaur_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_doom_bringer/doom_loadout.vpcf", caster, 4)
	EmitSoundOn("Redfall.FireballImpact", caster)
end

function dinosaur_die(event)
	local caster = event.caster
	Timers:CreateTimer(1.5, function()
		print("GO!")
		Redfall.RedLizard = CreateUnitByName("redfall_lzard_guide", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
		Redfall.RedLizard:SetDayTimeVisionRange(500)
		Redfall.RedLizard:SetNightTimeVisionRange(500)
		Redfall.RedLizard:SetBaseMoveSpeed(300)

		Redfall.RedLizard:SetModelScale(1.55)
		Redfall.RedLizard:SetRenderColor(242, 255, 88)
		Redfall.RedLizard:SetForwardVector(caster:GetForwardVector())
		Redfall.RedLizard:AddAbility("redfall_lizard_guide_passive"):SetLevel(1)
		EmitSoundOn("Redfall.FireballPassive", Redfall.RedLizard)
		WallPhysics:Jump(Redfall.RedLizard, caster:GetForwardVector(), 10, 24, 35, 1)
		local particleName = "particles/units/heroes/hero_doom_bringer/doom_loadout.vpcf"
	    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Redfall.RedLizard)
	    ParticleManager:SetParticleControl(pfx,0,Redfall.RedLizard:GetAbsOrigin())   
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		Timers:CreateTimer(0.2, function()
			StartAnimation(Redfall.RedLizard, {duration=1.2, activity=ACT_DOTA_SPAWN, rate=0.5})
		end)
		Timers:CreateTimer(1.7, function()
			local particleName = "particles/units/heroes/hero_doom_bringer/doom_loadout.vpcf"
		    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Redfall.RedLizard)
		    ParticleManager:SetParticleControl(pfx,0,Redfall.RedLizard:GetAbsOrigin())   
		    EmitSoundOn("Arena.ForestSwitchLand", Redfall.RedLizard)
			Redfall.RedLizard.aiState = 0

			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)

	end)
end

function redfall_guide_think(event)
	local ability = event.ability
	local caster = event.caster
	if caster.lock then
		return
	end
	if caster.aiState == 0 then
		local distance = 100
		if ability.lastPos then
			distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), ability.lastPos)
		end
		caster:MoveToPosition(Vector(-14272, 2880))
		if distance < 5 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_temporary_flying", {duration = 1.1})
		end
		ability.lastPos = caster:GetAbsOrigin()
		local distanceToTarget = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), Vector(-14272, 2880))
		if distanceToTarget < 80 then
			caster.lock = true
			Timers:CreateTimer(2, function()
				caster:SetOriginalModel("models/items/courier/deathbringer/deathbringer_flying.vmdl")
				caster:SetModel("models/items/courier/deathbringer/deathbringer_flying.vmdl")
				Redfall:CanyonDragonCross()
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster, 2)
				EmitSoundOn("Redfall.DinosaurShift", caster)
				caster.aiState = 1
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_lizard_flying", {})
				Timers:CreateTimer(1.5, function()
					caster.lock = false
					caster.targetPoint = Vector(-14464, 4928)
					caster.movementState = 0
					caster.pickupTable = {}
				end)
			end)
		end
	elseif caster.aiState == 1 then
		caster:MoveToPosition(caster.targetPoint)
		local distance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), caster.targetPoint)
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 180, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #allies > 0 then	
			for _,ally in pairs(allies) do
				if not ally:HasModifier("modifier_inside_lizard") and not ally:HasModifier("modifier_lizard_immunity") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_lizard_carrying", {})
					if not ability.carryPFX then
						ability.carryPFX = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/generic_buff_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
						ParticleManager:SetParticleControlEnt(ability.carryPFX, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
						ParticleManager:SetParticleControl(ability.carryPFX, 14, Vector(5, 1, 255))
						ParticleManager:SetParticleControl(ability.carryPFX, 15, Vector(255, 150, 0))
					end
					ability:ApplyDataDrivenModifier(caster, ally, "modifier_inside_lizard", {duration = 12})
					ally:AddNoDraw()
					table.insert(caster.pickupTable, ally)
					ability:ApplyDataDrivenModifier(caster, ally, "modifier_lizard_immunity", {duration = 4.5})
				end
			end
		end
		-- DeepPrintTable(caster.pickupTable)
		if distance < 80 then
			caster.lock = true
			local release = false
			for i = 1, #caster.pickupTable, 1 do
				local ally = caster.pickupTable[i]
				if not ally:HasModifier("modifier_lizard_immunity") then
					ability:ApplyDataDrivenModifier(caster, ally, "modifier_lizard_immunity", {duration = 4.5})
					FindClearSpaceForUnit(ally, caster:GetAbsOrigin(), false)
					ally:RemoveNoDraw()
					ally:RemoveModifierByName("modifier_inside_lizard")
					caster:RemoveModifierByName("modifier_lizard_carrying")
					release = true
					if ability.carryPFX then
						ParticleManager:DestroyParticle(ability.carryPFX, false)
						ability.carryPFX = false
					end
				end
			end
			if release then
				caster.pickupTable = {}
			end
			Timers:CreateTimer(3, function()
				caster.lock = false
				if caster.movementState == 0 then
					caster.movementState = 1
					caster.targetPoint = Vector(-14272, 2880)
				else
					caster.targetPoint = Vector(-14464, 4928)
					caster.movementState = 0
				end
			end)
		end
	end
end

function inDragonThink(event)
	local target = event.target
	local caster = event.caster
	target:SetAbsOrigin(caster:GetAbsOrigin())
end

function allyPickupStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local particleName = "particles/units/heroes/hero_doom_bringer/doom_loadout.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,target:GetAbsOrigin())   
    EmitSoundOn("Redfall.FireballPassive", target)

	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function barbarian_passive_think(event)
	local caster = event.caster
	if not caster:IsAlive() then
		return false
	end
	local ability = event.ability
	caster:RemoveModifierByName("modifier_stunned")
	caster:RemoveModifierByName("modifier_knockback")
	if not caster.aggro then
		return
	end
	if not caster.interval then
		caster.interval = 1
	end

	caster.interval = caster.interval + 1
	if caster.interval == 50 then
		StartAnimation(caster, {duration=0.78, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.0})
		caster.interval = 1
		EmitSoundOn("Redfall.Barbarian.AxeSlam", caster)
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Redfall.RedWave.Cast", caster)
			EmitSoundOn("Redfall.TreeRising", caster)
			local fv = caster:GetForwardVector()
			ScreenShake(caster:GetAbsOrigin(), 260, 0.3, 0.3, 9000, 0, true)
			local projectileParticle = "particles/roshpit/redfall_bigwave.vpcf"
			local start_radius = 240
			local end_radius = 240
			local range = 1200
			local speed = 600
			local info = 
			{
					Ability = ability,
		        	EffectName = projectileParticle,
		        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,10),
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
		        	fExpireTime = GameRules:GetGameTime() + 4.0,
				bDeleteOnHit = false,
				vVelocity = fv * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end)
	end

end

function barbarian_die(event)
	Redfall:SpawnAutumnCaveRoom()
	local caster = event.caster
	local targetPosition = Vector(-13440, 8768)
	EmitSoundOn("Redfall.FireballPassive", caster)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, targetPosition, 600, 30, true)
	local fv = (targetPosition - caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
	local projectileParticle = "particles/roshpit/warlord/fire_ulti_linear.vpcf"
	local start_radius = 0
	local end_radius = 0
	local range = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), targetPosition)
	local speed = 1200
	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,80),
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

	Timers:CreateTimer(range/speed, function()
		EmitSoundOnLocationWithCaster(targetPosition, "Redfall.RocksExplode", Redfall.RedfallMaster)
		local particle = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
		local pfx = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
		local particlePosition = GetGroundPosition(targetPosition, Events.GameMaster)
		ParticleManager:SetParticleControl( pfx, 0, particlePosition )
		ParticleManager:SetParticleControl( pfx, 1, particlePosition )
		ParticleManager:SetParticleControl( pfx, 2, fv )
		Timers:CreateTimer(3.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)		


		local blockers = Entities:FindAllByNameWithin("CanyonCaveBlocker", Vector(-13376, 8630, 128+Redfall.ZFLOAT), 3000)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
		local rocks = Entities:FindAllByNameWithin("CanyonCaveRocks", Vector(-13376, 8630, 128+Redfall.ZFLOAT), 3000)
		for i = 1, #rocks, 1 do
			UTIL_Remove(rocks[i])
		end

	end)
end

function AutmnMistCaveTrigger()
	if Redfall.AutumnMistCavern then
		if not Redfall.spawnPortalStarted then
			Redfall.spawnPortalStarted = true
			Redfall:ActivateSwitchGeneric(Vector(-15119, 10872, Redfall.ZFLOAT), "AutumnMistCaveSwitch", true, 0.3)
			Redfall.spawnPortalTable = {}
			local spawnPositionTable = {Vector(-14729, 10916), Vector(-13820, 10916), Vector(-11921, 9947)}
			Timers:CreateTimer(2, function()
				for i = 1, #spawnPositionTable, 1 do
					local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/spawn_portal_counter.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
					ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i]+Vector(0,0,150+Redfall.ZFLOAT))
					table.insert(Redfall.spawnPortalTable, pfx)
					EmitSoundOnLocationWithCaster(spawnPositionTable[i], "Redfall.CaveUnitPortals", Redfall.RedfallMaster)
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
					Redfall:SpawnCaveWaveUnit("redfall_mist_knight", spawnPositionTable[i], 13, 33, delay, true)
				end
			end)
		end
	end
end

function autumn_mist_cave_die()
	if not Redfall.CaveDungeonTally then
		Redfall.CaveDungeonTally = 0
	end
	Redfall.CaveDungeonTally = Redfall.CaveDungeonTally + 1
	if Redfall.CaveDungeonTally == 36 then
		local spawnPositionTable = {Vector(-14729, 10916), Vector(-13820, 10916), Vector(-11921, 9947)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 2 then
				Redfall:SpawnCaveWaveUnit("redfall_troll_warlord", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 3 then
				Redfall:SpawnCaveWaveUnit("redfall_ashfall_knight", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnCaveWaveUnit("redfall_mist_knight", spawnPositionTable[i], 13, 33, delay, true)
			end

		end
	elseif Redfall.CaveDungeonTally == 74 then
		local spawnPositionTable = {Vector(-14729, 10916), Vector(-13820, 10916), Vector(-11921, 9947)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 1 then
				Redfall:SpawnCaveWaveUnit("redfall_canyon_bull", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 2 then
				Redfall:SpawnCaveWaveUnit("redfall_troll_warlord", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnCaveWaveUnit("redfall_mist_knight", spawnPositionTable[i], 13, 33, delay, true)
			end

		end		
	elseif Redfall.CaveDungeonTally == 112 then
		local spawnPositionTable = {Vector(-14729, 10916), Vector(-13820, 10916), Vector(-11921, 9947)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 1 then
				Redfall:SpawnCaveWaveUnit("redfall_canyon_bull", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 2 then
				Redfall:SpawnCaveWaveUnit("redfall_troll_warlord", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnCaveWaveUnit("redfall_mist_assassin", spawnPositionTable[i], 13, 33, delay, true)
			end
		end	
	elseif Redfall.CaveDungeonTally == 150 then
		local spawnPositionTable = {Vector(-14729, 10916), Vector(-13820, 10916), Vector(-11921, 9947)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 1 then
				Redfall:SpawnCaveWaveUnit("redfall_troll_warlord", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 2 then
				Redfall:SpawnCaveWaveUnit("redfall_mist_knight", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnCaveWaveUnit("redfall_mist_assassin", spawnPositionTable[i], 13, 33, delay, true)
			end
		end	
	elseif Redfall.CaveDungeonTally == 190 then
		local spawnPositionTable = {Vector(-14729, 10916), Vector(-13820, 10916), Vector(-11921, 9947)}
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			if i == 1 then
				Redfall:SpawnCaveWaveUnit("redfall_hooded_soul_reacher", spawnPositionTable[i], 13, 33, delay, true)
			elseif i == 2 then
				Redfall:SpawnCaveWaveUnit("redfall_mist_assassin", spawnPositionTable[i], 13, 33, delay, true)
			else
				Redfall:SpawnCaveWaveUnit("redfall_ashfall_knight", spawnPositionTable[i], 13, 33, delay, true)
			end
		end	
	elseif Redfall.CaveDungeonTally == 228 then
		local boss = Redfall:SpawnAutumnMageBoss(Vector(-13820, 10916), Vector(0,-1))
		EmitSoundOnLocationWithCaster(Vector(-13820, 10916), "Redfall.CaveUnitSpawn", Redfall.RedfallMaster)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", boss, 2)
	end
end



function autumn_mage_attack_hit(event)
	local damage = event.damage
	local target = event.target
	local ability = event.ability
	local attacker = event.attacker
	CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_mage_starfall_attack.vpcf", target, 0.8)
	EmitSoundOn("Redfall.AutumnMage.StarStart", target)
	Timers:CreateTimer(0.6, function()
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_doom_bringer/doom_loadout.vpcf", target, 3)
	    EmitSoundOn("Redfall.FireballPassive", target)
		ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
		ability:ApplyDataDrivenModifier(attacker, target, "modifier_autumn_mage_debuff", {duration = 3})
		
	end)
end

function autumn_mage_blink_start(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/dire_fx/dire_lfr_smoke_19sec.vpcf", caster, 3)

end

function autumn_blink_debuff_end(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Redfall.AutumnMage.Blink", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/boss/pit_lord_strike.vpcf", caster, 3)

	local particleName = "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
    local target = caster:GetAbsOrigin() + RandomVector(RandomInt(560, 1000))
    local casterOrigin = caster:GetAbsOrigin()
    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    -- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
    --     ParticleManager:SetParticleControl( pfx, 0, position )
    local newPosition = target
    FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function autumn_mage_boss_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Redfall.AutumnMageBoss.Die", caster)
	Timers:CreateTimer(3, function()
		local walls = Entities:FindAllByNameWithin("CaveBossWall", Vector(-12459, 11567, 270+Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 4.5)
		Timers:CreateTimer(4.7, function()
			local blockers = Entities:FindAllByNameWithin("CanyonCaveEndBlocker", Vector(-12480, 11529, 104+Redfall.ZFLOAT), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)		
	end)

	local luck = RandomInt(1,4)
	if luck == 1 then
		RPCItems:RollAutumnrockBracers(caster:GetAbsOrigin())
	end
	for i = 1, #Redfall.spawnPortalTable, 1 do
		ParticleManager:DestroyParticle(Redfall.spawnPortalTable[i], false)
	end

	local position = Vector(-14822, 14269, 118+Redfall.ZFLOAT)
	local pfx = ParticleManager:CreateParticle("particles/rain_fx/econ_weather_ash.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
	ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,150))
	local bossTree = Entities:FindByNameNearest("VermillionTreeCorrupted", position, 1200)

	local pfx2 = ParticleManager:CreateParticle("particles/dire_fx/avernus_eye_smoke.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
	ParticleManager:SetParticleControl(pfx2, 0, position)
	Timers:CreateTimer(4.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	Timers:CreateTimer(2.5, function()
		local moveVector = Vector(0,0,700)/180
		for j = 1, 180, 1 do
			Timers:CreateTimer(j*0.03, function()

				bossTree:SetAbsOrigin(bossTree:GetAbsOrigin()+moveVector)
				if j%30 == 0 then
					ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
					EmitSoundOnLocationWithCaster(position, "Redfall.TreeRising", Redfall.RedfallMaster)
					local pfxX = ParticleManager:CreateParticle("particles/dire_fx/dire_lfr_smoke_19sec.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
					ParticleManager:SetParticleControl(pfxX, 0, position)
					Timers:CreateTimer(10, function()
						ParticleManager:DestroyParticle(pfxX, false)
					end)				
				end
				if j == 180 then
					local particle = "particles/roshpit/redfall/tree_healed.vpcf"
					local pfxA = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
					FindClearSpaceForUnit(caster, position, false)
					ParticleManager:SetParticleControl( pfxA, 0, position )
					ParticleManager:SetParticleControl( pfxA, 1, position )
					ParticleManager:SetParticleControl( pfxA, 2, Vector(0,1) )
					Timers:CreateTimer(7.5, function()
						ParticleManager:DestroyParticle(pfxA, false)
					end)			
					Redfall.CanyonLastTreeReady = true
				end
			end)
		end
	end)
end

function autumn_mage_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	if not ability.rotateIndex then
		ability.rotateIndex = 1
	end
	local damage = event.damage
	local length = 2
	if GameState:GetDifficultyFactor() == 2 then
		length = 3
	end
	if GameState:GetDifficultyFactor() == 3 then
		length = 4
	end
	for i = 1, length, 1 do
		local fv = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*ability.rotateIndex/16)
		local position = caster:GetAbsOrigin() + fv*i*280
		autumn_mage_boss_explosion(caster, position, damage, 160, ability)
	end
	ability.rotateIndex = ability.rotateIndex + 1
	if ability.rotateIndex > 16 then
		ability.rotateIndex = 1
	end
end

function autumn_mage_boss_explosion(caster, position, damage, explosionAOE, ability)
		local stun_duration = 1.5


		local particleName = "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( particle1, 0, position )
		ParticleManager:SetParticleControl( particle1, 1, Vector(explosionAOE, 5, explosionAOE*2) )
		Timers:CreateTimer(4, 
		function()
			ParticleManager:DestroyParticle( particle1, false )
		end)	
		EmitSoundOnLocationWithCaster(position, "Redfall.AutumnMage.Quake", caster)

		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
				enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = stun_duration})
			end
		end 
end

function CanyonEndTree(trigger)
	if Redfall.CanyonLastTreeReady then
		if not Redfall.LastCanyonTreeActivated then
			Redfall.LastCanyonTreeActivated = true
			local hero = trigger.activator
			local position = hero:GetAbsOrigin()
			local tree = Entities:FindByNameNearest("VermillionTreeCorrupted", Vector(position.x, position.y, 130+Redfall.ZFLOAT), 1200)
			if tree then
				EndTreeInitiate(tree)
			end
		end
	end
end

function EndTreeInitiate(tree)
	local particleName = "particles/dark_smoke_test.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,tree:GetAbsOrigin())   
    EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Redfall.CorruptedTreeStart", Redfall.RedfallMaster)
	local treeDummy = CreateUnitByName("npc_dummy_unit", tree:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
	treeDummy.cultistsSlain = 0
	treeDummy.cultistsTarget = 15
	treeDummy.tree = tree
	treeDummy:AddAbility("dummy_unit"):SetLevel(1)
	treeDummy.pfx = pfx
	treeDummy.boss = true
	Timers:CreateTimer(3.5, function()
		for i = 1, 20, 1 do
			Timers:CreateTimer(i*0.6, function()
				local cultist = Redfall:SpawnCrimsythCultist(tree:GetAbsOrigin(), Vector(0,-1), tree:GetAbsOrigin())
				cultist.treeDummy = treeDummy
			end)
		end
	end)
	Redfall.CanyonTreeDummy = treeDummy
end

function canyon_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	local timeWalk = caster:FindAbilityByName("canyon_boss_time_walk")
	if timeWalk:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin() + RandomVector(240)
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = timeWalk:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
		end
	end
	if caster:HasAbility("canyon_boss_lightning") then
		print("CAST MJOO!")
		local mjollAbility = caster:FindAbilityByName("canyon_boss_lightning")
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )	
		if #allies > 0 then	
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = allies[1]:entindex(),
			 		AbilityIndex = mjollAbility:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)		
		end
	end
end


function canyon_boss_blink_start(event)
	local caster = event.caster
	local ability = event.ability
	local jumpToPosition = event.target_points[1]
	local boss = caster
	local moveVector = (jumpToPosition - boss:GetAbsOrigin())/25
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_walking", {duration = 2.1})
	StartAnimation(boss, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.5})
	EmitSoundOn("Redfall.CanyonBoss.LeapIntro", boss)
	for i = 1, 33, 1 do
		Timers:CreateTimer(i*0.03, function()
			-- boss:SetModelScale(0.01 + 0.024*i)
			boss:SetAbsOrigin(boss:GetAbsOrigin()+moveVector)
		end)
	end
	Timers:CreateTimer(1.95, function()
		FindClearSpaceForUnit(boss, boss:GetAbsOrigin(), false)
		StartAnimation(boss, {duration=0.27, activity=ACT_DOTA_CAST_ABILITY_1_END, rate=1.0})
	end)


end

function boss_explosion_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.pushVector then
		target.pushVelocity = 32
		local impactPoint = target:GetAbsOrigin()
		local pushVector = ((impactPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		target.pushVector = pushVector
		EmitSoundOn("Redfall.StoneAttack", target)
	end
	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin()+target.pushVector*30)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin()+target.pushVector*30, target)
	local fv = target.pushVector
	if blockUnit then
		fv = 0
	end

	target:SetAbsOrigin(target:GetAbsOrigin() + fv*target.pushVelocity)
	target.pushVelocity = math.max(target.pushVelocity - 1, 0)
end

function boss_explosion_pushback_end(event)
	local caster = event.target
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	caster.pushVector = false
end

function death_check(event)
	local caster = event.caster
	local ability = event.ability
	if caster.deathStart then
	else
		if caster:GetHealth() < 50 then
			caster.deathStart = true
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dying_generic", {duration = 20})
			CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {})
			caster.deathStart = true
			StartAnimation(caster, {duration=7, activity=ACT_DOTA_FLAIL, rate=1})
			if caster:GetUnitName() == "redfall_canyon_boss" then
				CanyonBossDeath(caster, ability)
			elseif caster:GetUnitName() == "redfall_shipyard_boss" then
				Redfall:ShipyardBossDeath(caster, ability)
			end
		end
	end
end

function CanyonBossDeath(caster, ability)
	Statistics.dispatch("redfall_ridge:kill:crimsyth_corruptor");
	Redfall.BossBattle = false
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Redfall.CanyonBoss.DeathNO", caster)
	end)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text="Dungeon Clear!", duration=8.0})
		local luck = RandomInt(1,4)
		if luck == 1 then
			RPCItems:RollEyeOfSeasons(caster:GetAbsOrigin(), false)
		end
	end)
	for i = 1, 14, 1 do
		Timers:CreateTimer(0.5*i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_temple_boss_dying_effect", {})
	local bossOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(8, function()
		caster:RemoveModifierByName("modifier_dying_generic")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_cant_die_disabled", {duration = 20})
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=8, activity=ACT_DOTA_DIE, rate=0.15})
			EmitSoundOn("Redfall.CanyonBoss.Death2", caster)
			-- for i = 1, 120, 1 do
			-- 	Timers:CreateTimer(i*0.05, function()
			-- 		if IsValidEntity(caster) then
			-- 			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-5))
			-- 		end
			-- 	end)
			-- end
			Timers:CreateTimer(5.7, function()
				UTIL_Remove(caster)
				Redfall:DefeatDungeonBoss("canyon", bossOrigin)
			end)
		end)
	end)


	local treeDummy = Redfall.CanyonTreeDummy
	Timers:CreateTimer(8, function()

		local position = treeDummy.tree:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/rain_fx/econ_weather_ash.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,150))
		local healedTree = Entities:FindByNameNearest("VermillionTreeHealed", treeDummy:GetAbsOrigin()-Vector(0,0,700), 1200)

		local pfx2 = ParticleManager:CreateParticle("particles/dire_fx/avernus_eye_smoke.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx2, 0, position)
		Timers:CreateTimer(4.5, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)
		Timers:CreateTimer(2.5, function()
			local moveVector = (position - healedTree:GetAbsOrigin())/180
			for j = 1, 180, 1 do
				Timers:CreateTimer(j*0.03, function()

					healedTree:SetAbsOrigin(healedTree:GetAbsOrigin()+moveVector)
					if j%30 == 0 then
						ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
						EmitSoundOnLocationWithCaster(position, "Redfall.TreeRising", Redfall.RedfallMaster)
						local pfxX = ParticleManager:CreateParticle("particles/dire_fx/dire_lfr_smoke_19sec.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
						ParticleManager:SetParticleControl(pfxX, 0, position)
						Timers:CreateTimer(10, function()
							ParticleManager:DestroyParticle(pfxX, false)
						end)				
					end
					if j == 180 then
						EmitSoundOnLocationWithCaster(position, "Redfall.TreeHealedMain", Events.GameMaster)
						EmitSoundOnLocationWithCaster(position, "Redfall.TreeHealed", Redfall.RedfallMaster)
						local particle = "particles/roshpit/redfall/tree_healed.vpcf"
						local pfxA = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
						FindClearSpaceForUnit(caster, position, false)
						ParticleManager:SetParticleControl( pfxA, 0, position )
						ParticleManager:SetParticleControl( pfxA, 1, position )
						ParticleManager:SetParticleControl( pfxA, 2, Vector(0,1) )
						Timers:CreateTimer(7.5, function()
							ParticleManager:DestroyParticle(pfxA, false)
						end)
						Timers:CreateTimer(1, function()	
							for i = 1, #MAIN_HERO_TABLE, 1 do
								Redfall:GiveVermillionBundle(MAIN_HERO_TABLE[i], position+Vector(0,0,550))
							end
						end)
					end
				end)
			end
		end)
		for k = 1, 100, 1 do
			Timers:CreateTimer(k*0.03, function()
				treeDummy.tree:SetModelScale(1-(k/100))
				if k == 100 then
					UTIL_Remove(treeDummy.tree)
					ParticleManager:DestroyParticle(treeDummy.pfx, false)
					UTIL_Remove(treeDummy)
				end
			end)
		end
	end)
end


function death_animation(keys)
	local caster = keys.caster
    CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/boss_death_ntimage_manavoid_ti_5.vpcf", caster, 3)
    EmitSoundOn("Redfall.CanyonBoss.Dying", caster)

    if caster:GetUnitName() == "redfall_canyon_boss" then
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )	
		if #allies > 0 then	
			for i = 1, #allies, 1 do
				-- ApplyDamage({ victim = enemies[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })	
				ApplyDamage({ victim = allies[i], attacker = caster, damage = allies[i]:GetMaxHealth()*20, damage_type = DAMAGE_TYPE_PURE })	
			end
		end
    end
end

function AsharaShrineTrigger(trigger)
	local hero = trigger.activator
	if Redfall.AsharaPortalActive and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-9762, 15337)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function AsharaExitPortal(trigger)
	local hero = trigger.activator
	if Redfall.AsharaExitPortalActive and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-11535, 5266)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function ashara_explosion_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.pushVector then
		target.pushVelocity = 32
		target.pushVector = Vector(0,-1)
	end
	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin()+target.pushVector*30)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin()+target.pushVector*30, target)
	local fv = target.pushVector
	if blockUnit then
		fv = 0
	end

	target:SetAbsOrigin(GetGroundPosition(target:GetAbsOrigin() + fv*target.pushVelocity, target))
	target.pushVelocity = math.max(target.pushVelocity - 1, 0)
end

function feronia_think(event)
	local caster = event.caster
	local ability = event.ability
	local starstorm = caster:FindAbilityByName("redfall_mirana_starfall")
	if starstorm:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = starstorm:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)	
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_feronia_shield", {duration = 2})	
			return true	
		end
	end	
	local arrow = caster:FindAbilityByName("redfall_mirana_arrow")
	if arrow:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = arrow:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_feronia_shield", {duration = 1.5})		
		end
		return true
	end
end

function feronia_die(event)
	local caster = event.caster
	RPCItems:RollGuardOfFeronia(caster:GetAbsOrigin())
end
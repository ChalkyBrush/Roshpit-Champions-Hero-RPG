function footman_think(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	if position.x < -4320 then
		caster:MoveToPosition(Vector(-3890, 2000+RandomInt(1, 300)))
	end
end

function footman_die(event)
	local caster = event.caster
	local deathPosition = caster:GetAbsOrigin()
	Timers:CreateTimer(3.0, function()
		UTIL_Remove(caster)
	end)

	Timers:CreateTimer(20, function()
		if Dungeons.siegeKills <= 200 then
			local footman = CreateUnitByName("town_footman", Vector(-3681, 2387), true, nil, nil, DOTA_TEAM_GOODGUYS)
			Events:AdjustDeathXP(footman)
			Dungeons:attachWearables(footman, "attach_head", "models/items/omniknight/helmet_crusader.vmdl", 0.95)
			footman:SetForwardVector(Vector(-1, 0))
			table.insert(Dungeons.siegeEntityTable, footman)
			Timers:CreateTimer(0.05, function()
				footman:MoveToPosition(deathPosition)
			end)
		end
	end)

end

function minion_think(event)
	local caster = event.caster
	local ability = event.ability
	local sound = RandomInt(1, 3)
	if sound == 1 then
		EmitSoundOn("Roshan.Grunt", caster)
	end
	local target = caster:GetAttackTarget()
	if target then
		if target:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
			StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_DIE, rate=0.9})
				local info = 
				{
					Target = target,
					Source = caster,
					Ability = ability,	
					EffectName = "particles/base_attacks/ranged_badguy.vpcf",
					StartPosition = "attach_hitloc",
					bDrawsOnMinimap = false, 
				        bDodgeable = true,
				        bIsAttack = false, 
				        bVisibleToEnemies = true,
				        bReplaceExisting = false,
				        flExpireTime = GameRules:GetGameTime() + 5,
					bProvidesVision = true,
					iVisionRadius = 0,
					iMoveSpeed = 400,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				projectile = ProjectileManager:CreateTrackingProjectile(info)		
		end
	end
end

function archer_think(event)
end

function ArcherDie(event)
	local caster = event.caster
	local respawnPosition = caster.spawnPosition
	Timers:CreateTimer(3.0, function()
		UTIL_Remove(caster)
	end)
	Timers:CreateTimer(20, function()
		if Dungeons.siegeKills <= 200 then
			local archer = CreateUnitByName("town_archer", respawnPosition, true, nil, nil, DOTA_TEAM_GOODGUYS)
			Events:AdjustDeathXP(archer)
			archer.spawnPosition = respawnPosition
			archer:SetForwardVector(Vector(-1, 0))
			table.insert(Dungeons.siegeEntityTable, archer)
		end
	end)
end

function minion_die(event)
	local caster = event.caster
	local respawnPosition = caster.respawnLocation
	-- Timers:CreateTimer(3.0, function()
	-- 	UTIL_Remove(caster)
	-- end)
	Timers:CreateTimer(8, function()
		if Dungeons.siegeKills <= 240 and not Dungeons.cleared.townsiege then
			local minion = CreateUnitByName("basic_siege_unit", respawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(minion)
			Events:TownSiegeXP(minion)
			minion.respawnLocation = respawnPosition
			minion:SetForwardVector(Vector(1, 0))
			minion:SetAcquisitionRange(4000)
			minion:MoveToPositionAggressive(Dungeons.commander:GetAbsOrigin())
		end
	end)
	updateSiegeProgress(1)
end

function hulk_think(event)
	local caster = event.caster
	if not caster.levitation then
		caster.levitation = -5
		caster.levitationState = 0
	end
	local levitationVector = caster:GetAbsOrigin()+Vector(0,0,caster.levitation)
	caster:SetAbsOrigin(levitationVector)
	if caster.levitationState == 0 then
		caster.levitation = caster.levitation+1
	else
		caster.levitation = caster.levitation-1
	end
	if caster.levitation > 5 then
		caster.levitationState = 1
	end
	if caster.levitation < -5 then
		caster.levitationState = 0
	end
end

function hulk_die(event)
	local caster = event.caster
	Timers:CreateTimer(15, function()
		if Dungeons.siegeKills <= 200 then
			local hulker = CreateUnitByName("siege_hulker", Vector(-6400, 1252+RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(hulker)
			Events:TownSiegeXP(hulker)
		end
	end)
	updateSiegeProgress(3)
end

function updateSiegeProgress(amount)
	Dungeons.siegeKills = Dungeons.siegeKills + amount

    local threshold1 = 30
    local threshold2 = 50
    local threshold3 = 80
    local threshold4 = 100
    local threshold5 = 130
    local threshold6 = 200
	if Dungeons.siegeStage == 0 then
		if Dungeons.siegeKills > threshold1 then
			spawnCatapult()
			Dungeons.siegeStage = 1
		end
	elseif Dungeons.siegeStage == 1 then
		if Dungeons.siegeKills > threshold2 then
			--print("SPAWN SIEGE HULKER")
			for i = 1, 2, 1 do
				local hulker = CreateUnitByName("siege_hulker", Vector(-6400, 1252+RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(hulker)
				Events:TownSiegeXP(hulker)
			end
			Dungeons.siegeStage = 2
		end
	elseif Dungeons.siegeStage == 2 then
		if Dungeons.siegeKills > threshold3 then
			for i = 1, 3, 1 do
				local unit = CreateUnitByName("siege_dragon", Vector(-6400, 1252+RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(unit)
				Events:TownSiegeXP(unit)
				unit:MoveToPosition(Dungeons.commander:GetAbsOrigin())
			end
			Dungeons.siegeStage = 3
		end
	elseif Dungeons.siegeStage == 3 then
		if Dungeons.siegeKills > threshold4 then
			local unit = CreateUnitByName("siege_dragon", Vector(-6400, 1252+RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			Events:TownSiegeXP(unit)
			unit:MoveToPosition(Dungeons.commander:GetAbsOrigin())
			Dungeons.siegeStage = 4
			spawnCatapult()
		end		
	elseif Dungeons.siegeStage == 4 then
		if Dungeons.siegeKills > threshold5 then
			local unit = CreateUnitByName("siege_dragon", Vector(-6400, 1252+RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			Events:TownSiegeXP(unit)
			unit:MoveToPosition(Dungeons.commander:GetAbsOrigin())
			for i = 1, 4, 1 do
				local hulker = CreateUnitByName("siege_hulker", Vector(-6400, 1252+RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(hulker)
				Events:TownSiegeXP(hulker)
			end
			Dungeons.siegeStage = 5
		end		
	elseif Dungeons.siegeStage == 5 then
		if Dungeons.siegeKills > threshold6 then
			Dungeons.chieftain:RemoveModifierByName("modifier_chieftain_state_one")
			Dungeons.chieftain:MoveToPositionAggressive(Dungeons.commander:GetAbsOrigin())
			Dungeons.chieftain:SetAcquisitionRange(6000)
			CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = Dungeons.chieftain:GetUnitName(), bossMaxHealth = Dungeons.chieftain:GetMaxHealth()})
			EmitGlobalSound("chaos_knight_chaknight_spawn_03")
			EmitGlobalSound("chaos_knight_chaknight_spawn_03")
			EmitGlobalSound("chaos_knight_chaknight_spawn_03")
			Dungeons.siegeStage = 6
			EmitGlobalSound("Tutorial.Quest.complete_01")
			Dungeons.chieftain:SetBaseHealthRegen(0)
			Timers:CreateTimer(1, 			function()

			end)
		end	
	-- elseif Dungeons.siegeStage == 6 then
	-- 	local soundTable = {"chaos_knight_chaknight_spawn_03", "chaos_knight_chaknight_spawn_05", "chaos_knight_chaknight_spawn_07"}
	-- 	EmitGlobalSound(soundTable[RandomInt(1,3)])
	end
			
end

function spawnCatapult()
	local catapult = CreateUnitByName("siege_catapult", Vector(-6400, 1252+RandomInt(1, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Timers:CreateTimer(0.05, function()
		catapult:MoveToPosition(catapult:GetAbsOrigin()+Vector(300,0))
		Timers:CreateTimer(2.5, function()
			catapult:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		end)
	end)
end

function cannonball_think(event)
	local caster = event.target
	local ability = event.ability
	local fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/9)
	caster:SetForwardVector(fv)
end

function catapult_think(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_ATTACK, rate=0.7})
	Timers:CreateTimer(0.9, function()
		local catapultProjectile = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin()+Vector(0,0,90)+caster:GetForwardVector()*-50, true, nil, nil, DOTA_TEAM_NEUTRALS)
		catapultProjectile.jumpEnd = "catapult"
		catapultProjectile:AddAbility("dummy_unit"):SetLevel(1)
		catapultProjectile:SetModel("models/heroes/phoenix/phoenix_egg.vmdl")
		catapultProjectile:SetOriginalModel("models/heroes/phoenix/phoenix_egg.vmdl")
		catapultProjectile:SetModelScale(0.9)
		ability:ApplyDataDrivenModifier(caster, catapultProjectile, "modifier_catapult_projectile", {})
		local negativeFactor = RandomInt(0,1)
		if negativeFactor == 0 then
			negativeFactor = -1
		end
		local fv = WallPhysics:rotateVector(Vector(1,0.3), math.pi/RandomInt(12, 20)*negativeFactor)
		WallPhysics:Jump(catapultProjectile, fv, 25+RandomInt(0,15), 40, 40, 1)
	end)
end

function dragon_think(event)
	local caster = event.target
	if not caster.interval then
		caster.interval = 0
	end
	if not caster.enemyPosition then
		caster.enemyPosition = caster:GetAbsOrigin()
	end

	-- local fv = Vector(0,0)
	if caster.interval == 35 or caster.interval == 105 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )
		if #enemies > 0 then
			caster.enemyPosition = enemies[1]:GetAbsOrigin()
			caster:MoveToPosition(caster.enemyPosition+RandomVector(600))
		else
			caster.enemyPosition = Dungeons.commander:GetAbsOrigin()
			caster:MoveToPosition(caster.enemyPosition+RandomVector(600))			
		end
	end
		local negativeFactor = RandomInt(0,1)
		if negativeFactor == 0 then
			negativeFactor = -1
		end
		caster.fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/RandomInt(6, 9)*negativeFactor)
	caster.enemyPosition = caster.enemyPosition+caster.fv*10
	caster:MoveToPosition(caster.enemyPosition)
	local fv = caster:GetForwardVector()
	local newPos = caster:GetAbsOrigin()+caster.fv*20
	-- caster:SetAbsOrigin(newPos)
	caster.interval = caster.interval + 1
	if caster.interval > 140 then
		local ability = event.ability
		local start_radius = 180
		local end_radius = 400
		local range = 600
		local speed = 500
		local info = 
		{
				Ability = ability,
	        	EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
	        	vSpawnOrigin = newPos+fv*150,
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
		caster.interval = 0
		StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.1})
		EmitSoundOn("Hero_Jakiro.DualBreath", caster)
	end
end



function dragon_die(event)
	Timers:CreateTimer(20, function()
		if Dungeons.siegeKills <= 200 then	
			local unit = CreateUnitByName("siege_dragon", Vector(-6400, 1252+RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(unit)
			Events:TownSiegeXP(unit)
			unit:MoveToPosition(Dungeons.commander:GetAbsOrigin())
		end
	end)
	updateSiegeProgress(3)
end

function abil_jump_end(event)

end

function catapult_die(event)
	updateSiegeProgress(4)
end

function leaping_lion_think(event)
	local caster = event.caster
	local ability =event.ability
	local position = caster:GetAbsOrigin()
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if position.x > -5696 and position.x < -5100 then
		local negativeFactor = RandomInt(0,1)
		if negativeFactor == 0 then
			negativeFactor = -1
		end
		local fv = WallPhysics:rotateVector(Vector(1,0), math.pi/RandomInt(9, 20)*negativeFactor)
		WallPhysics:Jump(caster, fv, 20, 30, 20, 1)
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_CAST_ABILITY_3, rate=2.5, translate="demon_drain"})
		caster.interval = 0
	end
	if position.x > -4480 and position.x < -4213 then
		local fv = Vector(0,0)
		if position.y > 2065 then
			fv = Vector(1, 1.1)
		else
			fv = Vector(1, -0.6)
		end
		WallPhysics:Jump(caster, fv, 13, 45, 30, 1)
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_CAST_ABILITY_3, rate=2.5, translate="demon_drain"})
		caster.interval = 0
	end
	if caster.interval == 6 then
		caster.interval = 0
		WallPhysics:Jump(caster, caster:GetForwardVector(), 5, 45, 20, 1)
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_CAST_ABILITY_3, rate=2.5, translate="demon_drain"})
	end
	
end

function leaping_lion_die(event)
	local caster = event.caster
	-- Timers:CreateTimer(3.0, function()
	-- 	UTIL_Remove(caster)
	-- end)
	Timers:CreateTimer(12, function()
		if Dungeons.siegeKills <= 200 then
			local lion = CreateUnitByName("leaping_lion", Vector(-6400, 1252+RandomInt(1, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			Events:AdjustDeathXP(lion)
			Events:TownSiegeXP(lion)
		end
	end)
	updateSiegeProgress(2)
end

function garrison_commander_think(event)
	local caster = event.caster
	local ability = event.ability
	Dungeons.commander.speech = false
	local healthThreshold = 4000 + (GameState:GetDifficultyFactor()-1)*50000
	if caster:GetHealth() < healthThreshold then
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
		caster:Heal(healthThreshold, caster)
		PopupHealing(caster, healthThreshold)
		EmitSoundOn("Hero_Omniknight.Purification", caster)
		local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		Timers:CreateTimer(1.0, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
	end
	local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_HERO
    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	local teamMates = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, target_teams, DOTA_UNIT_TARGET_BASIC, target_flags, FIND_ANY_ORDER, false)
	if #teamMates < 5 then
		caster:MoveToPosition(Vector(-3202, 2624))
	end
	if #units > 0 then
		for _,unit in pairs(units) do
			if unit:GetHealth() < unit:GetMaxHealth()*0.45 then
				StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
				unit:Heal(healthThreshold, caster)
				PopupHealing(unit, healthThreshold)
				EmitSoundOn("Hero_Omniknig ht.Purification", unit)
				local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal.vpcf"
				local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, unit )
				ParticleManager:SetParticleControlEnt(pfx2, 0, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				Timers:CreateTimer(1.0, function() 
				  ParticleManager:DestroyParticle( pfx2, false )
				end) 
			    Dungeons.commander:DestroyAllSpeechBubbles()
			    local time = 4
			    local speechSlot = 1
			    local dialogue = {"#town_siege_commander_heal", "#town_siege_commander_heal_two"}
			    if not Dungeons.commander.speech then
			    	Dungeons.commander:AddSpeechBubble(speechSlot, dialogue[RandomInt(1,2)], time, 0, 0)
			    	Dungeons.commander.speech = true
				end
				break
			end
			if Dungeons.cleared.townsiege then
				if not unit.badge and unit:HasAnyAvailableInventorySpace() and unit:IsHero() then
					unit.badge = true
					RPCItems:RollBadgeOfHonor(unit)
				    Dungeons.commander:DestroyAllSpeechBubbles()
				    local time = 6
				    local speechSlot = 1
				    local dialogue = "#town_siege_commander_victory"
				    if not Dungeons.commander.speech then
				    	Dungeons.commander:AddSpeechBubble(speechSlot, dialogue, time, 0, 0)
				    	Dungeons.commander.speech = true
					end
				end
			end
		end
	end
end

function chieftain_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_chieftain_state_one") then
		if not caster.interval then
			caster.interval = 0
			caster.state = 0
		end
		caster.interval = caster.interval + 1
		if caster.interval == 6 then
			caster.interval = 0
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chieftain_buff", {duration = 8})
			StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.1})
		end
		if caster:GetHealth() < caster:GetMaxHealth()*0.5 and caster.state == 0 then
		    Dungeons.commander:DestroyAllSpeechBubbles()
		    local time = 5
		    local speechSlot = 1		
		    if not Dungeons.commander.speech then	    
		    	Dungeons.commander:AddSpeechBubble(speechSlot, "#town_siege_commander_boss_fight", time, 0, 0)
			end
			caster.state = 1
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chieftain_roar", {duration = 1.5})
			StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_ATTACK_EVENT, rate=0.8})
			local fv = caster:GetForwardVector()
			for i = -6, 6, 1 do
				Timers:CreateTimer(0.2*(i+7), function()
					local spawnPosition = caster:GetAbsOrigin() + WallPhysics:rotateVector(fv, math.pi/6*i)*300
					local minion = CreateUnitByName("basic_siege_unit", spawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
					Events:AdjustDeathXP(minion)
					Events:TownSiegeXP(minion)
					minion:SetAcquisitionRange(4000)	
					ability:ApplyDataDrivenModifier(caster, minion, "modifier_chieftain_buff", {duration = 10})
				end)
			end
		end
	end

		
end

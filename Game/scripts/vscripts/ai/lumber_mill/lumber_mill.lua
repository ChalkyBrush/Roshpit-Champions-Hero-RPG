function brute_wind_up(event)
	local caster = event.caster
	StartAnimation(caster, {duration=2.1, activity=ACT_DOTA_CAST_ABILITY_2, rate=1})
end

function die_after_time(event)
	local caster = event.caster
	Timers:CreateTimer(60, function()
		if not caster:IsNull() then
			if caster:IsAlive() then
				caster:ForceKill(false)
			end
		end
	end)
end

function die_after_time_twenty(event)
	local caster = event.caster
	Timers:CreateTimer(20, function()
		if not caster:IsNull() then
			if caster:IsAlive() then
				caster:ForceKill(false)
			end
		end
	end)
end

function die_after_time_died(event)
	local caster = event.caster
	if caster.summonAbility then
		caster.summonAbility.skeletonLimit = caster.summonAbility.skeletonLimit - 1
	end
	Timers:CreateTimer(5, function()
		UTIL_Remove(caster)
	end)	
end

function slam(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 220
	EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", caster)
		local particleName =  "particles/units/heroes/hero_elder_titan/doomguard_leap_effect.vpcf"
		local position = caster:GetAbsOrigin()+caster:GetForwardVector()*200
		local particleVector = position

		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
		ParticleManager:SetParticleControl( pfx, 1, particleVector )
		ParticleManager:SetParticleControl( pfx, 2, particleVector )
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)  
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local damage = Events:GetAdjustedAbilityDamage(3500, 300000, 500000)
			for _,enemy in pairs(enemies) do

				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR })
				enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.8})
			end
		end
		GridNav:DestroyTreesAroundPoint(position, 200, false)

end

function chopThink(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.aggro then
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_ATTACK, rate=1, translate="melee"})
		Timers:CreateTimer(0.2, function()
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "ui.inv_drop_wood", caster)
		end)
	end
end


function berserker_wind_up(event)
	local caster = event.caster
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_FLAIL, rate=0.4})
	EmitSoundOn("GazbinBerserker.WindUp", caster)
	Timers:CreateTimer(0.9, function()
		event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_gazbin_berserker_buff", {duration = 6})	
	end)
end

function begin_shredder_madness(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	local soundTable = {"shredder_timb_whirlingdeath_01", "shredder_timb_whirlingdeath_02", "shredder_timb_whirlingdeath_03", "shredder_timb_whirlingdeath_04"}
	EmitSoundOn(soundTable[RandomInt(1, 4)], caster)
	fire_chakram(caster, ability, fv)
	fire_chakram(caster, ability, WallPhysics:rotateVector(fv, math.pi/7))
	fire_chakram(caster, ability, WallPhysics:rotateVector(fv, -math.pi/7))
	if caster:GetHealth() < caster:GetMaxHealth()/2 then
		fire_chakram(caster, ability, WallPhysics:rotateVector(fv, math.pi/4))
		fire_chakram(caster, ability, WallPhysics:rotateVector(fv, -math.pi/4))
		fire_chakram(caster, ability, WallPhysics:rotateVector(-fv, math.pi/7))
		fire_chakram(caster, ability, WallPhysics:rotateVector(-fv, -math.pi/7))
	end
	

end


function fire_chakram(caster, ability, fv)
	local spellOrigin = caster:GetAbsOrigin()
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/units/heroes/hero_shredder/shredder_chakram.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = 1400,
        	fStartRadius = 240,
        	fEndRadius = 240,
        	Source = caster,
        	StartPosition = "attach_attack1",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * 700,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	Timers:CreateTimer(2, function()
		ability:ApplyDataDrivenThinker(caster, spellOrigin+fv*1400, "shredder_max_thinker", {duration = 6})
	end)
end

function shredder_madness_strike(event)
	local caster = event.caster
	local target = event.target
	local damage = Events:GetAdjustedAbilityDamage(600, 45000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })

end

function madnessDOT(event)
	local caster = event.caster
	local target = event.target
	local damage = Events:GetAdjustedAbilityDamage(100, 15000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
end

function shredder_max_death(event)
	local caster = event.caster
	EmitSoundOn("shredder_timb_death_01", caster)
	Dungeons.shredder = false
end

function assaultUnitDie(event)
	local caster = event.caster
	if Dungeons.millAssault then
		if caster:GetUnitName() == "mill_warrior" then
			Timers:CreateTimer(8, function()
			  	local millWarrior = CreateUnitByName("mill_warrior", Vector(-10176, -9216), true, nil, nil, DOTA_TEAM_GOODGUYS)
			  	Events:AdjustDeathXP(millWarrior)
			  	Timers:CreateTimer(0.2, function()
			  		millWarrior:MoveToPositionAggressive(Vector(-12672, -7488))			
			  	end)
			end)
		elseif caster.assault then
			local unitname = caster:GetUnitName()
			Dungeons.assaultKills = Dungeons.assaultKills+1
	        -- GameRules.millQuest:SetTextReplaceValue(QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, Dungeons.assaultKills+1)
	        -- GameRules.subMillQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, Dungeons.assaultKills+1 )
	        Timers:CreateTimer(4, function()
	        	spawnAssaultUnit(unitname)
	        end)
	          if Dungeons.assaultKills == 120 then
	              EmitGlobalSound("Tutorial.Quest.complete_01")
	              Timers:CreateTimer(1, -- Start this timer 10 game-time seconds later
	              function()
	                -- GameRules.millQuest:CompleteQuest()
	              end)
	              Dungeons.millAssault = false	
	              Timers:CreateTimer(3, function()
	              	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-14272, -7360), 500, 10, false)	
	              	local bat = Events:SpawnBoss("lumber_mill_boss", Vector(-14272, -7360))
	              	EmitSoundOn("batrider_bat_respawn_13", bat)
	              	EmitSoundOn("batrider_bat_respawn_13", bat)
	              	EmitSoundOn("batrider_bat_respawn_13", bat)
	              	EmitSoundOn("batrider_bat_respawn_13", bat)
	              	Events:AdjustBossPower(bat, 4, 2, true)
					for i = 1, #MAIN_HERO_TABLE, 1 do
						local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
						if playerID then
							--PlayerResource:SetCameraTarget(playerID, bat)
							-- Timers:CreateTimer(1.5, function()
							-- 	PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
							-- 	PlayerResource:SetCameraTarget(playerID, nil)
							-- end)
						end

					end	
	              end)
              end
		end
	end
end

function spawnAssaultUnit(unitname)
	if Dungeons.millAssault then
	  local unit = CreateUnitByName(unitname, Vector(-13312, -7488), true, nil, nil, DOTA_TEAM_NEUTRALS)
	  Events:AdjustDeathXP(unit)
	  unit:AddAbility("assault_abilities"):SetLevel(1)
	  unit.assault = true
	  Timers:CreateTimer(0.2, function()
	  	unit:SetAcquisitionRange(5000)
	  end)
	end
end

function batriderThink(event)
	
	-- local lookOutBelow = "batrider_bat_ability_napalm_03"
	local soundTable = {"batrider_bat_laugh_01", "batrider_bat_laugh_02", "batrider_bat_laugh_03", "batrider_bat_laugh_04"}
	local caster = event.caster
	if not caster.dying then
		local ability = event.ability
		local position = caster:GetAbsOrigin()
		local radius = 600
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			EmitSoundOn(soundTable[RandomInt(1,4)], caster)
			StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
			for _,enemy in pairs(enemies) do
				createExplosiveProjectile(caster, enemy, ability)
			end
			-- for i = 0, 3, 1 do 
			-- 	local mine = CreateUnitByName("explosive_mine", position+RandomVector(RandomInt(0, 920)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			-- 	mineAbility = mine:FindAbilityByName("mine_explode")
			-- 	mineAbility:SetLevel(1)
			-- 	mineAbility:ApplyDataDrivenModifier(mine, mine, "modifier_explode", {})
			-- 	EmitSoundOn("Hero_Techies.RemoteMine.Plant", mine)
			-- end
		end	
	end
end

function createExplosiveProjectile(caster, target, ability)

	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_techies/techies_base_attack.vpcf",
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false, 
	        bDodgeable = true,
	        bIsAttack = false, 
	        bVisibleToEnemies = true,
	        bReplaceExisting = false,
	        flExpireTime = GameRules:GetGameTime() + 7,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 860,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function tryingToAttack(event)
	local attacker = event.attacker
	attacker:MoveToPosition(attacker:GetAbsOrigin()+attacker:GetForwardVector()*300)
end

function batriderMovement(event)	
	local caster = event.caster
	if not caster.dying then
		local radius = 1600
		local position = caster:GetAbsOrigin()
		AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 400, 2, false)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )
		if #enemies > 0 then
			local enemyPosition = enemies[1]:GetAbsOrigin()
			caster:MoveToPosition(enemyPosition+RandomVector(200))
			local ability = caster:FindAbilityByName("batrider_sticky_napalm")
			if ability:GetCooldownTimeRemaining()  == 0 then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = enemyPosition,
					Queue = false
				}
				ExecuteOrderFromTable(order)
			end

		end
	end
end

function mineExplode(event)
	Timers:CreateTimer(1, function()
		UTIL_Remove(event.caster)
	end)
end

function batrider_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local damage = Events:GetAdjustedAbilityDamage(700, 3000, 4000)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end
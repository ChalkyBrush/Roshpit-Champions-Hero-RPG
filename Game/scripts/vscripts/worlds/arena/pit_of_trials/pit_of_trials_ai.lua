function PitTerminal(trigger)
	local hero = trigger.activator
	if hero.pit then
		-- if hero.pit.pit_open_time then
			-- local lockoutStatus = getLockoutStatus(os:TimeStamp(hero.pit.pit_open_time), os:ServerTimeToTable())
			--DeepPrintTable(os:TimeStamp(hero.pit.pit_open_time))
			--DeepPrintTable(os:ServerTimeToTable())
			--print(lockoutStatus)
			hero.pit.pit_level = 7
			lockoutStatus = 0--removed cd check
			if Arena.PitActive or Arena.PitLocked then
				lockoutStatus = 2
			end
			CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "pit_terminal", {pitData=hero.pit, heroName=hero:GetUnitName(), lockoutStatus = lockoutStatus})
		-- end
	end
end

function generic_pit_enemy_die(event)
	local premiumCount = GameState:GetPlayerPremiumStatusCount()
	local luck = RandomInt(1,7000-(1000*premiumCount))
	if luck == 1 then
		--no difinition for *hero*
		--Arena:RollPitPrizebox(event.unit:GetAbsOrigin())
	end
	local luck2 = RandomInt(1, 3000-(500*premiumCount))
	if luck2 == 1 then
		RPCItems:RollSacredTrialsArmor(event.unit:GetAbsOrigin()) 
	end
	local paragonAdjust = 0
	if event.unit.paragon then
		paragonAdjust = 1500
	end
	local maxBound = math.max(2400-(200*premiumCount)-paragonAdjust, 10)
	local luck3 = RandomInt(1, maxBound)
	if luck3 == 1 then
		Weapons:RollRandomLegendWeapon1(event.unit:GetAbsOrigin())
	end
end

function getLockoutStatus(pitOpenTime, actualTime)
	local lockout = 0
	if actualTime.day == pitOpenTime.day then
		if actualTime.month == pitOpenTime.month then
			if actualTime.year == pitOpenTime.year then
				lockout = 1
			end
		end
	end
	return lockout
end

function LeftLeaderboardExit(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
end

function PitSwitchTriggerA1(trigger)
	changeSwitchColor(1)
end

function PitSwitchTriggerA2(trigger)
	changeSwitchColor(2)
end

function PitSwitchTriggerA3(trigger)
	changeSwitchColor(3)
end

function PitSwitchTriggerA4(trigger)
	changeSwitchColor(4)
end

function PitSwitchTriggerB1(trigger)
	changeSwitchColor(5)
end

function PitSwitchTriggerB2(trigger)
	changeSwitchColor(6)
end

function PitSwitchTriggerB3(trigger)
	changeSwitchColor(7)
end

function PitSwitchTriggerB4(trigger)
	changeSwitchColor(8)
end

function PitSwitchTriggerC1(trigger)
	changeSwitchColor(9)
end

function PitSwitchTriggerC2(trigger)
	changeSwitchColor(10)
end

function PitSwitchTriggerC3(trigger)
	changeSwitchColor(11)
end

function PitSwitchTriggerC4(trigger)
	changeSwitchColor(12)
end

function PitSwitchTriggerD1(trigger)
	changeSwitchColor(13)
end

function PitSwitchTriggerD2(trigger)
	changeSwitchColor(14)
end

function PitSwitchTriggerD3(trigger)
	changeSwitchColor(15)
end

function PitSwitchTriggerD4(trigger)
	changeSwitchColor(16)
end

function PitSwitchTriggerE1(trigger)
	changeSwitchColor(17)
end

function PitSwitchTriggerE2(trigger)
	changeSwitchColor(18)
end

function PitSwitchTriggerE3(trigger)
	changeSwitchColor(19)
end

function PitSwitchTriggerE4(trigger)
	changeSwitchColor(20)
end


function changeSwitchColor(switchIndex)
	if Arena.PitSwitchLock then
		return false
	end
	local color = Arena.PitSwitchColorTable[switchIndex]
	local switch = Arena.PitSwitchTable[switchIndex]
	local newColor = ""
	if color == "red" then
		newColor = "blue"
		Arena.PitSwitchColorTable[switchIndex] = newColor
		Arena:SetSwitchColor(switch, newColor)
	elseif color == "blue" then
		newColor = "yellow"
		Arena.PitSwitchColorTable[switchIndex] = newColor
		Arena:SetSwitchColor(switch, newColor)
	elseif color == "yellow" then
		newColor = "red"
		Arena.PitSwitchColorTable[switchIndex] = newColor
		Arena:SetSwitchColor(switch, newColor)
	end
	EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Arena.PitOfTrials.SwitchChange", Arena.ArenaMaster)
	checkSwitchCondition(newColor)
end

function checkSwitchCondition(color)
	local allMatch = true
	for i = 1, #Arena.PitSwitchColorTable, 1 do
		if Arena.PitSwitchColorTable[i] == color then
		else
			allMatch = false
			break
		end
	end
	if allMatch then
		Arena.PitColor = color
		Arena.PitSwitchLock = true
		EmitGlobalSound("Arena.PitOfTrials.Puzzle1Complete")
		Timers:CreateTimer(3, function()
			local wall = Entities:FindByNameNearest("PitOfTrialsWall1", Vector(-8576, 7680, -900), 300)
			Arena:PitWall(false, {wall}, true, 5.5)
			Timers:CreateTimer(4.5, function()
				local blockers = Entities:FindAllByNameWithin("PitOfTrialsBlocker1", Vector(-8589, 7680), 3000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
		end)
	end
end

function PitOfTrialsRoom1(trigger)
	Arena:SpawnRoom1()
end

function pit_crawler_climb_think(event)
	local caster = event.caster
	local ability = event.ability

	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,8))
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin()+caster:GetForwardVector()*100, caster) > 10 then
		caster:RemoveModifierByName("modifier_arena_pit_crawler_enter")
		caster:SetAngles(0, 0, 0)
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end
end

function gladiator_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not Arena then
		return
	end
	if not Arena.spawnGhouls then
		Arena.spawnGhouls = true
		Arena:SpawnGhouls()
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_champion_gladiator_passive_stacking", {duration = 5})
	local newStacks = caster:GetModifierStackCount("modifier_champion_gladiator_passive_stacking", caster) + 1
	caster:SetModifierStackCount("modifier_champion_gladiator_passive_stacking", caster, newStacks)
	caster:CalculateAndSaveRoshpitAttributes()
end

function gladiator_die(event)
	local unit = event.unit
	if Arena and unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		Arena:SpawnRoom2()
	end
end

function pit_quizmaster_blast_start(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.QuizMaster.SpellCast", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf", caster, 2)
	for i = -4, 4, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), (2*math.pi/9)*i)
			local speed = 600
			local info = 
			{
					Ability = ability,
		        	EffectName = "particles/units/heroes/hero_lina/rekkin_spell.vpcf",
		        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,80),
		        	fDistance = 1200,
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
end

function pit_quizmaster_impact(event)
	local target = event.target
	--print("IMPACT!?")
	local particleName = "particles/econ/events/ti4/dagon_ti4.vpcf"
	EmitSoundOn("Arena.QuizMaster.SpellImpact", target)
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(1.0, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
	
end

function soul_revenant_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				local damage = enemy:GetMaxHealth()*0.01
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })	
				local particleName = "particles/econ/events/ti4/dagon_ti4.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin()+Vector(0,0,80), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT, "attach_hitloc", enemy:GetAbsOrigin()+Vector(0,0,80), true)
				Timers:CreateTimer(2.0, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				end) 		
			end
		end 
	end
end

function mire_keeper_passive_damage(event)
	local caster = event.caster
	local modifier = caster:FindModifierByName("modifier_mire_keeper_passive_effect")
	if modifier then
		modifier:IncrementStackCount()
	end
end

function mountain_crush_cast(event)
	local caster = event.caster
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_flash_b_gravelmaw.vpcf", caster, 1)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
	ability.acceleration = 30
	ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
	ability.target = target
	StartAnimation(caster, {duration=2, activity=ACT_DOTA_OVERRIDE_ABILITY_2, rate=1.0})
end

function mountain_crush_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	local acceleration = ability.acceleration
	ability.acceleration = ability.acceleration - 1.5
	local directionVector = ability.directionVector
	caster:SetAbsOrigin(caster:GetAbsOrigin()+directionVector*(ability.distance/30)+Vector(0,0,ability.acceleration))
	if ability.acceleration <= 0 then
		if GetGroundHeight(caster:GetAbsOrigin(), caster) > (caster:GetAbsOrigin().z - 10) then
			caster:RemoveModifierByName("modifier_mountain_crush_jumping")
		end
	end
end

function mountain_crush_end(event)
	local caster = event.caster
	local radius = 320
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	EmitSoundOn("Arena.MountainBehemoth.Quake", caster)
	FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = 450000, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
		end
	end 	
end

function arena_root_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		if caster:HasModifier("modifier_arena_root_overgrowth_submerged") then
			caster:RemoveModifierByName("modifier_arena_root_overgrowth_submerged")
			--print("RISE!")
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
			for i = 1, 13, 1 do
				Timers:CreateTimer(0.03*i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,18))
				end)
			end
			Timers:CreateTimer(0.18, function()
		      particleName = "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin()+Vector(0,0,100) )
		      EmitSoundOn("Arena.RootOvergrowth.Movement", caster)
		      Timers:CreateTimer(2, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)
			end)
		end
	else
		if not caster:HasModifier("modifier_arena_root_overgrowth_submerged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_arena_root_overgrowth_submerged", {})
			caster:RemoveModifierByName("modifier_beast_fighting")
			--print("FALL!")
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_IDLE, rate=1}) 
			for i = 1, 13, 1 do
				Timers:CreateTimer(0.03*i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,18))
				end)
				Timers:CreateTimer(0.18, function()
			      particleName = "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf"
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
			      EmitSoundOn("Arena.RootOvergrowth.Movement", caster)
			      Timers:CreateTimer(2, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)
				end)
			end
		end
	end
end

function arena_hand_animate(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_DIE, rate=0.8})
end

function ConquestBirdTrigger()
	local bird = Arena.StaffBird
	if bird then
		if not Arena.FirstBirdTriggered then
			Arena.FirstBirdTriggered = true
			EmitSoundOn("Arena.Bird.Squawk", bird)
			Timers:CreateTimer(1, function()
			StartAnimation(bird, {duration=3, activity=ACT_DOTA_STARTLE, rate=1.0})
			
				Timers:CreateTimer(3, function()
					local flyToPosition = Vector(-8907, 13922, 866)
					local currentPosition = bird:GetAbsOrigin()
					local flightPath = flyToPosition - currentPosition
					bird:SetForwardVector(flightPath*Vector(1,1,0):Normalized())
					StartAnimation(bird, {duration=6.3, activity=ACT_DOTA_RUN, rate=1.0})
					for i = 1, 210, 1 do
						Timers:CreateTimer(i*0.03, function()
							bird:SetAbsOrigin(currentPosition+((flightPath/210)*i))
						end)
					end
					Timers:CreateTimer(6.4, function()
						StartAnimation(bird, {duration=1.8, activity=ACT_DOTA_ROQUELAIRE_LAND, rate=1.0})
						bird:SetForwardVector(Vector(1,0))
						Timers:CreateTimer(1.9, function()
							StartAnimation(bird, {duration=99999, activity=ACT_DOTA_ROQUELAIRE_LAND_IDLE, rate=1.0})
						end)
						local staff = Entities:FindByNameNearest("conquest_staff", Vector(-8871, 13917, 370), 800)
						for j = 1, 80, 1 do
							Timers:CreateTimer(j*0.03, function()
								staff:SetRenderColor(40+(j*2.5), 40+(j*2.5), 40+(j*2.5))
							end)
						end
						Timers:CreateTimer(4.4, function()
							Events:CreateCollectionBeam(Vector(-8907, 13922, 766), Vector(-8640, 14336, 456))
							EmitSoundOnLocationWithCaster(Vector(-8640, 14336, 256), "Arena.StaffBeam", Arena.ArenaMaster)
							local mountainSpirit = CreateUnitByName("arena_cliff_spirit", Vector(-8567, 14144, 0), false, nil, nil, DOTA_TEAM_NEUTRALS)
							mountainSpirit.dummy = true
							mountainSpirit:SetForwardVector(Vector(-0.5, 1))
							Timers:CreateTimer(0.1, function()
								StartAnimation(mountainSpirit, {duration=2, activity=ACT_DOTA_ANCESTRAL_SPIRIT, rate=1.0})
							end)
							Timers:CreateTimer(1.4, function()
								mountainSpirit:MoveToPosition(Vector(-9536, 15488))
							end)
							Arena:AddPatrolArguments(mountainSpirit, 0, 4, 20, {mountainSpirit:GetAbsOrigin(), Vector(-9536, 15488)})
							mountainSpirit:AddAbility("arena_mountain_spirit_ai"):SetLevel(1)
							CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", mountainSpirit, 2)
							EmitSoundOn("Arena.SpiritSPawn", mountainSpirit)
							Arena:SpawnConquestPart2()
						end)
					end)
				end)
			end)
		end
	end
end

function mountain_spirit_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies> 0 then
		for i = 1, #enemies, 1 do
			if not enemies[i]:HasModifier("modifier_mountain_spirit_transfer") and not enemies[i]:HasModifier("modifier_mountain_spirit_transfer_immunity") then
				ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_mountain_spirit_transfer", {duration = 25})
			end
		end
	end
end

function mountain_spirit_taxi_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,100)+caster:GetForwardVector()*100)
	local modifier = target:FindModifierByName("modifier_mountain_spirit_transfer")
	if modifier then
		if modifier:GetElapsedTime() > 5.4 then
			local distance1 = WallPhysics:GetDistance(caster.patrolPositionTable[1]*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
			local distance2 = WallPhysics:GetDistance(caster.patrolPositionTable[2]*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
			if distance1 < 60 or distance2 < 60 then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_mountain_spirit_transfer_immunity", {duration = 3})
				FindClearSpaceForUnit(target, target:GetAbsOrigin()+caster:GetForwardVector()*100, false)
				target:RemoveModifierByName("modifier_mountain_spirit_transfer")
			end
		end
	end
end

function SpiderCliffTrigger()
	Arena:SpawnConquestSpiders()
end

function karzhun_shield_take_damage(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local damagePercent = event.damage_percent
	if not caster.disableShield then
		caster.disableShield = true
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
		local baseLightningPos = caster:GetAbsOrigin()+RandomVector(170)+Vector(0,0,100)
		local damage = attacker:GetMaxHealth()*damagePercent/100
		Events:CreateLightningBeam(baseLightningPos, attacker:GetAbsOrigin()+Vector(0,0,70))
		ApplyDamage({ victim = attacker, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
		attacker:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.05})	
		Timers:CreateTimer(0.1, function()
			caster.disableShield = false
		end)	
	end

end

function ShrineOfKarzhun(trigger)
	local hero = trigger.activator
	if not Arena.Karzhun then
		local portraitHero = "npc_dota_hero_elder_titan"
		local headerText = "arena_pit_conquest_shrine_of_karzhun"
		local messageText = "arena_pit_conquest_shrine_of_karzhun_Description"
		local bDialogue = 1
		local bAltCondition = 0
		local altMessage = ""
		local intattr = 0
		local option1 = "arena_pit_shrine_of_karzhun_option_1"
		local option2 = "arena_pit_shrine_of_karzhun_option_2"

		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_npc_dialogue", {portraitHero=portraitHero, headerText=headerText, messageText = messageText, bDialogue = bDialogue, subLabel = subLabel, labelCost = labelCost, bAltCondition = bAltCondition, bAltmessage = altMessage, intattr = intattr, option1=option1, option2=option2})	

	end
end

function karzhun_aura_start(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local stacks = caster:GetModifierStackCount("modifier_kharzun_buff", caster)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_karzhun_aura_stackable", {})
	target:SetModifierStackCount("modifier_karzhun_aura_stackable", caster, stacks)
end

function gift_of_karzhun_die(event)
	local caster = event.caster
	local immortals = math.max(RandomInt(math.ceil(caster.stackLevel/2.5), caster.stackLevel), 1)
	local position = caster:GetAbsOrigin()
	local particleName = "particles/bahamut/hyper_state_intro_omnislash_ascension_sparks.vpcf"
	EmitSoundOn("Arena.KarzhunDie", caster)
	for i = 1, immortals, 1 do
		Timers:CreateTimer(i*0.5, function()
			local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
			ParticleManager:SetParticleControl( particle1, 0, position)
			Timers:CreateTimer(3, 
			function()
				ParticleManager:DestroyParticle( particle1, false )
			end)
		end)
	end
	caster:BossDrops(immortals)
	local luck = RandomInt(1000*math.min(caster.stackLevel, 10), 10004)
	if luck == 10004 then
		RPCItems:RollConquestStoneFalcon(position)
	end
end

function ArenaConquestTemple()
	Arena:ArenaConquestTemple()
end

function temple_explorier_think(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("dark_seer_surge")
	if castAbility:IsFullyCastable() then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = caster:entindex(),
			 		AbilityIndex = castAbility:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)		
	end
end

function arena_temple_shaman_think(event)
	local caster = event.caster
	local shackle = caster:FindAbilityByName("blackguard_shackles")
	local wards = caster:FindAbilityByName("arena_pit_temple_shaman_serpent_wards")
	if caster.aggro then
		if wards:IsFullyCastable() and not caster.summoned then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = wards:entindex(),
		 	}
			ExecuteOrderFromTable(newOrder)	
			return
		end
		if shackle:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = shackle:entindex(),
			 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return
			end
		end

	end
end

function arena_temple_shaman_wards(event)
	local caster = event.caster
	for i = 1, 10+Arena.PitLevel, 1 do
		Timers:CreateTimer(i*0.1, function()
			Arena:SpawnRuinsWard(Vector(-14377, 15336)+RandomVector(RandomInt(1,400)), RandomVector(1))
		end)
	end
	EmitSoundOn("Hero_ShadowShaman.SerpentWard", caster)
end

function arena_temple_repeller_think(event)
	local caster = event.caster
	local wave = caster:FindAbilityByName("arena_pit_temple_wave")
	local repel = caster:FindAbilityByName("omniknight_repel")
	if caster.aggro then
		if repel:IsFullyCastable() then
			local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
			local target_types = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 640, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #allies > 0 then
				local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = allies[1]:entindex(),
			 		AbilityIndex = repel:entindex(),
			 	}
				ExecuteOrderFromTable(newOrder)		
				return				
			end
		end
		if wave:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = wave:entindex(),
						Position = castPoint
				 	}
				 EmitSoundOn("Arena.TempleRepeller.Cast", caster)
				ExecuteOrderFromTable(newOrder)	
				return
			end
		end
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 440, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local sumVector = Vector(0,0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector/#enemies
			local runDirection = ((caster:GetAbsOrigin() - avgVector)*Vector(1,1,0)):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin()+runDirection*300)
		end
	end	
end

function conquest_switch_attack(event)
	local caster = event.caster
	local ability = event.ability
	if caster.type == "temple_switch" then
		if not caster.attackCount then
			caster.attackCount = 0
			caster.startingAngle = 0
		end
		caster.attackCount = caster.attackCount + 1
		caster:SetRenderColor(255-(caster.attackCount*20), 255-(caster.attackCount*20), 255)
		for i = 1, 15, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster.startingAngle = caster.startingAngle + 1
				caster:SetAngles(0, 359-caster.startingAngle*0.5, 0)
				caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,0.8))
			end)
		end

		if caster.attackCount == 5 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_attackable_unit_no_more_attacks", {})
			Arena:OpenTempleWall()
			Timers:CreateTimer(0.35, function()
				EmitSoundOn("Tanari.WaterTemple.SwitchEnd", caster)
			end)
			Timers:CreateTimer(120, function()
				UTIL_Remove(caster)
			end)
		end	
	elseif caster.type == "forest_ward" then
		if not caster.switch then
			if not Arena.ForestGuide then
				caster.switch = true
				Timers:CreateTimer(0.5, function()
					--print("GO!")
					StartAnimation(caster, {duration=1, activity=ACT_DOTA_IDLE_RARE, rate=1.8})
					EmitSoundOn("Arena.ForestSwitchAttack", caster)
					Arena.ForestGuide = CreateUnitByName("conquest_forest_guide", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
					Arena.ForestGuide:SetDayTimeVisionRange(500)
					Arena.ForestGuide:SetNightTimeVisionRange(500)
					Arena.ForestGuide:SetBaseMoveSpeed(300)
					Arena.ForestGuide:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,240))
					Arena.ForestGuide:SetOriginalModel("models/heroes/storm_spirit/storm_spirit.vmdl")
					Arena.ForestGuide:SetModel("models/heroes/storm_spirit/storm_spirit.vmdl")
					Arena.ForestGuide:SetModelScale(1.2)
					Arena.ForestGuide:SetRenderColor(242, 255, 88)
					Arena.ForestGuide:SetForwardVector(caster:GetForwardVector())
					Arena.ForestGuide:AddAbility("arena_conquest_forest_guide_passive"):SetLevel(1)
					caster.switch = false
					EmitSoundOn("Arena.ForestSwitchInto", Arena.ForestGuide)
					WallPhysics:Jump(Arena.ForestGuide, caster:GetForwardVector(), 10, 24, 35, 1)
					local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
				    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.ForestGuide)
				    ParticleManager:SetParticleControl(pfx,0,Arena.ForestGuide:GetAbsOrigin()+Vector(0,0,180))   
					Timers:CreateTimer(2.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					Timers:CreateTimer(0.2, function()
						StartAnimation(Arena.ForestGuide, {duration=1.5, activity=ACT_DOTA_TELEPORT_END, rate=0.68})
						EmitSoundOn("Arena.ForestGuideAppear", Arena.ForestGuide)
					end)
					Timers:CreateTimer(1.2, function()
						local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
					    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.ForestGuide)
					    ParticleManager:SetParticleControl(pfx,0,Arena.ForestGuide:GetAbsOrigin()+Vector(0,0,100))   
					    EmitSoundOn("Arena.ForestSwitchLand", Arena.ForestGuide)
					    Arena.ForestGuide:SetPhysicalArmorBaseValue(500)
					    Arena.ForestGuide.aiState = 0
					    local passiveAbility = Arena.ForestGuide:FindAbilityByName("arena_conquest_forest_guide_passive")
					    passiveAbility:ApplyDataDrivenModifier(Arena.ForestGuide, Arena.ForestGuide, "modifier_forest_guide_effect_passive", {})
						Timers:CreateTimer(2.5, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end)

				end)
			end
		end
	elseif caster.type == "dust_dispenser" then
		if not caster.lock then
			reindexDustTable()
			if #Arena.DustTable < 4 then
				EndAnimation(caster)
				Timers:CreateTimer(0.1, function()
					EmitSoundOn("Arena.TrusthDispenserStart", caster)
					StartAnimation(caster, {duration=4.24, activity=ACT_DOTA_IDLE_RARE, rate=1.0})
				end)
				caster.lock = true
				Timers:CreateTimer(2.5, function()
					EmitSoundOn("Arena.TrusthDispenserEnd", caster)
					local item = RPCItems:CreateUnstashable("item_rpc_truth_dust", "uncommon", "Truth Dust", -1, false, "Pit of Trials Only", "truth_dust_description")
					local position = caster:GetAbsOrigin()
				    local drop = CreateItemOnPositionSync( position, item )
				    item.cantStash = true
				    local dropPosition = position+caster:GetForwardVector()*150
				    --item:LaunchLoot(false, 240, 0.75, dropPosition)
					RPCItems:LaunchLoot(item, 240, 0.5, dropPosition, dropPosition)
				    table.insert(Arena.DustTable, item)
				end)
				Timers:CreateTimer(4.44, function()
					caster.lock = false
					StartAnimation(caster, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
				end)
			end
		end
	end
end

function arena_temple_arachnomancer_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if ability:IsFullyCastable() then
		local newOrder = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		AbilityIndex = ability:entindex(),
	 	}
		ExecuteOrderFromTable(newOrder)	
		return
	end
end

function arena_temple_arachnomancer_summon(event)
	local caster = event.caster
	local ability = event.ability
	local loops = 2
	if Arena.PitLevel == 7 then
		loops = 4
	elseif Arena.PitLevel > 4 then
		loops = 3
	end

	for i = 1, loops, 1 do
		local spider = Arena:SpawnTempleSpider(caster:GetAbsOrigin()+RandomVector(RandomInt(100, 260)), caster:GetForwardVector())
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_dustcloud.vpcf", spider, 2)
		createSummonParticle(caster:GetAbsOrigin(), caster, spider)
	end
	EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", caster)	
end

function createSummonParticle(position, caster, target)
	local particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,caster:GetAbsOrigin()+Vector(0,0,200))   
    ParticleManager:SetParticleControl(pfx,1,target:GetAbsOrigin()+Vector(0,0,522))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	-- particleName = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_lightning.vpcf"
	-- local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
 --    ParticleManager:SetParticleControl(pfx2,0,caster:GetAbsOrigin()+Vector(0,0,200))   
 --    ParticleManager:SetParticleControl(pfx2,1,target:GetAbsOrigin()+Vector(0,0,822))
	-- Timers:CreateTimer(3.5, function()
	-- 	ParticleManager:DestroyParticle(pfx2, false)
	-- end)		
end

function createSummonParticle2Pos(position1, position2)
	local particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.ArenaMaster)
    ParticleManager:SetParticleControl(pfx,0,position1)   
    ParticleManager:SetParticleControl(pfx,1,position2)
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)	
end

function TempleStaffTrigger(trigger)
	local hero = trigger.activator
	local staff = Entities:FindByNameNearest("ConquestTempleStaff", Vector(-15168, 8713, 128), 500)
	for i = 1, 90, 1 do
		Timers:CreateTimer(i*0.03, function()
			staff:SetRenderColor(70+i*2, 70+i*2, 70+i*2)
		end)
	end
	local particleName = "particles/bahamut/hyper_state_intro_omnislash_ascension_sparks.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
	ParticleManager:SetParticleControl( particle1, 0, Vector(-15168, 8713, 428))
	Timers:CreateTimer(3, 
	function()
		ParticleManager:DestroyParticle( particle1, false )
	end)
	EmitSoundOnLocationWithCaster(Vector(-15168, 8713, 128), "Arena.Conquest.StaffUp", Arena.ArenaMaster)
	local loops = 3
	if Arena.PitLevel == 7 then
		loops = 5
	elseif Arena.PitLevel > 3 then
		loops = 4
	end
	for j = 0, 4, 1 do
		Timers:CreateTimer(3 + j*7, function()
			for i = 1, loops, 1 do
				Timers:CreateTimer(i*0.3, function()
					local position = Vector(-14546, 8832) + RandomVector(RandomInt(50,340))
					local fv = (hero:GetAbsOrigin()*Vector(1,1,0)-position):Normalized()
					local target = Arena:SpawnTempleLeshrac(position, fv)
					createSummonParticle2Pos(Vector(-15104, 8576, 850), position+Vector(0,0,350))
					EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", target)	
				end)
			end
		end)
	end
	Timers:CreateTimer(35, function()

		Arena.StaffBird2 = CreateUnitByName("npc_flying_dummy_vision", Vector(-14131, 8832, 667), false, nil, nil, DOTA_TEAM_GOODGUYS)
		Arena.StaffBird2:SetAbsOrigin(Vector(-14131, 8832, 667))
		Arena.StaffBird2:FindAbilityByName("dummy_unit"):SetLevel(1)
		Arena.StaffBird2:SetOriginalModel("models/props_gameplay/roquelaire/roquelaire.vmdl")
		Arena.StaffBird2:SetModel("models/props_gameplay/roquelaire/roquelaire.vmdl")
		Arena.StaffBird2:SetModelScale(1.5)
		Arena.StaffBird2:SetForwardVector(Vector(-1,0))
		EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", Arena.StaffBird2)	
		createSummonParticle2Pos(Vector(-15104, 8576, 850), Arena.StaffBird2:GetAbsOrigin()+Vector(0,0,150))
		StartAnimation(Arena.StaffBird2, {duration=99999, activity=ACT_DOTA_ROQUELAIRE_LAND_IDLE, rate=1.0})
	end)
end

function ConquestBirdTrigger2()
	if Arena.StaffBird2 then
		if not Arena.StaffBird2.init then
			Arena.StaffBird2.init = true
			local bird = Arena.StaffBird2
			EmitSoundOn("Arena.Bird.Squawk", bird)
			Timers:CreateTimer(1, function()
			StartAnimation(bird, {duration=3, activity=ACT_DOTA_STARTLE, rate=1.0})
			
				Timers:CreateTimer(3, function()
					local flyToPosition = Vector(-14559, 5003, 760)
					local currentPosition = bird:GetAbsOrigin()
					local flightPath = flyToPosition - currentPosition
					bird:SetForwardVector(flightPath*Vector(1,1,0):Normalized())
					StartAnimation(bird, {duration=7.5, activity=ACT_DOTA_RUN, rate=1.0})
					for i = 1, 250, 1 do
						Timers:CreateTimer(i*0.03, function()
							bird:SetAbsOrigin(currentPosition+((flightPath/250)*i))
						end)
					end
					Timers:CreateTimer(7.6, function()
						StartAnimation(bird, {duration=1.8, activity=ACT_DOTA_ROQUELAIRE_LAND, rate=1.0})
						bird:SetForwardVector(Vector(-0.2,-1))
						Timers:CreateTimer(1.9, function()
							StartAnimation(bird, {duration=99999, activity=ACT_DOTA_ROQUELAIRE_LAND_IDLE, rate=1.0})
						end)
						local staff = Entities:FindByNameNearest("conquest_staff", Vector(-14584, 4979, 270), 800)
						for j = 1, 80, 1 do
							Timers:CreateTimer(j*0.03, function()
								staff:SetRenderColor(40+(j*2.5), 40+(j*2.5), 40+(j*2.5))
							end)
						end
						Timers:CreateTimer(4.4, function()
							Events:CreateCollectionBeam(Vector(-14584, 4979, 770), Vector(-14656, 4608, 286))
							EmitSoundOnLocationWithCaster(Vector(-14584, 4979, 770), "Arena.StaffBeam", Arena.ArenaMaster)
							local mountainSpirit = CreateUnitByName("arena_cliff_spirit", Vector(-14656, 4608, 286), false, nil, nil, DOTA_TEAM_NEUTRALS)
							mountainSpirit.dummy = true
							mountainSpirit:SetForwardVector(Vector(-0.5, -1))
							Timers:CreateTimer(0.1, function()
								StartAnimation(mountainSpirit, {duration=2, activity=ACT_DOTA_ANCESTRAL_SPIRIT, rate=1.0})
							end)
							Timers:CreateTimer(0.2, function()
								mountainSpirit:MoveToPosition(Vector(-12800, 4736))
							end)
							Arena:AddPatrolArguments(mountainSpirit, 0, 4, 20, {mountainSpirit:GetAbsOrigin(), Vector(-12800, 4736)})
							mountainSpirit:AddAbility("arena_mountain_spirit_ai"):SetLevel(1)
							CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", mountainSpirit, 2)
							EmitSoundOn("Arena.SpiritSPawn", mountainSpirit)
							Arena:ConquestTemplePart3()
						end)
					end)
				end)
			end)
		end
	end
end

function pit_sapphire_flare_start(event)
	local ability = event.ability
	local caster = event.caster
		local stun_duration = event.stun_duration
		local damage = event.damage
		local position = event.target_points[1]
		local explosionAOE = 270
		local particleName = "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_cast.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( particle1, 0, position )
		Timers:CreateTimer(4, 
		function()
			ParticleManager:DestroyParticle( particle1, false )
		end)	
		EmitSoundOnLocationWithCaster(position, "Arena.ConquestHulk.SapphireFlare", caster)
		Timers:CreateTimer(0.1, function()
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = stun_duration})
				end
			end 	
		end)
end

function ConquestForestAmbush(event)
	for i = 1, 12+Arena.PitLevel, 1 do
		Timers:CreateTimer(i*0.5, function()
			local spawnVector = Vector(-15413, -4683+RandomInt(0, 1600))
			local fv = Vector(1,0)
			local soldier = Arena:SpawnForestSoldier(spawnVector, fv, true)
			WallPhysics:Jump(soldier, fv, 16, 25, 29, 1)
			Timers:CreateTimer(0.1, function()
				StartAnimation(soldier, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
			end)
		end)
	end
	Timers:CreateTimer(0.25, function()
		for j = 1, 12+Arena.PitLevel, 1 do
			Timers:CreateTimer(j*0.5, function()
				local spawnVector = Vector(-14121, -4480+RandomInt(0, 1480))
				local fv = Vector(-1,0)
				local soldier = Arena:SpawnForestSoldier(spawnVector, fv, true)
				WallPhysics:Jump(soldier, fv, 16, 25, 29, 1)
				Timers:CreateTimer(0.1, function()
					StartAnimation(soldier, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
				end)
			    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
			    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
			    ParticleManager:SetParticleControl(pfx,0,soldier:GetAbsOrigin()+Vector(0,0,40))
			    Timers:CreateTimer(1,
			    	function()
			      		ParticleManager:DestroyParticle( pfx, false )
					end)
			end)
		end
	end)
end

function bovel_think(event)
	local caster = event.caster
	if caster.aggro then
		local stompAbility = caster:FindAbilityByName("fire_temple_hoof_stomp")
		if stompAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = stompAbility:entindex(),
				 	}
				 
				ExecuteOrderFromTable(newOrder)	
			end
			return
		end
		local warcryAbility = caster:FindAbilityByName("arena_challenger_16_warcry")
		if warcryAbility:IsFullyCastable() then
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = warcryAbility:entindex(),
				 	}
				 
				ExecuteOrderFromTable(newOrder)	
		end
	end
end

function arena_forest_guide_die(event)
	Arena.ForestGuide = false
	EmitSoundOn("Arena.ForestGuideDie", event.caster)
end

function forest_guide_think(event)
	local caster = event.caster
	local aiState = caster.aiState
	local moveToPosition = Vector(-15168, -1984)
	if aiState == 1 then
		moveToPosition = Vector(-14272, -2112)
	elseif aiState == 2 then
		moveToPosition = Vector(-14784, -3136)
	elseif aiState == 3 then
		moveToPosition = Vector(-14875, -4848)
	elseif aiState == 4 then
		moveToPosition = Vector(-15171, -5373)
	elseif aiState == 5 then
		moveToPosition = Vector(-15171, -9085)
	end
	if aiState <= 5 then
		caster:MoveToPosition(moveToPosition)
	end
	if aiState == 6 then
		event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_forest_guide_invincible", {})
		caster.aiState = 7
		local jumpDirection = (Vector(-15082, -12162) - caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_TELEPORT_END, rate=0.68})
		WallPhysics:Jump(caster, caster:GetForwardVector(), 49, 39, 29, 1)
		EmitSoundOn("Arena.ForestSwitchInto", caster)
		local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
	    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	    ParticleManager:SetParticleControl(pfx,0,caster:GetAbsOrigin()+Vector(0,0,100))   
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Arena.ForestGuideAppear", caster)
		end)
		Timers:CreateTimer(2.5, function()
			Arena.ForestGuideActivated = true
			local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
		    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		    ParticleManager:SetParticleControl(pfx,0,caster:GetAbsOrigin()+Vector(0,0,100))   
		    EmitSoundOn("Arena.ForestSwitchLand", caster)
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			caster.aiState = 8
			caster:SetForwardVector(Vector(0,1))
		end)
		Timers:CreateTimer(3.5, function()
			EmitSoundOn("Arena.ForestGuideAppear", caster)
			local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_static_remnant_glow.vpcf"
		    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		    ParticleManager:SetParticleControl(pfx,0,Vector(-15256, -9088, 240))  
		end)
	end
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), moveToPosition)
	if distance < 100 then
		caster.aiState = aiState + 1
	end
end

function ConquestForestPull(trigger)
	local hero = trigger.activator
	if Arena.ForestGuide then
		if Arena.ForestGuide.aiState == 8 then
			EmitSoundOn("Arena.ForestGuidePull", hero)
			Timers:CreateTimer(0.5, function()
				EmitSoundOn("Arena.ForestGuideAppear", hero)
			end)
			local ability = Arena.ForestGuide:FindAbilityByName("arena_conquest_forest_guide_passive")
			ability:ApplyDataDrivenModifier(Arena.ForestGuide, hero, "modifier_forest_guide_pull", {duration = 13})
			ability:ApplyDataDrivenModifier(Arena.ForestGuide, hero, "modifier_forest_guide_pull_thinking", {duration = 13})
		end
	end
end

function guide_pull_think(event)
	local target = event.target
	local caster = event.caster
	local targetPoint = Vector(-15082, -12162)
	local fv = ((targetPoint-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), targetPoint*Vector(1,1,0))
	target:SetAbsOrigin(target:GetAbsOrigin()+fv*14)
	if distance < 150 then
		target:RemoveModifierByName("modifier_forest_guide_pull")
		target:RemoveModifierByName("modifier_forest_guide_pull_thinking")
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
		EmitSoundOn("Arena.ForestGuideAppear", caster)
	end
end

function boss_entering_start(event)
	local caster = event.caster
	local particleName = "particles/econ/items/weaver/weaver_immortal_ti6/weaver_immortal_ti6_shukuchi_portal.vpcf"
	CustomAbilities:QuickAttachParticle(particleName, caster, 4)
	EmitSoundOn("Arena.ConquestBossDash", caster)
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Arena.ConquestBossNeigh", caster)
		EmitSoundOn("Arena.ConquestBossNeigh", caster)
	end)
	caster:RemoveModifierByName("modifier_stunned")
end

function boss_entering_think(event)
	local caster = event.caster
	local targetPosition = caster.targetPosition
	local moveVector = caster.moveVector
	caster:SetAbsOrigin(caster:GetAbsOrigin()+moveVector)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), targetPosition)
	caster:SetForwardVector((moveVector*Vector(1,1,0)):Normalized())
	if distance < 100 then
		caster:RemoveModifierByName("modifier_conquest_boss_entering")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end
end

function SpawnConquestBoss()
	if Arena.ForestGuideActivated then
		if not Arena.ConquestBossSpawned then
			Arena.ConquestBossSpawned = true
			Arena:SpawnConquestBoss()
		end
	end
end

function conquest_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if not caster:IsChanneling() then
		caster.interval = caster.interval + 1
		if caster.interval % 6 == 0 then
			Arena:ConquestBossMoveStaffs(false, caster.staff1, caster.staff2, caster)
			local targetPosition = Vector(-15168, -14848, 280) + Vector(RandomInt(0,600), RandomInt(0, 600))
			if not caster.sideMove then
				local vecTable = {Vector(-15680, -13952, 460), Vector(-15480, -15168, 460), Vector(-14144, -15168, 460), Vector(-13950, -13952, 460)}
				targetPosition = vecTable[RandomInt(1,4)]
				caster.sideMove = true
			else
				caster.sideMove = false
			end

			caster.interval = 0
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_conquest_boss_entering", {duration = 10})
			
			caster.moveVector = (targetPosition - caster:GetAbsOrigin())/50
			caster:SetForwardVector((caster.moveVector*Vector(1,1,0)):Normalized())
			caster.targetPosition = targetPosition	
			-- if caster:GetHealth() < caster:GetMaxHealth()*0.6 then
			-- 	local loops = math.max(math.ceil((1 - (caster:GetHealth()/caster:GetMaxHealth()))*10) - 4, 1)
			-- 	for i = 1, loops, 1 do
			-- 		local position = Vector(-14848, -14334)+RandomInt(800,1500)*RandomVector(1)
		 --  			ability:ApplyDataDrivenThinker(caster, position, "modifier_conquest_boss_slow_pool", {duration = 6})		
		 --  		end
			-- end

		end
	end
	local castAbility = caster:FindAbilityByName("conquest_black_mage_luminescence")
	if castAbility:IsFullyCastable() then
		 if caster.staff1 then
			local position = caster.staff1:GetAbsOrigin()
			local luck = RandomInt(1,2)
			if luck == 2 then
				position = caster.staff2:GetAbsOrigin()
			end
			position = position + RandomVector(RandomInt(1, 240))
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = position
			 	}
			 EmitSoundOn("Arena.ConquestBossChant1", caster)
			ExecuteOrderFromTable(newOrder)	
		end
	end
end

function white_staff_think(event)
	local caster = event.caster
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 280, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #allies > 0 then	
		for _,ally in pairs(allies) do
			local particleName = "particles/items_fx/white_zap_beam.vpcf"
			local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster) 
			ParticleManager:SetParticleControl(lightningBolt,0,caster:GetAbsOrigin()+Vector(50,50,340))   
			ParticleManager:SetParticleControl(lightningBolt,1,ally:GetAbsOrigin()+Vector(0,0,100))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(lightningBolt, false)
			end)
			local healAmount = ally:GetMaxHealth()*0.02
			ally:SetHealth(ally:GetHealth() + healAmount)
			PopupHealing(ally, healAmount)
		end
	end
end

function black_staff_think(event)
	local caster = event.caster
	local boss = caster.boss
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 280, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then	
		for _,enemy in pairs(enemies) do
			local particleName = "particles/items_fx/black_zap_beam.vpcf"
			local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster) 
			ParticleManager:SetParticleControl(lightningBolt,0,caster:GetAbsOrigin()+Vector(50,50,300))   
			ParticleManager:SetParticleControl(lightningBolt,1,boss:GetAbsOrigin()+Vector(0,0,80))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(lightningBolt, false)
			end)
			local damageAmount = boss:GetMaxHealth()*0.15
			damageAmount = damageAmount/Arena:GetResistancePercentage()
			damageAmount = damageAmount/Arena.PitLevel
			ApplyDamage({ victim = boss, attacker = enemy, damage = damageAmount, damage_type = DAMAGE_TYPE_PURE })	
		end
	end
end

function boss_burn_think(event)
	local caster = event.caster
	local target = event.target
	local damage = target:GetMaxHealth()*0.02
	local ability = event.ability
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
end

function conquest_boss_die(event)
	local caster = event.caster
	EmitSoundOn("Arena.ConquestBossDie", caster)
	Timers:CreateTimer(0.5, function()
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
		EmitSoundOn("Arena.ConquestBossDie2", caster)
		UTIL_Remove(caster.staff1)
		UTIL_Remove(caster.staff2)
	end)
	Timers:CreateTimer(1.0, function()
		EmitGlobalSound("ui.set_applied")
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-14759, -14219, 238+Arena.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		Arena.ConquestPortal = true
	end)
	local luck = RandomInt(1,4)
	if luck == 1 then
		RPCItems:RollHoodOfBlackMage(caster:GetAbsOrigin(), false)
	end
	if not Arena.PitBossesSlain then
		Arena.PitBossesSlain = 0
	end
	Arena.PitBossesSlain = Arena.PitBossesSlain + 1
	if Arena.PitBossesSlain == 3 then
		Arena:SpawnPitGuardian()
	end
end

function ConquestOutPortal(trigger)
	local hero = trigger.activator
	if Arena.ConquestPortal and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-1984, 8448)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end

end

function SignConquest(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_view_sign", {sign="arena_trial_of_conquest"})
end

function SignLies(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_view_sign", {sign="arena_trial_of_lies"})
end

function SignDescent(trigger)
	local hero = trigger.activator
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_view_sign", {sign="arena_trial_of_descent"})
end

function ConquestMainSwitch(trigger)
	if not Arena.PitActive then
		return
	end
	Arena.ConquestOpen = true
	Dungeons.respawnPoint = Vector(-3780, 9726)
	Arena:ActivateSwitchGeneric(Vector(-3780, 9726), "ConquestSwitch", true, 0.34)
	Timers:CreateTimer(1.2, function()
			local wall = Entities:FindByNameNearest("ConquestWall", Vector(-4100, 10114, 648), 500)
			Arena:PitWall(false, {wall}, true, 4.8)
			Timers:CreateTimer(4.2, function()
				Arena:InitTrialOfConquest()
				local blockers = Entities:FindAllByNameWithin("ConquestBlocker", Vector(-4122, 10091), 4000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
	end)
end

function LiesMainSwitch(trigger)
	if not Arena.PitActive then
		return
	end
	Arena.LiesOpen = true
	--print("LIES SWITCH")
	Dungeons.respawnPoint = Vector(-2113, 10418)
	Arena:ActivateSwitchGeneric(Vector(-2113, 10418), "LiesSwitch", true, 0.35)
	Timers:CreateTimer(1.2, function()
			local wall = Entities:FindByNameNearest("LiesWall", Vector(-2122, 10760, 470), 500)
			Arena:PitWall(false, {wall}, true, 4.4)
			Timers:CreateTimer(3.9, function()
				local blockers = Entities:FindAllByNameWithin("LiesBlocker", Vector(-2048, 10768), 3000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
				Arena:LiesRoom1()
			end)
	end)
end

function spike_damage(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Tanari.Spikes", target)
	local damage = target:GetMaxHealth()*0.04
	ApplyDamage({ victim = target, attacker = Events.GameMaster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
	PopupDamage(target, damage)
end


function spikes_enter(trigger)
	local hero = trigger.activator
	local ability = Events.GameMaster:FindAbilityByName("npc_abilities")
	ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_spike_damage_arena", {duration = 5000})
end

function spikes_leave(trigger)
	local hero = trigger.activator
	hero:RemoveModifierByName("modifier_spike_damage_arena")
	-- Timers:CreateTimer(0.15, function()
	-- 	hero:RemoveModifierByName("modifier_spike_damage_boulderspine")
	-- end)
	-- Timers:CreateTimer(0.35, function()
	-- 	hero:RemoveModifierByName("modifier_spike_damage_boulderspine")
	-- end)
end

function use_truth_dust(event)
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/items_fx/truth_dust.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	EmitSoundOn("Arena.TruthDust", caster)
	local position = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1,0,position)		
	ParticleManager:SetParticleControl(particle1,1,Vector(500, 300, 250))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 510, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	for i = 1, #enemies, 1 do
		Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, enemies[i], "modifier_arena_truth_dust", {duration = 30})
	end		
	local spikes = Entities:FindAllByNameWithin("LiesSpikes", Vector(position.x, position.y, 448+Arena.ZFLOAT-1000), 510)
	if #spikes > 0 then
		for i = 1, #spikes, 1 do
			spikes[i]:SetAbsOrigin(spikes[i]:GetAbsOrigin()+Vector(0,0,1000))
		end
		Timers:CreateTimer(30, function()
			for j = 1, #spikes, 1 do
				spikes[j]:SetAbsOrigin(spikes[j]:GetAbsOrigin()-Vector(0,0,1000))
			end
		end)
	end
	local bridges = Entities:FindAllByNameWithin("ArenaLiesBridge", Vector(position.x, position.y, 128+Arena.ZFLOAT-2000), 1010)
	if #bridges > 0 then
		for i = 1, #bridges, 1 do
			bridges[i]:SetAbsOrigin(bridges[i]:GetAbsOrigin()+Vector(0,0,2000))
		end
		Timers:CreateTimer(30, function()
			for j = 1, #bridges, 1 do
				bridges[j]:SetAbsOrigin(bridges[j]:GetAbsOrigin()-Vector(0,0,2000))
			end
		end)
	end	
	local mageStatue = Entities:FindAllByNameWithin("LiesAntimageStatue", Vector(position.x, position.y, 128+Arena.ZFLOAT), 510)
	if #mageStatue > 0 then
		local fullMageStatue = Entities:FindAllByNameWithin("LiesAntimageStatue", Vector(2435, 15730, 128+Arena.ZFLOAT), 1000)
		for i = 1, #fullMageStatue, 1 do
			UTIL_Remove(fullMageStatue[i])
		end
		local mage = Arena:SpawnArbiterOfTruth(Vector(2435, 15730), Vector(-1,-1))
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, mage, "modifier_disable_player", {duration = 1.6})
	end
	local lizardStatue = Entities:FindAllByNameWithin("LiesLizardStatue", Vector(position.x, position.y, 128+Arena.ZFLOAT), 510)
	if #lizardStatue > 0 then
		local fullLizardStatue = Entities:FindAllByNameWithin("LiesLizardStatue", Vector(14308, 14998, 128+Arena.ZFLOAT), 1000)
		for i = 1, #fullLizardStatue, 1 do
			UTIL_Remove(fullLizardStatue[i])
		end
		local lizard = Arena:SpawnBigCaveLizard(Vector(14308, 14998), Vector(0,-1))
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, lizard, "modifier_disable_player", {duration = 1.6})
	end
	local treasureChest = Entities:FindAllByNameWithin("LiesChest", Vector(position.x, position.y, 128+Arena.ZFLOAT), 510)
	if #treasureChest > 0 then
		UTIL_Remove(treasureChest[1])
		local chest = CreateUnitByName("chest", Vector(6357, 15335, 128+Arena.ZFLOAT), true, nil, nil, DOTA_TEAM_GOODGUYS)
		chest:SetRoshpitLevel(120)
		chest:SetForwardVector(Vector(-1,0))
		chest:FindAbilityByName("town_unit"):SetLevel(1)
		chest:AddAbility("rpc_chest_ability"):SetLevel(1)
	end
	local tree = Entities:FindAllByNameWithin("LiesOgreTree", Vector(position.x, position.y, 128+Arena.ZFLOAT), 510)
	if #tree > 0 then
		UTIL_Remove(tree[1])
		Arena:SpawnTrueOgre(Vector(8873, 15488), Vector(1,0))
	end
	local switches = Entities:FindAllByNameWithin("LiesSwitchRevealable", Vector(position.x, position.y, 30+Arena.ZFLOAT-1000), 510)
	if #switches > 0 then
		local switch = switches[1]
		switch:SetAbsOrigin(switch:GetAbsOrigin()+Vector(0,0,1000))
		Timers:CreateTimer(30, function()
			switch:SetAbsOrigin(switch:GetAbsOrigin()-Vector(0,0,1000))
		end)
	else
		local switches = Entities:FindAllByNameWithin("LiesSwitchRevealable", Vector(position.x, position.y, -130+Arena.ZFLOAT-1000), 510)
		if #switches > 0 then
			local switch = switches[1]
			switch:SetAbsOrigin(switch:GetAbsOrigin()+Vector(0,0,1000))
			Timers:CreateTimer(30, function()
				switch:SetAbsOrigin(switch:GetAbsOrigin()-Vector(0,0,1000))
			end)
		end
	end

	local liesNumbers = Entities:FindAllByNameWithin("LiesNumber", Vector(position.x, position.y, 128+Arena.ZFLOAT-1000), 600)
	if #liesNumbers > 0 then
		for i = 1, #liesNumbers, 1 do
			liesNumbers[i]:SetAbsOrigin(liesNumbers[i]:GetAbsOrigin()+Vector(0,0,1000))
		end
		Timers:CreateTimer(30, function()
			for j = 1, #liesNumbers, 1 do
				liesNumbers[j]:SetAbsOrigin(liesNumbers[j]:GetAbsOrigin()-Vector(0,0,1000))
			end
		end)
	end	
	local bossBomb = Entities:FindAllByNameWithin("LiesBossProp", Vector(position.x, position.y, 128+Arena.ZFLOAT), 510)
	if #bossBomb > 0 then
		if Arena.AllowLiesBoss then
		  local position = bossBomb[1]:GetAbsOrigin()
		  EmitSoundOnLocationWithCaster(position, "Arena.LiesBoss.BombExplode", Arena.ArenaMaster)
	      local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
	      ParticleManager:SetParticleControl( particle2, 0, position )
	      ParticleManager:SetParticleControl( particle2, 1, Vector(500,500,500) )
	      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
	      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )
	      Timers:CreateTimer(1.5, 
	      function()
	        ParticleManager:DestroyParticle( particle2, false )
	      end)


			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					enemy:AddNewModifier(Events.GameMaster, nil, "modifier_stunned", {duration = 1.0})
					ApplyDamage({ victim = enemy, attacker = Arena.ArenaMaster, damage = enemy:GetMaxHealth()*0.25, damage_type = DAMAGE_TYPE_PURE})
				end
			end 
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(Arena.smokePFX, false)
			end)
			UTIL_Remove(bossBomb[1])
			Timers:CreateTimer(2, function()
				Arena:SpawnLiesBoss(position)
			end)
		end
	end
	if ability:GetCurrentCharges() == 0 then
		reindexDustTable()
	end
end

function reindexDustTable()
	local newTable = {}
	for i = 1, #Arena.DustTable, 1 do
		if IsValidEntity(Arena.DustTable[i]) then
			table.insert(newTable, Arena.DustTable[i])
		end
	end
	Arena.DustTable = newTable
end

function lies_beetle_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 520, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			local damage = 25000
			PopupDamage(enemy, damage)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			local particleName = "particles/items_fx/green_lightning.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin()+Vector(0,0,80), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT, "attach_hitloc", enemy:GetAbsOrigin()+Vector(0,0,80), true)
			Timers:CreateTimer(2.0, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 		
			EmitSoundOn("Arena.LiesBeetle.Zap", enemy)
		end
	end 
end

function LiesRoom2()
	Arena:LiesRoom2()
end

function truth_dust_apply(event)
	local target = event.target
	if target:HasModifier("modifier_boss_illusion_ability_effect") then
		local illusionAbility = target:FindAbilityByName("arena_lies_boss_illusion_ability")
		illusionAbility:ApplyDataDrivenModifier(target, target, "modifier_boss_illusion_revealed", {duration = 30})
	end
	if target.smoke then
		target:RemoveModifierByName("modifier_lies_smoke_cloud_invis")
	end
	if target:GetUnitName() == "arena_lies_supreme_ogre" then
		local hpPercent = target:GetHealth()/target:GetMaxHealth()
		local trueOgre = Arena:SpawnLiesTrueOgre(target:GetAbsOrigin(), target:GetForwardVector())
		trueOgre:SetHealth(trueOgre:GetMaxHealth()*hpPercent)
		Dungeons:AggroUnit(trueOgre)
		Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, trueOgre, "modifier_arena_truth_dust", {duration = 30})
		Timers:CreateTimer(0.1, function()
			UTIL_Remove(target)
		end)
	end
end

function truth_dust_end(event)
	local target = event.target
	if target:IsAlive() then
		if target:GetUnitName() == "arena_lies_true_ogre" then
			local hpPercent = target:GetHealth()/target:GetMaxHealth()
			local ogre = Arena:SpawnLiesOgre(target:GetAbsOrigin(), target:GetForwardVector())
			ogre:SetHealth(ogre:GetMaxHealth()*hpPercent)
			Dungeons:AggroUnit(ogre)
			UTIL_Remove(target)
		end
		if target.smoke then
			local smokeAbility = target:FindAbilityByName("lies_smoke_cloud_ability")
			smokeAbility:ApplyDataDrivenModifier(target, target, "modifier_lies_smoke_cloud_base", {})
			smokeAbility:ApplyDataDrivenModifier(target, target, "modifier_lies_smoke_cloud_invis", {})
		end
	end
end

function lies_arbiter_think(event)
	local caster = event.caster
	local blinkAbility = caster:FindAbilityByName("antimage_blink_custom")
	if blinkAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1740, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = blinkAbility:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
		end
	end
end

function lies_arbiter_die(event)
	local caster = event.caster
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		EmitSoundOn("Arena.LiesArbiter.Death", caster)
		for j = 1, 200, 1 do
			Timers:CreateTimer(j*0.03, function()
				Arena.arbiterBridge:SetAbsOrigin(Arena.arbiterBridge:GetAbsOrigin()+Vector(0,0,10))
			end)
		end
		Timers:CreateTimer(6, function()
			local blockers = Entities:FindAllByNameWithin("LiesAntiBridgeBlocker", Vector(3713, 15393, 160+Arena.ZFLOAT), 3000)
			for k = 1, #blockers, 1 do
				UTIL_Remove(blockers[k])
			end
			Arena:SpawnLiesTreasureRoom()
			EmitSoundOnLocationWithCaster(Vector(3713, 15393, 160+Arena.ZFLOAT), "Arena.WaterTemple.SwitchEnd", Arena.ArenaMaster)
		end)
	end
end

function lies_treasure_bird_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetHealth() < caster:GetMaxHealth()*0.35 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arena_lies_treasure_bird_passive_magic_resist", {})
	else
		caster:RemoveModifierByName("modifier_arena_lies_treasure_bird_passive_magic_resist")
	end
end

function dungeon_chest_think(event)
	local caster = event.caster
	local chest = caster
	if not caster.lock then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			caster.lock = true
			EmitSoundOn("ui.treasure_unlock.wav", chest)
			EmitSoundOn("ui.treasure_unlock.wav", chest)
			EmitSoundOn("ui.treasure_unlock.wav", chest)
			StartAnimation(chest, {duration=7, activity=ACT_DOTA_DIE, rate=0.28})

			Dungeons.lootLaunch = chest:GetAbsOrigin()+Vector(-200, 0, 0)

			Timers:CreateTimer(2.0, function()
				for i = 0, RandomInt(5, 7), 1 do
					EmitSoundOn("General.FemaleLevelUp", chest)
				end
				chest:ChestDrops(7)
				local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf"
		      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, chest )
		      	local origin = chest:GetAbsOrigin()
		      	ParticleManager:SetParticleControl( particle1, 0, origin )
		      	ParticleManager:SetParticleControl( particle1, 1, origin )
		      	ParticleManager:SetParticleControl( particle1, 2, origin )
		      	ParticleManager:SetParticleControl( particle1, 3, origin )
			end)
			Timers:CreateTimer(6.5, function()
				Dungeons.lootLaunch = false
				UTIL_Remove(chest)
			end)
		end
	end
end

function LiesArea3Trigger()
	Arena:SpawnLiesArea3()
end

function lies_smoke_create(event)
	local caster = event.caster
	caster:AddNoDraw()
end

function lies_smoke_destroy(event)
	local caster = event.caster
	caster:RemoveNoDraw()
end

function LiesArea4Trigger()
	Arena:SpawnLiesArea4()
end

function LiesLibrarySwitch()
	if Arena.LiesLibrarySwitch:Attribute_GetIntValue("pressed", 0) == 0 then
		Arena.LiesLibrarySwitch:Attribute_SetIntValue("pressed", 1)
		Arena:ActivateSwitchSpecific(Arena.LiesLibrarySwitch, true, 0.28)
		Timers:CreateTimer(1.2, function()
				local wall = Entities:FindByNameNearest("LiesBookshelf", Vector(10466, 13561, 286+Arena.ZFLOAT), 700)
				Arena:PitWall(false, {wall}, true, 2.44)
				Timers:CreateTimer(3.9, function()
					local blockers = Entities:FindAllByNameWithin("LiesLibraryBlocker", Vector(10432, 13440, 160+Arena.ZFLOAT), 2000)
					for i = 1, #blockers, 1 do
						UTIL_Remove(blockers[i])
					end
					Arena:LiesRoom5()
				end)
		end)		
	end
end

function lies_trickster_think(event)
	local caster = event.caster
	if not caster.aggro then
		return
	end
	local luck = RandomInt(1, 4)
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()
	if luck == 1 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 640, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") and not caster:IsStunned() and not caster:IsRooted() then
			local sumVector = Vector(0,0,0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector/#enemies
			local forceDirection = ((casterOrigin-avgVector)*Vector(1,1,0)):Normalized()
			
			EmitSoundOn("Arena.LiesTricksterJump", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration=0.66, activity=ACT_DOTA_CAST_TORNADO, rate=1}) 
			for i = 1, 22, 1 do
				Timers:CreateTimer(i*0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()+forceDirection*14)
				end)
			end
			Timers:CreateTimer(0.66, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)	
		end
	end
	if luck == 2 then
		local flameAbility = caster:FindAbilityByName("arena_pit_temple_wave")
		if flameAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = flameAbility:entindex(),
						Position = castPoint
				 	}
				local luck3 = RandomInt(1,4)
				if luck3 == 1 then
					EmitSoundOn("Arena.TricksterCast", caster)
				end
				ExecuteOrderFromTable(newOrder)	
				StartAnimation(caster, {duration=1.3, activity=ACT_DOTA_CAST_CHAOS_METEOR, rate=0.6}) 	
			end
		end
	end
end

function supreme_ogre_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if caster:GetUnitName() == "arena_lies_supreme_ogre_true" then
		local immortals = RandomInt(1,Arena.PitLevel)
		local position = caster:GetAbsOrigin()
		local particleName = "particles/bahamut/hyper_state_intro_omnislash_ascension_sparks.vpcf"
		EmitSoundOn("Arena.TrueOgre.Death", caster)
		for i = 1, immortals, 1 do
			Timers:CreateTimer(i*0.5, function()
				local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
				ParticleManager:SetParticleControl( particle1, 0, position)
				Timers:CreateTimer(3, 
				function()
					ParticleManager:DestroyParticle( particle1, false )
				end)
			end)
		end	
		caster:BossDrops(immortals)	
		local luck = RandomInt(1,3)
		if luck == 1 then
			RPCItems:RollFortunesTalismanOfTruth(position)
		end
	end
end

function LiesNumberSwitchA()
	--print("NUMBER SWITCH!?")
	--print(Arena.numberSwitch1:Attribute_GetIntValue("pressed", 0))
	--print(Arena.NumberSwitchLock)
	if not Arena.ButtonsPressedTable then
		Arena.ButtonsPressedTable = {}
	end
	if Arena.NumberSwitchLock then
		return
	end
	if Arena.numberSwitch1:Attribute_GetIntValue("pressed", 0) == 0 then
		Arena.NumberSwitchLock = true
		Arena.numberSwitch1:Attribute_SetIntValue("pressed", 1)
		Arena:ActivateSwitchSpecific(Arena.numberSwitch1, true, 0.28)
		table.insert(Arena.ButtonsPressedTable, 1)
		Timers:CreateTimer(3, function()
			Arena:CheckSwitchOrderConditions()
			Arena.NumberSwitchLock = false
		end)
	end
end

function LiesNumberSwitchB()
	if not Arena.ButtonsPressedTable then
		Arena.ButtonsPressedTable = {}
	end
	if Arena.NumberSwitchLock then
		return
	end
	if Arena.numberSwitch2:Attribute_GetIntValue("pressed", 0) == 0 then
		Arena.NumberSwitchLock = true
		Arena.numberSwitch2:Attribute_SetIntValue("pressed", 1)
		Arena:ActivateSwitchSpecific(Arena.numberSwitch2, true, 0.28)
		table.insert(Arena.ButtonsPressedTable, 2)
		Timers:CreateTimer(3, function()
			Arena:CheckSwitchOrderConditions()
			Arena.NumberSwitchLock = false
		end)
	end
end

function LiesNumberSwitchC()
	if not Arena.ButtonsPressedTable then
		Arena.ButtonsPressedTable = {}
	end
	if Arena.NumberSwitchLock then
		return
	end
	if Arena.numberSwitch3:Attribute_GetIntValue("pressed", 0) == 0 then
		Arena.NumberSwitchLock = true
		Arena.numberSwitch3:Attribute_SetIntValue("pressed", 1)
		Arena:ActivateSwitchSpecific(Arena.numberSwitch3, true, 0.28)
		table.insert(Arena.ButtonsPressedTable, 3)
		Timers:CreateTimer(3, function()
			Arena:CheckSwitchOrderConditions()
			Arena.NumberSwitchLock = false
		end)
	end
end

function LiesNumberSwitchD()
	if not Arena.ButtonsPressedTable then
		Arena.ButtonsPressedTable = {}
	end
	if Arena.NumberSwitchLock then
		return
	end
	if Arena.numberSwitch4:Attribute_GetIntValue("pressed", 0) == 0 then
		Arena.NumberSwitchLock = true
		Arena.numberSwitch4:Attribute_SetIntValue("pressed", 1)
		Arena:ActivateSwitchSpecific(Arena.numberSwitch4, true, 0.28)
		table.insert(Arena.ButtonsPressedTable, 4)
		Timers:CreateTimer(3, function()
			Arena:CheckSwitchOrderConditions()
			Arena.NumberSwitchLock = false
		end)
	end
end

function magic_ward_set_stacks(event)
	local caster = event.caster
	local stacks = event.stacks
	caster:SetModifierStackCount("modifier_magic_immune_breakable_ability", caster, stacks)
end

function magic_ward_attacked(event)
	local caster = event.caster
	local newStacks = caster:GetModifierStackCount("modifier_magic_immune_breakable_ability", caster) - 1
	if newStacks == 0 then
		caster:RemoveModifierByName("modifier_magic_immune_breakable_ability")
	else
		caster:SetModifierStackCount("modifier_magic_immune_breakable_ability", caster, newStacks)
	end
end

function lies_boss_think(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("fire_temple_shadow_strike")
	local targetFindOrder = FIND_FARTHEST
	local shieldAbility = caster:FindAbilityByName("arena_lies_boss_magic_immune_ability")
	if shieldAbility:IsFullyCastable() then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = shieldAbility:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)		
			return true
	end
	if caster:HasAbility("arena_lies_boss_illusion_ability") and not caster.illusion and not caster:HasModifier("modifier_boss_illusion_ability_effect") then
		local illusionAbility = caster:FindAbilityByName("arena_lies_boss_illusion_ability")
		if illusionAbility:IsFullyCastable() then
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				 		AbilityIndex = illusionAbility:entindex(),
			 	}
				 
				ExecuteOrderFromTable(newOrder)		
				return true
		end
	end
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, targetFindOrder, false )	
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = enemies[1]:entindex(),
			 		AbilityIndex = castAbility:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)		
			return true
		end
	end

end

function lies_boss_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_trickster_mask_effect") then
	    local casterOrigin = caster:GetAbsOrigin()
	    local randomPosition = casterOrigin+RandomVector(RandomInt(300,600))
	    randomPosition = WallPhysics:WallSearch(casterOrigin, randomPosition, caster)
	    FindClearSpaceForUnit(caster, randomPosition, false)
	    local cooldown = 5 - Arena.PitLevel*0.4
	    ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_mask_effect", {duration = cooldown})
	end
end

function arena_lies_boss_illusion_ability_cast(event)
	local caster = event.caster
	local ability = event.ability
	if caster.illusion then
		return
	end
	if not caster:HasModifier("modifier_boss_illusion_ability_effect") then
		if not caster.illusionTable then
			caster.illusionTable = {}
		end
		--print(#caster.illusionTable)
		if #caster.illusionTable < 12 then
			local position = caster:GetAbsOrigin()+RandomVector(340)
			local illusion = CreateUnitByName("arena_lies_boss", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
			Arena:AddPitToUnit(illusion)
			-- boss:SetAbsOrigin(Vector(-14826, -16121, 950))
			Events:AdjustDeathXP(illusion)
			Events:AdjustBossPower(illusion, 16, 16, false)
			illusion:SetHealth(caster:GetHealth())
			illusion.illusion = true
			EmitSoundOn("Arena.LiesBoss.IntroSmoke", illusion)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", illusion, 3)
			-- illusion:SetRenderColor(255,255,0)
			-- Arena:ColorWearables(illusion, Vector(255,255,0))
			illusion.boss = caster
			ability:ApplyDataDrivenModifier(caster, illusion, "modifier_boss_illusion_ability_effect", {})
			illusion:SetMaximumGoldBounty(0)
			illusion:SetMinimumGoldBounty(0)
			illusion:SetDeathXP(0)
			table.insert(caster.illusionTable, illusion)
		end
	end
end

function lies_boss_die(event)
	local caster = event.caster
	if caster.liesBoss then
		EmitSoundOn("Arena.LiesBoss.Die", caster)
		Timers:CreateTimer(0.5, function()
			CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
		end)
		Timers:CreateTimer(1.0, function()
			EmitGlobalSound("ui.set_applied")
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(14016, 3008, 200+Arena.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			Arena.LiesPortal = true
		end)
		if not Arena.PitBossesSlain then
			Arena.PitBossesSlain = 0
		end
		Arena.PitBossesSlain = Arena.PitBossesSlain + 1
		if Arena.PitBossesSlain == 3 then
			Arena:SpawnPitGuardian()
		end
		local luck = RandomInt(1,4)
		if luck == 1 then
			RPCItems:RollGiantHunterBoots(caster:GetAbsOrigin())
		end
	else
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.LiesBoss.IllusionDie", Arena.ArenaMaster)
		local pfx = ParticleManager:CreateParticle( "particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin()+Vector(0,0,100) )
		Timers:CreateTimer(2.5, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
		Timers:CreateTimer(0.3, function()
			UTIL_Remove(caster)
		end)
		local newTable = {}
		for i = 1, #caster.boss.illusionTable, 1 do
			if IsValidEntity(caster.boss.illusionTable[i]) then
				table.insert(newTable, caster.boss.illusionTable[i])
			end
		end
		caster.boss.illusionTable = newTable
	end
end

function LiesOutPortal(trigger)
	local hero = trigger.activator
	if Arena.LiesPortal and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-1984, 8448)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end

end

function DescentMainSwitch(trigger)
	if not Arena.PitActive then
		return
	end
	Arena.DescentOpen = true
	--print("DESCENT SWITCH")
	Dungeons.respawnPoint = Vector(-672, 9787)
	Arena:ActivateSwitchGeneric(Vector(-672, 9787, 262+Arena.ZFLOAT), "DescentSwitch", true, 0.35)
	Timers:CreateTimer(1.2, function()
			local wall = Entities:FindByNameNearest("DescentWall", Vector(-232, 10134, 560+Arena.ZFLOAT), 700)
			Arena:PitWall(false, {wall}, true, 4.13)
			Timers:CreateTimer(3.9, function()
				local blockers = Entities:FindAllByNameWithin("DescentBlocker", Vector(-256, 10085, 440), 3000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
				Arena:DescentRoom1()
			end)
	end)
end

function descent_big_exiled_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		if not caster.summoned then
			caster.summoned = true
			local newOrder = {
	 			UnitIndex = caster:entindex(), 
	 			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
	 			AbilityIndex = ability:entindex(),
	 		}
	 		ExecuteOrderFromTable(newOrder)	
			for i = 1, 24+Arena.PitLevel, 1 do
				Timers:CreateTimer(i*0.3, function()
					local spirit = Arena:SpawnExiledSpirit(Vector(6272, 8384)+RandomVector(RandomInt(1,340)), Vector(-1,0), true)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
				end)
			end
		end
	end
end

function ghost_think()

end

function WidowTrigger()
	Arena:WidowTrigger(Arena.widow)
end

function cryingStart(event)
	local caster = event.caster
	StartSoundEvent("Arena.Descent.CryingBanshee", caster)
end

function cryingEnd(event)
	local caster = event.caster
	StopSoundEvent("Arena.Descent.CryingBanshee", caster)
end

function widow_summon_die(event)
	Arena.widow.summonCount = Arena.widow.summonCount + 1
	local widowAbility = Arena.widow:FindAbilityByName("arena_descent_grieving_widow_ability")
	if Arena.widow.summonCount == 20 then
		Timers:CreateTimer(1, function()
			EmitSoundOnLocationWithCaster(Vector(10136, 7852), "Arena.Descent.ScarySound", Arena.ArenaMaster)
			for i = 1, 24, 1 do
				Timers:CreateTimer(i*0.5, function()
					local spirit = Arena:SpawnSorrowWraith(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
					widowAbility:ApplyDataDrivenModifier(Arena.widow, spirit, "modifier_widow_summoned_unit", {})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
					local particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf"
				    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.widowCorpse)
				    ParticleManager:SetParticleControl(pfx,0,Arena.widowCorpse:GetAbsOrigin()+Vector(0,0,100))   
				    ParticleManager:SetParticleControl(pfx,1,spirit:GetAbsOrigin()+Vector(0,0,222))
					Timers:CreateTimer(3.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end)
			end
		end)
	elseif Arena.widow.summonCount == 42 then
		EmitSoundOnLocationWithCaster(Vector(10136, 7852), "Arena.Descent.ScarySound", Arena.ArenaMaster)
		for i = 1, 12, 1 do
			Timers:CreateTimer(i*1, function()
				local spirit = Arena:SpawnSorrowWraith(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
				widowAbility:ApplyDataDrivenModifier(Arena.widow, spirit, "modifier_widow_summoned_unit", {})
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
				createSummonParticle(spirit:GetAbsOrigin(), Arena.widowCorpse, spirit)
			end)
		end		
		Timers:CreateTimer(4, function()
			for i = 1, 12, 1 do
				Timers:CreateTimer(i*0.5, function()
					local spirit = Arena:SpawnExiledSpirit(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
					widowAbility:ApplyDataDrivenModifier(Arena.widow, spirit, "modifier_widow_summoned_unit", {})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
					createSummonParticle(spirit:GetAbsOrigin(), Arena.widowCorpse, spirit)
				end)
			end		
		end)
		Timers:CreateTimer(4, function()
			for i = 1, 3, 1 do
				Timers:CreateTimer(i*3, function()
					local spirit = Arena:SpawnExiledSpiritHeavy(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
					widowAbility:ApplyDataDrivenModifier(Arena.widow, spirit, "modifier_widow_summoned_unit", {})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
					createSummonParticle(spirit:GetAbsOrigin(), Arena.widowCorpse, spirit)
				end)
			end		
		end)
	elseif Arena.widow.summonCount == 66 then
		EmitSoundOnLocationWithCaster(Vector(10136, 7852), "Arena.Descent.ScarySound", Arena.ArenaMaster)
		for i = 1, 24, 1 do
			Timers:CreateTimer(i*0.5, function()
				local spirit = Arena:SpawnHorrorCOnstruct(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
				widowAbility:ApplyDataDrivenModifier(Arena.widow, spirit, "modifier_widow_summoned_unit", {})
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
				createSummonParticle(spirit:GetAbsOrigin(), Arena.widowCorpse, spirit)
			end)
		end	
	elseif Arena.widow.summonCount == 88 then
		for i = 1, 12, 1 do
			Timers:CreateTimer(i*1, function()
				local spirit = Arena:SpawnDeathSeeker(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
				widowAbility:ApplyDataDrivenModifier(Arena.widow, spirit, "modifier_widow_summoned_unit", {})
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
				createSummonParticle(spirit:GetAbsOrigin(), Arena.widowCorpse, spirit)
			end)
		end			
		Timers:CreateTimer(1.66, function()
			for i = 1, 12, 1 do
				Timers:CreateTimer(i*1, function()
					local spirit = Arena:SpawnHorrorCOnstruct(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
					widowAbility:ApplyDataDrivenModifier(Arena.widow, spirit, "modifier_widow_summoned_unit", {})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
					createSummonParticle(spirit:GetAbsOrigin(), Arena.widowCorpse, spirit)
				end)
			end		
		end)
		Timers:CreateTimer(2.33, function()
			for i = 1, 12, 1 do
				Timers:CreateTimer(i*1, function()
					local spirit = Arena:SpawnExiledSpirit(Vector(11136, 7552)+Vector(0,RandomInt(1,900)), Vector(-1,0), true)
					widowAbility:ApplyDataDrivenModifier(Arena.widow, spirit, "modifier_widow_summoned_unit", {})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", spirit, 2.0)
					createSummonParticle(spirit:GetAbsOrigin(), Arena.widowCorpse, spirit)
				end)
			end		
		end)
	elseif Arena.widow.summonCount == 120 then
		local distance = (Arena.widow:GetAbsOrigin().z - GetGroundHeight(Arena.widow:GetAbsOrigin(), Arena.widow))/90
		for i = 1, 90, 1 do
			Timers:CreateTimer(i*0.03, function()
				Arena.widow:SetAbsOrigin(Arena.widow:GetAbsOrigin()-Vector(0,0,distance))
			end)
		end
		Timers:CreateTimer(2.75, function()
			local widowAbility = Arena.widow:FindAbilityByName("arena_descent_grieving_widow_ability")
			widowAbility:ApplyDataDrivenModifier(Arena.widow, Arena.widow, "modifier_widow_soul_steal_aura", {})
			StartAnimation(Arena.widow, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.1})
			Arena.widow:RemoveModifierByName("modifier_grieving_widow_start")
			widowAbility:ApplyDataDrivenModifier(Arena.widow, Arena.widow, "modifier_widow_scream", {})
			if Arena.PitLevel > 3 then
				Arena.widow:AddAbility("arena_magic_immune_breakable_ability"):SetLevel(1)
			end
		end)
	end
end

function widow_die(event)
	local caster = event.caster
	--print("THIS CALLED?")
	EmitSoundOn("Arena.Descent.WidowDeath", caster)
	Arena.AllowNemesis = true
	Timers:CreateTimer(2, function()
		local newWidow = CreateUnitByName("arena_descent_grieving_widow", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
		UTIL_Remove(caster)
		local widowAbility = newWidow:FindAbilityByName("arena_descent_grieving_widow_ability")
		widowAbility:ApplyDataDrivenModifier(newWidow, newWidow, "modifier_grieving_widow_start", {})
		newWidow:AddAbility("ability_ghost_effect"):SetLevel(1)
		newWidow:SetForwardVector(Vector(1,0))
		local movementVector = (Arena.widowCorpse:GetAbsOrigin() + Vector(-200, 0, 0) - newWidow:GetAbsOrigin())/120

		for i = 1, 120, 1 do
			Timers:CreateTimer(0.03*i, function()
				newWidow:SetAbsOrigin(newWidow:GetAbsOrigin()+movementVector)
			end)
		end
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", newWidow, 3.0)
		Timers:CreateTimer(4, function()
			widowAbility:ApplyDataDrivenModifier(newWidow, newWidow, "modifier_widow_scream", {duration = 4.5})
			StartAnimation(newWidow, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.3})
		end)
		Timers:CreateTimer(5.5, function()
			for j = 1, 200, 1 do
				Timers:CreateTimer(j*0.03, function()
					newWidow:SetAbsOrigin(newWidow:GetAbsOrigin()-Vector(0,0,2))
					Arena.widowCorpse:SetAbsOrigin(Arena.widowCorpse:GetAbsOrigin()-Vector(0,0,2))
				end)
			end
			EmitSoundOn("Arena.Descent.WidowDyingWords", newWidow)
			Timers:CreateTimer(2, function()
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", newWidow, 3.0)
				local particleName = "particles/dark_smoke_test.vpcf"
			    local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.ArenaMaster)
			    ParticleManager:SetParticleControl(pfx1,0,Vector(10831, 8131, 366+Arena.ZFLOAT) )
			    local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.ArenaMaster)
			    ParticleManager:SetParticleControl(pfx2,0,Vector(10831, 7928, 366+Arena.ZFLOAT) )
			    local pfx3 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Arena.ArenaMaster)
			    ParticleManager:SetParticleControl(pfx2,0,Vector(10831, 7728, 366+Arena.ZFLOAT) )
			    Timers:CreateTimer(6.4, function()
			    	UTIL_Remove(Arena.widowCorpse)
			    	ParticleManager:DestroyParticle(pfx1, false)
			    	ParticleManager:DestroyParticle(pfx2, false)
			    	ParticleManager:DestroyParticle(pfx3, false)
			    	local coffin = Entities:FindByNameNearest("DescentCoffin", Vector(10882, 7977, 178), 500)
			    	coffin:SetModelScale(2.15)
			    	coffin:SetModel("models/props_structures/coffin001.vmdl")
			    end)
			end)
			Timers:CreateTimer(7.3, function()
				UTIL_Remove(newWidow)
				EmitSoundOnLocationWithCaster(Vector(10882, 7977, 178), "Arena.Descent.CoffinClose", Events.GameMaster)
			end)
			Timers:CreateTimer(9, function()
				local walls = Entities:FindAllByNameWithin("WidowWall", Vector(10240, 7010, 200+Arena.ZFLOAT), 1000)
				Arena:PitWall(false, walls, true, 5.5)
				Arena:DescentRoom2()
				Timers:CreateTimer(4, function()
					local blockers = Entities:FindAllByNameWithin("WidowWallBlocker", Vector(10240, 7115, 131+Arena.ZFLOAT), 2000)
					for i = 1, #blockers, 1 do
						UTIL_Remove(blockers[i])
					end
				end)
			end)
			Timers:CreateTimer(10, function()
				Arena:SoulFerrierEvent()
			end)
		end)
	end)
	--SOUL FERRIER
end

function pit_tombstone_think(event)
	local caster = event.caster
	if not caster.summonTable then
		caster.summonTable = {}
		caster.totalSummons = 0
	end
	if #caster.summonTable > 9 then
		local newTable = {}
		for i = 1, #caster.summonTable, 1 do
			if IsValidEntity(caster.summonTable[i]) then
				table.insert(newTable, caster.summonTable[i])
			end
		end
		caster.summonTable = newTable	
		return
	end
	caster.totalSummons = caster.totalSummons + 1
	local itemRoll = 1
	if caster.totalSummons > 10 then
		itemRoll = 0
	end
	local bAggro = false
	if caster.aggro then
		bAggro = true
	end
	local loops = 1
	if Arena.PitLevel > 3 and Arena.PitLevel < 6 then
		loops = 2
	elseif Arena.PitLevel >= 6 then
		loops = 3
	end
	for i = 1, loops, 1 do
		local position = caster.summonCenter + RandomVector(RandomInt(1, 240))
		local zombie = Arena:SpawnTombstoneZombie(position, RandomVector(1), itemRoll, bAggro)
		if caster.totalSummons > 10 then
			zombie:SetDeathXP(0)
			zombie:SetMaximumGoldBounty(0)
			zombie:SetMinimumGoldBounty(0)
		end
		EmitSoundOn("Arena.Descent.ZombieSpawn", zombie)
		CustomAbilities:QuickAttachParticle("particles/econ/items/undying/undying_manyone/undying_pale_tombstone.vpcf", zombie, 3)
		FindClearSpaceForUnit(zombie, zombie:GetAbsOrigin(), false)
		table.insert(caster.summonTable, zombie)
	end
	local newTable = {}
	for i = 1, #caster.summonTable, 1 do
		if IsValidEntity(caster.summonTable[i]) then
			table.insert(newTable, caster.summonTable[i])
		end
	end
	caster.summonTable = newTable
end

function arena_horror_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if ability:IsFullyCastable() then
		local newOrder = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		AbilityIndex = ability:entindex(),
	 	}
		ExecuteOrderFromTable(newOrder)	
		return
	end
end

function arena_descent_gargoyles_summon(event)
	local caster = event.caster
	local ability = event.ability
	local loops = 3
	if Arena.PitLevel == 7 then
		loops = 5
	elseif Arena.PitLevel > 4 then
		loops = 4
	end

	for i = 1, loops, 1 do
		local gargoyle = Arena:SpawnGargoyle(caster:GetAbsOrigin()+RandomVector(RandomInt(100, 260)), caster:GetForwardVector())
		CustomAbilities:QuickAttachParticle("particles/econ/items/undying/undying_manyone/undying_pale_tombstone.vpcf", gargoyle, 2)
	end
	if caster:GetUnitName() == "arena_descent_terror_striker_ultra" then
		for j = 1, 8, 1 do
			Timers:CreateTimer(3.5*j, function()
				if IsValidEntity(caster) then
					if caster:IsAlive() then
						EmitSoundOn("Arena.Descent.SummonGargoyles", caster)
						for i = 1, loops, 1 do
							local gargoyle = Arena:SpawnGargoyle(caster:GetAbsOrigin()+RandomVector(RandomInt(100, 260)), caster:GetForwardVector())
							CustomAbilities:QuickAttachParticle("particles/econ/items/undying/undying_manyone/undying_pale_tombstone.vpcf", gargoyle, 2)
						end
					end
				end
			end)
		end
	end
	EmitSoundOn("Arena.Descent.SummonGargoyles", caster)	
end

function descent_beetle_take_damage(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_descent_beetle_effect", {duration = 4})
	local currentStacks = attacker:GetModifierStackCount("modifier_descent_beetle_effect", caster)
	attacker:SetModifierStackCount("modifier_descent_beetle_effect", caster, currentStacks+1)
end

function DescentGooBeetle1Trigger()
	local vectorTable = {Vector(7680, 2496), Vector(7680, 2752), Vector(7488, 3072), Vector(7488, 3392), Vector(7552, 3712), Vector(7902, 4160)}
	vectorTable = Arena:shuffle(vectorTable)
	for i = 1, #vectorTable, 1 do
		Timers:CreateTimer(0.8*i, function()
			local stone = Arena:SpawnDescentBeetle(vectorTable[i], Vector(-1,0), true)
			stone:SetAbsOrigin(vectorTable[i]-Vector(0,0,140))
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster)
		      ParticleManager:SetParticleControl( particle1, 0, vectorTable[i]+Vector(0,0,100) )
		      EmitSoundOn("Tanari.GooSplash", caster)
		      WallPhysics:Jump(stone, Vector(-1,0), RandomInt(11,13), RandomInt(36,40), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
end

function DescentGooBeetle2Trigger()
	Arena:DescentRoom3()
	local vectorTable = {Vector(9216, 1616), Vector(9472, 1856), Vector(9728, 2112), Vector(9920, 2496), Vector(9216, 1616), Vector(9472, 1856), Vector(9728, 2112), Vector(9920, 2496)}
	vectorTable = Arena:shuffle(vectorTable)
	for i = 1, #vectorTable, 1 do
		Timers:CreateTimer(1.4*i, function()
			local stone = Arena:SpawnDescentBeetle(vectorTable[i], Vector(1,-1), true)
			stone:SetAbsOrigin(vectorTable[i]-Vector(0,0,140))
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
		      ParticleManager:SetParticleControl( particle1, 0, vectorTable[i]+Vector(0,0,100) )
		      EmitSoundOn("Tanari.GooSplash", caster)
		      WallPhysics:Jump(stone, Vector(1,-1), RandomInt(11,13), RandomInt(36,40), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
end

function DescentZombieTriggers()
	for i = 1, 16+Arena.PitLevel, 1 do
		Timers:CreateTimer(0.3*i, function()
			local stone = Arena:SpawnDescentMiniSkeleton(Vector(14080, 192, 127), Vector(-1,-1), true)
			stone:SetAbsOrigin(Vector(14080, 192, 110))
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
		      ParticleManager:SetParticleControl( particle1, 0, Vector(14080, 192, 127) )
		      WallPhysics:Jump(stone, Vector(-1,-1), RandomInt(7,9), RandomInt(31,33), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
end

function DescentZombieTriggers2()
	for i = 1, 16+Arena.PitLevel, 1 do
		Timers:CreateTimer(0.3*i, function()
			local stone = Arena:SpawnDescentMiniSkeleton(Vector(13519, -1532, 127), Vector(-0.4,1), true)
			stone:SetAbsOrigin(Vector(13519, -1532, 110))
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
		      ParticleManager:SetParticleControl( particle1, 0, Vector(13519, -1532, 110) )
		      WallPhysics:Jump(stone, Vector(-0.4,1), RandomInt(7,9), RandomInt(31,33), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
end

function NemesisTrigger()
	if Arena.AllowNemesis then
		if not Arena.NemesisTriggerActivated then
			Arena.NemesisTriggerActivated = true
			Timers:CreateTimer(1, function()
				Arena:SpawnDescentNightmare(Vector(11584, -3264), Vector(1,-1))
			end)
			Timers:CreateTimer(5, function()
				Arena:SpawnDescentNightmare(Vector(14144, -3648), Vector(-1,-1))
			end)
			Timers:CreateTimer(10, function()
				Arena:SpawnDescentNightmare(Vector(12032, -5632), Vector(1,1))
			end)
			Timers:CreateTimer(15, function()
				Arena:SpawnDescentNightmare(Vector(13824, -5632), Vector(-1,1))
			end)
		end
	end
end

function nemesis_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 1
	end
	if caster.jumpEnd then
		return nil
	end
	caster.interval = caster.interval + 1
	if caster.interval == 20 then
		caster.interval = 1
		local dodgeAbility = caster:FindAbilityByName("arena_dodge_ability")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			dodgeAbility.dodgeUnit = enemies[1]
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = dodgeAbility:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
		end
	end
	--print("HELLO?")
	local boltAbility = caster:FindAbilityByName("arena_challenger_2_sword_dash")
	if boltAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = boltAbility:entindex(),
					TargetIndex = enemies[1]:entindex()
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
		end
		return
	end
end

function nemesis_die(event)
	if not Arena.NemesisKills then
		Arena.NemesisKills = 0
	end
	Arena.NemesisKills = Arena.NemesisKills + 1
	if Arena.NemesisKills == 4 then
		Arena.PitAbominationSpawnable = true
		local vectorTable = {Vector(13592, -5504, 136), Vector(12928, -4480, 136), Vector(14144, -4352, 136), Vector(12928, -3264, 136), Vector(11712, -3968, 136)}
		Timers:CreateTimer(1.5, function()
			for i = 1, #vectorTable, 1 do
				local stone = Arena:SpawnTombstone(vectorTable[i], Vector(1,0), vectorTable[i])
				Dungeons:AggroUnit(stone)
			end
		end)

		for j = 1, 300, 1 do
			Timers:CreateTimer(j*0.03, function()
				Arena.DescentBridge:SetAbsOrigin(Arena.DescentBridge:GetAbsOrigin()+Vector(0,0,0.91))
			end)
		end
		Timers:CreateTimer(9, function()
			local blockers = Entities:FindAllByNameWithin("DescentBridgeBlocker", Vector(10816, -3935, 127+Arena.ZFLOAT), 5000)
			for k = 1, #blockers, 1 do
				UTIL_Remove(blockers[k])
			end
			Arena:SpawnDescent3()
			EmitSoundOnLocationWithCaster(Vector(10816, -3935, 127+Arena.ZFLOAT), "Arena.WaterTemple.SwitchEnd", Arena.ArenaMaster)
			ScreenShake(Vector(10816, -3935, 127+Arena.ZFLOAT), 320, 0.2, 0.2, 9000, 0, true)

		end)
		Timers:CreateTimer(7, function()
			for i = 1, 16, 1 do
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
		      ParticleManager:SetParticleControl( particle1, 0, Vector(8375+(130*i), -3559, 120) )
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)		
			end
			for j = 1, 16, 1 do
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
		      ParticleManager:SetParticleControl( particle1, 0, Vector(8395+(130*j), -4258, 120) )
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)	
			end
		end)

		-- Timers:CreateTimer(3, function()
		-- 	local wall = Entities:FindByNameNearest("DescentWall2", Vector(12828, -6124, -101), 500)
		-- 	Arena:PitWall(false, {wall}, true, 6.5)
		-- 	Timers:CreateTimer(4.5, function()
		-- 		local blockers = Entities:FindAllByNameWithin("DescentBlocker2", Vector(12864, -6109, 128), 3000)
		-- 		for i = 1, #blockers, 1 do
		-- 			UTIL_Remove(blockers[i])
		-- 		end
		-- 	end)
		-- end)
	end
end

function DescentGooBeetle3Trigger()
	for i = 1, 9, 1 do
		Timers:CreateTimer(1.3*i, function()
			local position = Vector(8536+RandomInt(0, 1650), -3291)
			local stone = Arena:SpawnDescentBeetle(position, Vector(0,-1), true)
			stone:SetAbsOrigin(position-Vector(0,0,140))
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
		      ParticleManager:SetParticleControl( particle1, 0, position+Vector(0,0,100) )
		      EmitSoundOn("Tanari.GooSplash", caster)
		      WallPhysics:Jump(stone, Vector(0,-1), RandomInt(13,15), RandomInt(36,40), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
	Timers:CreateTimer(0.65, function()
		for i = 1, 9, 1 do
			Timers:CreateTimer(1.3*i, function()
				local position = Vector(8600+RandomInt(0, 1600), -4431)
				local stone = Arena:SpawnDescentBeetle(position, Vector(0,1), true)
				stone:SetAbsOrigin(position-Vector(0,0,140))
			      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
			      ParticleManager:SetParticleControl( particle1, 0, position+Vector(0,0,100) )
			      EmitSoundOn("Tanari.GooSplash", caster)
			      WallPhysics:Jump(stone, Vector(0,1), RandomInt(13,15), RandomInt(36,40), RandomInt(26,30), 1.2)
			      StartAnimation(stone, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.0})
			      Timers:CreateTimer(4, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)			
			end)
		end
	end)
end

function DescentZombieTriggers3()
	for i = 1, 12, 1 do
		Timers:CreateTimer(0.6*i, function()
			local stone = Arena:SpawnDescentMiniSkeleton(Vector(7420, -3347, 60), Vector(0.5,-1), true)
			stone:SetAbsOrigin(Vector(7420, -3347, 60))
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		      ParticleManager:SetParticleControl( particle1, 0, Vector(7420, -3347, 130) )
		      WallPhysics:Jump(stone, Vector(0.5,-1), RandomInt(7,9), RandomInt(31,33), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
	Timers:CreateTimer(0.3, function()
		for i = 1, 12, 1 do
			Timers:CreateTimer(0.6*i, function()
				local stone = Arena:SpawnDescentMiniSkeleton(Vector(8169, -4608, 100), Vector(-0.5,1), true)
				stone:SetAbsOrigin(Vector(8169, -4608, 100))
			      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			      ParticleManager:SetParticleControl( particle1, 0, Vector(8169, -4608, 140) )
			      WallPhysics:Jump(stone, Vector(-0.5,1), RandomInt(7,9), RandomInt(31,33), RandomInt(26,30), 1.2)
			      StartAnimation(stone, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
			      Timers:CreateTimer(4, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)			
			end)
		end
	end)
end

function descent_guard_passive_damage(event)
	local caster = event.caster
	local target = event.target
	local modifier = caster:FindModifierByName("modifier_descent_guard_passive_effect")
	if modifier then
		modifier:IncrementStackCount()
	end
	local particleName = "particles/econ/items/gyrocopter/hero_gyrocopter_atomic_gold/gyro_rocket_barrage_atomic_gold.vpcf"
    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(lightningBolt,1,caster:GetAbsOrigin()+Vector(0,0,100))  
    ParticleManager:SetParticleControl(lightningBolt,0,target:GetAbsOrigin() + Vector(0,0,target:GetBoundingMaxs().z ))
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBolt, true)
    end)     
end

function DescentGooBeetle4Trigger()
	for i = 1, 15, 1 do
		Timers:CreateTimer(0.6*i, function()
			local position = Vector(10112+RandomInt(0, 1500), -8256)
			local stone = Arena:SpawnDescentBeetle(position, Vector(0,1), true)
			stone:SetAbsOrigin(position-Vector(0,0,140))
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
		      ParticleManager:SetParticleControl( particle1, 0, position+Vector(0,0,100) )
		      EmitSoundOn("Tanari.GooSplash", caster)
		      WallPhysics:Jump(stone, Vector(0,1), RandomInt(13,15), RandomInt(36,40), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
	for i = 1, 12, 1 do
		Timers:CreateTimer(0.3*i, function()
			local stone = Arena:SpawnDescentMiniSkeleton(Vector(10816, -7009, 80), Vector(0,-1), true)
			stone:SetAbsOrigin(Vector(10816, -7009, 80))
		      particleName = "particles/addons_gameplay/green_goo_splash_blast.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		      ParticleManager:SetParticleControl( particle1, 0, Vector(10816, -7009, 140) )
		      WallPhysics:Jump(stone, Vector(0,-1), RandomInt(7,9), RandomInt(31,33), RandomInt(26,30), 1.2)
		      StartAnimation(stone, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
		      Timers:CreateTimer(4, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)			
		end)
	end
	Arena:SpawnDescentDoomBringerBig(Vector(14080, -8320), Vector(0,1))
end

function DescentBoss()
	Arena:CreateGooBlast(Vector(12416, -13568, 100))
	if Arena.PitAbominationSpawnable then
		if not Arena.DescentBossSpawned then
			Arena.DescentBossSpawned = true
			Arena:SpawnDescentBoss()
		end
	end
end

function DescentBossNotes()
	--Ravage
	--Poison Cloud
	--Slam ground (DECAY ANIMATION)
	--give bonus range for melees
end

function pit_descent_boss_think(event)
	local caster = event.caster
	if not caster:IsAlive() then
		return
	end
	if not caster.tombstonePhase then
		caster.tombstonePhase = 0
	end
	if caster:IsStunned() then
		caster:RemoveModifierByName("modifier_stunned")
	end
	local ability = event.ability
	local ravageAbility = caster:FindAbilityByName("arena_descent_boss_ravage")
	local casterLoc = caster:GetAbsOrigin()
	local gasPosition = Vector(casterLoc.x, casterLoc.y, 250) + RandomVector(RandomInt(900, 1600))
	if not caster:HasModifier("modifier_descent_boss_entering") then
		local extraDuration = 4 - (caster:GetHealth()/caster:GetMaxHealth())*4
		--ability:ApplyDataDrivenThinker(caster, gasPosition, "modifier_descent_poison_thinker", {duration = 6+extraDuration})
		CustomAbilities:QuickAttachThinker(ability, caster, gasPosition, "modifier_descent_poison_thinker", {duration = 6+extraDuration})
	end
	if ravageAbility:IsFullyCastable() and not caster.ravage and not caster:HasModifier("modifier_descent_boss_casting") and not caster:IsStunned() then
		caster.ravage = true
		StartAnimation(caster, {duration=1.6, activity=ACT_DOTA_UNDYING_TOMBSTONE, rate=0.7})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_descent_boss_casting", {duration = 1.4})
		EmitSoundOn("Arena.DescentBoss.Roar", caster)

		Timers:CreateTimer(1.5, function()
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = ravageAbility:entindex(),
		 	}
		 	
		 	
		 	-- StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_SPAWN, rate=1.0})
			ExecuteOrderFromTable(newOrder)	
			

		end)
		Timers:CreateTimer(2.0, function()
			caster.ravage = false
		end)
		return
	end
	local slamAbility = caster:FindAbilityByName("arena_descent_boss_fist_slam")
	if slamAbility:IsFullyCastable() and not caster.ravage and not caster:HasModifier("modifier_descent_boss_casting") and not caster:IsStunned() then
		caster.ravage = true

		local newOrder = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		 		Position = caster:GetAbsOrigin(),
		 		AbilityIndex = slamAbility:entindex(),
	 	}
	 	
		ExecuteOrderFromTable(newOrder)	
			
		Timers:CreateTimer(2.0, function()
			caster.ravage = false
		end)
		return
	end
	if caster:GetHealth() < caster:GetMaxHealth()*0.75 and caster.tombstonePhase == 0 then
		caster.tombstonePhase = 1
		StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_UNDYING_SOUL_RIP, rate=0.7})
		EmitSoundOn("Arena.DescentBoss.Roar2", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_descent_boss_casting", {duration = 1.2})
		Timers:CreateTimer(1, function()
			for i = 1, 3, 1 do
				local randomDirection = WallPhysics:rotateVector(caster:GetForwardVector(), 2*i*math.pi/3)
				local stone = Arena:SpawnTombstone(Vector(casterLoc.x, casterLoc.y, 150) + randomDirection*1000, RandomVector(1), Vector(casterLoc.x, casterLoc.y, 150)+randomDirection*1150)
				Dungeons:AggroUnit(stone)
				EmitSoundOn("Arena.Descent.ZombieSpawn", stone)
				CustomAbilities:QuickAttachParticle("particles/econ/items/undying/undying_manyone/undying_pale_tombstone.vpcf", stone, 3)
			end
		end)
	elseif caster:GetHealth() < caster:GetMaxHealth()*0.5 and caster.tombstonePhase == 1 then
		caster.tombstonePhase = 2
		StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_UNDYING_SOUL_RIP, rate=0.7})
		EmitSoundOn("Arena.DescentBoss.Roar2", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_descent_boss_casting", {duration = 1.2})
		Timers:CreateTimer(1, function()
			for i = 1, 4, 1 do
				local randomDirection = WallPhysics:rotateVector(caster:GetForwardVector(), 2*i*math.pi/4)
				local stone = Arena:SpawnTombstone(Vector(casterLoc.x, casterLoc.y, 150) + randomDirection*1000, RandomVector(1), Vector(casterLoc.x, casterLoc.y, 150)+randomDirection*1150)
				Dungeons:AggroUnit(stone)
				EmitSoundOn("Arena.Descent.ZombieSpawn", stone)
				CustomAbilities:QuickAttachParticle("particles/econ/items/undying/undying_manyone/undying_pale_tombstone.vpcf", stone, 3)
			end
		end)
	elseif caster:GetHealth() < caster:GetMaxHealth()*0.26 and caster.tombstonePhase == 2 then
		caster.tombstonePhase = 3
		StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_UNDYING_SOUL_RIP, rate=0.7})
		EmitSoundOn("Arena.DescentBoss.Roar2", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_descent_boss_casting", {duration = 1.2})
		Timers:CreateTimer(1, function()
			for i = 1, 5, 1 do
				local randomDirection = WallPhysics:rotateVector(caster:GetForwardVector(), 2*i*math.pi/5)
				local stone = Arena:SpawnTombstone(Vector(casterLoc.x, casterLoc.y, 150) + randomDirection*1000, RandomVector(1), Vector(casterLoc.x, casterLoc.y, 150)+randomDirection*1150)
				Dungeons:AggroUnit(stone)
				EmitSoundOn("Arena.Descent.ZombieSpawn", stone)
				CustomAbilities:QuickAttachParticle("particles/econ/items/undying/undying_manyone/undying_pale_tombstone.vpcf", stone, 3)
			end
		end)
	end
end

function descent_boss_impale_start(event)
	local caster = event.caster
	local ability = event.ability
	local casterLoc = caster:GetAbsOrigin()
	Timers:CreateTimer(1.25, function()
		Arena:CreateGooBlast(casterLoc+Vector(0,0,450))
		Timers:CreateTimer(0.5, function()
			for i = -2, 2, 1 do
				local rotatedVector = WallPhysics:rotateVector(Vector(1,0), 2*i*math.pi/4)
				Arena:CreateGooBlast(casterLoc+Vector(0,0,400)+rotatedVector*550)
			end
		end)
	end)
	for i = -6, 6, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), (2*math.pi/12)*i)
			local speed = 950
			local info = 
			{
					Ability = ability,
		        	EffectName = "particles/units/heroes/hero_lion/lion_spell_impale.vpcf",
		        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,80),
		        	fDistance = 1600,
		        	fStartRadius = 270,
		        	fEndRadius = 270,
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
end

function arena_descent_boss_fist_slam_start(event)
	local ability = event.ability
	local caster = event.caster
	local stun_duration = event.stun_duration
	local damage = event.damage
	local position = event.target_points[1]
	EmitSoundOn("Arena.DescentBoss.Roar3", caster)
	caster:FindAbilityByName("descent_boss_ai"):ApplyDataDrivenModifier(caster, caster, "modifier_descent_boss_casting", {duration = 2.4})
	StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_UNDYING_DECAY, rate=0.15})
	Timers:CreateTimer(1.95, function()
		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_UNDYING_DECAY, rate=1})
		Timers:CreateTimer(0.4, function()
			EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", caster)
			local particleName =  "particles/units/heroes/hero_elder_titan/doomguard_leap_effect.vpcf"
			local position = GetGroundPosition(caster:GetAbsOrigin()+caster:GetForwardVector()*1250, caster) + Vector(0,0,200)
			local particleVector = position

			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, particleVector )
			ParticleManager:SetParticleControl( pfx, 1, particleVector )
			ParticleManager:SetParticleControl( pfx, 2, particleVector )
			Timers:CreateTimer(1, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end)  
			ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = stun_duration})
				end
			end
		end)
	end)
end

function descent_boss_die(event)
	local caster = event.caster
	local casterLoc = caster:GetAbsOrigin()
	EmitSoundOn("Arena.DescentBoss.Death", caster)
	Timers:CreateTimer(0.5, function()
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
	end)
	Timers:CreateTimer(1, function()
		Arena:CreateGooBlast(casterLoc+Vector(0,0,450))
		Timers:CreateTimer(0.5, function()
			for i = -3, 3, 1 do
				local rotatedVector = WallPhysics:rotateVector(Vector(1,0), 2*i*math.pi/6)
				Arena:CreateGooBlast(casterLoc+Vector(0,0,400)+rotatedVector*550)
			end
		end)
	end)
	local luck = RandomInt(1,4)
	if luck == 1 then
		RPCItems:RollAndDropUniqueItem(caster, "item_rpc_basilisk_plague_helm")
	end
	Timers:CreateTimer(1.0, function()
		EmitGlobalSound("ui.set_applied")
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(11136, -14016, 158+Arena.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		Arena.DescentPortal = true
	end)
	if not Arena.PitBossesSlain then
		Arena.PitBossesSlain = 0
	end
	Arena.PitBossesSlain = Arena.PitBossesSlain + 1
	if Arena.PitBossesSlain == 3 then
		Arena:SpawnPitGuardian()
	end
end

function DescentPortal(trigger)
	local hero = trigger.activator
	if Arena.DescentPortal and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-1984, 8448)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function pure_strike_2_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*0.03
	local ability = event.ability
	ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	local key = target:GetEntityIndex() .. '_pure_strike_2_land'
    Util.Common:LimitPerTime(1, 1, key .. '_particles',function()
		EmitSoundOn("Arena.PureStrike2", target)
		local pfx = ParticleManager:CreateParticle( "particles/roshpit/creature/pure_strike_2_knightform.vpcf", PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, target:GetAbsOrigin())
		-- ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(1.0, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)
	end)
end

function pit_guardian_attack_start(event)
  local attacker = event.attacker
  local target = event.target
  local ability = event.ability
  local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
  
  if #enemies > 0 then
	for _,enemy in pairs(enemies) do
		Timers:CreateTimer(0.35, function()
			if enemy:GetEntityIndex() == target:GetEntityIndex() then
			else
				attacker:PerformAttack(enemy, true, true, true, true, true, false, false)
			end
			-- create_extra_guardian_attack(attacker, enemy, target, ability, "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
		end)
	end 
   end
end

function pit_guardian_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local blinkAbility = caster:FindAbilityByName("antimage_blink_custom")
			local castPoint = enemies[1]:GetAbsOrigin()+RandomVector(340)
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = blinkAbility:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)
		end
	end
end

function pit_guardian_die(event)
	local caster = event.caster
	EmitSoundOn("Arena.PitGuardian.Death", caster)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-719, 7628, 170+Arena.ZFLOAT), 200, 200, false)
	Timers:CreateTimer(1.0, function()
		EmitGlobalSound("ui.set_applied")
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-719, 7628, 170+Arena.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		Arena.FinalPortal = true
		Timers:CreateTimer(1, function()
			EmitSoundOnLocationWithCaster(Vector(-719, 7628, 170+Arena.ZFLOAT), "Arena.PitOfTrials.MusicHighlight", Arena.ArenaMaster)
		end)
	end)
	Arena:SpawnPitFinalBoss()
	local luck = RandomInt(1,5)
	if luck == 1 then
		if Arena.PitColor == "red" then
			RPCItems:RollRubyDragonScaleArmor(caster:GetAbsOrigin())
		elseif Arena.PitColor == "blue" then
			RPCItems:RollSapphireDragonScaleArmor(caster:GetAbsOrigin())
		elseif Arena.PitColor == "yellow" then
			RPCItems:RollTopazDragonScaleArmor(caster:GetAbsOrigin())
		end
	end
end

function PitFinalPortal(trigger)
	local hero = trigger.activator
	if Arena.FinalPortal and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(4224, -11264)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function pit_boss_take_damage(event)
	local caster = event.caster
	if not caster.intro then
		caster.dontCast = true
		CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
		CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.PitBossIntro"})
		caster:SetAcquisitionRange(3500)
		Events:AdjustBossPower(caster, 0, 0, true)
		caster.intro = true
		EmitSoundOn("Arena.PitBoss.IntroDialogue", caster)
		Arena:PitBossMusic()
		Timers:CreateTimer(5, function()
			caster.dontCast = false
		end)
		Arena.PitBossActive = true
	end
end

function pit_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.dontCast then
		return
	end
	if caster:HasModifier("modifier_pit_lord_charging") then
		return false
	end
	if caster.dying then
		return
	end
	if caster:GetHealth() < 1000 and caster:HasModifier("modifier_pit_boss_phase_2") then
		caster.dying = true
		pit_boss_final_death(caster, ability)
		return
	end
	if caster.intro then
		local fireAbility = caster:FindAbilityByName("pit_boss_firestorm")
		if fireAbility:IsFullyCastable() and not caster.castingStorm then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				caster.castingStorm = true
				Timers:CreateTimer(0.7, function()
					caster.castingStorm = false
				end)
				local castPoint = enemies[1]:GetAbsOrigin() + enemies[1]:GetForwardVector()*100
				caster.firestormPosition = castPoint
				--print(castPoint)
				caster.walking = false
				if not caster.castSound then
					caster.castSound = true
					EmitSoundOn("Arena.Pit.BossFirestorm", caster)
					Timers:CreateTimer(3.3, function()
						caster.castSound = false
					end)
				end
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = fireAbility:entindex(),
						Position = castPoint
				 	}
				 
				ExecuteOrderFromTable(newOrder)
				return true
			end
		end
		if caster:HasModifier("modifier_pit_boss_phase_2") then
			local boltAbility = caster:FindAbilityByName("arena_pit_boss_dash")
			if boltAbility:IsFullyCastable() then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
				if #enemies > 0 then
					local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							AbilityIndex = boltAbility:entindex(),
							TargetIndex = enemies[1]:entindex()
					 	}
					 
					ExecuteOrderFromTable(newOrder)			
				end
				return
			end
		end
		if caster:GetHealth() < caster:GetMaxHealth()*0.7 or caster:HasModifier("modifier_pit_boss_phase_2") then
			if not caster.summonTable then
				caster.summonTable = {}
			end
			local summonAbility = caster:FindAbilityByName("arena_pit_boss_summon_specters")
			if summonAbility:IsFullyCastable() and not caster.castingStorm then
				local newTable = {}
				for i = 1, #caster.summonTable, 1 do
					if IsValidEntity(caster.summonTable[i]) then
						table.insert(newTable, caster.summonTable[i])
					end
				end
				caster.summonTable = newTable
				if #caster.summonTable <= 10 then
					local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
							AbilityIndex = summonAbility:entindex(),
					 	}
					ExecuteOrderFromTable(newOrder)	
					return true	
				end	
			end
		end
		local hasteAbility = caster:FindAbilityByName("arena_pit_boss_haste")
		if hasteAbility:IsFullyCastable() and not caster.castingStorm then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hasteAbility:entindex(),
			 	}
			ExecuteOrderFromTable(newOrder)			
		end

	end
end

function pit_ability_cast(event)
	local caster = event.caster
	local abilityCast = event.event_ability

	if abilityCast:GetAbilityName() == "pit_boss_firestorm" then
		local point = GetGroundPosition(caster.firestormPosition, caster) + Vector(0,0,10)
		--print(point)
		local pfx = ParticleManager:CreateParticle("particles/roshpit/boss/pit_firestorm_indicator_portrait.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, point)
		ParticleManager:SetParticleControl(pfx, 1, point)
		ParticleManager:SetParticleControl(pfx, 2, point)		
		Timers:CreateTimer(7, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)	
	end
end

function pit_boss_haste_cast(event)
	local caster = event.caster
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.Pit.BossHasteVoice", Events.GameMaster)
	local fireAbility = caster:FindAbilityByName("pit_boss_firestorm")
	fireAbility:EndCooldown()
	caster:RemoveModifierByName("modifier_animation")
	caster:AddNewModifier(caster, nil, "modifier_animation", {translate="run", duration = 5})
	Timers:CreateTimer(5, function()
		caster:RemoveModifierByName("modifier_animation")
		caster:AddNewModifier(caster, nil, "modifier_animation", {translate="walk"})
	end)
end

function pit_boss_specter_summon_cast(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Arena.Pit.BossSummonSpecterMainCast", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", caster, 3)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.Pit.BossSummonSpellSound", caster)
	Timers:CreateTimer(1, function()
		for i = 1, 6, 1 do
			Timers:CreateTimer(0.5*i, function()
				if #caster.summonTable <= 12 then
					local stone = Arena:SpawnBossSpecter(caster:GetAbsOrigin()-caster:GetForwardVector()*200+RandomVector(120), caster:GetForwardVector(), true)
					EmitSoundOn("Arena.Pit.BossSummonSpecter", stone)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_spawn.vpcf", stone, 2.0)
					table.insert(caster.summonTable, stone)
				end
			end)
		end
	end)
end

function pit_boss_kill(event)
	local caster = event.caster
	local unit = event.unit
	if unit:IsHero() then
		EmitSoundOn("Arena.PitBoss.KillVoice", caster)
	end
end

function pit_boss_die_1(event)
	local caster = event.caster
	local deathLoc = caster:GetAbsOrigin()
	EmitSoundOn("Arena.Pit.BossSummonSpecterMainCast", caster)
	CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
	Arena.PitBossActive = false
		-- CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.PitBossIntro"})
	Timers:CreateTimer(2, function()
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
		for i = 1, 45, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,10))
			end)
		end
	end)
	Timers:CreateTimer(5, function()
		local boss = CreateUnitByName("arena_pit_of_trials_final_boss", deathLoc, true, nil, nil, DOTA_TEAM_NEUTRALS)
		boss:SetAbsOrigin(boss:GetAbsOrigin()-Vector(0,0,700))
		local bossFV = (Vector(4318, -13923) - boss:GetAbsOrigin()*Vector(1,1,0)):Normalized()
		if bossFV == Vector(0,0) then
			bossFV = Vector(1,0)
		end
		boss:SetForwardVector(bossFV)
		Arena:AddPitToUnit(boss)
		-- boss:SetAbsOrigin(Vector(-14826, -16121, 950))
		Events:AdjustDeathXP(boss)
		Events:AdjustBossPower(boss, 18, 18, false)
		Timers:CreateTimer(0.5, function()
			local bossAbility = boss:FindAbilityByName("arena_pit_final_boss_ai")
			bossAbility:SetLevel(3)
			bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_pit_boss_phase_2", {})
		end)
		
		-- boss:SetRenderColor(255,255,0)
		-- Arena:ColorWearables(boss, Vector(255,255,0))
		boss:AddAbility("boss_health"):SetLevel(1)
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, boss, "modifier_damage_resistance", {})
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, boss, "modifier_disable_player", {duration = 7.2})
		boss.damageReduc = 0.005
		boss:SetModelScale(1.7)
		boss:SetAcquisitionRange(3500)
		Timers:CreateTimer(1.5, function()
			boss.dontCast = true
			CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
			boss:SetAcquisitionRange(3500)
			Events:AdjustBossPower(boss, 0, 0, true)
			boss.intro = true
			Timers:CreateTimer(7, function()
				boss.dontCast = false
			end)
		end)
		Timers:CreateTimer(1, function()
			StartAnimation(boss, {duration=5.7, activity=ACT_DOTA_INTRO, rate=1.0})
			Timers:CreateTimer(0.05, function()
				boss:SetAbsOrigin(boss:GetAbsOrigin()+Vector(0,0,700))
			end)
			Timers:CreateTimer(2.05, function()
				EmitSoundOn("Arena.Pit.BossRespawnStartGrowl", boss)
			end)
			Timers:CreateTimer(1.9, function()
				for i = 1, 35, 1 do
					Timers:CreateTimer(i*0.03, function()
						if i <=30 then
							boss:SetAbsOrigin(boss:GetAbsOrigin()+Vector(0,0,15))
						else
							boss:SetAbsOrigin(boss:GetAbsOrigin()-Vector(0,0,90))
						end
					end)
				end
				Timers:CreateTimer(1.05, function()
					CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", boss, 3)
				end)
			end)
			Timers:CreateTimer(4.35, function()
				EmitSoundOn("Arena.Pit.BossRespawnAnger", boss)
				for i = 1, 5, 1 do
					Timers:CreateTimer(i*0.2, function()
						ScreenShake(boss:GetAbsOrigin(), 200, 0.4, 0.8, 9000, 0, true)
					end)
				end
			end)
			Timers:CreateTimer(6.4, function()
				EmitSoundOn("Arena.PitBoss.IntroDialoguePhase2", boss)
				boss:RemoveModifierByName("modifier_animation")
				boss:AddNewModifier(boss, nil, "modifier_animation", {translate="walk"})
			end)
			Timers:CreateTimer(3, function()
				EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", boss)
				EmitSoundOnLocationWithCaster(boss:GetAbsOrigin(), "Arena.Pit.BossRespawnAccent", Arena.ArenaMaster)
				local particleName =  "particles/units/heroes/hero_elder_titan/doomguard_leap_effect.vpcf"
				local position = boss:GetAbsOrigin()
				local particleVector = position

				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, boss )
				ParticleManager:SetParticleControl( pfx, 0, particleVector )
				ParticleManager:SetParticleControl( pfx, 1, particleVector )
				ParticleManager:SetParticleControl( pfx, 2, particleVector )
				Timers:CreateTimer(1, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				end)  
				ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
			end)
		end)
	end)
	Timers:CreateTimer(10, function()
		Arena.PitBossActive2 = true
		Arena:PitBossMusic2()
	end)
end

function pit_lord_sword_dash(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_pit_lord_charging", {duration = 6})
	ability.damage = event.damage
	local moveDirection = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
	local targetPosition = caster:GetAbsOrigin()+moveDirection*distance*2
	caster:MoveToPosition(targetPosition)
	ability.targetPosition = targetPosition
	caster.attacked = false
	caster:AddNewModifier( caster, nil, 'modifier_movespeed_cap', nil )
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_ms_thinker", {})
end

function pit_lord_dash_think(event)
	local caster = event.caster
	local ability = event.ability
	--print("HELLO?? WTF!!!")
	if caster.attacked then
		return
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 160, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	if #enemies > 0 then
		local enemy = enemies[1]
		EmitSoundOn("Arena.Challenger2.AttackCrit", enemy)
		caster:PerformAttack(enemy, true, true, false, true, false, false, false)
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=2.0})
		caster.attacked = true
		CustomAbilities:QuickAttachParticle("particles/roshpit/boss/pit_lord_strike.vpcf", enemy, 4)
		Timers:CreateTimer(1.2, function()
			caster:RemoveModifierByName("modifier_pit_lord_charging")
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
		ApplyDamage({ victim = enemy, attacker = caster, damage = event.ability.damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
	end
	if WallPhysics:GetDistance(caster:GetAbsOrigin(), event.ability.targetPosition) < 170 then
		caster:RemoveModifierByName("modifier_pit_lord_charging")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end
end

function pit_boss_final_death(caster, ability)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_pit_boss_dying", {})
	Arena.PitBossActive2 = false
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Arena.PitBoss.MainDeath1", caster)
	end)
	Timers:CreateTimer(1.5, function()
		CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text="Dungeon Clear!", duration=8.0})

	end)
	caster:BossDrops(15)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_pit_boss_dying_effect", {})
	local bossOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(9, function()
		Enemies:EnemySlain(caster, nil)
		Events:MainBossSlain(caster:GetUnitName())
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
		caster:RemoveModifierByName("modifier_pit_boss_dying")
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=8, activity=ACT_DOTA_DIE, rate=0.25})
			EmitSoundOn("Arena.PitBoss.MainDeath2", caster)
			for i = 1, 120, 1 do
				Timers:CreateTimer(i*0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-5))
					end
				end)
			end
			Timers:CreateTimer(6, function()
				UTIL_Remove(caster)
				Arena:DefeatPitBoss(bossOrigin)
			end)
		end)
	end)
	Timers:CreateTimer(10.5, function()
		Weapons:RollRandomLegendWeapon1(bossOrigin)
		if Arena.PitLevel >= 3 then
			Timers:CreateTimer(2, function()
				Weapons:RollRandomLegendWeapon1(bossOrigin)
			end)
		end
		if Arena.PitLevel >= 5 then
			Timers:CreateTimer(4, function()
				Weapons:RollRandomLegendWeapon1(bossOrigin)
			end)
		end
		if Arena.PitLevel == 7 then
			Timers:CreateTimer(6, function()
				Weapons:RollRandomLegendWeapon1(bossOrigin)
			end)
		end
		local particleName = "particles/bahamut/hyper_state_intro_omnislash_ascension_sparks.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.ArenaMaster )
		ParticleManager:SetParticleControl( particle1, 0, bossOrigin)
		Timers:CreateTimer(3, 
		function()
			ParticleManager:DestroyParticle( particle1, false )
		end)
		
	end)
	local luck = RandomInt(1,4)
	if luck == 1 then
		Timers:CreateTimer(RandomInt(2,5), function()
			RPCItems:RollHeroicConquerorVestments(bossOrigin, Arena.PitLevel)
		end)
	end
	Arena:UpdatePitLevels()
	Timers:CreateTimer(20, function()
	  	 Arena.PitActive = false
	  	 Arena.PitBossActive2 = false
	  	 Arena.PitBossActive = false
	  	 Arena:StartingMusic()
	  	 Arena:SpawnArenaOutsideEntities()
	end)
end

function pit_boss_dying_think(event)
	local caster = event.caster
	if not caster.flailEffect then
		caster.flailEffect = true
		StartAnimation(caster, {duration=8.5, activity=ACT_DOTA_FLAIL, rate=1.0})
	end
	CustomAbilities:QuickAttachParticleWithPoint("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", caster, 4, "attach_hitloc")
	EmitSoundOn("Arena.PitBoss.DeathPopSound", caster)
end

function rakash_die(event)
	local caster = event.caster
	local luck = RandomInt(1,5)
	if luck == 1 then
		RPCItems:RollSpiritualEmpowermentGlove(caster:GetAbsOrigin())
	end
end

function ultra_striker_die(event)
	local caster = event.caster
	local luck = RandomInt(1,4)
	if luck == 1 then
		RPCItems:RollGravekeepersGauntlet(caster:GetAbsOrigin())
	end
end

function ConquestCheckpointB(trigger)
	local hero = trigger.activator
	if not Arena.ConquestCheckpoint then
		Arena.ConquestCheckpoint = true
		local pedestal = Entities:FindByNameNearest("ConquestCheckpoint", Vector(-15248, 2464, 127+Arena.ZFLOAT), 500)
		local otherPedestal = Entities:FindByNameNearest("ConquestCheckpoint", Vector(-4183, 9332, 389+Arena.ZFLOAT), 500)
		EmitSoundOnLocationWithCaster(pedestal:GetAbsOrigin(), "Arena.Checkpoint.Activate", Arena.ArenaMaster)
		EmitSoundOnLocationWithCaster(otherPedestal:GetAbsOrigin(), "Arena.Checkpoint.Activate", Arena.ArenaMaster)
		for i = 1, 84, 1 do
			Timers:CreateTimer(i*0.03, function()
				pedestal:SetRenderColor(77+i*2, 77+i*2, 77+i*2)
				otherPedestal:SetRenderColor(77+i*2, 77+i*2, 77+i*2)
			end)
		end
		Timers:CreateTimer(2.6, function()
			EmitGlobalSound("ui.set_applied")
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", pedestal:GetAbsOrigin()-Vector(0,0,40), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", otherPedestal:GetAbsOrigin()-Vector(0,0,40), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		end)
		createCheckpointParticle(pedestal:GetAbsOrigin(), otherPedestal:GetAbsOrigin())
	else
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(-4183, 9332, 389+Arena.ZFLOAT)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function ConquestCheckpointA(trigger)
	local hero = trigger.activator
	if not Arena.ConquestCheckpoint then
	else
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(-15248, 2464, 127+Arena.ZFLOAT)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function PitCheckpointB(trigger)
	local hero = trigger.activator
	if not Arena.PitCheckpoint then
		Arena.PitCheckpoint = true
		local pedestal = Entities:FindByNameNearest("ConquestCheckpoint", Vector(8303, 11169, 157+Arena.ZFLOAT), 500)
		local otherPedestal = Entities:FindByNameNearest("ConquestCheckpoint", Vector(-2577, 10323, 389+Arena.ZFLOAT), 500)
		EmitSoundOnLocationWithCaster(pedestal:GetAbsOrigin(), "Arena.Checkpoint.Activate", Arena.ArenaMaster)
		EmitSoundOnLocationWithCaster(otherPedestal:GetAbsOrigin(), "Arena.Checkpoint.Activate", Arena.ArenaMaster)
		for i = 1, 84, 1 do
			Timers:CreateTimer(i*0.03, function()
				pedestal:SetRenderColor(77+i*2, 77+i*2, 77+i*2)
				otherPedestal:SetRenderColor(77+i*2, 77+i*2, 77+i*2)
			end)
		end
		Timers:CreateTimer(2.6, function()
			EmitGlobalSound("ui.set_applied")
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", pedestal:GetAbsOrigin()-Vector(0,0,40), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", otherPedestal:GetAbsOrigin()-Vector(0,0,40), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		end)
		createCheckpointParticle(pedestal:GetAbsOrigin(), otherPedestal:GetAbsOrigin())
	else
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(-2577, 10323, 389+Arena.ZFLOAT)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function PitCheckpointA(trigger)
	local hero = trigger.activator
	if not Arena.PitCheckpoint then
	else
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(8303, 11169, 157+Arena.ZFLOAT)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function DescentCheckpointB(trigger)
	local hero = trigger.activator
	if not Arena.DescentCheckpoint then
		Arena.DescentCheckpoint = true
		local pedestal = Entities:FindByNameNearest("ConquestCheckpoint", Vector(13918, -5683, 119+Arena.ZFLOAT), 500)
		local otherPedestal = Entities:FindByNameNearest("ConquestCheckpoint", Vector(-394, 9314, 389+Arena.ZFLOAT), 500)
		EmitSoundOnLocationWithCaster(pedestal:GetAbsOrigin(), "Arena.Checkpoint.Activate", Arena.ArenaMaster)
		EmitSoundOnLocationWithCaster(otherPedestal:GetAbsOrigin(), "Arena.Checkpoint.Activate", Arena.ArenaMaster)
		for i = 1, 84, 1 do
			Timers:CreateTimer(i*0.03, function()
				pedestal:SetRenderColor(77+i*2, 77+i*2, 77+i*2)
				otherPedestal:SetRenderColor(77+i*2, 77+i*2, 77+i*2)
			end)
		end
		Timers:CreateTimer(2.6, function()
			EmitGlobalSound("ui.set_applied")
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", pedestal:GetAbsOrigin()-Vector(0,0,40), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", otherPedestal:GetAbsOrigin()-Vector(0,0,40), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		end)
		createCheckpointParticle(pedestal:GetAbsOrigin(), otherPedestal:GetAbsOrigin())
	else
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(-394, 9314, 389+Arena.ZFLOAT)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function DescentCheckpointA(trigger)
	local hero = trigger.activator
	if not Arena.DescentCheckpoint then
	else
		if not hero:HasModifier("modifier_recently_teleported_portal") then
			local portToVector = Vector(13918, -5683, 119+Arena.ZFLOAT)
			Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function createCheckpointParticle(position1, position2)
	local positionTable = {position1, position2}
	for i = 1, #positionTable, 1 do
		local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_CUSTOMORIGIN, Arena.ArenaMaster)
		ParticleManager:SetParticleControl(pfx, 0, positionTable[i])
		Timers:CreateTimer(6, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function ferrier_unit_die(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	if unit.death_code == 1 then
		if not Arena.FerrierUnitsSlain then
			Arena.FerrierUnitsSlain = 0
		end
		Arena.FerrierUnitsSlain = Arena.FerrierUnitsSlain + 1
		if not Arena.FerrierPhaseComplete then
			local startPos = unit:GetAbsOrigin()
			local newTable = {}
			for i = 1, #Arena.FerrierGargoyleTable, 1 do
				local gargoyle_check = Arena.FerrierGargoyleTable[i]
				if gargoyle_check:GetEntityIndex() ~= unit:GetEntityIndex() then
					table.insert(newTable, gargoyle_check)
				end
			end
			--print("TBFDF!!")
			Arena.FerrierGargoyleTable = newTable
			Timers:CreateTimer(0.25, function()
				Arena:RemoveFerrierShield(startPos)
			end)
			if Arena.FerrierUnitsSlain == 30 then
				Arena.FerrierPhaseComplete = true
				StartAnimation(caster, {duration=5, activity=ACT_DOTA_TELEPORT, rate=1.0})
				EmitSoundOn("Arena.FerrierIntro1", caster)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", caster, 3)		
				Timers:CreateTimer(5, function()
					EmitSoundOn("Arena.FerrierIntro1", caster)
					StartAnimation(caster, {duration=3, activity=ACT_DOTA_SPAWN, rate=1.0})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", caster, 3)	
					Arena.FerrierGargoyleTable = {}
					for i = 1, 30, 1 do
						Timers:CreateTimer(i*0.2, function()
							local spawn_pos = caster:GetAbsOrigin() + RandomVector(RandomInt(800, 1200))
							local targetPosition = caster:GetAbsOrigin()+RandomVector(RandomInt(100, 400))
							Arena:SpawnFerrierGargoyle(spawn_pos, targetPosition)
						end)
					end	
					Timers:CreateTimer(6.0, function()
						caster:RemoveModifierByName("modifier_disable_player")
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_ferrier_in_combat_aura", {})
						caster.cantAggro = false
						Dungeons:AggroUnit(caster)
					end)				
				end)		
			end
		end

	end
end

function ferrier_gargoyle_think(event)
	local caster = event.caster
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 60, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
	if #allies > 0 then
		caster:MoveToPosition(caster:GetAbsOrigin()+RandomVector(RandomInt(60, 260)))
	end
end

function ferrier_think_aura(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = target:GetMaxHealth()*0.007
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })	
	caster:Heal(damage*10, caster)
end

function soul_ferrier_die(event)
	local caster = event.caster
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf", caster:GetAbsOrigin(), 3)
	for i = 1, #Arena.FerrierGargoyleTable, 1 do
		local gargoyle_open = Arena.FerrierGargoyleTable[i]
		ParticleManager:SetParticleControl(pfx, 1, gargoyle_open:GetAbsOrigin()+Vector(0,0,100))
		gargoyle_open:RemoveModifierByName("modifier_disable_player")
	end
	EmitSoundOn("Arena.FerrierShieldRemove.Scream", caster)
	EmitSoundOn("Arena.FerrierIntro3", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", caster, 3)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.SecretHorrorPianoEnd", Events.GameMaster)
	RPCItems:CreateBasicConsumable(caster:GetAbsOrigin(), "item_rpc_grimloks_soul_vessel", "Grimlok's Soul Vessel", "immortal", true)
end
function show_fighter_think(event)
	local target = event.target
	local enemy = target.opponent

	local arenaCenter = Vector(-2670, -2445)
	if WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), arenaCenter) > 2900 then
		local jumpFV = ((arenaCenter - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(target, jumpFV, 32, 30, 44, 1.4)
	end

	if target:GetUnitName() == "arena_show_fighter_one" then
		local breathefireAbil = target:FindAbilityByName("dragon_knight_breathe_fire")
		if breathefireAbil:IsFullyCastable() then
			local order =
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = breathefireAbil:entindex(),
				Position = target.opponent:GetAbsOrigin()
			}
			ExecuteOrderFromTable(order)
			return
		end
		local tailAbility = target:FindAbilityByName("dragon_knight_dragon_tail")
		if tailAbility:IsFullyCastable() then
			local newOrder = {
			 		UnitIndex = target:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = target.opponent:entindex(),
			 		AbilityIndex = tailAbility:entindex(),
		 	}
			ExecuteOrderFromTable(newOrder)	
			return
		end
	elseif target:GetUnitName() == "arena_show_fighter_two" then
		local hookAbil = target:FindAbilityByName("pudge_meat_hook")
		if hookAbil:IsFullyCastable() then
			local order =
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = hookAbil:entindex(),
				Position = target.opponent:GetAbsOrigin()
			}
			ExecuteOrderFromTable(order)
			return
		end
	end
	-- target:MoveToTargetToAttack(enemy)
	-- target:SetAttacking(enemy)
	local luck = RandomInt(1,4)
	if luck == 1 then
		local moveFV = ((target:GetAbsOrigin() - target.opponent:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(target, {duration=1.0, activity=target.jumpAnimation, rate=0.9})
		for i = 1, 20, 1 do
			Timers:CreateTimer(i*0.03, function()
				if IsValidEntity(target) then
					target:SetAbsOrigin(target:GetAbsOrigin()+moveFV*27)
				end
			end)
		end
		Timers:CreateTimer(0.7, function()
			if IsValidEntity(caster) then
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end
		end)
	end
	if IsValidEntity(enemy) and IsValidEntity(target) then
		target:MoveToPositionAggressive(enemy:GetAbsOrigin())
	end
end

function game_elemental_thinking(event)
	local elemental = event.target
	local basePos = Vector(-10944, -7232)
	local randomX = RandomInt(1,1080)
	local randomY = RandomInt(1,1000)	
	
	Arena.WaterMagician.gameAbility:ApplyDataDrivenModifier(Arena.WaterMagician, elemental, "modifier_game_elemental_increase_ms", {})
	local stacks = elemental:GetModifierStackCount("modifier_game_elemental_increase_ms", Arena.WaterMagician)
	elemental:SetModifierStackCount("modifier_game_elemental_increase_ms", Arena.WaterMagician, stacks+1)
	local maxBound = math.max(40-stacks, 4)
	local luck = RandomInt(1, maxBound)
	if not elemental.stopWaveForm then
		if luck == 1 then
			local waveform = elemental:FindAbilityByName("arena_elemental_waveform")
			local order =
			{
				UnitIndex = elemental:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = waveform:entindex(),
				Position = basePos+Vector(randomX, randomY)
			}
			ExecuteOrderFromTable(order)
		else
			elemental:MoveToPosition(basePos+Vector(randomX, randomY))
		end
	else
		elemental:MoveToPosition(basePos+Vector(randomX, randomY))
	end
end

function game_elemental_attacked(event)
	local elemental = event.target
	local attacker = event.attacker
	if Arena.WaterMagician.validHero == -1 then
		return
	end
	if attacker:GetEntityIndex() == Arena.WaterMagician.validHero then
		EmitSoundOn("Arena.Hint", elemental)
		Arena.WaterMagician.validHero = -1
		EmitSoundOnLocationWithCaster(Vector(-10560, -6720), "Arena.DrumRoll", Arena.ArenaMaster)
		for i = 1, #Arena.gameElementalTable, 1 do
			local elementalLoop = Arena.gameElementalTable[i]
			Arena.WaterMagician.gameAbility:ApplyDataDrivenModifier(Arena.WaterMagician, elementalLoop, "modifier_elemental_moving", {})
		end
		for i = 1, 83, 1 do
			Timers:CreateTimer(i*0.03, function()
				elemental:SetRenderColor(255-(i*2), 255-(i*2), 255)
			end)
		end
		Timers:CreateTimer(85*0.03, function()
			if elemental.real then
				EmitSoundOn("Arena.Tada", elemental)
				elemental:SetRenderColor(0, 255, 0)
				Timers:CreateTimer(1, function()
					-- EmitSoundOn("Arena.GameElementalUnsummon", elemental)
					for i = 1, #Arena.gameElementalTable, 1 do
						local elementalLoop = Arena.gameElementalTable[i]
						if elementalLoop.real then
							Arena.WaterMagician.realElemental = elementalLoop
						else
							StartAnimation(elementalLoop, {duration=1.7, activity=ACT_DOTA_DIE, rate=0.9})
							Timers:CreateTimer(1.6, function()
								UTIL_Remove(elementalLoop)
							end)
							local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_morphling/morphling_death.vpcf", PATTACH_CUSTOMORIGIN, elementalLoop)
							ParticleManager:SetParticleControl(pfx, 0, elementalLoop:GetAbsOrigin()+Vector(0,0,20))
							Timers:CreateTimer(1.5, function()
								ParticleManager:DestroyParticle(pfx, false)
							end)
						end
					end
				end)
				Timers:CreateTimer(3, function()
					local position = Arena.WaterMagician.realElemental:GetAbsOrigin()
					EmitSoundOn("Arena.GameElementalUnsummon", Arena.WaterMagician.realElemental)
					StartAnimation(Arena.WaterMagician.realElemental, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_6, rate=0.6})
					Timers:CreateTimer(1.0, function()
						UTIL_Remove(Arena.WaterMagician.realElemental)
					end)
					Timers:CreateTimer(1.1, function()
						Arena.WaterMagician:SetAbsOrigin(position)
						Timers:CreateTimer(0.15, function()
							Arena.WaterMagician:RemoveNoDraw()
						end)
						Arena.WaterMagician:SetModelScale(0.1)
						for i = 1, 30, 1 do
							Timers:CreateTimer(i*0.05, function()
								Arena.WaterMagician:SetModelScale(0.1+i*0.03)
							end)
						end
						StartAnimation(Arena.WaterMagician, {duration=1.7, activity=ACT_DOTA_SPAWN, rate=0.9})
						-- EmitSoundOn("Arena.GameElementalUnsummon", Arena.WaterMagician)
						local fv = ((attacker:GetAbsOrigin()-position)*Vector(1,1,0)):Normalized()
						Arena.WaterMagician:SetForwardVector(fv)
						local pfx = ParticleManager:CreateParticle("particles/world_environmental_fx/water_splash_rocks_generic.vpcf", PATTACH_CUSTOMORIGIN, Arena.WaterMagician)
						ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,20))
						Timers:CreateTimer(2.4, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
						Arena:GetMithrilPrize(Vector(-10304, -6731), attacker, 200)
						Arena:basic_dialogue(Arena.WaterMagician, {attacker}, dialogueName, 10, 5, -30)
						Timers:CreateTimer(1, function()
							local dialogueName = "aquatarium_win_"..RandomInt(1,3)
							Arena.WaterMagician:MoveToPosition(Vector(-10304, -6731))
							
							Timers:CreateTimer(0.2, function()
								EmitSoundOn("Arena.MagicianGrumble", Arena.WaterMagician)
							end)
							Timers:CreateTimer(4, function()
								Arena.WaterMagician.gameStart = false
							end)
						end)
					end)
					
				end)
			else
				EmitSoundOn("Arena.Error", elemental)
				elemental:SetRenderColor(255, 0, 0)
				Timers:CreateTimer(1.5, function()
					for i = 1, #Arena.gameElementalTable, 1 do
						Timers:CreateTimer(0.25*i, function()
							local elementalLoop = Arena.gameElementalTable[i]
							if elementalLoop.real then
								Arena.WaterMagician.realElemental = elementalLoop
							else
								EmitSoundOn("Arena.GameElementalUnsummon", elementalLoop)
								StartAnimation(elementalLoop, {duration=1.7, activity=ACT_DOTA_DIE, rate=0.9})
								Timers:CreateTimer(1.6, function()
									UTIL_Remove(elementalLoop)
								end)
								local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_morphling/morphling_death.vpcf", PATTACH_CUSTOMORIGIN, elementalLoop)
								ParticleManager:SetParticleControl(pfx, 0, elementalLoop:GetAbsOrigin()+Vector(0,0,20))
								Timers:CreateTimer(1.5, function()
									ParticleManager:DestroyParticle(pfx, false)
								end)
							end
						end)
					end
					Timers:CreateTimer(#Arena.gameElementalTable*0.25 + 2.0, function()
						local position = Arena.WaterMagician.realElemental:GetAbsOrigin()
						EmitSoundOn("Arena.GameElementalUnsummon", Arena.WaterMagician.realElemental)
						StartAnimation(Arena.WaterMagician.realElemental, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_6, rate=0.6})
						Timers:CreateTimer(1.0, function()
							UTIL_Remove(Arena.WaterMagician.realElemental)
						end)
						Timers:CreateTimer(1.1, function()
							Arena.WaterMagician:SetAbsOrigin(position)
							Timers:CreateTimer(0.15, function()
								Arena.WaterMagician:RemoveNoDraw()
							end)
							Arena.WaterMagician:SetModelScale(0.1)
							for i = 1, 30, 1 do
								Timers:CreateTimer(i*0.05, function()
									Arena.WaterMagician:SetModelScale(0.1+i*0.03)
								end)
							end
							StartAnimation(Arena.WaterMagician, {duration=1.7, activity=ACT_DOTA_SPAWN, rate=0.9})
							EmitSoundOn("Arena.GameElementalUnsummon", Arena.WaterMagician)
							local fv = ((attacker:GetAbsOrigin()-position)*Vector(1,1,0)):Normalized()
							Arena.WaterMagician:SetForwardVector(fv)
							local pfx = ParticleManager:CreateParticle("particles/world_environmental_fx/water_splash_rocks_generic.vpcf", PATTACH_CUSTOMORIGIN, Arena.WaterMagician)
							ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,20))
							Timers:CreateTimer(2.4, function()
								ParticleManager:DestroyParticle(pfx, false)
							end)
							Timers:CreateTimer(1, function()
								Arena:basic_dialogue(Arena.WaterMagician, {attacker}, "aquatarium_lose", 10, 5, -30)
								Arena.WaterMagician:MoveToPosition(Vector(-10304, -6731))
								Timers:CreateTimer(0.2, function()
									EmitSoundOn("Arena.MagicianLaugh", Arena.WaterMagician)
								end)
								Timers:CreateTimer(4, function()
									Arena.WaterMagician.gameStart = false
								end)
							end)
						end)
						
					end)
				end)
			end
			
		end)
	end
end

function arena_guard_moving_think(event)

	local target = event.target
	local caster = event.caster
	if not IsValidEntity(caster) then
		target:RemoveModifierByName("modifier_arena_guard_lock")
		target:RemoveModifierByName("modifier_arena_guard_moving")
		return
	end
	local targetPoint = caster.pushToPosition
	local fv = ((targetPoint-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), targetPoint*Vector(1,1,0))
	target:SetAbsOrigin(target:GetAbsOrigin()+fv*7)
	if distance < 150 then
		target:RemoveModifierByName("modifier_arena_guard_lock")
		target:RemoveModifierByName("modifier_arena_guard_moving")
		caster:SetForwardVector(caster.origFv)
	end
end

function stun_think_for_crowd(unit, bFromL)
	
	if unit:IsStunned() then
		if not unit.stunCounter then
			unit.stunCounter = 0
		end
		unit.stunCounter = unit.stunCounter + 1
		if unit.stunCounter > 13 then
			local luck = RandomInt(1,5)
			pullCrowd(bFromL, 1)
		elseif unit.stunCounter > 24 then
			local luck = RandomInt(1,3)
			pullCrowd(bFromL, 1)
		end
	else
		unit.stunCounter = 0
	end
end

function pullCrowd(bFromL, amount)
	-- if Arena.CheerLock then
	-- 	return false
	-- end
	if Arena.BetweenBattles then
		return false
	end
	local crowdSize = Arena.crowdSizeL + Arena.crowdSizeR
	if bFromL then
		amount = math.min(amount, Arena.crowdSizeL)
	else
		amount = math.min(amount, Arena.crowdSizeR)
	end
	if bFromL then
		Arena.crowdSizeL = Arena.crowdSizeL - amount
		Arena.crowdSizeR = Arena.crowdSizeR + amount
	else
		Arena.crowdSizeL = Arena.crowdSizeL + amount
		Arena.crowdSizeR = Arena.crowdSizeR - amount
	end
	if amount == 1 then
		EmitSoundOnLocationWithCaster(Vector(-2670, -2445)+RandomVector(500), "Arena.Cheer1", Arena.ArenaMaster)
	elseif amount == 2 then
		EmitSoundOnLocationWithCaster(Vector(-2670, -2445)+RandomVector(500), "Arena.Cheer2", Arena.ArenaMaster)
	elseif amount == 3 or amount == 4 then
		EmitSoundOnLocationWithCaster(Vector(-2670, -2445)+RandomVector(500), "Arena.Cheer3", Arena.ArenaMaster)
	elseif amount >= 5 then
		EmitSoundOnLocationWithCaster(Vector(-2670, -2445)+RandomVector(500), "Arena.Cheer4", Arena.ArenaMaster)
	end
	-- if amount > 0 then
	-- 	Arena.CheerLock = true
	-- 	Timers:CreateTimer(1, function()
	-- 		Arena.CheerLock = false
	-- 	end)
	-- end
	CustomGameEventManager:Send_ServerToAllClients("update_crowd_favor", {crowdSizeL = Arena.crowdSizeL, crowdSizeR = Arena.crowdSizeR})
end


function enemy_basic_arena_think(event)
	if Arena.BetweenBattles then
		return
	end
	local target = event.target
	stun_think_for_crowd(target, true)
	if Arena.bo then
		if Arena.crowdSizeR > 0 then
			Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, target, "modifier_arena_crowd_buff", {})
			target:SetModifierStackCount("modifier_arena_crowd_buff", Arena.ArenaMasterAbility, Arena.crowdSizeR)
		else
			target:RemoveModifierByName("modifier_arena_crowd_buff")
		end
	end
	if target:GetUnitName() == "champion_league_challenger_20" then
		challenger20ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_19" then
		challenger19ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_18" then
		challenger18ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_17" then
		challenger17ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_16" then
		challenger16ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_15" then
		challenger15ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_14" then
		challenger14ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_13" then
		challenger13ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_12" then
		challenger12ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_10" then
		challenger10ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_9" then
		challenger9ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_8" then
		challenger8ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_7" then
		challenger7ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_6" then
		challenger6ai(target)
	elseif target:GetUnitName() == "arena_nightmare_boss" then
		nightmareBossAi(target)
	elseif target:GetUnitName() == "champion_league_challenger_6_battle" then
		nightmareBossAi2(target)
	elseif target:GetUnitName() == "champion_league_challenger_5" then
		challenger5ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_4" then
		challenger4ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_3_a" then
		challenger3ai_a(target)
	elseif target:GetUnitName() == "champion_league_challenger_2" then
		challenger2ai(target)
	elseif target:GetUnitName() == "champion_league_challenger_1" then
		challenger1ai(target)
	end
	if not Arena.Nightmare then
		local arenaCenter = Vector(-2670, -2445)
		if WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), arenaCenter) > 2850 then
			local jumpFV = ((arenaCenter - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(target, jumpFV, 32, 30, 44, 1.4)
		end
	end
	if IsValidEntity(target) then
		CustomGameEventManager:Send_ServerToAllClients("update_arena_HP", {side = "R", currentHealth=target:GetHealth(), maxHealth = target:GetMaxHealth()})
	end
end

function player_basic_arena_think(event)
	if Arena.BetweenBattles then
		return
	end
	local target = event.target
	stun_think_for_crowd(target, false)
	if target:IsMagicImmune() then
		local luck = RandomInt(1, 5)
		if luck == 1 then
			pullCrowd(true, 1)
		end
	end
	if Arena.bo then
		if Arena.crowdSizeL > 0 then
			Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, target, "modifier_arena_crowd_buff", {})
			target:SetModifierStackCount("modifier_arena_crowd_buff", Arena.ArenaMasterAbility, Arena.crowdSizeL)
		else
			target:RemoveModifierByName("modifier_arena_crowd_buff")
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("update_arena_HP", {side = "L", currentHealth=target:GetHealth(), maxHealth = target:GetMaxHealth()})
end

function player_basic_arena_die(event)
	local caster = event.unit
	local enemy = Arena.ChampionsLeagueOpponent
	Timers:CreateTimer(0.5, function()
		if caster:IsAlive() then
			return false
		end
		if Arena.Nightmare then
			Timers:CreateTimer(4, function()
				Arena:CleanUpNightmareScene()
				clearSummons(enemy)
			end)
		end
		Arena:StopBattleTimer()
		local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
		StartAnimation(enemy, {duration=4.0, activity=ACT_DOTA_VICTORY, rate=0.9})
		gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, enemy, "modifier_command_restric_player", {duration = 6})
		EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Arena.Cheer2", Events.GameMaster)
		Timers:CreateTimer(5, function()
			Arena.scoreR = Arena.scoreR + 1
			
			CustomGameEventManager:Send_ServerToAllClients("arena_fade_to_black", {fadeBackDelay=2.2})
			CustomGameEventManager:Send_ServerToAllClients("arena_update_bo", {scoreL = Arena.scoreL, scoreR = Arena.scoreR})
			Timers:CreateTimer(0.7, function()
				PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
				caster:RespawnHero(false, false)
				Timers:CreateTimer(1, function()
					enemy:Heal(enemy:GetMaxHealth(), enemy)
					FindClearSpaceForUnit(caster, Vector(-3328, -2432), false)
					caster:SetForwardVector(Vector(1,0))	
					FindClearSpaceForUnit(enemy, Vector(-2109, -2432), false)
					enemy:SetForwardVector(Vector(-1,0))
					Timers:CreateTimer(1, function()
						enemy:SetForwardVector(Vector(-1,0))
						PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), nil)
					end)
				end)
			end)
			if Arena.scoreR > Arena.bo/2 then
				clearSummons(enemy)
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.ChampionsLeague.Lose", Events.ArenaMaster)
				Timers:CreateTimer(1.75, function()
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_command_restric_player", {duration = 10})
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, enemy, "modifier_command_restric_player", {duration = 10})
					Arena:ChampionsLeagueStatsScreen(caster, false)
					Timers:CreateTimer(10, function()
						PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
						CustomGameEventManager:Send_ServerToAllClients("arena_fade_to_black", {fadeBackDelay=1.5})
						Timers:CreateTimer(0.7, function()
							Arena:LoseChampionsLeague(caster)
							FindClearSpaceForUnit(caster, Vector(-2752, -8960), false)
						end)
					end)
				end)
			else
				Timers:CreateTimer(1.75, function()
					Arena:ArenaStartSequence()
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_command_restric_player", {duration = 5})
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, enemy, "modifier_command_restric_player", {duration = 5})
					Timers:CreateTimer(5, function()
						Arena:StartBattleTimer()
					end)
				end)
			end
		end)
	end)
end

function enemy_basic_arena_die(event)
	local caster = MAIN_HERO_TABLE[1]
	local enemy = Arena.ChampionsLeagueOpponent
	if enemy.bro then
		if IsValidEntity(enemy.bro) then
			if enemy.bro:IsAlive() then
				ApplyDamage({ victim = enemy.bro, attacker = Arena.ArenaMaster, damage = enemy.bro:GetMaxHealth()*1000, damage_type = DAMAGE_TYPE_PURE })
			end
		end
	end
	Timers:CreateTimer(0.2, function()
		if Arena.Nightmare then
			Arena.scoreL = 1
			UTIL_Remove(enemy)
			Arena:CleanUpNightmareScene()
		end
		Arena:StopBattleTimer()
		local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
		StartAnimation(caster, {duration=4.0, activity=ACT_DOTA_VICTORY, rate=0.9})
		gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_command_restric_player", {duration = 6})
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.Cheer2", Events.GameMaster)
		Timers:CreateTimer(5, function()
			Arena.scoreL = Arena.scoreL + 1
			
			CustomGameEventManager:Send_ServerToAllClients("arena_fade_to_black", {fadeBackDelay=2.2})
			CustomGameEventManager:Send_ServerToAllClients("arena_update_bo", {scoreL = Arena.scoreL, scoreR = Arena.scoreR})
			Timers:CreateTimer(0.7, function()
				PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
				Timers:CreateTimer(1, function()
					Arena:SpawnEnemyForRank(Arena.ChampionsLeague.currentBattleRank)
					local enemy = Arena.ChampionsLeagueOpponent
					Arena.ChampionsLeagueOpponent.opponent = caster
					FindClearSpaceForUnit(caster, Vector(-3328, -2432), false)
					FindClearSpaceForUnit(enemy, Vector(-2109, -2432), false)
					Timers:CreateTimer(1, function()
						enemy:SetForwardVector(Vector(-1,0))
						caster:SetForwardVector(Vector(1,0))	
						PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), nil)
					end)
				end)
			end)
			if Arena.scoreL > Arena.bo/2 then
				clearSummons(enemy)
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.ChampionsLeague.Lose", Events.ArenaMaster)
				Timers:CreateTimer(1.75, function()
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_command_restric_player", {duration = 10})
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, enemy, "modifier_command_restric_player", {duration = 10})
					Arena:ChampionsLeagueStatsScreen(caster, true)
					Timers:CreateTimer(10, function()
						PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
						CustomGameEventManager:Send_ServerToAllClients("arena_fade_to_black", {fadeBackDelay=1.5})
						Timers:CreateTimer(0.7, function()
							Arena:WinChampionsLeague(caster)
						end)
					end)
				end)
			else
				Timers:CreateTimer(1.75, function()
					local enemy = Arena.ChampionsLeagueOpponent
					Arena:ArenaStartSequence()
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_command_restric_player", {duration = 5})
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, enemy, "modifier_command_restric_player", {duration = 2})
					Timers:CreateTimer(0.05, function()
						Arena.ChampionsLeagueOpponent:SetAcquisitionRange(5000)
					end)
					Timers:CreateTimer(5, function()
						Arena:StartBattleTimer()
						Arena.ChampionsLeagueOpponent:RemoveModifierByName("modifier_command_restric_player")
					end)
				end)
			end
		end)
	end)
end

function clearSummons(enemy)
	if enemy.summonTable then
		for i = 1, #enemy.summonTable, 1 do
			if IsValidEntity(enemy.summonTable[i]) then
				UTIL_Remove(enemy.summonTable[i])
			end
		end
	end
end

function challenger20ai(caster)
	local waveAbility = caster:FindAbilityByName("arena_rekkin_wave")
	local luck = RandomInt(1,7)
	if luck == 1 then
		if waveAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = waveAbility:entindex(),
						Position = castPoint
				 	}
				local soundChance = RandomInt(1,3)
				if soundChance then
					EmitSoundOn("Arena.Rekkin.Growl", caster)
				end
				ExecuteOrderFromTable(newOrder)			
			end
			return
		end
	end
	local luck = RandomInt(1,5)
	if luck == 1 then
		local dodgeAbility = caster:FindAbilityByName("arena_dodge_ability")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 740, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
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
	local surgeAbility = caster:FindAbilityByName("dark_seer_surge")
	if surgeAbility:IsFullyCastable() then
		local newOrder = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		 		TargetIndex = caster:entindex(),
		 		AbilityIndex = surgeAbility:entindex(),
	 	}
		ExecuteOrderFromTable(newOrder)			
	end
end

function challenger19ai(caster)
	local blinkAbility = caster:FindAbilityByName("arena_phantom_strike")
	local luck = RandomInt(1,4)
	if luck == 1 then
		if blinkAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = blinkAbility:entindex(),
						TargetIndex = enemies[1]:entindex()
				 	}
				 
				ExecuteOrderFromTable(newOrder)			
			end
			return
		end
	end
	local stifling = caster:FindAbilityByName("arena_stifling_dagger")
	if stifling:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local distance = WallPhysics:GetDistance(enemies[1]:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
			if distance > 500 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = stifling:entindex(),
						TargetIndex = enemies[1]:entindex()
				 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return		
			end
		end	
	end
end

function challenger18ai(caster)
	local blinkAbility = caster:FindAbilityByName("water_temple_boulder_toss")
	local luck = RandomInt(1, 20)
	if luck == 1 then
		EmitSoundOn("Arena.Ogre.Angry", caster)
	end
	if blinkAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 975, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = blinkAbility:entindex(),
					TargetIndex = enemies[1]:entindex()
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=1.0})		
		end
		return
	end
end

function challenger17ai(caster)
	local ability = caster:FindAbilityByName("arena_challenger_17_ability")
	if not caster.summonsUp then
		caster.summonsUp = 3
		StartAnimation(caster, {duration=2.9, activity=ACT_DOTA_VICTORY, rate=1.0})
		Events:SoftFloat(1.5, 2.5, 0.1, caster)
		EmitSoundOn("Arena.Champion17.Grunt", caster)
		Timers:CreateTimer(3.1, function()
			pullCrowd(true, 5)
			EmitSoundOn("Arena.Champion17.Summon", caster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.Champion17.SummonEffect", Events.GameMaster)
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
			local earthElement = CreateUnitByName("arena_league_challenger_17_earth", caster:GetAbsOrigin()+caster:GetForwardVector()*200, true, nil, nil, caster:GetTeamNumber())
			local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), -2*math.pi/3)
			local fireElement = CreateUnitByName("arena_league_challenger_17_fire", caster:GetAbsOrigin()+rotatedFV*200, true, nil, nil, caster:GetTeamNumber())
			rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/3)
			local airElement = CreateUnitByName("arena_league_challenger_17_air", caster:GetAbsOrigin()+rotatedFV*200, true, nil, nil, caster:GetTeamNumber())
			local elementTable = {fireElement, airElement, earthElement}
			caster.summonTable = elementTable
			for i = 1, #elementTable, 1 do
				elementTable[i]:SetForwardVector(caster:GetForwardVector())
				elementTable[i].summoner = caster
				elementTable[i]:AddAbility("arena_challenger_17_summon_ability")
				elementTable[i]:SetAcquisitionRange(5000)
				Events:AdjustDeathXP(elementTable[i])
				Events:AdjustBossPower(elementTable[i], 3, 10)
			end
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split.vpcf", caster, 3)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", fireElement, 2)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", earthElement, 2)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", airElement, 2)
		end)
	return
	end
	if not caster:IsRooted() then
		local luck = RandomInt(1,5)
		if luck == 1 then
			local dodgeAbility = caster:FindAbilityByName("arena_dodge_ability")
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1440, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
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
	end
	local clapAbility = caster:FindAbilityByName("arena_thunder_clap")
	if clapAbility:IsFullyCastable() and not caster:IsRooted() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = clapAbility:entindex(),
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
		end
	end
	if caster.summonsUp == 0 then
		caster:RemoveModifierByName("modifier_challenger_17_immune")
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_challenger_17_immune", {})
	end

end

function challenger16ai(caster)
	local stompAbility = caster:FindAbilityByName("fire_temple_hoof_stomp")
	if stompAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		DeepPrintTable(enemies)
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = stompAbility:entindex(),
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			pullCrowd(true, 1)
		end
		return
	end
end

function challenger15ai(caster)
	local windwalkAbility = caster:FindAbilityByName("clinkz_wind_walk")
	if windwalkAbility:IsFullyCastable() then
		local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = windwalkAbility:entindex(),
		 	}
		 
		ExecuteOrderFromTable(newOrder)	
		pullCrowd(true, 1)
		return
	end
	local luck = RandomInt(1,3)
	if luck == 1 then
		local strikeAbility = caster:FindAbilityByName("fire_temple_shadow_strike")
		if strikeAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1040, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = strikeAbility:entindex(),
						TargetIndex = enemies[1]:entindex()
				 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return
			end
		end
	end
	local stompAbility = caster:FindAbilityByName("arena_riki_ult")
	if stompAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		DeepPrintTable(enemies)
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = stompAbility:entindex(),
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			pullCrowd(true, 1)
		end
		return
	end
	local luck = RandomInt(1,8)
	if luck == 1 then
		local jumpAbility = caster:FindAbilityByName("arena_dodge_ability")
		if jumpAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				jumpAbility.dodgeUnit = enemies[1]
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = jumpAbility:entindex(),
				 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return
			end
		end
	end

	
end

function challenger14ai(caster)
	if IsValidEntity(caster) then
		if not caster:IsAlive() then
			return false
		end
	else
		return false
	end

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	DeepPrintTable(enemies)
	if #enemies > 0 then
		local maxBound = 2
		if caster:GetHealth() < caster:GetMaxHealth()*0.6 then
			maxBound = 3
		elseif caster:GetHealth() < caster:GetMaxHealth()*0.3 then
			maxBound = 4
		end
		local nDrillSpikes = RandomInt(1,maxBound)
		for i = 1, nDrillSpikes, 1 do
			local fv = RandomVector(1)
			local drillAbility = caster:FindAbilityByName("arena_drill_spike")
			local info = 
			{
					Ability = drillAbility,
		        	EffectName = "particles/roshpit/arena/drill_spike.vpcf",
		        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,120),
		        	fDistance = 1000,
		        	fStartRadius = 160,
		        	fEndRadius = 160,
		        	Source = caster,
		        	StartPosition = "attach_hitloc",
		        	bHasFrontalCone = false,
		        	bReplaceExisting = false,
		        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        	fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = fv*Vector(1,1,0) * 900,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end
	end
	return

end

function challenger13ai(caster)
	local ability = caster:FindAbilityByName("arena_ursa_major_passive")
	if not caster.summonsUp then
		caster.summonsUp = true
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_challenger_13_immune", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arena_summoning_bears", {duration = 7.8})
	end
	local clapAbility = caster:FindAbilityByName("arena_ursa_thunder_clap")
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	if #enemies > 0 then
		local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = clapAbility:entindex(),
		 	}
		 
		ExecuteOrderFromTable(newOrder)	
	end
end

function challenger12ai(caster)
	local waveAbility = caster:FindAbilityByName("arena_challenger_12_axe_throw")
	local luck = RandomInt(1,7)
	if luck == 1 then
		if waveAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1040, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = waveAbility:entindex(),
						Position = castPoint
				 	}
				local soundChance = RandomInt(1,3)
				if soundChance == 1 then
					EmitSoundOn("Arena.Challenger12.Laugh1", caster)
				end
				ExecuteOrderFromTable(newOrder)			
			end
			return
		end
	end
	local luck = RandomInt(1,4)
	if luck == 1 then
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
end

function challenger10ai(caster)
	local waveAbility = caster:FindAbilityByName("arena_challenger_10_wraithfire")
	local luck = RandomInt(1,6)
	if luck == 1 then
		if waveAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1040, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = waveAbility:entindex(),
						Position = castPoint
				 	}
				local soundChance = RandomInt(1,3)
				if soundChance == 1 then
					EmitSoundOn("Arena.Challenger10.Growl", caster)
				end
				ExecuteOrderFromTable(newOrder)			
			end
			return
		end
	end
	local luck = RandomInt(1,7)
	if luck == 1 then
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
	if not caster.summonPhase then
		caster.summonPhase = 0
	end
	if caster:GetHealth() < caster:GetMaxHealth()*0.9 and caster.summonPhase == 0 then
		local passiveAbility = caster:FindAbilityByName("arena_challenger_10_passive")
		passiveAbility:ApplyDataDrivenModifier(caster, caster, "modifier_wraith_arena_shield", {duration = 4})
		caster.summonPhase = 1
	elseif caster:GetHealth() < caster:GetMaxHealth()*0.6 and caster.summonPhase == 1 then
		local passiveAbility = caster:FindAbilityByName("arena_challenger_10_passive")
		passiveAbility:ApplyDataDrivenModifier(caster, caster, "modifier_wraith_arena_shield", {duration = 5})
		caster.summonPhase = 2
	elseif caster:GetHealth() < caster:GetMaxHealth()*0.4 and caster.summonPhase == 2 then
		local passiveAbility = caster:FindAbilityByName("arena_challenger_10_passive")
		passiveAbility:ApplyDataDrivenModifier(caster, caster, "modifier_wraith_arena_shield", {duration = 5})
		caster.summonPhase = 3
	elseif caster:GetHealth() < caster:GetMaxHealth()*0.25 and caster.summonPhase == 3 then
		local passiveAbility = caster:FindAbilityByName("arena_challenger_10_passive")
		passiveAbility:ApplyDataDrivenModifier(caster, caster, "modifier_wraith_arena_shield", {duration = 5})
		caster.summonPhase = 4
	end
end

function challenger9ai(caster)
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval >= 40 then
	   caster.interval = 0
      local particleName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_end.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
      EmitSoundOn("Arena.Challenger9.TeleportOut", caster)
      Timers:CreateTimer(3, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.9})
		Timers:CreateTimer(0.6, function()
			EmitSoundOn("Arena.Challenger9.TeleportIn", caster)
			local arenaCenter = Vector(-2670, -2445)
			local tpLocation = arenaCenter+RandomVector(RandomInt(1,2700))
			FindClearSpaceForUnit(caster, tpLocation, false)
		      local particleName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_end.vpcf"
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
		      Timers:CreateTimer(3, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		      end)
		end)
	end
end

function challenger8ai(caster)
	local ability = caster:FindAbilityByName("arena_war_rally")
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	print(caster.interval)
	if caster.interval == 42 then
		print("AXE MODE!")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		caster.axeEnemy = enemies[1]
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_war_rally_axe_throwing", {duration = 5})
		caster.interval = 0
		return
	end
	local warcryAbility = caster:FindAbilityByName("arena_god_of_war")
	if warcryAbility:IsFullyCastable() then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = warcryAbility:entindex(),
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			return
	end
end

function challenger7ai(caster)
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		if caster.interval >= 14 then
		  caster.interval = 0
	      local particleName = "particles/econ/items/meepo/meepo_colossal_crystal_chorus/sorceress_blink.vpcf"
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
	      EmitSoundOn("Arena.Challenger7.BlinkSound", caster)
	      Timers:CreateTimer(3, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
			StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_SPAWN, rate=0.9})
			Timers:CreateTimer(0.1, function()
				EmitSoundOn("Arena.Challenger7.BlinkSound", caster)
				local tpLocation = enemies[1]:GetAbsOrigin()+RandomVector(700)
				FindClearSpaceForUnit(caster, tpLocation, false)
			      local particleName = "particles/econ/items/meepo/meepo_colossal_crystal_chorus/sorceress_blink.vpcf"
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			      ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
			      Timers:CreateTimer(3, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)
			end)
		end
	end
	local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies2 > 0 then
		if caster.channeling then
			return
		end
		local doppleWalkAbility = caster:FindAbilityByName("fire_temple_dragon_slave")
		if doppleWalkAbility:IsFullyCastable() then
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = doppleWalkAbility:entindex(),
				Position = enemies2[1]:GetAbsOrigin()+RandomVector(200)
			}
			Timers:CreateTimer(0.1, function()
				StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7})
			end)
			ExecuteOrderFromTable(order)
			caster.channeling = true
			Timers:CreateTimer(0.5, function()
				caster.channeling = false
			end)
			return
		end
		local freezeFieldAbility = caster:FindAbilityByName("arena_freezing_field")
		local soundTable = {"Arena.Challenger7.Grunt2", "Arena.Challenger7.Grunt"}
		if freezeFieldAbility:IsFullyCastable() then
			EmitSoundOn(soundTable[RandomInt(1,2)], caster)
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = freezeFieldAbility:entindex(),
			 	}

			ExecuteOrderFromTable(newOrder)	
			caster.channeling = true
			Timers:CreateTimer(1.5, function()
				caster.channeling = false
			end)
			-- StartAnimation(caster, {duration=4.0, activity=ACT_DOTA_VICTORY, rate=0.9})
		end
	end
end

function challenger6ai(caster)
	if Arena.Nightmare then
		return
	end
	local nightmareAbility = caster:FindAbilityByName("bane_nightmare")
	if nightmareAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = nightmareAbility:entindex(),
					TargetIndex = enemies[1]:entindex()
			 	}
			 
			ExecuteOrderFromTable(newOrder)		
			Timers:CreateTimer(1, function()
				if enemies[1]:IsNightmared() then
					if Arena.Nightmare then
						return
					end
					Arena.Nightmare = true
					Arena:InitArenaNightmare(caster, enemies[1], Arena.scoreR)
					print("NIGHTMARED!!")
				end
			end)	
		end
		return
	end
end

function nightmareBossAi(caster)
	local waveAbility = caster:FindAbilityByName("arena_nightmare_powershot")
	if caster:GetHealth() < caster:GetMaxHealth()*0.1 then
		local boss = Arena:SpawnChampionsLeagueEnemy("champion_league_challenger_6_battle", caster:GetAbsOrigin(), caster:GetForwardVector(), 1, 1, 0.05)
		table.insert(Arena.NightmareCaster.summonTable, boss)
		EmitGlobalSound("Arena.Challenger6.Laugh")
		boss:RemoveModifierByName("modifier_command_restric_player")
		CustomAbilities:QuickAttachParticle("particles/econ/items/bane/slumbering_terror/bane_slumber_nightmare.vpcf", boss, 3)
		UTIL_Remove(caster)
		return
	end
	local luck = RandomInt(1,7)
	if luck == 1 then
		if waveAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = waveAbility:entindex(),
						Position = castPoint
				 	}
				ExecuteOrderFromTable(newOrder)			
			end
			return
		end
	end
	local luck = RandomInt(1,7)
	if luck == 1 then
		local dodgeAbility = caster:FindAbilityByName("arena_dodge_ability")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 740, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
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
end

function nightmareBossAi2(caster)
	local waveAbility = caster:FindAbilityByName("arena_challenger_10_wraithfire")
	local luck = RandomInt(1,10)
	if luck == 1 then
		if waveAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = waveAbility:entindex(),
						Position = castPoint
				 	}
				ExecuteOrderFromTable(newOrder)		
				StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ENFEEBLE, rate=0.9})
				return	
			end
		end
	end
	local luck = RandomInt(1,5)
	if luck == 1 then
		local sapAbility = caster:FindAbilityByName("blackguard_brain_sap")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 740, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = sapAbility:entindex(),
					TargetIndex = enemies[1]:entindex()
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			return
		end
	end
end

function challenger5ai(caster)
	if caster:HasModifier("modifier_arena_challenger_5_meteors") then
		return
	end
	local luck = RandomInt(1,7)
	if luck == 1 then
		local dodgeAbility = caster:FindAbilityByName("arena_dodge_ability")
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1540, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
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
end

function challenger4ai(caster)
	local warcryAbility = caster:FindAbilityByName("arena_challenger_4_shield")
	if warcryAbility:IsFullyCastable() then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = warcryAbility:entindex(),
			 	}
			 
			ExecuteOrderFromTable(newOrder)	
			return
	end
end

function challenger3ai_a(caster)
	if not caster.bro then
	  caster.bro = CreateUnitByName("champion_league_challenger_3_b", caster:GetAbsOrigin()+RandomVector(200), true, nil, nil, DOTA_TEAM_NEUTRALS)
	  caster.bro:SetForwardVector(caster:GetForwardVector())
	  Events:AdjustDeathXP(caster.bro)
	  Events:AdjustBossPower(caster.bro, 10, 10)
	  CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", caster.bro, 2.5)
	  EmitSoundOn("Arena.Challenger3.Tone1", caster.bro)
	  caster.bro.bro = caster
	  caster.bro:SetAcquisitionRange(5000)
	  pullCrowd(true, 5)
	  caster.bro:SetRenderColor(120, 120, 255)
	end
	if not caster.bro:IsAlive() then
		ApplyDamage({ victim = caster, attacker = caster.opponent, damage = caster:GetMaxHealth()*100, damage_type = DAMAGE_TYPE_PURE })
	end
	local boltAbility = caster:FindAbilityByName("arena_challenger_3_bolt")
	if boltAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
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

function challenger2ai(caster)
	if not caster.interval then
		caster.interval = 1
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
	print("HELLO?")
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

function challenger1ai(caster)
	if Arena.scoreL == 2 then
		local ability = caster:FindAbilityByName("arena_challenger_1_passive_2")
		if not ability then
			caster:AddAbility("arena_challenger_1_passive_2"):SetLevel(3)
			EmitSoundOn("Arena.Challenger1.TauntVO", caster)
		end
	end
	local boltAbility = caster:FindAbilityByName("arena_challenger_1_illuminate")
	if boltAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = boltAbility:entindex(),
					Position = enemies[1]:GetAbsOrigin()
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
		end
		return
	end
	if Arena.scoreL > 0 then
		if not caster.interval then
			caster.interval = 1
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
	end
	if Arena.scoreL > 0 then
		local repelAbility = caster:FindAbilityByName("omniknight_repel")
		if not repelAbility then
			repelAbility = caster:AddAbility("omniknight_repel")
			repelAbility:SetLevel(1)
		end
		if repelAbility:IsFullyCastable() then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = repelAbility:entindex(),
					TargetIndex = caster:entindex()
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
			return
		end		
	end
end

function arena_dodge_ability(event)
	local caster = event.caster
	local ability = event.ability
	local enemy = ability.dodgeUnit
	if caster:GetUnitName() == "champion_league_challenger_20" then
		local moveFV = ((caster:GetAbsOrigin() - enemy:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.9})
		for i = 1, 20, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*25)
			end)
		end
		Timers:CreateTimer(0.63, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	elseif caster:GetUnitName() == "champion_league_challenger_17" then
		local moveFV = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_ATTACK_EVENT, rate=0.9})
		for i = 1, 24, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*34)
			end)
		end
		Timers:CreateTimer(0.75, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	elseif caster:GetUnitName() == "champion_league_challenger_15" or caster:GetUnitName() ==  "arena_nightmare_boss" then
		local moveFV = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.9})
		for i = 1, 24, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*20)
			end)
		end
		Timers:CreateTimer(0.75, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	elseif caster:GetUnitName() == "champion_league_challenger_12" then
		local moveFV = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_FLAIL, rate=0.9, translate="forcestaff_friendly"})
		EmitSoundOn("Arena.ForceStaff", caster)
		for i = 1, 27, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*20)
			end)
		end
		Timers:CreateTimer(0.85, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	elseif caster:GetUnitName() == "champion_league_challenger_10" then
		local moveFV = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_TELEPORT_END, rate=0.9})
		EmitSoundOn("Arena.Challenger10.Jump", caster)
		for i = 1, 22, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*20)
			end)
		end
		Timers:CreateTimer(0.7, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	elseif caster:GetUnitName() == "champion_league_challenger_5" then
		local moveFV = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_SPAWN, rate=0.8})
		EmitSoundOn("Arena.ForceStaff", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin()+RandomVector(50), "Arena.Challenger5.Grunt", caster)
		caster:AddNewModifier(nil, nil, "modifier_rooted", {duration=1.2})
		for i = 1, 40, 1 do
			Timers:CreateTimer(i*0.03, function()
				local upMotionMult = 40-(i*2)
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*17+Vector(0,0,upMotionMult))
			end)
		end
		Timers:CreateTimer(1.3, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
		Timers:CreateTimer(1.2, function()
			local radius = 400
			local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
			local position = caster:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, position )
			ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)

			EmitSoundOn("Arena.Challenger5.Quake", caster)

			local damage = 100000
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.5})		
				end
			end 
		end)
	elseif caster:GetUnitName() == "champion_league_challenger_2" then
		local moveFV = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_OVERRIDE_ABILITY_3, rate=0.8})
		EmitSoundOn("Arena.Challenger2.Growl", caster)
		caster:AddNewModifier(nil, nil, "modifier_rooted", {duration=1.2})
		local jumpDistance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), ability.dodgeUnit:GetAbsOrigin()*Vector(1,1,0)) + 120
		local jumpSpeed = jumpDistance/40
		for i = 1, 40, 1 do
			Timers:CreateTimer(i*0.03, function()
				local upMotionMult = 40-(i*2)
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*jumpSpeed+Vector(0,0,upMotionMult))
			end)
		end
		Timers:CreateTimer(1.3, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
		Timers:CreateTimer(1.2, function()

			local radius = 320
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin()+RandomVector(100), "Arena.Challenger2.JumpLand", caster)
			local position = caster:GetAbsOrigin()
      		particleName = "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf"
	      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      	ParticleManager:SetParticleControl( particle1, 0, position )
	      	Timers:CreateTimer(4, 
	     	 function()
	        	ParticleManager:DestroyParticle( particle1, false )
	      	 end)
			ScreenShake(position, 170, 2, 3, 9000, 0, true)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					EmitSoundOn("Arena.Challenger2.Growl2", caster)
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.4})		
					EmitSoundOn("Arena.Challenger2.AttackCrit", enemy)
					caster:PerformAttack(enemy, true, true, false, true, false, false, false)
					StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=2.0})
					caster.attacked = true
					CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", enemy, 4)
					pullCrowd(true, 1)
					ApplyDamage({ victim = enemy, attacker = caster, damage = 7000, damage_type = DAMAGE_TYPE_PURE })
					WallPhysics:Jump(caster, caster:GetForwardVector(), 0, 46, 14, 1.5)
					WallPhysics:Jump(enemy, caster:GetForwardVector(), 0, 46, 14, 2.5)
					Timers:CreateTimer(0.8, function()
						EmitSoundOn("Arena.Challenger2.AttackCrit", enemy)
						caster:PerformAttack(enemy, true, true, false, true, false, false, false)
						StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=2.0})
						caster.attacked = true
						CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", enemy, 4)
						pullCrowd(true, 4)
						ApplyDamage({ victim = enemy, attacker = caster, damage = 15000, damage_type = DAMAGE_TYPE_PURE })
					end)
				end
			end 
		end)
	elseif caster:GetUnitName() == "arena_descent_nightmare" then
		local moveFV = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_OVERRIDE_ABILITY_3, rate=0.8})
		EmitSoundOn("Arena.Challenger2.Growl", caster)
		caster:AddNewModifier(nil, nil, "modifier_rooted", {duration=1.2})
		local jumpDistance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), ability.dodgeUnit:GetAbsOrigin()*Vector(1,1,0)) + 120
		local jumpSpeed = jumpDistance/40
		for i = 1, 40, 1 do
			Timers:CreateTimer(i*0.03, function()
				local upMotionMult = 40-(i*2)
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*jumpSpeed+Vector(0,0,upMotionMult))
			end)
		end
		Timers:CreateTimer(1.3, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
		Timers:CreateTimer(1.2, function()

			local radius = 320
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin()+RandomVector(100), "Arena.Challenger2.JumpLand", caster)
			local position = caster:GetAbsOrigin()
      		particleName = "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf"
	      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      	ParticleManager:SetParticleControl( particle1, 0, position )
	      	Timers:CreateTimer(4, 
	     	 function()
	        	ParticleManager:DestroyParticle( particle1, false )
	      	 end)
			ScreenShake(position, 170, 2, 3, 9000, 0, true)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					EmitSoundOn("Arena.Challenger2.Growl2", caster)
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.4})		
					EmitSoundOn("Arena.Challenger2.AttackCrit", enemy)
					caster:PerformAttack(enemy, true, true, false, true, false, false, false)
					StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=2.0})
					caster.attacked = true
					CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", enemy, 4)
					ApplyDamage({ victim = enemy, attacker = caster, damage = 7000, damage_type = DAMAGE_TYPE_PURE })
					WallPhysics:Jump(caster, caster:GetForwardVector(), 0, 46, 14, 1.5)
					WallPhysics:Jump(enemy, caster:GetForwardVector(), 0, 46, 14, 2.5)
					Timers:CreateTimer(0.8, function()
						EmitSoundOn("Arena.Challenger2.AttackCrit", enemy)
						caster:PerformAttack(enemy, true, true, false, true, false, false, false)
						StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=2.0})
						caster.attacked = true
						CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", enemy, 4)
						ApplyDamage({ victim = enemy, attacker = caster, damage = 15000, damage_type = DAMAGE_TYPE_PURE })
					end)
				end
			end 
		end)
	elseif caster:GetUnitName() == "champion_league_challenger_1" then
		local moveFV = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		StartAnimation(caster, {duration=0.03*32, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.2})
		caster:AddNewModifier(nil, nil, "modifier_rooted", {duration=1.2})
		EmitSoundOn("Arena.Challenger1.Jump", caster)
		local jumpDistance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), ability.dodgeUnit:GetAbsOrigin()*Vector(1,1,0)) + 120
		local jumpSpeed = jumpDistance/32
		for i = 1, 32, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+moveFV*jumpSpeed)
			end)
		end
		Timers:CreateTimer(1.0, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end
end

function rekkin_wave_hit(event)
	local caster = event.caster
	if caster:GetUnitName() == "champion_league_challenger_20" then
		local luck = RandomInt(1,2)
		if luck == 1 then
			pullCrowd(true, 1)
		end
	end	
end

function player_arena_cast_ability(event)
	local target = event.caster
	local executedAbility = event.event_ability
	if not target.abilityExecuteTable then
		target.abilityExecuteTable = {}
	end
	if #target.abilityExecuteTable < 6 then
		table.insert(target.abilityExecuteTable, executedAbility)
	else
		local newTable = {}
		for i = 2, #target.abilityExecuteTable, 1 do
			table.insert(newTable, target.abilityExecuteTable[i])
		end
		table.insert(newTable, executedAbility)
		target.abilityExecuteTable = newTable
	end
	local frequency = 0
	for i = 1, #target.abilityExecuteTable, 1 do
		if executedAbility == target.abilityExecuteTable[i] then
			frequency = frequency + 1
		end
	end
	if frequency == 1 then
		local luck = RandomInt(1,4)
		if luck == 1 then
			pullCrowd(false, 1)
		end
	elseif frequency == 2 then
		local luck = RandomInt(1,7)
		if luck == 1 then
			pullCrowd(false, 1)
		end
	end
end

function player_deal_damage(event)
	local attacker = event.attacker
	local unit = event.unit
	local damage = math.ceil(event.attack_damage/1000)
	if not attacker.damageInstanceTable then
		attacker.damageInstanceTable = {}
	end
	if #attacker.damageInstanceTable < 20 then
		table.insert(attacker.damageInstanceTable, damage)
	else
		local newTable = {}
		for i = 2, #attacker.damageInstanceTable, 1 do
			table.insert(newTable, attacker.damageInstanceTable[i])
		end
		table.insert(newTable, damage)
		attacker.damageInstanceTable = newTable
		local avgDamage = avg_table(attacker.damageInstanceTable)
		if damage > avgDamage*10 then
			local luck = RandomInt(1,3)
			if luck == 1 then
				pullCrowd(false, 5)
			else
				pullCrowd(false, 4)
			end
		elseif damage > avgDamage*8 then
			local luck = RandomInt(1,4)
			if luck == 1 then
				pullCrowd(false, 4)
			else
				pullCrowd(false, 3)
			end
		elseif damage > avgDamage*6 then
			local luck = RandomInt(1,4)
			if luck == 1 then
				pullCrowd(false, 3)
			else
				pullCrowd(false, 2)
			end
		elseif damage > avgDamage*4 then
			local luck = RandomInt(1,5)
			if luck == 1 then
				pullCrowd(false, 3)
			else
				pullCrowd(false, 2)
			end
		elseif damage > avgDamage*2 then
			local luck = RandomInt(1,4)
			if luck == 1 then
				pullCrowd(false, 2)
			else
				pullCrowd(false, 1)
			end
		elseif damage > avgDamage*1.6 then
			local luck = RandomInt(1,4)
			if luck < 3 then
				pullCrowd(false, 1)
			end
		elseif damage > avgDamage*1.3 then
			local luck = RandomInt(1,4)
			if luck == 1 then
				pullCrowd(false, 1)
			end
		elseif damage > avgDamage*1.0 then
			local luck = RandomInt(1,6)
			if luck == 1 then
				pullCrowd(false, 1)
			end
		end
	end
end

function player_take_damage(event)
	local unit = event.unit
	local attacker = event.attacker
	local damage = event.attack_damage
	if damage > unit:GetMaxHealth()*0.5 then
		local luck = RandomInt(1,3)
		if luck == 1 then
			pullCrowd(true, 3)
		else
			pullCrowd(true, 2)
		end
	elseif damage > unit:GetMaxHealth()*0.3 then
		local luck = RandomInt(1,3)
		if luck == 1 then
			pullCrowd(true, 2)
		else
			pullCrowd(true, 1)
		end
	elseif damage > unit:GetMaxHealth()*0.15 then
		local luck = RandomInt(1,4)
		if luck < 3 then
			pullCrowd(true, 1)
		elseif luck == 3 then
			pullCrowd(true, 2)
		end
	elseif damage > unit:GetMaxHealth()*0.07 then
		local luck = RandomInt(1,3)
		if luck == 1 then
			pullCrowd(true, 1)
		elseif luck == 2 then
			pullCrowd(true, 2)
		end
	else
		local luck = RandomInt(1,4)
		if luck == 1 then
			pullCrowd(true, 1)
		end
	end
end

function avg_table(t)
    local sum = 0
    for k,v in pairs(t) do
        sum = sum + v
    end
    local avg = sum/#t
    return avg
end

function enemyPullCrowd(event)
	if Arena.BattleScene then
		local pullAmount = event.pullAmount
		pullCrowd(true, pullAmount)
	end
end

function command_restric_start(event)
	local target = event.target
	target:SetHealth(target:GetMaxHealth())
end

function phantom_strike(event)
	print(event)
	print("PHANTOM STRIKE")
	DeepPrintTable(event)
end
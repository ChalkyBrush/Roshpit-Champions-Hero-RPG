function wave_unit_die(event)
	if Serengaard.waveProgress >= 0 then
		if Serengaard.bossWave then
			if event.unit.serengaardBoss then
				Serengaard.waveProgress = Serengaard.waveProgress + 1
			end
		else
			Serengaard.waveProgress = Serengaard.waveProgress + 1
		end
		if Serengaard.InfiniteWaveCount then
			CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = "I-"..Serengaard.InfiniteWaveCount} )
		else
			CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
		end
		print("WAVE UNIT DIE")
		if Serengaard.waveProgress == Serengaard.waveMax then
			Statistics.dispatch("serengard:finish_wave", {wave = Serengaard.wave});
			Serengaard:NextWave()
			Serengaard:UpdateTowers()
			Serengaard:CachePlayers()
		end
		local maxRoll = 5
		if GameState:GetDifficultyFactor() == 1 then
			maxRoll = 4
		end
		local deathLocation = event.unit:GetAbsOrigin()
		local luck = RandomInt(1, maxRoll)
		if luck == 1 then
			RPCItems:RollItemtype(300, deathLocation, 0, 0)
		end
		local luck = RandomInt(2 + GameState:GetPlayerPremiumStatusCount(), 7200)
		if luck == 3000 then
			RPCItems:RollSwampDoctorMask(deathLocation, false)
		elseif luck == 2999 then
			RPCItems:RollRadiantRuinsLeather(deathLocation)
		elseif luck == 2998 then
			RPCItems:RollTwilightVestments(deathLocation)
		elseif luck == 2997 then
			RPCItems:RollPhoenixEmblem(deathLocation)
		elseif luck == 2996 then
			if Serengaard.InfiniteWaveCount then
				RPCItems:RollSunCrystal(deathLocation, Serengaard.InfiniteWaveCount)
			end
		elseif luck == 2995 then
			RPCItems:RollUndertakersHood(deathLocation, false)
		end
	end
end

function tower_die(event)
	local caster = event.caster
	local particleName = "particles/radiant_fx/tower_good3_destroy_lvl3.vpcf"

	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())

	-- CustomAbilities:QuickAttachParticle("particles/dire_fx/tower_bad_destroy.vpcf", caster, 4)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Serengaard.TowerDie", Events.GameMaster)

	Timers:CreateTimer(0.3, function()
		UTIL_Remove(caster)
	end)
	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function structure_moved(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster.startPosition
	if not caster:HasModifier("modifier_serengaard_structure_lock") then
		if position then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_serengaard_structure_lock", {duration = 1.5})
			caster:SetAbsOrigin(position)
		end
	end
end

function barracks_die(event)
	local caster = event.caster
	local particleName = "particles/radiant_fx/good_barracks_ranged002_destroy.vpcf"

	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())

	-- CustomAbilities:QuickAttachParticle("particles/dire_fx/tower_bad_destroy.vpcf", caster, 4)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Serengaard.TowerDie", Events.GameMaster)

	Timers:CreateTimer(0.3, function()
		UTIL_Remove(caster)
	end)
	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function tower_attack_hit(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if target:IsHero() then
	elseif target.serengaardBoss then
	else
		ApplyDamage({ victim = target, attacker = attacker, damage = target:GetMaxHealth()*0.2, damage_type = DAMAGE_TYPE_PURE })
		if target:HasModifier("modifier_serengaard_wave_unit") then
			target:MoveToTargetToAttack(attacker)
		end
	end
end

function sun_guardian_think(event)
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(-236, 322))
	if distance > 1100 then
		caster:MoveToPosition(caster:GetAbsOrigin() - (caster:GetAbsOrigin():Normalized()*600))
	end
end

function barracks_spawn(event)
	local caster = event.caster
	if not caster.knightTable then
		caster.knightTable = {}
	end
	local newTable = {}
	for i = 1, #caster.knightTable, 1 do
		if IsValidEntity(caster.knightTable[i]) then
			table.insert(newTable, caster.knightTable[i])
		end
	end
	caster.knightTable = newTable
	if #caster.knightTable < 4 then
		local knight = CreateUnitByName("serengaard_knight", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
		Events:AdjustDeathXP(knight)
		FindClearSpaceForUnit(knight, knight:GetAbsOrigin(), false)
		table.insert(caster.knightTable, knight)
		if Serengaard.wave then
			local armor = math.floor(knight:GetPhysicalArmorBaseValue()*(1.05^Serengaard.wave))
			local attackDamage = math.floor(knight:GetAttackDamage()*(1.08^Serengaard.wave))
			attackDamage = attackDamage + 600*(1.2^Serengaard.wave)
			local hp = math.floor(knight:GetMaxHealth()*(1.05^Serengaard.wave))
			hp = hp + 400*(1.1^Serengaard.wave)
			knight:SetMaxHealth(hp)
			knight:SetHealth(hp)
	   		knight:SetBaseMaxHealth(hp)

			knight:SetPhysicalArmorBaseValue(armor)
		    knight:SetBaseDamageMin(attackDamage)
		    knight:SetBaseDamageMax(attackDamage) 
		end
		Timers:CreateTimer(0.1, function()
			EmitSoundOn("Serengaard.KnightSpawn", knight)
			knight:MoveToPositionAggressive(caster.rallyPoint + RandomVector(RandomInt(120, 180)))
		end)
	end
end

function friendly_ranger_die(event)
	local caster = event.caster
	local position = caster.spawnPoint
	EmitSoundOn("Serengaard.RangerDie", caster)
	-- Timers:CreateTimer(420, function()
	-- 	local ranger = Serengaard:SpawnRanger(position)
	-- 	if Serengaard.wave then
	-- 		local armor = math.floor(ranger:GetPhysicalArmorBaseValue()*(1.05^Serengaard.wave))
			
	-- 		local attackDamage = math.floor(ranger:GetAttackDamage()*(1.07^Serengaard.wave))
	-- 		attackDamage = attackDamage + 300*(Serengaard.wave)*(1.05^Serengaard.wave)
	-- 		local hp = math.floor(ranger:GetMaxHealth()*(1.05^Serengaard.wave))
	-- 		ranger:SetMaxHealth(hp)
	-- 		ranger:SetHealth(hp)
	--    		ranger:SetBaseMaxHealth(hp)

	-- 		ranger:SetPhysicalArmorBaseValue(armor)
	-- 	    ranger:SetBaseDamageMin(attackDamage)
	-- 	    ranger:SetBaseDamageMax(attackDamage) 
	-- 	end
	-- 	CustomAbilities:QuickAttachParticle("particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_moonfall.vpcf", ranger, 2.5)
	-- end)
end

function wave_unit_take_damage(event)
	local target = event.unit
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	if not target:HasModifier("modifier_serengaard_attack_lock") then
		target:MoveToTargetToAttack(attacker)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_serengaard_attack_lock", {duration = 3})
	end
end

function ancient_die(event)
	local caster = event.caster
	local particleName = "particles/roshpit/serengaard/ancient_destient001_dest.vpcf"

	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())

	-- CustomAbilities:QuickAttachParticle("particles/dire_fx/tower_bad_destroy.vpcf", caster, 4)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Serengaard.TowerDie", Events.GameMaster)
	CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Lose"})
	Dungeons:CreateBasicCameraLock(Vector(0,0,0), 30)
	Serengaard.gameOver = true
	Timers:CreateTimer(0.3, function()
		UTIL_Remove(caster)
	end)
	Timers:CreateTimer(6, function()
		Serengaard:SubmitStats()
	end)
	Timers:CreateTimer(80, function()
		GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
	end)
end

function use_sunstone(event)
  local hero = event.caster
  local item = event.ability
  if GameState:GetDifficultyFactor() < 3 then
    EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
    return
  end

	if GameState:IsSerengaard() then
		if Serengaard.wave == 0 then
			CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
			CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.UseStone"})
			
			Serengaard.timerBlock = true
			CustomGameEventManager:Send_ServerToAllClients("enter_equinox", {} )
			Timers:CreateTimer(3, function()
				Serengaard.timerBlock = false
				Serengaard:LinewarIncomeFunction(90)
			end)
			Timers:CreateTimer(7, function()
				Serengaard.wave = 31
				for i = 1, 20, 1 do
					Timers:CreateTimer(i, function()
						Serengaard:UpdateTowers()
					end)
				end
			end)
			RPCItems:ItemUTIL_Remove(item)
	    else
	      EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
	    end
	end	
end

function serengaard_ancient_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.origPos then
		caster.origPos = caster:GetAbsOrigin()
		caster:SetHullRadius(340)
	end
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.origPos)
	if distance > 100 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_moving_back", {duration = 2})
	end
end

function serengaard_ancient_moveback(event)
	local caster = event.caster
	local ability = event.ability

	local movement = (caster.origPos - caster:GetAbsOrigin())/30
	caster:SetAbsOrigin(caster:GetAbsOrigin()+movement)
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.origPos)
	if distance < 100 then
		caster:RemoveModifierByName("modifier_ancient_moving_back")
	end
end

function enemy_near_ancient_think(event)
	local unit = event.target
	local caster = event.caster
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	local aliveHero = false
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			if enemies[i]:IsAlive() then
				aliveHero = true
			end
		end
		if aliveHero then
			unit:Stop()
			unit:MoveToTargetToAttack(enemies[1])
		else
			unit:MoveToTargetToAttack(caster)
		end
	else
		unit:MoveToTargetToAttack(caster)
	end
end
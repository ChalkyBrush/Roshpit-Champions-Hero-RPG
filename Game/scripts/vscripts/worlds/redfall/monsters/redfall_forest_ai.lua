function RedfallQuest1Trigger(trigger)
	local hero = trigger.activator
	local questGuy = Redfall.Quest1Giver
	-- if not hero.RedfallQuests.questA == -1 then
	-- 	return
	-- end
	if not questGuy.talking then
		StartAnimation(questGuy, {duration=1.0, activity=ACT_DOTA_SPAWN, rate=0.6})
		questGuy.talking = true
		Redfall:Dialogue(questGuy, {hero}, "redfall_quest_1_dialogue", 5, 5, 5, true)
		Timers:CreateTimer(5, function()
			Redfall:Dialogue(questGuy, {hero}, "redfall_quest_1_dialogue_2", 5, 5, 5, true)
		end)
		Timers:CreateTimer(10, function()
			questGuy.talking = false
		end)
	end
	--DeepPrintTable(hero.RedfallQuests)
	if hero.RedfallQuests[1].state == -1 then
		hero.RedfallQuests[1].state = 0
		Timers:CreateTimer(5, function()
			Redfall:NewQuest(hero, 1)
		end)
	end
end

function autumn_spawner_think(event)
	local caster = event.caster
	if not caster.summonTable then
		caster.summonTable = {}
		caster.totalSummons = 0
	end
	local newTable = {}
	for i = 1, #caster.summonTable, 1 do
		if IsValidEntity(caster.summonTable[i]) then
			table.insert(newTable, caster.summonTable[i])
		end
	end
	caster.summonTable = newTable
	local maxSummons = 5
	local loops = 1
	if GameState:GetDifficultyFactor() == 2 then
		maxSummons = 8
	elseif GameState:GetDifficultyFactor() == 3 then
		maxSummons = 12
		loops = 2
	end
	if #caster.summonTable > maxSummons then
		return
	end
	caster.totalSummons = caster.totalSummons + 1
	local itemRoll = 1
	if caster.totalSummons > 12 then
		itemRoll = 0
	end
	local bAggro = false
	if caster.aggro then
		bAggro = true
	end
	for i = 1, loops, 1 do
		local position = caster.summonCenter + RandomVector(RandomInt(1, 240))
		local zombie = Redfall:SpawnAutumnSpawnerUnit(position, RandomVector(1), itemRoll, bAggro)
		if caster.totalSummons > 12 then
			zombie:SetDeathXP(0)
			zombie:SetMaximumGoldBounty(0)
			zombie:SetMinimumGoldBounty(0)
		end
		EmitSoundOn("Redfall.Flower.Spawn", zombie)
		CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_spawn.vpcf", zombie, 3)
		FindClearSpaceForUnit(zombie, zombie:GetAbsOrigin(), false)
		table.insert(caster.summonTable, zombie)
	end

	
end

function redfall_summoner_take_damage(event)
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

function redfall_summon_ability(event)
	local caster = event.caster
	local ability = event.ability
	local loops = GameState:GetDifficultyFactor()*2

	for i = 1, loops, 1 do
		local spider = Redfall:SpawnRedfallTreant(caster:GetAbsOrigin()+RandomVector(RandomInt(100, 260)), caster:GetForwardVector())
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_dustcloud.vpcf", spider, 2)
		createSummonParticle(caster:GetAbsOrigin(), caster, spider)
	end
	EmitSoundOn("Redfall.ForestSummoner.Summon", caster)	
end

function createSummonParticle(position, caster, target)
	local particleName = "particles/roshpit/redfall/red_beam.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,caster:GetAbsOrigin()+Vector(0,0,200))   
    ParticleManager:SetParticleControl(pfx,1,target:GetAbsOrigin()+Vector(0,0,422))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)	
end

function ForestHouseTrigger(trigger)
	Redfall:HouseArea()
end

function ForestCliffStartTrigger(trigger)
	for j = 1, 12+(GameState:GetDifficultyFactor()*3), 1 do
		Timers:CreateTimer(j*0.4, function()
			local spawnVector = Vector(-11648, -15360+RandomInt(0, 800))
			local fv = Vector(1,0)
			local soldier = Redfall:SpawnRedfallForestMinion(spawnVector, fv, true)
			WallPhysics:Jump(soldier, fv, 15+RandomInt(0,3), 15, 29, 1)
			Timers:CreateTimer(0.1, function()
				StartAnimation(soldier, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
			end)
		    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, soldier)
		    ParticleManager:SetParticleControl(pfx,0,soldier:GetAbsOrigin()+Vector(0,0,40))
		    Timers:CreateTimer(1,
		    	function()
		      		ParticleManager:DestroyParticle( pfx, false )
				end)
		end)
	end
end

function autumn_spawner_die(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/world_destruction_fx/dire_tree004b_destruction.vpcf", caster, 4)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Redfall.AutumnSpawner.Death", caster)
	end)
	for i = 1, 140, 1 do
		Timers:CreateTimer(i*0.03, function()
			if IsValidEntity(caster) then
				caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,1.5))
			end
		end)
	end
end

function ForestMidTrigger(trigger)
	for j = 1, 6+(GameState:GetDifficultyFactor()*3), 1 do
		Timers:CreateTimer(j*0.4, function()
			local spawnVector = Vector(-11520, -10880)+Vector(1,1)*RandomInt(1,500)
			local fv = Vector(-1,1)
			local soldier = Redfall:SpawnRedfallForestMinion(spawnVector, fv, true)
			WallPhysics:Jump(soldier, fv, 15+RandomInt(0,3), 15, 29, 1)
			Timers:CreateTimer(0.1, function()
				StartAnimation(soldier, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
			end)
		    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, soldier)
		    ParticleManager:SetParticleControl(pfx,0,soldier:GetAbsOrigin()+Vector(0,0,40))
		    Timers:CreateTimer(1,
		    	function()
		      		ParticleManager:DestroyParticle( pfx, false )
				end)
		end)
	end
end

function RedfallAquaLilyTrigger()
	if not Redfall.LilyPhase then
		Redfall.LilyPhase = 0
	end
	if Redfall.LilyPhase == 0 then
		local baseVector = Vector(-11422, -8896)
		local loops = 7 + (GameState:GetDifficultyFactor()*3)
		for i = 1, loops, 1 do
			Timers:CreateTimer(i*0.75, function()
				local position = baseVector + Vector(RandomInt(1, 810), RandomInt(1, 600))
				local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
				dummy:AddAbility("ability_blue_effect"):SetLevel(1)
				dummy:SetAbsOrigin(dummy:GetAbsOrigin()+Vector(0,0,1200))
				WallPhysics:Jump(dummy, Vector(1,1), 0, 0, 0, 0.05)
				Timers:CreateTimer(10, function()
					local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
					unit:SetAbsOrigin(dummy:GetAbsOrigin())
					unit:SetAbsOrigin(unit:GetAbsOrigin()-Vector(0,0,40))
					-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
					UTIL_Remove(dummy)
				end)
			end)
		end
	end
	Redfall.LilyPhase = Redfall.LilyPhase + 1
end

function WoodDwellerTrigger()
	Redfall:WoodDwellerArea()
end

function ForestMiniBossTrigger()
	Redfall:ForestMiniBossTrigger()
end

function fury_swipes_attack( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_fury_swipes_target_datadriven"
	local damageType = ability:GetAbilityDamageType()
	local exceptionName = "put_your_exception_unit_here"
	
	-- Necessary value from KV
	local duration = ability:GetLevelSpecialValueFor( "bonus_reset_time", ability:GetLevel() - 1 )
	local damage_per_stack = ability:GetLevelSpecialValueFor( "damage_per_stack", ability:GetLevel() - 1 )
	
	-- Check if unit already have stack
	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName, ability )
		
		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack * current_stack,
			damage_type = damageType, 
			ability = ability
		}
		ApplyDamage( damage_table )
		
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, 1 )
		
		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack,
			damage_type = damageType,
			ability = ability
		}
		ApplyDamage( damage_table )
	end
end

function BackTreeTrigger()
	Redfall:BackTreeArea()
end

function JuggStatueArea()
	Redfall:JuggStatueArea()
end

function JuggStatueTrigger()
	Redfall:JuggStatueTrigger()
end

function redfall_disciple_of_maru_die(event)
	if not Redfall.DisciplesSlain then
		Redfall.DisciplesSlain = 0
	end
	Redfall.DisciplesSlain = Redfall.DisciplesSlain + 1
	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i].RedfallQuests[2].state = Redfall.DisciplesSlain
	end
	if Redfall.DisciplesSlain == 12 then
		CustomGameEventManager:Send_ServerToAllClients("newQuest", {})
		EmitSoundOnLocationWithCaster(Vector(-6916, -8042), "Redfall.JuggStatue.End", Redfall.RedfallMaster)
		for i = 1, 240, 1 do
			Timers:CreateTimer(0.03*i, function()
				Redfall.JuggStatue:SetAbsOrigin(Redfall.JuggStatue:GetAbsOrigin()-Vector(0,0,1))
			end)
		end
	end
end

function ForestStaffArea()
	Redfall:ForestStaffArea()
end

function big_tree_die(event)
	local caster = event.unit
	local position = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()

	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", caster, 2)


	CustomAbilities:QuickAttachParticle("particles/world_destruction_fx/dire_tree004b_destruction.vpcf", caster, 2)
	EmitSoundOn("Redfall.BigFlower.Death", caster)
	Timers:CreateTimer(0.5, function()
		local spawns = RandomInt(4,6)
		for i = 1, spawns, 1 do
			local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddAbility("ability_red_effect"):SetLevel(1)
			dummy:SetAbsOrigin(dummy:GetAbsOrigin()+Vector(0,0,200))
			local dummyFV = WallPhysics:rotateVector(fv, (2*math.pi/spawns)*i)
			WallPhysics:Jump(dummy, dummyFV, 5+RandomInt(1,4), 5+RandomInt(1,4), 16, 0.45)
			Timers:CreateTimer(4, function()
				local unit = Redfall:SpawnAutumnSpawnerUnit(dummy:GetAbsOrigin(), RandomVector(1), 1, true)
				CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_spawn.vpcf", unit, 3)
				UTIL_Remove(dummy)
			end)			
		end
	
	end)
	Timers:CreateTimer(2.1, function()
		UTIL_Remove(caster)
	end)
end

function BigFlowerTrigger()
	Redfall:BigFlowerTrigger()
end

function NearTreantArea()
	Redfall:NearTreantArea()
end

function redfall_roar_start(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_forest_roar_preparing", {duration = 1.6})
	EmitSoundOn("Redfall.CliffWeed.RoarUp", caster)
	StartAnimation(caster, {duration=1.6, activity=ACT_DOTA_IDLE_RARE, rate=0.8})
	local scaleIncrease = 0.02
	for i = 1, 53, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetModelScale(caster:GetModelScale() + 0.02)
		end)
	end
	Timers:CreateTimer(1.6, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_forest_roar_buff", {duration = 30})
	end)
end

function CliffSpawn()
	Redfall:CliffSpawn()
end

function redfall_roar_end(event)
	local caster = event.caster
	local ability = event.ability
	for i = 1, 53, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetModelScale(caster:GetModelScale() - 0.02)
		end)
	end
end

function otaru_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lock then
		return
	end
	if caster.state == 1 then
		local goalPosition = Vector(-5989, -14545)
		caster:MoveToPosition(goalPosition)
		local distance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), goalPosition)
		if distance < 50 then
			caster.state = 2
			caster:Stop()
			caster:SetForwardVector(Vector(0,-1))
		end
	elseif caster.state == 2 then
		caster.lock = true
		Timers:CreateTimer(2, function()
			caster.lock = false
			caster.state = 3
			caster.music = true
			caster.ritualPFX = ParticleManager:CreateParticle("particles/radiant_fx/good_barracks_ranged001_amb.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(caster.ritualPFX, 0, caster:GetAbsOrigin())
			Timers:CreateTimer(0, function()
				if caster.music then
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.Otaru.RitualMusic", Redfall.RedfallMaster)
					return 60
				end
			end)
			
		end)
	elseif caster.state == 3 then
		EndAnimation(caster)
		caster.state = 0

		caster:RemoveModifierByName("modifier_otaru_remnant")
		Timers:CreateTimer(0.3, function()
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
			Timers:CreateTimer(1.5, function()
				StartAnimation(caster, {duration=9000, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.0})
			end)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_otaru_remnant", {})
		end)
		StartSoundEvent("Redfall.Otaru.Ritual", caster)
		Timers:CreateTimer(1, function()
			EmitSoundOn("Redfall.Otaru.Ritual2", caster)
			Timers:CreateTimer(10, function()
				StopSoundEvent("Redfall.Otaru.Ritual", caster)
			end)
		end)
		
		CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/otaru_ritual_start.vpcf", caster, 5)
		local delay = 0.3
		if GameState:GetDifficultyFactor() == 2 then
			delay = 0.27
		elseif GameState:GetDifficultyFactor() == 3 then
			delay = 0.21
		end
		Timers:CreateTimer(3.5, function()
			for i = 1, 45, 1 do
				Timers:CreateTimer(delay*i, function()
					local position = Vector(-7653+RandomInt(1, 3200), -14960, Redfall.ZFLOAT)
					local ghoul = false
					if caster.altSummon == 1 then
						local luck = RandomInt(1,3)
						if luck == 1 then
							ghoul = Redfall:SpawnCliffInvaderRanged(position, Vector(0,1))
						else
							ghoul = Redfall:SpawnCliffInvader(position, Vector(0,1))
						end
					elseif caster.altSummon == 2 then
						local luck = RandomInt(1,2)
						if luck == 1 then
							ghoul = Redfall:SpawnCliffInvaderRanged(position, Vector(0,1))
						else
							ghoul = Redfall:SpawnCliffInvader(position, Vector(0,1))
						end
					else
						ghoul = Redfall:SpawnCliffInvader(position, Vector(0,1))
					end
					local angles = Vector(-90, 90, 0)
					ghoul:SetAngles(angles.x, angles.y, angles.z)
					Timers:CreateTimer(0.2, function()
				  		local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
					  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
					  	ParticleManager:SetParticleControl(pfx, 0, position-Vector(0,0,750))
						Timers:CreateTimer(2, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end)
				end)
			end
		end)
	elseif caster.state == 5 then
		local goalPosition = Vector(-5992, -14926)
		caster:MoveToPosition(goalPosition)
		local distance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), goalPosition)
		if distance < 50 then
			caster.state = 6
			caster:Stop()
			caster:SetForwardVector(Vector(0,-1))
			caster:RemoveAbility("redfall_otaru_ability")
			caster:RemoveModifierByName("modifier_otaru_think")
			caster:RemoveModifierByName("modifier_otaru_remnant")
			StartAnimation(caster, {duration=3.4, activity=ACT_DOTA_VICTORY_START, rate=1.0})
			Timers:CreateTimer(3.5, function()
				StartAnimation(caster, {duration=99999, activity=ACT_DOTA_VICTORY, rate=1.0})
			end)
		end		

	end
end

function OtaruFinalTrigger(event)
	if Redfall.Otaru then
		local units = FindUnitsInRadius( Redfall.Otaru:GetTeamNumber(), Redfall.Otaru:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if Redfall.Otaru.state == 6 then
			Redfall:Dialogue(Redfall.Otaru, units, "redfall_final_otaru_dialogue", 6, 5, -40, true)
		end
	end
end

function cliff_invader_die(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end	
	if not Redfall.InvadersKilled then
		Redfall.InvadersKilled = 0
	end
	Redfall.InvadersKilled = Redfall.InvadersKilled + 1
	if Redfall.InvadersKilled == 40 then
		Redfall.Otaru.state = 3
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[3].state = 1
		end
	elseif Redfall.InvadersKilled == 80 then
		Redfall.Otaru.altSummon = 1
		Redfall.Otaru.state = 3
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[3].state = 2
		end
	elseif Redfall.InvadersKilled == 120 then
		Redfall.Otaru.state = 3
		Redfall.Otaru.altSummon = 2
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[3].state = 3
		end
	elseif Redfall.InvadersKilled == 170 then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[3].state = 4
		end
		EmitGlobalSound("Tutorial.Quest.complete_01")
		ParticleManager:DestroyParticle(Redfall.Otaru.ritualPFX, false)
		CustomGameEventManager:Send_ServerToAllClients("newQuest", {})
		Redfall.Otaru.music = false
		Redfall.Otaru.state = 4
		EndAnimation(Redfall.Otaru)
		local units = FindUnitsInRadius( Redfall.Otaru:GetTeamNumber(), Redfall.Otaru:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		Redfall:Dialogue(Redfall.Otaru, units, "redfall_otaru_dialogue_3", 6, 5, -40, true)
		Timers:CreateTimer(2, function()
			Redfall.Otaru.state = 5
		end)
	end
end

function otaru_idle_think(event)
	local caster = event.caster
	StartAnimation(caster, {duration=4.0, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.0})
end

function OtaruTrigger(trigger)
	if not Redfall.OtaruQuestStarted then
		local hero = trigger.activator

		local portraitHero = "npc_dota_hero_ember_spirit"
		local headerText = "redfall_otaru"
		local messageText = "redfall_otaru_dialogue_one"
		local bDialogue = 1
		local bAltCondition = 0
		local altMessage = ""
		local intattr = 0
		local option1 = "redfall_otaru_dialogue_option1"
		local option2 = "redfall_otaru_dialogue_option2"

		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_npc_dialogue", {portraitHero=portraitHero, headerText=headerText, messageText = messageText, bDialogue = bDialogue, subLabel = subLabel, labelCost = labelCost, bAltCondition = bAltCondition, bAltmessage = altMessage, intattr = intattr, option1=option1, option2=option2})	
	end
end

function preserver_end(event)
	Events.PreserverXP = false
end

function redfall_dodge(event)
	local caster = event.caster
	local ability = event.ability
	--print("REDFALL DODGE!!")
	if caster:GetUnitName() == "redfall_forest_ranger" then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") then
			ability:StartCooldown(4)
			local sumVector = Vector(0,0,0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector/#enemies
			local forceDirection = ((casterOrigin-avgVector)*Vector(1,1,0)):Normalized()
			
			EmitSoundOn("Redfall.DodgeJump", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_2, rate=1, translate="ti6"}) 
			for i = 1, 22, 1 do
				Timers:CreateTimer(i*0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()+forceDirection*24)
				end)
			end
			Timers:CreateTimer(0.69, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)	
		end
	elseif caster:GetUnitName() == "redfall_red_raven" or caster:GetUnitName() == "redfall_ashara" then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") then
			ability:StartCooldown(3)
			local sumVector = Vector(0,0,0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector/#enemies
			local forceDirection = ((casterOrigin-avgVector)*Vector(1,1,0)):Normalized()
			
			EmitSoundOn("Redfall.DodgeJump", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_2, rate=1, translate="ti6"}) 
			for i = 1, 22, 1 do
				Timers:CreateTimer(i*0.03, function()
					WallPhysics:MoveWithBlocking(caster:GetAbsOrigin(), caster:GetAbsOrigin()+forceDirection*30, caster)
				end)
			end
			Timers:CreateTimer(0.69, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)	
		end
	elseif caster:GetUnitName() == "redfall_farmlands_bandit" then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") then
			ability:StartCooldown(4)
			local sumVector = Vector(0,0,0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector/#enemies
			local forceDirection = ((casterOrigin-avgVector)*Vector(1,1,0)):Normalized()
			
			EmitSoundOn("Redfall.FarmlandsBandit.Jump", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1}) 
			for i = 1, 22, 1 do
				Timers:CreateTimer(i*0.03, function()
					WallPhysics:MoveWithBlocking(caster:GetAbsOrigin(), caster:GetAbsOrigin()+forceDirection*14, caster)
				end)
			end
			Timers:CreateTimer(0.69, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)	
		end
	end
end

function forest_ranger_think(event)
	local caster = event.caster
	local jumpDetectRadius = 640
	if caster.lock then
		return
	end
	if caster.aggro then
		if caster:HasAbility("redfall_massive_arrow") then
			jumpDetectRadius = 600 + GameState:GetDifficultyFactor()*120
			local arrowAbility = caster:FindAbilityByName("redfall_massive_arrow")
			if arrowAbility:IsFullyCastable() then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
				if #enemies > 0 then
					--print("HEAVY ARROW")
					local castPoint = enemies[1]:GetAbsOrigin()
					local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							AbilityIndex = arrowAbility:entindex(),
							Position = castPoint
					 	}
					 
					ExecuteOrderFromTable(newOrder)
					caster.lock = true
					Timers:CreateTimer(2.1, function()
						caster.lock = false
					end)			
				end
			end
		end
		local ability = event.ability
		local castAbility = caster:FindAbilityByName("redfall_dodge_ability")
		if castAbility and castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, jumpDetectRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				 		AbilityIndex = castAbility:entindex(),
			 	}
				 
				ExecuteOrderFromTable(newOrder)			
			end
		end
	end
end

function forest_ranger_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local luck = RandomInt(1,4)
	if luck == 1 then
		local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)	
		ability:ApplyDataDrivenModifier(caster, target, "modifier_forest_ranger_bleed", {duration = 6})
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function forest_ranger_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Redfall then
		return
	end
	if not Redfall.ForestRangersDied then
		Redfall.ForestRangersDied = 0
	end
	Redfall.ForestRangersDied = Redfall.ForestRangersDied + 1
	print("Forest Ranger Died!")
	if Redfall.ForestRangersDied == 7 then
		 Redfall:SpawnRedRaven(Vector(-3456, -8057), Vector(0, 1, 0))
	end
end

function ForestRangerTrigger()
	Redfall:ForestRangerTrigger()
end

function LilyTrigger2()
	local baseVector = Vector(-6170, -7488)
	local loops = -3 + (GameState:GetDifficultyFactor()*6)
	for i = 1, loops, 1 do
		Timers:CreateTimer(i*0.75, function()
			local position = baseVector + Vector(RandomInt(1, 600), RandomInt(1, 950))
			local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddAbility("ability_blue_effect"):SetLevel(1)
			dummy:SetAbsOrigin(dummy:GetAbsOrigin()+Vector(0,0,1200))
			WallPhysics:Jump(dummy, Vector(1,1), 0, 0, 0, 0.05)
			Timers:CreateTimer(10, function()
				local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
				unit:SetAbsOrigin(dummy:GetAbsOrigin())
				unit:SetAbsOrigin(unit:GetAbsOrigin()-Vector(0,0,40))
				-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1}) 
				UTIL_Remove(dummy)
			end)
		end)
	end
end

function heavy_boulder_toss_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.pushVector = false
	ability.pushVelocity = 30
	ability.tossPosition = caster:GetAbsOrigin()
end

function heavy_boulder_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not ability.pushVector then
		local impactPoint = target:GetAbsOrigin()
		local pushVector = ((impactPoint - ability.tossPosition)*Vector(1,1,0)):Normalized()
		ability.pushVector = pushVector
		EmitSoundOn("Redfall.StoneAttack", target)
	end
	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin(), target)
	local fv = ability.pushVector

	if blockUnit then
		fv = 0
	end

	target:SetAbsOrigin(target:GetAbsOrigin() + fv*ability.pushVelocity)
	ability.pushVelocity = ability.pushVelocity - 1
end

function ForestStoneWatcherTrigger()
	Redfall:ForestStoneWatcherTrigger()
end

function heavy_boulder_push_end(event)
	local caster = event.target
	caster.pushVector = false
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function redfall_massive_arrow_phase(event)
	local caster = event.caster
	if caster:GetUnitName() == "redfall_farmlands_bandit" then
		StartAnimation(caster, {duration=0.87, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.2})
	elseif caster:GetUnitName() == "shipyard_skeleton_archer_boss" then
		StartAnimation(caster, {duration=0.67, activity=ACT_DOTA_ATTACK, rate=0.5})
		Timers:CreateTimer(0.7, function()
			StartAnimation(caster, {duration=0.57, activity=ACT_DOTA_ATTACK, rate=2.5})
		end)
	else
		StartAnimation(caster, {duration=0.87, activity=ACT_DOTA_ATTACK, rate=1.2})
	end
end
function redfall_massive_arrow_start(event)
	local caster = event.caster
	-- StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=1.5})
end

function WoodsmenTrigger2()
	Redfall:WoodsmenTrigger2()
end

function heart_spike_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local damagePercent = event.damage_percent
	local damage = (damagePercent/100)*target:GetMaxHealth()
	local ability = event.ability
	if target:IsHero() then
		ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
		CustomAbilities:QuickAttachParticle("particles/roshpit/heart_strike_manaburn_basher_ti_5.vpcf", target, 2)
	end
end

function ash_snake_think(event)
	local ability = event.ability
	local caster = event.caster
	if caster.aggro then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local sumVector = Vector(0,0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector/#enemies
			local runDirection = ((caster:GetAbsOrigin() - avgVector)*Vector(1,1,0)):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin()+runDirection*320)
		end
	end
end

function TopRightForestArea()
	Redfall:TopRightForestArea()
end

function ash_knight_shield_start(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.aggro then
		ability:EndCooldown()
		ability:StartCooldown(1)
		return
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ash_knight_shield", {duration = 2.63})
	StartAnimation(caster, {duration=2.63, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
	EmitSoundOn("Redfall.AshKnight.ShieldStart", caster)
	StartSoundEvent("Redfall.AshKnight.ShieldLoop", caster)
	Timers:CreateTimer(2.63, function()
		StopSoundEvent("Redfall.AshKnight.ShieldLoop", caster)
	end)
end

function ash_knight_shield_take_damage(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	Events:CreateLightningBeam(caster:GetAbsOrigin()+Vector(0,0,90), attacker:GetAbsOrigin()+Vector(0,0,90))
	EmitSoundOn("Redfall.AshKnight.ShieldStrike", attacker)
	attacker:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.5})
	local silence_duration = event.silence_duration		
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_shield_silence", {duration = silence_duration})
end

function ForestEndTrigger()
	Redfall:ForestEndTrigger()
end

function autumn_slap(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Redfall.AutumnSatyr.Slap", target)
	target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.0})	
	WallPhysics:Jump(target, Vector(1,1), 0, 25, 24, 1)
	local pfx = ParticleManager:CreateParticle( "particles/roshpit/redfall/autumn_impactknightform_iron_dragon.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 4, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(2, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	-- CustomAbilities:QuickAttachParticle(, target, 3)
end

function redfall_autumn_tornado(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Redfall.AutumnVulture.TornadoStart", caster)
	ability.liftVelocity = 20
	ability.target = target
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_autumn_tornado_lifting", {duration = 4})
end

function tornado_ability_lifting_think(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 1
	if ability.liftVelocity == 0 then
		EmitSoundOn("Redfall.AutumnVulture.TornadoLaunch", caster)
		local fv = ((ability.target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local projectileParticle = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
		local start_radius = 180
		local end_radius = 180
		local range = 1500
		local speed = 1500
		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = caster:GetAbsOrigin(),
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
	if ability.liftVelocity <= 0 then
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) <= 10 then
			caster:RemoveModifierByName("modifier_autumn_tornado_lifting")
		end
	end
end

function tornado_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	StartSoundEvent("Redfall.AutumnVulture.TornadoImpact", target)
	Timers:CreateTimer(2, function()
		StopSoundEvent("Redfall.AutumnVulture.TornadoImpact", target)
	end)
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
	if caster.animation then
		StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
	else
		StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
	end
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
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/astral_rune_b_d.vpcf"
	local damage = event.damage
	local ability = event.ability
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	EmitSoundOn("Redfall.MountainCrush", caster)
	FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
		end
	end 	
end

function RedfallTree1(trigger)
	if not Redfall.TreeTriggerThatsBroken then
		local hero = trigger.activator
		local position = hero:GetAbsOrigin()
		local tree = Entities:FindByNameNearest("VermillionTreeCorrupted", Vector(position.x, position.y, 130+Redfall.ZFLOAT), 1200)
		if tree then
			Redfall.TreeTriggerThatsBroken = true
			Redfall:CorruptedTreeInitiate(tree)
		end
	end
end

function RedfallTree2(trigger)
	RedfallTreeTrigger(trigger)
end

function RedfallTree3(trigger)
	RedfallTreeTrigger(trigger)
end

function RedfallTree4(trigger)
	RedfallTreeTrigger(trigger)
end

function RedfallTree5(trigger)
	RedfallTreeTrigger(trigger)
end

function RedfallTree6(trigger)
	RedfallTreeTrigger(trigger)
end

function RedfallTree7(trigger)
	RedfallTreeTrigger(trigger)
end

function RedfallTreeTrigger(trigger)
	local hero = trigger.activator
	local position = hero:GetAbsOrigin()
	local tree = Entities:FindByNameNearest("VermillionTreeCorrupted", Vector(position.x, position.y, 130+Redfall.ZFLOAT), 1200)
	if tree then
		Redfall:CorruptedTreeInitiate(tree)
	end
end

function cultist_entering_think(event)
	local caster = event.caster
	local ability = event.ability
	local fv = Vector(0,1)
	local treeOrigin = caster.treeOrigin

	local rotatedVector = WallPhysics:rotateVector(fv, caster.rotationIndex*2*math.pi/360)

	caster:SetAbsOrigin(treeOrigin + rotatedVector*320 + Vector(0,0,800-caster.rotationIndex*3))
	caster.rotationIndex = caster.rotationIndex + 1
end

function redfall_crimsyth_cultist_die(event)
	print("-------------------redfall_crimsyth_cultist_die-------------------")
	local unit = event.unit
	local ability = event.ability
	if not unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if unit.bossLock then
		return false
	end
	local treeDummy = unit.treeDummy
	if not treeDummy then
		return
	end
	treeDummy.cultistsSlain = treeDummy.cultistsSlain + 1
	print("Cultists slain: "..treeDummy.cultistsSlain)
	if treeDummy.boss then
		if treeDummy.cultistsSlain == 20 then
			Redfall:SpawnCanyonBossParagonTest()
		end
		return false
	end
	if treeDummy.cultistsSlain == treeDummy.cultistsTarget then
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
						local pfxA = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, unit )
						FindClearSpaceForUnit(unit, position, false)
						ParticleManager:SetParticleControl( pfxA, 0, position )
						ParticleManager:SetParticleControl( pfxA, 1, position )
						ParticleManager:SetParticleControl( pfxA, 2, Vector(0,1) )
						Timers:CreateTimer(7.5, function()
							ParticleManager:DestroyParticle(pfxA, false)
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
				end
			end)
		end
		
		if not Redfall.VermillionTrees then
			Redfall.VermillionTrees = 0
		end
		Redfall.VermillionTrees = Redfall.VermillionTrees + 1
		for i = 1, #MAIN_HERO_TABLE, 1 do
			if MAIN_HERO_TABLE[i].RedfallQuests[1].state >= 0 then
				MAIN_HERO_TABLE[i].RedfallQuests[1].state = Redfall.VermillionTrees
			else
				Redfall:NewQuest(MAIN_HERO_TABLE[i], 1)
				MAIN_HERO_TABLE[i].RedfallQuests[1].state = Redfall.VermillionTrees
			end
		end
		if Redfall.VermillionTrees == 4 then
			for i = 1, #MAIN_HERO_TABLE, 1 do
				if MAIN_HERO_TABLE[i].RedfallQuests[1].state >= 0 then
					MAIN_HERO_TABLE[i].RedfallQuests[1].state = 0
					MAIN_HERO_TABLE[i].RedfallQuests[1].goal = 1
					MAIN_HERO_TABLE[i].RedfallQuests[1].objective = "redfall_quest_1_objective_2"
					CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "newQuest", {} )
				end
			end
			Timers:CreateTimer(1.5, function()
				Redfall:SpawnCrimsythCultMaster(position+Vector(0,-100), Vector(0,-1))
			end)
		end
	end
end

function redfall_crimsyth_cultist_master_die(event)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if MAIN_HERO_TABLE[i].RedfallQuests[1].state >= 0 then
			MAIN_HERO_TABLE[i].RedfallQuests[1].state = 1
			CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "newQuest", {} )
		end
	end
	Redfall.FirstQuestBoss = true
end

function crimsith_cult_master_pull(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	--print("PULL??")
	EmitSoundOn("Redfall.CultBoss.PullAbilityEffect", target)
	CustomAbilities:QuickAttachParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_g.vpcf", caster, 3)
	local particleName = "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_crimsith_cult_pull", {duration = 1.5})
	local jumpDirection = ((caster:GetAbsOrigin()-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
	local propulsion = math.floor(distance/32)
	WallPhysics:Jump(target, jumpDirection, propulsion, 20, 36, 1.2)	
end

function ForestFinalBridge()
	Redfall:ForestFinalBridge()
end

function use_autumnleaf_firefly(event)
	local caster = event.caster
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()
	local distance = WallPhysics:GetDistance(casterOrigin*Vector(1,1,0), Vector(-15352, -8303))

	if distance < 130 then
		if not Redfall.AutumnMistCavern then
			Dungeons.respawnPoint = Vector(-15352, -8303)
			UTIL_Remove(ability)
			local particlePosition = Vector(-15352, -8303, 290+Redfall.ZFLOAT)
			local pfx = ParticleManager:CreateParticle( "particles/roshpit/redfall_indicator_allied_wind.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( pfx, 10, particlePosition )
			ParticleManager:SetParticleControl( pfx, 0, particlePosition )
			ParticleManager:SetParticleControl( pfx, 1, particlePosition )
			ParticleManager:SetParticleControl( pfx, 2, particlePosition )
			ParticleManager:SetParticleControl( pfx, 3, particlePosition )
			EmitGlobalSound("Redfall.TreeHealedMain")
			Redfall:InitializeAutumnMistCavern()
		else
			EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
		end
	else
		--print("MIN MAP EVENT")
		MinimapEvent(caster:GetTeamNumber(), caster, -15352, -8303, DOTA_MINIMAP_EVENT_BASE_UNDER_ATTACK, 4)
		EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
	end

end

function crimsith_boss_attack_start(event)
  local attacker = event.attacker
  local target = event.target
  local ability = event.ability
  local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
  
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

function redfall_unit_die(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	local unit = event.unit
	local luck = RandomInt(1, 2200 - GameState:GetPlayerPremiumStatusCount() * 100)
	if luck == 1 and Redfall.TwigDropped == false then
		Redfall.TwigDropped = true
		Redfall:DropAshTwig(event.unit:GetAbsOrigin())
	end
	if luck == 2 then
		RPCItems:RollRedfallRunners(event.unit:GetAbsOrigin())
	end
	if luck == 3 then
		RPCItems:RollFuchsiaRing(event.unit:GetAbsOrigin())
	end
end

function use_glowing_redfall_leaf(event)
	local caster = event.caster
	local ability = event.ability
	local shrinePosition = Vector(-11535, 5266)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), shrinePosition)
	if distance <= 150 then
		Redfall.AsharaPortalActive = true
		UTIL_Remove(ability)
 		  local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local radius = 350
	      local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
	      ParticleManager:SetParticleControl( particle2, 0, GetGroundPosition(shrinePosition, caster) )
	      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
	      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 40, 0) )
	      Timers:CreateTimer(1.5, 
	      function()
	        ParticleManager:DestroyParticle( particle2, false )
	      end)
	      EmitSoundOnLocationWithCaster(shrinePosition, "Redfall.ActivateAsharaPortal", Redfall.RedfallMaster)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), shrinePosition, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then	
			for i = 1, #enemies, 1 do
				enemies[i]:AddNewModifier(victim, Events:GetGameMasterAbility(), "modifier_stunned", {duration = 1})
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, enemies[i], "modifier_redfall_pushback", {duration = 0.8})
			end
		end		
		AddFOWViewer(DOTA_TEAM_GOODGUYS, shrinePosition, 200, 300, true)
		Timers:CreateTimer(1.0, function()
			Redfall.AsharaPortalActive = true
			EmitGlobalSound("ui.set_applied")
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-11535, 5266, 190+Redfall.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		end)
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[5].objective = "redfall_quest_5_objective_2"
			CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "newQuest", {} )
		end  
		Redfall:SpawnSpiritOfAshara(Vector(-10944, 14336), Vector(0, 1))
	end
end

function use_redfall_ashen_twig(event)
	local caster = event.caster
	local ability = event.ability
	local shrinePosition = Vector(-1856, -10240)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), shrinePosition)
	if distance <= 560 then
		UTIL_Remove(ability)
		EmitSoundOn("Redfall.UseTwig", caster)
		local particle = "particles/roshpit/redfall/tree_healed.vpcf"
		local pfxA = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )

		ParticleManager:SetParticleControl( pfxA, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfxA, 1, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfxA, 2, Vector(0,1) )
		Timers:CreateTimer(7.5, function()
			ParticleManager:DestroyParticle(pfxA, false)
		end)	
		Timers:CreateTimer(2, function()
			EmitSoundOnLocationWithCaster(shrinePosition, "Redfall.AshTreeShake", Redfall.RedfallMaster)
			local treeStatuePieces = Entities:FindAllByNameWithin("AshTreeStatue", Vector(-1451, -10240, 105+Redfall.ZFLOAT), 2000)
			for i = 1, 60, 1 do
				Timers:CreateTimer(0.05*i, function()
					local movement = Vector(15,15,0)
					if i%2 == 0 then
						movement = Vector(-15, -15, 0)
						ScreenShake(treeStatuePieces[1]:GetAbsOrigin(), 130, 0.9, 0.9, 9000, 0, true)
					end
					for j = 1, #treeStatuePieces, 1 do
						treeStatuePieces[j]:SetAbsOrigin(treeStatuePieces[j]:GetAbsOrigin()+movement)
						treeStatuePieces[j]:SetRenderColor(113+(i*2), 60, 60)
					end

				end)
			end
			Timers:CreateTimer(3.1, function()
				for j = 1, #treeStatuePieces, 1 do
					UTIL_Remove(treeStatuePieces[j])
				end
				local tree = Redfall:SpawnAshTreant(Vector(-1451, -10240, 109), Vector(-1,0))
				CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/boss_death_ntimage_manavoid_ti_5.vpcf", tree, 3)
				CustomAbilities:QuickAttachParticle("particles/world_destruction_fx/dire_tree004b_destruction.vpcf", tree, 4)
				Timers:CreateTimer(0.2, function()
					EmitSoundOn("Redfall.AutumnSpawner.Death", tree)
				end)
			end)
		end)	
	end
end

function ash_tree_die(event)
	if not event.caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if MAIN_HERO_TABLE[i].RedfallQuests[4].state >= 0 then
			MAIN_HERO_TABLE[i].RedfallQuests[4].state = 1
			CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "newQuest", {} )
		end
	end
end

function ash_tree_think(event)
	local caster = event.caster
	local spawns = RandomInt(4,6)
	local position = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	if not caster.spawnTicks then
		caster.spawnTicks = 0
	end
	if caster.spawnTicks > 6 then
		return false
	end
	for i = 1, spawns, 1 do
		local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
		dummy:AddAbility("ability_red_effect"):SetLevel(1)
		dummy:SetAbsOrigin(dummy:GetAbsOrigin()+Vector(0,0,200))
		local dummyFV = WallPhysics:rotateVector(fv, (2*math.pi/spawns)*i)
		WallPhysics:Jump(dummy, dummyFV, 5+RandomInt(1,4), 5+RandomInt(1,4), 16, 0.45)
		Timers:CreateTimer(4, function()
			local unit = Redfall:SpawnAshSnake(dummy:GetAbsOrigin(), RandomVector(1), true)
			CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_spawn.vpcf", unit, 3)
			UTIL_Remove(dummy)
		end)			
	end
	caster.spawnTicks = caster.spawnTicks + 1
end

function redfall_red_raven_die(event)
	print("redfall_red_raven_die triggered")
	local unit = event.unit	
	if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		print("Unit: "..unit:GetUnitName())
		print("Position: "..tostring(unit:GetAbsOrigin()))
		local position = unit:GetAbsOrigin()
		Redfall:DropEnchantedLeaf(position)
	end
end

function redfall_ashara_die(event)
	local unit = event.unit
	local position = unit:GetAbsOrigin()
	if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		EmitGlobalSound("Tutorial.Quest.complete_01")
		Timers:CreateTimer(1.5, function()
			EmitSoundOn("Redfall.Ashara.Death", unit)
		end)
		Timers:CreateTimer(4, function()
			Redfall:DefeatDungeonBoss("ashara", position)
		end)
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[5].active = 2
			MAIN_HERO_TABLE[i].RedfallQuests[5].state = 1
		end
		local luck = RandomInt(1,GameState:GetDifficultyFactor())
		if luck == 1 then
			RPCItems:RollBootsOfAshara(position)
		end
	end
end

function ashara_leap_cast(event)
	local caster = event.caster
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_flash_b_gravelmaw.vpcf", caster, 1)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
	ability.acceleration = 30
	ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
	ability.target = target
	StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7, translate="moonfall"})
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

function ashara_leap_end(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	FindClearSpaceForUnit(caster, position, false)
end

function ForestCrowStatueArea(event)
	Redfall:ForestCrowStatueArea()
end

function RedfallCrowStatue(trigger)
	local hero = trigger.activator
	if Redfall.RavenStatueActive then
		Redfall:CrowMovement(hero)
		return false
	end
	if hero:HasModifier("modifier_blessing_of_ashara") then
		Timers:CreateTimer(0.5, function()
 		  local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local radius = 450
	      local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, hero )
	      ParticleManager:SetParticleControl( particle2, 0, GetGroundPosition(Vector(-640, -9236, 401), hero) )
	      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
	      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 40, 0) )
	      Timers:CreateTimer(1.5, 
	      function()
	        ParticleManager:DestroyParticle( particle2, false )
	      end)
	    end)

		EmitSoundOnLocationWithCaster(Vector(-640, -9236, 401), "Redfall.AsharaRaven.Start", hero)
		Redfall.RavenStatueActive = true
		local particleName = "particles/dark_smoke_test.vpcf"
	    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	    ParticleManager:SetParticleControl(pfx,0,Vector(-640, -9236, 401))   
	    
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)	
		Timers:CreateTimer(3, function()
			EmitSoundOnLocationWithCaster(Vector(-640, -9236, 401), "Redfall.AsharaRaven.Activate", Redfall.RedfallMaster)
			local crow = Entities:FindByNameNearest("ForestRavenStatue", Vector(-633, -9246, 562+Redfall.ZFLOAT), 1200)
			local activeCrowPosition = crow:GetAbsOrigin()
			UTIL_Remove(crow)
			local activeCrow = Entities:FindByNameNearest("ForestRavenStatueActive", Vector(-633, -9246, -213+Redfall.ZFLOAT), 1200)
			activeCrow:SetAbsOrigin(activeCrowPosition-Vector(0,0,200))
			local spotlight = "particles/roshpit/spotlight.vpcf"
		    local pfx2 = ParticleManager:CreateParticle(spotlight, PATTACH_WORLDORIGIN, caster)
		    ParticleManager:SetParticleControl(pfx2,0,Vector(-640, -9236, 401))    
			Timers:CreateTimer(2, function()
				EmitSoundOnLocationWithCaster(Vector(-640, -9236, 401), "Redfall.TreeHealedMain", Events.GameMaster)
				Redfall:CrowMovement(hero)
			end)	
		end)

		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[5].objective = "redfall_quest_5_objective_4"
		end  
	end
end

function raven_seeking_think(event)
	local caster = event.caster
	local targetHero = caster.hero
	local ability = event.ability
	ability.velocity = math.max(ability.velocity - 0.7, 15)

	local movementVector = (targetHero:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	caster:SetAbsOrigin(caster:GetAbsOrigin()+movementVector*ability.velocity)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), targetHero:GetAbsOrigin())
	caster:SetForwardVector(movementVector)
	if distance < 90 then
		caster:RemoveModifierByName("modifier_raven_seeking_hero")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_raven_seeking_drop_point", {})
		ability:ApplyDataDrivenModifier(caster, targetHero, "modifier_raven_hero_picked_up", {})

	end
end

function raven_look_for_drop_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local targetPosition = Vector(693, -15193, 512)
	caster:MoveToPosition(targetPosition)
	local distance = WallPhysics:GetDistance(targetPosition*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
	if distance < 100 and not caster.lock then
		caster.lock = true
		caster:RemoveModifierByName("modifier_raven_seeking_drop_point")
		hero:RemoveModifierByName("modifier_raven_hero_picked_up")
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
		hero:Stop()
		hero:SetForwardVector(Vector(0,1))
		hero:RemoveModifierByName("modifier_raven_courier_active")
		local fv = caster:GetForwardVector()*Vector(1,1,0)
		for i = 1, 100, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetForwardVector(fv)
				caster:SetAbsOrigin(caster:GetAbsOrigin()+(fv*30)+Vector(0,0,15))
			end)
		end
		Timers:CreateTimer(3.5, function()
			UTIL_Remove(caster)
		end)
		local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		local radius = 450
		local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, hero )
		ParticleManager:SetParticleControl( particle2, 0, hero:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
		ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
		ParticleManager:SetParticleControl( particle2, 4, Vector(255, 40, 0) )
		Timers:CreateTimer(1.5, 
		function()
			ParticleManager:DestroyParticle( particle2, false )
		end)
	end
	if not caster.lock then
		if not caster.zDelta then
			caster.zDelta = 0
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_raven_fly_height", {})
		local zDelta = math.max(700 - GetGroundHeight(caster:GetAbsOrigin(), caster), 0)

		zDelta = math.min(caster.zDelta + 10, zDelta)

		caster.zDelta = zDelta
		caster:SetModifierStackCount("modifier_raven_fly_height", caster, zDelta)
	end
end

function held_by_raven_think(event)
	local caster = event.caster
	local target = event.target

	local zDeltaStacks = caster:GetModifierStackCount("modifier_raven_fly_height", caster)
	target:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-40+zDeltaStacks))
	target:SetForwardVector(caster:GetForwardVector())
end

function RedfallAsharaGlaiveTrigger(trigger)
	local hero = trigger.activator
	if Redfall.AsharaWaveCounter then
		return false
	end
	if hero:HasModifier("modifier_blessing_of_ashara") then
		Redfall.AsharaWaveCounter = 0

		Timers:CreateTimer(0.5, function()
 		  local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local radius = 450
	      local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, hero )
	      ParticleManager:SetParticleControl( particle2, 0, GetGroundPosition(Vector(1208, -14735, 520+Redfall.ZFLOAT), hero) )
	      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
	      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 40, 0) )
	      Timers:CreateTimer(1.5, 
	      function()
	        ParticleManager:DestroyParticle( particle2, false )
	      end)
	    end)

		EmitSoundOnLocationWithCaster(Vector(1208, -14735, 520+Redfall.ZFLOAT), "Redfall.AsharaRaven.Start", hero)

		local glaive = Entities:FindByNameNearest("AsharaGlaive", Vector(1208, -14735, 520+Redfall.ZFLOAT), 600)
		for i = 1, 120, 1 do
			Timers:CreateTimer(i*0.03, function()
				if i%12 == 0 then
					EmitSoundOnLocationWithCaster(glaive:GetAbsOrigin(), "Redfall.AsharaBlade.Spin", Redfall.RedfallMaster)
				end
				if i%75 == 0 then
					local particleName = "particles/roshpit/redfall/ashara_moonbeam_lucent_beam_impact_shared_ti_5_gold.vpcf"
					local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, hero )
					for i = 1, 8, 1 do
						ParticleManager:SetParticleControl(pfx, i, Vector(1208, -14735, 520+Redfall.ZFLOAT))
					end
					ParticleManager:SetParticleControl(pfx, 2, Vector(0,0,1000))
					for i = 3, 12, 1 do
						ParticleManager:SetParticleControl(pfx, i, Vector(1208, -14735, 520+Redfall.ZFLOAT))
					end
					EmitSoundOnLocationWithCaster(Vector(1208, -14735, 520+Redfall.ZFLOAT), "Redfall.SpiritAshara.BeamImpact", Events.GameMaster)
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end
				local spinIndex = 315 + i*15
				spinIndex = spinIndex%360
				glaive:SetAngles(0, spinIndex, -90)
				glaive:SetAbsOrigin(glaive:GetAbsOrigin()+Vector(0,0,i/10))
			end)
		end
		Timers:CreateTimer(3.8, function()
			UTIL_Remove(glaive)
		end)
		Timers:CreateTimer(2.0, function()
			Redfall.spawnPortalTable2 = {}
			local spawnPositionTable = {Vector(1244,-14176), Vector(1856, -14750), Vector(1244, -15424), Vector(513, -14750)}
			Timers:CreateTimer(2, function()
				for i = 1, #spawnPositionTable, 1 do
					local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/spawn_portal_counter.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
					ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i]+Vector(0,0,600+Redfall.ZFLOAT))
					table.insert(Redfall.spawnPortalTable2, pfx)
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
					Redfall:SpawnRedfallWaveUnit("redfall_forest_ranger", spawnPositionTable[i], 8, 33, delay, true, "modifier_ashara_wave_unit")
				end
			end)
		end)
	end
end

function ashara_wave_unit_die(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	local caster = event.caster
	Redfall.AsharaWaveCounter = Redfall.AsharaWaveCounter + 1
	--print("REDFALL WAVE UNIT DIE!!")
	local spawnPositionTable = {Vector(1244,-14176), Vector(1856, -14750), Vector(1244, -15424), Vector(513, -14750)}
	if Redfall.AsharaWaveCounter == 28 then
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1.2
			if GameState:GetDifficultyFactor() == 2 then
				delay = 1.0
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.8
			end
			if i == 2 then
				Redfall:SpawnRedfallWaveUnit("redfall_student_of_ashara", spawnPositionTable[i], 7, 33, delay, true, "modifier_ashara_wave_unit")
			elseif i == 3 then
				Redfall:SpawnRedfallWaveUnit("redfall_student_of_ashara", spawnPositionTable[i], 7, 33, delay, true, "modifier_ashara_wave_unit")
			else
				Redfall:SpawnRedfallWaveUnit("redfall_autumn_enforcer", spawnPositionTable[i], 7, 33, delay, true, "modifier_ashara_wave_unit")
			end
		end
	elseif Redfall.AsharaWaveCounter == 50 then
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1.2
			if GameState:GetDifficultyFactor() == 2 then
				delay = 1.0
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.8
			end
			if i == 2 then
				Redfall:SpawnRedfallWaveUnit("redfall_student_of_ashara", spawnPositionTable[i], 7, 33, delay, true, "modifier_ashara_wave_unit")
			elseif i == 3 then
				Redfall:SpawnRedfallWaveUnit("redfall_forest_ranger", spawnPositionTable[i], 7, 33, delay, true, "modifier_ashara_wave_unit")
			elseif i == 4 then
				Redfall:SpawnRedfallWaveUnit("redfall_autumn_enforcer", spawnPositionTable[i], 7, 33, delay, true, "modifier_ashara_wave_unit")
			else
				Redfall:SpawnRedfallWaveUnit("redfall_forest_ranger", spawnPositionTable[i], 7, 33, delay, true, "modifier_ashara_wave_unit")
			end
		end
	elseif Redfall.AsharaWaveCounter == 77 then
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1.2
			if GameState:GetDifficultyFactor() == 2 then
				delay = 1.0
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.8
			end
			if i == 2 then
				Redfall:SpawnRedfallWaveUnit("redfall_armored_crab_beast", spawnPositionTable[i], 5, 33, delay, true, "modifier_ashara_wave_unit")
			elseif i == 3 then
				Redfall:SpawnRedfallWaveUnit("redfall_autumn_mage", spawnPositionTable[i], 3, 33, delay, true, "modifier_ashara_wave_unit")
			elseif i == 4 then
				Redfall:SpawnRedfallWaveUnit("redfall_canyon_alpha_beast", spawnPositionTable[i], 3, 33, delay, true, "modifier_ashara_wave_unit")
			else
				Redfall:SpawnRedfallWaveUnit("redfall_canyon_breaker", spawnPositionTable[i], 2, 33, delay, true, "modifier_ashara_wave_unit")
			end
		end
	elseif Redfall.AsharaWaveCounter == 96 then
		Redfall:SpawnAshara(Vector(1244, -14776), Vector(0,-1))
		for i = 1, #Redfall.spawnPortalTable2, 1 do
			ParticleManager:DestroyParticle(Redfall.spawnPortalTable2[i], false)
		end
		--SPAWN BOS
	end
end

function begin_splitshot(event)
	-- Dungeons:Debug()
	-- local cheats = Convars:GetBool("developer")
	----print(cheats)
	local caster = event.caster
	local ability = event.ability
	local abilityLevel = ability:GetLevel()
	local location = caster:GetOrigin() + caster:GetForwardVector()*Vector(80,80,0)
	local forwardVector = caster:GetForwardVector()
	local damage = event.damage
	local range = event.range
	local procs = RandomInt(2,3)


	ability.damage = damage

	EmitSoundOn("Astral.AstralVolleyBig", caster)
	local projectileParticle = "particles/frostivus_herofx/drow_linear_arrow.vpcf"


	local minArrows = -4
	local maxArrows = 4
		


  for j = 0, procs, 1 do
	  Timers:CreateTimer(j*0.20,
	  function()
		for i=minArrows, maxArrows, 1 do 
			local rotatedVector = WallPhysics:rotateVector(forwardVector, math.pi/40*i)
			local arrowOrigin = caster:GetAbsOrigin() + caster:GetForwardVector()*Vector(80,80,0)
			create_shot2(ability, caster, rotatedVector, arrowOrigin)
			if j == 1 then
				StartAnimation(caster, {duration=0.20, activity=ACT_DOTA_ATTACK, rate=3.6})

				EmitSoundOn("Redfall.AstralVolleySmall", caster)
			end
		end
	 end)
  end
	
end

function create_shot2(ability, caster, fv, arrowOrigin)
	local start_radius = 60
	local end_radius = 60
	local speed = 1100
	--print(fv)
	--print(arrowOrigin)
	--print(caster:GetUnitName())
	--print(ability:GetAbilityName())
	--print("ASHARA ARROW")
		local info = 
		{
				Ability = ability,
		    	EffectName = "particles/frostivus_gameplay/astral_rune_w_3_linear_frost_arrow.vpcf",
		    	vSpawnOrigin = arrowOrigin,
		    	fDistance = 1200,
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


end

function fenrir_ghost_think(event)
	local caster = event.caster
	if caster.lock then
		return false
	end
	local distanceToTarget = WallPhysics:GetDistance(caster.targetPoint, caster:GetAbsOrigin()*Vector(1,1,0))
	caster:MoveToPosition(caster.targetPoint)
	if distanceToTarget < 150 then
		caster.targetPoint = caster.movementTable[RandomInt(1,#caster.movementTable)]
	end
	local position = caster:GetAbsOrigin()
	
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.RemnantDisappear", caster)
		
		local pfx = ParticleManager:CreateParticle( "particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, position+Vector(0,0,100) )
		caster.lock = true
		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		Timers:CreateTimer(1.0, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		  UTIL_Remove(caster)
			local pfx2 = ParticleManager:CreateParticle( "particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx2, 0, position+Vector(0,0,100) )
			Timers:CreateTimer(2.5, function() 
		  		ParticleManager:DestroyParticle( pfx2, false )
		  		
		  	end)
		end) 
		Redfall:SpawnFenrir()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[6].state = 0
			Redfall:NewQuest(MAIN_HERO_TABLE[i], 6)
		end
	end
end

function redfall_fenrir_die(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	local caster = event.caster
	local ability = event.ability
	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i].RedfallQuests[6].state = 1
		CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "newQuest", {} )
	end
end

function redfall_fenrir_think(event)
	local target = event.target
	if target.buddiesTable then
		local aggro = false
		local gottaMove = false
		for i = 1, #target.buddiesTable, 1 do
			local buddy = target.buddiesTable[i]
			if IsValidEntity(buddy) then
				if buddy.aggro then
					aggro = true
					break
				end
			end
		end
		if aggro then
			for i = 1, #target.buddiesTable, 1 do
				local buddy = target.buddiesTable[i]
				if IsValidEntity(buddy) then
					if not buddy.lock then
						buddy:Stop()
						buddy.lock = true
						buddy.aggro = true
					end
					return false
				end
			end
		end
		for i = 1, #target.buddiesTable, 1 do
			local buddy = target.buddiesTable[i]
			if IsValidEntity(buddy) then
				local distanceToTarget = WallPhysics:GetDistance(buddy.targetPoint, buddy:GetAbsOrigin()*Vector(1,1,0))
				buddy:MoveToPosition(buddy.targetPoint)
				if distanceToTarget < 150 then
					gottaMove = true
					break
				end
			end
		end
		if gottaMove then
			local targetPoint = target.buddiesTable[1].movementTable[RandomInt(1,#target.buddiesTable[1].movementTable)]
			for i = 1, #target.buddiesTable, 1 do
				local buddy = target.buddiesTable[i]
				if IsValidEntity(buddy) then
					buddy.targetPoint = targetPoint
				end
			end
		end
	else
		if target.aggro then
			if not target.lock then
				target:Stop()
				target.lock = true
			end
			return false
		end
		local distanceToTarget = WallPhysics:GetDistance(target.targetPoint, target:GetAbsOrigin()*Vector(1,1,0))
		target:MoveToPosition(target.targetPoint)
		if distanceToTarget < 150 then
			target.targetPoint = target.movementTable[RandomInt(1,#target.movementTable)]
		end
	end
end